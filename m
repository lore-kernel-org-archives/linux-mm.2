Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1FDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E336B00B8; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FECD6B00BA; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C65F6B00B9; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C92496B00B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DCA4140342
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:33 +0000 (UTC)
X-FDA: 84935247306.08.EAD2FBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 93BB140007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjQF8ufS;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792511;
	b=Kq/Trw7ixTgwz5CINUXqGLiOtlLbX+UOiAeLvsNHB09Q8Cf5lsTcjrukqQemhksQ8Y6JCO
	VT+IAM/abauWCMSlDTG9v85R+X/l/KRkZJREifBe4HcGBYgKd3N7RnvERs+gR5vfiCU6Qx
	lfl+H7oPIOITfAX6skUxxBpj5AEjqBo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCxqSNOS7n5QD0XpLwrveJ2jBbzhv9XH4+TY6qd4Yow=;
	b=b6scCf3CQ3xPZ0lFVp6CyHQFicNX/pOGtckLp8k1xtP7T/HLCnDFIl2XlcVS+/WZcgot5g
	07o6OLZtLocNakuRpgkWB9SPi2SyUqLsftwBZvt8ie4AjfGiukQi0ON1YqZIzpnhGMO0dI
	rDk3tj63AR94eYPuM/oBH+1kXN4xLIQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjQF8ufS;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A19DD43D3B;
	Tue, 30 Jun 2026 04:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F6B1F00A3F;
	Tue, 30 Jun 2026 04:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792510;
	bh=dCxqSNOS7n5QD0XpLwrveJ2jBbzhv9XH4+TY6qd4Yow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjQF8ufSGzW7qQlvHhiNC5FEcXN9VWApYrmYeEtq78sza2tW/bDo577WS/tZkzHc+
	 OagxGU6rObBbB0AlOjvKdAQXjv7dKUHS3uv+xXTWFY/QJSfN68v05VtuI3wSLQmD6/
	 AN1QYpWIsDOvVY2IQD6sJeoi3FhBzDhmzdf877VLMFUWWoacu1NuMfnq/11o54DD6a
	 4N9KYeEuDyjDVvMMK8tn0VQs8cpCSg68yqcxnTSoFMqdvevlAA6C8p/DBjYT0OL2b9
	 BuABzjkyxu/42uUi8il6TezFzEcDdPl8JQM4Ot86N8KTEwhRjJWsds+3Ad2T8ZT4q4
	 1pdauFcttXG7w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 14/18] mm/damon/core: remove attrs param from damon_update_region_access_rate()
Date: Mon, 29 Jun 2026 21:08:07 -0700
Message-ID: <20260630040812.149729-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ac6sffpg4jzdo1xzpqc1mkkieb5z6ztb
X-Rspamd-Queue-Id: 93BB140007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782792511-878567
X-HE-Meta: U2FsdGVkX1/2lp13Nrso5GRVFTVXWzybj3GQr12NX0b8RUrxP9YSa2rMZdXYMTpkyA87Oy5eQ9STFz9IBEuWirpfBM7bUdiU61+88N1R8X73Hms2ELb3A0zXhE9y6aDI9eFYrC6tExpgwxZNCPKPwJ8KjZ6V1mttqBj5+ChjfDpo4826FFFyiIu4scyOn8rEIguhymtms4tgZ0oJUQ/5Rsto5g2LNIFYTC98Tu4ReRCZo7SqQP3zCunlVYErkQ6g5GjgBnkwCD212QXPBlqYWRcrnIQm+75YgzSeerr6iz2FHY+wmP8AgyMwov7Libe/u3avO8ZSf/tWvNGaaq6CX0C3uF5Z/ykURLzR8Mq74ob1hIwFG5tdKyaghMxsjeXNR6rYBALToVRf1MH6+e1lyXXNMrh00/K47mZnZV4DNDNBEYruWyyeT6wexpNZLBQA88AS1YhCoWt42fwX/E/7SLI9Z8Kl+5Is3pAQJCapcUgKegsSzYnZ8e5c28laXrRGtQoSvx1PTT1h2QD3Xw9yw5qaCZaxS2hOHkVEL+p6GUrwvZQLU6uO1r4EnoPZ0M92p5pXx/8688s8qJuHnKTR7fMCXsFRWEArzg0iJIBwcD6wfeCjaxUBrYutc7emazimemfEnFLQl2jKcGUvTym9Tz1XELFkTpsi7Vd9qGgYCHIrYSOhBtJ+7coefdUnVtQkeyPO7Wy13u6s1eEUlE7NW4eszuybHSgO7OeUdDcdi4JZxqGXeGHTDqUaadte+AddDJu4hId/WmeTXujF1Bt0I4ealO85GA1hOuky0fKHYhNnA0LZZmE8EQ76vAVs0bvv5nmGr/8V+BWFCq8m+wXblWaFIgugKb8Ob0Uwxe9xRCXF0WvcNu3azoLjL+xl0jfLicFxjrz6TcCtUS9nRWPjqwrLbSMCqE6KsYLZ01tOKetmUQ9YxQq2hJiCg1G6z7pQl8FU41Ia1NjizLbltaY
 L+kPHcGW
 zmRPRO5vqYn5KPdJNg0+Vem6OH3jHxf7cpP+jKbftY7s5TNz2pApOv4mTXHNr2o4FZX/aUjtiEWjp9rBppOXpWGOl8nVz4uK7cKroAxsRY88jUUlAjJuDqwHcKHk9CewnKyIx6RWzQwrmbw4baaZF1jLDtD71nr/ColRdRMtqurSWankJ8G7x84EkNQWydSSrsz+TURWQGu7bF1qy4o0g6eVyVSUaTyYYoRyY1E11cgv0bedHRRXxnG4V29QNiG32jX0dYyrOkFCsFdqZiFfNTEsEwUJvcHANMtzE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_region_access_rate() is not using attrs parameter.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 3 +--
 mm/damon/core.c       | 4 +---
 mm/damon/paddr.c      | 4 ++--
 mm/damon/vaddr.c      | 6 +++---
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 87c1ff479da82..02ed47c558cc2 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1016,8 +1016,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
-void damon_update_region_access_rate(struct damon_region *r, bool accessed,
-		struct damon_attrs *attrs);
+void damon_update_region_access_rate(struct damon_region *r, bool accessed);
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
 		bool matching, bool allow);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index dcd5e484fa442..33c6fade59d37 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3814,15 +3814,13 @@ static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
  * damon_update_region_access_rate() - Update the access rate of a region.
  * @r:		The DAMON region to update for its access check result.
  * @accessed:	Whether the region has accessed during last sampling interval.
- * @attrs:	The damon_attrs of the DAMON context.
  *
  * Update the access rate of a region with the region's last sampling interval
  * access check result.
  *
  * Usually this will be called by &damon_operations->check_accesses callback.
  */
-void damon_update_region_access_rate(struct damon_region *r, bool accessed,
-		struct damon_attrs *attrs)
+void damon_update_region_access_rate(struct damon_region *r, bool accessed)
 {
 	if (accessed)
 		r->nr_accesses++;
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5c2da45f988cf..8530213086691 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -91,12 +91,12 @@ static void __damon_pa_check_access(struct damon_region *r,
 	/* If the region is in the last checked page, reuse the result */
 	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed, attrs);
+		damon_update_region_access_rate(r, last_accessed);
 		return;
 	}
 
 	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed, attrs);
+	damon_update_region_access_rate(r, last_accessed);
 
 	last_addr = sampling_addr;
 }
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index e73ec1ce016e5..2eaced0765e26 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -501,19 +501,19 @@ static void __damon_va_check_access(struct mm_struct *mm,
 	static bool last_accessed;
 
 	if (!mm) {
-		damon_update_region_access_rate(r, false, attrs);
+		damon_update_region_access_rate(r, false);
 		return;
 	}
 
 	/* If the region is in the last checked page, reuse the result */
 	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed, attrs);
+		damon_update_region_access_rate(r, last_accessed);
 		return;
 	}
 
 	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed, attrs);
+	damon_update_region_access_rate(r, last_accessed);
 
 	last_addr = r->sampling_addr;
 }
-- 
2.47.3

