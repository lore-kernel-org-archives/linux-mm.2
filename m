Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E74B3CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 15:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4E56B0005; Sat, 30 May 2026 11:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E5B6B0088; Sat, 30 May 2026 11:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6BD6B008A; Sat, 30 May 2026 11:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC0286B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 11:16:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C5601C0BEB
	for <linux-mm@kvack.org>; Sat, 30 May 2026 15:16:34 +0000 (UTC)
X-FDA: 84824437908.03.B254BC5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1508B18000B
	for <linux-mm@kvack.org>; Sat, 30 May 2026 15:16:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qa+LcmTW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PFpj0hi2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qa+LcmTW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PFpj0hi2;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780154192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SE90/JszZ/IRjGrWEI0Bz20FnK4+6DcEq7PwC6UmGJk=;
	b=6Y2rJGckxqzWrkqQd9J0Z7nw2X4WBhCT118Ha6Qakb6OAFqf26vGydv6jqqDKtVTczb1Aa
	v+f3FTI4iu0PK29bHXoB66+kNkjeW3aViawiVDg5P1pRo1GIAF/WpDF07Sjq2G1VvnABc8
	GXWKjzuWTpl6wwPtGJpfDChfLNXN1QA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qa+LcmTW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PFpj0hi2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qa+LcmTW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PFpj0hi2;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780154192; a=rsa-sha256;
	cv=none;
	b=ecxaCGZOa0t1EBGap7DVGiREUNWvqh/x8fRQQ1VXvh2TFZeSzyQjHlxSJdhhewSnURSQWL
	hNBEA/YQXRvXL3rhmZSmoQ0V5BpOB/sO4Zy22tCC6BYOMPkf75Yep9sCYq+4b1tOJm3MIh
	2KU2u8Q3pVPp4MU+2AFCc3ZaOrAz7qs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 443A86BB03;
	Sat, 30 May 2026 15:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780154190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SE90/JszZ/IRjGrWEI0Bz20FnK4+6DcEq7PwC6UmGJk=;
	b=Qa+LcmTW0ZOv9LibRf4M14HYx6ONzmia57kRHvqcPwTd3BcxiGBEeG6TM8YKzB+RKO8H2n
	PZw8uaca7wIUEt0oSClLTTozzT8ZwSJFgeVqU2OBk5dNGZiji2PDHA1w3PVqlrLjX8ul34
	gLdIrfF0XCXJgrSiHsUxfgs9b0aFqUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780154190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SE90/JszZ/IRjGrWEI0Bz20FnK4+6DcEq7PwC6UmGJk=;
	b=PFpj0hi2yZT/rs7ItscQI1gzyO9nEwyIjbHSvtCf+NkEtx0A9KaNoFgp53A3WJWGc08WSW
	v4b6RbI4syEl2xCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780154190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SE90/JszZ/IRjGrWEI0Bz20FnK4+6DcEq7PwC6UmGJk=;
	b=Qa+LcmTW0ZOv9LibRf4M14HYx6ONzmia57kRHvqcPwTd3BcxiGBEeG6TM8YKzB+RKO8H2n
	PZw8uaca7wIUEt0oSClLTTozzT8ZwSJFgeVqU2OBk5dNGZiji2PDHA1w3PVqlrLjX8ul34
	gLdIrfF0XCXJgrSiHsUxfgs9b0aFqUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780154190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SE90/JszZ/IRjGrWEI0Bz20FnK4+6DcEq7PwC6UmGJk=;
	b=PFpj0hi2yZT/rs7ItscQI1gzyO9nEwyIjbHSvtCf+NkEtx0A9KaNoFgp53A3WJWGc08WSW
	v4b6RbI4syEl2xCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2EDC7779A7;
	Sat, 30 May 2026 15:16:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MAHOCk7/GmoTBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 15:16:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 83C05A0EBD; Sat, 30 May 2026 17:16:29 +0200 (CEST)
Date: Sat, 30 May 2026 17:16:29 +0200
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>, willy@infradead.org, jack@suse.cz, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org, 
	r@hev.cc, Andrew Donnellan <andrew+kernel@donnellan.id.au>, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org, 
	kevin.brodsky@arm.com, lance.yang@linux.dev, "Liam R. Howlett" <liam@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com, 
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
Message-ID: <u52xvwk2fjjk2izdb4wvuqq2zhc5neb4q6usimcxejluuyngxw@d64sc6rvojyp>
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
 <ahlh2vdHEGo6ZSot@pedro-suse.lan>
 <cc9a1cf7-7b96-439a-b0be-ecdcf27b5da5@linux.dev>
 <ahmSolHvUChl-3vM@pedro-suse.lan>
 <185f1caf-b33d-4467-beb5-51bd8520ac78@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <185f1caf-b33d-4467-beb5-51bd8520ac78@linux.dev>
X-Rspamd-Action: no action
X-Stat-Signature: nkwipwkwerz6whitiaxuhar19itxk7ts
X-Rspamd-Queue-Id: 1508B18000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780154191-663626
X-HE-Meta: U2FsdGVkX19w+GRNB07h4+FPXHG1IKWbH2QsP6WYhnJQtsuYJULcvBBdM19UsZzOtXSxICDlZ+VQ6VxqW0ZZBg8rb+eQ6nx4zwEzPGqQSc6uo0olVGri075L55hzpLGk/9HDlDf5OC8HXuO0sI/aP8NBQKUdBxtNnGODVhSCOhh4jaiEmmN0X3Trr0m1Qlgl1YaC3S7DARHqg6ebcXYenZIvgAikIcbNb8nyfaIoehbvfE+oqC0QUq7X3lwMbcpXI05TGhM4oCHw6mXn8AukjLPzIa7ILYk8ya2GVS+oIFSCUp4ugWXl0psZXCuNftJwwwDOuwZTEC6v2G2fkSdjXoOe/Em0jVwdCAcGLie9pOMp8DeSn+mhNtSoBX9sMBsQsDDwsNwgL0js0ZsovBuyqCob7Nj2ktGVu1s0h1p99/QjOgjhlZIp+MXJ3znFKa8guTf4S41Fp/sc94K3/flRWmeW3tXQNTh152ljTdA+D4AIfJwnUTIDvbdizyuvPV/a/OovcxJAb3LcDbRCNYDMiOk/LTB2M8OtFVk0JRIYZieIrxkmFAS8TXCjoJ8bF4DzT1z/QPCDQ5Ei1k/WwOum/q28evMz1NHHkug+aYMdrf4U5m0MbL1D3heFCZYR6pg2kKBm7v0+bYQR+6V9y8VrwTIscLL7BIL2C8XZ5ye5r64GJnOzz5S+2toSaNVeqTpGLPetBgKCOyLh41lDxAO1DdQpIoel75K4kmVLkZ07CdjvvcKEKOZTSWZ2L19LuJv6NQIaFMod0w4j8pSeg7BlpdMPYon/eRTaCv6WF82HqC6hc0dVMTmDuE/DzF+432LzKEFS60++/LL5GI+X8/92mHPZaVWr/DTnvaJDQ4UTOkiap0iP4DExQqpDHx7tm1fVJruMgB5E4knXhwE5YgWUL7eViYEforQHUxQZ58rL2AKuPJGoclSZ+pldnVeMIdgSjiFpnY03MIlQf+HWlGa
 WHpTUwhL
 VPZ503wRKgPo+oW+OV9Z/bWWV/+MdDD2NNbFfBYQ8Zu/kVzXUdjyedIEcTS9rZ8W/NXMXLCqFYyqgqczm0GcDWqnmAp8e8YGF/RzOnQwG556RjbyEBcZigfBsVpfSzN3zfuBdWC78xCQddVUL7Nm9d6VuP3+uk61NX4dK903dXTQIpnIkqfongR9wjOZPi3Iow7UBcKGtT4vznuigP5Uw2KtERMDtVnsCnGunehZgF08DtAbG5jqPultypQzXPgndrjW0UUgSaJLuw7W+WAvyo4fVZYwDGG6U6bVMB1P7YprQdBPqloxDjIZt/LwQj+KfBKBU8KqNyoQMUCCysGcmcZV6GSZjLTzToN2SvV70o0Hl+z41yYx3700N03NW5KGmFdJGcz9uzzRhWDTCZWJ9rEhjnITv1ItJVgvgADl8yNEV1VoGzbHYwPLat5PlctWjbBNhvxE8opc/Zpf/DW7bs1/kbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 29-05-26 15:11:54, Usama Arif wrote:
> On 29/05/2026 14:40, Pedro Falcato wrote:
> > On Fri, May 29, 2026 at 01:19:03PM +0100, Usama Arif wrote:
> >>
> >> which means mapping_max_folio_order(mapping) <= MAX_PAGECACHE_ORDER <= HPAGE_PMD_ORDER is always
> >> true, and you dont need the min3(..) in your diff.
> >>
> >> Now the question is if then why not just do:
> >>
> >> 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
> >> 		if (mapping_large_folio_support(mapping)) {
> >> 			force_thp_readahead = true;
> >> 			thp_order = min_t(unsigned int,
> >> 					  mapping_max_folio_order(mapping),
> >> 					  get_order(SZ_2M));
> >> 		}
> >> 	}
> >>
> >>
> >> This is because this will regress the 16K ARM case where we already got 32M
> >> folios. Someone might upgrade the kernel and start getting 2M folios now.
> > 
> > So maybe limit to 32MB? It's still arbitrary but at least you get simpler
> > logic. If the architecture does not support 32MiB folios, it will clamp
> > the maximum folio order to HPAGE_PMD_ORDER, and you get the same result.
> > 
> > Does this sound correct?
> > 
> 
> Yes, so if we replace it with SZ_32M, it sounds correct. I just think
> the 32M size is too large. But as you pointed out, even 2M can be too large...

So AFAIU the practical discussion is about two options:

1) limiting at 2MB with a slighly more complicated logic to keep mapping at
PMD order for 16k pagesize on ARM but use 2MB pages for 64k pagesize on ARM

or

2) limit at 32MB with simple logic which results in larger (32MB) folios
with 16k and 64k pagesize on ARM and thus larger memory overhead.

I'd like to maybe offer option 3): limit at 2MB with simple logic. This
will reduce folio size on 16k pagesize ARM compared to 1) but do we really
care? I.e., is there big enough practical performance impact with conpte
and other tricks ARM is playing?

> > Bottom line is that changing things will always affect someone :) Particularly
> > since the logic we have is not too careful at deciding what should or should
> > not be a THP (both in anon and file cases). And if (once?) we make it smarter,
> > it will surely also regress someone!
> 
> Yes completely agree on this as well.
> 
> So personally I do have a preference of keeping the cap at 2M atleast initially
> while we currently try and solve the issues we see with 2M alone. As we are already
> seeing reports of thrashing and compaction with just 2M, I dont think the logic
> in this patch with just an if else is that complicated.
> 
> Matthew, Jan, do you have any thoughts or strong preferences on cap size?

Frankly, no strong opinion. I'd think 3) is worth trying for its simplicity
and seeing whether somebody complains, otherwise I can live with both 1)
and 2).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

