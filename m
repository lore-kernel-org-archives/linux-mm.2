Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E98606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IBacwDrO
Received: by kanga.kvack.org (Postfix)
	id D33136B00EF; Wed,  4 Nov 2026 07:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD516B05B1; Wed,  4 Nov 2026 07:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A4A6B05B2; Wed,  4 Nov 2026 07:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A83D76B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:09:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F501806CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:09:38 +0000 (UTC)
X-FDA: 85397317236.14.71F1BA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B2A5420006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:09:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IBacwDrO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793794176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1q50kbPjm0laMW43CAFUAOZZKVJRQfTQZ2GnkZN13bI=;
	b=dAgp1P7Y9YZmOaKKnArVNFehdmWaMld5egk2VHNtSP/2B/Rhm2xnJPcku3Ku8s3Ng0OoNF
	Wd5Il+godsuhdRUW4ezAySkgcplIAKeNA/vLVwVN22l5mauyu2v+4Si2blkF6sOTYS1rKn
	tjCPqaDmmke0EXA7rsoiqR2lAW2WuWQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IBacwDrO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793794176;
	b=RbVhaJHbj69TCV26KCksMtli6ksJo1Dq/FRXr/t/9SZFPDyb1U8yYV2qAeBdckHr2cvqKa
	yQwYBOh73e8s9qFiwIYZD07/4D8qwMj6cd/QxmUuQGl8Q3ofFLI+gVA38OE11RczeVtKKV
	FeQSm9uap9fz6pC7iHY2dzlPb51T+Rk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C5DB60F1C;
	Wed,  4 Nov 2026 12:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69461F000C1;
	Wed,  4 Nov 2026 12:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793794175;
	bh=1q50kbPjm0laMW43CAFUAOZZKVJRQfTQZ2GnkZN13bI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IBacwDrOzTcQPD6MCzu5ag+D5mCuIXCB25VBCeCuKwjRnD/yTDiBogxZl5jYquVve
	 N/U4Xgvva0AWTbh/czKe742mHd0uC0vYPThPEpYAb2YXeBo/pqTK+v1ukztA+/Pz9V
	 HGxTNqvaVYGHwy/p4rTyhbTlyW9BGHVeFn07LX1lyc1fPobEvsKQcEkbo5IzuUG1tN
	 buCEbkuRpb111d29csvEspHKSAFNA22GtU1fjipNnyVIefLnc0YZJnuaMMHlbqkqaJ
	 GY2c7l+XEoMg8KeeS7WKj1xOWOGD2D5PSrPbF8ucj879OhUM4eGyMevn3pT8EDNefA
	 jEdUudXx0W4Sg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Andrew
 Morton <akpm@linux-foundation.org>,  Chen Pei <cp0613@linux.alibaba.com>,
  George Guo <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>,
  Sourabh Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 1/2] kho: skip zero-sized lowmem and global bootmem areas
In-Reply-To: <auoo0EOKJLn9GUIw@kernel.org> (Mike Rapoport's message of "Tue, 3
	Nov 2026 20:32:48 +0200")
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
	<20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org>
	<2vxza4nqm27n.fsf@kernel.org> <auoo0EOKJLn9GUIw@kernel.org>
Date: Wed, 04 Nov 2026 13:09:32 +0100
Message-ID: <2vxzwlqslrwj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B2A5420006
X-Stat-Signature: y9dgtcp6kzi8f7kt856mij11ebz8s9yz
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793794176-181241
X-HE-Meta: U2FsdGVkX19r+9b13B0JGCM8ozGIMSZv3GBiMFfC928XAtSK46ppFeS47KMM+gAgmgqU3dlXcGlVarGIgSd50TtR1rOrY+y+eWORugRS6n8jbg/P28+pN/UQ6NRDfhveZ1j5lPPogvLSJFB+G4nZyVAL7RMvgH0wWTEl6Yf+UzBQjXNSyQA84MqXivSFgTTaMoHXnM5RCBBU7XEBruL1HkCx3Fcu41iG751GH5FmEjU1tI28jwEhXCY9WvVWnTGS++prt/FH5WmOLs3zaTkg1Ob9nRKpQEmTFxBjsxGEhv5Zi2/uvwK8hCxY/Zm8dHzAryL4oJnQgCE6b1xcN1F48FHsXhDFJQ6veFQT0OrvccupjUydsLfU6NKrdYUe8UOfcbyt/HgNoAMmD3tCn0ifASmNrG7TwVdZNXl2sOvsWXBmwic9zBMTD4sEzACnZqaDNsLMUPYllTfv3Jc7BjS9pJ0SWEhFkg7fdHuy9yCbzBAGNpKTJ6Lxd+5eHQ+63TREF3gj7acZEnmDsEXfazgGflE6c6pAS3rpfJ7/W3ZngXZlfYX+vQxpFgTzWasz5pM7CB1Bw50ZjLLQKMC0ruf2RTIeBaVYn40Ub5tCp2yTdffBS/9M3cqd8Vyug+/mfJ+vRaYpRMbvaxNjc77xVgLYUS2UtmjZWDf47dLCCaq0rPTKnuXNo8d/PeuS4zmiLTsgHLMS+dL1+L5dkZp+2n+wBFFT5kMSCImjRpVrvmAOTNhpdddm4qWfYwchQIvXSxvlMQxsuYSRa6mVgjWiC8mVlfkHvlIdAd0BHV/56nGDYLXTSjsx28H/lqB3O0Sfxdj00XePXcg7t93IOw3LxeJySyK1PbOOnvG+FbN4HxGj/YhNyc1LAGiqMEhRi0aAtIBTAzshoQh2aOswJemFMbkuaD9/Ulpy4/BgltisRRdB1KJkD95Y7rGxs8wMvIY4mlicYObTV6+qNWjvFwUtV6U
 klpgH+f1
 KIPMaWNin+Cm4di90T9A/nYyf5q77b29ngVAO5PJwELd73H8GyKW3lKWvIKgN365GLv4BWyCakOciCUsExqK3ufMYHz1uT/lw+JUB72vQCgk4sJY9NvKS3NLkprhEglChxu3oFBUrOsquVLj6hXRu8lGbQy8Kfx3IuGpP3exGc/MPjLHrDbGWAey3ok/A+dEhUcFntpgoJBFr05KegsGbg5nCmskB8XMDW3ou8BsQEBl72UdFHLaJ3ylrphqO5mg3VWFc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03 2026, Mike Rapoport wrote:

> On Tue, Nov 03, 2026 at 03:14:36PM +0100, Pratyush Yadav wrote:
>> Hi Mike,
>> 
>> On Tue, Nov 03 2026, Mike Rapoport (Microsoft) wrote:
>> 
>> > The lowmem and the global bootmem areas can have zero size, for example
>> > when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
>> > either of those areas is explicitly set to zero with kho_bootmem=.
>> >
>> > For a zero-sized allocation memblock returns an address without reserving
>> > anything, and that empty area is recorded in kho_bootmem. If there is no
>> > memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
>> > fails and KHO gets disabled.
>> >
>> > Extract a helper that checks for zero size and allocates memory from
>> > memblock, and use it to skip empty areas the same way as empty per-node
>> > areas are skipped.
>> >
>> > Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
>> > Reported-by: Chen Pei <cp0613@linux.alibaba.com>
>> > Closes: https://lore.kernel.org/all/20261026131851.9942-1-cp0613@linux.alibaba.com
>> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> 
>> Thanks for the patch! LGTM for the most part, one minor nitpick below.
>> 
>> > ---
>> >  kernel/liveupdate/kexec_handover.c | 61 ++++++++++++++++++--------------------
>> >  1 file changed, 29 insertions(+), 32 deletions(-)
>> >
>> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> > index 6f1f55fe31819..f268c57413a7e 100644
>> > --- a/kernel/liveupdate/kexec_handover.c
>> > +++ b/kernel/liveupdate/kexec_handover.c
>> > @@ -820,6 +820,27 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>> >  	return false;
>> >  }
>> >  
>> > +static int __init kho_reserve_bootmem_area(int *idx, phys_addr_t size,
>> > +					   phys_addr_t end, int nid)
>> > +{
>> > +	phys_addr_t addr;
>> > +	int i = *idx;
>> > +
>> > +	if (!size)
>> > +		return 0;
>> > +
>> > +	addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES, 0, end,
>> > +					nid, true);
>> > +	if (!addr)
>> > +		return -ENOMEM;
>> > +
>> > +	kho_bootmem[i].addr = addr;
>> > +	kho_bootmem[i].size = size;
>> > +	*idx = i + 1;
>> > +
>> > +	return 0;
>> 
>> I reckon it will be cleaner if you update kho_bootmem_cnt here directly.
>> So you directly do:
>> 
>> 	kho_bootmem[kho_bootmem_cnt].addr = addr;
>> 	kho_bootmem[kho_bootmem_cnt].size = size;
>> 	kho_bootmem_cnt++;
>> 
>> You won't have to pass around *idx and you won't need the final
>> kho_bootmem_cnt assignment.
>
> Ack.
>  
>> You might also want to have a kho_bootmem_max_cnt and do some bounds
>> checking here.
>
> Hmm, feels like over protecting. And if future patches will miss it AI will
> yell anyway :)

All right, fair enough.

-- 
Regards,
Pratyush Yadav

