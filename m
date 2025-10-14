Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BCFFCCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A6B8E00EC; Tue, 14 Oct 2025 07:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861588E000D; Tue, 14 Oct 2025 07:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EEB8E00EC; Tue, 14 Oct 2025 07:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67C498E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:35:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DA79C08B1
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:35:44 +0000 (UTC)
X-FDA: 83996515008.23.53572C7
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 50A721C0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:35:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l/8PgZrq";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760441742; a=rsa-sha256;
	cv=none;
	b=U5qrZ7LCgO+OSCWNnwR6UFqMZF/TOR0yHrlPTNqopUKVPHnHINdAo5I5+4nZXdgIOjY+rH
	SoRtUO+ezWKH/ccRkmnxm+RudiTiAoJteAYWzEIZDFwEktDFcYy/5xtqZ80T/er4rizXXQ
	+JcozuzgkorGlvqUacSL/kA0bbbfaPM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l/8PgZrq";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8p7hD7OCuERyUI780nZ9E8UoPwfcetR3c3Jt+sSRxSQ=;
	b=E51BFdrgGjjQ8O1eDmW7IhBmlpvkYidM207wZoCDYF4hA0vED8k5EE/CKTZMVydg4UCMfs
	jWpcEfeLU8wk99/nrWHKf0h9KXbGT717i4Juz4RKTdI0apBrOsv1ruMly5ur5Mp1yeBINh
	9MyEWduhitkKSM1HjzbxfIikf9jijJc=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-780fe73e33bso40496207b3.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760441741; x=1761046541; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8p7hD7OCuERyUI780nZ9E8UoPwfcetR3c3Jt+sSRxSQ=;
        b=l/8PgZrqK0zPCKdq+zD6A/tR6y3pPlv9B17EoNFoo4rxSn7QKTLPxHe8z0CL2PhFLv
         Sd1A4ZRcIr1pX7TCxpFyAA/QE6zvbPKpQxbSYdJRlFYBaxNPU4kYVhtlyGAnL3UWgDfZ
         HEZsCX5Yrl21QI2IotLH7WXgLbKqMx6CQFpM7DkEWRJLCPcZP5tdZYHIl9rveWwlOSfw
         OkJ5kBZo4LMs+xzYY+XyT98hbFXyCmSeYvbw4egbkMF30ivrvcIp6XxT7x7+2VarTzpW
         VjdmhuaoNvHLr7W3JlJGdoiqfANak4u4diU+JBG3Upi+ry39Kna41K/pxlB8ERl8Rxjv
         VOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760441741; x=1761046541;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8p7hD7OCuERyUI780nZ9E8UoPwfcetR3c3Jt+sSRxSQ=;
        b=rlLa/XaS2Kfb3KLhslP4f0b0DqVDnbZutbCdhVrwox0yBk7Jvg1WWt3jbHP9tshdoC
         tfbzC3xSEXwqnOeFhr1KB+zomQMqcInvbHrb+7jGXeSogQOTp32PFV4bptLTkj52Y4ZB
         8skzdRfWfLwu9lmgjhL2nJz5nL08aMnuSc1tRim050gnmOD37Uu99v+lPRheq0OZwcFo
         /Lk9eXv6+pxpaa+EvxGwpFQF+/PV3Car0ffnIQ4gRGkLd3oMHqbI4g0nVbXnN/pI0HAM
         90bPoW6tBMVB2G+0FLSZ6vfoDTee4YvRDn4ml4Sca4JegJ2RUlapJBEB6/nIVOpVwlzc
         FzAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyQAaOMhRnmmYYdZ/98DvbO7UhKqrLji60C8CchSl1wyHZ05VJSJcWZXDDAudMCrLbUl4Sss3cdA==@kvack.org
X-Gm-Message-State: AOJu0YyxI3rk/z0jMh4c0AvFIVMCJtcO/gwSIrIlhzSCnefJRlolYlv/
	W7WdMSbHM/cYDCvEKs+imf7uNeImuF97/AXV5pz6asXUT8MJ/rElJYPAzqRDLVhSrShUpzzyh9v
	AkVA6/d2GW3ZekZZdj3Pv/gOkjYFnXQA=
X-Gm-Gg: ASbGnctN41ExwsOYY1JRhQBqd/AdmRt6V2ZackrNjDiJUI09CLLGhbTtL9afuEBUl1L
	gEKyAWvPSGn0YpfstxP+UpPmwM1Tq4zqA60KmUfBzC24Jfpfx1LxGadTw/4GnMlzqy5Pgdgm8QN
	xI4//+vCpT4KCDwg9ElSR7NcLPnhg67rMsyxiMiCYb7eKaifwu1mVNweAB8AhDRacZ6W6FFB8Aq
	aGqDJ25+uDe21OH5iOGlmM9LHV91cPOW9lz0Q9DUBGvbv6RI6O06wW1E0gw3NZXqQvBTIJHCgeK
	9JV4XYuMks1vmk0hcK4s/57OMA==
X-Google-Smtp-Source: AGHT+IFGrG6pq7rWKm6aIR+7hnroTx4r9F7GqJTK8ku7OFj9kVD3jVgk3lYQmQV7GKSfAkPSy4Y9WHViCHJ0OdUDFlY=
X-Received: by 2002:a53:cd86:0:b0:63b:fcf:5c5c with SMTP id
 956f58d0204a3-63ccb817b33mr15696163d50.11.1760441741317; Tue, 14 Oct 2025
 04:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20251014050609.349461-1-kartikey406@gmail.com> <e6bb05f7-8f05-409f-9d87-2d25f66942a9@redhat.com>
In-Reply-To: <e6bb05f7-8f05-409f-9d87-2d25f66942a9@redhat.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 14 Oct 2025 17:05:29 +0530
X-Gm-Features: AS18NWADgpzWMP4thQRXfhtcU-zx-hQnfX1rVdSDKTbFByCZERsGs3hEMU1Ik6o
Message-ID: <CADhLXY70S17ZSnp0B=HYNgzqP1Ty5AppY_cKUteBoryGkF=y5A@mail.gmail.com>
Subject: Re: [PATCH v6] hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
To: David Hildenbrand <david@redhat.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	broonie@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: apfr51uh61hthw3g3u56p99km6hujpyh
X-Rspamd-Queue-Id: 50A721C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760441742-125300
X-HE-Meta: U2FsdGVkX1/3m2W3bbhKwDBJOnUkIp0Aue4Z2LGPU2OjHtfbnyuPJCYis9JeBYHrZHFAMFjqM5UQAd7s+S9wMR7zL1xZApq2VbqY7+ff7TkyP960pWFDUv+fzTfHx/AWCWdtmqAQO/QCS9zMv4hFaWlKllhU1vMBKf+8Bw6au1qnw0ErzPsFZQBA+oDU2aKLdkTipZJUNlpTPuUF/+c1DL6WweJevx3tp9YZnp5a/OWDwa4yG4YJ9X5+JlCIreJpb3KkW8lscMmH/Q8Q456J0VXxEikbrRPntd8nAXE6C94H0csDadnHF3ff/8VTU8r+88EGQvQKxnXHTTXXcW9E++ny05Q2uQ1gwe0SwqzpNZd963+YwEyaSkEyqkMzi5Gr3Ehozrf9DgJUFymSRwJB2WFNg6uYgpXyufFf6QRudkd6OcgbnUtbw07Bmi+4VDQWbsYpoiTyVQfJy5IBZCC+NU/YKhML5TNzBA0fwfHSIV7HB0lowrkp6SCes6nU23CXxh3BqEgv8ofoOtt8SQpKynuNbouEu0LlALOygXImb+gTt45tGRQLropErpzuvw9hGxu8BzlWVvMQBGQHkzIDhsR3nH0BvEjbtn6G02VSMDrPi9i5vwJWvI9eSiBgV2zgiG88GOXcJe9f+YyACojnYXRge0DXfefg0RGkAKrBdnv1SP9OnE367dR0gi6uLGpyrZ3Y3/8aVrEq0UDSD1m7JPcACorz0XqRI0fcfcnpvisp1QpvRQQEAHwWjCnD4QBnoa4+5HAk/Ioz0IzFKNQse6W6ntd5DBbIhe6PrAKCIUeVGHX61vg7mBynYXZVHNXUhLMeuAHwn3dKHyaM5MM61ldvTfHXyIHCnk+5vGp8LIEcvwcZ6NSlZSB+GjowppuS0zhs36neF6GDxo4fUGsPum2ZVcTn9zmNt27QwGHERmmF3RWJAuLc7/kNfb/Vr8AhkkP+Ls+ZvVITDkassu3
 ruT9VKFD
 RF0LgNCedo8UM8AmFtm/kYWzxzxwWs+L/6moKZ0rWsFPNLfAH3LLk/pjg6lTa1kmqlNr6k7XYupnw72x1D3TqvLvdgtklbs9/IIAg+hNAzfY0YwuC5IZHJuHs42/fh+W3l4qwxf9AT/gtUrOXhvESttGesGaLanot4NT0EmIV4aQwjAHddHGVyqVXMe8Q9mlmdGGRBxVDtU1jxMT3Khp5W4KjkBJSRDmFY0EyCygQ04D8KXTVN5q30QIWrNdk2zltr8TeHeoyiLf9K6UvT7zg7EQi97NQonDI+sJxFmjNDpjxlgnOLOju8VAgKP5GM8LwSuzMbB1NeN+8nVAMpoHnssloltWlBcvNL9J8KHb7iJDL0yIzypsWAu0F2RCMELxVYNHhTabXU1KN1/bHGQ8vd4W2DrEY3aG2olVTTgec9lEhGoTT1+ULnI8T/i2VJILaiRdSyYxRmpHkWZhzj7EQLsrBET7eF26MCb6/9n0aALjCsM9T7VoIvkcKjy1U1VJyZRjGBkEk6S3n7jaWekAryqER1pfDB7P41WFJf3jJed6tWlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

I've sent v8 rebased on mm/mm-stable as you requested. It includes both
the skip code revert and the assertion movement.

Thanks,
Deepanshu

