Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC65DC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C46D6B018D; Thu, 24 Jul 2025 05:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B996B018F; Thu, 24 Jul 2025 05:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B426B0193; Thu, 24 Jul 2025 05:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 580976B018D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:20:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FDC21A02DF
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:20:53 +0000 (UTC)
X-FDA: 83698613586.28.01AADFF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id A1C1A40008
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:20:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GXybMGmq;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753348850; a=rsa-sha256;
	cv=none;
	b=Um1fHGBNXCPjWKnXFYe+FCoxJp6rjcfjyaMBdpOXVZncONC4a9vrhO77CzY5aC/fj7DRGl
	o2g74Qp+bAkkANEiBV/G55feV39/LSbWzoki33SqujnBGcMiqPfDz4LzDK0Feu12BIYsv6
	xVlmgAD3mM0S5O3D8xJ2tHYqvzGk/sY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GXybMGmq;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753348850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0KQOXhvdl0E5NsfW0rWRgN9O8Gb98pd0x7UFntxo6M=;
	b=wNi7PZxVcF8YVcHwSvQTG1mbx6ix3cZUqYQV+moXXiObjJqy16FFhSYMgjLoozllZV94R5
	4E+jqtd9xyoWH+dvQp9eZE6pw9ilRIBB0ILd3MS8gUM3ZiKUg9tNfJrytKus8PAPphMWBd
	sv+u+KZ5cqwmKllRZHm9/eiJ6xlwYGE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753348850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=o0KQOXhvdl0E5NsfW0rWRgN9O8Gb98pd0x7UFntxo6M=;
	b=GXybMGmqRUUfVwU+IR1HokskJ2MT+wkSPrezjy6l3HbtlGfb33HfCJ3415InWFl6nux3ch
	qmLG7kPwuxBVB/m+fC5l2G4wUjoNhgVKdXmpD3tRLpkmw6pU6bt9pGqLTS/TqxNMnxRkr0
	qjqBE+c6DEC39Z1v4xxp2KHj4vQb9UQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563--jLnXJyNOryVlmnu0EG8AA-1; Thu, 24 Jul 2025 05:20:46 -0400
X-MC-Unique: -jLnXJyNOryVlmnu0EG8AA-1
X-Mimecast-MFC-AGG-ID: -jLnXJyNOryVlmnu0EG8AA_1753348846
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a5281ba3a4so271204f8f.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:20:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753348845; x=1753953645;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0KQOXhvdl0E5NsfW0rWRgN9O8Gb98pd0x7UFntxo6M=;
        b=YOV+Tskh3E6Pn8FxpIUlz/OuXrIL4AVIJMpZvit6UozxBYRATKOoAZQ8uRles3EoWU
         qSPf0JMbSkRan5rkAu1+1FOIJ/hNbZU+hAxGKXdyHAO+L5w5O5GAxXTsgbNlR1RPJg/7
         RZWytl4FAnNEoZSWfhGylnVjWtek1O0H+WLFCnrGhsFC+dnQtMRmhbL0dgZmfSPbY4zn
         x45sIuJMpRZ2crYbEkPXKRw+fz0YzEFR/i72HJM86Wp4oofEpFmtwdCw3W6LwDmr1mfJ
         rSZZlzNk0EbZdXrOA2Nic/FNoOIPdDn9RnLu0lzhqHvKDCwWT/QEQgGkr5H6386T7Ipm
         xtNg==
X-Forwarded-Encrypted: i=1; AJvYcCWZq/uKhv0UkJAAcFvUq1U1DbwUsKEU7s7yvjyICK2blbgezRFDZgUCk/Ug3CYPn5FDRP/lhQM2+w==@kvack.org
X-Gm-Message-State: AOJu0YzXPAQ98LppyD/FQU/i0R9iKD8PU7L4Mz4dBOYMlVEiqvVM9eYv
	FssT1xb2LetM5U/NTDqdw2/mM/oQk2HrNttzfY/hpys7KK+v+75N+LGXfh3JZ0uQ+DLVsxO37VY
	NQGlPjcuZqLoVjJci7mv5p6y48/Bq29bZtY8VwQFC4dKhnr9PKgHi
X-Gm-Gg: ASbGncvKdCnpr5LA2gfvQt28H0nAEYM7LLkerGADgK/bmJ7ZjWRZp96G01V1nL3CjKG
	RdlSaaj37MSxdOrbG20KXuZgm8zN9Ezcc/TuiwhBT2ufjaMxp6EDF7b8aJTVS/cAhqMt3KkBXva
	ByqLjb2FMJLFdzP2qh9Cog1D9WkMJKT8qU7iEE8MejO4yGVTIoOYuoZiGldDBlSVVviV2qnozJz
	de6kqV7BdQ23YDX24YgrUBFfbZ7E9t0KHgjTQap3SloEJs65db4hp3jHopD7H4vApE2a36nVnj9
	ueHCD2bpZplBE+u8Kq/fiNVtjS/+GZReaynRTocwp/5t5TOhf0I2zodk9hYiK5BoEcksG9JKzUZ
	RScYiCH10XmGNlYE6DMXFx/npn9Z7Ib11OOgJE3AxiJzITprYdEA2mjJxNV4ZZE3C
X-Received: by 2002:a05:6000:230f:b0:3a5:2465:c0c8 with SMTP id ffacd0b85a97d-3b768ecf387mr4907850f8f.7.1753348845472;
        Thu, 24 Jul 2025 02:20:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8sP+bhjvLf/wV0ECiS76roKzHB7SD6ppw8rkCNfToaFey0aWT3TtUeqzBvR1r2m9NLAMX9Q==
X-Received: by 2002:a05:6000:230f:b0:3a5:2465:c0c8 with SMTP id ffacd0b85a97d-3b768ecf387mr4907818f8f.7.1753348844926;
        Thu, 24 Jul 2025 02:20:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:5e00:c941:d6fb:3e30:b42? (p200300d82f1f5e00c941d6fb3e300b42.dip0.t-ipconnect.de. [2003:d8:2f1f:5e00:c941:d6fb:3e30:b42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705545bcsm12688485e9.20.2025.07.24.02.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 02:20:44 -0700 (PDT)
Message-ID: <6d14e212-418e-4734-b256-b75c6fade25c@redhat.com>
Date: Thu, 24 Jul 2025 11:20:42 +0200
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
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <e9bb93a6-1e95-40e5-ad10-a60d80735432@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MCXGoVzQW5fKd_g_6KKzPflhJSlTb6XL4VOn8C4FFtU_1753348846
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1C1A40008
X-Stat-Signature: qpbi36s889f7mzsnniwpnwaxjzza9akh
X-HE-Tag: 1753348850-464007
X-HE-Meta: U2FsdGVkX19ccEuY7z7/PeBOuytg2WIHNdPt2nTkqiVZgynkYlozHNDDipbDNeQKVBlD/8L2WI826UQg+f10WJGmTxqfwUIdmo0+ePHTy2s6QwiSuvv0WQqsxxaIsLSLjXxIiAKd1viXwHg+ZBTP+YmHYsph7TvsSLzSA9/rcOJ81cIHivivpEdt2lN0FJeyrB3Yn2XV2eaCH63F9IvstFQiq5BINdDBOByS2D3r0hfaK3WklmMmON/Tv12JkqyLoqw4XNazhKh5ITyINTuBOwHC/34CSMyrbFEM8U0b3i+IxHMIwK+2c+Dfrb2qYGt62DggIAYn1ulPWV+Gs4byWwRBNrihiaPjWtvqFM86NpgsTMOpKmrL3EFZ3gtyInl9rbkM+JctCxaKBsvJvUL2RBpQ6OVKXZdj7Joe/BKivMA9+kGGCWYp1iXniDgNpNxObtximpL6JyzA629YIvOEF4mXuzqxkqLARqziw1gkLaLZWBB6ryJ6boLjGZ9YhbmE2dBjOYWfmaOoAeAWaE+ficSenSXweCkq/0m2fMbWivIFbN6cAf1D7rMn/F3xICxI3WICFDH74vPkFFpMmZGj0ybFBTQEiMaSDhfECY9dlVqV8lbxs6C4wQx/2IbQni6Zff7g3NkU3VTyEdZ/w2pRJ16vrlfgRIwmEFw5WvzZUcGHh+bAxXEyU5bZq4LxQCbSPpmInk1/uD9AZrCnXbNrpX8D/2YPiTYSEJju1fMn5/iA3KCtdStWYm7LrCauFEd2hxbASNEW/v+ilUNuNzTSmKZKnZQI26QF29TMy7K1u2vgsR0cFKpuefjvxa+hSOpgG4XwLghBxWuZNkW1hDzQNkaEv16rjteFtY5rRpcw97PV6b9Sb8CGG9on0/C3UCQvCWDtvSmc7TIAIsVheO0rFq8GBrAsVuADYpAdroThIjfbEi3vZn2yrWqQfem/Pkmue4mHUSS3aiq0CeilrB1
 tQP2ipnY
 gZpwn4veXJzMEpiOiUTR2Lh+Pou6DKjNE2ziEX4Y8geRMiJyWsaWCOYuJpEsFDYzRRlXME90oLm5zT0fZveMjfx3kIGJEuLHgwaPO5YGuwph35ttPhshOa6xmQmr7y3YnhoAvNWQiimsO77MRdPZQNz0inKUt+hvcmsVfIKz/btCQFZqFIIjToNzjDoYH7NhT+b8otkn/8E4sJKU4tFFCd7BijASxAZK2rVqCUr0dkB3bXWsh0XbHJNidooX5B2PYyM0emmuNB4sBKzBw8zscdYBb56I6pnmg6WsIyndNWQB+LU8WTGEQgRSc2OsrGIIylM3uwT9AA+9Iv5UvGMildM5ynn0QoIDRikDDQJdb4bJBWhBcZIZX0XDvwI3J21Zf7+xzz1rrtmFgHmgPkF7gRi6ssbKmnzGZaMf72+hKjg/VZAks21mAAnV6f6zCVnDZwHSwRqhG0uL83NwKpybRVzA+cleHdKe+eY9WR885AZDTMurXg/oHQbpRA4DegsWXZWm2HafTysCbOnI3LCHNnZpPFvMXXIu1ABZxC/8XY4OypLTQxVisC0AotWC3FCbHpqyFD3ARQuxbx7aMX5QbST0UQm14NsMHdBWRIRv7ynr5l3XduEiCsWG72bKFdl3PPl8jaeYJK48Axxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 11:12, David Hildenbrand wrote:
> On 24.07.25 11:09, Huan Yang wrote:
>>
>> 在 2025/7/24 16:59, David Hildenbrand 写道:
>>> On 24.07.25 10:44, Huan Yang wrote:
>>>> Summary
>>>> ==
>>>> This patchset reuses page_type to store migrate entry count during the
>>>> period from migrate entry setup to removal, enabling accelerated VMA
>>>> traversal when removing migrate entries, following a similar
>>>> principle to
>>>> early termination when folio is unmapped in try_to_migrate.
>>>
>>> I absolutely detest (ab)using page types for that, so no from my side
>>> unless I am missing something important.
>>>
>>>>
>>>> In my self-constructed test scenario, the migration time can be reduced
>>>
>>> How relevant is that in practice?
>>
>> IMO, any folio mapped < nr vma in mapping(anon_vma, addresss_space),
>> will benefit from this.
>>
>> So, all pages that have been COW-ed by child processes can be skipped.
> 
> For small anon folios, you could use the anon-exclusive marker to derive
> "there can only be a single mapping".
> 
> It's stored alongside the migration entry.
> 
> So once you restored that single migration entry, you can just stop the
> walk.

Essentially, something (untested) like this:

diff --git a/mm/migrate.c b/mm/migrate.c
index 425401b2d4e14..aa5bf96b1daee 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -421,6 +421,15 @@ static bool remove_migration_pte(struct folio *folio,
  
                 /* No need to invalidate - it was non-present before */
                 update_mmu_cache(vma, pvmw.address, pvmw.pte);
+
+               /*
+                * If the small anon folio is exclusive, here can be exactly one
+                * page mapping -- the one we just restored.
+                */
+               if (!folio_test_large(folio) && (rmap_flags & RMAP_EXCLUSIVE)) {
+                       page_vma_mapped_walk_done(&pvmw);
+                       break;
+               }
         }
  
         return true;


-- 
Cheers,

David / dhildenb


