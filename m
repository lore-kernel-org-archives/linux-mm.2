Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E59EECD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC006B008A; Tue, 12 May 2026 08:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3666B008C; Tue, 12 May 2026 08:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9266B0092; Tue, 12 May 2026 08:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB2066B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:55:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A8DC1C0338
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:55:19 +0000 (UTC)
X-FDA: 84758763558.29.E7B1408
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 64CD840006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:55:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qzTb1PDH;
	spf=pass (imf17.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778590517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k001GOwiMb4dRczjtWUwITXHZjyE/lTx6um46NJkiUA=;
	b=AzL55sR/Qmx0JGFXjCLVcNfyOtbi00Ng/K33XtPK8Uw/sRMpTpPl7oAcd19uACQBO+Y5VG
	dmc9xZXTKCKzB3EGF28aJUyZhxzzg3X4NtP2le/wp3inyv9LtnEdMsaQFZBK+I90Z+3Ty/
	oLliqW8C942sbQ86ssXxEjkDs2GURe4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qzTb1PDH;
	spf=pass (imf17.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778590517; a=rsa-sha256;
	cv=pass;
	b=z9rwZM4t9X0/ZV73mzTZAPwoQSXUSbl06WpVecpYUMDgIPIFrVeLawDkcPc+dpkmTqnQ1u
	m7aV2GU2vJIwzcsS6CjOGVGN82/h/07hU2IAluSiKatczwyMNXmWB1RutHytEKvTEiL1os
	5L1YvzdiLQ9vyHwV9UELWUgS34hJzBU=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-13354eb66baso666404c88.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 05:55:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778590516; cv=none;
        d=google.com; s=arc-20240605;
        b=N5JZ/eHs7N7eHGsmFHEs+qSZBSPy34poGsyTm9ajHRRgBvYQQf0+9gSxPWAmq7fhFu
         yG+7vCJ+fRZ9LKo/GAbKcawhYitgiOxPrDdFWFFYF4wXZzyl1vDAVjm2zcBkFia36dzD
         pvNGapIMIYwLXk5ZP3YEcoe9PZ/xMSfFA8Wm8gHGv9fkSWE0Xit/lHmbrdiA/+3fP9q4
         bTvQ/66/oYgo2Ng0+b44zrgG2QPE08UFoA8eIPqHZ+sMQOygZCWismTpSy3x/m+5AJh3
         1pvXLAaOG5Izfr/ofPUXTOCfuHxgsS8wxv4MiJzyxsImIKQtKzL42ObXHJPUZ46dUBcS
         I0zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k001GOwiMb4dRczjtWUwITXHZjyE/lTx6um46NJkiUA=;
        fh=zZQdxdPed9A4PZCX3OgsVzIm5HTA7h2O6aDreTAD9co=;
        b=DLMlvF7SiKZa8no3jogerliTTaN+Kdf6NphJJsWbJwDaLJYZRCsPgth9kxbz53aVkn
         1xMcqY06lI5uK3U+9kBG79gwp74SnlbC7kgkd9HAXCLHgPbiV6XfeBfbbFeNTdWv1s3q
         CeebDnvqBhG7RxfeuEHhpORDym+N5kchXir0Z2KkOUQW32SZrp7aohnKbcrnLHCH/Pos
         08VFOJfiHRQ5q6qtueuQmSD5wGRK4wJ3FKEv8g3q6Kmgg968D2yBIitd2PEHq2/wQXiT
         Y6m1rHKtIEYKV0fXNqnzdiIg5s9TGBqlmoLU2GeNdr9g7sx2ZIGuYZF4wcutFpmtvwc+
         b/Og==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778590516; x=1779195316; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k001GOwiMb4dRczjtWUwITXHZjyE/lTx6um46NJkiUA=;
        b=qzTb1PDHGxLXG1PXQLCoj9FD4cI77iYdy1vngLKJSUDR+6vfRM2fIggcECBNd0IlQ1
         NbVoNU44DND7CcixHBUxvMHTtl4Bh+wQT8G9sfjJBsVdTXhIMgFk6baq6+nc0vxKliGf
         750tkoFHOVp9/AeCjt85brHpnIQuVhBoKBLKolcpA/SZtxr05GG74iPJYse52yxgxNNk
         nn/pSK+OFZXSp3/FUZluBYZoDDcmN8QFM2j/rp/dc0H3t9T9rYVeKAjx3wdejN58zxYw
         cYozELR0pPeZO9aEjwvFWiSq2y38U/jYAlKGemzOGGZaEwy7C9MGb+0eYhEQG4y7iPas
         HIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778590516; x=1779195316;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k001GOwiMb4dRczjtWUwITXHZjyE/lTx6um46NJkiUA=;
        b=ZAt4mrnZZlvwmVGHo1eVeAnXsEm739yQ6/mYXCXsW1yq00naB6HFx0AX5PogTOY8Hw
         eRtOPhj71QVjRBB5JBRIHDkNNStMF8IMp8o7v4AhWydUUlnCC6+xzrZnyFgS63qYGqFC
         UBF84XDfqiaJNVz5gHL6alwrF4CIJ3fzZVWO4WhpvqJtHXcwshNLlBGf+FmFAZzcF3Df
         ebzm/wEcPeAKV/W29QjnxlFbCrQtM7x+C0icS9QmiyRu4WRCcmaPG4/cF6QVFGLvLwcV
         AgdfM1lv5a9ja0bxEy86KALYl4TwrNfOmGyLhOMToega8BgXUjKUxIh6e6bXUBbMk1Cf
         Bi2A==
X-Forwarded-Encrypted: i=1; AFNElJ/sQDMyNGVMuTU7l8z5LI7HLdi4Vd649hgQv1umpMjHobP0fL8fy94zKSYCZZvC0LDaWotru/ayOg==@kvack.org
X-Gm-Message-State: AOJu0Yx9ke5ejhOWwRxPZwUJWVoe8Zj1DnvhfqpOAmq/7KIcvqiLNP1y
	vb4THy67F67yCXLjuWMSOQjiRHETth0ApA0zKbThOoRwKxl/JfbC1GHaKEDuzJ+tP71BTM5uEv+
	yICfNGhdMWhXn/xA+BBNd6c0vGiyadHcNfftwoh/m
X-Gm-Gg: Acq92OFl4Z07rH2noBMhu6XTzJcIBVVLB8/linoY21i/57XCwyh99LErOrSuG+saHPC
	g24IYWWvdidrbnIBYwO6Mth2C1RqSTsdKqUKb2A90+Lsywa07ziZ62ZcVgSLhUhKH0gofRQywh5
	28lDSuN6sX4dMhcTu3N9iTgj2Kqp/swTIOxgpIgtYfSHxvrNL4pO53UB2gUc0j3pZHEPAflgKBe
	/9PGevEcyc5UHWZbsy2yieVCaIGaj+1LJ/oaZ/ld1P2BsD5LJUYtOWIgaYo6g2UfS8Meop82XtV
	w/hVDiZU7NLvbhhl8ULZR6PDf+GGjwmApDETt8Z3qjgV
X-Received: by 2002:a05:7022:2529:b0:12a:6a64:81ee with SMTP id
 a92af1059eb24-132a7edc7a5mr7596782c88.3.1778590515386; Tue, 12 May 2026
 05:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260511200136.3201646-1-elver@google.com> <20260511200136.3201646-2-elver@google.com>
 <afc2202a-2e0b-43e0-9556-06be2da33c83@kernel.org>
In-Reply-To: <afc2202a-2e0b-43e0-9556-06be2da33c83@kernel.org>
From: Marco Elver <elver@google.com>
Date: Tue, 12 May 2026 14:54:38 +0200
X-Gm-Features: AVHnY4JQX5cZZPTvWGLXHBJoCN4agKvIY9SusDXvPP6Ojv3wTK7cyl5mLfOsNmM
Message-ID: <CANpmjNN0-b0TG2=7SsPpRuubwTWYfoAiYgnnM_5-39SoVfv=Pw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] slab: improve KMALLOC_PARTITION_RANDOM randomness
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
	linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7aqy3148wor8891w598xmii8m4ypdmej
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 64CD840006
X-Rspam-User: 
X-HE-Tag: 1778590517-925319
X-HE-Meta: U2FsdGVkX19oyXnTXjVW8JI7Anj3KlEA7DdGr1cSYbPNQywJ/mR/h+REbjfVMM7E7LhJz49spKlG1s26T+Y94qSwcNDGOWxRtqkNU6m5Owqa47lyUJjTMrZ5saECdsTNI2UiRxuGbKmPGyzFPDBK0Pnl+1yWnqu+cBjc4vyyP7fIQucvDEp9LaeEuSn5ZFB7xC105aKdLWLMnkLnE9JESOtiyBsf0aiGRGRQeTnGX5F/ViXlLUYk8GiurSMj6hs+xAsJEuwWNThGVe1Ho6dUhzNp94Tqn2zQ6QxYqMWAEReoWSHNg2eonB7tw6m5ju6M2E5iDvPMtMwnlJN99+AQusFYxc712bvELu/fTh+rqgQWVQmUR9s9lL3M/IdMJTD1YDH0JEECyUXhnJTHnU/i1Xm0oDQEvavdb9ks1nT4ZnemuxCIF01A5ZIOkPLkCpwA2CdkE2KIW4ZPskG3bqrk6mfwxGvS61QYpw1R+Gk3wjGlYzZBN/113RyPlgnWdJgF66lEQ3/ErE25ifi1vySsH9Thu1E6aWayxV7erQKVEfRyHErO4XTWBohVFqEKr0cd4TkSQMxwBc4+ihqrTF/07CGc8NMgPfyWJK/ovVx2pRlGxde911kyh01rj2YwO8CdG0wLU4F/B9zo/hS4Lv16GtMwFhzJ896oCUDfoDY2MNYzUNiaQilQm6qVN3x4+SMop4hGpZiuRqP1jDliuPIAJc8OxsuSqUNgAhRaR4f/trWq0DxHgvVr8LbEZm+jj0iIPYxnxsc4D6WQsbZht+YXD+MUBtBAY9u++pbIb3EoK7sclEgSfqbzeUpbGC0wqCwGyzkrKgtVp1sa98qAlaVR1uRJ6GsCwqlZ0/2r7HTzn2oohVyvLFZ0cB5TG6CaYaGoe3YQwPtE0l0CInwHAVj1XDjwYh+tCPlxADREL6ixlVprnoI/ojef8+I6MuF9hADXPrt5cOBcSerYiMdmhYT
 GPmQzXS/
 Qdc6y5trx/pRUHpJLZCYy/L2cQxI5uulnhF3xEwVYKaPFb0P6KwQyandQnf+lf87EMyDiKlyd6H/HQCxD+3f6IvPXgs04u+nv5Uq44HOpeRdEpH//BPHT8ColxwHzkaoUD8smS9sVINZ3+RIyq7RyH2emfsJAFmsaMiueap16jVedc1Y1IvKWPYvG9gAISGBBTt2EhCcGQrB0wR7q/I62U2vFlgCP/LGSCy1ZIiSOY2ii6fvfKMRZzodRen521LX1/wu0Vl/b/7SLq6ZNjSwk8raIKwowW0hB8eNhW5o8YglbmGBsEpCSNay6vrGHkhfE4p6TanCBV2Tiq+UaAM/+KVtnp4BGEcS8bKhHw8wJp9KP4Q4xy6Z8xXtA1AiTdPiGKIuV5G9W7DppS/wVFlwo1qUssaCsEjDU6Rfl3X7SlpuFx0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 at 12:37, 'Vlastimil Babka (SUSE)' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
> On 5/11/26 22:00, Marco Elver wrote:
> > When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> > to identify the allocation site. _RET_IP_, however, evaluates to the
> > caller's parent's instruction pointer rather than the actual allocation
> > site; this would lead to collisions where a function performs multiple
> > allocations.
> >
> > With the generalization to kmalloc_token_t, we now generate the token at
> > the outermost macro, and using _THIS_IP_ would fix this for all cases.
>
> Hm but it means in patch 1 we make things even worse and then fix them
> again, and also improve what was suboptimal prior to the series.
> Would it be instead possible to reorder patches 1 and 2 so we improve the
> current state first, and then introduce typed partitioning without any
> changes to the randomized one? (aside from changing the previously correcly
> used cases _RET_IP_ to _CODE_LOCATION_).

It won't work (it could be made to work if _THIS_IP_ wasn't broken).
The compiler is supposed to maintain semantics of a static variable in
a function, even inline functions, and refer to the same static
variable -- and because kmalloc_type is an inline function, if
_CODE_LOCATION_ is the non-_THIS_IP_ version, it'd break.

Even if _THIS_IP_ wasn't broken, the other complication is introducing
the slab.c vs. outside use of kmalloc_type differentiation.

Both these problems go away if we make this patch 2 (using
_CODE_LOCATION_ on the outer macro, not in an inline function).

While I understand that maybe we could have considered this as a
stable backport, I think it's borderline; the feature isn't broken
per-se, just slightly lower randomness than perhaps intended if size
is a constant expression. A minimal fix prior to the macro rework
currently eludes me.

