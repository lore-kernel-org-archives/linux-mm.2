Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7246EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058FB6B0005; Wed,  8 Jul 2026 10:31:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24E56B008C; Wed,  8 Jul 2026 10:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E162F6B0092; Wed,  8 Jul 2026 10:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B963B6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:31:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45F2AC05BD
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:31:40 +0000 (UTC)
X-FDA: 84965847960.05.3D429A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 89B16140008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:31:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cCpJO0aj;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783521098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnVyRAW1GybKVfIibIhr7aymmWn8IPGRIA1RKT+MYxA=;
	b=QygcIwoZOSQtuChmxYXoYmz9RcNozjXV7SN5CV0s5HR9sOhAbmFWwzq/seRQ94FS4PKmLN
	wWCKr3vG0FuWvwIP6ZhNNqrasm8By+Ot9ZduCGntxZzb3FTONGil9tQYdDN0rR6W508Z95
	4YgJ5/S9yS9T9VVWX0GLbuL/V/oVIm8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cCpJO0aj;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783521098;
	b=MJfGPKUELJdR8FjlkLjq1Qqi5rgJmVOOSSdplNmjAvVan42xOsyL/mYsXta1P9ZwaAbv5I
	H1wZrq+MoZU66Lh5MgBWs6EmdwWLs0a36PEgRPKXvhuArzS91YykY0zMebcZAoULKr9Lgb
	Rk5lSNMVMINk3JIL7WQJ6JM/oB3xlcI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0249D60008;
	Wed,  8 Jul 2026 14:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852E41F000E9;
	Wed,  8 Jul 2026 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783521097;
	bh=xnVyRAW1GybKVfIibIhr7aymmWn8IPGRIA1RKT+MYxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCpJO0aj5uJU/hUo5m+g7jSkGEXNzf5taItrCRpfzkUXT5cVT1l3aHMg/Er4rRRkK
	 VRcenDWbOqCaAXmTLwKLbApBvzIkiwYefLMVvn+CU9BBxs8TWUvBG9kibjxBm/dI/s
	 ip7keYMwP1vQfG0WQsvtLhuejUnfhAuD/5t7hBlydsEzkz+4roSo5ORag0sJ7inPSG
	 3Kkra9GFTZhTIhh+YrmrwF0zI0vHIPpI5Wdd8Kjq7NMch0Br+mS9Wpiy62B73Wofss
	 +S5KRYvzQVySR42chkR28/nIL91/GgYTFtiK2aGD2HKM3vHaesxuDVHHnnuFF4uHNV
	 uxG/jHMMYA4KQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero
Date: Wed,  8 Jul 2026 07:31:29 -0700
Message-ID: <20260708143130.124419-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708135359.122587-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 89B16140008
X-Stat-Signature: 8f4xxwsysde7r3mu8kow7iixa5mg8ffp
X-HE-Tag: 1783521098-103255
X-HE-Meta: U2FsdGVkX181ybPpPHrvq5YjQOgWbXY0rN+D6eRGEfRzyXxYK7V+n17IYMcjBr8TAvhZYYIYAXYFYOiLPFzT7WOUt1iBQLLkcXwYSOQMI+UtyvYlpI5YUQfz11DBx+FIKOOEEnBoHGloTcEvgsaSRxsz97dV3WArCJFWf168HG/QWheCELYjfTjKztOG+MuCQ1/7IFPtWdSycwoH0T3XWSF9s2Kb4gHhFOyi8jFhttAOMMrqn8nQRONFoxuiJhOa3AGVHrCyhgVSCROiXssJOmHUELLee4s88zNy+3prDvzWCHGv1PUT+/KCBVbwPodubkMEaOPwomzPWvBWGf+Qf7NYO1OtcSOEPz2Ol4HxfHPamXGZki/HzGkGfG67qzopc04psjQMxC7/2NigBO9AQRrZmWfCUBSKxVvXh9xcRV81LOhoC3UPTXiIlTtaDg7Cj+znCzhsj/8bKpaMffqFTGfd0lf9xLPhrMzzTT/gcUn+IsqrKjFsI2VTQu24ioZDcWylWR4EfPUn4LS78PEaxI2pbx8qJnPzFxNv29k4I5xhIyWeNxMtnyURWPVa0AZWYHB4Z1HpBrhxgVhroKMCiVO1aifbEi4jGceJezUSE6K2ZdZUqBqotVpaWIY+LC44DbTrnWrCYDRC5twB8gplibOHJQILQqb5TkMYzwaeI45tTp4qdlAs4Jo1YmytYDoevKB+mzwsWZ8O+OriYsZnFEZFn2QkbpJP5GtLZotpMa+8EDafPCAUoE5YEpBpzRJr8tWF2iurkhSKrJj69TJqVdJ/cfFeXWsedn+W+ZuQ08Cfe1XqAM2yaxkO4TpdbYYooMhSE4j3LT0+6bhh+DvSVPZnXjipfgME6QUDVuj8ItpETVrApuuPBoXGkcUriIaPvkYeXPVT/sFEizAx2f/Fun+WELdLT9NoAX6qsifQAgtc0rPVWBssSKUljY52hxT8S4NSB2xphl4barAdMEv
 ghECDOni
 cTAErDZZZTT4m7jo8OCX45VRsyS9nHwGyZCfLQkRTbHyBlemVBr3yjRxrvp5ze4dC7l0/UxfjLL39HOXVw5XOQGuWkg/g/4gQcqRc3BaKBprrI4D2wTd2TZrYpiEMsnEgo+usYyPuKkS6LgGpd2SvcdPEa4anRkxk8q2/H2pR7fNG1W7zrszmbXV7emyRES3GwlezpYRmlA6RT1vBxRsxM/2R4hwxZgSiMljUCO54t0xCVCRYKlqrOYS7lKM7mgNrjIj20Le/54sq8hKhYbydscgj7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 06:53:51 -0700 SJ Park <sj@kernel.org> wrote:

> The comments on damon_nr_accesses_to_accesses_bp() and its unit test
> warn it can trigger division-by-zero when the aggregation interval is
> zero.  Commit 35d4a3cf70a8 ("mm/damon/ops-common: handle extreme
> intervals in damon_hot_score()") modified damon_nr_samples_per_aggr() to

I mistakenly used the future name of damon_max_nr_accesses() on the above
sentence.  Andrew, could you please fix the above sentence by doiing
s/nr_samples_per_aggr/max_nr_accesses/ when you pick this up?

Please let me know if you prefer v2.


Thanks,
SJ

[...]

