Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B712CCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 21:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929F76B0093; Fri, 22 May 2026 17:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903096B0095; Fri, 22 May 2026 17:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83EAD6B0096; Fri, 22 May 2026 17:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73EEB6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:10:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22A921209DD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:10:00 +0000 (UTC)
X-FDA: 84796298160.06.A2098A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 86B484000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:09:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kf40v70l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779484198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3CBQc/NNGcZh45uWBZuxyVBDacJtEW2keqfWeLE0WrU=;
	b=i5fCArMB8lIdy4uKltp6r24lzrLCo5Ia2LLYwwbvQPocmgJ/j1nLjaSpRFdgX60rr5vWh4
	Jln5FLb5DP6aMtUgNhzUpiz6mTblYiJ/c/ZxdcVokm1S6qwQzcY9EvjKbbrTgFhVlUAsn0
	eZT7B9i5KD4tBDeSoVi6SydiM9zp1VM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kf40v70l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779484198; a=rsa-sha256;
	cv=none;
	b=LIRhu/tD1FvCYhOpQcCCSJxSa7OVue3KjF2tBjnwsTpwRlkLEUWmWXWXYy7b0GwuyjTl5z
	eFGhtrssL2ak+tGzwvMFKbFoAoh/2ufxQ7wSDBoCVBLpOBvOJJmGe75E9DudSD74ORZSx5
	ihRmC15dosEKIPs1SwIfQV0qoCvGLhc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05B1D60136;
	Fri, 22 May 2026 21:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3351F000E9;
	Fri, 22 May 2026 21:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779484197;
	bh=3CBQc/NNGcZh45uWBZuxyVBDacJtEW2keqfWeLE0WrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kf40v70lZr0HhMrlT1U+T4mkJ+EE78e5NPB+Z5BjGcwC0Z5f5DxD+iKxmLZu+JTLy
	 hzISx2ScNPx+lV/VvvWBftJFiQ5vTPGicdvVBUsLbhECQxuGUhxji84AkG0ip8o5s2
	 EvzBkmVoFKXgYadFygNxZe/1LU1L2dHr4uTmalcDGO7hg7RQKxQ4+QoWHx0Z6/Zzxe
	 oetb4OfKhYCiUvNs7yjqWoNbzEcQQ9ZN6JgvSEuQWX4WMKM4S+7M2+DFTw5V5qRd0L
	 KGMWBoiGYMrC3CmietTy9A4+Ym2IY5802LCiZcUA/r6s8KmjqSBOZRbAMRc9SvVjry
	 SVng1//GHLC3A==
Date: Fri, 22 May 2026 23:09:52 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec: free the old mm outside the exec locks
Message-ID: <20260522-bezog-kupfer-gruppe-e2ba3adfa44a@brauner>
References: <20260522-work-exit_mm-v1-1-bd32d5a560bb@kernel.org>
 <CAHk-=wgJRmdjDQExRP67GprmG7VLopuuaWMyZr4YNp2NvdNbKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgJRmdjDQExRP67GprmG7VLopuuaWMyZr4YNp2NvdNbKw@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86B484000D
X-Stat-Signature: yzqw81z8fdqajw96mkcukdhthmnjfzcj
X-Rspam-User: 
X-HE-Tag: 1779484198-742686
X-HE-Meta: U2FsdGVkX1/kk3wdqi461cLAx6u2GNrFXT5hfjnKuuZjTLqWjxtEHUBF1Q0cAX3pEBzYKqmhpuLedKfmwrFxoDnQAV5cr7rshNRmcCb6GF5ke6kazwmZz35a1xIvngKiqLF4CLvMeIXLqgbDxHE6yBSNtpMjb9xoGwc87RtXAUNDBwC4fCnsSB1qWFe7/zDzvoDnqQ0UjX8b25QQlDODBn34KAKIRLtoS+8kVrRaeZ+58xP92D4jhWoyNZ8gMaCODEyco7LDf7+NuUhAulPT6nH1HSbk+qpsoCV4UKHqg7k6x/Qk+peY7vVMUTxLCNpxwqYm/+WoH/uhpilqzlBdWvmMgk6sR61lZb3ORLdNDCYvsSkQ6WLPUnnEogFszPggJoPPtrEOmmB1/lsyxr81BCC1Sa3ubfejvY3pRC36oE6zY/99e9m4j1Z/SdqCdlbhSsdUa4F/kwd9eMWBH8XdWOA+sm4s4OMpS5whscVPmuP4F2DO7I95ZW3CtvVVIfl8rqTeFomYY0mEy5acbDacov2aeJmrF5VruEPPsV31t9L6wiJzRbL8sBLWCxq/XN7cl5UjYNMY3rXLndZza2zEx3K20fK/gD8IPKx6kA1sFAcr6Kb6Lzt70s2RiCpAWlkG8OXhvwkqJIXr7s3UbUpv1IR0KMmKpRcbvoqI/eH110QMsaxTqTrbZSNn8k4MBEvt0YuxLvoErybUcwhhazG/uutgpULt0VVd6afFj0tRuwisqji6n/Ka9+jVNsV2JEw4sgyJDwKFFekz9z06KB7E4jFMZcDwOnQYOijFuNyEXQBicSEiBjOVjaFqcQsP8VrSNMwySTZjX2N48ZX5bJP3C8lonMEer8Yt6fQPNxN3a0U5KRFPanjHOZ27WPncS9wZXfeOVZnz9QjWlPf+i4h6jE6VVB9wvzgSR/QgZuYvS4Rwy2KfgcVqnu+PI9qJgYG5/oXVWiEsFBSZ/baD7pK
 887LsRn7
 9f79baLduikqTLIEn1k21tlXzhkfwQSOjz+bmVG9yyIMwdPbUR65Q6dvjF6H8LmvyQbhkKN2nOe9aZywofvLKa/nwtF+srb+nWuPSdp+JZvYJRIQocNKyKIUbjamOulcAWDHu8QaMqIxZ339gDCeOm+wu0PgZhiQMuB6jnRo82/qxh7lC1rpuV+TXBFDaPKIiFZeKrtM8W+ThtTIj6it+619C7Tyraav5PqskWscw8B9YQMtUIE/9Y9qLL4YB5k52ItFM5hIURGD0jYuftjBYhqJZsGtwaQcppo7RIvefjTk7OEj/qP9tNsKOCKKlECFONujwNPKnuUH3JLZohPz3k/ni1b0AoSe+Qdtc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 07:24:09AM -0700, Linus Torvalds wrote:
> On Fri, 22 May 2026 at 07:03, Christian Brauner <brauner@kernel.org> wrote:
> >
> > If exec swaps the mm but fails before setup_new_exec() runs the old mm
> > would leak, so add a backstop in free_bprm().
> 
> This looks odd.
> 
> Why is the free_brpm() the backstop? Why isn't it the *only* stop?
> 
> free_bprm() is already where we clean up the new mm if it wasn't used,
> I feel like it should be where we clean up the old mm too.
> 
> IOW, why not remove that whole thing in setup_new_exec() entirely, and
> let free_brpm() deal with it?

I was undecided. Both work. Ultimately I went with the split to get rid
of the old mm as soon as possible. There's no actual work happening
between begin_new_exec() and setup_new_exec(). So the old mm is really
just pinned for a short time.

Moving it to free_bprm() has the consequence that we pin it across a
whole bunch of work. For example, for binfmt_elf:

* setup_arg_pages()
* mmaping the elf image
* the whole elf table setup

So it felt odd to keep the old mm around for all of that. But if it's
clearer to keep it until free_binprm() we can do that.

