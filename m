Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885A5106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 22:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5546B0088; Thu, 12 Mar 2026 18:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96786B008A; Thu, 12 Mar 2026 18:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99716B008C; Thu, 12 Mar 2026 18:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BAA496B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:44:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 819231B7E75
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:44:50 +0000 (UTC)
X-FDA: 84538892340.18.0A5E7BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C81AC1C0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:44:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rA8piUuD;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773355488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kma/+9t4PzKNAzAya5hNCtBvXuUuO5Jw0yY7xb6jglI=;
	b=G4TFX+QgZQyB3FlHHHLj0MoTYHu4NyGzai5CgPmmsFSER2XABkwDyffd/GJBz+ROahSIz0
	XvcBAh8AjPGjK+9sZFwq5H50nDp9311wq824O5BU2PoOJiu6++1h+ScrVGq+dsHGt+X2Cm
	vbCVn264ubjtqgldXS+z9053NVl+fWI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773355488; a=rsa-sha256;
	cv=none;
	b=f2/asSiUD5BYGfZNlQ/CaLDVec9b87zvwjISjwdexqHH5hoIVyX/hA+a6CG0JOOAlITf/w
	rZTNHpmeasHUetz67FT6jIu500mUablzdNXuRlvXAMxdaOetOY1uW5/BOf+f8WfYZKjUob
	0/g1ALvTQhlUW6Z+2jF62l5CHCSzVWQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rA8piUuD;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3132261334
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D19C19425
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773355487;
	bh=PZ+ExTNvH3r1z7OlgBOP6Su9+77UcJ9UthTuCroOJOc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rA8piUuDVFXKQYUsfrjwk6SaEVW+aIAdCTLFC3sNlVOzwGiPKiQZU1ZBSikNbvUWt
	 4Acz8vgJGkGrocuoJVXBHZGhdvb3j3Fz7smyS2aHMocoCPqtL1Fa0EaYhflf5oJxx2
	 D+jLJGWHgUYTnQ5t11eseHtl1+dSi1QIDLVShM20IJMYOyUr1MZYC2qSDGDpKWv9Vh
	 VIMkPvixw1SBlKil0/ZRRTICkLZvbgqo4Pb++7CnAv4ffb546afArIAiPKQFKwjwnz
	 FtQEqjUjtkLlfXC43LtftVvAJ4uqgBMXXhC6G5u/BTcjRCPEA+jL1w3W/14We73tQ0
	 tCv4hxESzn3ew==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b96d784828bso232305966b.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:44:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUD9mrXmGM6R18R9ovY6nAzWspH7QMWSoOaHFJFV/1QjjmQ9kqg2x0LJ4/X0K3Y1w1E6vZgY6Qkhg==@kvack.org
X-Gm-Message-State: AOJu0YzrQ/vPNuyBTquG8hviERQ8/wQ9VM9vjdcSg0R2zTAkrfSQag9F
	EtD80cLJ6zgUgK5HK/lPLZ27j/2u7IluvzUIpfQLN1hRXH5uCMHkdPD7Y33JXtohb81aTtM1zwb
	to6lOrkjwwrnIR3pLVKlaELVInYxv030=
X-Received: by 2002:a17:906:3184:b0:b88:7431:3942 with SMTP id
 a640c23a62f3a-b97651d185emr51530266b.33.1773355486758; Thu, 12 Mar 2026
 15:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260312040627.55257-1-liwang@redhat.com> <20260312040627.55257-7-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-7-liwang@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 12 Mar 2026 15:44:35 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM=EHSsmkZMfc0TEqaviHUW=43=r_PW60enjaoxJXGgEw@mail.gmail.com>
X-Gm-Features: AaiRm524PNfkYxfVrpc2St54DerNH44DRfyB07Ocb7QbsQotuUYK5q2n16rFokU
Message-ID: <CAO9r8zM=EHSsmkZMfc0TEqaviHUW=43=r_PW60enjaoxJXGgEw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] selftest/cgroup: fix zswap attempt_writeback() on
 64K pagesize system
To: Li Wang <liwang@redhat.com>
Cc: mkoutny@suse.com, yosryahmed@google.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uhd9uajf1f9w3mpzj5c4w1en8ze7d4am
X-Rspam-User: 
X-Rspamd-Queue-Id: C81AC1C0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773355488-437147
X-HE-Meta: U2FsdGVkX18z5ZFhWSd09PLQY+jAFDiaMCiFWetpGOScntG5fOf3cjsjtMXnRjyx/nCWTZEyjcyV9XXOpq/PvRU3h/GHqLfZL1/KWxN/YU4IrG/PBKFNTmZqPSYTS7lCOuS5EBTFtmHsCDrZmZniIyfO1W/sokNu3DAEbPZPTB42KC7sqKtgxoF0Ncx0apG4SMTKYn9yebV8KEiBYP5bIWHjQtVpoGAAMrs9a7ns4NGmgr9UzlE62P10jvelXhCR5NcRdLKuciPHEZxOYnxm848a99Ts/nXRTL/ihJ81p3omflpBuHVoN1p947DEAPn8Q7ovm6+so8VdjEgfm3KtwGPxOT9IHSEYzjYm29OGwOpSwzJgNZkqZAt/WPpEZjNJ7OArn9oSr0S5Ia3Vi++9qi++0kXxmtChu21JswMT18UOBmloQsaEAZcyF90tCrQocx1ZrNxGtjvl41MnW/ddsl4ypjefWLqqW+8VCQy5GzM6NHujWbNxIOb3iqFN9YSnMFvmYVX+dsfmbymNdLNWdPSjES9h07ZMJ8RtCSAv2+Bi8LDAsZ/waVt3JOTCfRXX3ohko6LrchuG807gcS/2oTuHFifpWA49SB4nfZL1MgpkBbkI0877K6RrrUdXWX3L5dR9ju2WcIEAVXqY11wkL8eyWgmOB6JvyHJlx4vu4ZKsDVEyvuH/mVs6lH2o753kZSTB24MqOoBPu/54z/oz7mIzrR+V7nE1IpoaSelSvReAN1wn5Ooxloc6fVSRX1RoyyTzQJT8Cy6TXkQKYfvmQoWhlZVPhtOPPth85ALDymkOtVGcO9h+KqQ2p57EJzu8sIG/ewRjMfFeafUr9inlhTYTeBMUnKixp7d1AZ8NnEZZ4uwVNG6gqK/EUgsL9xbpXVcerW6skEPdmlEqYv7hSkcdIB0B8mDBJorSjKvYTQUE2nDK0Miixzs4K/kzRlmK8sVF7/bmbN5443kyR8G
 iUb36Rwn
 C3TpIrVSaqynbOB1PYDnPSNmtj3yZ+5sjEEfp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 9:07=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> In attempt_writeback(), a memsize of 4M only covers 64 pages on 64K
> page size systems. When memory.reclaim is called, the kernel prefers
> reclaiming clean file pages (binary, libc, linker, etc.) over swapping
> anonymous pages. With only 64 pages of anonymous memory, the reclaim
> target can be largely or entirely satisfied by dropping file pages,
> resulting in very few or zero anonymous pages being pushed into zswap.
>
> This causes zswap_usage to be extremely small or zero, making
> zswap_usage/2 insufficient to create meaningful writeback pressure.
> The test then fails because no writeback is triggered.
>
> On 4K page size systems this is not an issue because 4M covers 1024
> pages, and file pages are a small fraction of the reclaim target.
>
> Fix this by always allocating 1024 pages regardless of page size.
> This ensures enough anonymous pages to reliably populate zswap and
> trigger writeback, while keeping the original 4M allocation on 4K
> page size systems.
>
> =3D=3D=3D Error Log =3D=3D=3D
>   # uname -rm
>   6.12.0-211.el10.ppc64le ppc64le
>
>   # getconf PAGESIZE
>   65536
>
>   # ./test_zswap
>   TAP version 13
>   1..7
>   ok 1 test_zswap_usage
>   ok 2 test_swapin_nozswap
>   ok 3 test_zswapin
>   not ok 4 test_zswap_writeback_enabled
>   ...
>
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

