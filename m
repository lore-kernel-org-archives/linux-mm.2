Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60401606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nvNRrQqJ
Received: by kanga.kvack.org (Postfix)
	id 611136B05B3; Thu, 12 Nov 2026 00:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8C66B05B4; Thu, 12 Nov 2026 00:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE6E6B05B5; Thu, 12 Nov 2026 00:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0FA6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75376A75A9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:00:58 +0000 (UTC)
X-FDA: 85425267396.29.980BB0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C808E1A0008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:00:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nvNRrQqJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459656;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XRmWr7dNVJxcz6l5Tkm0MCV4PTTQSgIM8xZsGnAf+c=;
	b=VQrnPxKkM2k2Z0GFUsACBLhFPgN9/CstsyjHXf1rsXtTXq3OI5e1VcYEKv0eQmj6k9Y1wZ
	jTGgntPmWE6yBJGp+2j7LVF7FrWHG1O5A+RhpF+7oSD/49SymwNx0P7Ttc4QtISDlUzqU2
	Y0PkB/Os72UHo+zVeOgCTEt1hXwgeCU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nvNRrQqJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459656;
	b=CccCPj52Lc2FqxyBof6YHIsyYUTia9kqEJVAQ5iZByoyE3Cj8V4pt6WR0n1s7K1rqe5mCK
	zq6V/FzWUcmVnt/X9uJw6V6pfkttcUmbg6kgiPLR+tCKkaxLTzTJUK4SaU/sjs2lUtytX7
	FG33982KzlM8iQ+VaZWCLCYlOhzlZYY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA30A61878;
	Thu, 12 Nov 2026 05:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421421F00A05;
	Thu, 12 Nov 2026 05:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459655;
	bh=2XRmWr7dNVJxcz6l5Tkm0MCV4PTTQSgIM8xZsGnAf+c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nvNRrQqJhJYvfI5oEdQjF3zfGCs2xrQGpm+w5U4YfdYoel4zcj99l63qxsudJ5rJf
	 heiAl8D0BXJuOpbbx1EttalagqBHw8Rv/V/RC3W3JxIx/vjXDXIAtr1K7jsVt+dLzL
	 u6LNRFW9d2LmPQeefofm9f9OfkQ/xvY391cNT9OGiN23jROJvgmBeBG1aRvK/U8Agu
	 /RC2Z3R3SPWfUhXsmj+ikh6d0TOGPRjqr2bXK5NMc84MggHhSs+Zdxno87zdXt874M
	 PQeiZP+HwzRh0kej6H9a3/Z1E1obaKAY8gc8F5yA0VvFI0HwCs3eCcJpkiFa2+1xJE
	 N6/NY6aWzxD6g==
Message-ID: <sashiko-outbox-210410@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 02/16] mm/mglru: extract lruvec_populated_min_seq()
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-3-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-3-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:00:53 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C808E1A0008
X-Stat-Signature: oar3n6641xqcmo1r659wqbosjckrxyip
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794459656-764016
X-HE-Meta: U2FsdGVkX19R/UNTiO4NdiQbMfUoPqtWZ/Kl0jvIRD627DaQvwNie/jm2tewwIr2YyR9tGBk9t0789AuWRy8WDn7Zoqis5dDd20kFDv7N7l6lwcHV62F+1mjLDQtlUTiwaH/N6ejxx6WK3MiowX75azOdcOLBYtlK7nYIvOMfqV6MQKv/uyJlItIjDv7KBMCmrjf0Z9tUbLOnj3tQwQhXGyUpraV5SiT1J1r0GAdz4pUG6h3V2BFbvKkbtqRLTTbEI1PN8qz/rA9fAC8MKVru7Lj8KLgiaCOx/tohsLQCgonNyCvDXhyOnWgdRg31S/kNVL/3urUmY2d/mVmbtCBH6QyYf9kgF4AmysVRSOeuTqpfV7XsnItNinNlqjE/qR6eid/vgL6OPvFvyoukcELDs3Irlxx9LmlGmMusmr2nTYIBy3zpUo87wHcR9wJqrVhTDcVxQjoeMgnxSX0gynSOzO1hTFGeFJUQnWKlwXMo9Y3Wz8F2g2raJQ0YQfVwWu+DYCg0pGsvPWrL50H4T+b/UlleEkHvR8YZnjFeuJsyR62Wkh3WVBd0Ho1jthwFW9+KbWJ/tySSByoG/BjKYd0fSl5be3vkeZd5i6df7CWM+CUxhfPE/0As0bmBB2UzazPu0i9vmhgqhmJbzDfM1DqmKjE+jKQae9RqvDRU7J+iLOFpEWJNjx39Mk1F6VJs/LmQhlI06xBkRVwOLv5SBgrkfYnp7RW4FofYGIdNqMkr97R0r07h7l6NwoirxzlhumIojasY8vaPE7IEX7E3MtXNH9gEU8DHPy8WMocXPSUvqvNejFY+vI1vw1hIRRdPl3B11ainz0N0eC6BqQlKuaer6b2VphUxOa4COs6Ur6ToVh8C/mr+u1VLoeP6C6AJbRHZiIB1jtq1BcZnoy0YAob5+BU973mMivi2hDuvJfCRNgtFTP63vI3t+DOaYsJMstkpxXSI4cjI6Sbe5reJWu
 5n3rkFpv
 HtzEPC5wVahWU6WSz2H9W7YfDFgrgcNYdUIpSubsFgc+awwzuVqxZqN5AIt/5i3WP/GxpQOhcTkEizCpkWlgJ/wd19rBy+DGdArozBsnUwE47cx1bXQ/ViLtBn70yLalPMZ65Q+G6RZARIfLjFLi0cmmVvBJLZuOUsk314H1jPrXKd+Omjyz36G/LblzFflFLellI3gfXY75UJBRXP5RZyWCVl14MngW8Q86e5LDAvPLKX99zifNF2FSfSjS1NbkANqlLecoT4yIh5squj4z5VYJ9/et7XP1tB1dhAo/1/PE4FS8MuS8JHvppltDLP9i6qT6IyETdGhA/3aVB73SgqjHvpIv7JacQiHNeY6f1F6iOrnhZWix3EX9jKBl6p71z2O72+oK6OO2Qeqo0Uw1cq7pJE81SeaW2asZ31+0/SXUziMX7l29LamQ6DcfykxNZIN80hUNvhqPcI3NPt4t3SNdQzV3Ghw5GL4aElg2cyncGnWq006AFDUqmVvjhHo/o9tXD4hFOho3GAPoKOPLu8KKEZsQOxmcNu8FTyXvMmTKJxfcx+AQRzImeFcfKEogyoBeDclEqhNjFzG9R1eio4SSe773e5tFcPQmIB+cVK6n6PFb+crHLVEHRfhb7DRljzEwSb11llaS+DslQIe+95cm9/FZK0Nzj611Mzi1sNZS9iyKpmEbalGbtIFrcLGrBmIG+e6Vif6t6v1E2pkukOBSxYY92mHrBirCPTVqPvSYGdoV+S1eRVax8XReD6YdWkRBzDOFTgNBOSQQ=
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
- [Low] mm/mglru: shadowed local variable seq in try_to_inc_min_seq()
--

commit 7a4927e9f0aa8623b1c83f69afd1fb935c342dd5
Author: Kairui Song <kasong@tencent.com>

mm/mglru: extract lruvec_populated_min_seq() helper

This commit extracts the search for the oldest populated generation of a
type from try_to_inc_min_seq() into a new lruvec_populated_min_seq()
helper.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ed224cb80a75a..f98cd483f014a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

>  static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
>  {
> -	int gen, type, zone;
> +	int type;
>  	bool seq_inc_flag =3D false;
>  	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>  	DEFINE_MIN_SEQ(lruvec);
> +	unsigned long seq;
> =20
>  	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
> =20
> -	/* find the oldest populated generation */
> +	/* Requires at least MIN_NR_GENS gens for basic functionality */
> +	seq =3D lrugen->max_seq - MIN_NR_GENS;
>  	for_each_evictable_type(type, swappiness) {
> -		while (min_seq[type] + MIN_NR_GENS <=3D lrugen->max_seq) {
> -			gen =3D lru_gen_from_seq(min_seq[type]);
> -
> -			for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> -				if (!list_empty(&lrugen->folios[gen][type][zone]))
> -					goto next;
> -			}
> -
> -			min_seq[type]++;
> +		min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, seq + 1);
> +		if (min_seq[type] > lrugen->min_seq[type])
>  			seq_inc_flag =3D true;
> -		}
> -next:
> -		;
>  	}

[Severity: Low]
This isn't a bug, but adding seq at function scope causes the existing
inner declaration in try_to_inc_min_seq() to shadow it and recompute the
same value:

mm/vmscan.c:try_to_inc_min_seq() {
	...
	if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
		unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;
	...
}

Dropping the inner declaration would avoid the -Wshadow warning under W=3D2
and reuse the value already computed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D2

