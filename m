Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6DFCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E454F6B008C; Wed, 27 May 2026 16:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1CC16B0092; Wed, 27 May 2026 16:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5AD96B0093; Wed, 27 May 2026 16:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C35B06B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:40:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 547D2406CB
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:40:49 +0000 (UTC)
X-FDA: 84814368618.16.9BC4FA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 850D5140005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:40:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=usZ7Emty;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914447; a=rsa-sha256;
	cv=none;
	b=6w0iyD/sg/nfk3UppLpJ6qD3vTkEy9WGZmMbDyCPig8jDMBQGLJlQImbB1oDjzpsfbM00k
	DBJcnoH8yX0CT2vMLuVGw5Jac+WsyvnbQcqoBZ5wvq5W4ARSheZ1qzsZXwqDzAsqil7I4D
	95BP890zY0ssYQ2W1hnTv6vhL6kNpK0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=usZ7Emty;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K18ZCxw4OmGVcQ0DQtRnxx99q7AnNG+EcuunEAg1YDc=;
	b=lw3p/XhBWTsBBdsY1zzkQjuQu87IvytXlFheZQAcX0oV92mb2I1IClYQw5F/Fljdwlf3pL
	6jB57ZTdzj1GNUYDMf4HNn+7GjjlbcPt58x5lNswj4q5Yev6YNA4M7owAxiiMVbuNNJH+3
	JCbcpx/LsfY0OKq3I3R6qjiZemgq3vs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6188C40E09;
	Wed, 27 May 2026 20:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C08C1F000E9;
	Wed, 27 May 2026 20:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779914446;
	bh=K18ZCxw4OmGVcQ0DQtRnxx99q7AnNG+EcuunEAg1YDc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=usZ7Emty9g6yWezElWjkbxY5gG2vPSWN2SmNAW/t6XOowxIVuHJEGg7MhmhNz2psf
	 ZdpRQDvC1Q4TmMS8x8XAEBcsLqVSPZMCf1K3lmJe/tkYKy+33r8Uu+xpUwZUrBfhCD
	 DBfi9lycLqlCc3OqvLyxICV7Rfop+Q9pIuphWYmI=
Date: Wed, 27 May 2026 13:40:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens
 <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, Leno Hou
 <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao
 <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, Qi Zheng
 <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-Id: <20260527134045.0b697675a0d0641a24f08d0d@linux-foundation.org>
In-Reply-To: <ahaCaP3b0ojBtCsR@KASONG-MC4>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
	<agH7qYcyFgRzkQDB@linux.dev>
	<CAMgjq7BzQAPp8u_3-9e3ueXmRCoW=2sydok0hFM=MYL7VC1YYg@mail.gmail.com>
	<agK-rkIIZlwBiMsv@linux.dev>
	<20260526183506.ffb1bbe41043c6247557caa1@linux-foundation.org>
	<ahaCaP3b0ojBtCsR@KASONG-MC4>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 850D5140005
X-Stat-Signature: 4twjnd75133jxsmpmeysypj1xp7rjcdm
X-HE-Tag: 1779914447-957598
X-HE-Meta: U2FsdGVkX194sm8MkntTE0skXwwSu9aR7JHBT9SV+6zMDsZZM0QzY/9kxxHhlZHLHVONTxcZfldt/JWi0ciZ2MIlAelxoZTFqU8rbIMUp+TyX19G3sI3dw2Q9IBxHmaaLEwDSq1x5D30Us94lA4gQXOnGsg36zOxItis7Fm0Hzq0PIklJlbB/vGAiHVxGd6Gs3XT7d4gXUDASQo/STDhXrHwefGJrl8RPIjYCgKaHIOzCz9MWvYFQd1/jndrWRGEAFJZlVi45zUvbaZt8tMKqFcOiG1qpNNjYquEziy67hlnMTkl2k3JJ1smBWgUn0UEjCeTl21ttt+cEwXYwoDgf9Ny+RGdjiTxhYZTIA7t5MWbT0m4QrZqjVV7N8728BSZHmp4fvBUcuBv7uCCSDPexJ77vPdG2GZZ6WJNeHhDVuRLm7URyIFW3iuNkF3pzleQ2HDswkUu7BZncsDARwrBhukUiSW+ESmm20HOIE0Us9UDXPr8FV17PfNwwj3hy9FvnLak8fuQfmCILVQIk9wq7O0XvDLK1bG+UDm3bLFak2wHESfRSybCv3GusyIiwoKoZjhnDakIduUY4Dnyu7tG7dACTfGX/wydN73hd4VkNThoiRQayKyRy/MAZ8x9S9ioVGl9yWOqlV+dJuMlV/kNcbK0Iy+y46Ocidm5OPlkauDtf4EcVm7twIbFVSWYsNRV9MfUX12dKj+LQMBkgBSZVPm/1+NolpkgnMVrMALRKQcoTZewpwUQQ+5Hz17Kak1MqSzi/XVBvo9YHcARowytqzB7w2+QCXBzngZyk8b0cDDNUPsP2xIYutWE/zZReQmHWV1je+aM3YDMvDZYAO16u13muUYlwQ9MBzmhLTLI2E/4i6raUj4Rx9zPJ5gK3DCwquxv6wGRcTOZPgSVGIfagJuztU18NnD6Y/0xVufwXHgruiLmm6YFdPLWAASODoVrkw/ApE+HfHkaDrT548p
 vLigGZjQ
 oYcIuQbRg8o5r4fCcTjRx1cGVw7I0nVymu3De+uwkyzPfiPLobjA2hodp5eSbJLEn7i5KwtSHjz+SD5vozfUiTjjxiaHyRNodxW1bDnvFIuTS7+qybk8ioR8lqnkhSpIbPPq1TOfotz1qY0+kJAvImcEVJDhaFcolQaplKGP1i1dC6PN15gllCoN7UJvvUVAZS6UpCIdMMBMrdbpa79CFmR2HZX7kuA3DTSSyhtwGf2xTRM08atlaaY1/hk83DCw5eT/j3R2nFrdmofPt4ocCAxoV3FpsGOZQFpr8N0PsrGFp3EXCdj0CKZaXrLo2/go/PW2XSf5/mv536x3zaYX0gsTN2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 13:36:06 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> On Tue, May 26, 2026 at 06:35:06PM +0800, Andrew Morton wrote:
> > On Mon, 11 May 2026 22:56:21 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > 
> > > No worries, we have couple of weeks before the next merge window, so no urgency.
> > 
> > Well, no, not really.  Some schmuck wants to get our
> > stable-non-rebasing branch into upstreamable shape well before the next
> > merge window.
> > 
> > This series was issued a month ago!
> > 
> > Sorry to crack the whip, but let's please all be aware or our
> > upstreaming timing.
> > 
> > > I will go through the series in depth, hopefully there will not be a need for
> > > next version and in that case, please just resend the cover letter with the
> > > information you provided below and don't worry about the length of the cover
> > > letter.
> > 
> > That's a plan.
> > 
> > Happily, MGRLU changes are well-isolated so I was able to trivially
> > move this series to the tail of mm-unstable.
> > 
> > It isn't a problem at all for me to defer this until the next cycle -
> > please let me know.
> > 
> > I'd like to know this as early as possible so I can hide the series
> > until after -rc1.  We shouldn't have "not for next merge window"
> > material in there possibly invalidating our ongoing testing.
> 
> Hi Andrew,
> 
> >From my side I didn't see any major reason to block this. There has
> been plenty of review and the series has been tested many times. I
> also re-ran with more rounds, with CLRU baseline, and the numbers
> are very close to what was already posted.

OK...

> But anyway, looking forward to Shakeel's review, and here is an
> updated cover letter folding in the additions. There is not
> much change: refreshed numbers, an "MGLRU disabled" (classical LRU)
> row added to each benchmark, a short note on why each benchmark is
> used, and three extra Link: tags. No code changes:

Updated, thanks.



