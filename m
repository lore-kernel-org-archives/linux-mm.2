Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D0D606A334
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g0huoPLA
Received: by kanga.kvack.org (Postfix)
	id 468446B05B3; Thu, 26 Nov 2026 08:07:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FAB6B05B4; Thu, 26 Nov 2026 08:07:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32D486B05B5; Thu, 26 Nov 2026 08:07:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8DC16B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:07:27 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A0BAA898A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:07:27 +0000 (UTC)
X-FDA: 85477296534.22.CF0E0F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7205B4000E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:07:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g0huoPLA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795698445;
	b=NOz6EiLx3HX0oL+b70CniDk/fXruMy5AgHVUWUTPf3KLE7I5ApRmDdqNWvvrcXjH+/HClR
	s/TqtkA5Id3s2faFXXyFH9idhaB06KYcZWso/+9kUaZQKrm7tTaRyy9SOcoDIfn9di4hj9
	c2AZiZaMPV8nXLuwb4V84IHLxm+NX3A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795698445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foknlsobLC1fmFyqK5JuWlMNEp3Cfb1HNvIorEGGP60=;
	b=hajHRAMHfpp0fKgX3fAns2XbA5+NLqQHJDXsQr+suedREgHExg3Ig4546NyAB32gKdz84n
	I8tB7PsUUSfDxiViss/88dU8gfxJsWZhps0pObpxLe1bxWHausg7OdMdsGXoW7AJN4oLk4
	RH4cBoEF7hBKKtSbBjO4oF0P+TNYgys=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g0huoPLA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E25EB61164;
	Thu, 26 Nov 2026 13:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297E11F000D0;
	Thu, 26 Nov 2026 13:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795698444;
	bh=foknlsobLC1fmFyqK5JuWlMNEp3Cfb1HNvIorEGGP60=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g0huoPLAbF7NU2cha7D8a91bsfXr5lvj0dpFIJcLsM453MTh23seN7Mo0dXxnu2qC
	 xN3ZgRasgaszBgksxHfwMbSXsLcd2O9/rZWZLCTvE74vIXMgR5jFrjVrguesR/dFQt
	 IeBvu2o7iVXpognac2ufIxexQxZ3p2R/kpy1OhpHewwntJh/LiN2+tvylVcB9ba4Hg
	 4gpXntdXbtr1QSSEqNXJaUxkL9wGU99NMiMFBef2CFoLjVOBL/wfGOHS0rd3kZS/qi
	 mVJguYEu76rGOSonjL/iXaakgV3DIjaZRnsAjrOkxMVSjHTttCSt9WS+jdJYQid2ar
	 WYuuFzBc9V5+w==
Message-ID: <931acd3e-0689-4517-bbd2-d06109ac4a6e@kernel.org>
Date: Thu, 26 Nov 2026 14:07:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: reject long-term pins of HugeTLB folios
 overlapping crashkernel CMA
To: Usama Arif <usama.arif@linux.dev>, Sang-Heon Jeon
 <ekffu200098@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Frank van der Linden <fvdl@google.com>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Jiri Bohac <jbohac@suse.cz>,
 kexec@lists.infradead.org
References: <20261125155108.24098-1-ekffu200098@gmail.com>
 <1b0242ef-49ad-4d7d-820e-d1e6569eacf8@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1b0242ef-49ad-4d7d-820e-d1e6569eacf8@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7205B4000E
X-Stat-Signature: ugnp8m1j68kg8bcyu14atragpgzwpyfc
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795698445-171002
X-HE-Meta: U2FsdGVkX1+9tNA0+9Qdzk2q6eY8BMEpE2E0mbPsIdwac8hFliBDkBD6J+9PDmpiWwn1q5KFdiQRDz6+sLXNcp7n/LcAmDpLegy2qSfnYmqKJPNjsdwCt5rn8EHtCcwUeK5oQ0CYbsDWfINmKL9xmTmy8PZBO/K1xM0GO98lLhWwz2Pjr185ObBvSEWz3oDVH8/TN7gT88PTCq6C4fed9i79bHW/Ht5c89PbRXC/FS/ue/rlWGDjY2u885OgPzizlnQ6msQXha+P+Jre/nan0dfRq4Qgch0NAy59dbnU/HXvk0Xj74r8vbQY/enlK6PYij2WSXFdWsqfDSfkrCGZ8RATbiM17fQUB0zWi3lkppjBwQS2K6B1NKyEuNalsNojOp03D8KRksRVae5fwbBik2i5K1c5f5kUctsqiqInLizshfYwbb+uWVC7fi+fn0zsCsNx0aw4jpJeZsDpzQT2/8KBezxf/zq1hj+EkIX9+BMuxHD8dOkLJZIhJycmD+XoczbMZWVlnIY1yUlrVe1KAruIKHjUSfVs+rvbyGkGCpeocDTEaWBkhz0mYMDUcsXRnagRVbnUDVBF7TVIO74eWOOZcvC209c+aR/8mSgIvpzqc/yafrXXb7enWasAmz3pywiMXm3im/pV6NygFAX1epgRAsTjSbTEHxi/a2oIKw3IL88BKJsUvwpkaX68EjRO6YPgTjro6lPYqdpdIUUfoHHYg2Q6xhtEZNrS72Bc9CoKeO9qraPexTLVqoY8rh6TZvqzGZzNkwW1FsIwLko6zeJJgSPXrYYwoWYp9ccWstItNog7cHhJqp3ckFZyKJJomMHqoM0bstQ4Jd7J9oMjW5t7jV3gQjX6dep5JBAsQCTDvdRCccPvKVlH3lTuJztzd5oEGp/hnM6DDs04s/TwjsQ4ewoEVS1qvmRcdBaSIfQq3A/fxeXqFsBxuhoiTwdBqPZukGiCxMrVon/tzM4
 Qfscem70
 LQKet1P5XyAhAfq6yFxDpACvsCzA7soK7T9YPKWDvzVQyRe3ffyeXCAOxd3zUsuFpHuMPKxH+nwFJDFpJA/asFUsk27NBwo0YJ5BESCrAGeYNQlDwgzjPKujUbWqfTfd3cik+YBQpNtWPKhN01orLtz30m/k34MJCC2NWBvlOyQ0sOqtLNC/RE6vDVzTeeqRlIi2jaKGmhslNk3kIOH0P6aLrKBuyJroybuRFusUIcv0uwrMcA9Ia6A8vnGW++C7B1D/6QO/HlOpX9XGUt9c358fv3M3NHGup2QHRvs9qdJeVCGRXtsQrW3tBXRTq6tNGYaNMusMXV83gXU4bM9n5bP4DvD5CQZYg3K16zcLMmbHpuhax7Cxz8fYdIlsMFlueDfoMIEuF7QYgaH0vo44f9unXUscDH8WPfvyZCT4l6pEQuSZZRQXVPwMo+Zv9RP3YGOimMFbGdhLdkBy2PZQduK1NEX9MhLGzaL9/LQ53kFFwEsvTFCfADPGbI5kO+Tel8OBc9nVwBonCfd2s4sotsZyN2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 22:49, Usama Arif wrote:
> 
> 
> On 25/11/2026 07:51, Sang-Heon Jeon wrote:
>> crashkernel=size,cma uses existing hugetlb_cma memory, so
>> crashk_cma_ranges[] may contain HugeTLB folios. HugeTLB folios allocated
>> from hugetlb_cma can be long-term pinned without being migrated.
>>
>> After a crash, the crash kernel uses the memory in crashk_cma_ranges[],
>> but a device can still write to a long-term pinned folio.
>>
>> So reject long-term pins of HugeTLB folios overlapping
>> crashk_cma_ranges[].
>>
> 
> Is spending the workload to protect the dump the right way round for this
> option?  kdump.rst describes it as
> 
> 	This reservation method is intended for systems that can't afford to
> 	sacrifice enough memory for standard crashkernel reservation and where
> 	less reliable and possibly incomplete kdump is preferable to no kdump at
> 	all.
> 
> so the dump is the part the admin has already agreed to give up.

We have in there:

"This option increases the risk of a kdump failure: DMA transfers configured by
the first kernel may end up corrupting the second kernel's memory."

... but I recall some discussions about short-term vs. long-term vs. cma
discussions.

Ah: https://lore.kernel.org/all/ZWJllXCN0SDIELrX@dwarf.suse.cz/

"User pages for RDMA, should be pinned with FOLL_LONGTERM and that
would migrate them away from the CMA area.

But you're right that DMA to user pages pinned without
FOLL_LONGTERM would still be possible. Would this be a problem in
practice? Do you see any way around it?
"

And later (me):

https://lore.kernel.org/all/04904e86-5b5f-4aa1-a120-428dac119189@redhat.com/

"What does "short" mean? At least in theory, long-term pinning is
forbidden for MIGRATE_CMA, so we should not have such pages mapped into
an iommu where DMA can happily keep going on for quite a while.

But that assumes that our old kernel is not buggy, and doesn't end up
mapping these pages into an IOMMU where DMA will just continue. I recall
that DRM might currently be a problem, described here [1]."


And in the end, we settled for the 10s wait, crossing our fingers that it will
be alright :)

-- 
Cheers,

David

