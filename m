Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A11510BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93EFA6B009F; Fri, 27 Mar 2026 02:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916E96B00A1; Fri, 27 Mar 2026 02:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C316B00A0; Fri, 27 Mar 2026 02:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC706B009F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:22:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 254F55DD82
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:22:56 +0000 (UTC)
X-FDA: 84590849952.09.A66BDD9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id ED74180004;
	Fri, 27 Mar 2026 06:22:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CfB8A93h;
	spf=none (imf02.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tOS59SYBV2Xl4rD7sZmCPHjc9f7vtoL0THKAa/pszU=;
	b=Rp/xRxJXgGeGjaWEkM7hTsAqS2FwFiZQqh0c5TicE1ODRWHjiCPXztdb+fPzyFLAAZS4/U
	h7Ma6/WK5VDlXKLVoAeO/3ShZ5S0HLPN97sneJCgkrenpxnyEPDsfOZ4EmMLkLCz+DAgGJ
	QG+0//TpZRjs6pmesv6qA0hPiyT5SEQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CfB8A93h;
	spf=none (imf02.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592574; a=rsa-sha256;
	cv=none;
	b=XbllQUlDDVBEVubpgEHHJewQ2QS+0oe7gXJIrplLxfZvcTlDk1mWkrf2xQ6iltVs6PXG/X
	J/xuku++XoLO0He+71G88pAgf4t50OFYZBVDas2PtOoYDKOEwbCjww5aFcl35r0aezo0X7
	A1I5BcymBtnVr/rddQidAZjtwIQHJ/o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7tOS59SYBV2Xl4rD7sZmCPHjc9f7vtoL0THKAa/pszU=; b=CfB8A93hmZpVjxpErL+4TlDGBi
	ZZs+iglw064x+KxCFmbS1Dn6uhOtdk8ZDFiuHXYAKxReHdmZ6Pv8SncVdi+wPW0Hy5JYo6ZRf/Gn0
	3twkSnp1XvatgoSmY/RANY/k9vCppXLz2BiSOK31aIAEh8KNEIuAxSrhwW+CLaj+sY/qLXmsPIrl2
	eDq/62Ob6qaaDw1d28zlkmtVfUW86em8h7Yv86oTqCoMXZ55Aq8znbgHBuvTIIvLXPOTnWvxPi+S3
	3Pj7Qy4fSkAsmK1zCOXQeS/RjcF2NH8hhybx9Ggs0quX+pEUBK0M23o2g+U1tY0S9SgdSuO0REXdN
	1KqRN/ew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60ao-00000006ntr-0vTS;
	Fri, 27 Mar 2026 06:22:50 +0000
Date: Thu, 26 Mar 2026 23:22:50 -0700
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
Subject: Re: [PATCH 22/42] fs: Ignore inode metadata buffers in
 inode_lru_isolate()
Message-ID: <acYiOrzqSVez6rnm@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-64-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-64-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: ED74180004
X-Stat-Signature: 5761u4ou8ap6b76icpktn8n4dtc186ew
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774592573-318407
X-HE-Meta: U2FsdGVkX1+RvThr/fnlx9d0/7gePRWb7yLIWmbiGc9ZFATbz3NjeGxWQOs/dWY/fC8D65NuSG4/JV5Ffuzb1D94f/Fij07keVVIuA4Vz3vTJTOAXDw641AyRZPxYx0iiNfBZG7bwe3j1tKZ6Dua2qUgbSnEGLFeKI81wIYpLRWk+j8bUacRxBgBNT5y+tD/ZpG2dsJQj3L3SRHR82j/NlZpXH60kX1QWgHzDJjbtyhLmZq0WbtNQ7Q89kUQIDIMGAy1Vky/zy5g2ZRc3yDTuihm+JiQN7JmRhqVIM5u5dJrRYEN1GOkOuRffyVLxVqX7eGw75tTD8UjTzMncSI15U36qzevxU5XxyabXZ+9k6B1zy+vRs9ywiSVjFBhM0BIdxj4lMgJ9iG6UcbhL0tNRABAQ6k3nQEDKwetknASdrcCcHYHuZfORp0vaV7KD2eITusU06C+aRCVRwr9oWJz0TSy7ZUnkeMTRZ8dRSCk3jvor93F0EjLPaR5AhyzWTiICTNlPdhsJEudHd2po3UCfJPf/Z3wFrUrvqQ+/BEiEbblVdQW2yjrLum2L90qIkKWbxC7Z+E7j2wjnxNi67N6vVDmNDhNRgERETsD1bBEUqR5faaDoAukHnuE0RsPvBghD6VlCyMozB4pV04a87iHRE0VN82+hXTMbJolPtHfgSup1JXp7fNJvLj7IWxkzaRdYjK922LB1rdsrS9JyLRhMD959wjS0aEfVNJGZWi2xzmIYqnM7RkaCT97Vnfz1DMQi0FE0uX4KgZ++6atNUYZxiscd/nWVu0uCqyKv+1pZQkzGLYIe6jpMA19na8e/QwoauWYryMD20U0fbuefF6CeaT8P3DEECNrOyLi6H272yvFfiC5U+u0K97tEpkzvX9rjcZOm/6ORi13sMkPNuhmXSpf+DTvCYB4lJA8V8Vr9/JV3Bh6kauyKRH1YUigw/38HiIEUulOHe4STBI3oQg
 LtlU3Sa3
 EaYAB2ELOWIjqFA983Bd32/XLfXLzmBxGeJQYoT+5e5MbYt/lGKJZA8VYM0cVTkUD5G4kl5to2Z9GbQWzh2L9m3e60tNAipY0C/nHTDD7/SQg3WIb5FzvLKXnegFweEFmZ+JPmtLd2fB6HOoQIE0FXcIIMq2Nu2ebzBeV6/FkwMHkzRn2+FiXgIDsX0h5qRAHrmuotJpJvX8WwrfdGUIA16409g5FuzA4z2C3sClvRvoAEN57R/9qaEo7/5d9p8mn/hFrYS5PqNAcAFpQEEjlqbRAdPrdfNALdMo59v4fsncRZI+RVjvFP8jHffD5gr948KewLB9PubpETCgoZw5e+NFb2XsFqalrwUAhjyN3GdB3lrtg+GVDnVDGmDBrppp2vQq4j5WwODl+pU3JjO/FzU+yY4sqNAB95Yqjm4w849oLFuqF2z9N6Iv2s4sfjYGqyrfNf4b2f0/8XEr5AVLh2x9Pxn8pvch/QryTG3SOgQ8sdiQ4A9AC2hiBV/YTYjuv0c3ICYXU1YhTrjk+3k+o8BAcF/eg2EWVPf0BF1PTg22IIpuaM0B2B9B2pU9vUhRJ2KkP5AruhK16RKVu3zcTqgTGLyQ5V2wnfrprsQR16JRtCQwr0iJEbyUBbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 10:54:16AM +0100, Jan Kara wrote:
> There are only a few filesystems that use generic tracking of inode
> metadata buffer heads. As such the logic to reclaim tracked metadata
> buffer heads in inode_lru_isolate() doesn't bring a benefit big enough
> to justify intertwining of inode reclaim and metadata buffer head
> tracking. Just treat tracked metadata buffer heads as any other metadata
> filesystem has to properly clean up on inode eviction and stop handling
> it in inode_lru_isolate(). As a result filesystems using generic
> tracking of metadata buffer heads may now see dirty metadata buffers in
> their .evict methods more often which can slow down inode reclaim but
> given these filesystems aren't used in performance demanding setups we
> should be fine.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


