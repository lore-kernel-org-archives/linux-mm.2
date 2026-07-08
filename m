Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFBE7C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D52D6B0005; Wed,  8 Jul 2026 13:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986836B008A; Wed,  8 Jul 2026 13:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C296B0092; Wed,  8 Jul 2026 13:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 613806B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:46:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE77B120234
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:46:52 +0000 (UTC)
X-FDA: 84966339864.16.BFB116A
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0632E80003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:46:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YmnyUW02;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783532811;
	b=DJOtxIukpb24/xXLwktLrc8L+MKMX1XwhapxVIZ5l8/3Lq8UNWbn47On5uZctn/Xra/sBH
	o3+W2QmfREh8aV7tn7XdQTiXIvnJe8zf5skQp/EYBDCj4V/Kzmy7Z20ezoFZr93fgKJSCE
	wKbxJ26L80fg0BXSrCcwOvSRWsL9QFA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YmnyUW02;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783532811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T72id7RPi86+PG3iZJFHATNYzmFCFJW00jDywLiIkEk=;
	b=RbJGZtVdyvPTzyZoapSmkbVJGD766P6jHBgsOg5/tEws14k5xz4UAdxmcwlThMXB/rtvcT
	F4ODrORm1FcKfl73vNXQExdw0gBGvLk869bklz0nnfLhzHVoCewibZiEypj8V05X4w5bm+
	xO8nfEbkTrrEvfkss+n7laenYtpKFUY=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cacef7d299so7905ad.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783532810; x=1784137610; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T72id7RPi86+PG3iZJFHATNYzmFCFJW00jDywLiIkEk=;
        b=YmnyUW02+SAkDCuRtqmPytY0IbDkWxC6RuJEeQgPjV07Yt258IKp4GkiHVQga5Bjh6
         dtaeMHtN0NgFo/I6QOf6d258/TZnDd6SwrIaqREjzm+aP+2INOvJtwVieNJmAhX2GLRJ
         7dLsAIc3DDGww/g1hjPrHDbQUWbwlWLDw5zTyyAOKovrfHLXaPlA07D3f/SBkmgfEAxB
         J0mCmjAvv5cHtsUaY4FyNsPqp6QJ8s+h5E9riaOl6jXQutffX/o+4q4iBesVN91fGdVm
         gBjIOWwfzHEoSHaPHeOkkzq79ySr+PITDvrWsvLY+Lz3i1d8I0U4+w80UAazieTLQshb
         zolg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783532810; x=1784137610;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T72id7RPi86+PG3iZJFHATNYzmFCFJW00jDywLiIkEk=;
        b=KXrJuEzK/E3Qlrqe6OOvueF3T7OWBXySd6z26T6pTk/SldD1Pasm4e1m0nP+dZARNU
         FRXIVfLPotBTyg13PkeQpoM4cmo8Q/7S85y11bkC6mnZ5aBwbetn7mWhkR9k/428RDEo
         OzfYwh88FyKqoo2gGHDSfNcGSMK+7TvP0EjxaGVJxUoATYTSjIxLk+icWNN4m+AH+FN9
         T8ApYxa5GQAM+jWGOBX5vbLPhHkd40/v9UcS8pJGGSp2U5crReOVaLkRqkHrrUd5jcZ+
         LCQc8g7I1oB9khXpTcahce8LkymALlwiSsCYriYt3LETYVEbpDGLluF5BZq4iFRn3bjx
         8IKw==
X-Forwarded-Encrypted: i=1; AHgh+RrQMXFNOw2qZTRANm1yMqhquz5DLiF7uOE9nankG+Mb4hcJygW0oFVWx58dp5H9s4ub1ZEgUTO9Mg==@kvack.org
X-Gm-Message-State: AOJu0YwLYrkEI5K6vZT2e5kWWRbmgtyZ91EYsKSYpq0lMKyBz43ucUpa
	w8ceHiBBIufBJq8hZri1EBf3/UJGUrCiMc7mKym3w449fh271LAPGGJmgDizYJs2WaUbtza7EeT
	uO3LBYg==
X-Gm-Gg: AfdE7ckVGflrBLhF9tTcKY34IV4/rmXGntEZDfGj9dE1N6JgULV37Yaqx8VMjQpM46Z
	qYNMVIeFNGQdoIQURLTc8R6FBZugFCKY7hXO4azKsv0CSJSLJw52gHYRcsRzqC9dHFylvAPOs1m
	UcP6qVVRLn8jVWrKgXP/OnZ777/xLRs1+6DJWYNGHT4H/5fXyUflAWZpivcrFSJdsThVc79Q5tk
	MTgdVQgtVkEe7w4j58tYDaT9PiP8wRygikXRYZGUKsDegyr68Q543h6KACLNHnv8hsHfY2V8Lsb
	XDonOhsu2SJBzz93FiwFEO29NCZX2rZSfL5iJODSA7g/25Scn6ht5eHtvNbDJN16NYcr/b95GJm
	jZK8yPu3CUoJ/o5kxHjzlFXJdq07Lp9+EJJ8MpYjAiiFB5SFED83rJvmd58G85G7K3UedrPwvjv
	BzU3kU0wJpXwGqw3130d4pXMDi/QvG23SC5GX0lbwy4ttVDKA=
X-Received: by 2002:a17:903:32c7:b0:2c9:a222:47e0 with SMTP id d9443c01a7336-2ccff85d2fcmr469435ad.20.1783532809401;
        Wed, 08 Jul 2026 10:46:49 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1eea1sm31610665ad.46.2026.07.08.10.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:46:48 -0700 (PDT)
Date: Wed, 8 Jul 2026 17:46:43 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Pratyush Yadav <pratyush@kernel.org>, h@google.com
Cc: Samiullah Khawaja <skhawaja@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
Message-ID: <ak6NA9-sQIel1W15@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <2vxz7bn5mv0n.fsf@kernel.org>
 <ak57VeunO8qd4wEh@google.com>
 <ak6DUC7NsIZ20RZD@google.com>
 <2vxzy0fll71f.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzy0fll71f.fsf@kernel.org>
X-Rspamd-Queue-Id: 0632E80003
X-Rspam-User: 
X-Stat-Signature: wpooewt9eibmwcp3y67gwbfejrgm8cxi
X-Rspamd-Server: rspam03
X-HE-Tag: 1783532810-808175
X-HE-Meta: U2FsdGVkX19YF+tdw75GNzrRmKiikVyZLihJ5O4RbQrjAvJAUQbSyn9qS4cQNBnNPLhEN5OfElF0FI5YudcaFP+i5ptQlo8rrNspEMJdc1usABbRwzR1Zkd6OlWMS06lfNtckcRRE5qtFHvQE7oGyi+tz1UV2/WmqmF6WZhlz5Lvd0OBpy8ZfxrVhLUw8f+JiFN5LvhksXjA5jjR+RZUox7n9tmuJLCu5QvzWzpXv/89JBeYHUN6gQSNtLdj620yR4zetsLMgogz8YmZqM6z1GGrb/Dyxf0g4j08ZGkPHC5sNH7RLb6gOlwtcjNeoQYVTe36sZG6neTxCnTgbW806M//9J9bEgJMsu544VdnGKZGRMEuHNMRruknCL+w6bj9z1q6Xxmt3EOgX3wriPZDSINj+sGS+VkzIT/JTN3ZRM8sjHsPVhFymEjrG65IlXH49FU9W4U+xHekobTNx7YkbEkLuMzpjIeeSa0Wmy7fVieV1oMsTMa4otlMe2EzI9FMycQJSCIZZapcrUCZKEt/HAAaooUSRVQrGbMbmi2Lu2rhhe2/LPaPkXokq2plAdkbkxSjYC84uhpwCOVThkCqn7Q0C6PO/b6lI/8pWP9LfGMC6fa1lvqXytWupbGpSTMdtYi/uqr2lPWHJlyIqiJ8ZljMnoZXtL+PQhQZcU1lm5KEiwDzMHfBdcLjZFqKbpijCbdBHRMrD0fhvdVZ5SlyDUcPmwxn/7J5R8fB92jNRDtBY1oww+HfCTjyuE0BNjt1Q52UCvRTfrcCZoglif6UeFT5GFfFi6OX4Sf6FtnLC2zwTChZAXpeC6+k60KrES0Y+jY3vuAnYMvwDFn6XkeixnWq0tZVDqzy4kbd7z9o1y1tcn3Nkrfy9TLNgp/wYm/4RbMDVHLhgjXMZ7/WzODrw/UpMqMPEbuNAhqrhhx/5cWYXDoGbd7+C5Gy3LFgM9mSi/8d8PxiQf3qfnx4xnO
 zlQSrQkU
 6EtIWWTmXxAINn/jUKt9NPQi/yJ91A8Fv7FREzWFVCUA3HB57aWXp8V1xPd9GTH+86eM91HELaEwWuYsU4M83g7MqNAiTpcVdsldoM4yBIw6BjBvpaAvevUPgSLblPqLGdLYgR27tgGXaVRPAYqGxOaOeHgyEzEDVreXslVDAjDuCkOYvPJn8KEzTvmhFzvLI+01AiLAry64s1ZZuJkNiAyif71PDY5oTGjOSuvJ4IQxXfEL4zz7fi8r7o+MOmBlkmi4IX+xxT6T+WGJmgaPTv2YnHbTR3mpoyghMRSFQsmb/ng+A4xfxEme32dnfkFFYaFYNSxgFad07QxC0Ba9v9PTLEQe3k1YumEFWsZKNUXa6lPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 07:34:20PM +0200, Pratyush Yadav wrote:
> On Wed, Jul 08 2026, Pranjal Shrivastava wrote:
> 
> > On Wed, Jul 08, 2026 at 04:36:46PM +0000, Samiullah Khawaja wrote:
> >> On Wed, Jul 08, 2026 at 04:11:04PM +0200, Pratyush Yadav wrote:
> >> > On Fri, Jul 03 2026, Pranjal Shrivastava wrote:
> >> > 
> >> 
> >> [snip]
> >> > > 
> >> > > 3. kho_restore_page() applies the correct refcount pattern based on the
> >> > >    preserved metadata.
> >> > 
> >> > Why do you need to save the type of pages in KHO metadata? For example,
> >> > for pages or folios, we don't store any type information and leave it to
> >> > the caller choose the right API. So reserve-mem and kho vmalloc need
> >> > pages, they can call kho_{preserve,restore}_pages(), and memfd needs
> >> > folios so it can call kho_{preserve,restore}_folio(). The radix tree
> >> > itself does not hold the information. The caller knows what its memory
> >> > is supposed to be so it calls the right restore API.
> >> > 
> >> > So why can't we add a kho_{preserve,restore}_page_multi() (pick a better
> >> > name; we can argue about the naming later)? Then your driver knows it is
> >> > restoring DMA buffers so it can call kho_restore_page_multi(), and KHO
> >> > takes care of initializing the pages with the right refcounts.
> >> > 
> >> > You won't have to muck about with the ABI in that case.
> >> 
> >> +1
> >> 
> >> I think this makes sense. The mm already relies on the allocator to
> >> track the type of pages it has and expectes it to use free_pages or
> >> put_page() or free_page(), so it is natural for KHO to rely on the
> >> caller to call the right restore API.
> >> 
> >> Lets add kho_preserve/restore_page_contig|_order|_nonsplit and the dma
> >> preservation can use the appropriate one during restore.
> >
> > Ack. I like kho_restore_contig, I don't think we'll need a preserve for
> 
> Dunno, everything is contiguous, folio, 0-order pages, higher order
> pages. So not exactly the best name.
> 
> Since you'd get these pages via alloc_pages, perhaps
> kho_preserve_pages() works better for this kind of allocation, and for
> the _current_ kho_preserve_pages(), we can rename it to
> kho_preserve_split_pages()? It is a bit too wordy though, so that's a
> downside.
> 

I suppose this is to preserve unsplit higher order non-compound pages.
kho_preserve_unsplit_pages() ? 

> Mike, you are better than me at naming things, so do you perhaps have
> any better ideas? :-)
> 

+1 would love everyone's help here :)

> > this though? Preserve doesn't seem to be preserving refcounts, I guess
> > we could rely on kho_preserve_pages and the caller can use
> > kho_restore_pages_contig() to set refcount correctly for unsplit pages?
> 
> No, kho_preserve_pages() can split the preservations in unexpected ways.
> While for a high order pages the current algorithm _shouldn't_ do it, it
> is simpler to just add a new preservation function.
> 
> Move things out into helpers if you want to avoid duplication, though at
> first glance I don't think there should be much.

Ack, I'll add another preserve helper.

> 
> -- 
> Regards,
> Pratyush Yadav

Thanks,
Praan

