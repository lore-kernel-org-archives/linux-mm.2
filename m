Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473E160A2601
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UeFU53aC
Received: by kanga.kvack.org (Postfix)
	id 4DF7B6B05B1; Wed, 18 Nov 2026 09:31:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48FE06B05B4; Wed, 18 Nov 2026 09:31:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358556B05BB; Wed, 18 Nov 2026 09:31:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 096E06B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:31:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 832FA120782
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:31:31 +0000 (UTC)
X-FDA: 85448477982.06.8BE6D63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D19AB140010
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:31:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UeFU53aC;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012290;
	b=ye45PdG/2upo9oyXpAMU3dEmKDclXhCTIhdQl0HZlG+s0KbhJfqdB16zgxYtEKL/puUeL8
	1bmRUH+5v/VBwA64riZcAgRCEOxWwhZLJLZFNlvm1ArvU+BPhjXlvhVexQ6HavYlnEheYX
	I+wH9XdG7s/pzlI6UrnwaQglgyFvOp4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UeFU53aC;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y3zZObu6o92GT6lamZ/7p0SEfuKu0JfAlZFdmlt2sKA=;
	b=hDo/p68JeSJANV7/SR1vxYpXjZXGFLBw1vmxXpGrWhy45KtpFyRIrdjVK93BFo/pwMXuk+
	sCJcQ8IbC5g46M1lIsSK2weSS/14xmCZ1MjeS0DIc792ZjVjk5OdpIZTOtleJHZE8/G6Ra
	5fTo6vy3A02DAIqnTc6kwzPN764xNx8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37A6A40219;
	Wed, 18 Nov 2026 14:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB7F1F000C4;
	Wed, 18 Nov 2026 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012288;
	bh=y3zZObu6o92GT6lamZ/7p0SEfuKu0JfAlZFdmlt2sKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UeFU53aCnNhyEdyIq6jrkxoaaJProjQHDJST+jpds+OI82fNA8OLU0giXgssuSVH4
	 o1bRt91wqx+adkh6d3OvmeEyv1qwGDImL8MPa4WxCXCX1zfy77AGOY8zgnDBqWDmun
	 CZISpz9AiTZ308Xa4COSNYLn2yUxRL9hBv+8aRlyBa5xISFhlVD4oBTL9UQ1v2hVzo
	 EnzxgWHVEAx26oqN81zmpyj1BKk78HRd4U4gVzV0SiZuFQd3VrF55tpLao9RV7BXV9
	 BoymtEkUC7lpNuf47TXCJqdaf1TCXUA9HL7SEQD2jvdkoA51zPtn3b2Djx47jDtNlW
	 KfRgNrhOXqi3g==
Date: Wed, 18 Nov 2026 16:31:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Andrei Vagin <avagin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/9] userfaultfd: use anonymous memory for
 UFFDIO_ZEROPAGE on private file mappings
Message-ID: <av22s6nXWhWxog8l@kernel.org>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-1-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-state-fixes-v3-1-b617009d1a4a@columbia.edu>
X-Rspam-User: 
X-Rspamd-Queue-Id: D19AB140010
X-Stat-Signature: qwqxy8g4n9weph6qx8bns8wdnzp5ocs3
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795012289-60122
X-HE-Meta: U2FsdGVkX1+FXLhOOscjIe2WTcUPt7K275SEsdam5bjr4xpe4BkBY/RKXUL5PTpaZWGGxd4Sdtc+D7v4rWnMpihtW3zKHsMYzbIdW2YI0sgOjoqWKRZoRWoeXxeB+17z59CeUcpDmPKM0CtnrnLbACXSUvcPVwKlrkpKrEYy7tweyCG86DIlmrcc84yptby820putrS3/Bsu7OfhW3iGIRHZLMxLPpJEq0EKcOyBhwLGo0iu4yM6iS2NDmYprGg6CNyS/hty4HaGAGgLqMR47mUVC6P9bhFXOMP6b+PjZ5E/a/90PBbX4GaHMS3VFf71jYSGhjTP5QZW+NiTqCuqylcXJfYFVVQD2/W2ajaeX4+djhM8Yfy+nNGaSy/goA9JsLnk/XlTDdC/Ptx6Ia6Lp0Z75+FVblkZGsHkUaofu+Xly4ZM/Znbh9DFIV2Lp5vhJh1M4BYIzJ40IhEMHiJZM6kAlWU1yf0j2exTefHtjjEQX9GiUWCvNSkdbYVDE2MYPMZ5b49Dp3HFTQYW4X8aA74g1IgrMs08MImA3C3I+1w3DJRSH6CVsC9Qovj3+LAI2zk3RR6NYeLrwpJ9ORKqxevgyBnqlIhC+xBDISwD0BDYpRcAMIj3hYiZ5aRgWzpbkEuNZFtMtoFs9PTq+KaxO/fWkxfoWMBxQ1L8zsw/wfcjpR9s2PqMphiiXtV2GMTvRf7LGbA9ABN1tSHrPeSs/wxwcxEC88IY+vuugDSSlzHOk1yTp7h+kKnRNGXL888kLgtLKTkbYjvYWtIIiBlYiBVAL8L+HpmWdfK0dtRvy2l50KWBAzD6YQ2ZJeforv7LjngQpMr0CfGS5MWqf8sgVR75AGhfPsXInMY0v79bhGC/jpffvz4metTjtuc1APdeFjUVO/imTwMBcX4NxoPxNXdHQ+IwWJucm0tsrOH0zvBRr2qDcXHbq7zG+078y8e3YPsQ1ugrz09HaP0xSG9
 SKPkdZGn
 HIag0gcbniM8Ykrc7N9Eo3xU4/FYccPjZfNQ8tiEfPouzlf9EYCZzIEjbWGyBTA6AvTISB7IIEq6Eac2XCRWP4WM2/yVG7MRy/ktNfSZ4L6+fxcQsNifVfid8FBL+D84Kg/OHKY4CKYyHs+Bkk8iXxicXXIiPHJa75w4n5cMxlrvQR1bWl1FcQu0vt3VJHM0YQLCETXHkSsPpLFH1j0fcbyds9FUz2u890T0KRxnKNfi2PbgolculH+w6SCSdBLBjj8dSou2v5MFu/Ik34PE0pe3cc4W+H9QUiGR4kNOh+sZ8w5uyevywh1lp5/0gGB/WU2nEkSCglKwHPyhpborgzr/zwY7Ga+40VR2IOkTl/Fvpyh3NoBmq+4Tb9huBSc6HNqpb4yqSwIlN3ThG7RtRHyizWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:28:41PM -0500, Tal Zussman wrote:
> If the mm cannot map the shared zero page, UFFDIO_ZEROPAGE falls back to
> mfill_atomic_pte_zeroed_folio(), which allocates a zeroed folio and
> installs it through vma_uffd_ops(), no matter what kind of mapping it
> is. An s390 KVM guest with storage keys or protected virtualization is
> such an mm.
> 
> For a MAP_PRIVATE shmem mapping, that adds the zeroed folio to the page
> cache of the file. That is wrong: a private mapping must never modify
> the file it maps, and the file might even be mapped from a read-only fd.
> 
> The ioctl can also fail where it should succeed. A missing fault is only
> delivered for a hole in the file, but UFFDIO_ZEROPAGE can be called on
> an address that did not fault, or can race with a write to the file. If
> the file has a page at that offset by then, inserting the zeroed folio
> fails and the ioctl returns -EEXIST although nothing is mapped at the
> destination address.
> 
> What we want is what UFFDIO_ZEROPAGE does on a private mapping when the
> shared zero page can be used, and what UFFDIO_COPY does: only check that
> nothing is mapped at the destination address, map zeroed memory there,
> and leave the page cache alone. The zeroed folio path did that before it
> was moved to vm_uffd_ops.
> 
> To fix it, pick the ops in the common folio path, as
> mfill_atomic_pte_copy() did for UFFDIO_COPY: anon_uffd_ops for a private
> mapping, the ops of the VMA otherwise. That makes
> mfill_atomic_pte_copy() and mfill_atomic_pte_zeroed_folio() redundant,
> so remove them and rename __mfill_atomic_pte() to
> mfill_atomic_pte_folio().
> 
> While at it, use vma_is_cow_mapping() to check for a private mapping.
> 
> UFFDIO_ZEROPAGE no longer modifies the file, and only fails with -EEXIST
> if something is already mapped at the destination address.
> 
> Fixes: f74991b4e383 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
> Cc: stable@vger.kernel.org
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 46 ++++++++++++++++------------------------------
>  1 file changed, 16 insertions(+), 30 deletions(-)

-- 
Sincerely yours,
Mike.

