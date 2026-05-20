Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EAF8CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01FC96B008C; Wed, 20 May 2026 17:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39B96B0095; Wed, 20 May 2026 17:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E768E6B0099; Wed, 20 May 2026 17:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7A806B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:16:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 827F5A03AC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:16:10 +0000 (UTC)
X-FDA: 84789056100.12.2BB11EF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id D5BE820017
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:16:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ahb0j2Ei;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779311768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fU02cunUf5qx+CTJ998toCQden5I5L9eTw1htlE14B4=;
	b=rc/VNy67z1HSNl//x+4qdBVOR14gVtLeICxF9TkU9hqih2wN1l3ohk3a4QMEiKzwQlinUN
	9iWH8BuY1Sm5xO7PDVv1TMf3kDnkDjn/hkgwsaQwluw/Buu7XrjAk2D/erxK3Xf+p3RkyD
	ldwH6a7UBBo5Dwmc/zHispxUKgbreB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779311768; a=rsa-sha256;
	cv=none;
	b=8WzLCOLfPxqClEoevTmF5lroJjy8KNZdqIwa37429Afyae2NdfIeXm/jxyyRZwFdOzrOH3
	gVTLnT8RNEXlNbhcIbInrNTz2VfaKx90tbw2W47ONWd3JgCS/xzxBghOFQ0WjuIJLoYJci
	I5vkhl6VOv6fRtC6eRFGqnzkQfaGeSA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ahb0j2Ei;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=fU02cunUf5qx+CTJ998toCQden5I5L9eTw1htlE14B4=; b=Ahb0j2Ei6nx5qSArSbx3QXwe7j
	nN0qnERaYLGpASZAP09LlU+EPQowKBvJPWhRsI00juo+im78mkgYHs+sP5ZWwXXBd7zRVmKWFHh91
	ozzCsrVpwBFURX4JqqoPT0iEmX8E9NvxsJFClE4jAwVlL4pGe782qw3PvR74tDYThCZ3q+fwmuY2k
	TzdU054pRFbgWK4qDrlWLvQekRsHk+y4KM+0uWUFsCECk4H+2CGnBJFwpoiJbHR/MvjI7M4kc/Ssx
	zg1lHxgjWogJBSyWKXMDALCFwuerNCe/Tci5nkDTpyDfHMo2R9PAJoJdp1sxjZy6+MelEhK4vLDAA
	A5g2JMmA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPoGl-00000007air-0tv9;
	Wed, 20 May 2026 21:15:59 +0000
Date: Wed, 20 May 2026 22:15:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org, david@kernel.org, vbabka@kernel.org,
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de,
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com,
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <ag4kj84EcKqamdB-@casper.infradead.org>
References: <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
 <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
 <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
 <ag4h87CBd-gph9zX@casper.infradead.org>
 <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D5BE820017
X-Rspamd-Server: rspam04
X-Stat-Signature: 6gsu9c3q6i3qtt3w7jyifzn3rs3h486f
X-HE-Tag: 1779311768-869098
X-HE-Meta: U2FsdGVkX19TWKVA8Mj3Uqu/naKPlTy9LT5bFvjagKium/EyoqOoFmWBGxmwCcIB89PortKfEOBv8RzExTwguG8iHf4F1ERmSAJW/vbzQD2/rkAewPGV0SNsANQQ+GFcBDd+y+jj6oLYgQQX5fQ3n4YKzhnQRD5KTHmMl4zMa8Zj3Ib9VUyDToEDZKUBm4kSZaX0WQPof9w+1V6TQ1/1msNfbflClU+maZAPjFDQDe/76o80eApSc8LtDDLYU+dPwwURXazo1OlGPZyB4Qc7DNhEK8gw8XcFoYRkqmC0pywenrQFDCjykzl/1BFAnUfrZG6aDcyYBU5MUjMgMfIYiBwCe64z9n6jCvZs5F8qDI773qh7Sq3QbYv7KX/SBMrrsn5U+dhzHNpGprCT2jL0pH6wJd6+w+PlxTlCS7Ezt6Zy1PJ7Apm3oCkJ4g3XhxbNIAGm8g8kG1In1R19j1ROr6c+0FV+BJBATHIU+z6/7An2U4y7cG1tu2ONPV0Odjknlx+b7XbKMiLN155krlSgyqDfXwIU1E70KRzvI20K1HvkSvXLsnfcU13OG1CimWxausBHOIqYya95S0TL0ktX9ew+x8E1+uW4hzwyN033H67+mAvCOwzMMLEJyV77bK7aTe5VA6CCgy4QpztisXk1Vqi6icRbQEIrjcJ9I5xMw881ZrcHue1XdQDXI1RctK7vNlXGvm2/h8Gaj0/5OdDVpVywSOrw5Vsva+igQHYZmaU7X+11MmVVWPnnhk78pQ6Okh988vvgXTSzh3lfTcQpjV7L2yWkkC6GxWoda9GUYiGcpht221WnnGeZ8qX0LXz3jgb7b/2etBffhHIblvAVT0iDbahEbF4BFMtTLa+e6xrOy9df9+zwXsK5ZTcMImYWdZZ8StFXRC4zIGtWHV2eo+V+w4hX4RT2kN/Zrb3r7bb01448IGC7KpuvSEzju38l1ByoYOqT07mb1vWmKFD
 GMLsJ6pQ
 oWQv/BAaBpdIeUy4yqfyjB95KEZGlNxqLdacMXS+ldTlpExqEPg2VGp8q6GBZkO4fPiuwR8WaByqSNMDNC58wadUQ/yxQjlwNSCSRA/ODpi06v86R+JOF697/CW7AFXNDgaIidQi84JIlW8XXSHBHV2+PXDoV47J/GAhbYZ7xb9+CLxQU64yxsIjysqFvELMv9SH7Q65bsbOYgAzo+NNFuatBFCmC9J3PTXkm2BCy+biKND085qDlb2IiE5uoyMrYWUXJdlvbeAJT9v0CuozBANQZDb9pdVVLtQfwmlXYZ9JONxuTdXH4mLM8/YUlVA7iz46YKDuGhREaTLADYEAvIZ0rC0b+jbkw0OvHieN7cc+hmUDvMcae7ZZ6jY+re+x5Onh3ux80P10HGe4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 05:14:20AM +0800, Barry Song wrote:
> My understanding is that we should not blame applications here. This is 2026:
> there are basically only two kinds of applications — single-threaded and
> multi-threaded — and single-threaded applications are nearly extinct.

all of the applications i run are either single threaded or don't fork.
what multithreaded applications call fork?

