Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FDE606A88C
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kLdIUvRD
Received: by kanga.kvack.org (Postfix)
	id F277C6B05B5; Sat, 14 Nov 2026 13:34:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8476B05B6; Sat, 14 Nov 2026 13:34:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF806B05B7; Sat, 14 Nov 2026 13:34:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB0BE6B05B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:34:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D6C614045B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:34:34 +0000 (UTC)
X-FDA: 85434575268.11.F597AE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DE821C0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:34:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLdIUvRD;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794681272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIJH830yAU8Etb/lYqZfpJ4EsMpPggWMJX7lGP00TrM=;
	b=JJLg2FPgjoaY/DAbIhaARoSJ98UqcmVWWHFfbAs3nQvlw96VqTTrgRYv7LDWSlpa85GIVR
	8vUJVlEjpzOlTy3m2AFOLbwe6DRWOvdWU9k3oUKg09A2PJi2TpcF0y0e1JHFpp7tJxzKh8
	zGNlBaHva/NzDN/KlDOFmu65cF2AO0k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794681272;
	b=5ecr+hyA2e+dIA7pHp8f5y0ML0quyX2W/4LNSqK2700x9AFhcHB1wbptXmWwwJy3J26Mz/
	6mwR9782m7C0jdDrNF2T7libkTPGWyQk3WYs4pd5mVqEEDHJ1RftDXDbKQ3fZ29uTBEgby
	3QvJBKEoXglmsRVWvXyu9EcMP/K1658=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLdIUvRD;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9737842E8E;
	Sat, 14 Nov 2026 18:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA86A1F000C4;
	Sat, 14 Nov 2026 18:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794681271;
	bh=xIJH830yAU8Etb/lYqZfpJ4EsMpPggWMJX7lGP00TrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kLdIUvRDvJxlUbY1ynRLNC3qDVm22HDJQ/oDoeAj04J3VQf5GOK2z+EVYkFf54oeO
	 ojMxnJJciIKBWDTf+n2auyLYOSEpUgnGR63WYG6R7v0ceX42IOP9B6sHO9PCtbaxqU
	 8FTFzMmpeWihgC5vIRFbUbZVoQJLQLQJ1FaYtUMWyWEvptvnftr8Gd8NEwSs/tjm4P
	 IfryQo5zUxv5NMGHR4OmlosERhkQzHZgGtHy0jZYv0hXUSugT1jq3HrSUrJVoQAJ9j
	 BHU7F3zmvwDZJSycFY0Uv4MQdEl6eRlTEvANgZi+rMgpityIDbYPWUvZR5PZlsfO2a
	 LsMXcMZ02scMg==
Date: Sat, 14 Nov 2026 18:34:19 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 05/13] mm/migrate_device: don't collect a range twice
Message-ID: <avinH6zgTzpjMCrf@gremlin>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
 <avfrWjzLQdDcmXO6@parvat>
 <8c79ce88-7730-44c4-92a0-d760d6f8e9e1@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c79ce88-7730-44c4-92a0-d760d6f8e9e1@redhat.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: kggpnp3x3tzaptbkdc8dx9dhezuckm8m
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9DE821C0006
X-Rspam-User: 
X-HE-Tag: 1794681272-648331
X-HE-Meta: U2FsdGVkX19zVg3EQ+Rzm41hukC6eT8QTq8+keJSEi6jFSGTTu6ATQgXi0W3QxxobO2HwCWFT24FRJSADdHN4CdVEv3fo8+YHulV+mEJ2sY+kQP4YXcEpv5HQmcqcYXLJwFJSVjQ4rgYo1UAjQZgNmxeuoawCZc0uBban+6BNe04P6TTPj3A1GsJAgin2AJhJnaipvCSAlmXtrcs2PBmBz90+cIj4SqLNlyYnDxlSVebnPz56iMN1gVuiKI4aYnIwtF/NAPiATp2hzfvwKXzcbp2jovJ9PLkttVE1Q0eO0ahbM9dg68Q5a+gIbmx0PW0tCJZmZNSPtzuz1YEjQa4y0VhX+WCGhOs3qS5pE6kch6iyONufy7wLk5+jo2nbvp+kxJIX66nBK0M4zZD5NXmkcLkGhrHH4Q17B/WJCtf1B8uy7PqhGTXaZmpsrluLwZNICeH3xldNMfurZXXBWNKt6wgShZPj0l/VQ97uMgn5ZyQlh2/v3SgdKFzyY065RFGRi5D6NGxlRODL8zcdKxxFaQHhPH2H05oKtuiD0IGWkRRrIsnzzAIgF7MN6vWKA0BEx9isBiSMuib9Z08JX4fTJG+APsfXScLRmSd6sFLf4LAhEirixiu1MZHAZzCz4K/aUB00AsTKTL1XjgTJdsV5oBYKk3bciObM/2z++fyKCBvxzHjuaoaLbDaSXJ/CvPePCjqPIbivCqefvhS9MP01N5u8VOajCr6SJ7i2XZzVhvnpsijFLmPHR//DQWsRpsBfUCfiGR41+DG3jroPPOsH/rya/QjCrmuLtWbqsfgB+LOYBd1Ql2u5gkfEI2rSApRBo3yCnvYmBt++1FgJnfZ6xscG1k18FvvJ5OElXp+K/o5hPvxg5Lhv0pEA07fmYZ0wjc2GCnK6xiKMc1yO5ey1L/kwoxApjnW2CTIzkVQt9Zv29ilsqnzBcUM83yMcLJr52JTyLDJ5SCmVfGczU0
 wNMDM2Da
 6V8oF1TNo05LQ8L5oQxIkyCHT1v+pa/SLoq/S9ngJCRC5LNX0k1mMFFdd3tvtHeS3MZz5HzBF4nhau7DvoUOwgEPAcyFiweR+uTwW6aBHN4+pBTjhalAYMsa4C2FkhJ308pmpREXXYBf1u7oQrLGQs7ZnhJR7VvoOSGFHP1K9MwFKED4cSVQ9vCZMYTmmbEB+WeQdFf5I2ArDwoKtLt1Pe8I+8iCjDkxtHyZ5QrJaxOfBNkNs+8ddbAbGB5EASMIvfTIVc+MybqpptdBwE5dKEf6MuLrL+hpTTVTAJYLexagPW7bl4K4A+lxnVm+wRYwwP//oU3a8JiNPycsV0K/GV4GfA581LJcgwTbI5c5zqUAdDPPs8QuR89BW5e/V+GMDZ/cVvHKbUo2O3ZOs320E0O5dIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 08:45:55AM +0200, Mika Penttilä wrote:
> On 11/14/26 07:09, Balbir Singh wrote:
> >> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> >> index 9e5dab8e1b77..28ed706109da 100644
> >> --- a/mm/migrate_device.c
> >> +++ b/mm/migrate_device.c
> >> @@ -257,13 +257,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >>  	pte_t *ptep;
> >>
> >>  again:
> >> +	/* [start, addr) is collected if we get here after splitting a folio */
> >>  	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> >> -		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
> >> +		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);
> >>
> >>  		if (ret == -EAGAIN)
> >>  			goto again;
> >> -		if (ret == 0)
> >> +		if (ret == 0) {
> >> +			if (unmapped)
> >> +				flush_tlb_range(walk->vma, start, end);
> >>  			return 0;
> >> +		}
> >>  	}
> >>
> >>  	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
> >>
> > Is the intended race a concurrent MADV_DONTNEED reclaiming the PTE table while
> > PTL is dropped for the split? That would leave pmd_none() true on retry, entering
> > migrate_vma_collect_huge_pmd() through !pmd_present() and taking its hole path.

Balbir - yeah exactly the PTE page table removal, and it zaps the migration
entries installed for [start, adr) too, so those don't keep the table alive.

And yeah, we would then see pmd_none() on retry and
migrate_vma_collect_hole(start, end, ...) would appends entries on top of those
already collected.

>
> I think this is "ok" for the fix, the hole is collected from [addr, end).

Thanks. Yeah addr > start, so it's not PMD-aligned so always ends up in the
per-page path.

And if the split happened at the first entry then nothing is collected yet
anwyay.

>
> But couple of things follow. It can't be possibly collected as
> MIGRATE_PFN_COMPOUND entry, only small pages. And the collected entries
> in [start, addr) are wrong ones.  Finalize will recover, but the
> migration will fail for those.

But that's true for any zap that races after collection started, so there's
nothing for this fix to do here.

> These all are handled in the HMM walk based migration series.

Ack great glad to hear :)

--
Cheers, Lorenzo

