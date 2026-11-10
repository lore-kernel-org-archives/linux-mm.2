Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4999660A261C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=SbW4Icrt
Received: by kanga.kvack.org (Postfix)
	id 9EB146B05BE; Tue, 10 Nov 2026 00:49:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AF46B05BF; Tue, 10 Nov 2026 00:49:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88BBF6B05C0; Tue, 10 Nov 2026 00:49:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 605856B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:49:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3988160885
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:08 +0000 (UTC)
X-FDA: 85418131176.02.2130FC1
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 28F981C0008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SbW4Icrt;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mw+D+bJ+3Noc/aZs++CvNqR5iNHaaWdAu9wnY20WtvY=;
	b=gzXRRCHQd2pL3mNvnnSvpxbMpm/K1ub99zd2+LyY+o+0FiV8Itb2xwKn3miU3U2hhJ80sy
	3VTRq9MR2/G+jh8Wd9t/Ky07gYEyzUVGCOoaa80vESFWCbDLpkKDfC+UPxuDL1+EdL6f9X
	2+WA7aZx8Yzv9q2r39zIRxkC1gXRvnc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289747;
	b=Ml7DYUgdyOB8Y39ZhG4VwDcpPMUbKTO2rKc20GLtInAExq4Prw27fJ9wZBsT8J5pOm6nV+
	46sBFiTmUiYeKgg/W9dRYmDj0rsvNAp6GKg0xHQKY+aup2DhPlTHfqi9tXR/0XrAdf3zQU
	uE3HqomKNvReuQbLClUkdE3/8o0TOcI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SbW4Icrt;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8b8ecfa886bso742350b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289746; x=1794894546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mw+D+bJ+3Noc/aZs++CvNqR5iNHaaWdAu9wnY20WtvY=;
        b=SbW4IcrtMcLZYyHT2jjQFRkW8oeUkBwAX6cAZi3x2YBgQ4aRHC/DQHqmDzznqiIffR
         7YIQnoxGXcr29cVxA12rNW6M9omJ/dnmu6U/owC+6Psy7A7kVMqi1VcOkDvlSLek6ohE
         DW9oILdQqiUgHvBuUomWMdjDTnQXVuHU9SlxY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289746; x=1794894546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mw+D+bJ+3Noc/aZs++CvNqR5iNHaaWdAu9wnY20WtvY=;
        b=fNcvVZZ5v64JTAmFboEf3VD+cmUqgkO/NNX8rsECr1UkAXXeC2fuLagm7almR5//2u
         G5x8eam0eQnhZLiYQQ0UXpcKdFmGf9L+bb2G3A0gddKvN+xAul/nFVHnTtQJC9kEJqBY
         alcVFiklZIw/OdKPsvCtbLXHGbdDtov7sfG1MRQc2Bp9bY9+TIp2B1mAznOTJmSuVeHA
         hN5ibL0IB+2DD5NWaE1+ARM1CamYWy+Ttm/Fo/7L76ESQQzvzHndFPoS4j2Vno5tzQBT
         hYZ5Cj3Ueej0J9KvUKEazJ5uZLYcqKcYRciX08JFlhPUWBImMpxCZSaOh4IURtrcOMW6
         fjNQ==
X-Forwarded-Encrypted: i=1; AL+hErGwXYHACrMVsOaCMIEUaTjIKq8/C3FjjF+qhITJEuq1O3fl8j92Jhcri7V3s8SvCtcbc+umq7GK8Q==@kvack.org
X-Gm-Message-State: APuU4Z/2HX/Q+ZqEJBVOWJxFvyNLvWJuFxqaLQXgVcWce+Vt+AonQh36
	yunC1D6mBbpQSU2zKWLaM4LemutVO44EgNNZYfxozlnsVxtSZXIcXtDAPgPabwLIBw==
X-Gm-Gg: AYBFou1VBSqEnCGAr+4OZgVAClSSLG1Ff6HVdSIu0RmqHI591xyv/Z6WwwadiUGRrZf
	cNncX4Q1NzFCI0iUsWIQXbuwBneZPbJSb7e3HNbgrs3ovfExhveedNLNobWFdgn5b/mq16mbNB/
	ZDKvH0tbgrKSh+M2T0SJUTW/Rt1ylh0Kd5yTsray2T+H/Az9nba1SGacZioaKk0C41MkW9Dbllo
	rR9CImIFd9Ou6nYmH3TqQ5R4NoNSpt0nKOlHwZKbOCD1MkrbMBy58eD8Jgnk07LfRah8Br5sAz8
	KK7QgXoRIinQSjkgoi+NCJMdafu2O/XnfyhmzIxTZIe7em66yOhof+EIiE1dCEYg30WE9j4SuRV
	96dy9a0ara0wMf4kiQIfuU7PUhP9kmEkwYTOVSYm3jJzfDa5f8hjmiesRo/ajjH6dmv3R2z253u
	9qh29zZi1ygPGNRWU/Bl9o7HLgs/BTUYjb+hK1xJdlHGXIMwO+uWARh5MwQR5TyT7fEb6klmmvc
	HDk/FKMwnAsjFmmUwkgd06jbXUTcRBRmoAODC0PVJJY3dn/x81qTB7Of2rSkWujvwgn4++wLCcX
	JGBWQmCKkVO8DegxUwkkB3m7oPZkL6hJrQP187ZqqxNeOD8zfmauG6Y/5ZeuZ9Gu8twsl55cNfX
	2FARIoI7GLGvnjBO1jg==
X-Received: by 2002:a05:6a20:7d9f:b0:3e2:8c65:b229 with SMTP id adf61e73a8af0-3f172725e87mr1467840637.11.1794289746035;
        Mon, 09 Nov 2026 21:49:06 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:49:05 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 07/11] zswap: do not free the entry if its pool is NULL
Date: Tue, 10 Nov 2026 14:48:12 +0900
Message-ID: <20261110054836.1515030-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9mhxwfr63uffz3ar3ng6tqsmegw1xc47
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 28F981C0008
X-HE-Tag: 1794289747-104809
X-HE-Meta: U2FsdGVkX180s3GwSlZTj8qaABYwWmzJ43H+hhkG1ICOQpNzh9j15BFxv8eOf4j4Enj9pEZh9Jty2LHkiqolFZg8tNQtZ0uHzEyYSgmsGs2GHdhUe3XPnf4fgHr+MAPOU2eGl8yaBfEHh8fsaEn+qYM1UH04k5D8xsho2cM/HqC73TY/rYpHqjzq09f3ZVEQLQKQxIZuaDJwsNq5tVG3RSCKxx5HYGLfuCeO0l8uXHfn8o1CYkP8FixrU2JdCiXjE934EHwqXWc5o24F9m+dmG5ye1nx2WlRsjg3LPnWAjD096YgAuRZWCye69o4FfBimk7vTA7FSaQGeEuv2pczrbDhBv79imdJgCiFmINs+ukkzUong0FCjZRjmyFJSv9VkTTkcLha6Mv0+Juay94/8pI8u+QR1Zoo13lb8YX9Wqs6BH5kVnGz+WwI4L/xjeIoKj/292DSAol+vqeqeCZ7LbOSJv59dg0KTvWVUasB22GzJFjc/pzSZDVHSOdy1OjGEQhftV7zXg/4Vx5x9MkX48vG80vnrCX0rpEF3ELSAUEgkF4jwI8p6Y6oyK4MgRkPvr4UfoEUcwYaLdvTkVAtW5YJzXHF1ZRFOnGi+vbFWXad76SwJ20x3Ao1jjlHuatfuRVVPRqiUlURfAYGl89MKGTVLt/KWJBxSyhyxP4mpJKLE5TsanaUpmjgvIZqqFJXNITcrNCLA8WMz1JSu8+XhhcyYjoqljjApRoiy05iDM9HZAjvY5dAZljQLdi5ZGRRuwTsm1mXDoxPwoNCaKnbJCHbn5/1CRn8UKBPrQoeS+3ftV6qPDhB9xpEhD9+NlMI683ilkqPZyceQnkgg7j8bvDZCY3pFSCGsfhhO4O0yPdtNi9C3msS5Cz7J9m5OxIiOM+dYo2Htc6smL1wEDGy9iZdeONXptYUymyuz7N1CFKh0DUhns/g/mFsoEcKB+sIVIJltoEQ7lw0cUKfWf2
 V+W86mpw
 G89/45brW0t4lJZEpXi2+Vq9gYyfNUsUlxG8wr/T/baGc8AIHtRz/U5diaTn2+ipXFM13vCBg6ehxxoO44HG2gaQLmL+9GRxzy+XJDToNRJuBPJEG1QeVp3WIndGog3VmGKW0iSvjlWDiuU/VJlRWLSGL+wJdrv4GQ4eD0pRD6OfJINEn0tQOwuTwaA4SZNuRr+60y676gWRGh/reLNYLInX9b2qFzVwLpKCoycI5kjkqLn071ogb7s5haHu/npgeoMJGKE6XMXIzmLw9/oT23fY/mSPoiCTWMqXW6mhhNqpTaVdWVjj3lki2Y55Ei/RsFnONGjsGP9ThMEDIfFn8IZovPaDjgrp58mBPHvRaDutR7WE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zswap_entry_free() warns if the entry has no pool (which should never
happen), skips zs_free() and then frees the entry.  A subsequent patch
embeds zsmalloc handle into zswap_entry, so zsmalloc object will point
to the entry, and we cannot free the entry while the object is still
there.

Bail out early and leak the entry, its cgroup charge and stats instead.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zswap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 1160bd34e289..dc0400d7e1a3 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -787,10 +787,11 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	struct zswap_pool *pool = zswap_entry_pool(entry);
 
 	zswap_lru_del(entry);
-	if (!WARN_ON_ONCE(!pool)) {
-		zs_free(pool->zs_pool, entry->handle);
-		zswap_pool_put(pool);
-	}
+	if (WARN_ON_ONCE(!pool))
+		return;
+
+	zs_free(pool->zs_pool, entry->handle);
+	zswap_pool_put(pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
-- 
2.56.0.506.g506a7eabc5-goog


