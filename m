Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705A8C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C9D6B00C0; Wed, 29 Jul 2026 10:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C376B00C1; Wed, 29 Jul 2026 10:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF1B6B00C2; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF5F86B00C0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B9E1806EE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:07 +0000 (UTC)
X-FDA: 85041980814.08.E222FCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A93D1100005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HpIvLMu0;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5RGW5tJfMQBefLVNsm8C6YsUWIxBGgWh+NafBLNk5T0=;
	b=VixZPYAgSZ3an36mbPjaQbqENkmRwv6QXC+9kLWs4EJ7BfsnSgQKxWd8kwZ5Bd8LuJgqB8
	EsZriTaiM1+eKa+2z1Lk6GUrCxA5x0XXungx8f1rQmBxIeVYGyDWlNDFfDxYGGRkY0Uxal
	Tyxj3VFRkAGhASavzESM3VglCbPnkxg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HpIvLMu0;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333785;
	b=YgN+VaBbycZUmQOVCLJVWvpTSV2v+I883KTr9YaWdN5g9n2hKI5/hsNpc0mhXSfDUhm18O
	rg9bD2dKZ1q7W/6nibwdztD70Z3xnPYWXEW+wyeykWKxv9OfmIiFZJTqD9LI6bawfF++fu
	W0OUu8Dt7IOoCPRu//CU9lVbMGKEmlA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 098D2440AC;
	Wed, 29 Jul 2026 14:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70501F00ADB;
	Wed, 29 Jul 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333784;
	bh=5RGW5tJfMQBefLVNsm8C6YsUWIxBGgWh+NafBLNk5T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpIvLMu06HaC3elJiA6elITNOECKamcFBJpfVoSh08FOPfmpxN8xc21ZD6A3Ahxu9
	 s7LS221fZuYRTuU+Q23Wr+SqKtC75632WqH/0WeHS+kLgzlxNBoTyKv+hM3g0CGqOk
	 f6Z0e0ubybTkVIV5NPIdVEDvhHrxXt41nuL5yA/OmzqOWYhPWUW4xfV0G4CyzXVk0U
	 OU+LYVwOGgm99t/yxvA4xNMnm7vcyK2kF8M8TAt5eObBZDzmKN7NODoVvIRl1vJ6rn
	 6wQkQJvqnBbyS4W6/YXDZqjOg4upSRFgCxRRdfiqUkieelrmRja9MOdjIw0GH3y7Ur
	 MTy7MpyEGP0Dw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 05/12] mm/damon/sysfs: remove probes number validation
Date: Wed, 29 Jul 2026 07:02:45 -0700
Message-ID: <20260729140253.87753-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A93D1100005
X-Stat-Signature: a8wt1wkqwj1spdkjooo747zwuyzuxd85
X-HE-Tag: 1785333785-694956
X-HE-Meta: U2FsdGVkX18Pk8iOAYyaYZRQqHFWe38ZoBuj3W4PvnyDQECvpTkDE8/ebZH/op34j6C4X8RjHlsqtjI/aNkT0jITfkVs61tD2AmjYPEyzxvb4obprZwJkN1hUbw9ZNfmvCJ2idGTHQIu7i2SmIq0J/U9iXaU3M8SWaw47HCz7cDPFw7JzHRLku6lYiw5u7tYJmyINeqEqRshaYdp/gr+XxEeW70YsdpDb4XjH0K3FXSUfqg9SG4VVcC+pjnTVEEwMCX5puIWXTQvpHWjJ5Ci7iKdKyQteI3vAbKJyBF0WhdfB8YBn2wdHJFviW9HvG9GNOgxmJoWyc/7xgvf7gn0JyNYH5GADV+VqmUzOo2gH8839GmxBAU1Jbe2VoRG40xXtt4+dVmuyKv6gxulMWLw+2VD98D9WizRwJyu3qTHy/9wqW0Mfe12Acrlyx8qX5CjQBOzUXJbz/MvW9jY15nuX1uQr3jHo2BUpTDpZZy31q3+H+m9QszBQ6vj3oqRYnxGWGxvnwElAH5o6Ad9NAleBvAQ+MpXWNo9uLu5aA7Puddylw3lCc2UmnTFI6XpBJll65II4MWm/Hkn4JOBf7VxCHQwJLkOTbV6iqd6iQacFYYBv0Ewm+Qw45DyR60Gu6Y8n05zafQ+MWmxncNRaW8/LS52MK30oYQ6V6Dg19oVtUgERcq0wFilJSt443s1oDqM8ZubeY0YR1pZGlU3WosGh/bEvf1e9G0Le09SU7hK7oQ+9ObGBPfuRdHAHhbN4/c4zUUmgdGO9MF9vZPOfQinSDym3o3NhvjpZY0S6zkteaPgt3FdeiivjrldA+nEirobxVlyyfejMz4VK+83pVUGG/zFIXd3QzoeTQkB/Atxb5ifi2l2vWwY3RI9a5WaVd52R2BbkncZmEyEM3Zt8ndfu5Nq7ITw++7t/UuHu0YyLLvB7hOON24Cfh2kK0WCXcP57Y+bCqZtTKTnA3rfA6W
 XA40mY+f
 W8hREWqWw2Q04xZLKveLrXjkcU5cOrhxSIOlnwitsza8coJAT/TUqiARDtpPHeOHNXQOtZY5XyfTvS4zwsiL0WNDTbEKI5lpHbbsvyJxH+ACWgCg+MBx7/l7DrUVvVTcYQOTCWKtjg29/izZjDgSpM5J+DrsLrvSu0xVKStLEErPozO4Rp8h4yWB6C2yWlaQzEn7VABPEOb2gb0DV/x8x6MKsWXjWQEZrKn6i9k1C/ZpgLqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface is disallowing >DAMON_MAX_PROBES nr_probes input,
since DAMON_MAX_PROBES is the upper limit of probes per DAMON context.
The core layer is validating the upper limit again, though.  It is
preferred to let DAMON API callers such as sysfs interface to set
parameters in flexible ways, and do parameters validation in the core
layer.  Drop the duplicated validation in the sysfs interface.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d02f5f8ceae5b..8abda69c98dd1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1477,7 +1477,7 @@ static ssize_t nr_probes_store(struct kobject *kobj,
 
 	if (err)
 		return err;
-	if (nr < 0 || nr > DAMON_MAX_PROBES)
+	if (nr < 0)
 		return -EINVAL;
 
 	probes = container_of(kobj, struct damon_sysfs_probes, kobj);
-- 
2.47.3

