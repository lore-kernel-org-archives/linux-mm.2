Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63D3606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q1HWPlap
Received: by kanga.kvack.org (Postfix)
	id DC85B6B05B5; Wed, 18 Nov 2026 04:31:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78D76B05B8; Wed, 18 Nov 2026 04:31:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E9A6B05B9; Wed, 18 Nov 2026 04:31:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8E036B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:31:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF5CEC06B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:31:26 +0000 (UTC)
X-FDA: 85447721772.23.002C8D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1BD704000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:31:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1HWPlap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794994285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XF8GKc/X0VLcHzIBVmGS1CVeRJx2Wgr4tpTpsERNcqI=;
	b=ObXb6Fa2wlHvvr2s6TA/rEX/lhaCDHrErChY1Fa+w2jhplSSZFFCdSik5MN/dokKQvOFTd
	ykMfEmrXN1akNtBtL6UgXT3iFAmfO5Grhd3s9vZcpVE9cYChxWwZgOrcznUQBfaboqyrb+
	rqwtQx3eR9CHqq3+XI+XeOcT9Oeotc0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1HWPlap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794994285;
	b=2qMr6C+exi4u35bPaw1TZtsuR2xhLeAJEbkio3ml4emdHHwvvfJyc360MO7qQcIGJTJ/iE
	lgMTxEo3IYuiHK4X/Qg9Pn/w68HuDxDCOpw0bGoEm35WHXtJZofXtvSoGnjDsaC7fI+kMf
	4K/oDCWulVE7sM8AvSGHvVu2i28CFpg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90A3061FDE;
	Wed, 18 Nov 2026 09:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D6D1F000C5;
	Wed, 18 Nov 2026 09:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994284;
	bh=XF8GKc/X0VLcHzIBVmGS1CVeRJx2Wgr4tpTpsERNcqI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q1HWPlapjpRCmieyRfIWLeE1Gqlm26as4yTq4bwNmdEjsKQuKb9BWZ490H7B0FwXr
	 cpIYolkQNJKuKBleITXdl1CKDnnawzei53EGY99yEvDFSrocoPYyWHrDltPyTGTWf/
	 eojg2mTjFwX7e2QgE2qMkjNxL9CWYooG+pXrpT2liNBBrp43gy8qqcZWgDmEQ46L/c
	 SLbP53dGMaa0mdaBe5yP9FBqK6E4AQ+rU65JZcug9qACXbHLJ2leae/ysZFB6kxIID
	 k0DoFioSSY4cZFoMJaRlz0Ae/CbTnF7IA3pfnOk+ubsnT08BZcBR5k5dUtNLN61y4n
	 a0vnAMNIujwNA==
Message-ID: <29bca989-c3ce-4995-ab1f-1e2c49b93e48@kernel.org>
Date: Wed, 18 Nov 2026 10:31:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: limit forced anonymous shmem huge orders to
 MAX_PAGECACHE_ORDER
To: Jingyi Sun <1045704958@qq.com>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Luiz Capitulino <luizcap@redhat.com>
References: <tencent_FCBAE9157D42FFF00E681A2D5EA72CEEDF08@qq.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_FCBAE9157D42FFF00E681A2D5EA72CEEDF08@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yxk9hbzeb5sdkf99yobcf1n6j3z3iig7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BD704000E
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794994284-853030
X-HE-Meta: U2FsdGVkX19TmgSeaaPQ2SBAthNCZWK4xpIgI8ebjkc5tZ+0y/bGWWBblmfZrxHTNU4/ROrrrtFfWXY9rVu33ecuuyq4wT4wTZ1EXeY58kJ0DOc0gmZDwIhda6FRHkKTMYfitLHdqxNaBof/7M+gCRv+R0LKlJYtS8K+oUG9xebel8DQZ9cLkO/exFkd7vYCrlrbnCqtVwaXEwMtEi7GkWbrRetPfbwizClnhWpFF0MP8E1sAgZ0q99YowaElxIDwJ63N3b9HEvKkT3tKqUSnGKPJItKJEE/7/XEfz7z4ROQgoyc846TgJYyak6+7LgpNarXhL+gWkJp/75JJeghBsE+CVgelcIWlSG6OSrgZoUOrMoZrssQqD3uAwKtuLIqLMWYgacLI7WeXzt38p7IB8X1CxOorlIBgJrGeg23stYDfGrijax2iiaOHRYWfgymR9PDJKuhBkPW9u4m45hhlJlsk6gNl1x7uTuRHMi3IzhntUyFo1sWvlIGmPCNQj0/ZVV9KbUZqIByfoXKAOWugOcbsh4ElFwq0yFn+fv2iNf5EBkhOXA5yc2yt2POMwng1NsHZibtjbqRbdjLqyR8BSq4DgjHORxXCwVkmNbzeP5dgMLgujWdcd80UceoMdGonSH6jSa8zzqhSVLQwmH/UnD6KkSHyE5WPJI9CT0LJHVKUB9bXPHFqbVEqS0s4JeGF3O5ynTRUrq4j2wU66MkaFT60+w+0E7FIaMtXY+xsFvqVekV0dhRC66dSkVNPu/GVkJdp7ob7EJs+tivFnslyi5w8QaumBjRixFJWRtuJd9H0/KeAF9OsU3IWqcm8wNpINv8IxxaKRSx/jFzuNr/YVPkZqmAKvb/FvjtJYQTAgWahQEtHl66do/9BtdKmA7umRUzqMnw2mKFPtkW9ShRyJNewrwe3H6vp/Hw8y4H7o+ielPKv2M+sWoxYLDpuX4QV4r0axLczEvoFHi0KR8
 JuMP2VoK
 VfxqDtZeRd7G9cVEQ7vp/0IQuVtpitqUZI5Kz+jP35+stj/f6JwTpeKzZm7hcSFB4A/LlEG02Bjrn4bcBTJK/YNCsYuc2X9B3K9W8HF7PUZZZSNse01wdKvv4aG1SBpG+ZZLHcr+LsPjvm6jspXHcCjgE7Hkc1XsYHqXdYUwOkcZv4n53o7gBXkl0+Qrt0YJ4Zq7zNkzBYyRsJgCM9MH5g+i8Sl7re0FUXwaFnDJX6GOUJbAjBTVN3pvVNjvGiW1RZj2pOtZY/DrS5n9oF1QL4mhjbpLQ+Nuuph/svTCasL1QmXkpKVXgiNzYhLqAfNgsDByiloYwECR77gJ6sj/vz2bJAQL4ESzLCzV3YhbXILLP4OdiGKnUa0u1pcEMhWmM181/cv+pJ+bDhAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 03:45, Jingyi Sun wrote:
> When the top-level shmem_enabled knob is set to "force",
> shmem_allowable_huge_orders() returns huge_shmem_orders_inherit for
> anonymous shmem without masking it with THP_ORDERS_ALL_FILE_DEFAULT,
> unlike the other return path at the end of the same function.
> 
> huge_shmem_orders_inherit defaults to BIT(HPAGE_PMD_ORDER). On arm64
> with 64K base pages HPAGE_PMD_ORDER is 13, while MAX_PAGECACHE_ORDER
> is 11 because of the xarray split limit. With shmem_enabled=force, an
> anonymous MAP_SHARED mapping can therefore get a 512M (order-13) folio
> in the page cache. Splitting it later, e.g. on swap-out from
> shmem_writeout(), triggers
> 
>   WARNING: lib/xarray.c:1051 at xas_split_alloc
> 
> and the split fails, so the folio can never be swapped out.
> 
> This is the same problem that commit 9fd154ba926b ("mm/shmem: disable
> PMD-sized page cache if needed") and commit b66b1b71d7ff ("mm: shmem:
> avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem")
> fixed for the other paths; the force branch was left out. Mask it with
> THP_ORDERS_ALL_FILE_DEFAULT as well.
> 
> Reproduced on v7.3-rc2 in QEMU (arm64, 64K pages, -cpu cortex-a72,
> 4G RAM, zram swap): with shmem_enabled=force, a PMD-aligned
> MAP_SHARED|MAP_ANONYMOUS mapping of one PMD size got a single
> PMD-mapped folio (ShmemPmdMapped: 524288 kB) and MADV_PAGEOUT
> triggered the warning above in 3/3 runs. With this change: 0/3.
> shmem_enabled=always and 4K pages did not show the warning. The code is
> unchanged in v7.4-rc3 and in mm-unstable, but the test has not been
> re-run on those trees.
> 
> The issue was found with a research static analyzer for
> cross-architecture dependency bugs and confirmed with the QEMU
> reproducer described above.
> 
> Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
> Cc: stable@vger.kernel.org
> Cc: Luiz Capitulino <luizcap@redhat.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Jingyi Sun <1045704958@qq.com>
> ---
> Changes in v2:
> - Dropped the Assisted-by tag (Baolin).
> - Collected Reviewed-by from Baolin.
> - Dropped the note about the overlap with Luiz's mTHP series; Luiz
>   confirmed his series will land after this patch.
> 
> v1: https://lore.kernel.org/all/20261117121626.1058-1-1045704958@qq.com/
> 
>  mm/shmem.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 10cef89b00b0..41bb3f2c6b63 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2114,7 +2114,8 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  	 * means non-PMD sized THP can not override 'huge' mount option now.
>  	 */
>  	if (shmem_huge == SHMEM_HUGE_FORCE)
> -		return READ_ONCE(huge_shmem_orders_inherit);
> +		return THP_ORDERS_ALL_FILE_DEFAULT &
> +		       READ_ONCE(huge_shmem_orders_inherit);

could we instead set

	mask = READ_ONCE(huge_shmem_orders_inherit);

And sue a goto to the end of the function  where we have

	return THP_ORDERS_ALL_FILE_DEFAULT & mask;

Avoiding the goto means more churn I guess.

-- 
Cheers,

David

