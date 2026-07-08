Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53873C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A5B6B009D; Wed,  8 Jul 2026 10:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161C56B009E; Wed,  8 Jul 2026 10:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FEA6B009F; Wed,  8 Jul 2026 10:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAED96B009D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:11:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6875BC06FA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:40 +0000 (UTC)
X-FDA: 84965797560.13.8912551
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id CA4AE20009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTU037Ex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4T3aSskSUL65uwGRfGm0A5PLww8rgg5Ag5MsYm7xYk=;
	b=oC9FFYHdCgV2TDa/KjOT9QxLRsfBlM/F5UipZUmp/Sfj7NvXEa0KloCEDQ+StU2SZGbzY1
	6lF6NgZprrsF6x5LkrsipB9WTAl1PBzeVw+dlezrK/aaMncI+xHvCf0WxLNnKjM7BN0LMH
	cFzV1D8zIhmbfuvcrVnh6U03F4X43Ck=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTU037Ex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519898;
	b=DMkQ/ZHKtnZDb/kA26oik0tvLa4kIVjmqSIiM9eAEgGRuNR0VT7gFrSFaPypL6pmJZmvdw
	cAB6EoRMlco2W+JDd3QQoZktg/e9DWj+/lA8x+BdDJd+cg/B3Cr5fe1O48PRKa7/2DZ0LV
	Y3ufVnMxuM6k8EK8Ofutr6cdhyghXnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6791C60008;
	Wed,  8 Jul 2026 14:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60E71F00A3A;
	Wed,  8 Jul 2026 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519898;
	bh=W4T3aSskSUL65uwGRfGm0A5PLww8rgg5Ag5MsYm7xYk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XTU037Ex9ZyJNkj8bDU9iKKXKpwT9vrllIePkr0TNA7XmWt0vSkPMfhGC7qjhjdBR
	 +KFgz361KYVgiVFkg34SU9hGOGDQ2+oGXcj9aLZ/YjgQWnt+o3KXDAkdkZbjIZZ9Tx
	 8/LI7Misflb/4tiOvhr2pIcnpvw/pqOVIHz9z0UfS4ENkEU0ApQdtV1Dx5y2hlECdW
	 fWdsxetgVhTRVTt4l0Wk7ZWVD690psoOKu4yg0GGTmzsxzstVn73IQck2mQ2lEsQlE
	 2CvWWgXrOV2w5ZYiXwVPpEuyZHvSI9NGXXomQR0zkv/FmVkzOpgrUZFDRpuBJH2RPg
	 vaETbZy++DrHQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:10:59 +0200
Subject: [PATCH 04/10] mm/bootmem_info: allow calling free_bootmem_page()
 on pages without a bootmem_type
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-4-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: uodtep9co1xwrb5mmz9y8d6oeyh8rhyp
X-Rspamd-Queue-Id: CA4AE20009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783519898-171796
X-HE-Meta: U2FsdGVkX19kZf/0xrlzbOMcghnKfe3V022IqAhO+Nb/7f6moqaNVqtsK1o5U9bLCwHXnd8lrzKoq/77lQajGIxAFAZUuJhL7AYDxDlZ0mNdsaQWjaWQbmjCErLOYJzSIGmnnrrYPse+162OJ5i16TtOdVaYMaOI0euJRp8TF9LAl8GpVmxVW7kIVdPIoom4hplaplHO2NQTF3PZEPXl1zONAVMP6jnUY7EVl9px7HFm/Vjw9EmfNeS3DRmgLoThDaKaA1VwFIyhOsoBDgIvUDSfRgDNeGX8BsTha8VCmPmrNTKiR1XzUo2l6htSlIMGlUvGSQEd/+UHeF36wVEagclwb98I5izH58vG2NikZj4nO2yxqd8qZjXtjW46OdoAOTkCS4QKxmgQlNyt1QdI4oPv6x11kfgT3UFy3StWN7V51irvKqlf4X0puZbvR6hDQRelHJ/M44fYOkUWbTD0s1gJh7RU/3QUpJ7j/W4bDTP1wvDVwdZxNruW4IHd4Uj0xGbjlyIQ9HzS36wsAj8S91wrcqyFYH22ioV25XjRg1X4UJ9SuI2Eg9j2n9J07bYnHk//e3mbA2jcE7/2GIaTEV8hWhZ9nSQ9JSBVwpYbn+DLZ0PizuivaKf4C7wnjDPN6og22dUCkkg2aURnXIqiSx6fdhmXRdMMSrhwaIeXlNiIpsBJW4E/8DgNsOSupiHj7QHomfob5jt5IZT9P/ImbS4jOByul/I3hN++FC1ZkCBPRMZn+QOREwL4yE/rYGJ2rzGPJudQf+trE5yc4b40IXEVhSMN2Ix7vN7SayyLPxGRvmH6CqpSfgtLkHGtY7jle4Piv3spfWj+iIjhnWB0jcvdR9kWUqAizKrrh4Tbkk6APDtkgMlrMKtJfgSGoFmBil58m3v7xgDvUzYGZfxdSzgDlMnoVhy3Vd4Icbk4hfM5ZZ0SRNcEh+h1b3EZsO/4rVNH4Tm4biKjD8B82va
 Tjs8sVj9
 MXJyDX13rS66jWDDDN98OR6V2J+/olwYPWIacoPey3r4maXZYqLly+dLq/9LmTpU+kC5LJeelfNzIMjwYhmFV2yIe2sO8scn1UFU+jbJtwdFtHl4ZAKUkVW550mfR5/f4AaMYTdjZFzoW4Ci9eVgN7gmmUB/z4Ldu3lUj8nBh0Tz0ZyFzy7ZaiZ95MvdVljTun2Ctl66n4EPQZuC343oXpCnGK7uuxTCyFWyO6XWROZvO3azIEkgKoy9tHQOL5yDkoJtTArXRzW+o16KRvyx10NDR5mOqmU2nVnK2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As preparation for further changes, let's temporarily allow freeing
pages that were not previously registered.

This will allow freeing unregistered vmemmap pages allocated during boot
through free_bootmem_page() from hugetlb code, until we fully rip all
of that out.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/bootmem_info.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
index f724340755e55..486acc6127039 100644
--- a/include/linux/bootmem_info.h
+++ b/include/linux/bootmem_info.h
@@ -44,12 +44,12 @@ static inline void free_bootmem_page(struct page *page)
 {
 	enum bootmem_type type = bootmem_type(page);
 
-	VM_BUG_ON_PAGE(page_ref_count(page) != 2, page);
-
-	if (type == SECTION_INFO || type == MIX_SECTION_INFO)
+	if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
+		VM_WARN_ON_PAGE(page_ref_count(page) != 2, page);
 		put_page_bootmem(page);
-	else
-		VM_BUG_ON_PAGE(1, page);
+	} else {
+		free_reserved_page(page);
+	}
 }
 #else
 static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)

-- 
2.43.0


