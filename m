Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EEE2CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 17:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812F88E001B; Mon, 29 Sep 2025 13:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA858E0016; Mon, 29 Sep 2025 13:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D97C8E001B; Mon, 29 Sep 2025 13:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58F938E0016
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:25:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D94A16048C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:25:29 +0000 (UTC)
X-FDA: 83942964378.29.69EAD7A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id B4B7A1C001C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:25:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iSFfVVQV;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759166726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8p3SZSGj6nAAVmGdvtxrXv4VJmnfEi+0dJCW+oMQs80=;
	b=M8lscb1m3KmE/fw4r1aucNbFNGbF2G3wk5/JXPe02HnpoBhDllzuUl9xh2UmfqEAh/Dapc
	5Fm9fr+JwoTIT0ykHyPE7jKopp7xn5L0CLQU2Boeoq6dC0RmaKUdSvC/FiIzlB/0Ozj4W+
	nu5zyFKKMRQ9ZPpb97HhtbVi95tp3r4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759166726; a=rsa-sha256;
	cv=none;
	b=j83GSYHlIha2NZIdwC7kcd0e71SA1OwQPJBwwEAnBOlVvFtyawgaYXK4IuW3cSAqnt3igt
	YYg8alvxynVAFDreyXP5ipd75uCWq/M+HfazfKpmSxeJ1hW7g9O76lRHyd6zWRsgYwa9Tj
	hL4DTro4xzpo298MQwcz6J613XqjGYw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iSFfVVQV;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759166726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8p3SZSGj6nAAVmGdvtxrXv4VJmnfEi+0dJCW+oMQs80=;
	b=iSFfVVQVlJqak9bD4JmOB7J3799vBe4UJrZjHiZlgDJ0y+ROQCejhVLub/rRwaxgT8/K75
	aZvwkVT8Ii6qqD2iplhrfiRw4ZeALgoaHaCI3R08m8C2tRzcFUaDOlFMAf06CM1EIoo1Wm
	PG366urOl1no1oDzGz6hWCthPz7jIUM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-TNLsit_SMX6sMXbNLeMabg-1; Mon, 29 Sep 2025 13:25:20 -0400
X-MC-Unique: TNLsit_SMX6sMXbNLeMabg-1
X-Mimecast-MFC-AGG-ID: TNLsit_SMX6sMXbNLeMabg_1759166720
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f3787688b0so2675125f8f.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759166719; x=1759771519;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8p3SZSGj6nAAVmGdvtxrXv4VJmnfEi+0dJCW+oMQs80=;
        b=k7GFum5I7oDY8e0Dcetz+gahyF/VCC1zTDg8EsWpZfy0xrylm8w0roGjek9o3hYs1r
         V2QcPdHmOr9Ep+Vy6eHyHxN6jcgW3BjKED40oHgjoFOdyo2dBiDCq1hWlxA2l/+TheHN
         oOfkCWKkHtg57HWro1aTvx+D5JlQ0wcQ/ahss0jgvIvl2ogAdEelAh7Lm/nnVDRoO+EG
         kJDBTe4dlYWWj0Q6Nunm38X5sLiGp2MAHXTH0OFqt0901dW8SyF7VRy2OGFY9Y03yEXO
         5Cfg1suCd4Tpl307u0DwdLXQC/Ts81iVsHYdhtPJISDVjsPJ7U5pfA6scJkuW5dY2V6r
         4w8g==
X-Forwarded-Encrypted: i=1; AJvYcCWfImK3nh2Av4XqPsXN9O2iOMmZzOW1sOpy68ep3xBu4F2w6UJM0nLicQJSYSd2av1oGR1YJRNApQ==@kvack.org
X-Gm-Message-State: AOJu0YwxxWdM0rw2YrzOxbqaSINCFCwlfRXicA9ZOCjz4d7Ej5yNXwsU
	JQDqmYY7/73EcKUABaqZn1CbBdc22vVsT0/fg9wNUJl+TAKqKtcJBqpX1K3x6GHqu5XI8fmJKZZ
	rrqhOVsgK6ZLitNEb15GFqRVPUvQXxNdTY+xiKb6g3WSEFE+Xvs6b
X-Gm-Gg: ASbGnct/1QPiQZTq9UsZatOWVNgJoiaqTXIlpW56pibCid/TymDL3XyQcWaFx7ezCPm
	GKCaSnSM6pkA62icxRmio8e1NMnUxevilvHxVOn+gfstsU3JD4IaM8nCGuzc7p3caqRWmEDmpBW
	eIpeLBejJcQ640Qcq3ZXdFN+vhkphmgAZTldTcdSav+hfQtofcTlrvD0wRMsKRzPcw7r/C0AYIT
	KTtjpkTjTHyB3gf5YPjujbLqjSoX0bpUaieSuUoN/l0mfAOviCtF7YPPf3ShRz0KqFOb9Wauq7Z
	sS7TAruy+KlWUeGLJpIeSqzBXC49Zu4OUqb8ScocESaz3cATWPYmfuvlGEmIDUEM1szr17qJyAg
	sLIc=
X-Received: by 2002:a05:6000:4382:b0:3d5:d5ea:38d5 with SMTP id ffacd0b85a97d-40e47925a6bmr17792032f8f.25.1759166719606;
        Mon, 29 Sep 2025 10:25:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8yf6V0bJBhN3rZAINkUtJpgJnInOSm7QsAGkazdg2CilMW0OW8WBM+hc28aI5tpTfBIsZFw==
X-Received: by 2002:a05:6000:4382:b0:3d5:d5ea:38d5 with SMTP id ffacd0b85a97d-40e47925a6bmr17791990f8f.25.1759166719130;
        Mon, 29 Sep 2025 10:25:19 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:f2e2:845:f3d2:404d? ([2a01:599:901:4a65:f2e2:845:f3d2:404d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996c03sm234843445e9.3.2025.09.29.10.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 10:25:18 -0700 (PDT)
Message-ID: <c1294b63-eeee-4d99-82b6-93eb3a6d0af9@redhat.com>
Date: Mon, 29 Sep 2025 19:25:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
To: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
 Jiaqi Yan <jiaqiyan@google.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "Chen, Farrah" <farrah.chen@intel.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <CACw3F50ijQ20Vg8ycMROSCccf_XtjB_fFvLGxvQZ7eaNQoLwGQ@mail.gmail.com>
 <SA1PR11MB7130ABC25E060D2CC4749E45891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
 <SJ1PR11MB608350E5169EE77F86A51E2FFC1BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <SA1PR11MB713082CA93E9B1C5F22CFBBE891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <SA1PR11MB713082CA93E9B1C5F22CFBBE891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FnkFI_7fzQrq3YEE4PiWyhMTHxqKReE_euJAbaXQWkE_1759166720
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B4B7A1C001C
X-Stat-Signature: 7339j9nz18d44ncct73yqtr6u3u4ratd
X-Rspam-User: 
X-HE-Tag: 1759166726-671445
X-HE-Meta: U2FsdGVkX18mL9j5i1fqez/SpmzngKYVxW3EH7emIPQCazf8HWci3B9Mv7nMg9Hz8eqnfyiZRXG1E81YHzNHiCB0Cc5i7h3ucZTQrSBpKePgFeYaDCujyoF28aX3C0tcD37+acdQNbP//RP/zGSrU8PQNYUDgY/+TW7cMtMyQvJ3nz41HKOtkJmTaeJ4Z5rQ7y5Ij/FVtrwx+B6VSsWkoSefeMDIRE3rY2qdaz/bFmRFNfHrN56Dv5e/OtNCvQ6aEoU2a/Im2o1kdVUxJeO4uefr+hVkCJNJyTAj2VFMuQRtezxRYHOz8k9yCQXdRa4xKUZ8wdpjH9Xmp/LHFPHSLGyunRHd6udHj7n97JmvRJhiGP5ho1mWVv/LRZ5SatZuxF1h/BPKzIF81cLIcHl0XEwAU7GEhE2Ev656+JftctnRnMoAlra6bWtiG1gg0jlIDs+LtEPgTaRAk7wRtEErx9WwG6wsYrZ7JiTBQOvYgBwjshVVS/IS8Lf6J4kNdaUcjuRvzSS7+CYl9ixXkzVI1IwBV9tNo5jYrpnqbpiS7RBjcyqY8/O7mX2Fpu8+1hUQX5WLTZAITKyTOJhINTgPi/AsJL2/1OCkropXXFvWVQssd5h6a40wDmveaY3Sx6vvGuqm1MGm3w9hM6iTorajwp57RZfxA71lKqfDd27jcvKr3Ge0MP3nrTS1P+K0Hg2x74LQ/7kRcQ9sScbYtqK91b31kT+AsmbQ/pTApUm0nLN6sgyP13IbLX1PGx1jnX9L4d0AzN2GTkC2mKiB/ebr3FJmjnkH258qWu+nYEyTMhGtFv64A/FpAy1Oh/HPINHkyae9XVCcl4GyeySFvJsNsZvu8kk+LS9WGdgfIDK2Iy+/yfyPITudp8HpJQ+7iM924ihAxKlZf+iQr/3f/p9nAeXP8S35X1OO+MsnoRJX941qygn8Bewbyt2aoNSBiaZLtHkW3mf7B3AZzwYVsCu
 nI6IgwUJ
 5QF8ymz0L5BoNAlNUPEEoe2+j5N+EblpYztDZCHSNWIUmKr2mD8f/6hV4WL+AKx8Eennh24z+rn20chg+AMEhJKy+EVsAKg7AK3ATSirPin7Xo4oz0f8LT2qwXdmvNEWwuTg4CNt7UMB0WZm7GeUK6Te36A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.09.25 18:30, Zhuo, Qiuxu wrote:
> Hi Tony,
> 
>> From: Luck, Tony <tony.luck@intel.com>
>> [...]
>> Subject: RE: [PATCH 1/1] mm: prevent poison consumption when splitting THP
>>
>>> Miaohe mentioned in another e-mail that there was an HWPoisoned flag
>> for the raw error 4K page.
>>> We could use that flag just to skip that raw error page and still use
>>> the zeropage for other healthy sub-pages. I'll try that.
>>
>> That HWPoisoned flag is only set for raw pages where an error has been
>> detected. Maybe Linux could implement an
>> "is_this_page_all_zero_mc_safe()"[1] that would catch undetected poison
> 
> This sounds like a great suggestion to me.
> Let's see what others think about this and the name (though the name already LGTM 😊).

The function name is just ... special. Not the good type of special IMHO. :)

Note that we'll be moving to pages_identical() in [1]. Maybe we would 
want a pages_identical_mc() or sth. like that as a follow up later.


So in any case, make that a follow-up work on top of a simple fix.

[1] https://lore.kernel.org/all/20250922021458.68123-1-lance.yang@linux.dev/

-- 
Cheers

David / dhildenb


