Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D66C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6536B009E; Tue, 11 Aug 2026 12:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAE7B6B009F; Tue, 11 Aug 2026 12:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D8E6B00A0; Tue, 11 Aug 2026 12:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 829FB6B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:20:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FC9C404F8
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:20:01 +0000 (UTC)
X-FDA: 85089500202.23.37B5D09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 68CEE20009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:19:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D9zlC8Ue;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7CISCZNOUacwFken/zE3V4XA36dbwptL0r4v8Me1CY=;
	b=IlJo/d8H73EFYmfDI1k2sEoQCCvPy3xe0rkf1WerjOQwXryxyDY61Uovf8ysYwucIOQN03
	OkypAJ/ruBEmua5DNKzv9Oye89b54Z++pIZGU7/yOz1GDtOnaZoIHNmI7GwlS+IB+wp3/z
	wLLYT5ilBHaEb13MO5Xhzv+otYc16HM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D9zlC8Ue;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465199;
	b=oaUKEoQaYhft3JfHEpDuDDKM3BlEK++wCL38xbKwrfwbmGcVetXYPMakJEFDQeXF03+mw+
	MnQlsx9ZrTrSrGNhScrljN5Y37XCbxhkzjZ6MecBBcAPTwQPDwoSralTNvYYRurAkZi0xG
	kH51UA8iU0KIYzsM8B4a98Wa7EupS0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2A22600AE;
	Tue, 11 Aug 2026 16:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44F91F000E9;
	Tue, 11 Aug 2026 16:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465198;
	bh=D7CISCZNOUacwFken/zE3V4XA36dbwptL0r4v8Me1CY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D9zlC8Ue7xyoRzrsbwUuTAn1JU7oiR5DVZid6WO7JwmYfxYK7juv4wK4YWA3jvPG9
	 fMNh6tkMCQAiV+0Zo803pEDObPx++QRzDbMTeqC8FVs213MQc6MHYwYbGM82/YGtMG
	 tumFrAoC8OmH0ntJar3oMIJddzwnBWGwpC3au/UO2THkmABUJaTyb0scTymw68IjPu
	 kkzGIAx14f0Jo7Xj9f/5/MjJGsLzrZgyFQOhYEJ9un76PSAbLqN1pq7gCZuqWWpzIm
	 6wtuElC4RxaAl6cqVD+qTUPqAZdGhDYxOoD/cQsukiy/qeg4CvEDax1X263j94k9PW
	 qvRYNgLu9hing==
Message-ID: <1d8cd29b-8a4d-454c-8dce-121b97e9d52b@kernel.org>
Date: Tue, 11 Aug 2026 18:19:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/20] mm: introduce linear_anon_page_index()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Alex Deucher
 <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-3-ab318a350404@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-3-ab318a350404@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68CEE20009
X-Stat-Signature: zdsyo98cjo4okc8xjn44u1mgr63r1k35
X-Rspam-User: 
X-HE-Tag: 1786465199-821856
X-HE-Meta: U2FsdGVkX18wa9XZzGnridwdem0hmlU80RsEHZtqn+GesEI0Nao7xljH1Elzs7K+OIsj+3aLkJPbi+6mK/0bGLf893pFAJ1E2aQWg8RrUdT3b7qKr/Sl+SyukkHdh3AVAmkcF7wuIJT6xK6Zl2m9R5Jn7RNpInvT8XmPPZwRedMI5uGRUqJdMuTnZSuGRuIvJZtfdkXR2ajRUlcrwVhvHzXjgCoG2H1KjPfaF3PKyLdTFsJNLokweO2VcQ4S9z+qDPU+KFDG2OyKZE+0DaYo1XdB6T/5sgHoejiIFt7g5aJI9rMLSA9yrqZYgTe2nK1oq+fIX2bwP3Xh36uuVFsNcq3T0rQ1VibVwSwgLYC9s+C53i5M34aRIBMo4uf6D+RN2ACFiyZ+LrXIqWDHtaIHe4KdqbLGyZ9w3LvDMIkqIIhuVNVVSmZwpljlveAimXlIWH62k1lSwSv04dEKQABLY+t8MuMaZhjjLIi+4QveP12/7sZbZx/mdpZy1nXLcq4KO5TPnANpiEIG9FaZo0q5yfWAAwIQAjgeRajcvCpI6bBmHJVIn+frqwKRh6/6T08k5adKpgZKnED2iH7Prv86xbnKwXz1s/zfkdtsvMADK9Mtqt1M1ktCUirPZSRSkEin8ZjZsDH2qGpjJsdogM2xfVoDu0XtCDE/FybhF0eL88WYMuk9Is5PCYgkwWkjVyCe8ZnwoAu8P2jdMzTb/i+4yW3ujZ5xsezoqrEJsuc3PvdLzl1And+7uu7hCfqoyPsHHr2lWpx+MjK7myBM2+z+eMxRTCGHoVpwa7ekk14AUm1qVNK3xgZ3w48lSR3OkZcp6bSaMQ39py1EzhZSI29TuCl6JTsGiAQ1TERf9p9EaxrZ2FCJSIonBqV8C1aj0IDrmgeecdfR33+4A5ZYE0EpNGNoVnNtAMYq9AKqYqYFf2O52L5JhW7+UPr+feW2pwUKc46/WoXuECNIiN22/pe
 CNi2JS/c
 MvOQoKxBqQ82tHKhQ9xXkM8pVJOOSdbxu5gqFtPBM38VQBh6gfcTIZrEuXdKrYPnL2EJPIoeZeitMsXaV9Ua3BeqGntMFaZFb9f46ey/doEQT8/im2FS3Cra3d26MiCJ6/Wu5xV5eQvS3y48PHMDp2wKn7odjv0HmVonEz0OjJCM+lZrlq34lKqAap2Q89YOPjICopmzZp35w7rW+7QbwT3Ut101trflWI4WBWk3WjPlPGAxmBtakkpskqv8q24dYvobeayI5t9H73hnW3VL2X9GoQtbAnDDaG3Gung3GMcE1XF8J7YzZ8mPF4VZe0BVLecjO5EE6Ne/lDhwFHP5OniiVTl+KFWzVSqlbZ82tmG0nyoTVO3tab/emaVtFf/YQmW6dhFBIPz3WRdbaxutq+hx4L5Sll0SXhlDPPkFObVhukHctKHCCCExBVI568xAf04FJ3tw82rr7S3vZdFUfk3dUaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 22:21, Lorenzo Stoakes (ARM) wrote:
> This function provides the anonymous equivalent of linear_page_index(),
> instead offsetting based on the anonymous page offset of the VMA.
> 
> It is valid only for anonymous or MAP_PRIVATE file-backed mappings, in
> other words CoW mappings.
> 
> For pure anon VMAs, this will be equal to linear_page_index().
> 
> Assert that both of these invariants are true In linear_anon_page_index()
> and implement the algorithm in __linear_anon_page_index().
> 
> Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
> but not fulfill this invariant, so when asserting this we check
> vma->vm_file to account for this.
> 
> We do not update callsites yet, so no functional change intended.
> 
> Also const-ify vma_is_anonymous() to make it compatible with the
> const-ified linear_anon_page_index().
> 
> While we're here, update linear_page_index() to be more succinct.
> 
> VMA userland tests are also updated accordingly.
> 
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

