Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BBBED29DE2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896606B0095; Tue, 13 Jan 2026 03:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A886B0096; Tue, 13 Jan 2026 03:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718C36B0098; Tue, 13 Jan 2026 03:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4976B0095
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:18:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B97789DE0
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:18:03 +0000 (UTC)
X-FDA: 84326237646.19.63C70BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8431380004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:18:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CRAjj62O;
	spf=pass (imf02.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768292281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZKQhUVRzOmUIAQuGytTCJTx5cBtYB3L+1R1dsyuO5s=;
	b=bdb0JDaxxDLJIUvABwBMmC48JoUQM9wQGtqv19mMRQGL3kNZhKNRnFkDqWaurt3QEO+UO1
	wQOlBc+bZnGB3fYIT1E6gO8vQdYjwLctcW3ccv5p/UWbje8bY4Z3jBolj+UlZFybcTH/iY
	a6C60FTdlUAiAj+EtsPxqtian9Je7ew=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CRAjj62O;
	spf=pass (imf02.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768292281; a=rsa-sha256;
	cv=none;
	b=gF0o3MU+JbaZIyFMJ/u/FFb+RCltjG/tVSEumxCiepM/Rt/B847ieJuiT6c3C0iOryehB8
	NPG7wbDvgMYgjrR7OMensRQYTenjD2jeDGtncJU56y8z7uuJLE6gXrAWg12GU7N7Ng1uoM
	k1aXrad/VYZbbKcMvIWoAtUIXM20YVY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 549F040068;
	Tue, 13 Jan 2026 08:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCE9C116C6;
	Tue, 13 Jan 2026 08:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768292280;
	bh=hZKQhUVRzOmUIAQuGytTCJTx5cBtYB3L+1R1dsyuO5s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CRAjj62ODPQdXh+6FN2GsD6AcG2lYecH36VJewBax+dzwagHdEDZES9nLxkr7JMBO
	 teMD78Y1IJd71FTC4MbNW6WamLUhA9YnDaT6FVj/CuvHccGXU5P+zzpDzcj/VDLL+3
	 umdw3J29G00NdDrRvsjdNx+Iv0y7j+a4r74NUSkxr6iOpO0HsKTcEwLYifFxLXRW56
	 6PjuUT4oVG+obAtgppwQvQPzY9+pzd+JqhPceUzJKOMCCYAhvTpTPT99CkKZcs9iit
	 QQLCKHKRP9z0kE8uwDYDRZfrjX57uuK5b6ai9M5ftYvLouTqr4WRHkGbSOxVL48PKq
	 VgED3Eg/XYPGA==
From: Thomas Gleixner <tglx@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, stable@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v1 0/3] mm: mm_cid static initialization fixes
In-Reply-To: <20251224173358.647691-1-mathieu.desnoyers@efficios.com>
References: <20251224173358.647691-1-mathieu.desnoyers@efficios.com>
Date: Tue, 13 Jan 2026 09:17:56 +0100
Message-ID: <87a4yiexjf.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8431380004
X-Stat-Signature: ahnqfb9mnjnz1d7i5ok361bpttpq97jy
X-HE-Tag: 1768292281-63294
X-HE-Meta: U2FsdGVkX19UPQ6hdRGu5pAnX16bkvyQxBKh5XO8vIswr5VbS2kM5Dh6tRP0j0btW8YcaWQ3UpDgHnOOuutz6D1l+zHohK3vRYK69aqFYAHFAbPp4xcap0mF8YpP1ln4m9m0wwy8mFzFa9UzdgUfOoi5XqGmZFaGec4QEh0JqvK1dX+XvVDKz4FPuvYGK6o6JvzF+VsFkmNAxrTx1UIvREWJ8GRmqvlTn70H1LWVe6799vIRiboPKDx9CQ7vZui9hbdc5X2gUVfmUYdiu7CVEInGOErUn31Y1zlz1QnSn+f1sHOKVJU01R2pbjDQg4BEMEv4szA/CMdzu+S4p0pJiXoDLD8Uc8SACdEF3MCv7eRAANXmxHHkC6wAFkq8UQKLuBL0D56Xz6KJI0ZdOi1SNkfHFR+zjUdP+mO6uaGVpgBELxreG/UOYzmL6MjbS0fCMoYof9Vdw6ptVkY0Hekrbd/mPyE0cMHKQGf/pZpYmAEyzk47JqW5+TQuqDTVJVHicmH0krX7QCsfNy79/+E8qUFmrwYkIm+Sgo0J/IHfjQT15CsKv3FicWNpUgF88Qyk39lT8EXG0G5QZJPlW+9jmcCZgNP8G7TXHnXr38J/0C7G86tcFyg2VK+pCz70aEUrWmfYcWIRzygCX9kZdWjQgfv1R399zF7aJFcIDnxWGTm+LkY9onbwV9N0/eXorDQ2dAHDzYI911MAFuQ1YfCn+Y8hYgB0gQQWZCbbTQ/y/71Ih8jenReQDRrqJQwv89PHugVbczv17EKJMVmY7wY5PapTxeyIlBgQsQgGWLGzw9TZnZn8QG+qFp0jGtcplyVL1R4gt7kSztxrsD/Vyny1vTG7M3rPVe5E+p4qUSAMEGw5upJpEU98POSYVQyUirzy2a5mvoMFpddlp87SwdwTcy9AeDF2o/Nj60s+uFX6r90LKpmqsj1iZe9KgK2CLWFH35JS3PEThTEewKZzqQG
 kVR/PoCH
 NbEmTAEi5NivSCvCaPGt1Hnfxsyg+RoMSoPQ/0XPFQrv9TqtRmS1jsaYdkUy9ByZ1H0D5xNk6lIbtC86uLUp/iRp3EZZh5QNvcIGiqdHLO0EFIyvsIVfu/cTUHCcV4B22BKa4qXQ4y5TRxG1tTWWfsNl8u0BQYudRSwsGz3+J6zYxkmvYQYu/XIBYQ/xbmRKm4ovJYoezgr32yY4Kw7drrbNqLRuNMyGeCuRlrzjPnXEuQSWgj6pCO5FiKkqpxD4+mkHi0tb0BlFNA2a1WQDL0xIsVwS2UAtA1Kl5Ku63aenkoUHUN9sRwV/3AdX76RGgc2ux68GcoFNkM+xDIctTXGrw5ILjqzojkYgfdmA1D3/6qlxNs00h9W4zKIDkIFij+TGlmOR6qjRD43dUD0DEdrP58OVJK5215uVfT+QUHlSKKysN5GCl8flbnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24 2025 at 12:33, Mathieu Desnoyers wrote:
> Here are 2 fixes for missing mm_cid fields for init_mm and efi_mm static
> initialization. The renaming of cpu_bitmap to flexible_array (patch 2)
> is needed for patch 3.
>
> Those are relevant for mainline, with CC stable. They are based on
> v6.19-rc2.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> Cc: linux-mm@kvack.org

Reviewed-by: Thomas Gleixner <tglx@kernel.org>

