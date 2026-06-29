Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B10FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7696B0005; Mon, 29 Jun 2026 08:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369F46B0088; Mon, 29 Jun 2026 08:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257426B008A; Mon, 29 Jun 2026 08:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF2126B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:00:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E03F1A069D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:00:01 +0000 (UTC)
X-FDA: 84932806602.25.4AB9E97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C0DB9160015
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:59:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FsJJBJuD;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734399;
	b=bb9jOmOOLCgdRi88S93HbdsPwGeCGBK+dY1CCgaAX2cx/BeHpMEz5JpWPW47V0KFx4B//V
	X4+ZtNOWH/SarC9xC5a8MMVdXMZn4r02rZmwnmEBQMC1E2+vUq3zW1QwiMBfV6ZX1F6pB+
	txeI16FkTTLJfW8GraY4ORRECzIUGPo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujgugl1pt5BJM6l26prd/YLdG0rSIvGNKWTUx3IjBCM=;
	b=UjyTCiLMkFTQG5fc1sAdTGGIRDwUVumlW4xEUjpfMvrxZ7QpXf/c1PnZu2ecQ2X7Lxi1iZ
	tojbf04yLvmWBlrrmoEF7eaRK1VgygCldurkB3Dt9jjG0/bpQTMkk5DCPJ2n7YvK8qdPE+
	+M66FxxxCpO25fj9rlSfc3aXb2XQR6o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FsJJBJuD;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C19A60008;
	Mon, 29 Jun 2026 11:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A204E1F000E9;
	Mon, 29 Jun 2026 11:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782734399;
	bh=ujgugl1pt5BJM6l26prd/YLdG0rSIvGNKWTUx3IjBCM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FsJJBJuDRYhGCHC4PKCT2Ih/71z9UrHRUPBAkVDb7f6w9OjT8pF/iDZe6sLytuMsT
	 3Wk+A4CBuvxME9bNfYX6Fz3IMfBYkWOXQIFwueYC6Z/tCNttNcsPu6Gk4bBk/l4CbA
	 assOY03evTh1luwa44FLGTIMg0dxRxofh74MmTpOltH2Fv/7I9J2eqi6Ktz2rN+fas
	 D9rCYKz/ygUQc4hLE6E7zs8j55eURKVZBS5eMwV41ar1cTencFlitAmgp6CLud5fax
	 fsFfvjSX+wUMERChuGZEPULOymNIsEh47x23ZweF4hd3Hoi8whOCG0+K5BHPOdSoG9
	 x1JPsK37pU2LQ==
Message-ID: <450d77b5-9fbe-423a-82e7-1a178cb4d3cc@kernel.org>
Date: Mon, 29 Jun 2026 13:59:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/3] ksm: add mremap selftests for ksm_rmap_walk
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
References: <20260629174424441L3NDvwfAQv74N4ZLs1PRA@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629174424441L3NDvwfAQv74N4ZLs1PRA@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0DB9160015
X-Rspam-User: 
X-Stat-Signature: 4xjktr9ax7fbcqhgd6dj4utaesc1mjoz
X-HE-Tag: 1782734399-950389
X-HE-Meta: U2FsdGVkX1/BBTmeelDwq2W/N+JlFUjvAnzTk1IRD81wsxD75TmVx9p8dDdyV5r326grLZwn4s66aVO70m5zeHbxbm/ZfTBQD3afdqPu5YjY9OaYdrygy0W5nEwPLZCX99+VlKOS0NMWGOk3pnLhERM3n0Fy9LIBF2otVZTEF8odiI7gCg8IN79Hz5Vgi/JxdzXviI+fH1jxWj1Mra0zXs5U49TKgv2ueYUL9ttXmVpCeFxVgJfH+9YivKCHFCC8nQXNNJIQz8L4FGjAZR4fv1rzyF0wIpb/PGwwanW9J/5goSmz1j5pAsjglRwPuGeiYo/JCKv5ytmGzvXIXUrJVy6XpyiQVPVVfYM0/tUD77iSn4DPQSPk7Bwx5z+JBM2+WfSr7MRDopJNyYPjvHlZGX3NNHgGQr9i0+z0Ezn1urSFnFwRdh4zlD/endqTLOqLVyhj17zWyUOYfxb1t/ynSlZj8769ZafeP4YZQyx4g5rUzzIPC3KIZBrS7ceW9bLtXbBU+KrlmCT+gNUbqcqIac1AmIBcC4sp0n+kCXTXZButCWDQL2pVU9QsfD9ZhZheGvTJngNhAio4rHo4yuQhoxi0GFzGGLo2c4mosoOw+k2BiJ6kBAk1cjUalPssDq2Q3mJyjr1/97EjibaovTY0oxx7L5WWUQt7qWuZxCmuaYYj1SbFCFqyMbPpSA13RWzoTBaetf3DZCUySOR/LggO6aMa/m9poSkaeXxsUOWCtxG7kcsjmnhLoWj4mvXSbTOuYPo2NIiQuYYg/60iY5eZesnohDep2R+WQQMl3MM/gX7WVauPp1DrjKZNQ+af8ACLNOHZQ8gxtfsINXMS72K1qH6RSXAMg75aFk/x8CBT8wKlR59VjNfjYOVTSIENWRfk/1PDn12PesCbfs/2DO4cAxUC8Q4WXagipQxplPvBdTHtjLnNQ/xXIQJnUae5W28ue+C/UUorpXULr7CzcLn
 4zycAF80
 QRwMEtRW8YOHZOfu1JKelEBIe/6E4CKIPU+F/eKQIuiLc56162C1fAEtJ8y+1uyJqce53Gwj/s83+iRs9ifl4Z7kM5oOJCKXPA+SXvtPGKNTHMMEy4c9K7npCvDoTb1ZGB+0ZRPzKgzsQ5arzATyWX2+L9O3M4keoSQQ4ReHAZBhyHk3sWB62RlqVO603mS5BvQNjXsh6iTbSm9Vjz2j9gBs7qpibgSPJ0DrQVEA7lJVWL0Hs9VlGO6zOGc4COAEPNzezMgsf/VH9sZ2k2HvfcVOPDghzqufH6cX0u7ieN/F2X+Ijv/Ym2entI1r17WaXq7FikD9Pgw5NgpFYY49DjeG56htHbFiIehihxeFLR1IJdoOySXw/MaxISK6v9ZigFL7r+RPysT3fNiK0DU4ZLDciVBykXmDo2joA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 11:44, xu.xin16@zte.com.cn wrote:
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
>  tools/testing/selftests/mm/rmap.c | 107 ++++++++++++++++++++++++++++++
>  1 file changed, 107 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
> index 53f2058b0ef2..ad731bdff4fa 100644
> --- a/tools/testing/selftests/mm/rmap.c
> +++ b/tools/testing/selftests/mm/rmap.c
> @@ -430,4 +430,111 @@ TEST_F(migrate, ksm)
>  	propagate_children(_metadata, data);
>  }
> 
> +/*
> + * Check if All PFNs of the region are the same to the input pfn.
> + *
> + * @pagemap_fd: file descriptor of /proc/pid/pagemap.
> + * @region: the start address of the associated region.
> + * @nr_pages: the number of pages that the region contains.
> + * @pfn: the referenced PFN.
> + */
> +static bool merged_to_pfn(int pagemap_fd, void *region, int nr_pages,
> +		unsigned long pfn)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++)
> +		if (pagemap_get_pfn(pagemap_fd, region + i * getpagesize()) != pfn)
> +			return false;
> +
> +	return true;
> +}
> +
> +static int mremap_merge_and_migrate(struct global_data *data)
> +{
> +	int ret, pagemap_fd;
> +	void *old_region;
> +	void *new_region;
> +	int nr_pages = 32;
> +	unsigned long old_pfn;
> +
> +	/* Allocate exactly pages for the test */
> +	data->mapsize = nr_pages * getpagesize();
> +	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
> +			    MAP_PRIVATE | MAP_ANON, -1, 0);
> +	if (data->region == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap failed");
> +	memset(data->region, 0x77, data->mapsize);
> +
> +	/*
> +	 * Mremap the second half region to the first half location (FIXED).
> +	 */
> +	old_region = data->region;
> +	new_region = mremap(old_region + data->mapsize / 2, data->mapsize / 2,
> +			    data->mapsize / 2, MREMAP_MAYMOVE | MREMAP_FIXED,
> +			    old_region);
> +	if (new_region == MAP_FAILED) {
> +		ksft_print_msg("mremap failed: %s\n", strerror(errno));
> +		return FAIL_ON_CHECK;
> +	}
> +	data->region = new_region;
> +	data->mapsize /= 2;
> +
> +	/* madvise MADV_MERGABLE and merge these pages */
> +	madvise(data->region, data->mapsize, MADV_MERGEABLE);
> +	if (ksm_start() < 0)
> +		return FAIL_ON_WORK;
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);

I think there are various improvements and simplifications we can perform. In particular,
 I don't think we need the errors messages or use data-> members.

What about the following simplification, to move this over the finishing line? (untested)

There is the low chance of page compaction migrating the page while we check for it. Not sure 
if we should handle it (but it would involve retrying on PFN mismatch).


diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 53f2058b0ef2b..1b7ab46a520cf 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,68 @@ TEST_F(migrate, ksm)
 	propagate_children(_metadata, data);
 }
 
+static bool range_maps_pfn(int pagemap_fd, void *region, int nr_pages,
+		unsigned long pfn)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		if (pagemap_get_pfn(pagemap_fd, region + i * getpagesize()) != pfn)
+			return false;
+	return true;
+}
+
+TEST_F(migrate, ksm_and_mremap)
+{
+	unsigned long old_pfn, new_pfn;
+	void *region, *mremap_region;
+	const int nr_pages = 16;
+	size_t mmap_size;
+	int pagemap_fd;
+
+	/* Skip if KSM is not available */
+	if (ksm_stop() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\" failed");
+	if (ksm_get_full_scans() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\" failed");
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		SKIP(return, "opening pagemap failed");
+
+	/* Allocate and populate twice the anon pages initially. */
+	mmap_size = 2 * nr_pages * getpagesize();
+	region = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANON, -1, 0);
+	ASSERT_NE(region, MAP_FAILED);
+	memset(region, 0x77, mmap_size);
+
+	/* mremap the second half over the first half, to stress rmap handling */
+	mmap_size /= 2;
+	mremap_region = mremap(region + mmap_size, mmap_size, mmap_size,
+			       MREMAP_MAYMOVE | MREMAP_FIXED, region);
+	ASSERT_EQ(mremap_region, region);
+
+	/* Merge all pages into a single KSM page. */
+	madvise(region, mmap_size, MADV_MERGEABLE);
+	ASSERT_EQ(ksm_start(), 0);
+
+	/* The whole range should map the same KSM page. */
+	old_pfn = pagemap_get_pfn(pagemap_fd, region);
+	if (old_pfn == -1ul)
+		SKIP(return, "Obtaining PFN failed");
+	ASSERT_TRUE(range_maps_pfn(pagemap_fd, region, nr_pages, old_pfn));
+
+	/*
+	 * Migrate the KSM page; the whole range should map the new (migrated)
+	 * KSM page.
+	 */
+	ASSERT_EQ(try_to_move_page(region), 0);
+	new_pfn = pagemap_get_pfn(pagemap_fd, region);
+	if (new_pfn == -1ul)
+		SKIP(return, "Obtaining PFN failed");
+	ASSERT_NE(new_pfn, old_pfn);
+	ASSERT_TRUE(range_maps_pfn(pagemap_fd, region, nr_pages, new_pfn));
+}
+
 TEST_HARNESS_MAIN
-- 
2.43.0

-- 
Cheers,

David

