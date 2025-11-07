Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF92CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 01:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88FD28E0008; Thu,  6 Nov 2025 20:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8675F8E0002; Thu,  6 Nov 2025 20:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CE08E0008; Thu,  6 Nov 2025 20:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 674438E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:17:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 184E558581
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:17:27 +0000 (UTC)
X-FDA: 84082048134.13.827DAB9
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06A9010000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:17:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="i4TuV3G/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762478245;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmWBxSn6CHjROvjdMq4Lw6nw/zAAMYc/Nhqo1NoydhA=;
	b=RjeElc2hhxAylTYKwPfIdwgpqZ/k8HzUgKC5TONXCzUm3wUs23JMDCvJcqG86QaxqktJ7w
	cVOYUBmjZok2Gp5P7RThcXNvvXJU4UGF0Iw9lJOUPb/E4eujRRExjhuj5i+oAKXEcTrLOp
	Lb2x5kfd2yWXxxDljUL5yAez+5f+9g0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762478245; a=rsa-sha256;
	cv=none;
	b=1zqDZVY4zDtFHpjgn0O7ceEBSyk2NEVqDdhwtab66r27BtZVFIE9peTqtTmIta+GOCZscr
	WJRtCuSRiID5mIhBVok5MGt8kFA+I5TTC4OZmClN+Vhy/aeCMPFj0eO8W9hlTxhDPgzutl
	oYGPuKYlfYxPnPZj6imQfUhcagy6ph0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="i4TuV3G/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b72bf7e703fso39239766b.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 17:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762478243; x=1763083043; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmWBxSn6CHjROvjdMq4Lw6nw/zAAMYc/Nhqo1NoydhA=;
        b=i4TuV3G/GNEDjHlZkO62OvebqRjaCk9120pGfMfgRRaf/skqtix1BwlPWcOd/ys3rE
         V3D8M8i+zHaKHQwJtzWY3ypE8/8BFdJ6XSAB+CkflVBpTT/Gci0yuhGSl4GRl+hJHvU7
         fPGt6gpv2w4B/Z8SHFBzeLv/4IF/sYLlxJKGbcPH8N/S8jlZJxLyVVKYCHHlMkcO6LTC
         L0Sknn6BVll1pSTguXAf8Cb2P06H15MpOw5I2ql5x+Ddee4uvw5FDq5el3bK9SF7+cNV
         DYpwD7aprwqfbKiEEOYqo+2kKUL9kTau2aefBZQoO6mcyzaVmVoSp+OGsNRH42Eg6ziT
         W4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762478243; x=1763083043;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmWBxSn6CHjROvjdMq4Lw6nw/zAAMYc/Nhqo1NoydhA=;
        b=VNMPdoFf6WhnLaVC+lMvIxpfnsVi95ISDJ/+dXcNk6rc/yow85YWnySrjpRE06lbKF
         yzGyGLJBV/wEn3jQfu3wwAl8IwfK5O0lN9bK0heMVhSVHT8F4moVzw2IudzWPZOomLmT
         M0mTPMqCU5ll5u5VIzah0VYlD9xfObKf9EWzj1E2OTUKIRYVjMH6uiJ8IJHpgIx2g4XL
         fxeKVjhB0BULgZXdbNXSWYMHM04UEbrxOcWFLBNMDJuqpegrrZTNxkaIyHkdewLArsr3
         ELnpNasJXVK2KAXQ0z2t+y5kvKwTqWSD2i8WJAchSNXpSYVzdoigoEy9Y6HW8vcV87lq
         PWww==
X-Forwarded-Encrypted: i=1; AJvYcCVOtMb/hJf2JK7dIVLmBnn6d5KsahyvigTSUWV3ZprIXas8gld0qqlf7QYKClQk3dapsoBzDuxjEg==@kvack.org
X-Gm-Message-State: AOJu0YwHz2v+JxQRyEuEMKJe7erGsAFseYgxRl4yZ18H8ZQYHGyLFNfO
	0skPwTpe6ozm4sZ7w88Tr6TFNC7TJNccI5nUJ4U8qhylrteZRg7B6TrC
X-Gm-Gg: ASbGncv4PvZxdMDCKe2pi+0Wql6eEh60RqurAk8doG7++1xRbK1BhlHz/QnJe68Wjcq
	krwEA3DE8cwmq04Pg5OrNtmKDD4jxVe6ThL6wDjzDhhepcjAWCtdmIxhH+kfsdfHpQ/xlgp6WXC
	YthukVE4hEd+dTMWdCJGWd5/9YJ/h9WYjA+XQpVC9+oT6ZSNsCJIbeKoKCL08kqHMdm45x+bsmM
	XSDdE5kXOwM8BrgG8qwLWhwc1PM4X4M3yoShTsZCRoW4Ct0HXHrEEXfY/g7yNXA0JehtdAm2LBz
	ZgAxtmBrVhc6jZ+tshkrwhaYKl60Quz7HEoz2ygObMMrVC7zbpRjYwp0C/uOSBFSn+p81QXRBt0
	VVwRLHo1LYFDzRmljIz9Pwgv+01izphqtlA6ks9WhQCESBy4j8V6kFBEcHhYoX5EigopD5HqFwS
	c=
X-Google-Smtp-Source: AGHT+IF5Q/cP3tM/19Kk5JvgWHl7A8A98k53i+E4kiNd0AlprbZKvThq3R/yZhqFgO7I9sPC39KgAw==
X-Received: by 2002:a17:907:2d91:b0:b72:7c52:8e9b with SMTP id a640c23a62f3a-b72c078a0d3mr147045166b.15.1762478243330;
        Thu, 06 Nov 2025 17:17:23 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97e54asm95561566b.34.2025.11.06.17.17.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Nov 2025 17:17:22 -0800 (PST)
Date: Fri, 7 Nov 2025 01:17:21 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-ID: <20251107011721.ez6pile62o3vmjz3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <0D94CF57-A9C9-4C01-A9E5-CE47AE3F10EB@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D94CF57-A9C9-4C01-A9E5-CE47AE3F10EB@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: dg9uajrq9ycmerx7ibk9gxwmw6utof3g
X-Rspam-User: 
X-Rspamd-Queue-Id: 06A9010000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1762478244-451015
X-HE-Meta: U2FsdGVkX19MFpYw3nNk6FCKcbObNFI8cF/gtB3MAbgWpzXI33uw6bK7sH/koN87P0DfypKRwrhlgq7cXkG20jh8vqdDvpq6dGPwacsRLl5Pb12z15F7K4L4dxuOlcjmgzB7yZGZDMTEjdLyrMDTDmIjn5Jt7oARWEHShLjtbHgp94qX/HwTWunztvs1r6AM9QWBBtB20HjdfSKEBuU6/XK2mBXrVyu34dnuph7svPbgtwrIG8VZFgN0EgOCVjhtx8eVyF5I/SAVtJacHm5DD/N2dEzH7Qk03ctbsw0X2F0oOZyauK2CepjHRV9UvS1zPKqEMk1M+rhvC5YHXt32hyLAK1utNREtITJ4lKvHNpylQvitj3J/iZkCna18AV/40o9O3C2i/iWeRRxF3p89zKs4PYGd7hm9X8OXHVIjbOcDFQeNZO7QzWZqYvcw7uR3y1oTuQhtQOV8qQ4k23mjL1uU7vDojQMmBXk0T5mfMHJduh31JryyzGIVSPesV+ITT0Y3gy3f29gg8JY8Ocoy9rBskuG+FnqpqdesrEFwNam9zpgyF22iDPwU6rwrY7hmQ6IJsN94b/slKe2T7yrR8WLH5vbEYtJ1CAcnj5QTzhLvwGKnmGJtBP5r6+SWZVwtuvIU41PaBPXzConZxIlJTv9uzcIv4qFBxvVzltfFbZWejHPENPiCiU03O3cM0kC3MVr8viuN1D+0agDqD8sHlPus4KD2uQFwnouE90s9ntIWdScNh+uNOG4BV/MQyvLy5/fD10Duf/NqCfSADoiXu0Gb/lCDL5loOjdl1u63eEgYNr59mXHDy0/r+wuMREqgtZ/w/gwpcAoPLd7+iYpecyzfXcgc8+hlcSnGAh+jpJXMvrRyxKjMfr8QUyyVhiucgx316P20WQgNSxHPZmkrBwRI45QYPbPyGVrvHhTesrur2L/RM0kCUTv4jzVya2ci9ySG92cp3/EcfEvNdNf
 9o7TLura
 6HUZCHWVHxvoPmVtjWF2CYBdGL5p/HoimaPg1+8kvBxMxOI9xm4A/dKcfj/QK3lgb0VYBIBrhjhkHgv7HGgHVjwfnbssKqVb9dBQQ+3FDTkJohf87kbaDHfjEqQyZ7LsFbZ2wEd/yqz76DwsCZ3diibNg+RC9F5wn+ps6S9pwi+5ZHrT6DRaVXWBoQQxdOAeiD20aY0a2cSK0x6+TdCBmXqEKwIjrFESNbM8uUd3lphgmarevlMOdhuWHFZxCmvGIDytdiR4bW90HLB/bN2ZzfOP6k+ghGfvDEzzyD7dvjMwdejJZBTCjlVtO98mJ4CR1l6DzAaZDAp+PC8VnoWileXQ+drfVOifWMdkJ0/MpTiDab2raKColFw0pE9hAk6xFQMOg6DEcDQgBAfZWXrKZ4mOmQXfL6re1sDU3/N6NKjFb4QNNAhFdE5uopVv0BanmN3Dx1VC5KMQVgiudkbzSbqkH1laC8Umg4fC6M0JjjBmOchj7rvIygSf9vDfaqH2Pghm3KJFWEyWo36Ho0E6JWUyLlGxrHbpf+cF/RKG081Ls5pmw4R37a+Kbjw1p+M46u6DfZvsbSBxkow5c7vNYWfKRoxezztifPk3Kx6BCAsgj0QycwptAXsxqUhaSSmKlqQeW6d5jHr4OTs4recibiYQDk6p72xqQoFgVNwB+2z0rPeh6bAOLcOYod6XIykkA68BFHeDD3P1M7ITBtfq+8hWOrXwGS31RK4IgkmXW6f14pIkLsl2A6j/v9OGIQUF+0YYpFisKp1OpSGC9K4PRRfJUTPbqMhrTyV564dcL4Ot803dQUHC4m2inh7vfCxEq1f/Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 07:46:14PM -0500, Zi Yan wrote:
>On 5 Nov 2025, at 22:41, Wei Yang wrote:
>
>> The functions uniform_split_supported() and
>> non_uniform_split_supported() share significantly similar logic.
>>
>> The only functional difference is that uniform_split_supported()
>> includes an additional check on the requested @new_order.
>>
>> The reason for this check comes from the following two aspects:
>>
>>   * some file system or swap cache just supports order-0 folio
>>   * the behavioral difference between uniform/non-uniform split
>>
>> The behavioral difference between uniform split and non-uniform:
>>
>>   * uniform split splits folio directly to @new_order
>>   * non-uniform split creates after-split folios with orders from
>>     folio_order(folio) - 1 to new_order.
>>
>> This means for non-uniform split or !new_order split we should check the
>> file system and swap cache respectively.
>>
>> This commit unifies the logic and merge the two functions into a single
>> combined helper, removing redundant code and simplifying the split
>> support checking mechanism.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>
>> ---
>> v3:
>>   * adjust to use split_type
>>   * rebase on Zi Yan fix lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
>> v2:
>>   * remove need_check
>>   * update comment
>>   * add more explanation in change log
>> ---
>>  include/linux/huge_mm.h |  8 ++---
>>  mm/huge_memory.c        | 71 +++++++++++++++++------------------------
>>  2 files changed, 33 insertions(+), 46 deletions(-)
>>
>LGTM. Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>

Hi, Zi

I am thinking whether it is proper to move the check (new_order < min_order)
from __folio_split() to folio_split_supported(). So that we could bail out
early if file system couldn't split to new_order.

Not sure you like it or not.

-- 
Wei Yang
Help you, Help me

