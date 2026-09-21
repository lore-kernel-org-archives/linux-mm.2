Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C0B9C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528936B00B3; Mon, 21 Sep 2026 03:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFC96B00B9; Mon, 21 Sep 2026 03:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4156E6B00CB; Mon, 21 Sep 2026 03:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E51E6B00B3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:11:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 951691605D7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:11:53 +0000 (UTC)
X-FDA: 85236899706.22.3BC0FDC
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	by imf04.hostedemail.com (Postfix) with ESMTP id 73ED54000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:11:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BJJyXSzo;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789974711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sH9a+rvkSCNl4NiTy6ScB3vbDQi2f1N3eMzMm+pJkEA=;
	b=1z5zeJeHd99qsazalAuJDtQeIMZ/dtOvLb21vae4lgqAbmHPVGW9tp82cE0Yg4elD3Njun
	SmLos205XyiQHsc7rhluP4ynlPNltsNIK5SUBRYLhVs40wiM1UkJ4rh1icOiq3w2OkfKdI
	mxPSV1Oajk/jGi61gct77e/WmErbcFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789974711;
	b=fBHB053aIlbpVwaiXSlntyP3qAkQV3ETYygjLJ++7B21mbVOf7ZgOD5ppnRohgXH06kM1j
	xLC3OI2dR52TZVSEv6+U+jYIGLyAWC4u5shUlA+wrhar7MqmmNPdXzGTpepxKgwjkta3WZ
	L7trDCBsVc/xxMhfgBvhOVn+pfSQ5NI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BJJyXSzo;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jUNOmZ0oFx/hBNFyItuSBJqhemn5jF3nsNF7Wwmgjhk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789974710; v=1; x=1790579510;
 b=BJJyXSzotVgiLcZgED4T/dWIm68LgLBKQ3fB+a9l6bKwTB5hgokjUxg5aJJ8/OqRwfE3kHGG
 xJirjP34De9jplyml8EcSDUAHhrPh1ryd8E4VJ/FXj4rJR8anXSDxpG/y2DehY/5ne/Yrrkg7tE
 PEPlV3xu5wbemoWt/fYn2F1c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 50fa2f7f8ad12771;
	Mon, 21 Sep 2026 07:11:50 +0000
X-Mizu-Trace-ID: 50fa2f7f8ad12771
X-Migadu-Flow: FLOW_OUT
Message-ID: <397d6fa5-a5a2-40ba-9d0d-d0ddc6bd1c35@linux.dev>
Date: Mon, 21 Sep 2026 15:11:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/17] mm/hugetlb: use direct assignment instead of
 folio_change_private()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>,
 Oscar Salvador <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ying Huang <ying.huang@linux.alibaba.com>, Gregory Price
 <gourry@gourry.net>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Barry Song <baohua@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Qi Zheng <qi.zheng@linux.dev>, Alistair Popple <apopple@nvidia.com>,
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-5-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-5-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ajdyq8c97wph57mskmxexgmqcpb5ubie
X-Rspamd-Queue-Id: 73ED54000B
X-HE-Tag: 1789974711-91874
X-HE-Meta: U2FsdGVkX1/K1m10/gzvQG/NWp2F7zA8FD5FEwA684tVO23Px7fhpPuiriLXhEdotSuQESV3YB1Gd8zNWxv55W9+7nBFRuOJ8OkZGsbJIMKRoomYOpUZBmGrl3RPnrKNDRdmsepzURnq5AmxTCVJu/pvlxDRw7W0PUwepy0hpJWIanijpZopmfq6EjiPsyOWx2AOGJJpK4sZ4OhqZw0+/6ioCTz02Ly7passqayrXWWDPQc3z/ZBtTSGEl9DhVtcB4QUk3t/RbM4d7VuB/zSKLSj3916r6+z0Ux54fqMVG8zLdX8o1DTbpZ1Hw7KBgiP8r+gYCjmqFvuNFtseoNqHuKCvV1kzI828xQJyk8qp160lhlbNaaRaNRJCzPdOAyFYx+ngVhHJvAQ8WYbyzblrtH2+EzDzkVZAlXSNAJn36dy5C/3z74GXf1WwT5OPMdXeK3MJJ7LW4sVubZbzlhEMhnJD9aOE4VdGcpmfXYxmttXbEFZrC8mN85qi8f4znoBDJptLCw16FTU1OyZLq//yttTwAT+SrPSXa9cNA5pVdsu5Sm6IjTVxNgPRfzlFge0gLqYHM6+QwbuCaGXp/obR4X85JrVqp3z3u1Ydp5RdncNyz57N5yLvOYxL7LjG13sS7LbRPELWJab6ZUHD1FV65P67/ljxMGuvkDtihsWo2LRYH8BUFFAjCxhqCLy+CgBYEnEl7kzn/O0v3jt1sZeFzgz5sCbEi6XfH/PzcVTkW++DAicEjB//iY/Sr/m2AlX3a/SQaemdERygFCYlSiWvG+bAsbkbvivap4FLf4ceG70b8QBjU5q0opjwg4O1ZgBjFtw3Wp/NR3xbhRewmQOqELVEbNnqUE2FW1ZhViyptZSGlCL3zR2eQQvq7OzBnw96LAEp3bRb+XlWRPyz9VSQ5oBjIgrZp53MxXIickvuoW0XSEqJf9bNSFg3ndPX3Pw9hlPCxILlxpTZ/hynyD
 LM2hjcgT
 wKlAlaQhmSnO8NhmGTKdkyBbaRx3q4XtlQFFAtOFwY++k0gs3TdDa6X2+8AquQW8WAcKVhPabN7NEBaGkDoAdaCW80bwBWd+gpPQupLEBOKO8dwDW6bpSfh1F6kD5gq79hNY9wBaoUKjuerMYnmIKt6ZZXM3bdy9gsipIhT30koyM/jrWoXrGsE37lZvYXSB4KcIA8HKGK+HrZgah17Z3KMGBLOO9nVlGXuJ9r7fML4rtsdGEkZivSPq8Uox1IvSYZLqTr6ty8NJZed8xOfw77Ykvvm0fpNG/2qgCkiLaoESBOHkGEQT6OcBSEaSaM1RFgW/BoBrrl67k01OrppUFulPf3ttuLLmk1UsHwP7ui/tKVJ40DTCmiKR0cTT3qUd8fSehHabHD/R/WuzDWS47bgxhlOTyy6GtBNMWdj1qbRyAjbsegdGF2Y0/8Tr3CaTMXhPlvs8bgo3CIRhXm8h+BK3SWnE7I0Fq3Q/uLfRBFrtX9kGb5E9YRnTc3I7eYt/rvLhXjV6hdJgVxEEIniukPzFQcz+9i8y7K4uCeH7Yo9CB/9g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 10:28, Zi Yan wrote:
> folio_change_private() should be used along with folio_attach_private() and
> folio_detach_private(), where adding and remove ->private content requires
> folio refcount change. add_hugetlb_folio() simply sets folio->private to
> NULL without refcount manipulation. Change it to direct assignment to avoid
> semantic confusion.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: LLM
> To: Muchun Song <muchun.song@linux.dev>
> To: Oscar Salvador <osalvador@suse.de>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Nice cleanup! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

