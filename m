Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F08CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729BE6B0579; Sat, 16 Aug 2025 03:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA7C6B057C; Sat, 16 Aug 2025 03:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D666B0573; Sat, 16 Aug 2025 03:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41AD46B0570
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:28:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08CDCC03B6
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:28:34 +0000 (UTC)
X-FDA: 83781792948.28.60505BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0B33B40004
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:28:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UMPMK9sZ;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755329311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhPBBF+Lw3fN55KB6kEc1nX5uVTLUAuKYqprPicOOvE=;
	b=t9Qv1tTAhoJL62NjHx2CSaUZTNeK69T1bMHDauLHhs0hnC4YJEZLwix3uSS1xCw2acDv1a
	D6Au4eaH/yOyHxDeLAy0Z+fHESFU/3kt0AaHwma2osqW18rYyjqw9qcgjc2GYM8e/2TvhS
	lpZ7YkH9rHx8Q43xZHTyG5xQ3HBmT5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755329311; a=rsa-sha256;
	cv=none;
	b=e/DmmheU3I6yPr1U2Jnnzvhg/V0VdAsmG/6uC2CGHYvwO0+qvcx9DK4FaurkItDxtJElko
	C03Ps2n/xQSz/fQM6dIHXUU/v71pXaU7Idb4V3XruWVWwPRrMxwT+jkBomKlQyv+Lf1x19
	UG16CULJawufWlCWTJIF1OvoSYHIgNs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UMPMK9sZ;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755329309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YhPBBF+Lw3fN55KB6kEc1nX5uVTLUAuKYqprPicOOvE=;
	b=UMPMK9sZDWjeYcCAmLw18r6WwhkRfIXp7vCTy+tx6lEwHM/z5kMyDxzU0OfgQQYgjHWp5v
	f0zp4GuRdIjCc4I/yuAYyaz9EyjIXElVTDytBiYExJ1xGLfFfTf3O6BSjqbOJ3/o+QmjmV
	EhhxL8kYv7s/VHu9DYipBzqtlVZJLo4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-_u31bjT0Nyy-o-H5Ea9tEg-1; Sat, 16 Aug 2025 03:28:28 -0400
X-MC-Unique: _u31bjT0Nyy-o-H5Ea9tEg-1
X-Mimecast-MFC-AGG-ID: _u31bjT0Nyy-o-H5Ea9tEg_1755329305
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so17035105e9.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:28:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755329305; x=1755934105;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YhPBBF+Lw3fN55KB6kEc1nX5uVTLUAuKYqprPicOOvE=;
        b=FgFR79VX7uGWTQVSnVoE8z2uytkBFdbWHjCaTnla9E5/cSnY+HupEG5Xheanu7N/dj
         oTKYUD+Pi4h63E1D5AVG9eo/Lw1Kk4HaoAsILlXtEFdIkkMG1AWicvBnyBv+DNHRvyO0
         Jp9Z1TmnE5NkFhMo4y1VxkVS+SBz4AipdGC3vsancSjrsbbicdbkK7KC5H5oO9Wg/DTF
         q5jAZQepKEcLs6IH05mXT9k5cyYlqfTiSZe/bz9rIAE/trkmJV2p0i6BgkumVi4ONFc3
         xyFTg2NRn6QXGKOHLCD4UTQcqhHEeJ1QNg6GMSu+wkqncMsX5mE1C52cH5PJq5aZlnu1
         KrUw==
X-Gm-Message-State: AOJu0YwZPgx3ns0wKnXuK2k2n5supoLFS7S2msR2Q01Ayp1J6KXpXO/2
	sYT8acMjVPIfhMzC7DwzjpJErmpUkISQVlpgOnUyo/U9/qe/4HEwg0FlQHO9WxmVxnVtdnDtU2j
	uT/VMPWdiJ7GMJ3ky0SE2qW1rP3eISEBRMVbzCxAalNc2a22ZPBO7
X-Gm-Gg: ASbGncsVuIK2CiG7LvICQ2L+5U+046z2EZyUffG5f03p9gRhL2Jr0tveSe+bO/KNoCh
	jAcVaVAFioLrRyS8r/OsyTt99P79+LAM4oCv41UEpVgR2zZqETowFSijpf9FDb8k7x0/FAqiFjC
	a29HykEZfCDgntHYbWOQlxs6XjNq6i+PsPodwfrfzjgeO17mB+1gj304lIMj58r/TuLPdfL8YCB
	zAO9+6ZSo2p1aKHKNsdNdEGJYeBTFwyctRKqy27I8R17SBbNAzh5xzPpxNXh0wsZ85AsJNX9Tln
	Rhqr4ARI4rrmNVZpgRQE88145DE8O9yPNuBI+DUlH0Q1YJUjqDG1bSxJVroZkjAEuQcnEZ9HVJE
	xX4rBitSG6mlBg3iP0DxHfMS8i8zu/2AfV/bGvuXRPpGNeYL0RDCO3lllEQznYRK6qOI=
X-Received: by 2002:a05:6000:2004:b0:3b7:9d87:9808 with SMTP id ffacd0b85a97d-3ba508ec549mr7047292f8f.15.1755329305454;
        Sat, 16 Aug 2025 00:28:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfT/JVGrQ0wyU/tULsCTxXAJ+wzvrVInddAWjSvaAhkc628zpO4SSRGf/+hfZY/W0REnvctA==
X-Received: by 2002:a05:6000:2004:b0:3b7:9d87:9808 with SMTP id ffacd0b85a97d-3ba508ec549mr7047274f8f.15.1755329305028;
        Sat, 16 Aug 2025 00:28:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb6475857dsm4748985f8f.2.2025.08.16.00.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 00:28:24 -0700 (PDT)
Message-ID: <c324c1fe-7a64-4da1-9641-fb1b9756ba2f@redhat.com>
Date: Sat, 16 Aug 2025 09:28:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: Huacai Chen <chenhuacai@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org
References: <20250816072149.1952348-1-chenhuacai@loongson.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250816072149.1952348-1-chenhuacai@loongson.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sdOe9rxqd0eQ0V1dpLysMjNhQvZn8lXpjFEokXo-tC0_1755329305
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B33B40004
X-Stat-Signature: 6qb7f7gg69ekqi6sohtycmfcdkqcxs1e
X-HE-Tag: 1755329310-244612
X-HE-Meta: U2FsdGVkX1/pWfkn3gt9Znj6gutCRPi4Px2ykMaB4h1XDTPAjv8l1hBuIQm9v2FFQAvqECyxOn5NTPT6ZFwcnxlNBuRUUiR1eQzOBtyLDQCBrtdo+fE4vJmxh+hLqWliQ/lWLxXv+SodEaie+++xWk9Ciu/8ULkpYvMviq+VFKgJw2pLAXkOsQPZ48T3I0BCjfV7eFv+oGAQnpKeRSBvKAhuyIoGVFdEPYtriMMzrxS3G/ELSXjgkwhYJaSq/1eEVC2uPMl+gjdj3Xm//8n9Du51ZIdX5ftFAdVDCUFwz4vZv0NAMS//8sZOKAJGhpqug5H384G+ajUSBlshRNeZu2V+cXMuNwBWzEktuRb3xSEtCaZa48EooN65CLvrlXshR9lZLbEVAU/V3PtLFUWwwDo5hwNVb5YTXBdchzXWixvo1j8jXdaFyQsplukC9Yuw6p4D7wJj+K3PhKI9i5A763SmD55pjgrEbkRO1YSZSNDwUIWCEse/zsh1BZtjdsvoNSoNCosIwhf0KDIkltLc+KcUw8Y8oebtROcZS/+CZEbYhg89McAEqWTFjojq5Eu6ZI1F4zAldKkDMfOwm70prVy6pp9x7Oej59MF6BqwfdxtBxRIrtmznyEKoOnZH0kLFfIPOH7srZ3oQfrt10gjWBAhnPiGFgW/Ys2W5Mk2UOXelQKuRnDLnbO4x67e9WnhlRHMOIR9BwVPbpBLN1FDWS/t1SKcHyyp2rrYWL0Lt4LjLYAQavL2V/zln139F7mGPf6q+7JWMwFEjgvWI9784KVh6Pl7duiqE944+UprfO5gSIuBtQYNfAP/oUWBq7OR+EIcTmedQPANB9+cV8lT5PxCZJtEX3boSJplZrg/OgxRskRCz91BZFupSFYwwe/ZrtPK+d/iNOTxhE9tsN/hkT6KrrzhbEIS0oVpTSbz5oHa4UG31gkAekuvChEsSF85ncBMPEnd2jPbpDYk4xQ
 twC93I8Z
 c760hG+GLk+z8uEm/co9EmCggLRpSpt3Tr4oZ1iv4Ipr3c2jif5yBmTmk9NG+4EgHqADWMAlzivslQ8p3DUQR4HaYBFoSHp+v89YPDNUF8aQFht9C3PtJNFyOJa8AxRg9l5eZ0O9S4bRsEl/GuzeQyb9sW996Hfo8XZAhJtwJGRGpncVXcFQ+ZXjUB/41jsblbHhPnP1GvU0s79c1Cw5WSzW9VFf/GImWOVHGWCBoaloDigNYLx2T1xACUoINWorSGxyluDXGtgFpUjTDgzh2YIuJXTjT7Xgp6ndTVDvh+2ogBovvc1UytwOj75giDjVTjYE+BX8qGVQLPaZwdKYVetBaAov3Nzm5CwegR2ZVUhyb3LgV2JrZfLNha+QPCJ3B1yn4ZJT1pHDXBN4jZHT+weTgpPPgVPiD/sTB1I8zKskrQJ9lyHrRyCkd057K90OAPyntmFWgmrQ00TC9b428Ojz55YrUXqMNJ2oNr1LR5En5wp2M8z4w9ekfc2RAC3H4Mj6xDiP4iCQNrBrs+qBnpXbL7iavhB1UrP1viYOXSAf8PBFFMKANfb3rmtsek9PDAiQBJCuYSohbr1Txa0BfU6wxRYqLmkB7b6f2l+WXM/f39TYSzXP87cfsxLPGWyjRI0+fKBoaowLL6SwS5w5kE6gToA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 09:21, Huacai Chen wrote:
> After commit 84caf98838a3e5f4bdb34 ("mm: stop storing migration_ops in
> page->mapping") we get such an error message if CONFIG_ZSMALLOC=m:
> 
>   WARNING: CPU: 3 PID: 42 at mm/migrate.c:142 isolate_movable_ops_page+0xa8/0x1c0
>   CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
>   pc 9000000000540bd8 ra 9000000000540b84 tp 9000000100420000 sp 9000000100423a60
>   a0 9000000100193a80 a1 000000000000000c a2 000000000000001b a3 ffffffffffffffff
>   a4 ffffffffffffffff a5 0000000000000267 a6 0000000000000000 a7 9000000100423ae0
>   t0 00000000000000f1 t1 00000000000000f6 t2 0000000000000000 t3 0000000000000001
>   t4 ffffff00010eb834 t5 0000000000000040 t6 900000010c89d380 t7 90000000023fcc70
>   t8 0000000000000018 u0 0000000000000000 s9 ffffff00010eb800 s0 ffffff00010eb800
>   s1 000000000000000c s2 0000000000043ae0 s3 0000800000000000 s4 900000000219cc40
>   s5 0000000000000000 s6 ffffff00010eb800 s7 0000000000000001 s8 90000000025b4000
>      ra: 9000000000540b84 isolate_movable_ops_page+0x54/0x1c0
>     ERA: 9000000000540bd8 isolate_movable_ops_page+0xa8/0x1c0
>    CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
>    PRMD: 00000004 (PPLV0 +PIE -PWE)
>    EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
>    ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
>   ESTAT: 000c0000 [BRK] (IS= ECode=12 EsubCode=0)
>    PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
>   CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
>   Stack : 90000000021fd000 0000000000000000 9000000000247720 9000000100420000
>           90000001004236a0 90000001004236a8 0000000000000000 90000001004237e8
>           90000001004237e0 90000001004237e0 9000000100423550 0000000000000001
>           0000000000000001 90000001004236a8 725a84864a19e2d9 90000000023fcc58
>           9000000100420000 90000000024c6848 9000000002416848 0000000000000001
>           0000000000000000 000000000000000a 0000000007fe0000 ffffff00010eb800
>           0000000000000000 90000000021fd000 0000000000000000 900000000205cf30
>           000000000000008e 0000000000000009 ffffff00010eb800 0000000000000001
>           90000000025b4000 0000000000000000 900000000024773c 00007ffff103d748
>           00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
>           ...
>   Call Trace:
>   [<900000000024773c>] show_stack+0x5c/0x190
>   [<90000000002415e0>] dump_stack_lvl+0x70/0x9c
>   [<90000000004abe6c>] isolate_migratepages_block+0x3bc/0x16e0
>   [<90000000004af408>] compact_zone+0x558/0x1000
>   [<90000000004b0068>] compact_node+0xa8/0x1e0
>   [<90000000004b0aa4>] kcompactd+0x394/0x410
>   [<90000000002b3c98>] kthread+0x128/0x140
>   [<9000000001779148>] ret_from_kernel_thread+0x28/0xc0
>   [<9000000000245528>] ret_from_kernel_thread_asm+0x10/0x88
> 
> The reason is that defined(CONFIG_ZSMALLOC) evaluates to 1 only when
> CONFIG_ZSMALLOC=y, we should use IS_ENABLED(CONFIG_ZSMALLOC) instead.
> But when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot
> access zsmalloc_mops because zsmalloc_mops is in a module.
> 
> To solve this problem, we define a movable_ops[] array in mm/migrate.c,
> initialise its elements at mm/balloon_compaction.c & mm/zsmalloc.c, and
> let the page_movable_ops() function return elements from movable_ops[].
> 
> Fixes: 84caf98838a3e5f ("mm: stop storing migration_ops in page->mapping")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> V2: Use EXPORT_SYMBOL_GPL_FOR_MODULES instead of EXPORT_SYMBOL and fix build.

See my review.

Please wait longer for a resend, so we don't have to do this weird 
review dance.

-- 
Cheers

David / dhildenb


