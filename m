Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4146FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275226B0088; Mon, 27 Apr 2026 10:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE846B008A; Mon, 27 Apr 2026 10:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FE76B008C; Mon, 27 Apr 2026 10:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E787D6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:48:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0263DC2725
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:30 +0000 (UTC)
X-FDA: 84704611782.14.D7CF2F0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9D86AC0018
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oRBWq7Ar;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XtHe9oOA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oRBWq7Ar;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XtHe9oOA;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777301188; a=rsa-sha256;
	cv=none;
	b=vK2iZSCYfyAjjwajnMlMNiq37lO/w5iG7SgWVqQN9E/42p+73AsocjylXKOEgl0GBVWv2r
	7ifETC3hTzj8lK4FYN8a2WwbNQgxP8CzIRkrwOh2xHIG8IEIoTxRP7vpbwMvZWU1gHTUU1
	i0KSABdm365jZyESAhxGlg4qNmTQq/o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oRBWq7Ar;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XtHe9oOA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oRBWq7Ar;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XtHe9oOA;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Al/x5q529VJCE509yhGj5VG+fYkakbkdSGNT/ABWIts=;
	b=H9mBJj7c119+A/GSCfbk9nZlTB9658s6V+V2HTj3FBp6S3CVrcczbU+G985vVgcuHeQIOB
	MKTv+9TeSsKpI2NJ/yfR5hTL9M0OamoifMEJ7Yh3rEC+CXI1at8F8RFO7oCfmau0JX1K9v
	GlaffZ7jmwozneg6IdwMHzkYMlpJxYY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C6DDD5BCC1;
	Mon, 27 Apr 2026 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777301186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Al/x5q529VJCE509yhGj5VG+fYkakbkdSGNT/ABWIts=;
	b=oRBWq7AroN09LeiAxf+DsEYteBQmd8Kfa0ldNWmp7lV6XCsHt+tcP6Cji/62JJ7exMlWux
	zItvL8PDpZi6Q2ukL0m4ColIWrUmw8ZEoUz+1Zqg9thPnx9pUEXcHPc971TF6GvVIk8W2G
	esYtsNsw7b7dMYB2O5tIrWzPEDRkhd0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777301186;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Al/x5q529VJCE509yhGj5VG+fYkakbkdSGNT/ABWIts=;
	b=XtHe9oOARok/7LgN5sOGVBDIb9GdZ0e6BCrgRyXJZIotx4UL5fK4pijFd83YIm2lcCnIRY
	WXxezlams5u4/3AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777301186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Al/x5q529VJCE509yhGj5VG+fYkakbkdSGNT/ABWIts=;
	b=oRBWq7AroN09LeiAxf+DsEYteBQmd8Kfa0ldNWmp7lV6XCsHt+tcP6Cji/62JJ7exMlWux
	zItvL8PDpZi6Q2ukL0m4ColIWrUmw8ZEoUz+1Zqg9thPnx9pUEXcHPc971TF6GvVIk8W2G
	esYtsNsw7b7dMYB2O5tIrWzPEDRkhd0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777301186;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Al/x5q529VJCE509yhGj5VG+fYkakbkdSGNT/ABWIts=;
	b=XtHe9oOARok/7LgN5sOGVBDIb9GdZ0e6BCrgRyXJZIotx4UL5fK4pijFd83YIm2lcCnIRY
	WXxezlams5u4/3AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6643593B0;
	Mon, 27 Apr 2026 14:46:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gxg7JcF272nbKAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 27 Apr 2026 14:46:25 +0000
Date: Mon, 27 Apr 2026 15:46:23 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, wangzicheng <wangzicheng@honor.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Matthew Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
Message-ID: <ae91A9US6ybEzqM2@pedro-suse>
References: <20260418120233.7162-1-baohua@kernel.org>
 <w5ekxean6g6eph4427frzclgzu5hrd7kqres3ronlqpvqtsusb@kfdagnk2xqif>
 <CAGsJ_4wo8Chd-B8oRwTEQsU+CQu_tvwmkx=PdNweTBTQLDsRUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wo8Chd-B8oRwTEQsU+CQu_tvwmkx=PdNweTBTQLDsRUA@mail.gmail.com>
X-Stat-Signature: pjxwgpzzw8ifogd4cw793m3sub888gmb
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D86AC0018
X-Rspamd-Server: rspam07
X-HE-Tag: 1777301188-876146
X-HE-Meta: U2FsdGVkX18jmdPTOwb/4utzYztxuyaOBRIU0eVXGV62SEKS+lLoWsnQzS4xyz3HuYcLQmJZMZUU0ZXLBt+zojeODzB1leuHv0rUpq3JIWJ7FcprZdbLtxtiyIckT0ppoc0Wj5GkTA5X+91JJlqkkt2IIxsLotO8ZO4fLUb+IAvfP7kSXzQeN8jKb3QLoiQ8s10uDrot/h8xQdWgC+tbmtfLkTx+QfquWvlQ0rFLPo8aeaqzF3AyWGjPySfvRtpgHM8Jhxxs9A4FqTju1onxwE01MO4mw9XVsNidu9Gc4UenGcAbmt62Atp9jKPBdkuQz1XVgqNYCBTMoITODJ3dkObo/SDYyOCJNaPBNZB4xuOFraVlJRc2ohALlazJhjU3gR8qpWXcqArvpc9/p6alHS5ef/2ZWCcZ6r5eeTkK4ujfWoqqbe9QxvoHtHNnq4/7nycoqeJmo8biiNUyfcTutFWjSRHpvim1feA37gzetGHuWsjGN4XBIrT2DQW4p1wb562AFmdrPmCU80oHe7Dz0gZ/v5uRwqNCvONeOeWyvhmj1li7OAoY9VVFLPa2BKyuKh0mMLO1tNesbgQN9ogc0E9HCXPu0m49h7uV9KkoDAs8zr9FwXs5xYtEG9ktWTdiFGi8oSbZ9xb1zIRi2FhGJJfkbk9PXdsMhkCeif7YFSYbML4ud4z4f3kC2DE8Trbmr6rl9DJRTdP4rGNIoWCeerLEHJMnZqVkLxcp3Yeu3X0EjwqiQw+KUgGb1kmfmRcn0Qf5MeXr+qofPGSdteRvRyWinYz36Q4YASBYPofQYyFecVpNBpdXEYEkaVcNuIU76mPTHDr0/fbifNP72WxlPcJtc74YOVh3dWXSy1No7tEnRgACExxASg5Fx+11UB9HwxZc7dUJTZLfoXly4Dmox3TG+54u3+NSPiqTVGprL4kjouhpoLAr88KbUl4/SYQ7ZYry4wmDk40mbxKbCGK
 ubJykWt7
 rX6oLX27+OgQG2OM14/yrGzGU4E43GgopqM5D2unHMnKGJGQhFGS+WmSeoFnQuSxbsn3iAZKSwlCCLF/h6rOw2tsrKVw4P7ZDLrxZDrt+Ad6kB1pzRlAl0LTOFiHHbYcdMIZqAfyn4Ajmzp/jBsJpDys7QCxn01dV/OhTWWjoYQSYJMLyWqE2mTaGweji6k63X6e/skTmrU10HAlv7Dt+djqowoPW4dpfiUtPV7MKSL1d/G1WTW573NMabbU08L5wFR0HvedJ0JySAq+oax2x2Dliubojj+e1sHawJuJL+IeGPgFGFlMVJzKOiPSX+hQ+3E+SPXQFydkquOn8Egtoq/r5DPABQ7LmhyqmYpVeBM4EAUnZYAYo1Zl7KCz/9JALp+04ssK6EKkiMDvVLK3EaNOpfUSSH+wwYY+TVH2zbZ8r4MYAD/kFZToakpoqsO3TSHu3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 12:35:46PM +0800, Barry Song wrote:
> On Fri, Apr 24, 2026 at 11:19 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > On Sat, Apr 18, 2026 at 08:02:33PM +0800, Barry Song (Xiaomi) wrote:
> > > MGLRU gives high priority to folios mapped in page tables.
> > > As a result, folio_set_active() is invoked for all folios
> > > read during page faults. In practice, however, readahead
> > > can bring in many folios that are never accessed via page
> > > tables.
> > >
> > > A previous attempt by Lei Liu proposed introducing a separate
> > > LRU for readahead[1] to make readahead pages easier to reclaim,
> > > but that approach is likely over-engineered.
> >
> > Why does this even need to be kept? I'm not sure it makes sense
> > to even mark readahead folios as referenced.
> >
> > I'd suggest folios should only be marked referenced (or even active, whatever)
> > when they're mapped. Anything else is a bit random and is hoping you are
> > eventually going to map them in the future (which is not true for, for example,
> > anything in an ELF file that may be readahead but not mapped, like debug info,
> > symbol tables, section headers, relocation tables, etc etc)
> 
> The patch targets the mmap readahead path rather than the syscall
> readahead path.

Yes.

> 
> With lru_gen_in_fault() in place, it’s roughly equivalent to
> the mapped case, since readahead is typically 128 KB while
> fault_around is 64 KB in PF.

I'm not sure I understand. How is 128KB roughly equivalent to 64KB?
That's almost a 2x difference!

And readahead, as of now, will read beyond the VMA's limits (which will not
be mapped).

Really, it's extremely unclear why this adhoc heuristic is here. A folio isn't
active just because you started readahead for it inside a page fault. It's not
even necessarily active just because it's mapped (although that is more
understandable).

And of course, because the whole ordeal is already extremely simple, it turns
out that in_lru_fault doesn't actually mean "we're inside a page fault" but
"we're inside a page fault and this VMA/file don't have any sequential/random
annotations".

I would really like to understand why this is here (and this is true for the
various odd heuristics mglru uses) if we ever want to have a chance to merge
the two LRUs together.

-- 
Pedro

