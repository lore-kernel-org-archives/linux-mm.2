Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D04CCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4688E0005; Tue,  2 Sep 2025 06:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C278E0001; Tue,  2 Sep 2025 06:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68ADA8E0005; Tue,  2 Sep 2025 06:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55CFD8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:21:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F31CC5CDF6
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:21:04 +0000 (UTC)
X-FDA: 83843917248.08.2D48F79
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78724120006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:21:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T3Wf+yRT;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756808462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9qIySCE7Ux2ipEebq38nCfiWFRGG96PftTSkzMOExs=;
	b=NMtATFJ8bNzJCfA3J5v3Lv1IUymzl8yuk2aZJSUuS2wxo8cgDeyu2wyT03FR474bQjpx3D
	6s7zUjOb5QiL0WZSIvH4gyikfiqeZJuzZBVk2C1ninU8tr1dnS2AK//atUJNwye4nH/9k9
	B5Xa4EAp212/IXfJxZtm1shXSA6QrT8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T3Wf+yRT;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756808462; a=rsa-sha256;
	cv=none;
	b=ku/zUDf8rwRzOu7ysCZqPMtGtBY7glyues0i2ripTlXtoPYu9harYLHAKXgNVOuP7Aj3Nh
	M4jTPRkKVITrlPmmGBYIiKSJ9WTC7UZ9mWh2iji0/TFFXDsHDV07CS76i1L2a9/iT5rzu1
	1IyI5oZnSbKsMJ3zbhqfcc3PS7bwlfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756808461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=d9qIySCE7Ux2ipEebq38nCfiWFRGG96PftTSkzMOExs=;
	b=T3Wf+yRTbT985jJYm05H027oU7xIzOfM4WrZIOD+xlnv/TVr/qdEEmX3cxLTbV5RsNAxUp
	YNqEZvobA2qxU2XH6UOYCZqd6kAbAr98gfseS7+Bs67WWBaLEu1fVQQwhMiu2v58J+QRJ/
	hp6Xd6z2Ssb2Ws1xzxOTPFW+Q8le7sw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-dlvNNBWyM3CplwVJ5rzl-w-1; Tue, 02 Sep 2025 06:21:00 -0400
X-MC-Unique: dlvNNBWyM3CplwVJ5rzl-w-1
X-Mimecast-MFC-AGG-ID: dlvNNBWyM3CplwVJ5rzl-w_1756808460
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b9635bcc7so3531435e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 03:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756808459; x=1757413259;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d9qIySCE7Ux2ipEebq38nCfiWFRGG96PftTSkzMOExs=;
        b=IwgzaSyTICs987Zs32o2p1UrpMSUZMD8eD7Q9AJrbzceaCyDq5tnHCcW7NVDzHODQ6
         8R+Wv5gOpsjMm3SJNVyG5F94WWl69ViDiinnaRe/po5OH6V1H2vL0gxzpKPlJBFn90S9
         mVR5KG5s8eATej7xQ9ZcE1VAqqjPUR7Jv0O35dIEs/J62lf8FhxXCwLqrL7IwNSG6kI0
         bNQe/7Vz69DOGwFnzCLBMNQx2gt6iRV4eZqyjZGxeOMQTcm1bqr/KIzrgtq2P36yXlSS
         FWlBAlEmjgpjxGvirEgIxFUTWIcMoIiXkhvfjdLXot5pGA7AgOGg1pHWR1dqVIe5/3kL
         8AXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwImpKGIOCcauunSyhi7x1/bgTL005AbKwgCPYoSlNl3XFVpBNr4M4xYRK1W5Jy2o/fDNW6QorjQ==@kvack.org
X-Gm-Message-State: AOJu0YxHt2D6huJY/hNg0dbcmmqZFex6f3UXgIVhHl6rtOQuj5urgIA2
	/ewK2F4mRG/j8lEhP7hA+ZBg7+FcgDbc0VuUzh1WJP0Yt5SACBB5yM62rw3VPVkgF+MxHyrBT+D
	XKSCWYxaj4N+yhTDPm3E/pArmbgPxTZH3DNjKdZUTr+XvQGVJG5pr
X-Gm-Gg: ASbGnctZ21HxlBF0Fb8h7LuOida97kytjl9oe/WhJg5cepth+eoFwggqlXTucjJvgJ1
	drC1hwhuF/GJ1JkUuUbtBwHTJpNDTCOGxlFjXAWKGy2p/O7Q6wjS8zari91SCjmYG0oYh/PvQz4
	v3UApmCMoX3bqDgS+YRTUpLpn1+ONUkxn2QeXYCcPa1gyv4OzIdvChs1CUtd+MQyQrS/tg84fbB
	J9DENVQl8JuoC4Kpp/HCt50ohhcJ8ZGA8pJ5IqXjjLmvtJNOttSb2K/DcPQqlPr7zqlih5a4xl7
	B95TOjvT22IklUKwRKR3dUIOYW9Mn9jUQkUJZogOHXSY81gJ1l+fDUDbBItxU88M5lwAJBGKoMt
	NyPVkTPhHLPtgioIKkUVhujEdZHHLmlQUboruqf/bJ6Gk1g6Hv+ddwPEv50vMzVqa3ts=
X-Received: by 2002:a05:600c:524b:b0:45b:8482:b9b9 with SMTP id 5b1f17b1804b1-45b85e429f4mr92046505e9.35.1756808459491;
        Tue, 02 Sep 2025 03:20:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrbdi+SLi7paUDVyuKl1DBRfmshZxP1c1y9/M75LD+3bSDY+4Id+uLzePCwr0Ba3fLwGatbg==
X-Received: by 2002:a05:600c:524b:b0:45b:8482:b9b9 with SMTP id 5b1f17b1804b1-45b85e429f4mr92046165e9.35.1756808459039;
        Tue, 02 Sep 2025 03:20:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f30fe02sm267724975e9.18.2025.09.02.03.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 03:20:58 -0700 (PDT)
Message-ID: <ed486d6d-1664-43b6-9d5c-696305f833b1@redhat.com>
Date: Tue, 2 Sep 2025 12:20:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] mm, swap: rename and move some swap cluster
 definition and helpers
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
 <20250822192023.13477-4-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822192023.13477-4-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OJbhfUp4c5T32DvxE4QeO5umKQYo3S4i3u_8UaIDAPo_1756808460
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ft3y18byh39aa57qstrokasuag1b9d87
X-Rspam-User: 
X-Rspamd-Queue-Id: 78724120006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756808462-87534
X-HE-Meta: U2FsdGVkX1+xXgtX407qUKjKdX6yd1fjVEO0ekeLjTkqctSlCjGkH41eE0Xbjg8zAaprxjiFQIyFoQLMqJSg3DCD/QfCU5A44dGsnLImjhUlvfdWOuhw/gEhy7fo0dLC7SMC0ZegEhjpd0EaYUfRc7wmjZzm+n+QxZlaZqA7wlH8xNFvYtuuTha23FnWGblv+Z4UvnpaOoI5EU49Fn8VxRzdn06YQGv8Uvy7++UQVGLrp0+r0v87ckGU8lO8tpHMOsuMn/l3A6+jd2+kpmoDVu0DTXutGocp1Vo5alKfO/KlZW5UPGBK4hiuEx3DREuq59i10q27wDlKcVtiXRRJho+zKKH5wMoag8MTC6uoPAWFzxiiaALhEQUxJr00C97Vsz6oNfzBZIV2mSLo0A2BX/G4ICmZxYKJbOAeBVmExuNw4jUGvbr3p+t3qVnmpbhMKp2YZ9cIIqifdj/Rsmi+HUqVPjvNJlQIlYDQj4qVcHUpGApj3M/bDgNAPDTsM30AOrSJYdivVGqYtSERupzdWzJEeu8WMmi5XR2+S+GsWqB63egJoej7VYzlcDTXaAZMdZZpt50ja7mdcKg9P4Dta4+qBdQwyBxg3cMrMSKgN3UXFrH2/wwIdqLJjgu2MwJZYqN1FdaOGagXzbyib8hRLluefpXQ4LliSxoPolBbO3GkULh0ooJT/nbBYYXzL/xuHZCW25+bsiLQl2aQGpwDfOWzdzGHhx1iwWkpYl4vwH2jt7UU//RIDCcH3W2WxftVnbMnmhwdUiBQVl1aWr1u3o8CpYFSlHtzRDSh0o0TcCimJJtD8/Q7t5I063eXBkeNYVjM1+5+5F17aC7p4+Ue2WpDzFd+sUgBjTHCmAi29BXSxaqkb/gF8VFjsJfIj9M43nC3YNqz4bCQ3xMUdoaHxqNP8iysqNj8Bnzy4vt9qdJMg+Si0P0SxWaMmwJ4cWgFlxUAaEKFTowCtFFot92
 5ge6jxBe
 oFEsx0ERoONKE/HoEqpxiL53YV9I6g4EhbdDOajDnu4Dj8VFuAw7/yQAtmGSHT3rjmNxirzoZTyigBd9pnlWgvmsJX7riV1100/HB+lQO93b0xMwzOLPDIpiPGPJ0kzTGqOLXBJttEWCDsktgR2sOmrEGlwXWQYInG/NB0Fkc40VW3fzyH/Y/b9gG6vwZQVLz6OUOlU3mYi/hVEbTfqOk1LkURtxpV+VMfRbtgFCQOwGz+30zXa5dR6/jGGZnc0xVn88xgVVuxYMnthNLZKjk7eRajOVN0oPD23ak5llQC4yYMHKAEJBb29df8LC4OL/DFp9gB/eYGCvmkJgFmttzIYDXq0GZ36ITeZ0nAD1PwWy9fqPa+P2a5wcq/SyEIJz3bUwrIP0stiZN0BQjEnz/WrlGg9qLE6Fh2EkHT6DkivGCEcjqGjnD8aUi6LruBDXR0VpO
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
> No feature change, move cluster related definitions and helpers to
> mm/swap.h, also tidy up and add a "swap_" prefix for cluster lock/unlock
> helpers, so they can be used outside of swap files.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

[...]

>   
> -#ifdef CONFIG_THP_SWAP
> -#define SWAPFILE_CLUSTER	HPAGE_PMD_NR
> -
> -#define swap_entry_order(order)	(order)
> -#else
> -#define SWAPFILE_CLUSTER	256
> -
> -/*
> - * Define swap_entry_order() as constant to let compiler to optimize
> - * out some code if !CONFIG_THP_SWAP
> - */
> -#define swap_entry_order(order)	0
> -#endif
> -#define LATENCY_LIMIT		256
> +#define LATENCY_LIMIT 256

No need to touch that line IMHO.


I enjoy the new function names.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


