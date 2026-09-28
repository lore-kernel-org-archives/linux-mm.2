Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CBAC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CDA96B00A0; Mon, 28 Sep 2026 05:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FA06B00A1; Mon, 28 Sep 2026 05:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9CA6B00A2; Mon, 28 Sep 2026 05:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB1D6B00A0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:34:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CBC940159
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:15 +0000 (UTC)
X-FDA: 85262660070.19.CF139AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E7C5420008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YwHxvgDo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588053;
	b=R7nxs5XM8NkW0FAmnK+778bfqNxVGCytr9xUFsjLUVI/nCWzqDyvO7k4mpzcF1gJqlrXjZ
	Xt2reMZwj4QvEY7vEcoX2RxNc6Sq/YcsAQXSg7nqdBQH0fKCFimmDkdNNj0jWoSiLwTmP2
	OyDHng8JvTrpjX0IpZtrd0TI5JRJUv0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YwHxvgDo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mS1OGjGueuh9xRDDJo/iscVAdMoJD4YdolHQuoVSGCo=;
	b=F/8gWRhzb7dxuFj7CRsOdfkZUSbg+sDJN4Ty0Ye++7QvIVb8zVM9rUjv3OY9MA+tC218r1
	zThhCP/AU24TGpL6Tn2DhFRoSrEFtzhuLwTdG22oV7fj6CoVH6WIdAm8yv6nhwHO7N4lCz
	mpY9zsOCcJ994HcDDbjpJe5TlgQq41o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99C7A60207;
	Mon, 28 Sep 2026 09:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55351F00893;
	Mon, 28 Sep 2026 09:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588053;
	bh=mS1OGjGueuh9xRDDJo/iscVAdMoJD4YdolHQuoVSGCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwHxvgDoQ21oiFsFvrD/lZITqVRSYeCdA+z6xl6iE2NwnMX6y32QzRBxi76Ccosdj
	 OH82NC8PqhlbRRi3DaAMY9mqjZOKGa5CpKdK5YOEjZmc9z6GJdT7CfTCZyJONGItEb
	 An2j1Z4tgL898koWQyRNJe9U9M0/ovbqnbVr/l0UXZEgjCQPsaPJngwxGMidwPVIT9
	 3vN+6i+4fFGQFLORkAmq3XsLuLfEr+ARUpQbr4t6RZZ/Dm4fT5gveKHy4woMBQpRm+
	 IknjOdJ1vm3ExqsapPzLnkF+S6FbAB9RxscezYN2G/SPOsgp4I+/QeooFtkW3m2VRX
	 QEdpU6XnLO8EA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 8/8] Docs/ABI/damon: update for quota goal metric complement sysfs file
Date: Mon, 28 Sep 2026 02:33:40 -0700
Message-ID: <20260928093342.16584-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928093342.16584-1-sj@kernel.org>
References: <20260928093342.16584-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: jyw96aqaxcxqej5i1zoomyfyn7biesii
X-Rspam-User: 
X-Rspamd-Queue-Id: E7C5420008
X-HE-Tag: 1790588053-513504
X-HE-Meta: U2FsdGVkX18mgiYuYHxdLjtV/q54U81aMsKnPPOnQ9D3yfVTzpD/86LC5C7XQkfVc4eUUprD6Oj9W+8rGQXwWwuJAXEoCqPGwaFwz5OxL3uwwHv7Oe9Lfh5WTUNJnt7ZrMgP12z+1E/GNnLihWJygryCv6fN9+U6MBp8hRhvd9LiNw0SvCpbYr2sx/Y7Ha71xKbox7DmQpIrlKNX1KarNQ/1eWtWZNPntsU2jnO5wHLEe2Sq1FuGSJAEx1UbAi2z+t/5Uf7kFIbF4Kgam4hSKfRxktTRYMkEKcCExzwtsrp8jVrGklTX9cBmr3z/IIuVeN1f988Is9sGLGwAqu119qnzK86Q2OGVgv0dRGO6f/yLFpFMsJK4AhPPhmdVaq7jqXPXzdUpe1RVRlYEbBjAEiuokZTxaxKB+XrKGIU1jLw8mrvHpGh2r/j1g67Jvyx2lAkuyiDDx+4yFde5fUmLVnu3DnXECuiRltnRnnZBBt3glv7bQa02P9SODOkbNbgXPR/QisWS3AA7834YyS6rklQ96koCpuXTwtsgFOdaHOvZn2lLpDAOLAurOEsgrNpxCPqnt56KJiJ4/v4q0ZEXdSGUrxkt9fjoSFzh9TzUGG+wW4zONqj9Ff5skgph5TgsPe+blqCVAob2lihG4D9Bul2m17rzdekud4IU47mrD/imbFQJNdDAteiK96pB+jy8C13QHfzJ3ItGPeG3ASkIH1lyEEzsxP4IBAcmjcZuEpwduuOJk14yG0oFm/NVnhvqSXNclDVqILvV+pQVLskbTNyvoeeRZFej9IjpxRNDHTUbsls4ByMg4/VpwpjSN3QDRfnRuz3p1bqZmIjTz+Kbpl8hJqORCEvVvXZ1S3DkP2AdcUlzmgGCTqEb5Bsu8+hJyYfUwAOhM8TBUKfLM2qK1NvUBrftS3qa3GLsYhrT6vKWrDY2Fw7yKjJ+NjXQJq7Mxcm8UcOGfzl6tvpM+m7
 SNvmdwU5
 3HGZVo9E1mHWCBzmEknDKn5B6cwKbHCNXRHvETTSyqxtENP9x2V4CZUbUjyi8r01WsyH5TVfkG3B2CIvI8LIGdQgJMmoXORjSKo+3MsbHt77G870+4HcdtHeWxbpGNgmi2iqtqmGziEqU+cmBjeeBiRGFz+b9vsDuzRKIOUg6l/HP91pJWrDtHqaYFwMJYD0Tbk9uNgLHdQ6q39OqsAM3NkyvViff0SWY401FZrv4tnuNLQEULGmJ+X+dkWLaxgfo01uZslNuKwsCJGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added damos quota goal metric
complement sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 55df688ea596..4acb2015c2f4 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -375,6 +375,12 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quota
 		auto-tuning goal metric.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/complement
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets whether to
+		use the complement value of the quota auto-tuning goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
 Date:		Nov 2023
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

