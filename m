Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573F9CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A0A8E0008; Wed, 15 Oct 2025 03:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B098E0002; Wed, 15 Oct 2025 03:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5208C8E0008; Wed, 15 Oct 2025 03:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5818E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:28:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBC951DD8C1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:28:06 +0000 (UTC)
X-FDA: 83999519772.23.B0B1F9C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf17.hostedemail.com (Postfix) with ESMTP id EA9B540005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:28:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760513285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxTz/CsBtqGwOsVkfT39u2/dSwl7+hBRN939OMGuCVA=;
	b=BOY5v+3iaHLQ0aOHaRdnZ1E1hVvrwoBNXcdNgP7PjsRe1eGkyTtuTJj1R/bNf1Q8IFPLgZ
	86uUZipInJQCe+0AY9dff/AkiMq2uyhnWAuBAnbNSdCu6B1zNINsZ3j8PIHaqJAqujhM9M
	TaECvQebY0AOBOjJrJSezMBTd9CVEVQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760513285; a=rsa-sha256;
	cv=none;
	b=motPKwzS5LjkXWbaRbCfnq/9ZloV5+NcSSQDllQewrLyD8lEH3FF/Vnt+f5laSS5XwjEoL
	s46JjWeQgQ/eK94EK/aI5E7KqnZyR9GgWaHBqZrggt8nigcfkh6aIV9I034ebHNKfTK/Zz
	0IbzNvzLpMLKZ9Wq2TtGgQByxpoEejk=
Received: by verein.lst.de (Postfix, from userid 2407)
	id D75E5227A88; Wed, 15 Oct 2025 09:27:58 +0200 (CEST)
Date: Wed, 15 Oct 2025 09:27:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <20251015072758.GA11224@lst.de>
References: <20251015062728.60104-1-hch@lst.de> <20251015062728.60104-3-hch@lst.de> <a1671515-4aec-46a0-aff0-75ea8540394c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1671515-4aec-46a0-aff0-75ea8540394c@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: EA9B540005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: j3ipfcn5nebgbgw3dyjb4fsxnsowhknf
X-HE-Tag: 1760513284-689414
X-HE-Meta: U2FsdGVkX1+7dWCauTaicxfwTQelyDY0gg/pZ4F0edWuk5QeHWznqUzkuu+t/Bgv9+FCNXSee2l1AKG6MpE8iYwZ82C1oahiueF0zlPTipbCP/osWpVUPWExJxTAW4xpJ0GAHP8ImNzHAZ3CJaKiJ8aXakzDoLREE8o4+6QD3panu7NZsk095yuAHc8lkXcYnQI/95+L35saUS5SdODKjIwBXvuu83gK4/e2co5IEkGalsQPoZ6Ll3zvFChGzM2bvCWIQu96gqV+9O3r8dBwLX96M6Wm7A/37V34IMt2GEIfahI45ON3HABFMOQa7rRoRss4SUb+AyAmcsClPN8J6SwkG+7SscWxmg3Nj1vbBJD17KND/Ign6mNIYWkw1OZDJJx4WvPUIHIh43zgBMq1SAuE68fiM5FHtibBMlUDm+jM4LK25rrmn6b/VUE9pJuPlpLpMQuQAKPMc57gnkd/8GXZEZz/EFqK4grMMVWikGu+4xN/7mYYwv4PD6YA3rgCZRvpVywZpVQlCUrK5faEjNdhZo0J0mxChtHurKRTKJ5iDs3ot3Zg2ykzQPh+pU+dsCpqIfabd7++s7hd4u3hPclLkf319wpHLN2eOkedrOjzQEHwiZFsHTWM/sO404rfkcXlLs31UBFG6jpCX8gIoLO0KfNfcBh88SGgXxKs+oQBaEyKS32idZ1U3Q9WFN5FTYR6tow2zvJ09G4rdBMpD5AsOyqhTmVCdEoy3SaNBC7ov6jyMzj5QpHGA28agULD4nEMyEDiicKnnGr8zfYQaX12gA6WyUlwn+Z7kSpdS83tBrrTcW6xhVmVvtSRiFD5IJGKtJCl7A+oWA0qS5NN0hjxJrHsNgr0ALuGby3ao5ttDUDpTEq2BSovT3iBa9pkGAETSH4XdGv6hb+Haz9318zz7sJlDJcAlSRIquKACzIavpzWp8VDOuv/Ym1R62OVMHXZywJCY1kWBsyR+Bh
 I3NLv09W
 TLlcc+KI7GdWh6piyc9tiPXn4WTHlaRENqOJmNkCOmmuZjlz69+yUcO0tB7rg9xBs5uNtUDQ67A7EODdEs+K+fXbs0x4lUXDYzOrRx6cUpG4oT85cpYhlfiy7rfql4+3eALKsjbm7h8UteUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 04:09:13PM +0900, Damien Le Moal wrote:
> > +	unsigned int		s_min_writeback_pages;
> 
> Given that writeback_chunk_size() returns a long type, maybe this should be a long ?

Not that it currently matters much, but yes for consistency this should
be a long.


