Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327CFCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 16:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926056B008A; Mon, 22 Jun 2026 12:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7556B0092; Mon, 22 Jun 2026 12:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE5C6B0093; Mon, 22 Jun 2026 12:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B22016B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:58:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 328AE1C135C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:58:59 +0000 (UTC)
X-FDA: 84908158398.23.6951C87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 35B684000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:58:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s+wGhbBS;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782147537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wteg9KqRUVkfOS3mlSvn890zNUJTJ36A1pnkvMGAiZw=;
	b=U/Hbms4fSE73pZCDylGnZPQUNm8ApTYn8XDGB0kMI4dfZkeDLkEIBL455fs0BjIbON6M9Z
	SAi9lVwoFfGx/8wL0dARPvN8OxgxGWhur0MEitp+rz6BSBtxnn/p3s84oTBkItddqxpOyC
	sx86cqFXOE2D1rAv6NeIUHiCpiGRZxc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s+wGhbBS;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782147537;
	b=x34SRtTprp5KjeXuhzn6mnwKd5MbZX/IA+u7IDhQfJlPBohOw2y8VUup/KXoWRrDg33JMa
	LvZSt6iLwu5bheNuk31bf0FepybzEqr/ui/8ZYVoSXEF2VE7idUgunWLaOKj82qnXAy9Kk
	RofCb6oempQ7qZx4919+/OlGmMmgRts=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D060601F3;
	Mon, 22 Jun 2026 16:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E5B1F000E9;
	Mon, 22 Jun 2026 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782147536;
	bh=wteg9KqRUVkfOS3mlSvn890zNUJTJ36A1pnkvMGAiZw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=s+wGhbBSz8S4aE8ceJeNSjIq29b/XvV9182QDDz5gOQFHOktd0YKeAj0QaiKCxXHx
	 56JYfOHZP87mmKcBySns95ANIZL1UbcghqLb0790x1IC+N1VKHUPx3Ff/m1R1yDHB9
	 joFEFNYD7OxpTHOKhuGg5VaESvYXLRRUxKYmXhxs=
Date: Mon, 22 Jun 2026 09:58:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, Frederick
 Mayle <fmayle@google.com>, Kalesh Singh <kaleshsingh@google.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert
 "mm: limit filemap_fault readahead to VMA boundaries"
Message-Id: <20260622095855.50e4276e331cb2d01db7183a@linux-foundation.org>
In-Reply-To: <ajk-NMghY50F6Sli@lucifer>
References: <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
	<ajVz1nhMn2JwucMY@casper.infradead.org>
	<ajV0TbwEyaKMzoa6@lucifer>
	<ajV49Fyogfa6aIjy@pedro-suse>
	<CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
	<ajWAYBXHJniJAO4u@casper.infradead.org>
	<CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
	<ajWXEn7gECvgG7F5@pedro-suse.lan>
	<CAJuCfpFfr_SQ4ZDFojOkDKWbO2dKdL3pUPA06B2ZC-usUnYRgA@mail.gmail.com>
	<7ftrqtta2bw2xxtrzelrs46t7khr7tf2vmh2ur2mhdphtymlsr@rqbd3pfjxdp7>
	<ajk-NMghY50F6Sli@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gcj71wqzbcakgd5638duewna4fnjbraj
X-Rspamd-Queue-Id: 35B684000D
X-Rspamd-Server: rspam11
X-HE-Tag: 1782147537-384258
X-HE-Meta: U2FsdGVkX1+Hi4gt/D158mkyukA6TFV7X9tDtugD82e0x+yZ9kzNaWiGuOxLpQLU5IlmvLGZ9bMVeoAN3hKKb/KM8wVP4WcgLjbjRxdB+Zcgvqig1826bB+Ca92DMc6z8AwueARCnqKbL7umdQZ9asETw2tOanfykg+eGNhZ7839ymWwHP+YujnyyU3Oyh2ftxG/Q+aKfA4i7urYDdWZUYt9eGVODGm3t1uVnns5QXTSNNawwTQtHy0fBV8rEON+YkM+x0Q0mgxhatukrdHy/2EYdqHxzKEZTyJZolpYq7846cpcVobGlxa81nkdc8cV4X9AaQSqntugeTbsWE+Vgl02PaZEF+r8fzhQCTywjhujIaIFHBCBTl5GTf7Ya3Z77lpdsOE05nf3vgn8tGY+wRSDLYFiYWq6pSvx5U+7yqOJlukt3AjjjDoBztAPpIzW7N3njZxHBER/GvjTzj9APGTs07NxLWCKHTKB3kOFXZOvEotNlEOGCJUGwbqP3dAH03330tMDQD7/8Ys3HUUb5/nbK82TtUSFmhylWFPlRDWnZ2O64AJ68aKOqykvccjtJsX5axf3YGb/wikKC6fEZBZpKP2RBMEHrKQhRY423rho9EQbqlLvda5x27EAu+6hsT6RO1s8r+UsVyPGX2nE1ehpxRoirsneo1Wxdy0gqQdW+wW0YSpKFmm6nL3dk2VdCp+4x46Khsw2yvNs1xocJMenFiKf6Zo+P6+X55A08zD8zTsRzBhXpwA/PNxNXqAyZwehwW09LRlauBQquZ92KTRXDXi5YfNNz55SmBYqwvESX+BuDCFVnUBX2ETwo4PIobpn3Dy46JTfBgZjT2qvbsp+B+D1bamjvD6e4UPS6jGJ+CEc4il064yVrn6qh/CsydB4IK02w3h2Cp40Tn5YdruIXvVoOiOUts+YBG1U/I6vKlPGCmTdSMBD9yDOxpue7mOmVUORfdvgBj+EJQS
 c+Gx6MPD
 ohJitwBlynW2i4GG8YWS/D8D3m0SWlnM7l0jYmBx9J8QeQMyrq4a2+rX3B5P8Vai2PiZdQIkyv4ssJC2GlNmWV0+AsacNMrnwqOKm/ssxYrapn9k66EWqUX6txffCsvtk0NHwK2rn6Abj2JO0DE72GplEuk/Mg8a2Am/8ctbl+AujyvKN1+eYYM9jtaBCW1we8ehg4dqz51ce0aOY2tWx0coPw7tzhalyV2gCQbmYPij7vpa8QXKjpK9BeMJiTSIN/h5O3H7WO8kOuxvN6saQixqO+65qu/4V0UZY/5+FkkaRTa0l63plOztAYaO3FWwI70Rf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 14:55:14 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> > Anyway I agree with you using mmap-frame-by-frame approach for this usecase
> > is kind of odd but not completely insane and it does demostrate people do
> > odd things like this. For others the usecase of Android doing tons of small
> > sparse mmaps into executable might look odd as well :) So this seems to be
> > one of the cases where it's difficult to please everybody with the same
> > behavior and we usually stick to the legacy behavior in cases like that (as
> > much as I personally find restricting mmap readahead to a VMA a sensible
> > thing to do). We just need to figure out how to improve the Android
> > usecase.

Would a helpful heuristic be to do what 7b32f64bc512 is doing, but only
if PROT_EXEC?

> Reading the thread, I think we're all in agreement that this is a workload
> that exists and we are regressing it here, thus the revert is the right
> course of action.
> 
> Andrew - could we move this to the hotfixes branch please?

No need?  I'll send Linus the mm-stable batch #2 this week.

