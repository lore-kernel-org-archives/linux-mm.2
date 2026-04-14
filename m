Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF52ED7BBC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A861C6B0088; Tue, 14 Apr 2026 06:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F416B0092; Tue, 14 Apr 2026 06:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6FB6B0093; Tue, 14 Apr 2026 06:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74A6F6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:44:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1642D59036
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:44:03 +0000 (UTC)
X-FDA: 84656826366.12.937D082
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 386E840006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:44:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vq4xJSC5;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776163441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frM77usxFPT3vq9Copj1FbXjZMzdBEqufSu5zj/MX+g=;
	b=gi3nc8qce3nj4OwGIHTg5iZQ7Kar4PEHdNQDyL5IyKQ5m9OmWH/j9VCZ3oE7f5l7G+MmwP
	ePCUG5VxE2+p5zUJuB0RK6cADwYbMe4FZ+08IHJ35swkmtIhX5CAOL789arOYHH/MQHpMj
	qhjx1MkB6g8U2VQLrpktSRhezf0yE4I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vq4xJSC5;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776163441; a=rsa-sha256;
	cv=none;
	b=8Cf5/ouyknIfwF4flzyD7kGW/6RUDb8Y2rXUFIXRXJm5rZ7af6v5MoPVASDrqxe0EZXE50
	iYMHxlJg2ESMkKif7RQGWNMMdf9FgSCEeyBeiii5i83fzVb1TGe0oZW9CrPLhTzAfCbw7b
	dgJOhJ6TKLud5/Gga3JI6Cg5mH+KIt4=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ad2b375e58so3789965ad.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776163440; x=1776768240; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frM77usxFPT3vq9Copj1FbXjZMzdBEqufSu5zj/MX+g=;
        b=Vq4xJSC5ZU56DqRLF2JYcrIc8Rh+5JGJvlyoeWW9Bn+MIPx4f7883f3THg6joig4rZ
         yoWKTYLAcVcei0+yNhcP9jY3BpQHgjZUWe8YqRnaUlLQDrGSiVwQGguLxSQlHqYmXdtj
         Ai9mSLe/0p8lshQnQta6hksfnSZUChfy6UGSTHiX+iak/8cEVWZ+8PG6nv/pptvFl4nH
         yNrSizYTTtAsCF5/iQxFMyMtWNQ51s38/FuKBataC8gAyVx7IyKEOqKhnGSQB1DXIecJ
         IY4Yc4m4lZAWsL5+NMDYBrNx8+06sRwxeH6g9a404ltreOU5X7TGrAhoJGT+pGt0vz+3
         U8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776163440; x=1776768240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=frM77usxFPT3vq9Copj1FbXjZMzdBEqufSu5zj/MX+g=;
        b=l5kJnYwPZuJHqA7MkwPnnGaBW9W/3x7IIAeCwLFkZNFgsS/wy+ntV+VoVJk2YS6jn1
         CwuSCmlpYljVMF2CI9yBlEtdLmFHHnXePkB0yKSBrjpGWLEW+wbFfg8rWFW4pyOv+y8W
         GKA8BxL/aJeOI6FsMQxLXeNNSj4daEq9t195yPCv2N+an/FtTJnNEqiqaF4ITXeu8rtL
         547KwoOcwgUCYKHphJkaZTWPc7wEXM9Cc0A2O7mDcgQElrhz8brgksRCodII2bg4LJaX
         i21b1dWSddDOAdnI48O0DHtgo1djx+nZw1KWRNuK3s/eaVHTU+6yrHcyoZtPPirAO93D
         vzsQ==
X-Forwarded-Encrypted: i=1; AFNElJ9foBp/3BUAG5yoMD/JNjuMF1KAhxhL5LGqmXInP/zExJv8QZYyWwnl9AXK5i79xwK/+/wASRw0Eg==@kvack.org
X-Gm-Message-State: AOJu0YzZtqH70Ckkc00oo4fYIh3hLNYqXCq8XFPZUKVClUk/SQOg6kGC
	+wnrnHxletuJf01d8TsFuO7s+y0iBlIYt4pLJSx5Ut/YymK3h3ljY168
X-Gm-Gg: AeBDieugBZFhxULj9D8HgZbL+c8Kbim1UosSVzDIHu3P+SE7pMHHndtLYevc/cFlLnW
	p0szQ5Aor9IFBwA8+4zOySO3Qft7pw5cSnIcYoh59mF5lYgVnVxE68V+iiYzdjMx0vrJ+dnaMEn
	b7pNsVWfqmmaNAA3cVfDRmFUBpwBsrWnZYk5aK+QGFQTAJxpQWHVS/iGEReVohCo1HY+yH4YU4V
	MqTHgWpM4DNVfyYCrV9UcFofx29DWb3A/TbGgOQpSjIIfiT8bHiuujtc5giJQrTmA8RNJC35NLQ
	hsJEmKU2f3DM+guptllQV3zkauwlCCmAW2y2Wl5IYgeYpGlO1ibT8DIycO8jDh7DQ+XY118u6/x
	0VqJGJk1DhqIKAPcStcPmocB4I17Z/uCYyyli3ashzo7obeodigV8eRo/50QQbHJUuzLLSV6ajl
	NcciIlTgXlLr1/3cN9
X-Received: by 2002:a17:903:2d0:b0:2b0:4c89:7b3b with SMTP id d9443c01a7336-2b2d5a3c1afmr100480015ad.4.1776163440033;
        Tue, 14 Apr 2026 03:44:00 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b463cb01afsm48231925ad.25.2026.04.14.03.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 03:43:59 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Donet Tom <donettom@linux.ibm.com>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v2] mm/memblock: fix off-by-one page leak in reserve_mem_release_by_name()
Date: Tue, 14 Apr 2026 19:43:53 +0900
Message-ID: <20260414104353.989063-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414094439.982853-1-charsyam@gmail.com>
References: <20260414094439.982853-1-charsyam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 386E840006
X-Stat-Signature: in81nyrfocxokwrxnudfdom57nycpx6d
X-Rspamd-Server: rspam06
X-HE-Tag: 1776163441-607544
X-HE-Meta: U2FsdGVkX1+0fJvjam22DwYrvG4Boll9TSH1FwU1Hs3MfGqyn7Dk+vBuYVaqEiwAzml2IHDw1KzTzB/0fBx8ZELGGi8Dxor04pTDsHRkgIn7bVhQzirx+1+gqfSF/3/BEfgTJyZaT2/9PIQwQhEIimVMWWvIVnOLwjSdT3l4O7sFutLaFhuchirVcAn1yJHmX9DyFD+q+RSK1zSDeBCF7kZfxeBVD/MKNc068ItH7v5QGTxbfMhnl+OkX+Q5BSeeKdHh7/Pa2dn2dsrqhRQ1moOl3d0UF+28kst2zsHsgdCg+ovWXOi6+zNobJ92Q2K9Cm/vwDC40Un27ladmNfIbcU/du+fAJi7NykR1PXLzkkvJJ1D9x+tV+ql6+rvePz5wsmOyrJMRIA6upuFQsU8WCr1JuBL6nhF4EQdHdaB5vexY2ESeiE384DTimeByeDFicP8kk82y8r4HghFesy+HjEZYURK7J1oS7HuHW1kz8un8+535OgsJXBUYCQnhqfiJESnwsribDR5hVB0iXVGtfIYjSTBwEFYG1ezvqwxHwSwjZEXTtMW87+umH7cp20TfH4KF0JUfXHzRwTNc/lCpDzIdGdMzftpVTFSlQwIQJV7odTIktMsxmoXoZZTPK+vivYtEz2Kg8MHNvD9O/1bvkIBK95Jhrib0hYYZTIYQoSbJ46/4glO4YIIh3Wd7erLUVuonvu2xd0spdeXB3tTCLZbSMrwHdMT90wVsx2U9ErGXRv/vWCE3UMJwnxugIu2ORwdwvpT+BC5xS0YEkdh5ggOf5POH0OZVBWMmmfFHtoYbV7x9kAB3GRxeuhaSscbwL4m9fIO9z5KHQjiRn7zKMplf/yrZ7YOTpE+4xrJsDjEr5nvzTl7Yfoi/zNR6h1hD9ouNSTLG1Ng0ys3fCxQMwK5CXeAAGc7YCOrvYdgQQGGyDO/LDQ3+O/jhV3hZiNfHr4mFPj7qNPD+GiRVAf
 4SeYxQvM
 dmSuVpOlVkhknEHm50LlynIfbwxoGg6QOV4pPHU8iBlBnWSIvtlOd4VnVam/R4Mg4d9iYO3hGZy+2+QYgYIvU6tr6uc/NfXS+uRocYe8UGOqYpFjq9g/1GIBgOOYXgiOp8BGu61XNK7keJGSWCQp9jfTWhvuL21Sk3edFvUhUsIZ+/D3w+C71tHw9sLsYF6zntI0GmTvzO8Gt16PdJLywHyD+DHwnDDL+A/SnRTEH3JiSxDesXt/4aUuF4mSR/2iV1qviHZ517H9PpHKBzVemJJjfH/6FQeJu0UNSvvUvfGUkFagYT+QIktqzWbDri6KC+D+Ya6a9RbB3wMDlSt9Hmaj2SZhIfZRuUV6t1OxhwXEJNgC7D/5KVEX/Aj3L+81K38KzkyGDEJ6829JBGtM2NvjzLShVN8ewDclE1hWJP7WJ5fZg1gjNuonx8c1iw1+56aTpk1008jBVvC61UEbsVbpSdHkWcqkm+/TSguFw6eHvNo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_reserved_area() treats its 'end' argument as exclusive: it aligns
end down via 'end & PAGE_MASK' and iterates with 'pos < end'.

reserve_mem_release_by_name() instead passes 'start + map->size - 1',
which causes the last page of a page-aligned reservation to never be
freed. For a reservation spanning N pages, only N - 1 pages are
released back to the allocator.

Fix it by passing the exclusive end address, 'start + map->size'.

Fixes: 74e2498ccf7b ("mm/memblock: Add reserved memory release function")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
Changes in v2:
 - Add Fixes: tag and Cc: stable (per Donet Tom's review).
 - v1: https://lore.kernel.org/lkml/

 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..d4a02f1750e9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name)
 		return 0;
 
 	start = phys_to_virt(map->start);
-	end = start + map->size - 1;
+	end = start + map->size;
 	snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
 	free_reserved_area(start, end, 0, buf);
 	map->size = 0;
-- 
2.43.0


