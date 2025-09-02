Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 113B9CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 18:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302D28E0007; Tue,  2 Sep 2025 14:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA6F8E0001; Tue,  2 Sep 2025 14:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F02A8E0007; Tue,  2 Sep 2025 14:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EABA8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:23:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91F97140302
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 18:23:14 +0000 (UTC)
X-FDA: 83845132308.22.F54BF8A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 741204000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 18:23:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gSrDF7m1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756837392; a=rsa-sha256;
	cv=none;
	b=Nc1nLvB/Ee6P94STYJJRjlkKqucBDdUJwyUbnWiruQ2mtsMm9eIl/o4wu1YxwMg99FNHr6
	QhsAEk8NpW4vPD3vC4K1+wdscAr1e1c6nKVnegiczzodlQ2O1u5YBYEZ4RfN+zoytd3YFk
	7VfxebnWxrO9p67am95/YsA9wcciwjs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gSrDF7m1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756837392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0pFh8FxqfM1XEDmmx2whmM7VQSC+oOKSVYCp7AUCP8=;
	b=zJ3IF92P7o48IZr1PPKWgPvGvba7W8/WxoH1ToMy0YIJeIFXODu5LoUFchitopjkRjpNiq
	HDzGB2HQioiCgH0mpLxLlNd1yYamnpFs97iYfIFcnAJaLgKp/yYf7o96Lx9t/rAJDKFY1N
	OcIp7CcVQHM57SMAbocQY76JWzQ/WyU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756837391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E0pFh8FxqfM1XEDmmx2whmM7VQSC+oOKSVYCp7AUCP8=;
	b=gSrDF7m1DwpN4QI5HgqDbHnUF+VdZ5uXIzZB2HgivvkUFE6wm/IfjiAcQ3n2RTEApq5ORI
	A/5T/sZpvUEEfM4XEmQCHNWWbtWn9ybFqhdqxnbXoNbERTtxlXZ3bTQwCowAY3N0PnOfOh
	CBp1cEWgnsmZKtNlZKVMO0KYOCELdNg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583--3iuF0LKPPm2stbhEPLpqg-1; Tue, 02 Sep 2025 14:23:09 -0400
X-MC-Unique: -3iuF0LKPPm2stbhEPLpqg-1
X-Mimecast-MFC-AGG-ID: -3iuF0LKPPm2stbhEPLpqg_1756837388
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b9c1b74e1so4495265e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 11:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756837388; x=1757442188;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E0pFh8FxqfM1XEDmmx2whmM7VQSC+oOKSVYCp7AUCP8=;
        b=P30w7xy+1GlaVEAcHlJ6bzobKYkI/CcJllrQ7ARq+QsbPajGW3DR+6Kp8Z1Dk1tLlN
         Mn9lnkWn2YVMjGE/NNDriYoSIWKtjZn5sabsNS/z87caS1a1cF9aDPq8U3uQ0AtYEUqk
         d8N49+byrN1wIEOCAAwP6JryipOShoEkVk+pOsnQ3CG10yJQsSycnz9PgaJ3ZQSZCepI
         XJOiljT81qa2Mm0A/AisaEKZXjB5G3XLOmaHiCBCgifZ9+EnxaMEOdHVjzwIyAAteTcF
         BuI+h+2ybQfe3qYpPTvYi+cXQZ+s3iPjgvxAmbFjqmcf+m8NXJ1CznmBV0saZ7gh04sT
         agjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3w8snhMrn3hDpa/Vatw2GFdZsK8pcSyr56bnXVqP+/LLtqne1ZYlQacYwA8IcWPG1xtrzcg5Wug==@kvack.org
X-Gm-Message-State: AOJu0YxSfZFn39mE7CuI68YOlEPEzD386nJVxwiS+5Q8VyQiMTz8yVJo
	IN/o4G49FhEp20TfsqUxC1h+tZ5dMPl1BwWYFAEtGNc07VHboebqlHa0hAd7OrF6ow9li5jRK/q
	+D+Z6SZ59/5FkiRf0XBDunI83pNe7xRutR7gRGfRVwlHojjezveKM
X-Gm-Gg: ASbGncv1JPPF/yVRvXbACXH/IkPjRAHgfCZnfzSYnrMT50EuiWATxQir6055xwzJaOQ
	OD1u8jN3romr51BjygSUiBfEPtYTLYlWtvMgwaHiSgOnk1oeXTaChf8QSWeksYGrcIvFRj4HtNm
	4ILpzVRqiGXuHNyMp1/vqmoL2NMZPQyC6vfgct7h+SFG6aCyUVeLVN8TU83yYwGDmu4h8k5zSTa
	KuVtEsM1Y2SMg0vvSnKhMkmc24YdSNbBhH2yZzrCkUzH6Ev1fXDAC9RSfCz+sR0maVdAhampX5f
	WExwI61c/5TugSsz+0+yLHZGfsfV11ue+hOlmZZeK/7ChKkI5guKCN27T8vzznkcAtWkAv+qmWP
	L2+fvtMC0eBQDTtR4TNJVAgnt42i/7B08t317T4rP3vWOqjSFxshGDEr1iG6HDu3K+6A=
X-Received: by 2002:a05:600c:1f84:b0:45b:7ce0:fb8a with SMTP id 5b1f17b1804b1-45b8559bd2fmr103371075e9.35.1756837388456;
        Tue, 02 Sep 2025 11:23:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGhNRpJ3Pxny2+h5z4NitAUSkL1zdnUZ2TclN2kLQ0HXcCaFawRrAsucJHE1gydRQcN6r5Jwg==
X-Received: by 2002:a05:600c:1f84:b0:45b:7ce0:fb8a with SMTP id 5b1f17b1804b1-45b8559bd2fmr103370945e9.35.1756837388027;
        Tue, 02 Sep 2025 11:23:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fc3fasm20237659f8f.5.2025.09.02.11.23.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 11:23:07 -0700 (PDT)
Message-ID: <f41383c3-913a-489a-82e6-d2c8d5519eed@redhat.com>
Date: Tue, 2 Sep 2025 20:23:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix kernel stack tagging for certain configs
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Kees Cook <kees@kernel.org>,
 kernel test robot <lkp@intel.com>, Dan Carpenter <dan.carpenter@linaro.org>
References: <20250902175903.1124555-1-vishal.moola@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250902175903.1124555-1-vishal.moola@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hLh66nxBbD-zpHyoTDAYmUFdNRmyFtRB152Ko1eaczc_1756837388
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 741204000A
X-Stat-Signature: ks7um1he7wxt9zyrxj5ehcqntaanfd45
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756837392-329760
X-HE-Meta: U2FsdGVkX19nMsC2hZwkW4MTtATFNsAliLFvxjxRG/2x0bJeAGHO4BfneGul+qB80oh0Zph9evWI7AsYYm7bZl+WjDvVLknjQwOygzY6SWkGQ5OvsEUvNi/YlHN2pUTIwoVS/ypOHuljZYENjn810G+7oGy5Q5DWbh1QulBrS+8UPZdlxvoF18+sjmncBEyfrBQGKEh2KUeuXoSuhoBi92Uf5aiW4WXmc/8D92M2BmAmpnnpbRQY1LmKOXE+9k/sHHsPj773xk9o4xm1xKcTG8hdddum2ZZbHnjrAfsS0uzJmr9fJkD3hWPnN/2ig7QafPhlVCnbVTZh6MEXgkPz3D1tBlGqT+rRSNl7OVPRmwubnQP75AXzxi0XnJlGtSHowzXHX4AWsGKq27ErHkaWkWLTu2zdNX0oh+tgMB8n6VDJk8IfzfztraPc+AmCMOgyHZ2Q39CsjJKAJTXFpRR6tlk+bX+W1HNVc4m/hxqILqxq4bqwWku7opk/QdxRKUjOs2JpX+g8b/bXAaLtnzywwQ7fSRXY10EitOknAJ+MLPg3UwAHv+Hv3DW4Shz/bgtoZ7S+m6TC8nseoiQg2Oip4dUNa0MBJYgNkR8i7zTuvP3TjGmp3Gn1DXmzO7QYaVD3l+v0QuBrkGVG8hRn61hJ3p5E27mcib43EomnzzARWnbfpYOlzUTF7z8Zq0jI/whFcF8CiomHZU9H8AgrXxDhabP28artbd8N+nND8xTy4c+9gR7cP7O4pgcOyMg67U1uSeN8RTl2Bza5mJ1bwAfRXwG/NybpJXMX+23m0Ji90RjFWj3pXoAvSvEpFKR0HOlvPQI9NzdLwQ3eI76jzVfj0BMGQ4d8JKFq5Hl7s1rw9SJ7Z4wtjXjwlGatUs342nDfMVOnAXh5OS8IxhpUgeGtmIcBZ8Y3un49lGKNo8O+ghLvrKNraJs74lanonNByJDfcrewYuckVXkQGWKFx2K
 giW6hJyZ
 iRh4RhQjdREhm3CLdAwyTuZoF2rsEnWUL8NGGoCqihoPk/02U+Ii9DVovw4R3hYtSF1skfqJu3tm1pVONj5ma3WO6LExBUthDpaZSDIMRfHk3kOj335AHOQEbWBR6PBc4L8OajRW1oNR/5tpiPuld/PeOnYMikMLcud/Jt2i2AtUQbByPSOvM4bCJIWk4lX8Uzhx52C2egdAKqjI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 19:59, Vishal Moola (Oracle) wrote:
> Commit 4ef905bda61f ("mm: tag kernel stack pages") began marking pages
> that were being used for the kernel stack.
> 
> There are 3 cases where kernel pages are allocated for kernel stacks:
> CONFIG_VMAP_STACK, THREAD_SIZE >= PAGE_SIZE, THREAD_SIZE < PAGE_SIZE.
> These cases use vmalloc(), alloc_pages() and kmem_cache_alloc()
> respectively.
> 
> In the first 2 cases, THREAD_SIZE / PAGE_SIZE will always be greater
> than 0, and pages are tagged as expected. In the third case,
> THREAD_SIZE / PAGE_SIZE evaluates to 0 and doesn't tag any pages at all.
> This meant that in those configs, the stack tagging was a no-op, and led
> to smatch build warnings.
> 
> We definitely have at least 1 page we want tagged at this point, so fix
> it by using a do {} while loop instead of a for loop.
> 
> Fixes: 4ef905bda61f ("mm: tag kernel stack pages")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202508300929.TrRovUMu-lkp@intel.com/
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

You sent the patch on August 20 and I replied on August 21.

I did not receive any reply so far.

And now I realize that this patch is not upstream yet and the commit id 
not stable. So the Fixes/Closes etc. do not really apply.

My current opinion is that we don't want this. (see vmalloc reasoning 
and unclear use)

I'm happy to be convinced otherwise.

-- 
Cheers

David / dhildenb


