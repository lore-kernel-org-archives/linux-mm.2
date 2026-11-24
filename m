Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2F5606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=EuF0fepp
Received: by kanga.kvack.org (Postfix)
	id 394906B067D; Tue, 24 Nov 2026 06:06:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DAA6B067E; Tue, 24 Nov 2026 06:06:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5136B067F; Tue, 24 Nov 2026 06:06:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D54FA6B067D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:06:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C72B91C45CF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:48 +0000 (UTC)
X-FDA: 85469734896.10.326E891
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 967734000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EuF0fepp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795518407;
	b=xstJH18tnWusb+wvCMzCNW9lbqaGBerct7J3BQVQpU630J/kqU3qMJ5LMVbvEhgjxzPPu8
	rHFSoYYf1zkC0OklVi69RXA9NBFD2ICBXTKRj0FCD/rWNTRWuixphSfysn3EarMZd2IKdo
	typxgO/oqPSYpl/YySnZKGIRl92vnXs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795518407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbIyF7bO6W++DN06XYi4/c6VO7HYu5YDs3N2duJ2UGI=;
	b=u17tBj9lS+QLl//mdObhVzcM2Ymg+UYfDmu/dFfHq5PXQ4m2/J1+ZbVNKtvzO2fkAmO6v/
	lT9XAWgo0EXF1L+lOmwwR36q5rOqMJZLFVLDV+ssolGkEuHsGxknF6971DuoNOaWKManbV
	MnuBvJz6wlxY8RBLMGRA/i+m0kB9Sxs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EuF0fepp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2f0213202fdso22488555ad.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795518405; x=1796123205; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sbIyF7bO6W++DN06XYi4/c6VO7HYu5YDs3N2duJ2UGI=;
        b=EuF0fepp/Wva6KbH0aVillzzdD+blPXg1V2hm6dhGTH5dNTA4JfcQ45QLlSSLPQNXP
         +E+sa6zqdN9sMAZpeNsg/WPc1fz7uz9TsZB156ImGUBnk8VTkHX9rByKBydb4qZCINBv
         vfazUu6r7kKq7UEcpjjPH6TkTvlWAqPhgmGFZId6PaGLz9NPLgkSwTrAaiCmGJu3kes2
         wzIuBDmgn07Jl4m/xYULwtFT/gWc+Tee0orcWQQ2iUgdIBw0dH8vZreqAArHhshrNLNf
         krMOIaV6LGdq+ETfqRnpUwqQ1F5lwqZkpseQVgI6f4Kd7BYWLbAuPpyiwMA1yAmcePE9
         a7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518405; x=1796123205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sbIyF7bO6W++DN06XYi4/c6VO7HYu5YDs3N2duJ2UGI=;
        b=ZdwC3NlDTbPA8/Lpgg3WopEjexuHpkTuqLaB7ciYUE/Vmp1GfL8OLBWRZ1VYj4vbWO
         93UTWXKmN0h44hFq48hL6dCbBIGYUe5xiQJDiA7Heb9cHO88f8hgrSko7I7U9P66ecg8
         scIJh4rIuETEneBaeyptx4L+dPJG6jjXQoAKzqRMHlnuxZKeaSV0nK8sTHbwaCmsufFK
         7IHUe5VeCi4lIicAn/m+cRUlsmoVLRGSqVmWta+GGB37AbTHU676MXGQ9m6o4b/g+8Qe
         Dlz7K4A0yfQbay8s5yU0b6onfbhZmJr+YpIZ0owHC4dX+HRqRQQZ292edGsvfT8RXfCO
         Zz2A==
X-Forwarded-Encrypted: i=1; AL+hErHIpwHUhiNzrozvD5uEG3eRAAXRUEE2RsBle3L/SMtuWF257DePtlM7DQAacGDZa/LMm4aKsy17wg==@kvack.org
X-Gm-Message-State: APuU4Z9RPwq+qUDR0D1gVHkGascwedk10EKkQgfzzFC+Qi15qsfSSZUf
	Fq66uLQ2mqFkL50O+k4At6t26rY7diIu8kNJUKoqYov7IQAe2cPCzTBqrZHznJfZUuI=
X-Gm-Gg: AZFdTZfGq/0ZhCotV/SrrgboSplwJbAF225wXSiSrIWYIt3z2D7M6a7XOmNOsFT9Vlh
	Epl2UtE0rmIn9F4TN826645sa1JdPP8VfEZ4z4vxu3xXIOfDdUiZcPX6koxCoHfWvRTxPvMIYKw
	32FgEwhMc9hUHewRD3B2TU5+qUtswonzRcch8zrg5iiSIRwXtYEmjKHd/zbeeu7pUwsDUhuSEZF
	mysK1BTRUTfrVblByRzms4WErQgmGYnLUl91PM14dkjrFhDiePj4Ngiy29pxbktlDz6/Ji5tVi1
	EnlkWBGkO2wa/kqLZUnPnvcxxgxNCL2ebCBkngEbXdwSY6J3joQqzWpiBYoCHGzBAGC2X4i1J9i
	vf5mGztB/OjrNsTBFwj54984u54+RJ1L1NYGHbDstSCgWI/sh5Ac65jQCMmnC9+/wBY3r4PXVIz
	7KT2iEXaj6oc0LVCm0Sfx9w3FoG4mIDpl03AAHdhDUcTVgQ+fiPrBEHOK0Ltw45eID+P6biZczd
	VyhdAAKj7z/jhGaHWF8JidZOl5S9FKG2OBSn4+42zmzLqfj+Mo/zmf3siH1ouiCQx65PDUytIk2
	5k2UjwsEwhwfxN1Vd3vQE7dAjm9U8kcTIuH2KOm78D73cD2PUrIu11OE+hVjSpWJQhQHcvg=
X-Received: by 2002:a17:90b:3d92:b0:3ac:7842:bd50 with SMTP id 98e67ed59e1d1-3b41c8dd1a2mr13528895a91.15.1795518405266;
        Tue, 24 Nov 2026 03:06:45 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm22909735a91.6.2026.11.24.03.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 03:06:44 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 4/6] mm/hugetlb_vmemmap: open-code free_vmemmap_page()
Date: Tue, 24 Nov 2026 19:05:28 +0800
Message-ID: <20261124110530.3004071-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261124110530.3004071-1-songmuchun@bytedance.com>
References: <20261124110530.3004071-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 1hr6wy5ehzuzu57qsociu7z1wqe8qy1b
X-Rspamd-Queue-Id: 967734000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795518406-583280
X-HE-Meta: U2FsdGVkX183+/yeiFuXyQYVAHRWD2C9dB/hv3NtblFTR2gAy5gPAjac3/lUNiu+7QhjIUk6ALPpr9nEQLtMnE/Nx1TaDRUrmTZuxGzhgMkK0JIH/Br+2bghwPU6dabNTZWMm5C6Lg2r58An6xzkW4NTyy0gT9ZV/zPG+/yBTpIc0R+FkDGsCvs2dhIhtyUMU6kFRVMJfjGuC7HXAQnWbRooSX+a7VPqI3neq5GptKh1pc5VjMIaQKww2rY7w5eQd7uEyg7DOIZmAwUeUnI/fPY2A4hePLDnzgnLzKyZV/RLS2hHOV0M0k82OuHrxYssFDRmnydd4UJmzIn5Sfdhxg0an0vgo4cF5VOn9eD1rH5V6Q9965FYbdtiuqSR48IFpz6vfoaofmGhh6AI0QsYiifzl3rpotjxgeTDmUp4Oumvtc0GYwOsLPsrKAFsx3dUCEsWMfECTE1SZzgP2tPsjudVWarCh0Dvp8Z4dqnRudR2P6lqMtx3jIoWduJhzLOtTpXmI0hWqVeubhiVob26URN4+lZ1mzI0pd6CVg0Y5Pf4CwB3VVgc279yBim3629mjxF13Y0gdrARthvx91s2J0hNIEgA7OEQSeFoYXWuehuzndLure25m0VhH4DVSy2/LxYZy9IcR70SEgcM+Mt9GXpZkHQN/oysEHcXimiagdMbmKFAw5jG14PPauXlaDP2RAHOVGYCLRA9SxYnEHEu1wryAVo12DALroIC3hCA/ydYzC5yPUBwyrrcttgql5bLJwdWmKTkvbfCuUyZFcc9AynQvWmmSzW7YwzjATFUsx/+xOKFc3BcvbGpUcQmw+0FH3pdL70dzrPnZCTYgBlenWtQ/Txn4S3pD5NBwEK7YqhwZxzFG1CxcKEQZVBhCGVuqLVzJCPDq5z3bninzLWyN5MMzY+PBt9cf6ejlCE3B3NimFjz+AwBBjibUNj1X2yoB6BgSn8dBG5YqXs7SX7
 YoNFrWFt
 EfXaRPZiy/Q4wNrZsYGELpuejpVJEgXtsWWW11w0FQsNpgVKQfY/o+htIjWnbXFB/8t6p7gYBcdKbxVwXr3eYbi37ls5Wv3BnoykigbFK9fuUhYDPyacnS24LMisHCMjbyKnf/dfYfYs8ZWTlpaLi7gzGG6OvUh3fjeltbbg4xu2eKM2q/64IOrAUc1RijAeq6xP3Zb5lPwtRZis7TEuKH/PpmS3zFq9jwYlmXe2/0ynz8lysTvVad3kO5bDcpwgkutK55uUKW6kqA0FvUJmpwQzMGpYz85ydntGiTm0fnNC1mCTT44XCF1jtFsBkwFrgh+oo+Ju7cu6EbaIP64IqGZlzRBdzBR2xZMgpZLbpCFdEhcIejZ+pv0RusatmbwuUTk9mkbSMJaOen3w0bJi2bfHCkyGSQ9/gNuZyrJjvB7SFKNGVt1tIZoC6CtvANCeX3kwI4Vx/ToWPeqYao8Bo5kajuCHwclA9o0kLT6LSke//ce2zisQI1MthVPHPdfVTEVUC9aY4GMxWqml6b0oomWbkVNg9CJqGpVoqsIU9kS4NowFwW+VqcPzHrw4pP93kwBuLQJebMxCURIg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

free_vmemmap_page() has a single caller. Open-code it in
free_vmemmap_page_list() and remove the helper.

No functional change.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4ed2db189f59..7ede6b6fb4eb 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -172,30 +172,19 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 	return 0;
 }
 
-/*
- * Free a vmemmap page. A vmemmap page can be allocated from the memblock
- * allocator or buddy allocator. If the PG_reserved flag is set, it means
- * that it allocated from the memblock allocator, just free it via the
- * free_reserved_page(). Otherwise, use __free_page().
- */
-static inline void free_vmemmap_page(struct page *page)
-{
-	if (PageReserved(page)) {
-		memmap_boot_pages_add(-1);
-		free_reserved_page(page);
-	} else {
-		memmap_pages_add(-1);
-		__free_page(page);
-	}
-}
-
-/* Free a list of the vmemmap pages */
 static void free_vmemmap_page_list(struct list_head *list)
 {
 	struct page *page, *next;
 
-	list_for_each_entry_safe(page, next, list, lru)
-		free_vmemmap_page(page);
+	list_for_each_entry_safe(page, next, list, lru) {
+		if (PageReserved(page)) {
+			memmap_boot_pages_add(-1);
+			free_reserved_page(page);
+		} else {
+			memmap_pages_add(-1);
+			__free_page(page);
+		}
+	}
 }
 
 static int alloc_vmemmap_page_list(struct list_head *head,
-- 
2.54.0


