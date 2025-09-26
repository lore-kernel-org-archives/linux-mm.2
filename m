Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA9ACAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 10:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20DD8E0003; Fri, 26 Sep 2025 06:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD19D8E0001; Fri, 26 Sep 2025 06:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0428E0003; Fri, 26 Sep 2025 06:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 86AC48E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:35:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5F7FC0626
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:35:00 +0000 (UTC)
X-FDA: 83931043560.21.C6A9D92
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 10D36100002
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:34:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=axnrzOSE;
	spf=pass (imf14.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758882898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QfqY6J+qOu9a6yKbsemysPtoOI3pe2aKtqgqEpcLgbI=;
	b=Bwy8TTrplPk8+PPttq8YbfQD5XfD2svnaAFwu2wx7N/BmqMysT63poZ4kV3Vz1rr0UK159
	jbVTcwxbIn/CGKK6vR5/lBfPxhaWKIkGAYrLfp82MX707S5shgNAZ/LB45upKly/djzcZO
	cSEKpb9cFN292g/2Avb4uu9+zo5KA10=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=axnrzOSE;
	spf=pass (imf14.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758882898; a=rsa-sha256;
	cv=none;
	b=Z1jm+EwO+A1uq7oFEcTi1M/ZycU1sNe7pByccRDNhhgmdyu7mXHB7mPNJECS/ZpZfSyaJZ
	q90ZJTpjsO+2JibBIsHp6fymDZ6EJGZDCHanjL5GqF/wmqMu4v5DPDn6OfTktRNe9OcoYg
	Mly+jK0bdUYDtUejcGA6em6l3pynt9g=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q8vYlh020680
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:34:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=QfqY6J+qOu9a6yKbsemysP
	toOI3pe2aKtqgqEpcLgbI=; b=axnrzOSE61HZXQTnaFM1HWOoDmRo/H8yb7eCot
	gQmm+U0hfgtCvGTfO2dU1nlISsnKJeiFFxCvixvLvR9BJ352qt81El1usmHxRBFg
	OIcpVh8HG1q7kcM/OkhJcRGgHZ1rFga8uMAiz4mH/6J3pyYkwcNFV4LLHTT0a6fy
	P1ZNd9YDuuR1Gw9bsGxyYafH7bnNx8gnv5hOSKOxixCXFTmDPrRGNqT4okdm0r+l
	fzu1hByWg6QzbGjcxrOQIDAbPYNvKK2vWeWA0PQI1vvovOx1MH8IKgeEFlbyyskX
	1sUB2IigDqNeyxp2qZrABHzIc9k/eXtPIrqaUVCsrM2k5Ppg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49db0qth5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:34:56 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2698b5fbe5bso32228245ad.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758882895; x=1759487695;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QfqY6J+qOu9a6yKbsemysPtoOI3pe2aKtqgqEpcLgbI=;
        b=wrAYIrUxMfa5mycfeLjgUOyxvH2PO9SxY3EaSSVXuhJ+h2A8mFzpGElvBDdI9h1l7I
         l3QYIzjSo2Znfy/sD3c97Bjw7Z2r8kR2B6/R2kd01jrIJ4oBUHCMYsAWTh+/hbIWXTQx
         ehlk8DkhRdWkAMa690RoVrwfQax4FMffknLu02XUlad9gesJzjy53IYFwp9+PGonXMEs
         mucM/rN8IIgytXd2ED8MPwtDKYaBYUIHGsp646gh5D3jGZTx7bBTAQfgxAcgQBKL3XYg
         Z9W/RyggjGYrbYTUXPV4zohih9itpzzg5WyvwOQ4HI0/VLs2fpo758oHqkATw6CSdBvJ
         +oOA==
X-Gm-Message-State: AOJu0YxXqUx56284crFobll8pQlfEmTXHh7dZDpVPL6FpnkkGKrCNkGY
	A8y6rzwFt3vHCW+4SrKqMuHpZgOGV2jIBFNAmBxArblrdCBLfg+6NNfrSo+s18cRJo2/oVgtc2m
	krMm5/PBt4+xWcwiDD+Y509uhEjbh3MIaaAOEPddoPxTeFxqQ3B28HA==
X-Gm-Gg: ASbGncvxyXjRz2dTobRqVoyYJ2JjJsHvrvJLynCKyATpTmvK/Io40Nk3OPN+e8trrXS
	P9n8NdnXolHvEdMbBtX7cRc3eVpjmbKRo3PsYvxOizD8VYwrQPge9yE8DDBQx7HDzow+6B3Dn/K
	wBMm0b0tULCgr2myCfgIlW/KIycLqtgMNR6t06p181nTgtT7BGR3snmX81WZDoULDDtQK1gL8kO
	XaWKlS3V2xiPVYUKHjWdE1dq+Lo2zOJSyb8g33jfiKMWiDuw5Pkz7d+NnvYVVaSVeBeOPiaiGiq
	aloBf/ayyjSFnOcXtg37TA6Hpj9iFF3TOBiopyuhEQ4=
X-Received: by 2002:a17:902:e806:b0:267:6754:8fd9 with SMTP id d9443c01a7336-27ed4a3cfedmr75025115ad.39.1758882895591;
        Fri, 26 Sep 2025 03:34:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4/u3G9PZR3/QB2V0Qz8ijnNeSE9rxuzoy7V4TGm/s9nLG8GanxC+UotJJjkoA6qHccMD26g==
X-Received: by 2002:a17:902:e806:b0:267:6754:8fd9 with SMTP id d9443c01a7336-27ed4a3cfedmr75024415ad.39.1758882894563;
        Fri, 26 Sep 2025 03:34:54 -0700 (PDT)
Received: from hu-pbrahma-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6aca043sm48950175ad.138.2025.09.26.03.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 03:34:53 -0700 (PDT)
From: pratyush.brahma@oss.qualcomm.com
X-Google-Original-From: Pratyush
Subject: [PATCH 0/2] (no cover subject)
Date: Fri, 26 Sep 2025 16:04:48 +0530
Message-Id: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEhs1mgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDSyMz3bzS3ETd1NxSXbNUs2Qj86QUizSzNCWg8oKi1LTMCrBR0bG1tQC
 m0lsFWgAAAA==
X-Change-ID: 20250926-numa-emu-6e6c27bd8f6f
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-56183
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758882891; l=890;
 i=pratyush.brahma@oss.qualcomm.com; s=20250808; h=from:subject:message-id;
 bh=OWvMQCRp32XJGYw2MjISATImcQCJhL5zooCvLtI0YdY=;
 b=tbaw8DFfFR6DjXHG+FAxfSytsv5cnSea0+z36/o/PZQoluo/QZWhniO73vt1Yl/Ou2FmbuacA
 q4sSBKgvfH4BOXCW2ONM8RjhdtCBs5gnHeGHjtwA5d+5MEgQ1PpH+AK
X-Developer-Key: i=pratyush.brahma@oss.qualcomm.com; a=ed25519;
 pk=ZeXF1N8hxU6j3G/ajMI+du/TVXMZQaXDwnJyznB69ms=
X-Proofpoint-GUID: pTpY_Cphkm5fKpSq5vF6iRFojZdWYlrv
X-Proofpoint-ORIG-GUID: pTpY_Cphkm5fKpSq5vF6iRFojZdWYlrv
X-Authority-Analysis: v=2.4 cv=api/yCZV c=1 sm=1 tr=0 ts=68d66c50 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=3PCUcf-SIovVhYl1kxwA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3MSBTYWx0ZWRfXxRFbREgDW6Tq
 lrDlEUKOcB1oJwXVTAgIBNgSodW1aOemvnz25zuImAr2WeyUS5WcxVhAOd0fCwSJxEvVYoxgN59
 m4TxtYagXiffdoeeEQYjPEKqbCjnpHMM/X5dXsXFrthRz9c3QQwWzgIJmwah6XE1/zEUNpCnF0L
 s1bGPNodRS/kjeZdOrp3EjLl17kJMaWoQjPHlKGIkL6mmTiyysxkzBLgWdnYZ7Z3NA8RVsiI+ET
 KiYoiixppWNKx+m5uw3E012e5W2d0BQrLomr01t/GDeSFj8Q0z0RaAQ41Gr/bDcyEpGkKLAz19T
 D70JeHk5u6z4PFsun765Xhi9DeOgLIraCw29FYhRHYH9NG/ZsG527cDCb+ZX5lZNg18gZUjhkPk
 74RKET0tIwtoIXm301kJmxuDNSwAig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_03,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250171
X-Rspamd-Queue-Id: 10D36100002
X-Stat-Signature: rgxgbbr3td6hoeach7fpw9ii5k4jiy6s
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758882897-970163
X-HE-Meta: U2FsdGVkX19su7TnwYARl8og16KMgJZVlI568K4KJNcz4msCabHPWj7zsVWMQS0uGSmInrBZFx7Ymp2PuyqzmzScc/Rk09T3eHJGt/azZhCjnd8anBS94I0+Vmvyx7Y6m18zQqVKit2wlrlDdAymWT5ddEwy7QeryI53X8XdMVjt/qG9Gu0UI30EbsKnE1uDDxmYh5e7oTtQAwvFt6m7lWnM6pg7U3AW8P2OIpvjxH5w4f8H2gyMEuJb1jv1I8LaM2NvOyEeRjN1awoxo5o0nVgT/eGBL1PcMcaEoV8G1O9jbrr/OICY6+S94FsPv67M67fZuGLR9o2HocF0Dzb5sh5Bmc6w0jPqiftGQ9WtPDOK7RdlQTOWDyigI34ZJXev54fX2amERYLkPvujQ6R+1sFJgjsij5ciiupB/i1A/eQN8xr7jWOJB9ceByGAZxUSBdlfvE90+JEP80vxBcSDMmBdF1RAV+t87y7S6xb2Zul6J2JFkqAbYgPfPal2h3fVtheifucejhY+Sx6lPOLYZG6EI/g7XQHnj151lZsBTfd31vYj5kLjbWiM4poEuBvnsH97rmYcFWufE8Md4a9ZN7xI1q+fgYIlk123otyKgBqzKXuENXGxcj7W1i1+Xi4ZnVphA1+8qhO136Q6o1zoPGtNrCdc/IDEsN3lKVRbd1Uq3sHWvzU0/hFia53DS7wQzf/0PKJEt0y+GZdBMzLUPakoe6BYtVdsujvfn2jUN68fkO5mlakj+BbbS10AU7u4ezj5k/zbU/v9lcub3BoHIH8gtUleU/OYnW1xSxuoVYP38jyIlBBMzOw8SkFhogU4bZmw4xqyv3Evk3emAbHmeMaObn6mX+2FIuIC1327ZWtwMxmvh2OEKArPRYYuxRORKqrzWlD48xjqX5nOZ4zNS89YjZV5nHeQF8MtUqJAeYc3rGeowmlNV4gF3PLB3ruuHgrDJTKjVevJv36Ohq8
 hcA0fPTT
 sbJ7vTAphL6jPpGvrrWGqr6YRr6Ie7lFvvnKPqUodjn6triZr1vJsKIU8AVuQmOqL9xlUkgb8Vx8MNtkzxEti3N9rL/cc5ZQ6j4zPSm/XTamsdIvONmMX5o8ReeTIZnJgxvy2ciB9bflaht8pt7zhqwg+TV7Taa1N66T3sXOiP7JOuUQvq8w6+q++kqXMiOFpSkCwDc++EyMWIxtOGTZXB2ymMpNVt0Etnvd6hF/2b80N4qsqNIw8+L0QSceEsq9FhZ+LlrG82kN7TrhK2F7QPu1oSh2U3fGT268/qkBuKrSoqew7q1TX2NPofwg3r5/dJCzmUbk4m28IVn6CvHZTfAEjFVagroEc/RzH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/numa_emulation: Code refactoring to improve modularity and
readability

This series intends to improve the code readability by using
existing macros instead of hardcoded values for size and improves
the modularity by moving the size calculation for emulated blocks
to a separate function.

Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
---
Pratyush Brahma (2):
      mm/numa_emulation: Refactor NUMA emulation size handling to use kernel macros
      mm/numa_emulation: Move the size calculation in split_nodes_interleave() to a separate function

 mm/numa_emulation.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)
---
base-commit: 4ff71af020ae59ae2d83b174646fc2ad9fcd4dc4
change-id: 20250926-numa-emu-6e6c27bd8f6f

Best regards,
--  
Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>


