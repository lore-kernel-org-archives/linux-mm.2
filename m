Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196ACC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DAA26B0192; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B606B0194; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450236B0195; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 140A86B0192
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9256B1203FB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:02 +0000 (UTC)
X-FDA: 85165248924.27.EC86F45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0101D20009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKaTg89x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSTjwnDV8A+NiGPVQu+FC6bukzN4Edj/bjp5VqLzRxU=;
	b=7vEYaUPbCU1kn6iN2FxskELG01Ri9BLycPjfb31lxGUVZz1iaFj5eYMtu/ekZUunHxDC1t
	pa+SuUnMjO348kEMzvuGY0Y5tFAozJ18EGZd7fGrrzCIp4IW7UAcIAkK3qvvpdjWjQk53L
	DwZ/XrsDq/DPvSbQ9UUXM0XcIvJdRaM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKaTg89x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268741;
	b=3qVAZ/z27nJ3MZpWUUXZKBpPw9wPjyTqdPN2N1mzDxHaabflwsKnHMq75FYb2EjkOrFVR8
	Yunhhq5agXYa8B/6PLfF7pGqClI8sI42CkHtI1ekpiwEkxfC4dPeet34hCfOn9Do9ZMiKI
	mQ0j6nxzddmDE8ta3byAXaE+aeggaLE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1649741F9E;
	Tue,  1 Sep 2026 13:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B645C1F00A3F;
	Tue,  1 Sep 2026 13:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268740;
	bh=nSTjwnDV8A+NiGPVQu+FC6bukzN4Edj/bjp5VqLzRxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKaTg89xFTeHYyTU0AYlP5vP6CBoCrQY+li5Smev5n/gqRqavoXXXL2OkN/kD6Vgm
	 XgbB27M94hUc2eLdsd64j9MYA/F1dC3ikoy+VUUqSCyem0Xwq9qW5R/55RRwsfqF5o
	 MH5W7MLxavzLWxZmFKmrVaU1opKhs8Y3LvivBsF1hsd0KYQrdmd+sw9Di30uVWhtIX
	 dtQ5N7irsZmSpYO3RoKtDHp7fBf8fjvZVPx3QLA8+f4UK4fX0AC6a7ZBYPjo/J9Qjy
	 Yx0bVYJG/yQ+n8bqIXUn5flvjNOzeIqisuHGjajW+S1xBGBUM/s9NcJekTBTYSdHCc
	 MazJtTNWXOctA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] mm/damon/vaddr: respect folio end for DAMOS_STAT
Date: Tue,  1 Sep 2026 06:18:45 -0700
Message-ID: <20260901131850.98037-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131850.98037-1-sj@kernel.org>
References: <20260901131850.98037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ags9wstgtr78oaej1pbe6s6od1r8a53i
X-Rspamd-Queue-Id: 0101D20009
X-HE-Tag: 1788268740-280385
X-HE-Meta: U2FsdGVkX1/xqtM2DRy/dJW08oD0jPvRcY0mnLA1SlDoOqEofl28YSD1jzPPt9OcT7BJdPzcPJQZJ1RX5DaAHZfsLsi0PuGy9R+b9Uw2un4siADahNytrrakj2mtpu0SjN6MJet+cqtMRpOrUVDVxY90HmIBABtsyPnMCAljhpCpPXAlRf6HeBbbIOAhoD3gRwQ2oxfybJs2z81ZWM8dXGgKqLvt/OAmirtYFAJKqyTI/4yAHojyuA8LyJtWJmGbWymYO5s073hIwP5Mun40d+yQilFcUcPYEJUjSNpq/iW/nIpNrp/5BdHssjlXDvFM61J/JtTzSl/n92sMArgR1BjlY5es7fWCYrWnxgoGsqDD0wj0diltPtvxqqGyiCVCDKRF4JWxCPl2V8WzCkleK9/W32YUS0+f5pmlw95UzKPYKSN91FYoyx59Hit+lolSgxmGbd4eDBk1i46YFmES6RWDd/yd/RomUA5iEV1DbwngH3ZNsjdBY4RDI+MjJA+QGeZKLG8hhojVvybAJxX1pro6/jiTGfsKepUYgoUiPuNENjaPVk5Tu+PZH/4w+cPUHoaFoUF2H08PwqJjnaaIvDsSHL6gsZkiClNYjUk92FkDKvIADMzsWybK7eUkQtB7xkQ/oZnlkDIyerWP9N+5RXE8fBfVidXSzrk/scn2UBHPC+R3VinqGjqIgfortxVL4AWuW+JpTqyYX7KXZuiJBGyj4XH+nMEBtvEhleoU60+g6/7NfX7cCZzfiHWDtEjWboYtKxMNrL9NIyNhY0dG1UWMk2aDNogA8zT+FbI+CnBKFfWFef8aNi3rIX/bSY4hNFF6RVAninNz+7WbBRokuSIIBimmGBHQmjsDpiiXhv1ZKFVuZsCve8pQdtJ61gZ0yQTiCefEqsF/GnKQZBcehMi2v8afiPqt3Wbmh1IUHoemKfCxIxx0fmhUia5FIouHc6hVzvZgzxpZaklfHsq
 UAU8Q0lv
 rnKxr3ZEbklsWPb2vYuPIT/XKoysb6PliRyOjdnZAg7JPhVcjxQKjYYIyK6jin/NZgtOAoSKu9Teew+TIlnNSndpKgNXJUqtO+1FBJyZbOHhPE1R9hviTJ+gJdXC+1+b8XTovZwt4vgBkobbFHEOdAlKe//PU0lQnutFC+ou6hIisOAN93Yyb6VVN2rVJC8ASc0HREGmYANobNSfthgF93GvI2J8qfAcW/DqgTMEu4YCXLku0zKGIQniYPgjFW3yVbfKSc5FU2DTXvbwma8oGYSV6XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For applying DAMOS_STAT action to a region, DAMON virtual address space
operation set (vaddr) calls walk_page_range[_vma]() for the region.  The
pmd walk entry function, namely damon_va_stat_pmd_entry(), applies DAMOS
filters to folios of addresses of the region in the pmd.  It starts from
the walking address and advances the address by the size of the folio of
the address until it goes out of the pmd or the region.

Let's suppose it is for the first pmd of the region, and the region
start address is in the middle of a large folio.  Also, the next folios
are small.  Then, some of the next folios could be skipped.  Fix the
issue by advancing the address to exactly the start address of the next
folio.

The user impact is that the DAMOS_STAT-based page level monitoring
results become inaccurate.  Since the page level monitoring is supposed
to provide relatively high precision, this is definitely a problem.  It
is arguably not critical since it is only monitoring quality
degradation.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org

Fixes: 63f39737d1e3 ("mm/damon/vaddr: support stat-purpose DAMOS filters")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 0648400b2d65b..4b0b5edf67952 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -831,6 +831,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -844,7 +846,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 
 		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
 			*sz_filter_passed += folio_size(folio);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 		s->last_applied = folio;
 	}
 	pte_unmap_unlock(start_pte, ptl);
-- 
2.47.3

