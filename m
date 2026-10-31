Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA818606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K/XZ72zX
Received: by kanga.kvack.org (Postfix)
	id 601B46B00EF; Fri, 30 Oct 2026 20:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B4E6B05B1; Fri, 30 Oct 2026 20:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42E366B05B2; Fri, 30 Oct 2026 20:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 115076B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:39:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 590E380846
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:39:38 +0000 (UTC)
X-FDA: 85381063236.06.5604FD1
Received: from mta0.migadu.com (out-27.mta0.migadu.com [91.218.175.27])
	by imf18.hostedemail.com (Postfix) with ESMTP id 14C501C0009
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:39:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="K/XZ72zX";
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793407176;
	b=WTTxbtGo+uDQqyA3QE/VGv9DqNyGW1kOmJ6cveVeQAmT7BIz8YfCrOk8QjgFy3Sz61i5dI
	kSWK33Se9CgnTkiBwhgxCPYNcFbhFFEtXj7mT4lATeLqrjFOByokQ1Jv/ayh/xt6EuxSgZ
	NpWHKvyJoL4tPTJdy0fSm0qP5BGvbJI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="K/XZ72zX";
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793407176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BAPwHDIfEubAB0o/RcmdVXqwks4sfJbcqO9fW2tVD0=;
	b=1jnQKOG/pNuJixw/GilnlZiuOteV1s0QQ/KsV91cG+Y8WEi+0XgktwzY5JrtbIBt6Xaqjb
	tRI0XWpRSzOmzyeZYhYCA08Bzlum75tM3ZG64hnc6QadzklpJnpGb3wWeY2ZFPeB/mU3dp
	kLiWiUVxIJi65Ul0ycsMoXyv4CyQmSk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ccTYSbFE6432gMlGOh0Xb0afH0jlRKw0VR85GRLF68M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407173; v=1; x=1794011973;
 b=K/XZ72zXQFm34wy+kyRho7nbTp1xGwe8R8aOLAaBOmUN4M6mRdBqC5+776NMcE7yzFhgSfFK
 C5+qegnXG2tZY7LrVLBSewAAjqwBVhnweSKzl67O7B+gs1KeExdnd1GKKGQwHJavuofbmE9er5k
 OmsG6UAXJScLi+pCLcErbni0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 5630e70bea526243;
	Sat, 31 Oct 2026 00:39:33 +0000
X-Mizu-Trace-ID: 5630e70bea526243
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 3/7] MAINTAINERS: add Zi Yan as co-maintainer for MEMORY
 MANAGEMENT - THP
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
Date: Sat, 31 Oct 2026 08:39:01 +0800
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
Message-Id: <47C979F1-F892-480D-A12E-CEAAF3A7C260@linux.dev>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: bpxec44oeycq1bkqergosbo6diybip9h
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 14C501C0009
X-Rspam-User: 
X-HE-Tag: 1793407175-403166
X-HE-Meta: U2FsdGVkX181AYzpP6wf/alk5GTqcEaLwvjUky3jV0YWid0r0je2KwZ8wrev00KZOhMtdYT6Ws019y6CjSr+pS6RakHBbyeVyv1cLRpJNYZw2cYTadaYGc/DAN2x/rI/QN9M3XWTjh3av7SaGZWY9myLI9ehil3VHR19pp7Nodbie9y27gl0tzB6JRyAW0yZMjExGC33j5dVJPUvnHrRGFssLCLDMj7LVgJKKRAIlNYcAav4E3u0kTcrzBQ5lsiOCZ9q6oSfQGWOFVM5DOSq8c5TmSZz6yOA2VjFVyP7rJCowhDdqEQDWdaOW8hRdeJkJKMlmEtnTjdhvMbyYDqL/01F6l6tKGMmkr18RBrxO3aNMY7L5W1OYfEee4iK8MRv+F0/GRAvyGn4VfFs5IJyOORfVlzzsYIHMhb4VFX6RUZ5lCPplW2tTgQi8bobB/JfAGbFHGv9m8n8xiuyi4mCUCAPqOMylLtWWcl8Hl44x/6V3jGKZBwHFfnlE1QjWTNd5AEWV5/xlYo+NSdtYip6GGIANUORjPk/LhRBXqU+6OehfHO9gfobnY1eVcJWrh1aeSPhbtvLmnxW9vrOqKS26XC2gL6cvWqSP2jOmkJL9628wtxEmdPrAj4p3F8cSOM3gAlrZI4NhO5UNwSMkmKCTaptHM2jkPlqfQ1d3BreFvBbTFuNCiuw/7WUWv/ETV9/aG1wT0MKoZeBRlqJHj9AxtLNxAP/Yh7WWEZWG92PRf0pPw8fN2M/Z5LgkuuCeIbMlMfEEcnK/QubB2IaXgYjpjKK8zKNrtjc9m8hLTHlIYN5la3m4k170BR8rrlLxOlubyYAXWqUvwU/hvAQlAVHHBvsMBmCu8U4tOWbP/zpwL5tYBkQ+AI1obKi6Q5VViP4/ct5BtVkf2umOBRE6dhnNtNXsbhOAT/cUH7ydFjqJXLW8D+YC+8G98Wq1uKne+VzRSCQuPI31ENy5sGlpVi
 3sctkoda
 HOPSKomSrGUspb5R+b+avPg1oO9nG0tjRa4H2UkJlSZQi/WAmqDFDLm5Se7gHdCU+hUPpd3fW1hOEOpqJ10YcR5HtDpjBHP5rO4O7E8JCUgJ5x0EYhszGIJj7yKmBtRSWigYD7pH8py0MPalXYzzjx9CaLx0dy14QwK+9UZdBGLwrbT0q5eABgxRKjYb8j4NNf+EZtFDjLX/nfNgFgaeJ+rWitIlnt1h2XpAJWWZFlscuH3cOG7URngKy9CNCGGkxmBL6FasfjEWxfFqG4fbMZqYR1GrcEPcZnnglNT14EQsCT5QPlSExl2ycbcKaBC5IxB1OKSwf6RvARUEauzFB3tfuTq8HIz6fS3OJMlr5xYVOsaPmc7CnWs3Joth3XjC6bBKCv+ZLmcWMRKo5dRI9X0v0dejQb+yjsI+vK2mwMPS/HDihEVHM6SH61GYDu9k92xlrELEI/m36yzvIeIh6CJXGQfEcA7xTwWxVpLbQRH+EPaOof0sJir1GKK3mWiZGhbXZPnOKYscdZbFu/jXfbcYKjw==
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
> Zi has been contributing to THP consistently and reliably over many
> years and is considered one of our most valuable THP experts. As THP =
is
> an especially active area lately, having a single dedicated THP =
maintainer
> is not sustainable.
>=20
> Fortunately, Zi volunteered to take on more responsibility by stepping
> up as a THP co-maintainer. So let's do exactly that.

I'd also like to say that this is well deserved =E2=80=94 I've seen how =
much effort
he's put into the review work in this area.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

>=20
> His placement in the MAINTAINERS entry is very convenient to perform
> this change :)
>=20
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> MAINTAINERS | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0baeb37b0dcdc..02b5b542f81ee 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17817,7 +17817,7 @@ F:	mm/swapfile.c
> MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
> M:	Andrew Morton <akpm@linux-foundation.org>
> M:	David Hildenbrand <david@kernel.org>
> -R:	Zi Yan <ziy@nvidia.com>
> +M:	Zi Yan <ziy@nvidia.com>
> R:	Baolin Wang <baolin.wang@linux.alibaba.com>
> R:	Liam R. Howlett <liam@infradead.org>
> R:	Nico Pache <nico.pache@linux.dev>
>=20
> --=20
> 2.43.0
>=20


