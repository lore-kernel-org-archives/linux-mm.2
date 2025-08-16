Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79ACBCA0EE9
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 16:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073498E0024; Sat, 16 Aug 2025 12:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022BE8E000A; Sat, 16 Aug 2025 12:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BAD8E0024; Sat, 16 Aug 2025 12:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3E558E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:10:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A8CD160407
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:10:22 +0000 (UTC)
X-FDA: 83783107884.05.E5B21BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D815014000C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:10:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gX9I0BMF;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755360620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tfpCAGsVtRyAJUXlmI4xOb33OBzTi9PEAhbYlZz+cc=;
	b=rDRmL+fj28NlQni9kJ8RgNAvSFnUPAa+YRv47Ga/b3y2Nzv67MbZzG5oIiux3NS6RKl2zb
	DCnxVFQbV5V+N9zA6rnZ3jDIATJM2b7u9nUbf9CUm2qLm6G0iw+qtU8rwSnm8u2LBMtMmE
	2m21ehDuBc1OYWO04E0O14YQwkZy9rs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755360620; a=rsa-sha256;
	cv=none;
	b=1MiYaN7hMOptaszbM2aSBMFbFrOK5hhF01EO1+UFu9Xp7+zy534vt8WxhkTh8KItZioDZG
	UFgWab7oIS9ADl3f1iIVhhbu81ASE8YzEoD0J5TQapIaB5XhiNp2wB1P6Q18LfMe2wHc9g
	oO28GtY79dOdCn0SPn1WhV2nqklbR8A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gX9I0BMF;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40E4B613F3;
	Sat, 16 Aug 2025 16:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60A1C4CEEF;
	Sat, 16 Aug 2025 16:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755360620;
	bh=dvV7dkSDKHOe3uTIJaHJRjvzm9dgErExd276G6LKKEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gX9I0BMFfx847u0g9Qcvr0PdLMcjCdGZGNF3ef3Oh225nzkdRmmSTVoBVpORDEx4s
	 Vbt0HW2IdbwcRQ3XJl9I/9OfAP9bsATqnAEHKKTr9iNU3Ga2BB4AanixDYSXvYo6ax
	 qBuedFW/UVm4yMqIUVZy17SCg09iM+yLo/7bfb8efllSCbTPC6nMqE6ItjEY7sbECJ
	 50lIuAVwbMy9wddoBLOid0prubrnqb+gXz3hNPC8n5PyEhFerVndjbK++WyAfcL6U2
	 S72uG1VUmVJ1Y9ac6ISI47bbM0o4GghpRaqRK7oiN9P9v+i3xw3EqiW9pqqlataqs7
	 5io568DjxjABA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm/damon/core: fix damos_commit_filter not changing allow
Date: Sat, 16 Aug 2025 09:10:17 -0700
Message-Id: <20250816161017.63692-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250816015116.194589-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D815014000C
X-Stat-Signature: d3wth9pzd3gt1ahh1stebfjsgkagmtoa
X-HE-Tag: 1755360620-500358
X-HE-Meta: U2FsdGVkX1+YJTdy9iVd/wd4XJf1q1+fbPgCdPUTDZQQhMqCxdwav2bRy0azOEoWaWUiDYDcgUBOKVKwRGYVnYRDG3BqFEpBCj9luQMNtzUBeDMZum7jGu2wmgU4gR0za2KkBqJ/Qm6B9iCUAJXqa5GoLL4YqWFWpxtHhJF53rOSCpfcpTOzFHAOr3LSW4o+3Hvq+jBNqkUpOCV4uCSMhCfiiYSCOF6pnnq2s9IHxwPqgbTFx4hFlgq58+w8CUW63USqTIVir+Bb2ZEhjOyqU3g1quS+uz/j2muy9TNrP+GxotSyxCyucEZqBC1jn1gWshnz3BwStdFDtDcvniYg/U9MWLouelksU92KeN9bq7nsvcZuRRKm4WjfWNXDofO+y4OTxKGEMS8fBEcR/jmOUPsArvSXt5MYgTNYvMB+xXBsewUAqhg1sI7SkbDaTgHlxD3bx7aAknXJitHxLyCOHsoFqssb/RbuYhDH99U1e4L2SubqY0ZoPiYYzYATw3/9Y/uzrcl4TuY/xtWoP8gqHhaB9HO8ZRi7vY//fuSdsQSTCYXwMsOAqIPthPlAiBrOHvbl898pFp6W5jsDbJLMnvy/WefGrPa/PWfy9GLLLNmJpztC42r4VcPm8Z8Y2dlW5tJ0fgxrQcuKVYbQvU8WOLyKI1Hnz2LRAU7MJQSOk0Sv9DDZVDTv+NPc+tdp5TflxiTtIf31oRuAQrGu6+p4no8xf23tSRMbN5FXuMj+t6GDhkaaZ0wtmp+KNZSee2ZFjv4ONMZIpvLdEIQQcLyaZ5Xv7kDwmPf41C10zwm8sEG77D2cZv/A5+BXxQZdtjG/+PeNSIbb+DZXXbNb6cU9fsAgxCS7i0h8wk4jkCbKL0YkCaiF/IeUq5LiF/Fb0rIOnmkBZ636XGPfAjFoshUZm40WMMpYDuUWtHLPsX0hmqko6baEEDWgsh1Mnf8v9O/WUU5UIXl9L4hzx012t7R
 WDtS4mBp
 wKzhw1kyObQTmMyUNRBUteO5QLHr1pShyv66fjvYeoaNgDEPKYie/+KAeHBF22lAOpejSLvQf67iL+p/1rp1DmMDzeiCf9m/ZyRTktXrQwBt887Dva2/hIyBRhc+adg9SMHI+ty6IPGGIkUa9p790x407hUOgN9XXTZJDkycqfFN0X9axx3Mp3a4PAbO1QONihINtV0Mc8VKBYhz35/5KFPVYi79Mp4WGzoLq6GlP6oYMwLY3qxCtSqAMlm0pOBd3w+6EreEaRzgqwTuZO4fjOPN0rRmWkHzsrI2RMVAV61hmPQ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Sat, 16 Aug 2025 10:51:16 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Current damos_commit_filter() not persist allow value of filter. As a
> result, changing allow value of filter and commit doesn't change
> allow value.
> 
> Add the missing allow value update, so commit filter now persist changing
> allow value well.
> 
> Fixes: fe6d7fdd6249 ("mm/damon/core: add damos_filter->allow field")
> Cc: stable@vger.kernel.org # 6.14.x
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

