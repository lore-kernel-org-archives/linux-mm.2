Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD6ECC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 04:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9FC6B008C; Tue, 21 Jul 2026 00:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B906B0092; Tue, 21 Jul 2026 00:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47CA06B0093; Tue, 21 Jul 2026 00:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0E056B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:31:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41165A03DC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:31:45 +0000 (UTC)
X-FDA: 85011510570.10.53C97D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AAEE540005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:31:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBV5hQfz;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784608303;
	b=KItfsPh1ZBih3ddLFrQMks11GIl7W8QOxjUOo/sRO3u2yz9ZhjKiwcplvv87E6uZmlpvYP
	9Xt9DKeMP/iFOOc+D1jxYG1D8Z4ziRxFZlXlu022XMZOeOYRxVNJwNVgPa95qgosPLFVi9
	JQxl0O6OsKFV9ucyFIjzCYKbRHVfdMM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBV5hQfz;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784608303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZgnx8ZS5nr+FiTQpYq9+40sdtQR4bKeN8zATAftxjY=;
	b=1EF7OpyhW0yf74q6ci9F9Tbx6NjD2a0PbgDrsD9iKeUZGXrqXxlT/ES+r2ffQKPJnP6GvL
	NCUqHdExvCLIYVXZlNtV6ioy5tIktvCEEKQ4Lnm8FjxgVwd8+roU6DPtSq0EB3WJpxuYQg
	FkI2KcTb2SkqWxdPlz/4N425b2WBG28=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF9CA40F20;
	Tue, 21 Jul 2026 04:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EFE1F000E9;
	Tue, 21 Jul 2026 04:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784608302;
	bh=fZgnx8ZS5nr+FiTQpYq9+40sdtQR4bKeN8zATAftxjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBV5hQfz1Dh6xQ8HtSR0sY6m1xs1TYQZlLihJVWqxV+Bf8BRcQK+qDb2kVnVJN2d3
	 WDPAKTW7RGFmPrZLbkzec+KbkiBO718+g1N1vuM2gimcUFcmCCAn8c4sjCR/Uz5wPn
	 YFJP4TlexJ123gV9osqK/2BOxx0Nfw8SW1Zx8gN9MiTX9fViIijzRmO39nUgue8YyK
	 37EAUd5KxgDPFy8IJqXma9HNEnNnj9s98zdOQdB3KyBNDx3V6nKUnfbcevxhPkv/8d
	 5vhF2hDwKxMOCLoifZwRbwgsYsRUNriDVx748w2KD0zGfyWwDKORx4yTvBwyLE6hC+
	 SdfTtzl7GRbIA==
From: SJ Park <sj@kernel.org>
To: longlong yan <yanlonglong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH] selftests/damon: Add missing NULL checks after malloc()
Date: Mon, 20 Jul 2026 21:31:38 -0700
Message-ID: <20260721043139.151887-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721025802.298-1-yanlonglong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AAEE540005
X-Stat-Signature: ew66tqp17ijxus7ho4y6gq1oca3fstjj
X-Rspam-User: 
X-HE-Tag: 1784608303-401485
X-HE-Meta: U2FsdGVkX1+iHj8kAxb1g62tCE2+k0+Xx9jHp+oSCu534rT5qyZbCFa8xveDIs5PgNWNuWAmls+f2jjAd6PrtesF4zjMY4rXH/G+03XZKXOmQk06rn5EbKJCNRAZMtB409M6wchAAPr+YiDRTa8X3cbKW/tejIBLKuFoxW/FjVbIPJG4bFun+SI99jwMuRm9uPVfIcf7nsLUb2fMP5chwgsg2XIuhdtoV5x0DFP1VgDpBhdSipw51KxALw9CIeDYarb7RNYoXSF88hNIMdGWDlmFdztrtSQEzmeZ3P5l/Od5E3QDPmuDAn/r4aQx/l4V/DnwMUyWLD+CrqnZ7BElbbl10rSiq310tYRujrv9UHL5V67w95v6ETmUdYsap+qbLHX617HO3Nu5FEm404oTJ3okh2UpztgeUPm+7Feu1caS4AB14hwtfZTZgx7dzFqKlIUq7zXWfVuZB8kAbhN0Yh+ATil2nn7d5fQGYotVS5mjNOLB5Vgj1i3vileg7iYc2+WfHcYmP+Fn+yZNeGf/l41yRmmeUvFcLtyKo9hr3+BoF0xgRNBO/ubTamIR8IZ9hLKwJhUfK0WMIhfRPC/HUpzq3wyHYX6QddlCetOMx2HfVdYmjDjQCL1pz0IzENHNpWUKYIOVR7/qcw03TyK7gnK4gNCAz7EFBKIJOFPekZvwoS8IOiigWg4FIDJAOOU0idiUs6aDUqy3VEFvVM38GifY3XloY4A3kkPjbkKP87uxJzVyRjeSl9k1ZP62aOwf5I2hwRnU/lbYYOUvpnGxwvTFd3QURWu0q7JdD/zQxXcsOKXfYcIE6NabM72cno1AcGy1FiEkJh/g3xzcq2mVYZvqkUeTx+XUjljXwaJGCLwmoGPfPOH004pFGMr//BTcjOqUV3t5AD4mSn6N81XwLiC1Ip5D5mBVwfb7N08YG5cHoXkWjwHtXBrLjda/WOWVkvOD9T1urx+oRrxbukO
 zfItlXDa
 nGsQQPJMrSAF4h6KedyT+dlqwPWJwlsdU12itldF/SDNwJh2W5NpHXgyNayqbCZ56qwb3b+0V9SCE1UQSI01UqglCxBiOpfIr5VHtqlv8gmhicSJ3n9w2MoFSMiz+7ayLqfpWazlAx9Q9TNVI/6sWjMFLTIyHI9LVzxW/xErsSFZ3wjLZ12AMvPjEdwWRM02k1cjuRTR4gteqnzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc-ing DAMON mailing list.  Please Cc DAMON mailing list for DAMON patches.

Hello longlong,

On Tue, 21 Jul 2026 10:58:02 +0800 longlong yan <yanlonglong@kylinos.cn> wrote:

> Add NULL checks after each malloc() call, printing an error message
> to stderr and returning -1 on failure.

Thank you for this patch!

Could you please elaborate why this change is needed, though?  What is the user
impacting issue that this patch is fixing?  Is this fixing a false positive or
negative test results?  Or, just making the allocation failure easier to find?

> 
> Fixes: b5906f5f7359 ("selftests/damon: add a test for update_schemes_tried_regions sysfs command")
> Fixes: c94df805c774 ("selftests/damon: implement a program for even-numbered memory regions access")

If this patch is only making the allocation failure easier to detect, I think
it is an improvement rather than a fix.  If that's the case, I think we don't
need above Fixes: tags.

If this is a real bug fix, maybe it deserves stable@ porting.  Please separate
this into two patches for each bug and Cc stable@ for easy stable@ porting.


Thanks,
SJ

[...]

