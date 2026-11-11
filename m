Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B682606A338
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ETxILC0x
Received: by kanga.kvack.org (Postfix)
	id 428D96B05B6; Wed, 11 Nov 2026 18:01:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4009D6B05B8; Wed, 11 Nov 2026 18:01:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF5C6B05B9; Wed, 11 Nov 2026 18:01:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3DBE6B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:01:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B0931C3B67
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:01:00 +0000 (UTC)
X-FDA: 85424360280.27.AC12C4A
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3CF5B40004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:00:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ETxILC0x;
	spf=pass (imf01.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438058;
	b=FHC/OkH9/kHhDaBz8eyqZy4m4Rv9dgrbaMlv9kHs0Z6OXu8cfYYIQd7rs9Fpuu3H6di9BN
	A7Hyz+CJP7rTn+bVR8UTNxbSiVuxjkOsJql+TQIot5D/SFbx0ubKO1liTUNa1m1aLuU5/F
	iN0cHt8yQcUgtDCbOjShjTFNpVF+bf8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ETxILC0x;
	spf=pass (imf01.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XmuKZ2loZKyTAGGj5N0MglpczGlu5fP4eNsQMpnqo5g=;
	b=l5TULiGam8RZsd9iRQku44z1DzxpZ9/doV3DV6W6ItC/V3M3kGFGqxPNaLHNvfr2fj8XrA
	I5LDZlNj/YMF13/f8bYQuKlZ2KlpHfPiC6ac5I1Y24bgKOEi2rHap8h9NNtd3gzUyOeIxQ
	onz6mF4Hub8jAaqiygsnkj0nilitMBU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438058; x=1825974058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XmuKZ2loZKyTAGGj5N0MglpczGlu5fP4eNsQMpnqo5g=;
  b=ETxILC0xVrv4pYr0mbqAlj8G3fAyZHZoVThNzYb8cE2EfQheW+3hpdpy
   4u77RAnDoPv0APRFXknQ2Ynnf4CJ9837MiplVxPIl0QPbMBzCtXNzs4Nz
   6aoBvErvxuY4AKrK6ME1o6A9UvNSHxKkP6w39/v+A6Lq2hwEr4syw3ENI
   /umVE4Enjn/FZRdF5A7gv+cyVPL3tTvgE7Kaui9wRN1Ourtc2nxVSPIVP
   v6f87cSxI93Vy5jaU2NHD7UtkbIWekXAzfo3VuZmffzV9SXY0/rXM1XmS
   /Py9ukYy6OzH04e0/ZE1NpJ22I5qa/h5gD/KQciJKDxuhLQnLIsiq35o3
   w==;
X-CSE-ConnectionGUID: u0wPrw6NQ/K2I7KjcEQL/g==
X-CSE-MsgGUID: sexqQlZdRrysFYK8rx374w==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33757115"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:00:57 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:6966]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id 4a210c56-7070-43a0-9871-00ea9c7c08f5; Wed, 11 Nov 2026 23:00:56 +0000 (UTC)
X-Farcaster-Flow-ID: 4a210c56-7070-43a0-9871-00ea9c7c08f5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:00:56 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:00:54 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 17/40] nitro_enclaves: Add the slot pool donation commands
Date: Wed, 11 Nov 2026 22:59:21 +0000
Message-ID: <8a4509d7542883afe7337af9c1bf759740572a81.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3CF5B40004
X-Stat-Signature: zoen145f73t6d6rqc518qkjocts68dpe
X-Rspam-User: 
X-HE-Tag: 1794438058-919735
X-HE-Meta: U2FsdGVkX18d60xvIbw5msZJ+NW18TcU7WGUCt4eAhOdScOat3WorK1Vr7naBfCvlYw3Rf2JmlhT1c9vGAMF3tSogzPRRq4fpDIgOjvhwfzS1AhV/M7pHkjSl7DbOcnj5/pT2vVCWUatdju1u+p8hFrtR+UN6BCIBCMCT3oIACACARs1rsIf2E1o1GIRLMdKclZautr5pjsA3BVTAqTFlm23TPS/y0HZAqs6+QzJ+bt3f6ZgNQjwAaRnC7JGYts8h3FnW/KbnAMI8QpwKYAsBq4JtKx5akIoPXjYcEg6osi7rZSH+CsckELP4N0bqpsNVcFIzaJSiRqoZRhoHw+yEcE51fF8c/7IMby6ZgLHAd7rEga7WgCmj/iuejBZ/lljNHaTiNXwaCl6YxRaE0P/MBM8YmN8QnQcqGhPlYq814n8fpbgACS0Rfn81uNUti409c+l4ev0pasnpTPaDFRIMRP3O1als6q6ZUD292/H0ZmOXLnECyiwtBs1ulhcPiQbGEFGO1z2quF2z7IKQ2F3thqn6ibkDgyX4pAYqKKpMsbfUHnc2TajwbNFj3Iz64U3+EgJjXQHfMyI67iMnT14sTfyYHXjWvuzecMzz4/YDlsjGMd2V++pr+aUqI096oWzpsJxEptyR8FRhL3nly0DXso5x8L6kLZHThyQ6nHE1eN3eJmo8YYiB+VUOXf2Fs66p+hzMYrJ0Nd1dEKvsotiQK5kfBQuc1vuqWnHn50lCDRcDXpzqtKV27X1ZFcnieXYkn4v7HBgNiMrcYmtjZC5DqFmlKKhLhIehRwYIOeOtVo6UxDjx9qKMyx4CHhb4KOTDk+rAlUkgj+dgISsnaRtBSMvnZC4eXSR5VXVNTn0WnmZVvYVqT0MsfSpASi4mtgd4oHldpPqtCL1xmXsSxn1i8Ey6PVpfh5biia1p8jykn7zMfATOtVfNQ7IPjeRX+OpxP9bdTBdNW3rW+porrS
 zaopvTms
 nIHEyA/0HoGI7sIMQGn4SI5IfqJvS8E2z+1wc/dqHW9sAS4q6yURNbw1mZWMzDE9WIw5E0ymMNBg9pln/k6bUe5Xj7g7YSbBCx/EEtAGtebCLnWFJyT2aM6qdW83TM/w6LN7bk8VVRrp5Ci7D44kNwrPQQg4Euhs7FNHTeialqC9LfbCQY1EvN8fiOQvhHM0wpOOeK2ijUDhg3MkMlBk7sF38ApwUpZYVonQ8hO8Vh2UPM+ebdNCZZ133wVlqYZblm49xcu6mK7ygy2bau/K9nAEhHXjzS4hyD12wS5/3rrn8+iJ2Kgz22LuApNKMowCL3xQPGXlqqe5Qd/CGGy12xL8eMO4zpqd9ls0wztBSjQKDZiy8IC2oblj9dE7DDIhSu9ay1L+uBGKW6mLGbpgCfSLlTSsw/H/CBhX+Z6E157zXGdd1VCMOuNh2m4Dp5Pm/dCtusxMG/zpQE9FMRuqVRUFnusWSVfMSuLUGgT0IJSf9ZekUIvoBwe0oFY1FmpEAA9Xt5PK3WRF+J9OuVpBdzYrehYNbIF4gVTjGAA7XRNfzixBC7j7lbluXMAY4iRsOAeb6Kfjj634oRh4LTHnD+6XaI+VKYP4Az66xj4eX2r4Anb0H2fVtbGxRuGVqWevdNTuQHHwknEeFE0qJwsKA4xGd12ogXZkpfaIR0phmsBr08GG6O76t+35IylsRUwWBLiGWsmTp/MtN8aA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nitro Sandboxes introduce the concept of memory donations. In order to
launch more sandboxes, the parent instance needs to donate some of its
memory. A device that supports Nitro Sandboxes keeps its slot pool in
that memory: the descriptors of its slots and the memory the slots run
on. In preparation to donate that memory, add the commands that donate
memory for the slot descriptors and the registers that say how much of
it the device wants.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.h | 60 ++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 835413fca8040..e651e74ab656e 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -95,6 +95,42 @@
  */
 #define NE_RECV_DATA_SIZE	(240)
 
+/**
+ * DOC: Slot pool registers in the NE PCI device MMIO BAR
+ */
+
+/**
+ * NE_SLOT_POOL_MAX - (2 bytes) Register reporting the highest number of
+ *		      slots the device lets the pool grow to, or zero on a
+ *		      device that needs no donation (Read-Only).
+ */
+#define NE_SLOT_POOL_MAX	(0x01f2)
+
+/**
+ * NE_SLOT_POOL_LIMIT - (2 bytes) Register reporting how many slots the
+ *			pool has room for with the pages donated so far
+ *			(Read-Only).
+ */
+#define NE_SLOT_POOL_LIMIT	(0x01f6)
+
+/**
+ * NE_SLOT_POOL_GRAN_SIZE - (4 bytes) Register reporting the size, in bytes,
+ *			    of one donation to the pool (Read-Only).
+ */
+#define NE_SLOT_POOL_GRAN_SIZE	(0x0200)
+
+/**
+ * NE_SLOT_POOL_GRAN_ALIGN - (4 bytes) Register reporting the alignment a
+ *			     donation to the pool has to meet (Read-Only).
+ */
+#define NE_SLOT_POOL_GRAN_ALIGN	(0x0204)
+
+/**
+ * NE_SLOT_POOL_BASE_SIZE - (4 bytes) Register reporting the size, in bytes,
+ *			    of the base donation (Read-Only).
+ */
+#define NE_SLOT_POOL_BASE_SIZE	(0x0208)
+
 /**
  * DOC: MSI-X interrupt vectors
  */
@@ -125,6 +161,10 @@
  * @SLOT_ADD_BULK_VCPUS:	Add a number of vCPUs, not providing CPU ids.
  * @SLOT_ADD_INFO_PAGE:		Give a slot the info page, a memory region the
  *				device writes.
+ * @SLOT_POOL_DONATE:		Donate one page of parent memory to the slot
+ *				pool.
+ * @SLOT_POOL_SHUTDOWN:		Give the whole slot pool back.
+ * @SLOT_POOL_BASE_DONATE:	Donate the base run of the slot pool.
  * @MAX_CMD:			A gatekeeper for max possible command type.
  */
 enum ne_pci_dev_cmd_type {
@@ -142,6 +182,9 @@ enum ne_pci_dev_cmd_type {
 	SLOT_ADD_BULK_VCPUS	= 11,
 	/* 12 is a command this driver does not implement. */
 	SLOT_ADD_INFO_PAGE	= 13,
+	SLOT_POOL_DONATE	= 16,
+	SLOT_POOL_SHUTDOWN	= 17,
+	SLOT_POOL_BASE_DONATE	= 25,
 	MAX_CMD,
 };
 
@@ -284,6 +327,23 @@ struct slot_add_info_page_req {
 	u64	info_size;
 };
 
+/**
+ * struct slot_pool_donate_req - SLOT_POOL_DONATE and SLOT_POOL_BASE_DONATE
+ *				 request.
+ * @paddr:	Physical address of the donated run of pages.
+ */
+struct slot_pool_donate_req {
+	u64	paddr;
+};
+
+/**
+ * struct slot_pool_shutdown_req - SLOT_POOL_SHUTDOWN request.
+ * @unused:	In order to avoid weird sizeof edge cases.
+ */
+struct slot_pool_shutdown_req {
+	u8	unused;
+};
+
 /**
  * struct ne_pci_dev_cmd_reply - NE PCI device command reply.
  *
-- 
2.47.1


