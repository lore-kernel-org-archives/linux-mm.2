Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A4EFCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 23:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41928E000D; Tue,  9 Sep 2025 19:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4E08E0001; Tue,  9 Sep 2025 19:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A916E8E000D; Tue,  9 Sep 2025 19:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 922018E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:34:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 094C859F2C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:34:23 +0000 (UTC)
X-FDA: 83871318006.15.312A3CC
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id 38D6A4000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:34:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4phQ6+y2;
	spf=pass (imf27.hostedemail.com: domain of 3e7nAaAYKCD4xzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3e7nAaAYKCD4xzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757460861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9D+kUp+8/PWIFjKllG6CENhJfl0f54OgddsYmF4lYnY=;
	b=BNnB1urfAKUnhquKPV1UN1IUDUekstsq91WYqk3NURINK4sj/CtILpRpHEau4Wgp4AaV5w
	mTDBU4cAeG/h4pGTlcNwpzr3Bt4ORLlcDiippnQVEaETgFoW+lZ0ZUcY6/ugx0+4ZkJk5v
	DCTGJe+TJZwXA5gUQlexXN5c0siZ7D8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757460861; a=rsa-sha256;
	cv=none;
	b=zmcXUdQgPWct8I64SN9MqnrWT/NIOh1YELpPBh9WBmUquO4ATPCZGScZ9kMKpnqC7LYZf9
	OjHwUWdmSUsAheolb+KJTWpl6a7sCMBZLoQSEKaCde2imtJdcdjbOzU8D6P2Qog8P4u+V+
	AhVmg5Xpm4EErO3CKEi3CZb2VPEt874=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4phQ6+y2;
	spf=pass (imf27.hostedemail.com: domain of 3e7nAaAYKCD4xzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3e7nAaAYKCD4xzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77253535b2cso5996649b3a.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 16:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757460860; x=1758065660; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9D+kUp+8/PWIFjKllG6CENhJfl0f54OgddsYmF4lYnY=;
        b=4phQ6+y2vyxZEdwj4vsIGMKoYILwlP7f0ZrhB3Fc22gvss2vDS0340IjbmUwbLWL/v
         Vrj7RE3D+mCpmOczUoncMdLuX1WMWMRcK+ou78qGQHJ165skRtvj84OVFS7Rg7+9CeVx
         AKgKdRM8rZOysZUaqVnLUSwF0rciY1XS7BaIDu2tYE0iEnJd3PyBWHJrJ1f5r2VgplRr
         ZK3nALvRtANgCrHQnXlCfJPIYfw/MslOZVccziMQz2rJ8fI8w0mGWJ7bKNXnLolF0J9Q
         NGAtguPgSGmVxT23my0DqR5MDpHEZmeRJNyqbu53h4KrgIRdRlVt8YUS+CHEC75IO7U3
         5+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757460860; x=1758065660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9D+kUp+8/PWIFjKllG6CENhJfl0f54OgddsYmF4lYnY=;
        b=XwhT0y4s/vxWd+3xotmO9O/QKXzO0Xry+ka7SkawjevTDWHereyO6TKEm2hq+WdLDP
         kGNyjBZWR04CpHaoKZCcJuMi0QaXtY/JYkpbxg7RsvTKZJPh/ZYYqOxOiAC9maaZc3Kf
         O4pLqoSWvPG02wclr1S8fZdIHfhO+VlKAUtT58zsdBUX8kpbjruvHFjCqzuqLOcMr3qq
         AeJWQa5l78y+YXTOIPbWId7KXRpL0zpmIC1I7MUd2Fn3paiwk0/+r/kX4pwUw4I+X/L4
         8sU9FZAoqoEt6F3WVBBlfBFoYPmaNLBJ9CoaLKf4T4lvG+NBCmIS7f/2Iv2k0kkoWOBV
         jzOA==
X-Forwarded-Encrypted: i=1; AJvYcCUmFWGRYnL6znh4XFPawRi5pB9DLN921lHOOFgY5V6ob2piw2sxHi/sFKWUCoATLNwqwEruGI3VVA==@kvack.org
X-Gm-Message-State: AOJu0YzoktcUkV1UF+s6eBMVrGJtm7YBxrk26kWRNDGiMUhozcQjIxti
	fIXlOnzli1fPm2DRVnWEAm9vRdVzpAAE2yIM8WbEbxqCx4QzCbcByyiY5f+7i+o6mLK6rA+9t80
	boAKZSw==
X-Google-Smtp-Source: AGHT+IH21M6CEVT6I4cbVbLFhLsLvsvyph9LaEsNMJBlcaaK/bkq0Ym1zULWMNoZDsLFG63V/okgQHCwDiw=
X-Received: from pfbcj20.prod.google.com ([2002:a05:6a00:2994:b0:772:701:dfa4])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:14c2:b0:772:80d3:b684
 with SMTP id d2e1a72fcca58-7742de925bemr16942717b3a.22.1757460859886; Tue, 09
 Sep 2025 16:34:19 -0700 (PDT)
Date: Tue,  9 Sep 2025 16:34:09 -0700
In-Reply-To: <20250909233409.1013367-1-surenb@google.com>
Mime-Version: 1.0
References: <20250909233409.1013367-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909233409.1013367-4-surenb@google.com>
Subject: [PATCH 3/3] alloc_tag: avoid warnings when freeing non-compound
 "tail" pages
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38D6A4000C
X-Stat-Signature: xrhwz31sudwkxisxy4hgfdmuukhqf5dp
X-Rspam-User: 
X-HE-Tag: 1757460861-321348
X-HE-Meta: U2FsdGVkX1/+Ws6UUSVs5onzzm8ONL1VaCw3LdTx7Td0wIuUEZViLoYs8LyKFupgoIGcNubmjKNtItZH2NvM0hMIbsfkK+g6YtXH0Rt2YCXLqvWgNO2qXZdY+A1JkNYECiG6bdZCPJOvQqbtEfJX9+l9GiiWcLqK3DgrlCSDU0EKJ37TTXQNhHayOlJihyfKgXPBTxxMNk1kFuQglatSHUchCwLku57kjqqffJD3L4Ixs/to6ave5YUvzsMoY6q4L2wOtqk6qMOhF8x8tcMQGgLK8JhktOvTkgCbH/mlN5mK9mmcKYRzH3lFxqYpwUZg1gXQyCOPHcCTvhKvVuSrGvpFDPBqMvtLvAUQ1W6fkmwb/SCe0jFriZluVfu6JsgLMBqZrcJUrJKLyuQscTYw67Sxy7chtgZurDyAGGNfJuz9GKMWkAc3BLBRPPybvij8T2Z/BI8VnNF1f+0QcPCBDv6eYZxdJw67H6ARjRPGf3GcjjxXtKSQpnUTkNneZHm+UUpvKAI2559W0wBozQRHgfJrYxhZcUNESOYKndoaZW5pXoajqdpZUrsrb/HbmNjI3Hn7sm4bxKhJreH03GpQxxeRvn+eyL0H5dBBQ6q5QA3xgPH1CfV/yUD7SsEFOC1diAnt61WPdcvVJDJpCzO385hppE6bemxnKicA/7FL2YsfRrnMi65FhYX4A8ZFkXwNa5wxJ/c0st6oDRUCE/368E5vDy7VrRKXH6HdvmkbVkYlWEp/5RO+zxx2cuVji8En5PLHcPlhFS+MmrzjXdy85bxXkSdNvhzWg+G80wjq5ufbENixlQ/jqFMVPfTqmL7PRDN8IisK8M+/dHQkvT982NJkRtEBVnUY9PDCyS2PM4nh93Rjgepv3vE2awLUqq6qitwiaXu+cyo+PogtYC2l2JuM/MlP8mk9ApOnCciO9vcYSBAcnkIJmTvbhwa4B8iq7HAIOhCw/d5Z/ZpRvhx
 a1tEWUlC
 Zbw1dkZSz4+5+dySOyVZtW9otUR0r9Ff2No3CYKUqAgdO+GB5+WqPewd1aAhnseXmQgb4sbB6sc2Z0S+Fu5Pn8hLoQkpcLsjVmHPG7KGI+cLsIYg5xVbkXx1bwQu5pCGz0GsgK6rZVHtpEYdzu4ABiVgs5+/jY8WvSCKxPZAxHxF0UgzgKkt6FjR+T2r9sWrVDgOnOpgB/c3b/yMVUnX1QyE0TBrW7haqP58cNQ5XHimHmicceYoScFio6qPfMeYqEPLUfVjc5iBAYtEOZjM5UetxS1J587Js9n2xQDQJrLe96cno7rmN/ww3qYZDA1TrKtLTkhsqhzNAKZD72+uUmlHssjnlI788f/i+rZ8vMNwig6+mAAI8W4CcV2dqOK9wH+vqCM0H6ud1xK0a0fXtc1eGW1y9F0+KNCJGoDRqVcUo+VG1oYcHSMu2SaEdq2AbdPSGAvkCwUkze2a/VIl2i5O/eOoq3LrAoglQC667FFfV5Sxya+/ztI7DoBtIzGcFkOconXW4SfZdiScINWfIxfK6P39Vq3yjXcBgVXxClekfp1aLK2Aw5QT8PRJBQP6K5oIsvaMh/hVjcJBod1oPguYl5cjXTW6EjGXrpXbksXAdLQPkMvQgUXSBgDlEHD/pJ4+u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When freeing "tail" pages of a non-compount high-order page, we properly
subtract the allocation tag counters, however later when these pages are
released, alloc_tag_sub() will issue warnings because tags for these pages
are NULL.
This issue was originally anticipated by Vlastimil in his review [1] and
then recently reported by David.
Prevent warnings by marking the tags empty.

[1] https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b8@suse.cz/

Suggested-by: David Wang <00107082@163.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/page_alloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1760346bbd24..d21a411e807e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5240,9 +5240,16 @@ static void ___free_pages(struct page *page, unsigned int order,
 		__free_frozen_pages(page, order, fpi_flags);
 	else if (!head) {
 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
-		while (order-- > 0)
+		while (order-- > 0) {
+			/*
+			 * The "tail" pages of this non-compound high-order
+			 * page will have no code tags, so to avoid warnings
+			 * mark them as empty.
+			 */
+			clear_page_tag_ref(page + (1 << order));
 			__free_frozen_pages(page + (1 << order), order,
 					    fpi_flags);
+		}
 	}
 }
 
-- 
2.51.0.384.g4c02a37b29-goog


