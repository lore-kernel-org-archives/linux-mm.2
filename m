Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C8EF3028B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F456B00D8; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123446B00DA; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45516B00D9; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90DBD6B00D7
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 510CBBDCE9
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:28 +0000 (UTC)
X-FDA: 84549515736.20.FB38EB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A316720008
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUlz3+NL;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7zkmJLFhrZtgZb5xv0tfELwAXDyT6rXUNKl5w+JrAw=;
	b=jC8lbUHRBZ2MoLdePg+g/DAV1bwcBVOiTY8/AiL/iXInZjuI5T5HK6X/Cny6yprAIhg+8l
	H/xmWjv85N7XMim+oMx8HlrPykPP69gV/ma80CKuSkuEEIykEtkWo+WPGyDULQqKQtD0WP
	MVgTG0KG6w3OwHPKRyu4gcV5sez3IDY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608426; a=rsa-sha256;
	cv=none;
	b=yi02yWj8GHqCN2A2MJMSKcgKxLIxseLK+eHX0UEzq6d0TMtXeb6HPkkeHI0Pxu2HXZ4Iu0
	ZMs3uZg/SGUVrGOx0YoFFHga2Qsu3OZvlXW7+FLuaU4T5pX57DV8bVUmIBUkoh1HLPV5dM
	es8NqU6WRKnTQwI+e79hUJEUazbFwFs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUlz3+NL;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C2B04472C
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257DFC2BCB1;
	Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608425;
	bh=9O26QoN+V9tNeSexEgjKx5Rwm+ySmwIIy3Pdsz7ovf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUlz3+NLoFBBpOsHIh6MDDQy19Hxiwz8wOt7dLdhWqaQCiikMxlD9OhxHjxS+Gs1w
	 PEOa+P7iPWs0SpcbyiqYnyHGrLBvQwZXo4bOo93kb4KyVHLu6icQKdw1d5ewR1qj+o
	 MQLdHjCw0+g1R+dvoARJ6mAdJ6oxuRiFf1a08wcrZnLU/yb62DRWBkyjyYSb4fYOiq
	 1o+kItvFI8bZfB8jryOYEgHkzJ1pdrPSqO65Vm+ogCIIT+Jggke9YAiTFFLrOgUU+6
	 IRhkYDneji1tfa/bWsZ2p2J/CAmbw5s+50+t3zZkg8SVMCfRs0Lx4A1l22Gu0iCBy/
	 IEDcsYgcTa9Yg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/10] selftests/damon/drgn_dump_damon_status: dump pause
Date: Sun, 15 Mar 2026 14:00:07 -0700
Message-ID: <20260315210012.94846-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zssoapr5np6mkuwsnk9cbrnfudn8ft6q
X-Rspamd-Queue-Id: A316720008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773608426-17803
X-HE-Meta: U2FsdGVkX18dtkJPmPca+/UyhLxbwjpAF2zNXHgwAVJyD6vZRKrdmzVKGberL8RYkgyIF9ptobZ2wiRIcICe2sr8KY4HK2LJVQBtkbXtQWi1Ykubgbqu8gt219HUMovQ3LXj2DfPZzwcf8JCA2JIum2XHqyWvg1sNvBYRrEHLtsqSilp/uYdHPoVTZ4lz/hk/rU1DHfGZGSzzj8R0ilfbd3PgJPu9PBpYuoLygAOaIf6arynlkD2QXwC8wyUtj62czkYSB5T1rtN+NGYTZhcCFAxQeLXUPOVZh1DQqJoz0GuymwByydnF5gTW7BkH69bXkREtnIjSuK1xaFWrz+9hJ46HQHkl27gPuphcVanl9T6HUkgtxN/ath29Wohr+yd9J2CfWrxEq7Fk9VxVOvp26DizTEUg7Fp+X/CIA03/rUHWrA+yrn248u+4kSbbHJ1KkSv833ojtKL6ka2ueySoh40zr/JXTB0h7XZh3MXSj3MC6QPGdvT83rCVtodkqzJxflyw2lwLZQnpFyMz4jSn1HVk4OpHoCpd7xbwm00rMGOj95PraPJSKURtDeG8nPT01A+Qeol4ffSQnNQFIhbc/pFr7DjKeHviSC4YQcILqSECiFGhigpxU3v3Ul1g7cHa0ln2n+JyyJCpLuh+jonSHg9N9KYvWXG5O+areF2QbhlJIhXqcEhJpnhsspXD5GqaoJh4wnGXB0ubbnbRcJ/AaEZp0qKTnjSJgnGcUsKFxJB0yKKukhD6wues1wXiHSa4pcK9iUzYsG6U6EUzO+AUO2yNkaROxt9uBLxrjA2F/7ykNeZipz9fuWmxV5sPlXQ/2XFI9v7e8/gOPLI77bo2DFczcTH0u+yUBhrdt6n8l3UE/gAcbY2wswSilMJ76KzGc9ICSYKGM6Zla5p5VApgFz2OiY/MjUdoDTvx5hkciPqZf1eSqQ+X5hIscdxWtCSl/WokpFgv20r9+DjHqD
 VJpUPcq2
 qRbEPl0WtGZMnGB1uEQXgypOFG+UQUvj6CVS3rUoo0FAQ3Oky40nzE06PtqhxmduWv4uzi9TRCGBioUckMrUZeOBB9Q53S3GK/Uzlq6I3dESb49zGPJvkIichqB0AiIXWkvFPiezq5WW+3V1hvZ4iJPZrSZwkFx6jVAlUPdlaxeQIog/o1KajKe9bifkhItVhSevnKzfRs2QNGwiBUdlWSulSo4ozPcigU+hGXRa7wkXds57dKlrpqleP2uUosjfOqDCH98ezCmKe0Kocq/1vxWAHJZFDZGJ1/l1nTpuHcNBtuzoHdU68xAr5Or6UTwianRUpGeVECn7kE/QytTfZyqAQodXWWF7XmxCZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is not dumping the damon_ctx->pause parameter
value, so it cannot be tested.  Dump it for future tests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index af99b07a4f565..5b90eb8e7ef88 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -200,6 +200,7 @@ def damon_ctx_to_dict(ctx):
         ['attrs', attrs_to_dict],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
+        ['pause', bool],
         ])
 
 def main():
-- 
2.47.3

