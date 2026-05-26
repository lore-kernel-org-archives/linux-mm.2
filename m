Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB0CCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A846B00DA; Tue, 26 May 2026 09:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1ACC6B00DB; Tue, 26 May 2026 09:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD2F6B00DC; Tue, 26 May 2026 09:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76F516B00DA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:42:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 410FD1403D2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:14 +0000 (UTC)
X-FDA: 84809684988.28.97CF3FC
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf15.hostedemail.com (Postfix) with ESMTP id 69B88A0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="1 /uQAB8";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=blyTPraX;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8+Wgub2qqUHY4eu6PfZmMEEUj7nDz6IAC4QMYExiwk=;
	b=s+CX/ZbwuusF4YXdbQe0SpSI5OPkNYam/+JqRxD2FYu1hQOl19TaxvL5ViAHbwrjBVeWY/
	xkKVGWVIOMBOWCCGveAeX2prvKUsFSxRh+sgQUefB8Ys1W5gB7JmDLTrywlX39552wHenQ
	BvK04wVwHsPeCA3GCjXVco+u4vwQWUU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="1 /uQAB8";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=blyTPraX;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802932; a=rsa-sha256;
	cv=none;
	b=TfnGLfe/0sx8HW/mRVLmYv4xfvWWhfsEhbODIi4ik+iw2O65UsT991QH+kX8nnkLizj1fu
	qe+mdvR8HlukCrfKNgmnXlL5ZclEbk++F67ei4JPZtYDesej1bkRph8C3jQNrDU32rs6GH
	t9v7+7TYKlgjU6jfZeJVKDoK/rKYuw0=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 97B7E1D00111;
	Tue, 26 May 2026 09:42:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 26 May 2026 09:42:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779802931; x=
	1779889331; bh=j8+Wgub2qqUHY4eu6PfZmMEEUj7nDz6IAC4QMYExiwk=; b=1
	/uQAB8g9zJChvy2emN2rwIwE81ztEhNZLebzz5eNfQsfCU35x/xUSE8dcZOkPJK8
	sq3je6NWM2QqtPCNbI9YT62kwtpjbJiUyHV9n1X2SHHHYF+FV+PHqXtFkMUP5WTC
	tYGFgSEMR8S3J+9tCPy949o87yzpRtbyjiVmaf/UEVY700StOeUsEe7miZgUhFuD
	F+pZeAT4/B6cDoPt2KndrHm5yVhA53SbMX+oTAVGFHONJvN3FNNBKNXAo2nDedAP
	NVg8aHnKixLnQMQzY53Y1YwvM3YjgXYbs1f1n8uphNenuuKgGc1Hw9KbUa21OHq6
	dRqNDScHWdzEXXrS1Dwsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779802931; x=1779889331; bh=j
	8+Wgub2qqUHY4eu6PfZmMEEUj7nDz6IAC4QMYExiwk=; b=blyTPraXT6oiGskrI
	BhkgMq1qybDHiPIgw6pRVIE31zAGAFhOLdDHgGeuEtHewhSGSiIwIkA853Jao1iA
	aqb9S/oa7mcVWsbePfaaQj+c3vHNSSxjaC2wqjaO3VFCnLZ8PLdUMkjRDol8bYZf
	W4O+dvWK0ukhk4x1y9Q4kpR/ifk2GeyIxZkLxryHzCnDfqRv5eBx8WhUpOODPbL8
	jqFKRqWJglqmaOydToebODEIId7XOEmtxkvEVLVQX5XkLar1/9FQTLo0f8F1S/an
	5d/zJ8UbzA3UnbBQ1iu+x5Orh80dDPGC+ioj+iU91v9yCp3MKgJS5h59RqiOLYpp
	Ah9Ug==
X-ME-Sender: <xms:M6MVagtn3NGqxV5c5sawSSSU8u65XhYwpZ7sOAFc2N5FiltMMa48ug>
    <xme:M6MVaqCoW1-QKEwy0QVdF65wVZOlGzQBJ1FX54FUwxSCJuRSCIfaaZ_LW454eDsE-
    c--L3_de--e-o_9OVedgS1Zzk0ijYFI5x8o_4zgAAIpelcXJ_uYjiA>
X-ME-Received: <xmr:M6MVagPFrJoga4Plf9Qpj-B8h7UvRa4Sh-esZbjkI32mmaSe14RVD1bO31HpdA>
X-ME-Proxy-Cause: dmFkZTGCG9NSIqjaJ0FcAKWnlQsiJh00bpn2bwYqat0i/9Uj870iJ2+nuGwq5UQ0hWiBWC
    0O4pOtGl11/rWzrQ8JpRQNWQ/o+KucL1HWCb9MN/J5ac+cionE9x/LUkgMMmmDj24Qvo9M
    hAZY128EGQ+FrSOzPDtP3gMcTwzb/bnhrLF81xwhJfW7FTkHao26SlYjjoQl4gZGSY72aR
    dCMuOs/9hNimjuTsXqn3/2Evhg4jhIamSMbZZ1fWRqEJCgWuaS5gf6qk5ClxVVi+zrQfln
    ASwmMqCuP6peEp5E4eWDL3vlj9B1Oeggrsny5nI39Pg5PAENrkAwSUmFirfgbE1IAAQaPZ
    m7r9+cUZIultUM04t9+hWZrfYCFcad45VMlsgbRuHzouVcpMokV1aOzdQpC5KSbHadSAL4
    I5KKZgdN+Rsy7HUg8PO+lLScTkvk5RaJWJDjWchcnQouXqotHb/4vLlEbPMgEcmN98lQop
    HY3jVeAUCBh/kKaHtDdhCKMTT5fwdJwsRKvnbA4fE8PLS3HQ8wYgrBfozM0T9Ktvp6xjCr
    562D/MP4fOnSQVESOXb2IJKBHRf/+7alqoy2kd+DU+Cc3671wlAoCIAWyoZ/UEipol0u5U
    ctIgkxR+LJiDJlCK0UEkXAzoZ8n9iTiFM5ODcevfq6tiIElYzpsk9oprc+bA
X-ME-Proxy: <xmx:M6MVaqCVyX26CtN4yoSYu99H0hnq5fLEhDUuMLAvd0uH8uIr5CQMdw>
    <xmx:M6MVah5N4LbNud-p2t4ZodrJo-QfYSuWYRS6uv5JfC4R-zd6hluabA>
    <xmx:M6MVak5BdFf1CZHF1eJpJbImCXG3iY40EuApMPtgp_5pTyYRaF3yfw>
    <xmx:M6MVajRL1BrBXQZ0T_lB64k-yXtsnK1YKaVhUkOXd5TuqAx0vqei6w>
    <xmx:M6MVah4qEqq4poq0PSkzhxz3aVD2xiHdUbJ7G1g3OPZY85qZhvRhZ8_z>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:42:10 -0400 (EDT)
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
Subject: [PATCH v2 3/6] UFFDIO_SET_MODE.2const: New page
Date: Tue, 26 May 2026 14:41:46 +0100
Message-ID: <20260526134149.2831720-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526134149.2831720-1-kirill@shutemov.name>
References: <20260526134149.2831720-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69B88A0005
X-Stat-Signature: y6bfgpa9y5t5fcigxi7mtfk7nfhh8xc7
X-HE-Tag: 1779802932-43347
X-HE-Meta: U2FsdGVkX1/Q7TaqOBbjnzajoPJBqO+IJh/KnlbNhmkK+QOdzBmxctBwSHMn0byKfxHjrZkNPr7sWVOnWOu0KiwyhbB4axp0ubC2baby30BPgDwBAXZXfM9zST9YKeAhI1Q3ePYHV2QJFKJhRO/k9r9Q2FdTkIyJx+WWhww4B9e6P5OJNX69C8xktaj0UedJiElWqdCVb2rzM+wB9+rF1YD8cJqGC/nZK/NmTXZwxb0ymIQhpIhhjgCfMwXMrjK8j8q1MB7RYRE/P3v/9HXUjA1sl/tTweDdNPiM2Ix44fRgSE46N2pOZeEqAQE/SiZHpk8Sx2nuRiayWx9OmB1gfNxscJNh3QPEXEwUreIfZrpskWBoq6TUTS/Rt5Zm+23xNCC5fGHyNzm/Y+t8Bgot7ZhXf3FV37PAAFHrkCx6CVQlw144rOTjJWCgnuDAkG9w2lKevpaL3Ekrw9KwOmCuyil2ZZyb7riZBU4+M0KjmcmPs3v82ierFX2U+QnusFBTk/aNP29jkdgjs3t4T73PiVQWs/1xNQnh5Qbqdijc2sHC0xNbKwDxCU/sX+cW2F5zy4ywMHEzqSnAsU9u1v28UWYkI3dB1uJb2BVzohzn1m/AuFZA8U+Qea4AtTMbwJqHmR0ySkUbR3dMVNXbEXJpPSbzQECS9wPItnuCWRk1615qqfAwFISE7Z6+f256KVyqFrDAT46Ca6AM+HomYwS+HXHiZLqgJb9sDKY3PpeWrLHoIjUxrHxuKyQLkFsINXWl5rBmQVuvVoxaLItsxNBAJe9XoXUSk6PQiLgAoyDCTOGNXLXxNgC0m8aTtDewE9nB4BjBeMnuIYy0lLoLnIAsH26hKfQLEJJt5hQ4a4+lOhpjPR2F8Wmmp+s0hfSWgI0kFrlhv/pS7Yi5EUbDlLDf8Isi2q1oDZ8jpWcuZk6iqCebGv48cF5MKkqWBelKjIr4ZtwwbuQVoM7cRDtiU/f
 y3NgvNCR
 baIzUa31OehGimgUwLKGTMdWtqkIkQBmH37GkFzBal36jtx69eL0qdIl7S4F6T+ixaoRMmZxt1Ana+i4U3gQX0h0Yy9nLFXrqyx6IyoVddYzZTuJF0V0O/X07IvyK/0Rcf2OQRlE6LRjzRve4q2iKq5iWH4wnbVNFXmRxMFNzhDeTi2hNQ5NYC45z2/KgglYCNMVwW41CBjrBNRJb/EFTNvpUWkRgHDXe5b1jR8F25LRLVzjP6Dq7Ueh9jl4k4KZBq6Ipm7v3mSsPysvLzBpuWg4otHGBZUUDyvLUB2JM+4/waxUF5H25UZ25JcBbvA8UhtM+W9OFzwPC0dTQ4JgHZd5lLnZPTTBU5MrpE1HLit5djGUU95qIjKPNiwWnOMzpaKHfvauioZu95NCB3tln3qdrvfE0bQ2AFoVAe/QvvIUEKnSIQi6dXk88TzxTKOziUzMc1ESlPLIFkH4YVEvZ6Wa4SerumgCVyTBOYwqQc+lsLVyr2V3ldldRdvfXGkhdz05MVrqUyu89LMokV6mkWQP9ENhUSkjoML3M8pys1Mk//Ktayfq/YC2jEQOFys2xSZW0uWPRxK9IfhcMRb6dHzPbQpWAuMqf/jHYHtprTve6AAbyCwrQPziF4HY4NMm4eQi14kvmHTc/7HsdA7eQ12zxMkPUh6FFXtuqTE0odI7eN8U0L7Hg/+fa1PMh7yn46KkfA6G8nIcOlt8=
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 man/man2const/UFFDIO_SET_MODE.2const | 98 ++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 man/man2const/UFFDIO_SET_MODE.2const

diff --git a/man/man2const/UFFDIO_SET_MODE.2const b/man/man2const/UFFDIO_SET_MODE.2const
new file mode 100644
index 000000000000..b71632011a4c
--- /dev/null
+++ b/man/man2const/UFFDIO_SET_MODE.2const
@@ -0,0 +1,98 @@
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
+turn the named features on;
+bits set in
+.I disable
+turn them off.
+The two fields must not overlap.
+Today only
+.B UFFD_FEATURE_RWP_ASYNC
+is a valid bit in either field;
+any other bit causes the ioctl to fail with
+.BR EINVAL .
+Enabling
+.B UFFD_FEATURE_RWP_ASYNC
+also requires
+.B UFFD_FEATURE_RWP
+to have been negotiated at
+.BR UFFDIO_API (2const)
+time.
+.P
+The operation is serialized against in-flight page faults,
+so the new mode takes effect
+only after every fault that started before the call has finished,
+and any fault that starts after the call observes the new mode.
+This allows a single userfaultfd
+to switch between lightweight async detection
+and synchronous eviction
+without re-registering its ranges.
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


