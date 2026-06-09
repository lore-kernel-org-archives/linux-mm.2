Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D273CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02DF86B00AA; Tue,  9 Jun 2026 05:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D046B00AC; Tue,  9 Jun 2026 05:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFDE06B00AD; Tue,  9 Jun 2026 05:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5C1C6B00AA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76F8340476
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:40 +0000 (UTC)
X-FDA: 84859824000.27.9BCB740
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F5E24000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/YeKi2s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzacP3ypYf5fRrXAJ98V9+ticq2bZRWt9AFGg5i34QY=;
	b=O3FUFmS2ogCWjMJGBIYZgcX0CN2+dU1khtNSf3A+LRhM6a3zW2VPaEJlt5L6nJXEqy1h6a
	oPqHR42WWu3REktDt3SD7n+nkh5lFvo+9R69kPJJCsfUR+Lc0/aiTVVDxCsS3DbdZQpMHR
	D003b8qkb35CRlmiGqw1nXYwo0KOeZo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/YeKi2s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996718;
	b=kp7UA6LWWbwSpdNng8iNaC5V3Lr76J47bT8ExYRd+RIHFb/WfM0byDKZHqxlJPQjta/ju9
	EUQ5ZqUkKOdCBHPoLU62zhBiGx8REj3PfdSgmrNPI5IKhKTZfiUHCh8WfXqX87yrUFxXor
	+/r+aESUU2aYJzv0meqviF3aHOXhYas=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEADF43BF5;
	Tue,  9 Jun 2026 09:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18D91F00893;
	Tue,  9 Jun 2026 09:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996717;
	bh=YzacP3ypYf5fRrXAJ98V9+ticq2bZRWt9AFGg5i34QY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J/YeKi2s/52CbzahjMsaAoNojqTOr85R14eTi47hgVOJrYPk/aOzeBPSWP/FH4qdP
	 614Gruk0mJTut2Nf2FKhtaBEuRwDiGU95zUD9qsUSAp+8Jmsc8MTkOVNQY2a6eMwnb
	 5Yg8rsDhM1NIKxF6t4rR2YeXlrpIeYVrvL24XRKoC7aFhkIJymeaPD0ReKb/58ZXkb
	 lO6FictpCQ70T5ZAEZExH5DhnG/XtAW9h0FqrcIKm94BmM1pe13NEYJd6BMKlNTSAO
	 deoWNXuUSs+PwU87kV0U3QyGmgsiOnfOcJvd7ZWOexx7cRFqnQRFlgoZoIcPhUX9wz
	 cQrRGeJY359nw==
Message-ID: <eff26d08-d824-4459-858e-277760fcb4a2@kernel.org>
Date: Tue, 9 Jun 2026 11:18:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/3] ksm: add mremap selftests for ksm_rmap_walk
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
References: <20260609124746153K8Y8tYI_4pNVKogGMdglR@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260609124746153K8Y8tYI_4pNVKogGMdglR@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bujo49ex8giwkymne9s6hzoz999brqqm
X-Rspamd-Queue-Id: 9F5E24000A
X-HE-Tag: 1780996718-502548
X-HE-Meta: U2FsdGVkX19qsV42uemKg06HCAhXAvd4oKT5VfksEwQL7VERO0jdTajjxLJaMCV/xU0RqFP6olhBO/BDNfaYlcVxgHvS2Jmion3P3PViqZUszujgS/i466yQyYmyN/gEsmoMfqbifZ3cdwYHK/itcc8XVOL0R3Pp5zdQEK1qgiMNrIAByPHPO1x1ZfmOM44X+g+qL8fnbvY19FfDNkow8mq3GLIDrkHPP7RcFPg/FfXknCSO3SQDYIwf9db8tbsS8NphoUX8dfzNDjsQmYRToNSYaZBG43hF+tz38+pKhteeflnTYYVEV0hlbX+XuRKgpv2xL2iatLuzPrvr0YAWSsjbhV6VhJBNuylAGzI6TtsD7FsdOELAaerH3RR7Rc5et9GP+1Dgd2sZEX3I/6Dr5N9zPKbtwipf/u7We1xbn1FidQDQbEL5S9CtC3WIVav2Zd2AvTxbxSjSbn/9nvkmlo8fmQXIV4l6aEAVxj6Ulwa8c3/66yyMaxky/ZsFO2HZTJel5zWVAqrB+2U+xGClbxFRIsZjmkOyEYYwAe7bNXktE51oVreBDjDWSKy7bJADtrGI7tLUf9Jfo6JO0jL0TcYQc2QQ+PEAOQUouUOBv5wvBdVyYNK6SRj2AjgRtW5QiNWqJn1Ju2Ck3Ikh64JfEDTlnfFsemKvJEULJAEfFm9NJaTZ3jTYciSg87uYdX4IhX6umeO6nXwftljCnVXE14Snmj9Ab5k14oyiUVL9TuF2s30cljMPeUIxhvgfwrmuiE7dR9Cs4Y5znrxx4v1leaaf2xEenngg3XLYkIkgNRDgj4VQbNGaAUWqwAJ3vfFpxNt28JiLurtZ97mlZ2ETAPoyanSA7vdWYqFqQjzxcU+FxZ0WwV9prhxpgj9LND1ieV588roOycfylTqn6u5XKW2SJCGQvhMwUCxT6g7NSD0qiX8TBjkyWZVoteoHSAJ/vwr/iXBjqIDdnNCpVjv
 xTcCrCW/
 r0j/Y2dZeMjs0W6o2cjRyBafhndW9Izygx2Qr+DmHIChDNeBA2GFcYGqo8FSYNnd/1iKwEq7oNTKnlaIrN1TWD9KGdiYpRjp1ThL21z9swvE46VDnhMwMpaNLRrAXMigqoQknLppSGIcbCW2h4gLcyRdiQXu1aGTKFMJJqX3RXzCg8PJez6+Wv4bw8dasXB8i/+lv18idtCBBsb4dXPgyLoQTlwsm/V7yjIxzIMO7fqFAP+quoPfi5JaGn5chCICTZE9R/SiwUHVbdZGTKw5wq/g/lXtbQVMx0wRIc48IRHIU9Hs/OIt3IgfoEf2kN+sF8vywJNXTx8eLIJX3lemp1TMpRLUcWXfI1zzC4/cgPVc63/s5OOWTUuVmKmWWYB3j0Sm+uG6XQW1DTcaPYRsq/WQuFJWJ5v4Z8qva
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 06:47, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> The existing tools/testing/selftests/mm/rmap.c has already one testcase
> for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration
> of page from one NUMA node to another NUMA node. However, it just lacks
> the scenario of mremapped VMAs.
> 
> We add the calling of mremap() and then trigger KSM to merge pages before
> migrating, which is specifically to test an optimization which is
> introduced by this patch ("ksm: Optimize rmap_walk_ksm by passing a
> suitable address pgoff").
> 
> This test can reproduce the issue that Hugh points out at
> https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  tools/testing/selftests/mm/rmap.c | 86 +++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
> index 53f2058b0ef2..1cdc4beb48c2 100644
> --- a/tools/testing/selftests/mm/rmap.c
> +++ b/tools/testing/selftests/mm/rmap.c
> @@ -430,4 +430,90 @@ TEST_F(migrate, ksm)
>  	propagate_children(_metadata, data);
>  }
> 
> +static void prepare_pages(struct global_data *data, int nr_pages)
> +{
> +	/* Allocate exactly pages for the test */
> +	data->mapsize = nr_pages * getpagesize();
> +	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
> +			    MAP_PRIVATE | MAP_ANON, -1, 0);
> +	if (data->region == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap failed");
> +
> +	/* Fill all pages with identical content to encourage KSM merging */
> +	memset(data->region, 0x77, data->mapsize);
> +}
> +
> +static int mremap_merge_and_migrate(struct global_data *data)
> +{
> +	int ret;
> +	void *old_region;
> +	void *new_region;
> +	int nr_pages = 32;

Likely you should do

const unsigned int nr_pages = 16;

and then simply multiply it by 2 for the temporary larger mmap.

> +	long merging_pages;
> +
> +	prepare_pages(data, nr_pages);

Is it really worth moving that into a helper function?

> +
> +	if (ksm_start() < 0)
> +		return FAIL_ON_CHECK;

Why the merge here? Wouldn't we want to merge after mremap()? mremap() will
just unshare either way?

> +
> +	old_region = data->region;
> +	/*
> +	 * Mremap the second half region to the first half location (FIXED).
> +	 */

Okay, so we create a VMA and populated anonymous pages. Might be from THPs, do
we care? I guess due to the split-on-dedup, this should be ok.

Now we mremap half of it over the other half.


> +	new_region = mremap(old_region + data->mapsize / 2, data->mapsize / 2,
> +			    data->mapsize / 2, MREMAP_MAYMOVE | MREMAP_FIXED,
> +			    old_region);
> +	if (new_region == MAP_FAILED) {
> +		ksft_print_msg("mremap failed: %s\n", strerror(errno));
> +		return FAIL_ON_CHECK;
> +	}
> +	data->region = new_region;
> +	data->mapsize /= 2;	/* mapping is now half of original */

Let's avoid the use of trailing comments where possible.

> +
> +	if (ksm_start() < 0)
> +		return FAIL_ON_CHECK;
> +
> +	/* Attempt to migrate the merged KSM page */
> +	ret = try_to_move_page(data->region);
> +	if (ret != 0) {
> +		ksft_print_msg("migration of KSM page after mremap failed\n");
> +		return FAIL_ON_CHECK;
> +	}
> +
> +	/* Ensure ksmd scan two turns at least to update ksm counters */
> +	if (ksm_start() < 0)
> +		return FAIL_ON_CHECK;

Why do we have to re-run KSM? ksm_start() already performed two runs. To remove
any leftover rmap entries?

But fundamentally, wouldn't it better to query before+after the
try_to_move_page() the PFN of all pages, to (a) make sure that they are the same
before (all merged, if not -> skip) and (b) make sure that all were migrated (if
still old PFN -> not migrated -> BUG).

> +
> +	merging_pages = ksm_get_self_merging_pages();
> +	printf("merging_pages:%ld\n", merging_pages);
> +	if (merging_pages != nr_pages / 2) {


[...]

> +TEST_F(migrate, ksm_and_mremap)
> +{
> +	struct global_data *data = &self->data;
> +	int ret;
> +
> +	/* Skip if KSM is not available */
> +	if (ksm_stop() < 0)
> +		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\" failed");
> +	if (ksm_get_full_scans() < 0)
> +		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\" failed");
> +
> +	ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
> +	if (ret < 0 && errno == EINVAL)
> +		SKIP(return, "PR_SET_MEMORY_MERGE not supported");
> +	else if (ret)
> +		ksft_exit_fail_perror("PR_SET_MEMORY_MERGE=1 failed");

Why are we not simply using MADV_MERGEABLE instead of the prctl?

-- 
Cheers,

David

