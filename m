Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFFB5CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485318E0013; Wed, 22 Oct 2025 07:41:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F498E0010; Wed, 22 Oct 2025 07:41:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6A38E0013; Wed, 22 Oct 2025 07:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 175B78E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:41:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8C2611AEBB
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:41:05 +0000 (UTC)
X-FDA: 84025558890.20.6738AA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 455E810000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:41:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GzspcW4/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761133264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwVTp53MY0OTR4XB8CqwUf2yp8gYIJ1wygRuvwsqZuA=;
	b=PmXpPEqD7v1YQ8PdfhQz987yldXCoiSIX0gN+T7C8kPEFvXvvoOTYi9VhOhY8RjVjvNoil
	m+RZpWaLpw7EjNSOVh8LmQME5biwQEWH/HI/0oV0F2cSc1knzy7vFG8YNGxGey5isyg8zp
	4FAfVjJAExAxAFnOsUUR7W1EMngWFZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761133264; a=rsa-sha256;
	cv=none;
	b=WFLeuIx0k+VZFaT4t38zKsDaiLxgJAyOzkM+4gIb8fUHf2G/fKZ5TmRBVC/LO4QbpM4Y1y
	jW3Ozg5tUOzT7tRMglHsF6Djog+bzL5TubQ0Xqt7wPePABJ03QqXmZMCQQtjyPwR8AyJju
	sxoTECVUhBure/ZYx07xS3FS1Vgj1zc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GzspcW4/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70A2762953;
	Wed, 22 Oct 2025 11:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11902C4CEE7;
	Wed, 22 Oct 2025 11:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761133263;
	bh=Z2XOzaBlqhEDONKoXE/pXMZHExzl/QDdtOnLEBT/1+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GzspcW4/o5KoI0A4n0LrdDNzrxmMecLrVr/mO2UOxLUKNuiyMExL7rUcHdzYsLuRC
	 2beepoH09TGSyp63DA3/mhclZKwPc9dzj7WoSt+O9BcsWN+ncXH/wni/Mr7BMsZ4KI
	 ZBlLaCvQXB8W0RT4ITIsqnoy50O5YUxotHcC19+UIsUUzkjTlC0CcBlyqqf2VAsi38
	 tjmJ2CcoGeK7DuvIWXJP8IRqQNgRMr/NpBwXUHBmp2s+Ptfdlw4FcH9uZIFqzqXvuJ
	 f6RSWqiIml2o+6R9+X9okzVy4WvNEhjSYo9GMukabl+mPVaptZyHrP1m2g/0oMoteE
	 ZUrGCDmflUfiA==
Date: Wed, 22 Oct 2025 12:40:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, muchun.song@linux.dev,
	osalvador@suse.de, david@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com,
	Aishwarya.TCV@arm.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v2] hugetlbfs: skip VMAs without shareable locks in
 hugetlb_vmdelete_list
Message-ID: <4d589897-acab-4276-ba4c-7e6fb5bec70a@sirena.org.uk>
References: <20250926033255.10930-1-kartikey406@gmail.com>
 <7a1d0eb0-ab08-4fa8-bdab-b193b69a8c9d@sirena.org.uk>
 <9d20e689-c06e-43f8-811f-3e66f3e86d2b@sirena.org.uk>
 <20251021141047.532542aecdb0dc5fdb95696a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4OqZh1KoSvhKKNwO"
Content-Disposition: inline
In-Reply-To: <20251021141047.532542aecdb0dc5fdb95696a@linux-foundation.org>
X-Cookie: Remember the... the... uhh.....
X-Rspam-User: 
X-Rspamd-Queue-Id: 455E810000D
X-Rspamd-Server: rspam02
X-Stat-Signature: 7nrcngshkr6wc7365apok1skge5gstin
X-HE-Tag: 1761133264-77034
X-HE-Meta: U2FsdGVkX1/Q+nshPo6aK/asWDgmV5vZW/oat4CTEX3GUocq3zY+k2cN6KrRsI7FGU01pHwXLbeVGQJkKg6iMOyK0a/cKOzq9hOChO+/I9D0anPDt2hQjC+PyOlIjEzikZ5UQQTf5K1yK/oS7OoTxIsnOer16a9bAmsLU+CG4ExAcpV4QzCknWIfHdAI8+tfFGoFhYulSzOVsptaueEusOvcN7ob/qm9wTipjinI7svKKe6ackmm7FtzwFAaEhBkLbZBs4J6rP6Xqxy5TbFuMpxW4bZ/Get5eigDULuA4HwmxV5fP8nO8CjOUW9KbsUNkVRZrCCU6qJfgK/1qm+5RDQW08pWwzJW4k8R/FBETJfdskW+2WAp3XEXKFHiDvs1GobDjYyYN1s1cCnA76ZMpxJmk2vwd1as+S2NxJUYZkFdiO4ZuYRl0YCRQ9ZNSXwimjKYthR8QL50/4RqiCf9zsHNy+UGg9pTl/uWzxbHVDJjpYJ+LZ2W0V69zorBTSICgVGMg7GFA+Hde6BEhY+BZnDcK7Cf43RDkfZS+Lh1QoIz8TjODd/Wv+/pDDz5q5LZn451VNbpRoYvGVIgG/1up20dhe5dlEsS2XlHWVHCTqHLbSQ2QGgdFvrj3bLkDDaSmtd02/9NKTNJkIY5YLp0P5ZWDyB+uRkU9E5ZmwMcXm8MdE7sr71xUiW9i60xKUGf++r6d0KTaxzmzI45mdSVfbjK5u7Q3mByPQeQwGHLFhJRPe6bVMfeVh2NmflUBF6oX2y7ir1gEVTvIOFxO1hvL6Gatj6PG/Q0akkh46utmqPAuCMjN9m29I5tOGLFlPAYmcp3Q0A0XWEjflaP5FWkmMtXkeFTFJpw+YnKsjwAZiG7ksNJJilMGxUVLMN6eG2x16fsW1iTbrKsboBhyLwJR9k7BFb8uU3bhGr45PszesdRBsRvsFA9c7fJ5NOsaRpXNXPDaMIO9TG7dT5r18j
 XG+WYA7h
 jEmqKbetyNcqVObQ93LGsYW/YmEexkrjpN2Zh/T+cDrpMfA/hkSyE7y9GQKaT2zbD+YxE3erRwvE24n1jQ03aiFMYHzqO1oAaAAnoLxc9+NCDwckgOqJ68U6QO6r/cfjNp/bE/N6xxlPMpsvAbyn2Tmrw8CHlRWMzBf65jwc6G8lLANi9rbXU44G0anU1NJDkRc2g/2O79HEZEU9miR0SWxCdurY749v8HLcrVKrF2rtx+o4vjFEj3gJydSS3uH5O4iBLbZXLPCPr/Of4CXuwXjBLnNylUysvAdSGSkqJTsUeMEI+CPkCN3DIDkgLfHaSSpxajjm1Rr+rPCTM/7JIN0HsdP/kF211Q0sycJwTLpBKDlV7CgnUMepojqEmxPieZmARnaHxbYGYmDBFtXHBbqgP3dM/H3oa5R1egAtIfUKaN7tuiI+UooOnopF0mr8fgn/ad3VbOfpar2fH5UcY4WXzDZKsq3+1klqWGcWQ/hmEughm/lrXfKWOcrKKwzaUpykNXCd9IMuMYVrwW33bjKXJfOSnFOav14qa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4OqZh1KoSvhKKNwO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 21, 2025 at 02:10:47PM -0700, Andrew Morton wrote:
> On Mon, 20 Oct 2025 18:52:11 +0100 Mark Brown <broonie@kernel.org> wrote:

> > This issue is now present in mainline:

> > Raspberry Pi 4: https://lava.sirena.org.uk/scheduler/job/1976561#L1798
> > Orion O6:       https://lava.sirena.org.uk/scheduler/job/1977081#L1779

> > and still bisects to this patch.

> Thanks.  Were you able to test the proposed fix?

I didn't, there were a lot of new versions in quite a short period.

--4OqZh1KoSvhKKNwO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj4wskACgkQJNaLcl1U
h9AeYgf8C223EQT2jxvLW57wso/4kvwPmy4zRY/uaqEPumCiV7M9VBew8qU3ElRx
9ziipdHzaoTM6Y1X3zjCB87u7RARUOPU8OsIYP0Il6lfDHCvoM/5WlA1xoux/fpA
x0+MOO8PTWqA51s4oc3PFg7xxKcJRmJnC6/FZQfoPXeceAHBb9zhPU94O9TbZHtH
9DfgG6IyFGyDkHePEVqO9pNl9qr9kxBIr+u7ZPMzERrcv8uIUreD7FV648Mq+ays
YNS9HEbWt+Ow9KB2I5a6lDUIPHcBqjlQYqzcCgBUBso4twnH8ZNLQQHuf3fSSw3e
RwQGXibOaeFS/9Zu+QXO5Xvl85jJxw==
=MsU9
-----END PGP SIGNATURE-----

--4OqZh1KoSvhKKNwO--

