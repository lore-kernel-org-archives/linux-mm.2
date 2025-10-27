Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0E4CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77328006F; Mon, 27 Oct 2025 12:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F1A8000A; Mon, 27 Oct 2025 12:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E068006F; Mon, 27 Oct 2025 12:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE0718000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:25:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9891B1A0197
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:25:07 +0000 (UTC)
X-FDA: 84044418654.07.E4FA72B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 097412000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:25:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QeidNnQY;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761582305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJ5VPlj4otrH6ErEHjuzGdU9BRwHQ8d9NMaXu6e9vKY=;
	b=chbcUP4K4BjDD5JQIZRAg2wUb6z27EaRg9fex3wRMheu619lsDkeOpzXvKtPBgiC+gJIdW
	1G6Dkalk3RwtN3gCt/MG7FNBYwewpyPcaB5bzLk1ypvLDDMcHTLscEOfPDAR91f5jY1v9J
	Asm40mLdGCD1QQC5lf/3pRyXs568iTI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QeidNnQY;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761582305; a=rsa-sha256;
	cv=none;
	b=ucBvFXBOwdVbzlShmx+HFA5hG5mcEfk55EJ2iysZZD+J9S5zuo9Puy6CJbwZ398IzEmmFf
	NVDvVehgTsis/eRtwdpFa30c6Y/38aLfxWH59nDS91AQQQNre6ygrMcE2mCRWplqAIV6PC
	jP3E+tJjyTJ3premCm8+FGv4PUA/4ME=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761582304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EJ5VPlj4otrH6ErEHjuzGdU9BRwHQ8d9NMaXu6e9vKY=;
	b=QeidNnQYyHxSTWWki/8j887F6dE8Wx3bcqfniLlnnmd02KFgmwLEkU+pkPY4t3VrV3OVFG
	Oti+Y+m+c6yJk6B81lVe14CsKqyN+OdHBz36X8u1rh6UFT+VR6L15G2EX+2ebbgxmfOGW+
	ZSdD1R+uWjiGBCrOPa+QXq6N/tjXA0A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-7RG0a7IJN8KXoj0Mbq8dDA-1; Mon, 27 Oct 2025 12:25:03 -0400
X-MC-Unique: 7RG0a7IJN8KXoj0Mbq8dDA-1
X-Mimecast-MFC-AGG-ID: 7RG0a7IJN8KXoj0Mbq8dDA_1761582302
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-475e032d81bso17397025e9.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761582302; x=1762187102;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EJ5VPlj4otrH6ErEHjuzGdU9BRwHQ8d9NMaXu6e9vKY=;
        b=nRc67/HFwx0CXwcF1fn1gR3zSUzzVaR75GtzbM+SWs1YG82X4Bza7ebqh55so74tS3
         Fuq93TcwU1vsbcKJjqmlC5O0yyBuRza9a5/0QPyiqXxKFPIttpSaw/i1Hvf4yIQ7pkKa
         mccVZwFVp0vUWcMBnCn3NYDutSmisG51VU6XUDZNd5MKCaIhRiUOdDza0pEdImSsHXKx
         ozEUy4tO6+VTQAZlbzTOysh60N9SIeUiXZ0Wg+8FfxgBx6XqY5FyJoSoG3Z3MTX6TEvt
         1KyrFioB2fKPoNEzt9lgNcNMG0wPqENNzdl7zomhBynjWnSzWQJJvkOD2dIbTA8MCqTu
         3b7A==
X-Forwarded-Encrypted: i=1; AJvYcCW68xZt4OUhpIYmBfYFsM5DnEXeejjeSbOB2qsInzky7hzDs0rWYupKpxNhvnrDsuRTkgvEZpSiDg==@kvack.org
X-Gm-Message-State: AOJu0YyT5OGaub64XehmjdPXp+zMWCQcjY2l1iN10Q3Bj8e8dROHE+6d
	tbLNxyRdt27xpQY+FkmG3WHnjSyGp87oYxWLl7pkyk0fxH34QQ7y5UlRdow829MMY/Yj4wVaGKc
	196AupuqmF1yMStRsPoSGAc9wRPlMFTPKxpcQQOY/MbhgErN/eXQ5
X-Gm-Gg: ASbGncvAAqWz9FHxvNQeBFSyfHBruNbbuKqJzY7RH/cGscRuS56vDHm791C6BTZsCAB
	a1rPoMoajDVE/7mVatXUJiF/b2sqnjg6UcbIZfgb2WpJA7VmZTvJZy44Obt4mZRIizeN6pfGXbb
	ej6leJdvQ5ZzBP+wBRDFAYQ6ejFZEbU32pPQzqXeA5SZigFe3buQNdPU0Zxtytdwx14JEYjochB
	wkB3ZH+Jhb/UCA3RHCzA/rj8YHAUUSscL34xlTgh+KswUaPpEhWqiTLJLdeLT3UYCJRcbBf/MDR
	EWWBBgKyFi0yQc/VAZfES+6D5CRozujCCPzQDIL/aL1nzRNeeAIKW7xRDPpOywDQnaxYC0/i8GY
	FtpeG4FVqvqPw8za/vZrS2FatO5uXVRNJjuWyevIvAyvrO6AVJCERyWTVbbSv0odICEmYxV0QKd
	y08/XpILT6qWIPFg/m4PMPnYXtOHA=
X-Received: by 2002:a05:600c:3e8d:b0:475:dd89:ac7 with SMTP id 5b1f17b1804b1-47717df7ef0mr2442385e9.1.1761582301708;
        Mon, 27 Oct 2025 09:25:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcpfk6BDA32rXrYsquQ4cz9qgC2WRauB7zTOhtVhTNHZoQZbKrXzlM5wPgRBa5cEga5fDZQQ==
X-Received: by 2002:a05:600c:3e8d:b0:475:dd89:ac7 with SMTP id 5b1f17b1804b1-47717df7ef0mr2442105e9.1.1761582301286;
        Mon, 27 Oct 2025 09:25:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd01c07fsm74064275e9.2.2025.10.27.09.24.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 09:25:00 -0700 (PDT)
Message-ID: <14030818-52e7-41eb-8ad7-602f3476d448@redhat.com>
Date: Mon, 27 Oct 2025 17:24:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/13] mm: introduce generic lazy_mmu helpers
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
 <20251015082727.2395128-7-kevin.brodsky@arm.com>
 <73b274b7-f419-4e2e-8620-d557bac30dc2@redhat.com>
 <390e41ae-4b66-40c1-935f-7a1794ba0b71@arm.com>
 <f8d22ae0-4e36-4537-903f-28164c850fdb@redhat.com>
 <28bf77c0-3aa9-4c41-aa2b-368321355dbb@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <28bf77c0-3aa9-4c41-aa2b-368321355dbb@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MAnpQpSzHwnQyjz9I_6d81hqmM87A3zYteq5_7EaYiA_1761582302
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: py5j36m4p9jsjmbwd4uxgu9yq553depx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 097412000A
X-HE-Tag: 1761582304-498950
X-HE-Meta: U2FsdGVkX192+pCKdgwMgQzKMZL7CWRpcr4vSKJMZDByo8EB6wtftU/9lFd116m90IzsC9aN38Aeb/YDzqHDkYMukQZjhNbwCPm4vHVMZ/U1BYC5oShiWXwrtMsV5vL3BMr8CvEGrXCZZF0uuN4PLc990z83dOu9/7pionydqlVtu+rJNsdDB9HLQygHqrvI6ZQ5OAkT2hhjMkzixNfyGsr3lLnOfv3U1CKX6GkYqHmMPMML4rxYD5naYfTYtXO4DXPFqfjPFA0CTFIfY29wUocQ6MtyZ8LDBE4xgZ7st1bvlxD11LaTayb3bX7t8ryW1BuZU79JKHqZQyp7m2f0Hj4xhOF/KsD133DUf4v02J2xWRYXzMIo0108kZCpk46uKTLy2R2zcjWGIzT+BNI/cROF4EX7+S+/LVMwa2I8/h12olYxyhBqef1z2TbdC+3DLoZQk8+3YE1OLXWjWyG292UkryTitD+CYzViM76oZLBzxrFHByM+ZG1iOFbF/PKAxFw+0KlSMYC1h8FGxiIZQrMlHcfaBfhT9XOoXstD7vheYC8ODFoRSCFgmDwrKbZkNFK75gQkiy5nVfE2t3TQ1i351BYyxHwq9y7PfRR0HXhqJLEsXhn0mAHlijVc8XbzcsXtdqkLHq1KQznEdhmmbSXCrROaIkbhox30VhLQ6wKeojXCmVu69AT8YBDfr8evIvsS6iCDuRDeun6TQa8r+VpeRaakpVnbRln67t6JqlRbt0UeQqn6EuebQ0aDvi5tC+4ZqeU9YJ3jHj0fDvD7UmQI1UCpN3Cvg/ao7c2ZS31do0NSuU6bRucO7u8UHJ6ZZ0pi+dL/+AEgYaRpY8hfkFUBRP7FoWvT6bsNjTdt7tUW4nt24XbmRKt6csdwbMHLYuk7RD8vUOIikBgr9hUu/ZV60t2iwgOmDLspxD9RSXK9MYc4Dq3KUPL8guCg55GaFH06DyCNQqi7koNWpIf
 jJY3YORL
 UhIF/P3i9EKYZ3xcd3b/NJbJhVeMNOCDyI3LspKJ/UOXWIa8KHTalywZR22XmAGkg0AHNf1h6GH2TxzYQTVBDDyBrMyWOFPpy6KmfE68PGaPAm9PXZKDY9F8pr4bExSAegf2JmJr39A/0eYm9fC3MRf1IvaZ2J30MMSVjflvWjni2fsoXdkxykZfwLFpa7k/niJu90lP164RKjHWi6nOEFYERgvLYZ1bzlNBElffyv2vqtJCsqD0uxNvIsWVKamDg01trm12EyTDUfea0SP2LX9nmD7E8PNh/UpKUGfwI0eNBAtWVAJquzB/etGe/w+QvK9QVbPMbRNA57WR+9ByfokZjtRqh3WUCPFHvz+JeEuLgKOpJD+Evh+OLd6+k/UAqAofMdddXzpQ5/5pSpmMRE/FN+ONb2OVSHsVYmrqrZIcBOLRRGCVQrZkk6OJ/i+v82LOKrIXusWty3Z+xMiicK08pvZamG2WSK73l8q6Bx3wfgzO/GPdDswL/AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 16:32, Kevin Brodsky wrote:
> On 24/10/2025 15:27, David Hildenbrand wrote:
>> On 24.10.25 14:13, Kevin Brodsky wrote:
>>> On 23/10/2025 21:52, David Hildenbrand wrote:
>>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>>> [...]
>>>>>
>>>>> * madvise_*_pte_range() call arch_leave() in multiple paths, some
>>>>>      followed by an immediate exit/rescheduling and some followed by a
>>>>>      conditional exit. These functions assume that they are called
>>>>>      with lazy MMU disabled and we cannot simply use pause()/resume()
>>>>>      to address that. This patch leaves the situation unchanged by
>>>>>      calling enable()/disable() in all cases.
>>>>
>>>> I'm confused, the function simply does
>>>>
>>>> (a) enables lazy mmu
>>>> (b) does something on the page table
>>>> (c) disables lazy mmu
>>>> (d) does something expensive (split folio -> take sleepable locks,
>>>>       flushes tlb)
>>>> (e) go to (a)
>>>
>>> That step is conditional: we exit right away if pte_offset_map_lock()
>>> fails. The fundamental issue is that pause() must always be matched with
>>> resume(), but as those functions look today there is no situation where
>>> a pause() would always be matched with a resume().
>>
>> We have matches enable/disable, so my question is rather "why" you are
>> even thinking about using pause/resume?
>>
>> What would be the benefit of that? If there is no benefit then just
>> drop this from the patch description as it's more confusing than just
>> ... doing what the existing code does :)
> 
> Ah sorry I misunderstood, I guess you originally meant: why would we use
> pause()/resume()?
> 
> The issue is the one I mentioned in the commit message: using
> enable()/disable(), we assume that the functions are called with lazy
> MMU mode is disabled. Consider:
> 
>    lazy_mmu_mode_enable()
>    madvise_cold_or_pageout_pte_range():
>      lazy_mmu_mode_enable()
>      ...
>      if (need_resched()) {
>        lazy_mmu_mode_disable()
>        cond_resched() // lazy MMU still enabled
>      }
> 
> This will explode on architectures that do not allow sleeping while in
> lazy MMU mode. I'm not saying this is an actual problem - I don't see
> why those functions would be called with lazy MMU mode enabled. But it
> does go against the notion that nesting works everywhere.

I would tackle it from a different direction: if code calls with lazy 
MMU enabled into random other code that might sleep, that caller would 
be wrong.

It's not about changing functions like this to use pause/resume.

Maybe the rule is simple: if you enable the lazy MMU, don't call any 
functions that might sleep.

Maybe we could support that later by handling it before/after sleeping, 
if ever required?

Or am I missing something regarding your point on pause()/resume()?

-- 
Cheers

David / dhildenb


