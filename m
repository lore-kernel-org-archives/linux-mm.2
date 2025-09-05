Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7EBCCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5CC8E000F; Fri,  5 Sep 2025 06:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCC78E000A; Fri,  5 Sep 2025 06:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2C78E000F; Fri,  5 Sep 2025 06:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA468E000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:24:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F1C91DEBF0
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:24:11 +0000 (UTC)
X-FDA: 83854811502.05.8774576
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D09A40011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:24:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A zkFO2R";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=j9ioI9We;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757067849; a=rsa-sha256;
	cv=none;
	b=iAPHCO5evJIWS6NglkAPdl17fMAKNMLqlh9qlPDibIrxbvpShQQw8fDl1tVifGChDdK9JA
	yQu5twQfyA/UUNkSTYldMA/QEFqWWgHNjIp9F/CHlJqo2pywHozfoiWSlO3xq3V7ifl7OM
	yNyu5zqj2CkRgfOd1MvywuRU36TXL/0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A zkFO2R";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=j9ioI9We;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757067849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obiWLF+7+4xwf3bU5itVhms+IeV4H5PIT+3MNBLQGVI=;
	b=0PKeW7sdtHXDyToKvRY9HExlC99w1QeU86mkJKt5lXRR+n/CvvHWvXhVSc8DjdW4JJqLPg
	lQ4qIQrAIE2gvYlOPuaZQyW97vSlGON0Vw+rakzH3SH/ILdj0t5R1FjYzfXtK6G0q1USSN
	Z9ZRh5hFbbzaZhTBpySwAQ8bdFJAYRk=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CD97314003DB;
	Fri,  5 Sep 2025 06:24:08 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 05 Sep 2025 06:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757067848; x=
	1757154248; bh=obiWLF+7+4xwf3bU5itVhms+IeV4H5PIT+3MNBLQGVI=; b=A
	zkFO2Rlyeh6T60UQF68r8TWsXG+cwQQMpZLMIqgS6zaAZ6trsNQA9e/a8ZNd0zOP
	Exxiz+y2CkpF6x6wdLD0dIqJfsSPwFa4MrAa1uKEJaL3v/aDn4B7+ugxNozPy0+p
	GK5jiustmxeMUb6d2kAJLIG0ULoBSS1JrxQjSgL4ANIAcE1Z0weqHwIfSFDS84EI
	1q4r0BvXTXLnXakKgC1VmdtcIPl6j2QGRp+4mtE7XYd2Y0Bz3VYC0xyOGnTozb80
	TzmyD5/49losAvQEMfCSYjjNT6roj5eFRy75v0GC4l5D2OiQqZwYfmqgM+oVOUbI
	7KSmDmRXzy//MyTxyTSzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757067848; x=1757154248; bh=obiWLF+7+4xwf3bU5itVhms+IeV4H5PIT+3
	MNBLQGVI=; b=j9ioI9WeRum1jD/JkbSSo8e9i9OIO8O4fPAU8vNH7A2f7VSIKdC
	5LbNBe66KJ1ppuaRmcQQuU49OB0GebYoqkqsy+MFuAD4o0PG6bcddxvxJQs7plGy
	HmQRqTRoCSNnk5ZqA9RmB9hCf/rDxlROQ9b4C6QmyaQv9REdx4kOATKNI3q9hwUH
	TmDyz2ZzN4VxcYEg3YJgDIAYi5hfvj9wDrjbIVlD3blcnPlP0jaDBR98ZtRUo7oG
	FlzzRAnMo4oqReLHrmvUJtM4miaMTbOem3g99cnpM0z96Rj1bjvEm6+LMRpLvqFA
	J7umqskEiPmUAYhww+66XNswe+zAKoNDQhw==
X-ME-Sender: <xms:SLq6aO_w3HajFSymw5cmUymqC_6DHiQPIAiwymAcdUY9uQRAJAkM5A>
    <xme:SLq6aFRZg5BNrBb06luwcBfmTLiE8zCdQej297ECRCmUNUjVJf5sdq2c9aGM3Cii_
    fK8mMr95z6ivfGFdhM>
X-ME-Received: <xmr:SLq6aFvegdDp9_XEdtdum2-27cF4rfMY48ksuQ70uGogB3UKJP9P1XE43aOn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdeludfh
    feefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvtddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtoh
    hmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdp
    rhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprh
    gtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthht
    ohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheprhhpphhtsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthht
    ohepmhhhohgtkhhosehsuhhsvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskh
    hvrggtkhdrohhrgh
X-ME-Proxy: <xmx:SLq6aP7A5AywEzQZ8zKiTuvFvpTfbc9iafw9yeuJP9_DG2Fw2QtvDg>
    <xmx:SLq6aEKYqFVungK9L5LSNrB1uHQ2pyQ2LFdvP_tlmlfPz6U69Dwo4w>
    <xmx:SLq6aJQUy6RhLx1kxWRKTK_0eJgUWXl4jFxayiUvCZ66En5OSW6AFg>
    <xmx:SLq6aHqSNmzuxH2yLkrnm9bSMiCi4wTvZbQNPSsMFyyAde-JofDsxQ>
    <xmx:SLq6aKrI0xu3YOho_bcsGCWsThRXfymcEX1H7DcnWsmlUcbZcSm1uyC6>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Sep 2025 06:24:08 -0400 (EDT)
Date: Fri, 5 Sep 2025 11:24:05 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <zmueckzkhbfb2fgienlycsl7niedwvccqurlry3udfsjjw2lmq@6ujjt7oo2hzh>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <b411522c-db48-4793-929e-2b80715e9cce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b411522c-db48-4793-929e-2b80715e9cce@redhat.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D09A40011
X-Stat-Signature: c4w75nmjkegh7x8sepxb35cjmczuy9x1
X-HE-Tag: 1757067849-590848
X-HE-Meta: U2FsdGVkX1+oF8anECwkbvSNujmvvTWDwnRa3RVHKDiJQ79Gl/kdfqeybmMXdOOUQpzINS1GZVCW7cZXJMox2TTdP1QQMm/A5L31H1+aCc4pwQTDF9Im6PwOkhR15x53qSjYZn9u8PCxzPiJPInF62Cz+ifIxTwofq5/UF4XNxo9Zh4dxTORsIC+HsvEO0M6i00JLhwZaIO71wYpMBxQRF3QeIFaGWxsppqShkj+7uKSuiC7I/eIIt3BkaF3FCGpDryNKIcZKuKV6+BGqU5GBQ1UWVm8+ndMM1y9Fgxe7Y011cyQ6iJr7wT0YKDOeELHdrb7lkQ2WJP2LkePBTyJVT2lLOnnpb8bnaPsliQJsF8UHZAZ+HvgOWg9gHqs9XgfADZxs0KB/woZPYdShvuoRvWC7Ap+0unwsSHVcjFm6EOjNJqrHkNAs7OYMQwwqf6a1GCYpBjkNhf6BmPUL/XaN5a+H0Mpv81KXnB9Pbt58dJRohmlHviYhBAwbAAinPgWpeSfYCWbNar7GqbUibOrg3Kx0b3Mxrt/wqcYA4FAXx/lq3PXj5dQwL/FG0lbmlAQis4t4zgT0HzWmK+0+83WcL+dQH1dFIsTiO+elugEDUc3/1yTsEOgSHj6dDdAG9p5YpilWz+Is3bpvP8Ver7M5quSWI00r0RhBBsOlKbVeCSeG8TWK6ow1iukJxansR1y4tnx3cm0LYpf2DQlmornD7KVg+k4I7zFDAZcFUO1cL3/vYOPIxGWhgPNGQSLt92kpkWbKdRSnuq1Ove42ZdgwTPKu1F1bKN5Q6AAiEbetqxoWbTsk0veV6uNpElH10ZOPJeV4NA9Im0Hzzv9ixm24jeChLZl53s3kjVItJszCzX2LYmamjO78epfttNlP44n6DJJaP4ZztzkbCi5MKEqT3z6gvvRFXntQRR3k3jeWn9Wp2IG3jniVeaB+1JYD1vRcZnsBw5bmZH1m+Mfp0f
 RMNXKXvs
 +K48h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 12:19:11PM +0200, David Hildenbrand wrote:
> On 04.09.25 19:57, kirill@shutemov.name wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Add a simple tool that allows to issue an advice on a process or a file.
> > 
> > It can be useful to experiment with effects of an advice on a workload
> > without modifying the workload itself.
> > 
> > Only supports advices available for process_madvise().
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> 
> > +	if (pid) {
> > +		struct iovec vec = {
> > +			.iov_base = (void *)start,
> > +			.iov_len = end - start,
> > +		};
> > +		ssize_t ret;
> > +
> > +		ret = process_madvise(fd, &vec, 1, advice, 0);
> > +		if (ret < 0)
> > +			perror("process_madvise"), exit(-1);
> > +
> > +		if ((unsigned long)ret != end - start)
> > +			printf("Partial advice occurred. Stopped at %#lx\n", start + ret);
> > +	} else {
> > +		unsigned long addr, hpage_pmd_size;
> > +		void *p;
> > +		int ret;
> > +
> > +		hpage_pmd_size = read_pmd_pagesize();
> > +		if (!hpage_pmd_size) {
> > +			printf("Reading PMD pagesize failed");
> > +			exit(-1);
> > +		}
> > +
> > +		// Allocate virtual address space to align the target mmap to PMD size
> > +		// Some advices require this.
> 
> I assume the kernel coding-style applies to tools/ as well, so
> 
> /*
>  * ...
>  */

I thought C99 comments are fine now, no? Like slab_common.c uses them.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

