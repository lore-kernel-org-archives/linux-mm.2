Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3EEFCEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552FE8E0030; Mon, 17 Nov 2025 12:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5021C8E0002; Mon, 17 Nov 2025 12:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3808E0030; Mon, 17 Nov 2025 12:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 134F48E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:37:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D138B578C5
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:37 +0000 (UTC)
X-FDA: 84120806154.08.493FC4E
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id E346A1C0016
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZD9PtbTm;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12BdLtJLTrdqnKL3Gi8pF5N6lQu3vbDUSG772a4HvjU=;
	b=JzbxdNztz1Z64tL2XY1+bTfBUo0U5o49i9QkdtnVb7t3twfS0jOosPXR75gxv0Ft3/0Xkp
	tFmddzG9LO0jccWYe3K+zUnngNpCIaOQ+uwpzCNInxonbxbi5PUMpSlfwsKBx3gkk4PTWn
	tS4dEzWshyvC+xOmo/p0MvDDmTr4Hto=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZD9PtbTm;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401055; a=rsa-sha256;
	cv=none;
	b=F6C7U8RQo+NGxLZ/rEadcH9jO81Vd9SHB8BS+1Zux5y6TxckQldZsAw84+5Z9bLUhYGiiA
	HN6ym58ZJ+Iyaws0/Dvky/vic8QHrALQvH+Rk6AqYBkQncQiIMDgXMbWJd2xgOiCuMti3U
	GFOuSkbCB9cr5xagD991E6uEiCNITP0=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so3549284b3a.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763401055; x=1764005855; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12BdLtJLTrdqnKL3Gi8pF5N6lQu3vbDUSG772a4HvjU=;
        b=ZD9PtbTmfg4Hie2gzZJMXB8Y4+hmuDmsQsOgAVqzLzlMKNdhwUmiBO5JmnoK7P9066
         dvpmH0bVuulvYpw06vhPTxvujEd5gP1eLGJ6ZIbOAN+BbW5FnJ3KyzijLmR8IvCNwwKZ
         YR7IjkaF82diQ5phNGoYgV4pReTtGexelC6vs9BxIHx/UdqK87LbraaC0zmQROKAZLV3
         6vNr45sIam4jWBHL5etpV2CCdLK3KAuHT8iwn7vVO4GwkMJGXWqXqpBwo/JB8hk22OoZ
         cnw78QiMdDT5xb1fNwiRnz36UJx0CW1sZ2i2gg5UbrfaE7oy9Ug6714aKLPgV/dNSPTi
         xVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763401055; x=1764005855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=12BdLtJLTrdqnKL3Gi8pF5N6lQu3vbDUSG772a4HvjU=;
        b=dTJW/DTBivGfEY1Nwtq6Cv0JKt8xLrUh7hHNSty4zabADbju2s94gM1ElciNQtp8nh
         P5FYAWlTYqj8AhJ05Tg0NodYr5vFovBFcBvJCDtsKWyDpprDgXXOS4NACZJ3XWf8AHHn
         PZGcpOs7BfSTftH4ExMKzA7Yc5ROfvdFDPq6jWGMlKggDIRueUOmfP4AZ+DqRD+yDi5e
         5J2WHlm5W8BBnPniBuJGuEwrOw44vqNtcpiCQ8tpUXA2oBW3bha+qikh2qfG1+U9WRNd
         rRBkfdVSW9rqongUaEWxaG7WMtj/dVSHhenYnPCAUrDoKydGTYZbUsiXbpslnTDVL7Z8
         SjcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsZ0yB68nhjk/OR5T+hyXk7itm9aO8/52iWAOAziWihzz+8aDRrjaKwHjzfI33qTnulmR0+h6VGQ==@kvack.org
X-Gm-Message-State: AOJu0YxJdV2aFsiWy1SRCNqVR49p8E14W3pdoQnb/DBWIqgyu+aLZ6X+
	cLFP0AR6y4p0AWzjkL5EinMkFQ8BBEnKPkrbXMrcbqiW6hOQ+tDokDLO
X-Gm-Gg: ASbGncukxmjmfhTRkauInFuvdlWlE0hmbzy0C35bCrpS29afGs750r8iIuksl6KIdjd
	Vw5fXragz4vwCclaHgF2HOlbdV/uhUJCGoOCf6x1BrjxiWVvggG94zKe6TjwYK9yEJvrBKojwjD
	phE7AHGyO6GnkB3eY50lL7ZequIotLlWJ8KWgcir7CyS0nZrHpjRc4QN192oyK79WBeYEOpaJ5p
	UFtK9w5LcKKUn03oly7PnqsyFR2Elfi3uMtp3c0TqpdC9ZRvHqilX44MEFXg/WfOHG+tAI6hLtl
	xxnECedh3sC9ncfFmvx6oUfi3VKlFD13fJhbmbM90wU18R/WwU8AwEWaaZgSIkD3vWz+UosLeFs
	eUQD1z7mrenPnTUV+BSTp6PWfK/t2IJnidQMF9JFY7vYz4TxDRMrMb/1nPbx7bhlB4R/gMns8Ha
	3xdkncEjvmOVfDdCy9XDUCo0UcHBY85jo//WGMT9hxCr9sPs4FfsODQw==
X-Google-Smtp-Source: AGHT+IERmnZJtAvVp6CfmHrtZRut00Fpcg8ERzAMpZpi3llOcyyTNaSlwGTA3HsU91J4Nl3wu2zbpQ==
X-Received: by 2002:a05:7022:7a6:b0:119:e56b:98b3 with SMTP id a92af1059eb24-11b411ffe86mr5432668c88.26.1763401054591;
        Mon, 17 Nov 2025 09:37:34 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11bf23d6967sm17190077c88.3.2025.11.17.09.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 09:37:33 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Mon, 17 Nov 2025 09:35:29 -0800
Message-ID: <20251117173530.43293-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251117173530.43293-1-vishal.moola@gmail.com>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E346A1C0016
X-Stat-Signature: 4s1a7yx75tfd969crr4rg6qke5wkj5mh
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763401055-902789
X-HE-Meta: U2FsdGVkX1+Mao+FlLbj8kYNvLdcRe8PBGkRgtaehWJvHVnGpgnVSutLYZPG0Boz+n3XB5zzgT1xqySiloNauSjqO+04F2Cq86xvXLag8igIgUf77GcPMs9rF3xAzdhXKTEN9JIzKv4QY+4IY/chtvVFRNI4q0MUHqtWToA2480K8ltZYxBvuXIzh74TtO53l4aumDTxgGmXg50OuGK4lH94ojWMcm8khWCShcxi8GGkd7pS79biWDWAWFI5LfIEf0nV9HRU/rENwJja5odIbl7NOwwapTI1JWnvtogdFIpi6MApgD9n39hNYHSKEFV9CUOGMD0c8c+V33s9/pu7uFMp+j+FGSOjyQOxwV8IK75/KduevlFCjcBNykz/WskNNNUqQv+fhPl50T+R4moZUEEMDltATcPLyWK/y+fmVJp0uO7j5CU3qL6LpkhAQLtVEVO8jbx6svF9/IUccxMC3risfyj3eam3cWEFZQnyBkfUOeX564UZCe++I2Q3oCboN/D78WROpYlo3L2qlXhZEAWcJi+BtPzi9eSnZTpLOR1SRMcm+UUNjVWqSlxjEGG2Ob1vCddB6CqLvQEQVl4fIkd+vkg+2bXrKEYitso438jd1DVZ/n729jB+bLX9p/Aa1wDboipgikoVR1XwcVpQfmx8JTeByJ3QQ06RnAlNT1yU/gvMmokoyBAulmZ4Gg3Z9PrM093CYWACxtiktmHzE50mmDuhVyvoNlzNjoxmfsIKLbs4/ZxRagcdzPUT+lnM1GR6Z+OR8uX+Udlh/h2sJgk1unueihFYIakp0+YSdYnVbBvkokoL5Oon/jd+4Ldq7n90wmFvST5crGpOvx4wrL9aYOqfy9wPIyfed0Y02KmIiYwtgzZXnIO/Yip48q3yQGDvQyn3B5SIwSWaGsQxk4hAV33mmD0QGagK37BpLJXdpWD0NqYWJRQb9ImqJC+i2e3sXidsSSpmTZt7ko5
 pSxWNPny
 9npYtu4GMR/jqLR7xN7BxRryEmH2vCNOOYywguUe9VzhVreehQkfnTTUNtwV5FE6QjjytFWYK1i96ELjP8Ns8XXp92ciLzTW7IW6ILyGf0Q9uTGYbt8IK8Qe0z2hbmoN/byp0hH0Jy5UpeZalTjYjucjtKo5Xk0gdLybkmPogNy3larRRGRlJEmACm9r9xyzTOtM/9ylrhCti5U2dD6BO+4UJjN/NcGX/d4IsRLZrQyldyCk1yKjpa6h37YiMoJK9TS8oaWMbfVd+CwBYTBF+6T+wb6qxsYkto+CZ63IHGs28nrSQJWFicJZBjTNmscR1tLmaUIInauWJN9cqT7sSpp1FRlX88nwYl11MeHwxykcYFhHxkqRIn/1fPxQ4XsGBPnwV+mhLBkmFrDhSzm+vhvdmS6oGO6KmXcAnsMacMs5Pp7JDwytpMl0Gm86pFsTw8EzeHJzef0qpFkkmXNvbE2Sd5n9ehEsDAJxj1eLvJgZg937FOClqjdANPuUtR8wrcYGQf1krruGYRFb9oBNBq3+lqPqd3LOH+GGOxdTpU9bElVY6N9QfIAtuq9SCesvOfu9jkCGLnePBnsT/2ccZGebVEw==
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
index 0929f4f53ffe..d343db806170 100644
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


