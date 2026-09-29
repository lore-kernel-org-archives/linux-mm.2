Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE3ECA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 00:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA686B0088; Mon, 28 Sep 2026 20:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07ADC6B008A; Mon, 28 Sep 2026 20:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2C76B008C; Mon, 28 Sep 2026 20:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE09C6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:26:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 530A1140390
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:26:58 +0000 (UTC)
X-FDA: 85264909716.28.8C2A80A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9068CA0004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:26:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rM8abSJi;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790641616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlkW1KaRsH/v2Yqvm3jPDzSTULrt4WXrqo90mO3Ywz8=;
	b=qyIsAo9lB5yyreKSvlyBmGkBEufkQ9UhN4GGFVfWpd8XvWVUEyXRPdxHl5RiF+lraVWqf9
	oLCbzL3GcnlABEdF/ko5Mlc2k4QUfLSnqMSXv2JXzgZpbVXar4gFdYmhJnSatCm/3EjECV
	GrpwjXqBZrgxvdQ5Ju+ok59f0UM68ls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790641616;
	b=fR3LWUCz05Jt9FAZWG0KFHWDlaZyGhsi6P7/ZAy94KcSvjm1nhwvkb342ml9Gpp8SK/ihI
	oYM1vd+uU14xKvP04hYxvHGUUIl2I2EPf14AVl8fmCqMpEXwl987mZb6ziz4huf46Z9Z9o
	ElrnwprtJfMdEoxT0G6L1gRJwFHUcZ8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rM8abSJi;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDC3C60136;
	Tue, 29 Sep 2026 00:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A1C1F000FF;
	Tue, 29 Sep 2026 00:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790641615;
	bh=zlkW1KaRsH/v2Yqvm3jPDzSTULrt4WXrqo90mO3Ywz8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rM8abSJipd+2kXzuONq7RkkMTtMCsw3Tzq2Y6uYXwohjlwx+4eToWEGmvsj6g0sU5
	 dnklmCbQ/b0hbiWK/3Q9F/f/UGeRD40WxiaE61aDW+hpU9JSG5CsGHIhdluh8HeSbu
	 Sc+ge/+B27KUNHKsxV5OO95BJ+B8Pm7KWCW//v6E=
Date: Mon, 28 Sep 2026 17:26:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>,
 syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
Message-Id: <20260928172654.7030810755eefd2a1503a0ee@linux-foundation.org>
In-Reply-To: <f78d2f52-1135-425c-a3e8-460a6e80e19b@kernel.org>
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
	<9efc7bc1-8d9d-49ac-b856-003e81558411@kernel.org>
	<20260924195826.70a87d6fb78d754bc73892cd@linux-foundation.org>
	<95e91b4a-ca16-49a3-9a1a-5b38afa6f08d@kernel.org>
	<arYnXJHW-Rh4eNzt@gremlin>
	<f78d2f52-1135-425c-a3e8-460a6e80e19b@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: oqcutiqqxwyymp7qcqboc1zs69ztciuq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9068CA0004
X-HE-Tag: 1790641616-727014
X-HE-Meta: U2FsdGVkX1/M+p7p0rmV/jTRsGgd2E5ib328DaHNwxspFc1/gT1yOLwa2JlAePFqoxcGQBUYKzbO2JWtauVwlkqjkqHh3XCV4KukXqJq7uJgKV8SNPzlK/PvZ5dt9Q+JqJYNEfbo/fVaEk0aZhrbuzobtXJJ9q7AJM7ujOHYLjrOWb+9dYLRBwBxtvWuMkAZQze+W1g8sO6t6hghhPLNRiYJjFQKcX4tqYMb6W24moc5zbA37vNp4t3l5UT7+i9bCyQ0NaqVJLLjOhv6Nzr9YKjHC5vM3f601mZ608ehtEtjCXE9lAF2x8VIsPgbt1tuSCy+BBj24BRKVhHc17Y31biZIWmuUBX+3l0nBFU6aKLW8WBpprFmzdMRiRUcpxJWnWLptHsGYeslbJE3GubRvI3waP+eRggt3LCQaJcvetxK5k7+cNaXm0+MweMXUjL3hUYSjbG/+e7TN9GHd+EcHPK/m/x7Fl60C9S2VuLf3GFj8VcpEinFNRRcaFy0Ay2B9wC4y//UU7j2M1aCZsbOuWFvHQQbt/j8sleSx7puhKvtuJPZ3rZXYm8YFHAWUQ72scSCUGLWphsm5ojyF4R5TPOwDr2sWuQmMj/dcSnd1RB/V3tSo5PK/Yx01hYcZUyZCId+JXuVKiQOFdaK7tHOidVaP/dR9pZ2ez+lW3H0bRPXLAw79SWkHUDc8+QXE2L8Datpzk1PnwKEpje+ybeM+xf3bvIvUW1s1B3gNKP8z/TZ/DsChorTxUlKaWCv8fg8/hktyNI7azul3bkzqlFcV2uDcqfsQzP+tRGu7Dy4dnUbxapNJf/gY0dNPUrXhqbuMVuWG18qcE2XLAeapxudEM11Zlyfv7eCbvKqvoCfAO0QcdREY+FdlhCeuvQMrfVghZfM0YaaPSVRm/VYub601lUvO1qB8Rw2EvvngyjjqwG5mWA699Td0MVv3tdb84RvkwYX+cnPG1RYEVD1cV1
 +GPa7fw3
 h3IfKDo0O2EDh5v9Sp5yFTy+6a9DYDneNNe9XcunrMOY826pj+MWyH36kMbiHcP8JQhsrbWHBSeEcL5JThEbp6HlPzcijV1/1yorFG2z4UoX4Thxzbadro9jihrq3Dsq8hKI2/xMD4ZKYajXyG3FKJTOVXXoKY6qNnHBBYRTmaTgrayWzS0B43exPE5g1pKCQ7uAzZzq2qA3EXL8f440p3ojpZTCrJrYcCohbLoOeLKh3uzskMxJKHkKGA/bLl/9+meP57SDWWes9Qg/972rKOnMbPqe09fj/a+qnnoKdk8H+iPEwIjhWhDwryF6efNAz2QGkzGwZy+2rg3ofjCHGtCdNJALwN8ES7M86ZLJ2D+AQ9h/poG4e0Q/waOcewpnhJzll2/tIN9A+a5r3LxnNu9CMGagaS4zBijgEA3wCPFsaXnAZBB6YEEU0alc3zlckz06U/D4rPthl8gs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 13:59:47 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> 
> > 
> >>
> >> b) Do what Lorenzo proposes. This will allocate real memory. Someone decided to
> >>    use MAP_SHARED, for unknown reasons, so I'd assume it's unlikely that
> >>    something breaks, but you have a point.
> > 
> > I would say this patch is the right fix for the moment to fix the assert, and we
> > can chase up with other approaches afterwards.
> 
> It will get backported, so we better be careful.

I don't think it'll get backported.  I hope not.

The Fixes: target of 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track
MAP_PRIVATE file-backed anon folios") is new in v7.3-rc1, so this will
go in as a hotfix against this -rc cycle only.


