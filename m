Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84678CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246B6900242; Fri, 15 Aug 2025 05:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6D88E0002; Fri, 15 Aug 2025 05:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5E5900242; Fri, 15 Aug 2025 05:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F03458E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:29:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 655DF1408DB
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:29:23 +0000 (UTC)
X-FDA: 83778468606.25.82D9389
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 62FCD180003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:29:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F5hWcF/8";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755250161; a=rsa-sha256;
	cv=none;
	b=2aMEIa2qXDMwon9W9uCHmN/FDA8dGZBSO9kx9laCQdIZ485GPA97MUxg4+hx6SZGAXZnG0
	nzjeGWwOcWJokdC89CbLMc+1em6fbs6YUx1zJwG3vgntLwL/QIu/RT9NhGCSfGUrFdz0jG
	LIQE1rZsedrNM2x0Yb+0rU6vn1dDB5U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F5hWcF/8";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755250161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZwWnSoQZBxGDEvy7LeuiGeEs7NklIXZHoSKPGcGLlO4=;
	b=sechCV1u0LjZeiTuH0gT1lGCY5eJhCEJN3SgdXTj+puCOUXOTkl+Q8uGot4BbDqrnHiwUS
	2XtOgc+7erkAyx8OJU6mBaZJdACg1BNzQH2TkVSS6gS3bT8/XRzV6+vnfHVCQzX0MpxqpZ
	i5TkpeTILZCozh6hOhXlFttfuVOGy8U=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45a1abf5466so10064015e9.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755250160; x=1755854960; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZwWnSoQZBxGDEvy7LeuiGeEs7NklIXZHoSKPGcGLlO4=;
        b=F5hWcF/8vLtEB9aavzvsYwA5Z+yTV7sX3hOph9cI7id3Xb7VAwHVxhUa5MDk68R3yU
         f2lKob2FtRrLOiPVFvIqRwW8cKg9JH4lQsGza5i8BByd/QRK8UtkhY2Z6SBBMyVMbB1Z
         0/Lk6G8c7CfNSPYQoV1en8zdJgSSKCZovJaQzI2FeTeeET2JvWjL2R+AuPLGwDYqbZVa
         bmt6RJ4Vv1DYVULEdFzZYCrEM8kS4I6tkoox0m26J8D4kG63pScvRLtgOo1TZ13qTS95
         6JlyaStllAir8jAnSs+fPIVWyDm9gVI06bhAgYPzxNEgvarwy4AyX94ru5/56kfmwSBc
         Qvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755250160; x=1755854960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwWnSoQZBxGDEvy7LeuiGeEs7NklIXZHoSKPGcGLlO4=;
        b=TydG7Snv3tjKPvc6MGnyuhPYmQ1wBPykCxk82zgzvcCtxsS5PZzMk/juUYb3mswXlW
         tyIrxOFplotVPUDNYaTshugkRbOAxDA3GO6b/U5Mh4A1iqJcLIbLfggag/bZsntT8n7y
         L6Dok911vuvy3Lw2fkEvWvRp7ANCsJB0VX6hG8ZT/lsNPbxeLQu3FwSy92npk6cSm5Fe
         DV5GgxEonP6qN2ucn2ObJp9+lF0PS2j+LNFljqJhRZ8gsGU0HXlfQv0BDAUShTgvcpbp
         DDr8wY3ZVBOJYPFmnf/GbtmEL70bgCyRNy1ShZg8/jPKW2Yf09eiaIXdfyAlzOJboNOE
         zXyg==
X-Forwarded-Encrypted: i=1; AJvYcCXnlEpHyhkTKOON4ZOqyitNClTBBpSVlc6QI6lK90cqouV1cklhf/jTBAGx3MmkstWgkWhhOyGAUQ==@kvack.org
X-Gm-Message-State: AOJu0Yy65eREGN2O5770eHtzb8Znv5Jjdm9jjxJOo5cbylDJK7RWKG7P
	5+x2HbpP5zyxndqZ6H36eUzF770NMmJY6EIUI6LwSmLmGd/9oVO3yg4d
X-Gm-Gg: ASbGncvTJdBRMzDXzBoexDfDnWS0WgxNVipR5kiGwefRAeuMi266+Jl3CxG3NaSYR+Z
	AqUzX2+QCfYxpIwPywP+xP2aqtkBjRq04ffrHX0xK5CBkaM35yzXXU1j7HyJLyoKDEixZm3DHw2
	fz/do5xzhvlIxtXY7tRWcDQGFHORQ+n6vmKuKoZo1oZSSX/pnZQjhvFG6CcHF/J7SzYpwxY5eyg
	+PEhfjFC0iRaw4bWR9QL2qN1ztWaq96UXcDbahvPOek+8Aer0Ao8mtYcqWyu1Kmxv3x6rcT2Xh6
	WtjbNR9UO6qVxJedFdL16LYK2p7Da7N1Ph4eTIJkQOFI+xdT2+r9dbZMi+TAPT8/owcIgLd/B7u
	ZACCy+9ZTT3lR6FHQejWl01aKsxF49Efv3shnLGEYjoJv2AQbZo8LwXsO9BMkrlwgjH1+EjzJXj
	O07N2CffwEkw==
X-Google-Smtp-Source: AGHT+IF+kyfLy/7halE6ohPvWdKODLSTE3Iw+QGXQQKUCPSBld9coa2uwxZQM6hjpcHr1YUXB6hPCA==
X-Received: by 2002:a05:600c:c8a:b0:459:d9d5:7f2b with SMTP id 5b1f17b1804b1-45a21868766mr14961525e9.16.1755250159582;
        Fri, 15 Aug 2025 02:29:19 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb68079336sm1217362f8f.53.2025.08.15.02.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 02:29:18 -0700 (PDT)
Message-ID: <cb94236f-e5eb-4f74-be3f-3f3fcaecfdcd@gmail.com>
Date: Fri, 15 Aug 2025 10:29:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] mm/huge_memory: convert "tva_flags" to "enum
 tva_type"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, david@redhat.com, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-3-usamaarif642@gmail.com>
 <CALOAHbAe9Rbb2iC3Vnw29jxHEQiWA83jw72fb_CQKGDFHv6+FQ@mail.gmail.com>
 <c8a47a7d-3810-426f-a2cf-7c020ce25c7d@gmail.com>
 <20250814181101.9e15c8c0202face2230ad1fb@linux-foundation.org>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250814181101.9e15c8c0202face2230ad1fb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 62FCD180003
X-Stat-Signature: mq3t7sd4ckr9qdhqhsyocozx5kqsfpof
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755250161-825824
X-HE-Meta: U2FsdGVkX1/sY5eHy8sNKSmkq6kZGv/R7S5vAdEj4tTi+/Xlq3o3tT2KGoaWiF06TLSWl2NsmblmRMXSoT5TGNYgKeNz+voNnL/JWPVRFw4pJLdJPe7x0QMabwvwM5UdEkRvwHLSkFqKc+jxUrdNLjOsPCd3+9p1xkARjcLunF0aI0hgKNM4aeThU+NMG2M65jMNv9IW/X1Bq9Uh8yM5/yd6Px2L5/EVBLhLams3jGlGc5KC35q5YhRvPV4JelcJJNXAM3imGF75vlQePZzVvnAzx+YKQBXvpeLeXqDNoNf6+NzEodxV6KQ98TLCPfVNUJddQytlZr5sL7rV4HT9+QAd7rjFVmi9YDoxjyJPeMr6U2SLjGnNvvYRqwAtStSITOqtwD7Rp21xJtdNmRtNXKVnoR0sBTyOi8NygAB0FNIjASQ7khBsat2WkXPm2/5qS7FxzibCPMw72KFgCfXt4PxBDDho+Kmtod8A4CPCH/1y7GwmMsbW1zaAznWACpjZbEVrAtstTNMJBwQTbrizazKrgutSz+ViBuUyjOLeK9rdSlAdtogaSDBmktrZWPdG7Gnnt/UJRx8wQVYU2WMNd65wlDHhXqTsqv9kwdxxMRXVt9JFqKwOs8MUb4lJlJXhs1oaFZeKGil5aUtWYoXs/itwng65XlwAHokgr37CzXo4WHmiTbd5R911F/hAooUb+wP7I1eitZPDUWB7+1QP5gOFYKTLyKoVnkq5aY5hHZq4Rid0kjK1oJRSjoBG+tX+7SNahyXIoY2wz3nUrvEV/jpZBYQUJD5QnYDl4ykngY/KMcm0gTWa/hRC1OGBeERWN7sCeoFSS5woPQ2E1uIeCy1DVZCKj84Xq8Y70qr1oCze1bujHkmDQCqVK3BpulC+V4Ds0+nWvlNTuSZtyHAn0WYY8ourK2nR1TWXBZDaY7q1qYB1+q3xlwNhCokRrmjfHDDXV3sHp4GgqFyzr39
 PKShR/vC
 vcVKdW3XGsDV+3IZodRF2oyhOV/pj9nRD2laA3Z63fGSsiuspg0cLvo6IM8TRWAEJnc7rwTPS6WMPjM9Etfzmdbh3O1YRlXwxZC9K6sOkjqzhr+YRs1uN0IGU+4GQbeUQjbpHGSL+L5VvJ+iQKrKgyxUzWrCVSzt/Zxpsrg5iQK5ZaZhXP806mb+jAsFCfAUhGqguiOywp1+bQue/+mVPiEZlp+b+fPDTITS/3Q67Ls+FA85OcpJjj56i2mtAdrDUdxQdROKRBIbllXQbEX6RRlNvvt3qRmzmPKyN6YkzSSglM41qi4Lg6T9gOTT3LzFHtI374OVNV3WKG6BYzqCQOiQFnA1jysuX12xg2kIdF6YhNYbA0IUbJ8O9LZu2UoZGS8cldUiwWGI5zgfgVixC50d68xfxp0nkJCUQfc945/h6zPrlbgTW4iLSMd+KTv05lm/QPm34EzoaU5m4QZK5ix76ZXbR3CZ1tRmjgZP9gkLtsPGfKaN1ky4Xo0tMPzpW6UX2Ynpt7xnw7ZWHzJ+3zNJpvBaY901EsDottvqHhxsgiMLRmEt8NJVWpH0rxSk18FtYIE8pcvWhNPxyGoQohdB8gj4BqhY6mw/YANOtf9ObJp7Ax48Mzt3grvyKy2Dq0aUH8LkEjB7XDRbXI/azT+bD7N7Px+qdUMFn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/08/2025 02:11, Andrew Morton wrote:
> On Thu, 14 Aug 2025 11:43:16 +0100 Usama Arif <usamaarif642@gmail.com> wrote:
> 
>>
>>
>>> Hello Usama,
>>>
>>> This change is also required by my BPF-based THP order selection
>>> series [0]. Since this patch appears to be independent of the series,
>>> could we merge it first into mm-new or mm-everything if the series
>>> itself won't be merged shortly?
>>>
>>> Link: https://lwn.net/Articles/1031829/ [0]
>>>
>>
>> Thanks for reviewing!
>>
>> All of the patches in the series have several acks/reviews. Only a small change
>> might be required in selftest, so hopefully the next revision is the last one.
>>
>> Andrew - would it be ok to start including this entire series in the mm-new now?
>>
> 
> https://lkml.kernel.org/r/0879b2c9-3088-4f92-8d73-666493ec783a@gmail.com
> led me to expect a v5 series?

yes, small changes changes needed, was thinking of doing fixlet but will send
v5 for it. Thanks!

