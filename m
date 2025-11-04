Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0814CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 08:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3994D8E00FE; Tue,  4 Nov 2025 03:39:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349E98E00E7; Tue,  4 Nov 2025 03:39:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2870F8E00FE; Tue,  4 Nov 2025 03:39:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1850B8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:39:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89EE358F70
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:39:50 +0000 (UTC)
X-FDA: 84072276540.17.445BE63
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id C04FAA0006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:39:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lpn7E2Of;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762245588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUhkfPH/iDzPYPJB5B9fd+xmNjC6dsjlXnkqvz4zmUI=;
	b=J/eN+Ps64Ld7j0Feij9i+cIBa2+xUksAO6hIajJev3NM8dA77NwfuWh4DnJJopXvpmrwPr
	7BOynidzU2G039Ujt2RRcty0jGwF5L0vKLteJj1znOBYC75M222AaDPhmMO7KtpM/6NwlJ
	QKVBqOpBb1BF9AQl+QxkFW+Tanbf05Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lpn7E2Of;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762245588; a=rsa-sha256;
	cv=none;
	b=ljR/isSQw8KO8Mq0HaFQ8nLKmMEwj5U4dhr0tOTer9cHdikwFKYpj+Zg4I4wBG9m9bFUEJ
	rJHJTbX4IpWV/5K9F50dAYwhL2O4QhMB08sFrOHSFHCbL/LsFLOjl1Tu0sq/PL6gfLa2E8
	WEID0xGpTioQBJWye39c7n6zOJRdT18=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762245586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XUhkfPH/iDzPYPJB5B9fd+xmNjC6dsjlXnkqvz4zmUI=;
	b=lpn7E2OfkVZHiHatEPiMSgIs1yg5dZmWJqK7Tl9WnOoNWUfIR3vnoj6OHM5Oa36Mqag9R8
	7cMP7Yo36xOQNBPWzhG7u4fmw4EzsXj2ckFGiI4PJYy0qag7vl2CNYqq77Jqj4w7TZ9lKZ
	8Z9tvdY12LxMxVn4CuFH7ZqFnE93GAI=
Date: Tue, 04 Nov 2025 08:39:44 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <f4a25c9dc3af7365b6ade4cd9a0404530afeaa11@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>, "David Hildenbrand"
 <david@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <20251104044355.94885-1-sj@kernel.org>
References: <20251104044355.94885-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C04FAA0006
X-Stat-Signature: m6wfas61bdzf86uuactmftmk3amc4auw
X-Rspam-User: 
X-HE-Tag: 1762245588-641574
X-HE-Meta: U2FsdGVkX19CMO6onlnvWyVbRxqzDKZBmRsvO7qMZFFQQpPGLkVyxlsjBhs/6a8P6KTVkGAsdgzkTko1A10bNvlNfxoiNqtwXzTgbnrOWvoArbq4V1SVL5jqiWIIaliyo6BY9bApLx7mjJJik/ipdMv4+Way1ZayGeabzDvq9z2WlfDpUzFZ8gtGqm3MOori2acxoIos098K8dNwBOakhasDoHhP2Qe3SBXReX2FiL24lzr4uX4TOXJwINVZHDz8WbMU73uAtglsi47PIoBljyMIF727HMl4UYV8rvhPOmqVeqIp6ZvS53WbU3FDVAkRHfAyYKz11AFehmAHGNKklC3v9kC6Rck1T+x7oONGwWQT/FnZBctcHG2T3ktGQNLyyecMiC9kS+ymfH+aumLapREkW4Sqq/YAJT7/uYcTUIoR2z4fOiEoOXPvW54Rw5wNnc137PnSRuQkhUbuSR7mWINCGC5CUD8eJXMbVaJ2+IzxP49hPe1RQWCcL0nJefL+0U/YN79D/MchMOuAplFtBD0ViHvR0Tkz0b6+opL8lQYEk2N3HlE7NsNaeFvmAMAVjjMp9mA9JQYEmV3hOBHL/YrYygaTnpNLzXodWe81JCL6Nm74SuYa/GVMW8Yrgl3fiJA3jJwPYJQMbgLQJxU+mxMff5eY2PdQijoiXiJp26X5AUyG3ePor3XWWUuyCsTFH4GydkxeqHuTo3Jgcw7sPHem4BkfLYKehCadQEyOioqKynZZqdpShSmmRKfTZUrX5Ld8Opf/TgRZJ0dq+GBOc8lZUEoBnjF2Nn3ZOuRHEkk3DbsyHyf8XLjDPAzlpSmQrcbwoEUQ3ry+l37cdyHd1PiIovezR8DjyXC/TaAJetaXQ1hAvzQzkdDVFv/0z9SdTIoy94i8kH35Lho2ewkC5KKCpQEoPtNSh9JCmk2PpOhVAT6xdvcggbk8Q/VhnBEdgy8u1bTbcgg9RimFDtY
 dktfGnNR
 hFp0ijMXpH3+e+MGKO/B464MHeHuyIT0OTtXlaWDdY6DB8W/aGZOBnGyCQ7xvAzR3HxSznSYAmMayTov0zKG+NMFIc+RcVhh5OyLA7bTFOap+GDi7PR9DjlCTOLQjPSXyl1Ib4BJBuwpppBECaufdqDKMCv5GnTuB6cNYtRk67vseVmo8ysYshJq2rPRA5gpzjsfGuUMbJ6tOzuu4bPZ4rNpbaJBdcVfLM0j5OwBluGPPQp1GzhD0VpBw8XKRqGWwFJwWOmLm6mSwlK0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B411=E6=9C=884=E6=97=A5 12:43, "SeongJae Park" <sj@kernel.org =
mailto:sj@kernel.org?to=3D%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E >=
 =E5=86=99=E5=88=B0:


>=20
>=20On Mon, 3 Nov 2025 16:22:07 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >=20=20
>=20>  The hugetlb.c file has grown significantly and become difficult to
> >  maintain. This patch series extracts the sysfs and sysctl interface
> >  code into separate dedicated files to improve code organization.
> >=20=20
>=20>  The refactoring includes:
> >  - Patch 1: Extract sysfs interface into mm/hugetlb_sysfs.c
> >  - Patch 2: Extract sysctl interface into mm/hugetlb_sysctl.c
> >=20=20
>=20>  No functional changes are introduced in this series. The code is m=
oved
> >  as-is, with only minor formatting adjustments for code style
> >  consistency. This should make future maintenance and enhancements to
> >  the hugetlb subsystem easier.
> >=20=20
>=20>  Testing: The patch series has been compile-tested and maintains th=
e
> >  same functionality as the original code.
> >=20=20
>=20>  Geliang Tang (1):
> >  mm/hugetlb: extract sysfs into hugetlb_sysfs.c
> >=20=20
>=20>  Hui Zhu (1):
> >  mm/hugetlb: extract sysctl into hugetlb_sysctl.c
> >=20=20
>=20>  mm/Makefile | 2 +-
> >  mm/hugetlb.c | 852 +-----------------------------------------
> >  mm/hugetlb_internal.h | 116 ++++++
> >  mm/hugetlb_sysctl.c | 136 +++++++
> >  mm/hugetlb_sysfs.c | 632 +++++++++++++++++++++++++++++++
> >  5 files changed, 894 insertions(+), 844 deletions(-)
> >  create mode 100644 mm/hugetlb_internal.h
> >  create mode 100644 mm/hugetlb_sysctl.c
> >  create mode 100644 mm/hugetlb_sysfs.c
> >=20
>=20I think MAINTAINERS file should also be updated for the newly added f=
iles.
>=20

Updated MAINTAINERS to v3 version according your comments.

Best,
Hui

> Thanks,
> SJ
>=20
>=20[...]
>

