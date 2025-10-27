Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A797CCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 12:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E012D8004D; Mon, 27 Oct 2025 08:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8E68000A; Mon, 27 Oct 2025 08:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7318004D; Mon, 27 Oct 2025 08:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B58E68000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:38:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6164713B2FF
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:38:46 +0000 (UTC)
X-FDA: 84043848252.26.E44DB9F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 086AC40007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:38:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c6eRaNEn;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761568724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cvIQRmqmBNV8P6YdgjJbon9LLe8l/9b6yM7q+yxHTQ=;
	b=4AiwAi6Dtni62BoSNBl3OhmVBpRRHc/uG7Y9/AYiQuu2UA8Yh+DAzg6oBrSwUixunuxbSy
	VY+j3ullcX8fWubIPM12lVkF3DoH6J0efYdP19XMe5YMIRG4w3TQ9tadhP6TINLJjaweTM
	5ZJwcOUlkbTMwX21FSZe08LKTiJrUow=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c6eRaNEn;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761568724; a=rsa-sha256;
	cv=none;
	b=IAxYrSsZ43kIpPmwkiZAgpqRMOlpDsxJ6gbqYDMRKg6SfNze9XMnbtC10lwtCaWnXTyYIA
	npbcXkzrg0TjeNGiv075B0rt6rejNhbGUpyJAs3y307JiCilarYfLLRE9C575edA2mnRfo
	p5OPriWR0a2DC0w/1xxPqk2ofK2S4Ho=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761568723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4cvIQRmqmBNV8P6YdgjJbon9LLe8l/9b6yM7q+yxHTQ=;
	b=c6eRaNEn3DkmXxywCs1O2CdnP4uVd0uKWqn8MuLxzrLgdAQolpaobJhMWi8VS0JUkr8Qpt
	UoFYqTVUzS8EijmomEI0MjvaTYvZTvy+27EVmx2ybQTMKgs7VXXc9dEDafQ6364giwt3kH
	IA01NMC0f0p6dCq3j974ufLpu/lOgF4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-MHD6dFuZOFCm1_FJ77nkSA-1; Mon, 27 Oct 2025 08:38:42 -0400
X-MC-Unique: MHD6dFuZOFCm1_FJ77nkSA-1
X-Mimecast-MFC-AGG-ID: MHD6dFuZOFCm1_FJ77nkSA_1761568721
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso31755165e9.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761568721; x=1762173521;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4cvIQRmqmBNV8P6YdgjJbon9LLe8l/9b6yM7q+yxHTQ=;
        b=Fuqqd6ygOQI8V23gKvBV9kqQKvjsJitvM+CGYLtZJwa0Ml6GvENUI+VTvx67Sj0Dcn
         u1MRuJbsf+k8aHoMLWGv6AyzcFYogZskQ0fxKS1JV0Se6iwfB9QdVOJy4TBzvts7cyw7
         oeE3zr8XCemnPUjdxo5QQdIeSNkR0TEribhsWfNOPN025qZueb1l14JMJFGguo5axPqS
         Z9aWJe7OWrDHGxwZB2Ui6bTQC6rWcOEJ1y6RgBFS9/nr55fCosqoAUdT/A/8J8GKvwqV
         w8bBefENcdTX+R92vE0Ksx359BtWK8y5rwoU2CQRoaMjvzMisVi/XijOr8L3dlzqG9q1
         k7Xw==
X-Forwarded-Encrypted: i=1; AJvYcCXRiPohYhnBTQfIK3ArSN20LFhj+LSDHByQeYKOv0PdoKqKkEfvLdBsPeiqGz+nIdOa0+KtkejC8w==@kvack.org
X-Gm-Message-State: AOJu0YxYEcUcMs7SKm9pEKGHK0o28Xkcs1fU8ClUBtn/b3gwoYn/sylq
	aNlKe6+p8kPJO3xlCK2BY4Bz6u16hbo5vs3FvTac6qCbURZqk7GGVMPu1qRXk6C8kWUJVvuFXZq
	Oe3p/nzLNWbH0AIJxkTa+ThlN18Rv0re/Wx1YbRkoLh77UkXDhOGe
X-Gm-Gg: ASbGnctQh7tSMEy1RG1oetef0mllMUjL7DlWNibhotlz+HEIXiqi4Oz/GR44w2Hat2P
	V6V8d9OJg/1n9T+4qPuqsP4bMYQ5Ne6f9giYi9/xZJufmrDvPHPSpwF6SSlGBB59p8oxFCZuJVG
	jDapu6bhUAKdMYx+leSSy0HvHpoZ6iE9GfWExCXhoZth/uHXVb2SEjD2Axgv6vRqYztZ5DFUwt2
	XcjbdEcVnfzOdYPt5gHDxXFQMtW+7O+vx9L8JgiUF91qmKh8XZRpYmblcjhkGLCRMt5OeMVyCSy
	2YZ2kvODO2lKnx/w7llpcOBQXaO0A8m0WyhREWgRVR23Ong5nWFuu/gbGe8rsXx6X1jKjsoPuWL
	4xuj31Qk6dI1aUcbuVyEtGc0T2uaQElQ=
X-Received: by 2002:a05:600c:3b03:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-471178a3ff6mr279997765e9.18.1761568720551;
        Mon, 27 Oct 2025 05:38:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9bbdh4PWkc2jU/rl4KkAQD2PqCSpwK7SfjvxDRuSE3bTT/1W5umiWwesFjMbMJkHNKlChlg==
X-Received: by 2002:a05:600c:3b03:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-471178a3ff6mr279997395e9.18.1761568720112;
        Mon, 27 Oct 2025 05:38:40 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1f1cf.dip0.t-ipconnect.de. [79.241.241.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd489e6dsm133581265e9.6.2025.10.27.05.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 05:38:39 -0700 (PDT)
Message-ID: <7df81ee0-1161-49f4-a93f-4d9245d48e1d@redhat.com>
Date: Mon, 27 Oct 2025 13:38:36 +0100
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
 <9faf750e-2369-4fae-b58a-ed9052cfd6f6@redhat.com>
 <1d9f416fd3665faf27841b6305b1e8d661427125.camel@physik.fu-berlin.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1d9f416fd3665faf27841b6305b1e8d661427125.camel@physik.fu-berlin.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P0u8jXzPawy8q6qfjlls6YMFhnoM0iAq_zqofOF5rng_1761568721
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 086AC40007
X-Stat-Signature: rjfz9fod91fa18mbx7qd46xfgh98bgyn
X-Rspam-User: 
X-HE-Tag: 1761568723-349135
X-HE-Meta: U2FsdGVkX1/z52TwGVqmp7Zsh3WXxzDIzssgH977qn/DqG6q8kRE7KiMzsZSbDird3B4RnfSezVJWP3G1D/W2jB0So35mvLVD3Iu6vTHsEWrOJoKAapS7zYi1GcEs9QxYrq4d+2JROgA3vUYWjNju2c4cNs3PRkRBW4bnt881ncukD5QlmyrIo/CVcBWMv5EH0dXm1KCHQ4yB14c9NmH+YrhbxvlSUVRIfj9Y5UvWhVS+f9mq7iLKrIVqYeJsId7V9S4ESYXAv1TAzsMOitwonvlowJS1MgKg3FDTw2L/qos8H6w7RKVhQwAsAcSUkBy9ApzJx3L87MYdvoreS0VPgofp3TtUb72yE1maRXKXiijZA6KYqbQfI4Y+taCFtx1z2PWHMPqOQ8L5TNkW8Hsn/MB+kqYiH55pwU8yHQ7z76IbhVwoOATm2D8z+HBYf8seTwtWG5qpOV0YTpKv+FSRSerXtRMFurZpBhJxXXXz2j1clqfFa9oQRn77iUvEiIzDG63n6RzfOQmCyVwSrXmaW1ZrViNilwnue4necHG/GdO8r9Fpjce+E42+wxXlEnSp3/olWt8R+d3QAHwQd3SpefR30K8mXOLF3VcUPOPbnfaDlHxD6gfxnUNjV4NQZvC4LUAFcjKl9rLiWB0A2xzWhFKMDT9JpdkNQPK0Tujq1balro7De3v5FOanud+fRj3jJczI+7p/ptxHRsskmc4hiOmTXVtQUcDsLCu0sirguhWj545317Mu9SEGBsJP+LokdhG2GH4LsNNT9Y65ohCHUhPFdBSVm232OZ6pKWhRBp8VORGL13f5qyAAn+d0FeIQ0Jo+LFnO0+uNWxuMo9tc77ZhpEjz5knDyP/Yn+epe2X8N/MTB1L/5c8LGf/XBWdfjSvSMCrP+9VraMEUB+w6GwFeru3oFj8EVEr3Gq03aBSMzex5f8G1KPyck0EGkPb2ZcgAjI9A45QGtwP1vw
 Ar/ZqwA9
 9aMF+7Cg/Dbeiy591vp7rAU2XL6bR+AQz5a5iPpxH8crGtziI/RqxWujvw8UGkAw+53bpSdO+Zj8F3/o722XO6JhXuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 17:51, John Paul Adrian Glaubitz wrote:
> Hi David,

Hi,

> 
> On Fri, 2025-10-24 at 17:47 +0200, David Hildenbrand wrote:
>>> Please have people test kernel changes on SPARC on real hardware. QEMU does not
>>> emulate sun4v, for example, and therefore testing in QEMU does not cover all
>>> of SPARC hardware.
>>>
>>> There are plenty of people on the debian-sparc, gentoo-sparc and sparclinux
>>> LKML mailing lists that can test kernel patches for SPARC. If SPARC-relevant
>>> changes need to be tested, please ask there and don't bury such things in a
>>> deeply nested thread in a discussion which doesn't even have SPARC in the
>>> mail subject.
>>
>> out of curiosity, do people monitor sparclinux@ for changes to actively
>> offer testing when required -- like would it be sufficient to CC
>> relevant maintainers+list (like done here) and raise in the cover letter
>> that some testing help would be appreciated?
> 
> Yes, that's definitely the case. But it should be obvious that from the subject
> of the mail that the change affects SPARC as not everyone can read every mail
> they're receiving through mailing lists.

Agreed. One would hope that people only CC the sparc mailing list + 
maintainers when there is actually something relevant in there.

Also, it would be nice if someone (e.g., the maintainer or reviewers) 
could monitor the list to spot that there is testing demand to CC the 
right people.

I guess one problem might be that nobody is getting paid to work on 
sparc I guess (I'm happy to be wrong on that one :) ).

Regarding sparc, I'll keep in mind that we might have to write a 
separate mail to the list to get some help with testing.

> 
> I'm trying to keep up, but since I'm on mailing lists for many different architectures,
> mails can slip through the cracks.

Yeah, that's understandable.

> 
> For people that want to test changes on SPARC regularly, I can also offer accounts
> on SPARC test machines running on a Solaris LDOM (logical domain) on a SPARC T4.

For example, I do have a s390x machine in an IBM cloud where I can test 
stuff. But I worked on s390x before, so I know how to test and what to 
test, and how to troubleshoot.

On sparc I'd unfortunately have a hard time even understanding whether a 
simple boot test on some machine will actually trigger what I wanted to 
test :(

-- 
Cheers

David / dhildenb


