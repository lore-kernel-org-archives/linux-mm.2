Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6579E606A327
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fXqtM6f3
Received: by kanga.kvack.org (Postfix)
	id BE5756B05B9; Sun, 15 Nov 2026 11:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCE56B05BA; Sun, 15 Nov 2026 11:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9896B05BB; Sun, 15 Nov 2026 11:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8864C6B05B9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:01:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DAE91407A3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:01:18 +0000 (UTC)
X-FDA: 85437817836.12.1197634
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C92810000D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:01:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fXqtM6f3;
	spf=pass (imf14.hostedemail.com: domain of 3Stf5aggKCD8kjbrjzbohpphmf.dpnmjovy-nnlwbdl.psh@flex--jiaqiyan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Stf5aggKCD8kjbrjzbohpphmf.dpnmjovy-nnlwbdl.psh@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794758476;
	b=eipNsTn0PTl6B+mbJblgSfvm5uFm7APNWoQR1IbPR4NW4wi4iLs5d5LuffvCcmKlxe/ZzX
	NU3yG1Mf3ohCusoqArRiHi7LUenT/VqoEZSzYyOJxBOQVbn8hDucKtF5evQfkkQCMleZB5
	waUienGq6dgE07LdITjFWorGYwDJabo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fXqtM6f3;
	spf=pass (imf14.hostedemail.com: domain of 3Stf5aggKCD8kjbrjzbohpphmf.dpnmjovy-nnlwbdl.psh@flex--jiaqiyan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Stf5aggKCD8kjbrjzbohpphmf.dpnmjovy-nnlwbdl.psh@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794758476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEtMxT4PROaXkntuICK0I1QFQe5PSnm2qJpCmGFKExY=;
	b=IkkzPDcfa/YJi+XAsy3J3vcs+/RH2IWSeygsg69QkNw+rvzBeAPO9IhRpt65uWATXUC8uS
	8NojU9v4TFCdySu5nBudUJw2MGetfAYJSqFcPZaNrPzsAz/emUUlJ8nPKgDPficFdRcuYx
	hc34l2JayOWdUkkEUN392GyNK9kKxZc=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ed8aca9775so24452075ad.1
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794758475; x=1795363275; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PEtMxT4PROaXkntuICK0I1QFQe5PSnm2qJpCmGFKExY=;
        b=fXqtM6f3BEjK9zLcH0AuekNeJMX4YvnB9ttPCBsOZtKm0x/Qt+pZ9vCkpV7XzzPYj1
         v5TLXbSMfOmaGTxWNqLqNmaLspm2FloAP4GptpPE/Myi/j7yUjvsUxYMdYeStQP1toMW
         OJ5PO4+PWrg697dqQy+k+w4htGGy7wm6BBiNr7uXbKyEjkiKaslWA4lZousFwUALAU1S
         Qhn/OEzRP3jHQPtCGKoM42IZ4nXSEgRL2gvnRNFvpa5ookJDuIvbZ/rX7F0V20GfYaDV
         MzF5Kx2DAfBJDtwg+9V8fVGaX89SqisXFSvOLbAivdth9X/ltOGZ46PkloYO0EUlMhCx
         dljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794758475; x=1795363275;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PEtMxT4PROaXkntuICK0I1QFQe5PSnm2qJpCmGFKExY=;
        b=xiFONlrMsL8DD8MMa4eChVVNuvGvqkRaJcCvSdMhvKAr/vEiJEg3av0U1Z7OqiSm51
         6jcp8y/72cfzlAnYXRpwGGftuvJ9ME3XJA14zKcGXCJaJVJJL4o0gOPg/UgTbW7jCPBp
         ROKHZ0kJT2foEHSodXLxi+Ps3ZHKyb64G4WskSD7BPSb8mxgZbCdFZ6MJxtHmGPjxalO
         o63yqzCwmC2yE8aIY4OmUvnNNzLN3pBeTDyLSpKk60dLncE9jyPIlwIh8hulg4sf3Ym5
         VAqAKCr/aAont+bUwmarbbHLJDQ70InWoL1YErGyaEFWJZMXqHD/nHy3COluk/ogtd7A
         NqKg==
X-Forwarded-Encrypted: i=1; AL+hErHE6Bf67sIsBcXz5cbxe5DjOUrIJSoYn7tXymp9d6Cak6zR86C/d7bKNw8QBt0UM6T6fUcwt6NSYQ==@kvack.org
X-Gm-Message-State: APuU4Z+0fkqM1OuQmi8E3/cDPpi2GoTikwZCtMQ2CkaQ5NqSinKAwini
	MTr9CMulB1b9sFcrJo8v1XNYl9QEA2+fUiDIUi6QKqWo40SpmMLI4CLAlrk9cZZPwuEusKnO8o8
	01alc2SxKvDTb8w==
X-Received: from plbkf3.prod.google.com ([2002:a17:903:5c3:b0:2e9:7e8e:b72e])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3c2c:b0:2e9:93b7:23fc with SMTP id d9443c01a7336-2edf1ed96a2mr76147275ad.17.1794758474742;
 Sun, 15 Nov 2026 08:01:14 -0800 (PST)
Date: Sun, 15 Nov 2026 16:01:05 +0000
In-Reply-To: <20261115160105.2507650-1-jiaqiyan@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261115160105.2507650-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261115160105.2507650-4-jiaqiyan@google.com>
Subject: [PATCH v4 3/3] Documentation: add documentation for MFD_MF_KEEP_UE_MAPPED
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, muchun.song@linux.dev
Cc: nao.horiguchi@gmail.com, william.roche@oracle.com, ljs@kernel.org, 
	vbabka@kernel.org, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, skhan@linuxfoundation.org, 
	corbet@lwn.net, david@kernel.org, dave.hansen@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: whmb4f37ffunyjb7n7e1tnzusbns1p4k
X-Rspamd-Queue-Id: 5C92810000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794758476-777829
X-HE-Meta: U2FsdGVkX19eOay9n/V2iFggbdijGXrMopD4FOcSpLBV9StB37Yja4JyUbjtNuqVx/Excmf/9uLImxbXmNxijzCfgEdi1N3tAEKngyU5v+YIW19lzO89ajIl4Of7jLPd5+dEzZ26qxitKeIddzKdnT1WI45yu+ircjlOAloBvskzhIJh85AnRqJ22NubM4gjf+hoMw9mynVecerRzTTTEgqxNJCitFOK55Dop/bUa4g46ucu3mnpWCGmQ22N8aCA+0i8K8dDlbXHGfViKX2DPRs/70YJATg7MQ6cSS9OUo+EB4Gn++2k/xBU9P4a+NJlVh/CDDGwwI6Ce2A3DUe3yHFx6O+ISS1srvuzJBLVagjTQ3ma0Sc4qKnKFdjH9NRsuVaW2X0kIXEbqWr1h6IUjLN5IDR+f46KOr/GyjI3cGMTiv3jnleTh1cYA/2DZZIN4IAOArnhGzNxn6EM+NexJePKrkh10sd5O/d+uyDKEXRpLfJFLIhInuYiCd5vRsubrizLmp7tam784Jojtt4tf7qoTPupMRlOyjRkwXOpXRmOUwsBa7axTd7Xw01H4n9dyyfAK38m43UBe1kujjD6zXV5MHIdSadNJYGqygMxgGyPphfFyAH9BhRRtrN1cVQdirsuEQSUiPuPaMg2J7XNHP4p9Mm3Ig8yzl+1yLod7XDudMs7WqCoCrBbYl+/FMRLjj4R5gvQlCkGgzjuHgGdppTRR5v3sL72eVva2EwgJpZAKkuJKIjvp2YhlBFCWXmDV/sm7dyH7khX04nyWvw87fpX7LRSIYa06KxI7FpP9jRfLS5VkSp006JhQ+wsueAnJ+LJcDpPzZ8+D6e2P2S0r2z+dfu0OHwRstpRjxeRVrv3px1EfNfYjRD8P1SJXSHE5zEhA85zgPFh2SdWaORwox6JjRoOCa8TlrsZxmE9V9w//OJtZUiCoeFPwZ7B5S74m1Lmfkr+G8+EiPNSJcM
 /euVY4tu
 KzHRvy2BSvjrH0k/eSdwCvnpsiM+65ytBoiDgxsO3sQNORyTRHbX8EsFOfdFubKSpFewNr3VA4WVIfJa5vfAgybdiDsfCmwFo8/zMrj5uAJz8jrCU3Hlz/+vrt4Dc5tnZEu3KgcBRtqenQCQVAcByT2knPixeAL5MZeWhbybwsr9HjM/sHZld7TWxA6f7H3QtWEGKE+AsEuBLEe6I+P9PYBPxKr0cCPv430ORZJ6pwwmhojlZqQLET1b5Ymsan5fx1K4TjaAXrBq+EvOofmRJctyUPWEffVGXbHJx9UdEGixK8SrDaVoFm7sm+JQS88HnmnUud9bjmbkHnO5/vUQuzChu2VUmL6a+g0z7sX/SSVrKFkt/GiCDf5PQz4yjqRptJguphWFIn2jQmUKOjvSoG4uWRAo1uEWcxrxSr3beiErzNiM8dBUFOHoFaM9GsatzBwptjYS2DqTENIVz44UDJ4Hh+pA5PCJqq0/wq8sVENsJsOJpIXOvg0AWBHFzqz09BkMgqDvOwpFaEveeFpW+ci8FuxYp86yluWWrleafsNDFKqkfdASCbkouITdBn9ZsS2SFrEj+JYyJ2j0MiQrDOkUI/LbIxN6ndYxgt9XmJ3NE1SJcWzzKJ9M4q4J4UNuWA/ts0cvRlseEYTvRgoU3wmootmUmBAIXQh8/rIkMWEXEd+MNtzvAYJ/Pfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Document its motivation, userspace API, behaviors, and limitations.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/mfd_mfr_policy.rst          | 81 +++++++++++++++++++
 2 files changed, 82 insertions(+)
 create mode 100644 Documentation/userspace-api/mfd_mfr_policy.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a8..9c40445ea354 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -69,3 +69,4 @@ Everything else
    futex2
    perf_ring_buffer
    ntsync
+   mfd_mfr_policy
diff --git a/Documentation/userspace-api/mfd_mfr_policy.rst b/Documentation/userspace-api/mfd_mfr_policy.rst
new file mode 100644
index 000000000000..a5441bfbe78b
--- /dev/null
+++ b/Documentation/userspace-api/mfd_mfr_policy.rst
@@ -0,0 +1,81 @@
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
+accessible is beneficial to the owning process for a couple of reasons:
+
+- The memory pages affected by UE have a large smallest granularity, for
+  example 1G hugepage, but the actual corrupted amount of the page is only
+  several cachelines. Losing the entire hugepage of data is unacceptable to
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
+  is the smallest page size that kernel uses to manage memory on the
+  architecture, i.e. PAGE_SIZE. Accessing a virtual address within any of
+  these parts results in a SIGBUS (BUS_MCEERR_AR or BUS_MCEERR_AO) with
+  si_addr_lsb = PAGE_SHIFT. Accessing virtual address outside these
+  parts is good until it is corrupted by new UEs.
+
+- ``MFD_MF_KEEP_UE_MAPPED`` currently only works for HugeTLB, so
+  ``MFD_HUGETLB`` must also be set when setting ``MFD_MF_KEEP_UE_MAPPED``.
+  Otherwise ``memfd_create`` returns EINVAL.
+
+- For ``MAP_PRIVATE`` mappings, even with ``MFD_MF_KEEP_UE_MAPPED``,
+  the first write anywhere in a hugepage that has memory error fails
+  for the whole hugepage, because the copy-on-write must copy the
+  entire hugepage and inevitably consumes the UEs. The result is
+  likely a SIGBUS BUS_MCEERR_AR with si_addr_lsb = 30 for 1G hugepage,
+  as modern x86 hardware usually supports CONFIG_ARCH_HAS_COPY_MC to
+  recover various in-kernel memcpy routines from memory error.
+
+- ``MFD_MF_KEEP_UE_MAPPED`` works with ``MFD_ALLOW_SEALING``, and file
+  seals work as usual. Seals, including ``F_SEAL_WRITE``, can still be
+  added after hugepage having UEs, since memory failure recovery doesn't
+  hold extra references on the kept hugepages.
+
+- Truncate, hole punch, and close operations from userspace all dissolve
+  the hugepage. If dissolving fails, the HWPoison-ed HugeTLB page stays
+  out of use. Note that ``F_SEAL_SHRINK``, ``F_SEAL_WRITE`` and
+  ``F_SEAL_FUTURE_WRITE`` prevent truncating or punching holes in the
+  memfd, so a HWPoison-ed hugepage in a sealed memfd is only dissolved
+  when the memfd is finally released.
-- 
2.56.0.611.g1030f0b940-goog


