Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF0E0E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338126B0088; Wed, 18 Feb 2026 06:52:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5F96B0089; Wed, 18 Feb 2026 06:52:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C73F6B008A; Wed, 18 Feb 2026 06:52:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 093426B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:52:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 983A38BDC2
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:52:26 +0000 (UTC)
X-FDA: 84457414692.24.438249B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 77C781A000C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:52:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771415544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L+1zMKnJ/+Jf0pFnKCv6/SHkSoFGwCSs/8FkKjIROcg=;
	b=X0yfB9U6WxvsOinlUUIM0mPTCz4c2gBNCEDCNiaChHD++IJe3P3WO4Qfx4Vg3ctFSQWhnq
	vmgfTDwsw6RwBDFk23pdGdalhRwjj4GDJ1jEEzkUBEtcdEnL/19lBE1kBNMA/0vucZVIxZ
	5slxtiPvPlFBn4IP5plesWD5bLOQPJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771415544; a=rsa-sha256;
	cv=none;
	b=d9WswNUbCUxKYgq2DdRuQxTKpD107tnOQgoeTUp1L68MUyesco5Fzn+Q2r+KPwQQQ7R1wp
	Kmr5yCCop5/nSkdrV3Ixfn9HXVQ3+rpXPxv7EcfMAdHUCp54h2ZHlCRgsHmhg28oMEUCIg
	0AC6Ar13+COLKWsk/EZzciDNUpRDreg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 159883E6E8;
	Wed, 18 Feb 2026 11:52:23 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41E143EA65;
	Wed, 18 Feb 2026 11:52:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1uKwDPanlWn/dQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 18 Feb 2026 11:52:22 +0000
Date: Wed, 18 Feb 2026 11:52:20 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: Luke Yang <luyang@redhat.com>, david@kernel.org, surenb@google.com, 
	jhladky@redhat.com, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	willy@infradead.org, vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions
 since PTE batching (cac1db8c3aad)
Message-ID: <dabkyhc5ugwekgcajifjomxpkyh3wie42se5udblji67olsygr@oi3jf3bwfrjq>
References: <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
 <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
 <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
 <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Stat-Signature: 9hku8i3agjdcewufi1oujbrthtu6tugf
X-Rspamd-Queue-Id: 77C781A000C
X-Rspam-User: 
X-HE-Tag: 1771415544-438877
X-HE-Meta: U2FsdGVkX1+bm5lOuNwlX1DBKR+31/GqislRiarmVdBSrpJ2WxIwxyixKK/ASxE7TfhQqdPreS4m54259CyhgeJ+voqLeCWHtFs4xqJkA43uHdceLlGjlbTVm/6Oj3eo86hNCvX0d0VCBMeZzpuRf9ksTJiBU9S34DZscKc1F5M0EiecY3/kjUhez43qh9JNrGHVYdKgLiIrrxk2r1Mm5B5f0SI5eQFUuKFzTBzjddN3Mj9xRgyNDrhuz+kxT1qKE+MdttIORKH4QwHgwlEZCzHGp/Vi8gnHXGDuGwhGPft/NAWJ16V3oRuCaNWPhPUKAZ/LbedeyvP4F/Od3zIciwBBGBlXDY3Nf2qwvOM9FJiKbaiB4RWzyLTmtp//7b5QaapMLTSmJCWeqsa+q3Z1p00qYIJm3/iqU3AyOcSNh8hFCchtmo/v53LQZMoMeGcNIA7hzWoyzMoB5EG6t65/s6/47HS/mdpVxkW8XymuGlqF6HpI1iDwUZrClH5pDGFlV60hpv5fOxwcelAWJQmkFYYwOwpivBJv560IKAFXp2k6tRIQDgs+LED6KBFVIMQZet1Cp5+nmcaLY3dGUftrew12gN7smUGzDjoEJW4ykoitaCqw2JnPBn5BIcNedjGXX4g2PEtQt2nEuuTFT3idmz6XkOaJtWSGhDjS/8HeBtTku3ItObt3BT9YofcA6sfDy6X/Gf7trrGu5ZSNQxyI9Tt6FtI4DxgXIxY67v0+Eh26xM6aI6pdIi/wyCToShZutEga4juzzKyAZERgQ59mECZyvdubmnyq9wL1uj+fUfmiqkXmkUfD46APpd27UZAjcVFHZIfxbRg8C1jpBxpoxhfDUAreToVG/W7FhZ0Lls8SdOS6s7DX5p794Ac+f7T70NIQ/EtFtWY+17zTmdRQcqFy176sB78bjpVUjjPU2JjinyOgPiRjJ6X2MhArr4sUm7a98qcgikKUmyaA9+8
 FfyOQMTL
 E/E/TLm2QJx9JjYsMhEOxmdNVNE4NlqiqFrZbA+OopCc2jO8d2AEIjCE8oG1DVPepDuFkU2cvo3WRg0wUX0kQr6I9Hc8pyXMPLxSh7fv7zG1SMZcA2KSVzH385Df2Bed5eazHgjdToQC9hc2kWnQ2M5BkqEHRT5jBX2Lmkm0aMvUe33o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 04:08:11PM +0530, Dev Jain wrote:
> 
> There are two things at play here:
> 
> 1. All arches are expected to benefit from pte batching on large folios, because
> of doing similar operations together in one shot. For code paths except mprotect
> and mremap, that benefit is far more clear due to:
> 
> a) batching across atomic operations etc. For example, see copy_present_ptes -> folio_ref_add.
>    Instead of bumping the reference by 1 nr times, we bump it by nr in one shot.
> 
> b) vm_normal_folio was already being invoked. So, all in all the only new overhead
>    we introduce is of folio_pte_batch(_flags). In fact, since we already have the
>    folio, I recall that we even just special case the large folio case, out from
>    the small folio case. Thus 4K folio processing will have no overhead.
> 
> 2. Due to the requirements of contpte, ptep_get() on arm64 needs to fetch a/d bits
> across a cont block. Thus, for each ptep_get, it does 16 pte accesses. To avoid this,
> it becomes critical to batch on arm64.
>

Understood.
 
> 
> >
> >> 2. Did you measure if there is an optimization due to just the first commit ("prefetch the next pte")?
> > Yes, I could measure a sizeable improvement (perhaps some 5%). I tested on
> > zen5 (which is a pretty beefy uarch) and the loop is so full of ~~crap~~
> > features that the prefetcher seems to be doing a poor job, at least per my
> > results.
> 
> Nice.
> 
> >
> >> I actually had prefetch in mind - is it possible to do some kind of prefetch(pfn_to_page(pte_pfn(pte)))
> >> to optimize the call to vm_normal_folio()?
> > Certainly possible, but I suspect it doesn't make too much sense. You want to
> > avoid bringing in the cacheline if possible. In the pte's case, I know we're
> > probably going to look at it and modify it, and if I'm wrong it's just one
> > cacheline we misprefetched (though I had some parallel convos and it might
> > be that we need a branch there to avoid prefetching out of the PTE table).
> > We would like to avoid bringing in the folio cacheline at all, even if we
> > don't stall through some fancy prefetching or sheer CPU magic.
> 
> I dunno, need other opinions.
> 
> The question here becomes that - should we prefer performance on 4K folios or
> large folios? As Luke reports in the other email, the benefit on pte-mapped-thp
> was staggering.

We want order-0 folios to be as performant as we can, since they are the
bulk of all folios in an mTHP-less system (especially anon folios, I know the
page cache is a little more complex these days).

> 
> I believe that if the sysadmin is enabling CONFIG_TRANSPARENT_HUGEPAGE, they know
> that the kernel will contain code which incorporates this fact that it will see
> large folios. So, is it reasonable to penalize folio order-0 case, in preference
> to folio order > 0? If yes, we can simply stop batching if !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE).

No, the sysadmin does not enable CONFIG_TRANSPARENT_HUGEPAGE. We're lucky if
the distribution knows what CONFIG_THP does. It is not reasonable, IMO, to
penalize anything.

-- 
Pedro

