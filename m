Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34655C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B726B008A; Thu, 30 Jul 2026 03:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22FE6B008C; Thu, 30 Jul 2026 03:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D628C6B0092; Thu, 30 Jul 2026 03:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFDF16B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:44:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 333DE1208DE
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:44:09 +0000 (UTC)
X-FDA: 85044654618.20.A3E1081
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9CFD74000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:44:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dyexTZr7;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785397447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmeKQuTAIg63rX0NYBXbKDYna+Q8UGjCgnzC2xARrSA=;
	b=Fi90FU0mM4vjmOXWciF8kQPHetGeDc1olQpT0WZlKv4dYJUfPh/xrAdtg73A585vBhcqqI
	ajPHCgsz5hdW7zZCudKwCHId5Td1zOqzw8cOX7+EXUUfqYqFc7To4hHPZ8Ix8DmmZG7SPE
	pu3VMzOdd1/tuYTCtC4BxihDjs3Qr0g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dyexTZr7;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785397447;
	b=MlcqKXryfYMEUBzFOJmYfg9Gx6WRpoIQYPod/EMDMfUU/MzTL6aOSc4Z9BMxzeY++UYyad
	F9bl5Pzoc17oBHljop/lodUygVYZA9Id1ujBF3QAMkpzFjim2ghVM3qjCgHKj/ppBlZZgb
	aEpQEYhlKv49zjk2MGgvpUj4ecUZPIo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1886A600AB;
	Thu, 30 Jul 2026 07:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C191F000E9;
	Thu, 30 Jul 2026 07:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785397446;
	bh=VmeKQuTAIg63rX0NYBXbKDYna+Q8UGjCgnzC2xARrSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dyexTZr7da33+SkLZ0GI0SbNJvBfORKTgm8yfOBmfz8iGrTDWWsw8Y8Z2fCFLVPcF
	 0ZarFBhp7DMmE8435CHEMiEl/7zjR8gYqu6Pza3f+S0ozGBLBfnGW5EjXNlWfgF/A0
	 SV7iN6DwqE7qTGI/MLWuyfXDz7dEFGS2x0efJItpFulFivamRtOOp2pQ7q1yJZ2oWK
	 EU4tUbmLCjChZqZ2xA8e5JzXCOpSmi9zp5L1bGasD9W+xAorkqRksxprv1MjiHBi97
	 gSVysbKzuciRksGc2RbgH5/MKohorXKr+NYG96a6Gui0vyPHtXGczbW8xV0Yq21toq
	 uKzRs7OGAvV1Q==
Date: Thu, 30 Jul 2026 08:43:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Soheil Hassas Yeganeh <soheil@google.com>, Arjun Roy <arjunroy@google.com>, 
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: return -ENOMEM for page-table allocation failure in
 insert_pages()
Message-ID: <amsAgSQpH9XacwUv@lucifer>
References: <20260730071323.964321-1-thnkslprpt@gmail.com>
 <amr9zoSncZguF_uu@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amr9zoSncZguF_uu@lucifer>
X-Rspamd-Queue-Id: 9CFD74000E
X-Rspam-User: 
X-Stat-Signature: dtb4t4xi7y4b4bi5qgxjbpfjce5t75b9
X-Rspamd-Server: rspam04
X-HE-Tag: 1785397447-358201
X-HE-Meta: U2FsdGVkX1+YGrbzjjzqAaCOsfPq92d8QX8FgKHaVah2QJfXW65jF3b5IWa+LcLKNH4SiznuIGPvj2k01UXbb01ioBz/AofZg24XCRnKDFr5w+gRQy0BKAPDvGl5cXBx2O7zlTdm8dv35pCqVLie0WQktgUHfCWp5HAjyu2Zo8pHo09mYhs6DAu0BSdCK4dVbU+lU5qejS3PHlfcN2M+nb+Wtb6ooq17EIQ+xPt//QSJdXXHff0crnf6oUj/6z0UZ0zJOhquZoYMVJfxbOwI7OyWjQJ/7bGwxQ8DwUowNvgRQKP2y1v/PR0qxOR69Usm5ZTe4U49XUsO97zSH/+mVNw+Zbi7kYO+ejLyBtKoqCLffP0tZRoeqUtUtglDjzZ/CGlXdq5xA0koqUOBBMUnT9oIjTkjV/mDpmQg6kO2Nc5T+XitUWsprjLzpvqUg0fTdhN7dZYzEH1skA8livrOX0QgqHDJYbkyYJC/7OpQ+SwpU7Q2fq9zAMsgODdiPowE8r59GHcMOrpMyBb0i1A1pJ8LjHH5/l8a+GhjePqUhD3stT3jgYceeeNM3ITo3+GyGP4QN7oRsiUh6mQyoClqbyqh/SPIaWeejeplQDg/Khs9DeRUrV5gywPUfszQ/bHNLWx27YRSpNL5JX4Xv70dSbxgt6IQDGhkT5USwikPy6AqmmLQdGt4TCa3qjTXRWVwpouUXh42matJ75gajarFSwFxbL0QAxFU1HHXlbvmKwFG+Go019MTqTEE0VzIYA6GKLWtVxhYXe9cgmKVnUw9obxjskOazxFBiAjPUh2Spx+hAMBI7SH7XPC6JD7lY2ErKrYKSEiQJRxLZRTHmhJqgeXsMaepgTFmejMDUWB2XOkQPMczBfEnzYMSx0ecixPYDVh7FdkzJeO/dprZywhTt8EwRAqRBDehz0gFCm06egptD5TwayA2kQy2UZ8QD6aQ9GsfAwaBPi3YxzDjk0d
 He8MAnN8
 6zcDZAd7xvtp6W5CYNuPTDQ0pozzULVwNx1hZLHRPAZ57febhFZ4PsKzGyvVXrzwq4ClWUaQ6+PNCaPtCHHO5PRr6Ldodqn4f1yQODACE2tC7NhUt5pJNmO05xQWmhf7dqpvn12D6qJUQ+4KyFLEgELweFAHVT7+6ccMWrCrxfV+3D3P49gBz5k9ms0he2fdgZUCBr9YHMFC3apyTf4jRB85sA7JVDEydv3HQzWNM795U1eNYcHYWzWa1ea2u12BqlaggvvFtu540JkVSegSWCkzyXgTN4kWF1mreP0jA9IlfTRi4iFc6AgZjtbPbhIgrbeuH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 08:42:55AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Jul 30, 2026 at 10:13:23AM +0300, Avi Weiss wrote:
> > walk_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
> > pmd_alloc() fails. These are page-table allocation failures, but
> > insert_pages() currently reports them as -EFAULT.
> >
> > Return -ENOMEM instead, consistent with the subsequent pte_alloc()
> > failure and with the single-page insert_page() path, which reports
> > failure of the same page-table allocation chain as -ENOMEM.
> >
> > Address and range validation failures in vm_insert_pages() continue to
> > return -EFAULT. Keep the later -EFAULT return for
> > pte_offset_map_lock(), which is not an allocation failure.
> >
> > Fixes: 8cd3984d81d5 ("mm/memory.c: add vm_insert_pages()")
>
> Hmm :)
>
> This isn't really a fix. Anybody relying on this returning -ENOMEM
> vs. -EFAULT here is in a state of sin anyway (unless you can point to
> specific users who are broken).
>
> Drop the tag.
>
> > Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
>
> This is correct, walk

Ugh incomplete thought :)

->

This is correct, the 'walk' can only fail due to failure to allocate.

Anyway I gave you a bunch of stuff to do here, respin once you've addressed all
that.

Cheers, Lorenzo

