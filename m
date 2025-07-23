Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73790C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B848D6B010B; Wed, 23 Jul 2025 10:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B352A6B010D; Wed, 23 Jul 2025 10:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5186B010E; Wed, 23 Jul 2025 10:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 885A56B010B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C41E111DEA
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:23 +0000 (UTC)
X-FDA: 83695807566.17.6455822
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 89E7A1A0005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b="jQSm/kP2";
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UX19BNUcwB6TjSqCz6om7S5yVRpVe4SwKywfTR0ocE=;
	b=AFagvvCI5OgwbfNozUztGUcLiJdTx6zhaddW2Cn4Te3V0edanjfcWgqNkAb14QSbYLlKoS
	FRod/bu8Zz8LRxV8Ymud0HYGFj4aFzQ5B71pASzoaijmJ3/jQnd/iAY/WaqXilVgOl5BKi
	0GgA2MhGLNQXpJQSNZrgH2jwZ6JejmI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282041; a=rsa-sha256;
	cv=none;
	b=KMUkL0fQ31JTrij8gM3teVRz0qRaiHl95AhH5H9ZUnsrumYH+JfhejoNO9cXMeoyaXE0C0
	IWCPrYDyVsOGfc3DeYyinoT0RkCj/1jBn+s4VPMN6fhWlubixlN0e8pc1hd7FXvpKCClEF
	+K+eGwEu1F2h+bQ6G1xr+EDlNmoCoYc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b="jQSm/kP2";
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-718389fb988so65760787b3.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282040; x=1753886840; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5UX19BNUcwB6TjSqCz6om7S5yVRpVe4SwKywfTR0ocE=;
        b=jQSm/kP2iVgT8Zs7v4ztMZij5nQt8pP4E2zCLUcqa7R7zpzZ50JwG1Ux96rFVGhmpj
         TwAdmNBof826RZpkR+aD4xRQRRuCERtrZGDKTJ5bN8lrlQN916gaSnEi848BG7DvshPK
         vrCfahIkOJYKxL6K7w1SQRv/XRPhInaxNc37JdwNST0LhJ8d/sYrLyfn/8bsVIxqy680
         TOBitFC2EuQvXoduZjo0rLZhOqnHIS5kx591okH5ojDSmQn7mknRyWtnXkafrwl/XAFl
         b5joUuTJqcg82Rvd9MxI7m0h5cPPjHzr6rQ4to7XaGFQBjFmXYLNW00PnguQ+NGP+tRj
         T9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282040; x=1753886840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5UX19BNUcwB6TjSqCz6om7S5yVRpVe4SwKywfTR0ocE=;
        b=jf8L7i2RfX6M9ZR9CDUDpUJ2D9rLF9SVTZ8RpvE9zPCVt5OHHZwu85A+KcIdzArlQN
         5CWnJnQqdfnoS/EgEPrjqR3LSUWxKU9w78FWCqqAEgdWK8Y06FdrIwCEITcS0Ytu27Tb
         J5ryM0vHJw1nDKb9Y3NbhbaH4C8eL6SitHPYo/CQrU5C+XjXFBHNe0Oac2FTaslN3U+J
         /InP0Adt02kHH/uVNrIX3xda8wziMZD9lWKrKN6vrW9jX8D/Wnz7DifBrXJQSRBJsGoa
         AFMMjDjSqLbUoHkp0T9mbasdZeYb+/9LLCWQcuTsJmADpXGy9rBwH3kB8P5Zn8F4pUx+
         fupw==
X-Forwarded-Encrypted: i=1; AJvYcCV7C054xmqEY6pH2WbmtAFTJlhitM1MseHsyFY/iYyK9WqKY6faZBaswB5C/JhX0EoXgFd5qxQ5fg==@kvack.org
X-Gm-Message-State: AOJu0YyZv7yy37AjmtRE4v7QT8/tsdeQARqQYAnb1UCIHPl8cZMwY1ko
	zqlKXum42xhco/kVBToVMWL+mpwfoss7jbF8mS5pKmYhSZidvthRLCjvZwRAQfXsX9Q=
X-Gm-Gg: ASbGnctfslaBld8NM5s/VH9XT/26v7g6sVnJRQcF9ertCHmaUP+9/XoECm0FLXpuZnO
	b5hHOc/WXEGwKsYsPubHJ4fAklXy9g5FkG50Teu2c6HrueeSh5YFyJcW/7pvDx2BTBbtX8TDU+I
	IBWD6M7wEgPatPxkskCuc/YD0EiCKpYcNQLSdiTmDWEODkl59kCfGGrWXTg8Wri6QjClcF1Tfh/
	G6xOJeNtoLSFGjf8i6lv3Uxc0Wy5+05VUNL1OBlQ14O9yORJvow2olwtigY6254jzFCDzXRzehd
	zfeCv2eX51vDbziY/Q3zzCDv1d0lc92V4GOupeTD4RcInS1wSwEiEMSJDGCVICe4v2Q8ea9iEzA
	oI4sebZLDLJYoXdCu00+s5uZM9Xmq5+3Sz5u3aYTBaNmcK00E6ICecgsHRhtUZb68zU966UgRwf
	5cU0CiIdfh8fDpbA==
X-Google-Smtp-Source: AGHT+IHeWCg5lvgS3ayNuzJMHqUh46fT1SJdtuE/GRTZAvZI/FWwWLnu+spwLbexNESx5UBQY3MOUg==
X-Received: by 2002:a05:690c:7202:b0:710:f2a1:fa6 with SMTP id 00721157ae682-719b4335d19mr40934067b3.29.1753282040576;
        Wed, 23 Jul 2025 07:47:20 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:19 -0700 (PDT)
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
	witu@nvidia.com
Subject: [PATCH v2 13/32] liveupdate: luo_subsystems: implement subsystem callbacks
Date: Wed, 23 Jul 2025 14:46:26 +0000
Message-ID: <20250723144649.1696299-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89E7A1A0005
X-Stat-Signature: 77opgbjcqj9bf3pgqc19yecuzyibtkr7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753282041-662751
X-HE-Meta: U2FsdGVkX18Rli2ZY9rer7r349sF8drJ2ka6Te7WBBgRRH/9dNeecZg9wTudWxaZM4LHf8PdC7erWOdWX9Sj5alHqyY0oK4SZAr7CLZEUBUyPdTs0JvK3xMImV/cLgpIZMs2DZQ8DFGHK/LjiDYTrzMpOAZZROwoR4+ytwehrUn08JqrumqhlyXqKq1ojbWyxc12aczub05ne3sXqXlRDu+mVFoHnJ3fGRU4YXP4n1odhyjiS7F+ia6XPe9N4Mf8Wi0FX4G0asp5cEbCeFQrlu9lSJCurssbkpG8Xykyma6NImiyaW9A7yJ1itvY2smzPfc5pqB/bWNOKCiz7bLAMA8+7edn1foTnA4fqlfKy9pPwN/tBY/ThlgtcdPqzRkPI5HmDI3EqXfeKzYpsNoovmtYXTkRsgp11fYgW7SyHOKdAW5GLB/UvG5wqxQ0s4K3lOOhc6zw53Nmg2iuSyWd0k6VCojBjs+QcRBYzpfLR0eyOt6aWMmECVEKwrmhg6gkxyA1fuNbW1XMTfus5+4yi/3WlDsYuNqjYHR3UUP847C/hv2zTBmNQCw01rFqNRm/gqDacHlSS/p4EEkqbxLpjukQYvEmTHmvMwn2u2yMsnIrWwL6K4efKONNAr/pFeRk9JH1LM/bnMwhFFSdMmQjhH4WxV45PbbeGfQTeE1d1i9g5ajS5/mAnrj+KNUxpjvMWDpOXCGK7MVkKkmwBsdekxKk0v4nENH6mQ66djigwKekbnhHkx4+h1yYo1NBaVAwi1PtFs5lc950hMitDRmoAALZJ6gNgNFwgCO5TWInGjk4qaNaDCjZUXoynRtQpVsAdXJg3zNk0LigLQ1geWxS0RCgUGvdB6tEMmEOjhuhvDgLYfPWqaNehrMNhcxr/jdVEjxnN2kgYqflMQHbtS73cAb/9azCqqBkyrY6DinScKfVrEiTXVSdQsAhidKWzNHl///JEo+LGVj91vB1ZsY
 sn8r1JyZ
 KguYVpbklj23wcFVU3pxn8XPD4oBQWmAq2MD9oPDwDjrharpslHFlozwp83QRuxeu8Na7u733RZx6EVUbJ3JpuJqpf9SD9X3VGduga2CqwDNrbeuoSCGza0KNh3Dvmr0KlOqH5p2vCsTTLFyoQz55joo+LoZ5yf7oueaC0PzbRHgnpwnSri/LBMxnMngzbDUdF9DcrCo8p04L0SJ9VsqWgyQFVIvZMM9YLpn42rohJ5M8KG5j5ag9mjhXc2DgEJWUAwe8OeQcHDq/D4AyZP14BmIywXC1uI/DtXblrGeXjZyxoKkWBXnbgK+J+QDBbV9bAOw9a92VitdWWlceHDE4fUValGVEKIFX/Kf7aSSyD0/y8F7B94XYf+Z+6ilDhDLSEICWF9G0xUey970ZLrUb3MgWZRg9Aseji/azr050o9uMyMmkY2QeO3H4CiYVMKWNMnBE5YJJIdmYmuxR+2FSQlQaKh1g9rn0CH6b62qPfvVKiKS2qCSw+8l5NixapTnnn0F16FXVV3v9LeTso4lSz+f+t2sGpoowaQUAlz1M5/f9oZ8MSu9EMDX4qgK5uQFeAcXes/GeO27mm74=
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
 kernel/liveupdate/luo_subsystems.c | 140 ++++++++++++++++++++++++++++-
 1 file changed, 138 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_subsystems.c b/kernel/liveupdate/luo_subsystems.c
index 436929a17de0..0e0070d01584 100644
--- a/kernel/liveupdate/luo_subsystems.c
+++ b/kernel/liveupdate/luo_subsystems.c
@@ -99,6 +99,66 @@ void __init luo_subsystems_startup(void *fdt)
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
+			subsystem->ops->cancel(subsystem->arg,
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
+			panic("In FDT node '/%s' can't find property '%s': %s\n",
+			      LUO_SUBSYSTEMS_NODE_NAME, subsystem->name,
+			      fdt_strerror(node_offset));
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
 /**
  * luo_do_subsystems_prepare_calls - Calls prepare callbacks and updates FDT
  * if all prepares succeed. Handles cancellation on failure.
@@ -114,7 +174,29 @@ void __init luo_subsystems_startup(void *fdt)
  */
 int luo_do_subsystems_prepare_calls(void)
 {
-	return 0;
+	struct liveupdate_subsystem *subsystem;
+	int ret;
+
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		if (!subsystem->ops->prepare)
+			continue;
+
+		ret = subsystem->ops->prepare(subsystem->arg,
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
@@ -132,7 +214,29 @@ int luo_do_subsystems_prepare_calls(void)
  */
 int luo_do_subsystems_freeze_calls(void)
 {
-	return 0;
+	struct liveupdate_subsystem *subsystem;
+	int ret;
+
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		if (!subsystem->ops->freeze)
+			continue;
+
+		ret = subsystem->ops->freeze(subsystem->arg,
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
@@ -143,6 +247,17 @@ int luo_do_subsystems_freeze_calls(void)
  */
 void luo_do_subsystems_finish_calls(void)
 {
+	struct liveupdate_subsystem *subsystem;
+
+	luo_subsystems_retrieve_data_from_fdt();
+
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		if (subsystem->ops->finish) {
+			subsystem->ops->finish(subsystem->arg,
+					       subsystem->private_data);
+		}
+		subsystem->private_data = 0;
+	}
 }
 
 /**
@@ -156,6 +271,8 @@ void luo_do_subsystems_finish_calls(void)
  */
 void luo_do_subsystems_cancel_calls(void)
 {
+	__luo_do_subsystems_cancel_calls(NULL);
+	luo_subsystems_commit_data_to_fdt();
 }
 
 /**
@@ -279,6 +396,25 @@ EXPORT_SYMBOL_GPL(liveupdate_unregister_subsystem);
  */
 int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data)
 {
+	int node_offset, prop_len;
+	const void *prop;
+
+	luo_state_read_enter();
+	if (WARN_ON_ONCE(!luo_fdt_in || !liveupdate_state_updated())) {
+		luo_state_read_exit();
+		return -ENOENT;
+	}
+
+	node_offset = fdt_subnode_offset(luo_fdt_in, 0,
+					 LUO_SUBSYSTEMS_NODE_NAME);
+	prop = fdt_getprop(luo_fdt_in, node_offset, h->name, &prop_len);
+	if (!prop || prop_len != sizeof(u64)) {
+		luo_state_read_exit();
+		return -ENOENT;
+	}
+	memcpy(data, prop, sizeof(u64));
+	luo_state_read_exit();
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(liveupdate_get_subsystem_data);
-- 
2.50.0.727.gbf7dc18ff4-goog


