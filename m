Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55FC2D3CC83
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 22:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1216B0005; Wed, 14 Jan 2026 17:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EE16B0089; Wed, 14 Jan 2026 17:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7ACB6B008A; Wed, 14 Jan 2026 17:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 941D86B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:12:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4075E1DF179
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:12:08 +0000 (UTC)
X-FDA: 84331968336.30.C47F554
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9F15A140008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:12:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WSuNNom6;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768428726; a=rsa-sha256;
	cv=none;
	b=O72/cjcQGcV8rq1XHYLoi0yf0wMHjsujGZIJXITSFSwnxVXY+MIwuHS4foMrkC7LkWVi3E
	6UzsyRb+iOQTMQJbP6R2UHB0qNsM1OSxXg1bPp6MwCWRjHTjVPDZVexXrtCM3TwhkbwWps
	rJ4/dJooy88R6lInMfNoAhHVLAkqeck=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WSuNNom6;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768428726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSRcG995XydfiL3jwGFnTPHyOQQqVgj+rZVXeEwdYvM=;
	b=JN8nkOx4sMkYQL3LVGZNNF2mqk4v0gO8m5ft92FpBBdhkj4939yj6F38ewJEkKobfguLWC
	4kOci4DnfZTzq0+DgN3nGf/+XyVSa2W3cO+mAkaLV6o1ogoOgOEubwPIxUomBSWup4tWMV
	Ti5MXJqFC6hFPK9VuatG2JVaT+ZBqYw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF3216000A;
	Wed, 14 Jan 2026 22:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01033C4CEF7;
	Wed, 14 Jan 2026 22:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768428725;
	bh=t5WWRCehJoLylAD+uLC9ZU6ijAK40ffTm6B6Yhk+ORo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WSuNNom6LSt95XERmTGPYvgiAT7FgMuu/OJHMHhSrrMr/BB/rY8B/qYezagnd6lNS
	 MfsU3Th1CVCTSqLcxSp8b+PlMfjGErMD31qESGOHa9+ejBISiYs3EPdvaEcB+Ud90z
	 H2cAfHKkH69QDFOumPOeRmIL7M3w912eyX0VQ+hk=
Date: Wed, 14 Jan 2026 14:12:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt
 <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, Rik van
 Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn
 <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, Chris Li
 <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] mm/rmap: remove unnecessary root lock dance in
 anon_vma clone, unmap
Message-Id: <20260114141204.d13c3a00aec1333e8ad45a8c@linux-foundation.org>
In-Reply-To: <2808d8d8-e772-4210-ada4-2b39d30c7029@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
	<9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com>
	<CAJuCfpGcdZE_Qnm4c7MgyZfZr7fepXuJkc=6ucwUNwUo_JjU0Q@mail.gmail.com>
	<2808d8d8-e772-4210-ada4-2b39d30c7029@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gmr5nbnn4u5umq4qsh6r1933ppkrri4r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F15A140008
X-Rspam-User: 
X-HE-Tag: 1768428726-670432
X-HE-Meta: U2FsdGVkX1/4IZsamS/tGJwyJ1Edv+HgrDL/LB3DpK/rn9ACf2bUV5R0dxmge4vQLQYYR8qfzx6UMyysxNVqek39cGnE4lrv5NOto+LbY66YW23O6KlZcPKdYEM/SiHlr84eGwJpM9I8kooPMfgC+U4dA6aknIc4Uhd8ulYJmS2sbWrUDFhanmYKJdKS63MsKdMm8g3jO241MICqpZ9LxjxIFeYqx0q2rvQ/auP7aYgkG1oIves9nsD6q4cRdf5pbGOJ6VjM9itGeRWzn6duHy9WrgVgCl484OCkZBxxyfTU/Y0XV/ybLPQ92vSmcmY5KAIxAtGDdYxTpbLTdd79WIHXlGV68ZmftyrzWVT/fPWqPl8vaZ+zDUJJIznR4CmhpcG6vUSRVibjeAcxCvu4XCM9VOz6VH2QRPd8+zpB+ysj6g938CpcvvJ0GMA5X2/AW9hV7VYtLTSmgg7YMTCotzsSsPc6lpdYcpppxPBZmVxsQLlikDBslv8wDFacSSv7cVCA06nWxptMFvzMpx2If0Ol1+hpv+Ay6js0kRw56wnj1Y3ysggvV+Ro4GT1MCq7WuYs37A3LO9wWOF5GEAfp8X0aYOb2FdmaD9q251Rm8roaHDHjIg37WEkVlG05l83Otwjx/G8Sw05mi0PsXhijgs35eE5LdpGGIxESLfT3RMG/ga7FEi3+LyjqhcuS7wnpycUTJX18ZIKK30xVt8MOllV0ht9BDayF2Qfxgv2fredtlVztSe39NCwTQviAFSbS8KagB1V/LzRBNqNSYFCH8xAKSvONVHX/8FI1M2jIS+s6u4IsVNxnxQV9IlI61Ly7Yue9WqgJJNK8dYrjA/vMRhm7cE8SNbp0aZCP69vkddZZco3shWRnrpBIWAdN8hUvMXw9BDQNHxc96qTvuvgqz3cIXClzOf/XjJauMseZ+8emlSgWlkRWRUtgEPw8CgSIDs+KW5YkSfs/HCC6Bg
 tnovPego
 KbI7wvZl3xTyWJtmNy/eaozoY88d/ZTqM+AqkSu5o0HrgckMdDg3XvEtQJ8t40dXm1DDrAkTnoQGBW1WRppuTQartFIIItrxCSHXXCHJ8GZ7/Xeta4bz3HGXHzu/GREAf4SECCEFAxZS/eIUpnVSQJM2PD4FlE/ZZ1U8AyEzW+/rl1e0VqtzSmECJm6n0kYRpVqTlWReeLPuHL1kSBZ52/Jsybrppjq5Rf5Sb/Bf6Tovt/BRB2QJ48YWmT84lyMkEctshs47rlTFJgjjq8fCH+LRkZIQc5hzUejDEnHH2m7og+6qOTBfwrZoGMsXl1cn49HQI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 17:54:07 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > >  {
> > > @@ -310,26 +284,28 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> > >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > >  {
> > >         struct anon_vma_chain *avc, *pavc;
> > > -       struct anon_vma *root = NULL;
> > >
> > >         check_anon_vma_clone(dst, src);
> > >
> > >         if (!src->anon_vma)
> > >                 return 0;
> > >
> > > +       check_anon_vma_clone(dst, src);
> >
> > check_anon_vma_clone() was already called 4 lines above. I'm guessing
> > this was accidentally carried over from the previous version?
> >
> 
> Yeah I don't know why this is here, in the tree it isn't, maybe Andrew noticed
> and elided? :)

Thanks, but I wouldn't have done that silently.

The later "mm/rmap: separate out fork-only logic on anon_vma_clone()" removed it:

: @@ -281,17 +317,17 @@ static void cleanup_partial_anon_vmas(st
:   *
:   * Returns: 0 on success, -ENOMEM on failure.
:   */
: -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
: +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
: +		   enum vma_operation operation)
:  {
:  	struct anon_vma_chain *avc, *pavc;
: +	struct anon_vma *active_anon_vma = src->anon_vma;
:  
: -	check_anon_vma_clone(dst, src);
: +	check_anon_vma_clone(dst, src, operation);
:  
: -	if (!src->anon_vma)
: +	if (!active_anon_vma)
:  		return 0;
:  
: -	check_anon_vma_clone(dst, src);
: -
:  	/*
:  	 * Allocate AVCs. We don't need an anon_vma lock for this as we
:  	 * are not updating the anon_vma rbtree nor are we changing


