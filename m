Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A454ACD3436
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 03:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E094A6B0088; Wed,  6 May 2026 23:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92E56B008A; Wed,  6 May 2026 23:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B0A6B008C; Wed,  6 May 2026 23:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B08B16B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 23:30:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 552AD14039E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:30:54 +0000 (UTC)
X-FDA: 84739197228.17.F1975FF
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf20.hostedemail.com (Postfix) with ESMTP id CA6B01C000B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:30:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wKNe1+eN;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778124652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyZVzRsxXhQaw+/BT2qurWH8p+SNTVYpiB+XsnLougQ=;
	b=zS0o8W7G62FCuEbdgkAS1jurx8je822NhKXptJsc0AnvDgZ5R/zu6OBi9cHLAp5k9tGedz
	a7TXW1Ee4K55LwV8pnLZwWBB3DaJoVxIJof/AqZJ7c34TyQBH5pgHVF2Oy5mPWUl+kcdBI
	XU3pV07nDnEpPRinSFNmcF25FWbEO9s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wKNe1+eN;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778124652; a=rsa-sha256;
	cv=none;
	b=uF/OqyWN4GrpUIh+OdO9y+tdAh9qn66LGkxyy2VYsFAmXK4ga2KC+VMDPKSxfKRlg8djdk
	pffIIOLT7+hN+1rrhxYsHS3XR43VPgEDnkQWgnzBWoGVj8L9Zs7F7rBDe53qWnJEfspKMx
	zYdJkH+5aKenOyTHpHdfqwrFGTdyIs0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778124646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyZVzRsxXhQaw+/BT2qurWH8p+SNTVYpiB+XsnLougQ=;
	b=wKNe1+eNgeqPd05y2iLWXfahEWECb2xBV6LFtMbhJ/SgQmjH9tQEUCZeFHpSXAQKhrRJOp
	Azr0VuQ3gyPGc04emwvgd4V9ks6rWAWm5Z/ewD5QSMupmexgbMlVW5cYJy3E1Q/wRixsWK
	2D2oc9njborSjMOUdqtqKxJWTK4j0aA=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com,
	ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu,  7 May 2026 11:29:56 +0800
Message-Id: <20260507032956.51667-1-lance.yang@linux.dev>
In-Reply-To: <aa778cfc-b7f8-4100-89bb-d2b2ef8e1138@redhat.com>
References: <aa778cfc-b7f8-4100-89bb-d2b2ef8e1138@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: CA6B01C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 739cm9zirhx8ioaoh75pfsj74ro96iaj
X-HE-Tag: 1778124650-210225
X-HE-Meta: U2FsdGVkX18clJZ+iFZNl0j+S0ZXetqhuuy6Z3+Q+LxAbZChWuZPJXvfxBJT3tTYZlFOp3t2c1tqCm1Do8149T2QFuGyINnfzKMAvM+PsmPm3XBbQvhHEjDf3v3f20QUB+HvP9IuFZam5hHEnKHBEj7QEQK3En55iChgjESTmGhaVXSpsfDuRhMJsGV22Xe+NVFf/9/SmIeo+FWghkaaNY06N0mP0uGJ20Xx+jTKqRyl2sVOAaXuHbh88JR8vrcL3i+JcCYETzBBXSvMLkzy6OmFS2jUa36FaWRhy/wGyy/qNQ05R9nlyXQ6Y2DxIGKnYkPoD0jS7wH/t7v+RV6gkWscUV/Qos57YZSk4GNAyxjw6NRuaEwHAqIwa+2t1Of2kMqxbiRL+s5vJ6w/bRWTCmK1bKcN20If1qerDlgNW62fBcKLZEp7SiY0KNeE+AVymIlkKC4VtqFVD8MIQNejYlFjzz+kkoJ0IDhB0WXp2Iq9n55+tQIsqX983lxIj11MNaVmq4J6A9mYvBrQCOPg29kQF3CFX+lSekdsFciebwQR0AO5g+x0x+Xn3WZwEzryO3HbJxvtqYcWP5GKZ3QdYmDp/HX5FjTTXghNiaIJLtbBJH7ttmhATtrnkoiu6CCncJiEO1OoyQtsd93tbyBGShbFM2hZt+MOJQhZx7tt9/SNnEXSwRuKEcV4YzVr85Un9WbE+X78iU10+UNwe01HjtdmNm3ZFwpnnVvvspJAK7R7p20ueLVXSLWBdH5j3L0zgqJoZGJqkPtzYB0RBiinKP9q9yvwc+Lo7UAkSkUbsKuCDmKJhY6T1SfGm0wLfLHRVkzXW9m2SviTTsmoLwx8xwSHx3c07RTl9dJ071xaw51eYVAInLfCmxkXI9RoY2l8RTHIghwOaxILlZCR8CNEpv6T2eH+RdnCWXAJ9dJJFC1v1IAtHQXbs93O9OFhUtobE6gK++wTl/joAjYp9bS
 Enjdvhsd
 fwbpDIZV7CpFor1Mb6K5JIpRhyNRQ6+B77Cvbh5iguf8V5XcSMC6rMNFfByp8PtkxjN4iG1yQ3x6CLg4GpfMsM36lkzbfVKlm36dlbscQ4UNECEdXUZsKt0xAzOjtmEKewZoRVWOiLaW8QNh4jK/eDb16cNC8B763YbkeKF0cObvv/xSGEJi1K0AymB3ElbEyy5xho4lBZZkxb93kdhcE6cDMRdqT1xecX5/aRvSK05sq8hrypZ9NkA7blLy25aR3fKCgXK3v4eJEpHr1z6okdvCxvFf90RIFE6V9mEXzVETEUYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, May 03, 2026 at 09:48:40PM -0600, Nico Pache wrote:
>
>
>On 4/29/26 9:29 AM, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>> 
>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>> 
>> Add a helper function mapping_pmd_folio_support() for FSes supporting large
>> folio with at least PMD_ORDER.
>> 
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   include/linux/pagemap.h | 26 ++++++++++++++++++++++++++
>>   mm/khugepaged.c         | 10 ++++++++--
>>   2 files changed, 34 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 1f50991b43e3b..1fed3414fe9b8 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -513,6 +513,32 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>>   	return mapping_max_folio_order(mapping) > 0;
>>   }
>>   
>> +/**
>> + * mapping_pmd_folio_support() - Check if a mapping support PMD-sized folio
>> + * @mapping: The address_space
>> + *
>> + * Some file supports large folio but does not support as large as PMD order.
>> + * If a PMD-sized pagecache folio is attempted to be created on a filesystem,
>> + * this check needs to be performed first.
>> + *
>> + * Return: true - PMD-sized folio is supported, false - PMD-sized folio is not
>> + * supported.
>> + */
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
>> +{
>> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
>> +
>> +	return mapping_max_folio_order(mapping) >= PMD_ORDER;
>
>Probably a stupid question, but I dont know FS thats well.
>
>Here we are checking that the max allowed folio order is greater than 
>(or eq) to the PMD_ORDER. Yet the function asks if PMD specifically is 
>supported. In the future could we have some FS that does not support PMD 
>orders, but does support larger orders (eg. PUD)?

Good point.

IIUC, mapping_max_folio_order() means "maximum supported order" not
"the only supported order", so mapping_pmd_folio_support() just means
"PMD order is within the supported range".

Also, mapping_set_large_folios() sets the range to:

mapping_set_folio_order_range(mapping, 0, MAX_PAGECACHE_ORDER);

and __filemap_get_folio_mpol() treats max as a cap, then falls back down
towards min.

That said, if we want the helper name to mean "PMD order specifically is
supported", the more future-proof test would be:

mapping_min_folio_order(mapping) <= PMD_ORDER &&
mapping_max_folio_order(mapping) >= PMD_ORDER

Thoughs?

