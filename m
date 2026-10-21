Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79EBA606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ktTFZgSa
Received: by kanga.kvack.org (Postfix)
	id 8FD8E6B06B3; Wed, 21 Oct 2026 06:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD766B06B4; Wed, 21 Oct 2026 06:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2AC6B06B5; Wed, 21 Oct 2026 06:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 583406B06B3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:49:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D10CB140395
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:49:16 +0000 (UTC)
X-FDA: 85346311512.24.903258D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2C00D4000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:49:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ktTFZgSa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792579755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6j8VvuZql8VshmBaFWvTWJSnRqnfgGGAQcEU92nPh4=;
	b=UgJrzHeQ1xNQnpvtstrKj8SLJFIO2hos4ekjyHitOOFXqs02QlKB7C+bjFgl/ZMt25xPZb
	Z3mk4jKX9zRVemMHU6R8NjwStCcIFOQSUEJH4hCsF8OAwbPgczSEZ0VReZmxvk1jom5bO9
	QBT+80zgBSbETUZEYOG1RYCWb4QZy5Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ktTFZgSa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792579755;
	b=4rN0Qo6xhiKSp+GPldKNkQIGKcE1zOANoC4OIwF6qCiTq4mdn++gyKBsLcE+fqXCQMfegT
	Dk6vnFA8aczqZor/v5QtE9mn8vo0cmFBEA/Hrw7mDvIuQ/EAHyb9DVf9jq0ThigccroW0o
	FH+Ryx6OzTfsg8u6IP74l/JET0d/vis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1EAC60098;
	Wed, 21 Oct 2026 10:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2974D1F000C9;
	Wed, 21 Oct 2026 10:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579754;
	bh=a6j8VvuZql8VshmBaFWvTWJSnRqnfgGGAQcEU92nPh4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ktTFZgSaXewBcZAJ7e4n0ylcCZtDk0VstshZqq5L+H5wUm+DlyHaZY4sBgoz+KoPa
	 ENG3oelI37RsleO3YYEZO+unP/LpyOCn1vdAlOlguRoyr1MLEAvQ/4xPOi+OwriRcj
	 1DyriKqEpho5M/Y2DZtLa38IoEt81Ztubhzkf0LIu2TQ5YKpSBWVOdjqvvwfXKaY1j
	 twFxsKgHQ6lFYBGDyniCBCFZGKcgHHFR5eG/VYt6WdnTYp0FO56Y5EoNPC2dpd+dXT
	 z175Q6JppgyH+z5XFxNXLbNpsI7f2R0EEGXRo2xSPqHShS6kBKROa7xVufU63GDN++
	 ZoKOdBzBZPCQA==
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, 
 Liz Fong-Jones <lizf@honeycomb.io>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ian@honeycomb.io
In-Reply-To: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
References: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
Subject: Re: [PATCH v7 0/3] writeback: let foreign flushes reach dying
 cgwbs
Message-Id: <20261021-anbot-mahlzeit-bankwesen-0c79e6d05fe2@brauner>
Date: Wed, 21 Oct 2026 12:49:06 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1646; i=brauner@kernel.org;
 h=from:subject:message-id; bh=48o0GEFu3mgqTW8sPyMN6GkxqnwEI0p4H1ZDHkTr9zM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdmLFU/a3Iiziezj9uslPWMUslzCxZ87Lhru9V/7sKs
 XFC3o/mdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk+RMjQ1vuqnOHSoMV9gut
 rUxUfHPT55Hrpv8rNrddzTSIVEvzesnIMFkktz0z3C7W/uPcXbde2YfU76kun2OmwDvZb9GWtWW
 P+AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 2C00D4000A
X-Stat-Signature: 4s77tzwn9af6bskg7xi1fb33g8111f67
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792579755-73870
X-HE-Meta: U2FsdGVkX1/3m5sEU0tjE2tbW5tP/8Nq/VkrqqNQk/a4LUI+r2Wp4f4/qUEDTD77OCXeQ6q5cEOfqJ2W3HowZX9KjsxQlcHa2LGvw6BOGAzotbXaRnVy0UGl6RM6yUZCkcaH6Awn17Fv+X/Qmxruk6Q8WtOHd8eqzEIliYxqOqH5BpBjEmKRLWfVVgG6R5g/Zwz8dwDX/26imF2dEdDqGvA7ZT3zunOvpGuF+zd11LgSoRl7SdA72YhmAdGeu5NyLTdJYLXO1s+NAAUDYT+rh83D+1NV+OAdZ4BQqMoUnOBYqk8+oKh/9nltAXYHGJT4vADDGBcevMr9YvUUltsUZPJ3ckm1c8h6Od9uj/Mof4XQsJmaDDN7xXX80hRhb8J5jH6vo1zsWYzY4yhWOfViPZBjkMGkenHjAIUdYdqsmF/cnUg2IN2n5g6V6mV1DgHr1QO+PG3q8Yey3Omg+A9VUSAA345EqLemvjUBBgBEYA4AcMiKg4PtrumFz6LF7lezOhJEGYCa/79GENl/z+WCw4k096lS4+DwnQ+eGE3mcNbIFcG2LGWI5BOYXwVDVgNAy60guD567S4ZGWF3LX1qchVhfnmFoMvVnmPDB3K7f20CDy89JOv54PljEgXfXK7aqe4mZAdv2QJliurv1LLQPNkEw0KJisBKaI3+m9i/g2X2uHbu6Hj2f+En9oJ8CQhJg+bokUhbXKnEKsue21tcgLxPMUzjMM+zSrlCon8IWHCjgyq3XRmhq23xB4S4Z2W3Io1UXYuoTAxQdQ3H5BA4DCTJ/Zy7DQediZIJSGXnjfCY7U1DVEiu0d5infF/v3d6M+SMCQj8L9MPiR9P5TvnB2njzuGM6wuceLsg+ldzyBvyHZcdwcADMTi0Wt5PXLwcTmah/9lzsexHNIJbiSXQcNSJxlti3rcLShLAHlww6soFlwMzEkqkXP3owPQCzVy71VtShpz4FWVZxqLPJPt
 XP+QWxsP
 5I/p6RQWQoAyWa/6WDnCfYS1zUhFM6t/335g0LjUDjV3W5CXOwMP3d0rDyDit4gdiU8v4r0oOG4uy0Yda5CpX0ZQoIXsf7tz+YjkKtRy2TKzBoGLCnROYt6ZFZh4qIZPPMPK0Kk/P3+A+0VFqiB+T3iqDdD2K46gh9lLsjkW7pgpq/+bAMUkfHuPdgoNhNKWSP7S6l81c5xoPfeG538KLVIbkdt1Gqjty/eXmfgIMt/1VlrpquaDUkmRMpZX8VHK6iGNMWnobTP3ySN1JTKc/nd9MfJT1MhItVdbA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 15 Oct 2026 11:40:46 +0000, Liz Fong-Jones wrote:
> writeback: let foreign flushes reach dying cgwbs
> 
> At Honeycomb, a container that reads from Kafka and writes columnar
> files to a host volume stalls for 30-60s after each deploy replaces it
> (v6.18). We're increasingly confident this is the cause: the stall
> looks the same as in the reproducer (little CPU use, lag growing
> linearly and then recovering), and the mitigation it predicts, moving
> our final syncfs after the last write, worked in production (below).
> We haven't caught it with probes in production yet.
> 
> [...]

Applied to the vfs-7.5.writeback branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.writeback branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.writeback

[1/3] writeback: clear the old wb's dirty IO state after switching inodes
      https://git.kernel.org/vfs/vfs/c/d70ddc66a4ed
[2/3] writeback: let foreign flushes reach dying cgwbs
      https://git.kernel.org/vfs/vfs/c/27f228cac83e
[3/3] writeback: switch a replaced cgwb's inodes to its successor
      https://git.kernel.org/vfs/vfs/c/90158789e8a5


