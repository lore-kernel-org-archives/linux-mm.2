Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B456CCD6E45
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F20106B0116; Wed, 27 May 2026 11:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7F56B0118; Wed, 27 May 2026 11:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DD56B0119; Wed, 27 May 2026 11:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFC136B0116
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:39:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65EC7161B95
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:39:16 +0000 (UTC)
X-FDA: 84813608712.22.08CB931
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BDF2A1C000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:39:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2y8R2Hx;
	spf=pass (imf20.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779896354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tkayxaFR4WgUW5KlUVQBv4QvmTLYma6soAnDSL6BSE=;
	b=OqjtX/ENX2I3fK+b6T+qgOWunTCwOx63buPmKhs2zGoyQ+cw3t6zoz65SKQkEUpDnHFlHN
	UGgorW90f8rZ+AIlv12pSBQ+VlOSkcJVIBPMZP7DpEgjE+r9PCc3DkGLoF7fRigIJ++LC+
	kpunxkw/C57U1WjAimb0Dg6Abd00Idk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779896354; a=rsa-sha256;
	cv=none;
	b=IEMPxRLR0GcZqd++bjpg0l7PC22yi2qo4/hWKYNXyx0ghLyNlvMoS+qGIIyZtcZ7G2DKO2
	Wi6e/nRFuEZtDYQ35yxk5p3wCqf4iz7n2qCKIMCxbPFyIKWQFf+xKVHmHk2YAJ0e7XoOMc
	zmJinoqhlqNOXAP4emC14tJVOSaZFyw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2y8R2Hx;
	spf=pass (imf20.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DD2C43D3E;
	Wed, 27 May 2026 15:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F2C1F000E9;
	Wed, 27 May 2026 15:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779896353;
	bh=8tkayxaFR4WgUW5KlUVQBv4QvmTLYma6soAnDSL6BSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E2y8R2Hxn+xhvIjIcnHlTfkDkts7bsT+888M6AM9G1ambnFnv5F78FJW9QyRGRGyP
	 +aRJbaNxmsBPyVau+poW6nye8T7/U+loHiVz5VLG0NH4eQqPZIVTpQ6MnJ1nmjSCWj
	 REKXR2KOVHvb+ByZMnVAoWwowF6BgkNVf1mi6MbU6kSzNmdLk/YmtmMC3CRSUdEHBa
	 nHMONcPUwmFcN6IGk5LJmqKzzuAntrUhs2W2KFTt4tyMGx1pcLaoVfm8bCs67yMBHr
	 vilgqZaylNQsNnN73f7k0Z9EdAh0x0eeghvPX2zls+ciDqu/sdJd1KO1MDHLsw/DV4
	 ugSTcps09ILXQ==
Date: Wed, 27 May 2026 15:39:11 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahcQHziLARSzFtar@google.com>
References: <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <ahYWKH9-ybDlZuJd@google.com>
 <psj3kr2gcze2yll5xdbvyyzxwcwhds5gh55poobpkfxrkpbgr7@ljdindismzd4>
 <ahZaScMpx19ZLQi4@google.com>
 <ahZlbQPzTUecMKGU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahZlbQPzTUecMKGU@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: BDF2A1C000A
X-Stat-Signature: 59nwswpetomxsdreo1oqphnsebe8egcn
X-Rspamd-Server: rspam06
X-HE-Tag: 1779896354-684692
X-HE-Meta: U2FsdGVkX19cS8Gbwkp1HDlqy+r/TmOZGT4DldkpuehqeyGBDu2P6nbl45CFcfabd+RjVTmFLqgXe/H4NPQMyjBV9tkOA++wU5v8V/5xAN01Q38yr/M/r7MO1NJxzQYMs/bBKQfMsvgLi1ZZJS6sc6toEFuKUOkvKP1ZC3bgP9snBsUp3D9wG55udWpXjtIruxKd4+8TfP9PmTPJV3kT96z66GrHTyi6G0K+K9Fw42OIvxkpoMMfXC+zOMacz0KghICeG5tjTOufpOgcHnsE0/7QOWpZiIsWZoqHDzJhqWT9PKnaTjvqsGoGy7wMyhd6c7K7Nzvq4/cDumA4aNbzllyOzEcNvEnE/tA+fP+AuKXjiPMkU2vweLmpwbpKGSAkpEBkb+KDnyu8gtS6d0r82gF5ZCvzNbIEzsPW8hlD6NB9cch6YfZmbG4dPcdV2jqFVk8yNiXWM1QwbfsAkxXfVuUqrqQICDqXTlH9n3Z4mq5rWB18sUSt+8FZgUP5sdZrucAUsBf/jTR5SkLmG2Bi36+9I6I5dFkS0bA8hAxyckSzA9r//XU94cUDxp5P1A+bmDxfORAuKloasK2JMXII4eFRW4lGxOTC+vbOLRMtyNWGj8jOP2NH645/MAL+ugS79Qdq7fhkFNfypkOsVAwqy6iWzBBDeU9GFM60jcvDK9rusw6RzgelJqpI54B6dHYNBdiYCTfWuJ3qEbVqforTGefFM7wjcQmtf+FBqxumMgIzdsYc1g9L9vl5O8uunXpmANcLgv5PTb9hm+6q+YcT2XWNumwtyhMU89Hdtj+G8TVTESGiIi9rEaksgeD3X8JF5/Hle+09TzWvn7bDADZizOm3driEKuj2HjQJRMiSNUnFD+4eL0Z9m2J2madpPZDOaybePfaO2MJU5OyDiBPjV8iCkBiGG3wz48g0EnOqBHUka891bk/m0j4JBEOmLpdmywF3wCuFymPnhK3wa8j
 DXfnpHSD
 /6H+YYWpwgpcTw6BRjCzdmUFW9tl4/CM630jFTc5YhHuqcotRJ/s7KII6L3SnUDvjVxc79q6E9jFBjDCDu8cK72KreZ1+vxUUIZpFOtTZYudtO6VJIwM2PI4xJtdp/6KFYwpC3zScK3XlAmU73YA8QXIQ+PPpwXWNASh8F9XkghFr09XyVBceOvI/yANkvCVdJ4ACXFqD73Cd1LVFRTOZLKEjQRtZNE1zKsaOgG+/25T46t/r2a6MnBLjYCk5WWvBlTP2Ih9oti1+PD3SjK/OHF72UJS7DBGtaFzC+fxa/fvOxVx8X8Nim0bixw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/27, Matthew Wilcox wrote:
> On Wed, May 27, 2026 at 02:43:21AM +0000, Jaegeuk Kim wrote:
> > Thanks for the context. To clarify a piece I missed earlier: the model pages
> > are also utilized for inference. Our data shows that larger chunks yield
> > higher inference speeds. Consequently, I required high-order pages to optimize
> > both read throughput and inference latency. I will halt my current efforts
> > and wait for alternative suggestions.
> 
> I think your efforts would be best directed towards general support for
> large folios in f2fs.  There's still 40+ places in f2fs that use a
> struct page, and converting them all to folios would be a great help.

Ok, I'll dive into it in priority, but it'll take some time since I think we'd
better to refactor some major data structures.

> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

