Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3250CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 21:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E056B02FC; Tue, 26 Aug 2025 17:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15966B02FD; Tue, 26 Aug 2025 17:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05656B02FE; Tue, 26 Aug 2025 17:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC2126B02FC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:46:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6332058714
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:46:00 +0000 (UTC)
X-FDA: 83820241680.15.69110A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id DF6CF10000C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:45:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P7thbh47;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756244758; a=rsa-sha256;
	cv=none;
	b=smlDMQ5nYKwuyVDi7NEm5E9HbvH9tKgp4j3U0O4YcBpetfFLMkIQnbDqVNIFZZfDL+Mjrh
	StHsEyKHHsn/uw+pF1e4GOB0q6njOocjkmtA0h9ufNL9nkUBY8N2n9IBN5XIWxo7YhQwtH
	KPvRE8at9YUSPOLfpB+aOIG/baiKhwQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P7thbh47;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756244758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/vc4qp1pUCM7kmm0HrDCp6zpxDPynWNzUG6wIf8EQM=;
	b=aMPLj0a+LmSP4yaqJsNZ/d1stJPGF/W4gdyU53usc4Ab4j5lPCSMPz3VDJA16Twf/Q0U2s
	ph7SlJp14gDE8RiE6vRCscPTV2G09osBwhExh0GCy1Jy306gsehD9TO2/Ejo3aHlNBdtcL
	pq8KDTbz5PIiWwkiWTxRPYsmiD+MtjY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756244757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=a/vc4qp1pUCM7kmm0HrDCp6zpxDPynWNzUG6wIf8EQM=;
	b=P7thbh47UJtmx4xMoUiOts1cVNSzCX4y2qQwUqIJi2iNa6D/Mqj2lqB6hj0xggwRibTj/B
	v1WI+u2bR8ErJf7hMburZP6UbLaQpYUTbuZxUExhbOQ2+QgEh1elE5eqHssFnj8+Cphp2l
	hxGwRJyz1SibzzZFS3pKj8TTSn3CI70=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-Zs9lXEAwOlGi2nJ7t6sE2g-1; Tue, 26 Aug 2025 17:45:55 -0400
X-MC-Unique: Zs9lXEAwOlGi2nJ7t6sE2g-1
X-Mimecast-MFC-AGG-ID: Zs9lXEAwOlGi2nJ7t6sE2g_1756244754
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0514a5so26966325e9.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756244754; x=1756849554;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a/vc4qp1pUCM7kmm0HrDCp6zpxDPynWNzUG6wIf8EQM=;
        b=GI6MLD3ODpnj/Lqe9s4uklPXryrJ3XRwKPDvWVwVJkcoK2iwhd+2SS1sFL+IfsAqEh
         DR4S0C0zylOmzF5PgJ4G0SQyMXaxy2lNVrHvoNUOf1bqtKRKKdKClicAjyHV31YpxBgC
         72ucO0PTrGwvK1O+oFkgXRRLzTX0YjSNFMUwaFp4j57jOAAPnFq48Eoyy7VIJ5r535QC
         VmNzJWWZPGi3gFqaChys4iU2T5RvL6I+SkE3bgDxgY9SUipNlftCcVwgB0YdNGG6k2m6
         P/TZdBXxjFTUGiGyByfVUhe+CKAsGu9ksNaI6/S7R6Bj0KbBf/Pp8qfgDbO0Y9Qx1aHm
         2GFA==
X-Gm-Message-State: AOJu0YzY3CRuFLP6k5ClwKfVtLJ+QdLa6t586AwP2HnjKqAQZvgt02e4
	cAYl6A87pC1syfdOH1ETZKqc35rb9Z3WuRJvtxz5wIzalQ/3sfEKZ3YbtBqlXltKTBHW0AZkaBU
	pSM/Bup22NJ2eXR9sksaIlgfag095GvEoheCNGrtTWPuPwYezTPW85YCCW19K
X-Gm-Gg: ASbGncsKZuLuWk288eqkNzH6XO6mUaWaTJXlM1RDKL+zJKlRUlb/eE99hq6uz4eJv3g
	/54AtXeGXlmubex8jK3d105H+4GR07MG+zQOjHBEoKZ8M0tEJfdg9tyKb+DD5EfRhMz7ey5zewV
	6CBH1SrhuEvfz11a/3T80MP/F2mDEz6V9I8IhXDI5KUvODAm4nqVYlfyZ9kv+mVDYrwEASPJrZV
	M7jiur/WWcKDrnasgYNbwd/On5dCwAHEs7fgoxf9JgFv7Y0SypnyM9b6liy8uloGDjHN5tl/RLB
	2PYjvjPaejl1aIPcIKd8w6soSv04D8iHBOHQCyANcEkImFpetkHS0HUGbxfPJhc2xFSJvy/SmFU
	fwZk=
X-Received: by 2002:a05:600c:4687:b0:45b:47e1:ef71 with SMTP id 5b1f17b1804b1-45b517f8e7fmr146285835e9.36.1756244754485;
        Tue, 26 Aug 2025 14:45:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEb/Aj6nbFuHpObWZu3G+WkZ5PlRw+qMiPwtTihkacz55171aqz2gqBvrSr559j9qTQw4SSqw==
X-Received: by 2002:a05:600c:4687:b0:45b:47e1:ef71 with SMTP id 5b1f17b1804b1-45b517f8e7fmr146285715e9.36.1756244754084;
        Tue, 26 Aug 2025 14:45:54 -0700 (PDT)
Received: from ?IPV6:2a01:599:91c:5f74:9ede:f58f:efc3:8b41? ([2a01:599:91c:5f74:9ede:f58f:efc3:8b41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0d7448sm2992255e9.9.2025.08.26.14.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 14:45:53 -0700 (PDT)
Message-ID: <a959a7f8-20c0-4c2a-9cef-ffad4f8b805b@redhat.com>
Date: Tue, 26 Aug 2025 23:45:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: make folio page count functions return unsigned
To: Matthew Wilcox <willy@infradead.org>, Aristeu Rozanski <aris@ruivo.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
References: <20250826153721.GA23292@cathedrallabs.org>
 <aK4EOf-EE43pi-xq@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aK4EOf-EE43pi-xq@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lpFILb-VnwYFcRR6f-pGqONU9AvAASi_eVGqwg5Wi6s_1756244754
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF6CF10000C
X-Stat-Signature: fhskx3muzxeb6djhcqrbtrn64u8gsykf
X-Rspam-User: 
X-HE-Tag: 1756244757-230897
X-HE-Meta: U2FsdGVkX18s5ZF5gsAdGGJp6iIBwP+YvaDGyUEOA58VK+YR5qOLhEH3VP48EWwl/FoUpVPS+j+Kw8ZJZ7KXs5MiF32bEjy5NY+EKTVoMDL5H0nAYQtYKFOeLvssu5bzE3lzL85E0/RaA0nuq+x4iwjrH4QF4tSVFydgskg2BoJsw8T1SaEr7q77DlJkFzjEb4hbWTZDYMc+ENAHUvCxalsOejzbcEtMgr9kP3WhVRQ4uo6ukBg1GchHpHL8pkdyL4In8l/RfdJSKOvcJY2ZqqgSFGZLNbuCwyDGQtzEUBN0swd3TPVvapFuJMRIr9v8FWSvnYopTvmQDrHOwkQA2u84FZhDmHWl7uhZtcGEeh70cM98TFx0M7964uv43BHSRQl/4UqYrAQprhu02eoXT1qSoxb6sUMUoZNpf5mdABp2fwLRaOaIl46CNzDuFscCfpl4WdEshPKend9ksRTt9LVdlTpgCVJxNUW3A4iP/8b5Do3xXSjcEWO7Ouj4u4lskgadZbRMFj36QYhNoqu7gWTc1MPCaOJ5YBY67aNBwNdPp2gpg71khK9Js8S76/Y3GilSc3TfPjw4h6JWQuYOvbUuZKY3DG6ddM0v7mf6L64djqiZFZDV/IlOWryLYMigY4HVpLXjLvs6C46IXI+somnqZ/gBZySIu5M3w5mQSADsU4hHx3cfT0Sur1bsqKh7c2jS91PhpUZ7kG+D1kw5xOpJXsk8Tcu/wp6XwcqJVh1H+uHuDfzOIuAKDjZ1gHDRBaP0BT3dw6O6LTwaOn3XZaTnpcmPPD0wfCJeaqk0hPOMin67WrNfuDiRLr1Lj5qi3B5FY/GD5JKbIe/XD6z9GEFvFKWszqHPtGigMXlvNckkC1tN29UCYkO6ovAG+Di87UNFs4Rzgdyu+SX1kzHzN+dBdhX9IjduKlGPicKz4icnIbDUSFNPhdK04+VAKrvRhD7sBb8LSLz35v25ibN
 qaSaaFLq
 vQ9GzSEnRtcXeF7mBYg2rWj1hqeEnc0ILDhLdw7nb0dBrGipHjJ0hMSSFDvb0V2NXtkAz0irnKtk67A7BSkU/NAwLc7xqp6DSOPIyk27vpc7K4kw5NZzzf0VBglYiZeRK1HvFSVF5zAu0UvUNIFYA0QhsjGhLBVqibhs1TdrS8CH9NN4f0UynDpkSYCrbUCsAkZHjfMocJVWtMveUBF7xGcpQKtUzu92HwRROqRe87izPw12koHi/UkGGfLpAqwrUeUAP3WtdZAKyLmSHYkm3HmRdNm68xdGfE8GScxKCgbutNooiwPLNBagegYJsOkiE8UhXptCI5gtyLJSag/9Hb0fQj4sHVIJ5ck7j4MKSJuXOQkCL00LYm1MxJAvrgBaRMjvtf+ZUX4mALUMv6h62Q2kYCHeLC3OUBr601t/rmwQYHLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 21:00, Matthew Wilcox wrote:
> On Tue, Aug 26, 2025 at 11:37:21AM -0400, Aristeu Rozanski wrote:
>> As raised by Andrew [1], a folio/compound page never spans a negative number
>> of pages. Consequently, let's use "unsigned long" instead of "long"
>> consistently for folio_nr_pages(), folio_large_nr_pages() and compound_nr().
>>
>> Using "unsigned long" as return value is fine, because even
>> "(long)-folio_nr_pages()" will keep on working as expected. Using "unsigned
>> int" instead would actually break these use cases.
> 
> I wish I'd written down what this broke, but it did.
> 
> Sometimes we pass -folio_nr_pages() to functions.  If it has an unsigned
> long type, things can go wrong.

IIRC, the issue is if we pass -folio_nr_pages() to functions that expect 
a "long" and we are using "unsigned int" as return type.

Then, e.g., -1 will be (unsigned int)0xffffffff, and casting that to 
"long" means trouble, because we wouldn't sign-extend properly and get 
(long)0x00000000ffffffff.

Using "unsigned long" instead work perfectly fine.

e.g., -1 will be (unsigned long)0xffffffffffffffff. Passing that to a 
function that expects "long" or "unsigned long" works as expected.

At least that's what I remember :)

-- 
Cheers

David / dhildenb


