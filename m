Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8329DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5EB6B00BE; Fri,  3 Jul 2026 10:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676836B00BF; Fri,  3 Jul 2026 10:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D326B00C0; Fri,  3 Jul 2026 10:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE5A6B00BE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:00:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6A42C0487
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:00:40 +0000 (UTC)
X-FDA: 84947625840.10.4CACDFF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8C9EE100004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:00:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=guFCZvS4;
	spf=none (imf05.hostedemail.com: domain of BATV+81b6007a27a119693311+8349+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+81b6007a27a119693311+8349+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783087238;
	b=FXF8m1A+qlBX8xk/bevLsBQt8qqAQ4ctcAOWmUs/RhLWRQygXwsgQaj9TQcwF8fejgLHBH
	sZgRQROko2qm8vECSonTnrvlM0k4/hvxX93tK30tEtj9j8AZ6Jrvjp+e4EGwT2Heuzc0YL
	NzBJnEQGWjvohgXM+Y9vA0JdwHkz9Mg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783087238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1o/buuAM70ro2w2qAlzO4GrBf098Us7syxhzhfaB61o=;
	b=kciGP2NXk9lJItLlX0PJQjMaRhxDg3gnacloHJtiaDwWaMjO6YK20wFoeFXtAsfrMoL/TB
	jUmZJSO57yfsVoBHw2CO5zl4SIOQk3VkkUtO54mWPxgc78cIvVQZDfwtPOERbCBsH045XY
	7QoCEr6p28loTG3B8PaMPaYSJarvswA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=guFCZvS4;
	spf=none (imf05.hostedemail.com: domain of BATV+81b6007a27a119693311+8349+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+81b6007a27a119693311+8349+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1o/buuAM70ro2w2qAlzO4GrBf098Us7syxhzhfaB61o=; b=guFCZvS4BN1gP76TeAo6E6tniQ
	Y+eDokXVFHydQ+3Qdpyqn8BcdHR2fIdWupPIrii+HuluXb61w8g4IjyR0BlFBiEUyVJU6sgmgpRJA
	/ZLNf1sB1y7Ycb13cr04jl1xdHr26dMFcCz4F85hXgyYYDqtED4Rzju6P5r/klEEdxlU2oYsT8ja3
	AcIA5A65mTAcK/Q8Q9iv2BpXbkyHQBB/Gw53wFNzn/FMZiBo/5Gb/rjMX1IhjOAtF3wku8Hpgepv+
	aDBt1LheqQchSqB2/lUITW6ngmR1mmjfSkz7nuP3q8aottk/CXOJuq9EO/dejCZinAV2aHvrfkSpm
	ueyFl9Pg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfeRX-00000007BgZ-0iaX;
	Fri, 03 Jul 2026 14:00:35 +0000
Date: Fri, 3 Jul 2026 07:00:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <akfAgy52s_Gch2KG@infradead.org>
References: <20260616134000.2733403-1-praan@google.com>
 <20260616134000.2733403-7-praan@google.com>
 <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
 <aj4iiD5C_yyLeb3U@infradead.org>
 <akevQfFVteCOD6LM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akevQfFVteCOD6LM@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: gcbnpusctw94trffm5ww83s7x4j8jter
X-Rspamd-Queue-Id: 8C9EE100004
X-HE-Tag: 1783087237-925481
X-HE-Meta: U2FsdGVkX19irBYS/Bh6i2jWll213QCEnW0SypmVM97X9g/tmWX6tajHCdKH0Ow8L/Q5MlmIXLiTddAqKLc8WXsjKYVvvFFlCku1sULNPEZx+0TUaUENV/+VrrQxoFD3GM/3q2MwfIbQWeRx8FGdUd+0fLHK+KI1oSJemdyVdm99dGEFbWYbSGP3i5Knos1SCCDE6HGLhmr4AcO/jwlow9kg/gIqtJ+YQt8dsm/dudp+VIe/KVbmsQR/LJjH8qC18SYfMaXgEJskPJGHe3A89M1OuynMIuO2zjqTLck5XDLAXERxqKGMxAe+kutQTTxHOmPuUbsbVwxj5x2tVGV84D9JGSHZU7UttHQWoYjok61i+tRooUz7uIEM224zIQ7tMFw0i30s4vO4xVI2GSYcg9NgdfN0brjKgBABoyEM4PxwJ+aiPHgN+soZW3bWsl6Qo4M+OKW8geWKpiRzdvWvLKhP5fkJtQEhXm2wRcEZLVsti8MXKlcIUxQfNO4xH/pYmEGdVGgfXPjJ/xG4khtxZvbN91wmT3eM/7+YthgasAuS8MnNEUIsdhukVnkKWMXQ7pWOBXrIiNS12NGemP3TjGrp+BM/1kszeML4bkFsnKzfqw/vXXgrujuwBGZRA+rD4Y87PmiwjaDodb1wrYKLh84yi/jAkvK2c1i20xSVP1itSQUWqvdYsgfn+0hs9dvG5iln/jxMK/w0xtlgbFiyG9F6706oCsqR76H9eJnlnLM/LAN/P6cF3IcwRRWU7po+AQSJnk79bgsaHEP2DP1cKNfWKRIMy1uLQZlEOISvWwNlI6cuw/8ukZb2+PnuxBljjm+G/iJ/80GRAsRQYhNPytdzWBrd9fKR0Ms9EIQaOKcydpWNQl7G+wD/kHuMATosk5umPpklsrrGbz5rIgpZMyntF0cw9c2R/tcVuosemF2pMRbxCYtMCVGvc4AIwHyPrMFarZo1GsU0Sq9nXw4
 U1PhcveO
 Y2BAOeOw3FOrwiW6HZTvZTTGm9v2AMilpuVH3CS0sjO8kVBBchvr5jQ7qjRnyjZ7ayuPU8LApcwrSa7NawCytzvMxniMdiLsl8937k9j+wmEygg8Pf0GUm6+m+IvvewgRrWp6vdrhaOtpQ6+3EwAwefW9hpl51Rq62Z6o5R4gfNHoAtB9M6eVMaeNSJneEMf+VkZobxf1cysDQgets+A//71Md2xQDJdahCqZSLbhbUp9EUqs65PZ+mdMYHosnhmOhdk+T7+2lCZ89wIAOwK1Fk/UACqUujoJ9DTkOEoKKEIDBlSqUap2W2tPr2z40JCd++5Le/2zpllouyHMFjwApF/qndcot+ShFiTalsI0bjXI9Ft0eRk7rgQ0kRoTlKxY8AU65JKRfbyAFD6U3N7Npc0bVHHzuQK5LAm5Xw37aQwVyOFKlzPsA48YUmFDYOmRn0Bf64enFcSXOBTh15Zr1sYItBaRXxprGtafCn1ymUMbid8JVByWJepxTFGXtxKSfVmDZgTHBy6Wuosrnc+q2uRugKrd+H/Xrp8G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 12:46:58PM +0000, Pranjal Shrivastava wrote:
> Do we have use-cases for a kernel user for direct I/O ? (Just curious to
> know if there's something on the horizon).

Plenty.  Basically any storage on file driver, or storage / file system
server:  loop, zloop, nvmet, scsi target and nfsd ar the ones I know off
by head.


