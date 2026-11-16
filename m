Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A867F606AB69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThaPefJk
Received: by kanga.kvack.org (Postfix)
	id CF6486B05EF; Mon, 16 Nov 2026 06:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F076B05F0; Mon, 16 Nov 2026 06:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DEA6B05F1; Mon, 16 Nov 2026 06:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 981A86B05EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:08:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 350311608CA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:08 +0000 (UTC)
X-FDA: 85440707856.26.45AB57B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3252D14000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThaPefJk;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UpKqXd1Q8PiwEiW91lGeEUdsRaeGgHVBpYK/fx91FQ=;
	b=a15gnpyIFPX+OSGccruAYDim23joOueX256hYx3LHphWJtN1GIe3OAnH17LlDy8ZAC6mf0
	YvzhHDpxAFr8q/i+v6ZAt0Kgl2SoJdPlJEkHLhq7PA0yTAuoLy2inUkH7snFbQqcz6aRjN
	5HOOJYAxWo2LWpH1Xtyze3ZaErgO8Jw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827286;
	b=DQCZNtQi1f3/HgUPTAQYAw1EhyRaOL9W5nBkBZD1mENYY7HV52rY+h989hOKGnKIhvSxJg
	9jz3RrHS20iq5GRU7a3W56E2nd8Z8shpjxlD9CnyoU6lP1vpYnfyLKMqqwRpsz54v8DNWL
	imbzGKc9OE4egytpEMIMOYAELqg7Jlk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThaPefJk;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82E44462CB;
	Mon, 16 Nov 2026 11:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E153D1F000C4;
	Mon, 16 Nov 2026 11:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827285;
	bh=/UpKqXd1Q8PiwEiW91lGeEUdsRaeGgHVBpYK/fx91FQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ThaPefJkzYID6A/gJ8BD95JHrrRcoJDueFApgfCzzf6m8AFEdrOPX1V/N0Ou5MSFE
	 3MisKv2jAnh8Lq68niVuDDcQgUlU9KBmq1TWQenImwyQsFWqYvNjMCUA6JECgAVC5Z
	 eCzHZrAVshZEsT9OLL1LKL8EXLhOWYBuwDyPsI88o0Rflk04BSpkmzvraWAQ+wW1P4
	 lJTEA6hSyLJvmV54IXpt4SUS6mx/j+/M7f4C24pf7Qhx12uczYw4UemP32oaW2sS5n
	 2peCadUpW/SatJlkDR04CbDtgimV2EQJ4ss/0BvVQFYbPY9qCuNlO9CEhSFfF6dtOq
	 nUL3+tjJpm9Gg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:49 +0100
Subject: [PATCH RFC v3 16/44] configfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-16-8cbbea1cf34f@kernel.org>
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
 Breno Leitao <leitao@debian.org>, Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1100; i=brauner@kernel.org;
 h=from:subject:message-id; bh=arBHZovnHktbx+8dxEhh1iDCO+7a7q/uQBzsyfGCKl8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elz4yo7/8fTyqPtLu0x0Zv8tjtQzyl68wOHUusK4U
 1piFu/4O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayW5nhn4LuCbVth/nnv61W
 jll948YM7hL1TRmv/gSG7k93fv59SRTDP6tHgrPsfflmcXKeOZ47jc/ugU3PlsV14pWbp3dNO/K
 lkwUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: ouq4qydsczw3z9isohyxaf8ws88ph4bb
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3252D14000F
X-Rspam-User: 
X-HE-Tag: 1794827286-950245
X-HE-Meta: U2FsdGVkX19SRg6tntJ3GAzTl2+qU5fb29kzVSKyk8NTZc0jlv5az+NxH/3hm8Cnvxo/ejFeTVSPXXdXvkQgze+zDoCLtAsz4ZoiBPJEcTroFrF6wlTZG0iBevo65WFGMNaz/w7vB7FFP5/QMGOSXM9udM+946Wf/EO6L1o/osAObRdypJYtxrPxTtgcueSR3GP7zFOZuATCGdjvaw6pa2egY4lJ9/TELU5JucowjDw0Vvxcc+jkqoesLRrVAfvojAtP8uiKrJCXTYzKR8vJl6ywIwClC49JkMA0AbMfdbSaiBQsy6eojRKHPpFjb69XMYLP8aBAc6Oe10kWhCcwfU49NFALg8h/gC4RCmrGBoJ7V3ZaESJ25kYdGrjvTgg6M3GQx8gsDjcfCwHFGUaLuBHAvVhYYED77lp9glF3ipOCyZAR0pAAvQtw1j6iA0YqNWAdeVvvGJcmWguGP6ZBrM50wteMKYrgqivrV8U8x1bg9mVbhTxVCzpQFRtthG0oKlv9LfsrUy0r5JzSw5gZxapsgpFefI7xGHBcMbXm1tkGhC0IZBT4V9tXWKih5XTrXz0coHqXJ94du2S4py3lTEof+a0Bm+25MD+ytIv2F9PGneQ+3D2toeI4JDbM0Ph7JGe7HYWaQjJGSY4H0SH5OPU96fOz8HqMd49G8IoZ50xH9747rcFkOCu4omBqqSeZs/aF9WINzaw/JManeve2FrEeDwIGazP51RLfggxMd4lM4NXQlj7+LaJLAErSB6U1c0EPLpx20bQM5Z/ywjpJ+V7iHTVUImsz37aKUec8kRNr0LNmK5OkZ265AzxzNiGvgLUpkRV0hIhqeRCxmNqVXG8oSHpUYTp+SIqnRe88Kw38/XqXzVEPlnQSal1UDQakf6egMEdSTTDld6UBG0OLRltPm4WlMojanvXZEPQ5kvHNhVFzdu+eWOhh3uQgiAfAZGgg83L3mQDar1MleIP
 HM1QJgjf
 CRnmaSiXuC0wH5q413GiQrIhg03MKQQZukr+d+wIn/RUjq421CNXljsL2zh4tC5JvAMetkMX4VDjOhs2R6AvlaA+4KFBNqG2kPbeYibyDJF9pbxTbq3qgvTwFQxi7TPPRr0Z0h5fVGmY7QKgwVQVrmK/1LTJDv/+xrDCZqelDm4TCAeotrulQxusFiOxQvQLlDfkoQTFnIm8FQKvsgDtbiwtVdgAoAAHqLBjT7zGpeN998hP3hqSuvIasWq9Ta2QObtLTbA8O+Y2LG7zP9XhfJPDEq/8/AG09LDFfbSFXMPiX/93MjXg/sGL4esjEGJV2j3Mc98S37QNkoDc2P+vknNYNNhYFzeeUfJRR1a+e91AzFdtEn+hzTPwG9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
device nodes.

Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/configfs/mount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index d8cac1cbf3bd5..60ba24e7ae2b9 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -106,6 +107,7 @@ static const struct fs_context_operations configfs_context_ops = {
 
 static int configfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &configfs_context_ops;
 	return 0;
 }

-- 
2.53.0


