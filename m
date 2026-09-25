Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33627C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4838F6B0088; Fri, 25 Sep 2026 02:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4349E6B008A; Fri, 25 Sep 2026 02:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322EF6B008C; Fri, 25 Sep 2026 02:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 139136B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:55:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0574B160584
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:55:19 +0000 (UTC)
X-FDA: 85251373200.08.3E507E0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9237220003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:55:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ne54MAPu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790319318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0h/KGKepbQbE7BW4Dl2uhb5RRiIbAMKTtfZ482lKCss=;
	b=IZF0NLq4FmE1xq6ah8qfMu6GXKDnWZKpG39wROD7GFnCdiPhJ9UE/Brx331gJKv5fyhNSq
	fPbssZRxNrZGbCe7P9HczlcupRtsrnBpJUs6ooCTBYUyzJzzotEh6G3CPy7YFapjYvUZdy
	exgT4pD7/ARdSDqJ4aG4YHnCiX7/YIQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ne54MAPu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790319318;
	b=yQG8t7XoQcOLgKPizNGmFzw7MNUxSLDkD8vBANftJ2V6bXqP4GW6awHqI/ls4jYbliJKIf
	S76Q6OQ/NAlzTHJHJG7Si050Un1i6qmK0/hB39bNXz/VDCic1x/4gQlyVG9d/BqvivivNa
	rROKH5R6uGDFOmIn+JQffkq+dbCPrPI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0h/KGKepbQbE7BW4Dl2uhb5RRiIbAMKTtfZ482lKCss=; b=ne54MAPuQmpprAPPdJWG246epv
	khzHhs+cYdD/YhrxYIrssU4PTa8OM5oF/tLvtU8AAJurOZY+j5Wem39+upmCDSWLPLKH2Lr9jIkNX
	yQ0/C4Vtr8flPutZmUTJq551ZSg00vBrjzjiLB02yq2tBPXP285Xu78nTvTprxioBdsZsuTHktHyp
	v+dRG2g6IdZXRb8nVwGMecKfzbE6R9kcxQ1YhEAfhEYsATA8XkmZUsrXMvXIqSosltoJzQQ5vg18K
	/FC9hFV6NXIGVa5KtVVWtCVeEWtNVZsMzReP/0MsSYkM7R8PSnvEPAxHbixh+LdX1bG95aKqaN/k1
	KceYlYew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9zq0-0000000Cma1-2Vei;
	Fri, 25 Sep 2026 06:55:16 +0000
Date: Thu, 24 Sep 2026 23:55:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
	jack@suse.cz, tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v9 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
Message-ID: <arYa1DbKNeAN-PLl@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-3-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925064444.3944820-3-sunjunchao@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 6p8xxzfcofphdh4thmkne4d7iospjz8e
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9237220003
X-HE-Tag: 1790319317-549984
X-HE-Meta: U2FsdGVkX19EB7LOwN3l+Klc4ORUqieb+dMbjdtbO94Lh40bvrLgjBbz3/uRtw6+uenSEXDWrbJ6rWvzjavUSLZ913rbJE6qmGHdmdogayTagdLBwYQGEDWkTvBNbgz55nRppSl3MzQAnWOyftGDhM90tqY83KK3pcuEKSl2F0o62EJF9GFUZByMZ5JX8pXRx25Mn9pjAl54zwY6NTnqoAp2ko0APIK6BO5c4zf0IXH/kw36+S5OAYSaGF0jCp0uU47vafJ0VTzKh6b35t8Z7gW3Jst3f7r8QUFzSST/fVi248tp1gfIwQ+L66FSatlmtBQ+Q+EtgImsxoC+hWAEGzR0AVOnIRHnIZGvP1bQcE7oh2YWWv0HF6kT6LYRWTe2L0Jh6AtTCLBqvVRq8EztSyFIsxl5Kxxa7p4Z4Z6KZIx8hdneG+5to09ggMbFP2b0SVSJqde3ATacSdb6+jUu5F/ODZ0PStWAzn2+c4TiuXvK+OFYv9lsL+yDYSOVfZyt487CZJorDsb7NyddQ+RJLrrulAloje9xjPYht9VqUumH5XgwfT2z2JWHiVcdcoGUrX7C5Gm7DpuGFDJ3YbtPouRccZ17DuFZfgM46wU3Z9mFCUTKDxuYRnt+OoaChllJj8U1KYy+QNWGWLxomXL8fEx3qxhVOhOMgFyV80y3uAXXu7e5Se0ovl55RGRypyIG4ekEOEH9pJytEYIyYky3EgK5Cvh3avnrbv/bM48zv2apFnLRlzU4k+Mkc/NisYxD9T1VWnWN8b0ybNq8P7GAtmcguV5Y0Vmv8mg3VSFFks3uy4i/XVMSXg0MDQLj1/o9zTnxQMr6ocMHDcyFKQ0qWl/Nmt4y1CQ1bEPvDlkLISx7WY7K0hxZyaujHQftS/r5gzr9x+tFnZu2BgTxRbyC8m1R3W7osUKVObNhHEOZzcIAEzG6353xdEty9iGiMyFVbDD3jwHXr7c7XdDBxzM
 cQMPNUN9
 geB9ilUwRAws+J1QoYOkDRVAKngt6juc/FoyAM1OCZ2xrEkc9cobKarQ7jfcMtNS70nF1IfX/8F9/5HT4A7NJvacAJS0XamqSP1MpTBfaBXiknHMMci9s19PLvT6v0C3iEbLbCfgaNYrXJr33sahK7bVJ74ETySKyFK+wXKu4nzx4DEi2bCBpa/Qg9YOjaBTCHWMluEi99xHLfT9vyq8vSfbQMYeYW3wGYxdK+4rOfZVeUInZCvqAPuTF48BbKkzbYIxa+yzxcwAluWpQS3Uh+vQE85Nhg7iQhEjjBPfCRvrZ6ePcj2JKFLtkTQgIYTek8gwWfgE7U82hIQjw3Zpw+NsbJZYcqZOVlVILwhXoMSzYaiU+jSHB2n1Z8dd5x+e8qaoTb0WtXg3CEmO8gqJOiHyqHJcyYYtAE3PEq1yylBUhwe2Bp79/yasotPnT8MGpTp2CqJhph+TpbuMlFwxd9c+leIkIhBpaqvJHOIyOd2o9ymFc93+4IhmFW89wiHdTabOWgug53qQX/q34MKY0nIwr+mxxLUk6XJVQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +/*
> + * No extra memcg reference is taken: this work is embedded in the memcg,
> + * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
> + */
> +struct memcg_bdev_frn {

No reason not to spell out foreign here..

> +		/* Reserve the slot: it may have become busy after the inflight check. */

Overly long line.

> +	struct address_space *mapping = folio_mapping(folio);
> +	struct inode *inode = mapping->host;
> +
> +	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {

Why do we need a NULL check for the workqueue here?

>  	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
>  	WARN_ON(!memcg_wq);
>  
> +#ifdef CONFIG_CGROUP_WRITEBACK
> +	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
> +					    WQ_UNBOUND, 0);
> +	WARN_ON(!memcg_bdev_frn_wq);
> +#endif

Instead please fail the boot.  If we can't alloc a workqueue at
boot time, we're toast anyway.


