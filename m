Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A42DCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2548E000D; Tue, 16 Sep 2025 13:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72D18E0001; Tue, 16 Sep 2025 13:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61A88E000D; Tue, 16 Sep 2025 13:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF0408E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:10:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 888A5B7A41
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:10:49 +0000 (UTC)
X-FDA: 83895753018.05.41CA923
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6062F160007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:10:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=HhqBEFP6;
	spf=pass (imf08.hostedemail.com: domain of "prvs=34776310f=ajgja@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=34776310f=ajgja@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758042647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yj/co0t5Iw8d47vXLDniXY4H2qDpIH8uba9JHqJdO8s=;
	b=cPSn+TcZCzM70wIVrrV/E+e5tKC5F7RRxXsKQyO2XEvodCowTvozQS4TFAlB2m2MoIBbPY
	W2VXqTssutWt4vTpgn3xzWEAZ/fatDhsybJb3WBUSg0mzaxCGG7H69iUmCsH8tnROrNuT3
	HIx8R5SnHfJ17P9rhF3mZfwC6B3ajFo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=HhqBEFP6;
	spf=pass (imf08.hostedemail.com: domain of "prvs=34776310f=ajgja@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=34776310f=ajgja@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758042647; a=rsa-sha256;
	cv=none;
	b=CDEbmLN5F6W7TO/lxX+mhXghBE6mk6KyM6BSq8d7K693pxAAp4W+FnqIFH67JcJKZsUBJK
	a+9IjEutgqzeamhQ0alr0HvRag4PjN/PvQ2pACAWhxuQsZHGvdldxkcbhOdwOPvvFVsH/l
	gzPT52WmzP/D2tigbtPxQYQ2l9txHD0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758042647; x=1789578647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yj/co0t5Iw8d47vXLDniXY4H2qDpIH8uba9JHqJdO8s=;
  b=HhqBEFP6bgsPv85UWEZkX2Rw5SaZB6pXxbzeVwg/nB1ejSOB7S00wRu8
   D6BROG+4aM0yjaF7MNU+UuAgmuseejEmuCQ+SO4NMpSJ72qokE2GRkC20
   7CGsi+kY+PB8bSPP6t5KLb/9QuMOu7qgDvLQtz//1/C1wPoZhM8QG1lAA
   fAExiiZupRfKAFKJKOjqn3FPAy3POE95WvyP3/bQM1rjInQlXJHLmuqUw
   M91Y3Eb3Aj0eDDqOd9SO+Xu/f2Wxo6GLAJg3qtVvtgCYfO2qVN/5lvI0G
   t9o7NkoszgCVMCbNABFV3qV3Ccf/Zz4oneiSlEM42H+HXmLP79w16TOJD
   w==;
X-CSE-ConnectionGUID: r2MH0a+nShCa9LtTSfPqNg==
X-CSE-MsgGUID: KgO2vHhiQHyJRTkCEVp8IQ==
X-IronPort-AV: E=Sophos;i="6.18,269,1751241600"; 
   d="scan'208";a="3085197"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 17:10:46 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.7.35:56726]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.219:2525] with esmtp (Farcaster)
 id a8e25940-f42e-4026-bea0-0929d2af846d; Tue, 16 Sep 2025 17:10:46 +0000 (UTC)
X-Farcaster-Flow-ID: a8e25940-f42e-4026-bea0-0929d2af846d
Received: from EX19D032UWA001.ant.amazon.com (10.13.139.62) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 16 Sep 2025 17:10:45 +0000
Received: from dev-dsk-ajgja-2a-6a9b5603.us-west-2.amazon.com (172.22.68.79)
 by EX19D032UWA001.ant.amazon.com (10.13.139.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 16 Sep 2025 17:10:45 +0000
From: Andrew Guerrero <ajgja@amazon.com>
To: <gregkh@linuxfoundation.org>
CC: <ajgja@amazon.com>, <akpm@linux-foundation.org>,
	<cgroups@vger.kernel.org>, <gunnarku@amazon.com>, <guro@fb.com>,
	<hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mhocko@kernel.org>, <muchun.song@linux.dev>, <roman.gushchin@linux.dev>,
	<shakeel.butt@linux.dev>, <stable@vger.kernel.org>, <vdavydov.dev@gmail.com>
Subject: Re: [PATCH] mm: memcontrol: fix memcg accounting during cpu hotplug
Date: Tue, 16 Sep 2025 17:10:40 +0000
Message-ID: <20250916171040.12436-1-ajgja@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2025091216-purveyor-prior-2a81@gregkh>
References: <2025091216-purveyor-prior-2a81@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.22.68.79]
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D032UWA001.ant.amazon.com (10.13.139.62)
X-Rspamd-Queue-Id: 6062F160007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ewyzmsfhrqjoj7ysmmpoduc8xzq67fu7
X-HE-Tag: 1758042647-216007
X-HE-Meta: U2FsdGVkX1/8ZIZX7Wcs+xW0KJKnOa3FiJGqRap9LJEEHjmzMrw+51I4grHiIrxU0TVTbA9tLGiSrTVXJ/4jiXihQixOIhPYuFXwTeqOTEJqboLw9arXILRPbykZrddIOH1vHHmmfm30hFt61/u5Um2NBj1Zj37rrlpLH+9AfpVIbtaYQ19HlsLhr1qbvZsmNRYHbzCdd0GTjIEJReu68qgmas2WgfDTjUoH9nyvQrpQ12qr8rt+pZESsG6pRhj5hzXTULkJ7VBJWLNMbM2IQ7Gh9Z4e+82cXI8ZryMGDqnMdDLgA/j/BJ3r3IfKfrUNE5DJIugp90WI7mCJcsmpmYq27ImpfkqWbLiytkIURyR6uQacD9VAmGo2XrihtTVsUTiw7lTfKwSRKEdLr1qnpQlrHGeX8tdLmFEPqHCC1gVDglem7eaOeF88O1U1VQW2x/zF8oj66NOv3WlMmbcDH3zIM8ItIK4/1Nw+dUl3Z2f2Dl7ssJR/evqhg0yU0mMctoUJ2FqLSjIcQz4vgiRtOTS5zET3If3Ze/wVRw9Q+Q+dcBgXWcXXDK2ROFE6ahx/yyZra9trXug2D0aRgodCdQ/pq843qDqUGHUCi5TO19MyfP/ox9UALC0p25uZKmJKpMxe5GcN/tH3GdwFsLpex2LDSaTAMtYB9l1dJ3e5+t1Zy1iRcplw3OF5N72X7TlsTFxZiHYZjiPNQJzHH2V34e9xysFg1SwOfSE/AANqFj9opSuGYC/bR2RqA4+vWdzx1pYN42hVKwKPpkF2WmNr6JLBr9KibajlK5BLiToKkFouBTw/g0VOlexMqQXocnKNhI7cXR38wVwR6cQfyjR2vRnRKv0eoA2/Z4O5/78La0zGRDf3yju/LRQOvBv8WuB+HnTBq5GEtu1gm6ueYwBExq/3l5Wa0C42jRoase9yxq792aNt1HMRssRKW2Vakza5PuzBV5mIP0IdY1kBow1
 zzjq1zRu
 rct/y7khmdWm6lGVkRNYUcWl9wX8Iw3i8XD4Fk+4Uz6x3D/JVwt0/EmGhivdWmdenCTu/uuZdCdeUe+Sy5zsf6fHhtIfsK0goRTgMmYWNalJBS2AiBvY4/Sa1FAp9l1jlxBQ0qpNjasHQBPo8AoUTH2A339qGXeRv+3iBK5xx8aHEIfiireCruUD1/6Cvrx767C3GdBPbSdkVDs7liz02zeurTr3eNT8wgF6NMq90QJgfRtQDl+65Y1EqJLiH1Ef6O2TbM41F/0XKozRx4djr2OQ+irG6qsxW80HU4uXZSfJpwLN0HnrzBiYq4HBv+zLOaa3rfaG8uv9s0VX4+hejR9BaNk4qIbJmJ9Y5uHcJU+2XKqj1mxdA7XqM625F1Nww4AxQPltxGg63rGUiwreMr6FqBZlj9olAJikAdMAKCOEJe3nxtrtGtcywDtahsYKgZ0lOvbGNAcgdX88iO3p9VEpIPgrT/4cdf63GseYH6ynJLDa+89ZJuw2UapZFhLsmudkR35ucn8nrkUy4Nb/v5AI03oJcenJcEUqo7muxDzP9eHjVu72SrrWDACBgmeLelhSGzibtcHFFmPMjeIapMsSpJVa7nvLmPn2Nr6FPVR1b6CQhxuQGnGySM1zKwjzOHQvs2vfZeWu61A7ltp1gAWo6WKnT9PeLVKWo4wk+motVA5j1PBM//jstkktm1UFA9ZIdxbkrhmUT6CnLSi6d85gEG+Ko6VyuONY9sHvy1pYjeQ7GeO5ho7+lu9YZCyGwQwlxG5RulyVnWPZxgRsB7vSte21pzKTsLXT4zgYMcvEosxFHqbVnV3o+l8e9oIIRolej
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-12 12:45 UTC, Greg KH wrote:
> On Mon, Sep 08, 2025 at 09:09:00PM +0000, Andrew Guerrero wrote:
> > On 2025-09-07 13:10 UTC, Greg KH wrote:
> > > On Sat, Sep 06, 2025 at 03:21:08AM +0000, Andrew Guerrero wrote:
> > > > This patch is intended for the 5.10 longterm release branch. It will not apply
> > > > cleanly to mainline and is inadvertantly fixed by a larger series of changes in 
> > > > later release branches:
> > > > a3d4c05a4474 ("mm: memcontrol: fix cpuhotplug statistics flushing").
> > > 
> > > Why can't we take those instead?
> > > 
> > > > In 5.15, the counter flushing code is completely removed. This may be another
> > > > viable option here too, though it's a larger change.
> > > 
> > > If it's not needed anymore, why not just remove it with the upstream
> > > commits as well?
> > 
> > Yeah, my understanding is the typical flow is to pull commits from upstream into
> > stable branches. However, I'm not confident I know the the answer to "which
> > upstream commits?" To get started,
> > 
> > `git log -L :memcg_hotplug_cpu_dead:mm/memcontrol.c linux-5.10.y..linux-5.15.y`
> > 
> > tells me that the upstream changes to pull are:
> > 
> > - https://lore.kernel.org/all/20210209163304.77088-1-hannes@cmpxchg.org/T/#u
> > - https://lore.kernel.org/all/20210716212137.1391164-1-shakeelb@google.com/T/#u
> > 
> > However, these are substantial features that "fix" the issue indirectly by
> > transitioning the memcg accounting system over to rstats. I can pick these 10
> > upstream commits, but I'm worried I may overlook some additional patches from
> > 5.15.y that need to go along with them. I may need some guidance if we go this
> > route.
> 
> Testing is key :)
> 
> > Another reasonable option is to take neither route. We can maintain this patch
> > internally and then drop it once we upgrade to a new kernel version.
> 
> Perhaps just do that for now if you all are hitting this issue?  It
> seems to be the only report I've seen so far.

We are hitting this issue only in a stress test, and I think we got lucky with
experiencing it, so I wouldn't be too surprised if this is the first and only
report.

Thanks for taking a look!

Andrew

