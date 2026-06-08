Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D398CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A248C6B009E; Mon,  8 Jun 2026 06:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC2B6B00A2; Mon,  8 Jun 2026 06:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939426B00A4; Mon,  8 Jun 2026 06:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 835576B009E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:26:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F9891A0A36
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:26:21 +0000 (UTC)
X-FDA: 84856365762.20.864524B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7493B1C0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:26:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgVwy8zh;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780914379;
	b=wwI2p3np75tGfTlvEkjHgeJgud67MqBXI9rmSkosbs3hOqtaqiMAur2Xva7LPRNOsY7l81
	NeohCsux9p8nVQwgiURl8rR0IFWxVCCCFqPUmKvtZbZwxpZuzXfwHyhycCSu0pvn0M9JnY
	Hu08cY0wyrDz6NDbVj2zhZqqtj0Kx2c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgVwy8zh;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780914379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1lroZnoIaLu1CMzf9kEVvvwG+CcQpGu2by6hNtmkow=;
	b=BbU3bapmlYMGox/gtcbgJHyWf1wk/VNOuLfMyegSPbt9GvMIIsrMwbAiVq8TWodkwH6CMD
	omlRQjM/froFiPDjs3Kk458sIUOWlJ0jwiTfVvogG+b2IztYv4+wxpDEIgKEo0EUx9z5E6
	pSNzJfWZHEPIXMrwnTu9NXSJygcx9pQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 048956001D;
	Mon,  8 Jun 2026 10:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817231F00893;
	Mon,  8 Jun 2026 10:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780914378;
	bh=i1lroZnoIaLu1CMzf9kEVvvwG+CcQpGu2by6hNtmkow=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=kgVwy8zhdyQca1BKeV6lxRurKUs5PF/8H4Yr4L5huRfNMVNH0YwhhuUCzuYXd8mv5
	 CbdlFVXFX6I/7m+gL8+0kNcyQcQjvwKtuHMu0mLoOg/WCDyzS4FP4eofmRSfoYr26E
	 5G70YuumsWXfdUFXHkyLauQKAYGEHDz7k8EFeRkSVnjLRYqBBk4c0116AjVCJbRlhw
	 yJwqLAndgemOL8eT8gkYVqdzaqyWgZkUFJylihyfv9UNkEh9SyU3HKx8xGdLGn7Sfs
	 4cowKgJmxIYsghmlUWcKOhA5iubapbStqLCBKdl/M0Iblw6O6f1fOi+PNSk9wK6Wd9
	 T17EaljA2Rt0w==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC v1 0/9] kho: granular compatibility and header decoupling
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kselftest@vger.kernel.org, 
 shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
 skhan@linuxfoundation.org, linux-doc@vger.kernel.org, jasonmiu@google.com, 
 linux-kernel@vger.kernel.org, corbet@lwn.net, ran.xiaokai@zte.com.cn, 
 kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
In-Reply-To: <aiVp5RlbWRz5VnPB@plex>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <178083348872.1648214.17778188633648887952.b4-review@b4>
 <aiVp5RlbWRz5VnPB@plex>
Date: Mon, 08 Jun 2026 13:26:12 +0300
Message-Id: <178091437240.1648214.10761111570005003901.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 7493B1C0008
X-Stat-Signature: gwymdt3833dyij59395g8wkg6afnwc1p
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780914379-503576
X-HE-Meta: U2FsdGVkX19A+ywwJtAF3i4J6srpYHpZDvVtNLp6uQszLj+Khs17lPWaxUyf6tNUFXaPt0M2QkPU05WEXJPCtmRSuXxKTLtp7/eyBiughbK3Mcei3U6vQ2TpNwgClcIgKg/0N3qjRpNnCNGU4K1nb4c29U6vKMjAcWtPtFZsjkOyq8DdV2XC4JIFFf3JRkHjmeVlecLbzYvdR31DTbSVSsvDGVdZBiYcYd0U8inxZYZl9cKzDCEBnoC5702etd6EW/nU42RUG7fdnpBT66kDAGEnv1aylxy/JQhgfuPb62dwT5bI1D+hgW1N1b/UNu+NB63zY3TdXO7Vlmdq0jhOGEqZ9ndhylPyEcJb3CmCIjOBdysxvbEaiT/G0OW9wFfGs7kH97+KRh472IhvIldtw9z5DMQkIIwpzPfX2pIdyyR1Mtci5amtDOB00Lef+UAb9f+xF7KLYGQ5ArydBpJcUlQ7WpxkclEDwsf6vb8QS0fKmZgq5VTToEVVJFi3xrb0sJruX2c7nDG0ETAuPryxcEiEYERGizh7xFZ35uy1/jlppT5iUzLk1AIGuhAfPhj64HAUOnBOR4Mo/Ds+/C5IWf81c+wntJsy3Kvnni91Do4wqEsDHF7JWxSDfh0uaYDRZ2CpkRL4LR6O2o00n76Qs0AJu26ZbEbE99knRL1lrVhTXKjHSnGochL77Wad/bUjJQqbBedpvsCYgSROCHIjbdETap87Ofngg/beaM+qXLGvr63W7MfMEdpAX4jC3raEMC0YyUjX68b/xf9Y5bfSzMYqBI+xNg2L6mZaWGvBwXYL3BDhREDrwGg+x07OI1NkcpNH1sTNcrG/lCepTsNhtefWi6J/4oVXcnfgrxqw1FFf3RpglDeBowSzmDxCz+L4M7Jy9O9592C+ecTUfhqpmHBf3MQx6ELn53UHpNvDeprCKbTABYVsrWIxianxJsbWrSBKt8pEB+ZUKxIGQ9V
 1qlOszd6
 0ojMQ+UBWayvNgHwetR//H+8oP+7mxNuGD/7BnF2DikIBiADgaOZ3ejEqIgXeXPnDDEMZhJOZjQ0PKNhM7sojQsTZqtyQA1sP+sKhWRZ8/D+VKAR1cdUWLD3p55Fp9g+mbRxgp8DhfyLEkVtse4LKs9hs9BMwR0nCOA4m41zzEClhqMY2fgRq/yi4cTmPZSZKdq/wzeVQXYeolqoIu2JE1roiY0HESngdDVGuIB1gfOsZFVXDDbymJgdM/GKi7bCqVu8oDu+M8r/gLrUsufedsQXWcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-07 13:43:09+00:00, Pasha Tatashin wrote:
> On 06-07 14:58, Mike Rapoport wrote:
> 
> > On Fri, 05 Jun 2026 03:32:26 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > 
> > Hi,
> > 
> > 
> > I'd keep vmalloc where it is, it's more of a memory preservation primitive
> > rather than a data structure of it's own. The data structure it uses is an
> > implementation detail.
> 
> kho vmalloc is absolutely a data structure. KHO core only provides the
> basic handover mechanism (FDT nodes, physical memory ranges). vmalloc
> is a structured representation on top of KHO, and should provide its own
> versioned ABI.

kho_preserve_vmalloc() has the same semantics as kho_preserve_folio().
It's not intended to be used as a data structure. The data structure is
an implementation detail unlike with kho_block and kho_radix_tree that
are intended to be used as data structures and expose clear data
structure APIs.

Yes, vmalloc should have versioning, but that does not mean it must move
to different files.

And, btw, moving KHOSER_PTR() infra along with vmalloc is wrong. It was
my oversight that I didn't insist on using it for most of the
serializeable pointers instead of open coded
virt_to_phys()/phys_to_virt(). We need to fix it.

> If we change any of the vmalloc serialized structures (like kho_vmalloc,
> kho_vmalloc_chunk, or kho_vmalloc_hdr), then vmalloc won't work and
> compatibility will break.
> 
> Core KHO does not need vmalloc; nothing in kexec_handover.c uses it.
> 
> Instead, vmalloc has external customers:
> - memfd (uses it to preserve serialized folio metadata)
> - KHO test suite in lib/test_kho.c (uses it to preserve physical address arrays)

Following this logic, kho_presrve_folio() should be moved out because
it's not used by KHO but has external customers. And radix tree should
forever remain in kexec_handover.c because KHO uses it ;-)

> > Let's minimize the churn where possible for the sake of git blame and
> > backports.
> 
> It is much better to do the right cleanups now while KHO is young. Once more
> subsystems are added, this refactoring will be twice as hard. Modularizing the
> code now guarantees a simpler, safer, and scalable design. Placing each data
> structure in its own file gives us code that is easier to maintain, review, and
> less prone to bugs.

dependencies
> > that justify small headers for each two functions and netiher
> > linux/kexec_handover.h nor linux/kho/abi/kexec_handover.h are that long
> > to start splitting them.
> 
> External users only need to include the headers they actually use. For
> example, LUO shouldn't have to pull vmalloc or radix tree KHO
> declarations, and memfd does not need block.
> 
> From a maintenance point of view, it is much easier to catch ABI
> changes when the file with the appropriate version has been changed,
> and most likely the version of that file should be updated. If a single
> header contains compatibility versions for several different data
> structures, it is easier to miss the correct version update.

No matter in what files the definition lives, someone can forget to
update version and we may miss it during review.

Would be better to spend this time and energy to add kho-specific prompt
to LLM review to catch such issues ;-)
 
> Since we are splitting the source files (like kho_radix.c and
> kho_vmalloc.c), the headers should logically follow the same
> modularity.
 
They could. Doesn't mean they have to.

> > I agree that we should decouple versioning of these components from the
> > global KHO versioning.
> > Can't say I agree with the way you propose to do it.
> > 
> > I don't like that each user of a KHO component should include that
> > component version in its own version string (or whatever it may become
> > later).
> > 
> > It requires ABI headers update each time a user decides to add a new
> > data structure and worse when there is a change to that data structure.
> > It creates coupling of the data structure user with its particular
> > version and just looks ugly IMHO.
> 
> It is actually the opposite.
> 
> If a user adds a new data structure, that new data structure will have
> its own compatibility version. Instead of the current approach where
> the global version string needs to be updated, only the new version
> string would be added.
> 
> Also, if someone updates their code to use the new data structure, their
> compatibility string is going to be updated anyway, as part of using
> the data structure requires including the dependency in their
> compatibility.

Sorry I wasn't clear. I agree that kho_vmalloc, block and radix tree
should have their own versioning rather than rely on global KHO version.

What I don't like in your proposal is mixing versioning of a component
with its dependencies.

I think that versioning should be completely local to each component.
LUO should not care about kho_block "on wire" layout. This should be
encapsulated in kho_block.

> Backward compatibility is not in scope at the moment, but we can make
> the version parsing more granular in the future.
> 
> Instead of a simple strncmp(), we can introduce a standard callback
> interface for data structures. Each data structure implementation would
> implement this interface, and we would pass the parsed version string
> to the data-structure-specific version check.

Backward compatibility will be in scope sooner or later and string
parsing is surely not the way to deal with multiple versions.

How do you suggest to represent support for multiple versions?
"luo-v2;luo-v3;block-v2;block-v3;block-v4"?

> > Or, say, we add support to kmalloc() and use it in kho_block.
> > Then we'd have to add kmalloc() versioning to all kho_block users, right?
> 
> I was thinking about this. Since we don't have examples of data
> structures depending on each other right now, I simply made sure
> there are no duplicates in the compatibility strings.
> 
> If data structures have interdependencies in the future, we can easily
> remove this uniqueness restriction. The users of block will still
> include the block compatibility string (which automatically includes
> kmalloc), and if user also depends on kmalloc, they will include it
> as well.
> 
> > I think the versioning of each component should be handled by ->restore()
> > of that component. If it sees an incompatible version in the preserved
> > data, it returns an error. The versions can be stored e.g. in the base KHO
> > fdt.
> 
> Hm, I think, checking compatibility inside ->restore() of each component may be
> too late in the boot sequence.
>
> By checking the composite compatibility strings upfront (before invoking
> the actual restore/retrieve callbacks), we can guarantee that the entire
> state configuration is fully compatible. If any mismatch is found, we
> can cleanly abort the live update.

If a ->restore() returned an error (for any reason) we anyway need to
reboot, don't we? 

What do we do if memfd discovered incompatibility, but, say hugetlb
global state was already restored?

If you really want to run the compatibility check upfront, we need a
mechanism for that. And that should probably happen even before
kho_mem_init().

> Additionally, keeping the versioning managed via composite strings on the
> serialized data and registered handlers keeps the KHO core completely
> decoupled from individual component ABIs, avoiding the need to bloat the
> base KHO FDT with subsystem-specific versions.

Actually FDT "compatible" handles versioning nicer than composite strings
You can have

	compatible="kho-v4", "vmalloc-v1", "radix-v1", "block-v2";

and check fdt_node_check_compatible("vmalloc-v1") for vmalloc and
fdt_node_check_compatible("block-v2") for block.

And we wouldn't need to reimplement string parsing ;-)

But yeah, I do see value of making components versioning and KHO global
versioning independent. I just don't like composite strings and I don't
like mixing versioning with dependencies.

Since we are moving from FDT for the most things, version should become
a number rather than a string and version compatibility should be
independently verified by each component.
Then dependencies between components will remain at API level rather
than brought into the ABI.

If you think ->restore() is too late for compatibility check, we should
work on a mechanism for upfront compatibility verification.

> > > 5. Adds a KUnit test suite to verify that the composite compatibility
> > 
> > Without "composite compatibility strings" we don't need to care about
> > them "remaining unique and sorted in alphabetical order".
> 
> These are not strict runtime requirements; they are simply there to enforce
> code cleanliness and prevent human errors like accidental duplicates or
> mismatched orders.
> 
> Even with a simple strncmp(), it works perfectly fine as long as the
> strings match exactly. If the uniqueness or sorting constraints are too
> strict, they can easily be removed.
> 
> In the future, we can transition to a more sophisticated version checker
> that parses the composite string into individual subsystem version tokens
> and verifies them one-by-one, rather than relying on a strict literal
> strcmp() string comparison.
> 
> > The need for this test alone is already a red flag ;-)
> 
> I will remove test ;-)

It will not remove the red flags ;-)


