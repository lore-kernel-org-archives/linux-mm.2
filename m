Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A41C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F526B0099; Wed,  8 Jul 2026 12:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476DA6B009B; Wed,  8 Jul 2026 12:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A14F6B009D; Wed,  8 Jul 2026 12:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03B946B0099
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:51:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D720140209
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:51:29 +0000 (UTC)
X-FDA: 84966200298.20.BF21F32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A2D3E140005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:51:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YzopBEA0;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783529487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fs1l97gUuJOUggeSkxVmc8x+hMstX7kazastR4ARfLg=;
	b=nau3iYmN9jkZRkbLUqRUyzIPJu9tQiWUcoDPGiLrqzzAmKX246phaV5qVonpQv49PiPVZj
	oUS3Tt4JFzq7eEhWF111665JPVIjlwO/IvFg+Oy8OWirgIj5tfAdKyd8FTUcra0xkSErdl
	LFpTFBBp+idFOLCZUtuFskP+AJd71f4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YzopBEA0;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783529487;
	b=O93n2vICKsnUlUeNzZ9LL+R1sZoj0DtOhVxHHA5hCnyda1Otvn9AFbfKVWZZnmsBJwOIHP
	3bo7MUI603h4sSKXs92oY0PNYkIM23ZyG29ppTfsIYvV6wnHVudMY5R0eE46QtIPHphYKm
	/LVphQaLQ2eH37cuLIA5aVwXR2QkhyA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31C56601D9;
	Wed,  8 Jul 2026 16:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F191F00A3E;
	Wed,  8 Jul 2026 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783529486;
	bh=Fs1l97gUuJOUggeSkxVmc8x+hMstX7kazastR4ARfLg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YzopBEA0EfPFV1TOe/qTxWSUJsHLwCAw5enPv4DaKa5XMVcubkglVM+BetbdYXvbB
	 gsQOO3AbYmTTEDV/to7wM4ucgFyl4RE7HWO2szrVUmJ0RN2YhThf0SXJBHspQo/XRm
	 kdUTdPVywfVZhD+yyI4i1BXW64tONFt7rE1M6vcDkGdO+gHZ+VaQXStxeU/4FxLtvb
	 d8GNArbVfIM0j9lDPoKWaNcpQGoVOqSW1MsdYBWOZOQFMOmj9uCaaJCQTgU9zb/OOA
	 xobniEC2CA6fofNmM1ULfAGUsp61nz5yzUjHL0JF5wNssj+cA0dvBYILSuRj0jfyBS
	 31Rq+i140GnxQ==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 08 Jul 2026 18:51:18 +0200
Subject: [PATCH 3/3] binfmt_misc: annotate racy accesses to ->enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-work-binfmt_misc-locking-v1-3-a009dd5b56db@kernel.org>
References: <20260708-work-binfmt_misc-locking-v1-0-a009dd5b56db@kernel.org>
In-Reply-To: <20260708-work-binfmt_misc-locking-v1-0-a009dd5b56db@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1989; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zYlyiqjSUhiYkbJOTENTJH4trDyaeI9WWvqH84datqU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5NbB7XX3QsDv+n/zL0H1F/56aa7JUNs454Fh73kpqa
 cyuU3nLO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYSfJfhf6z8s0if/U1bv7tl
 RWz9XbBtxZwib/NyDb3YWbf4zFb9yWH4p+a2oPKZ4fuK/U7PJj763iKrtb9hkcfTjTNUGNPXW74
 W5QMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2D3E140005
X-Stat-Signature: e5ujjk4s75otrbhr9re4uj47whxzd5ub
X-HE-Tag: 1783529487-179971
X-HE-Meta: U2FsdGVkX18wJGxqrzJOvR17JOL+gViMRkIsw4Hj85MGq7xF20N42j0Ga/qdxAoEKNlSgEDqoVWVEj0fHRPg4DLYlAAIF9BizmoNnpv1QLBKLdBzzAOUET8lvTMAUJfojRIJvKU1OHj+H2zuP2Twiug8+DCX/B9skOTi0EXDbfbsva2eymIuEzSmklPuFua7G9Q1nwU15zhnoDMGreYwn1BtOBToRcLAXbvXtBWEnhv1jHA1uyRhr008q3Bw8I+AktE8Zimk/+Yj56+28LTKXvg2papOntUaf+rC9qOq2RFPruQaYJo3rEb2Mm9qspj9ipEab9bbcYbghI+dxJhr4ETVoPczf5Npnapl/jPilKP9GoVpwc92GmtJzA07PvFgdborEiuKs+wdasw+NUfd4gKE5bO7QJEADrtzrkc5E804Cvz1Zf8xoGD8SvGCSMAjnT1tcPbFt8XuJ7XirxT5K08qrkmOIrY2ctvYwrvAvWb0CCKWU+mGB0ZJzmoVZ+aVEQpD7/p3fCAzW8SLnuSYX8IIOCNqXNb2cydj+5z+OUeJVB/V+f67nZko1DDuzpbrVXxzCDhCxiEgXVLKBY/N/fN/b6Etags+YPJTQ214zYpGJP3nsmD70hRRrM6xAMgLKtjvr937TbspnlS0Bmoco9jKT5R4P//rXuWErvEm2/XiLRViVm6tVz++3OkiW3GIuVgllRLIrMTp5nq0pHlmRsuvYwtxzJrCYWlptHiTK26Kc2/WyT8IICvO2XI5wqSDqcKhKrDmniSxWIOoy/8m5aFrRICtWR9tTnFHky6dJFWzokO2ymoe6F/5jPQ5xghZympvQS2i6JyxPD8fVXGtSMkSDdOvYqMVfxkr//OQFaKwelDvxVi6iihqG2m17/RPVPS7Hk0NdpEBZxA8XdfXyLJESBt5NYvoPjCRGgG+wOCkw67JorY6B6QJ3AdhQsoOMxCLfkm5nCe8JAtlcO4
 YcEXFpuS
 KieO3nNCbRAVvZYnuMVXEhmcw+9coCwfvvNL5a1qJz4gNCgWNFICqJrM7Q3WKBUBDYRatY01HfRR/Qxyrm0USEGTUOmVRj5cHYZsy44bxNLOI2h7oGkFP0YnThJvQOZorEOLSkWovDUFwEnUr9hHrct702UQi2k86YrQmvd4h4DjY5ZNJsnjsP7YGK8sP7ava5nUvFJJC7szn9aJEevc0EvrGUHirQT0Fqiw3v3y/PWoMWHr6ucsX2z/TT8iCZR6WBNV6EB69BSbE4oVz9K0slCRLh9/e7ufmYvr5tgCG7TC1g2APXjaMR5mXoQaHQlYLcbdb2n408WalrNw36t9Z/KauJ3g9dohaTIcBNnYi7KqvSaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

->enabled has always been read and written locklessly: every exec
reads it in load_misc_binary() while bm_status_write() or a concurrent
remount via bm_fill_super() may flip it. That is fine as it is an
independent boolean toggle but the accesses should be marked
accordingly for KCSAN. Annotate them with READ_ONCE()/WRITE_ONCE().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 9d1039dcd3f7..0f04709a0a39 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -215,7 +215,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	struct binfmt_misc *misc;
 
 	misc = load_binfmt_misc();
-	if (!misc->enabled)
+	if (!READ_ONCE(misc->enabled))
 		return retval;
 
 	fmt = get_binfmt_handler(misc, bprm);
@@ -863,7 +863,7 @@ bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	char *s;
 
 	misc = i_binfmt_misc(file_inode(file));
-	s = misc->enabled ? "enabled\n" : "disabled\n";
+	s = READ_ONCE(misc->enabled) ? "enabled\n" : "disabled\n";
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
 
@@ -880,11 +880,11 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 	switch (res) {
 	case 1:
 		/* Disable all handlers. */
-		misc->enabled = false;
+		WRITE_ONCE(misc->enabled, false);
 		break;
 	case 2:
 		/* Enable all handlers. */
-		misc->enabled = true;
+		WRITE_ONCE(misc->enabled, true);
 		break;
 	case 3:
 		/* Delete all handlers. */
@@ -995,7 +995,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * someone mounts binfmt_misc for the first time or again we simply
 	 * reset ->enabled to true.
 	 */
-	misc->enabled = true;
+	WRITE_ONCE(misc->enabled, true);
 
 	err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
 	if (!err)

-- 
2.53.0


