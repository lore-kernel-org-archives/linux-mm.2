Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE0F606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 01:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oaR/9Pk5
Received: by kanga.kvack.org (Postfix)
	id 6361B6B05B1; Fri, 30 Oct 2026 21:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6DF6B05B2; Fri, 30 Oct 2026 21:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6956B05B3; Fri, 30 Oct 2026 21:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 288516B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:47:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADE8A8080D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 01:47:05 +0000 (UTC)
X-FDA: 85381233210.11.8D40A06
Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E21180002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 01:47:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oaR/9Pk5";
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793411224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYlirVancYMmRVjJDVShp6lZsb2527J0ak94H6cSizE=;
	b=WQLkFa9kZQGpgKXaMO0ZyaDEF5ZAJLoIBgBkYf62hCKasPOgbEc5WL5ptOQeBdwNOilNJ0
	cLPqs0ZV8zcV99ZnIqNzpQeWOn6nk/I/f4LsiMY22rVaOs4FuoY4nPyXzsMT5DgrJvpT8T
	z3gnXHCwct7TFMdaYHDSy2hDNIZpbcU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793411224;
	b=G3ykHV3nXrNZc+82aEENP7FmA/QSFS5YOAGsltwesZg1LILSK2jqP+gs8U9QOmACDpdl9B
	pQK40B+q9qlkNrCFwToqs4eniEkPy84fJq3P2K1FrCxYXnoa9m0RbpuUAZQ1m15ciFSF6Q
	0Js0OKvII6w5s6AlvUDf5qTJgX1/x5U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oaR/9Pk5";
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AYlirVancYMmRVjJDVShp6lZsb2527J0ak94H6cSizE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793411222; v=1; x=1794016022;
 b=oaR/9Pk5kopXuDFGOADw5cPDH8Yeq4Tq0PC9zZCmeYWgtIkIP6nFWBr2T/b6HDaxKTldYK6D
 pVJb4K3qheNdEpfyyusTssNM+tD5QtLEKbpFp43OuHwws/sYB0BiZnXS/dFPK6KM90iEL4u0PCV
 iCIGRF/sxnsFXhzxYHJah06Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6df660725638d07e;
	Sat, 31 Oct 2026 01:47:01 +0000
X-Mizu-Trace-ID: 6df660725638d07e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 01/47] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <febf6aeb-82dd-4a98-9a33-0ef321792285@linux.dev>
Date: Sat, 31 Oct 2026 09:46:37 +0800
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 SJ Park <sj@kernel.org>,
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
 Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6FACF8FF-F943-45C8-BDFD-3AFB5C060E0A@linux.dev>
References: <20261030002004.154595-1-sj@kernel.org>
 <6d679adb-a866-4a76-b9ea-3b8c64171fae@kernel.org>
 <febf6aeb-82dd-4a98-9a33-0ef321792285@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E21180002
X-Stat-Signature: 489xbck9uuutn5pdssri5dco38hetomi
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793411223-329309
X-HE-Meta: U2FsdGVkX1/4hf1v5HdALilvL+hPO9ml09WNxwmMzIYfBDpXwS0nvxrWA0M6PSj9X2HVbA+2PwprsIxlZ9yo53SDmJ2MD0WaDMbSzjt8IEPOk75SW/F5bWMpQtAIPRL+Sr0uiqIjvhJ9/GJ8WHJAHeAKtWBDnXXVazjbaFALJtaIVKAcez+vwkQtiT2YtLJBJeUCJgmuGk+cxKscm8ejgWvxajvt1YktB3GXZ8Qkuc78D2rLSpVlXZvVMhTi3NcXx7mZvFmzY/ZvGytvIiDAQBsJTgJbgieK1l0oTMXBzCdOtJDPTR37bzjraWFvibprr4m9OkGtvNSmKyqPCz9YAZNAaaJHXEFXFSVxjlFqHppXL7fqGnzIVYZo+VbCQdJ04xNJX/mokRjI9Jsu9P1GMEDtgx+aQEQESFTJRYfLEyRzDhg0oSP8Mc3bc+ymXW51Bcwv5Kwk3uJvAOYA1g0KX4eg6qZmk8JR8b4S5daYODkr0r/6b0m5i15EGoukjRCj/ORD520RqJnd+DzzF3Pk1eq9vP2TwY2Wti8WK0ISJ0dlD4xFKGxMcFeS2XDxquCebrb4Mx4uRE6+LXzZwtG9koTdnCY6xHLCHo39Y4EKWlrtFpHBLYK1kqmM4QvNVg7JVICZH4tmlN6lQJNv+Zrwg6FC0QgrC/w0a70+5I3XOkRdDs5m4GKRBJ/stmi1YG5ee2xppBAP04P2M5c58IMGZC1KCXyjjN9Br/4R8vPtBu4srefNBWaORC/PF6VKoC9Rvlmp1x21BHxlBtk8BwrGW3V7HiZ55h0xZ4YHOOg2o6j7ojRIBUv6VHXu2JVpeamAFY5obPdSCRDlFgL6Vj8OY3Nd84l2iYB9ta4zHqC/0QJ/h9oYUvWS5Z0HbzhTrzTlzLQprk42dtHrqWKycWH1xxuKLvJ2qQr+aIilu5nWVjjImdQYSrIT255ugYgKHpgBOERza8C6bP0pyHTYAU5
 ZO7XYmjf
 xLHZcOWuPG9UUIAmsMFvyYdbBy3T7wLxpe1Zb/UnvnLhTiT7ujm94UGeDGy2LRwVjvH95WIpO/V++g03GOIrBQkqoJC5/Nq2RQ0bN43XS7uh5uikY16suyOdzmwQoHa/ZShVWUEbvdZX4vUtq2gYIxLyvi5BwR2mMidEsm7tLzxV4oGwjs855pLMGM/dWroKYbhmix+OukDMRbUc9tKrHzIFlfxOppNkEYlKedF89pjHk6wXxCktWHoOFZ5oQn6F7gu5QlEuvObxbuSZ+cJhuUo6MUvUc/kgtAlnyyYlsGhfgYRVgIDqMiB7q8keP7zAsp+WixIZ4VeNBpz06cuGlX8wxoFPv9cn+55/SeJNwCq0dZifWn7dojWOaIaPMj2eacikaDZAPsHf+BUovNi9ACia9aPa8PUO3WQEI8GWowGc68t8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 09:41, Ridong Chen <ridong.chen@linux.dev> wrote:
>=20
>=20
>=20
> On 10/30/2026 6:21 PM, David Hildenbrand (Arm) wrote:
>> On 10/30/26 01:20, SJ Park wrote:
>>> 'get_maintainer.pl --nogit --nogit-fallback' suggests adding below =
recipients.
>>> But I can show there are already quite a number of recipients, so =
I'm just
>>> noting here.
>>>=20
>>> - Brian Geffon <bgeffon@google.com>
>>> - Oleksandr Natalenko <oleksandr@natalenko.name>
>>> - Steven Barrett <steven@liquorix.net>
>>> - Yu Zhao <yuzhao@google.com>
>> The CC list was so long that I limited it to people that area either =
a reviewer
>> or a maintainer of code.
>> MGLRU not having any real maintainer is a big problem; because that =
maintainer
>> would know whom to CC.
> Agreed. FWIW, I think Barry Song and Kairui Song would be good =
candidates
> for the maintainer role.

+1

It would be great if they could take this over.

Thanks,
Muchun

>=20
> Both of them have been contributing to MGLRU consistently and
> substantially. Barry is currently working on improving aging and =
fixing
> the swappiness-related issues, and Kairui is driving the MGLRU-FG
> optimization work.
>=20
> They have also been active in reviewing MGLRU patches, and their =
review
> comments are usually to the point and helpful. They have been looking
> after this code well, so I think they would be a good fit as
> maintainers.
>=20
> --=20
> Best regards
> Ridong
>=20


