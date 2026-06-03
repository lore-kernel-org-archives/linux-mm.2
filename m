Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00C5CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00EB46B0088; Wed,  3 Jun 2026 06:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01DE6B008A; Wed,  3 Jun 2026 06:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17D16B008C; Wed,  3 Jun 2026 06:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4C056B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:59:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BEADC1676
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:59:50 +0000 (UTC)
X-FDA: 84838306140.23.F758FBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB263120008
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:59:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LbOOrg6U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780484388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNk5vW4s69I2K0c0Yz4QAV+UHhsLI+rVPezuIvq54J8=;
	b=ZEnTZbqLIZE5T80a0cz88bN3lGaQtuw+UFMK+CaYiBv7kjD8HzTpFtD/UGCzTfaCm8c7ng
	Y1/I7O7RZCZ4eUZTQQ6w7YNy0Of47gt6rPJzuhfa+ZIEWzny9vix5v5HzqVuV8ps+/NFtY
	8/kiT8OhiJi4jUYJGO8c+SJ2qlSBgew=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LbOOrg6U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780484388;
	b=4OhN2citECr7v+gTqjqV/Z3q41c2BvW1q2FIXQbnjRsNXkcvRgwlLiwMt+FgoUnCFhwg+b
	hAKYg1XmbGpGsFMyYlUixmi314tgfjaheMseM0cgoFrpRN5JDoMnwpsPduETpthKVPCmgd
	8FsU6vZ+25YqcyLHmwYI8vjO2E3IKxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05054400E3;
	Wed,  3 Jun 2026 10:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5229C1F00893;
	Wed,  3 Jun 2026 10:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780484387;
	bh=LNk5vW4s69I2K0c0Yz4QAV+UHhsLI+rVPezuIvq54J8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LbOOrg6UPzlmVVhpLbmmBadHDKyaV6em4iZXtTw/bwi9OxEB/Z2kLznZZfoyaIpIn
	 Pp63NWCW+s6iI/9BDWhG5OTJzxNYlVOrc8cF+gD4WtKa2p/hf1qgnWnVtiWqNzf25r
	 iZ/hMM5i/iPJwr0aJr/ri1fXCtCP+bKeYXTCG272+P3vQquYYR5YJlJeTjnl/+2F3h
	 JVnCBpNeX19CeVh6ic0bg7J1PiQCesrbEcvVJ3F9nt6uosWydyaCR9ACG9t7QYTqj3
	 ZP5uY/607EeWe/UU6/6jum7YQM3r6hPySVDYKrEMv1Ayk3Y5hEhQ0j+U3byptZjwG4
	 7vilOYdwoBoNg==
Date: Wed, 3 Jun 2026 13:59:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com,
	ioworker0@gmail.com
Subject: Re: [RFC PATCH 1/2] mm/secretmem: try to restore large page mappings
 in direct map
Message-ID: <aiAJG7gdey4oNr4a@kernel.org>
References: <20260603104624.36390-1-lance.yang@linux.dev>
 <20260603104624.36390-2-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603104624.36390-2-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB263120008
X-Stat-Signature: 8uwu94yw6jj71r99pwcwsoka4xi5tbrs
X-HE-Tag: 1780484388-165860
X-HE-Meta: U2FsdGVkX1+Wcnc+gz4bN21ELZl/kF0vmyYZ3JiGWDKcyJNzE0VbNVkUEuhemgCOJOR8SHy4xHmZMzx0MTXYs4MOn/oJYaLEnG778xeze0+gZfuChPuNxVnJOhTnTAyoqFum0FpNuKbKBqLXTTSKYYXSYhSVoxjeeMABcunnwZI26Ed+s9wHOgfsOJuBKV9gvVhYKVJRUb6qPpjl/3pevbhnoccwL20sU1QBp03nW2UvLPfe86GNWFRkoX7aCkwDsG2jGB3sUzSLEuWcyHUyCOx/CZvLdCKd1AzSA355UEDOL0tEPrJlstfKFE3dLtEROYI8tr+/j8YWyn8LogzBw95yOJiU4yHYGOc/FTM/DFJM+/hMF5mAGpK0nsgnAK5+5rCu7Pm6teusMa2++Wvl56qByIu1fx5DpEl+u/6NURrrDVMXv+CTpRUw0m7Op0+pObYCdq/lIF+i4MYmsOtpHKXE1ZcRA0RNqN4FOpop8PzimQHz9jW4aTmxpmmiEI0DXLkWvlhrRZF9oa9DAHCPaIYb1nAI9WdKG/DgtqaU+uidBMXegVRZxt5byRGfCS4JKZEkd9ZSSlDZKe2zgHRG5+yqQf2O4zJIToCsM4ew27GeJnDLiOMrqEzicsVuKwMsAQSbKFv4ZbGRp3lx6SXkNFnENNqx0UUb7mQB0I5LkiuaIeTGOSMfO3JhRwueJ5BfTqBG1dM/SFuQkaujV/bYWLemmLfB9Locl6diCiQSBDtMqxCxvq5YeAXy79dPqYhr/uhOO4wbkp3whMrCkPpZTuJVizcX+CyF/o+VIHzUnGbveqEo3kEwKPvAMNV9ivanSnum2Q8Xgmfqxf6iEZek9jBKgA0jwtvX9dzYn2Hk++qcwj+b6Iy0EZUrSvUkexT7RGWLQvKk06oDFIyrv/o6xsEodozqVXqxyptOhJEhVbnhIed8KXstmyUM4Xz/eHmR5ginXstXbRHKkwgu03b
 REuXIqNO
 R5NgWLnhJDiEzs8trq3HCQaY4Q2x99mCpy9jQp1Ig7vwMBicEXZElegt9jEvsmmX03muR+P0ZVk6WTeWx7eh4ZUCCwUwEVX2tDpSRTaFBffMI0i0SduyRGePaBnyPWAnJkwwxCnFXrLKd+bcJErUk5zB48KM1fanHJkh4PCV5vgqZ6XjkMb7+vQTKoAoy747+o6e1eKhmouzw8veTvMxWuFrxFlGKnJMD8/gygjrZ6Jm9AP8Xy5ynm1BhgdnlJNhh33U4F2DXmc/TuMOsZFmEW4DdOO4JDCht2swWQwQLP684b8qTalZHtj7HtEBu9YA1ujIFkifIPOJoRN3PYhn0GUwHod/a43NeodXy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance,

On Wed, Jun 03, 2026 at 06:46:23PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> secretmem removes the pages backing secretmem mappings from the direct map.
> 
> Removing one base page from the direct map can split the covering large
> mapping down to PTE mappings. Repeated splits can leave more of the direct
> map mapped with PTEs, meaning more TLB entries for the same range and
> potentially more TLB pressure.
> 
> So let's try to restore large page mappings whenever secretmem restores a
> folio to the direct map.
> 
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  include/linux/set_memory.h |  6 ++++++
>  mm/secretmem.c             | 12 ++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5a..ad2fa414a22d 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -58,6 +58,12 @@ static inline bool can_set_direct_map(void)
>  #endif
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>  
> +#ifndef arch_try_collapse_direct_map
> +static inline void arch_try_collapse_direct_map(struct page *page)
> +{
> +}
> +#endif

Did you explore what would it mean to hook collapse_large_pages() into
set_direct_map_default_noflush()?

-- 
Sincerely yours,
Mike.

