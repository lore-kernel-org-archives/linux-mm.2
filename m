Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85AC6CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1871F6B009B; Mon, 25 May 2026 08:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09AC96B009E; Mon, 25 May 2026 08:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECCCC6B009F; Mon, 25 May 2026 08:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0A0F6B009B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:28:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9CF71A023F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:34 +0000 (UTC)
X-FDA: 84805870548.17.A5087B1
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf23.hostedemail.com (Postfix) with ESMTP id AF3D714000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="j /8/1yY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=k8W8e66r;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779712112; a=rsa-sha256;
	cv=none;
	b=ermYOX7hBwB4GQSPXwW/WO1h4dB/0m4F/x+vnf2BZoWFsKHlEYcA9xXX0XzA738F/WMQwe
	iWPwYgRytbDL8+CzEml3unPSca0k9LkbfXDRu24YQLBRbmWdw3dP4y8PTMteVs+shCaROn
	zu0NrZqM7AJ8pBp9GL3hdmMRfLYeYh4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="j /8/1yY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=k8W8e66r;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779712112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWAtVzL13T+cD671ds/HWNR7tnLl0jiU3ofJvVua5e4=;
	b=viYo8iyfUF1bz5gHQ1kXZGPQWhvJ6quAeJESoN2Ij1ZhScLqPge0T4R+ZYyWvwm7rTqASg
	LuSpWwd6DTr7EWFCDg9Ncr/z8DrUs8JcTLqOLCqfVjkU4uTA29R/g3nXcqHXCUV+F/2kWv
	nJRjebkANVk5rL7IGTBqVK2I4z8Mna8=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E82E97A00CF;
	Mon, 25 May 2026 08:28:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 25 May 2026 08:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779712111; x=
	1779798511; bh=oWAtVzL13T+cD671ds/HWNR7tnLl0jiU3ofJvVua5e4=; b=j
	/8/1yYNg/Fh1rNb3qT3qSnfhFjiB6ZU3jvkDxbhJW4fz02RbwiADXmVAxEuo3NOa
	gtCSaycKTOuw3M/t8bSUs/Kx2h0/ZehnSYlYO3/zNKMKY+2U3BbCLEkPehAKj1jL
	OOX4Sbz70ZZlfTXp6uV+ueUk0579ax1bidw8uAm3P4jT8vVChhDqTmEBKq2JIF3g
	lE+oSnbeliy9E2jvvDXGV0XIBgirtu5xq/FbLysmj9RrqTg+YX02p7kX1QqSCTyY
	0P8fq//9u3WD/QC5npIev01+4PMIeUk4iCd0Mg+M5ZTwS2SNYMRjWR8sGbV0euai
	HqZ2uMucf4Un28IOzzVSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779712111; x=1779798511; bh=o
	WAtVzL13T+cD671ds/HWNR7tnLl0jiU3ofJvVua5e4=; b=k8W8e66r5xQPhQctj
	/UaGYkqTjRrd7qm2moxOkdM+kxW1uvnnziwSsewFHKBNRTfcp3atzbmV0CmjyRYj
	M/C0y7r2kRoiTuqmwvvPdZOewTthrU5QpdV+ahNuYx9hMjkqyvnnL228vt7LH9SS
	fIQC9Vj87EQROahCw4Az0eWK4YzE93DA/ItLBy6XQ+c+bdqDtChVzkmKHSuslOoj
	4cwriTZ3DZbBEsovVNUAS/372Bx/DaGezYFK06aybcgDwVNQZt4ylbuChigIsWjT
	nACIZKcTSzvhKpiT27j+5ehATsGQ+f0t28PJ7mpbwChtqTVQbfQ4wAyvA2OqAhsF
	kY2/A==
X-ME-Sender: <xms:b0AUatRbdCqQZn8Tnh7qIJIq3H1mwIIJWmw8LR-ZIdDeH4CFSv2jRQ>
    <xme:b0AUajV4R5Uy6EHT5FWWWqF82yTSAmY0ULT4dEJ9ZM-8jFHK-sPRnotJtOqToGG11
    MmaNgNUPvaWT_KFzQlVMGkDr_vwHdT7oCbnV941f6NDo-phbeiyDQ>
X-ME-Received: <xmr:b0AUanQF8P-NGEXea0btlWMoHAsOcziLM5A5lxuAI3F-CQbwWSgxMSZO8VXfxg>
X-ME-Proxy-Cause: dmFkZTFmLVSfYhEWaVm8N1lz0MjOBghKLhOnNQasw0tsXAFLPpbR/4+mrCYwWk/E423Vc2
    6B1s9iPuQgs3hGAiq/KhPqohuBMRIerNkWvsfuc3WkOHbHUNY5UmaGor5ig336hIeD+vak
    qB6bs2DTG0sfepDSzSArpLeFa7+n1qOspSUGgNQVB9KbSSFSgvHhLwD2o5NL2Su7Xc1htX
    UOwFpxHBdUGOki2ZYo2cYxe64jTF4NfawVkw4Ja9Vghy7E0XBO4BxqVYRhKiY6uJ4G3d/o
    hkvinoVmY3c44Mzh6S5sf4JfJ6aY+LIcesX0uapyNnoENtY2BlNnzIGDNJPpi4n9s/a/cp
    dGIPzZRA64G4ZAIPAYLfRN6pIEXS0Yp6q9bnSVTyiM3X7+wx6l7WNFtMGwKRe9tCQ/kLqQ
    16PuD5AigcCzgUkTq5xSKcL9CbeTh5Be3as4zl8Oa2dmAVcT0Y7i3Dwgb668+yVPQhnF6Q
    RqZC8FzAykAzjD3Niqbo1pFLQEGONQ5nppa1MuTzW/2h8guwKHJH8hAC3WJmLyOH/RxCLx
    T4P5KpQsUyqkoIi5wPYmJql2fvJJjcowv7vkRVm+0qpLMcmKrtGcolVV9zpe84a0H8bcY+
    NhwGHm7YlTzeq+mW1or0u+T9O3qtlz/D0TX8HjBmGPSpCaIhh0jPnKKqzTBQ
X-ME-Proxy: <xmx:b0AUar2LfW2WekHs58x5JjcrYW3JdqqhUXtySL_gTexMVl1DBstgtQ>
    <xmx:b0AUanclWn7MKKx6wEoRKe5fEr2XTezEKcAhRBIOCaMVL5ZW8IB8pQ>
    <xmx:b0AUajNVwV4iae7VE4OrSIpipxk__D_jcVE2kt76rHZ4L01cVt0Hlw>
    <xmx:b0AUarWBoWPO-zuBv19RaQW2eFCNdO_ztzM_Ty3FuNBO_UzIeWX3SQ>
    <xmx:b0AUaiOU78QRqKhiPDcg7kIDa0LlEdPqdbKuCjYSZ9VpUM_99yWLIZez>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 08:28:31 -0400 (EDT)
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
Subject: [PATCH man-pages v1 3/6] UFFDIO_SET_MODE.2const: New page
Date: Mon, 25 May 2026 13:28:13 +0100
Message-ID: <20260525122816.1956804-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525122816.1956804-1-kirill@shutemov.name>
References: <20260525122816.1956804-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AF3D714000B
X-Rspamd-Server: rspam03
X-Stat-Signature: zwb5nf4znqrm8sca835qri3w1mmswqz1
X-HE-Tag: 1779712112-980927
X-HE-Meta: U2FsdGVkX1//JUH0gxaOQgJr8QOQ15IIg7uPmiakCvd662Wo3QAzXQNWbR0SFWY+Bir4P/O0agkCHkSlc4RWP5VIXoyPzuzYSDHvF8EbSwJkjv+GssdCcre1Tvl0r8/b4Gq6NUs57sQnvXYfuiMF69wIo3wAij6i8regjs6s60Lp2easIIz3q6k7bzMPbe4CZwbavI5UCLk7PeKlIzp8uawhc+ZEFR5VS5xcs9c7D2K5Ww6t+0fB7r8kI8lgO/e/sQiEyOY61Gk5Z17l/ucM3LrnrOcEozexW5x2tu9zn9dgEDaimYj03xF0qxHgR0J1A8hjybsoMsnXIGKRIa/PxWIjI/Z9/3//MslFIcIyC2tBkmku4ssz+qcnQFTwKx5wcxH8RWlJsTl5Zx2js3DVF43e/YAkJnpEZxJvOmJ4djLdnReh4vwh4SMISEnRM6ZEC938JEfa5B6FpBb5Fi8ayMTRsClkXpAayzi3OCLJLPtqwIUrbTiNALBA85wL4neUFXI+k93r1YP7WMKhf4y0he9h1MpXMkMMwATpl0QgrisEI4sM9wzq0LOdpy7bLLWGKxhcu0nlX4Xe8ZJ/eHU7Xq9fbuMBbQasjOMKl2uvlchOQDSCpz8mN5dUIt283mcNRzHvUKUf7LGZZh9BMSo/bZ325fJ2o1YeYm+WkPFdf8zkDOpSia73xSFTj3x0lNaktqR338VpLX0EWd8RokB6V0Qyj6i+kjWKnDB1vaDtUy6Rf63lXG/ReWFemJPbKcEv33omxWv0g6hzzjOCFEEh24DPBZ/f4phoejiD6xSW6K1DZgxkNUtWYDE07mssAXHqdVn5d7WTaD5u+y+Ka6z0rl2PytUMB7zbaLENCMC1DhRdWDLUKfmizI5uyXRr+QpK6WnoEupruDlA0VUaXU10jSLY5qZoVcwbWWMr0Ou4i8iTJcncmRp40JEoeQ+muK/7g3zHKEpV2PdzJvrx62k
 9CJ7K8Nj
 OCyLz//iCOwAiQ040S9f56yiLVIrzOnu/KOMlHA8pa4CCo5IVX5j9ln5iHUICdPr0tFxn41doR1u3sa2+GKdBSJmAXmbeQsS+mf97YNLmhFadprgrf+F6mLbxIq0BdG2AxaBLRohozB/J5Vaqzol7lD25J/wbi8NdxHpZV0MkbIsmCpmlh8qhJxbIfIKHbAV2YlMZ3HK8EyuO6nMzZVenxZVyv9sj2w88eYe7HRUK9EVQZoEAEntXQIEuDAF3DIMa5Vx2z3I7cdsgtyAG4Ldn3832QcE6Pqgl1Wbn0hSLXVKpUYzE/xjJ4P1x5e/aZJV5paivDzn4qE0FG/Wc6at+OSCI+2QvYANA4oQJJoQYtUbzWo/qlpKiM51jcIab170AJY3vtchVqa3CX5IcWOBbzjiSX3mXi1W5ADpvSOWwQ1jMtpNZ41AusL8AtbZbl5CE8csYfAQ7nagXqiD7hY/oyfCJXRaYX5aB913KfUwhJUa4qNsiv1thAYcLqdqkkN0/KCMvDCDYK9d11Rz9tompsd5OVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the UFFDIO_SET_MODE ioctl (since Linux 7.2). It toggles
userfaultfd feature bits at runtime; currently only UFFD_FEATURE_RWP_ASYNC
is toggleable, and enabling it requires UFFD_FEATURE_RWP to have been
negotiated at UFFDIO_API time.

Describe the uffdio_set_mode struct (enable/disable pair, must not
overlap), the serialization against in-flight page faults that lets a
single userfaultfd switch between async detection and synchronous
eviction without re-registering its ranges, and the EINVAL/EFAULT
errors returned by the kernel.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 man/man2const/UFFDIO_SET_MODE.2const | 95 ++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)
 create mode 100644 man/man2const/UFFDIO_SET_MODE.2const

diff --git a/man/man2const/UFFDIO_SET_MODE.2const b/man/man2const/UFFDIO_SET_MODE.2const
new file mode 100644
index 000000000000..f97935a176e3
--- /dev/null
+++ b/man/man2const/UFFDIO_SET_MODE.2const
@@ -0,0 +1,95 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH UFFDIO_SET_MODE 2const (date) "Linux man-pages (unreleased)"
+.SH NAME
+UFFDIO_SET_MODE
+\-
+toggle userfaultfd runtime mode bits
+.SH LIBRARY
+Standard C library
+.RI ( libc ,\~ \-lc )
+.SH SYNOPSIS
+.nf
+.BR "#include <linux/userfaultfd.h>" "  /* Definition of " UFFD* " constants */"
+.B #include <sys/ioctl.h>
+.P
+.BI "int ioctl(int " fd ", UFFDIO_SET_MODE, struct uffdio_set_mode *" argp );
+.P
+.B #include <linux/userfaultfd.h>
+.P
+.fi
+.EX
+.B struct uffdio_set_mode {
+.BR "    __u64  enable;" "   /* Feature bits to set */"
+.BR "    __u64  disable;" "  /* Feature bits to clear */"
+.B };
+.EE
+.SH DESCRIPTION
+Toggle userfaultfd features that may be flipped at runtime.
+.P
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
+.BR UFFDIO_API (2const)
+time.
+.P
+The operation is serialized against in-flight page faults, so the new
+mode takes effect only after every fault that started before the call
+has finished, and any fault that starts after the call observes the
+new mode.
+This allows a single userfaultfd to switch between lightweight async
+detection and synchronous eviction without re-registering its ranges.
+.SH RETURN VALUE
+On success,
+0 is returned.
+On error, \-1 is returned and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.TP
+.B EINVAL
+A bit other than
+.B UFFD_FEATURE_RWP_ASYNC
+was specified in
+.I enable
+or
+.IR disable ;
+the two fields overlap;
+or
+.B UFFD_FEATURE_RWP_ASYNC
+was requested without
+.B UFFD_FEATURE_RWP
+having been negotiated.
+.TP
+.B EFAULT
+.I argp
+refers to an address that is outside the calling process's
+accessible address space.
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


