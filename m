Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BDA606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F+lsNK/G
Received: by kanga.kvack.org (Postfix)
	id A309D6B00EF; Sun, 15 Nov 2026 23:50:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E15E6B05B0; Sun, 15 Nov 2026 23:50:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CFCB6B05B1; Sun, 15 Nov 2026 23:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64B5B6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:50:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6ABA408BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:50:50 +0000 (UTC)
X-FDA: 85439757060.13.F6BDAB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 25DEE40004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:50:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="F+lsNK/G";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794804649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7rTvYMtAMvHRPS6DPYo2cQG6L/Be3uAnvxO8PNm0bs=;
	b=hcSXQno4/62WbwUNcbPDf36ChB+wDT4/03YsAEgdJ5mie7TuPrxpuEDJ50WQlHPksNaHAz
	SMszzRcrQdr/FmfWj9pxoS0p/lFyO0vU/VMtnzZN35Hv5JAquUtUzERMWvtXKB48w0ukjj
	kJ3JEnTusme0biUj0rIpFfsOZOIzLww=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794804649;
	b=xzeM7PcWZPl3P8bIiSlAJ7TjUEMyq4heipKBqf/dm7+E0pT3WOhqRwjghaiadUFwWL0lF1
	zmLci7ColflUPQXZBJJ4A6k3IjKrZmCyNAYwp1YzNRpUZ/gI+4eMBl+bXMa8gueSP4hw6x
	wnz+3UICnzm4R1xvCFHiaWSQixKRCAM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="F+lsNK/G";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C17D44F2B;
	Mon, 16 Nov 2026 04:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460291F000C4;
	Mon, 16 Nov 2026 04:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794804648;
	bh=x7rTvYMtAMvHRPS6DPYo2cQG6L/Be3uAnvxO8PNm0bs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=F+lsNK/GKd+fPaa4dSCLWOtllbYi7ZWp49WLoZXXYX/faq/WnmO4YfPZWa/ZfOpdu
	 RZ5J1zeeik55bO1EJW/vA1RpKNoROaT66wKabAbn4oO8sD3v6EYi1VO1J1s+hMLskI
	 SPmGmhtmx+UAeDlPki5Cgr5DbrIQaDjwgZYrgdZc=
Date: Sun, 15 Nov 2026 20:50:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: ryncsn@gmail.com, axelrasmussen@google.com,
 baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org,
 hui.zhu@linux.dev, kunwu.chan@gmail.com, liam@infradead.org,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev,
 rppt@kernel.org, shakeel.butt@linux.dev, sidchintamaneni@gmail.com,
 surenb@google.com, wangzicheng@honor.com, weixugc@google.com,
 yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn
Subject: Re: [PATCH v9 10/16] mm/mglru: Run aging when pages are rare
 outside the youngest gen
Message-Id: <20261115205046.8473acf5a93d69d460598559@linux-foundation.org>
In-Reply-To: <20261116042556.42111-1-baohua@kernel.org>
References: <CAMgjq7C_cH75JrYs8=P5LbxnDjDD6bqeqsCidOPa=r8Z+42sCQ@mail.gmail.com>
	<20261116042556.42111-1-baohua@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 25DEE40004
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1ku4fgkacpqzheezkx3qcwmybeigqfb8
X-Rspam-User: 
X-HE-Tag: 1794804648-348243
X-HE-Meta: U2FsdGVkX1/4VG/ERBeZtTduzIjJfXF9f+izIURH52Si85b0mT+PqLldOOrNvVERCe7njvLA1tkWWYFgwaufj1shhowtcVEr0r5GhLb/sKrlshc5QUNfLQAhZ+EPl2chwQFLrKQuiZs4kyEbEjiI640yY3jNaoHKtbAb678ompDmsOX0f53ho3nsgiDv1kfewPJhzkoKNnPbhacOZPuQAxfLtOTyn4es+XryFJutsVXzvcgSOfFg1qEJ/pL7Klh+8T4CksRQfs8I8F19Jv2HMKOncGZOY6XAul4BO/dBYKnpZKT2tFsCQ9faviI3FCmty6LAWKJEUZvjfP/aFH9BPGgCveS6zDnTn1cDL2RBd1OYmpaDowrKt13LIa+oxPJRmvbzNcSq+gM/RhdYUe0udvZmdUrVvmvH1ZM1TCt6z/h4hOjDoJTNE8bwaJQjrkiQJhe9ahO12/bqr9Ce6pgdjXpPcqPnCJAB8dCITRRtGluPjM5QPBRfo3nBPXiZpZD3uLBYUTFdWC0c0fyvn8Nbaj/pNcUtFYnlkfsw4//r32RPcF1gx/+WMEZQa/u27lDQXB/xNFXH3HDSlem2AuflYAoGRHv3yJk/t/e7cpPfTGUwRDptgymY6NSMHals11ZtAePu9cxlPsn7Zh1DYiZ733xMLEu1a1KeGTFNiWMQt7AsU2V1DfIdzvaAeqUel68ifUmMr8PNf0WF8O2rhzfptUQqm/vb1jmjPGY13P3uHaw9BGlZASZY1fCgodU98Z5yJsqtL5YqIzHwrNEVN05G1g5QAoEZ0OBHNNE+eibUlbpdH0j6GHw/MjVVD91pZ697g1xjuvNwFU/rr0k/gj1KY54yIFUCogW573la325BMqqZAOrYv0ihF13kpXVUajkWREGiBtz6fujMJMAAsMPsVw3b9H3zKCChwCtMCkEHQfaXqq7WAJXg5CJe9Hn0SXG0tpQApqhyjpbA7pZEVua
 dLigeK/A
 ShOreR1V8ljLcvP1XlQJQXLKU7uXhvw6j8CKWVifgh1REyvss8frXI+P5O0ZjjbFG8dhKCbNpNLB47W1TA6lrEV4xCmrzWrOGe+0oz+aDGs9bqSqgQKiOhwWaGTrTPaBNiNh3sJiS1+L+3eLVONY5jG+2tCEeqHAj3yrV6jY2elUSXzdpDDcsosK4/xlQH+1zCTWIUQxFrVBVz7654rSYYJYJS9JkduliCKhFCkBOKdSaRgeNOt2SbB8aOd5njaM+oS1LwVlGLI90BkZCOKOQftAgMArbJf6N6KV5IB6GTBwxRTYxKtPmwOZW3dY7COCwC7xi7Ebjxs8uNeBLoGwd6+C3H0EK8sRHs6R20UeFk1oHLR1T+AKQJ41I28pul/Xe8cUDl/YvhsXHRNALwAd6jixqzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 12:25:56 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> On Sun, Nov 15, 2026 at 11:55 PM Kairui Song <ryncsn@gmail.com> wrote:
> [...]
> >
> > A little nit: with the rounding above, I think we don't need youngest
> > / old as an array, just an accumulative value seems enough now? But
> > feel free to ignore this so we can avoid more update noise in this
> > series.
> 
> Makes sense to me!
> 
> I guess Andrew could help squash the cleanup below into the patch?

yep.

> As suggested by Kairui[1], we don't need youngest and old as
> array. just an accumulative value should be enough.
> 
> No functional change.

It got a bit messy because the later "mm/mglru: restrict eviction
accounting to eligible zones" alters this code also, but I think I
figured it out.  And I might have accidentally fixed an 80-col thing
while in there ;)

Here's the end-of-series result - please check.  It compiles!


static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
		int swappiness)
{
	struct lru_gen_folio *lrugen = &lruvec->lrugen;
	unsigned long youngest = 0, old = 0;
	DEFINE_MAX_SEQ(lruvec);
	DEFINE_MIN_SEQ(lruvec);
	int type;

	if (sc->priority > AGING_PRIORITY)
		return false;

	/*
	 * Round up or down corner swappiness, to balance the heavy biased
	 * type better
	 */
	if (swappiness == MIN_SWAPPINESS + 1)
		swappiness = MIN_SWAPPINESS;
	else if (swappiness == MAX_SWAPPINESS)
		swappiness = MAX_SWAPPINESS + 1;

	for_each_evictable_type(type, swappiness) {
		unsigned long seq;

		youngest += lruvec_gen_size(lrugen, type, max_seq,
					    sc->reclaim_idx + 1);
		for (seq = min_seq[type]; seq < max_seq; seq++)
			old += lruvec_gen_size(lrugen, type, seq,
					       sc->reclaim_idx + 1);
	}

	/* the vast majority of pages sit in the youngest gen */
	return youngest > old * MAX_NR_GENS;
}


