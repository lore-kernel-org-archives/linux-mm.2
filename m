Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F2F5CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 17:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5728E0003; Sun, 28 Sep 2025 13:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CCE8E0001; Sun, 28 Sep 2025 13:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9BC8E0003; Sun, 28 Sep 2025 13:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD588E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 13:26:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C99F7C0144
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 17:26:32 +0000 (UTC)
X-FDA: 83939338224.07.75362C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 450CFC000A
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 17:26:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M+wJ1ZRP;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759080391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JaxgNDXflqL3avQlXoHXd938FQVmjidir4y+OBPlFk0=;
	b=gmD6RA7fmvG2ahLtl8swX0a6/MZ2RIkGmJfJHpRenf/Vu9wJXUzPxSJRcRf7tmYgYmacph
	MClcX5WeMv9bMYge+EFwmcG1XOmNcRXEH1qmlrTSIe+7TNmxJzTKfgwuA7Ny9cloa1pT1Z
	qm7QPZ68naMdJQLF8cObVHzMYQ7W4u8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759080391; a=rsa-sha256;
	cv=none;
	b=fxAmF4MlXpYlq2dJZBJEHS1wewGZZim+GHzQrpbHSVnyhi5Tl86KatLmj0ajfzv/+BOd70
	4her5W5s2ombqiHvBZFrNysdMUAzbXiK+7LPaXr8DvPFjkaxIfFu58/baKv7glKmIDhnN/
	OAgwKbMCekMn78hre7PV04g+udojvAU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M+wJ1ZRP;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CC2262198;
	Sun, 28 Sep 2025 17:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5A1C4CEF0;
	Sun, 28 Sep 2025 17:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759080390;
	bh=OF7eWJ87Kl5LRzmJe4NN5nJVmgj/D1ixJcTK5JUoabw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+wJ1ZRPdGfWAT3/SWUywCk8+MFsU+4tQrSBZnYh/+goYOtPVPlKJO4mKVuhn3QUX
	 9StVYWd8OrqqQQN/kP2tml9MXZpp7WXgsA8iEk71jFoIh7gyHBZ8gDIOlFR6REW7to
	 GYMuDeYjFuvzFj0qBAuwVW5Outbcju1VZJtHT7LoFtnHQidx1MSPSQrGJQIZWdr5AX
	 ZeztRWJdsTftWwUt1KnSGHYld2z7dKRLuzMvrSJTOpMNGBCdgA98amQjBuR3sk8OrA
	 Aq/HTL+uI8+A/eeWIs6QUj7EomLXPWuDD8d2mk9uPwqbi40vO2mr7SUVu7Hw/+Zt+z
	 LukmsUuTbcosQ==
From: SeongJae Park <sj@kernel.org>
To: Akiyoshi Kurita <weibu@redadmin.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: admin-guide/mm/damon: Correct typo "directores"
Date: Sun, 28 Sep 2025 10:26:28 -0700
Message-Id: <20250928172628.61235-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250928064651.281325-1-weibu@redadmin.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 450CFC000A
X-Stat-Signature: 8kerq6rwq8ke44zsxk46psa7n5h141o8
X-Rspam-User: 
X-HE-Tag: 1759080391-704815
X-HE-Meta: U2FsdGVkX18MUu6dDZSLQzNq67/bZ6faEgczIsg2U9P6HRIDx5K1ghuywRmqcy/psP0zzgsrpvWYnr+0Gqvnpdl9CNvg7/kS1BwIo/cEgw1KzC8hivcsqnCIroXvU+tLz00q5A/dJWufgWOJdSJnWyoUbuz/Y+Hod6XMJXphLS1x/CfbXZ3RjPdEQi8Bu8sF/uzInl52hhsvK/VEcuULVBGVBb6lh3o1Qr7EfY+Rh3u5TWNz747Bqh2N4SxxNYFgXCjFANeccsFJ1vnsgHiaRPiwNstDkYEj43kpkzHq5JwQ1rBz4/rW2S9CxfRnB6C0HuIyAPIniLbD+s4+vCfiyF2CQ76+xmoq1q+PZ26WnmoV8Hvy0EnQsRMGqi9f9F8brWvlZwW8MpDxIHP1uWiyeLGAJKqyQQ6zUyehe9WRxq9Km9mNdyp7awN3XC8j7d2eAvePjDPw64Jzgts3mQw2+nu9rwYwdcwcZ9mqvLaWjHuru5Lj+S38vdcxDPQa3q9R/IKegUUlsCCoa0y8zNU6lxz97PQ8QDlL6LiCK+Ddq2fkMWoLcbTaW3MW+qkcMOUmAAIrks43kL6lK2rV8XoqOWgjg1tXOi9oJQ7nBdUemSjUkzHRrsu1uzK5Z0Uq2NXouBa4ikvUwWiHsQsOAiF2/O+eO+jcZreUk+EuDpwTH4DaxKMxpNHTO5ppRhLhteMN82TvI9oY/GnvFWhEQpz+sLcnE46fxeL++4Eqh0U8Y5wZHWJ/v5H4SM4r7vsYOw6aV+KgiKbg5SaI0D8+tuiwYOIxU3zBXVGGkIXTVBXhHVZY6CYJ0KQNsTJrFTSAvLrweI0N5LbICnDlWViNW49FmemqWze7IEJEFWOFumWo19PDJv+js8c0i6JN5Cg0pE5MEC0XlGItm4oFC+YS3HGINri9BpaqvnDXZwwYZ1sKu8ACEktqQTLyAj3k4TCPrc6eMcLGaGMjCaiT6Km8EUM
 DRoMGfoK
 9tN/g0ieuZZbuIwtITfThEfpBOBLr/L4ZUDRySRrzBNfeWIHmau/ENoLh9fQdX8BxpWO1UzR07YmkF2RoFQMjK/RwgwPPw7fKw2vQ30yJpb4HbUAxoVdthmOi8XZNKyqpi7vs0X9icqacXFVS21TJt6Aq5wPknE+vsr5W10dimLEaWIU+HI+EjXVCf8LDBzdI1kPEBL15x2We9srYzTvvr2QFH/sU9ZEFb/f1RFUzhr4GWFj4GO71lpLFhFfJ2BKO4fMrZwb0sji+ykGkXrD/qsT/nrvVb9ZaDK59
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Sep 2025 15:46:51 +0900 Akiyoshi Kurita <weibu@redadmin.org> wrote:

> The word "directores" is a typo in usage.rst. Correct it to
> "directories" to improve documentation clarity.

Thank you for fixing this!

> 
> Signed-off-by: Akiyoshi Kurita <weibu@redadmin.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

