Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33815CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997476B0093; Tue,  2 Jun 2026 11:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96ED06B0095; Tue,  2 Jun 2026 11:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DEB6B0096; Tue,  2 Jun 2026 11:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 767956B0093
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:41:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AAE51630C5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:41:49 +0000 (UTC)
X-FDA: 84835387938.09.43E3DE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4E92014000E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:41:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jUrX/DoB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780414907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6hjEXFIodlvX2INCmoabWYeGG2q40wKJYAYdqxhbNA=;
	b=a3BaHhaRAdr96xbACcpbJH0dyUDmcsek8pNuNEez+BsQsCj8bsKxeeS8YGrOhUe0VuHwJI
	3QZIB/QrvhVVl5Wc59rawaBkwQ13wVgmGJ4sG7tG4/neyyyvgW0G0/OGrYKJhbQ5XwwJTm
	e+E5K9+imRyAPEHguHC3YJYI+T8pw48=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jUrX/DoB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780414907;
	b=NtaO0Jm6QLe1DbWdFalOqkrOsrocvd4z3JXYsOfuEVBGtjFrWYUlbGTAmEYMH2QJcOJI5y
	dk5yha10/vW0Dvb6eEubLQmyyPti54idOPtk4JC7wjcbuJMo6/QBuu8vjFhWr7kRw7SFDy
	edv7mDCkv0anxgrsIH9rbPbx5qwBFKI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80E8440AE3;
	Tue,  2 Jun 2026 15:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667801F00898;
	Tue,  2 Jun 2026 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414906;
	bh=u6hjEXFIodlvX2INCmoabWYeGG2q40wKJYAYdqxhbNA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=jUrX/DoBXHWclZVWAjvP+7tw19ddYYGmISVNtUcGMhSSciNu0hP/H0gsSUgwMVCSC
	 sye1q47DoDLLvQurDGUIXS7wwoz3YAHHPnKvg//QjAeqCyIPPgU9vUg9gQiXULfGEa
	 5AUzO9PrWIuaO0TTP3sPFHnbpyOtxwFYWzrr6EW9jdCu7EzsD5KwjgG0W0msDQxux1
	 7+/4XIJxatx2EXFdz50enwda8JbX/5MjhP02qWQA4ED2/8lTLhD4oAftbOp+eBn0QE
	 gVRNgLQpMTvVG9YrJA/v4eZdv7bdDFfDQBS+6AAcUnP/2eXLJ+YE5odpAPO6DyVE2K
	 yqhqhcg2mQhpg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 15/19] mm/hugetlb_vmemmap: Move bootmem HVO setup to
 early init
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 linuxppc-dev@lists.ozlabs.org, Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <20260602101039.1867613-16-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-16-songmuchun@bytedance.com>
Date: Tue, 02 Jun 2026 18:41:33 +0300
Message-Id: <178041489396.457517.6730523256790632908.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4E92014000E
X-Stat-Signature: fdrdhuo9zsg8ii1ydbm7ktjy3zmrakwf
X-Rspam-User: 
X-HE-Tag: 1780414907-704895
X-HE-Meta: U2FsdGVkX19AaLuczZQ3atUtXFpvUd9g3yAYEg3Cb54tx7frG500pEpzrbOHOQI1N7X5XEXLI8BlokMPRYCV6Ep63Zw3/9BxNx9arBkMY2vcB5+setywTan4LpKw3/ETtOBtnPpe11vGpCp8jAfyH2LQbyu3/8KiwGBMgg2SNBBfbHHN3EFpuG0O4I6uJJRIbVqodN5bsIoQMCNlSQcyCwwoIG6pa9wOTsNzloiNd8PwxqFKWwU8QHjK9oU/rsk0RsFZSzmKgUm4+vVk2/1/2JmeWZlpGTx/Dg90FfLYe+C4kMbRh9NedhmRtom7xszWh8P10UM5nVDQbnLToM5V90Lg/0I+z32Z2d7RIugf94i1dVfrTRISZbBKTcbqv3S6hO3iLPu9GRec+n2+azxN9KyO0SdvF8eU6mWODrchX4P5ipT7waS+jxyAVgkHSqjlp2vbWQy72o6g4yUXpTZotytB67eoa5awaznHGFKy9AWo/24dnWDZU5BUqKf8DjrEOILgb+thn76QTI+uCMvYnt/EPDEMkt38ms8T+FcIKwde+uxYMijB4RIGK7lsYzS3BkUTx+47Kkkx/US9h+/tCUYqjXLLCC0f2NEqk12yoH/lIj8FnsZQzN2IfJNi875gyaM5kE0XNoNnUL5LIDOSnaAbYhzF7aHdbP0ANUQ3XGl8fKhX8enrnJo61o0Sa8Vhehe87wBzq4NQ/p7JLGyHbCXx1Jax/jf62xSd4GxIwfxCAmIFXfpX8OIAtJ0I30kbsxLIlvt6ySmfMWpBNwLvw3cNrdJu6U20AneKK/ogS2xmmHdoN4eEAwTp5SZ3ET4k92Xkkg2i3O4SpUykXoODw6cphAqEevoJcyJEbc8ihD39loPyQbiy1rce0d0YNVknXPB+2Ym9DwWm5Vn3f7LaHJqJvKpktxEr+SRIHfUs9mFOtCT+8L0+fOiT4ueXxj+QqFCT81L01QR01zdHPQW
 nCxWK7cg
 LbVx3TYIgxvDLHLJo6dnfbDNtc6BiFaDalwylBbj4zn8Ilv/oIM7K0Y4E29u9iw4A+IFZhLcWrwA8KfUJfFOyA6LDQfDsPNLD5oSIJzUMTg8FjB75qYDDBxy72Hl5XxEI2CZsiBgL8GGxmX9LnlooH/q3hs6Xmv/OIbULxC/VuzITdTq3OsHMIn3Qu6fRhjgU+v8MmZM6zNAOWixVNHwGgZSWFC+bFKEstkS5oDyRXkC7UeDWLJAlDt4cOtwXMcQKoES8u+gzZgDOLhboTQaL+XsyNI9EaUJ3TIwPn0993pvgRhpuYf0ckLHb4wr/kgu9rLIH6vkFUdbebXyi14LDc+3fsru00m/Eaenr75pe+Mzcr4DfvXA/8Qd8xNVYTOiBjqXp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Jun 2026 18:10:35 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index ea6af85bfec1..464578ee246e 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -745,6 +745,8 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
>  	return true;
>  }
>  
> +static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn);
> +

Can we please move the entire function rather than add a forward
declaration?

Other than that

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


