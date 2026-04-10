Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAA2F44842
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 11:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45776B0089; Fri, 10 Apr 2026 07:55:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFBE86B008A; Fri, 10 Apr 2026 07:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0CD86B0092; Fri, 10 Apr 2026 07:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C44B16B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:55:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75B7B59196
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:55:44 +0000 (UTC)
X-FDA: 84642491808.01.24106D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E77DD2000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:55:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hOZIcHOx;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775822142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtfUfxE/xs43zAAF0blVEvJBY1bTJtOfWAwYT3PoW5Y=;
	b=d2vhkGygrdzJNCtmxvpgsB+gmvW2MsLrVf1HW87r0WX9+Pd9vscIfDLHVklIy6chLysXja
	FyvIPIYY8sVFtK6jTeiSA22W+MNlXaCG5Ry6mfzYaQA7fkTE+NWNIEQre9PnzjR/5JytH7
	n78L6OFYJXLhFXmXcD5gt8VXU5o06qI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hOZIcHOx;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775822142; a=rsa-sha256;
	cv=none;
	b=GC+dbmihGWumKWFJRL1AHIw4vks25JmklL74j+fH2DJ13oCKEaENZRdQiN3ahlIHaS16pG
	ZTGwoomE55pz/CJFH/NiThTTbHw9km+kaG/32WWlznn0I67cucy6oOgKjtSLZxNQe1+NFc
	8dbAwYY+ujYkokTuEdzIoVpqYPpB/I4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DE4D60154;
	Fri, 10 Apr 2026 11:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D0DC19421;
	Fri, 10 Apr 2026 11:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775822141;
	bh=HFVNSZ9NdLshs/GF0kF4F3nn6TItzP93pKQuOnmZi4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hOZIcHOx8RMyGXKW+908tLqShReyx8UHYG4egkJqVAZkly0v7p33q4UAay3LeO2Li
	 909+KGhspCpoLhKu/yYX4lgd1bQD8j7huO7QANJEMGOMwOID5qf6JimIdEMuVtAFjW
	 +GhHAia+VOlJjk1lkx7+BsR28wl1z47Ab6wp84ECDq4Ne2+EnT+emA7hhb4J+2rLry
	 YlaUbwErfT9kQccM/Jz2U8uBuxnxtjdRSVkHLVeVUEjGqnHrocrFlrDSa/ozdtHXtC
	 EO3nFkJuqdofrp1T2VseMnr7Gmf0zpuJ+5ds4RjmrJ4HjFgZMtXk4qr1svT4RRSevK
	 SKvQh+S8cISDQ==
Date: Fri, 10 Apr 2026 12:55:31 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mhocko@suse.com, npache@redhat.com, 
	pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, leitao@debian.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
Message-ID: <adjkCOiLgZ_-zovg@lucifer>
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev>
X-Rspam-User: 
X-Stat-Signature: iiz48ybr1bchx4j4eebj7iywa37xcdw3
X-Rspamd-Queue-Id: E77DD2000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1775822142-816456
X-HE-Meta: U2FsdGVkX1+8LCWtlmxXKZ1Cc0z5JCKkE0L2fFWfaoOWFmw8MMviBiPpglIs+MrcJzoxXqODh1AcZR7/ED29Ng7hazefW+c33h+zb8VDJ7UzKlgH3Wq4c+vq/dcUPEaBClAIm1QiyjXjVS8W7U212iT2m5Mle3fjShhWfbC9qJ3MzkeKp0UeGGFDp1KdWGheTK1nZ2zk0e8oQrPHO18P3F1FNK9JaT6j8fa7tnSoweCGfWgD0L+xKImBrXqvA1ESjTNJx+7hDC2P63vLM9aJHkMb6A+4t/fR3ts5hCZ2vbtLUqfsliDFlX9FQqG49TKwkhPZD8BqnmxeJ7fDPAOrwP2tC4Bbive7PRBve0eSn8ULc3pkXVXUp9ZLWqW7sPJH0NFUTUchM1U2/MqcQDJqy1MoLw1wkf2nxCK2D33sgTfTPg6p0fxZWowMZ396MVllL8Kt9MjS8f+mR+lBj0UOopyl6ygIgN65EcSX3rzrVk2fhrz7ShJK5DRlMygL7lmyUA2q0Vk4R2GtEC9jkmwr1yvAhF2gExR8x8/z09R0lFKvomCkkgLbPzDXCO+RWxcxl4f75YkZ5fLsYEaKGJMgSmes/WfUESMM5OqOJkiPy1l05VnKG+TRpLJHU6HRVuBBMSP3MY5khwLnKV/uN0Z8aZIOaaA+Quy0bnHHYcm/WVT+Yf+fX5XlE1XNObu97CX4RffEWEgjdh8fPtXaUWCTdwA0X2kphVUzrITQWL4wYpjmSGOcqY65Xpoj/RldEc3seaqndDMtWoCsLKzbfEuJqN9FFs/IohGgaLf5KsCvU0U+zuYLIgaeDZzs1SqhtXMNSVp3a76n1pAbeTmyUtLzSf08oI+IRY/U8WI553Mg2dxS93bV28cXNnS3njOYqJhkm6vN2E/Y4Egkvid5EKApJdNv0juHXMGsvLnfxGr/neUSINI/cbRPjhbFc920ETHEVRE+YmIDnEg2ucH9/Qi
 ocxFbcet
 iZG5vfLHvFWIgHulZHDneaW10Sq99ZqEZwm1/JoLr5NF7vRkbLIEHAW445JuAzIvhVNv6X3ScQWmoYaHyfglGtouaW8vLHZhneBbMln1/7U4ADmXnUUFvTOOIplNkVFY8QTw0vfO3Xn+Uq0hQCiJ58YLfinJ7bLStTSGbzzzqVPlbWILGyqFaF7pCGGVk9LxWQvzlqIY2UKU+vdv3hBXNC7F0a/ivRH73puj6CmdxjHNfXBW96gflE6GLa5bd/qDg2mzhIxCf6YfQkiFn95K7EN8hXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 12:03:03PM +0100, Usama Arif wrote:
>
>
> On 02/04/2026 19:08, Usama Arif wrote:
> > v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
> > - Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
> >   to HPAGE_PMD_SIZE limited to 2M (Rui)
> > - Reviewed-by tags for patch 1 from Kiryl and Jan
> > - Remove preferred_exec_order() (Jan)
> > - Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
> >   otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
> >   do_sync_mmap_readahead().
> > - Change exec_folio_order() to return 2M (cont-pte size) for 64K base
> >   page size for arm64.
> > - remove bprm->file NULL check (Matthew)
> > - Change filp to file (Matthew)
> > - Improve checking of p_vaddr and p_vaddr (Rui and Matthew)
> >
>
> Hello!
>
> Just wanted to check if there was any feedback/review on the latest
> revision?

It's -rc7, this is definitely something for next cycle :)

On my part, my upstream bandwidth has drastically reduced, and review is
probably going to have to be a hobbyist thing at least for now.

Also, not to be mean but:

$ git log -E -i --grep "(Reviewed|Acked)-by: Usama Arif" --oneline | wc -l
21

So... :)

Review in mm is very lop-sided, let's try to balance it out a bit!

>
> Thanks!
>

Thanks, Lorenzo

