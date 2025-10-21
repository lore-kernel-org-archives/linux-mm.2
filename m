Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 598CECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961108E0015; Tue, 21 Oct 2025 03:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911D88E0002; Tue, 21 Oct 2025 03:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827C08E0015; Tue, 21 Oct 2025 03:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7147B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:48:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 247C0B908F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:48:13 +0000 (UTC)
X-FDA: 84021343266.06.41A149C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id BB41214000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:48:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=S1F3uxSV
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761032891; a=rsa-sha256;
	cv=none;
	b=LEnbUu8HHTqfIXpA8xtcRyZTfIgOSMOeA3JomF8RV9XC0VOSrmUr6/wCDPqbpCNiPAxUhA
	jWsXsPQaKW0aBiXkDNYlO6ZtT8ahN+wlKvpQmy6IoFoaDXbG2H3NHlA05akoKbLmQhiKhA
	C5kelfY60jbHt/pis0Cep1vnuA+VK08=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=S1F3uxSV;
	dmarc=none;
	spf=none (imf09.hostedemail.com: domain of BATV+5669af1c49f76a6ebb22+8094+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5669af1c49f76a6ebb22+8094+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761032891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yalo9SiRMGqaQ57Tjo01PZAvDxSGipcok0E7dyv6KxY=;
	b=OMaaNz46gnywWyxth8RN8hU03DQjzovLfJcItqKxlUyYZhOxlfZvdtwH71oySddBUw1Ewx
	csV7muctttd9j7eEwN0zVZMxwvLoAsArPfM+3J15u4UmJoXkrysPU++s1jKZLawHVsQQW7
	MLxcgAFFuZyYvaJwHFk8yKErj4pBe5E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yalo9SiRMGqaQ57Tjo01PZAvDxSGipcok0E7dyv6KxY=; b=S1F3uxSVDM2G8R0EL9JyjwN4LD
	T3bAgqcuJQcRn2FQRZ9433Vc9KUz36fT2u2LN3A9pSSrBe/aricGB+em1DnnLpjO7heKE6tjvN/mr
	Ef2FK7rp90zlJ67vXe2PLQxmDHdSkVwOulHs86nkwEYQaL42Oe8FFZ9UxCK7ZypCHt7uFFrUnff2c
	MUQm8lfeRPk+sFn3/7EjOu/stzK/lSTG45Hr1KBCrjWikJaPKQydLw8Uji8QKXd+9+XaKRtN7rHJA
	8JSDrnlOaqQGXW9oK6pRYtdQPeon+5tFCLdEaVjjk5aYa1k9LZvTqAX3SXcCR+5dsHWfhA7/zeW33
	QLd6+eOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vB76G-0000000G9Fq-0mBQ;
	Tue, 21 Oct 2025 07:48:08 +0000
Date: Tue, 21 Oct 2025 00:48:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <aPc6uLKJkavZ_SkM@infradead.org>
References: <aPYIS5rDfXhNNDHP@infradead.org>
 <b91eb17a-71ce-422c-99a1-c2970a015666@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b91eb17a-71ce-422c-99a1-c2970a015666@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB41214000B
X-Stat-Signature: dxy8r67m49asnbq666bopcmhct9rboyo
X-HE-Tag: 1761032890-188187
X-HE-Meta: U2FsdGVkX1/H/GngMwS1Wtzx7M06/xDNSLTqv9rl8QLzi750VGf8WDaOazn1/AExbr/HvwTPkC9t4E9j5r2W1cP9AbCxoSRnT0B2CHk7xCHwtp3izDVYJnn1ZNXrytvRBSyGMYaDrW31ARiBaLaAvwHf9RiPSkTnrp9lYDXv1mx7g/z98RQWwDYNLxP36d36QPXx71P1JnXYssgGRMQ2Yx7v7ek1lLB/xhRdByrfwBS+5oSd8JnZauKlTJZtzuyVgl339Q1AUDGy3//klyOH/qv5Wu1IIo/Uka6xn4DlmdNpI6+QRUCBPTacB/ydh4pybRCpLzJJUtAMDnCNqWhZ6FujgioKI83UEoYxcsJGnuO3JMgpTNNGpLKoWXnbE1DWFEK/AoFAJGASg0nqkrnkEUZUtFU53F5ugy7r2L/DtIsMDU/gpjo+H2WJffEuvnPm6i27+Iy3r2MQ26bhwcWFSIeGmVxePOjLfIMlXOkgxLexCP6X8gfN4MOlFMFytOpG0S0tZF6kCfnbg/J6EDRMWULTbYLugu8/RIu/V0aTJd+zxWpH3QEDvnlW0rM7bdxmHZ5xLWMUnzS9KrBdEWEAkMIWWlFKkn9uMyq+BLexnIUsBBy+RDLx9XjtM+syj923pnfu5O0/pKP7W/5kFOrzly1+OO2Cc6qk4CXbpGcEQRc93mXpof76yn2ydb5CP3gz2ydeOAO8zdtHue2gVSAIAgMyZ/8HBX+RVla6L9xbDx8vMH5vdLFYSX59lFRfg74J0wo9ipinXEhN7Tw3GC1Dd5WfvvFPl8/RJs/68BpSi25h6kh96yUIcbrm20JBoqUMQtM3DyaQ5gy0rhmDFRUvvfTMu7s/ctssmY1OQcBsIEzjflYwFy31aA7I9imEkShutBxru2npbGWuVSnqQ9oQcFfEQ70XCrwQo98N8bfXAmDP6j6liiWgYPlVptBt8C3YSqDN3slprJFI8HZCSJv
 /bBL4ONq
 /hnLh9mYz5AojoNCJZszCqWkXk2YTtznxXDip7iKEYw/qwFKZnbi+Aumhm2xi6cWpAECbEGZsUWXrVqPZEx6dj4oEbWS4K7McasPYvFP4YYquPmJir4aOZaUH09HFf7V9bF8TXLP6FSZ/IP8845TJphRhDd9PgsyU1UPMYTn5tUA1RAxMsr+TXLMORHDLm4b1W0+T0g+4AhSqXHoANNEm11tx3/BLQUZUIcGafDkE+eYf1lVvv8EfSd7AiSbWRfCJlC/H6h8s5OSdLQbNWw38y0a8aeQAX1tdLwkPb9xeT15QW78KH9hJ88nuFs27BoMuauDMbbEPiaB9spkDv2ecOzHJrjBaJbSvfwKMDd7+JH3GiwexCdkRdsNM8AKChPBAJ+Tb/KbhA4lJaXV7X/uM/5wtBF1hrWICG6/fKEGIzFoqdPFluJdL59WcUFLvDpqhICx2tNJFUfM/vfoKBU+WYGjRL0s9UtpfK6z4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 01:47:03PM +1030, Qu Wenruo wrote:
> Off-topic a little, mind to share the performance drop with PI enabled on
> XFS?

If the bandwith of the SSDs get close or exceeds the DRAM bandwith
buffered I/O can be 50% or less of the direct I/O performance.

> With this patch I'm able to enable direct IO for inodes with checksums.
> I thought it would easily improve the performance, but the truth is, it's
> not that different from buffered IO fall back.

That's because you still copy data.

> So I start wondering if it's the checksum itself causing the miserable
> performance numbers.

Only indirectly by touching all the cachelines.  But once you copy you
touch them again.  Especially if not done in small chunks.


