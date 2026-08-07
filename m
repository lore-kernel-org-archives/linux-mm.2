Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C10C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C9B6B007B; Fri,  7 Aug 2026 03:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD286B0088; Fri,  7 Aug 2026 03:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC696B008A; Fri,  7 Aug 2026 03:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF75B6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:50:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59D0C12022A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:50:11 +0000 (UTC)
X-FDA: 85073700222.04.D6AAE48
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf09.hostedemail.com (Postfix) with ESMTP id 70F2C140008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:50:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GW3kAuXR;
	spf=pass (imf09.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786089009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gy9L9/LoV9ZFrTZKgyHXZWp3XQGkD3Y92WNpBSmA0ec=;
	b=fu4yVKMyzfMfLvdPQKP7hBi+m0uwW/IVxn/sfMk1FG1IjZzhowruXORRIRZrcp+Z0T6rgx
	7RU6un5c+8umnjqpTJ4FK+cFam0xwR0VdeHN4WhusNnVJdZO4mjmsbDrjIMBw5Ini8i4N5
	3nysC58oRGC8HXXgxffOGxJOfSRXGcc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786089009;
	b=BKqvu1Bajmcz2/EmJ/LyNt/zu0ciQDXdvPtt5Z0xog+VRqkFV5gLL9aC982qmNCdCt4+sp
	ATeGdSGJyyefhMm6XEERLMXVMpGfytsg4RsY7v0T9RXHzvKKK5MiGcEiNnPJn/SJJ6GHRI
	fyrj0NqRg7TeyzHfKuDcOmCUf4bSnrw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GW3kAuXR;
	spf=pass (imf09.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3810f0aba07so1550139a91.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 00:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786089008; x=1786693808; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gy9L9/LoV9ZFrTZKgyHXZWp3XQGkD3Y92WNpBSmA0ec=;
        b=GW3kAuXRYdgNcMHMtj1ABTovzntK94yJeczSES3ouQr9lAU0Ok7QsHiLe3V+Jhn7Vb
         m25h4t4oaT0xcGM+7+InyBSlQuKd0IOOu1iNwmog8bu20jAGU1cZLKxH7YVStC0PBa4g
         0B7jO6evz0F2NiSRLnRheIKFloVWqGcyOx9oEfS8Ao7wEvgfOv+25joH3qMJVhHLlPgq
         QximZ6CstBew5Vf+062W/W9azBml3+VA3UBv0OVkAlE7wQ7dzq10BdFXPgiRWlYm6TrT
         D7HmYXQ8/590awE2ebk3swpJq9zo1kmrfvcb2PfSFC4bZXokdJJ9a8YRGD2aB/1YU7wn
         l6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786089008; x=1786693808;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gy9L9/LoV9ZFrTZKgyHXZWp3XQGkD3Y92WNpBSmA0ec=;
        b=VoWKRMRSURNb/mFaRr9Cu4XolDtwekQBUkjvSbOYkXMGIn8cB/hq6w2Ls0fPNvhuHO
         7GZaBkFBmMe5YDMzZa99W7ktZDt9KdNvPXHoGei+AB75Iib45iylsDchfMJwb7Hbk/Hq
         VTOoN3UZO0CS4VICmuhvqozmuho4x6ZAjn7FubxvIykdXUVkx23yuBv2+e7nNQBosv0i
         hBM4spuO81sIRicpHv1/24f+DN1FaCFyiteqzE/CHflWZ7CK/nk8IcePWS6uNiAhoHC/
         PNY/hGBvz39vWEXXFUbSXF/oIdicQXGCV0dPVEqNe3bitNQjPCIHrT0T++HiRDSZr7Sf
         G4Kw==
X-Forwarded-Encrypted: i=1; AHgh+Rp0Li6lA5ixXfWf5ntAz+fuR8ypAq7OUHhYbXfZqBL3Ha4SrnnhWVBxkHoDOuuhuzqhzSXGGz/82Q==@kvack.org
X-Gm-Message-State: AOJu0YzYl67zsiPp4+qQ42im2ihYR7t7SwOmuKu60nH54d+DSmwc60c8
	QzWDtQ7TIU+ff8lnpBtmnMCUfGVTFlp6RtEwBHn/j1iNry/u5ak3WLwR
X-Gm-Gg: AR+sD12cAEDmrhn+f4BW6DsCt84lLEY7R9wlq44NfHUUddb9+GsvqIHxpwXy9UUe4uW
	YQEkBWdd1JYhGVk+Jbv+uVgic7kSHUsXeWMPy9yV8aXSFC3/5P3M9dE1cbK+zE4W8KJRk9eQxTG
	RYFWQeTsg/X5euhBXHFOIF0DaxJDzQ+2Vv/AGV58oIqyTR7+zNkTqmbbEFBqXZFWfkVtZ8OQomk
	HtlXiTy8iuz5Xi6g2rkdVriN5GW5/UyLB8wHSjCTeK3f59qSCy5Hicoiw65hSLPn0FqLGpfL942
	K1kJJBazRTa2Y55Hs4WT1kIcN6Kmfnvbxf+1ny2aEeXLMYG0prGqed9jXF9x7WXnroXrwed75v2
	F3eLjcIytbyg3WQjCB5uXAYx2hTibagTcc7YeGq0AidJL40318msn6w2K+fS8kr9VQLxUHcpL9X
	rhuxCLuewRjHZv5y03A2kPJW4c6znohMlRy6j1WMr9otv2CPG+xn4CldlcBTKDcbgE5/LmLlrKA
	0QZq+wwmEPyzOvHpItCXuQPrA==
X-Received: by 2002:a17:90b:1843:b0:37f:bfa2:1887 with SMTP id 98e67ed59e1d1-3903c53639amr22774995a91.8.1786089008044;
        Fri, 07 Aug 2026 00:50:08 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:3629:bdc:8549:6d81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925fa4fc7fsm1453369a91.0.2026.08.07.00.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 00:50:07 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: baohua@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	willy@infradead.org,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v4 1/3] mm: allow page faults to request VMA-lock retry
Date: Fri,  7 Aug 2026 15:49:47 +0800
Message-ID: <20260807074948.28953-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAGsJ_4zi=MWULn80yDXmifaoBeQ__xwMVcObmYUj_YGG0_D6Yw@mail.gmail.com>
References: <CAGsJ_4zi=MWULn80yDXmifaoBeQ__xwMVcObmYUj_YGG0_D6Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: z3a1mwxbtrqnqoqh6hk1txhk6mem8zth
X-Rspamd-Queue-Id: 70F2C140008
X-HE-Tag: 1786089009-655633
X-HE-Meta: U2FsdGVkX19gPLf+2IZZLobEbUo36pkR3J+xZNo25wBQUZrNy8vNMVhjB8osX8lOknMQVrTANcGX2wnnuJIuLZr6ADoe14HuiU/nl7pyQ1GxOruz5FqseLN2rf3ZQnfmeNmXUQKOJJvLx0a5EoYnAbQz0alHx1U1DrU8gPiTWaOy7hN0At0T98cfmMoTNG6M/VEvnGknKoivWeY+BKQU48yhvSKTxThSden3JdIwgaw1i13cqXLJjwrs4nkkx+uarqHdQOjfuUmizszPiiTGYuBQJoTB7PjtxSe+8HosDgHe0NKl4O4EHfFxvBNLnCB0HFKXgMk3vb7/zrqWuQ7yxjFAwfEwaZ0mT4e0N7ks4CfJ0I2iRr7WuFol3mKZiTtsvBvG8/6RuEeD55WbrSClwAnUOFXk/HVyL6/IQo6R54Gu1cGr9mb57e/r9P/pxJZ8El3tbaDil4hfTMp3pL0DnwOXP8XLb4fKoSyYyA7R52HXBSZUKAunfRuk1cVscgBbMfWOUwM1qVHOP198Biq4c4t1lZMBk9W30HzCQ3sNXe58cbrRmaroyPttgO6W0Oq5Nz1KkJXT3nQQn93BC7Zxz1ur8vHBK9A2o0MAXWlt0yMZjLiTvDwSrW1P0Fn/m8purWfmjtL0e2FPO2EGx5+4PkVQdfbtH8WVIqOi8R3QTGOP7o/qf4Z8U7XHAXs2rejE8vrGBDaw7A4wzoLd/46OS3GgbLS2zbgXPY40QMQUpjEf6p7RTfWQ0PvAvsEtChqLKKhyb6hKMWI1JZCIr+d7G9GSSM/VGnVZ2I5p2KvOfHYG9ImSRuDsqxojbVZ7bD945PisDXipI71p2BW2PkzsTCPFZMdAAFLgR/hXtbr/waSGxQU+CJwWQ3sP0vlTI5vh46QNF3n0uBev207eJ6iWfxPdX9brvBkvXJN2NF6V6cwuerOcoUp8zwCCDvuLYBWIthB0Hd5Q+ZHSJ00gKWq
 GogKxnDB
 Ci8PCJRpaKoCzzWyLc81uCo1QJXEL6lFY8m4wtBuHer+GQcFC9JC2rfbeBjPktEAVAvG8i2AvfhzjecS2Nt8jyLOH4or+KgAb20NL6b3wRhyhVYd8MzmWGj4xDc5UNnjqoa1C/0LqEBtKy1zCVfu9zxmXmBVKZyyQeDjcHUMjKT0sr3UoXacb5FKgCWwJSBbwUx1z5tP22s1gdSQeohQg21R9kIlKMzed1L1zOa1WFI2Mvff1/rhr9uTYOLHRqD3/1F8Xq79K+saxiwSl46gDMhIKVUvrYfslbBUa3xrv+pAcyr+dY+tUXdpWW+fdJOWSJZOTmRxZkxzGLdEMIblV87AsvXRQX3s2ScGJufNbfRMa2wlIzy6KA4Y7wNCQVkajFjZlN2ANkvFPkGU6bT+6Bzuu0uVzRJpXnooXonDEJoLDon0OJS2uXrkLoO27asZyVcUpnDLOdboCIckkoVkyV8zS9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Thu, Aug 6, 2026 at 3:30 PM Hongru Zhang <zhanghongru06@gmail.com> wrote:
> >
> > > On Tue, Aug 4, 2026 at 8:32 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > >
> > > > On Tue, Aug 04, 2026 at 05:52:19PM +0800, Hongru Zhang wrote:
> > > > > From: Hongru Zhang <zhanghongru@xiaomi.com>
> > > > >
> > > > > Page faults handled under the per-VMA lock currently fall back to the
> > > > > mmap_lock path whenever handle_mm_fault() returns VM_FAULT_RETRY. This
> > > > > means that lower-level fault handlers have no way to tell the
> > > > > architecture fault handler that the retry can safely continue under the
> > > > > per-VMA lock.
> > > > >
> > > > > Add VM_FAULT_MAY_USE_VMA_LOCK as an advisory bit that can be returned
> > > >
> > > > I don't love that name or that faulting retry behaviour is _modified_ by a
> > > > value that indicates fault resolution state... ugh.
> > > >
> > > > It's kinda confusing things 'VM_FAULT_RETRY' is 'you have to retry this
> > > > fault'.
> > > >
> > > > 'VM_FAULT_MAY_...' is starting to bring in effectively configuration
> > > > options into it and that's kinda horrible.
> > > >
> > > > I mean is there any reason we shouldn't ALWAYS do this if a VMA lock was
> > > > used?
> > > >
> > > > It's not too expensive to do a single retry with the VMA lock before
> > > > falling back to the mmap lock.
> > > >
> > > > So maybe simplify like that?
> > > >
> > > > And like that this series becomes a single patch right?
> > >
> > > This is a brilliant idea. That's a genius insight, Lorenzo.
> > >
> > > I guess the conceptual model could simply be:
> > >
> > > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > > index 45b99c3b1442..3592bcc9bbd7 100644
> > > --- a/arch/x86/mm/fault.c
> > > +++ b/arch/x86/mm/fault.c
> > > @@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> > >       struct mm_struct *mm;
> > >       vm_fault_t fault;
> > >       unsigned int flags = FAULT_FLAG_DEFAULT;
> > > +     bool vma_lock_retried = false;
> > >
> > >       tsk = current;
> > >       mm = tsk->mm;
> > > @@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> > >       if (!(flags & FAULT_FLAG_USER))
> > >               goto lock_mmap;
> > >
> > > +vma_lock:
> > >       vma = lock_vma_under_rcu(mm, address);
> > >       if (!vma)
> > >               goto lock_mmap;
> > > @@ -1352,6 +1354,11 @@ void do_user_addr_fault(struct pt_regs *regs,
> > >       if (fault & VM_FAULT_MAJOR)
> > >               flags |= FAULT_FLAG_TRIED;
> > >
> > > +     if (!vma_lock_retried) {
> > > +             vma_lock_retried = true;
> > > +             goto vma_lock;
> > > +     }
> > > +
> > >       /* Quick path to respond to signals */
> > >       if (fault_signal_pending(fault, regs)) {
> > >               if (!user_mode(regs))
> > >
> > > Nothing else needs to change then. I wonder if there is a cleaner
> > > way to implement the idea, but it is really stunning.
> > >
> > > Best Regards
> > > Barry
> >
> > Filemap Throughput (higher is better):
> > +---------+------------+---------------------+---------------------+---------------------+
> > | Threads |  Vanilla   |       RFC v4        |          P1         |          P2         |
> > +---------+------------+---------------------+---------------------+---------------------+
> > |   40    | 1069.34 /s | 1404.47 /s (+31.3%) | 1400.13 /s (+30.9%) | 1412.38 /s (+32.1%) |
> > +---------+------------+---------------------+---------------------+---------------------+
> > |   60    | 1038.12 /s | 1682.88 /s (+62.1%) | 1683.37 /s (+62.2%) | 1685.23 /s (+62.3%) |
> > +---------+------------+---------------------+---------------------+---------------------+
> > |   80    | 1042.62 /s | 1766.72 /s (+69.5%) | 1767.83 /s (+69.6%) | 1771.73 /s (+69.9%) |
> > +---------+------------+---------------------+---------------------+---------------------+
> >
> > Swap Throughput (higher is better):
> > +--------------+-------------+----------------------+----------------------+----------------------+
> > | mmap writers |   Vanilla   |        RFC v4        |          P1          |          P2          |
> > +--------------+-------------+----------------------+----------------------+----------------------+
> > |      0       | 17303.09 /s | 18394.51 /s  (+6.3%) | 17899.48 /s  (+3.4%) | 18337.30 /s  (+6.0%) |
> > +--------------+-------------+----------------------+----------------------+----------------------+
> > |      2       | 16728.04 /s | 18591.68 /s (+11.1%) | 18346.72 /s  (+9.7%) | 18848.17 /s (+12.7%) |
> > +--------------+-------------+----------------------+----------------------+----------------------+
> > |      4       | 12596.23 /s | 18534.00 /s (+47.1%) | 16095.20 /s (+27.8%) | 18507.62 /s (+46.9%) |
> > +--------------+-------------+----------------------+----------------------+----------------------+
> >
> > The key difference between P1 and P2 is how FAULT_FLAG_TRIED is handled: P1
> > keeps the existing major-fault-only setting before the retry, while P2 sets it
> > before the VMA-lock retry for all retrying faults.
> >
> > In filemap throughput test, each reader thread operates on its own file.
> > In swap throughput test, all reader threads fault the same memory area.
> >
> >
> > P1:
> >
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 45b99c3b1442..c3ab30d32a15 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> >         struct mm_struct *mm;
> >         vm_fault_t fault;
> >         unsigned int flags = FAULT_FLAG_DEFAULT;
> > +       bool vma_lock_retried = false;
> >
> >         tsk = current;
> >         mm = tsk->mm;
> > @@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> >         if (!(flags & FAULT_FLAG_USER))
> >                 goto lock_mmap;
> >
> > +lock_vma:
> >         vma = lock_vma_under_rcu(mm, address);
> >         if (!vma)
> >                 goto lock_mmap;
> > @@ -1360,6 +1362,12 @@ void do_user_addr_fault(struct pt_regs *regs,
> >                                                  ARCH_DEFAULT_PKEY);
> >                 return;
> >         }
> > +
> > +       if (!vma_lock_retried) {
> > +               vma_lock_retried = true;
> > +               goto lock_vma;
> > +       }
> > +
> >  lock_mmap:
> >
> >
> > P2:
> >
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 45b99c3b1442..9507b8a0fe18 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> >         struct mm_struct *mm;
> >         vm_fault_t fault;
> >         unsigned int flags = FAULT_FLAG_DEFAULT;
> > +       bool vma_lock_retried = false;
> >
> >         tsk = current;
> >         mm = tsk->mm;
> > @@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> >         if (!(flags & FAULT_FLAG_USER))
> >                 goto lock_mmap;
> >
> > +lock_vma:
> >         vma = lock_vma_under_rcu(mm, address);
> >         if (!vma)
> >                 goto lock_mmap;
> > @@ -1349,8 +1351,6 @@ void do_user_addr_fault(struct pt_regs *regs,
> >                 goto done;
> >         }
> >         count_vm_vma_lock_event(VMA_LOCK_RETRY);
> > -       if (fault & VM_FAULT_MAJOR)
> > -               flags |= FAULT_FLAG_TRIED;
> >
> >         /* Quick path to respond to signals */
> >         if (fault_signal_pending(fault, regs)) {
> > @@ -1360,6 +1360,13 @@ void do_user_addr_fault(struct pt_regs *regs,
> >                                                  ARCH_DEFAULT_PKEY);
> >                 return;
> >         }
> > +
> > +       if (!vma_lock_retried) {
> > +               flags |= FAULT_FLAG_TRIED;
> > +               vma_lock_retried = true;
> > +               goto lock_vma;
> > +       }
> > +
> >  lock_mmap:
>
> Thanks!
>
> As Lorenzo pointed out, this would break major fault accounting, so I
> think it is better suited as P1.
>
> The performance difference you are seeing is probably because another
> thread is concurrently swapping in the same address, taking the
> folio_lock and installing the PTE. That is a separate issue and could
> be addressed by a separate patch, likely an updated version of this:
>
> mm: Don't retry page fault if folio is uptodate during swap-in
>
> https://lore.kernel.org/all/20260430040427.4672-5-baohua@kernel.org/

Swap Throughput (higher is better):
+--------------+-------------+----------------------+----------------------+
| mmap writers |   Vanilla   |          P1          |          P3          |
+--------------+-------------+----------------------+----------------------+
|      0       | 17303.09 /s | 17899.48 /s  (+3.4%) | 18190.62 /s  (+5.1%) |
+--------------+-------------+----------------------+----------------------+
|      2       | 16728.04 /s | 18346.72 /s  (+9.7%) | 18162.03 /s  (+8.6%) |
+--------------+-------------+----------------------+----------------------+
|      4       | 12596.23 /s | 16095.20 /s (+27.8%) | 17991.45 /s (+42.8%) |
+--------------+-------------+----------------------+----------------------+

P3:

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..c3ab30d32a15 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct mm_struct *mm;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
+	bool vma_lock_retried = false;
 
 	tsk = current;
 	mm = tsk->mm;
@@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -1360,6 +1362,12 @@ void do_user_addr_fault(struct pt_regs *regs,
 						 ARCH_DEFAULT_PKEY);
 		return;
 	}
+
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:
 
 retry:
diff --git a/mm/memory.c b/mm/memory.c
index 428eb555ecb7..8c34a857548b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4987,6 +4987,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	}
 
 	swapcache = folio;
+	/*
+	 * If the folio is uptodate, we are likely only waiting for
+	 * another concurrent PTE mapping to complete, which should
+	 * be brief. No need to drop the lock and retry the fault.
+	 */
+	if (folio_test_uptodate(folio))
+		vmf->flags &= ~FAULT_FLAG_ALLOW_RETRY;
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;

Thanks,
Hongru

