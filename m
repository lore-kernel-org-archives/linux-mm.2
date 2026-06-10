Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2C3CD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 02:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A6B6B008C; Tue,  9 Jun 2026 22:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C623C6B0092; Tue,  9 Jun 2026 22:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9E9C6B0093; Tue,  9 Jun 2026 22:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA16A6B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 22:15:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE664120860
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:15:26 +0000 (UTC)
X-FDA: 84862386252.15.EE909C7
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 208AA80006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:15:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D6ijSBnP;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781057725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUscgkaVB9GhkTyYmcNNOPyIpn4q5HzwEqwgoYRL1cI=;
	b=6wrArVK8wtZQHTlfvkTGxMZRjHrJv5dv+v14SAM/5PmnGnMnjDqxHr8tqYsOF5jX8WkM7v
	k6oA3pIo2mZpe6K6jf9oLaWu1uVZVd06ZP3sNX51WgVNaooGpLb+JukeC9vaGEn8sGfVco
	B/CgBPPkihb4UL1IakXfNkHBLL1m7Xw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D6ijSBnP;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781057725;
	b=WIPKM9nm+gs3vxdazybiwtDa3LUx+Cmo8gnDHI6HBVuxNKraa9zpMPWvkYPmBJQ7kaCDgx
	Tzg3Cj6A6tozNzfRoMUavXNd2rDF4qO6HPzXiKk83/yXMZsUrVmO5cQ/kNb6/AyR3SDB4L
	twfziNPeuBw6uIjDDTT5hLTG/tKIJD4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781057722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sUscgkaVB9GhkTyYmcNNOPyIpn4q5HzwEqwgoYRL1cI=;
	b=D6ijSBnPu590JadANQn6yWI4D34v3+8oS/4hsrM+AztYMR9ELQesm+n+bMbpuT5UnnPVdP
	3Sm7CUM7F7pRDF+SZFmKWng6A/cUb4qDR+aUBv6agV1CvTEsE1Q0M3wyCDU3CXHWnk0aUn
	MwSKL8vK12126gyL1mz8G54ZZJd+g4c=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: xueyuan.chen21@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com,
	dave.hansen@intel.com
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero folio read-only
Date: Wed, 10 Jun 2026 10:15:07 +0800
Message-Id: <20260610021508.46000-1-lance.yang@linux.dev>
In-Reply-To: <20260609124549.aff7e774603c4af188009408@linux-foundation.org>
References: <20260609124549.aff7e774603c4af188009408@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 208AA80006
X-Stat-Signature: 98z779aaf6jqtosboxked5w1cw89g696
X-Rspam-User: 
X-HE-Tag: 1781057724-791273
X-HE-Meta: U2FsdGVkX18xAdWBosAw01TBLXR/Fxlqu5fA7n5cMzgUoIGNFg7dVCy1JCj3R6MdJn9lufOASLWQiDIuusIa5xVRPj7oJodIUcpLciN9EzodB5YVHR4L64WBUBLbMo3WB5YmOd3mKsjlfeO1fhK4RaBbE/J2zkepF7Ymj8cs7FoQcPyIsj9HVkgHUGRWLMeLi9wIwigIOaPceeEtihy23LZh3hZfYXyKCfxlKA0hgZ7Yqi70CZQL23lGlPV7Ltl4K38bCL0zHozSCLQp3FsgTutQ7rX1I7UvYLwDAVDHOWt35GS/OQ6EnreeNjo24YAkYmETjHK3Vuvus30Mh9ukCc68Gu203tXryr/HkMly8enWTkTrCEcK0JYgKUOx/4lfKtFZbHqoVA+VC6RQJb9j+lR6yIIPnWzzNiMQXg9lmTxqDNhEKnqOhwCCTCUpHzBeVE29cbrROhRPsxT+K/Z21zTVA/hLBMGTUEtKu8DfwLyrHsMZk6xkY5cLbs1zsEkgbr+0MxVZa4QI9XCWsF7arVtKhQKUFuFIf1lOtJTQMPAVKARTI3TI6PbJrG2Ti6V2M85HJve0oDL8I18IA9pMLKCOBLKQKcNH0WZC67VuD5ri8E4Yt8CYO8lVywFqsRZ31X27spTD15gGSFnSNeRuBZ5PjbywCcUVGXnozzgXsJ4yDxy23tJNHFt2O19aQJZS29XkCBuA4UhtHdHFluZjpkrbv2BQpPYbXYUlRkY/OShVJviTQYeniIV6MJMR64oGm0RID0P1PHk0JJqEJqGYyEqgl0uingOidXe87jB+QT34mMep5ngVKqsUXDe/eURImwF1wuUXllnqBpZhr9DvZx7+9cJNa0m2uG8VbwcAsMHqS/BaeULBKP2Ru5P9xboj/0Ci8C5ELTBPy3MpHu+PuZqz0YkFpJK7HDERQUvQryiocd72czQ35kLkBihYtr1NA8K+gR4Nmp+bl+BE/HU
 BF3Kw2t/
 IWigJGyyI9kCvD4jXh8BA/NYDVIXyN7mn8WLbEo44cipoSkBBtM1VrkMmK/ln+QP7RexweCmp+0cM3vmoFI9A57ImSkB11Ad2fYGSO7wxuzN7FjJ6TFDI5xXzP9tXhg97n6C2mpmAyJ9dD6/hO/KSsx8uNz0SN7NCqiuXKoae/vvR6ddCn1noWmmgyUnHVV5KJcfNUNsTY+qiEXlPudzlHipjYnC2cqKevfTEbu7ZINmFMmnmizOzvbYLgH0X311eu++idj1fyXhRCJ+WwF1KoVbRaVEB+wFySff9IaMEk/P33Avx3FFlIMUc2iEEJVVIJex8cr4RwaFgT8kqWD5RP1RvHiJsFxrds20fFnkZLTjFKFdbHFeRZMKV3iWnUibCfvMorHRF1XBB0YSpuKHU+OElGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 09, 2026 at 12:45:49PM -0700, Andrew Morton wrote:
>On Tue,  9 Jun 2026 22:37:59 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
>
>> The huge zero folio is shared globally, and its contents should never
>> change after initialization. As Jann Horn pointed out[1], the kernel has
>> had bugs, including security bugs, where read-only pages were later written
>> to. If the persistent huge zero folio is read-only in the direct map, such
>> writes fault instead of silently corrupting the shared zero contents.
>> 
>> Add arch_make_pages_readonly() so mm code can request read-only direct-map
>> protection for a page range. Direct-map protection is
>> architecture-specific, so the generic weak implementation does nothing.
>> 
>> This was inspired by Jann Horn's read-only zero page work[1] and follow-up
>> discussion[2] with Yang Shi.
>> 
>> [1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
>> [2] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/
>> 
>> ...
>>
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -308,6 +308,11 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>>  	return 0;
>>  }
>>  
>> +bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
>> +{
>> +	return false;
>> +}
>> +
>>  static struct shrinker *huge_zero_folio_shrinker;
>>  
>>  #ifdef CONFIG_SYSFS
>> @@ -982,8 +987,14 @@ static int __init thp_shrinker_init(void)
>>  		 * that get_huge_zero_folio() will most likely not fail as
>>  		 * thp_shrinker_init() is invoked early on during boot.
>>  		 */
>> -		if (!get_huge_zero_folio())
>> +		if (!get_huge_zero_folio()) {
>>  			pr_warn("Allocating persistent huge zero folio failed\n");
>> +			return 0;
>> +		}
>> +
>> +		arch_make_pages_readonly(folio_page(huge_zero_folio, 0),
>> +					HPAGE_PMD_NR);
>
>Can it simply pass the folio?

Right, this came from the RFC v1 discussion[1]. David preferred a page-
range helper for possible future non-folio callers, not something folio-
only.

Of course, we could also add a folio wrapper on top of that if needed :)

[1] https://lore.kernel.org/linux-mm/929875a2-9e94-4dbc-9c98-b342ccc3f4e2@kernel.org/

Thanks, Lance

