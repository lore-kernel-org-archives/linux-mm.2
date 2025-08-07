Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A1FC87FDA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C511E6B00A5; Wed,  6 Aug 2025 21:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C289C6B00A6; Wed,  6 Aug 2025 21:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17426B00A7; Wed,  6 Aug 2025 21:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A5DA16B00A5
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 329E1BB964
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:09 +0000 (UTC)
X-FDA: 83748268338.18.7088128
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 69C37100006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XnFfVXun;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2OTaXTT6jQmKJ4PUph7LgRVFyALKuwMGjifm+qkQzqU=;
	b=wdEbsjtoLa9GbJ33EEX3m8hzGwTYt/Tod0LgvDANz1bLVAgwfnUE9GhIUb1cAmUQTTD8m9
	qLDRfz5uj9SfTlf63uwK4EcoV6zGXstr8BT1kxTbcFrN5YqUoJmMHpA8UgZTtYMAy8yGzJ
	GSrme0XOXIY1GlnRy8x2lXVRIMva1Nc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XnFfVXun;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531107; a=rsa-sha256;
	cv=none;
	b=iRtScWD8Xv7POrrT/RFheDTxSAGVOmhp1ZvldozPYS4bmL/a13gpCADgqvZc7KsiwWnHQK
	lTN8Ik/Ms0gWkr1kiGVBOIq8JTdVATAgwhSoUduzpRrvOC2lM1W0uszxENrCa51WweBWNb
	HWv/y/iLrp0N27WLOSNyt2dRNQFj/R8=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-704c5464aecso6152306d6.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531106; x=1755135906; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2OTaXTT6jQmKJ4PUph7LgRVFyALKuwMGjifm+qkQzqU=;
        b=XnFfVXunVBg3F+4tbOSGNfAUeUnznC5oUB1YrKALTPYclzBYbn9+NXa4fjV8+lZlFX
         FvYkiID0rOrOrNZ/yaXaUY3nPHVEDmW+dMC3a6nFgTOe9rADyAUtfQdLf3/VZhc7/lX5
         Gxe0wOquX5L3DWYonEOkzJQfjtQo/F04pI1t/PZSm44SX1KPp9Di3OiZSI2Dx8okYHAU
         8fHX1H/WZY79dMh3wNldct34LSdM09oPwfSHI0prDSF/Wh3GAiTLVwEpeqKZsU2DPIV7
         hnP5tvrOY6s+k8zDxQN+h/kGblZI6Mxmg489Av7F61uuEk+lROfOfl86t8qcCoJkv5Rx
         szig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531106; x=1755135906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2OTaXTT6jQmKJ4PUph7LgRVFyALKuwMGjifm+qkQzqU=;
        b=piim3VqY2x5siYTEiHC4AEh0xoq6boHSx7W5XWQJw3BmUqk/TS55dbLRGQ+Cuyyi89
         ZNeF4JAaIm4n8lTLpuFGCNUXcStjSmh4CIc7ZYZiEurU1hvMGvzEpOv2Z27k4zIKO7du
         sm+hbTLwstnMU6USdvAuuN//58nbmt+k2wS8tw8o5ho/xCL7lgyKlKrY/vR0IirktXr7
         uezgwGtouLrTw+Z3+Vn68+9VKWkU8FtkpB7XIGOESO3IoYNRST7S9UsRP/SHKaWv5+ZP
         JDtR5hGxWjrdJcrumgLfzCvmTyIzX80SVpPEJtCyaDiiGWbxz95GFccYf9RoYsu8sUVP
         qIpA==
X-Forwarded-Encrypted: i=1; AJvYcCWZkfOZC6l5f/G+VoNRBrO0fz27n7nn9uyTxcVR0/joNqWIgIXGhr3HkmdqfOJv8mPQO+k2okeAig==@kvack.org
X-Gm-Message-State: AOJu0YzaZHkTMUEyYL2wDLt3HWklQbm52cc2KMsNJZZl5WPNA7tzdQWb
	O5Pq0YYaatHl/5Ct3mgUY0rQut4IBGcxTRTPomJuJ9oxOcw0H6IRIPQVOYsl0PhJFOo=
X-Gm-Gg: ASbGncvNbJ1TYrac4hnYo2p0QgIAwjnnwbl1MZZrjYxcMh9rRg/3xgirpkDs65z4zmR
	brZpY0yzhLuZQWXajlBiF0s/iG5IP+tGOLJCBaz56ukIuZ9zPKW1YSvhNgN1EpbNC7az9byaypT
	lM11r8G+45CK/0IYyiOMNYKEe9k22vwOYEFRBXgbOP1K/44NNIkCdrcmVebi8qIv9ei1H7wyuGS
	tPp6B1tJbYe3lz1O2P7OSDRJ0e1mJzFr5mvjj+XSH0al3hAsIqTKmU3F3X1KgudanjXJVbiriGV
	+5dZ33on7R7xnyL22dKZkrhX0/2gJSOoBSlaM8mzpID7A98fIeaK7TTFS05RbzKTZS4NAIXT+Ea
	iZW1YAfkA+4TguLbojzGeT1OHAlg7qw+CnZrXBSaPUUS+X0jNnPjyHeX5G0AT2selb1tChVhB3o
	sALXg2Hd1+S8V3
X-Google-Smtp-Source: AGHT+IHkVV1gJ/eLfgNhdc15SxnB7MFyTZ6hI7y1/NB5UoxH3EhPIvvoxDJur8yfTZfudJtjwPns5g==
X-Received: by 2002:a05:6214:482:b0:707:45dc:c36 with SMTP id 6a1803df08f44-709795f4f3amr75094366d6.29.1754531106352;
        Wed, 06 Aug 2025 18:45:06 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:05 -0700 (PDT)
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
Subject: [PATCH v3 13/30] liveupdate: luo_subsystems: implement subsystem callbacks
Date: Thu,  7 Aug 2025 01:44:19 +0000
Message-ID: <20250807014442.3829950-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kj4iw5qrreu1q7he3usexwqxcr4o8p73
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69C37100006
X-Rspam-User: 
X-HE-Tag: 1754531107-870784
X-HE-Meta: U2FsdGVkX1/fSqJ96YPmhW4BDPkewqhgfHn2f6W2UARh118mxctkQZHEMNZ9Svtf3e3Fl8S605ZNJfXT6CFulOHXgLod4bgobQzV3Da3VFG845peP3e2VA48MgasmaIipVtpj5Ry5bwV9MCb3TLbTbw9fdz7JlTi3LsSVpbiPfvVmVFMxI8WIPqGXwqXLu3qkymiyLlZWKtvEKGIPDvFB9wIOYPvS/g7GAmd6BwPe6zzG7y+9NIQDmHbpdPT4KEipRAWmmvwUOhJwMLh0UWawdwklP/k8hZkESDDxbn4EoGN0oLau+araRdbvG3XxDB4d/KHkNMGFzD629TTYY/lY4Ox+D3QNHOb+mJuj0vBfd8VaAgrUdwyYO9HjRt2Al7Vij9TnElhIaqU3eMffLyxu8RSeQBsUyNAUh2Xx2mn4FWXAlMkhLzxx6aE1uvp18rVq61T3r1vpfU5Bso4JgV1fQf6Bx08tYIHEJbjZXx2+yjhUE21wRjH11FSZmAtzZ/mxXwrYTcVmcSpoNICpHet9PnJ/apKgCZsucTJbI0sp/OatFjEik9nFR2yUpyYuslPslx86xo9AT550mogmDzF2SJYW2/rs1KI5lNrj0gUq8bJhl+qV9Paek8t6iUZhqHLHF70zufKA3K97M24eBsF/88lYqUmDwWqh96ys+oTN/tjdmlaTFTkzA2yAHSnF8EHvGPX+FciP0+9FeAfRSOay6zJi97IHdjCZmILLJfU03fCGCqlQe/b4XN778lyNXcMnllHE9WctvcNtvTRIwkwFySJOf3Ogslo5/v/ujH818YxCK/6FrLkzRCBSgoFbStEYW8Sw4RXBdJgHLhzGGBqR60E5efqfZvhZ7A+lSsPn77m4VHGENpB+TfCFCPvfkapm+Pt8FZ9/gpwGHOVvdi0dcB6N3a6fIjvMhn+T3o9TiRrT131OFHLLRzm4ykV9b7DHQWFm551GbcU7xpE6IB
 QZJ5vYDq
 U2hisin42aCT2u971GrAPU+7LmiZ+49g55dYtS8D7qlw8NqyGzgZqgkYRytSCGh5lsyyCBcAaC6nth+3HCZDxNLCX9zJjurEKHxS1piYviZQxuD/Hue0y5mds1PW7FAmNsrgu9bN5W9PEJR/Gq5lTRNCzWGCQXxnwMqta+0v0ge1Pyq928/pNXapyKxkH8FwrP2ifGSPYs+CGnZEWa9MZEgkNrcpkl5OEo5Ann2WyxQxbQc5sNyuHWxq4yb2pAHsoosVZi5td5r+xexskYQyUpT6J9RecR7YJF02Da/Y4NsueR6QH4e1YP6I8GxFt9ZZwk8hNfPcImEsqtUJJ/OzsR6XPCJxAS4h9KLj9PuIQy//byUpykbkF2P951N/pPGkTuh/ozdY+VQMInQboX5Zm4c573JjOCU1xHyxMzayWlLA/vSSAo5skjGampOFb2SAREqk3r55Jgb6GNPoRJZv698Tmrwcm/L43UN+NNSrT9NYIwpw=
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
2.50.1.565.gc32cd1483b-goog


