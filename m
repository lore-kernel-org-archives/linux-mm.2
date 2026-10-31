Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E4F606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j8uPZm/c
Received: by kanga.kvack.org (Postfix)
	id 7B2F06B05B2; Fri, 30 Oct 2026 20:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7633D6B05B3; Fri, 30 Oct 2026 20:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 652E26B05B4; Fri, 30 Oct 2026 20:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38F726B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:41:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A945DA8441
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:41:03 +0000 (UTC)
X-FDA: 85381066806.30.65856D2
Received: from mta1.migadu.com (out-100.mta1.migadu.com [95.215.58.100])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9566B180002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:41:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j8uPZm/c";
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793407262;
	b=hTVOkjDXhLrlPH5PY5N30CevYxH02vsBa62a6DpsgKNv054y3Y/a0UEtQeKpCLURQV93nG
	OWgpaCVFL000/zndCSpnM0+v/jGdi5PdaGDDrEXTxa5oYSn3AeLYlogri74IEnNp9Gvp4i
	ZH3EGFc+fn4GOB1yXvBiGeTGsuQLEuc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j8uPZm/c";
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793407262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVsVhQ/ReZ0Z2nIJhQWtigrg3sY6kB0bqA5wLYKs5WM=;
	b=WQRXxxJujEIgYZxSclkcTIs5466uW2OH0J6Qc/KO2HYEVLqZuHotbawUBod3r2jVMgDmkK
	dh3NICc7mxENwSXvH/Mb0PUZmT4uu+NxIXSCoQDAV/0LQw2zOfUmGbdGBtHSOvvzwbAcPl
	Jo5xbBfaRP4VknpKipujFoXv7OQeonA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RVsVhQ/ReZ0Z2nIJhQWtigrg3sY6kB0bqA5wLYKs5WM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407260; v=1; x=1794012060;
 b=j8uPZm/cTAon5Bx/qz/wD3CF3+IVsaSKY1ZevVtNO1QBhqfs7WaSMurCbxcpTVXHmwEz2shA
 C79mytiiso1SKU2stFj/VmIcisD7f9str2F0QVhZ8gbvHyjnLQVXETwKFxvhL5O9sux3cGjl4fv
 PH1rWL9p5WGJVHIB550VXHjA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id bce34db760ad78a9;
	Sat, 31 Oct 2026 00:40:59 +0000
X-Mizu-Trace-ID: bce34db760ad78a9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/7] MAINTAINERS: mention for-next branch in MEMORY
 MANAGEMENT - MEMORY MAP
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030-maintainers-v1-1-97278f8a5f54@kernel.org>
Date: Sat, 31 Oct 2026 08:40:27 +0800
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
Message-Id: <FA211DB3-E11E-4FC3-8AB2-9EDB5AA80DB7@linux.dev>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-1-97278f8a5f54@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Queue-Id: 9566B180002
X-Stat-Signature: cqocyc9f783zd9yottfqujx4751q8c4s
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793407261-840135
X-HE-Meta: U2FsdGVkX18XAk4Znu5oKya1U0u3Ictroq0VdMgg+UFGc+pFYV7XaAy/gUFPqCd4uPE59+X8uXcSXLJJvY89Wv8bnPAJVLs3D22Zd3dGBxlyhUH/NfYhD9e5Lpnz9AaGq0gCOyh6KxnKxciH4E4s++jEkHR/pOpZ2MZAzzpTZ7RmGlR7aElp9bfAKXGdkqG8SJwkc4C+10qsofigDhGOr4WLDM/Dkyqfweg4vba2D2xBp1pO+g0QkaPYzdYr9z0e355wLScvLg/szxB/XdB5wipNP6L3Dh5GL+D0AlvCjkEb2EBEw02pi/r8Kzne0BmfhEzfzbHdMtTPoDcwr7cGBp7y0nqKieDFMnPl0thoC7q1VXLQaKtct5bQ2RHHn3USWQMfeu5RI75iuBBMf+ScMWA4QgYhzI4FSDcbUHsg4ZWSTC5P20E2irxQHVb4rJ+pmt4w0mp/+NmRkjzYQQJjjuUYDFMnKtYq8lMFJ3Pnzt1GRFK5WqASf4Qyoh1TMVe+9eNOGFibZDVnsmJzLv4JDkYEyCbeNhoRVvVxfzqhKYv4nd7vvkpZUoCZTm07+wBf7uxwaNDQJGqMzEr/Cb+/kyR0ZvAvfx04EZcvZJYbYH8y8XWF2U80HrPAlDdsnbvlC/bqczwpLruZcc5yuMlDnGUhX5VE1hWU1rKAud46+UQTkpgDUoq8VIrTLrHSCRnqeHTcgMqEJAmLjC+LrXQs/u2u2Ef7OMMfi05xVnlPu2fftazX4Mf4D82PSfS3G2Nq6V1DtPiuR7yT8RdgjwpaKO1c5DK7pdROa07PKpZKfVJCFvc934OPH85Ny4SHnF1rYka4jNlY/rQEYWDfUeFPrsUQwyHsm0hTQ3zeyn26mxvWfIX76rGgt87JykK11fgmi8IgGVMA/FUGWneWMwC9ElXa+YnsbR2MSuWn49/a7y6y/Yg8E/uT99mFZialOWof1Ae19cdnqjYhVxhAHB+
 HgwSy3c3
 xecdUTTeEOOXyBl1ixQx0CleCZa9vmmkzrWdFcwKLady62NFt2KMhfFW5XJkcd8KdMSUnUgepBj6LPFyKz9PU578cUYBrDQZ5RYojchhe6wOIW9+b9b2Iq0gnU/+DYqBPBmu9kBDeQ1qEVyuSpSJsyqQf6p2pvisxbWX3NrQX1HZygV/NJ5D1n/kwVvih76Q6n6HbNbmVtC3Cjsqjx9v5dbyACmu9usKGTNQFXycioSh8gCxHFuYmP7twvzOenKUr7CsdIHb/y6hZKBV0JmzM15B5fD3LrrTgSH3Xju1UaQDdG4b80bgz6pJ4ZvnAhH3Qm7xFEiME7l+RZJp4rqps/+bkO4jLq7JnvvBxvFJXOIBq7Hs=
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
> "memmap" will be used as a prefix for branches, but not as a branch
> itself. "for-next" is the integration for all these things against =
which
> people should ideally send patches.
>=20
> Not mentioning a branch makes them assume "master", which is wrong.
>=20
> So just mention the right thing, which is "for-next"
>=20
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


