Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B16ACA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 17:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFAE48E0017; Wed, 20 Aug 2025 13:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84778E000B; Wed, 20 Aug 2025 13:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973708E0017; Wed, 20 Aug 2025 13:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81B7F8E000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:02:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10E97118048
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:02:56 +0000 (UTC)
X-FDA: 83797755552.06.73969BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 40741C0012
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:02:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cNX5FnBn;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755709374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tw0vGfwzDFEPUCnS7y8mPbgETmCFs3CisrgKZbuO58M=;
	b=38WLzqqQV1wqy0cXfX+dqfbTmDwLUr/cm85QH+UnLuBgdbbCG6I5OP/fbNUZlp8iL6p+cu
	IJpbBvMzDb3yTOa0iVCv98g+C6rWGx6fTSch3c8fu+VURFW7UsaS7kiZV1/2tfKaM+qYv9
	uP71xwbjoO8NY1UjekfpGnEe9XYSbao=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cNX5FnBn;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755709374; a=rsa-sha256;
	cv=none;
	b=rNin3qz4QKViTnRH0lMAWBPgLDBh/vi7Vobv4hcfs3Cje21dwEFEhvzUuKGlNW9bwMxVoP
	ofImrGGRP/Za4GMYeWTlsWUg2+JuPC/L4rLI3rihaj9MBqAz8JyW+4uFKRY7pTyW/c0DY3
	vShaOsdEZ2b7/CzDpjHJXerAIZqG0go=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0D2E45575;
	Wed, 20 Aug 2025 17:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F515C4CEE7;
	Wed, 20 Aug 2025 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755709372;
	bh=HrCdwjFpFxpaKWtgscNZ318aNnsG5NhL9DO1rfmynjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cNX5FnBnvRPnHvtWE445pbsFMOEnqBch380SOWkKQEEqYR3bTQB3UhYZL1zZq86gy
	 ZAPvZkHUR2Bb4QrLdatZM7uw1LdxYOvmqWz3/07RD0VAVhBxhDq4rZY85a7K9Gxdg0
	 0+HnI/K4ybXFFjpiWB56YQ8ARtzypHtkFPkQmpK5ahtnKknsDoPb8mKVzPnjM9L6oJ
	 XqnFDf/pemk0g94lPuynwtt/HYP8zzZD2e+d0mpAUikbFf7Atz47ODTY5ZcDVIloj8
	 HQqR2YMk42KWsT4S1D3sc1hBNDesVadUMxcI9A6B8j45r8vsSK+hATFecL0KdfNc5M
	 jX2YADHI1r3FA==
Date: Wed, 20 Aug 2025 20:02:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Shiju Jose <shiju.jose@huawei.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"somasundaram.a@hpe.com" <somasundaram.a@hpe.com>,
	"erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>,
	"gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>,
	"Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"kangkang.shen@futurewei.com" <kangkang.shen@futurewei.com>,
	wanghuiqiang <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v11 1/3] mm: Add support to retrieve physical address
 range of memory from the node ID
Message-ID: <aKX_rk0DasbDgJrS@kernel.org>
References: <20250812142616.2330-1-shiju.jose@huawei.com>
 <20250812142616.2330-2-shiju.jose@huawei.com>
 <20250819175420.00007ce6@huawei.com>
 <aKV6dVkPiBPw595T@kernel.org>
 <20250820095413.00003bd7@huawei.com>
 <964fc2721fb7499daa5f49eddfed54ff@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <964fc2721fb7499daa5f49eddfed54ff@huawei.com>
X-Stat-Signature: ky8dtqps1mrjtja3z9tzr853ozodsuik
X-Rspam-User: 
X-Rspamd-Queue-Id: 40741C0012
X-Rspamd-Server: rspam05
X-HE-Tag: 1755709374-170159
X-HE-Meta: U2FsdGVkX188MRe27Jqzf3QN1GFAY6bXqpyfwB2Tj4VEdOBVQN6j2hnRMSynPvY+UTEVA8yRFMufwMSmWXKNa1vBwRFVXYWP4AaacwvggZ2GsDIOayu/dkt26mwjSzYxpkbnjFcv1O7+Colrj9ZwOLdkeZxlAFlyTWxrUcb2XYOrzSPK4cySM3Y4NvSdfqxIPIExXAMkdg3lUuHGsq1vWOaylxYdtgSrmadLai/xrmagq2lQzvz4RvxnDa7OKW1aHpwI6UwR6P87DeEL+7ueC2mrEJ8nsMkGZdznS9XGjPvKWsiIf52uNmhzL+3EOYqxgufMCGYii6v8vH8QH12rAhCo4vX9ef6ATdMvM4seBoY7q4hro/HVvrW5O7lLVtCVifrhQIZWcJY5mcQcde+jdpOwqg+KScJOqO95zav/1fxz7EB2866KRvMVCv6PmomveucSvZShaHQK+g3sm5JLJbC3lq52XQds3xvBMzTVqqg46utetYAURwJlquHGJwsAToS9jlc0tCVSJ4LcQrsZdN4MUYKC8dEpgLS+puw4z63DKpgx+DdcMg13XsO7TI+pVu5EfgBDrlA2RQjD4pamGGVF85qaXLmuZQiYkB19/Q93YM4xPGuo8EPjSM9WAwr2L5mcpc3LgkqtdkIKXtB7mIMferp05OQbitwJ7ISUqsnbk8LzeR1u+TysuGy8Kn2/8VMkWXBiaax4qoBGPYxjhRrxv4aAQMSt1VpD78ALNkVH3fMSjGHWvTp6ojxRPbD7d+bWH+9nm+i3JU7K8MXP6+Hbw4bii2TMYwsZnjF960Wr16EGZjpDw2NYyisn310vFzJNHMAnVhMD5PXfy8+zCLs+gU3X+vPo79pPowkxM2EPGr+0LAvEUyT04oZHi2VpLh5uvOUU4pvOtYAoBBWKOYlf1PBmsQ7fgxH/PZVG9cJZinBZ5rQ35CZWM1fQNn6MEHoH0Tp+q/BeSGcawuS
 NLt56ONL
 EPZuLsujVac8roR0sn8ml+EPsO5L3Mgd3lefvXSfVgrHs3e2Wgg8dvmmQDTdKgxiplZ8RuMkCXCR2+EbQ7fQqmyPLhZW/JCjW+849ig7V+ECfcfm47ECdjJJRCAghjjjEj+dzPbgFIuLk0gh1j+fV84eT59AEbmzMRio1HaYjwElme78V4GBCmaJx631BoKc00JGY3/0lu003q5unGz/aq7M8giftI7CcZuTiybRVG4OZ3962IRaDIr7cbMxCqyAPGwDkW9BGgTdusQM5oTULYAMikkv1bAnY3bpg1CyWMFv/cb5MNpSl+pNxZrgyOLd8xoyI5ybiBb2eWsSMgxg8k6XqssZPjbEXAnB/SZ8fjY2nRLhcLeMG0oVH96GKDHyXFCu8FK4br7pPL8OfvBiB+JurrAKeq53Jr5ZFEhw+pwPRx+CoAhnJJks0bkkZEnsNN0thqnq8B39j3zhy5ORibyrhr4a0zUoVKUxQm71aOTjGV0WeIHM0udZ93vy1GjBEyX1asygPrYhw4xi9VLX8hOafXn3iblsw+hO352Er2nORA39sLgx9j8xOud0RSsDQBtc7TMCKGQzcLAxdw+cexfAuusypT16/S6hFN2sZYZcZ14CQ23mPVK3fFQ8UGob53bzAVo6nViVJScJEAT/NdGt6j3nGE2SQcey32nkhY8DXacW0vS+W2fnUbK0iFDwtQISTLRjHcDvNyNjFppQJ6VDi80UHzjDy+AXb7kA4QM63kU3xKE8C9Imra1Hb2NaTnyX7C1JDM/9phn2x2nmH2cKcmP4JVJdxu+dPZkMTHX/bkquKiuM/gyuz0Vi6E/zSpCl83hrJrEdWO7uS+ysM1Md5wqtPfC92lBfrmnvezc54qXlpjXMWCS3W732uu+i28xLUCuuiiZivA04bs14kzFcjrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 10:00:50AM +0000, Shiju Jose wrote:
> >-----Original Message-----
> >From: Jonathan Cameron <jonathan.cameron@huawei.com>
> >Sent: 20 August 2025 09:54
> >To: Mike Rapoport <rppt@kernel.org>
> >Cc: Shiju Jose <shiju.jose@huawei.com>; rafael@kernel.org; bp@alien8.de;
> >akpm@linux-foundation.org; dferguson@amperecomputing.com; linux-
> >edac@vger.kernel.org; linux-acpi@vger.kernel.org; linux-mm@kvack.org; linux-
> >doc@vger.kernel.org; tony.luck@intel.com; lenb@kernel.org;
> >leo.duran@amd.com; Yazen.Ghannam@amd.com; mchehab@kernel.org;
> >Linuxarm <linuxarm@huawei.com>; rientjes@google.com;
> >jiaqiyan@google.com; Jon.Grimm@amd.com; dave.hansen@linux.intel.com;
> >naoya.horiguchi@nec.com; james.morse@arm.com; jthoughton@google.com;
> >somasundaram.a@hpe.com; erdemaktas@google.com; pgonda@google.com;
> >duenwen@google.com; gthelen@google.com;
> >wschwartz@amperecomputing.com; wbs@os.amperecomputing.com;
> >nifan.cxl@gmail.com; tanxiaofei <tanxiaofei@huawei.com>; Zengtao (B)
> ><prime.zeng@hisilicon.com>; Roberto Sassu <roberto.sassu@huawei.com>;
> >kangkang.shen@futurewei.com; wanghuiqiang <wanghuiqiang@huawei.com>
> >Subject: Re: [PATCH v11 1/3] mm: Add support to retrieve physical address
> >range of memory from the node ID
> >
> >On Wed, 20 Aug 2025 10:34:13 +0300
> >Mike Rapoport <rppt@kernel.org> wrote:
> >
> >> On Tue, Aug 19, 2025 at 05:54:20PM +0100, Jonathan Cameron wrote:
> >> > On Tue, 12 Aug 2025 15:26:13 +0100
> >> > <shiju.jose@huawei.com> wrote:
> >> >
> >> > > From: Shiju Jose <shiju.jose@huawei.com>
> >> > >
> >> > > In the numa_memblks, a lookup facility is required to retrieve the
> >> > > physical address range of memory in a NUMA node. ACPI RAS2 memory
> >> > > features are among the use cases.
> >> > >
> >> > > Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> >> > > Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
> >> >
> >> > Looks fine to me.  Mike, what do you think?
> >>
> >> I still don't see why we can't use existing functions like
> >> get_pfn_range_for_nid() or memblock_search_pfn_nid().
> >>
> >> Or even node_start_pfn() and node_spanned_pages().
> >
> >Good point.  No reason anyone would scrub this on memory that hasn't been
> >hotplugged yet, so no need to use numa-memblk to get the info.
> >I guess I was thinking of the wrong hammer :)
> >
> >I'm not sure node_spanned_pages() works though as we need not to include
> >ranges that might be on another node as we'd give a wrong impression of what
> >was being scrubbed.

If nodes are not interleaved node_spanned_pages() would work, even if there
are holes inside the node, like e.g. e820-reserved memory.
So with non-interleaved nodes node_start_pfn() and either
node_spanned_pages() or node_end_pfn() will give the node extents and they
are faster than get_pfn_range_for_nid().

If the nodes are interleaved, though, a single mem_base, mem_size are not
enough for a node as there are a few contiguous ranges in that node, e.g.

  0              4G              8G             12G            16G
  +-------------+ +-------------+ +-------------+ +-------------+
  |    node 0   | |    node 1   | |    node 0   | |    node 1   |
  +-------------+ +-------------+ +-------------+ +-------------+

I didn't look into the details of the RAS2 driver, but isn't it's something
it should handle?

> >Should be able to use some combination of node_start_pfn() and maybe
> >memblock_search_pfn_nid() to get it though (that also gets the nid we already
> >know but meh, no ral harm in that.)
> 
> Thanks Mike and Jonathan.
> 
> The following approaches were tried as you suggested, instead of newly proposed
> nid_get_mem_physaddr_range().
> Methods 1 to 3 give the same result as nid_get_mem_physaddr_range(), but
> Method 4 gives a different value for the size.

I believe that's because on x86 the node 0 is really scrambled because of
e820/efi reservations that never make it to memblock.
 
> Please advise which method should be used for the RAS2?
> 
> Thanks,
> Shiju
> 

-- 
Sincerely yours,
Mike.

