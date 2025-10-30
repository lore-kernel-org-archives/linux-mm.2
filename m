Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E530CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89FCA8E01C8; Thu, 30 Oct 2025 08:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851598E007D; Thu, 30 Oct 2025 08:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1A48E01C8; Thu, 30 Oct 2025 08:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 572F98E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:52:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E53E2514E9
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:52:40 +0000 (UTC)
X-FDA: 84054769680.18.247E86D
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id EB575180008
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:52:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=U6MxoDQr;
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.45 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761828759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhWJzGzGzYtcQeOF2Zd9nQeXdar54wkYdmN+7gtiSCA=;
	b=lW4cZB62C6QsOLXQNNeVeHY+ZZQgYd86KtlzllPjXpGHbaXX+ZZ/VunCtulM3jhM2fdZ/e
	wVa3NUdAJKrQts8IzuLyDalEO+5Jn2PMB05p3TGDIYGH6hrucVDNjBX5dFlqBAJkbsJ2O3
	MnSRncURSUvIQrqbxJarqeo5YJ82pH8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=U6MxoDQr;
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.45 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761828759; a=rsa-sha256;
	cv=none;
	b=C2RZeFFeiItSwIkDOBHcR2IFxogF9G2YnXuyWdloCZBlWJeXzZBR7gnBWFaY+NN50Pdixx
	hWXNl/xGi0MD7kGE/hlfvULgEgX4CFHqPp/GPxs/bgdohab9QdNYDoFznYfyQ7Yp6F6APh
	MR5YXmW9Dl06D1md2K09c2NVSbDn0Fo=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-87499a3cd37so7293456d6.3
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761828758; x=1762433558; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fhWJzGzGzYtcQeOF2Zd9nQeXdar54wkYdmN+7gtiSCA=;
        b=U6MxoDQrArQ2OFFuh030HnauKtJEhgLQZlPEXrzQ1KXFt98Y+0G74zTTq8Kc1DI0aa
         J6deFtNqTnev0n5jTQ29yOfOw8IzaK+7ju+iNQFf9G0CBbaAKF6yFaKpHFJMctk3N9GY
         P+ZVXHi3tlbQbPgkexdViLSKJqvu4ky35rldUd0CAR3AJrIOVIvyastMkIsCKJ/EAxKo
         8X9wGowFwG57iV1tmoJDAwOdxu6OOpBhGUaQZzj1wSjGnDvegFvDcQOdEuT/Rs6tpmpj
         fm5W2DAARPNkxuDM4dQl86K/D2CC0QWHNTA5LwOIUEDCM1gL6regdTJytrc/8Zk3H1W7
         0xCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761828758; x=1762433558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhWJzGzGzYtcQeOF2Zd9nQeXdar54wkYdmN+7gtiSCA=;
        b=S72SWoQZGigyuha97v+lGyh4EwqbNoTOokIco7NnVPretkjsnfxniA4dH39mYe9+rx
         +9gL97yV5Q0slKyDHuzT4nV6oscp6QoJUbUEvtvtlF/l+b4DKkWB5VPvg4QzCU455Iek
         0Xiqk9Li7Yg6H8/RXVi/AOL+AS9y8WUeEdxFGDXestANLe7kLWpXgkg37VM05A7rmqUt
         4B59vgOj4BxvSxIEpW4hbUgu603l08LU76OVz/1FsOBABb/AmcuxU8NyN6UaLjUtW5G4
         RKp5pg8DxAwVL8Zk6w3iBUyT/NDZ5HDfcwFp1ZMNq+wJ/7ysGIA39bImARm8oAyq95Pm
         TGVw==
X-Forwarded-Encrypted: i=1; AJvYcCW0Q5R61/OPX46x6MQs4QgkGaxj8YZ8vQiBC/PBW4aBIel8mD9B4JUrAb26gY42lus6OMv0eDLz8w==@kvack.org
X-Gm-Message-State: AOJu0YybAdOsME1zFaBMKR8FV27VvvVgRKnCb6s9WEjlwVOtabLSB2/G
	k2/7k7es0pZhC/kV+hiesf/KRyk1Y721b9WJyazO5NmJIV5fYa+H3w9Hwc3mueKEdt8=
X-Gm-Gg: ASbGncs3IlTop+g2PPCYl5B80yKGwzC4+/w7CbhDD9P11a60rCQsRH8ARyQyClh5kP9
	X9Yku8SuExhh9vRq9BnwvNf8nw/KptCKUYUYILN63XrIdwjtF5YevsnkjFF+4H5l3f0FhbSeNPp
	fKZInjR4QqqFEisMj/Zg4xE6TkQtx9oRowo+qyxIYBhNOOF3BJy8Hh0QC5FPvqJLkdePcEl9Kgb
	n55ANZ8hbKAj4aHTqVWgu9u8gkVHSuxtwzWQ/mejONM72HtsjLrvc4dorkC14WoasGwPr+QyHJl
	o9Y4pbzOVk/HS6mleuz/jbD2ckIwIJQCVvKAtO1/NzM2xmMpiRaQTWGu2PmQ5swgEKqA0pM44jM
	qCbO/LOUn4Zz4Q7AogK9ZOV4b15yBgnyd/fljp8fIxQshRL4NDEVMFnc7PSAGNAiDQfjlEnTZQn
	UzqjE25Leok18xpXPADppETyLZTd+qounbrhj6vyWTPKqe+CLLC7boeNQ0
X-Google-Smtp-Source: AGHT+IGoESvGzpUDrJdPJLRLhPWYD3SbdQgNdCWAIIjRLmFYz/jY6rOutROAlH9tr+MSKSD3bFPOYQ==
X-Received: by 2002:a05:6214:2261:b0:87c:2d74:1fef with SMTP id 6a1803df08f44-8801b2227c1mr37575316d6.52.1761828757828;
        Thu, 30 Oct 2025 05:52:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48a6befsm115003726d6.4.2025.10.30.05.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 05:52:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vES8o-000000058XD-1cvN;
	Thu, 30 Oct 2025 09:52:34 -0300
Date: Thu, 30 Oct 2025 09:52:34 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: introduce and use VMA flag test helpers
Message-ID: <20251030125234.GA1204670@ziepe.ca>
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <c038237ee2796802f8c766e0f5c0d2c5b04f4490.1761757731.git.lorenzo.stoakes@oracle.com>
 <20251029192214.GT760669@ziepe.ca>
 <0dd5029f-d464-4c59-aac9-4b3e9d0a3438@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dd5029f-d464-4c59-aac9-4b3e9d0a3438@lucifer.local>
X-Stat-Signature: tu89o3uo1ok3w9ze53y4ut18b7qi3495
X-Rspamd-Queue-Id: EB575180008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761828758-603965
X-HE-Meta: U2FsdGVkX19WFUO/2awbL/YMH5dTmiFwwbCezao2JP7d//tdi4N3ikbqq2+68ue0VQRX3Oq9ScDBduyUST9HNYtPvdM0eP4w6pOwI/C69decfSEOTQFYVFHkU4OUOu3sCnmZSD0/a1oFVYyYbNXEdAQlsBHssLN847GKrqQizDPpikOwMaAU/kZ2Ix/BuApy7YCdUJRakkLUm09r526ehbSkLACGlkbapC5CV3Vlv6iVvrkWpO+niGGLxQhZYlo/p5FPKiN4q2RsebCdX1X4nJyYwVHS0ZF91E2x5Cdt5hElB3yPh7PAwRS8dVOj/NjNTWfAXwMl2RbG2g81Le5E60ZmGvjj74/Vu0SsBhuCh7DXwvf6EWAfZqGp6XguxzbSy69/2d41eT8FlcIFebY32JzeoGygJtov4LznMosAWzUAvej8SMKyEyNYyuQfv3zMDZdr7LZcZjyAM1ZlhToiqORpMnUSFzBEykufq3BhfAdWrMkVuTTi+KEFB06XlTSsbqLVYFjR/mIZoF7/SAED5IKjpdzLpl51sIhEylh1LRhQpfkmzy4AjIohKbxjFExNR3priJV1epw0BOg5h05HYr1NsBxsdKDqwWeHOxhVdlh67D9uuLd9MMamXv2NjFvOE1C1KVcqoATad8iTug3HbahIOmIzghKrWVoKH2nktx/WW2SqUTHhNQcZBxridVtoYILLwtf36kqVxUd9derwL/v4SA9m2eqnN9tx27h90KE+2tBjxtCwsuEQOUAxmMgBzavciI57JthnO1gzSUutNKkB/bjrTb6cxb+6QxMuQDX1kvmM5VzCXFDHeG2vP/7wXFqMUKrDeQwMw03is3W95kB1N8jOD90t/Szm7IsQ0NWNe6nvemWAHservcInIEoE7k2qI6S29Uha0XTViLpGQu6tRDTqBsZ7Yb8zxaax+PqdlsKPPCZ2eKG228kHpH9mc8hZ4LJ6300CakPkODd
 IPpGKnxg
 xWU+7YsWQLP8q88podYpiRKMCvv71VEWzpKQkUZOSb/cuDOJJ6XvSG39XQjb4uNQ5eIQeFt3O4db7XbyvJazbg9EelS3Fce1JvX1w3O9e63PI7SQj8nFdZPw+KsvQVtWmt736VGhhKaiz3K6dbEYk1+8JpsOcG1O9QH/f9HeA67EcBg6OiwFs87EOaaZAyWAEAjHIvsuzzGjzKzCcgwr28f6cODa+ops0eQLnpEtgbKXmOTqRc5oar2UlmTxSDtsKYdwRMOxFMOdsrINMhydcuT8MYw3po6LM04eOHn7y+P9LmCBnabbvF+TSelGCOJvPtAFz+cSRn1TluBKr+JLhDkk3iRRZLzwIw3vqs1gfdqisLoQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 10:04:31AM +0000, Lorenzo Stoakes wrote:
> It may also just be sensible to drop the vma_test() since I've named VMA flags
> vma->flags which is kinda neat and not so painful to do:
> 
> 	if (vma_flags_test(&vma->flags, VMA_READ_BIT)) {
> 	}
> 
> Another note - I do hope to drop the _BIT at some point. But it felt egregious
> to do so _now_ since VM_READ, VMA_READ are so close it'd be _super_ easy to
> mistake the two.

Yes, you should have the bit until the non-bit versions are removed
entirely.

> Buuut I'm guessing actually you're thinking more of getting rid of
> vm_flags_word_[and, any, all]() all of which take VM_xxx parameters.

Yes
 
> > few instructions.
> >
> 
> Well I'm not sure, hopefully. Maybe I need to test this and see exactly what the
> it comes up with.
> 
> I mean you could in theory have:
> 
> vma_flags_any(&vma->flags, OR_VMA_FLAGS(VMA_PFNMAP_BIT, VMA_SEALED_BIT))

'any' here means any of the given bits set, yes? So the operation is

(flags & to_test) != 0

Which is bitmap_and, not or. In this case the compiler goes word by
word:

  flags[0] & to_test[0] != 0
  flags[1] & to_test[1] != 0
 
And constant propagation turns it into
  flags[1] & 0 != 0 ----> 0

So the extra word just disappears.

Similarly if you want to do a set bit using or

  flags[0] = flags[0] | to_set[0]
  flags[1] = flags[1] | to_set[1]

And again constant propagation
  flags[1] = flags[1] | 0 ------>  NOP

> I feel like we're going to need the 'special first word' stuff permanently for
> performance reasons.

I think not, look above..

> > Then everything only works with _BIT and we don't have the special
> > first word situation.
> 
> In any case we still need to maintain the word stuff for legacy purposes at
> least to handle the existing vm_flags_*() interfaces until the work is complete.

I think it will be hard to sustain this idea that some operations do
not work on the bits in the second word, it is just not very natural
going forward..

So I'd try to structure things to remove the non-BIT users before
adding multi-word..

Jason

