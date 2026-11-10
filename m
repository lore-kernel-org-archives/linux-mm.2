Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD261606C659
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cqE1KvWE
Received: by kanga.kvack.org (Postfix)
	id C398C6B05E5; Tue, 10 Nov 2026 04:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10A16B05E6; Tue, 10 Nov 2026 04:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27136B05E7; Tue, 10 Nov 2026 04:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 862BF6B05E5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:19:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 211F9140161
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:32 +0000 (UTC)
X-FDA: 85418661384.10.6281890
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66B5140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cqE1KvWE;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61GGJusgpyzZ+uPz/Xbu5aYUeDmjAfN/VZVh7aWKvTU=;
	b=W3PHoHLlemaNAm08KCI0xcouN7IMwvg3URnvqsCmN/5HOg5ivxfVUhlRbJApYQ5BD/UuFl
	OVEmJI6Vw3np5fwM8CAYUcvn/FjwtyhedOLO6o0krqPTvd1kaxHGEu40Sav8eZ2j+Qo6IC
	rfVfV6eL45/RZ9vHsxhUDf0gv7yXtMs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cqE1KvWE;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302370;
	b=atM9fQw1qGNuD4+vH9pSwY7fvgB60HGbpoHyIsdU46o20DD4ZQhylY/MssgoiE8UIG1/2u
	2QMt8cdY+eHmXpmp/EBv67eCNqS5jpl7j6m2Pf2cwvXfrSHJo6qoY0W5I49KLeZwCFOxw1
	ObI5/7m04O/4r5kUajvsFQdJ7Z1rTzo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB1F743B22;
	Tue, 10 Nov 2026 09:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAF11F0089F;
	Tue, 10 Nov 2026 09:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302369;
	bh=61GGJusgpyzZ+uPz/Xbu5aYUeDmjAfN/VZVh7aWKvTU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cqE1KvWEqfCGk9TU1/lVh6ReyYZK8xzJKhSLwmR1cLY0RyRyETFTNmRX/CBtNbGFm
	 AmuFU6adAiumck8an+GpWWAeHBHqTxVKqL/rOi4J9iHi/mWcjTVLhL+WnDXPLpVbqc
	 yNZwiqRepbCcz+qfyuBGhyN5+Hq+js5kBs4E3JLsZlH6qW37IQzTV15bwwycAzfttl
	 5KH5f71aAWWbWtMYVn2+pgetQgDmUXbkZvrrt3OqlCUUpM/yVT8GMncN9mcbx9GAj6
	 7GM+h1AIZhoDOm6jyzSEu1Y46hB8cYzaIFJvf0HAlzzReo76KuwOVqRDN7hOswsejZ
	 ZJtnzm0RI4l6w==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:47 +0100
Subject: [PATCH RFC 31/41] usb: gadget: f_fs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-31-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=955; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Ax5jIfHABzRtvx1V7vJnXeFPM8kck0XZoDkmZlrhKu4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erAjdtX2CfKp++Zticm3SYuW8v6aMj1ObN8qo7eS1
 x8t/6ib21HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARrwpGhs3ZDExxtr2C+4r8
 vRsu23RvyHzNtz1BoT1I0k34U0vwB4Z/1tUpv1Njvs9dubSC+cKR5tMG9m/4Jj97kF74bYvUGf5
 udgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 5nsznp1oeh7cncuocknkssroiuu9p648
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 66B5140003
X-HE-Tag: 1794302370-944192
X-HE-Meta: U2FsdGVkX18gjnXsWlWOazDdEO7Wfb/NWy+r5XcZZHU8hGHfJtTHLeW8RdNfUnYJxf09AZwIjLKPHe1zEFr2ZdG60MIuOmWflHC4oJtAz50ACoWP1wJxqQ5dy5szMVAEpzBPTw4ArbN+/76XZqlGsZz5Y3FoBG8gQAQwlEvySeBHAXbZxb1cUp92QpUyJTme4nWYSSBUTX6ZSPz9t/F0+el57mYMCs9uj53oF9dz7uWyORgcI3T1bRMqEvcgfLczY1iQ4VOK0xuYQFV/K46qd8lLxSZj+toh7wwcrO0mFvJBAenLs9JsrcK+/kdSEUpkzEIy+suBYlLFTr6dDU0VTlCw9e4zS8PB//igHgs5BE9We4lEv5WPnqxpFV4H1RBuKw4hXfG2gCcPEeRKGaKwxK3j5KLXofwQlQ1T9mgTL/B0HXYnSZTN3PVVGUr/9flBAKmdKs95qgDW3lxCoNjVnIEZvVel7ygpd4DSoFyrysLO8qSP4cZMTrnbaVMsH9WtpZi29N5Kv1pCv4uUREgMIsWFW7iU+s1eZ3vQEYTFmAkLz1BBaQAlm0heB/SCi6QAfPXk0aQdy7sggqEe2W6F+kx9MPjbQwTcK0fF9OKF63S4BJ2hSgK4EODDHVQanSUax8UK1sTHy7cmZns+raZZCUx/40EPPvEv9qLPGc/7K1dogS+dRE+Mp7RwHH/RbA2neNkq6PfiKCGORH5b7pqOoD/j9x5tmsBDAMwYVp2LKXBAHHym/bk5LB4vdFjn/lROoZGqmfRnRcRXGe9tuYNwolINKkOpCuTMhszJU89GWGCtXrx5yVb1o/Qqk3Tm31EIKGWPOb8kc+GO6wSkV8G9oJzuM1pLuiVAigoII/jrtg3kjn2+PvQtL/v+cMjzKLiD+yU1qQcoHN3VrQqV/2DjdrwymxXsHODTRzQlXFt7cQyIm1K3Iqp12g3aC/XaqxG8vZAuAbqUyHoV55xtmq2
 esk41FDx
 l9HU/4OQ3OLDkl//8Jh/fKn5p4bFaOEt8ELOW4Y88Dpu9GZhb7O+1ePdR61zFG/oTxrcW+TaAzve6MR/TigVjTy7S+emng5l4cOFKwaIcPxZIyQb+paD/kCvga0ot3/spp1RgGg+gCpl0EQeLo4axzIa/9ExvH84XYPlF/2UF83hQMUJbs5GBTEQ+QLoWUaKfYCw2kdbvHLuhjSRlPrGzm1J+kVvWkfdz2FuvbNPd+g0b/k1RubiV4GB/KRjLcFpEtPK4+2+XSCfu/KgPY5/kOAZpS8Txj9lXP90uoziZl3S9xbQguPd9nxW1rbs20K7xLhBXIDuseRqQQq8=
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index c64a268e98a4..a6b3788399a5 100644
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


