Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6DF0C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2726B0096; Tue, 14 Jul 2026 01:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA896B009E; Tue, 14 Jul 2026 01:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA046B00A0; Tue, 14 Jul 2026 01:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35DEB6B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:12:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9C1F16026F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:12:51 +0000 (UTC)
X-FDA: 84986212542.27.8AD7105
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf21.hostedemail.com (Postfix) with ESMTP id DFC2E1C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:12:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784005970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jlGQlluaXUrSTZrKOg+r4D/pydaZrrAAXG/tTp3JdDU=;
	b=HmUrwurU5pU+cO8Q3Tq4pZiQS6VkPfodVu9aaG7pVYM+qhMwgbdIfpi0BKrTESJLim2Q5/
	5EpKGF30zuEaIm6lHM08TFSyPiKXdmeBTz2KH3Sn3tjZ75JWrCSXYBWC2tOv2ZYcku3kju
	9r6L6wgPfUrIkJdT91A7lxL9+zj8Yhc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784005970;
	b=x0PHAVVsdFxicl3kXzNHq363ZOzUPOanAWkNR2WFMTO9DiaUdo1ev3LyvLO6rZ1jopEI0n
	TViPJbLVAypcCTa9cE7BkCsqhdU5Jx7ex4tCR0QoG9GbRFG4yi9cU9vSBqN4cVMXGADEAr
	Gx9tZX96bzZ9LIwSWmVgyF/qKEmLl+k=
Received: by verein.lst.de (Postfix, from userid 2407)
	id F228D68BFE; Tue, 14 Jul 2026 07:12:43 +0200 (CEST)
Date: Tue, 14 Jul 2026 07:12:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev, chrisl@kernel.org,
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org, Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: better block swap batching and a different take on swap_ops v5
Message-ID: <20260714051243.GB31523@lst.de>
References: <20260713093350.2154226-1-hch@lst.de> <20260713131305.3efec91d077d224a3a8d1aad@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713131305.3efec91d077d224a3a8d1aad@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DFC2E1C0004
X-Stat-Signature: s5847u6ays91sahncucxupz6pt1apb84
X-HE-Tag: 1784005969-982504
X-HE-Meta: U2FsdGVkX19yy9dDg6JLsmMntDpAzb6ljopmnn9LiZQOuCQcj6h6rX9qbsKqxRzbs3geroBzE9SJ0HxL8KUqLnkdy1VEda/y/bY1oLNp3N6srzkRu4kxFEWVhUZtywHiB0rJDwC3/oVbnHxzfFg0P3LMT9FGcmCJFjDyhFTplcXnybZQXskn5id2gQmcFlQYjmrJCXRstd5ucqV315A/ZSRJPLgo2et7CnQKjMolT3k1ogVPQm9xSexQkmNdzNSwHhvfsXhVd3vEiQ/vF2l2NcfUub0/YvxoNpHHfxGcNwV1z9pe3deRZXm4QeioX71yYttQweFH0vyMd1QUrXY+hpRdwVtG7nCN7b843O2QZJ+lBqb+7dRnNI7MJR251xK8WleIPhoWKqZuztoFffgTJvZdE7+gccDSUEg8rmR++wQ+/uf/fYQwiDj+9cMAikEJ4qf/NBnWsWEW8jG5MoG43u2uWXl1eWm12vutFM9InA5mIPa8wtlCm9zgqmqVD5Uz+AxAL8y6vmMTnS9TOFOQd2FXDlq/dsTj9JlsRST1KV9t5TognTU1e6ZQNHW89VPu8o50+UP12tLnXY6xz4DOmLqLKvCeQNNB0UDfJTnBY2fVpNi8T8nu0PLthUH5yAluaAGuYamHwHU0bQVg9AdH+XY7+WcnDRFl1WwJoyubpHIFiVjwWE+dB+jMCDTGsuu5WCfc3sXNvwnXrXGfh0Y4RPP6kxMwYi2Z5Ab4KCfyYH4eLpzihPFdtXEeaqlNOvzOl67OG40KNeJCcVilfk1Fy+UsJp01AoIVWGlPL+zEL0Gn8FyeGjvj9VZ0keCdY3tfgM9rLKhgWyg+4JPBXRy5pxWGG+4IFc+0DKv/8JzfIestSPBGcYQNmaa5QSGhBzJYL7d3cBpAP65SfMrzPy3F5uLP1ifmBqTCTWuU3q/bl3z7c5sPeMwEA+4fRsmcqLxzlndi27EK9ddjTLz4v0c
 BoczRopa
 Ixjed7lC33YKpqsfrPG1C5iH6Km40Rc7IqnSMVjrZlgC2T9vIzlc0q1Di/k5Drtd7zK8uKHDwutD+rOnHz7nSM9n7Ikl9kfR3pT24dbUnyokCwVkLCG6HUuLB4FV2t1JG/HlpT11jPkdQu9QhSsutSyRZwRHWIqdS3JajIzxaozE13yY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 01:13:05PM -0700, Andrew Morton wrote:
> On Mon, 13 Jul 2026 11:33:37 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
> > this series makes use of the swap_iocb for block as well so that it
> > doesn't do inefficient single-bio I/O, and then rebases the swap_ops from
> > Baoquan on top of the now very different method structure.
> > 
> > When running doing kernels builds, which is a workload that doesn't
> > really do much THP anonymous memory it still gets 2x clustering for
> > writeout and 1.2x for reading back swap in.  The overall times do
> > not actually change, though.
> 
> Thanks.  Sashiko review might have found a couple of deadly issues in 
> 
> 	drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> 	drivers/gpu/drm/ttm/ttm_backup.c
> 
> so let me add a zillions cc's.

Well, I mentioned this before, as did you.  But it is all existing
issues.  The proper fix would of course be to not give users such
low-level access to shmem writeback..

On the other Sashiko comment: the bi_vcnt doesn't make any sense,
bi_vcnt is only for the submitters convenience.


