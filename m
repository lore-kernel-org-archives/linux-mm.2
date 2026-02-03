Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F485E7FDFA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 19:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE73D6B0092; Tue,  3 Feb 2026 14:24:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72546B0095; Tue,  3 Feb 2026 14:24:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91DCD6B0096; Tue,  3 Feb 2026 14:24:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77A0F6B0092
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:24:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B2575985D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:24:03 +0000 (UTC)
X-FDA: 84404120766.06.777D1B0
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8EEAC180008
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:24:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UgrCg5dx;
	spf=pass (imf16.hostedemail.com: domain of 3UEuCaQgKCEMonfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3UEuCaQgKCEMonfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770146641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aquur2bWSawAVy++fhfPAogrKIXUck0YPKC9WFv0tRU=;
	b=a0n/Zy981KC/8ROAJ36PwGvra9+h6p9WYNAD0rg/gS3RjWDjNDYCK3GXrF9u5f8wuitqnA
	YqZ9Eb5d9HX3j6nXbjEGxSRfdMV2MpkOh9CgHkdgD8cWA6K6NztvUW1aOFPjeQUPhwxGre
	Ft8Uqu+9Z1A6EOmyp84Uba8Cbu8QYOg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UgrCg5dx;
	spf=pass (imf16.hostedemail.com: domain of 3UEuCaQgKCEMonfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3UEuCaQgKCEMonfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770146641; a=rsa-sha256;
	cv=none;
	b=tnrovmK133pzi0kH9l+vptTiCiqj7xC5Hezfrt8Uw5C0w5xBIkpiCNXm2y/JSnM3XBTn/2
	BRD20ouYdoSH3ybcB+eXusIg77XdmOYtxQ65/czGPnzNiDs2AS1FoK4mejxTLDZNQw/TJi
	Y3bvUupFGn83Tq9Yj5WWrbQqrDjCXHA=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a773db3803so61342195ad.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 11:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770146640; x=1770751440; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aquur2bWSawAVy++fhfPAogrKIXUck0YPKC9WFv0tRU=;
        b=UgrCg5dxPuk7DhRP8k6uedlyvmYxW+WbmiGZKPllfoW7M/TxONzpw0f5GXoD5D+1/e
         9ZHD0iJgbARA07spkgora3dLc43xa0D47qBnYNwKb7W2TTD8UnxBt7z+Q6LcXo5LeUbQ
         i/EHcvbs39WR3HYaazXex6ahh4MW3fGLBFfy9ma/VxxVI17dGbzo15DlGQWcoWhzYOo2
         GhfF5emyImVsoSP34A/mByJnOWRO9DOFHVAY/WqMCq+OtgW9+rvm8A4UvIEu6rUMhDrA
         YjtvF2VquyE72gH3Aw0Rz0+tYTPAPBOkqnm68XAGABMwJr2nITwKhUHWfy3gz9ucJRR4
         2AYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770146640; x=1770751440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aquur2bWSawAVy++fhfPAogrKIXUck0YPKC9WFv0tRU=;
        b=hWUn2p27R4Qtq/MzxOfAhJsCZU6xKRTVpg94ezRzZDHJ8489KZAAaSx+phUn5bmOmd
         Q3G+9mG1jk6cxVJbALcdpRlnY6Vh3++DpPkk4pvjR7aJ71r0cfNesHhGEINl9vun0lUD
         s4LqG/3JNsDd7w6C8hu0KBpvNJj6c74Ao3tXwz2gO3N7br7zF/Yine68fcc0dXKzsOGH
         Nwfe7+GKoS2EPiQpjADv+SABo3mO8/BS/RWoQjV/oPZcg3RfspS0cI9pvsmSlLU8ZyEC
         6KKZtkXe51UD1qYsG4m97kK9C5//dyeEXGkHIHrBCSBMtLxka9zdnTHWTPdZ1xNfO1ql
         Sgew==
X-Forwarded-Encrypted: i=1; AJvYcCWveP6nUpHstnilGiYDEb6eHwkujvug+DZibZiBQa/NVDE9otED+5WKaCu51VAUc7DiCEAjky4uFw==@kvack.org
X-Gm-Message-State: AOJu0YzpCCrLJ0RlgtfLva/jG/Q2eVLZFNu4do3mR0q0TzO5It46OIQ/
	1huTW0S9hSfERtecP42cAtWUbByd+jQ/HDgnI+2KOZfwsbV81mhlNSyOE2IZ8mPBxHUFK1uXSBj
	+HFopKCBO8fQXfw==
X-Received: from pjvv12.prod.google.com ([2002:a17:90b:588c:b0:352:bd7e:99e7])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:40ce:b0:2a7:c8db:488a with SMTP id d9443c01a7336-2a933b9d168mr3697935ad.7.1770146640258;
 Tue, 03 Feb 2026 11:24:00 -0800 (PST)
Date: Tue,  3 Feb 2026 19:23:52 +0000
In-Reply-To: <20260203192352.2674184-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203192352.2674184-4-jiaqiyan@google.com>
Subject: [PATCH v3 3/3] Documentation: add documentation for MFD_MF_KEEP_UE_MAPPED
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, william.roche@oracle.com, harry.yoo@oracle.com, 
	jane.chu@oracle.com
Cc: nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8EEAC180008
X-Stat-Signature: 8ub34op93m4x73fkkd8wwc4s15kui5as
X-Rspam-User: 
X-HE-Tag: 1770146641-712677
X-HE-Meta: U2FsdGVkX1+jOkbNAZ/NHtCEXQajOoTJaEIIcSAILEroU8Lbv0pfBR5jtEy8gzNpNxxjPXBV1vof9hX2F1GmqnADbopH0VoID1EZhLiwZci6R95DtAPTe2iPuK4YR5EoNyRAPScs69dTTxBNLjLjN2Ukus3p0KxKKOZlxHQfKRwVz2zyJCK5bRVm+BkmeGBz5KxqkDnQYIoYJ2+ZIAUDhQN6XBCzgUkw8O3tU6BmTqqNY49tgiX3QBVMrEnRe/n7pxoQ355BY27+NQM6HG6rNYQuT7NNNAJZt7E5sc5FF6CLUOa+ibLQJU3WHPo9AKCfupAdyiQySDbUV1ivvKzGIx7BEpEA1qxNiaNxjuMJ6/mkVVHSxcq34/yYrU/bo0lYaztKlsXE+J6T4lPSST3YDzpZGEx4p/UtGtYA8DxkZ5y1K9UT2sxwnCKpjNxxjtsPYqi7xJ4RqGU/FvDmKlosEU75n6x3X0YcrFoxUfjn7MMwJ0vT0rGou/Up4NiFtVtGbuywRu1Er94ue5v8/gKmh7eBLUE4ABSASx9hJnjKeaaTgYoOrb1ZRiuD5o0E+9OOUZnePdrMcCQfpi8JYx+bY9zCoPXrXAwAiOHA/4vZc0aohbA380gHCO7DOZDGcbExeSyWP9YDneMeNFnVdUULnOAbIKrynp1ldNPpQ+ZG1RROk4Az5kaQU1rC4D8upKc9UoKKj+aIKEH1XvGwoKbrWcFq/oH5oo6huhswgzy0IOX5soOCq26RNEdtGn24t+3cJ5a/u3gnYacJZuN8e09yAxbF8w8QcSEeNsVcqI7dSuoUA7TLygBoWMvwNgSEFq0ltGGGGnjRgZSoL3cABA6HzpA+dUMAa5/hS2/X8TKGz5s/pOdNwFsRSVFNpjfHpQ+2ahj/1ikGIWTg5bZtgnH4DpCIMc6fDCdMfBpzcEjJKLdlLDUwLelWE1CtDRxMbDqBZK1eX45VGhgDFCFXl0N
 PAk1pkKK
 FAORr9POCd189mxwzWoc1+t2Np+wImFPLO9TtH8U8JLU8avOq5QE9ESWgt5Rf/l/rGv+N+IG6rb3wudtnnoA7fdUF/J8gUi1dddUHsiclgryU4tSHFgT34occwD9+azY8qLQk9W3jzYxjPjMWTQS00c2D3ZPiYXdqQQU/t1+jQxEPiTg9FoM0r8SBbYhpM8ViuMtaXgNKUksJuAMAhB7NNQwqlttAsUpjgqNhSRVojwRp3lO0mFRRzamesxB0j6/IEnMIdT8on/DQ+66/dJtHgJcYQ7ALSBtEmzIuB3g4e/I8NVbrgc7lHO5xW0VsAIZ75djgstVCNBkKZRscg54yRv44WNQeYNb2f1vSfhxTomKyitNmAJpbmseI/paANHkvU/4ExMdLMw19b+U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document its motivation, userspace API, behaviors, and limitations.

Reviewed-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/mfd_mfr_policy.rst          | 60 +++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 Documentation/userspace-api/mfd_mfr_policy.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index 8a61ac4c1bf19..6d8d94028a6cd 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -68,6 +68,7 @@ Everything else
    futex2
    perf_ring_buffer
    ntsync
+   mfd_mfr_policy
 
 .. only::  subproject and html
 
diff --git a/Documentation/userspace-api/mfd_mfr_policy.rst b/Documentation/userspace-api/mfd_mfr_policy.rst
new file mode 100644
index 0000000000000..c5a25df39791a
--- /dev/null
+++ b/Documentation/userspace-api/mfd_mfr_policy.rst
@@ -0,0 +1,60 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================================
+Userspace Memory Failure Recovery Policy via memfd
+==================================================
+
+:Author:
+    Jiaqi Yan <jiaqiyan@google.com>
+
+
+Motivation
+==========
+
+When a userspace process is able to recover from memory failures (MF)
+caused by uncorrected memory error (UE) in the DIMM, especially when it is
+able to avoid consuming known UEs, keeping the memory page mapped and
+accessible is benifical to the owning process for a couple of reasons:
+
+- The memory pages affected by UE have a large smallest granularity, for
+  example 1G hugepage, but the actual corrupted amount of the page is only
+  several cachlines. Losing the entire hugepage of data is unacceptable to
+  the application.
+
+- In addition to keeping the data accessible, the application still wants
+  to access with a large page size for the fastest virtual-to-physical
+  translations.
+
+Memory failure recovery for 1G or larger HugeTLB is a good example. With
+memfd userspace process can control whether the kernel hard offlines its
+hugepages that backs the in-RAM file created by memfd.
+
+
+User API
+========
+
+``int memfd_create(const char *name, unsigned int flags)``
+
+``MFD_MF_KEEP_UE_MAPPED``
+
+	When ``MFD_MF_KEEP_UE_MAPPED`` bit is set in ``flags``, MF recovery
+	in the kernel does not hard offline memory due to UE until the
+	returned ``memfd`` is released. IOW, the HWPoison-ed memory remains
+	accessible via the returned ``memfd`` or the memory mapping created
+	with the returned ``memfd``. Note the affected memory will be
+	immediately isolated and prevented from future use once the memfd
+	is closed. By default ``MFD_MF_KEEP_UE_MAPPED`` is not set, and
+	kernel hard offlines memory having UEs.
+
+Notes about the behavior and limitations
+
+- Even if the page affected by UE is kept, a portion of the (huge)page is
+  already lost due to hardware corruption, and the size of the portion
+  is the smallest page size that kernel uses to manages memory on the
+  architecture, i.e. PAGESIZE. Accessing a virtual address within any of
+  these parts results in a SIGBUS; accessing virtual address outside these
+  parts are good until it is corrupted by new memory error.
+
+- ``MFD_MF_KEEP_UE_MAPPED`` currently only works for HugeTLB, so
+  ``MFD_HUGETLB`` must also be set when setting ``MFD_MF_KEEP_UE_MAPPED``.
+  Otherwise ``memfd_create`` returns EINVAL.
-- 
2.53.0.rc2.204.g2597b5adb4-goog


