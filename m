Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692A4D4661E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2486B0005; Thu, 15 Jan 2026 15:08:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C825E6B00F3; Thu, 15 Jan 2026 15:08:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB04A6B00F6; Thu, 15 Jan 2026 15:08:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8F9A6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:08:57 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67B4F13B0E5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:08:57 +0000 (UTC)
X-FDA: 84335286714.08.D5FD967
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id EDAB3180012
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:08:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="hoh/2tcz";
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768507735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpcZ01AOghjGeaLwyn84qH9jVj5LGN2Ssm7hC2lsYoc=;
	b=UGreMA2QJRrPMgNMIcK8G9fSwJi7xOhYucKGLf3gJ5po1bjcCi6yQqpQ1vt6tDLXkwWige
	M2QlH3NE5NxEXM4Xl6tpT3/KyY1yIruzM3kaD5RCgI4/JHM3jrfYO45CNrb4wA9fs8/0YK
	f2qwyzEi4JDYv30yDXgk00dLTBIUbgk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="hoh/2tcz";
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768507735; a=rsa-sha256;
	cv=none;
	b=g/2RzhhSTd1VyRpKG2E1y2/KpuwOcNZuCkcP6c3h7UXbti22qBEzaCPHb5VJRhJjot13eF
	sWe9dtev3/88yWFLCW2Sa3fy0aYtlwnAzQsxTIBk8/fuZB7i5kTFunuPHOW9b2yvyxmnsI
	SPsptrCzvq2bwE0Bo2U6AyS1Kmqr2aU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CpcZ01AOghjGeaLwyn84qH9jVj5LGN2Ssm7hC2lsYoc=; b=hoh/2tcz2jPraqGGEY46dkSGUP
	z2s1G26gHd9gkuXFmx9lgJNzSHgmxpLWCRUHbmFyvAL1GO53T215xwEBbQ6bINIBBOIh8OqXorFvJ
	SUGMnhQ2kmkE5WfTKQ+57Lldej58aFN2GUk67xtDqtTpMfxQ3idzgVnD83YRJ5CQUp9luSkCN0h77
	tWmlgru51ElN22k001F3F8bEghn0ousWSGqXEzXRU2e3Ykvj50pwNLe00H3tlH+6gkIEg2m1HPIql
	3o1V+4dwRuX42wm3xiUlV99ZKDfREuy25HJVUifmo0HY2TN/zwT/c82l5RJGc7otfeTndoWcZHilE
	0mjisBaA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgTeG-00000008OJj-1vjs;
	Thu, 15 Jan 2026 20:08:52 +0000
Date: Thu, 15 Jan 2026 20:08:52 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Manish Kumar <manish1588@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prefer 'unsigned int' over bare 'unsigned' in
 page_alloc.c
Message-ID: <aWlJVMat-YH16Y7p@casper.infradead.org>
References: <20260115194845.118064-1-manish1588@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115194845.118064-1-manish1588@gmail.com>
X-Stat-Signature: d69zybhrxyp3ykkdzsn54kbuc78x57ca
X-Rspamd-Queue-Id: EDAB3180012
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768507734-954789
X-HE-Meta: U2FsdGVkX18AbwdZN1Jvii4kRfwYrpp79dZZXSX41Dx0/yTnAQPEaQpj6IMNSA5mtRQSLp3tU59pNGdVS9sZuXbZUw7vrN16s/8zFKHDmjx33i2IdD2lkwi5+UOuyiypkFvcNwkJc1OyZUKhIPjHYz8jkFsmB0xBp80znG4QcS9v1Zoa/jjaNKMY9TWTq53uT+PGH3M2qtqQHoY46S0mVz7dXbC35/9T0X7Fu749OEzatmL2C9C/wO7uPLAmbU8h1UZyb1S4pZaOLd3Tx+0N483fnjbMMcy35JCLCgXr/viYoizE5qqgWcWBW6dLnhGV3u+x88BM55+8hPymYcSOd6xLhEgutWre08Cje0lxjVT5QpNfnGghKY97xKmXNSgnoE3Bu5B7IEDCajBPZa2nEmglixLeq+Ml6P30jRIQbk40EqvvRQ8sGIIImtMJ74Jek+hXcV7kaCsoSFEM6OoVHsSarsr8E6WP3a8g7LJRjAERKMGz0Ip12PZLlcj2LrG3kszW7+sZrOOYOv9Bp/904Fo/YqfUPnzcI4HKdw+hAgX9ODCpsfLJFqqHVFCBmJQl+ZDr43a7Lt2nefu3Rsq9zd8mjS4E7H13Vs8/mPgIq5FJs9KWBfm5ZBwPSy/3V6ZWiNlvAea7BOxNaXiUX/GCAeutr3jM2c+bY4G/XB64cs0QzDkoEVDSdd/Ra4MFJy2/0U6Llq7Bw2DfgPpd8QAsHDYviia44ng5Ad1xAPVeng6MdvK5Irzz2r8GYNlU9uqzJasOm02v0CHEL0W1zMtcVT2qLCR3j96mzYEuc8OSbUJh9XA7z9VTgBvlls6NmwjxY81hsmgyPopmFHjePoqfGdtGmVqznZWZry7ERjnpI8/saOFFFBw6YaV4r7qBgp3Hjc8wviwTQAA9VAtVpWcicrQZ8GnqInqNpL7G5ra9bIG5gOUF5sN6UvxrzUs6EDWpU6qoFsl4hDB0g+knE/2
 Dzo+4SN+
 2fHbxS62SQPugQoIiCyHOrf0ZOMMYs5nYJaT/GOOC1fYUaICPC0SoQM9u3NPFPK2+HhBRTXnn+/lQbq3B3KO5jnumK0qfprFrNz+XADnBFzYqZDakDxN4aQ+q/2kFEGKe6FWipjr+QVqVjerNarbp/jIO5kbFGdyEyh8vqGQZPdwSMXxPZ8pbiTgeeKlu2nBXZ4OOanLWVsSHv7Zf5W10lOf6lVt/6IAWRchgghL0SoYYbPOk20t1eKvRvZmaCt1LSmfHR/82PtWGKCBJiiJdF20SN1dJiu4sk2HJyvnBEptAhBE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 01:18:45AM +0530, Manish Kumar wrote:
> Change the declaration of 'seq' from 'unsigned' to 'unsigned int'
> to follow kernel coding style. No functional change.

Please don't send these kind of unnecessary cleanup patches to mm.

