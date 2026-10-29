Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A9F606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HdltiDRn
Received: by kanga.kvack.org (Postfix)
	id A5A006B05B7; Wed, 28 Oct 2026 21:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A6C6B05B8; Wed, 28 Oct 2026 21:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920C86B05B9; Wed, 28 Oct 2026 21:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D90F6B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:49:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1D561201C4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:49:26 +0000 (UTC)
X-FDA: 85373981532.29.8B34B12
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id F35B7100006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:49:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HdltiDRn;
	spf=pass (imf14.hostedemail.com: domain of 3I6biagYKCFgAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3I6biagYKCFgAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793238565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOkILSEQ28uD8BSJvTlIwGhNwyqSpmKjEG8uIJhVgiU=;
	b=exQ1Y9wLFWgNZVBDe4NBV75BPHkIgHMbZ1XFSJ6DUc+pSNInoJAjM9Y8YSjlp3TJ/2CVJB
	Cfyl2j0V83pmXp68pHCsm1ZJ9cPqUiToQdgaoDjmwa8ONHuOn3rg5Cn1d4uS+6Ax3vI1Dh
	fPMWo60IlcaUZYp/x6lvTaQf7lkT4GQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793238565;
	b=lOzr/RRWz9Yo+hkn8z4b3/Ek5EyxKgDxG48lzR4DJ2wK/exKLaAaS8gqc8lQwOw8Wf/5QS
	wd15T/tp+7/XO0aCpk+ubfHd8VICllqOm7FertV9INEFunF00lOLH3bDIXWstiH3qMoQW7
	GopZlnGI5K3+qaXM3SeuWr6piuN34Lo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HdltiDRn;
	spf=pass (imf14.hostedemail.com: domain of 3I6biagYKCFgAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3I6biagYKCFgAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad91787a1aso1166243a91.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793238564; x=1793843364; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hOkILSEQ28uD8BSJvTlIwGhNwyqSpmKjEG8uIJhVgiU=;
        b=HdltiDRnQDMM70LWMSpowKTRbjAHqREYkSTfq2z3EsXuUy8X9pZ/GhKqbJmtdqC4SK
         Tt7PvOT/5ERCBFtkJjo1J5krnb56idBHegwt9XDm8v0Zcfs20HmFuIgMqvRX3HbYquSE
         UkxDR18axKkac0pil8P+MUmRSJJ5z3NHn6gz91Kn8vjybIWYFRsU7gfxtk3rMRSYY0zu
         iSKO6kSx54q5wpzFqTxgmybDtvY63xICtgt8nh3pKX9tUh7wiA2C68CnEds71wRAVFPK
         VQKmct7MOo8/Q8abgnZO3Fsz0ypqTKgX2twOw8ff+nsgveqkZvaOqdPJzmrHcRrZ17jr
         HY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793238564; x=1793843364;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hOkILSEQ28uD8BSJvTlIwGhNwyqSpmKjEG8uIJhVgiU=;
        b=2zye0m8TDPTnZ+N3uPvJ3NBPTnWjpUCkEwU1dqOULyg4qBBeE3T/u6Z6Vi9XrpMEcG
         72yiulv66bhmjOVGO0rrrF9U1j03hxUSx809LfTl9ZuqQvSUGqqbe9ZANJFHkX05nhpO
         231y01GQmgq7wHIWQ1Xd8/Q5+WB/G+tNaQXsd//NXJKxLxCbw5E+1k75W/yTQ6Bk2qmE
         F4PaBWAr8j4ynuZfcHT9SrxHzx3EehcAmx2Gvt5dDPKlHRptCeFIJzXlMDa1Jfvieb9C
         Tc1Bl+iTG33t46sH+q82JNvNZQdULkEm2sehWsm+ehgZX0etIljf7s8AZBDRCtPh/kgL
         kFZw==
X-Forwarded-Encrypted: i=1; AKwUvBxshCdNlPr2a7b8h1tnyZxNkccIqLuknu+4kIMOqWQvfE7mG6QgwHRMXGAnnyfiLwiX7b3Tl4ArAw==@kvack.org
X-Gm-Message-State: AFq9FYL5Rhh3qV/L3DHgEB6r6iUlvdKCJwKxo1TeIe7PchkuiE9qoqTh
	WBfI/vsQojbTavRfNf1pn6LKtjLGVrrcpP3etYd6v3p4kJfGlkWfc97MaEoiSJ1QwuCrNhFGonu
	A9blEmw==
X-Received: from pjbcm5.prod.google.com ([2002:a17:90a:fa05:b0:3ad:ce88:b6b5])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57e3:b0:3ab:413:49bc
 with SMTP id 98e67ed59e1d1-3ae58123796mr2862133a91.37.1793238563618; Wed, 28
 Oct 2026 18:49:23 -0700 (PDT)
Date: Thu, 29 Oct 2026 01:49:23 +0000
In-Reply-To: <auKZIA-0j9WT_gFU@linux.dev>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com> <20261028185034.3607746-4-kuniyu@google.com>
 <auKZIA-0j9WT_gFU@linux.dev>
Message-ID: <auKlAaXEbw23OcOO@google.com>
Subject: Re: [PATCH v2 3/6] memcg: Annotate slow paths in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F35B7100006
X-Stat-Signature: wthb45n91pknz1ef9zj3fjkh95hg4f5a
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793238564-439817
X-HE-Meta: U2FsdGVkX18+zTSkUYawECoaFZTY+FNnvgyi14gEYUnzAj2MWVYVhRTaSmIkzAekCqJjOibPNa6PG/2dNsITNqI2VLRwVVl6dksKTTRLDXnuQLAnUlSh4iks6u/ydtzaG9q2qz+wgs1mf/9UfMmJRg5eM0Sb605QIAUEPE2NtXAyEwUZi7Ntgx8qiKzsNW1beH29cREHrxu09m1toh0AFiOOJSk/Wd31FkqjGBZrKKEmsgi10xpL1aQ6jmWzzmskMhtrHnTmNqUjhbqlRTWzpYzdR8B5LAxge/eVOrzpDHm+GVvfhyJQ62Gu3Qum03H473tkdlyQVpWnVIF+IrIvjIup1D36W2/XZZWWEWzf/kwBhg3llFv6jB1pBZUOYjk4CVoSj7+zFEpgkQYRjOd/V2WFLxSKmPr0aPFKi33iw5395zS87QKoNo6lSN8eyz04BxGiRjs4wDyal9AX2b/mNDkyLZtAw+ea1eIGL2Zh0dHvoOsOS4hHr8BeEltXZwp3HQjpEXEOJJ83QejTdOBSaJKqwFUzJrVCQ6HD0/RC4ABCW2sNp8v2X0CrVJSv8/WO7V1nSr7RZg450cr8bEJIs+AZrK4v03HN+ouypsMRtVcRQar4GB1TzEW0Otpi/W8Qz7bj7Ux1Xo3AOZDmInYw4fjVfUAmmJEuWncn4YylvtMaGlU/GjTqKRCIsaLl3bZ+dUts1SQ+GX6HX/K3SUjfW/2Rhiifk5ZRBo17Aevag1u4d5SGNdbE3cYNz1xYFgrf+vyMkWeiDhJii10dpTt8nfv7foreg2+nK6G9nVRuIMpngMDUBFKAy/98sCoL65oOIXF/mxiwxW+GyjIPionNutNmHn2JobGursgN2qSbhEZu9XAxmRJ1kksLZvJ55Ezu3zKRASqdd61e+5TacNO5BPrALrXzNFsS51d/ZIkudhfSpT00OMhhXIfqBOOP9Ihm3iXN776BGoYjdUZCZQV
 XohufEjD
 jKlJxLkSess3CRSK0+yhFmCYg/rj9PZDzbOCKUm1nWvYjKJSLpLeAYreh/9qvPQVjFmqMoA/wSdIx+nrp8lXefZDX+cNUQ/hIChTuyd9O6Klytsa+bOD2RzdcsbN1A3FCHLKjMiibeLVLg3PIyXutU1uf2RKUqHLe0sR1YRmLUPnsfhUp06KFkJroE7gTnIV2KocnD96WinuqrQ1PkeS3HYoSMaN4MC8ulG6/9UkYk3l0h+6ltnrXeSXejrLGKqdVDDAiSCt5pLEKNI1PSnHmwK9QnbTQrypbGP1FPaOw9febrm7q/HZtSyARRo9NU7/fHyK4UP8yw2sX7+3Cdeu3qqm/MAofVkUQ/rYHEiEGgsOD9AH9EONb7rxTqzRyZcOQASMxMnwmfmCFwjz8L4tfmY82D0sVX9EFX9fQjzFKfrftWn2aqxRqV3U60g+Hxuer8OQ12rzPfyQNN+wOdICMtMaVmCc1s0CckuEIfaHxXCItG2rj8Ysa5DcxXp0w2UFHYdehIBwu+Uji8Dt/1E3lQ5tVK4oUGNHHxNuvBE1ertG5fgQvhwjjl2rFUjme+NavtTOXWAlz8+AT96x5mHraoQmHEBxofjC/UACl/3nxygM13w2TnlMBfP5+ik+CrIVXX2VmBxSlUucC2+TlHAQF83xEFVvC6/4l4j/MMCGDBlXxtABtWYGMNt2FgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 17:55:31 -0700, Shakeel Butt wrote:
> On Wed, Oct 28, 2026 at 06:50:15PM +0000, Kuniyuki Iwashima wrote:
> > In consume_stock() and refill_stock(), each per-CPU stock slot
> > holds up to MEMCG_STOCK_HIGH (64) pages, so depleting a slot in
> > consume_stock() (!stock_pages) or trimming a slot in refill_stock()
> > (stock_pages > MEMCG_STOCK_HIGH) happens at most once per batch.
> > 
> > Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
> > failure, and insufficient cached pages (stock_pages < nr_pages)
> > are all slow paths.
> > 
> > Without unlikely() annotations (when building without FDO, or
> > when an FDO profile does not cover a caller), the compiler treats
> > these branches as likely and inlines css_put() in consume_stock()
> > and memcg_uncharge() in refill_stock() right into the middle of
> > the hot path.
> 
> Please state the compiler along with its version here. I didn't see this behavior
> on gcc 14.

Sure, actually I included asm in v1 but thought no one is
interested in it and this might make my patch look AI-sloppy,
but I'm happy that it wasn't the case :)

https://lore.kernel.org/linux-mm/20261016052811.3085635-4-kuniyu@google.com/

This was generated w/ Clang 23, but I was able to see the
same result w/ Clang 21 too.  I'll include them in v3 again.

Before (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   7ab2: 43 0f b6 44 26 01       movzbl  0x1(%r14,%r12), %eax
   7ab8: 01 c6                   addl    %eax, %esi
  if (stock_pages > MEMCG_STOCK_HIGH) {
   7aba: 83 fe 41                cmpl    $0x41, %esi
   7abd: 72 1d                   jb      0x7adc <refill_stock+0x21c>
  memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);   # inlined
   7abf: 41 89 f7                movl    %esi, %r15d
   7ac2: 41 83 c7 e0             addl    $-0x20, %r15d
   7ac6: 48 8d bb 00 01 00 00    leaq    0x100(%rbx), %rdi
   7acd: 4c 89 fe                movq    %r15, %rsi
   7ad0: e8 00 00 00 00          callq   <page_counter_uncharge>
   7ad5: be 20 00 00 00          movl    $0x20, %esi
   7ada: eb 41                   jmp     0x7b1d <refill_stock+0x25d>
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   7adc: 43 88 74 26 01          movb    %sil, 0x1(%r14,%r12)
  local_unlock(&memcg_stock.lock);
   7ae1: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   7ae9: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
   7af0: e9 03 fe ff ff          jmp     0x78f8 <refill_stock+0x38>

After (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   7b76: 42 0f b6 44 33 01       movzbl  0x1(%rbx,%r14), %eax
   7b7c: 01 c6                   addl    %eax, %esi
  if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
   7b7e: 83 fe 41                cmpl    $0x41, %esi
   7b81: 73 20                   jae     0x7ba3 <refill_stock+0x233>
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   7b83: 42 88 74 33 01          movb    %sil, 0x1(%rbx,%r14)
  local_unlock(&memcg_stock.lock);
   7b88: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   7b90: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
  }
   7b97: 5b                      popq    %rbx
   7b98: 41 5e                   popq    %r14
   7b9a: 41 5f                   popq    %r15
   7b9c: 5d                      popq    %rbp
   7b9d: 2e e9 00 00 00 00       jmp     <__x86_return_thunk>
  memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);
   7ba3: 83 c6 e0                addl    $-0x20, %esi
   7ba6: e8 15 f2 ff ff          callq   0x6dc0 <memcg_uncharge>
   7bab: be 20 00 00 00          movl    $0x20, %esi
   7bb0: eb d1                   jmp     0x7b83 <refill_stock+0x213>

