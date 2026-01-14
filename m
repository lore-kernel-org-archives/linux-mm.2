Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F549D29FF9
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37CF6B0088; Wed, 14 Jan 2026 07:51:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5316B00A4; Wed, 14 Jan 2026 07:51:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6DB6B00A7; Wed, 14 Jan 2026 07:51:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B63516B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:51:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F350140505
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:51:42 +0000 (UTC)
X-FDA: 84330556044.25.E2B48D5
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 90C44100008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:51:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evWepCO1;
	spf=pass (imf14.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768395100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=006a5mLOBo/6Z+BZ4PGfAJrahlfyrHXjY7F8sopqUqA=;
	b=73Ueki3Fgo3uA/RcZ2QXrw26SiqccDyaBFJGP/lUKeQ4iN0UXgTjEGbpr3vFC4kKOF8/2y
	PlI3ZQqiZaGEYCx6gzNtrp4HYm9OjV+8FQ/kWYhL9IvaMcX5NdtSUFD+Ttro+jp8NMTNXR
	LUhVwURsnVLJ3PQJCFXeu0qfz3mvWbU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evWepCO1;
	spf=pass (imf14.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768395100; a=rsa-sha256;
	cv=none;
	b=1X1i1OR93QmmSiBarhD97OHxDOtcc/dQfpoQIW3WS8T2C59c/uv8dgcLmE2uqDTkoQEt51
	XFtkv+TJFymhQKTij6I0e+1hleQ6H62TvyY+dcxklQhX5DfgBu+tWuG8wQ7bgQAOnIvLXH
	j0LU+qDXaT07yJSedegPrwu3ncHsVrY=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5014db8e268so5659881cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768395100; x=1768999900; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=006a5mLOBo/6Z+BZ4PGfAJrahlfyrHXjY7F8sopqUqA=;
        b=evWepCO1JCwfWBHW5LKpIoKkFbQJrwwmVnWveXEq1f7ei3Lx9pAUa5rQJ7EhKUeAo6
         xmQoKjUlvIuGXvqnLwlasIWcioVvzMvZSyt5oWFxVWEGr7roRyGAFZ/lROCpdKmCYtmf
         WUSeATVaUcgPVc047MAap2Hn3Yd86Sl4vNgYULbpgbiGxQrGkceLmhNWVQi7soDIP3pm
         TfVwa++glHmRmrLpP5/xul9RgyFhJ3T/zchZvAmjrLfktO8TjtuCVULM2RPSEA1hBRa8
         e8m5NyP4mK1x5quespuTvaYmfQpu5Eumv89+UoXCbgo0iIsx+94gv3sFtAwoWbGGWuOI
         ebBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768395100; x=1768999900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=006a5mLOBo/6Z+BZ4PGfAJrahlfyrHXjY7F8sopqUqA=;
        b=cmecdIzMbFSAqwluKO7Og1FIrGus/EIvnu+G4TcruJYfmACZ4q9wTUowpqHP26oCuA
         9cqLaOscZsGxDegDuGBH93XrZv0cXmVBS6ihVC8OwHekQe35amgyAf+WbCS9VMMK92Xl
         2D4uD1AUixlPxVS2d7qWBzjwyq/D5SEXfa+gEumSdFBdfLY80QM/x3qAoJIq19H851vq
         wdT4/X/Hik+NnRF7miy8WYU0gzwvzkVNprMw/A22+HuObl4FuoIIjxkspT7grgHqFDPX
         hfqfJ5cQfq9qOIYCNv0I4BmHYZIItazYiPFmWQzykiSyW92Sdkj+lqXVTGwj+Yvbk0ZR
         MQNA==
X-Forwarded-Encrypted: i=1; AJvYcCUx+Azo/K1vdpq98I4Gjx3ecEvjpaV8UFVe5TgqQA+E3J5oFqBp7PVfaGoWBMaX0RBSSNuBce87yA==@kvack.org
X-Gm-Message-State: AOJu0YwcK/uH7FBjK0W9iLiWvhB53bjfdVD/Z1eBMP6jB1pa7UzTMA3/
	vkeETDozdGXM8yFqIfB23v6vrw05kt+i3sz45jncxxpegNW3HYfaJ5pZ5CpUWgHjvmwT+zRxXPP
	WqSMeVesrDFgX2TNbBFoheg+MONa+bR8=
X-Gm-Gg: AY/fxX69dPxJoKdf1FxY5sQVXN8m5yqAPmhikFs5a2ZwhDUhNV8cyV5W7BOFtVZY49U
	qO0JljMm6nGyZxppOgtGv0BCnDs9OLSeQWF8T5eKzRqRLdMYpnvPGXs+UihTqyymI8cfT+6RgnQ
	YrtMP+zTHnsS87qrrmabjm2EMbrCrEbOQTjdYOg+Hxn4oksnD+7xGYD0ugfwjUrtCSN6CHhiLvr
	4xQ6PADFjJd2uQmWHU6FUmbqlwsvSqVBfR8+/Li5vlaMeCJmaI6ejuDbKxvYBJwKrG4RUDfpANW
	Y+2BA1qedOIi42cnG87mEws=
X-Received: by 2002:a05:622a:15c8:b0:4ee:26bd:13f3 with SMTP id
 d75a77b69052e-50148229b85mr30313931cf.8.1768395099537; Wed, 14 Jan 2026
 04:51:39 -0800 (PST)
MIME-Version: 1.0
References: <20260113081453.8293-1-akinobu.mita@gmail.com> <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka>
In-Reply-To: <aWZLZzo5Hb1aFZ0j@tiehlicka>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 14 Jan 2026 21:51:28 +0900
X-Gm-Features: AZwV_QisYgkZEmBBUAVcKZ8lXCorw-BsHC0m2W7I9C7udOLibwgtul2cNNEiFaU
Message-ID: <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: Michal Hocko <mhocko@suse.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	bingjiao@google.com, jonathan.cameron@huawei.com, 
	pratyush.brahma@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t9nz6fn3jmoufwgp883nkmf6mmhx8hh7
X-Rspamd-Queue-Id: 90C44100008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768395100-536244
X-HE-Meta: U2FsdGVkX18XU16+CEWXhAz/CgkZizWaTkhCNx10cP/VxmtXGBjoUBZSM4Tiv3RcXtjKabt+QfcG8R3dYRkJzgSNq3vym005lIS8v1jAeiPdLY01F+IjiCK0hWsDuvJYf70gZs/d2EiM/AmqpPSZebSh20dMv7y8KDpLNd3FHSCAY74N36Aj2Jmi6JyDqrCDiu8IirB15YXzhp8Vp2Yxp7hhYYzIu1ek5lZSX0wOdhPirJ4DLneSXiuDR3o/zfEi0rnwyTXbDCL4WQJaK9dq0XSsthOomVp6zvx6lqyxCW/9WPSyHwKdVhZQuRStXHRb9FGIQInsPHTiTC/B188YXfXf8P3sf3yfXB6H/X2BkEwskGsN9nG2bGsxGRN5Aawkc3X5rh12OjtpdOkMnwKqEw12UdWuzSWC4FNsjb4plCEE4aYLWsKrsbBc9xmuaUJnlSs6RzvGjRVFgq2Au2e4XtgWsRAN8t+6s7cx4jJbU0bmC0kaSC7uuebPlQfwa/WFjv9CmUDl2js0a1RLedCEY5xa7NgV2isN7HPBMdyA1KWn8xECASH0l2fI/Qpu4IbjWbs9JCWUDDFl4zV5yuNdoeGwq/2zXOqiHGQXNQYF8VEMD2TqEq9ZsJvjANqPPP1kH6s3YkVrt4SqTO7sWCZjBkrgC3ONfpXD3tPja3PPalY4kL0evpR+7+mnOjRppPpq9wCpYQWk6Qu0nbKodtTyJpvuuVsL05cFKdpuk2sWk9PH1Cn4O8Ekue4rHF1EwBpr/SYzGV/4S8+CYBNIohjsbM9LmTCwjkrz8laHblu9eqSxFj2zuyA3zqQzO6EqcIWFA+hKOL5Y9qyHYzBzIOQC+NuR5fXQSuwMA6fCySSWBFLl4n8AFnzvHPC+Kn6o1xN13lGn9AhuINtjTbkLG9xs+vjzEo1ZRO9k4ks7VuIVR7UN7sZQwXXivGOXbjuFthW6TryzPrs3vM798ES1ADz
 +DEZt5ja
 y+8gOFH4aFO8f7E9fmtcvKH4sAn4ZFbyXZvFM0815QbjboEm8lVN+ZvJV7OUZYSN8oGNjPxvSorr9C7E8D+f6W5EGaEGwfUrIyR3rletN2BwVdYhZp3+Gn0WKrh9Ka4zruqpkKfVvoJBTtNG9FtxLYIOtQvgNiuW09avdyuD0sYjWAP5LtfJq5l1TxW9lC36i8D0er2s0HqfQOM2zqibWq7mdnQFVSPhe/leiIb+hSwS0ouGEdCoOXFPXcqxb7RLDueR5wG/n73jX/aJeKG+2SNUWM996Cp6WyuZ/rXrZbkzJDfBl8+TsJuvNVeDqXL9b0Z0txq7f5N8znMaZbJIgl1tnLmdnANs/QsJq1kOWZPyLD5oInOLCyir/IE6VtfhvTVZ0a8erbSH3JB6AeQWte8jLNt/cmCb+pnJ5tlChxF0fex98XQLNtr3X1cVZ9tYcSX6bi1Oo4fo+Oad5ArfCLtf2Rqb4U9s0D8QIYUn2wDfVYdMK1ycOTl8o0OiKccGjBvQcXfVblEmxJpQru+ZNbfjZlevzl/ESuv9WMyanMsHKDio=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8813=E6=97=A5(=E7=81=AB) 22:40 Michal Hocko <mhocko@su=
se.com>:
>
> On Tue 13-01-26 17:14:53, Akinobu Mita wrote:
> > On systems with multiple memory-tiers consisting of DRAM and CXL memory=
,
> > the OOM killer is not invoked properly.
> >
> > Here's the command to reproduce:
> >
> > $ sudo swapoff -a
> > $ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
> >     --memrate-rd-mbs 1 --memrate-wr-mbs 1
> >
> > The memory usage is the number of workers specified with the --memrate
> > option multiplied by the buffer size specified with the --memrate-bytes
> > option, so please adjust it so that it exceeds the total size of the
> > installed DRAM and CXL memory.
> >
> > If swap is disabled, you can usually expect the OOM killer to terminate
> > the stress-ng process when memory usage approaches the installed memory
> > size.
> >
> > However, if multiple memory-tiers exist (multiple
> > /sys/devices/virtual/memory_tiering/memory_tier<N> directories exist) a=
nd
> > /sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will not b=
e
> > invoked and the system will become inoperable, regardless of whether MG=
LRU
> > is enabled or not.
> >
> > This issue can be reproduced using NUMA emulation even on systems with
> > only DRAM.  You can create two-fake memory-tiers by booting a single-no=
de
> > system with "numa=3Dfake=3D2 numa_emulation.adistance=3D576,704" kernel
> > parameters.
> >
> > The reason for this issue is that memory allocations do not directly
> > trigger the oom-killer, assuming that if the target node has an underly=
ing
> > memory tier, it can always be reclaimed by demotion.
>
> Why don't we fall back to no demotion mode in this case? I mean we have
> shrink_folio_list:
>         if (!list_empty(&demote_folios)) {
>                 /* Folios which weren't demoted go back on @folio_list */
>                 list_splice_init(&demote_folios, folio_list);
>
>                 /*
>                  * goto retry to reclaim the undemoted folios in folio_li=
st if
>                  * desired.
>                  *
>                  * Reclaiming directly from top tier nodes is not often d=
esired
>                  * due to it breaking the LRU ordering: in general memory
>                  * should be reclaimed from lower tier nodes and demoted =
from
>                  * top tier nodes.
>                  *
>                  * However, disabling reclaim from top tier nodes entirel=
y
>                  * would cause ooms in edge scenarios where lower tier me=
mory
>                  * is unreclaimable for whatever reason, eg memory being
>                  * mlocked or too hot to reclaim. We can disable reclaim
>                  * from top tier nodes in proactive reclaim though as tha=
t is
>                  * not real memory pressure.
>                  */
>                 if (!sc->proactive) {
>                         do_demote_pass =3D false;
>                         goto retry;
>                 }
>         }
>
> to handle this situation no?

can_demote() is called from four places.
I tried modifying the patch to change the behavior only when can_demote()
is called from shrink_folio_list(), but the problem was not fixed
(oom did not occur).

Similarly, changing the behavior of can_demote() when called from
can_reclaim_anon_pages(), shrink_folio_list(), and can_age_anon_pages(),
but not when called from get_swappiness(), did not fix the problem either
(oom did not occur).

Conversely, changing the behavior only when called from get_swappiness(),
but not changing the behavior of can_reclaim_anon_pages(),
shrink_folio_list(), and can_age_anon_pages(), fixed the problem
(oom did occur).

Therefore, it appears that the behavior of get_swappiness() is important
in this issue.

