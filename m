Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F88FCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA51D8E00BB; Fri, 22 Aug 2025 13:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7C8E8E009D; Fri, 22 Aug 2025 13:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA668E00BB; Fri, 22 Aug 2025 13:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BCA78E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:20:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A77616020A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:20:32 +0000 (UTC)
X-FDA: 83805057504.20.F9BECB1
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 98C0B4000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:20:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tCaOAGyv;
	spf=pass (imf07.hostedemail.com: domain of 33aaoaAgKCBo902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=33aaoaAgKCBo902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755883230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAIfYRgGwZxY2d+J+2Tw9OQSooCUHaphp7wteQwPLhs=;
	b=GltfHGFrqGPuLzYbCXV+dAGnLszjFxorbMnBqLi+tPcAe7a6YksLpEbHFkqpWQp4sSMknZ
	oCGZJOzAkvoU5NR4QA/F5HpuB4+Us+oE47taSf2+MsfwlyeY+lcGbg7x5EmozZc4M+mkmB
	HAbKKzOkeM4Z1sRcO47JwjJgGvW/vks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755883230; a=rsa-sha256;
	cv=none;
	b=YciXIXqn8VyZsvMuRFUA67GJxCBf0y2hLjVL74u2ooL2galnvXE5thOlFSvsQNv//g4Qgj
	MagG88s52s3xuuPD9cDswMwJ/XCyN5tQBOgIecZHaq8rUCtP7rKqIqWEj6BZtVugRahpGE
	bhOzKqS0wsWribcaM5PPHx2D6GQDAzg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tCaOAGyv;
	spf=pass (imf07.hostedemail.com: domain of 33aaoaAgKCBo902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=33aaoaAgKCBo902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0071c1so11692995e9.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755883229; x=1756488029; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hAIfYRgGwZxY2d+J+2Tw9OQSooCUHaphp7wteQwPLhs=;
        b=tCaOAGyvb2rJD4oOdkFoagLRse0ACozJUHGMaQ8U6y4TKgKYo3FP9ydjQ2PlSrk07b
         V2I7+0R8jaqEQJ9MFpRMQBVv6JjQfu5BvVbyp5PZE6ToQeuJN2V35qczfJz/NQ1wuJ6f
         7DLmbjmIxdto6PPx0Tcxm/pFrurh3PVvH7wFoVwNKSoQ8KHWNR6KFDTdmY++cHSvZnpX
         RGDVYr3gIR9ZKYGYERF5cYUtk9rqcheEPIzQTwqdyeILyjmNO+DuKUnr4So90csktcZB
         cYCN+OwmzkAfktL8S9RGBiv+EY2uGnFQHfaynpllHIgGjzx8It2yRR2KxhWmbkavgcsB
         0MtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755883229; x=1756488029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hAIfYRgGwZxY2d+J+2Tw9OQSooCUHaphp7wteQwPLhs=;
        b=YUqrre/vq/aDywR94J1O555EtVYNM/YkR98v4o8U7JChaP1kKjeOSdD9tu+zEvR8XJ
         j6QgCEcjiv2vHh2BcEJsto/G8vSK5GyPysHr/PVR569Qpe0YGnhfkM2DU0mytZGqIdRJ
         2ZtH3TBzx3YvFJtqqJhCSKBO1S7NiJ1nh6aHUPYRTGs8iGG/NNzHJ3Ou+QGxk+gtscJE
         INrSoRsiQ1+Q8wxrZTUjSOQkCDNwqsbBadRtpM0NZEUMw0z03iWP/PDuebWRON/njUBe
         eKt6CUUO4jabh3U0CTLoO2w07GnWY4+xrJzHYK1Nv/NYPqRr3bxl9JtK9ceEswnHq52H
         is3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUGiSFM3JO6T8LzjxSK0MTIQaYlfXRVm/gfE7DUJeiygpyNxZZ1O0OdJvav6pnIkdEDYwjPnnKyuA==@kvack.org
X-Gm-Message-State: AOJu0YyhvsNzM4pvkLjFkPc3TqaM94XZ7dd4g0kD+KP4JLO80gfyWyPG
	FWJBjEWSrPmwAqORxltVC1eKgrpLaU9Ji0YzbIWPgyi2eNbaVSgF54dG7L+3TtotN1l/wV3ly7X
	xRirKnZmqmk4Ykg==
X-Google-Smtp-Source: AGHT+IGAQ3nKBaK3QO/Ktb7KuI028hAduXrZ22Qu6Xo0zqvcqENW+BUAAlbLyqUJ713Bt/ANAuJrBwMOcBFf1A==
X-Received: from wmbes27.prod.google.com ([2002:a05:600c:811b:b0:459:db77:fc89])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f95:b0:456:1846:6566 with SMTP id 5b1f17b1804b1-45b517d903amr28510805e9.29.1755883229001;
 Fri, 22 Aug 2025 10:20:29 -0700 (PDT)
Date: Fri, 22 Aug 2025 17:20:28 +0000
In-Reply-To: <aKihQv8fWzZIgnAW@pc636>
Mime-Version: 1.0
References: <20250812173109.295750-1-jackmanb@google.com> <cdccc1a6-c348-4cae-ab70-92c5bd3bd9fd@lucifer.local>
 <DC83J9RSZZ0E.3VKGEVIDMSA2R@google.com> <aKihQv8fWzZIgnAW@pc636>
X-Mailer: aerc 0.20.1
Message-ID: <DC94NN6SM15D.3DQVRLO2E282W@google.com>
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
From: Brendan Jackman <jackmanb@google.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, <peterz@infradead.org>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, <yosry.ahmed@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Liam Howlett <liam.howlett@oracle.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Andy Lutomirski <luto@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98C0B4000F
X-Stat-Signature: dmcbe3h7dhksi566egtx19xtrcq7ngjg
X-Rspam-User: 
X-HE-Tag: 1755883230-664271
X-HE-Meta: U2FsdGVkX18Dh6RLvE9IB1Zt38LnfQNBOOX2NI4ohfIaq0sTOP1wzLxNBt+r7q8vmstDXa1vHHFQzfZIQv2xbDDnglCP73USmuZhGuv1ti9So0rv5rdIyKd3Nm0RYlusKH9PmhB1ANRKN9RLJr6JtG9OIZNX++HsvIVOAUJJYMRthR60zhfw9LJ+tkluo5zqgnJAcdoG7xcKez7vJ6pKV8+KUnmpAqBAzMcCHdIBjIK1WhdWZVQlBSO/PaFlOqFsKCR+QSDkSwRC9r1WAg5xw7ctm4XrxkuydRgwWhNofqR8FAyvuWbh42nRyzXaoO1rK2SIqLRUDRt3Jt5QkrPBKQ6oiopdffJrDJhyX+h5TG3FHaILgwKX6SlxZN/cfPjdjBkGj6iwbk+gQAkMNOmCIlAIr/cfG2eCa3hifROZZqQoqgTfi92wW8V4ok1iIajXUjujBRwtiaSh8OWGUzNj0YJX+ZWWGyJQrDc3jtf9zepDRixvAIk0dbGO3bkq/50dEgvB1sIIaKluSlpwnAqITC+1m04Ftg+fUQCbs0rlv3snllXlhuABwu659d0EWZgvUETFVFA2CAgfTlBvq2P4po6OJnAGuhnEMPNVFqBkFSjtT/gNJiJKQ2+9CrTY1Szldjwxhi0HDxDo4gKfAKJo8mXS+J7fM2Phwyy6W5Guj6VRgMvz6PxMe5WGzzaqzaKqXqvbeLSY/tfy2UDZTw3SOqBkr1kNsVch3mTn7CERIO3rWV1V3cG3+0f9kyC3m8Ym8sfksKq/TzgPXH+eQ6ycH+s4UZM5h44+OGI6dNFINhsxNlPok3Lol7/YY8RA1VykbzbcqKsZDNwbegkW2xTfcBU/m38GpcZEC4PMGqG+6DAviVShqQyRwZ8YauXkRzX+b4o28g7vuvkkdabH/eBag/1LtI4YQBpyffDCehsxFxLUi1sH3GM1fvHtRPx7mSNC8oomH4VDJk0Ijdapb+x
 NVZS3My3
 /SlFLoWkJBPMlBfZ+3SJWu4IhAXfmVOqtYosM9RLGuthcKmEDElgUpuoQjt+nVKayPiIjdpXeP0xiS4Bmpz5svjSqeob/b3A1hv4X7/LBBvYZ6HqF17jgeJbQJO43kRuAyYGEY6yPDPKdc2xoLMR55ECWaiBjX0/tstgVotT4M1Y7joubJ88LE4V87h9YZya3jCXeKlTLd2Mc4013NvIA8/LEnVzCFbRl7Lj0glHoqJLndA0/HiQURZ24XAZzYJraG9IBpzQDgjpzbadcJaygIUSNAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 22, 2025 at 4:56 PM UTC, Uladzislau Rezki wrote:
>> >> 2. The ephmap implementation is extremely stupid. It only works for the simple
>> >>    shmem usecase. I don't think this is really important though, whatever we end
>> >>    up with needs to be very simple, and it's not even clear that we actually
>> >>    want a whole new subsystem anyway. (e.g. maybe it's better to just adapt
>> >>    kmap_local_page() itself).
>> >
>> > Right just testing stuff out, fair enough. Obviously not an upstremable thing
>> > but sort of test case right?
>> 
>> Yeah exactly. 
>> 
>> Maybe worth adding here that I explored just using vmalloc's allocator
>> for this. My experience was that despite looking quite nicely optimised
>> re avoiding synchronisation, just the simple fact of traversing its data
>> structures is too slow for this usecase (at least, it did poorly on my
>> super-sensitive FIO benchmark setup).
>> 
> Could you please elaborate here? Which test case and what is a problem
> for it?

What I'm trying to do here is allocate some virtual space, map some
memory into it, read it through that mapping, then tear it down again.
The test case was an FIO benchmark reading 4k blocks from tmpfs, which I
think is a pretty tight loop. Maybe this is the kinda thing where the
syscall overhead is pretty significant, so that it's an unrealistic
workload, I'm not too sure. But it was a nice way to get a maximal
measure of the ASI perf hit on filesystem access.

I didn't make careful notes but I vaguely remember I was seeing
something like 10% hits to this workload that I attributed to the
vmalloc calls based on profiling with perf.

I didn't interpret this as "vmalloc is bad" but rather "this is an abuse
of vmalloc". Allocating anything at all for this usecase is quite
unfortunate really.

Anyway, the good news is I don't think we actually need a general
purpose allocator here. I think we can just have something very simple,
stack based and completely CPU-local. I just tried vmalloc() at the
beginning coz it was the hammer I happened to be holding at the time!

> You can fragment the main KVA space where we use a rb-tree to manage
> free blocks. But the question is how important your use case and
> workload for you?


