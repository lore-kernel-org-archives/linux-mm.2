Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 544621094483
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 15:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1512A6B00D0; Sat, 21 Mar 2026 11:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DAE76B00D1; Sat, 21 Mar 2026 11:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6046B00D2; Sat, 21 Mar 2026 11:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DAB2E6B00D0
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:04:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E29C1B830B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:26 +0000 (UTC)
X-FDA: 84570391332.25.AEAD9D7
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id CFDE418000F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DbZVODbC;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774105464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GotqY1iYunncyBpBt3k1vF2DkZbep3lRnQKBDrqpHyM=;
	b=tEw5p+W2UugjdPkJ/GGiUtekDzxu3XxZg+GHPiTpOINt2Xy1PTBCduNIjQaWA4W4ysILzr
	QUYRgT8t17nnnXkV4R7MKwev6eCdBEeR7uhKOkPudREK2QmhnBojqC3d8peG5o/iE/pjbJ
	pT5ElEMy/m+2Et6MyValDToGmd7hKh4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774105464; a=rsa-sha256;
	cv=none;
	b=Cmo4JEJoT4IR3PU2xGurVCqzFZioluUFuySv4ckRiz9hhEF8Hv8LvnyJzdHkPFQ74EamSX
	vKoy7ncim72lxPnbwO++9eAZ7gJ5Bwce36n5tNTyFtVgUW+AN5u6rV1bZgTjXckAUWsHx9
	lIlRuiRoGEKqrYC2pSVkHXwIfVesZ6A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DbZVODbC;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cfbfdabf3fso266829085a.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105464; x=1774710264; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GotqY1iYunncyBpBt3k1vF2DkZbep3lRnQKBDrqpHyM=;
        b=DbZVODbCzLpzLE4Kq5OYMrjMpdc99K+G+x+HnpDQAAjztIXa6Xf8zlx64N/F0w65Xt
         ep0irkhbfKcpTAMPYCzPsifFs05bwLV3/r85T1wC47S1S69rKJYiKaRxMhDl9daUOyPm
         oAI4brYVesL3cmQp0PL6qaJt1+r6G1a1FUfZVuNQjMVTQjHthMOxwxKh4kGG28/RTdFH
         iJ2Hm0/BnZ4oShN8qbaopmhoY8NzQzi/8cw8/VCGIxhxZt6BvJfEkuQ5vl2TUY/dnJnM
         +yUViq6a8KnHwK0qgbq3KVGLZh343sqdQc1/2XIX052L6lVgrQdfebIhvDkDR52CXQ6l
         Apnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105464; x=1774710264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GotqY1iYunncyBpBt3k1vF2DkZbep3lRnQKBDrqpHyM=;
        b=jYYnziyRv9R4JS39zSnnDYpA2UHbqSlxqNr2KC+fRCcbkq81FcEvRBho5rCTat8sEq
         TrbOQjqM5NZ3bhu9WHl0zrZkDb6eu3XvgoNW0KN4LfAhHxNwvkbLXFKINSNRJS7Cb1cv
         XvAGsX7vQxct1OnmEkfnH8tXhtfxOGWDYaGJdkK+yzJTKS9qp+RanIGABL37eeG0gFek
         F3JBiVVlthdlqSaU+SOsjGpoGy0HvU39Hq9LDaJ4+zBG9B+Ah1YDOQ/vmxxkSorHCzSX
         oJi0jCo9VI2dFPkQJRac0uU9xc1NQXSXMCbthwkT2USjvtTCPeqvrcuFvLy1kVsH88yG
         9+vQ==
X-Gm-Message-State: AOJu0YxwlM4HnvPJFTeDQRhzXBERWPqguDWbTJKNYtYsgOGk3vLbpZkt
	oywzHhb1a0SmBb77+56+S6bmJuS/H2/OIn36VcLRIU6HCf0JbkeXhBUSUsYqEpSV1WLxhYSnKPO
	JrXkZ
X-Gm-Gg: ATEYQzyC68TkPmzJ/p9n8Wwgq1iGJD5a6LHQ4fVyeCPxaR0aEorwF1VEEMM94AOkcWY
	oWPqqudFseWKv8dn06kcntmmAQMlxyNutwYuklB7+gbCQ9GJ/bGUyW7WApKnTZsZNUBmiRKLtT/
	ja05t1vmWERpa3LU7t0F+J7hXsaYmG+JIwUwpP77D6Y1j514+3X2wVnmirkpL06aHOGrEZDF7bp
	wIrya5Zj6UEjel93pnosvclkN5AkIv0YU0CJC88u2vSin77P7o739LD8Inf05Mzs/reen2iE6OZ
	T1U+uCr1ZoP5vwTxiIN8GmDGZXChiQ4d0pQ+piwIlRWvOmOQannbUk3K6ROkLVrrauE5iNQBPg+
	rWCO3bcxFl22md7FcfsIiFiA5r8xIhup4ITzbo6hQJiol413Iqa5oix8Cwnwk6GxS+aTslu9mvJ
	CPJ24U95exR9DhAg/5vZhm15PZqgKvNIGOFjXZXTXYzlPHqVFv0Ig8Jq3gaXixjx0NZnsUtu+fr
	ovxQlEeaE47F7u5kSOfDvb51g==
X-Received: by 2002:a05:620a:4456:b0:8b2:ea5a:4149 with SMTP id af79cd13be357-8cfc7f873aamr1145888685a.65.1774105463364;
        Sat, 21 Mar 2026 08:04:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:22 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/8] dax/kmem: add sysfs interface for atomic whole-device hotplug
Date: Sat, 21 Mar 2026 11:04:04 -0400
Message-ID: <20260321150404.3288786-9-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CFDE418000F
X-Stat-Signature: xos3saefwyg5uu8htuwagux37rgrio8f
X-Rspam-User: 
X-HE-Tag: 1774105464-286196
X-HE-Meta: U2FsdGVkX1+AMzzZHSKx5vgRdXArPn5xLvRSyj6kFinCEj0MIrSlNtD7P9VeivP85vs2Mgv45QBQbXrAu60ubzw/7tLJSgSLV/0gtBGmIK3U9h3a7RP/oQTvkLwTKxu3RUxxlVQMbeA3R2yVtbWHV4XjnkuAxscREdtAKGlVK1mYQCtD2RVj37eixr7widTePmxNcx4kZat/0fQEMPxkbYl+PRpe9r6JwHRnufyBwswt0nmLeNfQKtD0imFDXZhJ1fG1hqh/iWFifx8A0pse3nqvbcojFZlRBtRqn9ioICpcBlxU/BxhKS8n6SfFl8IPaxtstOjatemjoSQSSaaKksb8OApSVSMQO8XI0/inweCKZHHKXKz8h4EfSX5OV19HdSFDW3rO1iWNvcjcWOFSme8jjK/Zi0II6ESrHCKAdFWG5vqmfLG9ksIne3junzGNDozr7hOadE3v4P8jKJCbQ0+9hZXPUV/AvUEcDWd/6zo7OffANdx/uVitgwqi/P/oEsCluC7ivRv/CjA6AnoJ3uXVHLxXJ8rd3uwsKDQsj5QXLTUkVgZSRXfaH/7XgHHLYNUTU4noA1rR/PVDcJxtpX2ckz9GRGostmMnmZHRaF5BX+zRnQ9nSSFEnwltobSd+9AxiPUW8SQoQlrkXBk+Q8jgaoItYkFxwfs0BC0UL7CtiE6oY2E5v5UDI4f1iX3y6FNoFrTVivrT4jhLvw+a0T8mQqyUIO4Af9Lc4DM/fqkCOLpkCX7aSMjjmaGYmflk2kT0ZNg83cx2p7KoVITxvFM+BYdZP/c2K76PH5ML9df+oXZ4RoxTb+8EhAL3zFtd8ifBfploPnLGvpHUPbNq5+gjEQK9iMvkeYo6jPV7QstdBi5YPqJbMRbSHNrtvMwdz8Nom8g60ZVrlIrm5vE4pPTZFQbFUQ9BsxUJLGFc9vvVTX7QCxJXh7WjSKhATfwzjHAZSUUa9vyjlZdRwWl
 pX9hipp8
 4kf7Nz2WZiwuOLxTfje5Z73flJq/M5TlTY3+L8PDruRCST4V/FW9lKa+9chlmMwWOOwjVmcZI4IGyOxLSQKnUqXzYQQBnyiNB3VflBtPp6TdYe0RigfL0zLiX6AxWAFaPbOGH73C6MZtVkhapBJz1CeVTPBEpJaqb/nwlS+3GDHUfPCUOqP3o19Z7Q6m2q5HhPYcn69WktfMPsWkTSylQXV8nE06EP71NcW8jw01fB8rwQ/MM99A3LM0NPIlo+jwzCdqusoo2B4A9wkKw6pp8XwMpCrepUk1JJHu7tadd/L+IWgJTt/W5C2i4Hmx+0QDbmouIuObZkdmBgBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dax kmem driver currently onlines memory automatically during
probe using the system's default online policy but provides no way
to control or query the entire region state at runtime.

Additionally, there is no atomic mechanism to offline and remove
the entire set of memory blocks together.  Instead, this is presently
done in two steps: (offline all, remove all).  This creates a race
condition where external entities can operate directly on the blocks
and cause hot-unplug to fail.

Add a new 'hotplug' sysfs attribute that allows userspace to control
and query the entire memory region state.

The interface supports the following states:
  - "unplug": memory is offline and blocks are not present
  - "online": memory is online as normal system RAM
  - "online_movable": memory is online in ZONE_MOVABLE

Valid transitions:
  - unplugged      -> online
  - unplugged      -> online_movable
  - online         -> unplugged
  - online_movable -> unplugged

"offline" (memory blocks exist but are offline by default) is not
supported because it's functionally equivalent to "unplugged" and
entices races between offlining and unplugging.

The initial state after probe currently checks if online_type matches
mhp_get_default_online_type() - and if so calls dax_kmem_do_hotplug.

This causes the creation of memory blocks, despite the fact that we
should be in an unplugged state. This preserves userland backward
compatibility for existing tools that expect the memory blocks to be
present after kmem probe - and can be deprecated over time.

As with any hot-remove mechanism, the removal can fail and if rollback
fails the system can be left in an inconsistent state.

Unbind Note:
  We used to call remove_memory() during unbind, which would fire a
  BUG() if any of the memory blocks were online at that time.  We lift
  this into a WARN in the cleanup routine and don't attempt hotremove
  if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.

  The resources are still leaked but this prevents deadlock on unbind
  if a memory region happens to be impossible to hotremove.

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax |  17 +++
 drivers/dax/kmem.c                      | 164 +++++++++++++++++++++---
 2 files changed, 161 insertions(+), 20 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index b34266bfae49..faf6f63a368c 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -151,3 +151,20 @@ Description:
 		memmap_on_memory parameter for memory_hotplug. This is
 		typically set on the kernel command line -
 		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
+
+What:		/sys/bus/dax/devices/daxX.Y/hotplug
+Date:		January, 2026
+KernelVersion:	v6.21
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Controls what hotplug state of the memory region.
+		Applies to all memory blocks associated with the device.
+		Only applies to dax_kmem devices.
+
+                States: [unplugged, online, online_movable]
+                Arguments:
+		  "unplug": memory is offline and blocks are not present
+		  "online": memory is online as normal system RAM
+		  "online_movable": memory is online in ZONE_MOVABLE
+
+		Devices must unplug to online into a different state.
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 8be9286f0ea3..5dbd5b7862fd 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -40,10 +40,16 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	return 0;
 }
 
+#define DAX_KMEM_UNPLUGGED	(-1)
+
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
 	struct memory_dev_type *mtype;
+	int numa_node;
+	struct dev_dax *dev_dax;
+	int state;
+	struct mutex lock; /* protects hotplug state transitions */
 	struct resource *res[];
 };
 
@@ -51,8 +57,10 @@ struct dax_kmem_data {
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: MMOP_ONLINE or MMOP_ONLINE_MOVABLE
  *
- * Hotplugs all ranges in the dev_dax region as system memory.
+ * Hotplugs all ranges in the dev_dax region as system memory using
+ * the specified online type.
  *
  * Returns the number of successfully mapped ranges, or negative error.
  */
@@ -64,6 +72,12 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 	int i, rc, onlined = 0;
 	mhp_t mhp_flags;
 
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
+	if (online_type != MMOP_ONLINE && online_type != MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
@@ -156,9 +170,9 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
  *
- * Removes all ranges in the dev_dax region.
+ * Offlines and removes all ranges in the dev_dax region.
  *
- * Returns the number of successfully removed ranges.
+ * Returns the number of successfully removed ranges, or negative error.
  */
 static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 				 struct dax_kmem_data *data)
@@ -178,7 +192,7 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 		if (!data->res[i])
 			continue;
 
-		rc = remove_memory(range.start, range_len(&range));
+		rc = offline_and_remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			/* Release the resource for the successfully removed range */
 			remove_resource(data->res[i]);
@@ -214,6 +228,20 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 {
 	int i;
 
+	/*
+	 * If the device unbind occurs before memory is hotremoved, we can never
+	 * remove the memory (requires reboot).  Attempting an offline operation
+	 * here may cause deadlock and a failure to finish the unbind.
+	 *
+	 * This WARN used to be a BUG called by remove_memory().
+	 *
+	 * Note: This leaks the resources.
+	 */
+	if (WARN(((data->state != DAX_KMEM_UNPLUGGED) &&
+		  (data->state != MMOP_OFFLINE)),
+		 "Hotplug memory regions stuck online until reboot"))
+		return;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		if (!data->res[i])
 			continue;
@@ -223,6 +251,98 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 	}
 }
 
+static int dax_kmem_parse_state(const char *buf)
+{
+	if (sysfs_streq(buf, "unplug"))
+		return DAX_KMEM_UNPLUGGED;
+	if (sysfs_streq(buf, "online"))
+		return MMOP_ONLINE;
+	if (sysfs_streq(buf, "online_movable"))
+		return MMOP_ONLINE_MOVABLE;
+	return -EINVAL;
+}
+
+static ssize_t hotplug_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	const char *state_str;
+
+	if (!data)
+		return -ENXIO;
+
+	switch (data->state) {
+	case DAX_KMEM_UNPLUGGED:
+		state_str = "unplugged";
+		break;
+	case MMOP_OFFLINE:
+		state_str = "offline";
+		break;
+	case MMOP_ONLINE:
+		state_str = "online";
+		break;
+	case MMOP_ONLINE_MOVABLE:
+		state_str = "online_movable";
+		break;
+	default:
+		state_str = "unknown";
+		break;
+	}
+
+	return sysfs_emit(buf, "%s\n", state_str);
+}
+
+static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	int online_type;
+	int rc;
+
+	if (!data)
+		return -ENXIO;
+
+	online_type = dax_kmem_parse_state(buf);
+	if (online_type < DAX_KMEM_UNPLUGGED)
+		return online_type;
+
+	guard(mutex)(&data->lock);
+
+	/* Already in requested state */
+	if (data->state == online_type)
+		return len;
+
+	if (online_type == DAX_KMEM_UNPLUGGED) {
+		rc = dax_kmem_do_hotremove(dev_dax, data);
+		if (rc < 0) {
+			dev_warn(dev, "hotplug state is inconsistent\n");
+			return rc;
+		}
+		if (rc < dev_dax->nr_range)
+			dev_warn(dev, "partial hotremove: %d of %d ranges removed\n",
+				 rc, dev_dax->nr_range);
+		else
+			data->state = DAX_KMEM_UNPLUGGED;
+		return len;
+	}
+
+	/*
+	 * online_type is MMOP_ONLINE or MMOP_ONLINE_MOVABLE
+	 * Cannot switch between online types without unplugging first
+	 */
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EBUSY;
+
+	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+	if (rc < 0)
+		return rc;
+
+	data->state = online_type;
+	return len;
+}
+static DEVICE_ATTR_RW(hotplug);
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -291,6 +411,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 	data->mtype = mtype;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -301,9 +425,17 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	/*
 	 * Hotplug using the configured online type for this device.
 	 */
-	rc = dax_kmem_do_hotplug(dev_dax, data, dev_dax->online_type);
-	if (rc < 0)
-		goto err_hotplug;
+	if (dev_dax->online_type != MMOP_OFFLINE ||
+	    dev_dax->online_type == mhp_get_default_online_type()) {
+		rc = dax_kmem_do_hotplug(dev_dax, data, dev_dax->online_type);
+		if (rc < 0)
+			goto err_hotplug;
+		data->state = dev_dax->online_type;
+	}
+
+	rc = device_create_file(dev, &dev_attr_hotplug);
+	if (rc)
+		dev_warn(dev, "failed to create hotplug sysfs entry\n");
 
 	return 0;
 
@@ -324,23 +456,11 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
-	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
-	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
-		dev_err(dev, "Hotplug regions stuck online until reboot\n");
-		return;
-	}
-
+	device_remove_file(dev, &dev_attr_hotplug);
 	dax_kmem_cleanup_resources(dev_dax, data);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
@@ -358,6 +478,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
+	struct device *dev = &dev_dax->dev;
+
+	device_remove_file(dev, &dev_attr_hotplug);
+
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
 	 * device-dax range and return '0' to ->remove() attempts. The removal
-- 
2.53.0


