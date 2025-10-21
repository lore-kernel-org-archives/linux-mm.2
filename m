Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F72CCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA708E001D; Tue, 21 Oct 2025 05:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A858E0002; Tue, 21 Oct 2025 05:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8430B8E001D; Tue, 21 Oct 2025 05:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5A58E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:30:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27FE686655
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:30:58 +0000 (UTC)
X-FDA: 84021602196.17.96DEEA3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4536F40010
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:30:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KSXYc5C4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761039055; a=rsa-sha256;
	cv=none;
	b=hO2sVS3QBNvJgWo2CkBTqCQV7q9hRKtYzcHEgf9zRsoh6ZDxj+CktfNnBpKHXQRxmycGBr
	TOXy3WXaEFDbmEFmoENKu4AeUp9a5Ghh7vCu9gZyeTvMBqCfTHhdHIDmeMOUZBP0PoizUQ
	kKr01tSNNa8XnWvIX60Nv6u8mLuGEqs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KSXYc5C4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761039055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=miVaLSQJ+GrWVKZVzwOoIEwF8/pGqrxPxyZhLDn1EvM=;
	b=It9eUeIjE0CgT4hLmsMI+hww6k69xcTCLdKvKUbiZN8DFVoNAok9crnvpZkGm6KHEZEnql
	bcmWi0Te9ZBke20M2gToIw9YqSKLb0a+z+m9Xh1ICT6slab96+onV1JmXb535MosO4ZFaY
	Yq0k8LcvjRwAc20hx5R1wZE0ycGFu6k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761039053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=miVaLSQJ+GrWVKZVzwOoIEwF8/pGqrxPxyZhLDn1EvM=;
	b=KSXYc5C4kH8yumcxBTZMVkbUWy6nq6wySj7LkhPPJVVBjVrroOI7mYv0ZzaVk1H+Nnie7D
	95rq2pHUYf+7m7Pva05NyO4/blhcMThIZYt1PAmyuN6x1SACBrJvPi40Sg99ZWy8UdTIf9
	zQoJXaGLqPyARqwB8qqFCx4Rt6siTDM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-PD-aaZALNVeiCvWNzZFqfw-1; Tue, 21 Oct 2025 05:30:52 -0400
X-MC-Unique: PD-aaZALNVeiCvWNzZFqfw-1
X-Mimecast-MFC-AGG-ID: PD-aaZALNVeiCvWNzZFqfw_1761039051
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4710c04a403so57033435e9.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:30:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761039051; x=1761643851;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=miVaLSQJ+GrWVKZVzwOoIEwF8/pGqrxPxyZhLDn1EvM=;
        b=h9w/R7pE8QQFwBFJiQvCt8f3uOPNa6dOpX3WCpoHJlleM+zAmduzNOnZ2n9oGpn9yl
         eZBISgBxwCewjdtNpPNJ68pEOHonXjkVqEY/J7tQmTFe6Hmw1mMzZNKU5NJOoyY95/wY
         /Cp5oi08dmeQAysupAnFMcyxuWFYhU9Y1IqWBVdYUXPC56EYypN5p6aCxnZwzPD1/y6R
         BTbJZLRQvxiPHvlH9oLSiaRJCG3PPI1STaXtv/uImwhlO0wTj6pxTMGlQJp6aqRswdc+
         SIdHsjDCQvAPppvn/UjTojVc5hDvp6HlkmdLzYR2fI9RU3/RgtzrRDfSFluzcmzbsB8e
         9e4g==
X-Forwarded-Encrypted: i=1; AJvYcCU4dLOoMKgcJLjvVXWSfL022yAoTo03cI2JdJfWR06hCnQwaoIHCws0RgSnFa8EmMd/Eh68f6vHAA==@kvack.org
X-Gm-Message-State: AOJu0Yz1gmQI1as9OBKGMGswiUEsidOD/2oCGxNIXkbvAbI5SnApZ7PP
	APcXSEaBOzsLof0O9vPewDIUU4g0qEcfXEfmEzTHeGmDhHxXWZkGNsjI18wbD7/CA8vadMyanfd
	tnECt/G7QcKvBjEW0IH0qpLhyboPQa1FDip//T1ucMJcnFLIgoh1G
X-Gm-Gg: ASbGnctMMSXnKEq/pBdZy1X/vtbwK8G70I363S4lOVzd2mPS4GKWsGeyLruT/ncf7+M
	9tsRlq8H63xV3eGhuyxPysdihnAYKbHv/I7/fcZ3AIuzp4HDnby6p0fAoys6KvHPg2KZHV9B6Xn
	KryJTkrkvq8KTLdNJ4mBfnVsPb8ZQnKWMLemCguvxqLJyGM/MJSWx9d6Oo5Mz0d9j+8OQNJTaYC
	B8pZ7lxZd/vkKmc1Wc1N4YfT23tM45X0MDB5Aq9wf0QRdfUKJY/aAtFCb6h3OxJUpKtZsPXiJuL
	09A/luqFZ7djY/4ELHHOHqhVaFCHKkoaUGD6WtdgJedoVZREmw6lQMzRXwP8v396FptrzFSgLzT
	ZpUlarKE3+MQpGLZAsQcQOwtvhUrWc49T6jsn7WJeiWOFJ1eedtDdDyOK5VBUmDK7k4iRfHBz2T
	Zb6y5Bg0t0oVX9TEMoZ5zVdMV9q0M=
X-Received: by 2002:a05:600c:470d:b0:471:7c8:ddf7 with SMTP id 5b1f17b1804b1-471178a7447mr104678035e9.14.1761039050879;
        Tue, 21 Oct 2025 02:30:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2QRfO9MmiqYi1btl3MqpiES6HqQddhDz+ykAs9uV4ny3W+IOmzAxSH4+KOxeQR5hSjWOplg==
X-Received: by 2002:a05:600c:470d:b0:471:7c8:ddf7 with SMTP id 5b1f17b1804b1-471178a7447mr104677905e9.14.1761039050466;
        Tue, 21 Oct 2025 02:30:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496cf4cf7sm12324015e9.8.2025.10.21.02.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 02:30:50 -0700 (PDT)
Message-ID: <10402943-b613-4bd6-ab78-f34efa74a95c@redhat.com>
Date: Tue, 21 Oct 2025 11:30:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
References: <20251020210816.1089910-1-gourry@gourry.net>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251020210816.1089910-1-gourry@gourry.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZvKpfzBxgpYZBApmc3zTTi9OzUWSvGFE6_K2bXu8EmE_1761039051
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4536F40010
X-Stat-Signature: 4mw9u3xfr89hb6bfdw1c66pitu5dikt3
X-HE-Tag: 1761039054-928577
X-HE-Meta: U2FsdGVkX1+pIpjDdYKQI7+KxieGyySAAORBxbflm2hr1HsHZ7mRfpQPQmmW9gxjXl/Kjo7fgV+ol8xgZhd758TTxSjkv6xc8G0Da067LflnEsoLZadKkDgKmTu9ZRjnbjZtuBJkrgkdHNgp/fkhBClJ+ydm8i6BcyW8Xo6TSVySy32aPCuUVGhxjsLO/jDaBnkxsl/X41bozDN910I7DnMabfYbbY9pbURQKlCuBtS8S6Bs7DLDNb72iiFr7ZY8O5XsZATGzbNCuQFz+2GN7O6SIzSgcjANCB+hBQRwvEpAly6ujWd9MBLMvAGsVKCRgDpgH6gV0T61WRBTS12g5smQZlARR6mg0NQM2BotqQEU+1CEdS6d5+L1y/QxtWGrK7kLaWeozV8+/gi1PHFgizzce+vV/jPlLqYH7sDWKjRo3udabofnexXMcgfbsrxzOS7n2lL2MapwG2QfpcqgZxP+X6GesdNkuTXxb86A2d9qsaNX4TRG+RE4AmVcUZ+rztHVbkOeBFblT1z745rSwPK5l4BERcGhiBe+gVRqzWqkzssUp6qdgXicHMSTn2o1a08XOxHT6Q5gxy67R3IGttjhDq/Safw+z1/IkZux9SZGUbOejhJAY3UDtgfTZ/8NSf+ACCz0BH+lg89k2xxIVADE7LKpE6YUXK3zrQ2SUvn6X4LXh7CD9g1IuQsKkUeUT/IXt0EeI6/ryVJctU8B9+jmzP1MZu/BFBSaWE3JUxSp2q+zwWyTv+uCMpFcfKDX2HFUliuTRdMtyQDQyoP23ChBlqN+UMuhK4YngqCMQqnjYf7b7O3ZV8mavtpgn7TP/Nn2J/VIAz2OU5VTfxY0WHaMdmKdPvSZUBRXjxr2ljPTodkgCWYQ+76Tv7F3zP1jdTgptgjjH9XYjhwIuyHrUPdbhDdw3BDg2NI0z4fHxY5+2V8BCunoSF83PWOTexp3oJG8RABPeQdyA7x68SA
 4n5DYExj
 S9VMFhbSyTvuwgvA4HtWnqMEuuulKG8/Y2rozBb6zcMpLKPGUC+Et0rZWf9DWpxMeIyo6bkLXXqL76EShCEVgzYffDd6KVbjJTb6MgZgNfc1a/nKxBIUnp9aK+u/EFHO1PYUNpoDJV76J4916pNRR/JvVnHHZkJxbhzteoqfRTTrEN9ejSO+NEF6DCDzl5Z3/ZpA8OR+3iv9+R3qzLKNVfY5AB81Ra7O76g26tqQlj/mKbO9OMhmHakq60+eZMZ4KI60VebvX5RYznTA4iq7TOWOYTx5ABLnHMXJfPy5B9nNZCKjpBnXDu4hNAF29P9I7PnczqiqYtG+pz+dYTp948Y/G6PpJRU9cLoYDnZUNTKWTPI7hgaXA8PROF5dZuEdFbTrb3saMrYaT4EnLC/ZsJ/IsLbxE5VGeuTEbi9QIwcrhZQxxm+CrDgEYsuZ6lPjnElcB2sjwfLlALzEKoOezXAtoDHgn9/ycv50o3ip+lt4HBKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 23:08, Gregory Price wrote:
> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  Instead, if hugepage migration is enabled,
> consider regions with hugepages smaller than the requested allocation.
> 
> Compaction `isolate_migrate_pages_block()` already expects requests

Please, let's not talk about "compaction" here, it's just confusing to 
talk about compaction for something that is not compaction but uses some 
primitives (because not properly separated yet)

Just say "isolate_migrate_pages_block() already expects ..."

> with hugepages to originate from alloc_contig, and hugetlb code also
> does a migratable check when isolating in `folio_isolate_hugetlb()`.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   mm/page_alloc.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 600d9e981c23..da2e65bf63e3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7048,8 +7048,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>   		if (PageReserved(page))
>   			return false;
>   
> -		if (PageHuge(page))
> -			return false;
> +		if (PageHuge(page)) {
> +			unsigned int order;
> +
> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> +				return false;
> +
> +			/* Don't consider moving same size/larger pages */
> +			page = compound_head(page);
> +			order = compound_order(page);
> +			if ((order >= MAX_PAGE_ORDER) ||
> +			    (nr_pages < (1 << order)))
> +				return false;

This is roughly what we do in pageblock_skip_persistent(), just with a 
hardcoded pageblock size.

I'm not sure about the MAX_PAGE_ORDER check, though. If an arch supports 
two hugetlb sizes that exceed MAX_PAGE_ORDER, it would not work as expected.

Doesn't arm64 support that with cont-PMD vs. PUD hugetlb folios? 
MAX_FOLIO_ORDER would be better.

-- 
Cheers

David / dhildenb


