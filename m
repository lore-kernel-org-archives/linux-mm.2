Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44879606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h/WBm7u6
Received: by kanga.kvack.org (Postfix)
	id 4DB1D6B05B3; Wed,  4 Nov 2026 12:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B46C6B05B7; Wed,  4 Nov 2026 12:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CFA46B05B3; Wed,  4 Nov 2026 12:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2236B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:15:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A585AA8453
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:15:20 +0000 (UTC)
X-FDA: 85398087600.29.68B83CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DDE4420013
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:15:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/WBm7u6";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793812518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYq9+BBr0q0gADHtUh7wcOV25vq3s2GgCZsPxG2VA6Q=;
	b=MSyL2bpaeThg/Sm35/qx93kWDKU7ueeHWXZDgXP5yjRJm2Rpp7Sthx8EWZhXjbzxw14npv
	dWVcmwX/a9hM8+6t4U183OJmV26o196SJmxkR787Oczi0hO1nx4eMHmk+zdayBewS8MGRY
	OK0HFdytWAkDNyhTAj5ySQEd2+eZmyU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/WBm7u6";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793812518;
	b=iM8IgXUBz2+/mhgALYb+9bQ25SJ4RFHwXsSBD5AfSvDVRlLnP9vBx8peqAQnftGVRrDcB6
	0DHK8OyWXte0K5fhHU4ocyp3SwBMlegyokQiBx+pg03dWLXIyZI+JVtGDENAYi3dNpRPZ4
	2oFamKWS4LcvYmYZKV8xIrDl/Zcg4bk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22F016021C;
	Wed,  4 Nov 2026 17:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3671F00919;
	Wed,  4 Nov 2026 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812517;
	bh=SYq9+BBr0q0gADHtUh7wcOV25vq3s2GgCZsPxG2VA6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/WBm7u6jgGnIGCnazSx+mTpGGIdY44Edu9dfObP1hyHC87oXtWB0MMAm4MFUJJ/u
	 lBTy/MMP0imnbuTtYVYfUthcWkCCJps5xV7IEhakoied3Y/YAYJ2LCW19zBAqJx4pH
	 sESid7Gte1+yneVlzgi9FxomuyS5X741ccgnYFFmh/GqG+xRbGnDTzIU15SABc9zUT
	 En1QWKFCENGlbrm4Vqm2JURpdLhBKzYNmXQLpTfEcInf5v26cvGepdDB33FjMahU29
	 zYFvvfTS0M08OkXL5giLs6Lh5R2qjGs5WvxH+v452VLnqRD8w0FarnxUqHIsZr2Eln
	 lZUSab8BSMMHg==
Date: Wed, 4 Nov 2026 17:15:10 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Pranith Kumar <bobby.prani@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Richard Cochran <richardcochran@gmail.com>, "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:PTP HARDWARE CLOCK SUPPORT:Keyword:(?:b|_)ptp(?:b|_)" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] mm/rmap: use release ordering for small-folio
 mapcount removal
Message-ID: <autmnQwhDvMzqY5E@gremlin>
References: <20261104013139.1341582-1-bobby.prani@gmail.com>
 <750560f3-4c5a-44fe-b72a-0611be383f32@kernel.org>
 <CAJhHMCCu8ehOU37_4UpExNO3U8YPygjnht+2S+axkxTwY8bx2w@mail.gmail.com>
 <287698ab-76dc-4aee-8e6c-db1f5d18974c@kernel.org>
 <aus4ag1KxpuBNSP1@gremlin>
 <CAJhHMCChBTH3QWBFS1Hp17zj5HepN6KFucvG_5tVdpaB4fjCYg@mail.gmail.com>
 <autkT1eNM7-oSM4F@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <autkT1eNM7-oSM4F@pedro-suse.tail5790ac.ts.net>
X-Stat-Signature: fzo11dsrzy58ijkf8mmn84ghux7nr1wm
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DDE4420013
X-HE-Tag: 1793812518-961616
X-HE-Meta: U2FsdGVkX19vP6RypFLzJKbnzYuKShRE8z+87PqzGucJGG33rhnt6gDowFAfRgdQPOyY9rYKipxG9uccQ4E+7xyldjPh8+4Z3XeMKKedXVncTleMiJsnrJy3LBX4tb4lUv2G0oFYkSp4ay/3HM9ObIDXr948WE4sddSmaQm76VTQi1Yo8GTch5Zw9Ob9XvG3AJC+2FhDm8f8wOW0msBd0KQKC3qQk23OMBVaXkzSI05eodD7kTh+5C/dexErx2b4Jp/uoxrCQ52XYA4RBRaCZzSbWtdIh80s1mCJMxQ9vuu5LAnExV77BoHRKviB8S5MIMtuglK+dLvlhm7M5H7K1Tcig7BcJQdzBiGK9MEkmODFzHywK2rYe8z8DdCAOY2s5dFMPl5asnYVUO3zG1DZqJU4x025MlyuxSPq3SmycBRNMMLpFzKcCowuDZUV+aOKeOLkcoJk8jI+lknK8AEjdb0BqHWV9OlbBoV23rQRPEeZMUA/NWjGyJxlczUCn7oXfRw6spIf5Cp2W3F5C8Fz95kcALm2zY/UCCjTSAbjV98O5+HQRQF0R9GiNFCQVZj/AFVPmMb8tBsmpO3QZ7IZfEBtgbYFHfG7qGpxKkgM2AtKQv6GbPKjhzQIFyPMasgIoT52s7T5dsiBMDU7z3qUewyzscU9b2Th7XkLcoIrgJcoFbP6H6CZUee/TnVU4Ez8fgDtwSvJ2noBygJ3rpXS21Xeg6U/4TsqjPW6oQOMVig3+5DkvkkvGTMQC8y82D6R6Ln31g6wQY9OKiH1k0ZoeM2PLn3ECKOMbpw3ATmt6dlKppEwhcyqf2HNbGSdmQNIw/R8eez56ySaxtuQWp8tXpq+6uxxB4WrWlGvNgKdi0sbAbFPgNDfDjf6siyiNEOGAQOzNBftpxYrl4GAQ8ZAlZRCv5x3z8xIGZivJBfN3fm5NJe8rwxbBCqo93E4o27RheI1MYZGVYF9WI9z/MF
 v/W9fsbq
 dpLptSoW30PSZGhyCyqCd8t3OsoTlOnbPmhRh6dpmTX9nvfMhrLRWq6ZXZD7rjDrvz1C/8aGYV4jhPQS8gVMofZb+SLLE7fqz2xIpucIssXXfbK64C8CXSB4WpRGGFZqAjXW+lSDfsDorXqE0nGmnS1vCCthnRY5ZqOoP4zud3AjYhTCVk0GELMWIWaKqlBlRAZQ/b1xhXDDtFnbbZrRdBXTwNsGS7W2WL30kNfrB+DKRArJxHgi/R3I/D9yDOXtdwQeM87cQD/qr//KSD50lU8mcvIC42/TWQ4mkXzmllrY0P0443qE9ZP4KzgGv6iRof8kb2PujAHYQkkomdrE3f5XpkPt6sS+DXrGZOAOJRz3YYm8+fnb5YX37Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 05:08:10PM +0000, Pedro Falcato wrote:
> On Wed, Nov 04, 2026 at 08:51:20AM -0800, Pranith Kumar wrote:
> > Hi Lorenzo,
> >
> > On Wed, Nov 4, 2026 at 5:55 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > >
> > > On Wed, Nov 04, 2026 at 02:37:39PM +0100, David Hildenbrand (Arm) wrote:
> > >
> > > I mean 1.54%, theoretically is even less convincing for me :)
> >
> > With reducing the strength of one barrier, I think this is a non-trivial gain.
>
> Counting cycles on an arm64 simulator for a microbenchmark is completely
> unconvincing.

Exactly.

>
> > >
> > > In any case for something touching a sensitive memory barrier operation to have
> > > a stronger argument put forward for release ordering being suitable than simply
> > > stating it's fine in the commit message and updating a comment.
> > >
> >
> > Can you please explain what information is missing? I think the commit

All of it? Your commit message simply asserts that this is true.

> > message has all the details of why release is sufficient instead of
> > full barrier.
>
> rmap is gnarly code and I'm not sure people have an appetite towards weakening
> random atomic ordering semantics for a virtual 1.54% cycles gain in some
> microbenchmark, without actually explaining why it is safe. __folio_remove_rmap()
> has (indirectly) a lot of callers which may subtly expect different semantics.

Exactly. And this patch boldly decides to CHANGE the invariant here without
evidence for a theorised perf gain.

Sorry we don't have time for this. NAK.

--
Cheers, Lorenzo

