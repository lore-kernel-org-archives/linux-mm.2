Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4A1606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JQeUkzQY
Received: by kanga.kvack.org (Postfix)
	id 907BA6B032D; Thu, 22 Oct 2026 23:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE606B0331; Thu, 22 Oct 2026 23:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6816B0334; Thu, 22 Oct 2026 23:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56A6F6B032D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:53:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2589A7C95
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:53:18 +0000 (UTC)
X-FDA: 85352520876.01.BBED852
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id D442140005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:53:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JQeUkzQY;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792727596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWFIjtO8fXCI6gQg7xtksfY8ge2KYVwZr2dd9QfCdUY=;
	b=wCDh0V64h2bTyULLLRiQ+w/VW1oLCpdVC2EdWY2gz6+OC84i9bAVUXtwe74PgEc0ItZtNs
	JdHg6KLBrDKwX8TA7pbWkkVZO17lOWaHXbrcrKcaSDL45FwABhcz+gWFgtexPgvPRGZpxO
	Itz/esbK5y33g7ZVhRNzHKsL/K+BKkI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JQeUkzQY;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792727596;
	b=dF0etVIIH+WXxFXValrSXIcNCnSa6n/NH8g2h5GTrSVM+WCDGNntUan6mqYu+JT73uzIaw
	L/W9xcuusFxtMy1cjIzlSwVcQxwON5BYsdNnXijN+k3609AnsGtR8ysA8o5/POJvoNZ6by
	YigeQ7erWh3Om14Gq8YoJVngi4yBmGY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iWFIjtO8fXCI6gQg7xtksfY8ge2KYVwZr2dd9QfCdUY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792727594; v=1; x=1793332394;
 b=JQeUkzQYWxbaTEtZwc8IJcHuWgNDBidRhM+r+sY0Nu6FaptC95GT8kJCqk7yX4qY3RC7L5FO
 yfJiVV534gEsrutA4IpJuF/GqXn9vyxOQ7a3dX3MH0PUYMKvDWUffetOanMw+fdDyjdXvWt6Ns3
 cbMkWHPPx5sRxbCYtPJg8zLk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9bef591184831a03;
	Fri, 23 Oct 2026 03:53:14 +0000
X-Mizu-Trace-ID: 9bef591184831a03
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] mm: hugetlb_vmemmap: unify vmemmap range restoration
Date: Fri, 23 Oct 2026 11:53:02 +0800
Message-ID: <20261023035302.39047-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-10-songmuchun@bytedance.com>
References: <20261020115824.823278-10-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D442140005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ysn74eay9qxsqfrim5wqyazjm9kg4wzw
X-HE-Tag: 1792727595-443360
X-HE-Meta: U2FsdGVkX1/Z2AQhStT6DcumEUYg96rh40zeoMXGOpCdsbxlnfL8iKmMdunPiu3ZV3rVJLmszOzqXBaWwA5nIVdGYgF8cBWPJzpCq3px5otSQsfAp5EgqKpngxk4C5rDjZkEDz5uWiIwHYBG/Hew8y6T9dhn6KcUPHyFz/eN6hHI4WB3JkBekmcYVukMbJhzbjDc6iajqBcdsD3QExaQmXhJIV2HPdvFRvQ8JHjYFmZGfTcJK/zH0qO0uSBJ/bGv9UYRuucgSfehx5a5D0S1xOwX5NpCgx1Xh2V+iXLK6LkRFmBxGA60FwcBDo6RqT4PleIzAq12Nz2ka+7sqCCiBBGfee+fptgbily6B1m6VHbfIkT32D0GW7Mus9N9L/yOtXGQP9kX6qTb8xsFWhMHsx57ceBFkpvGUzvZseLnDNKz4EKEf5mpZvxm5nQuAdGvOBcSvSQjtbBux8HLOIWLxTTvJJMOxXmRwE0KimuQi0cU8/+pbsOTVz8cwTc2sWCBKWbISRJgz17hQbN9/2FKtqpfD6sLJ2QREzRD8aQmhzMvx7MPL1v8sECsVE48Jtp2uPbDy0ywI0UftNWEKua3+41OGsawIBXOQ3nsUWINetTTgDfC1zY8a1+hk1kIW85n/Lq36+ykydfes9cE75OKjBztgDqdRiDb58gzh8572TKmRGR0jpmD2/38KU2/Pisqzr/U9d92guPiy64BeiRDsXsls1qs5xgSC5erfxFmSd/WfxIuz4fm97hmtq1xBs7yQXv4YeyZcAoJiO3pjssYLwEdgYN5QK9QSyo7MHafLfYzC53Evxu/gJ4P9XI4if7KXBoNsfL/6X8YBi4S2sp0e6hVEiI4cTjpnXkGQC72ZKnicqhck8Axd1fn32BdONPfeDcr0ZN94k+kGeumB/55luZADo6rhIXHlAm0zuw2E8zH99kHyeZL7UJ1WZbnBlvLgyCUt0388lTiwiRE84d
 xoTW317Y
 7h2nLBkOux+YYUICxglkIjM6dgNRiY1c8F1gDbfKu7uTw29edl1/M1EI3gn2hu2zaSWDCOLFDGleauD74CeEqjPNr5pbJOa7n43XzuDtQ0PpEhs3qNUvqQ6cTtnQGsgg+LpR0qA4HJdlRziDLzIOLActiTLp3oW3AAox/MRNX01wk++6KnA2GoyU+cuYnierEpOqPv3YEBrE0YywLisMcctRk7064P1HrSEuJ+1+BR8wNCKgulgvHZhyX2WBCDlj/7n0AieTmDVBrJMvMEN6+eJ9YCY85yXltIHVwRu7c18lt/p8M9QXyHb7XxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:23PM +0800, Muchun Song wrote:
>Restoring an optimized folio and rolling back a partial optimization
>both restore a vmemmap range, but the operation is currently implemented
>separately in each path.
>
>Use a single range-restoration path for both cases, making rollback an
>explicit bounded form of normal restoration.
>
>No functional change intended.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Don't see any behavior change, LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

