Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3B2CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1A38E0002; Wed,  3 Sep 2025 03:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79368E0001; Wed,  3 Sep 2025 03:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E938E0002; Wed,  3 Sep 2025 03:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9709D8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:31:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36D85140550
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:31:15 +0000 (UTC)
X-FDA: 83847118110.26.0AE89F4
Received: from cmccmta2.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0FB2320006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:31:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of zhangjiao2@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=zhangjiao2@cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756884672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=MaMudOYArg+8r+yOnyKaJm7fQg/29WIGQKxUPJYG6Oo=;
	b=VxpAQ1a/P/VawIw8pkQkL+N8C40PmMmJjkEduQQDU6mK6nq29Fyt1HtVoinUNLcmZ3iNBy
	FBX/H5N2m7Ehhw+ZoMGmkgYdKNuqp1SITx7e1B2Wm+SJ70H9FyV6CT+a3Quw6B8a4/L4RF
	ufOVuhFgdb1qWUH56jpjK78mqlCjELg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of zhangjiao2@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=zhangjiao2@cmss.chinamobile.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756884672; a=rsa-sha256;
	cv=none;
	b=4XCo3BHAsL2diDZQ1P7wrPL/yUSh6YPtxFFrgiYtVgNqYIiemQLFafEYThMMyE7GaEgAn9
	bsEJhzxI6JOjoVwCteoFdBNPDcDi+pcGDOwSipeHedikAmG8ESJ8qeEw+pCf3RU2FWb8eR
	wHbsi73D49nrUE8lCdcPDU/pTndM1/0=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee668b7eebcb2c-504bf;
	Wed, 03 Sep 2025 15:31:08 +0800 (CST)
X-RM-TRANSID:2ee668b7eebcb2c-504bf
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from Z04181454368174 (unknown[10.55.1.71])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee168b7eeb90cf-63bd3;
	Wed, 03 Sep 2025 15:31:08 +0800 (CST)
X-RM-TRANSID:2ee168b7eeb90cf-63bd3
From: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
To: hannes@cmpxchg.org
Cc: mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: [PATCH] samples/cgroup: rm unused MEMCG_EVENTS macro
Date: Wed,  3 Sep 2025 15:30:59 +0800
Message-ID: <20250903073100.2477-1-zhangjiao2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0FB2320006
X-Rspam-User: 
X-Stat-Signature: qh5i1xps71sidpatezxik8wgaa3ok489
X-Rspamd-Server: rspam09
X-HE-Tag: 1756884670-426901
X-HE-Meta: U2FsdGVkX1/FX147z8mtZoEFr3Tzj6YQIWPKn6ipAkYJrP+pNckOQmUimay5UCR26yYdlfkvlKg7reGyfjAO0tJpPjM9N1tVnCYRh5uDQnJkwhhf2nQOCQNJpTwyrYHqq8O4ySDiaAhJbsWQSKl8ouAAWQg67A4+6BrD/wW/NxHh/gc0E6YGkXAt26Eycsus4WXzN4+xxjeJwD6KkqRZ3b4rRMH/x9DH83E2ztywr8TXLUEP5XoYKC5aeyRvD58oIc2yZufkIAciZmVrfm644s6zlKhwxit9XcrWY0LCup2+Xq8q3d+bN3iNJVTegAIoPQRAbxMCzAxb4i1uQNRybnufgA2mvAa5TSsQArW610J4modFN4/OhxvrUdPleNSrVEXAmdlw+izaVjsNPT6rXdiF2pSpoQzS0wDO/IuLYeXSw1cZy/iARN0B8ogWqtKvxNPVa4QaRUR1z9WlSKQIZQ4GdRpeXHoWLXN28wpZW2VuwaWCgHehkCgPnqNvMsaJ3FtLj7hP60K3Oi6Q3WTwklWmp9WpAVdfPCsMmO8BelQcUJNJYeQmdqi2WqoW87TtJuJJhFYwIua+EW0xNQLi0yYLNBE9vG60R2GR0CVervBXrYfcpTJ/VyqDS+Z0g98hOE80HfggzhFZMzk+i3NmmLsMpdrdKSIUtJ1v7dB1YM4S4cyrImeVJbQA5dzxTOEhyz8UOYszQvIKwPUTs8SQdY4DqxUSKAaTInryP+PpUu3Ak+6OLVFnW8FbWbFX+jK+k6NUSoQcOpHDaAQfS3TxiqtSVpBowUJwOgbj99Ov3CuC6dWiSkU/EaxAvZKj7eJDmY8NIvJ2Eywzs3of056WQn8b1aE1qwmCsdqorQEtE+oxFhyhXpvfoCUlZUll0fLsS+D8fchETF2zmFbbGuGqPnVujQSTW0lj2uisFcjrOsa9ffhjM0gwj6w8QtaGxDyN4fB2z1rFsf4keAAtCeR
 VvWcCsBa
 zY3DSMoT/XwCBwh8rO6yax9iupsj++l8lxImCpposBmZkgeZYiqEdxmqh8sRTQo4wLwMdVi3Ca0OpyKpC6AGQB5eVQSB1sYL+uqcHHI/JsEJ6+Rw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

MEMCG_EVENTS is never referenced in the code. Just remove it.

Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
---
 samples/cgroup/memcg_event_listener.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/samples/cgroup/memcg_event_listener.c b/samples/cgroup/memcg_event_listener.c
index a1667fe2489a..41425edbd88a 100644
--- a/samples/cgroup/memcg_event_listener.c
+++ b/samples/cgroup/memcg_event_listener.c
@@ -18,8 +18,6 @@
 #include <sys/inotify.h>
 #include <unistd.h>
 
-#define MEMCG_EVENTS "memory.events"
-
 /* Size of buffer to use when reading inotify events */
 #define INOTIFY_BUFFER_SIZE 8192
 
-- 
2.33.0




