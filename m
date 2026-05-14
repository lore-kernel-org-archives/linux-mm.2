Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCAF9CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6AD6B0092; Thu, 14 May 2026 05:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FC76B0093; Thu, 14 May 2026 05:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E13A6B0095; Thu, 14 May 2026 05:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA75B6B0092
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:27:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B02F140119
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:27:03 +0000 (UTC)
X-FDA: 84765496326.07.B5276E2
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 356C6C000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:27:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=OHyx9JtX;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=GfQUSB6n;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf28.hostedemail.com: domain of georgi.djakov@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=georgi.djakov@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778750821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ep7Kseu2ALN8qw5peg3urlwX74UCeAOq10mhtSWm5ic=;
	b=FuH2xxv/SAfjdh9UqzPys88I5uz9n3YjwURZ9/m3frH8/EbTaK7dDGBDbkzpFBMEBkhvzj
	0Du5bTx+asRL7+tNvVxLpcnKtwOKC6Liu3m/MFh1wHyS/bYQP37q5KJY/pg3n8ncLd4r1Q
	WbTa3Zbg4vRTBDMz3B4GQ58vZJUsBkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778750821; a=rsa-sha256;
	cv=none;
	b=hjHQxeIVieSXtxWruSqSiS/batr2iZ65W/HGrgh+KJkCD9RvLxrJUunoSG93U+X3Z1fklR
	pwFjx4wbCHkrNAaZeMdCdVAzfaBo0W/b1wTyXaOdoXuxqbezl8nOctXgbjf5QgdIJHcfk2
	0ZNTymcTnpxQnlI0oHzabZw5DB/P/dE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=OHyx9JtX;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=GfQUSB6n;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf28.hostedemail.com: domain of georgi.djakov@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=georgi.djakov@oss.qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64E9Gnhr1095283
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=ep7Kseu2ALN8qw5peg3urlwX74UCeAOq10m
	htSWm5ic=; b=OHyx9JtXT5NXVd4H2Ucvhx0qRtiQgRXRlbWMQINkSuQOBYzIvR1
	3mQIEnrb3bAwWPkq9MzwGh07GHFhxclLAuz5L55AwjOMqrKnHYpygSTy/nJDRyvV
	Hgph+CsqmSmxaTUnPuLYn2+8+OMbkWHYq7di59WALCdRDUT8IKj6Irli4BbcYnG6
	AWgSLRlWEZe16jiGWnjkdpvdlOsL1uNKa7k4HDY+FSvyYdSFCtmdWiSJlU8lj+lA
	/KFkQhANfTiNyPDpNH6kiJabKB2U9j/l7ZCZiL++qEsJSjiD8hUugKx3c4ae9DHD
	DW7Up2Adq5UVGGAfrgmgn17Wo5Ca77N5auA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e563hh84x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:27:00 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2f3ec2e8d07so4180090eec.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778750819; x=1779355619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ep7Kseu2ALN8qw5peg3urlwX74UCeAOq10mhtSWm5ic=;
        b=GfQUSB6nlVKLNHDkRU0rrnvjs1AGc++qUmoqGb4KDM/oYjjUi8NR++ce6q5rwJdBib
         /DuX2rdTM0zrxHv3AFX7/HJOoynmp4VfTHlR8UhRzn1793CLhclkRgOmFu9ImYazdQVf
         BlDUvajOfTQfxVH68WeHB8Jxur8WWCp16tOEOrkoQmk0NrnldWQoKDtJTWfh08SAqLg1
         NTk9Z3WPqaQjnJ3hsoUGCcsl+UlXPm6hQcd8qAjXePlaCx7fF5ud0s93oWGuW3CYSkYF
         jrMaicRzG51Vi5qTMmJahpXE7M05tUlbsH1HmZqy/50AIfxNXxswi6Upgk3aKnj3sDjA
         y4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778750819; x=1779355619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ep7Kseu2ALN8qw5peg3urlwX74UCeAOq10mhtSWm5ic=;
        b=BUYV3EFTFyUIU1x55g9QfRt6NbIVJnX0DGK8/fxz89u3yW03jfwmH0bzuKHx7uXm4n
         fMUjZB7U51/jVAHXl8bnNNaoDT6guOjq5ZneJ0NagSBP1WbHvN1QSaNH71grzPoh52mS
         /2T23aZXZxSgZqkFlxHXGmT/zBFr2eLXrXqXfvxGNn3Lm6TSktl1yip4dFXC0v5SBBlX
         w4cTZN69UTEaOFUlyRpnCENm1HrqmLlAtOHBE6+HGeM2ZWNH086O0fHGP/oYulvmdglU
         sEeN/VEWnfU8tXQqWOtnA4OV1FwG7MTUWUcay15kuJeX7Gb/bOkRqaTuhxI3PvoJrKbQ
         UyfQ==
X-Gm-Message-State: AOJu0YxOfqbVJ8Tyw1a1YiLTiysIJ7Z6VlB4l3Uo9RhtnOp8HFyceCrl
	TyKBCmrkXQ2Y86ZLSgtGQAv23mO0xkx/CqMpXG+Bz5U4g7XOMgsJcijj3sCaBDQWmH3BfooNfoG
	+8LRi0SIamaNXtH8LjjdnjPbq8UVroKd1RdhxJBFyxT8hvGzPXq4SNA==
X-Gm-Gg: Acq92OGk6vGfLe1lGjIzgwuHVDbHofHgElA3ffSwxdfdc3IYGcfLluqrh6m4zoSekOk
	CQTioRvoZX+TDwQ3GI11zBS8BLivpgzWCC5YdA1Xvo6dXoo/LfaQ3eicgcWlIl0GIO9nPJ8tc0z
	3P8NoZFMGv2MCU9m1UgV52vq+BYBv2Msbrh7aPgH9IoZahrJgLl8VUesCUrkckWm6/4RE6wTOu+
	zrzi63kTjNuIBesVwxK0Mwt8eEBUh5/OEwesamnkM8jMj7ZgvLqgYVGTum8uOs/l0icI9AXNvkd
	uGZoPJmfVLW74rejhHX+UBa1Pirgf23eRqTlJcrzyFhtO6vo17j6N11rEz0lmufZteuUwEacrcl
	AOQ7Z/eWTMs0rWlZeh0Ifdtgyjn/lwFXb4Gi5HlOTtrmUPAyXkDefyMeKtVn8/HbPKzr4zgfqOH
	zrCA==
X-Received: by 2002:a05:7301:1f01:b0:2ef:9961:27fa with SMTP id 5a478bee46e88-30118ea0193mr4235478eec.18.1778750819143;
        Thu, 14 May 2026 02:26:59 -0700 (PDT)
X-Received: by 2002:a05:7301:1f01:b0:2ef:9961:27fa with SMTP id 5a478bee46e88-30118ea0193mr4235461eec.18.1778750818588;
        Thu, 14 May 2026 02:26:58 -0700 (PDT)
Received: from hu-c-gdjako-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302944ffdf0sm2329385eec.8.2026.05.14.02.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 02:26:58 -0700 (PDT)
From: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
To: akpm@linux-foundation.org, david@kernel.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, osalvador@suse.de,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        georgi.djakov@oss.qualcomm.com, djakov@kernel.org
Subject: [PATCH v2] drivers/base/memory: set mem->altmap after successful device registration
Date: Thu, 14 May 2026 02:26:57 -0700
Message-Id: <20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: KHj6RcPY7V4qvQTCLi1K1aXxH3X0dNOw
X-Proofpoint-ORIG-GUID: KHj6RcPY7V4qvQTCLi1K1aXxH3X0dNOw
X-Authority-Analysis: v=2.4 cv=DewnbPtW c=1 sm=1 tr=0 ts=6a059564 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=sWKEhP36mHoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=YGLr7xQM868z39zpSbcA:9
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDA5MiBTYWx0ZWRfX0goIZN5HfMYj
 jB8SXN3p5WGp9deUFNsCWAOreMa809bL1LXa8aq0SBfbbCseQHP54ZJdS2M+dg4HfVw7CTwBiCm
 VyM7h1esyJDgPfI6guRTvvAzZh49C18FJf7Bu9JVTKPhC076crytaX4HulOv2U9md4eDDHpQzVM
 QczD3VP92DmmuaMH62g7kqGfbqyAON1fGsvVdW17kAwGLN46f+CpWv5/f+bPvAKi1KaxQXFXPP5
 k3vlVfwsnmMxsQsrqcWwoXBHiwYEJx1jaXwW6FSaz7QG4Rnn+JYO31/V2glCyEXRXAAKhGjchI+
 J2iJD+9VUJQNGwdt7ZkgdZcyYrKxmcZzva6oYWOJQtVZ6JMxz7HPYttd55CoueJQcoZaoRhiw2i
 vQeEYLta9TuKV2sAgO/Hhda5ppbH2jLGK8TlfZ1u3sV3aOtbFt5bIFEsHRAau2+Sumxbo9CsfWk
 nwaJfhzXk6R9RxS7Izw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605050000
 definitions=main-2605140092
X-Rspam-User: 
X-Rspamd-Queue-Id: 356C6C000E
X-Rspamd-Server: rspam04
X-Stat-Signature: ps4dpc1aut7spdmxa8yht5i1h64don3p
X-HE-Tag: 1778750821-432773
X-HE-Meta: U2FsdGVkX18DQzTj+a8FjxTmMttNk3/m4z08pFk8iry7CsSIVtNxYlb4Q8icLKXktHg1EicNYcrS0T+IF4asHQNOEl9co2wuroe5Aub1j1mIYBUWhiyzAwYkutjWXfwev11N/IILKb7CyYz6TIIOmFZM47vDWlEfANyYeSB9hKlsMGliYPQLJwRrEw7Dnwnr1zOBbWfSklrT7ayBip4OkM38MyXSpsFllCCCmNZJAaJ/yRfK8tYLtJG/W/nW4RTzhDH5E7NB9NzyTmBwOzQc0dh4X1oEjfervmVhoUXEG66ZnHQX0+AJPAm4hkCvwZZYdjaLuTf/FfuecxC10oFxQZn18htBIpkBozi0rP2cfdkxTyFX5fjnCF7e4GGDaqxHJ/GJRhJL8RlCjHbpYIDr9xNaUbdB2SNFAC0/797O5dURX8fsm5LbFQFax/glGZvEtaF0dLyaIZhJcO/iZpry/W9pumqqQtdxVh157nG76tJPjZj0/H3dJ6SKE12+NrC5HQkLQ+XT7j5IsmNyIFf112NFkOU6TXl/1hBaEraAHDeXcrvYYpPm9axWwXauxNN3Ww1eZjTrRI6Zw08DIPnhC6TmGEj8rtGztbtV0LN3zrQHwCUmtWeXm1NHyWZJKBpfVbDkCEUOENBiH7fOJXL6+6HdovqE65e8k5qmbzaDz6i5lOnwl/0zayt/b6A3abLErT86Vp2aRT/2eAQ2OF6iZuYqDQ3PVOOxGMji2vzhDhnnuCE5lsDLbeAtXHCTsPjoZmYl0Y/feweHae07CVOZVvFNPXI4O17ykTlzJxNDqijCT9QL0smXBlMdlVSdrIrjhHCsx9drow4qJc4c0AY/9cb8EzC6Tk+fJH/FqVeNR2x67ay84JfML62wCcdIVRVfSls8GAc/dGgjv4tXKA8PBPh3qeaIZsWmqm5reEbVU31Din/em8aa7uBObOnf7VEraAiQPQHWoSv1MDJJmHJ
 xELCYP4G
 VpCKyP2Ll7EMMLatsNh0tGz3a/jJWs6jMbvF4httw2hsA11sTx3+9mf/oyO8kfz2KdEGIkXGRYET3gOo9EiSvdFxfGPFgsohdnE6Z+0e/tUA6CwnZi/1UPQYQIOqQKEvh95yvbMgI1t7Ms/gZvelcH9rXCANFpS1CDYRnsCxqJ0D3K3StejzpRAcLNVml5XNt07BxVjTs1AoNEkRfnA5sl7WqfZ+xrPNURWaA6Hn3HRTok5IBKyNAjEfL9mSsJ69Db/t3vs97tyfiXqk0RK+iMfDjzgyTmmYzfdtrZ/4oSV14Q2o60JyHeNgFU+b+11EivcDUCzTzixyGR+qn3Inmxn0gp9yOGZSPT+sKwTKE7sxG73DfA4HlK2aRJ1rzUKrwff9aNJMVRCa6af3zrH83m8nv0aQzbQ2ew/ac5PfFgvaZhmi32ewl7B1Dvz7OlNOJkvTR4uJV2kn7AU8dXhVY3Wk5Lx2sEg8xfApmdA8owS4W6SgwtaQrt5BYOOoOOhliqbWXHA3erCJPiu7pjdldzxXKbwg4Ift2Ae95BYYC7Ui35tnzafOpBqN6mt78tDrD38NLVBkBjcrpmFRzsx2PKdSZUxi9/eeeGL+Sru0h16wzSo2u5BVM2UditA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If __add_memory_block() fails at xa_store() (under memory pressure
for example), device_unregister() is called, which eventually
triggers memory_block_release() with mem->altmap still set, causing
a WARN_ON(mem->altmap). This was triggered by modifying virtio-mem
driver.

Fix this by delaying the assignment of mem->altmap until after
__add_memory_block() has succeeded.

Fixes: 1a8c64e11043 ("mm/memory_hotplug: embed vmem_altmap details in memory block")
Signed-off-by: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
---

v1: https://patch.msgid.link/20260513130900.2204499-1-georgi.djakov@oss.qualcomm.com

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

