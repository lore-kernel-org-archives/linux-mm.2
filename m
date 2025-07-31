Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F413C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229B26B0092; Thu, 31 Jul 2025 12:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA216B0093; Thu, 31 Jul 2025 12:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9456B0095; Thu, 31 Jul 2025 12:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC6DD6B0092
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:02:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60CE580B42
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:02:49 +0000 (UTC)
X-FDA: 83725028058.01.BC588D4
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf01.hostedemail.com (Postfix) with ESMTP id 62F4F40002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:02:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=bcQ9Gw+j;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753977767; a=rsa-sha256;
	cv=pass;
	b=yw+jSW56vv2q/ELoFxddwtJAwlGvxMqe/2Yu8iIk38SuGWnHjPwHg8JLvTmwRd+moHRCnu
	5iM5b/SDvois0Y4Umoixni7tNinAhoQJJuCia+jrQyQleWKhFB+sP7/uwghBLTWd5KYpBq
	6JxSKUqRZL3rXkUYrAoki42iQwztW74=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=bcQ9Gw+j;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753977767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jsundmjk432Nmx+yxivH/Xk7ers/4Sj7qV5Y59avV5g=;
	b=aLtr3YAfsG0NSXp2dgAYJQIQwKld7QiKTYZsIB7WpYVWYILQLXvUMP+LnauXhqfwBEPkOL
	cvnHW/X+dxVZNdqwlVICn2/45Jush59n0NT4KKeR0WOCJP6Ly6UX+dPFqdIjx91UvJVHNr
	DiGi6KcvADyHvBvaf6AYIVRYwAHAnaI=
ARC-Seal: i=1; a=rsa-sha256; t=1753977750; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=DGVGICaTwhhJr59gs+cfZIQtxM2SepPnYLR/ivuLXW+6ONYxfFOmF/m90Avpb5zRkiM1CFHFsumMTL5pQP5LO1apBSZ7JW974L42i0iGtZSOqi4uwI3I8+yLa6jQUhNFDDrbLhA4XVB9LBEQb0FMYKWiQMPUu36H2bUQlgA1vE8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753977750; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=jsundmjk432Nmx+yxivH/Xk7ers/4Sj7qV5Y59avV5g=; 
	b=jXJ5PIT9OftLeQJq9Mgv/O2RwZNvlA+Z3/MdnDE2IeJIf3jCRszZlUXaespC1q5Mk6PBc2z0B9VvyXApz7fOQZoih+KbUnPvx40pLpTlBGtYPffCH1x2waK7hFVc/SGJtRiNLorQwf95kuIHn8kXKMqQbLcC73lXCUFlrR1blZE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753977749;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=jsundmjk432Nmx+yxivH/Xk7ers/4Sj7qV5Y59avV5g=;
	b=bcQ9Gw+jfHYzvDinaxptTQseABCW6dyLRb4HAE/vHF5+bg6OQXjqZtEp9b2szz6N
	kw6Iy4yI6w830plPR6802G9dUD4zErzqq7DnRMDJwv+r/eeEeorIPNi2MJYsXxMd65y
	3aSpCymxEyWj7fLqY8U5Q2VgOHl1NstMwA1xXyMc=
Received: by mx.zohomail.com with SMTPS id 17539777482221004.5959311406996;
	Thu, 31 Jul 2025 09:02:28 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v2 2/8] selftests/mm: protection_keys: Fix dead code
Date: Thu, 31 Jul 2025 21:01:26 +0500
Message-Id: <20250731160132.1795351-3-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731160132.1795351-1-usama.anjum@collabora.com>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 62F4F40002
X-Stat-Signature: 5quuzcc4spabh9hdig9sd48izdc9wafw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753977767-294730
X-HE-Meta: U2FsdGVkX19WtLPxI51R/Oz/EkCMb1qtkn6qIMcpoaijBIoIS41b04hXlXKzHS/buFWSz0WmxfE1BWIZd0HCNxNGOOt09OhU43gFWGjHhNvhso1q+l1Li95AwmeUjvygHjVENyo1f5yKpTmwFDGt89nATE33c72d1Z+JpPcUhzi/LLwJqNK3/zQfydGmTYGM2SqXnkLEvBlMhxCK8hcqsoFbLRggKx9V2uqS33E1nDamfR6kGjE4kQjtCTkElU5HTNBqFPm+FKimeo1EcowUfqCqWOpdBt61llGyKoMytZT75asyazFye3A5EE35XU6Zo6lYF5pVjvlY7p1KfZ3RKI6lrdSVsYDBUQXslOQCOEBfzZmXuYovYAFeJ9nCqnfcKiGJTCI2YN8Ck3Qtd+tgvl8RD26YYsi4o+4g9YuAvZZEqv0+bkLjZnXQeJ69raOYQLmrrLvVpd1pFXDlqa8ubUx3XK6qxNXFqtkvGPJsOM/uqLlLSckrpi+HBoTkvSPbn0eRxjGv1q2Rsdxoqjyr6k3HXV+lnnqSJVIk1rTDEnwRSLP1vN+dEyZ9RsLwaPEoRDvo6/xUbzfAQlXwxelW03OxOHNryJ8gBb7pRkeJJw7F+410UYSR7SliB+Bplr2u9kzufARslK/EgSjCKSRjKJUcvXn9mhG57l8CvjWuKfz1LJH3n27W7YHBpoVjCMBHyiSta1Dl7pGZa5K6sp2LgMFdC17BLV/6Vad4SelBkm+6m280aXVm3U8WcoljzelIXwGlF746I843Ar5lSAgD+y10ctVKQbgpfzAkRJV6Udvi3yxqzcnOKpsYySPVisJXPLb7Tu2iIOq5LixRSXyXU4AbBukMeR8FuzrfykCvG+xMfwPckgEGS2X7WOIXB5ZJvvl4Qsrl9dm07lQSXvvRtL2FsqAsGADsrAwT4YUDFinIuLwwsOklruvYxO8jcIA4qFWVqK3c0a7lGb0tFDT
 Ru/JhWs1
 VlczXjemzuKrUpo3WCQ4zV701yNwRP8rwsVTZuzFgK5trU8+WyiodA8WFZfrQ8Runt5GfvHgrM5u2MoV+/f9UHd4z1hIks/OsurBGExn8CPKfpEH/cYn930bLd2G+Ab5D8ArnWg7rkvtq4gd2qfUyFxHsSAVMoqYFF1UR/y+0OgTJSPxeVrrAIkjAGS4IKCmVfAnRK0GwLKSD9ivR+jqBUfI7BuyH3XECH5ruPDCCueVqZ0D3MTDuAc6mudNy8OL0kcg9D8SeTs8LhljOBeHBXyANrbUlPD3nShk7fxp2BnBtR4LaaGuDHzF/wylR7evL4qIJw13MRiK5AonC0PakKgocilDeg7LobQ1JdzkztzcfeawGnKfV3iIxtoE5rI9GL89MmshJBEpFcodX2nkojZ9LRKHGRWvhXrUo8rq+D6FZrHayItNQohv2HQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The while loop doesn't execute and following warning gets generated:

protection_keys.c:561:15: warning: code will never be executed
[-Wunreachable-code]
                int rpkey = alloc_random_pkey();

Let's enable the while loop such that it gets executed nr_iterations
times. Simplify the code a bit as well.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/mm/protection_keys.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 23ebec367015f..6281d4c61b50e 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -557,13 +557,11 @@ int mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
 	int nr_iterations = random() % 100;
 	int ret;
 
-	while (0) {
+	while (nr_iterations-- >= 0) {
 		int rpkey = alloc_random_pkey();
 		ret = sys_mprotect_pkey(ptr, size, orig_prot, pkey);
 		dprintf1("sys_mprotect_pkey(%p, %zx, prot=0x%lx, pkey=%ld) ret: %d\n",
 				ptr, size, orig_prot, pkey, ret);
-		if (nr_iterations-- < 0)
-			break;
 
 		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
 			" shadow: 0x%016llx\n",
-- 
2.39.5


