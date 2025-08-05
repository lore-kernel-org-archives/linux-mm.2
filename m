Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E6BC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 15:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68E96B00A1; Tue,  5 Aug 2025 11:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41176B00A2; Tue,  5 Aug 2025 11:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56786B00A5; Tue,  5 Aug 2025 11:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5126B00A1
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:36:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 418A41A0129
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:36:11 +0000 (UTC)
X-FDA: 83743104942.03.BFA4DC9
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5978720007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:36:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ZLvPdE0s;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754408169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1MKz8dfPt28HzEOpdUPkfZENcnUFV9NfsoMVTYwzbE=;
	b=vNAbUCQoxORT2aJjg39K4/rMAcPLIS0ndcAzRzalYazQKxy+Xxh6mRYlElMbjoclAdeqSZ
	0iiGL/mIwOR30adGH5JRIfsA5ZeUldB3aoKF6+zEXXLEFLDaVMPbiZ4kdpGwN4OkMS5Nh+
	bifFgfg3HbI5JcXayRuyD3Spq8HnNyg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ZLvPdE0s;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754408169; a=rsa-sha256;
	cv=none;
	b=pLM6K24UtWzgil8GSGQha9SOlIfwlyNG+S48T8Il6zFM0SMyyeIDS92fTAcuXHZmm7//ke
	IL/rtEwivnKpbWbt/0GSafTN6JY1uTtJ5Z7t88QMKCONwC5fvI/B0gHEuPV+AnOMPAIDPP
	9VCVB2fTjbBguLSf+9ZPopddujnYSe0=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7e806613af8so198218885a.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 08:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754408168; x=1755012968; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N1MKz8dfPt28HzEOpdUPkfZENcnUFV9NfsoMVTYwzbE=;
        b=ZLvPdE0sn9y9tnKsZ/j0wEjsBJ0f4FyOpYWw1GX6EpYkAxrpxtzpWiDjAGarNF51kN
         2doQcrVisaQ0DNY9LjZIaPDqrPi5+Hp8MDFi2vj82/D+OJ6IWP2Dh7/2p606bfrs3Fs2
         BUnA+gagivKojLbQSw5D9Tqb9oU8XGrOAJqjWkjTz2HMFygJkZnLXVp35YStzjFrQ9m/
         vRUwcB1sALAPXb1MovRKreTnkrhQ515rypOB9QWHSvdAN8FTgPGZbmrZF/zmKEiZAfst
         heez/eTYa/sdto4g5O9FP4F6Gj7PsK2JtfimH4Tpu2AmLnRYEBnSkt7CWLEAdqO8Msgz
         ds/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754408168; x=1755012968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1MKz8dfPt28HzEOpdUPkfZENcnUFV9NfsoMVTYwzbE=;
        b=qlw68gaIu1/kS0zG2F5bcvoH6RQi8Y8mD++0XhiCn8iMHN59CKEAMyIDqCuatc60hG
         N6qh/vONET97w6s6QaTQsanZE95uC6eR58sKeN7fA+xbXuLQVVJaD8MTfzhoxQnqOCk1
         cFhpln0IgSOMC1asbiaWyUsS/OD5bPCotdgftCFsCAKvKmTM9fyCR7cNgOpZG45b1Fpr
         J7/EF42xcf++Vqe4pALDbDOXFQxBhu8yAIrMQlA2d9JiCxoJOf2ZELjuqPEqPFhHKn2T
         bQ3n2KYowAKaV9boaiJaE8GIpwTXI9jklMnBu3NKxY/IwxTPeEir+K8tMvqcNRPCpRgx
         G1DA==
X-Forwarded-Encrypted: i=1; AJvYcCUF5jiD5OFfe3CZfwFlKAgPgl18Fk+8CIU41hr0lYruZirFSu6TgZTpOhqCvYhImqnIASMLgfYodQ==@kvack.org
X-Gm-Message-State: AOJu0YzKybXrYmm5kKsSluYiOde3wavqAGaTkH59HssUn1S1kBV2xsQi
	27HNEZ9qWwMjtxMmRZGB3fKXUmNf7smZUH9nYUdpTc9R4vgYbx5GOzV78QwuVod9J08=
X-Gm-Gg: ASbGncvv9Nbaie7GOi2Q2wNPtHe5ucRMep1ExWy7edneKOEcHTA6JOBU3zwkwpXmyNJ
	wCW/CT+FkseCPSpvAS8hMaucQTXwkxcJ440VLOM2OwHFRSLv+zHcd9FTOe7sN7d24D+NVLsg11a
	xxdXjXV1Rf9ie5dc/39RYSoaYeeD5MJppqCU1W9eMeWZOKuiFf44t2h7fSPt+nVwNXZR5DyGc+q
	G1bxa29VhIXsXe670V0WmeXKIsdgM0rwl330vipwQ82ElgWfttwF1qdMeykdgnYYvyL/m8mQdSW
	nS2bzthreFaO/DPZQ1qjEC74hYmVHv/w6hlH+oYAHMjWA+WRNI/17RgvtU//iq9VP0P2SbmGUko
	AIVeXY7pNUAJNBdWmNHH6HEDKXSwspj5QKbuXkVJfl1Cl5vi/945Vj5l1ONpRr7G0PSiJqraAhO
	jB2To=
X-Google-Smtp-Source: AGHT+IF1+3bX6DUQCrRo5YyM2fp0OCvjM/jusyZc5iy/VSCxNo0II2PGkJ9MrYPb1oYSw7F9hqkESg==
X-Received: by 2002:a05:620a:12c6:b0:7e6:8f41:2055 with SMTP id af79cd13be357-7e6962e0c1bmr1733279285a.21.1754408168128;
        Tue, 05 Aug 2025 08:36:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5cd63fsm689744985a.39.2025.08.05.08.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 08:36:07 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujJhu-00000001YWx-3rSt;
	Tue, 05 Aug 2025 12:36:06 -0300
Date: Tue, 5 Aug 2025 12:36:06 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Matthew Wilcox <willy@infradead.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, iommu@lists.linux.dev,
	virtualization@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
Message-ID: <20250805153606.GR26511@ziepe.ca>
References: <CGME20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf@eucas1p2.samsung.com>
 <cover.1750854543.git.leon@kernel.org>
 <35df6f2a-0010-41fe-b490-f52693fe4778@samsung.com>
 <20250627170213.GL17401@unreal>
 <20250630133839.GA26981@lst.de>
 <69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
 <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
 <aIupx_8vOg8wQh6w@casper.infradead.org>
 <20250803155906.GM26511@ziepe.ca>
 <aJArFNkuP8DJIdMY@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJArFNkuP8DJIdMY@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5978720007
X-Rspamd-Server: rspam06
X-Stat-Signature: hqnbnognkrpsospd3yxztdcjrkeeoghi
X-HE-Tag: 1754408169-812292
X-HE-Meta: U2FsdGVkX1/uKWLWuyDQTI5iu4WaLYzC8z43vCHeqQueSoasuygBgnwDVPD8Ggo4Uio565jPggC8ACDRx886qLsdipc7k5kLN5P1MbdKgL1eBo9lMsR523usY28quPcyN1/Q5Iyp2UA6aFTLuExAthZCOTNFwPVhJla0KyoJno1Xb+Ugk1j3GHsXQzGJ1vCPssp9G+yBMPZccRlZPczbdew3vASfWgC/QR3ahTQDk7FPYTPWh7wHzk9INi59sdRzYBp+cfhA8558dnNRuNonvAEcGZtdNLyu6NfLt/D+nn+DnbUAX0MuUbIYFxOS3zbZOlNldRC3LW6SrRbgvuzjDAaxoM1qb+CrOGiPpnq1TXEc1erwHJ4YWNQpRKImEXNm49XxexbmQmw+VSz277WVMOz/DCmnygkkLzBLtpwNK2Yhm+RAmedd+Qxt5juk9qDKMjQPz2YuvmBXlapUFiRbPs0tL27QWnqgdtE7k5mYfucvvgJuBC/eBrIqj4o5byTdGtVY5Y8JGG9/kbVaG1C1qb5RMHUBVIcB5U/su3BMmFC7c2IqEXGHkfLUcCCoQB7jWeAYwbxDTkgvShMEabCYP2MMXlRtLBPI78YF2RXRIbyQaJoco+6E4gELAo+9H40mqJNNbdqs2z2v4sZC77sWq8BTb4ZouZ/C6G2pVbmhbC1NTB9+7YKBFytjD4xV2/Y9iVERJ2IiCvsO6gt9U/mufJ60vf1olHYHAcjHm+Ekyd24TGK7X+LfhHFPqhsHsj/gCddS6mIka1q5uIfnaGKwQt+kwZBldycOXF2KYUoXWnOk3+AsoGIWq/qjUfnko60wxJMtII3Tza2FScFRPiya4V2oipztsFGlGWdQKFo7bWYodpGLsjaczAD1Bk3mAGjOv6SyPd+xGKivHNwHeRFZVC553WGNHpi73mgi+TRHrJ6U39ZkqlgJ/ARURDMASpc9U+7X/iSzodj3DvG6U52
 oNcEiif5
 Fn0NJi1Qt3OXIhkU6Z4va7F3pnMI7vGWJBoTIBUu4P7my1BgFcSTJvVULThJbdh1AjDCQ6Kmq4Lm2x2OzTncr+5SlAow4uH7G3FEcILKdqpIDX+OP3+m+qwci6OEtEv4P8ShMhrDXfZL5gGrviPJXZCEzz2QcZv8Hrb3t+IKIDN8zwaYeLtDK0oOABXw9BB4gtN/d31kGt+azVUtPhKiOEIT7LrcRZMdQj4bGYRBYn/hmyW9m7K84IQ5KuIJbwrY5tgxgm1tTeOFJ7TRU89Fy7EBzNCPJotjVQmzo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 04:37:56AM +0100, Matthew Wilcox wrote:
> On Sun, Aug 03, 2025 at 12:59:06PM -0300, Jason Gunthorpe wrote:
> > Matthew, do you think it makes sense to introduce types to make this
> > clearer? We have two kinds of values that a phys_addr_t can store -
> > something compatible with kmap_XX_phys(), and something that isn't.
> 
> I was with you up until this point.  And then you said "What if we have
> a raccoon that isn't a raccoon" and my brain derailed.

I though it was clear..

   kmap_local_pfn(phys >> PAGE_SHIFT)
   phys_to_virt(phys)

Does not work for all values of phys. It definately illegal for
non-cachable MMIO. Agree?

There is a subset of phys that is cachable and has struct page that is
usable with kmap_local_pfn()/etc

phys is always this:

> - CPU untranslated.  This is the "physical" address.  Physical address
>   0 is what the CPU sees when it drives zeroes on the memory bus.

But that is a pure HW perspective. It doesn't say which of our SW APIs
are allowed to use this address.

We have callchains in DMA API land that want to do a kmap at the
bottom. It would be nice to mark the whole call chain that the
phys_addr being passed around is actually required to be kmappable.

Because if you pass a non-kmappable MMIO backed phys it will explode
in some way on some platforms.

> > We clearly have these two different ideas floating around in code,
> > page tables, etc.

> No.  No, we don't.  I've never heard of this asininity before.

Welcome to the fun world of cachable and non-cachable memory.

Consider, today we can create struct pages of type
MEMORY_DEVICE_PCI_P2PDMA for non-cachable MMIO. I think today you
"can" use kmap to establish a cachable mapping in the vmap.

But it is *illegal* to establish a cachable CPU mapping of MMIO. Archs
are free to MCE if you do this - speculative cache line load of MMIO
can just error in HW inside the interconnect.

So, the phys_addr is always a "CPU untranslated physical address" but
the cachable/non-cachable cases, or DRAM vs MMIO, are sometimes
semantically very different things for the SW!

Jason

