Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A53F506D9
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94FE6B02CB; Mon, 16 Mar 2026 10:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F616B02CC; Mon, 16 Mar 2026 10:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58896B02CD; Mon, 16 Mar 2026 10:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF1086B02CB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:53:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6751F1402CA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:53:08 +0000 (UTC)
X-FDA: 84552218856.12.EF8D9E1
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6823440006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:53:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YEb2Q2zb;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773672786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOX/jhdoMMqrcOy5q3SKEFg2QJEUGhIi2FMLl0bou3c=;
	b=yJhPCawGt724ukK5eapS0+zY7AcLPsqco8cx9rgYsA564H9ApcQ0zIIEGveb7dapU4WJK2
	ZarE9hJcN0cjEwvpfJDtrsrzeN5A8munXCbtSKF6X4OF3fTjoJvk5ewCprk/ejF1g6zr5V
	JiPVjxhy1/qMuqXUj1j1KhdFKrjCBYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773672786; a=rsa-sha256;
	cv=none;
	b=qSSomnD/W4vToaU4kKb+sgi751L5uJE+jUM1XVZBp2Fom3AMUE2JU49cNMa8V7VhfEMXVh
	wRIZLZeLSU0NkJQyDvwGY/dyOF8hozsLANhYhj34IeTTAM4w4ww8sEv3qywpO3m6fh4WTP
	7lfuxkxsxJy9Z0eF+HxV6r1n8i/R/Ow=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YEb2Q2zb;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439d8df7620so3406185f8f.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773672785; x=1774277585; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lOX/jhdoMMqrcOy5q3SKEFg2QJEUGhIi2FMLl0bou3c=;
        b=YEb2Q2zbLMjclE+2kuh9XrjUjasoLKt53x9MfZzE344RcJz4VFzI8QdGKdi/K+qIz8
         od2sKSisRJKfmNoaUImER8+42CTKKHlydYKkJ2wWkRRPtDd1IFN8GhGEDsdZxY2zph9w
         Nqx9Fm2ujqo3aHJg1CcKiUq0OPf3x5/5/9SDBvKAV6bS0/Li5VP8hibaX7VIsba7zibb
         bKdDWjslWhY3Oof2uipoofktWSCnikfkhNpw8hnk0Am13mjrGduJhWokD6TLAOzFDeT+
         /lDSxPishRVhn2vA+MLSDdPyX3QWvHXXG2R5A/6BprztTArCfEWg7TL2nNuQJ888OqkI
         SYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773672785; x=1774277585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lOX/jhdoMMqrcOy5q3SKEFg2QJEUGhIi2FMLl0bou3c=;
        b=DdXvjchCp6ijVD6aeHAQpcWrVGZblspjZMjOwNNj/u7kxbTFa/ipkIhztvM9QrImZb
         01Yl8yYq9d49W3hwGSkr9l2baa2ZfhyJMFIQPBW6PwBMh1zpFNjbss+HfveKoAACdC/X
         Re4EIvk2y5Hj7gg06/hd/5sATK9JMQYIss14v6bGfzHCXvhij7yxSF9OqDKzoWi41G9n
         ElIrIQ4WaPanzTaXlHB+Psv5/OHRsOEaTq1ADwgJZeeUFE4eJvkzpkQ21eJi6Bf6CYP5
         aWsQC0aKfvij0+CYTuyuneaeuPh0cnDXpqpG4nsednpjA5S+YOBTHSFYvQZxukQLH4HW
         +I2g==
X-Forwarded-Encrypted: i=1; AJvYcCVEKfMLhEd/+tNcAlUeONrk0xfLRYWxKx1rQ4vh9k1Fiagt8n2+e/+42rR/TnoPya/xr/PRgQw7vw==@kvack.org
X-Gm-Message-State: AOJu0Yw8FwwNgcPMwF8kxrsgQ6scZLVk41eTBgL/yFKtAV9n3Z9ob9cL
	br8dPicD97ELFB4kgDraIcss0D0ZrXLS6Gn4eIgNDGZV8cWkQ8L3S5Gkzdfkfn5+Hmo=
X-Gm-Gg: ATEYQzyA+rLp1la/S3rVR/oA91HKYXoqMoDR5cxeRRC985qlebtpVjhlddfYfNKaypP
	i+yPO+c6mkHJVGNeQO1zKmsPQKNCSVGZ/SabQPCcVjxeADFr0GjQfGT4/5fK7Rfq9Ba9v6dzgE6
	BnlToc9xZJ9WBchujAKBKpgpZTmpgvK7m2s4ZDXh6uesUcN1suVIscOYQra1KDOTav9ta/I77Za
	ANpDqcp/5H7LG7JStM/khTAdAWRAtI6EwYYtegcdzY4v2Jk+OABQpznRCjq5Bl/7K/A2MUKKvPb
	nwll634vZgZAfeHp8SsRo5NahUazbuUaQZ4AOa0cByg0uI/XXpW62Vnd+efzU0UqX+Yo+Wh5I6N
	4JH/Vw9V8HCVGfz64/MeVjFigq5JsPAeHWQzT8hfRHKHzicPELSrPh35bhGuaPySwtMs/L4NFhO
	QWnV+qDQb+9ti3STCIKVdlKFfALmGr8Zk3I/Ue
X-Received: by 2002:a05:6000:4025:b0:439:bcdb:95a8 with SMTP id ffacd0b85a97d-43a04d1dc13mr22986896f8f.0.1773672784615;
        Mon, 16 Mar 2026 07:53:04 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b457cfa07sm6632244f8f.6.2026.03.16.07.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 07:53:04 -0700 (PDT)
Date: Mon, 16 Mar 2026 15:53:03 +0100
From: Michal Hocko <mhocko@suse.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Kit Dallege <xaum.io@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, corbet@lwn.net, linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm: document the OOM killer
Message-ID: <abgZTxYM9UcQ9Na3@tiehlicka>
References: <20260314152518.100194-1-xaum.io@gmail.com>
 <fbee0ca1-4de6-4182-865b-a33d9ed32ee4@lucifer.local>
 <abeyD1ZngYhkAx6g@tiehlicka>
 <31744315-bf9e-4d9a-9c25-63eef0bd2f01@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31744315-bf9e-4d9a-9c25-63eef0bd2f01@lucifer.local>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6823440006
X-Stat-Signature: 7tf1yjuez5rb34h3rxy4negtzu8nmodo
X-Rspam-User: 
X-HE-Tag: 1773672786-910456
X-HE-Meta: U2FsdGVkX19usy5dkQ8Nqx5AXkeaj5GMVWIk6ZozvL4N88zfSoPzF0tXoGwpEUOW7DXDfkOJqtEt14S+Fchyg8o+maGhHblSP4BPqZEhcIevOHK+GpqhF1NailFXqdI6/rbS4INWduXMLqJfqQC+nCsUEvJ5g6JifwMhyFNLPoF+g4l4fWHnw0GpY/5Ji0sUnYplBlyYF6FiDMTNkRZrdahbqZHnJP2OIIlt+gFbAuUTvCXh8FajU/Bv8v/u7sN57+AWiZwWTpgP04UEgfp8KWmyQAmlyknv7gT3IjCbyu/qRYqz+OjBt02Rzok39EAf+Uzp2tl4nAqQfmb0e40UyZHhHFQJt9qNSP0Pku0jJT3yciULFbPfC6HeO/6sGdljRKvborOxb4nfn7bm7CMITE8s3teE0fMhc/8ulRjnJ1DI5IuT72JGoOZ3dRlRrLv4UPq4OYHPdQoFLdJMPf0jbB893rTpWw6Upsux6KUJjfazBu0u+Vd1/UzdVSutZmV25PnrD4q13b/xRxfStyjhDdipNpYLTBw8QZcv6w6AV6tXNFAc37Omk4IPdDzlynpKJ/5WzPBU0t5cyt5BMZ5Jqi7XhcIKgEKcTUD8d/q/HTtAIjbYv2e9Kfe8U/GBBeHVD7urwydj188U+erLth4wCe3oDolfi+wm8ktaZEwL3t0SusUREbjI2KhUX0gd/AhhtwKJsUoyjviwk8a8jUYDtLL+5cREqtQzdA7DH+eTWRldFFk2x3wrP2VIenb4lJxn+wNOzE1TKP5NVqN7H01oxmugToZKEWRzhkRxTpLlww6C2AxokG4yXnqwQPWg0dyEYFYtg5fH0QBTf3Gufipi1xKEPBZ10rATtd7lvqfqZMUZ1CTJjY5bXrw8umOnTwxtyMEM3CXPVFEmue7gffViInHrxYTFQMRvas93sYgyWjqPJuAwqGBkUZif/zJZxVcWLljHj2UQNegGAIRQmS2
 WcV2OMlP
 4PKUk9ZFmS44o7PqXgt6Fg+8IKPxe8t+ZbHVSFXLSqPUFnUPnO+7JfAYlgZiK425KIsc5PeV3/tGEjPKlSXRtFB23WCoiBYHbSiwGhydE1OwxYDMjiOwN7AdwGI3W/D/z3w4KKmBjW76YbMJ8BJwWa+i3QqY1fda0FVklSJscVtEEPk6WAZp0/z64ho5C5k9bOIaSuLPUFqElOtOuMa8BsdbfW+ms/FQc3vWGBQA30vlTNHi0GpGAPY7jxz0KZ+DZdc+0tbmm2X5obJu85bkLrFIPL0cECXm/iBuTqNtVL/S4PpDdyig52EDejrzvyh98sIcu1LncEU87yZ1MUBQOo6Gq75+9BCjFpSqFYMWxWrRzB0hGkOfxaR8bHCp2ye7nq5VlddwO1wwGAbzkMRoROUVUIsKLvUAWgP3QE2u25UnvFNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-03-26 14:16:19, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 16, 2026 at 08:32:31AM +0100, Michal Hocko wrote:
> > On Sun 15-03-26 20:48:22, Lorenzo Stoakes (Oracle) wrote:
> > > NAK for being AI slop again, obviously.
> > >
> > > Again, +cc the OOM maintainer you failed to bother to look up.
> >
> > Thanks!
> 
> No problem!
> 
> >
> > > Reasons, as the rest:
> > > - Worthless documentation
> > > - Everything about patch screams 'zero effort, Claude did it all'
> > > - Bad etiquette
> > >
> > > As with all the rest it'd need to be totally rewritten and it's not worth the
> > > maintainer time.
> > >
> > > On Sat, Mar 14, 2026 at 04:25:18PM +0100, Kit Dallege wrote:
> > > > Fill in the oom.rst stub that was created in commit 481cc97349d6
> > > > ("mm,doc: Add new documentation structure") as part of the structured
> > > > memory management documentation following Mel Gorman's book outline.
> > >
> > > I mean the more I see it the more annoying it is.
> > >
> > > >
> > > > Cover the scoring heuristic, allocation constraints, OOM reaper,
> > > > process_mrelease syscall, and sysctl knobs.
> > >
> > > This sentence contains almost as much content as the patch.
> >
> > The real question is who is the expected audience of this documentation?
> > Administrators, kernel developers?
> > Reading through this proposal this doesn't really seem to fit neither
> > well. For kernel developers who try to wrap their heads around the code
> > it is barely scratches the surface. For admins it doesn't really explain
> > more than an existing documentation for tunables.
> >
> > So if there is a serious interest to make this useful kernel developers
> > oriented documentation I am more than willing to help. The code is not
> > really easy to follow as it is scattered. There are many subtle
> > expectations spread out and it is quite easy to break a delicate balance
> > tuned for through years. So there is a big documentatin gap I never got
> > around to fill up.
> 
> I mean, we definitely could do with better documentation :) Obviously I
> somewhat document it from a 'learning the code in depth' perspective in my
> book, but that's tied to v6.0, effectively paywalled (sorry!) and not the
> same as the kind of documentation we'd ideally like the kernel to expose,
> which would be less specific I thik but also up-to-date with newer kernels.
> 
> The point WRT this patch however is that really, it needs to come from
> somebody who has some experience/understanding, and generating it via an
> LLM is just not useful - any kernel developer with understanding could do
> so.

I think we are struggling with capacity here. I am willing to help shape
an existing text but will be struggling to find time to cook up that
text myself. I do mind involving LLMs are long as the content is
properly reviewed and factually correct. 

Wrt OOM, most people/developers struggle to understand these areas from
my experience
- what is the purpose of the oom killer and its limitations
- different contexts oom handles
- when is the oom killer triggered
- oom killer in progress handling and locking
- forward progress guarantee (oom_reaper)
- coordination with task exit path
- memory reserves for oom victims

I bet there is some more but these are the most prominent ones.
-- 
Michal Hocko
SUSE Labs

