Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132BEC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FCFA6B008C; Tue, 11 Aug 2026 10:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F366B0092; Tue, 11 Aug 2026 10:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C9B6B0093; Tue, 11 Aug 2026 10:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D446E6B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:21:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 664D5C042F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:21:57 +0000 (UTC)
X-FDA: 85089202674.04.B242054
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6AEA6180017
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:21:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YPCtKJ/z";
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786458115;
	b=GyQKhbUIErpsS1LuF9Rcl8U0vsTr4rB7+v3tLxYpJIPaWP58q8xIygvoc5YP5lhiVeCEMl
	n4qYn4aaBdKQ8DhJPiA9WkbQQBr35N8hnSmk6+CY1Cdrjb+ixPLtbSjmI1Lg5fcJebNSmJ
	hJzX5PzcwcyH58pXjLb+QpY6eHbmp+M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YPCtKJ/z";
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786458115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=peLTNi99sZ2H7Vza/JehbVMvGp+dy+fil6mDbDYjoZg=;
	b=Deu950/hMz+DKB5w00ruu6zIQwNy8bRGP8TTEv145tl71kTrNdAlBnow+vVpMd4isJrmU8
	WCFMOqieI/QUZPN83D6ynw5t7qRfgDc7+yVuX8cT/HitutW7xsVm9e+IcGoFTlC9QsNjQ8
	CncdOQ9gXq3ZoGI0eZHfV9wWrDLWMNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8B76600E2;
	Tue, 11 Aug 2026 14:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DAE1F00A3A;
	Tue, 11 Aug 2026 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786458114;
	bh=peLTNi99sZ2H7Vza/JehbVMvGp+dy+fil6mDbDYjoZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YPCtKJ/zhCkCva4zFXUg9jO0YrPFvEl3WZ35EO9gz/4m+jyCREP52lFOEZrhmVmVk
	 q9OfJLHxHqUsjDq2iSwSN3HjUTEJRNhQoDlrVifRm/ann37gbHQdF/4wz9DsdKHjvP
	 ZJ6uHvmsXixubav2aJNC6A2MkcNMMtF3FevXqxqA1wqLoqxr3+IFZgwVn52lHIZkpL
	 zXwj6RvKGMr94+Afzh6G5wQSGR7JlfOP+n2BXpVuwphQpzxrDGftS46MCMjpSCZh3Q
	 SGbkmSwbLnjhckbn2ndILydF5mh0Av9eFOl//RFKqmT99VQekhyFRvTxciQYdjEhcr
	 08P8quJLKeRmQ==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.ams.internal (Postfix) with ESMTP id E701D1980047;
	Tue, 11 Aug 2026 10:21:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 11 Aug 2026 10:21:52 -0400
X-ME-Sender: <xms:_C97ap8d0FoZkFK0U8B_jPUlI25CNWm_y8ZbhejD4KGHL8C0CmxzGQ>
    <xme:_C97avy5oSXUCjPbMMT4DF6qHAv4BUid2Fl6ZWfUy-6WZ9qIyP8EE7Qjm0XcFPGii
    kgqheceZtwy7DwXG94BzEpeKG_I56iSjGVsJ5aclGpRszlBCnfnjk4>
X-ME-Received: <xmr:_C97alKeGcjrQDl3nk9jA7wZ2kgu-INHs-aeYF0DZSrfv8txGmnRMv0Pob8>
X-ME-Proxy-Cause: dmFkZTEF+xcj27Q+X7YiPbPh0zXmZ9K4g7JaWjhfenTktvgKuXBjdkYrtDhTVEfZp35l3O
    Ci1dFFfWSdoRvqSIMzAH3oul02hDp/yFssBrCleZyfCcMMJ7bABwPVnJTTsrQdiD3SYYrF
    ZgkYBReBlR0Jqo2nbAIUMgtdUcb66G1uaxfctkfRihIcNFyrtTNi4iyFMVLzXAdFir9AfH
    txxbhKcaVGmzkR70G/VWfO2i1xKH+IEVFz1/1J8SGfHsB0eej5ky4FcvMVrtKFljmAHtau
    sCfeEiDCS31F8DXg5RVacCP7VEf8zwTAdDxddoNko/n0H+j0G0wuhddNVvVFdlkKrDe9d2
    yaJTVcmZCsY5LWhbjEM73hg0/3Vkx3DxgaBNT7inqhday9p195l2w9Ja7xVzGEx3cMIjzG
    NQzSmzELkdrUvEkJ4khuqC9ClO3ImUbOpxMp+H3eFxcCA5rNQR3sqfzaWcFi/As17VnBr6
    6mMTThnUasH6RSgfFrbAkFES9iyL0e0l92/UqdkcmrqkX68Sas8tEDFSzVUNxlDApiGbSo
    a9zdkI+3dWc2qAXGpIBTG31pNxvJolZ8YcG8VVT+efMWtq4jUoGgpJYP9PNFA9w402v2EP
    61/b/g9nTcKTfKcTfQHltZnRUtUBBj3wg7KaroulzYdaukXjioIrB4oo1Y+A
X-ME-Proxy: <xmx:_C97aiaJk_Lkq5nrfzq9zS-lfKB70vRHyJW9p_mGL7KsOfN_RC08mw>
    <xmx:_C97aqzmI9RXOFCFxWcTFUiNLuWEOdpORxJa-WID88g9gawgJCXqkQ>
    <xmx:_C97apbBOzb2dGyqjYipUQKEd6LWEK4qFHIbBCvVViul9ZiOWd4VsQ>
    <xmx:_C97apzC5nXKXBhOHZnsSmEjTRZl3lLYzXYFzWBi7mRqTFp7d_TNvg>
    <xmx:_C97alGDC0UdErQKXjJCK9yiUoqAK5XdnOU2lDgSLDbo9wzdp2zwUXW2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 10:21:47 -0400 (EDT)
Date: Tue, 11 Aug 2026 15:21:46 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v5] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <ansuaOyItxGTBlTl@thinkstation>
References: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
 <ann9Kcesyb4T9Z8b@kernel.org>
 <anr59P1ZCAuHxv6x@gmail.com>
 <anskyrEVUlnTVEgF@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anskyrEVUlnTVEgF@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6AEA6180017
X-Stat-Signature: z9q63145kuny7zooo3q71drpt7wrxgis
X-Rspam-User: 
X-HE-Tag: 1786458115-920500
X-HE-Meta: U2FsdGVkX1+C5FtNYJLyw6ho6KsLcEt8LYF9w/D5IhxkLIY+WmcFl1jI/hobFdN+fD2fEPATGPA+a/vMKsXp55H5lUQAY1QJi78gb4LNsUWml2lh+eNp//HVKnYn3vTu2rPSjHySWqmoraGfj1TnVQXBRWZC8j577WSJ32PaOgMI2A+O8UGXwPHHT1hb3QFOBPjcDM+uJ3vGmp2vFj8LDL7yHx6Im4V7B/KcF5fsMK/GQFgRq3V27oPZ422Mdi/tTT8mjr6O6WloxPj3oLAQbRyVuTMYWUqcQDZDJ7z2PxsP77/DuLidzTaDEk1NTTRrWvBb/2F7uDhhWTUTRkCaHrnUMm8HQnLSGJKEeIGs8SXDRPK5Wqlu678zyrqzeTBBcSZVMkJ5fLpDfCWkLTXpC0MP+DtR2h8U5WNJVRc656+QHM/MRb3dOfjtS3sEN8ae+GFZNTPNuit6uWexkgbGQaM7y6smSYpxa5yMLs+0bGn/HQD3pQMJtPNVsDC9uyJqbLAZhPiB1mxlv0CYP/b5AaLT+bR2wwTFhOcJGkCch+79jjT4kKnPQcUIMxQUyHjhwqziiLWtcmurbzD3KcQRBXc7bOsnjUAAE3MBVivdU1TGJKEaa3e+Q2ywrgXr5mWBcLQJa56XXNXnbVinn8IRTDj90ycbUS/7N74recmR3TzTLk4KlrN32PVFO1TdvH4NB30JkzJbMTZjDHtUQYZi8+J6My+4EIKFCmaKaDICSrIdgqyZgXPTpbwpZtd1NxPLz1bgjH/Ihh0ef0aNHdnmlEgBo7iGASoubVHh3l0v2EQErB7EEPctcG95EmsxlchL38HRBubFnZSND65bdzHPB9xXKd7tnngym4Budyw8tFMRsYg+4eneX5DPg7Td6x13cRpYqmVRVJuFvZ+0PK2EFafjZ2f/mXblqJPBRHPvSRrhH4u1YKQ0WVsZjardEUTzJLI1EVqoQRKMeDDrPwQ
 KVscYv8X
 eg0dE1dBY4NqH4KwKgCFa4NE6fc8waWplaSAjJnbHxgN5YIm6kEAJ9q7tjhOoclwkeRq2CKkPccMFFw3yJhmB64L2ST5Ei9gaHfHJWEiPYyaN/oUL81xEOEIdIkNByHHQU8vmlhsGE+O5Og4Riv/FHqnG5iuuSzV2EevWT4Symd1T13CAHAyNFV8vaoAYmNA1TsAYNQ7Zag3RdO6Dc/+9QrmnVCXrEC85WwBUHyKRtHV2Wkr4pcHRrTMbKVXV+wtLqcxR+oFq2wh+D9G0l/DvZk6zik7VPM6Rbti9e7QpMTRS4QFZxH3At+yR4m3ZgZNXy3ZLRnkxCFx05LgH72Ymp24huQcP28j1sN9W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 04:34:02PM +0300, Mike Rapoport wrote:
> On Tue, Aug 11, 2026 at 04:17:41AM -0700, Breno Leitao wrote:
> > > > +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
> > > > +
> > > > +		cond_resched();
> > > 
> > > cond_resched() for every pfn is too much, isn't it?
> > 
> > It is what the other pfn walkers do: the kpageflags read loop in
> > fs/proc/page.c and read_page_owner() in mm/page_owner.c both call it
> > once per pfn. 
> 
> I think it depends on the pfn walker, some of them cond_resched() once per
> "block"
>  
> > But I honestly don't have a strong opinion here, though, happy to batch
> > it if you prefer. Would this one look better?:
> > 
> > 	if (!(pfn % MAX_ORDER_NR_PAGES))
> > 		cond_resched();
> 
> Can't say I know the magic number here, but I think it's better to batch.

Hm. I thought cond_resched() deal with this internally, no?

We call it in pretty tight loops, like clear_contig_highpages() or
copy_folio_from_user().

I think adding external batching might be a bad move.

If calling cond_resched() often is a problem, something is wrong with
cond_resched().

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

