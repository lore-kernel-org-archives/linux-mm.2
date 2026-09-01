Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995F2C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C227A6B017B; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36696B0184; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913D56B017A; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A77C6B0178
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5C31A4148
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
X-FDA: 85165264674.25.280EBBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40E08C000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X3rU3NCL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atWhsqWAE5VXdJdWplOPI8OSXhIZpjioTpYT4VKG/08=;
	b=IYf+KJTIQUI1UDL1+E4rgTI1KIdmzFR5evOcdoC7v05uECHGXeGviGm9mObtfigdqd8EgP
	pkXc6imXX3L+AahOYvEPDXFsxFh/ZLgWfPwvXoam/9F3DOwC7BcE+SknQrazxLJdbYVZI4
	1qgcx9RegKbqCpe/XTHX7W5jJ0/3mKs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X3rU3NCL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269116;
	b=GRFjwd60qdNLBvGquc5IWbyjToqavCM72cGa0BVcwdd81PpQT111zflXrDYeBkR2eBjnOV
	m92dniTBwvaHYxQqj+pDQORsMCvGCbU0+YpzOl4LIB4hVuxlM+WlsIYYhNazxftMDuAWGd
	uw5GgbBB/RtUrSQ7XQzIl4wzWkqfoTw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B55441A1F;
	Tue,  1 Sep 2026 13:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475D61F01558;
	Tue,  1 Sep 2026 13:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269115;
	bh=atWhsqWAE5VXdJdWplOPI8OSXhIZpjioTpYT4VKG/08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3rU3NCLujv+rUY/N1F1HlANXOcMs774/erA6prJGwJ1zfysPI1f0g9nbt3IPyMjc
	 J/uqB/DMeZ8pZPNJjwj6fEsu53i4GhFBuEV7iVvYqaVlVWCFeHNnx0BbaazdgF9JfE
	 h88ogDbPp90id2S4klQpHGA8QUdhy/aA5cOOl1zPP5HyRQcbUBs/SowAgNo4dvPClR
	 z67tmt5xdgeRi3SYMsf/8H7bi+wLLDKIfbjBfrWo2qPwMqcnGzEi2rZObTJfs4H0M4
	 ozqFRyZzYLWl2EaI4iV3NSfVmOYP326pIMpWrOdtGr6oaZ6/ThTXV++u7d3zfO227b
	 C1XIK48dXmpsg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 02/17] mm/damon/paddr: support PGIDLE_UNSET probe filter type
Date: Tue,  1 Sep 2026 06:24:49 -0700
Message-ID: <20260901132506.99243-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40E08C000B
X-Stat-Signature: jxyefa3uu3ptgfpiuab58db1xsg4wp8d
X-Rspam-User: 
X-HE-Tag: 1788269116-313428
X-HE-Meta: U2FsdGVkX19Btq3+ecxZIrlPRrpWDeN6pe7xoNARFaScjb7IUbaRB1FAeuoTGfeHMTccj3OY4rG05lmhoQI7gLNcd3OJCkZfwlcF1fpJD2iWQxqnKhrq+KcKCAEeaSOqtf35m/NRJ1Q3lyzVCacVPlrD+70ktiqHWyVvWqSrp03IX02o1yeH6WsQX/ArOYP3knftV2DCyoo0iXn44lJnMwA0oMEv9/1lwuCbYN5gfjcKdRN0sgaUrgOGJsSBFo+npLpeMMguDYLSQTjDa/FU7qwzHFnKmTiYqKoKPqiOag2UXKwwz8Ij+6v+gSwa9vVksatBEWIeumDdOELuKBGYpXhcqbDv7rYaAs+9bo7mIoAlfM3sw5fRE+ijUOKrN0Pd+iRPpqO96anFKJ+e/JCOu+6IitCCwqTKEUbxtaqjttx56ADnFiFQA02JsHJfgnQ+ZS3gbkKujjj92qQxXqo/vM9uMJFTIfeocJbLX2dP6mUXFgn+4WCJk4FZs8CYuUBNuNrSiEL/J2BWeUR3Ryp/zUPhuVRCe0AfQ1rkz9sunk/MynZYQslV0qkXAwT5V+CoyZxbm2hIX5YOzNC/VKNYrFNsBzBP39VLwABV9tGboyZMP2RY3PQysEQzWzW8PuXYUJ5zxH+5M2h8jXdEcpcA+B1W/peDDoaeMpo+Zxoh04nEELMUZTrW3dHcKXPhuzT+Ya2wXTtPf9dOozLz5TPqS70bq0MDQqCmp+RLcFiz+kJtSPNQKlVVrlK1I/3yzvGjxdOQJHf+KEVystovNmXmtKv13G9e+ukZiKQ/G2jyHst8SGOySXajtNYvCmzW2U3oZHy3iG3+RxQpwQsEZeUzraQZ5sSFkEbybBwxAUuapMgKQXIVAfuef+EkaX8L0m9q09Br7Wt8rro0mfCEZKTYLitiUJqdG/CZDsL2X1W6KAcuKo8ruy+4LsdUJMFRLVQv9jbbEeTWkCDv5dtdUjp
 fXHMXGNU
 AC6lMmKJgHBtvSXFMa3unjX1laA+wNQ9DQPMTNkPpNKSSScLiB0zBRWJv/Sz3ZzmMYw7lM1u97UO4Oe/39X6Id5BAhS9SkP8Ro6zy4kKrcjzA2pZ2KD4ZlSJQUynp6j3XTHAvUJ4jcC87mhp8DPabGkD3wFBEib2PIcQGyebDMZG7TTlHHIXq1o/quGpMWNpDpQpzHfSi8IA0tI+FVYTaiN+N9CGQHWYF2Bg016FT/GB8ZScYmC8GjwedQkQ3GTR8ABPjuJsyF+kYbNMm0ALU/nGdEsESPEpaf1De3CIHYmUrsrk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement support of DAMON_FILTER_TYPE_PGIDLE_UNSET in the physical
address space DAMON operations set.  It reuses damon_folio_young(),
which was being used for access monitoring.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 9ddd1ec8202b7..6f756f8493894 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -132,6 +132,12 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio);
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

