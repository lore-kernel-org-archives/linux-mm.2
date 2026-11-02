Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29BA606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kjuHoq7Z
Received: by kanga.kvack.org (Postfix)
	id DAABA6B05B8; Mon,  2 Nov 2026 05:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33AC6B05B9; Mon,  2 Nov 2026 05:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4B66B05BA; Mon,  2 Nov 2026 05:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 924546B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:39:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2320440C38
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:39:23 +0000 (UTC)
X-FDA: 85389832206.12.EE61828
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id BFD2420004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:39:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kjuHoq7Z;
	spf=pass (imf13.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793615961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXPkduc5HmvcD4JbyCflilxUkIbcOVZyKgcYfnLDPdM=;
	b=5Z3cYbK1FzJPb1fG5npYYSYQ4nDCwhhLuvjZJ0lqre8ObU07L4LHOCUM6d7lF5BZP3kiyV
	1KaE+drwG8zhWW3oOdE6Ca/DQb42gKoFV54vcqVIkEHvNtSWtJFFn+eQk7Pba8gvpidRtG
	etDd+HIK0zlWkfBni0rSq420X1Y7OEs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kjuHoq7Z;
	spf=pass (imf13.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793615961;
	b=lIEumWCHorfJh8clG4vhL6W5QL4pw2k7Wt/EB9qMxYv9kJjuinXPdbMXOtMSl5uylvZ8lE
	DVrdsuJv/tlrA6lGymEjcwAtVJxQfT6TUip3/BHvmr/bIREU2de3+t8PhyGSR7n3mCIGeQ
	3W/jYTnA0LwZ5bqMCPrwlcmC/pg7gyE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g/mOLxr73xiPzfSEauykXJcCVgHJm2aXb9jWqKek3jg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793615948; v=1; x=1794220748;
 b=kjuHoq7Z7WInoWQjvZyWXCq6fLcyusxA/wCxez4d8Pyx+CwmRFc4uUR3ShfNvGhGHMUT3+HP
 /G1fYZPWIznutntr52aGAg2slMISGBWg0BtWi9p7pPPh9X8UUm5MJAgIMWouR/qsesR6a5zHsUA
 2kKl7WCLwMIhiRGwVbPnT1pQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8bbf69835e69a785;
	Mon, 02 Nov 2026 10:39:08 +0000
X-Mizu-Trace-ID: 8bbf69835e69a785
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	harry@kernel.org,
	hughd@google.com,
	jack@suse.cz,
	jannh@google.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	josef@toxicpanda.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	kasong@tencent.com,
	kees@kernel.org,
	kexec@lists.infradead.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	minchan@kernel.org,
	muchun.song@linux.dev,
	nico.pache@linux.dev,
	nphamcs@gmail.com,
	npiggin@gmail.com,
	osalvador@suse.de,
	pasha.tatashin@soleen.com,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	pratyush@kernel.org,
	qi.zheng@linux.dev,
	rakie.kim@sk.com,
	riel@surriel.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	stable@vger.kernel.org,
	surenb@google.com,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	weixugc@google.com,
	will@kernel.org,
	willy@infradead.org,
	xu.xin@linux.dev,
	ying.huang@linux.alibaba.com,
	youngjun.park@lge.com,
	yuanchu@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH v3 39/47] mm/ksm: reset the unstable trees of all nodes
Date: Mon,  2 Nov 2026 18:38:39 +0800
Message-Id: <20261102103839.225014-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261031-fixes_core-v3-39-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-39-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFD2420004
X-Stat-Signature: 64ww56jmi5cb4g13iquq9u7snmyoenkt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793615960-490590
X-HE-Meta: U2FsdGVkX1+18dHQopYnSWkrb1Em/zTMdhUCAurmgwUe0M6/SxWK10vx8x8FJFG+ojjPXw61bjBg+xIGTcN7cv8qsQydAK5z8aqqtm8+6AgB/iZOeUI3tUhZBRGSBfFUxUMydXXO8ae2jA7Pkhjk8tjbchJmLeTfMtw6Id4RiC4n1fPMccGxQoF+AEQig87YGbhWpFiOzAtkMv9+671BKVYAYlVnnUjm2ctYyzMgocwtqe0yANp0k8BnyFird4cFdxpd811+ju+yaF6PSLDlMNOiwYfeZDBcuWyCEG9KX009ARC0EwqeWDbvt84e5tOpO3fFtkRrFRVCOvBSZ807LCrtFDWIPpF5J0lWnywpXBtEr0damcgRqMLv3bGaYO6zI8N2ZBEjPAVgXBjHhjIEILL7mS3Y/3+t3uJAZlv8VApuLnabxU9sh5XzvFmNzqPK9CKFzNRv5iXbz7TpJJf246eSBQF/j26hH9ANm4eUFdXUm3Ogd2ZVWgOUeFWDJEjKe1mQRWpzN345brk0lmmBzC4cMMKU6vsrMsC+JIW8h3fweSPnvRDUmdBxw4Jw8uHYp2B0NVbHZfSIMavan4UF9tnLZgolST9Vn9QubgFTFE1qcW6buKBBJv/G3DD2rwUbl+qLv36aHF6WlVOyZEQqxqnAhcENam/BgbUZehfSs8BjtD19jTdPZMSsZrLzjYb6RLeuzQzJfJ3gisfxYfC6yn0l00wv2ZLyeSJS2ly1JxIciCjdQv7vKWG1VDkXKF3sciK5OGWEPMsuJzGK0pRARbBl0Ihh+37vfA340D9V6JZFKvpSkUu/qli/kexaFq41YcjyEMmA+oTZ3IMT8BIH9LMWvgr6lpwTXXaPuGZwqZkM7pfcRM6GOqOLCANtdRp64ybfzSSvmRz3E5wbRsWTl1jp/ClokrD4Qt71HQ4xT68rGS2ULt0l5a22iENVPsN6wMJPv1Wa55zhYRxoKBk
 5Rcely7z
 VURQm5ZzHIrkbJTIqYMoRiLq7gKsCD3IUefV2v5MzngxA7B8H7a8PmY2ddtz5FW0dSIoFocovAeHwj4omcsCsNHEaZz9xEKzbr0spKoTVSlmELFE5nwkzGy/P9ucm4q8VePZzoEKpRoAAFzdTj8+okubY7lSjfuW8se0H9q5koUJ0foqLlvaDK3cGNI8e6zSf1ESOw8OElp30NMzZyVOpM9SG4VLpJjXLN4YYD+OXwubJ9LMnKkUj1U8084zrjrZbV/h7ZmOzhAnF9+q6Hh75d15+prOMsDrAP92sc0Wdk/TFyeKenKsLbO7WiJAr1FjKkPMmNwmulKe41sBAmW1eoqxzFvNrF3rUgmr4WRRTZwckFA3BCYstQRgNuhtg2/Zupiui/HZlwQQEZuxfm9Rgb7fwNozkxJNGHsthcmCGo5jEZXwFPdpuI6ooDkmNg5iYX58AEgS5+Xp2cRSphZMwE2x8nk3UXsI0GI0sQi/IGXODunexJTfGXlmDiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Each full scan resets ksm_nr_node_ids unstable tree roots. Enabling
> merge_across_nodes resets this count to 1, even if per-node roots were
> previously allocated.
> 
> So when toggling "merge_across_nodes" 0 -> 1 -> 0, a scan that starts
> while the setting is 1 and continues after switching back to 0 can
> encounter stale unstable tree roots, resulting in UAF.
> 
> Only root is allowed to change "merge_across_nodes", and the documented
> sequence is: "merge_across_nodes setting can be changed only when there
> are no ksm shared pages in the system: set run 2 to unmerge pages first,
> then to 1 after changing merge_across_nodes, to remerge according to the
> new setting."
> 
> Let's fix it by tracking in ksm_nr_node_ids the actual number of
> allocated tree roots.
> 
> remove_all_stable_nodes() and ksm_check_stable_tree() will now scan
> more tree roots (skipping the empty ones), which is harmless.
> 
> Fixes: ef53d16cded7 ("ksm: allocate roots when needed")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/ksm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b1892..9c51925825cbf 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -475,6 +475,7 @@ static void advisor_stop_scan(void)
>  #ifdef CONFIG_NUMA
>  /* Zeroed when merging across nodes is not allowed */
>  static unsigned int ksm_merge_across_nodes = 1;
> +/* Number of allocated stable and unstable tree roots. */
>  static int ksm_nr_node_ids = 1;
>  #else
>  #define ksm_merge_across_nodes	1U
> @@ -3636,14 +3637,13 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
>  			else {
>  				root_stable_tree = buf;
>  				root_unstable_tree = buf + nr_node_ids;
> +				ksm_nr_node_ids = nr_node_ids;
>  				/* Stable tree is empty but not the unstable */
>  				root_unstable_tree[0] = one_unstable_tree[0];
>  			}
>  		}
> -		if (!err) {
> +		if (!err)
>  			ksm_merge_across_nodes = knob;
> -			ksm_nr_node_ids = knob ? 1 : nr_node_ids;
> -		}
>  	}
>  	mutex_unlock(&ksm_thread_mutex);

Reviewed-by: Xu Xin <xu.xin@linux.dev>

