Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F94606B1DD
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XE+EjocX
Received: by kanga.kvack.org (Postfix)
	id F1B6F6B064D; Mon,  2 Nov 2026 10:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECBE46B064E; Mon,  2 Nov 2026 10:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D458E6B064F; Mon,  2 Nov 2026 10:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A05F86B064D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03ED412011E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:18 +0000 (UTC)
X-FDA: 85390582998.09.71E2913
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id 41AEC18000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XE+EjocX;
	spf=pass (imf06.hostedemail.com: domain of 3K67oagcKCIg7u1uz4ts00sxq.o0yxuz69-yyw7mow.03s@flex--vipinsh.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3K67oagcKCIg7u1uz4ts00sxq.o0yxuz69-yyw7mow.03s@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WePLvWtT/WZKO7Unx2RTF+SOz/N+MuUr8ckMVHiMFxQ=;
	b=paZ1o1ASHfOYHDXyJxDmtCwlQT8fWvDkulrbdeqJVz/6cwfmB5gegfrAq70PURyylMgDDQ
	TXCFOLVlm8cvnl8ym2jJFHvxTsZSzDv1IEdhnj5Wncu/yx/cUQvIJwo8PrSndojCF32ICK
	uSh/eskH+PG0vJXJg3ZAWbxTiK6Kksc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633837;
	b=q+hxXywpkQe8u/wlJBfDLla7YajhiVFDlZt9fnopHu+SSkTCziEeSZgqWAbdNQoAvBydXL
	bmJcnHk61fjlxXfUKgvLsb8a3eN0TEsGdWEplMps6f7sUfPMF8WL7F6QKDtTujD7hexZMW
	B1a8e7BMupUAwe7REFZ6k08Z2SOZMkE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XE+EjocX;
	spf=pass (imf06.hostedemail.com: domain of 3K67oagcKCIg7u1uz4ts00sxq.o0yxuz69-yyw7mow.03s@flex--vipinsh.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3K67oagcKCIg7u1uz4ts00sxq.o0yxuz69-yyw7mow.03s@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd67466211bso1684051a12.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633836; x=1794238636; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WePLvWtT/WZKO7Unx2RTF+SOz/N+MuUr8ckMVHiMFxQ=;
        b=XE+EjocXWr/Zmll3CmLGOTh1Ftt5dEod4I4eC3hOsw+9fpwxTlgBdNvknapqFiIEyM
         u1Fa/MnsZFg9g9Qr1rq2dWQf6lcGrB/U1ixJEjfYPGLPKZCjl2VlzmY67VArpcD1FKux
         +eBJmeAmsZvKOX0bT4ODAx5cM+maW8hQAWiYcmeDUzArpItHDXzNVZvax2i1JiZMoREI
         bXYRNF0xuSyhyX2Fmg2FCcXkDIG/ug9nltlb20Y5Kf50bNoxXG4e73NJUi/Rc4q0Jscv
         6l3fePM3o3YFvqVGavIqWeG/CjEmuk74xYi6i1Gl7iQtaWmGlV32/lC7G/5TuR3Hug8y
         0LdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633836; x=1794238636;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WePLvWtT/WZKO7Unx2RTF+SOz/N+MuUr8ckMVHiMFxQ=;
        b=M7i+IG46vVTIU+ENF+ZBu+QnXz67W6+uMRxMkRiYD6HQtvea7jcTFvq+8fnbK6yu46
         XbaaGrxALsZaJUmwsiuEy3mv7JAQi5DdsOpGj2n3EhbrYincW+GDwS1qShHriolnPHGw
         +D1l3rk7KLlTaWTfL0ieP3Jg74BtyRArDnunano5S+dhxSIolY93pq/Vh6puQKG+q3EX
         0YhREnEFofh9/wTRjpR18zU6pedcmh1jJSnxtfceQh4mUHDJ8cqV+kLzzaJW/yKb5k2f
         4ymB0mFkMz0K2CXYUy7UHhUQ408XDjw7bEVU0F1bydsjNODDd/fk2un2M9f/IV4z2Uoe
         tQ5w==
X-Forwarded-Encrypted: i=1; AKwUvBxmMac+rq7zIQDznUqPBvqSiGe3eYJgDKD/ROLHzkuMWo6eW7edcw1W1Qb0u0nbOJfEx7nl+PMxjA==@kvack.org
X-Gm-Message-State: APuU4Z9Im73nvHB2veOxnSnVkLd3RHE1ILIkvj6hfAz9rGFT9tNYi9gr
	fqfhzJiZn95Qr9eqk4NofnMUMohEeOnv6Sotud5dzEAvG0tbB2eGROTcFNGTW3evwnEkyuGShXt
	r63IstOGfRw==
X-Received: from pjbcm14.prod.google.com ([2002:a17:90a:fa0e:b0:3a6:f87a:f3e1])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3807:b0:3ad:a232:403f
 with SMTP id 98e67ed59e1d1-3ae897aa79emr9013104a91.56.1793633835815; Mon, 02
 Nov 2026 07:37:15 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:44 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-16-vipinsh@google.com>
Subject: [PATCH v6 15/27] docs: liveupdate: Add documentation for VFIO PCI
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41AEC18000B
X-Stat-Signature: r7okjr8nj4yqhka8bdtdmaxwpdbpewe6
X-Rspam-User: 
X-Spam-Status: No, score=-31.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633837-518186
X-HE-Meta: U2FsdGVkX18DX3/VcbZgjA75hc5/NuXSI0C4NGzdpbKPKYeTYZTIh7Qdz7CidoFJj9BxspF+7YyO4Fv2fXffHmZKJsrxd4yZjgMnzL3fIb8/Pyab/B3Gl3mgWBtMsLQ53N5LDcdyEW1dbo9XS/lO4X5Z2L4uX2LJRPDrPRnwV4GHHYpeYpYZYr+onU7eWYJR0Sdmy6m5DAKEYg6s4peZowZrWDpMoJqfOTL5h5nRTaONzU80U8M4NTs8XgccgvdcqFZcBFpl418LFzBHmvi83dKG0h4ZBe8ht/N8jaTrSXDCazCdcKKPMKn7sxQUF6tyD/UYb1t1TftabNi8adGUsfg4UIkTT3YSAWw6UixmnVT/kPYUkenOCXxs46glUL+6RD7PheYQxDfoMOo+9Tr0Pz108lg+TJ+xEAr0AXyhUhy53lCN7k+fs53haNpF5DoiMgtkwmupRak/EJdJ6N63OjemnH/jKBCCWjS9alZ9vFs5rJTuYd19ligXb5HkG45KjNcuV2silc4ZP3Jdj/rE8pIufpblPJMKFQKgPi8jHAmTA2fjlXhBVCxP0AIiarP00r0witYYnbZMfAx3j+Wx1VX7iHd23dy4Bn8hj4WaGIlB8xt1b8FkBEQ9pJX4bMEZCeltRWfuNZc04dr9Vquk+KRpV+YWi3zol1N60k06gFHCJ0lrJlq4jm4EHIDFU1sWoiYpXNf74a5NEEFb1K7qFaQqX/EgSRRpld8NVuWZmAWc5NfAUHzRhUxQKqGmpsNotIlIM1uNLKrZiM6mNmLwaqwx/rdVbfh52BsjA2OerZWI44bPLK36+/Waan05QZ4Bx/AE0S/+Av9kZZz3VBWi4SxFFLwJTXsC4B1JYbzgnRpCgwnwK3E4ClHJkElAu7EFdh/bzZ8al9VVnnaBOEqiXpafdnKYEcxcp1fVoxAAYN1g26/Lhwwh7W3zKk61oRVfMnU5MDinN6RTXulRVPi
 2/XDufz2
 XVj2K9lbY5z/BK59FoJRXVob9+z29+I2pjZ4hiN8yyAsuMgYCIHpyZZrurQLLrcaQtVSq9+C/f+fr8z3fp/lWjzVcXRVHcLxlAHCuZrYv+8j3huNoPZpxnsGH3dom+XfPmWLihf0hZkdSyQCZlgVjwrKikq5MYTdSA8leJal84wEUYsApvOoOmaKeCI1Vdvau2oB98Kqicjda/8Z1ySyFC4J2FLLAWpW9XfHPFRDXdWt+e0sAG5RBohrwue7Ke2AbCNCEr7IlDmRjVLuPOo4GFp8YzEOK6uWClwxl6O5U0YPUZiYPd7wTACmwoxpnR1w3N/KvTKfaBWb/yAhajRodRkR1+wIWat88HS3GExOh9qLVKk10gRzK3pJSgbEbVFXsQ+R6rn3tY07X/IWy0CKHtxUeqPwE3L7r6jZ4beux9fuUf4FTzUhVgAMMVk3yKC/QPC/b6KurIaFD9gfVQSmjKSMdpPHsA5tJiA8a65GP1IeSMsdDR7KwAOexPDYYJrqcdMUUtKQLouUBNyKjgFsDHemAjha/Jib4k4t4Q5mVLDSUh4tFHzdSw/2Sj6U4Ekv51Rq51JPWljAeW417VzdVjHJPcy451MVdh2MbjDT/LG0kkZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: David Matlack <dmatlack@google.com>

Add documentation for preserving VFIO device files across a Live Update,
generated from the kernel-doc comments in the code.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 Documentation/core-api/liveupdate.rst         |  1 +
 .../driver-api/vfio_pci_liveupdate.rst        | 25 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 27 insertions(+)
 create mode 100644 Documentation/driver-api/vfio_pci_liveupdate.rst

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 2bce2644eba2..20f1d2e20508 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -38,6 +38,7 @@ The following types of file descriptors can be preserved
    :maxdepth: 1
 
    ../mm/memfd_preservation
+   ../driver-api/vfio_pci_liveupdate
 
 Public API
 ==========
diff --git a/Documentation/driver-api/vfio_pci_liveupdate.rst b/Documentation/driver-api/vfio_pci_liveupdate.rst
new file mode 100644
index 000000000000..81077ea173d1
--- /dev/null
+++ b/Documentation/driver-api/vfio_pci_liveupdate.rst
@@ -0,0 +1,25 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+====================================
+VFIO PCI Device Preservation via LUO
+====================================
+
+.. kernel-doc:: drivers/vfio/pci/vfio_pci_liveupdate.c
+   :doc: VFIO PCI Preservation via LUO
+
+VFIO PCI Preservation ABI
+=========================
+
+.. kernel-doc:: include/linux/kho/abi/vfio_pci.h
+   :doc: VFIO PCI Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/vfio_pci.h
+   :internal:
+
+See Also
+========
+
+- :doc:`/core-api/liveupdate`
+- :doc:`/core-api/kho/index`
+- :doc:`/PCI/liveupdate`
+- :doc:`/driver-api/vfio`
diff --git a/MAINTAINERS b/MAINTAINERS
index 167aa9d66ce8..2b62a0b8a48c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28661,6 +28661,7 @@ T:	git https://github.com/awilliam/linux-vfio.git
 F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
 F:	Documentation/driver-api/vfio.rst
+F:	Documentation/driver-api/vfio_pci_liveupdate.rst
 F:	drivers/vfio/
 F:	include/linux/kho/abi/vfio_pci.h
 F:	include/linux/vfio.h
-- 
2.56.0.317.g454f8302e1-goog


