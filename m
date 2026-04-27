Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 654FFFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817CF6B0096; Mon, 27 Apr 2026 07:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8866B0098; Mon, 27 Apr 2026 07:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE006B0099; Mon, 27 Apr 2026 07:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C63C6B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:45:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE43F40160
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:45:48 +0000 (UTC)
X-FDA: 84704156376.29.B4999A7
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9E2F1C0011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:45:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iHi8rR0v;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+M1KQXm9cTJLaAfF9FOZeFcLRTdU3LqFAA6GrfogYkw=;
	b=V5NkZ2zrTGvkjm7XCU3BhyVJ31EY5Y1ZFUw6a6/ShoJFFWtsfDilY+eQ82nzaNBVSalOuo
	ILN87xyRVV227yaDnu4RH79Ni6TAJbe6EoKP29W+kfvdJmeaLhM0MolbMR8/VceLOwGYWU
	E6VCZX9nLlVpWc0Liz3T8lNLKgxmICI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290347; a=rsa-sha256;
	cv=none;
	b=LZPDp1ESPqeTxMb7wgRG9O+9z8GpFfdJGNOlZntmETpx/0/jmEbxRr4vvTXehPoOFYNHf2
	RiwyvV6PawAprmCWcxN8sjaOKs5Ut1aXy6Goq/22ecf2/AOvIyIAvvxXAsV64UQDLTy9Y+
	P0MiX5/ppI2Ty/Xf+v0jjxxbNXeAuy4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iHi8rR0v;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <9cecea5d-9377-4d90-97c3-0cd8b2f77b35@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777290344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+M1KQXm9cTJLaAfF9FOZeFcLRTdU3LqFAA6GrfogYkw=;
	b=iHi8rR0vDXtZFHsT6lOVhst7I0ZOGkfIYhr53aX9M4N4VZPbsH6wsUzplHNXY1dgjin9Aa
	iP7SYILOzzGaUaPa0WnSxfREI4HcnKpFCN6k21LOk/Vh5W5jIqOZQfR6O0ppusPG7EqNw5
	0pEKCtvdPe9Sks9l8+CWt1iDGG7EXHg=
Date: Mon, 27 Apr 2026 12:45:39 +0100
MIME-Version: 1.0
Subject: Re: Large memory allocations at LSF/MM
To: Kiryl Shutsemau <kas@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
References: <aepANOFKoA4jn8NN@casper.infradead.org>
 <6cc83a53-4392-4925-9187-d682b60edea8@arm.com>
 <ae9AHWvXUTuoqlfA@thinkstation>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ae9AHWvXUTuoqlfA@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E9E2F1C0011
X-Rspam-User: 
X-Stat-Signature: mgxrx8wsxdj99na1xtuxe6cmjm7dnws1
X-HE-Tag: 1777290346-458941
X-HE-Meta: U2FsdGVkX1+y4y/Z45J2458FXunPbpWRD7RuT58d1dVI6ywKVau3YtyMsJG7yRXaVDcj/LGRCbiWt8k06l/KPjEKEhA0voe8inTRXwt8w6kF/Zi+DDPcOHQqIdqcOv8F/cOd10BqgrG1eoFvXe2u/ctng62ZFuD7D7GBxm/x3xbhGu8LHgSqWpA7in2xP+RtTSo+j3zqfY6aIWPsGebmjheZRMLkBieE2qbKuyLHXlF/qTfV8InKqgirmvepR8zktnJbTLkmAKatA0lKpBaHEjGwgKbNZNEdAp1XFvKyrUNUwXDPkvcc40YDrcnIR32j5+RYs268CcyOC11yGkMISDbldM2mZGxHiF71is4LEs+RuWPgzfusXNAkmAVt7VrCZRvvX/R8MDmJXD9YTLsKC+2qZ8mP87BtasDeYAoSrieLvqHNyzsgXYpDGL62cr60zBtpOcLgN+pVRrLAYmpZOx8h2va6oVx3GisTL2RVqqTFkTZ86W3eduannUxanEkJSTWoC1HcLcjNdtoiQ8Lcxk8JGAPxCLXfvcCFAdSUMWSrfq/qbn+ForLqScsZzv9sSdvmSF+xUKFrdklzbED3T1R8sCKwfzfL/leAasVqGEXpGjXllU36HQ2gFRiuSYgLfgyeG9SjLJFyNGviMQIzT6Z7H90Kf6SXxDcm4GK3cs/pNrzk7gbhEeN18aoQUTY0xyHbYJc0bnTCP2V73HUOykO3N/UOYLmp+hcrZmIdu1aicrZjlNkofbRQg1uVwua3AeqY1EVRJfduTM7CknS/c1kRUxmEDJCQYLQiaQVguRROeq7zhaS5+TnVhX8xJLB5EJmUZTh2oPqa56phG2Up873UwEX+zeXhVz/93z/pSgyU4nTqztXnVnscuoZqMnmbmEuJ9dEtG3ssVx47oEpdx2tCbb6Y8FOe8SNIEn4DCMTW5B6BOnxER7+Z4iFFQ0/12VQUnwhm/B6Wf50GfCF
 QwnHA7g+
 8eRySFrQs5Ou0B2laWrRoDc5zUCVWtLU3ab7rPrruq4pn6zRxtt2AGsmDfeYT6lbI+MDDfmMuaZs4dXEUr52FWGdzVL5UNMBw4R1rz210yXGD2uH6Zm4PSO1cr6T6ixFgKQ3lFl5qdZEHzy2sp5CZmqmqn5JvxG1Gq0XWQ4B9As7bo3Zl59na2SI8hnI0vXGJoUrLc6oQvq7iYOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/04/2026 11:58, Kiryl Shutsemau wrote:
> On Mon, Apr 27, 2026 at 11:46:51AM +0100, Ryan Roberts wrote:
>> On 23/04/2026 16:52, Matthew Wilcox wrote:
>>> We've had far too many proposals for the MM track this year.  In an
>>> effort to squeeze in as many topics as possible, I've currently
>>> scheduled your three talks into a 1 hour timeslot.  I think there's a
>>> fair amount of overlap between the topics and we probably can get a
>>> decent amount of conversation going here.
>>>
>>> If you feel you need the full half hour each, let me know and I'll
>>> try to come up with some other way to squeeze something in.
>>>
>>
>> Thanks for squeezing this in and sorry for the slow response. Yes I can make it
>> work in 20 mins.
> 
> +1. We can continue discussion outside of the session if needed.
> 

Good for me as well. Thanks for organizing!


