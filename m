Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6237C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31DC6B009B; Fri, 11 Sep 2026 10:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01CA6B009D; Fri, 11 Sep 2026 10:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18E96B009E; Fri, 11 Sep 2026 10:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C01C66B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:58:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66CFFA25F9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:58:52 +0000 (UTC)
X-FDA: 85201788504.24.FA7A7EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C1382C0012
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:58:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqz5AEtv;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789138730;
	b=O0u8k9qp8Tq2fd+H+jFlonvOJHy3eEhEH9G9r3RMOKJqEPLSGDTeZSsZ2pq9UN4qDF5Y0w
	s0O3v/pHpbDenfbRs0uYVuRBA0WGb54tUMIhBG2giOF2Smg+YIfrkyYF8yRtYmTCcPfgnQ
	w/9ewt+0AYYjz2mlZ6T0bnp1eKtp7E4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqz5AEtv;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789138730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLYYj8/276uUFHKp2bAmnGjCPPOUxg1/tbdfRRnY79M=;
	b=NNdJQYFW8B+tKhFSggM10cVqDJnjeDtizVp9jnlxLdrmFGiUObR0BE4VENOYxescqHgGWk
	CFagHHncfbFd31z6P+1sKu32Wfdp8y7wB5+aE8pP6jQu6xNgSJuRjy0XVmpdfxwRWkAEV0
	BHhoTAGM+org2TNtYCg0QXIUMmBT8YA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E4DC6022D;
	Fri, 11 Sep 2026 14:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF0E1F000FF;
	Fri, 11 Sep 2026 14:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138729;
	bh=CLYYj8/276uUFHKp2bAmnGjCPPOUxg1/tbdfRRnY79M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hqz5AEtv8bWAGxTuMNtJQO2wPSFWWYfCq+JSxjsW2aNGCo5VgdIdzSLSWqd1EQKf5
	 PV+NDPGnkEYz0CAO9fV9YVVbj39Ws7M+cVb0kh29FAeCTGyGfPWtW7BdHJgMmnzTFq
	 gEJ32WRXDa9WnfxmGqthkNrTKCcaseCh3ywj8MsITXYwpMSGp/6q028uEV7TTpM0hy
	 woNWGJGhhsSMCKZDlpiCZntEgs72YAPBRF1t71AC4guU/LPAbNrmVjo2/BSzuxVGvk
	 fsDYvlMe9lykYXEWYhDdIL72fLBJADzBrm+hz52rTYXxuJ2aISxsMX7BbucMksw4ID
	 E4lf9OfMk6tyg==
Date: Fri, 11 Sep 2026 15:58:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2] kselftest: mm: fix potential failure for merged VMA
 in guard-regions
Message-ID: <aqQXFG2O4CtoQERQ@gremlin>
References: <20260911142904.1825452-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911142904.1825452-1-yeoreum.yun@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1382C0012
X-Stat-Signature: cy3j13ewwmuwscwi6pmy9y6ncgwntism
X-Rspam-User: 
X-HE-Tag: 1789138730-258673
X-HE-Meta: U2FsdGVkX1+qHLoEweK6tb96LpS34YaoOW/EqXSXw6wQHz0pMwGbzqmAkjYveQah5TciH/LIpVDWfbkaUxvR1piAr5xQwfrqCosWpYEj+el4GD1oxvizUexs8S85+mcazXx4BoxsAuT2BiY0eeeTEAXqKJmTJdkoyHnoJKDAr+79YqxV7BAoHBBDfNd1MDPqCZ7NhNuaU3qumPL3o93bQi7g3OTbFTo1Kz9a0W6CuauQ4mL/0VYkmix2p/7Jtcu1ngGag/PDfzaH5W64lsfECufRs3iyFYsROFobqjvT2VUw3PniT6wkp0d4AYoDHzZY3SWfo4nz32SKvyUP8UrVIQMDOq0Mc/fU0W1ctxDD33xCmpvMNwiryIWfsv2/RvHujVctbR0kB+f2ODbtXnmgXlNIZdVfQh/RJ1XLgnB7aImjDsKTXczF9Ry7vGJ1LlgO8fK0IN/lzhnhSab7jvtmJRCoinXQwPpO1qEbBZvT8QG2T/6AK25IfGVOaxst8/5PW1/ZYISVUiiBIWOJBpISi0LjTSVEK9wui+ulWOiCV6059BnIyi2hDLjaoQVxqb6geNnIZjiLhUBBcFE33EWL589bS1UIIZzCBF80v3h+IuR/kE6k41fYg7bnyLPkM4zycEUJQ3L5jqKZK3Px0UAzlf8L1w1PCJM7JPyk49tF4EauDQJIWqs7CFxkhXOz3u8G96tnDTjMs7kVEvjnt6zBVJOkwTrjoF7A9iDEVWxXqODWYWpdPwFvlCNLCEsO8YH3tG4yHZrQBdztwohoEfqh0ZLrSvQ7tqRFB5YM55/yyQQLumNivHek+WXcZA0Vwfb33jCjGUubQVzwLCrrFtYfzUAIoQy/8GIkVWpL9ffSsCO656vpxaewl+g1kjHqfRCkx2PHXTRo6yXAts6+9deOR8On8hlyTkpi3MxTKc6Pk+8l5/f57BOoerugsylSAaxJlliHzClwng94Vaoybfo
 MDaxs+uh
 1wYOz75HtoN5z441NfRBH6sep2UTSQpSWXEYGXs35m2HTf67/DXH8iVz0SvwfUQeTm0sfMOAbp7PVDEFRBD5qtyxWlc5S5J/CDTOs6JuSxdg/T7ybAgQebS+XNZPqICwU/PzKooDM0CSm3ZytQhvNCJLcdOHFMiFPE8lu5wPA5y8RQyiynIg44UpNy5OQPk5E/Tr0miJwy/9ng/linqits3cqw6ohrkYoVK+XSfto2PlBgN6v7cakoltwtht8i1uLRDwxN+oaR6PNk+Nm2pp2OJYPiRrfhPR0yc+iO/X5yyBs5alpXyiUGQUjqiSHLZyGpaYeiLFew40aU5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 03:29:03PM +0100, Yeoreum Yun wrote:
> check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags,
> but this can fail if the mapping is merged with an adjacent VMA.
>
> To avoid this potential failure, first allocate a temporary region with
> extra pages at both ends, unmap it, and then map the test region within
> the temporary address range, leaving an unmapped page on each side to
> prevent VMA merging.
>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

> ---
> Change in v2:
>   - change the prot as PROT_NONE for placeholder region.
>   - add comment for clarification.
>   - Link to v1: https://lore.kernel.org/all/20260911123534.1181501-1-yeoreum.yun@arm.com/
> ---
>  tools/testing/selftests/mm/guard-regions.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 5c8ec3ca75d7..b724d62d2b75 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
>  	char *ptr, *ptr2;
>  	int i;
>
> -	/* Map a region. */
> -	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> +	/* Map then unmap placeholder to avoid adjacent merges */
> +	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_NONE, 0, 0);
> +	ASSERT_NE(ptr, MAP_FAILED);
> +	ASSERT_EQ(munmap(ptr, 12 * page_size), 0);
> +
> +	/*
> +	 * Map a region for the test. Since the preceding temporary mapping
> +	 * succeeded, this mapping should also succeed without merging with
> +	 * adjacent VMAs.
> +	 */
> +	ptr = mmap_(self, variant, ptr + page_size, 10 * page_size,
> +		    PROT_READ | PROT_WRITE, MAP_FIXED, 0);
>  	ASSERT_NE(ptr, MAP_FAILED);
>
>  	/* We shouldn't yet see a guard flag. */
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

--
Cheers, Lorenzo

