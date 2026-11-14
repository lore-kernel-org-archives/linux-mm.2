Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230DF606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WeNGCImV
Received: by kanga.kvack.org (Postfix)
	id 370216B05D8; Sat, 14 Nov 2026 08:08:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3210B6B05D9; Sat, 14 Nov 2026 08:08:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210956B05DA; Sat, 14 Nov 2026 08:08:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEB396B05D8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:08:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E2FD1203CE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:28 +0000 (UTC)
X-FDA: 85433753496.02.E002BBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1CD2C0003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeNGCImV;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661706;
	b=uBMRfx93/NHfRm2YVPXm1y86+EXxGk1RFRJsUyADnD7qiZ4LO9mhhb7qr+gwHxWGZvHofR
	ETJoxyQYzve76MDNUqF5Rgi7GYyf/1/e0zeNtHD5X5ETbcLBrSKoxhsgEXUJvDQ82adl4h
	x5mD66Lsj/rHWj6U6X4nWacPeLxPRmg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeNGCImV;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65YvxNKLucMRpYw1FJVCDVm75IlqsZ0/PV8GwJXc1Cg=;
	b=sNvhnGnZuHwjtvvDLCklTSHgnFedQPA7jkQy1LlYjKpsWUHsn2Verl3SJBu8a0+nY+cEBU
	XNECCxZ7QpHSQn2a7tY7VQewpqFmEgYBlvP/eIImKJXJ3n5TogJd4WRtRBn9I/hRnKxLCL
	LkV6TPUGiiMAT//AD36vIEhHG3SETX4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A1754135A;
	Sat, 14 Nov 2026 13:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780FE1F000CE;
	Sat, 14 Nov 2026 13:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661706;
	bh=65YvxNKLucMRpYw1FJVCDVm75IlqsZ0/PV8GwJXc1Cg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WeNGCImVr8p7F8Uli86lXrcXcfJcXXznRaJ3ysXgWVWZ+J7qA0GAbUGY1fIKmINzD
	 Gq0TzUSohC0rcSFwgj1YbJpSzLekANRgSJWblc3JmmjY5rfokTtd8Gk9jL+gnxkZgT
	 4+wocUPn+rNI91e8pLzzUTNjDm+8ueFQcqxvqz59WUo1LF78rr/MQUPWyv9vCtF0MO
	 WOAUe4WdgY8nZL3LH08OuHHlMKXJGnRXtdR2lA/Lm4R0Jw4Sg256wkbSmrYt+j5HCg
	 mTSFDIPBWkEk4eVPeI+ryhW2jC/6smQaaaQZ+zk4OTzgM+AIxj8Ie3NyT5lv/+pHem
	 sh1wJsF9nDAxQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:05 +0100
Subject: [PATCH RFC v2 24/42] efivarfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-24-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=924; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WuyzjhSjL7aXRZxi4H+U5QfhpdKUXYV3897MSDhz8qA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGlUe3TDrZdvVhVT2mR3k3we9/eJDiu6538yOSXAr
 Hyo0qCwo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJ3ahgZ1rM7x73c6uLQZetU
 O/epajfjD835024Vs10pq1pRdPDiVEaGNQXHTYyVl0ebeNRMbl02gWFxsDZvQuTKh6s+L1DpTtf
 mBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: nkqcu7tzokei8rpixzhhtspqfbcd8fn9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1CD2C0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661706-447283
X-HE-Meta: U2FsdGVkX1+fU/6F+6h1P5RHMaWXMU7EJt+LQqfR8rZwKKgoYi2ey0hiAhQ8k3JXNclpDayIjl+QHAXt6UYIZ+7dRMF+dTfApVrNOco82rDJg3bi7yW6mUROpaQPJ213GiQlCnLTwov+5fWNvDOG8X7aH6nqex/+xqO48H9B3zGK+9GaEagz35QywVanuim8yiMTQjMFCXB29ohU/iVafLeEWR+j6VxjkOCvqLEorKI7xmtd7CumSCmAV0Vo0ndPUG3L12qb+MgopcNM40GDMpUrWsB9t3anO6wq5H1gMviza2j8tRkYNQAmTG3byQoWbuwdYSUioplzUgWxvHDQD87/YI8eOILHGvkGjr1h3wSSv1hpMotMfGuidwFiWnzPhc+mC/MzINfWoT9wHgLnABXFidLXhKhtn0ZUjG0GMdDGJhp5nD+j+oj90J9jfhhRGrhasJc8f6kZlwM6lh5FWtL+rH1hoquuSLXEOkcBa/rE1jbIuDIZkBWNE+1tHnbRw1EE2s6o1nj/CWuUAMoCmy/GLZBZQl/IJcO4KwZKatbd0Tk/gOPoLX2JaqRiyBio4wMfurXo1Yb1xeJygKKkhVxmFsHSMxODbk3sc0oxOW/oxlWQ2vgF7murog511iEwRtxdvlTelHQc1g75Nec1otGG7P7dkZGR2GJljDHcEEIllp4BK3x3NepTAlqT1sN1wVuSmo7A7CxciYlRm1VFwf8f0WVxGiEwjnd18ud2ks12YeXD5yqyFQPudZaPAcol9aOWuTQdX1ORqDfJUM2leVsDAcvqUOYhz7Z8NRolXRvDBTUVocqfI6WE4vLM31BNa/5p8WXNzbDF3K5gcjCiJ4YQbmdpgCo4Xkm74WV7OorcMB7ua4yLWWcI/8xfTHkAFVEI5yZ8qcgvuagXityjqYwGSHWnaSO/u9ovECuDGh3Ib8AkpUGo1rDqGg7FbmRU2DiDIuqHZecGBar82VI
 oY7uQFr3
 hyTgNpuOfJ4YD/yg4mZ9XTV0I+biIJLiwAxNL85bRQwt8zWu2SXRixWUwplZEMC7ZDSkpDAvBU098ApFAC+VS6l6pW9ssbWDe95E5yXE62zNDgDWrsHVXS0jE4VS89MDoQxPACo8T1gkuD1YOj+yNCBDJ1V/N1DxJ1UcpFSGadTgCzKbOxOTVTguCzLJYtLql9sDxDU9F3Q2ral7En/1iEh9UBlZIIyrSsEy7neXoDQbarLlWsatej/8MQM5RqsaT50I8EoG08qurTbRXD9c3JXV8sTNnXeXb5nlmOhCPh4Pz0BqaHGxJXbQJ1Ux9cbJh61A+FTjvA1wE87UeTYfNhRV64pNob7+O918l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/efivarfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 12746ced6dc63..e598d42c5f42c 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -8,6 +8,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
@@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 	}
 
 	fc->s_fs_info = sfi;
+	fc_init_pseudo(fc);
 	fc->ops = &efivarfs_context_ops;
 
 	return 0;

-- 
2.53.0


