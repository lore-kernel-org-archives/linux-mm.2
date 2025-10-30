Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72191CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E978A28001B; Thu, 30 Oct 2025 12:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E210F280003; Thu, 30 Oct 2025 12:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D380228001B; Thu, 30 Oct 2025 12:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BADFC280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:43:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8499E1298A1
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:48 +0000 (UTC)
X-FDA: 84055352136.13.2651D36
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id A0AC61C000D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h8WBv31B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761842626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3yVuDV1mz1n/tGmCVMXJ1/yI+RC84xz3XcNqwP/C3s=;
	b=l9/bkTV0M88LEe7fblm4i7z9XWZtSqQTAQJcwuIWAeMlZV1bjaenDAjo/gtN6M7nMkNu9U
	4PE0ZqeoFzVkTJW81iP55TMll2CLyFpiWoSTotAyELxzeVMr2UzFl15zflq4jX8DgO1p8/
	kMB6HworGXBkCTGoSsg/bMfBkHayWkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761842626; a=rsa-sha256;
	cv=none;
	b=nmGVMeW28BZ9h6dokUBieBN/ohgxG8c8EaMbUtys84/KEWHoZZEtIqPOiCabH/Gq0lEQCW
	45RwixDtK8PC6v2cc7qAdjSK5YBvvi1cZTkuOVidDxG6vfWMVk6t45v1qGtI3ztmopjcn/
	RZpBKI4hO7fcAZjmRx+NVFVZr8+xFqI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h8WBv31B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-429b7eecf7cso760265f8f.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761842625; x=1762447425; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g3yVuDV1mz1n/tGmCVMXJ1/yI+RC84xz3XcNqwP/C3s=;
        b=h8WBv31BzwMlyukamcPBivsx2+P33Vs3pg8jvANtAXOIHuuDi4J4koXLqbTVhUUqvb
         z187C3ZuVDkiv0R78hoaunpLtMWjE4GLkiUUfgyis40Wp6WO6ylht9SQDZi5lXtPTdK/
         wyJ7RtZbg7dDRev8hfoeMUvzhLHHXVeGKHLy9zxw4xAWaIHe35LeT/o6x6JzEoHdw+vp
         O7Lbgw5gwm1A4FwqVLMTqI4zmBPyh3IY4BQggOMnwXw3PgttOvDm2+M2YYmQhHXovXjQ
         AVxfYr3G0ASBbcTWdA1k2wYvbHyBJMqyH4lOTbKbkE+o0q5cjliuhz4rpba5OJH8PpO4
         Rujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761842625; x=1762447425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g3yVuDV1mz1n/tGmCVMXJ1/yI+RC84xz3XcNqwP/C3s=;
        b=vmpSglk/vpukTV+1vR9R2/XvBNc+S6XuFKKD9QSdDiur+pIIEWB1vosLfo1Eqi9+o9
         jK3g6IesyryfOjKD4aX7Jk31k0NEHv/VRAim/BNSPpTd+2APW+Xh7cG9hkrd6Gq8XcOH
         gwN/s6vREbia7pzWArxNucC7V34Zc84cHgE2wbLzPImvAHSUhZWGD94/WUK/iL5Js/s+
         TBfU2xmcIJ0mpkASeYvn5GnGVDw11fUJIn1HbScd3UaE3eKEhN9Ly8zFQukv4Xnh65L2
         mLVFsk/wDDvM7WrKqMyQh9oqrqbug9z0bFsfe7zRCrTFSkQYku5tqXIlHNDdUviUYpwc
         xJdw==
X-Forwarded-Encrypted: i=1; AJvYcCUUcKYoCCHO/FDRFetLkkmRZ1XLqwc26sPHvzkWv4voxM9FiCjyY1Yrvy/44GzP8gikTJCVna8xUQ==@kvack.org
X-Gm-Message-State: AOJu0Yxg5+ycnYojfTZdkzgWjClte+hRDbhid0MqxSL2IswadBo6WSoQ
	8FkyK2OlCTsHblrAb1+yZQqFXXviNKZ/vbTyUOrz1XU1LSdPlQnsDqM+
X-Gm-Gg: ASbGncs2qoUVJeo02Tx7ft+HRdVSWky7CSBAs3T4vXcLySBAbTkdhw4+59t+sP2AOFL
	DdCnwRgZ4ktSZMoZj6ZPgyv/JLkBEZxLP0zaY/IbQOH+tzgUXCFwwkxLp2VcDUtUNvIta+ZdEQB
	eNxRzzxiihZbU/R9USJHrhANvJlRh7CmT3GVHg6p/MdLRh59ur0vEuDEEEV37wzG6/ChIGes4S/
	5ssAmSCmCJtmIQxVqE+n1bnwWGoWa/C9JfP2uBqMBOBxsNspM1w8fq7x2X5nmqCtBfiM1jANWgM
	MnJviLdGzhJ0VR117s/V1KGFnIegtI9zMPQvGn3ssi9SJNcCSd5HFx/xnZCs3srH7HmaenhIwjF
	WtoySgh0voCRe6jyZTAhruwbuP9LwVbfrXykLgY6nGcKUfoy9Gbpd+d3CQWP9rufNWvGCoGQx9o
	Qf7RSjywbOgGA2EsWGId5IUiDIAe7Kxeq85dKy7zp0Weai9q7+FvL8GjXI7p7NQA==
X-Google-Smtp-Source: AGHT+IHNQ45nUcwfK8RnMTd3oZeMqEiqKprwpjCjoEbKxBa+N5gErTpRDrXNo3YuT0kyNcEXTUfb7w==
X-Received: by 2002:a05:6000:24c7:b0:426:f9d3:2feb with SMTP id ffacd0b85a97d-429bcd849bemr498223f8f.23.1761842625164;
        Thu, 30 Oct 2025 09:43:45 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429952df62dsm36796839f8f.45.2025.10.30.09.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:43:44 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Thu, 30 Oct 2025 09:43:29 -0700
Message-ID: <20251030164330.44995-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251030164330.44995-1-vishal.moola@gmail.com>
References: <20251030164330.44995-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A0AC61C000D
X-Rspamd-Server: rspam02
X-Stat-Signature: 8ephoh54j9atezinrfia7obg313h97mw
X-HE-Tag: 1761842626-759477
X-HE-Meta: U2FsdGVkX18gmMu/MlktWXdNRK8cuO7ZIUUa76UwGE2Fr+K4OcbE3/IDTQJRwQc26ESedeusWrWPntB7TLc4bXgkmgcchhKr2pGf4rcWYqKxtPNlDwgA/JGeep1rFTNvN8YnmThsStogxaeZUWHxU6utICMoOe+LL9gBS/EDDwUGo2RY2mvkmm+iJ77N91Oi3YgR6nyNAeM50p3J4/EPYQKvUXpUnedHM+Jdc0s+VVv3jqs7wO/wGhUuCmcZYnx598df90iv9TT9NcCUlCofvld0ql8ozSUtUE3DLpeCKCfaH5rpl4AmFliHl2pQbkOKXlcpsrhsPGEBi2obMDQMvDOdZ7B6wCCZ15LhplLLiFrvnM/F3D7QEdRqSd/7IwK5CggvFZ8Cs9mo7ol4IoeWBOFRYuO4gW6rBS3vdEepb2sQRR4ROjxYsBnoHlEyUUECLA1DtRnmdP+HqxM0T3/VNuZlKLmnj5uq1qJhBdkkfI22a/pwW2tYxXaQ3roXVbkuO+ZFtWW8kJNAS+H8GWcIC3RxhEak+DthUXjHvlplYTRSHHS/4AVufAc4AT9isNtaHcKGDpOKFhDm7czghW5By8mZ9XS6DUAJj2vGOqnoMkUGXse7f2FXi2VgqVMsAg1yNsZjQqkcXkv5vZA75IkSFA49Ruj9eBVSXEMHXWf40ycuVsJIxJq3jA9dfLLU6ibD+FpuVfe5AIQB6FSBcoXqWvl0r2KwVQgRFojl6EEvns+UHYy1CuF4cEfdcDpbYlLMkP0Ln/h30+BoaYCxQjkeQexGGDMaz/TUZ/5XLWp/z+VIYx0rRmvldtiBkdWtpcficDOUDl+7jSpwRZa19tXU6zYZYSGLAfBDVoOjoB54d/yso6IOflpzz6FiapvOOjnXtbUdbNYInxT/EW4qJmu26ifGhniaPAyjN1zrANPDRX6l1sqYADPnw9P1i47FFzlt8Kj4HBQ6BhQCwm5OKlU
 eso+k8h8
 IxBd/HFBYtfxVvCpDG9tjHa2/5/r+RSe5LewJBHQwoJJNzhMD0D6VQLccKL39ANR1sEnd5bZkg3szinX0XcPhdP2gQcUDqcnJ1QF5FRSozXkZ3aJC237boZy+TBrp8iFq2quudHKjzJZEJo88bSrp8f0clLcNzmqzzFZ4utT/NWs19t4f/IdM9eTxBJ+UYa4AYn7IeW7HfS09coG/KyyTYbfkMA47Zb4Bedu1T9IVkvxUjjxenW0eyMmcxqo9XE5vOEs2HMfaTaFDeso1/PB8fxOkDsQxr0V7LldyaBINwk55MJbfAlh32FCJ/AgghSd08LjwtWjyyhKFibCifRVPkLpHIouFgHI43EOHh1ytN+/d1r3dPAGBfsoPoT0aE5PaupGJV/LLcR+VNcoq4B4FwW4rRvMIkcTqEh/rCIxkGddYEIKMPZfzg7klMKkDkWm/anu6Z7pTfOzj1pJaf6I2uALW9K4zaw9ehZmrqgP44asz07YATQ94nw+gQ4p8O1Qe8pFVL3zTcyzFqrY2CMyFS+APtUQZa/8dPH0I6nEilI3uwTP06qvB257ntyuvMhZJDOy1Yae7KDLRAmJ3XIjYEc6O4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 76c060ef2bf7..8ad0451a7bd7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3634,10 +3634,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
-	gfp_t large_gfp = (gfp &
-		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
-		| __GFP_NOWARN;
 	unsigned int large_order = ilog2(nr_remaining);
+	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
 
 	large_order = min(max_attempt_order, large_order);
 
-- 
2.51.1


