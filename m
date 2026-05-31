Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48799CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 12:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A19A6B012F; Sun, 31 May 2026 08:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B1F6B0130; Sun, 31 May 2026 08:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31A3C6B0131; Sun, 31 May 2026 08:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C27E6B012F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:16:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A418EA0544
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:16:55 +0000 (UTC)
X-FDA: 84827613990.07.4A34117
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf01.hostedemail.com (Postfix) with ESMTP id B83DB4000C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:16:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NxKn+BSv;
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780229814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSkYXQH+UFXJ6VQOm8Vmkeg+L5wEsvwuM8wq4irKhqc=;
	b=rLWvSw5PYoozA9fHtwpcSICgWnfP+1N4yzijIEW6QkHoHXLypF+JGrlIK5dwOrzz8YaNSj
	SLU7HmXJSYRJTQlHV0vAiKPsM41J+Dv8GyX+gmkCmf33UtsKcFeV26jNU8r+MDPQumN0XM
	r6U6mHxDl4S1avKVqp2tOA6BETKVKFo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NxKn+BSv;
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780229814; a=rsa-sha256;
	cv=none;
	b=W4PxL4BcPTpAZtgc9vYRApvYmOk3bxZZPnWUDNoPZiAQuPeI+w2/tFsdl/bez2ynGaBCPn
	MtsQVfBKQgQxNZj9YpbURHm98hc0XY5Tfd6sWrB6iWsJD17IQL6YNozhxGLx4q6+O2++6L
	EqqHx2vJ8f78brwX4AjxJARiEtiwTzk=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780229811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PSkYXQH+UFXJ6VQOm8Vmkeg+L5wEsvwuM8wq4irKhqc=;
	b=NxKn+BSvrTkHb9Cl02yAUV/0u9KXAEmOObugtmlyFUlsBGh0DSEGiqSlXQGLkVRIftZXe9
	x5h8bJDjj+P9ZDUTsWlezr5gqYuXwu3LNCgUCaYkSJxeQl11lIlMHn/TewWEmgZf4rpiaL
	QVZPbd6dBBxh8e7fDiucDUEHDGN7YyY=
Date: Sun, 31 May 2026 12:16:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <cfa837d8641972b79a404f4f9d489644dd6675f7@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm/damon: fix stale TLB young-state handling on arm64
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, "Kunwu Chan" <chentao@kylinos.cn>, "Wang
   Lian" <lianux.mm@gmail.com>, akpm@linux-foundation.org,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260526145034.91594-1-sj@kernel.org>
References: <20260526145034.91594-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xww7ypn83wtuzfocpgn5j5rw8311weq7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B83DB4000C
X-HE-Tag: 1780229813-999189
X-HE-Meta: U2FsdGVkX1+z98fPqdtnP3BctIrASbnnwV7ZmCFtTBJ9sH67glUi1fhtkz1KcEy3s2AhyNW0toOv9wLuE7CS25JlAJKVsoHpOOXyAktSBJ+mHL0uODA0USvJ3I8t01FYD7DUh+nzyCuVgKZ9i+beBTmln3yjA2VCY3EPJn6uq9e0vsEb2KCf8eTg316a5SdqxEs69KPyGzfVBwi6cgxih8n8Hgu107B5Z/C9Oer4lNay+oAwWIMWvjeuUU6sHWFjrxnwa0G6ifsdvtggiWs2E5hrbf1vN6xy/hmjarEsyHbPHCVrgm0PBKv5LRe37PtuyEUPQUIVO6L+UXRVDKERvO0X7h3372QRG3e9aIf+/YZD7pJmDJDgJWXZA0G0w49dMvZ2lpF7Yn9y7ZQ0NBQJc8jHToJL+nNMsxua0XcI/Z/eEZN+0hF4wyVOB8/qaDythkRxjFZCFypUmzMUKCHgRTzFmsDKYG8zYPLRQi8+xABNkq6evZ2mBwXPA1tSDWCdIvY4FwTCvWvGq06hrhG1f+dSSNlqvYyj9lUOvvpKNLQf/jOSa8dQXPyce56c9wz7pIZVlw7HlnSi2qiownwdU8lyALN0yKaljKTSgpyasD3rNQIg/Ol3PEsn0mLy3h1XuWVakO6vyaDHrpS9Zs+ufuwuVj64xX+zRfrINUxFHc5er8YvtDbwPFiwtx4x3loiQgdavirHCIH8I/RkVEUfPw9mKd2D7Z1yY+912m/0ORgGC6xiAG4UKQRr8R8eIwCfJAaSxzDV0RMqgQGRF83vvBGeLNGFVxKbRSPbl4JzHZ/boKCdTHA99i8hl5lPMNyRyWpFkUzHZei5nrqsh8mkJAMB1EfRLIhJLU21DrjAXqrk/+KaOcNObWgcIhoX8F+Bx5KHIY3H9eiDGISg3MkdCx5HWwWQ3drnXokdHpm5Cmb2cvwoLqrPvI4Doe8y73vLrpobrg9UvN4+3YLeVDF
 EZ5hzH3P
 ++fGCWmT9C2ClXNknV5xiSVByOhRT0iJ7PrevSXsaCnUbJ9RzkSC/9iRl2BH54ouoOqIm4ieAvdhfhPpoqzqiF/3HnVc9Qu3ylhO2OJIxxKGihqeugjH7xXb2Hr4koBpFJ4f8hUaSY9jUf0xR28FR2m5hIepOyl9yHi6hkS7htJstrH0Zss+rDyjeCyJaSvjqLhCIg5Mw2ortgmIvC3J00gZQHfXpEnQp0TP8WucqYZxl+9B1LSrsMTgr7o08dDWejFa6JpfL1xW/Gm3s3+ZBqEbAaonNhjmDo/45OTdE9NmRh04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,


[...]

> Thank you for clarifying!
>=20
>=20wss_estimation increases its working set size up to 160 MiB for this =
issue.
> Seems your test machine has large TLB buffer. I think we should decide =
the
> limit based on the real running system configuration and apply similar =
approach
> to other tests including the apply_interval.
>=20
>=20For out-of-tree tests, we may better to provide a guideline, too. E.g=
., run
> this sort of test program with this DAMON config to find the reliable t=
est
> working set size on your setup.
>=20
Thanks=20for the detailed analysis.

We agree that improving the documentation and aligning the tests is a
better direction for now. Adding an optional feature mainly for testing
could confuse users and create additional maintenance burden.

We've already done some selftests:
https://lore.kernel.org/damon/20260531085633.48626-1-kunwu.chan@linux.dev=
/

[...]
> >=20
>=20I was thinking this again. I still want DAMON to be easy to test. But=
, is
> this making tests that difficult? Users could increase the test working=
 set
> size. I'm not very sure that is too diifficult to add new optional feat=
ure.
> Meanwhille, adding an optional feature for only test might make users b=
e
> confused. DAMON usage might also be diverged and add maintenance burden=
s.
>=20
>=20So, now I think another option is improving the documentation. It sho=
uldd
> clearly explain how and why DAMON does not flush TLB and what is the ex=
pected
> problems (in tests) and recommendation. In this option, we should also =
update
> existing DAMON tests to be reliable and aligned with the documented
> recommendation. If we find it becomes a problem on testing even after a=
pplying
> the recommendation, or on production, we can revisit.
>=20
>=20Regardless of the decision about the optional feature in DAMON, I thi=
nk such
> documentation and tests improvement should be made.
>=20
>=20Maybe I'm biased, so any input would be appreicatedd. What do you thi=
nk, Kunwu
> and Lian?
>=20
We=20think that makes sense.  Explaining the rationale for not flushing T=
LB,
the limitations this can introduce for tests, and recommendations for
choosing reliable test working set sizes would be helpful.

If we later find cases where the documented recommendations are still
insufficient, we can revisit more intrusive approaches.

I'd be happy to help with the documentation work if needed.  Please let
me know if you'd like me to prepare a draft patch.

Thanks,
Kunwu

> Thanks,
> SJ
>=20
>=20[...]
>

