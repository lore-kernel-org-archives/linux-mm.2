Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86F7CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 08:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCFC6B008C; Wed, 30 Sep 2026 04:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846F26B0092; Wed, 30 Sep 2026 04:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E88E6B0093; Wed, 30 Sep 2026 04:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4426F6B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:19:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 903AEA06D8
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:19:47 +0000 (UTC)
X-FDA: 85269730014.18.6719F9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CDDE818000A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:19:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BVHiiujR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chao@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chao@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790756385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JDjw+45ZNrtvu5F2t9lQCEebxqfaUjTzsJjMtfW+q48=;
	b=YjnEwZWbi0QJlW6CAT035zUFUwg6KLopaZzNWEQrf81PSEqJ1PD7D1ywr49FeWyl6LykgW
	QTF3APFT2NVssvsF4clOms2+28SroRs4X8NhRBflbvwRaS/Zg+sYIqenKEDlos6+HrvINE
	Jk1NXbg/2hf+p4vcUQVaAIFoAiTmvzc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BVHiiujR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chao@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chao@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790756385;
	b=vZrzmbExazq+9FDGjL2HFuG+sdN0aTzg2Ilk/WiEajDrE6UdT7gUAYQnQ6LT1orSGJPGo7
	Wt7IYucwL6039QS1sexe5162ksqTL05lGoFstT03p3B8iOfAhYaUMTcTIG01ZtkKOJEt7V
	UnpqSIBMVwhApf+WoQPpQI3hJub6cVE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A71143824;
	Wed, 30 Sep 2026 08:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA55D1F000FF;
	Wed, 30 Sep 2026 08:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790756385;
	bh=JDjw+45ZNrtvu5F2t9lQCEebxqfaUjTzsJjMtfW+q48=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=BVHiiujRfXo4lkjG0Xe27sjzAAibGxO1GEfBaiQC06ZMGsL8CPZg4SEawGP7ZnC3h
	 A3kTawXNUNP30NfDDI/GqHIDxsAcFHJtmHZPtjc2piUEzzjlQ3N4gKcgXfJ7F6EqXh
	 7XNLIgPea2BU/uhD8VweCZ5Iq2RIQU41dnsfyl54ftq3pIIlKPD4WFL4y/6avNA3DQ
	 E+4vcx8Loii9VnezNjNp/WkWzGVROkHzKBj1uSsL8j6VUEd0izqh0y8L0irwoDgHhI
	 LeTijnJwrwMy5Jn4xz1cIS9lSPOLbIbPDknxvbD3lLnis0Nhuoj2nHyFqAbYamJs7T
	 bt1AV2Y9qgNdw==
Message-ID: <95029d2e-4cea-4c2b-a253-9b7efd989028@kernel.org>
Date: Wed, 30 Sep 2026 16:19:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Tal Zussman <tz2294@columbia.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v5 07/17] f2fs: convert the ->private flag helpers to
 folio-only
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-7-bb68b6a21869@nvidia.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260920-remove-pg_private-v5-7-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 6dr57j79eah91c3bfn9fzmmczria3ubn
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDDE818000A
X-HE-Tag: 1790756385-203218
X-HE-Meta: U2FsdGVkX1+yYzoFKfd0ZCrD/9E1Q//ZvT1IiJY3dGvWWYNgdniygxCFkzlkbcpXq4BDf/YJ8jhyIxcUHjAPed0Nh/9DVYfnX734TJHzie4pbwe8wOPYk+qvpvTe6RjLDpUH44ZmYRJlDLqaaQ6IGEp9mPvIaBqDpt/2SnF0VU75+VEmmH0Xv1631Fv9LbPJLFrmVRmfEytVYQIKcqi3vEqFoA/3E8JMXCX4/k9xCAFAXL3eTtsQokgguQ+1tB+ZP3BFrePX54ao5tPvpibEgqYTWXYdgjJe3Sh0df7MVW5oyOorm+DcB99tNAMHt15RbqyA7VspMiL9TFlHajaXX0Vwmhl3MNzLpu2YSSgVZ6LSGxDxfZjgxCm4DQIQqmAY1oEELNFn03IFnMN6IwSAhroStcz1IJehWer5Tp51yrGuYHqkt6Y2aXClQSnYdY/CGpoUxAr0wbTnodtM3ur2G94j+k3uqgIl3Dor69bb4m8vCp47+4eVwpAScDZeyW8fQ7eZEjNwcC5VwNAzx1ZTffAB2IhKucw9foQIRlvCX/TKQmNlM//5vSAQGhC9tfdAo0/T+OXdsjodePPjaOop9mbHnLz8OMvoTHLp537g+dQK5dzB5Mf0v53eH5VtBl0JxOmRx6cDhNWak/deLiRPhnITugwxwHWrd0Qoug8p9EwQx6yGIzK/R2V10FR7JerXzodLVMcd0C8cAhAxZOSjYe9iEVC/VBdWOx1MKWApNVhd2TLGXW8aHTD8M+MT0ylCgL0mL6/Vm1cmkuSbepzTNWHE4rug5TnqXhxvNYCuQzr9ZkZ1rMunMy924w9ZgpdXm1pR/BC264qwA0sniLrRi3BDW6eH73x8+HnVARLjYAzqJ4IhSu398RMTC4toThc+BmIb4cbWjmSsOTWGQFWO3Fq3BPYfU6BUrtmyBEGcSOtAm5HcRwmsEcfjwG9BfV9iX0+xSNmaWpoaL8S47Bs
 7G+UyKSv
 tM8vzQq8660+GF6bDF7v8PuDmv6AoSQ2C8RSCVbx27c5GR0ezKFK4WycvLdM6aEGQ1a/eL60IxhLgSuXx4M4ckIsx0TVXJa6x0X1wsBow2xg3KD74iAj4bmDGryvwdxAZLdhYCi0gNy+ytFBdgm00qUzx9LIKLe2pzk71A98plEGf1Q9fQDjdH2v2Q4ajAbieYyL2/aAqexvr35TpWYziXXP1QQlPZ3RM9+eoJqKaH04jhC7WCEiBM/3aYkeR9HfDQthIMfQ63SeDa+RswMrYBAyMNvOUd9K9hD3dL4dZlbZRf/xDv+pJzpOzUu68MlDpLbwWsRrLxaMAlYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 10:28, Zi Yan wrote:
> page-based ->private flag helpers are used in the compression path, where
> large folios are not enabled. They can use folio versions with
> page_folio(). The two remaining users in data.c and segment.c can use
> fio->folio instead of fio->page (two are in a union).
> 
> Drop page-based helpers after the conversion and rename
> PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC() and the PAGE_PRIVATE_* flags to
> F2FS_FOLIO_PRIVATE_* to match. Convert the folio/page union from
> f2fs_io_info union to folio only, since no page user is left.
> 
> The folio helpers do a plain read-modify-write where the page ones used
> set_bit()/clear_bit(). It is fine because the converted code either holds
> folio lock or, in f2fs_compress_write_end_io(), matches what the
> non-compressed code does in f2fs_write_end_bio().
> 
> Assisted-by: LLM
> Suggested-by: Tal Zussman <tz2294@columbia.edu>
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

