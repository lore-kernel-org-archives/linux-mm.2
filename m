Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC8D1048922
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 00:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9CEB6B0005; Fri, 27 Feb 2026 19:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A146B0088; Fri, 27 Feb 2026 19:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A769D6B0089; Fri, 27 Feb 2026 19:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98ABD6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:52:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 059FF5BEED
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 00:52:13 +0000 (UTC)
X-FDA: 84492038946.06.BA1CCF5
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5E2FC000B
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 00:52:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=mNLKxexx;
	spf=pass (imf10.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772239931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAoeFfADvJ86Hh0vJUrgbphPDvQiwv+aA//qYUUm5aM=;
	b=q4lrjeM0P6NK42lJl5DenfKjtHmrClJsIU5Y69p+/bIC1omxT1836rzzRvQMa+Vesgqxpq
	ZMXibsXOoDISRB4G0qiUDwhJDvIC+L3bTa79ueywCiun4mCE0bzpk/WkktZZXX23kS5K6f
	rFTGqwP5aVHeh+oEVDfnGrdGMZB/WKU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=mNLKxexx;
	spf=pass (imf10.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772239931; a=rsa-sha256;
	cv=none;
	b=Y3XsjPTiGlH5mU2DfuXXif8hOM6uBp8O7f8dag6/BU0sfMLlgPWbfNQ8Q53RbFONqusL6B
	qJef6vhZy6W5O1rAuiCejYEv31LUtE7twAjm7AdM879LAxMhvCWHiCmK0fpqJS/+i6ATwM
	dLePAqcIMc3APYuc5jielS7cWJ6LFEs=
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 70ACC26F22;
	Sat, 28 Feb 2026 01:52:08 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id NJgMBd4AjeyX; Sat, 28 Feb 2026 01:52:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1772239927; bh=SO4P9lTr7kXpn3uXHaW9DqgCN+bZeD2qLCDUrth50ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNLKxexx3w2Sy7feiSp/4TjbEFtWDKDME6cOnKdKzogMbWBPZQZlPHrvkJQAWXKup
	 kHhY0L7ZdIpZt3dtC1M8KIdD8j+ks7SBPskUsJocUowm6TEsS7sDKIAph1931DjXWE
	 mC7AdsmbCyJLbHRCevZauoBdDLXYJUnaOQuveV9ph08K2cSO7bUcrLfzlTFHvuwsbx
	 oVosavZhSKkdm2UrNvXnleHNGHYkldNu7qAC30E2FGkvJYJZoum8D1UsUjO7EjHfg9
	 XlfyDw0g1KHjxxmBZ9ofUP+l2oi4fR+zue6kcavEi4SGkG3QmegYUeGzHCPjunvDWw
	 CS/OxdqUqYeRQ==
From: Benjamin Lee McQueen <mcq@disroot.org>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Benjamin Lee McQueen <mcq@disroot.org>
Subject: [PATCH v2] mm/vmpressure: scale window size based on machine memory and CPU count
Date: Fri, 27 Feb 2026 18:51:44 -0600
Message-ID: <20260228005144.47807-1-mcq@disroot.org>
In-Reply-To: <20260227122857.dca67a5f281e39a3e78acc74@linux-foundation.org>
References: <20260227122857.dca67a5f281e39a3e78acc74@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D5E2FC000B
X-Stat-Signature: kmxoh7yrchpjpj9or4tuztjkke1s9594
X-Rspam-User: 
X-HE-Tag: 1772239930-537430
X-HE-Meta: U2FsdGVkX1+HQInkhML2cLnN2S7qUCmNvpQ7FEUjp+h+I1OSjrXCJH8wl4Q4xunB8IqoPlamUl4bhw7tjtnQvo26q9pomZ6gwwwhZoHZMcCInWndTSArIzraL7sR9/4FDu0UwbZBa9iuToCnaUDQ55VdzGD0X8SBe9qYLu2PTM7jGTHPHfLoKCBAvkCMjCjCFFDwZ/81I8DF79DKzXc8rDihQazcWuV6OdhFIM2a7o1Hk6bgIdopHhUCguGlstuOexlcwqd/okDSQyPRq5l2/Cbbt6e7Sbg+SW9VKx4TIMSsHmGnqF0q/P4LGzeaBxqR6kPR2CQrhRez2gFE6ChDyIY1FGwNQ7EU5ivqESzBP6qnKIOs/pVbvrcospPIvn7pFWg8njX6zO/EYRxy2W8HtmGJVTqtiSgu0ydfTVUjoQMnb6kw6LCx7Z8XHntJfD5s7I7b2208ZzaAJezzbPI5beWJwwROK6HqeAWeFLgXG+cIK5QBuCuH9aLkqCPB48+xe6dR+UX7rY/uQrqJJLWQZxuu1MAFRNCVs11a+BiM3IL6kNgC0/5Iiba1OHQA67qrl6vz2g490jaZhc2W8F9HZH5OqmqUN74fAkzY/kBf7o6tWrsXmpcLJgUveabnUg9NRHO0QQkZWrnwH4qL+2boX/6XvtpgwSTu9Q0sG+HeTfZ+wIDFpjUQEFxBIyfF7wzpy4g+krHKAAeyYWmDVaETl1MgvpsRAQIJr2Gdf7XgVic1OHQvoCRVGGRg6/8JNwXLziFk9/+rz+F3lWoC8qUVZZzKq9p7F3FYwYMlQcA0ZOqdRZzQaQ22hR2QNVMQmSlYE5SUL1/vmMUcMC3Ktmz3keQ/g9Z1pu4icalXR4QNG2v5VeCbcKHASLjm2q78wnNmRDtxANAtv/NsQnONxWeNAjtd8nxtR3ULQuVPYPMUeo4zuyXUetu6449kThItx/jqKp0GubFmh1yJm5FYZ18
 eAptBqqs
 nwPLC9tvXZAzNMRV4gVd/QAR/UIHwrfvrgc9YGon7AJNMb/ZrLvQ0woAlEsGtpe6H85EuE8fzt/F8rjM0YlBeQbRWxSoaPCJRxwvZvaWqu/kee0EyjGC68vtq2JaKZyWcWehm5dDF2ZSs+PWZ0K7x+ViXsdCxeBZoZls3ywSSj1dcYaPmhrjunmpIn9h04bnnptGSITEvm7gTkSh+jTF4oJzVcVjZQbs/zAWAMA9CcXE5jCSpzn3hTdjJkvhg6HZgoQLDVLl3DcqUVgxqLA13o4k8zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

on systems of different sizes, the fixed 512 page window may not
be suitable and cause excessive false positive memory pressure
notifications.

or should window size be capped to avoid excessive notification
delays on very large systems?

v2: better commit msg, also tried to fix the whitespace.

also my bad for the multiple sends, i couldn't get the format
right..

Signed-off-by: Benjamin Lee McQueen <mcq@disroot.org>
---
 mm/vmpressure.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 3fbb86996c4d..925659f28dcb 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -32,10 +32,20 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * Window size is now scaled based on RAM and CPU size, similarly to how
+ * vmstat checks them.
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static unsigned long vmpressure_win;
+
+static int __init vmpressure_win_init(void)
+{
+	unsigned long mem = totalram_pages() >> (27 - PAGE_SHIFT);
+
+	vmpressure_win = SWAP_CLUSTER_MAX * max(16UL,
+		2UL * fls(num_online_cpus()) * (1 + fls(mem)));
+	return 0;
+}
+core_initcall(vmpressure_win_init);
 
 /*
  * These thresholds are used when we account memory pressure through
-- 
2.53.0


