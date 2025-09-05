Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68E2CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC548E0010; Fri,  5 Sep 2025 06:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C808E000A; Fri,  5 Sep 2025 06:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86428E0010; Fri,  5 Sep 2025 06:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D06A78E000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:28:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C49086615
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:28:52 +0000 (UTC)
X-FDA: 83854823304.29.D9E9AA7
Received: from flow-a5-smtp.messagingengine.com (flow-a5-smtp.messagingengine.com [103.168.172.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B7AA180012
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:28:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m otdJui";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UqUMWQ6j;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757068130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98btgkmxybRyG5S0CCLIx+ElbJEKU3DiXBRzCB3IIZw=;
	b=PB45AzV95tx9MgbzFzBAlL+FomA7aLY1eu2/rKbIKkXAbJ4eYoBpwTNhP/Ol33LkKqKmlQ
	832hnfNtQ1bRcQW7aE/ADsrdlsNGBdei2tM8y92tlVCscqEZNaGMVaCznY5758zhzMJ3mA
	HnDw2PDtaLwcXBZd4nVVtTKikcXoCOY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m otdJui";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UqUMWQ6j;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757068130; a=rsa-sha256;
	cv=none;
	b=mO4zLlpVwkud9oJWnCrPAqfaE4uFjsOlpx98Zg6cGeibgM7bG/qS59xqg08X6vuIWayCQ2
	OuRDDoxPngCMcFEiX56ReRpKInJ6l5gdlfDGuv4xmsSPElfWAj+03cmPCx+Qm3oSWWTVwp
	KMifFoTNkHtVNSbmKgrMZYeguSnr3ek=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id C35DB1380586;
	Fri,  5 Sep 2025 06:28:49 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 05 Sep 2025 06:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757068129; x=
	1757075329; bh=98btgkmxybRyG5S0CCLIx+ElbJEKU3DiXBRzCB3IIZw=; b=m
	otdJuiMD5PhvYoJV+5+MRDvV28AsCDoGmfW7n53dbnkq1jN0tK1Y0H5PtVNAu6TE
	oLTrl7asIQr7TfxuvmHdxIivA202p3mxxOqZrOiTKdvWbvH1+T3hJy0RbG0iI4W7
	qpx7xSz8shwHmGjaxWThGHinnx62uJ/2FWeNZPSWEkyIb6eOoouy5O/WtT5QVbg+
	HgEdcA4K8zDTcKLxdEAsamnJFneOtuTBWa47aU6qparSoC0mbXVYroPtO4y0xxEn
	WFwBgNsQiYwllEJMC+q8FdUtCfNZp6Kq8LMI/I4p92EU++doSzzTf7VL7IhDEwS3
	mjJTsRoIvrZAqjqx4v5pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757068129; x=1757075329; bh=98btgkmxybRyG5S0CCLIx+ElbJEKU3DiXBR
	zCB3IIZw=; b=UqUMWQ6jLcwc8dZ5HE7359Bj535yJf2/kOibpKBR7aB3rfq8Rlw
	0FthbdZJkyjTRpGADmZIMZcGrt2fiQHyWTS67fPai+wHFB2k/fD5RJirEt6IVjaE
	eh5Ze53tBCz2inm5YC1Eb0Qpmhds3onsJxjfLoI0E1/KKD252kTAREHq0JItDRlA
	PivmFNiTSXRZ7OQmdcAjnQkAwcFT+AAMC2rIOx5cW87Kn7skRyfoBcMOiR7DPTw4
	uv9B2OBKczVHJOEpFDrYtJnOQakpNVH86qE+VCZwBH1uEiF0QebdY1qgZImR5+nm
	S123MJeLf0K/sNrLFIf7rqklPCBcJhRaKrQ==
X-ME-Sender: <xms:Ybu6aOKeS4Bxt6ZavBwUmyYQn68uBgOETaESMn3aI3wiOlmBuaxndA>
    <xme:Ybu6aMnTEw-GRPOBidl6EKPqY5HrR9STW7FNv-jCkD6B1TCuQduM3I0y2bKRdhL5B
    jEMXqGLZfKRS8QzaQs>
X-ME-Received: <xmr:Ybu6aMN2EpGnXE8G_WbAUb7WT2GmbHbiORIaGYjGN0HLvWfh-EOeRosqG0T6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdeludfh
    feefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvvddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhirghnuhigrdhmmhesghhmrghilh
    drtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhm
    pdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhig
    qdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvg
    hssehorhgrtghlvgdrtghomhdprhgtphhtthhopehmhhhotghkohesshhushgvrdgtohhm
    pdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvg
    hnsgesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:Ybu6aLzQDXBAiQkx3NZf0GatusYhSBldwHxTzfAm24Ytf6Esbl8llA>
    <xmx:Ybu6aEl5jDJxsGzvERUjnXma9efX5kvdZ_Aff-7pQIKEg5HHBAboSQ>
    <xmx:Ybu6aJ8-QnOSM0LkUGt8sAz6YGisAAaHfi85vSCJubtSvo0vd-wHnw>
    <xmx:Ybu6aIMrx97gsYUZ5eMqXtVSPEduW6GyMlEiwspWIRq4PI0f4OscgA>
    <xmx:Ybu6aLu_4LnbJV-zTJVcT5Z8suHS7ZRXfBKYPwqjP2pDTb9gCCpbXN3g>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Sep 2025 06:28:48 -0400 (EDT)
Date: Fri, 5 Sep 2025 11:28:46 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: wang lian <lianux.mm@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, rppt@kernel.org, 
	surenb@google.com, usamaarif642@gmail.com, vbabka@suse.cz
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <kve7xndhm4hzaglmzrpjiw22ut3yvcyb44n3oxx7cayiglhzh7@wwpgldcgl2p3>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <20250905032613.76910-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905032613.76910-1-lianux.mm@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5B7AA180012
X-Stat-Signature: ztqoi69px73m8q7w95jx5sojt43pzauf
X-Rspam-User: 
X-HE-Tag: 1757068130-322853
X-HE-Meta: U2FsdGVkX1+n92wl66s3MeFMbcJ2ZwWd+uvNVit9ddl6VtiW+LIKV8uU/oKxdjKTWgsG/BGiPj8eb4OFTkFVFL6vC237g98rdYjwAI6oNq/FlOzTv7PNbVCwYQWkRxTx4EWqsnAAQp+CGpwQXd+if7beK6eAFUV4qCcs5Iq+fHvf5RED2zy9att/YQwqb1CGGU67XAYJwV034l79tWQ+fXg9NY2wHp8s6ega4BCdxio6IGWG/6BPkNYWKTxOE36BqVDW06UiJsBkcECQg2i5Y2Ctq6EM4KTdOTnAgD7/FNm0Y9XZHVLD3zLYzIe4wVqf/D0IB8dDtbze68TInS1DlSZhV3WTvMxo2em54+Q60XWCTXQlUM3rAbDnt0S1isVn3A4ZezzLeymy2efiQG1PslaXLtQvq43t6+KRi+o73EcAFSqWg/hHti0WqACpsUHqDO2M/B7xUW1lOKKoiysIR6ssww5OKjuEv26lTKV2FWzjg3WWTJL3mJZCOkl0DhnGXznam1iFp/cbNrTiq6B5TUxig1L0HPweYcyiY9LFIiomqsHy9IDNUMLiSmyg+0qYhO1DHa2og3yzQpFMmGPczCne4j/RtP5sgoL3h+M2xwfgu2skd3vRk8bmmHY/mQn9LkxEfuKpqHLtFrV6YB+lyZl4hCZIO72fDIY8bBLN8Pgoxnpg+xKJE2OzuI5NvlplT7Gnqr+GR4tnGlmyB2r7ju+LmBbn+O4hZsqvaAa/TmJR0llBZ4/0znl6q27gG7QfNldZLRpdZnhT+RPKz55AL6+BHNpwM+HhQ0YXi0UbF3XZzRcSV0pCp06CcMx+kXRQiywgL6WaVB1nDjJfLtFNRDRtZ5j6jI2vSkWAespBX+eumcLt+fNmOHMavMSqCDfLs+ZjvZm6ysztmK9FqeNvf0SD9Lzy/9EsYur7sHU/HQwCvx1cGiO0wxv3X+koBmmhBzNCFN1FU9LvKNbiVl8
 2NJGVieH
 X9ZGLcrSGpxgzuizDjXqPydYtNAjpF77wb7KalOKZMlkFBjdVnVmVCHpr2HaYxu7oAjKS9Z4ygkR62Om8Zojv++iQuImy3E54lP5tho6Ug8wpMzomEuKIog8G3nzlG8V88mC9oOJhNlijtRx3XnITtUx65EWGwqdtwyYFj+1mVRgI2Kg6a04JGx8JKOkQBOOb4lj8T9VTUt5C6GtO4RKq5SnucMEM1+Rb0407gWwD+3r1G+b8+EBVGTySXvo3o2bOqcBC9lZ2uXdUtsLIqIRVplNN1dRBkZqBaUo7ROsljeKzT/R45AkfUC1NdSm6jwoyrB6EyeyuwEtJk/qJDJk06vvioN5Ht5BKtI5w7EJqJgrJjytsu77E6CDTGXOjOHAXpVkOmk+eVXv0uG0O8gdqvPNBiTc3D2IrDjOdcbh/s+rxd2IwykVXWLd3CUMFx+I0CcqcOYFvaz2tTTCoMtQo60C+fVoWL+sa4z/xC/36c1iht3I8jQ2DBmwo/5EvqPQuQuK1R1nJrVz4jAE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 11:26:13AM +0800, wang lian wrote:
> 
> > Add a simple tool that allows to issue an advice on a process or a file.
> 
> > It can be useful to experiment with effects of an advice on a workload
> > without modifying the workload itself.
> 
> > Only supports advices available for process_madvise().
> 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> 
> ...
> > +#define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
> 
> Hi Kiryl,
> 
> Thanks for this patch, this is a very nice and useful tool.
> 
> I just have some super minor nitpick on coding style:
> (a) Maybe move the #define PMD_SIZE_FILE_PATH to the top of the file, 
> right after the #include statements?

Maybe. Will do if v2 is required.

> (b) use consistent comment style like this /* */ 

See answer to David.

> (c) when i test, when process_madvise test fail it give some message,
> i think it should add into in the prompt message ,like this 
> > printf("madvise TARGET ADVICE START END\n\n");
> printf("should run as root\n\n");
> printf("\t\tStart and end addressed for the advice. Must be page-aligned and valid target pid address.\n\n");

It doesn't need root. If your target is PID, it requires the target
process to be ptraceable for you. Whether it is or not depending on your
setup.

> Other than that, the patch looks great to me.
> LGTM!
> Reviewed-by: wang lian <lianux.mm@gmail.com>
> Tested-by: wang lian <lianux.mm@gmail.com>
> 
> Best regards,
> wang lian

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

