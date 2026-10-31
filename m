Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F05606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dco1bVcF
Received: by kanga.kvack.org (Postfix)
	id ABC596B05B4; Sat, 31 Oct 2026 05:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A934A6B05B9; Sat, 31 Oct 2026 05:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA506B05BA; Sat, 31 Oct 2026 05:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB0A6B05B4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:53:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C956AA0904
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:53:16 +0000 (UTC)
X-FDA: 85382458392.22.A990322
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3155340002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:53:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dco1bVcF;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440395;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJVvXVVfMCPxM/C/6Frimxrx5kuXMET0V+pilYfhVmw=;
	b=crsScL1QKA4mbQ1UcXpNvOCg4gGL6YtQdiobMrgrBsG+8FMzXVELKrP9Ai7sag7CFe37fS
	uK0XPNvPZD1DkMVsZH039ejAf+lNaNEXpWSbrgUEjsNsnp474AKMjQhcM63tyMg0fy6XqV
	MkMJyBrrPVLJ1LorGkl2R3E9f/wFUUc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dco1bVcF;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440395;
	b=gYYZNnIV0p5mCxx8wKAyBzDzoTVlCMLrVumFmsYtj/Hpv7zcECqYk8QByTqbNP7TU2IaUO
	cyZNycOlIXgT9ujGVkU5Y8SjlVL6Cz3aUUsUYUJr/vH+u2Waro48Hi9Et7E++knhqkEoA0
	zHp8MACd9kroGpBFYPpz3kyoXQ/qk70=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5C9D600E4;
	Sat, 31 Oct 2026 09:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A43E1F000C1;
	Sat, 31 Oct 2026 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440394;
	bh=SJVvXVVfMCPxM/C/6Frimxrx5kuXMET0V+pilYfhVmw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dco1bVcFCPMLriwgR8v9phYZOHQ/InWN4tEWfXNL6o5tBbzMnjlsNy/NcDuFfqEY0
	 JYPR7FR/qKrSS4Oz6rha9WniWi/RdBWpCqRNX9EdDr5LZ76LXS0TUO63IeUHvdv9Et
	 GwoNiakMl/TinnPkWl/nUAvxRsKNTnJTAkhGwC7xGGkuvG1ZWmvYK/hIVEfFhwYZxf
	 qm954lxNcrPx6R9/gnbyhQweYrIjcAdA9z3LcFS7IWc7jIho3FA7TAUnQuVGY522gc
	 cyuscZeKvhmzuYKQok/Mj5Omon1Cz+86+Cgvun9KrRNxDP35dR7Utdnv28qTriJGld
	 6DZm0AvqhFFZw==
Message-ID: <sashiko-outbox-191879@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mm-new v1 2/2] mm: vmscan: skip anon folios zswap would
 refuse when writeback is off
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>, linux-mm@kvack.org
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun
 Song" <muchun.song@linux.dev>, "Yosry Ahmed" <yosry@kernel.org>, "Nhat Pham" <nphamcs@gmail.com>, "Chengming
 Zhou" <chengming.zhou@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Chris
 Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "David Hildenbrand" <david@kernel.org>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20261030095223.325309-3-jiayuan.chen@linux.dev>
References: <20261030095223.325309-1-jiayuan.chen@linux.dev>
 <20261030095223.325309-3-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 09:53:12 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3155340002
X-Stat-Signature: sfx34swzku5s1ig84jryn7zi4ux1e6ta
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793440395-987252
X-HE-Meta: U2FsdGVkX1+ZUfu5IT2LuZoloihrjRkQbowAVsnwSIQhkVY7fI13pbvTz26+lRrTuU+J3gDvIFTJEqLN75b84uHxxZVwH5gap79vtdw8yHU8o/5KAmSWHcUTYwWtcBdKsG5Ma6A40xCWbFJmaBJltOIY60BniXGnFIkbfeO9PWo20V+H8pKyOy3GhsAJ0J7iwlVsmfIrEJiVFVXhSIUzPbVNf7Y+hIezVxIJoju3+g8/RbZ7/wHb166GJpelEHJUa2WAXHtaAKD4DVnS9T8GxQpEfD2Ix3l9zfh9cGF3Z7l7Yrf2PY1iw8amYUAqAlzfvYtq6J4qhp6MgQsPU0VAcS8YPlqW0QVXH3nUP8Um+Yi9p6cxW8bQuSL8w4HeBhJ3Sb5+lf0KXoyVpitZ7CDS89O+P5XaBN5rFy7glEG0jpHZaYfFFxzTw0evtLZtOmxAzviWSWKwnrYjHNGQK2FzA6vKox+6xn6OXpiBLGheCwb3pxYiXSxDQJLf+mMJXNi9YlOXGYMyRUNCtfGgSW79EG7WluzdBPzwzfXDJ1lxRCY6kWP4OsWVndYZgcGIvzxkgqA/UytE1MDgOLwP/EZ8txsrvqBRGW2K4lEDU+n4KgLdfjqx8vs4Df18eo4IHkp5SRaEydga7dHxF06uQ3Ghiou5J8wSSiduj07ncijsjNhQLNUrOHsQ56oaKdJLf7Sw3FaHCGxfk3FAzd/DDQ3ED+1yvQycgjPSxBYYLiOyn6IHeEMU7l8AQgr16zxnFy3J2XTOvzbzi1Fex8pfWhbl2i6YfSvZzLOqksvrKbD6pkvv8hP/4fdRYVqnpXgvTOoosW5Rm9At6asnfkh/hKXfqMBRFffbwWEOPh2Rql3U+kKGqDDB+W2IRtvEd5iH0OTQUjeZxM8usd4dFysmiu3qcRePtUY5yfTnpAsgVc4mKrG5idMq/nawMqAUq82UtthISwl3gJcltLbLysu69wT
 ETkEZ1Da
 exqCwRuyrQEYdctGNQXBOISxiVVFKpidsCx9HENavv3EG/XYhUp04WFzzE/hSxqPbL4UH+i/6dMyj+uvwa9ifrHnadHztpfVsYhfbeJl9hsYYnr8wvdNClYZ/JRXfUgbwU6NGXmXXJELZjIiJisbEphCWmQMBeiMuTjyji7FNLzzHM1iMZ4M4x37QmjqNk6Jh5SFa8r00MO9lxfzI/3H3UqLfrktrPuvIbosIQuTHHrAexU8LCQ+liVGhefG7eBQWgYzK19ZSmiDQeii5VGp0WgXc4Jqi6mJYAOWZAsU3iBJjKSzDgTIMmFzCXOdtihSxlqOpFyB+1waxKMAKtC80TURxv9spSqZcyuNJPPUMtoPDb0FHnF6yNmPDllvcf+qw+uFxI0RR90lFTeSZeAfOyhajs0bcWXJXPhDCjlMS0fxjXI//mDKtTyDr2Mog2oaARyv6H84MzgV4GfuJAISUSOL30AgX9r17PARvB+6NY2BsBMPqBBGWcCM+4T5fF4Tvqqc5G1jJ6qKBNo2a6PWxRPXKPR7nHi6X4cN6pixvzTUk0AZJMtHwVZgFLVZ0NPJxHl03
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] mm: vmscan: unmapped swapcache folios bypass swap_writeout_block=
ed()
- [Medium] mm: vmscan: large and split head folios bypass swap_writeout_blo=
cked()
--

commit 6d6f21b971f8e3a837e970c969d5f1fdbeb97cbe
Author: Jiayuan Chen <jiayuan.chen@linux.dev>

mm: vmscan: skip anon folios zswap would refuse when writeback is off

This commit adds swap_writeout_blocked() and zswap_store_blocked() to detect
when a memcg with memory.zswap.writeback=3D0 cannot store pages in zswap. In
shrink_folio_list(), non-zero-filled anonymous folios are activated early
before allocating swap slots and unmapping them when swap writeout is
blocked.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7ddef3b488b3d..591a98cd9ef59 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1169,6 +1169,7 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>  	unsigned int nr_reclaimed =3D 0, nr_demoted =3D 0;
>  	unsigned int pgactivate =3D 0;
>  	bool do_demote_pass;
> +	int swap_blocked =3D -1;
>  	struct swap_io_ctx ctx =3D {};
> =20
>  	folio_batch_init(&free_folios);
> @@ -1355,6 +1356,22 @@ static unsigned int shrink_folio_list(struct list_=
head *folio_list,
>  			continue;
>  		}
> =20
> +		/*
> +		 * swap_writeout() would only activate this folio. Do that now,
> +		 * before it costs a swap slot and an unmap. Zero-filled folios
> +		 * are marked in the swap table without a store, an unmapped one
> +		 * may only need its stale slot dropped and a large one may still
> +		 * be split, let them go on.
> +		 */
> +		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
> +		    folio_mapped(folio) && !folio_test_large(folio) &&
> +		    (!folio_test_swapcache(folio) || folio_test_dirty(folio))) {
> +			if (swap_blocked < 0)
> +				swap_blocked =3D swap_writeout_blocked(memcg);
> +			if (swap_blocked && !is_folio_zero_filled(folio))
> +				goto activate_locked;
> +		}

[Severity: Medium]
Does requiring folio_mapped(folio) allow unmapped dirty swap-cache folios
with active swap PTEs to bypass this check on subsequent reclaim passes?

When try_to_unmap() unmaps an anonymous folio during reclaim,
try_to_unmap_one() installs non-present swap PTEs via folio_dup_swap() and
removes the present PTEs. Once swap_writeout() rejects the folio with
AOP_WRITEPAGE_ACTIVATE (for example, when a clean swap-cache folio had a
dirty PTE settled by unmap, or when a folio was in the batch as zswap
became full), the folio stays in the swap cache marked dirty with
folio_mapped(folio) =3D=3D false and folio_maybe_swapped(folio) =3D=3D true.

If userspace does not fault the cold folio back in, folio_mapped(folio)
remains false on every subsequent pass through shrink_folio_list(), so the
folio skips this check and enters pageout() -> swap_writeout():

mm/page_io.c:swap_writeout() {
    if (folio_free_swap(folio))
        goto out_unlock;
    if (is_folio_zero_filled(folio)) {
        ...
    }
    swap_zeromap_folio_clear(folio);
    if (zswap_store(folio)) {
        ...
    }
    if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio)))
        return AOP_WRITEPAGE_ACTIVATE;
}

Because folio_free_swap() checks folio_maybe_swapped(folio), it returns
false when swap PTEs still reference the slot:

mm/swapfile.c:folio_free_swap() {
    if (!folio_swapcache_freeable(folio))
        return false;
    if (folio_maybe_swapped(folio))
        return false;
    ...
}

Wouldn't those unmapped swap-cache folios repeatedly run
is_folio_zero_filled(), swap_zeromap_folio_clear(), and zswap_store() on
every reclaim cycle instead of being activated early?

[Severity: Medium]
How does !folio_test_large(folio) interact with CONFIG_THP_SWAP and with
the head folio left behind by split_folio_to_list()?

First, when CONFIG_THP_SWAP is enabled, a normal fully-mapped large
anonymous folio is not split before folio_alloc_swap():

mm/vmscan.c:shrink_folio_list() {
    if (folio_test_large(folio)) {
        if (folio_expected_ref_count(folio) !=3D
            folio_ref_count(folio) - 1)
            goto activate_locked;
        if (data_race(!list_empty(&folio->_deferred_list) &&
            folio_test_partially_mapped(folio)) &&
            split_folio_to_list(folio, folio_list))
            goto activate_locked;
    }
    ret =3D folio_alloc_swap(folio);
}

When folio_alloc_swap() succeeds for the large folio without returning
-E2BIG, the entire large folio is unmapped by try_to_unmap() and rejected
in swap_writeout() with AOP_WRITEPAGE_ACTIVATE, and remains a large folio
on subsequent passes.

Second, even when split_folio_to_list(folio, folio_list) splits a large
folio (either for a partially-mapped folio on _deferred_list or when
folio_alloc_swap() returns -E2BIG), only the tail pages are queued onto
folio_list to re-enter the loop. The head folio (now order-0) continues
directly to folio_alloc_swap(folio) and try_to_unmap() in the current
iteration without passing through the swap_writeout_blocked() check.

Should large folios and split head folios also be checked against
swap_writeout_blocked() before allocating swap and unmapping?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030095223.3253=
09-1-jiayuan.chen@linux.dev?part=3D2

