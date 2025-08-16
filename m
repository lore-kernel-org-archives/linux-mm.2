Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFB8CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAB08E023B; Sat, 16 Aug 2025 03:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B9F8E000B; Sat, 16 Aug 2025 03:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A3F8E023B; Sat, 16 Aug 2025 03:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A78158E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:22:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EFA51DC7D9
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:22:38 +0000 (UTC)
X-FDA: 83781777996.05.B760C6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1C310A000C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:22:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbrLDRqi;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755328956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FAicmBrfruBR0WNu2OeS2bQsnDAK3NIZV5w3QTHUts=;
	b=XmxQdedl6BjGAa3z/Cf6Bc/igi5HsYS0bCs+Arys+JzjOd8HOtqE1SUb9a2P6esc8JSUS2
	/adsb4mztXQPX4sxjENbhTnCuptD4A0oARuDGnhrg2e8CsmjhP5Yg7mn5k2z8JzfixBG1a
	RjLUEEVb+TBJzL8v6WXoGzSZIQ0UTZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755328956; a=rsa-sha256;
	cv=none;
	b=xZuHQjmR6VwB7WNSGyh4DBtNMbpVcGhLgB0cygt3hilCbl43jKbTiM/sj7T3uP+ktF4DYU
	UX9b9EPn7v2eqDdvcsT+eE8yDtTCi2IpZUAczo83EIGPz2vpb+YyXsOT7F6YHqblLVDUIJ
	+szDhtNx8t6dVTm8lWzzzIHoYGt3BI8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbrLDRqi;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755328955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9FAicmBrfruBR0WNu2OeS2bQsnDAK3NIZV5w3QTHUts=;
	b=NbrLDRqiTo/2ovEMhp8wv4CgPoEzwSxzQwHqFRSMhsoidSJOWhl22MxLHyfmSqYZYiOcr6
	ABTdXUwSlrk6XE1AfdgoGwGO+QKJOCrpawISh6YtXfqqovxcHT+O41SWKQYNOHSGklUQVb
	jHJjg76XcXYPd2ZHQErdGwIBQhFePH8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-ULSajIFGOlKgHukfq-GenA-1; Sat, 16 Aug 2025 03:22:33 -0400
X-MC-Unique: ULSajIFGOlKgHukfq-GenA-1
X-Mimecast-MFC-AGG-ID: ULSajIFGOlKgHukfq-GenA_1755328952
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9d41c245fso1914435f8f.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:22:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755328952; x=1755933752;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9FAicmBrfruBR0WNu2OeS2bQsnDAK3NIZV5w3QTHUts=;
        b=smaHO/F+i26SN+X/cauJqrdU22TeObvbX5W6hbCzbPxsxKoJU2mfQBgf23XV/XBk/3
         cxGqxYQ3dmF/oajNKcjURDcEyQ0ZghbXHknCzhJzkRhxUy8kHuDZ7qJnVxjD5nov2dct
         3+nvK2Yta+Ma8snY+PMgc0r/wwFaVZd0+6s2s/7zAi0OXh3kJncOlBHRYaRchLXNjcoy
         Ymt6IQ16rqChC9/4wK7XgCxh7bgw96B5PqkTKfLQmRZH3PNbONI5pGmhdZTNpgNG5UIN
         pwjq2AZm0ioJ5//EohfSbDzbJjTg1gfeW6EUTLaqPyE6lrSWG5ySeaNEynBcONjWFddG
         m2Qw==
X-Gm-Message-State: AOJu0Yy4N06aajh9K0PWNOOTxYfADs3X6HJmrn1UTsb/YZJsjZjmlqSJ
	q5R5LZfpS5kDkNpkNo1Uh28g8PSsd/wwFmFEYPrB/7yW5eEQTrw8evqbcztGPzPIzdCUgeTfkZH
	39ulneVF42s4uBx425DHMmSQcQYVI9NJPPztMez9oh+1t+HzHm95/
X-Gm-Gg: ASbGncsWMxEC7mDt1KTQ4m27pMFPWnIVNyeO/qVqUr5oKiW7dse9sQf2ZuMeDUEwbb2
	rMMxBAckrwymwOXpJ0QwY7ki3/9wYbfoish8wYcFnZ9IksjREnv5NZImUmMj6ROqXEkwTpPZNmS
	KzaLTA4ZsG4r2B4z569KNoFxCQR9aRnHaqFYo3XFYAxgJHfkqyo36KKjxBP96uY/21Yfo1sG4PN
	7dpCwR1lhatmwdJv03wXIcoHYe6BOCYcnIVG36fUX5xYAiyLS59rh6aH9w0cLK0uSFk4+l8zWqH
	uZf0/J2I5Si31DiXA4XgK5ckaOWePeudAvjF5CrO8Fb2l+1/rv0tj16w/+ZSk4Rjxl8CTvzuyPa
	Rf1UqkbTL6w8GUOny8j3LCmcGSH+wbpW6mEZjgFDLcD/IBYwPn9zmXtx4nNcjYKfJFso=
X-Received: by 2002:a05:6000:2dc8:b0:3b8:d1d9:70b0 with SMTP id ffacd0b85a97d-3bb690d1d7amr3726425f8f.40.1755328952338;
        Sat, 16 Aug 2025 00:22:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFHdJB4IwyyyA3bVpfFLOHZuVfY0zKaPkaw+OIpd1jqYrjiAl5FZVQ25zMUyB5BNnGJxF4+A==
X-Received: by 2002:a05:6000:2dc8:b0:3b8:d1d9:70b0 with SMTP id ffacd0b85a97d-3bb690d1d7amr3726408f8f.40.1755328951919;
        Sat, 16 Aug 2025 00:22:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb656dbec5sm4669828f8f.31.2025.08.16.00.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 00:22:31 -0700 (PDT)
Message-ID: <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com>
Date: Sat, 16 Aug 2025 09:22:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: Huacai Chen <chenhuacai@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Michael S. Tsirkin" <mst@redhat.com>
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815090539.1578484-1-chenhuacai@loongson.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eWrX7rOx4OhPQDHXjvNLV5U72axdCbj5_due-VqcLf4_1755328952
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C310A000C
X-Stat-Signature: firg31bz5jt9rmwo5y553m3mtebbp8o1
X-HE-Tag: 1755328955-133297
X-HE-Meta: U2FsdGVkX1+j37O0dzznUqd6yidyLXicGZMb64RvRNxVrIgq+e1+Bob4nUF5WnR8ATPpRjUQu5jc+vqmDE53pSqt/ATtptiadY2h6he+NjYdzAu34ji5EKB3+teiOvPSOJzL1cjC0wTQWzzHQcSIIAw4DwsdYIfiDZXSkJK+p/65PSm1mivwKSKz0b/BKgmfNEhP6BEPRaKEhNQwQWLV4T5RAzBboKytamv7mf5cljncaWUwDWGNLmOGE9T3KFGkWF1IzqnGoG4AZs00RkOUSZCugNY+Oj4r0/lNdJEHzJbIGZxNgtmFiOp93ltl9pwbQuAKpa1QebVvxSNAqkXAvXKpJJJ97gmSYWnIuB8iPuByqU0vknpB33pU3E1lGKEGsyaiWZ9MLkEZheztfiF3djGL4OmxP6YVb6HeEjbD2WbR6Xt0xftkhJdX0K0jUVxvA8jOJftEzGumS0rTFRCLikg/Ia8INpQTqv1LZKHSgFHEnWzyDma1po7n8S0ocRpNeXbxNnmz//VHC33JqXSQsyGVhr5GqX4a/2nKZl42iPmbHDM22v0pOAf8smlHyrscPVRpkfRR+KnJVyyFQ1pjY9Hyj34lX+SBb80+19NyzWVSc5GyWH/g9q9f8BvgycPQvUDkWXsoO+ujcJqBtxWvBlGP75j0n5tBxStMRHeOLZHeK9oPrMUmXcxtXV1ekbuyKlGelz+YC9g1awOLTPLKeF+0oWR8THXLb09mmDsA72ViKkQoaxYyLwiMArnnmbH6Y/nmk5IrMNo4X4d5q7vEjygAbOpjIjdzfptRRLVlCgfW/I3vJaw3WL0Jox1eOHsxzA54X9Ws9it0XW3VeS3rg0tjORVWq/0+6W4Nmls2lRLoyZFDBorEYaviygsb5FSn0yEi8j2WFJio5Sn/N3v7xk8a3vj+b4S1tysT4O2r7cN4jdOiU5Zn3cQiu7TV0b2KGUOVOQSCytCo0nVVR+P
 AEBEDItn
 JRg5+FnlcMwIO2Vspb1eFZ6Y13r5ynb3CZn/+xT8lZ95pd7grVV6efu8AL2UuJBN8g2ovPYlk0dgi7Z1y2KgidvLxSqIzoGXp/tIVPx3rVMpImX/XRB7dOtIABbEhv9ww8b4+PK5UHkOuW4WQLbPhqqtON/FtpQffJywWWm9xgsePgnGSVp9/zWG3g3yiGBgJMDKebPtSh1fKGE2ZJTcknC0vQr1Jf0Vxj9xPmo7aynubT2rEntyGIOO7KmeNVDErJbVIP7is1j2FXjqeBAVxkZe9iT/KSAk6s5t98GjB4UTdEDS6KvDddQC+06L2QrE4aE0XdJJHMltuaOMZPTJkAAtrXo93cxehzUXd9dEJNFPLQhd2p2tiPjL+7c4HZUpL8dX3V/pjrMpRP5JIrIE429G8+PKXymMnSuClCTU8uYfNct/K1gjDBrneHyBruvPa82bP5dm59XBmRp05eJPHUgnjanEbUETZkZ7IJgxrOnlHzqHp10xuqPW4IjwPWj58bzjH03HopZWdcj69yq0oLXMSZA2uMwgL3+NrzXQu8mdnPXJS8OcuFpkFwUYq4ABWsmLY/f4RriCCTsMjTMbBOqg6VJrud70nIYja
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 11:05, Huacai Chen wrote:

Hi,

please CC the appropriate maintainers next time. You missed (some) 
balloon and zsmalloc maintainers.

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

Ouch, I missed that CONFIG_ZSMALLOC can be configured like that. I 
thought it would always be builtin.

> But when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot
> access zsmalloc_mops because zsmalloc_mops is in a module.
> 
> To solve this problem, we define a movable_ops[] array in mm/migrate.c,
> initialise its elements at mm/balloon_compaction.c & mm/zsmalloc.c, and
> let the page_movable_ops() function return elements from movable_ops[].

Before I took that easy route to just get it working quickly, I 
envisioned a proper registration interface. See below.

> 
> Fixes: 84caf98838a3e5f ("mm: stop storing migration_ops in page->mapping")
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>   include/linux/migrate.h |  6 ++++++
>   mm/balloon_compaction.c |  7 +++++++
>   mm/migrate.c            | 16 ++++++++++------
>   mm/zsmalloc.c           |  6 ++++++
>   4 files changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index acadd41e0b5c..58fac171e4d5 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -57,6 +57,12 @@ struct movable_operations {
>   	void (*putback_page)(struct page *);
>   };
>   
> +#define MOVABLE_BALLOON		0
> +#define MOVABLE_ZSMALLOC	1
> +#define MOVABLE_MAX		2
> +
> +extern const struct movable_operations *movable_ops[MOVABLE_MAX];
> +
>   /* Defined in mm/debug.c: */
>   extern const char *migrate_reason_names[MR_TYPES];
>   
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index 2a4a649805c1..a1d2625b5c39 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -254,4 +254,11 @@ const struct movable_operations balloon_mops = {
>   	.putback_page = balloon_page_putback,
>   };
>   
> +static int __init balloon_init(void)
> +{
> +	movable_ops[MOVABLE_BALLOON] = &balloon_mops;
> +	return 0;
> +}
> +core_initcall(balloon_init);
> +
>   #endif /* CONFIG_BALLOON_COMPACTION */
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 425401b2d4e1..92918fab3e1a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -53,6 +53,10 @@
>   #include "internal.h"
>   #include "swap.h"
>   
> +const struct movable_operations *movable_ops[MOVABLE_MAX];
> +
> +EXPORT_SYMBOL(movable_ops);
> +
>   static const struct movable_operations *page_movable_ops(struct page *page)
>   {
>   	VM_WARN_ON_ONCE_PAGE(!page_has_movable_ops(page), page);
> @@ -62,15 +66,15 @@ static const struct movable_operations *page_movable_ops(struct page *page)
>   	 * it as movable, the page type must be sticky until the page gets freed
>   	 * back to the buddy.
>   	 */
> -#ifdef CONFIG_BALLOON_COMPACTION
> +#if IS_ENABLED(CONFIG_BALLOON_COMPACTION)
>   	if (PageOffline(page))
>   		/* Only balloon compaction sets PageOffline pages movable. */
> -		return &balloon_mops;
> -#endif /* CONFIG_BALLOON_COMPACTION */
> -#if defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION)
> +		return movable_ops[MOVABLE_BALLOON];
> +#endif /* IS_ENABLED(CONFIG_BALLOON_COMPACTION) */
> +#if IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION)
>   	if (PageZsmalloc(page))
> -		return &zsmalloc_mops;
> -#endif /* defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION) */
> +		return movable_ops[MOVABLE_ZSMALLOC];
> +#endif /* IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION) */
>   	return NULL;
>   }
>   
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 2c5e56a65354..052fcc0d29e5 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -2246,6 +2246,9 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
>   
>   static int __init zs_init(void)
>   {
> +#ifdef CONFIG_MIGRATION
> +	movable_ops[MOVABLE_ZSMALLOC] = &zsmalloc_mops;
> +#endif

No, not like this.

Please add a proper registration function, and use the page type as an 
input.

int register_movable_ops(const struct movable_operations *, enum
			 pagetype);

Probably best to refuse any page_type except PGTY_offline and 
PGTY_zsmalloc for now, and let the function fail with -EBUSY if already 
registered. The function can have a stub that returns 0 without 
CONFIG_MIGRATION.


The you can do here

int rc;

if (IS_ENABLED(CONFIG_MIGRATION)) {
	rc = register_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
	if (WARN_ON_ONCE(rc))
		return rc;
}

-- 
Cheers

David / dhildenb


