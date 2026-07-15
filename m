Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B5AEC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367286B0099; Wed, 15 Jul 2026 00:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317836B009D; Wed, 15 Jul 2026 00:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206416B009E; Wed, 15 Jul 2026 00:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D31BA6B0099
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:04:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 514631205B1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:04:22 +0000 (UTC)
X-FDA: 84989668764.01.59D7303
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 02BA01C0003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:04:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bIe4+f+H;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784088260;
	b=MK8aOgyuBOehdN8ipnf/jp5REMz6eJCKmwC5/kJKoY1lhTW3uPaua56bM8dDOhGeh79+8Z
	cuwR0lFOuZwyPD++srh5M07o+jDPiSSF/vwT/WLWNniHQ1agiWgNMvxRZ6cE9y/rRHRhWx
	dR1QPOhc9W5Sye//quxtUz3eJaOiFGQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bIe4+f+H;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784088260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rH41fwMQHzUYIu6gTUt3+s8hao9usLK+f5RMSL/O0OE=;
	b=gA4K4XtNA6o/1m0G0AaXKHvdetkXeg9yjGg62d/06cl9Vr7wY56AmmeSMJp4lBgLlathjC
	2vzfX6lORUyNpJV/X3kd73/QRR/V/T7UNjU6x4aOMbn7Kn3ctGG4zuLN1DvUWyjwa2vMVB
	BwMjwQKdDhyBjvexanPhPRncF8Pyi9U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784088259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rH41fwMQHzUYIu6gTUt3+s8hao9usLK+f5RMSL/O0OE=;
	b=bIe4+f+HrwZjIC3sJfbEL3Po+ElxqxuBEylY6vThI9NpURqEb9mJn5kvrsWLkEsOSh1PDi
	5bQjyx78BP3Ukjs2LLE1sG83V2tAlNJYavrlHw8rLKZzPIdKjuSWZhQnbbiRZNs01gHWAg
	SaHtXX5sZqjx64ZBhHBE17V4k96j1Fk=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-YvYks8uXOvCRCXIYDk5VNQ-1; Wed, 15 Jul 2026 00:04:17 -0400
X-MC-Unique: YvYks8uXOvCRCXIYDk5VNQ-1
X-Mimecast-MFC-AGG-ID: YvYks8uXOvCRCXIYDk5VNQ_1784088256
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-39abd6b0c78so7968861fa.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784088256; x=1784693056;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rH41fwMQHzUYIu6gTUt3+s8hao9usLK+f5RMSL/O0OE=;
        b=hD98pgWlZUzVq1gq+kBS8ZW74hThvuW8XURXD5IyDOR4sf56wyxJ5sBCiyJeUBadRx
         Y67ej/DRIhb0f2jvdyXJBEh3L77UhwS2O9Bdfpgnt3s3Lllwwaov/gZw5p5cuFyFzhOE
         A2FwxvnSWPR7KOdfpzaQKdXPLM1sQWoL2uiUN/QE2bKN6cPZGPGDmd9uQdEDsBW4+9RJ
         KpzftJiwl2wMihXBqJGc52GNwMh0R4ORZgMssbkKI/v0sP84a9NIBXkOEGK28arIvZsk
         DxfW3a19HfVLL3zpkt6U07fZ95l30Na+S0rTwGRCy+EKBtpZGtO8/Qabg2wNxhTnJyhC
         BuYA==
X-Forwarded-Encrypted: i=1; AHgh+Rr5xtWUTaaNAByBK4RMWiWliqjC9kuapV4ZgErUEQvoL70inQ2IcS28ObOfjUE5P4t1j31y+s1IuA==@kvack.org
X-Gm-Message-State: AOJu0YzNIfvDudZ6/zxysn7plAXNV9ONB3jBENpcBfgUMqjsDdey5Ung
	qj1E9yu1eFUDahf0wYlh6aEyTTMKFByi6KDoCBASuN3jA8kG+WdtRx0vAfjZOQFXRI4zh0YWueR
	SsoQawWCxqY6BC6NKZTWxBaP9UoIYVn5LrXcYHROi/QEq6vrXfBO5Cio8HEkTW9bsEpjFG4z81k
	BM8HlFnBwbRzcO52hQllEirBKrxHI=
X-Gm-Gg: AfdE7cmteJ070DqWWTPKwypO9ho03FF6E3EVRxOr+2N3w2jvh3hvWcS1xvEkxhA0LIl
	OLYoxyEjN0x6Ol+bmZUKPaVwdOiK3gyOA3LRK0dSZ7yzPNXgRznIdIfiNvbiVc9NvzGgBzGORen
	e8Xv6a4EFgauXRkp4aCfserMQfnfL8TfKzTpU0oOCl+RsgVq8o6wnbkFl7nO28Hbny
X-Received: by 2002:a2e:9812:0:b0:39c:677c:8492 with SMTP id 38308e7fff4ca-39c94c3f33amr27740141fa.13.1784088254831;
        Tue, 14 Jul 2026 21:04:14 -0700 (PDT)
X-Received: by 2002:a2e:9812:0:b0:39c:677c:8492 with SMTP id
 38308e7fff4ca-39c94c3f33amr27739911fa.13.1784088254254; Tue, 14 Jul 2026
 21:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com> <20260609172719.803537-1-usama.arif@linux.dev>
In-Reply-To: <20260609172719.803537-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 14 Jul 2026 22:05:31 -0600
X-Gm-Features: AUfX_mxAhc1Bv761Jc1uQW1A2zX6aSuIHHc8y6wnhBmDS4BiVEszC5e_cJSQeA4
Message-ID: <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>, ljs@kernel.org, 
	david@kernel.org
Cc: xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, yuzhao@google.com, aarcange@redhat.com, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z_-5imj6r2vdONXnT5eo1zMjmxwXI0cYjsMkaej9Qc8_1784088256
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02BA01C0003
X-Stat-Signature: zo86p1pcjcw9xdoz6145583rrunsrfop
X-HE-Tag: 1784088259-115663
X-HE-Meta: U2FsdGVkX188XfB0vMA8diUIXPXL9pDx87SZakgOjWSUddjwhvswj1e7s4b2g4lfH7KaT8JwiV58JCZX+MP9GEyCIfeQxwz0wmOYKxafV0KVWokMQL6wIaxTc1b5vxzCbRYXjt/Z+LyLTA6+1tnTeLxhWHRKFsqQ8O5WeGXOs7VZg4MQPNfvzcZIhsNJMutRAKcpZO9JgckGWyo3NysN3xGEQJRmAskSRZzwgTJtrx2GAhlkNQ91Ge4wCPnPnf2bzut4ElZ2dlHepU+ZUgZ4OpvqBL4iy3dC4tXeF5PVTPOiQoU6edhWCZ/2Ahh99yGlEEN7Q5fDVSmQmSXFXah/1bL/MVwjBWMqOQ6qI/84Ej4v1wt4v4rRk5B28imiUbgY6Uaf0j6pz1aJp37fojWNe2CfNP2TQCeI548KE3cgGJQ5B69PoU0ITPq8+Q2KfYQDI6GBGjsWXvylufpT0JTb35SDe8u5zGYcJbyYkhz9HlwjM+IPRYyk1+rJje5QHAWZFPMBjyXkDjRSvZIjuontQxtNZfnSfWM6RDppI5IbmwnIuSQzg/CuB8VNUMwhqtWygsl9mhMU1t04qUveu3QxTjOXXzrXfkHFjy46WCL5stMHpsuPXoZYRAYmy8KuTE19b7/40AfqM8+XNeTBpoDHv98P2U+vDXhj5LfhoUOT2vuZrp7ugk6HFx2Tssgec8nvOfgsjSAYBPNSxRz3u/1R4tKp5Y/BhlKqSO0NXmh7WPOYw4kIfop2mGAG4FnuJsjn4ihfmpxNZSs9pSoRVu0S1nz/7oXF1OiNyQWxIqUEntyYMZbpCzsg9gpIzAvSaXd0yfkU7VYfHQftaqBglA0f4iMt4p2kuycKPormp1FJqmWH2goSXozp2Y277KMGfSFQ2atLJdYGypL2m6x2VxbT5PQfUTfYy5v27nxWmFluh0X0RgIcjQKIqkv6HzJbSHFZ5wu6DxWLTzvdzY0vqAG
 F4frHdCp
 /Hu0rf+tjb6ZNpwtkXXdF6Zhlh0K9H7sNxqCMlxhrJAjaAe2LdYMQKAJbNXVSLA/w8CCibvqwX2jdJ2Z8M3RReX6YwilY6DsAytwy08lm8JnGPovnU09Y395U0lno/MBg+eKcbwmzK/Xid0Jop8gnUivogHK/S60EIVyqn93xOTfTqdts+c6vLUIcmCZH16W/+rF+kN5ZJgloACs5ina3npJRUWidhCqn0qXTf7SanV5yaCe5gULZj+Oa+AqXjjcTKYejzoSOrXuH3rRFMUKLBWhZMCNsLJywsxJoTYA4T3TAG8IOFhWQmpyUtiTa807L8UShFzmNl38w2MnvN4mWdX1F45UkUdW8e8bQXEqj1T26IfF1rMnYy85mZNSJz7FeocWdLcauevdHxsY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 11:27=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> On Tue, 09 Jun 2026 10:07:20 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
> > On 9 Jun 2026, at 9:47, xu.xin16@zte.com.cn wrote:
> >
> > >>>> Since commit b1f202060afe ("mm: remap unused subpages to shared ze=
ropage
> > >>>> when splitting isolated thp"), splitting an anonymous THP remaps a=
ll
> > >>>> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZER=
OPAGE.
> > >>>> This flag is set unconditionally for every anonymous folio split,
> > >>>> including splits triggered by KSM.
> > >>>>
> > >>>> When KSM is enabled with THP=3Dalways, this causes two regressions=
:
> > >>>>
> > >>>> 1. use_zero_pages=3D1: KSM calls try_to_merge_one_page() which tri=
ggers
> > >>>>   split_huge_page(). The split remaps all 512 zero-filled subpages=
 to
> > >>>>   the shared zeropage at once, freeing the entire 2MB THP when KSM=
 only
> > >>>>   intended to process a single 4KB page. This bypasses KSM's
> > >>>>   pages_to_scan rate limiting, causing ~1GB to be freed almost
> > >>>>   instantly.
> > >>>>
> > >>>
> > >>> Why do you see it as regressions?
> > >>
> > >> Since the zero-page remapping was introduced our test has shown the
> > >> following behavior changes:
> > >>
> > >> With use_zero_pages=3D0, the merge rate drops from 60MB/s to ~6 MB/s
> > >> even after raising pages_to_scan. The KSM merging is now much slower
> > >> and CPU utilization has increased.
> > >>
> > >> With use_zero_pages=3D1, ~1 GB is freed almost instantly, and it no
> > >> longer respects the pages_to_scan behavior.
> > >>
> > >> Even with just this patch (1 & 2) or the RFC linked in the cover
> > >> letter, the issue no longer occurs.
> > >
> > > Understood. You're saying that the additional processing action in sp=
lit_huge_page
> > > (remap unused subpages to shared zeropage) increases the scanning cos=
t of ksmd.
> > >
> > > However, I still wouldn't simply classify this as a performance regre=
ssion,
> > > because commit b1f202060afe increases memory savings through this act=
ion =E2=80=94 so
> > > it saves memory at the cost of additional CPU overhead.
> > >
> > > If you want to address the increased overhead on ksmd, I think we cou=
ld add a
> > > check for the shared zeropage in cmp_and_merge_page, and skip merging=
 when a
> > > shared zeropage is detected.
> > >
> > >>>
> > >>> AFAIU, KSM and THP do often conflict with each other. THP tries har=
d to collapse
> > >>> a huge page (which may contain many zero pages). If KSM is enabled =
and part of
> > >>> that huge page is mergeable, it can easily be split by KSM, renderi=
ng THP's
> > >>> efforts futile.
> > >>>
> > >>> Therefore, in our actual production environment, we typically avoid=
 making the
> > >>> same region both KSM mergeable and THP always.
> > >>
> > >> THP=3Dalways is a global setting used in many production environment=
s,
> > >> so these features now interact very poorly together.
> > >>
> > >
> > > Actually, I have long thought about submitting a patch: add a new int=
erface
> > > 'skip_huge_page' under KSM's sysfs, allowing users to choose not to s=
plit huge pages.

This would be a good intermediate solution while allowing backward
compatibility.

> >
> > Just think out loud. Or just skip huge pages all the time unless memory=
 pressure
> > is present. Basically treat KSM as a way of reducing memory pressure by=
 merging
> > pages.

Hmm interesting. We should decide on future changes before committing
to one direction; however, i think the immediate solution would be
what I currently have prepped for v2.

My v2 follows my RFC alternative approach: skip zeropage remapping if
the split comes from KSM. It also contains the patch (3) from this
version, which skips zeropage remapping if the shrinker is disabled.

>
> I do agree with this. I questioned about if it even makes sense to split =
THP
> with KSM in RFC (https://lore.kernel.org/all/20260510114001.600681-1-usam=
a.arif@linux.dev/)

This is indeed a good question but I don't know the right solution.

Perhaps we can discuss it here.

So far here are the potential solutions:
a) skip zeropage remapping if the split comes from KSM
b) skip zeropage remapping completely if the shrinker is disabled
c) Disable KSM THP splitting completely
d) add a skip_huge_page sysfs toggle
e) only scan THPs when memory pressure is present

(a)+(b) would be my V2 which I can send out whenever.

(c) is the nuclear option, but perhaps KSM for THP is rather
inefficient and pointless

(d) could be used with (a) and (b) and allows more flexibility than (c)

(e) is a more dynamic approach, and could be combined with (b) and (d)

Let me know what you think :)
-- Nico

>
>
> >
> > Best Regards,
> > Yan, Zi
> >
>


