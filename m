Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91010C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 05:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B496B008C; Sat, 19 Sep 2026 01:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8047E6B0092; Sat, 19 Sep 2026 01:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F65E6B0093; Sat, 19 Sep 2026 01:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8096B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:47:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A06CFA4285
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:47:15 +0000 (UTC)
X-FDA: 85229428830.28.79D31E3
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id DCCE840005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:47:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WKRfF3u1;
	spf=pass (imf11.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789796833;
	b=JxdUCDj2DxMlCOtRaFEcfZ6KXxcNjUMIOyUADmWdxraoMSVin2pmrcShl98DtZ+janwkSo
	wGUvPvJxKTc7aAfIWQFmed0JAM3vmxsOzmeRJ3ctLUFLgIgSSAW9XR71ep2dkz2WAJx6B5
	XKPJbiejnYAJf1456e07eL2GHMoOxKU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WKRfF3u1;
	spf=pass (imf11.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789796833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COKKaSNh5aTClL3pM4Jpjuvdb7nWPK0iDVawAIP9M/0=;
	b=my6CZvytDXVO8gr8A6RJ16JlytS+h+SUPO9Ho697OZY/B/9ExdQwHbFF4xglIBVmCn7rfS
	x0X7pg8BDWcuEB+J0+ZeWDmXX4liqSclLYSOUVXHFMPd1Sl9VQFMhb8x79PUZG7Ai4kCYV
	Oaa6H5owF1GDdAbkTqYrKjCLHGGa8bc=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccff31419so11797715e9.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 22:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789796833; x=1790401633; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=COKKaSNh5aTClL3pM4Jpjuvdb7nWPK0iDVawAIP9M/0=;
        b=WKRfF3u1+P9Nd5mRm55daewM9045kqt8UAYjFBVglSDCM5IluuF+fUyZ7W/Nc2dvSK
         lzYDaWERguk79NtXVxvyiNx5+wUnom9OvdH4bTwVOycYWcj2Q19qi25EvpyNMsqHk/b/
         DYup7swU3kS5+Tn0SoKPs+bGDfX2gY/rL6ltkOvdAdUX1c1jf5rP5fJaZsNX1XZ8PVxE
         s30OmOqRA8aqeyPkFOGlXI/pgvXZVjV71qW+YtstH90oPHqNPsBs7XlnAW+UnQLgAJ3h
         2MPqbqpCtjuwWrxyVb+J3+8NRHMII3SIGMoeU9zu+HuusmL+G+mE5cpmjYd3NKnl7TOU
         bCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789796833; x=1790401633;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=COKKaSNh5aTClL3pM4Jpjuvdb7nWPK0iDVawAIP9M/0=;
        b=DnLIKEznZ6ym1g3umbY74xAdbqFIzeU15VI2m96uTXLDY6OZmcHDQWFrCyIODqEfB5
         9UMVp6dOTxoNi8pygHwVFfxLRfrJ8KB2UVFeea868slesBdQfLI4ryMkzuPsx/LH1awE
         43rUil59BYyptQJmCS7ao6nqXREumDQ55PEFsuKHkBoNbc100XfjMja4upq/16+E0YyS
         A1ETeiNMw/93nCAOmEOhXL7PWZafd9n+Ie/hbB8GVrXi5z18r9nO78LvQDmMNOEPrpMR
         QWSvhLIutjUTMdPxsFx4/BbBrhU6CKsb5VgJOQd1mXSwdEWsj0fsnqT+Gc7HSN8l3M8b
         acPA==
X-Forwarded-Encrypted: i=1; AKwUvBxgTYBBvcgyReVFqraKI4m2k+LR5Rhes+LdfLNzeR4SN79AX2KSlaGJyWt67j7dvjSAc/nFwBIiPw==@kvack.org
X-Gm-Message-State: AFuF++kzaZNftYTA0v5/bjzeTZ/9+/I8MNNu/i6BGaLtIYveJOdHSXnA
	EAfB8tw1Kw5J2QjtSLLkVUcS+vV1z0fsfCuTWfjWR1/96xC0Q8z1smpF
X-Gm-Gg: AYBFou1C4PgRj9LIsr4gYyoScqsgIAU/w/BIeBts9cW8JBKP6RM7BX6Vio69yKpluHI
	XeiqprRuIoATbAhZtBpUBaxPHAIiVRtZ35SWaRm9tQJHeQLJiZfvrkgTAU1iVkOcjzriz9JE1wQ
	xlewunfvgFtmVy898i8aYHEzUyPXwAXHREuWO0HsFHcLeUrDQ5infLO+0yHSA/Dmix1NgN+frf/
	UKOuVIpz5M12aw0EZM6j0I01FNg35GRaXDLHDToBbTUInguq5RodD7mMOV6QyGU0ZclVpqp0CtV
	66sz3yRtNH4bLDp3o2IgoRzew5FK/Wd59rtTsZpJNLP5LFUiR68fgjd3FsWJ7ZQeYAR/Ovmp7R9
	Xxa/ADWWi5Safig97ifKPkGb+kZJOgQRZy+MbRvtvNvrgVLAkyIYehJcJqO3QDYAF718LhianFe
	gtXpdYljgVXje3PTGZbjp1kKUmAX8sSMicrYaykxZmhYCzvd/uMyeWZxRwCQyYSF5zKf+BBq4GF
	Ad5sbM+uji76fqV0FfakaD6/TqJ3OBL52RU5QSKeTCDkHNQDi7+iOpkjZC66ezZsxdQyGrFaJfx
	ZmKm1DYiGQ7ts2IjJxNx0cSE8o4fgG0eiT76J2KI50ZB6H65Q84mH8EpEJBtg38CX5k+DZZXp5X
	oTYrXvELjAUKJs9A8
X-Received: by 2002:a05:600c:8b61:b0:49e:69ff:c6b1 with SMTP id 5b1f17b1804b1-49fc5749edemr70586425e9.31.1789796832402;
        Fri, 18 Sep 2026 22:47:12 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a017-2b01-05fe-203b-7cd2-a640.310.pool.telefonica.de. [2a02:3100:a017:2b01:5fe:203b:7cd2:a640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd068059sm46003715e9.5.2026.09.18.22.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 22:47:11 -0700 (PDT)
Date: Sat, 19 Sep 2026 07:47:11 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/tests/core-kunit: test PSI goal rounds
 under the temporal tuner
Message-ID: <aq4hU5DNjnGELpUT@gmail.com>
References: <20260915060937.3423-3-kmehltretter@gmail.com>
 <20260916002137.101195-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916002137.101195-1-sj@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCCE840005
X-Stat-Signature: 8sjkeaqmi3z1qrqjm5ape6h5gfrrhq7c
X-Rspam-User: 
X-HE-Tag: 1789796833-350809
X-HE-Meta: U2FsdGVkX1+joAzePlcnAyM3eP1QXZcn/aqfWHYN7uYrimMevHvT8Ge/aUABbL/CcVEuNJSBBmIp0DMF4s0DKRc6o9AHbVtFMLmMQ5QPRESR++IFZDmvlOYR0ugZ53DG9YVmwGzFesjKa6Mx7XDzEHV20fWpIR7Yi6yN6pfwWg9Ni1IU0EEj3s2SXq/YVidbha1oDupIYDKsg1iOfAumUx84x+Hk+hgUNGcYxyz0CAQq16EcfobRyuTK9v86EKSsmmM11eYcCZkxUboGy7Nbb6lllCIigTaMsmidkAZOKkcahhUwyUGRlgyLlTiazS3E1EPVPYGxMg9AV04PIWuJdsDMzNGPql21PK3tsCqZpI9J/IidqSO9+CUD9aAlP4+K3AoqAQ4+YjnAN2iVuda7f2yXGwRfqOKqOsDC7KdYwi1F1p7LmpzInjJPDw74dgMmysa6w6cRVkL5il/pRtEgPDsq91BldYDD4Aphzu3BG7g0PTDfMi32J0rZccDdA84w6iVNLDbrwWCEye5XWIkx7t5zRk25a4B2bkI607qlM0tzYKJui3KRQwCmmx/HnWZVPuzmhpvJb3mso7kgWPDyFq5tfnktId4KtXF3gZxVtsYwYQQfbAAmKm/t0ibN4vazbJdmuTPrYEYev0uw7ykIvPAS/9LLj6h49QBLK7U2Y+k3dwBLwpzmc+9chqrNh1xCG+OfCCs4btKo8Gw7M4fxDICetaU2mPNsfGJwMkAGOFdwc0W/C9QfBATjpx4YeDyPY8pVLhxrcCG/0pFGlER5rL4cISXipcw3drbM/XJY3/3e+0yrnHzY+t88o/MpDNhhpCGAWIQ6XlOvWsfAtohTSWZ4/MNqVvD1p2al6Z6QYFZczsGCzkkK20+OeBqNOJq/2p5ppJgIw/fsubZ626W3WBqMDTFrIhxu2pb0z3H9O+O0de1ECzJehBBIQCwQrIHDc2LVb5PZQPjUjLcF0wn
 WJNED1zj
 5Yb1NxUXlbFFUYyc5IXZYIeDMpk9yqxG6QT2GQjGoKwn4ezeEwsQFOD+TdHKA0FwncMSyR5n4lulv3U3Xw7fcNiE1HRYUcW0Xfltcv97SbiZNlU+NKLinbAGIi8HEEzUxC3oqHmaRefZHclGTReZMqC9iPfJsR7fb/gYL9HVMm2l5kZD52VqVyV8lIrPZcBupCQ9R5xfv6Egp2PAW5i7lqh9fXFfPxz7PYab3HPMd/sOK/geDd7qCa80M4LJ5rmVdfPBdWD2frXAs0pGMdMp0xPuhhVKfrAyiAvK0gbTsbTTd5KhMBC8wESSVNVULVMW6ibXQgF2wg2HknDO3NGwkXh13QaJPrguz7WC5fV0p3ezYydMowIxx5/IUugZlNT62HXw/5yhYWflhjgYD7vTgVQkV74LIidvSAYTAB4nKeX7AkTkIqmyx59V5T2V9eKYlyb5iogtOCj+FG/Qv5Ji31bm+pabo4aA/ZHKr2mZk4kKO2FpsyyLSVbSGIUoLE/tOPkgGeRqAcvIq/II58IvclW4NUAzSRjoGxU9RkjMIIOyCNQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 05:21:36PM +0100, SJ Park wrote:
> So, this test depends on the memory pressure level of the testing system?  I
> concern if that could make the test result not very reliable.  Maybe we could
> split out the corner case handling logic to explicitly receive the current
> memory PSI total time.  For example, like what I suggested in the reply to the
> first patch of this series.  With it, we could build a kunit test for only the
> target logic, without depending on the test system's status.
> 

Yes, the second round reads the real PSI total. I used ULONG_MAX as
the target to make it unreachable, but I agree that a test which
does not read system state is better.

For v2 I can test only the helper from your reply to patch 1,
with explicit PSI totals. It would cover both tuners, zero and
non-zero esz for the temporal one, and the last_psi_total value after
each call as Kunwu asked.

Thanks,
Karl

