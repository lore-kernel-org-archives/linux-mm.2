Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E7CC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE708E0003; Wed,  6 Aug 2025 08:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEA68E0002; Wed,  6 Aug 2025 08:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376498E0003; Wed,  6 Aug 2025 08:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23D828E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:39:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCC22135F09
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:39:55 +0000 (UTC)
X-FDA: 83746289550.15.81087FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 72CEC40003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:39:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zl3gHH2q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754483993; a=rsa-sha256;
	cv=none;
	b=P9E2qf64AKCNTxhLSxFk8QLH3kDtZYe7Z3eVv3X/yX9fSBwj3DmlpNXn9up0S5DVu4DBeb
	tlVuNxFP6PY03kp56Iq54Ix0bw4wG3dD069klRPyC+84jyJvZ+fslDm/Q0XlEQl4FhDGm/
	asLKfemJ7kXgF7K6m9u4ZWTxCcUus5k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zl3gHH2q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754483993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dq3kYI5HK3O93EOgOfHM/oi6MB40Y2+T6PoWmg8sCFw=;
	b=UwcLS+g9B4kHmT24lOBg/OWZ1T5T97mLSZgVzRoxfAgHaXqP4kHSiyseANyaFaI+hjVsDN
	lLDJqmMqOWIK4CIX0KpLXe3qddpWvCLm8wnSqbBKAalaiE/h4+6MfmxHi4oqPRv/WOlmGq
	grht/++ZXTU7vOXpHjL3697g5qFmtWg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754483992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dq3kYI5HK3O93EOgOfHM/oi6MB40Y2+T6PoWmg8sCFw=;
	b=Zl3gHH2qmn+hxgkdclpgfOi9coNA6b4fF6oZBVp1Stix4t/ZiworV30D3pZ7C6LvdhaGW5
	T6G92FnlsH8iD1mQwfxCPM9z9N1v9FZHIVwRfZ8dzAWfhDEHZLBxg/i8P52YJ6wDyIwtc+
	dH+kVkhaOOcQ6skD/XduRh5QwKgl4R4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-eoZMBzmeOiu17-G5FOsOuA-1; Wed, 06 Aug 2025 08:39:51 -0400
X-MC-Unique: eoZMBzmeOiu17-G5FOsOuA-1
X-Mimecast-MFC-AGG-ID: eoZMBzmeOiu17-G5FOsOuA_1754483990
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459e6c564fdso4005205e9.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 05:39:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754483990; x=1755088790;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dq3kYI5HK3O93EOgOfHM/oi6MB40Y2+T6PoWmg8sCFw=;
        b=lqvEP6lbx857sh1jMhoJJizcJD1Eru+NxRNTqNFR240s4XvkoBqOKNzXcXYDEIEhF1
         Wy9o0YFxV2grdVLRo4zp5JmZ7vSIOJmdQxSbabZErUxcEHMfqZwQTOPr29/FY+ySMrKg
         OQwIs7R/gF0q1KG/aEr5gwzPzTsDdBdUwdjU+xCRYuaA4liSjJcKgfYemRDghB+KGBmX
         R8n6mFz7c33mAOyEK7bhxoe3tz5bFH3GqDHePZhOq/dnYpibzsob6eCL+LMgCFYVDj3t
         gL57nxDxYugEUl8DkT9jvnhmwjfh/76+q0d3kszpsLgYwepwwG9Rn5+ID4+N2X4Y6tHF
         rxSw==
X-Forwarded-Encrypted: i=1; AJvYcCVd7K5E6l/uP3YUOpNKgifa5yxOvtYZ0Go3IA5XidWx33XR+w94X9rtFiSXFRISsO0JoZKe0TnEKw==@kvack.org
X-Gm-Message-State: AOJu0Yy37V1IRZvEYrw9Z7z+CSlL1e1K/wfTHl1drk5wmbtJKCJanmrg
	HCU4MShkr7IpIO45e5+sRZ3kRI9d8spH2/rbRAfj4X2u9ymOsrcbQvfoUi3ARXlQXhIwC5DBC5E
	z0ninlnDL5LeSIjaKvkl/JCKCmJL+4374jFt/G1/OhUeNohzFs3xB
X-Gm-Gg: ASbGncsNQuNgk+ydYnvSbA+nrU+NLo1zZJo/XFcpyzchrO2G6GuejlkGyIb2RJgA0dB
	K+uDsSWRF2sYehXgOwmqfELUsbKsjPesiGoywzfJqF5doH5kpOFcSspHZjBSuvT6P+U+4qYnKcy
	b9C61jQb0ijdwy+T26AmyWJ711RXjm1RsDgD0fnrJdECIIFKIYG99aSKEZlaXxLVnaAJvoGNDeZ
	JgVlsiP1Wyuh1doDKzfLAfit/536IVnk5pYcd5G1BR80nDQGuPKwM2lMbNTjqyxYlbE5TmtOc2S
	Zy9hayUuLx4GNg2rHToF8y3hgbqbGmKYTfF4ndUvZIi6YDSs7SCzDQm7EGHdISjVt2c+AKEstb8
	Je81hPaGBPLrIpcKT1OC6MIMWTc7OMPq8vhWGFK4Lr8KufSyLlcRa54iqV1QDXULZL8k=
X-Received: by 2002:a05:600c:1548:b0:458:c002:6888 with SMTP id 5b1f17b1804b1-459e7136631mr22257295e9.32.1754483990297;
        Wed, 06 Aug 2025 05:39:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5yC7NJDSBWnAow++Fd5516IzmalIqYHg7jUW9fhwmcOZqDgH4BiMCVKhK0XWJf9PF8IFZUQ==
X-Received: by 2002:a05:600c:1548:b0:458:c002:6888 with SMTP id 5b1f17b1804b1-459e7136631mr22257005e9.32.1754483989778;
        Wed, 06 Aug 2025 05:39:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48de68sm22959311f8f.67.2025.08.06.05.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:39:49 -0700 (PDT)
Message-ID: <1a4df59e-e734-4ff5-b1b0-0a754afb6f67@redhat.com>
Date: Wed, 6 Aug 2025 14:39:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
To: Jinjiang Tu <tujinjiang@huawei.com>, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, akpm@linux-foundation.org,
 xueshuai@linux.alibaba.com, ziy@nvidia.com, osalvador@suse.de,
 linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com
References: <20250806020520.631203-1-tujinjiang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250806020520.631203-1-tujinjiang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bbN_S7EV7gBuT28sNrCXPkv6Qeo_noXFG2PgpuL4Nuw_1754483990
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72CEC40003
X-Stat-Signature: ani5oeou3hm3t6ky55kui1qeej11bta7
X-HE-Tag: 1754483993-786815
X-HE-Meta: U2FsdGVkX19ZGy7ie4UjsJhMeTSo04kjuGW23BVm/e2jwicv+l/ah/V1ZuW6lJ/BIKykZO6br0oxNiVOulZY/Lp7B7DPinWdoVC0af90FExexT7w/iwGN7o0gjLd0WgKSarAcqwJpcq2sGMzQn0jHUefDHNxTp3HdqxhFoXQJ2MiUy9cwJYqbs2ohPinaKfGZ6m2BL4alw8U0abVAF6uFTgIw24t0MN1ISYcByD7uevfN8LjFP7a9ZED3x+tc29du/ScIzyn2+1u0vZ+K7hI8KWhqz8Rt+89QJ+i9CnprTCSuQ4WZ2hTCVKc+XZX+HgNu2vLGNVmKa/FYrUhNUA/nzeEvdawSpz90RNWWDeCMHUQD7836iV7g5JY+AVSSD/25M7AB04epmZaomynxnthTqT4oL/NIswt5VShPxqH13uxtQpl9YqB0AxMzC88LXg6vIIxj32baY5qhGfH58l93VQqUuDaDkYcz3Co5tggplll1e/X2Kx3yyhQdI7JlYh1pilasGQRFzDjm0SvyHZw1c8Tkh6nvVtVq8VXz449zpQ/Zsg2u9RjPrIX4INcf02RkRQFJ2VrTQcyi2R5SVCIsmuKSIMv1B/dt7QbvzER+D7Gl2qktg4KKtcdY+2/SHwiFGbbPSSmEpcyKVHhiHqHAUzcK9OT29UMLeRB4K4P6OigGdeIwXjhMYuWhQM4XQ41hyV0IIjS8+ao1GjSFb1zar/vV9BNw5AAAszX8P18DU5jFEKdqxLk7cKjR9+5L7rQb74SLhXkvTqLN2UW6WMC2fWFSaf9zCV88F7r45bBw5WcCl+m3tE5V7GBF3CdksBPnGkWPtLpkTvLxiPLzcqZFQu5NYn6OqbmBGwuEGBcCXg+y1HcDys62065Qbrm+DU+USbLREz+YdESaOIIgaF0wF/9QvIiMlt1C1fDLDPedm8vtIwaxxFfVl9s5XgnXsnD4K4bILh1XoW2crvPy8w
 KNX528Es
 rTkFCywXfFpDyJWiT39WmzSKiJAbzinsB7P+ISTB743MSPhH7+OxNfbwbBougMiiOLIUoXywIMyZfAy3G9qdp+meqUP9Rj3tmfqJ26CdKXeTCiEs2nxQb/A/NaSx7/xiH9QQ+3ekbszrRvOS1/weFeKxZEz2mHLBWGJynCX7UDvz/Vub1mdj6Ie4mh+d4NrufHNZt8X5HlyI5cTU/3gZeColMuXFZD1Sv3CkYueKNRj69aJh7p45MgYmfnuMeBr92R9T+bL2z2HUlROgC0MNufYG+6t+ZaZW/NF5HEih3VOGv4ajJhxODNjx6/mKt2ZJHsrQ9+kCWhgaGQua+axpRh2vWlDs31SYL3r51CFfrGjthgcxM5Hcjc3cH7XhBTfE4p/5sLPBf7TVBTKcW+3+TcxRuOD8EqIKPhPSgBHWS0jolu2lTR6ltcfcJH8o2v4tPWDa7+uiy/NVNe6VZsluh12z9zRd4FCTgSiCX3uzV0MetxmqH1KHwsouj1/JO2MSnUj8OrUkuX9s/odLhk3a47RnNxuuY6TJxFYCh9Gmh3qhrl8v4o5Qqal2ctk/er1cB97Us2pkwWQ48jRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 04:05, Jinjiang Tu wrote:
> When memory_failure() is called for a already hwpoisoned pfn,
> kill_accessing_process() will be called to kill current task. However, if
> the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
> the vma in walk_page_test() and return 0.

That check is dubious and it's on my todo list to revisit that, because 
it doesn't make sense for COW VM_PFNMAP mappings.

But I am curious, is this about having an anon page in a COW VM_PFNMAP, 
or on "what kidn of page" do you get the fault?

-- 
Cheers,

David / dhildenb


