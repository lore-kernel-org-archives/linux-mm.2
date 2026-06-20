Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96996CD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 16:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6006B0005; Sat, 20 Jun 2026 12:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7596B008A; Sat, 20 Jun 2026 12:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD566B008C; Sat, 20 Jun 2026 12:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E915E6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 12:40:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 525721C481C
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 16:40:17 +0000 (UTC)
X-FDA: 84900853674.08.55A1C43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AB6BD100008
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 16:40:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrVAq62v;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781973615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3Tz63BYosudJXEAdf0pGSRWDOvFsB+RMzyuu6FMqT8=;
	b=5Sw3cgmLvGurTQ1/mbQzINDHj1LjX32lfP/ZWnMbtRGe1lXKlmrjFJQrEGkS+/x+hgR3u7
	ixva29A+gGVOU3GuZ5jGH+ToElwFD7LZu8K+M/XbipoYYOhKfyREzIWZ8ZM4c3gD/UiP+N
	dyxO9fuS5xWKtSi2BN818RfA6UR1cAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781973615;
	b=D/fxCO+WuFmFiQmfdAZ2bAbAtrzU2rJCeVDXMCIhGCNMLWRtZ6siRAxw92v/nETQxmUNw3
	4BQPofqHUXDnD4dP/tAZM426I84pMs+doRofu2UglnnouvfUKKscdlahP6Zv3iFTwB4fl7
	eUNTkJPhuePOiNy0cueexSkQy0Di4Ic=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrVAq62v;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90CF0429E5;
	Sat, 20 Jun 2026 16:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C331F000E9;
	Sat, 20 Jun 2026 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781973614;
	bh=K3Tz63BYosudJXEAdf0pGSRWDOvFsB+RMzyuu6FMqT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrVAq62vSWFLQklq1qa5DFRnbMwx/c1iX94ULGhFh3RBPLXHL7R8KBH+yClvSu6ZA
	 OQcMDYm86MenTTq9HurbEtizZM6Qj9nUyDZQNOf3NEjkIz+6ZFIKCiwjxFisTeYZrC
	 U3mGZFP2y+IygUGbNeX8JXTO4XAcwEsrhTsedNly3sN5SE/7AVumBaHTD7qi0wtJKX
	 ATTjbUnaFX5ZKlTkdnStARbZIPzRmH0bGuvad0XSxbsrnHjLd9uM1tnsTZnFz1fYKj
	 juwtfP1ULL6wMQqEBDWZfh7WVhVDQuArljVNKFWqnEt34ZN+SHa5ACgMv5X2JApHon
	 eid1GKN1ZUJrw==
From: SeongJae Park <sj@kernel.org>
To: yahia <yahia.a.abdrabou@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/damon/reclaim: fix potential memory leak
Date: Sat, 20 Jun 2026 09:40:03 -0700
Message-ID: <20260620164004.86461-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620032931.14281-1-yahia.a.abdrabou@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB6BD100008
X-Stat-Signature: x4wrdz34d6b5pmib1sqpchdh31x5s7xi
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781973615-343266
X-HE-Meta: U2FsdGVkX1/VkGt3AF4zeObUl8MgzDSetPJT1j5JJ8GuJJ5uT5xcJFGrOGJoMd9L2la7m9LaV1+PLfubSWzGeG/yby2MkON1/nyXPyPnAJuV1YRZ0kC6qsPU3YrS8WFEYcWMChCCk6OnujJyb8L1mKGWmFWULdelsp8wjVf5x69VD38Xb+ORPhDNgYHfV7KKr+vNuZv8ZO+xGgzOmDjBVlVZApYSr4FnjI+whyhCPQ69ZpL8kvkeINPEfAIW9pPag7NZ6PiuC8gyx8B1hDp3NqkK8ynDiIh9+oAJnhPRQLiVJHeH+a/fbjUEPXtBlSMQmMCzHtS0RHfkx9A8BWWFn0j5v41CkMthcCKDY5J2BmtkufdPcOw9zCXyv3Df9PXE1+uoM4v/u7hR62oXqKBYkjnkDAG+8zr0VqExQ3LzPDaowBwTvsVfzOclxoTu5pGYyX6uzoASdSswdPzuUruBJvGqL99piRMQQXD9c8WMoZEmJOnVVRRLawtMOSCKc4cBU3XGxDaMf1BQmnBvTM2mC2PC+ls5hfrVJSvtry4c82Xov4qgmpbOUS/uIo09eL9fmBwOsswsm3FdmTksthK1O5qhbLAjxqYlXrys82pg+z/GoBgdSb9gc9M5xKhrrcBzwDfZBPZokbpwLgf2xncOODqiqJbOZKSRfervWtw4h7XeFDBKwrSIH4oCjUZZZXCD6eh3Z8A6EzvEtK8yIViXlUB7GV2CXdBGl2BMo/yFJkaVV5NQQzglXk9jVwcbx5Hofb0o5XL/MtXHNc3SpDW9VrwgRMOQTB4LkSt+7bR612eW/r/3YTdYzrVnATW5vKelhxc2K+ZWMNvhq/Z1J8qKrCsCazf9/2WoBV/Fazma5L5kAM5w4ZoavD85DurBbyuq1qh/d5xny0PrevvC5FwXvaasKjzj1dW3Smk+oAjYg9PF4tHlF9AbpM2y0vIWlFHlCgCb7/OUi80YwwItPmr
 w9SkTKN8
 c6cZY/k+/YjG4WYfQNz2RkxGByCpXaye8pDnnqi8RKQWPuVKczrDQSxHmuqfcci5SUoMTYsQPRbJXjnUHJDmvH4QRh/Ff1UyGQAxpqAjDOzjzB00fdyeKns6qhG2Qwu1CBgUY3KAmCYNy/BCVtx7+gVpKnAZL+eI7xUg7gTv+2BGl+R5/mRK/dFcep6SPFaXFvBPXoA9ZBl9AJ8nSWs1Dk2XhxPDrcMdOogSgX3QHIlVQUnOR9WMAYnqKOLqskgiTLLbm9qHrhrrNXM9elWMIeTRwwV+juzne8/tVS6asl3t6o55knfetIcXqnMOv9JgOg4Otg+dqNr3OAmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Yahia,


Please answer my question [1] to the v1 of this patch, before sending new
version of patches.  I will not review your patch before the discussion on your
v1 is finished.

[1] https://lore.kernel.org/20260620002614.83004-1-sj@kernel.org


Thanks,
SJ

[...]

