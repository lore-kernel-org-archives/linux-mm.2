Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F56C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7D66B009B; Sun, 12 Jul 2026 11:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFD96B009D; Sun, 12 Jul 2026 11:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C68F6B009E; Sun, 12 Jul 2026 11:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7FC46B009B
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 623CD929FB
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:30 +0000 (UTC)
X-FDA: 84980549220.27.66494D5
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94D3D100003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k5jEu0RA;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BguinuoorksxpsezVhTMBAsbvTRcZT92EAAvPgOWJAM=;
	b=gG8VxNU/ZmMArnJPyktBAbnkrcCkPa+HPt2y30bxSjK4LRN/wwriIkrXC/lhfzfOZ8z7Wf
	v+dwNxKKRgU2cmzIJ9uTOCt4/+siLfckYPBrm+Uia4sSKNrymZ8Rj9k9uhYmqJ52LTfLI1
	t66L3HxeAV3mmQjxGn0JoDXixVeIWdk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871128;
	b=JhHGwV+chSQ6IiKHoMA0sUKae5OD9mfg94KP0M5Xyq5QtuNmqsgCk7BtOrHw/6Esy0Y/yT
	INs0e7fxj/9cDrbGgTG5+T11T0wFHKgWg1DMdIEIpUD43/YCCrwfHLjxgbp6xIaanGnOAI
	LojVBDdqEPKtpetakt0PBnaUlq6LQ6s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k5jEu0RA;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e512a9a6bso112856185a.2
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871128; x=1784475928; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BguinuoorksxpsezVhTMBAsbvTRcZT92EAAvPgOWJAM=;
        b=k5jEu0RAUx/AwIu3ku6DlTg2rFbSGoUpG8DlZelMgaQhZZx1uf3lofVOVAp0ku5NL1
         3/jVu3tx4XfP/xbd9TI1vt/UiaGsy0yz4dDgRMn204gLio0kw0GbdkGgL+MwNWqosiZ0
         dryKE3Y+r3/IwRiOSi1ykUPuQmO6yqgi97vKhNUSQ9mJBnSDKB31ArOwG1tX3Cy10oGF
         GcnQxSImNWq9PuMwclHbq09p9ihqQH5K935pts9Sv3dAMbnrz177ed8KdznXsuvFAfNH
         2L9L2pfxkSYr7L6IrdzMbbmoUzmwet+agbWVacGhVfupbwj5VqrkqtCfGpA3vom2ZkQE
         +diQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871128; x=1784475928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BguinuoorksxpsezVhTMBAsbvTRcZT92EAAvPgOWJAM=;
        b=A8jI8QZtapADa27qDkm9lN+Kn9nhLBO5PilLJ6RKY+DFPKhbnzxswR3AiHe4ZbqOJ8
         q8fHLG7YBhtctTeUP+FmXn9O1HuL5S7rlzKjXhq5M1sJG6/yBo60rf4MUpFK2otFKfNB
         gd8dvsx28BjqPtTQ4rqFSKhaeE2QMnxDwbv108lglKrYpr1XAoxMOFqXPL88PKYvi1yo
         kuQWuUpG04MOh2aJpMtkjjDGTNF+QbRoieOvw7ugcJGsTPffGDr9HajxUbHjAB3NQa4v
         SHO7cJTpogOPQRni70fsEGKZrMItBKtEgXDdii83dfillfMVNFxeuCqgJF7CpkGkPIz/
         Yh7Q==
X-Gm-Message-State: AOJu0Ywsww6QEaKmwoc1MfMo9g92TawtrNeZPE9OSDcf/FWY4WhCRo6k
	oQPWzav7CJIMKNmbZ+/FAKTEFyy0zw8tFgWx+nV2gw92Q3358qchRPV1meY8B7Z2vsi3ppJOTXB
	yOUy8
X-Gm-Gg: AfdE7clK3mY+EgIJzAY7wVq7+FRbU1AE+EIigT3+fWDebbxnAcW0rsio/lHMkoHb+Nv
	26d3IldX3TCF7wiMUXBdVHCpcHvkhrIWS+XdIQq8VvFqQtuEImh1AHY/H1ISqatkR2m1XvhQ6NU
	hCArM4nZU4Uq+w6wCX70sUoiSpkaa0Hy9cRFQ1kkgwlqsoefXmliiQBZI9/Ais8wdu/V8jghFt7
	hBuoGjPw6+f4IkoDf9tMcWzeLTEaHDOpk7ZLK7zMzd8RDU3RzOC9TWFeohgEoU2/2WZUQx6+SNC
	eBOaR1c7Yq1axnMJAgLL9MLtTmTj2Pzrrd6gZbKYKvC3MGkuZGR4sO6+DNvesGo9hCmTtYhKO7c
	GT0rY2Y+208OqsIelfXym2zQYZ3CUmfhmpDAz3It5OqmqF8/8emq+3Vmg4z8FgdsMafgwtUMKAZ
	fOtaE+lWdVtzC23d4xLUir/9MuGYENiijMKEjsZRzLcM55gdodUVUuJ5+fG/uvAeDEzyBuckjDV
	a33PkN2sbXP
X-Received: by 2002:a05:620a:400b:b0:92e:c117:5ed3 with SMTP id af79cd13be357-92ef2e222a1mr610227085a.83.1783871127659;
        Sun, 12 Jul 2026 08:45:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:27 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net
Subject: [PATCH v7 07/10] dax/kmem: resolve default online type at probe time
Date: Sun, 12 Jul 2026 11:45:01 -0400
Message-ID: <20260712154505.3564379-8-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94D3D100003
X-Stat-Signature: rsxsggjbsntdnqbh85okz4rodq8nta5m
X-HE-Tag: 1783871128-819314
X-HE-Meta: U2FsdGVkX18WTINNRH3bGijGrreHyFshbfWRlkJmHhU3t+q/U6NbNoHyVVCy3JSASo0ugacCxXelqscXF9Gfhl0ZnUTWx9L91lO/5B9cG1TFL0Bn5gvXrEOcupRJyD2+Ig9fEbmGb+ZgjvhtLrryix6wtPQkdCp0AFqLntFeCoIr5y8ue/GNhcv3rMBYXx0RiMeB+nR1xcZ2nDpCDp697SkiZGPTi3wETmKPYyML/QKKZqTvpfV8kye8vs1N5BHtKC733hbPlHn20yZkGi7ROtCt0RcVa71bfLh23BJPMChuhSDHrv4aIUR/azT2uBHLXi1/wzlibKZfetXXUmlehjICAiISqgxu5IAIDA8rzUSTM+PLjYTjTI+Mog32JqSeCJqREIAOzsLx8TisPxQJzleV2L3gKYwSNQJsCX2zDOONBXrPlK5XhS+aCx6cGKiafiOKlfvNpwdZeMcwMpuzjpXBsXqL00wwJX1X84fRvZVQkmvdMbzVPugTq6CFuzErupTUQXZLtl9JTtyN9m3OB897XS3rXQ0udsLR09zrNA/fDxACrKUKNVRWHgJF68w2mFZG8KbXySwqdqctsnntE/5EAYIGV6QXqZE3byIQSOV3QzxOi9hL5SK/KxKAZZtPVp7HbznQEfIqFQJ/cVj4CtLIDIXZjgB3FTDU8bSiYd0RsRxGoDxvdM/GHR1TdXpqbcHV/d5sn4hMrah/OBePNaoSyv0nCcj2D6PwabxxznWjp679OGIs3u4V9XgbQt+9jSFITWjfBmAlMFy7jhrzvL8cVwRrkdEQ6HDpuUQZoy+B+p7qDgxcCsjYkW+i8XXLPEoPTLdsGROqrgT/9kzYKec8inwAaDAEkGyM3HR6WBCYK2hKrRYF0cx7c0Ka0kVFGwQuJtl9pUB8x40AQvOo7unhcyBaZtx2ptqfJZjkueIjMOH4vUP1K62jrr5tr6WvDlU5m5QWhTTfAovD74c
 I85BZBn7
 +P04j1BsPL1/KFH/fDBFtQX0u4Lxl3PBUU7FsvcGcDxaKzbKfG1YGSl5sVshTPBZIoAtqBUciWBZ2IhNC1ehsE4ivMyBl5pamjBAgZN3fJlISRxNCkzP1BvOLJU4USXWxYGYom/k69cnnxdC5oglAbYIgoClKNRJC1kTsyQLBeQvGguE5op1sFsJIYLWIvvYtOZOpC8PiPQPhqigIhSlBjLnzPq+L3ZS3fsc2L3qtEmVw9rYfx4KJD7vDqdIWL0FKBFKsfJWZyMoYxbylf6wdzpc3ho8lef/3yCbCRVFhbyCwKHbaNJkEG2x7/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve the default online type in kmem at probe time explicitly
instead of implicitly inheriting the system default by calling
add_memory_driver_managed().

No behavioral change at this point (still system default).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 592171ec10f49..38ed5c4e9c83d 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -73,6 +73,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	mhp_t mhp_flags;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
+	int online_type = mhp_get_default_online_type();
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -172,8 +173,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				online_type);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
-- 
2.53.0-Meta


