Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D74C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 06:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2D06B0153; Tue, 18 Aug 2026 02:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A99E6B0154; Tue, 18 Aug 2026 02:02:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597B06B0155; Tue, 18 Aug 2026 02:02:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 350D86B0153
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:02:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C121980AB9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:02:09 +0000 (UTC)
X-FDA: 85113344778.15.2DBDE0C
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf19.hostedemail.com (Postfix) with ESMTP id 484461A000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:02:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf19.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787032928;
	b=PgYplAQKi2uHujw3uc79/avs4DguNAhWySTvHC7CpehEYkU6Q6RSrBlNhUUMyrzwfuEm5p
	ydoSEbkOv9+RSpZ0+Apw8958E0anLkuz5ILm5vrZ2Jc3JiCLtzxCpLN4F2Sm7M5SxsNTy+
	wHsh8QWJAAxcT6Ye7bBgpQoqIWTpx24=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf19.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787032928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YEcKHSQ7GoBdaipl+H4JA3MidQKty5prCX/yhILT0h4=;
	b=cIvKirjLWcj4oMBDg3tskC/kS7O4ryK4Lnr9CdZN7njxMsz38rfG6+16TOhd7u9YOJCn6g
	GQwNEnsD1pItRe7Y0b81EBH3SA6j0KuKPAiV0Bs7w9SE8fLyKoOagmjiRasaoydMpxhme4
	gXNr1iEPhLfgPzKf96G3JEfHruNKadA=
X-AuditID: a67dfc5b-c2dff70000001609-d4-6a83f55bd736
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
Date: Tue, 18 Aug 2026 15:01:58 +0900
Message-ID: <20260818060201.1907-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <aoMv3OhqkBTzSfek@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsXC9ZZnoW701+Ysg38vFCzmrF/DZnH38QU2
	i103QixO3Gxks1h9cw2jxfOtvxgtft49zm5x/dZKRov9T5+zWDxoWsVkcXzrPHaLdacOsVmc
	n3WKxeLyrjlsFvfW/Ge1ePPYzeJbn7TF/T4Hi5U//rBaHFm/ncli8qUFbBYdL++zWNyacIzJ
	YvWaDIvZR++xO0h67Jx1l91jwaZSj+62y+wem1doeSze85LJY9OqTjaPTZ8msXucmPGbxWPn
	Q0uPF5tnMnr0Nr9j85g6u95j/ZarLB6fN8kF8EVx2aSk5mSWpRbp2yVwZSz68J+pYJNkxa4J
	gg2MG0S6GDk5JARMJKb9XccKY2/8M4uti5GDg01ASeLY3hgQU0RAVaLtijtIBbPANlaJWxc1
	QWxhgSCJrunPGUFsFqCSZ8/fsIDYvEBTZn28CDVRU2LdxltgcU4BM4l3F36yg9hCAjwSrzbs
	Z4SoF5Q4OfMJC8R8eYnmrbOZuxi5gHo/sktMuNEBNUhS4uCKGywTGPlnIemZhaRnASPTKkah
	zLyy3MTMHBO9jMq8zAq95PzcTYzAKF1W+yd6B+OnC8GHGAU4GJV4eHd8aMoSYk0sK67MPcQo
	wcGsJML7cTJQiDclsbIqtSg/vqg0J7X4EKM0B4uSOK/Rt/IUIYH0xJLU7NTUgtQimCwTB6dU
	A2Nte0hHgP5Fv5JcFYmHxzzXSwvu+jyLte9ut/XvnadLr84LmR3gWnesfM+l6kPeF90m+Hlt
	KHv2W+i3yz3due4fZTWavuxb+kRw3Rzj917Xz10/Ntlk9qbNaZO0eLt9psz0tdrnvPPq+6Xc
	0tE2alOYToqkTNwh1zy78byjx/S0HVv2PK7zzXVRYinOSDTUYi4qTgQApXRiQ84CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXCNUM9Rjf6a3OWwcJlwhZz1q9hs7j7+AKb
	xa4bIRbnpsxmszhxs5HNYvXNNYwWz7f+YrT4efc4u8X1WysZLT4/e81ssf/pcxaLB02rmCyO
	b53HbnF47klWi3WnDrFZnJ91isXi8q45bBb31vxntXjz2M3iW5+0xf0+B4uVP/6wWhy69pzV
	4sj67UwWky8tYLPoeHmfxeLWhGNMFqvXZFj83raCzWL20XvsDnIeO2fdZfdYsKnUo7vtMrvH
	5hVaHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NLjxeaZjB69ze/YPL7d9vBY/OIDk8fU2fUe
	67dcZfH4vEkuQCCKyyYlNSezLLVI3y6BK2PRh/9MBZskK3ZNEGxg3CDSxcjJISFgIrHxzyy2
	LkYODjYBJYlje2NATBEBVYm2K+4gFcwC21glbl3UBLGFBYIkuqY/ZwSxWYBKnj1/wwJi8wJN
	mfXxIivERE2JdRtvgcU5Bcwk3l34yQ5iCwnwSLzasJ8Rol5Q4uTMJywQ8+UlmrfOZp7AyDML
	SWoWktQCRqZVjCKZeWW5iZk5pnrF2RmVeZkVesn5uZsYgTG6rPbPxB2MXy67H2IU4GBU4uHd
	8aEpS4g1say4MvcQowQHs5II78fJQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8XuGpCUIC6Ykl
	qdmpqQWpRTBZJg5OqQbGjCy/b6KOyqdvH9aQv/5v57TNjhuLfxRzzBUuc0v+05rXerGv7H1U
	7LvsxCaep4+XF8sV3LjP13F+C+tcvxJ5z5ux0nFqa+Lzl07szd35rrIzp2i9pGt59CIt0S8P
	3058Jv3ZffWH90nH7i6+lcN8JURSV9g6NJ1l4wEvB9kvS5+8ORdm66mixFKckWioxVxUnAgA
	s7DBg80CAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 484461A000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ninci3r41bd431gb4a7q4m77tnju37y1
X-HE-Tag: 1787032926-703493
X-HE-Meta: U2FsdGVkX18MgBVNDEec5cVT7GcbD4SKccg3JYYud1wAx6QbiYQ1bSCjTo8l0EYUG0d0chqen9LLN+F/mF8QB3CJGwCEb5x+BI92msWUB6Kx94aU36VNHCI4Dw5gIfpHOyOx0Qz9Wvz8VIs/uy0KUGb1oz5kL3QSZdnhI0RHkERA6FUSaRuWnzK/JikYJwbkJFR7ZaaxTDpHJiEMxQ0CuSTJ371KZtBpu2KHamXvacRJxRsiAIE4FnV0bLs1zMJE0NYaV1rCpWBYymWVUNGw9peiC7NEte2WIPKz6iHA48OAVYCaItOSN22HNK+mLwX2ymLey0WFDGf7DJopZRLG982SclxopUu3q+7boJA/lpUcxCfPT+1sLOMYY/3yXVH3aaW6VAy00ac81ouE5eqEhNCaTs+6hvnTrJGnOAgnYoHHjdbOSX3odjNX7BSdLdv1Kp3v5qNNt7NLBhEJlqACCMFgW7Iky52Ir2qkl63E2JFg8HM2Ct2a1tlk5uelzYLFCH37gTiTqi/yCt0F3R9j/ZB+PcWm8gLB3rdTTxtETxzpwK/2O8Dj2ipVxPh3AYtf94/AaA5C3x8/NEjPiGh0iflPuK08ZQlfNtbp1okujIMypEEELH2vuscElcVzzdgyBpGR+Hha1DTuJB1uKpW08TVKsybpFaqRRBD9YtmAauQVg4RghypX9jgwVCLJlr1h8+b174uHOPR5szpBWvJ0816ljP24HITbiSDBqLsX7t49/g7rzQk/x28Fo5yUG4265c+L/BfkxogYMowjognq3AHfqFVgWwtTmflnh29E8PPhFdEOu+luibaGJcV1IAzUV+U5KX3nn1wR5kPJQQd2NrQcNf3fS5WmPgzaeS4c8vRkQwpwNutlLjuDj1VvuZPgW2n1V1PCgXp/w2TVUYEA315Qr1MCPYQBLQjM+HpOWdPuUIL1cerN4OFdCQGwEGCuKmfdWHlpqUo7FJfuxrp
 PavJKMCD
 E5A3ggQ23CzCn4aciW5k5JaJVCdAo2y2590/msCQYESgT5QbG5y1+nFqIL7LDw++doKgGRGo0/rYZiNSn3krdTVvA9TNCEVoVC/b25sK2wF+FjUiBpfPlMl463dIgzDeZAISPUDB/Bf/zRovX71D3Joxm8r4vrL5z8BrqohWpa7Rlj3JSgvGy1B035FW3WjvCmLEc2nJbEMu9dV+JYl6fM78ZKEuBXsytSDaKjSRgc0LYzMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 12:19:51 -0400 Gregory Price <gourry@gourry.net> wrote:

> The original attempt to handle cross-socket interleave tried to deal
> with this with a matrix for weights, but this was deemed too invasive.
>
> This brings back that matrix, but not for per-node weights - we're
> basically just adding an addition weighting to filter on.

Yes. It uses additional information to filter the nodes weighted
interleave selects from.

> I have some concerns with the now additional filtering mechanism
> introdced into the allocation stack, but fundamentally I think this is
> a *better* solution than a straight weight-matrix.

About the cost of the filter: when the toggle is off, the filter does
not run. When it is on, node selection needs a nodemask filtering
step, but in my tests the overhead was negligible. I will look at
this part further and check whether there is more room to optimize.

> I will need to chew on this for a bit.  It seems there's non-trivial
> sashiko bug reports here to address anyway.

I am working on the sashiko findings now. The valid ones will be
fixed in the next version.

> When worded this way, "Package" sounds completely arbitrary and not a
> useful distinction.  This really just sounds like an extention for the
> existing fallback lists to take interconnects into account.

Other reviewers also pointed out that the "package" / "socket"
terminology is ambiguous. I think the description needs a full rework
so that it explains the current state better, and I plan to do that
in the next version.

> I wonder if abstract distance either:
>   1) already gives you what you want (the secondary weight)
>   2) can be twiddled in BIOS to give you what you want.

I thought about abstract distance a lot as well. My conclusion was
that adistance alone cannot tell whether nodes are in the same
package. This is an area I am still thinking about, and it needs
more thought.

About the BIOS information: as I reported before, on the two-package
server I tested, each package had its own CXL device, but the HMAT
reported one CPU node as the initiator of both CXL nodes:

https://lore.kernel.org/all/20260330025914.361-1-rakie.kim@sk.com/

I will post an update on that issue as well. What this series uses
is, in the end, BIOS information too. But some of that information
has errors and some of it looks reliable, so I think we also need to
sort out which is which, and understand why.

> The way this is written it sounds to me like this should just be the
> default weighted interleave behavior.  We already know weighted
> interleave does not jive well with multi-socket systems - this just
> fixes that (in a more general sense, Socket => Package).

I agree with your point. The default is off because it was requested
during the v1 review; Jonathan asked for it:

https://lore.kernel.org/all/20260325123350.00004d48@huawei.com/

Enabling is also not unconditional. I added a few constraints, so it
turns on only in a specific situation: when the packages have the
same node structure. I think the definition of these on/off
conditions is open, and it needs more discussion.

Thanks again for your time and review.

Rakie Kim

