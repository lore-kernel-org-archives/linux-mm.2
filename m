Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A26BCD043F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 06:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99C76B008A; Tue,  6 Jan 2026 01:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D2C6B0096; Tue,  6 Jan 2026 01:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53226B0098; Tue,  6 Jan 2026 01:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C27766B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:22:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88FC78B8FA
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:22:57 +0000 (UTC)
X-FDA: 84300545994.06.E59FA01
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 03FFC40003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:22:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=azKf2pLX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of BATV+478378d1af6c37b4ea59+8171+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+478378d1af6c37b4ea59+8171+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767680576; a=rsa-sha256;
	cv=none;
	b=enJZBbG2e2VzI2eKoYgjqYGsT7oIE5m8mAqHL76ShoJ1lwrOftx/IpjhJVNoPha12uPd8r
	ER65bpDIgZ3W6cNLBS80hqtpjxrzZvIo5U7vJYLY2SI6l3S2X/WETNBg8SGPHbOsS7US0v
	od3aOKmfVaHut+B8WczUOUJj1KWi7oY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=azKf2pLX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of BATV+478378d1af6c37b4ea59+8171+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+478378d1af6c37b4ea59+8171+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767680576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMGvj2UYTxDIhlojRUGlaXmNgk7jzB5FqEZJYNIzHEk=;
	b=OsL8j+2GXlI/I1G4fnlVEQkAbJrLwuJ+mlCrQineGDpUtT+iVAi01y76cylGNRubHbJFKC
	F2Q0fBtosJSTTsLkyIZKTq6w3cj99up8iEchXNGKgpaomb4nN1xgrD88DnD53RMKFhkJ7+
	EaVDS18dJoprXrMC2oLvlhmnjKVY/Ls=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NMGvj2UYTxDIhlojRUGlaXmNgk7jzB5FqEZJYNIzHEk=; b=azKf2pLXG1AFtApEQlzeWkYSfj
	RBOoYwUZAYaJHmTlnmnH1e5aKg6k0alXBYfudiV1SxhBp4r51GrVNqYqQGFTpTUtr1FeviBAX7aoB
	Udr8s4JK1xndy7zIWfKVqGz6jUyZQIVdGnk2mEj/ixSXhDdWq4EtLkENBpmT0dV/nQE3CGZnHvvVs
	HpHXRPIPLbbo6yK92RbYsSC5iC8lugbrd2q5+SXHO2hYwBGXgPkOJZr14GTdahIZ72rQhi84+OIn9
	Ewpu2fTMSpsOh+rNhegKi7trQf+GfV/ycnzm/T+FU+tFNx4054y+ledcIWA0Rf8NRpoWE7EhwBB1o
	gdllpJhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd0Sz-0000000CSwm-0wkQ;
	Tue, 06 Jan 2026 06:22:53 +0000
Date: Mon, 5 Jan 2026 22:22:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: klourencodev@gmail.com, linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/mempool.c: set @elems slots to NULL once freed
Message-ID: <aVyqPfnVtdAM4HYY@infradead.org>
References: <20251223231054.16061-1-klourencodev@gmail.com>
 <07c4f991-ae41-456d-8e7f-287bf8676c9e@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07c4f991-ae41-456d-8e7f-287bf8676c9e@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03FFC40003
X-Stat-Signature: 8ksqq6ckyyhrbn7b8kcdrzwx88jyrz3o
X-HE-Tag: 1767680574-76259
X-HE-Meta: U2FsdGVkX18h06aM+H/xQMZB92sFq0Qh5bWyO8zjLaP7N6pNdiaJLVdnpjnTaGeY+8WMcKGbmWn4YLClRDpk9iTHYgo3BtP+Sn4QjEnDx7fKIq2Xvzgd9UAhMa/6696qUVSasC8cLxc9AfjShwByZsjGFJ5PWv2rYXKtfBC62hUnoEBK8wj+NxoPRhSsdz+bXIgBMdUHpaZOVzvjhEHo0nLj02LxzMgxsjzVyTg7f+T1QNjD9N70Uf1B+/o0+xAFf5G85dvW8P/SuxlmPpuUgA9Sa3qyNF6eybcZ37gJZ3WO//UGRguniExmH3Eyt1PButDk2qWrEwmjnSTHLV0Lj/cZdsqQy4pCcjbBTItEsUXcBq7FT6pVK7w1hOHrh3OPEos5UO2qf0Lkn9J/GWevuR94FXMYcWGwLuvhvfBEjTsnzy4JeD0l5jJVcBsqdqX1WqqCgNbynwt+dI4JyWl6IruqcHrsSrt1GGhoy+53Zuwk1uSAaPkKaLv/JZDCYh8XuCW8EPPLN7kRfEgwmHBU3aewBBRSLZ+9e66sLCQsLi7Uq9C0w38B//Tc+U1PP0CpQbX6ftzQHT2VfYk+mHCTyOJ5uOJhW4eS6LA8pTaTSeE7LPWioatrBufVbbq3WleCvBmvEZl7txxVMF2tmJdCZJxllHwDrMduAyT6oEvGwBZzwqXanqB7eqpeGHz98cubTu0E7Zkbg8UmhkamTEKTW8ZuGLuLVuW6yX6jumZNv2/96SHcIxmUxkkRxFdMPZGDKgbJ/70jV7EXfnNSPqcOsuoezK9eiUjDMzh7ZprPTF0wNo3+XckxKmHZYWFPE1UJPLA+NKOZkQ4sMpacyViIjapu4/czrZrln2GAZ8TAzamGwY8+IBlLJ913GGGww4lZ/9Sbtwte5U37i/preWRNuEBp27+ReWIkj3xanpMWY2W1pvtpQ34Wvnnm4eTHW4vr3jUTcsVCrstIWxGbDBu
 /6IUtiU1
 8lSIamjmW6xjHJ4h5/jyuNYn3whJkQGu3RDWr9O1oMNSEJTuXu/t3x3LdW5WGQjWwda7aHxfE/6i/nfTx/fvKBzW+N1ZPMBBzbT5CDWkCbbYE5yPjPyskQGADEFpTBY288iN3dftXHkLEpCW4NCvmYtoCQ6N6dfDijGEL2lpUf4L+8i9eh93XVKfIZ1y38Zd5mvxY2D4fdSHLFBsXoCb+igF3qICwS5aS/05M5CtSY+awEq/7T0EpoqIPA9S0D1racRYNdD/QKAK2HeVIahU+kyUjZDT9A9PRLUOGHaFTw4oKQERwJ9fukw/Agcx6MdYlKvk1sLVpUXsXe+h7uALA2LjrYaIO89EakNbNrA6Vou23xEfT+bK+IixVjQ2B+tVKiJ1+ds041DZswftc7Mqmn1EGE5QRNVhenyvGF7WwqlitUn3ymhmRmFW5l/pqeOxBAknOxp+KgGYx32L57PAJQTp/+eatmN973KF6fX0y77C8OoB8tPkcGPmB+EMm3nDhh5hxspEvBwrRqKqTO4dfnDTHwKxiYUlU74E0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 05:46:47PM +0100, Vlastimil Babka wrote:
> On 12/24/25 00:10, klourencodev@gmail.com wrote:
> > From: Kevin Lourenco <klourencodev@gmail.com>
> > 
> > This is documented in the function comment as "...and sets their
> > slots in @elems to NULL.", but it was not followed.
> > 
> > We need to follow the NULL assignment, because elements newly returned
> > to the pool must not be touched under any circumstances by the user.
> 
> Well alternatively we could update the comment if no user needs to rely on
> this. Since it was modeled after __alloc_pages_bulk()/release_pages() and
> release_pages() doesn't do this, we could also avoid it for perf reasons.
> Christoph, what do you think?

Not sure. I hate the magic null skipping behavior in
__alloc_pages_bulk()/release_pages(), but given that we try to stay
compatible it might be best to do this.


