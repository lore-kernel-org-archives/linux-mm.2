Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8417A606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I9KbJE7q
Received: by kanga.kvack.org (Postfix)
	id 852C86B0616; Wed, 28 Oct 2026 01:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803656B061E; Wed, 28 Oct 2026 01:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C436B0620; Wed, 28 Oct 2026 01:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51E616B0616
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:11:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E21501A019C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:11:15 +0000 (UTC)
X-FDA: 85370861310.08.B01DF6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 46F42180004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:11:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9KbJE7q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793164274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yPa5wbC5qsV5ePJc3qyfqSfwGtResrr8GiaQmPYPZk=;
	b=dz54id3N/hrl+x8ME7t0tLT0q+IbwsgRaJLorHMZbuuPmYIht2ooDdCsYL/cYzEec/Ws5J
	G2iGXEFuMnJP+vpQ9MIcEibeP4hOFB9FozzJ+OwklhfUxr0yUKc234qgpN75E3EI9KPnK+
	cWZtwLZc6vjuN2lOjeBpAOQPnepOoSE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9KbJE7q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793164274;
	b=SZmjAvqOhK2+iPP8cg6++rC/crfeVGBhurvbshLBCBgiyh+QqM3Vyc3oqXdoU547Ziot1d
	HBJdQvyzOQf33KRzlkIw0Hwbckadb0Nq1SXEMZvAD8Em13bzPGrnlEwb5ArGmMXlBqAkF0
	/tOJBFVBFZ2rlrrNUI7y6GivVZ3j+CE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1622601F6;
	Wed, 28 Oct 2026 05:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3651F031E0;
	Wed, 28 Oct 2026 05:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793164273;
	bh=0yPa5wbC5qsV5ePJc3qyfqSfwGtResrr8GiaQmPYPZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9KbJE7qEqPtgy/TkRldcESI2Y5OZDrBs8NI88jwDvQ2YVPKxYjEw29qZpRZtjInw
	 rcXln9rEdUnQynv6msdUInEVFzxX4kvlsE9GEnzU0cmw9B3W+5jDlollM0eCkdaigx
	 4Sp9MZA06d2kisL2q1wJWpZ3c0k6rc3rJZcogW6wg54ksbbA4rw2XSDxh8Jqc7lbSV
	 Bma5ScdcjYOJaDvf7DQzUF23jT3//145nYk8ixnMCGFt4ydV+IB6xmXPg4wjJJj11y
	 2dmPfFlZeTWzPMC9cOiTrTtwkCe0IG7EPrl0eIsPXQS0O57C+SjYj4EDQt449wxS0d
	 tFo6Oae4voYiQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.1.y 1/2] mm/damon/sysfs: put target pids for damon_start() failure
Date: Tue, 27 Oct 2026 22:11:02 -0700
Message-ID: <20261028051104.154232-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028051104.154232-1-sj@kernel.org>
References: <20261028051104.154232-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 46F42180004
X-Stat-Signature: na4r8ranqc7msw11cbx8i8atauqt4ah5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793164274-830616
X-HE-Meta: U2FsdGVkX19A8+XVwXfFM8m4okz6ylWKXfQoIMhg3ksrprReqOoD3HD+c4MR9lKL3uVkXVkK+RGcY/4ateN4V+GOHwrA1ctjA8y86tQFohSIobfzduJCxCj57QiORGGJheyGXNh59mvm2PXYxPmWvw5eun9gvcqpku08hPX/i/O+kt9NsVShxZayWuR3Nyk8cSgNjL3vABpyFMQniPM+nm0ZSNF3oiFj5j+U9gmv7t+9U4gjFsxJdbRzBiCbK0kMHhtKOF1W3Uzx4Go2+nz/YqlXPXZbqpMI4bo8m80f6VDVMgIaQS0vuum3F74MQjs3jyPpWq30zfXKHkG2yW9JSAzQ8RioREr5+7ezq9zGEe99W8dEmkTRO2zu9EoC11/D1YBMxLLM/VKZtX5HdjGZs+tukiI/6y3EfMfcfiu6ODyTTYOHxCGqG+zQSt46vV9R5kfeL3zp10w7vhY6aHChMK5mZBzYQYr59XVZ62VcU6ewuUaJCdoK+AK0cFj7K3PozSweco20s5Ap1O8oc3pXmATGca0u1LuJYGK82+qvTka6EhFhtVdpa1TNJxOOKkbQuZ2wb/YN/T8ZRxIqdiR2wUJVOwajPCdQ4erR+Sfd4IwQjG9g3cr1ovPyAlDx5JGzcNR2LXEaJFo6Qi1JEFrHhs8RFWUEBqkqg1yf1BqjidhPYWmGQI/lJH05bMrPlWPoPmK6jWLcaiUF4L1ZcHUR7MDR1QYv9ibO0Zgd/XFutKpGc4J74IsmS7k6tfbvyYI1Ag22N5tWcxPB715fk/PEE7U0wh+ic7uGRXMouZvP2/EqA9VV3bgx9VqsHPEidARXpjhEWQ3m6uk0gdN8wkAHciAhWNfIiIu+MjDxBn1bsCSQi8GTL6inmq0gNTOde+PfMH9EOl2Xu3d2TNDEEMUhk2Mpax/HRe8lxLSrNnOiEkIZrdMVqA3XW/CL0WK5/5K4rvRKxwKqnZzkx61SnMN
 G4g2Enkp
 pMNR1wREopNFcw6KdXjs2nb7yWWaaMHH8RQadZz9YkonEmfOSMlLaO0x+e750gxrC4G16SUrJgwmfck3FgPQ0SoUfMTkNP/rd3So0hkHacFz4ur2DBp9BvmsiEX9ZOAUpPVzGnp4UfYCu+gNzL6PrtC97NiErGVcfaxBD4qYNf+NLkPZZ2OjC63XlE0x/AocYN6D8wdfHBYuPcQud+eUXxlSnMYZSPOt6rk9x1YIQ/yE7b1Ii4HHuvHYzvvmMfVkNYuDX/cjYR1aZYUGI2ZYjq/DYoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_turn_damon_on() allocates and sets up damon_ctx to start.
If it is for virtual address space monitoring, the setup increases the
reference counts of the target pids.  After the setup, the function
invokes damon_start().  If damon_start() fails, it deallocates the
damon_ctx object without decreasing the reference counts of target pids.
As a result, pids can be leaked.

Fix the leak by putting pids using damon_sysfs_destroy_targets() before
deallocating the damon_ctx object.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 9a918f8e4c6bf..4b28bb9ba0a24 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2547,6 +2547,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		return PTR_ERR(ctx);
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
-- 
2.47.3

