Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ECEECD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31886B0096; Mon, 25 May 2026 08:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5D16B0099; Mon, 25 May 2026 08:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44676B009B; Mon, 25 May 2026 08:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC54B6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:28:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7390D1619B6
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:32 +0000 (UTC)
X-FDA: 84805870464.08.2D0836C
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7A4A916000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k 2NKuUR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=IzSjLCgC;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779712110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZ42hooG9YxjgaN4BxNNdCHXBV/6AiQqjefEQ2hTKfI=;
	b=QDcsMbIeizcj5qmbTwVNUyX5CrVd5tKlaNAqNFMORTPDFP43v/iRww2la+yoGk0g2xBmXX
	bOqHQMyZieeEv1Yeu1KHcAezRmW4w1XIwjj7GDH7ac61NcgAQsTHoy13mPFog9MlJix15a
	CI4IrrJVq0Yckn4GZ+N48m3+TsFFhQ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k 2NKuUR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=IzSjLCgC;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779712110; a=rsa-sha256;
	cv=none;
	b=1Tj9Y4895WtigzesksOdTMa3dC9T7XRxVEMnnRIKlC0h3gJBJHsPJJbWkfuAHrYNPqYC+M
	iHKHI7COUjihurtj16bdVGDhuZmkRtRAwSIV7VmgUqloyFwy41d7xMEG11TJBHNJ2X08ob
	wWc7zpryHloGUv2RME97nN9WoqBONyk=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id AFD271D000FB;
	Mon, 25 May 2026 08:28:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 25 May 2026 08:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779712109; x=
	1779798509; bh=bZ42hooG9YxjgaN4BxNNdCHXBV/6AiQqjefEQ2hTKfI=; b=k
	2NKuURzASvI5SUPfIgWHkwRJKr+ZP5Pl03FUueq8yPzLujDJz75cxI3URuOlnHrf
	OPy1yRqSQzkpoq2NS7zYZYNzoeERlX7/Jro/Nd1Ojj6qAixXb7T2bkEycuIMTIu0
	6IYxbkRhlrNGinXhj0nVBBXsB1YlL2h54t+pWECdrXL7CrCrphenWor3tnbx7JSE
	OeRtGmsT9t9ES6yNU9Io+IE7Y3/Nf1Wg3k+0T2PgZkdfBkE8m/d24e/jaKtLhhJH
	L7IXeddjYy0dt9o0DqVoKG5LSBG6TklHqRkrohyBo5EELr1GezyMXO4sDAv7DdJQ
	iXlgnAAuc6Kg5S5yOZDFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779712109; x=1779798509; bh=b
	Z42hooG9YxjgaN4BxNNdCHXBV/6AiQqjefEQ2hTKfI=; b=IzSjLCgCoKDKeIFSZ
	8054G3VExM/972NoW1P7tsiPA4eez24luxCj5qUi2wx2tXBoq4hpIRL6isv/hr+6
	IJgUs/kH8DMG6H/NIeZs0cKNd4HtZe+DRBfAv/7F2/yTVfqq73bEEFrExcuYIP7R
	qzUq7QlDqUTOFonI38XXPISTvVn28Cxl7ekCH1rv56P810DhetZGM18Qg+EOvnVl
	YrYSZgwti1a0cgBvZx6dvu3uzSAltnNLy5rRzXtNfkqf9B64Y1eWwOdpacuV/Qzm
	5HykfqpeJGtuW4tzJiPijkWDo2trZ3wLmiS59uPN72MG6jKZR2YvCUHbyzJOgciZ
	6ctGA==
X-ME-Sender: <xms:bUAUasGyG37UCZYGt15sEyNAdD49XfLRivXbOI9IKmCpNNnaKULOcg>
    <xme:bUAUah5pHDR5VLrR-vXElSV8iFS-S5WzVvnzYLm4IHjypfPJ-Qql80hNacNOvkwM6
    shGm-43a_xB3dyN-g0KdhJ6P0XwgsyvfecuPripZCaPA-Ki_XGnbQ>
X-ME-Received: <xmr:bUAUaqnu1xUmLg2WSGf4S3t8bgNtcTVflFUvr2Ba6IjYPkagnw309uBxYYOzww>
X-ME-Proxy-Cause: dmFkZTFmLVSfYhEWaVm8N1lz0MjOBghKLhOnNQasw0tsXAFLPpbR/4+mrCYwWk/E423Vc2
    6B1s9iPuQgs3hGAiq/KhPqohuBMRIerNkWvsfuc3WkOHbHUNY5UmaGor5ig336hIeD+vak
    qB6bs2DTG0sfepDSzSArpLeFa7+n1qOspSUGgNQVB9KbSSFSgvHhLwD2o5NL2Su7Xc1htX
    UOwFpxHBdUGOki2ZYo2cYxe64jTF4NfawVkw4Ja9Vghy7E0XBO4BxqVYRhKiY6uJ4G3d/o
    hkvinoVmY3c44Mzh6S5sf4JfJ6aY+LIcesX0uapyNnoENtY2BlNnzIGDNJPpi4n9s/a/tn
    oLpYvXmD0Kbv8qg7zxheJnwp0M9eF6AsNnmI/VWks2T8m3ySv6QZuWgJP+w0LeN8ncY2qm
    wDJMsHrts7imN6U9A0/nPLq6pTjtvEkrSDdnBSM5N5cDg3wbbBZbonG0av9a6MTWfX2IeC
    F5wD8UMc9wU7PIQZaY31eHQTIxFZE1cES63ytYLFUoK2thuBbl1xRrKzRvailQKkx/lJWr
    7fO0Vjf1cEkBfCAufTmQUnu5+4sZGfiwxHpSus6Ir5aOsbmNaCbBOmxiQSiTG31nxd7+Au
    ZY+8UQhNh8MjApqGlEoMTw46YJ/tmGmUV5t4NEuYQDL8j9bv7NR5LYl/334Q
X-ME-Proxy: <xmx:bUAUak51nQ_PpGm5QmNmLwT8fxVW80eH9O6Q-WDgRU1xiTqP5_LteA>
    <xmx:bUAUajTedEE-lKQHfnKgX01ec1nWmKIb7ff7VcaeOqOKLbryNs5kCg>
    <xmx:bUAUaqzLV6dakCygYy6QSpWGMADwZ7Hz7jH1vstxQbNjUQNcbM88QA>
    <xmx:bUAUajqprp_XlZXdtn6nBR9RnKZjelftDDVrMVx0RvU3fzsW15DMHw>
    <xmx:bUAUakQ1jjGvIt8KoHsku49t_WVZUBioPgU8tsRG6Cra6HU3renCLUrJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 08:28:29 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: alx@kernel.org
Cc: linux-man@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	kernel-team@meta.com,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH man-pages v1 2/6] UFFDIO_RWPROTECT.2const: New page
Date: Mon, 25 May 2026 13:28:12 +0100
Message-ID: <20260525122816.1956804-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525122816.1956804-1-kirill@shutemov.name>
References: <20260525122816.1956804-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ndqjq6e8ppenuexiubm4ariqkjhqkx9b
X-Rspamd-Queue-Id: 7A4A916000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779712110-601926
X-HE-Meta: U2FsdGVkX1+sszaFnTBW1n/JIx+4IYEl7AbKWSYSPKfIDiidoQBMkK6Mo8pRP0j9gM7txNS9AZ5MeTh251dFnwenhXwgjik3RkOu50zRmS/ViNyoV6q5NqdccQ59N/yVOS9HzxMlKRwbrEOzKmj2PvaHj9hO15nwLJrd4BKfeVbdnFIHBF+lC3AvOme8Grmeo/D1uOM+0e3uXCK2iEr0doXpxJi3rwqDVzDbEH8D9bjkowwnxnQp2p3ILhyV7xOO7rUBnL6vG63iCtftu0U9522BN0YHkS8V3cybCYiRfilzWY+cMURur8pVTHPGkE4cBgJBTvRYd/erpSZBVkP/j9Mi7cvgH9coKGfwFC4z1Iqs7KX8LbbdyLrW1xHbg7hzvDsfnAzqzl89tYbCOvhv7T+jIY4u05cJ0K4ZFXMO4aa4cC80ArK7iaDRM1lSKeo7VMqaqoV6dfr8M6or3HLJgO7sRaA16RpQwQ8bHgAuJ0vPhbASzH3xvlAQdDRlmiTTXX+iDVl5wX9KFWMT2eqwZlAhcdEqBXa3mvVrNPIPLMIx4PrVHWC+/HauLzoQMLBQi37N+3LuHRKF+91guTxeji6HKxjfTLj+7ZYI4fg+SOStN0QjapcMQvvdqiY1vza+TQeZExdCVpFQbyh/dPjoHguQaf2OdHd/2jCAqyQ1kxaifssXjKPPIxOMoY0/kb/Qb97b2YaH+g9sh491RGUXnDlo50G9WFLYfBork9AZ5wI9d31O5T7elgNayb6UzAg6zBDsmETZ0pFQHmW1obpTYNk5rVD0VpYaH/IhcnR1niBd058ElKW2vGoy7DHgQ0Y/ayopjlroxqH5g3SkYTEnyb6k+rMidr5eERdj1LoqamO81gOG3PDyN9ahfgqeWG2PiukYT+qim5jcmnug2QgMXlORphsNQt/H4xc24p9nhZlfXGVLHn2i0vFY8LOAXwawNNSf457FryCIImKs4cw
 AkaowZzO
 qRMx/F10QclDF/BrreNQgUetUEzOOssVvPJXG4WjExU50LF64+HnkgA2dRWAEHi2IdW7orUDbvkw8nc3GJP52fxpKlIatV22dlxsSPnqcDTrYh9Gine9fE7kEMsdlLkf2pgYMLPd3wfHcZ/HUprv0C9wZaGF7dRgTAcS4RDxZSGegLd0p+xT15CiUStIKU4Z2mFKq6kBSHFWWkRWTQDqFfL60Hj+f2zmPQfB8iABI+ODWbhBP9CE8eJ1z0++b+i1xhv8Q7mpp8ACMY/nkuFoI815n77b+l2ygdUECNwRB9sMY/UyIiIWZYApXnvs4juk9kJRhUCTFEBSroZqlj9iZwpBWJnawESbkt3qYH4baT7AxTUaAm0UlB3x9BaiBHGkjbR+Hyorb1gvXJJGOcoWFSHuyIQIHTAuhZf2XHBcmJTqcW+ZvZ/6cY6U3Quj1v1Dmk5mbG2xYEvCDWkCc8qRs/Ylidja73bW+T3Pry8SBpa2EVS4xWRBAVAAuxtpI7fNhQpRQCp17sezvAIdVzcBcgJGzCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the UFFDIO_RWPROTECT ioctl (since Linux 7.2). It installs or
removes read-write protection on a range that was registered with
UFFDIO_REGISTER_MODE_RWP, and is also how a handler resolves an
UFFD_PAGEFAULT_FLAG_RWP notification.

Cover the two mode bits (UFFDIO_RWPROTECT_MODE_RWP and
UFFDIO_RWPROTECT_MODE_DONTWAKE, mutually exclusive), the populated-
pages-only semantics, the anon vs file-backed reclaim behaviour, the
explicit-drop list (MADV_DONTNEED, hole-punch, truncation), and the
EINVAL/EAGAIN/ENOENT/EFAULT errors returned by the kernel.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 man/man2const/UFFDIO_RWPROTECT.2const | 117 ++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100644 man/man2const/UFFDIO_RWPROTECT.2const

diff --git a/man/man2const/UFFDIO_RWPROTECT.2const b/man/man2const/UFFDIO_RWPROTECT.2const
new file mode 100644
index 000000000000..4ebe0a8648f3
--- /dev/null
+++ b/man/man2const/UFFDIO_RWPROTECT.2const
@@ -0,0 +1,117 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH UFFDIO_RWPROTECT 2const (date) "Linux man-pages (unreleased)"
+.SH NAME
+UFFDIO_RWPROTECT
+\-
+read-write-protect or un-protect a userfaultfd-registered memory range
+.SH LIBRARY
+Standard C library
+.RI ( libc ,\~ \-lc )
+.SH SYNOPSIS
+.nf
+.BR "#include <linux/userfaultfd.h>" "  /* Definition of " UFFD* " constants */"
+.B #include <sys/ioctl.h>
+.P
+.BI "int ioctl(int " fd ", UFFDIO_RWPROTECT, struct uffdio_rwprotect *" argp );
+.P
+.B #include <linux/userfaultfd.h>
+.P
+.fi
+.EX
+.B struct uffdio_rwprotect {
+.BR "    struct uffdio_range  range;" "  /* Range to change RWP on */"
+.BR "    __u64                mode;" "   /* Mode flags */"
+.B };
+.EE
+.SH DESCRIPTION
+Read-write-protect or un-protect a userfaultfd-registered memory range
+registered with mode
+.BR UFFDIO_REGISTER_MODE_RWP .
+.P
+The following mode bits are supported:
+.TP
+.B UFFDIO_RWPROTECT_MODE_RWP
+When this mode bit is set,
+the ioctl installs read-write protection on every present page in the
+range specified by
+.IR range .
+Otherwise the ioctl removes read-write protection from the range, which
+is also how a faulted handler resolves an
+.B UFFD_PAGEFAULT_FLAG_RWP
+notification.
+.TP
+.B UFFDIO_RWPROTECT_MODE_DONTWAKE
+When this mode bit is set,
+do not wake up any thread that waits for page-fault resolution after
+the operation.
+This can be specified only if
+.B UFFDIO_RWPROTECT_MODE_RWP
+is not specified.
+.P
+Read-write protection only affects pages that are currently populated
+in the range; unmapped addresses are left untouched.
+For anonymous mappings, protection is preserved across page reclaim
+(the marker rides on the swap entry) and migration.
+For shmem and file-backed mappings, protection is dropped when the
+backing page is reclaimed.
+Callers must also re-arm a range with
+.B UFFDIO_RWPROTECT
+after any operation that explicitly drops the underlying page
+.RB ( "MADV_DONTNEED " "on anonymous memory, hole-punch on shmem,"
+truncation of a file mapping).
+.SH RETURN VALUE
+On success,
+0 is returned.
+On error, \-1 is returned and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.TP
+.B EINVAL
+The
+.I start
+or the
+.I len
+field of the
+.I uffdio_range
+structure was not a multiple of the system page size;
+or
+.I len
+was zero;
+or the specified range was otherwise invalid;
+or an invalid mode bit was specified;
+or
+.B UFFDIO_RWPROTECT_MODE_DONTWAKE
+was specified together with
+.BR UFFDIO_RWPROTECT_MODE_RWP .
+.TP
+.B EAGAIN
+The process was interrupted;
+retry this call.
+.TP
+.B ENOENT
+The range specified in
+.I range
+is not valid.
+For example, the virtual address does not exist,
+or part of the range is not registered with
+.BR UFFDIO_REGISTER_MODE_RWP .
+.TP
+.B EFAULT
+Encountered a generic fault during processing.
+.SH STANDARDS
+Linux.
+.SH HISTORY
+Linux 7.2.
+.SH EXAMPLES
+See
+.BR userfaultfd (2).
+.SH SEE ALSO
+.BR ioctl (2),
+.BR ioctl_userfaultfd (2),
+.BR userfaultfd (2)
+.P
+.I linux.git/\:Documentation/\:admin\-guide/\:mm/\:userfaultfd.rst
-- 
2.54.0


