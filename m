Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C4CD44C61
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4956B009E; Thu, 15 Jan 2026 10:20:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC176B009F; Thu, 15 Jan 2026 10:20:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623446B00A1; Thu, 15 Jan 2026 10:20:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 526466B009E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:20:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11A338B64F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:55 +0000 (UTC)
X-FDA: 84334560870.13.098F78F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B29AF180011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BX17cijj;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768490453; a=rsa-sha256;
	cv=none;
	b=xUqPh1PfXfxWaHjoWRpryxtMIk/nKVCc58NsiecNmC3ISBPeo7Jr56WyfDIV7miYU9ZCXk
	zMTugFhxdEWRQ0JDy6/759S/ZMjcNgJAgssasidcC2zsfyK/hGDaUER2tBvjUb7rPRCxR9
	Kra7kRomxjYbbAeWJzoNyRXi7A5Gevk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BX17cijj;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768490453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bJHxyVAupFVrrsx2SNLpP4XeWqAu9IvvkDid3tWY3tU=;
	b=fyPpUNzfsA0sOgQfqJrPVBY3H/sHEVtRZf5J1SMfeVydfF68K+ZDHkmFQCTJS4EcOOXta6
	FeXUyLfXl4MN4B1GWQjXtPQAo6ARNCEtjOx2p7v1HjLJ5YDUghJk12Wl9ponBlM28fU6ws
	lB518k3fbYW+hYh6Rs0WmINiVb1UXmU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B10D6001A;
	Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8B9C116D0;
	Thu, 15 Jan 2026 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768490452;
	bh=7ggD0S4FVhSUFeQt1c6mab7wiJsXipetONzU/ymQkDg=;
	h=From:To:Cc:Subject:Date:From;
	b=BX17cijjapR9Priw09Qu6P+VJV5P6SfGe5/A97an7EA9ghdfS0SIRZf0F8Wk3z7Az
	 eOhhnEp4eBhxHbiJKXvBNSjgp3fay/pnkC5UcQNawIZs6W9WLN3PZbXGb3KPTwe496
	 NPSt8mAnceh0hQHiWZC2OvoWPaUzC3rWVDmu1lqD/PwGmlQbJpPg01SxIz5uv307kQ
	 voN/AVMX7apzdo9IFF9UZvRSUfEAqmlP5KR/jK9IQ/CeOS0LQ0o4GxRkuAjowTVlhD
	 5Q+9u3IgAvfrywM4mEsJ51gPQcmcTgy5cvpebZ4wPoCzAAQ3qUJGBQrp8dmMtA8+GW
	 rBIt2aI2mYIUA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/5] mm/damon: hide kdamond and kdamond_lock from API callers
Date: Thu, 15 Jan 2026 07:20:40 -0800
Message-ID: <20260115152047.68415-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: edbnjugjfo6fxmgafo6b4pc3mjwty9h8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B29AF180011
X-Rspam-User: 
X-HE-Tag: 1768490453-824730
X-HE-Meta: U2FsdGVkX18rUq/NXy+xHRbEMTucu7czqOGxfANO/3msrIOK3iBQof/bj+pogJVMJSfvDftGNYQ9jJhG9S6v/dtMjeG5G8coG/+ZIXr29jzVYxedqWIjf0upAh8zSRu9A8SSqmhc64ViTVY/fy9EcgDd6RWPTo7pg5GSiYA7S4ij0GlkYi+aXZx05jN3N46W73dnG3JOMOr0iuNnJnAPsc3pVrCWqTq4TE7mh9f4+MR0upx2U0QkPzD0p7sKyGtGwgyDZdOLTMmXF7eau3AGktTmNJgNRKj5OS9+l6+Z0OF1FGd4g0inwvcwa6BiHo+QzVeFGW+ybocfDLju2ew/vxRX3bBuzLD/GwYKc0I2UROrwVzynFQx/v5M3hkffjuIvM0VZA3ZtFTBfRZjwKZfg1pQ6d/+2VWWyhlgKDIpFZBycmsRbI7NHUL1q22iu40URSPQuRsmxLzipu0a8mx1RcXMr+O2DwlF0dwC4mAQwFExbcK45lYyvwt+0EdXaTGxVI68rnKeKrwT90nwS+wc8nUl0X6jnEjk2oWTLlHHdsTnIYtX0gju92ntfTDoZ5ZIztxiiozsEn2VglSGBGNvrrA7JLuEZVHT9A/HN0Uodwk0ypCrYFBQfWQugYt4gFFnMtTNgRVKFCJ9DW0EST6prcBcCB1txDQyyMjXGiOIIZF1JEeRl5/YCp9MyU6t4A5FNzyJ3oLd0ReFOBQoENARUHAtBz1LTx2W/vO5VdCdhWnH8Abvsl1eu/NJDYXbmEOjqR5eGmA4IYsKRxkyeHtbVlroCvvffYo79fIipmA2oUhvQ/ihc8hn4TWBeOrRlwIsGvjaPuSsae+YY6UKQSkdUAjzmjVdUlER12x9GGWV+S9U/AFBHybx2jdyd11J/1+l4Sh6iJjzNJNgheCeJaaAflkJPuhgISwkyPLRYFTcTdd31YpDwzyZH3i2YseVTmrZPCbwbdCCkuflH3lnJU9
 anvGCoJT
 7A8gN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'kdamond' and 'kdamond_lock' fields initially exposed to DAMON API
callers for flexible synchronization and use cases.  As DAMON API became
somewhat complicated compared to the early days, Keeping those exposed
could only encourage the API callers to invent more creative but
complicated and difficult-to-debug use cases.

Fortunately DAMON API callers didn't invent that many creative use
cases.  There exist only two use cases of 'kdamond' and 'kdamond_lock'.
Finding whether the kdamond is actively running, and getting the pid of
the kdamond.  For the first use case, a dedicated API function, namely
'damon_is_running()' is provided, and all DAMON API callers are using
the function for the use case.  Hence only the second use case is where
the fields are directly being used by DAMON API callers.

To prevent future invention of complicated and erroneous use cases of
the fields, hide the fields from the API callers.  For that, provide new
dedicated DAMON API functions for the remaining use case, namely
damon_kdamond_pid(), migrate DAMON API callers to use the new function,
and mark the fields as private fields.

SeongJae Park (5):
  mm/damon/core: implement damon_kdamond_pid()
  mm/damon/sysfs: use damon_kdamond_pid()
  mm/damon/lru_sort: use damon_kdamond_pid()
  mm/damon/reclaim: use damon_kdamond_pid()
  mm/damon: hide kdamond and kdamond_lock of damon_ctx

 include/linux/damon.h | 30 +++++++++++++++---------------
 mm/damon/core.c       | 17 +++++++++++++++++
 mm/damon/lru_sort.c   |  4 +++-
 mm/damon/reclaim.c    |  4 +++-
 mm/damon/sysfs.c      |  7 +++----
 5 files changed, 41 insertions(+), 21 deletions(-)


base-commit: 1aebb6fcfd6a8da57a4eda7863d69e533c392ae0
-- 
2.47.3

