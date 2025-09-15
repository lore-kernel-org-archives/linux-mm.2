Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C7FCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820368E001B; Mon, 15 Sep 2025 07:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1118E0001; Mon, 15 Sep 2025 07:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699498E001B; Mon, 15 Sep 2025 07:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 553588E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:16:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2011C11A77C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:16:31 +0000 (UTC)
X-FDA: 83891231382.17.D114400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id B91B6180002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:16:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HAA544ER;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757934988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9VHMJIScHKfyZnHIwgFZKoZs2/TRCeiVl6qpGPg0Ts=;
	b=642gG3p+nI99U83+iDhQV2U0LdA5KPymnyTKDwPgs1NEEAdplmT508hyDjV8g9D1RZKY1N
	s12+ljuKY0Csl6W66qxprStZfDO9E5jdRxlg0bgbaSWoHsUVBB3/R2kj2qaim1ygWx8uG4
	MDTE+41zvNFF2x29/o1r+x/XUQYkZF0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HAA544ER;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757934988; a=rsa-sha256;
	cv=none;
	b=oHsHTFXRxL7eAeAkWF3lo5SntRF4tnOqqbnxLGk4s2gdWlZ8Lx/k5uly9pe/wp6ED0yLnv
	p3VLRiI9opJ06OjLcMlmlieXivl+CYGEBRNb1j1zhjE0XOUNtH/KPZ3rTXVMmXs3JAGU2C
	7lm7Qx1UORMu6KsTYxp3DahmjdASDVI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757934988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=a9VHMJIScHKfyZnHIwgFZKoZs2/TRCeiVl6qpGPg0Ts=;
	b=HAA544ERNVwsC/JhzI2O5vHi5oU9v1bL4k+x59wzDr9PEKWoJ0Gp4iBz3PDUbfnljnCvFv
	wfpp2OE2pZgFOl4SdSume+uFqwybGCxtBOjOzAB3IyDPma+O8X2xvHSbp9B1kMtO/MBAbN
	n3f1+mEjIUjSFScWndZFuRSVKoZU3TI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-R8kMOyiFMpG37hAJaSuUJA-1; Mon, 15 Sep 2025 07:16:24 -0400
X-MC-Unique: R8kMOyiFMpG37hAJaSuUJA-1
X-Mimecast-MFC-AGG-ID: R8kMOyiFMpG37hAJaSuUJA_1757934984
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b986a7b8aso29605705e9.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757934984; x=1758539784;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a9VHMJIScHKfyZnHIwgFZKoZs2/TRCeiVl6qpGPg0Ts=;
        b=Ls4bd05/4A3o/+ASXkrt0E3ldVGfuAOze6yP0MRmUQXP03vIr0IHLa9XvjsiqsckLU
         o3FJ3s+FzdftqW+WXqZgudhWga+8qGo5RXdsH66xqv7uPza82vTtnXWS+43J7KGcuXIQ
         8VNou6RTcozjNirKbTYipoojEmwX7QU8ui1HdzGcgLXXB9o+pfBoba+2ZPdKPY+uzcd2
         fOAvwUuhA1AWxK/v8ctQsG2KW+f/LGGwcFzvZiV+WRAlxkdk5r4LIJ34hGLguiDACAjQ
         oOCQYKXBuQ7/KWxCP+6tqJ3Yfr/+MhgxN1VZWCvrig4hBB1Fi1TSbpfm9rDVs96lif2K
         fErw==
X-Forwarded-Encrypted: i=1; AJvYcCVALZOEVPQTFqbiLe5gjW9MTpVw3jczztVHH8KUsXw2g8qLIRLc6Mb/Uigxocu1ADbktjqYjY19JA==@kvack.org
X-Gm-Message-State: AOJu0Yx7eViePlD0JV213ARgz+jqwjbcKjEGAO945eZK70/f4IspCkIB
	mCxVZDJIol7ocl2ANc+atrSjFEopXKD9m47/4BPuWCP/r8Ai0qiP70OLY6DSwy6O6JIENVWAq8C
	YBENJzYbEgB6pKvTUdhI0FLT0rkLzXwHJuXKCkcNi1wHV+GoPVcFt73jncqsM
X-Gm-Gg: ASbGncsB3lWBqadE6uj3DjVlRmHPns5X4PyN+BUbaXrXgh3hjFzKq1aY5l+80pXv/P+
	H8zfV1cufm71POWEyHEiramXQlTX0H65nr3W5H0L7FMZV718AjqTHcymPJgPjcLdkzoDdLlTPvR
	YznuPJvmrMvm9AjX3/rDZEo92Uv45Bx+HB0cfGKLsPC9e0GCEMQdHOrvKl650uBSHvQN9nf3zir
	onhQAuLt7M0z6NBEJwX1LjM06hN/cKwxIL4D+HQF9LUblyfogMzDuqfaDEv5CzCoKW9rC+Ct5t0
	Yqdn78gQyvhTRQdR8G6lF6jLg0NFuAbaAkE/fABP2L8u11SniqYlmkt4n61BOgxgOlaLFsV1AKG
	D5JPUXRRqy1T9EMI7KU+DdjXVguiLSy3XH90iC9bW1NbH8UpPZDIakOt/tUkueAxey4s=
X-Received: by 2002:a05:600c:4585:b0:45c:8e6d:a45f with SMTP id 5b1f17b1804b1-45f211caa28mr122688705e9.5.1757934983660;
        Mon, 15 Sep 2025 04:16:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEG21FJvY8SBizXlRClZvA3kmKzKK5uslfzuqwPWbv/g2k+5nh8fAMnOP2RGfJj6Isnts61Hg==
X-Received: by 2002:a05:600c:4585:b0:45c:8e6d:a45f with SMTP id 5b1f17b1804b1-45f211caa28mr122688065e9.5.1757934983229;
        Mon, 15 Sep 2025 04:16:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e03719235sm173781695e9.1.2025.09.15.04.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 04:16:22 -0700 (PDT)
Message-ID: <546d111c-0814-433e-b6a8-600a1065e3f7@redhat.com>
Date: Mon, 15 Sep 2025 13:16:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
 <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
 <34754ca4-fced-4a3c-8ff8-c00967d487de@redhat.com>
 <92352257-5be4-4aaa-b97f-c4e879ac6959@lucifer.local>
 <de3f5502-ef81-4f44-96a9-995e512301a3@redhat.com>
 <5099d9fe-4a07-4acd-95c8-782ffc74df37@lucifer.local>
 <1312fa3e-88dd-490a-9e07-9749c625933b@redhat.com>
 <c2f129c5-7a59-46b7-8fd6-0bb052e597ba@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c2f129c5-7a59-46b7-8fd6-0bb052e597ba@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MHaH4P9XBXGeYtgYqKgq1veddnc5l81iJO6nW2L9C_Y_1757934984
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8mdfarh6gn9wpocjwbu64aim8ocn4n7o
X-Rspam-User: 
X-Rspamd-Queue-Id: B91B6180002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757934988-981692
X-HE-Meta: U2FsdGVkX1+PvmJ5QC5A6AncaPEMAAR7bzL5SPB/ZgHRlMXci/adHq4oPbqNg1tTVWSXdwiX8S4FbCSdgLoH1SEFsfjPKexi8rfmBfFA+c+Y9vfAdDY4wj3iOf3JyGe98ZrxZbWrhWtQTNphU2rkJTLYKrzNOhEf5+5Nalw1CzCq2P2m3V9RhA5ZDSKVT1SQQERvWYVcwjUdvdOZQGAC9NlFwdplmIusbRHKfcf6qKIipeODOzqDHwKiW8SY+bBShH9a8Tl5ZDFgh7ZQnzaxVI8etnpQtl+xYNpa/+sCicKKg00FeCd2vA+6sMod5a5eU88XdhMxp4wwW+1bX12mHT+IPFs7Yi9ZtENIZmxmwb9F0cXjtsCCkKP/QnbTQjnA6wkvGMs4c3G4U50yMPes/AYeXSLJy07Be5xHlcsvIEXl5d2AUC9wZkJsg/dpSJ1vdMw85IhprEmZ8ZHDqTCJr6eGdILoKsMKYCCBTOTHPOx1NR5mX7E/VvfC0HokeKJZOjOftv7Jtp/efIElOOuFJvVLKXoEWoWrHlBpwF+p5nkQ4zQok23fwgXbaaPQRswIt3iNQcW26CNhzdf+neP4GdVdZckITNxwd3fAzgBz7UbFrD1aiks4cFp8PNVCfC+wYnB9IxZ3q0EFBTrz4l/Ui848GZfZXfTPKnVG98v6MdNZf8um9q/gHRp3UPeF6DC+UjRSC6TZjBnReyAwIz8WqNbpSKh0YKHfp1nllJfAX2EuwphjAFqbdNNuKOFef+8gighZZ2vfuAqtdnUv9kX/v2u12HNVcwr0lfFw2UMC9BzdYPQwSZisYRpqyHLDf7ZHOk0Pfm1dwnMlk/fwsrFifZJ4BI+ASTYQI483uqeEr0v3kkcOIigSHklLe+RphkJd0ww1kM3i6PpVb37PGJD2Gv45iCJDzoiwNacmHR1hLZIV11a6+nxI51NeYW067qndMaNgYQAm7ETDWnBeAFm
 o6mxXmxD
 qcYdJqhGZr2kUuVbR7mz0j+IPuEkaWD7MUZKklfJf2tWTba/PU9+sARyABDAxfDT/WkNXNGMusD/0BZxzuTYI7L0+Y+xqypnxS8EbJwbqljqJb7yRQT+zo5jz2LFm1kGmYvmH0HaXcoDxz6iZVZgD+vl0kJNvbk9n6ajMHN0btMinXFNKmujEyG+p0P58e9p1cAhur5VDf9PWAje3t72N1LYvLZHSaAcL9J0NvMwYRy7bqjKPeEeO0mMOwKQCcKaWqhKWqJDKdSYVnxN7eG3V3SioB5Jq8p6EclCyYsIzTR7GE/EQGQmkvTtLfQVxkQc4blS7PisPa9RckHCzyXf4lAo5zhzbQymYchzQbl1oKAtXF7JjnQLrQJJB33s8Lv7WK+NynC7tg4HxU1kOpfPfYFMebdXZNu7TAfgBbUQwKn8x+pSe6qc5y9fiX6aGFVfqJtJgV31b3yHQWD+vCBdmIhKrSfgBQyypMC1AZKjxVnNqaSHLQm6jsufKRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I am afraid we cannot change the parameter to ignore other values because of
>> the interaction with the shrinker that easily .... we might be able to
>> detracted at wait a bunch of kernel releases probably.
> 
> :(
> 
> BTW 'Detracted at wait'? :P You mean we might be able to remove after a few
> releases?


"deprecate and wait" :)


-- 
Cheers

David / dhildenb


