Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E355FC5904
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8172F6B008C; Thu, 26 Feb 2026 02:01:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4B06B0092; Thu, 26 Feb 2026 02:01:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6656B0093; Thu, 26 Feb 2026 02:01:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 529FB6B008C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:01:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10E5F8C979
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:38 +0000 (UTC)
X-FDA: 84485712276.17.3ABE2A4
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id AA32340010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="Z/VVUEmd";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ao044GEf;
	spf=pass (imf12.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvgXEmpB1r4WuR4fOfrjdVLui/7pvUcm4fS6DOtgW00=;
	b=crzZw18NUefsjIRbWI5axVCmZLEKyn++jCtZrkSCcNFOtGhgqEtj2d3y0BPzhQsoe/LpCD
	IaF3EXUcgDwwMEcevE7040+pYQ1Pl+V1z7vHOsKspHB1ZTYHriNfTNwW2HlipISQBKsTzn
	HdWY51xWYeN+RIvpGRZBkGNEsokGDNc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089295; a=rsa-sha256;
	cv=none;
	b=7xTx5XzKVtztweBveuUMY9f76Wypezc3NamDPqyvFMa9X2GSUnyx8heBXD2gSARnuY7X4Z
	LgeD9IqAlyCq9nde4fi4tLXovcSIIlPBnrk+uSsIKP5J2M2BdlCsjyMiIGgrah/cZeHnP3
	2ya0PiN3uF+JgeOuXuusMUXj7DSsZBU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="Z/VVUEmd";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ao044GEf;
	spf=pass (imf12.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q4V8eH918974
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=XvgXEmpB1r4
	WuR4fOfrjdVLui/7pvUcm4fS6DOtgW00=; b=Z/VVUEmdWf/8o6COLQb8aFCUwQX
	Dzc5c7cuUzkbwZJ/bMJdJAP0hzVO+oLJ3T/lW2HrM7WY/DA3IpQf/jj6phlJAsUF
	e1jW5k8BIpSAR97a7nDM8ZFmcTVCrck0xpuzStPxj8lMIroSxSr5OYgQH4vPUqxJ
	V38nO5fYQaNhqUDTTo69YZuHciN4aH0+7K/zQOpH8HNJQJDS8/NA0Yug1JOpMfJk
	eX1oC7YIfsDMJYFTCYWVpGcoCnCIHgns3VDujldX03WCjXJFxEZ5e6+PnCJocF1O
	7pxdYMJEptVZW0tV5ejFvRoEqNbEIMNsnMCGnJgpegAmY7H1O8FotCDV8ig==
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cj4w4t7yn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:34 +0000 (GMT)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679dcf1f680so15172621eaf.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772089294; x=1772694094; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XvgXEmpB1r4WuR4fOfrjdVLui/7pvUcm4fS6DOtgW00=;
        b=ao044GEfVWQh5U4Ynvws3fMru0Yox2xiwDAKtkXQIbizp7vvWYRbLYy879yJYLWFmp
         NYEVXJXJTP20EploziDg93UUip419Qoi3RnLYTBsPdOgxAHIqx21BUbujXeD9zMQCMyN
         uJebu4zQAi+eLoi9QSLCUvsxHo/OT6rXDacVmJRUv6JG11O+xnzLXOVJdKxDptwXIcX0
         1NVJjfh8PhEPVS7WqfcU8f5j/L4z8rOgHtTO/nNpx6hcEPszBoBvS+0JQnqwbWCuRUQH
         54fdN+siNI/o4YJlTEBHAJMc/AmubvEMYe24PuR2Mp4C+FtdJg5t38tGSAQRN2qVah3A
         9D4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089294; x=1772694094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XvgXEmpB1r4WuR4fOfrjdVLui/7pvUcm4fS6DOtgW00=;
        b=u5Q768kxtBWU3S+USLFBZzdwswc4+wsWIn+5SUX4YNdVZdvB2AAaXQ3BwJPIeliU3F
         EXRB6J8aUIm+aE9ZWAv32wYyAu0K5kvFpkVNqwGowu2nZCXoqwhBFBb7C0opZpheqVak
         T/1JZdQyV2mnNM6kgiUR0GcpVH3o9amx/EJ0EPZFilHxDRT7Sz2CHQwDYtJHtUHioi6h
         xx7Pf8JBfbQh3vQj3OBbUWhJTr0e0flv+Q7CEwDysj184mEBQQQZkdL7f2lKp0NWTbi5
         Bxf531Bk1y3HN3xYfU8L7a5vpwmNKVHTja6xDSKkILC9Q+B1cimzsKxpPEkfl0i/vXks
         VlJw==
X-Forwarded-Encrypted: i=1; AJvYcCUjrCc4BsiGNXTjhjd+QkGtchdZCkSwe8elMCuqnKFKiO5jRH+CR04uVtdYkDJH1wVpI8FJWBv86g==@kvack.org
X-Gm-Message-State: AOJu0YxbOIQzy6zBdd/0n8m3/+FYZXD3MpvDNpJ3VLCY0NpC8MK1g+UQ
	KsDPYcvNn11l1YYFM1KLuWU9CtxHNDXBmQWCIliVMG7LHwYGThjTT8pXPsgY3c2vLdbCdv5zt7T
	Lj5FxQ3YqTFIl6FfLN8TsjvT3WyBjcaypMkjQ2Md65EN1Mp1dCXm4ow==
X-Gm-Gg: ATEYQzw09YSvmgSQFEfbsIPB6JX5LsoK5iTwx7PzufOUWKTBVtwJMK6fofnBYi8WE5w
	BOa99HaKogVqMf2YPWrDH9u78OsV/65/tm4I79uAJUh+PE6s/iclrsFbqhrj2RsKPQ04nLsnSis
	mO76beaxTFxKPlZo75aWRPXP695Su9svHYnGVuJI0g700+uomVUrsNSdpPbAK/mLmhgKnyRV4ro
	wawU9DIeN+EJ5I3egHdl9TS0/PExVF5xgpxr75mmRN6tpVlaFLOndZJhnCqOAGSN1BZyl7/Pvz6
	qon9PYekz7KZB/p6TTlwDhrLXxxvg/d3gNUhGjI4Ea3zobvvxJuuH5g8IUQADnSxN/zfeQ9XMnb
	Bm17cC82EETBjdkl7W66kYx5nubDIK/k96TF7AFwG3WPCNpi+Eo4FaBQlfJURPpAPp5hKJHdy+j
	CS5Yap
X-Received: by 2002:a4a:edcb:0:b0:678:a4f1:c396 with SMTP id 006d021491bc7-679c449b538mr9081267eaf.30.1772089294012;
        Wed, 25 Feb 2026 23:01:34 -0800 (PST)
X-Received: by 2002:a4a:edcb:0:b0:678:a4f1:c396 with SMTP id 006d021491bc7-679c449b538mr9081248eaf.30.1772089293586;
        Wed, 25 Feb 2026 23:01:33 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bfee3csm1013246eaf.7.2026.02.25.23.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 23:01:32 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org, mst@redhat.com, david@kernel.org
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
        jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longli@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] virtio_balloon: Set pr_dev.order to new default
Date: Wed, 25 Feb 2026 23:01:25 -0800
Message-Id: <20260226070125.3732265-4-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ifhcgAfTm7PBuZb1GBB4hcERqZcv38KF
X-Authority-Analysis: v=2.4 cv=IqMTsb/g c=1 sm=1 tr=0 ts=699fefce cx=c_pps
 a=lkkFf9KBb43tY3aOjL++dA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=ORiy2k6iMmxUqhiy1H0A:9 a=k4UEASGLJojhI9HsvVT1:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA2MSBTYWx0ZWRfX48lkMSNLMLt9
 4mdJ40kEi3r7tTT3m5KxAv7RydRXoknC8Ckbsc3xzwMMH2Lyoh/Ca+ngVGzegReRUpTMfh8Oh2x
 lSDqZxE351YyG3XymS8QEYNkePnNjjkEuyQCqgaQdH6IilLpc4iAKjn9U9C5Nt/PlvQkjg0Gqyo
 tm4Frw3N+1mtAgi/YdXskxQ8QvEJ1KvI63TjHry9JFYBUERGocMRW1PGGLjqZXFEMONt5g+wuPm
 o7RWYpI1MnUv4R7WjHA/teFL7ZiBNZAWhHc41OS05yxpvZNDn3BTkHVPW9F56fz6x9RnpT5DSjV
 7PArvEvpvrsqUeXkff1wPHWAPw6nZZA8XZ6wjo5qx3fVFcYAza+gZ0QSgqKWgjY2ibqPQfa4Avl
 uBr3eDyqLZR3HiVbMEC8U40fbIsMtBxTxvoNGyQpFAnu1XIrbfUoP/fRwkM9V+YKGUFTiepAZQx
 r2TbkQZGir0/ZeE1NUQ==
X-Proofpoint-GUID: ifhcgAfTm7PBuZb1GBB4hcERqZcv38KF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602260061
X-Rspamd-Server: rspam09
X-Stat-Signature: zp455jssbocstzncchaoaasaq56mbyzh
X-Rspamd-Queue-Id: AA32340010
X-Rspam-User: 
X-HE-Tag: 1772089295-575388
X-HE-Meta: U2FsdGVkX1/vg5P1MNXhhq5KaToUF9LAs0YBrdjsKBMdyad24PeAbn8VsiiqadqFJwSXGW5Lt8oXX28w2rhDLWG8UzDin27o7J0G8d4limcllhydwsbPfUnmtD0+LCvpzGNrfjHzE8Ul3flyU0JcxNpahO7Qn/G7TqD8S/lgeDaxfKGJAeueN1HfSqGI/5ZUSKJGsniuI7Jv6zsTFUHU+Cf6AwkNTVVKekag0TvzLcIgix3YElkEaXmqRApKQo2dJCCWddpYyTZqrD3vFVaqvJ4fO1I301Johycy9CNxNoXU4T3wDtDD+7cAyLL1vdvSazul4W0Y62sANADciYK4GQ3AUTOmmfZWiS+RgffMgBCDaNmH7LcqDWFTQ+8fqkm+5LsHBzoaGDzo2Q3+M2Lahq0WI5Azdk3v2zpwezsbelKLZWosCBNEziYhC1dx0wAiUCeKqyrttAAjXg4dN+7SOX1aPHofBz3TGrrIQr1WTlQejTuAK2L4JHkzEPASs7/SHFx0u734i3o7cmRXNGBeFYMUX6WXLg9aIZHqQ3JKvVcLOH47kqsoFdh3YaX1WoxnixSFP/qWlLjdSOCGwChQFSNubc+8n1BN3MNrCivuljw3wP6oYaTJXQ/Q210GenEf4Gym+6yfXRav52vWFBYyVdKFK5RJBCdb/mudGlJ6y1rO2+xCMqXgZ+u2P8S3T3M6/Bvh2ysvba9hIEW2MLeHxjGVAK7API5/2ZW4TREucajNqfvmXqVeOpZZ9x5tSLYIGRjUAeVY7knM1YJhv8oV4EN9BuLM7qJvy6veR+JbMTF5CRBpdfYt7Gizsq9VPDxewCDVHSiZS3i0I+GsuBbqGFiJpS86Y4oxFyFkW8GWgo/iGNZEOotA++uVCOphyRWCWupwcM26m+6Fv8kSFz4OLRTF3e6s+J72ZEFcXDNj+7+riqa1kPSzhTbpGncyU57KjOTwCA7ioa94DE8NlQL
 E0OStQVz
 VOC4doMLPch/cy2/ylz3fMa6rmmeGCYZqnOPnlsaMInTz8cCbJIsWWD6lIgaJbYLnvRMk7hyCCuTVX5rOYHChkfh00/fcotyUJdavyxfi6clnWofclu+1yoBCGgRnpACGEtwlt/dAuzNdpDvgxZSC3QsuM5vMHbhi+7wXBM+10ssFL9jyTTdvX/rmIohS7EDZPOROKrJF7JTqL4WDfktOWdKF7/zEVSpkKicArVfxhZg/NxfbJNvSokNZfyDoh9erJp4hAcmNEMAa2ckVFSK24UAJU0yDTXRWfIMOSXH5k/gfdpAryqHS+y1ax/NPrDtSgRfdIVYneIk7wbkwuAi6FSkyBqF96ufECA9vVpSN1VAy4SYfdrik8Vz7JDDFDrJ8ikWjkteIzU5a7T3r8v1EAUuKkSk9OsakZZUNd0hvVNFLqGnzB2VKSaGqoCbJBHX3KE6/Xi5hjwdUqGyMyfFYTM+unp4r531cSLd+yGgd9QjOsWl50UTtDJCFGxdApIYXsadsznwne2IskNnxIsf0zXVuJDzqCSJbVgmhvnu6A9IABpr55uQ14ElxOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drivers registering with page reporting used zero
as a way to signal page_reporting_order to be set
as a default value (either passed as a param or
MAX_PAGE_ORDER).

Since page_reporting_order can now have zero as
valid order, default fallback value send by drivers
to page reporting is now -1.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 drivers/virtio/virtio_balloon.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 74fe59f5a..3cc3dc28a 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1044,6 +1044,20 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			goto out_unregister_oom;
 		}
 
+		/*
+		 * page_reporting_register() takes the order either
+		 * from the driver or the commandline. If neither
+		 * are provided, it falls back to MAX_PAGE_ORDER.
+		 *
+		 * Order given by the driver is required to be in the
+		 * range [0, MAX_PAGE_ORDER].
+		 *
+		 * One way for the driver to not provide any order
+		 * is by setting it to -1.
+		 */
+
+		vb->pr_dev_info.order = -1;
+
 		/*
 		 * The default page reporting order is @pageblock_order, which
 		 * corresponds to 512MB in size on ARM64 when 64KB base page
-- 
2.34.1


