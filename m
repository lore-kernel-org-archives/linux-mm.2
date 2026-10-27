Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B783F606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Wy8rVp9D
Received: by kanga.kvack.org (Postfix)
	id D4D5B6B0669; Tue, 27 Oct 2026 05:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25DB6B066B; Tue, 27 Oct 2026 05:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDA76B066C; Tue, 27 Oct 2026 05:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2A626B0669
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:41:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B86AC095B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:41:07 +0000 (UTC)
X-FDA: 85367912574.14.D4BCA40
Received: from mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id 04B07A000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:41:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wy8rVp9D;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.14 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094065;
	b=taW2JwquCSss/+VcJzMqhcK5LP/LY0x0jAT/NtjI3A5Ocq5/SbQOHykoGWroNUm4jWLxP8
	ZBpCZ4vw1hBjHYgc5Ujx7CW40x8tL1tXV62UOiJpOY09L3zLxKOIqT5nxA/Rgj5dWoo4G+
	M+gDZYCA2pode3PkW6AJ1lNIX4ZsEFE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wy8rVp9D;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.14 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFKyeuO1JPOzpTH1nQSbh9oibxPGA9YOhGPCshroXxs=;
	b=qorUqZ2nX895H0DJLhOGWDj01iqumb0Dn83U+KfLXEYf1S+oqlNxIifedDeWv9UOSFbzEM
	t87hUuEd/18uXOevRpvILGrznNxjU2ogBYUGTJNYzUKycIPy9/fBvG1F4aenIW7Ct9DM2M
	X8pUMrEOZd0UBEkFz2PfXnLVSlEtknc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SFKyeuO1JPOzpTH1nQSbh9oibxPGA9YOhGPCshroXxs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793094062; v=1; x=1793698862;
 b=Wy8rVp9DDbUKlyVz5wuK1Feezur9xae+q/Z6Hz9yNW58v47WUH5wcaD9Hrg3xWbyvhu39BqI
 ExWkcwZHN1517KLsoJWC0uj/l5WpUULFpWzYP0SvVGopmxnWl4TptAwsG4qqUQ92vI72Mtsn8k9
 0zb7+9ocVTbtmM6u1o472cEA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id caa1b482120fcdcd;
	Tue, 27 Oct 2026 09:41:01 +0000
X-Mizu-Trace-ID: caa1b482120fcdcd
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 21/46] mm/gup: fix out-of-bounds write for nr_pages == 0
 in GUP-fast
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261027-fixes_core-v1-21-6f74bec9a5bb@kernel.org>
Date: Tue, 27 Oct 2026 17:40:31 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>,
 Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>,
 Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>,
 Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <31275548-1D1D-46D7-A0FE-36D16C03384F@linux.dev>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-21-6f74bec9a5bb@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: 5ko8jiu7sdwrper3gdbsjgfi77wiatyi
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 04B07A000B
X-Rspam-User: 
X-HE-Tag: 1793094064-850104
X-HE-Meta: U2FsdGVkX1+b03QnwUURL3R16gHDgQuFODLzS/yFRm4SViOA257LOf4OXX0s3pETgBytjU78+xMzah8Rc6+m4p4TozXIdte/9WAth3GRvl2/k4DCYi7MAtWp1IYJDxPg2gjfV6xbFhHEod1JsX0XtkTYWrpyfRMUNNVzF5KAqh+jO152pwUDOp/bzPEg8ugm3hnhHJ2qTN4KDADJhZsO1QdfRNGov+d9urFsN+ZFsJXJqgzqAIIx6uexfB7O3grWMiajHEeYbgXzCE79ULyLC7JP7JrosFCnK9wcyvaggRofkFmrLSLw5cdyjKz3QgPR6Y9ShhkQLt2WCNTr5ukl4jNFb6LpIXdkToWvxGAOgnpnxLmh8nYVUPu3ROEJuH0Ib3xTSZf2n/Oke0AIGrGvx7uV4jd7vM8R19frOsxW49xXRNxzjmFxwJuxUL3gwIvNBUe9fCfv0pH60DhlmxlfWDRE3xUUNb0ifIEccNsKlDmmFREmd7h0a+CephjsZB7NtfA5zQoXq18bWWJW4f+AmxUcP0Ta+SBBXkbDyGJx7m03gOJ4meMV9flE6+5EiWZ7JZRKXdXaexb7g3P55cXZQATGeHYrCq/LBa3NZqontvOKWbN6slqM1feje9Ewj6HBZqgq9+dGQBPpWXqFJdCswpDBAMhQmxIf9NKwjcsRZ+IyyRImHg80mx/+kA9FSiSL5rEu9c1VHPfwGbYuXcxq6hFPLP0jZ0gRZT5U+4/U9LgZcFxAE/mAFOjHnbUrdrVjVOW1baMM8oC8sbW7CTaCPuq0zNWGT7p67kr2epykeDzFsFPrZPIi5sFgo3DMZyhOL3CE1FnqTXskiEb5LxMiWTQ3kHEmkMmtyEGPcokF/P26vmZ6PmNSq3g2q58r0HOSO1MANrwXKD1WxPXO9npiO1IvZYOncet9WDLsbDVdSDRdqI1myCrf0V27JTvEqWgawRqZO+6QiwQ5NAPHcXq
 NmBcbIn0
 5U7YN6jaxyadYiXYvbK9NHIosbiaKvaGLWwQZrD9f56M5MTRoDt6tX9j//xhMNarQsEdCWx1IVHXJUY2A5ZXgqqAiMWCzMtaDgfpuJHZaBEn0081KZkblWYbHQcAIgYSBeeYZrIetovHz5hyFnKKY7U3PAK+h7WgcNxzoHLMcPsAIWx0h3TyfErtVQr2rQijDx2Yw6Ge/QEBB5J52RySY+pOSJii4Z2eA+WrLXnYSeFybmYKVfpwWsABNhhg4amGqNPuuNtS6lBvNC5K1vb6srQaYf0hSNMiIJycJYPQjRSnt7HLhzcV7+57oVRw6DwhMG8J+NQFd1IEi1ySjokNNhmyxOSiuamedaSb+pHO0b43ERy5sikIhfp9fo2PHycm3aurZR9YpLCfsQK0dG8y/Dzm1O/9TzJPOL4K9c3IIoNL7iUKJfr8lEUGhnDVi31PilnCk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 27, 2026, at 07:17, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Chris Mason <mason@kernel.org>
>=20
> With nr_pages =3D=3D 0, GUP-fast still enters its page table walk and =
can
> write past the caller's page array. The old end <=3D start check =
caught
> empty ranges, but was replaced with an overflow check.
>=20
> Users such as OrangeFS can pass a zero page count derived from a
> userspace-supplied length. So let's return zero for nr_pages =3D=3D 0 =
before
> starting the walk, just like GUP-slow.
>=20
> Fix generated by an LLM and sent by Chris Mason in private.
>=20
> Fixes: c28b1fc70390 ("mm/gup: reorganize =
internal_get_user_pages_fast()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


