Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAF410BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13B66B009E; Fri, 27 Mar 2026 02:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEBC56B009F; Fri, 27 Mar 2026 02:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A288B6B00A1; Fri, 27 Mar 2026 02:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3EB6B009E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:22:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E42F8D768
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:22:30 +0000 (UTC)
X-FDA: 84590848860.23.D2C4747
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id DEB86C0004;
	Fri, 27 Mar 2026 06:22:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IkRI44qb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592548; a=rsa-sha256;
	cv=none;
	b=REuenZGC6XwwUplDDnhN7aOfRPJy93dSdmA0bXI1gjoEFWX6KZR4oT1UtQSlXhrIm/RJ9h
	hjcVUVc1NaRt0aXg90QJ5ggrJRTobMiHUOlBQZvr/XixkM24AeEx19aWiofBdtHs0DMaHL
	y3zY6Wbtj2ttMLP3uWWG4nShxsYz3Gs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IkRI44qb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7HCTHYUFfQwB1AnmmoNDM1xdUIQR6x6PxBReIWtx+E=;
	b=hL7w0XcR+2xUeTNPsSMe5fQo/zrJmQW++Wu+91noF8eoKQBpg9pVJVMPYsiFuFg5y1GKZ0
	eCZx/FIFWdj/1KSrmR6u5xmdQ27XvY1dDZZqGCX9Xj2nAme/cKNNnuvvq6Vw2UdA7VtPFC
	f1duEdpnKf2YP3idCaHF+FoKDK11o9g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r7HCTHYUFfQwB1AnmmoNDM1xdUIQR6x6PxBReIWtx+E=; b=IkRI44qbd3PTpzO3/QVrtkxOIa
	UdkRK1WNceu1VkN2FAz2VYZTY87vmdmh5ycJw00nJFxbqsWpQwUJVovSF4eqtmMCtypEy3l6EO5FE
	zFbGNcEpK3QWUjXgdsJaytuVTkh8sI/mW8q7W9SQs2ugKWHEHYP+owYjVJkDN8x/vbT7ztUkfe1CN
	BqtCHxS6B6DgLfmgZK7ubM4z0ZcVEEsoVg2ocnFUxUgS3ly0wMRCzhMRL/ZKklGPlhhHSCX4GSE3r
	SsDmtdDTGNoQ9JMhikWjQB9Tsgz3lFsT9/imwdmCQO5u7SXUOhokx5Jiw9ApUVDU8bH7mwmsE/q/x
	2JorWLSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60aN-00000006nbg-3hZ1;
	Fri, 27 Mar 2026 06:22:23 +0000
Date: Thu, 26 Mar 2026 23:22:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 14/42] fs: Rename generic_file_fsync() to simple_fsync()
Message-ID: <acYiH4ByDc1-nPqD@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-56-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-56-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: DEB86C0004
X-Stat-Signature: 33ioptkn3ahh47cwfojfi4iogxmeaaks
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774592547-907131
X-HE-Meta: U2FsdGVkX19s8iHxfGqyF2MiIdwRkAfgQJ+dixF8p8SLIFMVbaX+JRKrtLBr78TXrkpFTnel3Pp362SEr6m+h+sN/m9/3A2s/s4dzSgqjTxJpmmWu1nL7ql85K8LHsqpBFViuVFqlA3CO8hL2raBkqr2EL0XaFGW4um/X400SXKY8yeb8Ak9LX7bHXBXQ0XBv/8WoA2FhXhMdrbLQ9zlrQMiwUq0Y3e+/70SZ4vymo9hHUvEfhAyonYpSf/guMztz/Wi8OzdVDx/7zAbPhvRvwf4KRYqDIqqxQdHHvZJXCv6nqWPAHzKKgpfmC1yd6ybLKOICwp4txz/Dj8z85RRZ8pJd2fYvJZ1h3KMvjDv1RUIZ6b2jbEUkvDrkgaOxVo7mPdSisroRtFrJiHsWKjN07es5xVHmtQG2yEnqU8Sa2FYUnDJeErkgjHwkinxxU15ijD68yYeLqzpLFDmkWO3X78uOFyKNm5Gt8voWoQ7pxPwBOEYtKmcFC6q9ZHAAXLb728vfnCyznGckdzZzvFCzn9Ys5Jgv4RZX3p/bKAe9+BBLUCckH2ubt+x64bDuNr5sMBj8H5Iep8wlqRCT3Hi0wXz3oTG9SYZDKbN5OS6HzYTTZdgpybrGQbPNkNR65qr5rKLfedLW3FWtc6x/ak+NTxyEmWRn1FzoMo6wxZg4ffWjkh0wW+KtaYjode8VP/7XbS9RPRxMH+OZ+pz7iattwdvNusG9HS3i24qyJbzn1ER8+oys5wNRTGQoiRPZ3Di1vD2Uzo/Aw1Mt1bnK5/rsHOL7TnnawiZ2QBBtLrG/jBtCWjCETTgiRiW+9qCqtV4K9iWNam6GDYgWvF51CmNKqrn9Ip9LHGOkGjYTFhvCYqY4ZF8v0SWbL6BL/LGcA+LyBn2zDDgTYShSlHoKq4LQfPLxYze92vcq+M5evN/eP4AiMNgZxx9FgJzIh0MXeLV+taflKaD7fOaWqeFjXW
 L+nODGC9
 qvX1X2HhLW0O1fhX8N8yMhXPDMoHGGenWL4RitZ+AkjttpO7i/Ym3K6THgsTBY6IBSYDaZvVrMZC+M4HFofmLffF/KkudKnIxa6VzGrTFy2CMo6AgCLqaUstHiQsPs/G4u1BfrrTlkkSNOUogM8zNwhcYPj3dM1fDswbGUA3Ou4ZoRDMbBNlzJ2v02kGIBrL6iQJNuqNd2WVEbwcz1ZMgvmnvu/eoMAY5kgYtg9+AO+GIQz0yN8RkVct0EbuVooltK/9EWyBG/q4ZE89OVqq3SBBVG6oylEnzLnAcoLW0SiSjlH6GKJajIYD9HakFWlDNHmAbjD3j0/LBg/YzlFCgRPl/zdSXJi5s+AM0WHR8XVXRZZdh5MdJGS81HIUhjDuw5BQpjfsuK+FaCclSk6eGmCjAPKClhb7pO/5rx5+Lc3n1TZQgLwrmFY3+TJ3s+HX7v8xMEVvzNxwltEDwA+vRmsc5veczsNb201fV1OX2Y9hQWjCOe2OTbb0Y22DnwaYSGKN4Grz8J8CB+NdHyQY1Akn+u30wikOI33jDtsraMvPoTn770RywuG/mxaloL8LAKOXyeQ52UQhAhM1d0Rh8cLeoSf2IRLEl7mw2GQoS+wpasc2N/2LOJ+eb/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -extern int __generic_file_fsync(struct file *, loff_t, loff_t, int);
> -extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
> +extern int simple_fsync_noflush(struct file *, loff_t, loff_t, int);
> +extern int simple_fsync(struct file *, loff_t, loff_t, int);

Please drop the pointless externs, and maybe also add the parameter names
when you touch it.

Otherwise looks good.


