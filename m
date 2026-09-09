Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E69F4C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97186B0092; Wed,  9 Sep 2026 08:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40016B0096; Wed,  9 Sep 2026 08:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56586B0098; Wed,  9 Sep 2026 08:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A66816B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:12:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0116E401B5
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:12:10 +0000 (UTC)
X-FDA: 85194110862.07.7E29161
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0859CA0005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:12:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6oBRNue;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788955929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FD1gsvGRC7hkDhQUoluFrtoGkFlmUbPoFR3CsiEk3K8=;
	b=qU+n0CMc9Aa+ML+j2oSxoE/ycaN7ij+sLyZ/T/mtvlK99R7Zs3IKt5egDioEwsCepl8dwY
	sGkDn4+D9fRo3udCWbhDrhRg+JeCtPQR8agYlCw7UomE3o8k7wWaJoiQ32KwtWXo8rPJy2
	UF+rwHKm5fb++gs7PLBF90043zK3Pts=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6oBRNue;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788955929;
	b=ElO1fhjO+rx+d79XQ6UFTryyW/HIwg3MlBN1XDd27kFJhdx5AcsTFg/CTtKo8C+elkOVpM
	OyOa38UGbMYfKWePccxrr2z8L17N7xR4p+277B8XGCZ2cQBPcWoFFaj0RVQyBHeLI2IOwn
	s36qQVOFfdAyESS5MGqZB5XEMhjoxso=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A8F84143C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAC61F00AC4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788955928;
	bh=FD1gsvGRC7hkDhQUoluFrtoGkFlmUbPoFR3CsiEk3K8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=T6oBRNueMixlB9U/xFkN2puYBkY3OzQ7loF/gsggucoe2FH9ww8Rwh+bpvtPGkc9d
	 ccxtKG+EvKTigS9BcX+WZCkd+T0odFJHTgidMiNbEmTYVXgS367thaQvMFSsDVY2pY
	 5IsekUbgakPOf/Et22zbdIW4DH3fXwnw8ry1J+eeT3BwxTYzxXlGma83UOFx6ymGvJ
	 AgMFcjjmC/HkX2l0vRifZQLcDauHgDzZ6GbjCGUQUHhA/vgcloXdojnjdWwzZ25udS
	 Mp/Oa4ZccFJj4kxH17R8oYLo9e31BWkcj0WUYBSYHa1YkcIBhQVD1ZazRPrZXhxx+K
	 Ud6ZAK/xApJOg==
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-66f7f62e915so6407698d50.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 05:12:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzAiCAwD7C+vFqY9hvT7VPA4Wp25AtHXU4uuF/mOzmKA+MYHMHB4k1nMbjMnyf7LhjJBdD8i8Bpfg==@kvack.org
X-Gm-Message-State: AFuF++nso1+eJ/ityaM9+XA/AZLF1lLC43UvACX4W5FDs+agHWwDkjnV
	gctDVQEUCtZxEu7JpkpgB72H+vNVVOhrKfMf3gaWtPMoiapm5QLneIEeOzXU5KZD+/H7I9JTR8w
	P1d5+aCGsfFbULha4s9bhWd1UGuUg3wU=
X-Received: by 2002:a05:690c:d8a:b0:873:5ddf:d862 with SMTP id
 00721157ae682-8735ddfd9abmr109509577b3.45.1788955927429; Wed, 09 Sep 2026
 05:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260907042447.2450663-1-ridong.chen@linux.dev>
 <20260907042447.2450663-2-ridong.chen@linux.dev> <CAGsJ_4zT0HcbkQjdPFPBeaqbGcYp4WE6sghDzz=0evhhupCs3g@mail.gmail.com>
 <102f6ff6-46f9-4734-a056-694eb2c0129b@linux.dev>
In-Reply-To: <102f6ff6-46f9-4734-a056-694eb2c0129b@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 9 Sep 2026 20:11:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wxZ0pc0UMAXe3xKW0=PTzYv31ieoJa1v01SoLczPVOCA@mail.gmail.com>
X-Gm-Features: AcwNN1USPJswSmWSzvVf7WcWGE35FXyfN8FIwgGMrmaqVfupZIYniCIbPs_AXiQ
Message-ID: <CAGsJ_4wxZ0pc0UMAXe3xKW0=PTzYv31ieoJa1v01SoLczPVOCA@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] mm/mglru: add tracepoint for folio isolation
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0859CA0005
X-Stat-Signature: 8p6iqh4amm4fs75m4yiu9zc3eswe7bth
X-Rspam-User: 
X-HE-Tag: 1788955928-334352
X-HE-Meta: U2FsdGVkX1/EPDuu1oE+kELDl+miKVcRUvMXTh5gwQKkA9CSxIFzq6Xru4BWYN7hKowjuW810k/tbgkPndMxDsvjruM90u6OabcsCdLYP7AZQAFEVgk+vyhgduIMg/c072X/hfSzWHWuWW1OZuGV5r9YA6vuaPx4gnraS6FIKdoMjgeDQioDvhagHbgupohqRTjQ/wY5SM3yFUSUW/YL/eVkSKQd/yEmhFmP42UaZLh1KeXfwDP3ebxFAWIYjLwe1FQ972emDnqlz6l81oi/0aNNcSQvaiIrm9Hm/M+OYxrArNNwAvQfY1M7sn5+IiyJcKbC+F4rHuTndYfFsGEK8/SOx4KppkikqNL1itbDqoLKa4ugyVcIFKXPR01t6bA4ApbSqjPVaGd5BbMjVs2h5oxD0tOdoM7h4BVlyJ9ziKRdLqLwYjzBFv/T9QmoY9X9C+ZtkkiUm6dOyJ+9jCw0Yz6yK2Hj+Sroiaatd06GQUuSXLAfUF2PJzbZzVFBU3vkUCFf/B2I1/pv/S8YYuuetmmv2Gf3ugGSugv7Z/PJyjC22j+VvSALDKotVeFhKASlAbQg94jqZrAn0/IrT0TUtWRZdTLQqVa2hzKkrdmYZBQSBX61WKqW1lmAkqDoeNQnHVvI+vsOnbW2vHRe5Vkk7qI7acSRJ5Lpuns2l24VtXM7XDSkZ96Mhu7fpQ2N6ra4sI7LhCKfRiytMpQwQO101YuxQn09zXFQk37nAdqHWeddq1NULzndtZmUhWdneEImHrxzLBJdC8NUxRUz6LqpT0T/vA6BWkCFDbCXZcyL5clxTza0BKnAdoGYZ2S2WJBHDA5KqoQDbk5t8BTjBCNerGgLj8yGL8vH0SRtq7cfsHzDEyKo3rUgwENVyE6EXx6JqTSf9/ZBQWOvKkoAf4OMFHGPZ42qXiTIn0XYzpKeBp+vune9nGMgDALrqH1zktzhGQ+Pz7iPwbnUh5f56BM
 Qnf/vPKY
 6exuJAVC+4XgY5TNXWgw6HX5JRwLUaxTcrLO8K1KuYl0EzydhIjWXdatk5i3Ow/kATlScUC9CKwDlZpI5rBdFa1Ifel35gP3x14P9E53kArF4j8z/EzxJAB4Cvjyftk+o4HsZYKrSbL+JfCGw9C7LWN8LOcAjyef6cLmVD046nXJR+HCGTVi0eUhTNEHtKqyHEz05Pv2LpCQ6CONJgwXXhPFqkGvYgeThVP9BZ336EIoLU4qn3t1nvwCHiEffll6aNXPWZ5IqEdt4kouIqcBymXzgGh2eZvDx2Q++WNJopeFCevjDgQ0X/B/e5GF6DGf4YkwHQiIpbc+VeZzIwtptqG/c7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 8:00=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev> =
wrote:
>
>
>
> On 9/9/2026 2:40 PM, Barry Song wrote:
> > On Mon, Sep 7, 2026 at 12:25=E2=80=AFPM Ridong Chen <ridong.chen@linux.=
dev> wrote:
> >>
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> MGLRU's scan_folios() and evict_folios() emit the classic-LRU
> >> tracepoints trace_mm_vmscan_lru_isolate() and
> >> trace_mm_vmscan_lru_shrink_inactive(). Those predate MGLRU and are
> >> indistinguishable from the classic-LRU path: they carry no generation,
> >> sequence, memcg or swappiness context, so a trace of an MGLRU run cann=
ot
> >> tell which memcg a given scan/evict belongs to, nor how far reclaim ha=
s
> >> progressed through the generations.
> >>
> >> Add mm_mglru_isolate_folios, emitted once per isolate_folios() call wi=
th
> >> the memcg id, the type actually scanned, the effective swappiness, the
> >> scanned/isolated counts, and the anon/file min_seq and max_seq. The
> >> min_seq/max_seq triplet ties each isolation to the generation layout i=
t
> >> ran against, which the classic-LRU tracepoints cannot express.
> >>
> >> This is emitted at the isolate_folios() layer, which is MGLRU-specific
> >> and has no classic-LRU counterpart, so it neither changes nor duplicat=
es
> >> the existing scan/evict tracepoints.
> >>
> >
> > I have no objection to MGLRU having some tracepoints. However, one
> > major concern is that the code is changing rapidly, so the tracepoints
> > may not be stable. We would need to maintain them as the code evolves.
> >
>
> Indeed. GEN-LRU has been available for several years now, and many vendor=
s are
> already using it, so adding tracepoints is a necessary step.
>
> >> Assisted-by: Claude:claude-opus-4-8
> >> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >> ---
> >>   include/trace/events/vmscan.h | 47 +++++++++++++++++++++++++++++++++=
++
> >>   mm/vmscan.c                   |  9 ++++++-
> >>   2 files changed, 55 insertions(+), 1 deletion(-)
> >>
> > [...]
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 8409ea4bbf37..771fe6827939 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> > [...]
> >> @@ -4876,6 +4877,12 @@ static int isolate_folios(unsigned long nr_to_s=
can, struct lruvec *lruvec,
> >>                  goto retry;
> >>          }
> >>
> >> +done:
> >> +       trace_mm_mglru_isolate_folios(mem_cgroup_id(lruvec_memcg(lruve=
c)),
> >> +                                     type, swappiness, total_scanned,=
 *isolated,
> >> +                                     lrugen->min_seq[LRU_GEN_ANON],
> >> +                                     lrugen->min_seq[LRU_GEN_FILE],
> >> +                                     lrugen->max_seq);
> >
> > Maybe `scan_folios()` would be a better place for this, as it can more
> > directly reflect what we're doing for each type.
> >
>
> scan_folios() already contains the trace_mm_vmscan_lru_isolate
> tracepoint(traditional tracepoint), but it lacks any GEN-LRU-specific
> information. Adding another tracepoint there would be redundant. Therefor=
e, I
> placed the new tracepoint in isolate_folios(), where it can capture GEN-L=
RU's
> specific details. Additionally, it can indicate whether a fallback to the=
 other
> type has occurred.

if `trace_mm_vmscan_lru_isolate` is located in `scan_folios()`, that
would be strong evidence that `scan_folios()` is a better place for
adding a new tracepoint for LRU gen.

There is no need to avoid this location just because we already have a
tracepoint here. In fact, I think this is evidence that it is a better
place, not the opposite.

BTW, `isolate_folios()` might be deleted soon, depending on how we
improve MGLRU and on some ongoing work from Kairui. But `scan_folios()`
should be long-lived, as we need to scan folios in any case. Therefore,
adding tracepoints to `isolate_folios()` doesn't seem to be related to
the stable ABI concern mentioned in your cover letter.

Best Regards
Barry

