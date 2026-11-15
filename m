Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 150A4606A329
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VtC39wDA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FSD3EA54;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VtC39wDA;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FSD3EA54
Received: by kanga.kvack.org (Postfix)
	id 00B866B05B4; Sun, 15 Nov 2026 17:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDF56B05B5; Sun, 15 Nov 2026 17:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13DA6B05B6; Sun, 15 Nov 2026 17:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3CC66B05B4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:00:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1510814081D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:00:47 +0000 (UTC)
X-FDA: 85438723734.22.297E34F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id EC2EC4000A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:00:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VtC39wDA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FSD3EA54;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VtC39wDA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FSD3EA54;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794780045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1q2m7iCmRu8/0QbFElHLPq1Wp6Csg/qGVcaQCf3LJU=;
	b=FWYt8KeYyLAI8gPEM4t0V8GPk/yZTteygM9OMWnUnglIjM/DJ5/RDXe/Qz+x583L1bSx54
	5ZQeGnNVaqDaTm/Np8+x6qG+KWQ8sHW6QRquzsD9ye826CepzWUEW9Q3gcx9bSpEimwoYQ
	z7IBsJVP9f7tQHjjY/ocQaid87LMQnE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794780045;
	b=1G1JnS63Ey8/HJC94Q9bHsO5+NBw0QxP9kU5rDHCB/K/IrJKtIZ9nV/xusi+CuXNZJr/1v
	S2e/C57Ao4KGmU3rnAmG+JHV/5Uok68UzThm30+9H6zbF2TLT5BUIvADoTJLiiHBJb8pKC
	nIZo7LQkoL6Fpyq8eHccEyZrtMVvEFI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VtC39wDA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FSD3EA54;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VtC39wDA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FSD3EA54;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8882F1F449;
	Sun, 15 Nov 2026 22:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u1q2m7iCmRu8/0QbFElHLPq1Wp6Csg/qGVcaQCf3LJU=;
	b=VtC39wDA1GWTGm0xox6CVDf2jVHsVvaOgt8LdKsluJlNGWsTnvwnbRNo+nszbXNH/ZPn6y
	mdlew/Jpo8f7BwJUW4HaSquuZ8yOPAoLg69ziQTIda6nEc5Eni7s2jrotzE7DBLQUWLjFQ
	AmQHK4DwrDTT5G6BDD9HFxk+aM4yeTA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u1q2m7iCmRu8/0QbFElHLPq1Wp6Csg/qGVcaQCf3LJU=;
	b=FSD3EA54NpSYVbs7Zde8pdPXSOSxZXRemtfdLIRL9+aSukEH1zgttElCb9EI88/JkNI5gh
	sHc8q8hKGbej2QAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u1q2m7iCmRu8/0QbFElHLPq1Wp6Csg/qGVcaQCf3LJU=;
	b=VtC39wDA1GWTGm0xox6CVDf2jVHsVvaOgt8LdKsluJlNGWsTnvwnbRNo+nszbXNH/ZPn6y
	mdlew/Jpo8f7BwJUW4HaSquuZ8yOPAoLg69ziQTIda6nEc5Eni7s2jrotzE7DBLQUWLjFQ
	AmQHK4DwrDTT5G6BDD9HFxk+aM4yeTA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u1q2m7iCmRu8/0QbFElHLPq1Wp6Csg/qGVcaQCf3LJU=;
	b=FSD3EA54NpSYVbs7Zde8pdPXSOSxZXRemtfdLIRL9+aSukEH1zgttElCb9EI88/JkNI5gh
	sHc8q8hKGbej2QAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9EFE134F4;
	Sun, 15 Nov 2026 22:00:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KoiGLokr+mqVcAAAD6G6ig
	(envelope-from <clopez@suse.de>); Sun, 15 Nov 2026 22:00:41 +0000
Message-ID: <1cc05b4d-e713-49e8-9bac-444259bf12f3@suse.de>
Date: Sun, 15 Nov 2026 23:00:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] mm/huge_memory: honor MM_CP_TRY_CHANGE_WRITABLE in
 change_huge_pud()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org,
 seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org,
 david@kernel.org, peterx@redhat.com, imbrenda@linux.ibm.com,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-5-clopez@suse.de> <avd0Cexmmu7kCN45@gremlin>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <avd0Cexmmu7kCN45@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -13.29
X-Spam-Level: 
X-Stat-Signature: 5hr9obh4cjme9bxauubighjmx8e5g4t6
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC2EC4000A
X-HE-Tag: 1794780044-744907
X-HE-Meta: U2FsdGVkX18L//aj4SE2r95/G9HXluSasclU1MtfSE9h3kC8mOdwETLGlHaOSQuiH8WYspp+BzwC4EHfLXEJMUThaU23dhOD6rWaaJ5jumHDO690wTgS0+w5kxmv/USBhK2IxQC/huSt2heD5ByXg/zG3B1+jGve+K+jstnYeKoJdzD4f6INIhiPBnEmXG0nQHXsGmXn292QnnyAFxzj7EuSceNMIJrE1Whuenp6ExAMe6Fy2vf7f6L26ze93/TOF0vnbRlLgHt0XzfRTj+A580bfbbisUPs4CT+T8qIcYUxv/v0uBSUzqgjY3KGOtgdHaC8PqoAA8BTvIOHY9gBiOk/aa/SIaHb65nFeT2EHZUHxtxfyttjPX3xArdrQL0NJx9VZZWx1ver9If6JycgClMvc9yVpurv/sB+49XAYEliT69sfs7U2YzC6UxRauNORfubffutYYwisL8SEVSkfIBoCX8MKC7fABTcVS8b8VPq4IPAUVx3tq1JEuoxRNcUBNVp9eRzTXoDpAu1sHNq5B5C0SgWbGsL1B8AU74lejnd3P8oPH0yG3oyYktqjDwChSKXS1qc1ipOpEjgUs82WaYozNLORgnWL5xigyafIdgewO4WvPf614eR/YzpLsk0EjxSA6frrioR+Bv5lKE5g3ZU+Q+RV5AOtFRKSet3T0rmA9gVgppHfq+iSF9ITwq2msQXubJodfwTgZLfqusfU+31KVlxR0sNvlMmklkgMfaI/1Gns2/OII69ufRIxj8Q/+aPsxTSQ2h0+Hb391YlST7GRL2BW2HBN7U54sAmHsXFDKwz9CjrR9peyWaURlHN5TstJEjJ+oR5AdpjZ0YVsz/mwiH7nKoQx/PDhFDhxv1J09UaRBE5GIN52JGtKU/3x3sAd8inR3OhhaRozGY/e6sEwI2cBCGb3ioir9dL/LSYk8ZI/SsLVWX6z8qxGI0XoyZ2R7EK3TCCe9AtidL
 H0jHQdMC
 VhLowPho8kanZ7UcqXqbI4QBL4wTMdq/vX4LEN3+yeb9BYmCdxfcWCmxZEH4IhFqavhcUTTdr1YOI4oNghmNaL0uNbTdAWi67apjjQgXnQlNFgiNqzMdumHLT/0zQM5rQBKXI5Lv1nutxdOOKKTdFmre33zop+hv9xc7kNBT+vBUHLYntAmjg2tod8cQML2kbhsFQ3bGXyfKl0YwxlPJaBcsMmg6H2xXB2fT2w/Q9qaLNpuU+8ji/MK3rtF2MngcyL+8j5O8Nu0kP1h8w8l150M/y8gi9IIWD5r/u99EoAXcAtpLQCDPL0tiFDvuQE2nZcHfY1oEm++t3J7Ol7HxNkBKMKYMfBznuBBa9BA2jTCQkALIuehNArAsZ72RKXiSkE3njuuTavCcQj29dRJDfcz4Nww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 9:48 PM, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 12, 2026 at 03:20:32PM +0100, Carlos López wrote:
>> change_protection() applies vma->vm_page_prot, which lacks the write bit
>> for CoW and write-notified mappings. MM_CP_TRY_CHANGE_WRITABLE makes
>> entries writable again if a write fault would only set the write bit.
>>
>> However, change_huge_pud() ignores the flag. For example, device DAX
>> mappings are write-notified once soft-dirty tracking is armed through
>> /proc/pid/clear_refs, and a protection change then leaves dirty PUDs
>> read-only, so the next write to each of them faults.
>>
>> Fix this by adding can_change_pud_writable(), based on
>> can_change_pmd_writable(). It omits the NUMA and uffd-wp checks, as
>> change_huge_pud() bails out on those changes.
>>
>> Signed-off-by: Carlos López <clopez@suse.de>
> 
> Is this a real problem that actual people have had?
> 
> The why of all this is still eluding me, especially for THP PUD...

Nobody reported it, but the new flag depends on it, see my reply to
David for this same patch.

>> [...]
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +static inline bool can_change_pud_writable(struct vm_area_struct *vma,
>> +					   unsigned long addr, pud_t pud)
>> +{
>> +	struct page *page;
>> +
>> +	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
>> +		return false;
>> +
>> +	/* Do we need write faults for softdirty tracking? */
>> +	if (vma_soft_dirty_enabled(vma) && !pud_soft_dirty(pud))
>> +		return false;
>> +
>> +	if (!(vma->vm_flags & VM_SHARED)) {
> 
> This is getting annoying now, you're seemingly _knowingly_ writing deprecated
> VMA flag API code on purpose.

Sorry, I based it on can_change_pmd_writable(), I'll use vma_test() instead.

