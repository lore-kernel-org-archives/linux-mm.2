Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32EABCCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6E98E0029; Thu, 16 Oct 2025 16:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F008E0002; Thu, 16 Oct 2025 16:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694868E0029; Thu, 16 Oct 2025 16:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5703F8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:03:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11553C0409
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:03:41 +0000 (UTC)
X-FDA: 84005052642.23.90434A5
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 674704001A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:03:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flz0HAWN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760645019; a=rsa-sha256;
	cv=none;
	b=CRVM2fdk9wMB44CRgydtaj0ZWw0GJer0AhzcROeGkJl7kj5eTx+GwuUub497AL0ox8+Id6
	FpHIlCOHaFZpMzCifLq5NeeB7OU+AiC65kMgD38nIdTzrZez+MPaaQ+U1cwH7I7mls3I7O
	MeKVsqQMq/WE7dY2JPGSzJrntwTWAGg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flz0HAWN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760645019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hZ7ypki6CuYeCryqFiqKvWXs+ZzivlIk6Wotvz3thCw=;
	b=rzpPPv436Uhho8Tcbf4TlSQ06+IyFNtawdtF2sLGAGtilLhtKHf5fZW6pSBXuQ90SM+IrV
	WrFyqcF2woaNN2UKCcHg/khhHcjWjAkiI00525yQyRwn+xIXc5YTwvsaVeoRabV+S0QXnG
	fOhowgFitbQLlVXlw1KRDODYQFrYRlU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760645015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hZ7ypki6CuYeCryqFiqKvWXs+ZzivlIk6Wotvz3thCw=;
	b=flz0HAWN9ApGK0shi3gJ6lDvw6V/IDIeGbU0w236HwES7BzMdLM7w32ZObrecuORBGSmgQ
	FQQjch2XhrH5Qanf4V5CmEt38sbrZshz/ra8CGvuFgJxDEBHQ94ruiCClH7DkegUxbv5QO
	jlNAQ6l5GuPhcb/HZmLzIvK7x4NPHbA=
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: kexec@lists.infradead.org,
	linux-mm@kvack.org
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>,
	graf@amazon.com,
	rppt@kernel.org,
	changyuanl@google.com,
	akpm@linux-foundation.org,
	bhe@redhat.com
Subject: [PATCH 1/1] kexec: Use %pe format specifier for error pointer printing
Date: Thu, 16 Oct 2025 20:03:20 +0000
Message-ID: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 674704001A
X-Stat-Signature: wgd7pjwmuno83rqqm1kn41gstsira38c
X-HE-Tag: 1760645019-33568
X-HE-Meta: U2FsdGVkX1/Iq6FxTBr2clcmDzGqI7frw3LvNxVTTPcUwvPHdHw+F8+YjdA5HWChU7mQPHY8YmzrTCppkLHEfsEGpxGCz21t6c4QJOBbXJkZ4g2eefILorhP/v1pR0Et/0hc+wzXxHiZS5KtznMwJntViO/9aVB3GqeWuCRSzHqZEjktpTkhTHCzUZK9r4EZpnuYAg/x/Ih84mG9WAWjA9xbNqW6fqXUzObADNQYCUDhwixedtDFuqLTdya9VOJcG2h2tKjCI1s7I4IC8DrcCmpXUKyHDU3MPODT6japkup82Tq+MeJeJ5ZkmXNttkMXjIbHa16kTxgz9ekFfb5DcRZp+y/8AoiRUiprmzOk6Sdu9kIh7g6x48GjSzAgX5DMmuKGmBMWIV5kRa+b8+PG0VULfELAUqBA/KFFJTZilhvUX+DsK5Xy+3pRG8u9xipT0BGM7zj9M8v/0pjjquMmuxaxE7gvXFOLVRpCXGX6GW+6zz7UYx4UxsneQsF5inibTReM5JisO8k3Lt/sDXBLg8IzDWTYEkz5FkwRljDJuRAnHK0IljbHBlw3ez40JzkSSv5nl4O7rXUuE/dJIOpkr8QyBc+khlKSrZ4I1bTdHmwg51fNqjkPZS1il0y9cnG6Z+2bR8qkhHri3Eu/wpObjrwz3CLavugRJgZqh9h4iNq75Ix1+TPSBuXLdk+203kjSdr2xAM2/EeZ8GFG6+Gj4zSSbk3j8foVx283NfOpO9l7IoQ16BPAQ4/g//4iyDzYBUf7Gg0OIJaC+gkxVNuIAJz6RkiYfM1f3mL/ejA8ebIvYNJ/h7TN7rbrA4qYuhDUjHwZJ89Ioe0I4QYYxTv1MgWcV1Fg03chBwAS8SEQCS36C647GRaZgQK+McT0IefZYjHoS3fENengunfxjLlAIbL2PvuIZ5uuzCwYP6orvHnJX7GfTF86wGLy6iOvgFDzRzd/dJmdKXrSOrexed1
 n0BUJTW2
 LdhKjQ/0J832ke1/1YUfiYbqif4f6TCHM2eF/APV9GkR1rde8Txnv7Fd7fNDaPCG4mMQSfISetcMqf7awJ2B4ptEiSKLixT+TUVXYKlj2Zc08U/EMY0LwZuuoVbBBIpBWVjoceomALN522JIcthxPVHTzl0SxQlipjRV4KaMFDVBDjLautvVz5AmfuOy/c7yJf7b52wnDZRZsz+9u9ELa122o4KbHU8xwa5wFTgr8GhdnQ73OIGfaRNUgqSDaRkCegn2GCRROIj0mUw7EfoP9ewz0T5H5SQ8fOi6OLfMZHhNMmPEdFwqMqMOA0aDzkxls0tFDXZ0YuIN7WFmT4i4knDmd80Cv8uHC4AJe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make pr_xxx() call to use the %pe format specifier instead of %d.
The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
-EINVAL) when given an error pointer created with ERR_PTR(err).

This change enhances the clarity and diagnostic value of the error
message by showing a descriptive error name rather than a numeric
error code.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
CC: graf@amazon.com
CC: rppt@kernel.org
CC: changyuanl@google.com
CC: akpm@linux-foundation.org
CC: bhe@redhat.com

---
 kernel/kexec_handover.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 76f0940fb485..77af377022b0 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1095,7 +1095,7 @@ static int kho_abort(void)
 	err = notifier_to_errno(err);
 
 	if (err)
-		pr_err("Failed to abort KHO finalization: %d\n", err);
+		pr_err("Failed to abort KHO finalization: %pe\n", ERR_PTR(err));
 
 	return err;
 }
@@ -1142,7 +1142,7 @@ static int kho_finalize(void)
 
 abort:
 	if (err) {
-		pr_err("Failed to convert KHO state tree: %d\n", err);
+		pr_err("Failed to convert KHO state tree: %pe\n", ERR_PTR(err));
 		kho_abort();
 	}
 
@@ -1355,8 +1355,8 @@ static __init int kho_in_debugfs_init(const void *fdt)
 		err = kho_debugfs_fdt_add(&kho_in.fdt_list, sub_fdt_dir, name,
 					  phys_to_virt(*fdt_phys));
 		if (err) {
-			pr_warn("failed to add fdt `%s` to debugfs: %d\n", name,
-				err);
+			pr_warn("failed to add fdt `%s` to debugfs: %pe\n", name,
+				ERR_PTR(err));
 			continue;
 		}
 	}
@@ -1400,8 +1400,8 @@ static __init int kho_init(void)
 		 * kexec.
 		 */
 		if (err)
-			pr_err("failed exposing handover FDT in debugfs: %d\n",
-			       err);
+			pr_err("failed exposing handover FDT in debugfs: %pe\n",
+			       ERR_PTR(err));
 
 		return 0;
 	}
@@ -1524,8 +1524,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_scratch(area->addr, size);
 		if (WARN_ON(err)) {
-			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %d",
-				&area->addr, &size, err);
+			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
+				&area->addr, &size, ERR_PTR(err));
 			goto out;
 		}
 		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
@@ -1553,7 +1553,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	if (scratch)
 		early_memunmap(scratch, scratch_len);
 	if (err)
-		pr_warn("disabling KHO revival: %d\n", err);
+		pr_warn("disabling KHO revival: %pe\n", ERR_PTR(err));
 }
 
 /* Helper functions for kexec_file_load */
-- 
2.51.0


