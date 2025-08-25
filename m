Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14C1CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16CD8E0054; Mon, 25 Aug 2025 12:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE318E0038; Mon, 25 Aug 2025 12:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2AF58E0054; Mon, 25 Aug 2025 12:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2C038E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:51:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 718DC84282
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:51:08 +0000 (UTC)
X-FDA: 83815869816.25.D6BB3E7
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 963A4120011
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:51:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p1aRF4yq;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756140667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqpQFZwVyd9daGv2BdVpF249HwPEKam6Daue11hrMLM=;
	b=7QHYKC635rFMohUnZA4ngfFP4WSQVjZhuO8P9vUQhGiJWbRvW//Jn83bEuAkNJGwFdRACz
	hU5PxtaAm1IWHWzWNRRZcjtUeYfGIN1Y9WzrKK2ur9qH+0zhHT0DRemI6Hc/mfKKlCK7E7
	ii7F+u+DqlwYC0wchifIkq4kY3OUUQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756140667; a=rsa-sha256;
	cv=none;
	b=YWWVB7H/UVsCJGuBcteHBA1yVN4ikT8zk9b8xXBdpnMUtXUKn+Zq9ircOSSxpZ0PW/jV8K
	7GttSgGNQsJgLPmidpKAnKIAQ4TnwDwQF+r+tApQbiqcFfrrjQNiJELKccDbfDXWYj5UGM
	SeJyNeZC7+9MMamm5LQnQtXaONCaO9Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p1aRF4yq;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756140664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rqpQFZwVyd9daGv2BdVpF249HwPEKam6Daue11hrMLM=;
	b=p1aRF4yqOC/7j0VRFHM24pw3foU2tCnV9UQ7nVEdYrizM09lraTGVSjjxLlIc+plnHQ/RY
	Yx06LjtEI/KECO6X2vcoPrNsi4VyVrLjDYSnAoPaQcX2VLxsfV286mDR0o2tLpAO2KkRN0
	Mvr6xXXvwbUwBR22CFrD63CvEU4wtZ4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>
Subject: Re: [PATCH] mm: readahead: improve mmap_miss heuristic for
 concurrent faults
In-Reply-To: <nbhyazac6tig3u753upst4brgmlo6qlwdntxdgwtfslpmmvp6h@gakfswzn3p75>
	(Jan Kara's message of "Mon, 25 Aug 2025 10:16:40 +0200")
References: <20250815183224.62007-1-roman.gushchin@linux.dev>
	<nbhyazac6tig3u753upst4brgmlo6qlwdntxdgwtfslpmmvp6h@gakfswzn3p75>
Date: Mon, 25 Aug 2025 09:50:58 -0700
Message-ID: <87cy8jz6od.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 963A4120011
X-Stat-Signature: fz6y3f1pnczabs4166hpqy4i4ba3qzce
X-Rspam-User: 
X-HE-Tag: 1756140666-214738
X-HE-Meta: U2FsdGVkX1+t+tOHYmOFqVc6GVpaV/SG3lIuhSCsmnhMrnHXjuBc0DkOqTOK5tPSRpcVoPTr6C9qR+iBBnRUbUAaADJB1F/fNvE9RVV1iwqrIoNKAIfR9GC13zRE6DDdo8J4lHBYRdAqNBGT5szQ4HAmNhO6uI1ZuptjFdOkGvR+oG52TT/tI7YVO+G51w2Y5R0G2Hld5VUY4qLoMXyfg+6WnFFgFW1G0oZFCFAwr6eEZ8mJqSM3Kvigv4AtWCl1Xfu0UJahNvyAlHLGtTKHMcWomm83RdSVKjS1VhBQlD92vWwoPn1SA/oTAlNuOxi/yDTx/kSA6LDgXGaPjx61HlmiwbZdL9i7wsJJhiA1jf95dtvc2brLyO5Nt6LgKma9642V5ZHoGmGBlGpUmNXQez3fk3edvwf131TyiHLqKp3T3JfGdsmSPNu39fBbPQE5sby5nG8gf35POSDWK2hwWOrKN0lIf4obhKpkv3z/v8yBSkcwGU4hoAhtDkzDuglANyqmTcDDcJSXJ5IKYyflQiH7B6eAhS4myFgU7KRl+KjRK3krHc9CaMLyjXysnVHwopweHG/M4UnCZqazhc5g8fJs3VVvtOt92WyfE/uynGYGE5uHmftLZe7xNvZGFkr61b/FnzZvb3lxQszpHgQeexXd4tLWe0XCM4Yg16Un9Ic1mr3VWFWyhW+E5VToCGJHV2wG6guTrZZAjkOhiyF2qbRcHd3UhcUesvH3iYAzHvHN9HwehnmodfP9XeBlIm/dc9Rm8deXFd2dQ5cY+K6tzp4xuKtDaGcwKTZ+1bki/Mna38lCawFtDmkcOmoZvZQ5VQUvKwngdjNJAOBM5K1F26MkmwO90+rVkKbRFdlqEeDJYYgjCl4CaNrsarZwyEJhmeU5OZkNgHVKgCH/qi6FLUqcVGZh7LCZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz> writes:

> On Fri 15-08-25 11:32:24, Roman Gushchin wrote:
>> If two or more threads of an application faulting on the same folio,
>> the mmap_miss counter can be decreased multiple times. It breaks the
>> mmap_miss heuristic and keeps the readahead enabled even under extreme
>> levels of memory pressure.
>> 
>> It happens often if file folios backing a multi-threaded application
>> are getting evicted and re-faulted.
>> 
>> Fix it by skipping decreasing mmap_miss if the folio is locked.
>> 
>> This change was evaluated on several hundred thousands hosts in Google's
>> production over a couple of weeks. The number of containers being
>> stuck in a vicious reclaim cycle for a long time was reduced several
>> fold (~10-20x), as well as the overall fleet-wide cpu time spent in
>> direct memory reclaim was meaningfully reduced. No regressions were
>> observed.
>> 
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: linux-mm@kvack.org
>
> Looks good! Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thank you!

