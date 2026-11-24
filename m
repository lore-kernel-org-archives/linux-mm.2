Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4A2606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GSWuead4
Received: by kanga.kvack.org (Postfix)
	id 9F0AA6B076B; Tue, 24 Nov 2026 10:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2336B076D; Tue, 24 Nov 2026 10:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B67F6B076E; Tue, 24 Nov 2026 10:36:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 636FA6B076B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07C0B16083E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:56 +0000 (UTC)
X-FDA: 85470415632.04.653D952
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 638E61A0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSWuead4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534614;
	b=Q2uzpWbDwkBXIjY4mu2jh1cLBj3D2MiQsYtP+FPKPBlbrG4YvJv27HkGPyOgrR94HEvKku
	aW/vS9IdvsJg/V8h2fmWYqqRxsQaHLX0Mmls/yd3KX0Fl4SwbrAMr8wOuF5DTpAQyOK/yV
	a8M+H+nS6jUE96vGn1GRWH8QiJznsTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnyPiUqFVF3Hx0zBZDBn3SkpvY286wpjABhuAXsQCTs=;
	b=No6lNLqR7sg0kWBSyCWzqyCGCWxZ7gM2ysR/HrFg5yPgYPHaefwkIawhdCNnhMp8M3x5TK
	2dD0JQj9zdQVlichxf/et8zWn/NmJmdEmb31EVTZAzZE4zRbp4SrgZ04Nyt3TIQO+wEK6K
	gI3BW3waNpgFFgjPW/GgH5z1V2yZ5+0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSWuead4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B593F43601;
	Tue, 24 Nov 2026 15:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA691F000D3;
	Tue, 24 Nov 2026 15:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534613;
	bh=pnyPiUqFVF3Hx0zBZDBn3SkpvY286wpjABhuAXsQCTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSWuead4LYsPNpUjZQu+tx5AWvfa1ioSl+/lV5GshlteDpCPwKbLynNYUIpHvuaOk
	 RlrkHnOHOK4+a6HsZnf+KLwE+XLuUqf7bx16CuMX6kOswtj3//w7FnPkg5837mIVVs
	 j9AvCmcX/MMjX+PSb71U7S2mgDT42PlnLFb6EQMWedsinx7i7S+0qnnrk7kLAM8/CS
	 yEj9DWaprzzreOTiKcON4gS8/SAI+89Rro7xZUL7FmR8HtWcO7cQxkDwcm/vcc6TOF
	 meoNWntRXqCau9x+3J7Y+TeLs77tXVjWmIjLUGWKZGllgN+TVxuVt7P+mhHCxQFora
	 vEzIshMGgPIiQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 12/27] mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
Date: Tue, 24 Nov 2026 07:36:18 -0800
Message-ID: <20261124153636.91854-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 638E61A0003
X-Stat-Signature: ew7xt3k878w75tt9kc6pjpawx5cfpwfw
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795534614-86609
X-HE-Meta: U2FsdGVkX18EB7G9ln9ixk/CC8HXrjr1FK8Hq8LRkbwfy5wwK5sj/cnLfN2QrYc4sri+riuN+0QqCvjcrxoSfqPtZTQuEKP4ws8K2ue/3QaeMZ1hyVP89Nlw4eLOIUg4VM+HNsELHWhNyoS/blRuKHiH8WLeWUINfhz+Z38NlQIR/smhBdIrPLcT94gu+udrkWKzerkyf0AlFIN3Z55KNP2t2FneTiFRL8ML9skpvivUla2v/plFBmGBJkC1uP24zgIX00b3BnyS3/Lb9ZWWVbXIg+IIoNl0muc4sJRN9AvvzNEnOc3tGwFkLNUrMfdUaGLcXjKNF6iAEgZgBktoCvQrrSWCD5HggVdYDuElB6ka2LFnOvHcu94v3Nh8Sa6lQ5h6Orjj3DZX/3nJo4vrnIw+oUgZ9vnPTZYEdhoLouwyjZ4iFPj5bWm84wjagvKOJFm1nLczcOLjiI5zwyVZwBzq8Ah+obVzYk6IMPcn7Ula1sf6terZxLZt43UcO3vukXxE9YcUfXDuMiGHY+AO1BMeQgg0OGQOPVYF4MCA4+jASRRzbiUT5HRX/Sq9ubfj6hKxt2CM4vq0cDma+Ukp6b1J+KJ+17Z94nhG/D/PmdMqJdHiVgO/+XjBBDBD5oR5Wrv1hnqA7hnxa+NrjEqNJWwIBTG+ud/zpUf2P4C/8qbOt/T00qRCWBt1R48UzIu4w2Sxj7hF2fDNhz3VxcxOgvBhXAQnRS9rL7M4XEf9NXKOtfiNcOrPmEogyj0i6civ4EkwDnyfRYekGPW88Mxi7ck+2ziYDeMOibWVNNWMhFUnLXTT04Z1dBZDUchqsOmWMyaPxbM9Dil+1TXXvp698/Pm+hBnkNbaorvxegfwXkVgohh3opxiWn6m1lz1cIQ6+PmG8xPRcXM0p3zmUtXhXG714Cp+FOyMGiYB4rnw1RIh/CrtutqAL4+QydriGqV2KXqpN97dz4j/zBJmPQ/
 LvNxiY9/
 Dp1IHjk+94d0N3h2Nrd51xtjBVCk9q6YGO29mw6D6vjIV8h4bZ/bpbrikXsW1lM2RYJG2awjBq/LA8jGaTKaRmGiMFSVSx+3X6j8y+JEIFShX0swkevpgXdfNZ6n7p+fjPZkSclv+OqV6YawxeLK+iN9DjfATlwzGOTeCufjN1To2BsaK/bSksvXxZKUkHxxZK9fH+BM8iCq3F41gLA3ENaRh4J9oOxHLmIPnuLJTIt+TnopUPQKhfwmWHHbxoVEuhY7+NjBNYNnMVTCDqN/s5LRucwFQ71Hv3P2X6+2nY18KEkE6eSgyv7dv6BHDRzxvTXGSYp5hXhKc0tyzw39VEy8APLhbjWtz4G5OWKkMOAaig3GNrKowg6f2QMoBBVp+EFqvyLv5L7i0zLqakRoFaQoMIo19ltqRubQ6JM1ugzthiT71eUnN4+jiPcU/i2fqHxxyISe/1/6kGAlGhNcK15thUpJg3m0DlIpKY2zcD9LDQoDOKmgYx+zBFCVyIoQzAjeYVf1L+KNFhZQYz2fC8BHd3uaEC6O9fo5cH5ddZt0/OJydP0g/CilweV1fzpFDf0TvDdu5E+hZLNRHKYsi65B07cBvPnngOiai
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

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++++
 mm/damon/core.c       | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 30c0ab8d88c2c..9f48f17969d03 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -808,6 +808,7 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  * @DAMON_FILTER_TYPE_ACTIVE:		LRU-active pages.
+ * @DAMON_FILTER_TYPE_REPORT_MADE:	Report is submitted.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
@@ -816,6 +817,7 @@ enum damon_filter_type {
 	DAMON_FILTER_TYPE_PGIDLE_SET,
 	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 	DAMON_FILTER_TYPE_ACTIVE,
+	DAMON_FILTER_TYPE_REPORT_MADE,
 };
 
 /**
@@ -827,6 +829,8 @@ enum damon_filter_type {
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @range_min:	Minimum value of range arguments.
  * @range_max:	Maximum value of range arguments.
+ * @report_type:	Type of the report, if @type is
+ *			DAMON_FILTER_TYPE_REPORT_MADE..
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -838,6 +842,7 @@ struct damon_filter {
 			unsigned long range_min;
 			unsigned long range_max;
 		};
+		enum damon_report_type report_type;
 	};
 /* private: */
 	/* Siblings list. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index ae6ef43e5653f..d4a4aca4a831b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1837,6 +1837,9 @@ static int damon_commit_filter(struct damon_filter *dst,
 		dst->range_min = src->range_min;
 		dst->range_max = src->range_max;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		dst->report_type = src->report_type;
+		break;
 	default:
 		break;
 	}
@@ -1880,6 +1883,9 @@ static int damon_commit_filters(struct damon_probe *dst,
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

