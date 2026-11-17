Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED104606A895
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SXqDJYPK
Received: by kanga.kvack.org (Postfix)
	id EDDF86B05B2; Tue, 17 Nov 2026 06:15:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5366B05B6; Tue, 17 Nov 2026 06:15:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF28F6B05B7; Tue, 17 Nov 2026 06:15:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDEC36B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:15:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4DFD7A03AD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:15:26 +0000 (UTC)
X-FDA: 85444355052.10.A38F2BC
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf07.hostedemail.com (Postfix) with ESMTP id 338DC4000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:15:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SXqDJYPK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794914124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJA2MCmjb1P7IxhgFgaHgcq/Fcrb54LrvxuYSklnXNc=;
	b=lTa7un45TlPp6v39EIRD+Xktwjpfq/aI7DP7ugaLVeVsCCDzreWlPzmKDU8mVrlBU+tteG
	JHvFU6Ud7Co6nHP7fTmNs3n9mG3JsS6yriywtd+jFe2z2tmwT1bHBH8wKuzrWq+AqgPByj
	S7wAZ2wC1Tf0HhMJHTORtGqM+uMulxE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SXqDJYPK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794914124;
	b=lQkcQETK9FSiNopD3q9sy8Q+j7Q1Qg3pUTjyhFlyKxecGO2bcqC/1c7K8vhCh4uUR0+6ZF
	wZJZ30sCZ3lqJnpmMpKXrZiRiC1LeaL76v8sfUUaiz3A7ccD+rk99D0ieTknq16rthuQSq
	Lrmmhuq8n7XfHqveOhoAByEQQu7lLjY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Qdvw5YG0QTbLXakfG7ZIquI7spJ/+YwHooiKLh0MV1M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794914122; v=1; x=1795518922;
 b=SXqDJYPK1f9ctpYCTYwzLuypN43cE8SlB4P7znt54yUc+9hZRaZ3q1CmG+3qfmabJCTvMAey
 xAmGI0e4IlVyuCj6dllftrNMVNnW+xoGkhoiz7tPzzQxC0wuuZOqqZsyEwzpu4WWtfvh3ru6IlO
 OU4x21Zw+NMrHVkDqRsN6fR0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id aeaa08e42b06b611;
	Tue, 17 Nov 2026 11:15:21 +0000
X-Mizu-Trace-ID: aeaa08e42b06b611
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 2/2] mm/hugetlb: remove the gfp_mask argument from
 alloc_hugetlb_folio_reserve()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261117-for-memfd-v1-2-fa68f433171e@kylinos.cn>
Date: Tue, 17 Nov 2026 19:15:05 +0800
Cc: Hugh Dickins <hughd@google.com>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DF9FCBFB-C1E3-497F-B7AB-567F44873B05@linux.dev>
References: <20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn>
 <20261117-for-memfd-v1-2-fa68f433171e@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 338DC4000A
X-Rspam-User: 
X-Stat-Signature: ouru4zm5a5fu1frkps374iczcaqsiqaa
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794914123-162922
X-HE-Meta: U2FsdGVkX1+VbCFVFaSK1UaivTAW7RGF9BNwNUfmikTCGWTw/7MdwAXFpjlUs6wN+jr+GmMItcpPioUr8RPT1imYmS+9YDBcyHIdVX2KuOZDZZoFLYYdytCliUA60zLSSroOkKWFSo1k9KjjRPFLLqnKlRRrXL4CiwQ6n4B0Y3XLP0TwiTijtpy261oBXGH8fCVv98L8fFH/bF9013g+eTXZtqXoRpqB2ZxdB9WTJOs9bQxbg/RCN23SAu5vEUqrjExYp5CrSYGhJkc9HkXO6tPzwT6KwcGvvsOhzv5H0GF9hgIx0CrhvtgU/NB0m/Rt6uSt7r4fnBSsn5+BWCHbmDkzhM/d6XprQi3dYpzchEe1jrp7yJlcFIEBjbOdx+jFOdVv3PQyNpPqRXwAdvK4rBhaaBfjCB/GfXHCSM0Y870/GYerreIpPBy02kN2bJ1+9wQlDNYmzVNHtem8XKHlNeXDyuujvoVGengz6mG00dRFRwZ8b4BDvpu/1Doevxua7At+xuBLyzrUyxyCpquXS+vp1ek0VFJ54MrDwDwLIzhBhsi2hnLIYOJSUgauJqQTXLHnbVYoPi2no5elPAMlDNmDNNrOSSMPOLZGqpIKq4Oby4r3QFU1DLAjcWMH70ybIAyfHqvHJH/OQ6enskuhdJRZsE6gtlEw90BuniclM1YQhEWfy9Ug/ueoI458maNO98hRhgiqZXhxqX/6LoRdGua280S8uJ3S3mBAFVSUiv4USxHjdXRu5XFWP/lXLpmI8Hcr4F4NRn+pHzuZxz1qwdBu/4hDBW5+ONWwafZSup8V8L8vw59omgyP1gQgP+HVpI28BLcccUIQ5OnNMaOPLDAZjI+s27i/5GFpZxW4XbSf6d0fTDbcT1e3SbnRizUcmyg6m2fmdyD3rEwo311WqY8BDGkdJm+rx18qW5H/GSy8Uh1QCyfE2u4lQJahiXzmTsXTspamj7c/tVzyTuc
 ySKfC/7Z
 ME8JOSOJSBMVJyNt2IPKi6cpCd0lTpCjBLRiRJ98zBdiKWRJVlZKp5N60u7NMkXV/WSwg4YK18kTxIUQsrFuXfnCZQGsKtPq3Is14jm+RZjVZO8w8Yt/3KOMgQRg95wHOEKqyB5hh8gt8ExxbzQJ2+v35WodslaeWar2OmmIf0IvVGVSs5t46K0mbW2h84RtwI8Aw8XZ5FKQA4UT99SSiRngsvd7juYTEZswBb8iXCFCaaKy0FUDP6CojtzNvNeqLBdOlcDnoDeH1NF/wfDcmXHVLCwAIB55Ih7B539O/WQoyKhjkmZJIRjFh4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 17, 2026, at 18:53, Hongfu Li <hongfu.li@linux.dev> wrote:
>=20
> From: Hongfu Li <lihongfu@kylinos.cn>
>=20
> alloc_hugetlb_folio_reserve() takes a gfp_mask argument that
> memfd_alloc_folio() always sets to exactly htlb_alloc_mask(h), which =
the
> helper can derive by itself.
>=20
> Derive the mask inside alloc_hugetlb_folio_reserve() as
> alloc_hugetlb_folio() does, and drop the argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
> include/linux/hugetlb.h |  4 ++--
> mm/hugetlb.c            |  3 ++-
> mm/memfd.c              | 13 +------------
> 3 files changed, 5 insertions(+), 15 deletions(-)
>=20
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 69732e4cc03e..a88c59476e79 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -735,7 +735,7 @@ struct folio *alloc_hugetlb_folio_nodemask(struct =
hstate *h, int preferred_nid,
> 				nodemask_t *nmask, gfp_t gfp_mask,
> 				bool allow_alloc_fallback);
> struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int =
preferred_nid,
> -					  nodemask_t *nmask, gfp_t =
gfp_mask);
> +					  nodemask_t *nmask);

To be honest, I'm not a fan of this change. This is a memory allocation
interface, and we shouldn't couple it with a fixed GFP mask. Sorry, I
can't ack.

Thanks,
Muchun

>=20
> int hugetlb_add_to_page_cache(struct folio *folio, struct =
address_space *mapping,
> 			pgoff_t idx);
> @@ -1161,7 +1161,7 @@ static inline struct folio =
*alloc_hugetlb_folio(struct vm_area_struct *vma,
>=20
> static inline struct folio *
> alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
> -			    nodemask_t *nmask, gfp_t gfp_mask)
> +			    nodemask_t *nmask)
> {
> 	return NULL;
> }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 88c9aa700533..e84203406da3 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2221,8 +2221,9 @@ struct folio *alloc_buddy_hugetlb_folio(struct =
hstate *h,
> }
>=20
> struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int =
preferred_nid,
> -		nodemask_t *nmask, gfp_t gfp_mask)
> +		nodemask_t *nmask)
> {
> +	gfp_t gfp_mask =3D htlb_alloc_mask(h);
> 	struct hugetlb_cgroup *h_cg =3D NULL;
> 	size_t nr_pages =3D pages_per_huge_page(h);
> 	struct folio *folio;
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 8905e3e9efc8..08b9d54b0d8a 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -69,22 +69,14 @@ struct folio *memfd_alloc_folio(struct file =
*memfd, pgoff_t idx)
> {
> #ifdef CONFIG_HUGETLB_PAGE
> 	struct folio *folio;
> -	gfp_t gfp_mask;
>=20
> 	if (is_file_hugepages(memfd)) {
> -		/*
> -		 * The folio would most likely be accessed by a DMA =
driver,
> -		 * therefore, we have zone memory constraints where we =
can
> -		 * alloc from. Also, the folio will be pinned for an =
indefinite
> -		 * amount of time, so it is not expected to be migrated =
away.
> -		 */
> 		struct inode *inode =3D file_inode(memfd);
> 		struct hstate *h =3D hstate_file(memfd);
> 		int err =3D -ENOMEM;
> 		long nr_resv;
> 		u32 hash;
>=20
> -		gfp_mask =3D htlb_alloc_mask(h);
> 		idx >>=3D huge_page_order(h);
>=20
> 		/*
> @@ -101,10 +93,7 @@ struct folio *memfd_alloc_folio(struct file =
*memfd, pgoff_t idx)
> 			goto out_unlock;
> 		}
>=20
> -		folio =3D alloc_hugetlb_folio_reserve(h,
> -						    numa_node_id(),
> -						    NULL,
> -						    gfp_mask);
> +		folio =3D alloc_hugetlb_folio_reserve(h, numa_node_id(), =
NULL);
> 		if (folio) {
> 			/*
> 			 * Zero the folio to prevent information leaks =
to userspace.
>=20
> --=20
> 2.54.0
>=20


