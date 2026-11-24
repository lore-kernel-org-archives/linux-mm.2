Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F052C606A334
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XifgZw4K
Received: by kanga.kvack.org (Postfix)
	id 165E56B077D; Tue, 24 Nov 2026 10:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1186B077F; Tue, 24 Nov 2026 10:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0042C6B0780; Tue, 24 Nov 2026 10:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D56266B077D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE304C0BE0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:02 +0000 (UTC)
X-FDA: 85470415884.29.1B74416
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 31B0B10000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XifgZw4K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534621;
	b=WG28Jcnjx5b4K8tJlocPMY6l1fsxWkaFAtRkTpC3aVzNxpFsZaoqfXiwl56hQI/KF9m3bu
	M9nngyXj++3hIJE6zUqmSFF1BoVqDrQtGEBwfvZ5VjCZ0M4cYd/JD9o7Sy+8P4vg8XCoTb
	AIArQiz7jtwo2/aqjZmY/DROA1PW1JY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwM0hoSsHT9C48OUdxiBZkgJJZRUAwe5QIB5lFSfI7o=;
	b=VYWtYJoGhIeCsIAEO8kd7/2R7DBO+xgekIC6vPaOirLo1af6E2W/1HaGlqpjkUwHcWMyLI
	No0VtL2v2jtq6r6Bpv1mlSqApQg9kIte1hxcU5HUNbxqX1GVlBf6S6MJTMmAjtQ3iWAXwy
	ffjkhXGFbJkddIfhP/HNDNe6nPyE8zw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XifgZw4K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD23961D1C;
	Tue, 24 Nov 2026 15:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D601F000C6;
	Tue, 24 Nov 2026 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534620;
	bh=mwM0hoSsHT9C48OUdxiBZkgJJZRUAwe5QIB5lFSfI7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XifgZw4K2tnSB/k/ZxBPba0Bem9Q5u82Oyskw/SdLDwtQx2MC8e23t9Y+6MwxroGD
	 QJvV8SZ8Z0TK+l/OSdiMfvaGbEybya70MuTl6SKZsW/9Ef8AyThrP+6Pq6nRyLLZc+
	 mYAIa1c0CBkOZ1ahJJfaDotKdTNaaCxAw6IANvZ7F8sfQx7MddyPFejQzH1UJ1eTYV
	 90LLRkVwfNW93bzDg+5LGQY3tRPMjbfKYoB+DNnz1m8+XyXYFolaz+/I1jiB76csLr
	 STR75yJ3pxKanX9tWCrO9arns0bFBLQ3czeI1/r6DkLTFLaEuZydr6HsI/zD4520tH
	 H6wqgey1ONc3Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 21/27] mm/damon/sysfs: add user_report support for report type input
Date: Tue, 24 Nov 2026 07:36:27 -0800
Message-ID: <20261124153636.91854-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: t3h439uwfmy8b7fzt6fwdzykiuwdanqf
X-Rspamd-Queue-Id: 31B0B10000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534621-308119
X-HE-Meta: U2FsdGVkX19qlYOG2F1fkLfkSXrO8sQm40OnXRGSRgB7BzQIAZEi914o4dFQvyygtY6+uzdnXojdSlUS8i+xyWETLd4HIQDoFrOnvtOvtdIheuez2hEkdK/1T7mgjr8RtbKY8T9GyXo1t0W3rGIrtjdAKMqKJCsj3Z3eE4PeZe9J38lC7DP/QdLjYunngGFX+bIprPYNy/kE1B2xPBA6fS66gU4YtYTiGvmn8LXMTJlejY3WPhfX8LMEtyWCH5SaEH6s8OI+O972LL9LUJ6JGcTPoEVKnYieigFtYFwT0yvWYuxGZJ6W4VM64KsEXHnk1UVtp55MmNrJLx5qRPhpGxOvnvhsJQd0xq9tIkk1bEgVCwCj/dPQIJonuOnF+cX4XUNKSSEmt0xwYVqvK1g5jJCwXGVYyiTaLeYqpYwj5quTPi5WmCSu06JxBMxDXZwKI5njHAIzfvd9w1QD/Ams4lQo/XK/cKX4qPX73d4EUsZd+yAlxTf2i2zhmJ5xqydMtq4ew5B8ppTAJf9wLmv5fGlFnYHIoIdQfwyvihjtktMaAGoQNUdRPJhleTDXLJXrKVufzv1JcazM9/uGU7pUX0ifbyeoO/kpP4lnSH+TKPHOzXXU/8i88G+CbQ1iT7RiYW8COtKnFloYhJQ6iErq/TuSDlTPPKqFo82HjxZF2OlM8cDN6WD8eCd8SW5ia+kHCZUUERQyMF0JR4qmv711I50gfePBVZWnzy8kXq6HX5IKW0tN5KtohhbGcRGAVeqnqnWoHAYgBHbJgHv7LVCNnmr5MKTRz8z1k9cARIcOVe1TbEkOgTGGfAunrtUIMrJtDqtGKlw+IDxRVjPSDYGsMHpa9mmlXwQCPYauWDL7QZCwTliy1K1zIySgwq490c7prgPgqhgKTmYURtD74/9zDqnTGWjCZtqKWChjqTr+f9lHUtgqjAhcTmKNDAb9E0er40n/sIIY9DmD47Ifnzu
 HYgvmyMC
 5y5HgWegP5vMZjsXtvWm7gow63eFHKunkb7gMIGMmqGObCmlCblCsdRA/TUJ4b4GeaORnWTewIw3WgYXFkPma0r48uZnCNCmMZoRywxNsD1DVvJtLQSVM3fDOEKSDBIBMG0RWWo2DX2KJgXiqeUF0ESWjNmkaaa8rHt6ZnYcww7trg+Ofob0DqyR9BMo6ntxP+uTmGgYXc80J6NyyQihfm5pRlM9oyN03PxhQ4/Xbo6LhyOL+yJVEeSu4v32sJnsm0Srw/zbR4e2k3S59rzcTeVig68tYmrvBsceBHHI8QYCOoH+11FWSh1Cgu/P6D0ZBNdVras/+Lop8xhPw7LL0uhwRKNXH8qnntlajxj/pqlpPhW53ZRmhhPWyfOLhFbaMu0WsJ6DHsbtS3fC/ExQe8+vXucWPVYJyeli5fW/KPe8LFwpuHsLpYrh7iaKBYa8NkZhDj8/LUB1NdV7T0hwhEM/i3mcVmXtQJ7oK8gvB1SFmdAVlmvq/Q7uLtsSrb89qwoO0UlWlEXDFd7DhOtFH1rrRVjctek42fYXVnDbdDIvci4lNPvuxgKvR/5KYojG4l8/LEcb8QmVDmv8P4w1Gn2J9N2weJCFmXA1S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend the mapping list for data attribute report types and user
keywords, for the USER_REPORT report type.  Use "user_report" as the
matching user keyword.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1c171af4590a8..b4d898ec0c9f7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1187,6 +1187,10 @@ struct damon_sysfs_report_type_name {
 
 static const struct damon_sysfs_report_type_name
 damon_sysfs_report_type_names[] = {
+	{
+		.type = DAMON_REPORT_TYPE_USER_REPORT,
+		.name = "user_report",
+	},
 };
 
 static ssize_t filter_report_type_show(struct kobject *kobj,
-- 
2.47.3

