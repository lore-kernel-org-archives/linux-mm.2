Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D7CC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 10:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33BE6B008C; Mon, 24 Aug 2026 06:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4B76B0092; Mon, 24 Aug 2026 06:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB546B0095; Mon, 24 Aug 2026 06:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0D426B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:08:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46CD51A04B3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:08:33 +0000 (UTC)
X-FDA: 85135738506.16.13ECEFD
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf08.hostedemail.com (Postfix) with ESMTP id 87069160008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:08:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=N+92z3Mn;
	spf=pass (imf08.hostedemail.com: domain of chenyuan_fl@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chenyuan_fl@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787566111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0NtmON3Iinqg4NTT+CvpMz+LBDo++1meA3igasdFZAQ=;
	b=oXpY5ug4nKzbHYWTMENMHMLo6G03AhIcTvqX0P90PArS1z7S6Cmnn9pOSYI5kcorAqcuUz
	3TVWKVYmeuO8V4Ar9GgVSmFb9laqhPVQTF1GnpxnN9g+KMEV5rTSmlvlh/BwDDq8AvqrmX
	kfMIZXthNRnd+S273jb+KhekRQANssM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=N+92z3Mn;
	spf=pass (imf08.hostedemail.com: domain of chenyuan_fl@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chenyuan_fl@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787566111;
	b=A3xbqjVNpb6E64KY1ZsAGgLkVVQdDwhtitI6xmZLYLbMcYuG73IOg74/ey6EIxI15aV6RX
	uvZSTWbjvmtqUpOdV6/sVwJv7HIsRDrRB3m8pwF35ww0s6qeFTCmjQA2Laf2vppSgKcqiP
	h+jGmOygFAnUFpwLTxBHQZBr4qEauXo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=0N
	tmON3Iinqg4NTT+CvpMz+LBDo++1meA3igasdFZAQ=; b=N+92z3MniTkaYTvV4e
	67Pb3Ua4tbzpAbPwf51171tU4qRV3dk9eKtW26nPKW1a8KEd7c2NKj8aXmFAkv36
	T37wc2X4j3OpeLNTBFmk72KWX76A/oKEM14f/GJ7uGJvS0Mz9iKWYqrt+xdIZ4S+
	VzbUIOdmZX9JRTRwy60MsZtyo=
Received: from nec8-i7 (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgAXwo0RGIxqh63qLw--.59759S2;
	Mon, 24 Aug 2026 18:08:17 +0800 (CST)
From: chenyuan_fl@163.com
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: akpm@linux-foundation.org,
	shuah@kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuan Chen <chenyuan@kylinos.cn>
Subject: [PATCH] mm/bpf_memcontrol: fix signed enum bounds check bypass via negative values
Date: Mon, 24 Aug 2026 18:08:07 +0800
Message-ID: <20260824100807.1829195-1-chenyuan_fl@163.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgAXwo0RGIxqh63qLw--.59759S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zry7Xr1kur1UWF48Jw1UKFg_yoW8AF1fpF
	s3ta4rKrs7tFs5WF13KF1Uua4fZw1Iq39xCwsrJr1rZr13Ww15Xa47Kr4rAFn8KFWjqr47
	J34qqryxAw4DZa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jzKZXUUUUU=
X-Originating-IP: [120.228.140.85]
X-CM-SenderInfo: xfkh05pxdqswro6rljoofrz/xtbC5hLHhWqMGBJbBwAA3G
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 87069160008
X-Stat-Signature: fog8tp6ttsmba5w6ahigfky3a4aedw3r
X-Rspam-User: 
X-HE-Tag: 1787566110-111853
X-HE-Meta: U2FsdGVkX19IAtrWn38jxO6+9oyOzC0jUeri7qmPUbg8uKaiV5jaxLS+cpKeGCqrieHh20Otw2JTDtg7SEH9IFytMqTYEfKoLrD9O2b+x5b8xdYNcmTfzHNrl54bGsfVr9GM+pNPpXdvSnJ3Y9lrz419236Z3P9U3oJdeK/OhKD4jEfjEdE4j67PsX06R/N+7OqmlRftJfjhSCwNQpwzNKgpiJ2s8K0lYHUL2iXTbONQPKzIdvkedyKTZGhAhLYPCNuD3Via16UWJBqJDPjdB1LcnlDV34BgCD+FHUCNNlXeciUMhYeN3e50jhpe4tc794b4zkcSCwwm0irQa8PE3fAhMTRU3VjHemzt7o1Z113H9VTX7vtBwSJH+l5ooiiopBZoTVQMgqN0KpxpNGdohnhGB+2Z+87zc+Woh5WZsLWOyadcwKW0OW+NwScLrWllc4e+sxPsDKwNgi9FGB8cVqZmMvfuueLFNf4jtkPUt58G1o5eyvXGWJhpp42T9X7WDgdMBSiKVvxnM28BWaEvcrICeEE1kAkqpaYnikDrPxm+oG0rL8ERtnEvsjlWlLgEWukjm3MlfSOr6jiTveq+LWv4uMR+Vxg8maOmAIk8JthdEts3qR05cefFKnVDrfEqHV+URoX7TMYU14lGa8I1dJOo5ROCDrWDMCrEBduerYY+KZBmcgFrM9iML1G4NiLfzI3esQuPuTpS3PYKGJ96a0+V3Wlb9Y7rmu0dec4G0h8sV/xwM6CY1j3b5Z7iBZcI7d4WDSrSbM+oixcq5f0iRL1eTqivd0/OIQ3zkkAVr0IuBgFwxi61WT8fu7aD4P31O7Hp5nmv0OIczH2DM8P6Z2y1+PEgoit90gjX8c0RZmFuuOzlvm+nncWN34LGnV0F4vj7doVoOk2ITHokr4qUrCy26Ph9/7U4o+Bh4kr6i6fz+GJAvs7iXGWDJXQAQ8tnDjHzd3IkoaleuH28XAz
 XncAB3sQ
 QlFAjoGeuYbK9eCUsjh84SYVr8MavMKqf32Usj1iCCr/xIa4ZbEJsx590yN+rVIXYA/gicsHAYVb51TssouLA8JrPnlzpHytXogUqHIVyCIqt0wtFmsQsZw3ADDX/i4/byplKNH8PCb+MfEy4jZCGuY3S3E7R9TfBzcYeYHNkE/azeqq1KCoDBIu0AVOgaQvI0yFsZwLjwnZnohpjruM/hB8w9DHI7dn8cuDA728eoru0uw+P1UNRb9hbcOYh3NlG4lvxGD+X3pKdK6/YhriGfOHd773HmqleUdHsJ581a97e8/i5F001M5ivZCzBP7HNmjIwptlODHNXeJ5DOCwMzoyRlmaq9nUHU2wteN/0hg7R2WvaiHJ990ry3yMWSE9D3UVFhqVCJqhLq6/fvUT4Ai3/pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yuan Chen <chenyuan@kylinos.cn>

bpf_mem_cgroup_memory_events() and memcg_vm_event_item_valid() use signed
>= comparisons on enum-typed arguments, so a BPF program passing a
negative value evades the upper-bound check and is then used as a
negative array index, causing out-of-bounds reads.

Cast the input to u32 before the comparison, matching the pattern
already used in memcg_stat_item_valid().

Fixes: 99430ab8b804c26b ("mm: introduce BPF kfuncs to access memcg statistics and events")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
---
 mm/bpf_memcontrol.c | 2 +-
 mm/memcontrol.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..5e8107f240ba 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -125,7 +125,7 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
 __bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
 						       enum memcg_memory_event event)
 {
-	if (unlikely(event >= MEMCG_NR_MEMORY_EVENTS))
+	if (unlikely((u32)event >= MEMCG_NR_MEMORY_EVENTS))
 		return (unsigned long)-1;
 
 	return atomic_long_read(&memcg->memory_events[event]);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..42a1b855bb75 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1058,7 +1058,7 @@ unsigned long memcg_events(struct mem_cgroup *memcg, int event)
 
 bool memcg_vm_event_item_valid(enum vm_event_item idx)
 {
-	if (idx >= NR_VM_EVENT_ITEMS)
+	if ((u32)idx >= NR_VM_EVENT_ITEMS)
 		return false;
 
 	return !BAD_STAT_IDX(memcg_events_index(idx));
-- 
2.54.0


