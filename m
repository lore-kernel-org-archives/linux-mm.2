Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBAEEC4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 01:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95876B0113; Fri, 17 Jul 2026 21:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D9C6B0115; Fri, 17 Jul 2026 21:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983256B0116; Fri, 17 Jul 2026 21:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5C86B0113
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:13:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4F24A08B3
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:13:37 +0000 (UTC)
X-FDA: 85000124874.07.D4C70D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE1BC80010
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:13:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZgRX3p3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784337215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/W/YiWHxrSOQzbisnMj63FpwIA6fnyz9f+4A5f0FVFc=;
	b=QEPiFJNFGS3fPHjTSGKtQULMlMktFp8qrn/fd2Mifzbm9F+ttwQD3SDLrroReKwPuN3dYk
	xKKLrBX2E2Qti3QLozXPAv+korfPmjNAxNt/KtXiSh456EellQoCUaff8Y83yOgHvbJL18
	LgzzksyNGFyEOlAmccOaORB3jdwabYQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZgRX3p3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784337215;
	b=eMFh+EDxV1uv7a3T8yhs7mCW0O4TEBu8QGRgFGooSvb3J8yIwa5kisZDqJ9+4VMdR3ljgC
	88OkV66o9dwhocSVtpjns7RdADPh3J42oPb8pyP479nGDXW4w3pLsy/qIMXnMHSw7OMvaX
	e3im/BcHUKlOg48GkoieLx2Z46JYFLE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B8AE60A7F;
	Sat, 18 Jul 2026 01:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B6E1F00A3A;
	Sat, 18 Jul 2026 01:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784337214;
	bh=/W/YiWHxrSOQzbisnMj63FpwIA6fnyz9f+4A5f0FVFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZgRX3p3twD8Mf53Na7gn9w5HhL4x1Z9CEaA8WplCyEeU5KYw7hex7LTowSQ9cUvt
	 I639bn0Mh9rBvMpcwTibzThaEgL6XoVi4jxLxcHZzeP0uTEVgDfuMbpm4ELTvhUr+C
	 nKmV8sbuLohlH5vN80ktKBJT9dhdraPVICLZBElzhfc6q53hfFpJUYBKLgHnhNWvDR
	 wTseY/yRDWxTCHlgEPaA3pLVsBcwvX+CoSVyPs/+/uFNhe0RrlchwrQaBSVI+ivqXk
	 UrLevpeIybVMOAZoj2nnjSbM3hvyl/RgU0Lbn6SsDKv4YExF7Pfo5s1zcLtbL59VL1
	 HI23ziv/BSnww==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] mm/damon: fix uninitialized DAMOS field and kunit exec expectation bugs
Date: Fri, 17 Jul 2026 18:13:21 -0700
Message-ID: <20260718011322.94001-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718001442.87129-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE1BC80010
X-Stat-Signature: hi6ixmtn37e11m1swtd9wyrdgqafcttg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784337214-217881
X-HE-Meta: U2FsdGVkX1+IcivewqSDepbNTnn+JStYrRCchquDiOkrWxPkzVA3uyGgSDtF677QQ7XDPXIacdPXytCdJID2VmVbgFJcCphRa+G0VT/nKqJpEOD/sBlPi100OWmFRBiGdzV16SPKjzT6Y7gL/Zo7tAeEerTrHjbwhZZrNUS/8yg0+k4OaFsp88xkl3bHXX1RvHHuAo1oJ42WZ5pcNs131cltL9SUNuJvBcH7tlAiydKWrRZ55FbEcBaLaGLg9Nh9XZybCgmvp54XRJBywL+BnWxscThNqYUCXU/52rQQkyMqbUkxAmU2//34CngXMhf5jIzHqH7LoQCmic1OEnhoz5xWAUgL++XcaV5tta3C8ZG3c5kvzmHpppZJrQ7OIAMpWFpWm9uKxNKtz8c2020BPNVatV78Z/e5UNmIXBVOuE679IrIJ9KF2xb137o387/rXRFKf3CT99p0FhV9EP0O6Lais+0QcVaLXOhEO1ZAoOnTmJheXZ5BDGyH2JHqbd8MPNzj+gV6fllv/OXUjPNoXfSonSZ/ufftdVTx6GQi5b2CwFTR9UyI3fQRCJEFXS0DTqoTN3+AC7Rc/p+l2A7JrxV6lLO0EoXiG5erOdibIie/UGrISNFMNL3w/sJMXQNCRkWFfzvzRFXzz+oKvRh22soOdiMFVEf7FY/zc85WCTSwWIUjLwEq9oSIpx+MeXo1CvHc+s95XJaOEYZEBxJs1DuDcWkuWnWJQSnMZ2MypXwaO2NzCrQqRWcTWWWmzYPu43+qB/Y4T6WmPFZFYVbnBNuFV49yBN1WG8HDM+UEMa7jJ8JAXQUcawFHxcb5K2RQ2ddd20dk7OifDCaxZ3u4NQdMAk74blwLWDOk2wW3KfPQIxww1g62Rr1MRUxAzyVDSx1cM7XkKka1E+bz2ETXUN3id9NO7juUxHA9yxN3PiU2wenwUip7JOOZtZxeMKMt2DWKDYDASH3y3Emy7EI
 muos7XFW
 IsTDS/MIYP3aG7gHFDTPD5r7EkQS5ZieifHuyCbXPD0LtmccX63NV1sp7r5rdgNydoawznD9ItAgdb5RTyQHrcfy1+7+pSvNpYjYh62+Wf7cDRQYBnMI9z0Yf1DDQtzB7oU7ZWXq7mOS03qRUtUnCSCBAJlUyw09s7OVMyKMaz1Etha5oLL5M+Xb3co2FMJLxSRqejwpkC+1mtUCi/BXTqZ/LpfdpAYrF7JFO60J9ZOs2Ja/VFxUjAzhiGoXmk2cEnVhB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 17:14:34 -0700 SJ Park <sj@kernel.org> wrote:

> Fix a few Sashiko-found unurgent bugs.  Patch 1 fixes use of
> uninitialized damos->last_applied field.  Patches 2-7 fix DAMON kunit
> tests that do invalid memory access under test failures.

Sashiko found no blocker for this series.  Sashiko sent findings to damon@
mailing list [1], and I replied to all the comments.  Please read those for
details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

