Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38670606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 04:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Hd5/4EfZ
Received: by kanga.kvack.org (Postfix)
	id 235A56B00EF; Sun,  1 Nov 2026 23:58:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6D86B05B1; Sun,  1 Nov 2026 23:58:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D67D6B05B2; Sun,  1 Nov 2026 23:58:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2B366B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:58:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6089EA0BCD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:58:08 +0000 (UTC)
X-FDA: 85388972256.17.8A17C07
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf29.hostedemail.com (Postfix) with ESMTP id 310FD120002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:58:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Hd5/4EfZ";
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793595486;
	b=4fDinKhQQYgY+qgcEV3hnYL60fubWxG4O7c0AUWjIy50ymTnQ4ziqb36VERjSxkzROcuSx
	xzB5JTMMjane85O/GJB0UmoensVw1nDK/hHvSxykaD5l10nezkmvNsEqsK9Cv/s78Nh5wg
	rC7EuHMDXWqrLPcDeBhut33bAzIP/pM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Hd5/4EfZ";
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793595486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjEa8aUzoMl3SYNFpAhF7zUKPZ6wHLLQaYP9asa0BH0=;
	b=pbCLkkSRJhfnFqRxsASPTLNucFQNrzWNHKPVKRS0rxpA8RHx0N00kZAhhjTioEC9ugrT0s
	qxsfWxkPfbxyjqEr+AU2Qu5DGvUVmJy/vJtWwx8zsGE2sP26VbkEk7QdVxU1JVKVl+hwtl
	5EUC3aD85TNpE6/y3gjeGTLIiVuTffk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VjEa8aUzoMl3SYNFpAhF7zUKPZ6wHLLQaYP9asa0BH0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793595483; v=1; x=1794200283;
 b=Hd5/4EfZTqDJhoJQj3RsxtDVnqKy1aamG9WHQGlhuYDbiUFMRMuVUh4U5WZxWeDr/5mCNBgn
 FHjhJk19Z2BSSg+yJ71g766NnsgHdRSQLGkOUEsKwe+DVjg5v3ia4eonJn1QqSAdzJyZEe1pud3
 zdEAiA5fQmMfolu9HsRAjM9w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 36faa33dfd74c51c;
	Mon, 02 Nov 2026 04:58:02 +0000
X-Mizu-Trace-ID: 36faa33dfd74c51c
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
Subject: Re: [PATCH v3 15/47] mm/khugepaged: always recheck the pmd in try_collapse_pte_mapped_thp()
Date: Mon,  2 Nov 2026 12:57:53 +0800
Message-ID: <20261102045753.34901-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-15-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-15-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 310FD120002
X-Stat-Signature: nxwscgwwjfy3x1es8xojgd8mhshrmaz7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793595485-936898
X-HE-Meta: U2FsdGVkX1/WeWK1RXeHSWTKyIk9HfqMUfkthpXx+jDos4gloz7cP7c1b7rvirKK8fAgU+YkLLlCLpAER7tZqzivSBH2cAaOXzwUXfDxaRTUDdvYbljaI1XxqZx2094UN1oHsMEWGvKDbnqaB8hfBnyHwvZozQJMW6bhDRNWOveTgvURXlh3aCLJsFPWQirZ+tRJhHbj9ljvftkgzqIxeAwGQOxC2znlSUiTYf1IpHBmzx8UHap66Jt+JiHrSHq6yqLxKKXNKDeiVzwsmBb48sq1FzISbIPWojg0oSpMAsw3ZQr/48nCUeH9T8BtWV4GkCW0b0kpx/5DrGTXH328JSS7LEDgEukAK4EaJjmcE8NCciYX3qnhmzFXllA+sjJZJyMHEYfBB8TVrEXuZpP+qDg/RbEAzGs6+6AYE8ADcKSe6UZNeFQgFZqHLrCcj/bgZpkd8Q0oKETgB/zKrBcxiU0jp5V6Hlha5Ag2nZSR6MbD6UF5t6oDKodRzQdRBX4vN3ooBbMV6YSDvwuvzrrgVGlQ/VZiAXD7li9WZKKIjVb24COY9BTc8Ze3Gu9d+lH3nrUlUGG3GRH21wX8pVWgJoREgFbEcqHFKwk+cLe2E8rIswSgiWZP9wraFcHCOaVVUSXrusGGW9CN6AbJvm38+c+nQaYIuyZi7ZMP5sNoGd64ip6xEZZ/EZfo4rgnuRWNNXwVHJ5aCn2fvtlZfvE8W6JN4dFbgz9z4EeHG6Hsq90MUWxNA1pq2evhmwdly8w2TPv4BgTiWOON904nbw35aN+yf5lQbABJYSRxwG6HGE5cx062uIDU6jz9lN828LEXz4hw8VCqPVfueK2S+L8YGNw2nMFp6098Ku5od2te/iu2uA3Rc67DxaurvuQbN/+qnLG/mbQmozylko9pgvzVp4C9wQKwnWqohxIqi+/eq3nSlHR6iFhEccRvAfzNtc6zD1DwksjYeC27pv0BbcO
 vK3enKX3
 OjrijnAFpCJsu2mmdRColayaStNW4TNQLMhx3GL48xGyMkd33apuV9vOY4GYoTZFUK66AG4js4DyVTh/S28A9iD8N0tgn2C8jhkNXo/ZswP41/xMLhDPtuuOOPIH1PB/lVdkQgs2hV3OnN7KtxoiGCGHKYn4NsWk+lFxSWiFm8Xdp0yTKX2Lf6JICU/9R1UjZd1X6R9ztYJ7wKLEYmQMojLsHlO2IJOb4xHticYK7KzngZNabNq4sz3l22I+YWGEGUqsnSfecGpLltYaatzBvlhDie4rUGZK3xxgoXZQ1mfJTKnkznzAXZAOozqQaY0PLh32CY9FMOhA6dAhGE4vKCORdKq/uXYB+Ilu2ELPWaSa4qHuf+FlfrvePqpFIIm74kg1gH1cHsxJNa0M0O2QIZxD0/pO7HAZEnqyjSqZYd5KBGRZ0PJXRAU8u7/Qg1uUXvf4dw9KG80JugcTddZBk0o8FyyzOgmXcMSD3f+7hfcajounk6rs9zz3u9m65FyX7biSxjTDNs8pYj2krcjOmTiEtkM9MwVJt/OgzNrfStoOuTpJYJc2u1ZwHJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:39:44AM +0100, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>try_collapse_pte_mapped_thp() drops the PTE lock after it has cleared the
>page table, and takes the PMD lock and the PTE lock to remove it.
>
>In between, MADV_DONTNEED with CONFIG_PT_RECLAIM can reclaim the
>page table. The pmd_same() check is supposed to handle this, but it is
>only done with CONFIG_SPLIT_PTE_PTLOCKS.
>
>Fix it by performing the check unconditionally.
>
>Fix generated by an LLM and sent by Josef Bacik in private.
>
>Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>Cc: stable@vger.kernel.org
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>[ david: adjust description ]
>Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

