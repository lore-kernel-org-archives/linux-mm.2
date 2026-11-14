Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B637C606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i8Ms1s7x
Received: by kanga.kvack.org (Postfix)
	id C927A6B05C3; Sat, 14 Nov 2026 12:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43FC6B05C4; Sat, 14 Nov 2026 12:14:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32646B05C5; Sat, 14 Nov 2026 12:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92A946B05C3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:14:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22A171A0478
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:14:54 +0000 (UTC)
X-FDA: 85434374508.19.566B847
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 612C8100005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:14:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8Ms1s7x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794676492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amAldK0/T73Ry1qXMWa943LC72gx3MygeFvu1xpe5Ok=;
	b=HZSoRR46+LU6Peg1MsPZExWiKRwtWt2VjFGtzIhxyld3ZhXhAe0MajFfiAKd8niwFX0N9C
	mXs/WtbFsC+DoW7IkrCOAuO0lQ6Ilp/pbGIIJpTqNWW6zBZryTMTHczBv1Vf1kCtgGZh3J
	EbjFV68qEtDunaskcJ2RE2wRuBqa12w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8Ms1s7x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794676492;
	b=X/jowMbJYxZU+rHtI/s9CrBvoTV3Qt7fmXYXOPMKkrGgWEAZq6Kqw5Ul1X2/WjLDZ/RLPZ
	08zMpjpWEwR4FbIOqeXrd0fzyWGedY/AHMLB10vDCcDwvuEiSp+U7sSlkztk25KlrbGAuu
	hFNLEI2QfNTQmbTUDjRtEO+cD6BIf9g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 939C1458A2;
	Sat, 14 Nov 2026 17:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6091F000C6;
	Sat, 14 Nov 2026 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794676491;
	bh=amAldK0/T73Ry1qXMWa943LC72gx3MygeFvu1xpe5Ok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i8Ms1s7x3h9Tky0npGs3DcTcpD9x9ZNBOGIqUGiKFm5Kie6dXrVDT+00aDA6F5AEn
	 vz7YwCk5G2fn+PMuyvUVI7tlnFg6UkkPJa7t2ZWpGFrAqE6ib6pzwIR2H6dHWp+w0r
	 wnFO0yatYgaLzdKqVERxXCAse+ubatVks74swC1VOJq7WYOMPcepDTdxYbxcbkyedo
	 Oy9gbE5/EeOfRWTBaouQW8+sMf0CoqryfbpJv/u0WND5MRCDMHv8bPkyEq0tT6Xzco
	 LfNS3wg7kZq4r2bfLtR3V1V/bZwotoan9lJsRR5hsTUOu7zflwZAOlb3LVIrr2iQ8z
	 vjdt2l0CTsepg==
Date: Sat, 14 Nov 2026 17:14:46 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: akpm@linux-foundation.org, liam@infradead.org, linux-mm@kvack.org, 
	vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vma: restore VMA iterator on full-range merge failure
Message-ID: <aviVQ40at8rZEyjW@gremlin>
References: <20261115004655564ix3vefI54RZ3HhYOmxuKX@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115004655564ix3vefI54RZ3HhYOmxuKX@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 612C8100005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: owjfykdz3mgmcoex7n8yrgkkajc9rnyu
X-HE-Tag: 1794676492-731029
X-HE-Meta: U2FsdGVkX19C2TJsiio6ZGEk2VrJUKcd1GdSgNy5aUm2zuXXci3DymlBwomV2vfd+U6lHdVgRIKaUaa3n6i57MNSAP+SrKAoj3OFDNt/P/IWuHZJXhQkuSusbdeaXlDsVepMMdl2qH3g20lMKt+OMKPKeDaJYtobunO97D0gfjPNSQAnI9/NgNtyntW8ixDO0Ia8DD34xxN/rpG7rcJv0EEkcMkOc3HTTdWK4PTBQFeBu4PW0uO/dOlIn7nTSinm3wGSgu386N9Yv3SFROA8NCc2kz6KKhACKQSU/uqFcavnZfAQZAumF44Al9QVA4oTjZAPCjhx4sr2KvhVIdP4RZE1zmYTq3DIJD/g0oqFNHnv8G8k2AMB2yayk1LfpCzD+A1DsU/Jm38zE1p1LwcmfQ2Lh2KBf93dmB3mqau1eKzl+tIyOtUEPT2zg2fsbJAkQInhtaMOjdOFHckai3YtYgfiRoFfFXmX/c2soCySt0hl51353/0hRYhyM60HbtPIz04c0det566iGNigfSkB668yhwxTVnrSu9mWoAs093J46Mt3YKKTdqIVSTrAnelMex3vGMw0H+iwDrYkRh2+484qjqCT9c+3bc5C7uOX2wj7k9Jx37BHloRLHSXKInqKE40f9aspReuZ9MK8ShbJ+3/ojXxkwjdkMuVJWetaRl1QHCPCj0uksrWLq+yht5m1ihOFYXCtGFF0CG7Rb9is/hp0pZFULuza+HZHbBVyQZfD/6V5r9faezc+eLrM6C43/ciA3Mw4N32q5mRFcK1BVTC8z3vHKspM6L5R5bnJXVwbkBeAIw4BV/0sDUnnafsZpwbme/fs4s6cPlodHxKKY2d0AV2btVDXsEornXZMvUp7oWD5olUz+eltxLMDE2IJbjiCl40mLBe/Sts3woTjhAL9W8m8I6TtMKDPdA3u/R3dB4nCIgcfBtu2PJuag2FgsltU9+YB1nBSeHLExK2
 9ne+FNqF
 5iqpqAYHO0PMRNzKFoIEJG1rH/gsFZdC8j2eqCicDsf3z7acUJWa/lkUqPtOyJ+f6F1927vV9zQ0LlWGuCXKcDrRdvek2CFSodaiNTv/p/lcDMKu54VHiDtdlgikl3efWWkxZgQmWKU7M1ikOeWXK3L7rxo7oT/Bxgwf3HD2oTO0dtvitUr+E8K4vpzHtAPwkm8nXvigQT4REN0Vnmub5byUCJhegvNLW9rdWC9poe5/6WI69OFAIZ9W7PzSoC87tJPn/1PnnzmkrxSC395z3LPTN2OY3rmawk9tUN+iuL4C1yuCV7J7DhY+yRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:46:55AM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm/vma: restore VMA iterator on full-range merge failure
>
> vma_merge_existing_range() moves the iterator to the previous VMA when
> merging to the left. If the range spans the whole middle VMA and a
> vm_ops->close() hook prevents removing it, the function returns without
> restoring the iterator.
>
> An mprotect() walk can then visit the middle VMA again. Restore the
> iterator to the range start, as the abort path already does. Extend the
> existing close-hook merge test to check the iterator after this failure.
> No crash or data corruption has been observed in this case.
>
> Fixes: 01c373e9a5ce2 ("mm: rework vm_ops->close() handling on VMA merge")
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

(Not the first time I've seen this 'issue' reported).

This is pointless. No caller cares that the merge doesn't
proceed. Revisting it is a noop.

So this isn't a bug and the 'fix' achieves nothing except unnecessary
additional work.

I might go change how this behaves just to stop AI-generated reports... :)

> ---
> Tested with tools/testing/vma using its default ASan/UBSan options.
> The added iterator assertion fails before the fix; all 29 tests pass
> with the fix. Also build-tested mm/vma.o with W=1 on x86_64.
> This verifies iterator position, not a crash or a production workload.

Generally we expect people to mention their LLM usage here.

>
>
>  mm/vma.c                        | 5 ++++-
>  tools/testing/vma/tests/merge.c | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index c82e9306b11ac14f684f44b8d71a0026b7fc145c..c87b29f1beec4ceb02c23f6b37af0e5dff272436 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -983,8 +983,11 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>  	 * If we need to remove middle in its entirety but are unable to do so,
>  	 * we have no sensible recourse but to abort the merge.
>  	 */
> -	if (vmg->__remove_middle && !can_merge_remove_vma(middle))
> +	if (vmg->__remove_middle && !can_merge_remove_vma(middle)) {
> +		vma_iter_set(vmg->vmi, start);
> +		vma_iter_load(vmg->vmi);
>  		return NULL;
> +	}
>
>  	/* If middle isn't removed then it's resized, i.e. splits. */
>  	if (!vmg->__remove_middle && check_split(middle, left_side ? end : start))
> diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
> index b26f1a66a17074775d751a907eb627445cc1dda3..91accb5dc9944724cd11d1bfa47484a3cf9df54c 100644
> --- a/tools/testing/vma/tests/merge.c
> +++ b/tools/testing/vma/tests/merge.c
> @@ -680,6 +680,7 @@ static bool test_vma_merge_with_close(void)
>  	 */
>  	ASSERT_EQ(merge_existing(&vmg), NULL);
>  	ASSERT_EQ(vmg.state, VMA_MERGE_NOMERGE);
> +	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
>
>  	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
>
>
> base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
> --
> 2.43.0

--
Cheers, Lorenzo

