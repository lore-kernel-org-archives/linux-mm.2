Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A97C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611536B00DB; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9246B00DC; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFBA6B00E0; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE306B00DC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F84814039A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:36:00 +0000 (UTC)
X-FDA: 84987631680.06.9980CBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF52A4000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kPizrGqx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrQWXD0bifnsUsYgqcN+mYTdFMuNVs+95dSBQVBP0NI=;
	b=UA8MTmd9VkIziFkUXgIMPDvCMiXGa741psjci7zUbdtkjS5cci8838zNiN3uveNAAUFhUY
	i/bRSaZRLgYRWOoEQuRZNgv9vCwZx7fVUXfWTruTMwqcrVxElcOZDsbIzpjEnd6Qn97JI4
	LtkdHmtxKDIG/RKYue+A/R3+BTnU4IM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kPizrGqx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039758;
	b=Gv3WJYkD05L6esFZQXjI+GRhNjRgSe/90KzP0sFKRVT61joiv5ZpIUghhIZouges9JdPa8
	9rsZAfL7P/FCneWOUZq9LVsM1RTw+UFZNjHcb/vUaaXtB8KvtZIW4/Zvrl8kS6TfdWesTl
	YvAd5qvGDz9pX+C/g+rt5lCGeIkySRw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2761243793;
	Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B1E1F00A3E;
	Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039758;
	bh=UrQWXD0bifnsUsYgqcN+mYTdFMuNVs+95dSBQVBP0NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPizrGqxSPrlQ0S99osZ0phDKd36Guwa0fDDzPkVnkKOq5VFh9VVdj3eS2argD0oy
	 +HDpzY5VSllxbPjICaKzm4WWEzlTu5/QxfV0QG1hnCWCFWHyoadn76/HbrC5s2/I9D
	 Ad6sZD4r9FKuklLhwdufn+NrESCE8OIIoqVjedHYsqR9kZQ7spqdA6Ursp7acIK6Ng
	 BCz7tgC1cC8eWw/16pFxoRjs3FaEb7OlRxbS6xhH5j+b984ShtOdYUaX3sbY3eAdbj
	 ECAV6F/sA2d0PDRDH1fR//7+2qCm9gZIOgfkZCe9vZxbX16nrGuXIVqigkjoSzVmOg
	 caL2SuWnLe3UA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/10] mm/damon/sysfs: do not directly access damon_ctx->ops
Date: Tue, 14 Jul 2026 07:35:42 -0700
Message-ID: <20260714143544.101305-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8b5tptgcnmsx91ry3xjz3997othkmzsp
X-Rspamd-Queue-Id: CF52A4000F
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784039758-778081
X-HE-Meta: U2FsdGVkX18cdvay04fO9ZIxFI0k3lLlivVv2vKZn4JHF8DTU+wTW1fekH23Ma5QWRWHRxGn++eizGlRsK3962q2t3qyTfKZAuQ6X5fpU2VFwUPE01HoSG3ml5r02R7xYlxhF9rNV7xdPQF9rpPmc6jFn19RL1ATb4bz8rVJ7z3SHI8cYaxCR6fgx9ycDG4joQ3o+gHEgyqm2GHbbFCKUOinwDVGqcVyeKURamevCXYeRXYEFMIoXe97k2ehX43L7TtydM+rx3+NgDVNbnWQJu4YtjWfm/4pSIuQS45d5B2L5ePZXiCSEcTKmWE1jS48NiRSPhs1emQU2+x+fD56xoz/7uYuBgxVtXV+Pkv1B2EJqV90DGyMEY8ebSc7FZJQqPAMNskBOJhGzZ/xeXGy6jIvbprwWcJlDIIp9IM1cYdajQAlQG4NvVj07ilRUBDle52cTeUKP+AJAgpm1DAfa9Le5kpxdUmkmsR6TcVOcBKySGczHdqTI2sOMtpXyUyjzVpANcoKr1QwiYyw9agT4n0GeFCqvsDB6L/D4yUdIxgZAySeWxax+0Uq3e53tgXY+V9S4LD+w0FeTZQtgaY6a54/73CpwhKAvV+0HdnOAHdBU6PEgqMyBa/a1hBofVxuKaapOupmaIMfP+OsOO+8tvrRMXL/ovgbl1Ad/5SgKEk5u1T/cbaT8kL21l3FfYTgaD3vNGgk4PyxE9Og/ffH/tliN+PL04kERzJ2b6B0hQJiH0DrTAeOQNH05AkY86uH+UiclWORCKV+dr7pIGeUG9i0TGlSUcn2JSl14jf5fQK9RGZUqIXhaOUQN38yjkvOyHkE6vkAnciGBmJmlTRqH0gd1Qd7syf+3bNPHca/p4PElXza15r7eHRcNqVc2tzyme+DwIw+LzVxgQrMmhctW0glHSnsc7gqXPGYBWodMU0tYiB8KLltuxrYDcbLEoCHoXVyln3XaUlXpq0WaTf
 W7LDqw4C
 egayVtlfAgkfs3Oc9/CHzsa3VejXc7nCytjjQIWbqVGsfexrgQfe/yuHXHGQIAXgmzL7CEoSRNWHM84bPV9pgOHGp0fygWvQB2r7gcFgz4Kgtd624jO+bezdVJs4p0lnLBPTcZbUXLc+BSnvA9RQAqKy3KXlJQX0qA+zui6arpTiTA460oSAC7dF2oA4j9rNiQODEoZ/fYdFeWaZNrOsFzJZXcs1xrSZ8oUb08+9Mt8Q9ur659RfZ5xxa2MZoUDz+wEi9wTcmvly8FUB47jOVFVicUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_ctx->ops field is intended to be used by only the DAMON core
layer.  DAMON_SYSFS is directly reading the field to find if it is for
physical address monitoring, though.  Use the API function for the
purpose, damon_target_has_pid(), instead.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 60a1a9e4ada34..228ceb4df5f97 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2051,7 +2051,7 @@ static int damon_sysfs_add_targets(struct damon_ctx *ctx,
 	int i, err;
 
 	/* Multiple physical address space monitoring targets makes no sense */
-	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
+	if (!damon_target_has_pid(ctx) && sysfs_targets->nr > 1)
 		return -EINVAL;
 
 	for (i = 0; i < sysfs_targets->nr; i++) {
-- 
2.47.3

