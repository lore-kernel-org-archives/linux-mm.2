Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12C6606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YI6k6/kp
Received: by kanga.kvack.org (Postfix)
	id C375A6B00EF; Tue, 10 Nov 2026 10:17:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EA16B05C9; Tue, 10 Nov 2026 10:17:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24716B05CB; Tue, 10 Nov 2026 10:17:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 969736B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:17:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D23C1608D3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:17:15 +0000 (UTC)
X-FDA: 85419562830.07.78F3A5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 72F121C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:17:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YI6k6/kp";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DrnlJCczTM/MuGJVa3hJuzHOi7kI8idb71E/ayOYKUU=;
	b=qgPcVRdT7U2FkIEuMZf1l7s+UD5me0U9yWo4xC7w/vNo59JyR/o6J3OX/QS4343RyeeiYV
	O59yRAliguGPkD9PWPqxFdmJgHWn/bHPtt7xqUygP8tdnobSPpKucT4bsL20pDzHJXQTVv
	fPHqHz0r4y8nbqsbJsDAy0NNU2OXIqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323833;
	b=RpKGFZHaUjmzZCC5uuBJ4MsirXrnT+yDShTSHZAEeRNzABsCeEzFMl4yXMEV+ROT+984/o
	80ccnuwp5ssJKzAvOPGtHpQkgIoLGs3WBXbY3cQOf3nLgqaojtKOieIxAJjYkmwF/9ubWH
	M1uFnSmR5W5WKOs4FpaETCLkcGT1Coo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YI6k6/kp";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9429743489;
	Tue, 10 Nov 2026 15:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C2F1F0089F;
	Tue, 10 Nov 2026 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794323832;
	bh=DrnlJCczTM/MuGJVa3hJuzHOi7kI8idb71E/ayOYKUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YI6k6/kpdsOZXv6TVGy+1NgyuveofbEgWqWrX8bvrAXNAz2RP6yNfZCwNBpusDfqo
	 3VVbO7y9AmERmV4cR66tvWcbuAQvZjn7e1+KIl1FsvO32qXVKHhxbs7xRE/RwlYsQy
	 cf+0bvO0hyA7Yr7hPCbqbc1DRxor9IYmCJ9cMegkWVcXrhdph95lruauvRixTRwxux
	 4NQOTOpU+31DqIaBudOyc1XsDStPZqgCxoEnCaDGb8vXbZhkJwlBgm9Rx40dOSlZmk
	 p0TgXiSnvffuH3ilakdF3E6gzIQgb6Q1npb9zKoaSGLe2fHk+3Y5liFSpyZOaaHUrE
	 KK4TxbZKj0Dyg==
Date: Tue, 10 Nov 2026 15:16:59 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, 
	rostedt@goodmis.org, bsegall@google.com, mgorman@techsingularity.net, 
	mingo@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
	matthew.brost@intel.com, byungchul@sk.com, apopple@nvidia.com, jannh@google.com, 
	pfalcato@suse.de, hannes@cmpxchg.org, osalvador@suse.de, raghavendra.kt@amd.com
Subject: Re: [PATCH v5 6/7] mm: use BIT() for change_protection() flags
Message-ID: <avM1ZOdjf3w7yJjl@gremlin>
References: <20261110150446.2452975-1-gourry@gourry.net>
 <20261110150446.2452975-7-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110150446.2452975-7-gourry@gourry.net>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bdeewb593goty7pkh88bsh55cw3qb5ra
X-Rspamd-Queue-Id: 72F121C0006
X-Rspam-User: 
X-HE-Tag: 1794323833-421208
X-HE-Meta: U2FsdGVkX1+MEAhpTx/1g/+jv4DqE4B+FAHishw0BBZ67FAFMeHSh7FTD8y3ji6LnDMvU/f47LWvecqb6tG94LFeQW10B7jgDxZNWGgfOOhOVs1YVhv1Ul26AlwE5/Rhfz3STb9kKsc3P+IzztKlEixDgzQ/KpFh7D//nHMQU6hGyZXzoIbcI1KG0KvVa19Mpbqgz1G37Z1e0K4YMb+vd/iJZ8N2zVmXo3QMzo+S25csFfHFkHe91u+dN1jIZ9yuLnbqJeOJbabWKdJmQsU7p//kiIKMs6fpvlMlqqNYz8i6qw8iqQV1cQrJpOBECg85UxgENpAF1njckEbd2LFjvQj7FbCAj5bFza8lJEJKoglDFtrvK+C3BWoa8CnfMzO91D+7/0zos3gxwXRLBrNXrodz01EphEAy+XvRcUPm57SgZgq6O+nVp4JQe5nHtUqYzH/GTQPhha4tpCKvAadAXSPOY4VgliQ3bfUZGYCI5T2H88nb8xiDqMHL3Hc+TCD69xj/0xhupMzXBLCUE75QYr0ZSis3KynwyMmszwShlKg/MLCoJf0cvkg063rZelv0tdffSZFnd8XHT39nBmuH2bNKdpk4pNDMLl2B6aF8YapnREMhQ0gFmTu3rc3MUQ1ErgBsvrPVruNRrG4mAx6Rx3Y1lJWZEjH81XrYXLiQ/eY6sEnBjCYiUbLorHYZhkz2oPBD6OyXyN+sliLwMW1+z67pf9p7qlfRsCH1Sp0/pP71HoRk6uVWyTFAbIoc+21koMrfqTCMES24cY5MS/pT5oEEoiOWYwXu4/0+u1aY1TlZaV0FIG4/q0vfPQVJvvip+LmKFaaqZNFXs5i3AZfGSXHFK1/+kaOyJClWb7lgupXLdYxa+U+Q/IpE2+06B6HTKUD0I3h8g5Ut3uWEJTKrHVZC2cTymNufP3frfV/92p7KENXueKP5QmWVYwFEAYexzbRsR3cz4wuUq7J3PSG
 jk8HUf2D
 ywa+58inbziVb0g7b8E+3J/CnLPb06HElTTpIB97w7OZBz7NIe2hJBupjTpmeXbUPHyMalECAlvIPlNL2/slboJAAqEGymx2N7Ysppz9aF4t2ruyizlc9dkrAMFa5d5ZsmFEbySDL7JIb2M0MSHQggKMFkCh/J0lcQa4CpP014LeNskb2wI6QQOjn3qcUH1M9ewYn35j/JgWrTTV3tv/U9p5V1tAQcrDVkLE/wojwYmQF2cXfVgUhs+gn/flNWcrMEYjWBikkmljbIRLWgh/AUCMqlUeWitoJPuHErAMLu0oyKaHhJKyKkLIHdpUDurlUDYbNnico3IZunXiEWLsj05itTsG4rOIL/IdKud33lfCNBHh378F5qLMCSHJySBWZqVtOyyzsARZw9H50sMacE90cALUwVjon+3+uiN7WG0/z+SVf1uGVTRDITxMCD7Z0JS44/NoLQOwxcQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:04:45AM -0500, Gregory Price (Meta) wrote:
> The MM_CP_* flags are individual bits expressed as open-coded shifts.
> Use BIT() consistently for the complete block.
>
> No functional change intended.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/r/9b5e1573-6fd8-48a5-a274-a6e7ff83d2fe@kernel.org
> Assisted-by: LLM
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mm.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 55817dea7307f..da22750faddbd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3572,21 +3572,21 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
>   * because something (e.g., COW, uffd-wp) blocks that from happening for all
>   * PTEs automatically in a writable mapping.
>   */
> -#define  MM_CP_TRY_CHANGE_WRITABLE	   (1UL << 0)
> +#define  MM_CP_TRY_CHANGE_WRITABLE	   BIT(0)
>  /* Whether this protection change is for NUMA hints */
> -#define  MM_CP_PROT_NUMA                   (1UL << 1)
> +#define  MM_CP_PROT_NUMA                   BIT(1)
>  /* Whether this change is for write protecting */
> -#define  MM_CP_UFFD_WP                     (1UL << 2) /* do wp */
> -#define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
> +#define  MM_CP_UFFD_WP                     BIT(2) /* do wp */
> +#define  MM_CP_UFFD_WP_RESOLVE             BIT(3) /* Resolve wp */
>  #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>  					    MM_CP_UFFD_WP_RESOLVE)
>  /* Whether this change is for uffd RWP */
> -#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
> -#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
> +#define  MM_CP_UFFD_RWP                    BIT(4) /* do rwp */
> +#define  MM_CP_UFFD_RWP_RESOLVE            BIT(5) /* resolve rwp */
>  #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
>  					    MM_CP_UFFD_RWP_RESOLVE)
>  /* Whether a MM_CP_PROT_NUMA change is for promotion only */
> -#define  MM_CP_PROT_NUMA_PROMO_ONLY        (1UL << 6)
> +#define  MM_CP_PROT_NUMA_PROMO_ONLY        BIT(6)
>
>  bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t pte);
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

