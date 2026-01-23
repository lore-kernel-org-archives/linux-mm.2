Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E79FD72367
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E276B049C; Fri, 23 Jan 2026 04:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CB36B049E; Fri, 23 Jan 2026 04:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878DA6B049F; Fri, 23 Jan 2026 04:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7319E6B049C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:59:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF2D91401D6
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:59:11 +0000 (UTC)
X-FDA: 84362780502.14.A462796
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3B93A1C0005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:59:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ty+NY1Hr;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769162350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OraLy8XeIZjSbX8NkjbCmR86yFe9whSrom3FX0RuLfQ=;
	b=G06BT/c62TB7rDd5XG5ISf2RzIqQBof1gLa4FZFEtOuEKZ3K2L2H6kGiW3LRMCfBsi7E4C
	bKEo8qCZzo1cu7F0S7PfIy7QXe4gz0O7cn8rDt/TmB7DilVeAasyhhAa6V1V0OLXDhJlsg
	w0XeT5lHns78DNkjf2kyIBod/2Z5QU0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ty+NY1Hr;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769162350; a=rsa-sha256;
	cv=none;
	b=VhYvZV/Vi98UC6VMODbS7GQws/yiY+qJH1q9kY078XgDGFJDVOcgX0okk5KT5Zq6TjCF69
	7fmyg+wbBOXP9Kv5yb1p70pG3C7Hyl4cs/8sBL+h6CY+aWze8ZwJpp+IJXmwrPn1kjp1dV
	G1OfNw1pmYW3HXQNCXbUEEXHxy/XJ/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24E0543CEB;
	Fri, 23 Jan 2026 09:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18175C19425;
	Fri, 23 Jan 2026 09:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769162349;
	bh=JvST1LRGXZAf6Fyp43JKlkKdk/TN8dTyoER4Anwc9lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty+NY1Hrg5UajXyM+Q53oJKE4lYESs2Ndf+rrFZyw5pJWcm5xsIKI1M81U/M88o4t
	 6IJzU0w8L9WRwVIjLWvHI6yTSrh2shg2g1jDjpzIzu9SLF22HeiOs8HZUSkeMOO554
	 eNrgEcRxRSUE8dV4e6skUucVCyYLm/CgKNAlktZzmlkPPqEaas8BY6rSMTLzYKEo8/
	 0bS7kgysYI3H0JHAYcpov9Epz6ufCGqgafeXowxD4ICwP0M2xtAyQYsDZUw1BqM3fp
	 DynHLuIgjz6nJpa/6iPihIquJZcegVo5xCJaTBInm4jlAIDGmKek8t1d/Q5A8b3n/C
	 ntzq4giz/m+Xg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] memfd: export memfd_{add,get}_seals()
Date: Fri, 23 Jan 2026 10:58:50 +0100
Message-ID: <20260123095854.535058-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260123095854.535058-1-pratyush@kernel.org>
References: <20260123095854.535058-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nxc1zwu8hsfopkh3uajjoheg4onhw33n
X-Rspamd-Queue-Id: 3B93A1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769162350-443063
X-HE-Meta: U2FsdGVkX19df6dqnnY4WMCUf85q4QSZ1G4its4oQPWHievgT38MvMzlRj6Yjotyjfyf/4hCLrW23KJeSfl8rRCGscu9J7C+JbaXENZlQi6bl7FfLRALaQbL4P6caKWkuPlCUYBv9Y6aI2NCpDwjWBIULAMqlXGXNrc5bOWNm61reqHe6rvkdIO34zoMJzdMcH6tnLkz3slpDOFG/3xNh/HCTdikyxtl0bzXPofnGALnL5GZFUL30l7YHHYtK7YW6MWaXFbL6HmyGXtKwLqXCkEWFSV9kky/bGX1MmBM29F6GxWgTe2GI9df+Lb6IuSvVUYQG09Kl7+fxyXMErhQ02aYUJll8o5H3jw8p0vYD6E1TyuBUz8FmavRKgyKDLVUPE2HzxoCcZO97+6uq8/oTzcH9fXUGaw+IpAK0lxdAjrQeInzpphyybkHOucg2Tk2sgELqs0Jw4foRVTD5SQZop9jg/VbuqdyU/bn3Xnzd+J9Hl9Y5BOE/9P8hvdZXSaKkwY0doAk9qwfgS2RMHDRLjoiD3V4NbLOqVCvKETneBs76ow7sejENzUJ/nxnm4b2EpwC3jSwKJ9X9SO5zSUyFZ3tMEkYrjnxFkznnmBCww11OWRXL1tjZMxhblMU5WhsKfmgtggqhohZJpE0Z5lM2b0OQTo9Xj2B53G1FX7QbFfflAyBqP8kbhcgTrToYOYVfQvsfzTabTt4v/Bld0oOCeRnmVgXiPzOc5/6dy1pBs5HtwNByL7aCB5yjqOCWJitysiovaGEA8eB1TGvlXFzMfdv9vQVvVHh185LqZMjIu2UusYlCGFZBwMlZVsjrjfR2C1Hkuy8tQihG1c4QLdgvLGz0ZG6ksRcjr80/lzzVmZ5jHG4yXBVRWD09mULTNV81KKNKJjfOh67kO4G5eqY/uFmupDfGo6g4B/rHiWqONY2+TGJVeUHoxVGLIJBhB6vOGP+weW6/C7iVm34T7S
 OPPky0Ba
 70LZr+A9j11P2ZOoJdXnG0UV16pGXq22Z21zic+DgIDVUrwTzrbX2uKCA16eIK64aqoirSBLFTPTczqYKlibnJTfykXwkxh0I3d7Zsi8JLbRvbmQVsWPwkLI2oaf68toEMUxmWa1Qp2/vU3pytDXLqNWMidKaduNync07T07ypKgiFAgDTqd+9NcYkFqEof+7+tkFNcFbEe42y5Hy3g/O0RCdqEii9+rcRmq6UP9QdgQ/yeQB55Sw9kmzj3nlvpn2nyn7U5vh3v5WsKhOQYY8PNDZULNd6ZJAzCD8tk1MlN3IKd5aTa3PWo6ZfN3WkRsA6noc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Support for preserving file seals will be added to memfd preservation
using the Live Update Orchestrator (LUO). Export
memfd_{add,get}_seals)() so memfd_luo can use them to manipulate the
seals.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memfd.h | 12 ++++++++++++
 mm/memfd.c            |  4 ++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/memfd.h b/include/linux/memfd.h
index c328a7b356d0..b4fda09dab9f 100644
--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -18,6 +18,8 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
  */
 int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr);
 struct file *memfd_alloc_file(const char *name, unsigned int flags);
+int memfd_get_seals(struct file *file);
+int memfd_add_seals(struct file *file, unsigned int seals);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
@@ -37,6 +39,16 @@ static inline struct file *memfd_alloc_file(const char *name, unsigned int flags
 {
 	return ERR_PTR(-EINVAL);
 }
+
+static inline int memfd_get_seals(struct file *file)
+{
+	return -EINVAL;
+}
+
+static inline int memfd_add_seals(struct file *file, unsigned int seals)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* __LINUX_MEMFD_H */
diff --git a/mm/memfd.c b/mm/memfd.c
index f032c6052926..46c5508beea4 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -228,7 +228,7 @@ static unsigned int *memfd_file_seals_ptr(struct file *file)
 		     F_SEAL_WRITE | \
 		     F_SEAL_FUTURE_WRITE)
 
-static int memfd_add_seals(struct file *file, unsigned int seals)
+int memfd_add_seals(struct file *file, unsigned int seals)
 {
 	struct inode *inode = file_inode(file);
 	unsigned int *file_seals;
@@ -310,7 +310,7 @@ static int memfd_add_seals(struct file *file, unsigned int seals)
 	return error;
 }
 
-static int memfd_get_seals(struct file *file)
+int memfd_get_seals(struct file *file)
 {
 	unsigned int *seals = memfd_file_seals_ptr(file);
 
-- 
2.52.0.457.g6b5491de43-goog


