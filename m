Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AE710987A5
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4207F6B0122; Fri, 20 Mar 2026 12:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AAB86B0123; Fri, 20 Mar 2026 12:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C05A6B0124; Fri, 20 Mar 2026 12:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1A25B6B0122
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:36:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C090D1602BC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:36:15 +0000 (UTC)
X-FDA: 84566993910.19.A1A67B4
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf01.hostedemail.com (Postfix) with ESMTP id EE7CC40005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:36:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=I+rSrwmd;
	spf=pass (imf01.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBhz+FP718xfFTo+Jqt21ir9B4N+Sz9WG+S91iYYSqU=;
	b=bDe7EtSXFQKhjHqKj0eL19xvKKz2j/8BHGchOJUQDrS01klQz1AcPaNFmUG8xFhc/ILnJs
	FsUbDFpqqaXZpATIDwh49Xdg9X5KTvza4N4WIzDpp9NPYwSqb9ntIq5f2ZI05gemKR8pfp
	A+j7ZjU9ou3kOVmyQevapiPwXK9w3kU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=I+rSrwmd;
	spf=pass (imf01.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774024574; a=rsa-sha256;
	cv=pass;
	b=sUyP8XQKJSGS+R4fyZUN97/MyjkDgq4pKOwWKyO4HnnzqEM6GZHIpkYajrU/gOIasPlvKZ
	zrUXM1BBn0/56I6kZwAPrOQrNZd2uTJmug2fnwlA8EWZ3SivtkHMj/qEb2Re2bYCwYPxvX
	9FhG7DR2sQn+fOUEytZj1mmRpQSIYM0=
ARC-Seal: i=1; a=rsa-sha256; t=1774024563; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=ff8X3tljHjklyFzeIFOMCAdNbLmebNvpYED9ZqvO5oAD7NDG1a45ss15UN6rHaeUpEF87bR6hsw4wmrIsW2j4KmhzuOc7YqAQmp49YiORUQdPIhzYlGKnYBxHdBY6IvtkY15H0jjAhxHRjbrnZfAMb0ojGsK1vvlG2ydZXgLss0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774024563; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xBhz+FP718xfFTo+Jqt21ir9B4N+Sz9WG+S91iYYSqU=; 
	b=Et+EfbnAdIfTOdfn2PjpJQeP4ypoP4uxvfKy9C1+AVGQSrKOzpFxuK7BPala0qvsStG2h0MF5C9Vz0ZZBbUMHrev2ZelqjEqefje9uXmFIr7pMwMhYnilH65aFwi3j1ZEFivFfdGiaZRrG4H54WJnbRnJm0P6hbq1y5HQZiyQUg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774024563;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=xBhz+FP718xfFTo+Jqt21ir9B4N+Sz9WG+S91iYYSqU=;
	b=I+rSrwmdO5diJIt0LdFNl3Yk3dlXhjTt0x0zyF30VEYe6opl27xXPDSUJJ3tXuYj
	1CMYjf3lBkYeKUDR3YP7NTyVHGex8JG3e8me/ea7fJzJV7H4XsLbLeKHaO5n+mTseGj
	7/xRFtAU2A4eivvzCxi6s6B3sCWpX/vEWTlm4eh0=
Received: by mx.zoho.eu with SMTPS id 1774024562167191.42267947695075;
	Fri, 20 Mar 2026 17:36:02 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
Date: Fri, 20 Mar 2026 16:35:58 +0000
Message-Id: <20260320163559.178101-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320163559.178101-1-objecting@objecting.org>
References: <20260320163559.178101-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: EE7CC40005
X-Stat-Signature: bry4nymuogncypksz1dye64wm1ryh1nz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774024573-362637
X-HE-Meta: U2FsdGVkX18GF9NAc8/TTzWNrnkdRM5Jdp+uONc1x5F/z8ne1eEvH+umQ04FQ++k5MtoJim1OmvBeaGk3rKj5VFfrGGm0YyAGWHoStWhmup7jUotHnc6SOa8sPlCrZ0YHodhPT+p6ZsACK3Po3dnVEFkWYyQiSbutxZjtH8dSZGtKqHHasE8+K92bOVXKcM9MWKklU1oiK3RLfLKItTbi+7ESPMc+ySE5ykzzYZ/ezqxtdENEoIoOXLQVPw8MmxCAqMWk5Kw3OOBKy4O1q9vrSHVKbMIVmy3eizpu1dWhoAILsyPJWWGZPOt+y9312DraKrJMu1t5QVVSzPw9Fcx38ExVdHpcadgSQRlhF3Nuf/glCHCyT3A3YZ+/5lR/Gu1F1bFVz56sAJ6Fq2U4fusJVB1Rsz4WFhMtgg/0oje4OVu2l3BCkd87u7YN/MESoal11MEFs68yOyVFjJok66snBBNSk4Y+aXbqqWtskcdaz43Q9F+0f0kr0KNBb19deTqWbjmC1YbuVgLh7fjfLE+E4xZVavAkQkNwCImRnjo6j1Ff7GRiiibQkDVAw50CvZrN9oEzyIX51R2M/yHc0WGF/IvA6EMuyhiVGbjPz7+UhDlPk+M62kpmeOtAZCOVRNpbfImFoMx71ObSexEQjPPMR2Bcr9PxqIEDWKhZfD/k908Wu6Kq1iMYa3U/vAtIFmW4FtPiI118lBldscq/kleyztNkxytwd7Ki1YJm2eBkz+VVxpHkOUqqTS1MIulTaGuiMqbTLXHcGXQiaDSZeDWDjwqbIOHK68kiM6kA3xzVPLU0lH1O5xfWD4HX2KgG5SBKpzTfdNLomDVMZFreeyehLBW+3dTO+w9jsg02EQ5tUoo/Bigef+zxjliG/wTwj0mLQmgEUokXJKFh2xOw1MBhABSco5X+47id3JpR+GYgu8qkLKKXEjXdTX6a3g1B+yIoiNCExIWMk4zgG/hEsZ
 EWCRfdiJ
 u9bngaVE2UcgTEb2X+HUZjSZIQQwsY8oY9amNJVzoPeaO1f8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Multiple sysfs command paths dereference contexts_arr[0] without first
verifying that nr_contexts >= 1.  A user can set nr_contexts to 0 via
sysfs while DAMON is running, causing NULL pointer dereferences.

Guard all commands (except OFF) at the entry point of
damon_sysfs_handle_cmd().

Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Cc: <stable@vger.kernel.org>	# 5.18.x
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b573b9d60784..ddc30586c0e6 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1749,6 +1749,9 @@ static int damon_sysfs_update_schemes_tried_regions(
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		struct damon_sysfs_kdamond *kdamond)
 {
+	if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
+		return -EINVAL;
+
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);
-- 
2.34.1


