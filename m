Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831FDC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 21:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091E86B0098; Wed,  6 Aug 2025 17:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0421C6B0099; Wed,  6 Aug 2025 17:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC28F6B009A; Wed,  6 Aug 2025 17:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC32B6B0098
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:42:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87860BB0AB
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:42:43 +0000 (UTC)
X-FDA: 83747657406.24.C8BD3AC
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id E3798C0006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:42:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hoZBgTYL;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754516562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dISthHhh14u7ozuGWeRbXxMN3cha7Mzokz7OWx+4Q+E=;
	b=I77+88fLD/stWOHlv8BJlnvhqNUCeaolCg5BJnp8fbbp0U0hC5W9wK+ZdvhJuePM4frYry
	sX1HIkg3L0Jy74UyPdRwXoZfm/sd6/n0OSvX6xuUjOWPdx+QMaINkwcyNHlKe8j2knLOKV
	zP3S6bapsE3/cXHNFotsHHr+n6+EQWA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hoZBgTYL;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754516562; a=rsa-sha256;
	cv=none;
	b=vzeJxNmW/jCQIE1jnTIUaFTv+FMU09ZLK6j9h7UfMpG9JDF9KqfdPk0OxEEnTaH+GsbZ6B
	SZ6mhJYZQfM+CCF0ugXe1u1VJAAUJknCPN5CXkqDIG8324V21niGKwb7OcgQ8utHedf2IJ
	v2l1V4yEnYKOKU9anCJeQdvTrSKR3Qc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D607C5C6723;
	Wed,  6 Aug 2025 21:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6E9C4CEE7;
	Wed,  6 Aug 2025 21:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754516560;
	bh=IP16fbf+G7a/uqZxnRnGz9p5iDyRqDGWV+tCxJaT6wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoZBgTYLM6S0Wb3uTTK/zr1aZiRs8bMg4/aU2jXIiSNqOVtcvYlphmsB980gRLlKb
	 0dOIDeqTC5dF1SJULftMQYAC33Rc4+0KcPKvKu9P6N+3IInpvK2tB5WWK7eht0FU/j
	 8qye/pqfqzyh/Dgb9uAmVqrpWK68lUQ2M3fEUpBTlAwQsZ1vAH3Oj0lCBZzjBMOOnO
	 0XiwATuqShtv5PzcxWFMx3ZpJLbUYKEmpKT9a70esnRdbCouu46kSrOpGBLao1xMVU
	 /C52wzKoBdtarOgFPIEXtg23YhK/GbI9wOalubYH2qUdZUFPJEwhCYNjmdyo5KfVet
	 dahrD9AGky5kA==
From: SeongJae Park <sj@kernel.org>
To: Bijan Tabatabai <bijan311@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH] mm/damon/core: skip needless update of next_{aggregation,ops_update}_sis
Date: Wed,  6 Aug 2025 14:42:37 -0700
Message-Id: <20250806214237.51484-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAMvvPS7Anh4qZu-VewZ61_QqfU9PDCaUpGjxZWeCdioTWkr5vA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E3798C0006
X-Rspamd-Server: rspam06
X-Stat-Signature: f7mneimy9kq1uubpxw1brd9uyr98ebiu
X-HE-Tag: 1754516561-102682
X-HE-Meta: U2FsdGVkX19tE7rjQ5/Ddc85mCGFGy81qNrKZgXgS/Ec54p7QiDtrWrg9arXMcbVxOkNswARzByret5KgJEK5y2wVcwPaxADeQ+0yFVLz5i/Z8nFuYueTUgMd29o4bwGiwdX9UFbl4UCqAjkCm6dYAwsqmygenn96i2Kx2QbDrMvD7SiptCRoKufmAzTJnoQGJ1EELSVqwvjGg9ZyQ9tsh73HPB9w8j1g2aZGJJeQF88LQ+hMrpDo1RGto5uUHsmYCBw6gcFAufyvFYs3oFVN0kLeG7x8VtwhTWx/i2SK//7AgcFKP1Og5B+g2AmX3e0cVTgpTxeeWo5iYME3wdf8uTz5Vh+rKnQU3Ts3l2h0hzKGkLxrV1o5WUU8YkcpS+WNiwfGZmIK8lLvL2Wzsp34dakQ1gWMngOw5dIXlSF9cCHKZCb+b7LgDh+RXccpddM8jpPL3favWYsValjiFiIqXNGnmYr8YrQCHprYWktVwsJw8We9/Z7hIs1dwdC/Zb9DYNcRntNHfBZZNtPqkevzqzhsjjm3/QN8QE0LsZW5NlADHojINionymGKPnGiH3zp31m7k+jDvNt/OT+I1vHYMazpTsw/bJxG1xTyGmFgztIEvgkK1c+eyNcKJc31lRx66c/8m1e5YMKRQnqCIvhqD8wwF5DH3zqVfdpMnK9d72EeAsnVAk833Dn2PX/Gt1jSrkQcyL/d6tjfYU7YD1hU7dugbwCgn/5nXNgikBtrmvICiGqLiJVHnHDxPecSLTK6som0aleiJ5pd82mIt2CSTvlpORAmmVbFbyiEtLF4B3/ZtT5IaWl3YGxxT6dG0u3b4uhqAXI2QqIMMs1xKHQRXVTFwPEs2ilaixH+293F+ousyG3/WjqdFAf+DOTnOxS+4QCpf4m7vxBpwY3pEh/scshi43Yaa63hF0piUdTqRtcLCqf1cF9UritW3KT4Iyud9kUFQeRGoPRjacOabo
 rbJHD9bx
 918JUl0DqDa9WulxYc+xdEl8dalyJBMJLpTu1y+O8UBOZZScf9B1rkiEp7eoz2UFNZVN3hnAgzocxZ7PcZMGydQe4slFeFj7rvDuISvxinsFGZgL0JP2eqq94vrr6gLehDR4B32pjCe6uHIrBJziPhUJU2TcuaYaBTyB65KlpuLm1XWlbmC4fxbCVAIRoi1GDT+2m6gKUcTkRRJ6xs57BzABT+fnfExhQUD7tZD71zNmRWun566PnizsKhSR5fZajaWENFS/iBCS92jIRdhQJbiT878kb6yPtYvjNqqbTb9NEFKIWHBd/0O6OdwKoihBN2xrOWZym3ntffrRQ07Wbf2LhFiZjcrDP0BSh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 6 Aug 2025 14:49:21 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:

> On Wed, Aug 6, 2025 at 2:09 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hi Bijan,
> >
> > On Wed,  6 Aug 2025 11:43:16 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:
> >
> > > From: Bijan Tabatabai <bijantabatab@micron.com>
> > >
> > > In damon_set_attrs(), ctx->next_{aggregation,ops_update}_sis would be
> > > reset, even if the sample interval, aggregation interval, or ops update
> > > interval were not changed. If damon_set_attrs() is called relatively
> > > frequently, such as by frequent "commit" operations, aggregation and ops
> > > update operations could be needlessly delayed.
> > >
> > > This patch avoids this by only updating next_{aggregation,ops_update}_sis
> > > if the relevant intervals were changed.
[...]
> > What about modifying damon_commit_ctx() to check if new and old
> > damon_ctx->attrs are entirely same, and skip calling damon_set_attrs() in the
> > case?  Doing the entire damon_attrs comparison might be suboptimum, but would
> > make the change simpler.  I assume the suboptimum comparison is not a real
> > problem for your use case, so I think that could be a good tradeoff?
> 
> I can definitely do this. Checking a few extra fields is no big deal.
> 
> Silly question, but think it's best to get it out of the way before
> sending another patch: do you think there's a more elegant way of just
> having a dumb comparison function like
> 
> bool damon_attrs_equal(struct damon_attrs *a, struct damon_attrs *b)
> {
>         return a->sample_interval == b->sample_interval &&
>             a->aggr_interval == b->aggr_interval &&
>             ...
> }
> 
> And I assume I shouldn't compare the aggr_samples field because it's
> private, is that right?

Ah, you're right, thank you for asking this!

Maybe we can copy src->attrs to a local damon_attrs variable, overwrite
aggr_samples of the copy and dst, and memcmp() the copy and dst?

I wouldn't mind the dumb comparison function, though, if you prefer.  I'll
defer the decision to you!


Thanks,
SJ

[...]

