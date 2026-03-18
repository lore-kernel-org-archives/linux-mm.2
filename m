Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3769103E17A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31CD6B025B; Wed, 18 Mar 2026 10:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE34F6B025C; Wed, 18 Mar 2026 10:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD17B6B025D; Wed, 18 Mar 2026 10:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA5826B025B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:41:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BD275B1A3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:41:01 +0000 (UTC)
X-FDA: 84559445922.22.1132B94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B85612000D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:40:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ngbdPPAx;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773844859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6SQBnbLtk/tDiFJtuG2lyke9l9pURsRfwk7gcmlJ5k=;
	b=b+48xM3PBuJp/HIxsq4w1TtBfvDadh08v2I0rJSXReWV6nBdJ2sv87nUuSGJ4r50/9UIVj
	ziqPb1jXADDh0Ab4lTNrdkOaw5LALgLOurOZmKDPBTEiTZapEp9CmktkvKxW/vbXU8P1hb
	qtQHXsLVtQ3/MIzPlwsMO42N5lgG8p4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773844859; a=rsa-sha256;
	cv=none;
	b=QzOf0R5crpDwiZWsbEzWXycy1zRvlRPU5LB+/W67DEpZOQiUw9AkI+48wEwEQ5HsbzPkyF
	rA6jQtDpZ8xm4L7Pb6gsdekphbdU1MWGAgbP33RRxAWQGl++0qvY8kMdgouCp+QK1YcG0s
	G3ZTryZzpQGoxN+/PPhg6CtKXYFBQrM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ngbdPPAx;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 773FE432F4;
	Wed, 18 Mar 2026 14:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F29C2BC87;
	Wed, 18 Mar 2026 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773844858;
	bh=QPe6wXvdAXZ1WsVrzW/I1Ea8rZgbDN6tCubJm34Z2So=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ngbdPPAxWjFSAiZvMouaeaCI+yNsZe/5Ks8XfwK23bbuJ+JwMl7yKx8wLk1AN3mNT
	 TMgJMbhcekeQl6cZDmfGyt8APhVYsofGCMvUz7w5d4VSUqCEDHmA0FWwHmr908obc6
	 Ca6I5aFuRQUI1yi4z3tpGvtErfL8rr5nKPdU3xQY3LcDhPRgWknRM3aO06irdxNWBm
	 2TlgtJ0ipwGbJWHORKvyo/BwbM/qZgR2EjBk9w3ApuIqc+XrUbVpU21pCoE11NYSNq
	 L1oljmENCVJ0s9YwPt8FVfCFDTEwjEsGgigo721LFalxDK0WN06IRwXdh82jFvxUSk
	 UiZTvvvmHDYJQ==
Message-ID: <4620167c-bcfe-414b-85f6-a5d28563b9af@kernel.org>
Date: Wed, 18 Mar 2026 15:40:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/23] mm/vma: add vma_flags_empty(), vma_flags_and(),
 vma_flags_diff_pair()
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773665966.git.ljs@kernel.org>
 <ede9b0f8a2e2dc72e7fbc1a0ddbeb513364c28a2.1773665966.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ede9b0f8a2e2dc72e7fbc1a0ddbeb513364c28a2.1773665966.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 39qoic3w3d9bgopc1tjnrajymrf6gaad
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B85612000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1773844859-900115
X-HE-Meta: U2FsdGVkX19Vt5xGlUNkBhMeGBh97h+Ip/4YKvGYd7jg/GmJA/0Dp29DcePqVdI8V2t2svpkOrho/eujMPPp3t/MqIwUpGQbaBACiHSHfLK4N6Cp01+JXJlaBF7BS6UoCBGHTNnWV+yGpHBEOZ5zNXywRoOw4J1IflH56Bx/qnRltJE7kjCfY60NoadiVu4ApaZIlgEQAwL76YH7g2RwgR1yNEqrw7EzUEOmTw8RoP6x/BsShpITNI4qY/CZo2KjxtGdtc83U2sBREqV1Dp6TA+8bbjk4MVWQMFNCGZROhv9umv1C2xw+8ucn/UPfYjKgDZuyB1feRSoj07/hfiAd+FJRlr4M+2gRmMermFsh9MH+OOy5DFFvnT5xBIiMdi2FEgII1Z2+tZaydW4hHWE8hcaLYZM2SCJU0QLYLHl8NHEClyibZQKK1G8dZlT1fXyqvpLteJHD0fNXPLqz76ac9hw48aAbgHhPmm0ZtnfO27qi15DcphPwYoBUpUEWWp1dX+Jw4UTdf8k/NpFBXyVYTkSTX8MOT3dB8jLmWnyewfULJ6PGnUDo4f3EY/oW0F3Y6BTvThm9+3lyODDia1V0u8WR5OrWg7bqbkyjfRNUtBr9UyfN94dZNR1rCVGj00Lm/0GtWyQX66M+f7IeJkzas1vTYE/SpmZ7LZhSNxwwipqUg71keRoWQOH1SlDRvsEkZC17199f6sbRN5Dw2CKwWBbUL3WWCuAl7+1oiVAZ3IARK4lhKYw642eybZy2dN24P8CUUa6Ou/qoSEcWZHztnNe/4z5pay0iXIttSWKTRdzPU5qUnyrtASf0+2nyLdlo95v3d4xB2yHchmU2nkbjAyws2Wdb/zloRQiWwLhfnMqcrWoXqOQoGRkbT/iKTrl79oRtc+YTH/zhY9WxKJBBtzlnKxzDkqGMNJJHMd2LfZ+K53lrxfmG5nArz/+eY+RYCZcDuD/IUG0Ldu+huL
 Oktpp48n
 cz1FGc1TRSRJTYQbZFgq0OKvxl9hl+IBmiYfAGsQLghI5htpPLEuvuCzVNXrJR9pjdvdrnsf1FpzNlD9lXc0yRGEZq9v4rWjMBKgPoOBGcBGo6deih86pwpZO7EUKMEuxeMdtrU32vSyEbSkSs/1BtIcYk1JgzzBp2nY7LH+o+mL2ouPCRmkp1NWUdySICryM3tDn0TGYheQDotqT704CsXMIO6+UXgkiTH42xBzHoe/5RbF2R6gr4UXjg1ujyVK1UshrHC40Dlnl/hQr8uiibNHsZTeFH9qxbRctaV5FuVj49kls3D5F4LCLg4FHwMmJ1/ezaOeq85Wa1kOgPF9wXL+vWQ9syfUkMS2AsbbqlixXDXi+wZQ6sToWNvhXxNGS1ePsDzqaXXD/zd8HGSRxTF7eaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 14:07, Lorenzo Stoakes (Oracle) wrote:
> Firstly, add the ability to determine if VMA flags are empty, that is no
> flags are set in a vma_flags_t value.
> 
> Next, add the ability to obtain the equivalent of the bitwise and of two
> vma_flags_t values, via vma_flags_and().

Nit: "two values" is vma_flags_and_mask(), while vma_flags_and() takes one
value and list of flags, no?

> Next, add the ability to obtain the difference between two sets of VMA
> flags, that is the equivalent to the exclusive bitwise OR of the two sets
> of flags, via vma_flags_diff_pair().
> 
> vma_flags_xxx_mask() typically operates on a pointer to a vma_flags_t
> value, which is assumed to be an lvalue of some kind (such as a field in a
> struct or a stack variable) and an rvalue of some kind (typically a
> constant set of VMA flags obtained e.g. via mk_vma_flags() or equivalent).
> 
> However vma_flags_diff_pair() is intended to operate on two lvalues, so use
> the _pair() suffix to make this clear.
> 
> Finally, update VMA userland tests to add these helpers.
> 
> We also port bitmap_xor() and __bitmap_xor() to the tools/ headers and
> source to allow the tests to work with vma_flags_diff_pair().
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


