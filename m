Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A51FC5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9DD6B009B; Mon, 24 Aug 2026 22:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166086B009D; Mon, 24 Aug 2026 22:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006EC6B009F; Mon, 24 Aug 2026 22:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD80D6B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:27:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 47A0C802C6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:05 +0000 (UTC)
X-FDA: 85138204410.06.D5D3485
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2B858180005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CvPbScQZ;
	spf=pass (imf16.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3MPEbFoU/QwRqNirYP/g92Fs3Z8hduqFFxsbmsOT820=;
	b=b0H/F9mXMjMvWKmQ93B9k8yqfhufN24yKU8QishFV6mlqe+Kt97T6qIljAwmeOATUVxm8z
	eGW7sPBPJU1XzLZwAMddFziu+J40oF5OAwD0QZVn0wlxq5uwjFzPiNVnJR6Va6E95EOoOU
	4DXdIcb02jBVqwK8bECrzuJj2xBPEUg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CvPbScQZ;
	spf=pass (imf16.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624823;
	b=u8XMIQo+Ghzm3gj0V76FnOqSZpm08UzDTsGyv/22D5jfCk8lH9fNnv9zbxt8yxq/ASpvGe
	vFg+23SStxXYjbIsSDWonXfXOsIQQTrUtPo+vcZEA7F6T07vkA7SYAABc36j7cBqJkD+RM
	IO5lFv6GkNHpp2VFGSf2VEZLbu0cpAA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624823; x=1819160823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xeqgpOGSccYdKjps30e3iCkBlKdPX8jK81YqHCCS7uM=;
  b=CvPbScQZAjxFxTGdo8tqzwPUGh6O+jrhSdOaPCfPIKhLovnuCUT2ig4Q
   6wYDBMVqNXtG7Zi7g8fdOKYOJC6BvF2EvyiG2PQoB7xm1v3W3P72IpBta
   8IoGjtNHLN6t5TQjWmTk+8xT9vPJhBlSS7ySxyQokXbv/1n/c6Y5FcaDb
   WrU5BqSbTm3g5yayIOwb1/IIkx1ewxQ8Ibr3x/u5w9f79g6e8UqSIMiky
   bT9mEkRrZan1s1gUcrj4vNl4VtRHbIMAjXSk59irV670hSagnZ//xzF0p
   +JGfoEYNzuTbPwuG1VGxylXvpeZI/Tda7/0HeUKUtyFKuyiSDWadx262j
   Q==;
X-CSE-ConnectionGUID: I0Z6VgBsQNuM6kvwi1OTJw==
X-CSE-MsgGUID: w3U6Yj/xTC6DNhLd+/RbJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761008"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761008"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:02 -0700
X-CSE-ConnectionGUID: KdGJNJfHR96baGgvXtQVSw==
X-CSE-MsgGUID: 11OofZUFRiO+d4zK+Qn7bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390063"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:26:56 -0700
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
Subject: [PATCH v2 03/13] cxl/hdm: Add function to restore CXL.mem decode
Date: Tue, 25 Aug 2026 04:26:18 +0200
Message-ID: <20260825022628.3651434-4-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B858180005
X-Stat-Signature: 87zo7bpy5z6nzjgz1eoxdb8su9y37mt8
X-Rspam-User: 
X-HE-Tag: 1787624822-178863
X-HE-Meta: U2FsdGVkX18c9MzY+DlCi4EV9DuC2UXTTkyCzgpaxrh6+YTnszDwUo+yJX73aFotfM8kObWtGbCxldfDNJJQxzMQUPPfMez0Pj1PlMYpCmD3EaK1CA7OBwImQX+0wAVi68Vhb9lTd1SyAz3W14+MQJ06jnU3pKqU4Ear0ZSnZm872cFFBJiOPhtNRnjCvchJLQ9JVv2/oaqnZptlJIgh4dDlhMXsOJk0VGuPtqugwED9pvicfQZvoIGDzk9rM7hzmm+yWc2oYxK2+dqla364cC61ASrNUyJi0pq44qSKEjQEC2O1x+kj1zf0xMaWRg3rTpHACrwmbUuJdt35DOqZfQO5gft06YiBHAE5KirEz9DKmHCtpWhozj66JEGuskch6uiS7wQsaNHVmtF0NBNZDswTMN7xqjbhx95EvhcVMvBjry87iB8vH59E33xwfHhgx5kzT713iwSTmfMbcs8ei6okWRCOAb/L82XDgFAJYNVkdlLWU50QLG0rDH/uRdOnfWUQEiW7rg2dJBBWEBbF/b8oIYwXC0ASFLOKSrkjK/hYH1ZQxbPAuRsTb2n9AS5bem7UikO9Z53NHoua10acAnWbfAlP1uMZJeaUVU/GpJiBpgorWHFURAS1ptaSkeNXNbdkmGjMDEwU18nm5ROE4/ied2ALuGi/gB9TovUl9Xz4tL/vJ3Sv4II24BF9NttG3DZ/3uV58v4FtLr8/8pEz2+2+k27k/BrxsS7Wy8kZj3xvJRaFGL7Qocyt7mqDRPpZJoKIieuULP6p8iC5azB+uXYECizZkLS8Bv9F6Dlh3R+TuFkT88MisOxXiYITIsfwJQrzu3fmqTp//eEoz99E5833oqJZX3bx8Wv/V9iRRX6TYKd1xw622d7tHB4BoWI4EhiVk3uZhw5uFe0w3BTv5g6aCTTCWWIRBWtijU1hue51uglg14e48ELz5sENUBkhiEYAa4VsIBU8GU6y49
 o/f2e+k3
 ri/Z91oMr5t5E27kwhTb6LK6CEW1Youu4ZQJ4YYyoT15YZ9u3Y+hjTTihszjAIPKD+BAePAHVFzk098fbH73iVIAb4+ssE/Imy6P0fUnT3opt/YjbWx6kswUwAs078/51ZeD4mkYEFPmWTG56KTkeSVkoPzw436WvOxgaCa6Y86SKM0/7E9Bc+SgFTSVL0ar9Sh8i4homW5xtDK86PIinNu6e8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A reset of a CXL Downstream Port clears HDM Decoder Enable in the CXL HDM
Decoder Global Control register of every endpoint below it, and Mem_Enable
in their DVSEC CXL Control register. Per CXL r4.0 sec 8.2.4.20.2
Table 8-118 a device decodes CXL.mem through the DVSEC range registers
while HDM Decoder Enable is clear, so a decoder committed in that state
does not establish the route, and per sec 8.1.3.2 Table 8-6 a component
with Mem_Enable clear may silently drop all CXL.mem transactions.

Add cxl_endpoint_enable_hdm_decode() to put an endpoint back in HDM decode
before its decoders are committed again. It takes the Global Control value
to enable decode in, since that register also holds Poison On Decode Error
Enable, which the driver does not model and which a read taken after the
reset returns at its default.

Leave alone an endpoint that decodes through the DVSEC ranges rather than
the HDM decoders, either because it has no HDM decoder registers or
because its decoders are emulated from those ranges. Setting HDM Decoder
Enable on such a device moves it off the ranges it is decoding through and
onto decoders that are locked against reprogramming, so it would decode
nothing.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/cxl/core/core.h |  1 +
 drivers/cxl/core/hdm.c  | 52 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 6d536fe7b446..918d48f4422e 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -216,6 +216,7 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm,
 void cxl_enable_hdm(struct cxl_hdm *cxlhdm, u32 global_ctrl);
 int cxl_set_mem_enable(struct cxl_dev_state *cxlds, u16 val);
 int cxl_decoder_recommit(struct cxl_decoder *cxld, u32 ctrl);
+int cxl_endpoint_enable_hdm_decode(struct cxl_memdev *cxlmd, u32 global_ctrl);
 int cxl_port_get_possible_dports(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_FEATURES
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index d55d764895f8..7c898c60f60f 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -920,6 +920,58 @@ int cxl_decoder_recommit(struct cxl_decoder *cxld, u32 ctrl)
 	return 0;
 }
 
+static int __cxl_endpoint_decoder_is_emulated(struct device *dev, void *data)
+{
+	if (!is_endpoint_decoder(dev))
+		return 0;
+
+	return !to_cxl_decoder(dev)->commit;
+}
+
+/* Only the DVSEC setup path leaves ->commit NULL. */
+static bool cxl_endpoint_decoders_are_emulated(struct cxl_port *endpoint)
+{
+	return device_for_each_child(&endpoint->dev, NULL,
+				     __cxl_endpoint_decoder_is_emulated);
+}
+
+/*
+ * Restore CXL.mem decode on @cxlmd before any of its decoders is committed. A
+ * reset clears the endpoint's HDM Decoder Global Control and the DVSEC CXL
+ * Control, and per CXL r4.0 sec 8.2.4.20.2 Table 8-118 a device decodes CXL.mem
+ * with the DVSEC range registers while HDM Decoder Enable is clear. Committing
+ * a decoder in that state does not establish the route. An endpoint with no HDM
+ * decoder registers is driven through the DVSEC ranges and has nothing to
+ * enable. So is an endpoint whose decoders are emulated from those ranges, and
+ * setting HDM Decoder Enable there would switch it to decoders locked against
+ * reprogramming.
+ *
+ * @global_ctrl is the Global Control value to enable decode in. That register
+ * also holds Poison On Decode Error Enable, which the driver does not model, so
+ * the caller supplies the value it saved rather than one read back after the
+ * reset.
+ */
+int cxl_endpoint_enable_hdm_decode(struct cxl_memdev *cxlmd, u32 global_ctrl)
+{
+	struct cxl_port *endpoint = cxlmd->endpoint;
+	struct cxl_hdm *cxlhdm = dev_get_drvdata(&endpoint->dev);
+	int rc;
+
+	if (!cxlhdm || !cxlhdm->regs.hdm_decoder)
+		return 0;
+
+	if (cxl_endpoint_decoders_are_emulated(endpoint))
+		return 0;
+
+	cxl_enable_hdm(cxlhdm, global_ctrl);
+
+	rc = cxl_set_mem_enable(cxlmd->cxlds, PCI_DVSEC_CXL_MEM_ENABLE);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
 static int commit_reap(struct device *dev, void *data)
 {
 	struct cxl_port *port = to_cxl_port(dev->parent);
-- 
2.55.0


