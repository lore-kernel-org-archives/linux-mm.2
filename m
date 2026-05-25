Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 082BACD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8EE6B009E; Mon, 25 May 2026 13:10:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68AA36B00A0; Mon, 25 May 2026 13:10:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579EE6B00A1; Mon, 25 May 2026 13:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43C246B009E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:10:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 040D7120197
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:10:17 +0000 (UTC)
X-FDA: 84806580516.15.E8CFEBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 69AEA1C000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:10:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiP9hJTq;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779729016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZaQ+QowX0C8gRVWN1yv5DhtG5U/Mg2xarM9pU/7iWk=;
	b=5VitBdrq56ZPJ9qPy+Elz+W0GQFy5DLqKLxzhLWnvULP5QNpjibV4BVQArhY9gMsHuanhu
	2crAH1IWoUCHPUSY0RidlKpvHs0TCyl2jZiE7c0I6Ve13wmcQIYwn3ocP36g7sxRuoQJy2
	oZoj0X0ozyamzPcs+wxk+p2VYuJMuz8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiP9hJTq;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779729016; a=rsa-sha256;
	cv=none;
	b=V7w5mi1dCzoKf+DPwS7ggzxU8nJjEnQab66YMjqToUZG+3MhHT0sGol6X0QxsXd8m2q0Hz
	tfCjlu9gAavRmKiPMefOq1QcHVirr3wJJDDEIiCuvpaokdmL986Jz682L9smcKKzqxclL1
	2/r2VKrmIG0HmPNiMA4P/2s6wiip0RY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E17DE6008A;
	Mon, 25 May 2026 17:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7976B1F0155D;
	Mon, 25 May 2026 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779729015;
	bh=DZaQ+QowX0C8gRVWN1yv5DhtG5U/Mg2xarM9pU/7iWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GiP9hJTqjMH2adM0ONX5oIwwpXnd6BF9MvgXhQBNMAl7X3kWDwmw7Iv4kMmggikRq
	 nBqNPSvSUbp/u1YDnraMMzc2Sh/Osc6eLDC7h64gYmz4kaKH8XJE94fh8f49381r4d
	 Q9vZ1zpMEq+Yd7ouvXHGlcDwaPkoV2UNygDW0KvJlEyVzeugFcnImi0qdHpzm8aIFN
	 1y4FJMxWw2SATyOvoT8cyZECWGQ3kD2+Ni2EhmlAXPXtDxb/iVRRKnKXGA83g9QKzz
	 +NeD+E09qdCKYj2LiW6gvpZVcrQWEW/Ow77g1UcLED7dHYmEbkAwg3DtTbpvtvX5Ys
	 TeKiRmjRDug+w==
Date: Mon, 25 May 2026 19:10:05 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/69] mm/mm_init: Remove set_pageblock_order() call
 from sparse_init()
Message-ID: <ahSCbVglzNQlsDMK@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-11-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-11-songmuchun@bytedance.com>
X-Stat-Signature: s1en8dfqdnjm8ao5hxq7339fsmqb7ne9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69AEA1C000D
X-HE-Tag: 1779729016-280224
X-HE-Meta: U2FsdGVkX19/3busDgbkoS7Kk1SCYd29GyYaUriYQ+TXFzg+8xxKPtSjoRvPPXN8/ojzYc/TjPdGQ5xDzYSuYAIyfoFFjpN1NNfAtZMfNLLANyJJRdqulUA6XnPxAIxqVL5A/ShwMbh7wbbpz44ohizmWXXQcC/XSgHje2MXGfyzYMG49fzk3TdiMtZhV0snCmwVrzEY4JN3TtVLTau+e/uyi2DmDLm1cgr7fdcWqokYZflD5cuJ44Nuk+qPD3U9EANiCl7Ic+KcILO+vs4C5nqud9kV+5vvh0sQS5KlAhr5MYPITv9Qo4X7IFIrpWHF8HuHWzYoDJDtvjoY/oLVFitRRKZazVyP8heH1AHMPedijPEj3peMbNk8dn3pVvprpQKBCVhObmUR17YjZ7egruSdZcrQEWSsT/r/4seDZnsTNpRMaLXUVV4GUL/JAMF/HhZ1/u2nwGsPNsHF3Em8vE1yhnUqWZY/ZcPr3HpNRDdnrqfiz/M2xOn7EDKIuAJRw1BmioLULfFsv+TKC/Xskz5s2HuoAV+TlKMsK3Epd5N4OJm4zfmTIJ/62thjopBuiq7UdtcbNilf92zRS5kzYpVMyBfItIkn0irifq6dxx03GSqGA14TTiJpHz+r9G0pmwpa4zq/17mxHOYsow0khcO15P74VuZVFptV0voSe9f959b1QP0fBaruKlJEYoHeemvVklddtwkoHzQhlhZ4hGEUT50C0sp23UcjM/DvKwXJSYkwZ8QWy5e7HEAUKG5hkDX+70XeR7BLW8hYnDoD1KTYv9pVXjInqclcAJqWN2QwveLIyf690fRbLSyMhETLVQljRGRZtLRdjLg6UKCX/n/xukstiQvinGCg56kUkxdLR8pKKAjNe+mfCdRQYVOKGipuOnaHhavAynMXqKLzvGrmW5FoW5tUs8GgHxOwSCt0V0SMs/clNFvbXx9+NFE43i0sjTcW+RlqJHoPe2f
 ngxJU2aP
 mjeraxsq9r5QyXDiQBiyqjV3SacJtIsnRI1HLKWHKlNDZ9oYELKcjgnZ7RRN5+mpQ36RQ1oqYbwoWaqFrjNmeVpO0qjf+1iIHO9erpbWJQDAxGAKAyhW7+oeH6dHdGQviiauQCx11kawAGKWhPMB7PJ/u5LNWBG8T2bpy4rFnjTCWjPcLHxWy3466mYPfOQpsEe1xVkHqa1oXAp3sed3O5V2ThJNhCcTDwqNIQCJf9iM6rb8hk24Gyk2rMipUjzR8r2oAo50OuB2CWVrh4By66R59zXcqEOG25wJrvskwiJuTabeWReF8NKHplg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:38PM +0800, Muchun Song wrote:
> free_area_init() already sets pageblock_order before sparse_init() runs
> for CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, so sparse_init() does not need to
> call set_pageblock_order() again.
> 
> With that call removed, set_pageblock_order() is only used in mm/mm_init.c.
> Make it static.
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

