Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 281E5CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C128F6B00A4; Wed, 17 Jun 2026 10:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74906B00A5; Wed, 17 Jun 2026 10:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8B326B00A6; Wed, 17 Jun 2026 10:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 709F06B00A4
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D225D1A0491
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:47 +0000 (UTC)
X-FDA: 84889686294.08.98F062A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4E5A3140003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fy6S+g/M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDjjHeE3ik/DACcTjgmd/gOCffqc91TStH/d4lyl+0A=;
	b=m02gJh1F4mOistkpekc2keO6+GTckWPeVBfurylQGeCnCE8KvIHBvTI0qCR7JUIUjGtn7b
	B7+rIxJPCWBYA5KsYodH8fqU8EtOIE7ZL46ZFRy5/my19otLo7SSrv8HRQ3M8RvrQHAXP4
	MyZuvaH729pcYuPWAww8iyiW6XJ1kfY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fy6S+g/M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707726;
	b=XibQNt/+/OFGMJVPXwRooT5BEL7YAZKzg54TCSOxZaHM5baCS3TaxyqTcC/n6qJJW85DO9
	6OD73RpydKIz9kk0TTqewM+jgvBUOdNkRDr+9s20+BWw5qwlW0JTTZm9KH0ojTuP0uH261
	hYEr4TMpAZJYnxfWItcxPLBLXnep0fw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDC8860103;
	Wed, 17 Jun 2026 14:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9441F000E9;
	Wed, 17 Jun 2026 14:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707725;
	bh=xDjjHeE3ik/DACcTjgmd/gOCffqc91TStH/d4lyl+0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy6S+g/MK/ISQR2I32EJsEB4grURqXEipGqfk1mscMpuO9ztiidZGhOWTl+BtvkkS
	 iv+WYXxOHxVgrKPmPXkSgeMso+cvjojMoU11EGce1S+fQvG2VHobPCMsvIvyu4zpbC
	 qywaVfNLvJxbkQ9Eg7MSWIhqDPhKX2lC2+DlvZboy7AKRaRQ4AchFCdEs6STZbPl4X
	 hl/OH8PNPLvTYQnYZ5uM0r1J7tTagWMjxH8UG+0Pe8auzYYbyLv8JaAUG3HhxSnBJZ
	 KB+oDvlOECeuyJMwnI99ZC3e8Dom0dWjRnEH1vkSiJIv495Ctw8z4pgcGVfSAfR7u7
	 rIKWhdsszaZVA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 08/11] mm/damon/sysfs: kobject_del() probe dirs
Date: Wed, 17 Jun 2026 07:48:02 -0700
Message-ID: <20260617144807.91441-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: y53j758mbso53oiqe37x1wiht859uzrk
X-Rspamd-Queue-Id: 4E5A3140003
X-HE-Tag: 1781707726-312821
X-HE-Meta: U2FsdGVkX18Kf6mGPxDIq/kU+AdZs1mVLzu99bM97yndTnR2/UxxYsCuya6+V3gJix/spKOgtRbc4ht1Q3AGxUfcnh3H2hnCd7a7uzlW4ngJTyd38f4dG1QYMpDKg+/go7V2m2aCzlA53A0IEatTdjDQc7WSSrR64ejdn9zChlIDCWjQ/RISX9lngR2KcBTj7PshBmdBo7FFTOpZFniZz0TkdSjPdUkqgRQrAjJq8VkVHhL6CFagyFx64iMdgMsySUf1rZtRTCuw3VukOSW3DeRtcvdIiKafd0AEJrSNlAzJ8OzQixvyp2qCkW0kB59DM0CQvqxkoCzsHjMqGeynBn1shR5fUoHiNLywEzwbpkdFZuXDfsb73WNf7z7Hhieyvd6paLhym3GGl6UipWyW8wbpNEPgcZcC25EYUIFdmg169K4k81piF28BfkFF4sn5GpW8eaDM/4ZbPhqNcnCeCQxEpJByMEdSeSZk/ZEb1EDOFDL6dC7SVReiNcf3aRW1u81toTEU6FEMoXUTj2vqPYSt9ffSi/92g7wcDJe8Bhvfa1MtJ6E2p/u5kbfPthNwnTuxm0dJ7btTb70C7CdAG54DW7SEOOBM3Wv64gOgrLRST3zhvpnKzLiBG2Q9F5gO9v5bhgbb86jXzj6ygAcPKTUDZ9U/7U1D+MD94FAjsDzSAiYg3v74AwBG1e2nxs7nTE/VHsqh/KkyWV2UiiRFodYnrvDq0hE0ugPLxUhwyru84kBVPr2c/QizcAQlFlZB1klKpSWWagLnK1D6w0h8WkY8FgMUrnEZqRoXiJpywrfON5SuGVMFbgYadTaNoLt/ZroSUdawY6hiwsWWIfAGyvQV4oh7nbAUUdU6Kdt+4K5UREA3Btpj6A+9q8PBS+vsOXaS+xS3tDc8ZB7yNCTXWPccMDaVZlmezx2e7RPhSdPWZFATWhanKAxzE6696MyRB5894elqY0bZX4T/vQ4
 V+QqzXlr
 8wmgqQMwYKdrvyT3X3s3LLsosvAiR5iTMzjG43Kz0w9eJYo4lURnuZnPKXt5pMDd99R/USt5yAr9jnWn0P6bua80f4iUC1NP/62mQJ7dYLULF7dth7qWNQMzsY7nfN/MZCOcDkGDktJ9JBpoYuzpWmPKvxT7Nzo8barCWD7u89o3C5F1YGNk7lpj+zOT+a01Tm3U45r+xtBWKdm8l4odJ5qQl2pH2y/EaBwq6//fb/Bdn5+lAi5ame0egx+wmHEQM80sHE172Hj2EAMnJky/PLTmlJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for data attribute probe directories by adding
kobject_del() calls.

Fixes: bf3ea3d30880 ("mm/damon/sysfs: implement probe dir")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 3c349f0fe80f0..5ca45654cdd39 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1139,6 +1139,7 @@ static void damon_sysfs_probes_rm_dirs(
 
 	for (i = 0; i < probes->nr; i++) {
 		damon_sysfs_probe_rm_dirs(probes_arr[i]);
+		kobject_del(&probes_arr[i]->kobj);
 		kobject_put(&probes_arr[i]->kobj);
 	}
 	probes->nr = 0;
-- 
2.47.3

