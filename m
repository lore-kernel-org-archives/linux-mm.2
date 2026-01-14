Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F351D31A2A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A093F6B0092; Wed, 14 Jan 2026 03:52:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA266B0093; Wed, 14 Jan 2026 03:52:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE0A6B0095; Wed, 14 Jan 2026 03:52:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 69E976B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:52:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1811EB8F5E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:44 +0000 (UTC)
X-FDA: 84329953848.07.369F0B6
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5CD851A000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BVohFndt;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768380762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHib3jWzP7kVcnP0SE1eJQabXI1WWwo6ABSGI/iwYvU=;
	b=2yZOVNHnPYz3SDqXb++OcFLKfBSkqpN8vzXSOGiiTPHOdKnag4xuvrFVz6rjbJamC0y0n8
	sm9fPYaco/gboNsggL73ctBu9XE84OvsAnGO7etw3vD1gEwpbTJ//zRSttfYSpTDutR93x
	h+a677rPIFsalj1glvAAs2DJYz3QiC8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BVohFndt;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768380762; a=rsa-sha256;
	cv=none;
	b=A2kdF+K56YOQ3/pFJr+jQzEpEbkcBh+RVmVLrW2ACw0LsgqFUYtVt08xspyLV+f9T+7N53
	1X77fdHesiA0OQsTkSfMA+ajpFfkDJ80NfqCo+XC1rln0qoHPa7bOuICowPdE+BHREb6OV
	qZXZQ0V9O8xmXPdTJl7rUfa6Ue+ohT0=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50143fe869fso12462941cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380761; x=1768985561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHib3jWzP7kVcnP0SE1eJQabXI1WWwo6ABSGI/iwYvU=;
        b=BVohFndtfW+7zkXMC0suOTiWsaYcjLdzwGy/QsJX8gptOWs1W+v/kk9GYr6dHZzzj1
         U9bgz8EbdFjDaiaEkW1iwxhfNDJGXyN2ivfg5O3SjPBAeww6iF0rw+RLC6DbfTVn3IZm
         u4ZPwNbZ4m8qceAQixTbs8CGm7eXtbYExbMVgYsl06nq80Ny9p3TkvEVEMwq5SIsC2y3
         txxESmc9AiNEigvER3S+7FUJDhXnlMPQjBEN6oyeGWGlgbeRU0QJw7H0px2VbQvKsnFR
         76Dim5FLUqHp0LooJSDnQOLaFk1H2EM3yPg5/F5gVZoke6li0i8i3xMvX4g0BnEjMrea
         bHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380761; x=1768985561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AHib3jWzP7kVcnP0SE1eJQabXI1WWwo6ABSGI/iwYvU=;
        b=LEJJ45R5w+BvGCeNsIRFmj25uDGvrkyfS/myWy8h+WrEoORqqyEjRip5hWUX2YQIrt
         K8iA6C8AfsN9kSEUZBUTHmC8v+eKgfDGhdI0w+NOb25EGKN/My6s2fDzRKfMA5EGUkSU
         x82id9vh0H0TNgRurLaVnCZWKspAox67Y7544wUH4lVvNd+ckFArEEcJebD28n+1Ue59
         i8eX2Pp/yLgYs26z7bkJi2YDn0kgPnPDti3mDvDVDi+oW7Pum5Hm4yAuVsZ8GQKYNd0K
         U2s7sQpope6gLs7m1Sxvg3+7f7jRcQ5s49/vM0abKKHVyYN+tlckEGCMghTSpz9J31gE
         dHhw==
X-Gm-Message-State: AOJu0YyJaZSeepP2lkrS2tPR6PCiX0ery7v9rbZ2LEIne0+9K8zG/iXE
	9xuorRnKeqGiBfWDvYpCLE6gcfaqOryK6pg2n7/CyvbSgJt9vVLEIFl0mBxQ9p6lVZtJG0s7tiD
	B2tyITF8=
X-Gm-Gg: AY/fxX7O1Yg1boOn4kg3aQoneWmT6Lxox0sPKu2A3h9Zz8isx37vlYwN2fpoFAeheMe
	oZfBTHaZH1IeUGqfG2s4krGU2Mfotzx/PZHJn1A0/HUhlriHNJ0LwZqP7zUY6OnrTucd3C/3We7
	KADiP23amakkqO6AEwqocswIJbmRSrri6CnHXUBzlsCLmxWBpj45Y9touVY2bFUUp0a9+eHVyaM
	LJPZo5alMLELV6nDfPTi3asiV1hmrnTayJ3+a47XO/ql87tvodYpFzCuYGQwfkYYJoO2wrXRgZX
	MNyRULc6S/i2sqj2uxuaRbxMjjw6/EOW6xb1N4eA+3x/0xQVcBFseTivY5KXAf+TMz6rXkLFaCn
	VO+eTcjQNhS6IIijmpRCig7ZhDe4Z1sdrWzgUJGUUgnKynTog8UoH6H1AF0VpCgPkj8HGS4xdJ6
	s3KS85RzqA2LH9hYhmbcn7h5KFDjzMpWlDzpJgfOzZiLJQf+YkjDdxXM11zp9qgdW8RmpxztZ/g
	Uw=
X-Received: by 2002:ac8:7f0a:0:b0:4ee:228d:d6b8 with SMTP id d75a77b69052e-50148482933mr21948301cf.70.1768380761194;
        Wed, 14 Jan 2026 00:52:41 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:40 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH 4/8] mm/memory_hotplug: return online type from add_memory_driver_managed()
Date: Wed, 14 Jan 2026 03:51:56 -0500
Message-ID: <20260114085201.3222597-5-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5CD851A000A
X-Stat-Signature: kemp366cdgm67w188j9xhu3g5f6mapa1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768380762-28403
X-HE-Meta: U2FsdGVkX18gxSO/pV9dWdW7cEsMQwAe9ZpI44MI//95hCxjWglWCS6keOwW3nvdgqyOwXOSeCAb7+s119gfqu8xK4/EavMbeXssguRJKZ3UZF3oP22b+IsBzpCSzB+/SRL1zanA0tz3lhyjpkwV7ENq11lTaemxy9xJEUQMm/oLvygltRBZW6Z24ycSK0GRuI+zu8oDg9Z0+qoleuNjjryaqXbsrQeaxIJiaCbn7QAlizlgnqsdylA7i7Lj7vfxa11d6wfhYsLevplf3qcvvzdIVrR6KJ+fb3TrWZJ7EF+AoyEsXZCdW8ct90gcVO5ZFMxuxACK1Ne5OXYE5dTrg1SfGLdH32C+ZxVm5J/WB5L8eqayYmkTi4EzV48u+fM61IBG/JPLdWiuZitd9UKu7w9oQ4yOM1YX8dJW4FsOpRu0a05ki/4mjh2woMb7K4gKyGggiECLix03Jbgg68LBs8SVRZT1tL0T7EOixsBAOJUrFSD0Le5/GiRqmrIOoTkrdrcJVvcDYoD3NuHIreqQJVD19s0Bi1yYeZDuNgvaA+6lk1h16QghFwwuoGyWo6wp2rd+lqZVWn7bdlreDtVoZImiEV3Qngk+Ig+pvQRXjrBZ51XMcw931jUsfvBPZebEf9U3C8sLl07IwRNUCoiCmlIU3ouseMJPOGMdjl1yH9wHapcr8Ye4EEP9uNxrPQmE2l6dnoMSKnYqIr1CrpxLicYvJ9boDY4Il0ae9StSHHI9irAE2wVSwvmwzhg+As09a2r3jTkEmo6kh8wo0zE0LcEyS66/eCOgMYr87qcxTfsrewxpwa4ePSjVMehKeseT6PBksIbAiuu2U6KD4h78/DTyJs6wh250vTXNQY/XrSfPuDB5Mnv0p+CwpbtltjtFF9b/oxvrl/EL1WUfDr7aCq5vNVrrueO+I4NbtsKTM559IzfuRBAWIKbAI3D+b7AhnAybLwbbP75d57JD+Dn
 7XmdVvIh
 sP881x+UA2sndjsB/cZP8lxJ0sydIcPWLIrB9QI2+MdZl/Z0LhkYagVR96tCt2Z4ZnB5OvYSEYwzm/ISkp1vFY38KMx6b2fSPyDhrd6dcMm8RYNyH9fMWuSKCo98kctERFPnJ+1Fdu+evLDzyj8hrhybQlWCjZ1kUQAQXNSOU1+mSzJqIM3amJUKzvgF8fRZgGGtRK5WX7miRjRCQK84r0mdPbVDAp5Qo4ItvBXMiWhFRVV+fsn6Z3Zh/FgWt/gO+mFQwFqt2YEdFdiCZ+3v5cUnY8/BX8UW/CUxaz891w1rL+9cBY+BYx6JohJg0P8+ctxRhkDxz4pcWxoHX0tEjfsdH+RpeI8oGT5Ks
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change add_memory_driver_managed() to return the online type (MMOP_*)
on success instead of 0. This allows callers to determine the actual
online state of the memory after addition, which is important when
MMOP_SYSTEM_DEFAULT is used and the actual online type depends on the
system default policy.

Update virtio_mem to handle the new return value semantics by checking
for rc < 0 to detect errors.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c          | 2 +-
 drivers/virtio/virtio_mem.c | 5 +++--
 mm/memory_hotplug.c         | 4 +++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 5e0cf94a9620..d0dd36c536a0 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -178,7 +178,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 				range_len(&range), kmem_name, mhp_flags,
 				MMOP_SYSTEM_DEFAULT);
 
-		if (rc) {
+		if (rc < 0) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
 					i, range.start, range.end);
 			remove_resource(res);
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index b1ec8f2b9e31..4decb44f5a43 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -656,15 +656,16 @@ static int virtio_mem_add_memory(struct virtio_mem *vm, uint64_t addr,
 	rc = add_memory_driver_managed(vm->mgid, addr, size, vm->resource_name,
 				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID,
 				       MMOP_SYSTEM_DEFAULT);
-	if (rc) {
+	if (rc < 0) {
 		atomic64_sub(size, &vm->offline_size);
 		dev_warn(&vm->vdev->dev, "adding memory failed: %d\n", rc);
 		/*
 		 * TODO: Linux MM does not properly clean up yet in all cases
 		 * where adding of memory failed - especially on -ENOMEM.
 		 */
+		return rc;
 	}
-	return rc;
+	return 0;
 }
 
 /*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 515ff9d18039..41974a1ccb91 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1689,7 +1689,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  * MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave offline,
  * or MMOP_SYSTEM_DEFAULT to use the system default policy.
  *
- * Returns 0 on success, negative error code on failure.
+ * Returns the online type (MMOP_*) on success, negative error code on failure.
  */
 int add_memory_driver_managed(int nid, u64 start, u64 size,
 			      const char *resource_name, mhp_t mhp_flags,
@@ -1721,6 +1721,8 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
+	else
+		rc = online_type;
 
 out_unlock:
 	unlock_device_hotplug();
-- 
2.52.0


