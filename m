Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB0511091923
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBBA6B0509; Thu, 19 Mar 2026 17:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3796B050D; Thu, 19 Mar 2026 17:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E91B6B050F; Thu, 19 Mar 2026 17:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F24836B0509
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:05:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9598BC2525
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:05:19 +0000 (UTC)
X-FDA: 84564043158.24.64F6BA3
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91A56C0002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:05:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Z/ZPAWUm";
	spf=pass (imf22.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773954317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOGqCH0/gok1apUNLDgL0tNl7DxQ75ThWbxAiJrASSc=;
	b=ETwCygqkNFDh9DNUvHWyVC/oI/Mf9In5cAb5bLp1CRU+bkr4v7Q6GdCgoITf8KMGtbMMOy
	5icp/ITzQOiGGV38j3wGvT1sv4ASRpx9BhoL48XDY7fBJbvsGTkhiL8IsNqK6HZo4spCar
	p21O1GRL80odOhd61gU6K3y5Dc1O4JI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Z/ZPAWUm";
	spf=pass (imf22.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773954317; a=rsa-sha256;
	cv=pass;
	b=VryGMJB/9JLXG8kq/d/UXrxS7aP2dRB4Ev8FyUveDiW0P36Ln3UA3/2mho2vpIZESndME1
	CegQyDkKIkrs1Twf0eCWWdLC7ofRZ/6PaG5Ncyz9KCSM63hjiOF9HrqOxSuQt6I0kcwlh2
	CbwCYfM/bSvXGlB1jpxJpS/nhjXo5j0=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1270f10a774so1062c88.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:05:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773954316; cv=none;
        d=google.com; s=arc-20240605;
        b=AInReakDMelAq2r7kfBOt9Fz2ivjEMJcITx6IZLUqYKwvzilMpLfr9uOeGh/jIDr3I
         I1PzidHCp5qhVEyxfDbW2M+d0NW2G2b4Qf+IGjl3SIgvsCWf+OJqev2eNbd4WsTaC5T0
         6VQnf8MSYi5uAw9mfOXulLUpllQicC8wN6yqN/tumLhrD40pM+DvNR4XKPB/OHxt4NYm
         emsNgux0cs5JkRwrXJ6ahQDC/wVJfj0870nzkj8Gy9ybaWRlJ+dqYDf62SNqsFT3HfZ6
         UykmIwK928iCoMWo0sebA8MJAQ99DDghDuMdx4P7OeScfhG1zIMkG7Hi/dXfDlzbpfLo
         mSSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WOGqCH0/gok1apUNLDgL0tNl7DxQ75ThWbxAiJrASSc=;
        fh=Ixs8AEw4xT/zVsoiqDOHUAM5SwqONiCu0tBNeTKtUzs=;
        b=W9nnvpfPCfl2GNnoQCQkozeVsOtQCpdT+YDZZtAWbbwci+ob8UQ5TmF7nhCYbWw8lr
         hIkg67EKuWpoZ9o6y7Q4urHx9/P0gHDcUbWeJERTev+dAMEZLDIHn2IHhxtlJ6gWMnxx
         FHMlI0JVSfpz0tYyXFT15qLAOZdzD1cP39y7cK2hzYDGHSqMhZ+CCi2TusH/NnhkBdK2
         EPRgqR9lh1maqAwkrjwTwSzU5yzhQm4YjDzm8JSUboTdMU/v7jnvi+3vBuxd0UEcWsgu
         Eo9MH3KPx/PkXef3qtGU2bIz7mygCNnmq6t4s7dkD2sQ+PScMxoX3AfMMEL9P4i28APD
         O3fA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773954316; x=1774559116; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOGqCH0/gok1apUNLDgL0tNl7DxQ75ThWbxAiJrASSc=;
        b=Z/ZPAWUmsVx6Ivenn/FH+2oNxJa7hoE6/7lkJWXquMlURVjaFcZcDjhZRpHwRNyul/
         TUMkiR+QZFi6yGRLhimWDrB3XSCPBBx3CORJy8+aTnbjobI9bUyHdOUcjl7TmWTL4mmJ
         mQZNLOXuiLZmu6vCIyk2D7hH6CIhmrimbVj/Rnr/h8LmhkP3BKT4zCak+pqCMukOWAWx
         ZEyCmnTwAN/9zCyxhYOheYBkenRYWubXbC9bQelAdDuYKkx8j0dWErcTQNZrtT+xt0t/
         d6C54wLCsgpJcczAzgFC+e38z87A8fkFGqXLwM/52d2aEAyVScdxvYOuf0/a22/EO99Z
         xinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773954316; x=1774559116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WOGqCH0/gok1apUNLDgL0tNl7DxQ75ThWbxAiJrASSc=;
        b=UKTBFms/YV3IkXZqpV8kBTmQdpLIA0MGJjpaQEyL18RT2Ea7aK5QIGYa7tNbQVvupW
         ZI7vNxau7BKeAwMUbKhXxXh5Z1+gtN29pgAuZeaF0gDMOOpIGNLh7M87AS/A1xmx87f+
         FSRd1MTMd22tpcINWLXcnaiAMBMs+hhkECK7SeLFDmusfP69/YQc0g/oTSoTwj1YFthS
         ZDRT1ybwMnazlcg3x/FiV7b1nJYshRUyi/R9Om+boJjqMW9LuI8Xi2PN9b249LLbLmhX
         BzjP2OZUqsGTmGXDouASBnGUTqQjCoeNcnn1a1JGuAmG6gdmBIoIzgOdEOpD2z6lsuiY
         GPww==
X-Forwarded-Encrypted: i=1; AJvYcCXlBibjJrIxv40FrNNIwI33z0K4Bs9k0NxK954wLTj6UQW6cordf1GLI8hH+wU+569cd5YDLyS93w==@kvack.org
X-Gm-Message-State: AOJu0Yw5DBIn9mybaEZsf68VkvTBW/kLU5Xnm6KTXvTYp8FJYy2VkgtW
	IQOS7a9oKIX26rZkVme6vfslu2ppsPv7kPk/x0+x5l4FkzXORcCem+0Ji+rWTfkEM1RkTZLX49x
	Suf7+raRdnspfeghWWdZVN/wJ6vetRh3VGy1QrP7P
X-Gm-Gg: ATEYQzxslEFPTfYCFbGKgpnkhjXUhsyF18pKqLBQ7mKZASBY6WyzgXjQt33eds1NzpQ
	uUzReGF+Zmm3briX3ZcSptDZMvt59GCv7QHu7TVW7p6xHEkC0nbyLRkTDHEt7dJKSgw+37sImWk
	BfptQoMmuCXgu+e7u5tTKl/9SqywclVnssBQW3ScFAa1wymCZvlyvxtmMCoBppKU1yfn5zy6nu1
	LtM/xef2VQ/bwBWOCum21NJQE2F/PwKFt2BbCSUQOUkUSwNvHJmIgleD67mZ4SaUocM0MCT5vfm
	cqyIjksA
X-Received: by 2002:a05:7022:e13:b0:119:e56b:c1e3 with SMTP id
 a92af1059eb24-12a7244eedemr42002c88.14.1773954315367; Thu, 19 Mar 2026
 14:05:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260319-b4-switch-mglru-v2-v5-1-8898491e5f17@gmail.com> <CAGsJ_4yY6q_kP74LtKpD=FEWPBH811Ch3EA=v6dxgYfyNtmZyA@mail.gmail.com>
In-Reply-To: <CAGsJ_4yY6q_kP74LtKpD=FEWPBH811Ch3EA=v6dxgYfyNtmZyA@mail.gmail.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Thu, 19 Mar 2026 14:04:38 -0700
X-Gm-Features: AaiRm52UWw7m1EDXzPxjyakiy-n4cnDAgqTNjqp8_9ShZMXbAaepuIdBV1ruVsA
Message-ID: <CAJHvVcjzk9yEzjtpUGnFxYM5YhfRXjgVoe9NiOqdVZsMYYQbPQ@mail.gmail.com>
Subject: Re: [PATCH v5] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Barry Song <21cnbao@gmail.com>
Cc: lenohou@gmail.com, Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 91A56C0002
X-Stat-Signature: bey1qmf4wknimgzpamxzm5p5yyxtb99t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773954317-35880
X-HE-Meta: U2FsdGVkX1+TRnZRcqm0pXF/FwnTJ7JIwz66922Lc2/XH+95YimTVRop0OHEih2kJflRB9480zHRDkHKAc97ZDtOyy93Aszt7f+LEoND6niuGAgBHksbXgiNIj9Q2hCBw/4s6CGjSAOmQa2UJoPYny1aX4s1vavYVmPPEf1cFbGSxzkcRqdeST1dwL0hNqlC/eMe8YcZG+BpG6aEx5sCU1M2vlO7Ndo42iVJmud80pLFp5Oz5h4REwt+knimfxn6WaD4Iys4IJu+ueKn0EOIm/TMZRLvpDLy/iQ92KZPlbjis52b1nI5nCkH4grB6zrdVJUSy9Sp5Xrx+6FcKM/mLoYNtY9KSHJliDySco3Wncr9qKeF4YLlQe4o6DiTIYEKSAoHxWhfzQ90Bgay33hyycKZM5Gl0i9R1i2THa/U/wIJAjqwSEaN2ga4uLm9yD2EpW6L9+uyMqHkgH3zSkof1pwgnpoooAFviznx8z1T/Bxs9dUgt/jPkHgwDLa2cr2Wopz+KjVTK6f5znrzHXJiPJKgVu+EBDdimedVw2aKnMNxuZSvptQRcRBe4hZtHHMvrJmkRWUDNIEtLPUIxf9agwttIwwlGIUwCZzV7hzyyrs/eL55WPtUia5+7WLRWg0QLGqJp+dncBi99IJ8v5PmEzEmsmQhXmh7YPWbKvgK5O6KOG6fzQMNStn3awVEUA3VVKQfBkhvuEw8+AF4k9k44UMYzmCDHjnuTlDM10nr1fMVhv+4NELXpxccir+vwOEZuem/ubprYPNHc6dbUAUVZ+hFHfPpFBX+EZYQg/5JaieINt1EG0gNOd5qIIvqZY3h06G1NqIK7hsRjRJZMoLXCiiPjBsD+jHsicYak/wnTjp44DoiKJi7/vwp6t0+JcRWzGfZEVhcVEBCmu/ScrZfZmG6l+/B5l88DpXe++O8S8M/XQRfNuf9UjDffwystna1vpfjFa57d7oJvGegaqX
 npdVAIiu
 AZ1+wDXWmfxd2ywmA/1SBBqjnL3cNX+ai3KdPJFnuSpY9WzsGDZNjXNkUhtDQeq3ywfwvhncmhrf20RYoYaN0i4D2URBTeD0St0hjzyn1vhcUCMWwJISRz43FPxV8wb8FiwQslqI+VmwMRKYu4f+3Hm3nTOe4siHyJOBcI0Ru1hr3APkSlioBDwT4lB7pQ9VRj1Lq7cCzxuCYm7DDw9LkEifrbL4XlZ/rJoVCmHTVX3Md/gwLz+qhL6w8Iu2nHoBOdUi4hRVyXMfR6BRmWqTBIOz3S36ZqtoYiaA2+Zbf6KpSzSw3Sri+6dhLTD9tQ/WD1aybsAV6KYYbwr7NRe1PxesyGKU7Q2VNHA70JWPhJ1Fj/u76SROarfCEV9uo+xXY6zyudJp+qtaGsdPARmC106N6ptHWSeatD4zAphMxfYHSLuUiI3ijhC1ealsxfWis2NERxYZVfkQiqfYlbforBr5ozf454Z/A8SL1yHHCw6wLz06RxW+xnKBw+Z7avGgJbFKuRvoFuYKvwQnNCR67Hobs+GhcxXM86yUN7o2LQSvoONXpGrYYnFn00qYK/nrf3BAb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks reasonable to me, no objections. Implementation is pretty simple.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

On Thu, Mar 19, 2026 at 1:49=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Thu, Mar 19, 2026 at 11:40=E2=80=AFAM Leno Hou via B4 Relay
> <devnull+lenohou.gmail.com@kernel.org> wrote:
> >
> > From: Leno Hou <lenohou@gmail.com>
> >
> > When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> > condition exists between the state switching and the memory reclaim pat=
h.
> > This can lead to unexpected cgroup OOM kills, even when plenty of
> > reclaimable memory is available.
> >
> > Problem Description
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > The issue arises from a "reclaim vacuum" during the transition.
> >
> > 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
> >    false before the pages are drained from MGLRU lists back to traditio=
nal
> >    LRU lists.
> > 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as fals=
e
> >    and skip the MGLRU path.
> > 3. However, these pages might not have reached the traditional LRU list=
s
> >    yet, or the changes are not yet visible to all CPUs due to a lack
> >    of synchronization.
> > 4. get_scan_count() subsequently finds traditional LRU lists empty,
> >    concludes there is no reclaimable memory, and triggers an OOM kill.
> >
> > A similar race can occur during enablement, where the reclaimer sees th=
e
> > new state but the MGLRU lists haven't been populated via fill_evictable=
()
> > yet.
> >
> > Solution
> > =3D=3D=3D=3D=3D=3D=3D=3D
> > Introduce a 'switching' state (`lru_switch`) to bridge the transition.
> > When transitioning, the system enters this intermediate state where
> > the reclaimer is forced to attempt both MGLRU and traditional reclaim
> > paths sequentially. This ensures that folios remain visible to at least
> > one reclaim mechanism until the transition is fully materialized across
> > all CPUs.
> >
> > Changes
> > =3D=3D=3D=3D=3D=3D=3D
> > v5:
> >  - Rename lru_gen_draining to lru_gen_switching; lru_drain_core to
> >    lru_switch
> >  - Add more documentation for folio_referenced_one
> >  - Keep folio_check_references unchanged
> >
> > v4:
> >  - Fix Sashiko.dev's AI CodeReview comments
> >  - Remove the patch maintain workingset refault context across
> >  - Remove folio_lru_gen(folio) !=3D -1 which involved in v2 patch
> >
> > v3:
> >  - Rebase onto mm-new branch for queue testing
> >  - Don't look around while draining
> >  - Fix Barry Song's comment
> >
> > v2:
> > - Replace with a static branch `lru_drain_core` to track the transition
> >   state.
> > - Ensures all LRU helpers correctly identify page state by checking
> >   folio_lru_gen(folio) !=3D -1 instead of relying solely on global flag=
s.
> > - Maintain workingset refault context across MGLRU state transitions
> > - Fix build error when CONFIG_LRU_GEN is disabled.
> >
> > v1:
> > - Use smp_store_release() and smp_load_acquire() to ensure the visibili=
ty
> >   of 'enabled' and 'draining' flags across CPUs.
> > - Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruve=
c
> >   is in the 'draining' state, the reclaimer will attempt to scan MGLRU
> >   lists first, and then fall through to traditional LRU lists instead
> >   of returning early. This ensures that folios are visible to at least
> >   one reclaim path at any given time.
> >
> > Race & Mitigation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > A race window exists between checking the 'draining' state and performi=
ng
> > the actual list operations. For instance, a reclaimer might observe the
> > draining state as false just before it changes, leading to a suboptimal
> > reclaim path decision.
> >
> > However, this impact is effectively mitigated by the kernel's reclaim
> > retry mechanism (e.g., in do_try_to_free_pages). If a reclaimer pass fa=
ils
> > to find eligible folios due to a state transition race, subsequent retr=
ies
> > in the loop will observe the updated state and correctly direct the sca=
n
> > to the appropriate LRU lists. This ensures the transient inconsistency
> > does not escalate into a terminal OOM kill.
> >
> > This effectively reduce the race window that previously triggered OOMs
> > under high memory pressure.
> >
> > This fix has been verified on v7.0.0-rc1; dynamic toggling of MGLRU
> > functions correctly without triggering unexpected OOM kills.
> >
> > To: Andrew Morton <akpm@linux-foundation.org>
> > To: Axel Rasmussen <axelrasmussen@google.com>
> > To: Yuanchu Xie <yuanchu@google.com>
> > To: Wei Xu <weixugc@google.com>
> > To: Barry Song <21cnbao@gmail.com>
> > To: Jialing Wang <wjl.linux@gmail.com>
> > To: Yafang Shao <laoar.shao@gmail.com>
> > To: Yu Zhao <yuzhao@google.com>
> > To: Kairui Song <ryncsn@gmail.com>
> > To: Bingfang Guo <bfguo@icloud.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Leno Hou <lenohou@gmail.com>
> > ---
> > When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> > condition exists between the state switching and the memory reclaim pat=
h.
> > This can lead to unexpected cgroup OOM kills, even when plenty of
> > reclaimable memory is available.
> >
> > Problem Description
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > The issue arises from a "reclaim vacuum" during the transition.
> >
> > 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
> >    false before the pages are drained from MGLRU lists back to traditio=
nal
> >    LRU lists.
> > 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as fals=
e
> >    and skip the MGLRU path.
> > 3. However, these pages might not have reached the traditional LRU list=
s
> >    yet, or the changes are not yet visible to all CPUs due to a lack
> >    of synchronization.
> > 4. get_scan_count() subsequently finds traditional LRU lists empty,
> >    concludes there is no reclaimable memory, and triggers an OOM kill.
> >
> > A similar race can occur during enablement, where the reclaimer sees th=
e
> > new state but the MGLRU lists haven't been populated via fill_evictable=
()
> > yet.
> >
> > Solution
> > =3D=3D=3D=3D=3D=3D=3D=3D
> > Introduce a 'switching' state (`lru_switch`) to bridge the transition.
> > When transitioning, the system enters this intermediate state where
> > the reclaimer is forced to attempt both MGLRU and traditional reclaim
> > paths sequentially. This ensures that folios remain visible to at least
> > one reclaim mechanism until the transition is fully materialized across
> > all CPUs.
> >
> > Changes
> > =3D=3D=3D=3D=3D=3D=3D
> > v5:
> >  - Rename lru_gen_draining to lru_gen_switching; lru_drain_core to
> >    lru_switch
> >  - Add more documentation for folio_referenced_one
> >  - Keep folio_check_references unchanged
> > v4:
> >  - Fix Sashiko.dev's AI CodeReview comments
> >  - Remove the patch maintain workingset refault context across
> >  - Remove folio_lru_gen(folio) !=3D -1 which involved in v2 patch
> >
> > v3:
> >  - Rebase onto mm-new branch for queue testing
> >  - Don't look around while draining
> >  - Fix Barry Song's comment
> >
> > v2:
> > - Replace with a static branch `lru_drain_core` to track the transition
> >   state.
> > - Ensures all LRU helpers correctly identify page state by checking
> >   folio_lru_gen(folio) !=3D -1 instead of relying solely on global flag=
s.
> > - Maintain workingset refault context across MGLRU state transitions
> > - Fix build error when CONFIG_LRU_GEN is disabled.
> >
> > v1:
> > - Use smp_store_release() and smp_load_acquire() to ensure the visibili=
ty
> >   of 'enabled' and 'draining' flags across CPUs.
> > - Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruve=
c
> >   is in the 'draining' state, the reclaimer will attempt to scan MGLRU
> >   lists first, and then fall through to traditional LRU lists instead
> >   of returning early. This ensures that folios are visible to at least
> >   one reclaim path at any given time.
> >
> > Race & Mitigation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > A race window exists between checking the 'draining' state and performi=
ng
> > the actual list operations. For instance, a reclaimer might observe the
> > draining state as false just before it changes, leading to a suboptimal
> > reclaim path decision.
> >
> > However, this impact is effectively mitigated by the kernel's reclaim
> > retry mechanism (e.g., in do_try_to_free_pages). If a reclaimer pass fa=
ils
> > to find eligible folios due to a state transition race, subsequent retr=
ies
> > in the loop will observe the updated state and correctly direct the sca=
n
> > to the appropriate LRU lists. This ensures the transient inconsistency
> > does not escalate into a terminal OOM kill.
> >
> > This effectively reduce the race window that previously triggered OOMs
> > under high memory pressure.
> >
> > This fix has been verified on v7.0.0-rc1; dynamic toggling of MGLRU
> > functions correctly without triggering unexpected OOM kills.
> >
> > Reproduction
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The issue was consistently reproduced on v6.1.157 and v6.18.3 using a
> > high-pressure memory cgroup (v1) environment.
> >
> > Reproduction steps:
> > 1. Create a 16GB memcg and populate it with 10GB file cache (5GB active=
)
> >    and 8GB active anonymous memory.
> > 2. Toggle MGLRU state while performing new memory allocations to force
> >    direct reclaim.
> >
> > Reproduction script
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > ```bash
> >
> > MGLRU_FILE=3D"/sys/kernel/mm/lru_gen/enabled"
> > CGROUP_PATH=3D"/sys/fs/cgroup/memory/memcg_oom_test"
> >
> > switch_mglru() {
> >     local orig_val=3D$(cat "$MGLRU_FILE")
> >     if [[ "$orig_val" !=3D "0x0000" ]]; then
> >         echo n > "$MGLRU_FILE" &
> >     else
> >         echo y > "$MGLRU_FILE" &
> >     fi
> > }
> >
> > mkdir -p "$CGROUP_PATH"
> > echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in_bytes=
"
> > echo $$ > "$CGROUP_PATH/cgroup.procs"
> >
> > dd if=3D/dev/urandom of=3D/tmp/test_file bs=3D1M count=3D10240
> > dd if=3D/tmp/test_file of=3D/dev/null bs=3D1M # Warm up cache
> >
> > stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
> > sleep 5
> >
> > switch_mglru
> > stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || \
> > echo "OOM Triggered"
> >
> > grep oom_kill "$CGROUP_PATH/memory.oom_control"
> > ```
> > ---
> > Changes in v5:
> > - Rename lru_gen_draining to lru_gen_switching; lru_drain_core to
> >    lru_switch
> > - Add more documentation for folio_referenced_one
> > - Keep folio_check_references unchanged
> > - Link to v4: https://lore.kernel.org/r/20260318-b4-switch-mglru-v2-v4-=
1-1b927c93659d@gmail.com
> >
> > Changes in v4:
> > - Fix Sashiko.dev's AI CodeReview comments
> >   Link: https://sashiko.dev/#/patchset/20260316-b4-switch-mglru-v2-v3-0=
-c846ce9a2321%40gmail.com
> > - Remove the patch maintain workingset refault context across
> > - Remove folio_lru_gen(folio) !=3D -1 which involved in v2 patch
> > - Link to v3: https://lore.kernel.org/r/20260316-b4-switch-mglru-v2-v3-=
0-c846ce9a2321@gmail.com
> > ---
>
> A bit odd=E2=80=94I=E2=80=99ve seen v5, v4, and so on many times;
> at least three times?
>
> I=E2=80=99m starting to suspect my eyes are broken.
>
> I guess we might have a changelog issue here?
> Otherwise,
> Reviewed-by: Barry Song <baohua@kernel.org>
>
> Thanks
> Barry

