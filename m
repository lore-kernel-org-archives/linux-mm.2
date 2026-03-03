Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A6EEC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F136B0141; Tue,  3 Mar 2026 06:30:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164396B0143; Tue,  3 Mar 2026 06:30:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADF96B0144; Tue,  3 Mar 2026 06:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D89616B0141
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:30:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BC8886F62
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:44 +0000 (UTC)
X-FDA: 84504534408.25.D7A031A
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3DB9F2000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=RFbjZohE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=NCPLwqNQ;
	spf=pass (imf03.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSSvKdrdqNtUffp+vZHypJOUj06k8TVBSBVgyR9aCmM=;
	b=ms1vVZaEAWyf0ZTdmSZWPBHX5mHLTn1EouFVsVTLjo4rvP+nENbYUXSFfDLMSr3r6nS2kr
	lNGoxMzESB1rIAg1Ci+OCgrIn1BEu175oqAQSK2wrwAS+8CPsDJOPO/WVwINqTNocKDxJB
	t00GjA/JyteZrlWblP7exmjAXwJW0pE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537442; a=rsa-sha256;
	cv=none;
	b=4/4QeWgHOP36/fmiDphZhG5e4otKTsVoQXCbEl+TC87Vt+kOX0XHEbsbDoioePK8wdoLB4
	JO83NJ18GxIlbcK2Q06+f9NJu6ocg5VsqA51qNAplZARo3MI2FjkQOyYIvIC0qW8nQhLF2
	sOmh3mqBvyxcyBoHlpyXmx7x/DS6/R8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=RFbjZohE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=NCPLwqNQ;
	spf=pass (imf03.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239mxom3996898
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 11:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=rSSvKdrdqNt
	Uffp+vZHypJOUj06k8TVBSBVgyR9aCmM=; b=RFbjZohEdYhFNtNFyhW4v07d1Xy
	t7Atad8LzCi6bRyYwCMaTj0Njuntt7rDanIojjQjtoPBxUWmKBFMmGb8NlDjrwxl
	LLGgSA8EdVb0zSP0nhFaWQiC+H6I3Ddf+VaFGvorGD/WHg3Wg4mdikgYxTtwuIp6
	XIvFpZGhRpAIH8/iUObyhlnJU8WLvBN0eAR1Gtl8fj+qlGDtreSm9SecY8HyVUee
	TA9/+pCZLavcYwyWdxRbvhfND4qU09bQvVhy4i+v5SqRSWibrWaFd0b1HQgGv35D
	2KNtCAObhJ7eU5FYHma1tNFzrUoh3OwNjSEtt43fwHtPPRd5iyNOMHAbSbg==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cns5fs958-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:30:41 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d4bd29099eso67182382a34.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772537440; x=1773142240; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSSvKdrdqNtUffp+vZHypJOUj06k8TVBSBVgyR9aCmM=;
        b=NCPLwqNQ8h8B/+Fw6UUlsQNr9yak1QwF636jCl2VdPGXroHFOaxA7+XjvRtNjbySCA
         7CoZPW/hOQquhU8QvG+25asp7b0sZzS3MpWbyyPNjQw7YOntD2e8fjP27a3IMjiiqQBg
         9RFjmQzxb+hxn9oBKE1bYuXBycOQT7LHv/lBeCqY7f/0NvqOR09mGMXIN4YyLU8ZW/Be
         FuTMKqjQDLuXE0LV3nwh15SLABJEdqDXsCCUw/5H7YuOalPhPsV9RtezvWPZUM8tu7o3
         G+hWUYFaxdi04C8gI6UsgKct0PlXM5XGVR5N2hit905KsUVTHQRKELI7sOmnkb5NjQ0Y
         QIvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772537440; x=1773142240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rSSvKdrdqNtUffp+vZHypJOUj06k8TVBSBVgyR9aCmM=;
        b=Gy7iX01Wokuzfl6o5sZVwW8PMgcW4FPHajCLMKuYp0/S6PuclOh02zgqKd9v0Az0m+
         wke5/SUQATAzR7vqcnGMwdxG7bEuOcD7wZf9EJ7aK5nj6bKBQ275AhpAgC/mKMkyYkOe
         RNwwbPM3/bgI/5gPF5MF0OulrWHJqIcymXMxmrL+P9jbAC68sTkbSVpwlftYkQ+NDtcN
         7Yqf9gyGF/TSc6h5pEnaFjEvVcmA5h8p0aPEEQ+w7AgWa8M1dtfHRpxMCrBiuptdRxiF
         7d9N6xsnrMSQBpdV2r0eQAhxqFtNsj2Pt+8xPEv8ncNAM7sOevJUpcw1i7LRGsnEk832
         72YQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4Wk+AHkeOWj8EWjw5QRJw+Z3SY3NdeOL785+1J+DxogTHY4LGcxbcBVFMZaeJiCvBG5RvWJVoBQ==@kvack.org
X-Gm-Message-State: AOJu0YxIbSyc6c4Ayu2hsOI2g60RKQ5OEcXbAo1vmyBlJgRpYqaA1yf1
	Yhx0j2lWiyjPzIlcHEiMpNwHt1kolbAybyHBVPME5zJrz9duoc59I/sipHgtNXLwprKR3f3Vkdl
	TB8OixAMecieXU0fEzMCxlmJhjIaIT30Gf711EUyuaytBjpSHc6inCw==
X-Gm-Gg: ATEYQzywLpgaelNCQQICaKImqMQ95GCgz47d1H16ui48B8srmIOgVbMjUAYoBgIbqEQ
	+3B/7v1djCfSBWtlE28zcIUFnp4dYfERjR1btvkeDcP5QN5lklwwI6MuuyYIP8JSuL6uro8I26Z
	1YBOJhnDDMwR6uWMc8CVuqjiRDZweHPyKHJbkjFXVVlf2+cwow37xOtHJpcnyT9fjGdh4rJp2UZ
	t44/JxQp1OrL9qY1HvF+uzocfQIqskHQYN3+KhOUj/tEVs5DufGzHHS7ZsS1oI2mHSy8zlxWHSf
	nQTjBAlFLkkFiBkC8mmmtN8mRFOja7fHvTYQfq40M4aPfdd0CpjU9wjlbhh1idjrxK0PhJk3oSh
	/NALp4KdDyks5HB3Jp5ZxEtVnWPQM6uEM++jETf4fctSPK6w2FRyTMZXsq4lEkjrx7GbZ6++H3Y
	C7tcLX
X-Received: by 2002:a05:6830:6a97:b0:7d4:5057:5ad1 with SMTP id 46e09a7af769-7d591b27bd8mr10409236a34.13.1772537440281;
        Tue, 03 Mar 2026 03:30:40 -0800 (PST)
X-Received: by 2002:a05:6830:6a97:b0:7d4:5057:5ad1 with SMTP id 46e09a7af769-7d591b27bd8mr10409206a34.13.1772537439862;
        Tue, 03 Mar 2026 03:30:39 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d59785d8d5sm9311790a34.17.2026.03.03.03.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 03:30:39 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: mst@redhat.com, david@kernel.org
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, longli@microsoft.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        linux-mm@kvack.org
Subject: [PATCH v4 3/5] hv_balloon: set unspecified page reporting order
Date: Tue,  3 Mar 2026 03:30:30 -0800
Message-Id: <20260303113032.3008371-4-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Pv2ergM3 c=1 sm=1 tr=0 ts=69a6c661 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=yAl3Rinrq36N4FMOn3wA:9 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-ORIG-GUID: HwIDR0nAV-MYBH8yx7cXGElah6-72eD9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4OSBTYWx0ZWRfX8GF0hZ4koaqX
 S11dtYhaLyBwO3r1FbjWZHBRUkdwlOyDczTfg3A7hhFpcgqeTsSAV8OPQ+AzTXpiWkTpzzOsNn0
 gbpTtTXaGriz4OmgJaJe4yp5L/O1ZBYCdIyYNK3sqQnmWMInJCalqnMloNp3XuTuvwNaodSV7qE
 UtEOTeddX6Krb5e7QSq0ZLboXaXPevqPiYGeRucfYS4/ncLDccTyciCMoOBQg39NEtpcaFT/JAi
 KUjH7lspisTNz0ygq7XDBdKjoW1W4lsByFMFfVp7OXh9m6b/esgllvhdrxxXdAnVuvOzfTA5bnT
 e7Ym5kEzbFovCgZ8rkjhQeaGVEzCaYaAlaNLXE58sODlmPRrSVav7DoHUkQrQ7ypMngIPjeQOiT
 UvzGtDG/hsNzFCo9ozKn/kmPmwrIIlL5EuQ/GkaY0zqrr6AmXGHaRaJGTfHUYrnfvs7xnxdrGr7
 Ut8R3nqMPd6Pk2foquw==
X-Proofpoint-GUID: HwIDR0nAV-MYBH8yx7cXGElah6-72eD9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030089
X-Stat-Signature: faxqopcsih3dbpj7dk9pqn5shw7dnx1d
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DB9F2000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1772537442-562433
X-HE-Meta: U2FsdGVkX18SzJpzNUs1v+FXX8q+dAECUxGylRRQfRc6WCFVxKzDQzUWwHTnAAi7V2jWarvXS3R0t9+g00qtrmCXGM4cry24Fiy4v5Oygx/T0J7ZrDppVPgthzJqAwcMOFG+EoPXceY+DoH3+ZCUpDJOSaTCvK6bwq2vqEviODve2/ejm6jdhltDAcJ3owis8dSj9ER1P2CKULm3vEcZ5MuLYsmsuQk53PxpuIWW/MmAVWDD2yVhafRv7dKb58so5aMA55PdBzwPVz0jIsdciYqH/DLkybXVh4opjFHQ312uTv4UK2zmVL/KB89XlBBzoI0vNY1hvApdH9CdvautXjG5eZqHPvq8O42BO7Vst1iSR5HtRNI2jNZ5DbtggbEtzOx9xl+99CdQ1G9nH9sLPJumuxxiR4YMbAefj/14BdngCx8iobB11kCWUegYHvGqjv/0TP2ZWe3GvmwrZDj8q3aseYjbjvQZsACP+fyyasllKBQFaQWVTow0FOMqp5MS39LK/zSoXosFleDaYgd8rvXzcQ/GtNogwtg4TQIK8qTwJUyp8LzEAZ9lrvM9YjvR9MYJfr6wgTMXsfQWu+YIJ1CVC18yBYPviIVTavZbI7Jw8ZY204gss7WVqiPwYTqzwYC/QL5GHT4OOjr9yLMD701z0O21CdTm5hBmSpmDS9Z/Vh9fcNls0Ux2J4QY1hckd1Njowlnl4wamWS7+fzRF171x1H887EXA84l59rqxaTF6R9bZsIUuIqxk/J7VL4CphJjBU8+eLYobXoh10pEriE6lvWoa9r5WC6slwYu26amvNfE/8xFne5yLNNICIxQTsrat84zgAtiLiDSEbP9lGjbGVwJq4lr2jNzT2CLN4VER5u3CE1+Ew6Ru0dZ4Cvrh1EaBUSLyq1PwMs8ITDa1bl3ZkuFCUPem69M+jSQlRGCXByc4eRNnwBNU/WfO9YobO3iEb9HeTKL1nf+khx
 FbcnfWcR
 2miHmF+S0KSmZTI1YyqXKysiVo1ZFZAndSj6NWFJNGBVSN3hvzPEvJ0aGaH5RjQoGnSn7T1wM2I1+Obfzi8gnmejzDAE/XwpW2RURMexk/KIXxvynMDXP6DiTxpH7BkDq3TGZxkHZT0Ct5f7034YIBPns+76Kc0sadthfihi2rjGmRmlJZKifpPxVObWiexncC2HKkI0F/ItXrXJ3Cnfc4e3AhXg6MLZIEHTED02rbN094sA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Explicitly mention page reporting order to be set to
default value using PAGE_REPORTING_ORDER_UNSPECIFIED fallback
value.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 drivers/hv/hv_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 2b4080e51..09da68101 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1663,7 +1663,7 @@ static void enable_page_reporting(void)
 	 * We let the page_reporting_order parameter decide the order
 	 * in the page_reporting code
 	 */
-	dm_device.pr_dev_info.order = 0;
+	dm_device.pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 	ret = page_reporting_register(&dm_device.pr_dev_info);
 	if (ret < 0) {
 		dm_device.pr_dev_info.report = NULL;
-- 
2.34.1


