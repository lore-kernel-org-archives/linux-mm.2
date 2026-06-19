Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB0ACD98F9
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92096B008C; Thu, 18 Jun 2026 20:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43556B0092; Thu, 18 Jun 2026 20:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33B76B0093; Thu, 18 Jun 2026 20:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE93D6B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EED2E1C4800
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:10 +0000 (UTC)
X-FDA: 84894782700.16.961D71F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5E13CC0007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hwDu/gQF";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utvfSl21aCDRZRwyVcgp4w+0VdsKPaEHtWbnJKfr1i8=;
	b=6Zq5DJ1RGndqVTUiT8Og7hBeRBauxvx9MOr6eEEtzg4K8L+shPMWAlzq+ZQ61DBud1zjCv
	nAARDusgth/rDgJiYzlqgX2Ag1XqmNjoML/ezhH7z0n/4DdZhqWwLj3KbxwMImdMw0+lK9
	USkdDBZktkHAXU1FkRwtL9xdhTdY2ks=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hwDu/gQF";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829069;
	b=oCHF7DEzZvKwBoolfsr0q3B7q0jETCInVeo22q2kHuuy46ea76TCeds3+2+mojObw0728N
	+UIii6p3HvytMCrZDKeBlW12Honybuewyu/VuqMrYeMTZAS8lVajJR7ZyBHBH4xgDRev/0
	QfyID5ce/w96F83ElRaj34UgBqutflM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78D8A43BA6;
	Fri, 19 Jun 2026 00:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0971F000E9;
	Fri, 19 Jun 2026 00:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781829068;
	bh=utvfSl21aCDRZRwyVcgp4w+0VdsKPaEHtWbnJKfr1i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwDu/gQFRInZmm6OJPBU8nh54p18ZN3ioLtEZGDM4y2ytDQn3DWa8gVZTMlip/oAy
	 NwcgaI9Pa1QgH+6cZzqjeqtXqAaeR6pBC3q3zBNjw4tM/Akd4eWdQn/jpTqP2qvz1l
	 bunT1YVMuUvOtloFUgbgjaCkaTXiV1tINTKMDdrxeawgURjHfirnxJDj8ZrI8cF09r
	 ppeTJb1TbGVMtjg7LAvogO/rqZLPF9LuPq0mqblkz+5qPgNh2LyI4dfGoFp8Vgu+DR
	 yhHtkmqa39TGkeR08YVQMyf5+B3Yt056jKnMkd1KsaJk3CimY3J7znMFmBXU9Nj7CQ
	 ECJnKySwaU7hg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1.2 00/11] mm/damon/sysfs: kobject_del() directories that users can create/remove
Date: Thu, 18 Jun 2026 17:30:57 -0700
Message-ID: <20260619003058.8801-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E13CC0007
X-Stat-Signature: fzow7jqnigxsya65g9usnccoogyy7p8e
X-HE-Tag: 1781829069-712549
X-HE-Meta: U2FsdGVkX1+qG4z/Cstv3tBQjYu8rCZ6fWGpCnmBVPq0aiUuZEXlsXMGQeegP8H+HAN8nsuHjzolPYC+KzlbMt0idkBe6mVqp4aygLv89QOKAJ6/M2zUUsTHSPLubygZxSTgazYZUBnphWpEO52kEjBvFsRGx3CkI9tflTGaAJs+jKJdeQ5fXAgFJgnN0LMnmaqUFQKRmpiPqVrNZCWgjDER6v1/yVQTDtyWMF6fudzKZrO4ceKb3pkhyWWoqPfg17DmOR4FpLE1CQZq7rpSxzV7YDF9LNjWaqeRJm8KPnY69vGWZWBye9xkfl7ZIMwaFya4C32VQlWQFpMyUZ6kEn/Rg4WvavujuBKf/R5/xxkUePkfhblW5Z3fZW0aMXbvNCNn/pUcRtPXYN933ayLp7M4s4ROPNiM6EjwUQdr9GD3GVq2kd3Q5pVxa6/76SArXYF4zrUygCnMJ9s2yZ9g0kt+scrCJsNHtOL3H4qUjt9KeWTHr1w0s/aZ+sMdxdE+wjbZXN24TJYeEbGetWd/Buf4k1/QSyXfMUswysLFfuga/9JxykfIamYAEdMK4d/mHmMKT0eUBblLuPa5jCvejoLSwgrEfhtwEkugQFo4HsVYaUrX4nB82+Wub9pq8W+c99eaQoXwPkFKbXA1wjWJ0Mz3y2yCvLJ9TNB1JUdmeBOVlWBpfLbHbQPreQXzjzBnvF/WJcNnL7VivKbh/dy2MaIp/+yAIlmMnFXtiqN3ScO81FbuP7GRiziyU1o3fFm/u5KSIsr+l2KO7uZx1HUHWSgmISbPyRyeDFZbr6ngYjcxTKA/umSqnGff702hIijCxB0ZqocajpCkJnjY3gQ56beWWwtXJnAqLsOCId5ZoU+uIjCKujXlQRIM39FMuYnBwnbQX6GJuvwJJkxscqJqG5SywxCG/1JzBUt9ew1GQwT2+ty+zcwiohW1pj68K4m6kNwpfdKzguNMcPMJNqY
 2EtgMnxd
 Utr5q+y4dAYywH/tPkNE/ab/GKPQPyvxrzOTTCMCjATECv5bEOO0ttiC0fokjGRz2JgBW6n+nivQMRzl/QhvrkxP7pG0Fz2CsROR0DyQzyrTO2VUfaZrKtr9lDKGSN5DDrxwmiDLsIfEThyRAxCw9/r1et9TPY6/1Z78MOEdmcXD1tKM44483ZVDOaRUEdRAjvaG9TIGBHXPS207CW2HEXL9plc5rVqPxNcbODYATgZJmXuo+HaNzKAVcjBaSorwn+9pZqdGa80lKaMyyHEZj0JIuCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 08:15:04 -0700 SeongJae Park <sj@kernel.org> wrote:
[...]
> 
> This doesn't cause catastrophic issues like kernel panics or memory
> corruptions.  Users can work around by removing all directories first
> (write 0 to the nr_* files) and then create new directories after
> confirming the old directories are gone.  But, this is definitely a bug
> that causes a bad user experience.
> 
> Fix the issues by calling kobject_del() before creating new directories.

Sashiko found no real issue from this patch, or pre-existing ones that better
to be fixed together with this series.  I will drop RFC tag in the next
revision.

I consider this series as hotfixes, and therefore Cc-ed stable@.  But, because
the impact is minor, I will post the next revision after I believe all MM pull
requests for this merge windoow are completed.


Thanks,
SJ

