Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F411CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4306B00D7; Tue, 26 May 2026 09:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A47B6B00D9; Tue, 26 May 2026 09:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7D06B00DA; Tue, 26 May 2026 09:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCCEB6B00D7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:42:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65B58A01AC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:12 +0000 (UTC)
X-FDA: 84809684904.06.80809FA
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf25.hostedemail.com (Postfix) with ESMTP id 86064A0011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="V MqmjAY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=W69Qr6Ko;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73N6vexTHGilGLYWVcdfvVVX3SK7Uz3VpE0ARvS/d2U=;
	b=rUhAsdGwcIC7AiWt3uAVNq0fjJLufbSEqmQy7xGh4uvHu+zuz/4CM8lPbFnoL/nEWWDazM
	8m7S6TvyI0pishd68rzI4uIf3nmX3qSxUy8QK42Qtg7P3vjMOLfv5vGz5PyTofFvlmMM2O
	CA85q2aTG+6B6QFXb6xkGPs+1TlYoOA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="V MqmjAY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=W69Qr6Ko;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802930; a=rsa-sha256;
	cv=none;
	b=etK2lNj+bMYpskUm9vJvHXGhZsje+9vwOFZTuy78iqw9Gxa1DpLIXoPlwm27A2qu0GKuLn
	xeAAg/lNK8QcMJwVssYL91JQOEmbZlDXJ8teBcZP590s885wq5FIOJtA4N+piu0vDDI2wF
	eU7nyN4eVRBYEZId19mJXCL2fkfjBjo=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 677FD7A019A;
	Tue, 26 May 2026 09:42:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 26 May 2026 09:42:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779802929; x=
	1779889329; bh=73N6vexTHGilGLYWVcdfvVVX3SK7Uz3VpE0ARvS/d2U=; b=V
	MqmjAY/ms0J8FObkTcmawJpgURVTkufqZx0rw2sOeLtiJcqTnzvRCFz5Jem5ZvHG
	llux0JT6bGMFlkBxOpueuXra4DlQcGIIOcDBnXmhNROt4UNrgjC64W4X2xULwTvg
	4IEhKP381lbg8uPiUx7PUG4Xpltd4nUDCwgRhi1pPWNx2m86gbWkaF/CGYrxxqPC
	Vo6ZEsjwEM/IR6wJmpzSaYo9kZQBDQTK1ZAE6f9fTy7x6B7MIxIIpRIYFfrv7rCH
	Lr9PJMXG5tL1vzRDCJNR0FqeYeCiY8Spn0UUC6T7cZSSDytxv1BR8MpwSUV6O9uJ
	KjSFVolfkn91F7lGwP7Gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779802929; x=1779889329; bh=7
	3N6vexTHGilGLYWVcdfvVVX3SK7Uz3VpE0ARvS/d2U=; b=W69Qr6Ko3fWwhmlwD
	da0wfLlk7SZd+dNFMRp/atBWpXdQbgCFd+A1Qb8uSq7l/gqKPxIE82GnrJ7dw3bu
	zCikejrstHHyOd/0nvpzVUez59a/3SVY/5Z+yBLfd5BrtaY3dsMapoIp82SiEyuA
	Wyi0tgH/QgL818uy9QTsHWE2u2/AjPDXwN5AIlvY5bjue8vzSgY2sj6Z2G0UYBVq
	8bTvbb9VxKyBFYQx+vlueWyyOfF3O1E3l8n9rpjU1aWECHADBDicjEkJdODX8r8T
	JlSCPoX+f7TSff/rArF9zYX0V2bj3ZPMLTWLODzfYucPYShVjfrRcVxbocRU7nR5
	7MejA==
X-ME-Sender: <xms:MaMVaj85hkflsAlHWlKnT-zeRZBEDIJq-FrMfBxPrijbPdqIMSIXAA>
    <xme:MaMVasTgdOsoS9516xpPyu8sfNhFM8UjyTqqKR9Vxk_r8nEZAwG3FwUWjWIrHHvwi
    00ubiKnhlBHU49WJBa3-nn_PV1j-fsbZKty2lYzcpPVwM0K_20RBrX_>
X-ME-Received: <xmr:MaMValcECuPcDfkcGVGox_uNbdp8CbjwILz5t7XYA0sx_Jgw4YB9X6Qr_VxiLg>
X-ME-Proxy-Cause: dmFkZTFxd05FKSwjYK98sxjZfnEaguNgmbkO96E9/sUnrZGjGgye4wZmt/Ic6rtJdcHZIW
    3//FyXDnAPZWcDl/2m+5C5IsDZPk+GLuu2B8rI+uRVdcLjBSQaOOZLOa+wj1oQtkVV8Bhp
    WtmpanqdGSitjyrzT2b6Pkutw5p5iBbq4Ria8BSGQgx/cneWSFK1H5BjkBZc7xkAcAMQ+/
    Rv2g5eDEYnTPqdUCqfDdBxWdlbC/8jofdT6MpQF8/jX84rElnpbBbagNC4dRH4Bg8YdXPs
    U1r7XWojbr+m14NCpvSu3BQS5JVzG4ZMz6Z/lJcP/h1EeFr3j6rrld2ilI9JN6jONfrTWY
    h5jgG57OvSsTJP98VgzxiR6A/Ti6GNrLzj3ZUiU3HTYoghpckaYhxGKTCprImHkPTF6h7w
    mZ+RcKw3+777zIaE/hgVebM3qgSGtBWeRmcm+/tZw/uiBsxf+xV30hJmxjO4c4wPzSuzdD
    U8SXX783FMUHBtd/ksznxlW7k7q2gqr05CUQdImoXZBHLqbihchej5uRre05nxGUL8yn+0
    hNi6/n5/bXR+WLo0kLvZEgmud19TVV37WiiMv8AcmsgterlaIuPEe3RYqaf7YXXNtUUErh
    pfi2FUkxnR0ko+LN3hH1JDOCM/SV0hHfQ0ZqGdJs82nb8NsSqpbh1MQ2q+dg
X-ME-Proxy: <xmx:MaMVamQE003TMNpPFEsDze83sY5ZOeZiH4wapTgTznoXsVvuHrpDaw>
    <xmx:MaMVapKOGNkF1uXDZCpM8oosYOrjRppeRySf1K4lT1DrnEC5wxWZeQ>
    <xmx:MaMVarJXJmPbUnqvgdQYKT3p72Yitci8A20Fg-GM0uwzTzil3O_2tQ>
    <xmx:MaMVasir9XE9CkPCXtTk_mIZigqjFNR988Y5aeFb3zhgGVAJhsnPLA>
    <xmx:MaMVanLODgeGqZB2ZFPbxcolUGakPF7vJEWRbQudPttrFGBWfqpqLuYq>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:42:08 -0400 (EDT)
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
Subject: [PATCH v2 2/6] UFFDIO_RWPROTECT.2const: New page
Date: Tue, 26 May 2026 14:41:45 +0100
Message-ID: <20260526134149.2831720-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526134149.2831720-1-kirill@shutemov.name>
References: <20260526134149.2831720-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: da45t675xonrwzfgrrjrsk8jrzy46go4
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 86064A0011
X-Rspam-User: 
X-HE-Tag: 1779802930-185617
X-HE-Meta: U2FsdGVkX19/Wbdi5xa+DUjWs6Qit5HW0ewm42ymQYKiG5MWRMWBkVwBN0Xfzo2MBKGsM1gytJpX8Mp1Ou/XIe7AWVQyOajEK4fCM7NOFr2aiGvrBmezyFy5+zA7KHUhosmSt2uQfsiP8aLIib3FiaNeH94HCsSQLnAinf/f1oWniW/aoFz9OjJElM8nD6PFCKFWy06oqulFzmufSZXQplQQtWSexNvDTI1X/MPm+zpMr+jiZ7UhjuSPvHwg9jvtQx4EEAHHKxv8zvop2h3Arn2SuqzJ4uBEm7VwpEuT5t0o6RxVcMgiFHHW+e2fdU+Pd2ewEZ10j4pJptvCT11ItryWoYUwNhf6VWutDXIGEeTECpdOXCABC0B+NcbEmO5Ln55iK3PXKAkrtJSOlhIuGrF2zzF9NV7e+vcY3ZkH2E/0A03pO3B6BNr8r2K7El3CFh0azKIHuei+HTH7pwoVLv96nE/XTcwRTJYBDbK8GwKRDYgs22JOzS2YCAycQWt13jfmQidSqGTd8SM4Uhj8l0Ycm/5s2FjwKjEoEWsiHQjWwfvZwrmiLTXytPDHBMKu5F7qsMiJxOeyeD9rFZgpdN4JW+r51iifFVARKfyiQbqdKtIHt1P4nW18BJitTZZb6ewjpwKg2/UJQBKYquD38kIOGP1oHScPtVm9IqPouupLoDVIf3lAbRwCxBPCl7gS45ef1wbIGzsD3yopeybkWwP7XW2tIYRTaajA0JGX8bK3jWc9+x6C6xe5dsPo85qsz9gNWkC7+23RRTXGcuczRNzMDp7spw1fQ1eGDUuFdjo+CgLMNqwdfUpgX4wlertJCM+WgG8NRfvPT1gdu7b+XAOhrLkkK3DKy+UMf1GH+irZDzMhqYMRdIOuwMWeR5d2/cIcU7jhdLaHqV4C5jmRcdgKpRh6z8t+AMy+kBGIA2XAcHOWbh24O5Jf327Zxpk6NFCA+oGvsAdGsuk2aaX
 +2XAdOIO
 lyAHsoI8mpB9XXTx08FD/q8OSd4LB/v9yHE+7HKrt7PGpIvOzMfE0O/6GGYv8gEXniavrjuPjiozt8KKlO/5D7kfSoqQvl2akUtZv/XuEDcXNGK40KsXVIT7jt3QOMnNSYgFn2rzuNfix+yuqikHJANHUbxq1BBe3FKONdg+yiFRO8j/GN9d5RhbywaIREqkEMh4EDgcEGGCbvcC3fYB2gcFKWWnFkvaSDH2pKYf7MhNMx+WE9fmqd1bjZ4dVMXEiILMQDa4Ihv6DPTN1CHEjJH7aga5S4PzfUhwAv0ayWzaEyH3xbb+hUx2pGtrH3V0pwW6K3pNoEBK24MQ9TACU2A2CPVkDi+qABtRdkPy5q+a6qXktRO8T4CzQoLYJuAdCSf9utft+wDCFljup4SPMNwIYdnzGwVhvIwIownJuGp6raCpPl8rBqt5L7JXl9OFnh5+Dq2rfKiSbUoJjJiNZliIr2ab3wT8NwBUd7NajqM7/+BgBVcg3L8ZdGbz4mzWD6pc8k2r6ZyDLfMFL0oFh3nCYX0qesd8SPuov4UhiUfki1NToX554vbrP8/1DxdolSXYJSs/dQxc6/H+Ig5zPvOJrxkcGnU/lBZV74CqEAo2vJdRNbw0sYaDDGmmCJ5W8gEwrK+2Aco7wgEayz95fLs53iGFz4ki2NNhc4IvUajzD8ZQPXld90d7HVUhQ9GeoKaXNwrQtAxKYPI8=
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 man/man2const/UFFDIO_RWPROTECT.2const | 122 ++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)
 create mode 100644 man/man2const/UFFDIO_RWPROTECT.2const

diff --git a/man/man2const/UFFDIO_RWPROTECT.2const b/man/man2const/UFFDIO_RWPROTECT.2const
new file mode 100644
index 000000000000..42654a834cd5
--- /dev/null
+++ b/man/man2const/UFFDIO_RWPROTECT.2const
@@ -0,0 +1,122 @@
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
+the ioctl installs read-write protection
+on every page present in the range specified by
+.IR range .
+Otherwise the ioctl removes read-write protection from the range,
+which is also how a fault handler resolves an
+.B UFFD_PAGEFAULT_FLAG_RWP
+notification.
+.TP
+.B UFFDIO_RWPROTECT_MODE_DONTWAKE
+When this mode bit is set,
+do not wake up any thread
+that waits for page-fault resolution after the operation.
+This can be specified only if
+.B UFFDIO_RWPROTECT_MODE_RWP
+is not specified.
+.P
+Read-write protection only affects pages
+that are currently populated in the range;
+unmapped addresses are left untouched.
+For anonymous mappings,
+protection is preserved across page reclaim
+(the marker rides on the swap entry)
+and migration.
+For shmem and file-backed mappings,
+protection is dropped when the backing page is reclaimed.
+Callers must also re-arm a range with
+.B UFFDIO_RWPROTECT
+after any operation that explicitly drops the underlying page:
+.B MADV_DONTNEED
+on anonymous memory,
+hole-punch on shmem,
+truncation of a file mapping.
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


