Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B9011090256
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A4A6B0558; Thu, 19 Mar 2026 12:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561476B055A; Thu, 19 Mar 2026 12:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49EA76B055B; Thu, 19 Mar 2026 12:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 393CE6B0558
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:50:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6DEC1B707F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:50:26 +0000 (UTC)
X-FDA: 84563400852.01.9F79004
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4FC9C14000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:50:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgTWHgcw;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773939025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySKX/SdqeoTiP9pwQcgZ94qbw5sb0oTPtV3x6ZUzB64=;
	b=VrQFzOfhVjdorxFT43NKtDTO3UuiHYFO5vM4szRNpfv68/kJu+IQAEO0j0lmKiNb8zwoQE
	vhWXdCYCy/jTn1UKMuVx3BW8qiyTOOB/FlQOPcWF2gni4HNwBO4JjTfYSCScOi8wP3/jfp
	uRf8br/Iju1XQtkSZ8W1fe6HK9Ka0DM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773939025; a=rsa-sha256;
	cv=none;
	b=QTV+1v7iOpkFlytd+5Opm5NnX6jStCSV78qoajbCw9g9UuiFKEKBwgJ2uL0Sb3jvYZyGtk
	jc+DPLXhIJUsfMWKWy6IFG5iGYHjDxS/lPjHXWFVyBJ8gOARnd6yrgki7YrGVh/Oo9EN8u
	P6h8/OEzNAqXqFJ+W3ByuzVExKHwZ6M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgTWHgcw;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AA6760097;
	Thu, 19 Mar 2026 16:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41945C19424;
	Thu, 19 Mar 2026 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939024;
	bh=ySKX/SdqeoTiP9pwQcgZ94qbw5sb0oTPtV3x6ZUzB64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YgTWHgcwTFKs1gBYxdYW33eFt5gNoD63sWPX8mdYVejWbKUuDdrFkJsiURNl6lSLi
	 XYkJpx/wRyyEkQGRCONtUVwp8dlhSmjpJmDCO67CtepROdANquLF914vAvs8F03t4f
	 bTPzUwW9A/1agL8G//3eqOLaaV9TNMSiL0J0t6/c4zk5axQdTYHz2ZOVPKnbSwlk6K
	 qocxlmnDCy6A8nO8NHNs/bLSd9OhmFGiAmqwSf3sFUuUX0nCndmYw9sGuphDXOX2tS
	 i4TA+BApsD8Pt+tqXbprswARO/rjXi7FaX5y7BenKplS9DF3okpkWVua6BEbY/FEZi
	 KOJGjMYMEW9VA==
Date: Thu, 19 Mar 2026 16:50:08 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kees Cook <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Dinh Nguyen <dinguyen@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH v2 01/23] mm/vma: add vma_flags_empty(), vma_flags_and(),
 vma_flags_diff_pair()
Message-ID: <3cf675e3-d333-45f1-bcf9-466c7b16f916@lucifer.local>
References: <cover.1773665966.git.ljs@kernel.org>
 <ede9b0f8a2e2dc72e7fbc1a0ddbeb513364c28a2.1773665966.git.ljs@kernel.org>
 <4620167c-bcfe-414b-85f6-a5d28563b9af@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4620167c-bcfe-414b-85f6-a5d28563b9af@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4FC9C14000E
X-Stat-Signature: nsgjd9h397ij4iatfxatsqaurrdsf7rc
X-HE-Tag: 1773939025-720559
X-HE-Meta: U2FsdGVkX18toNcvQzej/lz1BnznAXqly0WHbIOLL9+SjHBn725F/dCvdN2WiD3u+MfFtfdqIAseSVwg8LR6W0G1MQAaZ6VN0+apZ2T3mCk4Zfa1OoCwTW6Vjup3iKmPkRXyLYM3D0VaQ152MR5R7ADUI78uYjd+Ys1tdIHy9GPB98ax/vJ/3PbR61h0VyYkDJ/Fsm8hGHy0EA4kIoPqbduUpox0NH1osYM8w478WD8C8LSnzHdwTdr27RvCzAgYXMzqsxgSjP9vNAI5wyriKNUW1nYsdcwulgrcUxlZ6V7ZpwfHp9g+VkCx511luG4NChzurtmVidx5I/WiTsq3lh8gtOZf7vNYiLec1qKARkMyqIVz2uYALp9AIcN/yi03Jx98nSsGX5DnlBaOuy5G6NYiRGGgC6AL3/90IeJ5XjhyLFhwoS1y+MjrZ+wg/LawTO8NymGzdqnNEmspw2gR1COoFIAC65QT2Eq/fZpJ5aybdsYwtTxpCghgdYMg+RVyM5MjzOS1KaQsqjDDDtKF7BFcYqYZvTAdB/jWZmHzAFqQEzaGpV/yYhiWkQ+l9uyDTjIBJl5rDW9i68M4FgueJiQCv4zJsN566DHFi0/kqfdBUj5yEd8poXaXZskRGXESKXX/eYrDgVte/+IIkN6uM35a2qnmvdinLsfDeJ+7hc/Z0RPr1xxeTDh/a0JXFk3Y6hV3yaWfGnpTqd44syJq+A+4YoRVTjhqhCKpVUgdJHHQ7cqwaQ7cRgJG0UReqyLsFUQGeuaiaVaLhoMd5okCqItD55ys4v7k3Gljz1fV1ePhtHgnIzR67P+hJRQmjwT6Xj6S4n/h3PG6VcjrVMX6545++3V9cP2aEyYk8XcniAcgtnsjyRcWsciWai4sPFdKXlM+75C5bRxJqduyH/F/ga/r4ka+ctF1nlpgsPQngW6Fv5ywHh33EN3CaP4GuDMioD+bd738HOZUI65P8D7
 JsNFK3H5
 H/ZC2urBz0Lh0njKNdEOnfaRqnL1Y05kbAF1DC4kPZigfRspdyO7WTVrU8yXyVFtnRMRApl3N9HRrk/77Z3kbADETmHf5vPDe2oQL8RtTC2H5tTOnY9cNz/gyiH+8WuaeWlHi86uW7wO78zkXiyulHP+5b6RMtQrQ7b8OqU0Maaf27JV9qC6H0ANbMXXd6o6o1oiVb3ezy2adRhg1/DXNamjIf61KZHbqjKwK/sIt5o84/CxPv6b2rgUqVqWPFL9t4Yiam7h6B/WllsbVB1ulyGtvCa4P1E5CUQtZbnhwQrwPw6zRqiU3T8W/Bucif72/ZHkFxlJ5kGqnnDy7zC8wf+79fDvuaOr10nzi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:40:45PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/16/26 14:07, Lorenzo Stoakes (Oracle) wrote:
> > Firstly, add the ability to determine if VMA flags are empty, that is no
> > flags are set in a vma_flags_t value.
> >
> > Next, add the ability to obtain the equivalent of the bitwise and of two
> > vma_flags_t values, via vma_flags_and().
>
> Nit: "two values" is vma_flags_and_mask(), while vma_flags_and() takes one
> value and list of flags, no?

Sorry missed this. Yeah should be 'via vma_flags_and_mask()', or a better
description of vma_flags_and() :)

>
> > Next, add the ability to obtain the difference between two sets of VMA
> > flags, that is the equivalent to the exclusive bitwise OR of the two sets
> > of flags, via vma_flags_diff_pair().
> >
> > vma_flags_xxx_mask() typically operates on a pointer to a vma_flags_t
> > value, which is assumed to be an lvalue of some kind (such as a field in a
> > struct or a stack variable) and an rvalue of some kind (typically a
> > constant set of VMA flags obtained e.g. via mk_vma_flags() or equivalent).
> >
> > However vma_flags_diff_pair() is intended to operate on two lvalues, so use
> > the _pair() suffix to make this clear.
> >
> > Finally, update VMA userland tests to add these helpers.
> >
> > We also port bitmap_xor() and __bitmap_xor() to the tools/ headers and
> > source to allow the tests to work with vma_flags_diff_pair().
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>

