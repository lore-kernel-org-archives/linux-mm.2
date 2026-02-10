Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BF86EB26F7
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 18:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88956B0088; Tue, 10 Feb 2026 13:00:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33106B0089; Tue, 10 Feb 2026 13:00:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A7B6B008A; Tue, 10 Feb 2026 13:00:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6AC6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:00:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42C5A1B39C3
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:00:16 +0000 (UTC)
X-FDA: 84429311232.09.141264F
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0F54C140011
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:00:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="a/F41Kk7";
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770746414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0M5Ou8Dr19t94K73pKgRAsY639KugQQU9W89/USRqN0=;
	b=vWMpDN/g/9Wv2IbTemTP5pRxsP8qDDrxmfpKiWijx8RwKfjlp0Q6GPsJ4jlMcOKFK4/Md0
	qQNO3Z4hxHYR1s8TpyuJiy/MDTLjaJNz0LPKVN9/nY0ONowuhyXg5ZmLk5RICH+7gp+mlZ
	p2GZgr8f3C/IHDp9BLwnegV+PH8+R1c=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="a/F41Kk7";
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770746414; a=rsa-sha256;
	cv=pass;
	b=Qbu/Z+ZPQX0Rn9DkWXFrfVkMb2ipgj/FMgqMeoeYjQ+L+VI8/8/J8qE+aNnKKMUlmZsnWz
	wvc5os8dzaai7xNn3qbqMNH3ZPQDK9twDi+8csFtW+4cOO3ICS4NRA6WsrFDbtvXltfFv6
	SS+NNLhXTOKudIiB2Wy5FJJlw3EoPtk=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b884ad1026cso196143566b.2
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:00:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770746412; cv=none;
        d=google.com; s=arc-20240605;
        b=SmBpyd3Hb7IEWwKFYr6NVXY9rVyomXo0oEhN4+jm1R4hP5dyZbuFJ8+cfOdpAHcZjK
         GB6bVc/TExovcgKnKHxU45wZSKRcsANuh9xVStayVd7qfCYtToU/xQyRcTEbCOPq++kQ
         HsW0d9y7RbUiPGEkt0PqrUC55qA+WRWG87MgCt+w8RCYHTXIrRg4qZb8Dttnd+gikiL5
         gsad68/zsVgFFlr3VMuX4k+YVCcC6aQixxl/fHuQI6qsyeCBhpwFp4eMc73UMCVRPdjG
         ZiMUlrr4PeN9mit3Zp56z1mSnq6HICnwrw1n3DBLcBt+QDpn8CsWd3OjEvkmVfIgyLHW
         krDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0M5Ou8Dr19t94K73pKgRAsY639KugQQU9W89/USRqN0=;
        fh=QRP/ovttb8Jb/cZvuG2akPqFdIuVC6ob5sX64S2PJhI=;
        b=DxPLg6hY4STg4yb14KAIvglZ/eQIvhjTIgrpO+EskXsewVNxv/HClXqbQg9mvfinbi
         7gKu11UgRkL1hElkJexFPx1Mfq5UiB9LYCsMkmwZXESqT6dNwsThzHEQVrNfMoN1wADW
         jpor/0KYk+Qif+/xLB2ucSNXg4VFf+vZVM5CzJKwTbzPoGZ+MtU9rhaTelpBH9doxqL3
         wgQc39AjN+rnOJ8kXmG4No9EGvZdacfqzshqHw/yuEXfhWGw28tYYuDvv6QdiFisn8sB
         hFiZXKW8f3Hbf5wus9+DAMp+Xo7l+3fnruMZUK6xkjEF9rhJHgEQUAMbBusHVriRzJjj
         iVMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770746412; x=1771351212; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0M5Ou8Dr19t94K73pKgRAsY639KugQQU9W89/USRqN0=;
        b=a/F41Kk7vuwSY9F9SiYGLcab87UES1EDR6BV7zHiJ15VAAkgLXCPYzSzIjetoftIhk
         qwHOe4P2vqj8Yk4t6YvDZBM+JnupE+oI8sypw9Vt/CBR7l6JV9yLszB0u91Z3U+avn43
         VYOjOo/jb5vWYXSxIj+pJAD75UH9QxMKMQmB5lXo902euA25lV4oz8spFEcEzg1dFgHm
         9ex27KYUrDzfwjoGxf20WWbDStEm1HeAW6Lxd1PDzfKKwXP97EVw+rZJcfQoQ78qN0lN
         DLQyDDCVa9H6YXlN2C2vO0xP0oUA5np0BNDVxWvmZWsO2iraRg6HMhDEg9BRCINyS5xV
         EcXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770746412; x=1771351212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0M5Ou8Dr19t94K73pKgRAsY639KugQQU9W89/USRqN0=;
        b=L03ESnb2jiKU3wUQSyrVhOANQBaGK/F3HeXJo9N7s3FjT0WP2OigqELlg1ZgtHHvAx
         NKxsTBa7uuruWBzCjanaGJxMjFsuAJdU1CmlQVtn/4/500xdvSBAhoU6gqAHOczuA3XX
         ERRVFJVifNj52Yp+N51aa1ANS/4SR7Tmawniw3+kSRS7Jxxmp4wtIOEDO3EclvNMBfrO
         lv2B5CwbC4M8a1gTOoZ/19dY3jHcvNg4HsldJqUfC1cb7e0sg/dCSvAc1jXtxSr7Bn+e
         ZFucGwrOFHwZhZvxYl7B+9HpmwbMJFoBxCK4YwVz0N8gLeDWgpZhvg+8sQpdpO+ileUl
         E0NA==
X-Gm-Message-State: AOJu0YyippH62S6UGKMtvbJICCTLRew0o4+PoAoFrVd/yf08z6EsF4bP
	mNyT4LJHC8wBdklql6KhrQAHHmdy1Uursmnn3XnX5eMG8qUwG6xBJ7+9pN3UMJdfSS2l0e6vDes
	dlUKMCYwrzNRJ3qtzyktC7mOlwS6Hf6E=
X-Gm-Gg: AZuq6aLrcf7j35eIcsBOxvFlf2RgLntYksfJCo6Fura1jFlduBxHj5HMWhUKzxtG5Mc
	s2Luei4B1x2NXch2sj3QT3VdeuGBEVZ7I5OCK9q//AW67Dls/VkEK01VZQ5BLxBeZ4lwcrLQ2sn
	pz3UzBtOTYhchm8hiV03HZ4TTLJCV0e4hM1D1YZC0XQJl9tkQs/WbYC7+Sd1oW2fba3xltgDfEj
	ntBCFMnqMQowR+hWg8hY8fKWyN/nA0tUD2qwCO0LLW+1nz8gud7vI3fDdet3CXJFA0ElV48s3f6
	kM5pktgIqTqGKR+zzBr7p6bQBxJnVFiUfKnwRuct8Bmc57gcBd4=
X-Received: by 2002:a17:907:97cc:b0:b8e:3877:d1cb with SMTP id
 a640c23a62f3a-b8edf45cf7fmr962300066b.62.1770746411856; Tue, 10 Feb 2026
 10:00:11 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-2-nphamcs@gmail.com> <20260208222652.328284-1-nphamcs@gmail.com>
In-Reply-To: <20260208222652.328284-1-nphamcs@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 11 Feb 2026 01:59:34 +0800
X-Gm-Features: AZwV_QgjgrVezF-d_BQ-9HaqLNY-NJc1Y-8aDIlBfdscQkLqG0fjwgzeysl6W44
Message-ID: <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	len.brown@intel.com, chengming.zhou@linux.dev, chrisl@kernel.org, 
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com, shikemeng@huaweicloud.com, 
	viro@zeniv.linux.org.uk, baohua@kernel.org, bhe@redhat.com, osalvador@suse.de, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xdcb7bz7gkjzzy8dcut79857fsx6jcbj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F54C140011
X-HE-Tag: 1770746413-490354
X-HE-Meta: U2FsdGVkX1+lL9h0OrHDzOXWRVPo4yNAIemr65u+FlA53kBfDE4Jmz1j/05TwwJMPeyI+ZVWmaUkfFi1fZHY2K/UixiRp5x7cI7LMCSCOsAt/0mHXGc3BH8aDyjfh8mdmP+OMoG5wNRZRTWIAPoQ/bjRFNMpeouZ7bvhRWR6PRTAxjZUbF/hSed/0XPsjM9Bav76DJ2vpfeLzGOcaOSTxXPrPl/5i0H+QxkfqzMOJxB64bjyx764lKgchLMZ5zx1ZXVBu7j/IQTeVSLD05u63Mi17owGtavpCCygwmCEdHXSMVHvLDGPR3pymfiO6ekQ473oS0HrosRJTfo48XzSQf5hQjbigXErPiIxl63cITEgXlru0PepErGoy7lEVIJXHWYQ8OzVSbV5VpIcdGiQbugOMm5WGQyH+ABtUwDgxPA7TxYEbBp3dQmt06yNOwlLu6XWMcaZScF75rAiaadU7utLlIeMyNCaK9ZFVTMj23kgFtChvXwFRWaF+EQEBgSFxCXqgtj3XFhAwXKDpm8TJZkC6MZggKesYGC7VeqUt25lZdGj7c3zzV9Wsp5NywixcHK9xS+NtR2hfKa06PIl7RMZfPO/fOgIMH9sqzsLqfq25+DFxD1RjINR9EZb4HBSjtItTLsVDRUxDIcZZeIdnKmxCpyrENOYLZ7z7wXone6u/8nbqLSwVro4JlbctnbSshUqCwYBcS3VhG2gs7GsntHP6rzezslQ9DtKv4xwlpdf6M/ofCK/zjJ7jALX8DicTeNyHLf5j9LWF3EzWznGfG3gm1HaRecCOonAsDIAC8468gQ7sz9/ZEJHw1dqlZMMyddPxa5jYoq7M2IJdbSOtprXr5iQmEP3TAKvsGSXLPM30z3oy/jNx3I8eF6B7bQQgsnXYN98lBvyC/8flVIrkqiZdvb940L5DINkb5CT+4rQ0eLCSTDrIZKWo9DSUQg2GfuK/nIwIeJBxtyHQLN
 RS6ivoT5
 e9uYxGPqP3RxmQsvHXVD0PyJK0S969cDZfYGKHs48GKi9BowsIzlC3biJDxc4AO2fKRotzByN47d7Lk0UCUWcGDVmtW/t4wBeRDPBZB3NSWClcACP5JKhMPO3uVKzvDnnXZHz4sLiX95zL3mecOvoHJ9FiZMoQGvUXNziLyNVm41WIfOT3VXRYSi+MOMeDc2DbZXYsoFN/jVldCprzdoHvbXoFZd+OjkX+dB3fAYJC8VtmWm9mlh6H4QYlqJUuwF+ULa37QrnpfkGLOdbsDqLCrkJt9BukfCCxg/72BNwudOkZ23bnXA7WGrY6tvSb+YdAYVNLUyXvRbw+MMj6aMTbJhrGyIaTzuxt4V3NhIrQx4go7+mdvPAxlP1EL9HNAkwVlMO13IzeHWC+bVZWCH+/7bVHAk35DR0rJUxkFqW4sEqelJRGti537ywCEcdg8U0497F/xGPl6sE705ypSNEvmDIuzhljy0UhigYJ0WltRvQRQ/TuwwD2VWkCSXR8A+AtixvgTQYp/hNqCgQ31NgyOowsgE0iln3Ds3lpWOOIvIVaOVTVkB4lCy/HkmiQ6VIqHO/Jm50bDkVrmQCa+D5tFSDNS5B5qBvLJzejv4fV0Vl6oy3hMmqACAg54YM6PZpVd9o5oh/Rc24G9MAlZWtgLAK4NikP2L4tdYR9NjtMVZSp5I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 7:57=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> Anyway, resending this (in-reply-to patch 1 of the series):

Hi Nhat,

> Changelog:
> * RFC v2 -> v3:
>     * Implement a cluster-based allocation algorithm for virtual swap
>       slots, inspired by Kairui Song and Chris Li's implementation, as
>       well as Johannes Weiner's suggestions. This eliminates the lock
>           contention issues on the virtual swap layer.
>     * Re-use swap table for the reverse mapping.
>     * Remove CONFIG_VIRTUAL_SWAP.

I really do think we better make this optional, not a replacement or
mandatory. There are many hard to evaluate effects as this
fundamentally changes the swap workflow with a lot of behavior changes
at once. e.g. it seems the folio will be reactivated instead of
splitted if the physical swap device is fragmented; slot is allocated
at IO and not at unmap, and maybe many others. Just like zswap is
optional. Some common workloads would see an obvious performance or
memory usage regression following this design, see below.

>     * Reducing the size of the swap descriptor from 48 bytes to 24
>       bytes, i.e another 50% reduction in memory overhead from v2.

Honestly if you keep reducing that you might just end up
reimplementing the swap table format :)

> This patch series is based on 6.19. There are a couple more
> swap-related changes in the mm-stable branch that I would need to
> coordinate with, but I would like to send this out as an update, to show
> that the lock contention issues that plagued earlier versions have been
> resolved and performance on the kernel build benchmark is now on-par with
> baseline. Furthermore, memory overhead has been substantially reduced
> compared to the last RFC version.

Thanks for the effort!

> * Operationally, static provisioning the swapfile for zswap pose
>   significant challenges, because the sysadmin has to prescribe how
>   much swap is needed a priori, for each combination of
>   (memory size x disk space x workload usage). It is even more
>   complicated when we take into account the variance of memory
>   compression, which changes the reclaim dynamics (and as a result,
>   swap space size requirement). The problem is further exarcebated for
>   users who rely on swap utilization (and exhaustion) as an OOM signal.

So I thought about it again, this one seems not to be an issue. In
most cases, having a 1:1 virtual swap setup is enough, and very soon
the static overhead will be really trivial. There won't even be any
fragmentation issue either, since if the physical memory size is
identical to swap space, then you can always find a matching part. And
besides, dynamic growth of swap files is actually very doable and
useful, that will make physical swap files adjustable at runtime, so
users won't need to waste a swap type id to extend physical swap
space.

> * Another motivation is to simplify swapoff, which is both complicated
>   and expensive in the current design, precisely because we are storing
>   an encoding of the backend positional information in the page table,
>   and thus requires a full page table walk to remove these references.

The swapoff here is not really a clean swapoff, minor faults will
still be triggered afterwards, and metadata is not released. So this
new swapoff cannot really guarantee the same performance as the old
swapoff. And on the other hand we can already just read everything
into the swap cache then ignore the page table walk with the older
design too, that's just not a clean swapoff.

> struct swp_desc {
>         union {
>                 swp_slot_t         slot;                 /*     0     8 *=
/
>                 struct zswap_entry * zswap_entry;        /*     0     8 *=
/
>         };                                               /*     0     8 *=
/
>         union {
>                 struct folio *     swap_cache;           /*     8     8 *=
/
>                 void *             shadow;               /*     8     8 *=
/
>         };                                               /*     8     8 *=
/
>         unsigned int               swap_count;           /*    16     4 *=
/
>         unsigned short             memcgid:16;           /*    20: 0  2 *=
/
>         bool                       in_swapcache:1;       /*    22: 0  1 *=
/

A standalone bit for swapcache looks like the old SWAP_HAS_CACHE that
causes many issues...

>
>         /* Bitfield combined with previous fields */
>
>         enum swap_type             type:2;               /*    20:17  4 *=
/
>
>         /* size: 24, cachelines: 1, members: 6 */
>         /* bit_padding: 13 bits */
>         /* last cacheline: 24 bytes */
> };

Having a struct larger than 8 bytes means you can't load it
atomically, that limits your lock design. About a year ago Chris
shared with me an idea to use CAS on swap entries once they are small
and unified, that's why swap table is using atomic_long_t and have
helpers like __swap_table_xchg, we are not making good use of them yet
though. Meanwhile we have already consolidated the lock scope to folio
in many places, holding the folio lock then doing the CAS without
touching cluster lock at all for many swap operations might be
feasible soon.

E.g. we already have a cluster-lockless version of swap check in swap table=
 p3:
https://lore.kernel.org/linux-mm/20260128-swap-table-p3-v2-11-fe0b67ef0215@=
tencent.com/

That might also greatly simplify the locking on IO and migration
performance between swap devices.

> Doing the same math for the disk swap, which is the worst case for
> virtual swap in terms of swap backends:

Actually this worst case is a very common case... see below.

> 0% usage, or 0 entries: 0.00 MB
> * Old design total overhead: 25.00 MB
> * Vswap total overhead: 2.00 MB
>
> 25% usage, or 2,097,152 entries:
> * Old design total overhead: 41.00 MB
> * Vswap total overhead: 66.25 MB
>
> 50% usage, or 4,194,304 entries:
> * Old design total overhead: 57.00 MB
> * Vswap total overhead: 130.50 MB
>
> 75% usage, or 6,291,456 entries:
> * Old design total overhead: 73.00 MB
> * Vswap total overhead: 194.75 MB
>
> 100% usage, or 8,388,608 entries:
> * Old design total overhead: 89.00 MB
> * Vswap total overhead: 259.00 MB
>
> The added overhead is 170MB, which is 0.5% of the total swapfile size,
> again in the worst case when we have a sizing oracle.

Hmm.. With the swap table we will have a stable 8 bytes per slot in
all cases, in current mm-stable we use 11 bytes (8 bytes dyn and 3
bytes static), and in the posted p3 we already get 10 bytes (8 bytes
dyn and 2 bytes static). P4 or follow up was already demonstrated
last year with working code, and it makes everything dynamic
(8 bytes fully dyn, I'll rebase and send that once p3 is merged).

So with mm-stable and follow up, for 32G swap device:

0% usage, or 0/8,388,608 entries: 0.00 MB
* mm-stable total overhead: 25.50 MB (which is swap table p2)
* swap-table p3 overhead: 17.50 MB
* swap-table p4 overhead: 0.50 MB
* Vswap total overhead: 2.00 MB

100% usage, or 8,388,608/8,388,608 entries:
* mm-stable total overhead: 89.5 MB (which is swap table p2)
* swap-table p3 overhead: 81.5 MB
* swap-table p4 overhead: 64.5 MB
* Vswap total overhead: 259.00 MB

That 3 - 4 times more memory usage, quite a trade off. With a
128G device, which is not something rare, it would be 1G of memory.
Swap table p3 / p4 is about 320M / 256M, and we do have a way to cut
that down close to be <1 byte or 3 byte per page with swap table
compaction, which was discussed in LSFMM last year, or even 1 bit
which was once suggested by Baolin, that would make it much smaller
down to <24MB (This is just an idea for now, but the compaction is
very doable as we already have "LRU"s for swap clusters in swap
allocator).

I don't think it looks good as a mandatory overhead. We do have a huge
user base of swap over many different kinds of devices, it was not
long ago two new kernel bugzilla issue  or bug reported was sent to
the maillist about swap over disk, and I'm still trying to investigate
one of them which seems to be actually a page LRU issue and not swap
problem..  OK a little off topic, anyway, I'm not saying that we don't
want more features, as I mentioned above, it would be better if this
can be optional and minimal. See more test info below.

> We actually see a slight improvement in systime (by 1.5%) :) This is
> likely because we no longer have to perform swap charging for zswap
> entries, and virtual swap allocator is simpler than that of physical
> swap.

Congrats! Yeah, I guess that's because vswap has a smaller lock scope
than zswap with a reduced callpath?

>
> Using SSD swap as the backend:
>
> Baseline:
> real: mean: 200.3s, stdev: 2.33s
> sys: mean: 489.88s, stdev: 9.62s
>
> Vswap:
> real: mean: 201.47s, stdev: 2.98s
> sys: mean: 487.36s, stdev: 5.53s
>
> The performance is neck-to-neck.

Thanks for the bench, but please also test with global pressure too.
One mistake I made when working on the prototype of swap tables was
only focusing on cgroup memory pressure, which is really not how
everyone uses Linux, and that's why I reworked it for a long time to
tweak the RCU allocation / freeing of swap table pages so there won't
be any regression even for lowend and global pressure. That's kind of
critical for devices like Android.

I did an overnight bench on this with global pressure, comparing to
mainline 6.19 and swap table p3 (I do include such test for each swap
table serie, p2 / p3 is close so I just rebase and latest p3 on top of
your base commit just to be fair and that's easier for me too) and it
doesn't look that good.

Test machine setup for vm-scalability:
# lscpu | grep "Model name"
Model name:          AMD EPYC 7K62 48-Core Processor

# free -m
              total        used        free      shared  buff/cache   avail=
able
Mem:          31582         909       26388           8        4284       2=
9989
Swap:         40959          41       40918

The swap setup follows the recommendation from Huang
(https://lore.kernel.org/linux-mm/87ed474kvx.fsf@yhuang6-desk2.ccr.corp.int=
el.com/).

Test (average of 18 test run):
vm-scalability/usemem --init-time -O -y -x -n 1 56G

6.19:
Throughput: 618.49 MB/s (stdev 31.3)
Free latency: 5754780.50us (stdev 69542.7)

swap-table-p3 (3.8%, 0.5% better):
Throughput: 642.02 MB/s (stdev 25.1)
Free latency: 5728544.16us (stdev 48592.51)

vswap (3.2%, 244% worse):
Throughput: 598.67 MB/s (stdev 25.1)
Free latency: 13987175.66us (stdev 125148.57)

That's a huge regression with freeing. I have a vm-scatiliby test
matrix, not every setup has such significant >200% regression, but on
average the freeing time is about at least 15 - 50% slower (for
example /data/vm-scalability/usemem --init-time -O -y -x -n 32 1536M
the regression is about 2583221.62us vs 2153735.59us). Throughput is
all lower too.

Freeing is important as it was causing many problems before, it's the
reason why we had a swap slot freeing cache years ago (and later we
removed that since the freeing cache causes more problems and swap
allocator already improved it better than having the cache). People
even tried to optimize that:
https://lore.kernel.org/linux-mm/20250909065349.574894-1-liulei.rjpt@vivo.c=
om/
(This seems a already fixed downstream issue, solved by swap allocator
or swap table). Some workloads might amplify the free latency greatly
and cause serious lags as shown above.

Another thing I personally cares about is how swap works on my daily
laptop :), building the kernel in a 2G test VM using NVME as swap,
which is a very practical workload I do everyday, the result is also
not good (average of 8 test run, make -j12):
#free -m
               total        used        free      shared  buff/cache   avai=
lable
Mem:            1465         216        1026           0         300       =
 1248
Swap:           4095          36        4059

6.19 systime:
109.6s
swap-table p3:
108.9s
vswap systime:
118.7s

On a build server, it's also slower (make -j48 with 4G memory VM and
NVME swap, average of 10 testrun):
# free -m
               total        used        free      shared  buff/cache   avai=
lable
Mem:            3877        1444        2019         737        1376       =
 2432
Swap:          32767        1886       30881

# lscpu | grep "Model name"
Model name:                              Intel(R) Xeon(R) Platinum
8255C CPU @ 2.50GHz

6.19 systime:
435.601s
swap-table p3:
432.793s
vswap systime:
455.652s

In conclusion it's about 4.3 - 8.3% slower for common workloads under
global pressure, and there is a up to 200% regression on freeing. ZRAM
shows an even larger workload regression but I'll skip that part since
your series is focusing on zswap now. Redis is also ~20% slower
compared to mm-stable (327515.00 RPS vs 405827.81 RPS), that's mostly
due to swap-table-p2 in mm-stable so I didn't do further comparisons.

So if that's not a bug with this series, I think the double free or
decoupling of swap / underlying slots might be the problem with the
freeing regression shown above. That's really a serious issue, and the
global pressure might be a critical issue too as the metadata is much
larger, and is already causing regressions for very common workloads.
Low end users could hit the min watermark easily and could have
serious jitters or allocation failures.

That's part of the issue I've found, so I really do think we need a
flexible way to implementa that and not have a mandatory layer. After
swap table P4 we should be able to figure out a way to fit all needs,
with a clean defined set of swap API, metadata and layers, as was
discussed at LSFMM last year.

