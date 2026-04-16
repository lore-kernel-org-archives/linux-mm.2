Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78710F8A171
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 13:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9BB6B0089; Thu, 16 Apr 2026 09:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90FB6B008A; Thu, 16 Apr 2026 09:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6EC6B008C; Thu, 16 Apr 2026 09:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA8236B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:43:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4367213BBDA
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:43:36 +0000 (UTC)
X-FDA: 84664536432.19.11A85D5
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4966A10000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:43:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UAVsCTat;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776347014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjOGwsDBOUpGKkFXC9SNbDoonfQ12TYXzDLlbb+FREQ=;
	b=EqQf4m5vt3OnKkkTJFBQARkVRKPe3KMeBqhNUy9mwevj5MqsVmINLdetVCBNu6uB681JgT
	Uu8yqHAi2VSjcV330dMLcGzUHGunmBUqFXgKTCkraTTfXfd8nyhLs8CXwAPQdJ0nYxN/Dy
	KDcybSieuz76d/TWtikLKJFR5KHNtB4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776347014; a=rsa-sha256;
	cv=pass;
	b=CzoCrytn3HVEG5dweJpaOrND6lsQKHtBRsM5QNiIoTirIi/ZmWE/Zk/AZDNinYDbXwEthV
	jhKM1a4BQunTxDXmTjhJXmmobuR89vHxYu+b6foI83noYFQu1/OVWV1RAmuNMGLUisywF2
	A2cZFNGG3BqDH2loqQwUPXLIEqJQy/0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UAVsCTat;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1274204434bso465623c88.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:43:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776347013; cv=none;
        d=google.com; s=arc-20240605;
        b=EoQwDS9uwCZmYNCHgUqEKcsW/UV9N9tXwffY9odfE/kn7LjbpbeUl41XyIUhjBQfkt
         BK2Y1ViH0YmaIXy27vi0aa24GZAFTi89OXv4mqgOLV5hDKMfkXaZHOxCQyZInfurwoJ+
         Og4MYy+rFX4861rxtGbpnHOuAUVxsZzn4fWfOWHkR44TtREGdcPqYDe0BwstzlL5eitW
         byAsErzm7ioRg83OCxoZfvEtynHTTMjHkVlajthQEnBqwvbjQZQIxSTx34iw54J/ii9T
         RW3JUYckkB1fiPWitfRvK6zdv5l0WiKBH3KuqkGF0Lx00Zs+EokbS9tNlKOB0lqhiYbj
         9UFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tjOGwsDBOUpGKkFXC9SNbDoonfQ12TYXzDLlbb+FREQ=;
        fh=WcMpZBk4Gy9FanLZoDAmk+OkYexqFCV3U4zFVHZGTPc=;
        b=drYN6rMGN/mcr6GKiYCJdGFtSy28xgJVolh3G/cOlOrgICOJkNdEFD0IcpTTGg0qPP
         Snvdw6wDVeugSGKfMp0OqUG7TiSu1jbBMbCNEQXAxoYk1OP7VVDToH+tari4b2oKkPDG
         nfavvkehCfIT6LanZpn0fgwLu1bODXnfeYPbTsbhPsOdwgAYWkp5kEm5MBhFLFnAoToP
         CSIcoSV229dFy5euXAs0YQn4nEHJcttMQvC7Q/6LFH5hcDSvLI1DNePPvU+PVrEoZA8i
         x8uxrMuS7yH2AkWU9sg0wiQihq6IKsotL7QQD7vQMvOl+viNzezV3O00j44JzQ7P2x2B
         dvhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776347013; x=1776951813; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tjOGwsDBOUpGKkFXC9SNbDoonfQ12TYXzDLlbb+FREQ=;
        b=UAVsCTatAcQnhLFbDCRLpoBeh4wNHBZFp1ykckV+wmnc3ucgy+ZswVypdCU7Y+y1tc
         QWpYlqEmFzeETdDZkOlfbMndzg7S0AExkDaakBBc7Xv/b+GFv3Tp5hvf4UKO9pcsW+ui
         p/SpKnTkeBI8BV9MujYpRrIqlxz0Yg2itMAq3L619H+Osxd722xjL6saDaz7SXoJMVyg
         h8KuTpDn4dAycPckpV833R+sPZSMU9d76JE9dDIGmVMFK1RV5saX1WGs76n/xo+ImnDI
         A0QmKAj7uzVZwM4fN0zppPiABcOyN+UkUP04BaNLaOfHX6o13hb6G6wUbKR1U4i6FBBV
         LucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776347013; x=1776951813;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tjOGwsDBOUpGKkFXC9SNbDoonfQ12TYXzDLlbb+FREQ=;
        b=r6llIOrZgq/WP/wZwh1mXTqGvTWQQiD3utKPqVN/ZcqJil0x8MU3Slgglm9avvYLM2
         YfpJ6eWyZwJ+gsChMQUmcE9YrMD1nFo7nWKYNkrH5OiZu7g5FsKZI5Br6LxehLS1zPkQ
         CZle7Nb06T1j5VRlUPcP25cAH8a0oWsJ/cXMFmQAnnQmBqLIXYc7y9R2ihrNCTv7XYgI
         ZfnqBwxxvyGA4mspSidhB2zLef5rUzruJO4TkhExxnSVnYUX8Qnk9YYD7OWlGsMZg7Gt
         kgtgBWCLM636XImnh3k/zKFA2SWU1fRVeKE+P5KmA5niaFDH5THmO0CaOvcSImjCF/xk
         e6FA==
X-Forwarded-Encrypted: i=1; AFNElJ/gWfp89gGii8iPq43DJbQvU9l4eIiaYvCF92Th/IEQbGz4sgJJNqok9Q9/sY/za/e+dQP3DQNzZg==@kvack.org
X-Gm-Message-State: AOJu0Yy8yklYnINhEF3CT/rbew77A6ODLV1C5Mj5j7IiSLUsgFBVHfAR
	63U99G3s+jvqeLdjykLYCwSldPzr4cGaROpF1RCUlQCan/WOsvSecTx1rnPMzYbFUSoWPhjfeJ4
	Ajaop97a4cZrp9yyEgVwcU5nhXlGwIMlN+ppX2Ux/
X-Gm-Gg: AeBDietY1mn9nRLsPiX9oYA6P58StZVWDjsgNlJFm3pPHODmy/qa0f5o98QJ2sNior1
	e1r8pA+TZqVK/w53f+MYZ93DbyZHuEZFzDyeJAnIjAp17pVqjy3OlcEwGzgGQgkbStb/gSCnxQE
	pycZrSppwr7ZnGAQJIVvTnjePZA2vHKJbqD/zxQ0ZNSClhceTX7kydmWFukEx454l03+BkBxes1
	Rhnsj7mh/o7wke/qDQoeOcTjOIEEsYOuCi44arESP3CNKuNIurTuVz00WZZj5V5wcjxywC/q5A/
	ic/IuBTylhTF+f/A5YnL0708KRzaMh0dvdnagYmrjGVd+fncw40ORJMbDA==
X-Received: by 2002:a05:7022:ef0e:b0:12c:43:3ffc with SMTP id
 a92af1059eb24-12c62f5a7fcmr1810164c88.0.1776347012365; Thu, 16 Apr 2026
 06:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260415143735.2974230-1-elver@google.com>
In-Reply-To: <20260415143735.2974230-1-elver@google.com>
From: Marco Elver <elver@google.com>
Date: Thu, 16 Apr 2026 15:42:55 +0200
X-Gm-Features: AQROBzAfkSpT2OeUn44qCzMc1NnP0-wCVBwGgeL2FJ0Hvp5au7FJaosCLAeJDF0
Message-ID: <CANpmjNPfunKnU=S9Gty-7MaO-3eJ2PUR=LZNd37pmgRwQDruCA@mail.gmail.com>
Subject: Re: [PATCH v2] slab: support for compiler-assisted type-based slab
 cache partitioning
To: elver@google.com, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, 
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>, 
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>, 
	Matteo Rizzo <matteorizzo@google.com>, GONG Ruiqi <gongruiqi1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8iz8mgo9mfzu4hsoatx98hupuhtpp31c
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4966A10000D
X-Rspam-User: 
X-HE-Tag: 1776347014-133850
X-HE-Meta: U2FsdGVkX18iclHI9SNZkxVDAx6wQYV5eiPFz0y2p4OZ4fo9vDwJvFd0GD2HviPBGv3btGB/yueWU5J1AMH8iT8W3yO3S410iw77VHrEoBJzaLJZWovjgHEazh1uwxvhG8SthdBGRlYlAZW6ru5chqKAh6C/4NMUCVAofO9r322LYAmNsSmLMazrT5tSg/7Mi0leF9AxozV5A4xry3utQfnQR6ZfXecMjQjyXg/KFTTPhdjkj1XgcxWWPwfBOzIR2ruJz+13GSjaX+80sshv9TYRV2d0NroEziXKZ1NRuddk4IsCLegj1RBDVD6dHYSITyamGGR7tps4eiCK4SVtHp/gSrtz1xzEizhbzgRxvhoO79KsDYiYlHob+KBm0A3pONR6VeE9vYEywJLPbPpQzavof6g8Z8i9gKl4OrgLXOPPQpw4+Yw3VqH2eAOwrTG1c5i8Keo1fGBCBe9CU3q5la9PtR0epUY9pzA5VkTv4dOsQJshKYRPVHxhLEemokyGB7AFY0R/4ChGe9rk1UjN6AZwOKUVOCqnDuCZze6CJsktcwMLgLt4VSa0/ubpxj2TrVIOFuUFaz7IUobVuv8JGit6Qsq+o7L2v26/38rWbRoto2B0xbbSR/AF0MS8UCMNyr2nUwz7bh3Aj/R1vnDS74oHeAYNwxLe1l0PMOmYEugRevLCTLJOXR3r9wF2THGzea6f24REwxq//Jf0an1J4OpTbRd1qmXlnIGhKLbRj+mfMMuUuQci91Ey4jMbiiKglMcL6vnMGIjBa7XU3TnQ0FKJiIjEDAW+HT6mit3PyVbqTYNLE9SVz7PHuMD38Es8FL0HHPe5aAVLKn7Zii+jNuH6T4MZcPr8ssv57egSmiCbYklusMDJxthCSWzXN3l4hoTio8r+G803FDcYumkBNtzjN3fzx0ueQb9WwTWcMMkAO8GOEYKWUMzk1O3/43qPsj3+2EumTs9GJppkCrD
 x0YjrUEc
 VEW3OtniQ06UnLhbU6rkqaDJCV1XnELPTJ4Kf1XbxaMvlB/U+7zrlAnCEeyEEAjZ1HUoAYE+vG7ITfamu8oU/SNgiWE86Y8ukcO/JB8VSVgHTc77k3DZpabt1m5B0xuRu8u4dH+Vl1sgV6VP5UaT0ZXwi3Yhji7xiKYKxEESWjNwSo7nQ7dzt/SjY9cwSsjkb+6hBpTQWf3m9+J0/Kb/8ZW7MJ+qIUBSoNch3KEyllZsoJM2z3vhtq4XkaWYvLx14gUPut11FOEHPHp+WT3YGHVxDInY/G3VU09kBMa1O4q7hpQVxij4U1DNg/EeF1KnShoyHQVTwf4tsmDBGnRVfTDtHzYzXPyCvErsWZSp5TxyS7a7EFscwVL8nvvVjPdd67ergCO6zKpNcJQm5UF9nRHcVbfk91wnfKNvQ1pJFp4PDYEmgV28a32cCbs+Qr6qV6xK4tn2Z9Q152v4U1GZEo72+vCD3w4RU2yC/qPVec/Q5TTFzSMwSCY8i7hvFq+nPtaLZWCVdhkP7S8sjJjnFfNQrl8im8KnpgDsbY3qwjqVcSNq7VKu9TIl++Q11BbtXwV6wboCuAZkhlAn9FKozTRWih2QrK1+T9W2CRJv7LdD1N459kTJbYwn0TgCYrYqzQ30F4f+ygRT8Wew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Apr 2026 at 16:37, Marco Elver <elver@google.com> wrote:
>
> Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
> flexible PARTITION_KMALLOC_CACHES, with the former being a partitioning
> mode of the latter.
>
> Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages a feature
> available in Clang 22 and later, called "allocation tokens" via
> __builtin_infer_alloc_token [1]. Unlike RANDOM_KMALLOC_CACHES, this mode
> deterministically assigns a slab cache to an allocation of type T,
> regardless of allocation site.
>
> The builtin __builtin_infer_alloc_token(<malloc-args>, ...) instructs
> the compiler to infer an allocation type from arguments commonly passed
> to memory-allocating functions and returns a type-derived token ID. The
> implementation passes kmalloc-args to the builtin: the compiler performs
> best-effort type inference, and then recognizes common patterns such as
> `kmalloc(sizeof(T), ...)`, `kmalloc(sizeof(T) * n, ...)`, but also
> `(T *)kmalloc(...)`. Where the compiler fails to infer a type the
> fallback token (default: 0) is chosen.
>
> Note: kmalloc_obj(..) APIs fix the pattern how size and result type are
> expressed, and therefore ensures there's not much drift in which
> patterns the compiler needs to recognize. Specifically, kmalloc_obj()
> and friends expand to `(TYPE *)KMALLOC(__obj_size, GFP)`, which the
> compiler recognizes via the cast to TYPE*.
>
> Clang's default token ID calculation is described as [1]:
>
>    typehashpointersplit: This mode assigns a token ID based on the hash
>    of the allocated type's name, where the top half ID-space is reserved
>    for types that contain pointers and the bottom half for types that do
>    not contain pointers.
>
> Separating pointer-containing objects from pointerless objects and data
> allocations can help mitigate certain classes of memory corruption
> exploits [2]: attackers who gains a buffer overflow on a primitive
> buffer cannot use it to directly corrupt pointers or other critical
> metadata in an object residing in a different, isolated heap region.
>
> It is important to note that heap isolation strategies offer a
> best-effort approach, and do not provide a 100% security guarantee,
> albeit achievable at relatively low performance cost. Note that this
> also does not prevent cross-cache attacks: while waiting for future
> features like SLAB_VIRTUAL [3] to provide physical page isolation, this
> feature should be deployed alongside SHUFFLE_PAGE_ALLOCATOR and
> init_on_free=1 to mitigate cross-cache attacks and page-reuse attacks as
> much as possible today.
>
> With all that, my kernel (x86 defconfig) shows me a histogram of slab
> cache object distribution per /proc/slabinfo (after boot):
>
>   <slab cache>      <objs> <hist>
>   kmalloc-part-15    1465  ++++++++++++++
>   kmalloc-part-14    2988  +++++++++++++++++++++++++++++
>   kmalloc-part-13    1656  ++++++++++++++++
>   kmalloc-part-12    1045  ++++++++++
>   kmalloc-part-11    1697  ++++++++++++++++
>   kmalloc-part-10    1489  ++++++++++++++
>   kmalloc-part-09     965  +++++++++
>   kmalloc-part-08     710  +++++++
>   kmalloc-part-07     100  +
>   kmalloc-part-06     217  ++
>   kmalloc-part-05     105  +
>   kmalloc-part-04    4047  ++++++++++++++++++++++++++++++++++++++++
>   kmalloc-part-03     183  +
>   kmalloc-part-02     283  ++
>   kmalloc-part-01     316  +++
>   kmalloc            1422  ++++++++++++++
>
> The above /proc/slabinfo snapshot shows me there are 6673 allocated
> objects (slabs 00 - 07) that the compiler claims contain no pointers or
> it was unable to infer the type of, and 12015 objects that contain
> pointers (slabs 08 - 15). On a whole, this looks relatively sane.
>
> Additionally, when I compile my kernel with -Rpass=alloc-token, which
> provides diagnostics where (after dead-code elimination) type inference
> failed, I see 186 allocation sites where the compiler failed to identify
> a type (down from 966 when I sent the RFC [4]). Some initial review
> confirms these are mostly variable sized buffers, but also include
> structs with trailing flexible length arrays.
>
> Link: https://clang.llvm.org/docs/AllocToken.html [1]
> Link: https://blog.dfsec.com/ios/2025/05/30/blasting-past-ios-18/ [2]
> Link: https://lwn.net/Articles/944647/ [3]
> Link: https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/ [4]
> Link: https://discourse.llvm.org/t/rfc-a-framework-for-allocator-partitioning-hints/87434
> Acked-by: GONG Ruiqi <gongruiqi1@huawei.com>
> Co-developed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Marco Elver <elver@google.com>

Sashiko found 2 latent issues in the diff context :
https://sashiko.dev/#/patchset/20260415143735.2974230-1-elver%40google.com
The fix is here:
https://lore.kernel.org/all/20260416132837.3787694-1-elver@google.com/

The irony is that TYPED_KMALLOC_CACHES would have helped mitigate this
kind of overflow bug.

