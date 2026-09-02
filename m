Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA25C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61F36B00AB; Wed,  2 Sep 2026 10:36:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A076B00AD; Wed,  2 Sep 2026 10:36:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950766B00AF; Wed,  2 Sep 2026 10:36:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65C246B00AB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:36:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBFB740245
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:36:13 +0000 (UTC)
X-FDA: 85169072226.01.0DF39C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E99A616000F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:36:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qz2Ew/Fo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788359772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzzpWL0xLJV4HxgXaJDCRpeFEK+cpnvsfs6kVzVfAak=;
	b=udekm6Y4YaUjd8kR+XKwz6xExKtcrn1uVXfaHBjXqAc41X6PPwAoAvy+C1yYSrxZIJoxDQ
	78HqEgR97O883St1WMjbKfFZ2HbKCKtb6AIMzcGsa/wreMbG1lWy3pjsBaU+3rid+wiRkJ
	+euZw7wjn0Bd4OdfpnAv6Ypmhqr1xxA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qz2Ew/Fo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788359772;
	b=Vf96FLxY1HI+98QiIEGHfDYgmYUmdHJTg96a4Qi+3SUnZ3XM+ii5vU5yX3iKXL+wavU3oN
	ECRjCoHSY8RQA8rSEN5EAwWTDxP3mzjgeU76PH1mrMawVY/axLRjc1JoQOH2StIZudhnyt
	Uh0jN65plcDoQjBs50dGVi4aVYKFEiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE8154009D;
	Wed,  2 Sep 2026 14:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DAE1F000E9;
	Wed,  2 Sep 2026 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788359770;
	bh=uzzpWL0xLJV4HxgXaJDCRpeFEK+cpnvsfs6kVzVfAak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qz2Ew/Fo96WKMMFECtw6AcGedth0FeblIay9/D+sibhjAK2/BTaqye6hTBWLs8zRw
	 qXakXIrkxjuU89HS4vq0KEDl4x5Z+5neqSP1lPuX0OLciuKdgyqjd9FTsSHKpkKbON
	 +rEI4WgECsqIzEjtNQqxUwhobsANlSwbLo0+gejc7TXvcdF2esdVnYMH+viUhY4Vxs
	 I5YPwI+B873UPnl851liAilmTnKwoRgKEBL/Qkp67CXcRlVxi7w0cHqyTfePTjs2ij
	 SqS2cmlvhnjlis8DLSAigHIQ3woqHE6gL5snkeJGrQ1zoiv/+OdHptqVqSk/XgvaGn
	 Hno8waIJ7Q4NA==
Message-ID: <d3ca9ecd-768a-48fc-805b-cd50efa639af@kernel.org>
Date: Wed, 2 Sep 2026 16:36:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] USB: usbfs: replace __get_free_page() with kmalloc()
Content-Language: en-US
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Chas Williams <3chas3@gmail.com>, Duncan Sands <duncan.sands@free.fr>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johan Hovold <johan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 accessrunner-general@lists.sourceforge.net,
 linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
 <20260830-usb-v1-1-aa349c302246@kernel.org>
 <ea165ff8-cda2-4fed-9354-1d14ac2d87ca@suse.com>
 <8cbe558e-7f53-4ce4-be8e-52fdba9105d4@rowland.harvard.edu>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <8cbe558e-7f53-4ce4-be8e-52fdba9105d4@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w64tqfcjpipstgiskf757mdq5udt58zu
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E99A616000F
X-Rspam-User: 
X-HE-Tag: 1788359771-516503
X-HE-Meta: U2FsdGVkX19WT3vFpWmK0hljh8p2/jlA0qn0tjD3xkoU4fdUayhYefomWB0UWhzv7BSKUiE9dyIPE0Y91abNvspFwCtXT/pwglcjn2d32UGMlCMlorvN4cvNPslws95r2B4Cf6uuxTlF0OneIfTXwVJ7c35IArt6tmh2Pd1Yj7ZdqloRVs4c02nH0cchcr1lpvJcdk9jahygY+DXx7SMpMVfzFwy13GocDULIVCT2hZn5RzFG7OiBp7SrLC6vEXDFDIcI6yhWWJivc9IiUrjhO28jsImRqxePeVoYhPgUWqdZ/cZyu1GasDYGprrxY6lhpdMkIy+YjTS1BQFMiVZlLCHdXmw+lcgo3F+UviVzexXBz0TuuVJevFyaCMPhnyTBO5cBpK1tkhZ5tnIkldUHZ+0KLTROILLpiYxZzNg9Zkf74fR6cY8ZCNjMk3sje5uw71kTESCqKwAHlUwocXXHN6j1neMP838QvLmOXcVTkLy3xUL1xNKJnJttQupXFYszTjbBFJS3yY7PJR5HkGol5psgYAmI4hRDJ2uUY3c1Ou5iV3mvM+TArHHxsH4Bq1H8lKXrHJvZdGIHKD9FI1y5uW9z70ZEilAMRyV44uG59n1n6xaCB8hj4emc+NeAZF78OqqS+fn8boliyNNkjSsNsy8PwWgjbOE3ETPg2oio0dmnXiygug9iEJsZnnQIObHYsvwm+bWgHwJG5KDymcboEetI270SQF8WER5L8jhndEaDSfsO5/1bndW5xQ++BckFcKkEGkpuPlsVtGCWFOgyR1vc5jI+ZaRkCteTq7VM3fSGwo3u65Tnk/imX8oLN4BvibxrzYaCNhVI+Rr/7zR9NUEgD72NdYn0+FHvjk8IBBhAqbaj8YkWonXQcRm6ghLc2zjkeYLnpVfCkmyaRaWfKlD1+/9TiizGkGLP05wGCJQb2yW4a0EFaAXGQq1z7756IXazGKOoREZfofxSwN
 MhbrBHmQ
 w0OVllBJOhqEijfw8IC9A456nG53KIt/gRUfULLmeS7iWk1hAnoLKf8hjAfHyYSY2PvffDfVFQF5Ci5JNzqQBBOXpZ3GNBSPCNtWzFIKTzlNOnWGXdqgdyqK7Niwr0E5A0A9gkKC0fyYg8KoJO8c7t0a84zA0GPHMKa8fzyDYqrspm6X6F5bqQdHL4KmtBGhq3yTCotlPDIeRxsAQsqZIX3/qGntBeSIDmtHLNdSfSymHaDBsFx8/Oe3eJHe0DlCBBBY/2n8PPb+Eh4ReLiSn5kU7qAW2JgNzz+Uj8XfJ2B5xJApBFbiII7gCTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 16:30, Alan Stern wrote:
> On Mon, Aug 31, 2026 at 03:27:07PM +0200, Oliver Neukum wrote:
>> On 30.08.26 10:10, Mike Rapoport (Microsoft) wrote:
>> > do_proc_control() allocates a temporary buffer for the data stage of a
>> > control transfer issued from userspace.
>> > 
>> > This buffer can be allocated with kmalloc() as there's nothing special
>> > about it to go directly to the page allocator.
>> 
>> You are breaking the calculation. A page has a size of exactly
>> PAGE_SIZE. A kmalloced object of PAGE_SIZE is larger. That is
>> a bad idea.
> 
> By "the calculation", are you referring to the 
> usbfs_increase_memory_usage() call in do_proc_control()?
> 
> The overhead in kmalloc allocations doesn't really matter for this 
> purpose -- it can be considered a rounding error.

FWIW, the overhead will be zero for a PAGE_SIZE size, unless slab debugging
is enabled, but you can ignore it.

>  Besides, we don't 
> know how big the overhead is, so we can't account for it.  You can see 
> that in the same call, we don't try to account for the overhead involved 
> in usb_alloc_urb() or kmalloc_obj() either.

ksize() exists but I wouldn't bother indeed.

> I'd say there's nothing wrong with this patch.

Agreed.

> Alan Stern


