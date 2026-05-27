Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85ED9CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 01:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0F506B0005; Tue, 26 May 2026 21:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFD06B008A; Tue, 26 May 2026 21:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5BF6B008C; Tue, 26 May 2026 21:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9156B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:49:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52DA51A04E8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:49:48 +0000 (UTC)
X-FDA: 84811518456.25.4A10349
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9576EA0009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:49:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QJeYrvmY;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779846586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQHn0lIESMVrKtDroCt10TOS7riOoU6PCqbNq2RdkAw=;
	b=pFDBfkdPGBd4BCp/MJBspOyrPVDVne/iUsMPRrkL/eZL3D0LGVwVzy5PJ+HV0Zttr8z1/t
	OLoE5PCxb3kFsCy+TH01M/a29ss4KCz+WKxW0hNrnK/xKulqbVI7r4InqU67YApvyoVFOa
	0rZZv1zJ5qh8DCEb8bTK1AR4mTlGLN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779846586; a=rsa-sha256;
	cv=none;
	b=25VY2khLDX736RxPETeGOEgSXqzvOISIHXRjtuyW55ZAEd1tWT5vjB21NwNuUZL6Kr+lzE
	SKOvbv1XST3iWH+FBLEnEWz8p8tYKE4RcEt+KPR8WEoLzcQEBydBa8Xy1DnKoFI5p9B4Bf
	Xe3TIG8ohbSBsdrfdbqoQWmGYFBlunU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QJeYrvmY;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB8BF41832;
	Wed, 27 May 2026 01:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F42E1F000E9;
	Wed, 27 May 2026 01:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779846585;
	bh=RQHn0lIESMVrKtDroCt10TOS7riOoU6PCqbNq2RdkAw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QJeYrvmYIXlRgXJqbx2m87Z2F6eVrL4d6nmkeXmTxP+bjQnHFWIWAi+Maiat5XOcW
	 tO1AzZwFe4aVT2grsG0L1uOza0ONm543/qk70VhANXMcH82Q+9Yxp/XNMr1botqiD0
	 QG3usvJtyuOKWb2Hbiirgtj5Lo1s2kEvJi/RyGnk=
Date: Tue, 26 May 2026 18:49:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, liam@infradead.org,
 ljs@kernel.org, vbabka@kernel.org, willy@infradead.org, jannh@google.com,
 paulmck@kernel.org, pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com,
 richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps}
 reads
Message-Id: <20260526184944.18c28d6980fd29ff12fbbe22@linux-foundation.org>
In-Reply-To: <CAJuCfpHPs54_hc_U9DCxtv=xikKHJMtqCEDN_4Y5aDqKhoBDnA@mail.gmail.com>
References: <20260426062718.1238437-1-surenb@google.com>
	<a27344e1-6f0c-4686-99ac-fc2cfcc5bb06@kernel.org>
	<CAJuCfpG3xZhL94E=yR1KsWs6fVwcdoAECoOaV3UOeB10TXmOeg@mail.gmail.com>
	<0ce6071b-0c99-4119-9ab4-a2d9c00b99a8@kernel.org>
	<CAJuCfpHPs54_hc_U9DCxtv=xikKHJMtqCEDN_4Y5aDqKhoBDnA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 9nmmqn44856dbngpcds13tyrp4jz8bex
X-Rspamd-Queue-Id: 9576EA0009
X-Rspam-User: 
X-HE-Tag: 1779846586-413185
X-HE-Meta: U2FsdGVkX1+bCwJGKPkooUCaz3plhIY8uhNXXt9y7wdlJ9xDVwYU5xbbksymWVT3J3shcnccxrCItLqC1uPsWouE6hGWVi2aYkpTli6kTC2A0bjPfPx2b0KqB7wsAsjr60J8pAqRZ9qFwWkELEh5/CfhUMBOp0Ll4dK3LcVN9guz6W3FKAdTZWv1wCUGHAfzfAzh+gQVaclT5ah7syWNAyZxJfljp665fgHjgfiDL/n35w4zvuieRUCzd0BRvY/vuAyhwrv2HDYNG86Yv09EUlu4eEFLlWrR7/BgO/ZZN58iE9KstjAaCThJwbkduX3Q6Edr8mqLSIjVPbhiinAwGGtvSDG6PP7BrqgCCHZjCfnf+1fH7N3YNkmWnsBhCJP9qJII4ChQ3qBGpL/KFPGamoq0sals4uJ9q+7oYWTugNLEibp6Fo6Nrf1q4CstrIHMo9g/2SBCoVzadpAg7kPYvyL/bTh58cpp1h89oj1mqp7BHFywTzqPsowSWbZb9jEios5svFgsfN8TTv8kKUQxnwEfSyG/tH+enlqZ6hFeecEx537EgtOMo77gUdIPFZx3g2l7ZK8TFdC2tPu4gZJqY4ZT6GUR/Cfz8HIBgkriWI2kzH88AQ9gVMH5jmV+V6oEhWMX3I65juaMb7RmFcIIeuh48hgLL587WKXaOrGqfqJ3KmbQWxZsKYPZJD6YTwv1eDqUCVSjdea7d397jDY7f3zYqHCfnu2hfre0vdocCYOhiNGzSXzHICU5eXbEOpLQ30a/LA3kg6aUotkALgGQ47UwOfooJgFRPBkwCWhEQ0/rKegUlo27k/iO8BolgflLua8dcQSwF0m27cv5z9SchGnGXtWCO3OFA7ZWIVNi3bSQanPRatbsIX4NL7n9SKW+Tvgstg8p0wyFuHWnbHQyB6/WBbilitqI8RWM4UfJIAxnNdm7G2RW6jTpWjq7L5bJyOZ2XqOmnRdK5X1mSHc
 uhjHULET
 YqxC+WIn/djmGV+i/a9ombG67s/fCtNBG2qqY5wAh9kKXwqMBOFtmhKvluPdfhIAqF0Jsz9Elb9ae5AzMS2Y7owJB+1tLkOz0x+DskCc1XBTTtiuJ5C+EbA2+uoZT+2FdQwrbwFO2/+PHN7I1tRP7X0zObRVllFs4MhnD50H6hBWfNflYKlTjg748EsuyKlr2C3+QANFtKOIvRNVYWl3nQpsrcHSBQxDfHbFSFmW3s2MFvz3fyERPxU6QTARTWc6IZPOak6tIx2x8FWJ0HyA8WCWDG0xDNFVCvShxVlBSmGgzdpKCZ64BkUvJw9odLBitOetwuRQKfqb0+BJd9ravoNzV9ktWPSNdmXlBabtNBKKx7T9GUeNyPzBw0JsZgOM6BpOiRLe8M6jq4XmCRen6cWocLha8H76yF99V4KpN+055thx++yA2YVvXKsQJD5FaF3wi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 08:16:01 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> > > It might be but the point of this patchset (and the previous one that
> > > made a similar change for /proc/pid/maps) is to reduce mmap_lock
> > > contention, not to speed up the read operation, which is not a
> > > performance critical part.
> >
> > Well, this interface has been around .. forever, so if there is a noticeable
> > change in performance it should be called out.
> 
> Sorry, I missed your reply. I'll see if I can adopt Paul's test for
> /proc/pid/maps [1] for benchmarking smaps but I would expect similar
> results as was reported in [2].

How's it coming along ;)

> [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> [2] https://lore.kernel.org/all/20250719182854.3166724-1-surenb@google.com/

I've moved this series to the tail of mm-unstable to permit more time.

