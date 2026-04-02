Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FCF1112246
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9726B0088; Wed,  1 Apr 2026 20:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A6C6B0089; Wed,  1 Apr 2026 20:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079806B008A; Wed,  1 Apr 2026 20:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3CC76B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:11:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AD8A160244
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:11:45 +0000 (UTC)
X-FDA: 84611687370.23.639C428
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B6B9080008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:11:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dasTAydO;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dasTAydO;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775088703; a=rsa-sha256;
	cv=none;
	b=6DWU5DfZrrxJX7UHHSKNDFGPBs0dyaODBapnAi19SqlKVmeJGT8RFz9sK8wa+OfOvfuCf+
	RNGnNgu6L/TcRRRbAmpZHhuJ91FuK8dxuaM7f8ERQalFdnr2nfHJpSnKZ4KB8HQVkKJrQw
	j7dFZr0scWZp0AZcmurWNCAA818hiSw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775088703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3chbnyH5sBdrZs+s8J7zlSxqF8hLCq4rzHyEyInLHmk=;
	b=fl1seZKJCtDfw6AYrSG7OCiYlxC2FZtUOSC0bv5R89FJ69I2DENTbhywcPj6+vje6Yq4j/
	hm4QnOcbOM828W57z9G+VxmjKWhTcQPLd3qv7fj+p7eb3s88+2KfRiViBvcJ5EQ3Xreo5a
	qS6/Af1jywDHdNyv88jPa+yxK1SWyD4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15E3560120
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA43DC2BCB4
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775088702;
	bh=H5ORe6rReKgq97r/iODnZgZHba2IwZ3RdLCbS1qSkKs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dasTAydOb6qnGQ0J0k+pB20bsXW/tWrNSthh5RrvKoQRRedTKoCTJfzwh7J+Bjs8B
	 UGk493jbkzLno3xENn/0fYv765VKj2CIdKfcu1JQPslTurS+yOM5UJD02CE7L0iq0d
	 1nLnOuIrrUc0vNvpNoHoOpYyM0x+kxRpn9bfJtu5OPKPAAlYHxgpiZTdJLlAyvxuDc
	 00MoFUb5PpZcth2EErqnmmC06LpxZkS7IJG5Vc/2BgUrGMU8sW5nUOF+koNXARas+w
	 jhcXMffeaMQI5fgvxv67M76+LCMK+fQjFxZoJNpztiwBqBMqBrxNTdqXhzvuHXcz74
	 WUad+cwISC7hA==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-89cc71f4311so4444226d6.3
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 17:11:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU0Xde5fh4wrTVR6YTdFA8+3+AZHNnygtjJHEmr/M7GLt0KSOW6sAb0jvsDUSbI9PUwLKkz+eshbg==@kvack.org
X-Gm-Message-State: AOJu0Yzs4SFbhSDVouKomrtGupd8S+VMXxFqvSlRFzYZyG7C8nZ+Lc/S
	/1fIAbFsccbuSPNJYM4SqW6mFVuRpBgS5BxR4JLlzMsIaZV8nyz5KfvoelrtIFwm1X1rPnwQeuq
	rEGeqYfj+8xNBwjxjc2q4dKam+gs8ToE=
X-Received: by 2002:ad4:5ca8:0:b0:899:f845:a29a with SMTP id
 6a1803df08f44-8a43a2774demr88007146d6.41.1775088701985; Wed, 01 Apr 2026
 17:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com> <d77d5c39-a1cb-46e7-b343-3a20ff8caf3b@linux.alibaba.com>
 <acuNtuf-mv3KJJdn@KASONG-MC4>
In-Reply-To: <acuNtuf-mv3KJJdn@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Thu, 2 Apr 2026 08:11:29 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xQvcDf5hTHa3M74R3xgjGRcfEa4-mrrpyLT7yaRZJ-hQ@mail.gmail.com>
X-Gm-Features: AQROBzA4KskciQPu3Bmm8LVLb6JgIf9TeNDm-WR_-PRTRI30A8Fz90PO7UexBU8
Message-ID: <CAGsJ_4xQvcDf5hTHa3M74R3xgjGRcfEa4-mrrpyLT7yaRZJ-hQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback handling
To: Kairui Song <ryncsn@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B6B9080008
X-Stat-Signature: izjjewabe1d45c9azwkrczjc74mi5wtt
X-Rspam-User: 
X-HE-Tag: 1775088703-577488
X-HE-Meta: U2FsdGVkX1//2YRqQ/jOkSH7/dVJL6bwGouPSH2Ev9USpUX9tPP6jKNW/NatYx6dBUC4RFUlB68/xiIgg663jHaRNrKukh73dZCewJGY6sB0/snQRRedqRJ8DH/oosmmob73mBRacvQXe4HwJMuzdZ3i5UkJ3geTkXk45uDTKPc+2SiU236gJvaZ//fqYxJoqz7QhrVR0XcWhhaN0bKDKP96ydk4rJCWBP2ypRuhyJXCzy5AcJ12MMUBbCRXUS7mh4jk8j1NGNyHAfUr+mJCa4V5LlCUjFVM9iQjxWWg5y3CAHHlVHKi9tqTs79TC/F5CG+mk/gEY6Wango8s49fdxtSeQ3zm2qqro+rHzpXnwU2GF3O8Efp6TtKaiS9FiMJhG0j2pLadgaFf6W0JkayWcVwiJWCZKI+E0jKwkrGrF9TRuqW91HZoTBVw4o5sncXOBrZU9mmncR18PDNPrDyoEMGx4Qpn1QQhuzSTbYz9QUFrHYtS63CyPctMBL2ZW4e/smDw/OM2cLoPzeiY/vc7K0WqR11UABBmpnSkecrLBesyuQKanLp7X2mrzuwz/qemyDUpNUR4BpjcpIuEp7jkMVPM1IvL0ksRhDQdaL/PC+U8rRkzdSgREKt2JDtpgT1r94ioEXs2KNwWWusFUC27Kzj/6xeo79qmE/3zbatOnURtVSVDIGAUpI0yOOQcCdOdGcbc1kw6E5Xu/s+/Z9LHctARz8oDSvKFmgZAFo/xbYuxBNLYfO8NCAvqTda4u/oeRMuD4+GEe6aDj0NslgjZQJyaW5lowyKninjkDaaouecAjpz1LmtdWIQJHbRxGrC4uYW11w0ruAwZOs2FNm942pStYnpEndEMMgYIARj6PbuDyqXAVBFSNKsNZwl83bWueKxSo/mlyemjGx3jy7DYfM7RX9jCAGqif0O3wFPTva28XR+tq1T1DzrWQoB4noN9Rtb1Qz10Lt1d3fPzS4
 KEwhG9Tj
 By2AMA+8g2RERTyye06KuN8f+ha45CHxRYhcERg/sglj5W4TTxn0c3O4L1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 5:18=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Mar 31, 2026 at 04:42:59PM +0800, Baolin Wang wrote:
> >
> >
> > On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > The current handling of dirty writeback folios is not working well fo=
r
> > > file page heavy workloads: Dirty folios are protected and move to nex=
t
> > > gen upon isolation of getting throttled or reactivation upon pageout
> > > (shrink_folio_list).
> > >
> > > This might help to reduce the LRU lock contention slightly, but as a
> > > result, the ping-pong effect of folios between head and tail of last =
two
> > > gens is serious as the shrinker will run into protected dirty writeba=
ck
> > > folios more frequently compared to activation. The dirty flush wakeup
> > > condition is also much more passive compared to active/inactive LRU.
> > > Active / inactve LRU wakes the flusher if one batch of folios passed =
to
> > > shrink_folio_list is unevictable due to under writeback, but MGLRU
> > > instead has to check this after the whole reclaim loop is done, and t=
hen
> > > count the isolation protection number compared to the total reclaim
> > > number.
> > >
> > > And we previously saw OOM problems with it, too, which were fixed but
> > > still not perfect [1].
> > >
> > > So instead, just drop the special handling for dirty writeback, just
> > > re-activate it like active / inactive LRU. And also move the dirty fl=
ush
> > > wake up check right after shrink_folio_list. This should improve both
> > > throttling and performance.
> > >
> > > Test with YCSB workloadb showed a major performance improvement:
> > >
> > > Before this series:
> > > Throughput(ops/sec): 61642.78008938203
> > > AverageLatency(us):  507.11127774145166
> > > pgpgin 158190589
> > > pgpgout 5880616
> > > workingset_refault 7262988
> > >
> > > After this commit:
> > > Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
> > > AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
> > > pgpgin 101871227                        (-35.6%, lower is better)
> > > pgpgout 5770028
> > > workingset_refault 3418186              (-52.9%, lower is better)
> > >
> > > The refault rate is ~50% lower, and throughput is ~30% higher, which
> > > is a huge gain. We also observed significant performance gain for
> > > other real-world workloads.
> > >
> > > We were concerned that the dirty flush could cause more wear for SSD:
> > > that should not be the problem here, since the wakeup condition is wh=
en
> > > the dirty folios have been pushed to the tail of LRU, which indicates
> > > that memory pressure is so high that writeback is blocking the worklo=
ad
> > > already.
> > >
> > > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > > Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingx=
iangzeng.cas@gmail.com/ [1]
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >   mm/vmscan.c | 57 ++++++++++++++++----------------------------------=
-------
> > >   1 file changed, 16 insertions(+), 41 deletions(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 8de5c8d5849e..17b5318fad39 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4583,7 +4583,6 @@ static bool sort_folio(struct lruvec *lruvec, s=
truct folio *folio, struct scan_c
> > >                    int tier_idx)
> > >   {
> > >     bool success;
> > > -   bool dirty, writeback;
> > >     int gen =3D folio_lru_gen(folio);
> > >     int type =3D folio_is_file_lru(folio);
> > >     int zone =3D folio_zonenum(folio);
> > > @@ -4633,21 +4632,6 @@ static bool sort_folio(struct lruvec *lruvec, =
struct folio *folio, struct scan_c
> > >             return true;
> > >     }
> > > -   dirty =3D folio_test_dirty(folio);
> > > -   writeback =3D folio_test_writeback(folio);
> > > -   if (type =3D=3D LRU_GEN_FILE && dirty) {
> > > -           sc->nr.file_taken +=3D delta;
> > > -           if (!writeback)
> > > -                   sc->nr.unqueued_dirty +=3D delta;
> > > -   }
> > > -
> > > -   /* waiting for writeback */
> > > -   if (writeback || (type =3D=3D LRU_GEN_FILE && dirty)) {
> > > -           gen =3D folio_inc_gen(lruvec, folio, true);
> > > -           list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> > > -           return true;
> > > -   }
> >
> > I'm a bit concerned about the handling of dirty folios.
> >
> > In the original logic, if we encounter a dirty folio, we increment its
> > generation counter by 1 and move it to the *second oldest generation*.
> >
> > However, with your patch, shrink_folio_list() will activate the dirty f=
olio
> > by calling folio_set_active(). Then, evict_folios() -> move_folios_to_l=
ru()
> > will put the dirty folio back into the MGLRU list.
> >
> > But because the folio_test_active() is true for this dirty folio, the d=
irty
> > folio will now be placed into the *second youngest generation* (see
> > lru_gen_folio_seq()).
>
> Yeah, and that's exactly what we want. Or else, these folios will
> stay at oldest gen, following scan will keep seeing them and hence
> keep bouncing these folios again and again to a younger gen since
> they are not reclaimable.
>
> The writeback callback (folio_rotate_reclaimable) will move them
> back to tail once they are actually reclaimable. So we are not
> losing any ability to reclaim them. Am I missing anything?
>

This makes sense to me. As long as folio_rotate_reclaimable()
exists, we can move those folios back to the tail once they are
clean and ready for reclaim.

This reminds me of Ridong's patch, which tried to emulate MGLRU's
behavior by 'rotating' folios whose IO completed during isolate,
and thus missed folio_rotate_reclaimable() in the active/inactive
LRUs[1]. Not sure if that patch has managed to land since v7.

                /* retry folios that may have missed
folio_rotate_reclaimable() */
                if (!skip_retry && !folio_test_active(folio) &&
!folio_mapped(folio) &&
                    !folio_test_dirty(folio) && !folio_test_writeback(folio=
)) {
                        list_move(&folio->lru, &clean);
                        continue;
                }

[1] https://lore.kernel.org/linux-mm/20250111091504.1363075-1-chenridong@hu=
aweicloud.com/

Best Regards
Barry

