Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E794C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42FFC6B00A6; Mon, 20 Jul 2026 15:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3096B00A7; Mon, 20 Jul 2026 15:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2566B00A9; Mon, 20 Jul 2026 15:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDD9E6B00A6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65A861202C2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:20 +0000 (UTC)
X-FDA: 85010158800.01.D8333D6
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id B1C0EC0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bWLX1OAe;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HgkUnnQve0Rn/Pvs0Z/0q3yFfFJ0c7Ckz6K5pdtr6eU=;
	b=o2IbFCHsQnSEN/Vpo+X/jqR1BmrNqqzU2jKzaWlJpABRDWIJHUUsSG0O2d/C+brEvNcSbo
	OsEz386McsmPwGqBVhXQZzI6n4L1lhiS9ay0+923uAZ+tlKVmPrpNlIa9vVB0AE8Xj+Uij
	e5VSBCC5meishGo2Mn2NV/ELy8Al7XU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bWLX1OAe;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576118;
	b=aoRr6+Ya7YDTFf9iQ4x8IWGE+CdV4hNqAxZ9TK1l9KV+HN6Fy2XzbesQFhivn/KjOZoaLy
	BIwlgFqnRHCdM6EEQ/mC9QKSUVIdkSXSMzWoGN2M4u2cMUYrBfNB8KNmgL9KHXWXpZ7NDm
	0gucL5qK4eGpULQHxAzYNIa6PaNM9Zg=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8efec2c28f8so47236076d6.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576118; x=1785180918; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HgkUnnQve0Rn/Pvs0Z/0q3yFfFJ0c7Ckz6K5pdtr6eU=;
        b=bWLX1OAew8qfnfGmcJxIfufNvsmLSudwGZNSUI8n3hYjC+05zjeQYGzXCD5ZOBff8m
         tYxEkBznyujUHqRVOjUsUse+t647C/EIMDf2BkRtTx/OovNfsJ4ROPAQduw8aug8lApX
         Tsi8d3Obw/XAWzniRCsc2IAKMv8wo8SOzNm+QX81cs9aEMXRiMTPShqyIdWL0wkXGpIj
         jH2epC/+OrGtTwJKqHg33g60cQpxBzycZ+j15fFMqveBFhdDiTz2OwHhur+gHapRU+U2
         CXdjoaWtcKgOMRchgb5b++LYhTa3U+XQqlzKZ+v7Luxjq7EfyUqgAxTTgz0XnQnz8U3I
         qmGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576118; x=1785180918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HgkUnnQve0Rn/Pvs0Z/0q3yFfFJ0c7Ckz6K5pdtr6eU=;
        b=sT2/HJrd2S5iH9AGSfufSOH+ArDow+aU6jetEYORuzYQBTE1xAFzSWh9XJblr+gkhD
         7+KILztIT1WTwDtFG6ptBok0DcS/Rmnb59Mllue2g+U62B2MByAp0b7WQOeWexb5+JF9
         /cXVo+eTq4Nmx81K3MslLONJo8OTFD1K65gk2vmiSSGUzF8PmbHVptl4ljDftPY/sJWq
         Zo8lboTpCPiNWV6VvdXu2gHzTJI+tXUAufjUfr+mhu/8hCvaI902rwnRbghZU/NE4qY6
         Oa0kenXETfDHBDGwmr1/LOQ9WM/5lmUpL+jwU2SnuX9aGJszV9xNIzXvLRxCJwKNg/1T
         F1ow==
X-Gm-Message-State: AOJu0Yz7WinuOsTb336tacmma7GNeXjoVhyKrgNgz7dZe1byCy76g4Un
	lnasLrzJ6bWwaK8+vKWSnJR5HEQAWZpeFqPgl5OisFLAt+t/xfrVX8YniHZCOCINsx2/eMa1swu
	ACaaA
X-Gm-Gg: AfdE7clrYLY93DrCG2Da8Di3SxCg9gwyr9nUJlWtadJi0q3KdI03cAShEpPlqcWF/Ex
	198YGZ/oBIhc3Kd9l3pclFcuu55L/dI9kav69Ofyo/SEi9UrT+tIie7PqOzW19ezsjI3UOpI7B1
	1I/WXKXZ9QD1dLZVnOjMWwSUy+7UwGJvemKa8hnm8sGWR2CTP5hvR68deEq9PszegacvbwJhKPq
	t7++8OmS7ZVFzExmW+tkKkuNqJodPj/d6orl2qB4rbYHIAMDj/DEvXu3Dm7qC1gwrtEiReo4Wfu
	bNDO5BvA27iWMYnvTFMrGSAhBi+j6Aax575HXeEUfsxzsSpJ2fSoz83JJZ6svr17zxYdjk4KgGI
	v/OO282wuAtKEbmkOjxSZhzaAzOXhTBgrw5GSs1ChRZbGNmaSUEahQIQZPuT+aHAEc+t1kOM9lJ
	ycMAeY6AkRe12D9fM3Csnz3B+KwOwN0HxdhwTvoKagtlf2orhiOpzWbzb00vMi8mw=
X-Received: by 2002:a05:620a:4007:b0:92e:c116:bef9 with SMTP id af79cd13be357-930b4315599mr1572701485a.86.1784576117793;
        Mon, 20 Jul 2026 12:35:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:17 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 15/36] mm/ksm: skip KSM for managed-memory folios
Date: Mon, 20 Jul 2026 15:34:09 -0400
Message-ID: <20260720193431.3841992-16-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B1C0EC0004
X-Stat-Signature: g6gwrsj8xs6tgqrtciyz3n9yrfmk8ggg
X-HE-Tag: 1784576118-225644
X-HE-Meta: U2FsdGVkX1929ixFyoUrVZhpVQclLYyfGEXxbSiqAjX8Zo2JPg7Mi80SC/cLeC97RximN/b07saQAdnYdCzA8/lvUiezCiPv7mx9uHaoqVh6aUUaZtOp5eFM6Yl2WXO5cuzrqP4CeHEXRTXQMIIxDxUEnKt8LkXqnQOY8aPMZYyfvM3ZVsOmUSOMW9R3T/3X2xMXgAXNWtqHPXTrDzu5ojHHjYPiD0KjTXReuAVzo648Kd1bod271mVu6ZAEq/fYxP84guN92NhkgtXH1lWGjPesa3WZCku9Rpfc5xTX5+hh2IGwyyqkle2zt5m9IjpDY+1MmcyK72SqLGgNpoHaJSFLbwzp3PMnx0QEmepeuREELRZfuN00Bfy0T0lC5tYDVG9TE0XlaIV5KgLEyMgS3LtRsJuuHXzpCj/gW5fpbYp3F5Xtl0fcB9xiReusVPOPd/PBwBxJKAHWMycCs9dh6YJsJWpLOV7k5Ade+HnvhEPRkioL7sD5sUHC43t0nLD9mUibc0QWyXUx1dc4fKwIE1GXggMd/YAF7ctjJN4Y+3ZpjaDez4gm670jimoSb38YBCK31WtuzlWM7LsyZOzRVoI6KzAWqZaSV8UaRRtbtO/zXsH0B4oJoiscV3W6px8BeajR36y0ieA7+6Xi55EffIAfNW0FNBOSFhVHefHx+IAYZ6ma7tR1kLvmduPexGwogsgQGC5buiGxxWMzAIuh+T+yvupsoAxaKhdzvmN/F0W1/0TK/J++soYx5fjYwxdrgwC74iCsZG3E4bBfWWrP+r/h0c/d2QaKH/3VShvSeiZHSDxWnRLDXjtl7vQvsr7SPL+XZ6ZQuvMFKUC8dMF1rN46+eIbzgzVd3oFE1ak1KGnuEhLOhd0M9ptamfqQXvmuk7HwFuQFnNugiwX/yo5EGDHK59q5atnv66a0wI5B6IK2wQLURk6p4u9Bl4r9hFx7DulY1If+qu2a7X86ey
 46CcLUf+
 N3KzGFgtpRVodlgE3LVTTEIdzA8zQmn5Sb/B3znb38Bc6lGr4C5400cWAuAtro+hMMq6jSVRw3uFgxgdeqF1OKB7P5XZFn1WghtjpmYreAa2ZijOQECK50NM0MZ1dk6yweyojRG/GHwuiPGD/mw7KQgDYfs+vrIgL/1ULADtdTCQxRZdUfzoeCnV+dPcQ+Td37ZCDCrJKkBaeXrp6N/GHs+FWh/3FoFwIwIFG6Z076HzVynlopB5OoYKpXXGDFK026OVIf7NhagrBNG4cjHgfK72bmJe3IH7xhsmcjpT2dbIzMFH5M3H9iXlaai9MUwAU27NDZL5FZLCywPCbuLcIs3+DfO+xzU5UTQbd+/I5/xz3YSpSZjE5h4O4ULJWoWuaZ2TZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since private memory is intended for explicit placement, allowing
KSM to operate on it by default would completely defeat the purpose.

Skip KSM merge and scan operations for private node folios using
the same filter location as zone_device folios.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/ksm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 47006f494fcb1..dcc5c46a29eac 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -827,7 +827,7 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 
 	folio = folio_walk_start(&fw, vma, addr, 0);
 	if (folio) {
-		if (!folio_is_zone_device(folio) &&
+		if (!folio_is_private_managed(folio) &&
 		    folio_test_anon(folio)) {
 			folio_get(folio);
 			page = fw.page;
@@ -2558,7 +2558,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 				goto not_found_unlock;
 			folio = page_folio(page);
 
-			if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			if (unlikely(folio_is_private_managed(folio)) ||
+			    !folio_test_anon(folio))
 				goto not_found_unlock;
 
 			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
@@ -2582,7 +2583,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 			continue;
 		folio = page_folio(page);
 
-		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		if (unlikely(folio_is_private_managed(folio)) ||
+		    !folio_test_anon(folio))
 			continue;
 		goto found_unlock;
 	}
-- 
2.53.0-Meta


