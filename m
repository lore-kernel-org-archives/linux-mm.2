Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2575CF3029B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 05:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049546B0005; Tue, 17 Mar 2026 01:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B5C6B0088; Tue, 17 Mar 2026 01:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50FE6B0089; Tue, 17 Mar 2026 01:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE9CC6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:36:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C94B1C6E7
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:36:36 +0000 (UTC)
X-FDA: 84554445192.09.AFEB02C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E6DB1C0003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:36:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A841uQKU;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773725794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYRgzKh1Nx8rUjLir7NgOhvz/HZqs8HWJ51p8UYtLEA=;
	b=8DqUjv29K1/fp2bqiLx0B4vkkQt+gQEocyh/eqphZnxneiXygjq9P5+CB++VXIe/tUwq26
	xIrzR0ofneYqpHzulxoqt3vpwqhTAx0aweo/xDFBz84tCQF8VTJ63gQo4af3dhOakCqa61
	3B6Gd7U2FVkIKQK/+R0lyPHZxbMOYog=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A841uQKU;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773725794; a=rsa-sha256;
	cv=none;
	b=w5SnFFKmV1wMWGspURbCCBReXL9eRts+rm4wIFpJI6hMopyC3uUVaw7UdQ8t/h4ji7nGDV
	Dj0mVg8R13fkHTf3WW7JfxTDVF5GjLLKwxl5tOjETEqMwsndxTiQe5KLobOELeNFMZdmYZ
	O3LRB8Nd+ORtZS4BzLSj4KEU9iodiPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CAAA4366C;
	Tue, 17 Mar 2026 05:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5A7C4CEF7;
	Tue, 17 Mar 2026 05:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773725793;
	bh=/21WQ/IOtHu4dvnXgF2/nu4A18vGdKJxEcpXgHCCKGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A841uQKUOfqgjvLaPC0o8iVD3qLdenC2SHF2SBaJEZiRlJ+edfKAGybSXd4hMKI7G
	 GRi7lY7658ozFWQWFXC2Ue5g4vGpDybr1of1ClBghi9RV3JTQzcukZEQnPDsElDt3R
	 5YLPiXL6V91zmefZNpbZcz1wwofiOqDUSLNruYWZNMAB6X2vEDMuGQQQzBw5v8QlbZ
	 W65ihHvHH70srQ/eFmdtvhCkaGjSBPKpWS3v1bAJ3JkDC1NRpXMDIPgN17y5ouNwlQ
	 fJRzfMm0YfWFx3+STjKA48vqkuKfv3vtOWssYhtbAlRru0OAeVq7PqZbIbH9de8dvo
	 MAtSIYcvKnqhA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/damon/stat: monitor all System RAM resources
Date: Mon, 16 Mar 2026 22:36:30 -0700
Message-ID: <20260317053631.87907-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316235118.873-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8E6DB1C0003
X-Stat-Signature: tbfjk34hxuoag6p3mu8sdmqpt3dngknw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773725794-566538
X-HE-Meta: U2FsdGVkX18UIh158xXpQG3CEDEwIXlvSngobD7Zq0rDRyTYqySQk2FY3NRZ6V+2WrXX+nL0f8WgHRE0LzTAxO/B3PuWYtihiRT65MQdxIbhaJU3qfU+VvrcEHff3HiSk7N/TVi9zmFcb52FPVrAZNXiLDzlJyogjjTx8LCiUHMb9UEkuHdSF2adwhm66sK9V7u5R4cxTLIPdt74CgAfAuR8OTSpsxTge4+ancmxKETTi2C8gbmMjFCs2gsxaqSXvPYe12wej8Blidl8SYVh1D+GqqukkEgkV7YSLUf44CG7Ngn/+80rhDrYtjssd0J9a+fXdZ5VPcb1iFYz6Cvx0QbaNXJiC24RJ2MepL4LYIYl5EHMXpkHAOkjXUvbg3EFcUCFQ4u3+mHt3HMTyzcvJnyiqvSKCZ9BWNXyCTdT/OQbQNww5xz6YChptS18IuwJyzmZMGO2kmjtNF1OE0uG1NAXjwRkiJlIoJC79c72BMjqZFQaFUz9Y/fysqTzjTZ8zwEgrgVWcbkIvOIpOmzKIJUH5GhXxFKKOTXx64IYGZYBm1vh880M5VfMEdmfaHpSCddW9LoDP/yw5tcziMv2+QbRhxr5zJ4q39L8qoqzXFgGbpI4XQl9bPug+M886ZI/lee10Kl4g0azE7YUTa0Lj4i0VU6GW5lpHgghT7yUzEGb6qq/6au1mBqTTRoUhxAcqU+Ox6U1/uu8NdfgB8M/A8tOrAHrC/Z/xyIV8RzezC6rsYZVJOm0RM7DaLXEM3oKtIlFKlLuQv/I9L0zDFILc1K/3bEV/2kGnWmQAVzp1q6mow9aV0I/Hs2PAjH8TAPsS3HRffyxBPaG3kIBgMIEDL1bB5wY4AQ8Gz5oLREPnQ4xkbLs7PFYKLOoUt57Tt5+3VzWohewqdh0S49NzhIKur8kG46JzKaNi5isnZIGyoOH986dc2zMS1YEG7RFlyQLxpdfUz14gt2cWEKMo/f
 ACLgdbng
 JnP8l9vMrp4qwtB4gqaYa+woSoGEj5mE6SDDbiEIC2zUU5fjlo2t0IsiZuSedHk4Yj8m6wjq8c6dryunOxiyJGqjxEwoG/GnQjoWYXlmsAMh0BrTkL+0IeM+p0rHGnI7U+Yr+K3JQY5/XDqsWuz7Yuy1Hk36h58wepSPhDEQt+pcnGRpRvCoHtiFatLMKSAQyIDXLRS3U4qyJ5U2pwHBnmHoJkSLXxXSug6HsQq8puOaYaYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko.dev found a problem in this patch.  Andrew, could you please
add the attached fixup, or let me know if you prefer v4?

sashiko.dev added [1] comments.  Quoting the comments with ': ' line prefix,
and replying to it in line below.

On Mon, 16 Mar 2026 16:51:17 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON_STAT usage document (Documentation/admin-guide/mm/damon/stat.rst)
> says it monitors the system's entire physical memory.  But, it is
> monitoring only the biggest System RAM resource of the system.  When
> there are multiple System RAM resources, this results in monitoring only
> an unexpectedly small fraction of the physical memory.  For example,
> suppose the system has a 500 GiB System RAM, 10 MiB non-System RAM, and
> 500 GiB System RAM resources in order on the physical address space.
> DAMON_STAT will monitor only the first 500 GiB System RAM.  This
> situation is particularly common on NUMA systems.
> 
> Select a physical address range that covers all System RAM areas of the
> system, to fix this issue and make it work as documented.
> 
> Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
> Cc: <stable@vger.kernel.org> # 6.17.x
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
> Changes from v2
> (https://lore.kernel.org/20260315162717.80870-1-sj@kernel.org)
> - Rebase to mm-hotfixes-unstable
> Changes from v1
> (https://lore.kernel.org/20260313044449.4038-1-sj@kernel.org)
> - Fix wrong argument for damon_set_regions().
> 
>  mm/damon/stat.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 48 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> index 25fb44ccf99d0..c5af8ad4bcb65 100644
> --- a/mm/damon/stat.c
> +++ b/mm/damon/stat.c
> @@ -145,12 +145,57 @@ static int damon_stat_damon_call_fn(void *data)
>  	return 0;
>  }
>  
> +struct damon_stat_system_ram_range_walk_arg {
> +	bool walked;
> +	struct resource res;
> +};
> +
> +static int damon_stat_system_ram_walk_fn(struct resource *res, void *arg)
> +{
> +	struct damon_stat_system_ram_range_walk_arg *a = arg;
> +
> +	if (!a->walked) {
> +		a->walked = true;
> +		a->res.start = res->start;
> +	}
> +	a->res.end = res->end;
> +	return 0;
> +}

: Does creating a single bounding box from the start of the first RAM resource
: to the end of the last one force DAMON to monitor massive unpopulated
: physical memory gaps?
: 
: On NUMA systems, memory nodes are often separated by large holes. Passing
: this single large range to damon_set_regions() might spread max_nr_regions
: over these holes, which could dilute the accuracy of the memory bandwidth
: statistics since sampling non-RAM addresses yields zero accesses.
: 
: Would it be better to dynamically allocate an array of struct
: damon_addr_range covering only valid System RAM boundaries and pass the
: multiple ranges to damon_set_regions() using the nr_ranges parameter?

Yes, it can force DAMON to monitor massive unpopulated phyiscal memory gaps.
But, because DAMON utilizes its adaptive regions adjustment mechanism, the
overhead will be negligible.  This is an intended behavior.

> +
> +static unsigned long damon_stat_res_to_core_addr(resource_size_t ra,
> +		unsigned long addr_unit)
> +{
> +	/*
> +	 * Use div_u64() for avoiding linking errors related with __udivdi3,
> +	 * __aeabi_uldivmod, or similar problems.  This should also improve the
> +	 * performance optimization (read div_u64() comment for the detail).
> +	 */
> +	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
> +		return div_u64(ra, addr_unit);
> +	return ra / addr_unit;
> +}

: Could this silently truncate physical addresses above 4GB on 32-bit systems
: with PAE enabled?
: 
: The function walk_system_ram_res() scans the 64-bit physical address space,
: and resource_size_t can be a 64-bit integer, accurately holding addresses
: above 4GB. However, this function returns an unsigned long, and DAMON's
: struct damon_addr_range uses unsigned long for its boundaries.
: 
: Since damon_stat uses an addr_unit of 1, any 64-bit physical address might
: be truncated to 32 bits when returned. This could create an inverted region
: where the truncated end becomes smaller than start, breaking the
: damon_set_regions() initialization and causing out-of-bounds memory accesses.

This is correct, and the consequence is problematic.

> +
> +static int damon_stat_set_monitoring_region(struct damon_target *t,
> +		unsigned long addr_unit, unsigned long min_region_sz)
> +{
> +	struct damon_addr_range addr_range;
> +	struct damon_stat_system_ram_range_walk_arg arg = {};
> +
> +	walk_system_ram_res(0, -1, &arg, damon_stat_system_ram_walk_fn);
> +	if (!arg.walked)
> +		return -EINVAL;
> +	addr_range.start = damon_stat_res_to_core_addr(
> +			arg.res.start, addr_unit);
> +	addr_range.end = damon_stat_res_to_core_addr(
> +			arg.res.end + 1, addr_unit);


: Is it possible for arg.res.end + 1 to overflow here?
: 
: On 32-bit architectures without PAE, resource_size_t is a 32-bit unsigned
: integer. If physical RAM extends to the very top of the 32-bit address
: space, arg.res.end will be 0xFFFFFFFF.
: 
: Adding 1 to this value triggers an integer overflow, resulting in 0, which
: is then assigned to addr_range.end. Passing a region with a start greater
: than 0 and an end of 0 to damon_set_regions() creates a structurally invalid
: inverted region, which might corrupt subsequent DAMON calculations and
: sampling operations.

Again, this is correct, and the consequence is problematic.

We can avoid the problematic consequence by checking if addr_range is valid,
and return an error if not.  Below attaching fixup patch is implementing it.
Andrew, could you please add the fixup patch?  Pleae let me know if you prefer
v4.


Thanks,
SJ

[...]
=== >8 ===
From e1fd7cf6469977cf1a58ee98b977eec53219ffc2 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Mon, 16 Mar 2026 22:11:22 -0700
Subject: [PATCH] mm/damon/stat: return error if monitoring target region is
 invalid

On 32bit systems with LPAE, the end address might be overflowed or
truncated, resulting in invalid range (the end address is equal or
smaller than the start address).  Return an error for the case.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index c5af8ad4bcb65..cf2c5a541eeea 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -188,6 +188,8 @@ static int damon_stat_set_monitoring_region(struct damon_target *t,
 			arg.res.start, addr_unit);
 	addr_range.end = damon_stat_res_to_core_addr(
 			arg.res.end + 1, addr_unit);
+	if (addr_range.end <= addr_range.start)
+		return -EINVAL;
 	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
-- 
2.47.3


