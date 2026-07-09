Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F322C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E00A6B0088; Thu,  9 Jul 2026 07:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490736B008A; Thu,  9 Jul 2026 07:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7136B008C; Thu,  9 Jul 2026 07:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC7F6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:00:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9B6F1C54FF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:00:21 +0000 (UTC)
X-FDA: 84968944242.26.1F47A67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E3BCC000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:00:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RBlISwJq;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783594820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIRIMIqxIBRoAUi+TzoRrEIZ+kOeLqxW4VMnYG6vpJM=;
	b=e6TXGXCtDaUphhHimqEL7F9rW2BcSVeq/0oGV/sxB1oSrNd7HplH0gpUULZwpfCdcqSljv
	W2BbmvHRIzL97UmTPCYo3Hzvg9m/utfsiVk5bsneEe2dfwM0ks28cojuSsWtt6GUYtYlwC
	DuN22D/0Lmt/+G9CG6wHOn5+8wmnKCg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783594820;
	b=p8/0wgLvVIjHCClcyFY78DjXyBMRzbamVmSBRVdtT2rpRhuMnRs69J/4iAXtiWOa9QHZhq
	VUXCwptaSLBJZElFR2Q70ogbLeb0oOS/um162t1EHe+SWPC+XSkjfeKObmZh9yFNuDgHSj
	QLPgzq9XgxQCO535K6RLdP9Iyd4chGk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RBlISwJq;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 240F143306;
	Thu,  9 Jul 2026 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC70A1F000E9;
	Thu,  9 Jul 2026 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783594819;
	bh=NIRIMIqxIBRoAUi+TzoRrEIZ+kOeLqxW4VMnYG6vpJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RBlISwJqs2YqVKjGBoJ3mmQ4DaRDwrSPoF5W++7Hzrwz4c13bMoEWcxdhWoeVT7Yn
	 wuvE3qGGNmmSzcahSfSZeYHBWnbbUphVhHmbvytp8lDwWCrSqk0xnGIcJGrkZJRA3I
	 JzJDfQHyR2LnfUZK5V9n8R6BBkMe7pvyS+K6CugynwiPHMGFbXJhiDKhZIRLZe+zLA
	 p2fnpOH/iA/NEFOMM2SmUCg0jcfiFfK7H72NUeQB3Au8Gxgk/g+xEwGeeR1wbSVzvs
	 XPY2Brh9V6mMDNLIk2/COjzXz6r6MN7t/L5EGQfmpH6+7qp7EIcHKnIBr56/qCK1Xb
	 EGb+J2DdZHURA==
Date: Thu, 9 Jul 2026 14:00:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
Message-ID: <ak9_PDCQjNWHWCyT@kernel.org>
References: <20260703020832.1731864-1-praan@google.com>
 <2vxz7bn5mv0n.fsf@kernel.org>
 <ak57VeunO8qd4wEh@google.com>
 <ak6DUC7NsIZ20RZD@google.com>
 <2vxzy0fll71f.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzy0fll71f.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0E3BCC000D
X-Stat-Signature: 6nnntbz91nkzo1capq3zcf6fuyub5qxd
X-HE-Tag: 1783594819-764378
X-HE-Meta: U2FsdGVkX183Ywf6fvGo+fIUjNjNEM+mjU6VhzRuzxtJGuo3B9YCfhYcijuP+ubQa9ZGOTY3+mMvDVeWflySVuJKu8TXAgebwIDJaOuiHZdxMeA+gLJ5PFw3BwbxaMOdAUdAneIxakVqK6xgU1kkDVot7FOWlybO/Azyb7rBeorygLMIBHCG6XoiOlL5I6Gnxfqsdc33utjHmuc8q1tOOwXFAQBXkIRuVq9ypnQt8+eLVxFvQ+dFwcycPfxq0Rww/QjrmUIwws03ge6JyJUOstts72j0Toy/Tk/TgqnnoxcbR1Tz5bn4v4v3hhm2BaKvdA2MQL2XKG1SkQWf23Gq1f5C4Vinl4cu7+DX7N1exjA3K5qoHwTis/bRgt03nq87Ewi3f66ZIEw8WiC/3+NO/ee48sen0t3lVb3vIuiXWRw34I69Z7orMXlmHw6FeaWB3vIXJoB/orpxfWawlGJiv3wVfljagYwcyyyPJkslYpgmmMePesjbR0WHvEM8ecjM8eVBDaYL44b77oApb7D+fwed3t+lir/H7mlzYoP4oMJgoskgMiwfL3fXPrOsupet4N4XfaQvDLIiUJIikBTDth+xMkrL/NXUqG2+QTYVpmDSoDwanqNyn/s5qPAGJ1AAXyUFjzoJVD3ISRbH8I2I0VGXnuysUGk0T5ShNw6S2wLEt2VyR9iBfQZfT3rjEYbXp1UOZ0fPvfGQBWHoY66zHAhA6X2Af0IL8yWmXumo2gr7Wi14bkCUnkziDxwd/E2Zs+dKqIG5sM2SopIAil7fBMoD04JnPPFKqdcpaXU4JVCkXujb5cA6XXVh6Gmz9xPR7shrjNFbWk+BI9O+5oLCkoQLWs2Rd4VmCxX7ylhFux813n3UDwxwOxcYNZT7sc6L0YurYhaazXsRLLh5/VszK72djOyVkI7iQAyik12cDRNcejgHGDQ3edloxbu5o737FUTjA59F3Te2b4YhGTR
 61E3hLhR
 u2t+FFX5+V2qc5wvj7q/pe3uQWSFVuriVrMvLplDhEyNlrWCLEBhyg0/z3EHSCmqjsy2vCmggLWl9TnPU3q7fg7VomQlUtXDk3spAOBsHkuo+mUnwWvXNnmbGkY7cH+eu13I8HPNMCzHsV0BXX5R8NNKHVmDyOgCh3xgqXbTByKC+5nH4fNFQZL574qjuinqLY1K538jvk5KJu8qJZnu3qafkcAieEoJmChzc+EcoblzALbL+QhCMtm3ivP5si7X03vYH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 07:34:20PM +0200, Pratyush Yadav wrote:
> On Wed, Jul 08 2026, Pranjal Shrivastava wrote:
> > On Wed, Jul 08, 2026 at 04:36:46PM +0000, Samiullah Khawaja wrote:
> >> 
> >> I think this makes sense. The mm already relies on the allocator to
> >> track the type of pages it has and expectes it to use free_pages or
> >> put_page() or free_page(), so it is natural for KHO to rely on the
> >> caller to call the right restore API.
> >> 
> >> Lets add kho_preserve/restore_page_contig|_order|_nonsplit and the dma
> >> preservation can use the appropriate one during restore.
> >
> > Ack. I like kho_restore_contig, I don't think we'll need a preserve for
> 
> Dunno, everything is contiguous, folio, 0-order pages, higher order
> pages. So not exactly the best name.
> 
> Since you'd get these pages via alloc_pages, perhaps
> kho_preserve_pages() works better for this kind of allocation, and for
> the _current_ kho_preserve_pages(), we can rename it to
> kho_preserve_split_pages()? It is a bit too wordy though, so that's a
> downside.
> 
> Mike, you are better than me at naming things, so do you perhaps have
> any better ideas? :-)

Thank you for the compliment, but I'm drawing blank on this one :)

The best I could come up with is to kho_preserve_page_range() for order-0
pages.
 
> > this though? Preserve doesn't seem to be preserving refcounts, I guess
> > we could rely on kho_preserve_pages and the caller can use
> > kho_restore_pages_contig() to set refcount correctly for unsplit pages?
> 
> No, kho_preserve_pages() can split the preservations in unexpected ways.
> While for a high order pages the current algorithm _shouldn't_ do it, it
> is simpler to just add a new preservation function.
> 
> Move things out into helpers if you want to avoid duplication, though at
> first glance I don't think there should be much.

Right, preserving compound pages is more similar to preserving folios
actually.
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

