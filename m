Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F128CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5A58E00A9; Fri, 24 Oct 2025 10:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D338E0042; Fri, 24 Oct 2025 10:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE548E00A9; Fri, 24 Oct 2025 10:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB36E8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:42:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9007D5DAD3
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:42:18 +0000 (UTC)
X-FDA: 84033273156.15.195AB3F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 039F840014
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:42:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Us5hQ5Aj;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zuMO3Gm17MlJedQR/JASyV8PKolk4umw1nTXePw16OU=;
	b=PBJouHmvBOYiGB4IblaYIo01kYVdu3Ti52WfRtppV02ey3PvLGm7Y6ICeI2Z3PFe3C2rsv
	vtu+wCdqa+SZKwVV1qYDCip05253dNUNGx9sZNL9Q/EiKJ34GzbfcmAAeWoK2g4CvJKFau
	EJIgF1tCJkl0AKYP6QfLJ6b90kF5/Kc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Us5hQ5Aj;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761316936; a=rsa-sha256;
	cv=none;
	b=qOPr94XxDZWR+EB3yNfze5v6HZgXKpcTXS28z0SL+q/gQaBaslDq/ZsipujU/uElsrb2yF
	8qKoG/7euUS9+1INwd7CgTme9IQX/FOwGnvjsWgH4RLLtk5U/iELSUHq46YcIn1qOt/oBn
	lE1WfazYZywGxghU/JjOihflgqRvs3M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761316935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zuMO3Gm17MlJedQR/JASyV8PKolk4umw1nTXePw16OU=;
	b=Us5hQ5Aj0zt8Bz5eplCn6W+LI12qKspoYeQOfqWrQ0ckXO1pBMwFC9LRdYxKDp1jvkcvyK
	jxD0mXmHc5DHDGW3qRUFiFe/rSLCPGVqI1NlmA/plAEV9ITa57WXAs+3xA67Nae5jadivI
	72HjbMXMbxELVfFj/mO5YtXgwCVKlLY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517--886j-j9MhmbW1oB8I3tmw-1; Fri, 24 Oct 2025 10:42:13 -0400
X-MC-Unique: -886j-j9MhmbW1oB8I3tmw-1
X-Mimecast-MFC-AGG-ID: -886j-j9MhmbW1oB8I3tmw_1761316932
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso9549755e9.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:42:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761316932; x=1761921732;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zuMO3Gm17MlJedQR/JASyV8PKolk4umw1nTXePw16OU=;
        b=NuCKmstAZhEwk3VNrga9nE3M8NwFbIcpr3EsZJiRn6bJknupFv8/dubqaUnJE5+hdu
         4jgCwqkUZZ1jP/whdchMjtrZhxkCWrG09BPozrrCByDdJrrJwIxeDr5rWQo1T0hct2a1
         nZUb/+Vfy2gMjsEvjNkS30CiApdzMKvabmd2h0Eh14ZEtsfAkc3js5GXBc1nl74pQr7z
         aFHoq9TlBuVp400iN70GOW2y441vRP1Rdy50QzhJdm6AbW8ZlGuaD38Ih63b8KIrpKvD
         Ts4bfdm3W3SBD6HL/uQzHMMbZDIlTaTuSdFJMaKrYvkTQn/z3bGTTqOUVEOsGpHSDChN
         Rt3g==
X-Forwarded-Encrypted: i=1; AJvYcCXZUOY6IadOrs2dyxl653orCz+hOYThRVQ7MxbPXRUwOE+cL+1oMgWxmR2Df/TCh+rwQStUukOrjw==@kvack.org
X-Gm-Message-State: AOJu0Yzx6jDSYgm/l4eh6YwITi/vS58qdHs3ZZA+gkZIwioXjlo4J/Mz
	NShYjFhswp0wGyjkyX+dUX96wYqb4P+pbfAJ+Ar7kCVh/M3LsbCTVLBinfiZ18TVq9ZfT5cf4Cs
	qAeNHjZc5yVQSibRxNmbnpPxQ94W4Y7ySvnwR+AGSWil1xTD3uSgY
X-Gm-Gg: ASbGncuZ/SnjDYiKNA94/k4Mld9CjzAF+HRVuWiMieXHYz2V9mL/oRXciAKBQG4tFsq
	psunUX1htJCi+1SESzVUTABgudi5W4SzZLCCwNwo1FfiB+ZL7hOvVgvAkMFIPR3p64ey9rFFSot
	kA6p7NQ/VBX9DzAFoJhrX301A2W1xxgJE4hIPiNph4lRgpVlwYM5AMqO7f6nyhAbquTLY9ii8tK
	tihVzXK/VcdpkTyLkQ1uSrSQE+ClHrl70rFOzWNExlaVVYoe62h8p8a8uBp9X159mYu++T7WkTv
	r6SB3TFHPSZPjyBGN1sW3JrHSCj5DWvs0kD745ytwr/J1DN7z+ytp/YXos9fZ82602gShPt9Fpo
	gJjXyETlZAXBEUHmANvxBeyeDqj2ltKLz2cRRQJnE3IyJEU3/KlLehB5WGg7n7XU7t8PumviS1s
	4JQ2Jh7/5kIiLHkdOZ81H95lpdShg=
X-Received: by 2002:a05:600c:a4e:b0:46e:711c:efeb with SMTP id 5b1f17b1804b1-475cb02f5b9mr48174295e9.25.1761316931741;
        Fri, 24 Oct 2025 07:42:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVhLeriCo5qSkw1pxItKV2BmVweLyKW9vHw/E1IK25wn/MrmDSTPV2yNrI2gB0tW1RttofMw==
X-Received: by 2002:a05:600c:a4e:b0:46e:711c:efeb with SMTP id 5b1f17b1804b1-475cb02f5b9mr48173845e9.25.1761316931347;
        Fri, 24 Oct 2025 07:42:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475caf152absm113608615e9.9.2025.10.24.07.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 07:42:10 -0700 (PDT)
Message-ID: <5d5a85ec-0213-4af3-92a9-c02bb13da073@redhat.com>
Date: Fri, 24 Oct 2025 16:42:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/13] powerpc/mm: implement arch_flush_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-4-kevin.brodsky@arm.com>
 <60c55686-87dd-46d0-884e-80f7d423663b@redhat.com>
 <604f26cb-46c6-4533-8110-0b174eed821d@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <604f26cb-46c6-4533-8110-0b174eed821d@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9ztr_-SHknJBPCYocG573VwtuoSLsb5DVmzJiHuv40Y_1761316932
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zw1tafw8yaogxfnj9utn4tisime9d7wk
X-Rspamd-Queue-Id: 039F840014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761316935-66611
X-HE-Meta: U2FsdGVkX1/SHecejJHSUw7y41f9Fs98wRdFqZi3zbw2DdCSj3dcvRQtL/ldBG//NAgcjTUeoVI7lao7fyqccwmoglxhz6lv289lKAt9tUoNmzDFxwecHezwQ5gZWfYmiBR4gQzw5izp8lAmMviX+VheX/nq6En3me0H2Z6VcZ92gBaRMULLLpMGNwKNj9KOu9LFwLT54rhfamvtwkel/hCfE/qEdRN9Ja6Ge4UqiVf7kuY/pVyNn50nBNu/OBeXdJ4uXNulNWZxs3mRDnxJIx4OwzS1A+ZZS53AjRgWtpsqq3k/n8kRLCpEU8ZxdXATjLzd7UySEmdqyVgtVaBV3wBbIwmwko0sPKcTIQsGlN7aHnb8m76CGO7h5dfgTHrhk//rdseZ+8Ep7cIxfh1zvsxiFZ7/LWjhbyoPXkkI8Sauyn8F0gqFZdtSroihgD9s7mxbf5uZyIzPCLicmi+MFxQXCj3MPl5z9Zsj/7Hnb4M2hJ7OquMh7Lna3o3KEB0I87SOTdcmseAbIXwQlDMjzUWxGQRF1cvWwAC6t5yj07XPxx3LF+WU8x85sgrAjok3eKVT6KSlkub26GH0M6Rr2CQvG3gYuj4uL63QtjJy2riewRcw5Dh5hN1HuHb2XuQdnNSGqpopDNmWI56i7QDP5chPx6HGDf2Iwz2ihREQl60fQLbkiI2f2TQwRQZJXOrP5FmUgD1GfHcS4MeCdZn7Q1F078S401q4MLij/8e66s5jYHxZEm4/8lCyCA8i6lonUFPQ6bym6U48MFBjbFAdSyXbd/mLPcqQvRgmV24HZ9Z0D/4HM2jAaFuua2lisPVRVHX5BcLq3/5r2Kr6ZjPGEw2TJE/ZeOj0G5P8jQI4F1Z35XC1eXfIuzSgAeyHpxxrsUM9dm5OcYUe9zgnKKJ9pch63UCXm6RVTm1ZLhhwSZhLNGcZesrwNMRTYnseNyAStuWTkbTk15pMDEA+GbN
 wZWeAsUw
 vUbVg602PX94zSv8fmjPcouKsO/BFjc0EeqBrHnuDHo62afoQwW3lWwLQMc8BjxPv9kaNFs1vzMmKZqqjuZ/tgU4w0tqo1+HevTcTAgzUEeXMEl10AqSMzplE931zJoFqgAAVKHX6JMzL6xiJDqs0VLhkPvmSPDDhbsY4gKkey4+nk4rAnn/AkE/GgNiG1/an92NtB/F0kJ6IcPEV2Dea+P7WYYelfOAb7rH7/LS4KzyfpyYl3GjrMAEWYC4InQJPCAnwHP/xbXD2aQdK464ueBdLek8LJsfFjlOfyHCuxmnCsrit0tbOgMN2tgrMWVk8Z71MggZLTGUCyPQH1MuI1dtItytSuajQhNkm4ZnnmVz4nLpWD/f4QpbOfAkkOECGHnQCnIIifRYdUGlhlztZU7wg6vKwPeY3Vh88XV9a4o6tu5syqUnVO8mFb8u0qYw0GUXdNJTRSJIqVIqP/6KUN448cCfmGpTKCiid8ADa1Mt6x4Ejd8u8xc8SWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 14:09, Kevin Brodsky wrote:
> On 23/10/2025 21:36, David Hildenbrand wrote:
>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>> [...]
>>>
>>> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>> b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>> index 146287d9580f..7704dbe8e88d 100644
>>> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>> @@ -41,6 +41,16 @@ static inline void arch_enter_lazy_mmu_mode(void)
>>>        batch->active = 1;
>>>    }
>>>    +static inline void arch_flush_lazy_mmu_mode(void)
>>> +{
>>> +    struct ppc64_tlb_batch *batch;
>>> +
>>> +    batch = this_cpu_ptr(&ppc64_tlb_batch);
>>
>> The downside is the double this_cpu_ptr() now on the
>> arch_leave_lazy_mmu_mode() path.
> 
> This is only temporary, patch 9 removes it from arch_enter(). I don't
> think having a redundant this_cpu_ptr() for a few commits is really a
> concern?

Oh, right. Consider mentioning in the patch description

"Note that follow-up patches will remove the double this_cpu_ptr() on 
the arch_leave_lazy_mmu_mode() path again."

-- 
Cheers

David / dhildenb


