Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB60CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 21:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912586B0088; Mon,  4 May 2026 17:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B676B008A; Mon,  4 May 2026 17:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C3B6B008C; Mon,  4 May 2026 17:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5A86B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 17:23:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FBFD1402D8
	for <linux-mm@kvack.org>; Mon,  4 May 2026 21:23:08 +0000 (UTC)
X-FDA: 84731012856.24.43036F3
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9C7514000A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 21:23:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a1Iwoo7F;
	spf=pass (imf17.hostedemail.com: domain of elver@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777929786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igyU2nx2iftItHLeQpILR+qCdofiKDiQQ2B3kQIIdT0=;
	b=G1ZOzlRSHTJhAv1J79vmN1z/AYR7VnTs83PyzkKfWavOHXj3X1WRTaSKQLEEY39Bjbyonw
	blYk3GrSRHLiAD9bXFwM85pjdidsWwj8M2Me4yTr9/GsleNSbjn6zz3LEzPo5fvVvHvT1h
	0M2riGNJVsfR3ublyY5GwEdaJKfEFnc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777929786; a=rsa-sha256;
	cv=none;
	b=wbJi8W0zUBOqpFko4EYEn87al8p8IRN/Mn4i3GwjbQZkVWOOl4dzFYGAXnd1Wa4gvoiiej
	mlRe9UupsLodwGpVf3XLAzfzMDZfA4lt7nEQmMH8/RbZInynFFNrsvZ6yDc9XHjudMoYSt
	+srgdleY9I9g7i2kX8VHxhPv5wASriw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a1Iwoo7F;
	spf=pass (imf17.hostedemail.com: domain of elver@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48d146705b4so2827575e9.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 14:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929785; x=1778534585; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=igyU2nx2iftItHLeQpILR+qCdofiKDiQQ2B3kQIIdT0=;
        b=a1Iwoo7Fmg3xWPqaMmwn7YX4375jBQ2BarPTCrSjDJSZBFz8JBNmet/KvbDG/xvdq4
         JF4jWF4sJv7KFzmC6A33+jVxXpEYORgc19m+927AAACcMjYXt+Sk5NMCG0ERpOOyAWax
         tC2ttuHw91ceA5kXdEY02Ug4JgjjgNNqv0fPk+HV+Wjl58mDT065mw4lXcfNTxutHguX
         75TpYzL6KoiSO+wtHDvsM/u2viRvgQ0yOaUaXmQFzF8NicaChV5lWQMGBAHfSkMLdSCh
         Wo+gTiadtRR0AbfZzljtOV4yHnPhf8yMrkitRW9e3P4PpG4EM3X98Qk9SwGiW0qj6wOh
         ufeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929785; x=1778534585;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=igyU2nx2iftItHLeQpILR+qCdofiKDiQQ2B3kQIIdT0=;
        b=Vnp5TdnaP0BYml2bJNP9ww4/v7sRTsx3bHh9hDMbn8Dq/us3+957G6cLvNLatmzua9
         tdljXqK5IH+ZbUJXQuoIWetDRt2DIqYj0Xm87DN0zAuK8o3N8q9B6kef84rVpPFZmeEs
         bZ/Qdh1L4AYjCs9X52oNwC397eWKJBIhMHcF18U0NEnVEaAj+jGOHNnAI8d2cQNexOOk
         7eimz09gYLEDYE2c32xlkCJCSA5Agf8cUMVCQjd+P6E4BUTgSOeot0kWW879riN4RbJt
         v5HpSwN0NLpldXzlzzr5jMYnm2rOjr5nWAWBbCJjFSYwSbZp9GUYe6gcJxMYsw1akYGT
         FETg==
X-Forwarded-Encrypted: i=1; AFNElJ8OERySA8QMn69yii3yccymrZMCy7TukU8Xo0uVz4G/o38n1ZF3xbyMV4pIpK9h437n4wmoBTPuSg==@kvack.org
X-Gm-Message-State: AOJu0Yz9wMGbjD3YVukAXs1y1DfAu6DYJjc/E95Let/G2GvsNBX0w8hk
	E9C9rYtqjk4KZjprIUkOuHXAdjd2CKwbo5/OA+a4pgtNG3QmkvJDygTDMIssPK59UQ==
X-Gm-Gg: AeBDieveKGPiSfj19CnBEfEPMamOUS/xc27k8MSQsdJJXnhIClHfBKm9/hptb6BCJO5
	MEJyxw5O8BqzC0MOCm8Mfra7+HKDNI7+476i1l2qyFWujnX+vMq+9Rg0+Goq4hBWKEP6LWOVmdv
	cmgEJhClJ47BBwv+k/NVMJ0VgUNwGI2W5vbxEpWzC0aaGkjgdJaGcfDAMDQ8vu66rY8NDAr6/H1
	ODiEwg9gmqE3lSGsW7M4ANZYZE/+kE6Cw8mgVirLj2bjX3MzMikphZamUPSeFJkzQdgX7YwfawC
	GnSv8+zolZVFyKVgTUtUFm4+bVaHPv4SGe6evwNDfipE9pjmy46q1BZiUFF8ma/Rd+FK0KXZaq0
	PO720jbp21jRfZVneR3IcV5Ds242j33FMrQ+xBX9JWVOt5cRRmm6r4V3lTOcC577oef/fxWkfT2
	yH85yj+5OsPiGeDlZBbXb+MZ01zlJFBn8KSUK0jNHt5RRNu9f5A2vJCWICUdzvSyUvPC8wbdTsY
	lA0DKXqnw==
X-Received: by 2002:a05:600c:a30a:b0:489:1a3a:9e45 with SMTP id 5b1f17b1804b1-48d18cea8damr2194915e9.26.1777929784562;
        Mon, 04 May 2026 14:23:04 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:fba5:1281:871d:3fd6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eb694fcsm323128615e9.3.2026.05.04.14.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 14:23:03 -0700 (PDT)
Date: Mon, 4 May 2026 23:22:56 +0200
From: Marco Elver <elver@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>,
	KP Singh <kpsingh@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>,
	GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH v3 1/2] slab: support for compiler-assisted type-based
 slab cache partitioning
Message-ID: <afkOMIPu1WNFE9MS@elver.google.com>
References: <20260424132427.2703076-1-elver@google.com>
 <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C7514000A
X-Stat-Signature: ise1hpotc9yeh3y5kxq7gd8wcmpz9xwg
X-Rspam-User: 
X-HE-Tag: 1777929786-550766
X-HE-Meta: U2FsdGVkX19tqs0xQFYSKnbU/clxhkqOJOdm+gnQzMx1iVhwoHNuPP9RTE0Y5umKn4bkObI//pzE7tv3K+Qj/9eEYP76NbOSYgvlr+zzjXwdF1jx3JLKaEJrML1swUGZdwRlIrDUb4L0SSfizPIhYo9E6jvA48icfQG99rMbEzY25je3i3jSIxlDIYpuJT/KBod1yEeXvlF5apdJcQ+xv/Q/mIRksXfE94faFSmfqLKE2oWgkLwaUd0lOdhDznfpeeDUBrOt+QFgdrjGMmiEWmDStHKNreP3HJHfv53HJS7arJPhxV5uX3VQ7owbU2dmtkVVsgIeqILLotHqODgPTYzTuZhuGMaAnHKa8tPJ7qv+1Qqn8EIVamnd8DJ07+LaryYYARD2NYW7kZqKufw5sMXYQzCJqnO2drIZ1YIAupq1q4Nxvww9KK8Lxra+6qmnPmwcA2wklPUMdWzUzGjBKCYkCiNV0gxW75yDnovJRCF+p02qAIZZd/mFaC/dI3uwhJv3J+N21xOwnGN8jCn8eGO6oy53o/BN16/hYwtlv0Y89Iz+KAJGlIn/2HxbIXmBDEnAapYfn4VKJ6YHVfrCKxGAj6QVPgNLKWU3n0an9uoJI8myoQxvx3+LwO4kj8UIG7rf3cVFQ9/SNCQCLOnCnK0VYPt/uh4rjsIVCNsKUSfIxEaVuUdrD+9wM5nyeCdivDgC+0m4yQULZGwpV7U48iwRjGkQJmJjxpJVmEaEHLoAafUHnf9zJvXvRdMWDyxfQphg3UWnl2B6t0oeRpOsAJKRP4sWzyeF3JIs9wIKAxlTDPPxQbVqpSlIF2AYjJ8Xou+GlJGdkCpPSsCAb446a4aZISSEqz9remLzs0HN7lvx/xGUB33l7z92T2C21au4CBvREVWNkImBdDBrH1X4LD/jyEn37qbLYgvaYP130/M5d/yo1NBhsbeNCUWgd9opPuF5ikG49cS2L0Bu6my
 rpn8kAa9
 Lke8PfniDsojaqm6NZojVPwX/rF0+S7BwBXpr1XCQubU6g/OL9S8J/Ey6prLmZDnJUGAU/2YwdQ/KEsYZX3BONhZYWCdsRlAPVB42XDNgJcWFBtKgLmPnZYvmYdot7h7KFnTXZVr11hmAiJkdzevDiPIJed0yX45FJnDJhkvvY9xCvsuAVbwZBzoQzZjMNzRUL3cOaFnzi+VYN+5EkJovpiIA185SV8TXB15L78tiLRe7vvppuhSdgKlvypXTbZS3RngehdC6tYzMZ5zi3JSiZwKSNzMTkQc2cl3ycGNbAbhNVMb3DZjjOqClhDaOupvSzIa26gz6cvW45Mz1TI2/+Pzg8zCfuwfsRCfVTSsvHksCkP9torWWyrlvxh2rBwceqNOxlTxyElM7UOm2NevuvjxWEuyCb8032Qyo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 03:03PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/24/26 15:24, Marco Elver wrote:
> 
> > @@ -938,7 +968,7 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
> >   *	Try really hard to succeed the allocation but fail
> >   *	eventually.
> >   */
> > -static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t flags)
> > +static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
> >  {
> >  	if (__builtin_constant_p(size) && size) {
> >  		unsigned int index;
> > @@ -948,14 +978,16 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
> >  
> >  		index = kmalloc_index(size);
> >  		return __kmalloc_cache_noprof(
> > -				kmalloc_caches[kmalloc_type(flags, _RET_IP_)][index],
> > +				kmalloc_caches[kmalloc_type(flags, token)][index],
> 
> While reviewing this, it occured to me we might have been using _RET_IP_
> here in a suboptimal way ever since this was introduced. Since this is all
> inlined, shouldn't have we been using _THIS_IP_ to really randomize using
> the kmalloc() callsite, and not its parent?
> 
> And after this patch, we get the token passed to _kmalloc_noprof()...
> 
> >  				flags, size);
> >  	}
> > -	return __kmalloc_noprof(size, flags);
> > +	return __kmalloc_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags);
> 
> ... and used also here for the non-constant-size, where previously
> __kmalloc_noprof() (not inline function) would correctly use _RET_IP_ on its
> own ...
> 
> >  }
> > +#define kmalloc_noprof(...)			_kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
> 
> ... and the token comes from here. With random partitioning that's
> #define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
> 
> so that AFAIK makes the situation worse as now the cases without constant
> size also start randomizing by the parent callsite and not the kmalloc callsite.
> 
> But there are many users of __kmalloc_token() and maybe some are corrent in
> using _RET_IP_, I haven't checked, maybe we'll need two variants, or further
> change things around.

Good catch. I don't think we need multiple variants (otherwise the TYPED
variant would be broken) - we're moving token generation to the callers
(not even inlined anymore) with all this macro magic.

I think this is all we need:

--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -503,7 +503,7 @@ int kmem_cache_shrink(struct kmem_cache *s);
 typedef struct { unsigned long v; } kmalloc_token_t;
 #ifdef CONFIG_KMALLOC_PARTITION_RANDOM
 extern unsigned long random_kmalloc_seed;
-#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
+#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _THIS_IP_ })
 #elif defined(CONFIG_KMALLOC_PARTITION_TYPED)
 #define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })
 #endif

Plus a paragraph in the commit message.  Let me add that.

