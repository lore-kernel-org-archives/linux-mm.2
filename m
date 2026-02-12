Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A20EAEB490D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F7A6B0005; Thu, 12 Feb 2026 06:41:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2F66B0089; Thu, 12 Feb 2026 06:41:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF576B008A; Thu, 12 Feb 2026 06:41:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB63E6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:41:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B7C013AF36
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:41:26 +0000 (UTC)
X-FDA: 84435614172.19.E02930B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE87E180004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:41:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZRwvhRXh;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770896484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOmFVA8F7A36GVrkgjTKaK7VCkhN532H0IBcW3fjmfE=;
	b=l2MNGFjuBlW937vmkcLt5ipm2n+jQemYUBXW3E2HvVcg2lLLmaaq2/9LUkf1kPojXCzrcq
	PvMEuPqzhkLAzCP0uTDtYmjWm+porqLLe6UmEG9q5aCP1lzDIXp9JsztI9Gp2uPB3NiG2x
	cCurF4x88516ifWJdkXLILw+k9UkjkI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZRwvhRXh;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770896484; a=rsa-sha256;
	cv=none;
	b=dI8RIUIcTqfMRR+Hd85i14zawgpVCREOmvT3hdoa65vnzsbdmGVonJi4v9X4xrXzRsHrQc
	+DchDlTELiOZmIHQYlbCNF3go9oolPtCNNawBfXpae55JUkj1j2Ja27S3sNZ0Mwk5l4M/D
	vnj2qVfrC+mGQYHR5nvAIygD9LXDPIM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A8E2405B6;
	Thu, 12 Feb 2026 11:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C7AC16AAE;
	Thu, 12 Feb 2026 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770896483;
	bh=ZH+HbmVIIzMcIEa9LGN6wkR8qjpnh0O5mXXLZ+jp/ak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZRwvhRXhOyGP3akEut1HqTFpeodKL4dVxRPzvaQknwLED6HfcBS/051ZarH20JOZ3
	 enUK0HUxeog6dcdFzX6w9NeBTgKb69cst6G1M4cmliddugqq9a3bfjTB8jHrp+53pH
	 3KqJK/uJgPyOUsjRm47AYQgpJhH4HW1u2rkNTLARSwLv9l8YBaLC2cLrKkTETszu1+
	 xB+moFk/aQrxBvZ4ti4W3TmizA5rUqf+GpXLtnw+u90WdnPDwBJzbd3yU2A3Z55GbN
	 U091G3xG/XyFhlDnHRtsjGr9J81Bkmo1TPjGDo6u/lmh2RNQADUT36vV+5bV5U7sqO
	 flsTA3feP8fUg==
Date: Thu, 12 Feb 2026 13:41:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] kho: add support for deferred struct page init
Message-ID: <aY28XI1AR90kCiec@kernel.org>
References: <20260211173954.2091119-1-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211173954.2091119-1-mclapinski@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BE87E180004
X-Rspamd-Server: rspam07
X-Stat-Signature: boo8ody697xq6m6shthay1fxfyk7mq3t
X-HE-Tag: 1770896484-284803
X-HE-Meta: U2FsdGVkX1/hQsoRvOtRzrlXcSz/j5mB9mrDei9axf4eqrzQEtgidiacCHxd9vVfzzcobsswrIFkO3cBbKTaNm1bxZ913NV0KndUdxt++BllcnXNO7rFdsmRMNIlevJh6ojJftwKzUuwAOnJvQBKB34qWJnnFazWIzHca/PlJYMzNbAWHHBI3UWUO1W6yNhZ+jj3vinBB00NlWtFII11dwGP8KoQ6MrTRX/GzpAYDjWIeGdmvdh9f/N6DaUJ7OMB3l6y22T55ezaut2rBerWmGZrb0unaInRjVgteTfKffSR55tl9yCeqRLAO7T/EGGpfIyN+Y+DqobLLyDFD42Q/962QLJQWPKm6+2iveOxNna8kcMaFF0Ne4swn6X3PHNg/kZApUtbRQ8s2b6ILjV/jv2meH4N6WXvdv4OY69zD0EeSUGyq8Cr01X/I2tBAg9O24BaI3zZNkMwzVqMexKpnHJE+cqZ5RAG/ux2KLFyigpVZDayW5qmrJc//X753e2YmLAUuax9p3f+obCK/N8kNnaT6JqK78Paq0FwdrR+sl8g3/tZ9LtRKzsV3CPC1iukKX/PGBBFz+pg6JtRaHOjxksS06fetKdFA5/OOjeokr3qdG7nIcrLJJXNAPfYaLKvbWIPkWDYF/kH7kv+7ZfNe1GuN/6T2xhnEa6KREcckI8kHLVb9Clf8TODNlb15XAiZYuzT60aj5lktwAbwN3npUYkzxTb9dWPl4wV66iZBseJ1ijJW0+XEeROAPNJGyWo8RfOyhvazwTqN1kNZPxKi+/oWlxVQjg01CYbh+gKLBC833UcR9hHga+nwoESUeC6ySnSq5UenF7d6Mgzm7pXk3B6oGDJIqZ3SVJ6DLuhR3kR32/OdbgrKoK4WeHAtEup9eWjoD61q4NW7F/co6/M0aODj3+Qjvr+WqySHVAx2xpUXtuSAfRUU7yaBsnHSeIsFFoNxCDczhL4aHQgywZ
 9jQjFiAL
 /ffmUUumUp5qnaNKJHAj9ICYd4F4nhgcqSdilBZ2zD1VdqsKEvvxLD9jlRNc1SDKFcGI3IM+0nGeLDadXlP59j8JlIjKCFhzRnnWO8JAzcIkJxOIBxagUM3lOI2SphXzLyEnn/XxPPyWRgtHKbbpfJTXQQrxx9NOsKg0t757ajUrOEGOvJT8T2pQCRNUZjVW0Y12/GSQuP8l3eaRDdbO3xU5BKunjQxNCEmn4v55q5Qjhf2EGgmfA1mAj2KF4uMN2B93hIImst89ZKNUFaAfLzvy/73jIUbZ5xcq4dB1L/rBoAQo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Wed, Feb 11, 2026 at 06:39:54PM +0100, Michal Clapinski wrote:
> From: Evangelos Petrongonas <epetron@amazon.de>
> 
> When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> initialization is deferred to parallel kthreads that run later
> in the boot process.
> 
> During KHO restoration, deserialize_bitmap() writes metadata for
> each preserved memory region. However, if the struct page has not been
> initialized, this write targets uninitialized memory, potentially
> leading to errors like:
> BUG: unable to handle page fault for address: ...
> 
> Fix this by introducing kho_get_preserved_page(),  which ensures
> all struct pages in a preserved region are initialized by calling
> init_deferred_page() which is a no-op when deferred init is disabled
> or when the struct page is already initialized.
> 
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

As Pasha mentioned, please add Co-developed-by.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

