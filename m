Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D9F8C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 09:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADDE26B0666; Fri, 14 Aug 2026 05:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96B26B0667; Fri, 14 Aug 2026 05:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986556B0668; Fri, 14 Aug 2026 05:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 671AB6B0666
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:19:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEB8C1C14D4
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:19:22 +0000 (UTC)
X-FDA: 85099326564.10.73C3904
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C1D51C0006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:19:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClROgThb;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786699161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSiv8Ryxhci6n2uyQC5hk0pgjrUd4kNrjgv+MUJmkHM=;
	b=eJ+np1imdKjGI40dYbbPFZWl+1kdZ58bIZXkaEHru+6wzESNCc2ENC3HdZf4ArKFJvlYMB
	iGsm6+VzkQjTdny1ScfLMO1Y2vk2dyQYYKtEo+Mz/ooP4t8/QYBNJqOrqx6G5V2RO3SJ7j
	1Px19DIbKiQfR+cJSfdU2z/LrXOlqoU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClROgThb;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786699161;
	b=PjzGij4f6Y3kL5i8rI9yA5Aek1oqkvHBUrELm871eSfBhxkFWptCcx1MwLTAxgq7Kd4BFI
	Kkfdwe8ywStveLq9AYDgn9nZUKIB1Y9asjbNkoz4sHkWZVsPwx7uyIflFEWCvc38ak7d6Q
	S76zHaX/Fx9oeCn3ZN54crpqdK/FtzI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D508600C3;
	Fri, 14 Aug 2026 09:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6EC1F00A3A;
	Fri, 14 Aug 2026 09:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699159;
	bh=wSiv8Ryxhci6n2uyQC5hk0pgjrUd4kNrjgv+MUJmkHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ClROgThbzrACv5QEUbj7DSocgDof09D5Vd7sQg8I+Lt+b+Uh/duTux7hEUsAhO9YD
	 p6Gmfpy6TVyxbruLfAoIzXNgsGfse45hci9xJr8uwCdRr/sWmwzYiwkAEOkJXbYnkO
	 o3zxJzbVlIYeX6G9egfopDM3RX9OY+l6wO8ezGZyiHZ+/duems2RJFG3g6lmNWXRLE
	 QmFm1GOD01DhXfb8oWjFXZm94WasQ2gfDu8rtioB8alon8esBGOD3oL6inBOR4cbrp
	 wsZcsWaxHygY5y1ete2swQwTHFnPb1dR3CX6Cng064seinHx/l/tBbrLrw+txP+S04
	 Sp73EkyK4Pr9A==
Date: Fri, 14 Aug 2026 12:18:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH v5 00/16] mm/rmap: index MAP_PRIVATE file-backed folios
 by anonymous pgoff
Message-ID: <an7dekaY7IMMrzID@kernel.org>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
 <20260813115346.2aaad419a351341a4f5f3ae0@linux-foundation.org>
 <an7SkamROquJ7If0@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an7SkamROquJ7If0@lucifer>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C1D51C0006
X-Stat-Signature: iqepxbdkwhxkfdq334ufuk3szgteaagn
X-Rspam-User: 
X-HE-Tag: 1786699161-458902
X-HE-Meta: U2FsdGVkX1/k5LUwv+5l3Vv/ZyZpMEImWfKD4mXU6siXF1GsPD1U5dRbEas06r0PDg43kEm8B4FIzsfFCYuYQMYIE17MtTxpuRSm3WLOwLO/9blBppCFxV7GubfnICv1dw7CyyPAJ62ICCXbpE3lswmHBltTT1fpzM/ELP5p6wGwjdqzzuoNgD8BCN8SqDARlbYjEI9/2MJ2wRs/QrNcZw1GVq4tlYSCkV2j66dd08CoMLWuf6DAzhRByRqA9q9H16PEjE7s1BLtmToy8GeGPchaG3NqLNONntpZbS3zq3fnA9fBctu/awGjUswQepzzDs8UL755cczm193nlMYTQZbHpmqH2xy4QbLr4DR85i4HeiQ3AVo3q53Objz8MOaj6HTbU28yWDzqGlwVCXVWMWXneAXSB63etkMBvUri1hVz5QqLYJW7D4UFjdUezoinic1MfoLuXb9yhGwFZoLZZy1DBp5FT7mRCQjxMz1ujXp73ZAy1cjyWmQhfZB7FzKsoNWqc/rX2yewxtvcNDVFWIuWMixFs/1/0YROEz2ztHNC9kUpY+Mw/7cJetgohNkl7radGfvYxxyGqpJyEvvZSi/oCFP3Qd3ocHsaZCgddRTAJyNTRiFoqnmmbXycJC01no4ZihbkW6TLTOd0/Eo9RsGUxyCs6rHteexXFsykbzzJnzkSQGbHLP5ZpoAM4/DZpDxA3Wx+QwAmrQXJ/ZvRMTTbqHh2S5HZdtLtPKK7Cozto6+nzfLbFmHN1xqGtsOQc/GRWtBHZ0EN0z5KVihZrS4ji3MWKc3k8ZhJBlX1oLuJAV0Lzz8hEcxge+O/RUVVgs2ANGqt3GKDUcuZtdLOQeUKqVeo5mbETSjk12QueABSksiqf1/pdcQF/hdFsF1sCEmSOWC8oq6Hek+TOmojhQUPM9gbWUIznQ9tyqFtlm6dl0udIweTXosjdyd7Mi9cKuU3EYlc+nmflgZtzqV
 24F9RGRe
 /A1wtKcrmtOCzGd0gpeqmN8c4DRYGVyGUHeIgmWO2rU6dcressRXXdlivx03rYcSxtugiwvgUBsueakRk5TKIBY5NYBCaL4CL5uOngN1JD1GNgqiGbhHbOagIAtC8GUh4glAyDdSRGA2yTMDABwRW31y0tLrqD9Vn7YQmhxAKcZKSY/9DqxRvvrPSC9iCAfkkMhqV+Zgqq25M+aTbLsyYv4K01wZ+sUVV4O+7k0ZmDqcjQbeQlVHBa/hBOgslnczaJFJJdmZt5pVCq4fIUbxGlmAFb67rk9XugquLyP0ykgq9Sfspds/4mJYTks87fLSmMMNZ6ESoTevHCmSHCwWioCutrT0TO4cQq9X854R5MOk5o7waAwk33bCocA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 10:01:19AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 13, 2026 at 11:53:46AM -0700, Andrew Morton wrote:
> > You'll be mortified to hear that Sashiko wasn't able to find anything
> > to which to apply this.
> 
> :))
> 
> Well, when it's right it's useful, when it's wrong or suggesting unrelated
> what-nots it's less useful :>)
> 
> I do locally put things through claude + Chris Mason's prompts a lot, I
> don't always invoke local sashiko as it's very slow and token-heavy or has
> been so far, but am planning to do that more also in future.
> 
> >
> > Sashiko can be guided with a base-commit: tag but I'm not sure how to
> > tell it what tree/branch to try, or even if that's necessary.  Perhaps
> > someone can figure this out sometime.
> 
> b4 gives a base commit, but I think because the trees are rebased it ends
> up being the incorrect one.

It's not only that the tree is rebased, but also that mm-unstable carries
the previous version of the patches.

> Not sure what the solution is!
> 
> --
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

