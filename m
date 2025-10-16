Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3645CCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 04:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940368E0003; Thu, 16 Oct 2025 00:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917758E0002; Thu, 16 Oct 2025 00:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854E28E0003; Thu, 16 Oct 2025 00:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 755AE8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:40:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0791B56C9B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:40:07 +0000 (UTC)
X-FDA: 84002725254.16.7C34C80
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf26.hostedemail.com (Postfix) with ESMTP id 41B5F140011
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:40:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760589605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IGu4B6i6lZ5uoanEkR6444y6uwGd+D+P8YbVRH+XEnA=;
	b=xEpV7tC1L4jf0ZMmMaCwIH2a6yh0vMk7kdlqBrLsIIA6Qof1KqjhVlSpSbBqS0KzXLyZfY
	yLaIAf7z7dcBwTboRA4KbvB03P5ACOjnoW7koogaWPNmjJnpIJW74TzD9Veg/JmcrdyCOQ
	0cdapSF+N1jLfiAGnV2z2qVRrJaCFJc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760589605; a=rsa-sha256;
	cv=none;
	b=fpCqLAkPAK/0rEDPRzfR/UHBqa1xzeOV3ZpHIRz26/IoL5+Nv+7tiC+zKJRQU2QzHs9VCa
	K4S1nrxCmjf6PXwTbXfjk4LkwrH/3296ZY2OaxcO35CEPjSVac0P+L+cFy46IdlFwH8jY4
	9LuQliNs8IyCu6SDrfQry6D0kQhwzfc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66F11227A87; Thu, 16 Oct 2025 06:39:59 +0200 (CEST)
Date: Thu, 16 Oct 2025 06:39:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <20251016043958.GC29905@lst.de>
References: <20251015062728.60104-1-hch@lst.de> <20251015062728.60104-3-hch@lst.de> <aPAI0C23NqiON4Uv@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPAI0C23NqiON4Uv@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41B5F140011
X-Stat-Signature: 8qy4kezf5chth48tq3bf7iq3c6hcwtaa
X-Rspam-User: 
X-HE-Tag: 1760589605-350417
X-HE-Meta: U2FsdGVkX18oUtKHEHDmjlkqP8v6lU+u/MbHt+Nh/QrTWZFwpSbc/sQf4FrIHR6HN8clBqZH79WMf9Gss7u7zeBJtNGB+W0o9BYBYHXgy/1P9cc2TLm6kqipDsPKxU1BLj82Mem5TKkEYlTCBlCquYEGWemlPI0LGBn5RbKtgN+zBtK3rSN39TDa/H7QTkLPpv/i5/NMi+cx/KeODUAWWy3RODjh8Dm8Rj+7kwrmJwndHzvlOBwICF7pn3x+i8QUajtVbWW+Bb8ju1tXg/YU/QOb+JBIdfylr9A0aketlNF9NXELUv5LI7CwfPw0cK5f0hVqJTWIjekvYlOGBRuSdCa4CIrVGbf15K8+PBPwttL7q1vBfFmI3TWYSBsRV+lXLctPBLrOFFkkuhNwNtmaNsS7XYXr1wMIUx5wmVFQron82VtqYy56aOuznjE+j4WZZsLQy8TdJ6fhAzrei8F7Zas6JNLI0NqbJ/RhyFnVbs/V85JxrT4Nau1IhGS4PQS+g6VttrbyIvlnBGJYdcDivO0vT8vsOC+mLgt+bj+jvNid2n7nVoevS3PLdD0wvnwpzJQ6xGLjQaXSwFF8bdTVCvN3E3M7h0zYU+NvobprRb9BpjFtBji0yoZOVO0SXlwLUqrYKwYlAi0Nph5Q6mcsTNTPoNNT1lpX1byPf7UoqHgvdXeLzah0sWj2Nv3CancJaR3YkdOqZJuBoVhmy3s/MXvojLgHhw/SP4e1ErcmaI+9SjR9FHCi6Kfx9gCE+apL4KSfbchcsqLHAhVl6NKrrotoM+ccP4KC100P7ctbUGclENbPryJp2jHY2yVrHc3DlH3n1YccHlEXegMP3AZjvy3jFrA6YI5+OuBiVHkRAZYopFUWFfIgQpFTemIXECoapkWDpHXRi0e/NnxepfOlRQ7pum4o1YqlY6qp8q7C6657aJzQiDRlAmu3zunsYgflePuHD2H51h19gw8VriR
 GDH59ofU
 kR/axlz76/mloBOVWOCLRnZ/xLq+49j/aNScKt5Y6Na+Nv6I8LTYv9nA3ngG30didC2NEJH56IOu/ZMSImREJ1BgzhwErHZuIT4PpJNpitDG5mgei/qHlRxrb8Rk86uPaohNvJUNmTo/DUVohBV9H5YOWxx8NUf/K3JOPGJKyDbn9wrmjzc1ac8rCrpH6zsvqVGE4vc+BLIvyCJA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 07:49:20AM +1100, Dave Chinner wrote:
> On Wed, Oct 15, 2025 at 03:27:15PM +0900, Christoph Hellwig wrote:
> > The relatively low minimal writeback size of 4MiB leads means that
> > written back inodes on rotational media are switched a lot.  Besides
> > introducing additional seeks, this also can lead to extreme file
> > fragmentation on zoned devices when a lot of files are cached relative
> > to the available writeback bandwidth.
> > 
> > Add a superblock field that allows the file system to override the
> > default size.
> 
> Hmmm - won't changing this for the zoned rtdev also change behaviour
> for writeback on the data device?  i.e. upping the minimum for the
> normal data device on XFS will mean writeback bandwidth sharing is a
> lot less "fair" and higher latency when we have a mix of different
> file sizes than it currently is...

In theory it is.  In practice with a zoned file system the main device
is:

  a) typically only used for metadata
  b) a fast SSD when not actually on the same device

So I think these concerns are valid, but not really worth replacing the
simple superblock field with a method to query the value.  But I'll write
a comment documenting these assumptions as that is useful for future
readers of the code.

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
---end quoted text---

