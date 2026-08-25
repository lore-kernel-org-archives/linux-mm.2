Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F6A7C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 04:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EDF26B0096; Tue, 25 Aug 2026 00:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C60F6B0099; Tue, 25 Aug 2026 00:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78DF86B009B; Tue, 25 Aug 2026 00:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 578C66B0096
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:39:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4170160324
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:39:20 +0000 (UTC)
X-FDA: 85138537680.29.CF4F0E8
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id D77CD180008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:39:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FF6H2W6C;
	spf=pass (imf16.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787632758;
	b=wBGfbkxaAjI5dgy8IJw74ViYnY3jEXTXDp+HBlll0I9IieHkUiq1LELTpBOCAh3DKlhAoI
	IbSCY2MSENtOLtTGB3ZeNx+LGg4LsQQuF9pxHEzGHvPelEhfpJYwaWwWoOrWt9ST7MJrDo
	pYWT3EAQkwkkTw277v/LB1VA05n0JBs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FF6H2W6C;
	spf=pass (imf16.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787632758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgDt7RRYHrlBCjbTUkuVrBzfVypoO7XYvJ7qcxqZml0=;
	b=QypoS2j4lwXNWs2ZIifuDEQ0g5cSclNd92EKH1ahrzO98bStgcLkXFsVMkgz8qEmQRDkUb
	H7bKyg2I4n6TBml+XHP6eTnaDmFWZch7jD4F5XBtTfAkAyNd9w44aG7P4ZpAgGi8B/j6b3
	pk8+XFNxPaCuhfFXrlnL98TKMJPGQ9o=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cab973140bso54963355ad.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787632758; x=1788237558; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JgDt7RRYHrlBCjbTUkuVrBzfVypoO7XYvJ7qcxqZml0=;
        b=FF6H2W6CFcTgtD6UyoymLcRi3KQapz2YHU+6sez/cvjbXuqka3/idoVGxQmM0jdKbc
         sCmpVLs33aqbeaLEOvMHk2a4rt3SrGQSsD0DV47RTF614faS7XXWNrZYJK4X+jKmpCRb
         vDSnStW0xjAbN9RA7iqtmnUt9mppuDhJvZX4Ra1fdDm1Cyb9BquQl4gJ/CFfHSQUDqCG
         ZZ+WzSu8kliR9v/4lkaHV1lbE4V6F4vS91qhsndG/C52ZJ42ZNoAoxeqPb0fWoR3odbH
         i9PkpeXvPvoIF3QcCWJc8WGX5tlEe2ExFeBdHkkOwXcJNZjXlf8NuR4mGtW0vFyWpZbU
         Tm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787632758; x=1788237558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JgDt7RRYHrlBCjbTUkuVrBzfVypoO7XYvJ7qcxqZml0=;
        b=FohVXeAGOE2u9ll1BFgO1suB89dIq5GQgH3SeN6zJSSoi8D8o8XYkoVrptEZ5qS1P/
         zmBg9aXUGzzo6nfndL/+MISbeeV4/kX7uoBeyUsuK8Y8wuW34P6Gv6GPEVBrSkG22t5Z
         u1MWr5+PQp3PCDjO0bHbWMAcC56tyLtMAbyAmWqvU+7+fQCa2uyztpVtFg5fuGgBb+Ti
         fHwqYfG9lMkAJtVxFi10GVVxYF3KjkZlNmQSvWiyapMzK2ufLqb0/ZYfxWHLB9UGYU8C
         BGrh0mjfNWIIu8JLqNdXAlFmJy8//1jNl7cYUHXkMXIwbtswhxiqeCPWWWV4/mFfrFHl
         2tWg==
X-Forwarded-Encrypted: i=1; AHgh+RpKe8BdL9HsQUfffz+OCUbHbW6bhRDpHnMg54P7PMYlC8ugQsBh2jkg487Y5MZkooZYlkiC0K0A5A==@kvack.org
X-Gm-Message-State: AFuF++l2KWWdJSu6OFDlDcR0FCnnQuBoDlTN4CSQet6IVzGq3CjP8M8d
	nSnvJF5jNsymC24ZhBbjt0sUgAK89oJt4wGRGo6IWZqRecY3vA+loh7k
X-Gm-Gg: AR+sD107aIocUxz+bRBJLuR27xLFuFMRZ0uL0+W+kRB9+tRgeKK0jQHDxF72BTy4V9u
	EIht33Am9v/MIzxj5YI/ZvUqjVvidQfkyW+ljB2ljImoVnKoGkrUW5vw5Biv+mduq7aHBo787cL
	MNqXz39hO98/rmyD2FHFbZzmW5XTDnPiCTWHROlv7Vm7xr+0AFHHUfuZPifv90nDQeQKwlm3dMY
	n12tEBKJup5NCzm5l93nzUPWb+mwzmQcmyPrSQXvyLX2kWPgVY6SDfJQFF9L1H4ywWiORV99flt
	Is/+Mn1RkOlYS4JXeRY2N8eb/EwiTpB9IyEk3i+jEtTBoBufibm1CL3LBl5nIL6DzjPn96abUW2
	fqRqeOmjVTNQeesfFosFnBFizo6GCbif2AZRVjd6BfSSBEqp955Q8o3yY5bNnJ/41jTnlKMJ4a8
	Rcmsfc/vVfzL3YjVtEIeX16L7TJnUKAXUd4v2Qbh4UlRSMM8/VEU+p+r+4tNtWqzRSX62v4V1+6
	kXA9w==
X-Received: by 2002:a17:903:2311:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2d670ce466dmr376747535ad.14.1787632757691;
        Mon, 24 Aug 2026 21:39:17 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d6f726e222sm502155ad.19.2026.08.24.21.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 21:39:17 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH 2/4] mm: compaction: skip isolating large folios that satisfy the mTHP order
Date: Tue, 25 Aug 2026 12:38:31 +0800
Message-Id: <20260825043833.2659350-3-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
References: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D77CD180008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kjokni4jaj1qa4kaozsqrqwtxgb4utfy
X-HE-Tag: 1787632758-653592
X-HE-Meta: U2FsdGVkX1/PIJR1MnQRzjDtCw2Z4rKzp6a0VsR45hp91yxT6lcp7mTYBWUfcIxXEi65gYqLuBfJ6mLiPardBexulEQVIW3KvgiJzwfvHG3QT06JIWgabNBYnD/G6wzmFp8C+eV++dvzy1BHJ4BTnROKNf4NOpCX5wDNgvsO8/PByzKFpO3JshYF4k9g+KhgOCv8SvSX7+/wI0cH8qNd3Z4ZBqDhHZc7VDqLYSPx0K2BslOAcIG5lX0KvbZtlhYtVyyr7nb5abQ2QXzV1ulObzrUwteqhZCtCTw2A6NSlqBLMlAfeQ5I5NkA7eDB2xNgtXLoxsd3xO6wppObvuxBUoHDLH2SU1HynLVEfi+OK5YG+uLJugpmCVDIJVnLzo6aIjf+ZESJVH0OY5qaNl0P3VMbowyy/cp6c4cO4YyTTBl7uWvxs9vNjpv0KL+xRso6653xagsxxFK/ieyQXv2VEa3w0Nf2kN0Vt7usEPK5GnQ5XiGbZg6IdZDBIIT/ov0TqloYTp68WkJTQYTAZw79cYHe0fo9lMzvsTP8XSHBYXiU8GzA6WfRfkbSNobpEleQNO3koNbjc17VYCHkcGEWMcalwv6gvT1dCd3ejWeCR9PtiIPmk1bbKhpseibBCFOhm8v7UsjFPu37BVn33pqNSeXSPHXMyrEBqHVn6lP1kNIdD43Ui+bGajDXCBNOVG9uBlIrJrOmxnIoU6xXdx2apBo7CzuyvOIGGVZrXyt7OBribr3DW/f9qvh7gYwkuYfiC8P3fiRFt88MOJQJANjKBD5dsxdAWCpqoH++Yq191ixKvlb6HRgXmVg0qJOPlVu7k8hVDJMOTC0rO62JViKSlrvZbSCUfH2lwCqtQuqGKiYGXbo/Bc9ce0e1Ja7CPv0rtFAnEuApDhTdp8kh10GDDbM5TSD06/8Eo9lE8gwFdVMY9t8B1LxuV/VtkmrokQYDZhM8PHUHY+Po7fQVp+Q
 SPH7PzwM
 b+WNyVYNfVXHpXDOmpEhHPlrbJ7WNg25MvjPlfRB3XDTWpevgQ0OMprf2UpOALxjstdG9yRMHYslp9wPOWHzZc419deGkVi6tSIfreNOhjdWpnGvubveSp8ZQHHtK6vSb+mdPENgZM50UDw4YpYPucD4bfTQKDokH8P+EVW5x0IGMWGvIXqOMjtAQfhvDsQvPrxIDQbpTdBigFrhKMeZ+4D0Y/WcVfCIX1OUe/PjVkT8P4oytEPwY7dyTjBpLVXpjV4ZYHFPgpfwWo8Q8TxD0Rz4sl+KNVzuYz9PeIDfALmKOm3oIBKHjFd9VTOY8D2TkcpOzpGTHhcpQHW0zlzN1rXiILQcImLFbYbGM1uOE7NTAdwN1qoaSQS2/Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When proactive compaction is triggered via compact_memory and mTHP
always-enabled orders are configured, skip isolating folios whose order
is >= the minimum always-enabled mTHP order. These folios already satisfy
mTHP allocation requirements and migrating them is unnecessary overhead.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/compaction.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index a4f87232ad80..a15ed2576562 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -837,6 +837,12 @@ static bool skip_isolation_on_order(int order, int target_order)
 	 */
 	if (!is_via_compact_memory(target_order) && order >= target_order)
 		return true;
+
+	/* We are compacting for multi-size THP allocation */
+	if (is_via_compact_memory(target_order) && order >= compact_hpage_order() &&
+	    READ_ONCE(huge_anon_orders_always))
+		return true;
+
 	/*
 	 * We limit memory compaction to pageblocks and won't try
 	 * creating free blocks of memory that are larger than that.
-- 
2.34.1


