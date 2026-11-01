Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034A0606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FRYFayz2
Received: by kanga.kvack.org (Postfix)
	id E879C6B05BA; Sun,  1 Nov 2026 12:20:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FC76B05BC; Sun,  1 Nov 2026 12:20:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D666B05C5; Sun,  1 Nov 2026 12:20:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B10A26B05BA
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:20:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3670D120A3D
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:20:36 +0000 (UTC)
X-FDA: 85387214472.23.EC42F5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF373C0002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:20:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRYFayz2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553634;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szwoa8MQwk8nW+Y1WpnJHMkPZgcB9M33OnLZHwGiHB0=;
	b=DfTDTM4RajYfIhfEqP/YL0fznVwYWuGRq4zpW+0SiTe4d+87nibCLrC+cskaRt8ehBeKLu
	iW+liSDpBjkrPOiyCQRKmjRjT4vJZ2aQi6pqlJiyb4cFr5e+Fc67bn9SrEaOGFhgdXmRDr
	K0Gptmsw5WaRlDDF/bhAsxqvtBIOsYE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRYFayz2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553634;
	b=L8vMpdP6gPYuAxUa1BKOPDKhqNEAD8E/vIv46WoINhN8xQDM/L/vagwsPzYD6DyvfHzEwR
	uDF+gMMKyj8r348ORp2E2Miins1a7t/CcA6dbeXIbiXjc5+qIMsBUIu63BDQi6EsxiPN0F
	DTP5FvC9LUOJ+Tt8NYVeFymbgwraet0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47AB4600E2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7791F000C1;
	Sun,  1 Nov 2026 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553634;
	bh=szwoa8MQwk8nW+Y1WpnJHMkPZgcB9M33OnLZHwGiHB0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FRYFayz26BEGs7eWxRZYDsCGUgYPNkx1HTRnRATon+VHGeVkISF5PpNP6wWvLXVhs
	 mEqeI4Grz2I6guJ9LuSgS/+NIVjKJEpZs1CAOA9gdr+a3bC0JsdXQhFJGU9CQgfeY4
	 BVwU0BD9yQRvdsrSzWkibI9efdLFf8u1aNOUBfVIlm4m961PP0FR3HaIuMAyCEG6HY
	 7joAcoPznQIoPLrkQbg804aGxzqhf8PD16XTr4CDWbOfbLnkyJw/oDG9dN3TLSm+jP
	 MtJavQv/xra2xJr8bHshIkQo6EXYz930r0xmCc9TfnCTozN6zSMQYT9jGDZ6htbUmK
	 HOHGGbJLta+tA==
Message-ID: <sashiko-outbox-192521@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 6/6] selftests/damon: remove unused imports of os
 and sys modules
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Shuah Khan" <shuah@kernel.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261101171630.81477-7-sj@kernel.org>
References: <20261101171630.81477-1-sj@kernel.org>
 <20261101171630.81477-7-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 17:20:33 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF373C0002
X-Stat-Signature: rhz874twcgf4fh7e5xh9xkh31bfgpuh3
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793553634-389651
X-HE-Meta: U2FsdGVkX1/KYWWDRsmnguygMTuSpP1SNN1Ikjg/dlHtoLCzZd92IIECRjBJ8hI+3YZ6yBpLQCOnvvdVwH7/N3e+0Uc4+o/fypU0WkSs2QJk8kWccxEFNsaPLnn7B7YRjZ/IjHF7p6l2ugml7yhBEkfYoJZ73zC7Lt9KGg0JFfj03WlJ9p6uZMxVNlSDU1U1xh1EgTUixk8TVWGqPDtqlhFDS3L1pqmJsEfnFXzOPShPMzwTha2dd+lQ836I0tH350lW+93/Z0t/RuPf6wDUpjF0clDlL0iR9g6hKNmrcG2NYTGjAbZ//juEqn6xqExfLaBXKgH2E3ajxHiW2JtRqqCmNQf2tHIcVfSAAvZPoAiZauHUOo3Ro0o2LdWoHLWNzeEA/0eaB/G0w8Wace7m3UMyfA35oflFZxan+vA1oO5MFDipeIx/LTBqg+p3SflrLfchPoTKTCGlftIfy0vWfCgVYbgEzY/QnICW6dWET0XzzPEa56YDAGmfnXEjCOx99JJM/ZP0hGaVVk7NNdhPHydqPW0Jj7qCXGnZO31YdQQoyKtZu6XCsE7T9tte+nDoa4oDxyI4CaR6MEqe7RGMJGk0a2nSzFsZK8OLJjQVOq5ffRO12C1BrXVqVMJCQt72+lQyxP/KRPp/3CjGwCBRillCexoiffP9rFZG1zNSkXXzXoMxnHmOoNolKaj/VPaMg+YZWeZj71AxcOr0Fda9VZv9CeWh2599u0C7srzrdKkdHCkJ9vqjG9Bzu7CTO2VljpeJ1HmOg+enedp/pHHz+Mpg0INeH8U1eia4iBzy3Ct8LsqW8n/cpTmoWzAKecR2cfVbYyuLT5MjEoqPuMDiXi39htuUlQ8zBx5F8mLh615kPLLrbw2u2l51RAubS3W4XxQAgQ7E6TwIYQs1WCP8Zo1o1Ue7aVZbLVZbkao3IU+ByU/inlzKnAla1uZ0aO88a+3wKvW6qQw1au28Dpr
 xhbQUial
 8jBdbAba/DLtGx88c7KdB6T5nYdefvdtCBJ/NKf9YrVLQTKhbw9kqbkm0O23hrMv1c9c0GeHyPeJW0jaEwQrhei3/H64mS/RFr43ZVLr/p6rTsex88aXEflwIOOf5xapnZ352uPwGSwtYhCSWCFUXeyCEQdhdfohk4XIHc9lNVZMSEooBe+xCOORjM9hLX20QUjT74N/J7WhVXgRnCRCgA+tejSKT4RM8NT0DdfFSy5gmYXdGy+QZNszJwWBNvosrEMA7bxojMkHL0MoLVmDwZDeySgDiiGUaVPjeQVPWErcEnl5NuqI7ir1mfmw4c5pFUUjLiQPHCnltWjnTIhNW8jN3BB8DpBRXRJ77qEUVZkFBT5adhQhKvXPPPMtXnCrxrVyhY9RaJbz+Ze3Lgdp+undv2KcMUXibFgtEf2Ax1SkVuGetoOyexkaUI9U1hkTfNXbEZIIUMh6YDG3k2AtwZKfm29sp49fRMd67TalilxTwsDsYPduhqjz7M/fJUqRiOSX4ReFGG1rBGrppKDbAMsVV+h8mG9msMbvA/FtpDMvdf09a9Fp3GH1U4hRuokwmwrfQx+ucKQlrV9PivHQYZnxz3SOY2TWdxIw+djYs0K3i4WYqpYX771QCDlKrOmBIkkOyK87tDK6aqvT32RF8JNf9JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] selftests/damon: commit subject names wrong removed modules
--

commit dfc99fb0f6f595e8bf824229e67f0b391cab2a8e
Author: SJ Park <sj@kernel.org>

selftests/damon: remove unused imports of os and sys modules

This commit removes unused Python module imports from
sysfs_no_op_commit_break.py and sysfs_update_schemes_tried_regions_hang.py
in the DAMON selftests.

>     selftests/damon: remove unused imports of os and sys modules
>    =20
>     sysfs_no_op_commit_break.py imports 'sys' module but never uses it.
>     sysfs_update_schemes_tried_regions_hang imports 'time' module but nev=
er
>     uses it.  Remove the unnecessary imports.
>    =20
>     The issue is found using flake8.
>    =20
>     Signed-off-by: SJ Park <sj@kernel.org>

[Severity: Low]
As reported by Sashiko on RFC [1], should the commit subject be updated to
refer to the sys and time modules instead of os and sys?

In tools/testing/selftests/damon/sysfs_no_op_commit_break.py, the patch
removes import sys while import os remains and is used in
dump_damon_status_dict():

    file_dir =3D os.path.dirname(os.path.abspath(__file__))
    dump_script =3D os.path.join(file_dir, 'drgn_dump_damon_status.py')

In tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py,
the patch removes import time while both import os and import sys remain and
are used at module scope:

    sys.path.append(os.path.dirname(os.path.abspath(__file__)))

[1] https://lore.kernel.org/r/sashiko-outbox-192115@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101171630.8147=
7-1-sj@kernel.org?part=3D6

