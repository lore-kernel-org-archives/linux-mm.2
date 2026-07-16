Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB1EC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72CC96B011B; Thu, 16 Jul 2026 11:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703F96B011C; Thu, 16 Jul 2026 11:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61AC96B011D; Thu, 16 Jul 2026 11:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 359EF6B011B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:02:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 783474011A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:25:31 +0000 (UTC)
X-FDA: 84994409262.08.F410735
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5DC840007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:25:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RryvzxVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784201129;
	b=yCU6huaq3QNucHw1hv+cGNJsZTk4eMDLXURIFLK7jaUtAZdXu7ZLLnkwlgNfNOIAiZSCDI
	YyEdRYlYHLjEBZFauzCuPeyaNbK1kUu1tuf70GtoyqgzCXPZQ4MrUKTigAKWsc7mhEm/TG
	4EcZEiSgF56LXHjFMbTMdcC3xDbaaew=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RryvzxVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784201129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HY5mAISzRjDuaOGCSRr9WBJLo0EMBFc5Iz9GfShRj10=;
	b=1tU5LwXYKxYcvxUIAgfHmjAwoYmOAfG+CXv/pEMDcSSi+3W4nrel1QEwQJGi+LzjlWn+Fi
	DMNTz1FOzx1xuVWGWU18I6kDje1XgK1Av9S8e+oibx/51uxASzbdIp4IVz3Okrc1Lr3NcF
	gvc/rt+Pu3+1XCKqITPflJ9zkvsZL3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FAC46001A;
	Thu, 16 Jul 2026 11:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81E01F000E9;
	Thu, 16 Jul 2026 11:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784201129;
	bh=HY5mAISzRjDuaOGCSRr9WBJLo0EMBFc5Iz9GfShRj10=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RryvzxVodQXnTn9xCQPXMltWlXFJUlt2CgjGTaFdlp3t47wbs06NkPGko17Gn7EwB
	 inEpa3tjRZt+nKqmvwvEn4W4IOvpPi3ky4isPC0Garl3xZURW0gnMQlH18zP2x4aGL
	 yfHqHhECqm+Kcs5e2l1vfdvdfcB+7XJG1IK4HylWDb30WtB10Qrfdl0zRId2e59FaA
	 KaST5P/UgZBvneg1skrfBzPDE8nobSWcxndU+OLP9ccVo0LQ7GLJ6eav3t/6NCYslB
	 MUlLjJ0z0zYd8A0a5ossTczuz+JyrsCA143s9mbyGmMjwi1gvWhJLrWrtu1b7Smhit
	 OXfmJyJ7KgTOQ==
Message-ID: <714bdcbb-92cd-4dde-820c-e3761cbbaf07@kernel.org>
Date: Thu, 16 Jul 2026 13:25:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] selftests/mm: add PAGEMAP_SCAN test for THP PMD
 holes
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org
Cc: usama.anjum@arm.com, peterx@redhat.com, liam@infradead.org,
 ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, zenghui.yu@linux.dev,
 shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 stable@vger.kernel.org, kernel-team@meta.com
References: <20260715144234.442721-1-kirill@shutemov.name>
 <20260715144234.442721-3-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715144234.442721-3-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B5DC840007
X-Rspam-User: 
X-Stat-Signature: pyekyc33aqmu8ejpdsbxxht8r6fbew3g
X-Rspamd-Server: rspam03
X-HE-Tag: 1784201129-517827
X-HE-Meta: U2FsdGVkX1/uwY7zulFCCnLb47hf1RcuowLm0NO63/MdIMmPrhTPUTMtHjFlgjTgUDp0ou9XNiBnDZQ+fqPdn8VNVDZkkxaxoTVtaZ+abc7asf2cpiicW5xKA5RDT+hE5kZ39ezIhhJjwW8R20bnM7GADdeMkl9ITEIS45nUZ2OQU7EChfNdST40NWjqV6UKiRVBKcD2BIKtuPjz++8Yz1mxKp47tw5YseBx17WiBUQJtVYgqTvgNBUWUXdKCn1uCN5zRgJLZ1i4FSNXQGyGvmaVrO94e4zoYcWaWUvfv6ftHCwAQCd61n4LRk627vnTGaidEQ3EUHEVOms4hk73rU7ckEgUd5D2MaqoN+DimMS1CA8Wgfj0ezDED5rSJxkPQ2doN1+SNCrn1jKYZI1UjVFT4AnXpP8jNq+Q943iGH9LqOZN7zDMfkaqDkbbkmG/BXt684KMrh0M1Wx8x8gJqn5vRPLsWeiBcCrHfI2Rej7O9n7zPvGCVAL0/3+kChAEKiKg2qf07fakRk1DmmBS6VTMjsFOQE9gCmeAq+zEf0E6yT2mR5cexHe9cEuKZIilxDXbNrHc6tq87N4YYFrbHKwSARNaaOsv42RX8JwO5fyJKmIVi915ciRh+OUSo+SqJcnJU6tcZCicUKXx6EpexkI5vfDJSU8tc8gzli+ulyMRl2PDU3uAefii0W1v84YoWVvpXoyJjZ+KSFjRuGFh698ihMQUgwfPM6+T7zEWEjKxka5q7rlSNtwwC/hUhuMPb5HzMsafMR6kkIXwH96zdQAjxkUVNy3L607INkUsP8f/JSyBmvZq3QXDFvtFDj26ZQo2I89wjRYPN5qFYCYVEZZV3vtUz5iLQoksWHclF7sfkbx5JaqhaMlcj3F4DGM2t4RRM+hZ9tqR8O+5RRaxEM4Oq7HivkWYXaYrPQjEWX/Ov4wkcRnGBw1sqE+3dcwLl4m4flyevqHkPKOG61v
 0Wh1QecL
 KPJgtrstspwUZbNcgLLyy33kKa7NykwL4VkaSrwoWrU62IWqN2GT69+Njp9ebB+pOcC4+3Gyzf/1rew9ZfvSgtZ1V5vVAk6qD1dX5xUmQcHHU8+b6Wd6NECmPqwGJ6JIUNOITZNhmHCZBaXmEP6PJ8f6L+9J9QeKSiuwe2ishXcO159XYtgqNj91cdERTG+/c30Ayzqd26PLp8m2fNp3oQX65eJKqSWXNvHvcJ5gl6MjLlPd+dk24BHq4h73gnFbdtQDSzpSu+Pd29Po4YXAiUI1lhKPKXQtknKSQNfUxSvCxJraFLPLWR9uwVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +	/* Fast path: category_mask == return_mask == PAGE_IS_WRITTEN. */
> +	ret = pagemap_ioctl(mem, hpage_size, regions, ARRAY_SIZE(regions), 0, 0,
> +			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
> +	for (i = 0; ret > 0 && i < ret; i++)
> +		fast += LEN(regions[i]);
> +
> +	/* Generic path: same query expressed via category_anyof_mask. */
> +	ret = pagemap_ioctl(mem, hpage_size, regions, ARRAY_SIZE(regions), 0, 0,
> +			    0, PAGE_IS_WRITTEN, 0, PAGE_IS_WRITTEN);
> +	for (i = 0; ret > 0 && i < ret; i++)
> +		slow += LEN(regions[i]);
> +
> +	ksft_test_result(fast == npages && slow == npages,
> +			 "%s pmd-hole reported written by both paths (%ld, %ld of %d)\n",
> +			 __func__, fast, slow, npages);
> +out:
> +	wp_free(mem, hpage_size);
> +	munmap(area, 2 * hpage_size);
> +}

Sorry if I wasn't clear. I think unpopulated_thp_scan_test() can actually reuse
bits of unpopulated_scan_test().

Either by having a magical "use_thp" parameter or by factoring stuff out into a
helper.

Or am I missing an important point why that would not work or be really ugly?

-- 
Cheers,

David

