Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E167AC624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4EA6B009B; Tue,  1 Sep 2026 14:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702326B009D; Tue,  1 Sep 2026 14:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DED6B009E; Tue,  1 Sep 2026 14:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5036B009B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 938BD80516
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:30 +0000 (UTC)
X-FDA: 85165975860.16.1EEA171
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id DF1A640006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GWaHkUeK;
	spf=pass (imf27.hostedemail.com: domain of 3XxSXaggKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3XxSXaggKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abQNPJxLdJSbNwggArhdklh2mCXd2+hz+eKc3bSV4GE=;
	b=Zt2qC+++n+PoWbNKCgr6QRmiU/+SOJOs/DpUKUDOZv+tq8uAaJKq5kAaqauCA8qeoKuJxG
	HXVCD4K/MXY6JUbsOWLwQjIKeWlKsxgt7h3VO0dTdOc0h8VCmVxT/MrLfkJVkTzpoj2tT/
	vLEAr03cqmkiFTmcG6rOxHOTzE6Yo74=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788286048;
	b=AOfwFhSkvOjbShgD4d7kpb1aXU6qgEYEcAYW71adhYGctlEFtYi4uHA5t9+sKJu03d1Dso
	kUzjoSB2KNOBQOnX3ItjV3/7rkFemuCBRtpYXCptbksOSJxTYcGSgVe8Z1aF+lG5Mh/7gA
	Xn20cwBTfNEFh6oi+tKecoJUo7DNPsk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GWaHkUeK;
	spf=pass (imf27.hostedemail.com: domain of 3XxSXaggKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3XxSXaggKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so208220a12.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788286048; x=1788890848; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=abQNPJxLdJSbNwggArhdklh2mCXd2+hz+eKc3bSV4GE=;
        b=GWaHkUeK/quhtr3vLUZBZCrunV4oA4+aKEb+kRosgXl4phYIpeKaGkMBHDtbfESqxi
         MS+/1ofED6V5bhTwpWuxK7XNrwCgFqNP4TmX6V17tXRBjMAGreCB5q4z0bWzSG2xKoXR
         J99LAA1n+9r4X9SnjPTZ8WxMU+xN0O9jLe5YgkCVgAN9buveBBemKur6UyeeOUuybNPU
         L4eaTcv+e3DfOSOAW5bfkxp/4xATAx1AXzrDnOG0vlnvV37CRc9jHAvQf81tySSrqEKj
         zZQ9ylHoaVfldOP3Imf7TUU7sc0OZznYjEdRaWkAV2hhzE3/QvbSl72DkcJ97iNN5Wp8
         Sulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286048; x=1788890848;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=abQNPJxLdJSbNwggArhdklh2mCXd2+hz+eKc3bSV4GE=;
        b=Kyb+aZMRdMol+zFGt0X1lqdZE/Ow7Cgbxy0IDED/2cUMeI8De84XHv237SNeZQ+cDc
         jznbb60t7OLG2h7cnmqb/BUDU/kq/cItq7XQ7IyXHIQqfiad/4ihhxsUdIsRZ2VEQE47
         XkpTHlNuiwbnuCqRSe1nCkaWryeknXdCxKYdcayooBhCBG/r5BLHbBGQLJHmzeo2c9EB
         OosCHFUtrIlX6A/gVfnyc8ajCPkB2pnwfNoO9pLvklqYTIrAMKXchFgqNRGFzXTYYQyt
         BAG4vybJgEIie42aqmS56cdTD26p/BOBPoU6FJAFBZEMkaLiMArIxODQr3ykpOb40XEH
         SEBA==
X-Forwarded-Encrypted: i=1; AHgh+Rqr1YCBKdICWaCLdJKrLt8U7e2NM5L2miaHH2XDIEV7ZQCsk+3oainOXnBE67IsdzHk+7VOdFBA/g==@kvack.org
X-Gm-Message-State: AFuF++nYfVFtRlZUnpjYXusye6nRdjW1OM7tEJFB5JILVKO16EmL9tkr
	iSA45XT/rxW0D4dj5kxB9jCcD86xkVeN4Pcau0ieevFXFwIKuQ8q1RyBr5Fj1kABdYcnx4Yfdlo
	LQp37v6T0FaqCsw==
X-Received: from pfux35.prod.google.com ([2002:a05:6a00:be3:b0:848:7bbd:284b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3309:b0:835:6388:655d with SMTP id d2e1a72fcca58-8562ba7dae0mr58420543b3a.14.1788286047461;
 Tue, 01 Sep 2026 11:07:27 -0700 (PDT)
Date: Tue,  1 Sep 2026 18:07:12 +0000
In-Reply-To: <20260901180713.4185641-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260901180713.4185641-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260901180713.4185641-5-dmatlack@google.com>
Subject: [RFC PATCH 4/5] mm/memfd_luo: Expand support beyond memfd to all
 generic shmem inodes
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DF1A640006
X-Stat-Signature: bdgeoj4nxmjac13dbai7h8fx9673p9tb
X-HE-Tag: 1788286048-845644
X-HE-Meta: U2FsdGVkX1/o4UZacwxRKByItI5Xi872r7q9vJSUdvyHRJ63xzszJNH8ujRmhSzZP9320DPfMFdtyOIpc9HU5iHOVfwb+X3KxIs7Hk8sdZqu5qGknFegsmfacooC7HoJPsXHlDRgMIbulY/Qt/aGm3N1NYXWYSqRRHg5MVkAoCfzQ6gPiZtd5iYRbEk1SeXTuCnXRDHTG0+LGBSZ3kkokGL23quLdY8l/5C5X+G7TWs4sUwx21s8RCJIG2rwbIBwpzSt8yPY9wCXH86m+xi/0SkLCWEcqaZj/64R43XrIDsCv4uninH6Uz/uuav4Vu7Ip/TIKXRDVNnMDUcN2hH2hNOvE6bZz7CdHlsLCEfX1bcvs9wR2Axfno/nIXh3B8IEyH4ahqP7o5AtsrNZIWiJ9Jh8wm8ApYrJlQcJhIMmm6Rc1Z98huZdZ7crJM1qNoBHQNVzWuLoEjWDkG3k5y1n29/FH3fV5x8AM5kzMe0khsNZTW+UoIqYdPrBVmoDTY7SfWnsKlOQDw01zpxGABLuams2iPUEhRpsMYuVQa5/c7oe6eD80Fl5JY7HO4kon8cERN0nYXRWBetH7UxRzk/cv5v4Ewz8ZAz0tNaMe3IOQPLVGmghnJjgzz/jEs5qs5t/1EbMfDboE54zIR6Ol/VrMm66LtA9sCCKsZykMbnkRhn7ZVxZt0uM1hqoUd+lJh4BJbBj1vKwrsqRezVZgpnnNc8gku0ELHA/24JiqsO2/h2F6XzaKIkZUcinJuhoteXEQy9OrjAoDjIvNvniLWF2OshQF6jtxxEvHjZc7VImu81/JSKvRAutuBhAHz5C0V/+IASuBDxJtatzYIOyiuJaZwqBSEgRCI706Kl8PDhdfwGgnfsQVRBQYka2OaSws0MZgfFhAeUI4AexGz9G7r0Ozmxq+KZ4Qvqfu0YmRGk4x2kr70vJHm+JTHfzHKlLyD8hNOg7MWqoTFzID1qqhlX
 KmmrKKrs
 LfFA18gXkzr8vMICt3gPLKvmgVCJrdPtkG4OGkF2xtCfxRwyJGmXvJxLivSKseBWO1uRFR01sg8cTd7ulp3CwrTksOSYVUWlM9QRncruAiBH5cUM755ULrvX/rhHcpD+JvlR+HETs2JPrE6JihGunJBBeqlcFo+A4I/O26TaF56y713S9B+hX4DncRVV05VlHm4c2BGQ4g9IBv2FYH4GN9wnOv2Pltgs3+ZWBGeNyKZpFSgwG6oSebWgMc0riHoQ7ZKy5epQ/FCThtOYr1MYfhGsMfK/wBGlmkLAL+HlkqFuQO0nj4b3pr1Yvt9lAsH2huhBu1GNaOKCj7vQMfkzi3CZuynbJqlKB7cNcPaE8WoFHScErNTyiT48Mb4c78Q3r/R0TBZ5VTKJM0V3lXcIG+dxUVZCKcLOI/yWl6T/MnoSOqumevV2Nk9MZxAVRsqeZ20dGp+W8Ha3mF8AhWnei1O8JltNR0srDigiLtbmosCG+c4wu1fSZDaX2UytrdpXGvIGs5pMG3Ev8vgoYlRS3I/8ktosG6u6i7UaetpfDXMuUCjKo+06LDJTARiP4Y/c/Z/3Vmf/ZVZza+cBfBHdx1MO1q4X+YTQTeYx1OkxZzjBQ6nNXvHEnxQt1iINPG2+oH8uqiNVequAKSdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Relax the early validation checks in the Live Update preservation path
to allow general shmem-backed files, completely dropping the requirement
that the file be unlinked (!inode->i_nlink).

This officially enables userspace to push standard, path-backed tmpfs
file descriptors through the LUO session ioctl instead of being
artificially restricted strictly to anonymous memfd pseudofiles.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 mm/memfd_luo.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index dcda5bf98646..107115c97bd8 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -9,14 +9,15 @@
  */
 
 /**
- * DOC: Memfd Preservation via LUO
+ * DOC: Memfd and Tmpfs Preservation via LUO
  *
  * Overview
  * ========
  *
- * Memory file descriptors (memfd) can be preserved over a kexec using the Live
- * Update Orchestrator (LUO) file preservation. This allows userspace to
- * transfer its memory contents to the next kernel after a kexec.
+ * Memory file descriptors (memfd) and generic tmpfs files can be preserved
+ * over a kexec using the Live Update Orchestrator (LUO) file preservation.
+ * This allows userspace to transfer its memory contents to the next kernel
+ * after a kexec.
  *
  * The preservation is not intended to be transparent. Only select properties of
  * the file are preserved. All others are reset to default. The preserved
@@ -24,16 +25,17 @@
  *
  * .. note::
  *    The LUO API is not stabilized yet, so the preserved properties of a memfd
- *    are also not stable and are subject to backwards incompatible changes.
+ *    or tmpfs file are also not stable and are subject to backwards
+ *    incompatible changes.
  *
  * .. note::
- *    Currently a memfd backed by Hugetlb is not supported. Memfds created
+ *    Currently a file backed by Hugetlb is not supported. Memfds created
  *    with ``MFD_HUGETLB`` will be rejected.
  *
  * Preserved Properties
  * ====================
  *
- * The following properties of the memfd are preserved across kexec:
+ * The following properties of the memfd/tmpfs file are preserved across kexec:
  *
  * File Contents
  *   All data stored in the file is preserved.
@@ -580,9 +582,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
 				   struct file *file)
 {
-	struct inode *inode = file_inode(file);
-
-	return shmem_file(file) && !inode->i_nlink;
+	return shmem_file(file) || shmem_mapping(file->f_mapping);
 }
 
 static unsigned long memfd_luo_get_id(struct file *file)
-- 
2.55.0.966.g6673acef38-goog


