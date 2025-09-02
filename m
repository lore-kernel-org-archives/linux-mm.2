Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F3DCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DE88E0015; Tue,  2 Sep 2025 04:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227388E0012; Tue,  2 Sep 2025 04:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF6A8E0015; Tue,  2 Sep 2025 04:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E18CB8E0012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:23:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A703F140B2C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:23:58 +0000 (UTC)
X-FDA: 83843622156.28.F297F53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55185C000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:23:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JcTdhIHX;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756801436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvxAM3vFK2Ke3HXVSRqbv/c2sggs3s08NYadXVb6dg0=;
	b=ICfgZg8nN/GdG4Hi5sG7qmnroHkgVbY4pN4HJiow26p6v2SP0UWbVBs/2kIc4V2OGqOi2+
	IHDZZFCVOxRc1ai9T7iQNR/4Ws1C6TL6ZZN5u2O8DZxi00HRz0HahRKtvLyqDqO1DNrFzK
	zfzSahQZiD4xmYxTr4tgqrEZc+Rfq20=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JcTdhIHX;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756801436; a=rsa-sha256;
	cv=none;
	b=y2mIUvwzGYiWmQayuulsmdfs0qpasLdq2H8dDV76HK5PzGYxvIE/S9JO/OW3VclZCvgcPU
	69F8ly+ELuQkFDVS2XsGOib54G8KapmZAYRbtn50v57Y3eGgKD/QdtwG33z+gFKfVEGLlw
	QC1FTvwVN5kMHnmjwS0sJ0TVzUNIvUU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756801435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KvxAM3vFK2Ke3HXVSRqbv/c2sggs3s08NYadXVb6dg0=;
	b=JcTdhIHXnFpqJy3iy7rP5I5t7Dt45wiuVQpDzsZJjlT2EpWC+s9LV0AgM7qSxJSZj+rBd3
	AVrL8p1IhCJ9h7bhW3CuZsckiYcL26V3L6pVdl52+T11d6kb7nY7dUTWhEFhJus40jelSq
	23F2eX3+JRISkWADGokZnhHvH5STar4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-b0vl3WpqNzmMtjLmrqYnGA-1; Tue, 02 Sep 2025 04:23:54 -0400
X-MC-Unique: b0vl3WpqNzmMtjLmrqYnGA-1
X-Mimecast-MFC-AGG-ID: b0vl3WpqNzmMtjLmrqYnGA_1756801433
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3cdd69ee330so2234147f8f.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756801433; x=1757406233;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KvxAM3vFK2Ke3HXVSRqbv/c2sggs3s08NYadXVb6dg0=;
        b=Fc94isWknSxUgn9/5oKdrhuv1eLGjVCGFOPH5FM3C0XWJ/QqVsr0noVAEkKLnueYKN
         8i00BrLuvXbdnoHNEmPrvDYNWgdWUZvZlLMztJQYl0/KMmCVdAC0ujkdSW7Gxw0gJznX
         1XctNNpVrH3zcpT/NOaqknNJpGM+AVXKY4Ls8xAhmjrLoZ9XYh+jBE6AL0mW0bXinfuD
         G4yRLHwWArx0vSIN+DZADW810sMtPuNNpiL1MM+XMJ/M1B0iwhY5Oyfc38H9+mxSmaX4
         mL3IEWKjo0/+uAaanZDOByVOLLHHUJyaRVWLsFgp4xPMK+Z0be1vx1QEj/upcrlhhY3n
         A2lg==
X-Forwarded-Encrypted: i=1; AJvYcCWTV1U6G15HvjOrw7jza4Ua5cXukvdIWDDLXO/iSoz+5pqdJSim/GkL8YdRvd9n0fsPOZvBhoALxQ==@kvack.org
X-Gm-Message-State: AOJu0YwdqUkOL0I5mjDb+zgobaP6sQD/wgkW9zk1MXSuSTqrZoQE49rE
	HSyM3kFYhmufpq/PeycnGcHOZIK8Pjxq4m1bAJ5SEFcno8KcTAkhgBxaI5OoPJbeNxlcNKfr7KS
	W1QMlsPkv0HzOAT9yFY5i6y55xYZ6eOQMMyHBhj5U92AznTRXp1ji
X-Gm-Gg: ASbGnctl5MiZggUg4777of7urr+FPYxrm8AFTgJ2jBsewZJhrCvxAbo8mbeFxLrEoYC
	CuDSKVEZhgqRzC1Gk4C2uXPjS8+QWs8UZcBGMMXyB4VLMYl59LLfz63hNw7yfA2kKoxju2M+BcC
	XiZgn4QAQV2GkVK4FN6vtWAOTV0zbxHQZlrCx8Hx1CkKTKAtgUSxEbqzjFYzvGWvaB7QTWePZPA
	EEYjG0iCs7XgtzPP/feHQckPE0seCOfI9Wo1mwiNzFeIojvBSp5V4pYZk72GghokHkFNex3+9Vf
	wySotJZ67XkEKzaU/yEhssv5ck+UqK7N1CgIEN2KMAEQHNhAuEZ7X08vXTAyHEnua8u9Y6Fw6g8
	SaJJSmvKq1LMhbODMDa/TWhfiyfn8fGAzATN+bmw20/GtrBIXQ4wBOAD4iBL7jxee2Q0=
X-Received: by 2002:a05:6000:24c1:b0:3d8:8f86:7b0b with SMTP id ffacd0b85a97d-3d88fa504ebmr2342619f8f.50.1756801433274;
        Tue, 02 Sep 2025 01:23:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGePR3w/xMngBlylIPdnX7e6LlYWdH1m+Rn45nV4kPBWpyUDCkhsR/RDNmCwosoWathSfLsGQ==
X-Received: by 2002:a05:6000:24c1:b0:3d8:8f86:7b0b with SMTP id ffacd0b85a97d-3d88fa504ebmr2342601f8f.50.1756801432817;
        Tue, 02 Sep 2025 01:23:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fbd01sm19047514f8f.13.2025.09.02.01.23.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:23:52 -0700 (PDT)
Message-ID: <05f628ba-c24b-4180-87be-e5a577dc4e4d@redhat.com>
Date: Tue, 2 Sep 2025 10:23:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
 <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
 <20250902025112.d2n3o4imeptppctd@master>
 <dd30710a-a210-44dc-93f9-1e7ddf096251@redhat.com>
 <20250902081342.rthx5sopowmg4hyb@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250902081342.rthx5sopowmg4hyb@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Aw46Pw-wK56aXo7ZwemHDW5OdEB--wwBhYEFC5n4PwQ_1756801433
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55185C000F
X-Stat-Signature: tjj8c43hr3gzyebud5z1593fqybsqtkr
X-Rspam-User: 
X-HE-Tag: 1756801436-219382
X-HE-Meta: U2FsdGVkX1/DPotDIlDsHW1TvmUijkQFamXSIWXZgbKZdot8Ov+PPIkd51lY6zBb+UBpbJoQ8sD3aWrWwkF3PSce+IKhWPieRDvUHn0qGLM8O7UNcoRCWRraI6UysDw71YchJvAZy2n7+1XCjAM95CYE/TZzZgnYAqTUBynBmCXmnBKUN/ERupGR7LroX3SZUP4K5qjelkFgho1LngVXw3R9s1scSx/NE+WA9bK9JSkkO+CZfy8NJKrJq38+QrJ63s0p2XYNAIOjPJgdsv46ImAZjdNLuh2OobytrudMHZLJeoqr7gYrx8jIGn1dkR4nTtrIeozKzIIyuxrGt2OVKDt5iKi69d7i8gdTYD4Q3IeouYtbReXWnHjtBxjsuKwqSV1csWxaGKIkb10c+YhERQTaMuY6zOm5O3zcnUVMCq9tyTVQYZxjrzz45zfrmQr3Ati74LBi6H7zY8JnuRHhYPsKFdr3wqEk5vyzC/W4EuOskNreCgubtt6gyLBEOQgoJSXy6cmS8qZuPZSl/7McEnTs6gnuXa/HApiP2GmfEhKT6d5by4EQHyUncqDVN0sdgrsKHyBt2tGpF91T2JWIRrvnBUjgo1+ukZdixCrQFeFXk9BL4kGj9Byh5Lh08cRriLJtl97BrfLUgwZaBtcuEBOlK4t8VV1pSgAOUItfOynDPzEIGPYVgjT7fiVFUpTZxL5+7e3Le5nMzumbzVTgWOlN8BsHaXc8MWugcdOIbmF44eIhfjdtkfEbSDC+HxCzuNOtF0QHC+jESBnmf8LfBIIn7OBKtPWHuthY4chZ6suobxgNazRiG6WZupnQXljnY5m/bcakD1vbHtQ/96FggmL8clnt/BkmKuZo5nQFIRn/H/y6qvyggbUyjmnu0iprcCN4jp+mAbFL2vswVJQiEAF07jdPhx9JIzu83E+6UaY1S0d+XPB89DYupWIqP67sYjVpmzNVfVLxxtEjFiS
 2QcAx0Sb
 8/qZkUk7jBpcQaKqTSMkk120qP5l5IcvY6O2dlDyXnCB7ZieqNrO+i5/kK3G8J8ubDwSOTctUVTs7Y84szuN0EKulwbeJyve/5rQQPak4pDNccyp6rnlU7iBrSf874G5RF+Dz7Jca7aBbJ/huCMhpvaV/dG+TXKJFoOJ7D1AKDqHMGiTRkd+OM1F5kKRbCxmbgvlOoyUhJMakYpPpmq2lPfedB7S0KXbg5JoHoxdTwRmDps++VKvhS6U/huJswPS3rNUZOwgWSdMUNW4oQbWHKgD9liLUHjS8CBpFq2v/CGhjeMSHl4nhzKxadLOhDO8t5MmxgZGvMjWAGLg0Dl0a8ERCzwWoS6sWxQbqc9a4d1ktLgJtxUi3zfFOOXvV/cqFZU6B6A1uGsddYqlHgABW8YxZoNhN9hnurj0ywfkCpIMAtawhIs6srOj6rScDmeXeOx/XJ1gq3ZzeAUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 10:13, Wei Yang wrote:
> On Tue, Sep 02, 2025 at 09:49:48AM +0200, David Hildenbrand wrote:
>>>> +	/*
>>>> +	 * To challenge spitting code, we will mremap page[x] of the
>>>> +	 * thp[x] into a smaller area, and trigger the split from that
>>>> +	 * smaller area. This will end up replacing the PMD mappings in
>>>> +	 * the thp_area by PTE mappings first, leaving the THPs unsplit.
>>>> +	 */
> 
> This confuse me a little. How about move "and trigger the split from that
> smaller area" to the end? So that I know mremap convert to pte-mapping and
> leave thp unsplit. Then we do the split.
> 

After spleeping over it, what about the following?

+       /*
+        * To challenge spitting code, we will mremap a single page of each
+        * THP (page[i] of thp[i]) in the thp_area into page_area. This will
+        * replace the PMD mappings in the thp_area by PTE mappings first,
+        * but leaving the THP unsplit, to then create a page-sized hole in
+        * the thp_area.
+        * We will then manually trigger splitting of all THPs through the
+        * single mremap'ed pages of each THP in the page_area.
+        */

-- 
Cheers

David / dhildenb


