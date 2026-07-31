Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C88C55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165DE6B0093; Fri, 31 Jul 2026 14:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116A36B0096; Fri, 31 Jul 2026 14:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005556B0098; Fri, 31 Jul 2026 14:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7FD96B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:34:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 420EF804BD
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:34:43 +0000 (UTC)
X-FDA: 85049922846.20.2AAD8C4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf27.hostedemail.com (Postfix) with ESMTP id 06C3C4000C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:34:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=BN8J1Wah;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785522881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrDeeylJuieZY5hBqbOAQJHhoSSI5F+J3jqIK/WRh7w=;
	b=G3poYbTUOcb0f1Q/IRHwnkXWxPS/LwYn6ChRKUOofQ7411ppgdm1MjCFfqeDnS6XrZ0vlT
	0EwB61ZZIpE/iG0uoi7kis5ALkLZbSjBvIgKv0CFW9lNE9m1YnQ2KhFw68JYnPWXLJanoT
	P7nm/ODCxsvWMJDjxXAtZJ8rarK3vHA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785522881;
	b=2E8krDxsn4fi9yG35G6PTyo2TUHyspnGOMztUlAwp2SjwlOGcEQMZHWIOZ2qJQPGf7nm8u
	dfodVXDj/w8UCCo82fbAphIbQi1/RiAeZOcqfP+d5pfxyR324QTiTPU8DpexFXRdO0KX/D
	+XUg3gsrvkVyOryy8WlI27FotrrHV1k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=BN8J1Wah;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xrDeeylJuieZY5hBqbOAQJHhoSSI5F+J3jqIK/WRh7w=; b=BN8J1WahJZOavl85ADvcDRCj9T
	cbOM/qrJY0R+3M3eUyLZAiA/xCqudjerivPytegxduDhpxg5s/7hGqHHOhtlK9A7ppaYQ5uj5EtOI
	gY7qngrmmkatQHIwH1Vc8JfsE7K4RXiJpNsRJd77J3aLz0c8AO8kjZn4FMTce1stw5FYJ5JUmJCVj
	Jbg2aHzcByN9r+aa6Q4a1DkwLWIX6L77lNATO1vRYIe8CVFZeNKXXjnG9ZyN3gMVa6Tg1Ggh8NYak
	NY1z81VMnNwwTBkWAyjfYGI5ItQPa/9tqm2prJV39I1NW5Pg9l0YoXIkXjST7fCFaKiJNnQgggwSG
	ROOYRefA==;
Received: from [96.67.55.146]
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wps3w-000000002Tu-3LfS;
	Fri, 31 Jul 2026 14:34:28 -0400
Message-ID: <e969b38ce882b32d041b7279499fddcd00f18b35.camel@surriel.com>
Subject: Re: [PATCH RFC] mm/gup: batch contiguous pages in
 follow_page_mask() and return them via a pages array
From: Rik van Riel <riel@surriel.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton
	 <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu
	 <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Aristeu Rozanski <aris@ruivo.org>
Date: Fri, 31 Jul 2026 14:32:58 -0400
In-Reply-To: <amyUQahYOgov0z8c@lucifer>
References: <20260730035350.1fc95dd8@fangorn> <amyUQahYOgov0z8c@lucifer>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06C3C4000C
X-Stat-Signature: fgzdb343uk6xeyi18ymnkdjk3hef6fe3
X-Rspam-User: 
X-HE-Tag: 1785522879-663179
X-HE-Meta: U2FsdGVkX1+/dwsEoSiiYbDlwTwZZH+1PqB6yF3B4aiCns1zoOG9zMuhBgXvFhNA6lHagxGQmmPt6GlhRvQq5oEG2e8CJS7AfnZJ5lTFwHkoG17g8IvjqXeCtjoKOZtMJ7TtKOxgSNR6xT017/L4Icvi2/BUvmJPfO0u2ct1CPzcLEa7O91Ona90PZeD8AlMOf3of5hCibI71jlvl1ZD+M82jtVBmg/rpgZmXtPOOtmaKJV7RE7aF7XZV4M/a91IHVJvehBcaUe7zraWDPNejxDMvSuukxDxJg6YD4g0jpj/n4ZzeaF7BCZvS95WJGlK+WB69jYS03bXZ+V+IGvdL3LXPjD8qG85vT3OwBYvbB6g73bU/KcDxq1LyPAEZEUL1JOVMOa27IxgBIAxPtqpD/crOK4sCdAKr2dTpCBAJbgAtt3/q7xHRbgEYHPbjRv4Lga1gvcv2RgrOfOg6ogoLaEco9sllcSVNINQMP1zOAuiw6tgefS5hpovxZ3nkV8O8E1FljoZGlc8v30hH6LnI1fds+9HQ5AWrHVxPm+h5soT4k9In07ckB43CW3atzlS4wQYE2Wwud/BxrXn7svCwxA6UpB3WmstzzFILU6sXknpgTsRQItPxpu+RgXVAo12gtM3LA4oqf4wQPqWK57ByQ6Pg1J6MtdhhJtrgyLfDFt2YqRV6Nzl94qlSeAHvIcRgzcFi4e+UzKJy3MFQwdKfcl6wVr3sOhlnvUtVWLKst/9X2jrPclO0q5r8bsOTH40RjYdg8rYpXLMHPmuHy3LbpMtI3EtpCiNvS67cWdeToxAT5AbW97Zid0tCwAn0sKyAikCb6fubC+9AQ6WCeSZ9Om27Lwor4zQd21vKAElvyQx+jnXCkd4C7rD+cch8EKq5czHDYQuG8Fqjb3lBQW6Ov8vG4bPfIE+ke33GWrybCvB0kEPuaoC20U7XHQk6fs7BeAll9LCURXWFYVvr60
 19nnw3+7
 TgxrRqb/CiRcZ3xJAGstixlrfKDq9WSMg7mM2usQNtgzfua5YFtA7WdHpVfLrqS0XQuqDFGb27TLm1PGLCBZsF9uoYBsqUeGRG4zVJQffqOPlIpGY5G5DHdy/+myUkJ26KUBDoUMqL9NMnZqrHkbnxPZf/Km0PLWqb59CNHsKZS7Sd3KIFQrcXa1Oe2mX02QZQ9XaTWYG5YI2iXhB0tXLoXwaGRknGBHH+KQWhBRC0GvzSuj+um/sW+TgwW0ZCKCNaqFGUdyguU0EQw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-07-31 at 13:33 +0100, Lorenzo Stoakes (ARM) wrote:
> > =C2=A0mm/gup.c | 539 +++++++++++++++++++++++++++++++++-----------------=
-
> > ----
>=20
> OK it seems the message isn't really getting through...
>=20
> You really have to spend at least some time filtering this LLM-
> generated
> stuff.
>=20
I spent a fair amount of time cleaning up the code
and comments. Arguably the new code is cleaner than
the old code was.

However, I do agree this patch is too big. That won't
happen again.

> Nobody's got time for walls of text and giant changes like this.
>=20

I had no idea how to split it up when I made it,=C2=A0
but have found a few ways now.

I've split up the patch into a series of 5 now:
1) mm/gup: convert follow_page_mask() to return a long
2) mm/gup: split follow_page_pte_commit() out of follow_page_pte()
3) mm/gup: add gup_fill_pages() and use it
4) mm/gup: return a huge page's full count from follow_page_mask()
5) mm/gup: walk multiple PTEs per follow_page_pte() call

The changelogs naturally got shorter with things
split up this way.

> And at least use a reasonable model - sonnet isn't intended for
> kernel
> development is it?
>=20
Sonnet 5 seems to be about on par with Opus 4.7 from
last year. The difference is not that dramatic.

Also, I have found that while Opus tends to make fewer=C2=A0
mistakes than Sonnet, they both produce unreadable LLM=C2=A0
output when left alone.

In order for them to produce code that is at least a
good starting point for editing, they need to follow
rules.

Once you apply the rules, Opus and Sonnet do not
produce results that are all that different from
each other.

I just added a few new rules, so the tooling won't
even let me create too-large patches any more.


Whenever you see me, or somebody else, produce
something wrong, either with or without an LLM,
please yell at me, so I can add the proper rules
to kernel-style (creation side), or review-prompts=C2=A0
(review side), so those things get caught=C2=A0
automatically in the future, and not sent to the
list.

--=20
All Rights Reversed.

