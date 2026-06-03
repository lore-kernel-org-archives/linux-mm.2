Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC004CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C566B0088; Tue,  2 Jun 2026 22:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C596B008A; Tue,  2 Jun 2026 22:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63146B008C; Tue,  2 Jun 2026 22:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4F846B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:06:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A42D1C0D87
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:06:26 +0000 (UTC)
X-FDA: 84836961972.05.A40A055
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 54179120003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:06:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GbGhM7hS;
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780452384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y94GexdbEGEmiOo9phYF+92fMWxZFTUjHe2v5T7NUxE=;
	b=mChA+SrlEg9X5mH5oIjChXMY9DyafN+2A1VK9b72d230ejkPMnCk3oOgMHUNyifcUDcrTO
	Igk/8yAZ/QHujGLDVUoIf5iIioQkP+c+GtrVPe/43bnGqjl10pvn0+n4xGZi57SDt9OgZr
	iBJkH/2BujEOv4vnbxf91cG4PH0+bm0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780452384;
	b=mjX/5HqUzFyiw03pYwwftMtvPDSliag1FdHlUkOS8b/7lkJswvbgZx/ATF+7Fueah/iVXL
	K9wTT/KykoMeiGAUcRwz38yQlK/5yimUYm+/7K3+Q4c5y3z9b4FHRHcUnk7SndRAQcWUnz
	IHrvTLUk1ylH+6sDEoBmFsY7nB9PuOA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GbGhM7hS;
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780452382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y94GexdbEGEmiOo9phYF+92fMWxZFTUjHe2v5T7NUxE=;
	b=GbGhM7hSBid/iHO6Gf4bpN63/puUnNqFrGB8NtASBvQXxOkioDjX8ktGmJ9sT/gFJa7EYl
	vyVBUvXko3mf+8jW5+Pcf3by8tenNdTXPKpLyUwP/vStrUvUF8xcZMfaQuP0C5HFalEcGn
	Mj6jDaK6tCXWk2j7zBtTZZxENU2uz6g=
Date: Wed, 03 Jun 2026 02:06:18 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <452fc2b00de0b87e233c2cdcbcdd343bd840ea21@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2 0/3] selftests/damon: misc fixes for test bugs
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, shuah@kernel.org, damon@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Kunwu Chan" <chentao@kylinos.cn>
In-Reply-To: <20260601142802.111592-1-sj@kernel.org>
References: <20260601142802.111592-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 54179120003
X-Rspam-User: 
X-Stat-Signature: 9uwhh8bjyex9wd8rsyr1yi81p1kx6dum
X-Rspamd-Server: rspam08
X-HE-Tag: 1780452384-392284
X-HE-Meta: U2FsdGVkX18Kbr7t3ci/r3fTQajym/UOi8QVpuMb0eBZagNtjDA426TUHT4+hR7SV7yowHStoym7Cwys+HfFK5oDUOC6gfnQBx3YSwhyMMXmOS2Czx6UXZAURrpv0tscvnKqwe4CXzzI1fmKYn0pD23M+6ypqlfNd3dVqqaHu1r0lxE83bg8aOe9FMKOYSwyxOdSmBJf+PrJyJbwKaoLdl2k1QVYZ+rUL40TdxLvojuJy4FrzWYUx8XpSm12tHCYWEG5H5DlojBKU2EgEfRdxeexg+lUIEmFlrueJgGjXIFIlVZOZ2u7z549UFSp1elvxeya5TJtsmBbMIHB6N4CTiA9c/sxCoHJYJN9EZu3IAAhqXhA0wfsUdr3bxLxcwyZAipt+hvyk8uQ0nZWcV+mAGeDRBIhUrSuvHxpe9rNbPBJ4iXNwmnCNOGQZTXqKqYAE54AMpFteNQCr4aTvoR6dbtMiXdzHex+Ng7K86s0F+rm+XDsqT582DHUQ+h/9TRWQyNWIxfPsa4NlZV6rYQ/72IODs1bH9GZ3Lo4AL81aCbNmPdbBQbIXbBs30ShQgoxEPJ6EO8zmPOOUeAG0X6jSVMnnTRRi8Kx0lvo0OJ+7yBXZKc0f2c1xBdE5CKw8xjhxpXXYv2/d+RlGTzPZchLIaa++N4FDPEUERO4KpHC9/yj8X9OWpxhTWmkWqqEGmy3Ww6vKMsIma4QRYwG5px6aWx3p8P250fh/sC/4qQ6GK8Vg6klEtabkc0Uc+Tqiq4KLh/qEmqUDspcLkOjgzXCphl/+oYoKSV3Lb695W+/UFkErcYJCzIh6LeC2wlKz8RaREtZKH27CmofRdQG8I1EKkGwcWNQA5eBQ5yuGA+ipZoHyXfDkNvAMh+OyamZlixRrE/DQ6W1sd3PiOStQzM+c+RHYL2J+VIBydgmYpuPmzM51j76OH0XMad8SBXRNiGzV9vYTAG6UKpNWHVJoJa
 LNDhf3Kp
 AFlZBEDGljC0m8FkbxTP1YQL/pFCslS3J9ymz26ZJjU5c3cpEbtZqVqtZPT0bpMdgEEkQKNPMF/lJ3kTZKvUqLfSF1okNvIwcZCdWquiNE9ZDyPnOBEp512bwCr7VvCzRjKo70XPTDQNHviwTG20Ho+C+RAMENEiWhuVhCOtlO20/ZH2k3M85FRhhBVtj/Xckfy9bUwDcObdodrKh9rf98hgyTq6kYdf+Z/4ij+Ls7eApVlOZdpto2+igoCtzldWzWlqZzXL0IrTDQJbZCafLmo8yaDi3ZcOJoFzQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B46=E6=9C=881=E6=97=A5 22:28, "SeongJae Park" <sj@kernel.org m=
ailto:sj@kernel.org?to=3D%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > =
=E5=86=99=E5=88=B0:


>=20
>=20On Mon, 1 Jun 2026 11:23:11 +0800 Kunwu Chan <kunwu.chan@linux.dev> w=
rote:
>=20
>=20>=20
>=20> From: Kunwu Chan <chentao@kylinos.cn>
> >=20=20
>=20>  This series fixes several bugs in the DAMON selftests. Most are
> >  trivial but cause tests to silently pass when they shouldn't, or
> >  fail prematurely on slow machines.
> >=20=20
>=20>  Patch 1 fixes mutable default arguments in DamonCtx.__init__()
> >  that cause state to leak between test instances.
> >=20=20
>=20>  Patch 2 fixes wrong operator precedence and join TypeError in
> >  damos_tried_regions.py.
> >=20=20
>=20>  Patch 3 fixes several wrong strings that produce dead elif
> >  branches, skipped file existence checks, and broken dict key
> >  lookups.
> >=20=20
>=20>  Based on next-20260529.
> >  base-commit: 7da7f07112610a520567421dd2ffcb51beaefbcc
> >  ---
> >  Changes in v2:
> >  - Fix From:/Signed-off-by mismatch.
> >  - Add Reviewed-by tags from SeongJae Park.
> >  - Drop the duplicate memcg_path fix.
> >  - Drop the empty aggregation-cycle retry fix pending root-cause
> >  investigation.
> >  - No code change
> >=20
>=20From the next time, please add links to previous versions [1]. For ot=
her
> readers, the v1 of this series is available on the mailing list [2].
>=20
>=20[1] https://docs.kernel.org/process/submitting-patches.html#commentar=
y
> [2] https://lore.kernel.org/20260531085633.48626-1-kunwu.chan@linux.dev
>=20
Hi=20SJ,

Noted, will add the link to previous versions next time.
Thanks for the reminder and for providing the v1 link.

Regards,
Kunwu
> Thanks,
> SJ
>=20
>=20[....]
>

