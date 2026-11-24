Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4312606A322
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHIu/9LF
Received: by kanga.kvack.org (Postfix)
	id 4EE306B0653; Tue, 24 Nov 2026 03:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A09F6B0655; Tue, 24 Nov 2026 03:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB636B0656; Tue, 24 Nov 2026 03:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3B26B0653
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:59:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 837921A0AA1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:59:11 +0000 (UTC)
X-FDA: 85469413302.22.959B8D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1F74C0004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:59:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XHIu/9LF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795510750;
	b=Xm7HMen26IWriQB06i6jYR4fGtGat1t/xIjJMJc2nTbNXlHBlhgp8sf/9meyrGHoFBxTGs
	NIFgz+WFOw/XC7oHdznmfTxyQo+O50VHQGEFcuX/KSL1TuUM/Lw4m6LEZECrNuPeyuMqvo
	SpxY/DqsNY9LvLQx5YLq9QvLszShLKI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795510750;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKc2RgHdsSPfMVso1E2ZpztCTiensS417Puly+AKXwM=;
	b=f283Xuk+6sLi58RFxdXSuHPC1bcRhldWq6trfXugu2HL+AO+fCOAntN4PLC/APtm/jrfnR
	+H7/3m+lM6O73LMUWHcvTIv76gmua1rQZuR/PxdHiOyVBxSMu9NG9d60Ksn0/x3XrmL4uj
	S8lrq7RUvUu4P972JRY4XVzmy2vqX3Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XHIu/9LF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 913F662533;
	Tue, 24 Nov 2026 08:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A66D1F000CA;
	Tue, 24 Nov 2026 08:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795510749;
	bh=QKc2RgHdsSPfMVso1E2ZpztCTiensS417Puly+AKXwM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XHIu/9LFjN/DvAus77b0vGGRyGsbsq1docRTCDHpqU0MICFf9XDI/Fpnv3RH+4qIv
	 lVO7toaA90GEsqi2J2MedN7sM94X2HdW/LWnMwMzoXpYlf6nAf6C94ri5wsc55pzz3
	 Yv/7rmB1F36g1f+H415wWHOxXQycuEuT6/l/WuT6Fqel8ncvWkwkkniryFz/Yh5if9
	 krCE5LXIf1pYogkS+lWeolKbC29i2K5gY65Hy3fD08SVMJDz6eJN8ZcgcJA8Bq0pKG
	 xQu6XFxsqFky9PhcF/WVvzyqAA5QkvwABML6peNlXnc66un3BiwcMhwikEXYCDNmmE
	 THnCqEp5cbDgw==
Message-ID: <sashiko-outbox-230767@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/4] mm/mglru: count PUD subtrees skipped by the
 PUD-level filter
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: david@kernel.org, akpm@linux-foundation.org, kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baolin.wang@linux.alibaba.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261123085800.981256-5-baoquan.he@linux.dev>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
 <20261123085800.981256-5-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 08:59:08 +0000
X-Stat-Signature: koj9e4ffki57iys49p3se46cx4tirg14
X-Rspamd-Queue-Id: F1F74C0004
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795510749-593511
X-HE-Meta: U2FsdGVkX1/VVwameSb7geVWEf0MSEgdjoTNkCzDfYx1ZgzfnLJxVsODkRaGGBJAG17KAxPoYKhIHuTeNZ6DwH1vaX4p07jc+eIUo0elqzTiZ2QbpczP6ut6FtI5LjazXR68zgIIH0jSWMugEhF4gjMjw3OpJrPfHqazMc/oJZ31WYWTeOVT7FCTZYi+C7Y94C68zZxkfmaBxykepwWmoQObCA1c7QvNLT5a1HYCpDoleh276+NL65TzhTqXgVZgzxSm7sH7jsFjEgA9xy5MTpzHjYKaeQMsL7ZMj9+iuqDjWyfoN3B3Zwcd9uD8N2xh57phWTJSN7CAFzcghvAVDoPNVJaD7d4MtH4jiaBwctPITuNq5e2XQ9IyBMpwdf8UQHUSHShvwoHsaF3PUxKjkEtsD59FLQ+dCO164YscvPNcyfmT+7fPi5qdET8egCuwWkacs/ziWCkHV9ZdTTBiFL8DTLVpU7xMpYfEeQFgdJY1CoVkCd5QLdt7Fbs+hMUHylWWLTauMN0JmVOdQC0/YeTvBwbLfEmfvxKf15nRc7A4hQex+xeWceAGfsFv1GTcis2648xTlfll59mjW1dpytfWKKW6xK+3kUK/zK7eYJtIlMR6E1o+aGRLMBTUKifdrsBdsPpuRjl3uPNimX11/u4NN2mm7PyY7fg1oGsUNxJaMK7ISAMi+M+JEnDIQ9YYSaaHmQsEg9oQXUgRlJVEq07aYf0GNSdbyo7qScLHo/BUE6TgYzIxzObWCuGgqW9qzBClF1tuaIlPJljY7y/HTy7IJJBAGBUcLM8yAcELwvoh4cRysmIxk5HOp0hnxof2U8DGah9BkvODBHm/w925i5X0cW/kLCSEqi7bNteQQuVbFgRa3JOwwVzGJM2PnrsA69T8YwupNQ0IPYrgn+kIh2yQ+b8EnO4tNmUPNej732/KfYd8x+S+M0WDLt6osspejuggtM/FAs+cQXQa0VR
 2jKmdOsb
 6Hb7OM36Q51cCe7a1wJ8SwT0N/Euj9k81LzjodGnx89KV88/CDBbeT/hx8VaaPkLxiDgXPxu437wp/ONEQKJo65tj5PcWztHCvdTvUaAPNxNvezliQn34a+wqSi8SklQ0AA8IHE7IS3rYtNWrFzVwlYBEj4Q3E7UnOzhVEr3LdeYaKFd5mbeF0BXJiFct7APZQQWpPi427qB0Z1OGkgOKiqlALq4eKsFeLPdpEwYuvdI1pqiVnWqzuGKG/JUtyt0D/kSgy0bwPJhKl7faNYmXC/XIB5fhtyX7gND15uM8VoAW0uryMFJplTddNlIDepLfJS37hRkVkZLRWH75EFU/OwEK5KHc0+MINFIXFkCvgpwuGNZ53rWj0HkCURzPpSv+MV1+9dWiws6x+ih78LZezG6FwA8NnjSOFmbOIK0T+zvXV6SC8c7gx+TLMQ1fvDXQLlxrvqU5ncWks3dEuiJhQXOa99IUj7cK5ZTV+oF/QBxthEV0JX20UYd6Kla/vfbop0+PxlfT8uuOkR//fxbz93HmZ9UTHenrVKn+ibahc0uQecrebiQuswFRViktT+mVddp/Pkkx/qKw9nNo7NzldTMUk9Ry23RIL1c3/hsXN6zkmyhcm+djU+fv6TPebmBM0xUZctFajYlVYzqsZ6IKLrHxNsrqYvK/PB4FbYpy6Nc5xo8ERexepcSuPOUJ8/XdyOhot02qaMzqM0kk1MNiKF+QJxKXWHl3k6GoY0Q1TBXZIXRQ/wM00fAw8H4OidP7N2AhoBXhuK786H7DWQ+LFiAOddhXFnKJUzir
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
- [Medium] mm/mglru: lost young return from walk_pmd_range_locked() in
  walk_pmd_range()
--

commit 3dc8080e8c434c4239bc40252f11504dbbdb29f3
Author: Baoquan He <hebaoquan@kylinos.cn>

mm/mglru: count PUD subtrees skipped by the PUD-level filter

This commit adds MM_PUD_EMPTY_SKIPPED to count PUD subtrees skipped by the
PUD-level Bloom filter and exposes it in debugfs and the
mm_vmscan_lru_gen_walk tracepoint.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 517f5fbecdbf7..56e18ffd3383e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3836,8 +3836,10 @@ static int walk_pud_range(p4d_t *p4d, unsigned lon=
g start, unsigned long end,
> =20
>  		/* Skip a subtree that had nothing young for this lruvec last gen */
>  		if (!walk->force_scan &&
> -		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
> +		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key)=
) {
> +			walk->mm_stats[MM_PUD_EMPTY_SKIPPED]++;
>  			continue;
> +		}
> =20
>  		if (walk_pmd_range(pud + i, addr, next, args))
>  			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,

[Severity: Medium]
Can walk_pmd_range() drop the true return value from a flushed THP batch
and leave BLOOM_FILTER_PUD unset for a PUD containing young THP entries?

When walk_pmd_range() encounters a PMD-mapped THP, walk_pmd_range_locked()
batches it into first/bitmap and initially returns false.  If a young
non-leaf PMD appears more than MIN_LRU_BATCH entries past first, the second
walk_pmd_range_locked() call flushes that queued batch and discards its
return value:

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

Because that flush resets first to -1, the final walk_pmd_range_locked()
call at the end of walk_pmd_range() returns false.  If no subsequent PMD in
the PUD sets young, walk_pmd_range() returns false to walk_pud_range(),
which skips update_bloom_filter() for BLOOM_FILTER_PUD and causes the next
generation's walk to skip the PUD subtree and increment
MM_PUD_EMPTY_SKIPPED even though it contained young THP entries.  OR-ing
that return value into young avoids losing the result of the flushed batch.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123085800.9812=
56-1-baoquan.he@linux.dev?part=3D4

