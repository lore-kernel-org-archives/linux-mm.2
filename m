Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F7CDC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24CC66B008C; Thu, 30 Jul 2026 04:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD446B0092; Thu, 30 Jul 2026 04:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1165C6B0096; Thu, 30 Jul 2026 04:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E04B26B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:13:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 515F71C1233
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:13:48 +0000 (UTC)
X-FDA: 85044729336.06.7ADD8F7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 00EC3A0006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:13:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=HXnE18tZ;
	spf=none (imf25.hostedemail.com: domain of BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785399226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STnZe2MMCF/BzC03VvW9KYRg64vjJ4C3hF7Nl3+7RDA=;
	b=HusOMEpy5c4Va4aYq6tYKgh40i9kKWHQBTVQUOvA3Gi++uq/tKYtgi90aYq4OZJmcaYPrR
	BUikyKsdte6NLZmyLQ+nZ1NCBEkie/Yxm1iYV/cAcElw+gBLjbyA/Z4yWBChPn3vr8VGz0
	zXPG3V03FnmdcE5Q8WmHWBVAzOTFC1o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785399226;
	b=p5kZ3mFzJ/9mmdt0Ktj+cYSA5/cUl7uGTiukXcsba0DS1mkLSlLRxnQ5O3snQvry15JMOq
	PM/wPhc3j+bDMOjXgRjmfkixodS72yS1JkTHchCpx4ku+kq43YQ6RXcxPZHXOBazyBU1kr
	EdblHfYZ5qiRMOwO+QfcpU4Ir54BLpw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=HXnE18tZ;
	spf=none (imf25.hostedemail.com: domain of BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=STnZe2MMCF/BzC03VvW9KYRg64vjJ4C3hF7Nl3+7RDA=; b=HXnE18tZYg3z1yOR/vmkbR0e8+
	owNT0191K6/UHsvHlua/zgTPNh+47Mrlet9VRkD9YOmskNQ/80p4l1obKzRYpCGKFK2MtYU7TtyBE
	QK7pHvVOLyKoFlcEqf53voXwTboFbLoHobPt7cmSzgai4XWYpKfuBTiEBa8cJdaoV2k/2DjgijOrz
	47Y58aaxz3ZmSK/0K3lIEgqq5eMANYzbG5Dun1BhAiFZooTUwdLf1QlnI3zuvXNZB5kjfpSVqgnsz
	B1rb3EeP5hQ3vjcheeUz7cCvXG4m0YUzgFz2zFCUn8ORPE8USQ0kcGerQGWURqWi+FHR+hqLmdE8F
	LLVAXE1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpLtV-00000009pHc-2Lu2;
	Thu, 30 Jul 2026 08:13:33 +0000
Date: Thu, 30 Jul 2026 01:13:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hillf Danton <hdanton@sina.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Message-ID: <amsHrVCJnuXzeGG1@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 00EC3A0006
X-Stat-Signature: 5k784txm96t5p93tc8bk3z43o9nqo4fx
X-Rspam-User: 
X-HE-Tag: 1785399225-888208
X-HE-Meta: U2FsdGVkX18rDFfGiS9xXzjfib8XFYoVsyheMCBbZaQkdk7ZRNc3SX8ZwdZnkXbW6UYPRf1Xs9H551NhKN6Xqyu4ZRDhhxIR3V4mA4t8G6lkDfsnwbjHzBQ2uVcGYHF647PqUxPccugYETt0Q2LpOkDOcRdXD4+Q2qfDE0SMhABYoCaJzZ+Qc4K4p13nq1mUkCHjyXMkEVKF5Ek2wEpBoki9ZIKVplTSruX+xkSY69gJhHkAtqVkr3vNW7Sdy77IIrth60IDMW2jgdVG+mSdM2AKkuXER6DLNIkCqMXsSY9++iXzfMUzO0dQW5UdaZsRk01f9eUF9R6IND0LBOC6jwJht6eOMS+M+x6TOM6uh8cHerIAbYGGQXA+iifu/AijUwzjWObJdWh3H0++XkKiSUOhmT3japxLf9VOd5pDv0nNDYWKKGHp5sxSl7MBsheSl3HpYxIsLQNmR42xOfIGTonB9zLtZdyFyl3pQct/1fnAJqEm9G5uKjxlJJZHGxs0QdnWzzPRUkrfLwMV/xuD6WHIUbXLAXiZ/qj1/7Y137RQd8AvDIS7b8A0pPnN/Jin82jCQ1LGs6di+l6LkDzEnLs3DmLYDt2DIuT/8stu8mrWtQOTXhjDYA4JEC/V7ebEC+urjAeav/+2nBnCrgKqnct0AHdY6gMFEHJH07XsKmF3QWElDTTffJVAyfsew0eIPJTAQXBRIGh/kQ0G0LoTW/4/tlsaT/Jq9l2w7XUUlYUvd2O7lutvN8J3kgH98vGtO5fp242T5QnIZTUP7igDcx/8P33yMUOeiHqzilycbqi5pc7oJv1eMXsPCXp2DN2PHegPaaFS5q6VMi/6mYdxiJ8mGuS4KJdGBNPoNTnnHwe7EZsgXyPk/zKlbM5vtq7lKSiSD2jNxlbDAcrEw+CvNQ6iBw8wiMfmckQkxK3NDyjYdkN/B/VmOed8sGw1VbZFIB49WbuRTtrxqrO9cmO
 B7SPG8IH
 lL2o9QsDvy0RaUy9YWbl1KixPP8VPrvu+WLA4iccwbG06smvW5vIol2j4Um71wi7rV0QJQdrgMwEXwqE8Jdci4ETB8s/X53FuEvHdy8zDaX4SxOvhe4TGDfy/6IKN7O4BZscvPoHbUiu6GNsri3Lu2Xaf26RgJ9JQ0KKPAovQhc+chok8UQA3ggAFPlr/iVUIyKHpaP2X6nViG6SM19QdcPefA2BmA5WWN+JVn5aFOsDRHOxbHmRckjnsW+9bGr/3MZ1F5ZWp1d5P7Mgd/EIaHqNPUGpMaNALNlzg1YIfP5vi5SmvG6rLWBqMQoqtkyGzZzQoyUCugfA5h7ed2NIqEFWcEn92zKnmJ64T4gO98iqW1Culo6nDDzZpCc4dWetQzi26M4gky81Y+SExaJg5I4rxQ0DTzW9uamcb/3tHCw0aYHO+bP42r492LAdrL5dJt7qT8NXdzRWdaJGBnkuRPTM5b0Xh5+8l5IZRlWDAha2iA3wX2U8+hg+biz2CeaA6kv4/GzTkSQXkZ7VqvNN5s1EugmSGYCaPHV0LwqpAvOM+lHxSriH4+bn+nIqGyjziipWd6zJv81ey0Xs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 02:57:53AM -0400, Tal Zussman wrote:
> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
> is added. This ensures that bi_end_io runs in task context, where
> folio_end_dropbehind() can safely invalidate folios.
> 
> With the bio layer now handling task-context deferral generically,
> IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
> route DONTCACHE ioends through its completion workqueue. Remove the flag
> and its NOMERGE entry.
> 
> Without the NOMERGE, regular I/Os that get merged with a dropbehind
> folio will also have their completion deferred to task context.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

This seems to be missing the bug fix you identified for the double
deferral?

I although thought a bit how that could be done cleaner, see below:

>  		ioend_flags |= IOMAP_IOEND_SHARED;
> -	if (folio_test_dropbehind(folio))
> -		ioend_flags |= IOMAP_IOEND_DONTCACHE;

I'd keep this flag.

>  	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
>  		ioend_flags |= IOMAP_IOEND_BOUNDARY;
>  
> @@ -256,6 +254,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
>  		goto new_ioend;
>  
> +	if (folio_test_dropbehind(folio))
> +		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);

And move setting the flag to iomap_ioend_writeback_submit, and only
for the case where no io_bio.bi_end_io is already assigned.


