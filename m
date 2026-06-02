Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28069CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 14:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384016B0005; Tue,  2 Jun 2026 10:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C206B0088; Tue,  2 Jun 2026 10:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271D96B008A; Tue,  2 Jun 2026 10:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 188D56B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:23:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 774F71C105D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:23:36 +0000 (UTC)
X-FDA: 84835190832.14.D4729BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DA9091C0006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:23:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpA95589;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780410214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGMvFUKf+E59w4JOYmw7LcNq+OCPKabJzFFOMVmOnEE=;
	b=FTlCiAsFvXK/RVG468QM/NqxyzYoY70/CuULWjM9CxFpglqCy/qiMG7GoyzJ52P+FBT84a
	aqX5HtwpROdmICUN4L/XGYnqOIrWvxirV8cbsh0SORLAsYVjd6QxWRyOU2HWWSZovrIgZs
	HHyZ8JW1zvBdcWPCFAEtKTtd2Z6iMEE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpA95589;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780410214;
	b=Y8ywAWrRfbnGU2dGNjeeRFCAWKLcqsycGPs9I87ni57i1PJZFGW2L+SsK3l3AVFG0dXyjt
	zlcyA/sc30ZIhQN0fe3r5nI+9VckD2zs4h8TLttQCKCKoTMxi2xzbDCV2IbFbZebiQ4CFB
	J8gWRzd+QAicpzrDex/+veyex2oH/3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 419AC6001A;
	Tue,  2 Jun 2026 14:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45EE1F00893;
	Tue,  2 Jun 2026 14:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780410214;
	bh=eGMvFUKf+E59w4JOYmw7LcNq+OCPKabJzFFOMVmOnEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpA95589+ipumw5VHySo2fV4s8ZGh2wyUm2FULSPRJFNwz4u0hcrvDEH4WGqDogAu
	 ZSmUAgpUAjM/OMMURAfRGz7VDedxD5mlpJkOYxXcmSc1zGo+NMrh2xjYzIJ7zSZ0Vj
	 yeSA2pJ6xSmNU+CtzNPxETytqaQhVGZIcdmCq/OmYNF2FbdOBF3Cm6YBfxtbhcf02R
	 pZ8E7TlCb0PwBAyyjV+e7jSyONZp6Nb6tpSv/9x5OVeywzfEKHbxNGsH1AwyWGTCEn
	 WP9iyHsBZoruVX5HTd0O9Yk7ULJKa/tkgVVzB9rOKKL7V9qJ/EGTRwakhcDg+bSmbK
	 DAPRADr+8ZKmw==
From: SeongJae Park <sj@kernel.org>
To: Ruslan Valiyev <linuxoid@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/damon/sysfs_refresh: test kdamond refresh_ms
Date: Tue,  2 Jun 2026 07:23:23 -0700
Message-ID: <20260602142324.102073-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602131217.2210912-3-linuxoid@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA9091C0006
X-Rspam-User: 
X-Stat-Signature: 99bgb6mm5hg6bmitwgiuuxfrbqwounwh
X-Rspamd-Server: rspam09
X-HE-Tag: 1780410214-817383
X-HE-Meta: U2FsdGVkX1//Jb+tQw+hH+eraD0ltrWf+imSJOYSIaJq4tmpPRpnSb33dR33hOmRC4F7E3deC6+zFRoA6kR/SRcXs/u9w7ceQ6IgIBX7svEPIZlESRUKXE9aouRt26BqXfwJD3qZ0ZPKOFTvrf11idsSzon2pv88Ao/7xIexqoE7KxIQS4j71SNBeR6jpcsITkcoyqcxtZuJvfEBqe6nDA8QYNo9Ps8HV3JNvpgZSAU76pjPXjYbHIihtCd6Wdh8Tv24Gp9dhFQCoJ/ZBKWFIYAHyWSRueFCVKPiI3QCX6lS0v7NDKMBgxDaUJVhzfYfCrJQPbkkg7rDTk2in73s3dK/b6qA0SijxWjRg78dO4IRmcKlIBBjLVYC94YJdiGIghy3uYC0daGmCZbGQ78lW+lQFktFJaBcvk4LOigPv7i67JO0yzGHLtxJ8y4PK+TX+Nf7MvS8hwXdCBK/T2UkmSYSeH1dw6yypCk84FcslwNLMI2KkeJK2QXa08OU1f08ljB3AYxfBQDGErlgUgoiHRAPwHx5tHOX9GQ/H2IISfi0+jpm1KGBESCopd6sC+EW6xw3Nq3HWTjClyW7SYxVVxKRqMik7WfLY3KzmQYbb49Q38/sqj66oRWTcc5bAXWj+doiYx68ob4qqY0S5H/c8DtrOVWvMfpPVisQLEO21Kfcp/P+dZ2Slu7xPwV+RqKBLREGwVuDwUKAWDVqHxpu76gJKY5eHERMLeGTwqvlYuugZkd6NocmopkNeeO2EtZfHsEpIHqLGKv6zU+bN0pK0O26JgiQNhCHXikDVY7FNwL9v9VvDfrUewhcpgmEZ24hfymq0o9D/YQkFWDzmXX+12JPk8NpCF+DjAff01U/I4UHJKB2N9O/tandXTj790xpeAo1bu0wH09VzZ7uPR+4tXA+tNkn0vFsg7XJHsS+pf58k4llfbRvLwNOgPw6a2vHyPvn6WpMDpp0OdhvWBd
 UsMyKGkA
 g3zeCcerEyv8SU9NW0JVfro8U0qFgu5lprhqKhosrLqYRvVhEhFkGBKdfb8cCnisBGr/kY+yUQ745EA49zebA/1LblKoVRIqmgwJvk/z03VCZX0cbBD/XqhiUWUtv1FFbM33/YwK0I+rlq4RVeSUbMNkmIIWAGyB+TIM7IeWk2gKD4zKdEJ2KMXM0kK9J6fitROC1wuarQfwllxqFXpxp390dV5+sJFeWkWpd2SlQtukNUx1Gi0Pxzv5w1gCcjilfX8g8pArmVWENZUDjvIO6Y+qiMX2L7ilf/tGOjcfN0wUzvJL/cOXpvOz1j40eFBVe/1e4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Jun 2026 15:12:17 +0200 Ruslan Valiyev <linuxoid@gmail.com> wrote:

> Writing a non-zero value to a kdamond's 'refresh_ms' sysfs file should
> make DAMON periodically update the read-only sysfs files on its own,
> without the user writing update keywords such as 'update_schemes_stats'
> to the 'state' file.  This behavior has no test coverage.
> 
> Add a test that starts a kdamond with refresh_ms set and a 'stat' scheme
> whose default access pattern matches every monitored region, then polls
> the scheme's 'nr_tried' stats file directly, without requesting an
> update.  The value can become non-zero only via the periodic refresh, so
> the test confirms refresh_ms works; with refresh_ms disabled the stat
> stays zero and the test fails.

Thank you for adding this nice test!

> 
> Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

