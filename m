Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274E2C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BDC6B013A; Thu, 16 Jul 2026 11:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E596B0144; Thu, 16 Jul 2026 11:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6D56B0147; Thu, 16 Jul 2026 11:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD5706B013A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:38:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 256C01201C8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:38:29 +0000 (UTC)
X-FDA: 84995046738.08.53B1ABF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8993318000A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:38:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lR0erwDg;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784216307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a26FW5P9+YzyWC6sUoMal5XZ31S+uAd68vV2bOiyX1I=;
	b=KZMQvZcEHEuSmHd4ScoHyS1/sU7QdMIMvSkKXy0GUhkDoQ+WWdUXTgJpp/ZyLXFaATLjir
	EJrJm3UiYxWKE0dlgDNqHHZ7UMXgBEtWs6ktAwJsRCvr2JECoYXNRX+ngqT643ZnVO7y4a
	T9HaSrNKxA3qYVbSmGjCr8elPUH3xFU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lR0erwDg;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784216307;
	b=bM9BER+5/uY6uMLoRXRa9UATkIM/giRMUDh+tlTrvryZ5fuzlG6CiTWAP8xHGED3mkWV3L
	+D1EaQPjlRj3pEHnuxZfbtBf8QmJq/JREuyCCVkg4CWcCY4ZEIGwpD34eMyc2P5Iw4/ck7
	VaKjubO6q6bPi3/0OujB9J3HZe84naw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA93C60A5E;
	Thu, 16 Jul 2026 15:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3469C1F000E9;
	Thu, 16 Jul 2026 15:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784216306;
	bh=a26FW5P9+YzyWC6sUoMal5XZ31S+uAd68vV2bOiyX1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lR0erwDgzrfV/VW+jOFdV1LMajh/Lxr9kj6PHtGJ2ocf8UYF7Iiev7SR8A9tEWCgQ
	 sGQtqYw2ORhpBucNtP8LdQbJ2LzOyaiGIT6GaPRxahcGCnJYvfk2zIa2QDQdELHN+q
	 LDPB97EOuYOxIXGpx3SApeYztROlPB3s165Mf1Ebdkc8MxtMhYw0Qg7ZigGsuTDNt+
	 4MaV3BwpOvKoQ8ZSXNh6PVvDFHOyQvSa42Au5ELtabRp418yDLMNKvbV2FwXbBCEHB
	 pEHEJMklR5yaZnxH7xQJ0j+dYjktwFbJkpFZQ2YSOIlpfPGyMlcDbq6rW8IO8Ibksx
	 J7LMo5ew01Djw==
Date: Thu, 16 Jul 2026 16:38:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/mseal: limit scope of mseal address zero to
 address zero
Message-ID: <alj1Cyt4JvbVM7tB@lucifer>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
 <20260716-mseal-fixups-v1-2-3a9609bf041b@kernel.org>
 <aljyYdgzRZW1kIhs@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aljyYdgzRZW1kIhs@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8993318000A
X-Stat-Signature: dqnrhduj6hs1k1uhswn57zhe8serdhnd
X-HE-Tag: 1784216307-301565
X-HE-Meta: U2FsdGVkX1+spImdVRUNx0fmoicZbmqMftY6KzmeR0XOjt66+w3hzIqtX6m9C4BJpi3BQK69gJQjOSgASHHdF5SgPRHZA8lr994fbLAohLHHlXx+ivFGMmTGrvmYUU3W4x8QIY6lQBSqIBNIhDy1kAtXRPVjxk8YdLDDAp2RX95rb8pGuonyxqFFPYlC1HUnm8gYClcUZdynq/LHE5TUd3KVXJZSMXmKBGClrp51KwuKD/9BQ7eci1OtcB1+WGWsuGdicQGyETc4zQqM9UcIiB2X2o4aw/U4OA0TSbmnDosanhhHGNihOI7nDckw9O0W6QN0Ylkiki+WuEy4GZ8tSaKOosGhMPJogMc1uC4XnZVyNVfXh/kCvbur1wVMorAqmoGHG45dhrg6ZmuQZSoiUMO5a3IERFQTeKiZpUhHZAB/fZB7rwhUlfee9vLg9E9X910q/xVpiKTOM33Vvr/YaOqTHOaJl/VLgVttx/Wy96tPCK+8w00/IoEpf4Uj/srEJyTZUmfi4KE8viKHEdIAR2TQXFFubVEuDbv255zt7n+inXfyANIza72JmyuNox+fVOkDHGJwRZCm3YYguHZS0lIEUA1A75F0HJPUCIqvmgnoYIlsM43xBL2/YXSXZL0WF2GB/sx6QmRVuR4f6cSw7ZJoAIbYbIvQofEtKoTOHYc9Kdn07IIbsDXftr8wJ4+4zsOKS1Spsk4kmB5OXS/ucUHDw6nqWW2akL6XdWCnc2qGdGd5LuObC2h4bSpTl5QKg9B+mR6yXW9Tn50QehtbWNuKMsww2OZYQ6VGhTTtYI9OPstn58vTaHqAAnZ58W4U0DIlkCt7vodoIemcaPZ9PT8GvpUK9QYtVeuy9sMsYXJwGsX+FEXlNVQD4uGU9tDQZX+JhpkAWuJzRpjvx9Jo/bq/cNLQocs2LyYC0gxYmoZXq7NkVHsuAmyF5WB33jVI8ArVk4feuVNZ+kb+Qk/
 /oBu5fb2
 +QfhC5a97gRS4B8T0gxAeUsj1b1i5huupBXTIzQAPxuztB/hO/ewfkElACgApfYd7v4Ywxe0LKZwXRCpE/1l6HpmzHXZedDQza3hfFwH4B0vIEUvjAKXX69Cm1g5wpMJ1nIu9ccJMpJqqe5j9qYvWdxI0KWUIngZhO36WSUWGB2RjwitpW+DMQFZkdUuruWdedrEdn77u1+fJmGZ3/4xvDSUaQ1g5MIz6xoXJH8EQXPzJsbSVO99zT1H7RLs00Se3TndymJLP5Ry/eYOs1Bnk/goQtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 04:06:20PM +0100, Pedro Falcato wrote:
> On Thu, Jul 16, 2026 at 02:43:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Commit 44f65d900698 ("binfmt_elf: mseal address zero") unconditionally
> > provided do_mseal() to any internal kernel caller in order to address a
> > corner case slated for possible removal.
> >
> > It also incorrectly attempts to mseal() without checking to see whether the
> > mapping even succeeded.
> >
> > Restrict the scope to the corner case by providing mseal_mmap_page_zero()
> > which asserts the MMAP_PAGE_ZERO personality.
> >
> > Avoid unnecessary checks in the start, end range by abstracting the actual
> > mseal()'ing to mseal() and have mseal_mmap_page_zero() call that instead.
> >
> > Only try to seal the VMA if we mapped the VMA.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  fs/binfmt_elf.c    |  7 ++-----
> >  include/linux/mm.h |  8 ++------
> >  mm/mseal.c         | 48 +++++++++++++++++++++++++++++++++++-------------
> >  3 files changed, 39 insertions(+), 24 deletions(-)
> >
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index 16a56b6b3f6c..e3131a311995 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -1353,11 +1353,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
> >  		   emulate the SVr4 behavior. Sigh. */
> >  		error = vm_mmap(NULL, 0, PAGE_SIZE, PROT_READ | PROT_EXEC,
> >  				MAP_FIXED | MAP_PRIVATE, 0);
>
> I think pedantically load_elf_binary() should error out on mmap error, no?
> Not that this personality is used in the big 2026 however...

I'm not sure I implied otherwise?

But yes I'm aware, the point is to not try to mseal() an unmapped range knowingly.

The fact we 'get away with it' now is irrelevant.

I can update the commit message if a respin is necessary to spell this out (I
thought it was obvious).

>
> > -
> > -		retval = do_mseal(0, PAGE_SIZE, 0);
> > -		if (retval)
> > -			pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
> > -					    task_pid_nr(current), retval);
> > +		if (!error)
> > +			mseal_mmap_page_zero();
> >  	}
> >
> >  	regs = current_pt_regs();
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 550fb92957d1..87feaa5a2b78 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -5291,13 +5291,9 @@ int reserve_mem_find_by_name(const char *name, phys_addr_t *start, phys_addr_t *
> >  int reserve_mem_release_by_name(const char *name);
> >
> >  #ifdef CONFIG_64BIT
> > -int do_mseal(unsigned long start, size_t len_in, unsigned long flags);
> > +void mseal_mmap_page_zero(void);
> >  #else
> > -static inline int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
> > -{
> > -	/* noop on 32 bit */
> > -	return 0;
> > -}
> > +static inline void mseal_mmap_page_zero(void) {}
> >  #endif
> >
> >  /*
> > diff --git a/mm/mseal.c b/mm/mseal.c
> > index 207fea89c61e..5930551d84f2 100644
> > --- a/mm/mseal.c
> > +++ b/mm/mseal.c
> > @@ -32,7 +32,7 @@ static bool range_contains_unmapped(unsigned long start, unsigned long end)
> >  	return prev_end < end;
> >  }
> >
> > -static int mseal_apply(unsigned long start, unsigned long end)
> > +static int __mseal(unsigned long start, unsigned long end)
>
> Why? I think the previous name is perfectly cromulent.

Because this is what actually mseal()'s, the _apply is not really useful.

The __ is because it's unlocked.

The point here is to eliminate useless indirection, so calling the function that
mseals, 'mseal' seems sensible.

>
> >  {
> >  	struct vm_area_struct *vma, *prev;
> >  	VMA_ITERATOR(vmi, current->mm, start);
> > @@ -66,6 +66,38 @@ static int mseal_apply(unsigned long start, unsigned long end)
> >  	return 0;
> >  }
> >
> > +static int mseal(unsigned long start, unsigned long end)
>
> I don't like that you go start - end on a function called "mseal". The actual
> system call goes start - len. It just looks confusing :) So either rename it
> to mseal_range(), or make it take a start, length pair.

I'm not sure I really understand the confusion (I suppose you're equally
confused by the lack of flags parameter?),

I find it silly that we avoid function names because a system call of the same
name exists.

But I guess I can rename it to mseal_range() since I don't want the series
blocked on silly naming issues.

The reason for passing end (which was already the case) is that the syscall
already calculates it and we need it to do the actual mseal.

>
> The overall spirit of the change LGTM however.

OK.

>
> --
> Pedro

Thanks, Lorenzo

