Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC27606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mHm5HSyh
Received: by kanga.kvack.org (Postfix)
	id 3BCFC6B05D5; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395AB6B05D4; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E376B05D7; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDB4A6B05D4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69A22140482
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:42 +0000 (UTC)
X-FDA: 85446641364.15.EEDF846
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D29BEC0007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHm5HSyh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRVXEo9+L3IOL49loDwH1nSlcsh8gFIjIUafHWHgJ4s=;
	b=Ph9+nRn52TDOV7ofuDVbBOOjKFZrO/tVa8Yx1xb4nmkUOwxvHGzM1PkM+p6LSm2jm+iiVm
	tBJkTsLIq2Yf+AP7DH5kGgcl9jD82R5jAJaYBgB5lLsb5k0abx1h0DQFbuPINAH85qWkd+
	782lme94QoxCoJhzD0KDehG8X9JtGZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968560;
	b=ia/P7Ih7IplZ9wkqdtjdOBpLb2RPt4CK4t/IvqUIkFUdoCYn6k8iVk4rEyDy6Z+NcwVzLD
	hhX8mKCl7R8nwq+0nSfM5b5V20D+so7C7Ehlswf1AQ6ZgfX67pVZEjWqKEcB3FWYzWOREg
	Z3gtHvb4c34rkjSKau8zoiFSuoCG1+Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHm5HSyh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CA2761F49;
	Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9F71F000CD;
	Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968560;
	bh=sRVXEo9+L3IOL49loDwH1nSlcsh8gFIjIUafHWHgJ4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHm5HSyhwMzZkeCIUnHHrqzrm1dMW9NzjsNkGz1MfHu7Os/j7F2a6IijPEQhyTlOm
	 xq2/NQUTJcED1xyjylBhRvOLEjUjT8xlsJZPNQupGkM6bRD6ZumzdOmSR/agDKT5ir
	 PxaasSHU4ZioUrIdHecpcSQ0yVVxk53b+WAYrQvMrXLwTLpYJl9oALOy4jsF90v/Bz
	 WgXAp4/r4pMI++5vQpJGoPvQJ6TWg8OusPot+owUkISBW3ftjsqH/dfHznkhGAoWAs
	 J+C+RO4sy578Qe7uLTlIMw9C3wv8BcNK5TtZq5K/W3uec26P0+jSHvT0ZikWa7lAMY
	 hZIRnXkq7PsmQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 23/27] mm/damon/sysfs: implement submit command for report producer
Date: Tue, 17 Nov 2026 18:22:18 -0800
Message-ID: <20261118022225.100659-24-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D29BEC0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xyr8cti63769ti4iudn17aqwfujuooq7
X-Rspam-User: 
X-HE-Tag: 1794968560-427973
X-HE-Meta: U2FsdGVkX18BDdf68nxc66Q8gZIqQvc1/KiFR+eagg4aUzVVVKmrKuDdORUBiBOLknEigdIHq2D9tCLSVmZSh4H+e0/O4+rRBCF7mArKVUdbfHitcvdmQ+X/I5pIQJTJBLRysxHxPNjqFuDC3XMIPodPZHFX8uiZ5Dyes+8EByR2d+xnMVgmiJNhysXOmPqHeaQfUg51Zf+C06xLH+l5czsOGbobUnlW3U8aofh1oYEJ2sQWlCnuAscPm7j9Uo/plyXsL7iimwRSWd3OrylaR7m0DLpYPCFgDNGWfJ+sR8PxIcaskH+514cHbGmyY9PrDWL1t/2OLQS6qCZaMV/AOxts74ic8cJlQ2d7BPxTKWodSf1lJEbyvzq+rfxHliTSBTdVFiXztuGnVPFrvaoM0f1ymHmyBDE25GxbZeVQTJuMne/W3yoVAjZqDBCWP+kf+n01JCSUzgMqz3c51PsZmyvMRgyu7tD4e0E2mkat/RjbBTHdaLDuNW+Hd1kVDHw6ZcLa1oyjrhulGhrZY5HwhrR45yQvhL0yxqljGFUGvYumjphcCukHXVPiyWckrVoXKV1FYkmlQ0sqa4hiU1qIATa8cFm3ZT1/oje47MHVgHvBiOEE7Yv98xOjiWvngRIIly3dL6hS/x5M02n6MYT1pGqJ+0LrtkQnbRT8lHFRe6McUP5B0X6cxgWa+aGjfNB6cifGDLuyeYXnO7uU4knd/9QOCiglNw9gIQx1BwCpPaUTiFIAE9DzN0dkYv4VgZLY6+Rf+pNQU7AEH6wRosaIuhzN6C2pWw9dEPnhi/LNj3X9iG4CZ4DPEmwEDgE5GyiVfUR35lp3bFjL9sPzAvsEgb6gj0TFu32r9f/zKnB65OoF2dTiC2Izv3/l7n9jNwUhqSaPM3ek2ORv7Ew6ZkHAjNyQeC0DBckHUSqLAnSjDPciCOylySWZe1h8rFcsscBnjUZIKK+Qc1cWSW/QfJA
 NziQ7REh
 3siG+FbQ0ZOx8/GKQ+3z58iUdmz0ZkV4SzxEmehLUsj1KKBQcVfvG/6GFodGQaXcLZ+oGiqlwoDYaRvvmED52YUZIuuj/NrqzH5AbsbUS9/i5n1aJ0yxJdxvQ8NIhrNvOpBg7Y3cbo/qM3SEsAPka9V9KxS3x+DKI5bZ8C0Qlr+i5c3PUA7ojZmZJOWXzjC6qmZM7aFqGdcfsrF8YzuDBJ9UfgEFuaUccvcTH9PJpBYLOCvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Let users manually submit a report of a data attribute for a given
address range of memory.  Let producer_state receive "submit" input for
that.  For the input, generate the report based on user inputs that are
written to the appropriate sysfs files and submit to DAMON using the
core API, damon_submit_report().

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5f9bb1955dfd5..0049aac6ab974 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -3107,13 +3107,26 @@ static ssize_t producer_state_store(struct kobject *kobj,
 {
 	struct damon_sysfs_producer *producer = container_of(kobj,
 			struct damon_sysfs_producer, kobj);
+	struct damon_report report;
+	int err;
 
-	if (sysfs_streq(buf, "on"))
+	if (sysfs_streq(buf, "on")) {
 		producer->enabled = true;
-	else if (sysfs_streq(buf, "off"))
+	} else if (sysfs_streq(buf, "off")) {
 		producer->enabled = false;
-	else
+	} else if (sysfs_streq(buf, "submit")) {
+		if (!producer->enabled)
+			return -EINVAL;
+		if (producer->report_type != DAMON_REPORT_TYPE_USER_REPORT)
+			return -EINVAL;
+		report.type = DAMON_REPORT_TYPE_USER_REPORT;
+		report.addr_range = producer->addr_range;
+		err = damon_submit_report(&report);
+		if (err)
+			return err;
+	} else {
 		return -EINVAL;
+	}
 	return count;
 }
 
-- 
2.47.3

