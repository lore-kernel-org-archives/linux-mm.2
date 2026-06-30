Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B46AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A796B00C5; Tue, 30 Jun 2026 03:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB6E6B00C8; Tue, 30 Jun 2026 03:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA1E6B00C9; Tue, 30 Jun 2026 03:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 705586B00C5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:32:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2A1BA0411
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:08 +0000 (UTC)
X-FDA: 84935760336.17.69D95ED
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 39DAA140007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=t5MxdkAr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=cJxkjAUR;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804727;
	b=NMODzKQYoqDTp687xLjGcjdIx9hhK1kQ78KqSjJkvUqu2KnCnkHLgO3sheICzI0Lu1l9v/
	au+pQRdlVg8WfTBXLPCfm3jpkkmiD3lVhBdpFSHiTuAbQhRIAL5c3QqRfuplAC8tgH/Ybw
	ZHV4RGHmSjoKfK1/y69C4T7ph+c6bck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMHxE7YkKk7GdhOrMJdhPTL65ejZljPAmsiF73QwsOk=;
	b=VZVXA/8v8WY2IlMPNg979GCZAUCSYONAduq7cHq9pAseMLJwqMFZEztBry2XYRZSi9Wcjp
	NWY5VxTNg56DeIVPjMwqbKn+sYVrP0Ae298bilOjD44TfnE4s7Svt0SNDGm5DiMfSzRPiY
	8T/LjMKHAxEpk3SPNMZweLypm/H1od0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=t5MxdkAr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=cJxkjAUR;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782804725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AMHxE7YkKk7GdhOrMJdhPTL65ejZljPAmsiF73QwsOk=;
	b=t5MxdkAr0qR6zKEVOW4zSokyQYaKmTfFK76Q7VF31rw4YnQNoBzCddK+TIHd6xikymBWBz
	fnsokDjdJtr65wMCXQJO7nIiqEzwc+09zFHcTXOPCMu7Bs2fpLTQaZxqVLgDV3BedOW+SB
	1s3NkMLxf8QA8VK/sQRVDYvo3FUoRLMXAMRS4kTrG8UeKX9AB4HFnzDei1+7S8ytPPvTeI
	ptZOcQ8tcg4iAUiyHBrrYZEK3xjmEkFNRNK/KjmYntLo+9x+bEJgtCKsZgykwnfjiMTso4
	YHrDQ9HUHLRXBIy8g+4tfs1A78PPaNiTc7LFrz91dS6YPnPV5WNjIj9o80plLA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782804725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AMHxE7YkKk7GdhOrMJdhPTL65ejZljPAmsiF73QwsOk=;
	b=cJxkjAURqQzAw9/KFAhRPazr008ra2/RpOy/gqph2VcvkD6kYcBH5LDaY5PyHwpAQbxM42
	Uy6ojJM7l/ysxzAg==
Date: Tue, 30 Jun 2026 09:31:59 +0200
Subject: [PATCH v4 5/6] vdso/datastore: Allow prefaulting by mlockall()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-vdso-mlockall-v4-5-6c93708ce723@linutronix.de>
References: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
In-Reply-To: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804721; l=2120;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=p/0sBe0dK25prXvIP+rbuqZbauXCumjZnpFS8hQDCB4=;
 b=CK5rWQRlKZ50ZmCUDDA/6Le1n5kStzrypTXGtA45AiD/ONdyXh43UG2jKgGSKR0V6Y4qotKMg
 96woUFtDXCBAQaV2zvIxOYjQBfNlt313F+iDKrWnLgpPYWkpzKm3nSp
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: 39DAA140007
X-Stat-Signature: ykte5b1cggsegnkd3shj4iiq868gf5ce
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782804727-113057
X-HE-Meta: U2FsdGVkX19FmNVqlagYy4TiZd4+mec6ih6LyTaFF2mFVOsLisDvkt9WAVaDs3WNi2LD/wncrSoUck0/5UacFzrKpCU4PNWkoLKlZCM3XgWBPwc8vm59XBguozQWaBixgO+u+k5GuTLoAHhZ2aiAtOAz3HOkCNmyiXUtycQ4rqxkv8dfE+xU/zxG1T79YIIWuvmthlaccYu/U7YKx2ueDnOUfgqeTIzv8WenBqZ5h5O1y9I2S/+5KNIUk2tZKvGIURSHNOLpfKIKadaxuv0mszXtckAQBettfAA9vwtt6EJKqWWiueTlAwCyPUYqPQNzmCrxaBNzMHjCIR6n12wCyKSg62/uDOswl5nF1TJdsA9zl91RxktzcC1k5DAjBmXj4f5pYI5UVfSqzxvmkgqjRJJEX9m4kVsrxIkLGiZxZZ3JsIDZrO09rqf2C8YG/du6Cav2VFiaqAMD05rRaMSVCaYBo7tmz2oajpd24+OeB2ru+xjLIbFJ4YBtMgrLgroLyZ811he3ihJq97KDv2rabZCIJvqmkrA5KR+7xpR1dbMwbQBa/AGgkZ4ehyHQ5AUlFxGQI7iRAxEW2kKuMxD28lTwqqbX3rE7ilN6wnhlrP8621fwgm72sANvRxfRP7m8J6lvpCVILaEyaL5bJTL1q4jyTc15KjxC5rahRBlqc1NDUFznIKu0zJJgUg7/oy+l+2wN1Cy7SyT9XacbMEW9VJ3KpPpLN7Fg1xLT1aek0wCCYS0rohf04YDdSaQdFLodrAV5Eie5w6jtbqMKfeARSR3gzWfEDKDTqODjxV8Jrn84jyT/MI8wvAinw8FUtg8c66UJXTJAZ2ZofWbKn/N7V8PsZ12ksh8oLgG9AiBCBdY4X5B5nC2N+/FQX+hamwNHJsSbjGkkTdpBcCPyxWUFYJlWtrko2LCqiKLqmuKia9g4FJY93MqW6bP98Emq2i6RcRSXu88qjl99sdonMuK
 3PtL/NRZ
 BSm8+7MeQODJUr0GQigVEDE1C3QPK4yfQGfp8M0ES+2ZJEQUMGXXe8JFu0/GYQC0AFpBwrr4mpnLNCgPrMGarBMZEMrFuQe3zptoypDaiOVZwKWqDkLMzX7s0RQWPq1YD+cBVkp4edCW0tcf1MNkrewPbY/3GpwUZjqiP0u8czoEkOv5LLYYzFE/UoWcx00bOctR69S8hU5z/MshQCF2+SCH2jXYf6/kSHd7UHrGstpb2tXAL2ccOyRIF5RK/qDaPoGlMiFHElWp4awFAbSjwJWifrcprmHKgqzvKDsX0GwYENa2wJUVwtVPVaijo1FwkNV7yWbloqiCw/z+BOvzdrWmmAsHgEeC/8LPiXj2kE6R/6+LjHiDc7hWAyVUUCRMO47bX/l078/0w5QkhKc0GlmpIW8aon9xksXfyMXVFFtsLTPXcpYt8Q1MD3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While mlockall() is meant to lock page *memory*, effectively it will
also create and lock the corresponding page table entries.
Latency-sensitive applications expect not to experience any pagefaults
after calling mlockall(). However mlockall() ignores VM_IO mappings,
which is used by the generic vDSO datastore.
While the fault handler itself is very fast, going through the full
pagefault exception handling is much slower, on the order of 20us in a
test machine.

Since the memory behind the datastore mappings is always present and
accessible it is not necessary to use VM_IO for them.

The data page mapping is now also aligned with the architecture-specific
code pages. Some architecture-specific data pages, like the x86 VCLOCK
pages, continue to use VM_IO as they are not always mappable. They will
require their own special handling later when the general approach has
been agreed upon.

As a side-effect this will allow GUP on these pages and allow more ways
to access the data in them. This is fine, as all data in this mapping
is globally visible anyways. Either because it is mapped into all tasks,
or in the case of the time namespace pages, can be read from procfs.

Regular mlock() would also work, but userspace does not know the boundaries
of the vDSO.

Reported-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
---
 lib/vdso/datastore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index 0ca43965a8a9..d7ab077cd604 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -125,7 +125,7 @@ const struct vm_special_mapping vdso_vvar_mapping = {
 struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *mm, unsigned long addr)
 {
 	return _install_special_mapping(mm, addr, VDSO_NR_PAGES * PAGE_SIZE,
-					VM_READ | VM_MAYREAD | VM_IO | VM_DONTDUMP |
+					VM_READ | VM_MAYREAD | VM_DONTDUMP |
 					VM_MIXEDMAP | VM_SEALED_SYSMAP,
 					&vdso_vvar_mapping);
 }

-- 
2.55.0


