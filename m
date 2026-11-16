Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B330C60703C8
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ApAW8mvI
Received: by kanga.kvack.org (Postfix)
	id BBA226B0608; Mon, 16 Nov 2026 06:09:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A806B0609; Mon, 16 Nov 2026 06:09:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31BA6B060A; Mon, 16 Nov 2026 06:09:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80B1B6B0608
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:09:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3383120879
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:58 +0000 (UTC)
X-FDA: 85440712476.16.76D6196
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36A53120008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApAW8mvI;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7Xf/q0YdYNKT2pliNp65/qzLLmVGTQJhtvNXwy/Qs4=;
	b=1DIwbNl0cKZAj0A7CcYxXoWhdPdL1UT/RBYttmYlv1LInkotWfj6yhdxprZB02BCDOSgyC
	4pn+es5+QZ+17r33PU3Y72cogcpujpbBOldy/QIECHBEeMZDT4rjDvSnW3fUBpGcnSGYSu
	EMNn9/ercA9hMCjSojyW7A+kC+jnKPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827397;
	b=CSSv78g+iCWNVg7mxSIwfij4qh+GOFtWXSNU2HOnBfGOONjksIgUY/+CCnfmG3K/1+MCv3
	uN2CqBsStVo56M7fNjt9qHtuUnUhFGhwA1aB3pok12lWdMv24QihS1rJ8gw0A0683kFnJn
	s7Tn6MPVCjSz2EAp2INFvV/tN9gXDkg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApAW8mvI;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 810EA4144C;
	Mon, 16 Nov 2026 11:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711F71F000C5;
	Mon, 16 Nov 2026 11:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827396;
	bh=e7Xf/q0YdYNKT2pliNp65/qzLLmVGTQJhtvNXwy/Qs4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ApAW8mvIJJifAjWYMUb5gxMXy16DRqJm4u8pkiJ8hSizBB/4pLJGRptA/5U9yNxIa
	 xMZTa/pyHHSLFSat1QRBXQMIvBBOH46bkiSC+wCMJ30SJAwiKXLJPAdoQxzZ9SEOBZ
	 G3vlURHcW/ctidW9VnUlrwd1CDDFJU9ArynxTn+S/n0TzxhpLUFcGQr0wD8t5rq7s2
	 rDIEi8/j9EeeO+fKzBSz/q63y3Cnlcjn2qFJEho4HKBhrjQbr4WZA5duS6SFL965ai
	 O9BL7oLYto2CBKxBiOiCC10Wh16aWVflnMPiReBgzJqRNlSQVYcwVO7QDBJErdunlS
	 BdqXVb3PPTzKQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:04 +0100
Subject: [PATCH RFC v3 31/44] usb: gadget: f_fs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-31-8cbbea1cf34f@kernel.org>
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
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1005; i=brauner@kernel.org;
 h=from:subject:message-id; bh=X0J/CLc/AEot0Nag6LzWBIr3X5UH9CZnU81QaK4NiqA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etwULH6lXr7MsEdu38TG/l+zfsnXlD8WUt5sYCZW3
 Vn9ScCwo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCIBCxkZ2p4+qzvcFp18tPiI
 rT/b+7tri/fcdp/2x+vkHoEL9zk/72H4w7PD3/nLRDHRrO6+e50bLORVnr+V233sXs/Uay9DlQN
 bWAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: 1cg8tb6dzqpfiugc4yem1jw9xikjfpma
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 36A53120008
X-Rspam-User: 
X-HE-Tag: 1794827397-299824
X-HE-Meta: U2FsdGVkX1/uR1Rn82sA5ge0yExLKHdVkSylTMGxKMvNIGgapAhhcL4pt6HIwrMA7zcMgBaNysghmmN9x8OOsp+ATOWY3nVnWdNN9w5sB3pBjrGdSWKRv1g3+ktfAUrDc/+twtay/6LpurrHypsfV21AujPveukoHSBRfL16A91BH9gsWMIFCcsZZ2pPkE/6WxMDSfKXRjX7az9vv6cHiOfjN1DCsyxmunjPBuqBfbEjJgxuoOUY8xWbIwpAEp8R0Il8JChszCr/B7Ap5+n0GaMOwBhfxv4uJEJdi9i7tGaBSi6z8vppUEjrl/Md7VNOlL2jfsj3AO2H84ZF0U5NpbzfgrD6aDuHvItcnC/kUr4u8sjBNl4VC63MgqN3Q2/daf8FV3P1xEgNlWf68OvhsGOfSjwGcBCKgk/0KGms5c5P2U4uFHAUvjiE6NwTszugyDwIs1R8mtSuV/ZEOCJjYklvicIrKVemNWx1lUxlJK2+6kB99hgELZJNnY7E1ITZmjvFpAmcTTU30W6aXMlsE9nanaMaZ88FNHdsJMHKYKyByMpEUvrDslQo+K5CupBzj0JXgvmmiUwgoyG8omINV0IzMZwlLZiTDV8Ja683d6lwLPd06DqopcSnN4vofcseIWR+VGjBj+bvAK7DzKwGGALa3vWS2KVTGzLBycdiXmEmut0m2pMvHbyErqVok09q/6pPn99RJ1eUSmMIY4YXTZpBGnNGSXS94590QxG+m1r/Zvmw5OyUUBOcHL80cJ/ihiLBQg9OdFyLkG+Yz+Eh7CDk+Zp6AcX5qAioEvAbcI9XSjO7WN/UF87sJxISEA7CFbP33lyOHDgrCY/AmfKRxV64yJ7/qVZ4+QCh225XjpnhkhZjS7kwlV9wSkoxqYi+9ouKvffQCcOX79WJYQpgKGtjBWNVr8yhS2ysCjETuqbqVxrdUI+v8wkjPpi6yrmzRu1IDt0qcH9iBISJ5/M
 6bbdRTBy
 uZPPbySWzWeHztk71W7FENvwoUlHbuLNcNB9/sbiIs1L67Z32k1AflyARxtCwdkCD5YmHbhEV8C1l0Wnd0TzWR79R2hAtF/l2q4P5AB0SY1MmVh5l58P2c7HBknPFw57qEp2X8IK+wwEDDY0Ql+ATufLagm4dqS1JVF12CbsC/vNLotLXXJycfU8uO4vNlQcWH82uTdwrSk4sIqWe2YN2KPR/RtSveUuRUW8rL3lKCejKBLOo+CjJprOvp8aZ7+Mh7ovxB0YG7KgoQKMutsWQHVZROnNrS+EBQ3sLa5gLf6gDP2TEWv6Yhw/X5wk71d7RYc5qu1FbtQOsGE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize functionfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. functionfs never holds executables or
device nodes.

Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index c64a268e98a43..a6b3788399a56 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -15,6 +15,7 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/blkdev.h>
+#include <linux/pseudo_fs.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-resv.h>
@@ -2166,6 +2167,7 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 	ctx->no_disconnect = false;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &ffs_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


