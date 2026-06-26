Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA46CDE00C
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D9D6B00EE; Thu, 25 Jun 2026 20:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5806B00F0; Thu, 25 Jun 2026 20:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410956B00F1; Thu, 25 Jun 2026 20:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 176526B00EE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E1BA1C219D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:16 +0000 (UTC)
X-FDA: 84920149272.07.05C3118
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 06635100009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lWfA4IyA;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433035;
	b=s/fAV9GdaW84s88M1ju23vlItZMQct1STuTdG9QzeEcEsvZzVUGUSJ6L3GwCunAYJuNtqc
	IkKhWOh/z3d/2vxEukQ1+0c/nVBc8XxAGEoP+CSxpekZO7Ek213AKHmzH8jjVhpNKFe2fU
	pDXQj8wc2mLuZbgFfiVVdwP2GbyyyqA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QU3Mdz0QWuS68FFe2kfHvyIPhX+22pphhD8CNUTJFTE=;
	b=viKqMDFJV6OopiybA2qt3LHDX+OlsYe3hkDclQNBcwGJpcX05EM/6g99JGE8BQoYcbQyHp
	PLeJgIiu8aB/BHlz88sC+m0w4VYfyQRI/HvmUwsBx9aDMVKrhggADH9ZHTy/9oOCoKUS7X
	jhePDaEn5M26RK1tats7Wx9za3OjEvs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lWfA4IyA;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9734960137;
	Fri, 26 Jun 2026 00:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71161F00A3E;
	Fri, 26 Jun 2026 00:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433034;
	bh=QU3Mdz0QWuS68FFe2kfHvyIPhX+22pphhD8CNUTJFTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWfA4IyAJHopNKP4vyAHu4NTSxCRpcoIH3gthHc/XsYcOwP2k7nthFA3+VRavn4YC
	 tTuZyNhmSS5YCVxT0FTJqIZRDlECUigr2l+TNyE44ic2mMg4KE82KvAahbeUTE/A4y
	 JIszmYeyNnVmG4D5c/nm0Zuq5p/EJ01eWSDD6Nv9CQDF2g0zGxQSIVOwzdmqr3qw5t
	 vVJiDsuPZhN6riI7oNqnA3yi6RMKhWYg3LGW/2VL4KTLD+12I6BV1nO0/prPyFEH5i
	 06gzK3ZtwHtKriUr3AehVMx/Nun63DfMuOZA3MrZh5TAbq6PoNI+Orre8Cii1X1U7q
	 g/+3BODmNIzsQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 10/11] mm/damon/sysfs: split out filters setup function
Date: Thu, 25 Jun 2026 17:16:41 -0700
Message-ID: <20260626001644.85825-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 06635100009
X-Rspam-User: 
X-Stat-Signature: zn3rbsgi65nm3mkp9j9pm6xtbwsgjxdo
X-HE-Tag: 1782433034-655090
X-HE-Meta: U2FsdGVkX191+35BDi0JPlrffwotWOZVLCtOjqG4DB8ZoTMDPcI0fsbIoB23EPyk3Kpz7x59/rXWRdOKyxguNCvvpU/juZfX9FNPsSbYv0bnqyj/EyxcDKQk5mnHZSl9dbj72FtMzdT4JP655pF4sA6oyJQVAcbcirmIUHr6KpZviBEf9Rr0g1M8ystDP5DOpFFf6NckOV7SwlXtJM3NEjvgQeIRKqgKQQ2rsxyzhyYsR+1i+tC2XhnJu0U4kHSMycw7SQ2vrdXJOtP7toEJyoi4LWytOuSYEfOEPQNmtRz/cgUJTAph6EqE/rT+gQKTEmHdU1SOEN4x4c4QDtjKnwG/ge28dixkd0CVUMpyBQDwOS7Nixq3INiZ4rJ/ymBIhhmqbKhX8OW3MIPDTZdUplqFS5OXgGQrTatLFtmg++kNv7YdNBXvmEVGj/EKRN3pXz+wxDMDefyx8Gu8KrSXmlnUkv9blf3MohZVCEViAgwC0HzQwyRWs+umVjobPWeWW7kkaVeiQ2hxOy1cK9NF941/Taz0yM0IIFYS+7q0bfqFsSYAwrOlPDQc0HKj2UwOi0Fkrs6xiqlEw9OqSwl0DmerSUf+e50rhj5VM1/g8gvsc//HRjZwvSKmg0zCHYLz778LIvADYDTzDNlf18FyhquMSbQa6DBlkwYNk1itVIGDA2adFZ/WHqaKGP+neLgKPeLObuTzz28PFCD2gBbQ6wnBu+1srw3nSztTO7PE2kU3ZNe5BIxcpSMipqguUn9k8VvfmQLwhXadMHDFFLiEGVDw+sEu1u6tRxMBYoHOCxBlhkJxh81d9O6k8mXxsgWKxvsDcDNrvDPy31OSaWxzl9qVmqq9F/Z+vFvfWCypNWWdnQjkA3XQwclEkmfJNJrv9txlADbajwcFMtETiWputGgtEG95vR88lWUkWERXMXpZ9ygYFUk88h+VFebQEkBEKBnyaWISPNRG3iMpQrY
 o8gQoyx2
 F8cDsYpg6VVFC2WOJVyvRux5KCHwjsOdSam6DG0fQFQ19WFrok1g1wt+++Jf8piFqXaBRzYRvSv5QuljhQtGJyqOfVRXsmovqqVQimGF5U2FZVZxUv/bYXW1mxM4HaAjj8EBsCt2CdVBjSvI2/a/WLT/SUL864RyAy1EkEE/d3bxWcACyv0eJnJCdEOx1VUtxQF5TKIEAkzCOG31hYaNeDf3ksYKeqjSJXGXDZqELh0FKEO8oSbna3IES8+PmY/WvnDLMwj4ZxFAFl6sWt5pLYCQp75z/P0BFheMmFhg5pSh901vj9ANZ/9RB4DXo/lN5uipa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_set_probe() is doing not only probe setup but also filters
setup.  Split out filters setup for readability.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 982d824f63c21..f3bb146b204df 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1899,16 +1899,11 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
-static int damon_sysfs_set_probe(struct damon_probe *probe,
-		struct damon_sysfs_probe *sys_probe)
+static int damon_sysfs_set_filters(struct damon_probe *probe,
+		struct damon_sysfs_filters *sys_filters)
 {
-	struct damon_sysfs_filters *sys_filters;
 	int i;
 
-	sys_filters = sys_probe->filters;
-	if (!sys_filters)
-		return 0;
-
 	for (i = 0; i < sys_filters->nr; i++) {
 		struct damon_sysfs_filter *sys_filter =
 			sys_filters->filters_arr[i];
@@ -1935,6 +1930,17 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 	return 0;
 }
 
+static int damon_sysfs_set_probe(struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe)
+{
+	struct damon_sysfs_filters *sys_filters;
+
+	sys_filters = sys_probe->filters;
+	if (!sys_filters)
+		return 0;
+	return damon_sysfs_set_filters(probe, sys_filters);
+}
+
 static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 		struct damon_sysfs_probes *sys_probes)
 {
-- 
2.47.3

