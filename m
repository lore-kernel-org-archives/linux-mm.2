Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6586D73E87
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 00:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4B06B0089; Thu, 29 Jan 2026 19:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488F66B008A; Thu, 29 Jan 2026 19:32:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5C56B008C; Thu, 29 Jan 2026 19:32:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D20E6B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:32:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA92A1BEE1
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:32:21 +0000 (UTC)
X-FDA: 84386753682.19.7655A7E
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id B11AA140008
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:32:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=O8DUAnGr;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.66 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769733140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPUXRmfIX+IoXHHYz7SljCky5Hdp8sH/+/BEOo2u/kE=;
	b=HYftsnoaH461pxlcPRAKmt7DfOZMa7wJ9yLIBH9029bLr1hsEdRdVvGk6Hn1as3U4YUcaL
	R5F9cb1m1z0abQMIdW7jcVEDgSPRwQ8K9GXZ/mzdyjk2yfcHpMhvAE62whFMgavt7ZJBPI
	HYXqwnc92CxHqmK6ci+hdVAtklniILY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=O8DUAnGr;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.66 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769733140; a=rsa-sha256;
	cv=none;
	b=O7qkWIF/thFlD8dRkijQcyhRfRbZunRAd3qwgb3kWnD1VRRRLD2UMhi9W6wc+KGVk0encJ
	cFD2IWGfTjrKdA/HvrfUvplkPFuWaMZZKf5DgSiJjV1veF9RXadOMoZtM1lKW2kVZPF/fa
	WSwZFFk356mHqHksLqQZmDIXNifFeR8=
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-894638da330so15757646d6.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1769733139; x=1770337939; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPUXRmfIX+IoXHHYz7SljCky5Hdp8sH/+/BEOo2u/kE=;
        b=O8DUAnGrC/ranWglXMNgh0TiS1Mj0p87ATNTH9PvR9UOBNSxvA2+io0ZX56o1B8lJr
         FLZMYOkDUYThIN5jhk6PnLWxUSAr8QWwb5PYu4wPPzts/Yn8g38gj1SzdS6bkAFBTby9
         QRkgyKOWA68jP31Ag3A1KTF/GAugMNMgfSHOjLk+6SxcmcNd2oXGYGJQsGrf85WLXJc6
         PvucktQoZL9AkP6WHznyVfe7doYoGSvuxM7d2DzE1NlOx4kEcNZ568TPW+e5mgOH08b6
         7Y7aunT+lhdsYPXD8qbrkHKj3QMemyug73YfXm2vB0dE636KCtWyFBfyva0FfHAYkwbf
         pLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769733139; x=1770337939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JPUXRmfIX+IoXHHYz7SljCky5Hdp8sH/+/BEOo2u/kE=;
        b=Wafz0nF50cbMYmszFfY3cdzwSAXf262uUmVYMa5Ez2HEzg+3nHNuiVGVMKiHoeryqW
         xft4kTKcdRaqME8zPQy/lc0GkPLP6mE6/nYAr39FWjbPSlhG33c5Dyu+UM682hlaHpGA
         oT88/oGhlwkanAL6v3dP9VLLwU2/nBlq54YZgpJm114psFr2qM61ed7U2P0PbDHewsSm
         V9EzCXOY4d1PwgRHdGAu6l5dP4U+8hdq+rMQyEOStKF9MbC17km4NBnajcB7ln+0uMRm
         jIS+UFqBeH6Uh3jk4IbedPru7D+w6xgo9B032mBVpq/alvnH+zL0Y0Cd/60ZkDnAuNGT
         cu1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWGRqLBMzNXv2iFovTBs11eOaybTlpGUCJ+vTqreZG9cu/uVRqtrq0SjNJfzYK9E7t/2iuyO+JEaw==@kvack.org
X-Gm-Message-State: AOJu0Yzmr9nGqwL6tJDFyaDzezoOFihco02oIehu9KthBeHXWS7Nsa6f
	j9JLHFuSuxAzavQg1dkCjhYUqmPdDlPkz9+7W6WYIgWf1QqYbgaAJlDJBl9w2sgqG08=
X-Gm-Gg: AZuq6aL3oqUxA+35KoarkGRC1ou1Ig+fShJQc5whE2a4lg+bXy0XOMbmZUo7rz74HYM
	Z1P4/hvWTfUBUjmLGrVaD31+iqs3a+uLbN/rWSvedU7VxtIYDEOu+tz6Vz36Uif5ErfbX159Hc0
	2KDZBthAzP4HDx0ZxxILNYUvIoDY3XIHQh9z0hm2FYbTJCkAIqj87qvYR0TZiHU8J1PsNkN6LyY
	3o4giJYYz9Vpp2waZzFel1NFCtePO+FhkPSsYd8xpdb6GmKghHwBpb8QBzN7AFZTvO/0DulAf7N
	oZ/KTol5u1RcN8aTlTB03TeauIKkhBGanpUVBumTA3vjRnM7bbzfvX3Wdrn40z7pZOgaMb3IXX8
	Kx5Ad3qFpASExlkcFd2DFKBDqhFBYE19SLFK7pcuf2i85Qot56t6wBIllJCkZ1NCNJwi469RE7k
	6pEgygag+FTyWEypgLQulX
X-Received: by 2002:a05:6214:410a:b0:80b:11b7:210b with SMTP id 6a1803df08f44-894ea058f0amr21222026d6.43.1769733138680;
        Thu, 29 Jan 2026 16:32:18 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36c448esm48949356d6.14.2026.01.29.16.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 16:32:17 -0800 (PST)
Date: Thu, 29 Jan 2026 19:32:14 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>, Song Liu <songliubraving@fb.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in
 collapse_file()
Message-ID: <aXv8DjjJ3zqZEsgQ@cmpxchg.org>
References: <20260129184054.910897-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129184054.910897-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam11
X-Stat-Signature: maan8r9d7kmg4fz88wjggbwxetc3a3t5
X-Rspam-User: 
X-Rspamd-Queue-Id: B11AA140008
X-HE-Tag: 1769733139-593961
X-HE-Meta: U2FsdGVkX1/Z1aNe/fgLpfpRxO0KBOjlBslOCpXWGbhTwFXDPU6ljwpjqJfLkvVuuK4DetbnyZRVyompADfJqc9rhMBHZdYiC1BWM03sfnscYgAgUlnPeCRQLFj+zMBr32YLBg7Tsxlydy+v20//dAS8qjmcHYhEDF8lehgfOCzv5UWiV7gYtFYVm3yFlX3oiRLVJEVx2DLfCiH7joTowNIa7hz+0cm2ANOU0UYteSJ1MzuUbrfRVd8syHkyYuNnBhrKmNx4fOfvV98ypw8q/aJSEWwni9pS2b6uTGiYopiM6tSNjRAnIXucBo/iuFStKs4ofpNBImp9hL7pc3aEnX6nSc4aU2pRJPMo5ovmQDj4slEqnjvMprDFInI6CCaxlX/kQbO4TF8bNUJolymd0QO/KvzzyntmrxFlRcz8vJU99v8ODQ7LbX+v7X5musUj66YMpnuSX1AhMfldmUc5JdSQlEgQYFPO/XHgw6XeOCY8gBaf4bsdnT4pn7/apV4xjYaK78FOfVHv4uo+19pPYAz5LNx0XTUR6TC+u8Jy/gdOxpNGT+HTM05W4nwkWafD658TPjArBtPVzn5gJfo0Q/5l34Jg2l64mkkSbKkJdd7GlzSgAUvAZuPRo0wWP6uKCMjHCiZGiWkREgWuzJ0meexGdvmBJanJeQ7UC3rPIjJH4MPb71yAOEzRJ6VYwUTJoRCQaFnxDXrtCG+o11muAM8h0Q3zf/oLx8K1FsiNWELYqTBTiwvr5sKfpDh7nybsMs5SBOPv0HNascH6N07AuHQTJASUKtm/p/cWittsse3MFkYk93C8UaJE/3/aV0QknnfpkNKfNBFR5XzN5F4Fk4C9bXorXpyKM/qYNPCIZfl/VrA/h7vjuhV7IR02+b8WYCHOmNU1ABIIyl+ZpixONC2CmLYhWyNmXS/3i2Df82EeA5w+ho+rneeF+X5o4khPDlGk2u/N5JxKDTmp5Zg
 h/5BmuYf
 BfqBcjhIrukDdNaqVio63obBv6lMjqe1/AIkCAr+RdmF3AefV6V1ustJ1KcgvZgZH/xrsMXERJXygRcILz2Em3sgX9tuztX9teIwa4z3mxL7UxFYNSGmQpN83y6eQWoOesf4/IBh310C3gYo7enEA/68AX4A3vJ8SYHiRsvvNy0jLOvg2Kz3LtizdEwmaTnFAjWJ61/fLqJFEVPpvVQ6N3ZcZmOaywk2I/fwjJ5Q+CBf3mYisagLHNOKQbM5gbtc2fxKGOHAxvHuCVhQQ8MJWdWrze1Q+qXmMFsDF1BjmgWtKFIYS/42YCQZ2FAk3DOrwznJi2x8v8z0MpZpyeH9v/q9eODrwr4kzwi4Ii70XYF/4gZUDgb87BIgidJkroP+kYTXvTFKd2UkF0HNdsCxlRTK99Kjv0y3R35Pm7oM/boIKl62AQduFCKPegaelTxUdFVYczfpYiaAFAwTl8QkgmXBVvUJVCBudadzBQY4Lg/MqCbDXxxMD7AzdHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 10:40:54AM -0800, Shakeel Butt wrote:
> @@ -2200,8 +2200,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	else
>  		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
>  
> +	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);

The memcg breakage is more visible, but I think this has been broken
for NUMA stats even longer. new_folio could also come from a different
node than the subpages, after all.

>  	if (nr_none) {
> -		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
>  		/* nr_none is always 0 for non-shmem. */
>  		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);

So AFAICT NR_SHMEM needs the same treatment.

It looks like that's been broken since f3f0e1d2150b ("khugepaged: add
support of collapse for tmpfs/shmem pages").

Anon pages avoided this, because their accounting is done in rmap.c
when the pmd is mapped and the ptes zapped.

