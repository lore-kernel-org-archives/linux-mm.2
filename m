Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ADC6FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 22:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634F56B0088; Sat, 25 Apr 2026 18:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5B56B008A; Sat, 25 Apr 2026 18:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBD56B008C; Sat, 25 Apr 2026 18:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D62C6B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 18:12:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD26C1C0426
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:12:43 +0000 (UTC)
X-FDA: 84698478606.18.CB664BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1822018000D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:12:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IJJFpjCl;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777155162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeXaq9imB2XP6+cv93KE2QqNlUEHWwREDLB3ztikC8g=;
	b=0dtwevbrR4q/Bd7DqlIT2dc6GKFw/CjW2i6N12nuwG9j8GAnI6+miDATclYrNr7M5PKI4B
	CmHn0nfKqHRZUu28+4IEDBHnHSpOzmY2vZw/uoEJfyHn93FIS8xQ7oyNXkb9c0z2ADic7S
	TCKj9CWpZYD150wJeBFvaokUu/8qXuU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IJJFpjCl;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777155162; a=rsa-sha256;
	cv=none;
	b=UahcWm4VL5Wuniq5XlHbKel2cmvVXj5N4fc8yvNg6gx5VSruBUZ3QPYDZpgZl9arbDZGdt
	QT/1vWB8X6befQ3RinESN2vk7x8VH2b4AIx/Vczrqlhc1ijnyJEoJoTy/416SKFDsKGDFL
	GpmXNb5uNTgSjlZ7iJD6Luqfne6HbEc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E18A343E55;
	Sat, 25 Apr 2026 22:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829BAC2BCB0;
	Sat, 25 Apr 2026 22:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777155160;
	bh=DouxsJA2y6RwNgRRZj6nWQu9vyqCaCSBWNXyaOgcrzs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IJJFpjCl4eQKxccsjicKylgLII0fEbujJJLoGlMcUbh++REVkge3jUBio7NJOB25y
	 Q1rvQRGFBzzsNyVLxUSefm9uQJjU9riV+8tZl4FoPYO3tH7sgTzJ77+8qTBZOn5X4l
	 zHT0HxmOLs5Oy6bFKG1FQoVRZ1ajV4ZRO6jDKJfY=
Date: Sat, 25 Apr 2026 15:12:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Min-Hsun Chang <chmh0624@gmail.com>, arnd@arndb.de, msalter@redhat.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: replace ________addr with
 __UNIQUE_ID(addr)
Message-Id: <20260425151240.2a46e3a8640fde3902461d41@linux-foundation.org>
In-Reply-To: <20260425230134.5449498a@pumpkin>
References: <20260307092119.20733-1-chmh0624@gmail.com>
	<20260322144032.7353997c@pumpkin>
	<20260425135737.e79c4b546d22b5ebfd96c0b5@linux-foundation.org>
	<20260425230134.5449498a@pumpkin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: adoe69jry6ghbb5yuy8diknubjr9jotx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1822018000D
X-Rspam-User: 
X-HE-Tag: 1777155161-411732
X-HE-Meta: U2FsdGVkX1+SASk+w//jZjug9rDu6z1hWbeiKQVh+zkcSc+rm7L03Km62Qf+9iuB55Xoeq9wG7MX7h3EatmqR10Ply9UPbypuBK97JERReOVfyXW5fh5xsh6VJC+PJcv9HLPFw1WpuN3xY4uvqVdB0s2uU92EqRhBNAO3PZ7cASg689eFbqO/xqk5NFFipNiDM1j936c3mueSirEaiqiIaxE6Xm0WkVjl5fjYaI0NtbHeccLRZkfCS/UJQ2AcdY7FCX9AFrTAqqCzsH15vPtWSN5KfVWIaRTDM3WGELfxoivZCYv0zgS7FHcsIkQxXCHnYHXdAGebdxp5X66GUKbxYRCeeLnc3wA1qFl8Jt34jJO8YtN5U6//TSWMNqUbST0/MoMR6+AoZ6SmoOXj1BoZLjUQA+rNGVLf9lFp7HnQCVc3Ofk5HYW21hjT6RA/brT/JDSZxaR8w5SGC4QoDbpZGUkLLwcMf2ndXGJm4gOcx0OUWpwV88LdcfjyBytOoPc5beN5TyANfXdwYOYEs6hj9nKnXzGwGwsWZz6wZqosg0bbf3H6WTishZ1PlCWBqaK06DGU34CyIe5SX5gChXnoiD4+zAEw53DuPVz4OSkuZ9MPBrACs/zoZjpCJWsGpm6P3CUnwADNtygiHprwiXzdnBmODs8tE5PC2OOtGTow7ft9kwhw9fW4iKNaotHhSPLdEHQQA3psPlDA6dS9PierFgBKK5wXEAy+OgdRXvPsTla08/aNb2UQc524koTHt2NFcodhIMFIXd4jLtj8+puN2T+fVtqV04fPf4HHwYUguKacFluGMQtWr6glv+dlpfmA7XzKtTYKkqoOjSA2eG7/ZaVZunuRm3DqGI5Ub6x8sZaYezRhZ6KkZEaVwbttwPR8lQ2b7T15xyJFc/TTg1lc+pgqSm+/XfyjL8sed/bKJILREfQMIXNQhi0lns1re3Mun1IKNnDqn4GS80yise
 c6X6tGyb
 TzuPVhuaXJh0AjhN3ITwwYi4ExTFyqb9AQLvYxczzBkatwkIkK1rgrHr8TzV4NCkuei3XBcFd1xNfIfhyy4r5UE5yXKMqs/Eq3u+Uh6PVztGYefYVhsxidFM5+IYRqi8wK6ThYdWjQJ60jDBYlslbbBV+OBDmx12UyC5M+fn+VUsSxwzo1a70n3SaPObVfk42d1AryJHHijx1w9jIw7PxCqtofLeZsH5DPWxJGE7QW0/wcZLRk0+y7el1SKjuXfN8yiohbjByPVXLk2I1s6aWuIfwrJ4+a+rV7C1vrxTKpY69QmCBJfqWYVs5StObUHMThYpqT1zIYMzBlXGJAHWcYKfZbUsT8aAXbEDAcLnJuKjQt6Hu6zyenqhxBKGOdRG9HysxbMEZDiCQPTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 23:01:34 +0100 David Laight <david.laight.linux@gmail.com> wrote:

> > > The real problem with this define is that both idx and phys are
> > > expanded twice.  
> > 
> > The real problem with this define is that it's a define.  Why oh why do
> > we keep doing this to ourselves?
> 
> Sometimes #defines generate better code because they are expanded earlier,
> and sometimes you want type-agnostic 'functions'.
> But neither is true here.
> 
> But I think I'd go for 'always_inline'.
> Sometimes the compilers make silly decisions.

Gee, if `static inline' misbehaves then we have big problems!

What's special about the fixmap code anyway?  It's not exactly
fastpath.  Perhaps this stuff can simply be uninlined.

Pet peeves:

We use too many macros.

We inline too much stuff.

