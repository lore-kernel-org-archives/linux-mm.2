Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25793C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEAD6B00B0; Tue, 22 Sep 2026 04:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6B96B00B1; Tue, 22 Sep 2026 04:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5AC6B00B2; Tue, 22 Sep 2026 04:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A66096B00B0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:57:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E32D1A03D3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:57:25 +0000 (UTC)
X-FDA: 85240794450.12.B04DDFC
Received: from mail-ed2-f31.google.com (mail-ed2-f31.google.com [74.125.228.95])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C05020003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:57:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D5KWXKWD;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.95 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiXXKr6AQsDe2gm1Pl8WbMsoWdC+iaoqvgtPe7PcWE0=;
	b=XOhBVeEOsoaGuCAOTAqid4vAwWOKpLqo4FG1wwA/n3Sy6lNwoyzwWVORxZEtYhX8sdDntY
	BN6oTBUExTYi/sPgfBLEwBzOWeLlbHVB+rNO9qfCUsaqgobAifFg779Ut6OXwqrmZBvs9m
	KYOCsKSetlrdIiHLgSrljv4g8XKX3RU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790067443;
	b=AHOMh4opziufKvjmtTzhQEliciVBNHzSHu2mVznVn7Ar5lTLrN56rUOuOhYEiTBIu4LzE7
	vBtRDFlrx8gsFGQB4kPcd5XlSae9O4eRL8CSdy4e+pC3iRTMZW6wJCVfIIkJLwVKDFXm5l
	bOt9/cV+Xewejx8Ev2S42ZvSAsHqINA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D5KWXKWD;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.95 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed2-f31.google.com with SMTP id 4fb4d7f45d1cf-6aa053900f5so6494966a12.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:57:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790067442; cv=none;
        d=google.com; s=arc-20260327;
        b=kOkHQylXeizDEWocOgTmMHBPwOeQ/5rCJU+K/o+u0Xb2CUjVfvw5Fg514455wlvHn1
         0TagatIBRlsEtcAefFjzdJmWm2m/EzzpHMkczp09GIW0xx3alYjv0d86K6SGEyiLKxN3
         5in0O9pxI9t+yjYSvas/q5nfKP0gUrJhSi6qGxLq7+QhMGoMVzS9eAA6JvjOI8zBcSBm
         hWEU3Vhmg9WmInUAS8+TLMNs11H5zLa00b58yJk/S4pgMQtuS2VqYMevCyTodA4+4CEl
         hCLbuvNhJjJUSLn5cB3bpPbJyodFK/JXrVO/u76crrtznvSjxTfmISHGyeMk00rOFM1t
         TSaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iiXXKr6AQsDe2gm1Pl8WbMsoWdC+iaoqvgtPe7PcWE0=;
        fh=Q3/9bkxvwkb2aL4qokXiAW59PbBdGxYseic0FsVXj9k=;
        b=rErN5Yfgt9kgor33KCYbTYN2APH/xJMFHhxHf175pMb+R9RwWgEzTPgSxJ5NR2X5M6
         oVAdMuj4AL71/lsUEKGVMV5OnCs0pq0TIexeyzmu1+zYr1mDtE7yI30RHD1spXXavYzL
         8WGjibFSKmo22evFq3D4JDtVLg3OWGRATCwMEXZY4Y1v6WAPSIBRXtiE9uD64+/oLhHl
         7qdx6tiUPWyXTT2iIloq+HgTpdwR/R0Tag1rpR8iuAr7g4kGci+OjaMhmXXic/IPqjXR
         dGbDmgCyN+H6e4v4dWL1UD6f9ouL9O5J6JykkAfKMJIqZK6VKwPadKjktfgTOSZQxQ54
         Y4QQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790067442; x=1790672242; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iiXXKr6AQsDe2gm1Pl8WbMsoWdC+iaoqvgtPe7PcWE0=;
        b=D5KWXKWDux8IN+vjww9FEUnrY4fjgPV3UIvYqhbnlC3b5GAMhgwBCgPYDisGrg2B7t
         tGZSKjwcwUjbKnNpSLX4/zSsdBHo1b2xeu+KRS3Hk7eXtPr2H1/bF3WJVhZIbVjwwFM6
         s4bNN3phcFntNHKLRiAct+2pgEQsbQ5A2L4mrboqivvxaXIl7Uf2va/CFG+CipQJ1Ya5
         afsAfUZyW/cUbg/D8Od1c3lVWheyFudqfjhqgjQVljk+5IHj1x7vOF6CBmjvwfAM2w4x
         KpjiZNYu4upGZE90Nr8cu8mdq6OA+CMx+2V8/x5rGLvYpqF3FmjPw2cHNBRVd3bT3oCc
         e7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790067442; x=1790672242;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iiXXKr6AQsDe2gm1Pl8WbMsoWdC+iaoqvgtPe7PcWE0=;
        b=1adOnoL9JQmFGlGSpOk4xTL7JttglfToLfYg2Pn7Mq3LBJfrIj/fMAkezcdX8Ee4LT
         NE5fxFTEkkGFyH5ja/doxjKtrE4pTgrLNJ97q2oY6KAFrvjCyPRwD9zuqlifCyr1e2uP
         HUJW6+tTBjnOaSHtHjAdbdEVCcTqIkRspBh2gjiE1Vqhg3T8eqqr4JoYA1mAStFfjFvQ
         qyz9+i6QAJErQ/8oGlOWvb5bwk5a2xPujAZbAQrJorvWHNduknG+ptQ7X4E6g+zdhKMQ
         Ptrl2qzwaFv7CQrd1bfYpD2uQctGk7cVfs4G5RK+2vW6vd/cO32uIf5nG8PNO5/H2wU5
         ImAw==
X-Forwarded-Encrypted: i=1; AKwUvByZm5XU5Mr92wnSX33QabUzbIdF74HE4NIvVdLqKmdZamtLSpAhyDP9qrpCzpV0BSdLwL76KXO9eg==@kvack.org
X-Gm-Message-State: AFuF++lnkWHTC2Xa2lDeeYuabWSYdpZTyUAO2IqjFDS7W63zIbDNtv1/
	QCSL78xQhByjWqBGPUl7kCC9clSl8BH1hqwAtPsinbBgaonTbEYMZ8N4HGTORhZZsPaz+Kd8O+W
	fhAtFtZZpaikunYqp6huwfDVS/svDQFE=
X-Gm-Gg: AYBFou2I9dOm6WJsnTdf6xng/71z2dQ9xBdEQWAI2+bxWXmuucBQqDnNuTaIboAgrFo
	D8KS/0mHXBQjRfeYg+ul+F+xcRDjmHcMGxLActI89G8sfUmLyZscy3x9s28KBZh/k1BDXnk9PVZ
	kN4Susmshfc7BA8s0MJqWOIm3yaLt6gm2tONy0FHvMMesJ3oilhqZhBbDeJIPgjXbqBxngfaoUT
	aE33DREwXTucRcocLLtV929XJsXkcP1nbMGr2TZCLNqmJmqBDTws+uNQlfZeB+ufFlNdJCv3CJG
	vZf8IdwFULJBekptMEd2X2agwKTNthCR8LzTPJbBgP+q6tEGfwxLR64awBxOgxvI2rjzGK3sl/r
	wWTgILNgQ32uiuIme2ec9uw==
X-Received: by 2002:a05:6402:e98:b0:6aa:a05d:c08b with SMTP id
 4fb4d7f45d1cf-6aaa05dc232mr1725470a12.25.1790067441280; Tue, 22 Sep 2026
 01:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
In-Reply-To: <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 22 Sep 2026 10:56:40 +0200
X-Gm-Features: AcwNN1XI2j9cIScZ408fYBNwmh9MTw-tllmDtnAwPjWo0btydNjCZVpYmlUUn1g
Message-ID: <CAMgjq7CpRg_5aMiRWFxWTYA2b1mtHu8YJAtvRRAy3SaZg45t-g@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	willy@infradead.org, jack@suse.cz, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu, 
	hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C05020003
X-Stat-Signature: n7dxkfo4dona9goo7iek65dqoxuonc1g
X-Rspam-User: 
X-HE-Tag: 1790067443-107846
X-HE-Meta: U2FsdGVkX18d4Z1kwkXKauIH9iIZTS1RbsaSoY9AQ8msZHjYcHgX48tAfVqE4tJ9LiiU0IbP6uCYWyCPyJkYkzei+IQHMVSYRrE6DWDHl8z2yGEnzImohntDJQTkvPF5/5dCHrrkoUEh+fa4h19edZFkipDwAnFv1PA4OSPsM7rVii8kuh7Nr0bHcWAn3vT+pR1sKNkjQaTTMj0eOHnTOwPqtip37htL8q0vjKcsD/Car5hgRUn2OoKU8KaZ5eqoTxFchjJ4oUT24+RB26rD/EEAapqmirl6iozJ/alqcCXSKwIZn4p30hAgs/wwY7fnqDc/ahBQzWvAShPG/n1e7NqLGBcne7FPpip2dNJb5ra8S95OmMszpFaVBXXTDlw22bRiQfjCbkfSnIzUtJ+oD+h7Vg7wb/8J/HBUdI1rm8gXj7v7df4EgbUZFuAQzGvV6vPeULHOV5aRdf6iWpbGb+hJB4GAATxWP4gAiVo2zqmfrg/gxaIkOoypjjc/EXgqngBikfV2/1CBd+ROkTl96WlS+AnWqXAditRSW2oBDFHbldfzpHJOF6kdft9CFYeU5BBJFxg6+OJT2atDlUos69duEIuGllABm8ttzQ93pk0SVHw6NpoTLmDmXZABRHOollowEdsGTdcnEV2ij0agMPNVKlDleEeD/DG31uaqyewKjjyjsjIQ/vMsXBFIJBEBW11sMO2FEqjLr9VC7W51XcHgmo4wbPdO1UyXNch9+xVReHW686k2+9k+nWI4HB6bNWayywVXufP7R/8SMzjUMs970sDz/qV8ntWUBEeK17FEYOAFMT3vvMkvHDpaKmysRBnLDg2pMEwGSerQMFURPSRKsetRemJ2mWlOHXvoe0WsxhPhZuigp7kxmKaQukA7CA+fatyLaYqfnVqK3ZW6WO3e/hlPZgETo0R/WFPb3vda8cO4TKEyhMiLG2POwK20usMPSAtBQMdZJtd4/9z
 GkEP3jXa
 v/iQDx/cqkTHCexYfSd4crqB7DqufpSFGmsaiRqQNTCMzQtgCLqMXmKqO3H28rf+6GDfGL9TW9R6izqHFkcPApDSA2Zvx+98x4FZv1Ec9TKi79QS00vnV4FTlx9+jjE7n+FZSslEbtpkOxWUrFarmeRVvjvd0USK9TWkd0oUtZABOt0EvRNIZi0usJazEyB16hSuScXVB8ZNyxWRsahBh9vmNKGEWmmUF8MghzDFIEQ18MofzZojhFvx9cO/amL7fHhkGoKQzeZylSOkXXZ7HntE8IjZi63MdiIs9MVxCubSlNf0pN1GXOAJFokc4TGSE/4T5i/EOVS6y5Ts4gzwivNoLBRQS8hok2tdFqKtdv9wjWKCQPkwymMvrjpBVwMe+L/7WOHztF+cDqSMZikKrkIuTeEAFAGl3jlalcCksvG6adXfgIkXKQIuvee621dIC7/1NIJqsaLCcjn1XOcOo9/U9l41xMG5L2SQ/1xQvSKnNksqp8qYlY66Up4aoyByko1xGHHQqa5KJg7oudJZZZr99pCbcSLVtdGz8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 12:00=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
>
> On Mon, Sep 21, 2026 at 11:37=E2=80=AFPM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 9/21/26 17:24, Alexandre Ghiti wrote:
> > > On an asynchronous swap device MADV_PAGEOUT only marks the folio
> > > PG_reclaim and rotates it to the tail of the inactive list once its
> > > writeback completes, so the memory is not actually freed until a late=
r
> > > reclaim scan removes the by then clean swap cache folio.
> > But we have the same behavior when just reclaiming memory ordinarily? I=
t's added
> > to the swapcache and only the next scan actually frees up the memory.
> >
> > Wouldn't we memory we reclaim ... just gone, like in the sync case?
>
> For synchronous I/O, such as zswap and zram, the memory is released
> immediately after sync I/O is done.
>
> For asynchronous I/O, such as NVMe, the swapcache is currently
> expected to be rotated back to the tail of the LRU and wait for
> another scan. Alexandre once mentioned that when he tried handling
> async I/O the same way as sync I/O=E2=80=94releasing the memory once the =
I/O
> completed=E2=80=94he saw some regression. So, delaying the release until =
a
> later scan may allow swapcache hits before the folios are eventually
> reclaimed.
>
> But we actually have a problem here: this rotation, which puts
> writeback folios at the tail of the LRU, is not reliable at all.
>
> `folio_rotate_reclaimable()` would only work reliably if the endio
> happens after the folio has been put back on the LRU head, rather than
> while it is still isolated.

I think we might better fix this instead? Or is this really a problem?
If it has PG_reclaim, it should be putback to the tail instead of
head, right?

> But nowadays NVMe is very fast. If we isolate N pages and perform
> shrink on them, M pages may finish writeback during the isolation,
> while the remaining N-M pages are still under writeback. M can easily
> be more than 50% of N.
>
> As a result, we can end up with the following cold/hot inversion:
>
> LRU head
> ----- M pages whose writeback completed during isolation
> ----- other pages
> ----- N-M pages that are successfully rotated to the LRU tail
> LRU tail
>
> Now we can see that the M pages were expected to be reclaimed, but
> they are not only left unreclaimed, but are effectively promoted to
> the LRU head.
>
> For MGLRU, commit 359a5e1416ca ("mm: multi-gen LRU: retry folios
> written back while isolated") added the following code to reclaim
> those M pages that finish writeback during isolation by retrying
> `shrink_folio_list()` on them:
>
>                 /* retry folios that may have missed
> folio_rotate_reclaimable() */
>                 if (!skip_retry && !folio_test_active(folio) &&
> !folio_mapped(folio) &&
>                     !folio_test_dirty(folio) && !folio_test_writeback(fol=
io)) {
>                         list_move(&folio->lru, &clean);
>                         continue;
>                 }
>
> This somehow resolves the cold/hot inversion, but leaves the M and
> N-M pages with inconsistent behavior: some are actually reclaimed,
> while others remain at the tail of the LRU.
>
> For the active/inactive LRU and `MADV_PAGEOUT`, we don't have a
> mechanism to restore the missed reclaim opportunity. Ridong's patch[1]
> addresses this cold/hot inversion in the active/inactive LRU reclaim
> path. To my knowledge, there has never been a patch to address the
> same cold/hot inversion in `MADV_PAGEOUT`.

MADV_PAGEOUT is a bit different from the reclaim under pressure,
reclaim underpressure can easily overshoot the amount of anon folios
reclaimed, because however fast the writeback it, it can be faster by
scanning the LRU and dropping clean file folios. So before LRU
reclaimed enough clean file folios, we can't stop the reclaim.

I think the better fix is to have a separate watermark for anon / file
or a new way to handle reclaim. Reclaiming an anon folio is hardly
helpful in the short term when under heavy pressure and the device is
not a synchronous device.

The overshoot is a real issue, it's very common to see many folios
stuck in the swap cache after memory pressure. If we drop all of them,
we will see significant regressions. Treating MADV_PAGEOUT differently
here seems better.

