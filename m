Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB273C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 06:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915746B0088; Wed, 29 Jul 2026 02:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC886B008A; Wed, 29 Jul 2026 02:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809EF6B008C; Wed, 29 Jul 2026 02:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0063F6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:27:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83BC21405E5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:27:41 +0000 (UTC)
X-FDA: 85040833122.09.E120DF5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id CCB68C0003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:27:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZsZY7cG7;
	spf=none (imf28.hostedemail.com: domain of BATV+791f8870ad8e349a4af3+8375+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+791f8870ad8e349a4af3+8375+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785306459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=we2zBkBV1sMyyTnYWgEW4xW+qGlKxs2hSnPL75Esv90=;
	b=h8MPgCHAVSwoaj0OLH4TxhdnDMj7x7mvi9csFmtD7DOVglcMmwdnzrUs/PFvFdTnNlAMUo
	H8wgu8okUJM5GN9CH4PC2GcMCOgo52lsg36fT/3uM4oo7SHFjUzKwO6/WyAgKI5f5pvVkp
	86kqwbsUj+2sSAa0lot8jO9YXed5R+g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZsZY7cG7;
	spf=none (imf28.hostedemail.com: domain of BATV+791f8870ad8e349a4af3+8375+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+791f8870ad8e349a4af3+8375+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785306459;
	b=o1q1vV1uUZidHJbtgIIBtI8VyL30N51Eyzf9aZqVMYhYBJKGrBjCyeD3SCDz4rB6oCiDOc
	KdJ4ud9yUoRg10uRaeXGSVLPXFiEUKwtA+Wt1/j3OSPOAcyLomL/jVwWoAYqh/Wt2aGdcM
	1SQhCpTn/uUhk73ISDxFeD65v7Tj4zk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=we2zBkBV1sMyyTnYWgEW4xW+qGlKxs2hSnPL75Esv90=; b=ZsZY7cG7TISOF00itS0tsBVn6C
	SQ8jwg/oOzk58gKTWmUjQUCEprRhZH/PSG8CLrP8q70nJNdpgAIlHaA/Swjx0iDA4+MWCjB8GWqTX
	NdrYTlC5pq7NTdtYOeVqKJOFb1+ui73UKxxIJ/APW0rmaoDjS6f1D9hQWArr+u5QRwVGumyHuMtMo
	6J6u2NJn5Oy9Q0JFGQT/B87DyIEfVfMUaqy9Hto5YfD2jpQ4fzBRY8sYGN/rpep2jU2xCGO/ijQ0y
	4krBdt4IAc1g6eVZZyV20pxoXYs317s25Hd49ZKGzs2OC/ylbXuZP91UYFkb6/36zpD7+7dAanzkS
	g3fXKAAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woxlM-000000071M0-1A4l;
	Wed, 29 Jul 2026 06:27:32 +0000
Date: Tue, 28 Jul 2026 23:27:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <ammdVAKErVaSboKA@infradead.org>
References: <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
 <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
 <amgrwn0yQoFvJP4u@infradead.org>
 <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CCB68C0003
X-Stat-Signature: 1n9tjsndezagtn5hadd8m1bwpprj4ucw
X-HE-Tag: 1785306458-252016
X-HE-Meta: U2FsdGVkX1+O2sqJD/bZrALVruitZ9tJEBdJ+SKmgq+HQo6HTCXYoF65FcozQrTFcfS+qY/hIM4eODEuyYsoC7f1Uq0f67tgTBi3Qia08aMgA+dy7S2qwd/ZVpFaoQBQKu1PvqDFHVjn2DtBP4RnBqgMiR3kKiqkskeGHeuSRN8DMWjCTE7109Z9gPXUN5ibInFoH/lt92itbntiZ6EKzJUSJSTqnH/QeltTDde+ko0tukp63gor8y+VMgVPHBOQOt6UtpKSUv+/Gis+yXe+oGcwFj/OW1ruuWVFH1z7UM7CDUfKPq9Q9pQN1kgLzQwgtG5feL9drb+HLF+07KMeYBvNvgJq8KtiP1cJEVpKT4rDcNmCuMnZKjr8CodfqsvrpPMHJPJ1r8UO5cS3AC/02YaQaYyz8K8AniBVeN3HUjHYn6dOE9b/fIg2O55yu8La0TWpLEq+MQPsJUPZBKFDZImd3qZlSc9mKZuKYpch27TZLXtM125Z+GWoM2B8e5p6uo9mjwk+yMprY2tWapyI5WeQOILBSl2sLb1iy7tkQPWAWlHlVPaymhEH1+HaywO4voAQP6Z1/CHhRJQi+nQvgIJQEhOtU+I7jFddgugNcqYysPYyiLBSrBsRKiqtKx5Z1CAcaJZdERATl704jG2v7/ixeCHoggy7dfeID2LbabKf3j7m+/L82uiebjm5JVt7exxMw3myoDE120xU1AmiQxYZmNQY5VY6VOLK/CEUCZlucMeAEowvN+ONg9nw2BT0P+hxyrYTFKrPWZiwj30ly3Vj86I1VP/QcH9evjhI9Kz6AtFdBYqo17HTyIktH1Ujdh5AM70y8dYagxYaQJSNDuPrSnoK/i3FvVH14TRp/54IIPiYsPhbzWVuz/uWMwvlCsxeemXVUhZZdPtPPzwM/CC77nlh6Y6FJLEcKa+gcJkWhYVpLVmw3CNXmWS4XmoqMscg1IeZ2x/bplVA0GE
 cfj+fG2F
 ZVgho0w3X3BTKrTYV+B4B15mKKp3GiXJUBefUM+IBF19CpZuvzEOzcWuDJN8JQETKcc5ZLFlqfHJnBmMxmuM1VisupVCmlJRWR529+Y/zH8ni3a4eu+OyHtoVC2UUpyCuuEq7YOYRVHzkfh9F+k1YZ+dnW1N8RvVqKyuJZcV0Myh7NSghE0yFZOOMnEudE3U5tKxuRTqYKgi8Af+3++KP0kGbkTKzNHIrJsW8o8ocImJPD82Y0vTRaLKaLVvhs4eautS4cbERPbOf45Css9EuzndpvFWSHSepwZv5x3JVj/1BFW9dfVhd+FTOemwwHI3oqcabzFJbF+0IZa06SjSFMDisOyuvPcDWLOMs8GZeXcmTHJ8wQIanUFr/yTA2ljn5JLkQP7AxFrJGUFx5HuTWGzL5wAaqatXQ9KBI2pNk2IgY5D8zUY85DYTC9jUxWToE/GEdV0lPW1Cs+zumM9vN5DvF2AOHcWofPD22Y81CVbFL5GsbyQrwxMeYsG3jwMFr0F7y/cYeptKJmoE0Z7LcQk7pqGAXiKqNxzdT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 02:11:17AM -0400, Tal Zussman wrote:
> No worries, and apologies again for the delay. I had some deadlines and
> travel that kept me busy, but I have some additional results below:

Cool!

> 
> First, I investigated the workload C behavior further. The underlying
> problem is that ioends routed to the XFS completion workqueue were also
> carrying BIO_COMPLETE_IN_TASK, so unwritten completions bounced through the
> block-layer worker (plus its delay) only to be queued on
> m_unwritten_workqueue afterwards. The ioend workqueue already provides the
> task context the flag asks for, so something like this avoids the bounce:

Ah, cool - yes, we should not double-defer.  I suspect we might be
able to do something cleaner than the setting and clearing, but as I
have some work pending in that area I'm happy to look into that after
the basic series lands.

> C) 4k buffered randwrite, qd32 (~118k completions/s)
>   bandwidth (MB/s)                 649.5       655.7       643.4
>   write lat p50 (us)               215.4       214.7       216.1
>   write lat p99.9 (us)             703.1       984.4       730.5
>   context switches                20.69M      21.98M      21.44M
>   cycles                         922.5e9     838.1e9     911.3e9

This is a surprisingly larger drop.

> D) 64k buffered mixed r/w, qd32 (~11k completions/s)
>   bandwidth (MB/s)                 761.2       753.2       757.2

and this a somewhat surprising improvement.

How stable are the results?

> Again, my main concern with this approach is that 16000 (or 1000) is a
> somewhat arbitrary value that depends on disk performance. If the C p99.9
> perf is an acceptable trade-off, I think we can get rid of the delay, but
> I'd appreciate more thoughts on that and the XFS diff above.
> 
> I'll send v7 with the rest of the changes (Sashiko review, etc.) in a day or
> two, pending any additional feedback.

I'd be tempted to do delay=0 for now to get things going, and then
look into fine-tuning to see if we can come up with a good threshold
instead.

I also think in the longer run avoid the current workqueue and having
some sort of thread without the workqueue scheduling overhead would
be beneficial, as that would entirely avoid wakeups if the thread is
running.  But I'd rather get a nicely working API in first and then
fine tune it later.


