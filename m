Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA12CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 06:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A427C6B00A0; Fri, 15 May 2026 02:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A756B00A1; Fri, 15 May 2026 02:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1E56B00A3; Fri, 15 May 2026 02:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5736B00A0
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:53:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16894A0686
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:53:41 +0000 (UTC)
X-FDA: 84768738642.22.20F3422
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf30.hostedemail.com (Postfix) with ESMTP id 722558000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:53:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=eWh4W5Dk;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of 18810879172@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=18810879172@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778828019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phtXtH/b7pmu/MYZQmnQqSvjMn+s5tmARpCr3vOVuKs=;
	b=Ebh7sS1NjWuIviuTCaj0YTLCgxnC/aNha4sAMb83lHi4NAEq5f3JJRqQkGzic1ouQhmc/z
	Wm/t7HgxRZkU/iMlSl3vgUujmyVE2xzB6PXkWlzHEtfTmMjDyqGcWdXTGCYVL4v6Dt665V
	GCSOecPctsQ075KD86zIR8U73ePV7Vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778828019; a=rsa-sha256;
	cv=none;
	b=xRWaA44qTAV/6nylPdbV1K2MAzDuDJ/W/AS4hEe+pb9JmqrnrmmQjIeKISseVDLKM/WWVe
	1xQl6BHWnRZYAnqy8fUkZhnHfWL+Ur3K8ENQVvCiohuoLA9qgUQJNHccSXOXCnLATO18Ic
	Ce0/WjJ50Ry84BrIadcDoSuTZB0uPNQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=eWh4W5Dk;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of 18810879172@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=18810879172@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ph
	tXtH/b7pmu/MYZQmnQqSvjMn+s5tmARpCr3vOVuKs=; b=eWh4W5DkZV0NzGOJ4h
	JSGd3kGnTXU4mO4p5o9fwj2e9/LbDCoYTCiDDiGQll2N5kUG5TAotzcddiRiOpnk
	8f1RVJtFzI6RGh6GerJC0/HFmcWkiPifjn5J4Apnf89S4GeaVpYvrYqGV4d2I3wj
	NJ/1o+6SUSjz8WYw45WuBGgqs=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wBXDpTnwgZqtc7KBQ--.2204S4;
	Fri, 15 May 2026 14:53:32 +0800 (CST)
From: wangxuewen <18810879172@163.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <18810879172@163.com>,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: [PATCH v1 2/3] tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
Date: Fri, 15 May 2026 14:53:24 +0800
Message-Id: <20260515065325.4009527-3-18810879172@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260515065325.4009527-1-18810879172@163.com>
References: <20260515065325.4009527-1-18810879172@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXDpTnwgZqtc7KBQ--.2204S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrAFyUur45GFWktFWxXFy3CFg_yoWxWrg_G3
	yjqw4vvw1rArWvy3WfW39YqrsYyFy29F40yFsxZF13Gas8Gan0qF4jkwnxta43urWY9FW3
	ZFsayr98ArWjkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRE8sqJUUUUU==
X-Originating-IP: [39.156.73.13]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbCzQwI-WoGwuw05AAA3m
X-Rspam-User: 
X-Rspamd-Queue-Id: 722558000A
X-Rspamd-Server: rspam04
X-Stat-Signature: zxx71rc8az787pok9aqszirotpbye5om
X-HE-Tag: 1778828017-104128
X-HE-Meta: U2FsdGVkX1+Vy4dcSn0gL/ilD2uE5AVFQBxp+jQje7KBcJF+Wtmdd5ftqlIYEOSoDvqqHjJ+yX2vX0hrRvfAI76F5CGZmi2nK4Ejz4IWAcs0JNmHH72GxV2eK94DP/g6Il00dCxnSWCAGd1Sq9RAA6JEgFn7thmoIMilGFKmdggifDAS/2xYoZEyED8pastZttYU0pw1U0lo2vCHC7UkeReIs0032YQQ2pb2cONFAOm9VogJpg5GeZJ3Sou0Cu1szWed1IVOAquX5LTB18lhJhXFrit2mrBSS1OLDQRsnl838c9yZ9Tq1kPRYUlg9o6k9XX1OfeX63YSjE+LuG0pm8N8ajgNwAV/jjzLZjx+zEaYbxF2XZXyvwyz3jbSuLfauH9wtgavfisOAW4rNzaPzv6tND4kiClP/D5m0S6R3kfdaeabTf5McJ+El4r2zdz/Zk43it3Iqs5eUWWrIFu6xOJlR/7i8FO0gMSzzdieRmVcnyIyxiORoKmKNgTHnCuS7vPULNDZnmMNJrHXR7JhlK3HjMEiZZlF0H1e4y+U9cnVD6tKBQyGwHv8JntODtR56lX3v60BI2x/gNesjR5ksDUi2Oyd7Xk/exAvcItQ+YE3p4HUS7kAihVYm3CzzxdOmRey1LiSIOiMcNiY3eX4NJUswbcBP3GtjPVCQLlAJaL9eUkKGJ8sfspDPTkL6vZs/nALqAevNBDjJytoHVzFUUDVHs3fdLDz8udpvpL7zZANK7yfmR8CyY8DWiJZW7m8Ear87jpCOvpVQqtKYmur7gDt095nwU/m4rj/M7W34HrfdBQ2KKrTK8ggSis733PoZghe5+JQe4Zx2oZaf69bURNAoiKZTfehoN9NH8DgwGFcx1Cch8GUoT7xgoo/DbYyF9ZRDO/D8VUNW41TyVh7OxyMvplc0rxa2ZIVeZhC1PMTPA+LV8KhwGGGrOgvbumNDKB9OfV6OsRo+3195Lr
 sj9zptXz
 l5ZmgBIslGAV7bMNdm53Vpli3faqNZsajR3upHZ5+8NHE3B9Ba/spnYmDXK84htBhatAUK6uLYXBhpYYsmcQPBM6AnuqCfsCbIjHhR6vqAwLRrYv3uAgRGxYWeGPrGp6lpLSQ8eHeka94bdKGNtrrsQDWm1qTp+H41v0bV/hbopSMfHEDUbDgNGxlsarSD7IWH/lmUxiwO2C4mW3O6Nu9CCjh7Bt3tCClsUHK8qEm2eX8g7JVr98fULAOERwYJknJC7eE2P7/NttWSaS0ehpe3D8ey+C1VgF4h9Sscyvv28mdOJ2RCXHqwdXBxV3Gof/NdITevN3glIK7ClnJpdco7T8ZxfvN/x0SLg1XQiVnRLQz9MEUoEG1WLXmoHLXeEXSPJ4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The assignment `x = NULL` sets the local parameter variable instead of
`*x`, which is a no-op since `*x` was already set to NULL on the line
above. Remove the dead assignment.

Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
---
 tools/mm/slabinfo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 39f7eae7eecd..ac00daee41d1 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -194,7 +194,6 @@ static unsigned long get_obj_and_str(const char *name, char **x)
 	*x = NULL;
 
 	if (!read_obj(name)) {
-		x = NULL;
 		return 0;
 	}
 	result = strtoul(buffer, &p, 10);
-- 
2.25.1


