Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB60606A7A5
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VlWUdDLV
Received: by kanga.kvack.org (Postfix)
	id DAF8D6B05DC; Mon, 16 Nov 2026 06:07:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87176B05DD; Mon, 16 Nov 2026 06:07:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4B76B05DE; Mon, 16 Nov 2026 06:07:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A46BE6B05DC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:07:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D13FC0941
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:00 +0000 (UTC)
X-FDA: 85440705000.26.AFB7E08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8C280C000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VlWUdDLV;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827218;
	b=sL0jTf8K1bFRnRHegKQZfEeH5bzfOrcYYhoFGA1iA0qEFsJv+F3XbG8jW1JFB/vuip8Zpv
	09OAfj2QQSSPiIwJh2KEXxXSzgRZmvfI/fVdmJDMvvfYIg3KsZg8XruCZsh/24tGE7TjxQ
	4siQtDiAYS4SIOAuNa0bM5jVjNYgAXo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VlWUdDLV;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcuZgfEAu/QV7fwp1VLyFSljuB6ko+rpbI5oo0xXTbA=;
	b=AOWYITkSYSmrygG9l5QwYiBxbgYQrOE9APq2l+Q5w/9yMsVxjdLMKUN3FMQmrX/5mbm/ai
	ErVut+fX871Uyqa+qJP5vaLD0ltFdu239Ch4STAi35IHH1NG9Gbe9RdajgHDbgw+5+Z9IJ
	54DFB/YostzfRshzpsJs9CnmVjU3gIw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AC7762965;
	Mon, 16 Nov 2026 11:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF281F000CE;
	Mon, 16 Nov 2026 11:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827217;
	bh=jcuZgfEAu/QV7fwp1VLyFSljuB6ko+rpbI5oo0xXTbA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VlWUdDLVuU7+1W5AfKDV8A6h7bpZD6EsCzKV3QkLOwQIaYytJajpFIVxFa+tZJ35S
	 tI3uPLWgSo+No0yMgSs4xL74IpVyEJcOMhOK9feVdhR0gz/3OsFCh+HBGIfL5bfaQy
	 EeWwUQfCTADTYpl3kYIVLHrKD0071KrFYjjll+kMtoKchmkd0P4z7p5mleDk4dc4RI
	 FfwrK4jlOLZbAGciN7FsmDhx1C1Isd2oeRGeEvBqEwGSDwcR3+swUmLjG4HKFAeiXz
	 c1mW+z65Ldx/VReJb1LQr1zBRFMkwzpCRVKF3SJQ+PxD2B6SIRjYnlrbYtR7otXVX9
	 51azYy6ntC+8g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:40 +0100
Subject: [PATCH RFC v3 07/44] binfmt_misc: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-7-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1381; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Op8caQB40yLDgM+EzuEIWYdaqzetBKTmauJ3/A8MyW4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epz2stXSV/bIi9CLVUrrcpeXPvuV4y5RpjX9R2Rox
 r/jidW7O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYiKszIsPeTS0+B0pFmdk8l
 p0n2046ui4zZq/L5S64sm9fmmVf2dTMyzMt9rHkle3Nhwf2a5nkBe5i1t7ttYSyfFqfzfN10XlU
 eRgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: atj9kij756dtmtuk9pbz5cnx5c13ncm6
X-Rspamd-Queue-Id: 8C280C000F
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827218-742926
X-HE-Meta: U2FsdGVkX1+ELD87n7QgoUZZ9Xxk1coOSQXgN3G6OF0yV8WdW0pdbMFPX8TaXeufb+DGQsMpLExuCEgiWoMgyIMO6BujF3ZvfgVYvrCIfXV7LDgwaxM92ycuHGiz9alp6CzSUjEuSEtKe3beoIB2HVZMSoxz9NI9Y/FwWG/7nHxQMCmh/phmSa+cCucLJXt5l6ZLRHf6a92Syu1afiPnuU/6YXU+RPbTAMjTjswaul0OU9Rg8yu9Pn4rf0fGiQ8L+89eLQjUfxV/eacXoa9h1SF5FOiLrNovy2DmuRJ2bb42T8amjx2Siy29TP5qSbIHQGLTRUGxOdMdgYHAaBmX9v5fY+TtaC8b6wX8PSxf3JFZ391+rmY1QLCpLYeLYl+LsY+m7NBEfycwgKHbpOyytOHmyjypeE9+5MNYkYiSBKqmG66Q1cOXUf+kq44vnCHCa23Ki/5KrrEg11XEbNZPlW7f6/vWAA1ukxSC1Ki2bIOm5OXBN92FnKuEW/AG4XLlvlsy+9265GzHWHh05YWOwYrqRUwBphLjU7CuWVB6peSVah79SzpxFm+Pig2NhzvhTPWZJQD+8Iv/P29obh2unleb+Rtykf5XgsujMimvthAt7Lsz0hYry6TPsqcdtREc4BHUC4pzrj5CoBFfFO2WfHKCjI3p51L+wTL8NSJ7Si53naAJ1aT5yrSmZuf6cx9N9i7TBWP+p4/KgG1GykKUZIxdjxAAXociEdtMUqQA6lFWFzJRn5ZiwBwnskQ/1QyEa6LP0FpSx5hdTTXpjkreL8dJw9uztyMmR16wBUFMszuX48KtyzAsHC1J7qfb0H/OmyfANFC7BWNQJzFBwuP1xKPKxWY8+6dcZfYQJZ+YbI+9XdyyydocIN4xHGomaoJzJgZueFM/GK1Aotsw5eVQJ4UbUgZuCMndTAJhTQZB/6EFWWMYiBwSTOIYdYS7JI3z8l+sHAyIIW+nxWqam4I
 g2Ud0Ili
 Bxox8Pf2U1qtsLT/o61CVfgQhhVTAkjGflG57x+XggAKEc39e5xcQGeRPORLMSGjMRXYm7WlU0EE8R3WxR0WjizY9GIqybetJUFr8XWOzerENv8cAmqe86CMeAG3+rVna2vDcLDaM+JXbTiz0Xwr4ii9rIeBklat5b+UH3Tuts6VZdFI4dQ/JpfcXmFHP5bIVrT2fqlVmunHG3Ya9Kk4gYiXu+WcCokuWQcsBAUtRQirTDCQ0Bw0OkK6KWqSbL1Kh9GVRvZxqg2KsHkxAr4mIpPo2dNJ85dESx4dVbo//epJraxUWsIyTMZUfJWkUcPvd1V3y2PKliid0osPgmB3mmkYJB3K05K6v60Fk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binfmt_misc as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index d945b4f6e1581..7dc233becd98d 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -22,6 +22,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/init.h>
 #include <linux/kstrtox.h>
 #include <linux/limits.h>
@@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (user_ns != current_user_ns())
 		return -EINVAL;
 
-	/* Never exec off this instance and never let anything stack on it. */
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
+	/* Never let anything stack on this instance. */
 	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
 
 	/*
@@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
 
 static int bm_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &bm_context_ops;
 	return 0;
 }

-- 
2.53.0


