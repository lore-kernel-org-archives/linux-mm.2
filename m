Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 102B2D3CC8B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 23:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7525B6B0089; Wed, 14 Jan 2026 18:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70EAB6B008A; Wed, 14 Jan 2026 18:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9C86B008C; Wed, 14 Jan 2026 18:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49F766B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:51:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6C40140151
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:02 +0000 (UTC)
X-FDA: 84332217564.16.FE4DF73
Received: from mail-qt1-f193.google.com (mail-qt1-f193.google.com [209.85.160.193])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2193C140009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i0vkiBpQ;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.193 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768434661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TeEc8tQJdZv6wSmBwJwNJ7eg8WiARnEu4gZS0Yp4t4I=;
	b=IMTBCu+KhfwHPxLOgF+4n+VzS3NGai/O8R5+kQNcRm7mpn/rG1pOLqGXOz93txbwTxTvEn
	Fy3XWjUjBZj9gukDBxcc52rgmuQhgRWuUdOIb6VKA/x5ogL/xlLoLeOFvUA6xsGYt9SFU1
	xST7w1fa5+RCz/Wyez19iBZZ2PadsTY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i0vkiBpQ;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.193 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768434661; a=rsa-sha256;
	cv=none;
	b=Pv8A2SSdKB/csObkCWmRflkn0I6hd0JwLpm+ONeV0w+73PEPi+/i3cpxYPj1F3/FrDwUmb
	HBbG2W1X0hzDgU7qxbrn+KnvUUMLPtRawMwdcumFJHxkwh9ckyUCmN2fRQTGcz2ESyiw2v
	eWzjZ2SrNdwKBEMk4jCc/QzQnx2Q7vE=
Received: by mail-qt1-f193.google.com with SMTP id d75a77b69052e-4ee14ba3d9cso3925331cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434660; x=1769039460; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TeEc8tQJdZv6wSmBwJwNJ7eg8WiARnEu4gZS0Yp4t4I=;
        b=i0vkiBpQU8/32XbKnFuSXLmx5aCdpO4cdwU7zuJCw/GkXD8DKgCHDKW8z1UaSaYQ5Q
         8fNcyFSGUcY3jyI7zNXuf0u6knjNTAaQXzq6FNXi8gnn37pRLt64XL4kalQY9jl1CTgy
         pZ45aVdrR3d4cf8IbsC0EVxtt2K+1A3+YdSJj8RHZW6IgJuZWQyfGja8+FoptuqQKetJ
         dcVBGKis+ikGv0dLEFbYk6/QhGfVJBYIK0EhcEzZSkWyt18cpsrmdAywdS3Gk6TcQUPc
         1HoxRiykCr2uJBxZeo8+MOMI2FEV2067rWSeENCouZx6xdfP0IUKxYdCnV59/kFRnU0w
         D7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434660; x=1769039460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TeEc8tQJdZv6wSmBwJwNJ7eg8WiARnEu4gZS0Yp4t4I=;
        b=YKHRn7grRTrzpRw0XoUGv0ytrvOMgH3Jv8To2KkSGZOYeSAyHEEbEoEMGpVuFMC79T
         IEju0ZPlfwPI+12HZi9O3zrdCxLN8jABzFXKPRYWlRL+dppEeYDtW7CM+vLnHAWrfnlP
         HNLPp0ofE8o91peSgQ5s3pn/FbpNsYBfULi08YqDSR6tj/Kl6jDO+HEcDRpS5PjqG+H3
         e8oBstFSB+zUfg0rB74e1lcpnSl747BUq3jQiJpahIWawOttyIB6HlJptErsaOf4KMag
         DREyJ0xs5Wh2+NI/CBeSSrLBpqMV0XwQYQxgVwmQ/WQOXmH83biGPerbADMGzeAoM5No
         MBAA==
X-Gm-Message-State: AOJu0YwsDvaikFc8iGyPRl/3PDGz3zohiDIdLWoygmXEeYKPFkUTfWXZ
	5L2EHZ4WvKffVVDZ4l7RYkV0uBrl1M4dbLFMZyMKx5UBo3OTtk/NMQwYJukbtKOappYH2L0gfhg
	dDurO/fdIDw==
X-Gm-Gg: AY/fxX60brFZffxEdgCxUO9VBtR+uRg4ei8wiMQ0tM8FxDZF6PwyljoU6KwczR5LQkT
	RDA1mxxkmSEO/Zzg6hQ5B4U2SQokTJddIyYY7uq+J0XLUPPT3ys9IIh3OxAImBa1OyWGLoR3Aqn
	hf6bcM1CNG3cjXlIwt8xsC2di3WoYFjUw9jaMmY7jkjnDhkZtVDuTDIzY4dMX+tKgOzs0vJmnp5
	qLdCaMhRdJmThqIq6wSw1GH/dT0XdU2bW3OuC7wwoD/zcu1BwVY2q0ZT0cQIBiRIXaKaC7sU+Hm
	ewe3Mzl46ihilJdvRBAYGHGGCJaYcYFZIatsx1WiVCoUb6g3gM0rIIFEUGCyIrZZ6aHrRsYeMfp
	EMCTjU2IVY9UBPVnOwvmLX/dtiqhqx2WfXDlF6dtVGQHkWwDGKuzwI/GKN4Lrxm0U/ptM5z7u9m
	Pyz5GSQ97TFmcK5UZDBXcVdkEPFr5cDZoJ6BWan1PSnkTAZzfgu7pisOXad0YZKwl1gEQVeCC66
	phCkXC62t6cyw==
X-Received: by 2002:a05:622a:181d:b0:4ee:1d0c:15e8 with SMTP id d75a77b69052e-5014a99becfmr55478081cf.74.1768434659885;
        Wed, 14 Jan 2026 15:50:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:50:59 -0800 (PST)
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
Subject: [PATCH v2 1/5] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Wed, 14 Jan 2026 18:50:17 -0500
Message-ID: <20260114235022.3437787-2-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-1-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ocgauxufuacbz4wo61t645dq8r8m9zy7
X-Rspamd-Queue-Id: 2193C140009
X-Rspamd-Server: rspam04
X-HE-Tag: 1768434660-757358
X-HE-Meta: U2FsdGVkX18FTDHTiQVOFxCajzKrLPDiAGtC69hw+My0iWxxKTgHMorp+VNxf9e4JWdQz55NWJqdRNgGAskP6ZvoIxQJz9gZ1oZ1b3rgON3YaxNLijV+PQKm70WVI3Q3i6peQHLbFUStSAM2W0DjGrQyOqkgiPDeGC7wzUF0VRIvUUeNQpv2FbCvbK2bPm+CSnSYzuX7bL5luWMl1hVbAtLW9pcrYaccBY6+QOSc6CxffZgehBWY1DSdDrbcvlzxltvCFqDzz2xTK26vx3XNmE03srVeFcK7KAFNQwNtuhtTtnRmeQzAgMb2Tg6M/nTwle/Vh/VGYhQWjlLQXySrwLbNEQ9Uy1PIxnj2maOkhBBYnA/ZmsFSeroOXqsJYtprgrKzMeAbMSJRnL57XxHuEM6zcR54dRQRnnRe98twoe/Bcx7RnEvDuZpkpUjn1TRDr5EYfqXvLkoNDG6COVQIqjM/oO2UKUeRFx8CLmxTCpi7Pf0GfmLHDhYWdIjIYVRGTvfAe8rLLZthVAZovcwRiM8MgKU3Yi6/AnBQh+WSyzDjOCdvlcKTFji/YuiHBRP0AmQPBqYayHHLLQZFGnmj+5QswnvPCfNqClE83pcT+tEvfH2TRrbsXBbnSAe2xLJHk1MgDrHfQiG0m11jR9NfXLonLDcU40i3NHiz4/peNxlKE2/q+aHJl4D3e5ydYgTrgZuCmD9586K2CSLWogAac9ZBfNhGYtggj3nLgQTOL8Br0HaEO37YQxql1hIKoUcugu0Eu+UOM0tmbXqr1KtxnLRr+2zIhqp+9NakrjcnxJbIB2/gW/uHzppGxEERnHuZqxKJmpGmVmDIMW8k87uORQmCvuB9mm7pUYadC/CrQ7bJswWt2Si+gBOQnFkVyYAYaqDekr75FVGjSz+l6UrS/JVfI5sXTSCzLn7POuwBp+Hl3rp37ygeiOnxct2OkXkZwprCakB/x5q53UuCuxe
 Kdt5Eo3U
 bB7YZLI3XvfHBmrbgw62To1lVnOeDsf+Iaof0Lth+YK2CuvN3I2PvuclbDSuBXbKbg5EXJDfIub8lRjb/Rtli9qTOrOEN7NqzIvySoyY9pftd5ysbSO3WLbOICQhvI0gkUshfkiez11k1Xo4/CyzV4Oahe53ec84gsUh8YpqjImvHiRHbBdLpXWG0ojuuUCXprjsoNocXvTdFQFpiVvEoM609w+oiH9KfjJu+TyV9pUYUik9nQDGTh344nURAjbvF/NqN7pNGyRh+vAYrzuAF6uKSJsx3LGN/HaQdaf+oto3X5d+TeeCdYAZke3bAmzqCYcPWMGvEuxltzYQm6LLvaSCvO/a3ev9F3F6DxIzmyVLTRtsD8ndF59+tor7yWrrKhuJAfbWiMrDtOFz0qIP/kSEQy4CfY7OJI3Mm2jLPFkL6cnfHJUM9QaXqw+z25rz1xTYR5T61zqxTdz6EQlLzvyWUdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.
This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable. No functional change.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 389989a28abe..5718556121f0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	int *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1578,8 +1580,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
+		int online_type = mhp_get_default_online_type();
+
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
+	}
 
 	return ret;
 error:
-- 
2.52.0


