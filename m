Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F19D3900B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2C06B0005; Wed, 14 Jan 2026 14:00:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65E86B0089; Wed, 14 Jan 2026 14:00:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72246B008A; Wed, 14 Jan 2026 14:00:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B681B6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:00:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 082F81AE3B8
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:00:12 +0000 (UTC)
X-FDA: 84331484664.04.F2F729B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A5AC16000C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:00:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A3zkJyOI;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768417210; a=rsa-sha256;
	cv=none;
	b=wTUsF3pvoTGbxGWlJ6HyKVUCuWdAJMOiSMt9pIHWbgmQT+tXZJpkwbiLn55pxsl3yjn6gr
	U3wZBxxbe+ZB2u/I1cnijbN2OvoJxggszRNYpnT38dZkkKs8NsgUj9gxB2ArJc9ZiZt0VM
	zVh+369saoRFS1Y9KfZ0qRdUDjZGxOw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A3zkJyOI;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768417210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpQBVXkc61n1F2U8X1PPSsuAGaM83iXB4iAIF7ksr4w=;
	b=r0Av6TitMepJ/925/r8T5eo7yUpzf+/BkRLZ3QdI6ALI62lLQuLKWXg/nlLt1iEDZjYWG0
	xJr+d39jxEYM6fbLAqsHMQF6L/P6NXFwMYsWgzEmLPGmBC8I8LAMaU9v+axNgRDJa34AC8
	XdRWfSEgQtmN4A7K72ZilQz4Dc2NI8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00F7740745;
	Wed, 14 Jan 2026 19:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8F8C4CEF7;
	Wed, 14 Jan 2026 18:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768417208;
	bh=Ea4+GFq3dvRVKBWLXL2dGpjC6QUsN/5CKbbkdtcSkAc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=A3zkJyOIMhlgNA/h3KeOk3OevIOv/TNRnD9jwxfEpcT4iwUdK7IuStF/J4dAztaS2
	 QxiG/782koAMadAkIagGwjkxXsaprOWjFRbvT9uiHPQCmYN+ISppQv31zLJ7cx6/tI
	 vlDr+NkuUQznVfygHj1igc6to9U/6XHduqX+fNf+tkeAdyjo2Skd3vu3iRaRWSJwBI
	 KsKMHuc/b9okeyVJ8ji42js4SGI8WGBHnUZNX80EUCFhdqSNsRwpKpFZtZWE2xesQ3
	 RYisN7Fo16Hh+Fb4JXNRjk+iDzt9AJ6QSl7Nha3hD9wS1BPYDLxxTkWo1MAb4WLciX
	 1Buo4VHDjDTFA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Chris Mason <clm@meta.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  jasonmiu@google.com,
  graf@amazon.com,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  tglx@linutronix.de,  mingo@redhat.com,
  bp@alien8.de,  dave.hansen@linux.intel.com,  x86@kernel.org,
  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v8 14/18] mm: memfd_luo: allow preserving memfd
In-Reply-To: <aWfLS48tG7XInpNN@kernel.org> (Mike Rapoport's message of "Wed,
	14 Jan 2026 18:58:51 +0200")
References: <20251125165850.3389713-15-pasha.tatashin@soleen.com>
	<20260113140927.1074142-1-clm@meta.com> <aWfLS48tG7XInpNN@kernel.org>
Date: Wed, 14 Jan 2026 18:59:56 +0000
Message-ID: <2vxzikd4hvf7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A5AC16000C
X-Stat-Signature: hqu5m4qkfrw83y8ohb4xhds8p6kgqbwi
X-Rspam-User: 
X-HE-Tag: 1768417209-218906
X-HE-Meta: U2FsdGVkX1/DnkdiExkhKHrdLa0+/10Agfu/smBpzFwcJTNUPL6SIptMU0nie64oLr8QZTBdkIi2uomA11brGDhzdji6cFYkSxKEO+H+0y1KUIJgKLO2abMvxNgSjEFocDlUWBAD2E1zfv99rT0OGh6dZLY15Ql5rFy7F2uadj6l9TTC+wDTcoEXOW6TMyEPfPjQ+wS8h7eJMwl4Xt5/dyOhjPv4/K/AB9ZH639OBte/vrVTaM8Q7duBK/v+Y606Hh6/bLTE5fveCuu0vdFwAzxAgF+0oKTBTNzAWUHPZLVh4d0nmWjAJkxq2oBqDfG+6RALvXBmgDTBIOEFyvZkUGFeDsr8pLMjuDfEpFmtyRykcGrjInbwA2X5oRLFE82H6jCxErhKGBbYRuEJznaXtk3/bKMjtiEw0A8FcLQhh//ib3m/EMiptSypptfNJgpR+KQnNfOiPckJdyXTfl4GhNQhVQr3Yk7VapJohjnmTX5p5ttA8Yo4QB0YIoXClpxrr74RW4bg3pfflB/oOq5qdWoOfzUhgAZn/MIfccYv666xqc0j7CHm46bPg69Fu5bnw9wNxvWIVH2B8QI1OieefN2F3qpX7nNaPdjAVZYzzAMCq+MMTXeBL9+SyFGaqbSGrI+8xy+cYVQiCf8qq8FsVBb5zmjbnKHbU/U1QoGNKSQyQUeGfqzvqjh0kUZAk+YYAKCS16pCBPGKOqy3nVMbXQuCmOJGo8Sa3zJATBsnZebnjsitXjdU4yhb5uaoHtBxOcyKEuGjGVfNFB3slVAye3YAkkp/j1sj8eU7mRyVSExCtudigpJUc3SiLizLJPpk2dqHoWKvApFJW6OnRL7jhGPmej5y5EjC5LtebrY8d6B39wiB6KsG7H4pqsqUvaZP47pjkjmTGeU+boyTyu9/74kmwy6HDZArYhsB7CP4GWADRfkwVKRT/ijtxW6pdH4xCbEcyePTGLA5QwklGUe
 7/efIq0Z
 hemVvCiM+vk3l+/ailfwSVWEnY02mUpEXWh/gunyUorY6SMvxQshCTFE7We/J47Ix0FkSmkk3dZAanq7YPFux79gjaatQMjr7Q3rF8w29sMu8OjFrpyMxZsC3o0hpUZ9fQ6w2O4n9wSF5e7UiWcDPpVdtOswz2iJ3UCMdkfYhOCWRDVNCc2RRGa1k3wbeC5o95gZqNpKoWMyc26N4u+hAtJ2zWTiFzStLKNUhUYyB7Yx2O6rSJGHdY2A7yYdjtlhQze/6MaQk0RoVef0V4thq3WAUQqEQ00uIl7bOzAZ4xmsxiGnQS6xji2sV2C6+1FTt8A9BWEZ2HPachTdIXIJOabwlUqa9NiAEMJR5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14 2026, Mike Rapoport wrote:

> On Tue, Jan 13, 2026 at 06:09:23AM -0800, Chris Mason wrote:
>> On Tue, 25 Nov 2025 11:58:44 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>> 
>> Hi everyone,
>> 
>> I'm running the v6.19 mm commits through patch review automation, and this
>> commit was flagged.  I don't know this code well, but it looks like it
>> might be a real bug.
>> 
>> [AI review output below]
>> 
>> > diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
>> > new file mode 100644
>> > index 0000000000000..4f6ba63b43105
>> > --- /dev/null
>> > +++ b/mm/memfd_luo.c
>> 
>> [ ... ]
>> 
>> > +static int memfd_luo_retrieve_folios(struct file *file,
>> > +				     struct memfd_luo_folio_ser *folios_ser,
>> > +				     u64 nr_folios)
>> > +{
>> > +	struct inode *inode = file_inode(file);
>> > +	struct address_space *mapping = inode->i_mapping;
>> > +	struct folio *folio;
>> > +	int err = -EIO;
>> > +	long i;
>> > +
>> > +	for (i = 0; i < nr_folios; i++) {
>> 
>> [ ... ]
>> 
>> > +		err = shmem_add_to_page_cache(folio, mapping, index, NULL,
>> > +					      mapping_gfp_mask(mapping));
>> > +		if (err) {
>> > +			pr_err("shmem: failed to add to page cache folio index %ld: %d\n",
>> > +			       i, err);
>> > +			goto unlock_folio;
>> > +		}
>> > +
>> > +		if (flags & MEMFD_LUO_FOLIO_UPTODATE)
>> > +			folio_mark_uptodate(folio);
>> > +		if (flags & MEMFD_LUO_FOLIO_DIRTY)
>> > +			folio_mark_dirty(folio);
>> > +
>> > +		err = shmem_inode_acct_blocks(inode, 1);
>> > +		if (err) {
>> > +			pr_err("shmem: failed to account folio index %ld: %d\n",
>> > +			       i, err);
>> > +			goto unlock_folio;
>> > +		}
>> 
>> When shmem_inode_acct_blocks() fails here, the folio has already been
>> added to the page cache by shmem_add_to_page_cache(). Should the folio be
>> removed from the page cache before going to unlock_folio?
>> 
>> Looking at shmem_alloc_and_add_folio() in mm/shmem.c, when
>> shmem_inode_acct_blocks() fails after the folio has been added, it calls
>> filemap_remove_folio() to remove it:
>> 
>>     error = shmem_inode_acct_blocks(inode, pages);
>>     if (error) {
>>         ...
>>         if (error) {
>>             filemap_remove_folio(folio);
>>             goto unlock;
>>         }
>>     }
>> 
>> Without this, the folio remains in the page cache (counted in
>> mapping->nrpages) but info->alloced is not incremented (since
>> shmem_recalc_inode is not called). This could cause shmem accounting
>> inconsistency.
>  
> My understanding that if anything fails in memfd_luo_retrieve_folios() the
> file is destroyed anyway and the accounting wouldn't matter.
>
> But to be on the safe side we should fix the error handling here.
> @Pratyush, what do you say?

Yeah, I don't think the inode's alloced accounting is a real issue here
since the file will be destroyed immediately after. This is why I didn't
want to add the extra complexity of the error handling.

But now that I think of it, perhaps the lingering unaccounted folio
might cause an underflow in vm_committed_as. shmem_inode_acct_blocks()
cleans up the vm_acct_memory() call in case of failure. But perhaps the
iput() triggers an extra shmem_unacct_memory() because of the lingering
folio.

I am not 100% sure that can actually happen since the code is a bit
complex. Let me check and get back to you.

-- 
Regards,
Pratyush Yadav

