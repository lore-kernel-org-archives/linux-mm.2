Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F34606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b+o8Zs4u
Received: by kanga.kvack.org (Postfix)
	id 033B16B05B6; Thu,  5 Nov 2026 21:06:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26046B05B8; Thu,  5 Nov 2026 21:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15BA6B05B6; Thu,  5 Nov 2026 21:06:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C53DE6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:06:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58E1D160718
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:11 +0000 (UTC)
X-FDA: 85403054142.26.9F5EF9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE6E440007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+o8Zs4u;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793930769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jgnNWSf/GS9C16/6/oW04FCJlMaqBDrU/5PeIB0ivY=;
	b=yGS0YlELljKZagQgK0cys3zXRqst/2GGSnK7zR4BEmcmk3XCA/h4/5WBWkT5WDOQvOhjPn
	wh912eJ2sp+niwQsV5kiw9AGi9FDlC6AQ9L0AJcMXzXWeidfWTMJjW6t3I8/r/8z+Rd+dD
	cEAwxvNJHmzxvOrJZ5dESgMuBawwDgw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793930769;
	b=1jWCvb+HhAos2+W5Wcbo+wF96u2cGRxyl9wQ1e5HxCcxf6kdqRDNN+Vel2WoF0hQVrkwEk
	9t6OtxDON0hIvwVyvCoTre6VQ6oh1Q1IiQCHb2Z2aom53xXmGi9uZo4JNeP0SACeFYpxp3
	LSr5T1Q4KrtqbJwca9thQlgRjuJ1PvE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+o8Zs4u;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3088041440;
	Fri,  6 Nov 2026 02:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0EC1F008A4;
	Fri,  6 Nov 2026 02:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793930768;
	bh=6jgnNWSf/GS9C16/6/oW04FCJlMaqBDrU/5PeIB0ivY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+o8Zs4uMMohaqHf7oACOGb0O8r8zWS4hxH0SNbME9OEiZy7vlKSf0eARVaV3hPGv
	 h5N9pho+5C5Fd9FRKQhLjil2jCUc+o4JKhd5YqrHUF6IKs4DTFhTaVJJnOcfjpZ3VK
	 5IivQl+uVEnqNgNhqCLNNuu8xDtME6UkHej5oIxy7IooLMEkT+ul1GSVulir4zl5Xs
	 0VNzEM1L98djvD3n2WVDkyunVZ1hIvNnpye9ao0H9vgvXMpxOWu1Wc0K5oz4O8Tq+A
	 SKOD7w8MhNYtSu3InvWw1ZK+bjUsdVNPh+WTa96Ehfosk1VdH4byhqzk54mXV3ngVk
	 KIIt2U0cMV5Qw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH 3/4] Docs/mm/damon/design: update for age_ms damos core filter type
Date: Thu,  5 Nov 2026 18:05:57 -0800
Message-ID: <20261106020559.98352-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106020559.98352-1-sj@kernel.org>
References: <20261106020559.98352-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE6E440007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gjdkh9x568a1q6xhpbt8f5a3fzri1ksg
X-Rspam-User: 
X-HE-Tag: 1793930769-509681
X-HE-Meta: U2FsdGVkX19KDA657kB6YeTvkNHkJaKna+PS/K/9vMr7XbNKLKyUmiQtZjPHBs4y/1bbwfO65Mq1pOQRBYUffaazSpOCU9C4XC7Frq3TqVjk5i45JNBYsD06PJK9w24JvGdYVwDiqzfI3IHHungSwKK7P+GXDe7q5RlKeTBCf/qK1trZEG88u4+4Cd1nKErGrHF9itVvM1GijEUajxNqN0ODIm2uXZJmDnHsfy7cCEHf+juzsMHrMDsOMKmHA/BXBePaJ3PvWChhhkG9NGaa6LFGqCfj29lt4kBqe5sljJi7Y37FxM6KO6YsvcFuw6eD0yixjJkUshk+1cN6I0Hs3g7USh47gQKL4ogTzJ7Lwb3NeiDiGwC/SUGEN5ef6oJoxALjChPnHz0WSfbSZaX3Y9cxzonYhJ4BNe4ME9dQ4HC35u6rqe+I0s6YAXDlfWtpZYoqGX2Ukp6G71g9Tgh3Sa/Wli8tTF+kaJzKygTh1hayjaMDUCtXwhSwU3NTYtRlv7mLpBRQO51gPiKk6RBtJ/6S1LW7vKX9AUcyvqqCcIddEvxUKnERzCEulUNGJhdA5FwktNi7QftETMG6IkmFmD1hqzjOKDDrWOShNqvikzLp+6hYgyBFZZP798IjxDdrkKZdwEmQKW01WXLm/E4hVsAEgS2Y41/oDVnbsLe3aredFX04cgPVhyiKGHEsWkZH4ZiDC/AcfwRaEbYkAKpQE5lTnC5Q8k2DYIJKilMHhzueKoWc/+bNPXo3Mj31U/nBqh0E4VQYhQ+gA237UVaCIBET6iFFPodEtmdsihWWQhZ6OmtIoRqLLWzilXSdnzplyuHmSgmUpPr0aXpAdgrYcSM+pcX0kvkah0xQQcb/xtWT0HhgCagrCX7OqwG0nejIw7cSWNWGNMv5UmGoEbUTybzbP/nFoIv0mP08L7c54ugL6F9wdkH+62aLrT8Bjcbnz/YbcLPOwqiNiZkXA8s
 pXZZBuwz
 a7mFVQTD7ycrNAnqcdhdFrYty6qFrhgPKMCuJhs79dAb1UIHgm8vioJRYkAm+MUmOSuaDfoBBl6HBnc9sz9ffCWGqhJxf9EooB2qJE1FN9QvWw/CrLPFVTFWGeIMwkFSziJOwwHc9ZE9WIM9ZDuoCFJ4KJneUq7/iRc/MlHHu/EvhWlWhp82YuiRXbWkNUX97BPp17C6Z8K9MT2FGOiISdVGVrZCDAOzYuKjkO+nhEQIFA7Vyutm0uRlZBbK/QidJ0HMHGYniugcjn0GTkiYpL9qzSMUx06WIc9m4gKbebWuorBHurgJMsxIoLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly added age_ms DAMOS core
filter type.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 0689fd48446dc..8440c4954090e 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -838,6 +838,9 @@ Below ``type`` of filters are currently supported.
     - probe_hits_wsum
         - Matches to monitoring regions having a given range of :ref:`probe
           hits weighted sum <damon_design_attrs_only_monitoring>` value.
+    - age_ms
+        - Matces to monitoring regions having a given range of :ref:`age
+          <damon_design_age_tracking>` value in milliseconds.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that contain data that are not stored in files.
-- 
2.47.3

