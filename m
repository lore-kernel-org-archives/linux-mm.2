Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842FB606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QW7MK1KM
Received: by kanga.kvack.org (Postfix)
	id 9D4BA6B05B1; Wed, 11 Nov 2026 03:05:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95EB36B05B2; Wed, 11 Nov 2026 03:05:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8746C6B05C7; Wed, 11 Nov 2026 03:05:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA9D6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:05:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F23E5160230
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:05:33 +0000 (UTC)
X-FDA: 85422103746.06.B08F3BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6373B14000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:05:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QW7MK1KM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384332;
	b=Z9CGYihbX4NtplLgRZjkJ1g8rhlUultq61aWJlGETzfVGdpPR7TD1Zwx4EGbAS9gyMe2hC
	cyCFyLXFrr83+qy9B83EYShIsdDZTajfyitwCFUUwil80IMiZ718Pj/VPJvaNyZ6Kbtd2y
	TY7HC1xOt96g/j3F7ASw/Y890z4lJ7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GSWuUudINQ5InmDwWsy8zWhwr+7Kpnc2mR1mJL4+KA=;
	b=k1ncODV3Spu+k/XJ8Tw3Bnf34/UkYcuJses+T3xYF9ykXvxORccydInMsqcY/WRVKqsMcJ
	VJv1RTeTBAi9qcDk4OaoqXQSFVAhHmTj0X5ZakIIy8zsX3wNKaLn0DLx0FbzCezvrlPhzx
	tMlC0mM7tRyfAI/fEuqAa9yAMQccyBc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QW7MK1KM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F6C644D84;
	Wed, 11 Nov 2026 08:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E491F00A06;
	Wed, 11 Nov 2026 08:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384331;
	bh=/GSWuUudINQ5InmDwWsy8zWhwr+7Kpnc2mR1mJL4+KA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QW7MK1KMPShmXAzj2tGBuE1vD3/CnUjJJ6qz1x6814x0dF88RS2ylZ3oJGCJXWldl
	 oCmk98Qi2QHSbNYVhnD9ZYNfgT3mhaWRKSEXXHWtCRQHb81g1edSgty+bDEAXPjMXb
	 f2/15FBZNATOuZsxuXJtN7a24+G3vHnH9k0HGG7q62QmKPCjV0zRedYRvAKLUvt1dZ
	 t1UfZbr1OFwF+Fm7gcNyaT99SpdKSLOcF0K4IOG6BELRlA4/pZWDxY+2G264tU/YWG
	 UulKdXOxLH0wx8yH08+Ct/GNXMTPS3DgKrcax3Zgz0oChXeTaigr28d1hsFazZJzf2
	 OT9H6SrQywRUw==
Date: Wed, 11 Nov 2026 10:05:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/memfd_luo: don't use memfd_pin_folios()
Message-ID: <avQhxo-dVGdvcHK6@kernel.org>
References: <20261103172251.2348370-1-pratyush@kernel.org>
 <179381215936.28814.9050829645096838793.b4-review@b4>
 <2vxzse18h9j5.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzse18h9j5.fsf@kernel.org>
X-Rspamd-Queue-Id: 6373B14000C
X-Rspamd-Server: rspam12
X-Stat-Signature: kctiukk5qsmx85kb1mo5zpe8it5oz3da
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794384332-758385
X-HE-Meta: U2FsdGVkX1+nQ6PnF3+oaZUswODtRj3tZrCvzSljeMz9vsL/C0g+/J9tz9+e2nxJnRSMp//YhczfS4bFJ/L7Nuv6F39fqnjwwVo3FjQlVjgquY9AFwTlaDBtlO0nGcm5zW0Xn+1vMhmoFVLYj25ZMxHDpIiKUuDkw1P75DgmEP8xiD2KCJMMD4vWGzbfhV5MQ0qYiEvWbD2hluPAHrRRIsSZip5I7g1HkiO6hJRPdzz3PJjIznsU8ChVEsKHz42AxxY/QfHXWmxwG+tUv+n6uX/vdjA03lqqWcq2m6YON6SzvBO+xZ4GyNpwseTALIpKOvpn0LDyFVLrYIae8pghJFOzozMFGF9pfj5MNbgZK7fOXQoJnPlMRpAmENILXhfhQY9AorNS1aJ5LOsP8S0Nipdaes744kytQIIZK8J9uv8Rt9vMKDnoVqH3k27JkNJPKkwfAWnUbcV5uPcb0a/e5I/JFsxBcdXV9N7PX6c9iWvbr9Zn007C0lS4cojfVHEYwYcnzQ60UEcAsFfyaU5igqjGvS+v85IGV4LdZE5PWFMyo5/Z3rCDbOIDTIZigr6bu9+gi1n8/cCfhWllTcKOviKxUzXKC73/bKtamOfQW7LZP0tOvbgxAazhI8YM56WkoHI2UKNzA4Tj2Er3qWInj3VTwRwDFmY8tgHsDRrbylyP1mwu4Smkvptn8IW8xzLcovsL68tu1skgiQhQfOc6nyYchJGJIwNv7VlYR9eAfR3U1beC6tyRkVNZPvklhk4bMIbNKmdLUIVRuCiDn22rkuGbq0kEjf+GrHThTiIDoPsOmRiPyJtXro6DN6N7sHqKGCSszzlYJKFS2kyh8F4QEfjDggLZFS0lBrTevELRZnwNrs9HjXUzZMFZjq3W5ZNP0ltYhT+5nNp1l3A2y5DAF1kHz8bY9uq/mMq0g4e6uVTkeqTO7DmrBm6OwW7w82BxO7k4UUMqSRNWJdIlZJN
 P5r0eDsW
 Hvo/QZoOkDXybzNo01WUH4SDOXlRRVIe5V4QAvh940VrASxU2aN1SGL7/f7bXYgsRnECnuRXjsnIJLecs1mptQf3uNEgV8jHgI36Dmy1hO7XmpfL1KFlrdWE9AsUWOML+8ngtqQdRI8QfhBpFjT2jjsdAW9vX/2LOd5aX8Bq6AeITR6/jLaTznUG6UiOKaKQ2jBrTM4c5yq/HfUyhwsAyfoJv5FkigLTQ++DKjXzsnU9q3da+wBs3R1Yb4ummDLu63rfM7agYAGEV+nsi5d/rmhEriOU/mM8tQVlma4p2dYpefaGD4rnedO8+tloXslbw2r8QZtqj2rTa953qyrUMmFukzqpB+Mrpw4rt0lJmwa2izUWVX9Nhabfl5YNZh3IRppEmOSQ6hfgkkBMzsVCVigdkZtg4Odxny09e6jtHkIypsgwNK0ZauEGia0yOpLKRJQ1j1k1x32NxTY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 06:38:06PM +0100, Pratyush Yadav wrote:
> On Wed, Nov 04 2026, Mike Rapoport wrote:
> 
> >> +/*
> >> + * Move a folio out of ZONE_MOVABLE or CMA, so it can be held until the next
> >
> > "held until next kernel" - here and below - I feel that something is off
> > here, but can't pinpoint what exactly.
> 
> Hmm, perhaps this:
> 
>     Preservation holds a longterm reference on the folio. This would
>     block migration in ZONE_MOVABLE or CMA. Move it out.
>
> ?
> 
> >
> >> + * kernel. Called with a reference on the unlocked folio, which is always
> >> + * dropped. The caller must look up the folio again afterwards.
> >
> > I'm having hard time parsing "called with a reference" sentence :)
> 
> What about this:
> 
>      Must be called with folio unlocked. Drops the reference to folio.
>      The caller must look it up again.

Ack for both :)
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

