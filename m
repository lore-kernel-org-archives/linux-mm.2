Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23EFED637A7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 20:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847906B0088; Tue, 16 Dec 2025 15:34:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804986B0089; Tue, 16 Dec 2025 15:34:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744546B008A; Tue, 16 Dec 2025 15:34:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6364D6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:34:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24CE55AE58
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:34:53 +0000 (UTC)
X-FDA: 84226488066.15.CE69E16
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D45B18000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:34:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l9KoJa0y;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765917291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gpc6Uoat12G6CeOjQa+hU2d/ZT3lQcHMBgRvZ7BzJY=;
	b=rZehpcAYytVReeIinCWGsNx2phu9cH3Qe0cQxGsmKAIym59LRnrU8GrnSR3E+L3T6SmiMQ
	vJSkcb43K2nScdnckv5cQL9Rfn4c8K6K3x2fr4mrL41v8tJFb4D2j2R4UWcC6ud1LkD6th
	7wc12MKSpcdl4j0owoq02wLGkhaqpaE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l9KoJa0y;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765917291; a=rsa-sha256;
	cv=none;
	b=z+pT9RZWrZNogxSZKTD5fJQoU04WOirxx818akLEt87yIA3/6D0oUcokACJ+k8l8ixDJN8
	RcETRrmd2d+lWX7UARIQQwjMqHtiUzpdzeZqNTwv1B8GhqHkzRWDCg9CL6EWABPi0W6+9s
	TVHDPAoQx6V6xqTt2/aeo/3edkByxAA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3gpc6Uoat12G6CeOjQa+hU2d/ZT3lQcHMBgRvZ7BzJY=; b=l9KoJa0yZy7ZasWi/OXNxWNXmz
	df36BRAvU962fvAs34ZHEFjTntyDM7m7voN2aAj0LO5dBvPv44w53WyFp0N8LAccZiC5lTTLHuplK
	RXi2ixtnB3X6q5FdVn2Xzczd9jlWEIVflA6PDoOKIVISn1lXooltJBhimj9Dq+oD78icqfmy/M77N
	FpqvLzbypeJYm8ziVZPdhQPfM09/KrqCRTADwKHtoBwTwQYULSxAK6htT7yc5fQwiFM0/62iebTuV
	1trGiS2SxOo0+vC0oOop2HSoXYXjsrh7Ztyzw9ANI20Bf1rDSSJUhObZI+zNJhHLl/UffTGYzzxE7
	boZ+O3Og==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVbks-00000003lA3-2Gl7;
	Tue, 16 Dec 2025 20:34:46 +0000
Date: Tue, 16 Dec 2025 20:34:46 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Francois Dugast <francois.dugast@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm/migrate: Add migrate_device_split_page
Message-ID: <aUHCZpnTNqv8wfdc@casper.infradead.org>
References: <20251216201206.1660899-1-francois.dugast@intel.com>
 <20251216201206.1660899-2-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216201206.1660899-2-francois.dugast@intel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D45B18000C
X-Stat-Signature: iak4ergu3xegxnofqmsd5hi4fnr3iz3s
X-Rspam-User: 
X-HE-Tag: 1765917290-157537
X-HE-Meta: U2FsdGVkX18GcsgeP3RsHmPeXDEzhxOGfqk/fHljQ8SBXLcAx2lmlf/TY9XCYE9P1cv4P4c9dAVpTEhlaV0o7pGyvhC6sZvANphYE/DtqnoHm3eq9PrJxoQBhfQYtfmqrvbHJUaCi5eJ7So8NpfrjUhhbKUAODG4F9lJNAgGwC91uTqEd6NB8K9BljftpDHDcdfd3LMTzTGMj7tGAhPHtUFqbVmhObuOVBDV5zBZ9y//y1Tf4xBJyl0RWEmcsWEYHPG/G1uRTTJsN8/sr7zZoH22z8wvayZv9JXKRKN2zMsSea/PE+VrZk9kaVJfuktba8AJSxYxTi5Sc6CohDHpW/lGEHbxI6efeIY4tV3RtS6C5x+KnEIuhzjHiYiMIE9g2bTcatFhzLprtkvIgmi4Eg//l0XCdnfNiwz1nvq4fIYwl6E0HuGDun0tNoN8gz5ORU5EbCLNRoXDU+4k9BDxYdN44XwRVvKJaKmQwbMQCXon5l8XYQ4NXpc7e61qqbSnQYhooVg+y3LzzfUEOXrU8X0cCuz95BUnqqQGNvH/RPZlKvzH7BSMCEMzSCQuY6dkLzVJ4DuSpFGm4WabLt31tpfnUJSrouEow//H9NJorWXZyLXQM3qdnF+Ccy5mNFzA5z5EB7g1PIt6Fd64PyNP8CPYrrPYFz9dz/AosEq1DXfLKkinWoIM+PEx8MviHhr7erPS1mlOMDNqJfMevGDuQxglDvHwJ53KUwDxehPeqHKRY6UbioKdzYzG3MoNkbRW7VeEJy+3EYeeObr9hL+Ac32ZMeVf2jt/mGz8TCcisS0iB0oYH16t5jmwy37nhq2sL/K5T+0IGjQdHbole1XbdssSaOP7433l8rW3TEBaV4wt38jVMi2d5lk72QaubpKwDhLoqpKG/lZEShUgFtRYjMSQBQ3LEqAc6HW2eiRqPooq3kUktWSuIDtsf9Px/aywumtGd0sDC8HIh6SfTc5
 Byp5750n
 v7DM8MiGzLSElLKApfMjbCPRt44UTtFH6ewFGmvY+Tph+EZbbijaeYY4GJn6jnh8T3CLgjrbxdK1P84W3CaPkhgRDf4TnmrgDUWoLTD/1u8gZGDWuCYlSQVDl1SwdXdDzwxY31Y2WxHvOs1HCUiSL3PvGSWUlnL9lPwCC43lGW7kIsmwI293kdRNjgXv7LXIgaZ1ro1aKPF4oHeAKrqorN2EBTeTPycJXWP4zkeZDKPXTSvqchsIbK3ow+ykBNSuA5U2eVSO2xCi+XQmNCAsimmWfQystTNWIkC/pUpCFQAl5QeQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 09:10:11PM +0100, Francois Dugast wrote:
> +	ret = __split_unmapped_folio(folio, 0, page, NULL, NULL, SPLIT_TYPE_UNIFORM);

We're trying to get rid of uniform splits.  Why do you need this to be
uniform?

