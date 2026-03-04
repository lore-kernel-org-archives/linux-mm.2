Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F391EEF8FF4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5466B008A; Wed,  4 Mar 2026 10:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482876B008C; Wed,  4 Mar 2026 10:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385116B0096; Wed,  4 Mar 2026 10:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2560D6B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:26:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7B2B1405E2
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:26:58 +0000 (UTC)
X-FDA: 84508758516.23.0CABC7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0BC68120004
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:26:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JNr/i9Ed";
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ki4y4qN2AdkPyZ54v2+iGGCcyOmkpCXMP9Qdm6JNI98=;
	b=y52jMCAfAAUTQ0tRsT3BG+0A+HSjK1yNenOZbozXrqjp2n4kWBcalPhoMxb2JGDiACO8I5
	PCVpyAkfgzzaaJtzS4aeFkAEZ85BrwAsYIIS/SaA22Bxzq/2TzgHNe275mkBu4t9g5QTJo
	c2EzmNPk1uNiCsUQowIpAuQZnT90tKM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638017; a=rsa-sha256;
	cv=none;
	b=gO5J0ZKUuSG2daa4ns9zzFJVS6N7ubKcpK65ApCMRWL1EQKXm5tWkesoMLnKuD6UvbY6Uu
	fhIddZBtXRfva3vT4McghPS9ykF+NzBi+4xI02IrQW6eJFRz4u9dQNaukP3YcVU9h0ZJx/
	Ahl2g3xq/WIAoF4HQnSOPpQIRYZi5Zo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JNr/i9Ed";
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E664E4326E;
	Wed,  4 Mar 2026 15:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA02C4CEF7;
	Wed,  4 Mar 2026 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638015;
	bh=NSxpkcBTxGbZfTOBI1Osn6FZchKIMqEBt4E59vgg9yo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JNr/i9Ed94o5FrVUAIdDA9j6qVGLnE5GzfbP/S1eQuij66w5wYafVkKmJfNrjW6BU
	 A1qHbzpoX84W2Y3/DU8fCgtDh/bFbsR95IXw4bDa1YKfx2KDTn+9gvVk47D5GtsPhr
	 S6XIEflAmCZI+kFJOhLUSAKMC159kKQKecuwzKR8DT3B4C+eY5YaSizaIDmG+RQ/bO
	 OTFLtGzokmtE74YQuVHwoAjC3QCWckhfGWfFxU5RuztAn9pH5xH57mKx5+7NOyf21j
	 vJcutnbWGpl00AJ4jYiuegaQaPdEVO7qzspdvmLlAaHDXjEVctpre1LGEdez5nx/iK
	 AUByHkfctYKUQ==
Date: Wed, 4 Mar 2026 17:26:52 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	"linux-mm @ kvack . org" <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v1 15/16] mm: rename zap_vma_ptes() to
 zap_special_vma_range()
Message-ID: <20260304152652.GF12611@unreal>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-16-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-16-david@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0BC68120004
X-Stat-Signature: b4eu19qoxr5bx14nc1ydiinn8qkey8uz
X-HE-Tag: 1772638016-851830
X-HE-Meta: U2FsdGVkX18leBf66Rg1NnEVxpXQDnrL+ZdrvP+UwJPx5XyWcdrXILgKUWNMKTKbiMT3rokWjIovKRuCgu9xVpDJOuE9amaNZDlUfYO8LRZvZ6mGMukc4FXrCDm/EhAj3YNdslcX1/LwXJgpUZSwfEe0URrR0XI87lTrqNyE1+anz7tTZ9CG4zhLXfMZl4fOLrIG4goUQ7qKnVjmNxmgUu5VUkgcv/3Lo3k51N3RWPsbR3d+6vD/I6BiR1KNMB0DXGnkXUZ9MBASoAMxVNlFhPvjtTGJXBLlxJH4YnX2lg601WKUoJ2/n7SeoBfxHuQNfchS82eWN0Bx6COUVi+eGNnWbQAWF6p9rWTgVbJIjuUuxcaZKed2bE9tagbvWcQT8xmsuv4ato3L99ub8jDBcYNv5bI7ZpjKuK3+fPQRGTPa7ip+v7/prou6urAVGHDCxEcxzFgA1Q9xnXribkebbR+1AvEqxVdrvv0qZodyuH2vZczu4FI9XLDr0YlTFW9RKPkii03c8+LskEu3uFPZ3hKHB6ry6W2in8cajxeqm4pbJ454+O6tyvMSX0OMlcocOsfCI4fJwQvZFYr2yZxQLoJoqACn3k/SP0N3nlGzOPGfSqh7ZBXLv9z4cpVn0FHw1O3jXHy6eH7H6jSpKMuazXxYi33EiyqXBVQk18l5Fl6+ghfRIzq23N1z7pbCJzmWYIAPBr0bSFbc6AFJ/A7dTY2MTC4MxPIF2fC/jtb7cCdqSaSgv/O3A8U341F51JJ+htpMoL9uPgU1oYc0IAuc2DMp5tN6t53JW5StaxlaaEg6kFTQyen3Ps0qI7rs8HjkSgvB7KaqLz/KqXxMRP6c5fNjAZC+YK/Smc6m295DGrJW2Wan4JqO2DMpjD4VF+e7xBNO2c6bXGZw+eN89wU7yZz8MQLeZYlC+NPpnfgE9SjtFpcdEszBu/dIkaOZ+vO0sIWE95e2SAXffMvIN4y
 y0jeoz+I
 g2Gl4Wp9WSBj8hJe8p92y00Xq5ZmLruOqBzkEf3duPIhBBCLpNjq+tstRFIoO48rwqT//Fz/5gmISinE6/8lZl9Wkhzf4O7Y7hFxzCXdqSxc4MptjSa/eokXvVil4PGW641yLnCU05L1PhPwdcqMxqpLxUATXJYZOBfLbYolf6p3FnckDRfEUYO52uH5AYV8VpeGGqDp07K8fSym5p86WQUT1H7OWxWYGcxTXVbhsos3i45NXb+xuxd+qYWppE58vcNQPhOBH9PZmhLZ5w1OP2ZFgfc+MMD8RJEu4s1JbQra6m2BetoRMkELQlAsZ3HVgKkD7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:46PM +0100, David Hildenbrand (Arm) wrote:
> zap_vma_ptes() is the only zapping function we export to modules.
> 
> It's essentially a wrapper around zap_vma_range(), however, with some
> safety checks:
> * That the passed range fits fully into the VMA
> * That it's only used for VM_PFNMAP
> 
> We might want to support VM_MIXEDMAP soon as well, so use the
> more-generic term "special vma", although "special" is a bit overloaded.
> Maybe we'll later just support any VM_SPECIAL flag.
> 
> While at it, improve the kerneldoc.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c        |  2 +-
>  drivers/comedi/comedi_fops.c          |  2 +-
>  drivers/gpu/drm/i915/i915_mm.c        |  4 ++--
>  drivers/infiniband/core/uverbs_main.c |  6 +++---
>  drivers/misc/sgi-gru/grumain.c        |  2 +-
>  include/linux/mm.h                    |  2 +-
>  mm/memory.c                           | 16 +++++++---------
>  7 files changed, 16 insertions(+), 18 deletions(-)

Thanks,
Acked-by: Leon Romanovsky <leon@kernel.org> # drivers/infiniband

