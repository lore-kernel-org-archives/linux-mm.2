Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13635C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DCC6B008C; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24EC46B0095; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C766B007B; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEF426B0088
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37935C036B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
X-FDA: 85028522754.04.A39DED1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A2F38120005
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0SkmNCc;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013355;
	b=SfxS9WZQIgq0+fWkENaVgVLn/g5WYsJTufYFpoPVvximpXWLhVfD4Lae/zMRES1LEbcI+2
	rlnByvoprH6JADcERvSmtivbaJL5SETgdsS3fP+THD+Ig5i/eDkatPbjG5UCYGrTyXbM+H
	Zle6W3A9yypf/UgcFPrgOmSu5UuWubk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0SkmNCc;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZDCgXboPWDjpqLBgpT6yf0F7vtlbLEb3w3NI8ROd0U=;
	b=Mg+NB99Wywq+GmhCHPwHqpVkGm6qoA9F2DxfCNonlY6GNiLN8UkK/HTky0zZm0exhGav/I
	1PAEQEv+tVemAZ0rD3Tp7Qgm7z+BYqM/COCEHL7XHUkcm4Lsp6fiVEYAxMvukPWfBL5VYG
	Jol0bfgDpVWIVEFsJVruN9a/92YQIPg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38DF660A97
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C341F00ACF;
	Sat, 25 Jul 2026 21:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013354;
	bh=GZDCgXboPWDjpqLBgpT6yf0F7vtlbLEb3w3NI8ROd0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0SkmNCcRAszddBVfeaHVKD67PkiqdMZ3a6juJ0HvdMVBb+c8TpvCPILa4l3G8I2x
	 xS+awYaBkiZtMpjmrPR/8TQl3ysqxjn8MsG/Py1Invs8ZwHhwuOFlXsxsEHme1Jknt
	 Q67b1KaQlKN3Oi3+TGQ+YzvK19DFe+a+dds+71zSQjLdg/WeTXLd530CuaaChSQAnG
	 REer/H+zAoYSw4qvrZU9cYDLvVp9PIos/skkMR/9SK5b6wN7Go8ADVeEuDI30Hlf07
	 oeOml/l39fh7IJA/fkkaRHU+rIoVNVYHu1TpekEm2YBiPMKEjsp2Bxt8oFrX4z5g9j
	 1tG/ItmnaPGNw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/17] mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
Date: Sat, 25 Jul 2026 14:02:05 -0700
Message-ID: <20260725210225.129944-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pmfdu1m5c4qcx791rompnczsyi956wa1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A2F38120005
X-Rspam-User: 
X-HE-Tag: 1785013355-202066
X-HE-Meta: U2FsdGVkX197SiOIPG97oG7Pal5fgtoturG81BwGmCE4IvdBe2wPfLzBXNuJeGs6o2HGyRSeEGU+CWEnwfrGlPyWpL6CsSO2zA7yhRnu5k6hslxDe8aMjn7OpGnHweUT6W7lYn5dytPy6cBmvJ2ifoylGeTGREZJuZvrKKooHhVB0I0ikzdPapFvAmMwCdz7dzVI8GhUB3U22gE2k4iFAi5fW/+Qsi0FHH6goR0NhgDbQjSnIZYPS+lCsesQ4O9hGKvAvsmQhI6iZ3hKylUKtnsDhZS9iso7JfOsquxGxzy2AZRkShxCVRrE/sok6FsybvcgDZeJj8qKzo8s3wXC+DBHIJ2hszr7LCUqdqzN6sTez5j7/+a+XjXy9EGiMGr2cXSmLYgYej6zbK+Gyc9qA93Fwagu6yhKyocGXAR7mNqP/CAXddXJzj/g5CK+h4CVjQIHrx5PPBGcBFG/9ObbVQaQLcQf7iNfKn21YEzZL+af+deFK8oZW7k2w1Nh7+POrWzkUMhl/GgaVjONHi4ZIjUzp/EIRsc42sn8t+vi3++PKAFeCCt12S49rAgFlFCB8SDhB/p6c7fuRt6VcNL/YjjkJekDtfn4xtT7oyYPNqmBRhRqiq9TGAsB5ZPX+xBbKleFs57JQ7a4Tf2Y596RLQcNQQZQezi+e1L3KBgNw1nNRMXDBXdPvCYcx+KcnZ7wXKJQRl4LB5AllMsUTaiMK2K1fo5FcK5u7Y00wfLIjBP4BCYcYwiJxelIut66CJHx3CMlLMyjgyCd8UuV4+YezclocasiEzTT/Dgk40lPjkKAlhpndweNjqxV1GYeCsz2mA7KGLpd6pHyoe5AnwO0sA56sKMiQiHKnJb+ZDZUVoYe8CBPj6TB6GUYh+0t9M6sxHk94GCjcHd0fFlGoH2oYAPia0Xh1ojqsNJv2mHRB7uhwJ2BIXJQiE78QUyeq3TU+AfGb6xA36RzPqzOkfu
 /hzLorfU
 SVmrwA+p7PNHbRnG3HDLbH3n/6IEiEPucRk0/zvORBO007VKStEIxuvsIvT8IzswgsqlKXMqoetHq8HmFhR664B2qjMOilTH69oYntFZjq0qFIyqmHcyAgAeTVEGWdClJv9VqbkBmk+ynHTWvYXBG6aj5MG5ApJgTfsFgvdqRAXn5Ig6zilv2s9pJL3RvCKbbexpBuHn3CEmtzLKjKxJUFElxtdsfJNZphJeMOjso+3xmQFlUCjTv53WYvDmMa1/BX4NnR/iLlKFcIn9TG9Guj2w/+CBnkFW7pGP1Hq3nc7diI5emQqiDOfTclhrr0KejO74p/P6fDKjy0jLfhvhpPFdnenPP86RqjvCT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON filter type, pgidle_unset.  It will match pages
that have their PG_Idle flag unset, or the page table accessed bit set.
In other words, it says if the page is accessed.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 8ad6ef2e063de..cee4b74761081 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -744,12 +744,14 @@ struct damon_intervals_goal {
 /**
  * enum damon_filter_type - Type of &struct damon_filter
  *
- * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
- * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
+	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 };
 
 /**
-- 
2.47.3

