Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 689E9FA0C2D
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3C8C6B0092; Wed, 15 Apr 2026 01:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDE46B0093; Wed, 15 Apr 2026 01:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03696B0095; Wed, 15 Apr 2026 01:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABA456B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:44:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6749D13A89F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:44:16 +0000 (UTC)
X-FDA: 84659699712.15.A576C5D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf30.hostedemail.com (Postfix) with ESMTP id 65E4C80008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:44:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776231854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=12kEJKMEAKDFWxj9hNE2aGvJCeI8OywtIK0vKhWxsiY=;
	b=LBKK9wFTAIzZnFX3YMWFWvruKDGPajoXLf2w1gAL6GmcInYN7KLOIA+knWDAAr3W2C+E6P
	V9NqpF755+Lpr+74hrhCNIW1VWO2xkcGmPaN/aMQ8LEJJ+WtkqVKOupoBkau9dIuH/wexR
	xr4VtPnBazT5+GV7mBhvvRut3uWv3eM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776231854; a=rsa-sha256;
	cv=none;
	b=0b0ox9UT8M1nRyxLJj7BbuAAZhrlVb9AfdHl1N/AkT/gIFDNEQ54MJ2YXFEuIzhBEAo4QF
	mn4wMjFTiFlhA/3tEmGlZKkg1SXanVtNTwUdew71iXX+PtHOp88/edhEdlaYgBIoga1mUl
	K/iSAk3pAPV1ZbxGrGN2/j2creSdpUo=
Received: by verein.lst.de (Postfix, from userid 2407)
	id B147B68C4E; Wed, 15 Apr 2026 07:44:07 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:44:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <20260415054407.GA26893@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-5-hch@lst.de> <adgJqiA0vivaW7NA@casper.infradead.org> <20260410061725.GA24667@lst.de> <adj6iibxNot-yc9X@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adj6iibxNot-yc9X@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 65E4C80008
X-Stat-Signature: ujfgjcncznhu6xwtmiar5e3jd9hx4swx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776231854-762905
X-HE-Meta: U2FsdGVkX1+aPb+lDLf16vvSir8gYpZ7lJhzDTAhzAQa56Eww4df/IMY+32F82X9a4+JwNaec1QuqZjClh7Hc71UhZ3YwyWS/nhGjiZ0fjkXEz/ZkKc5IIpbx3g8t9nnuZv7o+OgR2BvGaWibhGJd0r2I2yKlbmHhCsr9XTeTSn4Hi6973J6PIf8I4JNZFtHFQtBjgROIOvsCTGZQtmSx14lxwEHBe74cVn78gp0j1FQQX7lwP2bvqBb3vwRnbwhoM8Its2KKz6mjy3G/VjOwCHibJz05pnTXQrTqvbCB+sKDgXljuOIRSG2fOJuvgQYlhI/B27AutR/R/De6s3bLqh0uWbpde/VAAtr23Dm4sC4194fY5Oyop7A2rUEpND2vthZ3p9wSNhU4hynj34a6pYdIS+F1DTp2xL5Ag6RBO9IppbQjIxdTABopqFO9L9Nme2L2XtiNaBgInxssy1PG8Gnyuixi5EETuZ0jSRIeYkDQYSeZjJZMKqpSEj5n2uDk2iF7AvaXwC949FCIS7AHxJ+iCrZHjGdLMbl1afFPkR7gTXC+A91Xd9xjBzwyYcAFwcBL9KG69DYwR5wCCM8JbIDHwsIbiHfOVXIAr4KKpSqR+hTYOm+xLqsCmzhawfRXaFbrYBn9hbfDmkXcN72fhIfOsuRiQEbdzXyTT5UZWvHv1UgNWofens/7fIXbEBgGeNDRxpobertmJYJK5LHqtRdAHDAwuD6QVrMldG2bExSeZR+feDxdT6kDm1Pi1cOOaZzFali/tk9lUSTot6+hIdvCcKb87AgwSC4AiBKrV2mxKbkxpYjJRoUCixQEnhwtn98ancVIqe/nHc/AGYZVB+vo/m7oC6LHscHPBk/1yoz5eTkT162ZNPizeoTTYfdVTCHrdvJAMmHC1SM4sIfeIaERqQ9kQjDK5Y8WUfnlKXpRurkuupwcNINv8RIupmqpvYf5/5NFF2zA2PTLlA
 yMt0ZPqy
 DqZz41cnXii6FlczykULiKAg7jUUf4F6FFc5fKXPFyS4/FSEo3mVOzoNlic9zHu5TmJsUU+zGpd720at6Rm7UX/q52hy3b+V4Ih97
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 02:26:34PM +0100, Matthew Wilcox wrote:
> > Yes.  On the other hand we can actually use it when we don't know if
> > we need to offload beforehand, which enabls the two later conversions
> > and probably more.
> 
> I don't understand why we need to remove _this_ way to defer completions
> to take context in order to _add_ the ability to defer completions
> inside the bi_end_io handler.

I don't need to, but we'd better have very strong reasons for two ways
to do the same thing, and I don't really see it here.  But I can give it
a try if the consensus is that we want to way to do it, and we're not
worried about people getting the bio-flag one wrong as we could set it
from ->bi_end_io, but it would not do anything.

