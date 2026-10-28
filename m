Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E23606A329
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l+qjavsJ
Received: by kanga.kvack.org (Postfix)
	id 915A06B05B3; Wed, 28 Oct 2026 09:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6B16B05B6; Wed, 28 Oct 2026 09:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD406B05B7; Wed, 28 Oct 2026 09:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6711E6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:06:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0565D1A0C3E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:06:02 +0000 (UTC)
X-FDA: 85372057764.30.A021B6A
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	by imf24.hostedemail.com (Postfix) with ESMTP id BDB7F180009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:05:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+qjavsJ;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793192760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQ37RfglzdINqejwc5JbxUwWcf6fyXiPnEVqkiyj9wE=;
	b=HKlQtwyg9XOlDaY5LBFnHQIIdvUIxXt/Y5o0yulwh3Z8CDS4AByNm8DviONcURWQXPHXLX
	d1ar+isE6Rb07Ip8w2O/xwR+FEnhmsovjFE6WxiG2jmmk+pes2HLAXQgMq/gcbUNc5fVWZ
	DH+O9iQbUsrtTRJBpqcYsPgOmLZhDQM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793192760;
	b=ILa0UQVCgE3nziUXvN5FBng2yyvdjOPP1dn+kP/Ur0H53tXwlyfud3gbna0Rz8cFHoBmR4
	R3B71nBC6Ldr/r9oR2aBlbn3enbLoKn7D9tNgEOe4Z0GNSxfH8Yzep+gKj20uzSWi+3HV9
	KR8+E6D+ZXTgUSCAy6Q6J4uszHg3mEY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+qjavsJ;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8ZJqLauaB75tCQkdQ/iL1btTWlyXZvR89RMo3Rbmqm0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793192757; v=1; x=1793797557;
 b=l+qjavsJub2Qwlt0kiwwZUKHqTD07Hrdeuj+5NMf5+2n5KY9kWiqdYvKqjB1Y8y/Qf4wAPYS
 jKTevQ5+bxWUgn5piUbQllcX7GvwLshacXL4NgQuibsfSwaaceXRoyKQ+9gtP3IvW1gDjcTJVtE
 pUGFwBfMZyDVBNIdj9tza0n4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 70cb52b1da55fe0c;
	Wed, 28 Oct 2026 13:05:57 +0000
X-Mizu-Trace-ID: 70cb52b1da55fe0c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/sparse: simplify the vmemmap alignment check
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028121129.39916-1-kaitao.cheng@linux.dev>
Date: Wed, 28 Oct 2026 21:05:40 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <66E340E5-B2D2-4DB9-AE01-4F98C3182B06@linux.dev>
References: <20261028121129.39916-1-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BDB7F180009
X-Stat-Signature: ei7mdepesn5xcnxc87y66zyejusopgm9
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793192759-537033
X-HE-Meta: U2FsdGVkX1+kg1hkIfVM0+DoB+bjS8EqljQs0+EvFkd02nFCHRSuPlUGMe2FB6f1fyNdhIYh8YottdnurYCIe0ukYmdkQd94QDQYzuto6Vi4bXPegniU9Qm00K6i38oMz/So04aIoeVBGvfj/rCuK/lz3jbQ3lqRDxzztJGsyNR2d6uZu172yd8XDdgnuHzJDbzhetVqcQElXdTbyTfB7AOaiojhARrEgsSaNekPl2ACaI5OKhb4OA24svLRgh4C+UHzGC0+E6nnGhRUeQHpo3LgAmYVVgicYi0+uOMgc4Sp4lJigP+ByIcjzKuwInuKNpFqRqfLMZr+NRx2MB3k/qQQS8lFx8G93c18fxa5BbAg57h7nvL7wTq2i9qAIfR+YXMr416inrSN0VEbr90b+0LEv7Z3mR6ePips16UvLCdKkeVLF/QPAz1JkC4ERKkM8UhIaitD9qkjrVUQJOKjEZpD8MNjbu81slmXpHv89LJVEwmhdrKMOHypuRoO6YkGriJglzJDXoLm1hTVUVOJgSfiybpbyR3JL+J+qApNw0P19ZPgvIBONCULz0hqecGT3GD7dG5qmfxYZCoNCdHO+qLjNF0ZPVMi7TAt50b1q48N3yOnJ7YF8xoV6HnR6UNFsYo5R9Tjd2Wq6TOF7oVe1Kohv3FuayWXl/OGc2UgU9IsDm+Ocaj3o410LJmkyWqLBw9qbl8b5omoyUOFqEMh64FU3TtqYqeFU0ZKCk1P5jgHPlXplCQyXYtSMzGUZOpY7meN4k6kN43ByLB/wCybkHVdG0po8G2fGpKoPz7lxGkHTf7M6djYe3TTVaYKLZOSNFZ8I4ccP95Hzx8WSPeHrfm4gRX7MAHmdfLayh9GjgyUjQeiUNiEVUSv2aU9NkLKKZsy35M7yYvGLYvONjyRk3zRbatkRVItoRWjxGmOmQaa+llW7bZVS8Je3LI/q7ZVxMh6/IFxlHhnLXHGgqt
 4Uo1CRh5
 bomtvc1SKYQdegbGOwyY1kBqAo7fLZuWbkJTotLI7X/Y9n+lKeClFFSacm/J4FLnZ+05g8UJ/pbBTMRf6jY9wldBhLb0MyNxZi6WUzwKoon2eq3qeECA0r6gZWijAmX5Wwvdf4dcsKtsW0WjzzxrlHGBvyLCCcMnmCcWELlLZNyCpB9/j4TaVqDSeM1C2IqpEureVklYB8dQB6ZbJttG7p2Q1CPeSZ9f4KbsJ3v7DFpCmhw9JKC0QTS6kFZ/5U47t6bE7byUgkMgKd2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 28, 2026, at 20:11, Kaitao Cheng <kaitao.cheng@linux.dev> =
wrote:
>=20
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>=20
> sparse_init() is called only once during boot, and the vmemmap =
alignment
> check is outside any loop, so VM_WARN_ON_ONCE() provides no benefit =
over
> VM_WARN_ON() here.

Yes.

>=20
> Use VM_WARN_ON() and fold compound_info_has_mask() into its condition,
> preserving short-circuit evaluation.
>=20
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
> mm/sparse.c | 6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 6acb628c8a73..248bee2d39b9 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -277,10 +277,8 @@ static void __init sparse_metadata_init(void)
>  */
> void __init sparse_init(void)
> {
> - 	if (compound_info_has_mask()) {
> - 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) =
pfn_to_page(0),
> -    				MAX_FOLIO_VMEMMAP_ALIGN));
> - 	}
> + 	VM_WARN_ON(compound_info_has_mask() && !IS_ALIGNED(

We usually don't end with "(=E2=80=9C. At least I rarely see that in the =
existing code.
We can break the line after &&.

Thanks,
Muchun

> +   		(unsigned long)pfn_to_page(0), =
MAX_FOLIO_VMEMMAP_ALIGN));
>=20
> sparse_metadata_init();
> sparse_init_subsection_map();
> --=20
> 2.53.0
>=20


