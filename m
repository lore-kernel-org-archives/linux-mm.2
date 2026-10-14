Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEED0CC6B2E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4106B0088; Wed, 14 Oct 2026 14:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55126B008C; Wed, 14 Oct 2026 14:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943CD6B0092; Wed, 14 Oct 2026 14:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EAC76B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:04:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 040A6A0792
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:04:24 +0000 (UTC)
X-FDA: 85322006490.30.11C9CD1
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27058100007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:04:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=EQ+eGAAy;
	spf=pass (imf05.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792001063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sre2Q8d9osDFJ2pO/rFODA9M0mfR2oBhyc/Yo4XzZZQ=;
	b=sORel5SWON0LMmtw3nnP6g8JqQ6gyppTRz3jg9qq6wpJ07PUVJ4J0Dj6jBo/jevIytIZmq
	Xn2h0k0Zzu+6SWQcpNy3TxmaWHFT6/cK6Xfz6P10qr3n9c49tPjhUJnZZrIqGb31twbR6T
	W/LeiVTyOQ0YX3p7TpODSKFk256CxXs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792001063;
	b=gSQeQVnHXxl3yLAJCoseN5D6QsTZ0ZriC3aS9M8W4SMeWNNAEixczDPL6ZlOltE77Cu2MW
	zwsmix1OU+asnov/lQo7WwIGtErI+h7vlnMrCxL2qaZNTwCHmOBGTYGCFSee3PWUdeA93M
	4MC4uuD3Mlmis9iqdmZY8s3oIu/L3gk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=EQ+eGAAy;
	spf=pass (imf05.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-8266c388b67so3757467a34.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1792001062; x=1792605862; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Sre2Q8d9osDFJ2pO/rFODA9M0mfR2oBhyc/Yo4XzZZQ=;
        b=EQ+eGAAykyd08PkoOykK2cjPRGaRzk5NsGXdDb+Ay1tINQB9pDVRRMsoV/Ca0KuU0z
         1XHIXlCQ3ZO1MXvffh0vV7spBSVjTAwk8nqGpoKPlt0HPULKA5aSq6AuCM2QYEp2Xsbk
         Rs6mb6/RmZqAtaLmJ1xLI/2ZLkATN98O04lo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792001062; x=1792605862;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sre2Q8d9osDFJ2pO/rFODA9M0mfR2oBhyc/Yo4XzZZQ=;
        b=qsKQpfyiYElYqKaFJmoNPeOdjXaOdoYb6sgwqAY9pEA9OyV0daIoLFZHivhV5zCSq8
         Hqxy8wGD6Q5ZEx1TXOVKVsNwEY3X/VbQnbQxAwmBOYDA+CU6B7cRcn2RGS0/fNYe3LON
         2qcrp94OunIYOY3TM64+rUKSwDlEH4lHAkx3zXms2tBIUEuR+K1FxA3mAd5X9QZuwlLL
         RQuGdTvqOMg+n664O6682FtSuf+8f+elfJMrsuvAz2mUTdNQ0X/Wujx9TaWOiEqAeED/
         q5C3CZujyvZvda5jGltJq9yb+JDRMalFoin6oWQzGreYmdPStzIrAJKmagRrpERfZDoK
         04RQ==
X-Forwarded-Encrypted: i=1; AKwUvBzMExJ7fMB/7AcJJ+/dfxpVjsnlG45MgrwbNReuvnIPmN04JSegssGewAvvfKsKT4ziesomWNVwZA==@kvack.org
X-Gm-Message-State: AFq9FYJRXIQWBxoGgZ/zVNI5ciNzInV2m5VL3mqwaQgPu0746Ix6cNp5
	ZtYd8QzAMCosxl/i6ZVyzMBJqbFP3cjGd/s3pHtYDU9C7AAloaOCV2vygeiFHbxsFgw=
X-Gm-Gg: AYBFou2zgdlpXZISK5NGnwb1bfd1Rkitc9oRt2v7IxTw1LcI6HjJJTOkxRX60SjImBl
	DrfTGCOBbkAaYEPshWakHxaj9irRbJ7Z+uLvZdibgsIhLsotrXUFkFgDizjhtBu9tDiTz3bbLDR
	I58bwz9WaObwk50UUpfKHFxnWh6Nryc7wH0kMwQBZ45wtlwk15Ax56Lje/axqqDJit8zn9jjyKO
	finCLhy4J1p3izKxcWoaKLhicVoZRAp3g/K++O16pzX+sCrw7HCcbxHj30n1cGicjLroif1uNTw
	STudqyg7P3JwpLL0u6mHEHZCWubmHFji0UueZa6x1TxklUX+8oBEZEUyStUrBKewhp6jC5r7Sex
	+hKb841VN+PZ4N4MVccLjJG09x+AYCMwJcD7iUgJ0kWKZVmtwA/hl7KsDZwygYDDONUGX68hTO1
	GRlibeEKLT6cD3LVbE8Y1R4yW4Xvlfsa0g99T4y9iF2QME+HSjMsjgwgLmifhItv3ImP6nOC8ps
	zqih4TSt7uQFPuRGGAxTF4q7gn04bKEfzuzs3wv+n/fLyoBH77+Fg==
X-Received: by 2002:a05:6830:6f8f:b0:821:8e71:1bb5 with SMTP id 46e09a7af769-830963f4818mr16941700a34.14.1792001062029;
        Wed, 14 Oct 2026 11:04:22 -0700 (PDT)
Received: from com-75606 ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-83039076dc3sm17027951a34.14.2026.10.14.11.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:04:21 -0700 (PDT)
Date: Wed, 14 Oct 2026 11:04:17 -0700
From: Kyle Zeng <kylebot@openai.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: only allocate anon_vma in CoW mappings
Message-ID: <as_EIRMinCdl1zOx@com-75606>
References: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
 <as99gyi-NUprRK6e@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as99gyi-NUprRK6e@gremlin>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27058100007
X-Rspam-User: 
X-Stat-Signature: xwmd5g934b6akdwzd13arbuueahes47d
X-HE-Tag: 1792001063-704628
X-HE-Meta: U2FsdGVkX18BhNCd+aUFw9P7FlRKpNfH8fwTreUw212L7OQufjQaNmlkPUEJgyNe4uMOYobkF+I1jNwYuBTdGDgfUcrFCaRCsKjUg05Snqg+L0k1Lz/MjiQSYOCrXXUqcf2BXgmxs2QTid/RxW+Q8A8BGjGo9myhrnKYPPU72hdVKxw35DdP1zN97638Z+R3PRR/uMzVIrgPFqe/aRVPy5u1j5H4+xMoYqvCEzXL3vgz6B/bWCVHace2zLv19AyOpJXkyWJWnTaG5IwcNpix6VAivS3a0do9b48HC3LghzREHqm46Gs61gYAvmuL29uOswsR2hVzymJP6SQ1mK7JwucVrZEY4FhoGBDbp7S6HCGYf94hZ+p7BcxpgFNsTOwIPuIfd+YpBE5rkYgqUKQphbKVgXE5SqwMAtF23LwaIgellVfPyEb7HcrxHc3YUr983nU/WZhp7cwYAF6bOFMEF1ASM2MgrLuzz/PYLorlUlqlQu0XyoYeRO3DkWhNQB3yqbj6pqifnnOlUweyUxG22CWd5aI2NbI9pxtTdvTDp+Qh4PyKefh6GK90VJBX0hWyoJq4r/6E1wOsdcklgcG/cleKCqkYcj4XN4V23D5NP4+GzxezAGQI6mfnW8RGQq0FUSUNkXv2nZ8vUfoHRp2DYc64jtpJIRwQSZv0Pi+aNifDGb7fTYKtApzx+mBULH3T6dqpcI7qwm/6TLvlt18ymRS9qpJBiS55rM+7Hm3p/sXEOlJC144iADsZulOkpDFAG0/kREAWXMd/c3c4XEpqW/m4lpppVey9wFyvkONFDrQyjct/b+xhMZbTy8fAaHM13sjDbSctyJ0XYpHTjCofGUxp09kFB/qV0v8MqqacWTJ81QPB+heJouipxySuwkfpSHgZEOhHERa0zwqYD483yxIU3x3bRrw+DUgjVp6ngm0eI53FeGeKg72dI7mc3Iuqka5c/Tk//yjtYjLMlw5
 POcGCG2k
 PX3tA8aym86HS7CbK67bEWTG3Go2eAyTCmVizlGmkG/n88uEccqnYo1PqpGEKChagbP9thN61FlD+W0q3qWiMWbcP5b7wLX6iGwAlxufH03hanBiU78yWG09H0wZ1K9K2CHDsOVRKcxR682sumkWO3kM/3BxHfTqWtZIiYqnkDUmdugFelLYgp0ai2ciDPvBRcGmhBnRO+kqllOIVIKiBfY0i2EHrytABEDuI2TW0TwKlzPe2QXXPsYUj/VA+1mEXu4sZ118jK801uD4AfqMOuSMauJ40px6fl1zVljohJ9x7pspG7acZgs7E1KY3m/p2S1QBTj/rZQOX1MyeA2D3hlOsqd1v0ttkXr1k5srgkdMuJqQPYW+FFnK0nJIzMTaJUSVTpEktKBgI8uN3wwOMt5qLcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 03:51:22PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Oct 14, 2026 at 01:53:11PM +0200, David Hildenbrand (Arm) wrote:
> > As uffd_lock_vma() is part of the same lookup machinery and
> > also contains a misleading VM_SHARED check, change that one as well
> > directly for consistency.
> 
> OK, I think that one isn't _strictly necessary_, but while we're there,
> worth doing too, clearly.
> 
> We should also go through and convert the remaining !VM_SHARED checks ->
> vma_is_cow_mapping() too if possible, but that's a follow up, obviously!
> 
> >
> > A follow-up cleanup will stop taking the hugetlb_vma_lock_read(src_vma)
> > lock in copy_hugetlb_page_range() entirely. Further, the usage of
> 
> Hmm really? Is it possible to do that without the hugetlb lock?
> 
> It'd be good in general if we could get rid of that lock as a whole :) but maybe
> dreaming.
> 
> > VM_SHARED in userfaultfd code should be cleaned up later to focus on
> > CoW vs. non-CoW mappings.
> 
> I think also anywhere else in the kernel where this is done. An audit on that in
> general would be useful!
> 
> >
> > Reported-by: Kyle Zeng <kylebot@openai.com>
> > Fixes: 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd operations")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> This LGTM, thanks for handling this!
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> --
> Cheers, Lorenzo

I ran the patch through my system and did not find any issues with this
patch. Thanks for addressing this!

Reviewed-by: Kyle Zeng <kylebot@openai.com>

