Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF4FCA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 06:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519AC6B008C; Wed,  7 Oct 2026 02:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA966B0095; Wed,  7 Oct 2026 02:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0266B0096; Wed,  7 Oct 2026 02:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 192906B008C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:55:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DDA780409
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:55:44 +0000 (UTC)
X-FDA: 85294919808.24.E16C4A0
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7F1C0140006
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:55:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=upkzkViQ;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791356142;
	b=zcUnFvv7Xx93jHPB0WBHWg0aQzDlyOSokx5+NuBoehIzwx6falzMZJkXCWmLEWjKaj0ERx
	Lp/I+BLvX8j+pvITpPTRr6Qq3Z12+o7gWBtDwbKBFqiH7xYLqqsvnbF5tOns2oQ8yHdFDF
	dixOdnBCYZLqmZ8ZMgiYw3jxThmdbQc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=upkzkViQ;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791356142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiiOx/JuFyugym69lApK4/HuiVutmdA0om2H1/BVpTA=;
	b=IYrrbtb5mTiz6cD2P8b18uXqObuEgxvcTjEQ0lewdUd0qWyuWBe5l09Cdf8GNZiOBiwDeu
	MbQFXd/MGXppiLOaN8IJ2Jt2qQYDrL9TSzKf8zLzdYNdTLyKhv1IM2BOnirDeadTafQ25h
	9GTG9G0N8yPPmc3KxNaafrO+geDZO7U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ToKfNOVp2qvFnEYXZ6nvsN9uzB66hA/JPYJkqLxPvZs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791356141; v=1; x=1791960941;
 b=upkzkViQXmYtdYcYGawtBOd4kYUxuHTmfdVWzlY6Hhc5SRa6cNKz5EXfDTsPm3M/W8KAGp1S
 BeIQQxkyvUGteVedy7lSehNqth2W/lHZX2aHkvH+Cwdh8FDOtMNsvEvPp9FiSTGJPnT9x8Ci8B3
 Jj2gkLg/tBxJ1C5jJi3juC5w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id af8f4c7b60dce85b;
	Wed, 07 Oct 2026 05:10:41 +0000
X-Mizu-Trace-ID: af8f4c7b60dce85b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] mm/hugetlb: use kvmalloc_objs for hugetlb_fault_mutex_table
Date: Wed, 7 Oct 2026 07:10:08 +0200
Message-Id: <5714BF9B-9FE3-41DC-A215-EEAAEBD7F9D3@linux.dev>
References: <20261006160128.31447-1-dheerajkumar.srivastava@amd.com>
Cc: osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 davidlohr@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vasant.Hegde@amd.com, bharata@amd.com, dheerajkumar.srivastava@amd.com
In-Reply-To: <20261006160128.31447-1-dheerajkumar.srivastava@amd.com>
To: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
X-Mailer: iPhone Mail (24A446)
X-Stat-Signature: p1nfr88pdaada5fkf88x4ao8gqxkakae
X-Rspamd-Queue-Id: 7F1C0140006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791356142-941043
X-HE-Meta: U2FsdGVkX18z2ffPNlPakNNxlL+WQj5mYzYMcLOm+FwhyWCrqu5zHQDWpD6v9xnHnAmkrG05flR1NkYkYMiC/IPefa7LOnl+lf+YHNAsgRWuMdPIWaqV3edm+kpISqDGHX/V1qPWfDLbhKv5iNZTvNLj9go0hWOYpO3tdOhvqQbCvPmkdc4/PBdr0dxEWad4yoV1WaEhpiuHp1bElSMrMb04WjgPiE2QF6iEM58AYzgVf0G8oZY6ahfw8+BCylAQy6ph/CW0LfDQ6eDXG0WVR2Ev17sFmEPUmADDnrFYnziPySfwYMtKw3j06ESAuThkmk+fXrHvpKSNepRovx/YZEAVK8ZmIB+UXZGnxvsHEpEmEY1ZSSLDAN4pHhFOWZJKjANDZ9FntQGynUQT3FOPdaAol1rASKYOY/H4PVUs/B4SRSOmpLhc2o1Eb2mo33lt9egLsYTiQlpV1PeEyQmU9G6LCn2Fou2aDjPDBlWjU1cA/ZBAq1jTgdS4TKQ198RqWtZtMX2JPopuOn7Vw/INlJufYnQayPG/iCo2/EGr9rXEg1ELRqrYJJjw8f1PLZnf7EPzMz26OaxJXMnu7KtKRvbZ4dYFF+Yz50XXmaviSLPBfY5LJrYH+eDtCZMijwC7l2epmsL0wnfa5vdsRfLSSCX81/8ih6lzjFf39FatVoc3leJ0ryDa/EAx6P2t1Dzyp5J2OPeWvpf9X4G3cgMN0weui0WynoLnVJFpJPjxmFDX4IKXsMnuBZjI+sDJhFz+vaeNII7K567w3tDyiuumwDNpeTAeUTSEQQ0ErfV1jDZfsqGhjBNhbl1g8FwasUzI5YJ4IK8Pob+A967FIkJSVtSFT5TA3wDF7lX6X18XxWV4yx0+fU6/NcLtnPjZG2HlX7MGphWzPhp9I0F+DS53r3bNOFMcLZ6A0PyAg4KIi68ZT8zIKNgX8PcTHC9XFHHPLkqiJQDzgzrQRsIp268
 BYgU/5TJ
 SVzgLcfaar7QbSKsu2UAMNukvAWtST59Oa2eO4AFk/IwafnZiPW+eJyHItyY5C+A4+PA52xauMFDE7noqoVuwq2TNBD7ymN7gT0HOCAVyUrZG8jrERQVBhsWel6lIDhQSVO+bbbp4lBertcb/KnQemXz0HAeDde5wQJ3qcuEbpLsLIIdPW9gxND09u4agFcydOfKZQ0ePkHYoIgNXrw0ppas2tVoG4ClwHhMWc1E1qdiNfN1pB6uHmSjENPAh3WFzf8fYnzkj529Bn9nBK107d/ypBKcRO6z3p9d7OwhQ6rN/nhS6c5uLFrDY6vDwEdTRHjD7Oje6mD2D/qLBNahMY/9ZY5Bp6kDny9cc2xn+C7FwjluH86QZVX1KZWdoFR3hOTF5rayKJDWdl6RpB0juSYtRKnd642TwAFtoomp+xdvxB5ctxfwliUu90rAHWWpiuGawJxX9ROkoYbnbyT4m2RJ4HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 6, 2026, at 18:02, Dheeraj Kumar Srivastava <dheerajkumar.srivastav=
a@amd.com> wrote:
>=20
> =EF=BB=BFOn systems/VMs with a large number of CPUs (e.g. 4096), hugetlb_i=
nit()
> computes num_fault_mutexes =3D roundup_pow_of_two(8 * num_possible_cpus())=

> =3D 32768.  The subsequent kmalloc for the mutex table can exceed
> MAX_PAGE_ORDER when struct mutex is enlarged by debug options like
> CONFIG_DEBUG_MUTEXES and CONFIG_DEBUG_LOCK_ALLOC, resulting in:
>=20
>  WARNING: at __alloc_frozen_pages_noprof (order > MAX_PAGE_ORDER)
>  kernel BUG at mm/hugetlb.c (BUG_ON(!hugetlb_fault_mutex_table))
>  Kernel panic - not syncing: Fatal exception
>=20
> Switch to kvmalloc_objs() so the allocation falls back to vmalloc when
> the contiguous physical allocation is too large.  The table is only
> accessed by index, so virtual contiguity is sufficient.
>=20
> Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
> Signed-off-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>

Thanks for your fix.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks=20=

