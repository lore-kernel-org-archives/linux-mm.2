Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22492D3E77D
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 21:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580E16B0006; Wed, 10 Dec 2025 16:49:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531726B0007; Wed, 10 Dec 2025 16:49:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4473D6B0008; Wed, 10 Dec 2025 16:49:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30AB36B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:49:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA13FBAD44
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:49:46 +0000 (UTC)
X-FDA: 84204903972.11.2C570AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 10DAE2000C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:49:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBTs+i3V;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765403385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efM2Lm9ZRC7AH0R9vKVu/wtG53Qm255tfwB5+WzZk8M=;
	b=3c++92nZptpfDhFqmsjmIXNe49jVEc5HIWCYZ809ipCa4Av7AHVMMX6blalk4hMPgB+u1/
	BcYMOMH/YTIH5qUaZ2SHCx5Dby4Rx81f8KQgyrUqqPvyjQb8I+I4pJYLcVVE+2JOo9TiaS
	y2kofKSCtgo2r9E+c8rrX+4bSz0AGZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765403385; a=rsa-sha256;
	cv=none;
	b=vq7o70EBbr3LZ5KE5P1NkToAClMmTmpOYJTISf0d3DZ07XeFNeoyYgHNqfOtcr5vjm+OxW
	cFMKKt+9V/5XBep+N1YFVFNLcKCO3utl1LTv7TWAS3UAD7DoPDxqm0BjDWQB6DHmVeSJe2
	3aFMxJlq5OuQWXuiKs+/9BUm82/+DdY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBTs+i3V;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA1DA600C4;
	Wed, 10 Dec 2025 21:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4398DC4CEF1;
	Wed, 10 Dec 2025 21:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765403383;
	bh=r6ZOZ8yM+7+ioWVUbdUX9Oobm1iYnDniUDEQ2yzX1n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBTs+i3VE5xWFYKivrcjKmNITsqDTSTnpYlpIVFR646Lx8IpwCp8fYsFyT2bxeSAk
	 DubexRQGOJriGM6qnHt/zFLHR0Seau+D7ViformhIMg+whTwQQcM9MrKBaGzEe6S6k
	 CD5X9rqDIwdn19ST5ibUYHkEbREVq3gnWd5cGVmySwSX1zMzheOOiN8p2XgrS7PyjY
	 +X/N8v/UAK36rXJqMxsP94//ug4VwMtXv3MFgCZ9Aj5yrLBnZDtX/69EZ1WL3MAQIh
	 sKIrgfDjuHphSuZxeN9RlmQG1I+WjVtBUVLG86g9/Jdb4uTMHWzM5FYrKz36QMn9ox
	 TuU4LPSS5Z16Q==
From: SeongJae Park <sj@kernel.org>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	david.hunter.linux@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v2] mm/damon/sysfs-schemes: Remove outdated TODO in target_nid_store()
Date: Wed, 10 Dec 2025 13:49:39 -0800
Message-ID: <20251210214939.62774-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251211030707.16417-2-swarajgaikwad1925@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 10DAE2000C
X-Stat-Signature: mozx5hnqocirzo163c378jaazwmj93sz
X-Rspam-User: 
X-HE-Tag: 1765403384-308203
X-HE-Meta: U2FsdGVkX19pIJMcW1MlCtKD5Aha+/a6ND/7UqDOv5elgZOuhQUp0fKnrCbapubzZjITk9xF2XeL8+PvvBJnayjAPSKGsx/sE+iwqJckd1Lk6cctQr6h2L5pInNUYsMZuksHhT1bm4Nvfxw4QOFJJUJ5Tii+rQEyln66a+4uuqNhamcv2nkl4RaGnuClThlHxwkXF0IiUDG9vOT7SP56fI9G7sRdqrGkRTRt2Gnxzn6O0FilLzL6e6GDJlRyTalNx9geMwH2305YjlP3ARhiz/3wf55j79/D62JGAlRUQXBYiUGvDgs+Ke9tl2AFUKplGJ/fO2P/urXqYFa1dFdQvKHoa/owOGi+ALMjM7J+Nuz0sg8ImETqnDF8pga2KddDUjjaXe8C0oF87iWy4ZAstkam+anWzFN4ZeTEhNqhorgVJY9C9L+s9inu9Z9sqQ0ENkgWOvmZMNOhFCc+5vDPmgWM9PI589iEyykM8Djt7jiMDzuJDYB/J54oHmWWQXcucAq5VMLAgbNdLnGtz7K2xPs+06anxRn2VZN4BVFQfRcHrh3dV+QThx/uWKoXUT/bgHOx4HvVegcjJqiIdHlFjL9OxAgdkt6ZlaFyJEYeHpISf9IhJgUjnDI168r8AFA5w1+ZzaRi3cjRFidrwKBHCqv5NAjq6+08DbCz+2fVM0uAJdHM39s7GZckDrHERxgtu2j1O2BYP28YJXwAAbmTTTrZrob0hz6gMEaFSMAcpG5snP8tcntVYI+qfCld63YKMdH6JkPsPdYv2d0RIvlUSkSM8/X5sIIzd8EW/NCEW2BOOT+bVFVV1oV/T4BR2CGMpqOzrogJVTe/f/71iM6dXPwfzxEpYI8+vWCiXNUiGSg5btDhb+GCenL9ZqciLjBlQJPJpM36Qtnmno5hsmf4pxxLF8Pm68XH2/Db3xvDNZBMmMT5Vz706EAZVIYRjbo++C5oxy2yRhLHkAjETc3
 VCM/Jl1x
 i2n3FlLlyZxeZVla/i61UR5ERpNoYx1p6gBBJ4NAznTpUGhTJLexvIcab5xc0e5CEHNjQlsClYr97ANZZGDktfQSXmySZVScIdo3uj46/nQ/GrGRmqqFjedW4Y2Zf5MnOyjcpYyFd6Yud2oxCvfajk3wfjym0tBrP3qSZsI3ASX6tVbrIN+whs9bj/1O7/s11mGWyZ1BSHJffUGn6djtrkQmdJo99nwk6AnabPUM+HBrsjpETqZ/Nv14bclKEg/7sQQoEa481LIa9zUAhJ+sGdY67K1wjKi73vr0+ko2SjsBmPXw5G1yfnLwjpz/d/66n5pq/Z6TVfcKt0mCMWCHHDUgMHbu43lpTfJ81S8HrInfMrYv5i6A9a/Tq4GlZcqC93pnWQlrl3PKIvns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 03:07:08 +0000 Swaraj Gaikwad <swarajgaikwad1925@gmail.com> wrote:

> The TODO comment in target_nid_store() suggested adding range validation
> for target_nid. As discussed in [1], the current behavior of accepting
> any integer value is intentional. DAMON sysfs aims to remain flexible,
> including supporting users who prepare node IDs before future NUMA hotplug
> events.
> 
> Because this behavior matches the broader design philosophy of the DAMON
> sysfs interface, the TODO comment is now misleading. This patch removes the
> comment.

Thank you so much for this patch, Swaraj!

You sent this as a reply to v1.  In mm/ and damon/ subsystems, we prefer new
versions of patches to be sent as a new email, rather than a reply to the
previous version.  Please consider doing so next time.

> 
> No functional changes.
> 
> [1] https://lore.kernel.org/lkml/20251210150930.57679-1-sj@kernel.org/

This kind of link is useful for tracking the history.  Thank you for adding
this.

> 
> v2:
>  - Removed the logic changes (validation) introduced in v1.
>  - Updated commit message to reflect that only the comment is being removed.

This kind of change history should be placed under the '---' line [1] below.
Please consider doing so next time.

> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

Other than the trivial comments above, change looks good to me.

Reviewed-by: SeongJae Park <sj@kernel.org>

If you willing to, please address the comments and send v3.  Because the
comments are for only very trivial things, if you don't or can't do that in
days, I will address those and send it as v3 on my own.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]


