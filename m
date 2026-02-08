Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F598EF06EE
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ABEC6B00A5; Sun,  8 Feb 2026 16:59:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A6F6B00A6; Sun,  8 Feb 2026 16:59:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518856B00A7; Sun,  8 Feb 2026 16:59:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3096B00A5
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C972759CCB
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:16 +0000 (UTC)
X-FDA: 84422655912.02.41A8A44
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED808140008
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jJ85t1pw;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7QY06q/ir2j1hW+S2SjYAeivUq/qdnGKxDWe/px5J+A=;
	b=yhRLnIUoYTK2zbx7xWuf4zmzWolzWnJNXBgRsLELRsbKX3PZhWBLNo90eV2TV+TzcerVaN
	hnHtWt2nvvgomyPM7HIby81TRFGqrhad9wJSegilWsjUxBVPjGUxP/0BpiJeKDwSGUrmnU
	diL4TyhHa/QTuBOOrMuRq3YXwdpxxV4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jJ85t1pw;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587955; a=rsa-sha256;
	cv=none;
	b=zSWEWrD9vhLXlaPWN4Hf9vB93CnWNg9nAVlJpx1AzFQS37B8NEqUE7NLEwNdHgBnIdphon
	HLQh8/v73xR2n/qU85KO/jqU+rd4g9Ua3nujMBFtTELQnVhCGktgbstnKfprWpB7E3zfTp
	jPF8BBq7tCClYFhUVG5Z6AwgzdZwteI=
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-662f5c5507cso2560557eaf.3
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587954; x=1771192754; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7QY06q/ir2j1hW+S2SjYAeivUq/qdnGKxDWe/px5J+A=;
        b=jJ85t1pwrhcKDHB079u71/Hjttgpa2zCwthyfpbVfM1zJ1tJXMIjuRX3Y3ZfCGI91h
         RY4+qjpNdgKMhIuz8b4tEkuDw6pQOlimfJ1UUxZgHuk8dYmMz2t+M4R0n8QDSJTqZ+NM
         wprscnGI5CklIyfSbXEkZ810a9Yhmd45pUckZAjFCZubgKilj/AbIdn6tM7wOTdX5D0O
         QvKvxOvg4iRo5iLlXSFyLvQIr9dqT3VXT03M41V7+TPrAbLWLMNwB/CNFhiaLsHcxolf
         ivu5yBkvirvfktHl+kJBViY1Ki2xuj+8UQ6E1jap5kNDV0gpPvYyxxlMaID3UrdbprWG
         0beQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587954; x=1771192754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7QY06q/ir2j1hW+S2SjYAeivUq/qdnGKxDWe/px5J+A=;
        b=ODRHnN89xYkM7KdZ5ghuNANwOiQyVfuv7QCnB0G8L7SXBcwI5G02sQVOFXdbVZ0Ecp
         VYbekmpUuCnkN+QW9pNXR6gT0PcN1t8qd5gU3R93dbTSaiBZBt7zSfky61Ecchm65wWO
         6R3h4FCrHvUcc6oup7NswMnWPqdJ+JJ3HFK5SuK9t2DSc3VE0wmwbkojPis5KZhvIAhb
         63B/Mlw91VoMQmfQ3y7LzOZ3xztCfybgs+fW3EHhdI061nv7Cd80yDF6ghV9Pe5hFLm+
         u2qulv81Y+RtovZ48ILcAWxmqE3sLjl1DgCrIMg+3ta0AjnPT6qYuZo5ldEd/5g4e5el
         CrbQ==
X-Gm-Message-State: AOJu0YyWRUvrM002+9Z0lUQoSJfJwsk5Du+Azj8bI1SqwIQzhfJCwikW
	8BG1UcQYdpJEXDGY5/kYAmPtIiJARH/LFGiOyDiWGpYjFsVA9jkq0FRJKO3vNSHpzXW9TA==
X-Gm-Gg: AZuq6aIKqtn2ZX3MUm4cqviWXshLg9rW342V6pgIXXJRlz1PLfNkoiw99eJPSZyoF9m
	phuDd2wGxmZbC1536iyXXqjc3lP/nVeN+OFm6jzdm+a+1gCRkEhJON1BJvXcab8XsGvY9gU4a7B
	dQaMuyp7ezQRJWbM0iAWd+bpuhyeKJKRda9I4/25f3XmzGZIhOa9jQf6Tpn2Yibw5tubYoWLQum
	4eJVI5XVW15cdfTF5wJ6G3GV3yKc/gIIaX+UtMrRRAx2QignAqnQPazjSevI/7aYhmiMwEYRKOs
	30EFiS89HNX3HywsC/vWlEdZCRFQ/yYi5e7ByBfbYaRLst+KBogs7a4OS7DVLdlq7TM0F39x6Rh
	JTw53OgLQOlcRu16v3XyoGn1+g3GAtqIEwQB+zcmV0GB1BF7b8HdpqWBV+0FHpFgOPdmykEqXie
	TARitysBqMHRhk/Xv0q0IHtQxg+GjzU7z6BBTO/CnHKEI=
X-Received: by 2002:a05:6820:16a6:b0:659:9a49:8f50 with SMTP id 006d021491bc7-66d32bfa23emr4293572eaf.21.1770587954007;
        Sun, 08 Feb 2026 13:59:14 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66d391ae639sm4737086eaf.7.2026.02.08.13.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:59:12 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 15/20] zswap: do not start zswap shrinker if there is no physical swap slots
Date: Sun,  8 Feb 2026 13:58:28 -0800
Message-ID: <20260208215839.87595-16-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: nqu4apztznr7wf4mnkxptfbfjdqfdkd6
X-Rspam-User: 
X-Rspamd-Queue-Id: ED808140008
X-HE-Tag: 1770587954-938493
X-HE-Meta: U2FsdGVkX1+wZ87UFhcnljNc4fcbnBR8bqDGvf8rTmyz3N7CglkGJPRRcJh5pls9svVIa5lGoi6vrvhHd4ivtm0BVTFFVAcVmA67ukchYKZtp3sCnTa/LGWUn8aJuUbQ8cVqrU/x5yAaxH4+tqxJJDWCK8SsPwr6fQeTtxINcTzIiHI6jsRtfiKWxYmdKwI/k5J82J0PBMDCfxTECfdkqOHO44Fdzk13xNk12aa0YVGMDLHBwmzyaTp4UMwp+K9Ta+3OamIghWxoxcOfBvEw0B5RxFecFxD8oKzJ77aWZymlhJ/RtEQAuEEF+yVTdHVAOLnt2VfigH5QF+AphMU73AM+W+7xDhsEzRmwagaoHIMjvWTrLjIQJvyweavd94v918sVc8MqjakIUhv2YTbDHrzUtYK/PIDSbGucZ263QpOCGT/31V+6NxpGv5Psrd+ur6hOoo2N984Kx71fjFjHUKa3hAcIpHQoYNhxvanKuhPhpyWIsQBmuiu5/hEZ5YU699JUDz7YJDPsObaGJOLlojxSFASIRs3EnkTEnenKm6cZVzkatbhPhI0VGvn1gsDnX1H8UYUte6tIyYPsn/MC2fVbcr6MEO6W9yX3wCubvkS84hv2Nnna4Gfucb/7PEsQvDhrHcpSijsHkPfucjH8I3YP3FCRduX1oL6MXDMlspwVTdSRTZd8u7ATQLVPgvj/8S0YXoinGQ6WX6lUmYhbr1hIiudqIqOUXeWJymtMEA5c4Tpyn0DWBaJFbOPD65cAamYnqbUNsEJn9nplxhJWEooXUdNQs9TWDdElzLdxylX24Xdxl6SpO84x8P1ALJsdA5MnLKSLRMhgM6TWVE9apCZjo8tGDIOBGCG+8IFm4SzBujLxAFWB0krnOEWoHDfWkeqKE0I91aZfalrmk9hX5870pC0DYk1cmZoxNfVYa8azkFHjfJgQf8ONxefk70P2iiQHYMHzUQlH1kxdSnL
 sXVz0fsv
 YIBTg+VvafralhybXfoZ5PUPB2Onbse+UpExqHVXR5bYc+4LRe9rzy1E9PjTTIjqJmTCbW7hCrW4rpooxtQDRqoLfWkhueNVbA1LDyu2jpmzSsIUicFZv0MO2b3w4IE2wwy3PzdbqG45jTbjryOcw36seVGK1if6hDYK8Hc2L5RtR9zTodXnrffYGAiaVDO/wPId1NU6yk/mcI6iMEsX2H9iiqvAj+DLY4MqD6EXZYVz/BMiDTUwZIPdAOSTxsp1gWLtQPvI/d4/EQ2CZShdjRaAAOipe5yWFgA4YjR/YqWB1ZZA1XnvY+FzR5gO6/HKmL7hETR78j4BLrIsI4Ta3ZHEV2GOApFEO/QNTEOpNZZ+XZMWq/t90SZt3/9lQjOurMqLPElWReQI4sBXKWO/5MKCScHmDOGSQnn28E5cai4kiAwXZd3N8dioeEuxiLDYr53n8vLvbfrJJqtXXoeZ5JPh8s5xG0bNjt9UqsiSS7/mzOd6cSnSGc82atWPYK5FO04mYMZEWv1/MTGL77YshMRWl6RrTqinhr7gQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When swap is virtualized, we no longer pre-allocate a slot on swapfile
for each zswap entry. Do not start the zswap shrinker if there is no
physical swap slots available.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index c5e1d252cb463..9d1822753d321 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1211,6 +1211,14 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
+	/*
+	 * When swap is virtualized, we do not have any swap slots on swapfile
+	 * preallocated for zswap objects. If there is no slot available, we
+	 * cannot writeback and should just bail out here.
+	 */
+	if (!get_nr_swap_pages())
+		return 0;
+
 	/*
 	 * The shrinker resumes swap writeback, which will enter block
 	 * and may enter fs. XXX: Harmonize with vmscan.c __GFP_FS
-- 
2.47.3


