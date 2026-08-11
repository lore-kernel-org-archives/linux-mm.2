Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A43E8C5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2246B0092; Tue, 11 Aug 2026 16:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A38A6B0093; Tue, 11 Aug 2026 16:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893AA6B0095; Tue, 11 Aug 2026 16:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56D646B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:08:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA523C023E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:08:38 +0000 (UTC)
X-FDA: 85090076316.03.A6BF07C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 222CC1C0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:08:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MVsx4Y86;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786478917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ay4Sx1aFee/8WOMMoH+smEVqfxFPpuKMRZQpbR6u3yw=;
	b=Yo2K8qYk6ktssNj5DktE1SD65gQa2z2vd6YmsMd+m39ilMgP5nSPG78PPuOzQOHap2/xiT
	9pJNTNopkSbZ88ZIiCRWXSX5a2lV7oTB6jEdFY3//twLssp43B+iTw8zk5KIYsTzRyTBwE
	wvBE7gA/dNmk/dCfWgNTrdKWRk22Qs8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MVsx4Y86;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786478917;
	b=xUIBg5aMEE+XjCN8tPwUjhQRvXUbp1WcFUPRDOBoA0C1eEQQGai8bio1fxW9T6ruX/mZKD
	XduTeItI66AJVbuY6u+oQFvxhYR2rOasWyA9ino//IkIIc4jQ756wFOrz5vxXmmTCGtA+v
	+LkF7oULV4zEkyDdX51+qEq1yl93swE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 337F0600AE;
	Tue, 11 Aug 2026 20:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384501F00A3A;
	Tue, 11 Aug 2026 20:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786478915;
	bh=ay4Sx1aFee/8WOMMoH+smEVqfxFPpuKMRZQpbR6u3yw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MVsx4Y86Lda8QCjyAeakFZeNbk1U1nnbpjqsIPtBxUMubFHCaQYUz20Z8mA0RiRLA
	 VCd+fPtrTR+NcFIxYVzfhh214iv37GZnIs3sWMgVPEcj8F9bTxcMlXmXihxTs0oG+8
	 fLgI8mKfy36hIx1mSwWptiKfVBg1ORNZHfRMBLR4=
Date: Tue, 11 Aug 2026 13:08:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, Kees Cook
 <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Arnd
 Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Alex
 Deucher <alexander.deucher@amd.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, John
 Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Youngjun Park
 <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 16/20] tools/testing/selftests/mm: test anonymous
 page offset merge behaviour
Message-Id: <20260811130832.3f18d4326a5ebe6eb18cfb5f@linux-foundation.org>
In-Reply-To: <antWw3a0iEv4l1Yd@gremlin>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
	<20260806-b4-scalable-cow-virt-pgoff-v4-16-ab318a350404@kernel.org>
	<cf70ce8f-cdde-43ec-a50e-796d4e390f3f@kernel.org>
	<antWw3a0iEv4l1Yd@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: dtx5nwwnqeec3gg38ot5u534h3xpqmo1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 222CC1C0007
X-HE-Tag: 1786478917-456524
X-HE-Meta: U2FsdGVkX1+B3YZRmCm8A1olvfI8TF+duWC0c7gMJuva+D8j6ep5wdtNj9831xPvhy3UNxs2zya640j5jnvY2Y6iR/DPQFlM8mPkFuLmreu8EhrCDj6XlvuMaMj/PmX6bDBH4y7r3tcI6XsYRGtrr55AdcydGqQhan90brPnD4FUPyI33erArblXwFLsmjm7KUD0pnfdZ8HD2pUkI5YE0ckDGlcl+8PWeTjxa1+VKkSdPX3bzGcxJVcrbg7KA0lpwjxMkG8B8H6ypNzIqR5HZM53hrepAFSjJOA0LoliHLps/8UmcJRhRGWG/nRkvouSVO9t8MBQqYn7NC64Wvzd6ZqNNgpIxu5LvDSNhFoL8vJPTTZqj+W/crjpH2Lm4ngP8vHN7dbkbWqIiXaGfNCg5Chr5F5rmD7tjfYPVXgrRAX5qI9dNm+Vcqgm27Musik320BXolHCEjXgGZOf6iY8PJ7NCiZ09iAC+7j6gPj3SedB1mrN1Avo4lph7OKdf01pNSQu0GDnB/89BW2scCqr2FtOza2WP4+a8cYm5aOPnAtwus5mDACyDwU/eLiTzkKv0Ny2s9Ii+4Q0eLuQp50bx+EFZfBY9M2/pW+JNiw7c0cA/2oUrz9YMwlysVjirtP9pF1jC04s9I6Wi38YnxYYmRE6TyFIisgP1ZY6c7biY7al7T/6KKWRkUOdE0bbWhLg4U8ZgIYrgPbV7sGHRXFaEBkbtzD0Rz/davULTNJuiudzsdPOjkzV/AhhTb8dAp8ngilA3PsD5JYlPrHG3jiKhJf/1jrBAjdrqkjpkx4Teo4pU04EWg5fZYrh3aZM8n8pgSrA0DG/KCEnY6owT7UVn1uLksegJScJYGJEHYei1RR3geuL0rsDt63F7Po/OwoWiAnDUBEFREYXGvSSTJvT+L8WhfmqUQi52AXidZ7FiKoX9kcpJXdIetPL7uhIwUAV771/0ilBEoSgG06WW1L
 I8beRHq5
 Z2X++h7Tk/nZ2B9o9ZJkawMLgaPPs3fhHbt84EDtBdybXM84O/eqnISK4O98qM9G90i+UnUHeUqSn8cEchF9Ufte9pODW5N9kfCN69UVL0EwpAG0/G0j9ZW3ZjhronBhYDBuj3JP4otM5PhIhDAYFiAqxR1JmMOBRksq6gy9vLWun/qLZDTq7lcfZ6zVtv9ozZiKnixVyWvws+eEsIiB1jrt5ifJ1CYNldjsQhJJiUQHOcwlY37Ci78FkoFvZnbiMYTWDfNEbl9T+uyFP0/fmLSWseWOs4AKfmnI9wF8yUjvtkujTw3is4mAFcQmU+aqz213pEm7xH11yqZBtfZ1HqobW3mejMYZude2C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 18:07:36 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> > "Fault in" is imprecise, as a read-fault won't do. "Trigger a CoW fault." might
> > be better.
> 
> Andrew - could you fix up? Thanks :)

np.

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix
+++ a/tools/testing/selftests/mm/merge.c
@@ -1324,7 +1324,7 @@ TEST_F(merge, anon_and_page_offset_misma
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/*
-	 * Map another separately, and fault in, at page offset 5:
+	 * Map another separately and trigger a CoW fault, at page offset 5:
 	 *
 	 * |-----------|           |---------|
 	 * | unfaulted |           | faulted |
_


