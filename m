Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C98DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CDA48E0021; Tue, 21 Oct 2025 05:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4908E0002; Tue, 21 Oct 2025 05:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893628E0021; Tue, 21 Oct 2025 05:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 785A88E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:47:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2786113AB42
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:47:20 +0000 (UTC)
X-FDA: 84021643440.12.A5E01C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8BB1F14000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:47:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UAW6AfI/";
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761040037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdxB4ObaxXDe3ntYne3br3T1Zilh+yVID4oP5ghyroc=;
	b=qKg5VsLX9fi2OS4u2mR1QO8QfvahfMBYy5QXJTnmK3W0qVejgCxUTNcwwF8BghbZi5PKeg
	yG0c1OjxeQNMpMMCxLGHTB2D3S2RFz/SwKnjXYKMzGCcnXAvVjAXblhs/xg6QBwC3XxrXo
	PhbjmFc9Idrm77raAlND/p+i014pvz0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UAW6AfI/";
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761040037; a=rsa-sha256;
	cv=none;
	b=5Xjwfly8DVhtYomfYPOexD1rGA+fmfEj8dVs95UpBHpbghXevcJPOmQ1T17O9ak+jhCG/w
	4Ad433cQEoP45czpwNCHATvpImq0/Qb5xFkZ6XaG0icaPPzzbpkn422XGH3NjBhZKgKuos
	qJ1dKbDuur3bQ/uD1k4XuTaQpabUrSQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761040036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kdxB4ObaxXDe3ntYne3br3T1Zilh+yVID4oP5ghyroc=;
	b=UAW6AfI/+/N7PAy6jMb4NJGwvkyGttqXNwLp+QS7xa788sdVFCrLoY617MLDqPAWdUzave
	8IUG5Z4pAUNhlVq9g+De9XNSIOiYLpp6BElGYM/pBlYrh+/EcuXbCN7dLEo00GGtaErry5
	m8C0h/+eHIGMD4ixjy4Q5XVNaWHwJ70=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-tTlp_wHmPzqtduBIx5znHw-1; Tue, 21 Oct 2025 05:47:15 -0400
X-MC-Unique: tTlp_wHmPzqtduBIx5znHw-1
X-Mimecast-MFC-AGG-ID: tTlp_wHmPzqtduBIx5znHw_1761040034
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-470fd92ad57so109892905e9.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761040034; x=1761644834;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kdxB4ObaxXDe3ntYne3br3T1Zilh+yVID4oP5ghyroc=;
        b=X0YUV0iqDrt7zy50g/9ABMo7l9YVo1aC7A9VGnulzauV9D6x0ZXIlNOE4A5vmMX9cC
         0VaBnX24fRlOTObn6IkFgwQ3B7Gwc45gJ733MuukD2xjuzkAaJulB1MtD8aEhB6y927T
         RppKs20N8OG05WQgJAvVT0s2ZuX8Do/Bq8WcWkyl9ecwQyTWahk+VlF8Bz8k23aeVgrC
         Kk9MFngL6UAcK+bf8t/CP41wuSGWE+pTBeLUg9UvvmL/qNegT/w9fKjYYzp9BiG7jLcr
         yavySFTbcoVG6IGgA/oGhXMQzMsVhakS1n5L60M+UMs+Om3JQHKRhTccpcGkfqdktVtt
         ICxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIhWqiewf8KDsD1zh2V91lIrheFFhlM+viYnpgICgkRquThI/gsPWVN75K2B3+LmHYpym+XTwC+Q==@kvack.org
X-Gm-Message-State: AOJu0YxE8X2EKk0aZu7Oae6sC3tN/AdrQHTsvqFRMX053mGvgDLG3xJL
	C/phtmJmQzdximV27HBTJx1P5qZJ0rA6foTO4YO26KCyLTarqHJfioX3dIHvDbNHjfk1dMESnMr
	hOWdXX/zf7noELRLpKbBdWAPRJA8f2ux2yQClllIgF9qjAjZ4oS2m
X-Gm-Gg: ASbGncsa0yMxHyft1clH5HqlvIGbzcJSUgUsqr7MvomPEOOmSWytKbel/L/RqLhWWp2
	EURrmqSH08crYPgn2MRsaoOMP2IDvofplVX9SDZZ8KRfT5HRdE6goI47C4PV+HtXftWVehcl6Y3
	drK/efQAn0H5RKASTF9PczbrWje+HnPbebYFOWLs/O/Y7jtoi0iHGP9qjrQnqAQItR/NMRRBGqJ
	Ayd7xLSx0GMgkDiUwTyJNFIRIKkmNWaAzlADfmifrgtn6HBDYE8HZHy4MScmQCMTjbnO78ltEkv
	ik9sOkGfBUYkcE58rHZC7mYv6Qa5FqEXcDy8rqbcVVZ52QuivaygZrPD/iq80f5Xo9Byk7ZBe1r
	qnHF5ttHAOfgGlCTTAJAdsCyWWXACxTjjIWdc91a1Cs3ccheH1njuO+4lWvfPp1/ZCHEZIjiASK
	ExT/ZATJF3gCK+wgUOhbNVD8+2mYQ=
X-Received: by 2002:a05:600c:354a:b0:46e:59bd:f7d3 with SMTP id 5b1f17b1804b1-47117903f24mr109166435e9.20.1761040034393;
        Tue, 21 Oct 2025 02:47:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQrCWI5MRc3hct8M6FiDVhKuOrq9aVGTkJL4l+BBrXUp5JiUTebsACgmFnwi5Fpp4jK76vLw==
X-Received: by 2002:a05:600c:354a:b0:46e:59bd:f7d3 with SMTP id 5b1f17b1804b1-47117903f24mr109166135e9.20.1761040033964;
        Tue, 21 Oct 2025 02:47:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496c2c9dasm13207305e9.4.2025.10.21.02.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 02:47:13 -0700 (PDT)
Message-ID: <37ceab54-c4b2-449e-aa46-ffaefe525737@redhat.com>
Date: Tue, 21 Oct 2025 11:47:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/truncate: Unmap large folio on split failure
From: David Hildenbrand <david@redhat.com>
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20251021063509.1101728-1-kirill@shutemov.name>
 <20251021063509.1101728-2-kirill@shutemov.name>
 <a013f044-1dc6-4c2c-9d9a-99f223157c69@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <a013f044-1dc6-4c2c-9d9a-99f223157c69@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sWHDZNlOSyedfw1UUFbtBdI66u9nTPJn3nuB-W_no64_1761040034
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BB1F14000B
X-Stat-Signature: nd19am7rbj3ka61dfqzo36mxqgknk78y
X-Rspam-User: 
X-HE-Tag: 1761040037-181006
X-HE-Meta: U2FsdGVkX1+D1AAUZQSce56AvDAwqeFv/LWIGu8aX4a0AHFIaTlZVUDVUfdFMtBbwzozYWOeQxC4KpnYjjRXulLrvHRbxSp/ZiLbds0eP8zNPyDpb9XiRViZCxH/C5mzr3QuD10eACdWBhwQnHA52Hn1jfJy0H2VIT1dKe3f7FIBlPeT2gWm8KisGvKM5ZOqy6A6nTQ5yh1nCXAjO4b1eUFq+ijAF0zVvICOB6g6VEAIJc+jFFPBE6fHLGLvg6pBChB2jpch6u84Za+wpvn6TW1LyiMK0b2FRGaJNuLyapxVBeC7mWXgQu9SjMCQYyEAwOutozEYlxKbz+11oSXi4Qu1xER4zdqAnXct1kii9rix+ENoDcpwW8l6Dt4NDstnHVbAf4SUg2Mhv4LAQq9SkNptZ67BsYJt68J2BT+MVwOwTjTOnoF0ojm/yd9h2druGli7y/rMuigFGweW6WSoRBWjCKfsp1DUz59aHr/eQME7oiE43Kb1/8jK/inWa550xNi+TddsaL0TDCsybkIIQdanVnRm89Frk1Y/sUyrXqeE3omuaItal3Et/GZLvlM/tbk0vZWGkRXtFJ2oo+411pUtm39K3O3iFkCnaUyzFZEj2y59qXcRMK/unKDYbePXEGOEL1a4YCsfojvlCFL6JZBXqbF/mbn3NFuXj+YtAUIm3kd5BPFYGxEi0L26WQH3Zmjr/mjGH04vDP0DnXOrYBSUSNc6Mzw+XuJ24VJwZEPN0r3WN7d2peyeH3DL8I2eEuqD4Scnu3RniAnecmf2cXoLEUxV7YAvokU9WRvCvsAoOVpcO/UvHd6kxwZEcsasykf0LVxbryisD2rAFQL/jogFZv3gOOdCJdtyUxS3Ca5CswamoqQYtYkfgvokifIsHOP4vFcmkz251zdid7gS5UbiCdg30o40iRduqivSXP81fxyBp+0993Xbj3/gWOxPXVwQ+nqpW0sy8paOhPQ
 QmxbierJ
 uT6FG1nO3naqT/hJyPkmAKoSb7Uz33iuYjlECjANMyLDtEPXnuonhrQVTSCvvKmGm815LCW70Yattv9DOA0ocbaEwTtPCtwBmw8e8YQvxBoJjhWA5Saxz7dKE9ubwDju/ens+CpMnuKfxmeyIy/ztRn4quk/aO0LaO+O/6rO/rYin2MMdD6Yubulh8fq5CTqolD48bqxexmDs+EedpAf2B4wJgdui5na61yLXGAE7nsJxRupISf5QPB2J/y1Ia9lzz1wneNs+dao+MVySUTokPmGw4LuCn5sC5JtaJ/uqIg2oiKIbueRtZr0ORvGh7ZODqhzhVn1OcCnkieF4SudG6t5IunTX7jPsuAT4Arz+e3BrnCJYLmzypji8KtzzfXEzMOP/F/UQC23CSNb0WCvqj/HP8ySAnQv2+Kyxe4CUbtnu2XQMbTi1p7PB6cIGQuc4vsaC/ZfLTqU9SKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 11:44, David Hildenbrand wrote:
> On 21.10.25 08:35, Kiryl Shutsemau wrote:
>> From: Kiryl Shutsemau <kas@kernel.org>
>>
>> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
>> supposed to generate SIGBUS.
>>
>> This behavior might not be respected on truncation.
>>
>> During truncation, the kernel splits a large folio in order to reclaim
>> memory. As a side effect, it unmaps the folio and destroys PMD mappings
>> of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
>> are preserved.
>>
>> However, if the split fails, PMD mappings are preserved and the user
>> will not receive SIGBUS on any accesses within the PMD.
>>
>> Unmap the folio on split failure. It will lead to refault as PTEs and
>> preserve SIGBUS semantics.
> 
> Was the discussion on the old patch set already done? I can spot that
> you send this series 20min after asking Christoph

^ Dave

Also, please send a proper patch series including cover letter that 
describes the changes since the last RFC.

-- 
Cheers

David / dhildenb


