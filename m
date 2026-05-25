Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A115ACD5BD2
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187F86B008A; Mon, 25 May 2026 08:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D786B0096; Mon, 25 May 2026 08:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F404A6B0099; Mon, 25 May 2026 08:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E43496B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:28:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78993C03EF
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:30 +0000 (UTC)
X-FDA: 84805870380.14.B6C5858
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9939D1C0015
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="t LtrXFz";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=GdhxVXi2;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779712108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBzdwc7p2KgTRH5jXfzw9i3jZ4EZ7HmaFEX50c0qk/Q=;
	b=jBGlopuCjDbXy7/NFZfYr3Zgrgmwa4lY1UVTSDO7/pSmSTxOJ9HTBZnp2oO1danCyoCsD2
	4oZMD3zAVcK2f3H5ohVRdu40MlKMQQvgcUEt+TX6eDOetJJeKi+2z6Z9t3tiHMeheAzvOj
	SAEeWJD3QzNiZhCEtdUYYZutBVWL07M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="t LtrXFz";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=GdhxVXi2;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779712108; a=rsa-sha256;
	cv=none;
	b=O2N5sMvQGr5pVHs6gH1uPHNN7FuhgIKPvX9HUMvHFveYpcaIEBapzB2QfeHe//grDAtBlL
	hnty/QqmUTMH20wtA3YeRXHeFejELQ54fm/6RI+Gou8GQIPd14MKAaNdhGIqyrDBcDyDDm
	k0LPvkkS3fwwMFR0GVnaaHJ35o6zSGM=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id C24031D000FE;
	Mon, 25 May 2026 08:28:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 25 May 2026 08:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779712107; x=
	1779798507; bh=VBzdwc7p2KgTRH5jXfzw9i3jZ4EZ7HmaFEX50c0qk/Q=; b=t
	LtrXFzfE8uLpAU2EUxaYFMFz4JyY733rx4Em8L18xIwF26ufud5w5rpyQI/8ttLB
	MrrcxfTLBC9bTzxpaM/V8Iuld0E+IHS49PA9lYBiuCo9ZKppiWKTA3EfxQjXbmbv
	tjtW0LjHXd0GwpLKTehpQLBdJT5ZK5ADI9H69+vMzhsD4WlYfnWf31Fi0RldCNwX
	HQILSWYTSfvAwP/vZJ77zn/6ys1Bl0mJXFUTCv3Ln0d7amuPIW5NCsOdUnoQ+pDY
	7SvMqhL9HSy313pAeQUxjaZKDh6M4hc4sj/ipO+SXL08oBGHq/ufP429+eKMYkp5
	jhmahuDn8PKZ9CLJBPPKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779712107; x=1779798507; bh=V
	Bzdwc7p2KgTRH5jXfzw9i3jZ4EZ7HmaFEX50c0qk/Q=; b=GdhxVXi29dXzoMnPx
	SF9e2OcGWOjKD/bPyCVHVBD+bYBNzQvNaTddfEQZODHe260NA3SB3Byiam7xqVs9
	aVbL3/fTKiM/3OFvl7pd2dm89GMRKlyzbLnreovUyP/b6hzsE0pTJJPf7cf+JI+o
	Fj7IIBngaBwo9pnjEnK8AmCgNv2YGw1h4S69/qlvnshixQ8FkDXBk/X10S1/TY7u
	pTuqT9Ct7LFw8lsaUJH57sHO+zINZlXIQMDOHyqn+KhibHeSHnPIjMxfwLlGtBkJ
	FpkkjIb9jflNa7FRZjXwEsmlqydSGFgc/TmRoIp3gX1Y/iWE9KRTGSFOwo0kjJNY
	3mqYg==
X-ME-Sender: <xms:a0AUansuaccbhVOlHpS_HY0fvj2LRcqClLj7eryhKA_x9Zg_zaE8fw>
    <xme:a0AUarAsox12fsVPYRe36X4bPebwGQGjrSjnypNW4klxwqwu_PACLDTbEHKxKdjWg
    aVUH5f3Q9x4mnXznKlaYyXq9JuRW3KrAm8IpGEQjVRIv4dcyxCbOg>
X-ME-Received: <xmr:a0AUaub7_ZH1DfclLdG-e9vBv4PIRz3qg2l_55Iqjffn1tkv0B9KhziABeQFsg>
X-ME-Proxy-Cause: dmFkZTF+vGxBLttClxhWUBS4Rd9mlT+jat1giB/aBIg9p2KWp37wtRflhLMKYkAOkhtYYl
    lW/07sDi0ZSs2HD+xGJmdjKpGoFdj61xtZaCVuvKUGTJD+JuFsbek527hGltID8L92IVmQ
    Tu0oUKxiNPpH6AHdPq+s5L47hEenGMq/SIgP/8nO3RxPykjGl1xN7YN9nCgxIRG049cxFl
    Zk4MO7f5/ko2vf6kROtcFNoSVZy6TrpooNM3g95orPKMyVpxhrOEdRlydL6gglS8hKMbk/
    NpdegBEF7KmgMwlLTcQ2fyawjEu3xJSq1pqMZOjZIBpypI2WwUDuUuMbIEmCwURg7VZ1Vy
    Fr/0MaAGr/qw69aPNHaEHY6eH8JTZ+6FhERW1AxJurKUcUYU5EtirQS1dWuBpb3oB/zsQg
    ozXe5ypE9EFfF7TBBeozhW0J1tPqMjqJCBdKZPVuE3xAapcaNEsYml1I0vYTLMH9DN7yCc
    3N9JWDq2GTq2d4EB10KU843DbTJ01+DxshXnFUHX10tfRGcshvBB31vMjYGu0rjXhUFpPQ
    Xc0l8HsUdGX8r17UROUm9Vw/f3FLH34l3bb7qj5Sm1uGDrxRw2YrHGHgM4qIB0NTNUaJfO
    SFT2AdaxBVNfX5jD1oBtoG08mzAE7Se23I1Id2lxCYf2bVw9mV0ga/iSlzEA
X-ME-Proxy: <xmx:a0AUamWaCRM3aJqJ8tFjP02C35f_X3NlQ8Ul48Gq_pHAVJWGlxL8gA>
    <xmx:a0AUatOqaSifGoEscc6qrX6MLzMOVdx_BpX5JRMEhB6ob0eRM8N-Aw>
    <xmx:a0AUagYEnaoN0bMiHQT6BYr4rQK9LqQmMQOXBTDFbNOPcddJgrPUoA>
    <xmx:a0AUas8WB2nsp223hFfMtKpVkj0XX3ZVnjqgURhG7_No_nHolJ4oRA>
    <xmx:a0AUaqL34pRCcIisrpeBDfepGYyZsLwa7TFKXRxu8KW8XtVAD9vIoAg5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 08:28:27 -0400 (EDT)
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
Subject: [PATCH man-pages v1 1/6] userfaultfd.2: Add read-write protect mode
Date: Mon, 25 May 2026 13:28:11 +0100
Message-ID: <20260525122816.1956804-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525122816.1956804-1-kirill@shutemov.name>
References: <20260525122816.1956804-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9939D1C0015
X-Rspam-User: 
X-Stat-Signature: u3xnm3hi5yxk5xdiru5w5iioa5ggf9q5
X-HE-Tag: 1779712108-270784
X-HE-Meta: U2FsdGVkX1+gLbBeK44mkvr0mwG1ayO7779e/BZFQ4OvpmKOJusy5cvESdUrafCfH1SExurEZ2gM7trosut6eiCJtZQdp2ZmKVKOa+iiIp+OrlXjIZ3e1d1hyab5+Vw2nG+qfN1OT8UCaeaiD4aK8q9azBLqoQpRxmymDc6pe3jIXFdDCTx6sYn2sSnikH5+Il9nlyVwPgaY7oapM6xP8AN8+xUAyBHj1MyU8SI3sBVcuHBuJNrsw/vBmAB911kWvfyzxdKWC+i3XIOwEEhN2C7Hv4cmrK1/wx+xCegVKJG6l+Rwes0REXv8HvZFboeNZNkl6YFDJglwnHd2KC9noWSgO6cc8Yc0y0nO5UK8bz60acvALzjbXnkUOaL4jiXbMpu0bnnDC6woX0ZYbnKyRZKgH1a02gCM5PzMso6rT1EWoAZZkChME1wA6EBugcmf6DYFlR2JKJ5DTKR/QLp1AWH2kkwWRKLd4k3veFpJ21CuaytJq74Zigitu1VKy2oqKcAGW0hKWr9Wio3miVwbUfaHBdLvZxBmdDRGT56KoYvuleCzatvnC3aHNDwgLhIU44xWF7vZXjRlXK0yfdOsn2ro3Sn9olSCF3C1VccF2p329HhkAh3mHWrdKwJ1hiNvJ4NDXBgPEat900uGuU1mpq0HEPmhuQQ6i0fetktS6K/xBQtsXO3QL5hBTaNpXxK5gEwXp+SyaGFAMVVHpSunyINydaXJx/JufaxKmVz4KiGhtGxbp7iNuG1QgdJ1XNcztyVtJ9eQvAv4KTJrTAwNQ5SSIFQ1jBvzZC2xSfSJT364oyRsJPl9DI3BzVcfvlypLgqbZ9lk56HVD5A2LT1hdek5Xye4ElG0DYjDmAjKKzX+2LWbTd/6FBVw1oztG9GFz/LSKBcoCcVJx5Ed0cQJ3D8XMaGCnn+EYJpzOQTkNEf6CPpaWmqbzq1Gs+EejXexTnapqSvDIvqIp5a2YEu
 oDs1+Cpo
 rjW1d78L5qD7AwCeu3gcTCJJuMySMnpgKH96MZ3gy7yaxIUAkqKULpqjbKmMkcaScHzYeki7l3f87wISsCj41C6dXsg6C3GtuHqC/Gt4U7YdJCQjlitblXfvvI5BoU6UO0P2sjMF1nMaQN38Ftv8viPQJnM18bdwakwpAw/yFESOpqM+V0g0GE9PbuB/8nuf2B3alDWMJuNUH6mEKmMKovnWKwb76mMWWvH/GkWDKZsK1neGd/LbpjeDzWYlqpJ4FGJh25dAvaGNrhVlTl7eq0JbwrIoTR6gMqFETqv5jFOuCR37mhXjpHed0Y/rGlmy+ZVtgewR7lkoHi0xBq1wKUknbTfENbRJEmJ6NrGYh6MivK1DrQetd5jUDcuZ7eRPHjDR0cO/CvLgrRe/SPfWjc+kJMuqEKny9go+bk5BleyjqPX0Rm/f1rBBic8oFQ+IIy8LO
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
---
 man/man2/userfaultfd.2 | 152 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 148 insertions(+), 4 deletions(-)

diff --git a/man/man2/userfaultfd.2 b/man/man2/userfaultfd.2
index 6d56085f1534..a179660f4105 100644
--- a/man/man2/userfaultfd.2
+++ b/man/man2/userfaultfd.2
@@ -111,6 +111,28 @@ The faulted thread will be stopped from execution
 until user-space write-unprotects the page using an
 .B UFFDIO_WRITEPROTECT
 ioctl.
+.TP
+.BR UFFDIO_REGISTER_MODE_RWP " (since Linux 7.2)"
+When registered with
+.B UFFDIO_REGISTER_MODE_RWP
+mode, user-space will receive a page-fault notification
+on any access \(em read or write \(em to a present page within the range.
+By default the faulted thread will be stopped from execution until
+user-space removes the protection using a
+.B UFFDIO_RWPROTECT
+ioctl;
+if
+.B UFFD_FEATURE_RWP_ASYNC
+was negotiated, the kernel restores access in place and the faulted
+thread continues without blocking.
+.IP
+.B UFFDIO_REGISTER_MODE_RWP
+and
+.B UFFDIO_REGISTER_MODE_WP
+cannot be combined on the same range; attempting to register with both
+bits set returns
+.BR EINVAL .
+See the "Userfaultfd read-write protect mode" section below.
 .P
 Multiple modes can be enabled at the same time for the same memory range.
 .P
@@ -192,6 +214,21 @@ The user needs to resolve the page fault by unprotecting the faulted page and
 kicking the faulted thread to continue.
 For more information,
 please refer to the "Userfaultfd write-protect mode" section.
+.PP
+Since Linux 7.2, userfaultfd can do read-write protection tracking, which
+traps every access (read or write) to a present page within a registered
+range.
+One should check against the feature bit
+.B UFFD_FEATURE_RWP
+before using this feature, and optionally negotiate
+.B UFFD_FEATURE_RWP_ASYNC
+to have the kernel auto-restore page permissions on fault without
+delivering a notification.
+This mode is intended for working-set tracking by VM memory managers and
+similar callers; cold pages can then be evicted using independent kernel
+interfaces.
+For more information,
+please refer to the "Userfaultfd read-write protect mode" section.
 .\"
 .SS Userfaultfd operation
 After the userfaultfd object is created with
@@ -387,6 +424,99 @@ wakes up the faulting thread(s).
 Minor fault mode supports only hugetlbfs-backed (since Linux 5.13)
 and shmem-backed (since Linux 5.14) memory.
 .\"
+.SS Userfaultfd read-write protect mode (since Linux 7.2)
+Since Linux 7.2, userfaultfd supports read-write protect mode.
+Unlike write-protect mode, every access \(em read or write \(em to a
+protected present page generates a userfaultfd notification.
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
+To register with userfaultfd read-write protect mode, the user needs to
+initiate the
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
+After registration, the user can read-write-protect any existing memory
+within the range using the
+.B UFFDIO_RWPROTECT
+ioctl where
+.I uffdio_rwprotect.mode
+is set to
+.BR UFFDIO_RWPROTECT_MODE_RWP .
+Read-write protection only affects pages that are currently populated
+in the range; unpopulated addresses remain unpopulated and fall through
+to the normal missing-page path on first access.
+.P
+For anonymous mappings, protection is preserved across page reclaim
+(the marker rides on the swap entry) and migration.
+For shmem and file-backed mappings, protection is dropped when the
+backing page is reclaimed and must be re-armed by the caller.
+Protection is also
+.I not
+preserved across operations that explicitly drop the underlying page
+.RB ( "MADV_DONTNEED " "on anonymous memory, hole-punch on shmem,"
+truncation of a file mapping).
+Callers must re-arm the range with
+.B UFFDIO_RWPROTECT
+after any such operation.
+.P
+When an access fault happens against a protected page, user-space will
+receive a page-fault notification whose
+.I uffd_msg.pagefault.flags
+field has the
+.B UFFD_PAGEFAULT_FLAG_RWP
+bit set.
+.P
+To resolve a read-write-protect page fault, the user initiates another
+.B UFFDIO_RWPROTECT
+ioctl whose
+.I uffdio_rwprotect.mode
+has the
+.B UFFDIO_RWPROTECT_MODE_RWP
+flag cleared.
+This restores the original VMA permissions on the affected pages and
+wakes any blocked threads (unless
+.B UFFDIO_RWPROTECT_MODE_DONTWAKE
+is also set).
+.P
+If
+.B UFFD_FEATURE_RWP_ASYNC
+was negotiated alongside
+.BR UFFD_FEATURE_RWP ,
+the kernel resolves access faults in place without delivering a
+notification: page permissions are restored automatically and the
+faulting thread continues.
+Callers can later reconstruct which pages were touched by inspecting the
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
+ioctl, which lets a single userfaultfd switch between async detection
+and synchronous eviction without re-registering the range.
+.\"
 .SS Reading from the userfaultfd structure
 Each
 .BR read (2)
@@ -531,13 +661,17 @@ If this flag is set, then the fault was a write-protect fault.
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
@@ -640,6 +774,16 @@ Linux 4.3.
 .P
 Support for hugetlbfs and shared memory areas and
 non-page-fault events was added in Linux 4.11
+.P
+Read-write protect mode
+.RB ( UFFDIO_REGISTER_MODE_RWP ", " UFFD_FEATURE_RWP ", "
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


