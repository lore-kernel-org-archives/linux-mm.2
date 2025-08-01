Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F325C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2675A6B0092; Fri,  1 Aug 2025 11:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23ECD6B0093; Fri,  1 Aug 2025 11:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DBA6B0095; Fri,  1 Aug 2025 11:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01D2D6B0092
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:30:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A3F91A0147
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:30:56 +0000 (UTC)
X-FDA: 83728576512.30.CCD99F8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 09F0B18000B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:30:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A1b1H8bX;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754062254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCi1+HoXdkRVSSOUpmZn555kzLpizeDbqqPts9w0KWE=;
	b=8Ka19VUhCTwD0iTRXK5QQKF+KFIdfDSFUVFs8zVSuh7/OVFl6F+RvLPkK6LetyQbI6g+LX
	U8jin+TYqlSuosvgnWvcbWGDTOBwPYYB1jerJbhZxMchb/PpU59X9WDlHL0BWMO6iAfzW1
	C9PynwWzipkJhaPq+GHzaObUXTnISJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754062254; a=rsa-sha256;
	cv=none;
	b=3SMo7AywVnuLSa4jM2v2l91uidZ+ACpdcgQzhbgLgwz3OKSX9/qzqeSS6jE9VzG1WXDSWy
	nKVG9bav5OozYIMGxOIOIP/IcIrdFx+aL25bxGMxs21AzIDCycqXQCZUYz30h9YtwP0acM
	ETEeE5VYVJMiCGWYa+lth4dgG5g2/hg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A1b1H8bX;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754062253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TCi1+HoXdkRVSSOUpmZn555kzLpizeDbqqPts9w0KWE=;
	b=A1b1H8bXGxuzzgxxBs6J2IWdTfRos1Lp0Ff/+3XtQt9gKFq2Lm5+Vi7pCGuOJdBd0q9IuY
	3jVI8d9M9g5aB10ctEBDyDJskYxE7tuwkUINhH08EN4FBMexwcDO7Lnm4CC+isCKJgsWqM
	VP9phwolMztb3siBo7zsj8LbMF/Jj4E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-1X3oo9RvMVGV6bZ_h3ZhcA-1; Fri, 01 Aug 2025 11:30:51 -0400
X-MC-Unique: 1X3oo9RvMVGV6bZ_h3ZhcA-1
X-Mimecast-MFC-AGG-ID: 1X3oo9RvMVGV6bZ_h3ZhcA_1754062250
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-458a321153dso4958515e9.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 08:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754062250; x=1754667050;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TCi1+HoXdkRVSSOUpmZn555kzLpizeDbqqPts9w0KWE=;
        b=CdGeOpUvORdvF8HS2T63Z9Y8BZcK3848oYEDMtw1EO2PgMlGGT2u33GFyjhcM753KW
         TWAKFvkBfx+tIz7EsZbIO7CB8ENHpiBGDecrgCzzEZ7uv41Cwd1CttzRkVPV+i9d/uVq
         5kOHARdKxOFX+uP+Sh3kAsuNA26M84MHkK6rG+rZr7HlQS871DeFh/yJnFWfbAhzmSQN
         q7VkRx/T5imdY5e0LR6tsweLQmvXFXZWI6jy81mUZly6//8rc6D/fWcgdc6iFsY+gvCh
         e34oWwTUNThrNaMeExBbe4vTR/DdYK3vJK6lvHDQE7OryOZyFsMm6GrpoHGxikIsDmGE
         WDwA==
X-Forwarded-Encrypted: i=1; AJvYcCU8F6uNB7kHwOh2eQyOcrROoMMQfKWpxtBjE3/2Y+ePhgLl2wOsLn1zKIRc+rDcjJIL+eTB5c269A==@kvack.org
X-Gm-Message-State: AOJu0YxTyJHtxVi44POXBrfpTBfSfypRNgaBK9jiRKhGGxvBGCgu+rKI
	esWZVrGsC7fudii8ygiQYcd5b9gbvEf4hFtPOlKtBk/kZ+5aHuaclLfN5eYPMzxZ7MHzOXB2Ar1
	zC5m8ce3eT5tQDwmTn4C8g23UHl96eLj2vRbXmZSTtce5+XcmIbVA
X-Gm-Gg: ASbGncsrRtBzbnq3nm6CxyBJPgq49o+PJmFyaNLT/TYtuLHNBZ7R69COUuT/Ns5ngu1
	vGsdQ5vAPMKo8DdmhohM3VFHHyxxAA24QwBH/LqN0Ar41CXz57NPSqdN5Tml2z60l+IWBP82fsc
	3Olspi++qwCp8EiQnpeidn1+oiUjITd4eHAX1x2ExChAw6a6/SDrqABaG0MLqJZteg+3Id1R7eh
	4ghJt9z9+ZawrwFeE3UUhTkNvQrdkTy4EZAjZmv/0PqMCCdEIiC909MU87DIjieTzs/HPv50RzF
	qUChcyp4LIU3rXYvXgjN1NjnwzbFJ13arJGDRScZV2a9FyCR8zG1F2R3+Yvj0EFC8/o9cmAyIdd
	jFp9aSypRJK8YRgJOHVMR8CRbfF7QSl7gOzdAefdw76dtssCvxMAWpNiuM9boQe+B
X-Received: by 2002:a05:600c:8b6e:b0:456:27a4:50ad with SMTP id 5b1f17b1804b1-45892be4bf9mr92153785e9.33.1754062249729;
        Fri, 01 Aug 2025 08:30:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUB5TcsYvRJNB+TvTZn9gO82Mj1g+cFuoQumEuT1Z47ONxoVqJ+Dm0x1gQESNybtDTjIpcKQ==
X-Received: by 2002:a05:600c:8b6e:b0:456:27a4:50ad with SMTP id 5b1f17b1804b1-45892be4bf9mr92153235e9.33.1754062249262;
        Fri, 01 Aug 2025 08:30:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589edf54bdsm73593495e9.6.2025.08.01.08.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 08:30:48 -0700 (PDT)
Message-ID: <88296851-3bbe-44fc-a507-70964c0bea8c@redhat.com>
Date: Fri, 1 Aug 2025 17:30:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 1/4] mm: rename huge_zero_page_shrinker to
 huge_zero_folio_shrinker
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 x86@kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
References: <20250724145001.487878-1-kernel@pankajraghav.com>
 <20250724145001.487878-2-kernel@pankajraghav.com> <87v7n7r7xx.fsf@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <87v7n7r7xx.fsf@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9Kd3R0bYh2STd3EyShHSOlasublE489pfa9bId3wmJ0_1754062250
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 09F0B18000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: jr8wi1bmy1ddmrwxoe9csgmxhje8bhbn
X-HE-Tag: 1754062253-915263
X-HE-Meta: U2FsdGVkX18Pjrn2LyLNLF39Bj5CoiKdAzcCniouI8FCQqL9VON5jMcXgtZQ1EH/w1VV9Re01GNicZ2Fw3JIF6zsSTYQWyvptq/GyWUi3d1q8G04yqAKcUmcuGIrRCs0w1wzo7eTRJGsECmPaAYV9wSUw/EI5IiEHeaUekoEr2V31EdVrvX7kLCeu5BssUv7pwqZ+H0M8h8wnEyfZYzOd3htGe/ubgk+hwRL3FPfoIe634w1qcuox/oV2x1wJnYocfMtFNSTEIOp4Lar/1OaK4CHBxXWge/+sZbM4AuiTiPPJwhotrPnvKv6YZ3GuoFsMgSAJH25SM3Ik7cwALyx4qVV4kSsnT7hGbJ6AeAu23AgKJX8/emPnXF9MdaB0/4h1ytt4NHbIqPyw706R54nk1erZ9sBEofZHveZUJGO8elSbUgSnEIIJ7kD6d6ji16GqjE4LlUspQ77Kni0884lb+b2YKSEbVsyQKKrzlvWjMfUEyYe+ZbPjpuRMM6k1k+pWW1qNwqyQ6HH5pMU+AAEz8jWP/AzpU1ejV9UWO6BJy/mX4qoNnu/h/ZQA1TrsB8YNP0/o6hkw0YsnQAVQciQ18ImsBbBq9NUyOt7tgoaYpgh8srPI6BGhO268cROAKTc0kaXNVfnZlmx3jbSKj6L9TMOl1KCpxOAArDPhou0NYm8ss9SxTouWabp9YqKFhaDW9eG9aLUsbMSYFvul4W4nzAQYgtAH8ERS7f+/oEUA04tx9/O8almJaUn0zTF0sbw83ZKZZgNG5TtkVuqeL4035aELAdNaSwVY6UD7eaPx9BdOrvMVUCdwCeeC8/2wsAuV55QITAe/xqrMh3BMsCwKelR5KagClIxbveaOvVbKAFRd9glbWONrqyZh+PVtGgTJO1i/FOHWCiNUNLpQhPAnq7PqeWQoz66Esxtl35c/Qe/LUQ6BAPNKdEOMDr8CrtGlLCkUcJMrqNMJcwXPYi
 XbvLESrr
 gj6znnmYz52lRJJ4tCZasT2SJ5o3ClGzczAOZZS2ZtOm9qiLyD4tSa8c0owVZEIcJ6zhcSnnudI/oCJBs7G9tIWFGFkmkT8fpwDBmvpUmM6b6EhKLywoec7yphoHmYJGyNkHY7J0wV6lTZLsFOcPhtSZNw5EjMCBvNKure7iQnz2CWVsFZk2yNh1g7Sl8JNjYkqyoBe/MHsvqgvn+rAf5q3EiQlAG5BVg6/JP63i8juR0dFbv5pvrdwiQtGb4wGJCDhxo6fa02YbBgpBcuNLO4Wgag5d9VaZ2uL8YlwOnVeK5+JaXCU7qNK25TRI9nPI9MhXfJcpdPND2P4MpYb5OHNcXg49Iy5KCcZyQhBL7Sg2fz1lwtypTV1GKPuQpcsSMJlLD1u2gOKVz4M9hg/0RJ1A7cePDCU1C209eTM546U4quvnIv5vE35o7fBVH/QbTKJZnZxVDmGoYgpn7dbmcoiwWCvfoXPbehNceKhc/LRmnZFk7BVYh1/82hNq9CIpQTOqZEI5vSlz0oku00ZUXLyQ31+k6aTlbuB5m7KNZC8YQZX1JZfxhyeAKUSmfUFayiG+RTh69CA55aYw6ZsJRuv+oJQi93il+/LhkYHzd3OwwJxp6INmeDooFFMR6vNEAsyhOnm50qQOIZ5BcbMLO8xdJYiNgSCzC40ic
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 06:18, Ritesh Harjani (IBM) wrote:
> "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com> writes:
> 
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> As we already moved from exposing huge_zero_page to huge_zero_folio,
>> change the name of the shrinker to reflect that.
>>
> 
> Why not change get_huge_zero_page() to get_huge_zero_folio() too, for
> consistent naming?

Then we should also rename put_huge_zero_folio(). Renaming 
MMF_HUGE_ZERO_PAGE should probably be done separately.

-- 
Cheers,

David / dhildenb


