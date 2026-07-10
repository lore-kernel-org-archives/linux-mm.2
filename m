Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B839CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 08:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62A8D6B0088; Fri, 10 Jul 2026 04:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBBA6B008A; Fri, 10 Jul 2026 04:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD3B6B008C; Fri, 10 Jul 2026 04:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC10B6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:50:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50AD240344
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:50:54 +0000 (UTC)
X-FDA: 84972246828.06.A9B6502
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 67782100003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:50:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VbknYlqK;
	spf=pass (imf14.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783673452;
	b=7w4LhVr6W+gIiVBd02dgyFiY4/4TI/v14lH1jqZfAr+ewZ/HsXiPUkzojquFPXpLHLBbR5
	uaNrHyyrszL7pZ0SPZR7XMcVZNToemRR3mL6D8LCgIoOltX1bocpQlr8H/G3KmuaSYyX1F
	KPTFIp5Wo2TrqjjlMj3uDaxjhSxjP7Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VbknYlqK;
	spf=pass (imf14.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783673452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=speNZ5kxqcfvumuAgKlguzjeDrPs0cEQRv6glMz1oGY=;
	b=Xlj0X8UY+Bp1waTaoY+5uJSkwLJ+NEFtN2VFC5frSvZ6ezD6qasUkQNSTDM+RX3mF+AS1m
	8U+87MGCLYZVjcAsCM/qlzW9jcSXUxbSBdgpDMct4oQeG+HDCEqSbmGUpCvXjBZkvk95QF
	esielIxHkZwRJDm9KAViKqzAd6k1gTE=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783673449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=speNZ5kxqcfvumuAgKlguzjeDrPs0cEQRv6glMz1oGY=;
	b=VbknYlqKj+XeIwzbMFqz18KoTCbiahRLIUVGMfOYwRvwWQDGfJDqU13WBtB/ZEsWkuWtpf
	LVp/piuHvqgAGyy/krjeq3Z0CfZpSJGS5hLhzUS23o4QaH1h9OySlwj9sRNCmz9Mjw5s8I
	WN1kk+gEuGno4d9AStWzQ1C6uj+gB+k=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jul 2026 08:50:25 +0000
Message-Id: <DJURGJEHZHFY.3SINJIME8E9RB@linux.dev>
Cc: "Ackerley Tng" <ackerleytng@google.com>, "Takahiro Itazuri"
 <itazur@amazon.com>, <fvdl@google.com>, <ljs@kernel.org>,
 <Liam.Howlett@oracle.com>, <agordeev@linux.ibm.com>,
 <ajones@ventanamicro.com>, <akpm@linux-foundation.org>, <alex@ghiti.fr>,
 <andrii@kernel.org>, <aou@eecs.berkeley.edu>, <ast@kernel.org>,
 <baolu.lu@linux.intel.com>, <bp@alien8.de>, <chenhuacai@kernel.org>,
 <corbet@lwn.net>, <coxu@redhat.com>, <daniel@iogearbox.net>,
 <dave.hansen@linux.intel.com>, <david@kernel.org>, <derekmn@amazon.com>,
 <dev.jain@arm.com>, <eddyz87@gmail.com>, <gerald.schaefer@linux.ibm.com>,
 <gor@linux.ibm.com>, <haoluo@google.com>, <hca@linux.ibm.com>,
 <hpa@zytor.com>, <itazur@amazon.co.uk>, <jackabt@amazon.co.uk>,
 <jackmanb@google.com>, <jannh@google.com>, <jgg@ziepe.ca>,
 <jgross@suse.com>, <jhubbard@nvidia.com>, <jiayuan.chen@shopee.com>,
 <jmattson@google.com>, <joey.gouly@arm.com>, <john.fastabend@gmail.com>,
 <jolsa@kernel.org>, <jthoughton@google.com>, <kpsingh@kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, <lenb@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <lorenzo.stoakes@oracle.com>, <luto@kernel.org>, <maobibo@loongson.cn>,
 <martin.lau@linux.dev>, <maz@kernel.org>, <mhocko@suse.com>,
 <mingo@redhat.com>, <mlevitsk@redhat.com>, <nikita.kalyazin@linux.dev>,
 <oupton@kernel.org>, <palmer@dabbelt.com>, <patrick.roy@linux.dev>,
 <pavel@kernel.org>, <pbonzini@redhat.com>, <peterx@redhat.com>,
 <peterz@infradead.org>, <pfalcato@suse.de>, <pjw@kernel.org>,
 <prsampat@amd.com>, <rafael@kernel.org>, <riel@surriel.com>,
 <rppt@kernel.org>, <ryan.roberts@arm.com>, <sdf@fomichev.me>,
 <shijie@os.amperecomputing.com>, <skhan@linuxfoundation.org>,
 <song@kernel.org>, <surenb@google.com>, <suzuki.poulose@arm.com>,
 <svens@linux.ibm.com>, <tabba@google.com>, <tglx@kernel.org>,
 <thuth@redhat.com>, <urezki@gmail.com>, <vannapurve@google.com>,
 <vbabka@kernel.org>, <will@kernel.org>, <willy@infradead.org>,
 <wu.fei9@sanechips.com.cn>, <x86@kernel.org>,
 <yang@os.amperecomputing.com>, <yangyicong@hisilicon.com>,
 <yonghong.song@linux.dev>, <yosry@kernel.org>, <yu-cheng.yu@intel.com>,
 <yuzenghui@huawei.com>, <zhengqi.arch@bytedance.com>, <zulinx86@gmai.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Sean Christopherson" <seanjc@google.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com> <20260508081812.12345-1-itazur@amazon.com> <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com> <DJP40SEE38XA.3BXJN4U0VDIOS@linux.dev> <akw1lZDEv8_Ub1zQ@google.com>
In-Reply-To: <akw1lZDEv8_Ub1zQ@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67782100003
X-Stat-Signature: m19mtoxptrec5srw76pfaqccpqxqnsk8
X-HE-Tag: 1783673452-611543
X-HE-Meta: U2FsdGVkX1+ErJGv8hKJcz5phdBqtDM0bQKs21wjSX1m8taZogsJdZUMfF+Z5Lq82LG3B3CKzuJGJDbxy/l1MgA83Q/g1xHcmENBC0IvS2r3F4gy82nmL0YiLmecD5EGbkyfjJedCR/iRnrZBXYgo65xKUrWz5jVN05MrxCbmHM6YioBERQHtOYY9p2JwLOluWrucQ6rwXQUKAELjAYCyfT+D5CbxGhf6FfYL3Swzp4ThGhnesWYXiliXFhtxlEpWc/mACZTn3VR3gAWUt9x8sEEirLbFriWo1GcYhiORgObRmV4gT/CS5aHSgXFiFrmxTiWu7x0fh4LylmnmtBhKGGtAiYvGu1jbxNQ6BvOLXeewoiOIC63ki8AjuGv4Q3G+SYDfm39wIh6yvsjRm1uuRFF1zPdSphhfqtEGOtmgDUt1tG7cCEDz3UMNcijtEgUBMveX6keRfpk1YQZ0zX//5qUlKVoJo1NsAmwaerBvXB4Qykgk9amM+6MWYL8WqmsG4lerto/5IKwQml98VFgM2FbZGRzRpRMpQIlxXzGwR8TTrZEVpXSHAnwqo8PTxdTVHXWxwPJnBJ9ydiLouW7HcA4LTlyVXirlxVN59wuMzbsqgUQetWh+9VPz2Z/KOCZg7IL5j5TEDqAj3Htqlv+nZMmSZC9OWu2HcX7wVi6cDRaTcxflIn1Dl/IGjGIoxbR/Qbg5YTzlHEt3gi+BvxHeB0IusFKnBed87GT8YYbBHejNRYzqq6qDMsxYLS5FQa0/nq2WNkPX03OlzngnfYTgDCwchRN53krffvyjmMDgJveZlw2FllDBAzsNpbHdyTTM8jvIzlAAj8yTCqPb8lEMuqqdhkrbX1d/+aXMGlDgrVahjeTNsv3oRcf14Lhp45tyHa80tm86kcdHmrx3vQdCMFlHVvoUNcvYAsz8Npn8JcobC3/pCee7fwUFLXzHkbImyNaJFHl+IpQXPc/kDT
 mMygngAp
 f5tEPH0vNCjii2oVbvBjlTP9YUKllgAnJEdXa8Y3l3YNqchjOej/G5VvVUberjw5brp7WjwXxKOQBoYmQXvkF2Gda8o5Fgx+rjX73o5xcEPiQRLAHDiWYbGOL27AVaQTfw0H2hRIdTeWx8VtJjehKmVsmlcYHrWIX4TW+X2LKHlY+UIf+ZkZynHEcJctXxmgp0pRxY3Rf5nqRBB6vez+z9I9dbOthzRLwCj22eUa9bjCyfqLMwTvKhgcgDL7QxQNTgcurRyRJibpt7ZVTpzbLP8nYXqy1eq67h46vh8tDEzTZ2QaiN0ZJG8WZyrIDvQ1FiaYIAflM5bvSacRT5BO/MZqGMN1GdseJXtEPjCzvZmQn4Ao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 6, 2026 at 11:09 PM UTC, Sean Christopherson wrote:
> On Fri, Jul 03, 2026, Brendan Jackman wrote:
>> There are also the fault paths though; if the pages are nonpresent in
>> the direct map for the duration of their life in the page cache (and I
>> think they should be) then by the time we get to
>> kvm_mmu_faultin_pfn_gmem() or kvm_gmem_fault_user_mapping() we lost the
>> ability to zero them.
>>=20
>> My original answer for this was "that's fine, we'll use __GFP_ZERO
>> (which will probably use the mermap under the hood)", but now I've
>> realised there's a good reason we don't set __GFP_ZERO at the moment,
>> namely that it's wasted if we end up doing kvm_gmem_populate()
>
> Eh, don't worry about the wasted cycles for populate().  The overhead of =
zeroing
> a page is dwarfed by the overhead of adding (and in most cases, measuring=
) the
> page.
>
> We (KVM folks) discussed this in the context of in-place conversions, and=
 long
> story short, the consensus is that shaving cycles by eliding the zeroing =
in the
> host isn't worth the complexity.

OK thanks, this is useful. Nonetheless because it leads to a less
confusing dishgn, I think it still makes sense to just disallow
__GFP_ZERO for the unmapped pages.=20

(At least, at the page allocator level. We might want to allow it in
address_space.gfp_mask or something and have filemap.c deal with it.
But, overloading a GFP flag like this is yucky, if we need a flag for
that I think it's likely neater to make it an AS_ flag or something).

>> (Continued below...)
>>=20
>> > I'm a little bit uncomfortable this statement since it seems to say TD=
X
>> > and SNP aren't taken care of. Would just like to discuss (for
>> > a line of sight to SNP and TDX support):
>>=20
>> Are you saying we need NO_DIRECT_MAP support for TDX/SNP? I think that
>> would be doable but what's the value?
>
> Hardening against consumption of shared memory?  Yes, the guest has expli=
citly
> shared the memory so there are (very) reduced expectations around confide=
ntiality
> and integrity, but defense in depth and all that.

Ah yeah, it did not occur to me that there was memory being set up via
CoCo paths that is not encrypted. So yeah that makes perfect sense.
Eventually we'll want to be able to lean on this to protect that shared
memory against attacks by other VMs etc.

> For me, the main thing is that I don't want to completely punt on the int=
eraction
> of the two things, and end up with an unworkable mess if there's ever a s=
trong
> reason for CoCo VMs to support NO_DIRECT_MAP.

Yeah that makes sense.

>> So that we can get a #PF instead of #MCE if we screw up?
>
> Note, SNP gets a #PF either way.
>
>> NOW, the thing I'm stuck on (again lol) is the patchset-fu. Here's all
>> the parts we need, with dependencies indented:
>>=20
>> 0. efficient GUEST_MEMFD_FLAG_NO_DIRECT_MAP
>>   1. AS_NO_DIRECT_MAP
>>     2. ALLOC_UNMAPPED (formerly known as __GFP_UNMAPPED)
>>       3. alloc_flags arg to the page allocator (I'm sneakily introducing=
 this
>>          in [1])
>>       4. freetype_t=20
>>   5. The mermap
>>     6. The mm-local region
>>=20
>> I originally posted all of those in [0], except part 3. Doing all of
>> that together in one series would be a bit too much though. Approaches I
>> can see to avoid that:
>>=20
>> Approach X:
>> - Do parts 1, 2 and 4 as a standalone series. The only beneficiary of
>>   AS_NO_DIRECT_MAP would be secretmem.=20
>> - Then another series that fills in 0, 5 and 6.
>>=20
>> Approach Y:
>> - One series that does parts 0, 1, 5, and 6. AS_NO_DIRECT_MAP is
>>   implemented by having filemap.c itself call folio_zap_direct_map(),
>>   then guest_memfd.c zeroes it via the mermap. It works but it's really
>>   slow.
>> - Then another series that fills in parts 2 and 4, switches filemap.c
>>   over from manual folio_zap_direct_map() to ALLOC_UNMAPPED, making
>>   things fast.
>>=20
>> Approach X seems natural from a code progression perspective but leaves
>> us with an interim phase where we have a bunch of complexity just to
>> "optimise secretmem" which nobody cares about.
>>=20
>> Approach Y seems natural from a feature progression perspective but
>> leaves us with an interim phase where we expensively zap a page, only to
>> then immediately do this complex mermap dance to access it right
>> afterwards.
>>=20
>> Any thoughts / other ideas? Personally I think I prefer X.
>
> I don't have preference between those options, mostly because I don't app=
reciate
> the difference.  My overarching preference is to separate the mm/ work fr=
om the
> guest_memfd as much as possible.  Beyond that, I probably don't care all =
that much?

Cool thanks, shrugs are fine here.=20

Main thing I'm trying to do here is generate some awareness that the
decision is being made, so that I don't forge ahead with X and then have
people going "ugh, why haven't you considered Y?" If nobody cares either
way then nothing to worry about.

