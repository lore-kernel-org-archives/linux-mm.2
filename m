Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D090CCFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A8E6B0030; Fri, 21 Nov 2025 14:15:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341D56B0032; Fri, 21 Nov 2025 14:15:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20AD26B00A1; Fri, 21 Nov 2025 14:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDB76B0030
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:15:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3E7C140710
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:15:54 +0000 (UTC)
X-FDA: 84135569028.10.6D2B590
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 05FDA4001A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:15:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Jz1xW+Bb;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763752553; a=rsa-sha256;
	cv=none;
	b=lE2d3RVe+R6xREHZq4Y/Crlo4Ks8WGNx/jVPE+xOff49PbTB2X6GWypPTUJKuh0I/9op9k
	SCNuLlCtXN6s/vmLnefmgdXUCLvAfLkqtV+igdSIlY6AWCKQtv8cXJxrviuxZ52zbEwSnU
	cf40bYDI4yegywuC2Td7uJ9kOyVkbLc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Jz1xW+Bb;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763752553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9cVYU0jUAAREbxmzQINLjsxcIyu995p8YVRTggmw3AA=;
	b=MyfvFbNQtDKehFWHPMKmRIIkqapCf7xUwXyk0m8XIoZW9qEzI7seLySJz6pAkzhmDvKxSh
	iBPM+MlhHSHp/rwRW/QajzEbfkY75JGqLMRPvLyFusNuRHN+/agahf2Lfld9mkPSglOrqG
	MXaKbzglpQKLOGVEJuDB0IEpc7PFejg=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-882399d60baso17917096d6.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763752552; x=1764357352; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9cVYU0jUAAREbxmzQINLjsxcIyu995p8YVRTggmw3AA=;
        b=Jz1xW+BbnTvchFAx9PBTB0y4KBc+9jApRJeXkvyyu/so2cJZATH6Of4WqQHJ2JAumX
         n/acqGGokuxbNHqeIkyGZjg4UJCCIY8QlXAT7p+lGg/IkB74XRJiJyWNUyM2SoZa+oYV
         0bWR9uj65Xw0s7v+9oK87CQL8ZEDQ/eXn9GcODgMht9UcsuKQ6cf1vXo7hoFte1EbDUE
         vQbdZ2nFbQ4BxVTILyg5FDi/9vlKVrPl46k6/nyNY/C3MKIJl3Y2H3JqPMlV+xiovGgI
         5RiweOsHXp5mQG5Hp/c1fcxPfSjBPYMT9IKIj3ROnemrFjoFg0JRepZSVXIypYCw8E02
         OoWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763752552; x=1764357352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cVYU0jUAAREbxmzQINLjsxcIyu995p8YVRTggmw3AA=;
        b=QM0sFUg0Iork6gMzlf+Gm3RojZ7vt/V6VhzlzjLCYcF8bhVHc5S0U2ILYvObn8G+lO
         W20orfqDvOY74C4ACjtAS27awIl3JbtK6K9suA9SC+Ixq1ipS64bDYYQNqo2ST5/IeHQ
         NXY3wfF+t7qezPdzjes6AwjydVEzdhRe/G/ShWs78qClYzzxIXWgt0lfsaqtman5bTPK
         PLt/IZNwPZCTVfUK1ZZ6Y7gs5FVyxe5LXVO0MfmDCZv9xFvmRN/4Lge99lO/e2rqZCyC
         AGLjVnnvX0dd0d8d0kwdRJvPaijhNh4411kutojOiFfBT4cZQcLoxR9fAchSrhh0o2gw
         GYFQ==
X-Gm-Message-State: AOJu0YxIdrqL90x+diKN44wFhOZ6skPM2iWlOL3oAbcosxRGpRA/yTpF
	uoAWia/6/umf2GAVbEvoJ4jcX4fHagELAXh2jD2BeD/rRzG4Oso0MjIm1+ME4eMSxvmgX6p4o/K
	mGP3y
X-Gm-Gg: ASbGncsUbd69ijVG5MabUgjhjgUonqDgfL+D3snQC/97Rvdwtvc4Gnr9hY/rf8qMlam
	sneH/2GpEscPbqVPWd/Ja80LNzdGB7l90H6zMZMX+YhNCsck9uRXHgzG5K9gAfnpYaFjl9BvUOC
	qT1bt6U2GQJ7EaWVeCaKLSV3S6P2cL55aXbIkEl1dsCOLIyyPJ+X7Nwi66kgkMx+0oJNPcyl3qK
	K+OZvpA+7qEXnBrAwcnGEC58+zzVX+krqwHM8BLNvApaZjk6qx9pB47aW2fMSDUdNkpX69Hp4qa
	yD82tDmc5GCILRZ0+2GmzWAKIMx4wNhZz44QUW9w2dEJ1nsOMARxCw/dD/r61yu0+D5vZjLhJ4/
	uU00ETo6UH/Oo3HoUVLULH9cfCbME5HIKQbD2Hjhi+clJzI36HO70oNCHjKmgv36jjME3bdnJ94
	QEZZPrn53VfR37W1Vr0ZZsZaWIcixa9zhPSJ7zRyrgUpgUitfTFbZ5qNXmRLjqJ3ZBNAijKJPKa
	g4=
X-Google-Smtp-Source: AGHT+IHGxru2CeM0UwntAB24WPxuCHNhlq6gHLLMl+FmJCEu8WPvfGmLBmspbe2MpbNhPjRQEiuKTA==
X-Received: by 2002:ad4:576d:0:b0:7e3:cc6e:3c89 with SMTP id 6a1803df08f44-8847c574370mr57405366d6.56.1763752551838;
        Fri, 21 Nov 2025 11:15:51 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e48f0d8sm44826996d6.25.2025.11.21.11.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 11:15:51 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: kernel-team@meta.com,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Rientjes <rientjes@google.com>
Subject: [PATCH v3] page_alloc: allow migration of smaller hugepages during contig_alloc
Date: Fri, 21 Nov 2025 14:15:40 -0500
Message-ID: <20251121191540.253624-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 05FDA4001A
X-Rspamd-Server: rspam07
X-Stat-Signature: 7hapew9zx4sodigzc43ppeo4j8c9c559
X-Rspam-User: 
X-HE-Tag: 1763752552-225687
X-HE-Meta: U2FsdGVkX1+fY/00dhjbmCzd+yP5khYC+4rHoCx+xDT2CfmpkdR90Xm/cJlFcm39s4VCvBLiolZVJONyCK+O55AByk6L6MDfFEdWevMz1UEC0douIILPawlGLzk5vidtG23Giu8DpHYMswGatyB+M7s4iOV+ToGtQ4HRQWNUMA2hXahUW/pyEweXxADT/gu5n9XajiNlqN7x5yeHcaCso4XNYwNoOfNLT3Tum6zekUzJHMS5sXxzOVzjU5JCS+Budws9WhFQ/HbDAmqJG6tmW+3YOXCJ0nGcUuIW8oD5dKEk/P9ftYgFV2lPP94Uowc7lJfmry2rxtGPmevpMuN+QHJadxkZy6AmWgSYVHg22Rr388YKw+IXV0u2LZbzl0VaPNif1gbANdsKERP6a3p621dJqo1718Oxz1VHwqv4ZnLZiEFmXk4NhPHNJQ2DAFvJLURt13m3uM0I/TU666uxsYKTjv+sStCT+KHPIV8d6UV/h0UkwiWmmf5dxx31JGupoNoDTevhoJvPfWLc4+Qw9IFrZQBWjlGA2L2P1APbHXi0V2luoMEyV1BeDekUGDtViGH+kxNoaDbta28L3MGeRBRb7zX6vBU+zDSetJOPESQlKUAf8+5XqM6u2SR24xmsHg0ktxwtGZ6aPUUpQfIQKtw1Wb9UyB4fV7fyIDbQc8Sa8e6emB5i/ggXedFOoz0V3XQd//o2OHM84FUUpFfyjSrYUj6zhtHUVfn9dNqbERVGgzObj3J3ah2twt5uHaWnB6pZ0PrcBJsIRCWDqGue0q5tI294EQF6iElCk5ADiBqWrV8pIkiuBwLaN6hQNQTpwbkoIW/x4BHSVpkRhoWxZ7AggvF4BhJwsl1jo69Dk5TpV3j0mAopJwHNxuacq4Hp/9XrXmAROiYiJX3LXMgWBljLqPIDBZGr/gzgN9b77Cx+7BFkP1kLfHlRF+3ih/AZt6YkpF3xi3O3vUSQ0lr
 HFiXuKtS
 GmuFIQrT/PLDsOw3I1T64sYN9cmYzdoOJDcs+0y6xjV0Zuao4Kp1XudvRh5itisn9HNnf4umGkXWRvGJQUfO8oVB+PsfUb5NaQ0O1szNlbcRPzymNWkP57oOHCDS65KoPJqekCX/NHC3M2nFA0ogX0NlagD8AMq8omk6+HDmhgomoX1uIFMPNlHD5JwfR0DFAMmrmqwyvWzloPRVY70Pcro6A/aP7uQOH0mgOnqarvY6xJXxnCSrDrWe9e3e4UGVXuEFChYZZJ3mM6zKBvO+c7I/5+0u6mlqIUn1KnnY+y+0kt4If/Q6XF9HVfr46abObzRAqNQL1WR+n2NIHyEVBUdZU1v4+ulJVhf3KOX+3+viTvVGAzxn+EOz8S7xCU6qr+UI9Za3xJNp8MeHKu48Nt0ntyC1nZl0vVUbWsGBcGcHu1sbqvYKpvn8qw5dTTy01v6HQ5LqJKxiQRdCXhx8U1iEtaW5WszGE1nzJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We presently skip regions with hugepages entirely when trying to do
contiguous page allocation.  Instead, if hugepage migration is enabled,
consider regions with hugepages smaller than the target contiguous
allocation request as valid targets for allocation.

isolate_migrate_pages_block() already expects requests with hugepages
to originate from alloc_contig, and hugetlb code also does a migratable
check when isolating in folio_isolate_hugetlb().

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/page_alloc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

---
v3: changelog updates and tags, no code changes

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a6fe1e9b9594..3b0f47f1f144 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6849,8 +6849,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageReserved(page))
 			return false;
 
-		if (PageHuge(page))
-			return false;
+		if (PageHuge(page)) {
+			unsigned int order;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return false;
+
+			/* Don't consider moving same size/larger pages */
+			page = compound_head(page);
+			order = compound_order(page);
+			if ((order >= MAX_FOLIO_ORDER) ||
+			    (nr_pages <= (1 << order)))
+				return false;
+		}
 	}
 	return true;
 }
-- 
2.51.1


