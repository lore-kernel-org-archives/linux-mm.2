Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B04606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VhDzF2tx
Received: by kanga.kvack.org (Postfix)
	id 89EE36B05B2; Wed,  4 Nov 2026 01:55:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8287F6B05B5; Wed,  4 Nov 2026 01:55:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0CA6B05B6; Wed,  4 Nov 2026 01:55:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 304A26B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:55:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 902804068B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:55:52 +0000 (UTC)
X-FDA: 85396526544.10.4F121A0
Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3181380002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:55:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VhDzF2tx;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793775349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LHrHKnVlKPTmz+tK/rlTG3Ul+MFMIEMsJZjre2ndI4=;
	b=l3OndlUSjRwqBig5bZpYkaKjUOAwjHKXeMOD+N+T2sZ+xAWhwQ6DDaGvq34GL/1oHd5ldK
	kvojaGtb70rO3dghIEhACXuiArWH8NEimOf2h8l072k4jORHTxLIxrxhB8WrvvQHgg82r+
	BcE9nKRm/8r5qYKLdaqfWWt8FcJJzFw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VhDzF2tx;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793775349;
	b=ubyAybuMVoeokTZbGv0PUdVKjcHjvPwn6jGq1RwN/sgrlMzuzltceZtLCM/vgaozNCxVOw
	rsNFECitmZr6+m/ND7+5vXwdbGzpM5RLo3iIKjbm0oI7OPB4uNcfDlhFfWCRYxNnh7sgV6
	4rqKTQ1u7hd4+0rxAInd3xKtV+zKQ3k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CIBZ6swiNtC8Tf94i/4oegXgVh55H6AYv54uJEyrGDw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793775343; v=1; x=1794380143;
 b=VhDzF2txmtaDN87fTQ3DgA/GYwVVb9/JkN2zy6qxnNSFw/+i904MfEkliJ4p97N4liQihbFo
 Q4Vxc0eGPYL/zvzTqDgnCprz6Gc6cLf0X/tYQfNDS34Wdcb6+gr05CyYVQRXyB1o2LBUZ463jLX
 tu/vrgMsBqoWPcB1MCgaU8d0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 355c044cea9cc491;
	Wed, 04 Nov 2026 06:55:42 +0000
X-Mizu-Trace-ID: 355c044cea9cc491
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 00/12] mm: Decouple folio-based vmemmap optimization
 from HugeTLB
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261103224659.2865b9ff27d09994949edd78@linux-foundation.org>
Date: Wed, 4 Nov 2026 14:55:14 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <77ECD6F3-6A6B-4743-B47E-7C97335FAA79@linux.dev>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261103224659.2865b9ff27d09994949edd78@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: d6mmt3cwrcibpqcnnrcgbtyhyn35is3s
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3181380002
X-HE-Tag: 1793775348-711950
X-HE-Meta: U2FsdGVkX1+LcX3e7o2+q6mY++AjXkBlq0qICEFvdM2Ahb/QGsQar0mVDtVtyAkfuhW4DfxjK9adgnleoUQdA4qf0fZro0K2b7mB+NsSluc3SrXqj0BjP+AgacG9MzLaHDVVhoqT6huIdMIy2rXpdEgHKcb8KOrLDBwMNVIxFnhcR5icimm9RJi9/GOKTj9MvnomuUCsmkF52iqMlMJQ+BwhDFRSHcCnudus676dsQdtvZJa185pQHC6BL1/JG3xgmy4nGG/yRKJcxMiYLSQ+VjwF7ZXmfDx66bDBpVQ8ElFyqmbPFlSHivJdCGmAWN1D2wJG84ohtuibkVVNdt41K082xMq+soPM8lYLUUV7CwblJyjhEoaXQKZMiml6eB8OFDV2sPuHOh8LaFVGptTpvyGbKYv6H1+bjbLtE6qMroJVn2FmWtxzpVe8XF4APcMpIdKB4kG5JKFpPfwtFS9EgtrtvDVL9Dr4KPwFvM994HF+TfMzEXTDLDvL7bIrCqO94AoZLwp5d2nKr6VUltnJN2jwIIO++aAgHcBFi+SGFal63nchQIT1EAD/Ry804iGJl/WKvym/auWWeDj35yIopoDfydiLm1N60xtjbLCKqSH1UACL6LWhxdz8ilBYghuavGIKuxTFxlrj/Ix0eOsq9PLGFKhMqtkgJIyWxJMgaucxpRTLB9KnSRU8nAtx4+YEym0jGfzPuo8glQtLJ9HTlDrogLp/TwD1lnzYSivhTtb8IkRlWTG9cxlaUlMz3r+ZvSq9yh5eAt410DezQWuIILx+qk/u1Avd2H33UI5mEg3/mJuURCKa0E927YU1b+ixrWkXj2R2UIb+IoTVsZpSM8Hmfn9IIOnWQw8VcYUsh/z/MfGiug8UCMy1J/M6wxh+6zNaDyGTIDpP4Kw6WSP8KJHfHm4T1AQ8SSgkJmzNefyuNGRrBhbu+keFMqBoFh8kzz3H7WdaXDlGtPN9Zn
 Y94SAIyc
 NYekNImfBsxpRdk6++faXHp08DU4AtHaXEbQyefYenDVpq4YPb1tMBs0xoQ5NNfLPdAs25U7RQzgoMcEdACJ1Y1JkuYmEEsUJkeRxmtnWbR/LoPAxb7Jirt65pNM6mJe64br6kkIJjU8kJrJNtmU1KXgyq2n7fnQcOl9muYwMsCc6EEn939Os3BLSRtM5o+ANE6qorabHRavZozwB70sn0bgZ0WhtJJNk92f+CraJeVQka9vmcIim+wR9WywLKcepkpjCV1YZLgItGx6Zay0wyljpHtA1H5sFMvlvg0OHUcjCsRYHIB4C3ggUIdSlpVpNETXoFmml94HCLlha4NrYFs/yUZIrRMTp5OEF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 4, 2026, at 14:46, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Wed,  4 Nov 2026 10:34:58 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> Hi,
>>=20
>> Section-based vmemmap optimization is implemented in =
sparse-vmemmap.c,
>> while folio-based optimization currently lives in hugetlb_vmemmap.c.
>> The latter is tightly coupled to HugeTLB-specific state even though =
the
>> underlying page-table remapping operates on one folio at a time.
>>=20
>> To make these interfaces easier to maintain, the folio-based =
remapping
>> mechanics first need a boundary that is independent of =
HugeTLB-specific
>> state and raw address ranges. This will allow the mechanics to be =
moved
>> into a common vmemmap optimization layer alongside the section-based
>> interface.
>>=20
>> This series establishes that boundary through three folio-oriented
>> operations, each with a distinct role:
>>=20
>>  - vmemmap_optimize_folio() optimizes the vmemmap backing of a folio;
>>  - vmemmap_restore_folio() restores the vmemmap backing of a folio; =
and
>>  - vmemmap_pteify_folio() converts the vmemmap backing of a folio to
>>    PTE mappings.
>>=20
>> Together, these operations encapsulate the address-range calculation =
and
>> remapping mechanics for a folio. HugeTLB wrappers retain policy =
decisions
>> such as eligibility, optimized state, batching and TLB flush =
handling.
>>=20
>> Patches 1-8 generalize the underlying vmemmap remapping =
infrastructure by
>> removing HugeTLB-specific assumptions and simplifying remap control =
and
>> resource handling. Patches 9-12 then establish folio-oriented =
operations
>> for optimization, restoration and PTE conversion.
>>=20
>> The implementation remains in hugetlb_vmemmap.c for now. A follow-up =
can
>> move the folio-based operations into the common vmemmap optimization =
layer
>> once the interface boundary is in place.
>>=20
>=20
> Thanks.  I fed this into my evolving LLM-controlled testing setup and =
it
> said
>=20
> : I tested all twelve patches together in an x86-64 Debian VM under
> : QEMU/KVM, with 4 KiB base pages and KASAN enabled.
> :
> : I grew the pool by 64 two-MiB huge pages and drained it again. With
> : vmemmap optimization enabled, the kernel released 448 vmemmap pages
> : on growth and restored all 448 on shrink, in each of three cycles.
> : With optimization disabled, the vmemmap count stayed constant. I =
also
> : faulted in a single surplus huge page. It released seven vmemmap =
pages
> : and restored all seven when I unmapped it.
> :
> : I tested both boot-reserved and runtime-allocated 1 GiB huge pages.
> : For the runtime case, I grew the pool from zero to one, drained it,
> : and allocated again. I mapped the page and wrote and verified a byte
> : in every 4 KiB base page. After unmapping it, I demoted it to 512
> : two-MiB huge pages and drained the resulting pool.
> :
> : All twelve programs in the HugeTLB selftest group passed, including
> : the cgroup reservation, fault-charge and reparenting tests. Both
> : soft-offline cases passed, as did all twelve poisoned-page read test
> : cases. I saw no HugeTLB warnings or KASAN reports.
> :
> : On a diagnostic build, I failed the head-page allocation and, in a
> : separate run, interrupted optimization after three PTEs had changed.
> : The trace showed rollback restoring the two tail entries to distinct
> : backing pages. The folio remained usable in both runs. I also failed
> : restoration after three of seven replacement pages had been =
allocated.
> : All three were freed, the retry succeeded, and the metadata count
> : returned to its starting value.
> :
> : I configured QEMU with two virtual NUMA nodes, each with two vCPUs
> : and 4 GiB of RAM. On each node, I forced the batched pre-split to
> : fail. The trace showed the remap splitting the same PMD and =
completing
> : a range flush before replacing its first PTE. Folios on each node
> : shared a tail backing page distinct from the other node's. I drained
> : each node's pool in turn and verified data in a live folio on the =
other.
> :
> : Finally, on the kernel without diagnostic hooks, I grew and drained
> : both pools during active page-cache reclaim. Over 40 cycles all 640
> : folios optimized and restored, and the OOM-kill count stayed flat.

Really a thorough set of tests.

> :
> : Tested-by: Andrew Morton <akpm@linux-foundation.org>

Thanks for testing.

Muchun


