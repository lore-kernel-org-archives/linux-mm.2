Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A531C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5B96B00FA; Tue,  4 Aug 2026 12:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56DE6B00FB; Tue,  4 Aug 2026 12:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D956B00FD; Tue,  4 Aug 2026 12:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 611776B00FA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:27:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D864A140239
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:27:34 +0000 (UTC)
X-FDA: 85064117628.12.694307B
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4C3CB1A0003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:27:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=gUqmmnMj;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf19.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785860853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRx4dTP+E12UD+buBycIlsaZS3LI+snTNrss8we8dxo=;
	b=ZXrlNQpRW7VjwlA/nYf7yw0OgK6YZId77FckKvpENneI46ujYnhKzl+GvDks+WUSsbhDU5
	nNotVxGQRp90GLsjlfEwfrWkN4lkD36Ost7Ab3RB2mfMREMViDTD0FTVRzTHcrvLszYOHA
	/msI29ZVljVNFX5Ne6+tWbR7en105MU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=gUqmmnMj;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf19.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785860853;
	b=0GWIYPViwA1Mdn0bzfqd3p2tHod8gaKDlzFUeEe4UmF6nqtsdvFY0K33IwjISNdJOWpwtx
	oyvjhcsykhs+KUCeJcBjlQxzKyMadBfFeTmTgKN8q0tvImIFYFZLmkH7LnugNbL3Z4xxt6
	bZJxrvEq7jnRcrHG/WQNnGlq1sA4Jso=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1785860155;
	bh=Dl59RvRhg66S6l9o3fECd7i9n0QYeVJJyHFmCxzp8Tg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=gUqmmnMjn8LK8++gxC0PClqY6BzDe/pWCOdBqpFhDhrNDnLIaoBqdaji0inZ5xmgM
	 xBRDoszSRajAYTL0dLTCnt4D63IMOqPracIHZoDPPg9rcM+kmTcDpnvbT8u205NFoL
	 5zov5xUI4qkUaC5EBuYpFPWty8G6nvEfuBxw9NGE=
Received: by gentwo.org (Postfix, from userid 1003)
	id 61837408AE; Tue, 04 Aug 2026 09:15:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 5D15B40287;
	Tue, 04 Aug 2026 09:15:55 -0700 (PDT)
Date: Tue, 4 Aug 2026 09:15:55 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>, 
    Mark Rutland <mark.rutland@arm.com>, 
    Yang Shi <yang@os.amperecomputing.com>, 
    Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, 
    urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
    akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
    agordeev@linux.ibm.com, linux-mm@kvack.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
In-Reply-To: <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
Message-ID: <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
References: <20260715180455.515692-1-yang@os.amperecomputing.com> <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com> <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer> <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: b7u4za9co1o3wdx4pj3xqy96cw8r79kj
X-Rspamd-Queue-Id: 4C3CB1A0003
X-HE-Tag: 1785860853-638699
X-HE-Meta: U2FsdGVkX1++W3mdiHuCtSOp/Q8X/euYxLTeLWBmyflNkStL+9XuCTJFyhVP0TAR24fkLrccfllOyKN8KiDSpKtt/WKa3hzyAP2rkuzkcPkp/gSmKpvcWBP43kMAQ8X+2/90f6UfbEWpQfEhzUWjrM1xy+3C2OlJ6U6+ci6mBlK1V3W+qcVWRdIKuZQbuiAZ4M/dNyPBJFRuTHAC2wPxlMRggDg+rb425M+YDDR7fplLx0oGVADVja4zlgI4Sv6o8/dWtvIopDbz3z924ZfFDHzpyBubYabUPQVmdgXcf5F/KDJbG0XCY1NKq/x8yaPA6JU5N8svEFM/gXNw79SR0XQ4sJr65ToXPGj+svsIazQYsF9nlL2hGq6ZWd2iFFOmTLNNi6+jBkXcp5Ur6SM07BH1fMMeBtgvYXVFbVV1rR9G7K5O7bH5vUVdH+4TVbd24oDnxAkVbvLlUxPy7eoxP1RS7VgMopOGOqAXZUuEmsmiSiuICMB06tRULqXJJEsAPNotiUTCn0/ikHQB6J9Rd7mYKUd8oGol2CdRgola4/cQAhy/o+IMifpMOkTNIAIq1rjYEuQoDde1R0CAKxCBGxpTGT2jISzw/YEWPEHIay23avZgb+6aL4vO2qpsTXItTwfOhP0WpX5z5cAXUIwtdWgSzT1R/B+LbTkdFc5ZPS2K294IVlwWvmRZ2xPbsxkzigepKM9Xd0XvtJ/VQzIXhQSGkryqlMNizD5llNvGOcsuIZrTmMtRXfQ0v6JdP83n6RrECXR9LWzhv7EbnBzLOI0aYEub2b97yijzv8Etu3hZZbKl0qSKQ7yKAludoeDWnv5Nu4pL7p5F+632MS49AB/XA5TvHa8C67kxWNpBU+C9CcefeId6kM6OuWHyjtf6kVMeliCuwGrZxFpBqtBhQy1seII0tt/EA6zjxkck5YMeunwH/wAKkJ1Nbnxt5qks7rY7b2WnzgOf9FOh8dH
 nsuTHCy6
 Onb9GlKzIT0nNiOXLZl7ZBY996MYyJTYeOLtjbu5lrmhU+ZJi9yxY3QIc5F9v5GcCcsPHAG8OtaKZrZIzjrqJgFF6lNik7nltdw9O664le5z160POhQXBOlgWzJWbe0VEhjmukZ37uiUfos6Y4STTtT5e4r2mxf2KGDtPS9hgfCK/zAH8s4CCqw3lggP08zBTUHsRh3u8L34uMrl6LWHWYRvKa5aibMbJRb9w93sJXK34CguvnEYAtYA0OHXJfKXqTgexb9fs8Judh42gWWyTow1p94W0V1WE6tDEAhgEIYFadQVm165I8TaY0bmnro6aixrG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026, Linus Torvalds wrote:

> On Tue, 4 Aug 2026 at 07:15, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > Linus - I assume you still find per-cpu page tables totally unacceptable? (had a
> > look around to see your take on this recently and found [0] which seems to
> > confirm it :)
>
> Yes, I still think that per-cpu page tables as some kind of
> architectural design is a horrible idea, because it paints us into a
> corner where you have intentional duplication and then end up having
> to have coherency issues where you need to lock for updates just to
> keep things in sync - and may need to do extra work on hardware that
> may otherwise already have hardware coherency support.

We already have had the intentional duplication, meaning multiple
virtual  addresses  for a single physical address with vmalloc and with
vmemmap for a very long time. Issues with hardware coherency that may have
existed for these cases have been fixed a long time ago.

> I honestly think that people who think that cache coherency in
> software is a great idea in general are misguided and should not work
> on kernels, but should go back to eating crayons and decide if purple
> tastes better than yellow.

Certain a bad idea. The per cpu pagew tables do not rely on cache
coherency in software.

> That said - per-cpu page tables as some kind of internal architecture
> choice that limits the damage to some simpler case is not necessarily
> wrong. We've obviously done things like that for page table isolation
> etc. It can be horribly expensive, but sometimes that is the price you
> are willing to pay - and sometimes you can avoid the expense entirely
> by knowing how the particular hardware works.

Have the same virtual address on all processors to reach the local per cpu
instance of a variable simplifies kernel code and avoids
preempt_enable/disable sections. Especially operations on counters in the
VM become much more efficient.

X86 can accomplish that with a segment override. That is not available on
other platforms. Page tables can be used to do the proper mapping so that
kernel code does not have to theses address calculations. These are
frequent operations in the kernel memory management.


> Very specific example: on 32-bit x86 with PAE, the top-level page
> table directory is fundamentally per-cpu in nature. It's just four
> entries that get loaded into the CPU on page table load, but it means
> that you can do things like having one quarter of the page tables be
> per-cpu, and the rest be shared. Several other architectures have
> similar "regions". So it can be an architectural choice to have some
> kind of per-cpu TLB. But I absolutely do *not* want to see a model
> where the general MM layer dictates that design.

X86 creates highly optimized code for per cpu operations without preempt
enable/disable sections and I hope its ok to use per cpu page table to get
to a similar degress of compactness and performance on ARM64.

> And there are historical reasons to really hate it. Plan-9 had a
> completely broken threading model that depended on per-thread page
> tables. It was literal garbage. It was broken beyond words exactly due
> to coherency issues, and I still do not understand how otherwise very
> smart people ever came up with such a stupid idea.
>
> We are not making _that_ mistake. We have made enough other ones to
> not neet to shoot ourselves in the head that badly.

We certainly do not want to replicate that approach. We are using the per
cpu page tables to avoid address calculations in the VM that other
platforms can do with a segment override.

