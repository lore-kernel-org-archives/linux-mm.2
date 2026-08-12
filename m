Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEA3C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337956B0088; Tue, 11 Aug 2026 21:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F366B008A; Tue, 11 Aug 2026 21:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224EE6B0092; Tue, 11 Aug 2026 21:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F03526B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:42:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D0DD1602A6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:42:45 +0000 (UTC)
X-FDA: 85090918290.04.BD8FC25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7545C100002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:42:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xB6wSOwT;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786498963;
	b=D4qhhgbfHiwO/ZZHDkNl8GCau2uKfsbEX1tWp7UNJDINnymxHHBby4BUDjySrJs+VZDx81
	ScxHbM9ScMdQ92g6YbpBp2BWD8IlVur8GSJIjcc/adbxyx6iFYr2jncd+69dQKuhx4h2Kq
	ug/MFCFAT3PW8L4DrCQC5NUZcu8o23g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xB6wSOwT;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786498963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZU8DXDgfl8l62Gk1D2XRPtVmat7xNwylWclqwtu80A=;
	b=wWYWMqkqKI2i+nAlLuNP1yXrd8IacYN8+CxaD3baGGSbl21hIfQxJ+DfWuQfslR8BbDiFz
	2K+KQffZ1iK0vBe4QNM4HuE+gJxwtKkBX4/EQU0l892So+cjbjXY3BeNgo6ZvhKBDCXYii
	GJEv5aNkNwXSSBTGvY0JTY082ZZp2fU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C79C40465;
	Wed, 12 Aug 2026 01:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40E21F000E9;
	Wed, 12 Aug 2026 01:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786498962;
	bh=0ZU8DXDgfl8l62Gk1D2XRPtVmat7xNwylWclqwtu80A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=xB6wSOwTrIILgb6EqeeBEk9OxI/Pqk3sH0e3eYLsqkOzDo8/Es1m3vY5hhNHWrX8k
	 t0m9poWiXWnm5DJ9uSqedQ7xBjX0otEjvkFSzXG5G/a+krdwjzQHBCJ8B/8xyThZGA
	 eKssDGxq4ZhqHzs/6tGmm/LDE56wKo0oUVbEgwno=
Date: Tue, 11 Aug 2026 18:42:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wupeng Ma <mawupeng1@huawei.com>
Cc: <liuye@kylinos.cn>, <hannes@cmpxchg.org>, <mhocko@kernel.org>,
 <david@kernel.org>, <ljs@kernel.org>, <hughd@google.com>,
 <mgorman@techsingularity.net>, <yang@os.amperecomputing.com>,
 <zhangqiuhao@huawei.com>, <wangkefeng.wang@huawei.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] mm: vmscan: fix scan overshoot and ineligible folio
 scanning
Message-Id: <20260811184241.e423b81c8a50d5f212af1c3b@linux-foundation.org>
In-Reply-To: <20260811070849.1332165-1-mawupeng1@huawei.com>
References: <20260811070849.1332165-1-mawupeng1@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7545C100002
X-Rspam-User: 
X-Stat-Signature: hefwtm95nh8ew8a1ft6hwrwqj4puzxnm
X-Rspamd-Server: rspam06
X-HE-Tag: 1786498963-762440
X-HE-Meta: U2FsdGVkX189zbpl6SNOnb8aFEKz5na4xyH/BrasPqP6eam4t3OpqRLYujQm7hUpraAQoX8DKMH+93RkoV66kyDA0NNQtvT/P8OZKkjT+s7oWmXHALEm2eQQlieEUwngCrt01Pkounk+PNsGC/t+aGBPkW0EoggBtICYCcFr14YDW3U4XYB3k3kr3pvJ+v66xvXirpkBftobL8G2Geho5l58WvdXA9rGlnvNL3pTeT+E5kcjmPGlsQi2kY3ONspUOL5XJDKMVSef0NePH/ErmRxLfxIl/YnBEhDLNnI5EMVr9wZilJcXyeOWA1TWMOBV71kzSUgjBygtOA++bvAEYgbDDw3i82y9u4bt68XNiRpZhMcONfEQyA/abVPkA9ae3mFZAEv5vKan8Axj3Qd9Lk6kvjaWzaYiGsdvhiSohbw6IefMHJycEdbR6ansdUT9DujhyqrPS2kqScwth3S3eHPuCZwhOHbyY9PMmUMFhnFlL35AocG2LsId6xwhSp/esfqeOIUXuSn3od8oOD9Ilv6uXj55Er+MXAVN0W4rTpJDqYzkmCZghu4H8yNg5wBMe0G93KvxGYq48CvxdsQ9XLyqliSiP6xtP3YIrNcN2gijz6CIA4wPvZ9IBa2Tygxhc6vAKNC33465UnqEURtj7jEkikgzdfXt4SsM99JT7H2Nwik/lLDmeDnskO+XaG2zEsXGQXpIkd2L8aANZ4a/zOkgl4ee+axVdXpdUViQgYH3W6X3JN4keSA4Ll1L+ONO3JQbr/G6jUKB90CBzURocJ9yRTc6gsOCHYCZdnXjJpgI7unfAy1k4TPBvCiXfWmpZljqpSUoB64yknuR4FeT64nH/8/0OR1oIwi0d7SEO+BmcYORxBD1sM5/mssv0sRXGwMCJhatUzdRRlTiKMUqDE6KOB+JzuDjAm4jQQhX/v/1zLT6lI+QPdJjzhKR/2Pjo0GgoARgnnI4qJ4soe8
 2/hk7kjw
 ZCqJPyk5Q2yxNYBz1LGBkZeTMjf/u8fYKidnlvjWYErNlX+JBdE+gnOoMBKowRkCzMlHkPAZZBcb9skdTmDqXLTS84hvTmvW0eWLYUlJ+m6RYvKrYKPFeolxv5XJXudTqPoH7otnHx79aqHbEQVANSF3x8c8tsrA10Tv3cEacWO53J+PTMFPU0RsxbrpVaVbOpSSGGtzfbXlvvYLNBO3bRvabzhdj/BXgnN7AE26oYgVMd1LzApLgnvzlDO681MsFT6Xq1ruFRidha91v8cY8byNdOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 15:08:47 +0800 Wupeng Ma <mawupeng1@huawei.com> wrote:

> shrink_lruvec() drives reclaim in SWAP_CLUSTER_MAX (32) chunks, but
> isolate_lru_folios() may scan far more than that per call on a single
> LRU.  The excess is never charged back, so shrink_lruvec() keeps
> rescanning the same folios round after round.  When reclaim targets a
> lower zone, the same scanner also keeps walking zone-ineligible folios
> that can never satisfy the allocation, inflating nr_reclaimed into a
> false progress that delays the OOM.
> 
> This series fixes both:
> 
>   [1/2] Charge the isolate overshoot against the scan quota so the
>         next round skips already-scanned folios.
>   [2/2] Stop scanning once too many zone-ineligible folios have been
>         skipped, instead of force-isolating them.

This all sounds fairly bad.  Is there some report?  Real-world test
results?  Laboratory test results?  Something to help us understand the
impact of the issues and the situations in which they occur.

Thanks.

