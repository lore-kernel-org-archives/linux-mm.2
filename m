Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3791BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC058E0177; Tue, 12 Aug 2025 13:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B368E0168; Tue, 12 Aug 2025 13:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7F78E0177; Tue, 12 Aug 2025 13:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B019C8E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:09:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 673ED160119
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:09:39 +0000 (UTC)
X-FDA: 83768742078.16.A09476B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B4D6540011
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:09:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oL4Sw+hk;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755018577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z07/MOpB5eSCJV0xU8+YoLA3tNkH4L/SQZnYHEJcV80=;
	b=aid2FBlgkBESOZXJscYJwfEa30BQVLa5IoUI9o00BSgGWQKj4Wqo2TzUrtOFA7DUlUZCN+
	ItwWMiWakBHwycp+En3JVcoDXSlK9iM59/HeiDLqq40S/8S5W9nzjks/OymeilnNFkco2/
	IHzJhjB24QGWGkNXXvHb0ScYIPXG6E8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oL4Sw+hk;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755018577; a=rsa-sha256;
	cv=none;
	b=mgZhGdQY3m7Xg7a2y9pTWFag68L4mI6vqvLmOJJ5SN2Y+Z2aYk0iKF6P6GbueqYAoj65/W
	CZOCNVAxaYZFLq4izPgNIvDHlGd6Y8Olg38EeLfsonoAcuZ+8YDd3PbYyNwlwoNu+lauxF
	UUdgRyyp4Z6XduYIWrVL3BoCPMQUE4Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 787B443BB5;
	Tue, 12 Aug 2025 17:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315F7C4CEF6;
	Tue, 12 Aug 2025 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755018576;
	bh=WllhlpeuM1QYj3ynp+yRWpiZPyuig56MrMJq6geJbq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oL4Sw+hk8pHYaYySOCd+3ByAPToVrqxHD3EhBtFQtquiy/gNpJhiIPi7WbacIdYq+
	 JvtT9wxou7H8//kEP7MDOPvjQd4VmV1IYtx+Q/IG6W7pR23Rde8bNJVBEpyN3Q48go
	 wA4XGXVUYZrDwV7DQ3VDcHGRJ/iMWWdqSMG9yafwpj49LkbHWRh15PW0xw9d6pqlkd
	 IAdLzvxQ137cGLL35VCrUz47GH7iJNQYbtJ4KNK0AUoP52esjXltISKF3O/YNUU8ob
	 WX9UxN5jHoZUnM/0UgRfb0OvEIWIn4+byx88nT14VS4T5qmwmL20Aq0dkjIy4XLHU6
	 RrdPlWcKcaEZA==
From: SeongJae Park <sj@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: Re: [PATCH] mm: remove redundant __GFP_NOWARN
Date: Tue, 12 Aug 2025 10:09:33 -0700
Message-Id: <20250812170933.56674-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <aJs9dPMdY_W5uZdc@hyeyoo>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B4D6540011
X-Rspamd-Server: rspam06
X-Stat-Signature: 4xsj4boqd46okjt53hhg1e37pafqgg49
X-HE-Tag: 1755018577-144237
X-HE-Meta: U2FsdGVkX1/OmWC21lweiCLO0vNS9gWkZYe6IZIVlK11GMUk2fIRNGyXyfCNwY+YdT7+KhTB1s7iYUtnw6j3LZlnXO4Gu8sPC51z1snkjYe4L1U1gvOQy3lJZ9quZkymcGt6uwuks+IuVLfzkncDHV1m5/e5DTRo1xNKxiaVs1oKjRZxjEuSRfzveCg+uto7ChCpWk+jfnkQ33CbI7ghRs4MNMNJByDzpRc1rbFmEI6J7RyGKxBuYQmeraGjopEiLfmv0dxgP3N/ezKFRayBGi/UqlRm9lkWlfQE+LsVQDFspD496H7v70XCWSSOHlRygvMqrDaqbzDVi7PBUR0UYCS3N/SGGP4Xq06UhkENAUwt/A9J0FNnIHf6MTATf2pCS9nCf3rULP/vbInQk0U6cxVRmO1HlD7gxEKvS5VTUHBeMDqumY01wtJ7+jS39Q4iWWah8VY2cR9dnohDbDC6FmptUZYKkKuT8XoGR3h/J4SbZ8Nqh++zbSM6x20z/oI6JQUl2fRsRqRdJ6g9jcgYsf7P53whC9XU2xCGn9uvkI9y1UdzEWlZ/mCEWtyrIS2FHxKByHztlWPCWJPYDsVG5KhGEFOO+hUPOL4ZbHJ+6NlkO+ZhTIHG7Qv+NaLAk+adS/9ef9v962L+wBqHeSAfK++ltoGrbHRATO6TPR9OtWvNRNX+AE76dht0S+th+tJaSvQw7uwoC5iD6ZLiVeP+i0DhO24SNnQFP/mGx+QiyWu4PO2nMQZO28lNm8ytdBy+j2DIOhy+ycMIv80lRPvceVFfIF2EQlrRby9jkZV9oWU0RGW9ElzEhAglEXG5UZklsU8DjoZPdjSfPjLwupN/If0lz5i+dGqWOLIGaO4CqpxucxtYpGd2OFaHgui488XtKdusT4OdhAnSTrpkXvxJsMglU5eXPB3N+e/YLFWJ3brrrIy9/wRVfwEHJ+yyutuovmI2Ifp3ruIdJME0Lqa
 LGfI2WOA
 4khCdCgRVG5DbLqzuQDAPhXFL7WxKouXNPq+UTxGD7H4SkUmrHL6OEtawEtd/mPLeJvWFdumXt4iKQ1rurw2fx5ly680Z3AfsUc3BiTV5DHD8cb56sh8R5a7Txc8duCrd+5JWxNZT+o90ZGGkpq/aU2TBEbnyBwfXpR7EHXM24mJr9qvN+1/+pO7SYJ6hVgAoXUJjubz3SzXMnFZsLhH7ob40sWfRGf2ylZz/BpDpU2ZLbEBmadsIvtH7ITtb9ftm0hRI6cNOmg715IYdZ0Y9o4mOVSaNjgP3xRqQXCXdXlbX/EfZpfoDYcCC/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 22:11:16 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:

> On Tue, Aug 12, 2025 at 05:57:46PM +0800, Qianfeng Rong wrote:
> > Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
> > GFP_NOWAIT implicitly include __GFP_NOWARN.
> > 
> > Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
> > `GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
> > redundant flags across subsystems.
> > 
> > No functional changes.
> > 
> > Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> > ---
> 
> Maybe
> 
> .gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>                         __GFP_NOWARN | __GFP_NOMEMALLOC | GFP_NOWAIT,
> 
> in mm/damon/paddr.c also can be cleaned up to
> 
> .gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>                         | __GFP_NOMEMALLOC | GFP_NOWAIT, 
> 
> ?

Thank you for catching this, Harry!

FYI, the code has moved into mm/damon/ops-common.c by commit 13dde31db71f
("mm/damon: move migration helpers from paddr to ops-common").  Please feel
free to make the cleanup if anyone willing to.


Thanks,
SJ

[...]

