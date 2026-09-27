Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4934C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 12:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB3A6B009B; Sun, 27 Sep 2026 08:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74DD6B009D; Sun, 27 Sep 2026 08:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963FA6B009E; Sun, 27 Sep 2026 08:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 706576B009B
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:06:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E40A51A09F4
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:06:06 +0000 (UTC)
X-FDA: 85259413932.16.97E81EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 553C020007
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:06:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IDs+j7aY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790510765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mS1OGjGueuh9xRDDJo/iscVAdMoJD4YdolHQuoVSGCo=;
	b=OWMTPdhL3TiW7x+LrOnN+9kSsEstmRcpVGB9GRyy/yrpSBEywzxijT/uoidl8dar+4Xvjg
	7cWNx6bB4C/zQc+XqwXYvrL2SwSk9IzG+Fekz6BgJ0HPUxTMLjy3/rOHPTX/4rQBmecJlF
	zKN37lI8zvktmkPVvCVThBb+X0kVF1s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IDs+j7aY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790510765;
	b=G2Oz5FSpSFKsYclqieFJPJ5rIvY48gkvwu4YFe2WpYRbjv/g+cRs15Y7hmt7uyybuNQ/Mb
	1A9XgqD2SpNBY3GPdmPtXhS+CSewkPdYijr0D00ivkNAuVf6SyL+p9ztDILhmxapaC7F4f
	oAchXeyqc+/kG+Z1Swa4phoh1eDQskg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECA7D60AB9;
	Sun, 27 Sep 2026 12:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960B41F00893;
	Sun, 27 Sep 2026 12:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510764;
	bh=mS1OGjGueuh9xRDDJo/iscVAdMoJD4YdolHQuoVSGCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDs+j7aYB+5xjvIVONVtCP5GQXJklUoB+f7CdnLTd2uxDeAYLaX73E9EXqgPH248p
	 +iElyfQD6FUs7HyVnijDWBSxsGFU7w5/h1x93dbBhTCEU6PWg8XfRHiJ3li/FX6P0n
	 frf0DLnmIo02l2tu+dLUuUXn/g18gOChW0gUac/UpbD06Y+qunXg6llXkgZXiQPdZJ
	 x3wjS7klRtKXf2t7UoNfhvRmeDvaFr944lxANyP47NIBQONlUjhMravXe7Rk9iegvd
	 GHywvUjRnbJFiZXnrri7dtZCVss7B/GkAPwBtWvkDFNoVhndyGrMKUKgYtD+eDlyHp
	 59Hny+Rjwk7Lw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 7/7] Docs/ABI/damon: update for quota goal metric complement sysfs file
Date: Sun, 27 Sep 2026 05:05:31 -0700
Message-ID: <20260927120533.50484-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927120533.50484-1-sj@kernel.org>
References: <20260927120533.50484-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 553C020007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ufwauejcbnxtnub8up59d63b3zoo57ka
X-HE-Tag: 1790510765-458119
X-HE-Meta: U2FsdGVkX19sZsUKB3IivZiXheEXo8n0/nVsdvZ/ZbeBdlV/wqeuH+E66d1TLEeFODGuaUWo+nKl1WLbZCbdz0IyhCRSBJ+Y0QKXuMdGSnHRtRBTnZ06g2uPISDlRmSXBOD/9qyNYV5m8ZxAiy19WDbBOdt42Y/OJAAXL+zM+7KTuA1jWSrRC/8kPPNc4QMwcR5MeIivlgOLAlqIMbxrasOSZmnDGuUYKRIWbAShoSbhW6WksFbioi5pIR87JsdCdrbSoQtj6GDKfcBNwlmDUqnEGZhFFTT5eCGL/ucV2xL26QH8Cam28E1e4XOgcJ4i89JQOssn7/XWmAcy0jV5ghT+vLjzjj90VNziHMQHsGYDVprClF41mBG3gGVV05iy+dy5oVV+pvgmZ+PUDyHuU9Yjy5uKSeURuniuvOzEAqOIoZOTSIlwxFvblHuSDzQgyPIHJPXbcZIENMrOfBlHocYrgGloOzVeo/W7NrgdccbcWlJkIbvzQtQstc+RBj6XRr1tM7Or3tEt+F7/NoJHFZccg6JXmnYssFX4es9GXYzONyRA8DQBXFOSslkbtNGtXKqcKagAM9lciB1+qXM4dbJy1kyVfNOkBun22wNdYyZlTKrjbmXTIh65utpdalDSql+ZKWYvcJIX29WI4xO6GR1jvM24brK9WidvC76bRZb317Fd9s+xBipegjiRvj98U9uxHDD0VqIetcnTRo2qI1oSxBrR7Umy8p29iSwhRQj2HKQq6/iOUpms/oCz4mtU8n+ez3S2kYo6daPambI9SItfEJErrMJDdPyqn5N66JwX0oeOoIA9plBTatteb9C9DMSEhzwXZFCe2nNOlOxk9HJuIRAMQD2Ldh9VcPYn+Z3exPQZ+jhgk3iWllvYjkDIr2I/oVZFKTPHB4otaYabMin4CnLBfaIS2KK2nPa3K2nG+9EFrAar8TqTdQCciqMQshskXwbOm6YOyyBpoLV
 369FA8d3
 x3E9iktb9rRlc+kJsxYzhKYb/r3dxKAjRhDA897fElW7JUNnev1j5SGcuZZcJz5StExLQs4iebuyd7E6hWpCw4EQGZTPVuxDCMI3mtoDIpZ45mssoYlo/6XD1hSYaZ9dKBtHyJOX1Hk7pXTDxVk7dROn3eR24a25BjM6zhGhr+KU+Qh5Fl4Bwzag1teWNFbcnLrlwOMw5sLCErVMSKsfOV5N32gzw6rHMRaosC/sAlJ7/jTWoK49fXLzo2+tHCz+rloFBhmfNAIUeCa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added damos quota goal metric
complement sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 55df688ea596..4acb2015c2f4 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -375,6 +375,12 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quota
 		auto-tuning goal metric.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/complement
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets whether to
+		use the complement value of the quota auto-tuning goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
 Date:		Nov 2023
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

