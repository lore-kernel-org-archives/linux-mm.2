Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8AF2EA4E25
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB886B0099; Mon,  2 Mar 2026 10:41:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3E86B009D; Mon,  2 Mar 2026 10:41:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2396B009E; Mon,  2 Mar 2026 10:41:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9F296B0099
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:41:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 827531396A9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:41:46 +0000 (UTC)
X-FDA: 84501538212.01.4FFB0CA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id BEBE140006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:41:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DM1iJFfE;
	spf=pass (imf27.hostedemail.com: domain of 3tq-laQkKCAEbmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3tq-laQkKCAEbmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvJ4Pj0Wo9ryI9xJ6mJ9OBJG9CVcmeBhutvadxQnZZs=;
	b=wHbf+UGPdeGAlU6z/wvDrhgG2ItKlFsTS14GJt5yfCJh323ms44xhBqDDHKL+JoF4e2FR/
	lU/ycOcfB+iWxUfE3/tl3hDkWMKZm0rFxMrp/Jn8FcCel5CtNJj1GpNz3HuVsjbwI4dUz6
	3l4JMLa1tla0FwPPWuPvo0il3tdK5Do=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DM1iJFfE;
	spf=pass (imf27.hostedemail.com: domain of 3tq-laQkKCAEbmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3tq-laQkKCAEbmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466104; a=rsa-sha256;
	cv=none;
	b=6kRGhwr36OafWXgy5sYzIsQin1avv78GNfmWnXK7nobuCFBTqCAXzdzalBbVBpLZAThYpy
	No/kdzB+KZ2qx2lbokBpFdpIQyhpw8dHkEgtkp01pAHwcjRK9AVJ0B+m7qQ6poaV2mbOKM
	zRz+BJy6TAn6RFSMsbyU6mLgQ6ie3Ds=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836bf1a920so47764975e9.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 07:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772466103; x=1773070903; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fvJ4Pj0Wo9ryI9xJ6mJ9OBJG9CVcmeBhutvadxQnZZs=;
        b=DM1iJFfE+resQe98hHv2cLNGuApjNye9Wq4K14UkuHqpbin6nNLb4Xyciq9jrN1vxR
         UmFKxCzaX7LO+XZVK6pSit3I2YFoZDDCId5j1xd/7MJUNcXs0a0cN6WwLwo/bUaLY/TQ
         TWlEFmTPZk2WeMoRAUbarKqmubT1JR/1WDGA3QtbhB0sy2NxA5Z76tWNMUmdcdQs/6IH
         XOsUspuxuPnS5j/9+NvJ6TzFi9FJgvLxwRxKzJYEbzTQGd4uE2PTls1U6zDVaihqvjJf
         pygbROdoHbW3MfflsU05tEU5ivAm1qK++gXEcbuSXaXUs45TGu77nUD/ML/VW2zwuWJs
         Aghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772466103; x=1773070903;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fvJ4Pj0Wo9ryI9xJ6mJ9OBJG9CVcmeBhutvadxQnZZs=;
        b=wFU3jVRiv3FjaBJBwjlrCmmXyL5pUKRfIyuKo1TU2c0bB4aq0w/ooiI0KQeqtpls7u
         5Xt9nFUfeCcNIurw18iRWfAz4IVyzWNPfWj77zaGjEZ5PpeHwWr1fbOvO5cNvyQcJpuL
         1DtsTNOVSrsJ5pH3imwVrXdHDNsMK5H0fIfz97gaW0MQMqcFoGybMDNjljyv4xeolN6y
         jUG+r+0ZoXMPNowNjnGGH5jBqG22YFIrm+XIXaA5+x8mbdyP3tjPXRGNSowIdSXow/Gf
         Vnl6Aftj0BO3mF6+nKMslqmVJ7xg0DWeJ3raySk/v1qxqRWrQAV5vGyCQ9gDsCiIB0ax
         yJZA==
X-Forwarded-Encrypted: i=1; AJvYcCW5uGBc9Crf+/6c6m/0iBh2nD66lJPcMmst8bG1pN5wkrqAxLsZPLSlqcAaaid5dKv3x9RQQAETSw==@kvack.org
X-Gm-Message-State: AOJu0YzroiIg7lp6fe4NcJmMvg8WaBg9WE9VBc77w1wX4ZtGgiy8Lc6A
	ql/EnPb1o58MC1K96GYfD8dX8RQADhmETDLChKw8FOQafsY/4QypeHpqAAydolA/kkRYD1wdUO1
	vhnsGzXFiGVCUYMVr+w==
X-Received: from wmby19.prod.google.com ([2002:a05:600c:c053:b0:480:690c:88de])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b18:b0:483:7432:a761 with SMTP id 5b1f17b1804b1-483c9bc558bmr213622465e9.24.1772466102970;
 Mon, 02 Mar 2026 07:41:42 -0800 (PST)
Date: Mon, 2 Mar 2026 15:41:42 +0000
In-Reply-To: <5f8dcb7f-9e4f-4484-b160-3a9ce541d63c@kernel.org>
Mime-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-3-david@kernel.org>
 <aaLh2BxSgC9Jl5iS@google.com> <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
 <aaVf5gv4XjV6Ddt-@google.com> <f2f3a8a1-3dbf-4ef9-a89a-a6ec20791d1c@kernel.org>
 <aaVnifbdxKhBddQp@google.com> <5f8dcb7f-9e4f-4484-b160-3a9ce541d63c@kernel.org>
Message-ID: <aaWvtn48X8UizaaN@google.com>
Subject: Re: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from zap_page_range_single()
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, 
	Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: BEBE140006
X-Rspamd-Server: rspam08
X-Stat-Signature: i8r5nawb4a84ueg7qxh7nkt6uwurikit
X-HE-Tag: 1772466104-769798
X-HE-Meta: U2FsdGVkX1+Jx72NHHZSDw+ib1JRClwQj4pe+cDBGtuAqidRrAFiMNDaSXtSrXcQP20Y3NJbQg1T9tedAQg9ryFNtcJkuLI1KHQYIDPJpy5c6W0/uVL83EsNzkf8JXIkFmkxReTkPUkw4Ct04IWVzoD67FbmhP1U1lSevTo8RYsKIB7DLNK9e0a8TKT/2ksV4J6K9EKPBjYxzY9sKRKGwWjhUPweTlWh6odgXRJ8KCmW3YhjcEHyfQ0OfOprdYoT3D0Zm0Oa/7Qqh/5b2/r93iqsVmTW1JSHlyZkoUKn1m0WOPZu7EeHoLvXDY5spfjWq6b1XoSDfu62YhiBifJtL7QBgQf1Rk+C1T4f+d3DytxvwxOOuEVQD0RreGq0Aqu4gtvRoMw6dl0E6HHxIHCPFncsRQnr3KFsGAWtoppiQflRICiNqcYqcDbenpkC6s4e15eqw0sCFsgZb4J/W2xK2EDLhE//5KBxC1SR3fWl9vmoBGYSSOyMb4ENW1hIClViXu7FgqXau0cy/sDcT+M9Ju+GmWJyHezDIb3v7zDOOSgSpencnnHcGIG4WPsoQSbVFa2BadZps05qXmkvptMOlb/DryEAo3g4nuqrYYNdyYZRz4SvwaRR9LFhwx5T394tDkhrFmE5wRySFiTjKvHLAGRFXoQjd2X7FHr/TwVxRULn+gMhiD4F+IS96Wd7g4wVYJhDQtToQtNRlSWTObS4VLLBkDd47s9Ksm5O24dXHANzMQjdfiiR2yzc3f9/anA08Nw2YFx1tDW8KvTuStl/rBxpPHHyoWO2MIDO7mMvxYRPNb5abTXIRoysC5hg+K2SdhJ5dE9LsC9S0iwo98ZqzIVp3JP6me2BAcrEytAT2nne9yNlRU0eV1V7uhZg55cWASIIIKJ1K0qtqm7dSo9eqFqlgl6qr+SSD4ahdmd61juSJ+d0Xo6Ltfiz9+9cdYWEyMavsPpQ+NPQdYyns2u
 2T/fV4xq
 1JbBcG5te/lL0q+ZkDUGOcuM44zeDDF8KCUSR1BRQdsez3EHvsQRupb/WQXykhBR7RzVKUYiCciiGOC6q5rRF6wjO2fsJzZ50+donNXhUIlL4y5F0dK2g0A7LvTkxLhZ2Knnd9wFWZUOMbEso7UDbnHq5RBzIdsn7coa1wXQthkW/uae8njZVMmlJruMmctO0Mhmdv2YLmFH+eD5loXEvOy5U4Y5TmNcuZco0radT3rb7ZSWucDYWDdk8e63sI0CvWV8M3vbrFtpjVw/+88wgJBAHjMMQTbHjssJpH84erzDkljUpOyNFOpI9rSR0AHr12Gbq4r0kltEv/fKx60XatJUeEURuvMpcbxpLiaDsJPDEgIhhotJMwsPrn0m+skXsRZr3FTQsSCcrJMFA90f8q5kzw3OLUOAIVFj/qpWCR6clfB87yja9UR8MS8p4EyrTU6BWrGe3HW2t8QPR3z84KpLXLcnu5ajS8Miz8JwnUpFcJj67OnORmQlcJwfACpzpXCox8k9Vd5Hgqm1Hy4Ozz/DKAAkISVee7Wr567sNmMn5ArMNHQP9nOpW4EWWusYyzm3xKjh8vV8qr6zEzS7eGMeloLbHXszSqqSoF4S/ST3iaaj2MjmtCwPaFiHmn5Z32zWaQ1Qfofe/l6IT9cWh0HywJDrK8f8vZuQR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 04:01:44PM +0100, David Hildenbrand (Arm) wrote:
> On 3/2/26 11:33, Alice Ryhl wrote:
> > On Mon, Mar 02, 2026 at 11:27:40AM +0100, David Hildenbrand (Arm) wrote:
> >> On 3/2/26 11:01, Alice Ryhl wrote:
> >>>
> >>> Well, rustfmt comes with the compiler, and it would be ideal to build
> >>> test changes before sending them :)
> >>
> >> At least on Ubuntu on my notebook where I do most of the coding+patch
> >> submissions it's a separate package?
> >>
> >> I do all my builds on a different (more powerful) machine where the
> >> whole rust machinery's in place. Further, build bots that run on my
> >> private branches did not report any issues.
> > 
> > There are some build bots that check for rustfmt, though not all of
> > them.
> > 
> >>> But no worries, I took care of testing it. Thanks for taking the time to
> >>> update the Rust code as well.
> >>
> >> I just did an allyesconfig and it does not report any warnings.
> >>
> >> So apparently, rustfmt problems not result in the compiler complaining?
> >>
> >> Or something else is off here that rust/kernel/mm/virt.rs won't get
> >> compiled on my machine, even with allyesconfig. I can definitely see
> >> some RUSTC stuff happening in the logs, like
> >>
> >> 	RUSTC L rust/kernel.o
> >>
> >> Thanks for the review and for pointing out rustfmt!
> > 
> > Similar to kerneldoc and other similar targets, formatting isn't checked
> > in the normal build, but make can be invoked on the rustfmtcheck target
> > to check it.
> 
> Thanks adding that to my cross-compile chain.

Awesome, thanks!

It's not relevant in this patch, but another thing that may be useful is
to add CLIPPY=1 to the make invocation when building normally. This
causes additional warnings to be checked using a tool called clippy.

Alice

