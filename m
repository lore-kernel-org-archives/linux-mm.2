Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBF6C4451C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 08:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FA26B008A; Wed, 22 Jul 2026 04:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1AC6B008C; Wed, 22 Jul 2026 04:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0496B0092; Wed, 22 Jul 2026 04:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D18D16B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:56:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A48B140380
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:56:09 +0000 (UTC)
X-FDA: 85015805658.28.BC8F1F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 931EC140009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:56:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LDc46chI;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784710567;
	b=aws+ecnE2CaspESVWa2vu7IKBNvNoW+iPKGBONTf2UfI3oErAFRTUSvwroizihhXw5WniQ
	0i+q3325kqSr5LxzYoZOAE9y/q1zA5nN/Yy7jDoJXBDFIGWd+pE0ZEY+TlYwCp2zOyzPgg
	+GasAasK37pIGVU7puIUPCCC94OIJaU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LDc46chI;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784710567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aee5s1edqbgsHAo4tjJhHBYFBXZbzIQhAfflgu0Qfl0=;
	b=qIQ6MehMJKFOXv+G1wfGQgLacc7xocUKQBJ38JLDwHwEkMHVMPBX8lGJc1q6DmC7CUJ6rN
	uquM5tt2NBkllqgBcr468A4sFjCD5NN8FESfHZGgUhv6KZjoo1Z8Sd5wE62iRQu4Lysd7a
	GYTBUQFPiHFhlyZHo0qtyGWcqL81sg4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 098AB60A6B;
	Wed, 22 Jul 2026 08:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7D71F000E9;
	Wed, 22 Jul 2026 08:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784710566;
	bh=aee5s1edqbgsHAo4tjJhHBYFBXZbzIQhAfflgu0Qfl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LDc46chI52fVENs42kG9+KBWM0nMhxZUJWhF2TcA//k7EVRXGYtJIEDCNw2MhaQxf
	 rAF7wicCMnhKVgjkDR5Va+tqdiK93/9KRL0amUDK1fkF/CYvi+4b0yXY0txmWTHBzm
	 FN3BEIyh2bx7nj0aCMQm2RenxGNCsPp3x2xisyF711bY3BDHZJZ9cBgDQ/wkNXvhIf
	 qeOmqal8BqfD6umsvhZ23KsidOUZWvPxo4euKNMG6AxVL0LbwZcNyrf3FjZpQ5BNd/
	 UqsVNpLJjq1PTHsuaT0kzYYLLQVD1E7gJWUegOsyo5+fFSYuWRWanDXNRVLIlnutd/
	 QQ65f9GU69gTg==
Date: Wed, 22 Jul 2026 09:55:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Albert Ou <aou@eecs.berkeley.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
	Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
	x86@kernel.org, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH RFC 01/18] x86/mm/pat: Don't gate cpa_lock on
 debug_pagealloc_enabled()
Message-ID: <amCFgFTmP1Jy_uRG@lucifer>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
 <20260721-generic-set-memory-v0-1-v1-1-2c1fc62306b3@kernel.org>
 <al-oTOKY7vkdPHr5@lucifer>
 <al-6woCPBH5d-lwP@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al-6woCPBH5d-lwP@kernel.org>
X-Stat-Signature: 7m3asxq4tc5yufbooojj79ho38pmkayc
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 931EC140009
X-Rspam-User: 
X-HE-Tag: 1784710567-564165
X-HE-Meta: U2FsdGVkX1/ja18vNsr1pYCi5VoLH/0x4RJlNFYZgxHgo9OTJXNK7Rb1qzJ4aun4aUD9z0qfcEDRMQnXK2KcRKG3xiChU64yUczx5J8RZJaJPopzcijul4y9wf+doRfWfnHb7EL929qhlLDVMPOMSFnz4m1nTbrkRCSXLKdzedcbYc8cN0jtFr3zVBPU42g5KmUrvQY+bkelT6j7mfzI/tkipVNxo1XIlAj03I4khdt6B6Dmc3UcQtAaDR8777cSxkNPDf1AC6PnW2U4pbxUaF8PLWhsItnPKXmYkvLRf2jsiIbws6cVJ2nHuFOxF9NLYT88GX+XICauJimSbv99T4+Hll5zlxq6prCVt1YuvIR865J0IlX0Aq7reWRGsDsIjtQwm67Uib7gyLNGThr+5145chzeK3Sc/8tc7veM6TLAeuFiSySOIG4NW1IzypSl0aTJy7cHcpAPbxb5Iike3uPr4In3Zdql3W7KKLhWA7iWcORm8xkYn7Ts9FUc9Zn4wa7CJpvWS5Xmdw2UyRy8iytl+m5CCHl4ytevLzoEZVN5m1Ob99AMjEtPxgU/KCRYQ1oY/DpUc86m3XVm4QjMLpIIFeHmCqBOFtxmF4KsAW0FLrYaC839cknPRPcauuqz27OTuVCsoblIVRJE7ECJUmDOjdmQ94w2UrVIJmU/I9HfITJTq4JCYAj2Yz0vAwu7PM0UMXo+i/ZADelSIQZ7U1n/iH9xSb9ez4q6fjJ/jkMosDAGzBq/BRDR25Fg6IYpOmuFTfc21s8/m1OD4o8rMQ8IHCQPb9UtvFbVCnnhZMUyyQxEf9SidS08NcJqLFJLkQW5KFaN72JXkLZzwUtcVX5sOSyA1gSOIAS3ZAA+KDZVxJo2xFUa29FxYYEAM1eV5sB3YmRiR8Vm3Ygf7p3Ng2d2uqQ6UWnHsrGNYQSGDz3c+r0FRAfvIujQcWyP24f+lQDwz5/nDkGXJYoNWCz
 Co+fNWAA
 VwiJh7EPxEB2ow6kKh+++dWon5K0a0A00c03xgz0NDnl+1jYkkmchqrI7l5a3nNaUtzGhk1fqSQjeFFWRelDZOG7KfrlM1l8D4u+skY+CHN9su4fGdZF/Sru+cz8IcIkau2BdiZmp4QUQnq6XZNy1MqW6VmLzSAvrw4ECkXvS00WATpPBF/nhlLZDrQQW+TYqN68LCLT9HAVMW9IVuv38s4INR9Ca5yIfKKGwPHkyOXDI0fv4BZZIm/GTIwPkZ80jOE8PpWa06k1QsLxg/E/CEYkGcvlyHPpIx6IVMTs5XFFMzKwHqPjdcyxSYUZhcQBU6K9ORAJe8Kp6gbmBHfUtrJkUpcmt42zyy1QJf961O0M/czPg7LsoZ3ZY+btjQ+6msTnJ2/wMZhsOfDyjRbOtDPARNF9fF4Mk+fDKKQ3Ko8L+gKDYsTw9kce4hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 09:30:26PM +0300, Mike Rapoport wrote:
> On Tue, Jul 21, 2026 at 06:16:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Jul 21, 2026 at 07:23:24PM +0300, Mike Rapoport (Microsoft) wrote:
> > > The splitting and merging of kernel page table mappings between small and
> > > large is protected by cpa_lock. The merging is relatively new but the
> > > splitting is ancient.
> > >
> > > The splitting has a locking optimization: since DEBUG_PAGEALLOC forces all
> > > mappings to 4k, there are no large pages to split. So the code that *might*
> > > cause a split can just skip the locking (and a few other things).
> > >
> > > This is entertaining, but it adds complexity and makes for weird locking
> > > rules. Plus it's all for a debugging feature which makes the kernel super
> > > slow in the first place. Optimizing something which is already super slow
> > > and not used in production is not the best way to spend our complexity
> > > budget.
> > >
> > > Stop gating cpa_lock on debug_pagealloc_enabled() to simplify the code
> > > and the locking rules.
> > >
> > > [ dhansen: flesh out changelog ]
> > >
> > > Suggested-by: Dave Hansen <dave.hansen@intel.com>
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > Link: https://patch.msgid.link/20260715144519.934289-1-rppt@kernel.org
> > > Link: https://lore.kernel.org/all/aab44f08-89f8-47fe-bee4-0ab6b25968c6@intel.com/
> >
> > Hmm this patch is already taken separately though? ([0]) (obv. commented there
> > already with review feedback).
> >
> > Intended to be with this series as some kind of background or? Probably better
> > to separate out given it's a live patch
>
> From the cover letter:
>
>   Patch 1 is already applied to the tip tree and I posted patch 2
>   separately [4], but I included them both here for the completeness.

Well that'll teach me for skipping the cover letter ;) Fair enough!

>
> > Thanks, Lorenzo
>
> --
> Sincerely yours,
> Mike.

Cheers, Lorenzo

