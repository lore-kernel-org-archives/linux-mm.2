Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC4C103E166
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2D86B0192; Wed, 18 Mar 2026 07:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56C2B6B0194; Wed, 18 Mar 2026 07:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434656B0195; Wed, 18 Mar 2026 07:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B55E6B0192
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:55:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEB955A01C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:55:47 +0000 (UTC)
X-FDA: 84559029534.27.D35AFA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 47BC3180009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:55:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bd8FpXyB;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773834946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrBDiAZKPy87YoJANJkvcYcuU6dFIp2F16czTKG53uQ=;
	b=Bha/cXsi/XfzerxuWNxdIPrWnXJjBCHtE3BtX0PKXlhuwoVcDQyTWvaQYPLcr98A30mfjf
	dnuo7MO8Tlr26idFUGg2W1WXiqzNEr2RmNMAuw7CAjH6sywgBmfbKMjhvl+75+y3eHlTM5
	UlrwWPfIK3ziCwE/famAEDQ2gtVTxkw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bd8FpXyB;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773834946; a=rsa-sha256;
	cv=none;
	b=gMzNqQ2LBix4nkVvTDRVItXPJxct8gTCTCLAOfC0pLGfK4bQb8c/CPkKJX1qqWENnypR5R
	kZLjZNG9KkaV9l6ob494EDigoDapdjrgHjVevkhu+Z8vPb0DW70bgh4X6w37dO4FcGIHrJ
	jSrX7rDXYU2xxDLOYlNBAuQFm//Hg7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A1BFF60053;
	Wed, 18 Mar 2026 11:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9016C19421;
	Wed, 18 Mar 2026 11:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773834945;
	bh=bpccDuS6OLTp8o1NwaEwGiI7WGiKxLq+rged8ze6+KM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bd8FpXyBrIGAVDD+7UEAwyGSFXaMeO9Ubxc5dc2TijU5DljuY69dYoF0K0oHB35ee
	 FBeI8fpbd355KkrEUNjB7XnTAi+Zh121TBfwp1S1cBRPN+qo678evIrOIm/s2cXvtF
	 RXJbKG7pCCTdHfjNfZzt4wz5fBid1TpOteNZlrJAgVSO639qw5gW/uYAvCIddbo6za
	 V99s08wo0UtWM8nvFXzoYKiigirfBEQNsZagCv6IlOPhSps0NZz2T8bV7exWZc1eQM
	 WScNEWMcHvLswh3NQvqglZ3qqi/U5fpkK/AsODfW+xj3WSeEEXcgvrwXwkc6Kh9f5o
	 wedCPqF21sgeg==
Date: Wed, 18 Mar 2026 11:55:42 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, riel@surriel.com, vbabka@kernel.org, 
	Sasha Levin <sashal@kernel.org>
Subject: Re: [BUG] WARNING in unlink_anon_vmas()
Message-ID: <b4e59cb0-c57c-472e-a70c-10ac450f4a6f@lucifer.local>
References: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
 <12501051-98d4-479a-8f10-547b2c08ad59@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12501051-98d4-479a-8f10-547b2c08ad59@lucifer.local>
X-Rspamd-Queue-Id: 47BC3180009
X-Stat-Signature: 6ripmnc1i9upk43913hx9hue4qoj43t4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773834946-114152
X-HE-Meta: U2FsdGVkX1/jiDRoeb2TdH7o3hGTZjPwthOF8kzOd904t+uQQJlXT+2uu0qP+D3pQROA/q4inCjopDGYnJ0jckmGOKswbovetTkxO8VPA3qr4HE/7zKqkww0lp03q8aEWzqFKbbAFHLQAiRj7DRdalOQMWVypEjIPCNI0352gxMTctK+shoGavuwEEPO8exml+qiYcZGDBtwyrUENJpTOkHRkKmVe0+qjHtBYgOK9r1n6Dqf/qU0TzfuibWefgsCYdoDNBctwKuIpGCzcgaa6nLjyh5zBUJTaN/V17R3QSDaZyiWSj4U/kXA9SNA2ofEA0Py4ptt23vRfSeeAlPNT3dmErxFvk+84pyESRbrFq7sbZ93zlUNDJyIlhthxFcms9u11gunK+Y/zyq0tXww2wy9/AkjILfU3RYevFmv24bR6Q5zxO+SJDdmjWmbH8Z9Gpl0xMrf6B6sgCtRmis9v/5hM9AgxXZelyGJJ3WvAjxrwBy1xx1D4lSQqO2gbMdZPM6JuTk7CNi2B+tTleaO1XC5dbatf4hVaPF5CeXv13q6HIYPCQNr5I5JzSuhWvNERgBErCR7sSUSLOnw9iBfYDZ/ePeidfTc5pp2ySCkE+umeQUqd6kMl1qyHXbH9lr2RsZB6Ap/X2oBToTPuluU4yWU2J/Nigz+8KN4NqG02aOBXdbJ1uDRHxXXJblpLUVRUoR9nHQpMUexjjGTSL+P1V5asC36tRgnQmxtBDXXXSLBgC86q7ojZ3G06fvlE/mmIY0ZJpjxAXU3GZFKQNUgbvmwPk3S2+HdU3qfFNkTxFTWaSOK4rwEYl2NIorVYiz6+0gjY2S/lGvyQ00gXOfrmThiJSMDTxxcZ0elJydO2KCVbN1zhIomvq+RYZh0mWsVtT//Io1qyKKMc+CGIyJTE1fivmQtAu4rEZIT46l4uz38UlS6vav2zjSSoAvclMmewfKJbiiLvY0CPWmFpKD
 2wUdjSBe
 QROALXHh1uaPs+UL2M37Pim1xQokGz0/7Eo93mego3FFBetEMQc82Kps9qhRWYcG39fidH6TnqoqRwe7OoA6Ksnyqcq2zs0G8U+1KEieE+wK9DvTkv/d8WNT9o0G6ZLo/YKmjZD7L77d33BYDlySUAMJp7AbxZmSyWQfOq3XpuZMKaps6iqo2qboHp4UObvkd9XzxxRBxL97gwotkMOrXuP2GWig8kn0Q/wlgHUAU+obO3we3DmxpLcSG6cNWFx1LQ+V1YeXumv/qhtzUNHQrA7j9/6csG5jtE7w/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Sasha

On Wed, Mar 18, 2026 at 10:59:33AM +0000, Lorenzo Stoakes (Oracle) wrote:
> (-cc old email)
>
> On Wed, Mar 18, 2026 at 06:42:49PM +0800, Jiakai Xu wrote:
> > Hi all,
> >
> > While fuzzing the KVM subsystem on RISC-V, I stumbled upon a kernel WARNING
> > that triggers in unlink_anon_vmas().
>
> Thanks!
>
> Will have a look at this.
>
> >
> >  WARNING: mm/rmap.c:528 at unlink_anon_vmas+0x562/0x768 mm/rmap.c:528
> >  unlink_anon_vmas+0x562/0x768 mm/rmap.c:528
>
> Assuming there's not some big mismatch with kernel versions this is:
>
> VM_WARN_ON(anon_vma->num_active_vmas);

OK so this _was_ reported by Sasha (via an AI assessment), but it completely
dropped off my radar sorry about that!

https://lore.kernel.org/linux-mm/20260302151547.2389070-1-sashal@kernel.org/

I want to fix this a slightly different way though.

SO what's happening is in dup_anon_vma() we do:

static int dup_anon_vma(struct vm_area_struct *dst,
			struct vm_area_struct *src, struct vm_area_struct **dup)
{
	...

		dst->anon_vma = src->anon_vma;
		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
		if (ret)
			return ret; <-- fault injection error here

		*dup = dst;         <-- NOT set

	...
}

Then:

int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
		   enum vma_operation operation)
{
	...

	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
		avc = anon_vma_chain_alloc(GFP_KERNEL);  <-- FAULT INJECTED HERE
		if (!avc)
			goto enomem_failure;             <-- so we do this

		anon_vma_chain_assign(dst, avc, pavc->anon_vma);
	}

	...

	if (operation != VMA_OP_FORK)
		dst->anon_vma->num_active_vmas++;        <-- does NOT get run

	...

 enomem_failure:
	cleanup_partial_anon_vmas(dst);
	return -ENOMEM;
}

We only clear down the partially allocated anon_vma_chain objects:

static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
{
	struct anon_vma_chain *avc, *next;

	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
		list_del(&avc->same_vma);
		anon_vma_chain_free(avc);
	}
}

But, crucially, dst->anon_vma is LEFT IN PLACE.

So on process exit, we call into unlink_anon_vmas() for that VMA:

void unlink_anon_vmas(struct vm_area_struct *vma)
{
	...
	struct anon_vma *active_anon_vma = vma->anon_vma; <-- is SET

	...

	/* Unfaulted is a no-op. */
	if (!active_anon_vma) {                           <-- is not called
		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
		return;
	}

	...

	active_anon_vma->num_active_vmas--;               <-- Incorrect (*)

	...

	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
		...

		VM_WARN_ON(anon_vma->num_active_vmas);    <-- triggers
		put_anon_vma(anon_vma);

		...
	}
}

* If anon_vma->num_active_vmas was 0, it underflows, but otherwise it'll get
  decrement one time too many, and so will _eventually underflow_ guaranteed and
  trigger the bug for for VMAs associated with this anon_vma.

The fix is to set vma->anon_vma = NULL in this situation, which I think is best
done in the cleanup code as I said at
https://lore.kernel.org/linux-mm/a709c736-fd76-4bc9-a1d2-e1351742b321@lucifer.local/
but then... didn't do as it dropped off my radar (oops!)

Will send a fix + cc, attribute Reported-by etc., thanks very much for reporting
this Jiakai, was very useful!

Cheers, Lorenzo

