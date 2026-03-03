Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E5B1EC047D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29356B00A2; Tue,  3 Mar 2026 04:33:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABFE16B00A3; Tue,  3 Mar 2026 04:33:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950496B00A4; Tue,  3 Mar 2026 04:33:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85AAE6B00A2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:33:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 100BC8B4FF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:54 +0000 (UTC)
X-FDA: 84504239988.26.10359A5
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id A2D8A80009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=DhJ6LbCe;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=gyFxdOJE;
	spf=pass (imf02.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSSvKdrdqNtUffp+vZHypJOUj06k8TVBSBVgyR9aCmM=;
	b=57bCC7h764bmbP/bBebgehz6iZeZqFrMzlN5esmJVv/wLbka3ULyXnMGpyF0og9AU18sE5
	y4/iSU9MncgXBLwCkwsd3T66S75JGl6sYyF4VXu27sL5+3qX2aClw+vIGxgtSadVHItXZ4
	+dGNmndetqebP1qRkRGU3lFjPqy1hSo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=DhJ6LbCe;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=gyFxdOJE;
	spf=pass (imf02.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772530431; a=rsa-sha256;
	cv=none;
	b=LBICD83y0Z8Q8JP/QB6upQyiar7VNcgBWJqMExojUOEtQ40qdvWauUabqOBYn3x1vu1xzM
	hqIaW3sMc22rBT5gxcpNFBxm0QGUyUOjDeEmMgNRxhmnw67TmRjOSqeOtyRLvZOS795cp+
	lYgraZc2KwpXltZAjentIvyGOGmz7qo=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62387U4u669947
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 09:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=rSSvKdrdqNt
	Uffp+vZHypJOUj06k8TVBSBVgyR9aCmM=; b=DhJ6LbCePoXnCMouZMBaR1h51DM
	d05A0Z/R4oZD1dZxptQoEebeOA0ejjZSI4mfa7qiC2rxDkdvN5hJaSlOJtuQ1Oaa
	d8ITFjb8FNli8D4tAsPOkCQ2tTWHWT9yYNfaBFgoV6DRAM/JrOuqPmMkptAcWiYG
	3RYJ8FHeIURv8N+K0Vm31stgotT6Smfv2PTQMl9p8VnNRSfQTDsdjjLAs4LW44BA
	UKDPX5lKUsMIbDZY5MVppel4IddQRyvdfXMh/BXEOCUDMvJrUnEiWHDJRHja1YGp
	60jHv0fVQwNJXn/QzTqmm4Uaii384cEfsiZ7+LQxz9ExqNa/gnyGNVYxgMA==
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnngg9mxt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 09:33:50 +0000 (GMT)
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7d4d6edec7eso39178117a34.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 01:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772530430; x=1773135230; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSSvKdrdqNtUffp+vZHypJOUj06k8TVBSBVgyR9aCmM=;
        b=gyFxdOJEz+/OVx+RvXrk2xmUxUXfgN4A/QI/uCazYWTqO78v0uCteeoX/v7dkNUQhA
         H6nbxmHBD8GoY1/HYPS6OqMDHaiiKU/Bp9fY2njb0jGP+hOgJ69myOpH8sAFBfze+q13
         Sho84U8pCBeDXYBuYcU0b3clvV6clb+Q59T6eLOSiZ50P/cgLgJwEUdC7eFGtLZwvtWs
         BxekYRy4lq4j+Bz0mLiqureVnd/hAJ5yPLAWydaguN722kQ8g71XBY+3ScyBxM8cJB7u
         hctRSvP3t+m2PO/gXK3GKiNKHf+1QRGcjYDXUS6suVHCtTDTExSOZZ+eZEXigG2V4Qt6
         xKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772530430; x=1773135230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rSSvKdrdqNtUffp+vZHypJOUj06k8TVBSBVgyR9aCmM=;
        b=Neu3oSzWJLeizVBSadJWfRcovC4+61KnrzPgGjj5ssE7HmtHHnaQpIp1dYN9VzV57D
         0RaPNSMPL0Rz6fBbtsET/qy4kQqu7oEYjZIn+mD8yQnEZ96Yuhk10lhfiTmKh06k4kpF
         k9E2fvxc8EZgtUTsqi9jxFH2TCk6bUXNSfMmK9FUyyhw3YfC7i267yvhkDRlHpReb0gg
         5m2G5HeUThKQPMf4w72ANw/I96OWDQAm9f7kz64e6XikFirV1Dyk+6QDW0lXCX50Olot
         4doz9ldolvEu0x64rjAxy3LqZZoG6vRaq/8m8yFcVtsdgzhqTZV31vp5u6CIr4lheatx
         Xfgw==
X-Forwarded-Encrypted: i=1; AJvYcCUlKTSugD1wbn/MFqXMN10wVrVsDmya+ajXWxQvCQ/DIItnVVm0xIMYoLRx3UWa4Y4qXEgrON1I+A==@kvack.org
X-Gm-Message-State: AOJu0Yx87bFKGX7acWHd3uOejqh234MjqaQFqV3k3iARXzOAI6+gk2+u
	mQ+k4udfNDFajx278u68bKJ4rC50oyI22BH4Zn0h/6XgVLK83VEbVtXzpDLg60AzuAy+pJVvc2+
	Qh09YuKbj/3QGRv5FhLgEPVexkzNK3UxvgGWuZGIYorq3fwtnT1g9CA==
X-Gm-Gg: ATEYQzwgaNh/PvvOJLFdcRvAk4N8mTTYTAkWu5+EmiZn4SpPTCCDtBWnuKdZGfy60Iq
	Im2kVzKw/lqd6D1jcqG2WqUh0JCwc8JnIal3jPj9QRjVyeBpXbcwM2qr51PPJc7hEEEVRwpSaPF
	oc+/ysFAI55V3HWh5KhLDWNOexPT8tp7/ksJZIFp474RCWY7KRnR1aOOjI+B9BoahHiv6uFZIrb
	xFAchrTDvfGsYZjXSxaTNwcwLD65xPG8+JRVhKKS17KzhaU6GAWng+i1fvJYah/4rHExwrzFJz9
	V8yu+NpOAcECvxggeUxe8ysk6roDViVyHSQjT2Qzf14ek9t7v+lTOiB1CbwRUaPrMtszxhkz1rF
	wFL1XltEPggAENR8A6ePi6uNTGjUqQocAObBnfkVEeD+id2Yw+1sTE2fpiCLC5h6hizvP8BVJRX
	MOPLqn
X-Received: by 2002:a05:6820:1ca8:b0:66e:7aaa:be64 with SMTP id 006d021491bc7-679faf45b78mr8277752eaf.55.1772530429728;
        Tue, 03 Mar 2026 01:33:49 -0800 (PST)
X-Received: by 2002:a05:6820:1ca8:b0:66e:7aaa:be64 with SMTP id 006d021491bc7-679faf45b78mr8277725eaf.55.1772530429276;
        Tue, 03 Mar 2026 01:33:49 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67a1d603f31sm938666eaf.5.2026.03.03.01.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 01:33:48 -0800 (PST)
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
Subject: [PATCH v3 3/5] hv_balloon: set unspecified page reporting order
Date: Tue,  3 Mar 2026 01:33:39 -0800
Message-Id: <20260303093341.2927482-4-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=P7E3RyAu c=1 sm=1 tr=0 ts=69a6aafe cx=c_pps
 a=z9lCQkyTxNhZyzAvolXo/A==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=yAl3Rinrq36N4FMOn3wA:9 a=EyFUmsFV_t8cxB2kMr4A:22
X-Proofpoint-GUID: RGFxaaoqMOgeocGgVi_Q1-ZNaPJTPYOE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3MSBTYWx0ZWRfX6uDIwDCyn6YB
 G5jGdxqMjuwlO7TMF4Zy7nkE4rFdkCWOdR65+13mx7QDINo24rC+YWCJ9XBoy5eWNJonLA1Veim
 0MaQ/oq7zJb0HGX2P3rUl1+EtmAU6xr0/y1H2MynFpctidmt6vJDLwwyvMLg/GI+XT3rnFC6ES2
 9vZyUj+1SMQVvG6KUFmCwtsUiwBGLslClIcKi33XpyQfi6SedzqEJ7zEoZmVW7WLEqCXxMMD5OP
 ccz86dTOe3tirzSVhBD1Redm/qDIYtzWmp0p8l8tqe5mirdHJTugzyALYhziwLnsL2TJrOYDVR1
 SiQIU1CM6BpyMilSgRyx8i6YbXRTQ02mHt9DGvJ9PjrAP6aiQoS5qnerdBPodULOd25gZtK32lE
 ML7R3FKMxt9gxAmX8TDtn/ep4PllyNYEEY5q4yLQJSem7VCFkYXBgm3E0mPLkXm5+8OS4b2AGol
 BNVg49X/RvNstbQjYlQ==
X-Proofpoint-ORIG-GUID: RGFxaaoqMOgeocGgVi_Q1-ZNaPJTPYOE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603030071
X-Rspamd-Queue-Id: A2D8A80009
X-Stat-Signature: ixpn46zijg36tkakhh5h3jgzwjthb9id
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772530431-690905
X-HE-Meta: U2FsdGVkX1/hzMsQwYOPNxR+KRxJqUSIljFF6p5CAJcqlYa8juf5NwSb38lbVMUXDoaTVra6eGPquHwJvI1p4SwhWVW27hJoQ0GQf2gmCt4RP+qOjKppSs3XTkvmv2DSskpZqPIuK6rMVo1a3fRIy9UCFoIl/mY1N0/y8ZiTPjWwy0O8KGQ0FOez8CxWLFRiqrHHZWdd3R1b/HUWiq+HCfq8hfQQWQC4uOVGp0FHvEXWvwfwKhLTCTObhf780SZ3PQUEZLe7DXLUijn2F6cLqDFfy8xKWX5ZdQ9E1wYZmWg/cnCK/PbReImvijMCmVeWnSnM/+65xv9hf4Sj+YnDqJ2A4LtBp9r7gAeCdjPbhP8LqV+Wu2RgeadLN1DLNL8kbKcD1Z6CE8z4rc0mMC3HSu0CG9iafhLCQOBBl+NIMsOIBIDtaeo+5i5Izh5k1oq+O13VSNB75NU+Ij6EAStn9GMpXZl3nlwZs3sm9WZ7Z3cB57BSSGqArFgZh4sYBPYAHVCO08mZw5mEDgoCDnhI3YwhxrISJ+M2YurQ8W2yG5oqJD2InlYc8YJig4sK7Blt5Yt9rtWBG+9gK/b4HI/EXIIf6s3qWX0NA0hoBLeNaCYfibY2S/P9eJLqvQv5kU5n0RyY7zWV+dyrMOFBgW2NxWIUGLs0o5IpM0Nc0MhUXrbgw5v9C8iQmOK4SlHkPYMQM/L49ACYgZ+zMNJOZ6jgYNCrjjlg2ig8AUDOH1EMjJo+E7HCipDcpN3N6sVCJNZqDTR5qr2OkdeoxgzDBQqxeoUD7ss7UhzzTy6xc7w9tblV9ZYp9XSrMX2Nlby+XpqCRGr6kZswKhCwA7HjGqASqLxF1TzA0gaKgrCgTFW5B0JOR4AnpWghwhvA1TC+ar8p87IWUk3tCm+0QqsslXeMhPdn8w3TPhhEvdSNMgopM25A/y0gOAV5DHd6mjpGsCiD/0fede7+Jiwq1JrHPm2
 lWagzt9z
 mNnz4E1xnVb6WP94M/snnBRYdeWo8Mr9Y2OY0kQAST5HMxKQAGwz/JbPUO5+NABwuzgxUTgIexfuHi1EwbEFwFBEVA1DXxpRrIq/T1InRnJeoucVf/IyUdXcAr9VOhVL5HL+Ro5SDBrI1lbXRDvM97ZThqA8uGihSq6E+G+fuMwq+w3oS/rPOu3QySZ+9++eaiU6m9Ig94u5vPFqIvsaugkfk2hv0i789qRNtb7Yzj779qLfK5F/MczrDdkXdOdlafb4FD81KdC92RQr8a3Z0AwL6gLGboNAiQQnfVT+6X5KI0WlCv/qn3EsrAbW9el9LqWGy+09+m+awti1ybgLaGAheavjILjMyp8WuyMvtHqqeDtLNRE2GvK10izPieOtnt0iOzKNFh3aUdHAlmAJTaiyCM9cE/bUnsPp3iCdV5VgqtMCo2chJ77WHTrD2wDS6VpS2jWJ5KYjeNTBd12gw1JSM8sSXuQE2Mt6kbmAUG9JOOea7YBQAbVKRqGQezvwgNRikGR9yvv4rd4W+1vhFwrNK9FaPXuR5XKxI3wwlNgMNHsinlbcWSeEl+ko3tVaZCrMLZEjDUkynnfVP8QROHdItmw==
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


