Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F401CFC5908
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 08:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599E06B0088; Thu, 26 Feb 2026 03:03:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5470F6B0089; Thu, 26 Feb 2026 03:03:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4497A6B008A; Thu, 26 Feb 2026 03:03:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBC36B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:03:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC0E41406B2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:03:23 +0000 (UTC)
X-FDA: 84485867886.20.78D686C
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id BEC8140004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:03:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KVhna4bD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772093001; a=rsa-sha256;
	cv=pass;
	b=kwFy62QpDqLEVPHnIYjL6bbCODszzUNsgq9/CqjGZ/0319t4hVQ5dKzpCG+wjd1tbE0/36
	1xs+2yi8lPG2g+/dVVAI9/kERDHWAw+LQapVFGYT5CYEF0K/Z+GuQq/I4OupipsnNY1u5S
	3QSqaxDMs88KZPn84KMLUkeWKLdwWI4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KVhna4bD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772093001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnjkDqCf02xshfHJti9bv3arxLwThyNlWEaebleJYF0=;
	b=vCKeSxqjpKHNTXmeYuFDlKvbpmyoK9OqpET/yaUA0gAfcJ3W0GKWR+52C5S1fv24E1qokZ
	ZWQ3JfuzlU4Y/Wv4khXg+6iwIJF2c95fujeaPpMxg2O0MgnKMGWcfSjKJ4Ze4rC24ZKj7U
	SlVVMBuNcGdYmAk5y1+8QdpMMuz3URA=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8954a050c19so6962646d6.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:03:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772093001; cv=none;
        d=google.com; s=arc-20240605;
        b=OvXzwPQJMHcIS5f+mrdAIamteVZkiS0pz8xBOL10OEuPwZ2rHfyo79lflGvvFOWmBK
         pF33pCw9IqrSSXbarPAz1hqdpTnZ1baJse9IaPHm8vXrmoqjDwnouTEis6NV72tZlMqb
         LblFuQycJxdF9hHtX7oqOTtfu+Ex+hJiSgLzcS/cn2Txf+OUEFZ0B52NkQTZ9lUdYUVr
         JjHBNOI36B6yIh8LCqJbM2NVyHpcac0p2N0zBZhNlzCph8ZNh7+aHvrhGJbXa7I7ww6w
         6z5SvojXlZ0kn17SUePmSuOmBqgDfB0Yh7/DPv4WkVqAEKr92ArEVaktDVpcdq3m8LaF
         zO2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pnjkDqCf02xshfHJti9bv3arxLwThyNlWEaebleJYF0=;
        fh=Ef68tvdwb04PcJvBzafdQSwQfOmK6fKEZ8nuOJI+XWw=;
        b=ENxb8v+Bks6Px+wHUhng/azWqQYOvFZcwIGDUbe3LZl71+NQbHAiCVucZNXk46B8uE
         QrQZeNFZuerjTwJQ8Fva7rAeNOXQjax3qZ+Hxhkbr8uoBoZwvZetS0h5gX/vaEnhrQ/7
         XT1sZFx3yydIM505ZyoxK/hcgutCZ9jnBmH3JZ7xR8lQE7HbtPd/uwQX573HvwXXChwd
         8af7AQS7y3/F0uht5845WjPyyrTCYB1eb+M8I9XkAJhAIPY+Dh0ENQZwcakWeC5y6G9F
         pejfIxFbp5OtBkWemmAfmkpOPNBVhWCPX8MdicPzE3s9PfcxYFHpUgKiS0eW5sYuXkCf
         2ItA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772093001; x=1772697801; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnjkDqCf02xshfHJti9bv3arxLwThyNlWEaebleJYF0=;
        b=KVhna4bDOYI32rmvE7g+UiC19HaZHT9jLd7b0QpIZO9jjNnZgZo+EBeetfk6szX2w1
         9bGnjTsy7R0xtsWAXRI3MH3vgURaljcf/tC/8PD/41Gi0QxLxPFzE59ZubXkvfn3b6XE
         2RbXNxl5WhwbzXaMrOSnlnRlGjHajNsJzDNhu2qtM0mQLdunRNqVfRTd88oRB6U+90t3
         sTxLSeTFpHNP0MMTsq+YcbdyZ2dq5oUM3UkoPND7Dt80nZO7x7dEW9GF62WjNXygX6Pv
         WvrSqZ/ErAhYAGf+6R8QGO1j7uzUn0PnkD1i+tEI2JKPk1lghRS2k19/bEIfwgParzXJ
         Csrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772093001; x=1772697801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pnjkDqCf02xshfHJti9bv3arxLwThyNlWEaebleJYF0=;
        b=EbhOh9FvJnC4eWBTNBhaEzR3zmcQ5daZVOq3/CJjssL2VLm3gO1yJ7sp8guvyIZhna
         zFy3Og6CKtHDOsTVCOke1v1miF/1TLgnzLZRjm1E6atfFrpDHb3gpbaLsrhGXQ4rYjKx
         6tqlg0L0aE6mcB6KwUc+M2BVMCNI3v5JAkM7h5Rr9M7/49/mUwGnwv55bkuyIRQ0OnY6
         qcCR9aW/JpxLbuKc4Fh21bXPHyQ865hzfLXk7rQRrK8BGD1qHGrvwKxJPc7sFu2xqQsL
         9bzVyBA/qVKV1dvbcB0JOnjEycBGFk7gqJFc5O1nPAodRoeBQ28sb5kCY3q9saxXLbDc
         cX5g==
X-Forwarded-Encrypted: i=1; AJvYcCWbWJTpuun2oeiSYcNJduurgCR0zDgXCdloBPebEZerRAmEHWxEtU5EjgkEe4XpWJsMSFc8Molgfg==@kvack.org
X-Gm-Message-State: AOJu0Yw6Wo8x8PNtVDB16In17G6RJPzLHcsIO2M1RiC1X7k+gGStlc2T
	6plOrvG6dOEOIr33R8jUtxUdroBm5nnF3INGUJsOJibEhqHtMlaGH8GdZV+dMz35z5lK2gUD4h/
	4I2rzLgZSEXaJkcKBvWydORd+Oft8cDc=
X-Gm-Gg: ATEYQzyZu9YDUapYj+lhTZ3ppkAof52VQjIjlkaByw2G0YSNJ0x5dVKxN0xQQdlvhFp
	muLoq2wjHpI4217n9kwZ121W5xJQxKAKcjYbk1JeVgt6cB/zemg2a3Zs+MAiuSapAW1InUMCEBr
	bgoQpRoZIoSA1jSO7BTVI/n7JDr8jvlSCYej5gAF9/RTNlslRU4BQfE6y2QWxV763anlMW5gJho
	4TFb3dPAOjWFpG/MJD+1UrNMfjfBVSmFG9LJuaA+SXTWnG2yFJVSPdjdrpFe+ETXjJugJManM29
	6PTMP2CZpQEziKtn
X-Received: by 2002:a05:6214:234d:b0:894:7738:b808 with SMTP id
 6a1803df08f44-89979f349bamr255983426d6.53.1772093000479; Thu, 26 Feb 2026
 00:03:20 -0800 (PST)
MIME-Version: 1.0
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com> <CAGsJ_4zatnuLkCJyDe_o_yXmhngpc54kV6b7M3tu6JyvF-ZxDw@mail.gmail.com>
 <7ecdf6b68ace402f90a4685684bbe995@honor.com>
In-Reply-To: <7ecdf6b68ace402f90a4685684bbe995@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 26 Feb 2026 16:03:08 +0800
X-Gm-Features: AaiRm51UnnSGxxz6KU2g_lLaRNv7zx8qjVo-uHIUJjt9V55x5i_An-Hk7pUQctA
Message-ID: <CAGsJ_4zPYpTDY4U0wSGhoa9dVHus_FChXaaD45H170TSXJ+RvQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and Challenges
To: wangzicheng <wangzicheng@honor.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, 
	wangtao <tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, 
	zhouxiaolong <zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>, 
	"weixugc@google.com" <weixugc@google.com>, Randy Dunlap <rdunlap@infradead.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "willy@infradead.org" <willy@infradead.org>, 
	"surenb@google.com" <surenb@google.com>, yangxuzhe 00017436 <yangxuzhe@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qxbde6cr84mqsnsd6i85x4squ9snpmh5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BEC8140004
X-HE-Tag: 1772093001-1800
X-HE-Meta: U2FsdGVkX1/44HEiG04jq+Z0SJXPCvq3+uYMzh1kMYVWPpzi68ghGLkADLanwbn40OiGd47HnHTCE7OesLRKu1vMnNwwsuQXwGjzKNkYeJhxFgW7QWkgxu86QKaF20YCMK6QKeGPNu10E0nJWY7chDHrIJePL5SzEVmS/f0pkU3Pu+1OjXUF+hLxq2oTAExqgieZ1EGOwqEvwHd5Kk1u1mBnUXzAP7OPVXGgLIrPphswsMByHvKE+R+AbzMKL0pO4p2qfIVZgOB9Wre2f3YeZcOKVxGCLOUmcxbVObh4tkJk55+ROngSHsD1flGF0ryC6/t4nSw/dY8Q90liOAZjS+N1ESFqIJ9R2QOHAddnj5vB/jYtq+JazuOSIsLS3aEm0p4sgogFQ2eID7HIp7D2g+0npVlvLqprieECof6KguACEBxSsncaDziT1bFcr4GWqslbjfQFNnax0UQxjAhu2FPv9KO49j/X26aZPSBxvpyq/7MBFegcgAwmon8JoOkIGkd+F4pSx92WKIiIP/U709p8Cb1NCIRvXZ2NOVY0LUbw1gB+rPxTtszR2dNJFUyp5w4luxb6e8Ueui25qHrburFAYRymlvWrMPbwX0a5L9inruI4hng5/jaD2e4jeiPI2qLOqGEYkBhbuxiq/1R24lXtjsoOqujULsu49nz0joeJA7IFMTg1TMoMJ3Ib7+0PcUVO4R+6MRWqbanoanIptKMM1Ok4OC4uy9L3tyzkqtsTmH/zytASa4rYMGE4xjc9VSFrqLM/XZ3GeJl2bbq6pdFujMwGMCy0L/pbSQndzjnCwsdW1v8f+80U6JjD0cfQsd4vhq4gFpK3q/s/sJ/91KA7nEKTxfB5JgkzsE0lewwsK3nGs2fM57UaWV/7RHAcXsBvW+n2UFC1u6pr4g9JTON35uzUGKBYZoQxFPiR+DwOKBHxqXYnvg0lQ1o4CvV8s+IJpgqBzjNI6GavSiF
 cRkBcTqf
 Jhxghe7gQE1+dZU+ynrgSslbWsuFaf4CQkKUz8oQUohWyFwAEN9tInXzrNTlDLRrlcBHGQBSuj1NN5odwKsj9v3rjxZ0wzTPw/Qo+wm9yhncoKD4yWgXnXHxM6cMO9c2UK1/w/kynSXhSMMJxkQpxdct8k/jxDP8t+cLPPLmosC9JhwhJVYZ5q372LBeho4otL5gMTmYnHYl9+YJ45L9pcvrpYQZbcdHC6qzVGFlTCJpqJw64RNEt6ovwytb7b9omLb79Sq+5CUvgTQnEvpBjvqK14ijDYHXvyyYt8IZHGwtYwdRdU/AAnjwTnV1cDCXuVw/t/abdHBvAIiqX9yulDrX/qtavDsjwZoalQEeeMy3ZjZe9Bbh7SDzNf82JPecYcL07i5BmvMlqvMt1epsQpqO8+O/9FtO6VOvHylqsIog+K4ZBa2BruWTkRwMBJCyt2Urx3XBY4PY8XdQaa0mQs2wTqM3Wt9vEycJiHvwp5BrDv/L/Q0jSrLi29PN5hSuhFE6uPLQ++f3HjkzyAFmn7KHZOGjOamlPch/rJV1poqurbUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 6:43=E2=80=AFPM wangzicheng <wangzicheng@honor.com>=
 wrote:
[...]
> > > reclaim via try_to_free_mem_cgroup_pages() lacks clear abort
> > > semantics and can overshoot the intended reclaim amount.
> > > We currently use OEM hooks [2] to early-exit or bypass reclaim under
> > > some conditions
> > >
> > > Q3: High reclaim cost and long uninterruptible sleep on lower-end
> > > devices
> > > On lower-end devices, reclaim cost and latency are harder to control:
> > > throttle_direct_reclaim can make tasks wait for kswapd instead of
> > > doing direct reclaim;
> > > sometimes the target generations in many memcgs have very few
> > > reclaimable
> > > pages, so the CPU spends time scanning with little progress.
> > > We observe tasks staying in uninterruptible sleep in try_to_free_page=
s()
> > > We haven't find any proper ways to fix it.
> >
> > Have you identified the exact line of code where direct reclaim enters
> > uninterruptible sleep? Is it waiting on a lock or something else?
> >
> Yes, we=E2=80=99ve identified the exact code locations where this happens=
:
>
> in slow path
>
> static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zone=
list,
>                                         nodemask_t *nodemask)
> {
> ...
>         if (!(gfp_mask & __GFP_FS))
>                 wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
>                         allow_direct_reclaim(pgdat), HZ);
>         else
>                 /* Throttle until kswapd wakes the process */
>                 wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
>                         allow_direct_reclaim(pgdat));
> ...
> }
>
> in kswapd
>
> static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order,
>                                 int highest_zoneidx)
> {
> ...
>         if (waitqueue_active(&pgdat->pfmemalloc_wait))
>                 wake_up_all(&pgdat->pfmemalloc_wait);
> ...
> }

Thanks. I understand it could be problematic if throttling occurs,
especially on threads related to user experience.

>
> > >
> > > Q4: Lack of global hot/cold + priority view with per-app memcg
> > > Android uses a per-app memcg model and foreground/background levels
> > > for resource control. root reclaim lacks a cross-memcg hot/cold and
> > > priority view;
> > > foreground app file pages may be reclaimed and reloaded frequently,
> > > causing visible stalls;
> > > We currently use a hook [3] to skip reclaim for foreground apps.
> >
> > Interesting. This somehow reflects that the LRU lacks the user=E2=80=99=
s
> > context, especially on Android systems=E2=80=94for example, which apps =
are in
> > the foreground, which are in the background, and how long an app has
> > been in the background.
> >
> > But this is not specific to MGLRU; it can also be an issue for the
> > active/inactive LRU?
> >
> That's right, this affects both MGLRU and the traditional LRU.
> We believe this comes from a semantic gap between the kernel and Android
> (e.g. fg/bg, per-app priorities), and this is one of the main topics we=
=E2=80=99d like to discuss.
> Additionally, even with MGLRU=E2=80=99s memcg-LRU, this issue is still no=
t fully resolved
> in our workloads.

We might be able to leverage some existing infrastructure. MGLRU
maintains an LRU of LRUs, and within this structure, it may be
possible to adjust positions based on whether a cgroup is in the
foreground or background. In other words, the LRU of LRUs could
receive hints from userspace to influence a cgroup=E2=80=99s position.

>
> >
> > Additionally, I=E2=80=99d like to add Q5 based on my observations:
> > Q5:
> > MGLRU places readahead folios in the newest generation. For example, if
> > a page fault occurs at address 5, readahead fetches addresses 1=E2=80=
=9316, and
> > all 16 folios are put in the youngest generation, even though many may
> > not be needed. This can seriously impact reclamation performance, as
> > these cold readahead folios occupy active slots.
> >
> > See the code below and the checks performed by lru_gen_in_fault().
> >
> > void folio_add_lru(struct folio *folio)
> > {
> >         ...
> >         /* see the comment in lru_gen_folio_seq() */
> >         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> >             lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> >                 folio_set_active(folio);
> >
> >         folio_batch_add_and_move(folio, lru_add);
> > }
> > EXPORT_SYMBOL(folio_add_lru);
> >
> > I could have submitted a patchset to address this by initially marking
> > only address 5 as active, and activating the other addresses later when
> > they are actually mapped or accessed.
> >
> This sounds very reasonable to us, and we look forward to discussing
> and evaluating this direction together.

I sent an RFC today for Q5. I hope you can review, comment,
and test it together:

https://lore.kernel.org/linux-mm/20260225223712.3685-1-21cnbao@gmail.com/

Thanks
Barry

