Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CCA606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Je3rYygI
Received: by kanga.kvack.org (Postfix)
	id C1F556B05B0; Sun, 22 Nov 2026 22:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6416B05B1; Sun, 22 Nov 2026 22:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33406B05B2; Sun, 22 Nov 2026 22:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3B06B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:01:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E106D16078D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:01:32 +0000 (UTC)
X-FDA: 85464883224.14.387B944
Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1066100002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:01:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Je3rYygI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795402889;
	b=UnUH7r7CQ4cMDc+JSUDheArodFPGUPij5+LcO73BzZ3BOUdFDcqJZAXM6URAM1TGfNmLKK
	pB8d7lU7pVsKhubc72sWTEUAIRGqhZ/4MRsJ6o3QBdQ8keTf1H9Q4JmLZSIeCXm9sP64v2
	W9gTGvhxnlcid4nzAXpviaNLwJtvuL0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795402889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVGtwWIUrwg3vjkZky9jBduG/TMeysWW9WrLvNCpeaU=;
	b=1X6J/xVgEoE618BPmEdVWUEsmIP+AD51z+w4C9fZYZrm1eMmD5JNfUEfLPby+I6tmJhKOD
	TF9HNs/bfTDTODpsWqbkhRhhWUe7TQ1Zq1+uNkRafBVIjz5/HCb6cI5avzxFcgMFC8cDmV
	xPs64cl/LG5tUH2h4enQVqqMRl58rtM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Je3rYygI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mIgBcbUV5ixDOvXz3J1MusGef0bPdFIqnXiTXJGakI8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795402887; v=1; x=1796007687;
 b=Je3rYygIgpzY1nXNspU9V2667bbCxLLQx2mNTGfA5ycudJIdi0ddpU3flrQfQ+x3bu/n4JwP
 EHkGQ2b2RtFhdpJIDn16/2YsyMpdxpo9jc0VZClg2ybCSOXNcWbKs036kkjhk0PZ+OuQ/szJxZH
 3U2NuV9anPz/kTarzHXX0zWQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 195945ff91ad8013;
	Mon, 23 Nov 2026 03:01:26 +0000
X-Mizu-Trace-ID: 195945ff91ad8013
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 05/19] hugetlb_vmemmap: Allow architectures to
 dynamically disallow HVO
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261122184453.2668189-6-jthoughton@google.com>
Date: Mon, 23 Nov 2026 11:01:07 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C1CC6F31-4F75-41D8-89D8-CE43465FBB6C@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-6-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 6as7hggrhsakjygutwxtnjnxmsbq1bfb
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C1066100002
X-HE-Tag: 1795402888-113064
X-HE-Meta: U2FsdGVkX1+xjKt7Fztu0SKyZb2rZD97e7trWdnig46LlLgZ5l3mhgr+RPjo090cNriV4fv21IL0zfL/7DXvJ2AalBvfSM+MmnZL6kvoH5JxulgTxg7N4t3QwixibdYY9ngCvzmk70MJ1sKCwD/mffH0eWIec508k7yTWMc7d6UI0leG3yrKcQxEnx8AKNDNjl5s2QrFI9Plxp30ZUOyWK2sBmiv9wYQuneE3ogEzeD/oqkn10wiW0b4EO49CRV2OTymaAHEe8Iu0detsvtBW45R9ymxnoEL0VqGPA0+mZXe4Nvayj1O56ql91TrvMHMXF+qlZ+G9dWCZb608WWUCVZEA6fVYDq6zSFq5MirJizUqcE0PtfG2tTtcjRBSc1EwrQHr6Zpyqu6ad9ff+t4lmEh8gRUht7N/hclNCNxeICyj7L/AYPzfhpRBQhGl+VSWTqHlswmREQrUsaDRM/7WJwyG2Nn/eD7oR+xARbkIAn488Jhm0OsRe67zaknGPtiaGwRkjpUJif/4P9fPhufUKMhjHwsRjvC91Zxgqc6mtd8IXfSbo42CfRLicOEhtyBPmYhv1mMSI13GNgptgCUcx8VuP+jxuJ/0Rs9N5fzHL63Fblq/+kC9AZE7O1moMxAW3RGGnVerpAyVha5IwXs4TMTIuCj+HCUQk+yOs6Nyk9XPRDkS9jkGNEzlcNmQr+9wKmnlY+EPwKMKcFe2phUTfWbusopyFGz5dO9IrhMNAC0B6yXJoH1axayj7bk/a5eNPZP5sYuQ/QWGbr8pS0rbT0yolMRtaECMn/7Z8SV449FGy7ol/iIIH37HyUP00l0LOVezO+cvLTWdz7SWa46V87XUEPOW/2LuNO101eZDR6IR3+XhTk1YWntSZhEWKQoHHvRoAnBjDLmqY94G3yg9zaB8XiA+peeFxRYlW7kPqRrQ3PVFGaSB6b6IY89sv3YqEwWXBPOwuia/e0/+oV
 UKTh9uWv
 VI7o07+NWop2ZaLh7+P6B8lWDeSn+V26hqQvUNeEZSgmNyGuQJ/lUfVmeLgArkLRftCudmLF5VneOJjnTp9frY4CmjW3kNViYwhdUk/hqPmvfN+LB4fTOLyK2Uf1jcf7oDLMXyrvgdIqIk9oLgusHuXWxV81hA5PiEHr2hxAUGLx7U71YbCKghIwXITGxqJzIBSyg3UKTdsBrQ3Zi5fVof1JP3RX8IR6d+ckV9N33J81Dzkn1hCnCubIKeaUDRTejeL80f2PJ2z+GBN86802otY7P9dCO52d2i7E4/lm2v5ZL9m2RSaeFd1PRKoDZwzKF3mC4EddzvYBSZeDY3rgCtgRcOGrD6kBiPLU9lIQhzsoC6mQLiOnAAFeRtsisUzDgsOGm6wOcjIxia5NBiAWduqmY+GOQ54J/+h18NUfUHhZZpi0IGi65J0W8OABdOMHPT8f4mAvGHxsFUrN3KN9QQSmFccKcmF9FSyuHbbcd5P1ulPvDWXzdDKB5f0E2CehI5G0T2zfUT6CrtSSTytPEF6iYciw01zYuaVbFoE0T0rEHpq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> =
wrote:
>=20
> For arm64, only some platforms support HVO. Add an arch hook,
> arch_support_vmemmap_remap(), to prevent HVO from taking effect if the
> architecture lacks support. The hook is not HugeTLB-specific, so it =
can
> also be used by other users of in-place vmemmap remapping (e.g. =
FS-DAX).
>=20
> Check it in hugetlb_vmemmap_optimizable_size(), so that hstates are =
not
> reported or treated as optimizable (e.g. by report_hugepages() and the
> HugeTLB allocation and freeing paths) when the architecture does not
> support HVO.
>=20
> It may be the case that arch_support_vmemmap_remap() returns false at
> first but eventually returns true. This is the case on arm64, where
> support depends on a system-wide CPU capability that is not yet known
> when bootmem hugepages are allocated. Such architectures cannot =
pre-HVO
> bootmem hugepages, so they must disable the section-based vmemmap
> optimization in their vmemmap population path with
> section_vmemmap_optimization_disable(). Their bootmem hugepages are =
then
> optimized when they are gathered instead.
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> include/linux/pgtable.h | 15 +++++++++++++++
> mm/hugetlb_vmemmap.h    |  2 ++
> 2 files changed, 17 insertions(+)
>=20
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index ab33df268955..8cf44120e2ed 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -480,6 +480,21 @@ static inline int try_update_vmemmap_pte(unsigned =
long addr, pte_t *ptep,
> }
> #endif
>=20
> +#ifndef arch_support_vmemmap_remap

We usually add a 's' to 'support'. Like arch_supports_vmemmap_remap.

> +/*
> + * arch_support_vmemmap_remap - Whether in-use vmemmap mappings may =
be remapped.
> + *
> + * Vmemmap optimizations, such as the HugeTLB vmemmap optimization =
(HVO),
> + * remap vmemmap page table entries while they are in use. =
Architectures that
> + * can only do this on some systems may override this hook. It may =
return false

"Some systems" is not clear for me, How about rewrite this sentence =
with:

  May override this hook based on architecture-specific runtime =
conditions.

> + * early during boot and true later, once system-wide features are =
known.

I think the description should be general, so the last sentence I think =
should
be removed.

Thanks,
Muchun

> + */
> +static inline bool arch_support_vmemmap_remap(void)
> +{
> +	return IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION);
> +}
> +#endif
> +
> #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
> extern int ptep_set_access_flags(struct vm_area_struct *vma,
> 				 unsigned long address, pte_t *ptep,
> diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
> index 8b28063d78cc..440477288d19 100644
> --- a/mm/hugetlb_vmemmap.h
> +++ b/mm/hugetlb_vmemmap.h
> @@ -48,6 +48,8 @@ static inline unsigned int =
hugetlb_vmemmap_optimizable_size(const struct hstate
>=20
> 	if (!is_power_of_2(sizeof(struct page)))
> 		return 0;
> +	if (!arch_support_vmemmap_remap())
> +		return 0;
> 	return size > 0 ? size : 0;
> }
> #else
> --=20
> 2.56.1.809.ga0b61035b5-goog
>=20


