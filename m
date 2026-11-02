Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D30F606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 05:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UuwuZrpR
Received: by kanga.kvack.org (Postfix)
	id 9DD9C6B00EF; Mon,  2 Nov 2026 00:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9665B6B05B1; Mon,  2 Nov 2026 00:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8072A6B05B2; Mon,  2 Nov 2026 00:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFB36B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 00:42:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE4371C464D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:42:42 +0000 (UTC)
X-FDA: 85389084564.24.30FC00A
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8433340004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:42:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UuwuZrpR;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793598161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiW8Mroe3U2+fZ+1bplzdhcNfTtvPuhlvwZ0rPfG9Ps=;
	b=Qok1pnr1o8Ecu+vUeKonw29fM7TVUaY3G3hgepi7mcd0g5KKK+U83uhUpocAZVdmh4Pf3V
	Y5yYEw4fikf14i6gKsYWBjDXbw5vNla6hJ2UUmASn6rkqzdll94FsxxIE5AAH69P25eCCX
	nzSHM6h6562H3MPXL6JHJaupup11o48=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793598161;
	b=S8EGB2I92rimaRutsLV13JMrTew2Ks98kGXXXVOtiw/svcTUiaNchFk83F/u6pZzgr6eH/
	QE+BbQ7C5N2O1CgJlKrLwbWD5gF4j3kHGV6+TI/l0NivxaYc0/5KqQuL1FZiyFlytKr1RL
	9q5QiRrcFGtfunVk4w9uyniyO1H2+P4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UuwuZrpR;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MiW8Mroe3U2+fZ+1bplzdhcNfTtvPuhlvwZ0rPfG9Ps=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793598159; v=1; x=1794202959;
 b=UuwuZrpRkQYutb58GVikL5ByJkdXkY5hrZ320Ad6t9zbKbpIWUeWtzUj6e7jA2gUDGMoLrrH
 gUeLCTBMp061JCHx6Qhx3sjIJSwh8MQzoBlRonU4eD5oEI2+kpHt3ULEzO6l5PK/syFv0vJ1f4r
 DZ12u63g6acTOpq0688ukOGg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9704e208af575192;
	Mon, 02 Nov 2026 05:42:37 +0000
X-Mizu-Trace-ID: 9704e208af575192
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
	josef@toxicpanda.com,
	stable@vger.kernel.org,
	usama.anjum@arm.com
Subject: Re: [PATCH v3 16/47] mm/khugepaged: fix PMD table lock leak in try_collapse_pte_mapped_thp()
Date: Mon,  2 Nov 2026 13:42:32 +0800
Message-ID: <20261102054232.36829-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-16-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-16-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8433340004
X-Stat-Signature: ym8sct7sopyxz18a5cutni68x43s3tgf
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793598160-411441
X-HE-Meta: U2FsdGVkX19DhrjMEHmtC3cM0m7qUgBi+0EWpOCIw5O3/ZB77hjh1o4aP710JDhDUW/S8VBFjDcrSI6+7mNjG1L5arY8vbbi58YjTEeXgQQnoADkgOyHzdQWNhIX+TKFygVx4jk3VUgQP/c6SwZp0dgL9j4idM3KpLzrtuqnl/zHPLcruVQiXHrX+jTg+Nv+9KdPIqMXDRfnwIHeoLbYjoQEQwyjOi6fMjLnh7rZ5KU/s34oIu4qmPy8MxECI3NLiZ/ysfKtZ2+sKGzvgXx/v10rnslpG6nzhuZFv09lJo3YJ+eINYKKpH9cAGotw/dyBJDTkvGJStdr7ImF/GEn4zuNcDs9/vPOq/J96IqI7S/3hhx+KwhxcfZVR1qyHJNgthhpCANMWndwZW2PVnDrpW+Ui4LzsTwbA5Yziq7+bBZR9JGLDNGRyt+odURH/Ufl2q+3AbGjVJ4ID3/m4tnV5Iehpgm62swao6AS3hbneJDBc1a6hQEvhIYpXfQLnvNiSjAs0eg7YcSm2kY2j42CNhzJTgVd1Ir/SkwlmvDVLuNVBIW+aGjp1gfDpI/9/chn8tBmwGFwlPbit1xmj/ZOUBRF2G9JMiw0B6H/k2A5OuDuQCCaPxY8Va9xtK4YOfn4JpOO56BzhdimeDgA9GfLy+OcZ6BIfRiuGPReuBVwv3XgN0OTrapVeDdtJb5QvgdVfSx/v1tkhg1iC5H9KPk0tjGK2g9bt/JLj9f/oPPnOmaxlzhD8lzra6kfxmw5EhmtkcV+juGO7kfelvllq4HrtCpNApnDdrp0cfZPtuerptqHt9kfPZSikoKLTz0SuQsft1ZIMabMvNTdmSkBWR5TAWwRoV+RcsNBaAzxDwACQtkpB0Yo7yIN6Ng23nGexFseCesRsTSQvounCF5ayT+b4Pl2SozwHaRQjwk09bMJ/IYKiR5kX9WodnwVrmkDBjNW47Kz3JCQnD3VRz09NdZ
 hlKclQlF
 tLc4zcIed4Kd5itZmyVLM+accGxyJJgsE7kHmOoMgzWeE4uNCb1s3cfkuFyIe8ia4cE6S3d6Hqg3BKI77FQdojK1YqqeOZ1PobQuR9T44bK71e+7wS7t8xHCDl7P3kQlN+qYc0E9bjlOhSOcXntAD6QenONqZGjsXt775vf9Hc9Moo8LTB4emyxyAjgmukBrbUKnZ9g256pEOGjWd/fsEfLvDalnE9+XJ6VnytawXq2scsk0c2h/WMGb0VWmKvH8NJaozmtwa3tLcAXuU2Dj5+uM+pnLWJJZ5jDQrMimLTJc4sF1bqMOwjcCBAg7h0v9cIF7yijQeveCQ2gjjKlR/l9FgE3/Vzo6CQplp9x+tyuRIRG4ff+cYn7iOKFswr1NehRuWa91/QpyGrk3DoNQXwxSdxkmokQdSa5ntRKY81nGfS/MxeemgDQPxuJJ00IaC048MR3zDVZcU7OlAmq50Z1DsIK0YKT9rjeVtw9SvmYVhaY8tfSuXC3Ft7a+P5XVsUDdCDsqN5ZbqDuafFP0xJEZ5UhxU8bBDC18V2pjYcCaaI0QJrGZqPmobQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:39:45AM +0100, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>For a private mapping with userfaultfd, try_collapse_pte_mapped_thp()
>takes the PMD table lock before it maps the page table for the second time.
>If that (pte_offset_map_rw_nolock) fails, because the page table vanished
>in the meantime due to concurrent page table reclaim, it leaves through
>the abort label, where the PMD table lock is unlocked if it differs from
>PTE table lock.
>
>In case the PMD table lock and the PTE table lock match, which is the
>case without CONFIG_SPLIT_PTE_PTLOCKS after pte_offset_map_rw_nolock()
>failed, we miss to unlock the PMD table.
>
>To fix it, forget the PTE table lock when we unmap+unlock the PTE table.
>
>Fix generated by an LLM and sent by Josef Bacik in private.
>
>Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>Cc: stable@vger.kernel.org
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>[ david: move the ptl = NULL handling; rewrite description, drop wrong comments ]
>Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

