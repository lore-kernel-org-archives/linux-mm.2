Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E3E6C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE136B0099; Thu,  9 Jul 2026 10:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E346B009D; Thu,  9 Jul 2026 10:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75336B009E; Thu,  9 Jul 2026 10:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8196B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:51:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EDC21201CE
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:51:49 +0000 (UTC)
X-FDA: 84969527538.13.A33E556
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 44BCC20006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:51:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QJYYQbXP;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783608707;
	b=5BzCwzqjFlEkf/IDjjRsMzkmHiPszp9oWXjaqQ3rKS6D4k6xxWZDlOODLOaeXQqn1sNaq5
	c/5PaSm1Qh3E8jaGzHpHFW1H1Me2zRrsYVqbhlU1TvkK1kxX3dthoMdL7VyDD5j6wmIYul
	Mof5vllC48zNopswGeNmvgpwb3V4MnQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QJYYQbXP;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783608707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZxx8R8fiqL7iH7Cr5ccFQZpVZE6wUlCcBNvGW/3Kq4=;
	b=KAq+tdGf3netJjjtx37yIvUOXy+zIAAjKyMw691LVFDir65sRy2nf4FGinQOS8RuG+9qjX
	z48Onm078MlctZfqUS/NVUk41MRLE4LzNbU6MArVVLTnmNYlXlsXy6ESYN8GcBP6er5a16
	tMTKzXHJ3aVsnr7cptxykfRV9f197M4=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38115bbb83dso246163a91.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 07:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783608706; x=1784213506; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HZxx8R8fiqL7iH7Cr5ccFQZpVZE6wUlCcBNvGW/3Kq4=;
        b=QJYYQbXPHxb5lyt0vehOlQJwlHQnoy+uGeNwa78GiSnYOyxkvklUq+MY9CT6OaIy8J
         /sbgwdfLB+35VVYEWb2DEQhgDwgbwHEMWoWTvzjBoJjAy4GrcANIIgtbjIXFzSw6ENZv
         sYzQ5dc0+q3ElmKPjKD/ix4qLS8gdtWSHwIOtPl6FynNxY4b+vQMtnysKLTYxh0N7VN4
         rrkbOHP/mrmvgUnW1IlIKicMFnZnRWPkcBmP+Swmaix5a2uun1AFHgFiztgCPZFoUnbW
         kHn9Pyjsl7qOt5RevGM55UpSBRfdLOTlqaJWY2E0/Qd5+wqQ5WUCRlF6sswZ8w7ibQn7
         a8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783608706; x=1784213506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HZxx8R8fiqL7iH7Cr5ccFQZpVZE6wUlCcBNvGW/3Kq4=;
        b=ET076CBny7X978tpPecrGUE7Vqchuy5HTdag5ZAaSnEcWXS9KgR56RmXbr1Ex1IokQ
         bs5nAXb8au2hjYhEjwNbAw0dVTrpB8PjZbD6vd7Fk35jQHv3415KbDpNUmPVeYytfzgk
         Y1WdbVmueAoPTFeISOk5TyZwmbcgramd8KYbFTTlrYCizGkTCd4SD8DbGw0RfTkzPFqx
         YIFqnaQeLR004nX7YELmQauE6WJpIuDIAsjafysfyj3X68lu6qIh/dKkV6gkH0EUdZAG
         CPC4nqmcZ6+REZwfiLOqsSx6KabnJHSut1h6G80A3JENDIsK8vl0c5K8LFrdI3sOUXyx
         iimw==
X-Forwarded-Encrypted: i=1; AHgh+RrNTJoVw2f/VDbIg242Sef3PX/Gu35eu2IQ1KBNwnvD+MyCMrPvHUIK8jSFAIcSmo+3feiiLSIBqw==@kvack.org
X-Gm-Message-State: AOJu0YyDFH+sVts3kl4eZqxKY5t6ghNC7OG8I/shQHtwumXY9aW7Q+KG
	BX5vqPt8peisir/rmFeY8M9O4utMLzY5WABpuan74lAF+qOZqUbd/V9l
X-Gm-Gg: AfdE7cmvbNzVxC8FZnDxaEBVkrWX9USWgZLe9M1M3L1aK89Pd9oloHgcSFU5rRYCqvM
	CZ6UG6NlbL65b08pX9amIcCqJOB6xq47nbHMXtsZgABGty+HVi6j4R+zIukwdI2ccyqS8/wA7in
	IPm2bRen7yccMR08LeSlOqifrG5ayE0g+TRikAoZwqhdoujhBaM6K+mWcN4xZoWbbD2C+rENzGZ
	KT4WgY/gPba93yG6Gkik9TpmKy9YI6/ftKjJwhwk/19x1IO/DIc00OYht6geo1/viB9MVcGhjiq
	hcbt+EN8y5mFqEzYVnlsnYaaclHDvvO49t6xjmwoS8GhXIzrj3Vt9mmyAOTcw42mrawnEC+6Hzd
	9cpo9sHIk6cvE7X+9d3Qbgyr+c7Dr9o/HihG4V1BVq8C8h69Tl0oRU10/wU0aJz/yLzflFQqne7
	6Mw79rs728CYIjqd318bo54zZJAKxouW+C82lvraRltzIJouLxay60eYj4HxAkV6K1Ck4v/+ZAW
	M8EkRKYQPIA87lnOw==
X-Received: by 2002:a17:90b:58c6:b0:36d:b30b:14ed with SMTP id 98e67ed59e1d1-38a1f1de22amr3604367a91.2.1783608705954;
        Thu, 09 Jul 2026 07:51:45 -0700 (PDT)
Received: from debian.lan ([240e:391:ea3:6910:38e7:894b:82e3:a58b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a57dc5820sm1286917a91.10.2026.07.09.07.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 07:51:45 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v2 1/3] mm: add page_counter_margin()
Date: Thu,  9 Jul 2026 22:51:22 +0800
Message-ID: <20260709145124.764807-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
References: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44BCC20006
X-Stat-Signature: ugu6wpcu565kn46w31fxfsg9zdx9bgwg
X-HE-Tag: 1783608707-89893
X-HE-Meta: U2FsdGVkX1/0ntjcn/Rv+SJNMA4OThq/ucsR8tSDBBu/6pemLJPiispws6VXYp9314CyA9G8RHs7hXhNTFgs4HcEINEfJmDgUcOJcfPMNbtMogEao080hUP1AAf8JjC+S/EyU0VQEupnZlWD6B0pEGT3nVYYVZEY31YVzU3zR8129FF5uoqLqmERfli84i6I8wflksGjIzAsDpl0j+c7LLghQKdl1eoOTqIcwYxZecGYn8ZfbUV0vNFe2NAJN6BgwuXxIZyNeezGsyLFqp5DoSxsTPqFWCJe8F0JfDXGvcrtSCkIUR0RidGOqCC7nr4XijujEw33/l/cY6XIcjwtWA/7eCyZoc5l+ucw9oQ65rHFWc3UUgWJM6NmiZI6LoiXpIjvYZ/ExtC/NpXunbbeCMrFB6Vt1TrRt+xAmtLd2hDzsymj88pSrs6pmhS61FOf7W8GBroR4Z+IosiEqmgrJp4QvMwiKb0RNWgtfKGF+99DUuVCo2Fqg2IgVYJ5hY2PtK1c/aMEUeHVQCvRNR8J5zt9HTEYcIaojErLbIPb1lqr3BXLCm7zGW29FDcpUyGLXnYG24iHje+vq1C5yxG1cni1VY/CXctfX1t0lHHW0R0KdkQ2d/Y6Vy2dxUQbtzdu4fBbs51i1mjgWWlTZfF4uianD30j3iGJEjBkj/1wsO8rSgsFAzHwELtPPOEghsEGfy71N/ruUAmJOJ5MwNdEu28e33q6UOnSaXopnPzCKQEgCYw+LDF8JH/FxeXfUuI+zxnSl82PM43G1HjKa6iUZZ/2jl3OS9M3Pne5l3zWZhRRvrr77vipYflsu2VoLffQ11KR/qYS5HCcJ0HgNw0RjhQb/wewY8YTY98w9+jFSkqSbGcK9yResSWtbEiNeFeKjPyFn7DasCbJIAWUeQSo5Fubc6wxnCDipPnFQ06hljd3DMqSRDR0DMyesaOQA2TIYknAuuUyIRTa0jjsgrL
 yXnq0mdA
 gtBch8iP+wxu+Il8xULstHiap5FWYWcGnPxvofRHatUtk0Km1n5nyAL5q9la4oNJCDuJcea6lpM16mKgQTBOSrwWRpB3beRY+vggf885s1F4d7jzuooliFzRmpaSjPfr2c6b08cWV9G4kJnouuBPjeW8PuBkTXw4b664yq+BeGByBC5l5rG0Ex/AKGDOCIzuh74xV0xr634n5CPfAApJx7YAgVGXZ9RDFglkJUQXEas+65n8cNZDas21FuEvZ7vlPomNsJXDRU7tuUn5iuuCtLnAPdXo0/l1ocUBjjN5WNAdB/rD0OgvDXOuOJeSRlcwZ7jeo82iAMXBToErm+vsh7CQG1xLQYYgMSt6TB2ZFTjZJYTyzMxomVQyaeDEjNtmvC+UJ0ACedXSSI7dXQqm8SMtICoPhzt0CWatVhwvOYKmkBcvw+ccAwMyVTnE9MzwtN+jKSxzOaO1/Rw97H8qizWWn/c4BEaMskgnyW8eNZcyvVUS5i7948qHhcGxUbdOlVTZk75fZveLA2rNnT3nXeqiHfdNNde/WLx/RoMe3CgzKMnlPKnCOTJCU0Zr2RgnPJTnD/tTIJPmac8ABi1/uhIq5kPK0MNC3V3Oq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper to report the minimum remaining chargeable space from a
page counter up to the root of its hierarchy.

This makes the hierarchical margin calculation reusable by callers that
need to know whether a smaller charge could still fit after a larger
charge failed.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/page_counter.h |  1 +
 mm/page_counter.c            | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc87..07b7cb12249c 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -68,6 +68,7 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 	return atomic_long_read(&counter->usage);
 }
 
+long page_counter_margin(struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..6e55c7628025 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -171,6 +171,26 @@ bool page_counter_try_charge(struct page_counter *counter,
 	return false;
 }
 
+/**
+ * page_counter_margin - remaining chargeable pages within hierarchical limits
+ * @counter: counter
+ *
+ * Returns the smallest remaining margin between @counter and the root.
+ */
+long page_counter_margin(struct page_counter *counter)
+{
+	long margin = PAGE_COUNTER_MAX;
+
+	for (; counter; counter = counter->parent) {
+		long limit = READ_ONCE(counter->max);
+		long usage = page_counter_read(counter);
+
+		margin = min(margin, limit - usage);
+	}
+
+	return margin;
+}
+
 /**
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
-- 
2.47.3


