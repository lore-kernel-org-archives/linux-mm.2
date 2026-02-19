Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5498E9A052
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4290B6B0089; Thu, 19 Feb 2026 12:08:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406F36B008A; Thu, 19 Feb 2026 12:08:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340E66B008C; Thu, 19 Feb 2026 12:08:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22C656B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:08:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC1C81B5831
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:08:33 +0000 (UTC)
X-FDA: 84461840106.24.E9A5BB7
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 97DC5100014
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:08:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FrNV3ihr;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771520912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P54Wj+hR2onkXuiRJpCjcqzpj5LDoT8D1MY+BBs1EDE=;
	b=kKj0FfHbZ7PEQJB+MdgJsfwir2IQOn8rllAJ/Ah1ZifE0XpdAmWnUiuEYCcSrd4fRCrajj
	l7WfQr1cE0OvruDc4+QM4CksvQlBPhGb0eH8ftdW6PA4xTyToAR//kn5sPYLVIcDyBuYN/
	F5B0UAISxZqyFKWX3IEhIo0sFObUldM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FrNV3ihr;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771520912; a=rsa-sha256;
	cv=none;
	b=sf3IEwNNNpgPXvOTDCGyAO1p+UyvA5RPRpng5QKVHkHFbL0PGC0r2kApakMcQiK/KmQc7q
	H5dd76vi7Uud2aRKnOFuc5UP67xynEoUef2qBvqqWjStwyoN9ZFMRxBMye0mxHXwIP9XFF
	HDjy5AMPShqFE1aihQJ4k5nbazSeH+k=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8946f12b1cfso13318586d6.0
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771520910; x=1772125710; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P54Wj+hR2onkXuiRJpCjcqzpj5LDoT8D1MY+BBs1EDE=;
        b=FrNV3ihr3+y4nSMMDgYewSaxIpOQUezw0vleE8KkPQx2NyWkcSNbHiIdtOHwpkzb8h
         +86dciSSg2jZRRkcQb8H55S4hb2ShzfoGgy945ePWoYGvK6LzBG4ANZyExYJN+ko9sa6
         H2idh5gzJk5ROn5/0E34wG2+G5oZQiGvnfBR62EcwQWhufeKp7398awkf1EdWQibyqnT
         xgyw+RKIM4mkqTQgMXYRspG2sDCgSodzJfuChl1GGaZKT6teGdP5hjCFfN5dKjxlAfR7
         2rU6L4xHkfUGHX/SIuXUvSesm51q51eTxo9KJuTQGGz9QIlH4ggxX9ZrGlrndeRYVfOp
         5Cow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771520910; x=1772125710;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P54Wj+hR2onkXuiRJpCjcqzpj5LDoT8D1MY+BBs1EDE=;
        b=AjKda0NWiIaGUxyW+FVPisddlIvriAZGeq5UXT2MAhOdAsqfDaPVpFdKdCJMv84a1L
         6aJQHco9Nf3NbJmbkK2taFZirIxMd55+7twgy4IRsG9k7YnX/ierRk9iZCgR0CuqpjuF
         tWL7Lm5UREMh+4jkuR1wpMWoxZ5SsUH4r81o0qe8JvLZOmWyJdFZGbr0POiLUkMjfPaG
         nuKKXONWeZ6XZKu1HmM1DGAAAS1eeWHWsY8HVSqOxVpA3qvWVCemJXWJWxqs0HxswNpA
         zxgtfHBW0yUrwoxhLh3jhpbH/N6RF5cW9MYU8lX9xK2LZWVmC9Vfp14OseFB5BoEWKY8
         35TQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrF85vGl5shnqZsCXuQUWRNRk4DUHVE0DKr+33uQNMv37f81V4cshKK0WWa/iDzV3i2AxQoSMC/Q==@kvack.org
X-Gm-Message-State: AOJu0YxGhuqxHP0DE6xlFqAshEcEDcJycHxzve3moEDsTEjGj5NWnD6H
	FVDbXbMcIWjlVz4m7m4oQ3/bSDmEe0HFM8QGJSjFAa9DKcBwtircwvdz0N/QOtGGVKk=
X-Gm-Gg: AZuq6aL6/ztmhcaUcHouNBtCV/rPLsG1uhxxqQjHZd45pUYJCB0XRHc5VRQK8GvRiIN
	euKRrasC6rlh6Aq6H2ITYgOa8IqEWiSuy5IakhOOF9QVVi2nTIvGQWU4rmsILMNhy7i8iR836dr
	43FgmgfGyNst4oh0/NMVZCDO/SUfMDTfL5Rl8/vcOJbk+qx63lTq4QkOAkb8b7rQ9+Bubwecwuk
	KfOvfRCpeqoiQr2oI+QIZjDhu3l1fpx6Rgzv54nRHRwGDTL7PXC88dQuGoLGtH8IhXnLEe2cPQQ
	GbQ72M3QGUhdj25/qd81rkBtcBIsJYpDtckyPAjOlXy0/jCnxNHIT3WVIq4xy+sWJFVSz1eYru9
	I/KcCfMMuBy6ohnqA1TLMOdGm2aIfTfXzTlnmj10Hi8HvWungOog/9AV58r6za/qEyz3z6U3vAW
	ZHuLTUPjNpJXatwP1sFlzDYA==
X-Received: by 2002:a05:622a:1104:b0:506:2041:13db with SMTP id d75a77b69052e-506f06ee22emr50311931cf.49.1771520910396;
        Thu, 19 Feb 2026 09:08:30 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-506849fbb11sm214356781cf.13.2026.02.19.09.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 09:08:29 -0800 (PST)
Date: Thu, 19 Feb 2026 12:08:28 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Usama Arif <usama.arif@linux.dev>, willy@infradead.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	riel@surriel.com, Shakeel Butt <shakeel.butt@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Lance Yang <lance.yang@linux.dev>,
	Frank van der Linden <fvdl@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
Message-ID: <aZdDjA16yQYV9csN@cmpxchg.org>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
 <aZc-8dMBz1XCJI3n@cmpxchg.org>
 <A4DDD3A2-104A-42BD-B174-676012166BEC@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A4DDD3A2-104A-42BD-B174-676012166BEC@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 97DC5100014
X-Stat-Signature: w7k5s8d8gcqmhi7ojabkpesyk8basqnk
X-HE-Tag: 1771520911-339548
X-HE-Meta: U2FsdGVkX18B9mNznCiq0Qxq19aio9lsDEnuNJso/N0Jpi8rVtPo0NSdJgpgGKNMoKbeRSFQIgDfyXXvUzlGc1QSCzoGkqJ+EslZ1bbe+Pw71/RF7RHmaz8FpdeqSBbMpIZFwvW1AFTsvRfESP6iZNPJLNcYM/hVdUVYw4bVquDjm0TAg4+TRkyhRB2qQptl+CFayovOn1rF1KYuGRDo4ATy0CPM037p0iirrUrkLWcb/9ZU4ot4ws3a96n5pPFUCEBpTnvDFD1if/p51dwiMp5Wu5u0v/wgK/oy6F01xRqZhIUj9uumxvqkWe18e88KTFT82NEUJwOiccXrCNcjCOCOOMhoxg2S41ZA9lCWi1Y2jxnYpb7iXCatg6+NrmavmpKMPJj+A+i1mEb3C2qR5904qaFoz6P5/FxDc8lQkG2SsW55jPopmIPbSehou6DuzkFnjRlQAUDU8nX+7YuEnzIYc+VFnVE1E8rdP2Qv0+dKncG9+SsLzYEEFUz2+WH8lWwn74wH6PE5nQ8jvtVL5PJf75Z/EsUAssnUyRfPrO+8Xap/GVopGRb5r7XRRkeIDTI7vEU6dyQENFu5HniVmWH5ZhlJY2xPHyASPsn8o/Kxak/dfTel/T5Z8sQfNDynuDFmEa5HGOUpmfJxJdrrbd0ZvJYeAYeqQcK+iK5u0706BrBQJ8NXkRjzJb2FxzSVMZTSZCJFUMCO+KnzIw65fTFVSbgf+rHKk1rMLLzaA6iVhlgrSaZQ3V/AJ1KwYHUSLKDpw72PsK/aOMcHIl8T/JFgKwF0TPViMfWnQD/4gQj7HCZvm0U1nE+RBgXNdGZqm9c2pQY+VHf7TmZufv0cA4cP4kw0ZXRFoYQ1X5mhsxECnk6V2QKzVG0I3fgLZTkjD9de0siyKz6cvleEvyvxso5Tw+m0ix87wLaL19jwgRqkPu/FXDGKd6VI/dkFQfDhvTVeet3ogLqL4ZItxaK
 vHAEwcwP
 GN9GEHWw0LQWums1kYxuV1gnuzwqtQ/a4vLkaprv0MZQnRhuP0yrtY/CdI2gGf/NZQln9J0UwunPrE4zGttG79zYTExC+TSJBA1ZREAl4Yl8xaXDn52M635rRTxL006K1L1VVm0QXDKSbM/WfgpNzONUzdPM4KQWJ+tafdRkj+ntCrv35lXhuLmo5N5fpDb/XXGSLoHND89kQuNQx9ELBaGQCoNF5VBAq1oQx5dH4EspG4SLbr6mSPqEF7mNwqEIgm1rV1mXn3bdHuAfeJf/ajaRLcTY/iEoIS4ccDOvQTbp8JQM07MiyWWYC2uONEmLTHb7fBHgphk/85zCqPX74+uAzeq0083u0LnLvY+KBfw4hRkTh/0CgrKx1wIjleQ5trqBwbvKfrKo0BI91HbEd13ae7toAsydcEEO2Ad6/2sFbxuVWW1VhrTTwnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 11:52:57AM -0500, Zi Yan wrote:
> On 19 Feb 2026, at 11:48, Johannes Weiner wrote:
> 
> > On Thu, Feb 19, 2026 at 05:00:19PM +0100, David Hildenbrand (Arm) wrote:
> >>
> >>>
> >>> I see 1G THPs being opportunistically used ideally at the start of the application
> >>> or by the allocator (jemalloc/tcmalloc) when there is plenty of free memory
> >>> available and a greater chance of getting 1G THPs.
> >>>
> >>> Splitting strategy
> >>> ==================
> >>>
> >>> When PUD THP must be break -- for COW after fork, partial munmap, mprotect on
> >>> a subregion, or reclaim -- it splits directly from PUD to PTE level, converting
> >>> 1 PUD entry into 262,144 PTE entries. The ideal solution would be to split to
> >>> PMDs and only the necessary PMDs to PTEs. This is something that would hopefully
> >>> be possible with Davids proposal [3].
> >>
> >> There once was this proposal where we would, instead of splitting a THP,
> >> migrate all memory away instead. That means, instead of splitting the 1
> >> GiB THP, you would instead return it to the page allocator where
> >> somebody else could use it.
> >
> > With TLB coalescing, there is benefit in preserving contiguity. If you
> > lop off the last 4k of a 2M-backed range, a split still gives you 511
> > contiguously mapped pfns that can be coalesced.
> 
> Which CPU are you referring to? AMD’s PTE coalescing works up to 32KB
> and ARM’s contig PTE supports larger sizes. BTW, do we have PMD level
> ARM contiguous bit support?

I'm not aware of a CPU that will coalesce the 511 entries into a
single one. But *any* coalescing effects will be lost when the range
is scattered into discontiguous 4k pagelets.

