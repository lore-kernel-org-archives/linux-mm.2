Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 656D8FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3716B0098; Wed, 29 Apr 2026 14:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775366B0099; Wed, 29 Apr 2026 14:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6638C6B009B; Wed, 29 Apr 2026 14:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DADB6B0098
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A4FB1C0354
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:12 +0000 (UTC)
X-FDA: 84712407864.04.8F3DA8A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf04.hostedemail.com (Postfix) with ESMTP id E998B40014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aDa/29QV";
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ELtGz2U8zQcfEAzcXaYVPPiU48m0tlXsl7aS1r2GTOA=;
	b=w/5u7ijStCctQIm9P5PXhGAwhnG1a362XlDY8Dfl1bk0+SaKiQCakwiGbcGA5HzucNBt0D
	qenCMWuMn6F0JK/MKxfzMcRQITKU4f+v22gBiekfOy8bCre96bcVSRfR5JkJrz2eiTW2yf
	I9HfsNioTeE8owKRFSD+lvEOxwsxFAs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aDa/29QV";
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486810; a=rsa-sha256;
	cv=none;
	b=8AJlLF91Au4CSYj8m1x/D136EMgXsGyoRX3+3iWOGMhdK+vT/2PBFCPd8p0nyBU6ZJ6hMX
	VxvvDog/HWhyslCCw72Kaqohp9FU/FJLd2B4rlnRH1sMIEf0Gepe72fUiZiRFRtFGE2vO8
	ogUntUc3tqKLY8P44OJ0XOalpfmympM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777486810; x=1809022810;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=7dFDPzrIAbzJLwmxK2im4erAqAsRrcXN0YYEP3dJALk=;
  b=aDa/29QVUkJJ5krwpFUs7AcQt7hRNQQwAMyYR+pImen4XuENOiBLZkMK
   sSe57XOctSrLX2vEOg9EjAMBhoCw0GvhUhcg1prbrXD35shioGec4XoA1
   kx+dIj988bHGHbwzNDqJN1fpDQIQF0ikTrDVHArd0J5GCNcH7D0lKwPk7
   YbZjGbsqw1Ue5T8IKiaA1WgUVQZ/AIwwW7uLIfvJojmdS6R6Lz5AE9SWk
   Tx+Qt2Kjrk/F1yHWmZ6NverXXl2nV0Cp4lRpYgbsZz2K9hx79idaz5V6s
   DDoGkmNu6j6vjabhrwfLVwVhDngRTlQNU5FCJ8rQVhn2fe9W9cmvIGlRV
   g==;
X-CSE-ConnectionGUID: 2VggwVoYR5yfGBFntC+Urw==
X-CSE-MsgGUID: oAkADiuTQ9aLYf2fUTq1Rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="95990143"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="95990143"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:20:06 -0700
X-CSE-ConnectionGUID: PD/Hu5SWQpmU0LRPzM05AQ==
X-CSE-MsgGUID: xbkb5ieTSnKs2CexBURa/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="239336473"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 29 Apr 2026 11:20:06 -0700
Subject: [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast path
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Apr 2026 11:20:05 -0700
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
In-Reply-To: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
Message-Id: <20260429182005.00BF70D8@davehans-spike.ostc.intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E998B40014
X-Rspam-User: 
X-Stat-Signature: mpeyrmeryksi1uh9oqz5rsfzz967gs6t
X-HE-Tag: 1777486809-888420
X-HE-Meta: U2FsdGVkX1/mzl7skeERsBmmVdLY7yI/0LxDvpuUZtsC8oG67+wY+x6IFuCnT5J+fvr0Z00u4QG+xC0iUslIzIxeDAnHWD5B0thdR4SRqnvGXgOGPB2WFyd72aY4QA1RttBLtsXMcB3aSn/w8KYqiU4TzSdikwxr8ulQ1/qKs5G7ajldTZvWzhiya1vteZJvBI7LoRC2TWDqsqHwZv3jkR1nG0tjZHRk75Z3r0ypZYDnJm44wBMdv0eJDd1O+BsEjJK2X1u0xmIYrMeeOqObeQ3G/YTKYbxTX6DvWbEU2pZh7KfaDLG+x85KZKnNYO4+tXoTSsZP8EhayL0SemeUS/v7SaemkdL6HFuw/i55s9W2leHUk2/LZPr3KC2B5NzYpsNB86/+RcYQ5ud+l3wCJr/w+1yhjxGYwvttpHDi6RD9676qC4qcrjnFdYqOPLEykLRNZd3gmjuVeAGl607Ka1RMVoWidwncuBjo1JUC7axHrU31DsEw44hR/kPkmnw6afz8zbPO9ICutMB/TwDkRRbMY5LYlj9VMmOYAttxRrcyvZKAyQttjGx9c13/V7crJjdUHF+dzHmJzsuJUzsZQtu8wMz7XLGexK0QHuRJl/elfZAy2zxRFNTJC8lU2IwGBLJkB6kpdGbX93w3/D8yYBvgZify11Qtzi0Z0L21ng5IRoAV5azlku4qjQVrz29F7j2r6lhDkjoMz6ZJcX/6QadrnRIolLp++QChEnW9d+KuGc+flUqiTGTqmu674gPnONR7r6GYI3s2HGne4ClOsfry0nGO2Nx8rVfsdxUbe/Om5Rp35XnDgIiOO8LG0Q4oGzBVU8eB4WY/kFZ6fMxjojCSDBWoa7R9k6ZISJ4JomZ0/pdjQP0PXidrpAM2j8W/ajZyl3hJ7PDlwmj+Nkv60gSKh4TNdTVZBlQpGDVD+QHjQnklJNVRiRz0iCkaA2UlJrTBw/1OmHvkX7rYV3k
 El68HuIU
 bJhrru+ap9ea/ns2jPJlv2U3wcKIo1Y9pqWQdYohxGDNvsavtRdqedCYSCdPfH8xrsQGQ8F5AphwS4ExXCAY+gX3pfSlCapFec+SvqhSNt/lKMkNB/rWAH6E/vLWmdCMkjjD35pzk6XRqxV+NDdlfoxfcpzXOR2XJ4/j4EKTqE6VbjtjENTkVccbkqsWzi6uGviee+2JXFInkjiAsPgVTKSJg3lLmtMRCf+L9unar218IB+mrM4dvS+vnSGTjdHpALBy6KI4wwbwPDBbwzrybRBEVOV79o6SP8FO2alKlcK2HNFa2S2wVdZXUaUdOpeSstjdRdOXjSRzHLk6sM797/U8/MI8gu0u9+pAzrm9IP152toVyo+leFsfy/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

The shadow stack code needs to look at the VMA from which it is
reading a userspace "token" to ensure that the memory is shadow stack
memory. If it did not do this, it might read the token from
non-shadow-stack memory, which could result in a control flow hijack.

But that lookup requires two things:
 * Looking at a VMA, which must be locked
 * Touching userspace

That's a bit of a pain because mmap_lock can not be held while
touching userspace. So the code has to drop the lock, touch userspace,
then re-acquire the lock and check if the VMA might have changed.

The current implementation does with a combination of holding
mmap_lock and looping if the VMA might have changed. It works great.
But the lock_vma_under_rcu_wait() API is a little simpler and also
does not use mmap_lock in its fast path.

Switch to lock_vma_under_rcu_wait().

BTW, this does swap in a mmap_read_lock() for
mmap_read_lock_killable().  That obviously isn't ideal, but it's
trivially fixable with another variant of the helper. I'd apprecaite
if we could handwave that away for the moment. :)

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
---

 b/arch/x86/kernel/shstk.c |   47 ++++++++++++++++------------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

diff -puN arch/x86/kernel/shstk.c~shstk-pop-rcu arch/x86/kernel/shstk.c
--- a/arch/x86/kernel/shstk.c~shstk-pop-rcu	2026-04-29 11:18:52.425697858 -0700
+++ b/arch/x86/kernel/shstk.c	2026-04-29 11:18:52.428697973 -0700
@@ -326,8 +326,9 @@ static int shstk_push_sigframe(unsigned
 
 static int shstk_pop_sigframe(unsigned long *ssp)
 {
+	struct vm_area_struct *vma;
 	unsigned long token_addr;
-	unsigned int seq;
+	int err;
 
 	/*
 	 * It is possible for the SSP to be off the end of a shadow stack by 4
@@ -338,35 +339,21 @@ static int shstk_pop_sigframe(unsigned l
 	if (!IS_ALIGNED(*ssp, 8))
 		return -EINVAL;
 
-	do {
-		struct vm_area_struct *vma;
-		bool valid_vma;
-		int err;
-
-		if (mmap_read_lock_killable(current->mm))
-			return -EINTR;
-
-		vma = find_vma(current->mm, *ssp);
-		valid_vma = vma && (vma->vm_flags & VM_SHADOW_STACK);
-
-		/*
-		 * VMAs can change between get_shstk_data() and find_vma().
-		 * Watch for changes and ensure that 'token_addr' comes from
-		 * 'vma' by recording a seqcount.
-		 *
-		 * Ignore the return value of mmap_lock_speculate_try_begin()
-		 * because the mmap lock excludes the possibility of writers.
-		 */
-		mmap_lock_speculate_try_begin(current->mm, &seq);
-		mmap_read_unlock(current->mm);
-
-		if (!valid_vma)
-			return -EINVAL;
-
-		err = get_shstk_data(&token_addr, (unsigned long __user *)*ssp);
-		if (err)
-			return err;
-	} while (mmap_lock_speculate_retry(current->mm, seq));
+	vma = lock_vma_under_rcu_wait(current->mm, *ssp);
+	if (!vma)
+		return -EINVAL;
+
+	if (!(vma->vm_flags & VM_SHADOW_STACK)) {
+		vma_end_read(vma);
+		return -EINVAL;
+	}
+
+	err = get_shstk_data(&token_addr, (unsigned long __user *)*ssp);
+
+	vma_end_read(vma);
+
+	if (err)
+		return err;
 
 	/* Restore SSP aligned? */
 	if (unlikely(!IS_ALIGNED(token_addr, 8)))
_

