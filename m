Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6007C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9656B00B0; Thu, 24 Jul 2025 05:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679966B00B1; Thu, 24 Jul 2025 05:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD076B00A9; Thu, 24 Jul 2025 05:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE2F6B00A2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:32:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02FCE14033B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:32:52 +0000 (UTC)
X-FDA: 83698643826.03.11F7FBE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 953F620008
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:32:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X0OQO5RC;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7uCQhwKP9dLIvdktJaD9mbq81ibyvlDaVR50SYdU1Q=;
	b=BOHIdkHnF1viJCYxt5mFIFX8+nFJ+gYURrEh5+YQPTumnUws+XpsoJWJHKRe/66TFXjp9U
	JnFnBsUQHKSsfDCWCHLj5y0olxT6mI1xx/d712REMq9bUrXUtK+K4CnJ1/Vd8rthEG4QyZ
	xmDt2AEYCwiFDJJKc6f1hJUw7Nu7284=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349570; a=rsa-sha256;
	cv=none;
	b=cuWSfbEQ5IXg7YWpTd3W6gCnXq3F/8FMqDSi1o5z+XurVcCmexBh8qr7iTquhdKZHms0GS
	Gc0sa0kZBNvhnngldlwMqJtMrgYrBlXZkEIBgiu4StibM4XVlA3C1KNq+zh60G4egn8CMu
	0gJ3tkfIbOyTn778Pz+PrgGmSiqztbs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X0OQO5RC;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753349570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Q7uCQhwKP9dLIvdktJaD9mbq81ibyvlDaVR50SYdU1Q=;
	b=X0OQO5RCJaWW9ymnE1i8fvLDDoD8GKvic3kS0DqsaUZ0Xk2RF9sUsF8gNElwcYmjEaz9yK
	Lz22TmLbDINdpx8hXP12AwMK7gZDXyMA0TW+U72mU6WsCqu0mGqbOF8boZ8Sn5jSieNMAk
	AlbXU1SVByUjzFtVgJe3ZwElW5JCzvY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-iT3ROE6dPTaPnY5aaeeHKg-1; Thu, 24 Jul 2025 05:32:48 -0400
X-MC-Unique: iT3ROE6dPTaPnY5aaeeHKg-1
X-Mimecast-MFC-AGG-ID: iT3ROE6dPTaPnY5aaeeHKg_1753349567
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-454dee17a91so5883385e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349567; x=1753954367;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q7uCQhwKP9dLIvdktJaD9mbq81ibyvlDaVR50SYdU1Q=;
        b=vdywl9jKp3sWJzg9rzIkwWzVCGHr6zUzvMTfgweItD6+xT8/2zCtfMwF1oiCKjL11e
         26nDrh9WXBG7n04UPEYbUju0xFjDFAuyTPFalPxOF9LIvJb2NdA2rwTJNcDqHlTdX2mJ
         4fFGkcf+1Tg/ApcjMHGOKLD1JwLzobPzdUKjZNIvGafy50rHPGy+dvnWshF7MBKEr2qN
         gpqk+ex4Hd5hX0hX8nxcR3ujpmCX7tkfOHycXGXL+FmedegIsfO+4MAh8eYYDothCW9c
         2mCDCeUCKYda/yoC32KAFQT3FNtfyAe13Zk/b4meTHRs2NMEwlI2+nIFg2g7t3D4FNlq
         1RTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBvZqgi43cgGFJN5ccu8FvSthaCKIQeh8ld3z/PmQ/z/AGHKxxrP9RYJkOMfkShjUotRVBT7M4lA==@kvack.org
X-Gm-Message-State: AOJu0YykdFAA3F7rNSuKSbTxgGYyCRHqR41k3GXJc6+EsS1vprwwlNBt
	6Uc+LqbiNB60z/+1QvylODHvLLQKKolZGm3B8ibiI/I6R5hGhTXnPPCPdr6Px/bkOT5FcJbQ4OC
	RPW3djn1rLYk7cqq9P2J3AZc4RLABq3f9x54zI6fn7PyqNwO19m8I
X-Gm-Gg: ASbGncslIYdWvZi3+G66A4I4j+sy4wXjaKYASC/jppq68lLoyYHXd9ugKRhPRpMI493
	do0DlDCpZsX1N1BPto4RcEZ8Ml/Awox3CqoX8Kv4zuHEL2hBdP+1R/LaCA3lSP1XB0kNONuVD4I
	lK/2er9GGxfIxLKDySfTyf19byrBO4i+ZtXKmw9zagUac5jVahnvhvSkTj/VMRynLVTicsVn/zF
	atLr+y71aFQh5JAh/pmenuiQ42+9Vk/0DJYoiPkTu3jwWCHKXP6PITkDya9UnaKn1f6AFiKuOxl
	2X7L3/w9//IVOyCIYXCWOoEvOeCeoaiMq0bTm0babkCBaSR/QV3bi7O4fs3L0jtbDTO2r9KuBhd
	h9khI+rXCKIm1px1YkkJr9weJFb53wmShr6MWRwJeOL3GPVNp1qX8eS9rp9A9skCN
X-Received: by 2002:a05:600c:6295:b0:456:1bae:5478 with SMTP id 5b1f17b1804b1-45868c75008mr61284535e9.2.1753349566866;
        Thu, 24 Jul 2025 02:32:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGgRm3hljQJ07PojBQ5FpXpLe9MmgVV9TG5vqehFxZVZNSzXPtZOOEFRcpY1A/+rO7OoBZZw==
X-Received: by 2002:a05:600c:6295:b0:456:1bae:5478 with SMTP id 5b1f17b1804b1-45868c75008mr61284025e9.2.1753349566358;
        Thu, 24 Jul 2025 02:32:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:5e00:c941:d6fb:3e30:b42? (p200300d82f1f5e00c941d6fb3e300b42.dip0.t-ipconnect.de. [2003:d8:2f1f:5e00:c941:d6fb:3e30:b42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4586e7d1326sm16573555e9.0.2025.07.24.02.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 02:32:45 -0700 (PDT)
Message-ID: <23b986e2-80d6-432f-8188-7a11d6915c9f@redhat.com>
Date: Thu, 24 Jul 2025 11:32:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
From: David Hildenbrand <david@redhat.com>
To: Huan Yang <link@vivo.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, Usama Arif <usamaarif642@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724084441.380404-1-link@vivo.com>
 <86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com>
 <cc560d48-884d-4c8f-9fb0-565d74ad769a@vivo.com>
 <e9bb93a6-1e95-40e5-ad10-a60d80735432@redhat.com>
 <6d14e212-418e-4734-b256-b75c6fade25c@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <6d14e212-418e-4734-b256-b75c6fade25c@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9fCyH7QciiqsPkLj2p9dm6XMjKZqOJ6UTPnNA2DjNAs_1753349567
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 953F620008
X-Stat-Signature: czbzehktn733xzdupk9h6q6hxq3pq7od
X-Rspam-User: 
X-HE-Tag: 1753349570-328316
X-HE-Meta: U2FsdGVkX1/8g4y5Ly3NLaiznzbZIqErUPBIIO1jsPh6LxXrglqkTPda4oIDj/7fCUcLKy+GTPirPPfntlghr8NQyafitd0l3333QCAWSxJGsXaEyA3dJpEi4KcSpPg0jSE3/Oriz51/X2RJjjV4xxgLgKBY7cpD3DLGoV9OP8boRE6zo7UQbWdm93NBE4EnvhZ5fO5WTGEWAWyHVbB3IxF26X/Rfk+XP5FoW6X7Czm84gMyGb6RTt9kX8Lsoxq4KEh6j8r3dkV5EUpwZ+cStBG8yTY7Ot4lFdziOP7oZAO3fSjsrzGC16UOkymKo9VcMCtz80FGY71ThNG1YOFr3CVeSq947It4sLz+liQoyCU+vDIiF66QrVIlnbVwUg88cHz8I8kmBDwye8TLQzv9NeqyTrw0Me5anlkN+oWtqT0n8qqIqL6YDseSW7s5nUfsRe25WR27VnYTX4q3g0bbWaw86ymVL9yaGdjUe9E4QA0TMCuKSK5KklQaOJrzlwOKCCdLW/ltdTFBOM2Q9cYsCWxJFC+IMTfM0wwEBg7Y5E7QLdXrVwQznBeA7JecZnQlrpDhKyi3qFesOIqv4Z9KcKThZhO8HdJq8D4Wa4xFQgBw6U2M1stCVtuIuCBxty05G4SUpsXpFr6rcdGR7YcArBzbn7ro6iN87axcNMe1vcTX6axLIsi/F5xYf7heIxHWUGE4AuYDWzX2kzd9usphAdrFEIvzUvA7if4Gp5Vmk8GiddQRgHbhfBImN+j3FqcQTNEDBfJh9DrivTJbxX7zRhwHpAmsmFwfAHcIxWOFNC16fOAr0bbUEyr30bqTQe0oCsSP2hRppp03hMQQGfGcpvhFUsaZt8uDr21i4S4uZhxfEGONMZ/IyEyoFY0UogHnwXpx83WGkTy7T09qNIS5/gMmWVygLgvrwAtpmOKPYFJNZFLgUDx8wYKYTnCGxRU3tz48KtPHxGWVrJ8X1AK
 kOy12H3q
 hp5/0nOLiPOzgA2oGvaRknuJrvMF0C6gFLJPNSC7fyTVX9ZHxRDMtbRSH4H5r4sfHZLx4fh04dehogEqdL1T+Q2SQu6xtlylSLDVRdx8gArSZXZYAakpZwd8iX1b4/rw65tDOMfw3MRsL3Mw2MNNAhNf6JMB9JIap6xLXRJvjOOuI9bul0VDsdoUAGsv1QskH4cSA0Dgn/P78HvxBv97VOElCZGrWiv96LEssNxbzAN889bORZLwNpssUHi8dkhD8m1/aQzhYL59WRKaFSQXPvd8Rsjn3l28NcRl5g+/heJuiIHz67BxiacaaOKW6ihoZ90uqOXvbrOGMPghwwl3osVH4GlYHFFP+7VYOhnl4eSUJL5SqaKU+JxDc7J9gO4sbk912RVnhm3+GVGy0cRzdKUMSK8B89j7o5XI5YJyoQ1casfATVt6xQFzl1twUWv3Lqst/295ieV37AdQQqGeHsC4d5t5cj8S+4XoBOKMy7wBfBiXF26atd30pmX5eTUofVJky2Lbhgxe92esyXrl1Oxuxdb01aKfyd+27L7+unxWVPJ0tOeqOYR88DEF3evgsuKsgoy9sef2AQilpik/5I1wUckUKPi39aUv4Iuf2YeusfeCP/oKeNngstnuwcfo9qwCSwcsSnMzzu0k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 11:20, David Hildenbrand wrote:
> On 24.07.25 11:12, David Hildenbrand wrote:
>> On 24.07.25 11:09, Huan Yang wrote:
>>>
>>> 在 2025/7/24 16:59, David Hildenbrand 写道:
>>>> On 24.07.25 10:44, Huan Yang wrote:
>>>>> Summary
>>>>> ==
>>>>> This patchset reuses page_type to store migrate entry count during the
>>>>> period from migrate entry setup to removal, enabling accelerated VMA
>>>>> traversal when removing migrate entries, following a similar
>>>>> principle to
>>>>> early termination when folio is unmapped in try_to_migrate.
>>>>
>>>> I absolutely detest (ab)using page types for that, so no from my side
>>>> unless I am missing something important.
>>>>
>>>>>
>>>>> In my self-constructed test scenario, the migration time can be reduced
>>>>
>>>> How relevant is that in practice?
>>>
>>> IMO, any folio mapped < nr vma in mapping(anon_vma, addresss_space),
>>> will benefit from this.
>>>
>>> So, all pages that have been COW-ed by child processes can be skipped.
>>
>> For small anon folios, you could use the anon-exclusive marker to derive
>> "there can only be a single mapping".
>>
>> It's stored alongside the migration entry.
>>
>> So once you restored that single migration entry, you can just stop the
>> walk.
> 
> Essentially, something (untested) like this:
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 425401b2d4e14..aa5bf96b1daee 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -421,6 +421,15 @@ static bool remove_migration_pte(struct folio *folio,
>    
>                   /* No need to invalidate - it was non-present before */
>                   update_mmu_cache(vma, pvmw.address, pvmw.pte);
> +
> +               /*
> +                * If the small anon folio is exclusive, here can be exactly one
> +                * page mapping -- the one we just restored.
> +                */
> +               if (!folio_test_large(folio) && (rmap_flags & RMAP_EXCLUSIVE)) {
> +                       page_vma_mapped_walk_done(&pvmw);
> +                       break;
> +               }
>           }
>    
>           return true;

Probably that won't really help I assume, because __folio_set_anon() 
will move the new anon folio under vma->anon_vma, not vma->anon_vma->root.

So I assume you mean that we had a COW-shared folio now mapped only into 
some VMAs (some mappings in other processes removed due to CoW or similar).

In that case aborting early can help.

Not in all cases though, just imagine that the very last VMA we're 
iterating maps the page. You have to iterate through all of them either 
way ... no way around that, really.

-- 
Cheers,

David / dhildenb


