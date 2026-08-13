Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 676BDC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0FF6B02C8; Thu, 13 Aug 2026 15:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478876B02CC; Thu, 13 Aug 2026 15:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369876B02CD; Thu, 13 Aug 2026 15:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EB7E6B02C8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:37:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93BE8402BC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:37:24 +0000 (UTC)
X-FDA: 85097255208.21.6B26F47
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB271A0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:37:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nVeZwwdl;
	spf=pass (imf25.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786649842;
	b=rfIlTB41dQyczqE0B40eCu9rhfvahV/HsNqTx07SWjNhTYwVX6nLEtjrAxFCMDEzCSmPl1
	QIzl390EzdPy/e1pPhZNnpQAO2EZo5uPhPyhX/FKRzoNYCk0GPW3103zaGcaYfgUkC9s9s
	hNOXXK60Dy3s5GZ5o7dOr9t76Ne1y7g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nVeZwwdl;
	spf=pass (imf25.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786649842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7h40fDSJ6LxR0LhSx+FP2dYCuXb3wJxS0vazqn2AKzg=;
	b=oe81n1zNMou8Rjq1WjnNh6oHme7DUQ6TR5iYCMAakD9oq6wu3y8UseQcdptIwQ+JJ88X+b
	T0+oMulPJ2P8ENW8mz0tUTlIvvY60dcq4JA6GDLxj3CEq0Y6d/7p8khpkBiA8VVOhTO9Uj
	fABnFYXbmCjrUFd69zmfvc2k4P0Oijs=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ccdf36f63dso34015ad.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786649841; x=1787254641; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7h40fDSJ6LxR0LhSx+FP2dYCuXb3wJxS0vazqn2AKzg=;
        b=nVeZwwdljWZm7rRPpvT7nn7+Gdc+CNqyGh4sw5wpJym/nmeX4AxHmJUVC8vz11DfKr
         ZomWxxmbxif/enPd7izSynl4tRDRQe0ioGPnQeTUDbvnF+sCPHWJyChAGvnNvKTNHMGS
         zK2G1IwAFtO+IJG9xf20M0dCky3zVi6ijqh945FzL65h/e0OTzUOnriaUpgd3nAUbpR9
         qz6xVrX+JZNfYv/urY3uj2OwJzSgUXGBBjUaQzK0fHLsJmFtOOEC/ud1VWYKVHCh473g
         ESCHp85j+d8/nDcNSw+xB3GLZjkhnagCSD9FFOEsMWEdLolVt4F5Rh/jcqTKTqYO5FgJ
         NqvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786649841; x=1787254641;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7h40fDSJ6LxR0LhSx+FP2dYCuXb3wJxS0vazqn2AKzg=;
        b=MUKvJX+XZrj4PWelEP2MJelCSxixoaAd5qEOWfTjFysNdMDLSV26oCzSbtDbelWA+O
         xrHXArauAOM3/sHWmBeZiCzDGkzwYuFF/fNFlO0T8dIOrf//QfbywiYCQLI/cXkWmcHb
         +CRHak1g/tCw//+AvZ9KeC1YuWtmGhs+WiXzrCGqeOn54yyXEVGz257fPhyzCObSmrMx
         oTLhzQz1JHG4/CGhaiTQC2eLyQ1jz3XNofHbI1nsRR4jBXUK22a8snForVv7KcyOrNmg
         f73eGppEdhruyTkE+OKPtrvRwj5lkUnTUJkl5G6W6zdEEaFFL43Eq0cgLmgYKkFttsLG
         8WOQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr7sng95MmPMmVcZxcgReRci5jEgaXtcaBiOJIjfl9ROyeRT7wlaiVOH1BEdAwO+9RYmqLWeGkdZw==@kvack.org
X-Gm-Message-State: AOJu0YwIJYs2DYr64JA0SFmKk9rWZFErN9YXElqTAGy5q4tdrrsowSFD
	2TR6vb54/38jHFqZKPjZIAHrNzIzG+5BoafxS5g82iqJu/MORyBcFI1uKlfYatK50g==
X-Gm-Gg: AR+sD12sUty+2OtBKtArN15x+tRQZvdVi1rVEyD0TkwQCVvzV3pTbX52WgLEKCEtb7k
	nJr8LWl6QKPdfpAXC76eFPTLctPDvOBuG2mRdggBE21LzzdBlVEd4J40xqu4ezR/28wK6YYXeAr
	/uUgoSJs7lMcNM6kg5dMGG7+4261l/77ScMPTHWV+TgFiLUwohWT6D6o89EGDGbIrpi1Q0G9Cil
	96J+/10AHg0/JoMqfib5gCgHrTGZ7il9cJE4r8vN3FCPBnZD82cDcvjhGMsZ39fEhUhIuRoQrjt
	raAlEY+PT7Q5XnH0nvigxnjrPkM5O9jonA7ot9NvOr9Q8Q1zLfmjc0QUquIQfh2vnz+hwj4v8lH
	2+IOzNUohviy41Mos/B+1GV5pzvZBKHHAfxX5gyxNcONQ0Cj1O38v8WCuXiQuvVHyaPcP42/QK5
	TPpOTWNhot0Vw3mqrIaidwWfYqUsxUuNA3aITfFBBBzqGlJIvP+X3hJzGf3D45xDT1mgvn9P7g8
	PkP+XCN8CIqA2n+F0jA6Zc8z5xhfUi/diO4ffjVJdsgbrni2iwVACJDEMpjxRwMWoahVB9XvXpE
	0mKIKxj2
X-Received: by 2002:a17:903:3c44:b0:2c9:b404:b55 with SMTP id d9443c01a7336-2d3af24f3a9mr2081355ad.6.1786649840834;
        Thu, 13 Aug 2026 12:37:20 -0700 (PDT)
Received: from google.com (193.67.125.34.bc.googleusercontent.com. [34.125.67.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3933b649975sm80193a91.2.2026.08.13.12.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 12:37:20 -0700 (PDT)
Date: Thu, 13 Aug 2026 19:37:15 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com,
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	jannh@google.com, aliceryhl@google.com, arve@android.com,
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v6 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <an4c64xukV16uN_U@google.com>
References: <20260813193433.3318288-1-surenb@google.com>
 <20260813193433.3318288-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260813193433.3318288-3-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB271A0006
X-Stat-Signature: syjc51qkpbqgssypytfy38miksz3mw9w
X-HE-Tag: 1786649842-356067
X-HE-Meta: U2FsdGVkX18v25znOundn1xpOUpcRTaUmaEk4ktsfZ7DSSFLhdIFuLHm4TsicnfcP3321jDsNNNk6qfimbWLIJbyMG4g6crARZREvENIx1nuQpRM7klWLZzkUs0VvCh69zC52/qmi2SnaSgXJPMGkELXt0RdQbJCRIR9AYlFKZC5Gvy9RmyVCSZ5l0Boja8i9ma55lhc1FJCZwK82CVSRJ6EOxnQi3DBXXwvjaygQs4beAO0M+SQknIBtu0jz4Mx66lNe/tYnO5DgLvA+e1fJPLtygMo0rTS+oB6lGFADWkkT6NEqG+V0ICR6Dw79D5jz4IjvA7YJpGu+ROMYf2sLu1Qs76aM2pAKNoROzgL/e4GyrvFRh1TzpT/hO4V7JOvmM5D6HSvZgiq10GXLADx9sQkYG/Y202MOcirdOxX59mwwjUDKnzvnv90vGqEuAQ20XV962AgyJ6mmvyjd0hNOuSHwvhV/GHthv0KclPfQdpqCuq06WstysoiUVUSTgfjrat63Ozyi4yinxk33Aw2bv4UU1cBSC3anil/cs7XYilXns5pw06QW9GAKSIEN1+CoetffLIm1hQ1eSzBF4VPBr4/2YYmf6Qb/aS4OYxbJgSGMPxJ6jb2txzcICdVN6fi2SYCVWJQPFk2dThyES3e2OCmnysLjF7PCH5N9Yg3/C2hMaDqP41zjKLdSGuZtuyjE+hE/hbWLEOEm67XNx66Ky6pAKXTMeEA+nw53Rq87IVG/B0RZfFerfZVOMGMw9T+juCL2MmJRMMYoxlclpRM44cdaWs6CCv1ZqE4X4r9c+VXmdNcU43IYKxTFlIxCwbJcRDlweqA/I9lT2ot6xA7HCqSQYuP0EE/CjVMuil7MyAKZOdLFsyXeXzvCJJsc7mZ+TVqg6bhtFVT5hEWsj344VyLiJ7cXP/EZiXusVsu52HQPwhCcZzxAIcKwLbgtUeZMYELFgIar/qaRIYHDYe
 6WujOC5O
 27HwIzESUyiMWjtJOmWt3VzMwM87X9f2i14MfLiDsoFyKUlKIHx14HfX2EXp4rgd+BEUr//JLVQR8dzE5Zmz3xKjXOmtv0ueZXNoc4pADcSMvaB/vhouZmOPLM86pycepaH4iQIuw3l75IQ5densne6IAXGVwIPlxX/Zk4rsoP+GnkJdjuZvfvVyJME/Rdd+hOHiapD9ySlVDhQ5Tsi24T+gW+riWqOdl/EbyzgifE5VHHpaQ7+g/kvntWBVsOKrHY7iCm2kK1HpqP9176b0JZjNiEYuni0KldN/Z/3GIXuFNshYxdepXtk6MiCzJG5otf8xRSAfXD8l4Pw8269cknQ6W/l8GUsjj49BD2Ej86HWoNr2S38RcTrvEk3HK/B43DYnFYoLthMBlbQ7T+Ec1X+Nq0R9557A1idoDQs1s75YQ5qfipdo5uqPmsxwsOlmyZ5gjb0xtZaY07kxzoF+hSIMGttJX1MfSpgvI7G3ArrtkFVHwvp/izw3RqzgeLmLyPcpRebcOtnvqu6DZOF2JWN8BwAaV/UBOZaLXTBc4QoRJ0BHmN1eVde9nbJu+/H09EWNGD7NsxYKf8iIIK6PRi18KlHi2LifWFgJv60IBMCYYdFVd9+aarH/pOuJEB8KHvvNyT0i53emq7BPQonxV2pWBzqsj7/AYgcJkbCwJKPEbKcScbQViY5uXtIJkewjLl4YijwoAbvNLDabmZEGkYokAICAbo9h/fA7fmJPM1b3S+hEchuwZZnRE+cSKzsUFNZHtxJoWPzYaDW8KcPiQVyVZLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 12:34:30PM -0700, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> it and mmap_read_trylock().
> 
> Long Version:
> 
> == Background ==
> 
> Historically, binder used an mmap_read_trylock() in its shrinker code.
> This ensures that reclaim is not blocked on an mmap_lock. Commit
> 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> support for the per-VMA lock, but left mmap_read_trylock() as a
> fallback.
> 
> This was presumably because the per-VMA locking can fail for several
> reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> to mmap_read_trylock().
> 
> == Problem ==
> 
> The fallback is not worth the complexity here. lock_vma_under_rcu() is
> essentially already a non-blocking trylock. The main reason it fails
> is also the reason mmap_read_trylock() fails: something is holding
> mmap_write_lock().
> 
> The only remedy for a collision with mmap_write_lock() is to wait,
> which this code can not do. So the "fallback" after
> lock_vma_under_rcu() failure is not really a fallback: it is really
> likely to just be retrying in vain. That retry in an of itself isn't
> horrible. But it adds complexity.
> 
> == Solution ==
> 
> Now that per-VMA locks are universally available, lock_vma_under_rcu()
> will not persistently fail. Rely on it alone and simplify the code.
> The removal of the fallback does not affect NOMMU case because binder
> driver depends on CONFIG_MMU.
> 
> While at it we also make the handling of the cases where the original
> binder VMA is gone consistent. There are two cases to consider when
> Binder VMA is gone:
> 1. there is no VMA at that location anymore.
> 2. there is now another unrelated VMA at that location.
> 
> Before this change we handle case 1 by having the shrinker proceed to
> free the page, and just skip the zap_vma_range() call. And we handle
> case 2 by having the shrinker return LRU_SKIP. While either behavior
> is acceptable, we need to handle them in a consistent way. Handle both
> cases by freeing the page without touching the VMA (skipping the
> zap_vma_range()).
> 
> Full disclosure: I originally tried to do this with
> lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> trylock semantics. Claude caught this in a review and suggested the
> approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> I guess.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---

Thanks,
Acked-by: Carlos Llamas <cmllamas@google.com>

