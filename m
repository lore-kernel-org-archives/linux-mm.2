Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F8CF483C8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3816B0005; Mon, 23 Mar 2026 13:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4856B0088; Mon, 23 Mar 2026 13:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA746B008A; Mon, 23 Mar 2026 13:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0A106B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:02:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9EBE6140CA0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:02:52 +0000 (UTC)
X-FDA: 84577947384.13.429E3DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B2611C000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:02:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o73d2bA0;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774285370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZhnVjZ97khcZS0Gp/GbjbsEfzokXb/2ZQ2GVaQV1hU=;
	b=aNq33N4jZxi1V5PnvJDSF6lXGcY7z04rVZZnmytZfxiIj+Fe0Gk9sujkS1wmP0MpuEBoWa
	QaL2qb693BM3+cAL+MyBltW7onF7rpyAkbg0VRUMsEOg0Bu1TSh7C7Pg5Of/mgxeQuv4A3
	SXUJ7obECfoyOIOWrNxokhIzS33rfpk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o73d2bA0;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774285370; a=rsa-sha256;
	cv=none;
	b=7qHSGeop0P0DSHmFFAFaYXQJZv5nsazE0cFO7SLlPOGVtThwoxKz9kbC/Lj640PPqL6h0v
	ocWeVLrwU1pKoiQQvD0/lL24a6c7u39fuzjDMf2lEVXpYFkLyMe5Tb8euGWzH/f+5nJdTj
	SEDYFhAPnJOTYaNcIxdQB4BwdjMRjks=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BEC043EF4;
	Mon, 23 Mar 2026 17:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5289C4CEF7;
	Mon, 23 Mar 2026 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774285369;
	bh=tZhnVjZ97khcZS0Gp/GbjbsEfzokXb/2ZQ2GVaQV1hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o73d2bA0Q1qyv2dHc8YTTVnFiWUKJP6wo3soKs2CMs51g1mw6mT9KWp3CubbmXqKV
	 7jDJnkWgW2eHCIecUVldJLpSpOitXyyIfVzVLaylvo8gfuhgJQn9mRNig6hNX/QyG+
	 /QZwbTuYFYIrv7KTbuBzYlYELHqpuq2TL9ggRByBMyd7lUC0hHXCt+hLSitYEO7U+3
	 t2wQtTbNsYB4HF7njtrzdZ4H7NVR+2ycXxVIhA4lpztLi/09CnEV0JGSQjyEWcnF1r
	 hbyljf7qNB4lCkSM0Md5qcGm3GA3yI5bNLTjAF8PHDxJeVa+obGmk5Awlekh8lvKTN
	 iCvk4DfUpQ8Xg==
Date: Mon, 23 Mar 2026 17:02:44 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, yuzhao@google.com, 
	shakeel.butt@linux.dev, willy@infradead.org, Liam.Howlett@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning
 address space
Message-ID: <dd9f09dc-d1c6-4f5d-9e58-d5ca95ff434f@lucifer.local>
References: <20260322070843.941997-1-surenb@google.com>
 <65cb38ee-2815-4b11-929d-3fc1528cc620@lucifer.local>
 <CAJuCfpEm4u3viNt3hG__RbgCJBxFQpFvjx2cAE-fg3DGPfja0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEm4u3viNt3hG__RbgCJBxFQpFvjx2cAE-fg3DGPfja0g@mail.gmail.com>
X-Rspamd-Queue-Id: B2611C000E
X-Stat-Signature: xn15cdai8awo8hm7ro4mba41ytqohfut
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774285370-746071
X-HE-Meta: U2FsdGVkX1/1t6hBGbG+jhWFqHdqtrVPULtBoza2d9xyIuiikK+v4AVnhX5gylCWh/Uo3NyP500sVtFhH3rFDRCvJAdukDC0NbYc7VXgZ9zR3zdG9aBC9tonLPYTJr8V1I+fztaSazRbcOJPoE09cMPgMr+Vf8wlhhOlysBEDYWvaSWuWCmwrvnlSDB2P96aFp0ffs2ox6ciAeJuN9NPQdk45asYvQ+eSIajqmwAN7m6qwba+ABdE4UpYMJBw1Mk2/DMLzaoNa/vnHxGYgObmuinKVBbijvP1UymcHV1nw+5meDUmU8wv20EhaOL2ibfZymUNg9UwKacBWx0cgT4dag6pgW2/MBd8nETmwwq3BTi2qdZcK8KtblqpmuFLJwW3vRfNXvWMCD5397Qa20omqAR2Yt6GzWNZ3LjIghE81Ct0IKfD11TYgp/+nUvcIMUqlxulzrfj2fbeFI/MnEtLgclynqym54I1Zvf8kbkXokeV541xvD/+yle/blsBpjFtLqJvhaMb0g3Vh1+mELE50fRP/JrGco3gTZJInKkSOjZcJsbitbVupBdOF/iAolRV7XViIH2xzrp7L7B6rX2HKOOe+RrT8glL2xmX49VYqwGdodLu0ECHVR8BdTThrsDLZtdwgjEWb8vxZLNr1Xwci+/x3QhDI38m7IF6iKoZ9NZPmv86k4sHXPVtwuVFH8cDypHR5stB262tJAaiWBtXEqFr4PoIfZ6H+/x8+8VAL/xegRrJzJgWb1sZlSlWVHYcfbBGLDzencC2TRys7kIhEEdNG5cyCLa+eRf95XFhriUizY+r4znC48yKJTb1iihAeJobhlVZBC0MdJ4MoEtix/x+USd/vlavV+SD56cnWFvBoehN3MXcu8gbmL4nh46mOhjTOJtn9KeHBHwckQu2PM6OSbUhFaZ3ql+qvSUltZNuPEzPxvwL5LcCAgvoo2Bl3w0UZRzJ4S87arg5wz
 yqkzdzWf
 QBHYS0mgoe7Gvm2FUCJmdIsOsZwezEWlBfRSfe8nSjRNrheEt4eFB+s5Mk/6whvxcl2vM9PCiAEg3Q6GwULfxdJhzMPpRW1QwgGXj9UiZtvZspY7mosekwrArl3A0TzyJHici/4XT/Vult3E6Q+irQ9KGwohPdrGiumml1LyoROFS5S4nZYd9lZV67XkIYoCDSSzM7STDmTNPxl9+LsMMQxJ4lvkfz7UQya7e/zn09atHNRDEOkuPO6wddnQ3U18brIYlO+M6W4Dqw0pMGJpy1YsVlcoX2TLMdPpb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 09:26:02AM -0700, Suren Baghdasaryan wrote:
> On Mon, Mar 23, 2026 at 6:43 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > On Sun, Mar 22, 2026 at 12:08:43AM -0700, Suren Baghdasaryan wrote:
> > > When shrinking lruvec, MGLRU pins address space before walking it.
> > > This is excessive since all it needs for walking the page range is
> > > a stable mm_struct to be able to take and release mmap_read_lock and
> > > a stable mm->mm_mt tree to walk. This address space pinning results
> > > in delays when releasing the memory of a dying process. This also
> > > prevents mm reapers (both in-kernel oom-reaper and userspace
> > > process_mrelease()) from doing their job during MGLRU scan because
> > > they check task_will_free_mem() which will yield negative result due
> > > to the elevated mm->mm_users.
> > >
> > > Replace unnecessary address space pinning with mm_struct pinning by
> > > replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
> > > within mm_struct itself, therefore it won't be freed as long as
> > > mm_struct is stable and it won't change during the walk because
> > > mmap_read_lock is being held.
> > >
> > > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Oh and sorry, missed this - do we need a 'Fixed' for something that's just a
> > perf improvement?
> >
> > This doesn't seem buggy?
>
> Well, if we are pinning something we should not is that a bug? I
> didn't CC stable, so I don't expect it to be backported (though if
> it's accepted, we will backport it in Android as it causes real
> problems with reclaim), however if someone is looking for MGLRU fixes
> I would like this patch to be discoverable. If you feel strongly about
> it, I'll remove the tag.

I don't feel that strongly about it :>)

>
> Thanks for the review!

No problem! Working through your vma killable series atm also :)

>
> >
> > Thanks, Lorenzo

Cheers, Lorenzo

