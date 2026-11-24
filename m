Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDAE606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QwlNMuFV
Received: by kanga.kvack.org (Postfix)
	id 2F1E36B0651; Tue, 24 Nov 2026 03:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2976B0653; Tue, 24 Nov 2026 03:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF7C6B0654; Tue, 24 Nov 2026 03:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC5B86B0651
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:59:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 690861C456B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:59:10 +0000 (UTC)
X-FDA: 85469413260.15.1ABEBC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CF3D91C0008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:59:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QwlNMuFV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795510748;
	b=yVUn9zKzISwNtq4su3/DfTFao4LhrG/yZ0m6YtVaxjw4VjxqNQ+348mz0VXNv36Cys18R1
	H0wj5WKMz64T2LWZ34waHtqDcZEr8Kb0crlXJoHG3Rhk4TUsbI5OqJkJeazrKarzKkxDMu
	mvPaS7Td1r9Cqr/RKRH3TEY4NPOZqvo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795510748;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAKF/Q2pmPmVt2TNNvB/j1w+Jrbj+upxvRexn60ZzRo=;
	b=20QYA7HzJaNr4Ej/lQODZVv68CGZX0vjyFYySEWzJVo5h33EcgsEdNiTHGxj5iRoqVKmQV
	xdgx/6Ono/yeTckvVjslIpIlq71C/+LUc4P6i16e7V0Wt/tpspqodRKrbPe7AP9RwS/bne
	mM7QqJQOzpeDRklQ7XWAaPGhfYfP81s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QwlNMuFV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 562F662508;
	Tue, 24 Nov 2026 08:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACDC1F000D4;
	Tue, 24 Nov 2026 08:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795510748;
	bh=UAKF/Q2pmPmVt2TNNvB/j1w+Jrbj+upxvRexn60ZzRo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QwlNMuFV1S6sc7/NW2CHbPQPGy6JzHF6xDygUMVz7YRQFeVYAbDjw9Zo+Asi8N4Nm
	 IhqXPY1jaJAMGXgE4tBE6gbuL0+UMtk9FbbhilzqhGvVx3NpqlRvowUooJYo4WXZon
	 d773aIq1pNwfYQbD4TghuTS4mmXI+FUUUO9unsiGJ8thx00moH1L2KGqtKnXxt2qtE
	 rCW8quRwTS28/fcfC33Sn3OR2JDrj5L7EWOsvjZZubuctQBvmLZXJjRG1OOlGPRiVz
	 h9N/OG9jVAVtaRwDywHZZpF1VphAzctDyKFn1NjHbrHoKqZ+oMA3CpbkQ+vQbI8lug
	 nnSXzncpE0ACw==
Message-ID: <sashiko-outbox-230766@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/4] mm/mglru: skip cold PUD subtrees during aging
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: david@kernel.org, akpm@linux-foundation.org, kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baolin.wang@linux.alibaba.com, "Baoquan
 He" <hebaoquan@kylinos.cn>, "Kairui Song" <ryncsn@gmail.com>
In-Reply-To: <20261123085800.981256-4-baoquan.he@linux.dev>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
 <20261123085800.981256-4-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 08:59:06 +0000
X-Stat-Signature: h7hk1n3gjb8ekztn9myyibzyo9c3uxd8
X-Rspamd-Queue-Id: CF3D91C0008
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795510748-628176
X-HE-Meta: U2FsdGVkX18WD1K3LWIcDLA2bZ6x5LuMXMayHxoKS14BRnFMGaASF8y07ayzLMDnnzgNFcbmhnD35CLhmTjBVw/lsQz0w8GFgPehg0p/4ozIaT4rBMi3ItXF/OHHt7XqJRlJtGxuroDMJ0kAQSmBi/ealkBGt7Oy37cmmx7yHdd3LVspAL7gQXwI3SxIYM0uGtP/tFH/Ad0tvZlWHX0MrmKHWFul8Xhv57FgMUPHCUWxuAnDiyjMR+NILUIrHgRptmNrZofiij1QL64L1E/tS+w8Qj54aYq/QRAaAvz39NTeEJs/Dm0m+bOE1Q99kd+AmQrZ7Sfkll9stQGFzy816cf/CsqMV/d5hPtEcAjdZ+o6M+IJuDgqSn8DPwGUEngxVaauZnKaC6FMZAyMWA4qkI4ygUNI2X2rpWszauWklzf2uPBMrHUpZ3fAMxUSGRNn+2BesFpoduRiNyefaf2wAdhXOevjXSsviats3pcJwK5UnThEG9mwap+NmywnhY57PhI5TGFNUnuEFrpnQ9h9Bbml8d5gwIBEC8vwz+RMDOatoOgLH0/bEFjHOzvYXm5wwPSUuaF2bY+6tG/n/81V2JmB0La23CyFzUQh8dzPtZYwJlJQLyD7XQe4MyvX2+6MvWh2T2OqfLyYqlH8LO1VJGImraHDlcu8b6W/43mCgE2UKVIyOoxKyOnwZ+Z3grgbL34ixIWBPVs/v5XXpdHw0rRZYgqc2V35Sjvvm0YjfmGhcMXqxSmCDJZtCUZ35AS1KRpvlZRCemaV1xR6PwOxKjGVubIx8YzYiEzlkU4NNNmiqCyFOizlUUEuN+q3bKWFcVIZ/7cPOhrKNzPsDrhluHRFNdJqS1Vc3UVcGma4kOP8WQARUJs3+hmBuQ6qEGJ/MaqjYvHXRbXUXnOdzO3tYVMk7K1JfXfoxQw9E0h9IHJXzn2qRRvGRruIGD5z5Jp1QFSY/S8z8e5AJkcLTmc
 nFBaNjnU
 RdZjhOo0OQd7z7HjKUlxDBLftqDinaIln9nfj+GcZHnz+tpku/GuHP0JQAVydPzu9JXONu+4zqFgkwtfrENtTnP8LkSj90nIxxeWNgt0SCSVZmmvmEPM4Neq/arcFf4cGFH/Y/Ed7r5IhP3rseFgKzcaeJwotmhis+CXC8IERol5BqKC4sptc9M2Xi69q2cVPJGnLRiYA5FoXHpf5erVnAV0F1mOrMerhoKo2e9ar75JGTXOc8mrs4/SgYTTLnTDrFzsgwc9uUHs/GJri7Xsdl491/NxQPT/df6F0wm8O5lptcXZL8JmanVrt6RvFofdv7J+ZWykJJzNdcyO/jmOITXx9eO+R1Yx9dyYXRAVvm82qeQCl/krXOJA89mN2UJadoIimvnT72y38HgUisCR86CPskMv2H3Ydce0PEs8ua3X/NsP5SNlLbFd9xeWhBBykgeRu3G21121OTr8GqoztQZ3FHmFb62vEGbPfWK9ADjMI6+v2PrS0EuSUQtN9Oormdz09VYceIyi7ZOsZkAKQlroPGaneOwY1hgKpP/8btaS1sLtZijSxzdAEDdXaC5Rj7mT9ZCAlskiavaVj2CAqEY9u+N9ps5KB6cJfVhHj4rOBMCq9I/0bXhIdz4kNttcFZzZsBbzjuyOI2r2gxvT4+8LD/SC6cPvNy4Jz4AdCdxfGLwo9aDZZ9hbSaMsr3y5en8GiUFcHdNzubHi41z/esuN9UfwVa0exyjqxfPdahpUnPjZHeOJBnbF/qdBdXK+JJg7BmMl6zIsdH3vGoOMIHDXkQpsvoiLLT3Zr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/mglru: lost young status in walk_pmd_range() when flushing
  THP batch
--

commit a67d5ce39733f49dd06a525e19b6621ddfe22558
Author: Baoquan He <hebaoquan@kylinos.cn>

mm/mglru: skip cold PUD subtrees during aging

This commit introduces a PUD-level Bloom filter keyed by (mm, PUD-aligned
address) to skip PUD subtrees that held no young entries during the previous
MGLRU aging generation, and updates it from both the page table aging walk =
and
the rmap feedback path.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7d20ee1b6c10a..517f5fbecdbf7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[ ... ]
> @@ -3750,7 +3766,8 @@ static void walk_pmd_range(pud_t *pud, unsigned lon=
g start, unsigned long end,
>  			walk->mm_stats[MM_LEAF_TOTAL]++;
> =20
>  			if (pfn !=3D -1)
> -				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> +				young |=3D walk_pmd_range_locked(pud, addr, vma, args,
> +							       bitmap, &first);
>  			continue;
>  		}

[Severity: Medium]
Does walk_pmd_range() lose the young return value when a queued THP batch
is flushed by the second walk_pmd_range_locked() call on a non-leaf PMD?

mm/vmscan.c:walk_pmd_range() {
    ...
		if (!walk->force_scan && should_clear_pmd_young() &&
		    !mm_has_notifiers(args->mm)) {
			if (!pmd_young(val))
				continue;

			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
		}
    ...
}

Both PMD-mapped THPs and young non-leaf PMDs share the same (first, bitmap)
batch.  walk_pmd_range_locked() queues entries within MIN_LRU_BATCH of
*first and returns false, only scanning the queued entries and returning
whether any THP was young when a later call exceeds MIN_LRU_BATCH (or passes
addr =3D=3D -1).  If a young THP is queued first and a young non-leaf PMD m=
ore
than MIN_LRU_BATCH entries later flushes that batch, the non-leaf call
discards the return value; if no later PMD in the PUD sets young,
walk_pmd_range() returns false and walk_pud_range() leaves the PUD out of
BLOOM_FILTER_PUD for the next generation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123085800.9812=
56-1-baoquan.he@linux.dev?part=3D3

