Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57E660781D2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hqVGQD92
Received: by kanga.kvack.org (Postfix)
	id 0BB116B05FB; Mon, 16 Nov 2026 06:09:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043E56B05FC; Mon, 16 Nov 2026 06:09:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75896B05FD; Mon, 16 Nov 2026 06:09:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCF1C6B05FB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:09:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A16880907
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:00 +0000 (UTC)
X-FDA: 85440710040.25.1FD0C46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A1DC510000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqVGQD92;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ek7FYduULSVbUq5arr3ZrFc9sF73FP4dcX9AYxY+9Ag=;
	b=brYOV1+X1U88IgSrEF7VdD3sldMmaH1ZTixjmSR1zs18xY85yTaBiUiKlA873tu8qpVDJX
	PRgi2lmpLFOsgW2U5m9kmqDNEfrcXzZz5hgpTVoS3NFBW+KYgelUQ6Ufa519K1CpbncFAR
	eaNLayi8JT7c9X//rf2FGx+63oJe/yA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827338;
	b=DBCG5z09VxWI1Z/8X/F7Hxep7SX9+YMlnYKZ+rMDtmQb073z9bXXcXVd7Sp/+UTjZopXA6
	b2Xr62NUR57TlZTjiQoWEUK5aDi9Vss42+M+JaxTii6MpPLTAnuC95XXCZUzYZL4SXa4Oh
	3jA250RnLTgrlJ3Ui7SIPpo7kmjaT28=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqVGQD92;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 337C5601FA;
	Mon, 16 Nov 2026 11:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB211F000C4;
	Mon, 16 Nov 2026 11:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827337;
	bh=ek7FYduULSVbUq5arr3ZrFc9sF73FP4dcX9AYxY+9Ag=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hqVGQD92ptf9qqnybXZsjl1lBXLy25LXcD3qck0h3II6D1+uj2w0UCe7AnC8yfuUK
	 DBvlP7U/ezRfWQ8Rs5suLaGriT1BSlssZ9axHhjPhAuXDlS1Y/K2QWswiS2nf0hd15
	 mgNz1M9WUrIByUmgj4LNTVaef0wBQawvbuFhB9JsfbJP+PbGz3/XCoYokswy4kK25Q
	 X2hrdX3tY06xzdGLazSIumYwZqYdKkoPSnb1hfbzQy+wt09vb/IMMve/bJQLAIa6F1
	 vAjADxJuDTMP4T1sHKG0OZOaWsM6OFV3enjzvFavLrjqm3CNNR7zTo5aWyeLsdFncs
	 cnHuExJ0EguVA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:56 +0100
Subject: [PATCH RFC v3 23/44] fuse: use fc_init_pseudo() for fusectl
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-23-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=999; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7AmoNzP4UOKW+VKhMYMUlDwuPOwZV6Om3UBU1WIAvFs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elx50rnV4OoK6YIK/Q26axukqwxsMu5p3Jl8d71vu
 a5nhWt/RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQ6NRj+qb3+utWQ88yGsDn1
 fz35NzrGiu+9VZp3a+fs5gueVgtSwhj+Sh5vPv5J8uPZIynqDy8WReRO0+3vnPshjGGN0vOzJl/
 fMwAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: yngquzo7zxswcbaczkpbqtwkmdufyt7g
X-Rspamd-Queue-Id: A1DC510000B
X-Rspam-User: 
X-HE-Tag: 1794827338-835102
X-HE-Meta: U2FsdGVkX1/W5szCckXVCYaOH+9YXgnNHVeCBt5AUCwTzSxx3D7XBKApj/lFmRUbKA13v7daK8xYVHOOM3/cVrrbCXyEFcxdclGf+rXgwG5AsP3vv9MbJv2sCJSzwEEflkvtSxawi+VKRqnnqx0FKWkFUSflBvyS1AkZST1uci3Fo0HqKTc2/q5UFI0kw87/opnq+3AMNVHPlW3irDzKwvrCyppv8i53DQr+DBw3e6fqduiVjllk+uS6xKtdlZYdHZCXbPUhmHdX28tx3Qik203x8KY5M4x0Bxxa+DBiKypn1rh1mIOut8mMwtfu7F9soOPegRXO3cK0bCP1Hj85H/t4qx/HoqvEN4H7rodNanqN/UrOEvVW4F24W3sc0HIT9XqaWJFotw5LiNZmVkRZA5MziPiwd9fIK4i/e2LcZvXMxRl4AItUufiKbVFQVtLmpJ8q8LohX4axtvT/ZfKRQmiuyxILz+rV8cMgxpGECJ6CiwsMLScUl2qiPCbKv5arqlF6EBVRf131VoryDplE99zTq745/OhQ4z+XGdTzzim1dI+t78TfEIwNNDy4w9edx7iKvBBKldWb65B3BuoH0IG5lGdb7l4kZ/NbWNYtEBT+kI1dlTOVZI1gpBSxhRNLM6ISOOMIkd9Ey8RahMNUcp1W/s53HWuBZklDH+7br4SwZMkKYazj4PFKSWxENdGbfpK5JYiKWgdY2Hn0oQGoYhTDkomu9cBP2TDw5b9QAwP6VTpIm/BR5ewek3Khp7qhO11Pa0Tu9C+qCJZBrajX49802GYDfrSb8xlCBuQGwxEEvIuFw35LE8cHb9VFlB2Zowuo5ewtFB3vnZRytufdPqraUsi39eSfJcDMJCFy2JLJyKKoJ1J8dW/rr/kUEhVezs/YuEmQ8EPeDetz95JIprPVPT40bf4PQwth+CFyx2SGwTLvxbf48J+GsEYPPtWV1PTmsVSmLNRDzjkuhyt
 z/yDfERF
 14J3zfmObNErHRBDuP2Ag9divK/+BaoubbYNiEPjFE2WsstHHL8lNqiT7XvSRwR6TeWbBXQH8RLtaSR45Xp8TdZxthFThS9HZ25jK7icUAjNfi8LER5BKlNuxQ+hdEzUxDk6MIm3wP/L7fI+cGQOCdrCiBQJ+8GFEeMibhRBupU1VxgRvfYTcjMpfPTBDd3UQjBKvoEZKnaAtwzJIzNcggQJWEkQj/mWubVWPHGNfheHhBBpCKeuOM1jFRzGjVLIzmZACM80KN59COVvChGgRKvPQMHl/aXKDHJaOGYRpVw2A/UHIYlt8OEAAnxa/c4kNk7Dob1Jg83IIcxYULCtGBXHxzRPL1Y5yMEv0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/control.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 21ffde596d611..4497362e7df06 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 
 #define FUSE_CTL_SUPER_MAGIC 0x65735543
@@ -334,6 +335,7 @@ static const struct fs_context_operations fuse_ctl_context_ops = {
 
 static int fuse_ctl_init_fs_context(struct fs_context *fsc)
 {
+	fc_init_pseudo(fsc);
 	fsc->ops = &fuse_ctl_context_ops;
 	return 0;
 }

-- 
2.53.0


