Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D68ECD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 05:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB116B0005; Sat, 20 Jun 2026 01:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C3A6B008A; Sat, 20 Jun 2026 01:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B486B008C; Sat, 20 Jun 2026 01:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7856B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 01:25:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8636A0668
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 05:25:52 +0000 (UTC)
X-FDA: 84899154144.10.DEA02DE
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id CDA5D180005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 05:25:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E7jM0yCy;
	spf=pass (imf06.hostedemail.com: domain of stevensd@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=stevensd@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781933150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxtWIxGNRrF9UndHpAngMe2xl+y0Kw1z8tCAncmG/5s=;
	b=szgDhdLzJYq6dOM2Rrbm8G8aVIQ2jfOxnWSmXzCNQB00VCVgQRx9WwAHdUTplY//SC/npc
	vmq0ydnMZCo4h7XNpCRM7lGqOOEcxi7fR8yKATr8biLrJqidytht8gCDnUwuPuOkt4nyET
	4K4G/cacY8YAru8r3rpJ4L94UdqY78g=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E7jM0yCy;
	spf=pass (imf06.hostedemail.com: domain of stevensd@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=stevensd@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781933150;
	b=zlmMjhzCguQqbmLirP/IjqEMUxfhczEkNO+V4VqELfd8OkNWTiR9rTPzwO6rEq3th9s9pi
	yn14DjrR6CBLshUPdGNmGSyjfOZI6U3HxU0cgQLXtByMpl4u+t25zVFLPK0rTjQVZYcDpQ
	/UySoMiz9CD9yn0w8PX78iZBvcCqh3s=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-695a3842230so15716a12.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:25:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781933149; cv=none;
        d=google.com; s=arc-20260327;
        b=ofzu5DhT3pP4uv+5ZQsSYpX9pYedxQwXLvKRPGE7d0mLjNYnayEtJTz8BMdq3Kghyc
         7AaD7vMAA/JoeEv/+SMVSx1MQxTAsmCRHJo6kgVJaphHzTwWupFAWoZ1aIcS+nTLsvC8
         +M4nJRyZNp5hdd66RTwD8Od3H03/FjyIVK93ejUIA6iWBXlU/zFY3N+FokSMJ35b9ZZ1
         HDAOd3sDoX37oh3j4kjXj4GiLaSbxkTT95++Fy6ghMmmVT4bn3RoLyQZdlQlPsLZsiVw
         5D4dd2X0x8QMivE10vXfQRGaMpKW3UFXpbwVH+ZO4MP1Evte6Jl793hr5Bf+6aKcHWg6
         7pqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qxtWIxGNRrF9UndHpAngMe2xl+y0Kw1z8tCAncmG/5s=;
        fh=knNLUZI/ISB9gn4XjnI/3QDutis28L1HeHmdLSOSqXk=;
        b=g0yaM1tG7I54U7jYpZQd1nzLRmimo/yR5Qr3qXaXKhqO86ixkPFWRO9i9SSm/xiaDT
         SNtONbLjBlD8PssF/8LMxBz6yng8irlq2jX4F+yJs/feS1lnnsIfJ3Dmz82QMQ3wwW4z
         vNShwe/k7Ub0/DqrNsDNBhpk07/9xWye1wDEk7p0ssCx7+QOuFV0tB/QLJYluoxpcqDp
         Bt1VNd1CxRD92TVp96sPgL+4Y6bZ3DYj1VOvP3sGiAWlHTE6yWjSsAWK6BtKK81rWDAK
         1qU9C4NC2x58DRfaQGJ1nKcGwveN6cP7KdrnOIAWWdjRYLKZMMQlB5Y7LdcrlbDFUGjw
         4/1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781933149; x=1782537949; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qxtWIxGNRrF9UndHpAngMe2xl+y0Kw1z8tCAncmG/5s=;
        b=E7jM0yCyFfVj+TjgZc8UE83P/AbOslvylcCITSBQ28Zpwsz5Z3pYKDJWSm9N4VHnug
         xcanVlPMRDeKOQFZ8szru5RBUHifsplMiz7/u6ZhIEbUT78jGCcd9sejlsxoBXNF4hWo
         vmHf0R8bEMgl6zGwm3EW1dbZvz/dd28U6i3T8EvgQ55Fhebo9cV7TT+qs6wmvnfVfTV1
         BUfvqy3Me/Y5iH6jvPv4QAECFLK10K68nj2hifBfXCD4hWgeDfv2dlC0+/Y6L8zHdLCm
         Jyn6PRT3YD/VrUHJ0YLvrlAKOtWLoRW5KTHv9T2cnLorygc4cOFPrKcAEb+45AEvqQUO
         GZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781933149; x=1782537949;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qxtWIxGNRrF9UndHpAngMe2xl+y0Kw1z8tCAncmG/5s=;
        b=OYoI6/y+37cSfdG6/BKsEC59Rcz8QV1huoEC7208LzWq4HIRTxfMwCYBcv9n87KYR5
         NFYuKHyDVoUNv4OWyixyQOe2msytDhFQ0xoI0KgCf+dB3AwFc2YpHNDP3QieKyKRnAwl
         AKMs8qW6I91wqmWGCr/rdeHKgf44pY/TQbVEDufCk68Gi2072EvMSBt7zHwSgYn0lKBl
         WQy63W7U97q93HC5CKNBmP2Ze98U54Y8lkDL34SwuoUrhXhK6JPJlbi6VoWmAtfNLeKa
         hxVVBK0908nWd0DslIWi/iRoFvhuwYamZmNAboCjBK/zYSYg4WhtrvjdCCvgLnuve3kK
         VrXw==
X-Forwarded-Encrypted: i=1; AFNElJ+K9qf9cGSWkg0Vd2LuGbvmcf5EfqMcYYu+cfqwHmc51Pr50vu8axpWLoPaeMUViwDhrQDYEebXNw==@kvack.org
X-Gm-Message-State: AOJu0Ywu5J/TdCrpSTeQMsAEwqt4fY5Gjp3lrNg0vpqDGEXkVB31B7LW
	js6I7/4ZvH6iUaOaDATgs9y3Eafk3Wi5Ie4uOQ/a1oGxHtBPq1UbhUHtbLa/ZO/xD/tRiAshCF2
	3i2kv3RR7brTgErX3fotSNnXmJ2zKdavEqh70SWAM
X-Gm-Gg: AfdE7cmUxnou8oIKXSV6H8EKA6uOslC/pWublcDOCrIACEI/gVleQ7TpxL3aDPs8qd8
	3nnN4cIRxn6ZKtTHoKZFY5o4RLX14Djsyz3zK45ZcrNxib0iXuSAdIaLjE/ixmsgomkz72SIeBn
	CaEE/tOw0vozsG5smyxWeiELE6mDvQ0bYZemqx5AsFnhmmogC0bwtvD7A0fWmZ7IIgWkl66IpOa
	cSidr/4uQOH7yyKzYkRZ5W6d2lkDH2tyACUjMQeaJs9rxXcGivLxK8+/k4bU8pArDi65x92CgpK
	+AwqBSbEdgnvy9i1EW8JxdpsOcw=
X-Received: by 2002:aa7:d4c7:0:b0:695:46d9:11d6 with SMTP id
 4fb4d7f45d1cf-697217024cfmr64894a12.6.1781933148700; Fri, 19 Jun 2026
 22:25:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <aevhw9xqz1pWA2Ow@plex> <20260424232637.054f15dd@pumpkin> <85f19b94-18c6-471d-88f5-c05a2f10199b@intel.com>
In-Reply-To: <85f19b94-18c6-471d-88f5-c05a2f10199b@intel.com>
From: David Stevens <stevensd@google.com>
Date: Fri, 19 Jun 2026 22:25:36 -0700
X-Gm-Features: AVVi8Cc8O3sgTO_px-jKk_eMUMKdRMah9dQplctrEbQoYn4hRfDQhOOq67WvDsk
Message-ID: <CAOiLmNE8okatb6RSonemyMT+BGVGg2h3=i_Epg5zppfp1Ks54g@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Dave Hansen <dave.hansen@intel.com>
Cc: David Laight <david.laight.linux@gmail.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CDA5D180005
X-Stat-Signature: dg91wa9r5ecmtwom7d6scrz13s3rmchd
X-HE-Tag: 1781933150-168164
X-HE-Meta: U2FsdGVkX18plXukqVzaUZTE6aFEa1wxmep3VjUOsFVSDNvlSreCoav21p13wAf4o732+GWgXG25PVsnRsKSqovTnWgTaDrq953t0mAGuSKXCTMeQIEuSgjiBeAJbArfdkPVh+S7ghhEAMj5Z+RiAqFvYcrAUYIJNHMKXBYfWVj7PhMyWvFnWFjqa/yfQC327cAex2QWU53l++OgXDBxf242Gitx5iU0duOGKlJcYzmuEolv9o9t7wSe78a9TE3vrIVclaR1Go9JmLEq6jKV+nJ2lqOexNPYaJRWk/j/sZoDuunUXBNTsTt7HZ/4jJuVKN/CWzKnkTJdKfb6TOa1MW5Gt/LIYQYzb5zK/4LZQ1sUGZyvx981159+orODA5Ia0v8MdevWDU8O4UD/pJhN2madVTxIHkDZ3fY0J20rHPJZyvAQPpRSXFpDCbnWYA1GpUo6pH5G8CLfPyq3aXSDTq6mK3m7LwKhye3tYuUaE3eF5sNuYCjbPDBdhCcBThfp7uUqDEMOl4ahjbvHV1EeSu9GtsA8M5LSu4MEI8lp9R+LdXJjYjvYtXLDd0K4+dk7aX1iAzSbeRRCOD/ew/PASn8StpvlBFkkK1LbtfY1CbI33WAJDRFE/aLaUuRcLD4f4SWKy+eOdWERAAwrq5gyNWo511+z5m5sqaqz0mR7WJeFf7u0E1f62I85QRyqNag6OzUE0dhG0w2x7vcl+6RHqB1G4wQKN7NhjRkaTUOAwwo5ROSTxJ4yTRxNwVA0cUVdJ1c2QjkCi3c8OQBfN9jt/3/XOExUCFBJtcrpNZJIogDDuv+KpaUDIcmqs4wEeIgTPUEh7DT2tbJq9CPFC6P1g5LXV+Mt9+FC/MhG8O7+iGcYKOPzSfWYC06gpQh+QAilZ0Y03vtrlukNIJzFGlcTD9MHuGZkGk3qtLk1IMPZ+YtQbbPfCJihodMO51JQLlYSt817PhCvdMTZyyyKbqL
 lKh1jlZj
 dv91/JlQahsEV3Dyh3Hh+1cfboWLsuaLH3wULFrwm2D0yNEsRDA/V9224A+YvJ+0AFX7Uw0YvwnjfYv/Bv1VPtTMGl1esmBgnpsCCb+IXSDJZtmTwkFXGLnjR5sr+VMtF/ruSyjOjYE2nIUnO/SLfQhI1N0XMz2Kgc0ppyQFOT9DmKMBnJEi6+slAcnxCTtJYnol/HtfiJ3USd13YQzN8z1YERJZvhyqEh2ihlp7VbevZJK7yQZzixIPNMXKPEvdBEEutWLY0kKIScDnbCnSIHF9b4/a+YcY1ru7aJVJOe3jfoB1kkp4gpN2SGFG/K4uI4OeOqif7YTQB2JZAthpOXymOZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 5:29=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
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

My understanding is that speculative execution can fill the TLB, but
won't set access bits. Speculative execution of a function call could
definitely put an apparently unused stack page into the TLB. In
theory, I don't see anything preventing one CPU from speculatively
accessing memory from another CPU's current stack. You definitely
wouldn't want to do TLB shootdowns in the context switch path, so this
would require a shrinker. I guess if you're batching shootdowns in a
shrinker, it's probably not more expensive than swap on a
per-page-freed basis.

> A simple rule would be: a thread that ever accesses a page gets to keep
> it forever. They're never reclaimed after being accessed, only before.
>
> For that, the worst case is that you go to schedule a new thread and
> can't allocate memory fill in the 4 pte_t's. You can't run it until you
> or some other CPU goes and does some reclaim.
>
> Needing memory in the middle of schedule() is generally a no-go. But its
> a lot better than not being able to continue _execution_ of a kernel
> thread at *ALL*, possibly in a non-preemptible context, like when you do
> it in a #PF.

I don't think this is different from the current proposal from a
memory allocation standpoint. Both proposals effectively maintain a
pool of preallocated pages used to fill the current thread's stack.
They vary substantially in when the pages are put into the page
tables, but both need to allocate during schedule().

-David

> Basically, I think there's a way to do this that limits the kernel blast
> radius to _mostly_ being a core mm problem.
>
> What else has been considered before the #PF-based mechanism?

