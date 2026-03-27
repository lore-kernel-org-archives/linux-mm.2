Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054C210BA426
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF0D6B0098; Fri, 27 Mar 2026 02:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685FE6B0099; Fri, 27 Mar 2026 02:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1956B009B; Fri, 27 Mar 2026 02:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD0F6B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:01:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1FEA5DD7F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:01:36 +0000 (UTC)
X-FDA: 84590796192.26.61B0828
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3477C1C0015
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:01:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Gv0tKMSx;
	spf=none (imf18.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774591295; a=rsa-sha256;
	cv=none;
	b=kTwGA+cYBggNP75MZJVjYdF4+G10Fwj48DTw+ZaSP4IhBL48HJ8IB/aeClV0+K2beH2ILn
	R5zicW/glwlDhC7XR41mbvYNf2HLTulQUMlMt4xGi12v6Sb0sdjZV678YxSl2kYfMqKKj+
	5HaZodl+8h7pILpFuVRn40hvJxkOs8w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774591295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiR2I8sUxZ8yfDLJLzYQlzBVwCrZzKrXAduqCfpJ0ms=;
	b=C+5rB1zrhhEVaHFWAWAssCcqXy1p7hGncQszQyp63cDOgM9GD3rkKrhuXSXvHh38SXxz25
	10LDj9oJeKRfiPCE0bU7eLz4BeyiL3Xo0QCWQ5VFPRl9vIFVcO76bdAM8DkFdcRGzo1Hlv
	3FNr4mRu56RBRfCWXhgskNZ1zMvEC2o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Gv0tKMSx;
	spf=none (imf18.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZiR2I8sUxZ8yfDLJLzYQlzBVwCrZzKrXAduqCfpJ0ms=; b=Gv0tKMSxUjyVhdxob889CYtLIC
	F1PlKPVaDqHDZmXCEPT6cdBFQxa8xJadENkhnrMzOaLQRQwIVcnW3bZIKGFNpWhrUp13cEFpceEsp
	Dq/l0msSvVZ+JtdJBCK+CHes78MKj6YEf1wLxe6dsFDll3tYJ9lZAaFGcBEYS5UR/Bz+WXgjF6//A
	wZndvR73vmqGGrGpkh8ojVuO9rUm/e9jPM94wTRC2QIIc18fSk7vBHZ9MFdj9mvCFwvoTWlkzoGkn
	SWn/9XWy0l87nYejZfww4Oz3Bi/weU+Yzf3Bra1iCsBhQYGgOUozY/vAun5MyjvwWLdgdZ7D5NptO
	uFAhwOvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60G8-00000006jdX-4BfV;
	Fri, 27 Mar 2026 06:01:29 +0000
Date: Thu, 26 Mar 2026 23:01:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acYdOOpo51xrzNBg@infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3477C1C0015
X-Stat-Signature: k9px38n1asi5zfcdm76zdhdqxogkenug
X-HE-Tag: 1774591294-766060
X-HE-Meta: U2FsdGVkX19dSjhijL+NU4vc8DgD5YMaVzk2av4z4ltxsu4KDygQUeP1ReGzX5rYGfK7AP9CkO9mH+YPkITP5DegeXY7o35AyHlRwFnXvu0XWoxH8oOhpGl61qBDoThbUslxOzBSeESiRmmXz0YhuZF61hZHsXhA0wqebbMDRaxnGXNT6IylSom8/YAhuzFVMfmOrYkZEdLRoUeytwg22fmdsjI6GPOCpenBu4sjkPjfgQKexxzzIagrKCouabRdPPQUX5yGSmkQymOAcs9E4yE2VZ8gc9VnWjsuByC/ioF2m7jRIVZ3EwK/WYyMHu5NNDOgsmqYFUvlBdzp53QiU9gjzO3di9CHba+1dHN7FRxLRFequC3w3t9rF0oXWhWBpwJ7RXls/25+elmwiT54hXN3c14TNsDHl8SP6xeLWpXjAg6DIv7MRqbKDDP7ieW6QcbCMH69TEAamZx4FdsGYBfTzMqxmwMGs6RJfEWnD1WqaJbXJioYrbrQir8mMWi9MytkR1onM1AWxZA3p1j4C/xUHAjSzIUYP12w33DoovwTjrIYdyXu6kh6fGl5AzR1wM9OMz2A7yTUSEpNWm1v88jMw7T7ol/A4qT9/0M89XW4OxtehBMZbpGltLWdnd3OSZNmMnzzHjtTEUmK/gaA3DERTAxnV2t5rfZ5j0o7xCuyTHiOnRuX/wIokWW7FtnTUsjQkxogLuMzQDT50h1g3/jSstUcH1+VjDMK6cikhBgmdufsbhCeiL08w6wLrNI2/Yng1rJ2Q0mXRA7JHCtzuuMBnzWrqpTiRcVzANzXCoXCMcUJ66+APKCzi8gZl904h9TuULVXrCKX3mkVmCihYKhDXdHVtcbn6jRKU0mR2zCYEokr2aOOTzwia0PfWT0jk0mZH/UwAVvTm+XmTLrjwiDi/FpEcb0bOZL1jqOuTH/b9UucAiWWzIepIX8cowRG9ooXOYBG7mnJ+OvCsrI
 HH4xjsPi
 yv7J6r/aC4wvLuCm9+eXZ9BHNP/ry5RT9+ZvlifnD56Us39BmrFsNScKpbBqNzUCrPw4sWOvqnngtBEogMod2drLVDBrZD68L2j26JNdZsT4CTKkCI70tiF8Zc8/CMXtBzAIbxHWVU9Zp9RgPby/tr9Xfl4t6TAkeyTSWGGcxAMU01l5KHT9qzj0G7iuHPaq/DxvBCj0/EYP+L3o6/cvZ7zxTZHQO0zGlWaIwITYz66n5sfy3u3mQFCIciDOErZUgIJqUWWJMcvFJ8swPi53HgmwauN4/U9ibzHZpFvn4rjrqhTf/IbCiqYSRez1qrqSNgWCGSr/G0ZQ5y3JzArGa+31+QlqT2K4boKBQv9Y+CZ+sehN2ShJdw48TpFLpHt0zxR2fRJzVB/OD18mIU/tSynkOxb2zmatABgpvFMvz30jbCStMy1PaSp+aTmumkZ/Ta+0BbYkNswHejkyJZxayeirF/vVSNuOd4CxVEEZGAoBvDfvIsaC5ZUoObY4EOOfnf5rR25DBlZF2IzmBIKqUYQT/7AgX2OaH8frsGoCJk4pWWpJU4y1tdKpbp4h0/fQG+C0H8SFxCx2lvV6c5H9TswjPWv/kcmZVuBF8ouekhO4EEzVZeG346mk92BP8s6BQKR8D8LNbpd8hNMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:43:00PM -0400, Tal Zussman wrote:
> Some bio completion handlers need to run in task context but bio_endio()
> can be called from IRQ context (e.g. buffer_head writeback). Add a
> BIO_COMPLETE_IN_TASK flag that bio submitters can set to request
> task-context completion of their bi_end_io callback.
> 
> When bio_endio() sees this flag and is running in non-task context, it
> queues the bio to a per-cpu list and schedules a work item to call
> bi_end_io() from task context. A CPU hotplug dead callback drains any
> remaining bios from the departing CPU's batch.
> 
> This will be used to enable RWF_DONTCACHE for block devices, and could
> be used for other subsystems like fscrypt that need task-context bio
> completion.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  block/bio.c               | 84 ++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/blk_types.h |  1 +
>  2 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 8203bb7455a9..69ee0d93041f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -18,6 +18,7 @@
>  #include <linux/highmem.h>
>  #include <linux/blk-crypto.h>
>  #include <linux/xarray.h>
> +#include <linux/local_lock.h>
>  
>  #include <trace/events/block.h>
>  #include "blk.h"
> @@ -1714,6 +1715,60 @@ void bio_check_pages_dirty(struct bio *bio)
>  }
>  EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
>  
> +struct bio_complete_batch {
> +	local_lock_t lock;
> +	struct bio_list list;
> +	struct work_struct work;
> +};
> +
> +static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch) = {
> +	.lock = INIT_LOCAL_LOCK(lock),
> +};
> +
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

bio_list_pop already does a NULL check, so this could be:

	while ((bio = bio_list_pop(&batch->list)))
		bio->bi_end_io(bio);

In fact that same pattern is repeated later, so maybe just add a helper
for it?  But I think Dave's idea of just using a llist (and adding a
new llist member to the bio for this) seems sensible.  Just don't forget
the llist_reverse_order call to avoid reordering.

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
> +	local_unlock_irq(&bio_complete_batch.lock);

I don't really understand this requeue logic.  Can you explain it?

> +	schedule_work_on(smp_processor_id(), &batch->work);

We'll probably want a dedicated workqueue here to avoid deadlocks
vs other system wq uses.

> +static int bio_complete_batch_cpu_dead(unsigned int cpu)
> +{
> +	struct bio_complete_batch *batch = per_cpu_ptr(&bio_complete_batch, cpu);

Overly long line.


