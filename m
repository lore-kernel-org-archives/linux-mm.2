Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96AAACD4F39
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F846B00B3; Wed, 13 May 2026 09:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0765C6B00B5; Wed, 13 May 2026 09:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEA86B00B6; Wed, 13 May 2026 09:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC0DD6B00B3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FB741C056E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:06 +0000 (UTC)
X-FDA: 84762427092.30.77B5831
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4C80E140009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AA9XbeEY;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=LUHC7DcA;
	spf=pass (imf26.hostedemail.com: domain of georgi.djakov@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=georgi.djakov@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uTfe/tIGhNeQUIR+fCUbh9LouIthlTdyb6tnrf/6/uM=;
	b=I7ISRsnanbBixwCTfkOSEAJ1SwzHxLJyBd32qOnioZB5QYOEaAri1asAZJDtr5tMEdC4iM
	si9KOc9RDPrXp5VlkHVZ7S6v60tqXGROL3a4Oi5vf1eF5UfWaMhiQ+6ISqTxWaKbVWsFXe
	r9rQROtUnVF2tB322AjEkKkEjsJhu4I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AA9XbeEY;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=LUHC7DcA;
	spf=pass (imf26.hostedemail.com: domain of georgi.djakov@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=georgi.djakov@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677744; a=rsa-sha256;
	cv=none;
	b=t/gYp5TWJwYmToA7VKRunXddKrnljQwwkh3i+XFE5xuEGmOnr2UyqFS43R+rLRX+cqbqe+
	ITbDT70EErv5llvaB299VcHazVepMvz0tklBnxq0W6Bgfh2pLrmp/iA+cFPECtGfCk5JCa
	Eqh+8jRx1dio2ZfWzIxiBIx+LAYXL/0=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DBxUcx3324708
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=uTfe/tIGhNeQUIR+fCUbh9LouIthlTdyb6t
	nrf/6/uM=; b=AA9XbeEYswKEb+EXZXwsLhUjZnS61idbfu0Z55OfSafAM8B/RBN
	eNETlFP+uZSjY9zloxIZJuQwpbaUSQJPlmsagxP15tZy0ktOh1SADcfvtMxpm4HH
	nq0tAhcFBIobzPX3sD+/rLyX4VTmju6wBxzb2md1XG63lDpimJxSPYYe1tZlBdME
	9EkgOg3G8Pchp84prvhh1UAJE2dtjfimiEsxxUYcOFlAiosZSFPB667EIcAR9coY
	p6WH3c1lcReTgCy8fTU91/LWyHYRhyqYUGFrYDzXHULarSjaVMnagMiHFAJTR1pf
	/2kS1olfrZdYoZ9gSC7mR1jnBKiqhkAQhwQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4kvd9hsu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:03 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2f5943ca81aso11014661eec.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778677742; x=1779282542; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uTfe/tIGhNeQUIR+fCUbh9LouIthlTdyb6tnrf/6/uM=;
        b=LUHC7DcA7d9+/qNqYZYbko7UUOCkHMoixJgXczHWdZl+ZZn7mfJtadXKza5KDvXlgy
         IMzIzlG9lv5f2j3jv5/xiQFBYLCbLQdrtqeYwlqb73noBfwFLdXYaLHJNC3bNn/FTBH3
         /uwKMN0MQuYCPOntpPyGY/QLq+bvAxC9iKnEACHTlakwA0iTGE5mFRsEp8/4ei33pe6O
         49Fyixkd3hBdi7Prn4/0XaJ+9YWoTC6t+r/1x/q7RKwj2o612Jk4M8lSPNX4VEMkXLW0
         4YjIWyJ1MYTAKgH+ipxKBANRGf+55LFiokO84sVH1RYOfPpikUTXTcA4Lqw1c/yQspOO
         qs6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677742; x=1779282542;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTfe/tIGhNeQUIR+fCUbh9LouIthlTdyb6tnrf/6/uM=;
        b=mnYnTm570/Xb7dXHfj1BGN06Pp+hv74OhiUdwAMb8vrL/xUGyDNUNE7vfKN4ZQsi9i
         z6baV2fsuXfkkFDYMp0y1Etzqt858J7aSnvbyDpZA41Yoy62QC6Gfi0yw3bsM/I/AbpY
         LySzkzuhE8ANWgUg6dpBLEUQ4FpYkXOfVtl79mLOWv2QfZcaeT2kHVQ55NG9cVEKgcpY
         /UNAOpX5QaBCOZCh6z1cCBkNasT6oTNTfWEpyQqpp4DpJtZg5h5o1qhGUbb6ypeCVGNb
         ag/Sqe1SL0M95DxY2SqkTvQpzgtVLyyqla3Chuio+WdK5V/LzipxCl6o3qAjrMqZf3fA
         U8Jw==
X-Gm-Message-State: AOJu0YzgfFGB2RhCMNsnOXLM0GdcgPXHMmJHAlimh7IYufqmi4EPHPP8
	DfPNKAdfOW3+H60zD4X3i/uDeu48MCrmxnb1f98jS0X5kg1UWzDn5w401V+ybnnc5xFmthYuqip
	fU2ZsLDIKMAUztBK7RWa4T5bk1Tib3/LEUKhPohu3/FHNDr+ZSAxUkg==
X-Gm-Gg: Acq92OEpV1Gz6sGyBTXMNrycsHT28rI49luEKWfJuSzpQm61Q3oHcYIIY+XYzf12PJZ
	kcjnWY/hjzvAqF8gUgXZmLu5P2rjZjwjyJXUp68zG+E1W1d4noinTtwJsLu4+2vYJ6jjeXzKUeF
	yeV1sxdOnPmbMLqLwgNc2X3uEuO82TzwhjTIzYvkb2GDkcoJMsLX/kf3Oo5YET8tKRjUm5dl6Fi
	W8NxVxgHEfs4UWO/rHJW3r76AniBD7CVe0MSOmV7wTWMN7bPBQzuvPxZAV1t1OvVw2RHqpiCVm8
	wAPIE+jjGm9zBH16sp+Su1H8C5NRf+yycJGqRgn7yyClh0DCvfSrgwDY+0+uB4+hCtehDivhQji
	Qo4K5vYCtWKZLMT7kRH9vpZd7I5hToUgsNEdDUqemPdkFG+LbeMXnD3PnjwhrOFzMfEytWMJ6aP
	HPeQ==
X-Received: by 2002:a05:7301:1011:b0:2fc:9ae6:e5a8 with SMTP id 5a478bee46e88-3011a16e093mr1953611eec.20.1778677741958;
        Wed, 13 May 2026 06:09:01 -0700 (PDT)
X-Received: by 2002:a05:7301:1011:b0:2fc:9ae6:e5a8 with SMTP id 5a478bee46e88-3011a16e093mr1953584eec.20.1778677741266;
        Wed, 13 May 2026 06:09:01 -0700 (PDT)
Received: from hu-c-gdjako-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eafacsm21895067eec.1.2026.05.13.06.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 06:09:00 -0700 (PDT)
From: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, david@kernel.org,
        osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
        georgi.djakov@oss.qualcomm.com, djakov@kernel.org
Subject: [PATCH] drivers/base/memory: set mem->altmap after successful device registration
Date: Wed, 13 May 2026 06:09:00 -0700
Message-Id: <20260513130900.2204499-1-georgi.djakov@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: aPxVtcGHM3BtJTVkjXNOsE8CSzfzOUqu
X-Proofpoint-ORIG-GUID: aPxVtcGHM3BtJTVkjXNOsE8CSzfzOUqu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDEzNSBTYWx0ZWRfX+K3OAyc9kNoQ
 aO24t91pMijf0+nQBEeT6+rEQBqJtqiMLIJamUW4PWbLsUTjRIYjgA7hL8WFd6Q+G02OU3F//JI
 m3+bqEj4VFROWJ9/vZ6sSZOx0q8anERw7sNw4V2Mpwy8lnnf4xLbkyYHKDf1vI+wPNt5TWcb//N
 1od2bP4lpax+wuCgn3zv/gVjWKuq2l11kIdCNgbZWZPJcBmuRiXowQESWA08XXPiDfIO27S9t6Z
 JRqv/uXjQAKdZCwiLeFUylWp2F8sKjzILJZuV/w4QCLc+A65s1j2LzaA8dred3LVkKWnRflQ1N0
 NlqeytYgot/OKCEl/Ir+JRDFjlPU6AIgkeOkuiGsvhLTUj3Tv9HrVvkoyqvyOvbRDIAhtN7aLNT
 bqD16h1gAAcdvnekyKzDrDZ/ZlzcU/0/GU5Ql4WPgUPQRbvsRcA0th/m+n4bXNaSDT64hMRu4OQ
 5itStcIvzVzVa32RGFg==
X-Authority-Analysis: v=2.4 cv=Iu0utr/g c=1 sm=1 tr=0 ts=6a0477ef cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=sWKEhP36mHoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=-MbnMxPH0mhGQIwWBDkA:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0 impostorscore=0
 bulkscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130135
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C80E140009
X-Rspam-User: 
X-Stat-Signature: mdw9tsw9esz6ndg1y3juzk8546a4ngrc
X-HE-Tag: 1778677744-990651
X-HE-Meta: U2FsdGVkX197v2Mga12cS2QYt7BwnbuEc/BTIF5Fp7WppJCUoUNdyvz4NHkMwPgMsMloVySwaPS4JQZiysb7UPLnUG72QMG0tcJg3zio61BBUDoGzbZrSydE+rSdL+Y0CPdYRBwyvv6ddtHZlLPHjVgR55gjMCZA4u+CcG73O8/LbGsnaPaNPlFERu8D8CujHIgxyu0LTiwkZv71HdbXT4hwCGRr+i0+fZ+D+P7uNUtIyMhhJyvtvTed12w3TNHCg5HDHHL00TQTgNQJgN77UtWwAEYytLcvhn1UsOI4TYBN/PKqEC/OPJo2X+G1RcCig5bTTgTS5gDbzfiMJy8mhK5GaSW631i/MImKewjRSdnEbhSMVm8uPnuRoSTXVJb0ix0isZFl7Zj/aIgQU4AjXLfk2Ju8gL6aYZA1PD02KTQzjplKi7Iw4b+4v1ZZkCTnoHnfdgy7rx7Z3bMy/gvULQDY6j51Yty7AYor16McIzkHE6RXRl3jVoPrjJs1isUUAAF9zmDcp/XY/HL9HPB8mJHP+8R6l1mGuaQFVh1GQMzwON0IxjhDV22OD6mdpKM0sEfcye0VocY5yNbnVElUOdTk0u9YV244k5Cv5esnnY5e1m2U9Y6JP1iGElC0epA2hMIyeMPa7MOycZL+OyzJ6uwe3TykSdU2S97fJ5eM+4+SZkyIff5D2+zfwBBwBxm9G7WQimFdBZwoGehAxQfH+UEyXfrrQh+Mh01gwqDH1ZsmloTcfOHso/ZVCDQ8LqIdYj7w/Ji391TB6TXFWkZ04IdCOjTvCV9h1nQRVluK/H1z0H8nNwcVsl/br2XvdWqWDuai8fwx91vIoaTkRocZI16B2t3T8lrbYvWQc5af/W22xnjKUBWqVi5MUXo8/6w7gj5fViJeWdWqD3KsQKbSm6Xh1RacByh1NGzgxCbeCerT6NkYtmSatZ0Z22BqDJ58XAoLTZVd6VPsYMfhb9k
 Cz5voQI3
 8BRlNnA320b3EKDIyEBvsWTpPVuxxSiNJzPhD3o5FoUsoUy6TRWiwrxWV8iD+CMZH77Lh52mREe/xjt4j8aR+gvbi5mcCcS9zxw+cV2XS3823U2JqSXtomA0szWzOUNyPQCxlzPfvNTqk2uOfuVYUSniAI4USP7Li4SrEXGn7g6YzkoidmbD7TGrEEtxtT0swcj+Y2WZim2vw0L3m0Zl0+fpX0ujoQtIbkadO5u3EZUvyM/EhYQBiygOOMGZriyUfguf8raPHZ3vwY0xpPywzOJznnFSKqhXWrxuWeOUntQzb9g+N4o2jgFfLSqxCnFY1A76Hyfhuv3WTyY0stNw24zP3FshFakmhYg3bnPFM0/DsVV+14O+PLJTXUoNj/lwXdX1YvyjBlwir2JEHBIV4lRzl/pdMcxEA3jBVAoDbMm8W37S7cn3dVmJJ1AnDSPUWnlkqElwPLhZ1Kx4+DnZyWO6edmEIecBT8OtOP4OMa668tS3f+WLBemilps3Mi3XuoW2fyEGGoLWYCM6TPnnQIg67Qvf1zeS56DWg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If __add_memory_block() fails at xa_store() (under memory pressure
for example), device_unregister() is called, which eventually
triggers memory_block_release() with mem->altmap still set, causing
a WARN_ON(mem->altmap).

WARNING: CPU: 1 PID: 76 at drivers/base/memory.c:96 memory_block_release+0x28/0x30
Call trace:
 memory_block_release+0x28/0x30 (P)
 kobject_put+0xc8/0x1bc
 device_unregister+0x2c/0x68
 add_memory_block+0x1b4/0x214
 create_memory_block_devices+0x9c/0xfc
 create_altmaps_and_memory_blocks+0x130/0x1cc
 add_memory_resource+0x10c/0x21c
 add_memory_driver_managed+0xb8/0xe8
 virtio_mem_add_memory+0xa4/0x194 [virtio_mem]
 virtio_mem_sbm_plug_and_add_mb+0xc8/0x16c [virtio_mem]
 virtio_mem_run_wq+0xea8/0x1088 [virtio_mem]
 process_scheduled_works+0x18c/0x300
 worker_thread+0x1dc/0x2b8
 kthread+0x1ac/0x1f4
 ret_from_fork+0x10/0x20

Fix this by delaying the assignment of mem->altmap until after
__add_memory_block() has succeeded.

Fixes: 1a8c64e11043 ("mm/memory_hotplug: embed vmem_altmap details in memory block")
Signed-off-by: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
---
 drivers/base/memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 11d57cfa8d72..78e9600e6d45 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -807,7 +807,6 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
 	mem->start_section_nr = block_id * sections_per_block;
 	mem->state = state;
 	mem->nid = nid;
-	mem->altmap = altmap;
 	INIT_LIST_HEAD(&mem->group_next);
 
 #ifndef CONFIG_NUMA
@@ -825,6 +824,8 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
 	if (ret)
 		return ret;
 
+	mem->altmap = altmap;
+
 	if (group) {
 		mem->group = group;
 		list_add(&mem->group_next, &group->memory_blocks);

