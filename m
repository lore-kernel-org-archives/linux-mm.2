Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9840C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28296B0088; Fri, 18 Sep 2026 12:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9946B008A; Fri, 18 Sep 2026 12:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDB26B008C; Fri, 18 Sep 2026 12:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5EC16B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:19:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A914A0724
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:19:46 +0000 (UTC)
X-FDA: 85227393972.17.7ECD66B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B608C180008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:19:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRTLOrJl;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789748384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTzKtvsupp1mqkbq3aYx9lBsTuNoskZZ1du0FOb6ZD0=;
	b=VjqtW4PX9MUZ1vVHrk7Fc/gQPMvwd8byLEE0bF4cI0iU+R9MygaOryoeK08pQe8M+7p6Ja
	f8T+D2ewPtS8Of0KpWBSH9UyJwxaO3LpZe3zkGF7LIKqCX0wApCE91L05GJ+emiBpZu3jy
	u+L/+7vwvLMjY3EsI42bG3+iaJ8iGjQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789748384;
	b=BwRjWOR079HihjqOy2AhnAdejG9tSsmD8Ht6CEEU+2peQ3+EgPJhwg/XuN4YFnyKfBOG/Y
	EiO4k8buwQ3VQXyMyJkeZdjeJwPl4NZ0Swq3MglhIDm1zITPsyolhTdvrx11aXm6cC9iLn
	RAIOxyPEduDTXnLrY6b0Del653SsXTY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRTLOrJl;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A030243B77;
	Fri, 18 Sep 2026 16:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BE51F000FF;
	Fri, 18 Sep 2026 16:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789748383;
	bh=iTzKtvsupp1mqkbq3aYx9lBsTuNoskZZ1du0FOb6ZD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LRTLOrJl6uBkAckvGJa7Q4j8QM9MnDxTzeT7vFUfu8aroSxv3ViUGjmgkYRofm84f
	 Od7WiIFsiMv0WQgGaDj4J4nOCA9FqMmmrF7aII+f1AZl2O9RW9S+lyNcykBQR61ZJJ
	 /eSXUDKLxADfTT8qU5sko7xeqauJh00+bDDVJgHGwhy/nPra9WXAYryAdNtb3yG+n2
	 q4mqQMsrvOw4n4kvMCkvLX305pUTBpTJd0R8DStQOsS8wHTsEgQdlz+PCV/6htpRup
	 sqiN9itGDS1BIKyURs+74BH3+JcsTnCSlQyIhqUCTqlKi1QjRZA+ebPu2mBTCnfZf9
	 W4//WayV+N/NA==
Date: Fri, 18 Sep 2026 17:19:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de, 
	hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] sched/numa: scan read-only file mappings in
 tiering mode
Message-ID: <aq1inYWiNWtZlyoo@gremlin>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-4-gourry@gourry.net>
 <0ed3ab3a-80b4-492f-867a-0584441722a9@kernel.org>
 <aq1Cwh9hNw4wWEUP@gourry-fedora-PF4VCD3F>
 <c445a20c-ae83-4571-ae97-031ce7facc45@kernel.org>
 <aq1FDhy00epXXtgd@gremlin>
 <aq1ZUTgLQfLBxn80@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1ZUTgLQfLBxn80@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B608C180008
X-Stat-Signature: jx46optn1xr7b7t8mcbj43cadaitzqsz
X-Rspam-User: 
X-HE-Tag: 1789748384-806068
X-HE-Meta: U2FsdGVkX18SiIkktqcMHBrmkL3hvELWWG37HDC4aVK0tu4D0dkFuP8wHkSnHGewu6GG0Nb+h8pjUqwHD8lX2Rm+w9gCWm3mIpwvZZshdHKPQcQzRi6aT8GV0wfc9UmPMiYePnRz6NU53fs8qlZY/XtwMIebH3j76Br/vvmNzN8WKPpovVM7UmQhxWSTtwL3Ro3IBTvPiOdiCPKjt+JH/+IFeYIFNyZt+7eyPZX6Z2xPYPrGLr4ffLsTGj5t6Qouv6h5S+ZSB6E5o3NMip0xw0//kJioECtCf0zgL1RUkELumNonUcqdWDhR+kg/PBaOwlQQHH8T/4Pk1l+UM1/yfXN7gDeK2piOOutWu/wot6zUz1V1RbQ4FZ68/Fr4ehdFQPuhqFgsbNlN34cPTFb2gjrqb64PsHBR01A05n9Nw1QYtkaHFMUCre1gh+iXub7EG4+kc5GF3jpWIeZb5g1TNl+8aI0Mq9XnkBOMGbFX/kuxUXuEwgwP1WRucusi+ZLVRnxX9Fvw/nkTLKPPW4uoqvsIqx8pSQDtdJFo4luYXrEA1Llj1hjzmAEKa42TO9lhMAOskOitWKNThmaKSP1QykNN4Sv0qUCZqd+o0AeUULTeuDq2LoTXesuY8fflbMEFvFAlbOAcuGEunULGLpkERsAUiVv3vTyQJWpkcj/is7ovWQDqZNFdy4RYCneIpGUFAQ6OSu9nYSe3bRzVpHImckbT3O6cxt+K8Tx0mmVJiuuEVOWx7TU2CSwU+kjbmO+2jQ0cQ//z40lSHIxd39mqUATZ0KIErbx7V/qDTqLCCDEuulmkTbYllgZ/u+8cZFOJt2/P6nVd1RxkLKEqFvPqI5DjcP1aYvsEBso86/HiiVmKDjuCvfnUeLlngl8B5JCNT+Q/ZJ/U2N1LuuNXAiWWNuvC9DnVnTa6YMjuPTv5Rx0M+X7Inoz0zcmMFDupHa5yPXLjWzdQSY2T928pK6B
 q0k/A3+v
 JnRSTPMPkuVuQvYNlYW+fl1wnT+1YT3lQD6P33VXiKk/kKRwxGnTfliBIIhLH5CwGK/iXcF0Ba7tpMlQD0qUE4hA8CAAlaMW0j3AAytknhk0UpwoYJwBF81DHwdR+oQIvfSKsQyOrZWccEEcxTlWQOMsvYOwflSFwHw0J6KUPhhf9xNQ16Cz09sEmhbZFPVmDgkdyC8w3TqAvzTvMQsFS2aXGbfrtpigSeSI95om8f12F1iEmHb33/Yr9W2yxkWnXGc9azvz+FxRQCoKArPs0kHLITawdXnrql9nA+DqALBYDA9HFfS3Uk85ksVyfiv4PmbGFV9keAWtL/2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 11:48:03AM -0400, Gregory Price wrote:
> On Fri, Sep 18, 2026 at 03:53:26PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Sep 18, 2026 at 03:59:40PM +0200, David Hildenbrand (Arm) wrote:
> > > On 9/18/26 15:57, Gregory Price wrote:
> > > > On Fri, Sep 18, 2026 at 02:58:36PM +0200, David Hildenbrand (Arm) wrote:
> > > >>> +/*
> > > >>> + * Read-only file-backed mappings are expected to be cache replicated between
> > > >>> + * accessor nodes, so they are not worth sampling for placement.  They can
> > > >>> + * still strand on the slow tier like anything else.
> > > >>> + */
> >
> > This is the most specific description ever for such a general condition :)
> >
> > > >>> +static bool vma_is_ro_file(struct vm_area_struct *vma)
> > > >>> +{
> > > >>> +	return vma->vm_file && (vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ;
> >
> > Firstly you should use the new VMA flags API :)
> >
>
> Please, I beg of you, let us propose clean backportable fixes to handle
> the dumpster fire before we propose setting the entire dump on fire.

Nobody told me it was a hotfix...

>
> I'm not against doing all of this, but this feature is horrendously
> broken and every piece of tiering research that used it since ~6.14
> has just had its data invalidated.

As above...

>
> > But also it seems odd to check VMA_READ_BIT. You can have it cleared but
> > mmap()'ing without PROT_READ but has no material impact on mapping since
> > write implies read for everything afaik (that can have an impact on GUP
> > though).
> >
> > Also note that (well my series changes it hopefully landing for next cycle :)
> > MAP_PRIVATE-/dev/zero which is anon would satisfy this. But anyway :)
> >
> > Anyway in general then I wonder if this shouldn't be vma->vm_file &&
> > !vma_test(vma, VMA_WRITE_BIT), but then it makes me wonder about whether
> > you care if somebody can mprotect() this writable?
> >
> > In which case it'd be vma->vm_file && !vma_test(vma, VMA_MAYWRITE_BIT).
> >
>
> Right, I made no attempt at assessing the correctness the existing vma
> checks - I just moved the existing code to a helper.
>
> I greatly dislike this pattern
>   1) Fix a bug
>   2) While we're here, fix some other subtle hard to explain thing that
>      may or may not change something but certainly is unrelated to the
>      fix and might actually regress something else unexpectedly.
>
> In a single patch.

Well firstly I'm explaining why what you think you are doing isn't
necessarily what you're doing.

Your check as-written includes write-sealed memfd, MAP_PRIVATE file-backed
mappings etc. and you need to figure out if that makes sense or not...

And secondly do not talk about figh... I didn't know it was a hotfix ;)

Anyway, I'd rather you didn't introduce a VMA helper like that here please.

It's not doing what it says it's doing and it might not even be doing what
you think it's doing.

I'd:

	a. figure out whether it matters/you care/etc. about MAP_PRIVATE,
	   write-sealed memfd, etc.

	b. open-code for the hotfix with a comment.

>
> > > >>
> > > >>
> > > >> MAP_PRIVATE can easily map a read-only file with write permissions. So the
> > > >> function name is a bit misleading.
> > > >>
> > > >> This smells like a helper that should go next to other vma helpers and have
> > > >> clear semantics.
> > > >>
> > > >
> > > > No argument here.  Would like to balance improvement vs backportable
> > > > bugfix though.  I broke out the name to try to make it at least a bit
> > > > more readable.
> > >
> > > I understand, but I am not asking about much.
> >
> > It turns out I made it probably too much, or at least too many words :P
> > Sorry.
> >
>
> Can you at least propose a patch on top that adds the cleanup you
> suggest? Much of the VMA stuff is lost on me because I haven't had
> the time to sit down and consume the novel.

What, literally writing the function for you wasn't enough? ;)

I can follow up on it _myself_ if you like + you nag me to (hard to keep
track of things...) good enough? ;)

>
> ~Gregory

--
Cheers, Lorenzo

