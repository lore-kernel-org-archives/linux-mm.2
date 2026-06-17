Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B180CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 10:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE25C6B0005; Wed, 17 Jun 2026 06:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E93466B0088; Wed, 17 Jun 2026 06:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82246B008A; Wed, 17 Jun 2026 06:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2DC6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:34:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1ED021A03CF
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:34:50 +0000 (UTC)
X-FDA: 84889046340.22.1868ADE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A3EB10000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:34:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wv97yqYT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781692488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUzimGhtwXxeFlNbjp2T5cpsz2AsOPIbGLnMGM1e6Dk=;
	b=rP6ngxSmeve/pe6fE2PLGeZbtnyKrrT4e45JAjPa9dzGrxCDNm5A8mjRjNmwFDvimuX8y3
	RCnLxlEk/UQQn2JRZOJG011Xfd8eAhEnYRn/g117q5vBAsmBPKeoipoiF40B7pc+t4Bk19
	C8L8MzUwYVPQjRWIJhFsX0N+6fHlokc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wv97yqYT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781692488;
	b=AMjlRSj8neBB+QlA3p/dy0sSeoHAdaxPe3r09TGUWZ3F2kNs6hKwLMlr59LID6CTrR6AXh
	tHJPiclbKpD7aE7ijihQpBed2jTnWlhTU30dWmUy6szezUbBrbOdPFTyzC45lHolDryeFT
	O5y/fNPkvvyhyAGeI5ECCsJRCdFL0g8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B340160137;
	Wed, 17 Jun 2026 10:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FC81F000E9;
	Wed, 17 Jun 2026 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781692487;
	bh=mUzimGhtwXxeFlNbjp2T5cpsz2AsOPIbGLnMGM1e6Dk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Wv97yqYTUmHJUFnZj5sV6+KfbOH9WCS97aAe2ipipFgYFnAgIyBaKA0DCVPWhme8b
	 jBXKmFR2LjzO+WhSOm9S4yVMbmlCGSH11yqqO0mq9Xr+BMQwf85wyzev4hqlx7sAUT
	 TP75DRBIfR2q7apcjUstwzSBStuIhrXIKy0StOYafxpFp1VHhyvgwcppG1/+ui/4da
	 DESJJGo+QdHVu+ZYi2jSI9lSUgtYxh3qp8sgvNI53EqqofZTgpeK2jKBhZFfFk8Wf3
	 TqJyGELBLbKO32SIHiP5JHb5yBTFjIcK1lUfKpyDqSi0Ae97MquHzGkCTY7bgu/xsK
	 W2A4DwTyVd02g==
Message-ID: <9ebadac0-0ec2-4ebc-8193-1a289574c0a9@kernel.org>
Date: Wed, 17 Jun 2026 12:34:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/3] KVM: guest_memfd: folio migration for
 non-confidential VMs
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Chao Peng <chao.p.peng@linux.intel.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Ira Weiny <ira.weiny@intel.com>,
 Michael Roth <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Fuad Tabba <tabba@google.com>, Vishal Annapurve <vannapurve@google.com>,
 Nikita Kalyazin <nikita.kalyazin@linux.dev>,
 Patrick Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>, linux-fsdevel@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
 <ai_XK__RTXMCEcCG@raptor> <ai_aczmeH2IA6JaB@raptor>
 <ajA4z_Wkb93cTW4m@google.com>
 <1e77f24d-315a-4f68-a109-2f4520343c0c@kernel.org>
 <CAEvNRgFQLEsKanKrj=ePHoShiY2cgQgxtGs_2CJcZHP=JOjidg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgFQLEsKanKrj=ePHoShiY2cgQgxtGs_2CJcZHP=JOjidg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6A3EB10000E
X-Rspam-User: 
X-Stat-Signature: zgz64bis6n9rmg68ru1p3z5mzkpwabdq
X-Rspamd-Server: rspam09
X-HE-Tag: 1781692488-20765
X-HE-Meta: U2FsdGVkX1+eezdB+yIZRqQ+NaIV82baPYmWpjCbxTMggrvr30to/Chwsi31pqeGBA/sCHRZg5be5tGAGziGHbfgrsd9ZcYVOFyQuL/u1zWszTHaSWNEMD3DVlL2juMM4rXgWtVz5WBZ+FGR243189oWDPl55GIvKG6FmwLsRvOIIzyY5ZBxCEJcsGUy622tVQCOCy6rP7DllID4r/oa3agJjYUNOVIjm9f38g6/7Sg+3A05Bi8vI6dProC3ypEX4YaRY+5IH18AM1UFcTu3HUCDdqPv0mqdOavJlbnZTr1S9Y0CB73hlQK4GKwnIie4KzcoQJmBhA0+PTt1++vj70LuMx1z/FKqJOEGsh4eyJxR3/h4UiNT8G+L0qOC52lzb05zwR9LkrvLCdspdJHW7eatIjXHtPGNtU2s/E/byDwuu58lo6uYVkZWwUtKK0C9dWmEIUHQ9FxFxjEPUXt4AeFtzxK30diak47U0kc+Vipsw30KNsuIQgTXNdaplk+r1/MdNFbsRfeyrv3Lb60QvUDAXQU9mA1t4OTSf6iQaqihvDNQI25WBX0tut8oCEaEJ2fe8afOepaGe+4NYEsEdIneSaXv1HgRP7L0YT0Ay1plL81FcBdBgxd95zbckswqiwR/Y/rwqAfUZy1utIRAdWxz2/VBNW0ROZI/gA8BbzhVmrK2PbHDEJ4NSZfGKUkDT9sXXZmkzUanuTE85xY3bZ4GTeQqD6dJ11pjDj7LOvcis+PVLeEpc0qIk0eNpPQAIeyYccTq1o4eOpyQDFIBBgDSJZgoSifPZWKEb6ZOlyIobRRBEjm5MYYYqSSazaKr4afk+1CHsZgc1HWkz2L7eTj9ueTYoPE2lX2vCKKnSSIxcUT1q9Wh8YopK3N4s6a74wBsSyI9cXlRK6nOjJQvRfkO7/lqNRiNu0X3/1RHPtYOeTAq99+wXVy1z8eEGTCsAXI+S9WM3au3ecbuvBl
 Wf01SHPp
 3aCUosRY8+ww0y1MYBgvbvn70sPOtX4U1mPHlbrAoXpg7I+WznpBxAdVTWa51B/Cvj00euQu3IkTsgMmXvxwXSDgddoauZJI+J5ssgo+ovdOH+zMlTNM7UXUqbmJ/EzXYy04vaqunVCpjXfNnX9KHyGM5g4tl7gTx/YjEu7AgEAwdem6iYvCHZ6IoLqqUu2YlTnvgj5BLkgpB8QbMgmCwozgO+8SyY8JR5ovDrQoohdEguf5ltizNMMcqi346mBaoMYEJhq3nsJc5ha+REPuitGK6+0Cg9NbNz5LdEW8cM/EKFtkb0ZyJ+BgGBYlIYepj/nZGn/xrvl6jjOtrkAk8ZLbGqcB/X12mQGc5WHtxE1fmmvHEixtF5PrMTjs1ONhawWFLtyZ9c8dk9LuW9Qc1y5m1qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/16/26 20:09, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 6/15/26 19:39, Sean Christopherson wrote:
>>>
>>> +1000.  It's not just "nice to have", it's a core design principle of guest_memfd.
>>
>> Right, and I raised in the guest_memfd call also the rough idea of Alexandru's
>> use case of having non-movable guest_memfd pages such that we can support use
>> cases where we can hopefully guarantee that a stage-2 mapping will not just
>> randomly go away.
>>
>>>
> 
> More concretely, are y'all pointing towards a
> GUEST_MEMFD_FLAG_MIGRATABLE, which will set .migrate =
> kvm_gmem_migrate_folio, and for now, error out for CoCo VMs?
> 
>>>
>>> For the purposes of this discussion, we should separate the physical act of
>>> migrating pages from the features that trigger migration.  As I said in last week's
>>> guest-memfd call, I am a-ok with supporting page migration as a mechanism, but I
>>> am dead set against supporting NUMA balancing, KSM, LRU-based swap/reclaim, and
>>> anything else that goes against the goal of guest-first memory.
>>
>> Right. Page migration for supporting ZONE_MOVABLE/CMA, compaction, memory
>> offlining, virtio-mem and possibly some collapse mechanism if we were to support
>> THP of some sorts in guest_memfd would are all reasonable.
>>
> 
> Background question: how would virtio-mem use migration in the host/guest_memfd?

Good question! As long as there is no nested-virt support (and virtio-mem
support for coco still being in the making) that wouldn't apply, only ordinary
memory hot(un)plug (incl CXL).

-- 
Cheers,

David

