Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F02FCCF2C7
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 09:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A01D6B0088; Sat, 17 Oct 2026 05:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151166B008A; Sat, 17 Oct 2026 05:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067BA6B008C; Sat, 17 Oct 2026 05:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD6686B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:12:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DEE1A0231
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 09:12:09 +0000 (UTC)
X-FDA: 85331551578.27.4BFE152
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf20.hostedemail.com (Postfix) with ESMTP id 07B0F1C0008
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 09:12:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=fDfiYByx;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=Pqd8QaO2
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792228327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UU3pr7YlPujtztfaD5rEaSu3Gsw2VOPeWtM6bSVkPs8=;
	b=IeQfUTFMDndwdncHmBB9qAmt8f5oFKdhykJ32t7rBhWCfAmYzjNxDreZ5xxYOaTIk8TVem
	JWqrOHB8NmCxOm7YpYnuHPxDQVTELHV3a4K6kesjHFxEfcUETKGlyugB3sGUYeoiG7AHy9
	Tr6VnUOrK2qn0/m9dtvMp2NdxVntWSk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792228327;
	b=Y+X0+q5p9PQUDHmo5W5Sjm/P9dP9jfZFj2guQQyYAwNJ4b5ikG75gjs66jQjYCFaWIGicQ
	AoQqxnSRc/RELg9KjeZ0theUiamDlwfe7VVdgWl/Yd44zYbxmrI67R6NrHi8KgqDm9pger
	ihP8HSCq4tBq3tPwAUtSAWa6+7ZmT5Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=fDfiYByx;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=Pqd8QaO2;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792228324; x=1792833124;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=UU3pr7YlPujtztfaD5rEaSu3Gsw2VOPeWtM6bSVkPs8=;
	b=fDfiYByxn7BKxdtzcZP0RauvFkLWvt3oaWHOmoJ3kaB3ljcKi5MNUqAsLi+DPEgMD3PlWDOJeeH65
	 mzORubIgvS/ur80grURXjG5BuDfXb01cEqzVSrHJoANR9FWEZeDDTlic61ysbunIMUEUcDJ6bD09CK
	 JEpKmorhpfgSUhAl0tzZb5RnbpjqH6EpUzeyruRHcXbV/n41zqSeAIGPC10+yIOQKMYipBGQyS9/t0
	 HdgePQQ2qINzHz1bAHo4Mbtj2q7+bLxnhM8aXvvyChaXOLnIh6GtmZ6iqpnd+1ggSEzHg2gvN8E91K
	 JlzV9Y8PpeBOWMLTr4UJ1/xi30YI2ig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792228324; x=1792833124;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=UU3pr7YlPujtztfaD5rEaSu3Gsw2VOPeWtM6bSVkPs8=;
	b=Pqd8QaO2poBfgaYIAQczbKMpKMUWowQreCw5yPVWOLhhNPk1Q6AMk9mVYP3opIDkRr5WDGBPPTyYQ
	 UYxBMW0Aw==
X-HalOne-ID: d10c5096-ca0a-11f1-b1da-7d3e33f7de26
Received: from localhost.localdomain (c213-102-77-204.bredband.tele2.se [213.102.77.204])
	by mailrelay1.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id d10c5096-ca0a-11f1-b1da-7d3e33f7de26;
	Sat, 17 Oct 2026 09:12:03 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	vitaly.vul@partner.samsung.com
Subject: Re: Re: [PATCH] mempool: optimize mempool resizing
Date: Sat, 17 Oct 2026 11:08:02 +0200
Message-Id: <20261017090802.1423681-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261014130301.GC15407@lst.de>
References: <20261014130301.GC15407@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 07B0F1C0008
X-Stat-Signature: ndaz5cxofkxb8bhkef37be8ad1o886mx
X-Rspam-User: 
X-HE-Tag: 1792228326-228471
X-HE-Meta: U2FsdGVkX19Ta9j301zy3qYsvz3u6dbkJYAOCmhlDoJpEjALxLO1HtWfSNpiN5wDzf/zyd7BOtuRxKJK4IBNc/a96cI4kyRu+J460mH4vcNtBIISN6tK2Ve68z6N0UbDN4AGjfW2JA3nyDZQsZqMxJB+e0otqAdhy4Ndo6oZQtAv2LrjpA/5EdoxxnBXS3QgLd0L5bXe2Osx2cKbEVg/4jfflPinJtTVog0LQE8esSfry/LwgDg1Uxh+jnK+NOlCp9++nsgJ9w/XvTw6ps8EXamwFXyQrIBFCFOO8ppLCMdcgIzgOvBUkM+JCh7Vuooz4/u4QgfeGzCOKqFwWFLV6IeQhXSjvhCbw/iZIfCfSzGnLoOiLq3vPMLNg5OiaXzNVvR6uSvwokS7tINQ4x/T+ge/zfwx2+TuGEVYWQnfpmJSJJhOTNQjuRlDSQ9xRlZQMpA+YbgKPnaIZlq36HOU3lxJ0bYTQ23cP2FtXlf/JvHC+prVqLQ9S0npawLm/OTYfxLMMuBH4XMDaZVnWTjXePJ0CFOzWa6wJB90ZO94NZbg5ccB+AlGxtc1n/B2ZAZYRdS5sCw9Vb/w1mT/t/8LwqvEiJSsvLdBG9k1VIM5usrgAdV/HjnxLCQ93kYJv5LNiGl/AQabuqxS7J24OEG9cPg/5LTmvyxEpK19dWJk5Z+g9RzhCjusD/yqEUNrk6+h5bZU1v2yV5n+mOm3TRjFUtKLaEfeILQraHLjBFdcMF2ICujt1tI7S1GaC+oh0CF+IywoNSHGMby9YaG6ycW9TMaP08QHodGrT8nlMrVCTWcf1fQOF+vRjrdQVD3xVKXS1bwyDQKPT3MnSVifpXBcn/ZJ/OItRb0au/VSvbF1a6UfckZpwjZ0s8dlsC8Qy3TT6YCS7BzgrImLIQTjc4g8MglUN1NMSehNFas2MfrpQsMASZjCVEbm9O0MMtddpmCrnEFnkkAhGAg0a45z0GE
 DXnjhOCZ
 MftVmCfv/fncvzpRj0Cj1q+tZPqbrM/X4ZUGX40oCN2F+tzXeiwLS3pE0Ps7LQxu14xwCXKL9HPMdSzTp3dO9VzTEKlrLi2SRSP7HuFQbAWZNW7GC62bHMDfmI7ohM4nsWFsn3W70rxc5e+L8B7xF1COD6SKgt9pwG34BjBPCoqupMAI8QxdPo6WOD0ICVue0J/EHqT0YfRRBRVsQZww3nSplqT6PJRrkudWgSEYKfMCHhH7/rICXaxoeyi7bYP2cwFFv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Imagine you have a mempool with 10000 elements, and you have to reduce it to 3000. Then
> > if you at some point want to go back to 10000, you'll end up reallocating the elements

> Who is "we" and where is the code?  This is a highly unusual, not to
> say most like broken usage of mempools.  If you need changes to support
> such a use case you should include a link to the intree user (or bundle
> it with the submission of the new code).

This situation may well happen in the block layer (zoned). The numbers will
be different but they were arbitrarily chosen in the example above anyway.

