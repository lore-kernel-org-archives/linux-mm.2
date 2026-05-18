Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A81CCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9751C6B0005; Mon, 18 May 2026 02:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925D76B0088; Mon, 18 May 2026 02:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BEF6B008C; Mon, 18 May 2026 02:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 703706B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:48:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14DFB1207D1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:48:18 +0000 (UTC)
X-FDA: 84779611476.22.6283B35
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 695BE100005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:48:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=q2RkAlOA;
	spf=none (imf05.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QlzVHg/VJtWXf7fgwcVOARPx/LzCTC/cqL++r1Bxj8=;
	b=NXduHBPCnvDrB9xuVqWBkHzcmYmAE2rOzgruS3Cl9BjyQhTUoC6Kj/Sq53OdwGVbktQdDT
	D038WBXp6EZ1eu0/1Ca/Wvc01Z0wHHbyvvvvYHcUt8yBYSSvAqkoVS2K0gfiXbo+AZl2VI
	MMSO0W5UwQ26Bb1F7urGK6dqcLJ/Ee0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=q2RkAlOA;
	spf=none (imf05.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086896; a=rsa-sha256;
	cv=none;
	b=PAULoUTW/cGy937BJxIiAmMYOvmKIwltVMOZkU1nc+01Mdn0iE0vDhgxQtFMJWPKhsIwVw
	viRrV0U37c94GkMmC8tgTQ6SsEZkMon79bAnsh6Vg/Pg34ZVvL+WkwJazLrfB74rSAM3IO
	UDKfLrELZkAM5eaLs4sGcIemNf8lI/o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=6QlzVHg/VJtWXf7fgwcVOARPx/LzCTC/cqL++r1Bxj8=; b=q2RkAlOADHQeGt9L5UyoaQwDJv
	ZQx/5j3Ebjw42T3EHsqG3owxB9wcEbB6IeR46UrKNkyNjZsJ1ZPyFfRO99Pq7rdIzRjIjhqY/AgwG
	2RHy4eLnSxmxfBP9PCyupAOmUgtVUy3QUiQtC/yw7TfXbpnHSGpOOZPBhw1I725qA/78wDtJfQ+2a
	BDLG4hAxsYX6LGB0fomexQDlVkaQxBk+84Xm98/78ClzG3v52AxBwd7LxXEu4md71daVbRlAAol2n
	WCbwu+jFGYMvJT3GJfVulk+JhK4cHftGW81kWWZoQaC3ARwxhPgGhxEnqlhKyuyAo74oYYnHtAcie
	0CQTAqvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrlq-0000000ETRO-04oH;
	Mon, 18 May 2026 06:48:10 +0000
Date: Sun, 17 May 2026 23:48:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <agq2KRd8RkP1TAf5@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 695BE100005
X-Rspam-User: 
X-Stat-Signature: yoahnnkp5wreg7bmae75xa6p819ki1tb
X-HE-Tag: 1779086896-579887
X-HE-Meta: U2FsdGVkX19UJ585kJfWUMNxmKE4lAwUZEihpyXWI2f70jy6ApnMk1m6EUw7+XIhTMEao46SZ/VcUuYwLnU/6IQdZgxob9s7FmwJrQ8k8M+Mf/ALtqcymT/dsSs6AmCsWI0Jvc0y1XdBztMbtL9+M/vLtvbTk6Q8B1B8n+y+zAhTZJfyP02+hZm7UKW7tDIhCacUmluTLWd5JFRCGJtbwFgRUD/LF2I/COg/vN5sVt45tTBoCH1f7nrbsitqN6UxrFShsD+yKU4EjauAFZbeZ5TvfOn5d2NIQgb0mj3sNKfOBzl/N+fnQAE+e0pkBpZaUJ9yXAnRRvYWISpaaYFoTy1VKPx2aVCnN8Qj2B6l7jOYsWeHFETt33/SqhimVZ42hrjHlGjPMuqDHRM5smMikNDuaF23QcSS69Yc/+kdOxntqjMLJbb3ubVVpvXWAGCaVAm2zYoAVRITt4A+Yfm22mItKvwmsex3LZ9ns/1kZAoJi8Xw4q6tgZV0/bhK2Wp3NqxI5Oq2ylMCcZAvomHzo4n2ykyCCMug/ukZj6RISUQGQUzaZ5oYOCyr6vCTa8CUUkE516FNHxyJVlUpFRH1e6UpSdOmEZLmI6hXVuB54DzTgxRbxLBruYLIivi8kBhIPufNKjZ/jkpAf4T1Y0b6T9IoPXYcicfhBWVRCaklycmSHFg4UIkuCgD+GxqMm/FCdrV4ylX4MdLExoz3YyKA5/XOgpbFxASapkSAzWyoD5Rco+F4lms+bovRgXSrgOK47jSmVWczHclg+ourdJlTgQjmqL6hckvjqzuAhYGPkQf/XYfVsE3Lxq7mMHaEKYynVC3zW6Pt4iaNRW1ItKHlFMCLOND0frebJITphHbMlpxaQfR/cwSpQbLIY8OFnNt7lYDZGdhxM2iGMi32rfQyb0rBr17GAiStrQT90gTgluXcFsbUnl2k9xZY01v5H+RjwHAKK7kiWsZ0Yz26TZo
 pLg8L5d4
 dd5CVciFDTkCU70cn0HIoHi+Px6X9Jv1utZnjv6bx6/mRrRFpuODYa1gtp+NXOVtBF9U2qKATPoUDhNWXGARgAFxbMmECAF3cruVtYY9yn5FjF2R9YKd6G8B9KB0R3Upih4N7jzu0NlGBwS1Xudcko8AucTrj+VT6b1sKKa9kAaiAfPOPb+OuWj2I8FjPuYSCVFhBFWaGIqt03LL964wkIcsaGpujJdCUqk9TVW/3iTn6xvZ3MOIctQ2GisBlHDiqvLNq/g5ns4ViIOoHLDnUm6RstR5IhCq/DAPKAu8Pzbmro3Efsz6gCtjh4CGFs59dVbDY7QZDDKEMx+BBtjhiZ4UuhYqqytV6CECU8eHpMUPkScehWl9d4FbnL9oXbWCRYojgzaBbEYAiqrbKd4ETJL+wxe7Hn+3F02iaojl+IEeOB1uzbHbNOli8SdJfrIITHYmu1GHKpIHM1Ue0X97RJLgXvmvHx/WO9+ADr/Nd6rdaEeJl4mxkyr9bEiFVN/MbslarJ/yvQzwUqQhLl0wyGQDykQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 05:51:14PM -0400, Tal Zussman wrote:
> Some bio completion handlers need to run from preemptible task context,
> but bio_endio() may be called from IRQ context (e.g., buffer_head
> writeback). Callers need a way to ensure their callback eventually runs
> from a sleepable context. Add infrastructure for that, in two forms:
> 
>   1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
>      in advance that its callback needs task context (e.g., dropbehind
>      writeback). bio_endio() sees the flag and offloads completion to a
>      worker automatically.
> 
>   2. bio_complete_in_task(), a helper that completion callbacks can
>      invoke from within bi_end_io() when the deferral decision is
>      dynamic (e.g., fserror reporting).

Note that method 2 is unused as of this series.  I do plan to add users
ASAP, and at one or two could even land through the block layer in this
merge window.

> Both share a per-CPU batch list drained by a delayed work item on a
> WQ_PERCPU workqueue. Producers push the bio onto the local CPU's batch
> and schedule the work item, which then dispatches each bio's bi_end_io()
> from task context. The delayed work item uses a 1-jiffie delay to allow
> batches of completions to accumulate before processing.

But this 1-jiffie delay also means we unconditionally increase
completion latency, which feels like a bad idea.  Do you have any
measurements that show where it does benefit?  Note that queing work
already often has very measurable latency on it's own.  This also
directly contradics the erofs experience that even went to a RT
thread to reduce the latency.

> Both methods are gated on bio_in_atomic(), which returns true in any
> context where a sleeping bi_end_io() is unsafe, including
> non-preemptible task context. This logic is copied from commit
> c99fab6e80b7 ("erofs: fix atomic context detection when
> !CONFIG_DEBUG_LOCK_ALLOC").

Let's not copy it, but have a prep patch that moves the erofs logic
into the block layer under the new bio_in_atomic name.

> +		while ((bio = bio_list_pop(&list)))
> +			bio->bi_end_io(bio);
> +
> +		if (need_resched()) {
> +			bool is_empty;
> +
> +			local_lock_irq(&bio_complete_batch.lock);
> +			is_empty = bio_list_empty(&batch->list);
> +			local_unlock_irq(&bio_complete_batch.lock);
> +			if (!is_empty)
> +				mod_delayed_work_on(batch->cpu,
> +						    bio_complete_wq,
> +						    &batch->work, 0);
> +			break;
> +		}
> +	}

Ån all mainstream architetures we now default to lazy preempt, which
should remove the need for need_resched() calls.  Do you have evidence
that we actually need this handling on recent kernels?

Otherwise this looks good to me.

