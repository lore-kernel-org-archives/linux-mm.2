Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9801960703E3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jJ+YsSS1
Received: by kanga.kvack.org (Postfix)
	id B43006B05DF; Wed,  4 Nov 2026 12:57:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19F06B05E0; Wed,  4 Nov 2026 12:57:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FAF6B05E1; Wed,  4 Nov 2026 12:57:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC0C6B05DF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:57:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1480214076B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:57:03 +0000 (UTC)
X-FDA: 85398192726.19.79B8218
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4C00240004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:57:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJ+YsSS1;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793815021;
	b=qepQTaHRJWlJhwu1oZ8sAXLwiW4vY11wUD1JhDPWWYLcVpRUjKEyT1Pu4ZPMBWXQ4JSGOP
	An05SmS4yQCNVLdcLbQcf1goWPhC0KRN5+8oINOelL1K6DAvFZEQ/lQoBjZOJyjiMZ4T7w
	+CD5T4R4ZekciYXA/igWZSMrTHlwiYQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJ+YsSS1;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793815021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeQgphPdxdiWtw36JzKqWooMSgzPZU+EeD4NlyLVhDM=;
	b=x04kDlQl0VRrq2zshqypydsz6DTmRAcu4zG8vsJgeX7u59Fx49JMdTrC3LbSShAax/JD5f
	NGAQoF40/FUAnud+2xzcnbIAVjFW1buPMBXTp780QxbEgrBzBqEh/Soneler99OuIfIkc7
	6qCZolwnlXM97GYsGLrruU0DE0HWny8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 908A743A59;
	Wed,  4 Nov 2026 17:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0110B1F000C1;
	Wed,  4 Nov 2026 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793815020;
	bh=qeQgphPdxdiWtw36JzKqWooMSgzPZU+EeD4NlyLVhDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJ+YsSS1mKgXVutXvIprPjWbk/f3EaiHLkE0iUZZAD8UlGdeiTsq37AMjiJ1LQO42
	 s7IKloTcsbSWCr6Lc4020v768o++Pni3fgFkFO5tp1ySQmamfYyvOlYF89oN/AE0uz
	 cDBLCJtKpTc2bEc32o8AER5NNVvUQIyxG/58XGRNwW4UebnC4TzH2w4THg6Y4IuZEE
	 HY4QLlr1k8HjiamlPJYs4KZrW3+I6WmOXTXZ8NvkX2h2a4OGzF5wxpPCxFfmNGgkxC
	 TEjrpd9SN8JK0f/Vf8mgRK+nlmhJ6yDeGzIC6DtBcVm6ZCj3+6Kd0iuDWQx/Ae1YSo
	 KOmYuIt4jqdDw==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 39/51] powerpc/crash_dump: recover from a machine check in copy_oldmem_page()
Date: Wed,  4 Nov 2026 18:47:25 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-39-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2421; i=brauner@kernel.org; h=from:subject:message-id; bh=VIVKq8y+KdCJwnDd/z4L2OCrr1yqDfObdGoCOSjiCdM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znu/ZLFx05xpnp+TTtxLuaWnvKXR5q5SRcWM5RNFJ +7uuXKbraOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi0wIZ/nB7KCi471/L1Nq6 9n0/51Uea/Fd3qy9fnsOr1vwmcnr62yG/yWGkZU+VvatQgcYS97WRSfuKtivn95TcozLZv5XWWl eDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: adib1hq8tsg965jw1g8spc6e774ggkgk
X-Rspamd-Queue-Id: 4C00240004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793815021-296805
X-HE-Meta: U2FsdGVkX19d+2EH0Gsv0YaMBavp6cUCMxgxRv1EXZJwTVJPlNOi+uu9N3XJfyNBsSXU3JAwPfchi+Qq9U51iDfHveDHpbRFSRjlDnC0ff9tA/e013pj3v2Lw/GxzmLss0ZYti3qimE/g0DyF75D7pC056YHSILYQmPK2bOM1A3PtQDK0Z7g1El5DrwE7RjGpKyCZQwQqqkJPmXtLaAbztyGLlCe+9puH3/vZ5fAFfCvX5iUmr1JhVSbsHussMb/M6MkQNsHAB0O3baASBwavaCZSre0YuHnwohMt8hOE3YEuVuazGY2/T+SW5dtXrEpTYtOxYzK+qIYBsJ6f5Kn+qbsTT094XS9Oj154+3Nnd78R4bW6NYkyabkGTp60yX7g3QPDyZMVslyN+XjotRL4ATUX2weDPjBbPr6SuDyE0hXtMh2XsF4k4nSF8OsROxcL1ydqxvacOqqTqJLRfQaMqG3EJeFFepMS0fe67I9rf0rPVYlVOZf0ud8xZWkSSpAj+ijNKhe0H5Q4vlEyAVifAy+Yn3q9PGklUxG1dFyY6Rqg0cAfUwpvmp9923NwWzg03ZdnfuTJNvyqhztfEcRhS/zBLTeunkViOfV34nj9eVWIVDH6TVAbdSPxeTJj1zQWH3h/ipC/7YAZPLXUaxRxu3QP/YeAxwWEw0W6PB1pnPeV/yNxmmYFGhSlctBSimmFHwHYWghAn6wXM4pAmIBLH1kuH8ecDsXa5d0vM7eHhVo9VQ7V6fs7DD/C9+deRZEGn4xoybV/wLE3dOJ5fiF5tyMqGIgWsSvF1qHiuSSza5nBe7LnBN4Z51li+7IeTDrTQiyGNMY1Qvh3wgEpKfRuvQlAo7tX2DdQTc9POI62stjFxpNhKIXhvathsSf5b+6wSpR4kcyaU8Ln+r8pI6wqtDkeprX0QYOASnXdPS4JrnsElo3WPbaEHJ/Ef9qk0WdSwz3xrtwx5Fq6zT0RYL
 uqyWF+EF
 wl/JeMJaf2EzrRGdwHGwEuSaRue7tZiTHnqeCnznzE0mevMnV5iDpqj+GXtlwuyj+PJQVMD6EEvqt4M//2ceZZDt+JLKoFBqtXaKhFRsddBqczdrJSMmvLl32cXW9PJpTDAbmUIeCwYSTMNjnAkBcM1kR6CZBnagP+8KGRmkgYT+gGw5iDBc/kqoV2p+plK0SwnVr2VwdAAFWIJwMzsmGfYBfpiANNRTqTuVb8fcKUX4LMKMcMH7xSFmfkqeLrmgt2EYhs+Wv4s/RwvvFbUOAP8QEqyq5CYd0blABtjvxdNE4Tv2B9GP6egcIrHq6HyADwYL3UxNV3X10868=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A capture kernel reads the memory of the crashed kernel, and that memory
may well have uncorrectable errors. On powerpc a machine check in the
kernel is only recovered from if the instruction that took it has an
exception table entry (cf. mce_common_process_ue()). copy_oldmem_page()
copies with copy_to_iter(). For a read() of /proc/vmcore that is a user
copy, all of whose loads have exception table entries, so the machine
check turns into a short copy and read_from_oldmem() returns -EFAULT.

But since commit 4a22fd20379c ("vmcore: convert __read_vmcore to use an
iov_iter") /proc/vmcore can be spliced too, and splice(), sendfile()
and copy_file_range() copy into kernel pages with memcpy(), which has
no exception table entries. A machine check there panics the capture
kernel. The same goes for the reads of the ELF headers and notes that
vmcore does itself, and those have been memcpy() for as long as
copy_oldmem_page() has had its kernel buffer branch, since commit
54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page").

Copy with _copy_mc_to_iter() instead. PPC64 selects ARCH_HAS_COPY_MC
and there it uses copy_mc_generic() for kernel and user destinations
alike, which has the exception table entries. Everywhere else it is
_copy_to_iter().

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page")
Fixes: 4a22fd20379c ("vmcore: convert __read_vmcore to use an iov_iter")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/crash_dump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index 1543917bd3e1..ca7e019ae3e9 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -83,12 +83,12 @@ ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
 
 	if (memblock_is_region_memory(paddr, csize)) {
 		vaddr = __va(paddr);
-		csize = copy_to_iter(vaddr + offset, csize, iter);
+		csize = _copy_mc_to_iter(vaddr + offset, csize, iter);
 	} else {
 		vaddr = ioremap_cache(paddr, PAGE_SIZE);
 		if (!vaddr)
 			return -ENOMEM;
-		csize = copy_to_iter(vaddr + offset, csize, iter);
+		csize = _copy_mc_to_iter(vaddr + offset, csize, iter);
 		iounmap(vaddr);
 	}
 

-- 
2.53.0


