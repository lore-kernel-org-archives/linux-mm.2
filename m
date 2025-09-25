Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF33CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A5A8E0010; Thu, 25 Sep 2025 06:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21A38E0001; Thu, 25 Sep 2025 06:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C741D8E0010; Thu, 25 Sep 2025 06:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B98A78E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:06:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 794CD13B00A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:06:27 +0000 (UTC)
X-FDA: 83927342814.06.E7C3CED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1A68210000D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:06:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TuHO+6ur;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758794785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQ1yIMrrwyU17r+tTnLpblX0dAaSzYGyBKLGlXcYZwI=;
	b=cRSV3YxIFxRwU4uSO+DfOcF47nn5UON7EAR2BhGWLf3/ImqwHiRQBvRkHrz0GyluWpzBeQ
	LAyPR/7aa0yi6QzvWQ3jOMHKs5NNBTpg9UwJ7hKoL/ZfBRI+OgOOGGCw0iCldLOEggNJJz
	1ploXNU3sCRoqbN6bjow2XtL6erZ+oU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TuHO+6ur;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758794785; a=rsa-sha256;
	cv=none;
	b=nBZYTY8KDPDd6tV4d4nQxEsF1JjiO1Kr1HHMMP/Un6c7dabSpyOfZ4ZwLvQHVTXUC9QFS5
	uu83/eNZbIn/4q2t8ScgMTX/5izwDR12KCZNEgE27HPuY4cZdltoRd9zjwg1JOGShx5BB6
	kStnhScfnmvMOHMD0wFp9+VPGKhSk5s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758794784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UQ1yIMrrwyU17r+tTnLpblX0dAaSzYGyBKLGlXcYZwI=;
	b=TuHO+6urt6hJn3ze4poCZ3CLLNwR1YxLMijTAfvSWsiDQHwihRPlaixSpw0MLijNgEm9sv
	gd76tehzjH+VnXrNbPZA3yxdkh88hIIIUC6Bc5CVXA0UOmDMhGWs32OTR/wjktKtWeHrs5
	851k1SSlBgIDK7IiYyn4rYUw07+zBc4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-arRucQSyOeGuZtWFknsKJA-1; Thu, 25 Sep 2025 06:06:23 -0400
X-MC-Unique: arRucQSyOeGuZtWFknsKJA-1
X-Mimecast-MFC-AGG-ID: arRucQSyOeGuZtWFknsKJA_1758794782
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e303235e8so5265145e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758794782; x=1759399582;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UQ1yIMrrwyU17r+tTnLpblX0dAaSzYGyBKLGlXcYZwI=;
        b=h7jz+2WiYktCIXVCpNVjPOgA7KGt30xT8dy18799vQgWtPS2bCCvNubO/zh1VYkWYq
         +HJbCXUK1gPDQ1aQJSpKMhzYYF4sWgqdQCLIgY80TUKkYFJ9NfhEcYnqbi1B4yN9bami
         +YmNjdQTxcztsDtoyJ+BMvxOEPYK7OPE3c2ddTHyj56Z/nnrT0OHBP9T5F1/X+HC59vR
         kfupNVxhK56hTWwyqIN7JtbxWxjeK8TKPNK8qB9Z0jHL1ABt7sDWZHd2J0xLF/pM+Klr
         PBmBiS/Kh8P6a2ineMgC0DsLLJM0JcVzaH+2WJTe3NZnXz99APji8v9f98LX+uJ0N5P7
         glow==
X-Forwarded-Encrypted: i=1; AJvYcCWC5z5N8/pF0iuz7b/vDQeZ8gQr6XNBNIn+dJ81laIwct9nh3OJHG2lpeWlubO+da4awwKHrPurVA==@kvack.org
X-Gm-Message-State: AOJu0YzcfymJ0Jr/Sq3GjMiWhQQP2rMaf7DUSt8r8TjVULf1d+D88Q3R
	a1amqPSQGjWtFb4qwlsVTu5FCJvCeeXkcys6rylVfMKiPzwUdK2jXZopQXlg9k/3+5p7drk/SDO
	p5LKFRZgF++8kZFX93INeFGNpFPMUeZHqql2A0RppQ84EGgSUwaEc
X-Gm-Gg: ASbGncs4pF7YLBNJY+CMJrMSIl+Cvu9LE6/ctTPKi7XXPopJzT7K/UUQ7naJEq0KGLR
	vFMT16Rngd4lDui5AeZ5TMbcZWqlJfwNQiWqwkpY0Dkkl5+ElC8fbtBKqOcFlXTvVkP6eVFNU4p
	Swr3jAV/Axow2xkRP9FPoTVtFcWU+YNfA7otYB9Iprd7TfEPLbIy9n8ZyXv/yJkwABWFXF0+g08
	MwdUVEbnlrozFquEq8AJiS1MLM9i84mbcYEdRm2+g0kZhwl42rpGaTcM28uwB02EXj72qeuO9Pq
	e0YdfRMuxibhKpkuOi5oMfSSbb8DD5k/qnS00N5mklhNLtNPHPlkP5aZoJ5xCa/T94UB0cUnhxS
	siByoinXHp+ITVZGzCxDMuWxnPR8FlR3sfik2GNKp5Cf5FevE5cNkLX54zLz1M7Um2GYS
X-Received: by 2002:a05:600c:1e87:b0:46e:27f7:80ce with SMTP id 5b1f17b1804b1-46e329e51c2mr23724755e9.23.1758794781976;
        Thu, 25 Sep 2025 03:06:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXJl4bhmMZAV2Ov8ckXqohzCkRtHDu295sdMoIicohDcdpvJzXAjcv+ktFKrVhD9D0sp0u6g==
X-Received: by 2002:a05:600c:1e87:b0:46e:27f7:80ce with SMTP id 5b1f17b1804b1-46e329e51c2mr23724515e9.23.1758794781570;
        Thu, 25 Sep 2025 03:06:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31f1dsm70034495e9.13.2025.09.25.03.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 03:06:20 -0700 (PDT)
Message-ID: <c9a0f531-bba6-48a1-bb50-639fb4f2dfb6@redhat.com>
Date: Thu, 25 Sep 2025 12:06:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v6 04/15] mm/huge_memory: implement device-private THP splitting
To: Zi Yan <ziy@nvidia.com>, Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 dri-devel@lists.freedesktop.org, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-5-balbirs@nvidia.com>
 <7987AB89-4E80-4A0D-8736-E95F998698DA@nvidia.com>
 <a77b03b8-508b-4bad-8913-fb825ecd8a0d@nvidia.com>
 <F6F6DB2E-C08B-417A-A8CB-3E759FE2C3A7@nvidia.com>
 <901c82e7-0442-4791-b249-b035f8ee428d@nvidia.com>
 <B24E4F6A-F61B-4E9B-A2FE-4004C62A3DD2@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <B24E4F6A-F61B-4E9B-A2FE-4004C62A3DD2@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hvXF72Np17B0EWCOjHvl2McgFD2bNscb9eA9LpEnQ0U_1758794782
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7md7ijaq1g69oh68dqosb4a7zjg71cnx
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A68210000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1758794784-870092
X-HE-Meta: U2FsdGVkX1+GPgl46cNCXZzLnvNivfRb942UeEzaaDEfV70Z/FW5XNPxdluPL80R3CC5+sje86DbfruSX4b4c3D8lSdCR7x5KF0kfkA7ztJbFJfVvs1GY4nt3NJddoU/p0jjapmG7WxXmK5tXzQX1cBlIDykPh2TgeHghQ14hQAc5OWWWf2HIExrcL+tNB5cbaRaRzBAfF2OgzRYSQqnWSr8gttAnDOkyCKhpxzqlueJjBTuYtV6QI2i/WQ5UgLTsthtBec02bQtiT2iWARpleJpZ8WA7a8jk/xc9F1zW0JuJVoZjfh9frsfcjeCSYiwX/7Rq1YggNbflapwphxPh2BHfmS4QswYOKZ7eQZJiyc9PllQs3F3KXWuaUYHZsZSqEmp113pQPZhREqzJA+C/FfKvW7erPY5zwR7E5v9O06alcxN2Gehuu3g3o6H51HbVaKK1aRmh6dnNynrHfXIIUvyIFCGnvYSVBrRSMQ+TBBfnYrryTFt2X00hapW9cy0CKarKoJoTLAyZrOwnm9dE/9IhGcOjlLkt7Eq6XwoZKFhkSxoqU8iYlF/QWDzOpIzvIDyyTmG29TZXa+mzAU3kHz0FpVJN5i3YNrcTgSxbYuVMxUAqkPL9OJZvgeYLMJKd53NkB2Ofm34S27WuL8wbHi7yRAufzecVdyCfuNs01Z1bqNS9sTGGqdKIj5f4sHYfXJ3cKK9PwxWb5tFSRNpD0WV1JELgHQzyjj8WdMjbuaWDUBDTkzgBoryMavcVnUDiQxTWGO1IaJEjSu5pcGdh7OzIXlqo5vNMx1pJAX4sZz3rj6SXtkMpeY3sNLsK096H28QHBbxMguS3VCp7L0l+Wc9R73XQq3x6oBJ+oBsBa4musJdm8driCgEVnZnEY3XNF/dgf19Ban7rYYpBRZwKJ/pzLZU56l0R4ATLv6hL34jLg17MnjPV/R74uxgdiEyKYihqfFYc8GXMVIVlAY
 GX/2a6fN
 /kIYsQ0EujPVj+N2fvEPAxkaytu3pLx2R6y27YOtIoaXbesSFOH/u2hqSirIPyDHVCqATHrUgax24Efasz+7kfDrJa/j0QTKg7xgtVE1aRxyRfFKWO98KarTB0JhonGnRf4RieqiJDU9//qIsE9cn3ShTDQHpG1eLzzxvR4HUitl9GP89g0mPVca9wctmKOypWiER/IBaJBfDSumRLk/pin6HwT8Nj6ttFQEasnhKaxzL4pTe/b0DU2jZpkkH2VzV7LDqpSUbCUPdjQg3SasxASPvg59EJk5+TqCvcWJZ4iEJ+EoAEDDsA+/wOkNt0HY7sd6ZHFDdEAynu12RO5wxNs8Mp5MNLcAuGAy+ke7lJX8nEslNmTnQ7O+GmWNzhHlaYaBonsditKpLSMM26D6JB45pkdrhEeM/LtrYlXhySsfc1LBLMdVCHpAcumrWalPgHaGzs6ehLmK3wnZbu9mY2UpHTvlIzK0JwzZlS7ee3JB87BvkOXmba4WVsGs22DD28QcogxGKrsBsGvqcgKeRMV0/Ur7royPKD+pwYXEeFtQ1RFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> Even if this is the only call site, there is no guarantee that
>>> there will be none in the future. I am not sure why we want caller
>>> to handle this special case. Who is going to tell the next user
>>> of RMP_USE_SHARED_ZEROPAGE or caller to try_to_map_unused_to_zeropage()
>>> that device private is incompatible with them?
>>>
>>
>> I don't disagree, but the question was why are device private pages even making
>> it to try_to_map_unused_to_zeropage()>>
> 
> Then, it could be done in remove_migration_pte():
> 
> if (rmap_walk_arg->map_unused_to_zeropage &&
> 	!folio_is_device_private(folio) &&
> 	try_to_map_unused_to_zeropage(&pvmw, folio, idx))
> 	continue;
> 
> Maybe I am too hung up on this and someone else could pat on my back and
> tell me it is OK to just do this at the only caller instead. :)

I think we shouldn't set a flag for a folio that does not make any 
sense. Just like we don't set the flag for non-anon folios?

In addition, we could add a 
VM_WARN_ON_ONCE(folio_is_device_private(folio)) in 
try_to_map_unused_to_zeropage(), to catch any future abuse.

-- 
Cheers

David / dhildenb


