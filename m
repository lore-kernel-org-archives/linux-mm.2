Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2583CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F41A8E0006; Tue, 19 Aug 2025 03:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB7A8E0002; Tue, 19 Aug 2025 03:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA158E0006; Tue, 19 Aug 2025 03:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C24E8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:22:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF6501173E2
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:22:44 +0000 (UTC)
X-FDA: 83792664648.22.6A728AF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 81D464000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:22:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QleqGxFt;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755588162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qq11idoUrEtRas34sML4LIAF5KXTLr/TpVdlfAMSXiU=;
	b=Pb4btZNWQE2N2GwWeTxOYbRd8ZirutqDZI8wZ4bCi3x57auslj5+Wv2iXD87UjKhaM+P94
	36/uisjOnHUtOdaLnrLiceSPJWuv3NWCXpKxL3rJNZI7dZr2mWgcxQg+pAlT1JZA+Esjwl
	MbLrHFqFGPWnhinyM2Xco/fKE8h8wo8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QleqGxFt;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755588162; a=rsa-sha256;
	cv=none;
	b=H7jpcbw0DizqZW5YNz/dgYaeQiSpneYTfiS0wzZcfVF8XwCsko87hEgHrmtG9amVIg/kzj
	A97UwQwNZVAZDH0YwuGBH8RjI4JcGGSux+iazcga9pWtsP5n9/tOglNnuDhlpqoubohwh2
	g7FZ2LfpaoJcVJe7Lpw3yGG1hLe6YDs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755588161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Qq11idoUrEtRas34sML4LIAF5KXTLr/TpVdlfAMSXiU=;
	b=QleqGxFtHQOpeVuwjz2DgdcXA8+mN+dS16H8fp7BD6/fxbGSok5bzCGe6fUH2SIGzX/Qw4
	MrLTfhtBvJi36L+ETpvTuW/z/6MRdCRFbz/GKV+5E1pnn+Xh3q03ALrfoTaom/aj3XMRGi
	l2PEdwB7TeDfb7e+slwn55/mSjlJt1g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-kcE9N35bOvOpGlKR77ngxA-1; Tue, 19 Aug 2025 03:22:40 -0400
X-MC-Unique: kcE9N35bOvOpGlKR77ngxA-1
X-Mimecast-MFC-AGG-ID: kcE9N35bOvOpGlKR77ngxA_1755588159
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso17594975e9.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755588159; x=1756192959;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qq11idoUrEtRas34sML4LIAF5KXTLr/TpVdlfAMSXiU=;
        b=HgkVkKpJWS5V3dsh6XHoYg19KzAwk5XN+tc2sXBCGpavtokmjL8WpWjOc4H0L70ILm
         8qS0vD7S15BJ+uBDFM5282sRNSWOnFdhg9AEDzgaHVgran7rvRlXwYKT+xKRrVh9l4Pl
         OP7IL6yyjD8K3cgHx5qcIoftKCdPvBDSyiNm7azd8cfgwB7yCegkJ2NZ6Xroo3cIvLpc
         /4HmfyO5Qgkna/bmDfU+VHkOYhKljEndaXbWHt40LUDWkj3MKoJC2rM618eT7hzVFNOs
         fCPH78a9RJ/fqQ7RxGmWvW5z+QXBt2aXHk51Taa7w0i5yzwzHticueTF/AMeH5XZFn8g
         rcRQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0LJsNXOe3VABXVgcBYwwuQTxxXwmI2mw6SMX82GrZZY8lWb6R6C5qRXbTWKkkf8XJrN5tl3PJCA==@kvack.org
X-Gm-Message-State: AOJu0Yy3yxdWH0JzfCMC4lo+PQBTkQSSs/ITrdQlEQNlshHCZaSBvRuj
	qqjb1ZzlQvaC90RUmzOQlvIZ3pbMR4vyArKCsbG/GpU6DZsuVRAxGU2KoDhRO8WLCUHNMl1XTXW
	TN6aRJuqylFr8gJSQJ6mVCquwfaCs9ouy1Dcatcxf3Qvdcxr0BblV
X-Gm-Gg: ASbGncufXrIw/PTZKy94DZWuhWpOoDWrHp5gMT0byu5c4YVZgOwycwmhFBGHtL2juwO
	9WgFp9RaJ6U4mUN26oHsM3b7riimrVLdNWOTKfT4YxjTGr8oM9nzv6NyU2JcC1PSOlgZWyd6Oxu
	S4Iejziaa5ToPzBflk9EwcMjoVMj9EKcB9XnQ7qrg5OYT+iG2NIS0Z2OcgmH12OGCxil0iek2vM
	t331ATV9dwPoNGXIiGjslipm78yPxqrhUceHNMEHO+Lm09fTt3yApmPt7YJWh5JwA68XArMK0VJ
	rn9s1mx7ixITGdMmN0FPtcaMqr4ktH6Z14yvNjwMib4tvn3d0OPQELdbJccdOiSB9TZz54EfmC4
	a14TBQX82810QcPJ+KIcflbPFY4WQp342u2ZZ8wVfO34Kf7i5TAKUyyHuKRdHOB7LzTA=
X-Received: by 2002:a05:600c:45d2:b0:456:19eb:2e09 with SMTP id 5b1f17b1804b1-45b44ed5e18mr3769395e9.8.1755588158993;
        Tue, 19 Aug 2025 00:22:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJIJ7GjSEIbfIOjgirt0dW2oC4TdNAvOum9QL7SYZbXtP3+sR+MrZHQGDCjlim6GzCoEKspg==
X-Received: by 2002:a05:600c:45d2:b0:456:19eb:2e09 with SMTP id 5b1f17b1804b1-45b44ed5e18mr3769095e9.8.1755588158501;
        Tue, 19 Aug 2025 00:22:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:8700:71be:5385:87b8:5a98? (p200300d82f07870071be538587b85a98.dip0.t-ipconnect.de. [2003:d8:2f07:8700:71be:5385:87b8:5a98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c6c324fsm196778995e9.1.2025.08.19.00.22.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 00:22:38 -0700 (PDT)
Message-ID: <a2c15b46-f829-489a-b9fc-cb2f5517736a@redhat.com>
Date: Tue, 19 Aug 2025 09:22:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: add available_count and total count in
 trace_cma_alloc_start
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
References: <20250819032654.4345-1-gxxa03070307@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250819032654.4345-1-gxxa03070307@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I8i4sqsTGLOVfsyd44LrfUm_InwI1XBZutfbtieuCps_1755588159
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: br9abe71k4e5x7utdrhus3yykkrs5kgb
X-Rspam-User: 
X-Rspamd-Queue-Id: 81D464000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755588162-834708
X-HE-Meta: U2FsdGVkX1+N28ybL/813vWUWefUCQNezymCDhrafc7uvNoRV2bowZOuACvU2fzDgInoh2R0nUcOytRJvRm39lBoYL8tfvo+UadvGwPULKhDthEqrXdmbA5uPR9/lVNemkiK07sjREZjoZKZLW2J9SadqE44ch0qhTomWnMOKTKBt3p9w71fMH1fB30FCVbbBuYRk3z+OIojAHux8o2/KQ9sfSg4O8wuKU3nvQoYi0hPCgsdzx7hEbqHzEdejkFNO8RtOta/AdhAkMbh0cHqYortKU//fdmds+e3Vx4XlqBfNCVDFXCBITY+xkn4gdhDv3znZJOUoBX0oLABYWscQAGlUtBFjxExe4nrWHs2We2UtiAcgnjLkLbLXEMu+0K45pTCYqzKrbkvdqPKqeTfdMmntW8/P0IZsKzSLoUwfFfLkO32dl65uB+Axg0yVGq8HmmnaMtYegUIul6SW0Y2C96dDuv8+svo3iXVIwiWdjF4R6UHo7OyVEQ5nBWqHMjz+95TV/1D+Nqw65caaCNLC3eUhQDPrLpwxbOMvX9xtFb7eS6K1hVIo09xayYIg0EGO+V4US1lNsVqfz4xT8CD7Hh8ICNqzCXvD3TUAUL5GYxZW/i19NiXSy1DTsL25Ox03K77sda3eS8MzCNS+gmp9K5Wp6ia5/8Etf0mZrqGMki/eg6nRJcsr12htI3PX8+SZBXb6/dGDm9HklW317ejmHbQoEc9dE4bMrKg/VREmq3cOdiMihbTVFm2CwWMl/3d1DDcYrfJIfUI95VH0x5CtEATgKafaA40rW+uGmEq1Cw/gcQZOaoaV9GNQyQb9SmOzbTp0kSKPnfYI5oaRAlvdywWrbTXll7t93XLjAtsIBJTLJoLg+LDDMZGkPoImoMbyH5rZ/AeWWL6sxIiS/0uF42dKTL955zLX+9Q5i+4Yjfa/IlCZjK5nj4tjeN4nbYEim+YDoIiE97O4xjItP6
 7NAsZRP2
 zI+fAt7vp1mxtoe2a4XxM4aLWQ7z3Dg0wX3d76v2qAjTY4z2XaWUh5zQCrhUxNcnyBN5n2jungdesCJx1rNGC5NTYN6ltnF4bL9tUuCREEdjPWZlAfDtKwry8yU5ftXVGZLTvYkDzCuTbLT0vTtlehOT+7+vuJxGumi5o8BPv0t9oV9C2wFpwEnQHshUE+pgTU2OtyP/TubQfzwU89xphEGLRu8MxxH0QhHOSH3VAAHSo2TTn1o5ZfFq4A4IZA4SI3C+LLbwZEc8cd4ckTN2bQfDyKnm3iPZHZvRgLvcylcN5YWQCnGumvJEuw6gzAKpvmS31K1maoiziu8476DlTI84+yhhG3Ut5bih1xM3atYA2Ibmd9Y5cnNm+57z+SI88R4pgHnKh79Y/0pB7BY65sKLG3h3F98R9r4BQ5asqKHVvL28rF8fvnEFXrSeJA1vzMdmBQw/Vni90SqoNZ4hu3ymvwng/8phnHtECLAU7Ve5pbgyW3+65XOTl1EuCYHxyIRem
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.08.25 05:26, Xiang Gao wrote:
> From: gaoxiang17 <gaoxiang17@xiaomi.com>

Nit regarding subject:

"mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start"

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


