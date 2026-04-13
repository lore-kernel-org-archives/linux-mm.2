Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AB0EBFD18
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 08:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B85A6B0089; Mon, 13 Apr 2026 04:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F096B008A; Mon, 13 Apr 2026 04:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5706B0092; Mon, 13 Apr 2026 04:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4725F6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 04:46:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E31CFBDA71
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:46:40 +0000 (UTC)
X-FDA: 84652901760.22.027542F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9BDD24000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:46:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FJVqbGSq;
	spf=pass (imf12.hostedemail.com: domain of liwan@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776069998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0213UnEMOod9W6HJe+rSGORixl1p8NPdPniRuWrrH0=;
	b=isEuEVplvEhwaPFljhLvkFeZZqVsqDZBZu9E8azGeJt2eylZBVhawqUkFn0VOufs2LzEa2
	1dBCL7fzhjpoSefA8Rqkok/uNFHu0eZ3RQrCTOUxPemED8bUa2Q6Aa2sY8xdB7i6hHnmpk
	f1ayJwQ7NF0rXt8XASlkH2Lvdyxc8Dg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776069998; a=rsa-sha256;
	cv=none;
	b=8RzW+YRklT3cu+m/D1LcAToUnU/SwELMc+2PHyGYbtRPcS4lEnp7hMyKwbMue+6SPWtwnY
	LAtJWN5aQ/0ZTX3Vt6kqAh+zz6P23dd2P795OnntY94Qqk8hJ1B1JM8bAUc+MoMRhcSRa8
	r4LF+Jlus/D23sX8lxSif3gkj/9FoHM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FJVqbGSq;
	spf=pass (imf12.hostedemail.com: domain of liwan@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776069998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o0213UnEMOod9W6HJe+rSGORixl1p8NPdPniRuWrrH0=;
	b=FJVqbGSqWxRJXDdxh8Cr++cRVSjl36LQbwcPDsanhfT5nAwW3hX63k2dhwhFkrX63txy2b
	2J3ZGvqKJCaZR4rIrCtgVMWHDjZvj+IzSz1yx24xYRedd4DxfPtI+RLTzWQDahyN2K4iLq
	kKs4MazZxaFrvvMuj49ylslMUaLnYfY=
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com
 [74.125.82.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-NbsqBDdaNpunpWAZspCEYw-1; Mon, 13 Apr 2026 04:46:34 -0400
X-MC-Unique: NbsqBDdaNpunpWAZspCEYw-1
X-Mimecast-MFC-AGG-ID: NbsqBDdaNpunpWAZspCEYw_1776069994
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2bdf75bc88fso5873598eec.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:46:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776069993; x=1776674793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o0213UnEMOod9W6HJe+rSGORixl1p8NPdPniRuWrrH0=;
        b=sFdAZfehhAaDkX9o+OcBuBGkywodehAXEcve6EbuJipzp+S4VzYBhZb6oFRfF6arX1
         iU8bJcLWq4hzC+0aIT85TyKazo/bfsj6zItQjOB5YjPyod9KLuVHJpELoiLSLLlL43YT
         wweUoyL8LDAvqYu8rtiRFnLniSQqSDFpHF0CMMlB7DDtA3WvUdig4qX1PxSn7Kg9Cb6W
         LDCb6dxjL3PYNi/tHJNZ+Ad6pOgHwFGZPlPoT9Yb3zOOClRrwQ+RLoN5hLPJvTMjAIT1
         epo5ozEH/i4+W5t0YlQqGIrycJ4qN3r4FAaC21mDCo6KsQQQDNhsJBZLSiJmTmbM15Nu
         4+Pg==
X-Forwarded-Encrypted: i=1; AFNElJ9HKesy6dLUvAeVYZqlYd5AccCqSA/eTI/XNxbDPqPmDitrg8ek2/al0x1hOHEccATsIMJNDwK8gw==@kvack.org
X-Gm-Message-State: AOJu0YyJkNwOW61VPhpZkpQ6UDuUktIBzLAGOUVNvsN6ihqfid36zdhg
	5bNsfqVe9+mDA/oURfsTUtfrP9Mjr9dJZAoo0qJlOmgyeVYdPnF3eKg4SupJV2Vccfb3mD7s4BS
	fvxy54o2MA/0U24plANScz0M70njHcjWxpk9enPwE8OaG2kYJYSYTzuWPa3OFj0/nk+BGuEPaF3
	pEYEypnbjEj3AFi06iKlGx2US2F6w=
X-Gm-Gg: AeBDietxznHGBnl6MY73WXjbcuOEaPtlYStBxrRyji85vE0TcD/nUN4QNlfpMLsJyGN
	UyYT6dER7i5iIihqYo8MCujHP3cnc8rUz9Rkwazuo47WewTfOqPlyjMUZwY+nPPJt+/H/fSwiJ5
	5dLKQ3uDXGfozIwOcBLnd47nWz0i/THGCSGzUOoZXVbg9hJRO8WLV+trzVXJ8ralykjBNVkIP4N
	ADooA==
X-Received: by 2002:a05:7301:fa0e:b0:2c4:b8d6:45d3 with SMTP id 5a478bee46e88-2d5877991cdmr6669870eec.10.1776069993430;
        Mon, 13 Apr 2026 01:46:33 -0700 (PDT)
X-Received: by 2002:a05:7301:fa0e:b0:2c4:b8d6:45d3 with SMTP id
 5a478bee46e88-2d5877991cdmr6669840eec.10.1776069992889; Mon, 13 Apr 2026
 01:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260402063714.55124-1-liwang@redhat.com> <20260402063714.55124-7-liwang@redhat.com>
 <CAKEwX=M150Hw0Ncs69SCWRr7J+vK5F0biotkz=MSFvFG3rgjow@mail.gmail.com>
In-Reply-To: <CAKEwX=M150Hw0Ncs69SCWRr7J+vK5F0biotkz=MSFvFG3rgjow@mail.gmail.com>
From: Li Wang <liwang@redhat.com>
Date: Mon, 13 Apr 2026 16:46:19 +0800
X-Gm-Features: AQROBzATy_Du7HEcqoEpfm3ecefJ913kdNeZVB-cXtC9R6JcAITrAGqsNlgA3uk
Message-ID: <CAEemH2e76jseObPh5oj7H7KB9kJeucWeb5zSy_f74YMy-HcShA@mail.gmail.com>
Subject: Re: [PATCH v6 6/8] selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink
 on large pagesize system
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, yosry@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, 
	mhocko@suse.com, shuah@kernel.org, chengming.zhou@linux.dev, 
	longman@redhat.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosryahmed@google.com>, liwang <wangli.ahau@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VmJsSU_VxAAEl3xgRYOsqvL63f_YAeQBxeP70m7tdWk_1776069994
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9BDD24000A
X-Stat-Signature: 5ipa9qxibojcjybssrp3sfp16jdk3rq6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776069998-881795
X-HE-Meta: U2FsdGVkX1/XJxau0X/yDxKc+fdOqPvYw0iHKMViRxAB2gSoBznhCRIHzVILBsCLUa/jzv3xmqu/MOtIGxKWumgeFoX4aDpHoE91txihJiqkFBZaXd08WEqgdREEQpDP8bJI0TjfTKjaJk9ys7yuwtcl3LiJ7UO1H/LtKThsHSDLmmd4WbfW5GIkvXn0PkOUNqFPWOKFZfhKx+PsqpDvfh9oDKzmgt8pCoYno0mwIQ3baVbKVt422E+FD4UXWr7gmX+N9BHc/U6R42HLfXojX964im6dF6mQObZzQqSBlvQU5hDuwjed+qeR1a/K/s+NGWDC7bA0cAXmkGiCh/Hp4dhP1gTjnDYl4CMpbbgPDGtpc8alhhWx9lqZeG9kT76p0P/V7kZFNhd9lq0alIsP17FZfylQSn4Z69QWRAD7I6cCmHYEdES8inFtbe71OBBfCH6hawC1C7QLbH/MqK1I22kHIUU9M4VjEYjm5WA15XIrT6kyluXUhj9BT+5XqX4vK4kBma7U0y1ugsMPtipW2qoHw9SUCX8/pAYdV1jdbB85aFxboElAEfO/pwYt3bDFzUz34M9J6MWzWlzcF+O7wuzczZynWIwOpmtNfCHlsCqcOTu2II9CSCZy6TgwsJgNF1TFfdBJrfSUol9sock83abgcjIzm/t5sdOrml31zSDXcMAF10IbYRkOXvUrbgMmGn7gXE0OMvX2DjKq5wEBq3YrtPGQUUePVwNChfBb6eAjA4nXsyX6vvAdahu0b6heQzYO3wSbR2VZj8vZU7h+z8+CYJwTpKPeQM4BAzQ2SLayEIrnEWUi0ZEDfoDTwaEzBmAPXQ6qDXusYdUBfhToFxQOwRH1+iS4yqC/g9UwhxpG4C9OJf7ahyDLmqZKcQMh+QT/LFLFNlM55oXrJd8jISs11EkANc7ftVFDKK1usSlC/onXehZHF0zChImEO3FIZaw9C/LK94Vtk4JNUNS
 dQr/I/K3
 n5u9f7wMGqEe+ZRrCvksSzXJoxBZVruDmQy5gTDZfNG/M1YwbThfsrWpy5c9eh1C0IVaG5ek8zjSdB8W5mdiQtLWcd4E/MCO6g/hmTUNkiuHNBa9l2zEZ0eumDJIPEv+pmMrXstaNgy9lODeUv2dGJyS8ACyIxTNSpbQhvIiTQMeJB35zcwhT5EMifgde6bdOoqx84cuu21WbCxNNiklpupcFJPqFRLxF1cSQREliRy48Veuo3nc8XakcxTEydse7Hnko9Jgn9ArxbK895RsiLvZBoQFOVLwziWgnIH1iv0NXUDxMe4o8O+/kHK71EByrgiS5ueKE8YJ3LnBb/sJwBG+h8oOW4UyEs39L7nC219ttaswLLIkOai++ulPSdfm+R/rA+yTBbfvEmUkIrsrt6uiLAGiureU7lMAReb2W+R1FQxvXaSB8KCOU4t53D1pncRmGwGGxKKlL/71fnOYt/ZwuzvTOYEduiXNqGsPlLYwRsQulM7uxtx5U0qKvk2jvDoq6cxeUQZi79uc7RGzJ0W5uMZgNLVMf7evKbc0ts6TPoqimMJJJZE1Ww0OQkiONvvTsJtDonYa9BLZn9wvpGRos9OytiIJg1L1Tury/LLbpyP1oFyI00CuQNK4wNesO0Zc/c0+wOw6nP8KZKr8JtWkKmFxRa4gqayTG0O/Q4PqOwcJ+LO4b1anbYgCHiIFbdHFEikh5gKKjiambpkQYiBrsgYoEOyGY1SxqGePXlQEKLtx9MKlHCchDUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 8:29=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Apr 1, 2026 at 11:38=E2=80=AFPM Li Wang <liwang@redhat.com> wrote=
:
> >
> > test_no_invasive_cgroup_shrink sets up two cgroups: wb_group, which is
> > expected to trigger zswap writeback, and a control group (renamed to
> > zw_group), which should only have pages sitting in zswap without any
> > writeback.
> >
> > There are two problems with the current test:
> >
> > 1) The data patterns are reversed. wb_group uses allocate_bytes(), whic=
h
> >    writes only a single byte per page =E2=80=94 trivially compressible,
> >    especially by zstd =E2=80=94 so compressed pages fit within zswap.ma=
x and
> >    writeback is never triggered. Meanwhile, the control group uses
> >    getrandom() to produce hard-to-compress data, but it is the group
> >    that does *not* need writeback.
> >
> > 2) The test uses fixed sizes (10K zswap.max, 10MB allocation) that are
> >    too small on systems with large PAGE_SIZE (e.g. 64K), failing to
> >    build enough memory pressure to trigger writeback reliably.
> >
> > Fix both issues by:
> >   - Swapping the data patterns: fill wb_group pages with partially
> >     random data (getrandom for page_size/4 bytes) to resist compression
> >     and trigger writeback, and fill zw_group pages with simple repeated
> >     data to stay compressed in zswap.
> >   - Making all size parameters PAGE_SIZE-aware: set allocation size to
> >     PAGE_SIZE * 1024, memory.zswap.max to PAGE_SIZE, and memory.max to
> >     allocation_size / 2 for both cgroups.
> >   - Allocating memory inline instead of via cg_run() so the pages
> >     remain resident throughout the test.
> >
> > =3D=3D=3D Error Log =3D=3D=3D
> >  # getconf PAGESIZE
> >  65536
> >
> >  # ./test_zswap
> >  TAP version 13
> >  ...
> >  ok 5 test_zswap_writeback_disabled
> >  ok 6 # SKIP test_no_kmem_bypass
> >  not ok 7 test_no_invasive_cgroup_shrink
>
> I assume the test passed after fix? ;)

That's right! This patchset is targeted to thoroughly fix various bugs.
I rerun it too many times on various arches. All works well :).

> > Signed-off-by: Li Wang <liwang@redhat.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> > Cc: Muchun Song <muchun.song@linux.dev>
> > Cc: Nhat Pham <nphamcs@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >
> > Notes:
> >     v5:
> >         - Swap data patterns: use getrandom() for wb_group and simple
> >           memset for zw_group to fix the reversed allocation logic.
> >         - Rename control_group to zw_group for clarity.
> >         - Allocate memory inline instead of via cg_run() so pages remai=
n
> >           resident throughout the test.
> >
> >  tools/testing/selftests/cgroup/test_zswap.c | 70 ++++++++++++++-------
> >  1 file changed, 49 insertions(+), 21 deletions(-)
>
> LGTM. Thanks for fixing the tests :)
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>

Thanks a lot!


--=20
Regards,
Li Wang


