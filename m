Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F0CCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F12C6B009D; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8E06B009E; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605746B009F; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A36B6B009E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C461164ECF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:35 +0000 (UTC)
X-FDA: 84893382630.20.1B1C6BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B3A171C000F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o3YCEZTr;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ot9STQ1g/9bWHz2PjKibHQ71PZQcqWhCbB69SWOFmKg=;
	b=7r+kEli/+PM7vBYCNm/yQY2P9iqny+4LkMRIH8w0AXaSc5KEeuR6BX8PXVq8oR5APojUdz
	DRkpy05nyd85k/Ro76JAsVGUHC+gB8jt941RNAE2skUaBFGZb4+D6EW3Uj+zqrBZ3a2KLL
	CofZxvNp5HXml1Zor4xd6UawUyTU0LA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795733;
	b=d3Ma3vbun++4pCogFDKSSu9ri/RtQAJ1CpE+QSO0ILYYgiyyJwzDxl0IGqYPGgKfxW4R7U
	NfqbKazFRfPBBTrjA+Q1ei7Y3ZyMKZ9/Whi7xVymR1z3ymfgjBDwH9xpQBOKOy8h22zjIx
	3ZRQ0fKm93Cm5dJy0yoVbR9n4+cYjXc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o3YCEZTr;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 065C3439DF;
	Thu, 18 Jun 2026 15:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684921F000E9;
	Thu, 18 Jun 2026 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795732;
	bh=Ot9STQ1g/9bWHz2PjKibHQ71PZQcqWhCbB69SWOFmKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3YCEZTrO+wyO3PqS/j1/Gt2GLsXLY9FxL6xZbWT1uGZLwZjqayIGag//weJb512F
	 RJNNCcmISu+dza9sGmQCswEbLB+3tcbT4/ySZehAtBUwVpeCePuB60lVcXd+0LIjIv
	 I5PwxR5LoA1sjjb1NIT+u2ZnUV8DOSHS+UhkGhmgzivxt5XdRgy7yUt7koLZ2A1Zrp
	 m/huCaE4WBwCYlNePgvJJTBKVPTV36UzLUwDaHgVD6FBxCkQ0tMOg/sMlF/1fXfrQn
	 7lvWn778TGS8/RyF1rs4COUeOXrdWp7krVcbg6DYx57zNoLNr0sDcRerYOo4s01bB+
	 khYE9UPlNjLrw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 04/11] mm/damon/sysfs-schemes: kobject_del() scheme region dirs
Date: Thu, 18 Jun 2026 08:15:08 -0700
Message-ID: <20260618151517.5366-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B3A171C000F
X-Stat-Signature: kzkw1crcozoh7zw1pezry5raaki6hzzb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781795733-396107
X-HE-Meta: U2FsdGVkX19JNVvAV5tXbjbdj/ry+bCCInDyvhyvqKgobmxP7jM9o0W2oPIpFv4yDniRiFvpaYtBacaQtXR62p1NI9/FKvS3kO9fxTI2Y0n/itk3pF9Cwqzs3lY3LWPm/foYVlP9l7Wl20WpMELx7r2VNJcNe+VetMWdLFT3CpSdZ4WW0tAAmdPk65PolX/Xx5hf1uaX7WsJ0qNuBpVzwHPh9oXdbX4eGTVdqeddupui/qurs+9z8SXLdPzJrINtU6SgzGqNmge5T6Bi6iErH+uzB1qOwC7ZTMP4EDwlqMggecRvNEu13+Yp90Mj7+gQba66+s7V6l3NRBlABIT0xc129Ct1qxpsMEhh1LrsCDB5qx8OLlohJnCKnjnQ/WoezK4+tkr1VQow7OxeAv9LaL5v9bSPtLCBcZIoTgHyd4pFRtM9DvQaXru0GsWv21QpzFNnpDthQLetxq2jI0sueIup785RJR8pg1ljGINJ5DU+cHZID7EFfcV/x2avtIq2jwMULJewb3fy/jIoGUb0FSfhmU5USVbNlm74WbA30O1IejkNja0NYHVIld218dLQ7WYLWTfhnrshfsmIbfYpQNMnkG0KCsZQmbgKb6Z1IO0SNqoWBIHchlL+VFOxXQgCVCcZUt3pBqI0vayXCIdWazLaEx049ebpadaOrgviTytOI4hwTuumHq/lyP9jeOd/4R6QO+JLg0UxDEJWCWs26vmuS2SAeMWrF+RCUsLRs1Np1zEkZC503BUfceP5OtbL4xRl35+lRa/MlvWrOsFpE0U8Z5c/OlYXSnKaaPUhZSkfNiDHRw5Hc0K+2BG3Nv0JNy0RGSThO5PEXVBT15m6ooJEgpCXo2VczahcdgZJAVbc43dHLCk6duSSB1fh+fdguGxzyJuGvMOXgJ+m6u4vtlm5hrT4V2b10aeQrqOOfl22nfAEdxaS0UOras0Ucv7hiZqOioYIa5MpyLANiMs
 mH/3m/Qs
 RTh4R+zv3wPyrvne8e3xld5gnd5vDo0bwOmZJbl7wNnjE3qjwC07rPzOTIsKv9qFuXhvolY8tt04Vy9SYXbC0ryKhPY9r6fygvyCciMoocyfgh8K59fDlijefYwRW1VZHYKGkImJ/YWPu2sgkb5LZH1rhOYrKvmFR8JhHYot1fBNoePN4QrB9UVMhz2gd0PUB7JhUO+2PpbwxtpcXK/OhsQMq4WNch9hh/MoNAbJrLCCby1eEvPuVLWh9EMQfXOMMq6bjVt1PGRR93GE8r1bFJYPehQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme region directories by adding kobject_del()
calls.

This issue was discovered [1] by Sashiko, though its analysis was
partially incorrect.

[1] https://lore.kernel.org/20260517205828.6204-1-sj@kernel.org

Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 13f5fae01800b..36a35ad0983eb 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -334,6 +334,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		damos_sysfs_region_rm_dirs(r);
 		list_del(&r->list);
+		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
-- 
2.47.3

