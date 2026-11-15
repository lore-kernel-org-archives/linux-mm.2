Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D75606A882
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DvQ6xmJJ
Received: by kanga.kvack.org (Postfix)
	id C56766B05C1; Sun, 15 Nov 2026 15:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7E96B05C3; Sun, 15 Nov 2026 15:29:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD096B05C4; Sun, 15 Nov 2026 15:29:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 769AF6B05C1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDEC6C0725
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
X-FDA: 85438492776.01.40CEC54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4FB9E100008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvQ6xmJJ;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gIxUQIo/TA1PIO0jTUdNpj13U+tqjhnz67nbkreB/0=;
	b=61wzhKykTg7ctrIX35I1V1rS2c+L5ejVQhfVGrPJp9K+c60ZF3aJCanH8nzqlMhlKUEDWc
	4inbu98VkBr3UCALlJjS/Zfb81YXzG2BavFPe5idK34QSP5GCX+JG0DG31EKOZPVzeAiu/
	qSvswB0TP89CVnBmiVVz9H2akJ5inYU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774547;
	b=0khNi2xyFfx1qPkPN7o6aZkY1riHPc7CNKS4645obbWxqfBrNGzhnEyw1v+w1R/F3DkJnO
	tbueXvECwSz5bfovOhxgAyrSUZ79dkGWkCnddnSHHiCdXQhzNTNAepFRw5X8sRGhnxl+Ur
	lazFvAvp1063PpfPc//U2qcHKoUyN/Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvQ6xmJJ;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C6A145B40;
	Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5945C1F000D2;
	Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774546;
	bh=6gIxUQIo/TA1PIO0jTUdNpj13U+tqjhnz67nbkreB/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvQ6xmJJtmDKQVvz7veeezW21iojwJCKmLcgN3cpqA3PNtLaYDr/JaTaePbfxC0/h
	 djgNWagXMtLjieepCkMuyrCQZqw5RohLAf4P34avIASU3q+9X5jDigFemK9bvOiVR5
	 02o4W5I0iHcQ8O1QFGoEQk2fLwENjCP7SMUZRA/EfS9KnY8Q9ocoa4t1OZUXr7Kusx
	 SJwF4nFiNy/iT8I6tp0A7XfOvgDYiSbnEvkl3OYedUKskLnCUrEijBF/fU9kSn9MJe
	 J+WUM2KSbnj+7o6rGntSo5S8qWoc66k/yg+tC0cG9I+TKHQlnirFWONRYYWsjijv+V
	 rtCvDrTjflb5w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 12/27] mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
Date: Sun, 15 Nov 2026 12:28:30 -0800
Message-ID: <20261115202849.99134-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4FB9E100008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gsyswar63pbaodqj5nop8wgadgr4q3qu
X-Rspam-User: 
X-HE-Tag: 1794774547-762658
X-HE-Meta: U2FsdGVkX1/yEYa1qH4FOIdgM/FOzNysKILmuLoXx1frYVmo/DesGiQHeHxzbyKl1inRIiV/wz9/26w/I3MW33xyxJTPZp4+szJvvua2r+cQ/L9DRWs/MwRrH5kfI2ZJwN3ofsNfQy6H/y32RDtP3LTH33ZRc5AWGhD59YIehq2jbzGd9FnLhzg77OpAUcGt2TtKX+Wo6mL21us58MTVQWR8YHp0jRiNgA4K3RPxNoySCtn1dVVDzt75bAhnQKy2Kcz0iuJFR+iqRJMw1b7kz19UQzt5JjAXevvqpPY2N48DNuWNzA27svsfeeKFPfMfUL9WBAJQ41vNItxZDFQFQxpnSJyZHJjEPcwgr9MbV2La927sxP93nNMReLAYDy4qFd7Med6FBoB8ijbr52S8TM4IT4jK3UL5kXVV27nFUUPEayRgSi4A7gs/U6q4j7TkYxCA/7narS7aRaWDqbKI+ly0pQQPJu1nVwqmgBHtT0k4as108iEhKgy/kZrDjnSc6x7M0ZhTogpYmC0jMJ1uD24Frd+FGw8Tj7oeOwxKolWCr6K0dDHYFz1ptlg68M3pziChGAclOudEAEbCc+++oqLSrOWdth0GFXCNkbxcXxV/ZKkqUTgWAvUzLidKZj7WZYUz+Cs48JV8jHDx0dOjt2cmUMLLrPYWRRxF7QEE/as1hp6zjc0HD2eq5kz8mGAFaOAW6eLxIJXISdsXxMEtakBr8reu8UXFa5KxU8xbaRwdeh/sPisBkBH5uvyuAB3ARWJRfGL/VZk8LAmYJa/uVFvAXm6Kl1Tuf2suTMxRXaWaqQvwLpZQBHA9isUbuNFYA3a0YKFBdkDb/yRETZHpohwOYfOfH9ZKmLWllS4QUXDcyELTWb0vHbsBsrG38XxgEJqtcLuN1Ne1+hUD6xT0OQu5foaKu9kcc1yaWwAXex5MOFkb6VKhuBbjwke2T8uvHchvcqaaGlsjAWmVhv3
 jqLfVcYs
 K9Kh8kLC0Fq8QJHpKk25dCxY598HvBqax2H+of5aNfvr64Z8HtnSb4NXbcHGeh4gCaA/pBvnzmo1Pmm3rAL7i2p8iHeJVQ+o3pCI6ewfHwcP1iRReLovagw+OiwgOJI+iR18Z+vN84mW1EzPWOCfxRWQqZ3HZzcwUFjT/hqsykk2YCgQsg7PNgfY7iDamSJYiR2kO6mO+oI6vK92o8Fzb/3nnAo+qk5PUeJIbEVuN3/M74ln7nJ8Oc74oy9wrF0viaMqscl7F+uvuB/RC8F8/E5GL+g==
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
 include/linux/damon.h | 3 +++
 mm/damon/core.c       | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index ca0135c6f6700..cce7d344c585b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -804,6 +804,7 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  * @DAMON_FILTER_TYPE_ACTIVE:		LRU-active pages.
+ * @DAMON_FILTER_TYPE_REPORT_MADE:	Report is submitted.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
@@ -812,6 +813,7 @@ enum damon_filter_type {
 	DAMON_FILTER_TYPE_PGIDLE_SET,
 	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 	DAMON_FILTER_TYPE_ACTIVE,
+	DAMON_FILTER_TYPE_REPORT_MADE,
 };
 
 /**
@@ -834,6 +836,7 @@ struct damon_filter {
 			unsigned long range_min;
 			unsigned long range_max;
 		};
+		enum damon_report_type report_type;
 	};
 /* private: */
 	/* Siblings list. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 06b85d00e38d9..c02c7fbc1d864 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1834,6 +1834,9 @@ static int damon_commit_filter(struct damon_filter *dst,
 		dst->range_min = src->range_min;
 		dst->range_max = src->range_max;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		dst->report_type = src->report_type;
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

