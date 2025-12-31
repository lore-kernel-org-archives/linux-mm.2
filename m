Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496F1EE57D1
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 06:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B254B6B0089; Wed, 31 Dec 2025 01:30:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8056B008A; Wed, 31 Dec 2025 01:30:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13316B008C; Wed, 31 Dec 2025 01:30:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 931A86B0089
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:30:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3937013B260
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:30:13 +0000 (UTC)
X-FDA: 84278791506.29.CB25D59
Received: from sender4-of-o55.zoho.com (sender4-of-o55.zoho.com [136.143.188.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id 440B340006
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:30:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=TqFH4OyT;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf11.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767162611; a=rsa-sha256;
	cv=pass;
	b=UhkCfT5DRTyDSrCHW+w8Ed+ZnzolO6E5Dqvev9YCtVvfVsUO1/LcDWqfDWLbZLEylveN0k
	V8JETyvwYpjgfBPEu0U6tWSD8LET2LPxyLtFe90DdgJU7U6QrAb5RcuC8RtgRcn7E7ph0J
	XyTf+/UbxMAu3X0Qroode8A8I6wAaS0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=TqFH4OyT;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf11.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767162611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bMTuBTfwdUlXom2vi3ezJLrXtj7KJIJpZH7lSCprK0=;
	b=M5r6dij6TNoZvHjwh6x9IXCqsrKxepQZnu+Kovg1gVWLRNzz4Z/PaMvGFZdHIg47Jj7wLt
	VZlPTrdzL6uhPeLXwHIFKkaUqJAAZHAKQIFNBiZdMgcmUAumE9vFtJTmxys7QqRS/m8LFH
	3Pp1h7v+zoTtTBJg/qEPefB52MmsWJM=
ARC-Seal: i=1; a=rsa-sha256; t=1767162590; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=hrQB5eqSwsTKw3YcGEGvWB/cQYlruo8a7Bmy1dxhxpZlYFIN5wMXnVW3orkfqA5fZs9qbdPekYmm4qM2+WEY9Q2uL0LXKlZe+s5ciARLB6/k02Ahkg1OTe+SsZtZtDe5tCOt4Yjh6vhpcZdiN5iZkrcydZod/0DAs/bOhP7Pdqo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1767162590; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=/bMTuBTfwdUlXom2vi3ezJLrXtj7KJIJpZH7lSCprK0=; 
	b=bUUBgDmBfKeEAtqs9L1s188nZtn6WaJlavnOysN0TNfM2lyZK1MoqLXioLLWsf6RG5guGPtMwHpnab7jkCkUqmfeqeErbqAxnRs0KtxQs36KDMU2osM+WpwrUNBIPre0mzvj70xpCMaUp875maXbbazuDS4awg4disjRJr3TlsY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1767162590;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=/bMTuBTfwdUlXom2vi3ezJLrXtj7KJIJpZH7lSCprK0=;
	b=TqFH4OyTSEMeLvYcaSEH2BfnQVyqO7znegWDLucxWwMaPq5ZrTKPLQwsS0n3TGTH
	gNRGGw+tL8LkN4sUFQOnMuav8xm4XTxL+R5xfBgjQR/7Qwgu4yGabMticBdlbYQMW7H
	7KRtBRojbSwrAk09kN0ouN4IfDveiVFwg+f4PtJk=
Received: by mx.zohomail.com with SMTPS id 1767162588754117.84424966320421;
	Tue, 30 Dec 2025 22:29:48 -0800 (PST)
Message-ID: <b2b99877afef36d9c79777846d19beeb14c81159.camel@mpiricsoftware.com>
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: willy@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dev.jain@arm.com, david@kernel.org, janak@mpiricsoftware.com, 
	shardulsb08@gmail.com, tujinjiang@huawei.com
Date: Wed, 31 Dec 2025 11:59:42 +0530
In-Reply-To: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
MIME-Version: 1.0
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 440B340006
X-Rspamd-Server: rspam10
X-Stat-Signature: pedmhobx3x1fxexoki66jt1w7rnpddqd
X-HE-Tag: 1767162611-549840
X-HE-Meta: U2FsdGVkX1+hGzTJ2cr3Qtjc3UG+1+7cbiMfLR/vXIeE0Sq7iAG5AYgJu1I7wZzyFvsi9Zt+X7KSqioSGWa8kGYompU5lIVZ/SDhRI+iVHCCyuNxbdAhlVC9c60edcRCeIsQJUFfVaoGEinkhZHbt1UOHYdpJNwk0MUpgz4+++hV2TBZVaYwX4hWHL9bhpGu/6vHkdeX+2d6yLwsFY3CatM654gSViPHtKbu7k0lPUq0J+oxRe2f8ij1uVVYYZgFIMeDPLgJqi2jl7O8s88S9QFwIvR8BAziXCPVqU57ggS5hWJqyT4/mt4rjb70u2L8LBR4BrL4N4emJTGORKIaXZSi2Li3EITL03SJqleEYGhp5Q073dzhl2/4SQcKtsuP3PXYqbIrmYAdxPK9aTW0/GCvgNcpONxlGC2mkGsal4z6Dig8e7sJgouPNH3g01v9S+6S5BTTSc/6wSKcpJyqoByy8u2QeBsXbJLbmmnLxIv1ZQgGTa6Cg0bcV3ojelW5UY73yr+KJ9Pwksy1k3YWTJqa1Mayut/NTi2oCIcaVJ4AYgYZjqI++njbmNiSM5GfbwuZrtbukHs3oqr/Wmon29ajL2jdO0sN4MU2vylVpgmxJ5b97Kjpx1F5VQ6YKfUqrwJUEmgniD0L3a6fWUhmdee89EGMjaXJT2Ujxy7Fs1JCtMCe56ILlStBAK7Bt1iLBn09rgNPDGBIEbdfIG6LoikM6sJ8Ot8WzY9OZOj5UqH8SW4459Re/r7GWdDcDboz4n6zNAb10T5HHNEhKjpyM+fB/UHfC3/ye06l9BYhvZmK0tLoo02GjGynCVWEJZvUUoG9jnjskqNbd1OSJHagXosHm8pJnCBrMak4ea5D/spCT72ShikZQQooN4LHmEaZd/770tqlTfBNpz5ZX03S5Zm/I9jZQPIYh4wTD6iemiwzjWL+igeHcbfH2tw7uZcpUNV0p6lmzs7D2Q0h9Zl
 gpWHn5rB
 +i0CcfqSkCwQ4tQjoPQtOZRAjBaiOg6qUiUc/ICJxbA0oOCaut0p8SIjT0+K7j0V4BhNOBlSufYR2Hrl3ZABZggCB5soDAjC2KQt5T2IlDRvAp5/yttJqxl8Z+GXbjvb6M9pMp3Xr3eRJi1IuhzdAcTEtvDnkn44Z1rWM+QxmLuSSbcWCIkxLLPnZnzfIIlA29Drn8m9T54Q1jvEEoYMyo+NZivrjXBwUQ4YwcWTbIoyf+kuP5niD4XwteoeistxP8EQP/mMEZ3xPSOYbqMsO82JXvi87xEPTIjBMheu7itcUZoUbgTPIxCPCBixwzMZJQN6YXUs9nKgR5pDATd1ZH6QQdRZanAN01Ackp50ZGFb1O844cgMmOE9SCDyI9/lZWAkAnyk+4DY3V13m1gKqjkjTS/Zdndfj7Y+ylzrSDutITcpUH45a1CqqOFuBTZVxoQ3QR04zR0fwscJJj2Pux3moqHfZ88M/wVKHfXqjLGZe7Eg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew, Andrew,

Just a gentle ping on this one.

v4 has a Reviewed-by from David, and Dev and Jinjiang both followed up
with additional observations and ideas for related cleanups. As far as
I
can see, there are no outstanding objections to the current xas_nomem()
/
xas_create_range() spare-node fix.

If this looks good to you, could it be queued for inclusion via
whichever
tree you think is appropriate?

The separate question that Jinjiang raised about empty xa_nodes
installed
by xas_create_range() but never populated is being discussed in its own
bug-report thread here:
=20
https://lore.kernel.org/all/86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com=
/

Once this patch is accepted/taken, I plan to follow up with a small
cleanup
patch that simplifies the label usage in xas_create_range() along the
lines
David suggested.

Thanks,
Shardul



