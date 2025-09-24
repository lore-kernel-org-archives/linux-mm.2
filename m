Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F99CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D138E0011; Wed, 24 Sep 2025 08:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4B78E0001; Wed, 24 Sep 2025 08:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B148E0011; Wed, 24 Sep 2025 08:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7458E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:49:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 107C71A0803
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:49:54 +0000 (UTC)
X-FDA: 83924125908.02.FD8AB04
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id AC7B24000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:49:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Zj5/AsDo";
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758718191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cHC3T2VfhHaR13TALJYW7Cdr1Z7CusERiD0/w5L3j6U=;
	b=Wc3+b8FUsXqcxwOICuWLNGsp/TU5jxS9sxJZi7ihv8hUegfrUBgSIXrGCd24TMr5gPfxak
	yMRTfTDUNhagHUUApPO/4YZHSMK7tFjrr/mZX+2zC88obfUWNPe1dX6RFlISiM0cYYhWJ3
	s0A/3y00rXFgjtCUY/gvGbzLq9m8R38=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Zj5/AsDo";
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758718191; a=rsa-sha256;
	cv=none;
	b=K4gihuuddJZToFP7EPVVfqRcQgVYS9fT3A8jpwV0SubUQBlpGmNezJsZ1y+uHm4adWHo9u
	sEEMjzHgVznPxu7TCLtEsL52YHwQObCTYvKi1KDzXAAUEoERC+Hl+hrjKN87YojruLfEKU
	fWjL9GfS6wf4iBd+XtWeiGTgf8E/W1A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758718191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cHC3T2VfhHaR13TALJYW7Cdr1Z7CusERiD0/w5L3j6U=;
	b=Zj5/AsDo8fxZ9k1ztExOATDXSha2k15QSFvCbI2dNu0N6rrWRtFwYQM0JQzgCkwgUOxqge
	EGfGLdE0hZk87iy+Vv4dX5c+Cv59G0YttRKOiSh+vDeNxoSzS3fsVXJzyrS9Abn9b3b9Lx
	IF3ORSd2NFcLYDY9f3kUjOVtE8RnuuU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-eh9tPrQMN96PXU65Wn10CQ-1; Wed, 24 Sep 2025 08:49:49 -0400
X-MC-Unique: eh9tPrQMN96PXU65Wn10CQ-1
X-Mimecast-MFC-AGG-ID: eh9tPrQMN96PXU65Wn10CQ_1758718189
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdc9dbc5fso4675059f8f.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:49:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758718188; x=1759322988;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cHC3T2VfhHaR13TALJYW7Cdr1Z7CusERiD0/w5L3j6U=;
        b=ska1Pc3CkZv9Zcaz4PE41x3huOYfcQiZ2MsmW1lZTYkY6J3T6ihRnUlM+98WdTdMNL
         Jdy0EHxbt0DMtWZCtdvRs9F2yEHiCGT/rPG+T9aliXGNxQ0hld1qbEu6oO/9RQsJ5xJs
         Yg6tc/IhJ5eNontEJ1KRZQRUXuF5o/gK+bdSUsMqTjy6sGycjbBwyQNTSjsAQWk3yyuf
         ET7JTkS0sYG9qHfWaz8AoacSb0Ba920A6yWCF4rEtmhya0bLd6VlxQrJ7dEif51UPjKl
         NPkj2ZhRb61HV1vHktMXXSgOvPHpxyWUVFOx7ZCL2UT2+TKf8+iRlwx6NgGyXDZC7qd5
         E2iA==
X-Forwarded-Encrypted: i=1; AJvYcCXoFyC1TplqlQrRZw5Mp9FNw4slpqfSga8yht8qI4srfppRV+YFu30BQ/WxEVlh1GpMS71LOfUvnA==@kvack.org
X-Gm-Message-State: AOJu0Yzcqq86EnmR0zJ4QDPa+bHHUwCJKJn2QfV6QDBZymKB45Zc0uA3
	BdT/9IRjowTzNU4Jf3V7cwcES5Dk8NVr2t+QkIyQcasVmJZ2Yd9gi0y/KklYoMoPQjX8j7XSg9c
	taAa9raUaA/BWIY4QrspLdO6K9rxBt5+f1M0Ynqqn1JuXmoaetnaY
X-Gm-Gg: ASbGncvUtTZzNht59qN8OTSh+Q3im6uqO8NJPfWLuKZjKeCzFNvSOf6lUNw9Q2ZBb13
	ZUi1JWm6j6mfGknZnrTkt3h48iGRihIGBwWfcxMKHo4VhgJWPx5TuGLsNujS3G4LlEiw8DNWKAT
	yUxOSpWLb8Fz10DR9j+DFbKMuyKDamLjf6hKduR7PsPcfkoA/3jTQsxwPByo2mSuMGZaERF3+55
	oFeKLHcruQ7+qXJGt2ScVak3jeM3wObIBAphwE1Thdiloz8gBIRzGWd+aJRZBOp0xfHPw1EfTrO
	yUoaOpW9vFGB31IOEGO9Bic6Ap/g9ZlxfyECIH48St3ZRI7EiBGqN1O7p66FfvKxdu383Akaoet
	H/WG+d2XGRKa/7q38Fna7WnblcttdR78C6/Sl1ExWLOsOYa0uOZA4puqzlmUDeV2PZg==
X-Received: by 2002:a5d:64c7:0:b0:3ec:e276:f3d5 with SMTP id ffacd0b85a97d-405cb7bbd3emr5343954f8f.42.1758718188550;
        Wed, 24 Sep 2025 05:49:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFx36SpowqNISp0RQInpY5EuDwZsj0Ac9eSfzcispu3U/tKhZ7kW2h2MXOTOLjwD00+FAK55Q==
X-Received: by 2002:a5d:64c7:0:b0:3ec:e276:f3d5 with SMTP id ffacd0b85a97d-405cb7bbd3emr5343929f8f.42.1758718188080;
        Wed, 24 Sep 2025 05:49:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2aae3d58sm34490655e9.21.2025.09.24.05.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 05:49:47 -0700 (PDT)
Message-ID: <8006c8c3-8e62-47c2-9d0d-9c7183dcdcf9@redhat.com>
Date: Wed, 24 Sep 2025 14:49:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mte: Do not flag the zero page as PG_mte_tagged
To: Lance Yang <lance.yang@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 Gergely Kovacs <Gergely.Kovacs2@arm.com>, Will Deacon <will@kernel.org>
References: <20250924123528.1536835-1-catalin.marinas@arm.com>
 <c07073f2-96b7-4044-94e2-b41a2f8ca633@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c07073f2-96b7-4044-94e2-b41a2f8ca633@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M_HS9jj951ZQlWzDmJGSK24HkMICsy7USlZCeyeebxA_1758718189
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AC7B24000E
X-Rspamd-Server: rspam05
X-Stat-Signature: 8a3on81mspkdzqqtsa4nkzazy1w4b5gw
X-Rspam-User: 
X-HE-Tag: 1758718191-991904
X-HE-Meta: U2FsdGVkX18LGmiHAWjz3icPQ2ZozPPywyMzWpL2K0/W54b3Xu8enXWvjbEESqO0444pXxrwbpv4GxgeinQkff+KmQrg5faq0vSUWL0RwfJE1J3Z/rPxtouvJzNOx+TScXONpVlsm/Pyg+PiuJJNNZ+DUmem9Was9H+dsAOBLa22Ny5aauD7ANCxg+KlHL8worWTkMbHgZq2AVBrQ4+NPTFFIZveQBLbuu568OA5KXXt13NH7VD9WM4Tzpin5PXJZOGIu8+C5KWDkAnieSVgqV/vdVI8DNSsRCGSH6Ghpp2CF7ZjSI0UNuytKVSxgCOtfT0CK4tO6ECFTe3qoQPLc0LXmfVJHckqbxr/HDO5Dq5e9864dwk1X/KJoYjItTKZtigeC9/CmK4Yx7uUZuH6sEmrHsmj4asKPU6zloCzy1gr7Y0ZHvpXU5uzqfUBNseqSORYz9UvPlU7m7WJnTQeA3Cmz3UxBIdpqBh90e/bg0iWr0z3HiFfEtUCBX73VBJNgzka6bmLwrAUvaZWnZVlrm90OoMpoyJYmJoL8xuRK2RpyazN/5PiIqk7qyWd/+epvAJxQzZdxOjYJ9IB2cP4dkqRHxUs5YYqibk4Bw72cXTBxH3nKtU3o2rz6E/y6Q10zvopVw7EDlc1wb5akQ0pbF6wuU98o7K+G87M7mKVO4RUcGTwknd99ldlDeZRJbsMC7/fZk4qjm/d5jNUnqRo97IAkeH5hNI19zMcXlacTYVhU3F+T+ILPb/uJofzyXZBvGfC2v+JifB7ClAmaHQqZRGYTqKrcPQ5z//byUwu1nYZJ7jCP5sR4CstCZr3mRgRquhyFPPQrcyflI5reqH8FduC6teMtDiuhkhIUPeNb6SIDeqDaQ82x11aJxOrZvdvkfiPWzBprd6AdwxoBdjKNN7MjYTVZ5BGvTSYnC8cWhKRAtf9Rpk37tOTUYFkYR4vmZdsyI8HAv++N+RtRu4
 IRFd6FMZ
 VFGMl48Hlx2Y1X69Hf69Q7mBzF6ipzulSCZK7U0uynHcKii1MpAzoGcc1tWFs4tNuxGNYodrEhCZbcE9quVWEpoWREVdnZxPAyABvjbN0NpPzrHtp4yYk1rsJArRo+/6k3CubktdnUaYRtUBl+3W8YuL7XWSLgQX+udeB29Cfo81ek2mLTIvlAWeAmpWnf/rHKRNiwdyP/jTPU4Bo/jTBubU0rYzErauEW8VF6FhFo8QIBl8YXnmhtNlmrIM+whff7HgG4rlpoK0WoRhe/HXSJExd1Ag8ajdqXf2zPg8gFzs0DERdP7CdQ1I916RKNlj3/rwvXVcYGuHx2bjW2nYkNz0K8HDDs/YKxcde/PbESCWjwFALmtpYuYlbp832bw3K3OhZVnJ5bqv74164uLz9ZJ/oeNCEp+LpUdNsJRhdi0X2w4EXCMOjKKeTGB8cs0N0GVqgQNrc/42lW3cMwJl8YjNiPbErRPaNjy6C7qQMamWTo5Ip0L/H8JiEfjPJLiOmjJeffrgZK8/sLXFY5bR3mKRVONDVXkmduNDi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 14:48, Lance Yang wrote:
> 
> 
> On 2025/9/24 20:31, Catalin Marinas wrote:
>> Commit 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the
>> zero page") attempted to fix ptrace() reading of tags from the zero page
>> by marking it as PG_mte_tagged during cpu_enable_mte(). The same commit
>> also changed the ptrace() tag access permission check to the VM_MTE vma
>> flag while turning the page flag test into a WARN_ON_ONCE().
>>
>> Attempting to set the PG_mte_tagged flag early with
>> CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled may either hang (after commit
>> d77e59a8fccd "arm64: mte: Lock a page for MTE tag initialisation") or
>> have the flags cleared later during page_alloc_init_late(). In addition,
>> pages_identical() -> memcmp_pages() will reject any comparison with the
>> zero page as it is marked as tagged.
>>
>> Partially revert the above commit to avoid setting PG_mte_tagged on the
>> zero page. Update the __access_remote_tags() warning on untagged pages
>> to ignore the zero page since it is known to have the tags initialised.
>>
>> Note that all user mapping of the zero page are marked as pte_special().
>> The arm64 set_pte_at() will not call mte_sync_tags() on such pages, so
>> PG_mte_tagged will remain cleared.
>>
>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> Fixes: 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page")
>> Reported-by: Gergely Kovacs <Gergely.Kovacs2@arm.com>
>> Cc: <stable@vger.kernel.org> # 5.10.x
>> Cc: Will Deacon <will@kernel.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> ---
>>
>> For reference, discussion on page merging here:
>>
>> https://lore.kernel.org/r/aNKJ5glToE4hMhWA@arm.com
> 
> Cool. LGTM.
> Acked-by: Lance Yang <lance.yang@linux.dev>


Likely you can provide even a Tested-by? Just saying :)

-- 
Cheers

David / dhildenb


