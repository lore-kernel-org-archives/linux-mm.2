Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F3DDC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B87F6B009F; Mon, 24 Aug 2026 22:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8718E6B00A0; Mon, 24 Aug 2026 22:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730FF6B00A1; Mon, 24 Aug 2026 22:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46AB96B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:27:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1B081602EE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:13 +0000 (UTC)
X-FDA: 85138204746.19.49D60EF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 714EC40006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZbYkxebs;
	spf=pass (imf17.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624831;
	b=OcO5LawY7o5gDt80T/FeaFM64RnWC+RQOovJNkeWy4d7M1FTPLjqgIjlmpvcoMFRr9Gkqq
	XkVwo7Oih0oG5PPfvdAV6C0mznx7+iQf8v2eISGbH52j2m8dUlGY6TYX38DtP/vAuORC3J
	VZEGOvafone0qRmeRaOER/LAk3VusOA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZbYkxebs;
	spf=pass (imf17.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOMXKg/TRFAQwZN8iLI70CGvUSAg9Be05TscCoQUGnc=;
	b=BLqc2GQPVXGntpOc9mC2TDzdOqd9r5tjJ4RoS5CxQDeSJvctXr3UyOq+ASG5q0hRT56OeF
	mya2pmZ3peHPWwPCyuKqIyogeAF825/ZPL+vY+qfO18skKm+BrfgexWr0S9sI8zdWkjlqE
	eZaNjzjJguKyfPsIjhkhQqYNXa8AkBw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624831; x=1819160831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ATpZzu8Vy3mrvuWJAxBs17Ttm0WSL3jWKLIUyOQOXaY=;
  b=ZbYkxebs7WDWpSb29PL53B5eBTede1nZz4qGHruw9aGRYAQhRmMI9/lh
   6f/1PVh2zeT8+dDz1YsGpdxHW7yDpUc+XzuuGHHi4lsaruI+mT+T5huJY
   CMEFk7LqR72JluQH3Ws5lA3dHqK1+0EGRHhcSkqQp7gRxmJZl67/pNL5V
   Ji7HeipgD7zjOKzH0SmgH48cA90rpbcEO9429dCfXg4G8klfBSWEduqot
   Pq8NqR8++6hK6r6xKwK6/qBofQzgegMXJnRAYLWW5We04lNNeOSDs8FQY
   +y9hnYFvXxJ4M6SRHjfpwn5pHpC+/EGl8yOXIs3N7fH1lxjRo37VPmaet
   A==;
X-CSE-ConnectionGUID: GOWLPJGzTNObuFDPb+Os+g==
X-CSE-MsgGUID: TLu/zOIpSNywZCX6q4C87w==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761056"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761056"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:10 -0700
X-CSE-ConnectionGUID: ugoWISdgSaGMgMluv/yZLw==
X-CSE-MsgGUID: uF8urxNwSMmug8tcxs3lvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390078"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:03 -0700
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
Subject: [PATCH v2 04/13] cxl/hdm: Reprogram the HDM Decoders below a CXL Port
Date: Tue, 25 Aug 2026 04:26:19 +0200
Message-ID: <20260825022628.3651434-5-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 714EC40006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: uh6g9z9y5utan5cwqpy6pgaqfuszrd6g
X-HE-Tag: 1787624831-421023
X-HE-Meta: U2FsdGVkX18+/MVFFjlPUZQ2sTTKJ4HgCIh8EEWJ7yKMxf3UBUrp/WfYWbP+BQyY/s3i/RC0tmAwEHLqe4YAqeVFl3cYafXPtTW0XKYnDgxvG8LumuZfKYKG8j6kgLvqluo/CrKxUsapBT6arGzxMs+T8cLKril17PXaouU141dAMrOzK/KvlvS0hWvZ0W2x9ykU7CXtCn+5XAqXjEwNeR7kYstYDLvyUbxhKYAQ0sBeJSnpdxgWwP9Wlv0bGeEcYD0Wwuz5IMJtg6ZzA7FvT4OBLX3gpiQPWH3cxJaVxwYxTy1WwvDYcIdSa+liR+/8VIVC54SraSKu39QAZRUH2oib3WHsk+r0GvSwjheIKEuPrbe0os371oRVhNg8Wk1uy3YDqmF6qPmkLpRWdb1sPPl2WcRkgkbovBiCeGPIKnt+43Abyd/LOydWQChlnpAC8hjc5cL8dsxMOYC4JqnwXU1apiXS8qWjgZYZ4/49qCkHn5GrZ8XR42syBBYES/XClFfbCL4IBF+99Gk43Gaw3zjJ+fuwjnvzVHqw4WgcfdduOB5DJ2+nTnjwUTJWTdRo6J0THEPopBWlaP3ze4sXNNM0zn5mWZ/ePTpmp7HSoLrdLm0qKCD6L808qW+RUy0EKtBOn8grIevrV4KvObP228+c2nb36sBOqjV1//uBLa3QhDcoA0UhSxxe7/IGSjqPzCDsW+MsxTZZzYl6TololyBOqtCeVe+JP2QYOTD6onWcZcRJqHNAl4pWFnB+gyt8JzliAQgTpgUTMs01o0QB9KoMua51s/UaQqgo7EKpb82ZZNey41SFzI6aHADqmElD9omBoYDMi4mvwqS0RIoo8kb3qUBY5GE3mSJyp9AeuX7A77HtjVe4KJjd2gDrdFKYjki1hjgxETqCuLTgblhzNFCF2fguEAQAySSBZxfT3x0dM9PgD9vGO1VTJVjhLyjbdP6GvHO7Vu7xowm+oCA
 2KLwKhb+
 dCt1giyi6+WrwfcRqzW9VKMsTG89wtv66w1l8ivZ11iNMqsd/zINDlP5jNZRU3hIADGjKuAmTIWHIGfUCRiljdttMyHgeJXDjtl2XU1wbyJLioHQVTWkg+vuNx9XvN9mbrMQtvtOpnWbLCakALW903T1Fats3MyDivfC7bbQf7nhXbiTlNHbEedL1BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A reset of a CXL Port clears the HDM Decoders of every component below it,
so the decode has to be put back for every endpoint the Port routes to.

setup_hw_decoder() writes Interleave Granularity, Interleave Ways and
Target Range Type. Restoring a decoder needs the rest of its Control
register too, and the port's HDM Decoder Global Control register, so read
both before the reset and write them back after it.

Add cxl_port_recommit_decoders() to restore the decode of every endpoint
below a CXL Port, and cxl_port_save_hdm_state() to record those registers
beforehand, one struct cxl_hdm_state per port.

Commit each path from the endpoint upward, so a decoder starts claiming its
range only after the path below it is programmed. Within a port, commit the
decoders in instance order, which CXL r4.0 sec 8.2.4.20.13 requires during
reprogramming.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/cxl/core/core.h |  22 +++-
 drivers/cxl/core/hdm.c  | 222 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 240 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 918d48f4422e..d23f0bbd7bf0 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -215,8 +215,26 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm,
 			struct cxl_endpoint_dvsec_info *info);
 void cxl_enable_hdm(struct cxl_hdm *cxlhdm, u32 global_ctrl);
 int cxl_set_mem_enable(struct cxl_dev_state *cxlds, u16 val);
-int cxl_decoder_recommit(struct cxl_decoder *cxld, u32 ctrl);
-int cxl_endpoint_enable_hdm_decode(struct cxl_memdev *cxlmd, u32 global_ctrl);
+/**
+ * struct cxl_hdm_state - one CXL port's HDM decoder programming, saved
+ * @global_ctrl: CXL HDM Decoder Global Control
+ * @nr_ctrl: number of entries in @ctrl
+ * @ctrl: CXL HDM Decoder n Control, indexed by decoder id
+ *
+ * Holds the fields of those two registers that the driver does not model, read
+ * before a reset and written back after it. Instances are held in an xarray
+ * keyed by the &struct cxl_port they were read from.
+ */
+struct cxl_hdm_state {
+	u32 global_ctrl;
+	int nr_ctrl;
+	u32 ctrl[];
+};
+
+int cxl_port_save_hdm_state(struct cxl_port *port, struct xarray *hdm_state);
+void cxl_port_put_hdm_state(struct xarray *hdm_state);
+int cxl_port_recommit_decoders(struct cxl_port *port,
+			       struct xarray *hdm_state);
 int cxl_port_get_possible_dports(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_FEATURES
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 7c898c60f60f..9839d2592d20 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -878,7 +878,7 @@ static int cxl_decoder_commit(struct cxl_decoder *cxld)
  * Return: 0 on success or if @cxld needs no reprogramming, negative errno if the
  * commit times out or if the hardware reports a commit error.
  */
-int cxl_decoder_recommit(struct cxl_decoder *cxld, u32 ctrl)
+static int cxl_decoder_recommit(struct cxl_decoder *cxld, u32 ctrl)
 {
 	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
 	struct cxl_hdm *cxlhdm = dev_get_drvdata(&port->dev);
@@ -935,6 +935,42 @@ static bool cxl_endpoint_decoders_are_emulated(struct cxl_port *endpoint)
 				     __cxl_endpoint_decoder_is_emulated);
 }
 
+struct cxl_recommit_ctx {
+	const struct cxl_hdm_state *state;
+	int *first_rc;
+};
+
+static int __cxl_port_recommit_decoder(struct device *dev, void *data)
+{
+	struct cxl_recommit_ctx *ctx = data;
+	struct cxl_decoder *cxld;
+	int rc;
+
+	if (!(is_switch_decoder(dev) || is_endpoint_decoder(dev)))
+		return 0;
+
+	cxld = to_cxl_decoder(dev);
+
+	if (cxld->id >= ctx->state->nr_ctrl) {
+		dev_warn(&cxld->dev, "%s: no saved control register\n",
+			 __func__);
+		if (!*ctx->first_rc)
+			*ctx->first_rc = -ENODATA;
+		return 0;
+	}
+
+	/*
+	 * Reprogram every decoder the walk reaches. Stopping at the first
+	 * failure would leave the rest of the path decoding nothing, so record
+	 * the first error and continue.
+	 */
+	rc = cxl_decoder_recommit(cxld, ctx->state->ctrl[cxld->id]);
+	if (rc && !*ctx->first_rc)
+		*ctx->first_rc = rc;
+
+	return 0;
+}
+
 /*
  * Restore CXL.mem decode on @cxlmd before any of its decoders is committed. A
  * reset clears the endpoint's HDM Decoder Global Control and the DVSEC CXL
@@ -951,7 +987,8 @@ static bool cxl_endpoint_decoders_are_emulated(struct cxl_port *endpoint)
  * the caller supplies the value it saved rather than one read back after the
  * reset.
  */
-int cxl_endpoint_enable_hdm_decode(struct cxl_memdev *cxlmd, u32 global_ctrl)
+static int cxl_endpoint_enable_hdm_decode(struct cxl_memdev *cxlmd,
+					  u32 global_ctrl)
 {
 	struct cxl_port *endpoint = cxlmd->endpoint;
 	struct cxl_hdm *cxlhdm = dev_get_drvdata(&endpoint->dev);
@@ -972,6 +1009,187 @@ int cxl_endpoint_enable_hdm_decode(struct cxl_memdev *cxlmd, u32 global_ctrl)
 	return 0;
 }
 
+/**
+ * cxl_port_recommit_decoders - reprogram the HDM decoders below @port
+ * @port: CXL port whose downstream decoders to reprogram
+ * @hdm_state: saved &struct cxl_hdm_state per port, keyed by &struct cxl_port
+ *
+ * Reprogram the HDM decoders below @port that lost their programming. Every
+ * endpoint beneath @port is restored along its whole path, from the endpoint up
+ * to the last port below @port. A decoder that hardware still reports committed
+ * is left untouched.
+ *
+ * Per CXL r4.0 sec 8.2.4.20.13 decoder m must be committed before decoder m+1
+ * while reprogramming, so let device_for_each_child() visit each port's decoders
+ * in instance order. Each path is walked from the endpoint upward, the order
+ * cxl_region_decode_commit() uses.
+ *
+ * The endpoints are reprogrammed one after another, so an interleaved HPA range
+ * decodes through only part of its interleave set until the last member is
+ * done. Per CXL r4.0 sec 8.2.4.20.13 software owns quiescing the traffic that
+ * targets a decoder being reprogrammed: a read that no decoder positively
+ * decodes returns all 1s or poison, and per Table 8-118 such a write is
+ * dropped. Nothing here can detect a stray access, so the caller carries that
+ * duty.
+ *
+ * Context: caller must hold @cxl_rwsem.region to keep the topology and the
+ * switch decoder target lists stable across the walk, and must have quiesced
+ * every access to the HPA ranges decoded below @port.
+ *
+ * A port with no entry in @hdm_state was not saved, so its decoders are left
+ * alone rather than committed with whatever the reset left in the fields the
+ * driver does not model.
+ *
+ * Return: 0 on success, negative errno of the first decoder that failed or
+ * -ENODATA if a port on the path has no saved state.
+ */
+int cxl_port_recommit_decoders(struct cxl_port *port, struct xarray *hdm_state)
+{
+	struct cxl_ep *port_ep;
+	unsigned long index;
+	int first_rc = 0;
+
+	lockdep_assert_held(&cxl_rwsem.region);
+
+	xa_for_each(&port->endpoints, index, port_ep) {
+		struct cxl_memdev *cxlmd = to_cxl_memdev(port_ep->ep);
+		struct cxl_hdm_state *state;
+		struct cxl_port *iter;
+		int rc;
+
+		if (IS_ERR_OR_NULL(cxlmd->endpoint))
+			continue;
+
+		state = xa_load(hdm_state, (unsigned long)cxlmd->endpoint);
+		if (!state) {
+			dev_warn(&cxlmd->dev, "%s: no saved HDM state\n",
+				 __func__);
+			if (!first_rc)
+				first_rc = -ENODATA;
+			continue;
+		}
+
+		rc = cxl_endpoint_enable_hdm_decode(cxlmd, state->global_ctrl);
+		if (rc) {
+			dev_warn(&cxlmd->dev,
+				 "%s: failed to enable HDM decode: %d\n",
+				 __func__, rc);
+			if (!first_rc)
+				first_rc = rc;
+			continue;
+		}
+
+		/*
+		 * Walk from the endpoint up to @port so a decoder is committed
+		 * only after the decoder it routes to. @port is the last parent
+		 * visited by the walk, and it is excluded.
+		 */
+		for (iter = cxlmd->endpoint; iter && iter != port;
+		     iter = parent_port_of(iter)) {
+			struct cxl_recommit_ctx ctx = {
+				.state = xa_load(hdm_state, (unsigned long)iter),
+				.first_rc = &first_rc,
+			};
+
+			if (!ctx.state) {
+				dev_warn(&iter->dev, "%s: no saved HDM state\n",
+					 __func__);
+				if (!first_rc)
+					first_rc = -ENODATA;
+				continue;
+			}
+
+			device_for_each_child(&iter->dev, &ctx,
+					      __cxl_port_recommit_decoder);
+		}
+	}
+
+	return first_rc;
+}
+
+/**
+ * cxl_port_save_hdm_state - record the HDM decoder control registers below @port
+ * @port: CXL port whose downstream decoders to record
+ * @hdm_state: xarray to fill, one entry per port, keyed by &struct cxl_port
+ *
+ * Read the CXL HDM Decoder Global Control and every CXL HDM Decoder n Control
+ * register of the ports below @port. Those hold the fields
+ * cxl_port_recommit_decoders() cannot rebuild from the driver's cached settings,
+ * so they have to be read while the registers still hold them.
+ *
+ * The set of ports is the same one cxl_port_recommit_decoders() walks. A port
+ * with no HDM decoder registers has nothing to record and gets no entry.
+ *
+ * Context: caller must hold @cxl_rwsem.region.
+ *
+ * Return: 0 on success, negative errno if an entry cannot be allocated or
+ * inserted.
+ */
+int cxl_port_save_hdm_state(struct cxl_port *port, struct xarray *hdm_state)
+{
+	struct cxl_ep *port_ep;
+	unsigned long index;
+
+	lockdep_assert_held(&cxl_rwsem.region);
+
+	xa_for_each(&port->endpoints, index, port_ep) {
+		struct cxl_memdev *cxlmd = to_cxl_memdev(port_ep->ep);
+		struct cxl_port *iter;
+
+		if (IS_ERR_OR_NULL(cxlmd->endpoint))
+			continue;
+
+		for (iter = cxlmd->endpoint; iter && iter != port;
+		     iter = parent_port_of(iter)) {
+			struct cxl_hdm *cxlhdm = dev_get_drvdata(&iter->dev);
+			struct cxl_hdm_state *state;
+			void __iomem *hdm;
+			int rc;
+
+			if (xa_load(hdm_state, (unsigned long)iter))
+				continue;
+
+			if (!cxlhdm || !cxlhdm->regs.hdm_decoder)
+				continue;
+
+			hdm = cxlhdm->regs.hdm_decoder;
+			state = kzalloc_flex(*state, ctrl,
+					     cxlhdm->decoder_count);
+			if (!state)
+				return -ENOMEM;
+
+			state->global_ctrl = readl(hdm + CXL_HDM_DECODER_CTRL_OFFSET);
+			state->nr_ctrl = cxlhdm->decoder_count;
+			for (int i = 0; i < state->nr_ctrl; i++)
+				state->ctrl[i] =
+					readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(i));
+
+			rc = xa_insert(hdm_state, (unsigned long)iter, state,
+				       GFP_KERNEL);
+			if (rc) {
+				kfree(state);
+				return rc;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * cxl_port_put_hdm_state - release a set filled by cxl_port_save_hdm_state()
+ * @hdm_state: xarray to empty
+ */
+void cxl_port_put_hdm_state(struct xarray *hdm_state)
+{
+	struct cxl_hdm_state *state;
+	unsigned long index;
+
+	xa_for_each(hdm_state, index, state)
+		kfree(state);
+	xa_destroy(hdm_state);
+}
+
 static int commit_reap(struct device *dev, void *data)
 {
 	struct cxl_port *port = to_cxl_port(dev->parent);
-- 
2.55.0


