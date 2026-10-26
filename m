Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60FA606AA25
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=iTA75d6l;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=X3xxhdlR
Received: by kanga.kvack.org (Postfix)
	id 12D826B05B5; Mon, 26 Oct 2026 12:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCD96B05B3; Mon, 26 Oct 2026 12:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFEE6B05B7; Mon, 26 Oct 2026 12:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0D046B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:30:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5509A059F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:30:19 +0000 (UTC)
X-FDA: 85365314958.01.797631F
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf08.hostedemail.com (Postfix) with ESMTP id 885A9160005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:30:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="i TA75d6";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=X3xxhdlR;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793032217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkW8hTzvtjVugfe3/cd+IeBxoEhuYAvDS56/L0h6ujQ=;
	b=ZTqRHoWHpTlPrqwf8zYbhJZuj3Ro51rMydHOdi2Z7sKEa79m5ygZG8IfcRMa95hym2vDK3
	oLz2DLjFT0fH5fvIgjZVZz9NVLI+iRHOJcNAUU1a6Z2sePmkreBzY5vgm/MoNH6LToaXdW
	R6/nso1NvXDOq9xOACJj507jLW19UA4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="i TA75d6";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=X3xxhdlR;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793032217;
	b=MvrZGXeKT1XuVCL6u6wlKR1pPcQsSrgqjUMFqcay1SljvOAoKOj+9Y276y5xErBNNZktZN
	aOQ5litMo6IqLqkZ95/blNleGMMLpEknwPYLnPxYn4sgRFcCmuc3DW46Et4UIxu2e+0+K1
	3jHS3+j4xZ9rfC6Wb1Q3O8dx17VCfik=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 1010613802E1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:30:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 26 Oct 2026 12:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793032215; x=
	1793039415; bh=qkW8hTzvtjVugfe3/cd+IeBxoEhuYAvDS56/L0h6ujQ=; b=i
	TA75d6llE/xcq40kiQHScyFhWzb6jHXmASv7BIV7WU5uKGLlXJjXXS9HpwoVuGFb
	/K6tVwJ3BVVvQSSSEjSE1MJBHASEGZlkEWaTUXazbh4lxcVDEIm68C8IO9+FzQx+
	5kAgmJdLPtqusbVOZLlxf2pPyUAf54p/uX+YMBulB2ohMLgQfKMMHoRTJXxsWFSE
	moTnXBLhJMzbZI6eC2KfS7DA0p9pcL1LZ0ktQgarsgKl+upAnNJ2wz6QzADl52KR
	fuTolfSbHIXIYJJLpQCjgmfj/RXcF/4vC1ElP1MXM4fyJ6SFOGXBL0Opt0bAbUeX
	s9LuUf3JX7+EJuLqGBR9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793032215; x=1793039415; bh=qkW8hTzvtjVugfe3/cd+IeBxoEhuYAvDS56
	/L0h6ujQ=; b=X3xxhdlR2n4MJYClXgFifMkH38vNiCxLt17x22NP62fcWsw9jty
	FDPj+Y2LTzf9yEOu0g01xcZynWXFVHBaRDL/BgMZgPABu3ChVjg7V7ti6QhM0NUm
	rzLhZLE6KrPX+aon4+KRsm7b4d4LQMdnh5hE6uGWNUe2JBjIcrIsMeTV6NorS3FK
	3IMhezpxWCr9a7p99ejrSCR9CvbA8Zde1oztqxSAe3Vg4Er4Lc7VZ+JSd7lPDv9j
	Ebtr+gHnoBaVYOVVSEXF0s+Z4OdNiBEY9cHqwas++9h8JrDuAUnRUZEXZZhey0Ed
	2JS07uo9aPY8VJ16eAcMBrnRLwFwk8z4JiA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793032215; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:qpev2qws4ugpMyO1lh4cjqE5du2N6sOeQlZKgU+777DKgiZ
	bwvt1NkeFyKgYdv4GWqnh4cIyxwd4gblbAnWaybXnV1VTnbuMbx6oEbUOJiXZDgc
	NAc8kbbi35fnFeOx1cYEw6iIp9tReJvii/JxH28w1NEMXOjJTmYs/MLpbkECkNMl
	+b/1w86afcBfxUVg5TtW/PsulNxWdmPJTXpIlb8IK2hM9FQu5c7OOm5VkkxtVyF+
	glGrSw4u0RBttMKqyJbG9PEIVm2GTUwEXFZOQ9FTI67mu9eg4QfpJxEqmfBXyeYE
	i828G/vpy4J490NJBVaBTLwtHg7DMw47ProR49A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:GakGN8qDwxnLhCAG78QpYNYCR7V4xlLXBcr1KHPT+UQ=:7lCRhhNYSHJPCDvJwYOj2cow038OFhaYSoUQhwE9Z9Y=;
X-ME-Sender: <xms:FYDfanvXkyEea80OS4g-HMDR8dV821HiTsjTez5EuF_BI47RnNZY5Q>
    <xme:FYDfavKRbx5EE_a04UWBuZGwZLlWfy-y9hHZCjeDBnFwFninJRiZ0BWMNmcaJRLiL
    -5m4cP5YW4-Cu8LOVxMUbWR7i9l2kMWjqQYrPzwvmqIZET2O-pNmBxT>
X-ME-Received: <xmr:FYDfak9ehBsvEqCtj0jPaG4nt5jKdVOVWMXN_UfqyGBbqFGgbYSGKNiyCnk>
X-ME-Proxy-Cause: dmFkZTEetMPf/XdcfRL7ShlxEnQmCfbKvikd/TPBFNP27ZTcZmgT31EhfOi/lE0FelkafX
    4nAi2WExLdLEStuSv6OzLxr1FeJJRsbSxrLe7wa8dc34xBQrx7cAOMxFzRoVJFk5Qsh0uO
    3vA/zrTAMkfwR+33ShcBrevmbmbjCEJ5M4+t13BlrItdpaGS7h89mEqhdf4Vcthfjvl7fZ
    JY1jeYR5Jqzd58wPYA24e3+QB0qz3L5DZAkHU0wuuDD7O+cma61OgrhdFnkOuGNYMTr5Kb
    tcNoMIjF/JZW/GzBtIF9JLJpYt8JL219hOcQpiwgZcI9qmb8mVBt6kN5ZF3aEOY3+qh7q3
    wpB1e/JQVuYv0tdMiJ3nFzQrng+lseyyYUyexcRbehvfGHuE8y2dx/51AJTh+smEFcOY+/
    A3BRHec7M8PHYUKLlB1Bw86mg3OeAhGHkjYNicppnIiv686lXB3QAVGNgdTizQUiG9b5Do
    QbY7tAjLfKvL/B3IDStcqXEGFwYsCjPGtwMJg9XN/0VVcDYhu/RSTXxYndsDsa6fPi6CNv
    sh/cPQOJxnKbX8eWveAqPNOoxrOWOYWiTvvSATYL2Eg2R069itIuZ9pobYunI+1Yw/Ltw9
    mrM+mWqaoNr+FulMEPY7Jx6sBUcPTJPkDpn8jLB3xCTHIAe0Yfo35SVaeHog
X-ME-Proxy: <xmx:FYDfam0_8C3KpamzyIszXfz62AIHNa4-AAfeO3NWAEkOrnzal_D8dQ>
    <xmx:FYDfart4nDqBnUyuI_o-QlRwuryuUB60YNDQaM-yWWha8c-dX3lTyA>
    <xmx:FYDfajI7t4H83H8SrGihVtcjFTioX-N37VL8y-xmdKip-NQ2LPcnsw>
    <xmx:FYDfajN1-alR5Gax8cgiaF_zd8UfzW0J7-4haFw2jlImezufspCG_g>
    <xmx:F4DfagqFcBwbRuQ9lEWjIScZKMJjdfBmNxHH_flaVixXjJtm609yB2Ma>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 12:30:11 -0400 (EDT)
Date: Mon, 26 Oct 2026 16:30:10 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 07/16] mm/shmem: avoid moving the truncation start
 backwards
Message-ID: <at9_2qIA1Lqdhuxe@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-7-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-7-703206d5fa0c@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 885A9160005
X-Stat-Signature: 6xusk1nh8yo5b3jqjb33pmtstqehy37d
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793032217-604470
X-HE-Meta: U2FsdGVkX1+xYh8sxYc+xb1JN8A92uDGc3r7so37gbHHeDzTSZ2uRULGRABbIfYT20cdgSsxcR5iB99mp21VLK7T7bvLWlr/xKBae/tsmMUhMKKZYWPn5ov+97MSUZOHQv8ZlgEON1x/dJyckTQxueyKNXwXJcMbVEkGagj0oe+6rgk4SzUHv92/V9MQHK9TTwPiDafzSu9cVgLntBusdsUD2zYRf4wd8pT6/gdUjtNKEHxf3BIctCumrR2vzj68h7mux3pDkpzr2Kuu2GB8RToIpmnhqezW+7pqItB2T0wPjLNKqAuvJ1MVRijITFJtfhQe3Ii/kYSdwRoI/jPME6qEnzIhpJ6Xe9HoLpcffc45jSbt9TU8FUoi5EqVle0ZT7tvGdFgSAypQqRZlmguR0gyb5pPSswqo6F9qTmcRz1dNEcvwGjkcmVYGE4azgoJkx3y1IIULzdvMyTmDDK2mNHxM3YWUBOm/Pv0cahl/e/E63TA2Nyiz0Z3Sds6ydDWsbJiRZj5P3RCXBQpQQoPzYGqPgXIirG48qRTOUnrkHujiZohWS7wxTWnEZV1MRPcEQb+a6lSFM6sITujsN1YZg3K87m2JyDAD2MjnlJIPjpVP6TMVZ735esRVywqRBEma3A8TeERp9lpFiItpJnok9uPcC/LftMwaejs+d6EaRwGmW8qteu8J/1Ip5rEqfGGXLSTB68DZIHIW6+xE5eshWm5EvIOnlqEZpejF7V4FKwxbgX5YezoNDePRINNQYC7jlqt5jO+y6y844BBXnWPXoNkJTIzgnH6jqCQGdCxwuUugaz+mg03oCM2wX/hTLNRUHb4hGz+eEj8mV8vH5x0XHS3zfa+GfU7irZHpvjbuUey4/+6qzzRFEke+NSFC0CyQ6Aahqpa5VnLPZzbqmhaEel/3uayrVwCIK+w8qxLCX9+4L4bULNfYgmXajHAYNeD7ZnngXYla3NtytQaU4w
 B7TpYKRo
 /11ollAMZewnPdU8rmbdxJftmbYaLBPHRMSf77UvY25MRjfmswDQZonyK++A4K6+Zp+54IlVl3dI4Sr4xkgPXuW7gu4MKoWVV3NhpYpxh119x9k0samWdhbHXrmtwl+rPal/N8AYqqxwJ2YpRAa+sWSa1QFnVj1sRTpCXOXqMnSDD17sTlWXuzD2vAOlrvEEdt8xLoTaa6NSa/FkEJfLs9lIVXHfmLWHFBKLf2Z3GpRCT4CDj9pfTQrMP9TkPYfgi5s3ZqPz/7b7Im4U1Bkjrvbp8BnBurz6yTF3TWikGQ40J++dcinDyIRosJIXEzT+2vZxjISmykx5QeB4ZPZ3QI+9l2/eDGHRfILmRr+hBDzFvDWFtwzcsSvvMigotGYs3kAvgIMkBNRGI8o4PzSkFZuLrzkOkQVd8XouxXItuLtbIBkK6U1zZSTrPqfrDSVnuDzB1shpb8Jd2XSYO2kKgLaEHv5Koa4bHtUai7HiefWvUFjXGY5btVjnsdk2UuHZEPFuNoqRJbKP9WIbty/6gXoXfxlrrEwTqeNDRda0wvSn23KcNJRJiAh7ahHQl7K9f6ptVzv008DrjlcWAuSNkOfeeJgftef0okRsWcs2Eh1kcj7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:40AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A nonuniform folio split can fail with -ENOMEM after splitting off some
> smaller folios. shmem_undo_range() then sets start to the end of the
> original folio, which may now lie before the truncation boundary.
> 
> The final scan can consequently discard data below the new EOF, or
> keep retrying a large folio whose split point lies outside it.
> 
> Keep start at least at its original value when skipping a folio after
> a failed split. The part in the truncated range has already been zeroed.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate operation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: split fixes, simplify descriptions, adjust comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

