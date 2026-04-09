Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0793DEA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 11:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56BCA6B0005; Thu,  9 Apr 2026 07:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542BB6B0088; Thu,  9 Apr 2026 07:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F986B008A; Thu,  9 Apr 2026 07:36:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7576B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:36:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D596CE2D86
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:36:50 +0000 (UTC)
X-FDA: 84638815380.30.D4A1847
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1913F1C0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:36:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Co6DXJZx;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775734609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbkflGjGu8BF8nS6s790ufgH6Ojdrqp4tFiwDkoaxz0=;
	b=PtjB3R7+M9j8L+SGTisEWS58O+7FyoDmhJq+0vB5psKDF/6a8hf+VpHS6ASwrwZFd/LUO6
	0HeMOyO0WQetCIOA5VBwPTzcl/oQEi1OKPdlWZJjwm04FCdIv0us4AWfIIFfl9pFRDqbIZ
	w//C9kgO72jvfcBtRChl+N/hdTrRtho=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Co6DXJZx;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775734609; a=rsa-sha256;
	cv=none;
	b=rsfspo5XfqIzYUDRJonw+LToFM+lHh+gS/sKebwfXJdJMin+dqppS0z68xnRRogoNd4ypb
	qh6TYIXi0ssXu8/7vwJH2nuwEZUUk5y8WzZEpk3EjPWmD8LCGh3hqt52pFjgE+6pwTuoVZ
	H2KVK7kMFPcsWSu42Md+Uez/TxWaRlk=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 713A6BE7A5;
	Thu, 09 Apr 2026 11:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775734607;
	bh=RbkflGjGu8BF8nS6s790ufgH6Ojdrqp4tFiwDkoaxz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Co6DXJZxLdh7H45ycK5MQG1F61S4xOokD/ug2AtnVTmrVeK0RqaXhRb6jgc5zGppy
	 Jpfz0Q1F30rdiAcF2fG/eVu0ieuEZnjNOxukLHDs4cGwrNK5hbgfGR8s5kihyaCM+o
	 TfQ6CDpoSzNNjSdW0H/+QqpxBnE9EyPgFTYyl5DA=
Date: Thu, 9 Apr 2026 11:36:43 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RESEND PATCH v2 0/8] mm: use spinlock guards for zone lock
Message-ID: <adePNxNF2pOqMYXJ@shell.ilvokhin.com>
References: <cover.1775654118.git.d@ilvokhin.com>
 <adaFaMGbndSSMaZn@tiehlicka>
 <20260408130715.d6772b9675b0182bac9fe427@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408130715.d6772b9675b0182bac9fe427@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1913F1C0005
X-Stat-Signature: 3bdcyw88c9c9wsqcj989yk8c1x46hbps
X-Rspam-User: 
X-HE-Tag: 1775734608-932509
X-HE-Meta: U2FsdGVkX1/u3sSGGJusHBL/XW5994yd9FTdmOF9brimdQUtKQ92/LysIHMfXP9m5SCtIRZEnIi75+W3leELT2KbRDH2yNNOrZltVimII2pnPD0o8ZKdr9gPVUZzx4/43xDEyg00nwdAQIF8PPxwkvuBda2OdhY9B6fgBlymsNhJzVqPlVFruOR25+sZccRMh22T9f6piHnBRrleuOPkCth3SHguBQaK5ygmf4qsH6SLcLxYccg9C3jxUWrYw6Y+WWsYznzq7vihM43UIel30TbKzetTseEIgMoIQJqmrxFDmUxpB701BPEg9SCmPx10uurdg0e8vOyg64sAjXwiCorgYjhp9iQw5fo2unXR6HcoB12UcABhAM16CLDt98tTNKOGOu+JVD/DxB4W7qXpCNKy0D16OY/eM0x9UPNZvss+UwoWLDgKZ3HukIMqCguvtZPN4coqWmAbRADLG9Tgb8jHhNs5LJCS6qB7Ax2vzHgZ5t6SrtBUmhMyzW3SlVxnIWOEmddQvJ8PoYQ05JmqNiza2TUineRd6Auy+R4N9yOZeSmPyLRj+0MNxsIvnBU3EvNUN/mMnBmMHQqVYkO8kY57mord41jNJzAPQC5b3uorh3ZoEObQpK2Q5a2LAcoSAswzdEs5YKWu25JUxn/xMLZ6b3SFmvV/JdWx91oNmszJwac2xqvn4AMGXZk7Ppe3Mbp8+E7+ByFfgdflVrTERohH6Hq6oJgQq3Rt1T4/HiC3RXpGTKyU2MFsiQyhsTRmhjM9el57enn4t83Uhe0YBSg5FvyQr5U9guJKTHnaAum/J+r0ynekhcWtZH/5IiM3Kx8KufLAE9V+kCNz539KF0CHvZ82gtNaOSQHP3CA/3oNhVcAeFIfYULvPXwxITGidQRU7wksBBx5zHx85Y2Zl5wx9DIvAUpePS/AlZMDMVMxJ+5HrtWZalPznPMyZnHtG+jBdssjru0SXZ1dVfb
 w9wY+z/z
 lmE5j5T6n6RM7fJK7Lq9Wp/YGnJazmIkgWZxHXF3gXb32EkNqD8OOa24pLUCBnQP8EBuXP1TMfJzSp4mPE2bLJ48lZQQUnL+sv8kw2knsnGnenHb/UBCq4dk5TyXD8yrByuTix1nSKZWYUL8tnG0qc3ckTBIx+Ahi2WUujW5ksd6/gnbP4rsSgw3NFkynt/8GeV9aDkwI1S8BhOVpXQpXZP/g3bOu9QfrhDzIhkvgww88NcJY853yayLaVjLAV3ZL1zO8zqoWUueGmJFaeakfMdTOXJE8CFdob50Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 01:07:15PM -0700, Andrew Morton wrote:
> On Wed, 8 Apr 2026 18:42:16 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > Dmitry Ilvokhin (8):
> > >   mm: use zone lock guard in reserve_highatomic_pageblock()
> > >   mm: use zone lock guard in unset_migratetype_isolate()
> > >   mm: use zone lock guard in unreserve_highatomic_pageblock()
> > >   mm: use zone lock guard in set_migratetype_isolate()
> > >   mm: use zone lock guard in take_page_off_buddy()
> > >   mm: use zone lock guard in put_page_back_buddy()
> > >   mm: use zone lock guard in free_pcppages_bulk()
> > >   mm: use zone lock guard in __offline_isolated_pages()
> > > 
> > >  mm/page_alloc.c     | 53 ++++++++++++-----------------------
> > >  mm/page_isolation.c | 67 +++++++++++++++++++--------------------------
> > >  2 files changed, 45 insertions(+), 75 deletions(-)
> > 
> > I like the resulting code. For the whole series.
> > Acked-by: Michal Hocko <mhocko@suse.com>
> 
> Thanks.
> 
> As I mentioned previously, the outcome here hinges on how the
> developers who work on this code feel about using guard().  Most of
> them are in hiding at present but that's OK - it's post -rc1 fun.
> 

Thanks, Andrew.

Understood. I'll wait for feedback from more folks. Hopefully they
reappear soon after the -rc1 dust settles.

