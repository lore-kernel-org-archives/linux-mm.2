Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62798C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 13:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7420E6B008C; Fri, 25 Sep 2026 09:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2156B0092; Fri, 25 Sep 2026 09:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F346B0093; Fri, 25 Sep 2026 09:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 425E86B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:09:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8DDC405F3
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:09:07 +0000 (UTC)
X-FDA: 85252315134.13.199C5DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 100D2160006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:09:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEhQN4GA;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790341746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnAneDTOhSK7ryzvQCKB6l+o67HIxRHTdOaZupVyATY=;
	b=k9Nf+LpxVfR6Y1JWxGkbG1q26dlkbMVF0Tf/+PcsF5dh2utvj2kfMcch64B7pBZ1xbfpWn
	wwK/NomA/1cEgdmb9OezvahT3SSFYmjfSo5xTGZnsOXhJSMC/r5IIODz6qt3tbpbQYrBvx
	e2mfvoqQVP/NF/e2hKmqjEBoE3Btgmg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEhQN4GA;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790341746;
	b=aNrQOGaKgTZE/33WFpjHLW3Hi2rKvU+RDNdxSpctU7/oA6ARGO7Hef80X+xYF0Wf0Eh9Qw
	vXUAdVm9VmlrYkXy5qAYbTu4/dekrC7hNkl3R+RFum3VVE4uuOjHHtP271hGuMnS3Rn1yt
	35+TgJnThYhCmz7Q3Sz+OSXhf1GH7As=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0A6740859;
	Fri, 25 Sep 2026 13:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13D61F000FF;
	Fri, 25 Sep 2026 13:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790341743;
	bh=lnAneDTOhSK7ryzvQCKB6l+o67HIxRHTdOaZupVyATY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZEhQN4GAOPhASTFcl0yG0oHUXqD+yfoiSdvt6qFToohSp1gkqe+tnbg5iw2UDNT95
	 ZcTR0q54BV1+jxFdsZZbUjWnn6U7ji9okb8mXoNvwK1G4FHK6hQ3k8TMhP4a7c1jhS
	 T+e/RyqP6dtNMTzhASmm0jZBz9+BngBBa3qdzeQW5INRn1QDAfgFXHuI56ZuXWYFu+
	 /3c3SUnBXjfc7jtPGEZJXVUDq+x5sgBZtJlkw0WCJy5ERckiqON21t+2sryUSijJ0Z
	 b4xZyZ7B9Kx2+O9uc9/wK/umZA42u1V33/nhxuZzRCy0vTcIulghVKUP/wPvt0/OCJ
	 j/UQ3LmDVli5Q==
Date: Fri, 25 Sep 2026 14:08:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: akpm@linux-foundation.org, tasos.papagiannnis@gmail.com, 
	linux-mm@kvack.org, liam@infradead.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/nommu: Reject wrapping ranges in access_remote_vm()
Message-ID: <arZwZYUNmUUaoJmW@gremlin>
References: <20260909064231.18693-1-tasos.papagiannnis@gmail.com>
 <20260909001341.6a7c3556259f7cf9a79c1da7@linux-foundation.org>
 <m2cxum423s.wl-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2cxum423s.wl-thehajime@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 100D2160006
X-Rspam-User: 
X-Stat-Signature: c6qkt5sj6f1rarxury6thdqam6ts6hhd
X-HE-Tag: 1790341745-231263
X-HE-Meta: U2FsdGVkX18rspuRjBDigZhOBJ6NPr4JWeagOwN9zne6Bp43n2lc8yhlR3ReFxyDCPk6eu3qi5fUzFZ8Sn9qAMaYbdRBXBgqKVKwSC57rpiCGbP9tlKmnPstY5SOB9/Wf6qqxDnyPvACGLdg3U3HHo02a3+5s0321F6jmBm8pwKSrW9rjA4Mj4LREwP3ms+X9AkEmWJnR332j6IzT64f+1+H5DiLSeYfujUq+CsVqfK3Dr8KUTAgU+AWQGZM2ayafVZDsVhxS+UqBMmZ2sE9Mdm3qBDe+RfnyqvncFe21ni+pHAw/NXylLJiFDUP21HdET1CNsx+88tsqhu2XYCQFYFLwxCzsUVyEKLVr3G5rVmtD05Mis2T5LGC/Kzwp+7ihT3j22RUZejIULR7l9SFrfpDlltdN54lVnR/iLDiITo63/rSsSvzgEVIrnn6azk93uQgdUrTTfNjaMKLs0sGTtML/UGLHI46fjK4w+kLasWfGay7uo6CSmvYde/TcqML+wepqzGrjuVDHoSjIchh3DIklyBCNAvldSFjTQMja6IPKE/iInOFBpU6srbesfhNQgZd5VhPQKQEyU6ztNkH2kDqtYfA84PnzI1VkNc2ojcZVU+LVfAyrfGQvAEFI4KzyIO5D8xkHR/OESO8zz4lpDknkdr8M/8ZbnUOpiD7Yf2hOTbLZfB+Qs69UUffHz3vEuuWnNg/IZ1LRt7VL0WAEQLV3YLhpTcJc4N43RZplmAxkBrTVn1zh7wBWtwoXH3f6QewEt+pDITairqMNb/4a+aKZuB9c1k3Z+EaHT3xpLhqmHPsN2qOEZeRXLju25PpbN/4ItAa2Cchv7vjtQMHtX/ymd6SSU2buLIFIUfW8aP6nFqg0iQ3j0vZ+CMVJGjKIVhnRedMzv8UNfFtne0xRSa05+T3J0kEcXXn/GkACVR5hJOHZZ97/jDu2hfICeM7gicayOjZs3anJUkUKv+
 jtQLzvsO
 r/1guMKAEaW6RrEWr2dbseZXhpBEHKm/MdYNSax4tI3FWW12FJFj8ebGgtr35+RnONljYvf7gjMOgpZgYuXDo791wwf0cf3TAZzN+itokgWqcUIaDTf/f48Rm8wL3HzloOf94v/TIjHoCbS7EDZM8OUkN70QVOgslPG7StbyIWzl7cyCXSrS87v4jHebXQCZOaxMWUR4Ijh0+YqsFS4UacououMknKg1OSeEoJoy5LSHtCGy7YAiMqV2yxnggUsOcxNLRTkamdAxasY26/GlfcEL1Dh2U+4+D7MgzAz8ZACZRkx7GoPGLrzy7G+IOZf01Kn8IVH/wvdJh76VnyZawX+sJ5/FHKduQZOEjLVEIobO0eSkxqniP8CCinifsGRzqVKndS5XK0Afq82aYxPMl2WWECtsCr8QQlN4cIxnXDLp0Ms15binsIpdOUVYYTXTvcP3BbZtHe3qknbOcNDVC/M9dmiZYDkSoVuY0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 05:11:03AM +0900, Hajime Tazaki wrote:
>
> Hello,
>
> On Wed, 09 Sep 2026 16:13:41 +0900,
> Andrew Morton wrote:
> >
> > On Wed,  9 Sep 2026 09:42:31 +0300 Anastasios Papagiannis <tasos.papagiannnis@gmail.com> wrote:
> >
> > > The NOMMU implementation of access_process_vm() rejects address ranges
> > > whose end wraps around, but access_remote_vm() bypasses this check even
> > > though both functions delegate to __access_remote_vm().
> > >
> > > Move the wraparound check into __access_remote_vm() so it applies to
> > > both entry points.
> >
> > lgtm, thanks.
> >
> > > This is originally reported in [1].
> > >
> > > [1] https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/
> >
> > Ah, bpfbot scored one.
> >
> > Sashiko might have found more issues in there:
> > 	https://sashiko.dev/#/patchset/20260909064231.18693-1-tasos.papagiannnis@gmail.com
> >
> > I'll optimistically cc Hajime Tazaki, who has been doing some NOMMU
> > work recently.
>
> I got a similar review (from Sashiko) that current use of
> !vma->vm_file isn't appropriate and should use vma_set_anonymous().  IIUC
> that case happens only (I may miss something) with /dev/zero (via
> mmap_zero_prepare()).

That's no longer an issue as MAP_PRIVATE-/dev/zero is truly anon now.

>
> I also had a patch but am currently waiting for Lorenzo's input for
> his work on /dev/zero, which mentioned in his reply.

Sorry, I just added a script to find call outs in neomutt :)

As above.

>
> https://lore.kernel.org/linux-mm/an8BlTgk7sc5vFJ1@lucifer/
>
> Thus 3 comments of Sashiko (all about vma->vm_file) can be addressed
> in future, and are not needed an immediate fix.

You can use vma_is_anonymous() now.

>
> I wish to ask this to Lorenzo too.
>
> -- Hajime

--
Cheers, Lorenzo

