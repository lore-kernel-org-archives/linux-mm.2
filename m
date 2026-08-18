Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B03A0C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 06:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940F06B0143; Tue, 18 Aug 2026 02:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1BF6B014D; Tue, 18 Aug 2026 02:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0B76B0151; Tue, 18 Aug 2026 02:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 580756B0143
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:01:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4A7A120AD6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:01:38 +0000 (UTC)
X-FDA: 85113343476.15.49154F0
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2C7AE4000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:01:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf07.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787032897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2HWQ+1Hofy0TiNJM3gg9vufAVBmsJX2uYq+bDtHscK8=;
	b=zaX8feLh+qhdbcyw4YiJxVC6BCYxyHpZvS2AYxmvZ+L5CO6jhEsep1EjdW6UIBT/KUoWY4
	uFM10kTMPrRCtO+V3kqn0i7VQ09/w23Awy/n5drtOZSoI8dnyzd6NjXoqodhHSX0pW4E0R
	4l+qeEYI11EgIfj655CL2ZWVOlqIrZU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf07.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787032897;
	b=RvlqEFu3PCBJPrTOWuh52lZA/ieQ9EkWNz5BiTgdrwbcGIDWrVdMzeiFMifrZtxkf1z5AL
	ldqcEFE0dOkYN6A1yok2taFBK0t4Y1wgrGoP9XTm0JhCCv53r/MUf5rLRn/RTOW9psOyz5
	OFYrPoqYFRkHsFtkO6TrNZCaclfwbkY=
X-AuditID: a67dfc5b-c45ff70000001609-84-6a83f53a1e00
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Tue, 18 Aug 2026 15:01:25 +0900
Message-ID: <20260818060128.1876-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <aoJY53BJztPQYumw@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXC9ZZnka7V1+Ysg7svTCzmrF/DZnH38QU2
	i103QixO3Gxks1h9cw2jxfOtvxgtft49zm5x/dZKRov9T5+zWDxoWsVkcXzrPHaLdacOsVmc
	n3WKxeLyrjlsFvfW/Ge1ePPYzeJbn7TF/T4Hi5U//rBaHFm/ncli8qUFbBYdL++zWNyacIzJ
	YvWaDIvZR++xO0h67Jx1l91jwaZSj+62y+wem1doeSze85LJY9OqTjaPTZ8msXucmPGbxWPn
	Q0uPF5tnMnr0Nr9j85g6u95j/ZarLB6fN8kF8EVx2aSk5mSWpRbp2yVwZayYNpm94BRnxdbV
	vewNjNfYuxg5OCQETCTObo3uYuQEM48u38cEEmYTUJI4tjcGxBQRUJVou+IOUsEssI1V4tZF
	TRBbWCBIomv6c0YQmwWo5Nny2Ywg5bxAU9raRSEGakqs23iLBcTmFDCTuPTgOhuILSTAI/Fq
	w36wVl4BQYmTM5+wQIyXl2jeOpu5i5ELqPcru8T7qV/ZIAZJShxccYNlAiP/LCQ9s5D0LGBk
	WsUolJlXlpuYmWOil1GZl1mhl5yfu4kRGKPLav9E72D8dCH4EKMAB6MSD++OD01ZQqyJZcWV
	uYcYJTiYlUR4P04GCvGmJFZWpRblxxeV5qQWH2KU5mBREuc1+laeIiSQnliSmp2aWpBaBJNl
	4uCUamBMeF7oMPnf3KKPCsuZj37dvCTl6J9lQuVc1xb0RK2OlhTXaJ23beY7Uc8dZ7iMxGzF
	nwvVfo/Xdp3lJyTH/aI00tzkfd/N/b9lT2SeXHX83HRWs+pJjz8GrjjSU1O1x2qz4gEmz3cG
	OiKWXo7LTYU5Xhn8Va4MuL97n0eSisrHoqbrwg0vK24qsRRnJBpqMRcVJwIACE9UAM0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXCNUM9Rtfqa3OWwa+HmhZz1q9hs7j7+AKb
	xa4bIRbnpsxmszhxs5HNYvXNNYwWz7f+YrT4efc4u8X1WysZLT4/e81ssf/pcxaLB02rmCyO
	b53HbnF47klWi3WnDrFZnJ91isXi8q45bBb31vxntXjz2M3iW5+0xf0+B4uVP/6wWhy69pzV
	4sj67UwWky8tYLPoeHmfxeLWhGNMFqvXZFj83raCzWL20XvsDnIeO2fdZfdYsKnUo7vtMrvH
	5hVaHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NLjxeaZjB69ze/YPL7d9vBY/OIDk8fU2fUe
	67dcZfH4vEkuQCCKyyYlNSezLLVI3y6BK2PFtMnsBac4K7au7mVvYLzG3sXIySEhYCJxdPk+
	pi5GDg42ASWJY3tjQEwRAVWJtivuIBXMAttYJW5d1ASxhQWCJLqmP2cEsVmASp4tn80IUs4L
	NKWtXRRioKbEuo23WEBsTgEziUsPrrOB2EICPBKvNuwHa+UVEJQ4OfMJC8R4eYnmrbOZJzDy
	zEKSmoUktYCRaRWjSGZeWW5iZo6pXnF2RmVeZoVecn7uJkZgjC6r/TNxB+OXy+6HGAU4GJV4
	eHd8aMoSYk0sK67MPcQowcGsJML7cTJQiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9XeGqCkEB6
	YklqdmpqQWoRTJaJg1OqgdFl/qbSS7d3Z2ccnMN56dGi5qMNUyWDVZqXLajcd27/Fx6BFXlJ
	T+8znPnGIiw6d5r0XNar6u6yM/r+Rq14uqRhI7O3D9fjs55KW49w2OQ7/7vRWnTBNztAaIF0
	e/aK83zTCjblpJaaXjwh8Ud7dtEF49bixnPl6rk9QV/k34WtEfKZ97nd7pASS3FGoqEWc1Fx
	IgCfDHa9zQIAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 2C7AE4000C
X-Stat-Signature: d5r5grhg8qaquf786cashz9x4eykjgt7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787032895-167535
X-HE-Meta: U2FsdGVkX1/9XAippTIyubohuiPbDLoWvRxQYmaYhHnIUQB4AeSosfp80DChgLAosDldwc5vzsdzU+Q4Xbtdz36w+CBts1bsZx6B1r27kChzH+N/E6wbmm5aYgZW6Ul6EuCLEYsuhB58VIDwsx6bQbLQ8+kWw5dm82TffyxXlo7ZDH389EZk86S1qnddg1x7XmOEabuUMIKrlMW6aO+ZqPekfrjzTDoJpVhWzKzwQKrY31JRL1t74q4WlfN2SKvPtCPmysqkaVTOlwQ7rVLaJFYQTg++fuvXbe/3BOhCrdu6GEVq6s9250pAvgm0gcw5V+mnNdQ4zaN/joPlfWmJuhuzX5Frps847M69Qb0lLxQSzcokvcgRveiI2ikqi32/F1s8Lku2bbL+yVKnKOz3T6mNfWl5v+jYYR7TqWyxhYKuIaDVknUyJ+VUJQfY/fLHUWBgQUKZsExqISaWSMhYOkudo1roJ+48wxKIeM/YMyM2cjfrZ8riKL681ijz7Ui9nurxQrJkZlFUJut3VFK3I66AvytbHbFt5MAi9MEbNF/JxPpY48xLfF8UuDiOIieO6DduNLPZ1cj4fwECgN2Pgp+GndFda7PpBkN2wF+kMg2mgEAA+kFBmd4IyC35ry/Dr02rRmWWHv1IKqfmQOJDYkYHq9d5zXADoE07gfc5zuskKaaB/mAIE5QFwQiCU9rcgoI+KgV7gbO4xjeFk8xl7NlZqgH3vDzb9CenuQRV5oDaNNdLdGPBzLSYE72Qx3mxzxm+G43X0vX05IhIdwcoA1sRPveIqzd3iwvX+fUgfDYtJEVJZcTGcerFoCHiclEKDcqwSS6E7Ab5f+t0jB1/dXuihW7wJyl7BOqNLBiaJxmEMkbYxmx/LXwG04vvTEIp929NvwiSCPYQ/2jvpk7YnxOnAH14veyxDyZSnu/eFXcwM6izJALFf/bsWQABMKOIWBZvs8muq9JsZCGU1l0
 N5Y/k3JF
 hdr94nT7HX7Ghgo9vaoRqLfOccSR1Po4wRloWxYY6oUb867bBfwYT30WSJ0YhZBtF2FYs5E9oMwsgmo53feBKQYQhU6oLw/yA6P54bWwISCbF6oCUIiEJxhkSCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026 20:46:16 -0400 Gregory Price <gourry@gourry.net> wrote:

Hello Gregory,

Thanks for your review and feedback.

> I think you are over-complicating the explanation and that's making it
> hard for folks to reason about this.

You are right. I will keep my explanations focused on the key points
from here on, and the next cover letter will be written that way as
well.

> My best understanding here is for multi-socket systems, weighted
> interleave as-designed is inherently sub-optimal for scaled workloads
> that utilize multi-socket ("package") memory resources (DRAM, CXL...)

Your summary is correct. That is the problem this series addresses.

> I think there is also an assumption that total memory utilization is
> less than the total capacity - otherwise some of the assumptions here
> break, but that comes with the general weighted interleave story.

Your assumption is correct. It is the same as the existing weighted
interleave: when the nodes are full, memory is allocated from other
nodes.

> I'm getting back from vacation, I will take a closer look this week.

Thank you. I look forward to your comments.

Thanks again for your time and review.

Rakie Kim

