Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF1BCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC88A6B0005; Thu, 28 May 2026 04:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52426B0093; Thu, 28 May 2026 04:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1AA6B0096; Thu, 28 May 2026 04:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B78B6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:15:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B0E714075B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:15:03 +0000 (UTC)
X-FDA: 84816118086.22.FBB0D9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B6989140005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:15:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vrn7sjU8;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779956101; a=rsa-sha256;
	cv=none;
	b=tACbtRsHB9wJ5kYA2LOH4TY4OzexRvgxoUfphIE1boRSXZGI6hz8n3FcMAR64LFcKkE6Cs
	nPV+IUbqnJ6rH6uh25WHIisk/UlpgaCKRGLhOVPWXxrYP+OsGXWJF0ySDpDKtyNWNH2ehF
	46IIHc79DvDioXSRLUww7VhwDEA6DMw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vrn7sjU8;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779956101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6nhRcxWI3QvMmb/a9I27Blh4TlqlFHzUdwx6Eh9u8c=;
	b=H/1pZvxEbNP3VqW3AdGL/TlAQV0SS+H6xccLwpELhIIHhvYIzrR5OPGBFj8VKs8dWaNgYc
	EybjCkaVxNpcAErktp5CPl4PBVJkdBwngRQKdExj1OmkItr8jfrTQA6e0+unD+t87DH/nn
	+2WYCHn2XimG33a/zBe0OOnqM0y+rgg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF91C605D5;
	Thu, 28 May 2026 08:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E6D1F000E9;
	Thu, 28 May 2026 08:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779956100;
	bh=G6nhRcxWI3QvMmb/a9I27Blh4TlqlFHzUdwx6Eh9u8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vrn7sjU8PwtWgLSTKUb/ONKyECnR73JdOuVnaTtJGBeZFHG4ofRHbi9w0vD5a6Nr9
	 FuhXoVOSIbkG7o+NFwgC6CQrXzkQlT6vF+Le8gd80vjFGA/AnszJgGUrnobIcv8bka
	 hGzceJvfLLbFkl9ss3BJNg3dsNw+77mSYR0sKcwwk0M+dQGpFihyaDmuCCwyXD78mK
	 3muxnfDMAau6vM6GjDKDrIwIwIZh2YmcAEFsDcCTURhV7aFYqL3Q2vGdy1hFu8reXF
	 9KeqBNiWOsETUM+k5ePUEAosh8SlaFi0R46YE7WqboSOy2Dr3IBBcRhaEQvDEd4knH
	 GVJPOfRZOG3eg==
Date: Thu, 28 May 2026 09:14:44 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: wangtao <tao.wangtao@honor.com>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>, 
	"xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com" <dvander@google.com>, 
	zhangji <zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahf2mJg9OOWvu0jA@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B6989140005
X-Stat-Signature: 67nn1kuacrjcgzjdmmodz8mmhzp638m4
X-HE-Tag: 1779956101-881817
X-HE-Meta: U2FsdGVkX1+bbyzBUe1QmEfl352SG026JaFJe3XSEGXHtG6sZJtxvEL045rw3RpUuPTvcVbrPqgc4bkJ86NGcZOEPfgijUtxzEK7p4sPmGbdDa/kbKPOb90t0e8NsCBgFo2gNrIZHl+ZQopqUMlgHRpjq4eSstli/FOjza6UNl3Ah/tlO628WZp8AZni+b4eETTRPeIojPsb4jVRytmJCokcBwNGvYg4AxPc0uKd3ejImGUgreKR2LJQzg9YbbSd0d81lB0NK0eg7ShYoHa4SxUnA1uLdYmEPUv42qOsDm89uY5w3YV8YAloG2wJqBSOfapvHPzvM5QbWw1BGEB/zpUdcwk4/38rJXI3CyBEoUWU0ZFPfgDPY2ybDd5gtPFl+DyrI5DUEY5Wti0Se5WoshYNAm2oTxhjlFoIDl7bSQ1tDxNlcAIa9BoC3xYdOEl+9/U5TI+o/EhZQvC1ZpLrMJ4W4sn7OM55//z0bw5Zqxqh3u0iVygu1O2lNa/iTsNiVHElbWkZ/wGSc9iNqKKDbSVthqxIK3czYgNMLYfvD00hDUwdRw9FRSVuFxaNgQaLYLTUpOH8t/wkcrppjZsbdhFMr1svLXfosopVqxeLlUk+M/iucl3NQv9mOhv5s36tsI2jIliHc2dtER99QUWCIZAPgepGhciLZ2RKhEZnU9tk49Oy2+RHOwtHdtHK/ocxs2wjuz6TfZ/29Un2U/qOCr8RE/NtBAhAOcqZK5+l5KErA3BHWkHCVOQSjiUUvT3qS9p4VT+D1BWTIYoxOiyJrjyvHL86SvQSTzRnLYpyUpZW6fjN1h30VjlCccc5qGLdfNF308H5W7mX9OHeHpF7HSofgxJx5zdJWGFH5nd66re3NVFvYHYGdyqV/Hl9W+J8mbVZuPM9syfDO8dVd+lVQKqEB5T3soHcLB69EPA78kOfaS6gKedsCNzBqBvI6Joc9eI739MlB2TLufmfWjk
 fC1m0vo5
 i3imHE6e68pYj83e768aivwOH1A6jMVGy+KjlmfpHWwI7u4JFrOhG+/La2/vSaKlmhwRNpbacmZ+knd1WoTcCo40JAUweefR9DmR8eZdDWD5HWbCCTw11CPKACgeMrQa6HjP7Q1D9fDSmcnK3BrTlupYgST9vTaGjdFGr5n5K0xtBkLQYZW5lJZC+N55yWsNVa7AI9wFLKLNQRAY3odNzOelcjz25wFnIfnUxyPcybkA2D/OyYVhKvIKqc/Zb+ZxRLX0qMrOU+eDHvKa/omZAnR33eJ+hty+cK3x6IWRL3LupTfJ0e7xwf7LQUoFDOPeD81O/fAL6n3ajqayAdOOF1U94bP1PZ1hkS6zJg+QgsTfI5ZvoNFzIX7oM6ELFTBlBq6+RUDGD0aSNgWyKH5g6EBrylDL1VtySPI9W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 07:57:31AM +0000, wangtao wrote:
> > Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred
> > anon_vma creation
> >
> > OK I've had a look through more thoroughly now and:
> >
> > NAK and NAK any approach like this.
> >
> >
> > Not only is this structurally all wrong, it does some insane stuff (pinning
> > VMAs - no), the RCU usage is highly dubious and I suspect you've completely
> > broken the anon rmap for things like migration, or have at least added very
> > dubious edge cases.
> >
> > You've added insane complexity, and also have failed to add even
> > perfunctory tests, which is also totally unacceptable.
> >
> > The implementation is wrong, and the approach is wrong - we do not want to
> > extend or build on anon_vma. So this is unmergeable, or any approach like it.
> >
> > I also, unfortunately, strongly suspect AI here. The turn of phrase, and poor
> > commit messages, you doing this out of nowhere with absolutely no rmap
> > experience before, your total lack of communication before.
> >
> > Claude puts the probability of heavy AI usage at 85-90%, and I'm pretty
> > convinced. Either way it's utterly unmergeable but that you (likely) used AI to
> > generate this much work for us makes me actually pretty annoyed.
> >
> > As a result, I would strongly suggest you no longer submit patches for the
> > reverse mapping part of mm, as there is now a real lack of trust.
> >
> > If you wish to rebuild that, I suggest you _discuss_ concepts and ideas, e.g.
> > send stuff on-list with a [DISCUSSION] tag, and engage with the community,
> > and go from there.
> >
> > It's also important to synchronise - I'm working on an anon rmap replacement
> > that I'm more than happy to discuss with you or anybody else which should
> > achieve the same numbers in an architecturally sound way.
> >
> > You going off and, in a vacuum, generating a bunch of code with an
> > unacceptable approach is not a civil way of engaging nor is it a good use of
> > your time, or maintainer time looking at it.
> >
> > Thanks, Lorenzo
>
> Your email is very unfriendly. I hope you can point out the specific
> problems so we can discuss how to solve them.

I already did, you've not responded to any of them, and I'm simply not
spending any more time on this.

The series is totally unmergeable, please do not make further rmap
submissions.

>
> I am not good at English and need to use AI to translate commit
> messages and comments. This reply email is also translated with AI.
> However, the code is written by me. I do not know which AI you are
> referring to, but the AI tools I use currently cannot effectively
> write kernel code.
>

We're fine with using AI for language, or in general as long as there's a
clear understanding of what's being submitted.

However I'm very unconvinced that this series wasn't generated.

You have 2 patches in the kernel for the entirety of 2026. One in bluetooth
and one in the scheduler.

Prior to that you have patches from 2018 in device tree drivers.

You have exactly 0 contributions to mm.

Out of nowhere this year you have a big series for DMA, this series for
anon_vma, having done no work or any contributions to rmap, let alone one
of the trickiest and most complicated areas of mm.

You have a total of 39 mails on the linux-mm mailing list.

Suddenly doing a giant bit of work like this using code that looks entirely
like it's AI-generated, and which after assessment by AI gives an 85-90%
probability of AI generation is really suspicious.

Now, if I'm mistaken, and you have a different name/email/identity I missed
with many mm contributes - I will eat my words here (the series is still
unmergeable either way though).

So sorry, there's simply no trust and as a maintainer of rmap again I must
strongly suggest that you no longer submit patches for this part of the
kernel.

If you wish to build trust up again, begin with discussions, and maybe try
some smaller patches in mm to demonstrate that you're genuinely acting in
good faith?

Thanks, Lorenzo

