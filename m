Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42094CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2F96B00A0; Mon, 25 May 2026 08:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862926B00A1; Mon, 25 May 2026 08:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778896B00A2; Mon, 25 May 2026 08:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8406B00A0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:28:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2AFE51A0220
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:39 +0000 (UTC)
X-FDA: 84805870758.06.AB2AD1A
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf23.hostedemail.com (Postfix) with ESMTP id EDACE140006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="G zPfphZ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KKYeTWHK;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779712117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vrDBOvq2+kJrD8P3sLIJ9hYixXyIjwZZDl/w6KrqRA=;
	b=hF1MjXo7K0yiMToQlohBe6fakcnrodfb7DigcsfWe5YMBGDkitywHanNVBFSiDCMYFqybj
	9EbH8wTL/ibw/B18qS30QKfx2SBC1LF2bSNBPtozjIXjxzncBLHeebdjluxa7+bPORclnt
	6X1FTTuhtFEtVnXl52JJidG9vWmgEWg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="G zPfphZ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KKYeTWHK;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779712117; a=rsa-sha256;
	cv=none;
	b=iTtLY2LubCLPT5sE+3ySNp0m/bIGRZgkCTBfpPmkXrgBZVAGZAHH947MY8AuiAxRuFkXlV
	JtbTI6zgLtTkqITfAf23VgjrW1acr7fxDaLD67kngDX9ieiVoaormemtqHsq/merPhjXvM
	BCzshhwwbX9+Y/hQRlNyxeR+17V7sm4=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2C34C7A00CF;
	Mon, 25 May 2026 08:28:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 25 May 2026 08:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779712116; x=
	1779798516; bh=8vrDBOvq2+kJrD8P3sLIJ9hYixXyIjwZZDl/w6KrqRA=; b=G
	zPfphZ17cEjIw9pOIPpRFsWBG8PZWepxNWWaVlWbb7Z2ZrzJgGsrnJGnwvIhGIwo
	+Fp5oTZB6dPeGS9L3J4owSy8N1gOEbfu40Hbo9zXGjAnJOSmRJYW6yJu47scwK+O
	dCL+dTECmpzjYf41RwlpdFivJCxiYD3UnkL+ZizSOFkYHRbvhulDUkVEwCQU+EoL
	M5Ys1BgC4MNo+7+lrLzXigTIygm4uQ4wk0GhjZysiOZXBjLOZOEYK5cRg4U2jACd
	sUiYNGZjXrgaexRJinmQltzE+3pEVJKqmK7MjmZStujh2/f60QHy2n5E52Iq/mUS
	/mmwuSQ/lAekoYkSiUl1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779712116; x=1779798516; bh=8
	vrDBOvq2+kJrD8P3sLIJ9hYixXyIjwZZDl/w6KrqRA=; b=KKYeTWHK/CGRz/KH0
	2Hndxs/dxYnj7yh7e5adDD0F1i/9kZKHsEnbE8DOk+LXipKlqcMZTmth+bynhkn0
	VXDdJb+cidRUG+E+4lhqr20RvkkhX+tfZn1TeROsS7CkNjDSTRRhpedx1AAqsyL+
	9G77uxUVh60yZmBnOk3faB4taeGk4enggkKp3CmpwvWZBEJ/QfstIHxKWf1ah67B
	6O5PMVO1uGrqt9FxGO78yHjICOcHxMx0DmQPZ/hdIOio1fk2hLMdD8/RippdR4vG
	0a49z9NrNy9n47VvPJvuneVlQAyJUXIpOZ+8/oUR3jTc4tQBiM6+LOeCugBwH0m8
	eecgQ==
X-ME-Sender: <xms:c0AUarBtKkvwyBsKRTnFCjc7XdgvH8oYl7mvPA9TfRIB5ynpPnKH4Q>
    <xme:c0AUatMMg1E-0c6iPJdA97At7tvaIDjXJqdCF-XogtT0IZpQ-NUCf-9uayvA7rLae
    HYhAqBZPTT9pT4gMg69CA4uw8EKnKy1CfQKHEM5aHct1xQjeALYBQ>
X-ME-Received: <xmr:c0AUajAJS2_fuFobhOmZyeAWpvsKPFrRSC8xhQM6LqyPNETKpO02XDB-nxonVQ>
X-ME-Proxy-Cause: dmFkZTEXp0cswLCLQnYU3cXjMRaX4wSfvTakw6a4812iXlP/oYHwvc//N0ENwYUIk99T7x
    XiejX3G5k75GRyBPaFULLW72flrMcjfWHJnueXxI0+t/vzZigKbjfvj1c2p4zGrVrqwvRX
    o6NFf4BdpVI+wJUcYURMDEwR/eLb6d5Km8AyI/46j92EpY4y2EApCdG2yHIg9iBYOrg+QE
    ju86lW7VRBKwT5veKrdL4qmk4nsbBFr8tBxHsk2R1jxZkkGJs2c7dL1Ou2HQsGtvgbhc+S
    +h80ESmF+sd1T9PmUfB7cHNrunygJYY9di8lZA0q53vnoxmbm0Zfn+RZevx0zkisuyDCoB
    W9Ng6yRowEOw6be8maducO9OEHTQP3JBQ/VQ6qgpjsb2anWMll7BchQ3RcJp6Goeamc2mO
    0djE9YdcLfMCGhFiTxWO3qNcwWq4izwUlSqP6UUUNt/ukKl7jyHY30fsxuf9oitCxhQPbB
    IqNdgSzzxNFFOF27wVnI2DpOpMt5tpdF7aN0OQeXbwMx5mEDx8h/CRpwoOsQrT/bsbmnKi
    9GmAObrn4b2xMiWplDLel/mqoAhesTaWfog3sPQbtF4JSCaQwKXWeITmEulhbXCb87bz6l
    xNuv1JGjtpHq4ar5qYWjwC26v/vprv4qacRlTa0kkKtq0WRCWsF51AkEfrSQ
X-ME-Proxy: <xmx:c0AUam7hkUGeY2uuDu5gsNaeAEXwCS_wgePd7rYg6ik6seODrZ1srg>
    <xmx:c0AUal5HEAqmXC7zhE9wbR8dlmQv1Mw_27cADw0YPFUtkEfutADmbA>
    <xmx:c0AUagRAdcuWFj-3erPEgA8c3Zjv8IC3336PJ_X7H9M4nL1u5vNe2g>
    <xmx:c0AUal_qkTZBxllqFGFnL-Ykiue8rR8Co29o9d5_hTbdypVXAiwuMA>
    <xmx:dEAUalYqdAPfvQHekxnytBjN-pFztXFoMAn9E-1I3VcgZ9Yi7ee4wa1D>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 08:28:35 -0400 (EDT)
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
Subject: [PATCH man-pages v1 5/6] UFFDIO_REGISTER.2const: Document UFFDIO_REGISTER_MODE_RWP and 1 << _UFFDIO_RWPROTECT
Date: Mon, 25 May 2026 13:28:15 +0100
Message-ID: <20260525122816.1956804-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525122816.1956804-1-kirill@shutemov.name>
References: <20260525122816.1956804-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zu8boqnmf7zgpskgbcobnnk8d46pjteb
X-Rspamd-Queue-Id: EDACE140006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779712116-768594
X-HE-Meta: U2FsdGVkX1/9eEIBKVsVuFfDHWdzhuhgxCag3CzKWVP46t/Xv2T9ao0D6gF1D9rXpHDGNNKemjL19S/iSj4DDaDQ7sf3wb06BlMz/88Je0V8YQW8gP/kmWMjZevpr5gm48rYoxxT4OJMRI1y+wg9d3WPFk78NekhpHaukBadFeSiQ+DFPJsLAdAzSwet9jiBdv1XAYFhbnqxMBOHE4oW8kDqqnSocl0E+gwRXhbmr7pmPZDHDiu0ASNlKYQJZSfKy3dEMSmRlO0sNhV4XR81dA6TfzVWGmybA7+hRaD4dzGOS0CnDPDhOdswh5XrC+q5m8oyHHp5ZSO95nWrbLTAhGVVgQuYtK8yjI02xOyCwwAvRRqzwWVuixqgC+goeFlxT1OJyPRtcrkDdwIZ+wkyDp8cJ78ygjHD+1rMnUuUcK1uAh2mCGILdzSz3S3DcjL3//WUznwdkqy3Bit7JgCOiWvJn50oSUuN5LQZWwhFyWaZBieTWddpA4Rh/UzaPyPiNhPT8kIeUfOW5qxAof0bhpAABI/4iaZV4/6awGAkpucUtn/n9PjBaSOOvacqrQnDctT/doMgFEl8w4xGjEadv3ttktLUWvJfQYxR9QoRQv8xEbwxHgyT/hnV3K6lLAkaP3Rnf+w1vsxsycjRwPy/bPMkpB4AUhBNuBlnv/eLl2WuVscWyFVsT9zyhHJqeb0mOrBUVAKk6A6RJvDdhJjL4U3A4OED9Hx6NLKBZ6LD8S9qUY2t6tnTfHFFDMyrwbYGN1cM596zGxYs5kl+tEaNnkATI1XNjvBKL9Yk/6yA7xx4nO968oTkc7SHxtI3G2JzVHgQYGoyBvoe/3ojlOAMhaMHc88PNurNWnq7NgGTQmZPEaN7u71CfivjLcrGb83WI+VUdkBS2ccEv4wyABOk2pWfHXjFKBLWHb4AW/Ht89L/q+PcfyCKEKHZ5CgKTMmQPgAXkTyj8QxPR4YeYoL
 8IpEg8id
 Jm8c9mJ+HfCYBHsQvf2TkO7JFyw553y0zMqQJQPEoY7mb2sUsVwd1nI6xAEzIKLNza00lIE7hb4CEAlRvSfIJH9b4Ed1Yz1KiYkqima6xPICezXt5ZCH3wVQw7J9uYhph1+aQLBb/pS7AokzPj1DkESLKnxF/ESo00e9XY5FrbOLkMoDWRzdIbHrD6Mm7WoxeGdhe+4etjkb/32PJxPLmHwVr8JQ/qO8yGQ5cZQ0E0vFn/QCAeE8GyZG/OCM7EEJK/SLHm7T2nZhCT36bhKiY5rPx8zKoDsUONEAXCbAlrr4YMVWdzaiQZE3KeLpUgSP2S5B6/ZU3jD5jVpf2asDt+gFMLJBcMQ7exN6Fj3EPhQpunLMfZkTYWFfAGtlpEGP4qREeqIc+iRWwpcmgrxEgK+h2LToc2ZwgOD3jsEYCLeH4dUedf4PjkdMGKcCvjf106Xn82BpA05qaaaOz3PsnonqN+nppbU4vruC8lwXr1bP0L6avZvpcZbIqUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the new registration mode bit introduced in Linux 7.2:

  UFFDIO_REGISTER_MODE_RWP   Track every access (read or write) to a
                             present page in the registered range.
                             Cannot be combined with
                             UFFDIO_REGISTER_MODE_WP; both modes share
                             the same per-PTE marker bit. Anonymous,
                             shmem, and hugetlbfs ranges are
                             compatible.

Also document the matching argp->ioctls bit, 1 << _UFFDIO_RWPROTECT,
which the kernel reports only when the range was registered with
UFFDIO_REGISTER_MODE_RWP (which itself requires UFFD_FEATURE_RWP to
have been negotiated).

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 man/man2const/UFFDIO_REGISTER.2const | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/man/man2const/UFFDIO_REGISTER.2const b/man/man2const/UFFDIO_REGISTER.2const
index 50064c954b81..07b2a1c9dfc5 100644
--- a/man/man2const/UFFDIO_REGISTER.2const
+++ b/man/man2const/UFFDIO_REGISTER.2const
@@ -72,6 +72,17 @@ Since Linux 5.13,
 only hugetlbfs ranges are compatible.
 Since Linux 5.14,
 compatibility with shmem ranges was added.
+.TP
+.BR UFFDIO_REGISTER_MODE_RWP " (since Linux 7.2)"
+Track page faults on read-write-protected pages.
+Every access (read or write) to a present page within the registered
+range generates a notification once the range has been protected with
+.BR UFFDIO_RWPROTECT (2const).
+This mode cannot be combined with
+.BR UFFDIO_REGISTER_MODE_WP ;
+attempting to do so returns
+.BR EINVAL .
+Anonymous, shmem, and hugetlbfs ranges are compatible.
 .P
 If the operation is successful, the kernel modifies the
 .I argp->ioctls
@@ -109,6 +120,16 @@ operation is supported.
 The
 .B UFFDIO_POISON
 operation is supported.
+.TP
+.BR "1 << _UFFDIO_RWPROTECT" " (since Linux 7.2)"
+The
+.B UFFDIO_RWPROTECT
+operation is supported.
+This bit is reported only when the range was registered with
+.B UFFDIO_REGISTER_MODE_RWP
+(which itself requires
+.B UFFD_FEATURE_RWP
+to have been negotiated).
 .SH RETURN VALUE
 On success,
 0 is returned.
-- 
2.54.0


