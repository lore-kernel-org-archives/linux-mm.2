Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE1AC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A948E0005; Tue,  5 Aug 2025 08:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352FD8E0001; Tue,  5 Aug 2025 08:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241BD8E0005; Tue,  5 Aug 2025 08:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13C778E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:58:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A49FF811FD
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:58:50 +0000 (UTC)
X-FDA: 83742708420.01.DDC3165
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 22913180002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:58:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S/v7iCa+";
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754398728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTZfMQLhSPfCJQmmLYuzfiipP2GKwI927nDiRlIvHCA=;
	b=00f0+anqyaLHtwJ6dHZE0cFjhhma/W1D4xiy+go4NcQANCKdbeXUvt4vev7ARIoviIaOuZ
	KXN6kydcZHGznKjwAlDHt7k+DGn9CXHVAngf+sXDmErv6BUUQmEC6M99NkDs4vX0M1UKHC
	+d0wTOO1/5AjCi1WDdz09QB03dA9Fio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754398728; a=rsa-sha256;
	cv=none;
	b=gfmzVLpsJDREJP94mp5S5rm5uSfmt4Itozk1LdaaiyYnM9SvDC63AIADCX03TTNv8zorix
	iawh180rtfKVtodCg6wkkhd+wlJokcFPPlGqLGzVG2fVmCDrUTsGHw29Q1aPrWGvDO7cev
	k1/jBnUffaNPUy34SzS0eZ6FSe2MMdw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S/v7iCa+";
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754398727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lTZfMQLhSPfCJQmmLYuzfiipP2GKwI927nDiRlIvHCA=;
	b=S/v7iCa+oW7p4BZOnp1yMOaZgVMkhTR0droITjj/mjy/e7DI5DMCFsmEWk1wgJbuHf53zT
	NdjSIyEnXVAlvEYLWQiU1bygBKyY9f1Zdddb47f2VHumks+hlk5YLKvRHAHGWbYLrcU+ft
	QUNR+TUK/4nG8uS0mYTZ88iLluj+6M0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-eZY8jXBHP8afzPNzC-FEuw-1; Tue, 05 Aug 2025 08:58:46 -0400
X-MC-Unique: eZY8jXBHP8afzPNzC-FEuw-1
X-Mimecast-MFC-AGG-ID: eZY8jXBHP8afzPNzC-FEuw_1754398725
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b20f50da27so2716336f8f.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:58:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754398725; x=1755003525;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lTZfMQLhSPfCJQmmLYuzfiipP2GKwI927nDiRlIvHCA=;
        b=eGJF1ljmrpJQxY84MrbXMjmFdfBvJSJOCVOGjqB6p1yqWd/bP5OFdLntIzMcHck2JQ
         9lUXrEDozUNWxItXTbKmugnGyKoLg8pDpyXl9Jtk91zsIWTAPYmcwfJqakdfj5nIPUfs
         KPyEVNMm8W/jp2pyOqvgAm0qES/3FXnLTwlox4V7SKj1V++NfXOvqFZbHHrDpG24t69Q
         Jydi+/cfrsG9NmMKbKHe1QqDd75cEp/RMJCB6oluQsC5nnO/1zwqilI8+zjoOGcSt2k4
         E2SnHF24VNgHtUva72VjgEryYSa6ngPLo3rJ7Vwx6hF9SxO5t9My1uqKc6/V6kyoE9YE
         RRjg==
X-Forwarded-Encrypted: i=1; AJvYcCVOLeSn4jVOJlJ9sev9YTmcp9kR4uVgoMMhcM/2toldlEL7are9Bwlqyrcaw1hPdwv1mb+U71L8QA==@kvack.org
X-Gm-Message-State: AOJu0Yz0c9xfoSf+KIAAyjPfbg7Fswtl5oQHF6SQcbsVvHN5GDEBGTFf
	3/UQonCmDBA9BMS+ilEdcwY0rk5qk2zNZrHtvypdL4Uv+qVTwhRtjpiTZ5byCzZ9LgxqHysQs8p
	ABnYiCUH0o2bY807VmyQKdaNWr4uJPiyvLkCRayP18SXAa/3YuaFd
X-Gm-Gg: ASbGnct3ffohTL+sQs1ACDvMmzSaWeBeKB9LSfhuMrYQ8axQ6E0yuPl6jNztp2IVIXU
	yMjd8MKXA9qgMC3h6Bu++ti0sCxEAuqkYnJNn4u6plO1/lwncAtnhnIPJiBzAVr4jedmi+Dzszy
	KoLD45WEdFHzf8PlkueHe41h4XTJfkZjrhz2Scnyjxlh2k6kU/TETSGCLWEFmzy8jbIktGTSaFa
	vqxJxOeQkbjkVN8IwvwJoqt4Q/oRec0SKLcTVb/9MTnPuuTeuPbuM2V0eOHPGf3s28mhT7tWZGw
	PVp673g0vP+ktd5n7RRM6DDWngsqfnamAylsbBsn2q6naTUi9KHdhGoJaHBR7iQ8gpS+NL4=
X-Received: by 2002:a5d:5f4a:0:b0:3b8:d25e:f480 with SMTP id ffacd0b85a97d-3b8ebed2fdbmr2863430f8f.29.1754398725174;
        Tue, 05 Aug 2025 05:58:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1e51JlGAL/9wdzpcbyPC9c3UCgkCY7wkeuF90OqGQFtbP0YkZLeOQM7IrojmjymtuR99b9g==
X-Received: by 2002:a5d:5f4a:0:b0:3b8:d25e:f480 with SMTP id ffacd0b85a97d-3b8ebed2fdbmr2863402f8f.29.1754398724748;
        Tue, 05 Aug 2025 05:58:44 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a26f.dip0.t-ipconnect.de. [87.161.162.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c469319sm18864766f8f.54.2025.08.05.05.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:58:44 -0700 (PDT)
Message-ID: <da283a44-e668-4e88-985c-3e2805b556bc@redhat.com>
Date: Tue, 5 Aug 2025 14:58:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 01/11] mm/zone_device: support large zone device private
 folios
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>,
 Ralph Campbell <rcampbell@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-2-balbirs@nvidia.com>
 <dbebbba0-3c59-4ee1-b32c-4b9f6ed90d92@redhat.com>
 <1e307223-897c-4db0-9564-95d76bc3d260@nvidia.com>
 <98a30c7f-8be1-4b08-955c-724667971288@redhat.com>
 <9c0ad782-e1c3-4c7d-bb20-730d2f915dd5@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <9c0ad782-e1c3-4c7d-bb20-730d2f915dd5@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a9szD9zAaA_oX7Lw4M_J6Mte4PQd4Et93dbzOpEbhXc_1754398725
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 22913180002
X-Stat-Signature: 1rwoosgwofub891o93e1ni97o3wert19
X-Rspam-User: 
X-HE-Tag: 1754398727-283727
X-HE-Meta: U2FsdGVkX1+MlbNNoLVXj6XM5F2Qo8N3+nsZGY5vdAjOdFWEBFcujwX14tHbwFia50yW6iKQWBgho2gI1ZKVJpWr0dXd2nYfU62KM9oSprZMuV1u03qRLMg6pC70yo3hNZ1xm1MTECIrD7zvKlyAUXAZYKDeN6R0EiQFSlc1f6MRRvV3yfHglmUZZIr1Xhoqykj1sKNNK3KXTK2BtDexTvyjp7wKQ8ry1YfAeaJWPxr34bqWNO+dCFlDGzBdlDLm26BmQx1XpnfU6DG+CuKS+OQXrz2R5b0lviV9V6kahI5BlaYrd26Q9+Ei1XXaxLD6RDvj3NoAQormrE+bYbcED+co0Vl5AGdwX3xGQIcRalpPoBMG7BhitfIVC3chISGFR5BAZzRSAnaolzmxJI0jVweAql9ggPVobASz6Mc8hP32bQM2mmtqk4OBvAYaHjZh5+J8NSHmRLtnX62E+EE0L1LZiTD9mnBY2emNJK5YKr790Qwzqq2kHVNvieOK9+xZeOSUwLJU0KbsZij5OnJWb67KFFFWfhJfhc8tnqG0+R3yb9p5Ldo3KulYGObaGBAGkrrtcqjOndWFyDDSNnAgPWIHar2ea27onIPsEKo2GXfQSqZHrUccUCns8wErErGR40/67zF5TkGZIj67XkRI+r36xTvpdLg4H5nhFPbf6qAJH3dj7dqxpXIsCt2GBaImHSXVLh5nPAIRy4vLujrZtmd8WsI8MtEx27XzgHyWIMQDyfXXvD/m8Rf4fMuAnWcGTmfzW67js8VHkgQQBp3aPENdtQOUGKKtRuiak12riR7nQ7L2cu6+IndspkiUT2v3PUmOb0dunddNkuGOP/a5igShjUoBKWhGu6SI3LakyjqbD6PJlWVANnjE9nd51hPONkTEAWilKvaVCO2QKsQSDVCkz3OfZwoDxp3RBuQ5gmpG4AEY+5LZO0gqBIzUlVUo+/1G6DbzFpdXnMd3NDA
 Mx3GO7x1
 YwQh7ew6xZOvtiySjsw2Il8efeOcSBBMiFNHM1igLtvzTxG1U7sybTXNk2zc+UiXTD55bPSAgoqRKVifAf9cLKY3IxoyRBDDYvplWnvr6LZBHCPZTsK08hx9GjIbOGnAPcR1b0ClWGRoWA11V5WNdayrDxfhC1XnKK6bGrXbRkNDC1q7ye+zbwzCMEQ93bVVdSPWcE9i9N97/HPhWNzGbjlS6j/l+tG0BOqz4vpeKKKm8aAGTLTXYhvViiQECWcrfc7utCA4y9L4qcNs+oj/hZrPTTqI3hp1EL8dtYsrx+5J1ALzn9GF36afLMS9hGafeSs6f9RKd9+VaqYd+YIJXfvnZSvEUR5LdLomi5copbwUnaz3hsE1leKWYLaIRMsSi1nwfZYPAqfeAftF0GpXnk6HSoyFwVJUg4OXC0lYfbqGAAErT43bSL/VCzcuXMm4V94BFKD9TVixonVADyg5SGCT/rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 13:01, Balbir Singh wrote:
> On 8/5/25 20:57, David Hildenbrand wrote:
>> On 05.08.25 06:22, Balbir Singh wrote:
>>> On 7/30/25 19:50, David Hildenbrand wrote:
>>>
>>>> I think I asked that already but maybe missed the reply: Should these folios ever be added to the deferred split queue and is there any value in splitting them under memory pressure in the shrinker?
>>>>
>>>> My gut feeling is "No", because the buddy cannot make use of these folios, but maybe there is an interesting case where we want that behavior?
>>>>
>>>
>>> I realized I did not answer this
>>>
>>> deferred_split() is the default action when partial unmaps take place. Anything that does
>>> folio_rmap_remove_ptes can cause the folio to be deferred split if it gets partially
>>> unmapped.
>>
>> Right, but it's easy to exclude zone-device folios here. So the real question is: do you want to deal with deferred splits or not?
>>
>> If not, then just disable it right from the start.
>>
> 
> I agree, I was trying to avoid special casing device private folios unless needed to the extent possible

By introducing a completely separate split logic :P

Jokes aside, we have plenty of zone_device special-casing already, no 
harm in adding one more folio_is_zone_device() there.

Deferred splitting is all weird already that you can call yourself 
fortunate if you don't have to mess with that for zone-device folios.

Again, unless there is a benefit in having it.

-- 
Cheers,

David / dhildenb


