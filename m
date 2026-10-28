Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C17D60A2607
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DOaintvD
Received: by kanga.kvack.org (Postfix)
	id 5AA1D6B05B6; Wed, 28 Oct 2026 11:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581826B05B7; Wed, 28 Oct 2026 11:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448EF6B05B8; Wed, 28 Oct 2026 11:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23E2F6B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:04:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A9B1140111
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:21 +0000 (UTC)
X-FDA: 85372355922.20.1EAAD81
Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	by imf29.hostedemail.com (Postfix) with ESMTP id 22DC5120012
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DOaintvD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77xhCh2ORMf6NIfM90rhR5yS555x+O+M+p2I+XHyw1I=;
	b=mD3uZQQg6VeuJwkVX29vk7/nlLNZDNOvzcYD0TMZmAVkbHMOhM0+ONdWcYs2qlLlfFaxVH
	isYapLI6knjfpDHwb8HZSLyc1uPtMXAD9WFX6Tn3kPpwO4L++H0eVaAMm+tWPstQQ2859e
	eyUVIdWUIaQ51YzCjL4sy045DDEiIQ4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DOaintvD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199859;
	b=za+W+eX6bYbR9TPfd3sBKMIvXSuPwSjU/9jftNbXDgwbR4yDD6PHc2lYY7cx6USG+I5jQs
	O1n/emnGxjEz44VK7rCwpzym8Dn77hfD4wqHDCnxPuc55zYV6AM/D+Czlf4SypoVLmjp3P
	FueSn9KLi99FCN4VLwk1WEGBXQLaioU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=77xhCh2ORMf6NIfM90rhR5yS555x+O+M+p2I+XHyw1I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793199857; v=1; x=1793804657;
 b=DOaintvDCkIU/aM4mbDkTUbB7KXdOwz/1W14lJYmnPjR1UglE6lkfhl7iisk2fyDHg/P6GP3
 5jciE740/d15e8va8jnQE3dPdseWY1LxdNQxUpMbCZtLmWnGJY0gb3M1wALTIAly7eJpWAaE9h7
 sOj/QiLSS8wumYpDbu7phDXs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d7967b914a90b8c6;
	Wed, 28 Oct 2026 15:04:16 +0000
X-Mizu-Trace-ID: d7967b914a90b8c6
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	josef@toxicpanda.com
Subject: Re: [PATCH 12/46] mm/huge_memory: fix livelock on device private folio
Date: Wed, 28 Oct 2026 23:04:10 +0800
Message-ID: <20261028150410.47065-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261027-fixes_core-v1-12-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-12-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22DC5120012
X-Stat-Signature: nxkq9h3f6f4oy3rnxbdktjqegi9h4j3b
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793199858-170614
X-HE-Meta: U2FsdGVkX181I3Hti/Z4ONTx1V+gggZq/hr0QNggKK7aSGU9VUo1U8EClMhYNwYhVh0iFjCi9mWpha54Ra5tBGAdEqEFFdoFMEXvcuWPU/rPZIlx93W/yIimU7y0fdxrAB4dBlneSzgmo0o5prBrOsl9QG2bRt04putvuHOF6YJTOAWysqsOud2oBeO606dcth9UT7N3iueeGMYQ7JtGCOs+lbMBdABI+IsT6JhNZd4PqgFV/JfV0W+cjaho04BGQMA3mg7V+RN2PNBxj3L4sTUa8dFhHvXbu6P1QyMM4SQTHg5HMjmjappvLZj6EC4R8lF0a3BgAFBFfmsm8VgLd04gmcoqBD20WzJwb8YXYRV3JLak7/owOc+hL+8aovgR6dHh2xoH3nUkyZfNMHMZoHCwpdGr0PoMEfTCoE15ao4olOmMToiCzASqlrUkRzjHVX0Ya+yOMFomO3iyMMPEsRhvnhCVo0OybUY0aQnnzg/tTjbWk/oc0pE2x1ua6JfebZLHVFZilWF0qQX0Ygyf3FDtt/m4Dfx/1G4zm5Vw591nU1JwsGcXlW9u3E3YLvS7pbSEaPqY8RG4RIj1jkkv+G2DaBO3NyoFPoDFU198caBeGbAa4OC2x7ibsJ9NFYyK268wAnqhrtn1pjD04SkO2P8LgVqAqRitvGi5tLUhMVBrefufWP0EUmz0F6M7pITpS0Mrvw1mL4YVaRSouWPiwQumO0fHcYOrySByBL9nbOg52/6eF8RaaPiLk3WY3ZssE8VYyFPjNH18o3+NwpKYU/LKwdRhKw/lpubtn1tVPpQo/lEZg1xFbpxm/qidph/h6uScSbq0tNds2fMylLBhC8bn7/Ih/aNvqIW6TdGSJNS/M2sdt9EqXw8EjOaVwOhVKztio1+qtaXUpiJorMp4/AcjvdlEcNCDzgkkws7th6JbDamYImgzXfWaTdyPzweetlrGmeqqk4bbU0H2aFO
 asXcx6wH
 1AKlp6nkHeKdF3XcO8z+ysTmfMt9Wh3kXgBCLru4epqtMoNrwVQrT+eWkQ0XgK8qRlmaJGBdEZkfAc7l421dwtEUygQRhPg2raTCT1oWPj/EO5f4k95ZOI2C3KBRDdpkqW4nEJM7UmRu3zcSdMOZrhznBnviKReefBbr7YYP1eE4NHlohj9+PoeoaTMBYO3Yfn9NOkbrPM7ryGu/m2Eql6m2wuy9bmXefWxNYMtXebShRhJKeiWc0NTUN7TFpT2TZ0bV2zR5baoRGffmijDo6n7u6CD07cFTj7ff7kLCSwpb3kiigcBMucbJCG1EEIUBI/5wA+7uC/Hc7ckhmm2pnHEA6oMjLR1jScKIJxDcxJ9n7Wn0Jzxmm2l/DB79Wy/i9ELCpw/ITaQGAWg3ArEgDz7f4gKA6mkTkoDBmlP89zJQ/ab0Ftas/DU+iEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 27, 2026 at 12:17:32AM +0100, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>If do_huge_pmd_device_private() cannot lock the folio, it simply returns
>to try again on the next fault.
>
>Just like we did in commit b570f37a2ce4 ("mm: Fix a hmm_range_fault()
>livelock / starvation problem"), let's wait for the softleaf entry,
>which will drop the PTL and wait until the folio was unlocked. This is
>precisely what we do in do_swap_page() with device-private folios. This
>avoids possibly livelocking.
>
>Update softleaf_entry_wait_on_locked() documentation to clarify that
>device-private entries wait until the folio is unlocked.
>
>There seems to be no compelling reason to backport this to stable
>kernels unless we actually see problems there.
>
>Fix generated by an LLM and sent by Josef Bacik in private.
>
>Fixes: 4964099163d0 ("mm/memory/fault: add THP fault handling for zone device private pages")
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>[ david: simplify patch description, fixup softleaf_entry_wait_on_locked description]
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice work!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

