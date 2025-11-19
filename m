Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BDE2CF2582
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 05:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A516B0030; Wed, 19 Nov 2025 00:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041546B008A; Wed, 19 Nov 2025 00:44:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC19B6B008C; Wed, 19 Nov 2025 00:44:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA3EF6B0030
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:44:39 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 553E1140348
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:44:36 +0000 (UTC)
X-FDA: 84126266952.07.A8CBECF
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5623220008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:44:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763531074; a=rsa-sha256;
	cv=none;
	b=bPURPk7PYsz5ENLG1bCVVIHOrrE81ejqsnJSLjOXFt80bRHiLFDmF31G7uzmtS7kk2Lu3a
	umpOEXcM3ejPzI0l7845ve8bZqgfU5TGI0cSevvfFlMtDh3dhAdHPZUfKz1/Gb0cph7hhy
	N1Kf8ct1SPX2IUoFVvj3Wqv5KXoP2q4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763531074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RB+Y/1LPbsuiH2s4/DHLnUgJXNw36NttKUJZ9Igg5Y=;
	b=J+kgBsZDMvlDhoZhNpv6cf3FAdgSFA1NlWLT9eSRFu7FCfDle9Co4KQWjJFi/+W7vhKuiS
	VVnPBHH474x20A87ZskU4Iv++frtb2QsRFyXON/axEFCEQe0mBOHGf6V6SLLmDFKheMoih
	RNuhgqyVlFR8mipN6SkdbmS+oQsIWeM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id D8E6068AFE; Wed, 19 Nov 2025 06:44:28 +0100 (CET)
Date: Wed, 19 Nov 2025 06:44:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <20251119054428.GC19925@lst.de>
References: <20251117173530.43293-1-vishal.moola@gmail.com> <20251117173530.43293-2-vishal.moola@gmail.com> <20251118224448.GA998046@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118224448.GA998046@ax162>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5623220008
X-Stat-Signature: u4j7st7xucgksjkdbsin8khagnwm91xn
X-HE-Tag: 1763531074-586055
X-HE-Meta: U2FsdGVkX195pUKPDqetmDPRSVoNnhN5rA+bxX9e5Fb2DbUi7e7xNbflv0m0kruuCJDMZGNkeX9yCEcnC7GAEF/13YPo3n5aSOU6vXWP1d4Ihk6b4PDsX1WRG0cO0S2AH828CqKMDv7XxvAriG1Gr34fOkTz9XjLQ9+4CGposp0PPp2eSxVL/ZV+aECEL68J6d+Ieg+nray4l85ctv2aNCOLBfrPMankdofF0vri8bh0GcLXy7G4uxZhiLc/qMzHlovxc7PItVCIWr91UyQQVT+psmwzkZPcqYd1vf4NHax2Oko+ZBQq0Siz2snrmVr2G431WzyZSOfDTmZbCebi1DUL3DSDSL2KQF9jp70276TQYluhik/DUmd7bsAvcIfdkbxIuxFlpYHyYaNsM2mHCE1JVkYkUW6RELXnJZra77C6xXYYPuH5G0AwcroohYE5hpvuzwNB/hdgG8/adguE4Emy+hAxQ04iMmOL17tj4qBMRE3khCRMkvTziujCKP/OmOe79puoEhgE436jHcBw7Gqbo0klyIiC9oJBZvNDOTCDjcNZAkVatI10mbOtrFrb86VlAFHbrbNsgA/vXrciGrdpBwmQ0rx3W0tvqnh9KVqx9fO/6z2kZ5hicqCMusCDO5dyrAWh7BtQgDguShaTMDwBCLnwWM7xev3mUnEMkIByi9Tei9WW4mLNo2pCNUvAxwu/+hE+2GAVWsXrWCtxvzzjOIbjNg5fbEb+fB2GDs6CJYJtKy2KWySf5yUclTOgZuruvqRurD9eQBj2/Hy/v7SttxR6uJZmJZiskSKJHKPm2T4PezMDpTgt0m9jbubzwSMpTQZ0kAQz74/zP0EZM0Ypv/2Mjj7CMs+8v8Z2eS32gyk7zlK75s8CtSXfqpSGmtplJRUDe7E/0f0w4Jr6Tgor8fc5mwa3MYptgQCL43km2AqgaZgqDmqrNRSUEzu4j0uNUT1UdosfxGm8IFj
 LhWzPD7X
 p5atpd2iJ3AG2O2gDLGSta2PPKy1n+yO6xtZtptMGTVNRPXWGqhXD2iOGcTPJbv030UEgl0Cut5zdcUiX5nAe2UOIl5cibON1RU5EspbuQd/tuC4Y1ADUZ05+oedFgPu+BGds1IR72LNXttdjHyMFkMo8krahPVRByNCX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 03:44:48PM -0700, Nathan Chancellor wrote:
> where kvm_arch_alloc_vm() from arch/arm64/kvm/arm.c is
> 
>   struct kvm *kvm_arch_alloc_vm(void)
>   {
>       size_t sz = sizeof(struct kvm);
> 
>       if (!has_vhe())
>           return kzalloc(sz, GFP_KERNEL_ACCOUNT);
> 
>       return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_HIGHMEM | __GFP_ZERO);
>   }
> 
> Should __GFP_HIGHMEM be dropped from the call to __vmalloc?

Yes.  vmalloc uses highmem internally where useful (on arm64 it won't be
useful of course).


