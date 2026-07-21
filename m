Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A046CC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 11:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FFB36B008C; Tue, 21 Jul 2026 07:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7546B0092; Tue, 21 Jul 2026 07:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE646B0093; Tue, 21 Jul 2026 07:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 385086B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:21:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9322120422
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:21:05 +0000 (UTC)
X-FDA: 85012542090.23.DD0D8A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1B091180007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:21:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpoJ0Xrv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784632864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2QCIGWwPwoyvoMjnJWSMriHvqcGHG1Gj+h1JEnla2yE=;
	b=Zxy41xpRSSkFWNDQoMUbCp+QBEwhiUb6MaEj3KIqSnDPSg6f24+6JEWjUUvjIeksk4bdSL
	mzxrEvPjzqlmbExAVAfbb4rO3/rVrH6Dm8Te/JhC/hSyfRIB1bWS3tdNVBkg7ARPIE0FKd
	Bcd2c6Mfdn5CrscxS4g9YfooqKCN50U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpoJ0Xrv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784632864;
	b=KKWTV/bXEPvUkF9ujOZanQl3NQxS9YQk9/grMJXRyPa9o32poIy8z1gK6hMCl/w1OGjUif
	W2qyzScLsacXRd5BsOhXMdIt80Q9ZC+CE84ObRPZ2caRBt+PpKcbple1KfL5v7uXIoYERY
	ToDNLwKNVI7V8pxsosUHjRuJJBfat1s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2127401B3;
	Tue, 21 Jul 2026 11:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91BB1F000E9;
	Tue, 21 Jul 2026 11:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784632862;
	bh=2QCIGWwPwoyvoMjnJWSMriHvqcGHG1Gj+h1JEnla2yE=;
	h=From:To:Cc:Subject:Date;
	b=cpoJ0XrvNyOBs0sYpHabs3pSxWkh5ZyP4hOPNJTumhP9A3+5yNiE8L5lAXdhOZVcF
	 SCsnAKkfIHJBgsoc6AiUrF3k9QCBUCrPQEOrCsKS0IApnhACYBCUMSg2GnvhD4/ja1
	 wJ7erJP8p/NUXN1V54aMicRA8wl2JkkxFUR75dKHFFl3KVwSlQn0EE6xQC80oW3h6w
	 mdDTkNFgTVKlJFKyvXE4t52HP5ou3QJUsfIrVBcXFWHp4eXBVEQ2jP9vUBUs5zivo2
	 Ff8OjW4I1FDkVxUR5me4VwLLKTnEfUVBoID52nJ2oThtCsuHBgrSn91uxMnOCV41QQ
	 xS9yHg/KgQNPw==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Farid Zakaria <farid.m.zakaria@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	jannh@google.com,
	mail@johnericson.me,
	stable@vger.kernel.org
Subject: [PATCH] binfmt_elf_fdpic: only honour the first PT_INTERP
Date: Tue, 21 Jul 2026 13:20:45 +0200
Message-ID: <20260721-gezittert-medium-kreide-b41fc1f0277e@brauner>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1540; i=brauner@kernel.org; h=from:subject:message-id; bh=+cJkpeap/KFYrggTqEpe4nk3HWVb6K6EfACXBz+YXGw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFh4k154eeNb993lBn4lqZiOWct+XOaF9teCzbb8+Q3 +QZIL27o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJ2XYwMB+5PtfosrlMQsYA3 waej1EphxQGt34rS/7ZNqxNxWvy0kOGvtHDrjQ4HBtZjykoGfkcdLXOvX39iep+R6dh2Ka31Wxs 4AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B091180007
X-Rspam-User: 
X-Stat-Signature: m6qamk977y9qz8azqyhxrtdr6n5uqumd
X-HE-Tag: 1784632863-533563
X-HE-Meta: U2FsdGVkX19dKEGBs2D5Mo5b6ZO2C6fVwnqh9bi7Gbkzn2zvjtJzpb2gcbNY0TfWab5u5WsErBNTn1KLYaG+dkP4ZvwMnPN82lelEJND378gYTe/ZAymt/5STXVEX67zXlDllDJ3YXymJSwjN0O2QTj5LEjL8or7m5wzr7gUyVpO6FGGoMUaUw3TDohB012u0VQGdIiFrLdHWaqhezHWZxsMyosfvtAPr1cPaYrAeOYifi7ICr1BHLQFoZbXncXFjF6MS5IwpRGjJuofNFkaLpl1P+0M567EQk+DHk3v6Rkqez+XuLfmPiDEWk8zc68hQ9qwzrmI4AKdNJrDVLYqvBnIV3L/c9d1MaJ++P+8gxlpW2r3bYdLWvZOJ5fXW4mnIiSnqISvzJyrOKrvjNFg1ozIOUZ10h3u829yeJuHHQCSwO8sbq7ReqgBsJQvMdQLjuY/Tt5yKU/GN4JZM9jagj624GVAwNxpb23ArG9GZZbe8hAezymbgDOZodRhIpOn274OYTdLKcK4rVsu2acRabWY3pxrNiBX3MTcZxG4x5/o3YtbPNSWdfrWxpFHxa1nf790HlZlN7d0Cfe7We53uAc+KLPAcAkFjEMEqKwgBfPTLltr+ulUDmGCmIfPsEXznE6hTY3LTgeqYEySvAhq3Tczvgrg47k6Jbk2xFoU0gY2qdKGHTfPh8Ki67SPF3nakXTLJM/2xBQmm7uReB0VAF/i9e285kvHB7o4qYN7vLSDGAJwRNAlgn1vj56mg4ehBYJHn/3f952vPLkT1F07WmvanrcgSi4j7ZvO2FtkFNl1zqin+k3uy6d+8R3vvrtNd0dCDY6owF9mJwWaHNlRPJEGz7GWShMe+rkCZ9vq9X2hBkxtae62DCb1Y6ioLr2hs9wJ/fI5BAcE3UV1Kv7/1fuXuqRdJHDQFKF6olNGrHQn8uTEEEX/7fW/YVklUZaLlzH9Lkz59bSMY+d5rB8
 OEz5rK9s
 NdQev2rn8280us8mhOZpR0bvATigJTnZiJWGAyuxHEXJ1UyxgJDFgtrgHcRU+307sd3eZGEZkI4L2WWlai02GLe624gt+2Y2566353fadrrOQbhFLwUX0ClZQgFxWWcpiw1H6hObxfamM0fGVi83qX53NsGACfjjboB3g6j1ErvIcoAlCCEMNgkNeFMiwMHHecZQHMyCf12pHrd+lfUTmcR+I7rP38yG51qgcRjqBBE0d+Sn+Iy/xNB4dwZaOBOL2bKqvIKxH7kTiitb/kzoQnuhIhN/xhuznKMYdSRuOsj9klDktN+93TCo7hOLvf8pm9WjPeiaqsL3Z3aWCBL7an88NGVCWnUiLFuji4poXmg/kT27RlqnKIu4LH9tzZO4+B0PWX1mUSdN41nDQjVBJhq9Lkt/Uc2jIjPNZjsjLIQmcac4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The program header scan handles PT_INTERP from a switch nested in the
scan loop, so its break leaves the switch and not the loop. A binary
carrying more than one PT_INTERP runs the case again and overwrites both
interpreter_name and interpreter. The previous name allocation leaks and
so does the previous interpreter reference, along with the write denial
open_exec() took on it. The denial is never released, so the file stays
unwritable for as long as the system runs.

An unprivileged caller reaches this with a crafted binary and repeats it
at will. binfmt_elf stops at the first PT_INTERP. Do the same here.

The flaw dates back to the driver's introduction in the pre-git history
tree introduced in v2.6.11 by 91808d6ebe39 ("[PATCH] FRV: Add FDPIC ELF
binary format driver").

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_elf_fdpic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 7e3108489c83..fe0b5c5ed2bc 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -231,6 +231,10 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	for (i = 0; i < exec_params.hdr.e_phnum; i++, phdr++) {
 		switch (phdr->p_type) {
 		case PT_INTERP:
+			/* elf ABI allows only one interpreter */
+			if (interpreter_name)
+				continue;
+
 			retval = -ENOMEM;
 			if (phdr->p_filesz > PATH_MAX)
 				goto error;
-- 
2.53.0


