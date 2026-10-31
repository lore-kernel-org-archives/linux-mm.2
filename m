Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A669606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Sf4dsc/8
Received: by kanga.kvack.org (Postfix)
	id 67F766B05B4; Fri, 30 Oct 2026 20:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F146B05B5; Fri, 30 Oct 2026 20:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DCA6B05B6; Fri, 30 Oct 2026 20:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 335866B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:43:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB91B1A0904
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:43:14 +0000 (UTC)
X-FDA: 85381072308.19.27F04A0
Received: from mta1.migadu.com (out-168.mta1.migadu.com [95.215.58.168])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9CE3DC0004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:43:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Sf4dsc/8";
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793407392;
	b=hLCofApmqvd8x6LaMTtZpReCNnvrYhFfBV+4/t/lGwzPHxC49kNRX1sPDZraqXhF803X/M
	zKqh8LrA7ehmZLkEZD3GyzC01vi2jUdcvm/v2GckokoOXQyd4eZHGhc1qaQk6bO1o7Tml8
	EFJkP/tQDiqwXJ++UjzNNgg9kPv5vq0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Sf4dsc/8";
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793407392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hs9ww9OWyyWTWd7XYZJCVayYLvTIQuyzD0QuSnMbhZg=;
	b=IoR/OvZGwyC8WiWDJX7+udi5ayruEEZCfJ0Xy8EiFocGTtqknKY0w45xM+uINepBM6SHdy
	t9SRkkiQzg6Sp/HcMjBzs7nl4md/W+KUApOlyzz3SAI39pLhb+VwpnhQRrt8NxP+bj6ah9
	NIDIIPNYApu1msCPcTR7/m68lbLRpG0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kWjkjHMuIQ/mRw2cul8HJjHFpbEMvDl4j7cCQ9zauHA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407389; v=1; x=1794012189;
 b=Sf4dsc/8F4076h8jMVHI7rNf+3W1b/61uDUgqP8E5HHTLPa8nU5oc/o8ISUg13IlHCWcGKQA
 UB+ZLth8Vkc0MHA/p9oE12VEqzKr9FC9ymTBDF+Ig1ksRMNz0jQewv0eDvmcSLdmB5OR8+ivAAv
 q8ZwWLwKtsEl0knW1TygDsEw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 86d28ed59939afc0;
	Sat, 31 Oct 2026 00:43:09 +0000
X-Mizu-Trace-ID: 86d28ed59939afc0
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 5/7] MAINTAINERS: add missing files to MM component
 sections
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030-maintainers-v1-5-97278f8a5f54@kernel.org>
Date: Sat, 31 Oct 2026 08:42:39 +0800
Cc: Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>,
 Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>,
 Dennis Zhou <dennis@kernel.org>,
 Dev Jain <dev.jain@arm.com>,
 Gregory Price <gourry@gourry.net>,
 Hao Li <hao.li@linux.dev>,
 Harry Yoo <harry@kernel.org>,
 Hugh Dickins <hughd@google.com>,
 Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>,
 Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <815030A5-DBF5-48C8-A585-CAD27089E599@linux.dev>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-5-97278f8a5f54@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: 98rehz54jq8byhdcmj1mw5enn3nm1hsq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9CE3DC0004
X-Rspam-User: 
X-HE-Tag: 1793407392-232744
X-HE-Meta: U2FsdGVkX18jNfz/hckKzTtQX+fIBP6QuRHZiyQfJQvutBeKNm9f9Bu5GptbCfX/Axd/334ZYTEkocnB/dtvbodGGGmRm/m2uaH/t9QE911R4HAOWqEGbdz5H6Bsfce0LC9UJ4ewrHQaVZuOURc0WHSRFzbSwlGHLMkopsBVN8pPck1A6oXiDFcvpD/hryfe2L2Oqk4u2oHBrPI+1aNp+/qGyR1paACQT7/xNVr9YVsKn5IZFOnclgglysmT00xuelJDj/pkSZGNknzkR1C+pm3PRRVpwE7w/Ltq0bW73JMcdTx+n1mT+yF9cSrp9dJS4n3xqRGt4uvQqTVPbGRI5NJHyNvRb7MwWJsXpbCkyDAgheTj16K3rJpRUe9XdvSxUPyVgAneQ0OGlSPbYgujIwAG4NKjTTxuS3lnyDrO8frHtN9ehGBYI7yMmazCIuf6xG7VbPRIEf7mZUDpfuFRaI1n7qnyrMrimxMrCz9NFKjDtP0A0dD8oQNVVbCclolrR72y5LTUWQL+E0qw0DkDqdIyeWuIFXffByWdXJbhQ9z6LgTCTWsJL5C5AzpLkBZm6vrLq708hLRr5mJqgqd4K4VUDswctZLdDByuW1EW54IjAc8ob2QxLG8wPofYay9OHh9uAz06wu8Wr8t37zDGKxYnWA++ZWEccQrewIwGvozZrCVgHOcy439sLSDxi/TYpXtei/YO9rigm45M9n3SkisIfmts0U7fonbmFPqPDPIskyknW2Bv5ftdchUCpRC/gqKOOHPmWMmfRP7d7ll1xHRwD67+RIWeUfKuv6j4wLEjLAXmR4xHpP7eeiPCihv1jqOQrO43lqpECajNqmRuQtHPpSv8yuWqvLX7/eXEBtmqOPO0B8g4VdY+Oa2QaSHmh0TUTgpj0BhqJG0s5qVC2bBnbBPnEwJXjnJgA1QdQ/7SwKZtGSK39wh+xY5NEHM3RYUgCTc61zLEgq6gYZt
 yPms9K69
 ZNz/tvHefz3IhNEmlkYQ+//Hj6PdGkPSxJ3tGbn2dunMkcbAQvW8B753eHCgXo0LazkhT5h9CgG49qD89dPRYzilCebvWVmNfwTTMwixntionNiebRo4QNb9Jj4DCTKfWlbuMqBzyH/AyE5qfJGpCFs4mtRIUY4AWM+UI4lmZvQ19UDZKsFrj5GKjGNYCpvjNfY9zqz7GYpfSDLC82d7aGTONXlwxNdxsNwDEs9wX9K72IfeLMZ3wtU0VXAbpmm37NulTEphjRJ5ukl+dtcUJWlaZV+KcggX+wzQ+RdIKhr2Th11aBCWvBO1pGeIqiIq+jQ9NdWa8DjR6Cmdtsc5BUK+rBsU3HLcR+4fq11Hv9Hw9BTt2OYjeHK5i4RlkPKFdxmpNTIAylWcaknb5Af0AnlbI67FjgYS4i8mm3RMM3KVPjwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 05:34, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> We want to make sure that MM components cover all relevant MM files. =
The
> generic "MEMORY MANAGEMENT" sections will probably go away at some
> point.
>=20
> We have a bunch of files that are not explicitly tracked under MM
> components. Let's add these missing files.
>=20
> Split up tools/mm to the appropriate components, but still add it also
> under MISC, similar to what we did with selftests.
>=20
> Don't split up selftests for now. They are covered by MISC and some
> sections name them separately.
>=20
> Some files like
>=20
> - include/linux/numa.h
> - include/trace/events/kmem.h
> - Documentation/admin-guide/numastat.rst
>=20
> are a bit fuzzy. Add them to the best fit for now.
>=20
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> MAINTAINERS | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 50 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bc82ef545e0aa..98948d159173b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6841,8 +6841,10 @@ R:	Muchun Song <muchun.song@linux.dev>
> L:	cgroups@vger.kernel.org
> L:	linux-mm@kvack.org
> S:	Maintained
> +F:	Documentation/admin-guide/cgroup-v1/memory.rst
> F:	include/linux/memcontrol.h
> F:	include/linux/page_counter.h
> +F:	include/trace/events/memcg.h
> F:	mm/memcontrol-v1.c
> F:	mm/memcontrol-v1.h
> F:	mm/memcontrol.c
> @@ -12349,6 +12351,7 @@ R:	David Hildenbrand <david@kernel.org>
> L:	linux-mm@kvack.org
> S:	Maintained
> F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
> +F:	Documentation/admin-guide/cgroup-v1/hugetlb.rst
> F:	Documentation/admin-guide/mm/hugetlbpage.rst
> F:	Documentation/mm/hugetlbfs_reserv.rst
> F:	Documentation/mm/vmemmap_dedup.rst
> @@ -12360,6 +12363,7 @@ F:	mm/hugetlb.c
> F:	mm/hugetlb_cgroup.c
> F:	mm/hugetlb_cma.c
> F:	mm/hugetlb_cma.h
> +F:	mm/hugetlb_internal.h

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


