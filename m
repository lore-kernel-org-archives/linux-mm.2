Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99EEACFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 16:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3336B0006; Mon, 24 Nov 2025 11:02:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9943F6B0007; Mon, 24 Nov 2025 11:02:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882BD6B000C; Mon, 24 Nov 2025 11:02:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 705786B0006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:02:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4087989844
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:02:06 +0000 (UTC)
X-FDA: 84145967052.05.D3D5DE6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 44BFB1C0013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:02:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CkFtIVDY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of smostafa@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764000124; a=rsa-sha256;
	cv=none;
	b=8Fy8r4J31iG+aIa4MVw1/+VCdjL0e4cjSTQWWp0hUk+jtK+C0T5Hu1XJN1jDsiWmizrp/L
	/AcUqkoBBDmOG5NyAtmti5mPCyC7xpBdPQozYCVM7y0+naEX9dFmVMaV4oJNHiPfi/Ok/0
	NvgSRnjxX7Cr+i1KpT9K+VsDBSb6vSA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CkFtIVDY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of smostafa@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764000124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLdELsThxmeB5YvfJC736dRFpSpC/jFiigw/6IO1T6A=;
	b=1t6rFOy0zd8zlEr11VaXUmwkGloSgFN8LM1qR0trTdlibU4g1hgcadx1lFaoMKO+kFAcYT
	f+87lCRPN4aiixEN6b/l+EmNtU/Y1jN8DomDqdvW+T2uAtjfUVzBEYv7XycrQNLyS/pfOg
	idTrbCrYRuf1OgAHAyA0rfd2RtCShxA=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477a1c8cc47so112585e9.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764000122; x=1764604922; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bLdELsThxmeB5YvfJC736dRFpSpC/jFiigw/6IO1T6A=;
        b=CkFtIVDYDyY4jMpnaPn9FBo2alfbO2ZambpmH5l8sZy6J1lVR7Ls8KxFNiawy2BbjO
         UlBDuFnj//dRh4sG7m6hEJnv5nXEqDWpDbqFyEwat0ouayrSY5lNcafSGiH7987/ICpa
         MGoXcMgip81eJkD/hfk24qBU181y66tsNEOuHuzehIqFEP5UvymhXcUJIWX6M3PhFLWs
         mGt5zPyAP2C1H4bZXG5o7PC2J+qCgKnLIXTo2c6XABmb3tffH612gRQ3WO0QFFOX8koo
         WaApJe6IbHTfoNWXYddNa/fuM6QFZCRjWbmqW+h6guOKowJkGsp/w4hLDQ9jBo5i049X
         AZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764000122; x=1764604922;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLdELsThxmeB5YvfJC736dRFpSpC/jFiigw/6IO1T6A=;
        b=xAQ/HfrER/hgYruAjuxEvUJ1nZfhfnuGOysLckgHagWMR8UedItFNqyaSGt+7sraO1
         kiSUnFfTRX4Qq8H/1NF9zzyL7cIRfya6FTbvMNJLWZlEEvn6N5gWSWMO4E8SOj6KxBCF
         iSPcULqurde01mAvsHu3xb/IRRFKPqnVPtxa+oNo7cS8cCVr5nE+eSCzdCsPuevhahHc
         DyUuRetkJ/A2cKKk9rZbRamvfHH36NYBunp2rU/HgpjBrNqNeMRNgQCBxCo7XJheDrxU
         q8gwJgIhZb43NTrnrgodUlQTcyVUOYu4To7qC8vCHueCtBs9+WTBA3D/l5EkvmfkdU0c
         mQwg==
X-Gm-Message-State: AOJu0YwahevlQC3inFHpHSQP3UerD0B+gx4jQd+d0CWzdQUB9KDYdSBJ
	Y5Z7IHm9+bMjGrGTjwYSM3KjzEHYpRYgUSf8pblAmhwkGqAeSsMQOaO/U+U4TMeTHQ==
X-Gm-Gg: ASbGnctCejF9eJWH3EjIvO04DVP7yF2hmlC0OiY0MAnDyDUR0rGJATcd2uiNCiY+dbI
	AziRl7DK88cHh4GC3bQnVUiH48kXaOjoGXx+J0qGz+ulyopoN8KR9RP0fTu2IRD7m7fJSPyPmod
	8zeRu52HoIUgP7RYKuoXqD5clVsW7Cz4mREnErBCjk1k/qgqtmLAjMDnbaGw49CIPlEe4seLI4r
	6RNKsJseSAPKb1MjPCiy+m5TNogtRAfciYLgRdB4BnYPEQGQJrq6uAHsEyM0G282ZOVzfMnCAr3
	qh98YzxBJehMqt4weFuN95IY9kc8bdkHAyNFKHdGDHdIsGzdCxf0Hd7x8wSr80QPCyPZXEQZe6n
	1mEg/eC6IF5htqQpMbLKg43i+eCMOnANAE90cI9jYxPxOQOyWKCTzT2z51Bl65w+qil5iArds0f
	KltRpXY3PN1dc/NwzNjgP/P4X6TxH6gxpBj9hKKfaH8vijHQZbMg==
X-Google-Smtp-Source: AGHT+IF87Of2xq3NRiXHoW9YLLU17xS9MSG7Pyejbfo/XW5RRV/9hA3ItGRGycpv5nRxS4fk6hR8OA==
X-Received: by 2002:a05:600c:888b:b0:477:73f4:26b with SMTP id 5b1f17b1804b1-477c5e8f119mr2244225e9.3.1764000122272;
        Mon, 24 Nov 2025 08:02:02 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf1e86b3sm239817465e9.6.2025.11.24.08.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 08:02:01 -0800 (PST)
Date: Mon, 24 Nov 2025 16:01:58 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 3/4] drivers/iommu-debug-pagealloc: Track IOMMU pages
Message-ID: <aSSBdu-P-E75-_iY@google.com>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-4-smostafa@google.com>
 <aRW6Tf_G2ObR__vE@willie-the-truck>
 <aSRRizzS39jI3BjH@google.com>
 <aSR7U4pI_mYryFzh@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSR7U4pI_mYryFzh@willie-the-truck>
X-Rspamd-Queue-Id: 44BFB1C0013
X-Rspamd-Server: rspam07
X-Stat-Signature: h44xwbnwm6duq8w9ggnm8awbtmftx8x5
X-Rspam-User: 
X-HE-Tag: 1764000123-505138
X-HE-Meta: U2FsdGVkX19TcyvZe95RlhWT2X8KL2YS4+5adCqHLmmZJ1Y3n/3ffw2AJqLRZyTcfxYpAKQGKgY35vXO9B17OY9c7tgj8W67S78OnxcYJ+TCxGx1LKEcsNq7H+RfAjMzZCIUHf1/zuc2JiJ2aVXzs114wGg5Jz+RlncQcAms2WUVgjpKWYB1ob/Y/OhiziwIBytOE8utqH03Rh0MObb9P1L56qZ6CPcEKADavRs0UZVKjxQGhm2sYnMxVB4MNa96gtxVrH21OEmowow8D/5+qJXIq9qm22+bFyb3sH6xW9XtsEtOjfhjvFhHh/lKWObXXKX94DeCF5hjMD2WpsM9JKxP+fS7D9uPw//H5IMJo0rrMzuaiBUhjTvjAO38Hfds6ktal04X3Xa8NSqlR87adS5W+oB5sLGUQjcoWgnbvGrgo/2Fu/TIUeqqJkNUbWe12t1ytT6Fq+qM1AjTuX2uaErNld9GHrvzxJFy1KLIJ6VuAqTKZB/8l3RKT4k/BfsyIbtCxQW1rkfEKc01dIW7YlttTgQq+7+bBLliXOBGC8bSsSGkggUSU3GTF9SeoaUYPFbvs9S+bzJWl+19jq6reU2BzfhwJN+VGAoQYeB8tjM6AtyJIJUdMO7u7zo7h9QddprmnqiBFhB2L30Yob/soFl8n4OCCdkn4otFWT4T+KRda7WNiBnIhhRID23rG4bo9UDTP/IiikAfOLKOA80EwlKlyW1qttDC2dhYxhoJAZLE+KOy2YiMUFkgrphTqcx8H6XTOB20BnXZJ5uewlJdaU66ILNxycrPO0wtQV9SDbQMqpljRFpD57yoSaog3Ec/Xu2qNAAbBOkdw4y2FxDbZFbqlKua/rkMlfasqfwFJ+5nkMgng+LNKasC+fGTGOx4I0aubkDsEZszjjD5HVMyI29uJdgKKAJnrYUlh5RTDT8bCivMOwTXz4u3KH8s6rHSchKCmPhaGVGXVymZqHA
 77iG6qxK
 0+knsIxfcjJTGWwz68BhLVIjZqVuw1gX300xp8rBLJECPMgWkSElisStpphChHW/OB+cNyt6l7V0BmuHjf8BvRMs8s8PeEJIx8D7Ny78u8D50PV+DqXh5WAy8cy6zko5leL4UfRnvxFLfD7NvQBYmrIZIjRJtGmLvMeT9E7k8chhsJ9c5AJ3wyC3EdXuGdVyeea5DLql1dntAFou9NqfOo3W3vD1qNQOLgG8EUlnINBSc/v22vEbcwZ1U0xmjNAJMSnrs3/luOPubuVyMV6Qmc1xUqKL5DZ7pVCyRMLgeQqxN7PA/d3jskHlFugMk44PtxVl+OT2uNI5hsIq2VrY056QGQxB9iL/7gYBtngMlABo9U1M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 03:35:47PM +0000, Will Deacon wrote:
> On Mon, Nov 24, 2025 at 12:37:31PM +0000, Mostafa Saleh wrote:
> > On Thu, Nov 13, 2025 at 11:00:29AM +0000, Will Deacon wrote:
> > > On Thu, Nov 06, 2025 at 04:39:52PM +0000, Mostafa Saleh wrote:
> > > > Using the new calls, use an atomic refcount to track how many times
> > > > a page is mapped in any of the IOMMUs.
> > > > 
> > > > For unmap we need to use iova_to_phys() to get the physical address
> > > > of the pages.
> > > > 
> > > > We use the smallest supported page size as the granularity of tracking
> > > > per domain.
> > > > This is important as it possible to map pages and unmap them with
> > > > larger sizes (as in map_sg()) cases.
> > > > 
> > > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > > Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> > > > ---
> > > >  drivers/iommu/iommu-debug-pagealloc.c | 74 +++++++++++++++++++++++++++
> > > >  1 file changed, 74 insertions(+)
> > > > 
> > > > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> > > > index a6a2f844b09d..0e14104b971c 100644
> > > > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > > > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > > > @@ -27,16 +27,90 @@ struct page_ext_operations page_iommu_debug_ops = {
> > > >  	.need = need_iommu_debug,
> > > >  };
> > > >  
> > > > +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> > > > +{
> > > > +	struct page *page = phys_to_page(phys);
> > > > +	struct page_ext *page_ext = page_ext_get(page);
> > > > +
> > > > +	return page_ext;
> > > > +}
> > > > +
> > > > +static struct iommu_debug_metadate *get_iommu_data(struct page_ext *page_ext)
> > > > +{
> > > > +	return page_ext_data(page_ext, &page_iommu_debug_ops);
> > > > +}
> > > > +
> > > > +static void iommu_debug_inc_page(phys_addr_t phys)
> > > > +{
> > > > +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> > > > +	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
> > > > +
> > > > +	WARN_ON(atomic_inc_return(&d->ref) <= 0);
> > > 
> > > Is it worth dumping some information about the page in addition to the
> > > WARN_ON()? That way, you might be able to benefit from other debug
> > > options (e.g. PAGE_OWNER) if they are enabled.
> > 
> > These WARN_ON are for overflows, which should never happen.
> > I initially thought about using the refcount_t, but it didn’t seem
> > suitable as refcount_add() expects that the refcount is already “1”
> > indicating that an object was already created which doesn’t fit
> > in the semantics of what this is. Similar for refcount_dec().
> > 
> > In the next patch there is a WARN_ON for the refcount check
> > to capture the mis-behaving context, I will add a debug print with
> > the leaked physical address in that case as this is the important one.
> 
> I was thinking specifically about calling dump_page_owner().

I see, that makes sense.

Thanks,
Mostafa

> 
> Will

