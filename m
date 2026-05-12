Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C337BCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B6B6B008A; Tue, 12 May 2026 12:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1226D6B008C; Tue, 12 May 2026 12:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F8D6B0092; Tue, 12 May 2026 12:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E901B6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:55:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93C138D51A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:55:24 +0000 (UTC)
X-FDA: 84759368568.21.E91E804
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB5CC10000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:55:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vdATVuB7;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778604923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0dN4DlT6Bj4xL0vyul4uKH/KmeQHvtJzrS4IxisTag=;
	b=Nimdz9I3mmk2E3xlJ15SmG/IwEEKpKsXN0I/W6Jvm+9f9AOdaBP7kI4bdtjMveux9PEgjw
	jNRa3fYdRI3BLYaBkcipShMPDfXEi8DCmmp1GjdqmpeO+k1qvrg/XZDsvOBgHKqyon0HU4
	/SxIMKgAWbLLJvi27xvwbZFRGRnpcLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778604923; a=rsa-sha256;
	cv=none;
	b=UbSHS8fcR69RetyvwXJMcMTjFA/P5NTMQUvE7bk71PP417wreYEI+r3SE5xyBhiTix1X8B
	Y9S+qZD+j6BrQTLXJXwPlkOBNIrix0vYR8WazdTqB86YWCAXp98xCiRiv1/JWaejHNlcfA
	Z28XBVTpy8nea+jcqhunpGkbVLwLLAs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vdATVuB7;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X0dN4DlT6Bj4xL0vyul4uKH/KmeQHvtJzrS4IxisTag=; b=vdATVuB7XZuJfgFexUCjgdf3Er
	ubnpFFDU209Jzy7e80hwVXdOrjR6fagWVWzT1XjQ7M3vCdKSHlCINuvCz4aSfj+q3xICY88wajRjA
	0FRx8Ne6bBTtNMhHlAWMfuawZVqvHfE8no3jgjzgYt2JSAQfpmzq3LuZbi/rksGSwhKEy5VIcw8iS
	eOGuY7QcEjYpTuc6V3u213rFP9CT5TaCvfhiPcLSH/X4IfxsFOY8GHXPyB7Zq2frDRIYjdUOH6ywE
	LDcT3zPl+cyIXQkMNKWda61fSFte8AAte3oKIUux1gPHDE7BBv8hHUYw6Q4x3iwKF/53QK2lQeSrB
	QJ6S8QOQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMqO4-0000000A1xT-2BEk;
	Tue, 12 May 2026 16:55:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2FB10302F8E; Tue, 12 May 2026 18:55:15 +0200 (CEST)
Date: Tue, 12 May 2026 18:55:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>, Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] cleanup: Remove NULL check from unconditional guards
Message-ID: <20260512165514.GC2677887@noisy.programming.kicks-ass.net>
References: <20260512071510.92451-1-d@ilvokhin.com>
 <20260512124557.GD1889694@noisy.programming.kicks-ass.net>
 <agM7Jekhn3py3sIg@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agM7Jekhn3py3sIg@shell.ilvokhin.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EB5CC10000F
X-Stat-Signature: 5xwhp44sj5e444geh4bkf4jm1o5yf555
X-Rspam-User: 
X-HE-Tag: 1778604921-582721
X-HE-Meta: U2FsdGVkX18BMEEPiXuDXNJSDzK3orVto6UPCs8MvaivzAMUYhTj2G/I02GNJUbrhkInlq4PSjTPQOoF2mXaoXYJlGy7G6kpWO47zjg6kDKNXcKMFR/+HwXJ/+FY1QdcLXcip0Dvqg7D43vTf3YfH8Y+AjtG8LRejBDg5k3cgOE8vscOVlpT89fNZAG63GECNLX9SOFhjd6fVHp2H0t2hXsWbdgckVtgBurLXqMiPC54WBFZRkaOI0ptRXNjPCf6peLqGLEw+Jnc4Mz4fgDgEca4bBv+sAjBK8IQoE1KhVVyw4ju2MJkUI03D22wYCTAmQgGvQopoNCJGc6KGOesBM6Y8N9Ydta+6Lnj4dZ7uTuLtBybtO+vurydlpWxshLB0yJNAeGwFAtWfYZ8/UxzC7/cedloaHDXficNQUoY2nlqlejBy4ndk1WgduMklK8FnRhbWOpgQMa+d5SbL1MvqCZFo5D9lWnxsu/zIBU3cylnjjiUGsLksIw5uxCb4PjhHKizLMhhKO/zYEgWJTMpzwi1f0W5mhWAvTsx7I+OmG+S3YGr0fpNHw/DNXwclxBYW8ScQ+6E1wbYv4wfsp+JkV6Cb57LkJET3SlalruGa8x1qkLU8jYaQbiyh4Dprs21cFhwQxH1plpyfOInh5tmqmST5jR+myX270w7vxKF74VwYdOtgPGvdKGHRjzPUHBehxg6Zk6kw93P0rKPg8XDReFM6XNl7PKDllEhZwUQeoilmH+wiMMrkYvhGfsIZVtxUNKB4QCiSbM6edkkmNv+TOxwLqkgRrXjdskQynYNVKoo+473+jJ0Blnjzws+mrvqskXPAg1XvfDOwax1W1PQXKimqfPceUd0VjX0z1McmwaJqpkgstj/BmFfA9Thz4JwDrZ3xfHfiMf1+Dt28sQYUdw3ximXN/Q/1AbD/U5eZQVXJNB/jDchGLPoVjfAKugXcPxXEUmD8JYaQ0A3chw
 g9L1SRlg
 X0+bniz5JqtfLxgGlldodfaPdREyFjvSAjtcr1VN9KllmDKOETGzHajfTvxswCsVhZ0VHGJ+1pEbqrMRDtwVKCHCkLkLjIiqhmGP3xy1dhlKrDuQWBMqs7aPg90+TNqGrz6aa8QQRGcbvS4lVp3R2+JsUgwnoL3r2YlFGcHybu5rpkuYOdEUVz3SiigWsG96KgVHYIXaW0yGQgEqFgdLIDoWzjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 02:37:25PM +0000, Dmitry Ilvokhin wrote:
> On Tue, May 12, 2026 at 02:45:57PM +0200, Peter Zijlstra wrote:
> > 
> > What about class_irqdesc_lock_constructor() ? AFAICT
> > __irq_get_desc_lock() can return NULL.
> 
> Thanks for taking a look, Peter. Yes, that is actually a very good
> catch.
> 
> For some reason I naively thought __DEFINE_UNLOCK_GUARD() wouldn't be
> used outside of include/linux/cleanup.h, but this is obviously wrong
> assumption. There are cases, where DEFINE_LOCK_GUARD_1() doesn't fit
> callers needs, so __DEFINE_UNLOCK_GUARD() is used directly.
> 
> - kernel/irq/internals.h: the case you pointed out. Can be fixed by
>   moving the NULL check into the irqdesc_lock unlock expression
>   directly.
> 
> - include/linux/tty_port.h: similar use case. NULL check can be moved
>   into tty_port_tty as well, similar to previous case.
> 
> - kernel/sched/sched.h: lock and lock2 shouldn't be NULL at destructor
>   time, since they are dereferenced unconditionally at constructor.
> 
> Below is example how this will look like. Does this look reasonable to
> you, or would you prefer a different approach?

Yeah, I don't mind changing things here, but like I said before, only
after a full audit of every single user ;-)

And yeah, fixing up those things shouldn't be hard, but it needs be
done.

