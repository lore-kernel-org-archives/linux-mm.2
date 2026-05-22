Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548A4CD5BB5
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74146B00B5; Fri, 22 May 2026 09:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF526B00B7; Fri, 22 May 2026 09:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885A36B00B8; Fri, 22 May 2026 09:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 664746B00B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 341E0C2ABB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:55 +0000 (UTC)
X-FDA: 84795163950.22.6C6B546
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2693A160006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y KVD0Pk";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=G3hnXIQo;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6f33nVxWenecAKHuGCYX/tM08lTeil0fVmlJgDKyP14=;
	b=X2+U6EBthoHndAPe0re1xHCJg4Mh5Xz8qoRzdAWE5vaiL7Dlrg95BQqWrs3ulekaaZh9o8
	2it2ujhfF0y6bqFOcJ+WHqRhfEdw4xEQL8eBTAOfn7EoEIyM/dHcZS1FbSOzeHM+bN7rdy
	kzZeFYUcYS38jLdUm6qI1w65rRuSvOE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y KVD0Pk";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=G3hnXIQo;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457193; a=rsa-sha256;
	cv=none;
	b=XBTqOd9XcTRBh8by51/cIYFdmuFWZVinaguTEwVhaWasfufCNDOfiwjGUuM43dDjymG1vz
	iIts+ibrtxl6L3SLUG6bG9EEVY94Pum62cQBBmGCsOpohz+ew+uVqimoxJRGAGZGnvm5RH
	ZLLpljanRJqvWwipCRCEFpldPPyoLH4=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id EDD3B1D0007E;
	Fri, 22 May 2026 09:39:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 22 May 2026 09:39:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779457191; x=
	1779543591; bh=6f33nVxWenecAKHuGCYX/tM08lTeil0fVmlJgDKyP14=; b=Y
	KVD0PkmfqRxwatoU5rNl5Xma/HNhtXw0Yz6QlpRXqghQWK628IuyESKrrmaOENjy
	uWj3fRGWoiJ80fyqJDwf6r6v8b4j85bGpCFXnGattnMvepge0SokqWXOlSxFOM6y
	4/QwA0gl9uSFxbeUVLWCNUM4uJJyje/GRgHLrvC7W5XHqSOKGxWKAUvqRHSfCvvE
	sK4M83K/g6Xlw5rkGYhARHTux8gqMy+W93akKoa9izpyyGJWQVe7w+4IckI5DRmO
	uKhS8aJhz9wMQayAyFF04Ux79U5Fc31jArFTt/NgzWk72aTc1mfAcK2OJfxTM1pO
	9xnzaaQyGp7BFOHQpYRnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779457191; x=1779543591; bh=6
	f33nVxWenecAKHuGCYX/tM08lTeil0fVmlJgDKyP14=; b=G3hnXIQomGxQpiG2/
	YFEaBDm0T1LQG3WbeVDK+p3At83gdAXPZS8lWj7HvQGzE5mgtGCVRYSvhzza8+Y9
	FnnhSat3HWQNRaSQqvQrjmv52EYLCBf6Lzo4/myWV2DdkuvOnoAGcepaKrCA3Wtq
	NL7nZ3QkrHXG0OWiEDHoBLsRd97fQ65Je+uQDCBMM7B08mshxNw5p3apxOVyA4qU
	KSvjfDDEK1Lp8DjxZiqe5bmSUJ1ZB9kJj7Rl9l1k2FKpoafCBQdq113JbfFaLzPe
	LZCnw3GGpp7MYy4Zg7G33yw7Uv2Cs+DyiAYmQRg/0v5JVccgsahfgMXfuo6VGJF+
	dG4LQ==
X-ME-Sender: <xms:p1wQar8vkn5I6zyKzsCWsJYnMvWBTRN_m1slQ6_xzhyfNypVlUBTPg>
    <xme:p1wQaoyl6MjJs8FnbsRpy4iLeohzTMEIOhjT73VpWvyMTAF3Kn_yWdebBd-0J5ZXV
    1XWqL54wxEPYRz6MnuxzkyDAM9DHeqxJDvLQnbHJhRnOCvUuum6qLA>
X-ME-Received: <xmr:p1wQar8ZYssG4l_EauFiCSgCljjSMsHt--Hlh8Ws0btnqrx9n1KziiIaDP0Lwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhhirhhilhhlsehs
    hhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpedtteefjeetgfdvkedtfe
    eftedthfehvedukeehudeikeeutdfgiefhvdelkeeufeenucffohhmrghinhepfhgvrght
    rdhpihgunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedviedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegurghvih
    gusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrg
    gskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthes
    ohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:p1wQalLW1GwubAkuhLOl5FQz8hwZEds5kwRutzURfsDsbtWk0FQ_kQ>
    <xmx:p1wQao-oFV0yWBSyEBn_zpKImyJLAOC4Yu3lO6eH-7tOVIGvmT6hzA>
    <xmx:p1wQapHXwecV9q0ZKuMnJtc8AJb9MpbJRW460lA6al8WgUjdbBZE9g>
    <xmx:p1wQagNnpXd_fnYP75NrIT19vRdX44DAHi1ZSf2qbGQXIcFhw2OFAw>
    <xmx:p1wQavyXHZDz4xtHM6xuedLXBTMHcXT2h1y_zwWiqQFrpmDuAmMZhZK3>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:50 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	linux-man@vger.kernel.org,
	alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v3 15/16] userfaultfd.2: Add read-write protect mode
Date: Fri, 22 May 2026 14:38:56 +0100
Message-ID: <20260522133857.552279-16-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522133857.552279-1-kirill@shutemov.name>
References: <20260522133857.552279-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yt9a3uiqmye34ta8mea79qzr139euhmi
X-Rspamd-Queue-Id: 2693A160006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779457193-271099
X-HE-Meta: U2FsdGVkX19BZhK+15l9knaFrfhgk+jnTTRJl8G/+t2Hgnlc4ApejWniKr+xnOshAvKhBUsN3GiMr0k3FyszhSHekP5TqQs68FvvpboQD9AneNC+XXoIv4XhKd0ggL9bs54hME4wqCB8g2VCpFGRPr36MfU1VfQoiZ6BbBoOPtM/Tk54N09KShwpCmhENZXhoD/JZdlz8zfYseoTX0vPnLDwYNiaG7J6I+yNIKlvmss8Uw84MhU0c+aIe+LouGv+d4IF4ijGNt7Vh7WKcZ+VWEMMeGBvFtp49gBU1HeM/ZBVq19y5UdxZzb9RwCCp8QFeDP9aAZg9Cymxg2Xh2OKdJ04W5ughojKzKtUYXFqBQJ4OCqJRpTTbwO5zqn1RXQwD99u2LjJ2gb2Xnc+hBpBjDqBVmPfQ5tKeJk+A5slSVSroNS6QDxXrOl9N7VvXB9nN1AFFUT1J5CL+DqsZ7xyYnSYqQFv+7JoyT2NgsO8iihwUgjjEDGLUgdQ72GIONNHZcHC9wdeK06Z15O23y5t48DA48Dr2MWDMgm1mxSGP24xBsi7U4SyYj9/OsVwmihUBn3CaAhYY/TNOSS1R4WXKzJmNBlp2tfIA+P8uBxRKbSWeL2PEGTDrWm3xvPb9PsTYqBu2g7YwsOyPqw59SCTZbKgtj1VEdwzb0ZNMgCZI5jYsWl+cdV9uy6snUG+EVrIRMgnShGBmupn1ZWoJloWdhRrg2KZJJGiAjaZOT2rV8ONo+7axmsOEVe2IC+fjv4D7EE44zR7JQbMMrupWz3n6zFV+COxLYhByeBfCwWzoF5/DGUk0L/ayD4lvw8bwlh8qBspRehSpKIC8VaxE0mG4QrG9yXV2kORYjJ16GbXKIh+l5+Fd605fsAlsIFwGrCx3u1SfpgoD98BXRNKudplVVIlgW+UCdv3uUKacYB/gh17XPQ7W472n7LJtbsdh4Rn+7JDzKebxGTNr/jBHGS
 nykpGH6G
 5EVayRfSS0IEJOdALEZMJ1497s/NEjjC3GhP1bn+7sOy39WJ+l7yN2Nl4DEHmiTkMq2OyPoznFHRSvPamdBcfCVYjyh+SkkdvDEpVnEtedEGXClw1qF0CT0Esi1nJGHd392j6tkEgWK0Mt/JdWbD6pSCqXKEkwdhxyy0HaT5RGIL733T5sWuWBEdgKVZBh4XA3oOUQgksBjyUxRW59rmpUR01xsxUQqj0Mr4li2CsCfA6JSaBnb2kz8CqraFAxHuaAEUOaTjt+H1qLk69jk5h1Yxj3OnqWJ79AvfZfhU2v+tuSso7s6h3KBJ0/EtPLOZcZFm/34o6E8LKv5Q1lL0+/eerTD6kqXEOaw+eDpMotT1HyEFPLEcEtsP7jx84+8mJhJGbLxjdopoB/f6LXtirSeev8BWLohlIfzRznBXj+C/UyMbfBYnbytoqXeVnKikyzeQSvT6gShOTt/s=
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
 man2/userfaultfd.2 | 147 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 1 deletion(-)

diff --git a/man2/userfaultfd.2 b/man2/userfaultfd.2
index cee7c01d2512..0e702f2f4969 100644
--- a/man2/userfaultfd.2
+++ b/man2/userfaultfd.2
@@ -24,7 +24,7 @@
 .\" the source, must acknowledge the copyright and authors of this work.
 .\" %%%LICENSE_END
 .\"
-.TH USERFAULTFD 2 2021-03-22 "Linux" "Linux Programmer's Manual"
+.TH USERFAULTFD 2 2026-05-22 "Linux" "Linux Programmer's Manual"
 .SH NAME
 userfaultfd \- create a file descriptor for handling page faults in user space
 .SH SYNOPSIS
@@ -105,6 +105,28 @@ The faulted thread will be stopped from execution
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
 .PP
 Multiple modes can be enabled at the same time for the same memory range.
 .PP
@@ -186,6 +208,21 @@ The user needs to resolve the page fault by unprotecting the faulted page and
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
@@ -322,6 +359,98 @@ should have the flag
 cleared upon the faulted page or range.
 .PP
 Write-protect mode supports only private anonymous memory.
+.SS Userfaultfd read-write protect mode (since Linux 7.2)
+Since Linux 7.2, userfaultfd supports read-write protect mode.
+Unlike write-protect mode, every access \(em read or write \(em to a
+protected present page generates a userfaultfd notification.
+It works on anonymous, shmem, and hugetlbfs mappings.
+.PP
+The user needs to first check availability of this feature using the
+.B UFFDIO_API
+ioctl against the feature bit
+.B UFFD_FEATURE_RWP
+before using this mode.
+On kernels or architectures that cannot support read-write protection,
+the bit is masked out from
+.I uffdio_api.features
+on return from
+.BR UFFDIO_API ;
+callers should inspect the returned features and fall back to another
+tracking mechanism when the bit is absent.
+.PP
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
+.PP
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
+.PP
+Protection is preserved across page reclaim and migration; it is
+.I not
+preserved across operations that drop the underlying page
+.RB ( "MADV_DONTNEED " "on anonymous memory, hole-punch on shmem,"
+truncation of a file mapping).
+Callers must re-arm the range with
+.B UFFDIO_RWPROTECT
+after any such operation.
+.PP
+When an access fault happens against a protected page, user-space will
+receive a page-fault notification whose
+.I uffd_msg.pagefault.flags
+field has the
+.B UFFD_PAGEFAULT_FLAG_RWP
+bit set.
+.PP
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
+.PP
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
+.PP
+The async mode can be toggled at runtime using the
+.B UFFDIO_SET_MODE
+ioctl, which lets a single userfaultfd switch between async detection
+and synchronous eviction without re-registering the range.
 .SS Reading from the userfaultfd structure
 Each
 .BR read (2)
@@ -473,6 +602,12 @@ If the address is in a range that was registered with the
 .B UFFDIO_REGISTER_MODE_WP
 flag, when this bit is set, it means it is a write-protect fault.
 Otherwise it is a page-missing fault.
+.TP
+.BR UFFD_PAGEFAULT_FLAG_RWP " (since Linux 7.2)"
+If the address is in a range that was registered with the
+.B UFFDIO_REGISTER_MODE_RWP
+flag, this bit indicates that the fault was triggered by an access to a
+read-write-protected page (either a read or a write).
 .RE
 .TP
 .I pagefault.feat.pid
@@ -574,6 +709,16 @@ system call first appeared in Linux 4.3.
 .PP
 The support for hugetlbfs and shared memory areas and
 non-page-fault events was added in Linux 4.11
+.PP
+Read-write protect mode
+.RB ( UFFDIO_REGISTER_MODE_RWP ", " UFFD_FEATURE_RWP ", "
+.BR UFFDIO_RWPROTECT )
+was added in Linux 7.2,
+together with
+.B UFFD_FEATURE_RWP_ASYNC
+and the
+.B UFFDIO_SET_MODE
+runtime mode toggle.
 .SH CONFORMING TO
 .BR userfaultfd ()
 is Linux-specific and should not be used in programs intended to be
-- 
2.51.2


