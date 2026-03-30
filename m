Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24CCCFF492B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 00:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184116B008C; Sun, 29 Mar 2026 20:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134C86B0095; Sun, 29 Mar 2026 20:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071B46B0096; Sun, 29 Mar 2026 20:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED61C6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 20:31:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67197BA84E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:31:57 +0000 (UTC)
X-FDA: 84600851874.11.808A350
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id 875EA10000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:31:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jY/zQjSN";
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774830715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2icZm2yEGwYk11apPC2NCV3wohko97JViEVKbyQOpg=;
	b=BXiTiiaT8gCRyx/XUNOzIyRu9wvmiXLIbwLA5He2kV6Nyd4e/bW4cgKN9DeWFY0oY4KUFp
	9r8k0tbrvUzZKp4ik2i9QeLTd8AacsmUDFhvlluQg4CqRpY+J37HnmvoBHSZ0F0YxtvJn7
	lM3IGwrVlysg74HNP0ewCH4eCUN0Vss=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jY/zQjSN";
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774830715; a=rsa-sha256;
	cv=none;
	b=j3xKD4wqCP4NM+OVmmzX5VXmXFoawr9ulwMZUk/sPmvj9pny/S2oIwnHk3LpjU78y0mTVF
	qXrvtkN9DuxTAwyIofeXl6E/2Ccxgsf3ohdT15lJEY8bc+u3AfzclHVqCTVmNIjcIIEd+5
	xGgjAvyrGr/LsAuLmIUrHxzUyJqra60=
Date: Sun, 29 Mar 2026 17:31:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774830712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p2icZm2yEGwYk11apPC2NCV3wohko97JViEVKbyQOpg=;
	b=jY/zQjSNjUidoC62UBg0OA0sKrFsL+KCacqNbq6kXTm0lK+Lckqu0s9PXY9mQ1gOlTXtis
	imQH2I5cUEis8dalola12yuStuWPcxZ+rcmfes7WwtW4j5J30xo+UdDq4mi0V8F2rWXwf+
	0oXkj1u+gCadsTseo6DpYkh0DN9bIbg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
Message-ID: <20260330002340.GA116015@shakeel.butt@linux.dev>
References: <20260326185629.355476-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326185629.355476-1-ljs@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 875EA10000B
X-Stat-Signature: k1np6y3883rszqzk96ymxfwz9yxudcqh
X-Rspamd-Server: rspam06
X-HE-Tag: 1774830715-611997
X-HE-Meta: U2FsdGVkX1+ZLY5WJ40dqIkyBTvL3ezPD8u8xz1gzU0iCWW7z2xmDa4GHOh9ZVnRVUbvogMGI0A6fC7tfJB9goM0kLf2AYZUy7EO8Dt3K1jWUpeRp4CdcFuJ0wLDpOxVrSMsaua6CKzFtYWk3QWlY591M6eKGtAglyiSPOwgDT+qplpqXQUnknL3jCZ+qCCJXQPiadGDF4deSLztg6GE+4sGpn9/uq4jKt0gKnEIv0bMWx2JS0NHgVMstau9p9F1UxzcZ4QVCMfKX38fppaoUd9Su43AH+xDPni8aDYcGIp8pmD3T1RM/k0N+5blUqUOMACOKLglPkEVZw/7iQLOCocYPig6HfsZLHVMl4ETsPyYni9HffOdDvimx8sy9cIz6/89N0qoQpNvHAYMuUFMr9HiqrXcRVNZCcTQoHac8EmOmfmE/7A5G6aFuL1ppYokXHzO2Di1s+sDqTJC4l5dV40p+em1hVdsdCqAEnh11BZjb9zJuZCi5OO6rGHQeuNoVErhJRVU0SP/pyoqhQ/zq52bndXfYQEouNoEbKDhGf9Gh2sz4L+aq5SarOGCctpsU+cBmDJ97nTA4qiWpVhkjIjhVUVEFOuIV/CvrKLu54trlzle8218cSU04kSMRdv4chLneOGvXRjQlP9+0uCdWK3kDbIk7fAOQQZyn+8Rf2F73h4iy0esnKjX3TiNretCuBGWMIZa0xQWAL45XPoVT6YFhYnd3oro7UhZQnRuxWPZ7aDKtdqfqEwdJqss9yTvVhEahWiinr/GlQdT7daEXDRl6BuAdphfUZKBPyde5yZadeOboM7CjIolh4IFd31rFyGS3HJAOI8RD9GY84NYDD8Obis2Jw2IHPacBnpmq8QV5+qGjIpouQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 06:56:29PM +0000, Lorenzo Stoakes (Oracle) wrote:
> We are moving to a far more proactive model of maintainership within mm and
> thus put a great deal of emphasis on sub-maintainers being active within
> the community both in terms of code contributions and review.
> 
> The MGLRU has not had much activity since being added to the kernel and the
> current maintainers who kindly stepped up have unfortunately not been able
> to contribute a great deal to it for over a year, nor engage all that
> heavily in review.
> 
> As a result, and within no negative connotations implied whatsoever, it
> seems appropriate to downgrade the current maintainers to reviewers.
> 
> At this time nobody is quite exercising the maintainer role in this area of
> the kernel, but there is encouraging activity from a number of people who
> are trusted elsewhere in the kernel, and who have contributed relevant work
> or review.
> 
> Therefore add further reviewers, and at this stage - to reflect the reality
> on the ground - we will not have any sub-maintainers listed at all.
> 
> Each of the files listed are shared with other sections in MAINTAINERS, so
> this doesn't reduce sub-maintainer coverage.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Haha, I feel like I am shooting myself in the foot, but if I plan to
make drastic changes, then I need to step up and take some
responsibility for it.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

