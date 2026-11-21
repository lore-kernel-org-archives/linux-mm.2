Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF13606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nfO4Ry3U
Received: by kanga.kvack.org (Postfix)
	id 4E1AA6B05C0; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9076B05C1; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B0A6B05C2; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C85F6B05C0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E8D21405DC
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
X-FDA: 85460344536.15.031470B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1EFFC0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfO4Ry3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294827;
	b=gIed24ZnWI8se0J6VPBeT1w5lh+pDRn7grX8eKufSOLfJsw/WApMxTwd1onXcQABeMJczE
	epFuDfh+GisTQCU9rRqjax4mGFqa4an6T9EWcJQ5PLZk2cwcHtG5AJWHMIpLdXgrocf+rS
	BDL6KrnaTwpi1pImbBAsUdFzoQCbWwo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbZTCynxDA8qlWzkpFXejL39caIBFfSg2B35l700hQg=;
	b=XZQGsvf6UfBDGcNT3Lu4MWlJ3PgpT9fj601LxPpl4od9D9rQcN8b2HD8Rd3pZ8O9NTGDrH
	uuGhaWwOWBRFiHBQ6LYj+gXlvQFmAlGYlQj37l9RWPFrUrQaIKXKPoXofYi5V3TVNXIKG3
	ZY931meLYra3/ZPOOUMhPUenkKF0m8o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfO4Ry3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD41761B73;
	Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C6E1F000C6;
	Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294826;
	bh=WbZTCynxDA8qlWzkpFXejL39caIBFfSg2B35l700hQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfO4Ry3USlMbmLI9W4/Bpcx7I6pq2rJZZHDU6rognuYyg0rELkfEYxgwJQsXxPZoP
	 a0zULYArVAjwMRGqq2DZ4PANyB1Jnao9wd1ZOMTTmmJCdYnC6R2dbGEelca9EJHHxi
	 XcOjSSUrifpeowSpPdiWji7CY1BF3SpB8FG45IddCeTFcCGRaGC1shCShtFL4iwxFQ
	 P4bNzCbpVFxTmzUEh7yqcl2+Fd1xH1iXgep7B3uTibkvJV3B4FVzHbnh5cCwaQO8rS
	 I30U6A2WpOZwfA0+KlzTTHqZ25Ux0kuftgfxLmQzN/Irid6QFiS2oQ6EmJZXocjLXs
	 s2ESjt5WyMQWQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 16/27] mm/damon/sysfs: support REPORT_MADE type probe filter setup
Date: Sat, 21 Nov 2026 13:00:00 -0800
Message-ID: <20261121210013.130397-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F1EFFC0003
X-Stat-Signature: oc3o6b48h18fyf8753qdmh7ifisd91ae
X-HE-Tag: 1795294826-77192
X-HE-Meta: U2FsdGVkX1/eRx1dJEcKXEnUToPh3oz/D/3XeshltVmjzTqekhyPpPTxXPAREJ6mRc7UaDCQ43SRJAXrSkXMqvGUGvnjFZfc44sfF/6H48cW9WQZQlSimDJyuICNux3ZUNH+TVg/5FixK8Kp2V1Ica9KbyocONmSPnvSg1w47k8NKBDwGH4yCi8RPvOJZbUfm4PBc/EIm6bYeBdByEaxwA1BEkvGIhSiOHJwFRqL6+pnflVLh9b9Z4+60xNWWoKV9ZnWOg19RGsWl6de3czEf1HYt6rDETIXP2VBy80mgIQFVEkZCRXK3ZSN0RT4PyQfDOu0hnSDI1UAxg6FDQD5OE2pYVlojTvDW1BuXc9Rv7YNepEE+Nobi58CGZlVyJlstZ3+p5uc9uyahZtT6ZPoVR3mqJm4coTfwMeZgknhx0yy8B52S4q4bRXDg+9lIEQ8Vr/gtXUAIPqx5CefjBeLRySeRdMs/Z+gqXVR3WTuer5JgNKGw7XAGNUjdWnbUwdG9qqXkMiPJQGAyMtiC9oxwRyQp4yV23lRJx9zsjQ1qjLW5UqdL2G8mApsyo+O6ImvQ5LC2IC7bT9vVu7WzJ8ACoEzKNC33VospE9jybQ6c177ID4qTBa3FRYHrn1oGiudbrsjKsMhTncJQQWsE66X08nsjo+TMquMHDX7JRErtIr+Tr6F8aIGjFBEwBACTdSHod0oGVCiW1yN4W8Mg9S9ovufpGs3HlOO76Ik4tfF6nyb40zt/0j5ONRWx4FCAyFKxNKduCZw023RUrURJM4Pb58VdzRFkc64xoBXrHR7eSxNDuP1yOLjNhtC88hrm9IV7LiGDUAp2ThKXjhuAoystBTEMLfdu7+aBF79V4Lcn0h1sdRZ0S15ybdJtgecBkgFockxjvD1yvweAb7zPqFAPZhxqzG3wZRmiVkgk1XiLFL23fDxzDtydxg5VMipgrDrtkLLCX3pj+FEx/5uFAX
 rh9lbw6a
 q5eJxe22cu9RuDv+WUgkWJa7kGOoD4KqnsbW/DYabWKo3lcvl5uqP8Z7+BRM4vy0FYppNznrs5URt+HK2ftjAxqT2yH37FDw4U77aUuCnVbQ8dISfO5zrsn4Sc1tNG56Baq6Th86gsMXKKszjKxHqjL4JOoi8GpaMDRT9EsfZjgTxtn04yigl862fw54Qkha4zokvLQYUJHlhff/9Y1fH2QKCZ04+kLRZ5sLdJ89lJFm6oL2DEZtZWCM3xeb9CfAnzcTykAWLnLIeIgoIXuLYR8IpgL1L6TseYYPXl6yd6ikdsz3DgkFfEvJl4LuUyXub0D7sbzsFZnJv6hs5sYpkhxFW+Q1bfTVAXckFIf39e7/PsFMzO1ueIyRxwIHBTgDuEZGrvSPQXAq09XgOJnQKYPiDFJxvOBgUo0QxYT7z3eebtaOUFvyw4045l2HIarUJMSWH242yKvqFZG6SzjnAKaT4x2gOQwMpY05vgDxGumwgNhMK2s0BOchmIthFJmGZLCcUaxuoO3c63wQjARxk0ITrnMaS7Fh1ZWWMSIMU0DZ3otU=
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

