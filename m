Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6725C53209
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 05:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298D86B0088; Fri, 20 Feb 2026 00:17:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2462C6B0089; Fri, 20 Feb 2026 00:17:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FDFD6B008A; Fri, 20 Feb 2026 00:17:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF8F46B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:17:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C12A13BFC5
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:17:46 +0000 (UTC)
X-FDA: 84463677732.04.6982CCF
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id A719E20005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:17:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3ZRLlXbv;
	spf=pass (imf13.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771564664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rI1NbYa8e4vBJeF0qLPEWLyiL/LU82orZ37dDXTTjz0=;
	b=U/ShdmhiejR6dHZ4WPQNcEvROem8s+/F/tsUNAYUcgpK9VAFICkXQL6Wt7Uz6W9JVZTeiv
	Guxtw8Jq/5xOipi2KH4f47xo2LJcdQ6epI43vZNPjVTRDpAY52rotQX8z3jxLnAga2ZuZa
	eCbII11guvO2oTDYYZv8G5eBPyNhLrU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3ZRLlXbv;
	spf=pass (imf13.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771564664; a=rsa-sha256;
	cv=pass;
	b=g4E54b+e2so6hFVCIsOoPeQDyfRj9Oi7u/ZwXOG3ygILwnIx3U5Df+87YfP9n0721EsMmI
	rnM7rEYEUDIw9sDW0edsJr4jC66o1N3cHiNzlqgwe8Ecmu3E2vSOfmhmK7V6PQDuM+5iQQ
	3AjoKNncd2VSTn0+w72feNrpCJtB9Oc=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a885af8ee7so32475ad.1
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 21:17:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771564663; cv=none;
        d=google.com; s=arc-20240605;
        b=Ow/GtF9KvZCS5H16x2ASrgn4kD7NzS8nlVAZx5PoYSAvl+Ul9ciC/aoRWWqV5mODn/
         BEN52qlDzLgTM03CRNwloNBKdWF+74ZCHQq6us1zkHPRMminX9MTCwQ/rLRMjXocFqQ0
         C3CEX/L6+7I24tACgPyjxpT8WCOJj6YF5p1GDwdpo2Axfzw82qz2iP8GGCsfQVcDTgoX
         j4knOlPgW0a01TKuBpnwQit7Pf74HeRF/dZ6hdbpwkCOOoen6clI9WJZ+Su2B4UFCZO5
         MiypNrIEB7gw6X7HGuWay7zfSIrX8w6vc+pDlyQ7rIkRwyWG73FSCwwfRkId7Ih+k/w7
         ViHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rI1NbYa8e4vBJeF0qLPEWLyiL/LU82orZ37dDXTTjz0=;
        fh=Ahx6CiiZJs5WS834n3KOtFF9IY/5AqmG8L8lNr3S/Zg=;
        b=UaZOfvwdnXlVRuNYeKTgX7SXESZB0sMUVCofmwnpqCGIJgGNpI6TSRLLB8Zu4HXsKf
         gmpY6QpE7LSQJCqoy8LZagFRNAgQnS+Gy23kOR7AP+6AnMk00fY1+Ao4zM7wsFh5/jLW
         OSh7eY3kuuxdEq9tPez1GoEw16eTHjbDWKKkMPRk8bs8n6iVShOiQ/jdeixAOy1q6cgM
         7JAKA72Z/AstKwnwGR+KL5Icw3VLsFwv8q0z5pT+YST9byDHKEfCbqtZZjhwe20ukgXj
         ILDjXSIo7vBeIUeQDntVh8PiRNrC4Rt3YfNlpcenlVJe16dC3jy0817WSrXOJVAFNGGe
         2vUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771564663; x=1772169463; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rI1NbYa8e4vBJeF0qLPEWLyiL/LU82orZ37dDXTTjz0=;
        b=3ZRLlXbvW5w+VzFp0h9TlD0Hh+TqvVAbe2ugY+iKFn6NLfCkbvV+HjV5EfCQvae8O7
         gULjf45A0HKneyROlU5+S9bwIHK/lWZ04ozTmvXT+TyUJpl3drBgOF1uFYmJfnmqSvUr
         MjPKdQ0zpEAvcKck28+QU6p39htsVVUCvxhUmlEHmzr8tOJttTvMEODWxYG2p1zRpO9F
         rMw/SDSCdvUyBG+2zkilYk32v0NNA/RdJ9zsSUpQkayV+OUocbr+wUnszFLsixWYOluk
         buLiUHZ3DjImrgItpwLM90zCqNXDbjEroA+Rkl+4J1ZgEkJqdtY3JZ4cJoyLR0cfwWcg
         9Vbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771564663; x=1772169463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rI1NbYa8e4vBJeF0qLPEWLyiL/LU82orZ37dDXTTjz0=;
        b=HefFP5tZch6Cju2PGbSp4uTqg2X7hJ7jJku7OVAe7kaXf86gCswzcsSRMRdEEuhRl+
         Y6SuCZXKuk6Ub73vbJL/ftAlgVFTb2JceoxEf9SCT5Tv3E0nTvI4fallQToQVCsD+kNY
         PeAUq/bzL4knWHHU53rLb0qG2Sszlo/8yzTVIJYupxssXZXaCPpVP1jVNxinHNZra1pB
         b9gEPnFvVwPrDb2WFyWbfdexzu08mjQW8G8W8BKXVGyz62fPrmkTF2rLQbrqowX6P0B0
         L/w4nkCF3cLtSCo6XqM32/Et6nZPEFaY9dtbdC3qNclGPz448oRH7hScoZxVA1SDiuyT
         GbUA==
X-Forwarded-Encrypted: i=1; AJvYcCU09tB8Az1We9ZKbl19gGJE5Sla6BzShIkD/zwAZX1+REPAAPFRW8pA0yEP3hA7fWf1Vx6Gwm5Z8Q==@kvack.org
X-Gm-Message-State: AOJu0Yw3ZoCujhXsPzW7alzAkNYhnV6v2Wu0WgIOgX/t3AKdLvx/Ht8C
	e8MnUYTho5WI8GK4B2Khyfycf4VmHbX+XVxGfITB7Ees7TzSlm6R9X7Cniks/1z6SFMO7VWiheY
	Z/qHmwWRoUlVK6mn4r8Z/AyFuLfNKZOPHN8NvoAbH
X-Gm-Gg: AZuq6aKgUi6d4np2GPYqs8tG+Tty2Rt37KNe90CjnhOMjB/9zcWt/gsSk+cqT6SfHqG
	iz5o0JqkPigiTP7hCwlYX/ua0cr/2ik2LFaBI6kW1xu2p+Zgm5z0c81XPerOHA1miYVpvOIL1K0
	nPw+zUTdfRx11ODNBi/VV0WUfZ05i3M2eiUXknweIEv45YpgEVDX4aHu+4+z5XpK9RaXxXgaEPk
	ALu/pJ6/CpnkQniA+UtN9kcfMcQ/wtjOLX+TFvd454WNcBCqnNJS7Fk4rLilYZZ3CNNjMnz8XBt
	ILa4OVJjfp0IWGERFJySoAwEy2pXYwrQ8xUBqdWw
X-Received: by 2002:a17:902:d584:b0:294:d42c:ca0f with SMTP id
 d9443c01a7336-2ad69e114ddmr1414495ad.2.1771564662949; Thu, 19 Feb 2026
 21:17:42 -0800 (PST)
MIME-Version: 1.0
References: <20260219233708.1971199-1-kaleshsingh@google.com> <20260220011700.127763-1-sj@kernel.org>
In-Reply-To: <20260220011700.127763-1-sj@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 19 Feb 2026 21:17:31 -0800
X-Gm-Features: AaiRm52THFMQu8DD4__rg--y4qYBq0Xcvfy_Nb5EOcRcZKNj46I4M1T8ZW27eX0
Message-ID: <CAC_TJvcdwaUspCXze4grzWeX8Kt_CQd0KmXwKG20Ex52n0hoaQ@mail.gmail.com>
Subject: Re: [PATCH] mm/tracing: rss_stat: Ensure curr is false from kthread context
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, rostedt@goodmis.org, joel@joelfernandes.org, 
	kernel-team@android.com, android-mm@google.com, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Minchan Kim <minchan@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Martin Liu <liumartin@google.com>, 
	David Rientjes <rientjes@google.com>, Zi Yan <ziy@nvidia.com>, 
	Wander Lairson Costa <wander@redhat.com>, Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: A719E20005
X-Stat-Signature: a4jy567nc8j7as1r3zhktmgwj99kzkaq
X-HE-Tag: 1771564664-499145
X-HE-Meta: U2FsdGVkX1/3bk/p56lkefHqPwHy2wJ2iZ4Q1xWCy9jbVjZQu/8u8oDMj+/q7VcUGS4/yGe2lrS1Rlr39QE+GnTYr8dkccciG4DDTQtEPJdCjkyRRr0QcTedqU21ubcs9q3TfaK+JyXvt9nykZT4snLn212dvdBZceUG8XQ7c+N2BY5eeQVAnhoeIh9k7sdgGxORfIs/wtA9VwFa9hOcsSeu1wYQCb4feCNsHde45ekEgHYSlwEH20cViLurDsjx6yLWyg0pWU+1Tnj/ad534IgusdRwg9mlbSOdQLjE9H1qJRZ/HEbNjI+/pt3OIzlnMzlJIYG7ajMlu+jtSkXimgzrLrrBbMEVvCgI/zBziewybsIHHQuMOA8R1MHOeySmBiCa0EwJS2nZuFauIAcQcHG1EMVhukPUOxyctzWfhIvVCMVMY/Tu3wgftq/NP9pLISBacgyyttryhOj0OX5pXZHhtw1HniCf6CqYbGOjYD+czZhkLvX0+NODYEj8brwdMRFCAgI9leo5uQu3kQ+5aXPIrBdhIZpfr5NhHQij+LNzXPAxpKE1HMjbfxi5IDnFIvtbHxCfWCvGupMPDbsDlcOl6ahrLo+P59de46B0spzMlSI33J6m6ml/SHT5alOpzmweIelEScrSGmtOGne4RuhW2e7Twt0Rd5+5hvsbAxI2taPnXvnCmvYmMg2PWr3RskEPHf+20+1Xi1iQJPfk9HefjUkTTfpX2GU809q8bLBSQYeWwxxpNaCDmOnxhVbqT3ZoVpH4yXoOvwfa62uKU55O84GOgWLbhc9qHk83Iz0SiNq6ZURNXWbuVjHJ/ds+f4T3Y/uFuxu9bEs6H1dJvkHEUnXBSfKgQ66G3u3jrCih7pjKgV7TCMtIhwfzb2UqzG0q1SOVuyr1AgujZ1RQ2rNX3+A+vT5vP8yugOtSFweewovVFO1X4sdp9AiztnKv/Z9y3gIoA4YDrsvrzv1
 p3khhYED
 O1UhhMTaXdcaV1i4I+BnJZtolb5cXqnhvxmNqflNKvlnlq+AhDgL6qptEyPVzS/4HGTpskjkSHKZ27R28t8iGcEMytp0tnIFEBfxIhGNJo1ovYTX+Po4obx6DCYaJbf/9LieCP/m3JJ60I988ZnTQXqN2XWF3ShAo8STNp3R+1rC0797oF4d/u5tsucT0Nx7xD6s1dy2e11vKcneVy3DdvdBdWFQRjJyUeAI9B4Q1EXnxJ+qaJEm9KPy7ARq+brsUXaIDAaJePRghbpVFXDWxmccFX6i8MIGwiAxeuLzMw8/EAmt3vVu9TgJ1YlJWnX+92zYiSlYXePF84SMA27Th70/AtwUPuTWUeaawB/jyRnw95o0iRpByp1Y39PaU/6TOF5Z1Bx9rlQELUIMeMhnzw8MbPF/4GUy5WVXSwN0Anblme/AUH9TGIeXzzb9KaC+0sFZQSFwOuuWCRUfcYlbqmbeV5iNbh/gYDRfFr0kem3fSK4hGA9Xo0BvY+1YsgIZ7nnh+THOkrn7xeSu/UxmPf8d7wIqrJMztNfQpLiKtPgU7QptXP6IrdElDN8PMjLFcYAK6n7IEKlOxnN0IPACnqbjJkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 5:17=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Thu, 19 Feb 2026 15:36:56 -0800 Kalesh Singh <kaleshsingh@google.com> =
wrote:
>
> > The rss_stat trace event allows userspace tools, like Perfetto [1],
> > to inspect per-process RSS metric changes over time.
> >
> > The curr field was introduced to rss_stat in commit e4dcad204d3a
> > ("rss_stat: add support to detect RSS updates of external mm").
> > It's intent is to  indicate whether the RSS update is for the
> > mm_struct of the current execution context; and is set to false
> > when operating on a remote mm_struct (e.g., via kswapd or a
> > direct reclaimer).
> >
> > However, an issue arises when a kernel thread temporarily adopts
> > a user process's mm_struct. Kernel threads do not have their own
> > mm_struct and normally have current->mm set to NULL. To operate
> > on user memory, they can "borrow" a memory context using
> > kthread_use_mm(), which sets current->mm to the user process's mm.
> >
> > This can be observed, for example, in the USB Function Filesystem
> > (FFS) driver. The ffs_user_copy_worker() handles AIO completions
> > and uses kthread_use_mm() to copy data to a user-space buffer.
> > If a page fault occurs during this copy, the fault handler executes
> > in the kthread's context.
> >
> > At this point, current is the kthread, but current->mm points to the
> > user process's mm. Since the rss_stat event (from the page fault)
> > is for that same mm, the condition current->mm =3D=3D mm becomes true,
> > causing curr to be incorrectly set to true when the trace event is
> > emitted.
> >
> > This is misleading because it suggests the mm belongs to the kthread,
> > confusing userspace tools that track per-process RSS changes and
> > corrupting their mm_id-to-process association.
> >
> > Fix this by ensuring curr is always false when the trace event is
> > emitted from a kthread context by checking for the PF_KTHREAD flag.
> >
> > [1] https://perfetto.dev/
> >
> > Fixes: e4dcad204d3a ("rss_stat: add support to detect RSS updates of ex=
ternal mm")
>
> Sounds like the issue is not that critical, but user-visible?  Would it b=
e
> better to Cc stable@ ?

Thanks for the reviews, SJ and Zi.

I didn't add stable initially because it isn't functionally critical.
However, it would be nice to get it backported, as without it,
observability is much more difficult.

I believe the patch should apply cleanly to stable with minimal risk.
Andrew, if it isn't too much trouble, would you mind folding the
following tag into the staged patch?

Cc: stable@vger.kernel.org # 5.10+

Thanks,
Kalesh

>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "David Hildenbrand (Arm)" <david@kernel.org>
> > Cc: Joel Fernandes <joel@joelfernandes.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
>
> Acked-by: SeongJae Park <sj@kernel.org>
>
>
> Thanks,
> SJ
>
> [...]

