Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A80CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015E16B00AE; Mon, 19 Oct 2026 01:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08FB6B013A; Mon, 19 Oct 2026 01:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7476B013B; Mon, 19 Oct 2026 01:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB5266B00AE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:56:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37FB31405B4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:56:09 +0000 (UTC)
X-FDA: 85338315258.15.9FC4AB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B36840006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:56:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WSlGexRR;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792389367;
	b=z1SasjsitloedJbn//fTYg5pgd3/SxZ0cqnffW3R5ByXt0Yw2+4QmD6J6A6foZ0YOo5Naj
	o/1mHkbdIGvDKhV3DWCWD3ve1MTVEghRCEPwl4WkzESmJ6/7kQdiOcL/v5HoG7/xRzh4la
	SB9+HoUx6lW3z8Re2V2XZVgmM7HqteA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WSlGexRR;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792389367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1R/rxlJHtAIixzoKXTCBUmA5XYASXYQvG6Yh/D5vUc=;
	b=uUnpR9qQGTmJaY0VE3K5jjZ4US+Mw9a5DGVH0iNETyI+Bf/7P4GjuN21oHK+ujIQMjR7F3
	BEkWMrouvgVLBn6cJ+Uw70jAuE/BhxLtfgXsjPlZp6Q3Rxos5r54/KyJKf7uCxuBd7rVAP
	Pygj2lxFKp2/8U6Gi+4opeFiaHybFUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 936A24477C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0441F000CD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792389365;
	bh=V1R/rxlJHtAIixzoKXTCBUmA5XYASXYQvG6Yh/D5vUc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WSlGexRRcveL3gPe8o8sNXcYcFIiLceom6L9+HzV8kU9geaAB8mZedMyFP9pUtlwF
	 V+vnhTt4gY5f+aR4Akmzo8RiAceKfB2Ollc/k4U7sBYt1tL8vaGTSmmSXevkX8uWJ5
	 LgrUvQ3Ub8V8ox+Jl9H6+jFmPOUXv2vEPvm7yR31LYBbjZeKn6zdvhkH247B4uZ6V/
	 igDLz79prmJHK5KBup7kAOLgTmu7LxbBiQwPQGYVfh2sfrZMibkZbwNaJbGMw8qS6S
	 6tbO3/9022qDbPcKwxWW8qCbVVNdDI8RcrQJMUzXq+aH+yVIb3KHO8SU5FX7o2zMKm
	 EkjjlJVpgnP0g==
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5364648ae07so18436471cf.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:56:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy9yK3NljWV03WaHAWiP5T4Bv/5kOU9hD+PfBDSVB/mjoHVl2UeecRK0m10tEQiNLiK0ZekKfDsPA==@kvack.org
X-Gm-Message-State: AFq9FYIKXkk89rU91bXcyvQHIFtRmsMid6rpc9HyznbQJh4rL5R1K2hJ
	HHQnDyYiQAKWeOVpGxsxhs4VlOTSwtYiyVFIDq1+Mu9GD2TT7ugiEeqqag1a4DSSWGZT8tS83hB
	IBxjjU5wOmsoIrazm+UmRk2LFkHyKEzI=
X-Received: by 2002:a05:620a:28c6:b0:93f:3565:813 with SMTP id
 af79cd13be357-93f3565089bmr678706685a.9.1792389364634; Sun, 18 Oct 2026
 22:56:04 -0700 (PDT)
MIME-Version: 1.0
References: <20261017004555.2890038-1-joannelkoong@gmail.com> <19d5b7cc-782f-44b1-8ec9-a1764484f10f@linux.dev>
In-Reply-To: <19d5b7cc-782f-44b1-8ec9-a1764484f10f@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 19 Oct 2026 13:55:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yME1gdFCq4jXCK7tYiQKiV-CsRMLM7vz9L_69OkMaZ0w@mail.gmail.com>
X-Gm-Features: AclHuK_JiHk60NrX7-Usm3115HOQ01kuH7Otr6mcrw2Y29QUJab0XSsc9l_Jpxk
Message-ID: <CAGsJ_4yME1gdFCq4jXCK7tYiQKiV-CsRMLM7vz9L_69OkMaZ0w@mail.gmail.com>
Subject: Re: [PATCH v2] mm: unqueue deferred split folios outside the lruvec lock
To: Lance Yang <lance.yang@linux.dev>
Cc: Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B36840006
X-Rspam-User: 
X-Stat-Signature: 5668z5uj55gkdk97ixf1dbnsegoghurr
X-HE-Tag: 1792389367-476400
X-HE-Meta: U2FsdGVkX1+ihlr8sCea42B63FYDpVWeRwVKbeOwLfTLruiEdY8Pap0ANBVcXrgh40PWstUsGblqAMRK+/JdJQWtvLzoRSuznPlpxx25CDfHvs4/Q1wh9jM7kJ7ronULztT8yhmQuS7eCF1rusYyRJMLwJ+sMEE+YtP4fluIEFhHWL/aJCEwJzdA8gIGO+HpXQbiPQauB9aS2N8D+E8Slu211w/gheZC1eEFZzB2Ixga2RvYibOmeaEhYo+/9jiqgHCw0AmnU+jdDDvc0jO+z39BhRCVapamq4w3wjB+haH3tuuEcHv5GPWliU0OQzBLAD8N1OSSPjMAukraa1aUfDJmCTmBHfbq2lAGu0sO5tEmIc7B1czgxmXCNQgJ6ZWG2+n/LHXlILWbgx41GaGt7Whf1JFqEaHejAlkt7pL4oxJ+vEMACnQOSdt7BN7tPMsWipa8wiTuhw2z8RjQ6RN6wXncErQn2Rp47GAWro+GEWSyW6mLXlbmN1uDmae1l9CjcdMQCwj9ah1TuGFZaA4znKAUxjKoX0tQThVJqKVXcNiEB3gPXQaeBNo14zQmO1rePkkimj9haoegPWNos9rZRnLDIHddoDyupkkKFR+MfZWNg0ISeKEDvQ/PnPPSxJ72B+ZUknDRKLHmBmFiA/Vy7CGZnb9zfj7DnmRmEUc5w8bLzkwUhOwz84NilYrQocGIwYISYV5gmaHgc/jPNWNjXtFLrjZeGUnp1q9pVXwB+2wno5ZqSd1CU0qw4wIIrxvhKikD5dLWekTowp04yYrb+SFo4X5oc7rrh1KckxfDfCc8tkSZ1UhoOSjmxPcaWqRCoKtb8y2QW0hJ3N5xuuYw2LjAAdFiNu+ISBmAbuDx3nlI1os5Ti7w0Ofe4Efs0bfq3Qa7kt+YJG1+bCnvTMmstS5TJHNaG0xYRu9SnAjwMmQ5P3kOrgpLRBPZx8Aao2D+p3mdLexSlUVwTh3Hwa
 m4wz5lHb
 DlvQr0qp+S2WRfg7HhRJ8ZFnp3MEL4j/+U2jegGESygmlLw07G2JrsDYkMYPJlAOoPg/AlY01SpxyeU7Hb/xXg0pgdOGv1C7/yAU06D1IrEeLvisqeta7a5Ivwo3Mo4akhB4pZpKHbL1j2LJIWcjoiha0jEi3P38tJwcFqJiCQBx31nmTp5wFvhVlJeqzGzHjsdXW5c27xO/ZF23qkvy2uvqJqWdnDY9mN/fXyu7qVMC1w3oeg8xIVBj7XFn27Fs7YzThpCmPGhCY/locNDjGaYB2fr/gFYPiCjeiHMBrZb9XsRAmojR0qWXPxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 1:38=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
>
>
> On 2026/10/17 08:45, Joanne Koong wrote:
> > move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
> > folio_unqueue_deferred_split() on folios where the refcount has dropped
> > to zero. In these paths, folio_unqueue_deferred_split() is called with
> > the lruvec lock often held (move_folios_to_lru() always holds it and
> > folio_batch_move_lru()/folios_put_refs() usually hold it for every foli=
o
> > in the batch except the first). However, it's not needed to hold the
> > lruvec lock.
> >
> > The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> > the deferred split queue lives on folio->_deferred_list in
> > deferred_split_lru. The deferred_split_lru is a list_lru with its own
> > per-memcg per-node lock.
> >
> > There are already other existing callers that call
> > folio_unqueue_deferred_split() without holding the lruvec lock (eg
> > __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
> >
> > Add folio_batch_unqueue_deferred_split() and use it in
> > move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
> > unqueue each batch of zero-refcount folios from the deferred split list
> > after the lruvec lock is released and before
> > mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> > critical sections, which run with IRQs disabled and are highly
> > contended.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> > This patch came out of a discussion about splitting underused mTHP foli=
os [1],
> > where queueing small mTHP folios on the deferred split list was found t=
o
> > regress Barry's fault microbenchmark. The cost turned out to be the unq=
ueue
> > running under the lruvec lock rather than contention on the deferred sp=
lit
> > queue itself. Testing this patch on top of the series in [1] with the s=
ame
> > microbenchmark, queueing every 16k folio went from a 15% runtime cost t=
o
> > noise, with lruvec lock wait dropping from 491 seconds to 38 seconds (m=
ost of
> > that contention then moves to the deferred split list_lru lock, but run=
time
> > still drops back to the unqueued baseline).
>
> Looks great :) Could you also keep the benchmark results above the '---'?
> They'd be useful to have in the changelog, along with the test setup.

+1. I guess Joanne didn't include it in the changelog because the benchmark
depends on her patchset, which hasn't been merged into mainline yet. But it
should be fine to include the relevant details in the changelog since there
is already a link to Joanne's patchset.

Joanne, could you also link your patchset and explain which patchset you
used to collect the data?

>
> With that, LGTM!
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

