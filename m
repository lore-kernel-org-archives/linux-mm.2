Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C47EC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0DBA6B0092; Wed, 23 Sep 2026 05:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6126B0093; Wed, 23 Sep 2026 05:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC276B0095; Wed, 23 Sep 2026 05:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABA666B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:36:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B4D68066D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:36:03 +0000 (UTC)
X-FDA: 85244520606.17.B6D31D7
Received: from mail-ed2-f40.google.com (mail-ed2-f40.google.com [74.125.228.104])
	by imf08.hostedemail.com (Postfix) with ESMTP id 48818160004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:36:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nsNLZx0Q;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.104 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790156161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cs8T5ZcWIq5U6G9Vf1GtZypFn9LtOBQKVlGIKm7mFCo=;
	b=LEjdpeEgLkZFXatipGMTDnAlHjOXh3gIBXqA/p07eRaZfi4EtQS8UVos4DKGIBQywLBYFa
	6nowR3qLvK4g4keYg4ZUDvJMzPXLrb4OGTnmqqIMqwtLSuOZ1wWhioKd7CBgURx5tvF8rk
	3jzznWVZ/FhwTBVuGdjonm9KPMNtJsE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790156161;
	b=Qpk/f8/WwIVMyh82LQHtcHAS/Qrl2iGNCzfJ3PZvoru71IF31pVqevUavoBxCOqmaGPQMn
	LoBUfB20ePLCqJEVKLoi+yFKFNvuv/b7mYa3hVUg0Tql14rPcL9laibXeJyqBA9fBvP82S
	+nWY6ugWKXwOITsWJoDN4/d/IcbWb4M=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nsNLZx0Q;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.104 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed2-f40.google.com with SMTP id 4fb4d7f45d1cf-6a60590a85cso1500323a12.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:36:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790156159; cv=none;
        d=google.com; s=arc-20260327;
        b=Bj8BX3+b1ws44aH/ATic9ftudNtc95gd+5sTEgoqJk2QYD8t4YBS/lwXsNvPWChnht
         G32SnHwceLEf5hyC0vezL1wfjQJnKqU2jJAR7ctvSYyqHIGmNZ9i+8wEGz7pUSlP6sYy
         gzJ8rt8P1iVE+U53Q9Or63BRzx6x5rUMJwuvpHKrEgHUWoVDRbWUtBIFjUiUJwPXjYc8
         GYnrqMqSc0sCILNHkxLyatSa8B4E0ADy9qIanpYNAcXQAOHorgJSYyexFPKI63nFrjTC
         V0gDKfG7sI+2GVjWHQ32o3yyaBfwY7VZqKpdeyPlsIioQtxVwyXhFQ2Fhpt5BSe0zbc+
         Q5Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Cs8T5ZcWIq5U6G9Vf1GtZypFn9LtOBQKVlGIKm7mFCo=;
        fh=pbgDWTAGnY9DnVpGVRUgEFFCoXU1bQjvzLEKEge4iJI=;
        b=L+BxnKV9p05Rhy0MtpAhUI2xPjduUDPhr+mCrZP6oY2uLhyIFOBSYAaP1rvzxqBVfS
         y+/vlYveNLqs3PZ5KyGkz0VcFqbMbdvzwhGNO++WBE0XGLDfPmJ1AnqBP7ph5K73cfXi
         sBUUymjy728TRRQagbMV4nSxlWC4JE4VOLH4xYX87GjzhEEI1IYnG4GA+4KiaEOOWywm
         V9MSm+cIrgs88A47ixm1twogczfg6l6UYqOvYwzcxC0gcbTBOtefO0x1QeIxg/88CDfE
         If0G0hvVcqXWL9H41KaUYI+xMXxSk2Cj1I7QCaBAsmYAQReBN78i0IVQTwL5x5nwJIFt
         4Nug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790156159; x=1790760959; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Cs8T5ZcWIq5U6G9Vf1GtZypFn9LtOBQKVlGIKm7mFCo=;
        b=nsNLZx0QaJFzO5IjUzp9/FouSMLB8TLVTGpeY1HVqwoVXuWNGbggqp5Qp/NGV6sZBb
         m6UsLx3EvfxjvGxb9YNPwIq4abCf0XLR7zWOgZ+bGYWXffzhxwiCnJ/3gBh63fI270ZE
         0/AmKgMaJWvPV4hvA5QMA+K845h/q+RBmf7TcBnGrzCuqySPDeu2ttOqu+n5W+S1iJwx
         /jnFFa9T29EssFjlxQONcKWb1VOgGNLDkejewD4KlRmR7XAbsI1qSLiwWtA37CCreqpz
         p23aujaj9R7hlJVE94RB92jLUpvFQApHoJH7CE+tOrw4xd2Yg/twbQ4AbodY74UYWsM4
         OnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790156159; x=1790760959;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cs8T5ZcWIq5U6G9Vf1GtZypFn9LtOBQKVlGIKm7mFCo=;
        b=0Li/0WLWOyU47H48VSW3peB7193nXlkLkXfl3uHNiCHyDQwa/bfg8v8HVo2fE1fJoX
         8cylZEwIwDXxhYraMI2/E1hgLNRc9td4T7H/iWB9QUHRWj/hOisQQoKOY8eo20N4VzED
         vXjNvepQy0B+aJy7pLLz8SQL+bl5RWgyMM0ln+5CfBFn91KPvXKTl6NSmgGBwVZaLBhI
         XMJ311KH2joB1Lr+wOTtvdvW2P7kyQiEsxzWhyD22+idtXa6d8Z7f7bXvDVSGHNgRcji
         +nJRoautmN8fh2FfPqipJ3tDysPLOi/XIY3Nf72yASfVDtOql+4DDuIMro/oDagM9JaO
         PCdg==
X-Forwarded-Encrypted: i=1; AKwUvBwpdkDO+lderQtqUEviawa3TQGAnZm4KxWsEqG744jlds9C7F1WmvUvBo6uhahMByloM5XqTqvifw==@kvack.org
X-Gm-Message-State: AFuF++kzghqLwhSkk0sNJUCzIHWICP3dR1usKuXZcGsB0o0IDgzAsjmN
	Z9yxIrktK30xaVmAlysT1DspUwRxmvYJaYhautQ3Ae0M0pLZRaiADOkSkCLqEJifTkxWX3DoZhx
	gzUJcS8oMXij8ZGncOj/po1BrqLzaSZs=
X-Gm-Gg: AYBFou0oAx4HzYpkbpN30mcRk7Axb3ovvvI7LdfYOSdALw0o8ajvGjltsbWQo5DQuo7
	FmjqccP9ztsPm+eWf3OTBl7xlOmBh3gsWwQJQR9/CFxpMD2nOsNxKu+2rOIcr2xIGB5U7cq0toj
	NYr7xlC5oxT4t4izungIT0ed6nkljHQ0mZCpOSSSEKJrjLC8zORy/8Km6kscIkP86lsMxo9V98I
	yzcLFrOJqYu0osiMJS07Uz2IjSNoFAXdCXjGWmfc4FOPAl/mKYpZEWTMzNZchmgWzPNUkwOD123
	u3J1OsVnCvwJvwWODez1fAa3dmsdZH4YPYXLxuTRgCBnWPiAVDUHNRYy9LSzysEhu/YaCMnIxA6
	tPxACjiXz8PHvbvJExRJhEGA=
X-Received: by 2002:a17:907:9409:b0:c2a:9e6a:3b4e with SMTP id
 a640c23a62f3a-c2aadc5bfb2mr169512866b.0.1790156159160; Wed, 23 Sep 2026
 02:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org> <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <2e695c8a-4212-42b5-bb51-fbe1aa162e1d@kernel.org> <CAGsJ_4z2nakqBCKd_uAn4bfub99r3NJt2spOUx-K0M7bHW3_-w@mail.gmail.com>
 <4c7c6ea0-84a7-45f6-989c-d1502b90694c@kernel.org>
In-Reply-To: <4c7c6ea0-84a7-45f6-989c-d1502b90694c@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 23 Sep 2026 11:35:22 +0200
X-Gm-Features: AclHuK-XFajsGqUIFgSM4jp7unmbhFgPOMy4tt_SeGm4xDkZtIbvSE-oUeT-3wI
Message-ID: <CAMgjq7DeYsJxG_VCf2KnViV5nd10m-PPYzXRD1fi8QcGWwD0qw@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	willy@infradead.org, jack@suse.cz, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu, 
	hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48818160004
X-Stat-Signature: 79bcpaioqao1m4ypp6twmk4hen7uzy4w
X-Rspam-User: 
X-HE-Tag: 1790156161-590105
X-HE-Meta: U2FsdGVkX18CXcHEFseYky2udfQIMgzTu1F1Iy0UUJbet85UEw+FCxexQSUP3Uw+Tmi800MPVxVd8ANeL49B7dwu/JBV2OlKSkSJ1MjkD0QFaqnAMuy+efIQQF+G2ocO2Z/ETuewApZGqZAykYFKgAKFqiHZpfzh39PdMcz+T3RYh3R7rrVp/2xe4EPK9S0s0HoU6hxqURSXffnjd+oOv6E+sFU8ahqGngtOHe+abUaT0gaAqW0D8reWdg+8oh2gG0Eu9hLzG8G56OeLP4SJ1iMY9JZDKAVTI5mAdN/0CD6oJfRuHuBwlPjkNqe6FuJO4TsBkulReEQAnV3g+m2Kt0Y6nEQ1X84xt9ctKJZuGRACSIRZGPnnORHsy536qfqwogeUjfMnhHzufYtNiekGO05GITYEhwnYoIlMTTAP+a/j8GcN64Ua8gItt0uWKUnXNiqGhEH3EAzlUzTBibobribUVzB+kRDkklIH2coWnKIGoGHsD1AH2SMy67tBhrwFKNjZXfAXTgwbWUKrP2l99NIiQ0i55BMhgvW08JKyCznSYxYq2+dAZSCOWY4sP1G0pLrqCYV8nU93rw6lD17TINC+OauB6d6AUKuY0izI11mK2LYhmXdbbD4JpeyhyrMrK5KaS3UKSWbXXJRasNkH7MqXIY8UBS3y2fFs1SCaiuqG7yEEbVh1HgezEW1sdd1xWTcSVJt7XIXlmEXWqpOsj3gT8fokb5Koetg0ptH5The+Ea3x+3TuyRQ5IH4eWIdjjpmxSyb8A8oWJ/T3Fqq930CzUl+qtWcimOV4R++pL0z0W8GvSgyVLFRm3DiqnrIm4oMx2wsJDB8oGw4qSvfoxl9X1pAnU/sPTsRQDeMmahFjWAfkj4Y1S8WbhkkqjXW8YX8BZtYAgBWa7OcEeKbpHOcQyv5OKcMjnLu5hmhEeEGN1zpTrVNIkrMJglCXLlVD9ftkQIeR6LmyfGbPEO7
 M/1FKiIV
 hCkJYKq7AKwrf6Krygi5vqVZJGCt2wtXXeKi9YY23vD2+9HRjEmAVrKQkvhmfL14xPtJ548DWOexGUf9NuXclfHpqk5QXAH/DUbCLIMjC6KyfkCdqvuw9yR9aQaNpmz6ONJB9crehYVCjfs+6tFDUXEuq0uI22dupyXXxXuYf7qIVSPwtr45U8MsJia617uOZyS6raBwUZ71jgsp3WwLGXsg0sXySmx1+Y61nkmVO2/Smj6UUgzCXQ9H4AqEWHJFesWvBA2TGzqrZUENHtHsUBzHICXAhXExlRPVm7TFG9ZVb5zVLfu82F+ikDXsP7TwE17pQ7oGIjsBpUTlzlM16TPJYlW0ZKeOUmt7CwvwhJyWHFAopNejzuxcY743a9h3ZXN6J+q/IgsjGQxrSavn/EM7Oiq3oPvhqrM+xPe3TVczB1KSOOLr8/7CAFNlu9xeCdperDabvnUMt9vb2av3kQWGsE41pkFsNBpFT6sHP5mp/9JsWdxsWh7c5gAkIJNvv85hiz8puVMFaPgWrINgL9k9qex/533C22+xx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:46=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/22/26 22:55, Barry Song wrote:
> > On Tue, Sep 22, 2026 at 7:26=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/22/26 12:37, Barry Song wrote:
> >>> On Tue, Sep 22, 2026 at 6:20=E2=80=AFPM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> I suggested this to Alexandre, and he found that it could regress som=
e
> >>> workloads [1]. That is why Alexandre is only making the folios
> >>> immediately reclaimable for `MADV_PAGEOUT`.
> >>
> >> I really hate to add special sauce for MADV_PAGEOUT. Also, I don't qui=
te like
> >> that we do something fundamentally different for sync vs. async.
> >>
> >> I assume, though, that async writeback that is very fast might just fi=
nd the
> >> !folio_test_writeback() scenario just like the sync case. ... or if we
> >> reschedule after pageout()?
> >>
> >> I am wondering: if we can show that letting async swapped out pages st=
ay in
> >> memory a bit longer improves performance, aren't we swapping out the w=
rong pages
> >> in the first place, and not swapping them out would help the sync case=
 as well?
> >
> > I guess that's because the LRU is not always accurate. There are cases
> > where our prediction of future access patterns may be wrong, resulting
> > in refaults?

Hi All,

>
> Right. But these would happen in both the SYNC and the ASYNC case. Which =
seems
> to indicate that making the SYNC case behave like the ASYNC case (keep in
> swapcache before evicting) could actually improve performance?
>
> Or is the SYNC case in general so fast that it is not a problem and the
> swapcache is just not a good use?

I think the problem is not LRU being inaccurate, but ASYNC case could
overshoot the anon reclaim very easily. File folios can be simply
dropped, and increase nr_reclaimed, but anon writeback (swap) can't be
done durig the reclaim iteration so nr_reclaimed never increase during
the scan iteration. So the scan tries hard to scan and reclaim more
anon folios, more than it really needed.

I think the real fix is some kind of different watermark, throttling,
or a different counter to limit the scan of async swap. I mentioned
this at LSFMM this year but I guess I presented too much at the same
time so few people remembered it :D.

>
> >
> > Even on Android, which uses zram with very fast synchronous swap-out,
> > I can still hit the swapcache from time to time. So perhaps with a
> > slower device, such as an HDD, keeping the swapcache around for longer
> > could allow applications to hit it more often?
>
> Why is that specific for HDD? It's the exact same app behavior independen=
t of
> the underlying swap technology.

If you have a shared folio, you must use swap cache, and even for
single used folios swap cache is the way to do synchronization,
regardless of the device.

> >>> See Alexandre's description:
> >>>
> >>> "Future work
> >>> -----------
> >>> Barry suggested extending this to MADV_PAGEOUT and general reclaim. I
> >>> prototyped dropbehind for all reclaimed swap folios and it regressed
> >>> sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap cach=
e
> >>> immediately turns cheap in-cache refaults into disk reads and collaps=
es
> >>> swap readahead clustering.
> >>
> >> Thanks, does this represent a workload pattern we care about?
> >
> > I don't know. Maybe Alexandre can share more details about this
> > benchmark. I'm also a little surprised by the 15% regression in
> > Sysbench OLTP. My initial feeling was the same as yours: we should
> > release the memory immediately after writeback completes, for both
> > synchronous and asynchronous I/O.
>
> Right. And see if we can identify why we are swapping out the wrong thing=
s :)

I think we are not? It's about over-reclaim. In the worst case we
might put every anon folio under writeback, while no folio is
reclaimed, if the device is super slow. And if we drop it on writeback
completion, we could drop the entire anonymous portion of an
application. Of course, the performance will be horrible.

We don't have such problem for ZRAM because ZRAM just releases the
folio during the reclaim iteration so the nr_reclaim counter gets
updated properly, and the iteration ends properly.

For async swap device, writeback is async, so the reclaim loop just go
on without updating nr_reclaimed (they are not reclaimed, still under
writeback). The reclaim iteration only ends after it reclaimed enough
clean file folios or previously written-back clean swap cache. MM
reclaim is expecting to see clean swap cache after writeback is done
and rotate them back to LRU tail so next reclaim can catch them.

BTW we could hit OOM even if swap is enabled due to a similar problem.
Anon reclaim can't really free anon folios, so it always relies on
having enough clean cache (page cache or swap cache) to drop to avoid
OOM. It just keeps pushing anon pages into writeback when under
pressure (expecting that this helps the next reclaim cycle.

This is ugly, I also wanted to figure out a proper fix but got busy
with other stuff :D

