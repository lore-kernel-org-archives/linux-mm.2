Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B1FC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736EB6B00A5; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0AF6B00AA; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E5F6B00A9; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 214C26B00A7
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA570A023A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:07 +0000 (UTC)
X-FDA: 85126186614.01.372F478
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6449BC000B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Y6Lx/Go3";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4q5Fof+ukHytC/x5b+k7VwkCJq156UwS0JZy64G2so=;
	b=W9rpmy4hxPaO8HB/bhEGhidr10ycRzKrZtMUkd2ZUyyZ1F2pQuQiEY145rCq8DnjlS+PQR
	KR2n9DQ7ebW8gF9UmJopiEaIcaJUjxo6n20jj6Zy6avwrrZjp9Fy304jltwsMK8ga3AXwK
	B0HClnMela6/6OhLPkckfxWYpNlmJQ0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Y6Lx/Go3";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338685;
	b=1N7DCoRtExJLMmU049hq7ZVmmVE1bz16sRrY64zIaDajaWHv2C4kHdtL8vkR/3zbhgq58P
	bmFtjnam7c312NO6cqSjrsSaeUaV91bqkIm8RlKZwR0XACZeiLsHz8jhETuy7G3iwGB6b7
	MNtE6gWFpO3V7ysnn/9xcM2YN2GMORU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L4q5Fof+ukHytC/x5b+k7VwkCJq156UwS0JZy64G2so=;
	b=Y6Lx/Go3uXJFHlGN9W7O7geOQiV3ZtoClbY3QnisAOqubuKPho1TExjfYGpDwkezDhhAXk
	TObWUXKOfgDlirPP3XESDpgrvTyBmjnZp02sItTOMLggxcoIPOV8iOnAMbjQBk+p329vOo
	E9TfYHbp3BEJ7Fd8axXGx36obFy8Mow=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-ymx7iVDYNs2z9cMZzrUAsg-1; Fri, 21 Aug 2026 14:58:03 -0400
X-MC-Unique: ymx7iVDYNs2z9cMZzrUAsg-1
X-Mimecast-MFC-AGG-ID: ymx7iVDYNs2z9cMZzrUAsg_1787338683
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90a602a4e6fso24964686d6.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338683; x=1787943483;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L4q5Fof+ukHytC/x5b+k7VwkCJq156UwS0JZy64G2so=;
        b=Tj+tTxus/KBo+BLTArby+s97Z/SpXOelY8SJGq4GiIDQZbzK80lffB/29bMuuB+xI8
         NHSp0evkciB5L3XrRADX4b8dq0pG5rw7wiIeb9g16OszUzt90Uv4f06ZFII0/eaHHwfG
         P9LtRgnJZKJ/SRyMcbjpjec+tDgs3DMni0jl8V9ckKHjFlSr1/kkClcwjkw1TVHGYqIa
         vqZv5SH6Dqmp5OsflRJVwhqvptZzYmx6V+v2D8a8fu9q0qLAJKmzuawGeq4k1UqfFpIc
         S2/HTVoaRu0v4VTJ/epBt95U/H4NadR3oX2EhQ0KlbmKDWJK6s+kIVeZVL0S91EidA8u
         OPhQ==
X-Gm-Message-State: AFuF++lDjECmbeTfoed8QuiNDcCzl8OymE5sjNvuLw4I4P8xRF7+ZbyB
	72Zq/09b/q4YGdq+eIbLtZNmdZadk3w8RVCP5LdEkSo2kd21khZa2hhWaheYVN16flL3VH8iz4u
	fVSFZg4slNmGfkAg9aQ0PJ00DAwkklw+90XC+BMT+bWSSd9DVCBO4
X-Gm-Gg: AR+sD12iAWtVRJn5T4C8TLs7bIwQzAg9nodUZDX6QFkjzDLHAQb05WcRB2o02vkqjID
	0yHB8ZfFQohH9QwObezCsFENsK5VB3Cr+ryELzM6jNGMeaYUG3vA/DDfwJXIhqsnmQ8SxOTq9kx
	mLWkf5IjUGEyu1b3MqgdVIff+6gIseogwmha1yyYAJy60XfT9p8BWwIBti+pceenFSieYIhBap4
	rQIbWQDtlstO5rBCETdMAI8pUrZo3Irg3pDMdcX5MTWdOqE951owA+cyLX1cr1wUBvnMPdo3QrA
	Z8/b92thq9bXKAc4NscyzJltMTiJl1GMnGAAJ7WKZCb/uuHFigRpUxQ5/15MSrdBvmo3YDQ+6EZ
	wyOFgNsziV/eQg4jffCYMjEUs51sYNLBJQzbk+DFe8v+e
X-Received: by 2002:ad4:5d67:0:b0:8f7:43f4:fe8d with SMTP id 6a1803df08f44-90c8fa5ed5emr5634166d6.29.1787338683083;
        Fri, 21 Aug 2026 11:58:03 -0700 (PDT)
X-Received: by 2002:ad4:5d67:0:b0:8f7:43f4:fe8d with SMTP id 6a1803df08f44-90c8fa5ed5emr5633776d6.29.1787338682532;
        Fri, 21 Aug 2026 11:58:02 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2b4ad5sm69468316d6.42.2026.08.21.11.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:01 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:57 -0400
Subject: [PATCH 05/11] mm/cma: charge cma allocation to memcg per area
 counters
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-5-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Zg32QX9sxR5otvCINrpG0TFfhj3jboN1UsushWCKrMU_1787338683
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: a8brtnhfxez4ddobmgexhqja8k6opym7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6449BC000B
X-HE-Tag: 1787338685-538786
X-HE-Meta: U2FsdGVkX1/fPsiOJl++L0GUXtJhfC4nfeN9QJCzOOpqCNM2Au48kfkv+iU0hHbaNuwbKKgTl+nlVDdfm7FP9OxuyQA9njas8Qp7nsY5824y+miDyTaXq9ekXqEG30RqRPZoAQNwCorIxcZPfIXXIiO8CcrKibPEc2+gv4+KqsCOhXZKYLpWiTqQuQ8dNXhyspedm/OMP+TirsTkU3i6aUHL3knP4GpTFrkm3WRm6FCq9VVc0SyAMV1lQDj2rP6D233AYPsA1AQ0T/znZRBKxdBj3HbLCnyrAQXFGlUD8JzEWS8kr8J0e1I7PUUda2r/ppXRHWBdq3qnlZbZngsvKv5kl9wP8wK/nd/rYNoOccOJKJHxvStX2iYBq/q8tKGi+TOIc+Z8HpEsdQo19fn0wo6nbNhFC2nrG5dx/P3A4kSDJloU/fvA+bCCNG99P11q9fxUY7B3tQxoHKpTK0KOZgujZRWWRQCTdEJ+xYOY8NfaoYSNqq7eFN7Z1tMOgb4zDntVbe2ombONAFPJQvkpT/yoaOu+RGFiBIhIzVRU8tgLNIvynt6vJc5dqMsELH5QiAKQLXjdO3UEmftl7iByrbhjFUQQSRd7alQmZD5MQui+zvFB68KmuC7TdGBFQFcGW2+LN0d+/9CoagAsrM61pKLu381h9a6pHcbSdXVJ7W4Qpxt3m6tL5Zm+5aYxpTD3JWGchT2kkGwoifE6geaSHPtf7O6YHRVGbaZUIRv1DFs8BhBxTTe9XkHE0HjMbKjFxil06XnXkJpXJvZeXiXnnmHv4Suy0too8bbPvguDLnzBdw2RMiFWWtg34c3soVMKfFIeFzE6IEPMp5K7W3AqgG0RW2l9YYwsmoENZgIXwVnOheENEW2ek+uJlvHRYfN83BVMSj+lkp9oez+b9/mT1G0yzvRzqgeudWPAWY1q3u3wsZGR2RHqBfa/jKhnflaWW1KuLrqf3ga0wtzWPHM
 XWKbhkke
 TDobnY0s1pTjkIz0m2Qg33xf1bW7Vwn+oQ5Lp5o+3BONvZugDzvSU3qHh2Wb7xof2EGCsuLDwfawVnNQq9T8TkRva528HSqBDnfl9BCsxzXQ0/5n6wjgHgyegOR1fXTlRZDA15mHniXzXf0MIlRDrDpfO4tYuBC9rkf9k4HWFiGsBsMAfZF8IkSAnngdCgwJYXCSkZ0QTQAv0VVXHtnXllCFUhtu5IXg/eeZ+vlzrnN5p3ZAUeOQiR3/FVTbDJAnOi6R0WiDKpyU68AbKERFJyQUvTdHnNW84HQXk7k9N0D/VAJ/C6oDEeqR6vjvv6X6JxfMWcOJEFHjszZwCggozyShdAGBEpDYV9OtMxQLQMhHr8jI7sSzYS6YXVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hook mem_cgroup_charge_cma() and mem_cgroup_uncharge_cma() into the CMA
alloc/release paths.

In __cma_alloc_frozen(), charge the pages to the current task's cgroup
if the allocation succeeds. Should charging fail (e.g, reaches a limit),
release the pages. Uncharge in __cma_release_frozen().

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 mm/cma.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 03f98f6d45a5..03eb3acbd3c7 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -904,6 +904,12 @@ static struct page *__cma_alloc_frozen(struct cma *cma,
 		cma_debug_show_areas(cma);
 	}
 
+	if (page && mem_cgroup_charge_cma(page, count, cma)) {
+		free_contig_frozen_range(page_to_pfn(page), count);
+		cma_clear_bitmap(cma, &cma->ranges[r], page_to_pfn(page), count);
+		page = NULL;
+	}
+
 	pr_debug("%s(): returned %p\n", __func__, page);
 	trace_cma_alloc_finish(name, page ? page_to_pfn(page) : 0,
 			       page, count, align, ret);
@@ -997,6 +1003,7 @@ static void __cma_release_frozen(struct cma *cma, struct cma_memrange *cmr,
 
 	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
+	mem_cgroup_uncharge_cma(pages, count, cma);
 	free_contig_frozen_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);

-- 
2.53.0


