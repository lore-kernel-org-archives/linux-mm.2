Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A90BAC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB826B020F; Tue,  1 Sep 2026 10:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785936B0246; Tue,  1 Sep 2026 10:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673986B0248; Tue,  1 Sep 2026 10:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 395226B020F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:26:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8B31403CC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:26:00 +0000 (UTC)
X-FDA: 85165417680.14.3083C04
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 711F440005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:25:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qrd8WxLm;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788272758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObgpNp4xsh/An8XTcvl4h2cgfsJnES05kTjlUzeTPjo=;
	b=aMYRIGzZbNxh1AiSzzST3VKtNxYu/bHA05WlHPvKgZwM2JTTXfN+NPxvhD8+Q0MhLSGdqw
	5emwog5CBJM4f1fqF/DNNCP3SDUjf5bkjPGABcAXxJsb+ZydGyExJEgiwXnv6U98np7pcu
	s50QgMrOiQ8Q8ay65U7MwIBoj52Iowc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qrd8WxLm;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788272758;
	b=QuMmwHtrXpkpXiRX7C+SJExRDNxU39oElQKryBGfgjJVBzC4dig8ecOYlIBi4vcXmNKBOn
	RT44Kqm9XeYE3/JknTCKFI2Vb7LglCUcQ7g41MDt4gkyulONYnvOmes7cYTKNkO2pDRca+
	SoV0cqKBA8g6MT612jW8DyIGsqi5dRg=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-857ff9fef54so11028657b3.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 07:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788272757; x=1788877557; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ObgpNp4xsh/An8XTcvl4h2cgfsJnES05kTjlUzeTPjo=;
        b=qrd8WxLmJgKf8p2x4VxFC01iCtf2nb8cndxYtiU3ogivsdqEMUmp/PnwQU9V+pk5sP
         8J7Z2P3+MZbglm0dl+Ai93GkkgpK1zHEI1EgT1iztMRfCNNNUW1g0n07+5csSf/hLGag
         y0zfUpFbR/RHfvBHnsIX7e6WI/Lw2ivVDMsKFBdffdP0v+WkbZgTmUJoQPfjotXwOzL4
         loqKWZyMeYsSGoHnPAMfibuwIZ1fYzfRYehUBlsOfl/RuOUFkBBUihJhq934tBCm/G93
         rPlFN1dFIGK6KXwE4sIniFCfvcJTzaDyY3PwQ7WLV1Lf95vJJykIvdX6APn7VadC85kd
         C5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788272757; x=1788877557;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ObgpNp4xsh/An8XTcvl4h2cgfsJnES05kTjlUzeTPjo=;
        b=l4/se6mU+3hAybnI4o9eGwSizBQUIsI1Y+EaryH+SjB8OMtnykas8Y3/1U+3JHZHak
         ZAxqPX22ztYot9pIUuo3scYQDKpgdX990zszzqO/Cs5R1gzwyMqZoPaXFU4QbvsqSAhj
         iKcdMpIWNkvCvm7EfcxAJjMjXbLU7kwAxe9+1J0L6phjq2gFZMuWhQrau5jZSaaNZBZb
         n1kiQkwhIHWhmgYs3lojfyKWc8UScNpWOUhDoOQ5aqv0fgZzIn055FKiu1B7gOPb1h8R
         uECFMyjxrF9ythavkyouPYyha8zP1ADf+Y5hqt+15ZjLRJmakfUX7XeeMMa8YuVZ45Hc
         ow2g==
X-Forwarded-Encrypted: i=1; AKwUvBxxwAOrOlaL+7rmM8/4I1Hx1Lc4+bBUjerlw07SfM1tdK+LkId3cPUSy43tW2Nf+qQd9+w+qhly0A==@kvack.org
X-Gm-Message-State: AFuF++mwI2gVXKnN/NgSP7ADGxLXjtdjVSxkzw5UGqlmHzq/+F7fOxyV
	ocls+x8U5h/7qNFFLOnTcBnPgMfxG4q63ovfaS5bchmlppDaVAvCXioS5GGZcyU0D78=
X-Gm-Gg: AYBFou1tIybWQTOn6bEAh08NulBxf7BTipHW5wsjZJfbzCUfr7p57nDmCudQMBTCZPx
	9JjnCXyBlGS46tRU46dCyu9KPDmfSc0Fg8M/Ql29ENc//UqN0Q80ZQzIO1XFfvXZYb7UhiEaLDJ
	OrpvOq0PpNEgzjYvTrRElvpdpME9NT2W8148gFvMW2TFD0ZcsrWw22GXO/Bi7+5Efs8BO5yO/QD
	ZQUIlf6pdUwjGWcqgwMIEFwLzT6ed77VVQx+2+CUXiA1eFPQGHuHurLgfZhJGsyfUgaRbjGCQX4
	afnjJ5lQd6Du5VhhQxHimtEnJ2HumgvmRVr0/+ienP5zeJ88RQc+T32UUkbTxEXecDFr4JHjr1Z
	NDukcaYn9C/F95kS27BF9fXxhg2p8PPaq6iREIUEDXOZNj+DfeJo36z/sASI2vvE6Pq2LCOvfMD
	p5mKPdkAnleA5h31dMm05QrpkAZ4gqDYjTz6cOh34VLbccJZdYlMxi1WjzxT8pAOVeY8CeAJQ=
X-Received: by 2002:a05:690c:c619:b0:854:d9d0:467b with SMTP id 00721157ae682-85d6cfc160fmr112291277b3.22.1788272757290;
        Tue, 01 Sep 2026 07:25:57 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e65f146dcsm75394907b3.23.2026.09.01.07.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:25:56 -0700 (PDT)
Date: Tue, 1 Sep 2026 10:25:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Stevens <stevensd@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <20260901142552.GG3004@cmpxchg.org>
References: <20260831234339.280376-1-stevensd@google.com>
 <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: gmxtxd8q4wkjo4qptmiix1tanyrtkegw
X-Rspamd-Queue-Id: 711F440005
X-HE-Tag: 1788272758-362720
X-HE-Meta: U2FsdGVkX1/mW6bDuZw245176IL04mC5lucUDvGQ8rFFShCPcSiCBDi+CsvLkcf+9CUxIEQopAOnHumeOAGRi0aooPRXFmXF5z1nLhsRrOP0S/MW4h4upFH0XVVtEWb2YbIk3AteSctV1Nmi0e8H4aOIRH4ERVVkBzt7HxhOAJov146cV8yIU3g+rnkHFlsuhSGbuChtWON3UzzyNy8fzIo2NEBS/DPPaQaUng8TCRuYf5cFRFgOaAXuEb9tsl46O7RICq/dh76N9t5P77H8VCinyBblkal8BytoZGdEKP13khHCFpEyVu8KIBbr6SLeJaRY7UzwTlsQ74xHVDGsUj3jCx5wQR1tAFzpMTgGdHyZqNZxRrnfqo7Oo0lSzmVIaqJtsgu6EF8VfPgCQagBMCGUNzL+w4GSLbmkWZISLuRW4BitP0g3iVpEcLUyFg8VGr5z8oX3zncsJzl+isYngqNDm4o4IaurA6uH0bkQzr1/uFkmo5Un2Ly5+7O6yWTPlqjv0UvQk0uWVddu5AiUOX1LRCPGZmSbqhc7xWNn82cPc8sBLtfU7/6ITioSfP2jFI1P1Y5Ef7c0fTG1rhHO7nalJ1I1PGocv7JcUOjEdh7Yc90HzR/IaV5jOFjCaDq8S/uPeJpM5acTG+GJmfVBt61hpFhgO0GvDKWdL5RvmgFk5Yc0/QEviwTHy0LKDJ9s6rGXSE81wdYXbhJdF02oO1DqsroVv4Iy55zAaTiGPdnKQf6jrX5FPjhUIncj7mnw6hqKOMwuGQuzp4nr6UoOn8y9E7T6VdUxVOKhIvuDYI7vkXFluFJsymwFySc8MSKowC6djaYufaej9wWfqrxtMwyfIY61rTP7ueI0TH/dnmnSUEnfVG9aU5y/2r7ucZ6rR9IxChGVu4qzJqo3XaEayylBxQofoENfY5tS7o23CgN77qhl32gG1l2XZP2wRuElMZUavmUUtK623ny0rFf
 1vRGM5v5
 NjXYa0znkzVpNm9q1Etmq3SSHHhVM+WzOIWVPiIxI/i6rloJcGo63me3BU/fM2JQ/W0AmCyAueB4Dio8ifUo/reAF5/6Hs4xq+ruyVIPk/zrWg5A6Iuy+XOVuvVZhD7wSFb+a/9CpB+6m1AQfpokToDp1KwV+pMbgZ2sK5W1/8f+7WK0mOdk2l4ieOSXStJaiZrbfapjNxnKLsNlUnYT/SNikMJDrPFfk26CE1c3m2tmUwc7RBIBP7Q7fE62JUsIw1e9yBroSaUq6dcNnPT+G487MOISV8DstivweIBdnvq99s7YrPtbH45pDERBESIf/4qU+2HPvw3buRkqm6ba5IT0zHYLFbSAe0M6BrD4NCBrqelz6gSjgmNYaye+CYVE/Aq1l8FnTEzoMEOk664cxVgFhCyMMIcQZFrLCW4+wma+U/KCUGxvA7NFJdpojgSbKoliMYjo3rUz5ByRC4Tp4YyC2g911HAsenxSZlpQWZWURfyzBwIZmeZokrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 06:04:57PM -0700, David Stevens wrote:
> On Mon, Aug 31, 2026 at 5:10 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > > Memcg charging can be done from any context, but calling schedule_work()
> > > isn't safe from an NMI. If memory.high is breached from a context where
> > > spinning isn't allowed, use irq_work to schedule the reclaim work.
> > >
> > > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > > Signed-off-by: David Stevens <stevensd@google.com>
> >
> > Did you hit this issue or just code inspection? I assume this is the
> > done_restock code path.
> 
> I just found this via code inspection. I spent a little bit trying to
> trigger it for real, but the only way I managed was by writing a hacky
> driver absuing alloc_pages_nolock().
> 
> > > ---
> > >  include/linux/memcontrol.h |  1 +
> > >  mm/memcontrol.c            | 12 +++++++++++-
> > >  2 files changed, 12 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 8170bb8066a2..036d973ceca6 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -219,6 +219,7 @@ struct mem_cgroup {
> > >       spinlock_t       peaks_lock;
> > >
> > >       /* Range enforcement for interrupt charges */
> > > +     struct irq_work high_irq_work;
> >
> > Instead of adding more complexity, let's just return if we can not spin on
> > done_restock path.
> >
> 
> There would be no guarantee that memcg reclaim would ever be
> triggered, which also would also stop MEMCG_HIGH events from being
> generated. Overall that seems a more serious than just dropping
> userspace notifications like is done for MEMCG_MAX.

I'm leaning that way too. It's an indefinite error, and it's a freely
programmable surface.

IMO, a few lines of relatively straight-forward, self-explanatory code
is better than code that needs a comment and leaves a problem that
somebody in the future might run into.

