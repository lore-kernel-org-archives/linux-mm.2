Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 955D7CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 13:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C18836B008A; Fri, 15 May 2026 09:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9416B008C; Fri, 15 May 2026 09:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7A26B0092; Fri, 15 May 2026 09:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 996D46B008A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:24:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39A438E166
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:24:57 +0000 (UTC)
X-FDA: 84769724634.23.D4953D4
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0430610000F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:24:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YBeNpmK9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778851495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJkIJ9MSSyAx7AMR5IamH1iN68B4UTFJP9CxVTr4bw8=;
	b=SVKQ248L9oHYdycYXIw/miYsD1T1Yl1EHXHbow7N/viaW1Nr2ls+m4UePs9uwfNnkGzXZj
	8sVvMOWrQAzHP4qm7oqm6d+FeJesobsqHNJusvXxw4o3Var7nK42jrkqzqwhxYsIiWoQ80
	SpasJArGTLGgROmTuuksyG6OOlehBTc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778851495; a=rsa-sha256;
	cv=pass;
	b=VnPmsEmuy65rh4XuRaPmNuLvfvOniymOPrm3Pay7odAElOC8Ob8NUBz3WmcOq3MrQGh7lq
	auoFb/h/khEaqClug3Oquz6eC3J4hd9FCM9JcAYjn4UwTE8SChAZUjtxhGFwUUhWKxfHcV
	bmTmzpPZUxBo2AlaiI/z/vvSPjKzatE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YBeNpmK9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12c19d23b19so15209762c88.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 06:24:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778851494; cv=none;
        d=google.com; s=arc-20240605;
        b=J9afzMrA+k4wLuqgy2Po/l+GRIglJESlGdOdcI0B+rQrHKn3137MlDasOZ6gnjVHBr
         5NKp9+CC0UZEkG2+MBf330N7B3FttkaP93Y/ZNTzxrBQBBAaBWNWgKBX0gaMbWgw2w9I
         izkfmzKx3ecWOI4ejDWhELvTLzB8wy3k/KJcIXGuXCNZmWeTVJz+HKCmjcWH2HVcc+Yz
         BpEWVYuwZXDA3VbSIzcRb5TmmBLLhshDr/4IHFMf9f9GrC6oQ0bNOSk6TPFhGMpIth0B
         AAR+XFseD7vQT6LZtMsgXvvcA3HIczR7jZkW/btwHDu05Zdc2KlzSQES6KjHfS/uEs3R
         gDMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kJkIJ9MSSyAx7AMR5IamH1iN68B4UTFJP9CxVTr4bw8=;
        fh=GvzESIu5DdDauKKFcD7GhMcZr9CiiZP04bTlibvwPTE=;
        b=i5d4ALbmEmIsnuwheLEpkprtR2TXzsc2+HiTnNVEUPF8dLOMzYo6P73uxvFFf7ud7f
         OaXUzfCPRIlDp1SDB7bfTs5WsEv+Lg9RoIg/Jp37JAy2xTRvFSpuwBoAUv98YFiLGM8Z
         c+G14ggQGGORRzX4zsEAAkit6Mm7jHyWgbZYxc4dc5OP9zSCmDHepVdgUVK9ifeMhX1J
         QPbFylw9lw6shHOd1g/GShb7rZtwNB6bPuNvpOlGPZ6hquZn2ib0pz4l3oqUQVAU4Sqr
         F4Py5sx0D2KsWRqNddGft8LXq3YLDLQ1fG8BLImD68Zm42uecb4H81ZbboydwpahTQ3V
         k5vw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778851494; x=1779456294; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kJkIJ9MSSyAx7AMR5IamH1iN68B4UTFJP9CxVTr4bw8=;
        b=YBeNpmK93xj8oRxSmrICEyYicOUXTC8WxWHPOvExl+dIUTS5W0gHjAhGdku+ih0T+Q
         7OqPDr/KK4bPh/0EH88imvsgjdYL0rlYrktWjwiT4kPeJSw4PExSs0rEtGI9TKp10yA/
         LCLE/HkZvDa+wNfl+rwcRomYVq3FNjdF7oIEr5SWjwbpEVWRBXZLu5RuFuYKH45msoLx
         FoIeTxYddgIPEHagN5EP2QXZJyEwWyTknIChvjcwu1eYuUk99Wu0FZZKhfJLtwq/iRH1
         oi32/NoofUDSLtU46QWGNwsUHUqB/vCP6dI1RIjG6EAf2VKeO+Wg+oTSdLubz0+zR+Bn
         7ZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778851494; x=1779456294;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJkIJ9MSSyAx7AMR5IamH1iN68B4UTFJP9CxVTr4bw8=;
        b=PGaRfd/vscp/frL9GXmcxCjx6D4ErTmT/EiP9FqeQcxAWECA4RTvgN1ii5Nj3OSpCc
         auQ99TdOgM6umv7dlp+JVDoAN+28DEbzC0BvebiX7jI7bmHExnyP3Wi6293KV9LOjw9C
         WPUxmhpCLAND1HdxGmEWUxUkZJVyhvB7DY/V81baywcwnDIdEIb6SRM6BBV/POMuKOO2
         tOSXOmjBdjdyYn+IbY7za4XDHcUbCCJ29OLyQ/PgviEZW2cXvVKa/Z7a21dSUq1ADsj6
         fdQkSdT7KyFE3AzXKVWx5gIimZ2/CEKEYJp2KO66LYfkmfHoCtaIFtorn6efFRt/b1fg
         twtw==
X-Forwarded-Encrypted: i=1; AFNElJ8zNVTGw4anYLWc0a/ls9QXDXTp4zV474gNJUUsWvxem64+jmJFqgctTGmwxu21XKvqqYP5XinFZA==@kvack.org
X-Gm-Message-State: AOJu0Yz2ZlBa93DfmsYawAGR+QSudfTtDeNfX76CLWnhqVxocyC4Ht55
	1fK/n+l12S9DST1breiwiY84yM2tNYT4hT+jxXLrjdCEpF9cWN8VQhW6Wa6peie11NZWuhoztHK
	KgJFZNaoMk8sALuAkwSHhzwPUH8aj6zqjQfRqH2p+
X-Gm-Gg: Acq92OEBsElTSFl+E8XsEov5/UZV0gDiZGS3thuNQMeX9sirWLK1UmUEDLFBsVl/bV6
	61SlG7xl/WpHY8bD0o+fxBpSIKvst/C+AZnjyc72TkFDhgL3w6yanxD751KoYMByvyJO/qGV5dx
	D+vVkH0iMsGOP9f0WLcVS/fzlr1kEqwTPqgtxm2nPGvUlCdblR+tyEjh7h5AwUAmqtiJ7r6zF/m
	NOLqCX3cp9qfvmYR2ziS6uA22142OoF4xZFoaDmDyu8YrIHkg0nc5yBzy3wBV3bWX1bjEduwAsV
	YLZMLQJvx4VhRSYShhFAXtLmbRA3Ypse8bulI8pNwhe456Xe
X-Received: by 2002:a05:7022:62aa:b0:12a:72af:83d2 with SMTP id
 a92af1059eb24-1350441d7ccmr1656610c88.14.1778851492906; Fri, 15 May 2026
 06:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260511200136.3201646-1-elver@google.com> <560a84ed-7daf-4a78-a314-b867c73bce22@kernel.org>
In-Reply-To: <560a84ed-7daf-4a78-a314-b867c73bce22@kernel.org>
From: Marco Elver <elver@google.com>
Date: Fri, 15 May 2026 15:24:16 +0200
X-Gm-Features: AVHnY4IK86MdHMyPl5dB4zdZDdnYGN0oaLGQAymJ1xrwo4kBW5Idcq4vVdQ8Oeg
Message-ID: <CANpmjNNHXvv8ruFGHzvom5V0mwmaoBoBenvt=ZLnEDmEy8dYeA@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] slab: support for compiler-assisted type-based
 slab cache partitioning
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Bill Wendling <morbo@google.com>, 
	David Hildenbrand <david@kernel.org>, David Rientjes <rientjes@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, linux-hardening@vger.kernel.org, 
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Alexander Potapenko <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev, 
	GONG Ruiqi <gongruiqi1@huawei.com>, Jonathan Corbet <corbet@lwn.net>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0430610000F
X-Stat-Signature: 1ir55qk38kmk3ab6sahche6c9b5qjjwu
X-Rspam-User: 
X-HE-Tag: 1778851494-199722
X-HE-Meta: U2FsdGVkX1/BfDEBL4rR+kqncLVW9mLg/t/nHvKBADOpNQ1UfOmWEPU8oLL3zs0LG5Vt96vR7uvkWDmfY4fdre/7uwjNXOXIWjb4d5GFv6xYP3/x9ZkJsy3sutoMTP0F6U5g40ctvo+ozE4v/SUJC/ZYTXwfSY9sI5XZlb6lndMxMpgozFHYNYfNUsKRZdgpCCZQ5grpgeftTMQekjE9ReZInzoUtEOJLXVfzGFEgdKcm/REnftd2V5WaDtmD9UYD2EVNA1SlPWTG0/pdBfNhaGydz6bLbGopkywCXJ5k2TT7YAROTtXliOLSIue3d12wxJ+GFIHWyCRRKQdXeGTWDWiURPYwKnus43AChGdQe1ayWD4TnVk7eb9S2fux7nZ2lUqzdkYMP2i4vkt6qq2hZRDJfLAioWIjlnO1qkspJSRUDwC/LcIw35DOZbrfXmio6tsSDj31mStvjECOIRXmHgKTAncZABWXKgLZoXgYNGPE5OEtbKrESNP04p+5Ccuwzs4f7+uya2MAx3P322USJnYYAM7AO6SHFr1aw/yjl+HYaurAowqzT+Xne7O675u4ACCJJJj07OJY01Yuf3ASH99J4VvNJsF7C2RoJZgvoVlXP8GVg2vIVg5Wmk6zzK/IH7CH9A6HzDCEYX552KpqtndcwsUMxVj1kjTB2BCwwF3zgXbfIdMwS2ObybYY1FUcoj6HvKEUW5m5farx7f4vkMTrJsJbr718HSBtt2friKS1EL9Rv21IkBrs93SIpx8K8rGLifQPEq7h836sLGAyGx70F/hs+nBPDBK85aKfb0WI45L/tkMuIK0ZUrY7IgK4jnCP7AwNi/V62IDVIp55iF8/w28iQKM671evwS0X/etddVuTRgWBVQ0pXXuWRhp0pyj/Ar1dLaqXuMRsmnWzr52/doMV/m2DAy47MqUFos6eKgoe4wnsSuk2Artzaf+2xPzh1edwJlCESZxn1H
 rjK6y9em
 oILgH/s/XRDJDbT+NHT14/9EYAE+ydUyEhK5LC87ZxWIf3J52hpW64Uba0Kp1wWMZGyKY1pYb6B2WO37XknhbyzarhHVNTR1nFZXSJACXv4Kc4EjgxcLQxz8MkPAHqAgZ93brTMyflAyokMO+mtxy4LKwZYyrNumUH0+1OFUEPMnvVF5Gam3s/ECaSXtxOUUeUbAbvSQQ72AntITzswpuzmRXYDEqoWw6IgwCdimM4/2QxKkZ4OsGftdk75kic9vI0oMaiYVodeJv4+rk6+8VG2CIOoMn9CxpsZ52EbOguafSxhEDnslryYfBQiTdRSlI3/SIdE4CGqRh+9nzqhcLbWyz06ePak16JZCtdYwCmz/bLLGFGLetGbmJM0Jo5K6xAk8dL5Mg4fS5MlBS7DJQ9YwPCPZLN5KJWDxzMK12fF4GY1EXg8yQayzc8oJCSGwW360BSesiJsWJNGllwPPTUUQMwwoeDQBI4MBz4Nq7EY/rsnNQiywf/D/XviHzcn5fN24V2/0EVNOPRavle98Z7n7xmaBzzrTS/vT+Qlw3DChhtdgh7B7ZlTv45S282qmIzZz8qiXHKyOC4zEo1K86va7k1WBDrgfyQIvfX0ZAL+zXyqp8gQQ4g6BHvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 at 11:01, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>
> On 5/11/26 22:00, Marco Elver wrote:
> > Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
> > flexible KMALLOC_PARTITION_CACHES, with the former being a partitioning
> > mode of the latter.
> >
> > Introduce a new mode, KMALLOC_PARTITION_TYPED, which leverages a feature
> > available in Clang 22 and later, called "allocation tokens" via
> > __builtin_infer_alloc_token() [1]. Unlike KMALLOC_PARTITION_RANDOM
> > (formerly RANDOM_KMALLOC_CACHES), this mode deterministically assigns a
> > slab cache to an allocation of type T, regardless of allocation site.
> >
> > The builtin __builtin_infer_alloc_token(<malloc-args>, ...) instructs
> > the compiler to infer an allocation type from arguments commonly passed
> > to memory-allocating functions and returns a type-derived token ID. The
> > implementation passes kmalloc-args to the builtin: the compiler performs
> > best-effort type inference, and then recognizes common patterns such as
> > `kmalloc(sizeof(T), ...)`, `kmalloc(sizeof(T) * n, ...)`, but also
> > `(T *)kmalloc(...)`. Where the compiler fails to infer a type the
> > fallback token (default: 0) is chosen.
> >
> > Note: kmalloc_obj(..) APIs fix the pattern how size and result type are
> > expressed, and therefore ensures there's not much drift in which
> > patterns the compiler needs to recognize. Specifically, kmalloc_obj()
> > and friends expand to `(TYPE *)KMALLOC(__obj_size, GFP)`, which the
> > compiler recognizes via the cast to TYPE*.
> >
> > Clang's default token ID calculation is described as [1]:
> >
> >    typehashpointersplit: This mode assigns a token ID based on the hash
> >    of the allocated type's name, where the top half ID-space is reserved
> >    for types that contain pointers and the bottom half for types that do
> >    not contain pointers.
> >
> > Separating pointer-containing objects from pointerless objects and data
> > allocations can help mitigate certain classes of memory corruption
> > exploits [2]: attackers who gains a buffer overflow on a primitive
> > buffer cannot use it to directly corrupt pointers or other critical
> > metadata in an object residing in a different, isolated heap region.
> >
> > It is important to note that heap isolation strategies offer a
> > best-effort approach, and do not provide a 100% security guarantee,
> > albeit achievable at relatively low performance cost. Note that this
> > also does not prevent cross-cache attacks: while waiting for future
> > features like SLAB_VIRTUAL [3] to provide physical page isolation, this
> > feature should be deployed alongside SHUFFLE_PAGE_ALLOCATOR and
> > init_on_free=1 to mitigate cross-cache attacks and page-reuse attacks as
> > much as possible today.
> >
> > With all that, my kernel (x86 defconfig) shows me a histogram of slab
> > cache object distribution per /proc/slabinfo (after boot):
> >
> >   <slab cache>      <objs> <hist>
> >   kmalloc-part-15    1465  ++++++++++++++
> >   kmalloc-part-14    2988  +++++++++++++++++++++++++++++
> >   kmalloc-part-13    1656  ++++++++++++++++
> >   kmalloc-part-12    1045  ++++++++++
> >   kmalloc-part-11    1697  ++++++++++++++++
> >   kmalloc-part-10    1489  ++++++++++++++
> >   kmalloc-part-09     965  +++++++++
> >   kmalloc-part-08     710  +++++++
> >   kmalloc-part-07     100  +
> >   kmalloc-part-06     217  ++
> >   kmalloc-part-05     105  +
> >   kmalloc-part-04    4047  ++++++++++++++++++++++++++++++++++++++++
> >   kmalloc-part-03     183  +
> >   kmalloc-part-02     283  ++
> >   kmalloc-part-01     316  +++
> >   kmalloc            1422  ++++++++++++++
> >
> > The above /proc/slabinfo snapshot shows me there are 6673 allocated
> > objects (slabs 00 - 07) that the compiler claims contain no pointers or
> > it was unable to infer the type of, and 12015 objects that contain
> > pointers (slabs 08 - 15). On a whole, this looks relatively sane.
> >
> > Additionally, when I compile my kernel with -Rpass=alloc-token, which
> > provides diagnostics where (after dead-code elimination) type inference
> > failed, I see 186 allocation sites where the compiler failed to identify
> > a type (down from 966 when I sent the RFC [4]). Some initial review
> > confirms these are mostly variable sized buffers, but also include
> > structs with trailing flexible length arrays.
> >
> > Link: https://clang.llvm.org/docs/AllocToken.html [1]
> > Link: https://blog.dfsec.com/ios/2025/05/30/blasting-past-ios-18/ [2]
> > Link: https://lwn.net/Articles/944647/ [3]
> > Link: https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/ [4]
> > Link: https://discourse.llvm.org/t/rfc-a-framework-for-allocator-partitioning-hints/87434
> > Acked-by: GONG Ruiqi <gongruiqi1@huawei.com>
> > Co-developed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Signed-off-by: Marco Elver <elver@google.com>
>
> Applied [1] to slab/for-next, thanks. That means including the kernel-doc
> workarounds in patch 3. I know Jon said someone might hate it, but maybe it
> will motivate them for creating a proper fix :) It seems better than leaving
> doc generation broken or not applying this series at all.

Thanks!

> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-7.2/alloc_token
>
> I did the following fixup to remove passing an unnecessary NULL argument for
> __kmalloc_nolock() with buckets enabled. Made bloat-o-meter happier a bit.

Good.

> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index c232f8a10af6..795455256329 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -894,7 +894,7 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
>   * with the exception of kunit tests
>   */
>
> -void *__kmalloc_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags)
> +void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
>                                 __assume_kmalloc_alignment __alloc_size(1);
>
>  void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
> @@ -981,7 +981,7 @@ static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t
>                                 kmalloc_caches[kmalloc_type(flags, token)][index],
>                                 flags, size);
>         }
> -       return __kmalloc_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags);
> +       return __kmalloc_noprof(PASS_TOKEN_PARAMS(size, token), flags);
>  }
>  #define kmalloc_noprof(...)                    _kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
>  #define kmalloc(...)                           alloc_hooks(kmalloc_noprof(__VA_ARGS__))
> diff --git a/mm/slub.c b/mm/slub.c
> index a6e9015601d6..74652bbdd591 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5303,10 +5303,10 @@ void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, in
>  }
>  EXPORT_SYMBOL(__kmalloc_node_noprof);
>
> -void *__kmalloc_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags)
> +void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
>  {
> -       return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags,
> -                                NUMA_NO_NODE, _RET_IP_, PASS_TOKEN_PARAM(token));
> +       return __do_kmalloc_node(size, NULL, flags,  NUMA_NO_NODE, _RET_IP_,
> +                                PASS_TOKEN_PARAM(token));
>  }
>  EXPORT_SYMBOL(__kmalloc_noprof);

Reviewed-by: Marco Elver <elver@google.com>

Thanks!

