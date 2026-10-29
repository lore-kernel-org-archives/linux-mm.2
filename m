Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63567606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=HO4txFAe
Received: by kanga.kvack.org (Postfix)
	id 848966B05B7; Thu, 29 Oct 2026 02:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9706B05B8; Thu, 29 Oct 2026 02:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7102C6B05B9; Thu, 29 Oct 2026 02:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 473A06B05B7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:08:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 735361602F7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:08:04 +0000 (UTC)
X-FDA: 85374633288.02.08AD6C0
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 93768120004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:08:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HO4txFAe;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.176 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIyRNW6At3oCihbJNccAaO3bWJ8LNw9lR1egadV9gDM=;
	b=Wm3uO5FM1wUjNrftorj4dmwfF+peLsN5tvlfawp4Rs0nTuKmgEzNVkjdXU0LmzZu7+Dj+Z
	HTotA6wV8qfjeaSpvPC6nhzNasctWfczvCpJQld9S0PVvsfTJ0y8/hySv8D3T3fPthRhW8
	RnvsRQmRue0ERhy6kKZT0xR1gv78Mpo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HO4txFAe;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.176 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254082;
	b=8Rb45kvBsU4SSlyfg3GbOAS2yEPhMQmnY9D3Epvx/wnosVbnB7zBZGyrccFr+/7xjp0Hea
	MYmsJeLou75VWUhzcVuWPfA0f6U8W5Z+n2dp6uUDnh9bPoLzK1l9ir4MTUP0iRDeQvR2/p
	NYsRVNW+3IgnyIOw0ZHnXSXKFJFckME=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-88cfa501c5cso931637b3a.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793254081; x=1793858881; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=KIyRNW6At3oCihbJNccAaO3bWJ8LNw9lR1egadV9gDM=;
        b=HO4txFAevH6fAIy+qpd+vXhtcvnqfHOVb4ULv64S4IkAHTwbg8RGOENiAGlH3mZTfO
         eoFCvgkdr4UYJF8jxwoAITnPoVGHOIWZvt7cFFUcFQlcdxxjnkrSodmVYGJdIwjAuMp7
         3/6p7sCrBGFzWvBTb3IffyNxGmrgGVumq/D5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254081; x=1793858881;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KIyRNW6At3oCihbJNccAaO3bWJ8LNw9lR1egadV9gDM=;
        b=n6yrNypIU59k0ogNAjAizIuIsjR37nlv2s057OeqqLPPEukNsZc342GwOOaRbRouB2
         QWa8uLeFvr/hhvqTKQXZ0NRKUzqFiFBXh7gt7VBbzZ379V+AYsifPleOfrymcJDCGfWQ
         F+q8ri/9Hutdqm8hP1girN9I0JE/jc4fKsP2z/LPePVpGSwYMHPH1wkK8KVsacuSMCxi
         OrXbtrVML4m3Y5hqJjgF1xsi2Y3DM3gEMl86WabjFGQLAksO7ZByeu9dl6ZHCHs9LUx6
         pJidXLyHEg0WB/4kMUz0ZF18B4M0eYbR/MGrMjVVGTTVmcslkVVnYDPwS9+7A1DxMyRU
         vX3A==
X-Forwarded-Encrypted: i=1; AKwUvBzxvlkqyp+eXJLUPepCZnVZRp7pTx8WII1CdhOVCDZJFd1KpR7LnWAd1+YZGTZO/1SJTRUup3cb6Q==@kvack.org
X-Gm-Message-State: AFq9FYKR+mBCw9zuMwuJ93VYDsrVc/4eWv6fT6D+xJAR4HRZETc37Bqi
	LwKTk0gksoIOFk/3Kd4xqQ6AogXNiqfoD1pbcAB3n6Wkj8glBBx8JDU1ydeUPdkSctQ=
X-Gm-Gg: AYBFou2z7QbRLVbrqymlnnxaD43tRMZNchJ4808qbDVT0re7bGCc/uzkHMOcihP9zOW
	YQkVbU1TbZCGCXqRyPPueZqto73e3yssitnKX570uxZe/wzjRiTA43pN/XdGfqoLcAqu0qqXglc
	wTYXGQqmV4EawQirp1kYHPt6E8b+mTxyGnuqmoTRuOhHvyE9YG4rHmeNWIT4AKaxmtUdzuUR2AQ
	8cMG3HzNKiLy9rtEHyY8LNXpVCqal4KNCxdI9N23bLevl76mrYoPxAitB+v/RNRz3/1WrMHs3pO
	8jPPiMoOfF2A33C9XxoKPmXbUUOTRH13VljK9qAZxdLzvvKkHqkqGo2LD3epIdcoMOOwWkXs75N
	Ojr5rst4kVQFZNYcG6L/8iUQ2xgUFIexTrw1Z3IebXC3EcgCzkqhsKWsNqeC9MaYxGkrQNqcsi1
	jQSFBetbaWZleTW11RlHF8dXcZt4M+r0TB53DMdOFsa1FcO7snJDKY3hATr6LvMj+ra1YXNzqhO
	xMDrwtVhvRa3hD4DRfrhR9EsY9LMimppcTeakPg/fzQXl+kDBXFvSM6xo/DZ1XqpUv1+xiH+QWe
	ts8YxIjar1+U8IZAqZ/cxRNBWWQ2D7GPbVOTiJGE6njK8cwc8aCRbT9vOcJoL2ZAWsehUfJeGlp
	aXYT6N9ldWCzOfBPBGituRRYYsndaUIk485/NjreaR9oBKIkziqb0PwACWnRjmXqVIji/BoiY
X-Received: by 2002:a05:6a00:a0f:b0:886:5f48:3fca with SMTP id d2e1a72fcca58-8a6e7dc9293mr3736944b3a.37.1793254081351;
        Wed, 28 Oct 2026 23:08:01 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5bd6asm1861640b3a.4.2026.10.28.23.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:08:00 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:07:55 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 2/6] mm/slab: Enable SLAB_FREELIST_RANDOM by default
Message-ID: <6bdc161bd869ead04b3b9a651ef6a83882ecbea3.1793253633.git.chris@chrisdown.name>
References: <cover.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793253633.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93768120004
X-Stat-Signature: 1j4wo351zqefbs7qhw7ct5y9jir8ojqd
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793254082-807627
X-HE-Meta: U2FsdGVkX19fi6HFnML9OKbHvgmxHxttRwjRtsgwdM7yrf6AizPD9A8h1ZekvjyBB6rg3PTjZQIrxJFZWqjHfhcveQIyWKKBeo473CUT1uVvS88pdHILXlVRJG7X8dW8CfwoF9bvpAzw1jz1FIlfgS9ETQGSScNxiSxW9iZm0us+/CmKGe/HVvah4b12SNFWLHbE9L/myaw16wuzWmzC433hFsgd9ENwI7fsHUUJem54yQY1tf0SEv+2xk6JghqTUJJK/dhiPbe6A+jvGKMdY47O/Sngin+QhmoD+Nv5Fw2gveqxWqOG3XUXaGTCVOx8QjXDIrFLr7Pe3oiZHDz7vFCB+7JS4xyA2aXhExvSRt8e5cpUijpSfqhyH2SSU5culeh9ZRwXL+70n6y+rookIr1+H3PitMLOpV+wHmjrfQzDuGzmQvh2wy+eUF/ezfnPM3PeZWwD+qJOEFDAiubjZN4sH8S93weKSm6wFyrDzgfKUh/llqfde0otNWZqjgEj0+PhxxY6SK/cWbbPj7f1uZrZ/xyf1T7pKa3kF39hmh0Yq57zRRIxR6B7oVA9QzHT4ftFGp/t/7vE92vgLr0k0y7dz/81HBp3l/Iu1oUra7h+sF4eauT4OQzpkgOjqmnM9xSGXElspZ3yY/vKIQXsjQ0HGL5mL3AZbr0vlMmX9iPNgu2gDpWcoRH3SClWfB4HAL06p6NQ7/4l8f6RsUODRU3UaTtmi5UDzD0YeYpvQRFisl5LuxC4QGjimqpvRIu5FiLyMaxDL0opiJBopVpPhX51O1TMDTB0jVVBLnWOVWlBwpMpAgHRtlJX1qW6kn+rPb9EZk1Dd1p+FPnmI7eipqNM35QfYl44PmFgt02pgEvkjTH/pG+zYzNsY2zX11S7BnCcIh3vC1VNrXyY3Z30CzegsFTVIyaMb//zr05/9F7SjVXHAlxuS05t06UvjtFnNMBVNNVJvaT/sIvVMKU
 mDp2A6HD
 M/sup46fz6m9LD9BgR8/Py2SP7Np+UE6+w9w/A96ez0EwuC8M9smOm30BBp3p30qm/39/ldMq7tdeRY2ryZUzDVtnijfCIggVHFsQhV3AztWIyY5G1TKjkWvTx7iMPCSgSxkn9KwhSmeYkdZypmT6ZsfKRaBTLgyR/lxVXlfdmpHO/vCj3CbSqlV58uuCSyOXmDwdydDfACCUjcVcbeK7sGC5h1H5UFDO/x7oHgmpESHnHYA4WhqxRQjY5AZQxANo+5R5AYLWBgZEN6J5BDE45gkSBJS00jPIjsr6gQ0ia5hkhqeWUfuIL13ms5FTjYc6/7QU3q/wgmgNLNS6mnoXfu+vR4GAO2UJLoxwq2AO3yl2RQ06PrclRrAfZ+rA3hJpeMYaAoZiVFKrdUu5eULbssX6OL8lnxY6lTroMZIdGXnnFF7sYDLZVOtHv/qKpCqda0HaKSOA7XQ9SOJW+ASamidrF59UWUIujVJk302kfXr0D1lF4d+OPfuzUGBi7zHyscDG2EOusNnvBLrkkrDYlHnxPgdxPXddEf9S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SLAB_FREELIST_RANDOM randomises the order in which the objects in a new
slab are handed out. Like SLAB_FREELIST_HARDENED, most distros already
enable it, and its cost is only paid when a new slab is set up.

With it on, the same system level benchmarks didn't change measurably.
Allocating from new slabs does get slower, by up to about 30% per object
in a microbenchmark which does little else.

So let's enable it by default too. SHUFFLE_PAGE_ALLOCATOR defaults to
SLAB_FREELIST_RANDOM && ACPI_NUMA, so it's now built in by default on
those systems, but page shuffling itself stays off unless it's enabled
with page_alloc.shuffle.

Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 17d017e8fbef..92ff97ff24fb 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -200,6 +200,7 @@ config SLAB_MERGE_DEFAULT
 config SLAB_FREELIST_RANDOM
 	bool "Randomize slab freelist"
 	depends on !SLUB_TINY
+	default y
 	help
 	  Randomizes the freelist order used on creating new pages. This
 	  security feature reduces the predictability of the kernel slab
-- 
2.54.0


