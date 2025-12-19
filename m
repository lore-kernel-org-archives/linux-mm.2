Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5849D78780
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48B7F6B008A; Fri, 19 Dec 2025 09:15:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44ED86B008C; Fri, 19 Dec 2025 09:15:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38EFB6B0092; Fri, 19 Dec 2025 09:15:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24F856B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:15:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D247C57ABB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:15:02 +0000 (UTC)
X-FDA: 84236417244.29.B45A8B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA8A7140013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:15:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O717isD1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766153701; a=rsa-sha256;
	cv=none;
	b=bowXVtPipQ3bTvFLHZhFWTUVUhBivlT3tmkJYvCTcKJHPKDhf04N5ROaTQylaKw2hI51di
	sJEejmDO/kxawnr7u8QPUck1yIj+AIeFQku4j1UI7wi6FB6EjpuO9WMpzv9+iz9B8xQm0T
	L1mpBTulUnynqmw5LkcRbumaI8qfF44=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O717isD1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766153701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ3wUbd728+Gok3VxLFpSx348UrfV5Dsy9YisZ0vT2w=;
	b=cmYXTS2qsn8VDfzbwiokRdPQU2m6PyNSmxSoGYD35W7z9wrjnZjm0MInjkrKLJaDegnsnE
	ASrFRrUZ2bH6kgLxwoj31G34Ea+UaowAGfN2h5rIlSyixynKPX5mcu9ECDqFxco/2LEa3O
	CIptZyYcm9MZgZGnIA0VSE3j5qKv5Y4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0A4643874;
	Fri, 19 Dec 2025 14:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405DDC4CEF1;
	Fri, 19 Dec 2025 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766153699;
	bh=h9gatBXLPknkA9XB/kDpWVDHKRf+rqWFuU1zgf9gItM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O717isD1mHBm5W4zYOFNoyxyRF7E9NbvNqjbXcL4AhlmDAOPyLQ33+Kr9Lv7uuq14
	 ohp1+/WYbEhEL/CST8pbWNnvW1sAS2iIOYrj8+0JrEqqvx3mvCjjI/LgdiYcd93cL6
	 HCAERNkf2egSFz2ikTO1H4RjquN2pCH+Ajbdo0teEkX5FcAq1oLo+JGYJGghTlxmjQ
	 5XqtpYvGZgHHWjpDNXYlBjZubxrTfFTk59FwbQz6CINzp98bvVwDsuCxsSD9bDXoaa
	 ItcakAYKMnhUHmAucPOMJcoLlPH8n1AtCbGfuHdvDf/Gqm1zCOuRrh8nrgPdf8np1P
	 yE+NKtFJE/Bzw==
Message-ID: <3f3e2e99-cf87-4498-93a7-700ecb42a2a9@kernel.org>
Date: Fri, 19 Dec 2025 15:14:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/memremap: fix spurious large folio warning for
 FS-DAX
To: John Groves <John@Groves.net>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: John Groves <jgroves@micron.com>, "Darrick J . Wong" <djwong@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>, Gregory Price <gourry@gourry.net>,
 Balbir Singh <bsingharora@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Aravind Ramesh <arramesh@micron.com>,
 Ajay Joshi <ajayjoshi@micron.com>
References: <20251219123717.39330-1-john@groves.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251219123717.39330-1-john@groves.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EA8A7140013
X-Rspamd-Server: rspam03
X-Stat-Signature: zm1czkjqbroeid48gsnn7q113mfyhm34
X-Rspam-User: 
X-HE-Tag: 1766153700-684838
X-HE-Meta: U2FsdGVkX1/a5giyiLLSB0rTT20lbr4pUG4fZeSmTdniCeXY5pcBs8kCiWQPvKA4/+wXOjQn+RgbhPScEas4pQKO1AwuTK5lJuQO8wsHG9cKcbbe7PZjGI1cwaz+saD8o/LshiI8sQ4xezIYhBS73NjEgryL9ZmaLOGlv82CUGXeQrs4aGOzRvkGZdZQ7V34k9/+9A4Ow7V7wFNa4qSRfwavM9cCOZBx5VElf06Uj1F8mGoaDBTjvlpqDvrasAKesiq43rNwvcItyb0Fotf2y90lJtnW/xBeHnEnD64/+2uuEO06KCOdfcDvENGzuvd2qGSTtEcxBPcyJEQiK5RILXqb8T31cIMNDYtntTIBno3dtlVY+flwHCwN857bOs2nIp5ulnmgMvO50hxtJYXhdqYVzm7uRurXGpWgkTlNML9/LLz0N8RczKofTRkWmrExh7cBboO+yF1XHD6PYKTQjYjuNe7V/tEUfr4n6HEqrJCRk4abGTPiB195jkxUc4ZlBDaasRRj04lyIhCjaM1n3bwYRZqcEx46BeZ48uOLWwge584lv8dWvBqKGp7DhcyRxzSNwmpI9owyXuxOdoNE7AtO0Awmpybk0y6jt/RgUt95Zs9tdzmzQ4e8MKJy/8GMAE6DMq8MyH9om5k1RQFceciH/fyW+AaxOJvrnGdqGmJp5jh1nylolnBwwSr85KvLYxDoApWetX2cNTRZY3ptPBfetMiaLDBAc+Fztdr7zQ7GXQ6Z2Ajq6uqsnyia9C6V4HpKljSgrl+Ldre7yJ69J/5Ub7AsUldL9eOqKW4OMpuxXLTWsv5lrtnmtS2CaP6r9p/ZCk7kjAJYjpFd84bQuhmvgOFBlgI/gteo+FOGehnHF5Vm1mZx4oR5qf+yfGKAx7VIDzcvJrVzI0drjiyOt0JBbeSZDkq95/h2SQZ5VlEFMhKCMvUp5MJBEIX2SxTEhvS/LmpSuwiFw+HGT31
 Q1UKkqtW
 gNfDXGBxC7x/fQOHVsMbEeH+nnytN5i4PszbpYaM8XzkqY9iG2lvH85E6NFVZHlvNCC57gzemKCQGU2TuEVRdaw8QV36LjE/+aDwY7CLY8OLrZx4QyeT3Bkb+I1mmjPxdpZ/2mDOpmodGZNDwWN5HMNAB+0lfH9Y9T5zv112dV2zm3YcCVjmQtNQwCGe1l0J9l/Zf2j1qswOve+t9o7P7e5TCI0MqdV6y2dighbhWLScdwli6daxivmLNQeiga0HUm+uDUvceWIJSQsoBoxzxZ5LfakefjrnwK2pNxYiyxzo0XoU3TPVmJ3wcgqCRXRmoT1tZ3q6ZhyBWAd8prolwOaynHXNEd17NItJ/URSPBi5yM70=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 13:37, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> This patch addresses a warning that I discovered while working on famfs,
> which is an fs-dax file system that virtually always does PMD faults
> (next famfs patch series coming after the holidays).
> 
> However, XFS also does PMD faults in fs-dax mode, and it also triggers
> the warning. It takes some effort to get XFS to do a PMD fault, but
> instructions to reproduce it are below.
> 
> The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
> free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
> when PMD (2MB) mappings are used.
> 
> FS-DAX legitimately creates large file-backed folios when handling PMD
> faults. This is a core feature of FS-DAX that provides significant
> performance benefits by mapping 2MB regions directly to persistent
> memory. When these mappings are unmapped, the large folios are freed
> through free_zone_device_folio(), which triggers the spurious warning.
> 
> The warning was introduced by commit that added support for large zone
> device private folios. However, that commit did not account for FS-DAX
> file-backed folios, which have always supported large (PMD-sized)
> mappings.
> 
> The check distinguishes between anonymous folios (which clear
> AnonExclusive flags for each sub-page) and file-backed folios. For
> file-backed folios, it assumes large folios are unexpected - but this
> assumption is incorrect for FS-DAX.
> 
> The fix is to exempt MEMORY_DEVICE_FS_DAX from the large folio warning,
> allowing FS-DAX to continue using PMD mappings without triggering false
> warnings.
> 
> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> Signed-off-by: John Groves <john@groves.net>
> ---
> 
> Change since V1: Deleted the warning altogether, rather than exempting
> fs-dax.
> 
> === How to reproduce ===
> 
> A reproducer is available at:
> 
>      git clone https://github.com/jagalactic/dax-pmd-test.git
>      cd xfs-dax-test
>      make
>      sudo make test
> 
> This will set up XFS on pmem with 2MB stripe alignment and run a test
> that triggers the warning.
> 
> Alternatively, follow the manual steps below.
> 
> Prerequisites:
>    - Linux kernel with FS-DAX support and CONFIG_DEBUG_VM=y
>    - A pmem device (real or emulated)
>    - An fsdax namespace configured via ndctl as /dev/pmem0
> 
> Manual steps:
> 
> 1. Create an fsdax namespace (if not already present):
>     # ndctl create-namespace -m fsdax -e namespace0.0
> 
> 2. Create XFS with 2MB stripe alignment:
>     # mkfs.xfs -f -d su=2m,sw=1 /dev/pmem0
>     # mount -o dax /dev/pmem0 /mnt/pmem
> 
> 3. Compile and run the reproducer:
>     # gcc -Wall -O2 -o dax_pmd_test dax_pmd_test.c
>     # ./dax_pmd_test /mnt/pmem/testfile
> 
> 4. Check dmesg for the warning:
>     WARNING: mm/memremap.c:431 at free_zone_device_folio+0x.../0x...
> 
> Note: The 2MB stripe alignment (-d su=2m,sw=1) is critical. XFS normally
> allocates blocks at arbitrary offsets, causing PMD faults to fall back
> to PTE faults. The stripe alignment forces 2MB-aligned allocations,
> allowing PMD faults to succeed and exposing this bug.
> 
> 
>   mm/memremap.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 4c2e0d68eb27..63c6ab4fdf08 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -427,8 +427,6 @@ void free_zone_device_folio(struct folio *folio)
>   	if (folio_test_anon(folio)) {
>   		for (i = 0; i < nr; i++)
>   			__ClearPageAnonExclusive(folio_page(folio, i));
> -	} else {
> -		VM_WARN_ON_ONCE(folio_test_large(folio));
>   	}
>   

LGTM

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

