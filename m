Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A72606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mNZCgTOx
Received: by kanga.kvack.org (Postfix)
	id 91EA36B05B6; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F61E6B05B7; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BD56B05B8; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 615ED6B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 957161A03B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:02 +0000 (UTC)
X-FDA: 85425267564.03.45A662F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC2DA20008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNZCgTOx;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqqSUDjemosKfMXFJs1dg5brBqMf+3gFKrO43tuFE2w=;
	b=O45XUXCmzC5ZTNmvTSgNM9sIUeD/3+5TjyRAUZrz6GeYPkRjKvoDVIVUzvRyApvckuRO0w
	mLqwhznsKaX7R1xwgOQILq3v/1MV+RuXZkeap9lZQl137toVLWFzFdXRiBZORoEhjXuPNi
	04wqP71XCLGYjSOw3zv6cysT2KgGNMQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNZCgTOx;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459661;
	b=7fvNQsGKBsHymy9BCm8drd9lStCojxlA19i5IBgy70e3jo5YOJbQ5+G2AAyQcJrviKMF0Y
	shG3BSy3oXPVDAM3sCws/tIM+nZfa8+k6xRIS+i4+cwPfZJalNJ+QKqNobHJ0LKutSofjK
	Eu81soXmr2D6cDvP7h/GnYjJHe7LcqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83F4663033;
	Thu, 12 Nov 2026 05:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905811F00A05;
	Thu, 12 Nov 2026 05:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459660;
	bh=WqqSUDjemosKfMXFJs1dg5brBqMf+3gFKrO43tuFE2w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mNZCgTOxgK1BNaLSGKQqSm95RcbYRuTvWMFkQuIue/r670gUlYddhyK/ZsAgIyEGZ
	 28iuIHt++Ir2me/i46LbPeKosDsR+aZ3lqskLmRwRJhPeRbkhqGjcZAFx2RSOr41cV
	 l25f5I5HjbO5Y3HuaDKDohLiLZkAhsgYFQGzUKh1sCnEZsM1/8vVKuj+69ZySzOS47
	 wvlqmK3Z/E2ixy5DBAzvah0FS99mspCTQzJPLz+SRV+nFKkfIWWAmMlIcStI28EtLi
	 rKD3ri69D81Xa9UllJfV0qM9cEdsBXFUU5U6IhsiZoH40fcaPknGCTv9oBZXhZkxNx
	 QHv7TGcrJgvCw==
Message-ID: <sashiko-outbox-210412@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 04/16] mm/mglru: lift the forced protection of
 reclaimer
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-5-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-5-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:00:57 +0000
X-Stat-Signature: zdmmewy6hwobi87amweszcw1dmshtc9w
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EC2DA20008
X-HE-Tag: 1794459660-247666
X-HE-Meta: U2FsdGVkX18LsGwu4O1gN/mXlfBD84iy9ZP15X4Ot2DrOp2deEJxwxNBz5ZP31uirOLRQ146v+pjOS4DQes0SJ49y/TzyqMqGXC0HIaN22BFcAmbyLHQPRlI5Diet8LRVCvBwSczEi4ORVKaAz5oIb227+4hrVYWtwxAsA77Son5EJJRp60EkzBgBiRzYvTQreCMxkzrRCuMA3kPKhgXvlpDSyTy0wDxyWkRI41i1MCCl613AsOvx6qnAzNbbxWnf5h7t185CWivY7DOs/q3KLaRWkUS4AnLZEY+nRo0QqK44s9q0n7mqTTntsBtpcOc36jXaLNihXKs2XnmLM1RR5tiFg0siReI+OP+e9JrJ8C/h4vxZms8RqFX1PqERJEQrZfMNJZmSp+bxd0xaNOsbp9uwUAow05e/LWjBOFLniqQ9dktEC9/X4Z+ERMzUhKREMf+k+EJt3sAI2OaaddD5747vEkOaJ1s2rLUQLTAwNwAcfEvkOZKowr4C44ayGjseqq13xRiz7lN4+0x/+GyH1nVncLEGhzURTW2MeYtWpcIr/C8jVmrUUDMSr/JpnE+b8j1NleRyWJXhnoKhvNmNf2IMRUMCpcK5umo/ypeAZr9aDPdHGt/mmoeK3PY7IUQBEeBC4LAIeVsvLIO1iAg2N4aSRXkpVS3XF1Km+gNvhrlZPDbRkz+X4eHVS9ObGEufSFmNKGAyrDmHohfoBA1PUm5XsWGOGkxPyFQKdfIPUYE6H6UAas1oY7gEErpfQqyjfJpuGS8avcOEjUEql9WTmAoajC+csKUW+ssPEsVi5eQ5kO8W0C6vs/vbIqQTjfpphppZJ0hDBHC26hfQs6ld8QQ4nk5zcp3OHSYDtiY0dXo7ZgOwYnYfk/Neu5y23NgSTPqlo91TBwkivYgplD0X9MTOwf8a9DVstvU4emnrpJdJdIVw/TF9wnWQpgcuDz0iMYRvVdq8OautHI5B+a
 Qv5IHgl8
 MOIH1Pxi6xRFXmZVCn/e+hcRnxTYHOWFaU8UlYogdzxSW/P+7da0OHDkFJJVKGjDtobLFzzflzeHp972GY72QGdavgsahgaUCCRxhEobB/EN1NErk/U9Zdb373/X908QmN5F9EL5grwQivdWwDxj4wqAS83h3v7c9tdtr0kHfSHcJ8uhFiYt9F+v+5kH3XCr2XTajeljLrE9FSdfuVjcDta+LDD0jN7CBPTgAY0QBwJjCqQja1n6YMS5rsq/kqVZGfuXDKLLr0VkItsEuh+hXHNNnBLmJo8DTUFwrZsAQfna0H7O/x9lVM6af2lWpgkT4cDVr1Hv/E9POeYfPgS+80+LU284Zbiuep8tFV5TGrVVS/vtrNI1OJJouvXe6/hD1TK2b3p1fDLLHB1YyoFNqAYbTbkYshJFJx25n7PPrRDlRcHHoVYje9h7jhrHWV3HDQ/A5GSTlIAmUITszoknzqoX918j4hGgBIjoJwDamXWZZYvwlJNh0Cp0hLWcihblrht6tPtzrDRhpIPTOioBeasyDBxTQxJ42FKzCLhO4ty1Uf+hd2BtRASaBWPKbwDFv3sGCbZlTsiFjKkUIio7rBob054mEemnamC0bhLDikIipWOAQ4sgdaQ/y4kgtQI/FxFx1ibUEI8RoX5ROpVULzz8X/7s6MSLtJowmjTt215pHvIf4Z0172IPzsM1l34/hnsDFWW9I6sqmauE93vznPsWBb/i6tc27QdbBeBHR6Ae+dOPPfDlj2PdIDQ==
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
- [Low] mm/mglru: run_eviction() evicts up to max_seq due to sc.priority
  =3D=3D 0
--

commit cd86952996e1243807567af19d65b021c3573888
Author: Kairui Song <kasong@tencent.com>

mm/mglru: lift the forced protection of reclaimer

This commit drops the MIN_NR_GENS early return in scan_folios() and
extends the raised-priority scan bound up to max_seq so reclaim can
proceed when aging cannot keep up with pressure.

Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-=
pressure [1]
Link: https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92=
dc43@tencent.com/ [2]
Link: https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@=
tencent.com/ [3]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 20199232dd70c..51c2ee66b3ee8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -4771,18 +4782,24 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>  	if (sc->priority =3D=3D DEF_PRIORITY)
>  		min_seq =3D lrugen->min_seq[type];
>  	else
> -		min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen->max_seq - M=
IN_NR_GENS + 1);
> -
> -	if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
> -		return 0;
> +		min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);

[Severity: Low]
Can debugfs proactive eviction via lru_gen_seq_write() -> run_eviction()
now scan and evict folios up to lrugen->max_seq instead of stopping at
the requested target seq?

lru_gen_seq_write() leaves sc.priority zero-initialized (0 !=3D
DEF_PRIORITY), and run_eviction() loops while seq >=3D
evictable_min_seq(min_seq, swappiness).  When one evictable type has no
folios in generations <=3D seq while the other still has min_seq <=3D seq,
scan_folios() takes the sc->priority !=3D DEF_PRIORITY branch and evicts
folios from newer generations up to max_seq, where sort_folio() also
bypasses tier and reference protection when min_gen =3D=3D max_gen.

The commit message of later commit "mm/mglru: balance anon and file scan
budget by refault rate" in this series notes setting .priority =3D
DEF_PRIORITY for the debugfs scan_control, but that initialization is
missing from the code.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D4

