Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D207CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 02:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CA68E0008; Tue, 23 Sep 2025 22:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5108E0001; Tue, 23 Sep 2025 22:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521F28E0008; Tue, 23 Sep 2025 22:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 455278E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:49:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF4451403FB
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:49:51 +0000 (UTC)
X-FDA: 83922613782.10.6DB78B6
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id D112A40009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:49:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D/w43Tn3";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758682190; a=rsa-sha256;
	cv=none;
	b=kbHNnWcBf3aoLTvEVzKw+bUL9yrbuZHWwjGE/gdgpOdsv/mAgQjxtUx17ycw+tZYSOKBOG
	pzNQmdq7vWAABfV26PHBAVqYYiESSCyjtHMiuTVjOwzfuNagwODFryE9jNWe1DtwsbtIgH
	ATY6WmEdD5CyE5zfd/uMy0BrZ7MXFv8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D/w43Tn3";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758682190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gS3UMQYfDRiVXfktUZqtEyuly+0oheyOGtsfiL3CXxU=;
	b=59kY2i2uxgOXOyMxvH+tg1q61uzJb/Y9+8ytwKTDNjc2AS/tTMuukPbaghUFcCduW7nZVY
	4L/+BM5oe/WTvXVajZaTdjE+tg7q5vq6eUoSLmePAdXJAAN3Zuh208MmQ1A3F83TcCVA2V
	+ul94vYo949cqbZTkuHTJWjaJPOki1Y=
Message-ID: <f2fe9c01-2a8d-4de9-abd5-dbb86d15a37b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758682186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gS3UMQYfDRiVXfktUZqtEyuly+0oheyOGtsfiL3CXxU=;
	b=D/w43Tn3x7CWbbsMju6wP2WmE63sMFT1L5kwMs0zBjv7gSY8AEfER8sfxukJxuwIgzMoyb
	HkO0RKC4KmgarsNHiuI71MwRgtTRzO2yF3PnzTH3CFUBqrRPSCu3rabdUvARAHDsykafy8
	GMLfw99XCOHABMYrqi82Sa7ykFYURTI=
Date: Wed, 24 Sep 2025 10:49:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 usamaarif642@gmail.com, yuzhao@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, voidice@gmail.com,
 Liam.Howlett@oracle.com, cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
 kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
 roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, hughd@google.com, willy@infradead.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, qun-wei.lin@mediatek.com, Andrew.Yang@mediatek.com,
 casper.li@mediatek.com, chinwen.chang@mediatek.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com> <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com> <aNLHexcNI53HQ46A@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aNLHexcNI53HQ46A@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D112A40009
X-Stat-Signature: mgh3gufpthhdgf3k8915pj1zjq431m7i
X-Rspam-User: 
X-HE-Tag: 1758682189-402838
X-HE-Meta: U2FsdGVkX18zWMXpKNV2YmOOzV/mZbKM0VVpSZuA2WeyapB3p4DbWrdgqHApS8+r5SO4u8DGIzfIlRzzeG0Qh/AQ99EAEImDxDZALTjurNSMyhYwUTuf8xaTYDN+/yq6MWDJdh1QEp8Vs+5bKmGf+NQ38jjGUPJ3r7sSXZhvSI6cV1lIwbX5N9xAA4auutpPdXlKIDCe7YTi2gq1gXeHQLehqooZo8b1SXLQe3OesY7aMFW0VvHw6GLoYYA6YsASkO08TjcwqxJm8MptjSJnd+a1cCkzCkoH+xnphdgsVGENTzRiwBYhm3QAfm6GfFy4DLNfdnLwp6u71UI5TbR7JFpYJ2jXxy8bI1UCeJlIwE55Ml4SI7CRH7CBIqIuz9fVm5XZit1CTX3UMMtjMUD9TeIdG0HpDrBx/r4GDtZtO7QCUT+dFSdUdxEnIwVZ7Kf3NMWzyrXaBtWm24r08BVX9N/iJONtIwjoLsBQiOstfIG1HvpAJgghnr7EgsUOAWggn05LioQmCenMrPS/W+PL2wqojmXAcEbB/XNO6C1YVkGbn3illSXaV9+1C8HlpRJx+Y0kfm+upEJRTHh9+mzX0K08nMxnhn8ZdAz/NPBL/CJytdICxg729qAKqEarPC5PAn8GEZwjz9fF0rpSTyEr2nUs+NPxznf5SwbhPOEZCDVP6X6XHoyeHGGaHOHhRYDQCYiJM59RsnIFrMxXBDmWYUluPLis10nzCoSfBj6ISxZrsvN77t/52N4SC+C8MTuMdqB7EdAhI2nZHPU2qGIok24QcgnkbJeVD10rPLEVg2nKQ3mMUbiROvnfmnEGs0df+xBd9W2+azsVfwt3lznRgYt9yJ/baUsg2qRfqP6MSR/6XIKvYElYgBhd1UQ2u4dASJQlm89AyktkW7QYEGgozmO1UBzNylV19mwy6xhq4ZRwyIIWcr6YjiawMR3rmwN2UI68/DxFzaqilGylf1u
 Q+PYKPn1
 l/uKQg3ZpQyqYPjSl+6UObI/BtYKLDNNlSu50q64d/ViTzkrYWmKQQTK3gnEKz0eW1yQ1Z1VXk9bJFjNCQTeYcI2EXyyLlTUTOvu2kNEoFToukeSPLtcPwARJOvNf9330N2Abr1gKcf6UGruMyxLekBu68hrMx/nM44ok0kEpvUfrZpHBO6kIeIIy3o26TzMG2KsLI/F3fW+aw0RLamIrSkAqIU2sXYJndropcXbC5EIi7IMInRjohBPEbiJRvUaQcdcq/yCd9PImEngOwUbinfhvIW44CoXJZ3h+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/24 00:14, Catalin Marinas wrote:
> On Tue, Sep 23, 2025 at 12:52:06PM +0100, Catalin Marinas wrote:
>> I just realised that on arm64 with MTE we won't get any merging with the
>> zero page even if the user page isn't mapped with PROT_MTE. In
>> cpu_enable_mte() we zero the tags in the zero page and set
>> PG_mte_tagged. The reason is that we want to use the zero page with
>> PROT_MTE mappings (until tag setting causes CoW). Hmm, the arm64
>> memcmp_pages() messed up KSM merging with the zero page even before this
>> patch.
> [...]
>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>> index e5e773844889..72a1dfc54659 100644
>> --- a/arch/arm64/kernel/mte.c
>> +++ b/arch/arm64/kernel/mte.c
>> @@ -73,6 +73,8 @@ int memcmp_pages(struct page *page1, struct page *page2)
>>   {
>>   	char *addr1, *addr2;
>>   	int ret;
>> +	bool page1_tagged = page_mte_tagged(page1) && !is_zero_page(page1);
>> +	bool page2_tagged = page_mte_tagged(page2) && !is_zero_page(page2);
>>   
>>   	addr1 = page_address(page1);
>>   	addr2 = page_address(page2);
>> @@ -83,11 +85,10 @@ int memcmp_pages(struct page *page1, struct page *page2)
>>   
>>   	/*
>>   	 * If the page content is identical but at least one of the pages is
>> -	 * tagged, return non-zero to avoid KSM merging. If only one of the
>> -	 * pages is tagged, __set_ptes() may zero or change the tags of the
>> -	 * other page via mte_sync_tags().
>> +	 * tagged, return non-zero to avoid KSM merging. Ignore the zero page
>> +	 * since it is always tagged with the tags cleared.
>>   	 */
>> -	if (page_mte_tagged(page1) || page_mte_tagged(page2))
>> +	if (page1_tagged || page2_tagged)
>>   		return addr1 != addr2;
>>   
>>   	return ret;
> 
> Unrelated to this discussion, I got an internal report that Linux hangs
> during boot with CONFIG_DEFERRED_STRUCT_PAGE_INIT because
> try_page_mte_tagging() locks up on uninitialised page flags.
> 
> Since we (always?) map the zero page as pte_special(), set_pte_at()
> won't check if the tags have to be initialised, so we can skip the
> PG_mte_tagged altogether. We actually had this code for some time until
> we introduced the pte_special() check in set_pte_at().
> 
> So alternative patch that also fixes the deferred struct page init (on
> the assumptions that the zero page is always mapped as pte_special():

I can confirm that this alternative patch also works correctly; my tests
for MTE all pass ;)

This looks like a better fix since it solves the boot hang issue too.

> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 7b78c95a9017..e325ba34f45c 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2419,17 +2419,21 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
>   #ifdef CONFIG_ARM64_MTE
>   static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
>   {
> +	static bool cleared_zero_page = false;
> +
>   	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ATA | SCTLR_EL1_ATA0);
>   
>   	mte_cpu_setup();
>   
>   	/*
>   	 * Clear the tags in the zero page. This needs to be done via the
> -	 * linear map which has the Tagged attribute.
> +	 * linear map which has the Tagged attribute. Since this page is
> +	 * always mapped as pte_special(), set_pte_at() will not attempt to
> +	 * clear the tags or set PG_mte_tagged.
>   	 */
> -	if (try_page_mte_tagging(ZERO_PAGE(0))) {
> +	if (!cleared_zero_page) {
> +		cleared_zero_page = true;
>   		mte_clear_page_tags(lm_alias(empty_zero_page));
> -		set_page_mte_tagged(ZERO_PAGE(0));
>   	}
>   
>   	kasan_init_hw_tags_cpu();
> 


