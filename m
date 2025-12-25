Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0B6AE784B7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 02:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845E16B0089; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829E76B0092; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529976B0089; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4035B6B0089
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F417C13B157
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:51 +0000 (UTC)
X-FDA: 84256415544.07.9552FD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5129740002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hv7oM6Fu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766629850; a=rsa-sha256;
	cv=none;
	b=nTDndIastyimBoK3UQcV6xpDs0geWZk4Yb0957RlIAR1tQZ/H0/+2TcD7LiheeRUVXUjoM
	T4mMgf3bta02xQtG0NEhYpr2//HHymKw8dhc01K6cDXYA53N8SSN9SeUN3CSfkOUEs5Hfy
	GHMj+SofLdIdMnUUdj9jAjF3k9FsSi0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hv7oM6Fu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766629850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFeyGifSrgJ7N0ATzzWnCjt+wMWkUUaUqQhyfIIAJ1U=;
	b=aZT7Niif0CUEHPkXbhZnGFMnHCLKGVfnQFFVyyYAnldJ54VQHAeETi07Eiz99CuanqxYuq
	ROBgWQV4hPalHKw6929LY8zFz6Mb6cud6syzGplcgtpsxF6Jx2F/dHATIY9AbPGTLwUN4n
	YQyayA1+re7yw2saug7D8FIf2uyp8gQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B22444079;
	Thu, 25 Dec 2025 02:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5334C16AAE;
	Thu, 25 Dec 2025 02:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766629848;
	bh=m1g5uoH2P6wU5+w9MpROfiHCEcAhvKwueo5z8pV/iIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv7oM6FuFVBFimNiN0++SlKU0Babvo1q/s0diD8J21TRCQTPHl9iI0Ed1VuwpLcC6
	 VoizBokSE4cNvmfNPlU0YLNhEsw6kzOipsfotF71PzIYrVDrls9il1BUf7XZVtS961
	 6flx6XDCsDddpb9kuoKWiUoYIRB4mYSGVJbSYMSBmu0DY+y2HH5/FfKIpBh5m9I3Ct
	 PenhSknzyZ5LgUnxheh3MdhASObRZkkqAqEPB9c2Va54t/4OfN/U9l8mqOMNI02fDb
	 M+tOxuMuOfLrrEJN3e3si4WfbsISRy0vQWn/YigCyM+4UyhmOP7ik1FY9y5tC+2IEE
	 fWGN8vwZPYB6A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] mm/damon/sysfs: cleanup intervals subdirs on attrs dir setup failure
Date: Wed, 24 Dec 2025 18:30:34 -0800
Message-ID: <20251225023043.18579-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225023043.18579-1-sj@kernel.org>
References: <20251225023043.18579-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5129740002
X-Stat-Signature: pan7z9usd87s8ixu3krg7rojzdooonn3
X-HE-Tag: 1766629850-459324
X-HE-Meta: U2FsdGVkX18ntUkIuvkk80AG6jxrG4ZQg5CgTluPYNqrpI/yLoI1l9AWScq7fcttbGRUeRKaff+1oRDU3OVhKdbacOWhE0+2xmlSTwTqb3J12M1ePXO7zt8ssiX71kKE4lycaYhcr1VhBeXkTkFJEnlvjpvymzDGW1veiSFzjoqT8AAlE7fgsuCzUZLSxRN8xIk/SY6yw7L3DtiAcvfp2jIZUDNk4kCaPkkyUBZ9Hw7THoc41VIqyMAluYIJprbmmLUjGLL10+ZvSn1l7IZZQY8/E/EyOY7G1jguSzpuW+GyFXtMWQYaPM8i+Zyy6pbKKGYypwna+68I7P3oPrjEkKvxKNICXRKezfQuPtayuzNHez5jrxBCsucau/8tbf1upzOo7i4fiw00kPl72/eJ9tCwKm46FitAlVhmqUXN6vUKl41JWWkN5cNNtk3+9bVKKjCQy2Xu1ZaTVdZSnKs5q9sNWX4x7bhVZvRIW4+SyVSlILVKqGGuqQS1waR7YCF8RMRnc29h8o3Rc5Nxd5ojH5yPPdekBeej9Epy4GuCB4D6xMSM3dQpnX/I2pECX4XfVZbgiWlyB87+LUg8Sk2Bgl4DVXJi2NroPfbzlz39D9hSmMDToml9bUCH4run8dRXiIf6iTPigDuYU6wbu/7ElCBmmnVbyLTkxYHcS6h/WtQctXqwOe0DoGA8x/gVlNpIKsMHusKoARzBfdPy0XX4JAXoo0WyYosCu5vo58p9Ro1LBov7QTzoVlkZpmxaaCjO+n+KB/ZuJ5xjHj0pI1FKPn60C3fWw19CTaWpsFEv5ZlA+mAYnEKTl1Sa2eYkFK/RRxnrg4EZq6AzXGaYSv+62RoW6TAMlftVzzXqwaUuLjZDKZ7d43IAdGyOdVmoq2gfhRI3xZJRDPk/TijPKeKN5cLTcue9Ft/donPD/dlnK8Pd2PqVpDkAi6SNpTTco8ErX0ZI/PMj34U0qwnK4PT
 VUWa8AS4
 uyFN9zf8laTH2HNgsgUaC5etoX2MKBIyDhgXhNAqQHbnQ+Pqbf/pHL+uEYKcFGs2dIDWR07ANcqwm7g/7I7oXVU00zUOFsVLatuCO7r/NxE+3sZbtzD2M4Y5a0Ovy8q5LL20EN0PNzeoR0DMcAJubKXunPWU9r1AYD7WuTANlQ1J5AuYmxrVMcuBN5kZS6bQRJbe7/hL7lB1/xTGhd4JPHMBiFozPWLj+f4thiFzO9nr8fbc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When attrs/ DAMON sysfs directory setup is failed after setup of
intervals/ directory, intervals/intervals_goal/ directory is not cleaned
up.  As a result, DAMON sysfs interface is nearly broken until the
system reboots, and the memory for the unremoved directory is leaked.

Cleanup the directory under such failures.

Fixes: 8fbbcbeaafeb ("mm/damon/sysfs: implement intervals tuning goal directory")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e2bd2d7becdd..a669de068770 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -792,7 +792,7 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 	nr_regions_range = damon_sysfs_ul_range_alloc(10, 1000);
 	if (!nr_regions_range) {
 		err = -ENOMEM;
-		goto put_intervals_out;
+		goto rmdir_put_intervals_out;
 	}
 
 	err = kobject_init_and_add(&nr_regions_range->kobj,
@@ -806,6 +806,8 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 put_nr_regions_intervals_out:
 	kobject_put(&nr_regions_range->kobj);
 	attrs->nr_regions_range = NULL;
+rmdir_put_intervals_out:
+	damon_sysfs_intervals_rm_dirs(intervals);
 put_intervals_out:
 	kobject_put(&intervals->kobj);
 	attrs->intervals = NULL;
-- 
2.47.3

