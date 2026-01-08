Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72688D185C2
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C696B0088; Thu,  8 Jan 2026 05:42:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72816B0096; Thu,  8 Jan 2026 05:42:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72416B0098; Thu,  8 Jan 2026 05:42:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A17A76B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:42:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 637EA1A06CC
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:42:28 +0000 (UTC)
X-FDA: 84308457576.25.C830229
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 941244000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:42:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4jPPnzlC;
	spf=pass (imf27.hostedemail.com: domain of smostafa@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767868946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCksppsN2qljq533bVWKBzGPs8aXT6gZzyjV+hGv2Fs=;
	b=nFRPU+W5nry26I3KcORBclPlJN8CRaqzgEJs/IdPSM39sDosADVpuvnqdIo5xnUbBVRrgP
	QiAIe6PtBdQXAx6MobsuGBtjBagQFrt0+c0JbGZSGNyQhxkXmxtfWMJXvL85NNNHDXjkWI
	D8dO8TUwK84thjIxNBipHc366E7dfig=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4jPPnzlC;
	spf=pass (imf27.hostedemail.com: domain of smostafa@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767868946; a=rsa-sha256;
	cv=none;
	b=PJZvVHevvB3bXtvFqkvvoE4Ceo8oSP6rrTXEPMWtTBOn2Bw+x+9cxE2pKdb0+4p/1WxUCC
	XJ8UsEyv57e8sZO8GY/9aEL7A3Pdbhz0gI9abDLFp5NgJX/oR1srdNpJC4y3A+JlIG4u9i
	+PIA5rs41t5JozsioTPOs270tZdcqRI=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso118565e9.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 02:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767868945; x=1768473745; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iCksppsN2qljq533bVWKBzGPs8aXT6gZzyjV+hGv2Fs=;
        b=4jPPnzlCnQoWoz0t4AAHS1f/Qw2lNhL6tCGeukDquEebN5WIL1qe590B2NbgpHI6wt
         UbUNnEM2WskcCYq10wBcfuutOGESOjG5dLLI8zzlzil/TkGbrb5qcMlQKgHfpTXvf3zO
         NsdUJKdBh2IC95Sr2T8MYbFyAK1qB4EbduxQdw+xCk3yCwdF5SS6nLqj1rX1r2E1UG+b
         OsjQtuw77ipyZchMsXQFXj6lx5jsvM12Bvt1ztHvwFgpESzGqb9aRjhkJ+WhW0dOrwVX
         us1fCOxVmi5rXKlT8G/gS0QHsvTDQkB/PaVTUpoZRzLrh4dQG9rPWPGjJAdddLfc9Jhh
         Tugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767868945; x=1768473745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iCksppsN2qljq533bVWKBzGPs8aXT6gZzyjV+hGv2Fs=;
        b=R852rV67RQCaTJjTUbBdOXMiEfLwBBQEtwXDouaAG05mjlaSahraCn6W8NTO6KxXcx
         OhEpTh0Gh3xNq3u+VapzQGU5JUO13mpO2T42vwW0l4NCJTFBSNLhl2h/lwa/vA8Hibi0
         0Gg5cOuuLCKTZiBHtp7fLovdepUrCFLZWLxmjWJScQFzUBSo1Htx98t2wgZKsc3+VuPu
         98r8Jysx9jhrHjvDrARwIbhdLVheasW9DBolI2YFsQVFhJcgJZW80XKljK8vjtjjWwmy
         aV5HOkxr8b+KlH7E1A3E+xwEZ53P+PJq6zih5Wt0Z6GqVNbAK/0rO1+s3F1ZoXNhnCqN
         LzNg==
X-Gm-Message-State: AOJu0YwA7SmOtct3+WMXVcxoila01o+Hbqcj3htOtV9hIFaqo0i9RzFY
	TiyAYkjVIRb7aAhdXCbxxUNp38+2HCG7d8GYTOvg1hpVN9zbjP83WeoZWhhFAki94g==
X-Gm-Gg: AY/fxX7vx14GMz7UzpjXQX7+GJ15IsmcnYbMYxhx/IHAxVoU3Wms/mfIjb2SURF51u6
	//77ho2ijhZNYlE420dOvyIC/SDwYUvLzJ891pSHOnpvPNwjZs76shV9I/0Y+JJVVUQMaaBz0Mc
	EfJhtlrIG8WjeQ333r43yYzMH7S5Y5y+Gq9sPW7pxjD0LpqDSTQ6GkakFWeV2ak0jk4Me35ezfE
	SRhi0DC9EmgKYDrmnqWxj0p1cecDnyOFoZdSzlJPnviDKpCNBM2qbUyMLt7PROEUKCwA8r3qYO4
	Hteu8qdnnIwQfvLhl17HXfMiJIUOaOBuJ6ENeG3bKFjxtPJWSttwtymu2pvBZOia4h+vKwCpqvB
	7UlfSMuBgIrEjQUGkcRkakESJe3jcNakbC+ff9lAxQVTiQQfGWP2cw38kWtW6bpnIs4e68lXdUh
	XAPAVm2HSjSPgc4yNPjlKvTsdO+1iIMRQZFDtL7NqP5gDjTb5Bg5U4
X-Received: by 2002:a7b:ce90:0:b0:477:95a8:2565 with SMTP id 5b1f17b1804b1-47d8ac3eea6mr350785e9.16.1767868944788;
        Thu, 08 Jan 2026 02:42:24 -0800 (PST)
Received: from google.com (171.85.155.104.bc.googleusercontent.com. [104.155.85.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0daa84sm15517528f8f.2.2026.01.08.02.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 02:42:24 -0800 (PST)
Date: Thu, 8 Jan 2026 10:42:20 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com,
	rdunlap@infradead.org
Subject: Re: [PATCH v5 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
Message-ID: <aV-KDEGlplD5EkBx@google.com>
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-2-smostafa@google.com>
 <1a6aedcd-34c2-4e26-b07e-6eb8d423b759@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a6aedcd-34c2-4e26-b07e-6eb8d423b759@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 941244000A
X-Stat-Signature: 9awzsgbj8uaicf7gupjx4hjpw3bxue53
X-Rspam-User: 
X-HE-Tag: 1767868946-614143
X-HE-Meta: U2FsdGVkX1+RUHlTSbZcQeNHL5AmMQY6aCDtBs5oisf+ZPORI/gefffz731V/0VRDsn3xSBn3Swl/xB/v6siur3jXs8gElvAK7anjdIk4AiVcTVo1mVpAfdALCtkDkG7mvQX2nCIAxS3lx7mKfNVzzUzKOCMTHFbVyI2iCJStqwsHQcai0empKu9epbwQH4PDbyk8fG+mL14wkV+gnl8WJTBa/eeOUvkUe7OCSfJhVLFVBBegCrW92XOklZmo2xVy6vkR3ipVQim2PXRWkY8f6IOF+tstcrP9kuhCr5RqlxIFFIU3qf5ggNQ/yqOYTHYWwSWsYWzv9lxFVqU92G2Dx1m8gyKsL/2XKqllpMFNhyGreptLa+lj3ohfoAzyNuFlqzW6cVA0zPXchN9Rrqi7mDq9piXQ/NA30z48Hi0Tq4eTy1jyJt8jyfUyEoJf1g1bvvjZOAq4riRBKgSaFdNjvT7Osx/Kq8J9mhbGjD8ZFERm+L+wX3wNaMtL/B/tb+z6vZzGND4uwogweunnU5S4nFMKo8y89pNxyzN9TWnjXFgwjdN0OkGXlDoem9ZrDBRMAdEo894AHvwUtE0ipQdmlE0938s/ga8KZQjveJBEmt5AmOEw4cJd12qCsnktqZF5SeXud/EIsWEEtI+m7z8Afm6sjfcqMYl9m04c1kUuGk/ilnTb84gFBpqnJISxb9QW1mSkvFABb9PvxkG69qn+aHJ2Mt1X1sgA0LlBq2Q3wqYLEBWPUkNDFc4xnDJPczuZZTmU2V6vK4kJobNYRIDp7JCmzaF91qwzwLANqD1IynRpCjkHX2lQcIj0cg/7AVloe6Krko+hshWCcVt+tS72GJSvEsUEnGNjtXaV7m3Hs9KVYXYfyjd1KV+2spFUZGk3mGcFGol8OpMNgCQcU/KEsL9Cj+Vbls2cwkb+FZ5cqoJtLpB+4zPxEY188wy3fJD6EYz4M0m6efi5OUE15f
 8REsoivh
 rXRrWNY2YtcaViVM5NQ4QVESA66Yt3xmA1eH5eqdg1PlyqXfckelVlFAJD5qfqW19rbD9E/uLfhamaGSNSDzE89nQ6pIALQu20fV0mZRj+sEGC2B0NHuGKy6voGzGLtcmcVH4WMRIF3xnjwvi/DcNE1GbETEq8Xohmi9TgjjD1DWDLrBdnslLKJXlfXydEGFS8hT5Ljr94fAjNO3jUJZo2NRhSdvPVyu289a1A0T1ef8/+bijENukGGvIZYs4n6XpW2rtUEZk1ZQBdOVAyATInRjZDRncVorsad3pWfLrt2LLsGlFQdBIlTALdBzj5cJ/DmgJll0EGMhSS04uiY7JrEExpZdifQkMLW/J97pd59/DCcz1Qxh/76jBZPSTF15qcz1VRBvTIXjt4Z36CLlrQHl/EuoFr1Lr/LfF/3bpC8tbah4ITDLywoMjxzTK5kdri9lX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 05:53:50PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/6/26 17:21, Mostafa Saleh wrote:
> > Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> > page_ext.
> > 
> > This config will be used by the IOMMU API to track pages mapped in
> > the IOMMU to catch drivers trying to free kernel memory that they
> > still map in their domains, causing all types of memory corruption.
> > 
> > This behaviour is disabled by default and can be enabled using
> > kernel cmdline iommu.debug_pagealloc.
> > 
> > Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> 
> I think I acked it, but maybe too late for you to spot it
> 
> for the MM bits
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks! If my mail client is not acting, it seems that was the
same version(v5) also.

Thanks,
Mostafa

> 
> -- 
> Cheers
> 
> David

