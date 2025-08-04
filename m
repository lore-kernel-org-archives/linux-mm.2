Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74707C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196828E0002; Mon,  4 Aug 2025 08:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E3F8E0001; Mon,  4 Aug 2025 08:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036058E0002; Mon,  4 Aug 2025 08:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5C5B8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:16:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B412557789
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:16:49 +0000 (UTC)
X-FDA: 83738973738.08.95012BB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 30B0F40003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:16:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WWAIUrNw;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754309807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smTivLN7vGpmKkbSDiw2L8Umpu8NAfTaDV1GiCt7zpg=;
	b=Bnos/aT26B9iETQQrr185+Nxl5Fpn6rm2QBtOZdqeDpBVXYvueIPXEsmrA2GD+Iio9Shj6
	bn4EsjiOW9RTaOJa2atBtGlMT3GXA5ohiJhx5eaFtxEcKvz3E+dR7XoJ76DmZoJx8CPi98
	mqM0eXI3Ejk7OvfFsZzqarpt/5YbZ+k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WWAIUrNw;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754309807; a=rsa-sha256;
	cv=none;
	b=1hjjUCvgeTrTPV33gGmD3qPx3Ql5qybxmzzvJr08gbAoc5xhSKN0CIaJycWd7Spcrbw2Z9
	f3QuO4N5hUixTFQxYU1CSkLMmRIg8cH69YFPAHDgfKYLLmsCugHA8r9/uhXTkVrJwAT+CN
	bVJWJ0Y8dirLgXwbgkEkpTcEvX4iwRc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754309806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=smTivLN7vGpmKkbSDiw2L8Umpu8NAfTaDV1GiCt7zpg=;
	b=WWAIUrNwW08ncQ7SUc98EZz7/MHmdsn8hcBdZhU4HfZ8bWn05DG4T7BRCMxvOpjtedKshk
	DD7l3nJV1qUP2g7o77MQTbaY+RHGphCw/KwgxAWyuUzrEzaNgxboG9Z4i7dAU5rmmiYM1w
	0yY+qCd/X18TUNTp2bkYMGg02XBJLnw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-hoDG2nHdOgiNhIqUpECt2w-1; Mon, 04 Aug 2025 08:16:45 -0400
X-MC-Unique: hoDG2nHdOgiNhIqUpECt2w-1
X-Mimecast-MFC-AGG-ID: hoDG2nHdOgiNhIqUpECt2w_1754309804
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b78329f180so3251925f8f.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754309804; x=1754914604;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=smTivLN7vGpmKkbSDiw2L8Umpu8NAfTaDV1GiCt7zpg=;
        b=WUMymVrkBhCfE+eK+R+vQgzXDdMrvlFvFcEL2M9n+J6rCuaBa6oq+bXxIzkCeSWJ9+
         XbbR+FuZCHF0Pc/VFncZz9Xk7y8qH5P+ZWnKu4ysE0bCPma8vO4lV6JHu+D5qNgIjKxW
         cSuMr8cLW5a10fvDIwYzELpgeQIoKWqXdHcI8uhy3nEJPnUO+VG6/H3+s4Ir0IYlKaN/
         lhaSAkP2SujbO3qzN7dxXabKno/OtSjTJBAsLWSnHYLSP1RiBq2EZbiE7SRqWyoy6Cyd
         PP/+PnqCkLlBx0aHSsYc5uAb9xHpeyUpH+GKJzSLaT9e+uNejR4DsBKQNvj54e/zCQMt
         IK7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWiD18n/PDgg3h2h+dd8KZxZAgdgELfQCvl3ySPSPSn03WVyixzHi1I71i4gOaS+iUutpmpdS3dlQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+xeYyvQuQ+4C21B94zHbndF8khsa97yUrkL7k60U9YK8JlQve
	p0qm1SuxFxm6uvuzJY5HM12g3a2bKi6e0PEI28zUWZZhN/DhMum0IXSpFlbJDQGXQ0eup7Mujun
	p1C65ug3PeXt1S8dyfBJZI9cTcfBAYVKqwWjdcjWGqHngYy6Xq423
X-Gm-Gg: ASbGnctQeC9Mva8wAt3esJHAPmSZLDS20jFK7UUfzK+7tQqCuBhRs/joYjtyp9wEtWx
	V0wf5ZAMb2i6wX4VhXNpdLnIL9AUwT6Jpqsxr7ilXsC+b/mWoadqwB6O/uEQAngfTKEHjZNuTYx
	VgfcRQJX0Wjli8r2i77twoNnalSCg9jcSPtDlYfhEt45BZtxsD/s9fyVkeVm+GsCVpfbuDlCvWp
	A2RRxlI6ga8hsQ+L4XFrMjZFZmf6n2e4reZYhQsYfjjOMhbsCi9UmcyqW4MeuHOf4eA8TZT+rFq
	AoDcu+CI6KSOm54YxCrXIZwn4l+yZB6vda34wQjN5vihbvPHusguHaNJFWAnr61d9oJI3sWNBEg
	RkOZIzAdBaNox49cHv9/T2JJx0Wp0ZBA/8wtkSRc2m3Lg1SpsrUj+0BbI6zuRU7AZEng=
X-Received: by 2002:a05:6000:4312:b0:3b8:d081:3240 with SMTP id ffacd0b85a97d-3b8d9469b94mr7277483f8f.1.1754309804025;
        Mon, 04 Aug 2025 05:16:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF62zIj5iO+0NeyVqAEhpgd+//vlpeQVUkWLMm00GOI4VdqPyH3d/dI3sWmYI2aRdRjphW97w==
X-Received: by 2002:a05:6000:4312:b0:3b8:d081:3240 with SMTP id ffacd0b85a97d-3b8d9469b94mr7277455f8f.1.1754309803502;
        Mon, 04 Aug 2025 05:16:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589edfd983sm166628015e9.13.2025.08.04.05.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 05:16:42 -0700 (PDT)
Message-ID: <dd27cf00-b9b8-4231-a6d1-9ad6562d0074@redhat.com>
Date: Mon, 4 Aug 2025 14:16:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: Michal Hocko <mhocko@suse.com>
Cc: Eugen Hristev <eugen.hristev@linaro.org>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com, linux-arm-kernel@lists.infradead.org,
 linux-hardening@vger.kernel.org, corbet@lwn.net, mojha@qti.qualcomm.com,
 rostedt@goodmis.org, jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aJCRgXYIjbJ01RsK@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6suFqq1GOexgXNlM13qQGJBIuiTSHRymw5G206zBz1c_1754309804
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 30B0F40003
X-Rspamd-Server: rspam06
X-Stat-Signature: 87yia1tk7mscg9xbmykpms98wo1g47x8
X-HE-Tag: 1754309807-33745
X-HE-Meta: U2FsdGVkX18HG5p0j4vwCAzFl8hp+0hTQhxbz3ZPQwfDtRPqgaNwSxB2LMIBf2pHMcvTt1GQrB8PS/Hhdbqx1buDtf3PCIAIBwxhUDylV8PDP15IwDkomh935S+R4jqQR1eVdcT6jJ3ayTml7aezWnd39cvA97YzDDvsJAnuwL8LLrYOJJx3IYLQLW8smlrfgA7lMUvXwPu1R0zwl1QmKOb5rKtg/ZXYYY0OpuZet8ZXmLj2CtpR2RsZDpGxeMJno5L1mLEDJqXP7BkaeQZVkH0EvxfFTM+9TnD3bj/2+0wE6zw5ZF1b8c/CVifVmmBxpmLBpm1Cm9Ewwd93K6iryhuNAwgcFQ8cZNcfW5a2zFnH/2YHjCoJQWNAd0h3JMFYeh0pvL13pgrGkIIREu4jD+JmZVpKt9LEsrwejQRbAb7vpmACfUk6O194fX5m0AYsc5SKCcn820isf/9y6CyLe9clHci+faT/5Y2i0PSQhJu4I4+nay6Vdi+L/Iy/qW6oKKpW26xsP0w5fSzLl9iaC1LRZKySvKAe8RXG7QGmA1O6OSkazbOnXiJ/VNP/EHummbklJMufF8w8tLxsVe6Yo60OUHHyambqBZ12e9fjHaeTkHBygMdtn3FBKvSALwvuWHHPyf+HRVkQ0Edybwb8kJ/hzC1iObDzPNUO1hMiOGSaUGyVPYpGiomN5sDF1/9DrJ47l80lCuxeGnoM6yhywUgq4vLHFrx8VSr9XkxqSDJk9swLOK0QbjBq83qHDycfGxvbfQjyfiql2f16NCi5dgNxuwzF7SFF+zo5448DTTNxjIXZUWY9ogT2PQCehzkVfgJxqODR3s0/5x5m0H5/9Pe5sbWOKGjTFJCAcqyV5JSZCgQs4LEkesIB5hoseJ+2tbHdJ/BRP2gsRqZC7ab006bE4yrf0Qj6GwC5ded7ivgYn2KgwEGe7hPY1MO5OiV4jX9SYedDDl0VqeM5qsd
 pLpM4Tck
 Obz+Jw72ridbIyiyoDjjfo2g1zQSVt8zBLCQ/9dThmO+5CowS/ZkzKYkTee7wqrwKoIE4s6brpfAbwCnh+BCbWBao5mst0v2LX7kfNK5AfGLFvf8sBlQctK6CMQOnE/kBnoACywLj7lGjlMfZ7Da8JSVB+IjPRVnYHmTYz3QkZvwo2PdheY0CXisk+84QJ9S83I+3IGr28rCLJygQr2vF3r8uLwkOOTD3GO6J/rer/Nl87+dzh9j1FKlH231uolIZqSbU2fehdvvJ8cdFrQE3+X7qT/Fza+n17ibQ4WYU4PjkK5DH2CYG9UIjmdoCSB0WJkcZyJio5Eo9HVr5bQDoSLt3FsZFVVPLy6VAWyEOe7b0NtFc4R5/oYguSf3laNs1Jmy5rv9+KRPrphzKALMrvdQSL5yyO0xSf76wxdhyC1YsDDVxdl37TF7W/0oBy1GZ4Q7GYXfwxvs4G/PqOYME0mw1q9l/I4P63r+lT7mugaIhNqk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 12:54, Michal Hocko wrote:
> On Wed 30-07-25 16:04:28, David Hildenbrand wrote:
>> On 30.07.25 15:57, Eugen Hristev wrote:
> [...]
>>> Yes, registering after is also an option. Initially this is how I
>>> designed the kmemdump API, I also had in mind to add a flag, but, after
>>> discussing with Thomas Gleixner, he came up with the macro wrapper idea
>>> here:
>>> https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
>>> Do you think we can continue that discussion , or maybe start it here ?
>>
>> Yeah, I don't like that, but I can see how we ended up here.
>>
>> I also don't quite like the idea that we must encode here what to include in
>> a dump and what not ...
>>
>> For the vmcore we construct it at runtime in crash_save_vmcoreinfo_init(),
>> where we e.g., have
>>
>> VMCOREINFO_STRUCT_SIZE(pglist_data);
>>
>> Could we similar have some place where we construct what to dump similarly,
>> just not using the current values, but the memory ranges?
> 
> All those symbols are part of kallsyms, right? Can we just use kallsyms
> infrastructure and a list of symbols to get what we need from there?
> 
> In other words the list of symbols to be completely external to the code
> that is defining them?

That was the idea. All we should need is the start+size of the ranges. 
No need to have these kmemdump specifics all over the kernel.

-- 
Cheers,

David / dhildenb


