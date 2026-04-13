Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C94ABF34C5E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29306B0093; Mon, 13 Apr 2026 11:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDA1C6B0095; Mon, 13 Apr 2026 11:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17DC6B0096; Mon, 13 Apr 2026 11:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D71096B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:24:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0977E2737
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:24:39 +0000 (UTC)
X-FDA: 84653904678.29.34EF8CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2CFEC0008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:24:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qp2a+nMu;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776093877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVHJe17/u6liWxMgvXz72tZZejZFlOq9P/lSV2E+0Uw=;
	b=DHhm8USV1y7av4NXaWLBSTYPa1gwxjRh2nk8Qs7UeiYA8hgE/U8wEgu2YDbmiKP7IX651i
	RCxFoTaRRjQrf9aFIqwWe/yx2UH6bJEQjdsc3xv0BZFuum7zIh8KYM4Tu3Doqtbctgr9Aw
	2t32ap7ZVdt45e+ZJyQY3YrJcFNmS94=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qp2a+nMu;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776093877; a=rsa-sha256;
	cv=none;
	b=XiA5pCniVpQIF/M0Pt0KR84FgzsmSlZO68Ip3DMgqD6yMExUqhIfJXvzz9kmb8783MEvTK
	SXbsPFZxDvAacrybYRG0V7lDSOhcOfLKBqp6kRNJ5gc+OdHecp4BPeEFjxqcxSX9n1Kvib
	UROJ1QcTyN51qGm8fr4wsZZukbcFpCA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776093876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cVHJe17/u6liWxMgvXz72tZZejZFlOq9P/lSV2E+0Uw=;
	b=Qp2a+nMuLgGIPc0wsmkHNNaXiNLRnMYDXSBqO9Fym7Seko/Jrfd2FYDBSdQCUJaWzvQX0g
	peuN3X60xVYJR9Dt2svFlQXUma+2y0qnhMw+jaiCUM7OkmzcGZEoK80VEljx8RU2hlU/MZ
	lAGoIkLz003pR/Fpe1c3VcKQNR4CoDo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-dBVBRduGMEGW594GviBorA-1; Mon, 13 Apr 2026 11:24:34 -0400
X-MC-Unique: dBVBRduGMEGW594GviBorA-1
X-Mimecast-MFC-AGG-ID: dBVBRduGMEGW594GviBorA_1776093874
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50d84b5f73bso56507051cf.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776093874; x=1776698674;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cVHJe17/u6liWxMgvXz72tZZejZFlOq9P/lSV2E+0Uw=;
        b=d/n4RLNqsCV3gONtv+tkal4GyRS99d7r6z6jpXrVtBiNL985EecGYJTkTDaB/wa8YJ
         OEFwMqEwKjJULmgVknFAokXg2Su3LnWjDWBNmTQwEvxE0LnJ3gys7VbUAUEDWULa3B7D
         87OPqwBjF6OiZIXUxv028qQ46RsCFHT6KGnELq43u19lRfhAv/kTWDp17cQy+bx9KXXw
         FVWp1euH0iLKzW+z6MBcLqp1PZr0glmzCgiVJnMKDsikuOP7KeM6PV7BhiuDsIKybTmS
         yu+aUfNoKgTbKKyjs2F4dbOt7hpKJYJAcIrS313eLAWuCkb19npd5TeZqbdvt43t3aQY
         IX4g==
X-Forwarded-Encrypted: i=1; AFNElJ9Ac8dfOJcWKi2Z7cwrao2eZPjfTIUEgFmkGXd1ksxUQ3uz8OuAW2YKNRpF8Rp9IPZp8293rCIe7Q==@kvack.org
X-Gm-Message-State: AOJu0YxmHK2WBkey4/bWmZQcZromlBuELEDV5tN728nX2BOpUzcR44UE
	wNL70/+crZQlIpUQDp9I4HGBXGXGtHqulTdNpuJXvZVDLsNwZWAHogsva6CN6szqCTevLDbbi32
	ghlj8dJix79K5MLzEUUT9E7E0X9lR7iBaOmaUtUvfIx83pgFJVsTmCNdBqZF8
X-Gm-Gg: AeBDieuB5DlFrNyCcOjlMZXBOiIVuFvDUYjo4dYazurqnzfMkylFtcWOwN7nd3jUTrv
	Z38xN1mkQbDRWrzno+3xZXxPT485R3g97U4e9v5EtIrjrNRlidSloEBXFFQ3rF8XcwKj4gW0zEE
	Evr1VyBffy0f8gfYDCSwDHKPKVbHIYaFdbPu8U9Sa/xnpYS/pTUjolXmfU19frr53c9oei//Pjo
	vXpgvgrZKUbrQg0/K4noudlO7+T8bNy5M0TEOfJ7a/LOa1ZxMOrlr8QqfajwbsXleQclJhzrFqi
	9Y+zv+q2h0LsMHW7729whZiM5r0QxF0nce+jT4IBlST2jCJJ71P+8igs+KHZKrDNP2jxADTJmDG
	goy4luN4/dplr4zpopiSyIsNIrw==
X-Received: by 2002:a05:620a:4041:b0:8cd:bfd9:e2a2 with SMTP id af79cd13be357-8ddcfbad95amr1957599585a.43.1776093873955;
        Mon, 13 Apr 2026 08:24:33 -0700 (PDT)
X-Received: by 2002:a05:620a:4041:b0:8cd:bfd9:e2a2 with SMTP id af79cd13be357-8ddcfbad95amr1957593785a.43.1776093873451;
        Mon, 13 Apr 2026 08:24:33 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb9351afasm864689985a.36.2026.04.13.08.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 08:24:33 -0700 (PDT)
Message-ID: <119dfe3d-4cfd-46e3-a539-8ac9af90f940@redhat.com>
Date: Mon, 13 Apr 2026 11:24:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] mm: introduce pgtable_has_pmd_leaves()
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, dev.jain@arm.com,
 baohua@kernel.org
References: <b65d560458b2488f715b5afc1603d786e786ccf7.1775679721.git.luizcap@redhat.com>
 <20260410081938.51302-1-lance.yang@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260410081938.51302-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KoFwVVwa0a74GfVThvTySUtLnnQgjQwPnPYsxOgooK4_1776093874
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E2CFEC0008
X-Stat-Signature: ix5oigd7c17i9n4rd6uqx833swgpip9u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776093876-345668
X-HE-Meta: U2FsdGVkX18i+1zTgWUBG3XyMWVFrTUSkAqPyXEWRuunjpHehCzaeVUkVVptF58sKyduI2puban4JR9CARvvDdqgbEJ3X0TdlrqDZIbqNvAJHumhgdwDMbAiFPQiKQJAAMf/zWhwfXUA+5eoE3ptBnVktbHAZeXHu7BgVJkSjaaxhoTm9g63sohRL7GuZBY/PgJt5JSf3tHLgrfMY5QBn2bpeEyBXZYguIxR6Vaf6DK8nQSFxO1D/Mi13eHTp4guVx3hjGFCINhLFH02lkwjWVpIf7snJLbcIvIeWOeuXs9oDWAY7vf8W+/HI7a+uEooMxZIo+5RSSBgUzWjW9FeNmAaAuQXoFSl/lCjTdt718SxnBbR0vO0YrQgw4mZpdRHgPzRV61MNtwzUWtXPTtvReMuonEYZI2OUWCyqgz9ksZquRI5aMKoWqRQpN74WN3OhTIwv++vEBwilQoS6y7GwxRaSVkPqBV7/HT7XUUFGyB37yUvHUNT7YBCE1oawAnUUxCR3Xu3LUCCFXo9sMtuoKxQ+9TVGuJSlugJYKVUWaDMjs8PYMqIm5OE6aB2NaNM2MhssfFgmCPRZFRVFIZ2j8A8pwE1Pw0uOJ8+uStAPEEiUJFc+A1s5vJMBb5KMHPeFOgHT60CRAqy3SBSuNAchgTyqXNhgl6zIY/OxvHtPzyVNP651i9+3DcxasD8Y706DE4iBQY4SyJRoP6PTP6dKxBjcAUUTrmlgwknyrs9WtjWHQ/9YUFrqCjH7IwRHtq/v4si2/Fa8Rim6zADUz/I0AOPby7NLQPmMz0lBKdqx6c0rsZI0qXP09yoqlYiaDKRDKTlMbyrLVdFL8CjmPpVPq9MbpYsyIR52OPaUXbZGjufYoVjyE9TAivwZQ7E2wLIKV/SIPaYHAMo/xfgtgRGWqtJtHJcMHTxSUNy3AzLmRzabxPfbiUbr5IgFqbZ6HeGcXKDyx1Xf42zxWY+zvV
 3rJGtb79
 156+VAp+MWix7gtroyJtEAsY+71D9SDYpdW2wV/aYX4EkKLDSeLqGpE3f/z7RI8Mv9rUKcoaJkYsZIOenUf9b9DZDqhJlRthJqzxFmCoGIEBXRNnJP2QipXR3I2/9SPTjed/v1rFE5LmBSUXSWJmpOFft/F64H7Amshck5IytcvQAz41SSi0GCcm42M0F0PoHve9TzZ+qRO0tRLxcNK4STljcLioDlJi3gghqeNScZCDsC3W3cXfMnLd+LKH8PEcA1UHlGpTxbGhB2XBM2L6f24JdxcjYWIP6rLl+XqN+w2+dKSpdEkp9OcsexLKl8fzODhg0udTaCTIj6G01oLS4Or0tR7DmQuj1TxbS8FwVAuVNU/x8ihRJ5EJMoCsl3iPt0d4KqKTXVDvYO2XsycZKgLKaM5+8xYErFQ6cKk5inhQxWTzDFaVx/uMi+wAv8CRosuK8I1X3L1kFvaBYkjc7uHTdPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-10 04:19, Lance Yang wrote:
> 
> On Wed, Apr 08, 2026 at 04:22:57PM -0400, Luiz Capitulino wrote:
>> Currently, we have two helpers that check for PMD-sized pages but have
>> different names and slightly different semantics:
>>
>> - has_transparent_hugepage(): the name suggests it checks if THP is
>>   enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>>   implements this helper, it actually checks if the CPU supports
>>   PMD-sized pages
>>
>> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>>   by the hardware, but it just returns a cached value acquired with
>>   has_transparent_hugepage(). This helper is used in fast paths
>>
>> This commit introduces a new helper called pgtable_has_pmd_leaves()
>> which is intended to replace both has_transparent_hugepage() and
>> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>> it returns true if the CPU supports PMD-sized pages and false otherwise.
>> It always returns a cached value, so it can be used in fast paths.
>>
>> The new helper requires an initialization step which is performed by
>> init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
>> during boot in start_kernel() right after parse_early_param() but before
>> parse_args(). This allows early_param() handlers to change CPU flags if
>> needed (eg. parse_memopt() in x86-32) while also allowing users to use
>> the API from __setup() handlers.
>>
>> The next commits will convert users of both has_transparent_hugepage()
>> and thp_disabled_by_hw() to pgtable_has_pmd_leaves().
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>> include/linux/pgtable.h | 15 +++++++++++++++
>> init/main.c             |  1 +
>> mm/memory.c             |  8 ++++++++
>> 3 files changed, 24 insertions(+)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index a50df42a893f..c4c5282f795c 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -2192,6 +2192,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
>> 	}
>> }
>>
>> +#ifdef CONFIG_MMU
>> +extern bool __arch_has_pmd_leaves;
>> +static inline bool pgtable_has_pmd_leaves(void)
>> +{
>> +	return __arch_has_pmd_leaves;
>> +}
>> +void __init init_arch_has_pmd_leaves(void);
>> +#else
>> +static inline bool pgtable_has_pmd_leaves(void)
>> +{
>> +	return false;
>> +}
>> +static inline void __init init_arch_has_pmd_leaves(void) { }
>> +#endif
>> +
>> #endif /* !__ASSEMBLY__ */
>>
>> #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
>> diff --git a/init/main.c b/init/main.c
>> index 1cb395dd94e4..07f2ddbf9677 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -1044,6 +1044,7 @@ void start_kernel(void)
>> 	print_kernel_cmdline(saved_command_line);
>> 	/* parameters may set static keys */
>> 	parse_early_param();
>> +	init_arch_has_pmd_leaves();
> 
> One more thought here: I don't see why we need boot-time caching.
> 
> has_transparent_hugepage() does *not* look expensive on the common
> archs. On x86, it is just a CPU feature check. MIPS is different, yes,
> only the first call there is more involved ...

The caching is not being introduced by this series. thp_disabled_by_hw()
(which is used in hot paths) is checking a cached value too and this
cached value is also set at boot-time by hugepage_init(). So, we keep
the same behavior while extending the use of the cached value in the API
(which makes sense for consistency).

> But if we *really* want caching, couldn't we just do it lazily instead
> of adding another early boot init step?
> 
> Something like:
> 
> bool pgtable_has_pmd_leaves(void)
> {
> 	static int __arch_has_pmd_leaves = -1;
> 
> 	if (READ_ONCE(__arch_has_pmd_leaves) < 0)
> 		WRITE_ONCE(__arch_has_pmd_leaves, has_transparent_hugepage());
> 
> 	return READ_ONCE(__arch_has_pmd_leaves);
> }
> 
> That would avoid depending on parse_early_param() / parse_args()
> ordering, and it seems much simpler too :)
> 
> The boot-time init step looks a bit shaky to me ...

I understand that caching on first access as you suggest above is an
alternative way of doing this, but having to properly order
initialization is very common in start_kernel(). So, unless we identify
a case where the ordering is tricky or undoable, I don't see an issue
with it. Also, note that this ordering exists today but it's implicity:
thp_disabled_by_hw() can only be called after hugepage_init() runs.

In terms of simplicity, look at how the resulting code (using an
untested version of your static key suggestion) looks in comparison to
caching at first use:

DEFINE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);

static inline bool pgtable_has_pmd_leaves(void)
{
	return static_branch_likely(&__arch_has_pmd_leaves_key);
}

void __init init_arch_has_pmd_leaves(void)
{
	if (!arch_has_pmd_leaves())
		static_branch_disable(&__arch_has_pmd_leaves_key);
}


