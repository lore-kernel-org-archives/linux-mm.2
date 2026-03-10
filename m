Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD7CCFD4F05
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 16:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6DE16B009F; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF816B00A0; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0D26B00A1; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A697B6B009F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D80DA8ABDD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:39 +0000 (UTC)
X-FDA: 84530679198.02.B8344AC
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0AF4BA000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773159938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T02wgZ+rRxKQwysPpPfItvTdL46ccI3h87ycEsVRFKA=;
	b=63mN4fmsm4gqM2LuixeVRXH0aF5a1ttDKHmaiJW6lNp1AxZK8VuBtZ8gPTEOgLPyezDIi3
	I5WVeLnQx96dLAGHU1tUPxDxCxdJjHIYCsorLpArYTVlnyOd6/eWc/canRAB/IpVZXNuW+
	HQFV/lP4Cl5BwphLE6t29Jp14g8gdOQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773159938; a=rsa-sha256;
	cv=none;
	b=47gJ7N/T6ILxNmlYXVEBc43IDKR9V2LBPwrGlRnzj0T/1xH8k0s9vYJ/9ECOetOb5rbk9u
	1dt6iuFGKhPIsPx1VMm3MVm7TO8jPpGwR8Pra4gQ//vOXaHGSBZGr/vIQQjMOaU3TxrkZM
	fW069aU4rka533+qelTKdV1PdKUnMqo=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fVfNd2Dg6zJ469b;
	Wed, 11 Mar 2026 00:24:49 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 23EAB40086;
	Wed, 11 Mar 2026 00:25:34 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 19:25:33 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 2/4] mm/damon: Support for synchrounous huge pages collapse
Date: Tue, 10 Mar 2026 16:24:18 +0000
Message-ID: <20260310162420.4180562-3-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
References: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 0AF4BA000A
X-Stat-Signature: ew4yas3t3rg5qyxq4kp7akihenw3dh6q
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773159936-832093
X-HE-Meta: U2FsdGVkX1+CeL6015vzHvJoY9AS0iJg4GeaN1pKb7Voh6nWUQeB6ubI3drE6KaHMKs+myh7uyvD/AEoy3DuPi/a0L2zd+kfAoFsOvK+GXzRS8qV5dNzPJ70OvezUcnci/bhUii6rAy7ZznOdWeZ5dzvPYaQO6GER/IRYZHscga0iVJOYz1iyNZEYB5A30Us8Kpp5EdXfUuSEdVPHnLhHNZvkulgX/G9S/rCnvb8BdPMEP3Uf9xw/D6dt4Fmj8MhXxZoHuaymsp8UL6uogIJY5kdk9P11cpG/gXGku3S1P1f4QipGpKwjk8YBiieyoNxlszkusWKRRCiulIGYKOmb0tjUm854PPHtNllwwV29FuZ7dZPktXL51judQLKmkw2GCnNMjN5jpfvhKZ2UpVDT/xMmbqfoorrMO8LQBRzxioeT804qXiQ2BYdVmDnXITHiG6ZljiZWqNHhaABFl8q69gGSlrwXVAp8igrAh7peeAS5ETMNKiqvfflkhPUEeD+xDNLYsXVD3m7BVdpY5KOk2McrJLxOSR+gryQmthDKjVYAtQO1+9Dz063PN33dxI2shn6DfZ79f1npsjUyI8T0y//OIRLUyTrb8bOJ02/vNfT7c7cYWGm05wZu3LkRK7K2HrfrajjgMfYUhU6M68IueHiRC9MtnPj4TqMKdUbi0znuRYGPTqTjXWRLqaHQehUp7E0Yusf9WoIfllRGHTl2ZO03nmIBl4Bdqll2qN0fBp7N/rA31eVnOx/FZbYdpOU5w/IJNmS0BKmVUUXA1zNHTrrRTvEEGbSLg6XfKL4FB2ZWn0C1Ra+s6zE6iUFceZilEcA1dH1bSXiaagqKsziIw2nh7SA/ZS1tcIIUUQm5d899VMInAyzPO6dbg+70vnHYoWL+bzdPqHhnSYKf+Mm8uwMxKOlDFtSMpwtSfRVXmUL9Ji2JZ/hbOEkqs9rQIcVmEQvvGrPULeBb8J2mIk
 Z18/2xX6
 hsyTqhPcleB6q7514EXxAMqvJpycDOrFOSdYUUfYiG+RgogsV8vmskH2/7wu7/rDEFA7nljqks/ToxjrYcAbusUdn21/dV9d0U5tGNmJNl08El2RK5Djh/x8Efp2sm4WD7gllMjujvusB3xUTRb2b5+AgYzm4suSt34J046yQV0ry26xK2EVQefEQY92BJeFIVAcLvADCXHHPm7XOZjrIqD3u1QeB3qXC7bdcmZtgOeGZ9DVhlojayJbs6v1vOXTvfDepMFET9vDj0t07Q9jZMs7XjYn3Ubjt5oQm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
---
 include/linux/damon.h | 1 +
 mm/damon/vaddr.c      | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index a4fea23da857..a9cf17b9e8fa 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -142,6 +142,7 @@ enum damos_action {
 	DAMOS_LRU_DEPRIO,
 	DAMOS_MIGRATE_HOT,
 	DAMOS_MIGRATE_COLD,
+	DAMOS_COLLAPSE,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
 	NR_DAMOS_ACTIONS,
 };
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 729b7ffd3565..36791a9a1094 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -969,6 +969,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_NOHUGEPAGE:
 		madv_action = MADV_NOHUGEPAGE;
 		break;
+	case DAMOS_COLLAPSE:
+		madv_action = MADV_COLLAPSE;
+		break;
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
-- 
2.43.0


