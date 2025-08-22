Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE91CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 14:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147E48E00B0; Fri, 22 Aug 2025 10:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1CE8E009D; Fri, 22 Aug 2025 10:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB47F8E00B0; Fri, 22 Aug 2025 10:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D2D068E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:00:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 857AA1401D7
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:00:07 +0000 (UTC)
X-FDA: 83804552454.09.FA3CF85
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id C1C74A0012
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:00:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bdmxIqml;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755871205; a=rsa-sha256;
	cv=none;
	b=BNXDOYZ9HaX/AE/fSNtomGoPc8muA2rud8W12IvGSOWW7bl5+puaGQMCpUS2E6lxKBbjUS
	ZskBm4GFfflQaTKmtQoAKhArpM1/KjiLQyNncCyzFFDhZcTnfOYoMFh7KkVrPqBILfin+e
	+7lvPeQq8dCcyGhIRkmspGHIcUOPJdM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bdmxIqml;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755871205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6aDoQ2nZkjhSfUgeR22UAGAXQBWHHuCN2RUasZyd3Q=;
	b=IHu3HgUdLZtIBKqpYfbwrc2shZ2Aod9cIeJdRPZivQppY3cgBHzxqaUcLxEc0ynLEFqcIX
	5UhZgwjwqygfa6EJTVeXIiR/+8SLxsQZfIUzIuh+LlV73NQob/Z8pjSMqQNG51y0Z0gl2k
	s5wetVpW+ZfEM6lNeB7MCY6v+/H1l2o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755871204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K6aDoQ2nZkjhSfUgeR22UAGAXQBWHHuCN2RUasZyd3Q=;
	b=bdmxIqmlBgN/hKHe/EcLRMZ7NMxC84lXy2zC4wVJdjf+O38pk9twlU1GCX3VE956IbJyTO
	u533CwhhOoRbl3Dz/7qt+Itdmwo6tbB1XVEJgCPX5PSNMi2c04HbnPasE+OXbnLU44T90f
	TueDakW9cVrRg5B44iFcNybMXUBTSPQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-ftZjEVbdPSup7qvuGtEqOw-1; Fri, 22 Aug 2025 10:00:02 -0400
X-MC-Unique: ftZjEVbdPSup7qvuGtEqOw-1
X-Mimecast-MFC-AGG-ID: ftZjEVbdPSup7qvuGtEqOw_1755871201
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0c5366so11536855e9.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:00:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755871201; x=1756476001;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K6aDoQ2nZkjhSfUgeR22UAGAXQBWHHuCN2RUasZyd3Q=;
        b=kVl9Bh4Jpxykpz5t+u0qndlDbyBJPrlHWrvRzbBJbQzDM6RYDit3rFWtKIo8GQReRk
         4U+twoR52juwM2Pw/SxHlINYPgcM3/hv+jsXaV9w9LYdg2AEDIlVco6ZN21iLvejN91I
         NZhAeEPtv7WtPrSE6qU9FUwIbCePZWheP/mum+hpj+u2KLdEzsKEVy9zgEyB5ubN7nBc
         NKwd6sAbF7w2GhDKz+/0zKjveqZmZW383pTQWYLDvgJAixiOYZgmZaqCH8asJbRqAxpe
         fWuIAylP+Hu/HKtn2Iapju+y9jcJb7RVbWMi8XfveO6Ts8Z9EOF9wM2HTHwsHzBK20Q3
         y0VA==
X-Forwarded-Encrypted: i=1; AJvYcCXHa+zfnNNUzq75QN8bWMrAUJ+E2V53F1SNcuW9HNwIHzBz75GpWe25o8f00EO7YF8Zwk9f01F3YQ==@kvack.org
X-Gm-Message-State: AOJu0Yyq3onHkuR9QvKJmZ0sXxvRqwqwJpmebUGaAGMxAX5jV3bTR8KY
	FFa8uxVrzZES5cZS2XSan2N6fxDM3KI2rLm2h1b2tNpTSr9fJ0tqAPz6jpOnvtNgfCvwlqMbwWi
	X2rj8BChnLaZNW2bBkw721p4kco9qt6nXoRertJe1fKxqyW+XEoNC
X-Gm-Gg: ASbGncub6/s/PXIr1ay2jD6R0OiAG1Mb7jlIIAiyJC4+8CHJQqGfohi3JfvqwJ7TKAt
	W3vBje7kMyUS2r3mrNE79+GJ7cylPol16HWBhp8nkt6ubR1I7cnN5RKUNJwYkIc7iUJQZs/aqGB
	r0f0h+JFsytAH5u8Z1JIi5YlhGQ3CFp231f6QH+g1mNFGeSh+wn334LjsHcUDZGFYNwCEbkwTbp
	59jEyn944iPmL5rlZ/toC2iPqaUXIB+XedctDNP3kTVb82PgyQeNjfGO2EiN75h9vAaALZupi51
	4fbItDVPx8RFbMbn6KP1izI+JG+r5/1xTUtQRZ5eD/Z7rcSI8EQxFqTMB33eVtAD1lTNvMKuANu
	1nmuVxqyM/2FZMZa3shRERX88bTwnBZjPebFgn3iu4+IvZ16EPTZVHpH7V69eFKqwLj0=
X-Received: by 2002:a05:600c:1554:b0:459:e06b:afb4 with SMTP id 5b1f17b1804b1-45b5179b4fcmr28181875e9.4.1755871200677;
        Fri, 22 Aug 2025 07:00:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwWP+gcyHz5PASikvY9eCVK8ixT+7ngDF6OHjbY0O7J0DLjuT/QVU1ki3KQXQcrTer6FnpTg==
X-Received: by 2002:a05:600c:1554:b0:459:e06b:afb4 with SMTP id 5b1f17b1804b1-45b5179b4fcmr28181195e9.4.1755871200176;
        Fri, 22 Aug 2025 07:00:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2e:6100:d9da:ae87:764c:a77e? (p200300d82f2e6100d9daae87764ca77e.dip0.t-ipconnect.de. [2003:d8:2f2e:6100:d9da:ae87:764c:a77e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57498d9csm82525e9.22.2025.08.22.06.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 06:59:59 -0700 (PDT)
Message-ID: <473f3576-ddf3-4388-aeec-d486f639950a@redhat.com>
Date: Fri, 22 Aug 2025 15:59:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 18/35] io_uring/zcrx: remove "struct io_copy_cache"
 and one nth_page() usage
To: Pavel Begunkov <asml.silence@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-19-david@redhat.com>
 <b5b08ad3-d8cd-45ff-9767-7cf1b22b5e03@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b5b08ad3-d8cd-45ff-9767-7cf1b22b5e03@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 67nQhSfSf0M3A2BQDMS9dSnOjZKK0-lS2sGDS2uCMl8_1755871201
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C1C74A0012
X-Stat-Signature: 8jt98asjbom3bcyzwyqb9rhyu5ff37m8
X-HE-Tag: 1755871204-45625
X-HE-Meta: U2FsdGVkX1+5OywjSSzsazq6NPqUQy4qucPplkWF0ULA2I9IdBree8Z7URle1PeWvGx0Phbe3LjDzHiWVieGb/iRKH7dl0yYNudC74QX+c6efNZsM1OaOe4PzIP1uMUQJ4Xugt/aYWtmjcIgb/piNXeDNivdzPFjw2mgyLahrS9iTr2msLcOdBszYX98tcrUs8YJrUN68mPvKEIFcQrCn0TJ2lGhUgWVungowB6/w+I6CbLQTbv/qZJ173Nz2l9KO+8bv7Yr0uEgMih+w8WBlxhW3QIl0Zdk2S0GOavrCr7zm4gkcIV0Jv9MWCyLcg6j8d7DtLKHsaGf667q8ZhDZ46wxdvD5/S7H71DKjWKJAqySJBvCg4br72BKqnPXb4x6UEA14i3w/MDhDNQeYD6dRs9Ox+aIeIVHYEL+xmY0wWcr079RSOsGqGjXyy4+kHfmq36q5nzt5vRw9IYeQXRjkOb49XR4gJsUOCh9q2DfdjauFzt9TM0WbXLbDsFD7uMbYWucnBd8PzY+hs7vv465IS7jkclUT58Zq1kl+L3bkoR7F7q9L537Txn/DkgnC18ctbxF3UrNP6OeohjxWzaeP2Wm6ygS8ZapR//0DjnX69LQf7bp5fa+a6XgSb78N75NRN3FTKplgQGx24rmORPoWNXdCeTB6NuSplbFM8hnsOF7t0YmCaQCmvhnCOBuUy3mKOHBihV8wB1ziYgx9Z3zTGR/3mGgpuJyDmuL8Kyd13/3tV2aKuDeT5MuhWiSeVbDRqPKne64gNbZXRSbKv+SRdUyBYa+7Ei6bOCAK9p/2QLmnqIH1K8+S5DB074wbetN29SXYlghKiB7d4z2ahvabio7+P63HWDqKaZWUOS0E8AQv1zxuOzN6FqV8saQLu2ZeDvdY2GC+OZbBB4Ry579EdRHwc6uN3EF7QQBDBtH0ZCj8zJjHaxBEshmv9Pl43++ICWeyXcm5AKu96Kq5O
 laQA1SZ8
 aoErrOgeM/9Il7r7o9ppnAO1MudU5fEBfmMh5i3QcTS1Qro3c1K0XtSxdMGV5Fh4kcltyRxMow6VzPvnbGnIoYnHuvyypXlNQ2bxzfSmxaUU9T4zAvmLk6hNl+8G1JDM/T2djSg0+Tfm2Bdwa6EzY9r60KdTadSJKuXfEjPSGdGU42fzo0ZyWBMdhhx0wfQmtsqTuPWpvbtRYwzp5PvLdnsFTUO2bLupQtwMqnfhQY/CwtsXQIjLEchrYxM2vkghQoE0g3JIrsvogGnUzFJffzSvIzdA2WCN0Gy0JjFHT9PztNd+1Q5dFYaFdyaJtqG7gYSaibYxAIq2lBmKQfJi0T4bJcJH9USFtpIvPTPylwwdL5XB9WTxCjYfcCvqp+6jk2PUe+K7w54AEn8DldH/L5pW/IxPaMNOx60bZUIcRNoulGNgAIW9OEsRqg8o6ov7r6nTZIlDtwEUW/boquGdLVUNKDb3KE3mEODWVavV5vnM++MMFB3VEdQJIOsw9+T8tAei1q65UkoQzG4fIfX/cARM4Pev5p9X3loZdg7bWJJGkfcM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 13:32, Pavel Begunkov wrote:
> On 8/21/25 21:06, David Hildenbrand wrote:
>> We always provide a single dst page, it's unclear why the io_copy_cache
>> complexity is required.
> 
> Because it'll need to be pulled outside the loop to reuse the page for
> multiple copies, i.e. packing multiple fragments of the same skb into
> it. Not finished, and currently it's wasting memory.

Okay, so what you're saying is that there will be follow-up work that 
will actually make this structure useful.

> 
> Why not do as below? Pages there never cross boundaries of their folios. > Do you want it to be taken into the io_uring tree?

This should better all go through the MM tree where we actually 
guarantee contiguous pages within a folio. (see the cover letter)

> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index e5ff49f3425e..18c12f4b56b6 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
>    
>    		if (folio_test_partial_kmap(page_folio(dst_page)) ||
>    		    folio_test_partial_kmap(page_folio(src_page))) {
> -			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
> +			dst_page += dst_offset / PAGE_SIZE;
>    			dst_offset = offset_in_page(dst_offset);
> -			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
> +			src_page += src_offset / PAGE_SIZE;

Yeah, I can do that in the next version given that you have plans on 
extending that code soon.

-- 
Cheers

David / dhildenb


