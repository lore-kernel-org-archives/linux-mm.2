Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C82BC44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84B396B009E; Tue,  7 Jul 2026 15:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822366B009F; Tue,  7 Jul 2026 15:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA6E6B00A0; Tue,  7 Jul 2026 15:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 442286B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:37:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B95251C3B66
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:13 +0000 (UTC)
X-FDA: 84962989146.13.EAC775F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D88D8180003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/R1GcGe";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgA1geaqq5El280u44lqj9rGD3DnVSHSrxwzp95cFOU=;
	b=RbgiyrnYlQ0j7Zw1VyAD+L8yaPCz6v4nV7sDcZ3h8hk22drao7LIqjkrTCZcAnO66QWapo
	Uqi6rh5Tz6KLD0kF5F4Xe+MX+BbtJoP26s9wdJimm5hJguGCgIVFopcQkWXd+W9pejy/mm
	wJ18hzmkZVNXc6NfFrVUiAdOJ4U2RcM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/R1GcGe";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453031;
	b=TM2qMCWf9DmiZIhsNiL9YtdQo5gRggd1hsOIr6M2Ztdf/9eVkMzQAlg2MCNp1DDmjPoSse
	oUGYuFgiinlmJgbE2BSchu6QzJSgPt2AC9zSg5X0Kb9pghmIv5WGgdRgW+Lir1Ol9VZ7D/
	jS5BZoVcIUaDCI76S1kCw3TfAP5IdTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A08BF43FB0;
	Tue,  7 Jul 2026 19:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA281F00A3A;
	Tue,  7 Jul 2026 19:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783453030;
	bh=BgA1geaqq5El280u44lqj9rGD3DnVSHSrxwzp95cFOU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=J/R1GcGeuq4+Jk08FVaiJaApToeqiDQEV6pLbvoDFOseUk6N8hg5rfagsSB2xavRb
	 TVUlUjm0QFpyNzb3JcaORHuja5/n5PIwFLOvm042VBH49wuXusAgVypXZ7MQrXrT4D
	 sm3QbLC6ygKlzpF5CNCOFxpJifTSCsrHeCPx7T8hpQsSLOEPzYX1h1mHkTpTGvFZ9d
	 G6A5jl/JzAtxNxGv5eBe1sgZG+b5OeTdYwfdzYu23OD2fqtz2ChB3VFrBd+TGpjUhu
	 /yG2u6YTsOIh7/Cad8fnYUbXiuB0oOhO+OS15uSAm4l455LE7eq83CcZ2+VLHPalEp
	 vOcan58Mh+CHg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 07 Jul 2026 21:36:45 +0200
Subject: [PATCH RFC POC 1/4] exec: stash a bpf-selected interpreter in
 struct linux_binprm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-work-bpf-binfmt_misc-v1-1-74b995c84ec1@kernel.org>
References: <20260707-work-bpf-binfmt_misc-v1-0-74b995c84ec1@kernel.org>
In-Reply-To: <20260707-work-bpf-binfmt_misc-v1-0-74b995c84ec1@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 jannh@google.com, linux-mm@kvack.org, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1700; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ua7v+d3uKRKy32nv1LaWcJpAPv7PpPmfHINLqR8HXQk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5hibssbE2kvx9I+R4s8QiS7bb78Q8e87e+jMtcCLP0
 xVseg79HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZuYeRYa5OkkfiTNde62PX
 vLdOuRhjdnrmvFAfjsYZk6szXIyiUhgZzs7QYt2os2nZ5dyooqriD46/713laRDaXLqQN2Biz8Q
 qHgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: hib5gj8m8b4j6am3cf6uhgfusntef5zg
X-Rspamd-Queue-Id: D88D8180003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783453031-896730
X-HE-Meta: U2FsdGVkX1+dgCYKY4UzvacAbQR0O0PUqRh4poLfrzA+VNmQRQHrn36Z/+/EBh+JIzhw8PKzZp4zsd9efu78AAsSJ5o50BPeIEqW1+0GGDKTxXeMBKXXbCEMpkWIz+z4FtbKWdpkw9UZVuaSwpQm2iHp2Wb1uSs/JFqZSfulXA3oZBYJaaHmrBzIDlUm9RpS+GdXFtSrfUOzCMJ7e2wWsVKdlUEdpv88RwosctGeHI2zoEVjTeG62xVbRmsXh5Ldf252xGBSLm9lVbeAwlrp3+mXe05TU/Nav1mYpN+od1oAxj9s3Uj8drSxJPuzr8QCd6oZj8yA2IajeP2HTLv10n4C7zfCdoDsxCp23T/O2dD9cLvQSuzxX1KgzIJBgNqJKW2YYe9d6VQLiGdoCsVLCvJiL5eB8UjjyRnPMCKSQLZ3VM074h+5iSsTlCWvmF71yx0aKC+4xSppYTGPnuMjdNx4ZIB60pdwPt8seyZar+bzWrOjUP6L9jaUiIQ34pAfN9UKp8uREXF9DQB5xCBp48VRMg16IKzFfOh/FbXWK0YEGFydvrxB8z7/q3Brpd31+Ga2tkiQNuHIFkznawt/IL+cpQyokExkqEqcDYfNxiC1YBNgX3r3RxmNN8uV1Qmpk0LiyRaaF+tPFABA2TgAu1KIqrEp0EX9SfomrAsFmlRtMXIKaq8EwzEFVlOLxdzNm7PoaxfHF94oiSzwSH4CVNsahppV2Lkkqf2OCITULB5p4+4nvFueiW/JmenfbyEaB8oNPu7FLI5YX+inShnSUILfw8h/sJwaGN6Bzzo7SiXyq2Y6HXlFb9p5FskW+wjTeqHUzNXDTqtNswnkOvEaHuUz68ewsJ3dKyLLcXDWY7Q7evjkrFVmoZo17ViIxgg5EPnQOYpL2NJ97NJmpo/MQLZOFTaUhkugA1plFwRO2VhFexsWoTNC4GUOqwcLkW1rWgUml4JNdiqIu/RUDQa
 Ox9IMI17
 ACM15c7UKJaYZVJryi4qMBIb0LpUX0loNhZXrs+HyS/Tad2lsS7EE/eDADIBOg444fuSXin49FJEW3/bPZme1th9E9+fDgVcB+3TjvwSiqvtLnalXnvSRJw3mTGP+clrPhdOHNvdO8y/T5WRv9Darr70ZC2zW8u8z9AduscdEFaC/LaBwo/H6PjObs9bYQ8ZmiMRvsBfdYreGTMdlgwviE8gJeixllIMbcFaVcaNT3ku+GFP9avxafgUyGgzUGPU+oUJ0pOJr6DNqyTT+hRhKw2VgaN/X1F0HUjksraz2HuhH7fU9Nt08PLCGMmmE+ASnbgGjMNIzElqxR6z6/v0XxVQNMhBsnaHdSBc+lIhiEymmtwIJbDUJGwP4og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming bpf-backed binfmt_misc handlers select the interpreter for
a binary programmatically at exec time. The selection runs before
load_misc_binary() has copied the binary path from bprm->interp into
the argument vector, so the selecting program cannot go through
bprm_change_interp() directly without clobbering argv[1].

Stage the selected path in the bprm instead. The bprm is exclusively
owned by the task doing the exec so no synchronization is needed. The
consumer frees and clears the field once the exec attempt that set it
is finished; free_bprm() covers all error paths.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c               | 1 +
 include/linux/binfmts.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index b92fe7db176c..7c9e28f549a4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1418,6 +1418,7 @@ static void free_bprm(struct linux_binprm *bprm)
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename)
 		kfree(bprm->interp);
+	kfree(bprm->bpf_interp);
 	kfree(bprm->fdpath);
 	kfree(bprm);
 }
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 2c77e383e737..0070d207d54f 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -65,6 +65,7 @@ struct linux_binprm {
 				   of the time same as filename, but could be
 				   different for binfmt_{misc,script} */
 	const char *fdpath;	/* generated filename for execveat */
+	const char *bpf_interp;	/* interpreter selected by a bpf handler */
 	unsigned interp_flags;
 	int execfd;		/* File descriptor of the executable */
 	unsigned long exec;

-- 
2.53.0


