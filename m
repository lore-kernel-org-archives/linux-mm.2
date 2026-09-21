Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0D2C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2216B00A4; Mon, 21 Sep 2026 17:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3834F6B00A5; Mon, 21 Sep 2026 17:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272086B00A6; Mon, 21 Sep 2026 17:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB7146B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:55:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A022802DB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:55:15 +0000 (UTC)
X-FDA: 85239125790.07.0B0CF2D
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7E3E7100002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:55:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UNj1BryT;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790027713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=18O+tTI1rRDvA6n53KVT0ktfEAZ7emgcAQWAHdf7HXA=;
	b=jv3/kblNXVZwMufxHjbGiC0fCqzsVRMG2/dImKshPo/QitDtrTPd+TXa+eq8YBUG99sjls
	c1SDiMiHnll0hbD3k3GQAeuOmeFSd0B4LP3e26gV7ek32G5SlgMKm6BAS465fMur4eizVg
	xyp7JzzKBuFeVrXQkJKUtpPT5MZ6irs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UNj1BryT;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790027713;
	b=JeNGAEAYrA7pKUvZbIrBjq2lJGxUm6Jg3sD+fzK4agVgg2yK8PWVsqYe5YvlK1susfQ7G2
	LFGkBDCxxi9fyZbUl/jzQ2f8WwnJp981wRKebRJfHi10e8IOdb7L0fBz+fBROhhp1agqyX
	03huLWAIQ9Wfi7vxtPtVSigrgn93CgQ=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48586861639so178283f8f.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790027712; x=1790632512; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=18O+tTI1rRDvA6n53KVT0ktfEAZ7emgcAQWAHdf7HXA=;
        b=UNj1BryTgG1IYkUHayRvz/7wfz9HbBhNoojcBQJYV2/O9PUJelU3AP9swtwyNbfLyS
         VdKfHYs1jQOYdYlpMiXO/t2Qy86z61Fqiftmd6nqxE1GPN2GvwUxz5wz2XyCdpuLNuZy
         VDG3nCag1bUR5IDJDwhgmLYM9hsGGT3UEJZoFpsxTp52X8cxWcilBowD8NHiLoeyF6vB
         49BteiceNPdYeXS9lqQY43pECJrdefwGrB4YobE++HhDgXEMLt7nNBeN0hr5CjTq3Mhj
         m6TSsFS48MLWfe25q+87Tn3SWmnZH2JfAltPtVSZWyN1b70m35ITTUrcmQp0l39Y8zTN
         obLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790027712; x=1790632512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=18O+tTI1rRDvA6n53KVT0ktfEAZ7emgcAQWAHdf7HXA=;
        b=zEC+bQrEHxQ9KwQOYstw+c+tqCZcIhbgP3QX+4CkOBHLJF44LtC7gtn5FLDQpcn5Bn
         OMh1VYmwfoBblSCh13vRunPUk/753mmrWq8MTfgoibAY3+HyjvRrJqwOrcSiedXh4SzG
         dvp+5M6gmxlPzSjH4L2yV/6OmIbkXr2osnrmZyg8lZMPVKwIfGVavnVDVF1mPEIHcgKj
         5oCJ4epnmPrZLhcpnE3fNxYs93eIciSaIt1wnfnMKT8wYR1d1IWRmx2Rlq3VGea7z2p9
         S/+6isRZchSdtCJzTzxBe3AFlYB39v+A6013jViOqwhX60IvTxshPQFBdu7FvP/XQ+ec
         TKRQ==
X-Forwarded-Encrypted: i=1; AKwUvBzzwSaejq6l8wpjz3i7StEqUqpsMjVDc3QjP9vQU8XThOs0RsFm2Usj3MviduYI5yMRO6uj+MT4+A==@kvack.org
X-Gm-Message-State: AFuF++k7Fmc5TamFcnQCOT98eVDJaSX+Y+cR5ceUKSdffcoOy2sqCEcP
	bLDDRrsmFkIQEW90/5xUAj98xRZA/d8wvTURPLZgzt/SLXpGqcHxAdJx
X-Gm-Gg: AYBFou34cwY6bqhenvuEmVfs/h2TAszgfPIsg2EPJatkKbAEjOznd0kj//rZpTQ8C5h
	sUbs1KzD2ACPDXcp4/fwXwNeBFTJHUKJe7Zm8/NhheXiQdli+RmNIOKNfAKS0mzKnUTrCcLIavK
	SHZywXAYZQXcK7tGxDFQHuK3rmZfZZkFVQnF98p3MwkLOTP35jn8IZVcDXOeprhhch/JkHYO6bQ
	Su7y5RB7+R+3tInviWApXV63UG+TyDiKhlIXsU8EbZqQw4g4D8WO4QI07NjEJrGwRc3i/i3D23g
	bqGCqH0NpXHEHKT/7/ZDbXSCs3VFAsbW/JTkvPi5zmkAz9MSZXogWAvME/+JCPjKUSJLqsfEFPD
	3e8Kqlur/5skvq6sewJDH4LgcUPd/mpAZVzaiLaAPIAIRQS3ZkhyNHpfYCCgbjVgSkzHmFXxOMH
	1lKRJoIxCg2CdJawwqgsFOgs3H4HBGAncIKeQ94MLmeh8btQxksi4qTJs=
X-Received: by 2002:a05:6000:2309:b0:485:a517:6287 with SMTP id ffacd0b85a97d-48860fd75d6mr1502937f8f.17.1790027711846;
        Mon, 21 Sep 2026 14:55:11 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886228be7fsm442767f8f.37.2026.09.21.14.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:55:11 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	syzbot+a3c71b9db9c11c270f59@syzkaller.appspotmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] percpu_counter: annotate lockless read in _limited_add()
Date: Mon, 21 Sep 2026 23:55:04 +0200
Message-ID: <20260921215508.141641-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bdu64gq4ec5dbjagamnu965r8u1ck1w7
X-Rspamd-Queue-Id: 7E3E7100002
X-Rspamd-Server: rspam07
X-HE-Tag: 1790027713-198008
X-HE-Meta: U2FsdGVkX19MyyEeMaRfl1bXNX1Ht/1SCNkPAC5V+EUcbnFewqRh4lvL81jsYfdXqOTQfyOUAYoc1PBE8H9m4MKEAvsSlypJf/db5KQ0eHVzMdWe2J99wqn64IhhTInjVETprU/XnIIoA5dOCCxvjdapXhMYhfn1NVpbLWPti5T/+NRNz1RgvrWIhsR+Y6kbTUoYUv6eIcp0jie1V0FTNGnvG1V2Radm4sBgEL4qhVy4zhM//MQmao2PYg82/hA2tZG2M5SDWoqWR/s79n1dDg2HKqWZda9eKubSWxbjaQ6v7dF393qdc78bbOpuUXaNt9Jbc8Lvpb4TYs0su7iiRGQOjYioeSHi8iiB++ydLngNAoXykCMWgtLtBy7XrCNdfNYDnzlXYk3iGuKEOveBm0r7KubOrmySh718OvIYfpr4SqFRnttuTFEh47njNCeG4bk96t4HfvSUol3w/30eQwVLyj74wI9YuKNoFaB6t+xpdfGiU8KN6vtxYUupG+go/RrLt3ghpu72DI+Sq2tCw4hRXQq5/w1Y+HZE7Ew4sNV3SgjGTr+bF5hCjk18mXO6x0eaQnm3w9L3q61vR8677PmIut7z/rhOC1N9Vdvo16FHPRepK6rhsT2hxf7+ABLr8mXWk27OdYrTUWgxkh2Mrl732VdU9RQOrmFseMrY9eVVHLhLxg2pj40yaORFxm+ABqSoGd5JgxyTxVaMGNkthndCTt8OgjseYNfUxwkRIeAiwtzMSna6i4bk8S8pWnI3Seh+l37v55Md3BGpn6Suc0/fS8akG2fOEjodzI/rbydulCu45y5ktTQGL7kU7gzH+PYc+14sefk9d44tv2MqwwtuocBv0rPpLJajCDht268obmMyw/5wTZ/vB8uStZXAWbs2lnuNkIAmtjt3MM4EFsNUOgMfStx51vcHLFgeFAzcT0aBsapLVCrIDbBSxG60l2OwHYUSpWww0KZAjqm
 1xSlRgiH
 NFERhLJjvIGjxPps54VyOd0gZrf3TcIXecK0uafCWhItR+g4RomfMT8c7g9AXpy+5JC2Z/NZPJapNdtn2eChrZ3Vd/npdnjlt426iyNKVzveqXq1RAQnPeZFPBAYqvDtZAm6JrOruH7khl+ndrQA3lvaGi4MU7RStV+HQyuyc9MvLFg29ZV9RhSs6HXpPK3BggjiScOIgIcIBrK0LHvS8iVReH51CePLE0d9CRtQYW91DAAKGXBNagPA/GDNbWyKLjy12KiiZfeW6fsAB0ieuL2g1NeMeInmATxnTaW/tL3V58l54uA1DcG1Op5SPNwZmlEh23lh2SLkDfS97i/2rt4L9dcT7bAAB9gWjjAq8saEXchhJ/gJSMxW0ytxqYP87MqmokmR4FBTz28MkMVaTYylPfW1Y/xVjdSRuVTqAHvGRb6HV3xH7ksLwkJXy8UHrXhxgLe5J6V0+8rR4jsvlNs80ssjgd85/BahVczLZNvistbRK+TK2Oz/OWjtCETlAK13uWJWmqNjLUmRghLqDHjvR7oaWbFLYg2U7GUuWQ5LfPWAt6RcnxhHekugYtYj7JcEK422Vwkvbt0HybElT167HFd4rhQiojxKlFN87J3uhVnMT8mUAwCqJPX6f6o50NWjzvj3L2IpM8EMbBCT6dYd9/Auf4MnOoljvxq92O+lxn0/v6EmMtgr/DMcKBRpoPsoZ3+/q1obSmsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reports a data race on fbc->count between the lockless read in
the fast path of __percpu_counter_limited_add() and the locked update
in percpu_counter_add_batch(), reached via shmem's used_blocks counter:
the alloc path reads it through percpu_counter_limited_add() while the
free path updates it through percpu_counter_sub().

Annotate the read rather than change the logic: the lockless read is
deliberate, only the annotation is missing. It is an approximation,
not a conservative bound. A concurrent flush moves value between
fbc->count and a per-cpu counter, and other CPUs' locked slow paths add
to fbc->count too, so a stale low value can let the fast path proceed
where the slow path would refuse. The error is bounded by the per-cpu
slack (unknown = batch * num_online_cpus()). This is existing behavior,
no functional change intended.

Read it with data_race(READ_ONCE(fbc->count)): data_race() tells KCSAN
the race is intended (READ_ONCE() alone still triggers the report,
because KCSAN reports against watchpoints set up by plain accesses),
while READ_ONCE() stops the compiler from refetching the value, as in
percpu_counter_read_positive(). The lock-protected accesses stay plain,
so future buggy lockless writes are still caught.

Reported-by: syzbot+a3c71b9db9c11c270f59@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a3c71b9db9c11c270f59
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Tested with a KCSAN kernel: defconfig + CONFIG_KCSAN=y, CONFIG_KASAN=n,
CONFIG_KCSAN_SKIP_WATCH=200, CONFIG_KCSAN_UDELAY_TASK=200, KCSAN left off
at boot and enabled from init via debugfs; 8 vCPU / 4G QEMU/KVM guest,
gcc 16.2.1.  Stress: 120 s of concurrent write() and unlink()/ftruncate()
on one size-limited tmpfs (shmem_inode_acct_blocks vs
shmem_inode_unacct_blocks), which is the pair from the report.

	base/mm-new:  38x "BUG: KCSAN: data-race in __percpu_counter_limited_add
		/ percpu_counter_add_batch", first hit ~0.3 s after the
		workers started
	this commit:  0 percpu_counter reports in the same 120 s
		(other, unrelated KCSAN reports remain: d_make_discardable,
		osq_lock)

Object code (defconfig, CONFIG_KCSAN=n): __percpu_counter_limited_add() is
the same size (0x23b) with the same four fbc->count loads and identical
branch targets; .text differs only in register allocation and compare
operand order (45 of 2171 bytes).  No functional change intended.

 lib/percpu_counter.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 2891f94a11c6..87b261b87b0b 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -328,6 +328,7 @@ bool __percpu_counter_limited_add(struct percpu_counter *fbc,
 				  s64 limit, s64 amount, s32 batch)
 {
 	s64 count;
+	s64 gcount;
 	s64 unknown;
 	unsigned long flags;
 	bool good = false;
@@ -338,11 +339,16 @@ bool __percpu_counter_limited_add(struct percpu_counter *fbc,
 	local_irq_save(flags);
 	unknown = batch * num_online_cpus();
 	count = __this_cpu_read(*fbc->counters);
+	/*
+	 * Lockless on purpose: gcount may be stale, so this is only an
+	 * approximation, bounded by the per-cpu slack ("unknown").
+	 */
+	gcount = data_race(READ_ONCE(fbc->count));

 	/* Skip taking the lock when safe */
 	if (abs(count + amount) <= batch &&
-	    ((amount > 0 && fbc->count + unknown <= limit) ||
-	     (amount < 0 && fbc->count - unknown >= limit))) {
+	    ((amount > 0 && gcount + unknown <= limit) ||
+	     (amount < 0 && gcount - unknown >= limit))) {
 		this_cpu_add(*fbc->counters, amount);
 		local_irq_restore(flags);
 		return true;
--
2.55.0


