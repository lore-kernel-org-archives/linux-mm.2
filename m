Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C926DF588C3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8916B00A7; Mon, 20 Apr 2026 09:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0F96B00A8; Mon, 20 Apr 2026 09:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29F8C6B00A9; Mon, 20 Apr 2026 09:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 195376B00A7
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:05:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C242A1B8ED0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:05:52 +0000 (UTC)
X-FDA: 84678956544.09.BE60E49
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf13.hostedemail.com (Postfix) with ESMTP id 062D220003
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:05:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xTp6KYy0;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776690351; a=rsa-sha256;
	cv=none;
	b=hpk1b26ejqE4IUheW19oBFas7TWdNdMnFQohkkcBGbtkF5qC8kHYx13RMc7Q+aOG3Opt2z
	1Y05rjmnAQ9Ujn8uTcD/1BQoy+Gi+bGdMA/wLOuraeJ/PcAMJ3GRK8Am+8YARIjiI+ft1L
	W9SnvLkE2SVR1st5zqQ7+DLR4RXzE1U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xTp6KYy0;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776690351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8o1Kvc1FhWv3hcUBdL9Fd1FKJEXKxrOb0wzsGmpz0qg=;
	b=SbQaiKVVmuCIjijFRK7r598gtG55o9dlv145Qh5A4s2QMVk180BIEOUozu+3w7j1MNxmsT
	QBqEcoU0sq++tcbi2BD7m5VOJun2h2sWvbjisZjpbkDJVb+bWpwfQYJDSnnXwZ6Lt+8L4T
	UwKc8O4mUyM3ddA/k9r2y6G1SWVkBDA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776690347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8o1Kvc1FhWv3hcUBdL9Fd1FKJEXKxrOb0wzsGmpz0qg=;
	b=xTp6KYy0xa4dIGcf4gFeKo7RLoE8gL95mM2ODmIY1tlpjleQnN0sElKN9BwkisufynAsag
	67Xm/OY1u/29XcXRdR3es/MdW66TZnW5SH/XVez4i/sUxnYFsvKz1T3eAOT13qdFidzrv8
	scpzSE2lP5JsR70T5RDPDui/uPsIFrY=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 02/13] mm/khugepaged: generalize alloc_charge_folio()
Date: Mon, 20 Apr 2026 06:05:36 -0700
Message-ID: <20260420130538.3537743-1-usama.arif@linux.dev>
In-Reply-To: <20260419185750.260784-3-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 062D220003
X-Stat-Signature: tn4gagdqoimi57auyud8ea5z4sriyb91
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776690350-32972
X-HE-Meta: U2FsdGVkX195dl2UaYTMNYMpH8veTFLd4vIxch6dT+butE2Xr++ya9c2vN8qCaKjasIgeRL8OKuNnm139ENiNQjJ8AX8TvzK8pqickmpjajusim6QWZbI7nyuhoSW0hB4QoGiLUjKgZsjWQ2lwIQzX38Q5WFccY23dPeMGEJxd4R4ewAPStArtA97zbnF1rw6frHbLaQKMwe/9FSUmqmryxKPkCNKKqkT+N5WPjHjiR7l5AQSx5HdehOm8sZDe2II8XyQ1lJhpShWyPHlmLOHcPU9tPff9LipCOY9TZ2eTpAuTghi/Qauy+u7iP5OjYM+/l7snvJa1hqPACp6PQLTsATwqp9T6vYfwV8J1N/jjRQimXLhtj0xovYyGiKaoAlkuM2uBruKp3GtY7O6UgaYSG1MHsMOi5NK+/mEBI50aoWtbrOiJ+sdCZctFw1dXvj/fc+N3Qje1n26xVeA/+ON1xYFm0GD05Ldkvb40fe6KQqLcZindNXrf2exePTOg0WtS2FiedAv23fkSyRnI9lVFNn9/Z0EtMshZmbpc0grXhVADQAsQ/dnR0l4jl5grzZrKMefPcxrWTe7BPuadM4gIKyayrYSBnhdphfzYlGFXIGuVESi1YpFadmCNG9ew7YZ0v/NfZziTfs6fTF0zE3mURm8oZ5E3HaETgH3ERirp0uJv2Y4cOwP1uphjjea45tQWEH0y3uyG58QKhFizsrDki8ipG2NSgggtmO05dpwlpdkO2ZE81a7Q9QGUiRk6QMlOqM1d4I14uEnDOcnAO+65SMPc558iXCZjWmYp+jEAq2rvKVyXhlA2G54Fn5j/34YIMCBhAgo2mFG/HoMwX/bqIexQnbbphyCulJLI4VxMthvb5JII0ZhsAecCZusfaImCITdGF0/A6UvVHdUQNWKJ2cz0yre03GfZwRQ12akFUKGkxAXVeCV46+zgdT0p38pGO4+/asGWYyuLLXxrp
 5js4BZl4
 3N335ll/ul1RJFXSc3DBAAW8r3/iOcL8xhbv75kwPAe240ahumt0YKMa54wXeI6BCkNj8AYVuOALed6yVTeZLFCS6MLv7dOsizKabkE1yTIU2FEQZMrVqyJ5NUU+0J8KIqTvbigKTtmHKMyX/5LT95WJji1CdbEqUX0ITCqw8+nbH6IZBGc9lf82EBRGQ8WvtgKPP03EIakzm48qOwdzFDiepIrvWv1qGUhyU7t+6TSTIwt2o8gs8e/r7LrXyMxbTK/C2cVoC0drZb0Ye5YZKWZGDNEXr9VJBFGlAmm0nZa2wKbIEMLW8gRhVrIeYIzv/CxvwSrftKeLeqKhUTjusR6ZWCUvb8/OE/b6mmb7AFdD9maF3KD1GHSdLNTyNqxrbw4kMVVtPGlo+d6vPj2LHIFA7v5qcDCcdvoAJ9d95+0H9BHIORICMuigf0wy2r0Dti+bt4jDN0sdWnuQWf5RB6p0ragg3r1ri6Orade1k2g+qB8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 12:57:39 -0600 Nico Pache <npache@redhat.com> wrote:

> From: Dev Jain <dev.jain@arm.com>
> 
> Pass order to alloc_charge_folio() and update mTHP statistics.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Co-developed-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst |  8 ++++++++
>  include/linux/huge_mm.h                    |  2 ++
>  mm/huge_memory.c                           |  4 ++++
>  mm/khugepaged.c                            | 17 +++++++++++------
>  4 files changed, 25 insertions(+), 6 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>

