Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39D6606A882
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=R5XxGFbM
Received: by kanga.kvack.org (Postfix)
	id AF2B86B05B5; Wed, 11 Nov 2026 06:59:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3466B05B6; Wed, 11 Nov 2026 06:59:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992536B05B7; Wed, 11 Nov 2026 06:59:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 663F66B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:59:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3111C0286
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:59:20 +0000 (UTC)
X-FDA: 85422692880.09.2A0987A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id 47BCC20003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:59:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=R5XxGFbM;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794398359;
	b=6DpfDFoBL0eAmcTDwZ0+FXIhEpkogl5vpGKmo8XvRPHRG/BhSUaLkeXWgz30gcd01wr6vy
	NGFVisHmX+zeZxamVVqqrnyeIFzbf1T5ERulEAH3c9DacriesuBhSeTDv3GRRtqQl+5QJl
	XEl15yRyykFTGFTVKbBTQIQ4DqaWmj8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=R5XxGFbM;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794398359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+DIIko/jddTALojzUdCwqYFD7qAVSieeB13vaTbTZ4=;
	b=rujLtNV+mdlN07XGACN0F+NvDPZfvkBmpRtouRUqIbF+JwBc1bppXnJ9qPEEUtQ/KPf+My
	TtwCfHIgXY0Z8FdidpzawFyDYsidUOEDnFBhWb1I7NPgQLp5ZWEdFSDcO5TCnn8QhCNXop
	hWSsZL0eDUZFMO3SS8YsAZqQcUKP4Sc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6+DIIko/jddTALojzUdCwqYFD7qAVSieeB13vaTbTZ4=; b=R5XxGFbM6TZRqhT0SXxuzcMt1x
	LUNRh7V8lAnKwChToktKXZ/BvtFiWDBfAUJ9dLKtb2UHW2064KOlAZ6KUeSJJgWg/hPASfykHm9lb
	dvvgSD9ejQiiI+LIrAd6gbPGs/9xZWqr0yWBdHoCClUgJD2Bg1YMupaoC/QOZRmfVPSCT6MpDMhbS
	246KM0GzqcBbc4E2580QxhluNnyoa2vW19Sk2kqFlCkeQ6ViS/yest6rZWy5lPKlR+T/Ay7hDfWGq
	IJLMSEFD0EmRJ6D4dVOiq+0BkJb7lfNarlib+MyMxjNYvepLWzR3xSOakoCQkMgy3TimUB70/p52t
	iE2dAMXA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xR6yh-00DAF9-2o;
	Wed, 11 Nov 2026 11:59:00 +0000
Date: Wed, 11 Nov 2026 03:58:49 -0800
From: Breno Leitao <leitao@debian.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	netdev@vger.kernel.org, ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND v2 39/51] powerpc/crash_dump: recover from a
 machine check in copy_oldmem_page()
Message-ID: <avRXzzCSzT9Qj2FC@gmail.com>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-39-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-39-021c84d852e0@kernel.org>
X-Debian-User: leitao
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 47BCC20003
X-Stat-Signature: hbcgemkzsk95rbwepd9uux46o1f87omw
X-Rspam-User: 
X-HE-Tag: 1794398359-828112
X-HE-Meta: U2FsdGVkX18+otGroU7a4FWHJ1puQhJ/hgk+vkcHWHqbD+m4cg/7zxWKuhKJ/b03GUl1rFZ6XExAe1tNOUiamKQgDQzw7QgvqqG8ZS3X+sqZhDkvdAORfVs4DlgFjY3wSCK/8vYzXsUEv9rkVjLUU1Y4oYfDo1CWz8XpXJ44YjhNSGH59WmX/Dfdlf6t1BUutFYJtLJu4xuGB2ihInsqmCQRR3ZeI5QWEBX4SOVhOGTrY8bToAg1K429jtOL2mDjGn2WbMuIKjilaTmGYxUmt/lua7AU6XJLCseWrBYVJ6zJ9+xYA0xcHfOb5aUe3OcyyskV0Wifu7M+/mWL0N3yMYt9xmLw6oimazBUAPPNu5kcRz0nO0pBnFtkZtxn4vJa61BxS8kRi0OOpyHxcvp0EUhxCJBMtSopxfFUl/4wac+G4bmkITx0pMWXN225/ql81Ih82M8Yhbt1yQI2na6Z3UeHsyyiMUXNDiXkVcDja11FpS/mxCVEL90aqALNjRLPeEbL00iYJr1aN3D0Aa/ugU3nWnR2ThdP8yusScZYIDTGWGTCqCkcp4/lEQfFL1siDSf2jrDfitFCSNyzunyQyzG5cmiAdnKgYf4U06K8QbdGZv9SIakEqyIU10BdRkRDGnC3ELVjLysqXobl5OxmzZib9AmADA8RWzu+tJtKwQwZSP3ShnlSMSS9zEpjx4WpLBA8U7DN2aL/9bzzoWlrshGFNbyLWgHzE0ypChx+u9IW4TpLQn8lSw7XkWYz5Cy09p+1U9WrCmd6FeFXGkMYRAuPBuff/UhGh6yW/Z72Qf3OYr8hBt8BRGN2QPAkPN1LlqjelAYqsTxHfY2Tgxw/AeOL+h3SV63T0FSEd5+HkGK7xVcKZbCO+uweazWzhBqFzJii2c1OfH9zj3sAkmPnOxBySi79F7nHsj3TrBjfAmwtM+QjJb/gEjlzGxZvDbdO60J1yurafRFxxc8059D
 0cvhoeIf
 KcESmjvJ7qesl0YGNtgV2+h8SGbTBnloy9xhgrfpoNKcGogJpgxSgvOv76lb1khwFMgQK8qSIuZsCwlRY1Tb6g5hE+0PuXeB9+Xau90iROed9WMGTvsgmXvoM+X6pw4aLdb8i92/40i/1Dad2JPeywh5cVDHO31K3NkLFC+mGt3cQauo7viHKr4glkP/IyTkL2DfExfvdbe/9mBbokqwwbhNExfHOhLoSNGP88SvAAjFYm5ICyREe3x8n70EspGJM3LJT6kPCL6n53+fPJft66r5FDOd5rCCtvuarz5DVYhiOTMS2ks54mgqXARWX8CrgeMCq3rHUTLil7Iy6sZWChrIJ250kKZGHtzLrstKYKyAsDdaVoM2EKNtIdeZJnt6orMfp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 08:25:32PM +0100, Christian Brauner wrote:
> A capture kernel reads the memory of the crashed kernel, and that memory
> may well have uncorrectable errors. On powerpc a machine check in the
> kernel is only recovered from if the instruction that took it has an
> exception table entry (cf. mce_common_process_ue()). copy_oldmem_page()
> copies with copy_to_iter(). For a read() of /proc/vmcore that is a user
> copy, all of whose loads have exception table entries, so the machine
> check turns into a short copy and read_from_oldmem() returns -EFAULT.
> 
> But since commit 4a22fd20379c ("vmcore: convert __read_vmcore to use an
> iov_iter") /proc/vmcore can be spliced too, and splice(), sendfile()
> and copy_file_range() copy into kernel pages with memcpy(), which has
> no exception table entries. A machine check there panics the capture
> kernel. The same goes for the reads of the ELF headers and notes that
> vmcore does itself, and those have been memcpy() for as long as
> copy_oldmem_page() has had its kernel buffer branch, since commit
> 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page").
> 
> Copy with _copy_mc_to_iter() instead. PPC64 selects ARCH_HAS_COPY_MC
> and there it uses copy_mc_generic() for kernel and user destinations
> alike, which has the exception table entries. Everywhere else it is
> _copy_to_iter().
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page")
> Fixes: 4a22fd20379c ("vmcore: convert __read_vmcore to use an iov_iter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Breno Leitao <leitao@debian.org>

The change is the right direction, and x86_64 has the same gap.

arch/x86/kernel/crash_dump_64.c:__copy_oldmem_page() copies with
copy_to_iter(), the same as the powerpc code this patch changes. x86_64
selects ARCH_HAS_COPY_MC, and _copy_mc_to_iter() is already available,
with the _copy_to_iter() fallback in include/linux/uio.h for arches
without it. The plain and encrypted paths share __copy_oldmem_page(), so
one conversion there covers both.

PS: I found this because I am looking at x856 production fleet  kdump
success rate , where first kernel died of an MCE very often produce no
usable vmcore at all, and makedumpfile never finishes due to this type
of problem.

