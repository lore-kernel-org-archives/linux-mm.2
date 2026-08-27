Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8424FC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4556B0095; Thu, 27 Aug 2026 10:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DCD6B0096; Thu, 27 Aug 2026 10:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536A06B0098; Thu, 27 Aug 2026 10:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1960E6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:33:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B074A0430
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:33:33 +0000 (UTC)
X-FDA: 85147292706.06.12D14E6
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9D79640009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:33:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="P 6HOkD4";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=YMTw8S+r;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787841211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ln/cYU6R6kxXbvIePHIUyNjbzJC0uJlvXR+XQ3FbfZM=;
	b=iiqAo0NOgJu64+pslf8y8nsqPK4BwSvyWzvUwWcS5QlaVY05xLCzcQt6LN3zBOanPbRNNx
	oSxX41pOCvBSKx84Has+BtKaITZP9/bGDcZh6cOtA/OxWChOwu1D83zN69oAG6JOynRltx
	MWC9L0tJ+yK9MRb8LDleD/neJUhIdiM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="P 6HOkD4";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=YMTw8S+r;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787841211;
	b=yyb3ieOMA2I9xpBTFWcJDsFuUQcdu+lsHbDwtrvNDhgtRBHJH7rrOBIB/+kXKfdJODkR3D
	+bJymrsPKRcuFXGqcmBQr18SSVQUzapU4ibfzdDiAz9lX+cqIbtVzmqC9q4Kihy300g8Ld
	cynBsSs+atPvMNxStwwKwzrc2O4NKNU=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 1980013801E4;
	Thu, 27 Aug 2026 10:33:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 27 Aug 2026 10:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787841211; x=
	1787848411; bh=Ln/cYU6R6kxXbvIePHIUyNjbzJC0uJlvXR+XQ3FbfZM=; b=P
	6HOkD4c8lkSWtklz5AyfvXJ7Edo4Gcv5bsmBLyImsWdrC2VmfETzZcILTibLnWmy
	HlaARwr76l8oyfS26SRdZKGrnWzbS+M/G8JrVSuW70Cof5qpLOzqgdR00Nv6RFs1
	UEi4MW95w3ca7TjDsI/GEx4NfOv+peayyZvo3u6GFPlg+YYBas9n6phB0kpMpi6P
	6S8QxD9dLtzVrZNH+4Q2tdlox1N62lvqRxGdvxlDttCmrSE58GBBeamlF5KEJ1Az
	wnD17xvlWd0jdcUEhLgigUuKFMS/Y1MKNsPIcPxhKEp7pnwmN39KMLWgwCVfoVOA
	F3LFGJy6+mgwxW8cP1KhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787841211; x=1787848411; bh=Ln/cYU6R6kxXbvIePHIUyNjbzJC0uJlvXR+
	XQ3FbfZM=; b=YMTw8S+rmSG6bfUflT6pvk6RtchcWGVsTZRRSZ6gAMxjESCi6Su
	OsEnf+FjOmcEVxQNqFjQjXD/pfVw6PvcqErRysrKQVq60sWD/HsvUy9xoz+4xZJg
	lKOqcalaM6JjVmsWtmUsguUjqYyhF0UNXnaizrGbzGBUH67L3OuJDELmfFu3FrBm
	N30Bh5rTErFqH1AsNgQwP79M1Be594Izc6y5/hedmx8C5YS0jNpulTngEtRANiJe
	0wA1dO0q2BBiq+T/RxUXDbDk4YzF9CnptmBbptvUdPvSEKYxnkLdLffyvx/u6NtF
	+2Cle9q7IFThxrOfZ73qUFyBoX3+Ccp8oOA==
X-ME-Sender: <xms:uUqQan-tRh7Sn03rjf_CjLxkT-RG_p7KLSPEucC8cD3WGPMvgV1W3w>
    <xme:uUqQaiIKfclPhGQ-bLuvrZZa5Vsq_DEAAop-iyyfKm9Fk9uj2HgR_xfYF3BYLbkdQ
    WteC2AhiflnnL2zqK-zL4WRvDNJJGCVVsOezMFH6KLjnH5oipoKVzQ4>
X-ME-Received: <xmr:uUqQasJjHPT8sYTq0n6AWxvyhREg1ky7oka_PYD84_zSe5g7oS5y2ZgFVjY>
X-ME-Proxy-Cause: dmFkZTFX95w7oz8NPPCgwgK0v6r1e5zrRtNU9uoQ4ywzPNzXkyMIhPlNvTdMRpJ6fx+94i
    pKd/HphuAZxxtsecVEssSbcYsWdECuVzgdv+juA9XC39CNmblKiHnup7SDLLALy6H1/DUi
    i1Kq1aWXsxz5+GTeyQyGUo6yk/OFIkBURo4AtdrDvo3/ipHRIMtgGcsHlBYLPs85UZUFKU
    6TYq1b3nBvnEFDcz0iEdfGT7czFRsH3Nlaxj3LGfSPwhBvbGugH7ZwQ5DHHUjqp10QPyUM
    DEWYjS4Qf253nIKsPMVTJ6hP/T+5YXScE5HAlIRkeNn3cxgHqdmMiboL9DU82Ogr8665Xr
    SXmV6Z3nvNk2z5JetqWIzfumfx95EkIgnqbW2fBHHOCEHekg9VcbCkOqa0hLefx+J30/1/
    gy2cWQQCLuYRryE68+Q1d/u+i0Y7m9h++zWwIqOZ9PWfKHI2uc+fVEF+lIPWFrmQG7VBAr
    kb9/A+IgZgTnXy3hA0IjOctFKjxedTqdNTKuC8KcJbo2zaBe4opafU1f6cMP1P+Qj+7zes
    Pzx8V9RQpw79SyWDQhyNd6jSL741YR5Pab7hLsWKBrit6KTb8PftYbsO3u9ZFcCUAHmhDO
    tvpwQxoUBVD4QGdr3yny9hNBGxC6cIXcidpcqmcCzIAwaTZyOCEdmWyIB8BQ
X-ME-Proxy: <xmx:uUqQanB6yVa8CLu5WEwlK6ceNNitDUh5iijmbU1Kqcrvg9dJaJcc5w>
    <xmx:uUqQavnd7RjnmserXeSj4PB_tdM0UF4VuavgePUgg7jjAfz2nZjp-Q>
    <xmx:uUqQajHu4qztDTWaH2b93kVb5izoZ5j4-SAMK2PsTJS85qenPXSHaA>
    <xmx:uUqQaugj-gscMeflSzeLmVuWdnUJ1Q8N2ZVfNR66avD-h8Ea7xVVWw>
    <xmx:u0qQagVxlUR8y64wWFdWdoKhe-OP47Pks4e4VZkbm3qwnzZX-8yAN8v->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 10:33:28 -0400 (EDT)
Date: Thu, 27 Aug 2026 15:33:27 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
Message-ID: <apBJ7PeX7c2dD9kk@thinkstation>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
X-Stat-Signature: r15erbxz4cphg56rqkus8rerch6dthf9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9D79640009
X-Rspam-User: 
X-HE-Tag: 1787841211-512637
X-HE-Meta: U2FsdGVkX196GsX4BokV7Sa7AQT9iqwt7BvQbMCA9Wi5HD+TAPEP8UCvEN+mBeZdTYdGBuPgJ8/UAgOklyxDzd3leVYsxg99EON0rBUV4cP3y6JbtYtckZDCqBSn0q0Aa8s0aZfeprrR4ub3Mr6e3KdU3exMCESTo79Uq/mTwocMmlyAL/vTN/5zVwATJkw4JVGE5AZ1eIBlsA9+isQ3OjZuZDazqy9WaR8hcJv7y029/TGXuQBHLAXAkOcdWWWhRReuQvLqg2naGDJ8ekF0M2sRExixqUEoTHQDvT/s/kg7Ei8R2NvCKAMa4mjxNGoo4wb7VU36qIzQ9twWs9z9c2oTiw0U3TcyXJc29n9tDKSEhpswiw6w+s5hAdEVB9A22Rto/coTci5ASllvfsM2QkZRb9bIYOeuDz7WjZ6930xeviwiUQBtTk7rKWrgBJICj3D62HgbbiBuL9hlCckCXLG2Xh9t20+dqodUxcfplH8oswUGAD8n5NyIcLcuMoj6b7FpMt9onSk+gZ9+maoNkmMLbvtAvHQKVmIXb9j20L+5XxB6YxhMxXCKMGafd+Hi/WKQOk+mOoj+A0eTKV+defYkbFkVMBG4I5ntcMdHQNgnng3TlJMhuUiA52/6t7vNOtFdERfDBaXuIVFFN05+G3JfYChl2voqNhNvkgW8QICoo/ExOE/0t1LMGXs18lWheiwjjd1nzXykho5rKYKE3zX+1BhjEDNQyrwqRYjBCRyW+fLbjlKOaMMv2agbDQSYL+9x4IAuTBRs48IrsBeZrJM7lIQ6gBLkDUqvlDAQhQCPyty6Gs50nMYcqwKvMUk1U+mkPm+UR4Fq84YvvzTcGinyp+MXoS+hcBaEV87O1ndYslwo/r0991ZnbW7KEzd+GRejhE2LW77aN8yaJyYOv9Wz4duY7UVv+zgcq6WW+tbHQ2kiHIFneHihZCr1nKb5ER6bhubh3dYXsf6nhud
 NJLrvEXK
 eo6XGlpxRIdnLYiWvysNloS7bCqm1vH2SQ/hWZbxbHwphRwZ08FYt13iANx3mTVgpyqggqhAHRRY97fdI1hMfp3UC0pSoSqmgnut3eqXJmHjrSIQJ7wcYwGvzSBwZ8MkuaxLqoKM4pc3aLYUFOMxw5vonTJjCuqz126LE4qez2me6Ktj76iqNIU9FmwujrZwxSpR5dq/Sf/Kjta2w6q9q8a7zVaTJUChwXUIRViPvLghUSjS1qUlcpX46+gkeBR15HZAGCHBcIAJAoDyK6B19ddpHPs3gTDvdCui3mshUgquxmTIq54/4q2CR49x+GT36Gd1rZ8J/e4X+UB+bqCZH8yWNsb5SGKWc6ekb6DFE8R2XyShDThRrNxMC45DCQ0A2nySNHCWVotKLHgQASGbvejUE1raKJYFM6Ub/u+MbD7UzX3o8Zj5tCkLzY8eDvNm17+v1nc/mnmdVAZLBHmtpcCTRQ7MxIs/IsNBNMjWyYX0OSghbNrC/TNDJnPVoseuUqt1YP7IXyOeuu52pWKdVTii34ZQ6clmpM/KQPjq5NToTUL9FG9e0uJdQqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:55:15AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> A folio in the swap cache cannot be split if it has a mapping (shmem).
> The split code does a defensive check for this in
> __folio_freeze_and_split_unmapped, after the folio ref has been frozen
> and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
> rejects the split and returns -EINVAL without unfreezing the folio or
> restoring the counters. That error path is buggy: if it is ever taken,
> it leaves the folio frozen and stuck, skews the counters, and fires
> the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.

If you are going to repost this, could you make "This error path is
buggy" a new paragraph?

> 
> Check for this case up front in folio_check_splittable and return
> -EBUSY before any state is modified, so the split routine always backs
> out cleanly.
> 
> Also fix a bracket style issue that checkpatch.pl keeps complaining
> about.
> 
> Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
> Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")

This is inert bug, right? I don't think we want the commit to be
backported. I expect stable machinery to pick it up based on Fixes.

Is there a way to express "not stable material" while keeping Fixes: in
place?

> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

