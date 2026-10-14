Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A1ECC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 01:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD266B0088; Tue, 13 Oct 2026 21:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3AD6B008A; Tue, 13 Oct 2026 21:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1536B008C; Tue, 13 Oct 2026 21:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA5A6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:01:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85B34803D0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:01:37 +0000 (UTC)
X-FDA: 85319429034.30.87776B0
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5160A1C000D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:01:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FtFoLv5g;
	spf=pass (imf21.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791939695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcyFLOR307IwCd4Dy0GBYyDYcbdMnlagtjknr2E8Tlk=;
	b=4ubsn7poFkXaVNsr6Hc3gm8LGLf2Sv81ubZhe5Z1vQY86vupACkF/vLRvmjYH/D+zcVpVH
	EHCfv+13huccAeGJF5nlQOQIGozaoJjM9VmyVpy0dhV6HoLOlXY8g/WIgs+nhQu7OaxAE1
	Nem5DgozOoK8s7B3e4iYWty86FlUZN8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FtFoLv5g;
	spf=pass (imf21.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791939695;
	b=c2qkXPhkLlESfZUFh5LDFIOqQQY2LF/VfYmqL3Vg3MrCwzflD6BXJZpPZ0C0PyidF1xtJi
	sKquidV+bJmgPXPhyU6dhuCfKunUrYVZi4ZRDwFGI8mPa9ehtGM3gnPXwCAHC9yChk7R9d
	ofjUmEEurtDZHjzTOJCIcTWH1tVz2WU=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c3156e7705cso83141966b.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1791939694; x=1792544494; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NcyFLOR307IwCd4Dy0GBYyDYcbdMnlagtjknr2E8Tlk=;
        b=FtFoLv5gi5Q/NW+DbalDkQNdd7+qjzzLq2OflkxxbQC2yc2do0HHVPj/UwrDsx2fpA
         3gYIJkS27P8k7vmzik+YC9BxOnNHWG7KkNySYq99E65gj29b+dn61yh+vTm1fphrQ0HI
         eJk3b/Iek71ftg3qsuqN1OF9f/bdKsDLBPSdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791939694; x=1792544494;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NcyFLOR307IwCd4Dy0GBYyDYcbdMnlagtjknr2E8Tlk=;
        b=ihZXjY6xizTFkox4YYLWInGdcPSYlhwx2E0UsU/3bR1oNdizm7VoSsbFCYhUmhhUd3
         vyifo8Poc8A7K895SiLfKsj3Er++eeeMGWMoBIHfbc0WayH25DCgICvm17ejWDUjDr8i
         3F6yUekqWJlVIKBx2SAuVey11CVj9TiBVwszhV1zDZhkzwE/+2Mg7dZrTxFAypIEwhE5
         f4VixxCAmKj9Fe15nsskeEtmMPI5oPKoeosNBowSaOmRdLVMqn8N9vkNBuWTg+L3MKPe
         HpvLd/wkSQA7u0Imssu4yjqJ8cMBLBYhKzXNUD1cOwUjzuFvz9rEY+FusWz7uGo7p1vv
         GOEQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDOoJ33ukwczQG5RizR+k+Hz5EESxVPI54xTbX4jHDef1jq0JSHhOZOjmKl++mp8hy5ZqwlQAijA==@kvack.org
X-Gm-Message-State: AFq9FYLCoeZ+pJAthgmz4/yjRa7CvcHLQer7y44tNTnpuuZh01vaRO0s
	Z4QaL787svEAwqXL6sVyDevtKLoOGSScAynz+n3UqoERtOyiWnsKzolhwTJp5UdbczKBJioDeMh
	zPaXFsnM=
X-Gm-Gg: AYBFou1Y+GcuruxfEfhxqQscISP5AkpmQLXzWvWb0aRxsIVhAkr/MCtDz3u91AnfShh
	RdwhBPlCNUjym0wV7hUZykLcWEbpV7Y5kQt4UO3fUhxXw3FSCHZq2+1nCA8YArnWwT1j0DxUKXD
	yLF6B1WNAArXREsfozYjh/bELXk9Q8HmvDSnt/loZGh9F8/vamn30roSF+ij09DDGSGmPyMusAi
	KqgVECrARkeBEFboo3oXs8BrSINQk6PRExV9GbgsRatdEKSNUa0zNo6MsezcpP9MKIVOgC5esH2
	4Wp8F5DRkAVLPsgC4kC0GANQ0uPrY5fyFrX//ZVMoqXaYXeqSAIzhqgCyu9T0KFIs11vhJ7yTlp
	XFny0vT/rZ2VpN7ddO4KbaORNLvrobacYkmWIThcobZ3BggO7Hy+XZ4OluzVU/RA7If4aFio++P
	qNW7CR3ucfgheppzhipGi4E6e6AgUytiVPxHWdDpptdg5iS/lYxBlirDWqksrQUV9iJOCFmeSSw
	O9BUjY6Kc9TBl4SbD5NmJ0GXdXScFc1jxDguRCu+PNKu+Z5
X-Received: by 2002:a17:907:3f03:b0:c26:2a2:b91d with SMTP id a640c23a62f3a-c31a9a28e8amr1426751066b.6.1791939693275;
        Tue, 13 Oct 2026 18:01:33 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c388b601c2bsm72080366b.66.2026.10.13.18.01.32
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 18:01:32 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c33bb2f3e6cso87906666b.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:01:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx8HMeCpuckIu6PWgugoRNDzsH0EcmWriMjdRljYvsfuQzlq437GLs/Q2z3amk+115MiD+7xSKoyA==@kvack.org
X-Received: by 2002:a17:907:c07:b0:c2e:3d17:5259 with SMTP id
 a640c23a62f3a-c31aa0bf51amr1323546966b.41.1791939691728; Tue, 13 Oct 2026
 18:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as690Xcu7FxIDYjf@thinkpad>
In-Reply-To: <as690Xcu7FxIDYjf@thinkpad>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Oct 2026 18:01:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
X-Gm-Features: AclHuK-7BzKDDoP5wgoiVMN8_EAgBIxPIkVd2eugYnHCB-lOaGFTkQDZImU89yo
Message-ID: <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
Subject: Re: Improve page refcount scalability
To: Harry Yoo <harry@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Kiryl Shutsemau <kirill@shutemov.name>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5160A1C000D
X-Rspam-User: 
X-Stat-Signature: dimpc3r9juf67m9cu7388q6pdq557mdw
X-HE-Tag: 1791939695-859309
X-HE-Meta: U2FsdGVkX189lfbYpILV9JPwEivFjGCvqF5yLc8gcpY1rTfh1mldFYSUuPT9Cck70Kp5yMfWRAZEvE306/Tsw01QaAv5K9cTgayylXIURbUgXQqG7uHYEMO+Xk3la1PNKJ76+Q8jEgiFyV1yTHTX+tZZ82AtkLCfwKNG/kYdlktYjnuDcAHkdIBPXdmkTyZz3dgjuLI2B7rcQWeR8j/XT3vpWA1u6cwgXSGtnpR7wDIegKdlqSqTX5knsOIGeKm3HX7H545SC08MhWf/r6jQr3CRLQSscKLkeD7nTrIn58KBkNY/urc7U8AnRNsfVr2ESK3etN/l+QlBdmeBEONoqdU1F3a1oLBj8gcuhKxbJjbYi4NyuSvv75E0plnx+dDpS0eMFXI/SrpsYl/cVde71GL2ft7uegYwlNvaDzq3PBnXzaKW8WZRViZhXL2VqwDwJn7itTzNt/jkBtwM99XX21Jv7SmSg+tR4nbeF7xhBQYA7b4wlSqFMarhDDXbzyHx9nU6h+Tm6uBGAG88/VPemZKAuSWt52lUzZE4f6yWHYPzxc0VIOP1n1sYqCqwyzBZBCao3m6iJyZqyzQcZowUPbW5/+ar+SmJ5r9lvMEhtY1hfx5pZsSoOJ+/HH99IZ+K5FC+6Ip8DZC/d2XoztRLDAkaEkChOUn3/qkV0DyBQtEaWm6XP5k17WT+YJjxNEsPljhAVO0h68b9NIMV1zS1u/89OwzEX1LO7leejREinYZ8OueAen0Co9zV+Li5sl06dFy6NKM7zKqA+Xi1Mm6eSPfyEeCWRTUKDnJ+7JriP6GYysuFqxp8EJ2KbgzTfdTBEmH/FzSEG/u5S4zdxpOCaX3GoEfeHFLZEeEHgEKdB+nHp+AinCr/Kfh37z/Ydzjbw8nq7OCOMS11Y23w/8HgYmrEs5mtlftZ1AASRG1JIbtjnhPw5QBWVHnqTF8QA4HT5TUDC8+OxPZhR8CrG74
 hQgyHg1p
 JJ6wpFPIqxwISWNcBhRxLEuUucVptlav9KIScqYeVnPMJwTIj5653szTkeZE3RdPzGmKW390/InCwJExJ4pJErJlHeJ4hZFtwqOH5eZwsiPzXDciXTfyhPMfdt7TNFIPppYJPoz/F7F/nTzui3Hb2o4YC2U7xaHuMBUecUSY8R2+58eN2DdSb4fGGiWnhZNyMMn1MiI4V3F244rAmbLuujCW3IICUliL4o7VifypJU4QOtdI3YKvx8nRNlthWHC1umSnX91Okaq+X6pa2I3gCa3VfvGd1aldrkId8wvfm0yhanwzf0oGgwXqfOs8orNKf48Yn2uzDgiwiorh8ZKE3F6b6ImlHtW2Mhb7xBPC3Y7NR3B0d8Bs0SHqG+8HbwWZHeIcC7RKsPtQ6AIEDPJr+ZJH/n+hD0bLoxrD2+aCdvQj3xwfKgwf5pdZJG3gKDivKwBmd7fKMWjxIY3WMXLok5fuLnYFaVqgUxBlvNII5ouds+SAEX1n8ih7O7000dT7+eTnaiMLGtHdlvER9RfAspss4uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 at 17:10, Harry Yoo <harry@kernel.org> wrote:
>
> There should be a limitation on how much memory can be submitted to RCU
> by the page cache, otherwise will be a corner case where we have too
> much unreclaimable memory waiting for the RCU subsystem to free them.

There is. In fact, I tried it a few different ways... It's not quite
what you suggest, but try it out.

> For the same reason, when a process tries to create RCU-delay-freed
> pages much faster than RCU can free memory, the kernel needs to limit
> that.

That was actually my initial approach - making the places that set the
PG_rcu_delay bit throttle themselves when there were lots of such
pages in flight.

Except I worried about slowing down simple things like truncating big
files: particularly since I believe firmly that slowing that down is
the *wrong* thing to do from a memory pressure standpoint, because
you'd be slowing down the very thing that is actively freeing pages -
it's just that it then takes a (short) while for those pages to get to
a usable state.

So what I did instead was to actively then expedite RCU when there
were a lot of pages in flight.

That worked quite well, but it hit a problem when you had lots of CPUs
doing it: since an RCU quiet period needs to happen on *each* CPU, you
still end up wanting to at some point wait for things: you need to
synchronize not _one_ thread freeing things, but synchronize across
all the CPU's.

But again: the good part really is that this "lots and lots of pages
in flight" only happens when there are literally lots and lots of
pages that are very much about to be free'd. So you are in a fairly
good position when it happens, you just need to *understand* the
position you are in.

So the other part is to come at the issue from the other end: when you
have trouble allocating pages, but see that there are a ton of pages
in flight due to PG_rcu_free, you basically do the same thing from the
other end, and do synchronize_rcu_expedited().

And in testing, that worked really well under even insane loads where
concurrent hole punching or truncate calls would generate gigabytes of
PG_rcu_free activity each second.

Now, it turns out that Kiryl also suggested another approach to the
pages becoming PG_rcu_free in the first place: instead of being able
to easily trigger gigabytes of such free pages by just truncating a
large file - which marked all those pages PG_rcu_free whether that was
useful or not - the current version actually comes at *that* the other
way too: mark only pages that are hot and are *worth* the PG_rcu_free
treatment (because they get read over and over again) with PG_rcu_free
in the first place, so that you don't generate that flood of
RCU-free'd pages in the first place, and now the PG_rcu_free flood is
in a way throttled by the *use* of said pages.

So there's effectively three different things working together:

 - mark a folio PG_rcu_free only when it's hot and keeps being accessed

   (See commits dabc522cee5b: "mm: have folio_mark_accessed() return
whether the folio is hot" and  bb5908b733a1: "mm/filemap: set
PG_rcu_free on the folios that reads keep coming back to" for details
- both are pretty tiny and not really all that complicated)

 - proactively expedite RCU grace periods when there are a lot of of
pages pending

   (See commit 2ce8df4627fe: "mm: expedite the grace period when a CPU
has many deferred frees")

 - teach the page allocator about the outstanding pages ratehr that failing

   (See commit 82fc13ff3a1e mm: "count the pages waiting for a grace
period and free them before OOM")

and it really does seem to work quite smoothly. But it's not like I
can guarantee it's perfect.

All those commits are fairly trivial. Of the ones listed above, that
"count the pages waiting for a grace period and free them before OOM"
is the biggest by far, but it's not really particularly complex or
subtle.

The actual biggest patches in the series are:

 - 65401f4102b9 ("mm/filemap: read from the page cache without folio
references")

   This really is not very big or complicated, although it *does* have
subtle ordering issues with i_size as pointed out by Kiryl. It's
mostly really just a simplified version of my patch from two and a
half years ago. And it's simplified because now the RCU freeing makes
everything more natural.

 - df0b133495c9 ("mm: free PG_rcu_free folios only after an RCU grace period")

   This is the one that actually runs on the page freeing side and
adds a page that is marked PG_rcu_free to a list and sets up the whole
RCU machinery (ok, there are actually two per-cpu lists: the 'pending'
list and the 'batch' list, and a RCU grace period will free the
current batch and move the pending list to be the next batch - not
rocket science).

and even those "big" patches aren't really all that big. Both are less
than 200 lines of code, and while I wouldn't call either of them
_trivial_, both are very much doing one clear thing and there's
nothing really *strange* about them either.

So it's ten patches, none of them particularly hairy. I really would
encourage you to just take a look and take it for a try.

Now, I *will* say that obviously RCU-freeing pages is an absolutely
conceptually *enormous* change to the VM. But it's in no way at all a
new thing: we've been doing the same thing for kmalloc() for decades.
With the right pattern, you can cause a lot of RCU-delayed kfree
loads. And we've had to tweak things for that.

So do I believe that branch is perfect on the first try? Hell no. I'm
sure there are things to improve there. But there are few syustem
calls more important than 'read()', so I think it's worth doing. We've
been doing the RCU-freeing for almost every other path, and I will
argue very forcefully that the path handling RCU code is an order of
magnitude more complicated than this particular code is.

              Linus

