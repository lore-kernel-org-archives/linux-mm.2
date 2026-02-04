Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB51CE83F05
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C444B6B0096; Wed,  4 Feb 2026 13:01:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BC16B0098; Wed,  4 Feb 2026 13:01:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD686B0099; Wed,  4 Feb 2026 13:01:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2A76B0096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:01:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 58E231A01F0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:01:31 +0000 (UTC)
X-FDA: 84407541582.08.4CA2C50
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id C016B40013
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:01:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1jsLW73E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ekr5tYoe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NbwMHFj0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1v0dpTLa;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770228089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/h1H75MzwyM0dxtB6t3yKM2GtQfPuU1slinrxlGbIs=;
	b=4vAUQydHn/s3z7Z12NI6Qmua0dIhv377h+15PUhEmS+29yuQxG35znpAMmi0ijFroqg2/j
	nlXBZii76X+I0z+6Tk8DTs9yuMt5vRVvO05sg3VNfARtiNsF2EPZLohIMwiBRiCF+JtP1k
	a+XReHN2zxzrOI0AF9PoPxgf0i68UNE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1jsLW73E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ekr5tYoe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NbwMHFj0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1v0dpTLa;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770228089; a=rsa-sha256;
	cv=none;
	b=DRMnvHwzib9ooJ/0KklQERG/pXL15fvhJvP4insWwmCskXZIjAfQs/Z4ufjJfQD7NTsWLF
	XOU5WKW0QPXafnL1tMAGZIEHtJBp0Idmq/I4WTGtlyOndEWPsRcJvfyyOrFe5Bw8VuscVJ
	+KYSDMX/olB0mFKk9TXGZTA24mpzVJI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EED375BCED;
	Wed,  4 Feb 2026 18:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770228084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D/h1H75MzwyM0dxtB6t3yKM2GtQfPuU1slinrxlGbIs=;
	b=1jsLW73E5LtstV7PgQCeTrll/0ju3u1TeD5vFxS/CRvpqMKQuxZNVI5LLeR2Fv/2o3mq8t
	C6CGVkSX2E2LLa3sEhaZd/2jOPELlsD8soxxmsoH8EEg4nc4s7Wow6QY8RJK24q0UVF3o1
	iDG/zvfRyLBP+L6jomtF1TwdCBgun8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770228084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D/h1H75MzwyM0dxtB6t3yKM2GtQfPuU1slinrxlGbIs=;
	b=ekr5tYoevU/ko2yRaBRVcJ4o6IeN/NjrIJxnJruYovivZ9RBXk3g3W5wB/s/qT9Hjj7nY0
	QPlIwebTJyf5TDBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770228083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D/h1H75MzwyM0dxtB6t3yKM2GtQfPuU1slinrxlGbIs=;
	b=NbwMHFj0v67X3yTKcvvI+D+65pvUoUbpFlcpVmFdV0rqJ90Ordui1fFFLPCqNpOcY7bQEU
	NjG1o1ncaM6nn4iase54b5owiG8d6j1TQSJIpwrx/S1tKS1E+YEtRdNUoDgXsVcJIIiVi2
	tWN3v2k2WJADEwXSfL6Nwo4TSl6pG7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770228083;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D/h1H75MzwyM0dxtB6t3yKM2GtQfPuU1slinrxlGbIs=;
	b=1v0dpTLa0AF7dbVhz0+hp28Jwlh+xjM3JHdb9VrhUFQ6oVdGYrzRoltXBnyDR77RLWwana
	RB5oZ13gLQb8zpCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1EA43EA63;
	Wed,  4 Feb 2026 18:01:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XgjqLnOJg2kQGQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 04 Feb 2026 18:01:23 +0000
Message-ID: <23df6018-69c5-4c94-bbdc-05c03f837f2b@suse.cz>
Date: Wed, 4 Feb 2026 19:01:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/22] slab: add sheaves to most caches
Content-Language: en-US
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
 <aXsLKxukv60p3QWF@intel.com> <2cd89ed5-0c8e-43f8-896d-1b7dee047fef@suse.cz>
 <aXxaryFUrIFo7/hL@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXxaryFUrIFo7/hL@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C016B40013
X-Stat-Signature: m7z9otooy1948bxuwwyj4qsyn5p9jch4
X-Rspam-User: 
X-HE-Tag: 1770228086-355361
X-HE-Meta: U2FsdGVkX19t/u4fRbBLWDi9BUT1hTgSTGkTrZ0UPHp2vlrUvAreg4CZi3uTbI6eZFL4jug4TdhrL/TP9QR6zgw5tZytpvk8mBaU1SC3UDsN3R2XjVdjYOAPT0y0pF11CSATQ5UVhSkJ05LiTdjd+I57XIwvOX6MB6l4vstKnQV84Yy4+uVfijytatnIHRoAt2pq16WzMpGhLUCIOnsU0AddAx4+ZMIZV7QM7CnqVhwt9O05QZiENzHJRwioW4zYvbpe5hJQ6G2Xl5gVX2wrwsVUT65yIwLNZugHfd3TnZVBCBwZIONQbYTKHywUYL3cgvduj3E78y+irDf0JRS7ydmFTt7TbK8zF8aml4OoXEIYmeqgqeHUja2OuuuI52h9Sar2SSY0K7GlUevXyTDJDq5OFm0FAujSQQSXzWPDpcEF3RLf7X9oiCMTVHDCxOznpiMz/ceTJnWipBWMMqZ+pFIAJZR9KavO619vklVzV98Kr70Sdsh/BYBwjLSknjsBPkxNk78b9TEKaj+y3qGD7a9B+v28I6uQhbRrBPRRfOD9bR+Mw9TqINjEu2TE8fwK1MdV2wngeSoodmlPkGnv5vJLVZJgFe130NjTGQL7Jz+gVVeC6nM4iYbEYyE6zNNOEkQVSUcUQERDDrLQONLc8WLmzsFxspxok1X9J1++CKIw3iw3r5J7eufBOXdAUYTethT62TShjchEkgZOQWKMAHUx5giRJB7hMlPr0bY2+ddXusMo3am/tZ9R2VkYvQpvTGULWHDMgcgUaWfZvKxECkxwXehFD5xeR3SEaRKhGBao31aBW6CQJ3OjStymJhRxHe7rNfR3H0xt3dXvgGtdbHmzO7+7L4zYdpiKIDJo86XnpGpgo5wZZL04njugyR54LKgmTQY23/YUJCMoXn25vQ7aIW8CtOCTZoiIIjroNSgYhjZHsbkNiX4qWjo2D4NLmuteh0px/ftuYV+YEwv
 mQFY095H
 Rrs2wtIEt3X3Q1qoP8TG33CNoXqWwnZfZuHM53qDjU1caFrjwkMok5BV1ZeTqGVbNxa/GHNZurVh04QLNamdvRJyuTmifog0cmUwfixUrKu4/aGa4EaERdvHBtMDKeCdVycEaT5cGZmziOT147l+SN062Ap1UnziirqoR2wPe23PisvNA4xUgYrFd8gIR52arHrkOZmFjv+txVX5xKOMpJc96ZqzKxKJ8R4JjPP0Ve59RbFFtz89Mdk9+rVIHs5Gk4RbgQiyhhAetfYcMIFLDPrPWeG18hQBwGOiSthQYUDabVdkvgPiAnxPGSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/26 08:15, Zhao Liu wrote:
> Hi Vlastimil,
> 
>> > vm_area_cachep's capacity seems to be adjusted to 60 and
>> > maple_node_cache keeps 32 as the args setting.
>> 
>> Good to know. It is a bit larger.
>> Hm I could have probably applied the args capacity before doing the roundup
>> to make sheaf fill whole kmalloc size. Would add a few object for maple node
>> I guess.
> 
> Re-considerring this formula:
> 
> the nr_objects in set_cpu_partial() in fact represents the half-full
> case since it was used to calculate nr_slabs in slub_set_cpu_partial().
> 
> Therefore, the maximum capacity of this partial approach should be
> nr_objects * 2 (and should actually be even larger, since it doesn't
> account for the object on CPU's freelist).
> 
> But here, for sheaf, the implicit assumption is that it is completely
> full, so that for the maximum capacity of objects per CPU, the sheaf
> approach is "half" that of the partial approach.
> 
> Is this expected? I'm considering whether we should remove the
> “divide by two” and instead calculate the sheaf capacity based on
> half-full assumption (e.h., full main & empty spare).

Yeah the non-doubling was intentional. Sheaves can be always fully filled up
by freeing and fully emptied by allocating. Cpu partial slabs don't make
freeing as cheap (except never needing the list_lock perhaps) because it's
the locked double cmpxchg patch. For allocation, we might be obtaining them
from the partial list either on allocation where they might have any number
of free objects between 1 and slab size, or we put them to partial list on a
first free to a full slab - and then there will be just single free object,
but we hope there will be more frees before we turn that slab into cpu slab.

So the half-full case is an estimate that might be even actually less as the
freeing side is biased to almost-full slabs.

With sheaves no such estimate is necessary. Not accounting for the cpu slab
size was maybe a mistake. In any case we can tune the sizes later, but this
should not be based on synthetic benchmark only.

Thanks,
Vlastimil

> Thanks,
> Zhao
> 
> 


