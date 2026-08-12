Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35C3AC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7686B0123; Wed, 12 Aug 2026 08:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397D26B0124; Wed, 12 Aug 2026 08:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260906B0125; Wed, 12 Aug 2026 08:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05E7D6B0123
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CC11120346
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:58 +0000 (UTC)
X-FDA: 85092521556.05.03AF855
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 01F1B4000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIQ1U2Fr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQPoDdD5OLaDoL3cib3mD06LEWmyAGJqyFzrLrL7XwM=;
	b=IaD/FzaDZ8A+C6BuJED91uWYEujHuzyEVKgA16at4G9dV1SYleasTnpPcpkml+6RoVRkBI
	kjwQxZTc0ipevk7Zgu3j0FFlgz32JVpFv0gFMrCTrmldFEnaBCPbUoGfpYNxVynuwJ75Zb
	mOL1Sjlv/o4o6kaVFi48Tj+qo6f+YDE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIQ1U2Fr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537137;
	b=gPEtxRYQ59z6DG6q9r7TTZTFfexTrEdoJtaxPCdIYEKGahEl0e3YfrD/TAkPieOp2JwCqO
	AZuVz2vVafUI/04kpcsgVmDcGOqZTA/uN0ItwQscsH5kgyNL0wOAJ/uSbuJrXqYHItLryq
	E5tZjbP83Gn91oqbp+/tPb78APfqBEI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98BDF60DB6;
	Wed, 12 Aug 2026 12:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67211F00A3E;
	Wed, 12 Aug 2026 12:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537136;
	bh=JQPoDdD5OLaDoL3cib3mD06LEWmyAGJqyFzrLrL7XwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIQ1U2Frf0x661YHoG8mZNUjmwleI0PxWMk3/LU8npUPFUiSPNtjx/IhiwDh7OgiX
	 Gna9MI2ipdDabXPGk2MZ91adiLzJg1kHYBPremNpuE3v6EL12cPGXSdBHDASEC8iNV
	 Qp/Dfxv/F6TdJnIulo/qgrr3ssGVOqPTtG3rZTqp9ZeCvW7c3pqA19KzAfi30tOIMD
	 0sLlN7u/TSEy5ddjRa6FKZ9O4Tw2uLSMRscyDKiQYnqq01Gpg1QImxLgjIEPdFuBNr
	 cSBHwzsKqccw2OO8LCBmR+FfZoUFkXziyxcH2qgSk5PyZi3C8CjG7j0hv0WyoB9PpW
	 t7s/ACJ85q3Zw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	Barry Song <baohua@kernel.org>
Subject: [RFC PATCH v4 13/16] mm/mglru: remove redundant gens <= MIN_NR_GENS check in should_run_aging()
Date: Wed, 12 Aug 2026 20:16:55 +0800
Message-Id: <20260812121658.69965-14-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01F1B4000B
X-Stat-Signature: 8k3pqkyj46mmjurgnkkjwyc1a73dcy98
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786537136-969642
X-HE-Meta: U2FsdGVkX18gNINro9reHqFSfObzwspfEVAcJEjUTk7k4XU0/CrDyy/GB3BwE5QvBB1vlbLHWPW9gmQk2pARvoSTP323BvaZ4bjERn9WAsrPmYI9l/cCy6VQrDb1fXvFA1z6dx7pJ89j4cQp6qPtmRPxPZC5Q9mRp4lb5x27x8qIOmkpEElEIxkJo1QJ18sKjX4ZUDS5VPwVKc+uGI0BoGgX/7ETA7KapUj1pKTPEq4wN8g/1sD99c4diavUJe1Yai1qiAPDuUy6/m4kFNzE2+JVRz/d5xJF3wZ+8BlXZ9pmZpfZVoT3NYumOFm7zf+HbAgMXBhxyEGApG0L8RVJqXfO7/t5pWeIV4kG0QJwQTt2aPuJGvhf2RlmwfB36ZToKrlWTC/nWrl62CObQm+wyY9rgq7TRKM1UGbpQH4bMLEUHKRxldmc0Ic3Bf4uslKY/jV61ilaROEDwGXQKigsCus6jaG/c3WXP6SA4BMAavm+MMHGe+HRxnB1wU6nejh19VznOrZ6wxu6G/czrDqjCvXlPwDPjvhpL8YCNNMEksKeL0wP3fjO54iGqUPKkU3Fa5bpsHb6v24MhRCcjp0ENxaEwU9I0tcAMtJz/JPPWOxzVe6amoTEqxNzIcJG9zCKVg/CL7ihbnUg88WewHQ7cje0qJipXVtX/r+/BJyzwoTnczhm3sSI+IOlPQUL7EHu7sCFwuTbfWvI5zfoaethsqqRWdOYljR/NpY6kFqwAU1Ohyzr5rXWKhMQB5Cq6gJ/NYO06VbNl5Fi5fXgHXpDVzsMHjss769eqaEkXJsFTZV6mjUvFx53YEDPtPxHTIVhi33eoLZySD87BvV9/0kUEELEPnOWUwEGpqzKOw08YCsxUN03scXZA7RdXDRaCplJBPe5D+RFOG5vhZF4dEPFgrOxCW7NvUby+AkorPun9I4xOHI3iFcUqDD9Eq2EDP8HZsz4iQDXWX5rzGXYLvF
 b55JqOGO
 yEHkxnmvuVYsYUtspj/s2jUNKXm3qbJJZ9Mstxfrn4hBcIpSczRfm3PwpyDExIy31kfaW5ZVxVI/DLy1e2cAp+ELxpiVn1mxwTsmJCtxy9bke07Or4j/uB4JOCHw9JXply9mxTrLUls/fW1nDe3//P78OlnVDpeIAxobPqrzGKvTbglWbmq91nwAju5m2aBeVLy9vWOIFpKZ/DqYTnoEZtaiwqtpLOfYqTSUtUEo59mxJYRmzFZghsS0LuXrJRZW8Sjuvtze6X3YFomMvIPkZziAWfnKCC5Q2eGVIczOIZkhVvbjOwYW8j8ualxCW8yR+O6Odk13yKd1mMXiAJdtSjk7TH6WzwbJ74Er5n4frdYDqpJEzEOlxhf763bW5JMWvPVS7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bo Zhang <zhangbo56@xiaomi.com>

If the following condition is true,

        if (min_seq[type] + MIN_NR_GENS > max_seq)
                return true;

then this one must also be true,

        if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
                return true;

The converse is not true, so the evictable_min_seq() check is
redundant and can be removed.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 50f0bcf9576c..a276560bc66b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5098,10 +5098,6 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	int type = get_type_to_scan(lruvec, swappiness);
 	DEFINE_MIN_SEQ(lruvec);
 
-	/* have to run aging, since eviction is not possible anymore */
-	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
-		return true;
-
 	/* run aging if the preferred type is exhausted */
 	if (min_seq[type] + MIN_NR_GENS > max_seq)
 		return true;
-- 
2.34.1


