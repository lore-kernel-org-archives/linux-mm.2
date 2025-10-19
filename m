Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01DEDCCD193
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 00:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4ED8E0005; Sat, 18 Oct 2025 20:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC178E0002; Sat, 18 Oct 2025 20:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9318E0005; Sat, 18 Oct 2025 20:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F00A8E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:32:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D047C59609
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 00:32:08 +0000 (UTC)
X-FDA: 84012986736.19.45E55B0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6CD3C140008
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 00:32:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZmqW0tBY
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760833927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDwpCJk3xs4cweUC7JTSnq7g+gl/B04N8QtBpC33QWU=;
	b=JAFR0ykoYLhipRhIr7Gz/WXfC8K/HtGWIFzjTsV3C0xvvOI4FGR2NsOaJvn4Mpi+2EnXtc
	thnU0QY2mNFn5u9GiyQbQPTurznYMEMclK7Fh8TH3KEqsW/4NtSxuf0vA3nJ/m92RhW18v
	y7Zp9s5RV6V2UX3/mNhKQQDK3zyZpwo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZmqW0tBY;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760833927; a=rsa-sha256;
	cv=none;
	b=p5aKhfoRN8b4BsZkMGIbyszPc7E5iGPZaatXtqBIQTNXGCesK8vyw0A2gzlkiswaHup6dv
	XbOPKLafkQURNdg7PPySNmzCDkG0IDfMFn1jKdCdIgRxDz0WAfQLKgPZKQphONEUZ+QXde
	co/0i+Qe/x+l0U4rZauu+Je4ZmQs7dA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bDwpCJk3xs4cweUC7JTSnq7g+gl/B04N8QtBpC33QWU=; b=ZmqW0tBYLxzSCCUm7Qcs3VwJwB
	aXLfR1zJzPtROayNES+PAMWAiz5Ee8NvuDzRYfAPoP9Hi7WKSeCM+CQGOdZ6Omwr3roXI/Gted7nM
	j2e4xm9k8uqo6eDwelETHOX50BLZRWD+0bKcJf1T4ydiNp+yZS01iKqa3h2c73cbT4k9FjFEv5La1
	euGydgCCSzfRZpe1TX2LQZLhJUg7qnHDxCAC2tPSQdaqo5/BOfk2BAoPYw9ZjGPgjvWPP9ozotE9R
	RqhWBUVaRrKtrBg0+f0Zfyru5RV2n4Rfgnzwm4ny41AUHB3SwNbbFXQnXMtXf0ORFQfbexMXdlhCT
	524gkQYQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAHLA-00000000ZsS-1go6;
	Sun, 19 Oct 2025 00:32:04 +0000
Date: Sun, 19 Oct 2025 01:32:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Huiwen He <hehuiwen@kylinos.cn>, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>
Subject: Re: [PATCH] maple_tree: Fix potential NULL pointer dereference if
 mas_pop_node() fails
Message-ID: <aPQxhMH0CSZm86Lk@casper.infradead.org>
References: <20251018152305.1612722-1-hehuiwen@kylinos.cn>
 <9092f8af-72d9-472e-8d5c-f950c8ce782d@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9092f8af-72d9-472e-8d5c-f950c8ce782d@web.de>
X-Stat-Signature: 3q77pt1pxrruy6ztd1p9z5k7qzuaf8ri
X-Rspamd-Queue-Id: 6CD3C140008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760833927-307478
X-HE-Meta: U2FsdGVkX1+Gx2m2x6ah2A/E8jEsbT4ALJ8PGFPiWw1aZfY6GUVCoC9hURkWS3JAXepPtKTaROPOGGa24NaIYivobxlCSedwsjnf1Uk3yKX4bUREZhpGxsbCUldPa9YdHYRme8LzLhz9bbPtNH5/6j4L944ehZzes/kseu2TNXDe7dZjgBUmPoheV/wY4Zhmo+shflNMl9jb1BhO1/qd5jrmLi5PjcfMbhp613o0OcrLx4etjtrKohH1ebUH4Ue+eGJbIu7yBtwwUCidcbQsz5tiSZOcCri44BauM3gLoZiBCXsYEQ1DmswWaT3MXCsBM5cbb1k74mr3sfL4ODm0nkJj8X+JnfmULbWTMnIP78j2P6FJ9xSFaKZfvfUzRG3KbRkN8Y/DJ/qOludaJmOHfAsHek41fJRr2bQ9dRXjKqeczlxnuMq/wG+JZCCYWL9eOBvds05uWa3ev901i/zdNJpHJv0vWhUkZ9wTYe4RWs0PZhx/Vk5xpmYquksytyu/ioYD8AxhcUgb4ohFBOOuqDbVIyN9s7m4R2Y3bNaVUH0XcOJb7jCVJCu0AIBmoMukeZs6oMa5mlao9NetTG4oT853+4Q99k6rMAWzyuOnwF1rejW+6wWJvq01dIDPhH9HaVDf1bARslo8ZWU6ivnj+P7opuymZxOdz/VHYy3PwtuuWLARK1vmcEgK1Ns5XH6595UgWOO5yu/9Bxt8gAGAD+L9gdgGUGWhfgS8NL646rCi9F4A4GyspAZotqsna5bXSiTCF3C1IK+WG39eZzsXAphGiVS5sAZ/E2wN6RUCY5v24eYgzQA7aGXTE1nFt2HZKw39A+Bh0BMAZrs9HGadT92uDVJf3roTIM3Fd+eaVs6HU2NFvrdP895vPAMKg4Jc59/HjSmH1ShlpLi2K8+QtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 06:38:11PM +0200, Markus Elfring wrote:
> > mas_pop_node() may return NULL when memory allocation fails or when
> > mas->sheaf is invalid. Several callers of mas_pop_node() did not check
> > the return value and directly dereferenced the pointer, which could
> > lead to a NULL pointer dereference and kernel crash.
> 
> Will another imperative wording approach become more helpful for an improved
> change description?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.18-rc1#n94

Markus, stop this.  You've been told before.

