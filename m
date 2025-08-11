Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793ABCA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2058E0071; Mon, 11 Aug 2025 11:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9A38E0060; Mon, 11 Aug 2025 11:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9158E0071; Mon, 11 Aug 2025 11:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB3D48E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:19:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 996A0115AEF
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:19:34 +0000 (UTC)
X-FDA: 83764835868.17.B13ECFA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01A82180006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:19:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ssqf59N1;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754925572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4rMKr5yqLMBPEtbuZGwA+jfkHDQ63mNAqigiwiYs6s=;
	b=z70ebKSvc8uwXyh2DJBXGPJD0Y2Bn1MFtBmhpacy+QYf/sOSgx40QJ21taWjwL4TCa3Oik
	WTFALUxHQehpum9Us5uGjfkuw0XpGQ9xTDA1IFZzUTayRyJv8rW0YNXqJScWocEEaKzFbh
	Czzg5EmKVS/9Q5qKcgbIImptgRRFg4c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ssqf59N1;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754925572; a=rsa-sha256;
	cv=none;
	b=sXY9ATupcdkg9L9V41/8jNlaTmsGrJ3o1lr1p0bXLrN24g0lEym+OGm/M/HQqK1sqO2E6Y
	UF7z9vnZLp0miK6Vdwh3kD5K/6g7jnz2nOI78iyOYtPDEg6+QRNGwSlpEEPL6vjtfCva7D
	SJDNQG36DECV3bFYt5j2Ja3iLUlm9RU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754925571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U4rMKr5yqLMBPEtbuZGwA+jfkHDQ63mNAqigiwiYs6s=;
	b=Ssqf59N1vLTu1VjglSW6UOqNW8FbWkUcE1UvkPW7Xuxwb381RdDhHgJbEj80HjJKPrn3Dy
	1mMCSR3qWagR/rsYCLuyI8cz+V2Wim8MmQT4s4NYRgWebtXki4iCVlONkK2pgK+POKPdQa
	caInvT8XBaOrQo1Z3Rd8wrNyXm9c+8g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-YlS0IlLcOq2rg8ggNIcu_w-1; Mon, 11 Aug 2025 11:19:29 -0400
X-MC-Unique: YlS0IlLcOq2rg8ggNIcu_w-1
X-Mimecast-MFC-AGG-ID: YlS0IlLcOq2rg8ggNIcu_w_1754925569
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7851a096fso3237613f8f.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:19:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754925569; x=1755530369;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U4rMKr5yqLMBPEtbuZGwA+jfkHDQ63mNAqigiwiYs6s=;
        b=YZZIgFHWZ8p6DfKh0qGeJxvIyjDpxz7xqwO/uSRFULYRI+9w8dGcEu4oACmB48MTBg
         OOTEkDo9oICm9AY4fzoNDS8vOqQLsNvNOxbZB1O0AaE0b+UmckO1D7SY0hKQu6InnTsh
         m13ZagADWBKDHA3X03RlJcWsUExSkIbsNWo2I3tYeh5erqYbFoidO9XiBSXbNicRejNQ
         RaDwizw8jqQ1TXibPAeMBuByY/WMIauqnxLFhXYWdrZev8+3U+yfYdu2SFWddzyZCIFp
         18IuW70PA4n+lgQlZ+4cr8+AUrYgYTLreVWBrBjfIkgFokmxoDWTXMSljcsl+Mg/EKlO
         zPwA==
X-Forwarded-Encrypted: i=1; AJvYcCVMFuNOORgVcjYrOrfCt5wGiGuJ+hDOaBV/N5IUnUvwnqq3IxbQHiSzwXhA7MFMSSSiapLiB67PIg==@kvack.org
X-Gm-Message-State: AOJu0YzW/Bk+MZJtAcevQgwrMADFajXYYwo93CwxMYD1yXU+JY2Q5yW4
	6zV60/EcZUiW2KzE4OUClToOYflP0LqzDk0LX/NIdRghwDm1TmXZS0U48B/JQ2IxloPu3cVou1T
	yHf+2BAZUObxmepc5WgDm6I7J6ZQ+Pp4EoIywxLUd2pj9HCkAYdyf
X-Gm-Gg: ASbGnculMYDu4rEIJpqZh5XjgZpcYXkUDWgZ8lYBbcZyR1ch8UExBxL2Vet+RRMq0cV
	rY5uJTC+pfhRoAzg6490m/na0oXoq8GaYKq9M1fFKcpluK4Bf5PyS72a653hQguv0aWzLyrlnwM
	OyX9j4M4KDpX6RzHx9zrbXWhaL7ur4mMLC1uAzffNRG4F0jxdDmQbX3CRfTVz2LR3YPgxtlN/9P
	HDuE1CrGOd/tagrVHoXXiTQkIs6ecPbUvPAxE5/a16rGpOI/8nuLgK7/XM4fjS86KslxzDRrCNG
	JpbXwSCKJD0AsMOgyKHZhsLoTj35xf5kkZVAi/0J4CzrtdEaSUC70k2KnYpPACmKgK8KwzxEVtZ
	n7p7JqN8FtVNaGGFBaIcQz2SXYpCQUmt7wEQCIue83iGPC87MlNOy4IiKV4ByJ1leL+A=
X-Received: by 2002:a05:6000:26cd:b0:3b7:6d94:a032 with SMTP id ffacd0b85a97d-3b910fdb7b4mr108591f8f.3.1754925568681;
        Mon, 11 Aug 2025 08:19:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlqejcEdMvgiK2RYwo1jOG2sniAVxTOTKJkporZZgppdpArjBWuTEEn/dhIFXsBoJSphIeVw==
X-Received: by 2002:a05:6000:26cd:b0:3b7:6d94:a032 with SMTP id ffacd0b85a97d-3b910fdb7b4mr108564f8f.3.1754925568267;
        Mon, 11 Aug 2025 08:19:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e584302csm279863205e9.7.2025.08.11.08.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 08:19:27 -0700 (PDT)
Message-ID: <dbd8c326-8848-486f-8789-3528dea2bb28@redhat.com>
Date: Mon, 11 Aug 2025 17:19:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Barry Song <21cnbao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <CAGsJ_4zuEcgg7U0yCMu6ayKqRPACtvuzUsC9vUxBk2PgMzaf_Q@mail.gmail.com>
 <47ce3db2-38ad-4a6b-917a-c6300fc39543@lucifer.local>
 <CAGsJ_4w_c3AY1Nw7EhYH3rf0jjqgZ6AYLdr3xuonF9SNgWckDg@mail.gmail.com>
 <0babf2ec-040f-4f7b-aa76-f59e80274333@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <0babf2ec-040f-4f7b-aa76-f59e80274333@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PpB-15vNj2zefRJVoR53vzuY82vqDCCuPE8HrVw221Y_1754925569
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01A82180006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 39cuikbzyeu7ka7kqjxu3k95r7achcrc
X-HE-Tag: 1754925571-96339
X-HE-Meta: U2FsdGVkX1/BSKOp4eIuqtYYlMoAqFhhw9VKwHmDzhsdxd6xOSLTPHpsnCwScw2BbDDwm1RtnoonaUmVkN3yvr24O0xWwJyxNjAnuHKHgA2P+oNcXWoRa5Sc/H4PP+oR7tAdcQ8akQNUI+UO5W3RB0nt0HyGdx42M9enuJBeTDUDx7JUuVmICEmqR1ccEYAXgGXsBiSTTSsDjln9+cyN99NF2JO7kYtyUZZ7aMGv8TOs8kHmNiuaSdcQxAynoaFWMSn19IXDMmswQuODcwZ8Ftu3N7WntLPH10yP6Cbv8PLFMGTvrjOV8sFtSdA3ixIjlqXjlrVi4F538roZqII2G6KZZN5u1rtSDoyaZE3iMhaY5Sg6AjI4lvDfByUxrUHY88Hi0j3pzrkt2igJ3H5/12ONDLUnOcylS0BnB+M7eAzc3dXxa6ify9JATyCxi77RxzkcQb3P9naYvT4Bb5ayfQoo+Ep0gzDlpi3eKdd8GrEpVmjRwopLch5/kDmsfoAK9+3WI/Vw/h4ANY/oBGLuUEnBOKICcjc2x9bokp04PuRMHd6SCYaHHWktH9DBOI7ZcsWzYeqYQOS35q41J68HgINfPNPmvrWm1I9UchfOCpAIR1Pj5OVwDsp/n7Rt3y/FoBwdHh3wLn9HNKuvVQeHJMPtaDgWYWwCXm/aHTaE4g25OYTKR2u+q8pgLVeO8OCqch0Xa50+lV/NjRuf//oPEoqo1Nd/k0fnNv+hMXhVEgIdC/UKZMQKaPd1004MAhb7VsEgWaF/jTWmzZdpWz6Dluu1shhE026gf+hZLJMV5Z7v1My8hwW1NnW5clgrGsbnXgI75XwsRN/SgrrswYB4BljP1UQdedt0CoLT4I2GytGEXaAY4fd0giy9Xbbbb409PoxkkhfD+lrRW5g6y3FlhN5DFoCC7E1sGPt5Ee2j8dwigmzXh+Tqa8VdBH6w1JKRjEgSh7kjPyEoqBSanyd
 l1lajW/l
 DmdeFSRlavNZjl4+M9PelhFhQWD1q8a5xMEKYns7uF9ojaF0xe89p3cqybXeOTKWGuWBLM9pmYE6q+bv+xIHC7Uun9RM2UtjEt6AE/5kWG0nKPyy7rIBbSzBRslbo6p/+/IRo2CwjpwYfUKAc9lNBkoPKEZ9KGyh9Njiibohw+C+LY6KtnLq6fUvu8/EqybU94SmgmQjPu1vY5ynZaUKFpokbevW7CPsplrYV+x2iiV/cGCfQ4Q8Hh288TtcAc9O1w3Mnr/1m7py6aQXXUZWJFa1ITb+KBk/wZ49DLgMtxvQWuIvw76HwtowIfLUqzB7A5IRIVVfgA1EAlK5rZjxTHRmSbNmBVVH+bl2IfqgV5Y+GjQgbr/6GKXYbjWC6tXFsQE20cmkfwzRl8oacQol33YrRJkXdt3mZG+Ha84Mk1dq8VynBGQoBIHawvTqHIELQAO7+JIQ0msFxvWP/Ss/iLmnVofTxIOeTdXVu0P0TrFzfJ0L8ND3DpyKgqEq3jbNBafaTQdEfzrDRWOyVzYvUpeZWEC1B2kX9wMCQnq1ZnGRRFotN4SK1YxZCiuyCgOdxcZjKbe3OVcB9Tmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> Unless the previous contpte_try_unfold() was very costly and removing it yielded
>> a significant improvement, it’s difficult to see how the benefits would outweigh
>> the drawbacks of vm_normal_folio(). Does this imply that there was already a
>> regression in mremap() caused by contpte_try_unfold() before?
>> And that Dev’s patch is essentially a fix for this regression on arm64?

Fix/regression might be the wrong words here IMHO, but yes, this code 
was not playing nicely with automatic cont-pte folding/unfolding , and 
now it's optimized for that.

-- 
Cheers,

David / dhildenb


