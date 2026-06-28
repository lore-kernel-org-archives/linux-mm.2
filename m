Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97605C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 16:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402986B0005; Sun, 28 Jun 2026 12:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3C56B0088; Sun, 28 Jun 2026 12:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2A86B008A; Sun, 28 Jun 2026 12:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 058E56B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:46:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EE04140445
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:46:38 +0000 (UTC)
X-FDA: 84929900076.10.F1DEC20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B7BA080007
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:46:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T2r/74FM";
	spf=pass (imf02.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782665196;
	b=f8RG/9TaSb1XloZ095x8F44DsAyBtZe2njhEaK9qoya564L4+b2J+hEnAaKRT0vt6dM7R8
	k4I9FEbeSFng+gjloNBA3OeLc2b0q5iJiD4RONXgMdLTOHrDFy0IK6uhLKewNr6sKehGM5
	a0bnNoWzts8GN5bEzibW4LocqrAGlqA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782665196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THp64I9/31adVTX3Es1NaaEmLtXylmJ/nlw0Onko050=;
	b=I52YW2U0DJVS3KRO8EDb8/x3FJF91WGhwEnCUud83MVjR/LHDsOP8OlQbdAqcQn1kZ6acT
	TnkpuCveIs1VxoAtRhzX5qYYV5PSsFYPM/C4MjZN2CYTkv28WU9v+wAgIjABCpct40Y2xY
	l8R6EfSWaL7qEREmHL0YEIZxgKR/7fE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T2r/74FM";
	spf=pass (imf02.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9975A4064E;
	Sun, 28 Jun 2026 16:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C909D1F000E9;
	Sun, 28 Jun 2026 16:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782665195;
	bh=THp64I9/31adVTX3Es1NaaEmLtXylmJ/nlw0Onko050=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=T2r/74FMf/7gQgsL/45OzYzUr8Kl7WLfPCebvUFVd9iV0Kpvdnx6Zn22StMRLHECx
	 crRp5Nh3YSpNZUejpnapuaFZ8oW/QW0srztGBsRKazpUMyOpCn84BhDbKFC2EVQhK9
	 qbNev2RfZZvbIegaa3ePFGwxllrwG6LZ6iaXKC7OxQclpsC9jP5fYIdNQ7krRESti7
	 yDrv732uIb7jVkbvlM4ryCUmEagryXhZ2N5Et5Q5YuHM5YXuxPdagIUNdldU9JaAF0
	 wKZ5zx7Gi23v3cmcvzTGMURfddEQ6CJMKawY3IUOruQkUd4A5yq4/fYFprgyKiNw8V
	 Ne4etnQZ+/35Q==
From: Thomas Gleixner <tglx@kernel.org>
To: David Stevens <stevensd@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij
 <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, Quentin
 Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
 <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, Kees
 Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 12/13] x86: Add support for dynamic kernel stacks via
 FRED
In-Reply-To: <CAOiLmNGD08mLKAJvRZdaS7b+3BeR8Ln2G0sEqNCmbD6cRFzAxA@mail.gmail.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <20260424191456.2679717-13-stevensd@google.com> <87zf0hgc3r.ffs@fw13>
 <CAOiLmNGD08mLKAJvRZdaS7b+3BeR8Ln2G0sEqNCmbD6cRFzAxA@mail.gmail.com>
Date: Sun, 28 Jun 2026 18:46:32 +0200
Message-ID: <87ldbyhatz.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B7BA080007
X-Rspam-User: 
X-Stat-Signature: 4pwaa1fghrgpqaif5s8n4hi78hwy7cfj
X-HE-Tag: 1782665196-149508
X-HE-Meta: U2FsdGVkX19U4iFGwtK0DTZ1m0+NwkHhERjmXxdtElaQSaG5yaNwu01kBuDHOuu+gnBkPJhc79JYi8jmUOf2pc84ZDLRJ1lShPlsvMgb6GotApIOtGeIzQMfBIqA62Vj+p4mS1gR1z1RR59Ckz8+fND0izn9xXdUffHERDOJaG5zEzQCqjc9L3LIAOFyXL/q35NDEKVxmFgyqCPNP+XSAMPhOYhWXCH1CYDqwxzVRQ+3H7kCLtGg4cynO0v9KnonOe2aj0d61QkT3IgYOW3QJHofNslms28lVtsBwDuoJOdTkTLyCByqsxx29uK3U/2qG0hGKGSkAvZw2rWZbdeaPR8JI3xkWZZ+vlKbrZbUNLCI+NlYpdaykSyZvA35sQEVf/vw4+slg8+HSgP0Oi0CkLf1qxJSNj1Od7a8rMKet/MPqbVAVTAtXJhFwJSu7kxQca8smr1wWxv09+SE7JL17Awgll4OWhqAfhxfeFL2NwQiUvTqQNRYLESE4rxUPD+pX8TMUjH7mQ2qjnkYqn6SwPOTnrj3FI53RGztMGQoPbZyQQcUm5wufNfZ0hUDPrw/MBktz0Wt1PNyEleahPusLpAgL3swCxy0HL1qJeJKup/oNrpShPWjXYLzgGmMG/Pi/2jWtIHx3eP2CizGKgYH/OOFjAqAmRiaN1BZBGJz8/jNj2kqjPFcvQb0S/RYNZZJN864uVvOTnc0DQTJULdh72xjpsk5F4DSNW+wUezGHRMQ7PkZoF/eXiGP4lGy+MyoMP4pqqO1lGeqoN4EvXMb3q3QTZimUY0Mb7IbPJa1+7WLLE9mXCtllAHyREilhCBvTrdK7jD2JVW7m6UGo6UlCW5Wh8M5yIUXkEpsh/Mb+cZMhAA7wt0qvmyWHeolYfAfavr4KPhvKclxlqr7RF/i8piKDoumgJYk5WsDP5GMfx6NI84338wdjgVtjtwefuCKm9jfjoxbV2LbOMo/fMG
 /N7HdcUk
 hakiYFfjcYSvwED5x3oODogy/G2tX6NQ5BvuWsiL8NpXKVpgd1UbKzgYcFmnvZLsFt7QI2HzuHq8DYd1XwBbTjPCHdBC53IxmIbkWiPePyDEvg/9vi8rueiRD7dIMJCfFEx0RhefJFGgZtK1AqWMzG3xQW6nhIiO/sv4HQs33L7WYmg/SOBAsIgi711kKMcaUvhJ08/ooMYt6ZL838duCXgMFS/qf4+D06AZt4LwdLCdORub/JLWdVqIRO7pX6kAXEO7aYdHx0mrtLOx8S4XPfmxI0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26 2026 at 21:05, David Stevens wrote:
> On Fri, Jun 26, 2026 at 3:39=E2=80=AFPM Thomas Gleixner <tglx@kernel.org>=
 wrote:
> That is definitely a situation that could happen, I hadn't thought of
> it. Luckily, I don't think we need NMI-safe re-entrancy to handle
> this, since an NMI on SL0 couldn't have interrupted a dynamic stack
> fault.

Correct.

>> As a consequence you copy stack data around to the same place, which
>> should be benign, but it is well understood that memcpy() source and
>> destination areas _must_ not overlap. That's UB, no?
>>
>> I know that should not happen, but that doesn't make it less UB :)
>
> That sort of fault would probably end up either with a
> page_fault_oops() or risk a context switch with SL>0, but we shouldn't
> make debugging harder with UB.

Definitely not :)

You can avoid quite some of the problems right in the ASM entry code.
Instead of checking event type/vector and then going to the stack switch
logic, you can check the stack level on which the event happened
first. If it's not 0, then there is nothing to do.


