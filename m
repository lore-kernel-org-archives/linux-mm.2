Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0F1CD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 00:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499536B0005; Thu, 11 Jun 2026 20:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A986B0088; Thu, 11 Jun 2026 20:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360786B008C; Thu, 11 Jun 2026 20:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 243726B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:11:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B5D9165AA8
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:11:26 +0000 (UTC)
X-FDA: 84869331372.15.4297C71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0F656C0004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:11:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBQATIv3;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781223085;
	b=Dr/f1Z/pX/uSLsP20Mvi8KJittqI1peQiXniOlvpzMqtctGaGERpR2cZ0pgKcRYYHnh/OB
	avMpQN0kCPpud2f9wW89sZZ3IUpBdXcr8hagI5e4HXDuiG54biooeAhCFSrx0lbGpJKZoK
	xlxeeqvjeIYlb7D7U8paEoE6jV7rQJ4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBQATIv3;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781223085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FQuoOP0H6GOvfWs9acfWr7SdBLQ4JX5Rqqd4VQi5Lw=;
	b=QeyXTkUKyHLcDVjwGgaLyrCqD3KZ36CxF6rmHJ3BhhaWsIweJ8GMMPx+0OQOpCRWv/env1
	IuKwsYZxTnB2fyzI+w0SCP7nfFvXeu2rEbLoPUBVCeWhZO2p3LRSchO/3N1cz9A2YMoECE
	UJdydZ/LU+6j1ZAZHplmePmaGrYhw2M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EB296020C;
	Fri, 12 Jun 2026 00:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF5E1F000E9;
	Fri, 12 Jun 2026 00:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781223084;
	bh=9FQuoOP0H6GOvfWs9acfWr7SdBLQ4JX5Rqqd4VQi5Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBQATIv3vlXRihKYdfldGfgFMv3KTGZQDg+cVNsHCAPkt8/QhNCK3Kvz8PSt1DZS/
	 pvgyAe0YYxih/Z0qD1iT5pEvMwTYrVSwSS/7+2G1jbktuxBixbp72f0LNCiaIaEVVT
	 hf+NlFKBtKU4p7ETcRjV5APBRdQ3IT8oVGnEwYROsf+bVc1D9AUjLSkSCHE/WqSkYW
	 /UrvwvCN3+/sPFgt9JHri3oNwSMGfrKvyQdhsrK0qRFEy+xW9VOe7ObgKhEgdZ2jPP
	 mthIZENeGtmTWkVjQzG8yf3t/xLQZk7iyHin4XOp5J/TX399Yg29NHKvxefRK8orl0
	 2ouiAUXN5i70g==
From: SeongJae Park <sj@kernel.org>
To: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/damon: add regression test for damos_walk() vs kdamond exit race
Date: Thu, 11 Jun 2026 17:11:21 -0700
Message-ID: <20260612001122.27512-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAF+TLO2PX71_-9nKBEAJ50+NpjNkgipig6=9OLsvbgZtqF2yew@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F656C0004
X-Rspam-User: 
X-Stat-Signature: bdgqtshduxki53zx16fstnkrgu5mif85
X-HE-Tag: 1781223084-326277
X-HE-Meta: U2FsdGVkX19buAdF2Ud3uZWbYFIMYfzXmCuTWUA0ikwqXby6WBJdCnb6i22SMUJABThmzN8+sLzyq1eODL64OoONvvv/XZwv7TsFszUsTj6jo6Jyfd4ccc1CAbqw37boV9lJ46P5IS6uNPw8I3DmVtR8Ns4nFb6Q9ddYY2qQ0+BmEC9h/NImF/C/1U+iREpUNENO+DZzdbCUYToMGY+zFOR7gyRdaz2hFWAPFZzIBbrBrNoZ6dtBWn515h0fclGThbugLaB4gTjJCQsDOAmKozIoEYKcpglLgsTRGCGy+n/6T/NyH2W3iVAF3t+E2CrHhC30GdO1tFS5SljumcnW0r3P3EpFjPGgWx8IyQgVi73a07mhOFGSY0rP2yFOqMBTZ+fXPVCzAAfEy3f8fBnKYGUo/iefh5ftIHndsXXhW0QvcA0cy2eC9/4EBhWo06la5mJg/yuhaDFdusfQtErRV+YR4qmgudsLHmUMmXNL0pAXA5NNQhdmGr/t6UZKcyE/Qiw2oGysBxrLp3ZRJpiOXt/VUZ3R3KdlEwBSCcf+4roNH5wgUbX7lD3AEj6r4xrQgrJ8Zmb1BvAxulQN+5iRf0jK4WFIpF47dQsy3sD0vnlNdwNpJuydSAyTz6E/0vvMPjxPFPwOCAkEyzk656PT0j6A8iVCcFc/0ADLFuUCsudEOZ12GUCZg3V9C64BBSO1O0Ul/VABwa0W4CArH2DpxitavzZUH19mX3XEiXkH5RaMiHYNmi/Elbl7gXrQoykrzsGPtotG/74C/K07s5f38CBS3OoMtT8J6tqjlyAJk8NvhJkq7HfbM36wmDEtV+FA44W0LanTTFMfOK3+o3RGkxe7W8wDLjrnvtPcKDoNPWrWBH3V/HROOIzqGcoE5d/3wLkh7eLW5c5NyyzZDmV6w/srvKAf92CEH/udSh44bp0Dj8ndme0iL+XASpxkObKnAj6IXJQtMI35afHBjps
 SMBlGMNO
 naLWEBRZE4DAgubOvac2IhyL7QqV8AAv2P6+g6GIQIDrOldpGvWXaxgppuZoKhx9DylORUenpspG2R6Pj8lFC3MPtdfEt9ZiGhl1We8n6z1uOQBx2PD9uM9UVYhSZJrG3ohcLKEujGN3smTGWB/S43i/N1BJZLGweZMpLjcxxkrco9OtkRrYUSg+0YWIGf4+LV1Nqlu3iE+WhA2KmSke6yTwTBrMH7osnrnrMXfNGlawuqvMvkMTMOCFT4OpdbcqmoX6n/CH/21KrsUh0G0K0Ka6voA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 02:06:51 +0530 Sailesh Nandanavanam <saileshnandanavanam@gmail.com> wrote:

> Hello SeongJae,
> 
> Noted on inline replies - I'll follow that format from the next response.
> 
> Following up on this thread with progress.
> 
> As discussed, I dropped the userspace selftest approach since it
> cannot reliably trigger the microsecond-wide race window.
> 
> I wrote a KUnit test instead, added to mm/damon/tests/core-kunit.h:
> 
> - Creates a damon_ctx
> - Sets ctx->walk_control_obsolete = true under walk_control_lock,
> simulating the state just before kdamond_fn() exits

I don't think you don't need to hold the lock, since this is just a unit test
and there should be no race for the test.

> - Calls damos_walk() and verifies it returns -ECANCELED immediately
> 
> I built and ran this on a kernel with commit 33c3f6c2b48c
> ("mm/damon/core: fix damos_walk() vs kdamond_fn() exit race") present,
> and the test passes along with all other 28 existing damon KUnit
> tests:
> 
>   ok 29 damon_test_walk_control_obsolete
>   # damon: pass:29 fail:0 skip:0 total:29
> 
> Since walk_control_obsolete is a field introduced by this fix, a
> kernel with the fix reverted would not compile this test (the field
> would not exist). So the usual "fails before fix, passes after fix"
> verification does not apply the same way here - the test directly
> validates the new field/behavior introduced by the fix.
> 
> If this approach looks reasonable, I plan to send v3 with this KUnit
> test (replacing the userspace selftest from v1/v2), along with the
> commit message format and other minor fixes from your earlier review.

Other than the trivial comment about locking, your plan soudns reasonable to
me.  Looking forward to your next patch!


Thanks,
SJ

[...]

