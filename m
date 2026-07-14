Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07650C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABB56B0092; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF006B008A; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C584F6B0095; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91CC36B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16A22140233
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
X-FDA: 84986116572.23.96412E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 78EB340003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUYkN1dy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BZxDJkFvulRjFQmRcUYV8xQhtaa1R3auddZnH6jsbQ=;
	b=ux3tWeRV3USr0YPsYBz6vqUuGXd81YVkwD1BgVXVGi+ZymboAakKarIaJYIZIFPq5fqFYu
	HyhvhpCkI1dlE/6R585VF9v5e2gABymLH7LuTlTzXfLW1PoFJ219hLFQNZ5hGxmVxGS48b
	cKy3MnCMVyPRczJGgEj2nwiUu2kMMQE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUYkN1dy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003684;
	b=cBYSAaujQpozDBkOjt2y9va3bhOr0fOHsoyriBjEA+Em8FbvcqmI9rFDgMpy/OcYVYtr68
	95cSVm5A+bMCPBURBEXGthSVNlr1egKqICAz8bBsoDpKHiZk8BFfYPleaKc+f9tfBldVzk
	IbdHZgWG4TvbUe3vMb+0bkHSUUIA8Jg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 924E9439F2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D2E1F00A3F;
	Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003683;
	bh=0BZxDJkFvulRjFQmRcUYV8xQhtaa1R3auddZnH6jsbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUYkN1dyAZZVX7GlyawUhpPuUYcxjJtD7mNDEzExlsgDd4Lzuh00cSJ+ITsVT/eQB
	 6jPW6zrcsJ4xnAnhUlxGkI7jSZDm2eJNk6T8EGMom1fxQMpKMfjFUlbThFWHc+yC2k
	 ybl+0eRpOf/YZhEAcqPsXgjhXqYP1Yk65xjc3ThZElPr1qw8ZoJod2ngN2laAtKNWe
	 GaiX450u37uI+T8dCKsgQjKQ4G1oZAjlFQygK57rOODlYtwlPSTJeOuhVYrDpeViab
	 QsqEzegoO8dlsrEVtXuTO4jsBiDMCdpoh9IZvZImOzpVEe7wrrylv5e83j5BEkHayz
	 VYoy9D59OoWHg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/10] mm/damon/core: hide private damos_quota_goal fields
Date: Mon, 13 Jul 2026 21:34:29 -0700
Message-ID: <20260714043437.95811-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4rg35mtmkk9yptaou5cynyfyk6anyrya
X-Rspamd-Queue-Id: 78EB340003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784003684-428725
X-HE-Meta: U2FsdGVkX1/HObFD7zPUDrhG+3CEHdTVv6eY2sRsiT/ZNBhXtNVMDCz/64ik7M50u7Nm7wyNiyBCizu7Ga8gPeQ5611Qqbc2m5pBF4WS/Or9QzXv/3tx2fJUVfiv571Mxuy4vAv+xpzMrNqzRKTfHH4qAFRzqJxqWCZZTUmeisDGP8b4hA7RT3w+Xx4VeN9ANth6cx04bQEQKfsLzIfrMomqTdlTB9/l0uq5dvhv9A0JknSO7lTRBXDeXAFecIY2O+pv206M4zz6+i1z1QN+tHoFSS6rEGKrBNzmj0sS63perNpfm9noBYyvEIisZ7NdTbqjzsqQzZa+w8cYSdLqRunzP1sZi4O9hn8CJKEOy5RKznlkKDivNwpzBEeDcsI+1XHtNHL2kDecg1UjNVzPbiNPiUSi1w/fTbVenXw8fzgf98LXwE29+oQYJTvO8d2LgimF6L+5jmCz8P29D5gPH1G3TkFjt8BCxDOAOpcw8ieN31IvHiEcDW5ufPcEeWYHxrLjAcesiuzHylW5x03GgYPN1ZnxbxKs4sUG92eQXxHTYFPBTLqPXA3fcv2OxviI8eQESpIq2EiHKxkhBRKMScgqCcTZrmDGdpHlgAsl0suCxFZPpAESlVoErsw1YDdarfc8QWssJ2f/mRFBhVuD0OEZXKGoReXEZQ66+PyNNN3j6uTAOCTHxs/Z1BG7LbIB3oTNTR9i+jKjShTSNrvH6C/wu/OxyuAxi0fUzuwP4xQpVVMRSyWZ6RKjoDRNq7j/DwMmigg/KP3GnGgFn4aVJ2S9NRShe+RxOQMQtil58FgRglFt77qT6X5UDGT815DchnKhj9hw8t25rlgw5hsWWoGZBV7htPevsItHfehFFMxADuVIXgd6bTztr+z5f9CW1WfAIRLcXIB/x9Goj7k9L9BjDJk04rDxPfsJ8jfwcx/IYA9MtZKCdDqmggqLERWdoafo8hEaWP9LF01KbnE
 UrxMmZdi
 yyLy3CPANiazuT+28L96h44BWWm1pS27VSr6NUpj9PdokgX8arc+tHkxoDT1a1Iz19TCt/JgjSQdq7x8wwmLxsKJFuC1OeoMn7XreGZKQJ5BPYGelbAZ2O38Ke/oqSJ1LsDhfKaFSJFQpo0SqUq7B8m+gBZOkfcRPwRn/IFpUTwsk3gz13Do5olXUl1T6BvKdQTGdZsqjpS1K4t5gBRUEVnZbaffDXWJBLjHM1uV8H784hZ0+uJrnjfaImrCxvZOrMOZehuVtP/MaLKGWy69hcyvvBb5KOF1BO12tuj/FJKzg4olEgyExstDftJee3iD3vmuYqEknoBsrZ8Hi2yGpw+R2ITiwhvOrkq09
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'last_psi_total' and 'list' of damos_quota_goal are intended to be used
by only the DAMON core layer.  Those are mistakenly not marked as
private, though.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6e160557a0014..d838cc27ee72a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -175,10 +175,8 @@ enum damos_quota_goal_metric {
  * @metric:		Metric to be used for representing the goal.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
- * @last_psi_total:	Last measured total PSI
  * @nid:		Node id.
  * @memcg_id:		Memcg id.
- * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.  The
  * score is calculated by how close @current_value and @target_value are.  Then
@@ -201,12 +199,17 @@ struct damos_quota_goal {
 	unsigned long current_value;
 	/* metric-dependent fields */
 	union {
-		u64 last_psi_total;
 		struct {
 			int nid;
 			u64 memcg_id;
 		};
+/* private: */
+		/* Last measured total PSI */
+		u64 last_psi_total;
+
 	};
+/* private: */
+	/* List head for siblings. */
 	struct list_head list;
 };
 
-- 
2.47.3

