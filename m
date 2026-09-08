Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CCE4C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C90D6B0098; Tue,  8 Sep 2026 04:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0E46B0099; Tue,  8 Sep 2026 04:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9796B009B; Tue,  8 Sep 2026 04:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6E916B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:23:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39CEC140448
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:23:44 +0000 (UTC)
X-FDA: 85189906368.12.B3DE2FE
Received: from mta0.migadu.com (out-137.mta0.migadu.com [91.218.175.137])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3A0854000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:23:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fgmBBoy2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788855822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SABSe6rOV+QtbFiRX1AQqZaCJbEvBGQSLmwzJIFmAM=;
	b=ArWjh69XeqRmkKISL94grkOgfd0DDEkV7JLJlvzLQJB0FzUnJbA9/3MpUxpYFZWDCZL5CX
	mtjIzv8c1mxn8JNcjPTnW3LaSxjYyeVGkQv7WYQ6SEuduzyn3Nz9G8pt1r3EENAOezqzfn
	6XWIW6a7xMQhIfNTYSI1KOPZBaZBtAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788855822;
	b=7qb/9Mh807+R0dC6IEfSS5Mm4VMNHeTepYaNlv16U3lqidTcLY2N+YOxdS0kFgvaRskCHp
	Iv/WC5s4Np6SIF3zcBePmB0PFzK1dBMOCeYQIIl2fjwRLcyzrd1knhA3EiDqHnZOcB0QpV
	H/n4TP2BQgGEtFO6CorUzdl34Hdjhcg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fgmBBoy2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XMTIRxiwfQqzh0MfBQr/FOHrV2r/u3kqI0wioYrdBLk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788855820; v=1; x=1789460620;
 b=fgmBBoy24jouHn4NGx3Y/QVZrrQDsJ5nDOTIFF9nEgJa6mkY1XtZAoGGsWeaWr1E0+UWp0/z
 awUKW4EJB7VTb5z4VcPf761x9edOJHc5bdMtCHVgkklRVuXfoMipt256vx4ztNLwRirFbGhKnG+
 stoyuKdooZ0cwc5R3wSym6pw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 99ae5adff9099bc7;
	Tue, 08 Sep 2026 08:23:40 +0000
X-Mizu-Trace-ID: 99ae5adff9099bc7
X-Migadu-Flow: FLOW_OUT
Date: Tue, 8 Sep 2026 16:23:32 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
	ljs@kernel.org, ridong.chen@linux.dev, hebaoquan@kylinos.cn,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected
 folios
Message-ID: <ap_GBGDHkEzZ1Osq@fedora>
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
 <ap9zPPughaSlfXM2@fedora>
 <CAGsJ_4wn5ArqhG9w7gJY7X4G+Lg6=1teCb70dzPdN0k+5H8MbQ@mail.gmail.com>
 <67d9bbcf-2991-4867-8afb-14bad1cebf8d@linux.alibaba.com>
 <31494361-406e-4874-8a2c-2c6f5cee5321@linux.alibaba.com>
 <ap-yQOH0pni-mfdf@fedora>
 <ccb8e121-bf5b-4bb4-a9de-fb5290998ddd@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccb8e121-bf5b-4bb4-a9de-fb5290998ddd@linux.alibaba.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A0854000D
X-Stat-Signature: y5xj81qgnkx4qsquscwepooy9wcz3k8b
X-Rspam-User: 
X-HE-Tag: 1788855821-829284
X-HE-Meta: U2FsdGVkX18DoYaoxgRiv1S2Dio/7fkkpcmXv8U7ggBGAzzSwE4fw95FNmqTO1pp2cbhPCHMVf4eCicwMGweGO9IK8N3S3G0DvrdLhipww+NSGQeAlmeEQ1spX7W43NgVCsCtioSVIWxJkitZGAa/AfbNuc4yT+uEw5zuX8XkgNlGlZMOWfbJu1Q8XY9LoIaW5QzwXJeNuKsrCmhg8A3NiAVmf1q/hsDJaOzgDoxGW+SSooh+plaaO26q7QgTWKu5/LpMsyHa2xgRbPq8F4Trlp+aojaN66gcJrjJbmFhhAc20sDwdlc43FHtmZqiQFYt8rvXHYPcdaYaVMvl5tR3QcCYfrI+Z9qGr2nGur3wfPulq868csofDLmShkaJErJ9yYSgbsr/srKu6n/Z3N+BI4Jx6vad8Xv/S5Cdxk1MF8T8UswlZDSjLXHfyJLnn4bCWEZFLpVQIdWZbWBEsN/++7wQ86OHl5ahUfrGXfA2p4cAfU3mcxpkZ9KaQY3TT7S8DQsIPKGue/FiVcf7E0mBvp/4vMo2uEIb7USLt7aQg9khRWP/ksQ8yE2CKGYVEc1BkpZ7HiJ6Np5JB0qNMQLeRQsAKMOIxM7ZIRItmkACX0Uix2pAmFSEgch+jccqe45oqFJQ5bg6kfBWhuhxaEynLitVQ0hvcVTiHks0aejETxB3QG3i/5f65l9rbiAPRMsElf6XL0I/4jWjC/8JAmLPw/UIfa0W400kPKW/CW1nR6++Ja6p9CnETnQoultwIK8w3l8zdT9LFoRhqUd2D0tH8n68KJnOCuOErWEleji3A2lOH9NQMecCk8S/1QKHfeEGuZNzCcZqJ1SyI1RjOZKYfudsHAXniBmedyu0bsTDvJlJQ8IKl+b88Nj6bAibBauG7axpnPc9PnwPOLMkjTBOQ1lZxTvv8CDHcRX60glAg2RWOTOd57ixLIkS67AQ/b2metDikBYIc35uxTE2Ru
 4w/naY/s
 aKd20jvGNQr3YS1gQx39dyHCj0Htc/eKUkvG/fiZve90EZXoim36RrxKlwNJwfnAzjdUzwAmikkTrefgSJwlLTZoncIEDP/SSn5gRjUzjWPFJdoiK063+RofQT3KNXO7NvaPL8O5zYWAWk1w7nT/c5FyQMBbkyxNzTthvHnrLuBGL8OCy/P2fUxIDs+9cn7zdZAjwiNcth130vvuHMaujAl5kb/ivj5Z9vpRNzMFkb00IHUvGdyR5LQh3rupUlkhwjNcqWbW743RALIHlZxBsuoRskUgbECA9vJpUDWcP5r++SZRQiqgkeIkPWbvB6AIcflPt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/08/26 at 03:53pm, Baolin Wang wrote:
> 
> 
> On 9/8/26 2:59 PM, Baoquan He wrote:
> > On 09/08/26 at 12:01pm, Baolin Wang wrote:
> > > 
> > > 
> > > On 9/8/26 11:03 AM, Baolin Wang wrote:
> > > > 
> > > > 
> > > > On 9/8/26 10:34 AM, Barry Song wrote:
> > > > > On Tue, Sep 8, 2026 at 10:30 AM Baoquan He <baoquan.he@linux.dev> wrote:
> > > > > > 
> > > > > > Hi Baolin,
> > > > > > 
> > > > > > On 09/07/26 at 11:25am, Baolin Wang wrote:
> > > > > > ......snip...
> > > > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > > > index 40d3f1b48a74..42c0a09938ab 100644
> > > > > > > --- a/mm/vmscan.c
> > > > > > > +++ b/mm/vmscan.c
> > > > > > 
> > > > > > Well, this seems to be based on Andrew's mm-new branch. I usually track
> > > > > > mm-unstable branch. Maybe the subject should be marked as below?
> > > > > > [PATCH mm-new] mm: mglru: clear the reference counter for rejected
> > > > 
> > > > ACK.
> > > > 
> > > > > > 
> > > > > > > @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned
> > > > > > > long nr_to_scan, struct lruvec *lruvec,
> > > > > > >                 }
> > > > > > > 
> > > > > > >                 /* don't add rejected folios to the oldest generation */
> > > > > > > -             if (lru_gen_folio_seq(lruvec, folio, false) ==
> > > > > > > min_seq[type]) {
> > > > > > > -                     folio_set_lru_refs(folio, 0);
> > > > > > > +             if (lru_gen_folio_seq(lruvec, folio, false) ==
> > > > > > > min_seq[type])
> > > > > > >                         folio_set_active(folio);
> > > > > > > -             }
> > > > > > > +
> > > > > > > +             /* See the comments on LRU_REFS_FLAGS */
> > > > > > > +             folio_set_lru_refs(folio, 0);
> > > > > > 
> > > > > > This looks like a great catch, while the code change could bring issue.
> > > > > > 
> > > > > > Because move_folios_to_lru() relies on folios' flags to decide their new
> > > > > > generation. You just cleared it before move_folios_to_lru(). This is no
> > > > > > problem for rejected folios that are determined to be put into the
> > > > > > oldest generation. But for those rejected folios that are determined to
> > > > > > be promoted, this could be wrong. E.g currently gen window is 4, and a
> > > > > > folio is referenced, lru_gen_folio_seq() decides its new gen as 1, which
> > > > > > is the 2nd oldest generation. While folio_set_lru_refs(folio, 0) clear
> > > > > > referenced bit, this causes it being put into the oldest generation in
> > > > > > move_folios_to_lru(), this is not expected.
> > > > 
> > > > Yes. As I discussed with Barry earlier, lru_gen_folio_seq() also needs
> > > > to be reconsidered regarding whether it should rely on PG_referenced
> > > > [1].
> > > > 
> > > > For commit 6cbdd9726fb5, we didn't discuss the impact on rejected folios
> > > > either. Before commit 6cbdd9726fb5, if rejected folios did not have
> > > > PG_active set by shrink_folio_list(), evict_folios() would set PG_active
> > > > on these rejected folios.
> > > > 
> > > > [1] https://lore.kernel.org/linux-mm/20260901220430.79810-1-
> > > > baohua@kernel.org/
> > > > 
> > > > > The original code looks quite weird. It even prioritizes folios
> > > > > that won't be promoted by `PG_active`. Do we need to change all
> > > > > the cases just to call `PG_active`?
> > 
> > I would agree if we can. While I have one concern. A rejected folio that
> > should have gone into the oldest generation is now being promoted to the
> > 2nd newest generation. In the original code, referenced folio is only
> > being promoted to the next gen. I even think this is not a bug, but Yu
> 
> That's not quite true. Before commit 6cbdd9726fb5, a rejected referenced
> folio was also put back to the 2nd youngest gen.

OK, I didn't follow your earlier discussion, I need take some time to
fully understand that commit and the patch thread from Ehab.

> 
> > Zhao intentionally did it: the coldest folio is moved to 2nd newest gen,
> > referenced folio (hot folio) is moved to new gen but carries the referenced
> > bit. Both of them seems to be treated somewhat equally.
> > 
> > To me, I would rather move both of them to the next gen, while keep their
> > refs untouched.
> 
> IMHO, I strongly recommend not doing this, and that's exactly the motivation
> behind my patch. Because this is also being treated as a promotion, it
> should behave like folio_inc_gen() or folio_update_gen() and clear the refs
> after promotion. I think this is a fundamental principle of promotion.
> Otherwise, ref-based promotion is already completely broken.

OK, it makes sense to me to make principle of promotion strictly applied
no efficiency degradation involved.

> 
> Next, I also plan to clean up refs in lru_gen_set_refs() as discussed with
> Barry.

Looks forward to seeing that. By the way, your discussion with Baryr is
private or in public list, do you have pointer if public? Thanks.

> 
> > > > Yes. Regarding this concern, I plan to change back to the original
> > > > behavior:
> > > > 
> > > >       /* See the comments on LRU_REFS_FLAGS */
> > > >       folio_set_lru_refs(folio, 0);
> > > > 
> > > >       /* don't add rejected folios to the oldest generation */
> > > >       if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
> > > >           folio_set_active(folio);
> > > > 
> > > > What do you think?
> > > 
> > > Just FYI, after above changes, the performance improvement on zram is no
> > > longer obvious either. I think this also answers Kairui's earlier question
> > > about why I saw a performance improvement (which seems related to commit
> > > 6cbdd9726fb5). Also, there is no obvious performance regression either.
> > 
> > Hi Baolin,
> > 
> > Not sure if it's convenient to do a little more testing in your side.
> > E.g rejected folios are moved to next gen, but not clearing their flags.
> 
> I'm not sure what you mean by "next gen" here. If you mean the 2nd oldest
> gen, I actually tested that too, that is, clearing refs after
> move_folios_to_lru(), and there wasn't any noticeable performance impact
> either (but the code was a bit hacky, so I didn't go with this approach).

Yeah, I meant the 2nd oldest gen, while what I am curious about is moving
them into 2nd oldest gen but not clearing refs. Clearly it's conflicting
with your plan. Anyway, it's just a brain store idea, please forget it.
Thanks for the sharing and detailed explanation.

> 
> > Then we can at least know which one is more efficient on yout testing
> > platform.
> > 
> > coldest folio      referenced folio
> > ---------------------------------------------
> > max_gen -1         next gen + referenced kept
> > max_gen -1         max_gen -1
> > next_gen           next gen + referenced kept
> > 
> > Thanks
> > Baoquan
> 

