Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E9CC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B4E6B009F; Mon,  3 Aug 2026 09:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3630D6B00A0; Mon,  3 Aug 2026 09:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0306B00A1; Mon,  3 Aug 2026 09:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3AAE6B009F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:47:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1856AA04DE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:47 +0000 (UTC)
X-FDA: 85059362934.10.2C61741
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7E79220008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMWhxAW+;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785747645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1fW7CNa0Rta/NRgITqdOPZuNkGF26w1VzOGgOD6xvg=;
	b=hC39APJZI6IXfXng6Wh+9C/WZ+Rm2R5xxUBxFamI6sYWKGbxJuTBrgPprYcEN1NJyg8Kn3
	XeYCFvXYvPfdSCKCFR941TDXM+yhri58bT3UzhAvoTgFcKc8f6UOdUyTtY1eHsPfZmR942
	A7qxVehJ824UEtd464VKUpjOsjoI8Go=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785747645;
	b=xSXYKUya4qp1c3x/ky7TNroi4r2WKz7jlBDSX7qzCMg1jzfqmnQCWnHjBiTmkIJPwSthU9
	e0KCO/Kj7WVEASKT0Tz4crgiviYTVoHtEuMT8PDGNSUx4eYL/b0cRhUh8xlLLNIopN6Qlu
	JbLsA9f7QyA4xNZl0jW7LPj/1EH3hso=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMWhxAW+;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01BE560A5D;
	Mon,  3 Aug 2026 09:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11A41F000E9;
	Mon,  3 Aug 2026 09:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785747644;
	bh=S1fW7CNa0Rta/NRgITqdOPZuNkGF26w1VzOGgOD6xvg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=CMWhxAW+ua9CuWQbkSA2KkHuDlUsptPy/9hThctxswMbNkp4WkJ3SgzGMluxhWuuz
	 gvqw9uqlqwoDocMV9/ZhLhhjaTDwSW/2ThQuH+xdUHZZtlzHNtDjRDg4SccCXq9cx0
	 rG0otOr6yxz/vpI4hPcpW9SfKJOnF43QQCi1DQ0ITJz2FK5n24KdalAEUaiA4K0FFr
	 uW+A4x9QpLlykXKz9VhfNlFJtxfuBqT25+GjZXSefWpEm6Oufga3zuURWhneY+lPuT
	 SHl3H/k8dqBX6Ld7IG/i2sQlK7eBrOfD10EySgTjWMD9TsL4FSNtVHVQVlwf2m1OSz
	 bpFmPnvKT0ypQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 6/6] selftests/mm: add a GUP selftest
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260730140825.238130-7-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
 <20260730140825.238130-7-sarthak.sharma@arm.com>
Date: Mon, 03 Aug 2026 12:00:01 +0300
Message-Id: <178574760162.1561566.17560239060453947110.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Stat-Signature: peozjuwjp3f3rk5jcfyaydanszxqm6wb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E79220008
X-HE-Tag: 1785747645-204723
X-HE-Meta: U2FsdGVkX1/nVZoIqPyYRxI//V48mUBxTEQToKYShI9Nci8/Wg5vRK4fSRfBpfft2jsfojSSKLFn6DoPddJpJ0OCc6KhkCR6WlADVK1X8XpxmkzdHJmeO/NuOPkaE//6cqv3+pxoKwUtMb7YR2NOYq1z+NYcIjwCM8M2BymvUFH/SerqqSu1apuzlZVIPSjkSoob1aKy9BZCJy5kvpFWFXnK2RlJxsfh2SP33skCjY1KwvDUTr9xASR8/m3iKSOqZKQiGqxnjfLBmxQhNvKbp2qvOBstPqHJ+iyKyeGOseIbhiXxjj/Nk7CK8VAL5W6r/6I756wEFwvr6ZsxwJW9VO/NSYtrnjkAs/OXY4ghMoE+J3svP3C+DeDZDSoyC1MAnI2qfuJnsfFGpI9PbnD6b7R7Hv9cdchiuRYpdHYeccN19wx2VGH6ddP1CxJXPBcrO9GQpRLipa1P2rSaWS6Dc10r+Ebl3H0YcNM2HUBPWFjLxgjP720GS9Ews4gxBLHbXFMqg+oT+GBFqmxaX/wR5uOdMIZYTwuzCtKoWrwNV0TPHVzDRf8YD4suulSrIuk2tOb7PYRB6CUZ6wALEi7jZLPGMCsdEueZfGB7MYSKRWKfLtl/+Tc+61UqhW/yf4DF650KeWxoU0u/qBa55AS+O7FfCPZ2AD4hFBICNfnQVH0j13MTqPG1buTygZIjDAHfv2GWjSmKBitjxeYnHJKY/2rchrP5PUKtEv4E3f00QEu+pFUcO5iO2rFFx2h4Q8ajQnTWNgPu8axKgvNmYBHwYK1yLyS4uInwc06kRn5I7piop3rer+umThP/eDws5e8kqu9MiqRJ2n+/t5Rj1TQfPDtiPpnYgyF83++FtAvEyAm9TaVyAIFWB9tA3Lvdq7B8OU0vovdruJgDQI7LgfDqBqIgOMu0j09++2a3rlR5YBG/RxggLod/clYaqWER4QDKvjplZy5rlb3FvvbkDxr
 WAxOsGBW
 vjYd3oyax0c7oBfoHDKOYZpATdKNRAnqYRfjtUdfnT89TipmdOqoZEoi1UCXgzql3QKfPxHifE0AsLi50MKZykEXDKcsMrZn9W3WVpuzL0rWXQyhLoVj0nJ9gugjdLUMuyFj+YZl72dBO2JpzK0ZwG5abZs6Yv73zx/PHHVbcuVjiczB1A+iRjpJvuAtxP61q5pWiMfzWyWA42piiGo5nXtZxQMwuaQdQzXbnIDPTFlkbxCuHgCgyBjltqoxRQRCivUaXx9Z07q1nLzCW1agrUWBxAXTRE7BP+bbq5/o7euzkuB0XUPq/W5zgDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add a new GUP selftest which uses kselftest_harness.h. Cover
> 12 mapping configurations: THP enabled, THP disabled and
> HugeTLB, each across private/shared mappings and with/without
> FOLL_WRITE. Run 7 testcases for every variant: get_user_pages,
> get_user_pages_fast, pin_user_pages, pin_user_pages_fast,
> pin_user_pages_longterm, and DUMP_USER_PAGES_TEST using both
> get and pin.
> 
> Sweep four nr_pages_per_call values for each test: 1, 512, 123 and
> all pages. This preserves the coverage previously provided by
> run_gup_matrix(): 12 mapping combinations x 5 GUP/PUP operations x 4
> batch sizes, for 240 ioctl calls. The two dump modes add another 96
> calls.
> 
> Preserve the previous sparse dump coverage with a standalone test for
> pages 0, 19 and 0x1000. In total the selftest reports 85 TAP
> cases and issues 337 ioctls.
> 
> Add the new gup binary to the selftests/mm build, .gitignore,
> run_vmtests.sh and MAINTAINERS. Update
> Documentation/core-api/pin_user_pages.rst for the new test.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>
> +
> +FIXTURE_SETUP(gup_test)
> +{
> +	int mmap_flags = MAP_PRIVATE;
> +	int zero_fd;
> +	char *p;
> +
> +	/* zero_fd has to be >= 0. Already checked in main() */
> +	zero_fd = open("/dev/zero", O_RDWR);
> +	ASSERT_GE(zero_fd, 0);
> +
> +	/* gup_fd has to be >= 0. Already checked in main() */
> +	self->gup_fd = open(GUP_TEST_FILE, O_RDWR);
> +	ASSERT_GE(self->gup_fd, 0);
> +
> +	self->size = variant->hugetlb ? 256 * MB : 128 * MB;

I'd derive the hugetbl variant size from the size of a huge page and
predefined number of huge pages.

> +
> +	if (variant->hugetlb) {
> +		unsigned long hp_size = default_huge_page_size();
> +
> +		if (!hp_size) {
> +			close(zero_fd);
> +			close(self->gup_fd);

You can move hugetlb setup after opening those and save the headache of
closing them.

And in any rate prefer 

	goto err_do_cleanup

to
	if (something_failed) {
		cleanup1();
		cleanup2();
	}

	if (something_else_failed) {
		cleanup1();
		cleanup2();
		cleanup3();
	}

> +			SKIP(return, "HugeTLB not available\n");
> +		}
> +
> +		self->size = (self->size + hp_size - 1) & ~(hp_size - 1);
> +		if (!hugetlb_setup_default(self->size / hp_size)) {
> +			hugetlb_restore_settings();

No need to call restore() here.

Also, if you use a constant number of huge pages you can just add
HUGETLB_SETUP_DEFAULT_PAGES(NR_HUGE_PAGES) somewhere in the begining and
you won't need to setup and teardown hugetlb explicitly for every
hugetlb test.


> +			close(zero_fd);
> +			close(self->gup_fd);
> +			SKIP(return, "Not enough huge pages\n");
> +		}
> +
> +		mmap_flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
> +	}
> +
> +	if (variant->shared)
> +		mmap_flags = (mmap_flags & ~MAP_PRIVATE) | MAP_SHARED;
> +
> +	self->addr = mmap(NULL, self->size, PROT_READ | PROT_WRITE,
> +			  mmap_flags, zero_fd, 0);
> +
> +	ASSERT_NE(self->addr, MAP_FAILED) {
> +		int err = errno;
> +
> +		close(zero_fd);
> +		close(self->gup_fd);
> +		if (variant->hugetlb)
> +			hugetlb_restore_settings();
> +		TH_LOG("mmap failed: %s", strerror(err));
> +	}
> +	close(zero_fd);
> +
> +	if (variant->thp)
> +		madvise(self->addr, self->size, MADV_HUGEPAGE);
> +	else if (!variant->hugetlb)
> +		madvise(self->addr, self->size, MADV_NOHUGEPAGE);
> +
> +	for (p = self->addr; (unsigned long)p < (unsigned long)self->addr
> +			+ self->size; p += psize())
> +		p[0] = 0;
> +}
> +
> +FIXTURE_TEARDOWN(gup_test)
> +{
> +	munmap(self->addr, self->size);
> +	close(self->gup_fd);
> +
> +	if (variant->hugetlb)
> +		hugetlb_restore_settings();
> +}
> +
> +static void run_gup_cmd(struct __test_metadata *_metadata,
> +			 FIXTURE_DATA(gup_test) *self,
> +			 const FIXTURE_VARIANT(gup_test) *variant,
> +			 unsigned long command,
> +			 unsigned int test_flags,
> +			 unsigned int which_page)
> +{
> +	int i;
> +
> +	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
> +		struct gup_test gup = {
> +			.addr = (unsigned long)self->addr,
> +			.size = self->size,
> +			.nr_pages_per_call = nr_pages_list[i] < 0 ?
> +				self->size / psize() : nr_pages_list[i],
> +			.test_flags = test_flags,
> +		};
> +
> +		if (variant->write)
> +			gup.gup_flags |= FOLL_WRITE;
> +
> +		gup.which_pages[0] = which_page;

Can't these to go to the static initialization?

-- 
Sincerely yours,
Mike.


