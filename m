Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A16F2CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0006B00AC; Fri, 16 Oct 2026 08:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92066B00AD; Fri, 16 Oct 2026 08:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE796B00AE; Fri, 16 Oct 2026 08:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 881946B00AC
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:18:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14741A03C5
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:18:07 +0000 (UTC)
X-FDA: 85328391414.06.393013B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id E102818000D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:18:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="fmqSEu8/";
	spf=pass (imf06.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792153085;
	b=S7j+/tQYmVh8Su1n5L9j0NkAGh0LoqwRcBCAb6+deC1DyF27GVEpow8/URBiTMTL4tZ/OA
	3V1VPfS8xnc7S0hFmTh02WfqiWBFghwVXBvaAeMBen7E2zgiXrvH+LkXGiUIEk6OOmQydb
	umqrjB8rvsKiXEEPACA7DtJB6NNzb7g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="fmqSEu8/";
	spf=pass (imf06.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792153085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUW4U01dFASPTC5DJPrSH9eKqjAjVlfOA8UZMZ6k/D4=;
	b=JU8Chausgwt0TrMZavLQk0EW30S0e9zXy+Zn7Et75E4Eq87/GBGCjQCyhJPWgeDIU/Ro54
	PWffFo0gWok4dkT+P/S66yfAJR6ZrayFlYoGZxGBU+z4mkq4neX8xr2AP58LOecW/5eVRh
	vE/WW1kI8eoklxsPgBOH9Kz5IwYcy1k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A170414BF;
	Fri, 16 Oct 2026 05:18:00 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 591853F871;
	Fri, 16 Oct 2026 05:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792153083; bh=Xy8QFx0pIXL4ldv8r+Coyw+l10AZN2VdWJ1iwbxurkY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fmqSEu8/7BGE35IAOlnvU9aPOhwvcym+dmE0vNJzMFe17rZUeyZoXiVtNNPcHe4Cv
	 OCVWlMF+ah71unR8czVXVlK2jyc+DjB6p0C1LWHHht63Yze6mlaK4lnMFjCzVf7g19
	 69pFRHHiM6se11dgZ3QLoOuGQZVK7sHvVbZIckJQ=
Message-ID: <73c55ce6-67a5-471d-811c-facf712b2fe9@arm.com>
Date: Fri, 16 Oct 2026 17:47:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] selftests/mm: check MADV_COLD and MADV_PAGEOUT range
 handling
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-4-gourry@gourry.net>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261014175756.2035176-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E102818000D
X-Rspam-User: 
X-Stat-Signature: upq8cu8un16t7s9garz9zh49fw9tbwk9
X-HE-Tag: 1792153084-664692
X-HE-Meta: U2FsdGVkX1+bPXT0Pvkau8NpnDcj79D6MjLRoA0FpiZ6XYon6fdmvQFZxXHGZy2c7qumLbQQSyhiOSinWoFbSaOsZrxA/bMCPqldyzalBCT1JUpN+f1V3wXqb1qXfeqVeq+Eb0lRzmgmw3i76Cg7E7QTlxhsnJg5/r2A94c6CEmrbWk86YTgOVMUFTNSFVUYfk1GK7bm+QNLTfp1P4EDGzbmFcay20OXVl42pE20kaJWHxZTd5OCX1Gw7af1oq+XY2EPKGJlYyOTRRU32mDMHbtxscYeHRCjCWHvZ9ogHmeblKZghZBZqDrmSrkggcay2OjjNEvzuv/8My9BTVdn2CcEM+YhcDAH11qHrbkdnJez9pHWSNWFlrDETPVU2cLe03XXdnBmB45OUbG60FgM2vUd567rT1QQrQx+OZDXqvq5uWTZdsMK2Z0wj1CbOd2fiPrP05cIa4yLo02Wkqn4yaXcpirlM98K8J+X8FiXoZ8xxZvhnr0hV8YnA7RWaoy15DpkAOBLRLdWJryOqRl2ddBhe2oZ/qqVynDj9UrfCPTgy1U+EoPO+qmqCwRaq3IiKcjxVtkk9Yc7nZ0Dc/yyyQwynawKO1UuzYAZ6hRHmc0oCN8AHkqsam4stYUbogyXkTd1gzHCpU56pGZ233JTy0LZxkJu36N8mWWLni1jDkdeZGjxFeU9T3WRX/YxlSKsAEHyR+3lOAAEXkRt6rFFPDTJp5oSyxL9FHE6r2jFcQuJDfL9iQzgTmjXbyDCQz9v7nHWgL4yM0FLg8W5HyNuU+QVNf3gSVUC17OvNqtuTuEPBqNfH3VWg9xxKS5yEvYum/uf1sFkVX1V7V7XDxtHCdKzdWqLM8anuQXbQSmyNC6nO7j8ewgFNxTVueywco2U1SGVlVlD6OEqYrOi9pnOcS1AweNvwYoNvNx7jwQb803Vo56VhWDawsqH3+hYOLSQYeY+JtaD52mYU7fkTX6
 rRJyjFA+
 m0BYC6GM5ZSUgwTxRfa2H6kFhEro2qFxL7pF/vLiX3pslWN3z6VAzKku1JvzAdsw0NSa7Y5+OD4GoEIyTtZup6t/Q4UFzaogV/w3jLISJjp7dIjFEK+m9Y5bMjerqzSCOhQ7xF2QZjEGxK6sMbtlpmoRrSnIfxAV3Ot8i+6A7LwcHiiRRyp7qOFwksGTNZqoNAZLUh05LxBeZ3ZyFg++uwJqo5tfCW/GhlKEwN4ao4pL97l1PBjM7YIBH7rtiZygBDwqMQSjZB9o2sSp1tKN0SRxLUAsuHHmD4LwOGMxgh6kxBLWgNeXoy0PE3wb9bMymt2Ylt1oHYnpfPw1BXXycpm0VDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gregory!

On 10/14/26 11:27 PM, Gregory Price (Meta) wrote:
> madvise(2) accepts a zero-length range, rejects an unaligned start, and
> reports an unmapped gap in the range with ENOMEM while still applying the
> advice to the mapped pages on either side.
> 
> Check each of these for both hints. Around the gap, only MADV_PAGEOUT has
> an effect the test can observe, so only MADV_PAGEOUT is checked for
> paging out both neighbours, after a control page shows that swap works.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

[...]

> +/*
> + * An unmapped gap in the range makes either hint fail with ENOMEM, after
> + * advising the mapped pages on both sides of the gap. Only MADV_PAGEOUT has
> + * an effect on those pages that the test can observe.
> + */
> +TEST_F(madvise, unmapped_gap_fails_after_advising)
> +{
> +	char *mapping, *control;
> +	bool swapped = false;
> +	int retry;
> +
> +	pin_to_current_cpu(_metadata);
> +
> +	/* Make sure MADV_PAGEOUT can swap at all before relying on it. */
> +	control = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	ASSERT_NE(control, MAP_FAILED);
> +	control[0] = 1;
> +	if (!pageout_until_swapped(_metadata, control, page_size,
> +				   self->pagemap_fd))
> +		SKIP(return, "MADV_PAGEOUT did not swap the page");

This test is checking for both MADV_COLD and MADV_PAGEOUT. So if we skip
here because we couldn't pageout, then we don't test for MADV_COLD
behaviour at all. Do we want it this way, or should the tests for both
of these be separate?

> +
> +	mapping = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	ASSERT_NE(mapping, MAP_FAILED);
> +	mapping[0] = 1;
> +	mapping[2 * page_size] = 1;
> +	ASSERT_EQ(munmap(mapping + page_size, page_size), 0);
> +
> +	ASSERT_EQ(madvise(mapping, 3 * page_size, MADV_COLD), -1);
> +	ASSERT_EQ(errno, ENOMEM);
> +	ASSERT_EQ(mapping[0], 1);
> +	ASSERT_EQ(mapping[2 * page_size], 1);
> +
> +	for (retry = 0; retry < PAGEOUT_RETRIES && !swapped; retry++) {
> +		ASSERT_EQ(madvise(mapping, 3 * page_size, MADV_PAGEOUT), -1);
> +		ASSERT_EQ(errno, ENOMEM);
> +		swapped = pagemap_is_swapped(self->pagemap_fd, mapping) &&
> +			  pagemap_is_swapped(self->pagemap_fd,
> +					     mapping + 2 * page_size);
> +		if (!swapped)
> +			usleep(10000);
> +	}
> +	ASSERT_TRUE(swapped)
> +		TH_LOG("MADV_PAGEOUT did not page out both sides of the gap");
> +	ASSERT_EQ(mapping[0], 1);
> +	ASSERT_EQ(mapping[2 * page_size], 1);
> +
> +	ASSERT_EQ(munmap(mapping, page_size), 0);
> +	ASSERT_EQ(munmap(mapping + 2 * page_size, page_size), 0);
> +	ASSERT_EQ(munmap(control, page_size), 0);
> +}
> +
>  /* Neither hint may fault a swapped page back in. */
>  static void check_skips_swapped_pte(struct __test_metadata *_metadata,
>  				    int pagemap_fd, int advice)


