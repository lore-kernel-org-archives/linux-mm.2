Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA14C5CFE7
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0965B6B0088; Tue, 11 Aug 2026 12:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0477E6B0093; Tue, 11 Aug 2026 12:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E504C6B0099; Tue, 11 Aug 2026 12:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B072F6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:46:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3892DA00B8
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:46:33 +0000 (UTC)
X-FDA: 85089567066.19.A05B722
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8946F100012
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:46:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDOZm2SI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786466791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XUCNlER7njUc40tBR0DWcTfriB1zvkQvss6GHD2ank=;
	b=0704ywYjcyO7+w21tMwkgmtvXPiXUDKN5Qsa88crFvLV3XdlL9BPhtaOkyjD3uY3RYe+Dj
	FxVoQYDFX6DjxvER1J3ON6RgYdpouAvFhma78merA4wiNPC6KLIydZiImrNRKfjDhIcuMn
	V0AHZEwCJJ/dqoP+fHIq/7ZOMGs8uyU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDOZm2SI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786466791;
	b=8dWlI7sfkkgy8i0LSQFTVd4qYn0SNSlkkXTlsA8JwC4AI16xaymYKPK+V4KsZaqIh80tNX
	mCMmpB0yckChn0QLo2mdUod5XsSMdhVWa3CkH1c+1b5WOJNiWe1sHD91KtBcPYVYjIgQXU
	err0b+tN9QQoV5UudvpuPoZRKRIrJjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D28D600AD;
	Tue, 11 Aug 2026 16:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C271F000E9;
	Tue, 11 Aug 2026 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786466790;
	bh=/XUCNlER7njUc40tBR0DWcTfriB1zvkQvss6GHD2ank=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PDOZm2SIEHzJEYL6kAt2p9SwsPWFP53BfhFoDIV5PJx4Mar22fWokuwB1Gs40HMCW
	 HusJkPRcas4gssRJHuMvSkcy0pQOGTfK9t7uteNp15QoUveerW2+sQ/5N5czl4URVe
	 6huPu9zGCJOtwppJ8w1zMucIJf3bBhZUKXFmUyF7Cjlj/mkR0OgZUmQeUhQP92R7jv
	 yVieUyIsqDE5eH662LglgH6MGJcAh0MiiR41c50TFp4hD+mDnj/smhw97Lg4dNjutr
	 DKAURUrvfOmLvLTJNeKIvaIwsjRGawg9+A+NfDLh/l+iN5qQjYALyXHDiynJvEt825
	 Ap0uIpkDLBUoA==
Message-ID: <c76f1dab-97a0-47e3-92ef-042e403c64db@kernel.org>
Date: Tue, 11 Aug 2026 18:46:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/20] tools/testing/vma: add tests for copy_vma()
 self-merge
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
 <20260806-b4-scalable-cow-virt-pgoff-v4-8-ab318a350404@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-8-ab318a350404@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8946F100012
X-Stat-Signature: dsn1in4fynra4yx6ky69x6g14b1kc9am
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786466791-428941
X-HE-Meta: U2FsdGVkX1+Nze7Cv8s+kT7PBfNtdZ2jUm2W6DQ0JL9nimD/EAwgRUsMI0kon/IWg5DOFXd74lUewDm2yiiNiKNHrqyKG6sz5dO7cnAaqDq+P1BolVgalWIX5Pt8j5vh+LS7l7uMgI29pQZ17LF2nVONGkyysO/UIkJNYFkSkbyPmaM3Ftdw4IgKYRLJVgg4jN8SryOTpbic+KOQPyuZz9xjccEUkm0bHLbOdlNhr0t03RPgDfong3Z7fYEld5s4DiAZpIFV+M0/vULtBM/xVoopw32USJ+z+jSSWtBCRUusY1YziisQQXo9HsBddPGv4DaXMrESHzhiD9M/Rb7vrC0k6XAkdFRXUejr8mjH6VTGLv4GnktLnRThMbt7+2oOHCUPSzNhYUeXowVc6fl5FwaHzyBOTNCUkTSCtcNxbyAiHanXKlBYzjoyabxedAAL6EsdhTJgKeYR78Chtj4BNoBhjO/tPPgVx7h3jJFk0Nbg7kWKGDsRTj+vlNnMzSv41jEcDddU/g39rbpL7O/XJHH/S0pY8GgcYrL65w1JU2GBHq65bZTReeMyTzeKqUI/sBiGYewWHMJaGv2DsIeYhTl9cXM83o3RRscBQ2aKHBZQ4yFzDyv/sj0/rmFr0+rUHXVifYfK6RQHtcZDhiqa3iiNZCsVXnAdLx/R39/jlAS/Gnf67/xdGNjhNfdic+Tvf3OpxY3lRCHYYo3wy/VofqNXlnV2D8T/xEK/t3bJ7dKyxL31kJ8vRUOwBdxvrH2SoSIAZruV7duxcK8Q1ripSX+FHXr20oNo5PviIewmweuumQysqo6oRYxKFk/LEmui8praDjCiZYMEK0Ig1t/kxKOJGcO/YbjkJW7eRAdxNp1bsPfk16nl9CM8tYF0zpvOHOhM4ver45xSCsNI2xuIBE+MRGOohsIGT73p/lamWLdsJX6TbR9ovgVwOEajjQopZCIUqeSaXln0y2IoK2v
 x53visJL
 6qdDI+K4KpZq57IUJD777NxwsIKqb1uEN64P+7YyA40KEN0PyfdJ420wi159jvejVNnKDLF8zS1rAJU6Wdb63y5J1vv6l4P85keiaB4q7p0eFNcNryPCTakEctMadI7BAmynIOEPDsF1ZjT1R8xkrEA/xSlQAFpHwnLxzkgiB3MmVWkl3DDTx+Co6y9TNqLHuh2r568l8ePd0f4M1U4en9fQayXyFoTJLwcqs/WYbSrZgo0SF1fXEmh1iHh0uQX8+7ZFPj6oc5KvzDcp/5rUINZNcQ3g5HyT7HKznAtq9ypOyYeJsA0mJFKCvJIZTi+BBemr44+z7p4f9iftdeRuyU+LOEPtPi1AYqwCva0iTTattny5DRjnVN4aSF5VtpiIVHAwqsh9ex1hRnhzUzE4WnWVpzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 22:21, Lorenzo Stoakes (ARM) wrote:
> Assert that a VMA can be moved backwards, forwards and between a preceding
> VMA and its old self.
> 
> In the cases in which the VMA merges only with itself expect that to be
> achieved by expanding its old self, so assert that these function
> correctly.
> 
> However in the case of a merge between a preceding VMA and itself the
> original VMA is removed, so assert that the preceding VMA replaces the one
> passed in as vmap and the merge is as expected.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  tools/testing/vma/tests/vma.c | 46 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
> index 754a2da06321..0d40d7ba2181 100644
> --- a/tools/testing/vma/tests/vma.c
> +++ b/tools/testing/vma/tests/vma.c
> @@ -33,7 +33,51 @@ static bool test_copy_vma(void)
>  	struct mm_struct mm = {};
>  	bool need_locks = false;
>  	VMA_ITERATOR(vmi, &mm, 0);
> -	struct vm_area_struct *vma, *vma_new, *vma_next;
> +	struct vm_area_struct *vma, *vma_prev, *vma_new, *vma_next, *vma_orig;
> +
> +	/* Move forwards, adjacent to old self - self-merge. */
> +
> +	vma = alloc_and_link_vma(&mm, 0x1000, 0x2000, 1, vma_flags);
> +	vma_set_anonymous(vma);
> +	vma_orig = vma;
> +	vma_new = copy_vma(&vma, 0x2000, 0x1000, 1, &need_locks);
> +	ASSERT_EQ(vma_new, vma_orig);
> +	ASSERT_EQ(vma, vma_orig);
> +	ASSERT_EQ(vma_new->vm_start, 0x1000);
> +	ASSERT_EQ(vma_new->vm_end, 0x3000);
> +
> +	cleanup_mm(&mm, &vmi);
> +
> +	/* Move backwards, adjacent to old self - self-merge. */
> +
> +	vma = alloc_and_link_vma(&mm, 0x2000, 0x3000, 2, vma_flags);
> +	vma_set_anonymous(vma);
> +	vma_orig = vma;
> +	vma_new = copy_vma(&vma, 0x1000, 0x1000, 2, &need_locks);
> +	ASSERT_EQ(vma_new, vma_orig);
> +	ASSERT_EQ(vma, vma_orig);
> +	ASSERT_EQ(vma_new->vm_start, 0x1000);
> +	ASSERT_EQ(vma_new->vm_end, 0x3000);
> +
> +	cleanup_mm(&mm, &vmi);
> +
> +	/*
> +	 * Move backwards between prior VMA and old self - self-merge and vma
> +	 * updated to a new VMA.
> +	 */
> +
> +	vma_prev = alloc_and_link_vma(&mm, 0x1000, 0x2000, 1, vma_flags);
> +	vma_set_anonymous(vma_prev);
> +	vma = alloc_and_link_vma(&mm, 0x3000, 0x4000, 3, vma_flags);
> +	vma_set_anonymous(vma);
> +	vma_orig = vma;
> +	vma_new = copy_vma(&vma, 0x2000, 0x1000, 3, &need_locks);
> +	ASSERT_NE(vma_new, vma_orig);
> +	ASSERT_EQ(vma_new, vma);
> +	ASSERT_EQ(vma_new->vm_start, 0x1000);
> +	ASSERT_EQ(vma_new->vm_end, 0x4000);
> +
> +	cleanup_mm(&mm, &vmi);

Okay, these examples were pretty useful to understand the original problem.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

