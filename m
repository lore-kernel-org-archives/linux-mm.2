Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DAE9D5B841
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3026B0022; Mon, 15 Dec 2025 10:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A534D6B0023; Mon, 15 Dec 2025 10:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969406B0024; Mon, 15 Dec 2025 10:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 879426B0022
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:25:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 417D11DF393
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:25:38 +0000 (UTC)
X-FDA: 84222079956.11.6516B2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 46C9640006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:25:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e13qmcjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765812336; a=rsa-sha256;
	cv=none;
	b=iXP0qkNQTKfR7Bp+dlzKwMmBJpBSFlNPmTwUqMrSlHDMX3xkpyX06XdKq1MzboVPrc1J8E
	v8U5rqOkUgq3hYojsJsuOXGxC5NZ555iFXtCjYnX84pvyAma5/UVY91YCPtfEUNcTWFEoj
	IedUrlNO81MFubmbyUvx1+BXvXduLsk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e13qmcjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765812336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k4I9aUsUJpKpVvx/qcHZWHO2nhknv0pQ4hQS1nT1Stk=;
	b=Tvlgm81YsCehfINxOgAaK99meOW07rh3X5+cC7ObrvUbwItxp7vawN16OIE+ogxvAk5em6
	e+xVPXRhHGoIRKWv/EYImbooF4MH8MI9c8Ny6UJVaUdSI6VapLPpqgauZFyhbCBq0zRqJP
	HOSCyN1OxYfElZDNGrsSjFFWmBDO1mw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02F2043706;
	Mon, 15 Dec 2025 15:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C58A1C4CEFB;
	Mon, 15 Dec 2025 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765812334;
	bh=mkIo7KJEQTeZErn4R1TynpXwcTTiQfApK6kMsQXsfQk=;
	h=From:Date:Subject:To:Cc:From;
	b=e13qmcjAwrPhAeC0cAhHznqo59gRv3HU4KJyh28RW3Nu9t+c8BjFfY9RU/Xi+4lEy
	 LDgSGpCSpSy37b6TfLKenV0MQ60KrtVcIgw91MbweoyKzvZ6bF6ubBWCHnl61mGFct
	 00x0DGAslok/PGpWBOZrv9i+Yio4qp7J8oiRShdyrEDy+hIhb1NQXpxG7foBxM169i
	 J0MytsHpUQ+OtJ4Gv8zMMqQrKG56aRljQNt2/H7qXea8b11MuANjyts41jXKtS8x9m
	 IB2+0s6SgMJddzp7sJrqTzHZIxMhpt+Die/IVqIqEsINGIfrpBHOh6SjViY0TmKPs8
	 ZWgJr6JPgSV6Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0528D5B16C;
	Mon, 15 Dec 2025 15:25:34 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Mon, 15 Dec 2025 16:25:19 +0100
Subject: [PATCH] sysctl: Remove unused ctl_table forward declarations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251215-jag-sysctl_fw_decl-v1-1-2a9af78448f8@kernel.org>
X-B4-Tracking: v=1; b=H4sIAF4oQGkC/x3MSwqAMAwA0atI1hZMoVi8iohIGjUiKo34Qby7x
 eVbzDygHIUVquyByIeorEsC5hnQ2C0DGwnJYAvr0KIzUzcYvZX2ue3PNjDNxnkq0ZfoyBOkcIv
 cy/VP6+Z9PwnR03lkAAAA
X-Change-ID: 20251215-jag-sysctl_fw_decl-58c718715c8c
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Petr Mladek <pmladek@suse.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 John Ogness <john.ogness@linutronix.de>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-hams@vger.kernel.org, netdev@vger.kernel.org, 
 Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2620;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=mkIo7KJEQTeZErn4R1TynpXwcTTiQfApK6kMsQXsfQk=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGlAKG1vvzqtVGOj5deDTFASziA+J0o6GzQpS
 K9/VN+bko9gyIkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJpQChtAAoJELqXzVK3
 lkFPAaQL/2BXoApyadWKDJjcZKhfBYyuqiQr7rMW2CIoeSMCjKsOLeBbHC0m6BAtuGLdmqdBsb3
 /PtOT1k9iyez0roDo8NQemHT0SupdxouZ7zEtHF03aG+6DnLpcw4xiYx+mgMLKI3wm2fyhkgXpb
 PSj4DBMPF5cx1gzGQ1K91g5lKE9pSo6/SSXkI1R35iTOay1OQMVfE0NaI5oa7kJuS8I1L1oO26u
 z4jZJQKzRpkL07mKiL0GWyAvuDPjMFbb9e7tlZEACNEEZoFvRW9rpZGU97v/j/6T6LjSsTUQWUJ
 Ar2s55t7h405SKOSjEfNbJnrotmNLxG3DigYGQ5xEPzpyS8lmksyhRSzJWrwAa+SW+aYIyYaU1R
 rIczJx1OYp9MD+YtE3Xg+FWLZO2AsAEtZ2oNg4CDXiHgrNBVhz0OjegA4G4bYgNuTnaM/YlZghR
 kMgN4tKwwJBtc8chd7QEMbxHaaWzdtYKOZ7Um9ebZNJc781OX74vcH0nL1GfpWHuKqBXwf86zM4
 XI=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 46C9640006
X-Stat-Signature: 8dgundwdqowjer7tbmdat5k1snetqkqa
X-Rspam-User: 
X-HE-Tag: 1765812336-596954
X-HE-Meta: U2FsdGVkX1/55oEX/o/3yTgcFPiCU8B8XculPbrV4Q5dvXw1JsfS8szKPbPaJmqxfTgD7FHncyA7wQ6n0WpB0QtbwwfbWU1R2W5/vsjaOQrOmMF9qXRV9knhCJ++qoGPyJ1UyMk5TvA5RBM5TwmDZx36v4kG36ZWJJCUW+wSPzKTHZ6uCWVsibvRXOIyjpVAJZaw0Nab9vCTgO+UZlyEUqx1eon5RYRRo5PiOqrbjb6DtSH0twSNtT2R8SfP3uxEYRf62cO7UwBZYvKpWSq8F0BX1QRkMinqW8culPwbAmsDEWIxjLqenFn371NEHQkD4L133qq6LudGqh5dAzZ/lBYYpU4vDlF4kXrQqp5Y+MbPdWJ5k9G2Ig20SsuMBXHZ1xSNxnR1gtOteeAHTtB8MNpnPA+qmwc+i/5pthWGMJoS7MhUNH1NPMuG0P/2SLev+RGO59MuQLsbRlJ/OkheGvKFPqixpdLAmTeKfYkXzn1TdUgP09arzz4Q2gB5ROqM2CflfEzn5SUSWeW9XWXhgOd7/PDrtNX9ARNIXicRcRu2fv7Q8NNPmTyZjrTDaxeF/WJ3TeX6Dw7j/FuDkAnhIywFeZK1mnISOtGDF2eqDhUexJpoYE140eJD75MupBro0KOx+LKa8P2t6b2o4Qczpb8tdMruLgai+KaJHTBYP4f27RcVK0UzpSIh+Hyu6vER58WWtH7TAqhCRgHTzoceZl1i+5bE73ikri4RpTh6LOfLbSnM2s38TJRIbCpIevw6un0GsWnoqgHDClmPL38dqef6AHR+3I2JSZ14nNBD6AT+PTxNgqDsNsMfnZiEEOLXJO1fGbGH3Jkxa9a/pFbLdIWQmcM8q6JtGsaYWPBB9BQ6y2xAcnLk8c98Upnlb8cpVZRD2YNpNFgOHOzsuDhZdyPMFgDC1rdeGjNJZc9yTJ4/IWsUomzmVeyQMv1eT8+6R97+SsQ3PxVybbTGhus
 3TfTo+3i
 T1HfohacH2kUIeUi/REEEem9xtt+4TAUsKt+WFDQ3/91/4dIPVaMkYCraL6pgpAW4GGWN/p7vcH8z4Kw/QOPg0i2/NLSHTKeAiSNaV7PDp9/Z1fyEnr3l84exaw3rE3p9e092YUex6kF3FBEeMSZ/cEuca/p7nST8k4FNNCJYhahlwvAUEuExWfBriPF4qGqtky8Po3iaeRqd1VvYbwUwisxcK1NOdZAFpZpF24gmaiDTsjV8WP1NO5uArdCj7X40VXKIZw7A4lib8l7+vwDIZ0NV30kG2Co798EnMPuoEZmJ6Ie3o9K18qma7dbBfPu0te1l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove superfluous forward declarations of ctl_table from header files
where they are no longer needed. These declarations were left behind
after sysctl code refactoring and cleanup.

Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
Apologies for such a big To: list. My idea is for this to go into
mainline through sysctl; get back to me if you prefer otherwise. On the
off chance that this has a V2, let me know if you want to be removed
from the To and I'll make that happen
---
 include/linux/fs.h      | 1 -
 include/linux/hugetlb.h | 2 --
 include/linux/printk.h  | 1 -
 include/net/ax25.h      | 2 --
 4 files changed, 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 04ceeca12a0d5caadb68643bf68b7a78e17c08d4..77f6302fdced1ef7e61ec1b35bed77c77b294124 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3487,7 +3487,6 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
 				 size_t len, loff_t *ppos);
 
-struct ctl_table;
 int __init list_bdev_fs_names(char *buf, size_t size);
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 019a1c5281e4e6e04a9207dff7f7aa58c9669a80..18d1c4ecc4f948b179679b8fcc7870f3d466a4d9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -16,8 +16,6 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/nodemask.h>
 
-struct ctl_table;
-struct user_struct;
 struct mmu_gather;
 struct node;
 
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 45c663124c9bd3b294031d839f1253f410313faa..63d516c873b4c412eead6ee4eb9f90a5c28f630c 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -78,7 +78,6 @@ extern void console_verbose(void);
 /* strlen("ratelimit") + 1 */
 #define DEVKMSG_STR_MAX_SIZE 10
 extern char devkmsg_log_str[DEVKMSG_STR_MAX_SIZE];
-struct ctl_table;
 
 extern int suppress_printk;
 
diff --git a/include/net/ax25.h b/include/net/ax25.h
index a7bba42dde153a2aeaf010a7ef8b48d39d15a835..beec9712e9c71d4be90acb6fc7113022527bc1ab 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -215,8 +215,6 @@ typedef struct {
 	unsigned short		slave_timeout;		/* when? */
 } ax25_dama_info;
 
-struct ctl_table;
-
 typedef struct ax25_dev {
 	struct list_head	list;
 

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251215-jag-sysctl_fw_decl-58c718715c8c

Best regards,
-- 
Joel Granados <joel.granados@kernel.org>



