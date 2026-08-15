Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86350C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 18:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6DD6B0387; Sat, 15 Aug 2026 14:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598146B07E4; Sat, 15 Aug 2026 14:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD566B07E5; Sat, 15 Aug 2026 14:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29FCE6B0387
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:16:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 314BCC03E5
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 18:16:45 +0000 (UTC)
X-FDA: 85104309570.24.B420B8A
Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A9A4A000B
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 18:16:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GIQa/i3B";
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786817803;
	b=hdwhYYUPgdcgofQHquXNyJ+jO1Kk7cw772QL1VOewNUrWzxaCN9Yy8na62nXMeBXkdcDle
	OHzfJVL86da6FujIutpT57/C8d7q5F4YiyVuoLNysBTdkmmRjGWoVhGfJmvb5Rg7WHpDq0
	BtrnYHnW/BUA2cuhj4bu5bUXNLm5c9M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GIQa/i3B";
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786817803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/zAqh/SBW3aekNfFpOYXuCzRxL10j2ukl5k7Lyjnxg=;
	b=YtbjH1E1iYssVBZ9fxVw2zmLUZItN7movEhgFKyTb8vRFlspTfqcQ99O4RR79c1BsGzY4G
	TrL8gEnFBEm5M2JoWTggf4MFLKu4LSB3qKLtyF661ddc572/p6AzLF7YdbonGHcC9+aPj1
	hz4EM+Usij8qgybCsNxAaWW08zLOJTs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sxz3FbT3P3NUYsxm7p5UauLMyNdZFqQ91NsLQoVFsio=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786817801; v=1; x=1787422601;
 b=GIQa/i3BJ+fCWkaB9FqBDEdFyF/+LX5y0ZszsKT0Mc2Gq8oyusHmKjgO1V0olpgq1pm62sai
 QmnFiBJji0IcSZlBDLYle4fdfMqgcPN0EgZbp+B6VrAUq2hfCRBWEB87cSunuTE4CafZu2CVmAK
 ++tMM0wwxK27LgtAq2O4tOas=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 18741eb5a36b713c;
	Sat, 15 Aug 2026 18:16:40 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: vernon2gm@gmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 0/3] mm: khugepaged: fix tracepoint UAF
Date: Sun, 16 Aug 2026 02:16:32 +0800
Message-Id: <20260815181632.21453-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260815174444.4164-1-lance.yang@linux.dev>
References: <20260815174444.4164-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A9A4A000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dnnxa8dqdar9ccf6rh78wjqafst7rcn8
X-HE-Tag: 1786817802-922226
X-HE-Meta: U2FsdGVkX1/DTy05MWTUJPB2H1vNVmNaP1cJRG7tkzxKyYKf5NZC6Kla/uBATKgbmwTCDnQv+E0Bxc6yBdWbZPIDHjAsItDfjGsC6hbjcCt1b0Zs58V+HyS0gDaVipQLlBUlQ1A4xGMzHPoOAf++2pvrNQk2tKBiSIpFRr/kpXiFg6vxJBzTSf395plK12uWoSG7Dq41ftyym4sbDxlhMTylk68h/ocil7icxExAqh21zuvnfKDwTOY+ZLAg+OpHspZxdai8tWMTk73z6qaHeiDf348r2zwML8Zognpe+XDoeFaOrGzJhSy8F5u+xbBFXXuYYzL7cL2Kh9bwaMWImqr/U4sJe+5KfCZEhqPeVGSSMFl5rqmSlRiB0OHQ3fq4BPz0cnyMb/sFcYrAVUEJrPt7gW5ch4uhPgjFmJ8PYsvUQcnSt4eEiDd+g9zUNqif9kxa8d5/uLzLpfYJSxY1N8VqemJ7rlxsSXdc0U9sXdmkRjEqyUVnrWyAULtntzWqP4fjFDJwLQrMgWuDViWeeM6RmFmpRxvwd0ABkYK9y4jeiwpsGj9qmD0WAFkX8SMO3c4Lk72/N6h27RrWXPuXl6RTdrX9z21Gjt3Jrx7+usdY5EhZlc+lnuSqW8QC/eNb8gxNkcw1Xx+iyvP5BJrlaqPmOJ+gtHzqnckno3sH3zLm3yJEAt4rwYG9oE2or5xzphRUgGUu1umQit1Emuo1CMKlc4X9vJQ4tr6iqNejkK5ff3bhx3++iLoMhXLj05/0jrDvkgZx8ndbKKrk9lFAxI8hg3rPW/kWMkKb4g42QaJJspQIc4GRawczuqaTXhpwiyAzMFprc7opTOx8Bm3Qxrda7XjNHkBvYgLERiidu6HqvHoW2bZ6+9v+6XL+/wwLmVQN//f23vhPcTPtWaXoi30ouKplNHH6N4pz9zIHmyYGuq4rrSyNizdKZfhbZJJr0kzfIogC4MYDG3/wQPY
 xd99OgQZ
 4Qyl+hca4yKlX7cuZxjdWs9pAYCuM9GiFCTAw1rpVI+j4B6Np8WPvFlY/KLIRuvaQJSCUZu4Ra1n9EpbG7umhWgMmaRI49caQWYhCbOJuyr8/6MCeKb5719Ks6++6fO5/3FfZ3GiD9SLDz3XRWcfk18tqGr4AB+NfhvjNR3PvibovAapGuc7I/4Uf9lJbH7wCvmTI+07eS0OZ8xrbMhZlu1Nkd1rA5SlmNWt8TCBR6aRQXrQTyr3G7ljsA2bzShFbIRcLDk8FiNKJILOJEK/qFMkBxc9QXbeMllo1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Baolin

On Sun, Aug 16, 2026 at 01:44:44AM +0800, Lance Yang wrote:
>
>On Sat, Aug 15, 2026 at 01:19:21PM +0800, Vernon Yang wrote:
>>From: Vernon Yang <yanglincheng@kylinos.cn>
>>
>>The khugepaged tracepoints take a folio pointer and call folio_pfn(),
>>but by then the folio may no longer be valid: freed after folio_put(),
>>folio_unlock() or pte_unmap_unlock(), or not a folio at all but an
>>xarray-encoded swap entry. On classic SPARSEMEM, dereferencing it oopses
>>khugepaged as soon as the trace event is enabled; on other memory models
>>it merely prints a bogus pfn.
>>
>>Pass the pfn to the tracepoints directly, captured while the folio is
>>still pinned, closing the use-after-free windows in
>>mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
>>mm_khugepaged_collapse_file().
>
>Well spotted!
>
>Gave the series a run on x86_64 (KVM), all good (only classic SPARSEMEM
>untested) :)

Hmm ... stumbled over something else while testing this ...

With tmpfs mounted huge=advise, one MADV_HUGEPAGE isn't enough to get
an unregistered mm onto khugepaged's list. Do it twice, and khugepaged
starts scanning right away.

The pending flags make it into khugepaged just fine:

int hugepage_madvise(struct vm_area_struct *vma,
		     vm_flags_t *vm_flags, int advice)
{
	switch (advice) {
	case MADV_HUGEPAGE:
		*vm_flags &= ~VM_NOHUGEPAGE;
		*vm_flags |= VM_HUGEPAGE;
...
		khugepaged_enter_vma(vma, *vm_flags);
		break;
...
	}

	return 0;
}

and survive the common eligibility check:

unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
					 vm_flags_t vm_flags,
					 enum tva_type type,
					 unsigned long orders)
{
...
	/*
	 * Enabled via shmem mount options or sysfs settings.
	 * Must be done before hugepage flags check since shmem has its
	 * own flags.
	 */
	if (!in_pf && shmem_file(vma->vm_file))
		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
						   vma, vma_start_pgoff(vma), 0,
						   forced_collapse);
...
}

But then the shmem helper reads them back from the VMA:

unsigned long shmem_allowable_huge_orders(struct inode *inode,
				struct vm_area_struct *vma, pgoff_t index,
				loff_t write_end, bool shmem_huge_force)
{
...
	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
...
}

At that point vma->vm_flags still has the old value, so huge=advise
quietly gives us no allowable order.

First madvise still succeeds, of course. The second one works because it
finds VM_HUGEPAGE already installed by the first call.

Looked at history too ... we've been here before. 2cf1338454a8 ("mm: fix
khugepaged with shmem_enabled=advise") fixed this exact ordering bug and
tagged cd89fb065099 as the culprit. Then 6beeab870e70 was meant to be
"No functional changes", but moving shmem_huge_global_enabled() into
shmem_allowable_huge_orders() seems to have wired the stale vma->vm_flags
read back in.

So AFAICT, this regressed in v6.12 with 6beeab870e70.

@Baolin, does that ring a bell? Any reason shmem_allowable_huge_orders()
can't just take the pending vm_flags as well?

Cheers, Lance

