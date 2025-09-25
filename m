Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428DFCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2BF8E000A; Thu, 25 Sep 2025 06:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA7A8E0001; Thu, 25 Sep 2025 06:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7998B8E000A; Thu, 25 Sep 2025 06:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69CDF8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:25:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0671E58E3B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:25:43 +0000 (UTC)
X-FDA: 83927391366.28.313986A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 83DFD80008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:25:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Le5YIHfK;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758795940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yn7KtJOI+OoVL/g0bXoboAmrO1BBc45RKDhcTRih648=;
	b=dbI4UuxepUDBfcU3zPK9YtlyiZpIOe8yIESRJQWE7F8+eaO7T35zPYq2gEQLZfeHFZ2Enp
	uOuirIwwSQJ4vn/CD7zrE0QyL3mI+v7pvTXCZfXQMCzcJad3fS906gGUJkR4LXuvI2Pu/T
	aItxOoIZxYJwVU7DIsYzYw2x5gFCkiI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Le5YIHfK;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758795940; a=rsa-sha256;
	cv=none;
	b=Md7xoEACpOqwUn1t/Q6WGoaB41KEA/9S9AFU8Jq97wc1xoJDXExsIinSnM5Hjk7saBtFN2
	G+ymvdjtEvKPNVOx31WsYxzp8RBXP/35DMzfmyy2uHKdmCrU1WjIQpf0tU4c2u20OgOs7F
	D/REdY7IdRnd70qJxvqnY++aYJFV7yc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758795939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yn7KtJOI+OoVL/g0bXoboAmrO1BBc45RKDhcTRih648=;
	b=Le5YIHfKTJ2Vw2xXcZn6js0oFKZTHOVXoiG0yVp4qgUAlzKp4st7V6a2cP1xe7UGElfVX/
	KzJ22DU3talccGGE3uy+H8gRKPPBWjOdw9DDTsgXn41co/Fl+D6lYHHyi5yLyLRt+mTtE2
	s+/FHWMSA9+ORP/YbskoQdoz8Kv4MWU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-xvyAnyNCM4Kj7ST7CL_IgA-1; Thu, 25 Sep 2025 06:25:38 -0400
X-MC-Unique: xvyAnyNCM4Kj7ST7CL_IgA-1
X-Mimecast-MFC-AGG-ID: xvyAnyNCM4Kj7ST7CL_IgA_1758795937
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so701974f8f.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758795937; x=1759400737;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yn7KtJOI+OoVL/g0bXoboAmrO1BBc45RKDhcTRih648=;
        b=D+37GEgAeqZUOWlgi7XfwGwkmoPyn+Dj4MIz1aQccRlM0+/uW6xbAopfxwIaDBE+04
         Jp/OY7A09YX3KvqU861rQrs+gjOIEs6Ut2Qj/CLTvNhdkaSpqC8yOh/qvBpvXLbIOkKh
         tGqISc/73Hs+zMWPcxVYgxXPne904ffqCS1xA8TTrQxd3i/zeMXDsvQLoPG1GOLi4InV
         zr476uMkUdy2XLhu3MU8erNS2tSpHo1Ha0iEfYebeAFwklC8+4jGdhU0+l9KCYOmiIWV
         hQOFpQIS9KGapT+ENGyk2g7nSnLg8XJjdkqWyASPbh3ESWb5F1sXTseMj2PAuVhwm6tf
         QY5w==
X-Forwarded-Encrypted: i=1; AJvYcCXCK2CP76IimtZpyJ2r1PY3RnV7AZPA+FzW0+29Sa1FT1rALBM3dE1sHPfQREg5DPUMCrDOssqfTw==@kvack.org
X-Gm-Message-State: AOJu0YwIdgs/fr/K+xXrJtTXC00wIPkZujzxkCBzYVg3A0a7G3m7NkJa
	Cslrh+60GDiXvf2yGheLaHHZzQLDYEfwc6ZlCs0goYteqaANokN71pkkZ5V/ifTw+GjeK/PKEmq
	ziDNWDrTaG0/Jp4TCISQjQNpPPcZ0JpYYbInLGqpXZJgIRNEPrGnf
X-Gm-Gg: ASbGncscm6Ly9EfsBW772FFydQs8hOjQC8lq2G2pW53BuZD5NEeya2vhP7A0Tz/pG40
	KRRhVrPtjvV5bj81xEqWm6sgEXy4/OUE+pxIhnG6R5VaLYQvw35RG6hf2ztohrKCcRSszMzYqVF
	aCbV97mFPEZpGzNxVq8U/dL2KBgIUq4zUWfz7zBGZE0PGtNbqSRRrNKy+LPFmbhdrN4DyP2lYQh
	eoDd3wOkroEVM0VA7SbNG4X4C1c3/fEGKv/mIzCvtQuLxesirGCe7mifjRdt06L3OYYVMs3S1eV
	Jnyd4iR61vyTudp2iTGoD7VnW8w8nGZyX+LaRaKwQwFI8A1MndGOA9FagyFygwj/V1FQYn3iKap
	2meerTqhCBaqWW0mHvBgA86xrbatiPS1YbuVqQtepdcVOfyCsKZSBqGbwGUrKga9zIjE2
X-Received: by 2002:a05:6000:22c2:b0:3d0:b3cc:c1ff with SMTP id ffacd0b85a97d-40e4b85109emr2653260f8f.39.1758795937457;
        Thu, 25 Sep 2025 03:25:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMY43SbBeTDqux7xNDlX/ZIG3DX+wQZ2EsWj+CndB3u6o8VAseXEawq3c7JdiIGuveFjJLZA==
X-Received: by 2002:a05:6000:22c2:b0:3d0:b3cc:c1ff with SMTP id ffacd0b85a97d-40e4b85109emr2653200f8f.39.1758795936721;
        Thu, 25 Sep 2025 03:25:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e330d1d2fsm14556705e9.3.2025.09.25.03.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 03:25:36 -0700 (PDT)
Message-ID: <c8259ec7-e31d-4771-96f9-e2fb6b573e85@redhat.com>
Date: Thu, 25 Sep 2025 12:25:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/12] mm: introduce AS_NO_DIRECT_MAP
To: Patrick Roy <patrick.roy@campus.lmu.de>
Cc: Patrick Roy <roypat@amazon.co.uk>, pbonzini@redhat.com, corbet@lwn.net,
 maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, willy@infradead.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, song@kernel.org,
 jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, yonghong.song@linux.dev,
 john.fastabend@gmail.com, kpsingh@kernel.org, sdf@fomichev.me,
 haoluo@google.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 jannh@google.com, pfalcato@suse.de, shuah@kernel.org, seanjc@google.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org, xmarcalx@amazon.co.uk,
 kalyazin@amazon.co.uk, jackabt@amazon.co.uk, derekmn@amazon.co.uk,
 tabba@google.com, ackerleytng@google.com
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
 <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: heimoNDYWlRpf_jhjdnuH4kOK2OMHKrrGb0fTtLeOFU_1758795937
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83DFD80008
X-Stat-Signature: 51odd5j5ibi9uuuzdfiphgp736wtfmbk
X-HE-Tag: 1758795940-75380
X-HE-Meta: U2FsdGVkX19EWXNknxsBgjQYe9+1x+ZGUfcU1iymdYdp8NK4AX+GIdVUOIpNlpU1obc5p+K74ctGRb9we9LC519+P5SPsh0pjvGweXDG3xjoqLTlOQjF9p+dSNHT3/hyMOVH1ngaIuolvVF6TA23Rui27deqUbONYpuywf3gBzepdukn3zU0r5bsXpx+up6GJ9L4v/ei3zvE8L89Ie7ckIiRqLtt3CBdbDSb1InW+GB1UQ9BZGgjuqqdKGGBtIIoe+PENnnYMThulgoiHuF7V9F7H/vW6OVHXoQsETO69j/RUlpg2JxdFcldxlrQdSQPdgk0hE48Lp8H+iPDjHiTgTBbwcr/0dhrEN8iMPhsE43MsBlfQk4jqfTg7gCydu37i8rozE3wp4ebE3ecpFBVOUsA+C0qn08q2L6IrSmJ5MDRb2kfiiyP+ef/hReVuZjxyHppp91dyDdHEiFvqkU2n4uR34XRxfGAV5/yPaR4ryjOdQR29Nw66CmyJcxkgRzin3VElvV6S/mEDjjC/vPVcaWOou93h/NPHEpBMXPRL1NJbi55egMDCbMtrU1dHfO1LcMJ/koUf7QrdH5FoXlLcYjcUtjkjneFxeaV7XmUMtQ4JXnTHdDSdy+yVS8U/HlSWIc21MFOLE8YJwtehtBbNY4v3qc5/CptQAhJD/GvhDURk8gSK24fZzUPZU2QSbqR2WdEci6Frz2rr61Kl8aiLIx42yhG7qcKyc+QDDR8K/N+SMyR0EMnjEYsVcNV4n16hiQYGz91ldfcamHqAS1pSDXV59/YpCMsD5opQ6XQnorK9XlyFkpp0xjKX5Kn5AKXZvyj+IssQS9ykO2rXpfAU3vXrNnRYbvVTP9iJ+DHJxl23QM/YwP8exLEot8l6QpQDkPM8jO4BCu6OTYglyi1KFXywzlRQKodY81GRrZGad6srIwX92+8CkcqXOzw8EKju0VcQj9saAHU1zrswPp
 yT/i/LJL
 HkV5yhN/tnub6qip2hQxgXeHNq8EmL69vsQlyHoGOiBLVUL12rTGGuhICn4/hXs2wKgOLCZVQUlNhahohQnWhYTAOOoOqARnWUYHbEe+MJV7iwhUIoJ1AU81T5Od+x6pkpgr6ks5b0RduJp0PYAQsncDfAuqiJ+UK9PTvdsLbvWr/irJv7TmQ+v8DzgOQHFIrvBLKgF2PLvrIcvWnEiEpOfR+v73IzkdhPK0Joz84ebugYQ88qtr2OkD3EbLOn3EIT94LG6Hyz4F/Clo2KArr6fRo3lQonlEFbXKcyArFABFK2+28hLx42ZSc5U8LrqGfOQikUKi/mVEyoyV10LC8O3X8tZSTL9mA+eMLPsmo3mKoYTML5vMRDwfe1Co3rJbHSstJY+iPRuQfU231Ei+HyAGYf90pd+F8jtWfG/1rK/CqpXIEL25dwOkDY2BxKt0DjCVRUs0R0mIvKPuHNlFamUbcssT8tVdWwOxkNNkZWMSv/F2kij+r7zlerPDRKSyReWZsBy4pH3nVhKBo8u5FN+Zr9k3BpIhqNbyhee9m9EOUivl7qqmtvMvfI5jq4qu0xgQ+xC7St6hGsVM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 17:10, Patrick Roy wrote:
> From: Patrick Roy <roypat@amazon.co.uk>
> 
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present . Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
> 
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
> 
> This drops a optimization in gup_fast_folio_allowed() where
> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
> by default"), so the secretmem check did not actually end up elided in
> most cases anymore anyway.
> 
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---

I enjoy seeing secretmem special-casing in common code go away.

[...]

>   
>   	/*
> @@ -2763,18 +2761,10 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>   		reject_file_backed = true;
>   
>   	/* We hold a folio reference, so we can safely access folio fields. */
> -
> -	/* secretmem folios are always order-0 folios. */
> -	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
> -		check_secretmem = true;
> -
> -	if (!reject_file_backed && !check_secretmem)
> -		return true;
> -

Losing that optimization is not too bad I guess.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


