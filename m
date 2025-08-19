Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91DDCA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438EB8E0018; Tue, 19 Aug 2025 03:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8898E0002; Tue, 19 Aug 2025 03:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B09A8E0018; Tue, 19 Aug 2025 03:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 150F68E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:26:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACDE282B75
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:26:02 +0000 (UTC)
X-FDA: 83792672964.29.EFD27C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 491C04000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:26:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AL4c7w4Q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755588360; a=rsa-sha256;
	cv=none;
	b=3tykF7OmizY9GFguZkFsVVSE8LgKPozIWfbUJFv3QW2+jrSAzC0RaMj+KgNjUMhbNzLZ94
	VIxHyUbLUJeSMF1lMU+tq/EyE63zNI3LvTmCYMTwA017nfrl45x+U9v7cWhz7jhL8Gc4oM
	bo2/4lTlXxwZkUrKw91pWLaobEOQunM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AL4c7w4Q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755588360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHfqlcSubeJn7/W38DDDWlN7ObnUVNPyWAs05D4g68c=;
	b=LCZg+PU5pQ4cFllyXhhhlLvPyhGin9U2UXkHojom0S0at3wmF2+fCpR1H+mLXliD73hwYW
	dJUqCt6SiecJ0BdxmgZ1VSy5xpl7MHsGj8VJs+b73jRzRCEC3WMGAduo89hDdeqvDGw8NA
	0uHnh4Lq2WnGBOm2XdAmqT3oWayGX8A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755588359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jHfqlcSubeJn7/W38DDDWlN7ObnUVNPyWAs05D4g68c=;
	b=AL4c7w4QtYTvwlDhWWufI6erZxjfg/eU+tmqeHdq8VGHYYhGM1qH8D3VbfyZ8birZYmZb9
	hD55r19tXHNs2TdTE7MeaD+aGjttu9q2WKI9+ATZYazgENvrtJlYLt4DSF2xKgpfSgNB+m
	i4G/Hlhhc5EgXOn33oZg5xqwRTBqC48=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-nfIvxQGlNVuDQ96o7p86mw-1; Tue, 19 Aug 2025 03:25:58 -0400
X-MC-Unique: nfIvxQGlNVuDQ96o7p86mw-1
X-Mimecast-MFC-AGG-ID: nfIvxQGlNVuDQ96o7p86mw_1755588357
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1ad21752so21310805e9.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:25:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755588357; x=1756193157;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jHfqlcSubeJn7/W38DDDWlN7ObnUVNPyWAs05D4g68c=;
        b=NsJ5301IdVeM8615BK1NU5qmhqtOV3NgSJH15iVuPuPZyCnPvo7Ge+7i/UxXhwtx/X
         OLnkKuWRuyXZ9XsbgGnam0C6Rw1r6DGkli3bT/qpbsX+0bd1w0llOvg42iP/E42isFXL
         2ayHOCu+1ymF+2eOLP56aNoSM/9B3jt5orWqC1Z23teJd9bw2cLi6nVJErJSC7IdL/VS
         dFe66EETDWAi7Y9cLaYJlUJG5rQd/Jmhym3QURA5ZAINP50y70tRmuCYva5sCe+2gzUQ
         u4JEjdJJzVXMoA5F1ah8LBIR2v32leh2ziQtvS+Wleh9g/+AnrL+NEi9rmTUhLf/6isE
         Nd8g==
X-Forwarded-Encrypted: i=1; AJvYcCXsrIn1TValQg5P3FIBsjRSng0COOXSSCvnw7SfsQ3a9YZoxquP4ZAAr//jSGituE9P/4GKJc+7Cg==@kvack.org
X-Gm-Message-State: AOJu0Yx8TLKCiYRnwKgpqt5rIw1NEw5kAlvQfgd/FuRF+rI6EESjrz33
	gXr6fnGWDfzqI5j6L6l4qdcfLcBkk4/Vu3jnOJV0xiMdmAmneZMZwn3vD/33q//pbJIybZ4iM1w
	sY+bxDU58k+ZXlo5dxHkdkgrqHPKWF/nMmT95Wangp5HnXgMx1j3l
X-Gm-Gg: ASbGncviAjupCT1eCUtD26R0ge4GHaVNUqUkMaI/oE399XCunhOhtwH5Szli41ygrim
	Hw+Z6RXdJM/EHrKTt54EKl0UEjP06cKXMP7TXRhSBrHaynLkyldbgnrstVrzX9/S44z2OR7xZ0r
	m4mW6qwfzH6ZgkG7zJPi6/OFgtkMB8AY+0R+2/+36CCgnVTDhszlPZA0eip7/r5RKvcIP8K6PGL
	v8roGQgnaG08Fz8YdbPaypcI6lQdXnjDPOUMXh290+Z31vA8j1rQ0Ub5akbq0W07QCWjhwn/MFk
	dAFsDJsPjwcF7go2KvPXLNR/yQPI7Y3jhSyD0vsgXM1imholvYceAxh0zkJbA+9rUZA54yhJWUY
	GVic4GoXhsQQkihNdKCEeO/RpNcs7PD89/0Pe8LBUfrZuLxyUSxUQgP9jqDcd5YEcmz4=
X-Received: by 2002:a05:600c:358f:b0:456:1157:59ac with SMTP id 5b1f17b1804b1-45b43f77da0mr10625565e9.7.1755588356742;
        Tue, 19 Aug 2025 00:25:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiCUhqGQNn0Jp/QYUQ0I6wiZbOyiVGMzK7ZWG8eNWkfWyIP3UZUKCKLtKKgTXe7raIvIZrIQ==
X-Received: by 2002:a05:600c:358f:b0:456:1157:59ac with SMTP id 5b1f17b1804b1-45b43f77da0mr10625195e9.7.1755588356252;
        Tue, 19 Aug 2025 00:25:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:8700:71be:5385:87b8:5a98? (p200300d82f07870071be538587b85a98.dip0.t-ipconnect.de. [2003:d8:2f07:8700:71be:5385:87b8:5a98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a24e5562csm146699305e9.20.2025.08.19.00.25.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 00:25:55 -0700 (PDT)
Message-ID: <8142d36d-2a0e-476c-8250-1a69c1f92913@redhat.com>
Date: Tue, 19 Aug 2025 09:25:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Fixup PATCH] mm/selftests: Fix formattig in split_huge_page_test
To: Aboorva Devarajan <aboorvad@linux.ibm.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, shuah@kernel.org,
 pfalcato@suse.de, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 donettom@linux.ibm.com, ritesh.list@gmail.com
References: <20250816040113.760010-5-aboorvad@linux.ibm.com>
 <20250819041239.167537-1-aboorvad@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250819041239.167537-1-aboorvad@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p2xmDQXQRLU0zZGognhsb--TgwZM7nITf89ok-z-qjg_1755588357
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 491C04000A
X-Stat-Signature: gezxnu6smi1xmgwtu5bfcetbb1bmhpi3
X-HE-Tag: 1755588360-108648
X-HE-Meta: U2FsdGVkX1+5vEZyoYEKYjMosBKB6EimJHNJ8AMNLCmXJW0EYFbCAedSttvujjnCawnIKwsWx8DdrUW3H/RQd/OIgqYUwb3X52oGDFaOUhVx9SDwKwlzjYNLd66NWBqcoe3YxAB3qh6mHDDB+1E45KXJrXrXL/YqKfTW9vX9Ten1rC3jZ+CQaWSrngS6k4jJSzNeDDUOm+bQHZLT8wm1ZPrr0KzYBDyrL7NWfAcwuF0HWKzoMDZCVOWe9B7eLMyCOB8M5ArWeqz+pVMmCLyduEB/nUht4QjlOtpmdVPmOXffdwi9XOc0fQdRfGcWiRJWLcZ8O7fBzoBtvjQ5cwET4Y0k71zzyYq3tV5iJ7OpyM+7E3xSAPiWgZLDgGOqgfDAzMUVfxU9EQQcgezFul5FOYxluy63nYZ8wP+j2WDkRYHdYBIPrGe7AQ/xxMLpM+nqol63Ke8a45yI2GJjf4l8ofP0U0Kq+shCR7xkRPi9Nyp4oWD/YSt2DvCbZp/UYdLUufk8A0LRC/Gx1dEOvWPnRjK3JNru9LIgRbaZQmNe5DX40cnx21Ed2nVURiaW88hif0487TtQadw3PZL+fl8chpmQ7hrbAQnXxDF6/c/TR8wX54T0amroWcnkzFRLJl3e5MN0nxza4yTk1CvfD8Gk5hrPfPXEmyCxhYIfezTrbf0CBVYHMhP4+v7tRh2IpXh7S5sRBuCi7CIzgs6LOFFLlHpeJ4p39tQZfHl43U/ElEtsw/l9CiQES/5bOFw2b2AQJJ1M6iEOMXY2PUi4y53VhV70ESy1uBP8nC2hcgZcdKR/CWQRT/WEixBbQiLlzX9tzkxh/n2xvsVnm6wl6Cd4OvechdA8XU+F3VKTqvhgiAaIgRnLKKV60HKpRnLVts8iq7d3moEdLDr0r1lsrFhQIqiKoNyPE7nYtlNizmbJ0JZDnC2Wf3LzSKSOpMTvW77Ywt5nexUMwB1+JssXf8Y
 P2IA/V+N
 xdW1FblwoIFnDQK4FwM7358g8RAmxrDl6lsomgxnraT6gVaL74j8zWPTSEmfxGoShNodVz+SSLooBhmmu7nbs+OQOYjUfD6oqzg2SxHOwu+2ynegzVSPdFDPkrPE7+mMTYUmVCrgxbvIpPJCtB7AJGOUbOfB3uTkGhirCMNII4o9rucP5Q28CEJzW1Jz1P5D4Nd/WnaLCTAvGOH4n7bSnSjhoq+zs/zGVsrvTRgiRG3fGsTPh2hPlXG25JIYJdIGE3GFE4PaQpkvvA6TcaSlYffOE1z5zZCRvFuHkJLPHoSQEj6bgzrV/Tpdmeuk0iYenkpzZ/dGYXE7es+mTwuaE90/sFaoYXRbWbpTWB1bqwWzdMN4HGcz7HBxTd8cyYg+mh7K1M4H6o73DFVC1Sxfc3M3CYsOwz++kyMf/lUCokLV/Zry1C9bEv/kjR/8UNK5xJT2f058qH9d8D42nV3IeqQtQLdWI3uraTsz5WfCGSa9pdKTkWh29DJN+iES4ke3Ohvg9Hkrpn/hvs9Cd+p9V0+59WZLySny5oLe/5JlmhkDJxxs6/LhKnt5KWxTo7v9zNxb6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.08.25 06:12, Aboorva Devarajan wrote:
> Removed an extra space in split_huge_page_test that was introduced
> by commit 4b76e221794b ("mm/selftests: fix split_huge_page_test
> failure on systems with 64KB page size").
> 
> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> ---
>   tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 54e86f00aabc..faf7e1f88743 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -544,7 +544,7 @@ int main(int argc, char **argv)
>   		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>   
>   	nr_pages = pmd_pagesize / pagesize;
> -	max_order =  sz2ord(pmd_pagesize, pagesize);
> +	max_order = sz2ord(pmd_pagesize, pagesize);
>   	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
>   	ksft_set_plan(tests);
>   

Please just comment next time one the respective patch as review comment.

-- 
Cheers

David / dhildenb


