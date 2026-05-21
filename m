Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C8BCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439EB6B0088; Thu, 21 May 2026 02:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB7F6B008A; Thu, 21 May 2026 02:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301566B008C; Thu, 21 May 2026 02:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7376B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:46:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCD24120523
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:46:42 +0000 (UTC)
X-FDA: 84790493844.18.B653183
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id 751171A0005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:46:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qpgOdekCAW0L5aWvHR2Dto+qKMc9AuKXDEpvsS8BAkg=;
	b=dEpLERI0hZzyEYcdfs/OywAtnOJECMeoYJ8kqgs5ebVJw5SbHHRyjJ0L14oGudI4V7ndTc
	YS7g9V9UXKqNhC70Z90pNjkTc7OxeS8j1BjpUf2H6CgeuQeoLnZK/t9HQyQI0/dLIZMkMZ
	fHsqOfxYrxHiqiPKtxxwnnZFtpU+OsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346001; a=rsa-sha256;
	cv=none;
	b=kkvIkcBcHyvZh4bzQUaHuCTpY4WPRXtaJxndqCN35MP/SLqSlDHGRQ/6AH+JlbcA9uWuyG
	SoEXv1WBh8rvj1Dh2AJDh0tlQxCTn6aHIBkSaNNKmv1yOUNNOISljYlz29FgTt13D5JxKT
	b9mEOW3HP/cjdCUALMAITuC6eBuG+I8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 May 2026 15:46:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 21 May 2026 15:46:37 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org
Subject: Re: [RFC PATCH 1/2] mm: swap: add SWAP_FLAG_SKIP_ZERO_CHECK to skip
 zero-filled page check
Message-ID: <ag6qTZulqiyukHAj@yjaykim-PowerEdge-T330>
References: <20260518073455.2495934-1-youngjun.park@lge.com>
 <20260518073455.2495934-2-youngjun.park@lge.com>
 <agwDnPXJSDIjGkpC@infradead.org>
 <agwMcxlf91I1ZzFU@yjaykim-PowerEdge-T330>
 <agwq6UY_4E9VjMMb@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agwq6UY_4E9VjMMb@infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 751171A0005
X-Rspam-User: 
X-Stat-Signature: onuni5derc8wrzr48rf6qoj41nws9pgm
X-HE-Tag: 1779346000-833355
X-HE-Meta: U2FsdGVkX1+ALSGLXs5nTRR/vflFmnsEMk1JXEno0tCp/hbR6mIAeppdYA05aKJUDTYcyHsfzsIoghGv8LWQpscBkHtd6ZeVWDOJfCEiA1lfx/vrieSeCUVIcsQQMZL9jD55ZGRJsHz80SDuOWtqi1bPx1rA+l/hnDos9m5JG82v6Bx1VSacYjhJqucAuMaVAd94Pxfl8dhLAUesHGL7EOIUAEegLwngNcCjerNcpkIT7z5sl1+VMvdK5mojbRjBkvff7ZKeHuitB0EhXeeuwInfecQ9uOaby7PXDQxc3PO7QA4D9sMaJV7WtI5e2fepPS+tmGqAzkHBDEkUUFO1DLfv7tX7FV6cOvc0a/aj21FZj19lB1jo2tZdV0WjT3RfPlS2CprT7tPu631g9zcMTejeW1V+THeTOS1xFs/J3tdRPNEPbcuc6nDIoLdbG3Zlb/ZDgkNvfGp3wJCny6qsiI+tg6/T5i3+eEQHe9BDKtp3l3QsM34JVwpi/gJ3JJHxTkdaVchI/+y7kpPQxKhbL5t/NPdh4QxyP1Zt3KR+ZVLGrn6muzx5RyJImjhgxC1CAN7GZ4dWL661hRJy3A/aiEAktFPVKS+BYJ43CYQqqgeqLPofcoQmK2YkSC3YwXFUgklERKgYBWbqE3ih5ETz541b4PEMFbNo/X1MVqLA08qwC9l3cSV48oPLyxe+V3tWoyTsoPXlBGIriltKSByJMuz+fCN2lBaURoq+/Pp7UOsrPmK9j1bIhnOAL8pYiNIiu5wFPAkU2LG/ZBfuyHk80uYYCDlSaVJJzfmbhOA+ZUmU7GhXMkRWMkzzXjSn+pcqpNdgVUzWi0hVRRRCccJMwlhA84YaOUGnQKRaO2h3oL3kgsSVFccN8gCpnKXsu/NPvvwUShLcGk9k6LdodaazLLlzVkLxrPdOtxHUrEGYmMSv+2886HqyVNsxNVXKyvh0lPcbBvZkzTPPnO1itDB
 Am/bbjFZ
 amLQ9CZVKsUKN1YXCTcgwWMwLAjg6bKWZtyyHH5Mh8RBrqMBePpo4GXqj8JfvaDafC8/piwcW2DlpLsuBVjdfOlJeI3SRpcmf38tsQY2CBZJeAABJiykJs7kErrRKRyKV8yyBaXKT0mpdhRx8bCBrqVCrT55m23hNex1u8I2g83wGObK1/6xF8t9nCBat3shKz5zebsLKcozsy/TajPXl6PuPuqIp9qte3fdOtqYMf8wVoigT9h2hlMLJVDSYBpUyYm3eHY0OL/ZTpP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 02:18:33AM -0700, Christoph Hellwig wrote:
> On Tue, May 19, 2026 at 04:08:35PM +0900, YoungJun Park wrote:
> > On Mon, May 18, 2026 at 11:30:52PM -0700, Christoph Hellwig wrote:
> > 
> > Hi Christoph! 
> > 
> > > Nothing in this patch ever sets the new flag.  And I'd rather not
> > 
> > I defined a new flag that can be set at swapon timing. Is your concern
> > that there is no mention of the user-space flag setting part?
> 
> Heh.  My main concert was that I assumed it's a kernel-only flag as
> SWAP_FLAG_* aren't defined in a uapi header.  But now that I know
> that they are user passed flag, my concern is that this is not something
> that should be exposed to the user because it is a depply internal
> implementation detail.
> 
> > 
> > > add new weird bdev hooks for zram when we really need to consolidate
> > > the compressed swap logic in the core swap code.
> >  
> > Are you mentioning we consolidate the same data pattern logic (including
> > compressed swap) into the core swap code?
> 
> That is the plan based on my understanding of the LSF/MM session.
> 
> > I am curious about what direction you have in mind. I can think of three
> > possible approaches.
> > 
> > - Handle it in individual devices
> > 
> > Can be optimized for each device. Currently, the swap layer
> > handles zero pages but not same data patterns, causing a mismatch. My
> > patch aims to resolve this. If we prefer this direction, we could even
> > remove the zero page check from the swap layer and let individual swap
> > devices handle it.
> 
> I don't think devices should care about this at all.  compression and
> dedup is core functionality that does not depend on the underlying
> device.
> 
> > I wonder which direction you are considering.
> 
> Please look at all the ongoing discussions on the linux-mm list.

I submitted this patch from the perspective of optimizing the current state,
but I see that it might not align with the future direction.

Thank you for the reply and clarification.

Best regards,
Youngjun Park

