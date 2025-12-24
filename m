Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15628E75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 10:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788286B008A; Wed, 24 Dec 2025 05:43:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7368E6B008C; Wed, 24 Dec 2025 05:43:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634C66B0092; Wed, 24 Dec 2025 05:43:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 514EB6B008A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:43:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2F49C108B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:43:38 +0000 (UTC)
X-FDA: 84254028516.12.42B6CA1
Received: from mail-qk1-f225.google.com (mail-qk1-f225.google.com [209.85.222.225])
	by imf06.hostedemail.com (Postfix) with ESMTP id 919A7180006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:43:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=iFlBKWRO;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf06.hostedemail.com: domain of ajay.kaher@broadcom.com designates 209.85.222.225 as permitted sender) smtp.mailfrom=ajay.kaher@broadcom.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766573016; a=rsa-sha256;
	cv=none;
	b=RF9PoDqsIkb+MlbQiW3rP7Hs9HiP1Dm33qEQ3yOyuFLLhHIEg1FxQdlw8gJeKf1j/wI9uL
	RItxLVmpogyTj9SfFTWjmsJ35x3akB0O0b/MNoVdn6VnVRXvzEizWNH++paOgAlpaemko5
	74npzLbKI98X5Uf/xGFvlfhCexR3wKQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=iFlBKWRO;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf06.hostedemail.com: domain of ajay.kaher@broadcom.com designates 209.85.222.225 as permitted sender) smtp.mailfrom=ajay.kaher@broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766573016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qs1L9yogvjoOS4UWjYKVRJa3NcwdJKzh6wcPXeXPOP0=;
	b=xsmxMXAL83mp4JW1yAx+9hFwtGyTT38K711Ww1mq6IKA6v45p20G5DNzjikms98C1cvL/x
	tQTf4XjmLqys8f/leo7wDvY8l7CSyxL+JNst6Z++xZG4oL5whV9m1jtelGkZJKvnlA9fxb
	6MHw/DoSUqfcc3alVb8ZpeI1DFKOGcw=
Received: by mail-qk1-f225.google.com with SMTP id af79cd13be357-8b220ddc189so764603685a.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:43:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766573016; x=1767177816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qs1L9yogvjoOS4UWjYKVRJa3NcwdJKzh6wcPXeXPOP0=;
        b=l0LP7gOsZpaAhPCCvRj9PEcjC2AUa6yl9cTfMOUs0fH2vSHdk7GtgbjDqga45UM1QB
         myPp9RQtlCqn4+bC21gji0YIryY0bhpNMpkwc/QifWWIwbiAX3eliQRg9gVJBb/tvGp7
         b9RzYjhio7GPyEnz80KB4vFtotWT+1jcsWnwtPqRapcmv2IYTBYtnGjfZK6y/3dg2wKL
         JjTq25RAYHwIQf/kugOinbmOxHxjHmKMoEFuUw5OI0mF5tcR0TcERJ5CpbhkF6gLH3X9
         XsC+hnkq4obYFWz99d3h6Pa+mbBr/WVgnd1maw0jBE5J+bcAT7tMP0bu3skKSbwYMaYi
         G5lQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtM9KwjKLVawvnF6hUJNpyuit8BRpJCgzPeEmvB2sgkNJ8WpS+R8xYEJmi9KTBchRlOVWI8Go/+g==@kvack.org
X-Gm-Message-State: AOJu0YwrNwN09ZttW6tvWDrvDlW8/B+EiTHC+paTYjOIzHRW6Vn9e242
	9n+ZVGLc6Z80LkfeovAY1V5OOWsc4lWml2nDZQF0OJhDUhJYjzP50iSJQWRYB2cGRM7NYkXWson
	fFd0yETE0jsqO4lD2thvy8hf5RxFKZsdbSLxcziV55qKuLl73nAJWyGxgVD+OqmdnCIZSOrl5eA
	obb/v5+8PPvKJQV/lJfMMscJ9KlXVY5b+myByu18LGCCotKOz6bAbmvKrtuf6HFw4PvcMhBN6r0
	t0Uuw==
X-Gm-Gg: AY/fxX623pPof74YG1MrIcfUUNhICwr4cmWKG+/US7bn/8LWif58w+ZeoqjcODvTFBS
	TN2HIeaIvyxzryLrH2HE4K0xI5bn84vcKeSD8DbeiCiFN/NhR5rfSxumJub6EBYZi2dZFexUnHq
	rza2LSl5oVHmlSQtd61cAFEJVfaeAj2QNBxRiyDEWG1L4mpx2J8I2+cMRv6P2Guu7iIHRi86Ews
	Hs0tRvtMKYS+2fVun1lI919+4r/NkcfpqSrJFVo6fFOmjAaLkQGC1MUYn+M1ze/GG/FMhPGPgh1
	0jSe/wxrwy+qgpb0AI2ZOL8/k8Sou4PH8Z/RZ74yD1oUrzl5GbQgzyzxCuU3gEC/Yy8WP2yFmcG
	KcpXNI6MB1fGWxmoK3frb1W3MRSf6c15nobyIAIcaniobsTlmtR6eNpixWL5FWX+wNA7HFz1GJc
	4HXaQ6BqND7Cm+NqMJqbJl0qpQcjgcoGpo+je86HDo7Q==
X-Google-Smtp-Source: AGHT+IEtLW8ctn2R1qY03UrBdIw7f089X3bk10Go5f/jcWF7D+xzDDmB00OHCTSLwFyR5igQTzlUwa1roOqe
X-Received: by 2002:a05:620a:4002:b0:85c:bb2:ad9c with SMTP id af79cd13be357-8c08fc012d3mr2519233785a.53.1766573015616;
        Wed, 24 Dec 2025 02:43:35 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-19.dlp.protect.broadcom.com. [144.49.247.19])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-8c096ca0b98sm176750485a.4.2025.12.24.02.43.35
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Dec 2025 02:43:35 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-29f1f79d6afso83686795ad.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1766573014; x=1767177814; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qs1L9yogvjoOS4UWjYKVRJa3NcwdJKzh6wcPXeXPOP0=;
        b=iFlBKWROze9MqXwUeSukcyRc3JRwSvtqAX536KfqyuD8imCDBV+xBF/0OA8T1XSrAm
         OHckxspexQsn4N3NxMvz6i64uMgvj1qg1Y8m48g7xxPVdnaqUuLBBxx/YC/xVNrjKjdX
         hMNn1hDwtJUE7AMjB/YrZ2meR2UD6mLWrhGlA=
X-Forwarded-Encrypted: i=1; AJvYcCUk2ZkOUDfW/aKNZqB7zbszi1qg9POfC/C6AB4Wp33mPwAGFRJ4g1yNV8brdQTvWWA7Di2Z/Z7lZg==@kvack.org
X-Received: by 2002:a05:7022:62a0:b0:11a:342e:8a98 with SMTP id a92af1059eb24-12172136c4emr20604510c88.0.1766573014048;
        Wed, 24 Dec 2025 02:43:34 -0800 (PST)
X-Received: by 2002:a05:7022:62a0:b0:11a:342e:8a98 with SMTP id a92af1059eb24-12172136c4emr20604480c88.0.1766573013386;
        Wed, 24 Dec 2025 02:43:33 -0800 (PST)
Received: from photon-dev-haas.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254c734sm68746919c88.13.2025.12.24.02.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 02:43:33 -0800 (PST)
From: Ajay Kaher <ajay.kaher@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	xingwei lee <xrivendell7@gmail.com>,
	yuxin wang <wang1315768607@163.com>,
	Marius Fleischer <fleischermarius@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH v6.1 2/2] x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()
Date: Wed, 24 Dec 2025 10:24:32 +0000
Message-Id: <20251224102432.923410-3-ajay.kaher@broadcom.com>
X-Mailer: git-send-email 2.40.4
In-Reply-To: <20251224102432.923410-1-ajay.kaher@broadcom.com>
References: <20251224102432.923410-1-ajay.kaher@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 919A7180006
X-Stat-Signature: xstq9nysn8yp73x4uhgy64abk3zzpws9
X-Rspam-User: 
X-HE-Tag: 1766573016-323588
X-HE-Meta: U2FsdGVkX180cNpVjbjLAcftZbWqP8Zjyy4aAM53uqXiQnbv97Ks+fYnbmSy7OPUYv6rBzMkHvKUp5bw5diTpPikMS+5i38yaCBeUAD72tOTejYvhjm6bRziu3FXCYYrSQ8nLJmYlU9u8A1yOHKaWM2HqbxqsI6d2sBW+uSxDfX3rcq4/aEWN8nhAGjT89C8T5m41iUj61Qrw+To46YiplOp28NMsPi4Qiu1c91KY/xVEcyH61QP0uzX/KnxtA29yT2FsZpM8pO3+NHzKtisfqhl0Vg1gM/QPAh0yq+HxGeDVN9Nc2XIljqe4GWuEDP5gy2rpLTTbF8T930jjEfpTdCItfGL5s/iNrpgBuAqe3vUUwFkhLsH2HoK3+JWVP9vuHzH2ba6XHZv9L8HDnGtx6cBlvbgYxcbiYGrL0nxSFQTc9GIaJ8+TeiBcHL2aRvWwN8p5MEqxTHmHRyakdNcK5lTaNeLoCR9q5NlCVBLXwSTTm0E0JI+7KLKbN1ZypYHYoKbLqO+1ScEE16xAoVVI4ip6upgNKQ73y6Y5hk2u9uR+sblwDGkmYzje3jGRvwWuUI8UYdjFlRB6RJCps0LnOPvr9kqhRv+RvWDumpNf6sSFyDarVkcRIzX6DGx2HYgYPBstCAgPT5Ny1cONUC8GeAo+N7PP71EYihpo6GS7ArcBmESmp8E5+FhfwNtP45w3owxqV38YAV1euJq39BlB+m5TcplxYcW3TJ82JwqkrxnP/SDn+yvqG6rQGQhsVbHQj/wC4pHQXO//8OQbhtTJMu4/hrsLIoctvnM4BAP8osIWv6t7pOVeKUf90zxVFSFJGycnqwr0gxSWs0KrkVvX6YkNUxc9MIdIxrsqItwYHg4uBcWPvut5F+A50MXmrvO8QrjYM8+p1eQBZgmLJmmfUkEV+4J+w/S0DflxC0qiMI6LAqRQNv02vDvMeRV/1CvDjzPn9Jv+l8WajWYnmB
 hbK35ztz
 bea9TSlLfEtHJFVLCWXzhasZDK+x9Bqp9iV12j6SrF2xFXfY4vqI5FztdAFQmaHhDLhDpw/Zpx836Q9ztH+S7GafNInbebnErlBihqWqwu4rPcylyKNbyEPFfjWOEBDiu7d14oMyBZzsQIFFZ3iGhfo6n7i7Ldf82AVOJpKsQZe02deA6D6pYM0xfjKuDfWgd9Njoh+DpF6pBkrKzSbiZ4sXyaZl1P2Hc5zhtXRKo2Wu4QRnmHBWkUpoPB8RNmPzgbESLc02S+zq/7sUfUY6zFajJ/cGd7Yu6WDXyhbAA4UZUFpcFOsb2szI6m/rIS8x+zfQn7JdubSiRUHnvarCMFKBWCKqWbdLR1Y8VBgu2yNoXPYR+FJq3ZwZyyorcjRYfpIDZgq+m0idB+a+TQJu7aVhutCOrVv2M75B+byFV4SOnLDo5oYdxFcvUFPK/AJo9k0Q7sZ2dvqfSCoa4DtaDLM+xVhNxNTxQuUP4exGe8lIxOcfmZkavbskxhY5O7CBWk7LmNx0jYP2hjpwQEELSKFacjEcju6Y5yJiFQHa4FfoX5tinUhrOUG75ziTmi8VkcrT3aVxLUfa6qL7oCA6YdqlZQdhYPugYpu+kNGLx3piOoa3A9EVPxPbnv+IY4CweWzgSiRjY5NATN5UAsBO3rwFxV/inO0lp20Jm7SSX3P1oYEMCPZcLMUYX2jk3TYWUyo6OP87FvqiXldsOSesMzOZyHyHu0O8BLP12OwYD1HHaj0n5h+Qb8Aq8PdO0tnL7C1xOWZDK+Zhm7CR7R7MrGQvLotPTYduca1ecdGbK6osdjGF4DGsrE2EKsOi12cbDdiib+KXlWB13KE4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

[ Upstream commit dc84bc2aba85a1508f04a936f9f9a15f64ebfb31 ]

If track_pfn_copy() fails, we already added the dst VMA to the maple
tree. As fork() fails, we'll cleanup the maple tree, and stumble over
the dst VMA for which we neither performed any reservation nor copied
any page tables.

Consequently untrack_pfn() will see VM_PAT and try obtaining the
PAT information from the page table -- which fails because the page
table was not copied.

The easiest fix would be to simply clear the VM_PAT flag of the dst VMA
if track_pfn_copy() fails. However, the whole thing is about "simply"
clearing the VM_PAT flag is shaky as well: if we passed track_pfn_copy()
and performed a reservation, but copying the page tables fails, we'll
simply clear the VM_PAT flag, not properly undoing the reservation ...
which is also wrong.

So let's fix it properly: set the VM_PAT flag only if the reservation
succeeded (leaving it clear initially), and undo the reservation if
anything goes wrong while copying the page tables: clearing the VM_PAT
flag after undoing the reservation.

Note that any copied page table entries will get zapped when the VMA will
get removed later, after copy_page_range() succeeded; as VM_PAT is not set
then, we won't try cleaning VM_PAT up once more and untrack_pfn() will be
happy. Note that leaving these page tables in place without a reservation
is not a problem, as we are aborting fork(); this process will never run.

A reproducer can trigger this usually at the first try:

  https://gitlab.com/davidhildenbrand/scratchspace/-/raw/main/reproducers/pat_fork.c

  WARNING: CPU: 26 PID: 11650 at arch/x86/mm/pat/memtype.c:983 get_pat_info+0xf6/0x110
  Modules linked in: ...
  CPU: 26 UID: 0 PID: 11650 Comm: repro3 Not tainted 6.12.0-rc5+ #92
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
  RIP: 0010:get_pat_info+0xf6/0x110
  ...
  Call Trace:
   <TASK>
   ...
   untrack_pfn+0x52/0x110
   unmap_single_vma+0xa6/0xe0
   unmap_vmas+0x105/0x1f0
   exit_mmap+0xf6/0x460
   __mmput+0x4b/0x120
   copy_process+0x1bf6/0x2aa0
   kernel_clone+0xab/0x440
   __do_sys_clone+0x66/0x90
   do_syscall_64+0x95/0x180

Likely this case was missed in:

  d155df53f310 ("x86/mm/pat: clear VM_PAT if copy_p4d_range failed")

... and instead of undoing the reservation we simply cleared the VM_PAT flag.

Keep the documentation of these functions in include/linux/pgtable.h,
one place is more than sufficient -- we should clean that up for the other
functions like track_pfn_remap/untrack_pfn separately.

Fixes: d155df53f310 ("x86/mm/pat: clear VM_PAT if copy_p4d_range failed")
Fixes: 2ab640379a0a ("x86: PAT: hooks in generic vm code to help archs to track pfnmap regions - v3")
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yuxin wang <wang1315768607@163.com>
Reported-by: Marius Fleischer <fleischermarius@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Link: https://lore.kernel.org/r/20250321112323.153741-1-david@redhat.com
Closes: https://lore.kernel.org/lkml/CABOYnLx_dnqzpCW99G81DmOr+2UzdmZMk=T3uxwNxwz+R1RAwg@mail.gmail.com/
Closes: https://lore.kernel.org/lkml/CAJg=8jwijTP5fre8woS4JVJQ8iUA6v+iNcsOgtj9Zfpc3obDOQ@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org
[ Ajay: Modified to apply on v6.1 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
---
 arch/x86/mm/pat/memtype.c | 52 +++++++++++++++++++++------------------
 include/linux/pgtable.h   | 28 ++++++++++++++++-----
 kernel/fork.c             |  4 +++
 mm/memory.c               | 11 +++------
 4 files changed, 58 insertions(+), 37 deletions(-)

diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index 1ad881017..67438ed59 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -1029,29 +1029,42 @@ static int get_pat_info(struct vm_area_struct *vma, resource_size_t *paddr,
 	return -EINVAL;
 }
 
-/*
- * track_pfn_copy is called when vma that is covering the pfnmap gets
- * copied through copy_page_range().
- *
- * If the vma has a linear pfn mapping for the entire range, we get the prot
- * from pte and reserve the entire vma range with single reserve_pfn_range call.
- */
-int track_pfn_copy(struct vm_area_struct *vma)
+int track_pfn_copy(struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, unsigned long *pfn)
 {
+	const unsigned long vma_size = src_vma->vm_end - src_vma->vm_start;
 	resource_size_t paddr;
-	unsigned long vma_size = vma->vm_end - vma->vm_start;
 	pgprot_t pgprot;
+	int rc;
 
-	if (vma->vm_flags & VM_PAT) {
-		if (get_pat_info(vma, &paddr, &pgprot))
-			return -EINVAL;
-		/* reserve the whole chunk covered by vma. */
-		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
-	}
+	if (!(src_vma->vm_flags & VM_PAT))
+		return 0;
+
+	/*
+	 * Duplicate the PAT information for the dst VMA based on the src
+	 * VMA.
+	 */
+	if (get_pat_info(src_vma, &paddr, &pgprot))
+		return -EINVAL;
+	rc = reserve_pfn_range(paddr, vma_size, &pgprot, 1);
+	if (rc)
+		return rc;
 
+	/* Reservation for the destination VMA succeeded. */
+	dst_vma->vm_flags |= VM_PAT;
+	*pfn = PHYS_PFN(paddr);
 	return 0;
 }
 
+void untrack_pfn_copy(struct vm_area_struct *dst_vma, unsigned long pfn)
+{
+	untrack_pfn(dst_vma, pfn, dst_vma->vm_end - dst_vma->vm_start);
+	/*
+	 * Reservation was freed, any copied page tables will get cleaned
+	 * up later, but without getting PAT involved again.
+	 */
+}
+
 /*
  * prot is passed in as a parameter for the new mapping. If the vma has
  * a linear pfn mapping for the entire range, or no vma is provided,
@@ -1136,15 +1149,6 @@ void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 		vma->vm_flags &= ~VM_PAT;
 }
 
-/*
- * untrack_pfn_clear is called if the following situation fits:
- *
- * 1) while mremapping a pfnmap for a new region,  with the old vma after
- * its pfnmap page table has been removed.  The new vma has a new pfnmap
- * to the same pfn & cache type with VM_PAT set.
- * 2) while duplicating vm area, the new vma fails to copy the pgtable from
- * old vma.
- */
 void untrack_pfn_clear(struct vm_area_struct *vma)
 {
 	vma->vm_flags &= ~VM_PAT;
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 500a612ff..943c47c95 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1195,14 +1195,25 @@ static inline void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
 }
 
 /*
- * track_pfn_copy is called when vma that is covering the pfnmap gets
- * copied through copy_page_range().
+ * track_pfn_copy is called when a VM_PFNMAP VMA is about to get the page
+ * tables copied during copy_page_range(). On success, stores the pfn to be
+ * passed to untrack_pfn_copy().
  */
-static inline int track_pfn_copy(struct vm_area_struct *vma)
+static inline int track_pfn_copy(struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, unsigned long *pfn)
 {
 	return 0;
 }
 
+/*
+ * untrack_pfn_copy is called when a VM_PFNMAP VMA failed to copy during
+ * copy_page_range(), but after track_pfn_copy() was already called.
+ */
+static inline void untrack_pfn_copy(struct vm_area_struct *dst_vma,
+		unsigned long pfn)
+{
+}
+
 /*
  * untrack_pfn is called while unmapping a pfnmap for a region.
  * untrack can be called for a specific region indicated by pfn and size or
@@ -1214,8 +1225,10 @@ static inline void untrack_pfn(struct vm_area_struct *vma,
 }
 
 /*
- * untrack_pfn_clear is called while mremapping a pfnmap for a new region
- * or fails to copy pgtable during duplicate vm area.
+ * untrack_pfn_clear is called in the following cases on a VM_PFNMAP VMA:
+ *
+ * 1) During mremap() on the src VMA after the page tables were moved.
+ * 2) During fork() on the dst VMA, immediately after duplicating the src VMA.
  */
 static inline void untrack_pfn_clear(struct vm_area_struct *vma)
 {
@@ -1226,7 +1239,10 @@ extern int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
 			   unsigned long size);
 extern void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
 			     pfn_t pfn);
-extern int track_pfn_copy(struct vm_area_struct *vma);
+extern int track_pfn_copy(struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, unsigned long *pfn);
+extern void untrack_pfn_copy(struct vm_area_struct *dst_vma,
+		unsigned long pfn);
 extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size);
 extern void untrack_pfn_clear(struct vm_area_struct *vma);
diff --git a/kernel/fork.c b/kernel/fork.c
index cbd68079c..992068b7f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -476,6 +476,10 @@ struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 		*new = data_race(*orig);
 		INIT_LIST_HEAD(&new->anon_vma_chain);
 		dup_anon_vma_name(orig, new);
+
+		/* track_pfn_copy() will later take care of copying internal state. */
+		if (unlikely(new->vm_flags & VM_PFNMAP))
+			untrack_pfn_clear(new);
 	}
 	return new;
 }
diff --git a/mm/memory.c b/mm/memory.c
index 41a03adcf..38e08d378 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1278,12 +1278,12 @@ int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	pgd_t *src_pgd, *dst_pgd;
-	unsigned long next;
 	unsigned long addr = src_vma->vm_start;
 	unsigned long end = src_vma->vm_end;
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct mmu_notifier_range range;
+	unsigned long next, pfn;
 	bool is_cow;
 	int ret;
 
@@ -1294,11 +1294,7 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 		return copy_hugetlb_page_range(dst_mm, src_mm, dst_vma, src_vma);
 
 	if (unlikely(src_vma->vm_flags & VM_PFNMAP)) {
-		/*
-		 * We do not free on error cases below as remove_vma
-		 * gets called on error from higher level routine
-		 */
-		ret = track_pfn_copy(src_vma);
+		ret = track_pfn_copy(dst_vma, src_vma, &pfn);
 		if (ret)
 			return ret;
 	}
@@ -1335,7 +1331,6 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 			continue;
 		if (unlikely(copy_p4d_range(dst_vma, src_vma, dst_pgd, src_pgd,
 					    addr, next))) {
-			untrack_pfn_clear(dst_vma);
 			ret = -ENOMEM;
 			break;
 		}
@@ -1345,6 +1340,8 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 		raw_write_seqcount_end(&src_mm->write_protect_seq);
 		mmu_notifier_invalidate_range_end(&range);
 	}
+	if (ret && unlikely(src_vma->vm_flags & VM_PFNMAP))
+		untrack_pfn_copy(dst_vma, pfn);
 	return ret;
 }
 
-- 
2.40.4


