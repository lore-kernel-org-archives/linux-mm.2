Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB112109C059
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1106A6B0088; Wed, 25 Mar 2026 15:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1BC6B0089; Wed, 25 Mar 2026 15:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19C96B008A; Wed, 25 Mar 2026 15:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3F396B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:54:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88FE9E0DB4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:54:41 +0000 (UTC)
X-FDA: 84585637962.03.0017DC2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id A005D14000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:54:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NQqLQZHr;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774468480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFchlTIOZMfi9wJHQbujTSnEB7GeSbipD+i3VdUS68A=;
	b=jHzJlXtYXUpVddSTnR/HX9ctlvwQSVXsMrvRRHZxpQtrfyREBO620d9gcTIpVmXbUi1X4t
	Y3WY6Q7ffVRYyLxHjP1agxExQFiSWSkGlhJHwj1/OFhOE1AWIbStylFkS/6a0iwuzz+deW
	gEPHTzJnFVEyyTv4z5S712onZs+LnSM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NQqLQZHr;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774468480; a=rsa-sha256;
	cv=none;
	b=4lhAfV1wcplklR4cgGd0VwzHEhKCmY9uH8RgwasY2Vk+d2hu6PRoYbgl58/nqjAe7eS10b
	8SHF6Hb8gdYny2hy4dfsaAFUmCd9FcQ1K5xOnvjzsdSUvz//5sOHCkuZnA0hm8Qsd0ZbNK
	FLnV1PnU5n1M79yzNZd7NyEpR6O7Ero=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IFchlTIOZMfi9wJHQbujTSnEB7GeSbipD+i3VdUS68A=; b=NQqLQZHr3QDq+7W+lb/RJzepJM
	7m+WjNfHq2E5KZgeHlvEWdCPyhaMgeMkREIcAjaGHTIDUtebvp/mZIDJcbBTaBhWBTEFTeCuJB4I4
	KP0DCG+gDd5MWACEtrA8I0GS0ohlKP8PpSMphdBt54Mre+oSXPGtfQ+pGOoE9yQBf5vo5eYn8Q7OR
	qu8dB6d8+khYP/Dx75Ay4LJVWLr2+DrgGTzW8YAea/jN25i7zKst0b2zt9aDztEsv9Rvj7qqbrbH2
	fnoOIsVOdw0+0fvhhxDMdHmgc9Fz8wwcKAZFKvh8AMOZyn6ZFJub/AcwRgGW1MtSUDohCA9SXI6OU
	urgqcbkg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5UJG-0000000GT4U-0a8s;
	Wed, 25 Mar 2026 19:54:34 +0000
Date: Wed, 25 Mar 2026 19:54:33 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acQ9ebzkF1u_ifuG@casper.infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
X-Rspam-User: 
X-Rspamd-Queue-Id: A005D14000B
X-Stat-Signature: n1ksroho34r89fk9c9zpo6wm6n359etr
X-Rspamd-Server: rspam06
X-HE-Tag: 1774468479-819182
X-HE-Meta: U2FsdGVkX19DSi5TxPjyWAoBVbAW+F0Hk3aWZLiRLk8ZSMUycKSSSPX7dt8ZCIe8Buq9P0JolzEPZFexukv0QY0XfIyWKJxldOmgYOE8ERdW1bXJGX+Jz4CSyJxHgNThVRPABV3XPkAb+WW8R/rdERkiZUImYJxIbgOW4At3IggX9GNBrm+Ks+WxLSLZ8qFYziM6KbAKYXjbSUlcnrdtgKdJj0LwPVa6JQ421z++PRkQYEsBpMjbYggyIO9e39UBrK6DNCWQOqrUlfjlNJ3pPbdeESxzPUzWW0UU5QbU3sf89obQJ390WG0KIHzsBJzjtCW+2TuzrOFzOXaVmoCykSI93OTaFSsGfVyB8qznrK0snxG17M03Egxk5ENQRJ/RwDwxS7b5XR8GyXXsqtwZf/YlkbXsc7XSr3CDS15yxe+vxbeH6vTYrlpyLOeF+mY5//n5ZPtZhP0nfS10athD7yMru+cW6ez9C78H65ZxRpbGDguPtQ9xh8XSPBPo7FkTJMGRuWp7TRKKEylz/Io9qkk7MeyqyxuLJ/IDY9TXatG1LsVkpg9ZmGRFkgsztVPRHFqSCkc0p2P3iktIjbT++NPq6w0JZVh9EGnmHJgwgze91pwXXlJxn9RvoyauDChW+xqCuFUz1oGyEtEuxmv01JKOQjiVmQA2tZfYbH+WgGogKPVguI9/eeiD3/z4FbGaxjmStmys9dJw8KdYFiBX5k5d2XxHm37GQaGjb+41Dofa/zcLM6PdYw/seQxeuLm9vewbk+P0V3J02VQOsg8hpXLdgwHDz/E7vvISp5cXdWugdAYkH3r7jKfnUSvlGON5YrqQBWTm8aqh+HU4FKOqGHKR7nWn1UU/nmyKHmtKO4ii6opgz6MZnbGtHr/waSLYlMm69ONJcVUvtCaQi/9ISjXNWJFkajctf7hMdw7U4F1mQ8i4+mfz3O8UdLdT5XYZiU0PVJGBXqREGPR/j4B
 cJfSZomO
 mgCKaNbfDxJ7H1m/WwWBvo2VsC/YqaYtk3yLNq+k6fEtFU8JPLp+Nm3Ti5izmW61wYrRjM+Lpp6AKxLwkEIK8YXCTl/QHU3ll5/tPHF9zLYUTvbzfUwDP8I9CSDyTjIE5mzlVXMObIddXfqr8YEr6n9JIrvoxK5ibA98J4Hdzx77IJ2Yb8028hk3wJVa3z7/t2je5qS+tt2bdoYAZyS+2c5eskZu37mUL3lHMGiW0h7h/IKwO8wKBxgoUTm0P4+uh44kxNzBMzadvNG//ieU+WyZX4ee/QppRZdB4rTRgeFKkqWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:43:00PM -0400, Tal Zussman wrote:
> +static void bio_complete_work_fn(struct work_struct *w)
> +{
> +	struct bio_complete_batch *batch;
> +	struct bio_list list;
> +
> +again:
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	list = batch->list;
> +	bio_list_init(&batch->list);
> +	local_unlock_irq(&bio_complete_batch.lock);
> +
> +	while (!bio_list_empty(&list)) {
> +		struct bio *bio = bio_list_pop(&list);
> +		bio->bi_end_io(bio);
> +	}
> +
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	if (!bio_list_empty(&batch->list)) {
> +		local_unlock_irq(&bio_complete_batch.lock);
> +
> +		if (!need_resched())
> +			goto again;
> +
> +		schedule_work_on(smp_processor_id(), &batch->work);
> +		return;
> +	}

I don't know how often we see this actually trigger, but wouldn't this
be slightly more efficient?

+	local_lock_irq(&bio_complete_batch.lock);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	list = batch->list;
+again:
+	bio_list_init(&batch->list);
+	local_unlock_irq(&bio_complete_batch.lock);
+
+	while (!bio_list_empty(&list)) {
+		struct bio *bio = bio_list_pop(&list);
+		bio->bi_end_io(bio);
+	}
+
+	local_lock_irq(&bio_complete_batch.lock);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	list = batch->list;
+	if (!bio_list_empty(&list)) {
+		if (!need_resched())
+			goto again;
+
+		local_unlock_irq(&bio_complete_batch.lock);
+		schedule_work_on(smp_processor_id(), &batch->work);
+		return;
+	}


Overall I like this.  I think this is a better approach than the earlier
patches, and I'm looking forward to the simplifications that it's going
to enable.

