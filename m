Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8479FCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E7E8E0008; Tue,  9 Sep 2025 16:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5C28E0001; Tue,  9 Sep 2025 16:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D330D8E0008; Tue,  9 Sep 2025 16:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2CD68E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:08:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65FF11A05A7
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:08:59 +0000 (UTC)
X-FDA: 83870800398.13.F7FAABA
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id A5F96140005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:08:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JFPGY/Pf";
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onphwuquionzzJcm9VbxKLWllVFJmEFE04yOUJ+NAjE=;
	b=XyzGxxffntKjV1a90/TnAo4CKmAfWvOg4kXyyGKFpRoQY2F02M2iD7DDxt0k7+kfcSEH9T
	2EKACAhnrWFn+eJzZMAx+I+fw/nxqY+PVW1vAJFwWcLhDxjagKJprmiUBH0CmJqutG6MSq
	3X2i8SAmUWtQNnIURbgvO9kowIDpF8g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448537; a=rsa-sha256;
	cv=none;
	b=4ReGQ+xmkIiyNhkgv8BKcRpwjBz+/bQ1x7sPzF/rD2+B5ipnX9VQmWZ1zv2gEK4Xy5Ejvt
	pbRylz40RaZTQb2r1ueGUMlTdapNuVGeYFr6lKJUVUhPGeY5dMfpT7+1Aw3d3+ZnEITh/K
	hVVLxaFJPovElR1tRo21eFGHjILfrs4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JFPGY/Pf";
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 9 Sep 2025 20:08:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757448536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=onphwuquionzzJcm9VbxKLWllVFJmEFE04yOUJ+NAjE=;
	b=JFPGY/PfIAFsR12C4a6aZ4MYme3pv5mVUxvMoVTXTJhn28IOFKPF5bST4EpX5+v8Bg3pi7
	x6EAH+QoZgli+A00jukw4toi7mtpIFyfQbC3acrU+/P97joe/gtoGvk8x2JFZpo48n86eM
	pvqV5S12DrWp6KpoM8Gn0NrRVPhPkTY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: zpdesc: minor naming and comment corrections
Message-ID: <3hd64ocpeiw7q7eb2nvb4bofhr6pwerqesnya6mceua4nmux2o@cxnmm6avhxom>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-4-hannes@cmpxchg.org>
 <mgt4ejjyz64ehnyskv24nzjllxxie4jvxb6i2dzlq43yev5dtu@sfltngevykts>
 <20250909151113.GD1474@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909151113.GD1474@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A5F96140005
X-Stat-Signature: 11kgi4adun3ui3mgaeuw8ez535ebr3wt
X-Rspam-User: 
X-HE-Tag: 1757448537-101261
X-HE-Meta: U2FsdGVkX19BT5wEEAZuD/JI+iqK1kky5ntP3QUqI5RG0sFt2jSFFnRU/2UfmPR5D42Su5S6DnooVwj+tGNPc2HUPlH3HFPgIJYiiZjtuOS5LqlPDd3V8aP8En68xQ9C9Q5f4huWs+Dj30hrleXhBEJ1p+t2rzriEB6Y2MuYbHcvAliTcrsmuaG6JgTewlAGa+69vLlkGyRlbSclONGJjdmyqN6m/jHcP93P0L9epIxSUxaUQJ+4TzgP4zam1La6hUVs1ZA+CHXwDeVFxZOYPINp90nRXe7lD+t5tVRJbV0+rKyos/gKA+OOzrlb8PYNS7pgM0JDOFvdQ/AD8ViOV2sZMc3lWwSsYFmGSiPfPj+/a5fSAnD/ZM0ZpOixGlx9HMEGmLljVc0M+3WrT55n3p2IfRe7TgAV0eNC6MufcngHb6eNzbyGI69l357W4/B/gN4whPOxn/w134jmr8qbsaeFKki6Wdn095WQvOp0H89+joyg3PDjA9wXCvxGWKa8sLTM7LG8hD1AvOMU+dAR1j1qkYQnt49H1j0swWQcBrcahjqp+QcrAtLGsBV/6IkiygxfEXzhAJhUxN1Nitvn6kLhvpIqkYS7a4gxEsDTTwJFP0fgPWUPgQm3t1Q++zX5J5b0bT88yqf+JgoSZ90bdRz+KRy/dxfkVx5GQHZXWfc32KTjU5sFngvIVfY19s1Kqy13fbB1mSkX0jPgoj5OQJNOH+JrkdL1m1rEg5l2A3EG33TSAQaXpjvajUYMXEa9/X79PkYgjvOI/gIplSJMs70l7AiUQw7yP0Jc5PRmkwRHzuHZG+4sEknpfy5Nvdey33iXqLIqvfQcgl9Bjp6GrKnU+6bLBTIrl+MncDH3rEC7s+B2bpp+NxLbi+9VAa5YiWyg63IDdw0u63AqMPqIPORGEPbdHtWDK0DvLDCv6U9qDetfxp28lYjERgr2mYKAfMDxC1K7CqRDSI4mTTj
 +uyDuHS8
 HV9TKWimBNi+wzOZBidYgJpas702iRmxg7PfPtH5Xs4/Ew1Lh3Qv+Jst2M8rBB4KgdrS7gGKkVLQvZqqU02Mcv6I5pgmOujLkyxnY//4tHbSg8AxPDRu0qmDJ5D2RZJzfPPyEzLoptkqZyiEkISPiJN6OddegrhfnicoG5apCf8X5BHIGu0QZ2vVsKPdVZaBBtMxjK2AbyLBKpOFvufBZkeLljqVSJhzcoQSRa29BSkgkd1tQFEJfQxReEj/lrhM/2YX5k4VDJcq6vqg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:11:13PM +0100, Johannes Weiner wrote:
> On Fri, Sep 05, 2025 at 07:05:22PM +0000, Yosry Ahmed wrote:
> > On Fri, Aug 29, 2025 at 05:15:28PM +0100, Johannes Weiner wrote:
> > > zpdesc is the page descriptor used by the zsmalloc backend allocator,
> > > which in turn is used by zswap and zram. The zpool layer is gone.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > ---
> > 
> > Why not rename zpdesc to zsdesc or zdesc while we're at it? It's a lot
> > of noise but it's just this file and zsmalloc.c IIUC. Up to you.
> 
> I'm kind of fine with zpdesc and not sure the other names are this
> much better to warrant the churn. So if you don't mind, I'd just leave
> it alone for now.

I undestand there's churn involved, I am fine either way.

> 
> > If it's just the comment changes I would squash it into the second
> > patch, but not a big deal. Either way:
> > 
> > Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> Thanks for your review!

