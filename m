Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A84EC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727526B009E; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5966B00A0; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EBD36B00A0; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 335B76B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B53C14010D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:59 +0000 (UTC)
X-FDA: 85212639918.16.48D3042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id BDEE2A0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgHK9ARe;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNN3COfz5szEevfjTAWMJ9flE3N9cABR9EM74E8BBgw=;
	b=8U+eUXp43wHcTf+7ngAU/iF+29SCxCSNMZ+/HqRbrdQ40l0C5M8Kd6E7S7s9Lya0WLyCBB
	rhzRnKyaSQfMsOnycPhcQnfsO0+XFDC6+ho0+Y4SYArK1v9Q8qQaPjtNfXU9DeWSufO2sX
	8L2xJrdsN/5ZTUkeqyaU3AS+/uc6V1Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397097;
	b=jL9VYLljZbo95NPNAOtae6JFhGXoyOpQNSDKsmTwOLmvQglmphN/5rCrpWabx5jBgrerVr
	BhA3YQNTYONxjwToaU5TME2WCyVhjs02hdZiLp46+W8pND3v6HDUFvKj0Fx4NhB8V3qttB
	gGv7K6JpGV/ty2PLirIdZUXbAVpMlx8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgHK9ARe;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EEAD43ADF;
	Mon, 14 Sep 2026 14:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17AF1F00893;
	Mon, 14 Sep 2026 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397097;
	bh=PNN3COfz5szEevfjTAWMJ9flE3N9cABR9EM74E8BBgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgHK9AReoEvV/+ci8VgMmW/xHkPlzSWnb5f4Lbj7TfVOuluHbRME+i/sGujR/ygZB
	 2nGIA8jPm2wZ4aTFnMZmNHz95NJNlalFia+8gD7R4jcWgy1BeUFmMBAcJj4F9wyKEa
	 sM9OGzZ43rP5X2IWqy9okjmmhNSGWHPOJWlZyW9/8jz5EMzHPy2KuSJKiCxSLqTkve
	 LlMUsE9bo81dhMjMhr9AfyAeMYzveFZk1IID18ibY/6Ad6ysgD+OST6RJJGZP9l+Ha
	 dPn+ddDHVI6m8YgKs0AvJabQf3UHqjDoKI3/HNEoTUm/0L/pOdZ3QGzWv964WojrZD
	 ulmeibjDycXBw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/8] mm/damon/core: commit hugepage_size type damon filter
Date: Mon, 14 Sep 2026 07:44:39 -0700
Message-ID: <20260914144448.93732-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914144448.93732-1-sj@kernel.org>
References: <20260914144448.93732-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p43pi4dsdzt5ew1t6j7nc3gw3q151t7m
X-Rspam-User: 
X-Rspamd-Queue-Id: BDEE2A0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789397097-999800
X-HE-Meta: U2FsdGVkX1/D3C52TUxijR6AbAfa06BO0eY9sENyD7A0CoEz+N+PW6/K+oR6s9wO+Ex4D3PNVU75g0QR93xsf+EcCl0ucywWImLcpx9QijrwFFu1eJ3zLRNVNpRqYvdHnmcRcX2HtPdoHCPivwwSjiHOSFkH+x4B0yzMvIu+I/e6QhHTfpomJR8bNdMnFl7xd1YResGO44LFKWOwlWoOG7s0WX8cxecwvj8avhqEXb5gbdZjmuMxSbOE4uJT38BUw1Idw5nDL21WoHIYh+NkMiCFXs5TOWj9CmADv4o5AxnC8aBExDEA+n1Py4i3Y6coztkq+bGRyRxt7EeK+hFZNEpaIqKdbZaKiHgSiiTM3yug61ELtqm2ind4RhzJQ/UyhKhAnmi0kxhDpTM3MlutO5eNZ6Zg6I/1SjzQJrqDK2JcrbMonBDIV9MCpVElPWV80Nc4dUwwWCjk9LaDv7Hk9Br5adRBOoJvzGIl/+yKBCJlbEKvPwIdRbCjy3EPY5+OCokcW9cWk4ruidsXhPy3PvZeYTJIKGSoGMMbAM+iFYllFD2DQMqw3z3mxrqkck2eZW8GCcVcfygggkj4JshwlsPamDVawO64yIj0PYBP3LfgAuaB230PRJfFJXo/4B5fXMXkkcpAirwQ3kbawgEiWwauKQ7pK9X7/2kT5r6P1UEeH9lvbF4zVIJH6USmEo+wRBDiw7RjXaOUFf+vnAIESUqqiEeRd9Z6Z0Gwk1TFGU9+4/XGfiBXD7bpNLWClNQ8VIqPiP4c0tcs/cOVOGyGahq3+EOLDoLovuoa7l95WDeLsVwHuNVeBGz7KccdlqO6TBpZXFS1LWZGlSS581Vr9qoNLbeqvOKoTXaq829ASpf7eYN5zvilKpCnyep13nAu3o71eHdt/ZFd6bUWhZJ1ZmBpmjNfJ0BaEb8dwsXezP1qM/XfKud+xU1309VL/enrImN78WJPFOYmSu7pmZ0
 WSut3VFE
 ++v0X4uMExby52Yy7cb8tCmGS8j2oyR79idifW7G6VTXIi24JTlNsCSQLRatAtyIo9Btr4XNfsLITEIea5cBbV7LAvvHvUF7i2MIWk+f7QxnDY50XGFeq98/pzo7jtebx+jtZcX7O6qUKEI4rC9DDcGVk6W1H5CUxTmJZRN0lxlW/KdgMN1/E6WMBNo7MP17rMHd41dwyfsLZdujvTRq0KwSsiUpGjXpKpeck0UBSACyRVZL3L68N2DaGtXI+Se3gycTILf0KyUy3bHVvxk/DxKeirw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend data attribute probe filters commit logic for the new
hugepage_size filter type.  Since it needs to carry the size range of
the hugepage, update the logic to update the size range fields of the
commit destination filter struct.  While doing that, validate the given
range and propagate an error if it is invalid.  Add the error handling
in the callers, too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5212bfb8f85f2..4cd7eec7b8ec5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1818,7 +1818,7 @@ static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
 	return 0;
 }
 
-static void damon_commit_filter(struct damon_filter *dst,
+static int damon_commit_filter(struct damon_filter *dst,
 		struct damon_filter *src)
 {
 	dst->type = src->type;
@@ -1828,23 +1828,33 @@ static void damon_commit_filter(struct damon_filter *dst,
 	case DAMON_FILTER_TYPE_MEMCG:
 		dst->memcg_id = src->memcg_id;
 		break;
+	case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (src->range_max < src->range_min)
+			return -EINVAL;
+		dst->range_min = src->range_min;
+		dst->range_max = src->range_max;
+		break;
 	default:
 		break;
 	}
+	return 0;
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
 		struct damon_probe *src)
 {
 	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damon_for_each_filter_safe(dst_filter, next, dst) {
 		src_filter = damon_nth_filter(i++, src);
-		if (src_filter)
-			damon_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damon_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damon_destroy_filter(dst_filter);
+		}
 	}
 
 	damon_for_each_filter_safe(src_filter, next, src) {
@@ -1859,6 +1869,12 @@ static int damon_commit_filters(struct damon_probe *dst,
 		case DAMON_FILTER_TYPE_MEMCG:
 			new_filter->memcg_id = src_filter->memcg_id;
 			break;
+		case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+			if (src_filter->range_max < src_filter->range_min)
+				return -EINVAL;
+			new_filter->range_min = src_filter->range_min;
+			new_filter->range_max = src_filter->range_max;
+			break;
 		default:
 			break;
 		}
-- 
2.47.3

