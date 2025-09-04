Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BB70CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 23:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA19E8E0006; Thu,  4 Sep 2025 19:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78228E0003; Thu,  4 Sep 2025 19:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC618E0006; Thu,  4 Sep 2025 19:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A012E8E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:47:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 120DF1DD5A8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:47:14 +0000 (UTC)
X-FDA: 83853206388.22.FDD7613
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4E37A40008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:47:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PZ5Q9uHb;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757029632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OB79J9OkzW9PQ4wTsToiX0t9gI13FhERYOzkV/zoaA=;
	b=SJDdJxXy+vKP/ln4tZWG3DJo/+5DvyJIq4OY30nQsfso633Y8O/KM/aqzxRVsF8L8a13Az
	+ffS0ZwjLo6TfPAlr8LqpS9I3gdcVGRSOeI1lhqP4C51RjvrYjtrWAKoHoMFUeZYb+YJP9
	HuPmgDp4AQtRfCNmcT1gh2m3BvXDWs8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757029632; a=rsa-sha256;
	cv=none;
	b=XKcoI8sJzOo7kVU8lVz0j4LoNAXY1rNAK9tSc6PSTAbi2PkD1lLz8qCRUzuVm1fvEDqSwr
	isRnx69MeSMVC3tHSRX3LLZBa9a+qToi78YJGBBhykjXsYSfblM+agiUW9WGaqX0gbPDWe
	efv0D9fp8g+B0W/2akZaZV37blDAMcA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PZ5Q9uHb;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3472544133;
	Thu,  4 Sep 2025 23:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8FAC4CEF0;
	Thu,  4 Sep 2025 23:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757029631;
	bh=wBY61Eq9TrYmzEriZktQvbsr92drztU25kt7n6mRRO0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PZ5Q9uHbUhKuZcOxdhN8wKAybQx/ha0k6QUz9jeOmyL9u5PkrnGxfRfnpj/7h2CWx
	 j0NUem97OttUtPfXr+ohp2wBfl499zuHANfI3yD8bhB8zFf4rJ6kfQevz2nTKgbTqP
	 7fNJXc79mEDQBbuFHCI7vWMe5aVFj4j7V2zMfVlo=
Date: Thu, 4 Sep 2025 16:47:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: hannes@cmpxchg.org, linux-kernel@vger.kernel.org, Vlastimil Babka
 <vbabka@suse.cz>, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-Id: <20250904164710.210731847fe25d9419203886@linux-foundation.org>
In-Reply-To: <20250904093325.2768507-1-vitaly.wool@konsulko.se>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
	<20250904093325.2768507-1-vitaly.wool@konsulko.se>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E37A40008
X-Stat-Signature: 8bd6yx1g8pemer6gd8h18cfpnwqo4x6b
X-HE-Tag: 1757029632-640959
X-HE-Meta: U2FsdGVkX19bhBqjb6x1IENy/0sUhRHL5c+tIg3R2W21nltYlMtvzS5mDy9cUDsBARTaKSW20MJsbJogextQOKcuzSjdqf4MFqK0ChUOk+SspgqvwnhiTHuIXGZU7ckEiilR/GZEuEvQDUvC5+aw+OfZ9SzCPJwnAtFzu1FQy3/qEdbIxLLNhc8NToiMeIOOea0cLpSxySn74+Q6Lc+EScIbeTUdAWqenLzAyHxskFI0zoGNdzmydGD0NF+mnsjonntXJ3q44et04J4rgvBnk3CLU9HxemgyGTl5NTQZ4BuHVkRCsFTDcSOeP+/H+FYvnfJIN2nbPEezHczHDy1GvtZjtMBZAACIUcIgDesFuan0KbiuDjaUM3FgONndQcOyCaT5k531DAvTc9MOtpRsHe9StUGHb5aU0P8MOgvBBeXYKBbJpMDpT8/R11hBAfV7QEfYuikI9k0cXnIgP5tuwp18gI3s7L7Y8jjp0t6nzAkc4XnDZ4hJJZYqHP4zCEfbo7xmMlLM6PImg9pjKudR/nLdNbzeNCkIy2Dw/nkADRJXzNQIJqe8U4K5tdrheW4UM+z+mTuMX95SzA3JcNTBRo9kiziHvf/P9rgGcHYpleBJIEr/jIoW4i29txc1CFOOPqR4CJK6XF44EfwRwKgEZ5+e9Rf2iMy8PkCAV1PygfxzTtZCM/bhj7aZ0UCMwZ9ta4rOo8mRuRGfyw3lQH46f+Wk+anoEvNqmgNdw9i5huz6xEPOnQ9e48IYGtMYdLCSTvHeNAwM6R7H5Fjs0aBI3sdx6yDEt+Jb1SY6UmBhQInkzhcBaiTSOVnQwxDzmstYZHkp3EEB2vSHwf8IlaHBDE7jAb9qDDuSTiFwRNZFesb5u/HNkWpqEMmmt8u6AS2NbFCDMBj+fn2LaYNawbYtegHTGfuql7cu+a8M8aeMiTbFmxtJZnqLa9FD3qzrZPAIqtNDRvFSzqVJdioFQP4
 kMWXUs63
 z709McYEU9HcvvQ6MCmfL2qbvlSEeDxCFodyRlvAUdFo31oYljD5BySmDu7uoNYqxGSMLwsnfGCAzHR2izhjR6d/+HVQDofJcywbjBlBl/0nxtxB1ImSD1FBciM13r80oyX6AAsNWxMgLDezjFSRr9JCyQcp3nHyewXmojBN5UBWStrRekeOSwdF9o/QIvxC4D6q/QztUc3L2zG7wcKrGoiDWJi4I+3Y+T1Hv4k5LaTXfsknupluiW6CBIWg6p8HIthzzDRs+IXWrNAdmniOyBI0/x7j386fYo5O+DIjrMRSOWEZgeXgZP9Kd5bjTUXWhXAEmhZkRmEG8Rsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  4 Sep 2025 11:33:24 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:

> > With zswap using zsmalloc directly, there are no more in-tree users of
> > this code. Remove it.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Per the previous discussions, this gets a *NACK* from my side. There is
> hardly anything _technical_ preventing new in-tree users of zpool API.
> zpool API is neutral and well-defined, I don’t see *any* good reason for
> it to be phased out.

Well, we have the zpool code and we know it works.  If a later need for
the zpool layer is demonstrated then we can unremove the code at that
time.


