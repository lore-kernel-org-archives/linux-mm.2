Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA0FCCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29BB28E0019; Tue,  7 Oct 2025 08:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FEBD8E0005; Tue,  7 Oct 2025 08:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E878E0019; Tue,  7 Oct 2025 08:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF6E88E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B74558106A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:54 +0000 (UTC)
X-FDA: 83971227228.07.6FBEFEE
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id D6899180006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O2vmk9zc;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KootqZKBoInJ70ZxwqKSLGt1yUrzmx1MeMaiDcSe4Sc=;
	b=hXBMk77wYpMAl+yxywY0H9ZUyilBW6natY9EMo4R9up1QaroeaAQZYQJF55HuxfBfolKGg
	pvqUpit8G/fmSYFu3EVT9UWXW30/oNjFNdLzfVS5f9NZW5U0Jv45/go30KzSMmInGRet47
	9gBUY2UBNBHf+NiqiTPgTnLyFfXD+2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839653; a=rsa-sha256;
	cv=none;
	b=u4pGG6izq8YQQZahoxX0YdwPB1e94I+suI1XNwxQ7aWKT7nx/SUyTKku+K2hxjd1hD4FcI
	gtiDy4S629BY5ihIm1p94Q73mnIGvzLGgKPg+zfyf5AHc9sZcLXzEOH+fLGQaK8bziwkGp
	bMRtfPXySiUdH6KmUnKTiyyAUjyxm1g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O2vmk9zc;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-57bd04f2e84so6992520e87.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839651; x=1760444451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KootqZKBoInJ70ZxwqKSLGt1yUrzmx1MeMaiDcSe4Sc=;
        b=O2vmk9zckyxnRoSXGFQWw4Eqktq6K+T3seUNN37Y/t54wFDl+GM0VeG+V3G+4Eooyk
         luBFbourxQVlQb4hR7XzqKm8dY+LTzYYYQUacEE7AlkD/ygjWdD3DSOYlRH5S+q8Y5Uu
         KznTahUI8sSBGUlssBZL998MuZuG4J/xA4sFM0bXKu+BPO4JBTLAW3b9KxlftX8+7zsN
         P5O8O9ba0kswYQTHDgD+67F0DAxy0XDRoGKNRaUIslvYDmG1cY5e5rGZVaHdjiehduSD
         BfMCdh5Q4uwxNnf2lE2VWeUJgcQB27jU90oOq/yrkE6nNJ45ItJfCZkYYMFOG2hfOAsW
         3ahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839651; x=1760444451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KootqZKBoInJ70ZxwqKSLGt1yUrzmx1MeMaiDcSe4Sc=;
        b=uehYg2XD6/gZ281IQk61+PXQB9BSfXPm7iyEGVpr1dYYcV8ZDJ1a8ZHkX2ymOI0Fo3
         AyX02LPT/PUDWutTHIBYx72VRuZFWD5KOYAJRpQOpxS5N86b0nUG3+RQgZ0mQYmtrxZT
         iVo3DSbNPwZW613WwqKoiDDIXHiZP6uXsuJtSFt1uvYgi/EX9ChAJBkmy7VzlGs7TzzB
         2UuTeHQ+pUTqcoUYP3VQX+w+qY5Gn4eDzIOdUke90OIOgjaaQUYf/AnskdOslJwcfWZ4
         Kmn7T5TP45AnHGzBx3g4tNwvcjFDvC0GJtRD5jNXwYA36qQ3Jc7qZL5pJONTmYny8NIu
         k+fQ==
X-Gm-Message-State: AOJu0YxqG4x6TcQfY5Ti4IzsD+lSLgstYYOaGeWuPcwzf2iL5NSEDXrr
	qaMmIN2kv+dSupg1LesS0fLXrVVIH0bzKmA+3BY+sYzbtKcXCdmLMbxkN2WKAZVv
X-Gm-Gg: ASbGncvGoIOYZnTyj93jH6HIz/MnZKVckiyUsHnM/FofTD/u5WjQAlDhqBMoVuMJRDJ
	hdPMS1V5YTwCiKC/Xdh2We31tNiY0M+T+q23l18LTahDLWmsqm5xOYsDTaWO2N0SfumSqil27O4
	ZGNWSGBsU1tFTp2ecT0mJSx6jJ6LTieNaqUY6n7sBUcEL+5DRoEXyTtW/8UCRMOiYcCrcTP/VtM
	pqiGgwS4ZtIRc3XPAsvJq1l+rOuZuQTzGvLW9dRy7S9hOV073KWv4Q8nJXWiqeZsK+KoHXsr4so
	aAhIB/VdYVIqJGnIe35k03y5VTeomKEd1imNuuG90hKg4hxS1SxbUxFWByFW/yu3F5iBazhThTF
	jmxYgV9CniQ9doyETTSXP/KwdkOnW50z5GvXdsGWE
X-Google-Smtp-Source: AGHT+IFPlX7EPJQfg4e0mUBd4WzqghnQVqlWdKVCToHj5t8/+iKkFTtFbq1tKN4IiRVof3fLjH1x1w==
X-Received: by 2002:a05:6512:230c:b0:56c:386b:9bc with SMTP id 2adb3069b0e04-58cb956bb11mr4722191e87.5.1759839651048;
        Tue, 07 Oct 2025 05:20:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:50 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v4 10/10] mm: kvmalloc: Add non-blocking support for vmalloc
Date: Tue,  7 Oct 2025 14:20:35 +0200
Message-ID: <20251007122035.56347-11-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: bteaedamdqdmc41jiz853ufdo6fa34pt
X-Rspam-User: 
X-Rspamd-Queue-Id: D6899180006
X-HE-Tag: 1759839652-440849
X-HE-Meta: U2FsdGVkX1+/Uoz/Y89sqAl2uil5v62GxY8wpVhNLpHLCIaHigpCcre56a2zwPnmqumw3Bidluawi0NVu/Dx94PXQGaxiFgwR3yhCVNB7Q4HBpc8sJ36k/7/p1g8zfp65v80NV/EYrFXfthnytGWL3e22E99o2EXeYXyMyJWCq/EvkR4AnKzZHpK4fNWhBgxKDeakzzWf/DQ3CDVdESeHdbcG5xOjSQgNkvnXa45PZCNrKVOjP+rndw7oyYEbUCw9oqFIZoECrQu0kHXp3PdFp85u6yBP8ml5QuSyYFG35lN85bf1bBYF9V8pIWyq9SYhRw3cbQm0UZsq7BmU/KQNB4tMz6b9GKRO9V8lWd1Zv5pW0NM84wvRvLhFkvnTN3ptbWQjfOl+jW2s6OZoXoG7h37BZ+o4JpJAdNqxVpLVkdYGG1IkpPt5lkKdihiddEChpNmi4mJdMyNG5b7KOK0FGxYzSLWRS12jIRK21iEhghFEkEvYY8CufAkvLJbJjISCxlmYLbQSvruXrU8YZtmfctS7B7/1gcHZq6YnI1go8FPKWZ0GUSg4MqF5dcXVnh6762jNOjMtHpd1bjtsIkIn7Voy77pWbwaCTM5uMd4XM64B8WfRCb9R/SF6jR/qYsA/EvYGHKJaS+mRw/QAh/bGTyzweRnFxhgLMkbeyCIXXkr8sIBv5WEvFnbhQjP2Qw2JcUBBrTJ2HWOMvoicqPe3pJS6vXun9/MlXBtnfVRcbSRj5xjRdSKegO0wqcF+Ded9VOZs/VZ1YY8v7sqV7wPWpoQhHNIiYxcrDhA9EfUaqTvGpX/tF1MCPs0NCRaiGhzm6DJhijxFgmPGiW3QCtnV9wR39fD6o/eJaaOBpz9r7W4d4uWgzkKMMw55Uc6DgWipxl3FTuU41+oZZkZ5yk9yAuILTF0LDHJwN77zaZd1tlDTVqNkshBZePkPa6uinL+j40obrXScbVBrt92r1a
 ur/0EIxj
 13+Tc7NSrfSQHtsuwtL5e2DNEKexOjXs+5TBlxyBjXssfKdfr13R3sowdwPltyUraYs+nvP2wtygP1HFTKrWj0ppZDMjfXICcXb4fYTCshBZxpPaeDV8CHX6jNEz+I2N39oDWxjwacU5OCFgRB3VpCURvIuNePKe+EpeTlqrA1rS/f4UgufDVHXeU+IIsYcj07n5G8t8tS1R9Z5zs+cE5pq6UEJIoRvAZvC726XUv239zaws2ejvQmWczVtTpi8BTybQIxtBSACltLyMnO37Xafd3/6VdAkzaD+ILzBSVMZq965nAlJSjeTCl5w5MLdB7k71Tzbx5uiBV3IarKc8It/lYgEjFQrEMfarhlz9GYME8xCiQCKmdJtdYXZ9a9Tgq+Ub15SpYuEXKgw5V7oOhET2yavFPLa0vy+dlDQZOAx9U2DSGdJunwKbHQNMtrF9jKWbRGQCNC3QHH2iP0/hROffeyI77yU3FatNwoaElv7nCCVa9p6u2HnDCkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend __kvmalloc_node_noprof() to handle non-blocking GFP flags
(GFP_NOWAIT and GFP_ATOMIC). Previously such flags were rejected,
returning NULL. With this change:

- kvmalloc() can fall back to vmalloc() if non-blocking contexts;
- for non-blocking allocations the VM_ALLOW_HUGE_VMAP option is
  disabled, since the huge mapping path still contains might_sleep();
- documentation update to reflect that GFP_NOWAIT and GFP_ATOMIC
  are now supported.

Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/slub.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 584a5ff1828b..3de0719e24e9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7018,7 +7018,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
  * Uses kmalloc to get the memory but if the allocation fails then falls back
  * to the vmalloc allocator. Use kvfree for freeing the memory.
  *
- * GFP_NOWAIT and GFP_ATOMIC are not supported, neither is the __GFP_NORETRY modifier.
+ * GFP_NOWAIT and GFP_ATOMIC are supported, the __GFP_NORETRY modifier is not.
  * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
  * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
@@ -7027,6 +7027,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
 void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 			     gfp_t flags, int node)
 {
+	bool allow_block;
 	void *ret;
 
 	/*
@@ -7039,16 +7040,22 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
-	/* non-sleeping allocations are not supported by vmalloc */
-	if (!gfpflags_allow_blocking(flags))
-		return NULL;
-
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {
 		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
 		return NULL;
 	}
 
+	/*
+	 * For non-blocking the VM_ALLOW_HUGE_VMAP is not used
+	 * because the huge-mapping path in vmalloc contains at
+	 * least one might_sleep() call.
+	 *
+	 * TODO: Revise huge-mapping path to support non-blocking
+	 * flags.
+	 */
+	allow_block = gfpflags_allow_blocking(flags);
+
 	/*
 	 * kvmalloc() can always use VM_ALLOW_HUGE_VMAP,
 	 * since the callers already cannot assume anything
@@ -7056,7 +7063,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 	 * protection games.
 	 */
 	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
-			flags, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
+			flags, PAGE_KERNEL, allow_block ? VM_ALLOW_HUGE_VMAP:0,
 			node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(__kvmalloc_node_noprof);
-- 
2.47.3


