Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 505ECE9D80D
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 21:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40976B0088; Sun,  5 Apr 2026 17:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17D46B0089; Sun,  5 Apr 2026 17:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954B36B008A; Sun,  5 Apr 2026 17:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83B0A6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 17:35:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DDF01A0144
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 21:35:37 +0000 (UTC)
X-FDA: 84625809114.09.6C94FFD
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf07.hostedemail.com (Postfix) with ESMTP id 55C5340009
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 21:35:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gCAAIveA;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of create0818@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=create0818@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775424935; a=rsa-sha256;
	cv=none;
	b=eDSm1HYk56/4yPJIRboevy7EKV0aL0Pdy57NnBxc7duMv47C5eOMW/QKmiGnv8B80Q2vwa
	b8WN8Fuq+BKdYrRyWVJHlyLWAODl/exA0AxcvbknhHepP09MuX7CwgyoUCUihxsOeC1C1v
	Q1jFuaadoiIgrU2JbNTer0UP1huBKXQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gCAAIveA;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of create0818@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=create0818@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775424935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vbdlbFbNNNIfUyUX0JsNdUg8YUtFUxeGql4X9jzJ+Y=;
	b=GZBj5o4Z3NqWmdKtXhBX0YpYU03gROLpVW+PXWg5cy21/K6o+rly3y8ZPNrbFUC1wdG2Qw
	NmZWXMgB4RaZvgNx5pD9PZBgakT7ozLKdlM3X0wq/Zvfx3mxwNdDo8NvC90VE9yzLuHHCK
	ltqikZ6TmS5wfvcL36eT903wd8lf8F8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:Content-Type:
	MIME-Version; bh=+vbdlbFbNNNIfUyUX0JsNdUg8YUtFUxeGql4X9jzJ+Y=;
	b=gCAAIveAKpJx4T70s7HCK22QW/k7334xQjus7sJzsq6Qlr2Ta1UIIwzPDupifN
	pPNZJRcCjY6zvxR5G/vCwNCc3vNCPSRgyenvcmwETWdH9vx6VA5SBMIg22rN7cfS
	Yzk6DDp75MFel7YOeRoBAck3dZ6/REV8anjlT7Bh0ulHE=
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDXfHuQ1dJpNHtrDQ--.62638S2;
	Mon, 06 Apr 2026 05:35:13 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Liam R. Howlett <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mina Almasry <almasrymina@google.com>, CaoRuichuang <create0818@163.com>
Subject:
 Re: [PATCH] selftests: mm: capture write_hugetlb_memory.sh exit status
Date: Mon, 06 Apr 2026 05:35:12 +0800
Message-Id: <177542491250.2079.13359792600713218361@163.com>
In-Reply-To: <20260405132057.c1ae7267911c5657cd5a3fe9@linux-foundation.org>
References: <20260405194623.84218-1-create0818@163.com>
 <20260405132057.c1ae7267911c5657cd5a3fe9@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-CM-TRANSID:_____wDXfHuQ1dJpNHtrDQ--.62638S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF15ZFy8Xry5Kw43JFWDJwb_yoWfArc_ur
	93tryDGw1DWanxtr1Skr1UtF4xJFs7uFy5Xa48XF42yFy8tFsrAF45Wr13W348Ja18Aa15
	Crn3JFWUZ34aqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VU1yxRDUUUUU==
X-Originating-IP: [39.156.194.234]
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbCwBGo4WnS1ZFWbwAA3e
X-Rspamd-Queue-Id: 55C5340009
X-Stat-Signature: mfarrzatsxfjid8upei8h1z1hynadwh4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775424933-858629
X-HE-Meta: U2FsdGVkX1/+rMl8S+6/HtNwCsxDZjCrv+gQWZQKcIhsnU4igFN2aXqbt56m+GriI7GQuVhwjclJugigTBMDQoXnGSPa2DQddXG0AWqne4HnH+gm22xLNpPUW1FCSV1OlW0fc1yqEIiXOjCmtig4Lbnv3/sVCDS4dPnvWLrxO4pzo9vO3p99xUS7aijQSdAgFsHWji4Dr5T1PlJI8V/YAg7v09fN511AmPrmAr2F+7zxur7LXVK4Qa8V+A4TxkOIJQmgHBWjsmtoMC89PacktewUMMoSTznbnjjIOCoz3WwYAuVAF34v0+Z9oqOr9mZspT/ZCvD5cvmuuQ2RvfR4q9uXdujHTRnOVr+z8wjvnqcZ4lh+e0qN3/mAe8fxNQI+AjRkK1XUAWvM/6u/eCz2dRHFS6XvTX70AO6+yVkFJJR+QSMa5/m8UasdpELXI7p5FzfeGDicPnXSJ+yDhNSk4nyYsvEAL9lF7AgcmcbZpyLdMhHM0urqelroSwgdZvY75rdMoZKNzeaKhFVAPLRgT2isURqY+6U6FPwCs1B9V2FTp4YLxlfL4IF2P9gckIWKSXN0YkcmaEoEO1RF2jvtBoP/Qa6V8fyBShn0x0/sxfOSqe1VaoVcbmatlb+JEEmaJJSa78OSIEO7EaPR2dyL0HhDye5QeijDIvphdpgtKt1y9NSp6ElQ9jaeHULSxMkIcjq4wm8bfHZYNNpJLpKnqs8tYEA60vdkM2AJ0ekOeZzPAx8fTe6JEWrnZ3TIPskmov7uzfqsgWbE3Oo4VRxjNj9ZqpGZQrASqKAWJOJ/lpgJFngVlv9BQ/GAyrPQqPrUm1N9u4PS6bAwAokowm64LKogNT4P3+dZUv4p7mrEoFC86svVDdB+cPMDeVcyMa9TNLDMmPh/WZNAZbtxQ9lzr1VsRdmQ9twrOE6RdH9hdrNZvqzLoTaEFXr3FffQzLmi5Ia+KQ6cQYFoKuwLRMe
 gNjMPPA1
 yxT6giBFGrbVQqH6eMB3D+IQmvvM7Sslnzu3SGhpuHE+yCH5SkdMtO5wTbIngWCCSN6+GbZILFD6qRjRdew/TJifwtIsAH7XP8dhrMFEjtbMRWoeM5X3dwFv/WZpW1HmNbLGLTPUT2B+vyeKpO38897mzt+92+uxa0aW9ts+rsP29RMM3DmGC03XItIndtlu/iVP94OtDN6L2930e8DdBgrfuYBMw3Jv8j0XdJzeCUkwRSk1jBA0ED+UuxUuqD2yQ8HCJUw0GO5/IGDvNfA+QMtQ4f2rP3e2pWRhupSIot4uQXAnc3qU7v+DOTXOPFHAmrmVTSBVfhgdf6Lifomi6cCsVunFt+iKzAKsFbYRLwsJCndY+u15hMj6bErZ5HoCHvplZ2kJmi5os7qJkim1EMsURd74kbC9Eby7Sx6ItFgqaaeoBTgBau9+bFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Thanks for the review.

I re-evaluated this after your question about the backgrounding model,
and I don't think this patch should move forward as-is.

In the async branch, write_hugetlb_memory.sh is invoked with -l, and
write_to_hugetlbfs prints DONE and then deliberately sleeps until
cleanup_hugetlb_memory() sends SIGINT. Waiting for $write_pid in that
path therefore blocks before cleanup runs, so my patch can deadlock
instead of reporting a meaningful exit status.

So I'll drop this change for now rather than push a flawed fix.

While validating the test on a minimal Ubuntu VM, I did find a different,
reproducible issue in the same selftest: cleanup currently depends on
killall from psmisc. I sent a separate patch for that one.

If there is a clearer direction for simplifying or tightening this async
flow after -rc1, I'll follow up on it.

Thanks,
CaoRuichuang


