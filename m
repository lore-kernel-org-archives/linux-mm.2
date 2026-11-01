Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8EE606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dWtiVPpm
Received: by kanga.kvack.org (Postfix)
	id 702F96B00EF; Sun,  1 Nov 2026 05:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4EB6B05B1; Sun,  1 Nov 2026 05:38:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2F76B05B2; Sun,  1 Nov 2026 05:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 273386B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 05:38:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BF641609DF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 10:38:04 +0000 (UTC)
X-FDA: 85386200088.11.42ABD42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1952100009
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 10:38:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWtiVPpm;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793529483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPY64yWlCtKaDiro0PGqoP7N/7OKUCSWO0JKTZUHSfg=;
	b=XPKfxKv5M54QyQo/DRQLzDmhhxlheSiovaYPK/UkmFY9uT1FpUjxgazz+rtE1Mu5YEWgN5
	FkoOBkCgKLi/Lr4s7wzW3Qswv4L73l4nlsTLiAG1aWl8aqnJ6VZEu5KpmvNTu5b4GFCVGw
	ZbWONpt8NCVxTQ25LdFgsDK6cMDScRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793529483;
	b=HbG+8VoKvUpyWr/IVJLO/E5KwXvNJ97jqJ0oRJDyxHRNQXFXINrspIBGnHOrvYWd25XdAy
	+KXgRJQrQhlce2pQ/cSRZaZFMqq2/Rt8ikhREZcRjqdrnTekdZ5FSbbSmeW9p1IlUyCZmO
	dsIFp1ECVJibhTGRYa8KBsl9QSQdaf4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWtiVPpm;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EC98600E2;
	Sun,  1 Nov 2026 10:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC051F000C1;
	Sun,  1 Nov 2026 10:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793529481;
	bh=IPY64yWlCtKaDiro0PGqoP7N/7OKUCSWO0JKTZUHSfg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dWtiVPpmRhKXcvxHHWPLMeoOn6f/UWonvIBtlm2brvj0C977bioeVIoaTTSrhZIW8
	 yqeDlO3pZOQ7/3P4d8mE1giVlCB2eu2lJYlv59mahM8JeukLP4VNjmi9snr0S7aon3
	 UNMoIYYc16PYApEhpNmT/XsKiVj22pel6CLvV7gfUvevic1W1GzU4vIyIPMU5M1gmK
	 dOPo+xh73mwwF8vg3X9tClfXnnlSLZytRNm7DnBK1AfEHuGIO6WRbo1T2OxLGKo3ox
	 YxEB0ecj+X11Wl9PFuTneU7aQXXWsJpo7wg4FyPFF5/ah7RCLMId2ZyjlpGQ/xdi1z
	 +gpMi4qMprNkg==
Message-ID: <2395821f-7fd1-4ee0-8481-91123109632f@kernel.org>
Date: Sun, 1 Nov 2026 11:37:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
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
 Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1952100009
X-Stat-Signature: hje6k7hheeenoydf4ngufa17ijdwcshz
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793529482-723113
X-HE-Meta: U2FsdGVkX19fTzCCIQb9Zp9Ih+o92LFwfzO0mNc/svQ8l90Padxt3SDgJRFCqBb7sY9CzNlb/eR4hgsGnUGMEuLQoRpU7YhvAo1m8CFH3loo0HstP2aV2WZlwJykc0LXCeUXD3d+yTnuMepmnYM8lpMqTM3m73Mb50VFN8hvGYg8IVtAux8Kbvu5rFmEZZ3oAjQGjnEubp7XrFM7eDq8x1di3PwCIX/+SgqEX7bKOPI/pWpr5inMPlsOVvRQW4jp4fTAgfMWw4+rjJT2aGskvSO3HkbIn8NDczDJY5yZ+bCzr8JqTFQFObGsb48jM4uQZRusF1Yq/m07Kne6VAWGEc+F2WwlVkSTlXxvWm/n7hjihwIG/P3zjUZHblYZfHcjSuAL5nuNtQCg9c4vvxRQSZRGT6suc8MOmD97Ay3A/bHjz4ZEoLM9xrpxxOIZhaSiOuUsC5FLKGYGb4TIFf5zdlHGEYyOeuEBHDpOiFdjbzT/9iAaeMfpPxjQVX52aGE6gVTlIds+04N89qSKn6DFtUlhWRz1kdA2Q6pv/zf00AMChToRcXHCxGGMglGxOefLAupdZ2DJ45teVDAZ06S7sR9eHEMnWGhS1yDKynASzaMfgiVFhlmX5y/SyTYP0boSPMkDphawffukIW4SxAgEScy4P8nyzCcYn6+WsQLf9JSMKBLaEmEtaYRxC4qc0HHt6f+pIvmkW2q3vJrSVxOXL36tY2SzhftcaJysrAoWlsH60ZKG3LDLToJdY0x/HXtofxPdtkLTxrkCZtZYe2unUDi24KlYzgyjhVkL5GezYL9yIIMayXYpc4j/kcYoT4SoE5eqNp65Fv8v6Dw+MyZC9YUDlKDErSIArOEWnNYSSWm7SdZXzunO/MwIrh1zcnUY2qSt1ogUPUZRNJUTmNYlH4o/xo7787+TjpN0dC9giJzK+oP0HBZOQ/bw/oSF46qjUfCeMfeW+wu+vpEhvDH
 01SZz15n
 fDl2aiJsU9uLDYnCITuD6OurrSPENdyxFamyYO0kx37djCq6Aoyqk9/13xlgngh3fotDXLAy2I2bhHY/sN1FetoKWpfGrl08vk624hr03RhmeJTcIIvUEe8pir8ZXV/Yns47ODV+JCjd4Ibuv+rQscyrtuH9JHjNBXhKGnXtnbvqZjxl0bE+iIdzJdslJuZ4j7rYrY3U2SA75RHQJORXhk3FlzSTx0eGHdaqieBJ/YMEbnPz5zewwniuWJTTi+EvsJ/kkVkxqUZmxFBVQD6AOAih+tr0kRrdXsWpyT2JDJYN+BzCz7OE7Y59DbJbBFnnimZpWMJbgc2IRfagC4/HG3iCRmiNiOp8Iubkh4aqUvieaou8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 22:34, David Hildenbrand (Arm) wrote:
> Hi,
> 
> several MM updates:
> 
> Make Zi Yan a THP maintainer (thanks for all your hard work over
> the years and thanks for taking on this responsibility), and perform some
> MM MAINTAINERS cleanups.
> 
> Then, start the next step of the transition from Andrew's MM tree to
> separate component trees that all get integrated into the mm-next
> integration tree.
> 
> Start routing shmem through mm/core.git, adding me as a maintainer
> primarily to pick patches.
> 
> Then, target the following components for the mm/core.git tree that I
> (co)maintain:
> 
>      - MEMORY MANAGEMENT - BALLOON
>      - MEMORY MANAGEMENT - CORE
>      - MEMORY MANAGEMENT - GUP (GET USER PAGES)
>      - MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
>      - MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
>      - MEMORY MANAGEMENT - MIGRATION
>      - MEMORY MANAGEMENT - NUMA PLACEMENT
>      - MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
>      - MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
> 
> More details in the last patch.
> 
> In the upcoming cycles we'll then route more of the other MM components
> through different trees.
> 
> Let's see how this goes, in particular with the continuous stream of
> fixes. But getting these in in a controlled way has highest priority
> right now wither way.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> David Hildenbrand (Arm) (7):
>       MAINTAINERS: mention for-next branch in MEMORY MANAGEMENT - MEMORY MAP
>       MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
>       MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
>       MAINTAINERS: sort entries in MM sections
>       MAINTAINERS: add missing files to MM component sections
>       MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
>       MAINTAINERS: route more MM changes through mm/core.git
> 
>  MAINTAINERS | 165 ++++++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 105 insertions(+), 60 deletions(-)

Thanks, and congrats Zi!

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> 
> base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
> 
> change-id: 20261029-maintainers-e2699bff7521
> 
> --
> 
> Cheers,
> 
> David
> 


