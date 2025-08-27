Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 750FACA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4106B000C; Wed, 27 Aug 2025 11:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963C76B000E; Wed, 27 Aug 2025 11:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852FA6B0027; Wed, 27 Aug 2025 11:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7208E6B000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:19:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F06A21603DA
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:19:16 +0000 (UTC)
X-FDA: 83822895912.15.6EA6308
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1DBDE160010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:19:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zsyi1d9z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 38SGvaAgKCD4ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=38SGvaAgKCD4ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756307955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26+u1vZm8GxbnUTWqM0HadqqbzPHef0N7bih2NyHOqQ=;
	b=4jNfMvqfbB2ywC8Zr/hxX6izZCe3tQ5Ey9lVZzwvcWC6Zj5fRvDkMjGu7Cqp4n3WSNLKip
	xs5kWiLJUN4i8coQ33frDMosop6JnhI46vg4QJ8LvO+dTqGd59dkikI/wv33W/y5VlqX1Z
	+fNR4vkrDOs3Zh1dOw3aaykLjKubDXk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zsyi1d9z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 38SGvaAgKCD4ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=38SGvaAgKCD4ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756307955; a=rsa-sha256;
	cv=none;
	b=c1R/gvR9S+jrMcUqMZ77mz8uXuqVqQilZs65tgMAM++7jIPjd6E9ED60KRt42LV2hTFR/S
	WPTDxJz88sWG5hEoHyuDfetFeJEko5AOJ3GYxbMFGfaiIzdTG0Zu2fBQoij4/k2Nw198aB
	QLcoOQJwVmE3YiVWZAb4ofB3hz5PBHU=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b71eef08eso4481835e9.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756307953; x=1756912753; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=26+u1vZm8GxbnUTWqM0HadqqbzPHef0N7bih2NyHOqQ=;
        b=Zsyi1d9zMEAOQhgnddEzT+SjtpiH5yYPmMOI7ycPoMe8XISpGHSv0ON+/T3f53v4+j
         iXI0/vHELbwD6UG9vlfg7xiJlMeuMvBptHBPfxQ/iSkgBdCNBasg8ohbWxsICEk0vh4l
         WSal8TXR+ZbX5Ok3+P2IlStMlVV3DnU3dorlD8goXCnpIxmRzheljsOfLTJU8Zp/Fk9C
         xg3EJcCzxg65eHTQM7piq9gz2YTbX1zFv8BHu2s59AXU3fRFEAvuF2LojH4GHWLzsQZQ
         JFveCUC5dP380zAfwtcJ7Uk5A14RTGoUUIrtcROBnNQBqiOs1k6BfJxIHfcPhW4rQWp4
         e2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307953; x=1756912753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=26+u1vZm8GxbnUTWqM0HadqqbzPHef0N7bih2NyHOqQ=;
        b=HzNgm2FZCA5T32nQafL55WBRmf8vAl8mBEaeMlVwW0BeC4lkHhDOurqbPzvFmDNiNR
         JZy+i4F2b9RrENUc/WF7iUr7KPn6wKMM0/0zKE4tOR5+4PbCQQkQv0eO6BF9TYAoOoPC
         r7R1Ew1LPBdpOHDlRHTsjgKMjrkwJOMAtb89Qxyr6rcGB5BoXubfttfKM1j8hejo7Uxl
         Juw2ibqinZpZcKSf+PiFn6XXoh7ZOWUC48RcPkqbdg3K+yy9OyV0K2PmGszQU6oYfnJg
         eyo0PF5nVGGWFej2Oq7yRedGNgusYdcp5jUw7Nf/GEcHiZaPEruDhihbaz5Rtr53ywiE
         uX2w==
X-Forwarded-Encrypted: i=1; AJvYcCUvSkdSuwqPM8wSt+qTJxZ2Jc5tsoGjPZPjJ+MJjwLFX81UmutME62vDAX5SbbG1nnj8prJlk2kwg==@kvack.org
X-Gm-Message-State: AOJu0YwGy5cSDVFqNLDIfisBZvEPylKPjX67T6D/xA1iwIyQENvyQC0t
	BCJmmrwWti5siKcWtddev0R+G7qRxrU0NifI7fPcbQntWS27+xKLW1ZeqqHmdBi5q9SFIXoxyRX
	lZzx5fSW1blpidg==
X-Google-Smtp-Source: AGHT+IEKQVr/X7PUctYr0S2ZQywjoScHzWuQZ6wJrsqpJVFUkj/CHPN4LgbezPeCJmgfoN7X2qZ2PUA/itWFng==
X-Received: from wmbel18.prod.google.com ([2002:a05:600c:3e12:b0:45b:732e:5a16])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e8a:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-45b517ddbd5mr183215045e9.25.1756307953668;
 Wed, 27 Aug 2025 08:19:13 -0700 (PDT)
Date: Wed, 27 Aug 2025 15:19:12 +0000
In-Reply-To: <xz2m4q24kgig36wu3enk6qlsxo5xywsaffgivyubadsps5topi@6yupqs7b7cze>
Mime-Version: 1.0
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-2-5d3a94ae670f@google.com> <xz2m4q24kgig36wu3enk6qlsxo5xywsaffgivyubadsps5topi@6yupqs7b7cze>
X-Mailer: aerc 0.20.1
Message-ID: <DCDB7IYZS73V.2KL54A53D1O1L@google.com>
Subject: Re: [PATCH 2/3] tools: testing: Use existing atomic.h for
 vma/radix-tree tests
From: Brendan Jackman <jackmanb@google.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, <linux-kernel@vger.kernel.org>, 
	<maple-tree@lists.infradead.org>, <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1DBDE160010
X-Stat-Signature: pnqhuiqw4iayz8p914y45asywqzhqie1
X-Rspam-User: 
X-HE-Tag: 1756307954-655239
X-HE-Meta: U2FsdGVkX18izom/LG6lI3NR/0VHABXOawgEtgyxRDDMUjzI8cVB9uXs/Fa7EtfzIT8fGLt8bsgWs62NZN4GziO8D3J91IgPzdL5O8aT1NhuvR316+PMpnkNfLbbvlVOiBfhjiv7lN/s+3lmsngw8NwIElJjLEKgcpjNQgzYWmcv9IL7MxvCtkZj/0Gma+DP9jqIKKQsa8gH33EiVZqI/CsmrAGcpaJ0U+xDdrDX+/HZtLjojzeJfh+KDTUNikb8JG87nneKyjhK1PipNuWxGM3eKOhV1oK+tOEAJZr961xDT741QmvQBRqowtFAKg+vYjyRayfZiKQ8PhQvR6JXJLamaGiv1KL4mVHoHTtgmKx85ZZInd0pkL1Fz9P7IZftJL21+vej77/w/jjCAD7GGTm9M+9s0nvpLforQRg/4EJaJyy03BUHvpRNejjUtgTQ3PWYynAemoNPAhO4NQWl/cw8SorOthCgYNeqhtCMVdoppt8/7VbGvjF62EKtOorPLTFD3jcfIzTm0rEL4w1eQXgNuts0ydc45JiBW7iMjJExVks3hEyO8QbpVfThsjNh/G4wOrULicfhaGheJD35lt9uBbp1ZJqfL6c7ET1bTzUy/qpAK38rwVCj9tyYVHxXnHdRNwRUWoqESKJYrdPhXPIR6qGmH+BFNib3tZZhj934xog3YxmcjgNvSgynLJUQoTkNxLStR1G9f77iy3Qon2WlPtQM8aIzoPVRIX5jq4bIlHwcpZHaxJXwJpRre3coY1jNm4kq0C581ekRMHPnm7dtltoA8Ea+63B8PmUvE8c1jrLbxA8aV5ogbRWAOoTW2we5iWpfTf+05TMekqHTWwxqFbX0AdfThd/K6VdFnOR/MFPCsUJGwcWfHlYXCiPgag1fVQ6C1ggUV/6h8I8RtHzNojcDDJbEtub5E/5dO0j6OQNv1dkO0NcIwR1sdik21QevHXsSqRP4GIrFpgC
 oEi4qndY
 zEVprLBEcVTRkSUoCwBpgqE27NroeSUUvQfUDeBomQ2B/PRASgbmt70XVQQubZAYJcz4OFk83l0mRlCFEIl4tUyLD0Nw+T27nmh6Nv8VohNgryH3bKlmuirklh20tHlJ58aRhJBp+dGDTAc2aB9t6EQ31X1y/nnhG5g0W2bg6EQYpcfMIpbgOdH5yF4zJPx0Yqmf0AQ9d6yUiUd6Lb4W8tTBDvi1NYoOQMCNFmlYb5gQptdURln5gG659M/6ot08t3RjJtDRvxyqCoqM+5rs54EZe1l9LSmTMZTr3FbSEbB4xDR/MBoomlwqEKQRntJ2om+sN9Tvl0rwM4EuyCBDO0AKgV8xhmhkPz3a2+SgtZ0n1WgahSumwg1N8yG56ne660ZtUPUFY6parZ/N5EuP2QNFo7GtHNeHraa4XfmSx23mSnhul+1PgVORZ/SMY0W/wtbwaZzhG+DZdrpf1FM/sdORAOVBnL7U/gNBcRLrKDdwPC9rLh9uuHK2y944Au8tGY6vCctoV1I+X55h8smKG3kqsNznV0ZkhxlUlp2hzmMuXw7ayTNi8avZZa2XvDR054kxk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 27, 2025 at 12:56 PM UTC, Pedro Falcato wrote:
> On Wed, Aug 27, 2025 at 11:04:42AM +0000, Brendan Jackman wrote:
>> The shared userspace logic used for unit-testing radix-tree and VMA code
>> currently has its own replacements for atomics helpers. This is not
>> needed as the necessary APIs already have userspace implementations in
>> the tools tree. Switching over to that allows deleting a bit of code.
>> 
>> Note that the implementation is different; while the version being
>> deleted here is implemented using liburcu, the existing version in tools
>> uses either x86 asm or compiler builtins. It's assumed that both are
>> equally likely to be correct.
>> 
>> The tools tree's version of atomic_t is a struct type while the version
>> being deleted was just a typedef of an integer. This means it's no
>> longer valid to call __sync_bool_compare_and_swap() directly on it. One
>> option would be to just peek into the struct and call it on the field,
>> but it seems a little cleaner to just use the corresponding atomic.h
>> API. On non-x86 archs this is implemented using
>> __sync_val_compare_and_swap(). It's not clear why the old version uses
>> the bool variant instead of the generic "val" one, for now it's assumed
>> that this was a mistake.
>>
>
> I don't think it's a mistake. Namely we're checking if the cmpxchg occured.
> So in the new version you'll have trouble incrementing i_mmap_writeable from
> 0 to 1, where in practice you should (AIUI) see 0 -> 1 (old val = 0, retry) -> 2,
> which is obviously not correct here.
>
> At the very least you'll need some:
>
> do {
> } while(atomic_cmpxchg(&mapping->i_mmap_writeable, c, c+1) != c);

Oops, yeah my code is total nonsense here - thanks for paying attention.
I guess I "got away with it" because there's probably no actual races
going on when I run the tests...

Anyway I'll apply my brain properly next time I get the chance and send
a v2.

Thanks for the review!

