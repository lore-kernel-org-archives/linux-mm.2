Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B87C8C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3324D6B0088; Mon, 31 Aug 2026 21:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCF96B008A; Mon, 31 Aug 2026 21:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C7F6B008C; Mon, 31 Aug 2026 21:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD2176B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:05:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35B638029A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:05:12 +0000 (UTC)
X-FDA: 85163399664.28.634BB9B
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A15D20007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:05:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gMxn2sxX;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of stevensd@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=stevensd@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788224710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFR8aYSnOaVLnjgwM+vo5O2WKxjAzys+M0VrDg9dEOw=;
	b=lbzce32PRREtP8K8NtRPoa0B4HtqchS2vZVOIzhCouOEgEPSYmR9yCtJ5oRc2Z+OlOdriG
	fhDJFAiK12smYFOJlVWN/qBdiKCzZJv1rDkVGQxyZ1o2epgd2yu9mMHvQ7WYoWYSAR+bKg
	Yibw1oq/OXo1wdMEaXxrlSQsL6lQj6U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788224710;
	b=lwC26itSI6dE2mlG9l62SwAZz348vLCYXLHM7wVryZHupYvPLIFPAVacF8Nbyv8U2FL5DV
	Dqcp+fvXnlcL8Sn6j8JYTwmj5lITAPmfCzpuh7ZE3sSZtStmyRlBUqn9OP7v6mcayPbcSt
	m8NjfGD4fiMcJRaFkk5iSbKWTBIoKsE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gMxn2sxX;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of stevensd@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=stevensd@google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-499add6348fso11345e9.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:05:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788224709; cv=none;
        d=google.com; s=arc-20260327;
        b=LA7IJS6pjR5TJvrLFNAkWozvGXDSlPxBXTQd6IOe6u3WaF+LOM5lfRKa5LS6gFaWj9
         HTHK3sZ2f8twhTHyKWEENFwUE324+koMeVgBLrT2hQ2W2O7hpD8TBBjeUR9pnaqOA5+q
         yVEgfe+BAVJZKqP922oWL55Jb0j6KAhCNclODhw0o4aOPkP35eBUfujLQP1+Io59qeLu
         +uX4a/reYEBxdix829AmsDaXHylAF++ml8XQAkHNBvDHG02pLtgMl6SkdiAq+ZRlD3go
         KVEwN4nuXOEbXqm5XhwfBmzksoFxrbubnn+vc3O/CbPXIv1m16qKotS0WMncaRf9TpNt
         W/hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mFR8aYSnOaVLnjgwM+vo5O2WKxjAzys+M0VrDg9dEOw=;
        fh=Yja8Qt3ikWsYbJZhexuZsnmECsSkYEE1YtOd6Y0QC9w=;
        b=lnxZrhZKxBdvwRBGnPNszefXHqeDUT8KARB4IwbXrnD9fkCM6BJItRm++K7cWsvkXF
         3R1YGhMqch44/dkDcXQ5562sv7bi1RNz3WJH2QipwEljIW50PcmYT1HhJq6trCsN3Gdf
         47QQy6JGu5ZTdUgfvJRMKbLyu9lP1DLoHqNZYcYArB+m8ifIW5AILXZ7iJL4PRezMaEI
         vwnaOPtk+ZSxbPgLt67GfFKTz4lU2FPnGgZ50LkWoxvRIvobLR7dVr1jJqzAdyabIrP4
         bze5G6jw+G771okyAT29Mbaqru+boksr1Cs3pAvc/mn+0cWBQK85ijGDUZs3MgpCbEa3
         wjzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788224709; x=1788829509; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mFR8aYSnOaVLnjgwM+vo5O2WKxjAzys+M0VrDg9dEOw=;
        b=gMxn2sxXfgoWn8A0OjUgxkmkIPLSWPQopGs6AIeP+MULDVRmeCO6RjUf0qK2z6WRtR
         AdPgleWNUssyA26/NvKoN53/9lge0gRLsE5g60Or7y6PSB2lg3pd2FFUdityzE5J1KsY
         3o1tVmKX7MtK4D6TBQE01L2bDB5bX2p2dfdh3cysVrb7RJfhzhfRSv+lmhp2rVcZZuYQ
         xbTVeM+nXjW00c6rY8GqkgerFpW9L25j8TFvSx/fpBzIvbV7UlmBo4aHAGqlU5AwUUw9
         HNuJ+txzbqCpWmdl34YVy6pVWBKJSKSLsqGndqfk1TQXBQSfbwsXl3W8Rd2ULTIqO/A7
         32rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788224709; x=1788829509;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mFR8aYSnOaVLnjgwM+vo5O2WKxjAzys+M0VrDg9dEOw=;
        b=sJSeGztwRDwpjfKvKWrM76CxZ+8n9wsLBn885H6e5u4/Mo1FHNHofPN2/gI07SVDOn
         P2VhvetO3asCacTkGUg35Mx6ZP2GDpKtEk3QyyBjRtJmeRSGeDhMPaurByhIfGsrDK5m
         UaK1p6lq9+xu6XwwLiw1wHabMR3JWWl+6Zebstuv4qJ9sDKUenD/pm2j/fYcGLQUR3Cs
         5D/43m7xd3KYYaVkbWgnM65H0aPLLDyex2F75GQGGP9fAaMTqcN/bXEX+FUBUsz7MFSO
         7ZYKo1Ifks1RFcBVHmrpwesdVGN3FlcGH6A71RJavIN2rgBXS+ke2VhsB/fruZtHjk5U
         lEDg==
X-Forwarded-Encrypted: i=1; AHgh+RqMgfca8LhmpXa0q1r1SuaMg75iZvAeqqeX/ukjIv1M+7ONrESYEt3Qoawsrd4g7FJapTCUynHzBw==@kvack.org
X-Gm-Message-State: AFuF++mmJLKcfALCSZa2ecWNv6fgPjR4rsk/L0derRR0Um58r66ry5DW
	yfpqlNWItcPKnsBYh5CiDhsh+aiDU/CZq54nJUiex0WfCsQ+p4yNhARxaM4kb5wYW0OkjtisKMB
	oqjbJaN9bO+tWlhnlG+5qqY7lja7g1D0RUh7kk2jQ
X-Gm-Gg: AR+sD13GZqdoWWqmcEZ3EeHxR06OUvzX8wDNtGQLF6r1zrwwS+40KB+wc4spvQdzrZp
	nmSxnN4UYi+IH5yRp7vOlCslAThYW/LgVrYPfvvt8GWDFTCooBp9n8d/77G64RbTNoDXfjXHBPZ
	gayrb+mhE6o0v8cdCGgy0vN0pWUVEsQkBe7rt9rPgf0mRYkVMzJ/HocMJGF7w9G04XOfHxMo8dU
	enF2FUkfgiEVhMG6ngvFRyjRhx4wNPep2OpqSjeD8vxNbQz/Je5vEmRW5pgSNCnVhi9WAG6CgFt
	v97BpNJufjJ5BDqT7Scauq9WyVrJBpds6urx5ha+2RKasDodWVouMZRA2GV4ii5zMle3WhQF2bU
	=
X-Received: by 2002:a05:600c:c088:b0:499:c4db:2ea9 with SMTP id
 5b1f17b1804b1-49cde7bdfaamr142075e9.9.1788224708321; Mon, 31 Aug 2026
 18:05:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260831234339.280376-1-stevensd@google.com> <apYXCL_GJs9Ovu0v@linux.dev>
In-Reply-To: <apYXCL_GJs9Ovu0v@linux.dev>
From: David Stevens <stevensd@google.com>
Date: Mon, 31 Aug 2026 18:04:57 -0700
X-Gm-Features: AcwNN1UUQ5wS7WM0_atlL1tQIeuhEAKnPM1Hr-Z68q5Q2CNXNYgeVFoYiElXs7Y
Message-ID: <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is allowed
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4A15D20007
X-Stat-Signature: y6frp6heuqbg5kageayqzpmiac3mypu6
X-Rspam-User: 
X-HE-Tag: 1788224710-37244
X-HE-Meta: U2FsdGVkX19feBax/D6Wg5WXCF+JNJz/E2umveeoxcJsJ9N2j8MB4B4E8AxBIl8jBa0C2LrowGKm+oZ73fGVtCVnB2PfgH5+z83VqxCiIe0GrkD0dxVj8kFeU0Rsjptiq8b6qHzODq7aaEsnz3p+KFy0j8Xsl4obQTDWP8lU5KtH2FfFW5KJMsJJEc3wmLPVifLooZx78Vf0KU9JkxZxcz79YMxj9OHziM2c9PFrB6gnbresEU1Vv7NtLrRuJYs2DFoQsmUE66JV+HBDwxWCjIZQEnC+71Hn8C4w8d+L6XhN3MjncSeNNs0tsCDrKqbzKCzUq1VmPesydiUyhFAnLStqKcUkpjmYkdrMMhLzMlOfEMW2UJSm+AABJlDFS31zrcaKM1ZdfDb7JF7sdMsPQOlYce9jJwh1mVuQvBFhysnvRivxIb43krmefZuyrYLjPx0xC8C9ZCG3AMlVHITjO2gSwxwisEmCarJyaOykaAs8jxI59BHj+dQgi9mTmGBEJv6v88EW4IkctL6DFsgoWmJmSXxjmax4ZFBwi2CJVPi8nFZe4/p6cXjkQJb2UkMlH9/rmBY/xoH/c4zc3iu2H9JQVInqBW5f1fVVnyZhFfVjCe0kqsMXuoJac8iQrdDtr3U3hg6UlBU/8a9GazlNZ7pTv7qcFyk6YJh1zqsUKcu0KbMAAwi8RFcl9HCOO/PAFfi/loHlutMW8tPGSpLUW+rivX87b8aVmO+HUroZuxqZk0HUsNwfzGyGiDQcL5PGZi6Bz9LXB7xPe4nmSdGiuizzEG8AH7yC5ZLwPGMV3CUd1apD2klYRI/gef3eJd8IeCXWZeHvpPkYoD2CKeeOm42h7lW4n89+m19qkyFAcwNEV08hLXVDlaKKbuCvhN2z21Sd5yrJL2rTyM9EtbdiDf2Ewi9efj02jFQjmNpZDHKkjQOBTp6SjZ0ahK/6LlNcVkLrUg9dCNsgpWT1+3J
 nAIGzkPB
 PFrMaFXkj6x3zbQE8N+ZRd+5aQI6DHQunbqpm4TC57xu0ahmQyFqgy7BlfnkDR/ynYUAFlzC0Xe1NP9gMObp1CFDsZfet9gdpBpPA8IwwSHy4+MLH749ZTWiiyaJUulIiL+8ez3rSAdVVyBTEJ9eWUv81H+pqw2oRiZoSPKFiC7CC4cDrxT1O7K8UxZt+7PRn12AhMSQjkBGa4JsAXxDVMsKXf829P8S+qFZ5zgqH1hSZB4yEVyKksunRONIZzRjaZwtqMm3JZK+jJvh/7TR3/WIYunUS6GAEcdyvlBFhxY7opEvEUaQxkjyJUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 5:10=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > Memcg charging can be done from any context, but calling schedule_work(=
)
> > isn't safe from an NMI. If memory.high is breached from a context where
> > spinning isn't allowed, use irq_work to schedule the reclaim work.
> >
> > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > Signed-off-by: David Stevens <stevensd@google.com>
>
> Did you hit this issue or just code inspection? I assume this is the
> done_restock code path.

I just found this via code inspection. I spent a little bit trying to
trigger it for real, but the only way I managed was by writing a hacky
driver absuing alloc_pages_nolock().

> > ---
> >  include/linux/memcontrol.h |  1 +
> >  mm/memcontrol.c            | 12 +++++++++++-
> >  2 files changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 8170bb8066a2..036d973ceca6 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -219,6 +219,7 @@ struct mem_cgroup {
> >       spinlock_t       peaks_lock;
> >
> >       /* Range enforcement for interrupt charges */
> > +     struct irq_work high_irq_work;
>
> Instead of adding more complexity, let's just return if we can not spin o=
n
> done_restock path.
>

There would be no guarantee that memcg reclaim would ever be
triggered, which also would also stop MEMCG_HIGH events from being
generated. Overall that seems a more serious than just dropping
userspace notifications like is done for MEMCG_MAX.

That said, it is very much an edge case. I can send a patch with the
simpler fix if dropping the events is preferred.

-David

