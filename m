Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE3C7CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5506B0092; Fri, 22 May 2026 09:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59EB46B00B7; Fri, 22 May 2026 09:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4194A6B00B9; Fri, 22 May 2026 09:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 266006B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4C9F1C1FFC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:57 +0000 (UTC)
X-FDA: 84795164034.09.2D97103
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf15.hostedemail.com (Postfix) with ESMTP id EED0DA000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="0 6PiO8p";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=EPJyAb55;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kgK2B7CSrKKlV7MAxGh/B0N2F/JYv53qwBfZJ+EZP0=;
	b=GDvCFXxUkhuRIoDCMpZr8rdpqOgA741w64CW/DDlU4DSSgggLU9j1R/9lxWzAtx0ozXhpw
	qskp8jK7rPORxbAJahdhT5xYdsgyx9hokFlGPm/IyBtf0a4K8Vz7drl8XI8iWR4DiqtD2M
	EqiKWQheZcHjurOoc4JHq3MnSQhgOf0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457196; a=rsa-sha256;
	cv=none;
	b=zwkkqxgCTZG1hTXv7zc9Uu3immfRSP9xLEqUgv2h4BGPaYKNNs4eTchi/MM6qyUqPdQH0R
	DRYaS2fQ2agSv7oimMQja1Y15vg81uSsTiuagMcK44BoVMQ4F2hsrKYBUu0kVx6I2iBBg/
	ej/Lws9nnELWEOidECGCT0+muEUnXQM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="0 6PiO8p";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=EPJyAb55;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id BB5291D00121;
	Fri, 22 May 2026 09:39:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 22 May 2026 09:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779457194; x=
	1779543594; bh=7kgK2B7CSrKKlV7MAxGh/B0N2F/JYv53qwBfZJ+EZP0=; b=0
	6PiO8pjoX+s75ZiHT4qw7ynCfBAjDhdjyUKwJsfr7BZ0gE8NoFBsAnbjHdzFdlzb
	ZMyrOFE4yR6XKstdv9fcpUtUbHwYqdl1C9yq510gXBJAULoTrVZrGleEL2aXV9z/
	3IOFF9X98wQCb+xxh68/DzIWouZyrT6LKRJyJHniNUQm5EamBiy+2nYtiNxEFB+y
	g4HfCf/N6bK7R93iadLzUQ0+kDwbjwJeCDGqRjFSyMrFw1T0JSxQAhof8T1+vyDq
	OerulQQvls5bQdM1Dbhy4G7+rl3+vd8L6jcwmqBCVeto97J3IgGGa6sAWM1pmIn8
	z228SWGpnB6cPHhQyeRKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779457194; x=1779543594; bh=7
	kgK2B7CSrKKlV7MAxGh/B0N2F/JYv53qwBfZJ+EZP0=; b=EPJyAb55jbrqUpgHF
	VjM2SUqz+yHoRy0qmFHa3mWQfnINHDJV2LKa4/Y+sSdwW+3GpDrtoA3tmIOxUi24
	LUnDrx8JDg24H9sgaLWGNBBTuix8Q27mMFRybJsOds5Xor4sC1S1lC1+tq4vGSP+
	vJ0PM+X2obTz7CE1cNeHjmNM+lZ19ZqgbOlpgP8Pk0M/4Q6DL9uY+NHQQjrGkyhl
	MGqFFOOsFMOhJ6ug9JwgvQRxdFvbtVOKAtLeSG3vPYeOm4gzwymMxfURJCVGEIhO
	/m5n8pkNywjMclMmalDlJgvEj9OkZsDWE1AeTTjnWcRPKNF0EB5ofjEDQP+fMgYG
	N1OcA==
X-ME-Sender: <xms:qlwQak0NWdRdzMMRRhBcLctEC-UwSXMnplLDesFGAqJAAnv5A_ZD9Q>
    <xme:qlwQagKPilxv-Y8vENSqGgJxDmYomUnWBYjhbmpGsAkBPKoo-ptNyE-G-2MJka2NP
    mdA-qQBlHOEpSXOmM_scTU6Hzw_d4b9KjmOgmxgLhUlQ4hXFhA_mFc>
X-ME-Received: <xmr:qlwQav2E2quj6ShYPo2Ggyn91TfgO8Xrpl8ovXTmHdMjWwyP43yZmW-HqA0mkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhhirhhilhhlsehs
    hhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeegveehtdfgvdfhudegff
    euuddvgeevjefhveevgefhvdevieevteeivdehjefhjeenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:qlwQargznNHXXEFSIkuyq_USe5H0wAPhBVJSQ3wQGvrW4C84--XX4g>
    <xmx:qlwQav0Q6vGaOaQu97ctfou2QxG2ad7owUQcAHzVx2yBqAvSKUXiXQ>
    <xmx:qlwQamcibcUSyR4rL0Kq1iCbCA-YAZBWEbE90Va-f5wRkbr1_mUL4Q>
    <xmx:qlwQaiGIGFAb7FTMrwdj44FhyhR9gcsYiOWrFXt7qdeCyChTCJjCbQ>
    <xmx:qlwQakpTcmTUhwg5-1AFaemuUZptVOLso8tO0fFLIxmOXJjOzxXGTCfX>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:53 -0400 (EDT)
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
Subject: [PATCH v3 16/16] ioctl_userfaultfd.2: Add read-write protect mode docs
Date: Fri, 22 May 2026 14:38:57 +0100
Message-ID: <20260522133857.552279-17-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522133857.552279-1-kirill@shutemov.name>
References: <20260522133857.552279-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EED0DA000B
X-Stat-Signature: cznwnh1oyoykg7qk3b8en76r46ino6r4
X-Rspamd-Server: rspam06
X-HE-Tag: 1779457195-930137
X-HE-Meta: U2FsdGVkX1+hHPPO9ckGddiqz5dET3+PndJwkoz9SWW4gcQr/99RqrYcI3WegZrgGE9wrXpqX+yr4laPbkJdBhmIC7mc9H4Daiv5KDj3fTRdSQy5aHV3OMVJkF70VNsMZu4bGnKMr8M7tA1Nli3h1hnypS1Fw7QZSIFfn3qNRBizncONmP0Lfba3FeyXXM4sNvuN3HTBLj6FyDsrSHbolf3Gw6QMM+mNfYW0CUBcNYJmk46YD8mTkOLrjDgdC3yno5AQIuNIU0poM0dkCJa/xDFxkGzqqPiKDJcb+R6VQNMhAHlEjE78xJ/UwDG643dZaGreysQ80mxV0y+qTiW4zHcQXowyClEyjX9BrMWgCkB2CNHRTbCMSzn2HM4e+dY9eZxhoqz+57vI7NAew6De0UpOOI8SMxkjUnDWK8/d4sbUu3CuHLPeGXgSLlbrp5Dn7JjhL1xXZ70qal/cMv0dnRURuVN597LmlFwLVMB+Z940lc4c+AE8+kbGxhfn/p0VdtmL9m9txOUhmdE3mj/svEaOVSxq2ovkRb+7n08QYZxgJ2Bk3PLvvyHeaLCfjmw3C4BWwWilxAYAYT+5SeQuK5tuumLjZsd96YTQC7mTUV/PIGoMA74ExJhYxr3yrd9xvtlCebmHxxmIxolWn2k2cwqlifOb8Cn3F2SidwqsVcy8MN/Q2YcIVwcSxVXAllSZqbArDY+4cIArpM9elWxdC6XE4nAQsTGIzP0xmkKKWIliYykFaMRPkk50z5VqBCgZyH0nCakXAp4OpaWHZKNhP0LAJAqIqbbbB86FaSUA7qw4/G+hApRPBs5ZpfJ4GJPiGCo6YpxIr73i5pfzVCFONzjpjODosOG5WGS0ZPnbKqEHyHjUlg3M5hMc6rfgk+MhWUAqYpUm7SioQidfq4Cp2bwVLCTY3C3HNHaMaMCzkclfledD4RASQeLcvOnD89OJlGNz4IxmvorJ38jUjXz
 1FS6uPDa
 UbHf8BCWzwzyXoHS7OI9rp91DQ54HPzRvBha0Ma5E+Ytr79IpeXIRhjxT+P57ghsweGLa9XO5wPwWGXOKwsWQmeJytp6jKLvcAMUNKdR3Wrdg8KoTS7OnC+9jYRf0xHtOAdlq1KXsda4igTa0hklcKvcEQIaPfecWiaHXSM7+0E56clza1irEE0MP3sYH++joY2a1Otyt060f2CIxicDHxETEW+WI5KyfAJNoE7FfywcA6lIPXsH2oeF7jGDWLWQipuh2q7BBts+uTKhtmLghJ5iB7QXP7hORj1HK8jc/9MIbVgav3W5Az1Ue3/YlIhom1EVPzlPdagkypt/Y6scJ5a9pKP+0LMBOS6/vSKxZkrE6CywcnuM/nkPHYiEV/TFR6eJ2AS8duDcfhAX3+OiCWx65JCFoRTBot+wgFKjR4DLEw+QOOv6rNBBR4i2voA2WEJR3Mar90BGcuDBt2dZGNrNfpuHlg0HVDDs3MdaMkAPlH6txUTksPs3ArQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Userfaultfd read-write protection (UFFDIO_REGISTER_MODE_RWP) is
supported starting from Linux 7.2. It traps every access -- read or
write -- to a present page within a registered range. The new UAPI
documented here:

  - UFFD_FEATURE_RWP / UFFD_FEATURE_RWP_ASYNC  capability bits
  - UFFDIO_REGISTER_MODE_RWP                   registration-mode bit
  - 1 << _UFFDIO_RWPROTECT / _UFFDIO_SET_MODE  available-ioctls bits
  - UFFDIO_RWPROTECT                           install / remove RWP
  - UFFDIO_SET_MODE                            runtime sync/async toggle

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 man2/ioctl_userfaultfd.2 | 209 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 208 insertions(+), 1 deletion(-)

diff --git a/man2/ioctl_userfaultfd.2 b/man2/ioctl_userfaultfd.2
index 504f61d4b0cd..0a24a77ca32b 100644
--- a/man2/ioctl_userfaultfd.2
+++ b/man2/ioctl_userfaultfd.2
@@ -25,7 +25,7 @@
 .\" %%%LICENSE_END
 .\"
 .\"
-.TH IOCTL_USERFAULTFD 2 2021-03-22 "Linux" "Linux Programmer's Manual"
+.TH IOCTL_USERFAULTFD 2 2026-05-22 "Linux" "Linux Programmer's Manual"
 .SH NAME
 ioctl_userfaultfd \- create a file descriptor for handling page faults in user
 space
@@ -214,6 +214,33 @@ memory accesses to the regions registered with userfaultfd.
 If this feature bit is set,
 .I uffd_msg.pagefault.feat.ptid
 will be set to the faulted thread ID for each page-fault message.
+.TP
+.BR UFFD_FEATURE_RWP " (since Linux 7.2)"
+If this feature bit is set,
+the kernel supports read-write protection tracking, and the
+.B UFFDIO_REGISTER_MODE_RWP
+registration mode and the
+.B UFFDIO_RWPROTECT
+ioctl described below become available.
+On kernels or architectures that cannot support this mode, the bit is
+masked out from
+.I uffdio_api.features
+on return; callers should inspect the returned features and fall back
+to another tracking mechanism when the bit is absent.
+.TP
+.BR UFFD_FEATURE_RWP_ASYNC " (since Linux 7.2)"
+If this feature bit is set,
+the kernel will resolve read-write protect faults in place without
+delivering a notification, automatically restoring page permissions and
+letting the faulted thread continue.
+This bit requires
+.B UFFD_FEATURE_RWP
+to be set in the same
+.B UFFDIO_API
+call.
+The async mode can also be toggled at runtime using the
+.B UFFDIO_SET_MODE
+ioctl described below.
 .PP
 The returned
 .I ioctls
@@ -240,6 +267,21 @@ operation is supported.
 The
 .B UFFDIO_WRITEPROTECT
 operation is supported.
+.TP
+.BR "1 << _UFFDIO_RWPROTECT" " (since Linux 7.2)"
+The
+.B UFFDIO_RWPROTECT
+operation is supported.
+This bit is reported only when
+.B UFFD_FEATURE_RWP
+was negotiated successfully.
+.TP
+.BR "1 << _UFFDIO_SET_MODE" " (since Linux 7.2)"
+The
+.B UFFDIO_SET_MODE
+operation is supported.
+This is a file-descriptor-level ioctl and is reported once per
+userfaultfd, independent of any registered range.
 .PP
 This
 .BR ioctl (2)
@@ -327,6 +369,16 @@ Track page faults on missing pages.
 .TP
 .B UFFDIO_REGISTER_MODE_WP
 Track page faults on write-protected pages.
+.TP
+.BR UFFDIO_REGISTER_MODE_RWP " (since Linux 7.2)"
+Track page faults on read-write-protected pages.
+Every access (read or write) to a present page within the registered
+range generates a notification once the range has been protected with
+.BR UFFDIO_RWPROTECT .
+This mode cannot be combined with
+.BR UFFDIO_REGISTER_MODE_WP ;
+attempting to do so returns
+.BR EINVAL .
 .PP
 If the operation is successful, the kernel modifies the
 .I ioctls
@@ -735,6 +787,161 @@ or not registered with userfaultfd write-protect mode.
 .TP
 .B EFAULT
 Encountered a generic fault during processing.
+.SS UFFDIO_RWPROTECT (Since Linux 7.2)
+Read-write-protect or un-protect a userfaultfd-registered memory range
+registered with mode
+.BR UFFDIO_REGISTER_MODE_RWP .
+.PP
+The
+.I argp
+argument is a pointer to a
+.I uffdio_rwprotect
+structure as shown below:
+.PP
+.in +4n
+.EX
+struct uffdio_rwprotect {
+    struct uffdio_range range; /* Range to change RWP on */
+    __u64 mode;                /* Mode flags */
+};
+.EE
+.in
+.PP
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
+.PP
+Read-write protection only affects pages that are currently populated
+in the range; unmapped addresses are left untouched.
+Protection is preserved across page reclaim and migration; callers must
+re-arm a range with
+.B UFFDIO_RWPROTECT
+after any operation that drops the underlying page
+.RB ( "MADV_DONTNEED " "on anonymous memory, hole-punch on shmem,"
+truncation of a file mapping).
+.PP
+This
+.BR ioctl (2)
+operation returns 0 on success.
+On error, \-1 is returned and
+.I errno
+is set to indicate the error.
+Possible errors include:
+.TP
+.B EINVAL
+The
+.I start
+or the
+.I len
+field of the
+.I uffdio_range
+structure was not a multiple of the system page size; or
+.I len
+was zero; or the specified range was otherwise invalid; or an invalid
+mode bit was specified; or
+.B UFFDIO_RWPROTECT_MODE_DONTWAKE
+was specified together with
+.BR UFFDIO_RWPROTECT_MODE_RWP .
+.TP
+.B EAGAIN
+The process was interrupted; retry this call.
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
+.\"
+.SS UFFDIO_SET_MODE (Since Linux 7.2)
+Toggle userfaultfd features that may be flipped at runtime.
+.PP
+The
+.I argp
+argument is a pointer to a
+.I uffdio_set_mode
+structure as shown below:
+.PP
+.in +4n
+.EX
+struct uffdio_set_mode {
+    __u64 enable;     /* Feature bits to set */
+    __u64 disable;    /* Feature bits to clear */
+};
+.EE
+.in
+.PP
+Bits set in
+.I enable
+turn the named features on; bits set in
+.I disable
+turn them off.
+The two fields must not overlap.
+Today only
+.B UFFD_FEATURE_RWP_ASYNC
+is a valid bit in either field; any other bit causes the ioctl to
+return
+.BR EINVAL .
+Enabling
+.B UFFD_FEATURE_RWP_ASYNC
+also requires
+.B UFFD_FEATURE_RWP
+to have been negotiated at
+.B UFFDIO_API
+time.
+.PP
+The toggle takes the per-process
+.I mmap_lock
+in write mode, ensuring that all in-flight fault handlers complete
+before the new mode takes effect.
+This allows a single userfaultfd to switch between lightweight async
+detection and synchronous eviction without re-registering its ranges.
+.PP
+This
+.BR ioctl (2)
+operation returns 0 on success.
+On error, \-1 is returned and
+.I errno
+is set to indicate the error.
+Possible errors include:
+.TP
+.B EINVAL
+A bit other than
+.B UFFD_FEATURE_RWP_ASYNC
+was specified in
+.I enable
+or
+.IR disable ;
+the two fields overlap; or
+.B UFFD_FEATURE_RWP_ASYNC
+was requested without
+.B UFFD_FEATURE_RWP
+having been negotiated.
+.TP
+.B EFAULT
+.I argp
+refers to an address that is outside the calling process's accessible
+address space.
 .SH RETURN VALUE
 See descriptions of the individual operations, above.
 .SH ERRORS
-- 
2.51.2


