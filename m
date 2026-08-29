Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA52C61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 02:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2599D6B008C; Fri, 28 Aug 2026 22:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2586B0092; Fri, 28 Aug 2026 22:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB0A6B0095; Fri, 28 Aug 2026 22:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D856B6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:43:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4770280628
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:43:26 +0000 (UTC)
X-FDA: 85152760812.20.0006703
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B161140004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:43:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IB77iyYK;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787971404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbdBpOVVjZYRbR08NMFYy3lM8LyPK44ueETY+0xcqms=;
	b=FQAfTreWpQ2VgC5WcQm8lJmDQKdQsOh8neeR632z3Yq/ATMMReiLVQk4F7ZRl43Bv/WR2U
	B+CYYr76TRbdVxG3iAse5DATE+aAS3hLeFuWN2c3bAbHLhescPHIewa+wkDE/KqqQHPSH3
	gqOGiEvpWxQsckoTqPOKrO/0sFb17JU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IB77iyYK;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787971404;
	b=swo9bN8fTExrC32W/tW3irVW2jyuTm93zi5K9JFSFqiC/FUzQEVYmO4zkR0pGVYMu3b5xV
	xKcCbA8JUMxdTvyuXiyuu9Adb5EVsTwKm5/r2CSszpKop1Ya9iGJdAJw3cefOpxuo5v3in
	gApcDSWyljbgOAF/+X6IqMbeQeA5QfM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4D8060A62;
	Sat, 29 Aug 2026 02:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D681F000E9;
	Sat, 29 Aug 2026 02:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787971403;
	bh=ZbdBpOVVjZYRbR08NMFYy3lM8LyPK44ueETY+0xcqms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IB77iyYKD6owUschePt6VzG+y2xpsaYWgTocU7aVh4cUSVWCugOJKlVUDpt+eK/Xo
	 uzKreizUhB4hGXW3yK1UUk49uOqddCkT2Ijk4AkbfPr0MqMWTs7b1u7nKZIXlnp5hu
	 P4fGuPEf2sg39h5c7GiBDTCHsDv398Y0Aj2914N4=
Date: Fri, 28 Aug 2026 19:43:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Message-Id: <20260828194322.0556dcbd1c261c23a1f6efec@linux-foundation.org>
In-Reply-To: <apJCb-8RK0azF8_h@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
	<apJCb-8RK0azF8_h@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s5t9bq3zdcwm33mqdqqu1hjfpococtdd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8B161140004
X-Rspam-User: 
X-HE-Tag: 1787971404-242226
X-HE-Meta: U2FsdGVkX18fJ16nQPLWUrSCGEm0leL2v19wt5u+42LXkVnU4q4h+21SJimUOE/QTXI+56BrlS7IfJXsw2lBb9ZFT9F3iCATUmPKHvIg4jzUvWTX7lSdW2N7Qm1tAGoZdxT1rQaqN1yl4pacfEYuFSpvdUZr7cBeQREjS2w8piSvyCP6kbrIYue+g5Vj8Wq88D9gGiSA7ChlxEqaOPIPke029lwAO/K0xqUosPDxCCkJhhtl394RD+6RBraoY/lLNbB6vA1V0KWDRIg3J1ykcu2XgLbqYzRsLJuhr5heONhwnHvuHv7l0CeDiTEey71Kyh+EIf5TwKCLG9F3NDU0sFKDLBUyW4FIBmfRTm/V5+XzIDvHQ/xpgmkl3b9fJGIXwZASB44CeDGqZumkFRHs9RZ68C7vP5gv03Bowx5I8lXDrly7kzXkWmk5ot5FKC9vuBIf8xRSE9L0sdOJ8o58+uoCD+0H8M83l2ME7QeqBBAoOqOpzDHukb5xlpulSyx+NoHCrgManQ9wIqFdsphP+3BCUecyRL63uhuYAsRKo5Unn23yLpaOFf7PZNAClAWG6U+cHqCVQkR3L3QNly4CeM60+nRR0V7xLakqHsUs5bVbogPdl1QSonF4AyYOBEaNsRD3btFj1QYwjSzJV6uKxfaihnVgv4y9HpAl0f0VOZR8BzhWKwzioB05L3In03ZvETFp65ZplTkrd/q/08wo+6YHgOWhk3VORovUhCNuo40N+bEY8QEWgKTfih9kCc9ADLps3CW9XP7SdqvhzVAfQdOkfKC4pLekmfn/3Z7CTTAVb3JEpzLBigcteJ0c6W6A5wbk+Awgm+eQLWyFZFg6ZJDp+/1Zjae2iXMp/CtCXjVTayXPrlZ6bCR/opR1Cf8ROeV41vw6k0d/3ZsrGs3lok0/d4Yzk+607eOLifFFVoI8I7nNAr3KNOsc/nmt2CrqMFeJlBoiT+shDchYhiZ
 3Znq9O03
 ZIlRxxjt3vGi6IH3ROL6zzlLIRjr1Zpr5nCkP7zOStX2bu9vfn1jGSo+kugYi9cQ9cJJeiIAJRD8r2rNyybo+MuLld69zkpGGsayn8fm4RKlZJlbukwB9z17Ry+lmFvn3ZsqFlKtesqXNgiWxUSOUgONi2+qvqV2LlntIiPj27THKvf6JNh/z4i+HCA9MzxDe5lKtGXzGgIOQeEKlxXa7mAgONuP2Yy4X6ln+AHijgecuY0O2SD68cAG3LYHEH6sMMBMntJeqYbCYPuPQvv7CUxVabd++wz8l5YNxyfkzvQ5SJtxnX6fewXmkynTwHQ+B67r3VjdHeLuqKzjQQQgV29i5nKZoYBtYY+KE7eqzuB92S9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 19:23:19 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Tue, Aug 11, 2026 at 01:31:54PM -0700, Shakeel Butt wrote:
> > Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
> > reclaim is the only thing that runs shrink_lruvec() from kswapd with a
> > target memcg set, and thus the only way kswapd can reach
> > lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
> > mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
> > reclaim. Do not reuse for anything else." comment and a priority hack,
> > and it simply never got taught about MGLRU.
> > 
> > Rather than teach it, let's delete it. The v1 soft limit was deprecated
> > in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
> > soft limit"). Nobody has reported depending on it in the ~21 months
> > since, and v2 has covered the same ground for a long time with
> > memory.low and memory.min.
> > 
> > Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]
> 
> Andrew, should I resend this series (without the first patch) or will you pick
> it up?

I added the series, thanks.

The [1/9] has already been queued in mm-hotfixes as a backportable
hotfix.  So I added it as an 8-patch series.  Because of this the cover
letter of that series is now irrelevant, so could you please prepare a
brief replacement for me to paste in?

Sashiko suggests that there's more that can be removed:
	https://sashiko.dev/#/patchset/20260811203203.3456029-1-shakeel.butt@linux.dev

So maybe an 8-patch v2 series is appropriate, your call.

