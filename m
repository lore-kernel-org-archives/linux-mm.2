Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F71C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 02:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3F96B007B; Fri, 24 Jul 2026 22:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DC56B0088; Fri, 24 Jul 2026 22:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047EF6B008A; Fri, 24 Jul 2026 22:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC6046B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:49:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 431C31A012B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 02:49:58 +0000 (UTC)
X-FDA: 85025769276.16.BC7F196
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 68F2C20009
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 02:49:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C1Pub5PW;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784947796;
	b=rJ7BdHszwrDCcJXJ72mSSGOU2MbMRMOKcGqIJvlsePhOm5s9IAg7Og6uAWEh+nFyZUS9xl
	MxWQd6GKpOUzL3QF1GP97NBzk4cDW9qIAmrxnnJ5zaurN3xRxMDprvYD2m0jRVcV28cRI6
	BYSpUMgIprtB7RfNo82djAlB15CS2bc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C1Pub5PW;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784947796;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsKKexgC0epvBRSVKWwxi0Mvi0wE7H4ciHAWx7tMFGA=;
	b=QBJr3u6KQY7h5uBOzBvKjtxAsoNIy0y3j97wP/FUM0ZQO1dklMP3uvPtLeMx5yf2b04NfX
	+FOnxB+xP3IMBevmXZN4bZHtASCIrstjGTM6aN6SsXQ48aplCymHtRWfESzt9yC9EXwYZG
	7Km2NqB3E4z+0H4f4DMVigqVvtAP2eI=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c12614b81c9so173835966b.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784947795; x=1785552595; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SsKKexgC0epvBRSVKWwxi0Mvi0wE7H4ciHAWx7tMFGA=;
        b=C1Pub5PWLdrXhb9yV8DzigefYUkutreq8g1dn+GjGLIQu7i/vbl3w9AEppxYaxUCUo
         Vgh0ZhlL1RedPrd+EfxscKYeMQA2H9CXjcYFifX24U+1ZN4T1gIIagzbvO9E344GfnoW
         5tWJKrvcFc13DHNij8TpfJ+kWi4fGZnj2B6pGMoNp45mrlNnvvUQ98+Kh74B1V2nE3bI
         zeoGa7fCn0d8TN/vLXUHf6LtTXpML8pW3yJ1mqGJgCgOpMbaubNJlLse5Qu5WB/oW5R8
         x+8Ld6W7RE4sIKvedyde2UzH2dzvXH25T0OIhcFPg3XTNi17/xC3L/lZ3n2vVP8FqSSz
         x/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784947795; x=1785552595;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SsKKexgC0epvBRSVKWwxi0Mvi0wE7H4ciHAWx7tMFGA=;
        b=hl/m6+1E+P5998wf9xJGx+vBatN81NczrY0+5bIvJpgGvjg9oAYpWrjvIzI+27mVBC
         LehIsZMbHJFYtkRqpotw1yBqtbSY9aSf4ufy1tWHBNZaaMJLoGo3RvP5h7qjsD5sP5EM
         1QmwFoTEjacNjBF8JNCKO+Uq6HfB403HD42dojINRf7F7/GOfv4yUhw26sp73hUwAKed
         /0eAHiMuahJ7aOxveYV0/FduwX50VROHVMIEIWgV1fMYAq93rtH/8lkr896JPeiDP79+
         GjBM09po7yGeUS+O4t7oKY0yWoIFy6/g9/hai5BrAgkfr63yLWsXoLS5AZBuIiaMjAQ1
         zGUg==
X-Forwarded-Encrypted: i=1; AHgh+Rocb4jQrYd+wvGiPFCnGTp6pUrZ+1YqRHVjggDq7JzB5NBCEvcOkSic8focGZ4/PEeBAnbfQzOpTg==@kvack.org
X-Gm-Message-State: AOJu0YwjvHm7106Qpxvm4jloq+E9yxm/+FYd4Xm7/Ipj5QV+rHwbSQjP
	t1qcPgO8Y4e266El2W5QdaGb2QytEagRtznfKFT8VLEBDfCu7ioujfbd
X-Gm-Gg: AR+sD13mugVEu50J19SkSbBYvpPBJtu9uiZF1oeV4YOh9viv3BbLrc9j/UyIDmywDgt
	P9Z2ApDViyJMZ8Y8znV8iKefaDR3U61P0dCFuULNlXrpkGEf/C/izmMSAJ7i0WLk9z3HkNV4UEW
	Ksgp0yP4MJ/VFK5nVrrIvhrqjIDhDtCB+8fBwAosKD7u7Ls6RxdIaE49dlDOUjXEgfwlOteS4CY
	zJNpU6KovY/23oNtBEZ8vbKvhoqY3aAgQnVREp1WNClXf5gB3/dcDLH93+cOJh5gZAHbt62NvvG
	HTTWjAmnr66ZMXMAkpKzKqz+O6tHfEEXFr8DuMwS5sgfeFyp5hN2GSeMJzSQF0TX9CN00BOUXDJ
	uOABaKjAYdu43eMevHsUgftNKVNNXAVsGZlYQrbURNfawH0cxepQmbcITwoWORX//eQmIPOhi59
	hPFXKjUN1d2K4=
X-Received: by 2002:a17:906:6a20:b0:c16:1227:e3d8 with SMTP id a640c23a62f3a-c1f1ea8f9bdmr34720166b.13.1784947794614;
        Fri, 24 Jul 2026 19:49:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32c8f7a2sm416650666b.37.2026.07.24.19.49.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Jul 2026 19:49:53 -0700 (PDT)
Date: Sat, 25 Jul 2026 02:49:52 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>, Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
 subsection boundary checks
Message-ID: <20260725024952.65lfm2s676obpoue@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-3-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723084946.189392-3-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: gs5d8bsk95jk5izimo5yanhgccwr1xpq
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 68F2C20009
X-Rspam-User: 
X-HE-Tag: 1784947796-205736
X-HE-Meta: U2FsdGVkX19q5YwjSOjIwImJjoSFh7Xw4bESejSqW6DLDTqD2yiRgqid3pSTcSEDpoJwSzTzdKxgQAN/aBttfs6Io1z8RzqSyLptagdAzGem0+/MIH8mR1opDFWusz++R4MQWqui1rWSiBLQrAEOu78FNXsNf8gwUGNNLaeVTqXgs/clwlF2/ekgdVz7X4gBZ+2x4O7/A4yT0d5Hvl6V1ouot7d38nOXXvm4bnS7q7VhT8v5gn3vWWLSVXSUWs3uGgqH/yy2YuHdlNxAnHzzBSvwCnsSeWywoAvGBcnr3x/WWenj0GQhrS+HB3IfBM++GIwqsRkPrKb9MiY4JOUzXdPcvnIb2yLt1VLCzVTmcIg1voi0q5yY//JyKfPoWW8ha6IkrGGtpZK4aoqE+2A6aIDxiMKHDG6OyT9v3LrS/bedeKLEh+ZU/SRzucwtfIrvVUBX4VES6g6plFU+rjI6g7iNTUlZGmCMdrcAiV4GPOMMLcr5aX7JxqS6B8hRucDIpYVhs+KrikgcKWSKsqIrto7t62TO6qZOUo1gYkRtzzRpDQK1ytwnqM+T8ZuZ7G36/TCOIZMxOXrBpg7hZbpyfohqq9y6V+H4ze/G7X4freFDlaiC1SnhY8sB686NdupSc3unY2P99KNyB5bkZlr1nUGRx/n8uhtvcrzxCjFE/LUqby2OdQSauiMzteGcRfifh0fDhWctfYsSYTpaVcjJucLKK3PixNTmTILPlp26badVVfvN+gUO7VI4d6lKc9J+pW3Bz1ac5SgAEY1jB5MD29huqjcU8tEca3AJJBQfkJFI1KzhbAqpZWKD1vHeh9rmfBfkdiGag1ctuDG3sl7r/GXmUT88dABZmnnQwItsjSOGJ8OR0pkgxmiRygW1V86yzmWiGlYXADPBrVTJTbUwjNs/NeS9XGCxobC0zDJ1PEZS35Lv2eZwmYlRfL5aM7YMIAnm4xyJyEF023AMifO
 2J2xjdL+
 vV3fCPI/h2odScCc9U9pPZ4phS/3heQwG+hdKag86pPPHFFTK0cznT9yJaJTtQyctCT8sHCcOzbYUBbFR40/RXijcl6X8GEVXsac2FdOPQ55+nop9/c2oafIvfrppVytjr9ZBG5HqryTNbKPDolcsxiGp3hwye2EEJorwFOeyFNkpfDbFEfMmuBgQRrz7MFvFYMIWepB7UcR3gMAnobs9LgjY5s0DUFV9APPadYGKQrUnCfY/xEcDPxb2a0gHkeg3ymZnbZitE1F84GGRjExdvfuXJLqmhiCOTT+c1+Q9WeKesJOu/fslFEV33dp4BmbV8khHBH7JRHX3fc9x0IzG+q0OGMo3TePvSc1Ito+5QaaZM/dQ/QgFZydg5+rm8j5ST1RlMqBUEBGo5gnPAe5OuYW6RhCZVwzQ16/aUXeLZt27rZ2IGmcmjWZN56T9/jMpjtpFtqkUxwBK3/v7udoALpENK24SKBQ2lt6hLzZj1DGrOl65hX0ywLJSzXJdSMsiuyRb3Xr1LfG0blkq58JHqEhdgktVYvHMWV2A2ookvFBav9X3F1WgTj55Kjya2Pc4jY3x8vgsmd24+n0ffK6xA/L9btLzvml9GXr1pTEwzI9XEtsld0wV+hRsICSPQdLjtQcvjkMa/tOaXIV6BARIHrrGAa8wSez6gijqxPYCiWzPy6wIU3vhyijXYXd4t3HP2iBcsM4DUcJ1wfPzUrRUMsvjiLf/xU7da7513FU30sdWQ/8PbJqdFDiO4k4+EyVo+u4SedIFX2eDaGlBmpPGk6KrWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 04:49:46AM -0400, Yuan Liu wrote:
>When shrinking a zone span after removing a PFN range,
>find_smallest_section_pfn() and find_biggest_section_pfn()
>only checked one edge PFN in each subsection for nid/zone matching.
>
>If a memory or hole boundary falls in the middle of a subsection,
>that edge PFN may belong to a different nid/zone, causing the helpers
>to miss a valid PFN within that subsection.
>
>Fix this by checking both subsection edge PFNs for nid/zone matching.
>Keep a single pfn_to_online_page() check per subsection, since online
>state is the same for all PFNs in a subsection.
>
>Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>---
> mm/memory_hotplug.c | 42 +++++++++++++++++++++++++++---------------
> 1 file changed, 27 insertions(+), 15 deletions(-)
>
>diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>index 4c699fd9c479..3a281d595207 100644
>--- a/mm/memory_hotplug.c
>+++ b/mm/memory_hotplug.c
>@@ -427,17 +427,24 @@ static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
> 				     unsigned long start_pfn,
> 				     unsigned long end_pfn)
> {
>-	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>-		if (unlikely(!pfn_to_online_page(start_pfn)))
>-			continue;
>+	unsigned long next_pfn;
> 
>-		if (unlikely(pfn_to_nid(start_pfn) != nid))
>-			continue;
>+	for (; start_pfn < end_pfn; start_pfn = next_pfn) {
>+		unsigned long tail_pfn;
> 
>-		if (zone != page_zone(pfn_to_page(start_pfn)))
>+		next_pfn = start_pfn + PAGES_PER_SUBSECTION;
>+		tail_pfn = next_pfn - 1;
>+
>+		if (unlikely(!pfn_to_online_page(start_pfn)))
> 			continue;
> 
>-		return start_pfn;
>+		if (likely(pfn_to_nid(start_pfn) == nid) &&
>+		    zone == page_zone(pfn_to_page(start_pfn)))
>+			return start_pfn;
>+
>+		if (likely(pfn_to_nid(tail_pfn) == nid) &&
>+		    zone == page_zone(pfn_to_page(tail_pfn)))
>+			return start_pfn;

Here we are checking range [start_pfn, tail_pfn]. When we come here, it means
start_pfn's nid or zone doesn't match our expectation. But if tail_pfn does,
why it still return start_pfn?

> 	}
> 
> 	return 0;
>@@ -448,21 +455,26 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
> 				    unsigned long start_pfn,
> 				    unsigned long end_pfn)
> {
>-	unsigned long pfn;
>+	unsigned long pfn, prev_pfn;
> 
> 	/* pfn is the end pfn of a memory section. */
> 	pfn = end_pfn - 1;
>-	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
>-		if (unlikely(!pfn_to_online_page(pfn)))
>-			continue;
>+	for (; pfn >= start_pfn; pfn = prev_pfn) {
>+		unsigned long head_pfn;
> 
>-		if (unlikely(pfn_to_nid(pfn) != nid))
>-			continue;
>+		prev_pfn = pfn - PAGES_PER_SUBSECTION;
>+		head_pfn = prev_pfn + 1;
> 
>-		if (zone != page_zone(pfn_to_page(pfn)))
>+		if (unlikely(!pfn_to_online_page(pfn)))
> 			continue;
> 
>-		return pfn;
>+		if (likely(pfn_to_nid(pfn) == nid) &&
>+		    zone == page_zone(pfn_to_page(pfn)))
>+			return pfn;
>+
>+		if (likely(pfn_to_nid(head_pfn) == nid) &&
>+		    zone == page_zone(pfn_to_page(head_pfn)))
>+			return pfn;
> 	}
> 
> 	return 0;
>-- 
>2.47.3

-- 
Wei Yang
Help you, Help me

