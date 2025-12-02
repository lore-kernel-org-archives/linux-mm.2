Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2608CD116F3
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 01:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B39D6B008A; Mon,  1 Dec 2025 20:33:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763BB6B008C; Mon,  1 Dec 2025 20:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653226B0092; Mon,  1 Dec 2025 20:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53D216B008A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:33:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B51450CBC
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:33:05 +0000 (UTC)
X-FDA: 84172807530.12.2BCF131
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 84E3DA0006
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:33:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bsb7incI;
	spf=pass (imf15.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764639183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQWHHWcsf1yDrXRN3kfOI9Jd+i+ZWG55FBfyel2UL8c=;
	b=ZXceVlRZdoI4UPX0jUSaMiaxQD8MQlGKfsMxRz1u9Uk5z9xa6It5Qsm6KsXfVfOQ/smi4b
	CFkcf6o8BfZyToEysL2bkJXtOZAJ7hVzz9d6mAroiRr2p+gcJ+JFdmWd4YE4knhUzN46ic
	i46FYIUwF/ivTkf1eFV6ivJ0ydo4pPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764639183; a=rsa-sha256;
	cv=none;
	b=NQkoIxuofdhBrl3ZW6N1YyrQ9JlLikBDfIguQ6HcheXXZ4k/xlNrPxiIi0nIjfOINItF5V
	xi1tgmyLjBE7J9ZsHZMZgubuWH9xKwr057HW0J5qk9jM34tH/zhgo/2lpc3SpORjNQMf/f
	asOGyGegWUgnvaw9QfJG4ZynWempb5U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bsb7incI;
	spf=pass (imf15.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE1966012B;
	Tue,  2 Dec 2025 01:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C379C116C6;
	Tue,  2 Dec 2025 01:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764639182;
	bh=oe4l/S1/X9n/DZSGZd0YfLwRU+TB8ogHEYv9W6fZxDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bsb7incIdQwV+qbtSrzI1R1Lf8ogfLheOc8H0ztMhA0RhnFaShC6xduKsj9g9yOH1
	 Vsv9IVe2mG39vW26gBS+TwZLbBcXVMZD+OCF2gUiE5S207/NKCOa0E5X0pnZWWJoHs
	 3/nF6Qd4zY39/v/CPOrXw4SOihVHe9GUh52r5L2fTqWNyY0+jGPZ4t4903SQTpwoOq
	 wznbIaBikJqPcmTutHBTQSHSXUtfroBY7jtFjHfziILFcNHSFrOeqq6QYWAlh+J/BV
	 MiBQC0a/PkJbRzXCeC9dBaid3nScJUqdw4fYOIyYeyapRz6PWg2Y+YP+nUNsaaVVSp
	 4voBa+5GpvLFg==
Date: Tue, 2 Dec 2025 01:33:01 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm/readahead: add a_ops->ra_folio_order to get a
 desired folio order
Message-ID: <aS5Bzd4jxuDjjCn5@google.com>
References: <20251201210152.909339-1-jaegeuk@kernel.org>
 <20251201210152.909339-4-jaegeuk@kernel.org>
 <aS4GgfzfuYRHJdg_@casper.infradead.org>
 <aS4HmeRgsStngE5v@google.com>
 <aS4K3jGkJErj94R_@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS4K3jGkJErj94R_@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 84E3DA0006
X-Stat-Signature: 1ymqbkg8f3xts61swuw5m9wd7b4b5ukq
X-HE-Tag: 1764639183-740653
X-HE-Meta: U2FsdGVkX1+08NQoSYS5ssEis92vnElgdhfQUPceh8DyzmkwZHvDUw8mVVKWs4ojYv7d3q+GPuISdihwIV36dfLwBpMS6uxvg6sZ3O6u79h6qvdrmJ/19ldnC0elpj8+JR1YKBMN2hNHX/+U4VJky2/tFUCSj4PDawdyPQVC0VLLz3hVZhnILDH8oZVkqQy+qRcjgmdNswxNvpAEScXjFKPaDGZPMhSsBpAoN7Z0vgQQpQ+4qDpPD/q/gt1bbLcEYP0mhFnQe+TJM99a5Kf4j/ru3ZCuxSwl6gCTzeBnL/tMSdwJzlbssLVYb7Q//UVMQ2eAXxEpOfp9+5p4rqMIKFONHPONI2HKAvAbSjEstU2B9OEF4ELb2LqdbhQvWbIX8WAl2JS/w3XM7kVUgHSwDW4x4hr0dkelJx7/w0jEh9Q4yuUqx8maNH8nQgBO68dzHQA7L5No/OI/nffzBVZn4/FwSgpYllTWG3vrraWNGzQKH1+YXyRtbFCO6n9s/9II0VeI9RLOuFBMl/9iq0y+eJ54PNYFwQuawncDag4aVQzUXhTjoOGhouBv5OnZ0lVHnErrBt2YMR8KlcHIduza/KYCkkYomddpU1kZ0STsN8q0Un9h6XMQySENlzzTW3TfnZMTN0DoJqRJ8h7oQyGWUuVE7GeoHw/hDhRwSt/lOD8Ig5aD0qzb1dipfYMLymtFNQnMZF5AqL7g6ffTxGmEjHBvvy6ryP744MuEu9PVGqJ7+RMiKzbseKQex0pfY0iQMr9wjOUgT04O8tQxz58znG1kh/LEE0yfNjKo6XVGG4TCNribHQTWtlvTeYYvTeBRLf7Bq8dOvbcuGFUFFtnWplS7wKyuCCtPed3TRKNZ3lZu33ux+8SnCpW/ibIeq9YWgeOjc7VIlM01cMJDw1MrZW/NqjFzpzHs1jeqqCrq8EpUi8tD1b1poAxCkEbg4ih95R3pNBRTpAGLz1OIJvo
 SkUW1Flk
 j7NMR+IXA4vExjUUzEgBgd/EW/JbOIagQeD3NTcqSf7Wvc7n0rxj+GEZc7ni48E6JFk2Lkw2Mesp8ouQATwzCGtrdrPlrgZMlDLCXwNsOkVmmwM+a0cpyYBIauJ/2+zQRvleBXJ7xPpa2V4T2cky7/uzmNGc/QnzVzAbZewZD1Mrje4yeHazZpxpCz02Fdq52k1AzYr31QCNkCDgGaR5hNlai+7dXQatYikJDNPzfMo26zVXaI4ocEaB1KiWxjV0bDmnMV1pMsgU1h6luo5sSIHtkRjbP2h2FCrrTVsh00hcyH8/p4Aqr46UJwmC5tNzcVu8W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/01, Matthew Wilcox wrote:
> On Mon, Dec 01, 2025 at 09:24:41PM +0000, Jaegeuk Kim wrote:
> > On 12/01, Matthew Wilcox wrote:
> > > On Mon, Dec 01, 2025 at 09:01:26PM +0000, Jaegeuk Kim wrote:
> > > > This patch introduces a new address operation, a_ops->ra_folio_order(), which
> > > > proposes a new folio order based on the adjusted order for page_cache_sync_ra.
> > > > 
> > > > Hence, each filesystem can set the desired minimum order of folio allocation
> > > > when requesting fadvise(POSIX_FADV_WILLNEED).
> > > 
> > > Again, you've said what but not why.  Does the mm code not ramp up the
> > > folio order sufficiently quickly?  What are you trying to accomplish?
> > 
> > That's why I posted a series of the patches to provide more details. Could you
> > please check the last patch in the series to show fadvise() does not increase
> > the folio order?
> > 
> > https://lore.kernel.org/linux-f2fs-devel/20251201210152.909339-5-jaegeuk@kernel.org/T/#u
> 
> So what you're trying to say is that readahead() currently only uses
> order-0 pages and you want it to use larger order pages?  I agree with
> that!  But I don't think this is the way to do it.  We should just use
> larger order allocations, always.  None of this "call the filesystem,
> check a sysfs parameter".  Just use the largest order page that fits.

I got that, and posted v2.

Thanks,

