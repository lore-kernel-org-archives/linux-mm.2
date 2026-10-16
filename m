Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAEBCCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50D96B00AE; Fri, 16 Oct 2026 08:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E016D6B00AF; Fri, 16 Oct 2026 08:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EDB6B00B0; Fri, 16 Oct 2026 08:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B37546B00AE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:18:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BE8BC03E8
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:18:20 +0000 (UTC)
X-FDA: 85328391960.19.22212B2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B944140005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:18:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tvRxeJc0;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792153098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7n9MeAAf+3BTjAeo4y0ymbO6RoUkI9GPmOzvGhDCYcs=;
	b=0nOTx5npvACyQSNPj4sXGBBPxvi8IZHUx/0+ibDhp1Ti2EMqYtAu1Qud2CH54EVBW8ntts
	No3hBsIz6+F/zOJgDEVwDHoPxFX1gEhDm+5THM3cQC/Hak0uvsQoZad7gzsyhxZe4Lo6Gl
	iMTnK/onYhVLficZvaAqRl6ndGY/dTY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tvRxeJc0;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792153098;
	b=3UQ3VdpCsJ6PZspKZsVd0JdtwhUiXSd8iqIAMuMcHYY0lFa5zgbdmWWgv5DwhhyFNvubT0
	Nk/aayXH/wLoJEWVsPGKlfDStOeOEMRbknwm9S4rFFNU7ySALDfkK67NX9qGWkcS111uOF
	JP3R8js3lSWgng+9rOG5A4Y973t2SeY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23CF314BF;
	Fri, 16 Oct 2026 05:18:14 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE0253F871;
	Fri, 16 Oct 2026 05:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792153097; bh=ZPRm3vIADOJpy/rrCOlBV/kbvkGxmDZcH+9P05dhEgw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tvRxeJc0WPXmr8vAecRZi/jQXP16d5zuGeWuWmsGKUx0tmCcCpOMKvCLZwuhFCV4f
	 M2SqNl4WkSo5J2cxXuNBoGVNEvPpTbGwcwbtMDQmrUAZDqmeEW+6naA3O6YRfODPVa
	 VkJCfMXnQiCAd2zXgAzdOSpGSmQb/PkyqSxcDU+0=
Message-ID: <cba2a01d-630c-42d3-b6e4-b498f10c4b45@arm.com>
Date: Fri, 16 Oct 2026 17:48:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] selftests/mm: check MADV_PAGEOUT file permissions
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-8-gourry@gourry.net>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261014175756.2035176-8-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B944140005
X-Rspam-User: 
X-Stat-Signature: frxtx7crn8tcos1bkxgt3apwewatnajr
X-HE-Tag: 1792153098-800256
X-HE-Meta: U2FsdGVkX18Dx/GN5HGqBOVSfhyHIWTz8cdiky8ci0GjFaKUwQWvjsiKKFWJyT4I3pgCZ5LBIPydlFDGWhzVY0RSNMYrrOqw/f2cd41IWejPkpVObYVQYojhz6eAM8ig/qx+iLSJEMAlVkv0TFZgTsjUrb1sOdpXMyq2mowPr7YpN0IvQCWacnY7gD9SIZl91lclgZxBWpf7+rC31EJjNfiRQGrgK80kHnYtmFGQf98XnbLBx668aWQLxnbJAMNEdxRLPhVMcRMFvmfDimDoP1rpIafp9n8CTo7JUt1G7f4PpRSVn9Mgo2dZbDMSaruE9tu7xeHG9btd8CJxfg/46WzvetDb/Dkogr4k/Ahrol4fBWPYWkbVcBFVhXVJXlgOaoHNvYe7L8M9FkFIJ+mlN548ixJD32SiktbwbqwgXqpRCz5R5iEqtZ76/1W1DNR7vaobEDR6YRRxfnN6+/zbqaq5kc26F+7/rMn+GYUDdDB4bf4Shk3Yp3MwtdYxl8SqBSrJZeNY+NQrg27QsoqK92I5uLkqLk8tb8EnaXGPI22nQ03X/qCoMAQszBZ5KYc1YbYizSLkt9SitlH8tTIOq4LZ9bXLsxICZErrBv299nhcSDTt2sU4b0rl+MlO7DgOs3yAn46cRNdsnBQvb32HwMnhDGsDkbxK29P8WarE5DiyrkDd9HwRGuOV3N9RSd4xddk+sc2pFTZpxqAbrKvP/9FDDJfgKsFniBzQuYrxpc9zxgH+V3PEdwft0fs8wm4h3PcUB5e8psO6+QsX4FTmXM7hPSmrwK4aSvz4Axtow8oYZ2SVpxi0DfsEiV5YgnTD8FSpYE3CySwDn7JkFjni1v1HwsfS1YgpNKmL9/BDryrKhe3U6bFCWYemhqu6POku+yL256NLyQikyY2LUpyII1jLeOMlkb+4ZbgM48hQiZFaem9F4x1IAELxo1pdlqoquqDH6H8/kiDOdFO2lvk
 /oGtM/Kz
 hfWi/wFRz8KCStYOo5Y22lHokQ/mXlbCbwZEHxjw69UP2QGdrOrKpM6FOKw5aSLlX0o3oNu3jlzhsM5HVjhLP+W9JZSmzz4YVjcYt+QmIst+dIhBMM25dU6ei/vk4qnxvdUMhrR71avQuvWJ4lfV2fbe3o2vC82s4+QXCpxEA22JbVFLHrJd5MyCu4qyG18mR8GuBW2bun8vpiS6VO67w0HDiB+LVw4+zCyypKAGznciXg63rIlqZMS424hNGqbtPauSA5wjIJkTZJ6A3yxqpdTIfW17l9WdyFb6LRxL2Uc8o5yIh3dR92pg4To03AfQNSWHFZ7DlfmiDotMGmtIPmQtB0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gregory!

On 10/14/26 11:27 PM, Gregory Price (Meta) wrote:
> MADV_PAGEOUT only pages out file pages for a caller that owns the file or
> could open it for writing, per can_do_file_pageout(). Any other caller
> gets nothing from a shared file mapping, and only the anonymous COW pages
> from a private one.
> 
> Check that the owner of a read-only file can evict a clean page of it,
> once a writable file page shows that file pages can be paged out at all.
> That test runs as an unprivileged owner even when started as root, so
> that capabilities cannot stand in for ownership.
> 
> Also check that an unauthorized caller leaves a shared file page resident,
> and that it pages out the COW page of a private mapping but not the file
> page next to it. These need root to change credentials, and skip if that
> fails.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

[...]
>  
> +/*
> + * The owner of a file may page out its clean page-cache pages. Run as an
> + * unprivileged owner, so that capabilities cannot stand in for ownership.
> + */
> +TEST_F(madvise, pageout_evicts_owned_file_page)
> +{
> +	char *mapping, *control;
> +
> +	if (!geteuid() && !drop_privileges())
> +		SKIP(return, "could not drop privileges");
> +	pin_to_current_cpu(_metadata);

Is there a reason why we are pinning to the current CPU here and not in
the next two tests?

IIUC (please let me know if I am wrong here), without pinning, say in
the test pageout_private_file_reclaims_only_cow:

[...]

> + * A caller that neither owns nor may write a file may page out the anonymous
> + * COW pages of a private mapping of it, but must leave the file pages
> + * resident.
> + */
> +TEST_F(madvise, pageout_private_file_reclaims_only_cow)
> +{
> +	char *mapping;
> +	bool swapped;
> +
> +	if (geteuid())
> +		SKIP(return, "requires root to change credentials");
> +	mapping = map_temp_file(_metadata, 2 * page_size, MAP_PRIVATE,
> +				0400);
> +	if (!drop_privileges())
> +		SKIP(return, "could not drop privileges");
> +
> +	ASSERT_EQ(mapping[0], 0);
> +	ASSERT_EQ(mapping[page_size], 0);
> +	mapping[0] = 1;

If both pages are on CPU 1's per CPU LRU batch here and then hte task
migrates to CPU 2 here

> +
> +	ASSERT_EQ(madvise(mapping, 2 * page_size, MADV_PAGEOUT), 0);

Then this can cause lru_add_drain() on CPU 2, and therefore both pages
do not reach the main LRU list. Thus they won't be reclaimed and the
test can skip here since the CoW page wasn't swapped.

> +	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd,
> +					 mapping + page_size));
> +	swapped = pagemap_is_swapped(self->pagemap_fd, mapping);
> +	ASSERT_EQ(mapping[0], 1);
> +	ASSERT_EQ(mapping[page_size], 0);
> +	if (!swapped)
> +		SKIP(return, "MADV_PAGEOUT did not swap the COW page");

Also, here we skip if we couldn't swap out the CoW page. Won't it make
more sense to check with pageout_until_swapped() first if pages can be
skipped, and then fail here if the CoW page wasn't skipped after all the
retries, similar to how some other tests implement it?

> +
> +	ASSERT_EQ(munmap(mapping, 2 * page_size), 0);
> +}
> +
>  TEST_HARNESS_MAIN


