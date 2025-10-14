Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4239CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E40C8E0134; Tue, 14 Oct 2025 10:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAF88E010A; Tue, 14 Oct 2025 10:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA668E0134; Tue, 14 Oct 2025 10:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15BE28E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:38:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6346C0991
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:38:48 +0000 (UTC)
X-FDA: 83996976336.30.CB30C90
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7C255C0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:38:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LvqsJCqg;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760452726; a=rsa-sha256;
	cv=none;
	b=eEJPmEfcyWSTLN1/rB2UJtFePTScmPq9jkppXssjeAt+y1/C/qw6s1WE/GIQN5BpvzlHsE
	mPtfs65BTyfbfM9NEl+UYblca8FkgxqvU0ZkVGXhTfyZu+iYRkAjDVxIQ4eOt8b/NAABU+
	IVSqZBTITZVGDIGZq9CaiXEWLM1NAws=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LvqsJCqg;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760452726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYeRS6sFSfUzQPJ/HzyrxnFwO5qGv+xZs7JP4gmO3GU=;
	b=xc7YdqtNp3Z8bGsf9GU+B/0dfgdgwhuum6gzK/hHGLk4BLB+8vpwA+AlFwQIlr25YbOmlO
	/CozRIYUWY2iJLRTZ9GHGORRYhVE15cyQ/jj5IhSlFMoG95uD+s0dguXbsxZFmzO1Ti5c9
	X0da7DRu4yxqQxevMqdOPH+oups3jLE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760452725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cYeRS6sFSfUzQPJ/HzyrxnFwO5qGv+xZs7JP4gmO3GU=;
	b=LvqsJCqg8v+sIseZJ8iXh5awTPe1lnJspAOQYkTJCX+MdQ9nwJzQzUniJyUuGTglhfZx28
	UjWE7kthGP9wYFlmfyVkcRJBF7PScS0wGLjmeQzBQYmzUZydX5l5jNdPTrBExq177iVWn5
	akg2su8apKs7moKC6bJATX3/oFvKFQc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-wbWvGM84NUSv3-FnjaSasA-1; Tue, 14 Oct 2025 10:38:44 -0400
X-MC-Unique: wbWvGM84NUSv3-FnjaSasA-1
X-Mimecast-MFC-AGG-ID: wbWvGM84NUSv3-FnjaSasA_1760452721
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e36686ca1so50474185e9.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760452720; x=1761057520;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cYeRS6sFSfUzQPJ/HzyrxnFwO5qGv+xZs7JP4gmO3GU=;
        b=t0qw2HcIGjxHDE5cE6JVARgXhwUaUkbuqIdy4rx9QkyEf2VdBxxmzYnVGQvUA+f/YQ
         REUy0p9HofJKYmMXO4BhUPJeqoGrYUhAwxbyA4MP5NIlC7X77B1GAZ/W4qKuYo138lvj
         13EoRI7NeXiYhi++uYp3nzSd822MsCWwRez1KZCAaTDw/1/iYoiZGys7vqggEU110vOy
         ap/OFiOCPkW88p173xhlAxIqTSsFAMJJWzcWvLQhUO//X1/npLDbLOePdhzbAP9bPeRw
         ilEaK+LsJThGafIYr6AttFsb9I/2NTNVcKRL+ay8sGcyGjbw5xyKOgntYHw/n9X1AWSX
         ekxg==
X-Forwarded-Encrypted: i=1; AJvYcCXIde/0b6CA/oAiGO7YBmOCvzKRtxbYS/iJVbngpUi++SMs2H3ghXNZOgFaXJy2AMwjRqqm3osaEA==@kvack.org
X-Gm-Message-State: AOJu0YzMjXiM4Nx5mhmReHtLGOG/oQPQJZ09J1tU5I9WCeMV/anZ6TPu
	AO8OwHC9NUo1hnerv/64Gw/D8Z2XDR9eEGXWdsu34yB8jbDq8RGXg5eFRRUJqlQBA8ydr6k/T/b
	/ADCwt5VRL1i8AxG/RS9vDXjBboyI0MiNQnqodgMK8Ei+N66y2vOddGlgZEPw
X-Gm-Gg: ASbGncuwI59Hyw4K1MSlVTB7nqqa+NKO5rXqrcuyHlEPKHkGt+FNFDMZ5j8+cClYOuw
	xx+tSwuSdOetjwNDdeRYNpI+Toj4rLWSqLC6T8ADRdcWFb+kmIcNe1pglPTAhcLfHURTTLHXJuw
	nHfNY7JDvVueAccohAA44IFgypIgoykN2oepdmef03bhZ+hMtU6enq1E9/gMC4cXSJAHSe6ykEV
	ewYPaUbgNNkwnnJViQqeoUUJ++GTiooOHcCNL2L6Eh7Qylsl8urEcxOD2slwQmKkPPeFUEx0YfS
	L+qSUYeDjaXNxPVM0wE9kcEf8hmfbV/Ldgv8cy65J7Rmv+YXv3UD66gZrzLZLWGrD+6B5BuxSA=
	=
X-Received: by 2002:a05:600c:3b07:b0:46e:1fb9:5497 with SMTP id 5b1f17b1804b1-46fa9af84fdmr176220865e9.18.1760452720561;
        Tue, 14 Oct 2025 07:38:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqAi05EmmQ/BhcD7IJ1mPJ/c7tINcxGNCVLG0i5FW47498X+2N7oVmLZuv/vdT2Tn/vHNVhg==
X-Received: by 2002:a05:600c:3b07:b0:46e:1fb9:5497 with SMTP id 5b1f17b1804b1-46fa9af84fdmr176220455e9.18.1760452720163;
        Tue, 14 Oct 2025 07:38:40 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fc1c5227fsm183080505e9.9.2025.10.14.07.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 07:38:39 -0700 (PDT)
Message-ID: <f9d19f72-58f7-4694-ae18-1d944238a3e7@redhat.com>
Date: Tue, 14 Oct 2025 16:38:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/20] mm: stop maintaining the per-page mapcount of
 large folios (CONFIG_NO_PAGE_MAPCOUNT)
To: Matthew Wilcox <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Andy Lutomirski <luto@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Muchun Song <muchun.song@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
References: <20250303163014.1128035-1-david@redhat.com>
 <20250303163014.1128035-21-david@redhat.com>
 <20251014122335.dpyk5advbkioojnm@master>
 <71380b43-c23c-42b5-8aab-f158bb37bc75@redhat.com>
 <aO5fCT62gZZw9-wQ@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aO5fCT62gZZw9-wQ@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fGUVoj84SezlkwL6KMLfoYzIN5jorQuHtz-Z5OV2Dds_1760452721
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: onw91uc61opno1qq8qhgg4a8xdtrg3qj
X-Rspamd-Queue-Id: 7C255C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760452726-663290
X-HE-Meta: U2FsdGVkX18ZasiaOP8sp9FxjepniIT13dZ+1RCboiCfLm6BX+57Tk8DK/43lYsZdzbSJh2wYlndaeAavZ66rra2u8ay9fkY+uUK+rzXwGuKUHmrkqit6uh8GA+Yq4SvOIAsjVpypbEPJ0aqVrKFFiRbGhvpw3UwOtFeWUtbe7JV28PIi+ygjBwCA7AfMqhEM4s0C/tT6fZvA7E/v4BVq9pM4JewCvR9yGQ30dLkw2xWCwoBG7/BWb+krvynSza3FUZEjmii6/y4JHcic9rDNdhAr4oEVNbNTurZSARlPJv+gItYatooVmmEEaFE8ruF7TQGBDBnsU36+Sg3AbOhUwPniGPtgDzbYdRa+JyZIG4LzaRCjz6YM/zj2pE7o6uU5vsqFJRoCKOYsFXl/W4Xv36JRgajakgLLssFgIhCy0ylVecFL74/PbnuPmxsRyW4MXcrhRdtmoH4PYMKBSVT2iyQOtrk6a3qS9Rqb3FGPYCBusqXRXj9JPjpcAqvU4FrKY/Sj1QEfFIF6wLu+T6vnWoWDtFyatttIRPavuFDjG12WrS00UUbzrZbhwcX9UxPjvZ1OTHfjT5iSXe2l3KUEjRaGthVWdl5DYNF0Q3AsXJcufEJfn+zJJ9Sn9uqrP35J2ZDms4DDUd2Zs/IC2SxlLRz+nCQsad1/6PQRXXzu8OU0EOueLIs7/OOGZI909Iadt+tRo1fcoPr7wQjNE933R2xwKDJyuQszR5aa0f7Th8xZG5ERlR0ktRYDWzEUsIWI2rbFC/SvT1XajCZzlYCkUgwkdDjIZq3JPd5KRDjP3hAry5mwHRm740n1gKn0DAEQ6FDbsz+XDp1CofR3EqXMFG7r+r4jk6yFl+5HAtTMuKFTc03FKLOdTli2TCSjXB0DyXV6UbNXJLVs3Wx05uhON/O7OnebiLzGpcNDvMVzqrGdHD1E7YFz/YfBEYB2nh7Px34swyrb0fNZAXY1l3
 3d6fWrwD
 ayiVSAL6jVFgAKQ9tAOsXBcON+BsScbNl8u5SR79NqhUG1gTn71MZP7uKlZVcr0p2eKjWJ61dszWeaQIGnsnkj55Zl/8B3OvygUvOoo/qr6u33WMV+xohOc2klP8MUK+R8io2ERuC1TCsWBn+XPNyV8S3hfFG8fWiCRjApvy6hCQiu+2QonkXjSWpzev/zIPcGvKTgTUlj4Wnt/vVFv/zugUaixJGAHJGl4i1zWyuhITkSfbaGFp598arfydTV66nN2AokFVOsmk4glu2PvMPZiUVFymBVm2lXTXd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 16:32, Matthew Wilcox wrote:
> On Tue, Oct 14, 2025 at 02:59:30PM +0200, David Hildenbrand wrote:
>>> As commit 349994cf61e6 mentioned, we don't support partially mapped PUD-sized
>>> folio yet.
>>
>> We do support partially mapped PUD-sized folios I think, but not anonymous
>> PUD-sized folios.
> 
> I don't think so?  The only mechanism I know of to allocate PUD-sized
> chunks of memory is hugetlb, and that doesn't permit partial mappings.

Greetings from the latest DAX rework :)

-- 
Cheers

David / dhildenb


