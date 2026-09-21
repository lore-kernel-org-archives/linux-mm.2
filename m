Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252BAC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DBD36B00B5; Mon, 21 Sep 2026 03:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365686B00E5; Mon, 21 Sep 2026 03:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254E26B00E6; Mon, 21 Sep 2026 03:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF7176B00B5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:01:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 446A4A05A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:14 +0000 (UTC)
X-FDA: 85236872868.07.2DA41BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6241340007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jgejePT5;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789974072;
	b=21LmyKn1S+YczIgmhcgVq4hgkxx0yCFuZr+/LsSUn3bXndxAHhW7C4XPMIzOWagD8FZOL6
	bbwPtOJyyR8r9tV0H1EgEV+8dkoDCf357asUJ71erJE6/n25s+b6t3OvZ1LZ3wOvbhTJDu
	gN/Hc3egTxhhouaeKOXMGZ2sRQD/DEc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jgejePT5;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789974072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCmQuU6gi9OeTPCWb/X0YUvJ4U4go3COykEH9ftpjhg=;
	b=iGwz/WvzDvJZwbOOf5oxS5JfyyCI6QVVdPiqPeKXCZWwdvfysubwWY7e10NyZwotxI8h0D
	8sKjqK5wPG4r/SIuRN7SupG9QsfcOB3oPvhFGEeyy8c4IgmLfwasqWQ1uNRM22gbvlg4EH
	7xKtBDALOXWqlcg5eralBVuDKjJ3DoQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4C1061B6F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624EC1F00899
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789974071;
	bh=RCmQuU6gi9OeTPCWb/X0YUvJ4U4go3COykEH9ftpjhg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jgejePT50hfmk+Ohhiq7ukd0rAyYWB0kk4n9KxexgdjHcYKFm8LRoDism0xMKaH0i
	 gGuIP/HVE3B/WO+DkUQSpYEjtzKXDJ3fyh/6Gj63mYOw8mM4IW88zfQs9+DQ7IqJl8
	 FoT75OdzIO/gENOBT3KUm+hABr/5mZ0h8bgcM+Jcnwogh7Wor5OjoBY+13adH49otr
	 29ZcHFrrPYoU9diw7EXGm8m0qj4s61w2RR23+EH2oupC/S7YYiBY5B9w0jCZ2S5CVu
	 imSKfVb9ZE5ScJtRBza5AjNDV1m7MtpGBYcaBFeHsa9AEt3DcFUYwiv0xzu53V/O+F
	 374LOlpI0KTsw==
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-980b6159d30so473570241.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:01:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwNsXDdQO5l9TDrnU47Ai3jkQG6znCEjxJaNzseenZLZeZAvlzBFT08ATN9RVgCBeJU7fEnkJX5ew==@kvack.org
X-Gm-Message-State: AFuF++kUDslUSbSjBoGyw/1yTkkZ2/i6JK3HjwKKv8vPbRnZF3IL1KZ5
	Pehneh4rFTxqDPkpaqSUuYH1tERb/56fgR5w6c0+3e99HfDdoIYeFJehJzEWyEXetGe/g75rHmc
	YtyycoJ8KCYRHbPb2YA+npyPBUKSqnm4=
X-Received: by 2002:a05:6102:4bc9:b0:7a1:f7d2:e830 with SMTP id
 ada2fe7eead31-7a55a92acf9mr3389421137.16.1789974070653; Mon, 21 Sep 2026
 00:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260920132519.3369946-1-ridong.chen@linux.dev>
In-Reply-To: <20260920132519.3369946-1-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 21 Sep 2026 15:00:59 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xVdNE_Afk8m+-_4UkA-K3VxPhdn43afP2RTxn7LgQJPw@mail.gmail.com>
X-Gm-Features: AcwNN1VwBXim9JNG7w99oiVvXThrctieAEVa5E60frR8NLkAFaCEYJHdccx52lA
Message-ID: <CAGsJ_4xVdNE_Afk8m+-_4UkA-K3VxPhdn43afP2RTxn7LgQJPw@mail.gmail.com>
Subject: Re: [PATCH mm-new v2] mm: vmscan: put rotation-missed folios at the
 LRU tail
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6241340007
X-Rspam-User: 
X-Stat-Signature: m6fw991oyerg19dfoxtgykjxad35nhmt
X-HE-Tag: 1789974072-168492
X-HE-Meta: U2FsdGVkX1+lfv9aV5Hj67cRGc7QK2gUWEpDOfkC5GJiWQbJ/3riTNAxoOsXo55ydKDYkE4QCraEugg1D6V2v+RHQgPkYRms6rUyZ5dYIh1+lKbLAwfWIMHCK6KKxvmX9s+N4UGyhTGroP2IBdFyAz/8zIGj4B9jWT9fN7y681LUUxqRHqd5DkYH0E8AaZZusq0FTWOQ0G9+zMjcYpNlbDVH5js2rUl4yPMMilHq05OxvAFEWLCk93fCLcbz7D/RUeBSMjvy+Yg3MOoojLkC6gNLy2Qxi7aG32pYDsqATLacbIjDJfXZJz2LvUOvEU0cucY1jXMhPpfpWpzw1uPZ2UzETS8TWXcs1KtFlBVvra4U8NeyWcRNrMOLfhksUFhR4WBMTuS/kgYZrSyMgeLKXlFr18KHIOd0Wbov6J5mL0Xoj83ZsweLZ36TfQlpt+Mh5+hGqRdSCzsDE7NbkCxQiIsBq8oflUen0lFPoTHvIE2sfuV05far8wRxXKi2+j0JiP8j/si5fNFWxB3hAahu2yP2mzKKBCyKDEUGBX80Dx/kFBw2HsPDMEPTApNX+OIh/nVB3QR6WQYMHXNkAVYJHCayFyZz8Skk5MsNNOjjh3WPqHfBhE21gIi9rP0MY/tQlApEQrAGrRbXj9zT2YNYAC4PHnLdO65SWZd21QwCHOxmBMSuWGCb6+5HlkBN2Rbl+scnFdH6SD/kV6qZQL6AzxpB3iT2wZIwizBaSxRSndkGA7i7U4Koh5XNY2eQ8EgjUoc0n+VFW0OLnbv8Kc6VCx1NHXhyZUvxFbt208eHnrR7InTPiwUKRZvYRNVYYfw5j+DKFKj/HPWmmlPJfPYtW155yXo00hWEvtRpIqNlw5lU+Y1NCdP6VrntRqYqF6mvNP8CV3+HgQ5hYRf7gX2c0sqZ2y088WqP5P5Brf8EoSx8Q9wGgI0YLlpI5zb5RnhPzXVa8XHT0tozYhIoJMg
 72szpw09
 9c6pwjmNL+c35awkqgRQHgiWfiY10uaOjApKt9KUj+t9BqmNuE+S2FhfziMKC/2p/gGMF8llhwa3sU0p8nQhD7Sp1l23phUsUCnwQZDGHLS/p0pRDThsBZhs/5XrSuGN2GkntO24sObM8zlpvuUkiMGSOxqmaMpewGz88dI/GBfKtkjeBu6C6o3FLnO6xtU9+vCdPguz3HysMgy0WJOEKrxLEzaVgmduqNAjKXnlPKN+kXEv/4vykJ311PdDuYgYpqIA8k9hx8LeIVDHLtYOWf0IY122YxAMApKxC+b1OFJXlHqdQWXYKt3Kpr2TcdpCsv2lOyS6tWGdJNlwpURT1LePPzkG+gpwT08c5TDzDRX5WQHUzF8XWnYevtvVHjGjE+9gP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 9:25=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The page reclaim isolates a batch of folios from the tail of an LRU list
> and works on them one by one.  For a suitable swap-backed folio on an
> async swap device, it queues the folio for writeback and, after finishing
> the batch, puts the folio back to the head of the original LRU list.
>
> Meanwhile the page writeback flushes the queued folios in its own,
> independent batches.  For each folio it writes back it calls
> folio_rotate_reclaimable(), which tries to rotate the folio to the LRU
> tail.  But folio_rotate_reclaimable() only takes effect once the folio ha=
s
> been put back by reclaim.  If the async swap device is fast enough, the
> writeback can complete a folio while reclaim is still working on the rest
> of the batch that contains it.  In that case the folio stays near the hea=
d
> and reclaim will not revisit it before wrapping around, causing a cold/ho=
t
> inversion: a clean, written-back folio that should be a prime reclaim
> candidate is kept ahead of hotter folios.
>
> commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while
> isolated") addressed this for MGLRU only.  The traditional active/inactiv=
e
> LRU has the same problem, reported at [1].  A reproducer is available at
> [2].
>
> Rather than re-reclaiming those folios (which would drop the swap cache
> that may still be useful for a future hit [4]), restore the rotation that
> was missed: when move_folios_to_lru() puts a folio back, add it to the LR=
U
> tail if it looks like it missed folio_rotate_reclaimable() (inactive, not
> mapped, not dirty and not under writeback).  A referenced folio is left a=
t
> the head so it still gets a second chance, and a folio with an unexpected
> reference (e.g. a GUP or speculative pin) is left at the head because it
> cannot be reclaimed yet anyway.  A new do_rotate parameter gates this so
> it only applies on the reclaim put-back path (shrink_inactive_list()), no=
t
> on shrink_active_list() where the list order is already deliberate.  This
> approach was suggested by Barry Song [3].
>
> Only the traditional LRU is handled here.  MGLRU already retries such
> folios via its own clean-list retry pass in evict_folios(), so it is left
> unchanged.  The same do_rotate scheme could later replace that retry pass
> to unify both LRUs, which is left for a follow-up.
>
> Test result with [2]:
>
>   Without patch:
>     cat memory.usage_in_bytes
>     1073700864
>     cat memory.memsw.usage_in_bytes
>     1413124096
>
>     free -h
>                   total        used        free
>     Mem:           1.6Gi       1.2Gi       299Mi
>     Swap:          1.0Gi       678Mi       346Mi
>
>   With patch:
>     cat memory.usage_in_bytes
>     1071140864
>     cat memory.memsw.usage_in_bytes
>     1413423104
>
>     free -h
>                   total        used        free
>     Mem:           1.6Gi       1.2Gi       322Mi
>     Swap:          1.0Gi       328Mi       695Mi
>
> After applying the patch, the difference between
> memory.memsw.usage_in_bytes and memory.usage_in_bytes is close to the swa=
p
> "used" value reported by 'free -h'.
>
> [1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenrido=
ng@huaweicloud.com/
> [2] https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@lin=
ux.dev/
> [3] https://lore.kernel.org/lkml/CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1=
K3u_i7LH3Zg@mail.gmail.com/
> [4] https://lore.kernel.org/linux-mm/20260911121341.178028-1-alex@ghiti.f=
r/
>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

