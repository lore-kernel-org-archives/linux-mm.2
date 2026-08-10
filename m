Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D3F0C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787C76B008C; Mon, 10 Aug 2026 11:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A826B0095; Mon, 10 Aug 2026 11:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628C06B0096; Mon, 10 Aug 2026 11:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32F2F6B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:50:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAD8C1C077A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:50:24 +0000 (UTC)
X-FDA: 85085796768.05.4DD4A34
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDAA714000F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:50:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FpmQJ2F+;
	spf=pass (imf23.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786377022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5RAXal2rZRUWpw76MNjDYAuWkbIPwuFzOtfzJ/aSVc=;
	b=Yd9et5XxGQB6AofcNqLNehmS+UcotuaFNYQlC6FTF0s+I1524WHmiYgLnkFI85jNaCsKmv
	32ucUdBjJZMOfCI0cyZ/Oe7rRspGZnj/2+WCFu5cvJ7tQFyxJ8kGZrC5f/EOx8quHxFPbq
	B7KI0eNJwL+pcmqrtLyWsIkxJVRM8VI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786377022;
	b=DuAfa4Y9m/1pFyNNI87n6NlEmjKf0GB6n/oqAlDzKxx2/55nXe2mKuWINUoSrsnw5Pf7SK
	pzmwRJ5VEPtZ5irR2W8chHSAKB4IW3uld6C+OekuzXN2tal/I4n0S+ny2g3znpqX13FPtn
	rf0FhCPTZSlCujpHxuRV7/sz99/h4hg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FpmQJ2F+;
	spf=pass (imf23.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38511175ad3so1928269a91.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786377022; x=1786981822; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D5RAXal2rZRUWpw76MNjDYAuWkbIPwuFzOtfzJ/aSVc=;
        b=FpmQJ2F+egFoFI1uyMmDmaHuJjR0zgQ8QL0L2/0zMt00ZqhR5QeiX46McZo1WahkD6
         nj5q2F9mCQ9lkObMZqRV1K+rBvUX9Ke6AvwlTW5Z7WI3M2801mOT+QxyNMeXc4nUmYLp
         4SEAARr2fp/2nCTTLFszi3zXWR914TdUjDkSObwcE03m35ekV1tkO9XoewPjpjfmz/4A
         aALwdjq6ERqcdmAL4tle+gvN1KRCVZ25hjz8EMOmEoAXW1M5/te3wvliEy0d4/hhhZvU
         XIEl7nzDqh1cuTNNFnfmzovXLJ3cpy6uLFTRThVjiQ5wS/RKJkzDOo67R94ULA9+QRjd
         ASLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786377022; x=1786981822;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D5RAXal2rZRUWpw76MNjDYAuWkbIPwuFzOtfzJ/aSVc=;
        b=msXQsdFJDPvy4e1UUW9U2c1CcToCvKl0fyGzWV7jqXH8W9o34t+PvuQnW7aVdAEwkT
         g3Mo5ct9wPpNXrmbk/I7aXjnR1fYbg912lLouBERcnhiCdszaGAytTWQ8GC6q1eGLdNM
         I0gSAX0ekh58CdaDRk60ezavrCS0gSMvMM3KXpAw4o089JRwacSZkv5lukhm7RQACwNi
         C0OHdOswvOkRajIuVpWl+MJl+IZaVa9nWaT+4V0LU32+++lnpdMs3qRBY4a59i7rcVwu
         1ZFg9MhirD5XhgJQ3Wm6k2CjZcL2UHZRYLQ46K54XauoiR9MWe4NtiB5DscmFK/5yqXN
         sVcQ==
X-Forwarded-Encrypted: i=1; AHgh+RqPlUE88AiTFMKpMKwrJctjV7peh/ccCgKlykCndY4rvLeAQsIsVvzSYzN3yulzi9hSwu9toJUQIA==@kvack.org
X-Gm-Message-State: AOJu0YxRQHj1LjzSwLKvXmzQiM56hi36aEsREriEXpOqT/jtZVCiCkB+
	Y4TIgMKQt+dkDNF2KCK1oTTCvbYKEYNTSlKDeiLWOBORCLkJ00ibxb8PH/rNZA==
X-Gm-Gg: AR+sD10XusWaui5b/Iu6ZKZXSJLfMTMRPWgJnJV09icKmzUzK52a9L9i6dTqAst9RhQ
	li5jmJxuUfVn2vqOhqjZxrovkTCpjhWbtz992z7KbEza+bsjnqVKltJb30IT9Mi+7ljRzQSBxGf
	hJrYhaixsYZbjEY4lmlMlOBCSos9WQgCOx8Hx5vJ/7rVIuGq9HHbkcaeUlJ1GqHw0naKllhrThg
	0j4CKyuljHKgZUJuooRSQYPr7h/PpfyMwg4hDB8+VSr4rrmGZE5UUY4rVrRUUbbBOdumbM9+Tzn
	eWz2FYECfVeACnX4bBQ0EbJ51KOdHrgn9DgnQcrlAczrkpQ+n2wuV2YJsEC7lnyH0ZlYig6ZUMC
	qEfVAjRvKkcwsz3bS69ErqwnTwkEOp0pTO6A7kF4s9Yx+RKgZ9mda1NtOqqONKJTYWy/0e5/V/8
	cOLoOB4zyGdnyXg4CAvgHU1SwbcEsUK5o/bCMcl0qItse3aF4tHWOaJreEjcXpYdc+lQ6+RHrgx
	oFnCnsoaA==
X-Received: by 2002:a17:90b:4a51:b0:37f:e1af:df22 with SMTP id 98e67ed59e1d1-392cca91c03mr2243236a91.17.1786377021604;
        Mon, 10 Aug 2026 08:50:21 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-390b30d465csm7004937a91.2.2026.08.10.08.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 08:50:21 -0700 (PDT)
Date: Tue, 11 Aug 2026 00:50:17 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	imv4bel@gmail.com
Subject: Re: [PATCH] mm/pagewalk: fix stale walk->action escaping
 walk_pmd_range()
Message-ID: <annzORC0NgSIsX39@v4bel>
References: <anmdrYGVqM-U4vlo@v4bel>
 <anmrTaWp2etxX7Fd@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anmrTaWp2etxX7Fd@lucifer>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDAA714000F
X-Rspam-User: 
X-Stat-Signature: rkzyaunf7fqqenyqf33xtjtsrewuetky
X-HE-Tag: 1786377022-193978
X-HE-Meta: U2FsdGVkX183ZoOqSk4MP1xiCXlVAAcMd8HhBrvanH+rn9s3EYKGNVZhL9mOQ6syTYEnMMjO/s0ijCkfh58fLC2JNLPeyrNSRN+wU9a9OgGMpNY1jg4B7n9aPe+WHQpeiDuaglO6b/DWC9YpvtnfyOvuTqorsnTI4nOE22BKpQOZsgi9Q5TA+IaD6Tdzyg0TpQVOTKrcIIWpOwcW7MkWH/AyEhg/Ouo7D1zmlhxAvelcm+olMEpjahgZOIQwcdmaHkeUdET6ZwigtJYWpxkI0PUDv5m9rjdJUxfjSZawwzq+82yS5gTiYFHCQUgLK2eQQaHgPvr0Y5q7tL1Z/W7yMPzvRfGpGGLgLzT7E1N+e84cvS7coBXqMzQjqCX+YFbgq3Wpbcl/9vD1rWGoXxRI/a/WekOTbTpvUkB6QAX3uxNMMORek7XX4hA7TtqBj+UjDv7hisGgRgNLBEbLENLEqPCBVAW7a4qYtQgvkge4B0ckuxeZkqQgLS3H7vgR2t3IDC9yAJNF9ekANqW7tNRXDe6VbgF5E1rssNKumrsDdLkT8YeyT1dN9yYWjBTyaUGlUdzzRQA1VPGB/7kYN13tu049ibJfle2XWl9GBq75jbA6DXQR6tYknqHVd9vbkT7ANwS2hK20XdpWmxTVaSG9Zs5/vfeLLPyT9X5kDkPVcuXjc6AKASjlXxQ5CsLaRfP9KZlOfBWkzOPisJrGdql/G05q8r9tMpoz9o+dUkxdnNc92rWQ/VCGWTWv5/Vgbxl7TH8SKn6n8ClbsyqmkgMQOQtW6Rgq48U+HYNi3LE2J0mp8W6BfT2LhmsVZrpERjOLQI0myk2DwCSE3zNdmL+dy2vFaWI71wwZnsg1rculDNK1BT000R28cLAlOvH3KdtnRqRwMplc0QkgRkc4PhicJ5pbtjV7sQTt1+aiibtBmYfS4x5HX8z+xRy6i/4sqNn9qWE2ppTtv2/NHRWnU12
 YLCJen7j
 pzjQb9gFtlhC0t5e45Oa6Q66zrM6DZF5Ta31iNL43FcUKq6SRJmen6EI6Pee+Y26rDWTUQZ9Q2cgNub6Ro83JVWbJIfn3g7oB1gBzN0bnHfcP1FS5+93UDcnsEHQhHmXqIl9duumekZvL02NOLEYYXmAwxSpd/9Rt/y3Cqnt9HB8iZWsImQOlZTZNdbf4hAaD5TnqW6I3CVsjqO91RA9KzhdY631GMPn/H3mquk358gFhWr11f0ypfsrSfzpmn+HytowhI9imqSk5PGe2T82t1fvQlpDqS2JhsF8h803VDCD/DMc9XUs2erudee0OTO018/D+vi27HaI7nRmfSrmovxlR59jgSinK7PTQAf0D2HWfOML9A3Q84VrYrBpXTz33scVBvnr6+Fn602J+oIJ1GAcNBUkkjTAqiHtqrLfJF5/HGm4df6aWTQowAQV7UXAJtCE88De4w05cCSXrCSN9GtsCRnbFZb43HvLXpSgvOGBNzYJXzLGyf7sZ4jxvd3tQ+E/t3lTchzeORK95aywApC8nO0ojx6MDs7OMRROQcFAEosI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 12:19:54PM +0100, Lorenzo Stoakes (ARM) wrote:
> Since it's 2026 + this is your first patch in mm AFAICT, 

Yeah, my home town is netdev :)

> and it's also a
> very fiddly and specific issue, I do have to ask - was there was any AI
> involved in making this?
> 
> If so you should add an Assisted-by: tag as per
> https://docs.kernel.org/process/coding-assistants.html please :)
> 
> On Mon, Aug 10, 2026 at 06:45:17PM +0900, Hyunwoo Kim wrote:
> > walk_pmd_range() resets walk->action in only one place in its loop body,
> > and that place is after the pmd_none() branch. For a walker with no
> 
> Newline after full stop please, this is too many words in one big block.
> 
> What is a 'reset'? This doesn't really mean anything. You mean sets
> walk->action = ACTION_SUBTREE, which is the default action.
> 
> Your commit message doesn't mention ACTION_SUBTREE anywhere, it should.
> 
> Also what you're saying here is just untrue if you consider reset to be
> assignment to walk->action (which is a reasonable interpretation) -
> walk_pmd_range() changes walk->action in _two_ places.
> 
> Just be clear that you by reset you mean assigning walk->action =
> ACTION_SUBTREE.
> 
> > ->install_pte, that branch continues to the next entry without passing the
> > reset. So if ->pmd_entry() sets ACTION_AGAIN and returns 0, and the PMD has
> 
> Not passing what reset? This is so unclear.
> 
> > become none by the time the loop restarts at the again label, the reset is
> > skipped. If the remaining entries are all none too, the loop returns 0 with
> > ACTION_AGAIN still set. The ACTION_AGAIN that walk_pte_range() sets when
> > pte_offset_map_lock() fails escapes the same way.
> 
> OK so what you mean to say is:
> 
> 	if (ops->pmd_entry)
> 		err = ops->pmd_entry(pmd, addr, next, walk); <- 1. sets walk->action =
> 								   ACTION_AGAIN
> 		if (err)
> 			break;
> 
> 		if (walk->action == ACTION_AGAIN)
> 			goto again;
> 
> Then above that code:
> 
> again:
> 		next = pmd_addr_end(addr, end);
> 		if (pmd_none(*pmd)) {   <- 2. This triggers because PMD became empty
> 			if (has_install)
> 				err = __pte_alloc(walk->mm, pmd);
> 			else if (ops->pte_hole)
> 				err = ops->pte_hole(addr, next, depth, walk);
> 			if (err)
> 				break;
> 			if (!has_install)
> 				continue; <- 3. Loop around to the next entry, with
> 						walk->action erroneously set to
> 						ACTION_AGAIN still.
> 		}
> 
> 		walk->action = ACTION_SUBTREE; <- 4. This would reset it EXCEPT if
> 		                                     you are at the end of the range.
> 
> Then in walk_pud_range():
> 
> 		err = walk_pmd_range(pud, addr, next, walk);
> 		if (err)
> 			break;
> 
> 		if (walk->action == ACTION_AGAIN) <- 5. Uh oh doing a retry for no
> 		                                        reason.
> 			goto again;
> 
> So it's only if you're at the end of the PMD range that it's a problem
> right? 

Yes, or more precisely when nothing after it sets walk->action = ACTION_SUBTREE.

> You should say that.
> 
> The user-visible problem here is that you can end up calling the callbacks
> too many times which explicitly breaks mincore.
> 
> Given I had to decode this it does make me wonder if you fully understand
> this or if it's just unclear language. This sort of word salad is very
> LLM-ish :)

The commit message was written with help from the lovely Claude. Not the
most readable, admittedly :)

> 
> Anyway overall maybe rewrite the commit message to something like:
> 
> 	If ->pmd_entry() sets walk->action = ACTION_AGAIN, the pmd_none()
> 	check is retried. The PMD entry may be cleared at the point of retry.
> 
> 	In this case, if walk->ops->install_pte is not specified, the code
> 	continues to the next PMD entry in the range without resetting
> 	walk->action to ACTION_SUBTREE.
> 
> 	This leaves walk->action erroneously set to ACTION_AGAIN, which is
> 	incorrect.
> 
> 	This was incorrect but not problematic up until commit 3b89863c3fa4
> 	("mm/pagewalk: fix race between concurrent split and refault")
> 	which updated walk_pud_range() to check for walk->action ==
> 	ACTION_AGAIN upon walk_pmd_range()'s return, causing the PUD walk
> 	to be retried.
> 
> 	In this case this results in duplicate walk callbacks being
> 	invoked, which is erroneous and will break any caller that is not
> 	idempotent with respect to this (and waste time for those which
> 	are).
> 
> 	A specific example of this breaking things is mincore which walks
> 	an internal cursor data structure a byte at a time on assumption
> 	that page table entry callbacks are called only once for each
> 	entry.
> 
> 	Fix the problem by resetting walk->action to ACTION_SUBTREE prior
> 	to the none check.
> 
> 	The pattern also exists in walk_pud_entry() so fix it there too.
> 
> 
> >
> > Nothing looked at that value after walk_pmd_range() returned until commit
> > 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
> > turned that into a problem. It added both the PUD check that sets
> > ACTION_AGAIN before the loop is entered and the test in walk_pud_range()
> > that picks the value up right after walk_pmd_range() returns and walks
> > [addr, pud_addr_end(addr, end)) again. That is fine for the PUD check,
> > since none of walk_pmd_range()'s own callbacks have run at that point, but
> > a value that escaped as described above arrives after those callbacks have
> > already covered the range.
> >
> > For mincore(2) this becomes an out-of-bounds write. ->pmd_entry() and
> > ->pte_hole() advance the walk->private cursor by one byte per page, the
> > buffer is a single page from __get_free_page(), and mincore(2) asks for at
> > most PAGE_SIZE entries at a time, so there is no room to spare. Walking
> > the range a second time pushes the cursor past the end of the buffer, and
> > it does so again every time the race is hit. Reproducing this needs no
> > privileges: run mincore(2) over a 16 MiB anonymous mapping marked
> > MADV_NOHUGEPAGE while another thread repeatedly faults in a PMD-aligned
> > 2 MiB range inside it and then drops it with madvise(MADV_DONTNEED).
> 
> Obviouisly see above on commit message.
> 
> Is it possible to add a self test that does something like this or is it too
> racey to be practical?

It looks quite race dependent. Triggering it deterministically would need
some of the race window widening tricks from exploit work, which I don't
think belongs in a selftest. I can still write one if you'd like.

> 
> >
> > Move the reset to the first statement of the loop body. walk_pud_range()
> > has the same shape and gets the same change; walk_p4d_range() never looks
> > at walk->action, so that hunk keeps the two functions in sync rather than
> > fixing a second bug.
> 
> Your commit message doesn't mention how you discovered this. If it was AI
> suggesting it (whether locally or sashiko in reply to some review) you
> should reference it.
> 
> If it was simply hardcore code inspection then you should say so too :)

It was found by accident while fuzzing a different subsystem. Either way,
the fuzzer itself was written by AI, so,

Assisted-by: Claude:claude-opus-5

> 
> >
> > Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
> > Cc: stable@vger.kernel.org
> 
> This all seems right.
> 
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> 
> The fix itself looks right, but you need to address the other feedback and
> respin (also please send a respin with at least 1 day's delay).

OK, will do.


Best regards,
Hyunwoo Kim

