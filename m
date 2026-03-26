Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19F210A62CA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372CF6B0005; Thu, 26 Mar 2026 09:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3239D6B008C; Thu, 26 Mar 2026 09:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239846B0092; Thu, 26 Mar 2026 09:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14FA76B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:26:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF76EE1288
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:26:37 +0000 (UTC)
X-FDA: 84588288834.18.A97BE2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0D8AE40012
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:26:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P6kLPKW/";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774531596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvBAgmocKYgbTFYtPW7DCVpDouyPELojROUbp0Wp0T4=;
	b=fWUdCw2bgRtJ1mQc74EUCyTsIXMGSSdFs3VRpfp4lGiJj1s6YDpU50B3HdBGuIELH9w6O4
	cxtmOmNScXL6q22FqgufrNCw0xKNS9MmNhy68n158HA7t74mcDaJIE675KTUaqI9P87jhY
	mVNjsi0MnoyjYEcOkiIDb/yfgcJL0iE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P6kLPKW/";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774531596; a=rsa-sha256;
	cv=none;
	b=n+lMnimuKkz4mkb1OxfW7uDdvy7CVYCWJFYOjLGYO2Ti9rUz1KIbU0h04I2vfQOc4in82t
	NzVDO1Q1a5q0sxPfMx3iBuo3IQad2pBsOphk+mOwoOZ9xvBNg83LO704B9V5IrbsIAQ85T
	qJyJUE6w2/Whgtb2VZuNj/wqH1YytWE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21613600C4;
	Thu, 26 Mar 2026 13:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC849C2BCB1;
	Thu, 26 Mar 2026 13:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774531594;
	bh=+t2roIXPHd/zg2sRt/a9JSIXkg7Ja3ZrOkaN/rOmFxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P6kLPKW/wu7lT6Gl+/BozP2EIuDsxk+6x09dOqsfDuPImN49ON+VXfVbT/qLoiJoF
	 8C7Gs1A6MVWE1yLKvb3fha9zYZyaTWSQ6hnb0YItnIaXsOeiCY2TwRQVWYtQT+caE6
	 HyvNSZpcy1qJMjy2aeGJp+Kj9EM3CPD2CDZGNoiYqxfeuPQdKDJmSOAGve1ld3VZUT
	 AXie0ESVuKCWpzx7GHdSLR/GUIsKzsnf74t7tQQVZ26USbLfzd8/G7PXOY+ej+P2Jm
	 2FZkxXLjUJIE96I8eCQU3WxKCHYwnzRFnDVC29uJo4Br+yfOUT/GtW9b/YHnk0GQ2q
	 ShzPaM+04PIPQ==
Date: Thu, 26 Mar 2026 13:26:26 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <e98ccaa6-52c0-46b8-b089-ac9dc4baa023@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <CAMgjq7A01C+wyHxytZfVFVvaJ+gUNqkKvYN61_Peo911YaBHOw@mail.gmail.com>
 <f617acf0-6bb6-4ea0-85c2-d6f377a2a574@lucifer.local>
 <CAMgjq7BfuYsxhhf-XqKH4B622NGP-9bmriSP2eMiygH9ZJMANw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BfuYsxhhf-XqKH4B622NGP-9bmriSP2eMiygH9ZJMANw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D8AE40012
X-Stat-Signature: inkoi7ff5aaxrysgbn7sqcyxtgqf9rnf
X-Rspam-User: 
X-HE-Tag: 1774531595-651853
X-HE-Meta: U2FsdGVkX19Z1gHwgqwq37+TabZC+t3tHeYP/g0rUCdGXjQ5fiXx29KKq8SdASbMaRiZK+pwwlssCFQtwFBhjcOMxVDYKXBwAyuli1Y3wmzjugFWO/ZlhE5mqRGyTgJQ1w3MmpqGnDHNuP4cwNb5Z0LatKfW8bo9h1p7vrSgVEKmNx98TzKTC37M2uPkb9gEHiGzLtjthv75QcL3/WKOaau5K5TPWdzOCtOo1phMGog8XrHwObplkJaevCUwzD28Cu5Xk/yeCdFHfHE/eqeQxm3sx2z8YCORFcR+OVtZ67vHh5F7yX5nsLUYqm0JgLNSpZ20SrOdLFzTMOy/+pYTJziKkhc5b2iuIRNhBVgyJ/KDBjVwgGLU3wZcKhlVK9qrKi+PgbCqXMJyW+v1X+DHQhUTClsqmnBhmR0hbEyFmnKSm04PMfopn774jxQ1tL47hTVp+M1pBHo05DDFofyW/rvtaSRU9oEbndLJNQ4QU4bbmliCr1+dMqURXGGAJFQzZKiHWmSDd5zEisGnnllYJvy+GmlF7LDVWVD+1Ebohi8wFVGklQUH8+uIFNRSzJykKLjRSybLlX0kLq0V5VOHyCMDtRl53/kbcUdBcZ9imezE6ZyCd0KKxRLbxOOa2L+jWJRYqKS/EscKrQlLxXmVzB5v3QGg5Aud4dI2VFojGhPee7VBhFHvgFWFwyzGdZqdb7/IF+AvC6S6fw7gMvV5PO5vWZtUF5Das+Rnlqn83qlV/SGBTe40RQMn0pWIele7gBmbDN+hNQ6/o7Yh8uG5jRnaeFoSv0x4MwYS0B+Nn4OwWYtK5McW/ZSoQiYYifgeQM0297Fy1iw+s5V2U0Z449a04xRpOpwIPzcNlhIBdpLDK0/XCnYo7pmNU2so5VafRNLgQD9OGDWVma6KI4DaumHvlbkTJkHUY89/I7ZPqHvtkV9I/xUKyBM2qp+2ZilCjlVv9h65l4pLYyCsRCf
 Nh2H5cTf
 Czm7TY8RTcV3xf+iOk0z1w+kbqWUgttXqsUfJnYu5M7OdYk2beRVu9a+q5ioHqvYltnMKMXtMjkQSE5mnI2bgJXziUsjAi++WiWBkXCTajXvYP1Y8d/EwX4K/F0gzdPUwPi+8oYjIBK/Iga9R2mI+mlzbeGNi+jfuFmL3kcYG5w85uP/7zS/xHdPYOl+9UtXCLr7p46z1gz1ymS9dgxvxB2iFSylsgqrfB180spHViXDkOK39X26NAZrrqdDhiOcAYMZZVakSBDYW01f1I9aKHF9iHqhvuZTvzvw8NXi17HxbAVrP/E/mLaJEcUnUHOlIdWk+Z3p36d23Cgcf5fyFEtiun+tTqT+NnX2wTjpC1HaEf45Wpw60FrWN3WYnvGamOJdf8MwRkyOwWNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:17:17PM +0800, Kairui Song wrote:
> On Thu, Mar 26, 2026 at 8:31 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > +cc Gregory
> >
> > On Thu, Mar 26, 2026 at 08:06:13PM +0800, Kairui Song wrote:
> > > On Thu, Mar 26, 2026 at 10:05 AM Andrew Morton
> > > <akpm@linux-foundation.org> wrote:
> > > >
> > > > On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > > We should unify both algorithms into a single code path.
> > > >
> > > > I'm here to ask the questions which others fear will sound dumb.
> > > >
> > > > Is it indeed the plan to maintain both implementations?  I thought the
> > > > long-term ambition was to knock MGLRU into shape and to drop the legacy LRU?
> > >
> > > I personally also agree on that, so far I'm not aware of any major
> > > issues with MGLRU except some corner cases that are not hard to fix.
> > > Once these are done, I don't see the need for more complexity.
> >
> > Well... :)
> >
> > What about the issues Gregory raised here?
> >
> > https://lore.kernel.org/linux-mm/aaXM7xNSJaJBsety@gourry-fedora-PF4VCD3F/
>
> Hi,
>
> Thanks for linking Gregory's mail.
>
> I'm not quite sure I fully get what the concern is, I'll try to
> address the main points I see. Regarding the bi-modal distributions,
> it's very workload-dependent, and the reclamation still performs well
> with that distributions. So I think that's not really a problem?
>
> The heuristics are a bit confusing and intertwined (gen number as
> flags for atomic update and avoid LRU lock, tight coupling with
> generational aging, etc.), decoupling them cleanly without hurting
> performance is tricky, and the current approach has worked
> dramatically well. Cleanup the code structure might be helpful?
>
> Many distros have been running MGLRU by default for years now and the
> feedback (plus our own production experience) has been very positive.
> There are indeed some known rough edges, under-protected file cache,
> ineffective swappiness, flag usage, etc. some of which I listed here
> [1]. I believe they're all fixable, and once addressed MGLRU should be
> a solid base.
>
> Right, I realized after re-reading that some of these really are not
> really easy to fix or improve... sorry for my earlier reply, guess I'm
> too sleepy today and not thinking clearly :P, my apologies.
>
> [1] https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com/

Thanks, well that's good to hear.

I broadly agree with Shakeel's proposals for the incremental improvement of
the LRU code, and I think that and fixing MAINTAINERS (*ahem*) will
seriously help move us forwards with this.

I wonder also if we shouldn't have a document on this somewhere in the
kernel to lay out the differences, improvements, how the gen numbers work
etc.?

Cheers, Lorenzo

