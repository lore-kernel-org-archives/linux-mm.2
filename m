Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C899FC9830C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 00:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1695F6B00DE; Sun, 18 Jan 2026 19:40:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140A96B00DF; Sun, 18 Jan 2026 19:40:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D176B00E0; Sun, 18 Jan 2026 19:40:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E80096B00DE
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:40:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5895F13B499
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:40:55 +0000 (UTC)
X-FDA: 84346858470.06.FA03AF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96A26160009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:40:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GBHlbexQ;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768783253; a=rsa-sha256;
	cv=none;
	b=xlBUVOZWvQqjuFFZyn5vJG7LQuNtmlrgHEyl6IJc27xhkkquzqEXnoxTlWzIsh28SIuSyT
	Dzscv/KS3GnqRya9/wXw8HVF/PLYEevxz3WTPvMb+5Dix23jGWbqOhpa/UMr4zPOTEG5IF
	igrWQsd3kDijRnc4IIkSu2cdhHK7ZIo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GBHlbexQ;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768783253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7jHFRnAxBhd7Ju0pSjH+oqkTOInKUvArk1UZYjnEn0=;
	b=NH+nb7yyGyPfIaVPXkY7vj/07ai1vrIL3DI75ELLmJ/P2lgt++8fFEWd8myP1qiHv/pmRw
	M04ZjWsScmq2aTOdI6FBf33I4R8QXMROQKpPa660uEcmwH3FXi9qiQ0jjvbWKAoaozsFR6
	VD+Z2vWIeJdpWT3/Cag6k8PWBuUSQZY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C964860010;
	Mon, 19 Jan 2026 00:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EC6C19421;
	Mon, 19 Jan 2026 00:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768783252;
	bh=o5d1cIK9KCyPp4LwqwZ0dTGeui5QFRzjlMGckHWgW90=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GBHlbexQ6+CtEWF2lGBRULaWx/fWd0Sj7qc41OJ/qYSvXnJTDYkZ/s45tQ8m3amMh
	 9aYfDkBJT2IHKL7s7OuKB3Y8OU+S6TgSQjrViPmqUTQ9pCkMId2d8xMA9n66A4kFFx
	 KFVtvESlzZa+VWAKajmajm2KqBiXUDRjBAadoWPk=
Date: Sun, 18 Jan 2026 16:40:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, Joanne
 Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
 athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
Message-Id: <20260118164051.521de8ad2758376c3e1d2d81@linux-foundation.org>
In-Reply-To: <01ebe0c6-6135-4937-a758-93a5fc78d7fe@kernel.org>
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
	<20251215030043.1431306-2-joannelkoong@gmail.com>
	<ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
	<616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org>
	<CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
	<238ef4ab-7ea3-442a-a344-a683dd64f818@kernel.org>
	<CAJfpegvUP5MK-xB2=djmGo4iYzmsn9LLWV3ZJXFbyyft_LsA_Q@mail.gmail.com>
	<c39232ea-8cf0-45e6-9a5a-e2abae60134c@kernel.org>
	<CAJfpegt0Bp5qNFPS0KsAZeU62vw4CqHv+1d53CmEOV45r-Rj0Q@mail.gmail.com>
	<01ebe0c6-6135-4937-a758-93a5fc78d7fe@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d3p47rnejowwyo8fueewfaggzzkphskj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96A26160009
X-Rspam-User: 
X-HE-Tag: 1768783253-746652
X-HE-Meta: U2FsdGVkX19KhDn13Yu4iL85BJkMDxpUi2Fln1IyWXVAazv665qQzC0Ge6PzUOvFX1p4z3mdfSLA4AwmSue2qQcyYiknM9plQWq8lbGSGFVYMAcmRNH+xrjRFcyKaA7IGuKTv+3y6XiUY+wUk3yAIRbGWoNMsaLgDXZ/+H9GQoYHmB5mQJQfesxOlSLCRLW42WSpV7YboNtglsnbUwXnwXhVluDqzsdWVlqfWUAxolLQ0vdOrAiWyDUyJVV/vo5unZW0y+9Ld+ExrogZthePdMe9LzH6PoyPJF2m9rxYXVFcxtD2cbozdZ40BmqHtVIc6d/zvsmdV4D5Hu9dxKW6eqIFbGVpaqt2JE/eqXuymmV97518nOCW+WV7jvpCR/U5wgz/nd8H/5/vfysJVi1meOA5eAZejDA7yksc9NuvzkYiqyt+lkY3uzDgJnBGu/9P70d+G36esliPWKFHJmVNdpAqTmqBqubfAFm+S+w16yWRma1lvICa28WRha04X4LEGWDAYJdEEbZo39U6L+P4KcUF1Ilh1GjwVMuyJAqrMLqwKUAA6y6lP/feVJgVt3XFY5T5aptW7xiP4iW3yQzZDWxsCBK8n/y+vtjY6JEca52qxbDD/HlzPlrQYFC1OzbqICY1H9tl1LyCDe3GqZ6YzQLN9AVW5Uj0fx/WQqf2lxoWVALQAoKIczSEI3PmFfa1v43TQyNFr/4wDjAo7IPw3kowEmaeFQ679BQgPbkBdKa+G3ZfgpgBhV9ZKWzC6s2MgaftfvLDxtiynNY4selSmFMNkzhqitadl7VBJ1CH6VEfsJsSarUHZ8x1M54D11GrLa3SyoOzS7HbN50vBzXtbXNwxqH5JmoRTqZ+bedM7jnBUC4tM/Fj86Eqt6ypEm3TexXLaGuM6hHUx25+zTVCpsg9Fl4l5dkcbOGU8t0H5Gp/R7UYHpG7qwGVPLItGJ7Kb0AdPTSSJXhTwJWL4gP
 v76QQUEI
 wgVo9DUDgDBPhUsDplFzI63uL/0MJdXk1af09svHO8ZCa3X4+qGfz3thMjhDQaL2wHPQ99xVg+jSIe9FJlSO7QWscsBcTTEv5AzgLAlexRcwHYFKUM41DO+wQPDNW50kSzw7LUz+Rz3hNaoC8MQYYFkyVt2v8tuPygX2v7ekY3gIvx3ns01DjbzUhAJW2P19nD0Et0d9q7XPeNfL0o30huwO+FzalCzLoMmJdGteyBBXmQHAgU9nc44V+Do+BhPpeboFft6SQoW/0lmEkV/DDL1TkOwG9kA8YFPv4Y8qafF9DAKto33vzPJJKWRt7aoy3SyJ7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 18:54:47 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 1/6/26 17:05, Miklos Szeredi wrote:
> > On Tue, 6 Jan 2026 at 16:41, David Hildenbrand (Red Hat)
> > <david@kernel.org> wrote:
> > 
> >> I assume the usual suspects, including mm/memory-failure.c.
> >>
> >> memory_failure() not only contains a folio_wait_writeback() but also a
> >> folio_lock(), so twice the fun :)
> > 
> > As long as it's run from a workqueue it shouldn't affect the rest of
> > the system, right?  The wq thread will consume a nontrivial amount of
> > resources, I suppose, so it would be better to implement those waits
> > asynchronously.
> 
> Good question. I know that memory_failure() can be triggered out of 
> various context, but I never traced it back to its origin.

I'm seeing unhappy okays from David and Jan, so I'll upstream this
patch later in the week, unless someone stops me.


