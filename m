Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50432C98315
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 22:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E979D6B00D8; Sun, 18 Jan 2026 17:33:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3B656B00D9; Sun, 18 Jan 2026 17:33:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D474B6B00DA; Sun, 18 Jan 2026 17:33:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0E1F6B00D8
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 17:33:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38B74D2124
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:33:24 +0000 (UTC)
X-FDA: 84346537128.11.1B1E7F9
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F6BF80006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:33:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cg2I5tWn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768775602; a=rsa-sha256;
	cv=none;
	b=OmSyh14VFd3OgtoBR8/2J21fcbIGMYH+hkP92me3RLapOqxeNRfFk8MJAPH/5vHuBwbuAH
	yybwbA9sWyr4p8y09SgGWGxxfM4EqcnwM//BfHQ8oJALcgNZ/DeMqRyQZDar7waa60gptA
	OE/UHgyldiRj6Vyjp+nITCWvq3Xadxs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cg2I5tWn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768775602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cx9QpyQrvnFrvxngyHgURZOAcKI8WngXTJ0q+cPiikY=;
	b=VGlK/OTjQGjc8kkm8IxcurodbdVQwWcRiC/JkDFT2iWhNmKvZpcbrNrtEamF1K+cfwK15b
	rJdG/ztXlq6G0vAa1Lm/aB7MqqD4ybq4QQjL3r5pa8ZIRZZHJ0rz7Yxrx0jkUdrk8ODgdz
	KO/OfEn7oITDEPGtUW/Rf1bRbv3KK9c=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4801bc328easo28403405e9.3
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768775601; x=1769380401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cx9QpyQrvnFrvxngyHgURZOAcKI8WngXTJ0q+cPiikY=;
        b=cg2I5tWnusyn+8ThH6sEaraJrkuaYX05pQwHrWjWM0mMz2BB5YjGmeGiKFzijFB/Jc
         nThnggN8Ni9ARxDq2ytqEbBLcRK1aPrmYmI0d/ZsgYs/3Eklkbk0ENpDPpKe6ejqC1ZJ
         YqKs12vx0Akh8MnIcJEOB6SFcgYU2JMCQh1nHJIR5JZH8fevwHRFsHf6k/DiBnznjcVN
         tSauTLXwJOSVWQKaJfjv1o6JLUv9UJ9sNAJF+i1jALJ+FPRfmWFgSLNQURnmF3IQnJgW
         gwVwm9IStZ6TrcZBBaSOyrDsSdILhaI4/CHwGuBBuPv7abYQOVMu9doXwa0VEmizqPGi
         i3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768775601; x=1769380401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cx9QpyQrvnFrvxngyHgURZOAcKI8WngXTJ0q+cPiikY=;
        b=A3nuIeL7MqCOAeDlNyyL728afimCuyjbIA/bfUE0RqGbugRDTaqLGkWW8Yv6zrHRbw
         lmJew8YxDW90j/LPFTAZtLrfZJWeMm03dnlk6XhnsY5gD6YLwDnyjZ/MmQL/Jz//TjjF
         sRToM5hL1iRApSxDAlAoVRl1+OA1JVaqMug5NwVlEYgx3DO2kAyBoAxvRhXVDxW3lIy4
         vmoLfieK0ovFpV4vzg4yvS+MXRnnZn9e2nnNdSxPqllDDZD+E7dPGfVK3Zhke22TjSoh
         zvkVxLA+oQIkE4NOIJ/xsl5z1jnZ+fwNdfyQf+B6OHbTUlpoVCxIKYYtRPiowNX8RvH2
         98Nw==
X-Forwarded-Encrypted: i=1; AJvYcCXbZtPBYjPMw25hQ9cp4+iWJdoff5iWmJ/E9hX1uME2tniNTWjwG9ORStadC4ZNu2MlxGvQE80CTw==@kvack.org
X-Gm-Message-State: AOJu0YzYVtDTDQxzsvFvQ5Oapl7aU6TtH2j6oITJVQ1HsVFNEnr/VU8R
	1efR9AMVirnSVSA41Un5CGb5wqPe4XCyIzXVMqefBsjegwIhVU/Ohq/v
X-Gm-Gg: AY/fxX4cANc+fBppPboWypejqzL7Jd/ujdmC/cVN31Jo752/2DVwyLsqU4lZ4twkags
	gCw2g4IykYH36cZ+vJiT3VfDx1EfSmc4HGYLGIHzlRPtkZ8WPnWYkFNyqFD0nrT6qWqLTeFLWxs
	6RAIlJMHFTVoRWgFbwKGj7LuSzCBhFgSwIjGhEqSNpfmVqAbyX72My13t6oHE3veFlyAqqCVv19
	Wvs+VLER7RNFDLpC9LBbXNMxXB1fm5HsTJXDlqU8qgIxF2uDwByiLQypEx0ZlZfdoL5zqGM/Vte
	rYvSg5TtJ61SBQl2FFQroUS0AKgN0GA1WNz0/tuPmLrXbIILGcknknoOzrhIxPp7nHVKmnVspuN
	Y8Vsqbo0iqpC4kn15Cmm5pwhJGZBhOEB9B7uWynUFyqbbCHJeZPOAAy6hUyccUgSPFvTEwHa4IN
	2n7oTN+nsHgseijUe+eYy0JqTMKP6JG5aGJ8vLM4PcFIUcOUKmrBWaUvTTjq7n5RU=
X-Received: by 2002:a05:600c:474a:b0:477:9b4a:a82 with SMTP id 5b1f17b1804b1-4801eb14b36mr116131045e9.35.1768775600441;
        Sun, 18 Jan 2026 14:33:20 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4b2672d6sm218823515e9.14.2026.01.18.14.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 14:33:20 -0800 (PST)
Date: Sun, 18 Jan 2026 22:33:18 +0000
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Eric Dumazet <edumazet@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev, Linux Memory
 Management List <linux-mm@kvack.org>, linux-kernel
 <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, Jakub Kicinski
 <kuba@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, Nicolas Pitre <npitre@baylibre.com>
Subject: Re: [PATCH] compiler_types: Introduce inline_for_performance
Message-ID: <20260118223318.7a3e3837@pumpkin>
In-Reply-To: <202601190247.dDAvbbMH-lkp@intel.com>
References: <20260118152448.2560414-1-edumazet@google.com>
	<202601190247.dDAvbbMH-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F6BF80006
X-Stat-Signature: ees79x5whya1r1f7ahcjg4iyki9jxj55
X-Rspam-User: 
X-HE-Tag: 1768775602-101765
X-HE-Meta: U2FsdGVkX18ztGNVuWFPYt7LcWt0DyBtlKgGDo/t4DD8dNA/gZrPSaBFrY5PoZjvmd0i9Y9g1kZC9lp8HY17aQy0KBsLyR+A4KzjJg3FHAUrEh7piEVYWGdJ6C6dBaE/yx+GilEy94HMdTwa+InlNgxExmRw9+r4hi3jfjxabJn8uSJBwQzbmDro7e8igc0ENuB21s16iRBfgi6f8imR9hE/F8MQNdqEweUAXMdtbltd5ijmZ2BiyR4blVAaguY410HkmGW3Ee8+r7a5AVT7fzlOu2vGJCRHSNNA6keBbszUipWszui6zWQvrUFHXxsTNXW+QesWpVBzPc9eNTgVdDZpP+/kTg/ot/wtuH74KD7+cGUPoNbzGXkZ4JIB1RHvbxLpdakNDbGyCym1eTogPL2ifuv/P1d4byke1BjlR2BwCKd3VFIwJIb0scxyGBcMFTaSOyuS1AH9jVq2jK35P4isiXVoA5dQS4eOCSzmojO62KUZbCsPWyIgth8iGVv5eR9iZKsVTigNsVDn7TjsEkCwH9/cvq+Wy8uRWOFHA+wiv4jRpRf1TdAXYD8niWL/HbZ1313G2O+AbrfatsLyoRaVUOL1mlWFpFiNGjwMAiudjfe2zhfbMljBThTHf8PrDBLFHF5aF1mjVHLZdNr/UtsSfeMeUPmd3WDKY78vIgjyWDO6SD5oZE1u90CfohZFITODp0g/tvM2a/cDJgvBc4vVv46GFiTTUm4zICeY/Bm8TXgOSfLSzYBtdxKibgjDu1Un7nm9TQ8eKOdx+evneubSGttF3gmaeU2zd9uH4/5r7MUB9AX88Bzyl0oLiRE0UyaATf/xabl7fm8RPGX5twt2aJNjn8l0eTVx97HLVfBPtTxa2h2KEQjSdjU5g4h4GGcbyGLMk3ko2SyBYY1HkM1VKyxR/QvJ8G2hCGgmutf+hYP6gLEh9FrC5uLAjr/TUm6IaROMKZlBBloQtZD
 VLr6SetM
 QMj9gH0GphKo/meTNMAsLrDkkO3fvkyvU5Mt4iBMPfni13iJ1TqGyk+yyUhay0sscIbyegwfgVJliyly+Gvxpl5ifmcZ0By/qovsSNzH7JfsfFxZ7PHJwexNdKZitrWeXn/fIM05aEF9j4HoaMaTPsP4HasJc4bAUjke3xtEP56Tm9Q5XDs27YFwSNTuyZNIZ0duvfKIjm/mONcD+hb9ZiRp2sHTGItau1XNgu7DkOxMz8l7neFjVU+DSOmnK6Edg6KpBQgBC/UArkllaELAFSMG79G4WTBfrKoR3UrDnKE98eLQSMqzquuuHws3BiTrzxI8Tb6rIDWXeqOEkkZpbqWCPBO7e9LsDflShzQe5HifeVS9AMYmUL89s3muvmFrI6vkd7h6jSsRBNz4qImx7/psKE854Ai8k1K71HaRHcfy1D3uSymPdqE8IPeRe/tREWbp6/QmTlJyla+Ivj1wf9++P+hST9+ibqyPUlohseX6dKp0R/gYNd0HHd/74aOvOle9WZxp9Kfp+oyCLC/eVYSylxko3FiFnBAgtH1BDnJc43qINBOS3O8ThC99NgJ/PIPBmPtKkvp0IBZXb3IVoo+iIGCcfb2DE42zB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 19 Jan 2026 02:36:18 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi Eric,
...
> vim +/__arch_xprod_64 +138 include/asm-generic/div64.h
> 
> 461a5e51060c93 Nicolas Pitre 2015-10-30  125  
> f682b27c57aec2 Nicolas Pitre 2015-10-30  126  #ifndef __arch_xprod_64
> f682b27c57aec2 Nicolas Pitre 2015-10-30  127  /*
> f682b27c57aec2 Nicolas Pitre 2015-10-30  128   * Default C implementation for __arch_xprod_64()
> f682b27c57aec2 Nicolas Pitre 2015-10-30  129   *
> f682b27c57aec2 Nicolas Pitre 2015-10-30  130   * Prototype: uint64_t __arch_xprod_64(const uint64_t m, uint64_t n, bool bias)
> f682b27c57aec2 Nicolas Pitre 2015-10-30  131   * Semantic:  retval = ((bias ? m : 0) + m * n) >> 64
> f682b27c57aec2 Nicolas Pitre 2015-10-30  132   *
> f682b27c57aec2 Nicolas Pitre 2015-10-30  133   * The product is a 128-bit value, scaled down to 64 bits.
> 00a31dd3acea0f Nicolas Pitre 2024-10-03  134   * Hoping for compile-time optimization of  conditional code.
> f682b27c57aec2 Nicolas Pitre 2015-10-30  135   * Architectures may provide their own optimized assembly implementation.
> f682b27c57aec2 Nicolas Pitre 2015-10-30  136   */
> 5f712d70e20a46 Eric Dumazet  2026-01-18  137  static inline_for_performance
> d533cb2d2af400 Nicolas Pitre 2024-10-03 @138  uint64_t __arch_xprod_64(const uint64_t m, uint64_t n, bool bias)
> f682b27c57aec2 Nicolas Pitre 2015-10-30  139  {
> f682b27c57aec2 Nicolas Pitre 2015-10-30  140  	uint32_t m_lo = m;
> f682b27c57aec2 Nicolas Pitre 2015-10-30  141  	uint32_t m_hi = m >> 32;
> f682b27c57aec2 Nicolas Pitre 2015-10-30  142  	uint32_t n_lo = n;
> f682b27c57aec2 Nicolas Pitre 2015-10-30  143  	uint32_t n_hi = n >> 32;
> 00a31dd3acea0f Nicolas Pitre 2024-10-03  144  	uint64_t x, y;
> f682b27c57aec2 Nicolas Pitre 2015-10-30  145  
> 00a31dd3acea0f Nicolas Pitre 2024-10-03  146  	/* Determine if overflow handling can be dispensed with. */
> 00a31dd3acea0f Nicolas Pitre 2024-10-03  147  	bool no_ovf = __builtin_constant_p(m) &&
> 00a31dd3acea0f Nicolas Pitre 2024-10-03  148  		      ((m >> 32) + (m & 0xffffffff) < 0x100000000);

Can that ever have got compiled?
Won't the compiler complain about 0x100000000 being out of range?
Lots of alternatives...

If u128 exists this should probably just be:
	return ((u128)m * n + (bias ? m : 0)) >> 64;

Which is probably the only alternative an architecture might provide (none do AFAICT).

	David

