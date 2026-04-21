Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B6D4F8FA9A
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 16:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0726B0005; Tue, 21 Apr 2026 12:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A85F6B0088; Tue, 21 Apr 2026 12:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E56B6B008A; Tue, 21 Apr 2026 12:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 610FE6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:05:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F14FDBE4D7
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:05:10 +0000 (UTC)
X-FDA: 84683037180.20.CEF3CB4
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 02976A0008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:05:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y9e7uJzF;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.161.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776787509; a=rsa-sha256;
	cv=none;
	b=OvRfEpP6lDco/nCeioJOp2B3SyHP6Zt4tDPxdnip1lN9cBQG0dfrgi1sCxKnl1NIoIH+Wz
	nm3RkxQOE1uAdDTdGdmZOCvZsPd49kTtvXUMU4vaNVRIVWQ1gdoZYmQE/HfaKRxjD0z7Wb
	uqBVubFADI7iFM9m8BHl+D+1/ohliQA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y9e7uJzF;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.161.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776787509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfR8fZwCFFz0FeFXDfTRURMvD1IDFp6drnOSFVLy1EU=;
	b=5z+MSufQmXlWLfTBwZ8xEg5s5otKkU98nb7AUu6kmoD2g4fJm2q/1zZQsg9K3ONLnjKFb5
	uNm5HV5wHXVrMsShQFAB2wGdmiGbUMCqJTJPSLQQLMegwBkv19D5Nf1FKwwc4RIXBuBNX1
	i6P5X+VCpeI1PytJdaKrj79kwo3hXOA=
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-67c22b05346so2252601eaf.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776787508; x=1777392308; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DfR8fZwCFFz0FeFXDfTRURMvD1IDFp6drnOSFVLy1EU=;
        b=Y9e7uJzF4EA8TJtrnTEfAlaZ6wWkmaLBLB5N+3QhPtok+Mcat0GTMQqii7v9BYft9A
         b6H606YWsC3NeM8qUfDfmNvOHhwWKA6pwU54POib468yBx/ljAQVRpu0m2ZXVGNDzrsi
         u5pBVoN1o27g161zjsBk57/mMIaYipM4QHm8BcLK6nRHPeeNNDa+Xrs4Rh0EhVDJOQBB
         ZLsMUvdWI8Mu9TIymuCgs6JrBOf9WMxqYNfGV7J7/y3Ybh/OWNQapx28algXxssVyChT
         Ejl4cdrwuCRsCsi9CoRvAC3mqObWPf5AwgNF/z3zDTJTuMC2/ZbfpS4D2twzh6BcsFjV
         DFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776787508; x=1777392308;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DfR8fZwCFFz0FeFXDfTRURMvD1IDFp6drnOSFVLy1EU=;
        b=GSoAo9ffC/GG3K7i+hEF772HP64CD0WiaktQco9V0G1YafFGvU2LDgdmVns/aXdo7C
         PMFIfV3hLYwPGj7eNwzuwqKj8U/UgcTL0sdjmFWgd+zuU5ccetHQtK3ukML5/3H7IWpy
         Xg6WUk3vH2p9DyjfQMtqWRk6FI4Go9UjVxJwCwbQKIwF7VxLHPkdh/+ZU3clrdbDodKN
         J0FBdbIeCU1od0annUuwqLUOptCYmgdFciij39LcTupda2LN8lAZycUka+TYQnwNJIOa
         ijcGURu+pyEyykFNwuP3tHfhqED50Kveu+kQBIluhPwidUBTuratLnN+h6lqAfvFt5Zt
         B7LQ==
X-Forwarded-Encrypted: i=1; AFNElJ/I1/mk8NQoT7qbbsX8sZlJvg1xeBQiOeMHj8eSiVF0fCXJm0wL0M+V1SV/2aHavWx9VjVFVAD9QA==@kvack.org
X-Gm-Message-State: AOJu0YxO4632GDf3sqa6jyB3JJfiBwO45JHYFrU9aMtVCcom1dnazS7g
	Xw7OPmm+Y9PjttOHFPma0NFd2Zb6trvS9hEMyHJ4b6hRXAVpph4e7sfhEOfTFI+OH0w=
X-Gm-Gg: AeBDieulag+4y8O8NTmrfjSY2NsZhuwumnznqKlDunfEAaxBRqY1+3qGgJxItQf0p5s
	1PPzgh3Qq4+UeRzPiaztynDzpbMBozDiKB4W7ud6S//29h+q8Fnyoy9udKCgio7JdcKlWcTX055
	DX0W2vXbBPO6F65k2miiIcUtsx8KBLQGmE9vsAh0yrcEn8h8m0QjmnzcpmFs2nqyYUVB8lXThs7
	RG1aLlr6B+vhEJ1sddfvvsj4LcWQ82hSGPMmR9vhudyVk6gwXMK2CVpPYUVdIeXyW04TduZ3Jvw
	8ATZe17N/l1M35LJJAdX6EFvkPlR8oLKwSmp4aWdL+vkiQ8wG38AJnYZZIlhHYq77+181jC4jGy
	Amov6SwPu9MsNORz1D2UEVuU1mAfOm94R8MLqR/hEYefEbcWA6SfT8PNVz1mTxE7vgv6I6KRogY
	dzUsMfNKvImepvTIGEuqZjEst1AJgMeedHav66EvNEitH2fbZs8MdrvBdsIJcuhY+Xg3XrwS9fW
	kpbTd9HrDLuRXPVCYPq
X-Received: by 2002:a05:6820:1796:b0:68c:6e:89d1 with SMTP id 006d021491bc7-69462f31c5dmr11175838eaf.41.1776787507683;
        Tue, 21 Apr 2026 09:05:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-246-228-50.washdc.fios.verizon.net. [71.246.228.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d69ad48asm1059065885a.19.2026.04.21.09.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 09:05:06 -0700 (PDT)
Date: Tue, 21 Apr 2026 12:05:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com, mgorman@techsingularity.net,
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com,
	riel@surriel.com, rientjes@google.com, sj@kernel.org,
	weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v6 2/5] mm: migrate: Add
 migrate_misplaced_folios_batch()
Message-ID: <aeegL2ltmCTfuJiw@gourry-fedora-PF4VCD3F>
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-3-bharata@amd.com>
 <24cd6a95-1304-4732-9273-43c73ea858b2@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24cd6a95-1304-4732-9273-43c73ea858b2@linux.ibm.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: orpf9r5exwu1ayxpr4oc6otoongt49ey
X-Rspam-User: 
X-Rspamd-Queue-Id: 02976A0008
X-HE-Tag: 1776787508-581436
X-HE-Meta: U2FsdGVkX19xLfaV69g3NV15c+pt/8wlbSx7V7hoRveeX/VQc8TtgEP49locKLciW6PwU9n88jbgEmMzCNz57dTG87PllTcmj68DJnONzQp1lPl+jOMdvXDVGSRYJM6+Gy5qhmqsVob3Z6ySD+eT41dSFtJ2AJKA1kbBJT34KaE57xwCVuUqZSAQg1dJYfOwXFkdq3tUnQcynBcwE+Nqs3QJ+mknTywTM6aJxF4ldFfiqzZlq42Sbqa6B5qNLMHUumAho7t/kefASKH/F6PjOuZSeDC95lxSsF5vDQZ93u3mJDZ7ZSrVBPBwOWSVex9s2jUD96ZAJVstHw0Vu/IGYLuTdyvcXpTAbYPDdKBdFTCeFXEpoc8zTUhLvOuG73W/ODfCsxGzIZ6/15/OFsUfy3YwAtTrih57FVQX8y9w8er3ryF+qDPowMlQMH5FFi4hllFmfj9uM75S8FYdnQWmbk0fNqzl+Vy0/6guEEey/snSRb4JMkRIES1Yb1HRcOT9ZHpAfTJP9HC+NiPxXQ4ga/CkPMZFzX6TrXujZPL5AKdat450HdocBVrW8DQal4QFZzlFVqEu8U5vum5OMMQNfp7dnRndyeHFqVdsgmIr+ZlqFubxDsq4GF4+JSbTPRZi4CBqx6uzaNLXa/1EJwmu/IG0GCd3ECTgWKtnGGQ9vfPerfNNAFAGTtX3rNtKop0RLz/mHF6I1/27WTu0LiFJC8IRJQq/WsElDocjPxlqI5Uh37Q0o9uMsKwNZVo3NRfWINog0P1NKVQrOkL9OPMBbXZqnH9U5N3O+am6jhCXG4IbFTefBXaWEkDzctIVVQTbOwmT14eB+xgcrDk3a8BdPkD9ZR15MvpuAM6e4tCx1JcG7BjQuVsdMxSdoE22bNN4B8hHrZkwF2SlOiIqEFaaUAySFW/GuOgik5fQgHh3QZlD84ShdADL7ALwOIga4CuYW8eUcBBb8L9LjpjM0GK
 9+cKuGXo
 5mDDdsmGqk6n/UICb+yZmO+8MKs23vEBoM6itfjVlbuNjli4C6cpakQY/gXQ+PqRQAKEkW3/hxUTMa8pxwll3ivURjddq3/L8wiRb1pP7jgbDxWF6OaLAXIGdyYApnuL70fLqS1VDtPNOTn9WkuTAyYoXb6Mvp3vFl0ycQyrPZzjCbvwIbXO4eme+kX6O8l0NG6y/tMOPGVY4WQeywYvknd5LEIB/hIK01UAtRkM+bvcJ8ohP8VOq/SFVMNtHayOyavarpnfYvQE2kXBMMXKkMmFzNlLjegn37Ag53GMIiTcQgP/km0XrITMQJDruAxW+6FROtlcMp6dJL4L1y/u1ICqHI1CxNALaNwRs+m82tVDO/lYFL7AM2G+DYisuUFeW6XyIfPDKfk70J3/Ejoq7zODgPJS+W1P/7D/Y9qU3j6JWYku56H85cA9S3VmZWJiKUupowV/gLmOJnq3jRPFAosBXvpEls9o/ILomg/FEtz2zQ3u+KJ+isneQkhYtzZdT6c6LZbw4HwGDsmMN1CrIMXjq/nCHJ5UIqhzzMfDfr6Kdq0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 08:55:02PM +0530, Donet Tom wrote:
> 
> Hi Bharata
> 
> On 3/23/26 3:21 PM, Bharata B Rao wrote:
> > From: Gregory Price <gourry@gourry.net>
> > 
> > Tiered memory systems often require migrating multiple folios at once.
> > Currently, migrate_misplaced_folio() handles only one folio per call,
> > which is inefficient for batch operations. This patch introduces
> > migrate_misplaced_folios_batch(), a batch variant that leverages
> > migrate_pages() internally for improved performance.
> > 
> > The caller must isolate folios beforehand using
> > migrate_misplaced_folio_prepare(). On return, the folio list will be
> > empty regardless of success or failure.
> > 
> > This function will be used by pghot kmigrated thread.
> > 
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> > [Rewrote commit description]
> > Signed-off-by: Bharata B Rao <bharata@amd.com>
> > ---
> >   include/linux/migrate.h |  6 ++++++
> >   mm/migrate.c            | 48 +++++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 54 insertions(+)
> > 
> > diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> > index d5af2b7f577b..5c1e2691cec2 100644
> > --- a/include/linux/migrate.h
> > +++ b/include/linux/migrate.h
> > @@ -111,6 +111,7 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
> >   int migrate_misplaced_folio_prepare(struct folio *folio,
> >   		struct vm_area_struct *vma, int node);
> >   int migrate_misplaced_folio(struct folio *folio, int node);
> > +int migrate_misplaced_folios_batch(struct list_head *folio_list, int node);
> >   #else
> >   static inline int migrate_misplaced_folio_prepare(struct folio *folio,
> >   		struct vm_area_struct *vma, int node)
> > @@ -121,6 +122,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
> >   {
> >   	return -EAGAIN; /* can't migrate now */
> >   }
> > +static inline int migrate_misplaced_folios_batch(struct list_head *folio_list,
> > +						 int node)
> > +{
> > +	return -EAGAIN; /* can't migrate now */
> > +}
> >   #endif /* CONFIG_NUMA_BALANCING */
> >   #ifdef CONFIG_MIGRATION
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index a15184950e65..94daec0f49ef 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -2751,5 +2751,53 @@ int migrate_misplaced_folio(struct folio *folio, int node)
> >   	BUG_ON(!list_empty(&migratepages));
> >   	return nr_remaining ? -EAGAIN : 0;
> >   }
> > +
> > +/**
> > + * migrate_misplaced_folios_batch() - Batch variant of migrate_misplaced_folio
> > + * Attempts to migrate a folio list to the specified destination.
> > + * @folio_list: Isolated list of folios to be batch-migrated.
> > + * @node: The NUMA node ID to where the folios should be migrated.
> > + *
> > + * Caller is expected to have isolated the folios by calling
> > + * migrate_misplaced_folio_prepare(), which will result in an
> > + * elevated reference count on the folio. All the isolated folios
> > + * in the list must belong to the same memcg so that NUMA_PAGE_MIGRATE
> > + * stat can be attributed correctly to the memcg.
> > + *
> > + * This function will un-isolate the folios, drop the elevated reference
> > + * and remove them from the list before returning. This is called
> > + * only for batched promotion of hot pages from lower tier nodes.
> > + *
> > + * Return: 0 on success and -EAGAIN on failure or partial migration.
> > + *         On return, @folio_list will be empty regardless of success/failure.
> > + */
> > +int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
> > +{
> > +	pg_data_t *pgdat = NODE_DATA(node);
> > +	struct mem_cgroup *memcg = NULL;
> > +	unsigned int nr_succeeded = 0;
> > +	int nr_remaining;
> > +
> > +	if (!list_empty(folio_list)) {
> > 
> We seem to proceed even when the list is empty. Should we instead return
> early in that case?
> 

Well that seems utterly reasonable, yes you are right.

> > +		struct folio *first = list_first_entry(folio_list, struct folio, lru);
> > +		memcg = get_mem_cgroup_from_folio(first);
> 
> 
> I had a small question—are we ensuring that a single list contains folios
> from the same memcg?
>

It has been a long while since i originally wrote this commit.

I believe I originally wrote this I used it in the context of
folio_mark_accessed() driven promotions - trying to get some semblance
of NUMA balancing for unmapped page cache pages.

These folios got put into a task workqueue that then got processed on
the way out of the kernel.

I think I made the assumption at the time that the folios would all
belong to the same memcg - I have since learned that this almost
certainly is not the case.

That means a bulk migration may have to first process the folios into
lists by memcg before migrating them.

So this commit likely needs to be redone.

~Gregory

