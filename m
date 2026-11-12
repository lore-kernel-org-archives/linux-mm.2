Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070EF606A324
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GbeGebs+
Received: by kanga.kvack.org (Postfix)
	id 1F2A06B05B4; Thu, 12 Nov 2026 00:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3416B05B5; Thu, 12 Nov 2026 00:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E02F6B05B6; Thu, 12 Nov 2026 00:01:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF6116B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8BB9A7CCC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:00:59 +0000 (UTC)
X-FDA: 85425267438.25.F411955
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50469A0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:00:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GbeGebs+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459658;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfcA91JIRbeW475hmsMlSCAt6ytcnff7eCYbzKvaRLk=;
	b=mc5OUfiv6vc5MwDlJ1o0KCF+UE+8qsxtwoDQCYn7Pzn2YSyiOK5pFygNhTrXh5JXVoqrrM
	CaWv53AGCKDpwXS2fxqK8WcSMYCRZLv9K3GgiruGxibFKJ9I/xx68Fm9vHDx0X5E09Zucp
	cDzzMPfcC2tuQFAltcu3E7gZgMcl9jE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459658;
	b=m5xShVxdc339CCmVjdVeHm3Oi5L8wg4SgbbuIMqIdhiVkAfTq348e1daWJYCzMAeWlwJ3E
	miuWT6v/9EnyEZOBgkCJwE1oE7aPqDKEB6krh9aAzNnHKH7b6DLH+dUfgi5AIZXuLdyb1p
	etW0yVa6Zm6LMjLvsT6hHfbHpmZAFyw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GbeGebs+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E470961EFB;
	Thu, 12 Nov 2026 05:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB981F00A05;
	Thu, 12 Nov 2026 05:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459657;
	bh=OfcA91JIRbeW475hmsMlSCAt6ytcnff7eCYbzKvaRLk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GbeGebs+QUn3jnRHP8H/X0iAG0/MR8w7VFKKOv/EKzzmWUdLi4RZj+lg1hO5wCMsZ
	 Wgi+ypK+m1n3RQGUb+m9Hw7ZtJ7a75BMJji9CxafQpvrKPLhD3ooo5UmnEmZOQ+HZP
	 3xz/vNSzLtwyLKRfkk0Qj4ihfJyKjyvoDxHxnx9tU8AaUsVxF+mCUcqSr2DXtcUJTr
	 iJ1YulLn6UDY07RXdW56/zCvtyDzd78hstM1xAyRl2rimjYu4qcmnpe8FJRdxv2sr1
	 +GRDZTCUt7bIL2mGX1W0NF0tPNRWdfrw7FrcN0prSW+WrLPI7t+fHBwTZT1PVHmDf7
	 1ObnP/EPMklCA==
Message-ID: <sashiko-outbox-210411@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 03/16] mm/mglru: reclaim from the oldest populated
 gen
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-4-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-4-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:00:55 +0000
X-Stat-Signature: 8mgck4wf4gq9nx6u8hgtdosz9qnyks49
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 50469A0006
X-HE-Tag: 1794459658-428501
X-HE-Meta: U2FsdGVkX18SOK8t5BQ+3f9ixnsSKzI1IyqnA0xWvZUUJRgoyADkWhsuwNThLqYP9kax+A1Vki5HE5xAvkhi7t7s1lIfnJi8laylZCXz3Cso0HVv25CvtdJxYdfP1C5JkpP/GK4VVwdPmfXYo8sj3AcxXmR0tCmkepzUNjEOie5F6V4cwvv2yNYmrhCm4EjVTrtJCLn6BGg2fP7JgojGwG/2fTMgwg+2BwTlnG6T+t0jFRj2/Sd7S1HF7HF6oVsYYEcThSBWSaReVyjAfzcTkx2nzHBRrGT/tSdnQUpsdVTLQ3ftBMwqRjs+Bl/F+ECVU3PatkXOezGyGGw6A4QNS0I9DFtnm8Uh398iLlRxK5SpKEOeKlXhp6QTA5f44Kw+gicgdUpKxyZN4N11nMFkr1abG9AsBmBpDQXX0XfkEdoCwuy2UQiOKS3iUjN917UjUNX77MzQcBY/PQAWJ6qkbRmR6TYBrbNh8Y+65aKBejFN8NPreFiIqXaeX41h5s18yMRgRqVHYhxJSUXaQFAky99/kZKP0yDk8TNWno97pJc1YBJ/f51HhEg1pty19h1vst+4diwVSbT1zUoW/UXDqhpAmesCLdiCRm2kCqaFJAabe0B0o9qu1XzYN3hNLABxOLdWU0kWqG2i+3c2J9CFHqRqbcU6eCUQZ9QTPTkxjXeNogx97dzY6NzKnHk9Mk21t1/JSh7dBo2eqy5xQRBRmnXF4I5UqDgKRR+GOX/ykvHv0Rczmci1/1odFwnVJmoaF79IVFZx8B3UD4Sy2SyMRvgmdPcO+OWRAHldIX6hOaTEkQTFa67SMavuRmQAlQ3B0Q2ZYCpKTnU4SS3Wfqee/InJ3r6VxHkRBOYt8uhFJFMRoIPbfsn19hDK+ES5L8dF2SCnaiCJDLd0ejg5PbNUOurmMXJaHge3LyjC6MOBLRxUUXzS4ivEuRr7zrsHiCNP9D8FvE9nbfdAO8GGrSr
 TCZ078hZ
 NeloVTY0a+iNZpzJ8Itdy1vFU7wtKIzMAY9EKrMpYax4XyDBX0N2HFaO1Qw70SlzEyGmjajfDHLhQYzw4ncRRV10YWwlwOwBrTF4jaWQZ4cYb47zq1EvW6xeIPpMdM+GWec90POfQD2lpZ1/Hf+dAlFStP5g+7+8oKi2gc5gImtKMW+OXywxyY4YdcTc4kK78OMF2myLfbyZDXsbei4AUwcgUs+ya5IG+nuhKg8CpyTa4hcdJB7wM/kQNPmKPR7pF6SYom9K+EDalWvmk9e77Y0WVVND0Dw9XA6anb0QhzrOF2xZ2YbpPT9bXT0ZYiB5B2hifAoZsuNx5TWBCSlda0+nXyMllglUlKeMDiyCqL/dIrdMPpqtmZ/kcGSpkIzlR9W+Cd2/8iJtkJIhBb2gTlxEahdedl9XqGoRml8Ey6RIk0YzIalD/ZpfSj3WVkoaiL8Vj21g/LRc2APGzAy1jejicFypdSsdU3LQtaZUun9MHAzOKAumwog47Y2eZeT8xBd9DqIYY7WFZmMAVKXFyi8yjej+4WPxE5ifmHYFVJclF3AjrAUd5hKlu4jmAgTcP37w9p5WOU1uWHaQdfIO06tRc7SLLk47vfObE12cGUa7LSjRAYFsBLTx3cA6OhGlgONz5PZiO8vlZZq2BJKuj+cv/4aYveHdRz5PiV+EpCMbpUE4brRtRD45Idsw0zMhTIxJPyFQL0GY1xHD5aQEGiYBd/hXRXDuE8SfA
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
- [Low] mm/mglru: uninitialized sc.priority in lru_gen_seq_write() skews
  scan_folios()
--

commit c250a15f7ef946582fda6b278da38054c0ad3a66
Author: Kairui Song <kasong@tencent.com>

mm/mglru: reclaim from the oldest populated gen

This commit updates scan_folios() to scan from the oldest populated
generation when sc->priority is raised from DEF_PRIORITY, passing that
generation down to sort_folio() and folio_inc_gen().

Link: https://lore.kernel.org/linux-mm/20260726122123.7614-4-baohua@kernel.=
org/ [1]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f98cd483f014a..20199232dd70c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -4758,17 +4756,27 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>  	int scanned =3D 0;
>  	int isolated =3D 0;
>  	int skipped =3D 0;
> +	unsigned long min_seq;
>  	unsigned long remaining =3D nr_to_scan;
>  	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> =20
>  	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>  	VM_WARN_ON_ONCE(!list_empty(list));
> =20
> +	/*
> +	 * Respect the gen hotness distribution at low priority to avoid
> +	 * aging and scan cost, but prefer to satisfy the reclaimers request
> +	 * when under pressure to respect swappiness more and reduce IO cost.
> +	 */
> +	if (sc->priority =3D=3D DEF_PRIORITY)
> +		min_seq =3D lrugen->min_seq[type];
> +	else
> +		min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen->max_seq - M=
IN_NR_GENS + 1);

[Severity: Low]
Does debugfs eviction via lru_gen_seq_write() take the raised-priority
branch here because sc.priority is left zero-initialized?

lru_gen_seq_write() allocates struct scan_control sc on the stack without
setting .priority =3D DEF_PRIORITY, so sc.priority is 0.  When an eviction
command runs while one type's oldest generation is empty and the other
type keeps get_nr_gens() above MIN_NR_GENS, scan_folios() treats the
call as raised priority and advances min_seq up to max_seq - MIN_NR_GENS + =
1,
evicting folios from generations younger than the requested min_gen_nr
(including active generations that run_eviction() rejects).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D3

