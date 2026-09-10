Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2245FC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE346B00B2; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3D96B00B4; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7486B00B2; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63D236B00B1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18587A4FD6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:44 +0000 (UTC)
X-FDA: 85198068648.17.990AEE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7517A4000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exa9FmDP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exa9FmDP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050162;
	b=wEuRoqxrJ6W3fVqcVipkmSWgj20Gw8hTTq0Iks8DtdPvP6seBmuLqNBrM1a3j7P85yUZ5Q
	K2/6gIaHkCWrJrA9EskW0ZWsysQktQ3InY4mGpXAIMJPZ2F0vRCN0/5XYPgzbhCIA3PhTi
	NmeVBOReFsZFo9pZ8zATCPfd0NYo6EE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ujxj5yZhRYtIbo6ExzhErsIpeWFwIc8YKBiGwvcIFOs=;
	b=AhaxkxemwTUzkDRXLCcYdLnHoQbTHdqI/9GbgIf6GLNx8TzpOxBE0LQrRa8eC0ic/emMF1
	rnqMBhuMx5PoCwx50xj1rB8slJzvcpZxxJl88J9viG7QqogaeyDUS5KjErOHc5NVbHkGM0
	EBbb57+7MzEWlbxtiZlpOdn8YJyNN5s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01AAE60202;
	Thu, 10 Sep 2026 14:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A471F1F00898;
	Thu, 10 Sep 2026 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050161;
	bh=Ujxj5yZhRYtIbo6ExzhErsIpeWFwIc8YKBiGwvcIFOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exa9FmDPuLLk4ySV5zRZ7Gerh+miD0YW6ZjX8DHUbTeacEm9wEPc3ZdGifHJdGhgu
	 ALqujmwfqckOlyRgRWXe7vIFgMKiK62VmmFESwk+0+8VMaOWKtZNYEVwws4q7+7qXR
	 h1/u4bL/i+kkpLKjYeRqXWrH7L/JMk3+0ZFxRZu2F03aaRMyvoREwRhO7AWvWMkf08
	 4iXbRXN+7p5i+/Vad/0w+CmXJEVQUdcvw93OhvsdU6fh9pg5z+gspXL4SArYjzrp+W
	 BAVLbSf+QnS0QeMSLvowlhlJDft2bq3XhZLelUUVz5GjShthroAzJrUA/5eEg/jRCF
	 ugLPEz0U7KciA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/5] mm/damon/paddr: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Thu, 10 Sep 2026 07:22:29 -0700
Message-ID: <20260910142234.171562-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910142234.171562-1-sj@kernel.org>
References: <20260910142234.171562-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7517A4000D
X-Stat-Signature: cmq5mg31uczkzxcbdbqhyypont3ey8h1
X-Rspamd-Server: rspam01
X-HE-Tag: 1789050162-68920
X-HE-Meta: U2FsdGVkX19eeLvnQb7LPaih/OW+aUi6UKrtJFN7sopEVNYMegfv2rYlNKZ1ulq3rlzV+nEbjMpAiO/ExmBYQNxsJ4Yt7gxvgcDUe7cutY5dkRmgEK33tulEH3w5kGTeEe82aob0NHp2jO1IhqqxMQDm8F7LQ2+vz7q1qj2P6X1zsQnPGAiAI40237Yz3i1v6FYKmbc/Ta9s7arRNoXHjKhH8hyxqXkyeiGvG4NSHaA0fQcwq4C4FKnk2gEirXihpcgkF7AQfB8gh/K5fbBi99LBAiHUwn6OZNd2PYWopBiOVekb22fNMgtVyJR5GSsP2jP4q71Vy/QANYtm//2Y0ylVWwdXBGrMA5deh4+xzb04XH14d16KPiT2cU4SfZ7cArmsb0VJKdZMihn4v3TDTtOY8pRah1mzZ9CxYztbr8goTRWyB0EqZ7Sg6mYOPWKIA+MHSYCcPdCWZsko0Wi7mA4EO3R3hoT+cayeNKygWlSGP61vQeuKAHFp9kaMVff4AQ1dl2JdN+t9smof/VIxovLUy7Mm5yCrP/6ZHnJbpuhlzcjrQ3xd2j5IreHXwX+F6FUB8T7vcjL1PN4L/N53u3MTjM8cBy7s9yaKzGCs2Fv6mkkQbbQDNKPlmfmkry/AB5OMBK9rW7iy3pVbcWVeAx5w4hmcYdFmQQj8Jw6kUoTkeY3uxYdeuW09C/jkNLc6Ii/4wdfYSWotLCEGja1gSAs/aCIfQFaTYePGsuZD5Ku+g6BES0nZUxMEIEmhr6Aj3CPeI4oWmnS+CHV2u9BHCy9mlnxTTI2X87K++VvZUk4kKf78BAAixLAxlUMMCLgOeZ8BfgKubRJx5IVAeROE5jaI8DS+tm/jYfL/hPatM9tgHJz3qmqxqbH9J/JA8g+S8GGzJpy52QnmtA5hGr68MzfEHnf/YUhTTS3+B3B5/6aGM4l1tgv8s4Fz6Nya8cyj0Twxbm/w7UPRqswjUMi
 f0YZuXd1
 nkcg6771eJIZ+6/5BUZoNdLG5VYxHw594f4/aYAzZuQDr8roOuwihBSWDbfVqOp1fS+wmLMhuZkKVi2CouUWlANJm6Zuiqy6ewn8/xUwRcUdLkfc9MVYOoVm/0BvFQ4RB45Na2zhRPrsp40jxvGGgalHMPzJ96iwo17wP3E29wZXPFqprHJTQAFhlQsYeM+NopQrOZSnOVyNBuF5PxmFUmh9LlvsIEYHBkVuOlCF4vTBoIP1yoFbs1Pat3/WGzE64nf7d8K6Xz30g297VorVGSrEhqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement DAMON_FILTER_TYPE_PGIDLE_SET support on the physical address
space DAMON operation set (paddr).

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b8f4d28165dd7..5abfabaa339e0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -151,6 +151,12 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		else
 			matched = damon_folio_young(folio);
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_SET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio) == false;
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
-- 
2.47.3

