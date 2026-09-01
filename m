Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF67C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F37B6B00B3; Tue,  1 Sep 2026 04:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCA26B00B4; Tue,  1 Sep 2026 04:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508D26B00B8; Tue,  1 Sep 2026 04:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE3C6B00B4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:18:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6E481202C2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:18:19 +0000 (UTC)
X-FDA: 85164491118.21.C8EB097
Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	by imf30.hostedemail.com (Postfix) with ESMTP id A028E80002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:18:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D9UbVN2W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788250697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rn0C9xZWIK2fZCFipWenTGiOfZluTdBZ87ghLuXUjEg=;
	b=Pr0at4N0xc+NAhv7nKJJ+n1pMzoXAx3VOpjc4jLpAIXWLSXTLBj0XxfkJ7yRWNe9x7LaxN
	2zyb8zrstTVGZX1ZRlJ6tQk5szhBaNQq5m09bHrW6sVYYjyvF/EKPZk44pRB0FA//ktYdQ
	utudMJjFfXNMcilmEeDptoGr2+ptxB8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D9UbVN2W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788250697;
	b=GwP44qWUmzH81BR8DSCtbrhsCB4ylkn5nofjAqTvvPoZ5Lju0QhBEWjuAvmSXzXaEuKwJ8
	ox3+wIM0RY07S/yPcf2fHyrjR+SjOCh9wPtwYdgkJt1Rpt8xQJRHpklfDSYWNozThqIzCY
	XgtfNO3QN3Uqbcnjw8jYzzpNPmyZiw4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PTAyQAT6b8SIjtBAGjxmxs0TM06Ij5cauUJMeqTAZWA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788250696; v=1; x=1788855496;
 b=D9UbVN2WRLCU5gWf/Yzd/W3AEGS5o7fEvrtDYdPiDRNKEhl3bLNnZ69vd4U/sfqzNHjsI418
 FS5qvb7t9/X7CVwuNzajccxJGxNgYP/bsIJozIfivD8e5+jm2qvz2RID3XHygK3VIdNKeiv8UEB
 +HZxFCjHloC6xSvW9rZJFOE8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6327e2275dcbef01;
	Tue, 01 Sep 2026 08:18:16 +0000
X-Mizu-Trace-ID: 6327e2275dcbef01
X-Migadu-Flow: FLOW_OUT
Date: Tue, 1 Sep 2026 16:18:10 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, kasong@tencent.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH v2 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Message-ID: <apaKQvME_y3K2bQx@fedora>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-2-hebaoquan@kylinos.cn>
 <CAGsJ_4x=sZcc0+wkAbS02YJUdpzxTTpozh7o7CSozWL=1K0rNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4x=sZcc0+wkAbS02YJUdpzxTTpozh7o7CSozWL=1K0rNw@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A028E80002
X-Stat-Signature: r54dtygap3445dhbyupmj85trx7f79mh
X-Rspam-User: 
X-HE-Tag: 1788250697-354954
X-HE-Meta: U2FsdGVkX1+UnHmxnbXqXe6t6RNSY075MqT84NrS4wORWE79M8Ozgb4/JQXmVtbxgZMGcycIDjw3pY3bUScVxt23DpF7fYTDsKMTXA9iVUlhnG6XO666s4P9cN7T7LPRVjfRBewKUfaG6u118IEdvDMoHKmYMQKsbbB/Uwbr0Tk1kIgIQsgxH2Bwt4RgckpfZqXZRFWOjgY3bZeK2HIbsfZXGN5dk1XZzdFceTBwOFDmnwgwtNHZs3V/4bXZATjbjq4xKoyC4EzupFZh7LNidcK8mgPqrJnnCfq30Xx8HWqItr5rHpc93tONOlX0cr1YwCxPDiwbc+JqBTh0ML4vtPZsGEsZWdAMBoFjCAUSvYZZY84DGwsf6Gdj3MCICAY+Ku6P/sNfyeLMwbwW+E88fcUO/Gg8iQmkYv4GafhC5PBNC/tMGCWfVSU66GsQ/eAGxkQDpqaM+r4m36p3z51tGCnDrrVcg48cCRQX4GVwZOeIzqfsEwBjr5mJFM7otolhqLB55XNciQhnOuRCotNWOb23G14pMicpE1/CniqhYWZlCXv+v99M+HgptcJoPqAQGpj9i9rryJg561zMB8zNI8xaPjp8SbQYTz2PKNWcDKZrwES4ZaZu8nw8n8TubOm8Qo5AgtU9WLhTU8WibRoFC60/KQwS6QSMnQPf07RH7fX06jVo6LXvE3KM0PW8k2iW8mjgQMzYw7kbWoSPSyKeCPrLwaHfH0+YBOyap60paGyxcqI9hVM+n22imMozw96Rmqff3aC2llXgPWcmCCGVQYfHeuyHMrdKHXA4BCxsocYPou37C/EkpaASzfRbVt+5Pqq2ZD2O7aZ+MHaaxZoUUvbn7CO+JJ4IzYnsrKED2vRA32BI41VcIq1uw1yLUxaM6/dhTpD/Rr3oxYEMuWUUjONGkmjcW+Zl0SwnQdVxacSGWU1t/kY4ZPeHldW3/5m26nH75lSjWPQZRcmbIy5
 s40VRTZE
 AkXJgb8WZo1ynvofV9VZRTGt8stDngtI9pg4+yNCMrL2ioZj5LqC5+vTaiYNYFEoBQCep8x5y2ueBPd9KNYXuLRJikTNJwx9v0UK+nlgM287qB3aRVJpT8RKvUtvw+qjM6WjKwm/vCmARHO5Zej8zMEWRA9ter8wusdJxYQMsm39ztBWmZaZHlCkFWjtM2n3+opMK43+pNi6P6TNctFfeTstqOKkKxhDRyCpsL/DDk8Hbco/1w++OMdn5RdQ3r8hbWBfl0A+OqIzgGEmJJp9CmjwFw5u8WY69r3UjTAufVWJY8PCn5/kCmsAW2RoICwxSMZLe0i2TqtNXcJkDygGIllSE0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/01/26 at 03:11pm, Barry Song wrote:
> On Tue, Sep 1, 2026 at 2:38 PM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > Add per-walk counters to measure empty aging walks which traverse
> > an mm's page tables but find no folio for the current lruvec (node+memcg).
> > These are common on multi-NUMA node systems because lru_gen_use_mm() marks
> > an mm for all nodes at every context switch.
> >
> > New counters (accumulated in mm_state->stats[]):
> >
> >   MM_LEAF_ASSOCIATED   - leaf entries whose folio is in this lruvec
> >   MM_WALK_TOTAL        - page-table walks completed
> >   MM_WALK_EMPTY        - walks that found no folio in this lruvec
> >   MM_LEAF_EMPTY_WALKS  - leaf entries scanned during empty walks
> >
> > A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, and the
> > debugfs lru_gen output ("TYFALWEE") exposes the new counters.
> >
> > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > ---
> [...]
> >
> > @@ -4109,8 +4113,28 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
> >
> >         do {
> >                 success = iterate_mm_list(walk, &mm);
> > -               if (mm)
> > +               if (mm) {
> > +                       bool empty = false;
> > +
> >                         walk_mm(mm, walk);
> > +                       /*
> > +                        * A walk that traversed page tables but found no folio
> > +                        * belonging to this lruvec (node+memcg) is pure waste.
> > +                        */
> > +                       if (walk->mm_stats[MM_LEAF_TOTAL]) {
> > +                               walk->mm_stats[MM_WALK_TOTAL]++;
> > +                               if (walk->mm_stats[MM_LEAF_ASSOCIATED] == 0) {
> > +                                       walk->mm_stats[MM_WALK_EMPTY]++;
> > +                                       walk->mm_stats[MM_LEAF_EMPTY_WALKS] +=
> > +                                               walk->mm_stats[MM_LEAF_TOTAL];
> > +                                       empty = true;
> > +                               }
> > +                       }
> 
> Hi Baoquan,
> 
> Where are we clearing these counters between different
> mms?
> 
> It seems the previous mm_stats will affect the next mm
> if they aren't cleared.

No, they won't. The counters are cleared between mms. iterate_mm_list()
calls reset_mm_stats() from its "done:" path for every mm. reset_mm_stats()
accumulates walk->mm_stats into the per-hist mm_state->stats[hist] and
then zeroes walk->mm_stats[i].

> 
> 
> > +                       trace_mm_vmscan_lru_gen_walk(
> > +                                       lruvec_pgdat(lruvec)->node_id, walk->seq,
> > +                                       walk->mm_stats[MM_LEAF_TOTAL],
> > +                                       walk->mm_stats[MM_LEAF_ASSOCIATED], empty);
> > +               }
> >         } while (mm);
> >  done:
> 
> Best Regards
> Barry
> 

