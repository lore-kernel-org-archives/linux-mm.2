Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183B3606A332
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XcjiUnC+
Received: by kanga.kvack.org (Postfix)
	id 311C96B05B3; Fri, 27 Nov 2026 07:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9506B05B4; Fri, 27 Nov 2026 07:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226D36B05B5; Fri, 27 Nov 2026 07:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF65A6B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:25:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0B2E1C292A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:25:52 +0000 (UTC)
X-FDA: 85480820544.20.83ADE9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 41BE61C000D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:25:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcjiUnC+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795782351;
	b=sN2w8lVyR4DEZvT3g/E0ez7HkIQ9IWLeWO5Ay9BnpICAiw/ftY7H03L9VpTDjt69R42cWu
	yTda+xSpf1JQp6YxPeRk0M1sgKokNmsIAwDKJu11Jhz/Kj6RqnX94SV11Fo7/ZXmEHQaqY
	vF09JFw0kYybQ89dbNypVv0+z0QdYiY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795782351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0qu0j6AmOnocb4ErsG1/P7x86Ov3PdyD2eIAJ7Q9CI=;
	b=ne+TKn5gdZcYRMYpyrbuoihg1ubwmq+A1bhwQQmbZvZCOhV1gtH7P2t/1OdLYbqRbwIXct
	D70Yv0TS3xFArttoo4hFfzIN8THf3SMzv+egbA/EM+5fW1QxKrhceMU3KdrHsfPsy/TTq5
	zruNTsZ+hZnefH0DsCQ59B6Ms6ew6Ac=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcjiUnC+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD1E6621F5;
	Fri, 27 Nov 2026 12:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CEE1F0089A;
	Fri, 27 Nov 2026 12:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782350;
	bh=a0qu0j6AmOnocb4ErsG1/P7x86Ov3PdyD2eIAJ7Q9CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcjiUnC+QzW1+A5q+f0vI+yQYATvfZE3rf+/VClnaksrClJRA0VBOqNUxEFicVdAO
	 Xowu3GA9Xxw1sQ5V2Q3Pqd7gy6qqh5ePMP/Vv3jRF2bdQ2bfVMfFIQnwhQ9V7IlXBX
	 ZAPjUnFKFmFoAIAk/cza7ql5yzSaEa4Xw7zeiTxVpYKgN9WfOzODcvW28KstEe5yQz
	 9zqoCOZdGaipyqB97hbfWemWwSggmOFhvhGIlMIW5zeIFtV7xn47pGJ8UxEA50LdBx
	 Dl23WXcx4qmnaGRNVdfYSMZwNeMmsbUB7+jH32gQj42UlCl9eiYwNCxJ8VyaP2WXxC
	 ARwmGerIkA2iQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Matlack <dmatlack@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 1/6] kho: build KHO objects into a single kho.o
Date: Fri, 27 Nov 2026 12:25:27 +0000
Message-ID: <20261127122536.3708770-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <20261127122536.3708770-1-pratyush@kernel.org>
References: <20261127122536.3708770-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 41BE61C000D
X-Stat-Signature: 8mdh6u1xp3q8e4ux7rccadxerbohjp89
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795782351-539011
X-HE-Meta: U2FsdGVkX183ySv//r4Qz28e04+UGYjCXd8q7k6DHXppxFUQLLuuv4Nvq6trq20ysXvDpeBy9delaQU4YNZ40fdHKirBqctcigzEWA3xv88qAwthRj7hfoOimyxbl9LP8di/73OYpqpH7pAk1vZGfWFtod44KlzN4HlEl/id5O2AVDEKvy3n+wykM+A0qMElZ+g002pVnhNByoSUA5hnZiUVRgJQ72IRnBnaPGxZeLmtJSIsGVe4lR8I0W38q21FXZ1fdO5DewFtZxginZ9JDje1gZSyPZGXwiez9FjkWOt5fqe6y7XeDBiEiLpKFuZ6KG2+RaiJsdX5SOzHY2ILN9msdjDlho9WKBABRc9XolG13oyvn0a3yFFaJM7KvFdpyodJfw1Ui1JKgUxv+mxWLVaulJbT0moe7S0SiDzfJPJsGs0Co1bn71yPXNSgfU/B0zKMfGWX4tkp/mUSGNghOASlTFOrkwNEbvBkS8W/WeOfoZ0PQD4eu4MXtsTytyOUDzPt2Lzio86I3Gf+dROOXNirvERbMuUFhcFlep8pGBUIKoq3RZNB/CDijDbdn+GW/YKwBgyYaHwpMhPz53Kc7+bSRmFQlN1iNhEhSXw1YxIXHsZYWtZ3HT9xu/9xkPn866fW5UCOPr//D72Qswpv3AGAOMSWA6yOXbIaNhLmlH4luS16bHOt6tW+/6n7CdKFUuQdcwwxEErpyUMxRgxiqkpS0xJwdJTW+SWX5evkHwAWbSLowI4pCpCqPE1IazxDqt+c1/XosONGSo4Kk/2KCMBnLP8zpUJ7IpiIujAue1Er0km6hq4HOB1neU0lpISYnXNwrEnOg8RSnJS/XeGPJXOoeWRl9Y4pPxmA1VWmibHakAHJtF8pOyW1VNvbeTlarcZgKVMunk9hzd7k5VUpZgH/X0oiudF1bfo6EdmYAGVdULKjNrsd0duijZ+UBcZsy6/NgoB1NmcM+tTjfM4
 LhQcp6gq
 Uo1GRkR+uqixcNA9QCkd9369hgcxeS0Hgmvq/fFfLtsS2ciSO/DM+CZmf2d14CeN3BkVECTp+Lfofb5Ow0/MYywQ45m0DfxCgbrPi0tZVNihv5rpkQAn5lQZbFyBuxcYaeIZgz+skLVy72k55Z9MovWQgOAlsF0+ORgogZ5xpRCARRavZUNG4BO9bMTd0q6ng+EtSYZ4cGuGzdOFFXwjzNd6WABMW5o4B88Wd7lL4m9KfynWtb1fnEpvwB+/yTIldikdV9u9LP3KJZF7V6KP+JtX7BZ8jL2zKNfHu3HLn5+ntXBR3VBN7IjNvALdiSAzEBG7ZmXStYAsBIletPqOLqTLJYRsWf627eEfHV2TU3MXe4RApG6fBt94eXxy8wWKGjQAtmbbp7xnO0/VoRHhoyuTkSvKm2zLwn2I2PJdSlAiCa4gyR7YCN6V2LsB0sxPBp6aIyczOaXwADdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

kho_block.o is part of the KHO infrastructure, but is currently built as
part of luo.o, which ties it to CONFIG_LIVEUPDATE.

Group all KHO objects into a composite kho.o, built for
CONFIG_KEXEC_HANDOVER, the same way the LUO objects are grouped into
luo.o. This also gives a single place to add new KHO objects.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/Makefile | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index d9f469462556..bc679905ce3f 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,13 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0
 
+kho-y :=								\
+		kexec_handover.o				\
+		kho_block.o
+
+kho-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
+
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kho.o
+
 luo-y :=								\
-		kho_block.o						\
 		luo_core.o						\
 		luo_file.o						\
 		luo_flb.o						\
 		luo_session.o
 
-obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
-
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
-- 
2.56.1.839.g22a8290db9-goog


