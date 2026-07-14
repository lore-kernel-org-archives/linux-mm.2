Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDD6C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0242A6B0088; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17F76B008A; Tue, 14 Jul 2026 00:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05A46B0092; Tue, 14 Jul 2026 00:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD1996B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24FB01A0291
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:45 +0000 (UTC)
X-FDA: 84986116530.06.E4709E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9F8A1C0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drn30NTu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5HorvAmOdD8OW3Wub7kaOWmH60W1P8iHnRf74xopIeM=;
	b=Y23TKDJregGDx5ES89siIN3Y678Xj2NcBux76bM588lZltBnrDj/NSmb6H5QUjzAlKT/0U
	Vqx4YgzjEw/svnOxZNr+9KGfJ/LN+x6iS216O0Vkuflpc4SMB3pOcLJ6IWjQgY/OmhNms2
	7ZBawA2tjncuPaKda1a3bByAZZf31Xc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drn30NTu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003683;
	b=jk5KQT0Xf/DIlTXPykcWIhc858GyzlhMGwVqoIAjLyR8fatAHCasbRoVDTsVjwwzonVGre
	VmBKT2NlpVmq/qCutapmg7rpdUAex3ZRVKZDr/KqCnb/lO2unOXu6ZvMw7dX56DNzEdRhp
	MbPLy07buoFxfexWToF88bqkuL8YLa8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E22A0601EC;
	Tue, 14 Jul 2026 04:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7201F000E9;
	Tue, 14 Jul 2026 04:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003682;
	bh=5HorvAmOdD8OW3Wub7kaOWmH60W1P8iHnRf74xopIeM=;
	h=From:To:Cc:Subject:Date;
	b=drn30NTuEyGs0VhHRcO2ejG3YH6liKQeRe5AxNWRh4i/+A7XpsuZmrdwvvX+lwJSl
	 6AOeFEtEzP2ViEBt/iijZ3ehOfYqar+arJbzUHe2tAOkP3cAEd/hu9Smprb7kIxoX8
	 t3QlN8GCMK60uFV9IJ7ihwhEMvhhTBluAKDKNjNFj1BiBRC6yx3Yj1dPK+Pi+3rR3p
	 6DOZsqtarnk0GVD+7HgGYPXnExDizW1R/P+MbLlVe6t8nn7qEVM5c54prvGLUxAPW/
	 bEPxRqBbBOh4ix9OHRKoKgxE2wi3HFVfeFoBdjWTdkr/YHC4uRJU+bOFVFaTFnIBX9
	 BlAa6+mUSZN4w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 00/10] mm/damon/core: hide core-private struct fields
Date: Mon, 13 Jul 2026 21:34:26 -0700
Message-ID: <20260714043437.95811-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F8A1C0003
X-Stat-Signature: yyqxp7qtmsxciud475ramp48r9ogdd9h
X-HE-Tag: 1784003683-150342
X-HE-Meta: U2FsdGVkX18adUAXTWgjDdDbU3CZfsFgPGoo67atNlaeBZ99tNp9nbgcknB6NnEoh0Pqwbfl4janzMu+uSrbkCHMNsBYUSHd7n3HuvheSdpFLQ04sWrSPSsh4RO6Jv3tuFEVoOfaxQuSundWO3M55JBdjzAQLrMMlyymvHMZ+6jDpDjS5cT+ISYxeE2naqk3Lrimj2os9MJoKUyAVmfce4wL9k+Q5MmglI7ChPr0CmsMYPNAjOcyWJNhPAa0GbdN7o8kQOBddbdVAaJNVfdpp7bEAeA61evWyUlRRMfVfFljHiYhhy2VpYKigcsnyWuJaXtKRwq4hj9Fetssvs6ZiYg+H79ovWpkNhhK71PA/7jH/uTY/IEnyefN5KdHGjinjqNfqwSNXBOcLxd+yP72aMxz8l1iZwzTuDEi7E2WQhn8yawIK1yJkN0I4KFbn53vTYQMc2Mx2rUYV8fP55zRlLV7Ikvyi6X1rx+g+qTof5XDcXnA8TWvE0ldSFp1LxIdApf3yuf303vnrRp1eeKUnENTamMlkkHRYIRDLuMUhIdmRBxXP49M4FiYLvDhS/Bfcm1M1gmPULOlgYmxrm2Gn8uLk8PT3oq9Q7EEn/ydm9g5DNhC9fZStnH3kO97BQzQA4yxb58c0r1kw/U5/mDsSKhaNL2dJzIKQu78nuQpzM779Se2vbstDjFQq68w0U3Oo8Rorp+fIXRnc/kQ/RNBlKhrMk89JF2fGBL4Dz/+UovCKiXV6lHgvWwD9oFbAO40P7FFjzikvOCxVou18W9Gtfqw1c05W5x/fx4i8ufH61PqFoawLsoHOe/0mVwTkeYQQYV7yYf663ApU4nz+kPATAHs0fYugVY4O97j/qRlDbe3lc8vUwdYS1gf5WHfMqHZ3xX0Ge6B8e6JSr4LU5ebq/LMc/j/CZzWh4t+JINus1/AbjFqc34Uqtt826qQLvz/19qS7HGzTsgVuVrwRwU
 V+roUKzl
 ceae3fEfHruMHjJU/nUQfU2d67dFBVaifLoB9ZFlVReltQUc7IgJvmmS3gM1M0QCJZOZ4akrt47ROXHvnAIUxxZnjM+4wQTf29L4mdMwAMKzpP9nxq5jb4H032YHbpO8nvmQNnTWuGExrx9WihpzgbVDJ5gbI32gti37C3qZcZY82EILZSxwDv7CLu7GkavfOcNDN4WJqh9jamD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core structs hide core-private fields using 'private:' comment
tags.  It is incomplete and inconsistent.  The linked list heads in a
few structs, for example, are intended to be hidden, and always be used
using the wrapper macros like damon_for_each_region().  But those were
mistakenly marked as non-private.  A few core layer-only fields were
also mistakenly added as non-private.

This only encourages callers to directly use the private fields.  It is
easy to make mistakes, and difficult to control.  Mark all such DAMON
core struct fields as private.

Patches 1-8 mark the private fields for damon_region, damon_target,
damos_quota_goal, damos_quota, damos_filter, damos, damon_filter and
damon_probe, respectively.  Patch 9 removes DAMON_SYSFS's direct access
to core-private field, damon_ctx->ops.  Finally patch 10 mark the
private fields for damon_ctx.

SJ Park (10):
  mm/damon/core: hide private damon_region fields
  mm/damon/core: hide private damon_target fields
  mm/damon/core: hide private damos_quota_goal fields
  mm/damon/core: hide private damos_quota fields
  mm/damon/core: hide private damos_filter fields
  mm/damon/core: hide private damos fields
  mm/damon/core: hide private damon_filter fields
  mm/damon/core: hide private damon_probe fields
  mm/damon/sysfs: do not directly access damon_ctx->ops
  mm/damon/core: hide core-private damon_ctx fields

 include/linux/damon.h | 110 +++++++++++++++++++++++-------------------
 mm/damon/sysfs.c      |   2 +-
 2 files changed, 62 insertions(+), 50 deletions(-)


base-commit: ddf3f75c217672edd46466c9156d64abf5119b68
-- 
2.47.3

