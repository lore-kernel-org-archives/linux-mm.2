Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E9BF33A68
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47A96B0096; Thu,  5 Mar 2026 09:05:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08D86B0098; Thu,  5 Mar 2026 09:05:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21A86B0099; Thu,  5 Mar 2026 09:05:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF91D6B0096
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:05:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6CA4014013D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:05:42 +0000 (UTC)
X-FDA: 84512182524.26.1B0D993
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8EC7C140015
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:05:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=sdJhfNPp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772719540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjzA29kHyaTu0CdBE4NiO/4Dgo4yhaY+vy+XeTjQsZ8=;
	b=2t+WB6JafONRfoOUdbmPfOgvP6l978ilOUBHAvK6VY/cDvfQe8H2tStg0oSOhyQMYSr+9K
	FIU/gRgHkkLfSmwxXlQ95wG/VsFvRVRQ42Rjq4J0Ge5aLoAgGRyLEgZ9fYYfGe5NSDTMeU
	EDH/Ro3MdgcH7X8Pae0nid/5SqFDREs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=sdJhfNPp;
	spf=none (imf23.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772719540; a=rsa-sha256;
	cv=none;
	b=WrJCIfDcgJt1PJNrq4pABygWZbqcklNQDA31b4EbRVw7+5Dfz8zVx8+4UHRW4obhFMutlC
	XAM95rosE9vAmSgd9UT9wC33lAHHjo+wq9pUV+FRORbo9f+mIxixtteRsL2Y04HYKZ2bti
	ISpk7Z+V0EJzXwYSzaKly3JcTw+mxbU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=fjzA29kHyaTu0CdBE4NiO/4Dgo4yhaY+vy+XeTjQsZ8=; b=sdJhfNPpD7+8Cj3rgbiQVD8cKt
	isnVz1owe1lg0hf9QufeKy2IgsOb7KV8JTH/sUGfJZHpb1SADvGHECEQ7+DGMyBeVylzcdSmAjEE3
	ACrFXaQLo19u41WFGhpERD6FllJoS3JAe8BbBJLviWCH5ZanlkyvQIxItX3qE8lt0SjhemUuWE3FL
	zexFgy4wMxftbTkrD1oNGd31z2P5ZhGfjVQqsSXGEPeoFiGF4m+5mK/DXJX4QV2KlthXjDG+rtTX5
	yN1zDuYyO8/a7zfi7Lj95iu+wOc45k437XoMAHfbuOf/MR684cfyql1LrkanOrRcFkZzR7pmMxBpm
	1c/unbjw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vy9KX-00GmQG-CM; Thu, 05 Mar 2026 14:05:33 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 05 Mar 2026 06:04:55 -0800
Subject: [PATCH v2 3/3] mm: huge_memory: refactor enabled_store() with
 change_enabled()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-thp_logs-v2-3-96b3ad795894@debian.org>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
In-Reply-To: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2816; i=leitao@debian.org;
 h=from:subject:message-id; bh=vPEbT2v0zbvHi9a317nXlZeg63vRGu0w/r+o1EvSR20=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqY2VLe8cFEQJ0smLQoRFwTTZeGaiiBLP5OWCE
 ofHndUML7eJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaamNlQAKCRA1o5Of/Hh3
 bbbTD/sFCO8p2fCAXqoAiQj1ygh1y7Uv1RIfgfZU/0tkA3h5dl+rWGjq/t+DEGTWWFqucssKNcC
 Nbh4Z8fvN10bHoYCu52NpP4ezHnnbYUzhOs6u5nYiww4U73gKnSlHTHrDOXtLnJtQn6JrjJyQRG
 xqtl3yIXMc8bsrPfW75NrQkhM4bsou2oJWg6KZ052aJPXYpNJcVYWFSTJCxaEEQV/CH0fDV5uMY
 sp7nt7a+KILFxOSVr6X9HT1I4bYJl9fHMi9Ec3XanoXcQll6QooiOhcFjJuPZ1mFmqA2bF/Iyyl
 CkJw4MQir7yAkk3c58c9QUaUPizTMJZ0DBU261SaWMz6aQzlUUzLLdk9TAhX4ysHTyh+o3mVcls
 DN27tAstnhR4K8JBrug1GPlaR1PjO/GEsanP7UjptMwqTgc6tB4dMlHGwA2yaqTuHw39yLq2ku4
 dZPOVZTMnHmeyoWtN2KFd8NLCajUnyTkRqaOKJywpFm9qYGtIFbrILH+3xUDD6dThMHeeA9WGd1
 ktnt7Eji1zGSTvLYKyV1+PT4tVVwrP7oPfUeCtwsaLHIbFURevBXyy0gOyZBeyMaHE/cAaEKAwU
 /1msT/A3Hy27mGT+aBh9d1RILKiyGV86MqGR8TY7m1iCAuMD2B+94b7QSPa/FLNzSdZrE9boK6e
 9VNRKmOq/XgyeSg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EC7C140015
X-Rspamd-Server: rspam08
X-Stat-Signature: hjmtcksp9jroz46xes9q9u51got78xgm
X-HE-Tag: 1772719540-619523
X-HE-Meta: U2FsdGVkX18uIW7Gd9CoSGsxXkmNn/KiGB9YoAdC9wWRmF8Qpg7Mvril+UjxH0ZKqEFy3g40/XNODPZWew3+yuiMXYjLJIl2dCH05rYAb0F613hDijR/ZdZ+w+s6iwXMKercMnggEj6RwtTcqsiVwypwENZIltIX6tPh8NGLNNQNW37ARA84rpwY+oGRlESGXssayuV45d0TMJn/TGwJCR44jc5kd9JX13JTTnxB/0IMtCVWAKNNj4BcE1vjrN4TdThGrA+v2wy1E/fYIqn2Kb0zTU6MEELJLW4WHH2daBkl3sJQ8hgPnL9SsIXyK8F9t8c2twsqGSYoQ75Qu9mqEeW3v7OTD7Axt94Yo/5N9GnEavC7IZn5S92uhpvJT106jAi4DW/4kmbVIQ9FOkIwLa/dKuyeO/U4hzhPmbpYqP4+P4q7t/tchDFFSsn5Uz9say+WgzuBg1WVzW3WyLAUnGDshFujnVsrDnuGOslNeguoPdMZ7ObG5ubMLedCzydPDayy6DGgMSziNB8ZX1/4FBoHVNrbRjNY7NqBrgicfPPSIG25G6k9qCB6wA5BAmkw6/JH9ZKUCl7x1e1aUH7d81iY3fxVeadKlkVNmajfZe6TWMC9B/sA5P4GtAhbh81JR68d6pzAqFhDX1j52RSFGfCA4qdAhQzSYbcDLZGjhm+aqGbsMslh9WdjLgt4c0QjQiiR3qlTFy9PqMDhzP0nTHaeI9g8ZTDucM6B1uoBwikgW/DAbt/7lky2l87Sl3yMNXreQMZ0g98R9Amuy5JaSOeZbXzAoyZXYR7hQhKmaYVOGI0yJunESMei2rZt8gFam7O67OPRQuKG8Psg+acl08YBZdIjgDCFuG7XaVUueuFGCYRk2HGQQSjkaCuIn9FxnJKA+pVXoKrD0qMX6VGG4pKLc+nwh77sHfTnPWUDknWqguGyoEU5oSrNzlldbw2SvhywNQfaixf+yCvUIzV
 j0ZXeM03
 48DXk0Vcz/QL3KQzGnm+h7FMgEeSmoRONZBd4ji9wABrsDPj7zO3Mx4VV6rZ9kvdE7EmjtvP1wIDAFCgjyj0J0i2RuYkXEiszhst7JErZq8ZTZV9B6u9rzKCBgTu0/7O3h1SynPJCgxCEY+LHKts9AB9ZaxLga0ep7X+pU6w/ZMzmX9RV/Sq32KCEkXLOwug9issiYQkal1gsInk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor enabled_store() to use a new change_enabled() helper that
reuses the shared enum enabled_mode and enabled_mode_strings[]
introduced in the previous commit.

The helper uses the same loop pattern as change_anon_orders(),
iterating over an array of flag bit positions and using
test_and_set_bit()/test_and_clear_bit() to track whether the state
actually changed. ENABLED_INHERIT is rejected since it is not a
valid mode for the global THP setting.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 51 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 19619213f54d1..dd5011cf36839 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -330,30 +330,51 @@ static const char * const enabled_mode_strings[] = {
 	[ENABLED_NEVER]		= "never",
 };
 
+static bool change_enabled(enum enabled_mode mode)
+{
+	static const unsigned long thp_flags[] = {
+		TRANSPARENT_HUGEPAGE_FLAG,
+		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+	};
+	bool changed = false;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(thp_flags); i++) {
+		if (i == mode)
+			changed |= !test_and_set_bit(thp_flags[i],
+						     &transparent_hugepage_flags);
+		else
+			changed |= test_and_clear_bit(thp_flags[i],
+						      &transparent_hugepage_flags);
+	}
+
+	return changed;
+}
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
 {
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "never")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else
-		ret = -EINVAL;
+	mode = sysfs_match_string(enabled_mode_strings, buf);
+	if (mode < 0 || mode == ENABLED_INHERIT)
+		return -EINVAL;
 
-	if (ret > 0) {
+	if (change_enabled(mode)) {
 		int err = start_stop_khugepaged();
+
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode didn't
+		 * change, as the previous code always called
+		 * start_stop_khugepaged() which does this internally.
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+	return count;
 }
 
 static struct kobj_attribute enabled_attr = __ATTR_RW(enabled);

-- 
2.47.3


