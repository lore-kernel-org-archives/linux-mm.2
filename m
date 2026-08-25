Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52ED1C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582C36B0092; Mon, 24 Aug 2026 22:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55AD76B0095; Mon, 24 Aug 2026 22:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449876B0096; Mon, 24 Aug 2026 22:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4146B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:26:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55DA6802CC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:26:51 +0000 (UTC)
X-FDA: 85138203822.21.5303294
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id E7606180005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:26:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cws/Av2W";
	spf=pass (imf16.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJzASNNSG+QiH++4gzj7pnCDSF9TUeGXmyxhBzuXNVY=;
	b=OBHDp7sO72tRQGV4jO42FkV3VLjOH7LAF7Xlc8mLkrX/cBqyhtG7wPDTBWkrIwDjPtVW7n
	89xyhoN6Yyttq9kDXNy4wSrdlGIFCJSOAsu8WoIBoN5/uDjWI3bzHpT3tE/4Zn0Juy0RNX
	+EVKh4nRDGuTMv/8KbROZuW1V/4eHyY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cws/Av2W";
	spf=pass (imf16.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624809;
	b=dBSd++zCvNAO8LlYOaHr9DQpw5qbgfmUtCFChgdimY9xsL9G3t9oU1AbYymkhBqLFsnxBi
	9yrQwOt85OaRF7P04lX4Pgi2U9bMrR79bJuvwDMDp8nP7JKPyvoBzVTCMCfinl6JcZU+ur
	10wDAY4vjlvAokwdwhPgRmVIoYYlvEE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624809; x=1819160809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tsn1ZiUbzdaF4vYy7trPOo26c92bIqiH3qklxnc8dFw=;
  b=cws/Av2WPClSWzPL4v4fYeHeCbr1o9Kemr0aWZEZV2EBY5WkkE0fcfXV
   N3lymV+zyYxlZlt/2GkAZCZq2sQa32cJWCqdnb4oZ5sUNHuQ49fjTOt8j
   wH+khob8Aq/gf0/wZ48Rdul7hgQ3meI4fNXCDTxTApSxyAHP7SpbqXvKV
   3YJ8hmf79vf3IcZNhE4hWJGZehwlnd4OGR6GYmB4lvEVgFDNLmj2u3//r
   EmLJWaBZA9VIBbbHnG93hmF4zDJg9qZdJ4HsFUL5eEi1kXccAm5+/yD+K
   Rbgtyb3zNKNqjmSG+mwm6LhaANShvpr+2biG/IJlQHFwJN/MQhZiuKiI8
   w==;
X-CSE-ConnectionGUID: pOn1CBQERRuFS6BOM3sePw==
X-CSE-MsgGUID: gZtn94d9TfixzNT1RSysHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98760941"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98760941"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:26:48 -0700
X-CSE-ConnectionGUID: lF9tHVnlTmmDi5NsgwZhEQ==
X-CSE-MsgGUID: NWBh33+kSD+0V6l964YYkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390038"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:26:42 -0700
From: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
To: linux-cxl@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Oliver O'Halloran <oohall@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Subject: [PATCH v2 01/13] cxl/pci: Make the HDM and Mem_Enable writes callable from CXL
Date: Tue, 25 Aug 2026 04:26:16 +0200
Message-ID: <20260825022628.3651434-2-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7606180005
X-Stat-Signature: wm3xmjm3i1f471mch9b5a4gaghbg94xf
X-Rspam-User: 
X-HE-Tag: 1787624808-605881
X-HE-Meta: U2FsdGVkX1/JF8nPHfK9Fn6QZSxhpDbtmNmVrCK2xhGAtoUwID6iOcauLt3SgtYOCcixASv0SWe3Zt4vXtFcCGhjH+670ldKCnDJ1OKwY7KVhGnjSYMZYNaOWQfxmMX5vxf59f/rYsvTea4pOxYs1L9Ah3+THLnWmZJe8bHP2qFLvR6PtYqnB1GboT7VWFSqJDeMp/4UJ9wut/8tJgNO2VUcuU2+NobOhgLMTvfmCHgOyXkGzaVTLyG9iNlECoibUxC02iiGEkpTph/5+shHPJ2gkgaQ3PAQR0LsVT9Hc8331tOvpOa+aVaOkciVeQyM0fcWam+X82v+y2/Fqfuvyj3iqmIAlgpytyaEIHrKftzsoVIDlIdeqzHqZtQck8VSGQGb52bNPiqk9mLvtvLijHUbYT2TFEzOQi6yHvhUrFE21mXJOCxtqr7nynOpi5Jjy/vcaX9mwpalniBDkLsk5H9kMFSGle5svdJ96LhIa9jKTQ6U2Tf92ieWB02/TXvBTBZ+XckMPD7mbpQF/hDBK0Z3W385XSg15DVruHCXmBnje8RfYcT36s3o59JdnCCQ+JKVqsuTEnfvKf894pHwwGuWyG3hGfEqkULfi+qyzBD5Y8GghBEGD0q0XyOubf/AhsVYLxpnSp1qJbY5E4CBQNY+CrOaG0ZpDiN8+uzxshaCoNX01k1YvSPLd/zGs/NCa8tknqmTE3LKy64mxp9U51dBp8rfekaQmVNJ6GwOkkkcwMEhOLIEUNqDbjhuj5lj8vdBOiVwESvjKSUk9h6hZut1t0DstmoqG5lTzLN6XLWrq2MGdn0SfCyzmnXplo49KgDIXDs0H63PWo3OmUUuZ/yfxARZ9dqolZCt4sQL9/6Gc/cGXdxQlwU3MXh8k2GvwcLnua4Df3ntniH5wVrnTbG/AR5FcXZdOvAUKySjy+j+ZVUcRGuh9/AyAYHC1SEcV6oo8mnnpfG42HzOcvS
 gHVmJQ/t
 cVBcJIEL9KnszDbQxx2iK9y/7qgnFQn9Ysp+UJnYur/yWtXdi0M2t3LUg0K13orlf4ciEta2b0IFQFjfqS+P198/IgbXwvHs2moJ9nsISK3VlIJoJucc6dR22KI6xzbkrUh57QVXC3Zf9GbUPZXuSjTJBohrJcOtSHibdAKunZXGTc32MyeZnWniFvMM/xkZbHm3pG5Ak5EKFO0WAbSTaORjBqjyXxi3wbO1W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split the Global Control write out of devm_cxl_enable_hdm() as
cxl_enable_hdm() and drop the static from cxl_set_mem_enable(), so both
are reachable from the rest of cxl_core. Declare them in core.h.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/cxl/core/core.h |  2 ++
 drivers/cxl/core/pci.c  | 19 ++++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 07555ae63859..4dc324f019ab 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -213,6 +213,8 @@ int cxl_gpf_port_setup(struct cxl_dport *dport);
 struct cxl_hdm;
 int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm,
 			struct cxl_endpoint_dvsec_info *info);
+void cxl_enable_hdm(struct cxl_hdm *cxlhdm, u32 global_ctrl);
+int cxl_set_mem_enable(struct cxl_dev_state *cxlds, u16 val);
 int cxl_port_get_possible_dports(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_FEATURES
diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index e4338fd7e01b..a7a2b84293e9 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -179,7 +179,7 @@ int cxl_await_media_ready(struct cxl_dev_state *cxlds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_await_media_ready, "CXL");
 
-static int cxl_set_mem_enable(struct cxl_dev_state *cxlds, u16 val)
+int cxl_set_mem_enable(struct cxl_dev_state *cxlds, u16 val)
 {
 	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
 	int d = cxlds->cxl_dvsec;
@@ -247,14 +247,23 @@ static void disable_hdm(void *_cxlhdm)
 	       hdm + CXL_HDM_DECODER_CTRL_OFFSET);
 }
 
-static int devm_cxl_enable_hdm(struct device *host, struct cxl_hdm *cxlhdm)
+/*
+ * @global_ctrl is the CXL HDM Decoder Global Control value to enable decode in.
+ * A caller restoring decode after a reset passes the value it saved, so the
+ * fields the driver does not model are not left at their reset defaults.
+ */
+void cxl_enable_hdm(struct cxl_hdm *cxlhdm, u32 global_ctrl)
 {
 	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
-	u32 global_ctrl;
 
-	global_ctrl = readl(hdm + CXL_HDM_DECODER_CTRL_OFFSET);
 	writel(global_ctrl | CXL_HDM_DECODER_ENABLE,
 	       hdm + CXL_HDM_DECODER_CTRL_OFFSET);
+}
+
+static int devm_cxl_enable_hdm(struct device *host, struct cxl_hdm *cxlhdm,
+			       u32 global_ctrl)
+{
+	cxl_enable_hdm(cxlhdm, global_ctrl);
 
 	return devm_add_action_or_reset(host, disable_hdm, cxlhdm);
 }
@@ -398,7 +407,7 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm,
 	 * enable and use the HDM Decoder Capability registers.
 	 */
 	if (!info->mem_enabled) {
-		rc = devm_cxl_enable_hdm(&port->dev, cxlhdm);
+		rc = devm_cxl_enable_hdm(&port->dev, cxlhdm, global_ctrl);
 		if (rc)
 			return rc;
 
-- 
2.55.0


