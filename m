Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002D7606D80C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M5WQx64W
Received: by kanga.kvack.org (Postfix)
	id 20BC36B00EF; Tue,  3 Nov 2026 06:46:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC0B6B05B1; Tue,  3 Nov 2026 06:46:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB776B05B2; Tue,  3 Nov 2026 06:46:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD6756B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:46:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79434140373
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:46:36 +0000 (UTC)
X-FDA: 85393630392.28.72F3A91
Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1BF9020008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:46:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M5WQx64W;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793706394;
	b=lGF8y4rl7XAE4hj8aJH2jG4MAjPhAFgFxfLYp2j8qbC4iYaUDXzjLLV4s00jHZtgZVhHXB
	vd2pB/kiJ8saDhbB3j7/Xm4mmD2c19HBzH/Rvlvd9+2FsgDz807QA5ZKm/SD7HV3ZKIeqI
	bKQkSxt0AGYdt/r8SmetOfwFWV/WfTk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M5WQx64W;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793706394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1h7SuxIdXP1BrmLiSW0TA0Y4x+A0dQHqIxOY0fZWzgw=;
	b=hG+9+i9Lfqx2Ad7MItlpEp7jkX32LzslR4QZ75IoEasciLYfrO7c0cXHukgiNURaeRmKpr
	TSeOaBhAPd1wJx2EBsyMzqW3MWXpQjyLzjSlEh4r8A9nOJ4kVf/8H7c+gyjdg17WlD5LzL
	IPwy3XNDzn/llhNWNUFxrMNvYFNK1lE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1h7SuxIdXP1BrmLiSW0TA0Y4x+A0dQHqIxOY0fZWzgw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793706391; v=1; x=1794311191;
 b=M5WQx64W3OrKv3IrbfaaaUU8t9LBurF+lIi1NsZf+TH86Tb8kzcQtOfRinqCLkp6vbJeJkjn
 Wdwp+SEY7bV+SCApfixGc5g2PSWIhjsr5o8DnWz2b+eULeX3U8KrowNWRCDh9p9CW2PdjVmXutk
 fgWn2GKcQL5AnmV3qr19TWzU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4c5c651460189e35;
	Tue, 03 Nov 2026 11:46:31 +0000
X-Mizu-Trace-ID: 4c5c651460189e35
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
	mason@kernel.org,
	stable@vger.kernel.org,
	usama.anjum@arm.com
Subject: Re: [PATCH v3 41/47] mm/ksm: check large swap-cache folios before mapping them
Date: Tue,  3 Nov 2026 19:46:26 +0800
Message-ID: <20261103114626.15764-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-41-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-41-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1BF9020008
X-Stat-Signature: 73c4x9fmrqtt3o6hccka8qjtaj7wiisu
X-Rspam-User: 
X-HE-Tag: 1793706393-963840
X-HE-Meta: U2FsdGVkX18cN4MXTmJO0KHkhEqnjXXI/66IbbIBAQbiqQd9lcd7ox29TkqqBgEgOcdpl0Chg8TI1LJtjWHyF2m0HiPX5AnE2duguFhmTYWm97zAUksXoASl0TvcVDxo6MEweNVUeajIfVMj19jp+8kJpnBGqdH6tw7353GgZ/cOaSnHJA0qivhf/sW9nFd/7n250qYUIYmHT/3vgr0YREHhqIk9T5m/xgYxHL1JvRorEm6c3OK8vHqUGnHzQi6KmwgDmIty5GZJt+bv37Tt4buawEiafJUiGDGTyoKgZBGIsUDRRNDPDhmZ6IhUSv2P1OzD+cb3UeJ0vOqosHCvz0+TON610FfWUzzcjfndgjx+y26XwRz82gfLHQ5RH66SP77jiGMf0N48POgb3T2qIkyWajiQWTRJzgyNeDF9xjjrjj1TS7q4RcPf1onDqH3tp7aHKL9uFlc4n4kQMo3ZB58QItBE/4b+EgoDZ11gfbBiI+xsp/x0vbHynMTtSr/fJ5VNXgUnU53MyxYUS0nc9+4t4mfajnUlpXyzPbhNOI8EZOr4ff1VfwYVCnQs2nJLRzBpDK4KIQgXIVv6TPLNKnIjG6x7ft/Ou7k009Y5lNArJHXbPvM6ZwWv5eyyccTirh002wf6U6Mi5xCUR5wtTGe6z719en96lQG0ruZwsACPfmnJJylwSNb6kIdndxP/QXFPZKhGCOdj4s3oQej9028UOR/5nIKCDWTPhTHWByb0yQInFSqQpywCYVmK4Ag/NiegMbvHy0x/AOPIHMQ7C3+8kmGLriBSeAGCVRaVPps1pXBSTddmhIQQQJeACiQO+Fub6QJo4VtIKDGU7czFCIX8BYMv+M2uL3an6Vf/8kBagOsGRgtNMIq3jhmLc9LfmoUUFVBF02cKEQP9QRIkAbwS2zSpYmCnQ1G+d9ohiiMA4kHXFBC17+av8ULzRmDDm6kQdQKVoYDnOvadkX0
 AhVvG+B6
 xzUnv5a7lLU6HmxR84f8w0d8UYSrHwAZjUzcjuu65nP5Rzc7T26w0M6eMUVlytQiTiKht1MRGDwezVVOuIwBDagZjv5wqItb+1S030wYypJ3iWeYa+oUKZcQRsRvgAqbkqGI1whJJ0Wqb/yRYQEwUutXBBCYwV75vrBSd1C9VGRPSsGF8nzL2vi3tLWPgj4uoGd6HFqwCi9AoVyrIX8mxBisKZumstDNiB0U5ArcN5JL2aGkQINTwdDirDaF4IL9du1FIABfTXfN6z0usFhLIYiImoLqSSgifiMKP9gBNB1M1LGtMCkcuAg4OEP2/s8vUn2Luxd7EkCQhfHNS8PmkXsRJ6aweo5uy87GY5Fg1qxjrFeuwjFxpF2npgKYQvriuEWbE3MvTKRv4F/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:40:10AM +0100, David Hildenbrand (Arm) wrote:
>From: Chris Mason <mason@kernel.org>
>
>KSM folios are always small, but their shared swap slots can be read
>back as part of a large folio in the swap cache. ksm_might_need_to_copy()
>skips large folios, so another process can map a page with an incompatible
>anon_vma or page index. Reverse mapping then cannot find the new
>mapping, preventing migration or reclaim.
>
>Apply the same compatibility checks to large folios as to small ones.
>Pass the page corresponding to the swap entry and copy only that page
>when necessary. In do_swap_page()'s copy path, decrement only that slot's
>swap count, because the source swap-cache folio can now be large.
>
>Fix generated by an LLM and sent by Chris Mason in private.
>
>Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO")
>Cc: stable@vger.kernel.org
>Signed-off-by: Chris Mason <mason@kernel.org>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

LGTM1

Reviewed-by: Lance Yang <lance.yang@linux.dev>

