Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6F4CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B62FD8E0003; Fri,  5 Sep 2025 11:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AC58E0001; Fri,  5 Sep 2025 11:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50AD8E0003; Fri,  5 Sep 2025 11:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94B198E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:11:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37DF31DC51D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:11:56 +0000 (UTC)
X-FDA: 83855536632.29.A7BA87D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF3AE4000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:11:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=afGSEc2l;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757085114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejmCL2yZcTEHH96tsoUqx+++Lo7P6eAG10DO6o7H754=;
	b=FkWlwQX8jIJ7PArESpOISTtUOw0wOBZzgNT9MFBnbb8Hez8OpGbaX8IkxvwVrtd86WHl2M
	vRsUWviwjkdbb0VtDB/YDnIHOx2HCLpa+VZvhUO89UVtsJp7ODmT3o8FKcdhL1mkuTiH6P
	I6Y4opRuZr9zR68WEdAMGHsYaI1FTCo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=afGSEc2l;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757085114; a=rsa-sha256;
	cv=none;
	b=5IKldM+zHCVA8MgLNpujFplIcujGF/YnCOWLVDAgueF7UIg5nHRsgF8nowTGX9x/EFQ/s3
	IzAcvcDprDYfbeDhllM2H5dEmvSm4046LthvEVIlK2QRG5VTlLNOzhXrrmFTy1grmtt3Fe
	fwBCNzraPuF8FffBKOnI+4d0KK0CljE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757085113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ejmCL2yZcTEHH96tsoUqx+++Lo7P6eAG10DO6o7H754=;
	b=afGSEc2lqjRDJL6Ofetxj1q0PYyBxvLvQw/rLlRbZt2v6rsaBltYhiGLsItXCX9jNwT5xt
	p81PD97lE/cI6buRq0dz68Uurcpwl2QfooxpiBknsBAoAsxGzuZKrNJiW0Krm4PAn/NHye
	9+xbj/IPcSi6TxY55Q+NfiMGC7/LfnU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-0IPiIwA8PEm7ycbXAS1G5g-1; Fri, 05 Sep 2025 11:11:52 -0400
X-MC-Unique: 0IPiIwA8PEm7ycbXAS1G5g-1
X-Mimecast-MFC-AGG-ID: 0IPiIwA8PEm7ycbXAS1G5g_1757085111
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3e4a8e6df10so296468f8f.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757085111; x=1757689911;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejmCL2yZcTEHH96tsoUqx+++Lo7P6eAG10DO6o7H754=;
        b=jxnC66JXDKdN9iwmGWFOn4KiPp61X6vbvdKfBJPUG/NepfCxR+2gA8qV7Rat2t8N/+
         itCPBy32JXoqnmBz1ReJlPnmG8hypKmoS4sY5tjN08/IYs0rxoarn3PZqr5t37jIdc0a
         VbGpK+vZcCvhVZbBJBalhsqaUDI+JcVofrex7Rpv0C1QjHzrzbb3wQFZ1y4ju7fKfBk1
         7lHns15F9XwatAOA7ftl47qeJy0RCSmxIBuE9VYaTedXj2noF/lzzdZ/Qs09e1bK9bW0
         C/DklfppnVQEcMHGFnkQTXUxsSKGd6pPnaESMm8kIp8pYJy13lC+NhrBzE0oFYoN5gpu
         f2Dg==
X-Gm-Message-State: AOJu0YwrrienQYVhtrzNIK9TGe8rB/cB3e7CQqEQcFQ2/EFnptWAcpTu
	4FQEMQSF9SjPTFyO6rADeWOl7j3ho/iVudrUirfNxBY1f3SVs6iWEtFc1rObuu6oYuBa5WWmp1U
	6hG+baNBEk5DIMLjWzlFuv9K3ZCGvt2edgS7ICSUeaDZ7dv3cjSnM
X-Gm-Gg: ASbGncumA4xa5nXjoECZqqpO0DwFc14mGAiMQxQR708sevd2cmB+zZyK1x/oXKuO3zv
	va1TNc+HzP0eosXI2HFadxe3ouT3sW6WxpXozcM3wgGMKgVOcskERpJeKNEKW6+yR6mkmxXYtr8
	azJzzBnG8MIkQ2prEuu0LGpKURsysbbjDjIkjGMR0zK0a5Utz1yBB1dRIDsZQX+injUWDwEv/yf
	aDVWH6hEQUQZpADc6hqDgzYBTtPgf3+MxdnrC37TXgmSe6SaLwDI4wV3MXSbRj99XICwt0L+iWb
	sdDJjGz3V+XzmonzCKcwwh1H1wl/u+BFY+S6yiAs3fQjACkzFrNe3Z8nnObg0Y5JPpawOFFQ8G6
	h7dLM9XdHzFkrF6CCH+uEPMjBx4xfnTSrHBlEFG5QVrdpxbVxQa5cmL6a
X-Received: by 2002:a5d:5d0a:0:b0:3d7:38a7:35de with SMTP id ffacd0b85a97d-3d738a739b2mr11352676f8f.8.1757085110724;
        Fri, 05 Sep 2025 08:11:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXaISg+ckj8PwoQCPDjMhrf572oqtBNgCQOCCZlR9jfeBO9sLv7C/4kvo8ngavi+/aQ5ANGA==
X-Received: by 2002:a5d:5d0a:0:b0:3d7:38a7:35de with SMTP id ffacd0b85a97d-3d738a739b2mr11352641f8f.8.1757085110257;
        Fri, 05 Sep 2025 08:11:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d1319sm369430255e9.5.2025.09.05.08.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:11:49 -0700 (PDT)
Message-ID: <d93d1f3c-7a83-41b6-8166-be545f6270f5@redhat.com>
Date: Fri, 5 Sep 2025 17:11:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usamaarif642@gmail.com>
References: <20250905141137.3529867-1-david@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905141137.3529867-1-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o8wengmGIrAziKZg_1Lr4fJzLmAiPVL_UeiENPxigc0_1757085111
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF3AE4000B
X-Stat-Signature: qjyh5b49yqhrykqn4hg18mndxwa6tmwa
X-Rspam-User: 
X-HE-Tag: 1757085113-804620
X-HE-Meta: U2FsdGVkX18o5dvysLgqKRWAeBJZMZPkGrENGY+XS/b9jv6ngodMSfwj6jeHo4G2K4WZlbd9+KuFryr5vuwmI1aXkzbT9WdBCcCN0gPmupSJ9Tcl7ym8NYr4DIxfpgOvmq6rjl9LWlaiExFzuZzUbwKhqcrRFkRpzOcg+MOnr3ScijptxmF1frl4qQOnmCRyqwdg7CnB2i12TscwiXGSQ34ejdbDqdUoDbr1Ze3e7B7xrJj5/4pZo/IDGLfoQdDzYLwprME+YROErkdoOvPr2BY53wCYVV6jblBN6ifUJqOBb0kWryzf88MtKwn5u63Fr5OZxydJj+NA1Z41rGwVzrKeIAoX7K79bG5S/SSTKa4VpIeY6x1JLgOxr0K47VqcAwKHjhT8NvQ9R1SEf45LAxKG3XHe8H1tdw6BJrc+RHrE5IKUBYOLX8CxWaMVF5CaZCwJVk9NHQs0n7i4FevUUqXQLLWl9VBLv7nPKHqaXQEN3AwUt5yKOwlnG6SIoTjc7L3XLUi78j89CfCtxjHm/TjLI7dyw+WoPil4y5tk+cvA7bA/eVW0sAXdJp4DpxH99Frb/pV3KBHDvYjdYVEn2cioV8PWJjzGeNbgfBsfJrlxVYCHiPt/XzNAuS83ktpDllZGbuYmtNkt+4LAveZXH/Nicg6IzKsg7ckvCd71WSRUFsAQLZtzKEsUEBzbUCghWXHCmG0cZtBFU055cStQc5NQ5teDBIGahKkhIGMB10voqjyMi1RCBueqLjkst/Dw4MAVDv/pms/a6TNBv0i1VUjwDxkqBYoAlVjUX1MLjp9lZmyVOW555q1zZL0qeUMf4YdkVDiYXhQ1nQBYl8/pOSlIqHyjdxcsVrj4/IMKf7X4qjWs6zH0UDG21V4gGxJxsPccabpnFvqOBeAWnRoqGIVkeW6NNw9lfFuQfLol1liaSrjQDpRmeU/cn3qAFYexFu5I8j/19DZ3w3pT10a
 hej8OZJ1
 jPq7R7gw2Yqkb4D+B0yxocTOBDD0cCenkx0AZx0Ms8ZhigIEUlxFrq3r2pKpUrnVuDzFR7xQvRyXr4N0DKQ0LwUJybOvr/XSFhTQ9osjwSNNWonY8Wt0gE+LFpkve2FZx7XCxB7frar4ocWsS7QYXhisXEGIK0MS2TEhMo1LdljU0CvHOHhZpWQw29TGshGg5ZbF5FlBY46i6yJT6kTZM+weG32zobn4X+6eOMNzE5CUwI6gQqlYpjGRvzHrIzZsIJvCD2KKWUITmBrx9aUZ6guo8N7H2Vclj7IInIw8aDH7xoDtKWntKsML0ze/JOCN3nZ2e27QLYZHZII47nOdW6lMI7idzAEwmvUQ4cEyvZdcpsiWiCDPBNCOzHylmOoRbpWQBgcD2Jsgkg8prsIUneNYPahyEZkL5wXwbkfpITWZO6U5bHa0bp8/RQaSJlHqOFfFZHn5HHEGO+TvMr1YkPGJjw+DjkNKNUbGx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 16:11, David Hildenbrand wrote:
> We added an early exit in thp_underused(), probably to avoid scanning
> pages when there is no chance for success.
> 
> However, assume we have max_ptes_none = 511 (default).
> 
> Nothing should stop us from freeing all pages part of a THP that
> is completely zero (512) and khugepaged will for sure not try to
> instantiate a THP in that case (512 shared zeropages).
> 
> This can just trivially happen if someone writes a single 0 byte into a
> PMD area, or of course, when data ends up being zero later.
> 
> So let's remove that early exit.
> 
> Do we want to CC stable? Hm, not sure. Probably not urgent.
> 
> Note that, as default, the THP shrinker is active
> (/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
> THPs are added to the deferred split lists. However, with the
> max_ptes_none default we would never scan them. We would not do that. If
> that's not desirable, we should just disable the shrinker as default,
> also not adding all THPs to the deferred split lists.
> 
> Easy to reproduce:
> 

Just a note that I will send a v2 with an updated patch description 
after the discussions here settled.

-- 
Cheers

David / dhildenb


