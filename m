Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBD8C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD456B008A; Thu,  9 Jul 2026 13:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4CB6B00BD; Thu,  9 Jul 2026 13:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5126F6B00BE; Thu,  9 Jul 2026 13:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4FE36B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:42:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FE471C1F05
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:42:33 +0000 (UTC)
X-FDA: 84969957786.09.41035E4
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id D6615A0009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:42:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OQqnee6k;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618951;
	b=7bFkUZ5xXDpclfLVyMk0JKvyOoK9ZvnxpaRUNEZh4MZcwD/WETcX0ssvPwT8mXEpW04mia
	WPCKlSfv+SOB1haqdewkG5tUYbL4qRegwvtxlnJYT9iWJBDg16XnFNuWztaiunUcWmao7C
	Qgh0sBGkEdJeUDwU65YIxl59pVaJ4A0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OQqnee6k;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCmYJfmZUrFzu6y7sef3nXo3D+tzzPc1JVMO9nTza9k=;
	b=n+VvpL0AWHF5OO9sMHEBUCUn26wfcbS4PzQhb+JAFhdhGupOo/w8nbvHSjH4sSeMuXIziW
	eAPLRcz876UieMRs43o4dq7MkoJXhOv9el+7VLbt8nI1nfCnxSMfwH8090XLWJTxnVptqu
	n3bX+3BH8rAspJih707FLZ7SAMHgECM=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e55b62640so3244885a.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 10:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783618950; x=1784223750; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZCmYJfmZUrFzu6y7sef3nXo3D+tzzPc1JVMO9nTza9k=;
        b=OQqnee6k+bfNfP+lLe9YgerAENAP51fjJGDhPC6hgK5VKOwjkzSZGUs9Sthk0tlOp7
         VwJhSLof6Q/NVdeDYPDEEZBI+JsS/jSeNcyR5Lux0+OmzDR+YUALoTuVnpA56JCj6dPO
         o0Q2M403uY107ZZx3EB6bIBqGPEuZOpvnFkFbZh5yICsElu7uSCvueazUKjqY/IlwLNZ
         da9Nu+I4+hZ+rsGwoHhOmlCSEryejTWcZ3qM6DBgolmOEceAkHJ9cGno+nYSeaguCVRd
         2taVnE/2JInThKZDAJvwb5oHP0qNCtLy2oRjSv/5/6KAuorHS+OqB5T4q52nCF0qNR4u
         uE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783618950; x=1784223750;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZCmYJfmZUrFzu6y7sef3nXo3D+tzzPc1JVMO9nTza9k=;
        b=dOObQ6gjajORBPZxrpbb7kdonbw3Eajmh21cquyLpXMjbT3scDGlm2aDi000TLj/8Z
         KbcHcqFzWwIKd5pklQOREhBwYX7+KnC7d++O0282jOvEkHRNEJ1daYuT4nYLKl2qOFQW
         5i129xXzDaxBh0g31F+ylGr9KrmLTyi3+MboGsTpLKtVs716em4VXf9Zp3Vg0K9ukiZT
         3QCFRqfdy56qz12s4a9+5kMqD74v9HU8DTVlT94u07IRuuIK+xm5bV4GAlDW3biV8BQf
         IyvurTi0vENSKnzdiBeakKSuw/VBXyitCipovc8ndb2ypUSpdcQ8UUJQwaRJKxhGWd2M
         ac0g==
X-Forwarded-Encrypted: i=1; AHgh+Rp0gsxyc9JZPbfjUzMCiZiKWTJIXTYjwrKtbAapA/IqrAkE8ITe5tgDwKTy5RXYc5TfwuknErUmtA==@kvack.org
X-Gm-Message-State: AOJu0YwPQfrQP0HDK5JVsidbdG/JktgVAbksW/KbTqclePMAfj8ESrNw
	BUbUUg3nAykKenvfYEqa8xCpAEgp8o5/qrLjYdwjD34jFvJy7xVjRyt+bwhtzEmYYOc=
X-Gm-Gg: AfdE7cmTWgkj0byRbici6k74LPEpRu1JYGPoGzmu83NDmyOki+1PIrUtv0NhQAawYo+
	GVfeTlZ05a3f95Hn/jIaQfvyABUYVqH4XG1sn63kgJiD761HJJbi71gKsoeyOVYFSBExgk4LLHs
	dy/2pflJU04KAbw8IAXPOsdsv+Pt4gM9/A3SqC8At75ulm7kslfyqNFofaCOptF5LGaGwvROU/V
	+GuiZ0rgSOl3pUQRyUDaFYOcEug12A2TkvRDoi8hJF0YUUqM+SZPLaeyZA0DNdOayUSDNipS6s5
	fJhqvQ5h7j50JjZmuN4Ee2PaSHW3kNK5fV/bm+SLPZERw6falokl2ANju+kr1Zl1Hj65GcQaUWA
	1spwqutkh7zaxoB0tZXyL4YUVZluMC9aNKwcek0JLaf4cnCZstN6zHl9H2ufoRafE+Fdt7QiHdI
	Gedn95zLV4rcw=
X-Received: by 2002:a05:620a:a51b:b0:92e:d953:8283 with SMTP id af79cd13be357-92ed9538814mr421842585a.44.1783618949159;
        Thu, 09 Jul 2026 10:42:29 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90ca004fsm1721530585a.28.2026.07.09.10.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 10:42:28 -0700 (PDT)
Date: Thu, 9 Jul 2026 13:42:27 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: compaction: support non-movable compaction for
 pageblock requests
Message-ID: <ak_dgyUa3QI8SKaI@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-3-hannes@cmpxchg.org>
 <DJNPG9B5H59C.1RS4YG5DJRNWB@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJNPG9B5H59C.1RS4YG5DJRNWB@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6615A0009
X-Stat-Signature: 3tuux63fpgd3zc9jfjd9ta4bcjci3muk
X-HE-Tag: 1783618950-76813
X-HE-Meta: U2FsdGVkX1+aHF1FEuKbMGA2jLibiKzr5IPadoz0MLv9LT9N8QMu6cBbZVKKMwyqiATtGKNxj0rj4MvqHLnUzDLxYPKnQhK0EfhndOqkOojkxt05xCVNyASbFV/b1sDCOTeN8ZRYSTftrj+zT3EsuF2lqIeuWCD9P6K3zhtrZYaCJ5mKTHTYxZuxZtmegi/XEvljxCA4z9SNDPs/ARYgXdx87sfJ5ISaNxmV4Q7l0+gc0TxZvVw+iKoLUwPBjs8Qpb84tgKE8XVKx3ugrQ1vljtXnLVDRxi8tqoNQL/Z6yRHQ5dam3KF/pjWhFem+hW92yA2gFZWDoDgXCq+mxZz0A0ax7i/OnNd8cI7rS8CAXg5c4HPrPz2huXTKeWcMLTK9OD32OBsuSY9nqyI0o6Sz6hHigO3rBeE+swqeVS+eddislgeQjotPPyNJQUJz8bQf6KymLdNB3cHF/9HBgShDdLXnQWJUueVTgGS+cAwQGIw/+fgpyOAAZeA0D1qV0an3MfOkb7RPi9piJiJH+hhTSNoBl+AE1iVzlXEsWiMp9f3MVjo1ZUcZEmRNRWQodT9rXfmSncnCKkdq/bnfOsVeW8xE4jjLEsU88W6JuE2RChRzsig4Bp5vDhw2vQiVRiIyV5YM376q+3iB4M0TRlvVv6kTKUYBUpopknIoD2dqM9M5D8cbnCZAxugwUKuSZfoUX8bjIGFa6QX5kwYeVCjNHA8HeU3bPcJhs0Kk3q+ZERIHnwGQXVaZ18HKQuk08mlwZ33RUkWqzWkN4kXkZtZwwb0qMFzmy7eJw9/sppg2ouK9CBUgJEz9ahOss1c6jGodQzLcCyV4+ZPJn4s70IA1kq38+uaAC5OOqVVvPzI+k/koF82in1dzuQLeC9AG4DqUor5c53UtXHpguXJ/BkJ7YWYyTHNrskM8gA9PYjSepExNgQUXVfmLcYu/xcDwfgcYaerFSNPxJ8hCRxRdRG
 VkS04FWe
 89c39ksW/c/qPtbZfkHUwONwU3AmaeGNPIXdYgFu3ePJSlG0cugbC8oKCyTep92pBNNydoYPnfUuX8FC+dCLDG/+Jy2+0KSxMtpE7Khd23Tf/l77RAvuLVkaMVGJ3c3KBfV4zmXEZzu3qaDXg4yWrQrfAiKF844qCY5XHBvYYVxPKRC/E4x98+6/mFAp/Ir74PDA2dRRfAdmqjIQumKBvAUlcrkeP8c4a20NZB46AE/0EvBxt4J4tZGK9BMQqO0mOFo2C3jl5g8O4JH4amvT+oTg4Ysy1g/iZtDrqntKRW2x08xIIush+GQTWzq4Rrk9Pu7+h5e8VxdMDcu84kH5WNE3Zo0m5aMOE7a2FquZ0J8kFHacXyAZdFfPaaM/ahM0b7acpqZav2+D1S8Kz9vGH5Lc7JNihZv6t+EspEAl3rxzMRD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 09:47:21PM -0400, Zi Yan wrote:
> On Fri Jun 26, 2026 at 2:21 PM EDT, Johannes Weiner wrote:
> > While trying to fix a reclaim storm in defrag_mode, I noticed that
> > non-movable direct compaction is extremely inefficient.
> >
> > When searching for space to evacuate, compaction only allows blocks of
> > the same type as the incoming request. This is to prevent migratetype
> > pollution, where a small non-movable request frees space in a movable
> > block and provokes the allocator to fall back and pollute it.
> >
> > This protection is reasonable on one hand, but the downside is that it
> > makes non-movable direct compaction nearly useless: if we get the type
> > annotations right, by definition there aren't any movable pages inside
> > the non-movable blocks it is allowed to scan.
> >
> > With defrag_mode, the goal is the production of whole blocks, which
> > are essentially type neutral: __rmqueue_claim() will convert them
> > wholesale on alloc. This makes type mixing and pollution a non-issue.
> >
> > Fix the pollution gates to take the requested order into account, and
> > allow whole-block requests to scan blocks of other types.
> >
> > The only exception is CMA blocks. That type is sticky and these blocks
> > cannot be claimed to other types. Continue to be strict with them, and
> > allow only explicit ALLOC_CMA requests and kcompactd to evacuate them.
> >
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/compaction.c | 35 ++++++++++++++++++++++++++++-------
> >  1 file changed, 28 insertions(+), 7 deletions(-)
> >
> 
> <snip>
> 
> > +
> > +	/*
> > +	 * Prevent small unmovable/reclaimable requests from polluting
> 
> "small" here means smaller than pageblock_order requests? If yes, it is
> better to spell it out to prevent confusion.

Ah, I thought the order < pageblock_order in the code would make it
clear. But I don't mind spelling it out.

I will change this to "<pageblock_order". Shout if you prefer
something else :)

> 
> > +	 * movable blocks through fallbacks. Whole-block production is
> > +	 * exempt as the allocator claims and converts these.
> > +	 */
> > +	if (cc->migratetype == MIGRATE_MOVABLE || cc->order >= pageblock_order)
> >  		return is_migrate_movable(block_mt);
> >  	else
> >  		return block_mt == cc->migratetype;
> > @@ -1974,12 +1995,12 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
> >  		return pfn;
> >  
> >  	/*
> > -	 * Only allow kcompactd and direct requests for movable pages to
> > -	 * quickly clear out a MOVABLE pageblock for allocation. This
> > -	 * reduces the risk that a large movable pageblock is freed for
> > -	 * an unmovable/reclaimable small allocation.
> > +	 * Prevent small unmovable/reclaimable requests from polluting
> 
> This "small" as well.

Yep, will keep these in sync.


