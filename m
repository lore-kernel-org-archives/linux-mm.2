Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A03CCF9F0
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 12:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7A08E00A7; Sat,  1 Nov 2025 08:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F098E0068; Sat,  1 Nov 2025 08:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7DA28E00A7; Sat,  1 Nov 2025 08:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3B2E8E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 08:16:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FF14BB035
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:16:58 +0000 (UTC)
X-FDA: 84061937316.12.EDE8362
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0DBA71A000D
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:16:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R+pvMkH1;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761999416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ec0hJUsQTUWsdl6E8s6GRpczB51mwhz+FQUrv1x/BOM=;
	b=6Msk+74/9CExJa+iHMM181I8XU2x7W8XSl2UIM62HOhGCs3dwF2b+FqXu4aKzZrxAD5djg
	ToSle4GkE3Xr4OO9rit3pHArMc3J8yFDZ5d8PpGLpiZo2Sr6UtYC1/JCHfLY2QjjrWGwPp
	SdwVn7aukZ/tnRLPfjv4J5J18u4LWvI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R+pvMkH1;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761999416; a=rsa-sha256;
	cv=none;
	b=yrHWMM1aZK8kjXuKGQG6CSIjLNkzejE6j3C4ofSa37DTvCexvQ5F3S6lqExgjgMI4WbVP0
	Fka5ytcRY3ftF8Q835kz4tNv17ibs47knruvab8CJzHtnVRflF1XEBW0eV/JCsgSgcdPf8
	Dl5Iujntgsz6goY6AKqpxTAmf3/xV24=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761999415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ec0hJUsQTUWsdl6E8s6GRpczB51mwhz+FQUrv1x/BOM=;
	b=R+pvMkH1HJx6jcVYDDjGzxmmI+Rzb0WGRQj1eYMVv/YnnC5LTIAziPzT52op1s8uSV9VSh
	Oa4JsJWsRbBzIax9SizxsHyVDrfPqZBeXCb2Z9C39SmbpNfbF4AQKv4l3pcuBAx6eY5hlx
	NVwYp4u/QKjunymin8YhjTgTSXveGHQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-zKW9otj_PT6Imj8kX2rn_g-1; Sat, 01 Nov 2025 08:16:54 -0400
X-MC-Unique: zKW9otj_PT6Imj8kX2rn_g-1
X-Mimecast-MFC-AGG-ID: zKW9otj_PT6Imj8kX2rn_g_1761999413
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4283bf540ceso1765809f8f.1
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 05:16:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761999413; x=1762604213;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ec0hJUsQTUWsdl6E8s6GRpczB51mwhz+FQUrv1x/BOM=;
        b=WB44yQBxnQVCXfIy3ZtJmsGBuAMzgEHbBGFeBk3NX9MeQX3AmdNe/40Ch0YAzLoQGN
         iTPegnHzj0a2CVoRZVqgIDMDuMa69sV93HWKgGS+v4hdb2uCRnij+DfX4cvjsa0rPbHq
         wHGMY/P5eN0e+h38BxkjkWWxh1BdNnh6i5O8TiJXWmr0A5FDOStv+S0ny9ETqENaGOi5
         SpIT+vOnxOcFk4vEa1qJwNe3KcekrLciR0cbcwmcf2y3ydeSw8Z5c4/wV52lkDv6BKGa
         79e7l/IwtUf8oXZLN0qYZFQibssQYkhf0t0WpjoC4HJvQAtEZmM6o2U9V6LBO61U4Cbc
         IP6w==
X-Forwarded-Encrypted: i=1; AJvYcCUPie1+wBycoDk4zui/92OZ85wON1pr4SSbXr/T8ojrF7Xzau2QF/Qh0+1UywewrUnodyQiTIS/mA==@kvack.org
X-Gm-Message-State: AOJu0YwdCL2/j74yM7lMLeXTkig3KYPPYz3DfcslRbdDx4g8yQxAAKDi
	W3s2MeQXawI7Q7Vg0RhWmJcMsaMTGawI98nLe3QlexgU9vUD8UBfDhv3L7z8rr8rcQWElTeGSga
	U7VkUsP45+hTUXoaVIac4iHtClUXKSNZbrLAmS65IBQm4O5t/e7irPww+GP7t
X-Gm-Gg: ASbGnctwDm2mTShBj5vFX2S/UZBDwXlFc6E9AriL3MWzcwIty//6rnlzWEjhVZY/6fT
	jd0lUpABdBAkYSwJah1hlKvkGDCPvQmPQRkG6WXotWRqqyHM/D4tGkrJ2Tpy7i7qt3LtDp5FQXf
	brbiLikmW4HCIXRKZSxCTG/NhDZY4N4ed07S2RcoWROuhDk136zUEYzg7DPgEQ+dSeP7o1qPT2b
	3Juy7EkGfVN+dHOgMFRWNBEtl35mHVT6kGI7hOck3mNco2nqSXhWuN6hzRvorkXqqMiZAcIhXhh
	wxLqYJir1DojvXqu/YookA96oF8A0Xxgp5vpeIgZnhn/kkVm38vhzmBg5u3u9FCo3Kky381oOao
	EOoGsg2nhdWjo3Jb1B3vyvKBqMvku/hsnnkbRrME6aDzO6A+D6FyRkbSNJogM5TEQ6xKlO/fZRF
	R+1wx0OT3Dy35+qXkxA2JgCiNH3hg=
X-Received: by 2002:a05:6000:2f86:b0:3f0:2ab8:710f with SMTP id ffacd0b85a97d-429bd671cc6mr4920640f8f.8.1761999412951;
        Sat, 01 Nov 2025 05:16:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwyu8iCMznl2jxRh8YLUHJ3p228bh0SCAtFEkItp6biokKqMXHyqxQIX3SdYCS4w5abwUMoA==
X-Received: by 2002:a05:6000:2f86:b0:3f0:2ab8:710f with SMTP id ffacd0b85a97d-429bd671cc6mr4920621f8f.8.1761999412492;
        Sat, 01 Nov 2025 05:16:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c114ca0csm9986764f8f.21.2025.11.01.05.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Nov 2025 05:16:51 -0700 (PDT)
Message-ID: <5368a371-10f5-40ce-9246-d8eeff52e654@redhat.com>
Date: Sat, 1 Nov 2025 13:16:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/12] mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
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
 <20251029100909.3381140-6-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029100909.3381140-6-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wdh0e3XG9IZWggTUcfcQ_FDMiLGCQIRFnjkMptLXKck_1761999413
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3a1anoxoia9nm18gyem5d1wakuneeow8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DBA71A000D
X-HE-Tag: 1761999415-528862
X-HE-Meta: U2FsdGVkX18I1m/yKC6CKtTdkwL9Vynn99GiHtBehT7jdTC4IsVHO7VtKHLvvw5MF1wQTxfBNU76ANK7AWMLwCPcIm9hNFc18TmqgfOgQ1Nt0Rwt2k9uqR1pviZBeeFuAmUoUYFjna63Oky/5FUvZlQNCBbL4JGp1zCgdsvIm8pD7pRwpXF+Fa7Wkxr6YvSfRK/sICX4uQ3ZV4LUCJeAqvwyZuZkuVj5lR057D3UzZoujGPEee/3+O5N5ozWA6Oq55VooHQ1xzWfmvAuMHjH3G2UhB8bm8AVSpmHCHN9EvZcODhCeUsV0Te9uRIDif5t3p0UMKSqUQdi+qyYCG6XWA11XEC67Xoofi9BNgsmsxRa/Ca71nQbxDJR74gta48xHt0rFXZAYEQCrRD1GD+wzdrLf2hsWBQCy9bT2i5pFnR8f+Dz8d8fnLkyxMJbVTbWWwomk2hXws5+G50+67HjAbKfdI2o5++jJ4+5G6TuI/YQ029GEJQ4v6nQ/K0+e18spdl+GdSZshs0HCMkzvHyH2YBFKxDe54b/2pOxQN2MDUGddstHXz4xbrBZ2soD8KdEPhBCQ8qoWMf6brl5uXUSbNh9mULqpvBF7z1YF36vEJFRqnGDVm3GEdddJ6+V/PNctZODxFOdqiSIQ5MUiyCGsSNuyFHFKg7+JVbbu4WMZ7lchKyrAHljKj7aO67HOe/ap4ob3qGzz/wamq/hN58Zb0XIdje4haebgqhRIjHGsB0OpBE+5SsKQl9dRQtLTbXGCsFoWeYFfrF+f1agFWMzKHfgef35GlikILkOvW4mmJTa6du+AfwTehhK9CsqjstWKmsHke2wWwVtCVffOuJw0qs0voCzUgprczYKQnS7qCHbjbUZana6ChGbfJkES1qHvw/C4ggWcNG/pmH1le8SOuDXb/hGVVGBG3+1N5LAtj+MX/TV+n6f9id4UXeUiZGWdMRkClKDde4uKDo/hJ
 lAgrDL2V
 69glWDJGblxwhlS0RhATKtyhcO3bh3oUIlHKeYdhqeg1vE9co5NzMFDTT6piEnmfHgSK1eXSeMjM5o2110m2w/jY8pSVFS6lZyECpI48MrajC4NtiBXeZZs25DmT5C1lWtV03uU8ns8H5G558TUClTz+1/fQruoK68mKkuZPirwtISDItmtzs3kam6/qYVgg7iNE5h0MPFhQx1X1z8MNwXvIbkDvwjLzxtMiqdjRdBd2VodVhEOILpWAE5EQQv9khqwEhbNQfyqfurKV9x9cYnrZSLT9nNKg5SGtUx5TN1Blzd1fYkHVND4OT9ertuVSG6Bde1sXRjqGRWk+ofyBoqBFkPCd5whu5cdVK5U8lir6p3VPXkFoOTItnDJCjepxoKM6WOGD56NdXMSoNGv8Idcr8YSjcT5dX+duLkPiNZD/cCDAh9iFhWr2VrE8iqGLZRfw3jGLiahXGlv0Knki+yuS8JwZcFmQ+n3Kpb15etLRiOAUPTfgVntGmpCdXwCF7rQSszWeuKM8YZ1EEEUNTu1esJYUDrW0FTesWo6YW+uW04DHF/oCoNQhbKseuckPB/wl0vZ0Ke1g1lo8NWKcFOas4482cw0f5IyLjNRkK6RNXHPcnYUlhczvJoV9va7XxrF7wsKznekBRz/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:09, Kevin Brodsky wrote:
> Architectures currently opt in for implementing lazy_mmu helpers by
> defining __HAVE_ARCH_ENTER_LAZY_MMU_MODE.
> 
> In preparation for introducing a generic lazy_mmu layer that will
> require storage in task_struct, let's switch to a cleaner approach:
> instead of defining a macro, select a CONFIG option.
> 
> This patch introduces CONFIG_ARCH_HAS_LAZY_MMU_MODE and has each
> arch select it when it implements lazy_mmu helpers.
> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is removed and <linux/pgtable.h>
> relies on the new CONFIG instead.
> 
> On x86, lazy_mmu helpers are only implemented if PARAVIRT_XXL is
> selected. This creates some complications in arch/x86/boot/, because
> a few files manually undefine PARAVIRT* options. As a result
> <asm/paravirt.h> does not define the lazy_mmu helpers, but this
> breaks the build as <linux/pgtable.h> only defines them if
> !CONFIG_ARCH_HAS_LAZY_MMU_MODE. There does not seem to be a clean
> way out of this - let's just undefine that new CONFIG too.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


