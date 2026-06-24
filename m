Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA12CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B52C6B00A8; Wed, 24 Jun 2026 10:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3066B00AA; Wed, 24 Jun 2026 10:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CD896B00AB; Wed, 24 Jun 2026 10:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5F6D6B00A8
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:58:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48B9F1671FA
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:01 +0000 (UTC)
X-FDA: 84915111162.12.C1EBA50
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6AC72120004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:57:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gX9epTvb;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313079;
	b=DnCwn4pdXBLPt9Ds2rV6m0uGSW+xXsKQviKyd/hzDTOewMz8i/Jl9EJrhAApQJbZjxx0Ay
	CbWMLhfxUnID1ZOiw4BxKQNVODiqEQScT/4+xrC1gpOW0zQTG2xysyz72c6naluVyXRqWZ
	oTKTNp9jRlCzdPa4Y7AVMDlPP+oN8BQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQoqst23Sd/uqsFRXXVKz4Ck7yyavMrD/eBg48X+nsY=;
	b=gjSPUcFBrAwl2niFEvOw/DjXTJg7cgEY8XjP0p5Gig9mCUvmiwYdyoWNmi8qn3iv2hbavU
	ab8djl3Hex7nbiwlODNiQemrYrsKgfsitZ1Hv0/qWZ+ks3LridnKrEyHbYA9+BRI5a/Kt2
	7PNA7n4ePfDJpd00qapTt0S66QlnNbo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gX9epTvb;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-517de710886so7802531cf.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313078; x=1782917878; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQoqst23Sd/uqsFRXXVKz4Ck7yyavMrD/eBg48X+nsY=;
        b=gX9epTvbU+ILMqflt0F0+5EKxeLsqA/1wDQqe02p41XLB52gLBmkzwGsk9x78NMuLF
         Jt7nT2Iv5oKPuaiG3QHlIDn3efh7g6uAUMa+iIBh0OYfmJ6Xf6tTuqAHnDf8vjMcTDCa
         XZlGqvRhbSv3X0ydn+iju/NOxGITTgcR1iNq61SIx5DKldyBHKMpd1525yfq3FEe0leF
         FJIt9QhAlWqIFkVa4bWASkv8PggGg4awukyyneOoGxDLEkVFJOfYN/QY/Qr1ndiyuhVB
         PVl4V1o69xJHaV5e4vLxL1wd9j3HI5UgHQ9MLEl3WZh2tt05zp9Sq3TdxSLbpXahsevR
         Cu/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313078; x=1782917878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UQoqst23Sd/uqsFRXXVKz4Ck7yyavMrD/eBg48X+nsY=;
        b=PfEDjXvrUQsPfsBUgGMRp7XQ+refARiTzXmsSbl/RsMw2BQOxWZCYy1gj4bt83WXdF
         8v3uKY5KsjY+ApsrX8M4hyzTQvj3B0fnguNWqlD48xMerlH9UFF4+o4LUCz/9opCOgHe
         06nJ9hwhnLWyDZLAnHp4HGR/7xKgP5X8X1iczBjgGp+4jw1PyxQabnVoIT64hyGvakbn
         vL91TZ2VVmNRFKdGnc8Wmm4hP2chKChwiYqAGoyW2QDYx2SwFKKdPTKuHkEFtkAbEI8N
         zG5KsytLOM65tN9ZbfoTjRjQo9iA4miu47NGbBv/9tKgAg7M713oIl5EzfglVGuKsyv+
         x2AA==
X-Gm-Message-State: AOJu0YwFzwcnqgtsJQIQxcJmR2XweZe73kWcrMO+HyTobZHoi+IOuTiS
	QRuvKDaGxdUZqVRJVndzUZpvL4rwCBM/ZQ6BQVmaMPfVsC4ZYsh8YyqkLkRbkyFy6xZpadrhCHI
	966Gz
X-Gm-Gg: AfdE7cnAsrV4dv2hoONumxNg2vyeA3RqXXmnHkp0ru+UkQgWhjc8V95EUp7PY8sx37K
	gJBseY/d1f1qwbhVvLMUrT/4zfAHsPP+Zsc06N1ut1t17v5vw+0mmPZ8h82pdq7avz7pHEvOHDP
	IaegKrbPFSaEyHwcQG2/3TSU870y8+MA9ZcyFW236PVd4QXFvHkD+J8p16gA+lW1uWRa+5rqmTP
	p/LaG+6pSeXl9BamoUY0JWoAWlPi8qih1Eth369w0vHIiI5xWXGAlTjJMpnNBIlTzDxJ41ABZm7
	LVNlv32l51mOoW3bKdVb5JJV8+MSfUuIDUwlnRMGP2c97bE1l8No091xZkNIhCr7+p6FUXx0PH0
	smxv7uLS55eZmyb64H8JvQH5GMfSGj1Y5RQFuCR4vumBimucS4wi/jsWOYkrZ8Yb59UalDDdrdo
	A9eM3LtaFfij3aWkMfMT4xvkP9O5kp1Ci9fo60yvhOEJAoMdrkfcbb2Azpy4HF5+H0HCMq03aod
	A==
X-Received: by 2002:ac8:7dce:0:b0:517:7e26:36a9 with SMTP id d75a77b69052e-51a5485b854mr12138801cf.39.1782313078372;
        Wed, 24 Jun 2026 07:57:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:57:57 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
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
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 2/9] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Wed, 24 Jun 2026 10:57:37 -0400
Message-ID: <20260624145744.3532049-3-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6AC72120004
X-Stat-Signature: j3sgrapoh63i4mbc9wynr9ys3mru4cor
X-HE-Tag: 1782313079-270730
X-HE-Meta: U2FsdGVkX18/4Tc1Yn4mMjhg635FgRaPeir82NNVCtA4tn+iq2Opz8B9aycWh2u4g/kNbOeudTB2lzqRb5NmlcTwtsAQvH3UbBOiQZ3g4ACW636ANH/MifYpPHV7IKfmphLYv/gyuSMV/CG8c7LXs1qa8JsAt8rHzSHImtO6t1u27+bZyUSvSx/9x96Jh4B1fUcmTOh3uZRsfZFQoAW7yZ3Q5ztCRpd3pi5RdaLyVrnDz/tze9Omy4q2w+gZ3eYodtGtwfOknCfvoJ8iK/D/v9GQuKdlciNQTXYchD2W7mcoyDUntgZkKjP/2WIHxuoz5iYpGEiaDDGgtJ1jEIGj5F5sj8DC7ZITyZ/nx6tSm+3mB01NMvyFerGYZWVw4ddwSVGrvBVEtpZZ1qtxFNrNdZlw8rEu5zi8neL5OUMF0BCeoEDnpNDJ99+gHRLqQWszf0Bmzzp7ZYDaOjKH7nQUOOFpX3wmqlKj6twmS3JZuVom+pR1lZVrdssUe3yCPvenQO9eJ/lbb3FpPztE7bnu9j3wQ48YfpUwcOISLdeVKx1NPwYqkTSDX+MMRWiu4Y8/ooDxJ9pxoD89GzXtZiHsygyK3tbRy7x2/43hzHwm5bUJDqo4f5s3D5MfmpwSveXq373WfLe76gbF3G+2v63pyQnHLFh7ukziNPYteGap+WYbT2W6grybqwe0IwRquIDX9NiRx6XLdIjAzGzoBiSTw/OEJH54KYoZtiE8gSOpHXhC8eJ0a7JFtqhLUpgyK8FF+leZNs1Kkw2HWeKSDMgHrWLMEJ+mozRTO5cxtjN+8iAC1eCRWtN11voDaXNdbRDEfCbqrSFL0tY+zDW6BkEMay00krvVjBDLIoHnezVKvRrsfBS0zsSyKCTxYr0fgHx0uEcKTygmHb/ZM6UO6druxq8swFB/KrtuHJq1vyXNHaLHiqGlrSkOm9Gw0iKKtclAcXDOPi/IARfMRksEcHw
 f9XJhZIJ
 Yx3GVt2Iu6PjPEBVLCMu6biMJHRzAly7EG8nGQ35NfOEJTsNe2/u8vUrmLGtlMnaostRDc4oIH9Rldkz2muH/wb1DY84vxRCsboNtTkuNisAD+/6Ipe1an2yfuZGBgpKOa9Rz3aJfyCierMp/2D51xZrJwZ6x3CMq7Ho0IMFZZD6uduA8y1ktT9GrHfMw5mwzw+wIBvZ66OoC+e6E4tA2loQu0MtCMSF+wwD7NJ94r+pZbbngu0BEgl0SqZ4pB4kN+8j/9KrudXqBTFDYTggWukMR/IZ+VcaSseM5tL4YRikShl2d71K0K9Neh0gJD6h89hfn/OkwI12A6GXhJ8WGGFnxjNXbX6yx8BbjDMharCRazDwv7i8h1OPQVQ==
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
type via a local variable.

No functional change.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ac19fab2263..6833208cc17c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1494,6 +1496,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1582,7 +1585,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
-- 
2.54.0


