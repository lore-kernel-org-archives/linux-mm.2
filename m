Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10AA6C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 07:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E8B6B00C3; Mon, 11 Aug 2025 03:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FBB6B00C8; Mon, 11 Aug 2025 03:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645916B00CD; Mon, 11 Aug 2025 03:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 569A66B00C3
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:09:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2B4416069A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:09:42 +0000 (UTC)
X-FDA: 83763601404.08.387F581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA88F2000C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:09:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jSgMoSnb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754896180; a=rsa-sha256;
	cv=none;
	b=x/R+vMNgbDlcMOac4PWXByqmlYLVpaA7Oa6QyO2drkPaXvW2ZdAl9GvIKFZwtijVAMpeyA
	AqTCYi83k1a+MxBtAA24A4uMNd1KiZVW8cWQxoMCtevIvs16uymU0mLx5av5ayH+QG/ZN9
	uD8VPc4JRwb8h8huHS2DiLrGtpipJ2k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jSgMoSnb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754896180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYGW20HOdxmPiEoqhRtBhvf9IFz/tFlA/9VUt4ajYtM=;
	b=ilgfIbGE3ghcDjl5xQcGRyHlI2g707G7xyhS22L8GThcJPDae2B6Ci6bGMNZhRdvDzosGR
	WVtaAsy9B01dkwJ2BppbLlW9TsjiRZ7LOUlsfvGpmot7MVs64qe9tOkPAajVRFDIMQAfLy
	X8xVhmq4X9xHyTkTjfdSIzy0akyRr+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5942A45D44;
	Mon, 11 Aug 2025 07:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED5EC4CEF6;
	Mon, 11 Aug 2025 07:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754896179;
	bh=7z//XUu8T6I5PWiVUYkgzX56lekKtAuXc9LA1vkAIVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jSgMoSnbXdeC3hTmMa5rxqnU+TWuL44ft9yhN6jzlYEmA7jwdSGYiQnLF6BFOYKsr
	 5R/fr9QjyFbzxrlBrIv2gCok7gC8JkgAppw6IXD/F87bUVX5sLc2JR+i0hiKjHB/eg
	 cfP9T2kKrEeWB53CBUEIYKgIVeFsIdkopEWkV1obWsWDyqrTyQ0SMRBRBszN1XGf6p
	 a/x4EjKoAuphTOp/i4iZkdRFQSga+eMCJZDAvNlPeoiQXnyWXFuLlWT0mOaSgKnz9o
	 oU2KCRXlBAKJHbtJRS6w71U3Eb8UeQ9PSpr4qZWggtwXe60/vHe8hYUg6SLwi5/Qqk
	 j0QU/Hr3uRHzA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 61606F40068;
	Mon, 11 Aug 2025 03:09:37 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 11 Aug 2025 03:09:37 -0400
X-ME-Sender: <xms:MZeZaAKhv47jBdQVbZBUzCxovzHYH_0rrP55uhLzR3Dqu-Hy8rtmog>
    <xme:MZeZaDm4-FA4AmkgD2YQQA1xH-F3sHPexYTS35ALEVFWRqWFjvQXtfar8y28gGpiS
    cXt0_A1OFnzm3zDBmM>
X-ME-Received: <xmr:MZeZaM-CyM-RA_V15WzO_HJwVVjXwS5bJQX1q813TA-nJyYUmhcLGBheIsW3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufedukeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepkedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehhrghrrhihrdihohhosehorhgrtghlvgdrtghomhdprhgtphhtthhopeguvghnnh
    hisheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopehrhigrsghinhhinhdrrgdrrgesghhmrg
    hilhdrtghomhdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pegsphesrghlihgvnhekrdguvgdprhgtphhtthhopehpvghtvghriiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopehluhhtoheskhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepthhglhigsehlihhnuhhtrhhonhhigidruggv
X-ME-Proxy: <xmx:MZeZaGZbB5w_M42lUmZvSVfIC5VjvScMKskxvkLxG0mVV0m3V7kKAw>
    <xmx:MZeZaBc00jAWL5dtGe5myKZzMdQ7PLHS6rajsmRqWQuvhtwgycMP1g>
    <xmx:MZeZaGGN3-BRzRyZ3VTcErLpqp_9MdvkA37zFIuvtc29YHSY7cqBRg>
    <xmx:MZeZaEPqxrTYCm-gaYlP41qi_-NhCIWpAR2UzkynZnOmQu5E2MBG4Q>
    <xmx:MZeZaO4ZV2QSxZoQAn7qeAHqpWYLVxkPnxGf8XyRRwOEAG9Iw4NuNkCY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Aug 2025 03:09:36 -0400 (EDT)
Date: Mon, 11 Aug 2025 07:46:13 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Dennis Zhou <dennis@kernel.org>,
 	Andrew Morton <akpm@linux-foundation.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
 	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
 	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 	Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 	Dave Hansen <dave.hansen@linux.intel.com>,
 Christoph Lameter <cl@gentwo.org>, 	David Hildenbrand <david@redhat.com>,
 Andrey Konovalov <andreyknvl@gmail.com>,
 	Vincenzo Frascino <vincenzo.frascino@arm.com>,
 "H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
 	Mike Rapoport <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 linux-kernel@vger.kernel.org, 	Dmitry Vyukov <dvyukov@google.com>,
 Alexander Potapenko <glider@google.com>,
 	Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, 	Thomas Huth <thuth@redhat.com>,
 John Hubbard <jhubbard@nvidia.com>,
 	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Michal Hocko <mhocko@suse.com>,
 	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>, 	Jane Chu <jane.chu@oracle.com>,
 Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
 	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
 Joerg Roedel <joro@8bytes.org>, 	Alistair Popple <apopple@nvidia.com>,
 Joao Martins <joao.m.martins@oracle.com>, 	linux-arch@vger.kernel.org
Subject: Re: [PATCH V4 mm-hotfixes 0/3] mm, x86: fix crash due to missing
 page table sync and make it harder to miss
Message-ID: <qsprh2qiisldfsielpx6inuiw3rrh5owr3urin7maxvwtlhipz@zbioc6hgqe3r>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811053420.10721-1-harry.yoo@oracle.com>
X-Stat-Signature: zimq5qwjsgh8c5d9eyh9kca6fmbioojt
X-Rspam-User: 
X-Rspamd-Queue-Id: BA88F2000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1754896180-258186
X-HE-Meta: U2FsdGVkX181RxeURczi1dZpjlMt4BueI5uN1pZA782QNVIZuoOLRhW5GflW+3uPhHb70MLZI5NEXx9NVeQ6czqq8r/lSUHHgWpdJeQumnjEh4bHFXgqlL1bHDIgPJsGL7cKFrazJsYgWdXAbY2sTy25UEedybotJ+y5dGJZfWgFYraZ12ufk5pZAu1I4gFnDr9SMdndiZf4bDxhc+EMOVshYlmqG/s6dcBgooS9KVV0xk6PTYE4BYnYlJHsWVlOb8dralBCBYrleAJacNmtzDE+DQFO+J6reuaqqZUDMM0S/b6ioGSoU/bnpyR/WNFXLXgDWBDe/wameeja08NIKvkXWop3LuhNx335F+smXZB68LOy5ebNNaDxuiXrNeHXKhEOIgySpUljKyHcSfOMjrZE8+eqx7tbdMQL9cBjPWeMIHHwjLiTXJJlS4I3GQv4RbFolCyIzYRHEPP74+oCWLE6ljSJ2A/EKxoMun22xTDHR4xIgELTSCpkoSxQ0fB0Nd+eH85biq5OM1hhs926XNfJnyhQecYjyZM7cv+pvs1lP4fwkAJZm6LlJye/h5RLzmj4ZJGJmEBQ50hc0wnJFuxxYHTDdKcTCupdaa4My/Frv+JeAWhtsy6mVdc2QoFuBghbXChcT59whXdnWFoixvmRlrpGV7W6h+9U6Cd/soY8/x+5yffEOSp+EhQ6QYPZhef75fCeMF++ekbvrA4XredvOKeb2fHSv4W6Fpe9cxXc7hqyqT97HdLcuAE5jQyh9OATYu0040z0+0Wu1LJwzMm6ulqr/tVyoVhlGrJgjH4QlkGe6kc+LkJlwR0XNLNBqlLy9lhonOsLDcTrPgRhpI1WQ820glh3mxUrBdDyAvLx+RPfNRmXSS6BSuPNCe7ldnwC/2ovndBAe4VYqUMDJBdX4q5wMzH7EhE5vdapcUbIgcyuz4R0qA7AM5kiN8YTroqisqZTJRhvyUs5Gvs
 JH/nsS4Z
 CVQRO2hM1z66ldMF3TYiLL4QEQqxUIRB9baZ2ivSY9QerD5UR/cVdeVU29O1VdmJZ9F9rIAJNJ/XcBK9xmg+MxHyn+Mm+FUDSaZoKkW933SMKRmXjQ1N/fUb78/y07qik/eoavcBL34LrQKmctAp6HBuGrIz2K0RINiRpGc2isTP3MOpBnSEQImmIpefJgVdmtNN0oq5OaHGVXn40Y5OzTxHz71o+4DJbQA2Yu0f+7PIZNBOQptx1sFEfkFuOYipaU/OB0qZodZW1XvnRzV0WOkYlW2tuyeb9By5vcYYCu67dpBicTPj6T/1sR14wFbOoWI4VJf47qe8jFRZ98snD98J2p9IoDTHR3NHrHo59NJUV4RqUwv97ar/XhUzGwB2BeKO0izJRsYJy9NZJkC5SRrObHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 02:34:17PM +0900, Harry Yoo wrote:
> # The solution: Make page table sync more code robust and harder to miss
> 
> To address this, Dave Hansen suggested [3] [4] introducing
> {pgd,p4d}_populate_kernel() for updating kernel portion
> of the page tables and allow each architecture to explicitly perform
> synchronization when installing top-level entries. With this approach,
> we no longer need to worry about missing the sync step, reducing the risk
> of future regressions.

Looks sane:

Acked-by: Kiryl Shutsemau <kas@kernel.org>

> The new interface reuses existing ARCH_PAGE_TABLE_SYNC_MASK,
> PGTBL_P*D_MODIFIED and arch_sync_kernel_mappings() facility used by
> vmalloc and ioremap to synchronize page tables.
> 
> pgd_populate_kernel() looks like this:
> static inline void pgd_populate_kernel(unsigned long addr, pgd_t *pgd,
>                                        p4d_t *p4d)
> {
>         pgd_populate(&init_mm, pgd, p4d);
>         if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
>                 arch_sync_kernel_mappings(addr, addr);
> }
> 
> It is worth noting that vmalloc() and apply_to_range() carefully
> synchronizes page tables by calling p*d_alloc_track() and
> arch_sync_kernel_mappings(), and thus they are not affected by
> this patch series.

Well, except ARCH_PAGE_TABLE_SYNC_MASK is not defined on x86-64 until
now. So I think it is affected.

-- 
Kiryl Shutsemau / Kirill A. Shutemov

