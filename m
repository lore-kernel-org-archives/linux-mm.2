Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE2CC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6206B6B0099; Sat, 29 Aug 2026 03:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F87D6B009B; Sat, 29 Aug 2026 03:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5100E6B009D; Sat, 29 Aug 2026 03:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0286B0099
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:47:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 481C914066C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:10 +0000 (UTC)
X-FDA: 85153526220.04.91625F7
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 86C3A140005
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="k/EzrT+w";
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlfOvgBEtySKIOUVBBOTKpFAbjQZaUCTZO6eqUdoNDE=;
	b=hXt1rPDy2sg4vdXEFff5IHugm4meiG02ufQSIRE4dfMhX1NqNiB1E11day8cvGpsgBsF/J
	JU62CjFnrvXOTjXHoK2It37ZbcP+6rohHMj4HewIkyL8R4uXYqF6Qkhzs2HX5lqGTvaLTQ
	TDXoocuGCfv9n0G3SrWgTTbykgQyWao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989628;
	b=MpLpmULnlYX5H0pywLhNtcb1gkr2gi7wfIQkvRgUrp5mf3sG2axM/SsVpAiu5kjVwN03v0
	roKI0Airss6EMMFKLMyhthPQ30wEqDNC3ymMpDXcWQRLgue9WVs54+F/g4nnSDXoeSMlp7
	z+D6kr6dy2Am+GzcdKMJzdXp1wduSY0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="k/EzrT+w";
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d6efd73032so24756715ad.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989627; x=1788594427; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZlfOvgBEtySKIOUVBBOTKpFAbjQZaUCTZO6eqUdoNDE=;
        b=k/EzrT+wjiFuD4HCZ17oEm1P9gdm3C7vrexjne/vUPqoHYuilxJrjWAYn85nSvslKq
         x6P6OQ3HUhPtVw+H6EMrdXrIpti4SnHKxRXnR0exOZizqqtTWqZAbRA/aLWmW9SOuRv4
         HBk+FZcmA9MAOaa87bpOiscFCGM1KqNvpQAQplIKRj6IRQh4wMUfxoAoj7tR7dDddrmF
         IHdZiOaCKlpoe1FcoUWXfnL88bFEs3j9BysaaApW/mqWfaTTYUxJ3b0IiDVCy1tFR7u2
         EFpvpqH/oNUBApn31Ha2E23ni46G2n7+crnjWEOL46I7FvUZ7rAgbAmO+imt0hp1ADm7
         RHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989627; x=1788594427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZlfOvgBEtySKIOUVBBOTKpFAbjQZaUCTZO6eqUdoNDE=;
        b=YtFD8XTfeYSlgUA6PRI7uSCmwxi8TTmLtfnAZSa4/J97FAvoCNoR2jUsKWUJ+50n9B
         Zzu8qEpPKUEXqfb3179n6f2kbvFnjOWwqL4mex5MASBhypDmi8Z0+PBt3H+tMaPtvERs
         GLhTj0SXmrAqcNcTq8Om6Ou6hP3VvvI/y0r1HG3uhDa8lbmWhstgDeh/9zQFjax8t5+y
         fW8JvR2P+cvSU5AvNl9IHB+YvboQnjGctTtfUTl2c8TPR9mhr0cl4WO/KytqYOxMkLla
         JIwBI8lw7xANHC2bpMzykOugZB2hoUbAudHXtOa+O58TqxWnCxMFhifWwAvRX9EPb7hF
         yfsQ==
X-Gm-Message-State: AFuF++m+iFx1NLO789/7s5hiIDkN++s6r9aFSdTg/729eT6iOc+NcW59
	XmGgXfT0Wd83KLt6eQUyjc4bW8Afj96r9V/f4KFQtSrVaLUDhKkIaADo4MG8zA==
X-Gm-Gg: AYBFou1kue2AHXDy+xapka1P/jqWrh/FZOuTQTMQyZac3cAwgL/I6e69HRYfvxViLWp
	cmKno8C/BcvmUVIR19oncEunxcTmavRs5RovC/u2tNKKMkXkHcEuwFWPl+B1pBKiXkUoItO+6c9
	kev/kX7Fb64Wvq7XwEHLmGnqz6m75Y6FmcIyKOpJ+jL+1vTYEZ9/NwBYsZXLPAbxhun6KWcPz7v
	t8tmqFTNEBT75q9zWYy8i3JeMkaLF2ZBI6PtK7SufEPYvwDLlH5S01kcp/TRABNnb5IFjpfAV8d
	r/c0F6/8DbChsl3ox98y8nw8R0cAya3E/OynZU+QHGRSIAHj91zWiidcY1wKAviSeJh6ERaKag8
	miqv6YF/jZyBZL6bVhPqYfxidgAOqjVv8x+GHmSLRyrb6qYPc94yGJ2mFkoObvNPR5r29Aeu2JM
	FyPdTX8Q6wk/mu0ZBFSfiF+Sw7uqVMHr0XUWe7x+dcpPlu8DDwSFOIOOIOT5Q5giafUpmPtd0c6
	aHfmtgaFD0PeYcsFOu/MTrvvhrx
X-Received: by 2002:a17:90b:2243:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-3989b3097b0mr3060892a91.1.1787989627434;
        Sat, 29 Aug 2026 00:47:07 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1992435sm11159127a91.13.2026.08.29.00.47.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:47:07 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [RESEND RFC PATCH v2 02/13] mm/swap: slightly cleanup the code for hibernation error handling
Date: Sat, 29 Aug 2026 15:46:58 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-2-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 86C3A140005
X-Stat-Signature: oh5c7k8wc1a1b55mai8okt4bw3efi8rh
X-HE-Tag: 1787989628-832660
X-HE-Meta: U2FsdGVkX1/XBh7itpqql56c1GCqikd+Nb5ykcxDktnT8Tg7jLxwEXqm6QnKsn9hn1a+lJyCd7l60qRD9hkc3PgALaK/3GLLu5+zbO0MXEd18Q/meFi8S0bba+8E9DKZNhRZyrcTOLJtThNeerqigOzPba+tv2Mhzi+EsjyfmWDHOoG/zB4h0um0SW4dpZ3U/yD8Dsqag2SwYMAOSfcA3SfgKxDf6lujN0fRAk66BMw4WYPzrN+vZ4cJniy9UODpjYFsFg9hJDLNEphsojpLjlyqinwzXHlGWZcNgpP875lOm9x5lE8erdqeHGvBDyylyy6o5RMrEZg8VK+w2xef20Pwr0sXqaRR0hLOGcBbFXSCW5sRmKtFROEHJ42p4OkqlOFHSOn4WZhOiPphNxt5ljhE54L2cf49edM9Uiq001cCuT7wlDHUcVcFL9aM18KrKtoikQW/myVzeVcurfAE3PluC1H6Yjl6910QfIbjXfDlOpoys9YMUJKRrh7HiL5NvhH1wPO94XaSexTBLQlDW/EJQhAPbwHeQ8fnuLdDwHfx6FLbqYv7oEEbcq6zUR5HYEsu0qPAPnuNbQfGh6jOCZ4zAGqzWGUFJKnUem4yR5kdkVr06sbhEc6v0tKt6iXvGWW/y3+nrsyGukmvg/BlfgJv9x4Ue8vd2ARFdDah2nZlW4ybLOGHtI3fy90zeZ2MHVd1TCyMA1KM5STJomlVIBcvvYMaiaGbfmQOusL51CRX2vlbBiLJIh7Q1FNKdq1JuTHcfnvFnemjRVY4cTxvYqEjty0h3IxbWwXlLwAgYT/HiVE2SvrkrHfcrkiuOg8eNUyrfU+ogfeLzhtswc1Lq3udjXbo4S8rnrxulxa1lDIHCsa425WxI8IjpfjNpcPVz6kAuVFfW8qZQWxPdA3/WkXlfkjwvtC5u5GRawgEUeuSMnRioaDa/LmvOZZO/V/kC7uCOcxzmSKgpbPDXJn
 ih1qBSzN
 NZ8W7Sd6oibzlQ3uiVZthLD2CIDzKoHM5FbnV3iZMvipqtC/ilnlnWeXvuiRxidwdTtvUMQP2ZYPFDBuOVK2c9WkKvU8pIb0qCGvGc58nYoZnQeEeG4GnndQ/wpTV6oMsVSDkR6vwP3ghaZmI4i9+MnKlRDNjkbxdaGZ5it45G4E1p+XagBkC4LS4q4AYYQB+yV7UILcrLtq+NPe8dbhTIeG7duNb/kHKCVMf2u5T8sy/xFZ3OaE4XboI51EqsU4zsJ+H0VpOW9jfGx4MtKTNbKOQP76Xvcu+7XrW9hhQSQuYF6M0vcKto2z3KSf7K614bNFXaxrqWkM3nmOknqON+h2qaG1MHnwSK2brfbAbbQnuPhdUPU4NovdzfYV9OYDcXD/QlhYj5gfo5c4SLLOE70M8JUtfetXVlNFJj/8ptvl/Pef+suz1CF+n2vdWiV/1Y/Z8uW9FYOB8cmNXCIOCCWRaumW7V3tQQrTuEOBupXQXyen/t0MBZwlOYEp3T7/t0I3eWOrbUlfe8AA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Restructure the error paths in pin_hibernation_swap_type() using a
goto out pattern to avoid repeated spin_unlock() calls and simplify
the return flow.  Also simplify unpin_hibernation_swap_type() by
making the si NULL check inline, and clean up find_first_swap() to
avoid an early return inside the loop.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 mm/swapfile.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0f962cdfa5c0..46772d0e3e68 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2260,21 +2260,18 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
  */
 int pin_hibernation_swap_type(dev_t device, sector_t offset)
 {
-	int type;
+	int ret;
 	struct swap_info_struct *si;
 
 	spin_lock(&swap_lock);
+	ret = __find_hibernation_swap_type(device, offset);
+	if (ret < 0)
+		goto out;
 
-	type = __find_hibernation_swap_type(device, offset);
-	if (type < 0) {
-		spin_unlock(&swap_lock);
-		return type;
-	}
-
-	si = swap_type_to_info(type);
+	si = swap_type_to_info(ret);
 	if (WARN_ON_ONCE(!si)) {
-		spin_unlock(&swap_lock);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	/*
@@ -2283,14 +2280,15 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	 * the same session.
 	 */
 	if (WARN_ON_ONCE(si->flags & SWP_HIBERNATION)) {
-		spin_unlock(&swap_lock);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	si->flags |= SWP_HIBERNATION;
 
+out:
 	spin_unlock(&swap_lock);
-	return type;
+	return ret;
 }
 
 /**
@@ -2309,11 +2307,8 @@ void unpin_hibernation_swap_type(int type)
 
 	spin_lock(&swap_lock);
 	si = swap_type_to_info(type);
-	if (!si) {
-		spin_unlock(&swap_lock);
-		return;
-	}
-	si->flags &= ~SWP_HIBERNATION;
+	if (si)
+		si->flags &= ~SWP_HIBERNATION;
 	spin_unlock(&swap_lock);
 }
 
@@ -2348,7 +2343,7 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 
 int find_first_swap(dev_t *device)
 {
-	int type;
+	int type, ret = -ENODEV;
 
 	spin_lock(&swap_lock);
 	for (type = 0; type < nr_swapfiles; type++) {
@@ -2357,11 +2352,11 @@ int find_first_swap(dev_t *device)
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
 		*device = sis->bdev->bd_dev;
-		spin_unlock(&swap_lock);
-		return type;
+		ret = type;
+		break;
 	}
 	spin_unlock(&swap_lock);
-	return -ENODEV;
+	return ret;
 }
 
 /*
-- 
2.55.0


