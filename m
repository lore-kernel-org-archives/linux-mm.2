Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0876606A333
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=K1lUGFZH
Received: by kanga.kvack.org (Postfix)
	id A79C46B00EF; Tue, 10 Nov 2026 15:19:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A513B6B05B0; Tue, 10 Nov 2026 15:19:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9674A6B05B1; Tue, 10 Nov 2026 15:19:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7221F6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:19:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01BDA1C4388
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:19:43 +0000 (UTC)
X-FDA: 85420325088.23.693D359
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 148661C0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:19:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K1lUGFZH;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794341982;
	b=PfD8o+EtKm06iHF6po9/Tp1hvmAeKLZLVpPSKHpzbPnP7toj8xTlHclkmYpFKiUCAIQ4DI
	39W1ll/LfW9jAH8Y6ViWzU5bMoF2j20rBH5ptwPXSNxHhy0O3sm0TkrdEIoP23372CE1hF
	Fezx6HNMQquipr+P3I51P89DHXtree8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K1lUGFZH;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794341982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rqy05NhlUV5BjanU34c5iOE+GBzU8rBDGQIQzRYoUdc=;
	b=i0hUxd7sQGxBQGKMUD9jDb0KFwG5KYgslwwSZwMp9JoSKaR54mA1nGTD1iQ2IBJgPF+6Sh
	IfwTlv+ITUbhxEHVAsovrm7BlJButm9lVupxemGtW4/orypcGS4HEszOmijGm3RUrDOxCI
	hPbDJsPHjaD1M4geqqatxfQ1DNiS3DA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD0591477;
	Tue, 10 Nov 2026 12:19:37 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C22FA3F85F;
	Tue, 10 Nov 2026 12:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794341980; bh=YcUtf8s3nEe4c07U3pzR0x25fAU/uZ4ZSOAodtFGIC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K1lUGFZHGwG996BA9mqSWjm7RkxTjcA7UKIzyNKKoscn95BhhfZEQevkP0Ts6799j
	 prdxvNx6p3ReV9oKcpz1q/0x7bK/EGQhE0O92mz9H5+v6yV2aZOAW9f/eyGD2SsAJD
	 AAUHLa6OpYFXKbl5a9W1rpf3d9isIhoWnNuuE05Y=
Date: Tue, 10 Nov 2026 20:19:36 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Rik van Riel <riel@surriel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
Message-ID: <avN8WISVUF7u4bXl@e129823.arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
 <avLqwIWHa5CAbHO2@e129823.arm.com>
 <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
 <699499e46ace0875fd0f32052399e665c8209ea9.camel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <699499e46ace0875fd0f32052399e665c8209ea9.camel@surriel.com>
X-Stat-Signature: pjepdurusmfxrimu6tt1s6q113gpy7wt
X-Rspamd-Queue-Id: 148661C0009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794341981-912704
X-HE-Meta: U2FsdGVkX19XtvdXw7bWzdcWVb+M9BHFuEavGP7SSlYPi7QZeSpheO2OmG0m2ElgTAqsh+kahWmQxbm5Hrf1r+tn1UImrh8me0itygRYmDlejTMJJURZXldlhFkF4jH5DxWfIabFU8e2odeQEqpKXe36u+KQz34U7H3ZdntURDVWV1kVtOumJdo/R6ZTFweCpyNnnkxOv5vNKbQ1PcroxW79XlQYBaL2jmZI/l7JTc+t48okW39HmWsUq0+C4QhBIhcBzhYJtDGgZ+CTSSJU0Zw27iYNqbKPO6Vk19AB+8KcslYFVsXeah/TS8rzjhRE+qzcmG6rKJ2ObOKq/OJFPsxjLlnQnRQCCmoUAo6jmpVn2qvYk4dOAg6dqWTfNpIs4yndAP7BPOfm24wpMYrb+/mIdknl6E6RfBhpXmjZyid/A+KXAyv6dnJyiyKLk8a60Asn003PdPqnu8P1I2uTuFoQtTiFQ+RGdCTBabzZ7qjsRwR4dydprLM/OxCWldo45MGyA8wA4SnMg2jsgCs17gesXfgH4tIzf6SbAeId+HDiSbAu+EtAks08P3X5I1r82n1MmWufGkA7mL48tzzLpCDMb5rHhTJIAvcYGPcTPAhvBU0DHaKGf34prBYhHjpM8bcL8wP7irKQxYouJt7J/Jnk2OIBLxfTAe7CfyYVBvMXfNF2OjD1rnn+KGRT4ykTTQ74OU2chLi6B3+37pX3N9gxCL2Lg+gC5keSsWkPFMtMgdXLsPQ2hoiZp6rjKeh+OR8M+s6zDAJQg84suvQV/Tdr6l3YOTckOajFrG0IbHUmjv096e5H4ZF9uKdjNtznFgC0UuSKx/iyGM10hMEg4YR6x6lBXd/g3eMTbGUjQ0g6vSfe5SuzWD98kDLqoVKV4rdoYcqwVqrR3FAR2cYeTlbL45wFP+4U5j15xRzgT4dA3w7+VgSl/Z+zU6+bAqG3TMyO0uOcbFlGdjdFC+k
 zadrazWR
 EKy2oR7IOGIS2mYw5BOvL7Wvzps8FjufqpxdEBLP2mUVeqbaEVgA1f9ThrEauTlYSySQIg+wn6Rd0MZajSGh8xUqsczx5KsW0FCytSbQiBI85dmfSXfSgWLUClo5AXery0+EZhcxpuC96NkcvdhHsyz2D6EXJ5yFr/rZp4bEnxwkI7Abvz7HEuP4VAmm52bu8aTgGTu6QNlpF5+9Grjnm1FW85S+XUAFqaO8pt2pAypIVYf5Vq562H/zU/4mR/IeJ5WhnjFsqPVOnRRreskOJAChwv6v/wR/RsuTD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:21:18PM -0500, Rik van Riel wrote:
> On Tue, 2026-11-10 at 14:04 +0100, David Hildenbrand (Arm) wrote:
> > On 11/10/26 10:58, Yeoreum Yun wrote:
> > > Hi Rik,
> > > 
> > > > On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> > > > > This is preparatory patch to make gup_fast_pte_range()
> > > > > batchable.
> > > > > 
> > > > > Introduce gup_unshared_pages() to count consecutive pages
> > > > > within a
> > > > > folio
> > > > > that do not require unsharing, and use it to implement
> > > > > gup_must_unshare().
> > > > > 
> > > > Could gup_exclusive_pages() be a better name?
> > > 
> > > Yes. This seems much better for me. I'll change it in next-spin.
> > 
> > Not quite the right semantics. For pagecache folios we simply don't
> > need
> > unsharing in MAP_SHARED VMAs. That does not imply that these are
> > exclusive.
> > 
> > So it's all about "number of pages that don't need unsharing".
> > 
> gup_no_unshare_len() ?
> 
> a little awkward sounding, but it describes
> what it's doing?

Hmm, Wouldn't this name be semantically much the same as keeping
the existing gup_unshared_page(), since both essentially convey that
no unsharing is required from GUP's perspective?

Anyway, naming is always NP-hard problem :\


-- 
Sincerely,
Yeoreum Yun

