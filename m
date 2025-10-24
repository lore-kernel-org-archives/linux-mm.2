Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 047E0CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2828E00C0; Fri, 24 Oct 2025 11:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37AD88E0042; Fri, 24 Oct 2025 11:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2431B8E00C0; Fri, 24 Oct 2025 11:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1126F8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:47:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2EC888F7B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:47:23 +0000 (UTC)
X-FDA: 84033437166.19.950919A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id D302F80002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:47:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="H2ryN6x/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761320841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zh1ZhwP32aAGY6v6KALNNGN/uKhaB99XR778w+H01CM=;
	b=Ra/FhiLWPvyrpUNcliwiTHbdN42R2MINIbj8ODS8iXJbVO/VsRZ+8s0cIv7/4K6foxHW6Z
	kpvpc5R5sUFdXZGArVdUB8huc2+NgC2G/URpvq0ACfvBYks74OprEgUW0M4E5Avn1objov
	AGuZEZJ7PJtdVVvTn1OeECbEMTtsyWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761320841; a=rsa-sha256;
	cv=none;
	b=R6UDcVHl41LrI4fgUuXymtI6Ng9LO2DqWpR0SCa7Plg//VJE808HcC10CI57VQjgzPihef
	1mdkQ5+MVvSDlZHT6f8eUHH8UVt5ijrC6dxS52RJv6L+q9eAQ+wh63aBTDDK1NW2WDSJC6
	tDjBLjsUFTO1cy3yf/7Qq7+1+UqlTKs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="H2ryN6x/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761320840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Zh1ZhwP32aAGY6v6KALNNGN/uKhaB99XR778w+H01CM=;
	b=H2ryN6x/vAk/alvNnBM6750hAKKnj7njBunDPXhYnaykXRFKPeSde6twdxftE9IwOsp+LI
	N3mnTZYzm4Mk3h8wvbZOHJFnm/IS4g+YnxQvF33HIJIEZMeN7DSkvnDAjaKU0nzddu+9s8
	unEIAaaZD2+cwV/mS9igqFNFPJ6l04c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-pv-y-RCSOeiVV8fK6foEaw-1; Fri, 24 Oct 2025 11:47:17 -0400
X-MC-Unique: pv-y-RCSOeiVV8fK6foEaw-1
X-Mimecast-MFC-AGG-ID: pv-y-RCSOeiVV8fK6foEaw_1761320836
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-426feed0016so721251f8f.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761320836; x=1761925636;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zh1ZhwP32aAGY6v6KALNNGN/uKhaB99XR778w+H01CM=;
        b=VGZjXccNTWVzc2m3s155SwIrsiRR4JvbYJIzI72NLVQihR2eIo1oJlyd9wmuklDBzW
         vJcVPxd1JAY0pxJMbVEx/E+aw42OiMX/qMrYqnOufwX7xscXyqrCNenesXOjuC4srZyp
         yFtOe9dtpoXDj9xGZAFTNQOy0FtkmYehbX37tmVEjE/mWvvmHmpX72YHlcCY+LYZFn61
         kyLQmuECfE9jB1xKgN3HooUzSOVSaSBDNhUfnDVU3i1RUdGnMa8Ywxdi5w7rAuGKFTSW
         azurDSfxjZNopv3TGaAYJWwzE+wtd8ggB+Wdp3bhRAoH+PY2Zel4AsyXxcyqMIqp1MwU
         yMpw==
X-Forwarded-Encrypted: i=1; AJvYcCX/yc+doSx1u+0vaImhaTny88vjKIW8Fsw6OlnAzhvrgXnJcARzxavSxq1PTH4M1rJ5pOUb7adU5Q==@kvack.org
X-Gm-Message-State: AOJu0YyBXcSQ5SWt/qHmYjIg6eV7dFTiMZp2cCa/rMpyAoDSe4Pw4dbX
	/diuycHTG4G0t7YVL7XddF0fMl7Qmnvr3tiQTjJ++S6XBCldz4oQxqRqATpCXAa4a7sQMhcpfMb
	QKATygJM8k1LbVUzyMyM1NKDZOoogOz3WmWvLbhqD7kOJfKBH+8PJ/KJEn28T
X-Gm-Gg: ASbGncsJcVhiEFJpC3SAUKPkxOT1X1K77aY/yUBJ9i95kSPOw0TJ99aCDOK7H2gY7zu
	/oKiW2icny8trFITyn01pDHfZyfwCn26gF2CpHxjWvpMC8gAX1FGhGr1KunOcHdjmf0YiTZT8jn
	zGgIDUlsEXIeDFXEAOkFVaoNknVqKzczP162Ud9IIPaNHtdAFAtjfkodkiJcqXIiPUJJPpjJ2ph
	/UkSxSk7PL/i0knFMdhu1dWhGDMNQmYH1TPRGbDVepBhg1DGOf0MryNioQEK6dHGyGqsqnEx8GD
	M9/QBbtKELRbwENbLD5VrAC0ldlWgqjXX3dLYaWy0xjOQkWY59AyOaMPzI1jf5JVKhCvOSD60Ij
	PXgVr0y3M+7+wdPZClrWEsXth+/Gfv4lhzjGhorP4I1zwVBd6WWdZ1Ky9A6DTV3oH+POygNbXXx
	HtAy4tmQCUhnN8zqkQvphPYKur7lM=
X-Received: by 2002:a05:6000:2888:b0:3ec:dd12:54d3 with SMTP id ffacd0b85a97d-42704d9396fmr20967187f8f.35.1761320835755;
        Fri, 24 Oct 2025 08:47:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1IyVkNrFwdw3X0IHbQxiNfclxHzAPN9pR/bJWmUeOYxNVyIqqL3bIXH42bdfIqDr4yy7kTg==
X-Received: by 2002:a05:6000:2888:b0:3ec:dd12:54d3 with SMTP id ffacd0b85a97d-42704d9396fmr20967156f8f.35.1761320835282;
        Fri, 24 Oct 2025 08:47:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897e76b8sm10302003f8f.1.2025.10.24.08.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 08:47:14 -0700 (PDT)
Message-ID: <9faf750e-2369-4fae-b58a-ed9052cfd6f6@redhat.com>
Date: Fri, 24 Oct 2025 17:47:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 David Woodhouse <dwmw2@infradead.org>, Kevin Brodsky
 <kevin.brodsky@arm.com>, linux-mm@kvack.org
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
 <20251015082727.2395128-12-kevin.brodsky@arm.com>
 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
 <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
 <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
 <cbe0d305cce6d76e00b64e7209f15b4645c15033.camel@infradead.org>
 <fcd7b731d38b256e59edd532e792a00efa4e144e.camel@physik.fu-berlin.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <fcd7b731d38b256e59edd532e792a00efa4e144e.camel@physik.fu-berlin.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dRFC7ThGRRd8JI1FYopawmxZ2WjhLNsGtj4th3CEnJM_1761320836
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D302F80002
X-Rspamd-Server: rspam02
X-Stat-Signature: ek8ys3jic84ht9cq4rp38gke1dokgwis
X-HE-Tag: 1761320840-208582
X-HE-Meta: U2FsdGVkX187LAZRYClHIeSwEmtbuerX0FoDgFobBpP26A97cnAlYaOALaLIUWS3t1rO4463BEJTjeD8nsLz9LIq+hR7nv9JrcuzP75E8/ESdbQtc6HH8Qy4TjJL4lB76PV7Vc2Imx8rXoXVlp8/gTol7edqX/xjXVfwNDrqDQppLhAc6bD32ONgolFwXGUwHQa9c32iEcofHvchtzoM8LHSts9idO8K6Z1ZYfpVCvVJxkVVJwia+o+/j2Vshi4sVt3cns3F7Mo3rOFHr8bXdJmMKxjGp/MWkes1dJpVIblL2U/Y2/4Xxnp5EI7Y69O0tBPAkBVsqHew5cuAHZDe2Z5lPF52g1as2mtw0hL/Ob1sFiMjAeL8s7SsfuO+RmuHjTV91YuOaukuHcJjXzuArQHvKCRbht6cxM8ld3miQQH9KjbldPmvh5SZe9XDrZn2CM0Bei112oQ1Otr9pV2iv0YbEFfdvnN2Eis4EqZ8iaYzBSEbNTTHbZ1OvkMEF0ar3MAPAiKr/ZsjdlsjaW4Co5mw8MHp5pFipHQ1ixpMX6JVkYLT/wnq5a/v3Wpvg96Jl1YBsFSyZQsR2Vf5qX/rkZu+0/oox7Kd8NvQM2nqLv4gMIlCNHK+1MgWvWL/iA6H8SJ2uG1P+nNgbreiyhEAyHvbLFDdFwV1Bd4v516/qHP7BMlr3kproWBVIMOhXWkC24S0ImxTp6iOoTbph96khk8rU2oju2nusnvJYmJYUb5MXqqHY+UF+UwFpOowC8ZBq7pujx+ZI2MHPkQchdQIha1jhGw3sru5X3WrOlq24NlHRTgbYheV7BolX4hkk6kc9Ohvejx/k8sX0Bwu04uVYrz+0mT1EphwjvXpOp+We6POz+5Rq4WcJZitVUXXPGfHV12ZFKD2mkpZNJXyh/46Co1uJJor3qxrrJUMh86Yunh0f8qx6WCVSVA0SWzhvO7cv+KvVJTguBP5N+kr7cv
 /3gkQRYl
 PhDE9kioRDRHT9d1Pn9YDNooqL4hgRl0+itgNt8nK7kZZDuKANtWQQ3tE2VY+54lix2jg0DO75DayrMAEDxrTkWNSE79UIfqTsSbU031AjjUFt3dI6mgxc3nsn/JVqf3nZncGrZQN1H0f0kWMhBSUA6p/XWtWt5OphBgANtOyIXj4firaXelWknQTNoW0RJj1ogG3KTYi3xlmKrNfb9GWEYxANQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 17:38, John Paul Adrian Glaubitz wrote:
> On Fri, 2025-10-24 at 16:13 +0100, David Woodhouse wrote:
>> On Fri, 2025-10-24 at 16:51 +0200, David Hildenbrand wrote:
>>> On 24.10.25 16:47, David Woodhouse wrote:
>>>> On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
>>>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>>>> We currently set a TIF flag when scheduling out a task that is in
>>>>>> lazy MMU mode, in order to restore it when the task is scheduled
>>>>>> again.
>>>>>>
>>>>>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>>>>>> mode in task_struct::lazy_mmu_state. We can therefore check that
>>>>>> state when switching to the new task, instead of using a separate
>>>>>> TIF flag.
>>>>>>
>>>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>>>> ---
>>>>>
>>>>>
>>>>> Looks ok to me, but I hope we get some confirmation from x86 / xen
>>>>> folks.
>>>>
>>>>
>>>> I know tglx has shouted at me in the past for precisely this reminder,
>>>> but you know you can test Xen guests under QEMU/KVM now and don't need
>>>> to actually run Xen? Has this been boot tested?
>>>
>>> And after that, boot-testing sparc as well? :D
>>
>> Also not that hard in QEMU, I believe. Although I do have some SPARC
>> boxes in the shed...
> 
> Please have people test kernel changes on SPARC on real hardware. QEMU does not
> emulate sun4v, for example, and therefore testing in QEMU does not cover all
> of SPARC hardware.
> 
> There are plenty of people on the debian-sparc, gentoo-sparc and sparclinux
> LKML mailing lists that can test kernel patches for SPARC. If SPARC-relevant
> changes need to be tested, please ask there and don't bury such things in a
> deeply nested thread in a discussion which doesn't even have SPARC in the
> mail subject.

Hi Adrian,

out of curiosity, do people monitor sparclinux@ for changes to actively 
offer testing when required -- like would it be sufficient to CC 
relevant maintainers+list (like done here) and raise in the cover letter 
that some testing help would be appreciated?

-- 
Cheers

David / dhildenb


