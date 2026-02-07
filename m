Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E20EE6B6F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 00:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4086B6B008A; Fri,  6 Feb 2026 19:48:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B63E6B0092; Fri,  6 Feb 2026 19:48:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2606B0093; Fri,  6 Feb 2026 19:48:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 198B36B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:48:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3995213A7A9
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 00:48:43 +0000 (UTC)
X-FDA: 84415825326.22.4A8144F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id ABA924000D
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 00:48:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p7nX2vVX;
	spf=pass (imf07.hostedemail.com: domain of jpoimboe@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jpoimboe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770425321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThdYRa0w0w0c6u8WzkCILTjX8n/t6NbT4BMxHfe2XJo=;
	b=PAVxeWvwA66YqCW+k4noRArlThnPZ91i2XvUDQYvJ4HSzYALbeoCaWj3Nk4tEje4k0i1py
	IDH9J1wpSigB9wNrvM1RdkYeChAipi15iIS1tJTupPAewUJhtiV66MFgtjK6xtHIPOquKl
	E/ROyJUPOSY6yOxsU1WiXd4KfZkQlc0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p7nX2vVX;
	spf=pass (imf07.hostedemail.com: domain of jpoimboe@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jpoimboe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770425321; a=rsa-sha256;
	cv=none;
	b=q1PFau4ZfHM0Z8FVLUXhDxT9gi9bTzlS43JjSdKNxP6L+oSxTrxexhnEz2vfbaVMA1s4G3
	QVAvPSbi5TAWnuEFY23nETO11YPiYBWycjIuwJ+t+Px+ZP9ja9bDWyIarcLQUFk0gvh68W
	QTj1Zt8wce7Ysf/4GjoUUvJUaCUz30A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D17F3600C3;
	Sat,  7 Feb 2026 00:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE14C116C6;
	Sat,  7 Feb 2026 00:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770425320;
	bh=vsvgKR4j92CFsccFD6/N2XzrLJouwtpGWdBZS6Ku7o4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p7nX2vVXviUESlx8Jk7ISlG4N0+euZ5ks+pQQGhT+J9tbyWxYHXPF0ekRxG4DpISu
	 dN0sohT7CkSMHGV9T+qTysmH9D3OwEVm7lwkrKWA3YrXYAngHjdlU9x7KFPUWUdnha
	 st16aMTVH4R1YRqLofCAFIho4042/FJbxmc8klRZcNVe/tzZgBVbFQq5Opaf2Oq0vu
	 4xA9SmmFpUkT5UCdZ/2z8fZK438ADxP7SYh1OWlkkcmpqruhh98c9Ua5YW+eG8q0l8
	 3nsSWFD+Z/epBoJzv9V7wUmw0f9yrFRrN8pjk9ZGQ8sCEl8VDpQ8yZdPAXl9FiPNWs
	 Z+HRp3xKIi3aA==
Date: Fri, 6 Feb 2026 16:48:37 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jens Remus <jremus@linux.ibm.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Steven Rostedt <rostedt@kernel.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	"Jose E. Marchesi" <jemarch@gnu.org>, Beau Belgrave <beaub@linux.microsoft.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>, 
	Carlos O'Donell <codonell@redhat.com>, Sam James <sam@gentoo.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH v7 6/6] x86/vdso: Enable sframe generation in VDSO
Message-ID: <h34g66ujiebhuxzcqo4hg4zq2mbpbh5c3u7b7qlznaqxxwpczf@3kwv2wydbuiq>
References: <20260203171958.1522030-1-jremus@linux.ibm.com>
 <20260203171958.1522030-7-jremus@linux.ibm.com>
 <f671c79a-ee73-4a12-af48-2811f97b9f3d@zytor.com>
 <9a63ce89-84f0-4782-90bf-dfd7c8ec8c52@linux.ibm.com>
 <1AE3ED79-C094-46AE-B455-06199D5699DD@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1AE3ED79-C094-46AE-B455-06199D5699DD@zytor.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: ABA924000D
X-Rspamd-Server: rspam07
X-Stat-Signature: tonfdrru4fbm98jb8b87o1tfsekmrhae
X-HE-Tag: 1770425321-811449
X-HE-Meta: U2FsdGVkX1+BVNNyaAqPV3GTMAmfJk/Jp0aHezEhU3CPtbIQJpreP9wyrwVkjumEDhfoYY2ehoGmFMfEPbjGvkwGDgEl+TLM2acC4CBMaRTvIhqyzhuodinWRlKgj0neRk5qYRF1PfctU7iHnM/jia677NBoH8URM3KN/RM84foe+o+PRKLAWSz7UZ+5A2KckQqe32VghsdbzGhaCKYjRHFZvrx65lNannCD8awTwOs5X7blJLjooUPknNELhYped5GygLFPaAqjfwQl0kZ0Rpp12RieUuqgvwOSYO8gc4QcV7MHxPJ108pbuX2ZbrguQytluEkO/IXWnbjMrA04CdLTWtSw4Dx4jTWYX5iwT15J06EMQv1/ipK8uRS46S/qntVo+j1EoP3Hjl1YYUXnHiaRDf9n+Ry9Bvd9NBw9ROs6xExxg2pf/qKfBnd/qG6d8+vld9nidCcokpRAgDW8o+uSHRFmSvgzNRuUkKXqLITE6hNi3Tdf3gNwtGJyzfS1Yq0Xl2gp6pV1iNyzCD3mXhSE3dqVHzAqkyyIXWB5Ivo/4ECNYFaf/RhLUpOO6IrOYxx+ka5l0f41ThcZ/99DjdgTqxDdnAqjT2PT34eDRczRxxVsPgJ7KMamYoa7XKhUsIB1sUTsWXQoMul+zC6GDzStpc8hUMKUPdgh/Rkx+3xpsr4GgE+qs9xsPD1m5o+/mZRaeWqmryT6EG5Od5pQYDc5fV/rDlOt/XARF8Y7oJI4og1rkWNVJUTJJLy+n1Oh9jUSqPMrcJWEiFrwShKfmb3oC6PSqyThtl3cEJ+UksAE8dHO33LL2fIjmpKKQzfmFy5j8ktUnGTKGIVU1o9HQupEPOAJxKGhq2ZGp7Rd/UJOxYpkKAUJD/d0jqRL/Rh002IDzhHj+1OoxFnwoeiYNAZp5zpmbOL26B9oAdQ5tzE/uVxGc6OziVWCWRmhA6m8g0NYnEHlEJct05BoUXr
 CObU/YcY
 spS/PabU8i2eEyduku0yyXvReLqbRHvogo83j9Hou/CwiIqe494PMWRYP49cbXm/g3p3GjBWK4ZxooLEcxIzQ91jtH3glPt9H+nlbxtdyFmUPHkr87f6AOzjTT6AHx3FXbhXbzifxKvH5rfqEtXd2lz+8Rlw5Qb9Mk+5njnOLY2aJhyNfhZYq9uUtCk1JLNFt46XM6TmKLxauG4PAe+itf54/3wALChVjk2xRlZiT9+wopQyvGOa6Z230cVEi8DcfYJvsvaQVGR2mr0GrzQX6KIphOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 03:56:59PM -0800, H. Peter Anvin wrote:
> On February 6, 2026 9:48:24 AM PST, Jens Remus <jremus@linux.ibm.com> wrote:
> >On 2/4/2026 1:49 AM, H. Peter Anvin wrote:
> >> On 2026-02-03 09:19, Jens Remus wrote:
> >>> -
> >>> +#if defined(__x86_64__) && defined(CONFIG_AS_SFRAME)
> >
> >My understanding is that you would like above changed to:
> >
> >#ifdef CONFIG_AS_SFRAME
> >
> >>> +	.cfi_sections .eh_frame, .debug_frame, .sframe
> >>> +#else
> >>>  	.cfi_sections .eh_frame, .debug_frame
> >>> +#endif
> >>>  
> >> 
> >> It would be better to:
> >> 
> >> #undef CONFIG_AS_SFRAME	/* i386 doesn't support .sframe */
> >> 
> >> in fake_32bit_build.h.
> >Due to (binutils 2.46 pre-release) GNU assembler supporting --gsframe-3,
> >but only for x86-64 not for x86-32 (nor x32) CONFIG_AS_SFRAME is enabled
> >even for my i386 cross build attempt.  This then wrongly causes the
> >.cfi_sections with .sframe to be selected (verified by adding an #error
> >for testing).
> >
> >IIUC the .cfi_sections is there to have DWARF in both .eh_frame and
> >.debug_frame.  For .sframe it basically has the same effect as
> >specifying the common assembler option --gsframe.  Given the more
> >specific option --gsframe-3 is explicitly specified I think it would
> >be better to drop the changes to both dwarf2.h and fake_32bit_build.h
> >and solely rely on --gsframe-3.
> >
> >Josh, Indu, do you agree?
> >
> >Thanks and rRegards,
> >Jens
> 
> Seems a lot cleaner to me, too, assuming it actually works.

+1

-- 
Josh

