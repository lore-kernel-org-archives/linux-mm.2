Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8855CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D79D6B0088; Fri, 29 May 2026 10:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161CB6B008C; Fri, 29 May 2026 10:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A556B0092; Fri, 29 May 2026 10:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E28CE6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:06:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96C9C160AFF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:06:12 +0000 (UTC)
X-FDA: 84820631784.18.1C5E2AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 114D420012
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:06:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+YifSkL;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780063571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a69E3VWZkwV++uR/J0ybaVc0ASBC/CgMAkTholPQExU=;
	b=MjTPwrkpAqQfRMdqcoUQTcXdx1tjFAQWCpb7i95kGXMzNzWRcpPmLiQLypaJTV9C8rLaMd
	zcbX7npH/dUAWQwjlPwl4bEhKZZlaUrBwbqzzWVU8DL0Nw5vwScyeRGIuVEZqZWu9sDInC
	TogINfQDe5iWRHd7GxSpAZ2zFYrxQ5Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+YifSkL;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780063571; a=rsa-sha256;
	cv=none;
	b=JlSBJJkocAPL5x6OpFWvH1If1OKyXo4bA0l5pqm/6+ZXma7prWD1IyImP6huwy/p2Pp0fL
	PHOCdLi+G9dmazC4eyj2mALiN6WE1ie4LdRC39vnKZ+W7ckluhOVivagBlgKLBqJw+9Fjg
	yi64zjka0tX7tts8O5fZ9XlFDElq+aQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 735D960546;
	Fri, 29 May 2026 14:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9699A1F00893;
	Fri, 29 May 2026 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780063570;
	bh=a69E3VWZkwV++uR/J0ybaVc0ASBC/CgMAkTholPQExU=;
	h=From:To:Cc:Subject:Date;
	b=A+YifSkLcbj/rjftWzmNeXURfK9QUGa9T22tpbpxVtXlDkVKYZq/PrNU6bvsc7VgN
	 +tg2XN/bSwOB28D7I643hmCLHDd2EmldBgVeQ6chTzGTH/cXjIXQWRA5pyxKdiuMJs
	 q38BsPxGww8VGxHKFd4pXJMVvBoZXawzqwSSreahwLT3LnyGUWN/a4rjFT1Md16h6X
	 agsdDhU+3U5y3frePS32cbnxjdxKcZ19VQaxgpkU1w2t24hTDmnDThq5DwO18gvqj+
	 qpUwghfMbtBA6USfUeXuzgTQBwTfMqzc78peReUCiFwI6NgXKbouaGu/enIXqd45S7
	 b2zrEWr/iu33A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: "Pratyush Yadav (Google)" <pratyush@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Daniel Verkamp <dverkamp@chromium.org>,
	Jeff Xu <jeffxu@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	linux-man@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] man/man2const/F_{ADD,GET}_SEALS.2const: document F_SEAL_EXEC
Date: Fri, 29 May 2026 16:05:55 +0200
Message-ID: <20260529140557.1624507-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1013.g208068f2d8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4qfrjynsr64qkzpphbzc1ws7sdrsyfan
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 114D420012
X-HE-Tag: 1780063570-290997
X-HE-Meta: U2FsdGVkX1/veKAkU6jhpO2W2Xa7E5kiNyIBPTk+Pl3BzR0TuONTrPSUw3tuzk/zHx90EyWMMKfQM4zSjY5D6cq3b0m+Mei8u/zd4Q174pmDNMPDFX15XAP5OabLebIRuOP0i/CLPer0oWfNH98GvHklYaPD0umPHSu1xqqV/G1qfbjiy5mPHnODfq2ucigoh/nCZWi84y/S7yK/5wHoQEutgnKXZTwbpmWKyHM/dbdXrYZoCWQBlGex5NsL6x3bS4LnZNVveQ4KFyHTbawYX3VikGEs/rad7uy7eMqa8HbZqJHBLb7zWiHk/yOKhPRZwF9saJjeiCRiF5s8rAtm7MYpxKQkgn5hmDGi8mhcXYwy/mfsJ6Sg7JM4wHsPwcubGMRFxAcadNQ6nCxs0P5/mAQkx6Q+YsqVK4Yakl//F/MzGwuV4PGRM97oz+pB4sEFHuOdUvpOZaO20Ggg4+TNW3DW+LvCsybdpo6dImQn/gx6/KrbuJg1KTNwVLeJBxp5TLJy+pXFM+aLwUxHcA67C235GtEt0DzoPyQwSlMbDbtMjTjcMatCioqKm+0nakXiV5xyedu9JEA0GQBn2CA3daXw5aFF9Z6RpeLsAJ0Plpc/I+8ARwHsZUXLntEfjU+5Z0PFqy3/MM74KSX16YO3sRl5Ll7ZCEySxbqkOI9iNPcpzCRwhndGPn6ZzJqQH6kgdJYPNrQxuC0Zg6d9pPr/LUX4hDYhEG5802rGfamyYmPqHoeWOxJjaCl+U/xUjvIGDd/HpQ7oa/gySboF94/19CDzSLSfaBTAS6psJnvwQQpIF8sk5XQfL8iembORRkQbN6RIDzF0A0t3ed0DQgDiObIRJZwrC9pL4MSxyo5GSEjk2g8obnNbWqVCmi1D91mmZDaK0NsSsa3fqAuCzn2NiT2U2y1tYg/w5K8H9DxnEF7Vi2h+aiQ3K72wlxrxviQKU6eFY/HOwh+yjxYaPQs
 ZI2pPMKJ
 b6xUFdhloHJH0j0Syx3+klZWvZXD21+rY4JzA6Qn741JqwOVXULLxA5d4zQiY2lCnOQ7tl8aSuw+tewyCY7/j49DPaKxoMqnSEzuPcIVtBH9V4DEOleNNOlwo7szKg9qlyKlLNnNrWOaaOmRmWqHqNDnYakawzQj6Z8grAN717XlAqMVok6sWck1iFMsM//BDA2jOyhNCZiQUsPyj9RbGXriMUz9HmetA+Gk1cQbTRe3IYDocZdSi1S1cWzA4jV3nsNgp/+HWuDcAVrYxGubtIApo1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

F_SEAL_EXEC was added in Linux v6.3. It blocks changing of the exec bits
once added. Document it.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    I discovered this was missing when working on [0]. I had to look at the
    code to figure out how it was supposed to behave.
    
    Changes in v2:
    - Re-write the documentation by hand.
    
    [0] https://lore.kernel.org/linux-mm/20260505133922.797635-1-pratyush@kernel.org/

 man/man2const/F_GET_SEALS.2const | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/man/man2const/F_GET_SEALS.2const b/man/man2const/F_GET_SEALS.2const
index 175025c10..f41e1748a 100644
--- a/man/man2const/F_GET_SEALS.2const
+++ b/man/man2const/F_GET_SEALS.2const
@@ -176,6 +176,25 @@ will fail with
 Using this seal,
 one process can create a memory buffer that it can continue to modify
 while sharing that buffer on a "read-only" basis with other processes.
+.TP
+.BR F_SEAL_EXEC " (since Linux 6.3)"
+If this seal is set, the execute mode bits of the file cannot be modified.
+Attempting to change the execute mode bits via
+.BR fchmod (2)
+or similar will fail with
+.BR EPERM .
+This results in a memfd that is either permanently executable or
+permanently un-executable.
+.IP
+Adding this seal implicitly adds
+.BR F_SEAL_GROW ,
+.BR F_SEAL_SHRINK ,
+.BR F_SEAL_WRITE ,
+and
+.BR F_SEAL_FUTURE_WRITE .
+This ensures that the executable code is not writeable.
+All the pre-requisites to add the implied seals must be met to successfully add
+.BR F_SEAL_EXEC .
 .SH RETURN VALUE
 .TP
 .B F_GET_SEALS

base-commit: 9db8ca91f920b9aba40ed68de6b8da0ca9dbefaa
-- 
2.54.0.1013.g208068f2d8-goog


