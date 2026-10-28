Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD86606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gscrHbez
Received: by kanga.kvack.org (Postfix)
	id 654456B05B1; Wed, 28 Oct 2026 04:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6044F6B05B2; Wed, 28 Oct 2026 04:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCB86B05B3; Wed, 28 Oct 2026 04:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5366B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:36:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F1F5A89FE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:36:32 +0000 (UTC)
X-FDA: 85371378624.15.DFCC59F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E7A7A0009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:36:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gscrHbez;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793176590;
	b=zkk1TTs/xOsLivD7NQ+OpBKooK3tc3OIgCAZuE56OxTDYJbRJA0UB83R0Epy6QQSW+4FEj
	pCzUIbQSl98V3SmVtoc7rllp+dsPrgxH7zKXeNe/PD6gGNrV70bg6lifpL5VM8aIv943gI
	oxFUYjyY+HCXeo7k+IdcK3EbG5k5Uo8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gscrHbez;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793176590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SoDZH5y48If1elxYBxox/ESd5HONTLAzfzat25FiII=;
	b=gr55ihUaZPleADViJ6Ny+PbEw96HCSUl2oLcQflM/u9xw6wF5wMGuRlbXn3hR99N4h/fty
	uX4QSZnTNKG76Bg4sxsGKfFIlN5//B1aJaldlxnvkqVqepR4MB3aPIQLEtbB7EoZcRowlF
	mFYwfnvgLRVvbHV5n+5roOv1ek9AdT4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 016A641E98;
	Wed, 28 Oct 2026 08:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53CB1F01825;
	Wed, 28 Oct 2026 08:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793176588;
	bh=5SoDZH5y48If1elxYBxox/ESd5HONTLAzfzat25FiII=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gscrHbezavwEXPMK6kRtD1Li4ys3C9HLDDcREx2x3C4ZU+hKrPPb5KQNBUEbdLlQY
	 ik7pQY48RPsjcXmvEgt4f+rB/CJC2AhN0emliAY8OEThJ8U+DhCWrmYwCva3eDua9L
	 nTih5IXDxDPGSjm7+mS7lb5Ho6Juj3DaFaQKnqQP1nA3O9YLfBRLAPChxvSOP+FN8A
	 FLx31mhQFZsIrw43VTDsVQ88/sugKAsqdT2CYk5TMXIuaPB607YtcnDUSHfA5XkZyB
	 kf5WlT2HMzWa9ZMBYA19s+VfZ1A6JWgDbQVwQx/5/PLbla8SPSwRNr5rOgqzi/FG64
	 6Tc8/f/0pzpjA==
Message-ID: <c829f231-3d0f-4f23-9668-06a419a45921@kernel.org>
Date: Wed, 28 Oct 2026 09:36:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new] mm/migrate: move NR_KERNEL_FILE_PAGES on
 cross-node migration
To: Ridong Chen <ridong.chen@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Boris Burkov <boris@bur.io>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Shivank Garg <shivankg@amd.com>, Ridong Chen <chenridong@xiaomi.com>
References: <20261027043214.2248986-1-ridong.chen@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027043214.2248986-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E7A7A0009
X-Stat-Signature: mmhptyu9bi4zjxx6ice1hcdodxdcaiu8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793176590-212302
X-HE-Meta: U2FsdGVkX18gEyCloIAANn5LqV8pjEB/4mnfQtJ39c8JCLf7WouSoVGemUMeHY2qJTBSz8012kFAAGgn68w2NLNW8LvgB/D2IcxS5Ap/twOAuV7SeJsuYAHpaiOAKefttjsFnYBWnpk+ijb545AAcWN/vK0Jx7dNdVJopRBaA5KT97HF8qy4GeVlYbhcrFcR+8w1ocWvEX6dAvjD6pxqByedlqFuwZJPi1ZCinfCxdfZ2y5AJfKhhju4pgv6BR7ZfWE9VfeUw8kceL4n0ZNn1EQhNpZw15qM49Muq1/VAGOPSfE4UzojtBdnTe+78/nAjvVkjC3bAwo8k5keNuVyBcKEa2X8Gq5+tkx8S369SoDhP+zz/vDICcnlUPDkDd7igdOd93H9d1WwpKW50PuLujcNGhMIiEt3yQVnU0Cj7bPh55cpLsSGxehWIfPXJCgyL+3v3F+hkX558V6XamELeG7YEwkcf80/dNCrWW7xF4SWY4kEvHhllhsRRNxi7yfu5GXh9vbOgIcd5acU1E4KK2bGS6KD14dFC5Cu5eXyaDrwZbLEkSn6APmnZWsTjSJhFaLUruP/RcOEsJ4Bz3V3n3A6VuY401Roo+1TlOQP6UPIGFdqwWhq9CXv2uSKjXWDYx3fTs6YNVCu/n0cYdmMdCssZt5w7c6cB3iocSvD6wDA6zZGpy7ckzaqFHH3/iIBB+wBn8S6vQIS1nv7svE3veclt5uxEyvwWt4BhWXJaQEgPxXrDI6xvwLOqmo7dBMGTDu8nhUZacJSdJGV9kHKycBPdzxD5Wswx27MGWuHd63ev34JDHYm7nf7/igdhU14Wx1dRYjSPiy+td7wo6km/crqSUFW/bGX1hkPnifkYCgkq4HAy+fRxnJGVmw3JeaJNxzbn4kvVdZyQuKFOCIlvuKM92Uu8tgGw3qoHXt5VCJSsMV40GSp++JpXB0vNZMrjsPNjuJkHf5uL0Szulz
 8exK1UjQ
 cioBCDmHFOAZbj6ZzgJdZKCtq0aGfbVNKM395ChMmy21te3mM2pSCOM+V3NgqS842NO5qAYhGGSAApQt5i+0ArLz/1lEAe94dlH94lvX44g+LKLBAZ1SQtbVQjeYCC7eT0x5echLgCFPnKJET/x3UOsSoRkWQE1+DBCSB4pHf1GvSjKGgcwLTA9uI2z3SLvtfJSWmXOeFV4++t9/XoTbd0D1pc9iy0GG2lEhwN4TLd7V0eSUJt/3n1aWJauSLKZJHq8JOkUyXsvwr0H+fdD03WHWMJiF+W8MAMnu8LDjoexRjse73+BZ/dkj3sYepZDtxoIvVmYgSgRTWgaL3f4acYds6JBAmLhKOaM1BFqdJ2dtsgLNRegllJv/QZedTdMICJQ4RddGNSczSiwQOqWW8xpTdtatIj+IBsimVeW1Smi2butkC4ZXnklXS6vtwqflFHw0GQWYb3aqrv+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 05:32, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> NR_KERNEL_FILE_PAGES counts page cache folios of mappings flagged
> AS_KERNEL_FILE (currently the btrfs btree inode).  It is a per-node
> counter: filemap_add_folio() adds to folio_pgdat() of the new folio and
> filemap_unaccount_folio() subtracts from folio_pgdat() of the folio
> being removed.
> 
> __folio_migrate_mapping() does not move it when such a folio is
> migrated to another node, so the source node keeps the count forever
> and the destination node underflows once the folio is freed.  btree
> folios are migratable through btree_migrate_folio(), so demotion,
> DAMON-based migration (DAMOS_MIGRATE_{HOT,COLD}) or memory offlining
> all hit this.
> 
> Reproducer, on a QEMU guest with two memory tiers (node0 is DRAM with
> all CPUs, node1 is a CPU-less slower node described via HMAT) and
> /sys/kernel/mm/numa/demotion_enabled set:
> 
>   1. mount a btrfs and create 20000 empty files, so that btree folios
>      are cached on node0;
>   2. echo 2G > /sys/devices/system/node/node0/reclaim, which demotes
>      them to node1;
>   3. umount and drop caches.
> 
> nr_kernel_file_pages in /sys/devices/system/node/nodeN/vmstat after
> each step:
> 
>                   without this patch     with this patch
>                    node0     node1       node0     node1
>   1. cached         1868         0        1868         0
>   2. demoted        1868         0          36      1832
>   3. dropped        1832         0 (*)       0         0
> 
>   (*) the counter has underflowed to -1832; negative values read as 0.
> 
> The global value in /proc/vmstat is 0 after step 3 in both cases.
> 
> Move it together with the other node-keyed page cache counters.  It is
> a node-only counter, so use the node accessor, matching how it is
> accounted elsewhere.  Interrupts are disabled here, as for the zone
> counters below.
> 
> This was pointed out by Shivank while reviewing the NR_FILE_THPS fix
> for the same function.
> 
> Fixes: e3a9ac4e866e ("mm: add vmstat for kernel_file pages")
> Suggested-by: Shivank Garg <shivankg@amd.com>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/migrate.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 99e3026e3126..f829c5017c96 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -705,6 +705,12 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>  			mod_lruvec_state(old_lruvec, NR_FILE_THPS, -nr);
>  			mod_lruvec_state(new_lruvec, NR_FILE_THPS, nr);
>  		}
> +		if (test_bit(AS_KERNEL_FILE, &mapping->flags)) {
> +			__mod_node_page_state(oldzone->zone_pgdat,
> +					      NR_KERNEL_FILE_PAGES, -nr);
> +			__mod_node_page_state(newzone->zone_pgdat,
> +					      NR_KERNEL_FILE_PAGES, nr);
> +		}
>  #ifdef CONFIG_SWAP
>  		if (folio_test_swapcache(folio)) {
>  			mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);

Today I learned about NR_KERNEL_FILE_PAGES :D

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

