Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9FC606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IVZyQmPp
Received: by kanga.kvack.org (Postfix)
	id C7B096B00EF; Fri, 13 Nov 2026 21:02:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53B46B05B0; Fri, 13 Nov 2026 21:02:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90A56B05B2; Fri, 13 Nov 2026 21:02:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0696B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:02:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3611A033B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:02:19 +0000 (UTC)
X-FDA: 85432074798.30.6D96EA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 521AA20002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:02:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IVZyQmPp;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794621738;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/BUAcWunD5avy60u0RgXgnkoExybgKO9qdpG8t6BKo=;
	b=nLjgmxkd6MAXyqs12frSW0rHwMbxjyLBZQcF1PLsDU4pL0+mtIwigfI/EmlJ8xA40LFMJi
	Mu0qUoi8xeYta1qEJPFcjLvryJHU2bvNn/vr8WtM4a/0IzTmYuVuAAuQJVR1xrLhgopxkv
	YHppAtdYTdp7/wgxCzvtDQRZDUxepD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794621738;
	b=5btG+mfHj2p+8b5+AQSs57k1GDR2mlC5tvswV8NpYdbDvlzYHg3DXZFO6OJsuAuXSjJppt
	LUZfcDqIGAREl/xuHApaSTV9EFh99B3PN05iNfZKGm9XxlNYSAVuZE2WA4H0TBU36DPyge
	F9Uf9srMEfInv6wgPM+bqYcK/AKmRK4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IVZyQmPp;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE63961EAF;
	Sat, 14 Nov 2026 02:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242001F000C4;
	Sat, 14 Nov 2026 02:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794621737;
	bh=g/BUAcWunD5avy60u0RgXgnkoExybgKO9qdpG8t6BKo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IVZyQmPp76a+wS5LUV2vl6e4XNku/IBMxUKBs48NG/VeMTUYenAQ330fp3e0RlHoH
	 d/rdyTmCZO0RHe3OFbc23rCB299Db6q+7sH9n2jMfNYydI5HpuHqfBYRAQoedM5SUR
	 8L834n9zT9l+eAk/Mrrmn6CJ8s7LSwEpAB0sWHLDAqO3W0i3INfc2pIHnsPKs+2DRR
	 2M8SIQ9vP/69bddHVdbFapF+V3YUI7TJibfE7AJ5iyVQ44L/QmK35PkAO1LeQtBF95
	 fcDcsoc2JLaYhRjwzacfujmFlKBXPq/MWjehqMyUEmphZT05fdfiLBijGT961GcqLX
	 zlZV2x43dzQjw==
Message-ID: <sashiko-outbox-214021@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 02/16] mm/mglru: extract lruvec_populated_min_seq()
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261113185541.70203-3-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
 <20261113185541.70203-3-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 02:02:15 +0000
X-Stat-Signature: 7kpja14ccqndsjcpbs8yygy1mud5r7qr
X-Rspamd-Queue-Id: 521AA20002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794621738-185555
X-HE-Meta: U2FsdGVkX1+yPeJDIC76Bt4kIgCpIFPAEDC8C4FeJkhX/BVUCzOzJil9M+yoKSf5EzqkbypRFiQhhF0XCzW3KkBP+QLbNSXJEZXScwDDMxqAxJ9Qg+64iWtfD7TPMeeSEmNDkTi2vSzhZapLFtD2v3jAOA9ZsiIMYeLmBnY50ijC2m62W5oYvM+AsKvbCs04GcXEl50TaBf/+b3AO5uSepK//N4oLzGaJgwZiWqXADaaTIS4t/whT2Nw5LQvCgZOv5CGsJi4Lzy8oKP+6clfhCMbmTgl367pY8vM4R+SEgGBwrPsP6jDrvjx+rZgBJna16aIPS78m1mfLU+x069ln9tSwxEzzoT0snAr/GstuirsQSfSoCo7IZmn/lCWeKT1ldmsj0vmFukQu4RwGIBKkM/Ae25Q3E/pBr7ti7mbh3hXr2ee9MK2fwMUTfmy1tbUfP42CUtVDckaEg7EHkS3ypaiHaMqDwMJWbFJyEuDZUVwr5UCOZDKBf9WSNR4kAw3fwC/5etTd9ABSIk7Jm49WosLHLvj7UcOYVDvZdNnL4JDY8HEq2lamUxs99O0oh3v3QkqwrlQdCp1M9awhbBt2oe9z/3WX910Xh8IRC4K14ceMeOsp4H6GXXWflICVXwbMc0b4rECz/cfRNfMMZSnGPv3SoBC4fl34GuICI1UN4WpaHMKM3yX2dsdl73nHUpYXWOxiKZAfi4lVgXtgAt4+I/2hwJAz8BgK0z2ZPXucl2Vum+ilpa3STLgkuU9+fOPmeCfRVwPW7dvIxoEi43uEB3X898TWuJtkc10RYMp4Q7o3qpfRQ+oKMVhLg9Fx79qstqrcsM8FHG+1yRNbSmIr1KbNpEcF5dPQg8lsXFPBMi5jpxW6B+As1D70epq/zIZXN+mhL89yjuhvwB9yXODyjTR1UNBKz67jRNdfSXEfMprqNiUEACAhJY7EMxMZiy5U7AvOOdhkALze2e+y1V
 MIkNr/yj
 J9SwI0xw1UVpIjIzcu7ei8Wjm8B9ER14qvAQljVU4kGVRP+4Ym1h/udLS9hvTcZcFTFYDcwPjmwJyUWaxOOK3EyQPa9T41cPC+x/bccfFS8xn2VvIqH3uOxGZEThTfDDrWEaJBzwwj6M+5J6GLYrEdFnRlh18/X6B6F/DjMQlp7X+egQlUFeFQJgZVs9UspAeQ6q0NWoZtybGNLqHlY0y4C1YwSR/d/L+IVmfz2hCoAOiIbymUreY2ppm7tKkO2iKFVo6GVystLdvHmWNbobYIwqrukN3MD8kGnsH18YOkB376/QGbZHLFxae6sBBAaYoKWHKzBDtL3dMJWU7tdMoMvuN1eiX3FjNzw4P3hf9VN2a1mZkhVcoKCy5O5de6LUJN/mvvpOTCGxSFcBmU81eg03Qpr/ywPMAHN3ncPRo8wdGvQ9DPtTqFCC4EbG3TIHlHTBii8hg20yt//uQjGaLH59+iEXilFcf+yRLaRc1wL5vSYPbuj7sTRrvfKCdF4Ar5qt/FilVvYy6+uITKr1OaQLaDPyRgqTBGV6RtV868EDSlacaU9nn1j4O5XhKJehcmoVhndrXW/AaA+SNh7bzwGBPN75jxXtQRV5rdeK9N5AK3Z50jL4NdpGvxVIG/D6yKrqIj4iuUmd1s2JtLBMmnl0BIacrqGNigrT+GMOe/5laolSBbXCWzOwZmeSjFPRlv3RXvvwFL//eNdEocyPXTDOrNdlRtZ9EfN44W/jAuKB+ROio7cvxMTzRZJqNxO0KBnxrihVfZobIghU=
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
- [Low] mm/mglru: off-by-one loop bound in lruvec_populated_min_seq()
--

commit 9751ca1c29ca665233058e3a3c3cfa85cc385872
Author: Kairui Song <kasong@tencent.com>

mm/mglru: extract lruvec_populated_min_seq() helper

This commit extracts the search for the oldest populated generation of a
given type from try_to_inc_min_seq() into a new lruvec_populated_min_seq()
helper bounded by max_seq.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 400f87fc51e12..27dfbd3ff02b3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3992,30 +3992,45 @@ static bool inc_min_seq(struct lruvec *lruvec, in=
t type, int swappiness)
>  	return true;
>  }
> =20
> +/* Similar to lruvec_evictable_size, return the oldest populated seq of =
the type */
> +static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int=
 type,
> +					      unsigned long max_seq)
> +{
> +	int gen, zone;
> +	unsigned long min_seq;
> +	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +
> +	lockdep_assert_held(&lruvec->lru_lock);
> +
> +	min_seq =3D READ_ONCE(lrugen->min_seq[type]);
> +	while (min_seq <=3D max_seq) {
> +		gen =3D lru_gen_from_seq(min_seq);
> +		for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> +			if (!list_empty(&lrugen->folios[gen][type][zone]))
> +				return min_seq;
> +		}
> +		min_seq++;
> +	}
> +
> +	return max_seq;
> +}
> +
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
Should lruvec_populated_min_seq() loop while (min_seq < max_seq) and
return min_seq at the end?

When min_seq =3D=3D max_seq, both the early return inside the loop and the
final return evaluate to max_seq, so scanning all zones of generation
seq + 1 under lruvec->lru_lock is redundant work that the original loop
skipped.  In addition, if lrugen->min_seq[type] > max_seq on entry (which
happens in commit "mm/mglru: lift youngest gen protection for higher
priority" when scan_folios() runs at DEF_PRIORITY while get_nr_gens() is
MIN_NR_GENS), returning max_seq yields a sequence number below
lrugen->min_seq[type].

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113185541.7020=
3-1-baohua@kernel.org?part=3D2

