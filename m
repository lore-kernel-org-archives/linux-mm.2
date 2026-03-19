Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82B271088E71
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD4F6B0564; Thu, 19 Mar 2026 13:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83F86B0566; Thu, 19 Mar 2026 13:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BC26B0567; Thu, 19 Mar 2026 13:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3E1C6B0564
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:38:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73E8CC22C4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:38:59 +0000 (UTC)
X-FDA: 84563523198.10.D1BEF64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A9C60100003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:38:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AwsdLrRj;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuEjoftA1+hiXPIV+9bi9DU3ZElxVyYPyAtLVA/TK/A=;
	b=u7eYgujFMlxby9mxYfS3c8b8ZFMafp5BslS59HQPZWCjaYbAOgnkKy5K/H46hSdOUWa6KT
	LQyNsFRl9LA1yKmkJxoZqdrUlu9MRYBUU0t5RVNpQ4ziklL90fztnC7v5T1xJqKg99ExCw
	O40VLPIW8S20vZc4a/SE63slvUdOUFY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AwsdLrRj;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941937; a=rsa-sha256;
	cv=none;
	b=ZTwBIfkL+BQIyzdCy+FTJyMSYau3HuUWXaI8BghtxwbS5SZqQ4bePu+Ik0kEFzlnemD95n
	KRn8vi5CX7HAqz+zItQJZnBR38RYq6sr9G/yMKm0rUIxwkDW/c2wYV0YeryzpgFXpfuxm6
	Fva1HsVuxNr/Fs2gwFkA77ZoHOoLwiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82C9640786;
	Thu, 19 Mar 2026 17:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179C3C19425;
	Thu, 19 Mar 2026 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773941936;
	bh=Hivr+4pDKuDtiIkYu2gbJDWvORBSel+6FMp1v9HmeG4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AwsdLrRji7S/5bKRIRoLy9oMGfPTq7CI03hWA5bepga8vECo4/3RvNVeYeizQKIwW
	 R9UN16H8ZaF5yK8yAVtizkZh9zEgm8LSZqWA/t1UeGp3EhNubKGLgbwTBmjS9ANHPQ
	 CKr7ivIecBornjtAgZMvvL1T+6+bs5ktKzdaTNRhc0LyaeH1C0j44VGifmhwvaAXJM
	 POmn8ELyxElL1bT/10KjExBS16LBEqK+xysiliEZ0LVwQMpB+qDKVPe4l/rYse1i4L
	 PzUuZBXSFeyQ5M9ynh9jcooBzTBMkDLSF06baAlOeNctRGjpEyjMmt7dSbkQmkwwU3
	 AvDqZkxp71zew==
Message-ID: <b5f6f86a-3321-46ee-a481-23c2ee219618@kernel.org>
Date: Thu, 19 Mar 2026 18:38:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/23] mm/vma: introduce
 [vma_flags,legacy]_to_[legacy,vma_flags]() helpers
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
References: <cover.1773846935.git.ljs@kernel.org>
 <4fdffd05ee7fabe2dc313850a4300bf184beba69.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <4fdffd05ee7fabe2dc313850a4300bf184beba69.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9C60100003
X-Stat-Signature: wynz96xxyrfp9wet9fkc7m3aaut43utx
X-Rspam-User: 
X-HE-Tag: 1773941937-638999
X-HE-Meta: U2FsdGVkX1/2Oyx5caoLNy1tqOVcpqTzRzTe7Ys5ohhE+j/xJ3L8FS7Fw7nlVoa670Lib2RBP65my4Xa1meDOA8lDsd+T55qUpyGhkyNGD6579ryH7CJySIYdMJGhl0D0Ti/Fc2289I9y74mmdR7WdU2MBS1wf4dRbCUMfa5UZNNXdgEWlM2tYCEJ7ZEd0IXs3K0odRmZG22iOEwWVbDLfILKNcs4YimX/3m/VRYCVFVbiAXH4LJy7/p/M3WSfLJk6PGoS1ga58iYkxEmqM20l04WC3eGbdOokX6lb/EegtkV0tVTPlXDbKVMoTJaefkzop4YfZSzHGFi6w28rI+ujrl1DVqBNHXn4o0QgvWLam5jg7H+yGAzNwoUkRJkj1Q+9pc4Rll7LM43VSIG7t4+Qze2VIa3Cj+rSEcSba7xh6tmO8UNrTX31aQuxn4vtWaMxqf+WshAZlWNvTNzsJ+0+pD/cHQyESIYrIMZAphFYw+VRQJgWUXAodPfXB/ISssswu7YgoWNpRnhNlHJwwUtzMCFSa94NF8vXk1fx4oIp4CooorPPjtCYvw1xRmBg8aqXayF/2uWoddaYc/dnC92QDDsVFVDB4latfpJ61BijG6tWZvYUeBc4P3nL2jJpBlRMieQldNZUm5m+0MF+KsktxJiLfdBe+GTJS1Cdvva7qLJn0nNQ39SdbBmfBS7qPqAYeNlF+uvsfz6UOESHU2RFlcWBlI0MtmIxfNQFQF+fSmYX0b49IotDNC13Kq2zCFN08mrQRFUxsHWw4DYgRqx+owFZkXoUrK1EhFShC8X5BwQEfq4QfALgjNXsr6UERb//NnD4NeHsQKBFx4LyTNErqzUUXZIXHk0n7+B52++rkq0PihyoBJf7/HE6oHMTPLwIqH97JlNHZ5z3PScaxhXAIV52l3bz14hIxv5z/AOTowcLSeTZ+p5mxJa44EJP/29ysQ80gk4yXUMgXuCd+
 DQ/MOTiF
 /+QdQPahwu3ooeIgTLwLhfu72j6C2tF3ws358J2Od7U8KpVZ/j5F3Zufyg0Epqt1BY8rpHK6Vmr18CMgaLs1mitILFtZaWK51juaqBY/dNRWW2Qjbe0HQ8gIVINlw9QueUWYOjli3Ghz8StMZfjXAIkRW9H7tkMrngcdTeHi0DjqLdyy7g8gihHkAZi6SP4KVctMBFI99cUA1na9KT68sIKXCb5W3y3OKR4bgsoQFeE8FFqUzVB6iVRfKsfVNmmG41lYTYS5G9AeSgl6rRyW+2UOQnfr3CltFcG7qJ04XSAWBjIwAeZkQcBM/1tiHrG1dxDpHTJDu+KpjwubFcKL0CilQpQhNCYEKK/caAFd7uggf+bYmWi2N4M2PmAsVgZdyrddL4AJ9HHKkVwA63/Ud/tQHOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> While we are still converting VMA flags from vma_flags_t to vm_flags_t,
> introduce helpers to convert between the two to allow for iterative
> development without having to 'change the world' in a single commit'.
> 
> Also update VMA flags tests to reflect the change.
> 
> Finally, refresh vma_flags_overwrite_word(),
> vma_flag_overwrite_word_once(), vma_flags_set_word() and
> vma_flags_clear_word() in the VMA tests to reflect current kernel
> implementations - this should make no functional difference, but keeps the
> logic consistent between the two.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


