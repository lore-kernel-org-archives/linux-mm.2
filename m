Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C90FFF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 04:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804D26B008A; Tue, 28 Apr 2026 00:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5006B008C; Tue, 28 Apr 2026 00:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2B56B0092; Tue, 28 Apr 2026 00:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61C396B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:29:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC4C58BA3D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:29:54 +0000 (UTC)
X-FDA: 84706686708.20.E95500C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 67898C0006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:29:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TnmVEeVf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777350593; a=rsa-sha256;
	cv=none;
	b=594Ggu5MHFqx/yBtRYUesjvPbbsDPHyYkxvvu5DF1ZiTT0n9/kddaXcpK5BRJL3ByNQgOP
	6f+sjknbDHthJrccvDJJj3vJt2zDS4YrpmjPgOw3ARRpFHVHya8V3yMEF81P9qVJoxKIBX
	K3zZ9SqTeGKy71NFec8Rb8uMgA4OIjQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TnmVEeVf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777350593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MqE5r5j1uTrJHGZ6qmXmR2/ka7z+i2TFurZc6KgvvaY=;
	b=0egNno66P1mJkYlFj2Vcw4yPu3C5FeEqd2UZrdSA3siPJUfsiq/lxnP/JUiJbMG7SKWkvB
	iEZ35HfYojivoqgdujHPHzIsKybe2R6Laf4yYu8qkhbcSVsTXKkLBMRbOccAShNCfbMMmM
	Umn9SV+paEb5LxYvTiGuhRi1KfO1zAE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CEDF439C9;
	Tue, 28 Apr 2026 04:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE875C2BCAF;
	Tue, 28 Apr 2026 04:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777350592;
	bh=sdIOuHzeJtaYTP8u5YUojhpsDYOu9rOc+EK4UXxTHwc=;
	h=From:To:Cc:Subject:Date:From;
	b=TnmVEeVfdPMWYtEMpVKc4rO5BMoxGjEjOZe3LrCEuY4l4WfQ32Vd3S3bInDxlz2Zn
	 oxWi1aONRu+pSfqpzu+f3HpKbj9exi9PKoCjh37w/vLkFYKhpGQ7paLuojm0M03tcp
	 TzX2cO0QJUkBgtsANS28MED6xeWDnTSPzKZiryzNnMBtMBGXrI/hFl+g6DKrL2Eiyw
	 SE2PQValF7fQ9LwaEaRI4J38kdHGGvkrjc6ilCAX4BFQKL/ombDI5z5ALK2iGMfwTV
	 QPHMVH/2c0HoZepJeNufwnGMG8DgOOSsPMj8MElyvbXpKD0KfCagrEeP+4jyZBF88A
	 WnW1bUp7wNRjg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: make charge_addr_from aware of end-address exclusivity
Date: Mon, 27 Apr 2026 21:29:40 -0700
Message-ID: <20260428042942.118230-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pwk31ghi8gxwosqu65ff3uxxkcj4bdsf
X-Rspam-User: 
X-Rspamd-Queue-Id: 67898C0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777350593-259010
X-HE-Meta: U2FsdGVkX1+ZPRv9/YgCzqkypW2gUIRBKld4CpXCLg76allAoIJw3pcbM0OqS4IHkbLiTJFglpoOYMhZHZb3xekEPs+6Sr5/w0MYiGYsUIlztoBOovuEqeiYLUDG6lL2kDLv4FsmoMqax26QgyKYm4jrDR+HAcu7lS2hC2zLHBfO7UPT1uxa/t18xeC8DufidO47WeHySdXadWQ9TOMlUKhB34JIN3Z+4Yc1upcE5wOuQpijYXRt02UaUbtk9yJPpOQfY5HOG3L5RwSOxpMU8mlQnSf4gaHttbbehSl97R27k+qmO+f2xEoZwE/oPhyNbXcZJ+XIO2sP40iX0E0nQJhv2I7Uya63w945HyLJkiPsDlPv7ILy/XpTirVVf7oPxZ2Z9qaMfjPu3tR8gmq+vxmucGEZpm0l3o2zvNZWzifEGHQyKRiDaXrBM3WLNoU/kSHq7PXMys92QzMCBYbhVjv0q+ToTmAzscG8fLM/wkYLPQNtEpTpq4t5IGEOVvwQ/LTKJ74LChsVhYxankaY9oeLHTHcQB8V680JO3D+5ISQ1rDNYR+LCtdooccCSCRbwX2oeFSqHZoNhd7B+GuRgG7zE6BWy9ae7EqgR6qwFE5aApvNLMjefAFxyu1G+922Dz9UFAucEcm/L5fEV5L40uNaNrG+W+zxS+43W0j8miEyv5T6EMPAF7sf6e9eXZv1Na5tGW3cVjySLNW47Ev7o627xN95k8J9Yr0nnzGr0gp/slckge2bhm5DszVZ51w/Dg44J0wwZcYdWQ/H7/X9yk9KJPy7MBoFrFR2m6vd0stFBIsb81i3gD7F/fkPJm1/YKLTWze7BkDF5AJguQlXIGLVlXGTmSEkBkSZvLaa1Rq59lwFtVIrL9P7Xw8Ji/+yMDupT3wI1G/Fluwwqh/bXJ4/frJt0w+n1Gz9+Wjz+5oqW1Q/tNDLhCLDYKK/SEGvlcy36bqSFWXW+xkhSYo
 NMMyk5cM
 6vspmA7QNlhS6CkqynGEQl8A81Z7E6HxT+r+0mVL6mRMHKMuyZugB4jRRqnJ5Nn1HNH2EZF/828XaAYEOaqpLiSd7494jIycos2VMseuLjzFHELm7SkU0iUDjH4rHh7bNBRZpymAYRW6wVcZD/Gr2Q5GgLAWNA0yW2tHQB7fUS+lZnrc+OO2ge0d7DkipUwZEwsONaObx0VatUZbSbn3Sc4nW+/IFxCB152LN19sJ1qKHd6thRqMoak6d9P/QPr7qWLNiCWTOG6JsI04PgfpDWDpHlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON region end address is exclusive one, but charge_addr_from is
assigned assuming the end address is inclusive.  As a result, DAMOS
action to next up to min_region_sz memory can be skipped.  This is quite
negligible user impact.  But, the bug is a bug that can be very simply
fixed.  Fix the wrong assignment to respect the exclusiveness of the
address.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260428032324.115663-1-sj@kernel.org

Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 278594847cf94..37c9a40d0577b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2107,7 +2107,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		if (damos_quota_is_set(quota) &&
 				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
-			quota->charge_addr_from = r->ar.end + 1;
+			quota->charge_addr_from = r->ar.end;
 		}
 	}
 	if (s->action != DAMOS_STAT)

base-commit: 986c714ac6faa9750e15ccaec72ff2823c96a5c6
-- 
2.47.3

