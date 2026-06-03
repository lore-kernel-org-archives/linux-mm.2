Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD01CD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E706B0088; Tue,  2 Jun 2026 22:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF276B008A; Tue,  2 Jun 2026 22:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4F76B008C; Tue,  2 Jun 2026 22:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C21316B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:11:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 492FFA01E0
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:11:43 +0000 (UTC)
X-FDA: 84836975286.14.3FB4BFC
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A60416000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:11:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fet6fDSY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780452701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWcXO5uoIwwgO4Aa+YYZakt6JMfCreyx3cspW4io9Lw=;
	b=5EC6T0e26gdSc9BjjHviwROza4SoaOvzQwI2cc//H4ffBhJ9ALqgmYZgWe0+9f0BQ/T7i/
	wipBTLHJMuN+g8Oh5ZxwaBFt56tUaaLvBQLjD+dDnMJm4oIp+Z7jMN8qo6xAqQnwdHa4Yu
	XaAUsCBypsStg/qqSYsN5kuZyhl+MwY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fet6fDSY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780452701;
	b=u/e/7SwuhEP0Gd6QjdQJVhexsLcJHHuclfw7HVyxFfuH/plVk6OswZNdCsftPuI/+jc4EX
	sfrlG+XJebdipThgzRAALSGd/ZHlE00Pu+ESKqD4W3yWmVDj2nkVxz9cHuGTWpSHIkdthe
	1eCCWT0grz/+6M5o1X/O6HmOUSr1FbE=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780452696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fWcXO5uoIwwgO4Aa+YYZakt6JMfCreyx3cspW4io9Lw=;
	b=Fet6fDSYiGjeiF+vRO7z6BJFZX/dR9CMeWUIFtJFE9creS+yD0JQBGuWgGQUhyP6XrNmHh
	Z965wlncTfP1tOwChoVENLJB8dzP9PWkSK2e+l9omXLG0HKsFd6y4J8uyFX83oe+kM9BtW
	uFt/qF9a1de8Y91NqhGy9DIvSJvw7gE=
Date: Wed, 03 Jun 2026 02:11:33 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <38c4d77974349f9783478a04c46df6f975d41c84@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2 0/3] selftests/damon: misc fixes for test bugs
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, shuah@kernel.org, damon@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Kunwu Chan" <chentao@kylinos.cn>, "Andrew Morton"
 <akpm@linux-foundation.org>
In-Reply-To: <20260601142234.111301-1-sj@kernel.org>
References: <20260601142234.111301-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0A60416000F
X-Rspam-User: 
X-Stat-Signature: ewhpsr1kfe8msz1wrbzfysybxc135eg7
X-Rspamd-Server: rspam09
X-HE-Tag: 1780452699-449381
X-HE-Meta: U2FsdGVkX19ZEoFbBWiM8pHezL1ENRDknmd62vEmRLP54mI3ge32lFCXTtdKXlwJL0hJOuqlD54RgR+Hrj4TTJiHPYSRc8iuX7FqX8RcgVmYUF2KA8SjAZvRcosCDRlc6yHropKDzhB/YIX1P/HV4uFs2Nlu9RLCDKEJ5ONbj7CZE41eDCcmxx3lLq+1B20c1AqkWoyvL8UAxH1fJv7uvRSAjAzavAGLzGNil9VD+7FrkIZSMwftDNZJjmX7WExzzERXbCYTBhhWOT/9hXSiIfQoNjv3DzI/un4S2+kNpEr+TeaLvE0P87zYGP/8KTbiK8Uwny+IHladkTURX2W4vLbZCbQybj++l972mgTt1cCS6zXhllVTHad41el+OHHoTfUfmUXGrEeh73uy7K5xLS8CrFhRZD6yj15OZmYfSwMtguooCOLZ4e1/NfNOXZ8Eg/WMSfGqdVFGcVXJDjlhmjQ9+rmWBzn0b8mQTnDp+QvR7ErPNCsE32rD1n3oHbE1UQR6MhmYxdCwohlgYb/hi+TnJftUzGScusBqRyFhAj6/3LED9WwB9evg6uGqfGxFJM7L4l30M0XLjiOM36vchyvqeDsD/ZTpsYUsuFKeUdCCHG42XhrX1vDPl83FwU2h4rrV6w52naCVfSh6/6ILyXCffGTmYjGbNPiNTZsX/LTyqBzKHIskd/41a0/lvrgS8DOvZ+Bb7wMvNOXvRGaZoU3Ybxrs0AgbsfihkjI1e9vuHWDxNixM+Bk83qGkUWNIdSA3ewEy5e4WtxYpB0CCT6DRyUd2CZbn8+TSYquOTvnMQOD8fSvPcPChmJD1DrJf8ooSvj/Ymngqk2+sasc22Cwa3qeRG7iyjevZn9AJLYLwraWdxeuvT6O47HfqZGz/RvpbTNWUXKgph/mG4GhQ8iWLe/kn/7nAonD4JDbk9T/kmPUTVmBCHIXWSaVKgydaVUowKqZxBlN73BlGox+
 gNrP2oOq
 Ipd8ezYhuP5FYS2vIh4jUe1caJBdPrAYUk5qjahD4R3G6JfHtvrgnzG3c0LxBS8t7IrmjIWuh7UcVLmkZlfTGYbbzC640yjo/1roN6S5R9NK/rnGuhrFSC5Pzb6UGFgTO9NfKk2HsVn1z/mZF4LmgGZIHlxOm1BtQzMiPREaUv/77mQ+Ug0E+g7PsogDSudeJOQAJ7RV4sMaVblLuKo0h+N0XeD3Dl4CgY50thJ1x+w6QjWs7cK1xFra5ViWVibwHq5y7LpTDclBCW9yhVD4W2XnmoGjPwrIYpb8z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B46=E6=9C=881=E6=97=A5 22:22, "SeongJae Park" <sj@kernel.org m=
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
> >=20
>=20Nit. Only patch 3 fixes a fake test pass for "avail_operations" file =
existence
> test, and the series is not doing something for slow machines, right? I=
 think
> the last sentence should be updated, for example:
>=20
>=20'''
> Most are trivial but makes test output wrong or even silently pass the =
one for
> 'avail_operation' file existence check.
> '''
>=20
>=20Other than that, all look good to me, and already have my Reviewed-by=
: tag.
>=20
>=20Asssuming you are ok with the above change, I applied this series to =
damon/next
> [1] tree with the above change. If this series is not added to mm.git i=
n short
> term (~1 week?), I will ask mm.git maintainer (Andrew Morton) to pick t=
his.
> So, no action from your side is needed for now. If it seems I also forg=
ot
> doing that or you cannot wait for my action, please feel free to direct=
ly ask
> that to Andrew.
>=20
>=20[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-pro=
file.html#scm-trees
>=20
Hi=20SJ,

The updated cover letter looks good to me, thanks for fixing it.=20=20
Thanks=20also for applying to damon/next.=20=20
No=20further action needed on my side.

Regards,
Kunwu

> Thanks,
> SJ
>=20
>=20[...]
>

