Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F6BC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086B46B0093; Fri, 18 Sep 2026 12:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FF96B0095; Fri, 18 Sep 2026 12:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB80C6B0096; Fri, 18 Sep 2026 12:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA65E6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:56:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FE31120744
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:21 +0000 (UTC)
X-FDA: 85227486162.03.9F6CC5F
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id 43DAFC0008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LcoooWNU;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789750579;
	b=7xyPnErdGG0Mpo6dvVRsEJxLNJfxPzNldNHUTmtmjwdqpE/9DJLtvgCik8PA6eoZ/3thfM
	vK787Qyeke3OSbfosedaFUBm/ntJtt5jmRglxJrsg2/xlVW/JycPi6UCeAKRssdYtHHC9W
	2o3Z7zNqsqdGAVUiDeUZ7LHuxSnDcec=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LcoooWNU;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789750579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neVDt5BLYMfRKzGN8kfWno0gbQY9XV/RBxErvToTgFI=;
	b=rWYt0Y6hihCuN/RU2FVn8GlH/SItB5n0qh5DH9WVuD5RO0LK9UFQ+O4Lx8QFDhEO8FEtTO
	oaoCog6tB7Bh23s5Srg/a3up16oPjoRSAbrtfSDeaw7SdwunML0o4GYxyU/27HmEAac7JG
	ogj7z4WezmBFni6QvoGHeoIHxWbgmqs=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2dd77300825so10350415ad.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789750578; x=1790355378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=neVDt5BLYMfRKzGN8kfWno0gbQY9XV/RBxErvToTgFI=;
        b=LcoooWNUebE5IO8ZG4poldR00NbJ2+Te7I36IKJA2bjs0oRLiCH+lC+pAD/ND6jvDM
         4As0gywamq1CWGKvkki7PIBHrKl4ZV8ewoyWwCwm2dZE2xpX0a/Dd/d8ss1mx2Gadiob
         6AWyYoi24/JXt9mc3EO+QIwGQPmi2qfli4jCzu2i385O2TaaJWBs/S16P1v8ta8z86LR
         8dA6/S1oTT4RSsbOrx1GGeD5eXnrcpvsU6uznrW+txt7QsUUHL4ow2VOg8uumeul6CI7
         vXjmpvqsKnGMPBiDXi3JOVZeZlNCN9oAeV4v92QRWNoojdbN2Piv3xCUzqhbzsHK8a3T
         Oacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789750578; x=1790355378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=neVDt5BLYMfRKzGN8kfWno0gbQY9XV/RBxErvToTgFI=;
        b=WvErWW+/N79KbcMve3yl/2DrT+m+2NwccXI1PTnWMyJ+61AzOtwo3yd/mIx9LxlBr9
         UFNl+Yufm4PyyqWHCA7EDD+M+vku+Um1isU07bQ9Tf2lJi85+nM4tA3dVGUaRID7/eyU
         dCuWnlRJdJM9OZopcinA1cMtRnfe7AMgrimc3Tv3uCKIdG7J8zLVoi4iHmIM3byTXdEW
         v00Jy9hvtWfQF4TTMBYbue5C3oM/HmNDKlKzP6guY91dywp37A/cRZ5XLchIDUqjN+Xu
         iZHFxFCWiP9igJpIJQGeERL5fkKSUgB1LsdBfwO3ZeBRx2pMzizksaHR9QoerM5rXbm0
         eo9g==
X-Forwarded-Encrypted: i=1; AKwUvBw7mBLQNsMgrtPZdaRAf/gpFafIJoOOl9Z4SEi7tgd/iTlpB2fBTvtdgWmr/w0adDGTo9kigpjW6g==@kvack.org
X-Gm-Message-State: AFuF++m53OAXG6wplUycOXmlgoTno1QPsl40segTqn7jJziw9UU4v7NF
	PKvLtzwi8FWwvVQwbBNpR2IZMrQvZ9lm/2iIGFiuJo10dzSxVV66ZJZJ
X-Gm-Gg: AYBFou1kAaTqEYL/67Rg1XH0ccjAhSHdXcp9qSWX9QDw+hVN+V5KGes5iU8bkHUNNiB
	aNq1gbJRHpItFPP9+MIvUAvUjANpR0DHiolHdJqQAF06oHmKoOqRM+7q3lCf+y1wUXTs2ylbuMc
	DUkkAVPmYttntmn6ohRLjAY+ZX5g7W5bPUXI80+R/Y74aE2wCvd5BnkrHwg4dkkpzWvvZWgEQeN
	moPF2ci0yDuYik1a5P1gccDLm4D3NDGs0cBtgtJ1zmYCwVvHARYNCZN7wiow6WPrlNFHVtCYtQ0
	KpY7t2KS86D+gx8G6O1MCs+J0Uq8v2FvsCKPbCtqD2dAOul4KtYEqsfK/1uyiu5CZ2Gn2mS/qgV
	l9bjZqm4ZgfsoBkurV/bX7VYs99W+CtxaHdtTbEpkn6Q7ZtAZljOpvC26sniv1t+imks8DhpbQN
	kiOWSPN51uM9meDI9nvxlZm4vMH7Qy5NR7gdlfJVDFz6t3zDUxWZ1v2vEHSOqj1h+r
X-Received: by 2002:a17:902:e951:b0:2db:7269:38ef with SMTP id d9443c01a7336-2ddb1b77ac2mr79752805ad.14.1789750577966;
        Fri, 18 Sep 2026 09:56:17 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75bfe10sm11409685ad.64.2026.09.18.09.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:56:17 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 1/2] memcg: remove unused page_memcg_check()
Date: Sat, 19 Sep 2026 01:55:57 +0900
Message-ID: <20260918165601.1014666-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918165601.1014666-1-ekffu200098@gmail.com>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 43DAFC0008
X-Stat-Signature: gr7cx3ejira1ky66c1ji3qm1xibxkkzh
X-HE-Tag: 1789750579-365952
X-HE-Meta: U2FsdGVkX19uFIHOwxxpWLQfCfctRZ8Up5eCcIeRuCIrIXnXG3ENY4jDo3yq2iDhMzEIzqCIUKeoDPgTBaN0MA1d/YVFADblip/bYbyyWblY6AZzvsAPwFMQA60AQ1OzIOVhGhckP7m1m77sQcRGRRgu93G2jLgX0qLSiZgJJcISZ3cOA+zMPI3IHcRGN3DjiqCyI0Dv1Y+6XldNu47sGblmUjfExs5DZVenSoCWmK2eRAvP3nx1rlzi0LUX4SljagIK3YQ9vuulpzUhbclvksTs9VweSwVxD6aUBltbyjzk8Xz5ehDZ2EoH0sS0yYiwfO0bw9hhAVi+fz38Zu1li+q8hwC9Hk6yVxkU8NjSYkX6hRMiIfrEFU6ZSZ/270y+eJoK4S9enBHP8esa3OMiZGiVeJeS/Cvrz+7OPwuNQgL2/sOlx0HXTZz/J+YEkPrtbXBCIg9/LlsFTUeBANyS/T84PxEwxv7EEYuqDslNdzsmopv7RAu4J17jXAiPLeoaZeXcXFQzUm6iKr1GsPvB9ec6Nr6yg9yBz1PkSgH2I0Xudwvti4/JOV2NnWJ9EDDKzitRSzKSVUwmM0Y6XxjnLToqeRUAr4CeMBax+hBMAWnGZ51Rucp/v4XtiPqvaI9P4g2OfQDVhoDc0HBVGqI0O6KyyZJ4VWgEJsSCIB7w5bMJSTIG+HxsSMdTa/8tY+5qe7iM2FMv6jg5eBcGzFVQ91WHec5w9Dgf/4+Oj9A/Qx2IwJMi98GW1Cn3btiLqekuN+jt5Igy1gDKjo8fODlQ4vG19vILb/jwYN7D/3yJw6B6le7ngun7jxhgxP9Msw9ASQhicUVEpFotH/q74Z3AKvOMgt9Z9tcLarVfljPG5QINVjw+huyB3CDb9x/IkLmKryDQVbw1sp5XNIAf7ebOzdfS+i3mK5pHNGMFcTcD8aGniq+3KvSNhpFOQd5WNjKLS6M6y0AzcR3LqqRvte0
 9wTSlY0i
 MwKKjuoxiG2uUd4Gka+0Dox4vR/heobb+SL72O1MPsYAFSNR5wWFrWreQPHNtkOjPEO4y06Tj0oTuojP4jkbKIse+xZKdtMiMplALO25FSmtU7EITwrzJ5oZ2sog9RB8evuvjKyQiUulRD5xLlgX0a1HVhOQqKCAAzDl3nUuM4BtrV0iyTSz1HLoqO1sKMvVGD62d1e+apI0KeevYv1ZtI7olYw/4SN6v0P68ej6h/gk0I0us3nMPJTnvGLG5hJ84NikiCCf3pvHlk4QvG3C1pXImiu/QHWkH1tvrqjgVMahgm4VyzLF3FdkZHkOq6Szsz35vnIAaSAE+aVuQRiNHTg5i4T3Jy9v5gHFlgG2pfawZ3BNSYFNAJzQesiKDDwQJFQnwMO0C+OsrR9aODUNussXzxwes+WiTwBPM60QbFvKTSfER9w9zC+uf1kR9xIr+T3ZE5XRnRR9FgWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 90f095b816e2 ("mm/page_owner: use memcg_data snapshot to
avoid TOCTOU in print_page_owner_memcg()"), page_memcg_check() has no
callers.

So remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/memcontrol.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 64c183be8cbf..b57a74617b0b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -498,13 +498,6 @@ static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	if (PageTail(page))
-		return NULL;
-	return folio_memcg_check((const struct folio *)page);
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
@@ -1100,11 +1093,6 @@ static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	return NULL;
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
-- 
2.43.0


