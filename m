Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEBABEFB7F6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 04:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EEDE6B008A; Mon, 23 Feb 2026 23:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3999E6B008C; Mon, 23 Feb 2026 23:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5516B0092; Mon, 23 Feb 2026 23:02:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 15D9E6B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:02:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1B3C13ACF5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:02:28 +0000 (UTC)
X-FDA: 84478003176.29.7133AE7
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf17.hostedemail.com (Postfix) with ESMTP id A64BE4000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:02:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771905747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dBYX2a7CrJrjwtfFr/YT1ZORWteDAHcPBF5vxJA9cRA=;
	b=XmrIa+1C+wqscpLlKVjt2ZNBelPb9l6ZFHkqjAkHA2Ei7Wq4S/EYyga8dM9jXgKcKlfzgZ
	BcKy9UrxR/Ay/U/Z99pwA8PGb/hIdVkBYDrMXPRtE7qe1uHodCu7Ys8aUvDxbg3lo3uuk9
	0G5BSbv/+SISHzUoW8axIP0qiE+M7Tw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771905747; a=rsa-sha256;
	cv=none;
	b=3OSeg5/NrXwWaHrzAmJXju9Yyb43r0ckY1L7/MFkndHoAqNTJA7q4hUdCYwjhoN6Ji0HrA
	tOLB+zUAu7c09LqjaN9hu+mrdmm1m5204B0/t/LSKu+uOut8MlOxduidvyl1BLdtK9Cs1J
	tnnqSzdu69w3+4MT4RBDgmM4xceAixI=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 24 Feb 2026 13:02:22 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 24 Feb 2026 13:02:22 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Chris Li <chrisl@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	nphamcs@gmail.com, bhe@redhat.com, taejoon.song@lge.com,
	ryncsn@gmail.com
Subject: Re: [LSF/MM/BPF TOPIC] Flash Friendly Swap
Message-ID: <aZ0izpnK+QMqxYbM@yjaykim-PowerEdge-T330>
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
 <aZiKQwT7KjWDLspH@infradead.org>
 <CACePvbW6uT5OKDg0RWS3ZBGcppBkz+MREDVXdwSat_qM=Nc5CA@mail.gmail.com>
 <aZxUtFaVaJbkAM8Z@infradead.org>
 <CACePvbWkGk5Z+QueOBNCdrr1mzGxQZbRbfeskOrLsmWEvF5ToA@mail.gmail.com>
 <jvbthrkxombekk4bbmdqrwvik2qnd5btafb6q7guimxnioaqom@7kjexmbfuzxx>
 <aZ0L48fzXzC9IOfj@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ0L48fzXzC9IOfj@yjaykim-PowerEdge-T330>
X-Rspam-User: 
X-Rspamd-Queue-Id: A64BE4000A
X-Rspamd-Server: rspam02
X-Stat-Signature: geouii8coid7ywcup7hbzxbfixzsyqiq
X-HE-Tag: 1771905745-307320
X-HE-Meta: U2FsdGVkX1/KFXf6UfxmLTVBVM9CCRFttxc4dHFBNoJmXGzyb+Tz6OI8IbdKfRXARxLYqqKVZ0cBZlpqdpstzMO/4aTAHRVwbpStECho1O2W0MqtmxtwN0pgfuO7QNIW0/+5IBX2+AXr+LKPEY9BJiAf4sFs3Z2Kzgn4jJNkRQm+FqMgOE4ouvvyR7R8jJP7WPnYZsFEWYa47F89ax9dZcSn6guLAZFS6zwCt034ykMjPc1ZJns9ykJVwNLguoxwesfZuMf7jiBXs1yq6BAzQIvEyTbDFlguByayVSSmwX35uuMvnL7Ruy6GG3+/W8AeUkbJVTKSdpIJ4E3BvDAUok7X9yeJO5LfxVNjvd3t+dHbDTnVPM2cumuXCHbXMgr0GyjRkRfewAhCt7Ld9URChGCZpAc+VmRxmE+FfsR/WnBBecMNYDTezCaAoUV/gPGO9k2pMiqQ5UX6Ted7TaPXTOk+ya9xEui1Xm+FYzkRjZo8kojPFhZD4i7+xPKNUKbXr78ryGa9Pwexn30BkJiQ3prrB3y55YStc06+KUOwM9yC4Qx5cZbUCzujQ2BC5zK96mipsAnUprBP1/1IKaAnfkAsYBeA05Zh54NimHjNI4LoUoeJWezKJkRuLe87JRlUtj/voZwTtdQrjqRiAX6K/KYouoRAcX7CldYxNF7BZ/QvMRgjf84zkmJ8POne54zrHSvq4SCzAcsAH8yy7fVK2nEVMe6sv9u6ktA7aTasQZHj7PlNKruVGakjNpoEecSYBItyZbReb2q6wOJGV5X9Qw8Nm380eeiHVRd0hUpg+K0UyLkeV64aleJl2vniCPuE9nYW7S7aTm7EB6pMHVqqWdUjpVKWI2w1ATitkJXu1S3Vrn9awzPln6cIvBDjWfy0k7/AD/UXa+IwUgcLObQPtclWJDPWf/lgUPbF6/qMKA337GFS8G7JQAN+c1q6NVx9oyAkVRlhNQy9RO3R1TY
 3xbMRryo
 Qm9IC2lj5cS/dtRaUI5S8SwJwGSecO7y7ykBQJ3/pYAKroablCqfbTP0230r19HZKnlK6JgrVX3tpmm4r2UUIt9pBQx56h4ezYkwWCc0/E5HaH+3hw2p2/oVmiLDBdLr0CK8nZZyhkTR+BsutEzWjQP50wu5F272NdNYNU9UQSOTieB7lr7eqGWKFLumYVh3ArIBjsnQNqjC6wFtCLSiGheYqa4xaFgetYGEYbwHZs+VBw8D2JrJZAf5e6mHGgYXgyfe+TKvMijfVQKTLTnpYXIEQFk62fD2nVyE+ucbLxJ4ycC5tx12PhUUrdfUtOEDyjHEe6ZGqOy9A5NHWMlo5eHWLUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 11:24:35AM +0900, YoungJun Park wrote:
> On Mon, Feb 23, 2026 at 06:53:12PM +0000, Pedro Falcato wrote:
> > On Mon, Feb 23, 2026 at 10:15:14AM -0800, Chris Li wrote:
> > > On Mon, Feb 23, 2026 at 5:23 AM Christoph Hellwig <hch@infradead.org> wrote:
> > > >
> > > > On Fri, Feb 20, 2026 at 03:47:18PM -0800, Chris Li wrote:
> > > > > Hi Christoph,
> > > > >
> > > > > On Fri, Feb 20, 2026 at 8:22 AM Christoph Hellwig <hch@infradead.org> wrote:
> > > > > >
> > > > > > Honestly, I think always writing sequentially when swapping and
> > > > > > reclaiming in lumps (I'd call them "zones" :)) is probably the best
> > > > > > idea.  Even for the these days unlikely case of swapping to HDD it
> > > > >
> > > > > For the flash device with FTL, the location of the data written is
> > > > > most likely logical anyway.  The flash devices tend to group the new
> > > > > data internally to the same erase block together even when they are
> > > > > discontinuous from the block device point of view.
> > > >
> > > > Yes, but that's not the point..
> > > >
> > > > > It is easy to write
> > > > > out sequentially when the swap device is mostly empty. That is how the
> > > > > cluster allocator does currently any way. However, the tricky part is
> > > > > what when some random 4K blocks get swapped in, that will create holes
> > > > > on both the swap device and internal write out data. Very quickly the
> > > > > free cluster on swap devices will get all used up and that you will
> > > > > not be able to write out sequentially any more. The FTL layer
> > > > > internally wants to GC those holes to create a large empty erase
> > > > > block. I do see where to pick up the next write location can have a
> > > > > huge impact on the flash internal GC behavior and write amplification
> > > > > factor.
> > > >
> > > > And that is the point.  The FTL will always do a bad job with these work
> > > > loads.  You should not do overwrites, and can do much better
> > > 
> > > I am not sure I understand "You should not do overwrites". Can you
> > > help clarify it for me? Let say we always prefer to the write to new
> > > clusters while some swap entries has been free. What happen we run out
> > > of new cluster to write? Wouldn't we be forced to overwrite the
> > > previous free swap location? It seems to me the "overwrite" is
> > > un-avoidable if you keep swapping in and out. That is the part I am
> > > missing.
> > 
> > See log-structured fileystems. I suspect that's close to what we want for flash
> > storage swap.
> > 
> > Also, FWIW: the cloud vendors have fake SSDs that while have negligible seek
> > latency, have extremely low IOPS values (e.g AWS gp2 can do 100 IOPS on its
> > base setting, and scales up to 16K IOPS. gp3 can do 3000 up to 80K on the
> > maximum size). I suspect swapping on these is a huge slog, and we would also
> > like to write out as much sequentially as we can here (though I hope no one
> > is *actually* swapping on these things). Also mechanical drives. Log-structured
> > filesystems were originally invented for these too :)
> 
> +CC Nhat Pham, He Baoquan, Taejoon 
> 
> Hi Pedro,
> 
> The motivation is indeed similar to that of log-structured filesystems, and it
> employs a similar management mechanism.
> 
> That is why I thought a management style similar to filesystems might be
> necessary at the swap layer as well (the swap abstraction layer mentioned in
> the proposal document).
> 
> Previously, the direction for upstreaming our solution was somewhat ambiguous,
> so we have been maintaining it privately for several years.
> 
> However, recently, I would like to discuss how to proceed with upstreaming in
> the context of Baoquan's "swap_ops and pluggable swap backend"
> (https://lore.kernel.org/linux-mm/aZiFvzlBJiYBUDre@MiWiFi-R3L-srv/) and
> Nhat's "Virtual Swap Space"
> (https://lore.kernel.org/linux-mm/20260208215839.87595-1-nphamcs@gmail.com/).
> 
> Best regards
> Youngjun Park

+CC Kairui

Oops, I missed adding the discussion involving Kairui (CC'd). This is also 
a direction currently being discussed:
https://lore.kernel.org/linux-mm/CAMgjq7D6n0H2=di0SrMQbJ48cVeKhGeQMH_mY0y-au4OJbE2GQ@mail.gmail.com/T/#m2feb4489b29075136169ff3efd28dc365062f66a

I hope our proposal can be considered or aligned with these ongoing
discussions.

