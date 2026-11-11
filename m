Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4F1606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kXoNFNRu
Received: by kanga.kvack.org (Postfix)
	id B54E46B05BE; Tue, 10 Nov 2026 19:24:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2CCF6B05BF; Tue, 10 Nov 2026 19:24:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42B16B05C0; Tue, 10 Nov 2026 19:24:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7166B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5830014017C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:24 +0000 (UTC)
X-FDA: 85420941648.19.3BA068A
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98592100008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kXoNFNRu;
	spf=pass (imf05.hostedemail.com: domain of 3tbXzaggKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3tbXzaggKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356662;
	b=kd4F7qOKgVxo+WEtnH9fw24YpGVJxImRx5TTOAvbdaE2NIs/WhVXtyrJVgi5r3VcoABqGe
	b+wqZ2bkU8zUoWgE/51H0Ms6EXCqkiTUi+PbWalUy/IcEjxRjzvhY8kDw8uvbhBwsU1JoG
	0tarh4cRyD4Nsa/4HBYCi1VpP+CJVS8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kXoNFNRu;
	spf=pass (imf05.hostedemail.com: domain of 3tbXzaggKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3tbXzaggKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dKUASXcgtiRNT2+c3YhFYhMVcr51Eig0y+PlMV5erc=;
	b=Xs2vEydfr0Qy/YBY2iVQrFfFxtK59duTrR3lyjY4FbIth7vAcvPOOBBo1MyxKTaTBN3FtE
	+qIvX2bCdhhXcc3yfsyS29WhsHippgsooCOIsX/nnhfjxFFtBbf1WJ9gALcuC7kphhGx5o
	X46/kBfWBrbRe+VIVYavKd9TnAQN5wk=
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-8520e83f715so2909362a34.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356662; x=1794961462; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/dKUASXcgtiRNT2+c3YhFYhMVcr51Eig0y+PlMV5erc=;
        b=kXoNFNRuXMmY/rNmt3Njk/kLuCcQYHeSFLoOZYVhFwdjyZHmOwQo7XQ1QWQsRppjGY
         fLhaGKm1NKBZ4L13lpndx8Dge2vNVlTjWf9ZkfK4u/FzWHGvM4uwVFikh8VYHH6RmtPt
         8IFAMeAmtJNzPnr31qQ64FOuzJFzfuTv+xLFEgwO+AIjMlXnFIMWGM5aGzqrTMUprsqE
         lufOui4WSqXZJmBog1qu1oxCzvBKJYKyNBgxcxmgyyRTZzq7H2N9z2Yfj2RtPuBE8uDZ
         8bCroTXBaY/FMo4xIAG3+DfmJ3eZ+26m+n/TGXSpyjYUOOSAZq/awyn6sV2+ao5Qjhut
         IN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356662; x=1794961462;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/dKUASXcgtiRNT2+c3YhFYhMVcr51Eig0y+PlMV5erc=;
        b=r/OwrhfQcyK3kJPCJ5ViKfLfROF0EECDM34DCvqPRKg/aVlJnzusaXDTb39dSBbuCU
         utSjf0vl5p3NBkgsMHgtm2Aip0/J1lY2Gw4r3+l0TXt1lcRJm0i8W2VsY8mg+1nX6SEf
         kEs9TJrwIcNHBKJRsoVR6xLJSDmXYOGCd+H4C57gt5Pkf+vfDPfG5tFKqIOnp0oxZgRO
         iT2EFrNAXsnF6zQkIJCvhA0r8anfDRiTJDswFFI1h7XNMVQb5gNq1/21ZhkZDKRUv+O9
         oV/t6ExhKqPyvgtQs3+UCNFkrHRtlwso464/S77//aOnmXXX/KYedypz67ixU1NFBU+k
         VPTQ==
X-Forwarded-Encrypted: i=1; AL+hErEBmJwtCoV0m2oI9FNYVHzqXLCeADJXR11zcuuB9DCWWE/0vylW3zXHyB57S7uQ1vn6AAXWGJYU6Q==@kvack.org
X-Gm-Message-State: APuU4Z/gZPOTQibWtVLe44Dor6GiyrzccOQWMsflGUQkr/mDuliErkfU
	s9hI8NXV6Ynp9LQLoTtBOsoDe4YT97FZq70KaXQSxcgD7ckjVauMRRQE3ZIsJskh5GTV+9P10AX
	0s5CIUpXLUMDKTQ==
X-Received: from iocou21-n2.prod.google.com ([2002:a05:6602:c315:20b0:9c7:6af8:db91])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1246:b0:53b:f634:83b2 with SMTP id 5614622812f47-56b903e2f53mr602569b6e.0.1794356661391;
 Tue, 10 Nov 2026 16:24:21 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:49 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-12-dmatlack@google.com>
Subject: [PATCH v4 11/19] mm/shmem_luo: Require permission to preserve a file
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: akfso1kuxf9ktzxb3mos5f19quazd6np
X-Rspamd-Queue-Id: 98592100008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794356662-171985
X-HE-Meta: U2FsdGVkX1+T3+kIFvNbijxzXD33S8rvSsJWejvkRKTtL9IFeCHmI7r6yXbnn8RuEmST3CpBuFrm1zKNUMFeU4tMD4RsPe1pSp308sPJn73xru0P3gjBETs/xCZxgqTK38AW1phM+4yzS9TfozocKaq6L6MaXYBbKmJ14yXxmqBnuThH6ogDlR/zmcZRp7M4girJkd60qGCF4XeCZ6+r7M/Sh8cSoNCQD+IQVkCNzVcsUNKJ4G/0IhqQehr4Blq1iXYqvPbd8GPbArqhAdL+Ij6wQzF4uEuFzzReeuHMcUfO3Zo1KuneZAHlDa5f8R3RKKKDUJaks9xp37XO2kW+GR7dWyv3qzwjh/ObZuLG1QkWbpWRiOL1gfGFhh6UMInujNCDczgL1+kBYCZMGay2icDClXX4NTy4n7SwHygg4BJ3sKRvVLBnjwA1cmwDzJZ80SGrLbPyWZDzKj44tPiLUPriWQrl2fSm8JX/mHMGwkOyXip2Euke6b6/msBkT7FmwqEQkf7dkB/HTIo935RgGKv4mIm695ZKBw59O7YbCF1amGnsCpBsam7x7JeQSZpxxX8Lveg9kxxaHbezlQsME+Q8Cr6BWiUPicn2T854HUCEXrsGjsVPbhiE5Y6/LAMrvX21o85/gQx6fdX313GIpR5bTMBixqPpK9BhlRUEMdE//Ox7dfhNMzMYGpQuwTxdp6psoWO583EoWiK6aUoYI410fEELWoTjBdpm0YDN7B+KyPw0lZ3SgjUEeL2i7rivcOSYJMy+9UEky/sbbENJ/2OKMpzZlg9tpP/XddgjeLP55kVyiZzBFkrPtHiqmSW4u18i+LwaK/W90CohzgF/W8J7Iddbpy0EteJQhVnH9tXhZWqLfzgwL3bO4hHkFQhufDUeuL3Zps1QqgoFZpYo121gSvg228/qkLExbaFTkMxNkzFLiJo3O2h+zT/thuVwL6rdh7DARv52NImwize
 HxdMd92Y
 9PRZ0n3A4OO4/P65zRpTjSvxn1Z3MdQjgf89dxxA1CsjQqyz7cfVhixOF5tCMFTtqINIqcWnr6F3vnpppFlyB5r96t/x/NWWJv8IxbDhi4rug5XF+/rfwWR5Nnk74r5KMJbx6Sj6/vVEM4B2bJkpzNshVQAZ4t9QNapLZi31KvwBuBpPT049AzbDuWTVh7Pz0TWcShBXkGxw+bEP542IgmTQk6UIQnlMuXoWrsf/D9CSAw2CqXor2ljStrrtFjeR8GuZSEkK2zEQEUg9upIqyKcAPr3KKAGthCCkPLq0irvt/vFQOvserMzTotT82kqSuh3xLmY/JNu5YRtnpCC4evvzSPIxtuutju1J94H4O8GinNZ6uHT2wUhx7h3HV4+9MFL/MZuP8WPkjBueM0DhEHphIFD4ogNrdfqeIcOcIn6F1bURK3AZZCdbgOQRuz5Sq0JsA080qkXF3sC4KYDoLVfP6AKkQjTvNm78pV3RO4tnnmw2MloZfBjJNeUXidHdI+LVgV57bFB17/+xcOsHf+rXiBRV7QwQ5FlTecDAgwyqj20Gy80PZRTiRhupfpj5KqYhOQjrCqtDsOv3gTdFTwC+nauOS4yswQDvieIrbjUR3PwOw/pKXAmxB+wgL2inmnxCH+piY+rDMe/3ep3f1Tmxo4KEl0QX3OSqZoDClkjRDRe64TBhq1J+PweHquXm1lYCX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Require the file to be opened for reading and the caller to have
permission to write to it in order to preserve it. Also let the owner
preserve a file that is immutable or on a read-only superblock, and
reject append-only files.

While a file is preserved, its size is frozen for all of its users:
truncating it, fallocate() and writes past its end fail with -EPERM.
Today any process with an fd for a memfd can do that, even one that was
only given a read-only fd. Requiring write permission limits this to
callers that could truncate the file themselves. A file descriptor
opened for writing isn't required, since that would rule out preserving
a running binary, which can't be opened for writing. Only the permission
of the inode is checked, so the mount doesn't need to be writable
either. The size of an immutable file or of a file on a read-only
superblock can't change anyway, so its owner may also preserve it.
Append-only files are rejected, since their writers can only append to
them, and freezing the size would stop all writes.

The retrieved file can be read, so also require the file to be opened
for reading. Otherwise a caller with a write-only fd could preserve the
file to read its contents.

Document the frozen size and the permission requirements.

Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/shmem_luo.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index dc6ede528822..bdf90aac5820 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -27,6 +27,15 @@
  * the file are preserved. All others are reset to default. The preserved
  * properties are described below.
  *
+ * Preserving a file requires it to be opened for reading and the caller to have
+ * permission to write to it, but it doesn't need to be opened for writing. The
+ * owner of a file that is immutable or on a read-only superblock may also
+ * preserve it. Append-only files can't be preserved.
+ *
+ * While a file is preserved, its size can't change and no holes can be punched
+ * into it: Truncating the file, ``fallocate()`` and writes past the end of the
+ * file fail with ``-EPERM``. This applies to all users of the file.
+ *
  * .. note::
  *    The LUO API is not stabilized yet, so the preserved properties of a memfd
  *    are also not stable and are subject to backwards incompatible changes.
@@ -255,6 +264,30 @@ static void shmem_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 	vfree(folios_ser);
 }
 
+/*
+ * Preserving a file freezes its size for all of its users, and the retrieved
+ * file can be read. So require a file opened for reading, and permission to
+ * write to the file or ownership of a file whose size can't change anyway.
+ * Reject append-only files, since freezing their size would stop all writes.
+ */
+static int shmem_luo_may_preserve(struct file *file)
+{
+	const struct mnt_idmap *idmap = file_mnt_idmap(file);
+	struct inode *inode = file_inode(file);
+
+	if (!(file->f_mode & FMODE_READ))
+		return -EBADF;
+
+	if (IS_APPEND(inode))
+		return -EPERM;
+
+	if ((sb_rdonly(inode->i_sb) || IS_IMMUTABLE(inode)) &&
+	    inode_owner_or_capable(idmap, inode))
+		return 0;
+
+	return inode_permission(idmap, inode, MAY_WRITE);
+}
+
 static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
@@ -264,6 +297,11 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 	int err = 0, seals;
 
 	inode_lock(inode);
+
+	err = shmem_luo_may_preserve(args->file);
+	if (err)
+		goto err_unlock_inode;
+
 	shmem_freeze(inode, true);
 
 	/* Allocate the main serialization structure in preserved memory */
@@ -317,6 +355,7 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 	kho_unpreserve_free(ser);
 err_unlock:
 	shmem_freeze(inode, false);
+err_unlock_inode:
 	inode_unlock(inode);
 	return err;
 }
-- 
2.56.0.542.g3ef89b7020-goog


