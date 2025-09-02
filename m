Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857ECCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40F28E0010; Tue,  2 Sep 2025 06:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19398E0001; Tue,  2 Sep 2025 06:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A078A8E0010; Tue,  2 Sep 2025 06:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1398E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:18:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38A6113AFA9
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:18:38 +0000 (UTC)
X-FDA: 83843911116.15.2D697D7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB1F6160016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:18:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EKjjbQFd;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756808315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfPQDWh+blhS1iVGJAFgii1Xqa8zns+gAsDev0OCaLA=;
	b=MNuTPOGs8w6WvDYxTo1Jf+1WEaU3cszqqNxziAytUX9gdev1XQyOE3ep1SKlBPDV1BLUyn
	GaVP4EzBPvuyPaM40OvkTN/UkZPhImIdRnFb9tR1hAjo4hzzr0lEprKS6V0GayOCdK0Wmn
	kiBvtXdXfMFqVvfbSfVMTD/2NRPmA00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756808316; a=rsa-sha256;
	cv=none;
	b=1dWiHy6Tpk+yDz3qL40TGtXEF4SruIZ42bsZoAqzvMLl9jP/i6dICI1gwffNNFWy8IRlAZ
	MivoDz891Zl5wjWoM86erVrMk2ptDejz4ooUMGyvTeUAcvyqZNk7Iph82QM/BNQ07G8nOB
	v6dySPOvmAeS713zG4dAh1SZk5vmal4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EKjjbQFd;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756808315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XfPQDWh+blhS1iVGJAFgii1Xqa8zns+gAsDev0OCaLA=;
	b=EKjjbQFdl+LlUI5R4+y8Z2uOysmIRZs+YuzTE9viejsVmRQ2zSrBTCANG5xfDT3EJKc/fx
	7vwtcCqJy6irxewV9ehc8K+30AcHIR4lpHw4CavEMK90sE9EoUw7WQZcsZYufFZcJ9bB0u
	WAA0aR9zwkHZw8xKw3bRiG0VQ+NGTTA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-69lXJegFN2eYQKU6i9lpQQ-1; Tue, 02 Sep 2025 06:18:32 -0400
X-MC-Unique: 69lXJegFN2eYQKU6i9lpQQ-1
X-Mimecast-MFC-AGG-ID: 69lXJegFN2eYQKU6i9lpQQ_1756808311
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso3839095e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 03:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756808311; x=1757413111;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XfPQDWh+blhS1iVGJAFgii1Xqa8zns+gAsDev0OCaLA=;
        b=swT94/VWzVUeLFf/sajc2mCeeMCd+kWfnEmyvv0rDCYNHhN1kKbntzODYIpRyqf2vJ
         2T0Hjg4/MnawygqfLFb9889eyvAnf9gqfz4PwgLI6SL6f0TNuTZssHCiP80FKmvZgL2m
         /t66ss8+IcdRQjDQfEPuwm3WGNfOJW20vLuGz/XQEtrJNyTfzUfrosdwlb64QMedzO0T
         H2VrYuk3s1e7Bwb/njLxetMimijTAA/hKVhh7PYfj5woqf2xEtGmenImEblOB6hHYWBJ
         xIPThDfGOSgbaS0Flli2HPkC5AJBAiRglkjFGmvQ4hZQ9emz5XusCrUXzNAJ3DVlNUGK
         8ioQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzctTbX+81SpAawdRRMLj7e6f733EkWABLgJVVV/u0D3rgV9hftSRzP+BBdcD18O0ezaXDHEOWgg==@kvack.org
X-Gm-Message-State: AOJu0YxPliRTtjjkmNs7eJ7OidA2Q1ahuz6dpUlMYaGOmGpoG98XBlV4
	uFpcU14mQujgmIJpe6He4WILARQQbrmedP8wm1RWY3H4UJrS6uYWMWvvNHZpVtpRgX7UWnfV3ML
	G/ELT6oW1+36uQorUorztjUUZhsvDnecYIdjF3k5ya9uWLTgm7mpB
X-Gm-Gg: ASbGnctMonPSEPtvHFswmGdsXNxtUKpy6tQn5ywoi/ZCNLfYzuge1fi0/ymKSWulEAh
	zs+SH6stiKL3bszMJvH3kmBZnyaEdZscIPSmtOhG2Ce85PozwrePuQxny4hkazU48VieasG1T85
	X3L/I+XiqqT8ZG8gLtQG1Oj+5mPXsN6pBGtTd7xLshs+oAvN/Qk341l59QwSgjE8jvv+dowzu9I
	0Vfk7Jk23I0ZtnABJFSNxfIDHrgvGxyED4yHixQhsH4CHHhEqJShAGI7MimlRQaV9yPWtXGzWhN
	fCJfVDe3fdMv7j6xB4Vsxp/EwvEDIXPoFD9gnCeuhObd1TsbJosQov3MbwKFdKgAEW5q7172c6b
	IDPc10NfThpC0edg/pZCMrMyEpMvBLMtlnC+Z0PSUcddeBzoxlX56HUOOeP2IAzW4R7Q=
X-Received: by 2002:a05:600c:4754:b0:458:b8b0:6338 with SMTP id 5b1f17b1804b1-45b8554e53amr108058125e9.6.1756808310854;
        Tue, 02 Sep 2025 03:18:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJ+ztZI1y4AVzKBKNuPojd6cp+oaGeLPMegv91kQPUznpJCNgOTUu1ktEdtczx4Xk1VYZ6YQ==
X-Received: by 2002:a05:600c:4754:b0:458:b8b0:6338 with SMTP id 5b1f17b1804b1-45b8554e53amr108057835e9.6.1756808310345;
        Tue, 02 Sep 2025 03:18:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66bbcf19sm164087935e9.4.2025.09.02.03.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 03:18:28 -0700 (PDT)
Message-ID: <911dc3b4-c511-4ef2-a159-091780987965@redhat.com>
Date: Tue, 2 Sep 2025 12:18:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-3-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822192023.13477-3-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C2FHLsFs7p4brvOqFx4ZVN9N332PuIRtkQweEmKlonk_1756808311
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB1F6160016
X-Stat-Signature: zrdg9wczkuqkwi5a5hd4jzn936dga1k4
X-HE-Tag: 1756808315-266699
X-HE-Meta: U2FsdGVkX19XULCTMmKNMLsL/ZI121lbPGABnDkjCtmYGymQYj7brlI+cCDXJSG90FVa7bfNDk5E1OfWYRw6RAoeTqVTL9qf2z9Pyfekw4+dy6snITpw57/5D5VA+30bNOjopevQDkWq2DQTofxpeg4lJBz/rjDbuqQX119w96aJBPR6iIBoAEfaw0opE/KYxGxo/9/9wbQwvinbHlLUULRa5A71wg/qPbPX/nswQq5rilUCzsBA6nzHiKstBQxgki7jN0SiZuc9aFR/9gb6zqh64pTzofhJQCBnZg8lNAXezDB3wfHOS+wtsllG4HY2zaUiD2kxaqejLPGA3pR9j2gciu/Pfy/aKNVYGIEJr89YnPhO084E6UU7rmf8PcbK4uKe6Z37K1hlGb5de/0LAhh24J6H9x9s6NG8Iyt8kFvFe1GRX+gzT3oZeyHl5eCep2tv6xpyns+ZfEdwHANcfyH8W4el1vX1nFAmUsrujmaUrbq5orsfv//ZvjUwSGtLL2qNCrxaywDEpwdxnjWvUKevQe8VBo7dvIpcnfU4piv+RBAe8p0abt9sCic6rUlWeJw41wdwwiKU/WfdpQFtlONw+QpbD3zTI2rbO8cK38gwCG7HA2bTZ19dTTasgzj4BFltxjcJ6JuThyuYq1YAuA4MAdui6iyBxkRtj4UPqT1CIkS59osoAcZejMWetxAXdLmTC8IOPRJr7F2DuAYHoWamiQt6ckQwYQi+WHK+nzPdGmjs2wMD4GGJ9xQ3zzV0Gvy4vIRYadxuX1PWQ8zGsW8x52LT4fezYyKndOklm9W+/uE1nUgjYZ4xsV22xrH12gvHB+0zJTbfRX+ibfoSyYZulWydgo3TYWxxB56Fjo3f8+egbO886IdlhCGi7kD5MUnKf47y0x2SbVKkBRgdxgn0J+rtlEizo32bf15yt8/T39+jiHrhWeg3FEJKE1am2Ha+yezLIHACMyAnVvf
 a88xkKcy
 4xb1VCnk5z/4aRMeboB16Y5YUykpky+MMpi0yDL7179x8qZejxcOFBWXNgo6F0L17QPHlccuc07fBzlVJozQcjxf0rNXtGVd4kfOCxcDBBMpKh3woJl/Azp6JRuGm5Z+RfowpxjBgaeKrnq/yqNeFS4JdyeeKy53q1dcCNyEhLbjzYBeRUE9WnzX1k/kIBrzt3V0nIdtXtIsrzsxrPREa9R+0Nbl0BZbYpMS/DYzj4ilKRdvttlYw+pG+El3gslIg+EOICL+5PLpy893iYD4QEHq+ut5aIUvyNAIIezDL4N7XMiZm4bIUmVlDABQu4OJSy1ZBdtW7lm6QvjdlJGbCbWi4UueVwSoEpYsO9eZi2q6DJPEGAfoXpoC7HTHYiL1VimMt35gl7iPD4MzTVXWv8ZDlaa5D4/SstnBKRfdYwDjCoV9Th6TJv5k+KdREd/7qopwJL+f/qfoJkCQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 21:20, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Swap cache lookup is lockless, it only increases the reference count
> of the returned folio. That's not enough to ensure a folio is stable in
> the swap cache, so the folio could be removed from the swap cache at any
> time. The caller always has to lock and check the folio before use.
> 
> Document this as a comment, and introduce a helper for swap cache folio
> verification with proper sanity checks.
> 
> Also, sanitize all current users to use this convention, and use the new
> helper when possible for easier debugging. Some existing callers won't
> cause any major problem right now, only trivial issues like incorrect
> readahead statistic (swapin) or wasted loop (swapoff). It's better to
> always follow this convention to make things robust.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

[...]

> +/**
> + * folio_contains_swap - Does this folio contain this swap entry?
> + * @folio: The folio.
> + * @entry: The swap entry to check against.
> + *
> + * Swap version of folio_contains()
> + *
> + * Context: The caller should have the folio locked to ensure
> + * nothing will move it out of the swap cache.
> + * Return: true or false.
> + */

I appreciate the kerneldoc.

Intuitively, this should be called "..._swap_entry".

But I wonder if "contains" is really the right term to use here. It's 
more like that a swap entry "belongs to" (was assigned to) a folio, right?

Sure, we store the information in the folio, but the "contains" is a bit 
weird.

folio_matches_swp_entry() maybe?


> +static inline bool folio_contains_swap(struct folio *folio, swp_entry_t entry)
> +{

const struct folio *


> +	pgoff_t offset = swp_offset(entry);
> +
> +	VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +	if (unlikely(!folio_test_swapcache(folio)))
> +		return false;
> +	if (unlikely(swp_type(entry) != swp_type(folio->swap)))
> +		return false;
> +	return offset - swp_offset(folio->swap) < folio_nr_pages(folio);
> +}
> +
>   void show_swap_cache_info(void);
>   void *get_shadow_from_swap_cache(swp_entry_t entry);
>   int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> @@ -144,6 +167,11 @@ static inline pgoff_t swap_cache_index(swp_entry_t entry)
>   	return 0;
>   }
>   

-- 
Cheers

David / dhildenb


