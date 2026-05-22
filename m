Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46779CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 966166B00A2; Fri, 22 May 2026 11:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93DB76B00A4; Fri, 22 May 2026 11:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B1E6B00A5; Fri, 22 May 2026 11:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 796006B00A2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:39:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F22DF409F9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:39:32 +0000 (UTC)
X-FDA: 84795465384.04.422694A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57CBA4000C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:39:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i257pqtM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhXZNDewQIU/RtpMf+wfAqV2sivH+vGmM2cktxerE4U=;
	b=trfDPEsR1eiapb8ZjLM6nysReug6tl5UhpJh+Lq+hk+PryMj21zNtKwOBvNoXiDI9rcxkQ
	5gMfer+36vF57j/IEIP1xSs6daOE8+XugbmAPPQX3MceG0NufiLkjZGFBX1OOyJ4wgVmF8
	o0nrCYveM2VrB1cnvqfRsGsX9Zg+7Nk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i257pqtM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464371; a=rsa-sha256;
	cv=none;
	b=vpeyFrZNBgpK2iChQl+1APLgP/YNJjL1wZNi2i5WIYZAjV+JKahvICq9KYwfThRsSFEhMV
	g9pTh5vsNXugl58S29o7OU8cZWDLEZykK9XsXYtkXGALwea7g0fW7aqJuzRkhQQRmPLy6s
	N0G2fEhPWU9Goe9d6gTHNkry/ndH4Q0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2F5C60172;
	Fri, 22 May 2026 15:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38B41F000E9;
	Fri, 22 May 2026 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464370;
	bh=PhXZNDewQIU/RtpMf+wfAqV2sivH+vGmM2cktxerE4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i257pqtM2kYPACyD1ngfUggI4iSRxqjUdYlFKKxzVufZViVIVT2xBOEl0SpU6DInE
	 ROGVAZb/3/W0IvbwFMxor6HFcVcNrG5Q21A1mRVWwKOQBsih1iPdGeTznGeoJB3DO+
	 Fn3PvCB8+2fNVtuS/MJbVyshSkcM02OLF0I9W6ZI0pMtT9j53IMpWiV0ZX8JC6M9P/
	 FaQjM533MNXthFgpwvWbAxK8bl8eUM9XMOgr6DAoXK73ugQpZzruTM8OshFacd6BC7
	 PNNlBh7PgBgxYyU+EgAcx28busgrsz6DinxYMoEk9F2NneTnICrdURcILPdeHr1TFa
	 GSUpZYp++RtDg==
Date: Fri, 22 May 2026 16:39:20 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, kunwu.chan@gmail.com, 
	liyangouwen1@oppo.com, chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <ahB4fJkNVH2UIglX@lucifer>
References: <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <agxbq1TxJdniMQT3@lucifer>
 <CAJuCfpG2Zmpf5N_ejB6ZDv8LDjpVtTfA_tYQ6sW+Noc9Y+XhdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG2Zmpf5N_ejB6ZDv8LDjpVtTfA_tYQ6sW+Noc9Y+XhdA@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 57CBA4000C
X-Stat-Signature: kouimgispp3sc7mwamso4zmdjhmbpbm1
X-Rspam-User: 
X-HE-Tag: 1779464371-857717
X-HE-Meta: U2FsdGVkX1/r2ZP/XJBlLFXpkLXhXesAE2GxA/ein9gMxgwgbdH6Amzs6K2+vXfRFEsXX1z5dG53Lnfyp20VrO5TQipVw7gAmg5pkrMkZHEKfLklNnjKW3axu2xDZXeoPHzskVpc0WgK5rrFKxnAqxFi2IUymNz4TbZf177P3p9hJpFEihxKUqITR1hP19C2GdJXlbYMkRkmzReVOJ1oAjKp+hTE6A0OHAyniQaDDFoOmpAAhRgNfxiZ/Wl7BXara+Po2ju9V2tJS05TbaeeXxG0aftgJsHPBk9IAX4jzx8HxRop/nNWwWPt4NHLyUcDoEfjgGY5KotocypvHWLdCBC6QAvZu8y4eYnc4POOhhhTMrjNyfXlk++OA+yUJwmnpFUj4zbeTCQ66+Mjk1efIKfsZMGk+hWMdCg0KQRszxfl6vTF7N1B9LlqTsxnGMO+jMC/X24/NtXPNjU2rGeubT0yuCG2Gp6Hk06Vs563uAUxSqXBgrSnRzLRkZKi4lUJ2xG9tV4lZd0uzz9h1Rd5385KbeIhrRzuMF7bVIbxMedV1ujtnk6ZCpPnQb7s1FaQs+MlnBE7+2suf6VO5A59BUeAOaZyHD77c4CdVeP7r6EPA1WXYkNqjD+j5wxNvCzOdO8sGbnTU8dZ5DvQouFWfi/wGeQN+9KOPfPsgyhinpTk1kalYOI9nYCf/y8qpQy7vUcTI3feuhzZJsJXGSoqhjyG89dXgiGmbiM4ZSPInYO3qY0oVyFFfL65FPvdiQAttKbxd8Ri/SD3PAL0jmYTt+CNVxlgvqIMukeylnfmh5l2mUAt49MUXqHWsjoN9rlqMacKJ5xQDSsh9cuwBmif4qDa+LrBerZC8TQAXZQixrz73AyND0hkgbDa+hul3GUt9ZcP1LaoqZPTLDAcM4WnkFQOVvGLommumMToXHZo5SvNao+QlPUJ6uunACEFSM8VClb6q8ax0dnRcfDviCz
 JwqtPNEA
 TnWcpHAr4/nWz6Zz3fkG2RJkA0bJ8C/kWeANOtqZ4/9P017fpFgjGQTdu0X2niKA1XtUOeGU9W/i3iSLOB97jpLaCNfocCzVYoPjYcv26zlWPP2lT2cmoh++u6T8fpVjxrYvQ/DYjDFuxIEcdve9SEDVhwF47xoUHZRIjp5iisDQVPPOpiatiSTeZ7MHz4hfdh5ujFrt6WeBNGJAuplsBqdtDTELH7Vsir1FYhATOlwxAUMRhu9kFSf/X32509zNIHoLv76tfQy0wBm0U+MFEmG59NUh91j3dVXPJ/9nM3dcRvOJGGiLjVgH8IWF9Bm4ZGYlq/QuGkrurWxunss0LNRgVvTuC+WuliWvv4b3PW1eKEmgStopbmN9xiiLCmYm+XxGCoY64lDehzTjqv6Y0CCDzZK/uwpyk4e+h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 05:51:23AM +0000, Suren Baghdasaryan wrote:
> On Tue, May 19, 2026 at 12:53 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
> >
> > > >
> > > > I think we either need to fix `fork()`, or keep the current
> > > > behavior of dropping the VMA lock before performing I/O.
> > >
> > > I see. So, this problem arises from the fact that we are changing the
> > > pagefaults requiring I/O operation to hold VMA lock...
> > > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > > is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> > > anonymous and COW VMAs only while holding mmap_write_lock, preventing
> > > any VMA modification. On the surface, that looks ok to me but I might
> > > be missing some corner cases. If nobody sees any obvious issues, I
> > > think it's worth a try.
> >
> > Not sure if you noticed but I did raise concerns ;)
>
> Sorry, I didn't realize your first comment was a conceptual objection
> to this approach of allowing page faults to race with the fork.

Ah yeah it's understandable I think there's been so many threads in this
conversation that it's easy to get lost :)

>
>
> >
> > I wonder if you've confused the fault path and fork here, as I think Barry has
> > been a little unclear on that.
> >
> > What's being suggested in this thread is to fundamentally change fork behaviour
> > so it's different from the entire history of the kernel (or - presumably - at
> > least recent history :) and permit concurrent page faults to occur on a forking
> > process.
> >
> > I absolutely object to this for being pretty crazy. I mean I'm not sure we
> > really want to be simultaneously modifying page tables while invoking
> > copy_page_range()? No?
> >
> > OK you cover anon and MAP_PRIVATE file-backed but hang on there's
> > VM_COPY_ON_FORK too.. so PFN mapped, mixed map and (the accursed) UFFD W/P as
> > well as possibly-guard region containing VMAs now can have page tables raced.
>
> Ugh, yeah, I realize now this is a minefield. Resolving all possible
> races there would not be trivial and might introduce other performance
> issues.

Yeah, it's dangerous waters :)

>
> >
> > That's not to mention anything else that relies on serialisation here (this
> > would be changing how forking has been done in general) that we may or may not
> > know about.
> >
> > The risk level is high, for what amounts to a hack to work around the fault
> > issue.
> >
> > I suggest that if we have a problem with the fault path, let's look at the fault
> > path :)
> >
> > So yeah I'm very opposed to this unless I'm somehow horribly mistaken here or a
> > very convincing argument is made.
>
> So, current approach of dropping locks during I/O sounds like still
> the best solution.

Yeah _of those proposed_ I think importantly. This doesn't mean there aren't
other potential solutions.

Thanks, Lorenzo

>
> >
> >
> > >
> > >
> > >
> > >
> > > >
> > > > >
> > > > > I'd also like to get Suren's input, however.
> > > >
> > > > Yes. of course.
> > > >
> > > > >
> > > > > Thanks, Lorenzo
> > > >
> > > > Best Regards
> > > > Barry
> >
> > Cheers, Lorenzo

