Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0918B606A324
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 18:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kpQTgW3r
Received: by kanga.kvack.org (Postfix)
	id 1687E6B05B1; Mon, 26 Oct 2026 14:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119C46B05B3; Mon, 26 Oct 2026 14:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056216B05B7; Mon, 26 Oct 2026 14:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB5576B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:05:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F450A845B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:05:11 +0000 (UTC)
X-FDA: 85365554022.07.10BBA71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C55C6C0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:05:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kpQTgW3r;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793037909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSYE5PMCjtkYE/2kg/ihUpsjoSDnaarE8/1GfnhKwlM=;
	b=I+qtSqr5wkoqoNJpH7CpCMGOl3KobJBlg0+YCtTeK3FeBRwaWMVaFYM6g/ZEPlxFRNpkMY
	MBnsR+U/t8E7E9RLS5xkVrtmvXCV/gJVR74ooRMtLsCKxRW7rCCPWG94+HzZfBSqYNdKsY
	sGjpAQI4ORJbs68v+z4EDC/nL1zIQow=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793037909;
	b=bBPEZCjwOZsJe5+uF56WVhaVWzw/md3QxV76NZluHqdynyMeBaRsWgyc6VposQ1ZYz2ePU
	ULtub/FOBUR0r174ytsUHccHaVxmKQmFPMkEEETa2GmYcm6kC/FX2CqXaV+8fBrPaMOoBe
	OMMDjOe8dtelb6AYJHsgi9FPglaQHY4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kpQTgW3r;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53091601EF;
	Mon, 26 Oct 2026 18:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB101F01825;
	Mon, 26 Oct 2026 18:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793037909;
	bh=rSYE5PMCjtkYE/2kg/ihUpsjoSDnaarE8/1GfnhKwlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kpQTgW3rDY1kY36F1bdm0miYZ7qkvzMiHcyoMuGIRhSZg80yhPvKxdxRJ5W2DNpt0
	 I6gAYk6hYOTLAEqH8qI+X+i0GZYNv6AQtPmYUNOwMxyD08Xio9hJR6JDhtVPjtt+2c
	 6OeChc//KC/hSRQsCQVeiyvmDo2C0KxPexzZTGLkw6rRpeSbjIG3QpImoUcRwULz8n
	 j7Uj660lB9mz/vFlMFInPEpDIr4WMSbX+ZasjwDlpJ2ZUcqqD7jiusTg8dOL1WNMI1
	 qo4w2j4PCvXPc32fKnnFbTQ8yj8gVUXudf+qfpREfOBTUskjKmklrsJle6s9kfkx/A
	 Ybfqosydthhlg==
Date: Mon, 26 Oct 2026 18:05:03 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
Message-ID: <at-WKy_zj2SYUhBa@gremlin>
References: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
 <at8-42OwXk2z6-HB@gremlin>
 <CAJuCfpFaxo06yHdVKsEEmFf9qoOYS0DbMvUuAZEhNfDe7dcwJA@mail.gmail.com>
 <8c5a8fb7-233e-4433-af45-b67cb2528b60@kernel.org>
 <at-M5hORjFt6aur4@gremlin>
 <ft4q2mxxiihpvc6wjs2pyku6fvfqg5r4brpgjvz4ikkeh7vwff@s6h5k2dxstk2>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ft4q2mxxiihpvc6wjs2pyku6fvfqg5r4brpgjvz4ikkeh7vwff@s6h5k2dxstk2>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C55C6C0002
X-Stat-Signature: ory9athiz3xpj77zdgi1ojh5myb5h4mp
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793037909-622889
X-HE-Meta: U2FsdGVkX198aiYRuGfcjWgrq0coRCo0wNWDwiZ1jr5xsAGu0Cham0sXXd80DEB0h6nO4LG5z2tGfQKqTHo3L/ozDWpkBorrDRfjpWpIJKEap9R8trOGtwglR1SUzhjleRh5sl3ebqaLdWPUwA8bIb8yCy+/2OEGHi55nBTs2wdszP2//AmOP3RC373Je09XjGNESoQD8JXc2LSHnv/UTcuBLBhZogj9v9TmINo6wqyNX60piplZlD0S1mFF5eK4ZpBSytLn3ht1egyEE+sHGmPDxkTl6a1lrvFe/EMOBNtA+b6uHxAWWjCZ3Md6I8S2MgkYBEkji/pxX+709ZWTb12swFyQlJo8X+0wJAbfHpOJ/Qn9gNb4ly7wqOk3+rFivR5dY+e9Pr7tUgdjqiC9ae3/6/8c3D3laqmnhmZZXS79ANfGiQnhv3kJFT46kpE2VVBYrCWVom/yZcx8lofCthey9kK1FKeLmbovNbU+CS+jy+pxmiIWMsKY681KIeyvYWBGqeg7+NogfI4NsSClcPcDHa5ZNdOb9MZPVa8jJnNBTcnvsFmhanJzr2yf6sTeTyTjFHOlJNRfkxuo4O2KvEj0kHbbVcrPFj5bVbMJTi1l2cF7ikh7AFenzPegBWfBotl0MtJ+X1pJU+Tr1GyQnW75G9Toq0ruXcPo6Kg0zWBg6Bhf8wajM+Xhb3RxGEOF2Bae+iEs96GRIKonDLUWRo8DCOia1QkLolxvJMb/IuhJGNdy6hLiapycFbI8PTBFMrTRD4B+e6TLs8RSjtYPL1GWzhwj/PvYbv4I0lZenpc9URJXZML2jvhkR8iLo2V+e95IE3o06FlFsRPBCQrwx72PXO5Ew4RlHxbLzArTWe/uHuZOCBLTwGPgab2EGcxyzUYuKi+sCFnVdjGOq6w5XSxK1Qg9p2rlA6/UTI5UPIpK/ttPSvTHYwIXuA/51J+JEg2RMKqWKG1mG94WRYC
 sJV3CwdW
 67n5GSehrnUkyf5d5aKv5VCIY09MbpwYed2tIZCAzv6DoIB3giT4nAIwLR++33mBGs0yV8oB4XxfTLgDd/Fl6W207jPgzjbwZm6I/JSnEzXGhwdL4xhVLSGJ0MIGpcmU2TaBJ0asFS7o6tGZumhY62d1CD0maJkYwJ+RKjEEJZyvFPH9SaWInka2Kb2oYNZSp+rcTN/P3bFCT1VIn2dJpg/w6pPSjQ+xPudvpxontEQ15SGalmfhGLanFFTNNU0zP23uUNq1bzEr1tgNFrK2la5osDjQr7IcDz1pga38E+Z1ioE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 02:01:47PM -0400, Liam R. Howlett wrote:
> On 26/10/26 05:26PM, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Oct 26, 2026 at 06:19:18PM +0100, David Hildenbrand (Arm) wrote:
> > > >> +       /*
> > > >> +        * No lock was held since the last call, so the iterator's cached range
> > > >> +        * may no longer be valid. Always restart by address.
> > > >> +        *
> > > >> +        * The vma_range_is_empty() checks below avoid unnecessary mmap_lock
> > > >> +        * fallbacks.
> > > >> +        */
> > > >> +       vma_iter_set(vmi, from_addr);
> > > >
> > > > This is clearly simpler but this unconditional vmi reset is not ideal.
> > >
> > > Yes, exactly how I ended up where we am right now.
> > >
> > > I pref my current fix as something to backport that avoids performance changes.
> > >
> > > If you two disagree, please take it over and drag it over the finishing line in
> > > a timely manner.
> > >
> > > I wasted enough of my weekend with this over-enginered piece of software. (had
> > > to change one word before sending, can you guess which :P )
> >
> > No problem, will take over.
> >
>
> Just a follow-up, another option: the vma iterator can check the
> previous end from vm_end and set the maple state to the range of the
> current vma if they disagree. Using the set_range() and not
> __set_range(), so the next walk will be a new walk immediately.

Ack, as discussed will give that a go and see how it looks taking on board
Suren's feedback also! :)

--
Cheers, Lorenzo

