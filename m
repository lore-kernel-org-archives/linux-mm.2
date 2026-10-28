Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5EEC606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6tdC5HJ
Received: by kanga.kvack.org (Postfix)
	id B323E6B0987; Wed, 28 Oct 2026 00:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2BA6B0989; Wed, 28 Oct 2026 00:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2C96B098A; Wed, 28 Oct 2026 00:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 743FC6B0987
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:26:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C58A6120B35
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:26:28 +0000 (UTC)
X-FDA: 85370748456.04.5066AE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4794440006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:26:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6tdC5HJ;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793161587;
	b=T1AjTLDO395J4ko2+qL7sTUu7EqO3QZKHRboFwb/9920ETc6myD3EGqyoUjlhUy0w2oQdQ
	B+ZJyuhrQKHhjo2Nu9z4MdzZ+E29/xF8RGyuFsLRR6Mew90pa6YuBWcme0PpU2uLzpmWCc
	chR82VxPAJehMlo7yQFQVH4c0IAkuJs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6tdC5HJ;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793161587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qsSJjk2iONV4ODDHOr7Ui6FDrROh+Yjjmw83BnKZCco=;
	b=44ddPttewYoQEzbnKsssxmlUSDc1O8xrDylfgq379iRfQoXeWcv/0FedrsEGHPttenG9Zd
	xU4NKWi2TnyPfOaYFsMhj7z5erqjSRCyDb5fKN6yUJdLN8Pti2LsQPFwErNVxXk1jjw+Ij
	D3dBgUuNv5KV+1LHv6+F/AbzgwxaLrU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E9FB41817;
	Wed, 28 Oct 2026 04:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205B81F01825;
	Wed, 28 Oct 2026 04:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793161586;
	bh=qsSJjk2iONV4ODDHOr7Ui6FDrROh+Yjjmw83BnKZCco=;
	h=From:To:Cc:Subject:Date;
	b=B6tdC5HJ9k3ZB4fk7jBl3mMIc/5JBY7E3fcRpaOJwhBROFz+b73TIB+x7rOev7ArW
	 hTY2MPjSLu6meWTZNjYIN+TX3k4inwAfQUMBYcl2hgNzbJy5sKE7/+ROCiEu//cVVK
	 ATO5UDNn4IkjcAaQiyREue8O4iMqjIfDFHDNmT0N2PenX4wKRDSPuLajWmZVnwPe+m
	 yXe+/XfoJzeTx6ZmMgELRS2VUKnnsbKklLMGdY4MEGP74mVqgW5Gie9hWFaCjh6dlf
	 7j8A7KkkztoKTnAYtlVhx5oqwnH/vf8BRgvkSv54F4q8FHJLWXHrfe0VhFq6eFCD6t
	 8wnBq2HY/kYSA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.12.y 0/2] mm/damon/sysfs: fix pid leaks from wrong error handlings
Date: Tue, 27 Oct 2026 21:26:13 -0700
Message-ID: <20261028042617.165657-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4794440006
X-Stat-Signature: 7fe1ho8r935qx1krquigabjztcih6mc4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793161587-148381
X-HE-Meta: U2FsdGVkX19qisYXgk76d7Zv2Ct6o6vaiVqPysnylbTP6juDs8qIbA5X8k81ibOkx0nYSkqnUA7Xjwkjpdk0Qa32aQwzdDc7p/bSst+z4+8bEwu03MHws5ZmNzyRe6p2tci+V4T1K0YVdar7REkNaNH4wlwYpVz7nIXZFzK7lFVng2+c3MKrKn5kJDhu+WM3Vutem4ykysKpP5+5jTWT5jl6YhS4X6lE/r/YtZGPBDWvCljmB6wGdLvl991BPkkz1SG4dj+C0rBpuewFpmZnwvNtOhEgbmilrXeeECSA+EzEmWbpK7WV+Jsq8dTbze3sAnwR5OSFQwxE6IkHu/Ms8wqbdOfV5dv7z4uUopdNDpYqBmPo7yr5CJ8+bn6VbofCyR7zEi1CPWocXutK8QQ09rdt1zAD4t0Q+RHwISoan94ItbVBoO3LnmRHvm6GVmdzSoqcclQtDxB9Z2j4Rbg3ljkmDbasdhFOocuR7jaEjxRx2Ekk0dlU0Dx3bTl3U1D3Hyz+FuCBfIjww8LortLLn/AB4cpAoEvDZFeO3LR79s2jhFpB6Lq5DRRcQFmVpxywBk0hsgR6rd3w1BkfL/qzDEfxsEqgJQiw8sYmBWKyvnnW+32ZuFAk5vGlH/jwW6P3rqRcKHmzftbQJaSjv0sT4LzYhuDhWzXugej9V19+a3UkUoIHGk1a63OE2MfDiSZEqZ6hZsopG6dz5Uuj5SQFod+z6AGjH25htg56xXRV7bOanjiBxFBh8efPQ9xEwotNx/j8zjLZhmT/lh/R0iQyPB4g34b1Y6AGayDxgpW/+7uUPamvlkiuCM62AsgJtjYwArSky08CKCDyIODYOPi9Jz/CC5R6gBlTyLwgxjkNR0XRlJSZsFNcLG3/eWhiQo7a1f/KM6pHbG24zjEs9LA4OFm2iPozRNPeN3f16PdhGD2OoaVBTt07ki7O5zAtqqYi1bCPaDltmUBg3/tEUnu
 LkLhMKxr
 u9VwbDAzPqjIfVM+NPHdMcjjUxbltvPVKfBYeA9x3fZpFUfg9mYdqKQpcjA0uh9E85KxtYc+S/yR3NqS47ycqhgCpN9LQxB7ExLwDc8uECg2wW6ocEbcqJiYpPJYrkPnN9cDwTTsp9/kNsEr+Hb63qUIepnPllpMEt/jvZvWlHOauTLLXjPWgnkDorSI1PhmlmtP6OBmiMJCAOiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface can leak pids due to wrong error handlings.  The
issue in the mainline has been fixed with code refactoring.  The
refactoring is done with commits including 7114bc5e01cf ("mm/damon/core:
add cleanup_target() ops callback").   Porting all the refactoring
changes to old stable kernels will be challenging.  Hence submitting
this non-mainline hotfix series.

SJ Park (2):
  mm/damon/sysfs: put target pids for damon_start() failure
  mm/damon/sysfs: put target pids for apply_inputs() failure

 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)


base-commit: cdfe28f3e9f0e6bfc80fca63d2defc5eb972d56c
-- 
2.47.3

