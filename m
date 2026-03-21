Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 094D81094489
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16D186B00EB; Sat, 21 Mar 2026 13:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BFB6B00F0; Sat, 21 Mar 2026 13:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25146B00F1; Sat, 21 Mar 2026 13:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D67A86B00E8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:54:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7281E1D800
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:54:38 +0000 (UTC)
X-FDA: 84570820236.01.45D54E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C45F040006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:54:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Tgu/N2qJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AZuHclUN482UjzxOhblK2W1ztEa214QqMxVy+frVKk=;
	b=SdymF+HhLwl3KeStt+dy8wxVZioVP9mh6jpJz26hgt0lhA/pnOI8BSaDkqKp8EWec1w2gF
	u0Bbb3NqI1fEOP5EgWlguZpzkF2spZ/Ye0Yz7ojGxgN3q3DuEEp5tlK01qTRj5mOGn3XXz
	e571lKfebZRjRe9gy/6ElzOICcj+wiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115676; a=rsa-sha256;
	cv=none;
	b=HJzZbfYm7K/j1isYOgNiTNy0nhK02jHEcEJDqWjoEvYsWWf3YPbI1RGqwn+/xzh29AHx6e
	Iifd+ATZZZOe2+jo47g3s1tne2UknT3nT3nCjEvZW2FNOfS9MQDRmkRVoYmjuRl2VdgmXa
	+qSedjbsDC4Ez74BiBovik3IKbRqfT8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Tgu/N2qJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2439441B5;
	Sat, 21 Mar 2026 17:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC19C2BCB2;
	Sat, 21 Mar 2026 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774115675;
	bh=kqdEPb3iNN0fFsVK6m3M9gMdlpedC9f1qzwxe6K56h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tgu/N2qJidFELa4r9BzD1WwU6563wFyYLpFeqzAZwcZHxbUQJikNm03IhG6ga4O0P
	 4gkR7H8AeiwT7Q79DF5fBsXfw5MoTmKsIriNGT+uKc7s2Sr47yau3UxeyboKCyUNdA
	 VHVtnCqKX7sB07ZBJrzXivgN8FdeB9gmCP2WUdCom/uNzGv82jAsM3B+kH6UczvgrJ
	 K8FLKphL9mP90Y0th/QZNJhCYCQoiW1KQhQ32+FNA0GXtd2ARWr47W5nlxXUDUhvow
	 cEFGjDgpkRYCMhjQLpwv7cpwXYW4UxUZXNvMrDeBZ0tPyNsHa0UdkaUZxRzrajinW0
	 AWj8UgrMbuYww==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Law <objecting@objecting.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/3] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Sat, 21 Mar 2026 10:54:24 -0700
Message-ID: <20260321175427.86000-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321175427.86000-1-sj@kernel.org>
References: <20260321175427.86000-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C45F040006
X-Stat-Signature: ct391j4n58nc54fwbm7z48xecxzkw5w9
X-Rspam-User: 
X-HE-Tag: 1774115676-992464
X-HE-Meta: U2FsdGVkX19n98rCtLrlWinbu6Ih2SS6zl1rxzAIkElQT9TTlir931HzUBxweewCo/b7iovhoU4JrOTvRaqmrs7roabCy1tOhubHJyJhEsPNDooLSe6cE3r3IVGMRKbG9KChjuv6XCn7/5+cy5nasHKtLemN3rwqPQE6s8MJ1yOCIeLVFBhrWcduGZa+QuzsOM0YSpto8dm1kBcmDS1vMSdLk7eBvKJBpfn4Hu976R6g4a3UFYxL8mvO9/03jsnxcwOVRZt2bjTn96HEHl7UZBf8GBuchb/KJkEY7JQpuk0xfdPUD2h2CrVz5QSikNzmNZOsb6Rl7hqqyY2RVUfqgbSKY/rtXenHxWJ3fzCln3+VyZ3lUB4mdvQmiyJ72laVAnmhx7wwYVzRKIAlta+374XBF7/HBMDLt37PgfSCbYz8O04hAfcyUKTcyf+s51a/jpStX5Xj6k0WYF0nB7sLwIPvGJt+pTRHowfif4iK7zk2RhZi7blpqhyRH58IVZbLcFyspCln065wUowFqY2LWQTOJIztGSsb2SJ6hcQc+5H24hxq9LIfGRiF0LD9Rt91N4IrwGe/KqXYGhlNpO8lAGf3qVv+dc8UbFJ702gj9OCroOXtjHVuDlIAwbOsr/IFPSzLYqJCZhn05ye04jVK9XTflKq3V+JxG4lM0xGO7X6KJjB9lJhWF1QW34CpTRnv9T/fkufDyHnIDoA1lUeTR6GwWYVDm3CzdpLA1O8VAtK1DHtAScQBVI+6B1wB1NYyayL+g+zZbzT5oUCeEQoKDPdSdsmyq2S8IQg901d3jrq3PRM5j441gSkxKeLUhrHea47uH7NC5S4NeWpK5IshrCefwa7eBXcHhqBmnkqUVbDfPAVe+3Rymc66Cjocgwp17fZ5SZPAxFWxoo9aMFGDCDQmhQl3Mnux+4WRqTrIqPOG8NddgoUS48fhlfLOGHNkW3hdO6zNjn9oZD9sXrp
 aSR42ENv
 B8gOkh/5wV5SQsLxzIN/vKlBhXvinEYIRQRu2X45+x9BPAZ38Cvmck5ePUsFTbLGR86fmfPnwshEsUZInBnqPqP35WGod6NzOB0iFzNqI+XPUeW/TbWMSe30mvQ/nMYPoG1JL27tgl9vS73D+JBN4UaOlVi6Y0y2ST7AQ/4VWkDp1jt7Dv+FxU9Yn5X45cg07Q82d1vAOBR6tcHDCZCHMKQWjX3x+FANl+kSTfd830+nmHItxiaHHfrG7cpwYvdsl4Z8/WSgk5C7ygjOnggAqnU3zHlzPl0lA3F9i7fXivKZhMNeVgPUn46Be2W17G3yR83X4+KTV6LYmpw1+ZAzx8B3BRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Law <objecting@objecting.org>

When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
param_ctx is leaked because the early return skips the cleanup at the
out label. Destroy param_ctx before returning.

Fixes: f0c5118ebb0e ("mm/damon/sysfs: catch commit test ctx alloc failure")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 576d1ddd736bf..b573b9d607848 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1524,8 +1524,10 @@ static int damon_sysfs_commit_input(void *data)
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
-	if (!test_ctx)
+	if (!test_ctx) {
+		damon_destroy_ctx(param_ctx);
 		return -ENOMEM;
+	}
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err)
 		goto out;
-- 
2.47.3

