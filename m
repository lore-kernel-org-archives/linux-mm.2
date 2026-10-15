Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB565C2D0A6
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988B36B00A0; Thu, 15 Oct 2026 14:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911B66B00A1; Thu, 15 Oct 2026 14:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB816B00A2; Thu, 15 Oct 2026 14:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 470036B00A0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:14:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BC7BA0585
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:59 +0000 (UTC)
X-FDA: 85325659398.29.96A28F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E86671A0002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhFWtCqs;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088038;
	b=niyic9VCFq1zYAN/8qN/yuWqUNGQcjj7H9duj6/RgIhMaBahtJ/bRigqPGcbeVhzAVIUIb
	EmnNZ89jvC3x7Nzjxk8OIF36roeIV4hj6x4Xrb6v0JKvsm77NxdaKLxeQ3MYV5GqmSc169
	0Ep13xcuGjczDLul+qUfI+BVtXmZ7uk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhFWtCqs;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EFQJqg0yMuhYAmVAOubglzurSt2Ec8Wt/DHPpPLNKI=;
	b=Jve3RF0uvsyHlfc/nQDzx/ZmJ2/6/5hTf/1L8NJoyGx4j3QTQLb55yoPGSPPzjxY1xAFxW
	/H1Du0Zq+8vRHbzcIzOWLthydi3hrgGnvJsZnkDCbVnvRAhZWLX32eN2ZjEB9i2hiM1z8V
	zkxXTKPtMhB3MdwFWA2AEj3vUbliqbU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB41F43915;
	Thu, 15 Oct 2026 18:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805E71F000C4;
	Thu, 15 Oct 2026 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792088036;
	bh=4EFQJqg0yMuhYAmVAOubglzurSt2Ec8Wt/DHPpPLNKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IhFWtCqsP4BQwMpnuESmHYQeVEpjJzGMm0A93eHV4/8xM4qoz8Kunm/NKm64riKfv
	 5q07b2mCfcxv5TsYp9WsEU65TQw88rh8YGpK9fnUI4WYQHOXL95eGdc3aM4KZGlNui
	 7BuV/x/8bAE6Iv7fAD8ioavZ037v93OinWq/fjxs08kEzahdXXIyNbIwmNFvFXTDgj
	 VyQ6GR1du0RcNNPQ4jEyVaa9Wo/G/PmEm3QH6Vmd7+xlaUgmSFy9+hkXK2NQcm3OX0
	 jtNDKEouCgyLzUkgxQkfzeCxDkRhdWQ7hJIDLr9Z0IJwTqgqcWz3x/un+sPvRC2kwc
	 jpm+j/61LMuoA==
Date: Thu, 15 Oct 2026 19:13:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Jann Horn <jannh@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent VMA generation reuse from skipping readers
Message-ID: <atEXg_B9_Hy9CEbN@gremlin>
References: <20261015143735.1630957-1-4ncienth@gmail.com>
 <atD8jesRoc38xF0J@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atD8jesRoc38xF0J@gremlin>
X-Stat-Signature: hst4rf7bckpubb65k1pswi8jrxfikh7t
X-Rspamd-Queue-Id: E86671A0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792088037-608309
X-HE-Meta: U2FsdGVkX1+Kf794mj8hgr6Gxr/AwjMniS6IGSghRTjqIO5bAB5prur3VSbaOebvCxH7QR23zvlhpwpS90VNRv9X41bOzRf95Ybmk+Eu5LVk3Y5Md1nrUQCXZIrwNuZoegr+vzrV/mKxnRKgEF9n3z57z/mqNaR9UoQ4xn+kjyG2fCzR5pZ5867A916bDwd52YG3mKxccUEYsFVynDbA7HSxWYbOUv1tV7swbvOrZWPSRCGQu+Lhs3bi9qJnWT20tUF3yOWzMNE7KfwSHV7HDwBFEMFihXNio7i7AJA4UH+jwknNpsxhq8g/rd7upksleC4ka2WyIhHet9yrqPAZkjDL1EjIU0Vs4tt59kjz6L5Nn/ds3eY35ifDa0YzzHm4VSqXcOWgEyUhWuNWxZw5ImMjQ1AeFInoks62uyqHcBaUYloIIRWSvxnfhB0DxwRM2ZqwD/agj93/Ot0MbK+0LzuWRLSQ5P8WZVkDmCQVLDQfpgz74UkyCSEyd3mlTWGsrV8bG/Eiffizwru9Os7vJv0ScM2BDaFYvtEog0K9IUtpaN2Ys5S0ceZHFD0+C4WNYHjqoFHJU9SXiuZjgbRIvBCNoeZwI4c7PEtsVNv9C2cUbRLvx5unVL0m53m0NtDUxTkXzdVwDepOVogr9xMn5/YDl/jDnsKbuzVTowd71eSCp0IXnS2WseIMXuwjnxSaqd3ERKQr/JImB/cCLswux0tbeYnQl9qA4ZtMTdskpZwgNl78XLAiEWsDzaB0m/LfLLaG/OJwQLitKRsqmsvUsvYBYFr3NYCEKrvJnwVQu9dOERVRNBWnCrzgBB8ElRyf6l1sZ46ocbAcmJjmvHaw547WkH5MGnuyBywIWDZ2H+PwvS8AUDrkan8SArYu5JqgvZhFsbmBhVKuB5eu41tm8SZINSeT5FHcBat8JwTeWfeelAp9BjNB/anl2dH1iibGb0PPDBPuiLW1YYPxh0R
 A+7VCB/R
 Hx9MoSUM04DipXtkP/4J6kFPJZAly4LXdC/p844t7IglzFjdfltrvuMrxXboLp5tWwnbja9GMoOj4fdgiIPHKG2Ku6zboAlRly3T2QU6PJJQF/SYXXxcnq2ks03f6kn+1yqBu4hGjZWsEnffwMR0mNa0bD+yXk9trHn8KQ68i24F5klh2OuSWILxKx+m2HjMWo9fOdK+aF5XKm3w3oWemxLKSPKmfxmzuss9OEtafdwVz8GADkBvlaz5Gxc3A003yn0hx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-schlopper.

On Thu, Oct 15, 2026 at 05:28:00PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Oct 15, 2026 at 11:37:35PM +0900, <schlopper> wrote:
> > Both values are 32-bit. After 2^31 complete mmap write-lock acquisitions,
> > an old VMA stamp can alias the live odd generation. vma_start_write() then
> > returns without waiting for an existing reader.
>
> This is really unclear, I guess, as before, a member of the core team (likely
> me) will assess this to see if there's anything actually valid here.

OK I've assessed it, it's at least theoretically possible (Liam, wisely, raised
this before and we all, unwisely, dismissed it so, humble pie time :)

I am working on a patch. It's not necessary to add a new field to VMAs.

Will send out in a little bit.

--
Cheers, Lorenzo

