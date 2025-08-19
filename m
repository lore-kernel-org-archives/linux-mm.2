Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D656CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 19:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B169F6B009B; Tue, 19 Aug 2025 15:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7E86B009D; Tue, 19 Aug 2025 15:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B74A6B00A0; Tue, 19 Aug 2025 15:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BDC36B009B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:17:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00C3A57339
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:17:13 +0000 (UTC)
X-FDA: 83794465188.27.DA05AB5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9D57080009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:17:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="V/y4bFkp";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755631031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCoVjraV1aWrr3hYNSy7ZLne6MThZ0GPZ3PvFVZ8gCI=;
	b=4lltlPhdE4CpZVhdLJZJzH0sA96HDtfDYasu5wL77yqcTwB3Jaz33cZov/913fIGER00BW
	WdB4h/65Aj+VYVhiWNMjRVInoURy1HragGh2HTdnIF6/XIyjXN6a/aPRj2KC0cXTKZ7xVu
	6eJuqkb7f5mkiW2mYhgF4o1NDHZq51M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="V/y4bFkp";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755631031; a=rsa-sha256;
	cv=none;
	b=54yYzDFXR58ZCWXA0E5/e0OZ24R3A3rGJ97DO88o/vgdKjAj1tR0axiXGexYIeqJZRB5ow
	brBqJjkroN4lup2fLne6dv9rifb3xymVn2jwzHyB7iy6qpjmjnN34cAmP43wp3rYGeFiAR
	bnLQ8cEW0JKUpLm6JoXaUaNAGwjPGRI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755631031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KCoVjraV1aWrr3hYNSy7ZLne6MThZ0GPZ3PvFVZ8gCI=;
	b=V/y4bFkp2nm+VQPYIrIiicM6NZk4tWIbbl4Fxh1ac8RySVUVOuYNrdIWfOAJGaouzlBvRx
	73VIT8fcTJMMpAsehezKwQFRn8UNdIGHxHj2UvOkUuMT7u2lMVY+IPTgVHwlo6mDabb2jX
	ZJKxBY+0wq/+qzNcBBpU1OSfCr7xRkc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-cxsN8NVLPKevqpc78MN7ag-1; Tue, 19 Aug 2025 15:17:09 -0400
X-MC-Unique: cxsN8NVLPKevqpc78MN7ag-1
X-Mimecast-MFC-AGG-ID: cxsN8NVLPKevqpc78MN7ag_1755631028
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1ba17bbcso25296885e9.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755631028; x=1756235828;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KCoVjraV1aWrr3hYNSy7ZLne6MThZ0GPZ3PvFVZ8gCI=;
        b=hkCx4wDu2vTCFh/y8u0R+hpJANNOQvYunrlUxM6QKkuZkux8WJ+sw+Uga+n367+S1G
         UoZEzK2WzFUApHu3PaBElx1+cBkQC088SfqTu37/DNze0uUywCMDtOaCsKh3cqp4suvG
         YHF844my01o7ZgOy3Rokev7U/Zw4KrqrvNvHHDK4H+rNYFVpJ54kZfGSmogqEuz7kH1P
         CYb2Tjb46dEfI9F4gZ9vxjpymHYHWUzpP1s9IGOyyhKpF/HDI+NPNfs6ckea1oUNLqPK
         cC1bhXGnZPMG3DbAKVGQUKn072pEVs1Ik2t+sBxp1xPPypdZExbWRKzGZZhegrkflwzZ
         oMAg==
X-Forwarded-Encrypted: i=1; AJvYcCXEx/2Ok3/sHtqvrpg6dEf4Lmc6vCrlLR6lb/yB/i5jP8ksBuP9UZxLA/gWLgOmaFWgXLUXvZ8L0w==@kvack.org
X-Gm-Message-State: AOJu0YyoAZgUcGt8vAPdU5K+M6Wlz2gGgy5VrmnW4bTS5uGlEZ5F0O3q
	t0hCJYqRFJaY2pQQhjHdr+WTMnxhns8T74OYMfEzQvcoBgbIusbUdwYW0Qir/sjB0n9r7oj13Oc
	JvD5W6Cqe54jwiUny5DoTTn/aRYA02EKYIaHuZNT7o6Ykd3pMVg8i
X-Gm-Gg: ASbGncvgLDoJD64WWso3DOqvcLIASwMOzCbad3R7unjvaO8FeLEZMWdyP3hfbmgcLMn
	ZuOrvVbnl38qfoMzovgYrc3VHpp1pVT2Cz2qKz5tzJgqkt5ZoWKOSNFMxYewiKmVwFDbqHhXRrX
	AviYxR5CfbUZwfyNBP6FdAgn422dinuK7Ca91yzBzR+hdT7YX7QWYRhIgmOMpWTKPLh/4fCOVuJ
	AIThAdsLgmffJkOA01lP4eesYqfobAGKnBfcOgknclljw7UCeUN79plL/ZPVJJLU/2Dg1UrAFPU
	qle9tGi1BhBaEBCCjXWzBBAiz/OsEEwR5jYSFs7G/T+loF0YFVVY7RIWvmvqB+URRTar
X-Received: by 2002:a05:600c:4694:b0:459:e35e:a90d with SMTP id 5b1f17b1804b1-45b47a0e791mr281915e9.27.1755631028261;
        Tue, 19 Aug 2025 12:17:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjddPAw0CRkmszGddpAPgfAzfUmfzlD/2TzAmauAHweP2ivGhPJjMh881AW4izELkh6vGHKA==
X-Received: by 2002:a05:600c:4694:b0:459:e35e:a90d with SMTP id 5b1f17b1804b1-45b47a0e791mr281735e9.27.1755631027879;
        Tue, 19 Aug 2025 12:17:07 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a207.dip0.t-ipconnect.de. [87.161.162.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074d43956sm4860751f8f.19.2025.08.19.12.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 12:17:07 -0700 (PDT)
Message-ID: <41f0e713-7f2a-4c31-a48d-50b8d05f40b8@redhat.com>
Date: Tue, 19 Aug 2025 21:17:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: add 'available count' and 'total count' to
 trace_cma_alloc_start
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
References: <20250819134817.247495-1-gxxa03070307@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250819134817.247495-1-gxxa03070307@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Nxlp33-t2POBqBjWdEXRyAn8wjHd2_gJ46_-L9A50do_1755631028
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D57080009
X-Stat-Signature: pz854w3fpij9rbenyi534ygznkhiccf8
X-Rspam-User: 
X-HE-Tag: 1755631031-100544
X-HE-Meta: U2FsdGVkX18eOtV394qfCuDVskkjK4ZYw593Q5WVsapFQWl56vG6TG5kR5LJe1mG8H1sW/NsVL1o6tQ5rYIVuZSnKcwtaJ6/wtKoc73k2wnG4e9TJvaZMHsDB3GRqgL/kivN86DP6D6AKjkC9mQYmnfePkexCYr3Hdv9YF1+VYr0FEt/a8+9YWDRrGaPY1MCk+7vtv5tyC2QtYAzcmyRxX3TD/sd66fu5q1p80izrC3VFBnU4V24/YyPhhx0bsEEY0+BIzbqEy5+YWdjaijyX9vEvE1fmPj8KgaiORCdiZnNJNQQbeFtGHqfs1ndrqJGintDcstNZ+52+170TuvyGkX8LrweQ2upawkHb5s85TzqJpW5EQA1qkE81IwYp+IJCGbYiVm5uTm36CrDckuv32omMGn4y8zhbkqCWRwSWb7r9e9DCohc/6UTGpD2XEfx1MgAnrfEtdoukR6jdoiCyfn8moP8d3uQTwKmGrm3Rh3TCJa/3MO3mcFP/zhf5s9wi+iAs7J7VouQW2oCStwwK9QQQJezaClosDcWCR8pHeT6rm2kBBp1T01deecD4m6ZN0mw6gRWTUWQO4nuyzppQGk7DXRVkJz9EeEATz5JTnINhUfSthH8apmJgF89rzGtfyU6No37rS4JT0MTprVInrWithIGWDdefPgbQjCiIYjTWJJL0VNGElML38b03VdpG3J9xeEu57E8Pjoz8vN0YYTMM4S96Mixadqzei2rGOsZGferUczj7RRwgty5SLswgZfNlybhIBFZoX3lq6/Xng1rO8//kRypgbvCcIVtf+iYN/V/wFew9nJUYpxwf64KV7yjt4TzevVZ7sjj/YrCqPNUKRN46x35cltQeZX8bMcZRltbRJH15TkktPZ9mAwGXnyUMxN+MIMpxihj+Jlypry+S9mAxsS6WkcqOzO6SNp/H1fNJREBgaiNmRMYqZK3r29I0SDHLvEVkMbm/IJ
 1J6+S/yu
 exFtalszLsWkJvyE08VDVDK79xmqd50eaWAzeHdYppo6JOOSH6l768hAN0BJqFLyG/EqtMi5vJLCm1d+rX3gg1ksDVLt0V+ZTzgB3iCI0tTYxyFuvBx03g/VXBDleIz9jWWu1363wecM2sMrQtYzfMCoPj00cTuza6LqwAGRPvuex1qdVy99oCcCJhkMdgiwluTs0WKvWIxpU0ZgTyLESvzdfqk6WeeZzO8L5LvShNl9bfWJAkYrLWZJdScio4lMdzU1fOfExGBjXRZriJ1j7eKMhEMmxU5wvsrM28xdL40BWAenbNQd/DqdR6cyCY8cUTEdzrkZAvHoAJEK2q1S6NCu3K0aYjBndD9T0JfG29jZyOHCPnICzW8kX3Rya8YrqrcIvB0Ru+E637WYg7YXb0uNiJW2yMTxBRG47hGDbww0Q1Dk9HnhJSEvQKbXtFyuT+nvTxM8v3o/nAZlxxPkMRkYGUM0RGOAw0VOh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.08.25 15:48, Xiang Gao wrote:
> From: gaoxiang17 <gaoxiang17@xiaomi.com>
> 
> This makes cma info more intuitive during debugging.
> 
> Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
> ---

For the next time: you should have indicated that this is v2 ([PATCH 
v2]) and briefly described under the "---" the changes between v1 and v2.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


