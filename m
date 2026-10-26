Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCE1606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=fZ/mmV5g;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=T2a+0L1C
Received: by kanga.kvack.org (Postfix)
	id E781D6B05B8; Mon, 26 Oct 2026 13:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02086B05B6; Mon, 26 Oct 2026 13:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1066B05B7; Mon, 26 Oct 2026 13:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9686B6B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:15:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9C0F12083C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:15:35 +0000 (UTC)
X-FDA: 85365429030.09.B66CF5A
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf05.hostedemail.com (Postfix) with ESMTP id B76D7100008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:15:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f Z/mmV5";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=T2a+0L1C;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793034933;
	b=awh+q3JxBoZxSG7f/80F5JaKSOc+5ryDYQMwMUqPlWlei+Ev+yEb+UJyDRxCcZTyC2bIzM
	qTVJ38nVbwb7cVLJ80AmidrN7TIzI3wp4Cesp6CufuwtZzFSnizd0QIY9YsvJNR7tOlPpz
	UTpLOQCuJEDycosg2K25iSr6OU+Wmv4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f Z/mmV5";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=T2a+0L1C;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793034933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgWZTIZ7qHEcd9eqvBpm5VFp1o1TmVO9nxe8IAIt6xQ=;
	b=q0O8I8dG0dUZeGvNXb8yx9kv7sjk57B0P/JLygs8YnCz7cw53vGcAP39M7yufFP3IQoxYz
	tnBlSn8MA92UOGdIMR14abk7MSm+aNk51hKfzswW6pG+q/lDSwmh/P78di2OVAmeFup7zT
	HbKvWRMqZgldnMk7D7TzLmavZ7Kz2uA=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 4D91813802A0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:15:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 26 Oct 2026 13:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793034932; x=
	1793042132; bh=WgWZTIZ7qHEcd9eqvBpm5VFp1o1TmVO9nxe8IAIt6xQ=; b=f
	Z/mmV5g9zLaRu5j3caYih8wYVeK7pKR2YtVumaOb7e9AEDxtWwuyOeOFmO+eXRSm
	1PSO/VFOy/+mWa9abx3T/2yAELqvdnmAeSJu4fzYNvWJTRR2Jy9srIM+XYmCKdSN
	34dn8nODhQxO4aGw97WCjkzr51iOwn3ruBlaWbfWsb19OudhJxbB5YDBf5pTNnXU
	+85Hyy13345QP8VDIx7HQEcye1Kq3tAknpXR1YgWlU1X/KWCkckpXky9L9/pqTyz
	ooN8GW80M1NG7tct3Au1Qb4j8E/mEuaXsdTCAaG59G/O7w4TwqAvgb5t+bXBUdLR
	V/bb8NEqSPXsjaQ2/6n/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793034932; x=1793042132; bh=WgWZTIZ7qHEcd9eqvBpm5VFp1o1TmVO9nxe
	8IAIt6xQ=; b=T2a+0L1CD1iecshjOU3hWu8d37blUekwLbjtDS5gZpKwM9pjLG9
	Vh5wjo2Yl1LE3RquV44L5MZlVhg7ag1UV0M73oLMBcwkzOTV1CLOD7lFHm741eds
	5JoDvLpHNfPTRMvfMpOtrtztR3jMnXJWgPZWUrmoeGxD7hBnGsMLrcEjsVQIAF53
	vto83Oo4BV8/3XsguCeiXq5ueq1ezjOFmuP1zROLHt6nCS1xsspUVr+0RPfxa0u5
	02AlJc5y2VQEx4RkptibYJOCx6zM4phKtMB08UgWHrGyWEGZ68xWXDPNiMuiIId1
	UNfzNs6wjmOLNqXYP2to8UYt7mU5mcEMQYw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793034932; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:P8uyKZaalEF9kO5xM7B9rttUkFvOydiMHxdX2EPPowgYevw
	mMOLc850LgLXn0D14WRKMlnNlCPlwXBB7/dz/9NaSF3q7GBX3Zs0M2VIbFMUKXWV
	Hy67Guk+LB/b1fq1jqkFN1ieu0750YKiOHzxRfw6nam9nkEF0Xt8DdCtk+12nv2Q
	88BrS3LmuP4TIthd6HNooEEhrGktyYa+4BYodBHVlh5BLFJI+sm+CE4m9r7IK/GP
	lC9VcHZYq7t5UuPpy6LSDx8wwWZw5Zxo6MdlfXDLuHX3rRoeFuhfEQPvmC7K3GiL
	cMoI41sypd26iCo0pMlB8zuZRGOgbG4U9uodepA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:CwTqFkX92AiYgrdq5UPorGiNimGP5HguOsZVh3B4CWU=:5B4/pBpvFw4Mf5/ZSFPGmD+cCMlqrVZFb5WHDs2mwGE=;
X-ME-Sender: <xms:s4rfag58y-RJ_XDZpFZWVrazj564_G53BdUi_PptTtpdDPSLEW2lSg>
    <xme:s4rfahChi4WKT9gRwf_v0J-xS1spZmaNKWGYOzR4IT59tRyctsE9lE_ag6xsXsNph
    RRuAOVYRa9nEt1iJnji-zjC83WAUgaHOjEbBHy7FzNNtSBNgTZwa9HH>
X-ME-Received: <xmr:s4rfakcGZqQLYXC2H57zOUOZqsixT43wyiUlZ7bmVPj2z9IMwBSTgVoP09M>
X-ME-Proxy-Cause: dmFkZTFB6PNGhMhAXmj0ZOtRvHKd56A9JXD4WvNPHaZaK2XiU5P65xov6wStY5RJjkvPKO
    XSPqLzkGO4Zo4ODwiKKxS0X6P41grxvQjvP6oiDZiTh+fpDH0yL2MunT0+fjiS+FaAqY1/
    PaJgc/5aspdPW1Mj45Bp7VVVdrPLEgSlrB+JkwItGH4qYwuHSgEwJtjBUZKOymAYKJScIB
    KoMf/Q5MRD1DE9DmWfw9Wo0qm6Ock8Jg/0ZvcH/PY8Ox+HjLKJTKKASZNlPl8RIBfaFzN+
    hv3kzzwRvjniNu6oVve34NyDlpJcCbxEX6LePZcQhFmYCUOx0RpGtkzk9m5jAP/xJV1jqB
    qmfqQgYHKFDf/konLHPaAJTbFRfxuWNuwXsBKupI59MnPZtXUnXHlo+/ycyFM1EouEFEOx
    7zcJr24zTYLLO1S6FjnCnGL33sOzapaodQgyvAUHSR+M/pjoi3r1wj6VJRM+aigFAfINZQ
    VhhPPtbohfWHOpzxaDLQmMyoBtRLSztcPzs4dLBl1kNw79rRydZoPrFc01SCGpo8oEKDNH
    wHV4Oldi896kOORnjwO8XhqyPwv4StCU+V/qewoqv2I6NmJul/pFVodwr6eWAdHuancEy4
    TgqJLAjDjyDuZTnngn7454DY/QRz+2UE3Wx2GivQVzMxTOcFQZPY0oQk91Xw
X-ME-Proxy: <xmx:s4rfakuJjJ6-h0mknCrr9JvZdH7hQUDw35nzt6NEtELk3WpJKPuJqA>
    <xmx:s4rfasNMDaq6ohN-_TuZ-en2CdiRi5XkgSxs0kvFu5pl5w_Yv2ruAw>
    <xmx:s4rfapHLmcRWRAKMDXbGPP_ApfgdpsicwQ4b7apUy01Q4IuctmCrIw>
    <xmx:s4rfal9DZ0S-IpAzW3tGo-tkqwsJYFiR6l7ih97I4dUG4PAROuBgTQ>
    <xmx:tIrfas6H2672-_gf-0iJEJOe_gcSKJw9pgPdfdJgSt2h7xlz9Ix8uzMA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 13:15:30 -0400 (EDT)
Date: Mon, 26 Oct 2026 17:15:29 +0000
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
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 10/16] mm/shmem: discard whole new large folios on
 fallocate rollback
Message-ID: <at-Kn5yabin1E1Jw@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-10-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-10-703206d5fa0c@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: B76D7100008
X-Stat-Signature: bpwkknq96wpnsqs1j4xfaz1fsamqikhe
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793034933-494334
X-HE-Meta: U2FsdGVkX1/qW2M6pciALfILjJIYDuRVzlt47+yfcpIGv/HBRTLcd0QnTUTj440Ixq1Eu7OGU1hLOrBJIov85yXqiVNphH/SgX6Xh96FxnocNaJcHSjZUbLMFAxw06tYEQlQ2NKhR7cFp7tpPPkTNUwlbiLUKROvLXh02QXl7D+dE0tLYDuzMqiUiXRsINWL5s0RAuH46AtOCo58MH2Wwo/QEHFWJn1Qpr7lvNqUVOtQ7j2zyzAz7qPSM556o7YOK8lsG1+uY99QBd0sdSjgsaAa8Iytu/2WV63oZMl2QJ+ql7rvdkfbfhl3gxh6sRt8Vw3GnuDmM3N8NUJfUE9EDy3GOUO3AxfRk1gzdXjBWdb+uflHRLhn3FUjFiMQnXSalDs9NVQnAnQ9ZUTteOgPDDQyn5s43BU4sg7qxXR3L4YVGA9q1B6phmwiXCHdCGox8pgX99hBJlRbw5NdqycvbZ0N3JQ4FxcFnyD8uCLanUJb8XXrD9iOGL8ZdrkkHlMBCGMNYoltXlChQnMTikXYejVG/yB3v1Fsc7edw/ecfon1Q3BwZPvPqatlCNy7IlVySKgOpoZ3UXN0fdEe0YiJzSUi0gYI4BBwdSkiiyxE84ILVQ6G27xYAWpLBe8d5UmbY78c2c4ztR2xbmv1nCBG9wJES+ze8S/W8J7NlBWmW6aQ304huDH9f7rtXWVes9UlHXTPv3oNeMoohkvkjVCTiMdgwen29ecw1uki8K7YYAxzsyO8wW06vimji6QV2a7bhvcKNgld51uQsiu+oHDchs+4M14wWc//vaO7zUvapKKYqR9GJIOTKN1CbbXFk92ho1HNFvSxNjaT+1nM5Fv2wGHGytLnr33R/Js21HTulf3IXTYCi1h8j4MgRVwLzmpLTOh5MVQVjUo0o3lZw2sK6PXPPplQWWYzCETY9u6DGeSSgUfsw5injcXrmXx2kB1K2JmorOO0rEHHz0aEgjF
 9l0mEwCH
 uB5vqJW8QebBl6ZjqVGm0wLLcvXbaz61R7LzPqxGiM87P/U/ztQ4oaROfRqTNHbe00hv/275kF3kigbcW99wQr2aOl0hmGAdNKvk7xhlyUr0FKxdjISMlrn+hgA1xn6MfLQ5PdpBspNngVJabKH14IyKNfttUgPWhEurtoqNVNY95qcm6BWIxvnvmOEcGdrHiIfkDIbi0qB0XfY+hGNgDha48x+lfORBYqe/KN+DregqW9pu9fs/vRrnuuxR45eUrt0r15ZjFL43aW94fTbqk2yJORVJXBr90m8/l+8zg8hM0usR3UrW1FA4ZoC3KWFnXQ4f6XiokU8T7jj1jw9xmSb9tLEWg07nO4OHO8SaHo/PnyP0zqcf7EoFQQWF0OwXhzZIBciOiLvJOOame5QMEhG+r5BSdtcdbn+3A2N9yTlS74Q+gAyE6XxAJDr7WyhrjVrb5SoPP59q28QFn8JwhzaAe7AfVbR6aMIxkWr/C0XPC9N3jdg4F+lnjQ546khAB7kOEZNFh3ju7PNe5wV069wkD7gahGN8TyRqcm9ErWSpOfbMtRIcO9ApUKU6uHo85OgMOqoY3SRLmps7/miKAfqKtvDPRfp4XKqyR6NaoROh5BLVgkuLH8w3lSoCKioSzCA41
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:43AM +0100, David Hildenbrand (Arm) wrote:
> When undoing a failed fallocate(), shmem_undo_range() must discard each
> newly allocated folio. Its second scan instead passes large
> folios to truncate_inode_partial_folio(), which does not necessarily
> discard the entire large folio, but instead tries splitting it to
> discard only the requested range.
> 
> For example, with huge=always, a failed allocation starting at offset
> 4 KiB can leave page 0 allocated in an otherwise empty file.
> 
> Discard the whole folio when unfalloc is set. Note that we enter this
> path only for folios that are not uptodate, and can consequently be
> dropped without losing any data.
> 
> Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

