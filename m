Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FFB6CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1377D6B0095; Fri, 19 Jun 2026 15:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8AC6B0096; Fri, 19 Jun 2026 15:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19506B0099; Fri, 19 Jun 2026 15:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCC1E6B0095
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:57:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 30BC91A056C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:57:05 +0000 (UTC)
X-FDA: 84897720810.30.95BB7B6
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2F03F140009
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:57:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vgZ965cb;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of zokeefe@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zokeefe@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781899023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+s618HP/1+WS+l1UzZHBuXzsKacGOTvnWQZyyRwJUds=;
	b=N3Yc9QtqUgTuJCW0cLpS9tKQLXx0oTtOK4CKlYHMcvcI14BX+FXe6HkbTZLGuoWKfxSHOU
	6/ZGgP3ER6WhTX45rgOkv5zXkc12ZoeWXFas7QTgnRjplKBZrFRM5RepzTw+Q4MR5XxQQ0
	EhQUwlIJl4yTzQL/2UByiCLwVNfhrWI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781899023;
	b=JS8iPiIg+gqcYZ+CEXbdRsLQWRvSbEFOmxq+TqWbocA2UKp0tprFjW71CSICa8AmmM7aWp
	kiKnF/F8j0fyYQJbQ/ieNFIO7f34MoBnnJwDFCuoa/Bdizo9wIrjAuVMhIoj9bhCJQY11Q
	9J5Av3ZACyMtx/eWtkZ+1F6xsxDtwdg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vgZ965cb;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of zokeefe@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zokeefe@google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c6a4eccab1so59765ad.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:57:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781899022; cv=none;
        d=google.com; s=arc-20260327;
        b=F6GaFbTTuxFlUHx5QaX8TPpO2CdRHNBVPoAKySR1IF9fMB7NCp+VgZXbjUUkRBBOkc
         iSSgRqAEewXlZzIRMamHS8/FRxfZw5JuOatM99xgqHbvoydXhyKb2ufK6knH6PD/4bLj
         fq+ohP0k5559Y8m93T5Jdzp+8h/IHKlDrWFwRZRu3KGc0+VceovDdUdt9XGGtyteR5mh
         ZfOhfWDcQT9ohbMLS0ZUuZM5nIrYixRLQgXwmBLB3RTvuJJm5DAkqJt0G5/qymp7U0Yr
         AtJjWQ2YFiqpd4Ic6iPUu+qdxyjr2NPn9p6xD0mv0OfIt2xeCpEQ7itvmBfwTzQNbsVK
         63LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+s618HP/1+WS+l1UzZHBuXzsKacGOTvnWQZyyRwJUds=;
        fh=YTaPWp8CEeXA9QzvRnPhK4lFsTbb9Ck6Y+/41STCNY0=;
        b=O6YrTsjyk8BUe1iYAkhHHDXXVxFmOqtmMI0UKU7x7jWObsyrMXYx2ySEKkyMfhFSyT
         To+/IMqgbzP3CKwrexhx9oKbUqN4Dft4fdHA1uv4l1lk8Uy3rf+hFtApytQsGMqUtfuV
         WMPSI28EjgdPGAe0XKyt2JX67lHhwtdzD5i89sD22XvMuPf7QvD2MGQMxvQY9TcF4w/u
         hTb8uj+ZIPdJS+LCyJAthLfneUOO3iQm2DTEMiwripA54Z85Kf/gqDWZ8GuiiGovlAom
         PNbp+SO53vdFYonZWWoSMz/1lYlANMwcpNTEkiz4pc9j+mqaPf5Lb1BoTMe5M0GvE/M6
         t9xQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781899022; x=1782503822; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+s618HP/1+WS+l1UzZHBuXzsKacGOTvnWQZyyRwJUds=;
        b=vgZ965cbLwq/CS652LYR0ip7p2ifGyOgqtWFHWMp6S6f0C1fp7m3Oy3/WvfPlFQ5QD
         sR+6SelizNaoHNcsdz75cKdNuxZBre3mwfksv4rIn1mOdvrWjRu3lwCM8GRIC0jRQZCk
         dxed46MOHfyQyQlqJCSrYnzCu9oqYi6gnaevCvSt5QlFrq3g2hPJVc2SZqz3kSITZzm5
         q9iIuHkbGunHheKP+I0OE8oIJGpC4XoEu8BcIU6gCkMhFgyKlx5EaudnlNlBZdF+hJad
         4gcGbsLC4Uq2sAf9Vo2Y6cJv5FRH/9dEIX8C1p2TLM97pE/M6zWG4J18sSDHgG+5JaZ0
         LaUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781899022; x=1782503822;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+s618HP/1+WS+l1UzZHBuXzsKacGOTvnWQZyyRwJUds=;
        b=GchNnq9SvswjE+37/socjB/9V+LpckdYvac6+4TGRuVEdjShj/4LZT6//a5klUsNzz
         FZgamHgvgq6gdggkCfdqHfYn93g8uechSZwPtwnPPlD8s6elX2Y48FWcW+b7pbacobmk
         ZDV8lugMLLSIzfUpVCUvn22dy+PouA12qYmSOTJAgSWc4X/qA4yjR1yL5U/dL3UURVWN
         KSYkwAIterXkS0mNQPkHcEYe0eP9TIK2iPU+e54PT7W4fIypfOOAdJbTsgVrPAdUDQKb
         j2fnH3kWaWzCkUQaaxk5roiBOKOwSRWN650uemzDV1iRUDf0Awm8l2nyvE+3LrlV/osr
         pwwA==
X-Forwarded-Encrypted: i=1; AFNElJ9zvAxEs5HtJd+l55sBIFAdAwd3KcIsKpA8ad8xAac/0CSJ2LMvAVFDbvpPA8gbI7hr61tQpRJ06Q==@kvack.org
X-Gm-Message-State: AOJu0YzsqSzQkiYGN+chiLxrAvYrLz4p2ZKnQUPGRdePLe6hk6ABSXCy
	Mq24ugEhxTcwEiNQVjh1Ho8eI1REf+fclJWUsm4sPSAbvSRVffAMDMTB2y+u9Pt5nBxgmoglRV7
	tR3kmPS9NwBAd+mCRG7oNBo8NqvSk4C4EojkL/BGF
X-Gm-Gg: AfdE7ckO4ETm4dW+DDfW/pO8LVMEyruqWy2Km/COiwsV5djRjzHPAINBDA1oy0D6Ios
	rSA2cwFHjVc2xrEW6iUv4OUNsW6SLuiu60h4xNzSpLWXqoYBtq6X8CxNjd2pHFkwcLH3265qNd/
	UQgd/CyPMVCIDH6ls8nnnikf15KCkJecdPJg9hzUl44x9bqcGt4kNUeYGuR7sE+PpFz1crRM+pT
	1hiYPVW1PV2cxSQzWKdU9+MD8Cx5bXfbvzP/i+X05u7XQGAEB/xjZ1sijCx36gPsIlQ4O+Vjw==
X-Received: by 2002:a17:902:da4b:b0:2c1:ee6e:4e4b with SMTP id
 d9443c01a7336-2c719054ae3mr2221575ad.28.1781899021344; Fri, 19 Jun 2026
 12:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <aevhw9xqz1pWA2Ow@plex> <20260424232637.054f15dd@pumpkin> <85f19b94-18c6-471d-88f5-c05a2f10199b@intel.com>
In-Reply-To: <85f19b94-18c6-471d-88f5-c05a2f10199b@intel.com>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Fri, 19 Jun 2026 12:56:23 -0700
X-Gm-Features: AVVi8CeLKAhaL24ZETrhIOEQR-ru-FLcpMbX6MU69R7jJfNKrA6Xx-nwOBqNDqQ
Message-ID: <CAAa6QmR899xH4QNMYN8Q-NDOG1R8-Y7ncMsF86cTp2Rw5X15XA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Dave Hansen <dave.hansen@intel.com>
Cc: David Laight <david.laight.linux@gmail.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, David Stevens <stevensd@google.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, 
	Quentin Perret <qperret@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2F03F140009
X-Stat-Signature: 83hg9zqjwnhag5rdjuuej5brjkkjz6to
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781899022-383668
X-HE-Meta: U2FsdGVkX1+oCe8iaehCidAym2tRsuGdz/2Nv2x1PXmWo7+WFaReDslICshNIieSp1IhrOq1bYO6tenZylEUP23s9icLzppna5PvBypmSXzv2y7SOGrUPJE9FXLMbTGqwHxvMmxNGStXcdsOpXnobQIAs8pTRPgzYcZ7pH+1Bf2mkEgP2b8cdhHu/98i8QE/M3wJt6tlZKqnWTz93dVvmlXYM+9WREtMoKlKGGmdYILmEwo6hRuBETKPt5ZYQTRpDBlRJeZAim5n52zl5BS3pbyevZaJX2WbQ4SQVdmucYeyPj7cUF4E64+PYgZt1zinc8zRUtr7AssWd+Tkmn6UX2UMB4YgkIE/P2Yu1TVs5KDRfOcClZPMJt5mZL12gkoutqMtl/AS1xcWkh/ZY6lXnG5ZmoE+V5SAON29P6IcuVU5of3hU4bBqyZYPRpaie0G20EoYW4t77k0xU1xOEbiHet9AIlPSQbcDXjFy3vm59X41hgtefM0xb7uOb4hhFA7gWaWf7LD8RJZ/uBpgHhMCLLiE2kU0Y3puvSHbjZTxKj3tLM05C7bL6FbGvaupWMZdWkNr0zlSzZEy4ifUZaaOwDc/ZmNDcYWj9LKRrxGu6cwsCcYFi22gBP3gY0h2b4otzQIZmD5JxLfUBH9+n1FW9j6HmjEVUV1tPdnhv8XcxmhvsRU3e3kKx9CiPIf2+jqkKNMNOPqJbO/BvZ29RjWUv3nLk1/Z1cGgo6YRlqasIfomTeY1HpknEKzMAxOMKlkCHFiDy7wF1yt/RiyKl7iN+GMsAaAWZQ7PK6+YVwrzOauiEd4VzPgKuLeZUJofhHYUdqP3ET+OX8uD5vgqR62Oo6xFj5w4BA9LsGsnWoHtF2xnTNj54ciMTeI1LYcZXPbqu0m/bGLtk8xbjikTEntW+U85PIpMiRDoQOzmdPGFQK28Qmk4ISH5S729myDct2bcxRxdZspyLQuAHXSVTU
 RXGZb0Gn
 Sw14C9zC8uBmQRO2ufqUOSZh5AsUAgzFTEetJTgGkqBrUcFtDi39bzjYnjoYh4wSlkmt71GdvlKzTAH02BqlcfusW9JjIFQyPqiQgqD3aD6Q1igqmuqoyXfdbUGTK72OdvXrzr51VRrFeZ4CnRlroihNwJ0FdkMa+5yoeA8XyxMsKZUWtQvxB+JKdAZ1Sj4WQFVxeR3BuSB3OqlMXwJPsEN/jvQufMiaWR3XjnanVfrNLcqVScteg7XTYu1qAZedMOKAZY66fuGHwun9aXMuX/DweT0ZM5W7AJpCUuEZW+tXFssuYuZVGrnQ+N2J5C9GskeZ8SyDUFDCnAQiFyNCxJ3F8/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 5:29=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:

Thanks for the thoughts, Dave

> On 4/24/26 15:26, David Laight wrote:
> >> This true until, in a fleet of millions of machines, you encounter a
> >> one-in-a-billion chance of a stack overflow. You are then forced to
> >> double the statically allocated kernel stacks on every machine, paying=
 a
> >> memory tax even though 99.999..% of threads never exceed 4K. This
> >> overhead accumulates to petabytes of wasted capacity.
> > And then you hit a stack fault in some path where you can't sleep and
> > there isn't any available kernel memory.
> >
> > An alternative idea is to arrange for some system calls to sleep in
> > userspace, so when the thread is woken it re-executes the system call.
> > It then makes sense to assign the kernel stack to the process when
> > it enters the kernel.
>
> There are probably other ways to do this without handling exceptions.
>
> For instance, let's say you always *map* 16k of stack for each process.
> But, after context switching out, you take a look at 4x8b pte_t's that
> were mapping the kernel stack. If the _PAGE_ACCESSED bit is clear, you
> can just clear _PAGE_PRESENT and reclaim the page.
>
> If you don't want the overhead in the normal context switch path, you
> reclaim in a shrinker, at the cost of needing locking to coordinate with
> the scheduler.
>
> A simple rule would be: a thread that ever accesses a page gets to keep
> it forever. They're never reclaimed after being accessed, only before.

That's an interesting take; but it's a one-way latch, right? How do we
know that task won't dive deeper, later?

> For that, the worst case is that you go to schedule a new thread and
> can't allocate memory fill in the 4 pte_t's. You can't run it until you
> or some other CPU goes and does some reclaim.
>
> Needing memory in the middle of schedule() is generally a no-go. But its
> a lot better than not being able to continue _execution_ of a kernel
> thread at *ALL*, possibly in a non-preemptible context, like when you do
> it in a #PF.
>
> Basically, I think there's a way to do this that limits the kernel blast
> radius to _mostly_ being a core mm problem.
>
> What else has been considered before the #PF-based mechanism?

The only other way to know on-demand when to increase the stack size
is through stack probing, which I've ruled out without further
consideration due to performance.

Then there is a class of solutions to explicitly grow / run certain
code paths on larger stacks. Though instrumentation may help, others
have described it as playing whack-a-mole.

Then there are solutions that use a shared pool of kernel stacks,
blocking userspace until one becomes available. Very disruptive.

I personally haven't explored any of these in great depth.

To me, handling this on-demand in #PF, though technically challenging,
offered (1) the most memory savings, (2) the least disruption to
userspace, and (3) (ironically, expected to be) the most maintainable,
general solution with the least perf impact.

Happy to consider other ideas, and again, I appreciate your time and though=
ts.

Best,
Zach

