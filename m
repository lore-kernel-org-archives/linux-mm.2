Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B174CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4896B0092; Tue, 29 Sep 2026 06:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EEC6B0093; Tue, 29 Sep 2026 06:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A847B6B0095; Tue, 29 Sep 2026 06:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85BCA6B0092
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:03:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D45B1A047F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:03:58 +0000 (UTC)
X-FDA: 85266363756.24.AB6B522
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf27.hostedemail.com (Postfix) with ESMTP id DAE7940002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:03:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xV2UfU0t;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790676236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nbqrJ878FZWi0rZ57VBSYZymeJkYo6GGL1ScKrDJ8E=;
	b=3I+qjAe1rlkAOG7uq7vHdGqnj7UujebGE3I2kqKMYwBIQA00/K39uA5NNp4iR/bjah8vgK
	ui4cvpKAufqxxi57uz14gvyw0tR4WjH28T7fXC6cdVEjYGTzfQVRhbr//y0A/SNCPhylA7
	g7FGgMkfkLAmgUrNQKprq3I5HYCohk4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xV2UfU0t;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790676236;
	b=kF79qsSo1LKfE7l6zGjJ060PPqry7fnNGMSFMYS9Kle5EpQm3afvRsjvgD9cvU2fx0dQpj
	8gGTGiBC5UadwqquHKLRKMu4dHiwH/kRNwa73r3UrTl2jJ/6nc9z2InQ3VVjy95UdVkM3E
	g5oB7P3qp6wQkO1Gj9mdEtrZ2F+pIL4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4nbqrJ878FZWi0rZ57VBSYZymeJkYo6GGL1ScKrDJ8E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790676234; v=1; x=1791281034;
 b=xV2UfU0tuDjs+vAM8lHyWi44dQsA17pn5uztKuFBNlIe6GwRd2PYsqtyA2scJz1Wj0qol/xS
 fKpCR7C1jmJ0APctIQOMpjalPubX6UCh/TA/Lraz91AVO/LOzU2BBNPDGNjjfJz18B63MgEH4kn
 de+vftwvanmq04h+NbE07hdQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 00c772cd190c1b5f;
	Tue, 29 Sep 2026 10:03:44 +0000
X-Mizu-Trace-ID: 00c772cd190c1b5f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 08/12] mm/sparse-vmemmap: move vmemmap optimization
 helpers to a public header
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <0481F7BE-F912-4E83-80F1-6E7990B447C1@linux.dev>
Date: Tue, 29 Sep 2026 18:03:20 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9720986C-2DE2-4968-9CA6-7823B1F978C5@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-9-songmuchun@bytedance.com>
 <a31cc06a-c22f-41c2-851e-4827869e9df1@kernel.org>
 <0481F7BE-F912-4E83-80F1-6E7990B447C1@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DAE7940002
X-Rspam-User: 
X-Stat-Signature: yw3jm49jy9ebmknt6857hmnz84jjtrd8
X-HE-Tag: 1790676235-109397
X-HE-Meta: U2FsdGVkX18Uzi3JTQT3e9yMQEoZiiVeHYDfbVgkpjsHcac2lfhb5TpNZT4wHcMnA2BhHLyT0wd1Gi13AFK88LtrFutxuDpOHAhCaXtj0P3QRDtOFTV8J5VL7kThqVv7ercddUsQU57Ot2XMy0PoYFVzCpj4VRQE/uxCVoZhzdcNQHC1vDMG7YHaHlpCOhl7hV7ONC3eO49/cYSNVUk2eGdC5tM2j8OaJ+Fsar+MXKGDaRtwdHr37Yy9F5rXO8udQs09MQtoH/A9R5HgYO1xY8UalEyWLZmnd2mKnSRD+hIeoLoR7OwC1Ce49yWqHHwz/+11N4xywl+CUhoRchIh4E6ZIrTe+rmpIW0VoRXmQLx4tcEm5O5VTgGKQ/Oif3SHvb8wRxcwERwTJWDypaoNR44167mCBWAoe3FR0mlB4xRc/XsFnMtyIcD9BXLWHiuToqmBYSnkYXo39qTeM8SF/sjEi2xX/UfuAUgVZBCS9nFh1t+0lp/Mz1oQ8xyvmsCGaleaSW4ok87cDOHKvczAoLtcJoG1teVCo4F+EcTc+NhmWvV81w3v/o7LrDqIbfI+1oQjE+HPEhnz2i4JoYd6eTdlrBtCS4mMwaWAmmw5sNEE8XxCk4aJ90ZcAcyny1NkclEB6PDeA/4EKjG8X1/mNLgGJOxVnC3J5vHTHezmlladB7gN/W+WZHaLCeCK4//KZtzL/U0Trc9tmXSO9SN39WbYWpSUd6rXVSa87WPEkGJDO/AiPg4wsniC2hm3Nwh3OAFpIC2RbdpTNYkO1NXIF2W59TvewcgvnrSAKSmhekZ5tCLcHR/qHRJbl0iufzYHjpwAlYylL6juwLrNPwJ0E/nRGehEMSHtYd9urK8T4e95ZGhB96v22Y6Sq/okFFc7cttBQuBui8R9g19gPjmRbh6DNoyoJDSDGjgxGMLZ1igFeZDT5mNkAx1ne0+JaCua3lUsLXJKDjAJVUMlbgM
 yeziMpih
 XD5+FLNwwGIFE4e5cOeX1IfHmiDCXKxrbHzE5NExlAJPLuJJO5evHPlwnhMla5Rz9y6AmSqKVpN3ScevlhgZU0sXU4de2NOGpkln1iIoE0HKH7sFBrKu3zIGcFH1NfuD03Ee2K1ON56ZWrd4//TyBvE+dihU4jl71AhlAqL6bkyCnA14C7tcM3RQq6c1ZwZJwfjNeMcMSPAaMm+tg66b38/lWD4xFgNG9ji9ZQ4WlxpjQq0Jq+6qQqYTITQipWLgh8Q2F9I4o2fp6IV8Owppvu19pmmXtkqS9syfO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 16:44, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On Sep 29, 2026, at 15:39, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>>=20
>> On 9/27/26 04:54, Muchun Song wrote:
>>> The vmemmap optimization helpers currently live in mm/sparse.h,
>>> which is an internal MM header. That works for MM code, but
>>> prevents powerpc from using the same interfaces without including a
>>> private header.
>>>=20
>>> Move the declarations and inline helpers to vmemmap-optimization.h.
>>> This is a preparatory change for powerpc, which has its own vmemmap
>>> optimization implementation and needs to use the common vmemmap
>>> optimization interfaces from architecture code.
>>=20
>> Which raises the question why powerpc was special and will remain =
special. Wha's
>> the big problem here that powerpc must do special things?
>=20
> Good question. I also don't think PowerPC needs special handling,
> but when HVO logic was introduced for PowerPC, it handled HVO on
> its own. =46rom my preliminary analysis, the reason it didn't reuse
> the generic logic initially may be related to the fact that
> PowerPC's section size is 16M. With a 64k base page, a single page
> can cover the vmemmap range of multiple sections, and the current
> generic logic doesn't cover this case.

I looked at the code in my local branch for removing the PowerPC
vmemmap optimization handling, and I found another issue that needs
to be addressed.

Since PowerPC vmemmap optimization is restricted to Radix, this only
needs to cover the Radix page-table implementation.

The generic vmemmap path currently allocates intermediate page-table
pages with vmemmap_alloc_block_zero(). This bypasses the normal
page-table constructors.

PowerPC Radix uses early_alloc_pgtable() before slab is available. For
runtime population, it uses pud_alloc(), pmd_alloc(), and
pte_alloc_kernel(). These helpers initialize the page-table metadata
and fragment reference counts expected by pud_free(), pmd_free(), and
pte_free_kernel() during hot-remove.

To address this, I plan to update the generic path so that it uses
the normal page-table helpers once slab is available, while retaining
memblock-backed allocations during early boot. Once allocation and
teardown are correctly paired, PowerPC Radix should be able to call
vmemmap_populate_hugepages() directly and remove its duplicate HVO
page-table walk.

Thanks,
Muchun

>=20
> However, completely removing PowerPC's special handling is already
> in my follow-up plan. We need to wait for the current series to enter
> the mainline, and then we can proceed gradually.
>=20
>>=20
>> Change itself looks good.
>>=20
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>=20
> Thanks for your review.
>=20
> Muchun,
> Thanks
>=20
>>=20
>> --=20
>> Cheers,
>>=20
>> David



