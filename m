Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A84F606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gnoNxGoL
Received: by kanga.kvack.org (Postfix)
	id F3BF36B05C5; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F476B05CA; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1BD6B05C5; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2B86B05C6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F145BC0725
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
X-FDA: 85438492818.11.E3EF831
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6DC4C1A0002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gnoNxGoL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbZTCynxDA8qlWzkpFXejL39caIBFfSg2B35l700hQg=;
	b=6ChsHYQPqYUSPZUbohOdTgJUqphT7vXNZI1qdL0SGEHzbWGxlEJbPSjexEcOHeyb6W2g2k
	47NEIYNzi/xjROYu6CiRx3/VthwN+fEfzNzHFP6fWfeJ+41lliQD3lZHyMauz5E6vzsIAE
	jUpA2pLfWttmAcVxSdw2KghSEicArtw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gnoNxGoL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774548;
	b=TAIfe4gj9dbdKbHNiaVeaN+7YoSyVTiNqaxiw7kbLop703L9xsiUXzNcRy8ExlZdpnsI+1
	CNbipYebCfIFtFOFOZ6DNuElVfkZ8Oc9wXWFRbHhWzGh0OndXhPjFqJq4B8DG+2p8DrLXp
	62cMjvolgp5KhVKAa3eqHSwI3/11Ox4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E483545BF3;
	Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A637C1F00939;
	Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774547;
	bh=WbZTCynxDA8qlWzkpFXejL39caIBFfSg2B35l700hQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnoNxGoLVrB1c6PqA+9SUSMKtWHDLFu/i1wQ0om5R/ycBjpBzjyeDfDpo+/HyxR5b
	 bzMF7DHxDYXcV+eVLyfpG5BGlbfYx30kPvZTyK59hF5Hz6mCKdXpv0Kzq5B/lAxox7
	 3jutHytUkROnz6XqkLFg9CZkdzkiC+a31zGCqfRE0Yj5w1zwUSdCrHz4aHyS42SjW5
	 mpp44LoKMyCNKm+eGk03sHnOTvtHYpjg/AFKtvjsadocBoksu4sJUkWlNONtArDPkj
	 QvVLFQHDFxyupakxYk+81WgfUQyzs266RoEaM6rLbvi/vAI+ui8JUXEUbne7VZCIv5
	 BfAQKcbIU9Y8A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 16/27] mm/damon/sysfs: support REPORT_MADE type probe filter setup
Date: Sun, 15 Nov 2026 12:28:34 -0800
Message-ID: <20261115202849.99134-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6DC4C1A0002
X-Stat-Signature: zg9k71dzoiwa6qgnoso8zfeti54sjdar
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774548-353552
X-HE-Meta: U2FsdGVkX18fwuT7M5vzTn5C/6lXNbFd3gLFE9cUNlxybpZFgoXoIubiATCNFMcAhlC2OTOQJDAAnBWEA9cQDn9n6MFtby7SZ3sV8YHOPEvhRRDU8H/pPNmk76UdKRsmxgohBgDwGLWSYtNjcNmqnCA+xmqFwEd0QQvk7/23hkZMYQUDLxLOgyGtXDpe7QbvFREfwIfHufXVow8PnWf22KEHUb1Z7n89lqLt9JIdUkKihUl2bYiTlFiitfcByxs9Ls5VhWBrsco3Nd2VkZ9FQqlmv7OuRmNNU+CZ7a64X7zekQO6hMEo8W2b7hvMC1g+GZY98RLP9IUhFwnYLTXKy9MIVA9s4LK5brrrMILnbAcwhx2HJpUcThGu4y0TyrBjyDytAg9/DyrH4JGCYqchgsrCrdb+rZVswaWpyWsjJeQnLh8CdHMXV2pCM1enjhbcysazyCViBXKpXp6EELZ330+x1ho1qTwzh+css1aFHvMolUny+La+Qde2NFYeIRGfbtxF83GpuHcGKUpXfSeUGrykqU0TmlEAX/xstLGy3ps9hfwJj9qfeL649rMbKr3gDYMFPk2R+NsS3I6k7JwhviehCcCpOCQ8ZawTbmxlI+3ycAVs0PAR6OltHu4AHXj4x1oezZSyTZ7NkTo9k0GEwksPVSe1rsfu1dNaKYTehPFdh030ObU52jhLjUVP7/Wt1bPJBuanC0RZWtnm97V6xHFDnmDbk+J0cpXNU5oQjt2b2OFBPG5QfTqLBuyJAjcOUTTaNFd/kZxx/YXnseGDvjEGapIT0jJP+gmqomULnIi2h0gtw3ki7BaDFnnp6cvzAJr64UiIRPoD16205DxnF3jYlMtNeBtErlurXjfhQAq2zqcyR3lYe1hlshAEOSiJI3BRXCSVCeWMJ8toLho3VqswC3bUS6W5bieYQY4TUw8hxXY955YtOz++Q28clb6m0f6OOohL8tOov7tyN5f
 5sQHpTNL
 adptdRNz89ZU09DBsNLHfvYLjDMp7PlApflaVqJpWZ4O2ODL+ftM/9fns2UuaHoABTtpUrSdNjVkHEsY4Uw9fVnIcpcCp5wiZ5gxYN6mXn4MIKToHTKgtNliae//kumAcKQJZ9K3SgPSZAN0NpUKxvI6x2FtORw5aqBqMd/E6VLJ/Fgfb8X+sChlvd8lye6WDJW2JNY0jv+fnzx/qBhYRKTcdosbR9kMtjxWi0/+F+TbHMOf9QAdGmnMtwj0qWzkYyFxrQxC+DqTF+DSwWRP6Grh8uF+4q8jq0789kmAfNnmGpy8zeAnNmCCWV5SNhWjIw8ChfZsudSLpnFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Accept user keyword "report_made" to probe filter type file.  Set the
damon_filter->type as REPORT_MADE for the input.  Setup
damon_filter->report_type with the filter_report_type user input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ca971cf1dcf6d..1c171af4590a8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1016,6 +1016,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_ACTIVE,
 		.name = "active",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_REPORT_MADE,
+		.name = "report_made",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2336,6 +2340,8 @@ static int damon_sysfs_set_filters(struct damon_probe *probe,
 		} else if (filter->type == DAMON_FILTER_TYPE_HUGEPAGE_SIZE) {
 			filter->range_min = sys_filter->range_min;
 			filter->range_max = sys_filter->range_max;
+		} else if (filter->type == DAMON_FILTER_TYPE_REPORT_MADE) {
+			filter->report_type = sys_filter->report_type;
 		}
 		damon_add_filter(probe, filter);
 	}
-- 
2.47.3

