Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB198CCF9F0
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 12:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB64F8E0092; Sat,  1 Nov 2025 08:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E088E0068; Sat,  1 Nov 2025 08:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55CF8E0092; Sat,  1 Nov 2025 08:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A24EB8E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 08:14:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 517111A0641
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:14:49 +0000 (UTC)
X-FDA: 84061931898.24.087FCD6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 05DAC1C000C
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:14:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I5s+LJuj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761999287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wcrewv7OssaEm3gyvMk1iF/ClvQjL5UKQAK3UbLbS48=;
	b=mMstmc8srCPnkjOxqBlwUxR4ebbSSOr1zBQylYXuGPW7tbZ6yh2Ses/bAhV8OUy0NCk87n
	bUzcvpqZtYetBzJBPMbo5yGi+QlSfpQhyhJuwhDM/0WB0ibBF8AoS/X3eJ+ejPFnNEL+Uw
	cDThD1JsAM9UjvsSV+Pj0b/OtPFXBcY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I5s+LJuj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761999287; a=rsa-sha256;
	cv=none;
	b=OOnWLxsq6jaUaufqRlFCv/nTlxmEjBdSbqtxoS6CY9oBHESn5D5uFXxetS0sScjooJYJgM
	5rKnOJc/+aex6fQIt8yBdwvNdf+sQUm+WVaxhfwQt3yo2Zh3/Z0bxOQy8TjX3y9fQVIxpb
	0GsYj4Dd6csTUaQZg2miNPlm3OolIEw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761999286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wcrewv7OssaEm3gyvMk1iF/ClvQjL5UKQAK3UbLbS48=;
	b=I5s+LJujy807p09M01y7bbwR77hghtjGqVcUfTYCe6756sWnWbyhfw7Bse9KFnHs++fOdr
	0ho7H2mIq3BhaHBaX16Y44n8GcJ+rUwxhPnPSawSMAuwOmQwLqG3O1fZUisbzPyuEOWC6+
	flIaBZP3P6ZKrhcu9q6YmCl1ngS6riE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-16278ZUIN-GVHQucbiZDDA-1; Sat, 01 Nov 2025 08:14:44 -0400
X-MC-Unique: 16278ZUIN-GVHQucbiZDDA-1
X-Mimecast-MFC-AGG-ID: 16278ZUIN-GVHQucbiZDDA_1761999284
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4721b4f3afbso9000155e9.0
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 05:14:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761999284; x=1762604084;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wcrewv7OssaEm3gyvMk1iF/ClvQjL5UKQAK3UbLbS48=;
        b=XtfmJKc7hV2FhHHlQRk0QBUlSPJ2Pveir/GUXtHilUcflpS/mL48u1Yo8HyS9Oy9wV
         G3tJ5KFgg6oVOov8RxCg8JZN+SAp2JjwTUEGigJqq0MiI3Vzw4XhShMR7+56E79EFe51
         3sd80isnBPCcr5fuNiedhs/Ltj2rwxHl0gpu0DsAoe701vOH3Z8UZvAGibzSD6Ck/hUL
         AZA0VuCQvxNDiZ+qO4om6WQHnKprOvecrbAh/wgkwGqdr4xYYTwkmy8Tu+iLiaCRqcvQ
         XzK9FhWO/Pt9OWpADFcoBn70PL6JcbW9fNQTTn2xSVwmqzPELxomci2PAQYWvZZb0gIH
         RTiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcgwavmgXYYuDymOJmfbqex3qsjNkZaEWi4u1SUd1mKghoQTOzGuCfspuVBM+gLhNwW9c2647Mzg==@kvack.org
X-Gm-Message-State: AOJu0YxkLdO0noyXuB0Fb+KH7iJpdrgwPPpKa1sKP/ADDCHA0d5OC8Bh
	UTDRcBX1Ji32if0nBae5PCJk9XYqHCDFLurR0EmDsiRJ4In5Ayy2pEEbvwyoXy+MA43JldIj9Jh
	OZ9rCjGfpzFCf/+3XYBQvor1XWwe6A1BL7W7KcTGIIHQKUyXHB5Hx
X-Gm-Gg: ASbGncsAGMSCmTAn0sViA4S+mFIuSl1OjSGsVoCt/Ogg7phK+r17mvyf27USLeFx5XD
	MzmvBw87u3+zzRQgkAjZ/CSUCBeI+mdcWLjDNn00/Q7z/H5Us+hWxKeSXYvpPildnL7gi8jk0bb
	XcsoCb41FyZhpKAf54ZV6KMeEU+L2IhtSZrTDb7TIrG4runq9tNxwMDAmx011RmH5WWteJwWWnj
	Sxs2zQeBkheK0qSjT45f/1EtxprHN5Z0Y9buYULt9+u70WUx2RnTVPqEfwEDtcl91DrsCfSnEZC
	krqNgEQrUm1H53y8n5X+6fdF3GoJUhten+kRi1rCa4fNnjR8gaZnKhLNqosn4nhKa1UUCZH0aLa
	gL7GNkMqEkPuabgc5mOCKbOz52A7DLLGDLRf49XZuQEvby8w9u+NMXJfxR8QolE8ZFqzo9XHBNq
	r3OhvSVGbZoKgO6FvqTduEguLdV5k=
X-Received: by 2002:a05:600c:a0b:b0:476:57b4:72b6 with SMTP id 5b1f17b1804b1-477305a6db5mr69965025e9.8.1761999283755;
        Sat, 01 Nov 2025 05:14:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFQqut/W+Hh2058Mo2KRwgSobvPqBB9YeSBGPmcQlX0YmXFdyt0oSxc1X9BsoNgscSeoohIA==
X-Received: by 2002:a05:600c:a0b:b0:476:57b4:72b6 with SMTP id 5b1f17b1804b1-477305a6db5mr69964795e9.8.1761999283199;
        Sat, 01 Nov 2025 05:14:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c110037asm9428834f8f.3.2025.11.01.05.14.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Nov 2025 05:14:42 -0700 (PDT)
Message-ID: <c2859944-734f-4ba0-8b49-e0df23e1bdbf@redhat.com>
Date: Sat, 1 Nov 2025 13:14:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/12] powerpc/mm: implement arch_flush_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-4-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029100909.3381140-4-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6uRkl_7BWTg_2Cyzqcb1AUsJa_xeu6lOMJUqBu8SQjM_1761999284
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 05DAC1C000C
X-Rspamd-Server: rspam03
X-Stat-Signature: bz13tj4ieu5uokrygefj8h5cgd1uh9jf
X-HE-Tag: 1761999286-248329
X-HE-Meta: U2FsdGVkX18m2nU4v0XWvuDLCZZ/5VDdxyx5thCxIwWanSQkZsGvSMdTlc6OAH3bNhfdpCH4mlEk6KKVAoz7/7kTYD8lGXpLRqM6YsulQo+OggUcYpfGVWTQt1tWQYUkDkQXF4q1rP7uaVGS/K6zBD2VG/JIVkZuEQFOnRS9z8ezeNsURf6C3BlnCM7DwKih8YPU97GknXOXwi80gTUEO1W10uDQa4Y5dOV0indF04VScai3xVgWiapfO8L7mj8ctLTWjJ/bKO5czMZtJOE5/J7ozuQ650G67yMB0izgEIJvm4BxTtn7hMe6xJ5FYD17lP2NIq51SuUpnlNMbztT3aXm9pbrbnu7mEMkEBIGOyczZhRL+NcYCxLVygUdJiG8BUhbtpyR4jpOupBVPxbpLDoE97Lbb+eN+brQYFXkGTfGxil3KrQVQXNBKaCPNNzB38KbI9vATSoqEERn5jHr/a76UZkl5bpZww7xGQeaqGsyywusGFN+BAH6Vg74zZbTWpBS5G6CsnbTQD3c/PSNR5eshIcc0KIvxP2p5BBakN2AexgoUyirh7e0BZHsL1orAeNaIAnBNYE6E2FXPWt2dkcKcbbtq4xwLs7HuxXqv48jC7B8hhlUVMsqAM29LSR7ntReFz9FGjQdjXu9p0Un+xPoZfGXWB4WkfQOnd6Wj2fn6fXpYQTItm4yk4+SQiNPRVILU4qbMQNefPqqfxG1VGei6chg7j5Y5s+DxxKl44ICteEgGvHkjjpAJg7bBDs86JudI05ShpjjjsgSazdyBHk/9+m5FRAWRwspV6DJqR/3xheAHVYi9mucwju9W80bToF+QHYU2UPTc7Fa8GD+TI8JoOm2Lew+DcWH7YL4YkeFYhO1kOH5vt1r4RYlVKksRiyddUUauWJt1vN0Ii/ZaMuMCxYwcfAXWmUMITpax+9zrKGi76SoPDdWCZoD31PlXR3ylOzzSMYxAHzmrLy
 Km2Ly8es
 I37LC27TtIEQ21UPJ59HkTz1UtS++LqpJUi33n+kZD3dBU1NOiCMHPBVhiPDPZnka4tz/QDWrTsUPPYGDvgDaeg25qE6REAzp2CrZNsNnVofVV664D1DLbH4KLurdbmcUmf/n6jXD5CcVTpTOs7x0KT2i3mP6PlL9UXg3YvssR1vapp240YNEwW0UJ+5efyuEifvsHvLWmZZAOYw2NZDgdmRfF20WCCEsHq/9+1+cKfNcMW69Xj7VRHMxanpQ7NySbZxe+bkMYvwJ9Wo7qia1wqamTaNSBEgmkKxXRcPU20y9JD6mtoRTg+IUDO8ycw1OQQzOUKQANmO48lJL+UGf9xLxr5R0tIWhs8+h/cJxF8pL9REGCs39eYtwq3IfBXJlq/URNS54YGYQzlgmstsBP10OwIE/k3J++sK9g/NJ9u/20z3yUptE3/nHvB2bHJO87/PlzuXZhzxOAYdqNYyrLbaS/vJg73EcmEgcVqd3JsKXULfH3dBECwRQa5WysbaVocAm8kaFW1N1pcxjmPRrVFKDT12qg38z89faQYC5ZTfNpXIQCnXWLsN0Vt7lOPolr+GX3dWYqhpHGqixJlBk3l+bEf/l6D1yb1ux0cTwBBvtt2MszTnUUVI/8f4Ew+HHIXgrzVuVxoV67pM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:09, Kevin Brodsky wrote:
> Upcoming changes to the lazy_mmu API will cause
> arch_flush_lazy_mmu_mode() to be called when leaving a nested
> lazy_mmu section.
> 
> Move the relevant logic from arch_leave_lazy_mmu_mode() to
> arch_flush_lazy_mmu_mode() and have the former call the latter.
> 
> Note: the additional this_cpu_ptr() on the
> arch_leave_lazy_mmu_mode() path will be removed in a subsequent
> patch.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


