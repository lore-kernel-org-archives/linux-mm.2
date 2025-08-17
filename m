Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774F2CA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 17:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05D18E0042; Sun, 17 Aug 2025 13:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6678E0035; Sun, 17 Aug 2025 13:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DE48E0042; Sun, 17 Aug 2025 13:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF2018E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 13:35:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42EDB138C29
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 17:35:01 +0000 (UTC)
X-FDA: 83786950002.04.59FA8DC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0105D1C0002
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 17:34:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HNgfIcsG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755452099; a=rsa-sha256;
	cv=none;
	b=oTFHOXhtut03/l053TmRCkFhl77+4GQD3VXYFzey8Ne66EQVU3i8sBnpJF8QrnWEe6jZ84
	269+48pzJQOiuQux/0PN+vdMI5oZbxvBqtJbBmJEXNRCArh6K4kYH7cjSY5tSZWESj5ZsM
	7OvT482OYfq+63wutMu0W78wCNms6+E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HNgfIcsG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755452099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QArQznwqkL7/U2m7o6ccA5eQVjfRBrnYkN5ken8DFYI=;
	b=jQrQxQddKLgs0lDEoUz6DPwEYe+PJ98D588VbIm+kXEOYeC4r5NcI0GVUsLNQhsVpHRfMo
	VpE8GO3BJMfCAwoMTA4piD7y8gO/cOy0MPPYZxU5zO5UJdMlhR2YT1TxfCONWEI7hptrtn
	dSGTNSjM54wbtdyUTqEqx7cmTdPlNYg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755452098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QArQznwqkL7/U2m7o6ccA5eQVjfRBrnYkN5ken8DFYI=;
	b=HNgfIcsGyt3/NFDNdutNgZXGKGyCSMQWM8AB9pNTQwab0XaZYHG27gjrQoIB+HtckXJGzG
	jGRM/RoCV2tYjvvb5v9EaD7iFGM36/JOwhYDMrzMH3DmijPzMax7rZrLmR8Ri2wGRVY2qb
	wwpJ5G9C0ysoBus0/B6ADcRLDM16Ui0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-FgI7HW6QPbKqA65KGIKWmg-1; Sun, 17 Aug 2025 13:34:56 -0400
X-MC-Unique: FgI7HW6QPbKqA65KGIKWmg-1
X-Mimecast-MFC-AGG-ID: FgI7HW6QPbKqA65KGIKWmg_1755452096
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9e4166a7bso1698175f8f.2
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 10:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755452096; x=1756056896;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QArQznwqkL7/U2m7o6ccA5eQVjfRBrnYkN5ken8DFYI=;
        b=q9spwC9k+immG3h0fYEnJ79KE9xOuyl6RDNQbCVbklm3sLZ49grsQc0ozrEiyOACN7
         uhJzEkaBblmlmDvrPgwAvp/gZOkVz4sDbz+mAvlvI/9SRnPw/k8pSo26o9IvMIAKAbyh
         fD0sVD3sSg83bGQ11W82y2C2q7G/jOePbKQta4Wtqg7FKKVuHdmoNR29B4iMuAnsE3Yi
         PSWwbpHaviu9IuIkejnaJpM1NW7k/zIg06UnLd4AUZE/QObLYEhBaXGttubSYm/AxIVW
         b+CNlVEXzSpSEogW+BsXsM5UmThe+dVy00Uv0X99FhQgDsZS/YhBO2tFQXxa13nVAy7T
         X+LA==
X-Gm-Message-State: AOJu0Yx+uHngsjqxzKAZdBIS009qnO36sHMfZmJjI7XBWUCg9YfaG9qe
	C+b8TZTWnv/ztfP0HDkK5p86hpGxBa4tLeM89Ca/gGBm9d45LPmJ54vXbg1/AmNM0QR4mV3o1E0
	HFwfTZMUqJDLQK7K6m1J823vO76GZApQz0P8+Z7mDK65IBwJM8WRU
X-Gm-Gg: ASbGncvyCrs1ezc2NjC3AEqvuIZUe6q7DH//QnPsZZlufGyKLOpf97dhE9Pt0gl5A7M
	EYby2o8XG+QPV9aeAM9gPkM33GL/j8brKSGC9cUJNIot9W7WbhoBp/nZulbU/It4HX2ibp8ea2U
	cXFLijhgd/G62oxFnDv2JFT8pczXrvcHo2pBNN6rUoG5gV2ozAKmCbxVUW5Nty+LIBA5bgNwj0i
	KAx0xEmcTueqh7GiPwDFCQQ8O0u/RXMHdLRBltmrg6OINxE7OXC+dptLGSbBB2cLRBD9Dt4nWJ8
	T/CU2GCd3hM6WqcCIeirfWLNvE8OG+6B9VL16dG0TNI6VysTuGfx3y5CEpqne2HmvwfCXWNbK8T
	8QKy0WxtfueFXzdD8tqfV62DKrfteShdFv1zqtU5AZxI0M1HyU7skA7Np4GFYgi4DH8Y=
X-Received: by 2002:a05:6000:4009:b0:3b8:ffd2:22ca with SMTP id ffacd0b85a97d-3bb68ee712cmr6518857f8f.40.1755452095649;
        Sun, 17 Aug 2025 10:34:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETGYW5NPXtpi8+O85uXCdY38+LRC4p9pbYMPyAkJw62EI1OsnIbkbAZjQENeuOlWOERnSuHg==
X-Received: by 2002:a05:6000:4009:b0:3b8:ffd2:22ca with SMTP id ffacd0b85a97d-3bb68ee712cmr6518832f8f.40.1755452095139;
        Sun, 17 Aug 2025 10:34:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0b:a400:87b2:80d2:3e99:1b85? (p200300d82f0ba40087b280d23e991b85.dip0.t-ipconnect.de. [2003:d8:2f0b:a400:87b2:80d2:3e99:1b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a221bbadfsm98679335e9.0.2025.08.17.10.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Aug 2025 10:34:54 -0700 (PDT)
Message-ID: <7a10a5bf-95d9-463c-bbea-50f96920ee73@redhat.com>
Date: Sun, 17 Aug 2025 19:34:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: Huacai Chen <chenhuacai@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Michael S . Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
References: <20250817151759.2525174-1-chenhuacai@loongson.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250817151759.2525174-1-chenhuacai@loongson.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OVc0rPqVYPVc6g5tKrI0XWahtitUJDaYyl7wZ_khFCk_1755452096
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0105D1C0002
X-Stat-Signature: p9q1ztdu5kfc4i6hei9s9hwrkjeqmhaz
X-HE-Tag: 1755452098-402764
X-HE-Meta: U2FsdGVkX1/yjHD7/39WBU1h4V542dm5JEx+txG0m3KqKf/CiSvBqFpNG1qPk+ERrtMjiUQ0Opv1b2yjpKqsQw0qn8CidUVjLX+K2z/C8JdTRlBRqJBFo8bTWZJStO/n/Y4YquxqE8U1Dya3WZP+msFsLKhHQgRI62vOENoTHFcey7NXzUhtDqDWDEKjabJSChciju0ITRpGCEFhQg193ngwuZ1CodlbRndrSn5B85rB1xm49n6nr0DdV1LBXEIvOCHZGb1Ovnkl3cjFaDzi6Pm5FrXNMUnZFqFuoahKAIWIr7d0KxH9HvOkr3ISw1vmJT60aRDMVsRuW/Eezsj0gDYTKhZwWyu4Rz1apFDGKmMnb4kRZk2dTXqJRBryfyUMIuev+Y+e/7GieJUqszeQqb/uoDkkJjBCJS2eotEaM9Mca5wpONy8X4GbuORUZe2aW0FZLB75qtGWfxsj0UFmKhjVblMxmN98PBdLachtLmb9nv9VaPGvMn6of7hxIX4eQJippq7S3flDtdeX0b35NRBEJLcH5mfjmovg1e7OoA3MwvswrVchl2ytM4swoallc7xciH1Oz7u0VqEiE9v2IGXrzTe/Bc0XkvBkXY4LA5ojy/wbFnxgA/YB2P6mH4f/Zz5v9qoNjKA+tYmlSTt0pxnpMfLMQ0t1cJhaUXOp1DhRgoY7bNLRrihBimrFDxUqimTnrMryoDoqlLBhKzipRSh8wIsJy1QnMx4MIW9bfn8u7S1dS3Ppezo/bTIuxzSVhkroxwwBQEwULrsr8pZ/F/7T+6nDU1nXSJweOuErqLzRmC4L0mFr6q7cnI1DtUBn5oTdtwlFzweMrOWPS9FXbgQ5WJUlW5KtKIDAmFN4aVacKYzlWfPPa5oinuSoe6de+DR1HFZ873jCu2609d6vuitdpjJBXNSCk7E9g2QkBZ4Qen6Qlbh1LHFda1ElX+rKw2sFDAUz36V53WTKPIB
 fmmosreW
 v7aMMf2uIkKDG7r5XIbTkiRwOZETOshNBv6lSjtNqohcD6mnuDHPnAARVQl0vZyK/YXGuPi1gob1wFXtVcG69GX1oRxOjuRIJGzLxAYJPtl2cV19xInYDuRQrxqNpMXFCnLGKBqocebX74HZU61sY7a94QIHbWs6yHBteNm3kwAqOiRbtH7WxjuC6Skp+AigeVH6QyE70buskv5VWO0LsyPF9gM9s1sTh7lXcW+5TfjFD57TUzmNJWrlKDS9yyEqfmYf4sYdKPUxgV20A8nUI9dLELsOiRzUXfpCtDgocXtUnmCkZHSY8LqiANUaHcq8bQDqqNKI9JEckx6beKWw+1dXMAkoqB0jS+p4ieGCPUiOySNNtr1vaQShlM0g89cWWHB9h/Av0Ub2x3AG5qinIl7L+14n+ER9+BSwcFB1AIm6l8yLQWVtadBd+hwf4qahQOeKc+Sc3oGa0xwP3fgGm+qQbvJki7JYAAFonuDhKkZxRCLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.08.25 17:17, Huacai Chen wrote:
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
> To solve this problem, we define a set_movable_ops() interface to
> register and unregister offline_movable_ops / zsmalloc_movable_ops in
> mm/migrate.c, and call them at mm/balloon_compaction.c & mm/zsmalloc.c.
> Since offline_movable_ops / zsmalloc_movable_ops are always accessible,
> all #ifdef / #endif are removed in page_movable_ops().
> 
> Fixes: 84caf98838a3e5f ("mm: stop storing migration_ops in page->mapping")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---

Thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


