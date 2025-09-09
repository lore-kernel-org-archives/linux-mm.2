Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D0CCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 10:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC16E8E001B; Tue,  9 Sep 2025 06:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E723D8E0007; Tue,  9 Sep 2025 06:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3AE68E001B; Tue,  9 Sep 2025 06:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCF3F8E0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:09:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A6FC1A03D1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:09:57 +0000 (UTC)
X-FDA: 83869290834.17.CA614C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 29CFB1C0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:09:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EIH2P8zI;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757412595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LqU+WGzmfGncFG5qyai0jHYVSP7TCxKOV9AhHT2zCnc=;
	b=dnSpex4M2Ki32Lyg4R2xKwJRQsV8qbyfBLgb4VW03LxhAWJPmaHBdEYfkpZHK+ZO25RN4X
	Lt7TkmBrzWoMsTFw/+zZJO1LxZjuA+NWYiqd/fc7eviOxpa1x01pn+8Lzo3lDJQLx5eLyA
	tFt8qPTyufDKEhqp0ZH5UbGPM66f31Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EIH2P8zI;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757412595; a=rsa-sha256;
	cv=none;
	b=dwRDCVBe/IgkFQqMSlKUYP6048LQrPliCX4u00l7PLz9vPhG9QJ74aRCWZF/YyoTHMykHF
	PjofbCCRRjAxDHsils3s+z6d4a2Ab7FtFixFB8GSgvSMmXmF2TW3uKTtAf+P21DxZLvyhl
	4wuZKrREWMa8bvUeIN2AF7fdeB3Jzt0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757412594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LqU+WGzmfGncFG5qyai0jHYVSP7TCxKOV9AhHT2zCnc=;
	b=EIH2P8zIcZYkDaCMrxLDGWHfPHP777hlvuk4rjzrd3EWHy82xAVFawnQA0eQ11KfPTUQIw
	mfMilZyTB/IPyohu6Inx1nvoomsXwhxl1TwV8jO+qcFWtUu16n9q54WBAzd+YUCW37T5WO
	MDo4/NDu6ELr7/8Lah8RGtOioePKBS0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-x4AKc8MoMY6m8EZN5ZAuww-1; Tue, 09 Sep 2025 06:09:53 -0400
X-MC-Unique: x4AKc8MoMY6m8EZN5ZAuww-1
X-Mimecast-MFC-AGG-ID: x4AKc8MoMY6m8EZN5ZAuww_1757412592
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45dd56f0000so32521825e9.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 03:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757412592; x=1758017392;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LqU+WGzmfGncFG5qyai0jHYVSP7TCxKOV9AhHT2zCnc=;
        b=Pk5NVQRf1hDvBJDcmLDq6CPKb7+W86HlC423PxiMp4Q30eEyTHvBfDjI+oi4eIeuPk
         gYHMLh0KHYKLYdgh99qXxWsD8cL6NP3PgNdt7VlYMVzRNvqukgPLO2pD0IBWH3YBZ28N
         7x4UDTj0GqlGdhtc0bCfErflsLoNpKUInM4NdShnyUll7LVnhRQcFr4K1XHmxUxCyO2E
         9+Urd2R2Yub3wf7oKNVGJNp4m2whqLzP9Dfoy9Q/JC62lDLVErO50asc0o8JCqUgJNBw
         NwV3WDQf/WpZgFtcy2pDqqRVNWPCAmKFPI4ZE33qJUu2r85Auhz+FMJxV6N61+W/Rk7a
         CkXw==
X-Forwarded-Encrypted: i=1; AJvYcCU4R9fytd4j/tFnqwWcm4yGGTKlGFguLMlkxj7fOgERuWJGLTiet3veLawUc6qxKJr5RLOaTBrOkw==@kvack.org
X-Gm-Message-State: AOJu0Yzlca6cfj2oLq8nob44FEahuBxZsXqqYVO/ZvOIcvZjogi7Gu+2
	1Qg7OYMqxieqGGlwZLNVBz1kAhRqd44fafqCXxkq9RgO6RFoowYvq5pahMOFpi0V9YGkoXkLbpe
	icPthIq3rM02FsiVGkRBxcRCNcljGPd8foYn0IBDSY96REvAnLF6t
X-Gm-Gg: ASbGncsfjqNQNnfWmDMYL10eifevgEcgX2FB4iXQ4rAdynuuM0VF3hIP46u2ZF8rwW9
	NhkGI1rHbNv2dkTlDAVzRFbHxdoUeYC22nZNbeNIdhePtlnPVs9RfKfKHvzOdyN1rfQ45P/vG7w
	0w1YO1cJibzgXZU54R24p0haX0p0Ld/1YSe3BtSmxkDqEP6GNtJEU9zlnGuY/tsxcCXxzuqw3Xz
	DOCnbMWoD+afmzkRi17yFpcIy4oV4TX+vJksYPmZWhf9Qfx8fFMNWSdnIsoRZ5NQg17KEkjo+r8
	I5KG78VmBjBmP+rCB009IX10oJRadE+5x+YehF3y05DrmidT3Gs4F8Xm2QqzmehM046w73zoKuo
	MMfxpFCVsYfi4I3F+I6akgp6/7oB7Ho9GMzTP8M6kbfHVFrW8fu2pMCD/laK6oSF1tIE=
X-Received: by 2002:adf:8b1b:0:b0:3e6:b06c:5b2b with SMTP id ffacd0b85a97d-3e6b06c5fe0mr6424823f8f.10.1757412591679;
        Tue, 09 Sep 2025 03:09:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+6kYqxQMhMlrUNgHhh5IEpwCukAjnB2iBRVYizcIa9qqydeyLJ0L3jlngBNKljI3RpH7CHw==
X-Received: by 2002:adf:8b1b:0:b0:3e6:b06c:5b2b with SMTP id ffacd0b85a97d-3e6b06c5fe0mr6424776f8f.10.1757412591141;
        Tue, 09 Sep 2025 03:09:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7522562d1sm1945921f8f.63.2025.09.09.03.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 03:09:50 -0700 (PDT)
Message-ID: <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
Date: Tue, 9 Sep 2025 12:09:48 +0200
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HXmaM5vM4W80U-Y6cWDPyQhFDt6cfIOzppxcHxqdQRA_1757412592
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 29CFB1C0007
X-Stat-Signature: gsgh6k9pedoioteqxq7tb1bxpii7iyo5
X-HE-Tag: 1757412594-931603
X-HE-Meta: U2FsdGVkX18SncRbhsTSm3QlArdF6Jk3XKup3xVVVKNY+cq7xCqyeIwEuZ793iN88zWzq8Pac4g9Z+0MaRMBIM0K64SuwDWRckYm7z5BUqxy7R+NEx2YWd/0Jzw0O5ysYviRU/tFGiITEe8cdK1Oen01kSeIt895QVcWBkO1bhYB5wsHya7kDSndT1YdMAfHRxDcxqSG8mZoiZyJP/P0fHyE0EfyBViRoeL1AFjUCHD5xzI8XXjwmkYpeoRZBQ7e/v6tazVB87KJJA8iYRhTOkYVkJ0nYo45jmMwjLAytmrte5NaGQ3fNxPBeuHdItHzY2gls4rSB/3311MbxMHmvRgE14zhSsWP9l8zXFFCUnL+JcqJ7N6ZQTM3buyphtzxfF5y0Fv5IO7pJ1MPq74v4nzQyqjzo6Mo4X7jiI1xukGMEoywdMZw155X8HBkEsB5hAhlgoCXmdlYaDXsyXykT+df+pEylrOTO0gVByg5Y4tjrdPx7QKBzNG6dCM1i3nUIgjNGLdpYo/dRSHIFOxSHqFVQ+3kEXiwDK4zYFO050GoZX870v7xXakqLwXACAnwzbpTGfaZxMnvYDoIYS4cqH7/+htga4EbUz2rkEGwBgpQ+A+7Hb3c2c5aScQ6cGkWKmI1wIhC5qrTlhpuKSbHb+/DloLIu56FQaMi//Xhmy0qaK8nq9ovguDT1UQBxNGwkky5kLYKLZn9Ovn6o5DYJSnyXF1TkuZO92Kp0NXxba5UUQ0Iv6ejQTocsc7UcqwP52Zb5OXYs6BZo0TYqGi2pyj2bpKeUfKTJknQ2NQw3zBAxZyKqDdCCKWdzzPO7AYF1XaiWYjTHO/Wu0Wjy1ETasoq0JtxcjQ9xtRVdZuj2HY6qbCTpg/OMGS+7fvUm4uqoPJ1h5AsyhGJySbYQ+x3egN+RN9VoOeCVnnCFPRveLHOMMJBTVHFiOYmPfEUGwA7z478Knno6TxFptaKl4n
 Wevd6GGp
 BAVUeLRbwIfLaL6qbZziS7dCLj+SaGCxwhSzmQR+YZyQPF6oYUt+rydvNvfxCuEYVTxbPjb7JtwRTUM5KWO2PcqEbVBTwvlV2oqioIT2+M0d9OxqPLvYkVr66bpORRzKdI2E3yrOpqcRQhy16ZAd3fU9SJhkLOIjl2MIwd3+3ex4pdFKdDJzyVoNQpUIKFwiHE7NFLsDRAsfcIho9DxmKJZnA8/SWRn36vf7INfn0ImOFF9cHJwAIkfjsbOf23TJLCPMA2/44AaiSmOg8mTTqoeIiyP28jxqirgSYNzbnsOVGfz33y2af+7GM6OrOSiRrN6mMSMfgdvvzGx9Op/FM7EB6lPsGP+0Ly+MPgItN8VXV/lHW83iJqXvUrymOv5+TATcNYcwIcDlbFhSwvhXgtGq/zNGcnTZc5xA+WoGOAGU76yqB+2bftCS71VylLaWHJa/HTrUWsKwbyxDrfErkY8KucQmXpjY0Jqzh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 11:40, Alexander Gordeev wrote:
> On Tue, Sep 09, 2025 at 11:07:36AM +0200, David Hildenbrand wrote:
>> On 08.09.25 09:39, Kevin Brodsky wrote:
>>> arch_{enter,leave}_lazy_mmu_mode() currently have a stateless API
>>> (taking and returning no value). This is proving problematic in
>>> situations where leave() needs to restore some context back to its
>>> original state (before enter() was called). In particular, this
>>> makes it difficult to support the nesting of lazy_mmu sections -
>>> leave() does not know whether the matching enter() call occurred
>>> while lazy_mmu was already enabled, and whether to disable it or
>>> not.
>>>
>>> This patch gives all architectures the chance to store local state
>>> while inside a lazy_mmu section by making enter() return some value,
>>> storing it in a local variable, and having leave() take that value.
>>> That value is typed lazy_mmu_state_t - each architecture defining
>>> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is free to define it as it sees fit.
>>> For now we define it as int everywhere, which is sufficient to
>>> support nesting.
> ...
>>> {
>>> + lazy_mmu_state_t lazy_mmu_state;
>>> ...
>>> - arch_enter_lazy_mmu_mode();
>>> + lazy_mmu_state = arch_enter_lazy_mmu_mode();
>>> ...
>>> - arch_leave_lazy_mmu_mode();
>>> + arch_leave_lazy_mmu_mode(lazy_mmu_state);
>>> ...
>>> }
>>>
>>> * In a few cases (e.g. xen_flush_lazy_mmu()), a function knows that
>>>     lazy_mmu is already enabled, and it temporarily disables it by
>>>     calling leave() and then enter() again. Here we want to ensure
>>>     that any operation between the leave() and enter() calls is
>>>     completed immediately; for that reason we pass LAZY_MMU_DEFAULT to
>>>     leave() to fully disable lazy_mmu. enter() will then re-enable it
>>>     - this achieves the expected behaviour, whether nesting occurred
>>>     before that function was called or not.
>>>
>>> Note: it is difficult to provide a default definition of
>>> lazy_mmu_state_t for architectures implementing lazy_mmu, because
>>> that definition would need to be available in
>>> arch/x86/include/asm/paravirt_types.h and adding a new generic
>>>    #include there is very tricky due to the existing header soup.
>>
>> Yeah, I was wondering about exactly that.
>>
>> In particular because LAZY_MMU_DEFAULT etc resides somewehere compeltely
>> different.
>>
>> Which raises the question: is using a new type really of any benefit here?
>>
>> Can't we just use an "enum lazy_mmu_state" and call it a day?
> 
> I could envision something completely different for this type on s390,
> e.g. a pointer to a per-cpu structure. So I would really ask to stick
> with the current approach.

Would that integrate well with LAZY_MMU_DEFAULT etc?

-- 
Cheers

David / dhildenb


