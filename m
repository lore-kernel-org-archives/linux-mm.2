Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28DB3D3B9AD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 00:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043BC6B0005; Tue,  9 Dec 2025 19:20:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36A46B0007; Tue,  9 Dec 2025 19:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E252C6B0008; Tue,  9 Dec 2025 19:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEDA76B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 19:20:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DDA5160336
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:20:52 +0000 (UTC)
X-FDA: 84201655944.14.F611BB9
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id B146D4000A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:20:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Andc+qDx;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=R3uMNKSE;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf12.hostedemail.com: domain of oreoluwa.babatunde@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=oreoluwa.babatunde@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765326050; a=rsa-sha256;
	cv=none;
	b=Jzfd2pXCiK63RcQV1rq1cUkP2jGkWgebZ4cJCUXUKLPGlOxClsQWuRWplOfVt8sFnnezjd
	KJj6zEJb8gYfdhHDeE9iSR5mmQmqvddCDyUKCLYEjCR8FkzqkfQdC7G6m8rsPCK/Mep0yt
	CM2t8bHekjGOZfRS3C+RFiD4DKBWoKQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Andc+qDx;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=R3uMNKSE;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf12.hostedemail.com: domain of oreoluwa.babatunde@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=oreoluwa.babatunde@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765326050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iHBwA4IfSbfg57hhtkGLsS9PBLgMplwjUcXE/vuBD94=;
	b=lRwncDuG3scFsR+hav4Pfzmz9EyKY6N1Fjgpnq8Nlyr8qVkNrhN2FwlEi09b68droBM7Tb
	HilI3v6COwHtsbLhBQrtkaBIwM1I9MQcxfF6M69/jh5ExiAVfcdajsSoRM246aasErJFhD
	cZK1NGkm3S15AvUBl0QqXKYlDUsF6ho=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B9NIUH01075585
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:20:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=iHBwA4IfSbfg57hhtkGLsS9PBLgMplwjUcX
	E/vuBD94=; b=Andc+qDxHSt0WG+VzJdUdL+Fg/tBG89vPh8M5YeWLUE9dxrtnQm
	hCYQB2GhvmoyKChwoKWoL1PXDQjU3XYeGx230eVf2whf2R8R90jGAc21bmJru4ZV
	YnZm9BwxfvxIo9uMmFzx8B0ymQhdvWtMtnaOd74HIGlZIpDF1QwYh+gLNni6pHZV
	ah+bqFu+uCKIKCssGpAmsXyFC7/Kxtpy9Y+NN+vVVlSJP5iEFg2VUqax+Nb/NyXj
	pHc8qnC9ZYIrM+OXr0CWPK71NkECp8NNgvsXD53pmQ2cc6qW19TKqs5OHp25u0m1
	kQX8DtQg77Co7XKf5b1XLYOiA2ju7OL2B0w==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4axp5p1k2r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:20:48 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b969f3f5c13so6685983a12.0
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 16:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765326046; x=1765930846; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iHBwA4IfSbfg57hhtkGLsS9PBLgMplwjUcXE/vuBD94=;
        b=R3uMNKSEfTsfshW6kGXM7MepUPZ+lZCIdCXnxMrDRQ+wxX8oF2L/fE0gko7EA6hOGl
         5UoaeAIBrIvS/OHsxQTCoSuW9g+cAjLK8uaMqompJq/1NVj0P0RC8dTfKkzBG6G9IdnC
         U9HM7fwz9ixw5P1MN2IM0l7+b8OE7Ze46yK6zQWlVXLXw5g8C8tXin2ZHYsXrPmtxMlM
         kd+ky40hzH2KTYJgEwFBW3Nbsoz0Uhw6axQTII20fPQSyqzwqgilDD3mIC11vd7Ijg17
         wV9b94Q5aInRWdbpdBl1Zs1gO8R5BKFzh6SpEkT7l06dW5rwtS/aUTWzUtL0jTg/u0RL
         YYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765326046; x=1765930846;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHBwA4IfSbfg57hhtkGLsS9PBLgMplwjUcXE/vuBD94=;
        b=Y0fBzYJvQ2BHyzVO8gfiAYrJzisFuylB2IosaFMj+HlOOTc6YS344rdl4AyCy/2APY
         Qakk6kBuYVz4/GIygycp8uRFsKjnWrH1PgfKR3I0f7xXURwInfl8GAN5qN7nUCRRQHJg
         kbyR7TkPBSAFBaKNX40T79RktnG21aQnKsrZzKTr+BiXYdUhdoST8WzcqxnRrzN3xyfW
         fboJX62GzDoFak6lVyEzBFSy6vNRO9e7yxwmZ2gtBG7qns7uJFyeWnQKAbn5pMbT6KhS
         ujgO/lPTgFx5lpeW6Whve/pG3d4Hegi69EV1nPr8ZsMAL6kf0EgW0N+1uJrg82eZo570
         2kAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIknVelhgnJmOrfFn6FCxhsen19t6jpGs+k98OlEAhHNjeuc+N6w1Rcr9zo9u9u4gpVRMPEvmFIQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7n+uF0VvKCDO6ApGZhjeifLsbkc1SXnhoTU47WO7bFnTK5Tbb
	959jcsR1YMVA3BHxcApmYeTA2ePRH8Is9qPDdlcbQfi54TYurwF6COF07S5uHY9oa+w+o/rgCp0
	tJSAgqaAtB2G6mC+xzr1TL3OMGyQD/jMggGhcS2Qpn1KSGNWKA6ZJwA==
X-Gm-Gg: ASbGncuBJfzj8K8ZOjSQWoXDhycpIIVgVM3CZZFIuyxYIHMC7PvyrJvH390vKhet4pm
	PowUPV67aft64fwqbzE4RDTwTo9pwp+jycHQ1mqcUOAEAeywwBmSGxMtVIN7wCD+c6EAv3xi7Dn
	cn6p5mCGWBM3pAMHhrGAb9SWq7bUyxlJcRv//mtmYn2HsTHMgbJiGdvw/8Q7bVArRrLRaWot7m0
	RIpM4lqodNbSzhdwbTHHVGuReYkUvu7+lYwzqILnBq/kvxX0G0p+PVOSTEUYvrr9SdYkT0CvslO
	eN68rFDeJ+J5dBca+xTJtsOTIjSCxBZ94e5xGmoWxXI76Xg30MKJEF1uAMs1o5qB0AVfiposDb5
	UKOf6MVu1fLmofEosk3dNlrZHfasvIPJrRNSCYPZbMVYKmPd2PimMUp4pjgtlCAuURuf/f1r1
X-Received: by 2002:a05:7022:62b:b0:11b:ade6:45a7 with SMTP id a92af1059eb24-11f2966a03emr425007c88.1.1765326046090;
        Tue, 09 Dec 2025 16:20:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGcLj2nkg82c0xX0uwbx/GB/IwXsGaN8dBi7OsSisu2MU6g5avYy1Et2uoitaYLu9zbKsRD9w==
X-Received: by 2002:a05:7022:62b:b0:11b:ade6:45a7 with SMTP id a92af1059eb24-11f2966a03emr424972c88.1.1765326045477;
        Tue, 09 Dec 2025 16:20:45 -0800 (PST)
Received: from hu-obabatun-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm79775745c88.6.2025.12.09.16.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 16:20:45 -0800 (PST)
From: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
To: robh@kernel.org, m.szyprowski@samsung.com, ye.li@oss.nxp.com
Cc: oreoluwa.babatunde@oss.qualcomm.com, kernel@oss.qualcomm.com,
        saravanak@google.com, akpm@linux-foundation.org, david@redhat.com,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        robin.murphy@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, quic_c_gdjako@quicinc.com
Subject: [PATCH] of: reserved_mem: Allow reserved_mem framework detect "cma=" kernel param
Date: Tue,  9 Dec 2025 16:20:27 -0800
Message-Id: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 8js91AfXFOkUrsLiODH7uDbf1_5Bhk8C
X-Authority-Analysis: v=2.4 cv=ZZYQ98VA c=1 sm=1 tr=0 ts=6938bce0 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=DS4snQ7NONFh9zYVhi8A:9 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDAwMSBTYWx0ZWRfX/VWg5Se5eO2J
 nGNY7UpvQkQFEMOj3KpFwWBHX3nvt1WmjLGlW7LZCAvJ9QTdJZ11yz4kBMHeocCpjXNgSO0zwtc
 Rl1HJdSHKBJb02qvo+RBE1aHZsejzCYx/+30ncjFVtkxmByqC1usM2f6kTPXyV6EsZMrxVdtcG5
 NjdcRlRlCip8OGwOs0F2mOwFeg/dCV3CbcVDleZuhNVJpZYTxwqytgVwLzSd+VOMlhmCksBEv2Q
 EAE65qw53kBOoloBZX8EQRIVQjiUuxop+TwBrwU2RzNCoFYSmNtXPqRlFkI9XNSCrmxsOA5yA1Y
 9f4vyQgSDSHnMTWo8VbWYvDTuPkt/QOT/pYOyE2T46XniaDrpy8gXVX9iUfOb68y0pXgGb81g3l
 BNK1rWFTLgL6XXChOyBb+a/ENK0ZPQ==
X-Proofpoint-GUID: 8js91AfXFOkUrsLiODH7uDbf1_5Bhk8C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512100001
X-Rspamd-Queue-Id: B146D4000A
X-Stat-Signature: a3omb9oyijqohwrto8qakxmkkjajitxd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765326049-579273
X-HE-Meta: U2FsdGVkX1/tBFPG8Kk4ov8bO49tnNKyNWFeOkVYlcNqzCE/kXVKKd+5bbFcgqYNEeubBcM+BiwzgiMNyIZWvx+dITOOAWhSzZVhq0OIdwdtxsCFQDE+edxSA2fYgUnDBFgcIxT5lRAQ2jjkIsIF/qopNNng2ljH2p4OHalfTHkT0Ck4elp5cfNfQ0IvVAQsp3b/K+MeMMjcyDiuDdhXW3a5BJjyUSF0MLwlD7gZVf/kdhnQSVoJ6RxlIEXyh3NTXWRceQKKGQuUGOIEj9gXBTQjUqFITNN1UtUE/5aby07YQeVtilhfnWNBS4X3iaILbMZV26cAxZyyGPAzfQJMRpveffv+5eYakEYsiWrQI1JyaiAt5eg3WLUgT9cjaavTrkFhgKDX6nycRhK0sUUfEd+eShqlqi1wGxtUdzsTaAy4NlM09dOmAk0IjX7dwPmFk+tATvAHyQJ8i/7s4TbJtSARC6lv2X4JrMqGJm4nN3x9UUQpPGMyZhIRgS5vFYaRW+4I/HtHp9wDUFyoiHrv/ekyhqrfLNOiBw8N9GqXS09XFNnXzHSh55hevyjX2+wfHYoZhaSrZFWOG/V+M9cxExLOvEuuESZIC3LJWSKxTphny4qHO1KyWDLmIEVPEOReJl31uQorts5FZfvTDdeQJBm8wnRuwEqW/rBeYZc6AAr8/MYXlefa9il23Jm62ct5IY+hKAnEcVM5vGSONJ6xWF5MFawU5Bh82oaPtA3HHLR9w0PWg51dQNHaNserqfeH0ViPBI1oOTNsBF1KbSGtVQAuiU7gBHojYfZkthwbz2WjeXljhAgQrfh+/t8AZkmyywbqiRB3Pb4GWc+ngvzclCrG7coagAcLGjgCGe1Ox3oodY3nImz5y+8qkdOEQhDhwoThIVuclQPWc1LgxPX5jRvTnuEBQTq5/aXZj2idJV8/X4jU2kIhK4XOGd+frufy2Q+DMNoKV1C+Hh4+usi
 YLIADb/G
 XctGb5UR3Sct6HoBU/C21n7WIKhTCp8yRIHhXLkdrB4r4JBteFm4dAp+oTsmFKikB4a5gVh7Achi0293bjrVMwgtYkMvDXH/woRN0tJA8j7o+Jtw90EHQwYKiyEoOZThEM8XmFaDR7Wlf6oHJgA4TmeoTp/XrOKES+eDBsizRE07NspzSwfbMQJchu2zXTc9houJKrIAPZ31u+4vxbY1YcAy1pNbj3Opg1AsdothZkw2fKZgVwvuQ4jUxE5r5ra7e5qCaidLrSyDF02UvZkNaLkXKx/29T7H27to1nloswH/UmSkB0FS27zzw9NU2hKfrL7fw90gvCP7MPd7F95QcN3fBsI5FwtRyRLtkh7wqb6ZMjYe5ItWJ9rriQ0rAykRHN3MltipcFK6hja+hrKB+c5q0h1AcYISqyPtrpmeKJv06BCeIguAxrjFqpDNRaTR8zuykjPLpct+/h2Sznez6FQaQEGFPXaZ9IRR8GDgPZSG6mI4Ae9rGHJ1YAt8RoNUoQXv1PGGATvHsbxIdZacDihGN8wS0gCe05MlqxXfV123GrayvBwsSewk4g24yamaAL6fuGBZ4KWgmCFPO31xNn3I7fQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When initializing the default cma region, the "cma=" kernel parameter
takes priority over a DT defined linux,cma-default region. Hence, give
the reserved_mem framework the ability to detect this so that the DT
defined cma region can skip initialization accordingly.

Signed-off-by: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
---
 drivers/of/of_reserved_mem.c | 19 +++++++++++++++++--
 include/linux/cma.h          |  1 +
 kernel/dma/contiguous.c      | 16 ++++++++++------
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 2e9ea751ed2d..bef68a4916b5 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -158,7 +158,7 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 	phys_addr_t base, size;
 	int len;
 	const __be32 *prop;
-	bool nomap;
+	bool nomap, default_cma;
 
 	prop = of_get_flat_dt_prop(node, "reg", &len);
 	if (!prop)
@@ -171,6 +171,12 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 	}
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
+	default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
+
+	if (default_cma && cma_skip_dt_default_reserved_mem()) {
+		pr_err("Skipping dt linux,cma-default for \"cma=\" kernel param.\n");
+		return -EINVAL;
+	}
 
 	while (len >= t_len) {
 		base = dt_mem_next_cell(dt_root_addr_cells, &prop);
@@ -256,12 +262,15 @@ void __init fdt_scan_reserved_mem_reg_nodes(void)
 
 	fdt_for_each_subnode(child, fdt, node) {
 		const char *uname;
+		bool default_cma = of_get_flat_dt_prop(child, "linux,cma-default", NULL);
 
 		prop = of_get_flat_dt_prop(child, "reg", &len);
 		if (!prop)
 			continue;
 		if (!of_fdt_device_is_available(fdt, child))
 			continue;
+		if (default_cma && cma_skip_dt_default_reserved_mem())
+			continue;
 
 		uname = fdt_get_name(fdt, child, NULL);
 		if (len && len % t_len != 0) {
@@ -406,7 +415,7 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 	phys_addr_t base = 0, align = 0, size;
 	int len;
 	const __be32 *prop;
-	bool nomap;
+	bool nomap, default_cma;
 	int ret;
 
 	prop = of_get_flat_dt_prop(node, "size", &len);
@@ -430,6 +439,12 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 	}
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
+	default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
+
+	if (default_cma && cma_skip_dt_default_reserved_mem()) {
+		pr_err("Skipping dt linux,cma-default for \"cma=\" kernel param.\n");
+		return -EINVAL;
+	}
 
 	/* Need adjust the alignment to satisfy the CMA requirement */
 	if (IS_ENABLED(CONFIG_CMA)
diff --git a/include/linux/cma.h b/include/linux/cma.h
index 62d9c1cf6326..3d3047029950 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -47,6 +47,7 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					unsigned int order_per_bit,
 					const char *name,
 					struct cma **res_cma);
+extern bool cma_skip_dt_default_reserved_mem(void);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
 extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index d9b9dcba6ff7..9071c08650e3 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -90,6 +90,16 @@ static int __init early_cma(char *p)
 }
 early_param("cma", early_cma);
 
+/*
+ * cma_skip_dt_default_reserved_mem - This is called from the
+ * reserved_mem framework to detect if the default cma region is being
+ * set by the "cma=" kernel parameter.
+ */
+bool __init cma_skip_dt_default_reserved_mem(void)
+{
+	return size_cmdline != -1;
+}
+
 #ifdef CONFIG_DMA_NUMA_CMA
 
 static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
@@ -463,12 +473,6 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
 	struct cma *cma;
 	int err;
 
-	if (size_cmdline != -1 && default_cma) {
-		pr_info("Reserved memory: bypass %s node, using cmdline CMA params instead\n",
-			rmem->name);
-		return -EBUSY;
-	}
-
 	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
 	    of_get_flat_dt_prop(node, "no-map", NULL))
 		return -EINVAL;
-- 
2.34.1


