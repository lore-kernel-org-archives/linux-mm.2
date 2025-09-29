Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6FECAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7EA8E0018; Sun, 28 Sep 2025 21:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41008E0006; Sun, 28 Sep 2025 21:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2148E0018; Sun, 28 Sep 2025 21:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 797AB8E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AB4357688
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:39 +0000 (UTC)
X-FDA: 83940492678.09.76086F3
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 520C020002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NinHilsP;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQeH+ACDAvWfipNpkX5nREJXLCZp+2/jqJfKfCHTDvk=;
	b=YZuDa649j/B7Nbh5IaP26RRb4hrioFLLqw5VgGxhTzD9tpLHAqjRsxeELqj64njpIkH4IW
	46K8h8orlBwmo3e7kaJqNJHnKGj12Oj8AlP0jH2aDFG5oQ8lPgm2kDh1bDe6+qV0JhorFp
	/JSQUP+pn/YnjC2omfW4HwkB87a2wdQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NinHilsP;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107877; a=rsa-sha256;
	cv=none;
	b=KEufrp6WxtkUgvtZ+UweqelnZ9TPSY0eSKvfrZHwPzbXLi7skiWmQ3msvVKjFljcG6zOYt
	pPnnnOVH35sit8AM6q5lMYf8j5oQchvHkY/G3Vc9eHFi4iD/ILPSQbFqoKpqwDazeoIm7D
	HVc9QkDmMUnyse+8DJr0mNaAdUx/mAI=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ddabf2ada5so35675181cf.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107876; x=1759712676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQeH+ACDAvWfipNpkX5nREJXLCZp+2/jqJfKfCHTDvk=;
        b=NinHilsPni/+FBQqOv9/Zle09Qca+pTDv55/jGOzO6bWdqJh9kOPUbRPqFdHrNE904
         Jrdy2oJUtYCmaVf+Hk8gG9YR/i4/ZW3iqlCIqD2ENQvocPm2ly+S0BGoiCICUioiRT2+
         4M8OnWr8O1qmiKkArhD7JhLeklN1q+519vy266ccUcdit+qX9l5HiAc5H2xiFN4L7P3x
         WdOwhfRU78RaQvBut9lbC2tfRHLCcXgopCDScnlJ1HjK4FDot5dZTSB95olVW5Uw9+hg
         I5llxA4VDvLKuuBe3IuVAhLBNooAFR4b6MgWRw4fdxnQoB1oolwc9SWXK2EdS3ulqmEm
         0/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107876; x=1759712676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQeH+ACDAvWfipNpkX5nREJXLCZp+2/jqJfKfCHTDvk=;
        b=MtnAXpeJLfgbF1grzFklA58lYzX5AUA1p77LpbCEnWWXzvFCUz1R3Bm7sPqcqdj+4v
         v/QyTeBB+kueJjr/xOZ5rctl81PolGv3rlMc/flQy1rZ/fJnVKaThdXce7RO5sQC/zR3
         eUDmxNg+8CFp4Er01FFUyrkzs5SXXEOwVOD7O3jQk0kTf5v1/gcsveVq+bBA1g0qGVAB
         D8Z51ZMh5jQiBYQJv1ZF+uyO53Yc2WkMEzdJK4KzbJT4LSDDyk8eOxEtk8RJB0IRBDkd
         mjG9igviGDXlc4d9Bfli7ODTQC2f/PfDs8dLg76hBnU/GsHyk0ORCi60JtkbGlUud5RA
         yZ0g==
X-Forwarded-Encrypted: i=1; AJvYcCV6063e0M1zRdAqZQibw+TuHj+F0GA3ySsnpQE/OwqSqZzc5nLQRwl7gyEl3khRcZT9/xaaSTTrTQ==@kvack.org
X-Gm-Message-State: AOJu0Yyt90P9QNKhLkbNykGRU/B0a//xzGfRnjImJDwLuwe0+xed6ulW
	ZNlqu3TVb6JzHvLLCpaat+Aw1iMEiCYQE3UjkJmkWpMtfTPHSFdqRyGvaq6d5Reak9w=
X-Gm-Gg: ASbGncvtm9P0tPiJAUpsnwTWc6HemqYmpLWP6h3xDBVT/EN+Ybu7gofocGOGZd0p5a6
	t3gBVm5cyEIDfLDw9fy6Zh/Ymj8djm9HSOsfVl2uBAYCvmxZJBCjHiVW9Dfvx2GFnXzjQmlblBM
	ZGIDvrEbTl2rCemjNrA9MM2yn+qYqbwlqOTRC643CsY8vSD6j3xkjL7ty6ZFsWby75Z5/dCLzSr
	zyHea34E498/ije35pCbulHMIkzwe0vaa11bFUkDbv7wAes1QusIQy1DjcvF8ap7m8OfgSyE9NQ
	rZ5WUPDSXY9EkHMnh454caQzy6YhtgL27KnKy4SdIfTSzS+cwD4GzJIqysj1QtCNHS8qokxdGdc
	edWhIEtEYL7b7iNI8POLtIw5y2pN2gNhb44ZFgLxCYzgOCzwjjSQUvOgn50muYGqOaU80s5ByJT
	dGFnNrMWuL1NaZvIpnbg==
X-Google-Smtp-Source: AGHT+IEPxuS/7M1Es5d/LhiTv2FSJGMeUGCP9yWRMSwEvaODB3P25ESHbhk9CzfQ3IGx46q/YialgQ==
X-Received: by 2002:ac8:58c1:0:b0:4df:bab4:f710 with SMTP id d75a77b69052e-4dfbab4fa58mr62437871cf.25.1759107876179;
        Sun, 28 Sep 2025 18:04:36 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:35 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 16/30] kho: move kho debugfs directory to liveupdate
Date: Mon, 29 Sep 2025 01:03:07 +0000
Message-ID: <20250929010321.3462457-17-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 520C020002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: az8rx7ko5hh3zqx3j59k43cr4ya9zqus
X-HE-Tag: 1759107877-219287
X-HE-Meta: U2FsdGVkX1+FNnHgrdF4m64AFkYqRZ2a4oJ+YHMCsI5ue1b+b41zehtZbX5DkAMoYtCOocTqoVjI0YuspCp8pvAIBRVm8us5ihK3cwbUBvVlElgEPw9TxVv//Ru9XBmCHmSW/oZxGcWiRFexQSjFGyz+LaPdOUvTLAvmoJzL5vDcMhuyH1yMCJEmlvkTkBKaOhDlnSIbkqSZg3vivkfAZz5lOvcNpAhrN5QxVZnWjobPKRfRcEDOg4XdV9FQGcHUbm1knY+GoI6XpUAIBuxkJCGnzMUYbpzhcVwRFy0PilGnU0F9BeosGsk1w6bv81KO55z/WaS4J3eoNwUYH8br1NF/fntBcmmjBxcrx1dt4f5jAXygZdVb4MI2RcmN1Jcx9/YrtD/iLBpQTpGk+XbCGUGioOj9H1N9w5qN6WMTYM6o0OsqhjeQROLqGasCYWzNDYtMg35ovlo3o4gMV8Jy18D+rrb8g2b5S3oB9NcEU9wqBRx4MBNIi1jKvAla3jkZThM9qsxcA0yNWqSRUP4a2J27nORx6/8EwnGW+6CUfaktjzKVT7SuutvJwxln69WVnmD0cfbV5Lzjf2MZ6M9e3q+N+1IEwSNZqowb3gCeZRogxgJr9X+mQW3Zk1sY3DGL/ISmISyQxNP2Y5Rb4KrhxngcfnHVD0NLyb7Z7lSUjxfn0Cqm0NhlyATMpGAVdkjO8lTJqFFQKMPPGXVyJNaJN6RN5LzzCOieXkoDEQsPM+UVDeKwFcJ6M2nfZS75JKXF1TMGfzVW7xG8E7t6gAs2fVP5XbHdYqAmH/6Pnx3Am69kosPOpkNpFDSZL1WYeFtEcNgRnWHPRhvEaPcPLgForbA7QPjVNtwifOTqq/YHQhKMDSc7ls/AM/KbnzxMmPIAYgp/4i9W5NJxaoZ+Ft3yJ6GWQxqZD0JOhmzAjbfxmJcvtzcrN2DglbCYSOp+U53RDl2jz68lcw1jFqT+IKO
 d+bzb3Qk
 RubgZ1HUmxM1xXj44uAI5mkaJbx+1KqFXo7nqSC+/sIuRA2czBHxnUMhfgtDmL4MQdsUrwvRMHEGOAuC4uTwj2A+ASTAtEzsasjWmLZGhrC5mVmgcz2/eh/YUsbn6kCg/LdQLN6ddm6i8Yg52byL0yBLFp/PDC3xHMI5NrkcySz75p6wmBZVHRsrSUHIJWqnOOhp2KmqRG7qh/pw2PKRA6hrIEohXhMA43yExyE7Q5BptwMgw/EhT4CdDQmza3AcUcIWC0KNrBQwAabpsULBPNW7YA7ZxYExLA5Uyn0tWbZuhbiUpdZ8UbSgCFvY2RTWCQSJD7+3Y9ZG5BtbeAAXn/yAraBc4opx36tgij9Pi8VEdkZLy00QgkGVNyqo88fdoqqBzemLzX8xq5yshCRa0RIJ4vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, that LUO and KHO both live under kernel/liveupdate, it makes
sense to also move the kho debugfs files to liveupdate/

The old names:
/sys/kernel/debug/kho/out/
/sys/kernel/debug/kho/in/

The new names:
/sys/kernel/debug/liveupdate/kho_out/
/sys/kernel/debug/liveupdate/kho_in/

Also, export the liveupdate_debufs_root, so LUO selftests could use
it as well.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover_debug.c | 11 ++++++-----
 kernel/liveupdate/luo_internal.h         |  4 ++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
index af4bad225630..f06d6cdfeab3 100644
--- a/kernel/liveupdate/kexec_handover_debug.c
+++ b/kernel/liveupdate/kexec_handover_debug.c
@@ -14,8 +14,9 @@
 #include <linux/libfdt.h>
 #include <linux/mm.h>
 #include "kexec_handover_internal.h"
+#include "luo_internal.h"
 
-static struct dentry *debugfs_root;
+struct dentry *liveupdate_debugfs_root;
 
 struct fdt_debugfs {
 	struct list_head list;
@@ -120,7 +121,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("in", debugfs_root);
+	dir = debugfs_create_dir("in", liveupdate_debugfs_root);
 	if (IS_ERR(dir)) {
 		err = PTR_ERR(dir);
 		goto err_out;
@@ -180,7 +181,7 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("out", debugfs_root);
+	dir = debugfs_create_dir("out", liveupdate_debugfs_root);
 	if (IS_ERR(dir))
 		return -ENOMEM;
 
@@ -214,8 +215,8 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 __init int kho_debugfs_init(void)
 {
-	debugfs_root = debugfs_create_dir("kho", NULL);
-	if (IS_ERR(debugfs_root))
+	liveupdate_debugfs_root = debugfs_create_dir("liveupdate", NULL);
+	if (IS_ERR(liveupdate_debugfs_root))
 		return -ENOENT;
 	return 0;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index c9bce82aac22..083b80754c9e 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -107,4 +107,8 @@ void luo_file_finish(struct luo_session *session);
 void luo_file_cancel(struct luo_session *session);
 void luo_file_deserialize(struct luo_session *session);
 
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+extern struct dentry *liveupdate_debugfs_root;
+#endif
+
 #endif /* _LINUX_LUO_INTERNAL_H */
-- 
2.51.0.536.g15c5d4f767-goog


