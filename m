Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762FFF01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED2B6B00A4; Fri,  6 Mar 2026 07:43:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B156B00A6; Fri,  6 Mar 2026 07:43:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D046B00A7; Fri,  6 Mar 2026 07:43:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A63166B00A4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:43:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AEE51C655
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:43:27 +0000 (UTC)
X-FDA: 84515604054.01.4F23DC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B70431C0006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:43:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9mC0Dtb;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772801005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWdPDMTwGM6a5JRcgYVSuAzDD6OQV73Y1dH59k1txJQ=;
	b=cJUgC7QLLdMjfVeAyxf3pMuuhGStAHmt5e94PXx3CcVLRTk7qqyrzd4Ltiaj5D2PciOSAR
	SejlZD3TmCgsKsfvO1Ym1wZxqr4nv0jgPLRFdSuy+xYuR/asamrDfv6X7TxgTVkTtl9jKM
	DDo/MSJLUxWe9R505Tcu06hnz9Chgn0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9mC0Dtb;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772801005; a=rsa-sha256;
	cv=none;
	b=RiLYfKEnAjsu1D8WKP6RfTJCz6rT9uP0uPDRTJL6+SSXQvi85GNpgYArmkoRTIADKOymil
	z7RkD9lFbW9wOqldKIdDusIqtt6fNSLKpvUJ0D9IsPMlc+YzycJ+a2qrLFqDTeO0JoO1rw
	YP8QZ2WBW3xSmRSv+8I5CpWhXJMcfUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C43F340571;
	Fri,  6 Mar 2026 12:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149B7C4CEF7;
	Fri,  6 Mar 2026 12:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772801004;
	bh=laI5Gks8UKTtQyxqn7mx9nW4b8iCTs15iKu2otVUFHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p9mC0Dtb5HP8pcPpgD7riizGZNEqblFXhyCBB7gyX3iYqVlML2IEu/E46TQAfJ6kB
	 5ES8F1tVf64ZhuAJ2vES+zOK4kRMzYtKhCjqesskIYnO8sAKVgRvaUWEnRMwLwSDQe
	 6ozGy1rqY43AQN4mamdsvpi0UFTEWG/1ua9kPc8CcoyCTro7l1nx6xbY3HJtSjDB33
	 HoXIf0/JjwlmXYcHIiJHIJDR1zTA/RgIid+TR7+6DmUz/5MSsmXaWj5qjtxVswmSpB
	 y7qIWK2NRTkB+QK0r3eC/5U81n1lw5TgFlHl0zqxfvXpiP2u3XAAAbXR9+cd9x48Kv
	 4L7tL1NMHpRqQ==
Date: Fri, 6 Mar 2026 12:43:21 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 16/16] mm/memory: support VM_MIXEDMAP in
 zap_special_vma_range()
Message-ID: <f2a7bdf4-8db7-4101-b7c6-3f5d9c20e078@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-17-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-17-david@kernel.org>
X-Rspamd-Queue-Id: B70431C0006
X-Stat-Signature: x4zwkmpcb5oirjxdfmbbhiogs3pcyxhw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772801005-262467
X-HE-Meta: U2FsdGVkX1/L6xmZ9WPYEuutZAB5Fn5lx65RbaBrDr+up8WFWoBmdDXFQo9THNAXHtp/dELwkSy4paJOvTv6+ZGZopEqrWLELKgz2EkDJWE853zY/WCg+rL1ZyLAqWm57Xdn43VkaMPXiTOgqrsw26eZNnF/YXSmql24i9ucYHDZGhoGYCKDrr21x0bn3Bf/IKNhADnJSQQWTsIEwS+ymB0jHTMc2gNnXjIjzJgbNCRJfP0P5r1Ql7uquYXQVsk9hL+6CKpqCiT1P92SJ5WtJbKCCHChIfaPFi9x+tREl9u1ubNwjK1ktNGRBR/uhyrU73fbsGqt0QNx9rTkLML8Y3Wfkd3TrY4ehwHPyvgwfd8GMEP9F1bG2B665XGS9veQ0FZqOxjMk31VJ1cktrKsrQMv6SUvdIxTJsxEy+QEwEs1FKFYlLsk5OuvetpZxfDxkLaeAsuy/grFCqzCHhZUsen98d5SBPfTUEuNoWqhcsBHoamWPUuSUNbaghxY+n0ljyD6yplleFl9MmM17QwKkT2kns+4UKzQTi11JXghYU5ifcHPJvq5aZ96xdlz6lva4IhHuYBtA8GPtlp/NpZ0EICb0xmVDXCVA1jHk6ihMavXnY4lPFYo5Qh4cps5fL0G7USvEq7ym2/RmD68YU+nIDXejWEwvJfZ+iWhzUa5WdV+N05czCULIQxXMzYTgFLaEolg4Y6vfEjk0vtJIDWsVSiPj1tc/UsAWZmJkz08DLZqmHrlCVAe5HWYbHAt1UFGeQES6YEFVxBpl0L35ofvublEZoOuSrlPn47LYTWFjtJjaON3LyTTgUb+fkYjaFe1sX0botPvm8uA5wnlmnwWV1JM/P/ZVVKkuy8h6IA9D6jOPZRhMHWSG7Vf1LjlHmPCqeORxHsKUBLAogHj7Fa4pwCZRl9jDJiLzkR8ZriJYQhsQNF+DGUtg2rb0yCdz6I5T+5C9s8UVbbmEGwAHsA
 URjenKKe
 CdOz8oM8SylUdpZ5aUk/RCN4P6FNn4Suc6Vc+TX0QcCUu9iauv3Wx8/XniVQMyoaa8yKOW6JOZNoIKmDS5MCV1XRvWqBO6MQNWKDPyYRlOwfj2xvWr1UBtG0iiHfWZu91zRi+0yzYP4XQfDtMXb1PDIhFGHL6niWdD6x+EXatKfW0vYrh4iQhkmYa+zW9Sm/o6d56cbP68kO1Xd9l4wnehkh6h6dfMFrKsqNuvgXygNk9Ekk0TcC1RT/JKNA/apJBkCjNOZ4vFA1ocyYmGWREKnGfp3KnX7YBayvu1Bzlo+1lGP5bNHzez2Jg0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:47PM +0100, David Hildenbrand (Arm) wrote:
> There is demand for also zapping page table entries by drivers in
> VM_MIXEDMAP VMAs[1].
>
> Nothing really speaks against supporting VM_MIXEDMAP for driver use. We
> just don't want arbitrary drivers to zap in ordinary (non-special) VMAs.
>
> [1] https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com

Dude, you have to start your indices with 0 what kind of programmer are
you? ;)

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Agreed that there's no reason not to allow this, so LGTM and:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks for this series overall, very nice cleanup and I was frustra^Whappy
to see that there was nothing major or really of note to comment on here, a
rare occurrence in review :)

> ---
>  mm/memory.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index f3b7b7e16138..3fe30dc2f179 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2239,13 +2239,13 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
>   * @size: number of bytes to zap
>   *
>   * This function does nothing when the provided address range is not fully
> - * contained in @vma, or when the @vma is not VM_PFNMAP.
> + * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
>   */
>  void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
>  		unsigned long size)
>  {
>  	if (!range_in_vma(vma, address, address + size) ||
> -	    		!(vma->vm_flags & VM_PFNMAP))
> +	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
>  		return;
>
>  	zap_vma_range(vma, address, size);
> --
> 2.43.0
>

Cheers, Lorenzo

