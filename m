Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2287D2D0E4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4516B0005; Tue, 13 Jan 2026 07:42:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A216B0089; Tue, 13 Jan 2026 07:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EF86B008A; Tue, 13 Jan 2026 07:42:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA4776B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:42:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7406E1A609
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:42:21 +0000 (UTC)
X-FDA: 84326903682.01.8A537F5
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2D64B20008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:42:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=eF4Sw4pw;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768308139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fU1qogXZNH/lRutT1CKQyIeRvV+WY6BgoX9FINuGm/E=;
	b=z/r/0FKvazjS7gj6JzJH8y8vzHTM6L4/0Qm0Y7mRYECvVqcp5Y720UefpOCsS2KPebDuYj
	N0piNJ2E1fVYlO7WmE/lwpWIf8QyoOLmy9mCrwmlVAcgs2mJTGvBP1Ihx/Y1+MvwLgoEkc
	Nk+bGESa1Mu5Qm0m8w/vq9FX4H70c+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768308139; a=rsa-sha256;
	cv=none;
	b=mBRVbv4BDNYb365SGGqrRxwFtGhAyrk3a/ywu6FAEPnYO3OTgBpXoS4LQ+4MGD1FvOIGbh
	xOV6/oLQgLrcT/uW+hwh1FkhfO8D5XPjysdG6mgfopDDGSoiqaQ7uOKiSV5OTdu/kTlqc8
	cfMoWRa5BUDGeghBmk715YRg2saenyc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=eF4Sw4pw;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768308124; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=fU1qogXZNH/lRutT1CKQyIeRvV+WY6BgoX9FINuGm/E=;
 b=eF4Sw4pwXFoBvDZYE6u698oNdgW+NHlQnZxlEQ5BAkv4HGAN6KsjGI4j4lvQWy6BrEA81D
 wh/OkgQzod7ppcXLS2h4v8vwG03WYziEXNZyArny08Oi9TwCn7h0u8u2atCEGB2HopNRVG
 0ifHRs/TDXEFHElSOZROBSttWbaSYS2cpoupdlRQu0cOHWbxfjaNSM48mdbDSARIEu9bz/
 YBN3KdaQ2/m5PM0/qXWPtMNoIducszgGo+k8TRymSfqgm7PBt1s7R0QC08rIo0BhtwKRbd
 KK5euRDVmvJEGJ3FM2MvUWt7a0I3yifEplqk2ru4rWEonTgaud6Q3iwANfaDjA==
X-Mailer: git-send-email 2.45.2
Cc: <akpm@linux-foundation.org>, <ankur.a.arora@oracle.com>, 
	<fvdl@google.com>, <joao.m.martins@oracle.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mhocko@suse.com>, <mjguzik@gmail.com>, 
	<muchun.song@linux.dev>, <osalvador@suse.de>, <raghavendra.kt@amd.com>
In-Reply-To: <7963534f-cce8-4330-8a67-3f31bd6b2166@kernel.org>
Message-Id: <20260113124147.48460-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <7963534f-cce8-4330-8a67-3f31bd6b2166@kernel.org>
X-Lms-Return-Path: <lba+269663d9a+4069a2+kvack.org+lizhe.67@bytedance.com>
To: <david@kernel.org>
Date: Tue, 13 Jan 2026 20:41:47 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D64B20008
X-Rspam-User: 
X-Stat-Signature: 7rd7zsu4n46848cenyztx5k1jkj9uz5g
X-HE-Tag: 1768308136-142712
X-HE-Meta: U2FsdGVkX1/Vs8BKvL1573CDpHKLhyfSAxb9qUqXeOiEXI6KX7hWSsgPIHcQCsqdJ4+n2E2MJmHH/tOyGfQxGZkVNKyH301PFVFvYb9Imd2pmaUm8XEZXv3OY2BVd86VskrhzAswr4Knn+ccmeVgCORcKx7sz/XEQLF0fdpX85pbfqzXr5pJpypd66aNt81Go8wir2DCXo1OCxZ/xcgK+rb7QB6brlmO0C9rbQ4g0dENG0dusk0qYhk0N8LQqKsgy7NE1lh/OJb7S7IIYS3vddBuV73NJS73I7q/Z9ubOqMloWm1Xh8ONEYhOH1IJVV1UeadF/A3a3o21wabDBYPSuQN5X/yCk6CN/UOdQ7Tj8E9NlcoBHSA2lUWvQBksW7jDBhssKTICw9vCtqGF9jHK9ZPS10XDEW0AxCd3FS3UgsMghdWYxkE91+e3whyQzM3jgaY/eTPLvPVwkmSWrKj/92tXFESorHFi/1dBZti7ziF1FR24G9uSgjcuJ5xWbZbpqlklyx2OBS2Sl/wf933S6Rt3h2yFrDx/IAmc/6XhQnG6DXn7Fq4X2U+YwPuPb2pOeUIvsdij7yY7wblHNa+MY5TGfOU4CJR8uNd+4/fS+OEQaKm6uiiRj7NdMA3q62l+JdnhPQ597YGT9irsVsUIzF3ywrnx2MjwSTRCr968rCLtNbZePsFSOTrtmvezi0IF3bCBrPmFzc8Zp5fyOVhXjOABQJLFvbXKt97K/kBaUb8E9qpvMKhz9KnjOnpGlbb7vPpolsVF2G7+wzp9/CPwZyZ2fFh1IOxh5dzQfMaU4vizvc41ASaY7ZNrinek+Ni/yRLKFoNVe6kXskKRAC95JNI/s88GEIEJ9oHZAt3vODoNM3fiefG+Kgo581g2WStdQSAnM8mWi0c9KGfwDps+hOifva5MCgxGm28QzcWbqhVMjHowU+NH8MLjziBaQUZnr+hgwL9yfZB5TsmpQt
 AoJoDrZq
 E0GXG2WmG8QTLPQ2TTVxKrPxSuQvSpy9o8DMXYQEBLu9LRcJcQLEia4dKnAwKffNzV0MYg5VzUpFeubhuZroutcGiVs7RhTtC92i6OQ6ZrMfI4lnpVWvYqMu2UpnCYjqQjFQb8YQnYJJp1hX4YGgh+Srq/0O7SdiuM85+o5pCaAbu+2UgCJa1D3TExpnMMeCwadBV4KcxYCNLDLkaFrMKdGaQX8Oqbcrt4bUrfBzB9HBKx/PZMxfwrcYXVaE+GhpOmAdR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 11:15:29 +0100, david@kernel.org wrote:

> On 1/13/26 07:37, Li Zhe wrote:
> > On Mon, 12 Jan 2026 20:52:12 +0100, david@kernel.org wrote:
> > 
> >>> As for concern (4), I believe it is orthogonal to this patchset, and
> >>> the cover letter already contains a performance comparison that
> >>> demonstrates the additional benefit.
> >>>
> >>>> I did see some comments in [1] about QEMU supporting user-mode
> >>>> parallel zero-page operations; I'm just not sure what the current
> >>>> state of that support looks like, or what the corresponding benchmark
> >>>> numbers are.
> >>>
> >>> As noted above, QEMU already employs a parallel page-touch mechanism,
> >>> yet the elapsed time remains noticeable. I am not deeply familiar with
> >>> QEMU; please correct me if I am mistaken.
> >>
> >> I implemented some part of the parallel preallocation support in QEMU.
> >>
> >> With QEMU, you can specify the number of threads and even specify the
> >> NUMA-placement of these threads. So you can pretty much fine-tune that
> >> for an environment.
> >>
> >> You still pre-zero all hugetlb pages at VM startup time, just in
> >> parallel though. So you pay some price at APP startup time.
> > 
> > Hi David,
> > 
> > Thank you for the comprehensive explanation.
> > 
> > You are absolutely correct: QEMU's parallel preallocation is performed
> > only during VM start-up. We submitted this patch series mainly
> > because we observed that, even with the existing parallel mechanism,
> > launching large-size VMs still incurs prohibitive delays. (Bringing up
> > a 2 TB VM still requires more than 40 seconds for zeroing)
> > 
> >> If you know that you will run such a VM (or something else) later, you
> >> could pre-zero the memory from user space by using a hugetlb-backed file
> >> and supplying that to QEMU as memory backend for the VM. Then, you can
> >> start your VM without any pre-zeroing.
> >>
> >> I guess that approach should work universally. Of course, there are
> >> limitations, as you would have to know how much memory an app needs, and
> >> have a way to supply that memory in form of a file to that app.
> > 
> > Regarding user-space pre-zeroing, I agree that it is feasible once the
> > VM's memory footprint is known. We evaluated this approach internally;
> > however, in production environments, it is almost impossible to predict
> > the exact amount of memory a VM will require.
> 
> Of course, you could preallocate to the expected maximum and then 
> truncate the file to the size you need :)

The solution you described seems similar to delegating hugepage
management to a userspace daemon. I haven't explored this approach
before, but it appears quite complex. Beyond ensuring secure memory
isolation between VMs, we would also need to handle scenarios where
the management daemon or the QEMU process crashes, which implies
implementing robust recovery and memory reclamation mechanisms. Do
you happen to have any documentation or references regarding
userspace hugepage management that I could look into? Compared to
the userspace approach, I wonder if implementing hugepage
pre-zeroing directly within the kernel would be a simpler and more
direct way to accelerate VM creation.

Thanks,
Zhe

