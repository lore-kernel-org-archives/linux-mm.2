Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A22CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA466B00D5; Tue, 26 May 2026 09:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B5C6B00D7; Tue, 26 May 2026 09:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623036B00D8; Tue, 26 May 2026 09:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD096B00D5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:42:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17E4A1C175D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:10 +0000 (UTC)
X-FDA: 84809684820.28.ECEB83B
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf02.hostedemail.com (Postfix) with ESMTP id 253D680003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M /hO74I";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=vAfkACyb;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQ8zo6ePeQ8e0mgFF9YwviRxnOrTPc84EtwiEk4DZu4=;
	b=q86SJtNouEFtcBh58jMzC6pXuPjbz+79Cg76l+Yvl1966uRd5Loq5/TDh8awS/xE5RAyeg
	2loXmUa91AnjswF0f1WRW13gMMDGavSf4shHeGVjAkb0+UO+Ypugzbz78vJUyyah3Kxe1b
	pYdXJhftoi51yAZvdapOXA9N6oZKyeQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M /hO74I";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=vAfkACyb;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802928; a=rsa-sha256;
	cv=none;
	b=YaUEiOCyEA2/CXD9btk+7E9RWwM0Pd9HLwCST2Xi1IdFCntihbgHTjII7MniRChhOld3h2
	k0YIsnReAf86P94p6RIzIHcOYOwiK/qEFhAUJxVaunW5mzd1ZMxpydxV1xn1VIq34HGK0+
	UHjUEsR3eLEoC2UPLdC3d6lc8oJK6to=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 5F3151D0011C;
	Tue, 26 May 2026 09:42:07 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 26 May 2026 09:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779802927; x=
	1779889327; bh=tQ8zo6ePeQ8e0mgFF9YwviRxnOrTPc84EtwiEk4DZu4=; b=M
	/hO74INtUjFD0ZbYbIa4DSzJKhTCCjQrokUxfkjXTNWpNze9JH3qY/QPrDXrkwrI
	XTRCLa/fc2q8d9pjCBg0tzj/V+UrqpEGAuKleYlp6Fdf7sE9BSfAVFRsYoovmrf9
	U2Ylip+3zQnJZmKg/bgmzbvbgI1RYv+WsxJRqoz9bdEXrIK0yFa3cVzth9DafH5l
	AJWpuJYE7U7SK89YnbtwBNy2yy7KC7Fmqjra9JfdP15vqQrSRzXHC227TqFBuyUB
	qGzGNR0ti+Qj885vH/1t/RDNZ6awcEe/bb2T1srBXWLLbDz8W9UjwF3mIaGvOrGh
	WTkMLO5fynINBf/sys21w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779802927; x=1779889327; bh=t
	Q8zo6ePeQ8e0mgFF9YwviRxnOrTPc84EtwiEk4DZu4=; b=vAfkACybs+4kgWmSn
	hV7XBuuI3W7g4iz5mKqHfs6Ax6VZm1Ydb0UfHTNSA3D/8Y4bJoUqYYEM8KLRlukK
	ok8UMLGXhkFIVUbPg4MpJ3I9yGr3HEWiOsjzKzk4zl7AhUDyRnP80sReTisVehZ+
	E3N1bkUp3BqUdEZNUhY1fGaRkcNEtrHtwPtdUlu36yYPT7jx5pL5bLKJeOaVFsyF
	8sh1qDvuK42bacOZAz86Yu0ZKrHXkMXU6i7G9CTDHKFnk7L2kLS+T7o6wYFLECIh
	4IHlptywvpLX1uq3l223eleOvTsatCbSnrHxVsXeqFcuOPEhF6saRAtDECw1Nc/w
	xbbYA==
X-ME-Sender: <xms:L6MVaprqzHCs-3z5wija5jsfc0ycfITk15_Yht6Upsvd3d1FZu-M0g>
    <xme:L6MVauMfsiZXrybFEjrrad6Y-bdMPj1oQpQOKM4ga-e6clYek6xAeblMnl0YplC_e
    I8x0wafgVh-I322_d2KG7-ToRBkkCBhJMha_ssVPsNiiZVIz7kmYjI>
X-ME-Received: <xmr:L6MVap1a30jJrZMdXbBr_afa7E-2tgeFna31H_nnV-heYPMrTx8noBXxU-4WVA>
X-ME-Proxy-Cause: dmFkZTEKmmmfXFMqzBs7jiifbVegvNCJMVjirpcHlqYkdZGf2vrG6uVXAFSg1d6Q0td17G
    BHi0Udk8wZxn4GNKQn0i0qKJVhV28Siuoy4sYJQthpVYTvIdem3xKUu82LLvmo/fRR2idc
    E/LNl071KFayMqGvv4PhVSsTfRiLzAahkciooLFgU6KxnQ+B1GpIDtHxzLYepxSOTOuoB2
    Jd310wilmlqycHv6nAP4aVmA68fCVq27y7NLY62QiKr3TqEQlhss6i3AfD+YtRux8QVtEP
    BSq3XlZYZPRjKlQoiTY0UC2u7pxjmzfGltvfKqMI1QHBcBwF4AwCgyEi3Yivk9I8a0Cjp1
    aq7Rgo2iTvIVEMB6gomogvKnxfS3PgajbODpWSC9MTBZJXGSM1fOko/LDjUQOMx9gOQv0v
    3zs+Rvv2qXSiD1EmASCjcYfTRlvA2DN1gfCrsKD9Zyk84QnhFChL5qwaoKHdCZMBI72JcO
    QHr50QSYUwAfhB4RrSRT4BXmv4Rn+Jk+aGbYPvKG+muXWzH4KNOJh4qd4y/+TmrpP7HRw8
    2nQXTAlAb4NQWh/bpXwBDGFHPR1QGixkYVCC/9KDYbYKLP/Mv0+I0AJ9HP4zLQDGaOtbRv
    55wACmSeU7Cnzinlv1UnzPPuW/KVLfjTzKMyZnHCNa0z64AKERkZTDFhpnjQ
X-ME-Proxy: <xmx:L6MValBYy24u9HfuLLo-kY1pFycAJrU0-O4G9ETsqYfbWMrDXcBtWg>
    <xmx:L6MVauKpLCmMcec3Xnlv_zct2gsTdS6Spvzyn8SEL6mOu7skoBIx0A>
    <xmx:L6MVamkXn1KuDqKlkyC8rGMWHksqxvvhHF3Q4GaRaIb86P0UYTbe4A>
    <xmx:L6MVavZJmIgFiWSHqCD2wgqvTuX0rHEN-cI-J6pTO6Pajy2o-HQU_w>
    <xmx:L6MVaocbmHJ5wYufmuFbFkuNKIApfHRmiDBa7Z82caIG1lxi7oDmUDnl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:42:06 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: alx@kernel.org
Cc: linux-man@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v2 1/6] userfaultfd.2: Add read-write-protect mode
Date: Tue, 26 May 2026 14:41:44 +0100
Message-ID: <20260526134149.2831720-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526134149.2831720-1-kirill@shutemov.name>
References: <20260526134149.2831720-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 253D680003
X-Stat-Signature: ac8qohp8uoek1m31i6djoqn7safg4xmn
X-HE-Tag: 1779802927-276985
X-HE-Meta: U2FsdGVkX188gGtVZdEOhMGMHrARc+qlGgZKoLbMKWcg1jyqHUZXtTGDHqX9u7WvFnGliQ8j/fkZLAumaDzJKJ6AdCVmT2lMic76LrPi3fIQvF3LJWR/3bRg4fsY22fdi7PDRhmmI5lCcOIiYCKh9undjAzHUklw0w16Wmibcs9uBgB6iUpvpbbDwJXekuSsV9ydfBpdEOOJaEab3Nr5AbnzsbPUHlks6eE9LKbX030eD8CvaxJRyKDlCfj9+Vi2ao7Eopr39MxP2nUDnMHrYZz9uDQQWDT34x1b7z9PqhoN/Sp463ah7m/sjA7ZtacoHGEEysh2hsG20CZM+JYtwgjXqkIsZ0kOmoA7aO6vD+MVJXzSdi651in6Rouoax9WggfW9RCcEvp2lSmMvFfa9qwCEOp0EGSluPX1KmBLeTSWNOEJB4bp94cd/jaBXu496M+V6MvQAltwqHsK+3H5eiKuC6RmTV30Ts0XL6iJ6QC7YF2jteImudUKmQIxaY5MYqNX4/T62/G6llO1xWxJlczyOS+suAmpoeSmdJyWCbJcSYSv1iLhoYHQsdY4CTDjIOEBgTCMSUYhtJ+iwqTjRmEwgdaauUAJMybebtukV5Ebjo+13Eup87Q07wWKyS61yV0DrzUTEfsSC/crhNSn08K884gUwitgsakK4u7VE2PvaJPJ6s3n5Q4ZVvd7X+sCrElzB9TSrvMdcRscypmyl+tZUH6LPbOjtepBpSTdwwL2rMChlOZD2G4PQQpLzfbiae5CHkDl4wuFmR250s67mWs4kwCoM8SbDmCb5hbvc3leScEHOTxnSP3hC3mSv5GnNTNRN3MttkZpr2+P7Z0L0I6u3L4hZvH3guZLtbgcRl6cEKBVo09W4fKorWy4tRdkPoQc/noajrq0Cj+FLLNi9CuOdt1Fy0Cr2/iCrZnGQR7UryJl6k7B5cw7o5++RvllNPh/q4qdLBZpioySUsH
 kjvfRvVj
 SP+y6HHIIfj9rD/mXi6Pu1PzmJkytXm8/gkOhwxiCP/X0+UR1QXrugpQmdPgsrHTlQw90U+XLSLuqV06JNyV0BqPiSOPhP+e5JbhQGPo2R9pKfaoy1EMtpRvISN2ECLKl9bIBjFGLt8/iT77armXTJTN9E8G82/RuWaJ2MMHLu6X3jnCg/dEQ+Lz/hxs+nQUkd1rPBb2JZNSz+rRAOvECuw9XJCvxgwGq4ptsl9I1HHNu5GKXsDuQHkRpG6EPZDgjCO/FuXRru4KQF6KA7cESARNP5EHhuPwKG35nKvhaXNqyAu+npZygb2QZHS6BPuCHu78+M6Bkp9tlB/1wH+vToHtFwZC8HFBeW234Afik7k3hmaNPn0qOjaZpNXRrIPwHN+pTsAYHHkIgGhxi3THXBb4LshrEwNUh40aVIaG6VERQuPsIcrpT5VV3xwugbgYPN3HLYAJqsqBf5wqKsXMiDYBDQkNvcz+LX876NEyxTTOGtw0i9hWWruKM+ALAZyAPsW54J7GG/zy1dRbMEKvgrB1zuP+oI2nmMA3g6OxSQ1Cw0SXioge6//aCbs56VdBZ50NLnaDIRn/nzPEoe3cHCSUmpkmZ2zXu2f27GeRwO73IfwfsHmBHTpmeDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Read-write protect mode (UFFDIO_REGISTER_MODE_RWP) is supported starting
from Linux 7.2. It traps every access -- read or write -- to a present
page within a registered range. The matching UAPI consists of:

  - UFFDIO_REGISTER_MODE_RWP   registration-mode bit
  - UFFD_FEATURE_RWP           capability bit
  - UFFD_FEATURE_RWP_ASYNC     async (in-kernel) fault resolution
  - UFFDIO_RWPROTECT           install / remove RWP on a range
  - UFFDIO_SET_MODE            runtime sync/async toggle
  - UFFD_PAGEFAULT_FLAG_RWP    new pagefault.flags bit

Document the new registration-mode entry, the "Userfaultfd read-write
protect mode" section, the new pagefault flag, and a VERSIONS line.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 man/man2/userfaultfd.2 | 174 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 170 insertions(+), 4 deletions(-)

diff --git a/man/man2/userfaultfd.2 b/man/man2/userfaultfd.2
index 6d56085f1534..c395bf9bb332 100644
--- a/man/man2/userfaultfd.2
+++ b/man/man2/userfaultfd.2
@@ -111,6 +111,32 @@ .SH DESCRIPTION
 until user-space write-unprotects the page using an
 .B UFFDIO_WRITEPROTECT
 ioctl.
+.TP
+.BR UFFDIO_REGISTER_MODE_RWP " (since Linux 7.2)"
+When registered with
+.B UFFDIO_REGISTER_MODE_RWP
+mode,
+user space will receive a page-fault notification on any access
+\[em]read or write\[em]
+to a page present within the range.
+By default,
+the faulted thread will be stopped from execution
+until user space removes the protection using a
+.B UFFDIO_RWPROTECT
+ioctl;
+if
+.B UFFD_FEATURE_RWP_ASYNC
+was negotiated,
+the kernel restores access in place
+and the faulted thread continues without blocking.
+.IP
+.B UFFDIO_REGISTER_MODE_RWP
+and
+.B UFFDIO_REGISTER_MODE_WP
+cannot be combined on the same range;
+attempting to register with both bits set fails with
+.BR EINVAL .
+See the "Userfaultfd read-write-protect mode" section below.
 .P
 Multiple modes can be enabled at the same time for the same memory range.
 .P
@@ -192,6 +218,24 @@ .SS Usage
 kicking the faulted thread to continue.
 For more information,
 please refer to the "Userfaultfd write-protect mode" section.
+.P
+Since Linux 7.2,
+userfaultfd can do read-write-protection tracking,
+which traps every access
+(read or write)
+to a page present within a registered range.
+One should check against the feature bit
+.B UFFD_FEATURE_RWP
+before using this feature,
+and optionally negotiate
+.B UFFD_FEATURE_RWP_ASYNC
+to have the kernel auto-restore page permissions on fault
+without delivering a notification.
+This mode is intended for working-set tracking
+by VM memory managers and similar callers;
+cold pages can then be evicted using independent kernel interfaces.
+For more information,
+please refer to the "Userfaultfd read-write-protect mode" section.
 .\"
 .SS Userfaultfd operation
 After the userfaultfd object is created with
@@ -387,6 +431,113 @@ .SS Userfaultfd minor fault mode (since Linux 5.13)
 Minor fault mode supports only hugetlbfs-backed (since Linux 5.13)
 and shmem-backed (since Linux 5.14) memory.
 .\"
+.SS Userfaultfd read-write-protect mode (since Linux 7.2)
+Since Linux 7.2,
+userfaultfd supports read-write-protect mode.
+Unlike write-protect mode,
+every access
+\[em]read or write\[em]
+to a protected page generates a userfaultfd notification.
+It works on anonymous, shmem, and hugetlbfs mappings.
+.P
+The user needs to first check availability of this feature using the
+.B UFFDIO_API
+ioctl against the feature bit
+.B UFFD_FEATURE_RWP
+before using this mode.
+See
+.BR UFFDIO_API (2const)
+for the recommended discovery sequence.
+.P
+To register with userfaultfd read-write-protect mode,
+the user needs to initiate the
+.B UFFDIO_REGISTER
+ioctl with mode
+.B UFFDIO_REGISTER_MODE_RWP
+set.
+.B UFFDIO_REGISTER_MODE_RWP
+cannot be combined with
+.BR UFFDIO_REGISTER_MODE_WP ;
+however it can be combined with
+.B UFFDIO_REGISTER_MODE_MISSING
+when the caller also wants notifications for fresh page populations.
+.P
+After registration,
+the user can read-write-protect any existing memory within the range using the
+.B UFFDIO_RWPROTECT
+ioctl where
+.I uffdio_rwprotect.mode
+is set to
+.BR UFFDIO_RWPROTECT_MODE_RWP .
+Read-write protection only affects pages
+that are currently populated in the range;
+unpopulated addresses remain unpopulated
+and fall through to the normal missing-page path on first access.
+.P
+For anonymous mappings,
+protection is preserved across page reclaim
+(the marker rides on the swap entry)
+and migration.
+For shmem and file-backed mappings,
+protection is dropped when the backing page is reclaimed
+and must be re-armed by the caller.
+Protection is also
+.I not
+preserved across operations that explicitly drop the underlying page:
+.B MADV_DONTNEED
+on anonymous memory,
+hole-punch on shmem,
+truncation of a file mapping.
+Callers must re-arm the range with
+.B UFFDIO_RWPROTECT
+after any such operation.
+.P
+When an access fault happens against a protected page,
+user space will receive a page-fault notification whose
+.I uffd_msg.pagefault.flags
+field has the
+.B UFFD_PAGEFAULT_FLAG_RWP
+bit set.
+.P
+To resolve a read-write-protect page fault,
+the user initiates another
+.B UFFDIO_RWPROTECT
+ioctl whose
+.I uffdio_rwprotect.mode
+has the
+.B UFFDIO_RWPROTECT_MODE_RWP
+flag cleared.
+This restores the original VMA permissions on the affected pages
+and wakes any blocked threads
+(unless
+.B UFFDIO_RWPROTECT_MODE_DONTWAKE
+is also set).
+.P
+If
+.B UFFD_FEATURE_RWP_ASYNC
+was negotiated alongside
+.BR UFFD_FEATURE_RWP ,
+the kernel resolves access faults in place
+without delivering a notification:
+page permissions are restored automatically
+and the faulting thread continues.
+Callers can later reconstruct which pages were touched
+by inspecting the
+.B PAGE_IS_ACCESSED
+bit returned by the
+.B PAGEMAP_SCAN
+ioctl described in
+.BR ioctl_userfaultfd (2)
+and
+.IR Documentation/admin\-guide/mm/pagemap.rst
+in the Linux kernel source.
+.P
+The async mode can be toggled at runtime using the
+.B UFFDIO_SET_MODE
+ioctl,
+which lets a single userfaultfd switch between async detection
+and synchronous eviction without re-registering the range.
+.\"
 .SS Reading from the userfaultfd structure
 Each
 .BR read (2)
@@ -531,13 +682,17 @@ .SS Reading from the userfaultfd structure
 .B UFFD_PAGEFAULT_FLAG_MINOR
 If this flag is set, then the fault was a minor fault.
 .TP
+.BR UFFD_PAGEFAULT_FLAG_RWP " (since Linux 7.2)"
+If this flag is set, then the fault was a read-write-protect fault.
+.TP
 .B UFFD_PAGEFAULT_FLAG_WRITE
 If this flag is set, then the fault was a write fault.
 .P
-If neither
-.B UFFD_PAGEFAULT_FLAG_WP
-nor
-.B UFFD_PAGEFAULT_FLAG_MINOR
+If none of
+.BR UFFD_PAGEFAULT_FLAG_WP ,
+.BR UFFD_PAGEFAULT_FLAG_MINOR ,
+or
+.B UFFD_PAGEFAULT_FLAG_RWP
 are set, then the fault was a missing fault.
 .RE
 .TP
@@ -640,6 +795,17 @@ .SH HISTORY
 .P
 Support for hugetlbfs and shared memory areas and
 non-page-fault events was added in Linux 4.11
+.P
+Read-write-protect mode
+.RB ( UFFDIO_REGISTER_MODE_RWP ,
+.BR UFFD_FEATURE_RWP ,
+.BR UFFDIO_RWPROTECT )
+was added in Linux 7.2,
+together with
+.B UFFD_FEATURE_RWP_ASYNC
+and the
+.B UFFDIO_SET_MODE
+runtime mode toggle.
 .SH NOTES
 The userfaultfd mechanism can be used as an alternative to
 traditional user-space paging techniques based on the use of the
-- 
2.54.0


