Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C70CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410A48E000A; Fri,  5 Sep 2025 06:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8378E0008; Fri,  5 Sep 2025 06:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDE58E000A; Fri,  5 Sep 2025 06:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6008E0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:36:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1FE85A75A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:36:05 +0000 (UTC)
X-FDA: 83854841490.17.D8274FC
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id D0B0314000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:36:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="W Dm2li4";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=LoVr9GwW;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757068563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhmSj7a+xiZsubIzj3pCuWSi4hI0PrO23QvJbr4l9jY=;
	b=fNlV8u5qJVXgfgw2pIJD7+lZXAOyCO9xyjctgfqqVIgdgy2Sk3cL2W+XvxIU4OJmBBTCBY
	akpht+iqw4sTfVLQXrH1evzHkg8pHf0s2Q8NO8mDY6NAWBC+a8W9Q1ANT33aOiXjWeXKSN
	kZ+Ly2HbsgiAvpWfTxN5J1ayxBRVtcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757068563; a=rsa-sha256;
	cv=none;
	b=Qs/2dlxkbsZQdo7/+EHw0DotEUYoDxYHW/t85IBZhc3gYzpVZt7EE5FknNOQbSIrFJeUux
	Of3WJq83P1WlkayWqnJKgA0vvWDgIIxNuCl7fTI6FwSBv0G4lw9d8oCOl5XvdKFfakO6Dv
	pI2cpkY0WjTW8J2b/vHpJFlLRNIxtyo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="W Dm2li4";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=LoVr9GwW;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 45270EC0489;
	Fri,  5 Sep 2025 06:36:03 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 05 Sep 2025 06:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757068563; x=
	1757154963; bh=UhmSj7a+xiZsubIzj3pCuWSi4hI0PrO23QvJbr4l9jY=; b=W
	Dm2li4tyTV4ECpqQdwwF4gF0VRzt6AZxyJLBVivSDJrVvvhy4lwEfqVRdxqjHM/+
	ZPmx7o3aESEIdBVWSE1ZKrQcu5OMdxm6PfUwdp/aoblz10rCAPaUse9UGLdMOif0
	+X3MEbNqrNhqcjU4IfpBHL1DNBDX7cx6J4udJTs22XAXy23rKSJo3+aYTyt6T1iV
	D5KxCTQIc7+cgtfMcWlJcwdsHP71sq2eOmi7Zd7TJjHCouYAFylNf684iokfMLQ5
	Hb1Io4RS/ukaKA42DfVlCQIklBIK8l1pUddZDBTBwgyEHFr64jITF4x6rPhTBFTo
	5vhDlksducHIAg/UbSTjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757068563; x=1757154963; bh=UhmSj7a+xiZsubIzj3pCuWSi4hI0PrO23Qv
	Jbr4l9jY=; b=LoVr9GwW5dSlKAMXfDipWenE+4hDoAPEiywoGnxfZMFeNWN1Bj1
	icIrnrTdtL6gfXhK64oBsZ/TgCjjIhcVn17hqJ0BVMZLmtHWRW8mIrYCEUd6GWI4
	o+Ob+ECCvUC3ISSjAbbyGXoatPRmRDBYoR45dNJcWb6tpGw86oUj0UkQaL3jKzDI
	Nps3AodwlLoC7PU6SY/1H4wBU2PhNE/E2f4nEv7LUE/o3lo3BNGP4JkhDt9o8xNn
	aQZRfwgqcl0xjGdJseg8M3Hv1c8zjbOV7zIWVqiwZCEwXHZzhsTyQyHqxlGw1c0g
	Zt6DdetTtOzgWXnhdFZ1zMdeJ6xyXzZQRRw==
X-ME-Sender: <xms:Er26aJQzb7WSICCwL6FNshrnGLr2V-TNCAr3Ltv3OGI07fYGsBaFyg>
    <xme:Er26aJX3xSJeqM9HnR7_0E-G7UNvAo4KD8aJFemLcoqc8BVW53hjs5masKDvfJvMk
    gzSmYScJtfp81cyJVg>
X-ME-Received: <xmr:Er26aAim-TLCdvj-jNxQ65FXlp9Em8yfFxQA2uZW4iVAjA-7OUzmcQnDOhAn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekieejucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:Er26aKczxrBZZJMtzfT4rpRzOyi4XbXfEpfab4zlZC9EhRJI-eSYAQ>
    <xmx:Er26aDdAdutUUO0W2_FVXmzlcNIex3EHusHKnopn-ddEndEgnsJw7g>
    <xmx:Er26aOW1HX707hoz0ZTllL3jDvZ08EG-c8Ahb2IoaaLcYYKhG2zsOA>
    <xmx:Er26aPcHACYaDU1F4j1iAQBwTBCZhbGJF2hROuZFjqm5sbiVEA4bBg>
    <xmx:E726aPe3welLZ42w3sW8ABuQegbCU28I7AN_KloJ_QsanDBl-MGhqGvN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Sep 2025 06:36:01 -0400 (EDT)
Date: Fri, 5 Sep 2025 11:35:58 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <x4pljkh7ajaisod2inrk2gftz5rzyoxujzk3zsswirtzv4xgn4@uke2zolyj66n>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <b411522c-db48-4793-929e-2b80715e9cce@redhat.com>
 <zmueckzkhbfb2fgienlycsl7niedwvccqurlry3udfsjjw2lmq@6ujjt7oo2hzh>
 <15e8b5a2-9b08-4f3b-b174-535eef6dadf1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15e8b5a2-9b08-4f3b-b174-535eef6dadf1@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D0B0314000A
X-Stat-Signature: eop6gsmopkr3q9ykaz6iof8isy1zbdfj
X-HE-Tag: 1757068563-232376
X-HE-Meta: U2FsdGVkX1/XANJ5xV7FFp/6SnDvJDPaql5FykWG7o5jMwdTLcoLMnitb9LKiBco45d9nPvRUD/Cxl4k+aZKscXFGSbjAVa6GXX2WcQxIHnV+NB7SvZm0sjqD6Waz5sjiCTiHPj6OSJUZL4myCYTY6iqcaTdzVnEPqf1R7jfmj53kmyw+sjSH1ImpjeewOdXidc9hhYeWNK6/OSrfD5/SkTnLqZBOdoLNu0ykY/uhHTa4iXDgK7PO0KG4Ajh2gYwBlxPv0lBbV7dB+19tGNYEcEn+z9wjCzeWH2oS8lkePRgmZQJNsm0hffbBVnvXjKl1ZjWfax/EzXmMOpCo2ASLG6wbWN0TdjSbJLlikj2UgeyVluLD52+LrQGUlPCwVpXQe+QJLLu//tOjJHYdj9llXyER+nkGStj5AraRGewj6NZEjB2PUnvhsl3NKf+pi4vwglNaBktVH6TgG2i8rGQR6N+hCYMZJ4ZFe9Kyv5gFz1L0veWsBxL1n7LmxtGSomtN/ZCfR1/mq17+bxjOfmnzDURpFGguzLzXHjlW4S3a1Lm5H/ppEh+hQTYvSGeXQIk68kcX/SOtH9ugbLdepEOT2y9GKmXRqT5dcY95X7tpUWkGoNKbzSz4hXckFHz1LQla8+thVTicqjRFGfNp5sfb8t6U+kVlZwqcXklsDRSlwY9ZpyqQxe9uhK9/WsriwG56/GRnC+dGISb9MBktxEnWSIU0JAkpRB+3SgMPQAa1+KHAmR+6ogJbZsaXEg3OKb7/mFAt9TLWpE9CSM3csUvjVXcRXwKoG5hPRIxoMETCnqX9s7V+rOAZMBzYFJrv3rWyZ3FnQf91+Wmfr8/CKFeQRFBke9fPrBT3utDKQN7AVYQiua9BIigGAU934zlTGsVG4qmdWxj0xJg6pN7M3Id6NkxMgF9Cfbr/zuuJRoCfxpIIYYny7hVkhM054647HGwBOOtRlnvn9bpCUWbxmh
 F7e5Wnl+
 M5H+1vH+YYdOVPnfUQ2NhOJXxSyIu2OkEdvM2ZiFrPKsdQtNiMFhQIDIFiS6BiQed5NAsk+RmIB6cuy6ypNRbe6aPo/xmh2SbHbAd6Ge9scG6f94wV/78toppSy/hbjc2v3pWJzK5zsEagfZj1o42Q0jdDBw51nV3U6xpLxtl9+sh9MUKUajKHQmVgQLJhRqeZvMo52REI0DKg3m7YcidUblCiwcq6xKVipCnOe8ftEMee5eZr23CXXkgJnhPHl+d5Ipj3B2DfhSMKyX9/h0ro/LvZRc9Mu0nZK3OOAX0buS2x4oAM+J7bEEvr29gg7jBUble2YINVKu9vtyOOOhkjORXRuvj56rNCjbUvQvZwlAOPkEm7YWTBa8ChHhASMg2UnWNeyF6XhPl4dc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 12:33:31PM +0200, David Hildenbrand wrote:
> On 05.09.25 12:24, Kiryl Shutsemau wrote:
> > On Fri, Sep 05, 2025 at 12:19:11PM +0200, David Hildenbrand wrote:
> > > On 04.09.25 19:57, kirill@shutemov.name wrote:
> > > > From: Kiryl Shutsemau <kas@kernel.org>
> > > > 
> > > > Add a simple tool that allows to issue an advice on a process or a file.
> > > > 
> > > > It can be useful to experiment with effects of an advice on a workload
> > > > without modifying the workload itself.
> > > > 
> > > > Only supports advices available for process_madvise().
> > > > 
> > > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > > ---
> > > 
> > > > +	if (pid) {
> > > > +		struct iovec vec = {
> > > > +			.iov_base = (void *)start,
> > > > +			.iov_len = end - start,
> > > > +		};
> > > > +		ssize_t ret;
> > > > +
> > > > +		ret = process_madvise(fd, &vec, 1, advice, 0);
> > > > +		if (ret < 0)
> > > > +			perror("process_madvise"), exit(-1);
> > > > +
> > > > +		if ((unsigned long)ret != end - start)
> > > > +			printf("Partial advice occurred. Stopped at %#lx\n", start + ret);
> > > > +	} else {
> > > > +		unsigned long addr, hpage_pmd_size;
> > > > +		void *p;
> > > > +		int ret;
> > > > +
> > > > +		hpage_pmd_size = read_pmd_pagesize();
> > > > +		if (!hpage_pmd_size) {
> > > > +			printf("Reading PMD pagesize failed");
> > > > +			exit(-1);
> > > > +		}
> > > > +
> > > > +		// Allocate virtual address space to align the target mmap to PMD size
> > > > +		// Some advices require this.
> > > 
> > > I assume the kernel coding-style applies to tools/ as well, so
> > > 
> > > /*
> > >   * ...
> > >   */
> > 
> > I thought C99 comments are fine now, no? Like slab_common.c uses them.
> 
> Was there a recent discussion around that?
> 
> Coding style says "The preferred style for long (multi-line) comments is:"
> 
> slab_common.c seems to be the mostly the only thing in MM, for some weird
> reason (and it's even being inconsistent).
> 
> So please, just default to /* for MM stuff unless there is a pretty good
> reason not to.

Ack.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

