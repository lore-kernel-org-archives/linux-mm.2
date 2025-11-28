Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518EFD116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 08:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4026B0012; Fri, 28 Nov 2025 03:24:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94716B002E; Fri, 28 Nov 2025 03:24:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D13D6B0030; Fri, 28 Nov 2025 03:24:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBAE6B0012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:24:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FDF2C0484
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:24:26 +0000 (UTC)
X-FDA: 84159328932.13.5B89778
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9DFB1A0007
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:24:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=twHtpgRh;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764318264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXW7UNXJFYx4G9lq8NN1HG+QrUM+GUTQsjvSKu1sfEI=;
	b=1xlA4wEiK0ZC0N+pgdKqlN5MGqWCx8K4NTC3cCvqdhQAlIB/l1QxluD8jXJ/a6L/OTLgYt
	ly6upfqfFlXxpPpOjSCmV4nHqKy4itkzWSoxlNqKHRdHDnRGm+6/2tsMzA0PfvGs30nV7d
	dH1UZvEXTjKdLxv+4f9fB/HFKd8eNNI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=twHtpgRh;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764318264; a=rsa-sha256;
	cv=none;
	b=YO1Zb+nU6SevBtr8uGXU6iDBPYK+yu6XtZzHSl2+2J+Yz8p8B9cESfRN8eVNvzQGTk1hAX
	j+bePuFFrDwM7vCarBrwosu+J4g8a3ZbMkc2txJvWhnvVcAvwnZQH+l6O1HmWuu+r/g4nY
	TPyPRIx1u5YJVTRgS4E0Qe8eppk8rME=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1F3940315;
	Fri, 28 Nov 2025 08:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0723C4CEF1;
	Fri, 28 Nov 2025 08:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764318263;
	bh=TxbNUU5rEWpRsji0Fkm5s4PvabTJgP9dBBi/HLey9tQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=twHtpgRhhqE2tes1gOGyLCWGfpBFWRDX4cC2jloOgeNAgnHcsJXK22YYZNRKLZqVO
	 KC5JktvEpqre7T6bIsziqWJxGC8KoM6qVMgKK59bYLUE1AzIyg9CNOb9hC7IPTiMBL
	 W6HdAYLuASAw9xkkC+jfmsgPyODM5VRNFMhHBzZxCnTvsa7gAQlxnzB5do4SFNZAiR
	 bOmkUkzx5bun2aKrKsXOZ8HTij4aGIfQiTU32nVQfyXBVs69qIP4Os4+HI76J3NoKC
	 YijfesC/QO8JXGq2zeqH6BaftFiziXAaJeudYSE3BY7TJjYO3b1ob7sr31+15N13g+
	 DwIU9/pV/9fqw==
Message-ID: <189ac734-b194-4b52-9752-18d8c0b71377@kernel.org>
Date: Fri, 28 Nov 2025 09:24:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] powerpc/pseries/cmm: two smaller fixes
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20251021100606.148294-1-david@redhat.com>
 <557b5500-412a-4d26-8c4b-147c9a00d5fd@kernel.org>
 <87zf86n3vq.ritesh.list@gmail.com>
 <3cc7d401-c77c-4ac8-abb8-c264fbd9aaf0@kernel.org>
 <87y0nqmwaz.ritesh.list@gmail.com>
 <a3bb0e8e-72c9-4a9c-b347-e899ae29b289@kernel.org>
Content-Language: en-US
In-Reply-To: <a3bb0e8e-72c9-4a9c-b347-e899ae29b289@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9DFB1A0007
X-Rspamd-Server: rspam02
X-Stat-Signature: ucgaktfms4mm64fki7i3xjhz4aih9wrd
X-Rspam-User: 
X-HE-Tag: 1764318264-410659
X-HE-Meta: U2FsdGVkX1/ohNvAdfQ/dEyJUQQsIBLdPnPCTZHqHa2W4OG1vNuEEeJYaLO3aekqu0z5s8aDV7QRc59A+Jfg+bJYeTnLvMUBQR1B1Fd1Eo0++rKqs9yKLEO0OEhVwP17T3fH3cRjQbhzToKyUm9F+WWN391R8O9GcdMXBfz8vGhzGrLMt4kxY1VRbCw+AVBszVVMvDslb761aKncOeCJVwKnbZsco2OsSIsPUNipZYLg8zZ5d8jeFCwfqrU47c5huhNoITC4danJ7qHD9tB3T5yJDARwe/dp2IM+2bvMrrOqBik0sY2yx9Ol0e9oMO33MEHRVziwFbWLUKGkPH/ANTv5KrPHUect8Jeh7DmmCLjCyrSst6E+e7DaGNXuCTwG51Ypw6rUc5F83fDcaWb9Im1u8N36Ta/B4sZbLmh645JwjXf+e9nyHJqSwDvjYUGQl66ouoPv6JPXra260l8Sc6Hk9Y7j7nRFBDun1Nrnb/C1bVHZKUWQIH6GNEvXp++ngLv7MwWiaukV7/vFOYUrnXG1YTyInR2iGSLWXPd4ed4FmkSAXW/KV/e71oXYqChXq1hvr5LGR9DC40KIgCTrl0YQW3H+F/Enu9BPqq2a/ofRxa38rCtG9DZRdVHw5OLi1Wcimm4cHQeO2RQkJlj8hlpvqF9OMyQFyMkLydWT4Iq5nztBxPJCXgwELbBCRl++YXbxbdetBr9PkhUezLX00YY23ZbZlZ/1hj/70wHmztGSqZfkTsZ2m63GiL4PUKKjLZMuCYU1nc0bumMfJnD+R7fzyO0YJP4XCETwJV6kG34OcMOveH3cKB3v7EaUwRwRjFhqqzCQWUvYA4rfxoeOEyJcs+ujUd0+yDYNF3kRzbVOheoa5glWhkKe/UJfk+fbSRyWV0JkpmKA4iwrSWpM07lImwh5lxbcnmVq/jkHNeGSE5s9Lb5tZ9SfWTM1Is4K2rCJritAj6gU+cEW2xo
 lcA0D44l
 Jt+kZp++RtCBOrF8ViSy5PuxboBZ1lTt8zJmd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Right. Let me give it a try first with pseries Qemu. Otherwise I have an
>> access to pseries LPAR too. I can verify it there.
> 
> Ah, now I realize my problem: I tried with Fedora 43 in a powerpc VM but
> the modprobe didn't do anything.
> 
> Looking again:
> 
> # grep CONFIG_CMM /boot/config-6.17.1-300.fc43.ppc64le
> CONFIG_CMM=y
> 
> So modprob'ing won't do as the module is built in.

Right, so doing "cmm.simulate=1" on the cmdline in a Fedora 43 VMs 
properly creates the CMM device.

-- 
Cheers

David

