Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C0210F2855
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB4D6B008C; Fri, 27 Mar 2026 12:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092B96B0095; Fri, 27 Mar 2026 12:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11AE6B0096; Fri, 27 Mar 2026 12:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E00296B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:52:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D0F4141127
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:52:08 +0000 (UTC)
X-FDA: 84592435536.25.3211D57
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8C362100005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:52:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQdxda0V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774630326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=859ciwTLws9gTLdPiMbsS4SJ1GOzZrhoCCXtFwVU8lM=;
	b=rDW0t3Us9LGj7Yapa4xj/l3UGy3CQBgBoxD4NkdqODlWPuUls48aF1mWBUizhbBEwBEfnz
	u9GHHFIKmWMYVZ13eduKMLnNYGmS3V7ZxqOFgP8dMaS+pjKJQNfqxmxMUUUGW+1j8Y7rPv
	hWSa6k1wR5TwWMT28qQ/+4S83J3WCdg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774630326; a=rsa-sha256;
	cv=none;
	b=qy0XEe3jOwEB7BJgMLgewhOSuFCfehR5+n5CS+JgCU87ELjyMdK+wDBH+6j8GGoqI3krpG
	CU+28bMgQGQWMY1S/IkOnNMFJUo24+y2lf5znN0G3Tx7ZyRG5cAYYt2XBa1H6Ni5jShsHz
	oA8H57/GF3w9mzHmpDdyVqxvnMH/xYM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQdxda0V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
Message-ID: <09f1f982-4143-4c57-9bf6-fee546b2606b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774630314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=859ciwTLws9gTLdPiMbsS4SJ1GOzZrhoCCXtFwVU8lM=;
	b=eQdxda0VXEY8Bm/gK5z/H6o1WBS+xzZU7GDDlPJSxH272S+kvcs994vq5gP6ylP0fK8WMr
	wZ1KR8sjIN6G+BRLqc71go1CgG/LVZHt2CFRm94mVG4EXUF0oS5jnoZ0DXugjTmf62p1Ib
	6N/JEBZtBILoFe3eY8E3oEAIcUuUG20=
Date: Fri, 27 Mar 2026 12:51:47 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE
 coalescing
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz,
 ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 dev.jain@arm.com, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@kvack.org,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-4-usama.arif@linux.dev>
 <ab1uqdcMBP1cBr7Q@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ab1uqdcMBP1cBr7Q@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8C362100005
X-Stat-Signature: sjycoishabxh9rchys6rmbiku19tnuze
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774630326-33728
X-HE-Meta: U2FsdGVkX19SFVYVTxZzL72FWeG9VdNBN8NRkAC9KH6sViYiG7jNZdjpGJuTZh2c+sZo3nrG1ykArZ/5+sNk70QM2AyvGVqgrFWGKuxZnDPcNEceW/XEQfODRrKu70tqlJpluQe9LjtFV7hsvX2BJW/OhDvXsDilEF/VbWFM28cxHnmp0NXQ7gf/1pa4yt9+NPex5OUi7BRbvStLJjvICdbuDHTwMbDzqzyLF0X0NrZ4lU2oP87bfTzi0qUsL/K6R8fnjo4UPYTzR8fktegxTduzwEK4dgcDf9/41qSMosjh8kCY6W0K9f8mE/qa0wfhNrq3UROj4Om7WkSGlBL4Y4D5Zg095kt0u5AiH2d6jgdalkPkbEs1s1faY6Yi1IWAUU99WwdmBUgoiscRdngJvF8kR+ooLqboixzXhf14rWRgT9l9e1IPR4EBiuqohbfqUiG4f3cXAMrBYhNXA2VguFF/nLFDTRKdVMD7DC2X4r6vir3SN2P4QPhlI+wDfssE3sbJOd+Q2vvje42kn4kc4+WdAGSTBOTrV6xLpRsW6fRP2GkhJJYunG2Y8LUkzUN5KYtHCVCMqAFvEQhpasGJkLL6uYD2NLpq04+ybDR7iBCPlAfcJWXzzYh4AVUgGP+LpkkogvNF9frd77l57nonyRriIBRAkpFi/ArGNHVZ7sr44YneFsvv+lhSjsnzcJJ2+keuGRKX8EIBV3pB3ZH0m1Fv49DlzvY/QObW3Qj8+keaYH2+IR+Qoy9AUumVD+cE+ouLfPURVTQaGhsCiYmpEjivYS6RBb0CckJqvuq1RMeC00o1UXz4J5/t21VMPKDNS5Z5kG9Z3HLrV0iFBld8EKF1rvj53oI7RPBfbmViF8jcaRZnofzFVeQ47wbsLlgk8/PCRFugPZrFRHDrdeGLw4lBsMK92BUpv6lbLzsZ0TGxVKdUlV2Ma5vfatThNcBNPD01acdnJU4YE7tq4Pn
 qZsvm/ei
 hCemFduCwCNeXR8tFINiGaQyfl24ePoxBRa3gqe3nWa/etdCo+IdjkchZGbkxLdGvhRQPxNAAaMoXWYspDLYy3VFesH+NVNuiXKQwSp6oiAxeuzQkBK7W4ghs1irBtqJyB7BFs2axaAbwBudcGtwe3xR8cKv7ixqMs4/KXfPI2MJDQE6YAdVBknuURkRZ+4+vGHwSLO1TK+YLRXQD10VY7/lDVrEqXxompXVh14gYdq5Se5B5zdxAvLJdWOvloqj94bqPhtBS5NKK/XqI57TthIauyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20/03/2026 18:58, Matthew Wilcox wrote:
> On Fri, Mar 20, 2026 at 06:58:53AM -0700, Usama Arif wrote:
>> -static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
>> +static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr,
>> +				       struct file *filp)
>>  {
>>  	unsigned long alignment = 0;
>> +	unsigned long max_folio_size = PAGE_SIZE;
>>  	int i;
>>  
>> +	if (filp && filp->f_mapping)
>> +		max_folio_size = mapping_max_folio_size(filp->f_mapping);
> 
> Under what circumstances can bprm->file be NULL?

Yeah its unnecessary here. Its used in other places and this is never
checked, so we can remove it.

> 
> Also we tend to prefer the name "file" rather than "filp" for new code
> (yes, there's a lot of old code out there).
> 

ack. will change in next revision.

>> +
>> +			/*
>> +			 * Try to align the binary to the largest folio
>> +			 * size that the page cache supports, so the
>> +			 * hardware can coalesce PTEs (e.g. arm64
>> +			 * contpte) or use PMD mappings for large folios.
>> +			 *
>> +			 * Use the largest power-of-2 that fits within
>> +			 * the segment size, capped by what the page
>> +			 * cache will allocate. Only align when the
>> +			 * segment's virtual address and file offset are
>> +			 * already aligned to the folio size, as
>> +			 * misalignment would prevent coalescing anyway.
>> +			 *
>> +			 * The segment size check avoids reducing ASLR
>> +			 * entropy for small binaries that cannot
>> +			 * benefit.
>> +			 */
>> +			if (!cmds[i].p_filesz)
>> +				continue;
>> +			size = rounddown_pow_of_two(cmds[i].p_filesz);
>> +			size = min(size, max_folio_size);
>> +			if (size > PAGE_SIZE &&
>> +			    IS_ALIGNED(cmds[i].p_vaddr, size) &&
>> +			    IS_ALIGNED(cmds[i].p_offset, size))
>> +				alignment = max(alignment, size);
> 
> Can this not all be factored out into a different function?  Also, I
> think it was done a bit better here:
> https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc/
> 
> +	if (!IS_ALIGNED(cmd->p_vaddr | cmd->p_offset, PMD_SIZE))
> +		return false;
> 


ack, will try and address this accordingly.


Thanks for the reviews!!

