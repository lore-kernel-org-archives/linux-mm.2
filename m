Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E78C6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CACF6B00BD; Fri, 26 Jun 2026 11:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97BEC6B00BE; Fri, 26 Jun 2026 11:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845446B00BF; Fri, 26 Jun 2026 11:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 477DF6B00BD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:08:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B40D01404A1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:08:55 +0000 (UTC)
X-FDA: 84922396230.25.811D346
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id E415B40004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:08:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPvNDeEl;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782486534;
	b=eYodWk6faPCc9mbuyDN4fttbLN5gu8X0FDY7CPkPof6d5LD8/v7gae9JdzfnHZUMmYMtng
	Y4YbZp1HA2dTbzMq0TzEbJgolHJ07M1d0lQn38AB4NoMuyem1Ccr10kp7iYlOILcWBLb52
	lu3sKlE6gSeg0ZVt0ybMJ2MA2Hd1zac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782486534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9StKkQ0/yj07eWoElZiv+n2VxDoLxnR18N0r893Esc=;
	b=PIl8OJv+hFVvvTWKGMBD8Iq9p6jo7Ugzmiyb9/RkKnybztZA7D9iYZDpYeIFRz4icFabIk
	SwjWaC633mDH7/FsoEiDGdeGVXW83zG3OWd4yW5QCUHVC4eumHukvSAs98eEFIuK0JyW7/
	6PRch4SDYg5mwR5F3rQUsViOtsNpojw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPvNDeEl;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782486531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W9StKkQ0/yj07eWoElZiv+n2VxDoLxnR18N0r893Esc=;
	b=BPvNDeElvRZEMwzggouWII2tofymA3pxu+5JfmGwK7CJp2impsOKKN+WsSGMrtCbjeGBPp
	NozIkXctwbMzmWJYZfWlevw7VPXWSaOnPydN+auEoQa0orwMQ/6weJ5g1FizLIV7FLvrOU
	M1Cmc9YYM8i84hgILpAHMIQo3kf7m7E=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 15:08:42 +0000
Message-Id: <DJJ2QJQQ73CM.2WHKW4AT6QT1D@linux.dev>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
 <linux-riscv@lists.infradead.org>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org"
 <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
 <yuzenghui@huawei.com>, "will@kernel.org" <will@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>, "willy@infradead.org"
 <willy@infradead.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "lorenzo.stoakes@oracle.com"
 <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org"
 <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev"
 <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "song@kernel.org" <song@kernel.org>, "yonghong.song@linux.dev"
 <yonghong.song@linux.dev>, "john.fastabend@gmail.com"
 <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>,
 "haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
 <jolsa@kernel.org>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "jannh@google.com" <jannh@google.com>, "pfalcato@suse.de"
 <pfalcato@suse.de>, "skhan@linuxfoundation.org"
 <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
 <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
 <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com"
 <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jthoughton@google.com"
 <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
 "alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu"
 <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
 <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org"
 <chenhuacai@kernel.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com"
 <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
 <shijie@os.amperecomputing.com>, "svens@linux.ibm.com"
 <svens@linux.ibm.com>, "thuth@redhat.com" <thuth@redhat.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
 <urezki@gmail.com>, "zhengqi.arch@bytedance.com"
 <zhengqi.arch@bytedance.com>, "pavel@kernel.org" <pavel@kernel.org>,
 "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
 "vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
 <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v12 01/16] set_memory: set_direct_map_* to take address
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Kalyazin,
 Nikita" <kalyazin@amazon.co.uk>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-2-kalyazin@amazon.com> <aeeDvpDnGnY5n69n@lucifer>
 <DJJ23EXF55VK.1EGQZS511HFB6@linux.dev>
 <f7a40359-a210-4711-acba-677e9c1d565c@kernel.org>
In-Reply-To: <f7a40359-a210-4711-acba-677e9c1d565c@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E415B40004
X-Stat-Signature: 3h9cakr5s5xkss6fm8xxcmfdoomsowbo
X-HE-Tag: 1782486533-335349
X-HE-Meta: U2FsdGVkX1+8kYivwvZrIk9oeMgsZ5aA9BYvFEvhQb5v7FDHllOVilqXOyX/U11M57jKQziw3ZybkO44EaQFR+HMrAKWBTLlOywzF3g8fYkhHiCd6gdf0sgCf9DsjDOtfhufTa947tyoD795StoK1R/1LzVX0Ex+k9TvFN/mzN+qUqmeGxr6WO0TKoZmdY7WbWQ5gUJYo2knz87kh3Xk8AQ9xBjU5ap+Bo43qP9nI7kbpXDzDc+bgr4UNzyiyJZ0H1I2Dxulto5ccOk7VguVWpMUW7AvAJ9EbBRTMD/x7cMacbWFcqUFUxxUtUeI5JHf9ipz40qPaGl2LkTzi5Z6tLmx1ZkmbJ9a2Lr1PsdNfztQInd0bxDdcGm5XRcznVNBxNrsweaybfXnqonMOUDOssVyLPCiuRDi6yEF17RKc49jubvEMWY42/41BToZCQa7ILwz19/DAhw86bTbcpm0pZK30sqr9Ijl5741kWECWIYnQoHPgKX38Tf2oxaXwN1z/0DEwVL2+5cFaXlRToY2+bnwlNTF2uBDRAP95nlBEgPtUlIqL3PUSCcmGYIkoons1buN5DTWFzLcPT5NTDXTknV98E+GOfqyy/mRjEE73HWwaqkO4AppqMpXhIjZcrZCcOGPxkVIjsMWhAQsF0nYUed5CcVKYM4+bMMRChwyL8oe0V1O/YCUaa+qOKLQhbRt+jzl3Ag5zSfo9dRFUfEhvxCCpBRgNKW4GOehqsVFqNbHyivJ+5JzqyIb3+nN4dqPzanqdbWCRRNGvyB2w6y02U4RteJZ9KYhLnsXvJKRksrVRT+hw2PBxkUqXz0fvqPjuqFg3oweB++Z8MYUNgCnM2NcmhHWiX60opg9r6Dp5GZ5JS3AhsDDrI5Iz1E+XI7noPDmkbfcjtbXQUtAUrCgAroi2xde03ZkhMprP7HiU53/nUCC8T2lQxlzY9Cy2TAPcuN+H9k1K9a7VBNP0P3
 NBIshxkH
 9xMpwjbstWQMEXHH7iTLGSAy8UhkPNGEIogNzs+o+4bAMiVgaxVDQ6Y6/ydrWKVjtTA/hZSUAP/XtASItm4rqzBvskag8ILETlbVs5CsgU+NsxSFbuMJE7MCpNmA+VayIlip9r+8lhSmnZmGV1FBbuDJO6Obp2AZ1DgMYAzM1W2fVeXdgqdYZ/LOagz1qWBO1U95EAsuO3KoAvYT8Tb4/YPXwyJdsQkobDXQvpdnkXHr1pd8T6NylV5FHCwintmZ+oDOdPhy4X9ybA4gI4IqF8ecrJ14h07spM1QUhnblRb92edcGz0wbkoR4gXSl5nW/dtpWdBy+Nz6fk5g9AkNXfOfQYTyW92OWpk5IAcHMEfJo3AWxu26LNX2eJe88nsc+M1w8z37BVV6SMGD5SLnmtAugoJQ5WJhBRqNlJFnNWuJFKwuQJ7qb+w/JY9RF6mMvIzTSZsu2cg7nY/PrQiJIa7SGXOQ5H0DFe5yjHO5YhARH2Lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 26, 2026 at 2:58 PM UTC, David Hildenbrand (Arm) wrote:
> On 6/26/26 16:38, Brendan Jackman wrote:
>> On Tue Apr 21, 2026 at 2:43 PM UTC, Lorenzo Stoakes wrote:
>>> On Fri, Apr 10, 2026 at 03:17:58PM +0000, Kalyazin, Nikita wrote:
>>>> From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
>>>>
>>>> Let's convert set_direct_map_*() to take an address instead of a page =
to
>>>> prepare for adding helpers that operate on folios; it will be more
>>>> efficient to convert from a folio directly to an address without going
>>>> through a page first.
>>=20
>> Why is this more efficient? Isn't it a purely compile-time conversion?
>>=20
>> Indeed in the current implementation folio_address() is
>> page_address(&folio->page) so it still goes through a page anyway, no?
>>=20
>> I might be missing context here about how this will look in the
>> memdesc future.
>
> Good question. page_address() is really only complicated for highmem. For
> non-highmem stuff it's simply derived from the page pfn.
>
> I suspect going page -> pfn will remain as efficient as it currently is (=
with
> vmemmap). For odd cases (SPARSEMEM without VMEMMAP) going through folio->=
pfn [1]
> might be slighty faster.
>
> [1] https://kernelnewbies.org/MatthewWilcox/Memdescs/Path

Ah sorry I raced with you and replied to myself:

https://lore.kernel.org/all/DJJ2NKKPRANG.188CUADJO2CKK@linux.dev/

The above makes me realise that if we really do want to avoid needing a
struct page here, the "right" thing would be to make this API accept a
PFN.

The problem would be that our favourite programming language we use
doesn't know the difference between `unsigned long addr` and `unsigned
long pfn`... but I thiiiiink its unlikely those bugs will be latent,
I've made that mistake a few times and my computer usually let me know
about it.

Still, I'm not really convinced we need to change anything here yet
(modulo fuzziness about memdesc etc).


