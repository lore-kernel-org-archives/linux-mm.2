Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 962CDCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046426B0005; Mon,  8 Jun 2026 12:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11B66B008A; Mon,  8 Jun 2026 12:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA1C6B008C; Mon,  8 Jun 2026 12:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C65EB6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:13:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D7291C0804
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:13:01 +0000 (UTC)
X-FDA: 84857239362.22.FD0F06F
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7A11E140009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:12:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YB1nANr6;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780935179;
	b=LIVOefJei1rna/DjfBxeE3nwGxFSUvhQwnQWHcNQIUgY1nFhvPH3Y9YYUBwJYk4it5iL01
	Zf2ZVpiJbojGAw5ga6vUGN3bc1/k9BK4vxEgW+ALYXYEAZZPADCDR7wJsfQRtFseJjfbIT
	qvZpn7iUL6++m0GV5vrnYoyn1jSewq4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YB1nANr6;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780935179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7BP0s37Q+khF0GZ143YoXVWV8LzH4rQFimf53xc42o=;
	b=MYUKqc42XQ4FiOwPcz9k8w3YVZe2/2MyvUlIttfx932CFDCsJA/JN5Q4BOm4k48AGhzVlL
	/1zd1bEEEnRataBIcSs8jQzqDab/jSoRXmJxu3mf8I9/Hl6PPEbOD5UlKBgt5B+2e/Wtol
	0dUrDYSBNEi+Rz7xylkcKIFYfZ6WQzA=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9158629a220so501058985a.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 09:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780935178; x=1781539978; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G7BP0s37Q+khF0GZ143YoXVWV8LzH4rQFimf53xc42o=;
        b=YB1nANr6ijs3exZAl+WWYpHDp4fl+RzUtTudADAWvsYZbK5BFhwXwuB6X2HxerhUQa
         ByU8yH4RnvNzEk+uY7EF3undmllq7L1IwqUOsvbvPQUg5tVp6Mol/m22pZIAIr2sYipf
         jw2Vbtu7evWZZtPWeacPEVWHmU8DZs+gXm6UxcojVyPjaCtAOidMQ8aqRwc2hxQNrlnm
         lP86fcfUuhxmaB7CcLwJyynk2gNSvmzhEx5tLNMr7+nBkf2ZpUhQNI9OYPfk8Zeb+9qS
         XEE6dfBIdHHrqNInTUcEAHz6mNeg8uhAF9v2SpT/KaUnM+qm2QzxdcIXVEITwVvZH8rH
         9/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780935178; x=1781539978;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G7BP0s37Q+khF0GZ143YoXVWV8LzH4rQFimf53xc42o=;
        b=M94kn5xkVvU/aamkCzbCWm8OkifCRR9NCtJzgCgmvgdgYiHDKbCtwHd8hrMnTKCdnI
         SYnhZVynEPw+H2Fy1lAfD/xV6G+mrys3bs7a45LZ4SJN5Yc1jX2f5iKi3wwchq9w7XBi
         ebAz92cl0J77/yQEaRrdrl1vp3gVETuTJXn/CbTxLYYltiHkKGc5bPdsSk8D0Cj2Q2hi
         +VEFWXF1OVmP5NRVBzHeAA3Kv90KeT3177/CztZzBbzgihLyKcE6j3gaUi83l63pFlNi
         LogRRrh3hl8Fb4/+dR/wnbRXBNq+C6nUnCY4w5m51ifMPDLp5CtkeItkimUrII2dm1Z2
         70dQ==
X-Forwarded-Encrypted: i=1; AFNElJ9neOwTA7VVrpz2wabgUC649kUydpLHpnk+mu9fXE6r2R9xnwg65Op/mys0vlNDOatdqVjCxJ+jKA==@kvack.org
X-Gm-Message-State: AOJu0YyRqz7dhFyBQadpiDueWPrpd/sm8nyAdu254K2JFaJ6IwMoyrw9
	Pb1UPNGvModSXWh7p7TtGiN/M80y+eQBTVtEhgqZdH/qBkQMEluOo/8T3nPgZDAIOuk=
X-Gm-Gg: Acq92OHBmCZdj2mIIUBJG7ItRZ9VOqKK8E96E+K9Ut2A+zSG6bcjaCKFq/58Y8e+zyu
	3CjFooCtqK5rW2u7WRdIG1yVrq5D5aDhidIkOrqHDPsZ1CqHjTTM0+mzmPzTQRUR8lmwSnft9Sd
	BvAQhF2R8Q4jWSekq+rQU6zh6xEYv94BcXzGwJv2j6QrxqIjBhjW6ds/aIRm8MlRq//P7kV8O1i
	APUE8Bjv14tk5UEuu8x/EDQO5MuPKn8keq43iASHrejfE88Z/IZNcF/2+7hNZsTuQKIZDjzEEq7
	kxw5yFAr2QtEStH6tMsBJVa4C/70wvUh53nxNiovSduDXVMvlKZXAfkyRh/Y1Wq5H06bOC/zHM/
	qxMpcAi7VUbnXSxWW2aUzoWbxs3JCLUu444rDV8BBAtQ943W8Srnt3NS1l4sWUdWK1AxrYHS928
	lyQGTzW3RbXMmHKzu2WKqSpeGAvnMSPPR61Y824sjTzyJHnls5GlYIQrrDSeizAA==
X-Received: by 2002:a05:620a:1988:b0:8cf:c106:faca with SMTP id af79cd13be357-915a9d899a6mr2683778685a.36.1780935178189;
        Mon, 08 Jun 2026 09:12:58 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a00ba04sm1761661385a.7.2026.06.08.09.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 09:12:57 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:12:56 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, jasonmiu@google.com, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, ran.xiaokai@zte.com.cn, 
	kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
Subject: Re: [RFC v1 0/9] kho: granular compatibility and header decoupling
Message-ID: <aibYJvzQQnpoN6YW@plex>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <178083348872.1648214.17778188633648887952.b4-review@b4>
 <aiVp5RlbWRz5VnPB@plex>
 <178091437240.1648214.10761111570005003901.b4-reply@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178091437240.1648214.10761111570005003901.b4-reply@b4>
X-Rspamd-Queue-Id: 7A11E140009
X-Stat-Signature: tnmtzy9b764swbs14feo6j3kbkqx9b51
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780935179-472268
X-HE-Meta: U2FsdGVkX19NdxRtzD16E9XCoDGGUFAELowNZyfz9giTMRo4LIo7f7VVMWc+SwzObrzGpI+zB4UHDpAAc1rJn0gY61Aw8m0OXp8u/cAmUype7d9lbz0/1L4Q9BV8tWtNqB5PF/PPqbatd0V3lyBTmLcKng2DgW3qNLyOLraYYC2jM/0UIEK78At6g1rgFONExKUa7Toszva4kHNAVrFQkm7/S84SO6L4xrpQ4HURoYI5q3sjjezFQy3wG6bJnAXy5IW0FXADrcE/Yef6msZV2P7TZJBn829DGVF6gOhzzvgwXaiRmz8wjHC+p/6w6GL9BtpVPRYYG4jnAx+uUJSxMAtictmMQZrYirSqtniVIXpy4AeS/3KoA4VUKCuvESTP3x3HwrIekbAT6fJ1MD0oBNybE8/ibUYzpOq8wrLnYvucJunTMTyaC8EuEQCzkNpZnD8veqqeXKFCorj1V/0q1BEN2f0cBPmV++jtkzL64TjgLQZNRiHpNgTh8YTi6l4ZRVpjAf7LZ+deQdPGfKKW3Fb1fU8kWDxTuGG1M1E4VsZTnHxQBWh3QlAEjOTVrc06VaXe0t8lJOjWvKE9cXmb1febX0Se2ExfAYt6EtwoF6ZbR/mJtww+wFAUZEvoYfIeUOg7R41l9vpCaPZOLlG581sZIWIZAo+BImilhTk5RyUQ1Z8QxxlussZL48H5A5AbgAtXQL4ecmJaKJ17MQ/pg3Bi63DG5zllIX97gYsVEmaQU18z52YSVjwZ1MjQTz8BeodGVFRYWS84h5YjTjiGekqxVH7NfjhZBr87RjUHcSg/YcuwtmBMMC6j7wU2nuv3phrohBQEaspS3Iht69uoIzCqTcQBiU2g73xuO2O2BckBABK7OObZdmb4D4vLSnsU+zIYNJflkP4KZ3qreqwWt0MvEg/jLTf4v60suk5RHw3JaZuTe/TAQ7o8HrUQucbHFAAj8Ir2Y/sGb26iIkF
 0v6TZDqR
 ad+OpnVvQz37wOOQbjKHrjvScx6Iw9EfxZezb3sgGCNge8gVzIFm703OnMOQi88gaFDoykx2MQ4qV017gkAM+4oQ2J8PFdxmf0ubbRC3DKp5kQS2KactvDRrbTCVjskeynW3/qPw/rKKm93HeUMyYRuckgDgl69RnrzE0L7zgt8FAOtP4RBy2yg+tc2QZ3nvA3u8aTkTIWBOSARmjEprxR3LOlgJhViAaxULJB2F4vA2xXhMwn/+/rECUWU3ClWameFlKIRM02/zgr7nKMynCBa8AglusMIqMav4WBcFljjOkkO/uguMIxQnhpzD8w9ALA7KeND9K9UQfQedEH/5O3zMU6d6t7bMXMx5APhD8HPXfCdos65n8T+d7j9MXIRgqqC0Xv4Ua9am35niEvRsC9TS/Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-08 13:26, Mike Rapoport wrote:
> On 2026-06-07 13:43:09+00:00, Pasha Tatashin wrote:
> > On 06-07 14:58, Mike Rapoport wrote:
> > 
> > > On Fri, 05 Jun 2026 03:32:26 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > 
> > > Hi,
> > > 
> > > 
> > > I'd keep vmalloc where it is, it's more of a memory preservation primitive
> > > rather than a data structure of it's own. The data structure it uses is an
> > > implementation detail.
> > 
> > kho vmalloc is absolutely a data structure. KHO core only provides the
> > basic handover mechanism (FDT nodes, physical memory ranges). vmalloc
> > is a structured representation on top of KHO, and should provide its own
> > versioned ABI.
> 
> kho_preserve_vmalloc() has the same semantics as kho_preserve_folio().
> It's not intended to be used as a data structure. The data structure is
> an implementation detail unlike with kho_block and kho_radix_tree that
> are intended to be used as data structures and expose clear data
> structure APIs.
> 
> Yes, vmalloc should have versioning, but that does not mean it must move
> to different files.

Core KHO preserves contiguous ranges of unmovable physical memory, that 
is it. Preserving physical addresses and folios falls into that 
category, and everything else is built on top of it.

The underlying implementation is where the ABI contract is defined. 
Unlike kho_preserve_pages(), which just tracks raw physical ranges, 
kho_preserve_vmalloc() must serialize non-contiguous virtual memory. To 
do this, it passes metadata kho_vmalloc, kho_vmalloc_hdr, linked list of 
PFN arrays.

I do not understand why you are so against the modularization of 
higher-level implementations on top of KHO. Moving them to dedicated 
files makes the codebase cleaner and easier to maintain. For instance, 
at some point we might support sparse or partially filled vmalloc areas 
where VA size > PA size, or areas that have holes.

Keeping all of that in a single KHO file is the wrong approach and goes 
against how other logically separated subsystems in Linux are organized 
(e.g., mm/vmap.c, mm/vmalloc.c, etc.). Yes, there are some messier 
places in the kernel as well, but keeping this in its own dedicated 
kho_vmalloc.c file makes complete sense to me.

> 
> And, btw, moving KHOSER_PTR() infra along with vmalloc is wrong. It was
> my oversight that I didn't insist on using it for most of the
> serializeable pointers instead of open coded
> virt_to_phys()/phys_to_virt(). We need to fix it.

The only reason it was moved to vmalloc.h in this series is because kho 
vmalloc is currently the only user of DECLARE_KHOSER_PTR / 
KHOSER_STORE_PTR in the tree. I can move it to the newly introduced 
compat.h to keep it in a shared place.

However, overall enforcing the use of KHOSER is unrelated to this work. 
I have my own thoughts on this, and perhaps with proper versioning, 
using KHOSER_PTR everywhere would be appropriate, but let's keep that as 
a separate work.

> > If we change any of the vmalloc serialized structures (like kho_vmalloc,
> > kho_vmalloc_chunk, or kho_vmalloc_hdr), then vmalloc won't work and
> > compatibility will break.
> > 
> > Core KHO does not need vmalloc; nothing in kexec_handover.c uses it.
> > 
> > Instead, vmalloc has external customers:
> > - memfd (uses it to preserve serialized folio metadata)
> > - KHO test suite in lib/test_kho.c (uses it to preserve physical address arrays)
> 
> Following this logic, kho_presrve_folio() should be moved out because
> it's not used by KHO but has external customers. And radix tree should
> forever remain in kexec_handover.c because KHO uses it ;-)
> 
> > > Let's minimize the churn where possible for the sake of git blame and
> > > backports.
> > 
> > It is much better to do the right cleanups now while KHO is young. Once more
> > subsystems are added, this refactoring will be twice as hard. Modularizing the
> > code now guarantees a simpler, safer, and scalable design. Placing each data
> > structure in its own file gives us code that is easier to maintain, review, and
> > less prone to bugs.
> 
> dependencies
> > > that justify small headers for each two functions and netiher
> > > linux/kexec_handover.h nor linux/kho/abi/kexec_handover.h are that long
> > > to start splitting them.
> > 
> > External users only need to include the headers they actually use. For
> > example, LUO shouldn't have to pull vmalloc or radix tree KHO
> > declarations, and memfd does not need block.
> > 
> > From a maintenance point of view, it is much easier to catch ABI
> > changes when the file with the appropriate version has been changed,
> > and most likely the version of that file should be updated. If a single
> > header contains compatibility versions for several different data
> > structures, it is easier to miss the correct version update.
> 
> No matter in what files the definition lives, someone can forget to
> update version and we may miss it during review.
> 
> Would be better to spend this time and energy to add kho-specific prompt
> to LLM review to catch such issues ;-)

LLMs are great, and we should absolutely rely on them. Spending time 
defining LLM rules and helps in the long term, but none of that is an 
excuse for keeping the codebase messier than necessary. Having the 
codebase logically separated and modularized is still the right 
approach; ease of human review should always be prioritized, even with 
LLM assistants.

Localized context is incredibly powerful for preventing human error. 
When a developer modifies a structure in vmalloc.h, the corresponding 
compatibility version is right there in front of them in the same file, 
making it far more obvious that a version bump is required. In a 
monolithic header, it's easy to modify a structure on line 100 and 
completely overlook a global version defined on line 10.

Modular files drastically reduce noise in git history and diffs. If a 
reviewer sees a patch touching include/linux/kho/abi/vmalloc.h, it is an 
immediate, high-signal flag that a specific ABI is being altered.

Even LLMs behave much better when the context window is smaller. An LLM 
can read a focused file and understand the interactions much more 
accurately, compared to polluting its context with a unrelated 
subsystems.

> > Since we are splitting the source files (like kho_radix.c and
> > kho_vmalloc.c), the headers should logically follow the same
> > modularity.
>  
> They could. Doesn't mean they have to.

This is not a logical argument, nothing is have to... Keeping headers 
aligned 1:1 with their implementation files provides clean 
encapsulation, prevents transitive dependency pollution, and ensures 
that ABI changes are tightly localized.

> > > I agree that we should decouple versioning of these components from the
> > > global KHO versioning.
> > > Can't say I agree with the way you propose to do it.
> > > 
> > > I don't like that each user of a KHO component should include that
> > > component version in its own version string (or whatever it may become
> > > later).
> > > 
> > > It requires ABI headers update each time a user decides to add a new
> > > data structure and worse when there is a change to that data structure.
> > > It creates coupling of the data structure user with its particular
> > > version and just looks ugly IMHO.
> > 
> > It is actually the opposite.
> > 
> > If a user adds a new data structure, that new data structure will have
> > its own compatibility version. Instead of the current approach where
> > the global version string needs to be updated, only the new version
> > string would be added.
> > 
> > Also, if someone updates their code to use the new data structure, their
> > compatibility string is going to be updated anyway, as part of using
> > the data structure requires including the dependency in their
> > compatibility.
> 
> Sorry I wasn't clear. I agree that kho_vmalloc, block and radix tree
> should have their own versioning rather than rely on global KHO version.
> 
> What I don't like in your proposal is mixing versioning of a component
> with its dependencies.
> 
> I think that versioning should be completely local to each component.
> LUO should not care about kho_block "on wire" layout. This should be
> encapsulated in kho_block.

That is a fair point.

As I mentioned in my previous reply, we can definitely look into making 
the version checking more modular. For example, each component could 
implement a standard compatibility-checking interface.

These checks could run early in boot to determine whether each component 
is capable of accepting the incoming preserved data format.

Whenever the component is later used by LUO, memfd, etc., we can query 
that cached status. This achieves four key benefits:

1. It avoids delaying the compatibility check to the actual time of data 
retrieval, which is too late to safely abort.

2. It prevents a local incompatibility from triggering a global kernel 
panic, allowing us to handle failures gracefully for just that specific 
component or session.

3. It keeps the local version local, as you suggested, so it is checked 
only by the consumers of that specific component.

4. It provides a clean path for backward compatibility, as components 
can individually decide whether they understand the incoming data 
format.

> > Backward compatibility is not in scope at the moment, but we can make
> > the version parsing more granular in the future.

100% Agreed.

> > Instead of a simple strncmp(), we can introduce a standard callback
> > interface for data structures. Each data structure implementation would
> > implement this interface, and we would pass the parsed version string
> > to the data-structure-specific version check.
> 
> Backward compatibility will be in scope sooner or later and string
> parsing is surely not the way to deal with multiple versions.
> 
> How do you suggest to represent support for multiple versions?
> "luo-v2;luo-v3;block-v2;block-v3;block-v4"?
> 
> > > Or, say, we add support to kmalloc() and use it in kho_block.
> > > Then we'd have to add kmalloc() versioning to all kho_block users, right?
> > 
> > I was thinking about this. Since we don't have examples of data
> > structures depending on each other right now, I simply made sure
> > there are no duplicates in the compatibility strings.
> > 
> > If data structures have interdependencies in the future, we can easily
> > remove this uniqueness restriction. The users of block will still
> > include the block compatibility string (which automatically includes
> > kmalloc), and if user also depends on kmalloc, they will include it
> > as well.
> > 
> > > I think the versioning of each component should be handled by ->restore()
> > > of that component. If it sees an incompatible version in the preserved
> > > data, it returns an error. The versions can be stored e.g. in the base KHO
> > > fdt.
> > 
> > Hm, I think, checking compatibility inside ->restore() of each component may be
> > too late in the boot sequence.
> >
> > By checking the composite compatibility strings upfront (before invoking
> > the actual restore/retrieve callbacks), we can guarantee that the entire
> > state configuration is fully compatible. If any mismatch is found, we
> > can cleanly abort the live update.
> 
> If a ->restore() returned an error (for any reason) we anyway need to
> reboot, don't we? 
> 
> What do we do if memfd discovered incompatibility, but, say hugetlb
> global state was already restored?
> 
> If you really want to run the compatibility check upfront, we need a
> mechanism for that. And that should probably happen even before
> kho_mem_init().
> 
> > Additionally, keeping the versioning managed via composite strings on the
> > serialized data and registered handlers keeps the KHO core completely
> > decoupled from individual component ABIs, avoiding the need to bloat the
> > base KHO FDT with subsystem-specific versions.
> 
> Actually FDT "compatible" handles versioning nicer than composite strings
> You can have
> 
> 	compatible="kho-v4", "vmalloc-v1", "radix-v1", "block-v2";
> 
> and check fdt_node_check_compatible("vmalloc-v1") for vmalloc and
> fdt_node_check_compatible("block-v2") for block.

That is actually very similar to what I am proposing—individual version 
tokens (which in my current series are concatenated into a composite 
compatibility string separated by ';').

But let's not get too fixated on the composite string formatting. I 
actually really like what you are proposing: using integers for versions 
and having each registered component carry its own "NAME" and version 
number in the KHO FDT.

> And we wouldn't need to reimplement string parsing ;-)
> 
> But yeah, I do see value of making components versioning and KHO global
> versioning independent. I just don't like composite strings and I don't
> like mixing versioning with dependencies.
> 
> Since we are moving from FDT for the most things, version should become
> a number rather than a string and version compatibility should be

AFAIK, for everything but KHO itself is going to be FDT free. I would 
like to be strict about that going forward :-)

> independently verified by each component.
> Then dependencies between components will remain at API level rather
> than brought into the ABI.
> 
> If you think ->restore() is too late for compatibility check, we should
> work on a mechanism for upfront compatibility verification.

+1.

Pasha

