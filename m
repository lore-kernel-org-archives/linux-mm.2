Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D7BFCAC5BC
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7264F8E0012; Sun, 28 Sep 2025 21:03:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672608E000F; Sun, 28 Sep 2025 21:03:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1AF8E0012; Sun, 28 Sep 2025 21:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 326698E000F
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:03:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C40CC1A01DC
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:48 +0000 (UTC)
X-FDA: 83940490536.01.3FA438C
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 08B88120009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IdoR7HTx;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNgtpsyj7RLAHZgXPkVDbvjA113c53pRuAQVjz5hWqc=;
	b=GDtlybTJ1rIo/WcTW8U+Ql3GXnG9vkTFDgaiDD1JwAqPT4j0UmkDyYjLnKQplYFHNLevZO
	EChVvG0f+8azhCMhw4NTvI/kggPPScHU1Mt3npXdRY2Vf+SJ+akLoOj5ccYNOKqgzsiDV3
	jfHohDJogxYLXGlZB/MwgKyGof2XZzc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107827; a=rsa-sha256;
	cv=none;
	b=EUnEJq7gifdrSL7jK4rNUr/Bj9SBrTvMU/U1S3aY8MuRJS1I7pOjTb8OyyqX0TBHHN9ikh
	oLF/wQY3O97m/DkzGWhrb+JBYRtbl96TySOEy0th9R6+TnMfm0i8i9vdWI54itdMw9oW8i
	9MwrXhAY3wxSFkBiG13C15EJDIhErYQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IdoR7HTx;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4de2c597965so23455691cf.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107826; x=1759712626; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qNgtpsyj7RLAHZgXPkVDbvjA113c53pRuAQVjz5hWqc=;
        b=IdoR7HTxtua3JTzbZZvwYqydDLhEuboMyWMDBz/U+qbJy9wwjxpk8tjcs3y+Ir1PDt
         CKxJc/kWNnPYWzTyjpx9of9UODjSJEbMn6k2sZMzd1HYb+9m6Fyi4By3pRBl2EMBY7Cj
         /xWoal1lwDLztXauxwgXoqAf8pioKfT9PlcJAGbN1ox42QTbKgR+8WlooBPQHljfm6Zw
         RuiSwJ/KUUmmTg4BR8dy5d1tP4adHhW2EXMf05lr6VwugZGDPYvhWspoeCRvNfcy15oZ
         FRnNbjvAFt4hl1vgoiko+wC6JgqGAXyXlgVnTacOMkgnikM3EUokVAU7GXSrvCXFRyw2
         dUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107826; x=1759712626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qNgtpsyj7RLAHZgXPkVDbvjA113c53pRuAQVjz5hWqc=;
        b=kGnrS4btAxFw/Mn2PyYqiRrsWddlSxeeceTDFHzOnpEanh5KuWqvZmkOzI6cIacKbh
         cggrH0nw4FZfn3jOfvoXhdUFSggKFJj+Oit5trbC0mtgqpqqVogXSrQwv2bKxe267imv
         KTcPTogPA2aW5+lPuODbfUFQhYEBn6NnPS391lKVfYrSocFw4qKjbKMydiZpc3+sViPt
         p5i1ju4UgmGSuNYf6tPSidppjaX1gRI1VxvKbnbmRBnVb2Xp2ORNLipM6FFi9eWbc5Ot
         BBTYz6vQmW8v27vzyNa8iJ5J5Ml9tYd0rPuVZ4IAZK7FrUVjtifbs62EaEXRz985fxMM
         3vbg==
X-Forwarded-Encrypted: i=1; AJvYcCVm+zLLbU8030/BCAe64eDh0k8EWWbTGtLNYgU1Y5nHOryNVHY0XsEfjIPoOJPKzHkyDxJTBkVnUA==@kvack.org
X-Gm-Message-State: AOJu0Yziz7SZcoYE/S8K1ASXFetk8XFaBD39O4aj9QUFU/b1HwCklKjg
	zlxRJIGdbkVANS+b9zS49+bPDoY/ljgVQ7R+NDh6aDsKDwnIWdcQJa7oBXUoyafNbjc=
X-Gm-Gg: ASbGncsFMKGxxhC2FREgQJ6BRHpWZtROKbGQ1M5j/5J62+AL+XLxiAAikaMSUn/Y26i
	nG5i56FdLm0vwHJv5Mqi/oL0I+Z/1b3tKyk/JYKZ7TQpaNjaCWWN3CkjvFIr5KEgKwkbA6k0stW
	IjwYrWxiq4CMisn5MGpKNtDD7q/+/T1EivIfHikpmd80gbVhrobuXI95yHrRyr4kDpsdb0Mv6uG
	Z0DBj0pdPR4fYSmL9zLOHQcml2t8Roj2pf5PVfw7V3CEsf/M9fv2d5vxREO+9L9uIWm1j6Fde0O
	jOrswLuS6F/orxnfwsI/njAnygNIVsbVwa7vZ908CAyjUtlfab473HLYnMc2a7bWzgvI16DkOuf
	C/PQQbmZa3worn5dOt+kF6iJh5w3yVSDpDWm6W9z1Tgls8V+p4gik7mZ07MIyA/LNtuDFdxapuf
	QlBMH5ag4GhJBejPG/5w==
X-Google-Smtp-Source: AGHT+IHxH0LChANCVLQGPE4rLJ8RYbxJBPP7307a2p1i+UBLkReBGwGJRjYxsz6FhDJmrWtglXB3xA==
X-Received: by 2002:ac8:5fc5:0:b0:4e0:b72b:7f6d with SMTP id d75a77b69052e-4e0b72b8612mr35576991cf.29.1759107825963;
        Sun, 28 Sep 2025 18:03:45 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:45 -0700 (PDT)
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
Subject: [PATCH v4 10/30] liveupdate: luo_subsystems: implement subsystem callbacks
Date: Mon, 29 Sep 2025 01:03:01 +0000
Message-ID: <20250929010321.3462457-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hmptwn8eskjngyzcahq7ha73zbytadqd
X-Rspamd-Queue-Id: 08B88120009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759107826-983402
X-HE-Meta: U2FsdGVkX1+y0mFtwvPDBdUAoAEOR7lackO/8Ghfx+aSKq1UehPgVzyIoqf7jAQFhaKBpvHb2W+54KgnyRsAk+CT3G++wyW2wkEQGwUFyw7Y2oBIEoHSq/HuLqvdNOzfcTUvKxH/c9SL3wA84+WIecVrJPCQv2WMk7X98HWVNhCG1D4NWnndAEhpyO6k9Fap7r6dirbPu01LUAq4cB0izAUXJfcbvusurBOuPyXSl4VWJ0L95d705SRNX8+o/3+hvZ/cwZfwKFhzylIttW9ABe/FlThjAS3E711OPXF34mC+nQCtBI97KcbXaBdRquc0yc2YSGUqAo9znqfFGCET/kxzCK20ktmryfrg0Snb7rBTRtav2OXLvSCyKcjJK20SbzeMaooNi25psCdCIrM8HlflqzzY/Mbo+Zq7PbxlkdXVSo4Pyzsj/7UD16vlmoQnDZ3snUidgIWetKF8wXrer5zZNtvjXvj2kaoGSfTy2LzJ606dVI8Z3vhR0TLbzBuFMex5NJSKrAOfd8rX5RYUTZGW58eknbnxq/WWp42XgPESsPdfsccm1RWKP2IzalV/rEOnclDfw7e/TyBW4pOeU9MTBktLwjS9QY4HiidnNOqMoiomq884E/CSltWsqBhyQ6mgH8ewG9dTMtXjiXicjmykumjlKX+kAx1S1XBA0YgdexPHLd5cR7BwzH6Ry0AZAtMrl5h1cuQPo5jMUCcXrAfk7fTWP1kBFcbzlZCZqE2z5wLRldOzcsNjf+LPMda/i7YLUh6xcHo5fam/JLe3K7k9EU2JiN+8XB/ZHzv71UJz4Yay4bn8gQd7sdVIQ5hUGSpbfzDuizq3f9cJ9/0whqN08lhQ9n1IGuNYP4fVDx5z/4EKSHqyt+PJW8UPL3nkyO/90zan+1BtkK4pySOkoEbdIV1yPxFZHM5TATuvGcYA06PLwZe26t61iWe65ZIe1tH1aB23zKXIu4fhybm
 9WQ6y/Qg
 YeVVIFGyf+6iCG+cS+SUQmNV+v272uf6zaTTGhJONsUAdDyjjZduFmtP7BNm+GaJj1Di487wTxR4E9EVZm1YClNs9m2cJeGV7wlL8xu0PS0p4goN9pdppAtzIt80gYeFnIXz594SySOZf6cZzXcnQkUj3xPL3++EIpVq19An+PMwkeDaHAY2zFWTh8XIqNS6pZCuztA0WmjYQXG81gU6CF9Mf8+g0q+5agrHnShvwJs0jvD5zZjalOuHrD+IRE3KYmQ7j+4I3QyonvSXjoW3P2M34Ou697n5jMXnirm28MooOdwbwIoyM9PZGKUIW/6iDj/P/UoJlWM34HtGFobuxU4X2XVxu5J7KiW1nqb5Hj4yRX5t1p4omLb5ZdgSAeOG8o//aZPKyPjlzk7oep72MWWUBV5oBr+s1vJm0KWZ28AyyGG0DwgPY28/bhNieCx6Gy5AjCuDQYPgvuP3AUj2N4OhT0MFaKPW0ou+IoInZ8+ns8P8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the core logic within luo_subsystems.c to handle the
invocation of registered subsystem callbacks and manage the persistence
of their state via the LUO FDT. This replaces the stub implementations
from the previous patch.

This completes the core mechanism enabling subsystems to actively
participate in the LUO state machine, execute phase-specific logic, and
persist/restore a u64 state across the live update transition
using the FDT.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_subsystems.c | 167 ++++++++++++++++++++++++++++-
 1 file changed, 164 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/luo_subsystems.c b/kernel/liveupdate/luo_subsystems.c
index 69f00d5c000e..ebb7c0db08f3 100644
--- a/kernel/liveupdate/luo_subsystems.c
+++ b/kernel/liveupdate/luo_subsystems.c
@@ -101,8 +101,81 @@ void __init luo_subsystems_startup(void *fdt)
 	luo_fdt_in = fdt;
 }
 
+static void __luo_do_subsystems_cancel_calls(struct liveupdate_subsystem *boundary_subsystem)
+{
+	struct liveupdate_subsystem *subsystem;
+
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		if (subsystem == boundary_subsystem)
+			break;
+
+		if (subsystem->ops->cancel) {
+			subsystem->ops->cancel(subsystem,
+					       subsystem->private_data);
+		}
+		subsystem->private_data = 0;
+	}
+}
+
+static void luo_subsystems_retrieve_data_from_fdt(void)
+{
+	struct liveupdate_subsystem *subsystem;
+	int node_offset, prop_len;
+	const void *prop;
+
+	if (!luo_fdt_in)
+		return;
+
+	node_offset = fdt_subnode_offset(luo_fdt_in, 0,
+					 LUO_SUBSYSTEMS_NODE_NAME);
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		prop = fdt_getprop(luo_fdt_in, node_offset,
+				   subsystem->name, &prop_len);
+
+		if (!prop || prop_len != sizeof(u64)) {
+			luo_restore_fail("In FDT node '/%s' can't find property '%s': %s\n",
+					 LUO_SUBSYSTEMS_NODE_NAME,
+					 subsystem->name,
+					 fdt_strerror(node_offset));
+		}
+		memcpy(&subsystem->private_data, prop, sizeof(u64));
+	}
+}
+
+static int luo_subsystems_commit_data_to_fdt(void)
+{
+	struct liveupdate_subsystem *subsystem;
+	int ret, node_offset;
+
+	node_offset = fdt_subnode_offset(luo_fdt_out, 0,
+					 LUO_SUBSYSTEMS_NODE_NAME);
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		ret = fdt_setprop(luo_fdt_out, node_offset, subsystem->name,
+				  &subsystem->private_data, sizeof(u64));
+		if (ret < 0) {
+			pr_err("Failed to set FDT property for subsystem '%s' %s\n",
+			       subsystem->name, fdt_strerror(ret));
+			return -ENOENT;
+		}
+	}
+
+	return 0;
+}
+
 static int luo_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data)
 {
+	int node_offset, prop_len;
+	const void *prop;
+
+	node_offset = fdt_subnode_offset(luo_fdt_in, 0,
+					 LUO_SUBSYSTEMS_NODE_NAME);
+	prop = fdt_getprop(luo_fdt_in, node_offset, h->name, &prop_len);
+	if (!prop || prop_len != sizeof(u64)) {
+		luo_state_read_exit();
+		return -ENOENT;
+	}
+	memcpy(data, prop, sizeof(u64));
+
 	return 0;
 }
 
@@ -121,7 +194,30 @@ static int luo_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data)
  */
 int luo_do_subsystems_prepare_calls(void)
 {
-	return 0;
+	struct liveupdate_subsystem *subsystem;
+	int ret;
+
+	guard(mutex)(&luo_subsystem_list_mutex);
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		if (!subsystem->ops->prepare)
+			continue;
+
+		ret = subsystem->ops->prepare(subsystem,
+					      &subsystem->private_data);
+		if (ret < 0) {
+			pr_err("Subsystem '%s' prepare callback failed [%d]\n",
+			       subsystem->name, ret);
+			__luo_do_subsystems_cancel_calls(subsystem);
+
+			return ret;
+		}
+	}
+
+	ret = luo_subsystems_commit_data_to_fdt();
+	if (ret)
+		__luo_do_subsystems_cancel_calls(NULL);
+
+	return ret;
 }
 
 /**
@@ -139,7 +235,30 @@ int luo_do_subsystems_prepare_calls(void)
  */
 int luo_do_subsystems_freeze_calls(void)
 {
-	return 0;
+	struct liveupdate_subsystem *subsystem;
+	int ret;
+
+	guard(mutex)(&luo_subsystem_list_mutex);
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		if (!subsystem->ops->freeze)
+			continue;
+
+		ret = subsystem->ops->freeze(subsystem,
+					     &subsystem->private_data);
+		if (ret < 0) {
+			pr_err("Subsystem '%s' freeze callback failed [%d]\n",
+			       subsystem->name, ret);
+			__luo_do_subsystems_cancel_calls(subsystem);
+
+			return ret;
+		}
+	}
+
+	ret = luo_subsystems_commit_data_to_fdt();
+	if (ret)
+		__luo_do_subsystems_cancel_calls(NULL);
+
+	return ret;
 }
 
 /**
@@ -150,6 +269,18 @@ int luo_do_subsystems_freeze_calls(void)
  */
 void luo_do_subsystems_finish_calls(void)
 {
+	struct liveupdate_subsystem *subsystem;
+
+	guard(mutex)(&luo_subsystem_list_mutex);
+	luo_subsystems_retrieve_data_from_fdt();
+
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		if (subsystem->ops->finish) {
+			subsystem->ops->finish(subsystem,
+					       subsystem->private_data);
+		}
+		subsystem->private_data = 0;
+	}
 }
 
 /**
@@ -163,6 +294,9 @@ void luo_do_subsystems_finish_calls(void)
  */
 void luo_do_subsystems_cancel_calls(void)
 {
+	guard(mutex)(&luo_subsystem_list_mutex);
+	__luo_do_subsystems_cancel_calls(NULL);
+	luo_subsystems_commit_data_to_fdt();
 }
 
 /**
@@ -285,7 +419,34 @@ int liveupdate_unregister_subsystem(struct liveupdate_subsystem *h)
 	return ret;
 }
 
+/**
+ * liveupdate_get_subsystem_data - Retrieve raw private data for a subsystem
+ * from FDT.
+ * @h:      Pointer to the liveupdate_subsystem structure representing the
+ * subsystem instance. The 'name' field is used to find the property.
+ * @data:   Output pointer where the subsystem's raw private u64 data will be
+ * stored via memcpy.
+ *
+ * Reads the 8-byte data property associated with the subsystem @h->name
+ * directly from the '/subsystems' node within the globally accessible
+ * 'luo_fdt_in' blob. Returns appropriate error codes if inputs are invalid, or
+ * nodes/properties are missing or invalid.
+ *
+ * Return:  0 on success. -ENOENT on error.
+ */
 int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data)
 {
-	return 0;
+	int ret;
+
+	luo_state_read_enter();
+	if (WARN_ON_ONCE(!luo_fdt_in || !liveupdate_state_updated())) {
+		luo_state_read_exit();
+		return -ENOENT;
+	}
+
+	scoped_guard(mutex, &luo_subsystem_list_mutex)
+		ret = luo_get_subsystem_data(h, data);
+	luo_state_read_exit();
+
+	return ret;
 }
-- 
2.51.0.536.g15c5d4f767-goog


