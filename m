Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 707E8CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6349E6B00D0; Tue, 16 Jun 2026 17:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56FA96B00CD; Tue, 16 Jun 2026 17:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411246B00D0; Tue, 16 Jun 2026 17:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7C06B00CD
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:04:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEA71140162
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:06 +0000 (UTC)
X-FDA: 84886108692.12.62B6B25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 20F0EC0010
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iz25/H2i";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuaM4fRepF/o1XaIHUwvQhwbfg7Aj8WjTOuDU58kPoo=;
	b=hwBD0pnKcwxROzrpAsL6Mm7TUcRuL2fIiZVxfthRLQWCLT+/Ln8SiwwkWMZ/qXIKNTtzlH
	y8f0g9iNlsAehD65z6ZMAyuJLf+ggFleEpvPu08f5j3BcWukRB2IkQHh4MKZUfs+StiuXd
	yNSQ07/dBUwyM0npwECXoOkFU+4xYd0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iz25/H2i";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622545;
	b=e5yUPhZMfHkkw3AJ9YHSfGU0f5l8V7PLgIsQsSYetVafe5yGH6ZK18sJou4qpQMbxNh8PB
	CjYftGner6BEXU9WcnlvSgHQls8NOwsc9nzu5jZTLPLgKHicgKrN/ZutkG/JiaYjNomORL
	xZ/vObPKuYLWlkOFOqPEK9eks57zEwI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 761BD43D4F;
	Tue, 16 Jun 2026 15:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BF21F000E9;
	Tue, 16 Jun 2026 15:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622544;
	bh=FuaM4fRepF/o1XaIHUwvQhwbfg7Aj8WjTOuDU58kPoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iz25/H2iCs0QaO9SUmnaN62+yvDA8BVabum7KyzQ7hdbZARJVaxVPDcyCDTJtzOw9
	 MIfHWp2hmuQEvl9HlpFI7OVECkwljZGWy0cZR/r0ZRbKJKHChlHpr2Jvfb5leJBjp+
	 JS6LaqB3S05VZdQgN6LdhXb67dwYHSa2JkSr9/qC6ojLB0YrNTLt0mcFhXGCNybQlE
	 0r9XkkM5k3P60CoHfGmEoI3LZTXfBQ90TFisELBGZ8ybJtYpmww8gB8EqRHasDRpuJ
	 hUmZGIoPB8FdrQ9n4+Fotyb/2qW1AG6POOhljTnOZV6iNqal5RE4YCIG+5rJcS2geQ
	 Cca+mrV3a8SRw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 8 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/9] mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
Date: Tue, 16 Jun 2026 08:08:40 -0700
Message-ID: <20260616150844.88305-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: <20260616150844.88305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20F0EC0010
X-Stat-Signature: m8okp4ri97sz8mjwbq3bkbwjybpaiye7
X-HE-Tag: 1781622544-629072
X-HE-Meta: U2FsdGVkX18DbFeVi1xCTJn3Gk+2F7KD5POvJ//hzagl/42ykDnjurgPQ7uUr00JF6IWCK+Vi2u1DBpGkVpcLu0x+cYx5MNufz/MqnVc/iIBGztFr9MwqSkHZJzdzaHdfZHbn3QPXuC/edBn4fCt6kYZaGhFjo+C66yM7NAPI+BLq2htTfELzZ4cEdHdpU0g5O3PM8bAAGv8XLG4dPY2sZBAakC8FA4Hb0M+x1neWrLx4602rbDzJZ1KinIPYq2CiayJ4QawRy01LU+zZBAAA+WbDDqoIt/NFmRL8/vIqhf0PEO0xaeUjgx9cC5XovOu/x++WUxWPuf8Pal54RvSPiIcKI4JaqNw/2EA3T/db2CE9DsD3Orhakfrj6lw4PgPidPgiFRTUbIosfx58/jUvCwMQg0Gty2boHctXvTDkSQRvZgbiRBOMa8Fu1RLdz9UpcX2GUL94BfXOBSDq/e2UfmUjGNNXFPoUk8S0A8d7W+7FnPCQB/FKfR/bPuq+3uioMMl5namKJ8jiBj7RtdH7LjdQsqjYQlicyoBReV1KgIfxKxzQgPY8USNvVZ961NiN3JUUvI7eYlmbmWrlzQaFcu2mHqTETbDiOyuGMFy63JjXAqaHLa/VVTJaQdZWCGGJGYJzvjWG4W9muBDoqjyu70AEyvccC1gQqlGzjSiKWel9xQViYhiJu/lKDlkCkOK8k8sNaUpAURAmvynbV+w2U+6jmxPIPXPGNUnK2pPToi6MJ3uxnn7DROXk8+PAb6vIaD6VePiiojZb9/xXiFtz4241rxRPjDikwWjh/HbBPAsaQb9on7+JCGYsucv3BvpG+Us7dy9WIudLV1D/cbrXQioFu2/jMrfG0zUpY06MwokMmhzHnDDds3LNyI+8iG3tJOQlr6mbs6XPir7s9+0bbS3WKxYkJ2dzK4MUUDjVAdSHTHPSNIvHO1q+sbMJbk+n9p8n+ByjYVcmjPiv7a
 rAg9tGVU
 vx9Mg7UPEkaqh0CrzV0UewlDngSTGQ4QWoWqmfSP7xezk4Eggt26HaoNcLvANa/Xv2oZ3/cmc3cHOW+m6NhbmOPRPTOLT6kG0fMXt+hoX4lHL54WrQIxlRLNv+5Oqh+3/3yTFAaqUlMcPl1bFcDN/3OOaBTEzZpWcV9cKwtEj3Z9tKBcPj7FyqDLkVv09CMHUe/tAgQAWLRFBJGZhemG/ukDdNd62JyFrQCgTutHSml3akJ5v6iBO/aKBPzhkvY9p3HXthEeupumo3/rirXGfqBCAWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme quota goal directories by adding kobject_del()
calls.

Fixes: 7f262da0a30d ("mm/damon/sysfs-schemes: implement files for scheme quota goals setup")
Cc: <stable@vger.kernel.org> # 6.8.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 300930c2c5b3f..737638be84f15 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1465,8 +1465,10 @@ static void damos_sysfs_quota_goals_rm_dirs(
 	struct damos_sysfs_quota_goal **goals_arr = goals->goals_arr;
 	int i;
 
-	for (i = 0; i < goals->nr; i++)
+	for (i = 0; i < goals->nr; i++) {
+		kobject_del(&goals_arr[i]->kobj);
 		kobject_put(&goals_arr[i]->kobj);
+	}
 	goals->nr = 0;
 	kfree(goals_arr);
 	goals->goals_arr = NULL;
-- 
2.47.3

