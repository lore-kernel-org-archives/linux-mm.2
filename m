Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF682CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 18:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2458E008D; Fri, 31 Oct 2025 14:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2888E0068; Fri, 31 Oct 2025 14:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB89A8E008D; Fri, 31 Oct 2025 14:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A81758E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:31:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B946C05FE
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 18:31:17 +0000 (UTC)
X-FDA: 84059251794.29.CCE6C62
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C290C000B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 18:31:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qV8FwSI9;
	spf=pass (imf22.hostedemail.com: domain of 3cQAFaQgKCNQ902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3cQAFaQgKCNQ902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761935475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EmsAdmUDoKsJ3nHoaGiAdPdYRnKJhE+ODFWyv6RuBg=;
	b=vpmFTrq+aSxFr8NnZ+W6wd4KIB7D6kWf7SOkXRF8NYDIKeQHXKT3qy5uC58bGWfbc2+vhM
	fCOqO7paVcrWpSMch9IvDWUYVf3rLJ/ED0ptdnaY0YvW7tWBpX+mCW2MG7xKw68TDvgcC/
	6iWlRRtTTdRzMAj7JmcqSex13UF0AeI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qV8FwSI9;
	spf=pass (imf22.hostedemail.com: domain of 3cQAFaQgKCNQ902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3cQAFaQgKCNQ902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761935475; a=rsa-sha256;
	cv=none;
	b=S2AvUMTHTJ7h8ZksSDp8VmGjZxoaY7Ln9Uh1Rog4SGBmu+vjW7NLqwhmE89e6goM24QPep
	YCNHLWSw80ltrOwCS1nzfiGdR5MpI8Dpm24fLoMVmarBay4+/6ai7Ov62e3e7N5jOvO+y0
	RPioC7wAoiVxjmCmgSCtz7jjxzxkrr4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47106720618so27138365e9.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761935474; x=1762540274; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4EmsAdmUDoKsJ3nHoaGiAdPdYRnKJhE+ODFWyv6RuBg=;
        b=qV8FwSI9503CDxwvGKXkTdr3gp+JuvKUgyekql/oMbAOV4gSjm1FkY5kkL4xmbyTSH
         nJbJ6kuU6ENTrQGEHVA/21j/HOOWbpI0CN0JevYH+tUa6lHTtraV1st4REGdPBeN3wBa
         K/Khv+SBKSnzpt20rw/N7WSzUjQg3H/r9IPwOKGkw1oIOKr2XJDQ9ZtLIAWqiLPmYGsq
         t4jATHiUPTpeEjSASLq1Z8U6Yzh7l1TzMNzEOaTVQtGdoZRDngXG0EMItcx/yO7GlSMM
         o06MhPtZ+qArLyxPVUS4qqKUXYEwbidKFEsoV8KC2FUhfZXZ3h+mQZ1zb/JG/H0OB95H
         72Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761935474; x=1762540274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4EmsAdmUDoKsJ3nHoaGiAdPdYRnKJhE+ODFWyv6RuBg=;
        b=tLitY+Ny7H7mYlkjVfzJ/qN3ITr39iCqoI9/ykAYT3jSmUCmuPQvCA++d+zlQRMrr+
         uC3VWSI/TyGf6Viw9fFYtx98+vxyk4vetD7T56EurHTcbhACyoP2QSGttBRmRbwlENol
         uULS0t+EizIs5cheZcBMWXaDhiYNiiWcIG5FFiyMEUTfkH7BXNHj+xun6qmX4DimbilL
         ym8evCiAyEZPKjEvVcCsfVz2ULJdU6mm59eQ/+fQOg7IGVi5giv4qqTXprmH1V39R08z
         emIiMGwOshCe9XufYQlHz3ZMLdyTmpJNS8n7htOee1p1gzvoNv82eCuWkdVi+GqUJgy1
         v4nw==
X-Forwarded-Encrypted: i=1; AJvYcCXaJ5F3pxntHPbHC92pmO6rcXY6aGtjki+NdxnrZjHTkwbfpdygOmbnXpnR4gITGowhkzvk5JXq5w==@kvack.org
X-Gm-Message-State: AOJu0YxcQGQahdCWKT+boEv+Yqa0ro+4vWv/MbxAxl77zQgYeF/tNutM
	aTX8m2sUhekGIq7K96gqyaoXyEJ0UL+y638Oq7CuExbN1vPJboGHXCSIADHXvR4BAdCBlp9ILDm
	HxMl7ANA6tYDyfg==
X-Google-Smtp-Source: AGHT+IF0oSz4CxTQF0nqeQnWSAmNxvR2sRC2JSlBMi4CM6sxr7VzMzJzOGlnc5XOQifgEAhMHxR06Z4dSq+21Q==
X-Received: from wmat7.prod.google.com ([2002:a05:600c:6d07:b0:477:17a3:394a])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:528d:b0:46e:1d01:11dd with SMTP id 5b1f17b1804b1-47730802d2fmr44933805e9.2.1761935473616;
 Fri, 31 Oct 2025 11:31:13 -0700 (PDT)
Date: Fri, 31 Oct 2025 18:31:12 +0000
In-Reply-To: <DDVS9ITBCE2Z.RSTLCU79EX8G@google.com>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com> <DDVS9ITBCE2Z.RSTLCU79EX8G@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDWPZY3AA7BX.1Y05FOYIHAI07@google.com>
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Dave Hansen <dave.hansen@intel.com>, 
	"Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"song@kernel.org" <song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C290C000B
X-Stat-Signature: w15i5e9spwpxj9uxmep7g1ag31isdzsd
X-Rspam-User: 
X-HE-Tag: 1761935475-684803
X-HE-Meta: U2FsdGVkX1+pbFDEg4uSOYDLsFmiGGvXCe8ZQ3/x5IPFm1jPiPc/PUVuW8vO9f9GRgQqRUuklJqrwMUZlUPhu83Jr9HETyyb4D9u249bTvMP5zSw2PqR/QOQEcllNfBkcIFrVyHBjHXT519MUNNdGRU8zaCZapZk1634WW50LOG8HuKWpAu4/W7HJgokkYf0qwKTndVsECg0LJmCIyic4dinx1ilE5uKMeYzPUG/Y9Zsfh/IIAYMxc//1lWWU5SSsMQx/sniNHzOEevw2MbQlqYB3QWF07MBj/22jXuNLdY1cQKxxm+rbTFdUxXds6pHbAN8RTKt3R9kfMRQMe776ewJtpGLJJjIII37vzYP17cypTFlw3g40K0OzmZ2ApgyhW7AgR9T3Chd0Xyyz2A0xpi61J5xSlS0Scd4S9LUx8imMz9vZ5On3JuSJeFj0yAnZpXX4ZnLQzsot+QZ5TmCnoRoMxZXG0SL+/7UxgLpBq+xTxEYuhsVbV6WhDWuBt6IQdbcvownHdXZcBjA6j/89eMzcrzO5axwZCbCWJ9sV9vsgE2WJ2uBPmzwuvEb/DYDui+yET8of44gKAEhkLOKteELNQ94ylhbTm9sGNjvVrb1NkA0/15TgUikb60g1kTQ4auiobJV+RE5cJZV2HefpqsrnEKYB0ObtT3tXbJAZSZCtVggYaNIrge64me91th1bOym3uf1K32wt1j600mVDJj6vR6q6tqPOt7LbF1SSE7PTFqe35a7UD9a/ySDGcGQKWpG8Po/2nLJQaCgW7GNj+/Iy0SvyqiUPrGP8pYdVtP3nyil9GoNeMkjrAo0q+VOtDc0axtPkA2bDvpWGmE7z2xAwL6MPiSmxvwVKpUbHx6DQc/KgO+86/ftIXD4SKkZI8MP+mgkyzGAELS5LziAzbONZxys6xrINuK7SvBUFbPGGus3v06hNnV4H8asx56gDCGULjfmC/zOakKik9i
 fJ1Hcb3U
 A+bATlukxZLtfUeE63zJXuWk8p6gSUUAaEmbzkvjWT7MA0UEQ7T4aVKCaxy3knb/u8vmVjHw+ahPYPJjRV9wtb/lLKRQEqE8vA9VM7R46tYsIcLvkOfKepV/bM3OBp6zFxILVBxDFhy1Rlj9JF5PQalHa3vG/E+AjLLbPDa5VztW1pZjAYKa+h+moSP3sei32++xWkZRDkqxKjwfR/nXVPrAh7tD74uRtjvyYMr493/0nCO3KGBI4blA+TMioSgxbGimkEJd41EC96Dgn6SBIHkHJCrUmophwuUV7R8NenYNGOzSO/V4d+Y0MaBk8oD0+2JcDZbcNTgdsJy+rKWQp3X6oZ8pES4MnkBcltyV7AErOPWU06p3bKk19zgzEC9yDBIUJObq3PYsywZ+5ZwURekcNYrhTv4VgnVg7PvRpn+pHLZlbaTs6yKioPGM697b2zDx53HhgMXYZ7xPmPLRoMs218apxFj77MB29JyTHBjOxJDZE9Ei7+16vEB//4B4+ilLyWho+wwLTFBP2SyrwQIuyJXCCGVs3v/ZO58iBbH6VCOlIfI+CQ9+m/EZJ8BGxuvvkSsLotEilfqq+r5RQPFMppBimojB5fuEVNlX+oqv3kP96eqpo6kDmuIp2f1fWW5SMLuPUmuyko0JBL3ZewU94o6VuvGfqY3fJ91fmtYspR1cxT+CYEZFg3KPj/8X9wCru4OyQZGPrVECqArA6SMUMkKMOR0T0G0BKS9y406HX/VAw0PnvfvN5msd3Oc0d4Dao/b+NkFhYXKp3C6SY31T37moMq/4K9j7Q6+pCxKnq7ed1+1FjfkwdQf64Ybvkgd5xYf96IZZLsE6IRRR+UOWxZiBmRXueR5RjSnXUfruRLqwZDl4vP5FHaS1dgVyhw4L/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Oct 30, 2025 at 4:05 PM UTC, Brendan Jackman wrote:
> On Thu Sep 25, 2025 at 6:27 PM UTC, Dave Hansen wrote:
>> On 9/24/25 08:22, Roy, Patrick wrote:
>>> Add an option to not perform TLB flushes after direct map manipulations.
>>
>> I'd really prefer this be left out for now. It's a massive can of worms.
>> Let's agree on something that works and has well-defined behavior before
>> we go breaking it on purpose.
>
> As David pointed out in the MM Alignment Session yesterday, I might be
> able to help here. In [0] I've proposed a way to break up the direct map
> by ASI's "sensitivity" concept, which is weaker than the "totally absent
> from the direct map" being proposed here, but it has kinda similar
> implementation challenges.
>
> Basically it introduces a thing called a "freetype" that extends the
> idea of migratetype. Like the existing idea of migratetype, it's used to
> physically group pages when allocating, and you can index free pages by
> it, i.e. each freetype gets its own freelist. But it can also encode
> other information than mobility (and the other stuff that's encoded in
> migratetype...).
>
> Could it make sense to use that logic to just have entire pageblocks
> that are absent from the direct map? Then when allocating memory for the
> guest_memfd we get it from one of those pageblocks. Then we only have to
> flush the TLB if there's no memory left in pageblocks of this freetype
> (so the allocator has to flip another pageblock over to the "no direct
> map" freetype, after removing it from the direct map).
>
> I haven't yet investigated this properly, I'll start doing that now.
> But I thought I'd immediately drop this note in case anyone can
> immediately see a reason why this doesn't work.

I spent some time poking around and I think there's only one issue here:
in this design the mapping/unmapping of the direct map happens while
allocating. But, it might need to allocate a pagetable to break down a
page.

In my ASI-specific presentation of that feature, I dodged this issue by
just requiring the whole ASI direct map to be set up at pageblock
granularity. This totally dodges the recursion issue since we just never
have to break down pages. (Actually, Dave Hansen suggested for the
initial implementation I simplify it by just doing all the ASI stuff at
4k, which achieves the same thing).

I guess we'd like to avoid globally fragmenting the whole direct map
just in case someone wants to use guest_memfd at some point? And, I
guess we could just instantaneously fragment it all at the instant that
someone wants to do that, but that's still a bit yucky.

If we just ignore this issue and try to allocate pagetables, it's
possible for a pathological physmap state to emerge where we get into
the allocator path that [un]maps a pageblock, but then need to allocate
a page to [un]map it, and that allocation in turn gets into the
[un]mapping path, and suddenly, turtles.

I think the simplest answer to that is to just fail the [un]map path if
we detect we're recursive, with something like a PF_MEMALLOC_* flag.
But this feels a bit yucky.

Other ideas might include: don't actually fragment the whole physmap,
but at least pre-allocate the pagetables down to pageblock granularity.
Or alternatively, this could point to an issue in the way I injected
[un]mapping into the allocator, and fixing that design flaw would solve
the problem.

I'll have to think about this some more on Monday but sharing my
thoughts now in case anyone has an idea already...

I've dumped the (untested) branch where I've adapted [0] for the
NO_DIRECT_MAP usecase here:

https://github.com/bjackman/linux/tree/demo-guest_memfd-physmap

> [0] https://lore.kernel.org/all/20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com/T/#t

