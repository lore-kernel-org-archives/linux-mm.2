Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B3EEC144C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901766B0154; Tue,  3 Mar 2026 09:04:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887216B0152; Tue,  3 Mar 2026 09:04:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765B16B0153; Tue,  3 Mar 2026 09:04:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1C46B0154
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:04:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DEA81B5DE9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:04:07 +0000 (UTC)
X-FDA: 84504920934.02.D50EBCF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id E0506A001C;
	Tue,  3 Mar 2026 14:04:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TqZGYwkY;
	spf=none (imf15.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772546645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xx99S0jOfX5Qw2YjS/eNLkyzJ9WWiDVakUvg/HB1EYU=;
	b=A9JZNp7ORH1SO8rIvgAvt0kirsFEWVHsV0boY1J3O7UduI0hvbkIV2bwWZubFvboBnRJy/
	/50zSbXkMweY/zqiUiFPhsHNJ6yZd/nIcAF2zID7lORNYkdQLODlYhQ7o0zwnzJO95ARWZ
	ZWlUuaCGA3USETUR7jjf0ALqyMDbE9s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TqZGYwkY;
	spf=none (imf15.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772546645; a=rsa-sha256;
	cv=none;
	b=KVourMmtVvbKdTYsAa4CI4FizH54R7Grm5x56KPqCsuG7adr2kQdQEXgcxhnTTYtuGgqtC
	lHVkO4GjkbaTrl5WxuMYmOIoPQRjbptTSMmdJeuz4gt7a2KrhDpQOKyEARuKSuYBNygNv5
	rbQWpVeG5Ywfjp69fSonFo4yAvDWXUI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xx99S0jOfX5Qw2YjS/eNLkyzJ9WWiDVakUvg/HB1EYU=; b=TqZGYwkY6K1IHhjjT0xHjVOY8x
	tgmETnotdWllufluRCX8CD447wxyz7MF+V7SVR3o383nXqg+wkLSRWSE2tSkm1w1P0NfGCIln3T2K
	2CONd1tYrrD5V3U4168haTz4djaa9XGviO/oyzo26pt+XmMamDeLV4TDYTThjWEs7vuapGo7qJMPX
	ZD4sGa3WwdT315CNuWrVQVVQufuwuzUiLV/NtHvFYRkjMk5DDio5oJHyGfYKzKiqZkl0mrJQkCMhi
	M4NNDrKxfNcMHsrWe+FNQzGqGiryFFAuMeIP6vpVSGLwZ0/uYyACbsCt0bAE7SVg9qFUJypDMi1Vo
	kZmLAe6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQLt-0000000FHU7-1zbQ;
	Tue, 03 Mar 2026 14:03:57 +0000
Date: Tue, 3 Mar 2026 06:03:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <aabqTRvKIWo2mHz1@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-53-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: E0506A001C
X-Stat-Signature: edxjfzxegzabhr5y3s76dqrcedzgb766
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772546644-372797
X-HE-Meta: U2FsdGVkX18iMoKhy/BeWc8uKqLTm0j8bpRKcFYsC824EcpplJOtCJJqR5hZfgvjWZHOYbn6WEn97Pr/kGyVfjwVheOZecflfbpGOttFfzxzcWJh8H5fIS+7Ht5Os4c4XE8R8E6LZUjb2jjQ+J7UYKZ2AOlofnv5bywNqaA9/paZ2dFd/XMML2JpyYq9w4jyNbYnyW/sFUXrV72n7Q3YJQt/sQAZVy9wVjl22Rs68/bcUAvAuUplSkHau2x5jtGRUfPW8EcpWq212H4LfxwKGUaswQ1bpdVm2aihG/iWfJu9e86F0+vQfuxeccolBvcsMrZgUnm46zosrb34pg6QgjIMF3AUCmP6iJXch2h60MDdYadCOXAVD19ZrQ9Fv+xLVPVQdkDhDwpTrUuYYpu/+z1haQGKFPObeFmzEZmmWIXvb1tRgLgpcFt6H5KQHQo6ct0ME16j4wBw8MB2QNmfRG8Qo//Vccf69p3jIEt5RblgkVSzEml+e5i+JG2KH9fnbSEhTBNThu7BwXIcVsb6FQj8xjUfRah3tdPvO8ld0PTTMhCUYPr0WNR7PTk8srfn2RyGjXk/I/sU4hunRiUH2zJs6zKRdXQZan5KuhJZTCJ/rzrfrbZq916+24DQF+5XuAjpLcBc8E0RXG8081GV5H9g6n2OxJQdCvMbwfP5+r74tWbc1GVs6Nv6hRI/YDaR3Iu5vzdwnqoaULvzeHxYwFsXo297SDorgBpB7ILBipMuHVl71Umf0Zw2W0A7Uup8JqHwtijt8jcY+5rbZaRyiqC87Wx859JaCbUxu/WWnl0c5JUggOJ1LJIjxiTb5Py6zrK7425x+PMH/gH8TsCTPUab/NECfX3gR3HOxEk3o53VgcuSaiCGzepV7iJo/5KEGLa5uF/BE5r4mjGcpjg0SD3ydnG4xL4jwR+CJJiZ34x3m+D9n1lJ7OW8T24wTWe+DbuIBeGPyaC0DhsKLjH
 SZj36q2v
 EXe5TIvStO0Fnouo6ABbevtj/+nR07qxEemzvj54qKYoekolXzLP+DUThdqSUAOfdZwwUW5cOeNIdn2sLiqVozL2xTKor/jxf1cgASK5EYJ3ZAYTvoADTFOUAsM+jdLHcj+qlIiJji22sZxTt6F/O9Kd/sA4jwU6Y/ryVvOfrIX1llT9jCMIicJMSUGIu7A8VjylBkABfqn66nxLzAwEjzbIvMNJIRMjeFqCeAP/Hgle77wlMUr4HgwMlZy4ZLE2pYLRQLfpOvD8PJ0XA2FLlgxE0GgzgNRtZ1Pg92ifjUfKxPs6n/pAP1fIdUmo/6nnAa1IJlz6nL/eGRwbY0TEkpNRnIuBw/hOVcaXFlPvyLc0JaHKfG+M6EhREcbe9eX4P5AkpAcMK67SL/7qvZ74njunFTA++KSiwcmgpRdppWHFfL85IIJDcuwt5N4nsg6oz0Mh5jhwfr1C6NQvvmixHsrGz58DJlAduh79xnrvCR40wPaz5WbqABTycXtxcePsIa4YGnNinR7Djvd7m1t2kt+z/ysom2KJeoJQmJzpKRXWouKTnE7Q/3I6qgvKuJH1qUO6v+oYItki6NsW/pLnEnQl6w3yigDW4A9AwdGBIni7e5foLKIRbeMkbAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/block/bdev.c b/block/bdev.c
> index ed022f8c48c7..ad1660b6b324 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -420,7 +420,6 @@ static void init_once(void *data)
>  static void bdev_evict_inode(struct inode *inode)
>  {
>  	truncate_inode_pages_final(&inode->i_data);
> -	invalidate_inode_buffers(inode); /* is it needed here? */
>  	clear_inode(inode);
>  }

With this, bdev_evict_inode can go away as it is equivalent to the
default action when no ->evict_inode is provided.

