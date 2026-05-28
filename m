Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F93ECD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 18:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EAD6B0088; Thu, 28 May 2026 14:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A9B6B008A; Thu, 28 May 2026 14:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF426B008C; Thu, 28 May 2026 14:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9681C6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:30:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BD861C080E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:30:00 +0000 (UTC)
X-FDA: 84817667760.05.7680F5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9B2E114000F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:29:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YFlOu+HX;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779992998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHxKrIHeJU3sg/edF3r6NX4gBETjgiw9TNGEvxgUQ+8=;
	b=EOhzK6T+a93xVAUh4A31KlSoAAWVM2J8lX6GFG9WKJ4RTQ/W6s8PUzvOLWW/UjjoIgIT/4
	S7Y6mGh9ZRcIUwusA7AFllNxjsggRVw5FyhmmaPs3lAKi4gz6ejrq3TCEzc8KPmPVOhSbg
	3DgK/BqEdTT1MxmWIgVOZ/OePpkfofI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YFlOu+HX;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779992998; a=rsa-sha256;
	cv=none;
	b=44Uld6HpIsCkyVdGZjfZlGgijGXJwdrxZw7XubG/WRCOKfEnZJw2amoCtvu0L6kDQhUi0c
	bZl84eKZHNxNSsMZvjbfH1GDe33F3Prk0IrKwfOZaFqA3d6CiDr0n2+1q9Y9Cu2XLr3oAQ
	xcQnQ8Nt6/jCQikcxQnlr6lMqC9Mxds=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1319C601E4;
	Thu, 28 May 2026 18:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC731F00A3A;
	Thu, 28 May 2026 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779992997;
	bh=JHxKrIHeJU3sg/edF3r6NX4gBETjgiw9TNGEvxgUQ+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YFlOu+HXNnoQN8osREHhda3zNvyEmCHgTYqcncUKosWfmD+px7Ymz8SFtRN9Rv9+H
	 HVcRn246+bojhY1DZyqr3V4hF7qxxHO8KkZ+l4xXwdEaw6VH2i1cLCd6ehe8B3PBDR
	 E6eRaLE7p8SbWJrdIjsUvOKwRP4rUzDapwe/plLo+65fEBC3gSf0gY2xhzaYaH47HL
	 JC2STC/QXl684fjHMolOiLg4BnvBN/h2l63wnhUobASDryQrUdBoLbRkj6kD+KIeAx
	 Ev1Gs2nsPLGFjg5g3BYsxABclg8VdZL0ztl0Tj9Vp1uNYrps9hZCCcmUNU2NMdjXNJ
	 Pl4PPLCS3UKzQ==
Date: Thu, 28 May 2026 20:29:51 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Karsten Desler <kdesler@soohrt.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
Message-ID: <ahiJn4rgTQJMxKj0@localhost.localdomain>
References: <20260527143643.GO31091@soohrt.org>
 <ahcTYufV7P5Cmotq@localhost.localdomain>
 <ahc31AChKqnfItHW@localhost.localdomain>
 <5f70e840-9d0e-4cef-8574-b355cf26e0c4@intel.com>
 <ahfWdMdxX68ni4ZM@localhost.localdomain>
 <ahg4zTSRK6THd2yP@localhost.localdomain>
 <ahhLIOB7u210pjfA@localhost.localdomain>
 <20260528153118.GBahhfxo0BmTjX72Qr@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528153118.GBahhfxo0BmTjX72Qr@fat_crate.local>
X-Rspamd-Server: rspam12
X-Stat-Signature: ujmknwwcrbqxhdfiiu6ygdifte3emicw
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B2E114000F
X-HE-Tag: 1779992998-778810
X-HE-Meta: U2FsdGVkX18bSA8UCzEZ8HYIgSMxfQUDMiyj3bOXBd3mYPTJxtBEmZbevC3wDflIepfvHP2GIhx2/DKlcY1C0eYUqmgVJMqOIudbIGiqNauppVRaLyhY2EsfkUyA7kJaGOJMqHztywFV4mh4GGaatxPq+b9n0x1pfWx1ZdcZNkoMnHOveeAL9RHatRs7nTii4PMcQUK3uiZY21Te/gtX0DRnhPz4dSx9ILK5I+939q2/UMF4RB5c4lEgGKe8ymhCvFuv3C8TLJkRasC4Gol1Wcd9Jg5ux9YAImliOoDJktczcusdMbkTnuifrdGeVhHWXBNIT2QBtA4V+SFW5M5+jBc8F8jzQJUN1kmybF7a0iLTuM1p5VF+iwPtx525YHevRui+YJ5Miyg9oTyfbb9vBUoObKRwHpZ6b6POwQrPlsIm3y6wjQYc4YGQlmSu85M3orw+bx/Gp9UhSjYtKS3PUNM5vbVFHBUWYB4/qc/7yKjvzAuaTIrlWRtG/pkmTnXQrpfw7RGvA8f/L5rCyUz5qeKjtM9WdtXBhoC6/1BYMIb8Jm7bmDTgf5Xzxq5FZ3zuLw6VJ9/7HPhnXvIdBAWonseUDdrRqQh+TUmFQlaJMFEvprTUxB+0UQQq4QHYIXaopCy5OT98Qym7L80D7w7CK6j7oS5RQ+skD3S/ZoTJQcnHZDkiiZ7T/I2sIJAbnSgKhiu4aE3azrQqjBKtlH+cvLnF7PJEyEplglj83qfleuZFKg/AlillEhHOMbC9tI3PeeZSzIkBH3n5SYZnLWU+J6Zrc1NXB2UT5gzJFeFLL3gSEUgaawDj0P4IrMUH63SsEAHYgSoX6rgkirM5n3Ef+r4wViUVtUnqsW1Mxk3pCmds3aDTfeuyL0PfZe23TV+YBhGetntH7HMH9fzHH8LdCd1+YhSAkAtzxfNx5uRlykd00AMicUVsv1tQaWEXNdJ4oORUaXzPU5pT+YVSB47
 W3V/1C7S
 MSMQ4gmF65J22TPPPVkOZD6yMzXd+qH77PbJz9N7Nen2ZSS1XL86fLM4n2Qixqk1qkw9CUBvFlHL3Na5/+Yh5/zm8XOrU+N8Xct+06EtIra5iX+zTqehBpSnlDnVutOFDtvQJcauO5fom9ND30Xdbc9pqRZOUtS57zo6tJ61PhLNybiMuFD4+jc5xH4rw8ed2AQIm8eTlbTgGsxt6Qv3XYLYQBgbuoH59Lq/0wK3H80D8BN8wU2lvLMjRv7Y6IY9WAUYctgKYADT+adJSGfJt9lkF+EbKrfkS5NPh9uKW9N24gxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 08:31:18AM -0700, Borislav Petkov wrote:
> On Thu, May 28, 2026 at 04:03:12PM +0200, Oscar Salvador (SUSE) wrote:
> > On Thu, May 28, 2026 at 02:45:01PM +0200, Oscar Salvador (SUSE) wrote:
> > > The only thing bugging is, should not the same happen for THP-file-backed mappings?
> > 
> > Aha, no, for THP we do not set align_mask (at least on x86), and the masking off is being
> > done in __thp_get_unmapped_area().
> 
> I hope you found this in the proces:
> 
> dfb09f9b7ab0 ("x86, amd: Avoid cache aliasing penalties on AMD family 15h")

Ei Boris, thanks for pointing it out.

Actually, checking the other arches that have their own get_align_mask()
for setting the mask (s390 and sparc), they both skip info.align_offset
if we are dealing with hugetlb, e.g: s390:

 info.align_mask = get_align_mask(filp, flags);
 if (!(filp && is_file_hugepages(filp)))
         info.align_offset = pgoff << PAGE_SHIFT;

So, maybe for the time being we can do the same in x86 in order to fix the
regression (although the refactoring is 2 years old and first time we heard
about it was yesterday) and then we can think of a nicer way to handle this
in non-arch code so s390 and sparc would get cleaned up as well.
Thoughts?



-- 
Oscar Salvador
SUSE Labs

