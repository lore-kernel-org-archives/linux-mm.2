Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08E5606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Wr/qaLu9
Received: by kanga.kvack.org (Postfix)
	id C5D966B00EF; Sun,  1 Nov 2026 21:01:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EE96B05B1; Sun,  1 Nov 2026 21:01:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00D26B05B2; Sun,  1 Nov 2026 21:01:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8963D6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:01:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF823A85E3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:01:50 +0000 (UTC)
X-FDA: 85388527980.24.5F43CB1
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf04.hostedemail.com (Postfix) with ESMTP id A2D9F4000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:01:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Wr/qaLu9";
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793584909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhak0MmZxZsDBp8302xnXT/xyZGUloAlWeCi+dxqbB8=;
	b=hnDq95+WchbIgbUtdaYYbBSFrioQztc/nOKmjNWjgeVRwRu1jKbROuZI6dsXvDW4XcGKKI
	hBgH+YeG3jmRYVR1Up0tQHTiXrH6qLxhh0sp3COaM87hcxcyzCfx7mB8MNLnM1xoRaZTq1
	HP0G4mw80xSaNwW6F87/wrwk9b3Mx0U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793584909;
	b=v+d6b/zkvc5oBJAqMUHTNkCdxn4xSoRTLwWbErF/6ARDMqkMaV0+XdJjjiQxjj5Xnpoz2U
	vb/PLYT+nGMbvSMDdo3W9rpmdNC8zTieBuNAnnFZyfYI8WH2Etc+dYasfBRiw8W0hPfY3/
	8//u47OysfS6chVd/Ua99Q8bIJU/fk8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Wr/qaLu9";
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793584903; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jhak0MmZxZsDBp8302xnXT/xyZGUloAlWeCi+dxqbB8=;
	b=Wr/qaLu9mKfMdVJgeg8uBCdh7AgeBjSK/lXooIgsS5JzhzixX76QdKTV9v7pxjlBS44NIMGQ9SHKbFsc7C4QQsiDP7c1X/NfL9dsIcOttiiQFO8DhOL6nhA/g/qwpvytsM1yVpA3ATTkfP9QOnaC0fZumb4FMbjrKT+Xi4FujXw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=61;SR=0;TI=SMTPD_---0XDrTDBs_1793584898;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDrTDBs_1793584898 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 10:01:40 +0800
Message-ID: <1b7b47aa-8523-4029-971f-ec59b667c7f9@linux.alibaba.com>
Date: Mon, 2 Nov 2026 10:01:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>,
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2D9F4000B
X-Stat-Signature: qijd7rsnqowmknokjcwjxd88hgxkadih
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793584906-654994
X-HE-Meta: U2FsdGVkX19mAFTjysd5iyNLCuvBfws1mOC0H23T6M7z9TCmClnaqlp8fxnRN4eSYs6bcpocfbLMaug4cLdv87fOuakyaMuIVq8FNnK3cc1NiB53nti7CFvFIb01MY55EBszxMISMQlLugovRhhhBDlMRrYv6AhU0UiOMGIrUeAVrpy0xVrLKyyFUpe/E1jQlQEHG9zKAKAwJZlGZRRVr6mzaDg98RoKGSIWl6ns16ADAt3OSlfh2w57kL6vJU8ItzErgs5Yj2l1cRS6T0N9uTn+6SScgbVvlD3tB60a2c6RoMmhd1Nx2zbw5VwjhalG1yMuJS70CGHBlu1CjwfWEgQmv99q074m4myPQeUjOYRijKKPHC4Z4fCFehjqG942rJZdaGhjYYP+d7Gy/h513liZZF/H83wzPS+hZsHI61m9ZgcxeHoup3tgoLrUFnRbktB4xe2Ma37FSAMYksZaOHk+i0ZFt/lumo41PnnTfun73o5esYOZArVUyo1vjj74gFlomeUAtFVOS1OwXEWPEwqMEN5Vpg5EP0OrzOXTw4msfgQsttwwN/81POl3KuWJy3xinn1F6Zx3wzCGKnBEo50LqbL7uWarVATK2PLLTyIUKMh1F8++1hnZW4BC4vJGxAMy9wp2BIQItsluwoOSKm5p0HegWnMPt/DbRXkOitkFbJER+BbSvpptd6TF0NNe06eEFo4ja88HaAtLp7oXp7j0jKwAQuHl7AXfDnFrkl+DmaYarAlsdRrHau3L11Qc8hVsehhWBk/r3HyojomZgWDAdrIxXd1ZpvX93XKhUJOossc2oOO0YuCb2z4oJJrCO53tbS57kpXnJ2pT5W3peZ7QvF9kCoZS1n6MzzeEcE1LdfRwYjt3Rp7cyQK5zu9OcHQVRiUl2I1Q4e53yhvy/GGhf58gL6rMa6bKpRyoXaAyNImBfe/HnIZVwo0Nf2afOtprMbfMxpDbOoVIaa2
 Cz9ZuaPk
 UTAieA75dVmIMg3xrdZ7dHQP8Y+FvB7GhljPj5FB4jvZxHXd4hWBgQuwl3muRRBJOysdI0MKgtdnlloCQUex8ojcq9BTGv/CSLMtNeOeYavUkMxguWdwt6CElrEdO/T1MLvAgsxCDjTET3Z6ofEnDXfpr5MRb91PgTwzXfKe5E/Fa6+4LXaAstl6DwV3p/w1pjDxeAd+A25y6i0nJLCDru3u/H+fV9NTyXa67z8iHKbTD1zkiDyNqL/2ANnamrxNT40THgvzVvVJCh3kdgz7Z9ygyR9w6qwm99AtEw+hPOQMm74AQBVIRxR8Eh7EsTqopwLGft797VVoR/oqgqOkes5kLrMQDpvnkPufK1Luk8ZyQNaETsCr5y9dB38undbT3I3pgkmxqx66FD548VJFQmEBoig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:34 AM, David Hildenbrand (Arm) wrote:
> I am not really the best shmem/tmpfs/memfd expert around, but it should
> be good enough to judge when something is ready to be picked up, to then
> pick it up. I'll have to heavily rely on Hugh and Baolin on judgment
> for the more involved and more controversial bits.
> 
> Rename "TMPFS (SHMEM FILESYSTEM)" to "MEMORY MANAGEMENT - SHARED MEMORY
> (SHMEM/TMPFS/MEMFD)" and move it accordingly. Add myself as a MAINTAINER
> so people know whom to CC.
> 
> Add mm/core.git as the target git tree. Once shmem becomes a high volume
> component we can dedicate it a separate tree and have dedicated people
> pick it up.
> 
> While at it, add some more shmem/tmpfs/memfd related files+directories
> we missed so far.
> 
> There is also "kernel/pid_sysctl.h", which includes some of the pid
> namespaced sysctl vm.memfd_noexec. But that's really more of a proc/
> namespace thingy, so it's not a good fit here.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Thanks.
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>

