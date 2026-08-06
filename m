Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66205C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A16C6B008A; Thu,  6 Aug 2026 01:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678DC6B0092; Thu,  6 Aug 2026 01:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6CA6B0093; Thu,  6 Aug 2026 01:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 389B76B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:22:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB06F140661
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:22:46 +0000 (UTC)
X-FDA: 85069699932.21.AE55478
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9221A40008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:22:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ELVTXSo2;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785993765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dFMFOnT/CSCQ1DHkJmapIfczGhzuoh3MCdpoEXCJwY=;
	b=f280g++q9OsuJOoac/eYA1aRrCqNH7rncrFjHwgmTMJB0SOvEqeGs1BoljaOTqSHto1FmQ
	Laj8Xz5lfYxTlhhixcw89QNhJqVAjZspKHxEJ0Zs/EQ9vSW5mQavBKGMF1BtEhviq/j7jC
	IjF3PTvleImsDbpP1+bmUtreLur9t04=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ELVTXSo2;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785993765;
	b=O24wbdcsvXa8BxGBloxsiCDKQNuOGHL85k8wbzlFUvJgdV/0rUw9mL6dW7OfYb+FFIjEf7
	L0vBvQSdtp7JEJ/UuwKVd4cZEZNK/alzkoGF1oqXE+oZauG5oq5ZdRB+echQH1k4DFbvf1
	HPI4b+LCBZvwSX8WmbzqST9ALXg+CV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6B634364E;
	Thu,  6 Aug 2026 05:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B041F00A3A;
	Thu,  6 Aug 2026 05:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785993763;
	bh=3dFMFOnT/CSCQ1DHkJmapIfczGhzuoh3MCdpoEXCJwY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ELVTXSo2OjiYl/fr3qqB9hrBh9PrK+dW4oDHcPnfVGK6Z9oKelFvcNQWIOor8XwO6
	 n7ZFbLEKfFosCG/7Hz8lfUB9lZnZm8orlm+2NI/uJ8MM4yuM8AvunX4dCTwRZe0wUd
	 9tkiq1w4VvkB9EV0I1km/T6mvyAH2DS00oSDaSMg=
Date: Wed, 5 Aug 2026 22:22:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Juan Yescas <jyescas@google.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, open list
 <linux-kernel@vger.kernel.org>, "open list:MEMORY MANAGEMENT - CORE"
 <linux-mm@kvack.org>, android-mm@google.com, ljs@kernel.org,
 fvdl@google.com, tkjos@google.com, minchan@google.com, dskiba@google.com
Subject: Re: [RFC PATCH v2 00/16] Page Alloc Hogger
Message-Id: <20260805222242.13f1f24fe95cbf13292a01c3@linux-foundation.org>
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ynmp5m5rhiu5iyqy9upnpz7qwhyrocbs
X-Rspamd-Queue-Id: 9221A40008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785993764-542491
X-HE-Meta: U2FsdGVkX18MAU7hW5UYZ7d+1C01oeLc5UIUX1xl4bcNPxvUWL6NBiYgSdl+97r0pfT0hnJlysP7xOftdGqr5XqbEAJ5jDawFuCctvJ9SF3uEUf7LF5Be8tC5T98Iav7S1vtYASCc0hmRoISONUKJZzg5a9tAhNspGP/jB71VUTLurynuSKqOy2fAuKx9dOg7UQw2QpxCj8avoQ2xNcJn1rVrJNs+oNqvUOkroAa7TAI3xBbubXBOTMYeEKzx8VK3TUwXMuFSTAQRt6J1nuisrqvRE+QY32w7ZSZf2hAmAs/JarNc2cwmJYr1uU/52GehkKl663T5SayJd91SGPS4tkWID0CDsaQks25PrT7WkVRYldVATXMTwZeMoSuBROdSt93QlWT3EX3LfQFImuNg8Dc57frOKniTuBokf9cvrEWJxFiIdJ0ub6B+mCJ9G+rkP9+SbmqzGODjgaWY28q/G9sIBw8gPLFpBkUNzEuAeTrMj1FNjxsdVKUieVYkKObbtkc1Pppku5XjswWfIRHdz+js0HbN+0CFLTxz0GoJtXpSa0EuxSrP446SbQeVYd2EsqY0kNRtMUgli5V/cyC6bpbNxdw4Am8bymwEWskjuN8vgct5Tt4tBaVvi832BQLgqFGLZBD4PNBTEHaebj13IimKtKn812vK2fVFwOzIxNW62CqgQrgONdOmSnTa0PD6vEqkdG/b3nkUDs+4AVGC5QKS1rsRMjX/ReiUUOV7gtPtBZKGoTDe6WU2p6kOHjRmtrco5qzJSnelQI034UIlRsVMGlfTrEEGpFDVlM6ttG2UWftNDhmMbeY9Oi3G+8UxVkdMS0ek57BAyKZQJ4P3czOS32RykwZCabT/zM4k+LshZwZr1k+IUsfLkTvCAXzaTz1/SGnreyHUu3V9cmCXpXP4eQQTiFKaEDRvKghWnINN+uznjcU1Q/B5pjPDXrD8GqqOCqodawAgHdtdxp
 bHkNK0B7
 FuNGFbYyopY8BgKCmouYBhrj/KIYA5bhA6UJ9vu6P72XHv8QH68dSGGuoV8nO4WCsfVWJ7fIUBuQINoCsML4Q7XlgE/xytt8QwGotVc0wvpB7NVqo08IlifhhcXqt+C91bNeGnPAPwSi5CdSTyJ3EOg7jfCRh7FFM3Q2NM1c4T87T8y14doCnNOb+ripfHzwD1NgWZUmzc1TqBMMwoqWE0JaXe9PL2K2KwhvzgASiWXVfRt3/rt/T2AfjPyW8KUwI9yXTgbnuzz7+IX2xcTOWAwjncSD9+7aJjhNFsJDVoL/Ezeutgn/nmtPJV3kIiMfobm/Nzbd1lYX7vosGzjTDe6sAixVoXu3TGiKDgRrrXn1InwbHRsLwyOIW37QVJFfCuLzl2MrfmQs3MVGpBO1SGbumpgn1d5T3iSNj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  5 Aug 2026 18:09:01 -0700 Juan Yescas <jyescas@google.com> wrote:

> This patch series introduces the Page Alloc Hogger. The Page Alloc Hogger
> allows you to allocate memory pages from specific nodes, zones, migration
> types, and orders directly via debugfs. This provides key benefits for
> testing and debugging:

OK, so this is targeted at kernel developers.  And they may indeed find
it useful.  I see value in us developing a common way for developers to
apply well-targeted stress to MM.


Probably everyone has their own favorite memory stresstest suite.  Most
of these will be in userspace[*] but I see there is merit in doing it
in-kernel.  Any perspective you can add to this choice would be
interesting?


Some usage scenarioizing would help.  Is this being used within google?
If so, for what purpose and with what results?  Sell it to us - help
your audience understand what benefit it offers to them.


If this proposal has legs then we should Document/ it separately - that
big block comment in page_alloc_hogger.c will become unweildy.


One could consider plumbing this into selftests/ in some fashion, but I
wouldn't encourage that - longrunning torture tests aren't appropriate
for selftests, which are nice and snappy.  Perhaps a new
tools/testing/stresstests will one day appear.



> +obj-$(CONFIG_PAGEALLOC_HOGGER) += page_alloc_hogger.o

page_alloc or pagealloc.  Choose only one, lest you drive people crazy
for ever.



Sashiko went totally nuts.  Have fun with that ;) But I wouldn't do a
ton of work on this until you've heard positive noises from the MM team,
Guys, poke.  wdyt, is there potential here?

	https://sashiko.dev/#/patchset/20260806011048.517229-1-jyescas@google.com


[*] Back in the days when I was trying to get redhat ext3 and 2.5.x
    MM to do something other than lock up or crash, I wrote a userspace
    thing called "usemem".  In recent times I've seen people quoting
    usemem results and wondered "is that my thing".  So I looked it up.
    It is!  And it's now quite unrecognizable.

    Because, obviously, people found it useful and so they used it
    and added to it and added to it and more.

    And I expect the same will occur with "Page Alloc Hogger"
    (terrible name, btw.  How about "pagehog"?  "memhog"), if it is
    adopted.  People will use it and will add to it.




