Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 676BCCA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7F48E0006; Fri,  5 Sep 2025 13:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F498E0001; Fri,  5 Sep 2025 13:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4EC8E0006; Fri,  5 Sep 2025 13:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 675538E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:12:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 083BB140325
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:12:31 +0000 (UTC)
X-FDA: 83855840502.09.856BC6F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 026B5A000F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:12:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lhxgxpeW;
	spf=pass (imf25.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757092349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRexvvNjPPJfK1uT0OSGvRNA7ydx0We94Cj4HRzyUo8=;
	b=YbLOCX85DOuoHeq4K7PmLTHWgx6AZif735mLVKzHC4Z9x6mr4rfQ397ogZvTnUwnwEN+C6
	LIFFlDjly2IIW6m5WRwaxBHS21ZQ41Q2hB95ebuOxUX5uX4zKLvGjzlyQBvAkvI/lbd7fu
	k4bOrk7R9dDwXROgDxP6M3qrm/RVujo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lhxgxpeW;
	spf=pass (imf25.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757092349; a=rsa-sha256;
	cv=none;
	b=iRj5AVGzCyDoRVafs71uRnuWkTvownAJZQkO3oFLzzCBmNJ1kk1zHCJLVw39IozdCBPPbI
	ml+FOFggANugr1wfHlDUQsFOwTzngeMppB1rLEAdHGURk5i5nrcWesJO7ZxKXkxPxtF4K2
	GCLHMFrjzEQxxDycLkr34zNcSPuap74=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45b89c07bb2so689695e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 10:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757092347; x=1757697147; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YRexvvNjPPJfK1uT0OSGvRNA7ydx0We94Cj4HRzyUo8=;
        b=lhxgxpeWWH7XFnPUjfe3YUfjarlaVp7/gQi2rya6HWX/FX+QNKNQMd2tjZhssqOBze
         rmeV7h1Fw6eNdhzcDXMDi2a9oWmcJ4T02GO8aydkpGEx8qgLKBiGxU395UhwYNX5r9AN
         l8JlTcGa35syT5gecnMopAeKU98ZAw7h5izqn5NENCSkF5YOLzwHQFlV9IDzFzwINxsp
         XQ0xZS6kbVewcLmsw5JP51ujdpMlrKIatahB+x+0BmaA5hspDN9QsM+v0txtZ0GSPJ/J
         aQbeShNa4ZJf1NZsVhQd9M2eLZCD26a/ipi8fr4rldlwX3GVYkqt7C6aLohv16Gz7DuM
         +NNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757092347; x=1757697147;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YRexvvNjPPJfK1uT0OSGvRNA7ydx0We94Cj4HRzyUo8=;
        b=XFuctnb6ZYkasUU+Ai0Mry7z3KUiXRFIBbxyHDybU7yawqA7eSEofbkpSnxabRHUv3
         CArJM5zO8dtQ8OZ1kEuFBDOASV7wE88ejBCgKLN+6qWe1tzSFH1gdMs/QhjkElgH51mT
         Gqh8TcPoWuBkztO4zKsO/LEG5rcyRSK/ig8izwlR0BlfyNyd8uQ6F6Uk2/lHNBcyN5qo
         ySUBtppHFXqOfe6yEvanPd7pa4VnvmVa+rYRq//W/GwPShRjHPWSy1sfLsRINjVRNPiW
         957/6WoWuz89/z5sSUFoxJqksbdH+jYeOjrCr6A0eBPgNvS6UdkQJ8N44fyU4aHHdnjD
         S9TA==
X-Forwarded-Encrypted: i=1; AJvYcCXoggDBMjF6f9GCmiQffF83wxxd1j11p1crqK/pXFXPfXf2ObIC14gm7Tb1ayaPVrKs8t7rEIQRWQ==@kvack.org
X-Gm-Message-State: AOJu0YzkmuofkbV2rx1sGV/sF7EnqLxbZTlRz9ZLUuLq/fuEcnEegJ+P
	VbyTdIgDpnjE2FCoIMYbXW48lJeqQibKmVadJ5P3K55aigWkACLKKtNl
X-Gm-Gg: ASbGnct9So3JFh455MCpIIgQpsSah8iGum76Qq8DtBu+MlEghcIJksuAdJRbDfaF1VF
	yqNu6nAx35kO7jipf1WWR73lq4M3LglIGIWH7vt0ukezdoEBMs3lkM0NuP9Hj9GSlyjuCL4fcPV
	4dPKCEsQgkphfY+AKJVxJ5fKrvaJcV5HcgMiY3TAFUIT4cuFANITxl3Nowd0DWw5pSd3rO1sVxU
	YPBz0/TDt8uZc3Amyp42x0gRzU2gUM2+tH0Yo+aoFrpW5Cs37DUgFen9L9CjOXVPCv8rz7EU6PE
	logFhCWOkutB34LI0h+T5cHZpAGG4X3NEH/YM06J74UaS+oUh9DZ3xEsiUs1ZnX6kO3yLGiRvny
	hMghbwrj0FE4NieDkzWEVtRwY6IyYObYBk/jemiu1SmnfaBc1YlV8x9tsBGUJwLgq1r00d1DBaW
	7pQJiVLRXeJG0IOFs=
X-Google-Smtp-Source: AGHT+IGlC1bZMx0rOOObifxr+isGVzwQ1CKTbVGeV1N0+/Jd+6iR4EncAxNpQwTB91Ey6108bNX3uA==
X-Received: by 2002:a05:600c:8b10:b0:45d:d0a9:18b3 with SMTP id 5b1f17b1804b1-45dd0a91aecmr33464465e9.4.1757092346974;
        Fri, 05 Sep 2025 10:12:26 -0700 (PDT)
Received: from [10.213.233.28] (109-92-217-44.dynamic.isp.telekom.rs. [109.92.217.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8ab14esm369577925e9.21.2025.09.05.10.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 10:12:26 -0700 (PDT)
Message-ID: <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
Date: Fri, 5 Sep 2025 19:12:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three
 modes
To: Andrey Konovalov <andreyknvl@gmail.com>, Baoquan He <bhe@redhat.com>,
 snovitoll@gmail.com
Cc: glider@google.com, dvyukov@google.com, elver@google.com,
 linux-mm@kvack.org, vincenzo.frascino@arm.com, akpm@linux-foundation.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com,
 christophe.leroy@csgroup.eu
References: <20250820053459.164825-1-bhe@redhat.com>
 <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
 <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 026B5A000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zfqghw3pefzkxrx7ci5undbnuf46x41q
X-HE-Tag: 1757092348-62640
X-HE-Meta: U2FsdGVkX1/k4bXmekuojkBqX/FwbOhwssxvz4GwLOha+frFzxeFatSsWsIYRcopSfHkAK2EvYscF55DwsLdc8AP8VLxihxX0m2Rbo0Bhwe9kOYZeU7rVi85xo/A3lqZZovTz8QSEtrnoukMJTduSbN/yoLsBiqWZcDKHYaHGFxpJOXNT4+xEVnrBeu5p/3K2FgVKdgGCkcD0fXMc+V5K00y4sN0rxGXRrXxN4oZvOr0eF+773Ay4oEUsNa4s2htsYby2Incy7vF8pOmlQQ+9AEj0xm+QHtapfrztXdIw1IZAKQMOiaVdNXBEQ7jwxh1hEB/d3WTTpQrhEakg/sHp0jPd3sO9KDC+RTzzFJA6Ii9qDEl0kpV7fY+hOzngdFs8Y1R5yNgPAnI5+xfWqd2jVwFzM9pg1CbrjV/iMTtETGwMXV1i34bxs8fRWNdrxyRoiAqEJM7YR2MGrJJeZjLKVYuo2lh10MVKaZ+dxKjcTZpcwrc1ZvIEE+BLamGmeQRs9rJkdP3siY1OihNtOQJAnWnSZ/OCe9lHATfhF6zGy1Efno+TW1oyGIXwe+LJ+e6c/e5ZHYceANkxhaxpRN0TMXc2kZcnrCEYwHKbICerP+gVDhULY/4oEeoEL5Uum1rM29T/A2EaHcAoPHwL4i1ZdvRjCpzCBYWqn1VOXVUOkYtXWTvMrpMFfo1fJkDIEV6nL3FKkGzgrcKh5pSyTjV/ivbuVnpL/ADD3dRgPXQuEpxDfaCdZbV8Myb78G/KfSOEjt0ToGNJhnKWsDz0tkl1vR1OnDMC+iW0JIVZ2zr0Ny+mlzvn3w8bEpiy7DB5ZPG+RRPYGqF5BTLKlsokEzU0Ws2l/JtlY1qHCfxnG80FkjblDomPVCng7tQ5ryMsG6ZDWXCcj5AJnAU9r7s79e5IlFgEd2cnKc3v6oQSuu4xDvIJGECvNkNZp/P+LmU4XWik7uAdSIEvjrTgJJ/4Pp
 32XVs+Hu
 yJMltz5DZpf1C3IUwcKqR0ajdlD51ua0PGLNn8g14hRU9OSwRm1gN7LgoS8SNcMcXKaaUO+2DRIwqsd+Rcmm82HS5/6wmRkGIPSDMbnBMpDzD92LtquB4D8h/RP6UmWvTdIQK85DJHuYrxQ+LdajxyEaoomgJy6OkM92QeqEbYB7bF7XpD/X90d8e1SCe6820WFjqvKHUvfPq8k34FAl5sTvGx+cxisPuM4DvF2dJzROFS5SN6FzKeBk0rnrFOibloQJqcBAhmjd5PAVguuJsiF13JPeKHiMaOpjbRYe4mv/jSCoZEryFGC1YhIPP1AJVntBZBEVZbmUTHiUbrs2U5dqCTvFUOYf1lC5fuhmDlYkzDuU/6ZSAOUMjFXW/JQoEhvQcnG7eXFqsO5IIb2cOwWbj+aaUDVtouknM9pCaH3upFfVwBXnn9xxGqJMXorh3sMI3H8uz7LNMEKvYwvLY18oJkVz8y5hVp/nlA51dK2Bs4OmvlUjSfVzha1TTRmvadCMLSaGfF/R2n3rOhtp7nndeYMLPw3t1WpFPh2MKbIznZjdEyAclldpMoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/25 4:58 PM, Andrey Konovalov wrote:
> On Thu, Sep 4, 2025 at 10:11 AM Baoquan He <bhe@redhat.com> wrote:
>>
>>> If so, would it help if we make the kasan.vmalloc command-line
>>> parameter work with the non-HW_TAGS modes (and make it do the same
>>> thing as disabling CONFIG_KASAN_VMALLOC)?
>>>
>>> What I don't like about introducing kasan=off for non-HW_TAGS modes is
>>> that this parameter does not actually disable KASAN. It just
>>> suppresses KASAN code for mapping proper shadow memory. But the
>>> compiler-added instrumentation is still executing (and I suspect this
>>> might break the inline instrumentation mode).
>>
>> I may not follow your saying it doesn't disable KASAN. In this patchset,
>> not only do I disable the code for mapping shadow memory, but also I
>> skip any KASAN checking. Please see change of check_region_inline() in
>> mm/kasan/generic.c and kasan_check_range() in mm/kasan/sw_tags.c. It
>> will skip any KASAN checking when accessing memory.
>>
>> Yeah, the compiler added instrumentation will be called, but the if
>> (!kasan_enabled()) checking will decide if going further into KASAN code
>> or just return directly.
> 
> This all is true for the outline instrumentation mode.
> 
> However, with the inline instrumentation, check_region_inline() is not
> called (in many cases, at least) and instead the compiler embeds the
> instructions to calculate the shadow memory address and check its
> value directly (this is why we have CONFIG_KASAN_SHADOW_OFFSET, whose
> value has to be known at compile time).
> 
>> I tried inline mode on x86_64 and arm64, it
>> works well when one reviewer said inline mode could cost much more
>> memory, I don't see any breakage w or w/o kasan=off when this patchset
>> applied..
> 
> This is interesting. I guess what happens is that we still have the
> early shadow memory mapped so the shadow memory accesses inserted by
> the inline instrumentation do not crash.
> 
> But have you tried running kasan=off + CONFIG_KASAN_STACK=y +
> CONFIG_VMAP_STACK=y (+ CONFIG_KASAN_VMALLOC=y)? I would expect this
> should causes crashes, as the early shadow is mapped as read-only and
> the inline stack instrumentation will try writing into it (or do the
> writes into the early shadow somehow get ignored?..).
> 

It's not read-only, otherwise we would crash very early before full shadow
setup and won't be able to boot at all. So writes still happen, and shadow
checked, but reports are disabled.

So the patchset should work, but it's a little bit odd feature. With kasan=off we still
pay x2-x3 performance penalty of compiler instrumentation and get nothing in return.
So the usecase for this is if you don't want to compile and manage additional kernel binary
(with CONFIG_KASAN=n) and don't care about performance at all.

