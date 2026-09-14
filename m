Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C19C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAC86B008C; Mon, 14 Sep 2026 10:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BE36B0095; Mon, 14 Sep 2026 10:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79F76B009E; Mon, 14 Sep 2026 10:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5B516B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:23:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21738A0100
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:38 +0000 (UTC)
X-FDA: 85212586116.16.B9FF3E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A1F9C0005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UnBIhXhg;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umQcJFGrr068QYat6Lud6jcAzEmAFL/l4IbhvroBRbM=;
	b=r7ZX5tZyseqOfqq4xS8exl4O1o6+Oy84HX1YIK/gTzyIxR7/aDaxlFsHgFmVmxK9yUFKze
	RMXs2f/UeJ7W1arDoZlYMDThMxRr3Ac5HkhJnq0L7JqnoAji292GJC4PTRjQzTGIV2hCDo
	xzZvzTKp7lUs3qUuV2PNE6Vk2/XaAL0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UnBIhXhg;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395816;
	b=s3pSercJkp5rChvvqwuF3MUk2hrkqlEqn34/4SsWdZHxaLLF0hZxVehRIol7UW7uiigHFg
	yE97vyAx4tClwNQHyGTY0syF2lEsF73c6mFLKTuvt9e1FBrYwKFgBif2whZl+ueO4Bu2Bv
	ddKrStCLv6Ux1S6BqC5Tz8DSSax9I98=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB5F443CEA;
	Mon, 14 Sep 2026 14:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727C41F00898;
	Mon, 14 Sep 2026 14:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395815;
	bh=umQcJFGrr068QYat6Lud6jcAzEmAFL/l4IbhvroBRbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnBIhXhgSEQ7UU1Y7A23DFOancx7pojdDvKQJG3K18zt1+0sp17kaIancC0qgk1MB
	 P9zgKlEBxWUhS8wBlbpaotWyNZnDSf+dhF/27pMH4jmWVSo7prg8DURkYQZT87PIwc
	 OJhAUiuXPjlsZfJRSViZceuZVzfqqP9qrags/bDvQ59ntrEaY7rF+cdcdmLtlsWKgQ
	 GwxbjxomNNk5Sl/bDh4/NAbWNggLW84miZrDaFjyQvYDgRY3yadolbgvgM+8S1nDUg
	 8MCPy/K0o8UtR6990zfSxZ1V/xKVkXElsFjyYi2m11aNswq8wdN3L7ARKo1diDXg3o
	 OyB3o+HJZ+tTQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
Date: Mon, 14 Sep 2026 07:23:18 -0700
Message-ID: <20260914142327.92510-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914142327.92510-1-sj@kernel.org>
References: <20260914142327.92510-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A1F9C0005
X-Stat-Signature: jswsg4k6ju7hznhbpe97o1178wwbmtsn
X-Rspam-User: 
X-HE-Tag: 1789395816-454146
X-HE-Meta: U2FsdGVkX1+axZs8TyvYtH8R0STEh9jEUOTLu5xu6fKXNHCNy7NyeNmI1fz3d+0u5KVUN2ydfhSlJWv9qAi3byPOUenZEC71VHhkia8OD0ipSyYvkWPuVISeE11tXhDCCUh9Y7pxv0I/sqDjvrHB+CIQfHktz4UthN32nsEoR6fem5sl7UjLqvNBOXMI5umakDkYU6dODzyG/pcDHni+OGJA+V1ULP/EPgdwzf2af3gyBe3/gqCnNyjENKio5avEGkWKskWN5mVcVRZEUSZyiRzESwxCnozIS8CEo7wEf3quSGCI99ZNh+wWizfUqN+LXS2MITgQSeiFc/bM4NtxQ8LqtFkxyWfzMVQdV2uGEO7oLqQ/wrM4jeMdrp6Dfd2ZpuRcvaUr7SQuQge9StvOrwq6hEQk+NkktMeC9dCf8mloAnf3ymxoazI9R7vcdWUW2VBR54QZLpNzWUbnK+UbofWJGHmsdy2V8ih3hAQZ7y1XqVJsDgkfT/2fg/74ZStnj6I6+oQqkIfCsMwXvlOIEetracGDop0a2qEsGHg7XhZ3iZwuPokP7C2kOgSXqKzM44JfDgptgp4TdL4+UUe7wX0IxY20oC8zJmSLjlMW03D1UoA1Wjl13qsPyW1XtuOeku77uz77lYAey09Hyjyb7nFHH0vR4pei7+6yq0pdOEsyMNEPiyDw/dq+3oIf7xdGd6Alj6Lyvtlp1wYwzCz6AzH0GU9aYDAtCwQkye8IIII/upqPmXzYm4Uzv45ySF24HKjtVvWAY4E6R5lMmsv4dV4GoKkT7FkItZw4JUaE9XlOkGhSUzMSB6QD/mrfdWPWWt4pdkjfoQ2jb5oMV/CZix0ceKBkt3P86YWJkM1a58ygZaS0UucK0VbqzB1dB+ZG8EwhiiU81he9sPjvzbZv5FDeokfTZNVmskYjuXrSfC68O2Z2/jmR7+bzmcDk34idqkSGIeAUyZaHFOICiU0
 jWZvV5Hn
 gZW5a7tRbQLhANPac64tse1Okzt1iwEjHC516VCij9mHM2jFQXQNjJnBP3GfBHTuda2M0EdH1U6df701H3XmwkS8ZD48pi4BeiMogkyz6uP/BuN2H6IA3iVulGgTwByhs3ckHzggw5vJ/YCkezPIzeP4C9QS88Xe14JA1F0ovJLllC1UqtMYYv7gIICcLaMJuWI0rGH+feU1vQ409feVjC1GZuDxyMVCRmfsj8QIUFZbQxqRmJ+xLmrLPsnXe8+XfB8rY26Is8/CdcstUZw83bVxUNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface reads the user-provided address range arguments
for addr type DAMOS filter twice.  Once for validation, and once again
for assignments to the variable that will be passed to the core
layer. If the user updates the argument in parallel, an invalid address
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid address range is not really invalid.  It just
works as having a weird address range.  No critical issues such as a
crash or a leak could happen.  And sane users ain't do such parallel
arguments update anyway.  If they do, such racy behavior is arguably
somewhat expected and deserved.  That said, there is no reason to keep
such races.

Fixes: 2f1abcfccd86 ("mm/damon/sysfs-schemes: support address range type DAMOS filter")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3de4d804e049f..3c1c1cb387fec 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2831,12 +2831,12 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 				return err;
 			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
-			if (sysfs_filter->addr_range.end <
-					sysfs_filter->addr_range.start) {
+			filter->addr_range = sysfs_filter->addr_range;
+			if (filter->addr_range.end <
+					filter->addr_range.start) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->addr_range = sysfs_filter->addr_range;
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-- 
2.47.3

