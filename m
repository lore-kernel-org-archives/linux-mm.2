Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11A6AC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0936B6B00AE; Sun, 28 Jun 2026 18:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C676B00AF; Sun, 28 Jun 2026 18:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74E06B00B1; Sun, 28 Jun 2026 18:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFDF06B00AF
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C0C41A04DB
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:32 +0000 (UTC)
X-FDA: 84930693624.11.35BE281
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id AEF7A20002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbVX7xpr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684090;
	b=YbL9JUW0RX8oV0nRnrZjucr4IySWNBUOzkumhNcezm1iEKL2rIpuXh9uNPGeh3K2oT40xK
	KRu9dtN554VlRE26H/g1NqsyVK2b464Bvt5agxyijuIE8Ff9a32Un4ejLulHlnsonJ6EMg
	oyAcAZPTI+DqJHdWuAIyIZzsaXnHYLE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmB3b/npGhBxKB1bt9s9o0NNa/GR5StMFfZ94pT6qAc=;
	b=QX2nf3DM8eMjADpkcMQnKc16Ha/VlgfVGccJXHHctEIqlGKx3fH79Uf3miCk1wVo7XrX3L
	HTwfNFypSOXy7igZTVem3qbUAzjwuuBoyAU3SMgAFmEg7c2PZoaLMZessQyLbjNNcAvGrc
	SL8CEhEYE+zx7nPZ6DdWt5ObOPgNcSc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbVX7xpr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C3F2600DA;
	Sun, 28 Jun 2026 22:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD52E1F00AC4;
	Sun, 28 Jun 2026 22:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684090;
	bh=fmB3b/npGhBxKB1bt9s9o0NNa/GR5StMFfZ94pT6qAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbVX7xpreBe4ktCRslGI5Q7jXTCI6P5LRMQMd9ZH4UwEOT/xc3BiULbsxpSOd9r0p
	 L1454zI16P8NGzMpQffPRBmDzPHOUOsD3yMMXv/Axmy9b9cMwnBdH+ZeL1YJNQTp4r
	 HVK02QQzYuqE6uwnp1lhuME215o0xjAw7QIzPXCDqzqTQv4WBV/j4C88JnmsMnoLWk
	 zPw9YFzPHs6r5ioRRCt2E4ltdZAAkb4uUlXF4oY0C4eEzvlCMRpiolECOtskyKJOcP
	 yqciI8+R9JDzogO9xlxPm+/HN9MRto91y7ns2F668SrfcCPzVOqlDGEScoruIDh7ft
	 oRSiKlbyaXPaw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/11] mm/damon/sysfs: kobject_del() probe dirs in probes_addd_dir error path
Date: Sun, 28 Jun 2026 15:01:19 -0700
Message-ID: <20260628220121.97360-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEF7A20002
X-Rspam-User: 
X-Stat-Signature: 7q5beqirkbtkfba499w8i3rwwr7k999p
X-HE-Tag: 1782684090-591377
X-HE-Meta: U2FsdGVkX19GHh1CgnMdgsv59+AmXiGacHye/JNh5NGKZDBT5k/WLrPmi/U6unT14/NgbdjlS8mVol4mHEe/f0iP9UgQ++/CCGwgrnucbTy6/cprXNNcxyJaxdVkXj7PW0yUX1gvZaEUCJzITtuIOxVjs9zevzmyd2r0vg3sZljU6By5brcJaCviOgO0fV/SL9/fGnCmrf3L76GQsrQx6r40d6SO0TcH5SdVeDbKpiYOdVhInc3+XmPknwJo9Ak6o2NvgWVaBRZgjLMFQoCi7uRjWPFa2kvQq+qo8eHX5jcD5dE0MFomQsA75k6JjS3b2I7jBTZXBjmS/dx5cjH71BWeVekB/VSkUrxBVZR4uA3ju6ZucLqZ64ZxUEuiu+T/oCQxtanssH5BTfaE8kmKAP2EQZwAIU5k0868ZY9v3IkaRBQ1N/teuDt3JWpS5NzwDxK6eCrZv5OlZKpzIYOYwuyEYBY3hzyJFtKTG5wTZVikTdU8AB6cx5gwZUv+MwOagn6DkmGm1zWhoECnjGEdRh+GLL/BVccNNaoeJEmlekECOixB2qRKvmaGIAgWXCiLx4M1/0AzlTcDoRctzPJDlASZWo5YEX2sdeO+snoA8mNo/4v0ixHkmOrtIMBRtDwVYXgXZu2rYyQmerGPzoFlc1tRmqNnk2bzu9MFSQwPxr8zgNPvJAv2zRjZiW/IMkzSlyNUt0moUokwEx1dgzkkzFNanGrR13RxehLwpYVO/MIZIwRxbL8JUC0i2+6MMYk4+m2/t8eTt/wWi2cYu5sPXNRhmLFA65qouOuMXbxPli/SwvP3DDrLIOtpQItjYb41MVo91GW7gokumIfme+ss+Q2s69K5Se+I6Gy00UxhxCgEf5zQ4kRKQceh4BZs/FiYKYOU1tXG0uNZlnUcr+3NBjRmxF6yz4AY8jpwOyWtBDm08oYSZyVmWbOdWoOAQy0IWUZzO94MBHuoT12LMo8
 ZjSCF0D2
 GvCrtSQLdytJhQF8IZFAQwlAlQNWn9vOptvZngGOhLMHhM+f/kNba1PBNJK6lY0YyVeMSsO9UM73veoEIYZdwJC92f0jBcSoatCGQmla1tBxDeD44wpEP7LN2HZcsbxpbD83UVaqbc+xZnMAsUvSfh/Ype6AvxRYXqT5/rTmLmblTqiSF6kF7lAbVw3gsRJ3NMcVbOdOqeBHbbeJCQB1MWoAJrlNju5cKxR7SkYPb3RisKQO9zYPjjZhcq6DktS90LVZG8dmr09KkhCZ+3+WVZsvb+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.
Fix the issue for data attribute probe filter directories in the error
handling path of damon_sysfs_probes_add_dirs() by adding a kobject_del()
call.

Fixes: af7cb41af9a9 ("mm/damon/sysfs: implement filters directory")
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 0ccdc71275d52..e3526a263e205 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1181,6 +1181,7 @@ static int damon_sysfs_probes_add_dirs(
 
 		err = damon_sysfs_probe_add_dirs(probe);
 		if (err) {
+			kobject_del(&probe->kobj);
 			kobject_put(&probe->kobj);
 			damon_sysfs_probes_rm_dirs(probes);
 			return err;
-- 
2.47.3

