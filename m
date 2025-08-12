Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B496CC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF34900004; Tue, 12 Aug 2025 04:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3901E900003; Tue, 12 Aug 2025 04:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F30900004; Tue, 12 Aug 2025 04:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14C3A900003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:05:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30DC7C0233
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:05:41 +0000 (UTC)
X-FDA: 83767371282.04.54FB711
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5DA6418000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:05:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ibtjAMV0
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754985939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bb46KS+TCS0ezJy71FRo1CCvXlfnyYDGVOhJSPif96o=;
	b=arJkcGSHIjFH38L8lb9Wd66UafSpY5EawapCvNrVHpXDNX8BjL+N8XEaqEJbWLrKQuOser
	eTMAtHhdefkY0ND/wAe0kKgPj0j/vNdljH5Cjq9dGqLkXFZKCaXdo4MdQ/b7UGYWxnhaTq
	CBKZxe7hX2EjC1aO4GsWzFQMv7Ro+1k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ibtjAMV0;
	spf=none (imf06.hostedemail.com: domain of BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754985939; a=rsa-sha256;
	cv=none;
	b=km71iwgehnuQXzK8W58UESJ+BpwY4aFW8b3PdtHeYBwcFsGI7vJrinoWoSTP6Ibfwo4xu+
	bIhcKG6mW3+C6DIxmfrx5zySjUJ42bWLFzDsvKtQB91AYaE5UiCRAUxLrG/auND6P0nb1O
	31gi8zqvZmAvAUeTOWN5UXEp4y+rxhY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bb46KS+TCS0ezJy71FRo1CCvXlfnyYDGVOhJSPif96o=; b=ibtjAMV00BUwFRWGsozllDrCO7
	ARCPqpi13cYElLf01yQYbPBSKSmX6dFZeKlHEAFHe4/MA1QkJcny0KAUcf2RCrYcPsRjDyk9RPibn
	i8moItG7C8vwjMHxOhmt315h+tduYteBH1xyw0I0ZJr47S2iK/JQBdzsyK1L7DnN2RYxc1o9jB/qO
	Xna4PFsamXE744T7QpPZK+VYLdeckVjtwpK9W7G2KioaCoPu1QUTCTWOq665cY5gT/mKltmFSPQAY
	d/iWIwA7tEhYJ5WqlvxQevRDutKe2/j5jev723BpykOywzlOVdGYOWiZAgCbSl8eSy0yQGcms+xKh
	d0StQarQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulk0m-0000000ACHU-1NTm;
	Tue, 12 Aug 2025 08:05:36 +0000
Date: Tue, 12 Aug 2025 01:05:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org,
	jack@suse.cz, hch@infradead.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH v1 05/10] mm: add filemap_dirty_folio_pages() helper
Message-ID: <aJr10JoIyxc4A0dw@infradead.org>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-6-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801002131.255068-6-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 5DA6418000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6x11t8yzy74rbpof3xwoe5mkz3r9if8a
X-HE-Tag: 1754985939-389458
X-HE-Meta: U2FsdGVkX1+6MFqiVF/bJu4wxz/FjdzAStePpBSr9N29W9qbVQftKWmkrQDfY8p+QLN0F0ovcCOuxv2zQ+Lzblc6WSF5pYuiYrNmMFDwbhE/Jfgf8y1zQkU5UxMOfhBRTQ7clFZFFKHFkTQ+y+N9DaYd8HPcekQlRgXJzZ0ZWEh3G8E8wa9X+3DAivyjOOomae8x0TvIuiZIjhW1Uv7WT3+OIGAXqFyy3UM2HO3sbksV6214gbB3A9UgKzapiqRBUCTkwstT91rsGs1kuq9U3zr+Nmbs7ApsGaE1cYuW/njqj17l+VCm5YCGVGq43C7Aqn+B9RyiZEs2Y1Nf6lUuh95X+fB+ijuxApPoQis3X9AenmGl6FFLWslKsS9rLL8ZXFrYsp8gcwFG5sovwRFfHujU0iSMTymXz1mXuNoj30BvONfbUcKTstL6uP+KTsAEqfPfVfUMLnaiuqRiauCjFsbEWP+7OQEy/36LSoQDzRoLAkWUgvfuw2o7Spmb8WPvWxtnuSVJrE4MrLPDHolK/Rxyc++w25BKOyz91HvuTo7visx2y8zqgQzUSmWmr0xklS4l9A5Z5R2pgYedmEVlawxWrhq0WWuzAwXme/yhrblBAq62VW+iJ0IpMpGtH0dBh01DxA+KoU1OKBy7ynRUCqHb3qvglh0XCYHupffHLidU8v9K9LSEFGFLrQm5+ztIjg98SheBF4ZGTHTnqmlvLe66pDOiJ+nQbnW+S+x+B22k/cmBA0RG7vCbZO4ZiOvo66O2l3YiuhfX8vWEvOggNKxocFDUGQgzxcl+Dy7Yk86RN2+1Gi2fDorKGrCVLs8RTWJufM+91CQAyb0swnW6CP1BUW30UIZo9EbAmU99VGZYRO6BFLJQy5vYcVav39CUWMgdZHRpTDFGVBnY/QFT6h7TLLlEuxxNA63ScouGuyLUhVRwnsTdCKLghmZxNUlIXslXyfEmM9Jupy+xohO
 MgJMoKS8
 /7VYAlM3wsgdgwFeU7Hcbue3Ff2OjBDO+N4bUzts++M64xFO5wgSPt4kS/DiXiXBm6KHG4XU9BK9Z8UZ3s1WHY26dcvBlrBEkNT4oV8z4ZTjZ2blEqY53uhruagS3pM/QLdjJ23r+41pRBzUPwthe/M7bavRHUMCkefYkktqVa1DI2RIPn1L8J7p3DZxU49zttdPaHnJph5Y55tVNALYQ9/SkWhQz9r84eZLkliw4KumnnjFCDIsz48HNwmP1iSTCTN2hIbYMzcIP9ef3XdMQlZFuvLrUjj6da01xeLQvcQPsfO9oaXFZsbekWlIaU4i5M7ThKgy5gdc5inGV0iX0cdSK+Sbkwww1VZMgDL5j/J0ay+vvQ6gwGPQpzDEPJ4ZYTVg2QCoCyWynq+c3g3ZK9hX1khD4FmEfGX4dDc8LN6JPevY/G27ibsTAQprDP4SVuDupvkS2q1cHS85FRGLm+Vz58PaTxwJQr7tH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +bool filemap_dirty_folio_pages(struct address_space *mapping, struct folio *folio,

Overly long line here.  Also this function would benefit from a
kerneldoc comment.


