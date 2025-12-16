Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58BA2D5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2544E6B009F; Tue, 16 Dec 2025 03:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1026B00A1; Tue, 16 Dec 2025 03:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE076B00A2; Tue, 16 Dec 2025 03:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E406A6B009F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A77C859242
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:54 +0000 (UTC)
X-FDA: 84224590548.02.8CD305E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0D080140010
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ubgibi1o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872113; a=rsa-sha256;
	cv=none;
	b=kUxLtXksEvW2A845DCjshzxOlQRTgIWhvRHQYkd3ee7wAo0nz3UcOMEznpg2p1fVgouffS
	QfWI4/mipvuVv/pEFNfkyIhdGti3oOIboVDlc6RyXeZwWINQQpigW7kEf5Xjd94nN5KCI6
	7tvUFDrgO3g3dJgxqm0RVbSdBbLBCUk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ubgibi1o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAhPChlG7dBut7QaS1WLZVcnyItZVysppAQHnGK0xOU=;
	b=Hl5Zz3OBK6eyExooMfWtUPg2k5n5GZfoJrgn4zRrdNcDi3FNmaTCOuUovsbiqkqK2X9BMG
	YtBcPLDRUK7N/FlDTHIWSjFH1HLVYslvZ+f6LwwqhiFKM78hp93nR7keItLVo2Hx3En2J3
	Apy6vw1CgKKZIPKlyPe1LokG+kOFi1A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92AAF6018A;
	Tue, 16 Dec 2025 08:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2D5C113D0;
	Tue, 16 Dec 2025 08:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872112;
	bh=CMU/MAqiw92B3IvzGFYdKBKpTTJU4mdm4PDik0TPe5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubgibi1oh5rwQYBQm0dtApjfZUlrc5w0TF7s0jJdAMTPpLkeyUh0Xp79yQJAL937x
	 sqq3MwE2FgAtXW38Ew88nTKFuVBaXggJAZOjQ5eDBPgMM8pOHWHxJG8MLmNdUP1rMo
	 2bP7q1mKE4VYIcZJ5cR1+Jb36KZPD6yOMX7ileyKOIDike1DdMvjyH0Mb2QfXDGJuC
	 E0YFBdS6jWtslSndn43dkwS65KOvC7iv3//W9NnvRo1a9uY/+ego9Gl4bgqgk+0+la
	 1UbRL4aQ+p9lR/btcRC7aOD16DSIyB2sso3N6ln9TAPulZvOAab/0oCqcr4Y4w6JSH
	 eZY99cw0M3KoA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/12] Docs/ABI/damon: update for nr_snapshots damos stat
Date: Tue, 16 Dec 2025 00:01:18 -0800
Message-ID: <20251216080128.42991-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0D080140010
X-Stat-Signature: fj486ri4hjuu1w966kqnwsuabxb3s1rg
X-Rspam-User: 
X-HE-Tag: 1765872112-486926
X-HE-Meta: U2FsdGVkX1/R1ft9bfvDshJFb2w0K1kPqoKy+tG/w/8yEuus9pai9aKGIp5e63dUcRwx9SaU+QBMD40UcgYoOGpj3/S9n8y1yZ/FV4WNDndGA99F/Lrh/4tZYTIEN6BcTJk2uSATLH7EIH0fLfrT6ZMrt8TGXkfcsazkuq/zA6tLCRW9BXNqbLV2IoTE16QcIuq8dhaP7f0HyOq1rZoyDAXuF3tZXrxzRxhxbFfQj2uKYSjkbPYRRopyQOeqplITfR5DNotSRzoo9rs+ea86pOTBMUFCgTgW34W4YilaCYan/2BUPbSghFJoVg+dGfgIoyxejS7YjDm2cP8DU4Ve+CEWoOo7PrTxw4KDhqaifoetsAfjUU4reA8nzkCCZXk2U9RzAwFBR4Yz8XvDwQsoA5HqvfJO95lLF0x+JoU/f0Cg2i6zaBhNZgy87k1UUQP/EDxgh1D7iBVvm0lr9a/lvlt/1LJt/u48bLuidCk6vl5rhe2L+4ep0nR6Py2gipxufMlRqo9VRafXyXifBhbsvCGbEUY54fMPlEFjVHOHSH5iARz4NfKBXpo+qnGoxbmnY//AXZ0E+puOoDBVq49AW88rFf5ddZMq+Fvx/MG1E/Dp8QoGsXK1X+7jgHDPFQBPPXzQSLE1UN3RnXaQHpyhz8sbbdpzSV1+z+Ypl7z+jXR9W6XZdNAGuzQlsp9568b7M7ng2U7usxFLdenFHy8HWCeXBZvXGv+QvZkQyGFNKWkZzZVM9U1lUUnCQgjLZiVloFrN93fpmxhx0HaMT4KIj/NNgjUW4NhdShcU2EFf5+hGRWJFQERiMBO4QyMxxyv/PRKJYcYnnWYfcUZLn/Zq0vIyfazszrzdacvyyluXtBc0uch5oCtNOQagG7OFArWC3Iuomq6vOwxvnA1smGAdQUc4ruMDROD5sbVgLQD9Hi396sP/l3z5YurRjGuSdJe4U3HOf/oswBqqXw+i7Qc
 TpeFmam/
 b0T4P1RUuOSAN64JAzuH/0Y549WwBeyQDHp6N7CzHqWz0P+DkO51c37u6UJnY4xjxZCP6WUJtuD1HAoT6SH+oqdQm2PhxoDkts8uKfxa+n5V33cBIx4t+W86ydzMkxtvkR4JF91vIXGHLDZWbKwAiy4Te25eC3R7ilWY1nuU2/V8RgEsKBHUdCxajPJQsM4wyEGZh2ATTtdhd2nxyvomzPFDcL0Zi3AjZvJm1n0olrMB3XSq2+9T81VYZ6fz0gAqEpY5aynYyJyBEJbqGrpuL2me2rMG8afAxFWsUPnYWbC+aMfhYdVMejeL1TQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added damos stat, nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 4fb8b7a6d625..7571aa78b7bb 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -516,6 +516,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the number of the exceed events of
 		the scheme's quotas.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_snapshots
+Date:		Dec 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the total number of DAMON snapshots
+		that the scheme has tried to be applied.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/total_bytes
 Date:		Jul 2023
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

