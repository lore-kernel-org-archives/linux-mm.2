Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB33606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dn4/oKL2
Received: by kanga.kvack.org (Postfix)
	id 311546B05BC; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4656B05BE; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAED6B05BF; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E833D6B05BC
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 605DD1A059B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
X-FDA: 85460344494.14.B2771FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B304314000A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dn4/oKL2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294825;
	b=rG597H0tWAJf2Fk1MPXETPs2UBvrLxLq2z6o+lf2eZFAiea97JkQ/XDATIr6eBZ72NDyrI
	fogoF6xIlUMmdpkN6X4Dcz6llAi9txoziGpkM6RHym02QCi5EUiXGrbwTAr7QPB7DqMCA+
	GJn5j0LzZaBVsNWigLNRO9t1lzPz2yc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9zNU7VFP9R08IpO6GDu4i26WmaNoJQ1rmpNbfyIt9I=;
	b=RM3pM7iKYhVS0VTEtvca8ZT933myt7Y+Xm6zFqxWrFkmUML7JjeAef1iXt/sTXjZyUzqyo
	SYl6+LFIc1bSYSb2HMmR7C61TPQHw6GbotIzo8FUPWD0TsVyrIjndCdjNJ5gq79xCy0gSE
	+A6/PywTxbVsV/S9gEh7AQAbxYCle50=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dn4/oKL2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90CF561CF7;
	Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A7B1F000C0;
	Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294825;
	bh=j9zNU7VFP9R08IpO6GDu4i26WmaNoJQ1rmpNbfyIt9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dn4/oKL2StXi0ppkVyq6NMoGGStoQVOFsvq5r09vK+G1xmI0P3FbWkYbEhfDm1FeP
	 aTixH78iV/1vGXruWunbhtCTUX+7VzZnoSWNUoDHcy+0fpkqswWegR0egeFDdAFCUM
	 SDhMGuQeKfBFXlkNQ12gng3JeINwL2UCvjzeqUHvXt5kMf799CCLqCMf9S8Vc8uBUS
	 GvHlo+rVJNaLhIK7z12UhnIUruXIP+OfSAvw5SY31XVR1ewXALjCBStah7BBgT/mLU
	 mutYgJS89AdkFK4AGun2njPS8zIPIjg/yyyLbX6JihtUVDaW7dQxEa2fNd7RwgnMYK
	 TRlo07iMhQgpQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 12/27] mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
Date: Sat, 21 Nov 2026 12:59:56 -0800
Message-ID: <20261121210013.130397-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B304314000A
X-Stat-Signature: rrhftji8hpaxm31fy363nbbp3p6cuczt
X-HE-Tag: 1795294825-735067
X-HE-Meta: U2FsdGVkX198XFGTekQLs7NZyLctfJDrOs2IIMynWFDmzBtUUOoQX1qCXxx6gstLPuDSwbFIUqB0poUdLM32is+VgUoqwBVvM0Z4XJc18AlwxdQQCVxzFgp6FI9Bd3PXQM7Lj8ste9SXij5R0TZJQeO+Wc9O0/9Y5uumN1WKyUwy/a7cDc3egEJ4ZR7eTWAiMKgE+IRSE5c6MhxeYxeHt82lVc/CX2iD21sYjAjVEhK6diXlTyzJBX4EdxtCnx+4RdGaA3M/Bm3jf6nDPm1VbaVWoPvnZQA08FppcDOqcz7Ab3bj3dpADdhZhztpdLoWHVvqGH+d9mpquaoQHX9/z+z8nX147o9JLUxdEVNPy5PeabSgCYDm6kJ3ukOgZgwvTV/bKQYHOp6PSXypqMHup1h1vJsNKm8ki7beY4jEIqRVPGztLsLsoE3aC4oJMRJuKIUsZTRWcwE4Pa2JzldCTkSFR6K9I9cPI12WPJ+O5M/j+1pOuHZwhnqMqiwoAvyhYnqaoL0levwY0yZkWdzr8ZmwbzgsxDnGeWl8pTrRBl1dkosJ9WV3RY1vg684CEkhZPgt9IxMoCI5fAMperQNDikEVeVmjQOUIaj0hOfrYwrs57fdiZzoACNG7Sj7bR1Pg6MJMfG1APYNrXkDZeFF1Ag6rZ1dL+0obJy8Cg5KKIAxrksRgnBpi3KpIP6xZ1upDqIsyQNXKm9YhD6NcLUvHJjQyBRBe+SR2IsesnIw358+sNBwK0gb1UPNRoLd475DZMwW8bU+tLfzHZVRPqei3+orOchoSRcsoRXO+DIzzFAy2d39azz8QHZ2s96GJICohkBUm0RhNhUF821ZX6ETHsYYL/+OjwwhE0t5t/npZS85yXHjRvfv4UeZrXG6tsUsyJjbJwOtw6l3jW8TZvM8CCdr9E+9W6IewVrvcycLPzR5BPIvpBk71xlf3+1LObaJ2VUynaK/2nQKKE5UpIt
 bTVDRnmE
 ZLwJMTCg0cAl6/jyjq8BJjhO/F1YW0V+C5MQVykXaMeTiOAwc2snum9Rg0hTfuZ947n5CmfahOOw8oknLOKSlv7EA/0FZQQ8SHs/N2kqSeGnAxgs3MEYlwXSSKLm/642zaWKRd8L6dHMoPUDRK9M/JamIodZWZrs+iJ9ywCKYmTskOZrIUb//I+k7GXit5oCMZVDG83JlCkZ3UVcquBe/6PgKr0KHy0waHdQeUut7PmwqVJONEAkm24PD5XCx5hDLPhOz/X3NjpgUU3i+sjTnIqfh5D/NFvU1717kQkXxYOugTLIDspZk4V3wwQKEUkA6KXAZySrQZsirI+xzu522f+9CyMcr96jyTmo98VOSnV3/nOqt0UBDsaSQtAVB6+xK74P+Z4ynOoOwxVHYQElx3+rf54Tkd2KwdplxRg93presdFnwwZ9/9JH1gCiVek1B+dHCUEEo/cyUsRRkPx/TD7oWuhLHwH7tyVoaH9q76n3WrXlSq9jhcp8HaH6O0hehKjS3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend DAMON probe filter for the existence of data attribute reports
for the probing memory.  Define a new filter type, REPORT_MADE, for the
purpose.  Add a union argument for specifying the type of the reports
for the filter.  Update the new argument for the new type when new
filter parameters of the type are committed.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++++
 mm/damon/core.c       | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 35ad002d1536c..09f0dfbde8966 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -802,6 +802,7 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  * @DAMON_FILTER_TYPE_ACTIVE:		LRU-active pages.
+ * @DAMON_FILTER_TYPE_REPORT_MADE:	Report is submitted.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
@@ -810,6 +811,7 @@ enum damon_filter_type {
 	DAMON_FILTER_TYPE_PGIDLE_SET,
 	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 	DAMON_FILTER_TYPE_ACTIVE,
+	DAMON_FILTER_TYPE_REPORT_MADE,
 };
 
 /**
@@ -821,6 +823,8 @@ enum damon_filter_type {
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @range_min:	Minimum value of range arguments.
  * @range_max:	Maximum value of range arguments.
+ * @report_type:	Type of the report, if @type is
+ *			DAMON_FILTER_TYPE_REPORT_MADE..
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -832,6 +836,7 @@ struct damon_filter {
 			unsigned long range_min;
 			unsigned long range_max;
 		};
+		enum damon_report_type report_type;
 	};
 /* private: */
 	/* Siblings list. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 61ff3adcc69f4..54e0ed6561c05 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1833,6 +1833,9 @@ static int damon_commit_filter(struct damon_filter *dst,
 		dst->range_min = src->range_min;
 		dst->range_max = src->range_max;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		dst->report_type = src->report_type;
+		break;
 	default:
 		break;
 	}
@@ -1876,6 +1879,9 @@ static int damon_commit_filters(struct damon_probe *dst,
 			new_filter->range_min = src_filter->range_min;
 			new_filter->range_max = src_filter->range_max;
 			break;
+		case DAMON_FILTER_TYPE_REPORT_MADE:
+			new_filter->report_type = src_filter->report_type;
+			break;
 		default:
 			break;
 		}
-- 
2.47.3

