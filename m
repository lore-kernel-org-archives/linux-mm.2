Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBBDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1654F6B008A; Tue, 14 Jul 2026 00:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3216B008C; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BA86B0092; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 999DA6B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D8381A0291
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
X-FDA: 84986116572.21.6BC4EB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B96FC0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nP6v27zd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wUP+A3V/Raa3GTzyt1oBi5Pi6+PUzbHoN/8enGeFJg=;
	b=7r652a3FojC6c5glQYnUwNU6DlSPgGUXk1CDuZbOU4QXbt31VDBUDEgcbsIttpELzfPh8b
	si6L86T0FHp5OZ+s76znXKBuxCx0RIK8iGqlMD0GS3scHbsitSUfJpOE7Mn2RXfMzTJQ3u
	dMNeyenUGj4f8nO5UEmvNGQ2iVadp4Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nP6v27zd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003684;
	b=PmT/S1GH6guwLof3nS2B57/EGyRy4zbms+bhv80beznhN9WxoLYvDZA6i1EKynizQy7g85
	HDC5zuKfa/2zH4Sx5D8x+HG9eUTrw8zBi+ar6FcrKqNJS5qD0Ezm4+MnaZjsPx108Xb5fQ
	EXNagqXoz1Y1ZKs4jSaUT/Vp0oqQjk0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49FE34073D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A951F00A3D;
	Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003683;
	bh=3wUP+A3V/Raa3GTzyt1oBi5Pi6+PUzbHoN/8enGeFJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nP6v27zd4aZIjybbP2COmXtRqP64OzGCediBE5NcFQI8GuA0zz1gNkaynT70/+zZk
	 yM+YIwnMmbkXKyTYLa0jGcOWwSzO6VuBYhrE3QZ/lHkw/w8SkMOme1mrQG4WpPLEEZ
	 Ad4GcPivWRMb3xXEXLWv5ahPmUJEBpH5ttpSp9s/LLZMW5HyqGzYkOcU2/jem0emEC
	 Hm9+poQXtUCUeZkviaPqjtr9ZHdHqc0GFWwu44Qdc9aqZOxpkkvgepa64ezz8nHjsF
	 4cv8fzPDSCneTLC+RaCJLT9e2tqMg4o3r0+BWRbNsxavDweTgBtn0dYb6ro2E6GufB
	 8EPNdi2OXrOzA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/10] mm/damon/core: hide private damon_target fields
Date: Mon, 13 Jul 2026 21:34:28 -0700
Message-ID: <20260714043437.95811-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7B96FC0004
X-Stat-Signature: tc31se4womxz6obja5ejacq91pndig9s
X-HE-Tag: 1784003684-412678
X-HE-Meta: U2FsdGVkX18GciyhCVaa0whRP6FEONmC49rZGcEKYZ0dg+g21BUrTMem1iwQdhiuX6edpLIX1P65dyv4ucnp7gobcop3zf90nX/sZADqSOljGgMMA3LcTMf7O3xvFrIaBi2ydQXtroE3BJU8KrEhHM59NqNkOB5BpLa2fNRAny3SH4yTpU2zZHfRSxEmVwN1V1rsVm4tBCE6efWIDd056IXzDKkuTZpdBL7IPH7HSMz5aaCNKfQhZL6tg2L6zX+e6OO2FnmFZcOICW7qV8NOPptZfdVT7OOYS6u4N/7l6Js3V3wKEYxFzmSCLI44Xzgqe9nUSzGI0/OhJ4cjV+ntbQ9CNc6kKw3oqzbBeS7cpWwewno3GqdrOVtEOYvBx1QyyOMYMTvTSK0lExZ3/EUl8ha787bxVofiDe9gP6zqXkQeBARLb08Ef8Dg8KmfStLGtDN0bEDAr0hkInm0SHEsK6Cqm7/zClhkYyKsQKzRCb2DKswhxo3ATmVmHmeLVYEGzvbMbWm+mjsuGKr3snCJwTbOKIi/2usa87N8ddtUQUw5uYTU+e6vRr/GTzrN6gx7hNZXSOIWj3KH45IF35I0wKyUzDYDz/gkJeN/Vhe7KujQt2QzKCFP0VGz70ApNI01z2FRRxjdcrqzxqeUumcPePhB3DR26CpqbCYWA5/6oLdYl2xDtgL3fM17OgXluFTTqvMnGcScY5UQkzjp8+8BMELFAV2tg1dzJNOzrM9dN/IZmtuvPqB9V6YfQyfnflffKYaL6vifL0OOWXwYuViKviG+pUq+GM10rUCpmptYQ1gyXclaWM3F/RZ1ztii9JZVz92YUzub9D1Ud9NS54QUUYuDUDApVf3Z6o/S4JnJJXWz7xGnFOYmtfO5tcfZTKnZd0CERpxFvJqQ2hQSuQF2FxOEDTudNKcxUDh7NuyPmHixeMOtKuXHY+IkcHHfcgGUuwax/HKwBRccH9oA9zw
 1pLBp9aU
 oRf7MprAoPWFIQlqDieJxyivpNmkOE2zebX/7QsrPzM60RCpJXFkyWkqLv+HZhmoD8gq5s8Hn0xokcFeKzah2FbtwMejmR0XIlUcX6TPw3YjCX6r/eERxA9wNs2/NIkbyTtCzQfngb0ksa2fRK4ZFplwidVC9dlUNIWrAOi4bQmUqM6YE3AkNKIAb83xHtgY5FTF6yzmFwilRToV8NGZ2gjtDeOla4MWAtsoL6cG5mYwkr8xBBu8xp2DuBRXtRO/jBhxnbaOlh8hUUy2ReQQDq5Tz4BwBSdnwWaq9+Dnjf85zwpBXsZ7gHc6NT4CJDG4fPW6k8pBbPBguq2TT8hs+DxmTd8oB1nmg3WpL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'nr_regions', 'regions_list' and 'list' fields of damon_target are
intended to be used by only the DAMON core layer.  Those are mistakenly
not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d32377e7e535e..6e160557a0014 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -79,9 +79,6 @@ struct damon_region {
 /**
  * struct damon_target - Represents a monitoring target.
  * @pid:		The PID of the virtual address space to monitor.
- * @nr_regions:		Number of monitoring target regions of this target.
- * @regions_list:	Head of the monitoring target regions of this target.
- * @list:		List head for siblings.
  * @obsolete:		Whether the commit destination target is obsolete.
  *
  * Each monitoring context could have multiple targets.  For example, a context
@@ -95,10 +92,14 @@ struct damon_region {
  */
 struct damon_target {
 	struct pid *pid;
+	bool obsolete;
+/* private: */
+	/* Number of monitoring target regions of this target. */
 	unsigned int nr_regions;
+	/* Head of the monitoring target regions of this target. */
 	struct list_head regions_list;
+	/* List head for siblings. */
 	struct list_head list;
-	bool obsolete;
 };
 
 /**
-- 
2.47.3

