Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C940606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hb+T1JfW
Received: by kanga.kvack.org (Postfix)
	id 7D67B6B05BC; Tue, 10 Nov 2026 15:56:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADB56B05BD; Tue, 10 Nov 2026 15:56:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4066B05BE; Tue, 10 Nov 2026 15:56:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4664B6B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:56:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6ED61C02C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:45 +0000 (UTC)
X-FDA: 85420418370.09.F1EA6ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33E7C180008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hb+T1JfW;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344204;
	b=JGMSvyw74/7x0gbVtba6AKdoflsvbk7TClkgTustC97i8ksZm1zgjsXVGcnschPyl0hM3s
	qSUh/cGo/YY0ZYq3jH8BzdnEOjpK/s2/xExOA4KtlwDGhkyjQ6pPIkou6qGrr1on8LR2Q+
	6l7GMZpqRDqn+hzRg8gp5nLiUo58gik=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hb+T1JfW;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344204;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C59l5yjEcpPoOE77GBwwC572wfRdG0uqhTnZS6j/vg8=;
	b=z97AtMu02gPJc9VfGc335XS97ylkCi8gGEF16o86YEPwWbhFbUH1vDWFPv2VPgbmZoFu3/
	ChLtL8ZS++i1q8eh5C1/cCWd4lCEi1cKmfD4F8nFO53ERK8cR+uxIfNzfh9Jh0fKfNOs5A
	CQDgojV2r3P0GBex3FxT/n5+dFhFy3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E34143E83;
	Tue, 10 Nov 2026 20:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461F31F0089F;
	Tue, 10 Nov 2026 20:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344203;
	bh=C59l5yjEcpPoOE77GBwwC572wfRdG0uqhTnZS6j/vg8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hb+T1JfWtIQLt9lEpnqY2Z0a2J8Ap9UFi+VmPb2nAHT4iwmQKPELs55EOatrtIkkn
	 tJKXXMQEw6pK+INlMh6uP1ABEH5xvB5d4MnZL2aY6uhsjFWdcH21qCLsg+/wNHXDrq
	 4/F3swc4aQ9xmq+4mtKl5G8dFgYXaRBI5Wuxafmreu7lpgDa2TOpQHACvTUZazCR4v
	 6+vJ2AX3pwhs2mzF/rkAdFNHHQxNOP6xEw5OAxfEsymaf7en0bbRJCJs1Hk00wExlY
	 ZSGapBfKclovo0brnvDDFZ/P/Yr5EEkuUzFvMmZzwWsIbYCm9dMeHhmXYOc6iTWbjT
	 UwiUtcBkSIsDA==
Message-ID: <sashiko-outbox-207746@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/15] mm/mglru: Avoid placing rejected folios below
 populated gen
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261110202025.25736-10-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
 <20261110202025.25736-10-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:56:40 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 33E7C180008
X-Stat-Signature: zm83c44f9ysgs94pgw151khrxhq7a4as
X-Rspam-User: 
X-HE-Tag: 1794344204-865663
X-HE-Meta: U2FsdGVkX1/3NWgdWF1uSCJ9kBmqm/d79J36YbMm5hwwYYpcHFfO+Lwa7yZ8uGJiEpnLlV0Z4Wnm53GPeXApW+v01a/CYTHBdvIsvANo8FZ0ag8hTOU3tJTndCAsnuMGVfhIE00XfGsAoBVQUarO4QhlqpXhfo7fpWVK+B5Jep2BbAADbchrY7h9K9h1zoHs5uporVr3RLVpMGwWBFFTZyR4X4PbedJdCgcgpyt0lidSxU00IaZLGk4Cj6UG6BSNx8RG1vLGRDDnSAIQhSg9lEMTI51YLopRIMppWl0iK3lChSbPZioX2LzZgJchTE62xa35oJa3C6fWe992oJMlacnUv2nqoPcWsmDxginXqIkIbT9SiYzfhZFuFZ3/wNYesw3Wp6XDwBPB+scM9CSJCe4APXgbqiHUF40IoZZjol3Z9f+HBssMMv05YTW+hBBGwLAOgqyMZ1ACgmjpZa6/fRVN/w4em1PSS8gaxwmXqBZ+5TnsVvozE4invWX5E519rxnfLpByoeNj+J7OQ6Y/kFy857x7dmdqgTPFs2SWCp6YXAmIMaOrWKYDlfkbne7YH/Va/rFzY+yQENSPkrhvtaLqb1qeV57NZ2Xr9Z2KRaTd3ja9Jeu4j7ni0D4KfYE6aC75M3FTh5nQ+v3AD3nzYVmsLIy9ZCXtJaiEhHpFobS0sxjc5nJB8OZzweZ9q8sdgKuvcHYFqMVSgPimUpku6kyOWIZpm1Wst6k+C29qguIgsxkVpMzV8xR0kie94lWjYgH6TXsswq8X+pcd1HPcyQb/F+7t8ZnwwgIPfC7fCDED648+DGf4r+Fv+Befh6WZuLB1f8bApLhOtuPCG/8DMRH+HIz6RZz75KrWlsbsWCDu7KufFV/EGKUiR4XLPmXzS1Lt0B3X71t4yBRVNctGY4AqH56fqGSP0NYPDeHGFFw07n/TaTtpztsz0sjuWGMtT+dU9IBBktLG/Os0UEe
 +XkRUHws
 6Yk+/dB9W7ZaXtewoCvtyFUAtAxToiXY2J/VRbrziXSX8XG0Gr26S2DFKLTQE6rlSwt65APAjA7afwQqHkwBMhkFz1joTu9UtkBwicBM8WK9OCbWt8njGQfcwkVFBNRxk5gbqgnqdayqTUIXkEGh8MWMgy1h8iG0Mc82j/KSSOaH0DI8YfEfc0itgKgEI1KtUV6fxw1BAb0WymxGBvsr9gaJlOfv6s5qbJEcb1KLNlqPPiFnJ9s11LHr34OuK1/82mdXPtQKxIUat8VD/XtWT+P9mgr5e1UYSfOLNfxNver2g6lPQqgLfTxjLWWcE9wFoRD0tUurNW4m6K+qm1ovuMcdZDSl1KqAfTO1NFzr2t2+u742XdJTQLsktWi8uxlNUzzPLYmM1rw/zuzXz8U25mqOKuyCzogARGV43aem4QcnXudIdYzwsLYQNigfUDFGaALoo49big1ip5hWSQApXEHi+0tR+xLTyZKJhrcKqNVHZCRSJsp7aNCS4JuuwV6ulx36iQwWEJXVD9vZvihlGqcLsEPDEohK16CfcKAdWIvv2d7T2Gbp1P7rUg24+B6gGkzztfC43IowDk8sjIacnceEsFDdj0yCn8KtRWQgkdrudjqa5Fgtou9ZUGs9iyQf3ZA5ufABImjaCD45rtUvWDEkKc5owl6CEVj40XGJO4HFnOm4X5Sg71djGnkQgVbInt616ZwukI992bW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] mm: uncleared LRU_REFS_FLAGS in lru_gen_add_folio() [1]
--

commit 8ef17c06cc7c92ed5b07f7cf40e28066a3ac2fb0
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/mglru: Avoid placing rejected folios below populated gen

This commit passes the scanned generation sequence number from
scan_folios() to move_folios_to_lru() so rejected folios are placed above
the populated generation or in the youngest generation, and removes the
previous folio_set_active() call from evict_folios().

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893f..f6f4bc9a704fe 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -332,7 +332,8 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>  	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_=
seq[type]));
>  }
> =20
> -static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
> +static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct fol=
io *folio,
> +		unsigned long scanned_seq, bool reclaiming)
>  {
>  	unsigned long seq;
>  	unsigned long flags;
> @@ -347,6 +348,8 @@ static inline bool lru_gen_add_folio(struct lruvec *l=
ruvec, struct folio *folio,
>  		return false;
> =20
>  	seq =3D lru_gen_folio_seq(lruvec, folio, reclaiming);
> +	if (scanned_seq !=3D -1UL)
> +		seq =3D max(seq, min(scanned_seq + 1, lrugen->max_seq));
>  	gen =3D lru_gen_from_seq(seq);
>  	flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
>  	/* see the comment on MIN_NR_GENS about PG_active */

[Severity: Medium]
This problem wasn't introduced by this patch, but should set_mask_bits()
in __lru_gen_add_folio() also clear LRU_REFS_FLAGS [1]?

include/linux/mm_inline.h:__lru_gen_add_folio() {
	...
	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
	...
}

Omitting LRU_REFS_FLAGS from the mask leaves stale PG_referenced and
LRU_REFS_MASK bits set when a folio is placed into a new generation,
inflating its tier access count and causing cold folios to be protected
from reclaim at the expense of hotter ones.

[1] https://sashiko.dev/#/bug/linux-d2209941-6149-4b37-a97a-08c70d875d2c

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.2573=
6-1-baohua@kernel.org?part=3D9

