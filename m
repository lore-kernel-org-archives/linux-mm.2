Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31DFCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670D06B03D9; Mon,  1 Jun 2026 10:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647FB6B03DB; Mon,  1 Jun 2026 10:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585606B03DC; Mon,  1 Jun 2026 10:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 47D1A6B03D9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:39:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D34B5C0586
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:39:32 +0000 (UTC)
X-FDA: 84831602184.14.86E36C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 255F8140017
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:39:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1d0atvz;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbuVgLi6EARiwiI2lEn+0Hwi5JqyQq0Zb5p01BU0Q1Q=;
	b=rYPOuGwCLWChZZwZa/ql2deEABKeDxpporAhVp4zfuM7kNl6B3A9l2j+w3FZv7/Ht93mYc
	JTk322BcaRGZL6bHb1lmsoM8R/KXNVFXo2eUrr3SHz51m6kzK/URjHNhe+wHkVzpiNjBvN
	6waUqDp35m14yWpi+PYi2faa9Olc5AI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1d0atvz;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324771; a=rsa-sha256;
	cv=none;
	b=FCMsPBXtdHf6HEpKH/JAMonqbOGch+1//Tz7jtuPborIcC5ZAVbf53q23/zqQxXcBMqg78
	XU2Y//T8A44VrxWGJnP+gZrmJJCax+hcDJ2x1LpJ7tQFRwMrH0nDvFG0K5G1O+/EzPsotD
	nOij8Qxn4qe2vM3gT10KvLXBDNokFx8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DEDBD41736;
	Mon,  1 Jun 2026 14:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9891F00893;
	Mon,  1 Jun 2026 14:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780324769;
	bh=lbuVgLi6EARiwiI2lEn+0Hwi5JqyQq0Zb5p01BU0Q1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1d0atvzJb0Zb1KqKiOguLe+KCog42bZ+MpATbE2KhgFGVKMAV8fs6kKITf1LKGXJ
	 xb/up/pc1PIEcpI7CKiD843S3k/XkItQLyKPhFMQo6+oguHWxF3x6drjaE3xr4VYlH
	 w/5Si+rEPri7EUmAM8s7MTai8vABrNgeOI832mQcrd/zuv7A/d32TIOotJxCy+9R6d
	 VdGq9YMg1A0Pp9FUrb5a4S5sOByaszycF+A1147ReKRfroVvU8hKr+NlVm0tYkgbNw
	 tZMpHeMaAug0LXt1OPFUdxed1tlsbM+/tcJDGQk8/v7oiydV+YgJHM+FeeZb6opPva
	 b513vPCMgNehw==
From: SeongJae Park <sj@kernel.org>
To: Cheng Nie <niecheng1@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	shuah@kernel.org
Subject: Re: [PATCH v4 2/2] selftests/damon/sysfs.py: validate memcg_path staging readback
Date: Mon,  1 Jun 2026 07:39:20 -0700
Message-ID: <20260601143921.115468-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <D2B37130D38E09AC+20260601090634.241864-1-niecheng1@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: awtcgzjbqe6oj1txfe7wr5pj1ocpnnem
X-Rspamd-Queue-Id: 255F8140017
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780324770-259915
X-HE-Meta: U2FsdGVkX19/HBZDWM7oOtYRpmYjXqgQb20irsUFpzdast+fh7Dl03doLjbcc9rdFLz1MVIUVvdQ4yU+1/IwRMtkTFY2KMhWgPkg0w4/Od0wN+u+FymwkfDiP2WjjQxbB7JcwaJ1XcoTnIZNxEhn4nDgkwqx4uWSvfLDg6DHGYFTvUy5QkOx4PkZgadigoUCqng8nPbrl3jyWFkVdDxLkfg67CDE5o+uwjl9YqAuIz8HLNmEHckm45IxemPeGtJbY0Sb6ByZUCDMKFxTvQV2+cGDwC+oTmhWH6BU3mbwNBQA7luZUlH+gHXlJV/3+PC8/P3iVf/tbsmVxs2cToUGHitaUKUYmQxKVM4n91kq4g0u8tDp8bzzkcOVvIkGe0Zt7pgT0IsD5r+zSf7NBczs6O8LVxAJ0lQY4fPWI1Xr7v4vcroXG/GnO+Q8Qfpd08bJgOo+78+Pj7/bakmjgb0WgayQcZjf+pACaCtTS1a+9PNRXGRoXzl5e6BNv48G3AcQJIW3sZ0ySKMIEqJnWNqHsKgmsFgTu3rr+IobdtjyNKyzG8nk1Hi1YmltMlvm271bMK7iGGFYlf3yeWU4u43Dz8SDAQWKoV6jpA0VYq6wNx141V6NBFX9evgQMUJrXGbjzo7RPMaU8+3f3w0CaWw6rEaFjGzmTVAdTRJoNrlRyTZbTjBr6W0Ypp+KMHkzATOKGTmu+c5OXOeYinvu3N3evpVWRGEqEjB6eUgis3EwLUIcqq8CF6InPP4+61rKM+B/xKR9MzEX2kJVzwwdjWeLWRFiDiVFLrCZ6fuzmKxAd/s0w29NpNfV3mYXVapgH5lDESqy7dSGbkcy/DSRBZgh/xSBncT30Pm7bZR7Fof0TQI0ta56j6OGZkrqSHe4lZW4W4a9nvfolooQlmEFXqSkzP7aELC+hAx91ZBy/adu25ztRUFGcqBREw7MHNLXZBLNSyMClnVcfp84CzFlc9N
 13Ij3veT
 ugntUO1gnvh73yQKRyTQ7BS379DanRkkUv+N+v4E7d+8eO1jW/SDIoGDijPsn8Ek/LG8tF1VmpfoFrdnM/9JduU3tsBWwVB+b9WOLaz6mTazlTy6vBcHD+a9NPaEuQH1JzjeiFgZoZiCm41OJ+Wl/eqmQ1p8TAU2Ds6s3xrMkHyjimDpfyH1E2su/RNrfBpUI3jTPgp0FDjJEub5itDqQCoYzBr2lhqKSLNd7zbPTqVWmmmT4nA1sHG5mgUZ9GQ4tri9yQ69fxqIkf2yp72gDlAozyYUZ4KZ6ScE3lC6DHKoOTN/PbFtpaXUKWDQvf7i4kSCPDD3k84Oldfl0OafPZuXUbMghqpKEFSKXO27QBxmPgoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 17:06:33 +0800 Cheng Nie <niecheng1@uniontech.com> wrote:

> Add a dedicated test at the end of main() that stages memcg_path via
> sysfs and verifies its readback.  Configure the memcg filter before
> start(), do not call commit(), and ignore start() failures so the test
> does not depend on CONFIG_MEMCG or cgroup layout.  Call stop() for
> cleanup without checking its return value.

Looks good to me, thank you!

> 
> Signed-off-by: Cheng Nie <niecheng1@uniontech.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

