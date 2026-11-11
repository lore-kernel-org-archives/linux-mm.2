Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE494606E2B1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=qaxYqcXt
Received: by kanga.kvack.org (Postfix)
	id DA9106B05C4; Wed, 11 Nov 2026 17:44:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59206B05C5; Wed, 11 Nov 2026 17:44:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C959C6B05C6; Wed, 11 Nov 2026 17:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A92776B05C4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:44:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56AC940426
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:44:30 +0000 (UTC)
X-FDA: 85424318700.20.8E73563
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0EBA940007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:44:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qaxYqcXt;
	spf=pass (imf12.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437068;
	b=oBDkSIRFBEJzs6i08cSV27cnPSaIS+0M9ODcZceFACWp+7ARLN1tpYw0XVSHwza0qsum8K
	ZW1SmmT0nL7pP4XB2GJynfZemokKUo4cVQyuXIoRfNHwhdHAvNnPOPMdXt9kFuehWESn9x
	vdUYmPKjxUNv0i4TCk9bS0tgMo3xluA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qaxYqcXt;
	spf=pass (imf12.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RikZQ1odxaSHdwBKe1B1T6fN0JY99txMaqyijCLq4Tw=;
	b=hgp43xzt3v5seurYceZtk2OjJdSRlEL0f9JZi6tiv/6KPCUWf4d5RoM2fPllkXjcxSaEEz
	h+oEJyNJVggjsUc41C0/0tEsyOsuQBTZ2w9eFpdDUmBQZjbFJGxhRpDyznthYT3v5H0VVD
	4AFrEDryKv3Fa8zT5+L3wlBKHpOf/ok=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794437068; x=1825973068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RikZQ1odxaSHdwBKe1B1T6fN0JY99txMaqyijCLq4Tw=;
  b=qaxYqcXtZudQcb6XFbu8GNk09GkIisWDwCzhkpVPTWqVOwpreEPkyKoD
   kbgMNNgJ4qFKAv0tP+qQhaWTW4u08vrPH2pUPGuJgRKmjdUeRG/xrUOPv
   uzg5ck61i8mzkr7IamEgvIJ2PuejRm48DjaRXqjiMUBEjXlCJ3rIhUraB
   SANst5ESIfkF9muFoctJe5uE8K3bmKbarFBneTrVimgkxZNnWtfmppPC0
   ByWdsuMzzqi2cMibvo9nLYfSe/0HojQTVNFb1wJgYJh/Nvtwx6N0jcu63
   uPqOSp88cFIIHEMkkRFQoCBo5Fg2ZBwIT8Kz3+S3Csg8LoCuq3/eWL+1k
   g==;
X-CSE-ConnectionGUID: WTNM8apySkiSNhJ16IVtBw==
X-CSE-MsgGUID: kpqw3RAmQTm0n4HuTKIUtA==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33572346"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:44:27 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:30085]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id edac81ec-ae2d-4f54-a2dc-5d8fd8cdc477; Wed, 11 Nov 2026 22:44:26 +0000 (UTC)
X-Farcaster-Flow-ID: edac81ec-ae2d-4f54-a2dc-5d8fd8cdc477
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:44:26 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:44:23 +0000
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
Subject: [PATCH 12/40] nitro_enclaves: Name the device's error codes in the UAPI header
Date: Wed, 11 Nov 2026 22:41:57 +0000
Message-ID: <5ef0d84ef7ca12328f6debd41d3bcdbf07315450.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: 7ipbckxihimr9jrh43pk4bs368qcpn46
X-Rspamd-Queue-Id: 0EBA940007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794437067-435420
X-HE-Meta: U2FsdGVkX18g0H7jH+FBJii0eMG0XK+OPh+jVvHoK5FAebu2MjXnfYmLJwOApl7woK6zAabbPIQRpcJ3J446s2xD8mjcXulhpjUlEs6BbdcCON6RnPzds3g7eg/tMJB50RPX3M7YjI2Ol3Bqf8VGyspJCyoo5QEZHW16aI2cqwDd+8P+nI/FVH15qwViwkcEdB7jcd/RrDJ5LByWW6zYRD9whXpIeefriUzZW5eZriBerNq/cgPpul4qN43QHqow7HeHM8+plptLk9m5ld00EJzgIJStF9JejFyuGD+i/pECUfAMjIuJh0hVbuN+s8VBZsRZ+ENuder8d881TmBd5Kgh9K8Ep7ulI1KEwDANWc3qDpuO31HzTgwpjddlM7w37c2X6wQCzKnBxGJWGWhIyd7olUGtLPz57zMDWv+0eV33Oebgbon2Z6J+FZdwLBvJnwIKmQLM52u2u0BlgS5C5FAJN2Rvy1DlDkUkL59DOLUqlW6Po/oJYxlsKW5HHPTDdt9OZSPGK0twIBsD7LLiRaSFrShyhvKdzwlrC92VlEtsJvo+DXc1OMkurwG8xYEs2g7jfCeLOY4qY2tYP7HfzU5oNXx6AFoFriXQbjwWkb0beBXXfgACLxvbWteRvLVwJu7whw8k26BbpNcpHgJsmz11rKOb01P2arliYCbuijFZaX1BFLynnLeJQP1Iv5Y3R/st8boQoP54RQKu99Jg0NzhqzQttM8M+ZVEyKb0CauYNlMSzNRxxQGzqBPrBTRwxLRy0xyGieBV7Hv9NHREYMlltmwr0H9ovhLmwAzsfdG7BJWkDlHAxIXQhHFJYsDnXxGdK1yrQefCRv8gYyxJvVBumlgEQ2Pw7qkHR3kyyCg7SqeeDmZ1e0NlNaN70oQAluaUKwENNxc3ueHg8kkHylj4OyDgmFxB+W2J5ErSoXRfgmA8RJ5+CSOs4Gdrvm5GswATWYtamnyN1UYNUzT
 TtUYZ1AE
 1SCPicierE7OBttVYWW5usVCIu5yTTfHx15paQ1sRioIxJHbV7X3bcM0om9qP74ZXJsVn3tP+/FVEhd09V5h5ay49VB3+GE7O5WkFSPcbTxsmDNRTjVGtSEzrGpTSdadHAzofHeTJ4w45hRSDRgL8AW7hDp8wOn5JFaskrC9mKZiG0VyX5pBdbX6UcPdQvSfDVymRpXSeTiKzGdfmiCMI2ia3ghdasFY4my1ans9CJ/6lfzggtOwPGzBjUEGj7kzv18f1iNQhQAf58OT85cP9twzFYq+GeijKqiCiO4FhMLhoRccZRcOkJt2YCW3MZynN/HQE+yskCfRWIWMAR0XsJjJZ8RpC6uUbDb5KC5Pbah2cB8PZyP8B+98OyDGoSPCoOq+GHVPdCqr0XrT1gpRKb5dJggO3XGW24tItNyq354ZOlZ51DN0tkafufKA6hO17IH027i/OTiK07Z51onNa7y794VZhBBhRRtj2/NTzqeEdR+K4YPy9Lf+RSdp8COEKZ0jhgKz8EMZB/hh3hKAfDbLTb1w7PaBOupMgBkeJMqfY/eVeByNnbPhVwGi3hhiiXftvq1lKtOG/yhZ9ACBZGBrXjx05Wla/c/gAMRLY+mKz4Q7Hipo/QH6m6UxrvBFxWqU4yKnRvSOpz4G0XA4RZM/5bC2qqhkvKwzhcHuLFYsYrA+jzy+TgTXE8mu19BU00O4zqS9LsjW1cO3cR2x8gKs1+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The nitro_enclaves device refuses a command with an errno or with an
NE_ERR_ code, which ne_do_request() passes on to user space as it is.
The codes of its own that the device returns start at 276, after the
driver's, and we want the device to be able to add more of them later.

Name the device's codes in the header, so that a caller can tell for
example a refused flag from an invalid slot, and document three ranges:
the driver's original codes from 256, the device's codes from 276 to
511, and codes only the driver returns from 1024. That way new codes on
either side never collide. 511 stays below the kernel-internal error
codes, and 1024 well below MAX_ERRNO, so user space reads every code as
an error.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 include/uapi/linux/nitro_enclaves.h | 142 ++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)

diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index 8ccf16e9cf5fb..6dd00c41c07d5 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -567,6 +567,148 @@ struct ne_add_memory_region_args {
  */
 #define NE_ERR_INVALID_ENCLAVE_CID		(275)
 
+/**
+ * DOC: NE error code ranges
+ *
+ * The NE_ERR_ codes come from three ranges:
+ *
+ * * 256 to 275 - The driver's original codes. The NE PCI device also
+ *   returns NE_ERR_MEM_MAX_REGIONS, with the same meaning.
+ * * 276 to 511 - Codes the NE PCI device returns. The driver passes them on
+ *   to the caller unchanged, and the device adds new codes upward from the
+ *   last one defined here. The range ends below the kernel-internal error
+ *   codes, which start at 512.
+ * * 1024 and above - Codes only the driver returns, added upward from 1024.
+ */
+
+/**
+ * NE_ERR_INVALID_FLAGS - The command's reserved flags field was not zero.
+ */
+#define NE_ERR_INVALID_FLAGS			(276)
+/**
+ * NE_ERR_INVALID_ALIGNMENT - An address or a size the command carries is
+ *			      misaligned or too small.
+ */
+#define NE_ERR_INVALID_ALIGNMENT		(277)
+/**
+ * NE_ERR_INVALID_SIZE - A size or count the command carries is zero, too large
+ *			 or too short.
+ */
+#define NE_ERR_INVALID_SIZE			(278)
+/**
+ * NE_ERR_INVALID_SLOT - The slot the command names does not exist.
+ */
+#define NE_ERR_INVALID_SLOT			(279)
+/**
+ * NE_ERR_INVALID_DEVICE - The command names a device, an address or a memory
+ *			   range the device does not accept.
+ */
+#define NE_ERR_INVALID_DEVICE			(280)
+/**
+ * NE_ERR_TOO_MANY_DEVICES - The enclave already has as many devices as it may.
+ */
+#define NE_ERR_TOO_MANY_DEVICES			(281)
+/**
+ * NE_ERR_TOO_MANY_VQS - The device already has as many queues as it may.
+ */
+#define NE_ERR_TOO_MANY_VQS			(282)
+/**
+ * NE_ERR_NO_RESOURCES - The device could not put together something of its own
+ *			 that the command needs.
+ */
+#define NE_ERR_NO_RESOURCES			(283)
+/**
+ * NE_ERR_ALREADY_EXISTS - The slot already has what the command gives it.
+ */
+#define NE_ERR_ALREADY_EXISTS			(284)
+/**
+ * NE_ERR_MISSING_INFO_PAGE - The slot has no info page, or the one it has is too
+ *			      small for what the command writes there.
+ */
+#define NE_ERR_MISSING_INFO_PAGE		(285)
+/**
+ * NE_ERR_INVALID_FLAG - A flag bit the device does not know, or does not allow
+ *			 here, was set.
+ */
+#define NE_ERR_INVALID_FLAG			(286)
+/**
+ * NE_ERR_RESERVED_FLAG - A reserved flag bit was set.
+ */
+#define NE_ERR_RESERVED_FLAG			(287)
+/**
+ * NE_ERR_MISSING_PCIE - A flag that depends on the PCIe flag was set without it.
+ */
+#define NE_ERR_MISSING_PCIE			(288)
+/**
+ * NE_ERR_INCOMPATIBLE_FLAGS - The flags asked for cannot be had together.
+ */
+#define NE_ERR_INCOMPATIBLE_FLAGS		(289)
+/**
+ * NE_ERR_EIF_FLAG_MISMATCH - The image's matched flags are not the ones the
+ *			      enclave was started with.
+ */
+#define NE_ERR_EIF_FLAG_MISMATCH		(290)
+/**
+ * NE_ERR_DEVICE_DISALLOWED - The device type asked for is not allowed.
+ */
+#define NE_ERR_DEVICE_DISALLOWED		(291)
+/**
+ * NE_ERR_HOTPLUG_DISABLED - The enclave does not take devices once it is
+ *			     running.
+ */
+#define NE_ERR_HOTPLUG_DISABLED			(292)
+/**
+ * NE_ERR_BAD_EIF - The enclave image is missing, or did not pass validation when
+ *		    the enclave was started.
+ */
+#define NE_ERR_BAD_EIF				(293)
+/**
+ * NE_ERR_MISSING_PCIE_VIRTIO - A flag that depends on the virtio-PCIe flag was
+ *				set without it.
+ */
+#define NE_ERR_MISSING_PCIE_VIRTIO		(294)
+/**
+ * NE_ERR_BAD_PAYLOAD_VERSION - The request's payload version is one the device
+ *				does not take.
+ */
+#define NE_ERR_BAD_PAYLOAD_VERSION		(295)
+/**
+ * NE_ERR_INFO_VECTORS_EXHAUSTED - No notification vector is left.
+ */
+#define NE_ERR_INFO_VECTORS_EXHAUSTED		(296)
+/**
+ * NE_ERR_TOO_MANY_ENCLAVES - The instance already has as many enclaves as its
+ *			      quota allows. A terminal answer: neither
+ *			      resending the command nor donating more memory
+ *			      changes it.
+ */
+#define NE_ERR_TOO_MANY_ENCLAVES		(297)
+/**
+ * NE_ERR_NO_MEM_SLOTS_ON_NODE - The memory budget of one NUMA node is used up,
+ *				 which -ENOSPC does not distinguish from the
+ *				 budget as a whole.
+ */
+#define NE_ERR_NO_MEM_SLOTS_ON_NODE		(298)
+/**
+ * NE_ERR_NUMA_SPAN - The enclave's CPUs and memory span more than one host NUMA
+ *		      node, and the enclave was not set up to span nodes.
+ */
+#define NE_ERR_NUMA_SPAN			(299)
+/**
+ * NE_ERR_NUMA_ALIGNMENT - The memory of a guest NUMA node other than the last
+ *			   is not a multiple of the guest's memory section size.
+ */
+#define NE_ERR_NUMA_ALIGNMENT			(300)
+/**
+ * NE_ERR_LOW_RAM_TOO_SMALL - The lowest contiguous run of enclave memory is too
+ *			      small for the boot layout the enclave needs.
+ */
+#define NE_ERR_LOW_RAM_TOO_SMALL		(301)
+/**
+ * NE_ERR_ZERO_REGION - The enclave's memory layout has a region of size zero.
+ */
+#define NE_ERR_ZERO_REGION			(302)
+
 /**
  * DOC: Image load info flags
  */
-- 
2.47.1


