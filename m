Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD84C606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=h+iZtq8a
Received: by kanga.kvack.org (Postfix)
	id 06BBD6B05BC; Mon, 23 Nov 2026 18:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043426B05BD; Mon, 23 Nov 2026 18:39:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74EA6B05BE; Mon, 23 Nov 2026 18:39:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9016A6B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2C461A09F3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:45 +0000 (UTC)
X-FDA: 85468003530.20.980CCF8
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F19580006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=h+iZtq8a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3vs4EawgKCM0w5tC4tv3z77z4x.v75416DG-553Etv3.7Az@flex--dmatlack.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3vs4EawgKCM0w5tC4tv3z77z4x.v75416DG-553Etv3.7Az@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477184;
	b=FzQGdEYn78dEHzp8knms1kUoj+OZWpW0DEPxeyH/GvlyMgFXDjCYxfZOiFuN1q+NUbS/Jd
	hJT8kK8X6Da9HUxVJA1nKQJzgelNHeFqAQyBuy77icaROXcCavfpEzHNS7rYl2penn6HwM
	8EZ6vmYUxOCbhPCVLiGdSvl4Ty/wV6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aggP6JcaAjhqbHGLe6VQCft8I9oupyLjhzJry8SU42I=;
	b=YbK9Lr815l4E4XadkuNlNAu9B/7mArLxdiqfLik50wfsDsUDRLV0RxvvAYAoQsrZVB/lNx
	XZ/uHef+sJKaJoIJm1r8+36Uu+G1d3pm5u/cht0HQoHqPMkdOUIXOLy8dst4Dpukn2RYfW
	rEBQzkg28hAhGiZTaFjhFg38At9TEL4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=h+iZtq8a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3vs4EawgKCM0w5tC4tv3z77z4x.v75416DG-553Etv3.7Az@flex--dmatlack.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3vs4EawgKCM0w5tC4tv3z77z4x.v75416DG-553Etv3.7Az@flex--dmatlack.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-83edc5c5ae9so4058399a34.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477183; x=1796081983; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aggP6JcaAjhqbHGLe6VQCft8I9oupyLjhzJry8SU42I=;
        b=h+iZtq8aKgObmiOUHPIHkaUj1zUPPiLWxGvI82idjIbSTY5jNw9T4WBLcaaezO00gh
         m4OwI/PK3d2dOwjHpkacEsW+JmCQC4M/v7LuDcKEfJdtFVYHKsL4Wc0269WxF7V1m8wq
         xBloBN+f1nfNKYg0A5n+aEpI542qnXjy0ByWpQS/zdm65W2TaXC6WBjYqHJtuiVI1eMt
         sykdI/7WPSTw/pnXqX3bReKSB25mgnt7psps7YQ5wtdasmF2QoB2eXL6p5tYxUYPr5Dx
         m4c/3/w5ENhNfU6GYB5Q/rKMshZZtSvK5fStW5jvqkZBj987E16zfY+/mqPb9hRoRAJq
         6SDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477183; x=1796081983;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aggP6JcaAjhqbHGLe6VQCft8I9oupyLjhzJry8SU42I=;
        b=Eql4PFgShT/u3+Ah92akc/sGf1+v53vthP3kmiN6e0fvs4IuBH4CB1zQb0MRZ9DPRQ
         jR3ICudhvfnbH/yny0v/of6h5WBB0uALnNP7LjFzD8u6B2uIvV5jB38SeCdmlynP3Glg
         2rJPai/yqTodABNV/D2grv201RmShKGW3jkH7j5/9sxNpjODqu6o0G8d6RrFCoZVA+37
         rqkqFUGQEigXURCXYSRWv3juJmWggr4JXCj8FUxTu1vnKXmATFIksXvVLE2AIOAp32SJ
         4DBUzbcowGfvdKWXmFfUHTB7FUKOHyC7QExB2PMHvIYJnXq7YZBmvb9hJe6tjIt5TWem
         dT4g==
X-Forwarded-Encrypted: i=1; AL+hErE2L81gnRteK+LMkCSzaNsl2+KK2G3bicJXgf+KyjrnivoOfit4ZQT3GLlZfG10M8RsJn2sRVO1IQ==@kvack.org
X-Gm-Message-State: APuU4Z/zw+Iqt32cBU+wtGfj5KFFEimrTFXDP1+rk5MSvNDfX86DeTui
	pe42ceTJS+0itW8s4FsmfacXWXcJcq8yYHAD2Pz56BwXvHaRT5/uPPVGySRJ5jDt7goPUjVTeS8
	fD1uCMcsyvpGLEw==
X-Received: from japq5.prod.google.com ([2002:a05:6638:405:b0:620:5afe:8b1b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1a10:b0:564:48f3:dfa8 with SMTP id 5614622812f47-57a0a111c93mr14525917b6e.11.1795477182891;
 Mon, 23 Nov 2026 15:39:42 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:15 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-11-dmatlack@google.com>
Subject: [PATCH v5 10/18] mm/shmem_luo: Require permission to preserve a file
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
X-Rspamd-Queue-Id: 1F19580006
X-Stat-Signature: 9y9ix53tigwwwkkpbbwupxctjwomgym5
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795477183-568137
X-HE-Meta: U2FsdGVkX1/CmVJm8bCCD1HqqSzI0LEgrgISSfB3/rx2lbkWUu9BjQfaDT9Z6utx45K/sIgeTyCFN4xVInZ9xUS4OKSpC8P8rYMeioF0oYWMDCIdsf+Im7LdOidFv8CFlHsgi5Ttz1x1wCvfd4U2aD7GaIB6Xfwesa9nDbSSSHVB6zjTEL4yWh1n/fWMWHHW2a+VBAmCeqwBLGvE/MR+jRyLFR/GtfBDVTBcHYHXTjVQWo7bnZdhrfeF8/K6HDiyynWCNjFWNb62hTXeCQCbLvnhADRlPunqQ4u+qbneJg41Cq2VPgaOc5vwQLQhGSO41XRwIKxvdzdWFrRSKqkcuc19O1KeUAlE3NX+S2iYUrdxrgWXSws9v5cNzCSgWyq89CKC7NAyNmEd+15lox+MbBkBq/7PVid6Cg45+TYzN0j2gLBg6xjMHjl//ik1Xq+0xFLiBk/YaACtEwpuBpVMoRewggkqMf9Gqd2X1VxSXJzbi12nH+n6oxxLJ61QqLMUFsy4B5MbccxKXb9DgFjl02y2d0mspN8noKQorTrb0nsWhnMPWmuFa4pfUbxtmfkVCmi5m2h6+tqjB258lqlmNBXoB5UIob/9TnQROcYRj+g0DmVDancCV5XnQpeHShCnIMKwo27e3Oni4SJFSQbpW3NQMFSuBh1Xhoxigk1Ne/+s3msovHaCchJAmcdRciZ0bWI8d06hJIOmS5KQlUAvrHWsrHzFEDiMGkLkt5td3ki2Thc1eyeGDfp6CWpIc6TPZqNbHwyckA6T1Xe0UcA4Wqm2UJmkU65uyrvfJddvvFkXSa1s2EBkRT3j5TI2D6GnYqvTqQnife5KrGgwFAmbjc3ljoz/B9GqJTw0ZC4uQdm5NxaCGowaTQ1CfOC9CE3XAihTYQWmQvz7250V4SJ4S8kLIYC6lOq+Y9l15i3QGnrDlXkZYvOFrhTsTjNuNLs2NEwNhVL/uO/WVRMtMUI
 BrZHjonb
 7YxVhv/AX6e6WrEnO0/YcJDW/2e5yvMS7HBXH/Ve/S6clsYrdeBqVCZahFV6N6YQ2rmlBwEYT113xhHigql7bmG9Ht4nY6DH/cXB1+sLhRfa5id/rOaJ/+nd35ZggfWAuaZwSLi9EDwyiClIFG40z8JhGI2O1aMQMm4Kb2qL+P/daZi7Zl87osed0N+xGuRVS9NBFbyLK8y5IQyY4wTIWZe8UPRivtVOwuQg/NZLine5VjBik12EHgMORQ/BKUhuXNBaiIhuYDEKW/dH5QL0sk3ziGU2C+Qo6s/0to+uqpnMUWLKSpbU+l2Bz0oyjact++16tn3dEBGXnk9NIlFj9LnHP4c/ihEkSczqWKfAfcOi0wyNj0wLNA79Ll0qiIhJqRMllkZqv5/PPwXqHr34YoEUj+OedIri4424f+rz321rp9SjXFv5X39lXVrTkNM+S87MlpCIo37SPMYIOdILyiA3FDwB8xeUBweQZ1DsiMwPSPsom85MzIPLpMSmaihhpF0Z+atUKxEhPx3SWmyqm3wxYQ2hWR2HOaHZMw/mOuN9fO8H/RZY7GAtSET0CvMN1R7raU9yRlOQ9Qp8lp6nWf17noOv1/w3ybzWaRi3j+JeQBCOBL6vIv+6DeOe6kP2Z1fcsV3fgrXEnlzxev2n+ToEdFIdppNHla1BjzUf2S7WLiCuaWNK0nVaxoxyOLTETMjQYfUy9jd2vCrkAu8doZ4+LnFURYxR7G8He5UZ3AOvPd1HgjsO4lAgCJTivwOuQjJwGhNTFTHwCcE+uWAVzszVrTRrQpy5Ywzxp+ks/WrXnh5Rl/CqhcjFTRoy6X8HpHlz3XSOy2+lKLWvSw0fiDlAt57ijVSt60R3IsazXkvNrAAx5Fvp6UFel5JA0otB3eyltTue5bXXOkBqgEb5fFieWqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Require the file to be opened for reading and the caller to have
permission to write to it in order to preserve it. As an exception, let
the owner preserve a file that is immutable or on a read-only superblock
without write permission, and reject append-only files.

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
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/shmem_luo.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index 46b33a00c2a2..854a49cd0aaa 100644
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
2.56.1.809.ga0b61035b5-goog


