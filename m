Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E161FCAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 12:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9838E00F9; Thu, 18 Sep 2025 08:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81008E0093; Thu, 18 Sep 2025 08:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96728E00F9; Thu, 18 Sep 2025 08:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B76138E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:16:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FD3513902C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:16:04 +0000 (UTC)
X-FDA: 83902267848.01.3882CD0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 01D1540014
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:16:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cfv36FUR;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758197762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulEJfMwUrht3OKAns1HWVRq6ag97yaiR6fr7dDvVVhY=;
	b=ACsZj/PCZS4wPHsdErUXj8lhnTlpwaqTB5s+FxdLbfsiblRkKJUHwIyx+sEngN9eDok+gK
	/vSPBSgZcOKuQTduMTpdPGWKx/YrSdBfKpQEJO0dazUpyblZZqdQYGktoqmBgw+DLf02hH
	qXL6ZyANYRfGaYLjutOLQOqy29d3Tqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758197762; a=rsa-sha256;
	cv=none;
	b=PQ1oN+8iBMJJ8vhZT5w7vjMucPNbSvAbMWog3rNCk1FHmE4QyBaNjC6UB1QaS7gK0c+dMg
	2nbxCCVV6ALn54atAYvTPrVSDmy9mppyJMXzWKx6k9A9/13w7HGFaSp+zZe5p34MJSj7yd
	6voBtLIC6a0hGq9IJ3S+2kk1D7kfUr4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cfv36FUR;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758197761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ulEJfMwUrht3OKAns1HWVRq6ag97yaiR6fr7dDvVVhY=;
	b=cfv36FURV645OZ9u+P1wRmO5+Ef0cstmydGzGhtpymO1WLdlFeVl9KI0AVQ34inu3AdIIt
	9mvPBLoxtrQvDtVVpyTAU/CmwlpCX1Tpuz/PFRuPLtGp4lwXUmMo3hWj+gt9Pl23DphT+p
	gb26uwDSVVPIRQZl/hUL+A91E4Fwqhs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-JwYKNSWHPIiSeBq3pvs1Zg-1; Thu, 18 Sep 2025 08:16:00 -0400
X-MC-Unique: JwYKNSWHPIiSeBq3pvs1Zg-1
X-Mimecast-MFC-AGG-ID: JwYKNSWHPIiSeBq3pvs1Zg_1758197759
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso7085135e9.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:15:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758197759; x=1758802559;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ulEJfMwUrht3OKAns1HWVRq6ag97yaiR6fr7dDvVVhY=;
        b=iCHmAIeh2wW6f4Sev9s96PDWtEH4AK0y6x+7MkN3bXWGZ5UqW9YvjjK2z+QpzCtfKM
         PZDOckEhInMogfcUB6Xviz5aEOzrk+85q7pCy0M2pmXz+jw3S77iLS+rIu9VjZJJd8fi
         TgiF9utkQn3ACDF0yMX4WBy9D3MgnMSCAoQEt+w2PmP1UUUEsL/uoCyuujVoga1igeDN
         Hk3PcXoxqZFyYvcgUGPIH8LV93DMEsRfa/9sAKjl3pBJz0db5MuPoESvFkaUgbVp+M4O
         kp+Iwo85oOYlQo1vaNC2F6F8+/PDUObMxm9ss97JH6PFJMTtKlnoOI6Q0CmSiEjBa7x5
         /viw==
X-Gm-Message-State: AOJu0YzduWgQYgTZ17PgVY5rs/iS8UeY/pwKeKvLy2PkoUEFUuNIt2kC
	vFdbKI3OvXztHvDqOm006LN8+az0fk0Agt0P+UOWSaCN9G4ugrhlCzBnM67ApCXWrU3t/Ab/K2e
	zVsltDfGgMo3n2KBtZKFm6Ff1iHDDYLaQMdUIKL2ItPfAlhRuzIOw
X-Gm-Gg: ASbGnct92khMr6cF6SzI+Nq0q7GDL1AtHldFzen1nA61bnUqzc52EQM0WyerOKe/E5u
	SxQP6i/RNv8rGeMggA/liHVS7qn7UfkwJ9G5QKWVy6zKgPRWoMPUpAaD6dQQ+f4ln3YWBtA51EN
	fhqOdBk1ZSFXnSUIhcHGHxyTynIcXXThUtMhUCurLhBsAlf+Kpp+lEVwqecIr1uiq1+I52Kasm+
	kk8q3g11fd1UAtIQFcdsk0fszSbQUeZLXsuUX3G+i+OE/qDTecrJ7gkRHqcE304euKLtNcQtcF8
	AKghw9r3PnRrwSSN+VeHkRSDA+47M094wUiEwQhFRN+ZQ1lRvbdKaABS0zOiNUfM14WjivLYdOA
	hosoI42+k/LFJRhVS8GXvEqTpvN4aYdK781Cz7mcGJ3ASsZB24yhrqwtRfE2VaayZ+lim
X-Received: by 2002:a05:600c:3421:b0:45d:e531:99df with SMTP id 5b1f17b1804b1-466aad51930mr9037265e9.3.1758197758701;
        Thu, 18 Sep 2025 05:15:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGuNqwEth+bH+YuZyF3qbKkugj3CbhLjQTnqczvHb+i+ExVsskte42EU4HUFvw5g/n82QcOg==
X-Received: by 2002:a05:600c:3421:b0:45d:e531:99df with SMTP id 5b1f17b1804b1-466aad51930mr9036965e9.3.1758197758278;
        Thu, 18 Sep 2025 05:15:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613dccb5e2sm78562505e9.17.2025.09.18.05.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 05:15:57 -0700 (PDT)
Message-ID: <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
Date: Thu, 18 Sep 2025 14:15:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com,
 jannh@google.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>,
 SeongJae Park <sj@kernel.org>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918055135.2881413-2-lokeshgidra@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -DTaz8AFDwLq5KeQnoOHe7b6WewiMr1HmI9kxkeqiCk_1758197759
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dzgwieyfdxf1h36s5t9593bcxae3umad
X-Rspamd-Queue-Id: 01D1540014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758197761-597285
X-HE-Meta: U2FsdGVkX19iO6/UxhEdqGCsWD7AlzF/WXe0p6DiAONxrRz+W+t4Is1zzMJrnUBzpOJA0EbKqil+7WaIkTVJBxFcPfyRTkX6BvyIIWGPTr+DsCrsWMNbJkc20Guk0z5H3BdK+w1XAwM+ysW7/B4B14HEbHTzRTjENbcpNhlmGvIv0EXay8j5OHyQroSUdUvCBPwVZ0j/J+8dEoFSoW5HL/trhje8SD/P6Y2Ok3GivzBTBnVhme77wIry8hwqjaxN4KpTWd1m71MsWg3S7cfPJye6zW4pV1nuteVE6GPsAVBFf4i3kIeUOkWtVfB+2GTu3nk5x3r+AxmkVTUa2TfiR0/+h00aAyXhQKCWCj420VLI6OiHrMCCy72FZTQ0NihFIxw2U1xdrf63ueSPIGLXbZxDT85YFkZGeAPCOcPeTEt+HcwX+6rvwhI2S+5zSxgcI4UXTguYcKVSeF00M+oYu6tterK3OmwwefE46vn264StRUKxgddZNa3KOMeSMQcWMYRbDvHKQ3x/czMHjOLuM+sSjm7pujUmYqny0mCpNvMSsk3+lbLirhfIkGZ6ddh+xhMtexY1OxchA1+2EVYgLs+PI0u6CgHWqi7AqmFJw0Ku33KldIGUh0TYsOneiMTaTQdV1U0fIKUQfNZP+b5l+M4pky6XQe/pG+3ek5x8VyONYCDvzxzLEyrRgD3s0zkq/dAVbG0tN10xHNTwh7fHIxXf8t9keFfLhpKrkv7SLIX0z5zVWcKvjXNnGB/pbnNy+OOhZ5OPNAn0gOdFXbYnb2kjIICbyIfYs9T82/DhOPxrXcq6BFio5P85ubdp0cZschQnEFr7D064gSj/Zd8Jx+IlIc63+9aRfolqJG7csU/WcXKghy3eP2suJsj1Ke0AdXCJo62wzNpKBOnYJHJDysuC/kPtYEBiBhdhh+lXvRxRD/5NqxnVH+66Ph96evBK8gu0vdaHb6YYYqvro4r
 dt0/WYoa
 LS6kUF0q5EIbI/+ZvXX/6SzpeeBq+NyveZndGG3NOAGJtIQlz+M67NNPXfrDXwKgq6m4nyFVXgZkn1W+v0uqUJHiNH4wopSFcX1GB93DCFLq4+1DXdV7O6LAASqO6kHqW9BdIuKYvXDomaluopknplyTP6szFqmwYMmWRwIEKKmW+3VkNH3smcwnHFhCsxU1Sz/401hZ5HpKIlwoCf+dPvb2ACewZSNEdXvHYKJ55THTTbgQe5cssoJjkixsbxppRR4vbtutKKgUbP3LuNBsMaIXeW0ozYTmj3rmO6AA3jIM1894/VEz17n5uLo4NgUTIsGROOEofWC2X4e3bdzDI87HlQrxhh3XKbL8qDCVuom7+2YYFRcXr25q5r0ZuK4K6/NA4KrQf7cRWplKdaGI/Cy94cN11gjrHUezZKfxn36KvQQHTAdWtdgTK8HbjRM9CljOAV5DkFH2yeAKKJLqYzUNZvPTiy1wwF0T8/TgGTFwnfTrByibg5g0JfUq5BqercfDD5LMF+fnMJQhoTKWnWNYAPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 07:51, Lokesh Gidra wrote:
> Guarantee that rmap_walk() is called on locked folios so that threads
> changing folio->mapping and folio->index for non-KSM anon folios can
> serialize on fine-grained folio lock rather than anon_vma lock. Other
> folio types are already always locked before rmap_walk().
> 
> This is in preparation for removing anon_vma write-lock from
> UFFDIO_MOVE.

I think quite a big bunch of the cover letter belongs into this patch 
here. In essence, why is it okay, what could be problematic, history 
etc, etc.

> 
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Harry Yoo <harry.yoo@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> CC: SeongJae Park <sj@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> ---
>   mm/damon/ops-common.c | 16 ++++------------
>   mm/memory-failure.c   |  3 +++
>   mm/page_idle.c        |  8 ++------
>   mm/rmap.c             | 42 ++++++++++++------------------------------
>   4 files changed, 21 insertions(+), 48 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 998c5180a603..f61d6dde13dc 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -162,21 +162,17 @@ void damon_folio_mkold(struct folio *folio)
>   		.rmap_one = damon_folio_mkold_one,
>   		.anon_lock = folio_lock_anon_vma_read,
>   	};
> -	bool need_lock;
>   
>   	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
>   		folio_set_idle(folio);
>   		return;
>   	}
>   
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>   		return;
>   
>   	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>   
>   }
>   
> @@ -228,7 +224,6 @@ bool damon_folio_young(struct folio *folio)
>   		.rmap_one = damon_folio_young_one,
>   		.anon_lock = folio_lock_anon_vma_read,
>   	};
> -	bool need_lock;
>   
>   	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
>   		if (folio_test_idle(folio))
> @@ -237,14 +232,11 @@ bool damon_folio_young(struct folio *folio)
>   			return true;
>   	}
>   
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>   		return false;
>   
>   	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>   
>   	return accessed;
>   }
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a24806bb8e82..f698df156bf8 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2143,7 +2143,10 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
>   {
>   	LIST_HEAD(tokill);
>   
> +	folio_lock(folio);
>   	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
> +	folio_unlock(folio);
> +
>   	kill_procs(&tokill, true, pfn, flags);
>   }

Is mf_generic_kill_procs()->collect_procs() problematic?

The dax_lock_folio/dax_unlock_folio part confuses me: I think it only 
locks an entry in the page cache but not the actual folio ("Lock the DAX 
entry corresponding to a folio")?

-- 
Cheers

David / dhildenb


