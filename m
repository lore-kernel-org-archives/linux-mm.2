Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AC6CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 23:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A8C6B0088; Mon, 28 Sep 2026 19:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB8C6B008A; Mon, 28 Sep 2026 19:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAB16B008C; Mon, 28 Sep 2026 19:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6A76B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:30:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88B211C2898
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:30:07 +0000 (UTC)
X-FDA: 85264766454.29.8A5E082
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DCDABA0008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:30:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mp2k2TBP;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790638205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0XE7IoMyItwyaCzzcE2PkwcpGvCdLwnkryM7cP8W2E=;
	b=23osdvV2E1rtSxd5zzDuxr9HD9OQ4EhKLcn3A3cnSKix1Lk4gs8YDMytK7Hren2jTlCH/q
	KrSOnPxwDGTuceglXRoQNsxlHt79hZn03M0uFuEAmLIi8m13CLlMDe0RVKZW+er/9FUyTS
	LZnpwGKd7s1XYaP1jDGZPYxcv4sTIeo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mp2k2TBP;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790638206;
	b=poPdXfXlMfOkIHJVO/wB5PpucCdZonvEYqT0uOUSrl2DKiYKp7QKcQsHULZnpsxa7HjQdn
	piKJ0NzG4e8jC+7YLKR67q9WMNcrZd/f1NtcdxqclKXG4MpcTNoUWoa7sQOO6oXkWEiMNY
	fx0iofjy69puQAj7R5pF1BLVRhs9odI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15F4640A0B;
	Mon, 28 Sep 2026 23:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C308E1F000FF;
	Mon, 28 Sep 2026 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790638205;
	bh=H0XE7IoMyItwyaCzzcE2PkwcpGvCdLwnkryM7cP8W2E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mp2k2TBPVaaa0oxas9pidANxg0LgDSy5BpcWNRKUDZ2xfRnQMMIHH1Qe8npsm2EwZ
	 JQvL7o+ufYOIqkwRDBmD2qLfMkSW0hBKvMr28f3rNeL3uSw/vNuK9gPPyMXPS75ITO
	 dwgzwWjZY7IfJp1M4npH9DnI3l+UKPmhlO1KI+8FASh/ZgwvfeKPI0DYvfXtqQ0GLf
	 uS4VM5KEsvr1YvvJ4k+4lYQ3eRehbzxv/1jz1tCe/IVj/FmY+H7Le3yVGYVorc5yE8
	 ypt8nmUXeDxZYuzrfESvJ8/kDeRIh+ZBI8yo2vIfJByvMHdHRNCS4IggAjf/zsEGpv
	 8Q1ZH0jViPjeg==
Date: Mon, 28 Sep 2026 13:30:04 -1000
Message-ID: <6d0542fc07639c8df7672b12f4ecd906@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Xin Yin <yinxin.x@bytedance.com>,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 ian@honeycomb.io
Subject: Re: [PATCH v2] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Stat-Signature: smjghbaz54wo3www3r5s7ewuudo1j854
X-Rspamd-Queue-Id: DCDABA0008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790638205-118794
X-HE-Meta: U2FsdGVkX19hfXw+a3T8YLN2MaopPi8IAKPpVh7ygYdzV4Y+kg0T352Culdw33u71gwbdWvtJNY2Tb/ktnsximxc5d/Gfb6euXZaoX7i574jHIcRn50plKrsSK9V7PW2dBQRAlMsmkxSwz+pW6519OciaCtA9cjsF0zw9Muaet2OW82FisSSGKDlyhL+/iQ4IUmz9fWDevnsgURD4uLy0J8tGA1pUUCZATNB8TnjaqCc28GJtT4C9WLwebAZ6c67rgvN8lv2/x2FbiKxYVaJvCnbgCwMuj2o0EAZDZMk0LaGuwFHAb65amR2EV4nEmI4GebxzOg1ySEf/I3mxxnKvkncC9sEL4j/27BIqcA5jNvCYdP6UUq1kccU6W+q/yJ/BUmwGYltW3S+HB3KhPg6yJqZxSatsofNQ6DK1W6ZVfS4DwurBn4RvMDm4XctRRgVIxY+EDs2SYTEVFYEH6IUrreBibb9q2bmAz2Z9TK+h2FNVrVzw1ac1VI3whosyt//DLag8SZuKGIbYGgFyKIRCFMlRjhMNYXXHu6MJk9zRmEIRMj4shLrwkFadxMF25+eKjOPxX7kkWnqAAYn6sBJzrSEbLszKXWCk0QcuEroFgf4Z5398+UPaD+HN3Zx3klSx3yi+q5ad0xDLzNt2fu1tE6VCodT1VIZtf6qCi/8QCVXb0SAWALF+8OYrax3M2xhHNAu+OLzL6R3dAMLYyjM1LqfQGyWsd1tpcov3ACvOo0zFpJIWpopzl2oVQuTvyU8dEyAYimEi3RbF759jA5Jky/ujukSATrQUZzS2pmo7qKt/ExBx3CmXC+LSW7tWGU6Q4+WhEnL850zl48fQLRSKjFCTMfsmNqUVEoo/eHKkeKmiq5cydsft4DboChJkII1zjWqmosA/lsHcyYW+DpdGTQ53qFrtQrXAe17xHdgJWpwiWQKmX/vGUwPk/0SgH4iiFle8m0bnLrQHW3SrjP
 zYDfWmKd
 Osz3CIxGOiwqjFtp/udhWcB1eCw0PsY9jsTb/pMt4/G7zOmfwJBL4u4rZScbk6rA1OerrvVaPDMToP70Q6xo4LcooRdLib9U49aC40CL7yWwCG84ugPMY2rf1yAfPzFGKN3AXoJy6Ez4KIxM3BNF11WgIH2pXoso6i6wNONHbLuNeDGHaQOgGgzlq5ChrpUXfpbjBl+ZZMJW7k/BWzE/yMUfS/tr7EAzEtAHkmF24gudMuSrnqe3o6m3cPACFJ4ILKmIE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Mon, Sep 28, 2026 at 10:12:59PM +0000, Liz Fong-Jones wrote:
> +	/* a newer wb may have taken the slot, see cgwb_create() */
> +	spin_lock_irq(&cgwb_lock);
> +	radix_tree_delete_item(&bdi->cgwb_tree, wb->memcg_css->id, wb);
> +	spin_unlock_irq(&cgwb_lock);

Maybe use scoped_guard() here and move list_del(&wb->offline_node) from
further down into the same block?

> +static bool cgwb_dying(struct bdi_writeback *wb)
> +{
> +	lockdep_assert_held(&cgwb_lock);
> +
> +	return percpu_ref_is_dying(&wb->refcnt);
> +}

Can you drop this and use wb_dying() instead? Requiring lockdep for testing
an atomic state is a bit odd.

> +/*
> + * A killed wb stays in bdi->cgwb_tree until it is released, so that foreign
> + * flushes can still find it through wb_get_lookup().  Inodes attached to it

"until it is released or replaced in cgwb_create()"?

>  	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
> -	if (wb && wb->blkcg_css != blkcg_css) {
> +	if (wb && !cgwb_dying(wb) && wb->blkcg_css != blkcg_css)
>  		cgwb_kill(wb);
> +	if (wb && cgwb_dying(wb))
>  		wb = NULL;
> -	}

Maybe filter out dying wbs right after the lookup and leave the mismatch
block as-is?

	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
	if (wb && wb_dying(wb))
		wb = NULL;
	if (wb && wb->blkcg_css != blkcg_css) {
		cgwb_kill(wb);
		wb = NULL;
	}

> +		} else if (cgwb_dying(radix_tree_deref_slot_protected(slot,
> +								      &cgwb_lock))) {
> +			radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
> +			ret = 0;

After the takeover, the old wb is out of foreign flushes' reach while its
inodes may still be dirty. Kicking writeback on it would move them over to
the new wb as they get written back. Can you add that as a separate patch
when posting the next version?

>  	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
> -		cgwb_kill(*slot);
> +		if (!cgwb_dying(*slot))
> +			cgwb_kill(*slot);

Can you add {} around the loop body?

Thanks.

-- 
tejun

