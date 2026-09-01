Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A9BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79FEF6B0099; Tue,  1 Sep 2026 14:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733A66B009B; Tue,  1 Sep 2026 14:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8E76B009D; Tue,  1 Sep 2026 14:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3975A6B0099
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A58F24050B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:29 +0000 (UTC)
X-FDA: 85165975818.13.8175BF4
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id D684040008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o3lOFg0y;
	spf=pass (imf11.hostedemail.com: domain of 3XhSXaggKCD8enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3XhSXaggKCD8enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788286047;
	b=rhHFwGLITBxJ+VTyKAefmpGzQG9j5g+W+2tAR65FBGSnM0H5+5Y5B/lFJWwsgiN/w2K1UH
	AO2oo77uzBLixLgIaUN3vX503HhspmHM9bhUaTni0Aw3oO7OXpMo9/OX5A7fvyrniDdM0R
	NX7KdCQZBWqm2vtpW2MTxuDLcZeZkjg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o3lOFg0y;
	spf=pass (imf11.hostedemail.com: domain of 3XhSXaggKCD8enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3XhSXaggKCD8enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P31f4AxefLaMEsH/zGccMYrThdu9slSJRJY7f7YnBMU=;
	b=K9UqapmkbJ1z57r99v3wNiMi6Lf+YiG4CkFh1m3KDbY6ZZpuyBPMZaQu6wDX6jzqx0zfSr
	IowiEBDyk4V0cIC8tEf8ZdLa6zS08Jt9G+tZ8bodbE220KmxpaeKw032ukJ6uWBib1yJz4
	VI2Q0G2HKFP5oih3u3exCslTQRoEvyk=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbb92868263so135755a12.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788286047; x=1788890847; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P31f4AxefLaMEsH/zGccMYrThdu9slSJRJY7f7YnBMU=;
        b=o3lOFg0yJv9WSQymvluz0nAMfIpmwFKBIWFRSZBHwNHlm5V00K42gqtYyUhmZQ7cC8
         QLtz9SVxQ1wC0X1xMCXGr7tQBjFkm2xa3Ohcb2j5TzX1mhFlBC2ugs0d1DWoqKV+zTNx
         iPEojpCYD7cHOTUvkrFLArtJqqUGN6ZqhQzOAm4WdfZakAmNbRFPS58rDTkfSwsaQ0Zl
         Qdb9Mwy5kk1iwEoOTi6b7rq/MRUWbraJtMqnf6LxYGPpcLlT6lEWBsjuSOogJ1fPdqNC
         drz/ohNrMa60U+yjMIDzqY6hH4a4AsY18ImCh8PdgIqr0IgI/7q82N86S+wL9v3rvZFy
         x56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286047; x=1788890847;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P31f4AxefLaMEsH/zGccMYrThdu9slSJRJY7f7YnBMU=;
        b=EwgBz/o/NPqxhZKaw/6KRIx3hAyvanQxEl8mt51DxEgj38VF4pSDQKODSHhBCBUhpd
         KVtaHu+MWwwpQd7XqQuvebDY/qn8wLDPwp0iPskCVI0atjrgVqgoz+/PqDtWA+jE1YhL
         H99aaPpy6hkD/OP2WwrtI75zRneN0mv0sdI3N3yX7rBZh8wKDzZc2SZc66R6npSPOOcc
         cyN5uMymzZaazym8o/REm3ht9Rgfu4fgBgLLYxAYLBb4UQKgYy+MRTJjrkeVUHDogx0h
         DMEXhened5X3o1MNF9nVgcqKPW5oLNAGyxgbT5Ieqy5NgC7D/hZmLlJFurCLXGeXRqhv
         1S3A==
X-Forwarded-Encrypted: i=1; AHgh+RpX6P1wfV4tTe+nujXQOEhaiqMJPqsguaCXM0ew/YBfgqS9X+QotkPSfo3mNaO2FStIA2j6ByY1ng==@kvack.org
X-Gm-Message-State: AFuF++lSlfulzY6aU2MsFkk29JqVfVGNNSQ7k+HuPSdcSxfUqRNY23sQ
	Qo2SMi6ueRCXuGItvJGVrTzOtt1eJ59dX3hfdVoy2qVYxEwXU6vtKYMTTv0Nml6GPj2A5x3CesT
	kJtr1TYCugqu33w==
X-Received: from pgea25.prod.google.com ([2002:a05:6a02:5399:b0:c88:b675:3609])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:31c7:b0:3d3:adbf:777e with SMTP id adf61e73a8af0-3d7afe35cddmr15820173637.19.1788286046490;
 Tue, 01 Sep 2026 11:07:26 -0700 (PDT)
Date: Tue,  1 Sep 2026 18:07:11 +0000
In-Reply-To: <20260901180713.4185641-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260901180713.4185641-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260901180713.4185641-4-dmatlack@google.com>
Subject: [RFC PATCH 3/5] mm/memfd_luo: Implement retrieve_into callback for
 shmem folios
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D684040008
X-Stat-Signature: wspfuf4dh4e1dbg8fhs1spwfwraurq7c
X-Rspam-User: 
X-HE-Tag: 1788286047-641308
X-HE-Meta: U2FsdGVkX1+NoRHTfXjYmkEyNcnTT4RoX5SQRLpFMIiN1qFH+MwmaHSoEjp+DgXgskl8K9ne9Eyufd+ygvnWGoWY1ZsN/GNl8hfNUVrC8x/Qx1qOCsp2xm4ZjuEn2xZjHcTTTkuBe1e2GKEkFhiC42rfBBGydq+vdHzQiLIFSt7Dw3TN95QDDeQIh/QONI9C+eW1hd+jEFXJypvjrrj0kRYwlN9GPmDw0FF+IcEyxdd++h7vV36BE+/hHp2YY3TW3tWbKRB9Axd3h3LradCl358m4DIw13/6nfAb3La43ly/yOdigmqOQoZT/h6t5CVZtnH2O1Cnt5NjwT1qVd7BoA+xhHWk/TwLcM584z+uKEK1jYlgBOWq7RvX3/VgAtSwO8oVpDL24fXcZsiohUrzKo9FKtVBteAMKk9P/o8mbkqvDmfxm69a0unX2Adj7dsWMYTCzr0pfmyBr9FztwDDSAwG1VdlhDLhs4qI9cGDncJHgtq8n5NytK89iNFVz9J3iFVCg204YGlT5+LMauk+0FUYrO9SiG3E94MRxCtuCzdqMVIUkpVnBIuIHyXaCCJyKjp0NnHNpHHqHJNXn1CKJ0grb7tVkVJU+tnnbiUJV7iAxxo2isRzqwT1BgMh+5HAelVFcVnWLEp7AHnBpLpj8cKzBXN0cMsEQzpVo46iY3upBzsHRuCyxW6BhWo27KvCcm1hChwjVN2hPKD7hXY/HjY+Rbp/G94olx96UZ9uXk3UerfriazCK+laycMuTa2KqP96m90fJ5QF9qyow3eIJ7ORhsztdpBLlWmG+vZWeKEN94Wt+qVnnsC2DrD05uwwUAiKKXztuZ1A9K6mOEysWFLOl6r//BbjGYb8ScvWrU5n+CAMkS11YvPtA6RxkXPFaQVc6BAdfFYPx4m7KqHEi+bIix8BneSXniZmwbnOZk+TJ0GVL3y1dBxxHLs/10N9JmdeKaMPW2uVKSkptiw
 NHPcmxR4
 IcOlExxUiKYSEvdHb0ce21sXE5sqdwVziDnrO3k8z8rIOyD2BXfsUcX2ieYy697olb2Wi8ZJAJs5N6dECWBeSxcBh1iLsH4SaadVNBkN33uq9a7gYThCTucQgT9l9UnCvTZqNSimXtGA8lLrEf4S9CJ+kzypFyWl4/2WLU0O61CvFa4wJ543sWiuqDNAUCCLTehYHWWSDRl0h5x2Z2F7A5VDTRMS1YQDU9FB4vsY3kKhdRaMQLFFEn7ALoBzj5HeQogxclkncpEnOo6vogiDJxye2/6C4zH1ttxHSZVhej0u+mDq62TZQbBQv7lxIql27YO5caCtOmLJaDU+0X4SK4i6wlKA27XEW5dSc+HhcStQMEu5TYEvVbSmJZDnpN7QF3O4dZEX5psdl4C3AULSHl1QZ+gTsEXGzMctsO4VJu9oth7BWAl0pa6n+adWu9nHITM24XRFc193Hka5Dz+VIqT7/UhP4roddSOmPqhGR225aKmM79do3LTBNJU8B0hu241KoPjChJtNuhaFWdaR0DqUCMQswAwJR+8Azl/uQT2s7qOZcd6FLFY6InYWSTDtVz97sTqU7vzpXJTmTNvCI/bFmuBc9MYjEPVSi2nRADCWtzOmsDLia1Rpcvxfq9vCRgWTluPLkJS4DJC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the .retrieve_into() file handler API for memfd/shmem files.
This implementation uses the standalone logic extracted previously to
securely drop physical memory into an empty target inode.

Userspace topology delegation requires injecting folios into existing
file descriptors. This implementation verifies the target descriptor is
a shmem file and strictly guarantees it is empty before locking the
inode and bridging the KHO folios into its address space.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 mm/memfd_luo.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..dcda5bf98646 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -590,10 +590,58 @@ static unsigned long memfd_luo_get_id(struct file *file)
 	return (unsigned long)file_inode(file);
 }
 
+static int memfd_luo_retrieve_into(struct liveupdate_file_op_args *args, struct file *target_file)
+{
+	struct inode *inode = file_inode(target_file);
+	struct memfd_luo_folio_ser *folios_ser;
+	struct memfd_luo_ser *ser;
+	int err;
+
+	/* Security/Safety checks: Ensure it's a shmem file and is completely empty */
+	if (!shmem_mapping(target_file->f_mapping))
+		return -EINVAL;
+
+	inode_lock(inode);
+	if (i_size_read(inode) != 0) {
+		inode_unlock(inode);
+		return -EBUSY;
+	}
+
+	ser = phys_to_virt(args->serialized_data);
+	if (!ser) {
+		inode_unlock(inode);
+		return -EINVAL;
+	}
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (!folios_ser) {
+			inode_unlock(inode);
+			return -EINVAL;
+		}
+
+		/* Inject the physical pages from KHO using the extracted helper */
+		err = memfd_luo_retrieve_folios(target_file, folios_ser, ser->nr_folios);
+		kho_restore_free(folios_ser);
+		if (err) {
+			inode_unlock(inode);
+			return err;
+		}
+	}
+
+	/* Fast-forward the kernel inode size to match the injected data */
+	vfs_setpos(target_file, ser->pos, MAX_LFS_FILESIZE);
+	i_size_write(inode, ser->size);
+
+	inode_unlock(inode);
+	return 0;
+}
+
 static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.freeze = memfd_luo_freeze,
 	.finish = memfd_luo_finish,
 	.retrieve = memfd_luo_retrieve,
+	.retrieve_into = memfd_luo_retrieve_into,
 	.preserve = memfd_luo_preserve,
 	.unpreserve = memfd_luo_unpreserve,
 	.can_preserve = memfd_luo_can_preserve,
-- 
2.55.0.966.g6673acef38-goog


