Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B7DCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3AD8E001B; Fri, 12 Sep 2025 08:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13DBD8E0003; Fri, 12 Sep 2025 08:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8C78E001B; Fri, 12 Sep 2025 08:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB52C8E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:41:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FB0216046A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:41:06 +0000 (UTC)
X-FDA: 83880558132.20.F10A003
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 09107180007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:41:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YlFL2Cy8;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757680864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMoIwx8Fq7mQjvBVlaYyQNpQMDf4JO+RcpWFZz45CMg=;
	b=RDqryPmwT5tNSjV9U24YozrMyxq6XwUlTj/8CfBK4oOC2rfGRE6aH0eEFF5paAKJzLuviy
	Srx2VDR11epNMfOFkTp5vMjX2uxM1mF0rt9306tbrTPpLg5EK5/RtvLIgabgSJ24BAuuIb
	mR7uPMFeh+z1JAsRiRZX3x09h5P/p8A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YlFL2Cy8;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757680864; a=rsa-sha256;
	cv=none;
	b=N9J3C6VHdBTBSPdn8eQfCCQBOvYK73RkedkGNsXjLdOQ6URx5Qtb9BGE5CR5mE5OPTq+QJ
	0a22MQ04EgXxq4qgp579pkZa4M+v6HuPDDuvdRqingkPOs1LFzcAfGKJDFFKNABNCRkZk4
	NEcnnkGlxgMm4O7g1t7sNoG+pcabBPE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757680863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iMoIwx8Fq7mQjvBVlaYyQNpQMDf4JO+RcpWFZz45CMg=;
	b=YlFL2Cy86xVkjOYcsG2vT9XWXZjTSaFxEi5P4MOwSoUi/9EJzpkhILQhI/M8aMFcnahiw3
	wqjrRTEKUr0uqq168L8ifBCofkQptPl3brZv4HHsR+tb8d/aNSmAnBFdV1cLWkXY7M+mdS
	4KeGyfptPjTPzfcJJJvPAIu0lzOuN8M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205--UQw8D8vPOihOn35idyIfg-1; Fri, 12 Sep 2025 08:41:00 -0400
X-MC-Unique: -UQw8D8vPOihOn35idyIfg-1
X-Mimecast-MFC-AGG-ID: -UQw8D8vPOihOn35idyIfg_1757680859
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45e05ff0b36so6920215e9.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:40:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757680859; x=1758285659;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMoIwx8Fq7mQjvBVlaYyQNpQMDf4JO+RcpWFZz45CMg=;
        b=kSn5+Xu79/ZDtE0hfX19ogglNYPBUoxEslWZiHSgoJzeyoNgFA9ZvibhO1K9W7T/4o
         4b0hAqkhcxNWs+g7pSSsYA0p0ZLJ4ySmm79jXaMN18HOPOoGVWiygzWRXjzayTTbjOjI
         Y+7mEJQEkR9thNNogJVF6yDv3JSqV7iUEjkTGfFxPnNG6hf4i9ascSdxOk4e6XlBaNMk
         Xxi82HBXX848fFagGl5byCFenB4arVG6DLazpv+SvvmQ92xgHWSVyRDN+mpCYKBc1Ioj
         jq4oV1MhiAe7iMzLg6G6wd/TRx+k8xSRXBtcHoO1bZVolpxQBQwqlcmhCX+ADPajaw2k
         QYFg==
X-Forwarded-Encrypted: i=1; AJvYcCWtjtabLtYkEzCCnNDVgfg6LdUlsirDQ+kQ8ySG37GxbJy1jKNJQoleMOilVnhRd16b6qaD7yX0/Q==@kvack.org
X-Gm-Message-State: AOJu0YzPRTxVs5BkdYqoCux5WDcGhbMMlta2PPr8wmqPFVQCwRL2A7E9
	bbOyim1uGKXGLnZxGci9hZoHHLB60nrSlb5hyYSnfluyd9Ycczm0Ur9EeO78/xecLHAE9TaIwQw
	vpYhgbrAbGetj8Z5s1LNcMh/ZH6fpXxK8hfrQltmkjB11/c6EmZfI
X-Gm-Gg: ASbGncsnHI70ZwXyfyu9p4kNn70VyFL+hb8H44gIK7KTcDboVK8c91KEofxX+givADr
	jMh+qI2yA5hGkWSJR/dS9n17bCm8KOe423d/OzVWl8bojulJAIEH5uxwGIi0xXtkTK4vLqSV6G7
	GACqd04OLz+4yZZy6eTdcup1Z1ma08sCeaOrxWNLDIvch0Lhk97sOBQ+8g/guxcsl9W/JRrC2Sx
	MvaiNrL774j4h7WTldDXNyeD5DR84yUx5RuABsrtAwvYoigI3GKYCZ+k2nhznmC5Sn4aHX0vH+Z
	vJQxZs8qMn89bUNOlxvRawPfyyXivov+iKQAqo2QE6ib7IuUaZ2QCRIHjChz1k6S11iRQe2Yuh7
	3cb/gkQAVl+oJObPctxv8WR6g6BYoDs8SclqMpUVhgYFAJ1s57z0RyHLeGhfkmwGi8ek=
X-Received: by 2002:a05:600c:1daa:b0:459:d577:bd24 with SMTP id 5b1f17b1804b1-45ed647a10cmr35609985e9.7.1757680858996;
        Fri, 12 Sep 2025 05:40:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVEThTm8r9XP8uPlz9qkFfWXl+PlwCvx30XVhJYO0zMEAs87UYsFy+ktNpyiVcKL2vVNFxRw==
X-Received: by 2002:a05:600c:1daa:b0:459:d577:bd24 with SMTP id 5b1f17b1804b1-45ed647a10cmr35609685e9.7.1757680858542;
        Fri, 12 Sep 2025 05:40:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0372ae57sm60050545e9.8.2025.09.12.05.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 05:40:58 -0700 (PDT)
Message-ID: <74d1f275-23c3-4fd8-b665-503c7fc87df0@redhat.com>
Date: Fri, 12 Sep 2025 14:40:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
 <29383ee2-d6d6-4435-9052-d75a263a5c45@redhat.com>
 <9de08024-adfc-421b-8799-62653468cf63@arm.com>
 <ef343405-c394-4763-a79f-21381f217b6c@redhat.com>
 <4b4971fd-0445-4d86-8f3a-6ba3d68d15b7@arm.com>
 <4aa28016-5678-4c66-8104-8dcc3fa2f5ce@redhat.com>
 <15d01c8b-5475-442e-9df5-ca37b0d5dc04@arm.com>
 <7953a735-6129-4d22-be65-ce736630d539@redhat.com>
 <781a6450-1c0b-4603-91cf-49f16cd78c28@arm.com>
 <a17ab4e3-627a-4989-a5a5-d430eadabb86@redhat.com>
 <9ed5441f-cc03-472a-adc6-b9d3ad525664-agordeev@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9ed5441f-cc03-472a-adc6-b9d3ad525664-agordeev@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w6MC4SdshJIoPibQ4NW0SYg_CzuZUGpDT84oX1-qL9Q_1757680859
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 09107180007
X-Stat-Signature: pfi96ua9njxbjm36gsgm5inrmcbsj48h
X-HE-Tag: 1757680863-40660
X-HE-Meta: U2FsdGVkX18b8NB9n8yTIsYDwmmXXjmWJL5PZ/4YXPvlWopM5gPH33CRsZD/Y9A+kI+8nPlwzMBMOhu+l3FpwI9Wu5Ojkw+9huSpC740Xb7XWWtg/gMLcDeopTfR9sQwnpbID2RgKA2MeeYQOAaiIiBfR3hsf7yugngD2AqGg6KNjH4Je+hzJepqEbLZV3afcWY1on7AA/hK8uYJjMWSAEUpSVuHiJFhxkCXnp+w6l7J94SP0Ev+MkYnEBt+eF4/14zDMU7QS9acPMDknkaANCVLCfzHhog/ok/zfeSJWybwwC2lq4COoSYwAzC71kNvk3UnstIJspMK/iZ8l8yytgBmOSXmyfokgblfXIbsIbCO8/ueGXmgiNIMpr78NqdtVJzdpuIF83k4UQe7RD41sYpcp6fV2fvK2565+1QZDdCRZxNf96K4LBfW6AsjLyCbYS7emPLa9M731taP5iLSAbCP5Tm5czxFUjCxxTmaGfAv9q9KmXjrrfayxJYYXDLgmQo6lJFCbNw9RcprmBsOUjpojQgkStCDLETYeidphWHSt9/8I8xcZMGjGGviURFyyiqXr+QiKbIUykqBdmU0UFZY47MEPL5ryOp98+qvHiMZ4++oyrhpx2uL00uxYnC1Za1iyiyOz41ExWpWH5CQj90X7uABJ7kIeSAY72zHs/QXNc4gQd/jINmV4J8+XI+GMAs7+CZ589tJ2GZ78fo7FjmIfIAPrNUeMiz+sJv+KtlmQD3JP//ntWZ06sHPRsPlzAKZgzcqabRBQPX9pLG4nc1b5B5ZNAmb8uZKk+RHjLXaPQ7q3z8V0fiW7mi/nXfb9mJeJzoP8hvJGoua9lq4vcxkHEJ2wtbEshys9BfAXS0V0rqaBbxooJbAWjkjSTzaGtdBxxdXvHSnl8VvHMqX6nrMCxNqI7VhSdnBnYkG3Vo5pDTzGI3p82bvk0i0XX/PA4a4FaX1YphM6O34EYj
 mvzuV/5o
 Ao9Ni1Lk9/gnzShygVipKvQ0x761AE7Psz8q7MI7nDdYq7XSHqP2YXu/Ad/jiBt0de9tw2hx+z8MZK+Ta4Z4SkREpVavdTLecxgBsgJL+1PNrioao5crWWQHoWFUB3dY7d5u1z9BrFHwsgUIpE3ZTATmINz11wPJghvrm1FsPv+LHTnuZUr+AXwNzpgAhIy/IhhvbzzdzSpsvbeR3/LjsTkSzrXDwpcUNABzBjFjvqvnTYb6/kyso1NW39dUeLPE53dLL6NU1mIWp4Ct+0/yMnPQUte5UPhtZhukIOyQcyeARKOLDh9weF5F822VCNTQ0wnQmoAKTfAeX3MZLAbbwVOL8zDWyOJIum5Tj06ll6/0qCzQPYRR5EvKcPWhZYYug4mETTG9rwFCG7zMyMi1mVBETb59pgMNpyA9pIL+3uxmzXOIwu69JtGtTi/oAXDy8/sSo9vX6KWLMqIRT8aVm50evem5x+sjDsS8Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 14:37, Alexander Gordeev wrote:
> On Fri, Sep 12, 2025 at 10:55:50AM +0200, David Hildenbrand wrote:
> 
> Hi David, Kevin,
> 
>> Great, looking forward to seeing this all getting cleaned up and done
>> properly for good.
> 
> I am currently working on lazy mmu for s390 and this nesting
> initiative kind of interferres. Well, in fact it looks like
> it does not, but I am bit lost in last couple of iterations ;)
> 
> The prerequisite for s390 would be something like the change
> below. With that change I can store the context in a per-cpu
> structure and use it later in arch-specific ptep_* primitives.
> 
> Moreover, with a further (experimental) rework we could use
> a custom kasan sanitizer to spot false directly compiled
> PTE accesses, as opposed to set_pte()/ptep_get() accessors.
> 
> I am not quite sure see whether this could be derailed by
> the new lazy mmu API. At least I do not immediately see any
> obvious problem. But may be you do?

It would just be passing more context down to the architecture, right?

-- 
Cheers

David / dhildenb


