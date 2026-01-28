Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AD3D25B45
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DCB26B0089; Wed, 28 Jan 2026 06:18:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 694526B008A; Wed, 28 Jan 2026 06:18:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6F96B008C; Wed, 28 Jan 2026 06:18:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB216B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:18:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E38D13B394
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:18:38 +0000 (UTC)
X-FDA: 84381124716.01.E97A25D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4E5AEC0004
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:18:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=VzQnCZft;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=YFoQNh6Y;
	spf=pass (imf10.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769599116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BuE0+YkR9qetr5imDGOoHOW4rxCJooClkC81S3EEPcI=;
	b=EBsR2/QGwXfIJkyEspTcKkziREY5VsRW3sQETbpq1hZsB2JNMjJb2YX2ixIt03yDA7wYr8
	98aIN4f7GAVeHJrijiF9JRnMxagbun5ifokxnpJFbaObL4/Gwh0kFB8TNOoFZni3NapJrk
	CEdi+ppnyFgOIoqldy1lLE85fSirQvE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=VzQnCZft;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=YFoQNh6Y;
	spf=pass (imf10.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769599116; a=rsa-sha256;
	cv=none;
	b=nQSH5Y/fs0TB1Rcz7Mn1lM+ffNYx7yvaUsvPRALifWzkfVsUmwgNWQ4G4U+RFJMpvU+0FV
	buAdfFRBoQKfGRtuXpgEcW1Sp+RrEv0j2KvPCqZgJIWkuawubJSvirmhi4bV2Aml6NO7OL
	Ly1VR/vcB+RG+JyU33zwfUGWF1gyvnE=
Date: Wed, 28 Jan 2026 12:18:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769599114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BuE0+YkR9qetr5imDGOoHOW4rxCJooClkC81S3EEPcI=;
	b=VzQnCZftS8+YZPbuC487KzvyJvX8vrJphOsU0eSaU/O+AyHomKDwrVwha/ooBYqOqeVqP9
	V2Vmyi6+G4luDOCRTtPLLXLHQ37v6TgXp6t8wJw5ysHh4T7nJP83A0mowMNsPk5U2uotyb
	fHV0oi/LnHxeae7UJzdd8OOLdir5BmJ3L5ab45VLdigMAbd8dZclen1hnP+MHOKZvF/k4e
	89vSjdCxCczoLtBtTU+HULdZTA9TUZJ3axtJu6XS9kNKWZiWZSO0LrHVZm2WrtvFBPHK5e
	+E17LRuHPhcA7WTCaGt1h1uTlHMWdy7MpSVKGcT2+GJs+OQi/XFTakSRlVGEPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769599114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BuE0+YkR9qetr5imDGOoHOW4rxCJooClkC81S3EEPcI=;
	b=YFoQNh6Yli1yKxYSun4KWK0KoTpLMXkHushNpv1cG8FO1QgYI1dVtL1+4xc8zft5lgTQsO
	pL0N0wwWCKUmBkDg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 04/10] mm/vma: add+use vma lockdep acquire/release
 defines
Message-ID: <20260128111832.X9oXdXn8@linutronix.de>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <fdae72441949ecf3b4a0ed3510da803e881bb153.1769198904.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fdae72441949ecf3b4a0ed3510da803e881bb153.1769198904.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E5AEC0004
X-Stat-Signature: yxfpan3wszeh96153bqfexj45rhombuf
X-Rspam-User: 
X-HE-Tag: 1769599116-257469
X-HE-Meta: U2FsdGVkX1/HiLAynVO7eNUPD/iy0flIh2fwrc/y1J3oXH+uzlF2QQ2ERqYx6smX9SSt1u5Om3xw5zUx+PjNTdBIgYSsHuI+HOIo8LLIUu9JUYP3Oa21yd1dcN50jv8FSkCeUf6Xpixxq2qvFjSskuN1Ms5mnM+l5+vzFwgc3ya6Cjm7WhJSJCS+xrpkuokykcofh2NIrWReAie4vQopr4AGY3J7WbjhVGmavrfP/seB1Cukm2LHDOqa7HEQRsLVvC857FEKNorgsv7yJxQa5O900bo9m6TPX0oXelO3ET0FT3F2lCYZc6MT36JQJrl+zs337/7w0TakDxjZBb4uId5TQnfQZ22YWfSue2VKd2juJrFstCcWLGBHxOhi2Jpt5i0LFas3NDjGY+ql8iDTDSeOTv96LfPW81jHIvpCm3m17e9H1x6Gq2SsOSGEEYVTYE8HhqKpiALPW5HnalWiJJZ0YX7jU6pYRbIMu38r4rItWNRbkKWyS5zGFedzDdtfUkOWSAG+uCxKUgnourM6o4u9V4eXSOiukMV0DUXCU+TaBpZFoYjtuZT6l8Q9AWnlIev6hwbk8CFsAanJ5X43tvv0xVmdXhNDcbg+713YLHKhrM7+z/Wywkvod79YyLsH0jSECdfc+8FPrEvXhFVVyzb52MDox50a5MGG6vLc/lo2x6UnocgIEthuKFPGHbuXskvnIeZwvyYB36Ib9EWDE6a7OQXAFilbBbC2tOwMophI4PeL0wgKYDK0uaUz79ZJkc8T7RbTw4Bor+04njZzpuv6+K0W0HP8lR5Sw6gmoHfx0PvWZIX9RihPPF1bqa3D+nDGsL7t7DLGHBEXe2kQpPU9ixfXpVMTO+rBYScF59I/Gvp61OlHp3Eu9snQxBw9ZOHSfauOwxSclStS2jzLm2aoe8IVRXwRY7aEq0pdHiiKl4Vo2OO5oOARy7HnKACW25Iwu7IEHxdQyrngq66
 LEjjfK0M
 Od5yV7yoKSU61g884nki2EoN7GA280z2gmVCjWCbHINuRytNjqApsHlDnM7rt0wUFqIQYzJlTYtXyDIOHmUxyGdXe1y1oaJEm77G+ZDmn9JYUJSHNygiArbjXsUmHyH5yX+Jn/lodZKPm/BconYGATmRjfH5ZSaENJrqY/zICZzIHtB3lzqD0bFmXP2UxQo32fEvXECs1NqwRZ+nmSC46Cy68u6DT5xclbtYFUHhqP8O0uAIXCMJryew/9QOdZa1E6Nm1v1pdeyP1MBE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-23 20:12:14 [+0000], Lorenzo Stoakes wrote:
> The code is littered with inscrutable and duplicative lockdep incantations,
> replace these with defines which explain what is going on and add
> commentary to explain what we're doing.
> 
> If lockdep is disabled these become no-ops. We must use defines so _RET_IP_
> remains meaningful.
> 
> These are self-documenting and aid readability of the code.
> 
> Additionally, instead of using the confusing rwsem_*() form for something
> that is emphatically not an rwsem, we instead explicitly use
> lock_[acquired, release]_shared/exclusive() lockdep invocations since we
> are doing something rather custom here and these make more sense to use.
> 
> No functional change intended.

This is just "replace rwsem macro with our own macro" which is fine. The
subject confused me because I expected something new to see ;)

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian

