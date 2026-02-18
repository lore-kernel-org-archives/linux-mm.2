Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D972E9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 10:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935186B0088; Wed, 18 Feb 2026 05:07:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E28A6B0089; Wed, 18 Feb 2026 05:07:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7907D6B008A; Wed, 18 Feb 2026 05:07:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 638C96B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:07:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03BBF1404A4
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:07:02 +0000 (UTC)
X-FDA: 84457149126.11.390E5E6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 96F3940007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:07:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zLpgTwql;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PFVAEm0s;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="taonA/ZO";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=i9QQVC+g;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771409221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfj3Algp/3uWm0tjDhm6GerGMKHAxtnoYTIF3HPKZFE=;
	b=Vskva+E+i0Qb25872lbl2KDf2kOXSOjLo/nvxqqOhS1u4upBlTDMfIS14QdnnHBq4vCbx2
	4TEYyXZR4W1a5dbMsZMw8WoWXG1g3ua+YYmccJZgLi0EOaRgcMNAvfZc73MgZ4x2JGnaoG
	0IsLoe5j4dgNctZY2DRomKWdyn/EsMM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zLpgTwql;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PFVAEm0s;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="taonA/ZO";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=i9QQVC+g;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771409221; a=rsa-sha256;
	cv=none;
	b=1b7g2lX8NETBFYwOcQlvyhhY+rPICqmmaaNek+ll0GTotBZClzjFhkF18wO5IgGCluWH5C
	U7zHZbst+61rzZXroba3d4eSdzwyIErLoab6+FYxBRAbFW0QsJt8TDMBpppj12juu32zmB
	Pqw3ntcAkWmoRAJCT8WtMee9eO/UR/Q=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DCF545BCC8;
	Wed, 18 Feb 2026 10:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771409219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cfj3Algp/3uWm0tjDhm6GerGMKHAxtnoYTIF3HPKZFE=;
	b=zLpgTwql4UyYZ9oC+ju5hwR9h3b3SQSGUrymNxyc+fw0sAR1IegVTrN4hxWH8K1nAGWQud
	3zV53zHSAoPIqzkvIEySQEAd/10rz0ZNYqjFxo6vWUOwJSUxmuYPW7NRp1d4ndY98MbA/1
	IiPY/svAWt/wakDMxcmOp9uNgWLtndc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771409219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cfj3Algp/3uWm0tjDhm6GerGMKHAxtnoYTIF3HPKZFE=;
	b=PFVAEm0svVAT1dB8hgoEnUreNxMr/Twsxi2jn+dVC7FTEuHKWN+dJIjuB1Gw1piNPfDxgU
	ufm2XWBUV+b7RyDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771409218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cfj3Algp/3uWm0tjDhm6GerGMKHAxtnoYTIF3HPKZFE=;
	b=taonA/ZO1pYwcUQXx4vtBgf9N/7MtF7wfcRTE3tjSzWQNGJAohVlLwT6FofhM101yWqLaE
	vLCV7AHsmRaxqX/RAY0uuKYAfXETMkxXOQyxFmo+BKdU4aVEu6cQur9YRDo6+7oCE9NCsX
	e9bR+IM4HAj2NTaBtqmatQJc1TAgjks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771409218;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cfj3Algp/3uWm0tjDhm6GerGMKHAxtnoYTIF3HPKZFE=;
	b=i9QQVC+gIKPpTInoSXEnwpYWaKKFnwObV0JWExLJNzLH+Wi6sWm7DZpgOOQsXwIUlrmWBL
	sR1UtXlx1W+LK6Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CAAF3EA65;
	Wed, 18 Feb 2026 10:06:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I+GyA0KPlWmUDgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 18 Feb 2026 10:06:58 +0000
Date: Wed, 18 Feb 2026 10:06:56 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: Luke Yang <luyang@redhat.com>, david@kernel.org, surenb@google.com, 
	jhladky@redhat.com, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	willy@infradead.org, vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions
 since PTE batching (cac1db8c3aad)
Message-ID: <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
 <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 96F3940007
X-Rspamd-Server: rspam02
X-Stat-Signature: wptnauougujewcwi1k5itgs7wnb931qm
X-HE-Tag: 1771409220-611573
X-HE-Meta: U2FsdGVkX18xG8M+oWSSM2Zy7yFsCnIBy0LelFtUhhvTfYKU/hF2jNDj2xklFuc7wCraDB+4k+ECSweas7eKVVgzFMicoSVGeBoN+EkjWHRNEXYjEdlc9Vmvet6bbKC+pv6dxtyzQf2mHmoLLmFEx82ZCjjNWvXdtmzTzHe030QelgsjthqelbcNrSXUJxHSbLu/+rC2Uvw1bP28sAxFK174+aPRTEIub3RlsoY+5+Xv8y86DVMeOZ9Pl3o1TQPrg64L+lvNPDzrVfhsSgE1F+20zC4JDYbyD3hD/MMAcj2nff9CTam1IAmnD2zKvxImK+HM0cYAZltPPkH1Mbx32hUIO+urwspUVHvxJIUmokpxWq/yit2D64q1j0dvFFR7JZts3wpFLCx9TcWnF3oypg4Ct7HyphK7ryZJdwYmzB88vzwG+D/cIOHa+mfVVmjyU/HwsTWFBbgobxx16bLWhUO+QFvybzAb2yYd+0LW+Z3p/mSxsyFJvl9MQvhuHo0MfS3L+x9/mBQDijh44cK2BlV3uR812GCPOzL9LHzUZAs1XGjtcMWwbemahCkSJXx50Kn2Ceq2i5CVOPLMD/LpnWXcBqtwd84lNCj8GlXcrqs3kbN8F/e/M/EMKRyIyogU1dUH6+XoiM/LEU3CCiseGhmHpD8rqxjqOgBFfORhI94UixrYeWnaaVnE7Sb3zJhiWin1nRwqJ+4utpKVmDWTYJBIkZ/ZykJe3DGRwOTG30b6ymHpddAQzPN5hgaMvuQS3BnWpvNVixojW0saEGLAsBmi5Rimek5UfYUH8cs98BzjEnCozNKy1vYMMUjZn+4gw5L7eSX/+aD8s27mKpozBkVQYNogOgqA5xcwkJ+McgjedhTkvs9TiPjPENl71W2Vr06lED3CY0r4dtI49+AbCXXS+t00c/TMz3MQmayXczuLXOJlS1x2HM9xatD0xLtGwv/T9AmjFASKDsBkQJg
 CfLraMGb
 253DCqErCBdpW2NfeEumGCnjXDI3BHIJb7jOplwt3WLgMi8JO2R/68QPqiQetJXIabHijTV8tJoD/npG3loaawT69QZs4b/Lrdc8A1W5rIAxTKB/HTwteljkD/I7Orh6Yg3lNmE/r+PcG6FB5DDCDDSqm2kF18YeAQQuZk78tqwyn9NznsFjT1fWMOFP9D3vqPzU4lbXGjJVT1g9HTwrCrl2fUk7jTJymcrQkqf+f6FgVCEWCo8OqfRDoF+kkEW61BLJf4E2HnpTXW5mhZbWdZxYI2AOwh/8ydjcnGAmPRWl6/HVdpYl3eFzJgAvzkdPRNilb++Fn68KycG3dxtNN6IRotSh6e+NLlCW/4z9Z1ioBtUhyHFjmyHj1qA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 10:31:19AM +0530, Dev Jain wrote:
> 
> On 17/02/26 11:38 pm, Pedro Falcato wrote:
> > On Tue, Feb 17, 2026 at 12:43:38PM -0500, Luke Yang wrote:
> >> On Mon, Feb 16, 2026 at 03:42:08PM +0530, Dev Jain wrote:
> >>> On 13/02/26 10:56 pm, David Hildenbrand (Arm) wrote:
> >>>> On 2/13/26 18:16, Suren Baghdasaryan wrote:
> >>>>> On Fri, Feb 13, 2026 at 4:24 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >>>>>> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
> >>>>>>> Hi!
> >>>>>>>
> >>>>>>>
> >>>>>>> Micro-benchmark results are nice. But what is the real word impact?
> >>>>>>> IOW, why
> >>>>>>> should we care?
> >>>>>> Well, mprotect is widely used in thread spawning, code JITting,
> >>>>>> and even process startup. And we don't want to pay for a feature we can't
> >>>>>> even use (on x86).
> >>>>> I agree. When I straced Android's zygote a while ago, mprotect() came
> >>>>> up #30 in the list of most frequently used syscalls and one of the
> >>>>> most used mm-related syscalls due to its use during process creation.
> >>>>> However, I don't know how often it's used on VMAs of size >=400KiB.
> >>>> See my point? :) If this is apparently so widespread then finding a real
> >>>> reproducer is likely not a problem. Otherwise it's just speculation.
> >>>>
> >>>> It would also be interesting to know whether the reproducer ran with any
> >>>> sort of mTHP enabled or not. 
> >>> Yes. Luke, can you experiment with the following microbenchmark:
> >>>
> >>> https://pastebin.com/3hNtYirT
> >>>
> >>> and see if there is an optimization for pte-mapped 2M folios, before and
> >>> after the commit?
> >>>
> >>> (set transparent_hugepages/enabled=always, hugepages-2048Kb/enabled=always)
> > Since you're testing stuff, could you please test the changes in:
> > https://github.com/heatd/linux/tree/mprotect-opt ?
> >
> > Not posting them yet since merge window, etc. Plus I think there's some
> > further optimization work we can pull off.
> >
> > With the benchmark in https://gist.github.com/heatd/25eb2edb601719d22bfb514bcf06a132
> > (compiled with g++ -O2 file.cpp -lbenchmark, needs google/benchmark) I've measured
> > about an 18% speedup between original vs with patches.
> 
> Thanks for working on this. Some comments -
> 
> 1. Rejecting batching with pte_batch_hint() means that we also don't batch 16K and 32K large
> folios on arm64, since the cont bit is on starting only at 64K. Not sure how imp this is.

I don't understand what you mean. Is ARM64 doing large folio optimization,
even when there's no special MMU support for it (the aforementioned 16K and
32K cases)? If so, perhaps it's time for a ARCH_SUPPORTS_PTE_BATCHING flag.
Though if you could provide numbers in that case it would be much appreciated.

> 2. Did you measure if there is an optimization due to just the first commit ("prefetch the next pte")?

Yes, I could measure a sizeable improvement (perhaps some 5%). I tested on
zen5 (which is a pretty beefy uarch) and the loop is so full of ~~crap~~
features that the prefetcher seems to be doing a poor job, at least per my
results.

> I actually had prefetch in mind - is it possible to do some kind of prefetch(pfn_to_page(pte_pfn(pte)))
> to optimize the call to vm_normal_folio()?

Certainly possible, but I suspect it doesn't make too much sense. You want to
avoid bringing in the cacheline if possible. In the pte's case, I know we're
probably going to look at it and modify it, and if I'm wrong it's just one
cacheline we misprefetched (though I had some parallel convos and it might
be that we need a branch there to avoid prefetching out of the PTE table).
We would like to avoid bringing in the folio cacheline at all, even if we
don't stall through some fancy prefetching or sheer CPU magic.

-- 
Pedro

