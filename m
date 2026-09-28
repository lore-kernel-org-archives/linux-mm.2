Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C6BC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 07:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1E56B008C; Mon, 28 Sep 2026 03:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3BCF6B0092; Mon, 28 Sep 2026 03:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B50A6B0093; Mon, 28 Sep 2026 03:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7051D6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:09:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0453C0B64
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:09:45 +0000 (UTC)
X-FDA: 85262295930.08.A9FF62F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9A5FC1A0006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:09:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JYy+c8Ji;
	spf=pass (imf19.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790579383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0Sqv66/lUO5fAJlL+QxeO6e18NIiLtdJqIDVEF6pVo=;
	b=z6QA36xwFpG0xAoWOQFR3T3Ht5YK2j9UAxljJJmv7Zoea9ERgwgPLJNyQ1b1g37pcghKGm
	mcHQMZlle38ujVzxK9e71hlgw8VnxmInlLFdX4+jEBQDt2c3X8yl2iLnFnEX7ba+cUZbkP
	QO3ubYhY1rmQIyUW2EiXyZhZDYy31YM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790579383;
	b=XaJqODVv15WKq1GPVbm+3IhGke+Zkkb5q6jYO/bAL6gr27OVS6hry2Uk19n/AG+ibyP7pV
	zrFbfPAZ39KGUHmEnvSVLsoaPKkO8lrj1SLI4eBtG5Uui0FQ852bp4QAQC6nISPton1Omv
	uFuqPchtKsTF3/6gOh6r0L3qCxmEWNc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JYy+c8Ji;
	spf=pass (imf19.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68RH6Nfb3175554;
	Mon, 28 Sep 2026 07:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=U0Sqv66/lUO5fAJlL+QxeO6e18NIiL
	tdJqIDVEF6pVo=; b=JYy+c8JiVYKn8nouxfqxB62qRnE0w0KFaFzXksbh7vvAEL
	eXgYsBXTK2Q0/JC4VwMEh9Wwlyt0fkmlrYPk1hebyUUZnJr+feU7zZpKKCD/32/6
	GK32iuw74mDOqGX9iyfseMbRfLesf50WlGakV+9f53EZhKFMhbtEbO51ZWCt+ock
	/PE0Naan+UboeuNsatwP0qFylAPQ++Gg00G3nbQ/ri9MiOMUdZAZg7Or0NU9fxZX
	ewY6U6oBpIPo40E24MB0d6khSx9MkPg5zQ/6dsPbXRMVmqVFlHA8hhWnrPeRjvWF
	fheZ3R2ZDqUdhLBF01FckKKwv6/BTpjfJaIy8tMw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4fdyn2k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 07:09:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68S2DNPM2055623;
	Mon, 28 Sep 2026 07:09:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxrcpmaf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 07:09:34 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68S79W8M49217996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 07:09:32 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 602C620043;
	Mon, 28 Sep 2026 07:09:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAF6620040;
	Mon, 28 Sep 2026 07:09:30 +0000 (GMT)
Received: from tuxmaker (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 28 Sep 2026 07:09:30 +0000 (GMT)
Date: Mon, 28 Sep 2026 09:09:29 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eduard Zingerman <eddyz87@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
        Emil Tsalapatis <emil@etsalapatis.com>,
        Ihor Solodrai <ihor.solodrai@linux.dev>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
        kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 0/9] mm: distinguish HW PTE pointers from SW PTE value
 pointers
Message-ID: <20260928070929.80522Ae0-agordeev@linux.ibm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6aba12b0 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=7CQSdrXTAAAA:8 a=VnNF1IyMAAAA:8 a=B2JZ75edH0TnST5CdBoA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDAyOCBTYWx0ZWRfX36xnl4F0X1lx
 fqVE8lBCzTdyT+J+ezyz2OlTCEkg9vyu9qTQRaxPpF6hKz2talO2Fe86TA25Yp12H8ZPv7JvxWM
 qv6KcELXddf1u30q8Q260QGIdLS20Wg=
X-Proofpoint-ORIG-GUID: eaaIQGcS1nHN1_JGmMiyppMCwLEK0T95
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDAyOCBTYWx0ZWRfX1MBO4JWQdoeD
 8e/68bQLQFipsPa8y4AzHDaALB9+xGvirrZGm50ERvkR7A4Zmo+9VoMtAbAofJ7oQOJiuTUdAd9
 pYrp0fl47P7f87KgOiwiuVK6WSw4/Q08fnfRkHE/X1Ai9A6dlbWlIo7+LVVTPJLsgynXNNkB0kF
 WnQFoGn5DSIyYo7xILZ6hH/F/C60+7m9PQlSHbBx3jboCRxWsXR22WO8HeZ8+dE8xnt0UQemj1c
 huDAEphBKpAazTr5qTLXkI/vWEj/lRuVslQwgv4QIXlC9LXTKVF5KNjtqj2g4nT1s0xXtn1VF6V
 ijawGq9T+QC3qMonTajwMYd4TChTOrZQYATczf6snahgRRwYDnzN7mjsrZMDXNCuTs6Tj36BMR0
 9fwweUvy9ESMXLTyt8Ig54jGwVq4e2vAuybWD7rHHUJqWlfa3crf8DG9VcvSSJhYeN2vcM1zaEu
 i7ia/6REAMnf2ZYz2JQ==
X-Proofpoint-GUID: ffa-cTAiHn0bqMqx9VhJ2VUgRwO1RQTC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-26_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1011 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280028
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A5FC1A0006
X-Stat-Signature: 54dfdhghtmjscmca9oqkr1zc6rm9z3ij
X-HE-Tag: 1790579383-346838
X-HE-Meta: U2FsdGVkX1/sE5iwMMZT1RgeRwkN8ht3/UmXm9IwmR80u32AWw1+hcs8/XRqpiGw7TflPZKQSD7iijmVj/pLDhSXFx01diOunbkdIBHREM/2fu57KV3OPEbxPKeNP2o7i17Gl3WQyoIb5BF+nmjBQRZqrYzYGnZJ27UlUXi2owutQ5hIXmfI+FwoL78qM+tBjBsolpBwwZ3cQiEp1YC307GSUljv+nqmp1f5Z+zNN7enxeGV2kN4Xz+rZu0kdD6Ghpg01bg6UQ1QDPbweOi5iCyJcgZOcW45dd0GKULjOfml2GHoqvwcWoJjLnP+ZAvuZUHwlXSpGcC1dFKqOcj8SCLqniWPv/7aycJrhoOTzbTVirT1Gr6Z4OzLnQIkAdKWbNXqBu7pfr+rPANrwXpAfJQ7JGqjpow3hpQ4egdBCLG060IJSgPfVIhqgpZ/OeINrl7tkZYGY9D7mU+TE7BP0+49niCpZ8G1ktqHPGxeZELc28s+vxP/IM8GlotjEXG0Q+nIfyVMFwGVcxyNBsAPb+rIk9Cu5troTgZiLF/jPQ5G7JF3SEG9qZV0gQLCwmZLltGrgQ4qz1Q5X2oZlSH7sWmbQ2peqEG5htYV3cIcSPxTw0pbhZChql87kCJ/aYrmQkzAgrmZOEw8LpQ4KQVSKXK0yKdM0j6u3e2yXUqMB8wStHEMgLqCfFVAwdcMHNaHd/jYY766ovA9YFxoTcmHtJtvRooWGat8jExedPIj/CbbP1YhYbpubWSdartf71OiFtNqdzMVZWqM53/R5Z7Ix4kSoUqbUmJGcNgGmQNh+dCPHGZrMwEy8CzaSmOdKHjatpyT7zKyWtMiXRWYJCHUVYjOK7ftNrtfGQHb4Xjm9Mi6H9Se86d2c/PATAdWH4ye7wqFWcaK36SiyxaYcFqrmApwzJ6pc/I8AlMJx2G1kW1FpF10F5jZZAXFly+2eH4iBKwRL+W+l4IduUBECTV
 zcX4KSMM
 hBTidDkolB9EUrl4HoV0fJHLy5F/fvCv2TgX+SoWKE4yal3tNtTFRkDD3/30CGyVOVbmqXDwGHBwXSTVQPNEbPjWxGNEe0PFnLTwE2pLjFxdq9YLk0mikClhuZF4npCAGnfFxvaINAOjnvkRotCLOilvkIdlj69jLbEM7AwTzEjItgJeBeYtGziN+Mt7/tuUT1MRNT45eEtdDL++C06pZnzq9aasjjlvUysEjJO/z5gRj41p2owNfc0ry9sDiRu9AYI9oMjEAqDve/KCaxjWhyuqLAAWAriH+HSTtz3g2AEz/5S3rozDAOYM8UoU6lUxxmNWNgvpqESuxkDhTdy9NWg9hN3rmKm0eIRcQOcVHbguhYWVAi0lKqnpKFH76knjk+ySsKv4aa2Ux80C0Z6IYdM0U58yzRNx9MuNgI0D/OfyvU6b7qaWW4LEP3828C6ug27+oWmmWxj/NAPlIvMG6NQiBtlnnfqoS2MgTtEI6SJxO3Ssrwy31/HekFnF8kSOqGfH+4YzVGt2NZWtL4o8UMdxbhfAV/zOQlH0OiZOMwG4U2vLICn7oltwhBCIx5H8IVc1DVpuoC4iQ2FYWdVXsvAiSn3sbkZuVqQQCvfYQQI48MDY2i3ZNJYiFC/cSYNtdossgbD8dA+Ro86Kvif/le3rkQWqf9Mij2sxMJQPEnMno5xV0yNQN01MuhEbOsHFjU8hgc6Pqiv+hXpfqL/w2oYTNTw4Tsc7HHqOceC5Kakrbab5P0ZM56zdakSkV+ILJAmcqP5TnvBSoviewd/M+DVx7dmPbe+W0cmdadpq+PxBsZ13prpx6fy2d8+LZKOnU1kDfJ/c+MqacolOloy/X4TPSxQw/Sx9cp2BmmouHIGrluiGx59VtJ+rZjYJXDLnQEPGfVv/uPWkDGBySHgaZMLl7MGIz7iCHtMb4t19lV5/PBlsZTWwsIwW1b7btA/ft1vLA4Potf+k4AHd7owObWIAsVZF7
 H0k7b3SU
 Bu3C2XZ3x00UfyrRMagvnXREBOs4rBgc7bd3soVomwH5LFnvHUEAdsLcQsj1F6hCTlPTDkRzPj+w3xtLuImLV/LEGEDvG7dUp8DQx0aNIFSknIVcrLTQ52ddEWDRCIDj8oCuHyBuwQVMhBRE04zwbyb4AIx0IGS6LPalTsIa1bJI3WkfCXKiULqpI27W9duMGvOJ2ikjkflzERSHhqLNOKCxhEG9zrYthMI7cdajvmRrHlanFAb6NXZKpzM3wMZSeWDWcZKwc16+LdFTSqD8e4/yIYgCbxUsg1iAVkB50inmyyWYCS3Q96P42UmTOyzog+haLgwQzkhIq4Q6OHlx+DXyyWFNpPqmmEscfUoUHQLvq3UsT19QsXT8KzIZlc9TYQIZVXzoHGCSoOXdUOzIUz6RYDBD7PmTGuFvoVkOXDtq+w9/tbvxJdDIr5PQvY1c2WPuKv2Q+PRuCv3GEmT7Qv2gSejamGOrxwg4/FOb3lS12zdUwc9ra/CDpi4BChtf/W+4WF7sMARlSlwVUU7X54bef78rfJI1yVke8TkAYlS9PcbY3CGUEQ/4C3dqkTxkUbh9wNrfJwHgLnTI8p2IIqlFSKPhuujrkmDgz+xCU1puP+iXMuhNztMxi0kWJvMwMef9+Z7eBun1txNwxdrH9zkslDtypmyfa2Ks8V1eR2rq3r5AOE+QlSFf1WzpI5VMLwUka0umQ0f44Du+Q42PEYnu5YWZ/MmSQ7qo52gTyJYA5NRHOKq0QpjBbf3V3h6PWtKCg7QltxTRqJqhYZVLvS+KPRAYXzGIkabtdIv9XcGHQ5TdPLWXYkaAIEjydGvn+6q9V9f27K0+lIw/YEHBoWbEQ7/HcX4PWq/4MjHwbc3XGRUxnboEwFJZ6bC45JNxUuDrgOC3Eqis4uxkhJZpVkSX9uvdW3z4JTzdgNXITLqDOYmjwLZ41WeZu2EJ6ob1lGzW0/y0Q9ex2FMhdvsMBPcMhWV4+
 DM6VohS3
 7HlqgG6UgpaBm3DDX19yawaB1UbhdgpJ3cWriXL+wv/KqQT4uyyaTHHALGUz8+IHjZHfVbsn3vhxz8PvE3il5vzKy4p9EJLv2aFjxVbaSdMHPuTDpb6wrx3GgyUdyW1IVfWd37IBc529ct4844UiUlarpgS9q3en+HE0RF8n5lzLd18EDynBqBWJHHML80vTH3b0K7jZHgGKBeoeNOw3arYqLy5CZfehq2TvyaSN+aUVQDnSEcnP7KXB10q9gSb379Q/EcEYh/qrdsxSVzrANvSekFSflU5WXO8s/4rHtoWOCco9Im8zFncDiRg3tFAK9MdBV3nW+uFkH6LuRPt02vdTupzg8uQXBtWm2cD3GQ3lCNr2b/LwAZp097uX2C+JVkUeADg/EAZgqTsKvXRRuMDC1CPq4KwipyS/u2PhsFjXWIeFjF+nCyIaoDOftxLw0r8ZcJJNX+FWFEShvW+2+iqU6lHf0DykAEZ/0PjSITqymZscGA+srfcXBfttXOs9zNIXYRqb8GPYWTLl6HnEDPbr7rvzBqZ0fQI1RtYZYzNYR76DwD2JFZHMTi9R+kyykSr9X/BGRjrLEI+0RIVcL4k98DoP6zGTVJDOuT7xHlhzsJ6f0UNnsK+alvOp7u0K2u5Ab/NnLCBlZHm74oc9d3TIZ82255UeeVIKqxFlI/JrIapJB4mlP5le+PWfpNWURmkKPLa4Kii4bp4tvK7OZ771ugf3NcLpzTKdiic+qGc36dl7KtS/8uEYxEk2Tw7+ld8Hsycr+yObFha+r30QkG274y5GSVbvgdbAfuAowK61lXiWi3g1wjow7n6XP0VIqBN4r1FH+QQDCFlnU+bXTcIQtS/nNtWeehihAy6BfhBir2QUDMqXW65x3kEARxV+f8hITvvYRiPfrwZN6/XgAU9YAOKQRux8SMfHugyKJ66Vsy+RRGMezgmJAkK9uwsMZyHTsDADQtCs6Vkrmew+7iax09ufW
 EfqJaO2B
 7qZgU1T5p91vYhuo0LBRUQ02oJdTdf7mt5A0Nf0zTM/Oti6usLfhnSRnIMx8t5uYXFgLKeyysEjNp0+Riw7hz4DHS8lYqtJvLItJ71D6UmDCWma314S/z0PnUqty38yXv0WJeRd0/vW6G+agmgia0UKWSaH8bk5ubCZTplEFv7+cvsA+OHKeimoq6c0hgXq77El8Vd/7Ty+PyU5QrAaHOaHTj+cwtohQaBZ/mHZSmo9sSyiK3XRSsGBpfCf+gBnEU8+D7eOZwerGL+MvrhkPCgoz+PQt61j73wgqZTT+RKzNFcM3yow9RKvOll5Wk+GUxND+HUk6LMkOLJNvG7JNNltnL0uIYEXJZvrzbYnfjPuhNn0qn9sKH2s2v2q8f0jmL2u9d40G/+pIkFnPPFoH2/pK7jFO+UJi/B8SXuXoTdvvRAPNLsqGgRXp3B2Ywg3ZGY0oLg/etN1sXQrAuWkwGkFrNVlOM7Kyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 06:12:28PM +0100, Muhammad Usama Anjum wrote:
> Hi,
> 
> pte_t currently describes both a software PTE value and an element stored
> in a PTE table. Consequently, pte_t * can point either to a software PTE
> value, often a stack copy, or to a PTE-table slot. The compiler cannot
> distinguish these cases. A value pointer can therefore be passed to an
> interface that expects table storage, while table storage can be read by
> direct dereference instead of the architecture accessor.
> 
> This series begins a staged conversion at the PTE level. It introduces
> hw_pte_t as the element type for PTE-table storage and converts generic
> MM to use hw_pte_t *. Software PTE values remain pte_t. Interfaces that
> intentionally return a value through pte_t *, such as install_pte,
> remain value interfaces; the relevant parameters are named ptentp to
> make that distinction explicit.
> 
> The generic definition aliases hw_pte_t to pte_t unless an architecture
> selects ARCH_HAS_HW_PTE_T, which enables a distinct generic wrapper named
> __hw_pte_t. Some architectures define pgtable_t in headers parsed before
> the generic hw_pte_t typedef is visible. The structure tag allows those
> headers to define pgtable_t as struct __hw_pte_t * without creating an
> include-order dependency. This is required when converting s390, m68k,
> powerpc and sparc.
> 
> No architecture selects ARCH_HAS_HW_PTE_T in this series, so the
> representation and behavior of every architecture are preserved. ptep_get()
> keeps its existing READ_ONCE() semantics and converts the stored element
> through __pte_from_hw(). An architecture can later select the option and
> convert its PTE interfaces to make the distinction compiler-enforced.
> Architecture PTE implementations and most architecture code are
> deliberately left for those later opt-in conversions.
> 
> Here, hw_pte_t identifies PTE-table storage rather than table lifetime:
> complete PTE tables use hw_pte_t whether or not they are currently
> linked into a page-table hierarchy, while software PTE values use
> pte_t. The distinction between complete but unlinked tables and
> hardware-reachable tables was raised during discussion and remains an
> important point for review.
> 
> PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
> converted in later series after the PTE boundary is agreed, avoiding the
> PMD-specific cases that made an all-level conversion difficult to
> review.
> 
> Most mechanical pointer conversions were generated with the Coccinelle
> script included below, then audited and fixed by hand.
> 
> This series does not add a second ptep_get_once() accessor and does not
> remove or replace STRICT_MM_TYPECHECKS.
> 
> The design discussion is available at [1]; while the original idea came
> from [2].
> 
> I've the patches here [3] for arm64 conversion which I used to find
> usages in generic code which I missed during development.
> 
> [1] https://lore.kernel.org/all/6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com/
> [2] https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com
> [3] https://lore.kernel.org/all/20260914-pte0_arm-v1-0-bb53b663e396@arm.com 
> 
> Testing:
> Testing was performed with and without the series on both x86_64 and
> arm64. KUnit and the MM kselftests produced matching before-and-after
> results problems or regressions. Fastpath performance testing was also
> completed on arm64. No regression was found.
> 
> Thanks,
> Usama
...
> Muhammad Usama Anjum (9):
>       mm: introduce hw_pte_t for PTE table storage
>       mm: rename pointers to software PTE values as ptentp
>       mm: use hw_pte_t for generic PTE table storage
>       mm: convert PTE table entries in ptep_get()
>       mm: convert PTE table entry to pte
>       mm: add hw_pte_val for HW PTE storage
>       mm/kasan: use hw_pte_t for the early shadow PTE table
>       drm/i915: use hw_pte_t for PTE range callbacks
>       xen: use hw_pte_t for PTE range callbacks
> 
>  MAINTAINERS                                        |  1 +
>  drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  4 +--
>  drivers/gpu/drm/i915/i915_mm.c                     |  4 +--
>  drivers/xen/gntdev.c                               |  2 +-
>  drivers/xen/privcmd.c                              |  2 +-
>  drivers/xen/xenbus/xenbus_client.c                 |  2 +-
>  drivers/xen/xlate_mmu.c                            |  4 +--
>  fs/hugetlbfs/inode.c                               |  3 +-
>  fs/proc/task_mmu.c                                 | 33 ++++++++++----------
>  include/asm-generic/hugetlb.h                      | 15 ++++-----
>  include/asm-generic/pgalloc.h                      |  6 ++--
>  include/asm-generic/tlb.h                          |  5 +--
>  include/linux/hugetlb.h                            | 53 +++++++++++++++++--------------
>  include/linux/kasan.h                              |  2 +-
>  include/linux/mm.h                                 | 26 ++++++++--------
>  include/linux/page_table_check.h                   | 10 ++++--
>  include/linux/pagewalk.h                           | 10 +++---
>  include/linux/pgtable.h                            | 81 +++++++++++++++++++++++++-----------------------
>  include/linux/pgtable_types.h                      | 23 ++++++++++++++
>  include/linux/rmap.h                               |  2 +-
>  include/linux/swapops.h                            |  6 ++--
>  include/linux/vmalloc.h                            |  4 +--
>  include/trace/events/xen.h                         | 10 +++---
>  kernel/bpf/arena.c                                 |  9 +++---
>  kernel/events/core.c                               |  3 +-
>  mm/Kconfig                                         |  3 ++
>  mm/damon/ops-common.c                              |  2 +-
>  mm/damon/ops-common.h                              |  2 +-
>  mm/damon/vaddr.c                                   | 20 ++++++------
>  mm/debug_vm_pgtable.c                              |  2 +-
>  mm/filemap.c                                       |  4 +--
>  mm/gup.c                                           |  9 +++---
>  mm/highmem.c                                       | 15 ++++-----
>  mm/hmm.c                                           |  6 ++--
>  mm/huge_memory.c                                   |  4 +--
>  mm/hugetlb.c                                       | 60 ++++++++++++++++++-----------------
>  mm/hugetlb_vmemmap.c                               | 13 ++++----
>  mm/internal.h                                      | 16 +++++-----
>  mm/kasan/init.c                                    | 14 ++++-----
>  mm/kasan/shadow.c                                  |  6 ++--
>  mm/khugepaged.c                                    | 50 ++++++++++++++++++------------
>  mm/ksm.c                                           | 11 ++++---
>  mm/madvise.c                                       | 18 ++++++-----
>  mm/mapping_dirty_helpers.c                         |  4 +--
>  mm/memory-failure.c                                |  6 ++--
>  mm/memory.c                                        | 78 +++++++++++++++++++++++-----------------------
>  mm/mempolicy.c                                     |  4 +--
>  mm/migrate.c                                       |  4 +--
>  mm/migrate_device.c                                |  4 +--
>  mm/mincore.c                                       |  4 +--
>  mm/mlock.c                                         |  4 +--
>  mm/mprotect.c                                      | 19 ++++++------
>  mm/mremap.c                                        |  4 +--
>  mm/page_table_check.c                              |  4 +--
>  mm/pagewalk.c                                      |  9 +++---
>  mm/percpu.c                                        |  2 +-
>  mm/pgtable-generic.c                               | 20 ++++++------
>  mm/ptdump.c                                        |  4 +--
>  mm/rmap.c                                          |  6 ++--
>  mm/sparse-vmemmap.c                                | 22 ++++++-------
>  mm/swap_state.c                                    |  3 +-
>  mm/swapfile.c                                      |  5 +--
>  mm/userfaultfd.c                                   | 32 ++++++++++---------
>  mm/util.c                                          |  2 +-
>  mm/vmalloc.c                                       | 11 ++++---
>  mm/vmscan.c                                        |  6 ++--
>  66 files changed, 457 insertions(+), 375 deletions(-)
> ---
> base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
> change-id: 20260914-pte0-6c88f5592d79

I backported this series to the Linus master and tested on s390
with the lazy mmu series applied on top. In case it still counts:

Tested-by: Alexander Gordeev <agordeev@linux.ibm.com>

> Best regards,
> --  
> Usama

Thanks!

