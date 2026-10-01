Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E283CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A786B0088; Thu,  1 Oct 2026 08:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912AA6B008A; Thu,  1 Oct 2026 08:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801B16B008C; Thu,  1 Oct 2026 08:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE726B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:32:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E09ABC03D5
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:32:56 +0000 (UTC)
X-FDA: 85273996752.22.9DADEAA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A7EDC0007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:32:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PL2OYIR7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of vmalik@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vmalik@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790857974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMYtf80P5oX4IkVB/3A4AGGwzt6DCWZzJjMZ+oV75Lw=;
	b=gqkQGuotKUwu/CxdD3qvq20UqG1Hd4+2L2Xbmi6wGwHnX/5Eeihf19YFAI452ecnJst15b
	0jqVjl/yFbQZm0fzcA2Qs5pFf4nm8vAKdvq0GnkUv4+6ZAX40mNzMmq3Rt9TaTbQ4WZWEx
	3nc+K/oZvFlJjkQc+fb3lk1Iz5eO3ok=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PL2OYIR7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of vmalik@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vmalik@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790857974;
	b=LfIqigc1WJz/96amYJuC5UI4ONum3+blVn3UX4pmE/Qd12sWpMEt8M/jfNLCYGUEISnPgZ
	bOxn3eCLyYT489aAI2rQNYBt7nAaVIzVeiy7awR4gDEHPGfH3bwTDv1DXuPwq0M3hsYOiI
	lR2rVHgZdfhSSwTX0IXONjlJhbE17NM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790857973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gMYtf80P5oX4IkVB/3A4AGGwzt6DCWZzJjMZ+oV75Lw=;
	b=PL2OYIR7qszlw8p5iaW6Ddl11UDYi4Pf792PkKrqBeitjAQzxL0zOBucLuLgipBV4lVTqu
	ubC+8SAI9ng9VkFRTNn89BTslOlm1zAWxxc3TWOUUthNh4EGr7Pxbhtmn82euJScpWc2oC
	azRg/YpXB4oahyfH/LvnOM83Jg2WXOg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-4ADiy2gWMayTrGzFCYg4AA-1; Thu, 01 Oct 2026 08:32:52 -0400
X-MC-Unique: 4ADiy2gWMayTrGzFCYg4AA-1
X-Mimecast-MFC-AGG-ID: 4ADiy2gWMayTrGzFCYg4AA_1790857971
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-486e8fb7d75so2988709f8f.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 05:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790857971; x=1791462771;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gMYtf80P5oX4IkVB/3A4AGGwzt6DCWZzJjMZ+oV75Lw=;
        b=Wr74wMbY850cbVqm9jtRka2yQV42aTitmojqkjtkyzm2BswbK3Vmuj57jBfwfBgKKO
         cdyYbIvvYceZaiPGso+MsPQIG2hw6PvmWMA2QodehGPKRRK6Rsq593dZ2ktL598pt2XG
         Ef6SnqkPo/iBY3qx57af78Kl3PvjhB0MK0R7LKM/KWDPAnrnA9+0+Q+CNvjRYEccxo/5
         junOiH12w9mi0jrMli8MXUzEABTZq9YoLWUaIJ+TKFdNPpbg8YbVoJJ6IwtRtC19wz2u
         nGPYc4C4pCUlZ50fq9NXYzjmdAOyWTlDbXGDiXlJdVdh6rlPNlGqq3B1dQu1byhD6yHJ
         UTIQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgys/DkT3CXosxA1/sbyoHOXde0iiB6OkS4QMYGBwxdiYYra6+qbl5LGf4/K58j5dm7hlBykVfyg==@kvack.org
X-Gm-Message-State: AFq9FYKLdJd4X5fuEoriOCmPIMeplanBcBMulboab4/s3+7wWIkViXbF
	rLmLz8wz3pf9Hbua/5Zz/bquc3uSuBYrubGK7zy5Lr8PJwB/Zoi9GzwzgW7X8BbMDnELngl1SYT
	XhkJ4X2IIEv7+KRfTSWQOklH+l9pyry+LYjUS/b00XM/OBgjsFYM=
X-Gm-Gg: AYBFou1kR3+MSn3nAHJfGaHk3BHyai3Dqps96+z1qqeHz20Ce4YylkLPwhWqMlv5mlV
	DqdAw31tpg16fJkYMMEdnW59FgdpZd7E4ciogF0YfKZ+fSr6h1crFNCk0mnHgsTH0zEuPSA1g+k
	2nCeJKaRSPSua4VrZkYTvBCNxf3q0Mz1DYEsY6CBOEMLcYxvOtOifyBGIUt/43+IFGyTeih9PhU
	EqAZn7OYM1MNM3Q9gS0ltzlsI5e3Ncfu7zGj+DCIHlEYi1qOt34ElZa9f4kR0+0gW03RoxMhRVM
	JkJ6kqB9Uw7TiCx8JcHoe0GrxIi5tSbGno+fhg10T6tKF+HpJj/OX7cSpocau1C1dKWWEQwygzu
	5doxfs7yuxnmr4LqU3eqAeo1swP75h/45Qw==
X-Received: by 2002:a05:6000:4107:b0:485:ac35:5c5d with SMTP id ffacd0b85a97d-48b05870bd4mr4665275f8f.15.1790857970825;
        Thu, 01 Oct 2026 05:32:50 -0700 (PDT)
X-Received: by 2002:a05:6000:4107:b0:485:ac35:5c5d with SMTP id ffacd0b85a97d-48b05870bd4mr4665181f8f.15.1790857969830;
        Thu, 01 Oct 2026 05:32:49 -0700 (PDT)
Received: from [192.168.0.101] (185-219-167-205-static.vivo.cz. [185.219.167.205])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b0691d681sm5371173f8f.23.2026.10.01.05.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2026 05:32:49 -0700 (PDT)
Message-ID: <5e183c24-4acd-4b79-b601-bd1aa2f53dce@redhat.com>
Date: Thu, 1 Oct 2026 14:32:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] maccess: Use a scoped guard for page faults
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)"
 <linux-arm-kernel@lists.infradead.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)"
 <bpf@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
 <20260824160523.3907021-5-usama.anjum@arm.com>
 <79daa73b-0d34-4e84-8450-56f90bc700d4@kernel.org>
 <98e9ac67-7df3-4c0a-8814-37e196d94020@arm.com>
 <7454d7a3-57c6-4883-a66b-26129e633c6e@kernel.org>
From: Viktor Malik <vmalik@redhat.com>
In-Reply-To: <7454d7a3-57c6-4883-a66b-26129e633c6e@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cRFwaloul_BKSV_ueS7gmwDBBjrKLREWLZSTLVnEWjo_1790857971
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: orxuzwotzf8p3wcnspzqb3rac1zqp66i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A7EDC0007
X-HE-Tag: 1790857974-88695
X-HE-Meta: U2FsdGVkX1/SonufpB4Fg3HuRVkBe0Z3XZGtNZZ+oHyRwH3ezHzPOxpWMgAezOufW3v2mvlKE7ynz1mWRPTanaKYL8P7vGxQIxYj7GAHVhgmA2HplyB7xdvMlZcsbrEWWjn5AbSgn7ibUa25XzUcfFvloOumUMvdWwAQUguGtvjikdGhJLatHAiq6jZDTDS0eZjA79EBZs836pRK9/PkghNII2R60/KLTaCvwd0ePLJL4FlPLM6hDvyaZpRKF+MV50acyVX/phjtoGnErXgfFyJR5XLocC6G0pMHCAmfvbwU1MqViA1YP1n+esP3emjyifGIDhTCO3LSVlJUje04mfIBI1SevBJUp7iL3+p3Iebf74ouBB3kNacohwMrKM7+dURh5/OlIySo7A5HukHTnXKzNQO2gz2KF3RJ47EpIkluMewvUlpm6oHJumaxsMQjaZOFUEa0/U3fBKuYzt0RRChj0RcC9uKD+DphduYgzKULg+At34PvwLFoO4LRH930viRSVOtdZjcXkGkcZvSR1lZzYN4uTZhQvIRzZL6ZRLjUQ618deDUl0tF8vn9Clp23nZhOx5bLfViq7ySFYSWoltoefvXgd4XjzXjgYMtMWZgixEVbXEwANmw5205XM1dMUeUtD14V4CRTY+LVx2psKbjN+B4NlskMXhefkzYiKcVZtmabgkO0pdYyrwEXWizehbcjilN35+7+2m+06v+yroQIXQEBJfnDT8+4OLr411ggW54znwybzGkJ+7/Y3SwX47fUV2HPlo+Gd5QjA7PabLtYJTJfVeWuQaUIP+SDyeKwpKep9bkLoCAMkPuccTmdHVRggPvDbWV2ZbVS1dK2kQzg49gY1ZtSaEEdbUrA24nbn9s0qTYKlPoHQ0qdMqTp9CnDC/aYG8qhKot5KrlaMlbFcSlRZFp97F020G0DHB4B7NYCtmSpwEnr1kFd6Z4sAjg6MNKWfHWcFoI7mW
 0e3UxujK
 I8Xdv/1IrtQ48NufrA73yVyV3tc/qw9CTrK0izeQbUVRhBJ9LiQrdjHEVvEy0y7csbDj7U1O4Nly36QejB0Om+Z4AWE1YVc8mQsYeGAoweB+TVrrGqhrnIz6gV+M1XkpS0JPYlxKy6bwdhjcAnAnah2/z158ybco39/n/9VOHr/nz/4uf/3dQ7+I7OKIZKzWk7E74Fd5bdkr/1QFjAcvzl8DFO3DuRUder8urjzH4L7jiPu+VDkscKoiF352LgvJPOvUfClHR7UXR498hVhn83+cXJMdiYkm7mQJpsgUWar0daHhyHDSiOBb/cFTPFh2EFVYsG2MRZ/eU/aGXkZ7Kgrr8Id70A1ZTDiqLOxku6802nqqJD0PNzXFlbYndK+S0DjmbTdy5bTUKs08=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/26 13:33, David Hildenbrand (Arm) wrote:
> On 8/25/26 14:07, Muhammad Usama Anjum wrote:
>> On 25/08/2026 11:36 am, David Hildenbrand (Arm) wrote:
>>> On 8/24/26 18:04, Muhammad Usama Anjum wrote:
>>>> Kernel nofault copy and string paths open-code page-fault disable and
>>>> enable around label-based loops, duplicating cleanup on success and
>>>> failure.
>>>>
>>>> Use a page-fault scope guard instead. Leaving the scope now re-enables
>>>> page faults on both paths without separate cleanup at the fault label.
>>>>
>>>> No functional change.
>>>>
>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>> ---
>>>>  mm/maccess.c | 53 +++++++++++++++++++++++++---------------------------
>>>>  1 file changed, 25 insertions(+), 28 deletions(-)
>>>>
>>>> diff --git a/mm/maccess.c b/mm/maccess.c
>>>> index c59a0e092d24a..f695ceefe6fcc 100644
>>>> --- a/mm/maccess.c
>>>> +++ b/mm/maccess.c
>>>> @@ -38,18 +38,17 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
>>>>  	if (!size)
>>>>  		return 0;
>>>>  
>>>> -	pagefault_disable();
>>>> -	if (!(align & 7))
>>>> -		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
>>>> -	if (!(align & 3))
>>>> -		copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
>>>> -	if (!(align & 1))
>>>> -		copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
>>>> -	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
>>>> -	pagefault_enable();
>>>> +	scoped_guard(pagefault) {
>>>> +		if (!(align & 7))
>>>> +			copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
>>>> +		if (!(align & 3))
>>>> +			copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
>>>> +		if (!(align & 1))
>>>> +			copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
>>>> +		copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
>>>> +	}
>>>
>>> While I understand what pagefault_disable+pagefault_enable does, it is
>>> completely unclear what scoped_guard(pagefault) does.
>>>
>>> Should this be scoped_guard(disabled_pagefaults) or sth like that?
>>>
>>
>> The `pagefault` guard is already defined in `include/linux/uaccess.h`:
> 
> Ah, sorry, I thought this was added in this series.
> 
> It's completely confusing.
> 
> 	guard(pagefault)();
> 
> meaning "disable pagefault", what?! :)
> 
> CCin Viktor: I see that the patch that introduced that has no acks from MM. I
> don't blame you, because the file is not actually listed under the MM section.

You're right, looking at it back, it's a really unfortunate name.
Renaming to nofault or disable_pagefault is certainly better.

Thanks for pointing this out.

Viktor

> 
> I think this really needs to be cleaned up to clarify that we *disable* pagefaults.
> 
> Usama, can you throw in a patch to clean that up? (calling it nofault,
> disable_pagefaults or whatever)
> 


