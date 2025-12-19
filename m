Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A61E66891
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92496B00A4; Fri, 19 Dec 2025 15:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66656B00A6; Fri, 19 Dec 2025 15:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92DA6B00A7; Fri, 19 Dec 2025 15:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 963E36B00A4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:57:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40C6FB6FC7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:57:06 +0000 (UTC)
X-FDA: 84237430452.07.686EABE
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70BB740002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:57:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j0yrxQeM;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t509bwztenot/CP8kNyRzbdexzlGui8MOb3iqN5WlEs=;
	b=jqM82iouJYxohO/PqRWNNUxybW5z8rOY/lCg3hEQJaA7jRuxgSHlQ6LN8rZNUI+wfw5jU6
	m1s2mjfD0YkGdoV94un0u5G6+SKL2XQHAXsr9SVQshD6PyE9kNM+r9N2XamuqM/LPdRg8+
	ozpMKl2zI9BTzmsifqjHI+jFxxyPMeE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j0yrxQeM;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766177824; a=rsa-sha256;
	cv=none;
	b=UDcJpKWLW8yL/xLPc3H3OGShRmf8uT+wlas4v0jPNOqTtlseF4Y7ygwHPj7d2yFJtC0P2Q
	h+SHrwES5yCcXL0QyAs5OVDLiOBlEl1OG7EnzU9A61TJIbydDf77DC/Ng7Hc5fQbqDxa2N
	RdxoQyhHxNczd9omlOS4X4d6lb556v0=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4f1ab2ea5c1so25886061cf.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766177823; x=1766782623; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t509bwztenot/CP8kNyRzbdexzlGui8MOb3iqN5WlEs=;
        b=j0yrxQeMSHpfPQauwIf78bIVGOduyn+9o4vZGq/fHh+cFUhBG8UrIO68jPPa8TkJBG
         PkMW/9ypgbNQJjdbqUyDagLDrt7fk10BR3qwApnxC3U+ZZZk6lGoeOWopJh+o6xJgayY
         Uzl/MOMIv+rY3ZqNWurOfhJ4Mc4usC0dBkVRJFMYhpNnkDJQlrZ5dPixwgcOwfPVC5BE
         rBL7lriVA0/IxTgo3VBWqFgVHT9akD3qtc0Ai5C7gLZjPVyoIy4sDV92+jd6mFKDZ8FQ
         u5JnFT7jf7xsmT4dzHVyhHD3E50v8Xjm3z/6lFpoMDTVnx8yw2OOwOrxQ/hY07J5LWG3
         BYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766177823; x=1766782623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t509bwztenot/CP8kNyRzbdexzlGui8MOb3iqN5WlEs=;
        b=BQAW2qil5k80dU1ST456UVXF+cajYzHFwlAFT/gOBh+fpFXyBexx7R0thnl69jvv+W
         a8yURz3YncqgQD9XQ4mglYBO47jAnk8lfxBa2FjftAX+cg2kgJR2huo+NH27VLvafpeD
         uK0XpZP/aEY4VRbujT7ZpVp92Sf3sR9EzmRUC7o3oWvxnbvXjRmFgU4ZtL8PVgqqemsr
         EC6fT1c7Fnk75gHaijIdrMM6i2WW4nbFhu2km0+mLvvJY+5qKhJ5tIOFt4ySiYz+3ehR
         smwi+Lir/ta+pOwX/2ix+UY5a9R+PdAyEA+m0xkc9cpvEV946CH1vsTVmoeaF+exRxnF
         zi2w==
X-Forwarded-Encrypted: i=1; AJvYcCWtUVO8ASfytAlvPIOEMRFX86JYzw1l3WgUrMCgMIFgiHNJ2Mnx2CBPpLVfZCxvdx7qWM/0n80uPQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2CRXhOC8+aOi6Renuwc6NDhCk+6vYsnGTeEAfP+SOtk2uuzXN
	8XWBOqDkasjDelSfz5cHfksBC9/XRiw6KyQm6a82DkZBd+058DUbuQt4VlD2L9JNDYw=
X-Gm-Gg: AY/fxX4Iku2lsrTw9sdZDhDBJbLDaChHS1L4n0JPSGHoWx1DP7EFADo0p5cTlRoTAzj
	awjKIeNcYKaeg/j2OqPCsAh1HwhIz7l7Q+LV2pcBiIipwwJa9+I5dmusj8o6BHb3ndypuHZjGrd
	n9npQATPHnn7pIrj7GEw+Dj8RyBE5su3C1PSIewCUKeFqg6xbS6E0Q9BggJy38R0PQkizcRhe5R
	lRfc/LIHslyfDNJfeUOzbdSfqzEHQ1FzdxiJxtKacTo+GrkR5DpGhGCkyVvOG6O/GJqNEQWWy9P
	P/i/Rnd/xJw7YtuEdyLieWh2AySoQfDj3tGj977VH4nsV8DoQqnskpiJAPb4hyvUQYk70gj0QtC
	06Bf1oCpAHDgzrTiFs2M8GIZ1Mb2f/tSblWGwwXYq6FUCuQ2o5kKkZwUv5mvc9Z7OzhNrOwXMSm
	CDgvj6KKS/90rvTRr5Iran4ytcveeir526J1A4c4YiJ+K6i6lMb30fUQKL3ODw+mhaMFsZ8A==
X-Google-Smtp-Source: AGHT+IFcc982nWdpBtU/myoa3OSL4Lx+tf1/WhI5JBF/tQgeQcpMo4ERuhRNkwwEGYKvbboveZfS1A==
X-Received: by 2002:a05:622a:904:b0:4ee:2459:3d6b with SMTP id d75a77b69052e-4f4abd6e209mr60644641cf.49.1766177823513;
        Fri, 19 Dec 2025 12:57:03 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9aa3ac8fsm27024046d6.56.2025.12.19.12.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 12:57:03 -0800 (PST)
Date: Fri, 19 Dec 2025 15:56:26 -0500
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	osalvador@suse.de, rientjes@google.com, david@redhat.com,
	joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v6] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aUW7-sart2k302uO@gourry-fedora-PF4VCD3F>
References: <20251218233804.1395835-1-gourry@gourry.net>
 <20251219000800.tnpqzvcdyeqcwryt@master>
 <aUVgoEiaXj94IBmW@gourry-fedora-PF4VCD3F>
 <7EED2D83-AE17-49CB-BDB6-954793EAFDBF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7EED2D83-AE17-49CB-BDB6-954793EAFDBF@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70BB740002
X-Stat-Signature: zcujo64xk3gjcidyqqnwbrcxnutd6zns
X-HE-Tag: 1766177824-860188
X-HE-Meta: U2FsdGVkX1/AI8nfJMJwbjPREpCHITRaIuh0g5j77NnaKLOwfV/JVxhtGmDg1EU7+FnNSNrTzmudFeW0ohp7ZXdUTFpIDaqpe/+t4DeUxtjzIEWcb4KE6Wj1HiwpnSmPH630ACCuK3in5/4nFsrv0zO01LZ+G57mXx3gtqKTii+jbY7qxIu/nItbnrQt7sUY+UP1ButWw0st9VweOYHk4ag1s/bq7kUE+WPs/sMYwTBSlpUms/aBm+Skaz1xzIK5h3tILMVfXW7PehGv8k+uPVZYS7SbgD4byB0/rJXhDRBMugL+X5wCfKygp1bi8KjprQVFRXka1QriTxDPSEA4s+Xs/mDt9fbU6bHhOtp0n8gNK1LsKvqT0ehEcNeNEPvwN339eWnm060i8iHSV1DqoRH8dDsP+VSCEXZ+taXVYQL3JlgzhPLxAu1AtINtrzee6+0+FduINm/CwLLRJVLxoMFA8iLFtj4VGn30zYhSBv1LP66MBL3fJNmIXb1/2hgsAT2/w7LIPAPdEZT+eAIQzAwZqjf5F8rjwSO+Db0MkIub/dL4mtHCM6WHrPNFslm/o3qFgM7FgzkhEnbgDUvlvge7mrPi7lRfSDeoQ5RjHo5m3Y+OHCoyF1+DTEqhObbJeJm6yRu68sIq1CFop4RCjIK38ysWXYV37zN03aclTacwz1B9OY2BwBRYInrvkq2xg5wyjFpKbIVgI9nZN5EXjyUmooqBlD8M8/zMgUfsf1n73ZYP9D254n+w+1ws2EtNH7mQfWP2dDT/Om3EsVXkezYAi47OEQkc9Se+LOqvKEXU2oRMdFkI5iIUhSchGPmRAB+AYxTwtL+wfcFzLFkuKIWDaACv7kEnj4kQmbAsUCMfXlcOepBcTAznfpZF8rBS3hqy7lTuk0sh4v6S6ViyE+juodSZfusHTDGhqrLpIG260l0z7KfnY35qL1JZAmQ1ixxvUxtnA977UoJRwhA
 rDDKZyym
 HpUPOTwpUrM8Pafji5lNn3SsTP76AKz2DeUnbrs6Ark4aC2MOMIqAHXvpFUjxf7ym0+yYpEi2rTRUHECq2HE2rviuGm87VuOd141fmjpIuX0Ah5vWUq5AnJ5wsin+TEiGBNcOKPqSGiMvEXa3j/LBPSYYT7fgV0osqjjy1VsQIJJBwSomfQB5tSufP3jAKBw/B+qT9nu4AyPNSTCHgg3qT/GzGzF+5JNHyBos9HGHdYbAq5CI/GkRXlUn8AnkRhF2jq9iYjHNk9mQyelT+EOv9cOdrkAgsodyZ76ldc+N0t3G12I4e2kYyYymIu/jTTFMlFnrA6+QUm9n2MN4Y4mScfc59u0fndef5QAg6zsyy5bcdAmrhi0TKbmkjTp76bPCepbRyoB9pgp9XfAxd0pbBRzIdMD8HClN7IIBhSLfwkRNYkcvYwbGKdvfSHiVgcZCgfpb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 03:46:25PM -0500, Zi Yan wrote:
> On 19 Dec 2025, at 9:26, Gregory Price wrote:
> 
> > Will think about this for a bit.
> 
> The sole caller of pfn_range_valid_contig(), alloc_contig_pages_noprof(),
> scans from the beginning of a zone to the end. pfn_range_valid_contig()
> should see head pages all the time, except it scans in the middle of
> a 1GB hugetlb when alloc_contig_pages_noprof() is asking for a smaller
> nr_pages, like 2MB. But in that case, the if above i += (1 << order) - 1
> would return false without reaching it. Basically, to get to
> i += ..., pfn_range_valid_contig() needs to search for nr_pages larger
> than PageHuge(page) and nr_pages is always power of two based on
> alloc_contig_pages_noprof() requirement, but that means
> pfn_range_valid_contig() always sees such PageHuge pages as a whole
> within nr_pages range, thus cannot see a tail PageHuge page at the
> point of i += ....
> 

right, and we hold the zone lock here, so we shouldn't see a page
suddenly become a tail page mid-iteration.

I hadn't mentally worked through whether it was a good idea to encode
this behavior now with only one user - but i suppose there's no point in
optimizing for code that doesn't exist, so i agree.  This does seem
fine.

Thanks!
Gregory

