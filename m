Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D7FC44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE4D6B00DA; Mon, 20 Jul 2026 15:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F886B00DC; Mon, 20 Jul 2026 15:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76EDB6B00DD; Mon, 20 Jul 2026 15:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4933A6B00DA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:39:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB8CFC026C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:39:45 +0000 (UTC)
X-FDA: 85010169930.19.4E6EFE6
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id C369DC0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:39:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UEQylVYa;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qp0qmX7/lG+2iV/7px+x4IwYJSrixYtqlMKjlDaa2k=;
	b=nf8gTuR1H8YYsVnbi/j13kgGIdoOBjAM6IE2CtfphcbG9INE9yuFilzZzqGN6XQ79HI5AD
	Dm20qJZhxtBOCj5ECwdEQkle1r5CJufGZYxEymSrXYqLUMZeG39iSb1ZhyafszbHoaX9PW
	PWSRKIO6QOungXK9Vc1cFZxBlvDaCvk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UEQylVYa;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576384;
	b=X7YoLnzDmLqFOVWXqeuKioS4HuHu5DBjY2GFlGb3kdrQTcr1glpPD3R1eft0og707hNaHC
	yo9jEbCYY6LGtAEJay90IJPkNLQl+qMWo+hA9XrhjRolg7V4vPl/n9g7W2fJ+alIWuXq7b
	6yuNEfu45DcL71wFPgsn0+6RE2TwxHc=
Message-ID: <e010eb53-2a7c-46e5-9049-0afc47b09a61@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784576381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/qp0qmX7/lG+2iV/7px+x4IwYJSrixYtqlMKjlDaa2k=;
	b=UEQylVYahUPHKpHwcBPg9WnwTJ4SqNhc1/GHwwewzeeQTWeJBDq8dQc33sgPNQ5xVM+gpZ
	rJOtWPzp/R8wroyp2kpT60GUb6BG9zG8ibFxKCiR1JzYty50EqpxtsmyOXaG2NLaOYuYQx
	jyRfm1vXIHd4Ko6tOlB2ZVX3pIu23H8=
Date: Mon, 20 Jul 2026 20:39:37 +0100
MIME-Version: 1.0
Subject: Re: [PATCH RFC v3 2/6] riscv/mm: add untagged_addr_remote_unlocked()
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 kernel-team@meta.com, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
References: <20260720115741.239657-1-usama.arif@linux.dev>
 <13ec2603d5cbfdc493939f182b71e5133c26af54.camel@surriel.com>
 <46dc1b58-f2de-492a-9da5-a5c429c19a10@linux.dev>
 <51c0025d2eb885ff1f4775e4d9ffcf34f478f378.camel@surriel.com>
 <e9703d2e-f815-4d96-b5ce-074aba281f76@linux.dev>
 <f32b1d2d272e9eafaf0a68be236c84a0585a62e3.camel@surriel.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <f32b1d2d272e9eafaf0a68be236c84a0585a62e3.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C369DC0004
X-Rspamd-Server: rspam01
X-Stat-Signature: mquuneyppmodpxxi5fmuzx7obur3qgka
X-HE-Tag: 1784576383-131457
X-HE-Meta: U2FsdGVkX1/+GpidcmsZG+iMtJRYTuFDSiWBjRzAKPSr1NYSIWOXWspNi1k+uoz18PaoBWZqJnSJoNz0IXMZ26B50ROahN4VhsJnUbNtJP/vpW+7mlRZmQpX9g3mJEYZhEpHn8jERLTQtHCsuaBPZD1A2Nn59pnKst/dd1W0cno53Qll9/csFB/Be11UIihw3kUMfIWVQZ/QSRHdlFm3cyeHvXHkyEG+NypK09VibO5EVJ6vX9sJ1EC1PJup22LvNGB+kzjHfV16hdKcCG2PZeC3goKpAdpz+oi1EaoeqqXzCArCCR8bvY//8+Lmwwtg5Ip8ONeqsBO9FA9Eub9cwMl3DVGmQLauWoSLBBDbvq4a/HN6//cXtpxonN4TlWTOOgEyTAsapoFA2s8+bK8QZggPpidHBDEP9VlTQfq9dWCrsNnG1ldflyAn7VwLguoBhtstn0wz6+Bgg6Z66zFPmdVIAgWCbRPMBygNHtkQQdg8rQC1IG07Slk5S7Hq66V1Bn4T/afrhdiUqjED+l9l02U/gHuhusImMjyVZ9XbX7ZSj/FKQUK8KogtoF1cyUDZSYr+E0ohd+IhQBmv9VpLWM/gBygyhtgNf/GrRuT7DNOcDuPNTQXJN+VsaVKM4xWHFCatONkzVYGTCyp0zH8QxMxfzm27CtAObik8hxJqcHm3fghccynh0aEL+sccgQiMwDOq7OMxxyWvCExB2DhaBhmh+8n3Qrv0uHoLGsmIh/yQBUxbbhjJiVJcthnTruntRv6uiYUPToGonL4msvQZLW5Xyq8mVJ7liza7+rvLL8Dnlj9M/qJxkhawO2oqFh9wz3vR9dJsgFAna0dUUDJpj0/Q5cp6mN+fVvPC8lVl5fEp2oLqdebIVvD1o7gZOg/gKZjlMajsL9sFHr7ag3PpJs04fpvGVtU0LOYl0aRCSiuEV52GDWph2n57pH/CNX1BL3elwfrhA7rBC6etJg3
 F2mAKQ7m
 X1pI8nDkzLNMPKHZj1OOuPnklV38k4wSxIeXVS5ap3zCuwJJR4gTIWboeU+9WOS1aqiK1c3zM9XAGEvG5l3t6/G6PrpRnzZjwZVUcDpd6k92ZcDMr+CF2oXJpAeemHP1DYEhM7gzE9M5mh5L/VWVIDUm2XCORnlnQeYSQU1Pa7ig3MjYQjKFFEZB9zyWksB5xDE9QgJydGSdocLR9oRb9/GIaazT9u1ONaGJUIB287F8TF6MJzSVJZ/dSg7CYRH3vNc64+L65s3fC+/HJfrohwNQeSj0GvdSevsPs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20/07/2026 20:21, Rik van Riel wrote:
> On Mon, 2026-07-20 at 19:46 +0100, Usama Arif wrote:
>>
>> So my understanding from exploring this code is, and hopefully
>> someone
>> in CC from riscv can correct me, for example:
>>
>> Tagged pointer:  0xabcd000012345678
>> PMLEN 16:        0x0000000012345678
>> PMLEN 7:         0xffcd000012345678
>>
>> The target VMA might be at 0x12345678, but applying PMLEN 7
>> to that tagged pointer does not produce that address.
>>
>> Previously, the order was:
>>
>> Take mmap read lock.
>> Read pmlen.
>> Untag the address.
>> Look up the VMA.
>>
>> Changing PMLEN takes the mmap write lock. The read and write
>> operations were therefore serialized.
>>
>> The new order is:
>>
>> Read pmlen without mmap lock.
>> Untag the address.
>> Attempt the per-VMA lookup.
>> Possibly take mmap lock later.
>> Continue using the already-untagged address.
>>
>> A concurrent PMLEN change can occur between those operations?
> 
> I suppose it could, but what are the possible outcomes here?
> 
> - We fail to untag the address, the vma lookup
>   fails, and we fail to access memory.
> 
> - The address is already untagged, maps to a
>   VMA, and the access succeeds.
> 
> Are there any others?
> 
> The VMAs of the process need to be in the bottom
> part of the address space, right? The part where
> untagged addresses sit.
> 
> For things like /proc/<pid>/cmdline we should
> automatically get an address without any of the
> high bits set.
> 
> For things like ptrace peek / poke, BPF process
> accesses, and others, I really do not know if
> those could get tagged addresses...
> 
> What are the failures we need to protect against?
> 
> What if something comes in with a tagged address,
> but the process disables tagging while that
> something waits for the mmap_lock?

So I think the above question is what needs to be
answered.
A tagged pointer can become invalid if PMLEN changes
before the old mmap-locked lookup too.
The mmap lock only defined whether the lookup observed
the old or new mode.

For VMA as you said, it should be ok. I don't know about
others. I think it would be best to get input from
RISC-V folks for this. Hopefully its ok..
If it is ok, then all that would be need to be done
is to just remove in the commit message that pmlen
is stable.

> 
> Does that reproduce the failure case, without
> any locking changes?




