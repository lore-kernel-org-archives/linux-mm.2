Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AB8606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k+yr6W27
Received: by kanga.kvack.org (Postfix)
	id 83CA06B0665; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610056B066F; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0A66B066B; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2131E6B0669
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6FD6A8277
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:22 +0000 (UTC)
X-FDA: 85428937524.25.599D152
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 27EAF140009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k+yr6W27;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794547041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDPWmvInaWp2wgeM0od2Li5jTmlC0VSnDu9Tp3ujlp4=;
	b=Ip0duQ1aRLx+F0gBSaWIjpwX1cZ7qnEgGvGCacrf5jGtrLnp5ZYgpfzd2/+qpAbkPcEiXD
	wqcQNURp27SEjIL2lZ1q2CVLPaSioYx2EN+dpZ4i4PK4Bgi0GMjLeNmqEGL85ZMJk1pTy5
	u9mvDZNaCMJLiew92w2xQklJU/NZvf0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k+yr6W27;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794547041;
	b=yvswqYzi6dGuCG4/Vd912l2/Hm7uWHfUwSV8T7id/RHx3oCe5BQOTIuGOQa0FlfHF71r7U
	GQPViVSpRhtMQoZkwNHe2/k5nCCuoTOVYUjo0UUYy3sgJQ2g3KjteUAhEBt43M92yo+PkY
	HMARJ5J6nVjQamVbMewLhOW9npKTTdI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95D8E609F4;
	Fri, 13 Nov 2026 05:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2863B1F000C5;
	Fri, 13 Nov 2026 05:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794547040;
	bh=hDPWmvInaWp2wgeM0od2Li5jTmlC0VSnDu9Tp3ujlp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+yr6W27/wZKaPZnZaFn/PbqcVmbapL5L9VOqS2LQ1Y/ufYLqSwa8bb5psMelW6nd
	 OzuBREQ2t5tcz0cd2agIsS+Z3j6rqTpCKT2ta1PyFTY+6ZzU0P/rP8wbt18Ki6iDYT
	 pZyYw36lhgjICmVcRdaWGwRhwOEkIPY5org/KFyR+vKXxtArmZc08fbyaeeOGIO6dv
	 ws5Ys4ETf7CSEjHKdPVSeJbPsDHJ1373M0zc4MSoyZBQkmaQn8z4WhD4dTo670+jEI
	 fDdzWnZK0JLlrfFpNfez4NAb6iHqNthLYxzoOrDu0LBjiiP5mgG6X7MDK853Y2TlND
	 VQWR7rU0VlfoQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] mm/damon/ops-common: implement DAMON_FILTER_TYPE_ACTIVE operation
Date: Thu, 12 Nov 2026 21:17:08 -0800
Message-ID: <20261113051711.89274-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113051711.89274-1-sj@kernel.org>
References: <20261113051711.89274-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27EAF140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qse6eatrd14y8yugqtc5hg1on3hgpz97
X-HE-Tag: 1794547040-260745
X-HE-Meta: U2FsdGVkX1/TdwRxjymlmi7BYcFy78kMpSMwOzZ08zmUvGQHleCnR4a56Dg6iRInIKjHvx9uamsoQbRli/JlBOTFYe/dJFhCc8/NeeLYvaDT9Nsg6Ue4pHiDhReKyz8ZKJqQt+wASIYCzkyW6WmNdQHiR/yTgEnspWlOCM3iPOzbGP14zZX7U5FMbjO2dGrqYshTEY4UgVLPbSi4Mm/jUNf1YxX/syKkmaIkXZ8cM3NH/yZ8L4tlhOBpBxMDE8non76F5efCAlfLEoQsMidIZcG4cwtA2pSUZg7+C8c2Av29zsvJgjcHa3IW6Yf37JXNp15bRYJSZHFE4zmQdGRCIK/eQ0gaPTZjmz657y2UMdK5HyOzwFOEiDwhByq2nCFkBdu+7u/blAZ27vJEF3lbsfyvQt02I/eixgZCutJskY9rUnKUmi9UywDKoqmAV1RSVrMFkyK0uCAdOv4tdH8f5ibo6PXZAuOVGX4nhwPEpxqjDbsn4T4NXc4OX4svmW772+P6g0WT+MHAAqw8eTuV/0D2lhWOU2W9LxgroBydsC4b6qZwFvXXeLjjEejOgMxY6sCAqPezKZF6HItAX7hyY8q7oS6dXmuqcjtut367oE5tVNiXp/iiqHhT8RvLyvWR/hshiirV4chflsowXlqKnemQwqH5Fr5TTkReUl0PhGC/QJ4RchaKQXU2ZlvHlVMJZJ3IuvN4e2VzNOLfJzvHjtFyeitSLvu60KEKpS+S08Zn9q8FZK6bCZewIeAf7kbVwOsSZJWijY4GqVNr7ap9vQC292J8+41CbJaRmuRv3Zw9lvrUZmjoO8Dz+zDoq1T4tZqjgY6NHPZqBgaJgSxZop7LEsmB2JPBJdhuJgE7K/juF6cHoJyg4y4GHmVaLkrUln0rYYdu7Rv13VXd6Fq8+T2xtb1jXQR8a/f0+9bsOp5cWTPDrNqatxgNbi9qLURGQIq5wm6nwY1mgU70bGm
 kkLgqlRX
 /LVmOP/OVlqZWi7GPGGfmpSmIrWypFSrrgtb5Mb85/GtE5UojEonpNSsTR68U50jl4m9DuK8cdRjBSmb5fCXep9puFPrCWCbJiOUNEYvhOVhMFFBfrZFH5KiQ8fdQajyC8+zSt77TF6E2EyesfBOKaJVPvgnwkQQmXEoEafVCvulchlSS7eVp72Ra2UQ7EMvpX9Jyw32hbS7aJ4K4pA7uMluC0/FTBYyZMezI2Lv0uaOBHpTYJ7Y+XpLL/n0Z+FGyXxT1TsdjDwyIvTRYKzBhoVkWeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement DAMON_FILTER_TYPE_ACTIVE operation.  Use folio_test_active()
to show if the folio of the given memory is on an active LRU list.  The
implementation is made on ops-common, so both vaddr and paddr gain the
support of the filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index b9571f53e538c..2216a0023154f 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -574,6 +574,13 @@ bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
 		matched = filter->range_min <= folio_sz &&
 			folio_sz <= filter->range_max;
 		break;
+	case DAMON_FILTER_TYPE_ACTIVE:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_active(folio);
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

