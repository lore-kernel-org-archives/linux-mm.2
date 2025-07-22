Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A61C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B39F8E0008; Tue, 22 Jul 2025 11:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163C08E0001; Tue, 22 Jul 2025 11:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02AF38E0008; Tue, 22 Jul 2025 11:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFD978E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:22:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D32314044B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:22:03 +0000 (UTC)
X-FDA: 83692266126.24.C17766E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B41C8A0002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:22:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GAdbTJ5r;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753197720; a=rsa-sha256;
	cv=none;
	b=W6C6rvkPdhj0p14cQCH486rj1MPrhsAZ795+iYTzGlc/O6BNhoDUeWd6k08jhZis6DXH67
	YZSLyzu34RVERqfKa0TNPECFij1WJFAScEF8KdC14ItIdQNOL+SN9ICD7VHAaWitrpm5wb
	/JTJBcK2Ads3UzOvZhmdUWRGhHjwxJA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GAdbTJ5r;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753197720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lGVCvSvU+dwTTyQ/1aMBu54ELfXmjnvHtRzgY3JvgA=;
	b=68F8v9ldXLrRfd6IfQghkXqcbf7G5kPaLTkXaCFALirZh7uatpyj9341fcnvcj2DpnngUJ
	RyCbhdPO7nmvv9Pw85Oog7RCGoveCxvJlO2XdzhYqQfQu8Y4ZTZqoqfN0t7kh3SFGClYxZ
	EOl+XCV3vQAGtGUk83109nYqwCAe65A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753197720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3lGVCvSvU+dwTTyQ/1aMBu54ELfXmjnvHtRzgY3JvgA=;
	b=GAdbTJ5rBPVuZOebhxxLWx8vx/4BKM/W2aTjJY4uwPIPxwwqC/ZOCRWAsmR9jAIJ6SokbZ
	2H+BlUyp+PmYWhAvJxQ1pDt/LgJAeFJkjgw00CAg778UvIgRWvIDD60SMxCtNiatXasERC
	g8ka0fgIi0O3jNPvehPaSyFUvrEnJLI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-4hqFulM0N0OhRkiaOGZLEg-1; Tue, 22 Jul 2025 11:21:58 -0400
X-MC-Unique: 4hqFulM0N0OhRkiaOGZLEg-1
X-Mimecast-MFC-AGG-ID: 4hqFulM0N0OhRkiaOGZLEg_1753197717
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so35282825e9.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:21:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753197717; x=1753802517;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3lGVCvSvU+dwTTyQ/1aMBu54ELfXmjnvHtRzgY3JvgA=;
        b=q4ysoXhzOQA/qUzhw3ihs4tf3aAW+eC7ttAVvUt/426NKm1hCg7beGnoCCQ4511CZ3
         m4MGLaYYTDe9A6aIHrGjY8phKlj3tggK4IMK4yjN8Vtr1xuiWP8NfZsMmqz8OYYMTCy2
         yTn6728koaHTPixsnwesk5mNzr3fEhkSj6EhgomW1eMZTxN8Ou1t879ObMi9IKOj2sMx
         29jJPZyEN6fC5BVdr7jwvagJdMf6t80FLf69s03jQCmuY87OvtyPgZbQg92QYTA/Bjvb
         cLO1Eowl5gYuP7MJ0ineYbj6QMOz/Ff6waPTjPsPKH9IulWt40dFT54gOKzpzRkgwoIx
         uWWw==
X-Forwarded-Encrypted: i=1; AJvYcCW1/V3KWHR1adX/3rXU9DreGtJ2N0A0ELqFO0RvScsU7HXI4ba/bwOgwSMV7+26+8y+w+XeyuAWxA==@kvack.org
X-Gm-Message-State: AOJu0Ywp/gbfOfhkVZUVzufbgPGdDACNCuFnJDs4+benN5QefwyQ0CIq
	J3ck/Z/JxJ3vkrkrX4l2LSHOIkhPXcOGQa+NaOffyER4DPmZRpxnYJ48mqjajboFZDcIlgl1b9Q
	QiKKpyUJPTwOMl/5GCxNKjkr68ja8Ed8g0WU9OtZ8y57X3gTwk4EV
X-Gm-Gg: ASbGncup9an1AhSrVLNMtYmr3Q16RxqT+ARwOZ74lBbG4cEOa/aXmyjmDqGLRgymFit
	J/ZBD1WBizoahzseXQ5k5RKqLDf8hUX8jZ+F5pQgtJAcJF4WJfLLkLf8GAG1U9j6w3REMuquF45
	EBSUJISdT97MXt6kyzaa1CAEAreG+5jPbSiQPqjcR2b253DghB032GIuXQpNP0ZcBZ4HD7zEGXz
	qmqOvuMROgfeR4GfCFp9nzVmei7uvExxgULrnTkqWZoqLX2nIogxZwc5ayx6fjdhmXEjvyEd1/i
	038riQu1wM1XmBkxq1u421BvxES4HntNSPpukRJUxsFSuUB2mZehP4M9mUEKyUgODMyDPLaN3c6
	oD3WS+pPOrcWi/c/zEjSOw+XCPJXwQyoojzlf4GHVrPf/u2nyNUTV3w1AWPP7v3tIYd0=
X-Received: by 2002:a05:600c:1389:b0:456:26a1:a0c1 with SMTP id 5b1f17b1804b1-456437a59efmr137997005e9.17.1753197716959;
        Tue, 22 Jul 2025 08:21:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5enLdCYgzjySAx4ybbYU0jMVafZgCttcr6BLFjBoC3XlTsR3XaXP1SUNWMbt7hDHDm6g3EA==
X-Received: by 2002:a05:600c:1389:b0:456:26a1:a0c1 with SMTP id 5b1f17b1804b1-456437a59efmr137995965e9.17.1753197716277;
        Tue, 22 Jul 2025 08:21:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e802ae4sm192273375e9.13.2025.07.22.08.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:21:55 -0700 (PDT)
Message-ID: <33da1127-f00e-446f-891f-01ccbd53efd6@redhat.com>
Date: Tue, 22 Jul 2025 17:21:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 3/7] mm/filemap: Extend __filemap_get_folio() to
 support NUMA memory policies
To: Shivank Garg <shivankg@amd.com>, seanjc@google.com, vbabka@suse.cz,
 willy@infradead.org, akpm@linux-foundation.org, shuah@kernel.org,
 pbonzini@redhat.com, brauner@kernel.org, viro@zeniv.linux.org.uk
Cc: ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org,
 serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, tabba@google.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, rppt@kernel.org, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 kent.overstreet@linux.dev, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250713174339.13981-2-shivankg@amd.com>
 <20250713174339.13981-6-shivankg@amd.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250713174339.13981-6-shivankg@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sgQ09yognxfMx_pO3R5iWn4kZuVclsDHY5DGSOg8gto_1753197717
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B41C8A0002
X-Stat-Signature: 1hxh6m68csore5kb9g8yp8t1faej4mqh
X-Rspam-User: 
X-HE-Tag: 1753197720-94676
X-HE-Meta: U2FsdGVkX1+4VnXRsVwRRIv/1U+bgxSMBd/wrdgzMY5lgWXvs/BnGeV2zQO51/v5wn4s3mH7gNOMWgRYu1ZVlaA3jcCr/Tvw9Y+GyxcClEqENLv2+7w9q2aCdnWMBSQBiOMdH6lee8R1hT1IoDwv0uq/0+2cALCLq+kYkAzfDKCTUAoD/qsTC2+YNexfXV0rkg3/BJakgMt000WQqyQCPN6rG/D/ax10lrpM2j2DtddSDFyMzDgtcGc69CuuUghrRRb9907tgd7VgxsjvKEyDT3j5hmnFc2GO3aOska7zUaDFbcZpWgSMPsZpos4LaM1t4NsdiHkGCeVqBKH4hhgRqUzQlKo0+wlb9AjWUwzBMkvrGGClQBscth0OP3UXn4L6SmCZnmY1pg2VKVK0yXhEOIq5i/UM9KciIY+tsgE4qVJhnDjPm3gznSOd6NUcUT480OYcU4Jf/5za6XN9oNvTNnOVRM8L39PYOJgCXBpOYEinD62waJtaV2GBVQ54sA0Q3sejr9cptALLDaWbYchGcA7eozgR5xZxPO/ilnkYQ8AZd2aHp0lKH2X+i9KVb5DHremkqTxv9ZP3+H0syLtYKghlXqM37JPcHgmP/tJoAv3DASUj9vYqu2KNu/NXEeuwHZLOv8ZuTyHqUYLfthkFrIerZsGtDf6vwwCdA6rWmcoyzLxBUt+CFoV4HBuFisL7P48JIp7aHlzwlcL8AidRmofUrwJsfpgRCAOn5XaWQRsJOO+fZ/48aVhPqFXNNgtuVo3tpqSaL0SF9Ken3OxrDjkTX0DSuPcDdPAbt81EQ2WHZIJurM8bK0VdMdWZqneVldiYxTnrsVUqCGCwa0boJ24N1Ppf+JCTJ3TOPwLh3AVC82J+xaRAL2bZHoNKLNkrWU+SwP4nPd1vlQzTVM3phzVZAiWkNYlwA0Al/trfo0IcRl3UBeQ7s3qM7yAE102d4pH26Z+2OJiOhmO1E3
 cCMf48IS
 F6VaOMX/WJqAr0o1EIh8FjO1rEZF2jTM7LvnDikhfmCZR0nlwUbcnw2sjpdKHA53d03x9NXVKgG6E3bR8/I74VqX5tMP6X2nrORS8vsTXOrxPMCjY94MRIU2wyuEu1UhJ3sT/oSaW59ETN0dEQoGlPs/yZT9B2kb0Z3juhg9cUtAp7U6R25KENYh7t2XZVb/D8aCzgdn0YLVsQ16fdT/wiTyjm0mr6GM6EzCFCSVDpn5VESkFyWHb10rDZ93zaOAa4qm5o0vHd+sSM1xIGQUSD4cIuaR+qSi/uZv4hCxVbBL3dcjR7MmA0nytdfDTLxcM8/o39heqtZQp24s67qNMi5vV6JFuk+NaxlQ3vN172UIo9EeKmGc3eJOSyxacaLliicMqyBVY7J00nWT0RK9puuIAMx1VQrv9leiJLxrEbEKDB2z0rKW83FGmUDRRDJVx2PKC+9jeENH4qMpH4Oxd6ofO0FZ7AW1/iumnPINn+O7IWW5kTrjQqBtHxcmmVbSvXt7M6rdzx6f6iSAjoNt1HuYKI/drAsci65b7gqqLHtVcUH366OZrlq+QbTkPyoCVxggg1vG0sXUwGD8l1sgRKVdp3YLUaiqOZbkLHW300/hge8zHh6keHVbKmJQhoH2bP6lQJhPpadmMzJQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.07.25 19:43, Shivank Garg wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Extend __filemap_get_folio() to support NUMA memory policies by
> renaming the implementation to __filemap_get_folio_mpol() and adding
> a mempolicy parameter. The original function becomes a static inline
> wrapper that passes NULL for the mempolicy.
> 
> This infrastructure will enable future support for NUMA-aware page cache
> allocations in guest_memfd memory backend KVM guests.
> 
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


