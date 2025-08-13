Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A47CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 07:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7A38E01C7; Wed, 13 Aug 2025 03:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78A68E01B6; Wed, 13 Aug 2025 03:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B673A8E01C7; Wed, 13 Aug 2025 03:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A31498E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:21:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4974E1377AF
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:21:15 +0000 (UTC)
X-FDA: 83770888110.25.960855C
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id A50B34000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:21:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Meg+jr0z;
	spf=pass (imf07.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755069673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iMAgZiZKsY/zy72157yBbDBpwMbZReCDi6Q1sd5Rl64=;
	b=ZhV7Punt9j9HkOKdtmOQUMe2WKuDQjN397JI5t+eIm52b9J+f2p+v716E4aM0lPiu3GIxf
	+3on/a6KgYeEmM22aVbryvgFrzznZu3RSIU+Pf5Ky02UE3zxMmHC7dLmuYR/39d3rjBjjY
	mzuCuOfAWP0Ce6O8oLvui67mAswARxU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Meg+jr0z;
	spf=pass (imf07.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755069673; a=rsa-sha256;
	cv=none;
	b=fRcVQeZIikyQVn2ebYlSNO3E8vdCmTb/PP65/9W9zH2nuK/39xed5NHGoG2j2Vtal/EmFs
	/DBGrCWRfCYmvMI7ENK/fUne9gLmjMAvaQpurrj4NOdxEkgjDTwlbjeFrhP+YQvXZsVY+f
	yf1kmoWR3IvjNIHTI+oEmaFlQCuKZgQ=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57D6mnOa030519
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:21:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=iMAgZiZKsY/zy72157yBbD
	BpwMbZReCDi6Q1sd5Rl64=; b=Meg+jr0zOlZJd1PsYoceJqHpAyYvrW7GI8w67h
	kRWQLGD/bVsqqQQjRK8bpBxFv71Q8tJY1QQ1GVXcnJpvINnvSs4LENxGn2tjXzro
	+Zi/yTRxMVGKfFmDA7uJdSS54pMUzrv340eHApNqQ0X2Tcm8qfc1AuTU8pzS/mXy
	Fj0irTUCy6Yi/iHb2i1OXlG6SElJwh9pNPSZhR80Jst16INGSFNKrRelFyWTVPQF
	SoovqgJUENIjSfaCXi075pgkM/bkQRsl1ghF6Yc8fF/Q9D2XU5KHg1q211n0qUgC
	oNaFXdepu6HmrcDbyJQLllWWhYA6uLYdRrEqwE52PYG4Ml5Q==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48dy3gautf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:21:09 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-76bfc40bdceso4291332b3a.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 00:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755069668; x=1755674468;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMAgZiZKsY/zy72157yBbDBpwMbZReCDi6Q1sd5Rl64=;
        b=CclmwElEtmtvDfelo9nkJdmIDO/DBPh8LDnBbZowd63+VIn92zSu52BjpXo6TM66bQ
         93KHC9JDrJwTAgyz17XrePtf986ln3MjKaYumR0AOKI8nrIkdlRr3YC63ku7GlnDwrzB
         YdQBAEcJk4idlSD5x1M3ygGkz4vTuOhhG72knuxbkIyPPhaJAOuwBgVt/F9d4uEklpXA
         9YxD7y/nnrdQtOrSJzea93W6T3DnrPcge5CSlDDUGK9xgLOftAhDvXRKAHB55xRbrvfs
         /9TZ/VE6gVaIDdZO4Vh2L9cdKcaSei9NSWqekCSNLe4DG7y3rdQAlTW+0w0jbt1/zJwG
         uXsw==
X-Gm-Message-State: AOJu0YzfSl+tq4S5AX6S0zAnRTx+bWHRptrMbD1XnedTrWagnhpZlo48
	PfNyeS7JQ3RzMFrbW4gZtNkF/aAl/bJ9pe4aENTRHCkbI4+n416aOFWXNSdtmw/gU+9be0qhbHZ
	yeAF/YMH7HBFyupqvPst/E3s6a47qtuoVdfkw335hgcjNwO1shgfq4g==
X-Gm-Gg: ASbGncsGfx+udvmz4PNJF6/AHRNGd1Q7JJEg/VD0DmQPTkYtXIHLf2iiPghFFqwXBjh
	zuXWUHDLAbniRouYcJlC9SezfQfycCvhaymP9Ozgp9vHbSuQbXpUBjFYj1exQDEmDAmTdlazefz
	8JwH+QggltkBmxKX2OxwGnspD0BUx5YQ6/9bGsutX4uh4ZdB1PZMBlleN9w/3UC7SgpYw+Tk6gH
	D0DnfuASunUBPWnUUqPLX6lrt1y9h4qD70JIKMGGaaUUWvOWuDpxz5i5bKXGS4IO1XbQ5zOCjiq
	eUiX0+C0ptcws/AlkOWleeIZshvyL9BTqNAhUChWpAg=
X-Received: by 2002:a05:6a00:39a7:b0:748:323f:ba21 with SMTP id d2e1a72fcca58-76e20cf0539mr2582929b3a.1.1755069668270;
        Wed, 13 Aug 2025 00:21:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTenQZeafqeK17bULskWp3Z66K1603GFcLmEsh80xkPSD7Bq2lIA9XY9Uil+7M2UMNpagcWw==
X-Received: by 2002:a05:6a00:39a7:b0:748:323f:ba21 with SMTP id d2e1a72fcca58-76e20cf0539mr2582899b3a.1.1755069667835;
        Wed, 13 Aug 2025 00:21:07 -0700 (PDT)
Received: from hu-pbrahma-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce8f9dfsm31235397b3a.53.2025.08.13.00.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 00:21:07 -0700 (PDT)
From: pratyush.brahma@oss.qualcomm.com
X-Google-Original-From: Pratyush
Date: Wed, 13 Aug 2025 12:51:02 +0530
Subject: [PATCH v3] mm/numa_memblks: Use pr_debug instead of
 printk(KERN_DEBUG)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250813-numa-dbg-v3-1-1dcd1234fcc5@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAN08nGgC/22MQQ6CMBBFr2K6tqQzFKyuvIdxMbQVmgjVVhoN4
 e4WVizYTPIm/72JRRucjexymFiwyUXnhwzl8cB0R0NruTOZGQqshBKKD2NP3DQtr5FUg+KMuqp
 Znr+CfbjvmrrdM3cufnz4reUEy3cnkoADR2MMWF2XkujqYyzeIz217/siH7a0Em58gI2P2T8pi
 URopJaw48/z/AfsNgY05wAAAA==
X-Change-ID: 20250808-numa-dbg-62a8b2092c56
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755069665; l=1381;
 i=pratyush.brahma@oss.qualcomm.com; s=20250808; h=from:subject:message-id;
 bh=c+IKTEzal9kBPA/ADB7y64RVy4hw6SkL+5vIBoo8vsM=;
 b=Phvdx1UAs1Q1EEyp3PktJ9j7+rY+4rgWV+6bOSVScD+G6jDpwhSXQxuudoIEAal3FIZhpAUDX
 0LRg3sU0uapBZyk/PjwEmup3UPRp/7BIor0s6aq8NP7/2oI7Fly2gYE
X-Developer-Key: i=pratyush.brahma@oss.qualcomm.com; a=ed25519;
 pk=ZeXF1N8hxU6j3G/ajMI+du/TVXMZQaXDwnJyznB69ms=
X-Authority-Analysis: v=2.4 cv=X4lSKHTe c=1 sm=1 tr=0 ts=689c3ce6 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=pGLkceISAAAA:8 a=IjtafaaC1MEc7PSuPL8A:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDAzMSBTYWx0ZWRfX5ybPGUqGs3ed
 6BaOWYuzekof8nbtELo0ben4e9i/Gihi+SSyHfsiukGlMcGBPGuJLZwScDleweSopzQPpn7WzqY
 RK/eMlIddGFX6sO/OSYgoTfGaM8EYxRrGW7rJvl74I0Bn6PejIqmwjB1JIXTUMXXzn6XD58kzVQ
 THIFkwhMIxzWErfDsEFVjP1F9r27HOS4Noe90CoO+oROR8lTRSN4Ea0iFRSLMt5gfuNpaz+BD8q
 wI1iJPa8TpaZ95/k/KXQ9XPKd1C/p9QSpXW9n9jKj3uK10GGSuUaThMe4tTCo0nbnJ75GFS7ogn
 BzX7hTQhF46D7QD8LRi1p3eU4pj+jw1elLjg3/RuyhH01Vjs1cfNNxofMTCNuFVGTPzibyLSman
 3RalvP9x
X-Proofpoint-GUID: qKB5DrkWHuBE0lU-8D4xcWQnV3g1YM00
X-Proofpoint-ORIG-GUID: qKB5DrkWHuBE0lU-8D4xcWQnV3g1YM00
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 bulkscore=0 suspectscore=0 impostorscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508090031
X-Rspamd-Queue-Id: A50B34000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kaze9qj6f8s4hztuwm8cgok4ucerguji
X-HE-Tag: 1755069672-644537
X-HE-Meta: U2FsdGVkX190w+NJq2LnZ2Q4u7iB+r7ESbLlxzIijWlJFvQa5v53xt2xZLnNYv4q4IGZTZukARsnKAUJh7QxgcQXFa3K5y/MgZTn4pRfs8XvVpjJZXvUSLMyB9tOWYre90iMppqEmz+GWGo5mG45GTwkajdL+oXTrfo6KxIucPW1BmWK/4W8KT+IbweDdv8sJie0ANou3ot3GisjdEkAt0ZHYbMsyGN/7hK/Eaf5iYw4Kjd5zP0KaTuVOJwjxftmVR3288DqFrd5mQkPBSW8CZr3KwFLraMY2E5C8gNFhh0LnPz7DKY2FoGoN9f+Yd1jlrA7IVCJ+ZOLvlSyb/AP60f/fPcqSLTpbZNtGoRCjr0shhGQr1rmWT+CcOACwIuGGanuShtc6pttl1AwTcf47sotsyJOLc4CmMGC+uahi8/NqCsta0sQHhXtiLqZ2tMhWMoI8vRaagucarRWzdN8ao7TcYcvZWYkeX2vWLr9vEPqXoaMUW8whZ/2xPRjkwXitxaNHKHSRlm78TwxwBX64N10PbXGQ3gEXVpwwad71aM27v5Ah0qQ1ZngBhlWKBUzTaSI6Lxi/q2Hp7FBb3u71B4d9h3GWJKhy0OjWoAwO2g5kmYNWU70wak1gSNWZB1kCvxXC9GPZWLPMcxJqcmshKpf0uczLsH5TvzfdhdR81+o95vN8UzIRnwMR4JFL3MQQycu+gGja5Vns0bp9uButroQ+sJ6f+OHZgaaL2ApIBmNTq2wvV4eyVHZ7YcL08lrv352635GUSR0cCpyQCky+dNu8SAKz9Ig9VdJ9dLbyjGRJ3tT09mvUhBN9OcsiHcfTGfCeG9XxLR3SjBgJB0unk1QXae2wN0MW+ll+X/HwWKlTkID0Q2bKuZ0k64Nw7EqG7gk7Jk2oyVZA+DJyyXlKJ1TM4oa7ZcHGrndDn3eySKmwQbV/SqBLQgzkVvlP4X/SiebVe4SJ8DZ1FDfesT
 AWFfUYJR
 FIvhWtPwTP+NRQUF46oBgYeMk+YrAjkQXGvlAdT8tZl7ApQQCAd5X9S6bFGRzSJ5YV77Hny75oyVG3Q5NuSLzN5bC74kDJBiozuPGYgvXtYNAqJzNEU94bphtQ2LDavWuB2zmni0Ig9BlT8jh0Ca6A8p6v5A+ScqPGY+xRQIeDDmvSUEJEgbJVuhRIwpMrnL/7xaXc6Ru2VbtK0nU3lhQ1FlPIdenqPpgE4enPXG1K9CteEu3sIhlWIDvw9/v9YRzuRq0XbPfl0alfOjk2Lq+J1Bx0ZDk3SMeclOCf5+NXDiymdifxlvQQQj8aEIbd9GS8WBemzZuazWk9L03smtivUAG2hDHrXAYrxITU1k9ppE3l3iDeLvXMtulUe9X5WknF3ELUy0/UL8ID/CMrc66nMx8n0hDvZ4IgGZeRYeAhXr9FEwYd+4UwKxCxRdQdw50WauRPR/m09Sh2NcZGb/kk/St8vXS++LdSayOKWg/bB8cY2Yg39OAQ+SDMY+m8aAMs19n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) to
align with the consistent `pr_*` API usage within the file.

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
---
Changes in v3:
- Restored printk header as per initial implementation
- Link to v2: https://lore.kernel.org/r/20250811-numa-dbg-v2-1-7842aa2d4c41@oss.qualcomm.com

Changes in v2:
- Removed printk header as suggested by Joshua.
- Link to v1: https://lore.kernel.org/r/20250808-numa-dbg-v1-1-2ddd1ec634aa@oss.qualcomm.com
---
 mm/numa_memblks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 541a99c4071a67e5b0ef66f4136dee268a880003..de626525a87c3ed54d31695e86f18c980c084558 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -76,7 +76,7 @@ static int __init numa_alloc_distance(void)
 		for (j = 0; j < cnt; j++)
 			numa_distance[i * cnt + j] = i == j ?
 				LOCAL_DISTANCE : REMOTE_DISTANCE;
-	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
+	pr_debug("NUMA: Initialized distance table, cnt=%d\n", cnt);
 
 	return 0;
 }

---
base-commit: 479058002c32b77acac43e883b92174e22c4be2d
change-id: 20250808-numa-dbg-62a8b2092c56

Best regards,
-- 
Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>


