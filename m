Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F21CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 19:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3932B8E000B; Wed, 22 Oct 2025 15:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342EB8E0005; Wed, 22 Oct 2025 15:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258A18E000B; Wed, 22 Oct 2025 15:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13AE88E0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:22:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B51EDBC0C9
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:22:44 +0000 (UTC)
X-FDA: 84026722248.26.69B1402
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3F32740012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:22:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YFN8csLz;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761160963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbBBeYBFZH5ophEa2nhxznXN91y7nH+iWW5dUK79ZfM=;
	b=Qsiq2pYzefFzDymG2pHVeL932HuYAsBUg4aogylfLJxcCnsXeIcJh3zDCdygE8vwWtHujD
	fAKovwVuYs0B4rAmxVrBQriZ4ejYvEDVDJbQ86ETKZ1TxQpqptVbKkEG2MILoXyUT5Up0b
	OdE6wofI13bWBHRdtC3pN5qhp+TnLp8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761160963; a=rsa-sha256;
	cv=none;
	b=mzeB0Yy3yRBAh0vpXQ4Prl94AJFSF33SavYbQXEt+hOF4ULpwOUWcuucvqLTl0oRvlAERq
	VYjNM3YOgJOG7lDA8ZMsEzCejkkJQaYolqTSWLCmHevaHAk+3jktnCcm7/i1II3zAeojOc
	RdniPtzeSEFvPJzGyp8H/2F1l9vy40A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YFN8csLz;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C6386057F;
	Wed, 22 Oct 2025 19:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E000C4CEE7;
	Wed, 22 Oct 2025 19:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761160962;
	bh=hQnzupzHHgSi4cofh0YJDQqv3isCGVIcYStvBh1mYXM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YFN8csLzGHpCp1X+A3OFEYYmru95A84qxriKEZDIvqcO9DbY03YYDjGxsPFDMcyug
	 SH7fQU7WKReNKK+KIvM+6V3tHyX97UI34YaBI4kETmkAkXpexe4hFaeA4+09VR0TmH
	 ufb727p9iiRS6WiIKFXSVtYb8KTDO/LRkUoJLPEc=
Date: Wed, 22 Oct 2025 12:22:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Conor Dooley <conor@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
 <dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
 <wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
 <luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v4 0/6] Cache coherency management subsystem
Message-Id: <20251022122241.d2aa0d7864f67112aa7691bf@linux-foundation.org>
In-Reply-To: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F32740012
X-Rspamd-Server: rspam02
X-Stat-Signature: hesbei4sr9131ywjocuh97csijj6bz9i
X-HE-Tag: 1761160963-973953
X-HE-Meta: U2FsdGVkX19pKmDJMl2BYYHluBWh5+SHPhhON7TLEGOi+f0fol+wH+8A3CZ29o/bI4yChXoavlcuJpyrJSszTx5KWm0ClJ9s/sm72mX2a56vQWyk75GPVAm+rov3c+qbjhe4jqbQ+u2JFVHjFitRQm9Z+q5DS5ypu2YiB3fKCOpTYy+9I2tBJy3BBZFkWiYn2jZKd0OMSEfUUgoLDFge90In1g8e4azmQN4CtDKqvl7t5PKd5nCT/XebQhW/1yYQjJJah/y8YYOUyL2XmX4qlVAYiP3ksy+jAZTlO7eGFgiYIk26o14VlRRoeamShjBsdq3iZjzMhpM0ATmbf6xwg2Qy0pmK3JuSbtDP8n1+NbW322ujIHgtYESZM7rh7CIgXaQa7KqicabdA6O52h2T+JOx2pku47wQfNcBdWku4fG4+Xh+Ey38+KNJq+yFmWvyOLvUqx2t+SwWxnQStQoPIg/sUSIF4oom+BQ3Ew1zMsBu8m4x0MSZEgYUIjgjQvUU1ZcCcMSLbJJynLkZG25sHC1dP7gwbEXg2jNKMNnTQxnaNOwIzWx52Q06w3iYgkSFLq2Fdm/pbznROKownY2wQhwUh0JLhIyQyOlLZ44t6Ky3baqjf35iEyYPAwTuglGka8+6CvB6JWKwTmzaCZoIqR3m11J77d4VfUlubnPawdqSEYKh+VldlrtSZY86mi/V0MDvZTkQdo3kFPTmip8iDnpJC/kJity5mEPj9ppb3/o8y9zw5rOUX8tkeYVirYXYy2HAJwj6iySHEW0v6bgLShPvYW4GMgDUb1XSP3qhT/5i49MxZctlXC4/G0iyLvWvrOS/IgsBgYju028sQfYUkA6LYAItRyjryhduiCXiZk3cKSUmM7ZROv035wb5+EBGkk9wU6D4YCQujunHwRXTJo10VFIMx/Z4KCdfk5J/XTY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 12:33:43 +0100 Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:

> Support system level interfaces for cache maintenance as found on some
> ARM64 systems. This is needed for correct functionality during various
> forms of memory hotplug (e.g. CXL). Typical hardware has MMIO interface
> found via ACPI DSDT.
> 
> Includes parameter changes to cpu_cache_invalidate_memregion() but no
> functional changes for architectures that already support this call.

I see additions to lib/ so presumably there is an expectation that
other architectures might use this.

Please expand on this.  Any particular architectures in mind?  Any
words of wisdom which maintainers of those architectures might benefit
from?

> How to merge?  When this is ready to proceed (so subject to review
> feedback on this version), I'm not sure what the best route into the
> kernel is. Conor could take the lot via his tree for drivers/cache but
> the generic changes perhaps suggest it might be better if Andrew
> handles this?  Any merge conflicts in drivers/cache will be trivial
> build file stuff. Or maybe even take it throug one of the affected
> trees such as CXL.

Let's not split the series up.  Either CXL or COnor's tree is fine my
me.


