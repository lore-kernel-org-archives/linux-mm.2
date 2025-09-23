Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886CDCAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE87D8E000C; Tue, 23 Sep 2025 04:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9AB68E0001; Tue, 23 Sep 2025 04:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B881C8E000C; Tue, 23 Sep 2025 04:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A27098E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:37:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56D45C0917
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:37:11 +0000 (UTC)
X-FDA: 83919860262.25.FB62223
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 01CC01C0013
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:37:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R0DbxG2S;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758616629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FichtJezjG8Fw3oNsREz7KtXAArVifFDdwv8D/TDyo=;
	b=w7X5CguFrlRYgQbETL956eF++W4no4NpnHSGZ28QixCUvo+ujWrpOlSYSNIKrVsMScHS17
	Vn9gqp6nlgOQSFiM5PcGNwSzIPmnLRjP8bzYqGMoR0cTNYUjJPM1iGYTinOkN9FlzM7kIV
	7cKV60733fi+6knkrLkfqnfSjBx5ma0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758616629; a=rsa-sha256;
	cv=none;
	b=FdpIYasqN15RyYeIUokfSRL2C8GOJ9F8xN4Nff9MnwoSdSGbtv8yF1iOUZxKXmFe8uRhzN
	3f7v9aQsi+t57L2cTbINBw/jvjYJMpjXXSoq7glFwik1FfA0Fg1LR9qpNpUIfD4faQSkVP
	DtrfT4CpkPCx+6t80eKDOWMn83a9Hw8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R0DbxG2S;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758616628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0FichtJezjG8Fw3oNsREz7KtXAArVifFDdwv8D/TDyo=;
	b=R0DbxG2S1/TmUh2Zg6uGZ9y8eXX9JHNN/2bWJhuMsfBfptS4c4v9vbsLPB5hYAw2dJeJ+p
	uTQVXYthIDxQN/gGX9M7F84dSQJ0YAk65ZFF9zhhArnUClTO8rqCkEcDtMgB8MmsRFaePQ
	lGFVAEXnJSTxyPKdhtEBAx5BBLmQ0kQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-stUP4EjwMsef2M1MtyTNWg-1; Tue, 23 Sep 2025 04:37:06 -0400
X-MC-Unique: stUP4EjwMsef2M1MtyTNWg-1
X-Mimecast-MFC-AGG-ID: stUP4EjwMsef2M1MtyTNWg_1758616625
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ccd58af2bbso2551152f8f.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758616625; x=1759221425;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0FichtJezjG8Fw3oNsREz7KtXAArVifFDdwv8D/TDyo=;
        b=s1YU23DJi/lDyIph8TWqQ9vQDvIWRYVI16iJt5tn56kEZM1E9gayZb7cr9kg0lyu3a
         ue+WBy+tXDyuuWvhZrgviGgD/xxD55Tno6xDvL4G7ZcUF4UhYpc+FXWe331Exs6s3244
         Jo5kvopvNU65rTzhhSaQWITXYUgJRW+LmfW3btpnFd/otNDtTDT5z1tP6BHjpMsNrDnG
         WwBR3S8Dla8hAwXamv6KGNh7xeHd4EtxbIDGF6YVO0bjt6NuLhXeoyDfJP4RXhe20pU6
         HhAfGQ/IJWFR6dmEpIll3NL27CRNwklts7Nxy2VAqESUOaQuL2S/dlF/z0xlz0QfgaX7
         QrsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsVgT1T4+oLdRfBCPdxzYLe5aFCil+uF6JiRFE907Pcydbsih6mb768grAjqAHhhifuC0WwhDxYg==@kvack.org
X-Gm-Message-State: AOJu0YyNuLLDUlmng2UDCs5o8RhXD8dlkrMEKVSgrwgcSnPaJyRFs/u4
	EQOUiqxtqCMlkcjdyLpM1DIGC2tiiLKSDlVPO/IuTRF77RJlkbz8zIFuJ8zLmDgtbHxaP8kFIRg
	jgaoKjF8i8oAebltHzdT3i+5vTEKsazFJWENZ2jV6Daz+A6lQpBw7
X-Gm-Gg: ASbGncvAvJ3ONQ5fbirsmwyoOVoDSp2nwLmU2Jmz6eBxUlcKG/5T/SIB3zAqWzBTAlv
	4yv4z30NnfmF0QbTtm64YbOD5WL3tvR8+Pw488CeTCvYR1NMJmgNMJx656LLzbR/Uy0rIIc+vUZ
	88sStwX1efZiMPq8fwG+uAXKmEZz5H3Dh4in/m3JKc2HRgd1Saax3gEw6ZYpMAhos/3vW4PWt17
	g/eHgzf1cLzbSnHXiCLl3kLYws5a3tLiytkXFtuQvc9MVdgbEx0MNXKcylbxy+vFTUjK1bquB1j
	KENdvdpBA/2lOWC02VUloJnZVvElOzXYRjGp9HiDlRidtGtn5Ial51LZUUwW8cT1OIYStTLaPJv
	IBXHj83jCu+tkZ+Wwk305Ruk9V+umVFqW+MlXEgopEWqBlFnW6GZxNPVJsosgivC23w==
X-Received: by 2002:a05:6000:184b:b0:401:c55d:2d20 with SMTP id ffacd0b85a97d-405d26c213dmr1225238f8f.26.1758616624935;
        Tue, 23 Sep 2025 01:37:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEawPPWnpwt5rFwfd2DqihY1bzY492tZVIfX1f84FZQOvJccOmfH7DP+skjktE9t2ycA3257g==
X-Received: by 2002:a05:6000:184b:b0:401:c55d:2d20 with SMTP id ffacd0b85a97d-405d26c213dmr1225200f8f.26.1758616624459;
        Tue, 23 Sep 2025 01:37:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f829e01a15sm11575843f8f.57.2025.09.23.01.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 01:37:03 -0700 (PDT)
Message-ID: <bfede7e3-5295-4453-928f-8e7c0bf8f2cd@redhat.com>
Date: Tue, 23 Sep 2025 10:37:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v6 02/15] mm/huge_memory: add device-private THP support to PMD
 operations
To: Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 dri-devel@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-3-balbirs@nvidia.com>
 <2A0E854D-0B0B-48A8-A87F-E9D38C6823EF@nvidia.com>
 <5b9da42e-49a2-4229-81ce-625ce00ed7b2@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5b9da42e-49a2-4229-81ce-625ce00ed7b2@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iqGy-4ysGbqYoi1f_jIQhnODwXtKQCateV-TspFouc4_1758616625
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 01CC01C0013
X-Stat-Signature: ayx898sw6w7ng39eymiwx88kmdmm4y91
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758616628-600297
X-HE-Meta: U2FsdGVkX18n9c9bOgCH2ZidLgypJVxB2DljZ/kyRfH68fIMNI10Lw4JPMhybGf5TFag7ngA6HFcnj643eClkYrAoHKO9cs+kL6gTO3aXC/1Xn0ICxaX2GA+aCHwNJYv00wxLkXyq0YLoxTbFKVnEV/NxpL4X1SDl0bdFCPVOBymaEePxUvwVCH6IQ/EyScaP2M4Fw6UcWPzXhSyIzt05zGy1t78ZeXcIzhNFVPTkH3OIHlQQECpDaU3sqfmLrv1fMoksa6eitqNSnOTsz9RwMwl0vbcCDLoqmhJqoZS0YZHE41A+a8Lk6S6wDZ8416nrFToJ/l1eaLP+DFeNMsNc5D57hhdxO1YMMWL4tI5DcPizskUPktg7eWedqUEIUN3eKHepElDSTrGDZlMi46Kdqi94oPHGYvET0m0mSWNS+pBOIjyqlSFShLC9P1SMde33em3JcqRkZ0wSf5Sw/nlFDYYjMTvqL+7woIfYAcQfkdLFTN0NlNPxgZ/sM1mXE/9UOArewOYhb0rl4R1oa6+sv+UQ18luvJCJoXsbVpMyefwkor0uYBsBYOwdaOQvN149Sqa9d7r87m2G1wJ3TkkGMQIzzjK30Tk9PImW4VwoT+LkOZ7AsVUrromfvyh6J8FKsGklSaOEtyWKQwMq7v5YJ7uYv4rr1ABBaRi7rYklLqigpOu8TZNZdJTXgWpkfrLUjvKyw1dh+a31j/POAjPd4RI7XZ81FhEpVmvoAivdQo7MxHiL+RjrLrU8UpkD9/TRq1CJ4KIoiduIySFm6nAwnhBcS+24Hi7ox4oagyIRC97ZJdXmuf8mRK718JE/slT7cqUv9gviL1FjPI8lfFqshegJMgGK6PA7RGIymDDk8v4Egn5yyfhyCdR2yObyJ7ZQG8isS9rT2F6Y2HGx4eJt7yho5f1XqJVTfdAqJz3hTbjAkAr1MqNb/BIGom9goUe2gKACr7E6+rtsqex+fa
 rkAXauk/
 6QQU+E2JjLvdR5+Qbpgh/tEwSeaK3MGuL/dYP3NJUYlvK4FIB+Dn1tY0Qlq2OL/T0jFa+Z8CVD/PJkYbOkwXhOkpIJ9WYsP6BrQVzdG4Q6P8SMC8FBBhr0JiBgopmwggFx9WROxhmADgbMnxhJjwIBW5gSPvr7pAhCygC13zFc9bTg5TRono7KDcSGQfyCdEL1t3++TOmCjndFB60PEIK1bv2Cz8afS89h/PoSTA6YB0YlGm6JFT5Lc9Alzbv7m02CRRghhKVzrlSVvs3OMii9Avmz7sNypHn+gESh96fOrE2+OnFjs23F255VnpHvyjVjXe1bIp1FRJHf1SurBUI7/v2VV/nBnvPIXlEOme/vO1Qmg+1+cVWYnBli/yvwCTpape1+fFOvMe3uHhVymm3eOMPC3Czbg6SLrKUcBKWE6w04OGM+a8xmOoE8lJnVAkKz7/ZhZdkaulOJvYSSXXFFzXjkgZxGmbwwhr1nj9y5vp3NXOvLMf6j/nrMDNwDQmRW3rwwSGr+WQ51WLI7Qhdl/m77oz3Tc9uKQd/RSAjPgzUDvGitmjYiO3lx9YF76H7mYLebJmFK3eCyFHJb3JFn/WoESmxBFMHNS8+rH0PS5EwsLo9oSNd3MCv6MuLP5K9vYBgvAPyWxcWVzVTeR6GybLa+CFj0BR9K6S92tWQDdolfak=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> non_present seems too vague. Maybe just open code it.
> 
> This was David's suggestion from the previous posting, there is is_swap_pfn_entry()
> but it's much larger than we would like for our use case.

Right. If we can find a better name, great, but open coding this turned 
out nasty.

-- 
Cheers

David / dhildenb


