Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF26CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 02:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA67B6B01F0; Sun, 31 May 2026 22:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7E446B01F2; Sun, 31 May 2026 22:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB086B01F3; Sun, 31 May 2026 22:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA81B6B01F0
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:11:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C3C9C1D8F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:11:54 +0000 (UTC)
X-FDA: 84829718148.29.45A58AF
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf14.hostedemail.com (Postfix) with ESMTP id 89F27100010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:11:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bJgPJaPR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780279912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yA/QFrCtPoX5wPIQZTccJ9pEjaemUdXNIzLEOb9zuBk=;
	b=zgIaW75MpzHrRNgNiJH6wYyhJv0gLfuoo1ko+ktyvh27YmfDo4ItGEiOOmnhcRg7Ll065h
	AkysDC5gwlX9+H1Q26eHfOLS2V6/JeIEGNkqSAv1g7i4cu4v3c1StdTpj3VULO2mTORZ1/
	FJBhOLZJIqTM3QrHPkst5klwtsxmSEI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bJgPJaPR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780279912; a=rsa-sha256;
	cv=none;
	b=2s/lH/35cGFbxi2sdiZZBx81iPmHNhmJvUJ1iTSoJbK2BMUtGO19eX/4PSfWNaPesgnq/o
	lJw9OXj64DcPgpotY51KGjIyYClFrq4YPI5vWJIZILleJJU/jiFkvW+texet7Yb557uFZq
	JiFShYR+4b8Uq0YU6ZkxstNnOQf0KPM=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780279910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yA/QFrCtPoX5wPIQZTccJ9pEjaemUdXNIzLEOb9zuBk=;
	b=bJgPJaPRzvdonnMsZ4dpFUWP9OLxY+c8G+lanO2reQL+tLTEmhRxizTgnW6WnfqjghcwTp
	8M0xmyVSfdACXogiyGGfbhUHphhbpsJX/hlBgDr7tob/B99FQ2oIjWrf1hZQ3kPWEAkn+I
	T8geubSrHZAE/8vN+xvMLhJLHYOoXKg=
Date: Mon, 01 Jun 2026 02:11:44 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <2b9ae12de845ad1c7070c797ed1214602e548db9@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 1/5] selftests/damon: prevent cross-context state
 pollution in DamonCtx
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, shuah@kernel.org, damon@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Kunwu Chan" <kunwu.chan@gmail.com>, "Wang Lian"
 <lianux.mm@gmail.com>, "Kunwu Chan" <chentao@kylinos.cn>
In-Reply-To: <20260531163050.98908-1-sj@kernel.org>
References: <20260531163050.98908-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ayarsr8pagu4bhwp3qsqyf8j865y46j4
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89F27100010
X-Rspam-User: 
X-HE-Tag: 1780279912-715073
X-HE-Meta: U2FsdGVkX18WD84td618gzbEr9DFaYg5ht02nMTFDN5hXq3zIr1rJtCOfELbWwwEviZGB7zcLZ1t81mHuiWbC9mQS91v6IUaizHws+NxE/fbWjuoPCkooRneIn942QJ4v1VjAbQXNPMl+Tfu6rSCFqg6idyfhv6PQc9o96K6t2z8/6qdznRi6Cqd/0UyRN275b2CrIlHslwXhltc3PbWYBW+wAtjAH6HYt6yv/Kuhmy2B83Mi5C++kR8iduR44v4jZBgn70OWck4DWrylVXfw0DrUyUj0qraQnERIsO87JRRknwSJZTFkohj+BvrSaHSckRg83kedDgVC23DFWRdeHR8y4cdDlQgZSpE/RpFBynfWLZ6XJ3CToWfS+gvMsI7liYj/zyuXasHCNRv7kEHw4TVp00qg6KkivfwrKqrIZ4fXDmdXIXWG+ZzLOfwUywxSI7Ao7o3mJ/k3G/rfKozcd3iCo0RANdAzjHa6BKf8eAQ0GhbNPxMk5z5MEDs7442+15LVDQP0+E0HPDwwoTwHdHzVeQdmj8xRjiICOeXDWsxHaJnVSUfPH5wiGqJMTozSZXu0PNxTlbzdzqDSABHvTzGR2WjZ823UsZuQDrjRZ3Ez7gY9pfYGMXfBV8JzhBvYMcQ6Fib6kDK79N/ik+xY974ybcucRC8w8LsCBKXU9twDj3TI6k7gvKON+yXfz4hYv8wOMNKuYb3vp1Wi0t+kJOY4gbgA+6hfWsHp15Ld4ygrC/RYSvMm7qnc/KCSsHKZyTxbiwcYWG26QfKP9nJwwKmSgHulRgQB9nsrIZhxx218RPAkmLV1VquATSvYx1Z5Dccr0X5YZ93kxLqYUHdqUn/yGSIgk+D/Rd63meLDnwPPkvyQOXq9jo4s7nueoxSfofZ9FKHqDLwlzxRF7o7sRLhPGjje9akYbxngunqvcNmi8FXOrn/O9g/Zw9Qu3ZpUMRL+bHkMrToLl7d79a
 86WSjO+j
 v/Su24So+D9Pxtuz+GjkJDDTnlIZ6P4pgkVd64HKRAaYMynpX7vMV8SgwmKfIvPIYykjEGKc8Q0JyaJtnJaitHtvjepVh6aJs7FkZ/jyyZjAePOqj6hMm20AJVETGr19f9Uo/6FOljn8Zx17imIi4HFshM5gPUyqbklGoqqo+OtaHQdI+yR8oQTlo25yzn4ZS9W8/sBFsiIb3iZ1Hc5G1i/eyuf7+/VcMtaSlGx+xI60mxeNCvZVBjZtcJlNEYqC+qSHcoiLqJBgnVcdCpJ096MBYEW52oVXhXCjN+361kA+ifeKiT18Q6o2iQoVmM1ikbS/hCRZCpwblaT7mlbCrqTy4XrktMCxh6ia5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

June 1, 2026 at 12:30 AM, "SeongJae Park" <sj@kernel.org mailto:sj@kernel=
.org?to=3D%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > wrote:


>=20
>=20On Sun, 31 May 2026 17:17:20 +0800 Kunwu Chan <kunwu.chan@linux.dev> =
wrote:
>=20
>=20>=20
>=20> From: Kunwu Chan <kunwu.chan@gmail.com>
> >=20=20
>=20>  DamonCtx.__init__() uses mutable default values for
> >  monitoring_attrs, targets, and schemes. In Python these are
> >  evaluated once at function definition time, so multiple
> >  DamonCtx instances can unintentionally share the same lists
> >  and DamonAttrs instance.
> >=20=20
>=20>  Replace the mutable defaults with None sentinels and
> >  initialize the objects when needed.
> >=20
>=20Nice change, thank you!
>
Thanks, SJ.
=20
>=20>=20
>=20> Co-developed-by: Wang Lian <lianux.mm@gmail.com>
> >  Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> >  Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> >=20
>=20checkpatch.pl complains as below:
>=20
>=20WARNING: From:/Signed-off-by: email address mismatch: 'From: Kunwu Ch=
an <kunwu.chan@gmail.com>' !=3D 'Signed-off-by: Kunwu Chan <chentao@kylin=
os.cn>'
>=20
>=20Other than that,
>=20
>=20Reviewed-by: SeongJae Park <sj@kernel.org>
>=20

I'll=20fix the email mismatch and send a v2 to make the addresses consist=
ent.

I'll also add your Reviewed-by tag.

Thanks,=20
Kunwu

>=20Thanks,
> SJ
>=20
>=20[...]
>

