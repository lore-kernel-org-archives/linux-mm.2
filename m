Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080CBE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F25D6B00A9; Fri, 19 Dec 2025 12:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575FB6B00AA; Fri, 19 Dec 2025 12:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457806B00AC; Fri, 19 Dec 2025 12:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 345116B00A9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:32:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E54ECC02D9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:32:31 +0000 (UTC)
X-FDA: 84236914902.23.60BE452
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id B3B671C0025
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:32:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="iNgE/d6c";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.49 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766165549; a=rsa-sha256;
	cv=none;
	b=F1ehNZkbqjkLE33+BBMLmzO24IrhlVCWepPs7l64hGrh3qa2v4eqZgM8Ny62mNqO8Cu4yL
	XD5O3o5NQYogmLxusVCMd2N0zu/tSfPLGFdTo24eNwrfN4b6SBfOPJIDBxhJL96+ObPD87
	ekmqm5qvMz0LERRK2NmzHAsKUAiK8jY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="iNgE/d6c";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.49 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766165549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hC/VXab9lpTCQATnomkfbW2pa0Vc9kadnS6vaPWuw8=;
	b=eWfPnNCHTDS00fhrTMmwuhIgFXG+zWnXT+O12ahCOXlOUNnDc1Yveqru0hJWlhFXhOinqP
	uiom3JB1fPNcvj9MWJVUpd+V6IE7C67A0Ca49Z566JwRqjwiNxutIElZRiLVaZ//cHPANq
	ElOO6JguzueY7u+/2ANR3dyou9YwTps=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-888310b91c5so26425726d6.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1766165549; x=1766770349; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1hC/VXab9lpTCQATnomkfbW2pa0Vc9kadnS6vaPWuw8=;
        b=iNgE/d6cYZxZGokALCoYysZO9uPVjQNg+5G28S/CZMfLoAL6zHdStXFFuV7vm89cr/
         hNPeHDqkn7elkz1MYzh/fAvc5mbljgx7O5wmtnwsG3zL5JsdEZkIcD2y1cfYvJqsRUwo
         nmd1ymD0+fgPaoW+5CKXIowkZxEy2VYwGcLAXjya7B4RKQioU5S3wrdO30kxKoAX9x0T
         VYZOlxzxFCYH/Kv6rKNjsmC4wDRfLL6FYTzptzkPRRrwwesojxe9SUZIrBZ/Cd+njBLq
         WNVKT3APZjF5fH0Nr+3PJ6WJMpUZ7Omr8XikVwjBuZu2YW2PFJ1ucp0AaD3b4+s8P6wm
         x9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766165549; x=1766770349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1hC/VXab9lpTCQATnomkfbW2pa0Vc9kadnS6vaPWuw8=;
        b=H8mzqS4FR58llOc5ZTqSF5AxAiQy9uxdxBKu6PH26ujA56Czk2Od6eTk8ZXt6yK4B6
         tpoPgaafJ/6zw4EoE4DXIj+gKrBvujYzZcvLdXgg4bFjBL1d+p7mJCF52q6FhOos8i22
         QYNLw6PuaXNK8NrlDebMnSH0vFIaaejD1vS/jUegL6iRL0FgWGCEa11vfafnKRhdMmQ1
         jZDsidKr7TxVUiv5wJF+hmDJkKzuJvNd7qz/1PZ/t3/Q7xV8hmrwsTuSytHsUJzHfMr6
         m9lcYbLFviRi0NFuwC6d3xv+9xPesttjomye8H4sF60XvUp7YQAmKzESHN3lirLYWGcb
         E3YA==
X-Forwarded-Encrypted: i=1; AJvYcCV8MW9kctBGYARtu6sYso+U0F8H53dg8vwsTfwTKPE8VarRcLqIwg5u6YCdFyGhGs6a1i8lF6V9KQ==@kvack.org
X-Gm-Message-State: AOJu0YzQVjtXXvvyazG2Gqqra6AiZMNmdhumrP41PMYSZfpj6yEL1czO
	tmMU1gHQu1ed4cH3cBT7PmYhsSiliBesHY76Y/Dv/tTKDPGPQzsm6f3D3VUTu9EGzAE=
X-Gm-Gg: AY/fxX7KFmmkMJ5hqPvtXzx3YnknnPPftCv9gKu1DykINnNAG0glplTxhOHWFfL+SGt
	c8Auv4G5EHOfcTjWg16glT+vDI2RnnKGxoCXrpq2vr/aLH4rz2rz2XuSqxyXdOYRg6l6pL/0dlS
	gr6Ackt9PN83okaaDCae6iIZo5RAJCkNibfZXrx1m34mPOLU5F4QdonPQlCNs29ItP+xeymGQlG
	udSiV5Bf/CM8FwTxaExO7K2GptbScqNLFsx3hlDWwGA5kiqLVMmbe31NBf5jNRfOd3aMhm3zjA7
	v8KM34NFkO0hW3RoGUmon+klIccm8LpIOehROAX0LZy+AOrP3S2GMhrrvQwOT7a7miybioT/5Wu
	ivTvy/RmEElrlxrrlekqfQAi08TMvrbAzHWJvwsaSyOODPKgB5h8EYSYSWJraKAV71UR7u43WB0
	sZTSy4SFU3Howj7oyBY9+HbWht5j4lyyJBv8dQ+7wAyFfhj64ksii2JoFmA5T7YYRT+oA=
X-Google-Smtp-Source: AGHT+IGYAWh2sxLwizpTExt2w6pCX2ECxkldvqQUVe1MFbSK91RMxz7SwBO+heTsOJkJoalFRECn7g==
X-Received: by 2002:a05:620a:c50:b0:8b2:3484:8e22 with SMTP id af79cd13be357-8bee5dcdd8cmr986687885a.0.1766165548739;
        Fri, 19 Dec 2025 09:32:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d925f935asm23424216d6.0.2025.12.19.09.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 09:32:27 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vWeL5-00000001b6X-0xBQ;
	Fri, 19 Dec 2025 13:32:27 -0400
Date: Fri, 19 Dec 2025 13:32:27 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Will Deacon <will@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
Message-ID: <20251219173227.GJ31492@ziepe.ca>
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
 <20251219140557.GH31492@ziepe.ca>
 <aUVje_QZvJ9rjedp@google.com>
 <20251219161153.420d1c46@fedora>
 <20251219151434.GI31492@ziepe.ca>
 <20251219162734.46f3aa9d@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219162734.46f3aa9d@fedora>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B3B671C0025
X-Stat-Signature: tbjhc8stmzhm8uydkkmya4orwfr38xbs
X-Rspam-User: 
X-HE-Tag: 1766165549-669024
X-HE-Meta: U2FsdGVkX19RJsW5xjdFQNjKCC6G81bzBqnCuBQ0F63uYPryuHzn2GTpkyalapmAiRngoCvC48TsSu97L9LXZ2+FYPlxSAKA8XcSr/kPpBP2gsrEr1vEWlTQ2rOnr4g64C7JJCwWnOJ33yHzHBTvJPR7U4Bqb24bE9+cIhAm9JKLuca0/IQTWI+zIFWEr0zhTThqxDjNEhuNgPm8wH+ETnHrubMSG5gtFLkCupyy9Cm9k+rBa42XNFPE71SfQyfvyNS3bznjhAryUedoBiip3L2ZZtNSg7otacSxdZXqBRJnODi/YpVrzi7+GWLA3THdOo9AeVLbO5Memd+3xVfgeX/i8zAQcR6jpR98zKtW4vachJ9MzNuEwV5W743tZwQa3wDdOSEVrAA514c6lj8Jtjk0n3124vstGoAeRluTlaOrV1jZQW8Z16E5DvluxeQx7XXDHEmQRAR1+es1RtKUj5d8birVcC5GIfsH8WME3BOQHw0LbO6GJJAiADL9WlFuKXFh8oazFr+YWSHD/cgaO/JTjc2luwts4fBIGWR6NMZkXP+YBHzSC0ZpEulsMU6LfoTku3Hh05J2S0L/svb9Nz1capa0If/VbTefgA48VtCiRi8c5G++2hugdgkzWdHFkg0LVTbPzxfvc0In7tkjYBYM6W9LJMFPRn3PIQrrbET6UbyO1Pwu0CJrcPlOAA8MLnzblDmCO3sJo2yuAg1+v9LmMb7VvCvxSQFPQW8kvgjXMBhT0XdI95WmYgCAoaNDGVI70t/gOs19HzREMqIfhRoS/t1ycNOCv8MZPQtO4t9iBr7AMs/SVt0c0JklPRvNaLNMD0Wfg22997beYIzz3DiFV5gHqHyAOc1GJJM7HuDakG2NswLHbtFEiTykaL2F3s8cOqOdCQP2RhXHr/SAbw3JLCJD9emFSbLaIt+4UredbDXPChK+/dXDz5eePSPC8Y1oByZrOfwOxMqb7/T
 azcxHE0D
 cTjpatsBFgcDwgVqi7YBtbd7cd1B/fIcvxjLuDIAbVAgaiCfPylKZ+JjADrrnPpdEu0tDywq0oEXS2rtUwIfo7smNnSWDR9qAAf3Nb4C7/WIsy+BGIMAx/D9qV8DW1UlEeXHQuIwsThcFaznlbL8j31LCTf6lNsfcySwInEa8ehKOhf6fHRwMnPOPSgWDqxlw8v2LhdTI2I0yk8w3lK6dDFgTGEzxnmdUF2LOotVgyBTl+U1X48bHADWNumMqns4sagssochjuPjSnyxsRaQtYSlGUJqN/Z1JeN56A8J4XN6yAOntnkJDheaEBXphEfqtT5bA3IC9Q45F3jslDOibbdXPzEdcTKkGeCTbdqj6QdDUoreIxbx5Lb7nfClAJkhVv39KIo20vD79NLVDEBjbf4LUmCp0T0qSCmo8Ye7YxT1JX7mERVfG7FbF3uMSPGCbOPQQiqlqZSq067KA7lMBRn0/6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 04:27:34PM +0100, Boris Brezillon wrote:
> On Fri, 19 Dec 2025 11:14:34 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Fri, Dec 19, 2025 at 04:11:53PM +0100, Boris Brezillon wrote:
> > 
> > > There's actually a confusion between TLB invalidation and L1/L2 cache
> > > flush/invalidation. The things we can decide to flush/invalidate around
> > > map/unmap ops are L1/L2 caches. The TLB invalidate, we don't have
> > > direct control on: it happens as part of the LOCK+UNLOCK sequence, and
> > > no matter what you execute (map or unmap), you have to surround it with
> > > a LOCK/UNLOCK to provide support for atomic updates (GPU is blocked if
> > > anything accesses the locked range while an update is on-going).  
> > 
> > That makes more sense, so these GPU drivers just flush the entire TLB
> > every time they change it - built into the UNLOCK operation?
> 
> I don't have implementation details, so I can't really tell what
> happens internally. What's sure is that LOCK takes a range, so they
> might be optimizing the TLB flush to only evict entries covered by this
> range, dunno.

So, I'd probably just simplify that comment:

 For the initial users of these rust bindings the GPU FW is managing the
 IOTLB and performs all required invalidations using a range. There is no
 need for it get ARM style invalidation instructions from the page
 table code.

Jason

