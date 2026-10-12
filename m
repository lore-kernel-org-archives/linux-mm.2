Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 744A1CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 09:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2553E6B008A; Mon, 12 Oct 2026 05:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C3A6B008C; Mon, 12 Oct 2026 05:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A256B0092; Mon, 12 Oct 2026 05:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5C146B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:58:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53AB3140A6A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:58:37 +0000 (UTC)
X-FDA: 85313524674.20.D8964B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A8BA520002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:58:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGoIpRNF;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791799115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkoyxlI4OiMEMuywtpfFKclHTWhgbqKFjNw6JB8CL60=;
	b=ZOddvnPBHA5RW4Tl+7otu+NqsQqoPaup+pkMZ5YRk/3gklUYl+rMyTDueg1UOIKCOCooBa
	8u+GA67tJW8JbNb/MvSnlYEQA9U+B8s6mXAOGAnISY63ubv1374fgT9LhmC6r00NqjQm9X
	kpJz7iiN6Cgjf8J988YSwfdROIuU5QU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791799115;
	b=nHLeDumjqg9f0zOyjfj+y0HqxyLaxxsf2MP5mxzSwLnlafOqhBLFLYGzuZnGYj0IAlTLr8
	4wKqw9gYmJSdrhahy8vOa4IfYJ364bmq9eRIZGXEfcR/GTvaA85Fm+hGU+ec9DdisiVJGT
	OL8QjkB+f8ZOGV2GeakShy/ZUsfm4Sk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGoIpRNF;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A6AB2436CB;
	Mon, 12 Oct 2026 09:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476AD1F0089B;
	Mon, 12 Oct 2026 09:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791799114;
	bh=PkoyxlI4OiMEMuywtpfFKclHTWhgbqKFjNw6JB8CL60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dGoIpRNFt+CuDVxJ2uPyA5Hm5mmzrTstTL3R/lTmqs/mwOAv1a4wDDB/B9fib5UTg
	 NFZAzE5HstfDmiT0uSfPqdqYdnFzbzSim7tGTbaUybo3oC10gZq+Q5zPl/ra8hvyNJ
	 qz7KupSPg2UBSGAC2pp4vjKpMKNRlaTDcognvs1oJM/SWG4y3nHcfuebKTjkysSf9s
	 gmP+cmYIkzJRU624MiSzRMwNx2wNzpBFw3VkpovfxbAIuPSQXvtIi7hwjG7JLCcTPA
	 bYArA0r63mJjYTuYMZaQDi2vOsz4h2SIklx1qZbSVTdHe4vUw9LFs3IqbseL4ABC4b
	 yetxWYM3nR1YA==
Date: Mon, 12 Oct 2026 10:58:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ivy Lopez <skunkolee@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	fvdl@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/cma: fix list_insert_sorted() ordering
Message-ID: <asyvPcMxeH9kyU3S@gremlin>
References: <20261011003059.169430-1-skunkolee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011003059.169430-1-skunkolee@gmail.com>
X-Rspamd-Queue-Id: A8BA520002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u88ku5zaqfyi6dqzs4p6irkqftu5hz6m
X-HE-Tag: 1791799115-771855
X-HE-Meta: U2FsdGVkX1/XIzO3qc8NiD9ypSJ9AUfxgJSYgSxb87PcZAo/m4TYJEnTeAlfiFjzp3ECc82cfSinhWoEnrDPVormZD8CkApm0+0PnfZkVWom+HGv2O+ynKneDv0LnEaCqMo8CUs+9g5A75W1S5rayI2ZO+I9O98PAIMaf2GguakO3cWub4dQdDZGnqwHPh+ueJbe5oaLT/3J07QjhJzyPy0CZoD++StRzLAylOYRGoedmMBhDGnlaeez0Ve60JFrBajlPpxAMtEImee+0qRMfuMHeZTDD4Obhot+ZSEplTPfF40xoRPs4BNp1YSupdAhvNWta2VRutDtXnM/t4xZYWY3Tk2OOKjTibYgt1EUSJ/si1NQp3Q3yNWF5CXIkImK4B0y/T2G1wTHg6fftN97rAUJ0jKjlbtiKmodJhKC32SMTrIlMYBRPNsoqLqGL9xPXh/qbEl/kVz/1dw5bubP5TR47YYHw8wob1WMMqvI424lve6gIVhwjid/ZEsVHDQjDzMBwKfWm+f+xlK0ly9CA2qwgL1PsPU/EcdsbCzkdqukROYDrCVdMXG9XyXVrhcyl14RdSnmlVOhLLTuSQUexOa+h4qKB1H5nkP+1tQdmdD/vYVuzgjullrXXHLVIUJp+r8ubjcZ3Z7G8R8QMjBsgbxCqjOYwcIk7OefBEpK8gYwJxAqGmDBGEmdW8x4Zq83c0WCH6s4P44EoBGjQ8UorKs1ohaxZ1nmp4lRavlyWk5Xbnhgx2p4nE9EVnX86Pfq+ks8feo9mB3kksdILJv58hAhOQhDy+uSB6XhkUUUnfvPFn0BAiDedIYSdvItUAFtesVDQ0szA/pQ8suYulgno48aOFTHiwbyMuf3f1M3CbeaQUC+HB6YdT5GVxcQCynVoTpsKdJ1HYpWREl1IpkWwfgYgbkhQfX388SM6IOU2YhGcwph/40QU03oS9t1GHjbLYQ9veOYC5E4+g28ENl
 zhTOC4MF
 CUT+dtKBjN9l/lSF9fITDJpN+FrEp5YOwisdJVaLka70GRE7p1HEbonniCWsTuEoskzNhCpYbm6K9flmU1f2lIrR0eREwnW8Gp+RNkuq64nLQKl0fcCVyxlPMZyowTIy/3C7v82G+Al7fN9DIx5aNM7RyArrFwng6Uie1oceDiHGuHB6vdBKc+tF/ppf8jDbkSxXOtA+4xpuSYtHBfq/XUuR9P8N+FstmHeWcOZjDKAOC2fQm9UT1iN7vghicsmlui+BXEX8FAtD+kiVpVLCX6nyUXxR13N0DmtT0sFLCwd603at58Nwrnp+OD49xYXO9VKv7pMUrVPVfdKKsZEw7lGQovmOvfJ5Y0AaY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Please send patch series of two patches or greater with a cover letter,
with each email sent in-reply-to the cover letter.

The easiest way of accomplishing this (+ our preference) is to use
b4 [0], otherwise format patches like this:

$ git format-patch --cover-letter --thread ...

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

-- 
Cheers, Lorenzo

