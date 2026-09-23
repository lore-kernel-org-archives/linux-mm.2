Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3410CC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3516C6B008C; Wed, 23 Sep 2026 08:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329BE6B0095; Wed, 23 Sep 2026 08:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268026B0096; Wed, 23 Sep 2026 08:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0046B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:58:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AA27A07AB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:58:02 +0000 (UTC)
X-FDA: 85245029604.09.BA5FC88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C19FA1C0008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:58:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zxnby2nw;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790168280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQ0v5smSirSLn3Dbt8DawQtx7Fm5uc1AWxyasCUTYn4=;
	b=5z3mekz/3nH69ls2nq7Xy3H0fyfLyUgk/sbcCxbV089vCPfnUca+0314jBgK1cVw1sSqbp
	1go3WdjddgXgmYbsVcC7eiaYINI2R8hGClUpV1SMqujynLGzhbq/4/sKnRbvyta0xXMfVX
	R+omkOF3segIjWHC1iDvdsKxLKfe6xU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zxnby2nw;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790168280;
	b=iYPq5qMBTYFKEdMIbZyb5eXb+zs7tVJK2TxXN4FvNkvu74sGjR9ZIzLOvgB8ClgCmZEr3B
	8rADDiupx8Pfk5GH4VWP5Vs0NevDCrq28Cg5WBg7syQIlQxKP83hrGkmd46TTR/o0u9+uV
	vZ8cCovoPe0/QGqQTNNfoIslCm5NQf0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9612434F9;
	Wed, 23 Sep 2026 12:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0356D1F000FF;
	Wed, 23 Sep 2026 12:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790168279;
	bh=OQ0v5smSirSLn3Dbt8DawQtx7Fm5uc1AWxyasCUTYn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zxnby2nwT6agUfUxNFYQVFQcnq60D3e0EEiVBZXPeNMAsd92FqsxKviV5uj/bvzfI
	 dD/gfXnh/YJxcXOkYTa9Mq5+lvXX0MsOogKSlYr9sE11uFCcSNyu9ZHFKVaMFpWDWZ
	 6SWx1Ff/NCdQTHqlLFQEqLPJfLwtrNNFVmblGdvIcxqA9Fx6M6ARNVqRhkyvH4v8KJ
	 1jdzpEIuWqWtw9RYbWgySMWjGtmGmkKT2quL6gqcmldLgNIXva5ugTkBs9bblyyxtz
	 Qegl7qNWZgAitzeo62X094x0NbBU2byB3UhEMQlyktpxAxBvCcJI2K78R2Ad6JEKnu
	 vejZV/UiECaNQ==
Date: Wed, 23 Sep 2026 13:57:57 +0100
From: Harry Yoo <harry@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Amit Shah <amit@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
	Christoph Lameter <christoph@gentwo.org>, Dave Hansen <dave.hansen@intel.com>, 
	David Hildenbrand <david@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Kirill Shutemov <k.shutemov@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>, 
	Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shivank Garg <shivankg@amd.com>, Sterling Alexander <stalexan@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	William Roche <william.roche@oracle.com>, linmiaohe@huawei.com, ljs@kernel.org, osalvador@kernel.org, 
	nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, muchun.song@linux.dev, liam@infradead.org, shuah@kernel.org, 
	boudewijn@delta-utec.com, linux-mm@kvack.org, Breno Leitao <leitao@debian.org>
Subject: Re: [Invitation] Linux MM Alignment Session on Hwpoison on Wednesday
Message-ID: <arPElEV0zDhXrteb@thinkstation>
References: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C19FA1C0008
X-Rspam-User: 
X-Stat-Signature: 1ystk5jt9e3kdzgdzxmijsu9wkzx6x9t
X-HE-Tag: 1790168280-530183
X-HE-Meta: U2FsdGVkX1+DTHpR+q6fkDtmCkELZjUxJ2GsudL1WXWIDLoJbqYeSLrZc+MiXmB0ojKaKRvcml5R6oP5sOGgOKloAgrgjahw3Fvb5pPe5ruRi27cNjREB+TamV4XNsK2kVo1X8q4FLVAkgpLagPGS0fgdnskQn4lsiQy6GFw94GtRvCHSaMBPdQ2FxHvGv1uRp/sqCM8Ssvrr5MreZVreii/40FDR4CW4LHA1Zna4mcCbs7V1cRNqqvd8nXq0CrOXU/CwnJJ/w5ph2Lrzr195CVamoeWDBV8WNx0Ia3pVcqziNE2hK+p/wE/k6HVkkZ29N1RdMVq3oaJWvhSgQbidyec9pFZcY0Ky5so6fYKTGYsFHlFjOxV+6nxKw+RSH5Fj+WJhHNgL1sEXaLXRcdeIATMiYlbBI9fkkSPYmqeLZTLjlknwRq4Ne28A0djT74YO5C8zoVael3Z0K7qdlhnXKatLU/HCq0UTHKg0G+WPf+Zlq1pNUd4fEiDPV+FaS0G0+aYP408PV87BNYvkGo29TVOojZWv4KFQB4OLnuITC7vkg1Ax/Wuo0GhBJgR+nmt3gw458r7YHV4pNar+KBARyr3HeHiJqLSFak57dfvMBuQDQ87axOW8fiNkHb+/s8HrqWRRrvMdW7qGHM5y3L+EG+usZJr4YpOukLbNEouALTD08JKFz5HNvMFssHZouV21veO0W0U3TOo8FGfgzvuU0sa9gYdd6+QQIfdp0+kH6vUgdxHuYvfDzXgmQQlaI4hEYa/PrZwRzJ+8lZnS/EqOSGHM7oUiu0+W9WO4baMNqRtetJ0eQ4O8l/MEdQmTFDu/gap6+zynomzUdP01AaO8PNqtm6jpzpBlm0uCW8NRkqOehvdKsYqMNLtGIwxx4kYGi8dv+xKStafvkK/zZ9ZwbgVpiaN14q8OprMsYBSDEJ8cVrwTeiOP4ba+RIFFmYBQeuGnfVPfMk7W3QCTZM
 LsANVZEx
 0DEw+cTx6oribED07T8nDwj0bBPLbhhCDKKVgpSzAi9RoMtcMJaxMgz6wRVQ4gXCnKqctaPUOBY16GEnZFekxzgSPK4D8cSgwDg1V2CzNra4FuX3tQ36rcQSGM4z838iSkovMw4LNLigv9Btz1PGbKrCopc9ABIM/nuEfyFTPe2RPnzc6w9sV4wNFLQAXemiZkKgFCygmeqz7x5OZBsKzUoGCecWQkzocb0jby5uGiTy38NMdQEN5Chcd+I1p0MDBublJdZOhNn0hxpJBwX4Vjoarpr0K/5jIvVUC2oo5Se2bR3TRKw9aKBbIxQVCxVDwmO0y0a3K/uHx7Yau7YotYTB1d2uYHFaEV6x1TC2SvT3gt39ei4FG9aAn6e4IBMBwKSJxo3Rzf8Vr1obBghZDT96BMPV/T/+2Xn2IWqUGmhv+HI/qlXsAWOXvpQX3iNzoDopCna8sXyiwnX9QQahV1UjH7tLURdxRl7HpR3auGUDsRktk7lINlb95RBsVjrILaRwJYsXd84v1CMgNb/w1S5GUNOjDWxLoIY9dOKP7LFC2VTpjjy/C0Zz+nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:26:22AM -0700, David Rientjes wrote:
> Hi everybody,
> 
> We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
> We'd like to invite MM developers to attend and will announce the topic
> for the next instance on the Monday prior to the next meeting.
> 
> Our next Linux MM Alignment Session is scheduled for Wednesday.  The
> details:
> 
> Wednesday, September 23 * 9:00 - 10:00am PDT (UTC-7)
> https://meet.google.com/csb-wcds-xya
> backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
> doc:
> https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view
> 
> This week's topic will be Hwpoison, see the discussion in 
> https://marc.info/?l=linux-kernel&m=178796007385067&w=2
> 
> No specific agenda other than to gather core MM developers with hwpoison
> developers and discuss:
>  - where validation should live, esp with regard to the page allocator, or
>    strict invariants in the page allocator
>    + implications for the fastpath
>  - handling for folios of arbitary orders
>  - handling partial folio poisoning and split failures
>  - race conditions between memory_failure() and concurrent
>    alloc/free/compaction
>  - soft offline for pages in the pcp lists

[+Cc Breno]

This might be worth some attention:

  [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages out of the next kexec
  https://lore.kernel.org/linux-mm/20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org/

  - The question: How best can we pass information about poisoned pages
    across kexec when the kernel accesses a poisoned page, panics and
    calls kexec, so that the next kernel avoids hitting the poisoned
    pages again?

    One challenge here is introducing another source (a new EFI bitmap
    that represents poisoned memory, in addition to existing
    PG_hwpoison) of poisoned pages adds complexity and confusion.

    David Hildenbrand suggested that we should simplify this as much
    as possible in a way that we don't have two sources of information
    w/ inconsistency between them and using memmap as the only source.

    e.g.) By consuming the EFI bitmap only once when initializing
    memmap (to propagate poison information to not just free pages
    through __free_pages_core(), but to the all pages on memmap).

    Another challenge here is that we don't have functionality
    to poison pages early in the boot process before memmap and buddy
    are ready. So any allocation before initializing them might still
    allocate poisoned pages.

> We might even want to be bold and discuss a holistic design overhaul if
> it's warranted.
> 
> If anybody has ideas for future topics, please let me know and I'll try to 
> organize them.  We'd love to have volunteers to lead future topics as well 
> as requests for MM topics to be presented.
> 
> Looking forward to seeing all of you on Wednesday!
> 
> Time zones
> 
> PDT (UTC-7)		9:00am
> MDT (UTC-6)		10:00am
> CDT (UTC-5)		11:00am
> EDT (UTC-4)		12:00pm
> Rio de Janeiro (UTC-3)	1:00pm
> London (UTC+1)		5:00pm
> Berlin (UTC+2)		6:00pm
> Moscow (UTC+3)		7:00pm
> Dubai (UTC+4)		8:00pm
> Mumbai (UTC+5:30)	9:30pm
> Singapore (UTC+8)	12:00am Thursday
> Beijing (UTC+8)		12:00am Thursday
> Tokyo (UTC+9)		1:00am Thursday
> Sydney (UTC+10)		2:00am Thursday
> Auckland (UTC+12)	4:00am Thursday

-- 
Cheers,
Harry / Hyeonggon

