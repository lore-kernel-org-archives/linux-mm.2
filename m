Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAED7CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9FCB6B0088; Mon, 11 May 2026 14:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50B16B008C; Mon, 11 May 2026 14:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66396B0092; Mon, 11 May 2026 14:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B587A6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:45:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F90F120245
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:45:42 +0000 (UTC)
X-FDA: 84756017724.26.34A50C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CA95018000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:45:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gD5uFrrl;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778525140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQ/lKYyflvZSNBqlP/dvjAr1/tprgH6SH+5pfzheVMA=;
	b=RX8BuH783XEiTie+FAWl0/XMyhzy1clFxkjWvUftqej5KepN+Oh3fv37I/L1Er+ShbfMdx
	oiTu8DQ0+S+yN3zZ5OF7TRk4xnoWyi0Cj4G43o4ZPEYPwJjSO+ZbYZXteuyqIUeum6ADtV
	J+DizI/FPTMKbHZX61qMvv95yqttA8U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778525140; a=rsa-sha256;
	cv=none;
	b=bhYkoL4vFlyR3Cc6bVJaoXl16QUp6DuFx9x2AyTjYu0K1qe+7KRqF8o4UpEjp514nU56t8
	GglBYstwwGOSMpUhTgBEsmoE8Ziv33VtQwu6r/Qm7JEIuJIuzQDwZs7fzDfhXCgkTSegvR
	sMf+b9fiuQqpC3RzqjwQ1vJ3oz5ARc4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gD5uFrrl;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F028600CB;
	Mon, 11 May 2026 18:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFBEC2BCB0;
	Mon, 11 May 2026 18:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778525140;
	bh=TwOfOoVHvAk5+BCmHU/0l16HBggiVxIlTk/wO3uefzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gD5uFrrlE+wG2vwML+Aua/biLzAAyLJ+t6tbI+rhZSnVTjogUz6PrsXYzBDuv04SE
	 5UossI/jUrt1BWF56+0ts/0MbUWbyhisN9TyfCmJ1yDkACDU33yNP81cnVfETNey5h
	 0P68FO0RXg4OZxf2Pt+hfo0cdCjBMwJbrdOEd3Pdl3PRLkTmcYaqHGBxXGM1vY4PSS
	 2qvPgHjG3FGAWF/6ZLxS2SoQBF9+nqr4cWLDQUhYH6dRDjnMxv/hnqfMec5S8pNKfa
	 4cWUtMHZ2B4dAzEHpMKQC27h9YzXrLWXzskKQEkFDNph7Ozt4lOUU0MxDlojcCKrDp
	 FduI08HJYAMQg==
Date: Mon, 11 May 2026 11:45:39 -0700
From: Kees Cook <kees@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Liz Prucka <lizprucka@google.com>,
	Seth Jenkins <sethjenkins@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
Message-ID: <202605111144.349EF737E@keescook>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
 <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA95018000C
X-Stat-Signature: bj3u4paq8isa3pikz45d8rnx9z1pb9jr
X-Rspam-User: 
X-HE-Tag: 1778525140-175594
X-HE-Meta: U2FsdGVkX1/c47G296ta3Dxm3kc4Fd71PkX3hmbuFdsfNxSWxswMElfAN96r0weUqyVsMuDruOPCjNFe0NvFi4EDx0Mnnlz2ivK4+1GlPbxDLeigb5WB3MQNa9rWmObBhxG9Sbf5TAljKntOELAKjDWDdIYL/q+HcarmQUmNswhNcatZPISLrdpehONj9a0nc66fb3uNQZrokofnmHS8SJdJqC9QfGn9opjphuVFqN7rOKgi4xETdzcMzyblcoZstnnydl4Gnc9l0bbqBR7w2XQ5T5sPQPbk3RGc1/TirupV1pmnsx8W1FkBcHVFA0KBePG/XiGlHueJ9+N6fNTV0n1RHIpNwEcHQXL3T5qyAybVc8XnvY0QustCCvuTkbywbDpUKIjW9iphMBdWPCjgwt7K19jCJ66gFyHPkU4+KJIvoqEbKU6CEfhCEoAYYiG76gbt5zGejajPTmkhRTETXLSVFvgjR+YDDsRV2YRZYk3ocv7fcE3gA9wRm0oCvmiH53jGRrHMmqHpghqMTfHod2J+DFZk312udSROJD9BpZ9Zb+nMrIb/HHD0pMdvbDTS70t2V/jhrstWsc7YUCVVnfE3++VRP+mYq9gtD97CjK+DSdanCMe7LGSCNVVh3a0idLDOBtp9UUc1HWZmHOUEPsivytouW6B8RHX0d+g3VU7GOe82hni4DMJVGqca/PaX7gbV9uDN4uhozSDZG93CLIjaK8FBDEZXygSKVhkYs7LlwbkaS9YaTX+HiZZ+TYFSbGBitnFdikE9Dbn/ICbVHNIRmCNBimnRgLunIPhgjtySnk8juLqDyoO/0DI051x1fCXrp+cd8toFAyMVc/T7SmFCjhma421oBp+gQMLb4A1L91O2VGEg+ChVGLOedqKBw5zM/PMlRRtdx3/TCrOxMOW45U8wc7ojOO22cHmQ9BquTDfOWhFpgUPie6ibgBA20qnJX/zW8Q48Ul6vLcZ
 V19PRTJq
 H6fDjA+x8n7nhTM+khrZKn+3MMGkK1BANGUebyf6faeAXn37q2LQybc2TXu+OEFjQlIpewOiNGvNEtEcpT+p4sg36q/f/XuKR0YtnzADgFwWAcpxotzGs9SogkpopV9s7TS6OB0cbvnVbGPG81cGaOhVdGrZkNjtg7WYSppIWOl3yLWyEhwC+d1OaDsftX4tKq8bMTvh4C5iIruQJGp53XO1iBYvVwnWgQ4lsLIlCYx9MAbCWjLINdbHTopiams2HJY0XHNNWPeie0WyYtylV1aLFcEOKigfLHF0jX75kdFZknfHqDylQreBsfuVMmwJ//pB2Qv0j4atLaCPcgFqmKwdzNe9Ybe/XUXfHK9mS88LVIcDjlkZxccROaeGq/AdmEkHX9kbcbTI6sAxXh2cmzT1rYC/W7TshE2vea8SPt+CAqdjq1D4J2/GErYitIyHNE6Cv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 07:02:51PM +0200, Jann Horn wrote:
> On Mon, Apr 27, 2026 at 5:44 PM Ard Biesheuvel <ardb+git@google.com> wrote:
> > The empty zero page is used to back any kernel or user space mapping
> > that is supposed to remain cleared, and so the page itself is never
> > supposed to be modified.
> >
> > So make it __ro_after_init rather than __page_aligned_bss: on most
> > architectures, this ensures that both the kernel's mapping of it and any
> > aliases that are accessible via the kernel direct (linear) map are
> > mapped read-only, and cannot be used (inadvertently or maliciously) to
> > corrupt the contents of the zero page.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> 
> Reviewed-by: Jann Horn <jannh@google.com>
> 
> Sorry, I should have looked at this properly earlier instead of ending
> up duplicating this patch with
> <https://lore.kernel.org/all/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/>.

As you mention in your testing of the patch, could we add an LKDTM test
that does the same to catch any regressions?

-- 
Kees Cook

