Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39B2CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC876B0096; Mon, 25 May 2026 02:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D5B6B0098; Mon, 25 May 2026 02:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A506B0099; Mon, 25 May 2026 02:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3934C6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:28:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D467F1A0184
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:27 +0000 (UTC)
X-FDA: 84804963054.10.A375DB5
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49461180003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TJY4PHJq;
	spf=pass (imf16.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779690506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hy1vnl/axXCuEJYWaxw1gEfqOcge1HsYtjEucBp1X78=;
	b=25lTR20LK0CGD+DhyJhFZHK04cboKUzLxMKjaGGLMtNbHHtbAGAm2tjMh5XnSd7ee+Ed5g
	/63YaSvWxI7vfMYysrc14Y5G5SY2OfupwmedPXOKjaCyO0XU4VuRkqB7Q7IIAlHAnARRbE
	IgDPpTNaK1tVd1EDXUlFukiQrkAXu5Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TJY4PHJq;
	spf=pass (imf16.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779690506; a=rsa-sha256;
	cv=none;
	b=KTDcJwsChUozhnqcXXtl+Y9ui5EOEKMPRBHorVYKKRoZFXDVW0n0IxfVCl5twbKdMncKFo
	DBwfWIqVhBRl4pFHGIqAs974HQ5dKFjWuv8h+5uSgtlsZohiqoo/2+ObeFpRa8tw5vF0r8
	RrWZaFQ8swknImKAh9ADxdiwkryXODk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779690504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hy1vnl/axXCuEJYWaxw1gEfqOcge1HsYtjEucBp1X78=;
	b=TJY4PHJqDlB3R77odWscnhSPPbwm9H68wWAZvxNyZIAtIklolvIxjfMXKeb+NlAfpqT5dM
	iEXiI1ZDh46GVM25OWf66JkFgGsp7DlsCDcu2btbWbtLcDL2T03HdRgZPj6yOsrPGbZkUp
	sKLcM+2MPj8jAP+t2bhDr7srZO32iPs=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: kernel@xen0n.name,
	graf@amazon.com,
	shuah@kernel.org,
	loongarch@lists.linux.dev,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 2/7] LoongArch: kho: strip stale kho_handover= from reused cmdline
Date: Mon, 25 May 2026 14:28:05 +0800
Message-Id: <20260525062810.103367-3-dongtai.guo@linux.dev>
In-Reply-To: <20260525062810.103367-1-dongtai.guo@linux.dev>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qxfip16wgnwk75gyz6apg1mijf8hcxoc
X-Rspamd-Queue-Id: 49461180003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779690506-634236
X-HE-Meta: U2FsdGVkX1/pqvESO3rsRU29EgbYla/pnO1S50gZ9kM3Xei4y2jnqi8CXKifkQM0Dmck8oADEVqR+h7THGR9TI1LUlhXCUPlcPDLpvmxu4vYRxJ9G53eNrHeUmANqPMfGFr8Te6h8z8XHNFip8uCgqOMC3P429tpt7JuJ47/L/wVrJ3ctqDKBvmz/7Z7mk16il3D+GSRtmLDKHoi+9k6bVzuNNpFynAKB+nl82L1EK8VmIn2dFNTmdrJp3+DtGNuBCMt9N7t64VJdwfSeVN7RZuTsbGll2e7aNYl+5ZRfcYCcIiK2faXbCtZzJaTnCNbuL45OIEecc7l/jxWFZ6Kx3rfaxmLgh+5hzLw+OACbSlSND3Wni32wg15ZGyLFvDDvpGRj6UBR96uUHQ2dd0bkPsHvSpz3RBHsbgWjn2V1fvc0TxUKne8wUKDLvw1HetMkWQaZlxpCQZwEqMIA73MXrjt5uPZlaKamjkVyTv1pfPKmfP6hLC0qHNiALxpltPzKpsHhK+vnmJIpzFVhFPR0DbfSh39RXkDpEN0Gu43rWb1U4hKszOfunUxSUYj+ONFV8FCbAcrC2CzXRF+bRKuz4zADn9oY+Ft6Bej+jy584gmDZf4XbdiDB8uw7qK+eY+RGu09Ooc4mw+1aVTDYwwNtHWuhJXAL31V7SalGsjIjyJn5r8h+iZD5I5mSJGHMMfBtSI8PkQ0a48DkIVKRJ6hRRSYtBvykiu6VzZb5NhtkLdVOhM4J/v+ZWPcgseLInzQqPn8HmsznJzjNCj+keLm9UHG6AQSCN9urlrorJsUy8NXOfnQafNKOXZlhKi/ibuSuRbj10sFI5QSABsBrm6U0a7CqhmCjipUgDVdOBys+rer8fNaQk75rXl5SepBNzO8b06GZLnVyVbXRg1oPPbN1/CFS6iNJUrdpAfZapgvtVlxMoWhUWY+wqWIVaUFUPqNJvC8RIlbujnusdGYi/
 f+QqvzEG
 H3oZfnA9yVime47hgKC3oPDbABkoLkL6+7ayuNtHMZhudz5/9H+VhICaTNZLdFbwwq/jlW4AFJy023oJSwM5MXv/gMN+UUVu/J8YbgEY5MLnH8j0YvPBZ+aps3m6HcjFkDgh+1z5dLdJxDMVlYcZe6DIU4IQIf0LJS3uxhI8ePg2axN5sIYkLNfXWHykUZuGuSCCSlfAiv6qIOCGyuh+lWu9cIOnU4UZ8REMNFaGC+wDrHLpE5Hf8qVWfGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

When kexec is invoked with --reuse-cmdline after a liveupdate boot, the
running kernel's command line already contains a kho_handover= parameter
from the previous kexec load.  load_other_segments() prepends a fresh
kho_handover= for the new handover FDT but then appends the original
cmdline verbatim, resulting in two kho_handover= entries:

  kho_handover=0x4000@<new_fdt>,... kho_handover=0x4000@<stale_fdt>,...

early_param() calls early_parse_kho() for each occurrence in order, so
kho_populate() is invoked twice and the second call overwrites the first
with the stale FDT address.  The stale address no longer holds a valid
KHO FDT, causing __kho_radix_walk_tree() to dereference a garbage
pointer and panic early in mm_core_init().

Fix this by adding the new kho_handover= to the cmdline prefix first,
then stripping any stale kho_handover= tokens from the appended original
cmdline portion, so only the freshly generated entry survives.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/kernel/machine_kexec_file.c | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index ddf4d0e0e7fd..ffaedd055e62 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -71,6 +71,37 @@ static void cmdline_add_kho(struct kimage *image, unsigned long *cmdline_tmplen,
 	    image->kho.scratch->bufsz,    (u64)image->kho.scratch->mem);
 	*cmdline_tmplen += n;
 }
+
+/*
+ * Remove all "kho_handover=..." tokens from cmdline.  Needed when
+ * --reuse-cmdline is used: the running kernel's cmdline already carries a
+ * stale kho_handover= from the previous kexec load; without removal the new
+ * kernel sees two entries and kho_populate() ends up using the wrong (stale)
+ * FDT address.
+ */
+static void cmdline_remove_kho(char *cmdline)
+{
+	const char *key = "kho_handover=";
+	size_t key_len = strlen(key);
+	char *p = cmdline;
+
+	while ((p = strstr(p, key)) != NULL) {
+		char *start = p;
+		char *end;
+
+		/* Only match at a token boundary */
+		if (start != cmdline && *(start - 1) != ' ') {
+			p += key_len;
+			continue;
+		}
+		end = start + key_len;
+		while (*end && *end != ' ')
+			end++;
+		while (*end == ' ')
+			end++;
+		memmove(start, end, strlen(end) + 1);
+	}
+}
 #endif
 
 #ifdef CONFIG_CRASH_DUMP
@@ -249,6 +280,10 @@ int load_other_segments(struct kimage *image,
 	}
 
 	memcpy(modified_cmdline + cmdline_tmplen, cmdline, cmdline_len);
+#ifdef CONFIG_KEXEC_HANDOVER
+	/* Strip stale kho_handover= that --reuse-cmdline may have carried over */
+	cmdline_remove_kho(modified_cmdline + cmdline_tmplen);
+#endif
 	cmdline = modified_cmdline;
 	image->arch.cmdline_ptr = (unsigned long)cmdline;
 
-- 
2.25.1


