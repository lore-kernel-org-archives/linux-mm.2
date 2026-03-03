Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBCC1EC0463
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB1B6B00A0; Tue,  3 Mar 2026 04:33:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5884E6B00A1; Tue,  3 Mar 2026 04:33:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481646B00A2; Tue,  3 Mar 2026 04:33:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38F876B00A0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:33:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE0E11403BE
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:50 +0000 (UTC)
X-FDA: 84504239820.16.63568F5
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7DBB5160003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=JJ0tq9jf;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Mq6r0EMT;
	spf=pass (imf08.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CezckF6fL+YK+N5ZT55E1n8JW8aI4FRVkbKEmz0I/2A=;
	b=1qdMFow8RBIPtgkKza6OnNWWThBkpHbof04ZH6J+Na3aJ9gdjuoygv8+qJAHavBqFQ+o7I
	IkTzw9ZQdAYe8hQVabR/WA0gnYfNQNmXHjv5+vCQtdDPRtMHcj/pPYdEumz7263XmlhWqA
	2ibLLuzFooPRYJjdi5xouiyICQeKGBw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=JJ0tq9jf;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Mq6r0EMT;
	spf=pass (imf08.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772530428; a=rsa-sha256;
	cv=none;
	b=VswxUTgoRm9K82QesWeMmSULcWtDAhcvVe8zbTId2Di/lZICVAqcILPsi2au81N5Ur/yhy
	dIyTB5j6/fUvE7ScJVveBm+uqLIaO+iAwSjV5KwvyWcJr5pdLnlCfHsYvoKHp8mA53WI4i
	KIhQjOvB1cH3FFGI9wpoe3jsN+wSf30=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6238A9e2669784
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 09:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=CezckF6fL+Y
	K+N5ZT55E1n8JW8aI4FRVkbKEmz0I/2A=; b=JJ0tq9jfMstclY10VCwTW9P1ptQ
	f9m+RBSQy1XsnT3+jgUuRjk2wkFP9XnBu7C1iHr/sbRyOAZz6yjdYetGKX/YuEUi
	ShjsiFYNUxlJLhf7Ht2NtdkYKjKe56SO6aupKdf/dlR5ryC9LixuE50wc8Aq5b44
	EXSgYTgnXGWoZyZgstaIIVGg01CAk+T+pDhaVQdzGE/YY4o/0BHeDbXg6+PJCOpx
	OcL7jTooBMz9xbTAQMebBevY1OIsax2Da9oY9QW321ysoOFBSlxaW+/zlPgctwCf
	oLD4vZfoDqzEDhJaDIeOuBIcJ6iLKh9FiEOSeeoNUTiTXXA/9LUEjqpKTPA==
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnngg9mwy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 09:33:47 +0000 (GMT)
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6799ac3a066so39200949eaf.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 01:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772530426; x=1773135226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CezckF6fL+YK+N5ZT55E1n8JW8aI4FRVkbKEmz0I/2A=;
        b=Mq6r0EMTG3Zj/su4/GeZcB9kexKZPNzBU3AUvXryhAYDSlVQC0fFBZ5VF1eNLqPgLm
         EalKHu55G+3SZsZJHtsirZu4RsKy/1QIgXTRXXUWIUw1K/6TXrZJuAIsP+YM+s6l/z+u
         O9o0FrxiyqFDX4amrnTehF0aG5bKXRgGF6nSAjGsapReIjeoFE60FHwNZ+u7A8Lw7kQA
         lUJ4A9LTdiGLqaoPVSrRfMOixWAPQsWOMVXx5ptPz+mDSJ88oaC0bDwtl2Hkdq6k5wH9
         AKIU8dJufS5pVNfEg0YPukJGSa8c3PFq+AC31SOMvtI/Bo0WfpAKEvJj6jEHfzszLhus
         RpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772530426; x=1773135226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CezckF6fL+YK+N5ZT55E1n8JW8aI4FRVkbKEmz0I/2A=;
        b=C4PBoN58Ez+Ncep5SSFvM3qRC+4eOycicqSsoWxHZtIGYWD/IQFRVT46Ke2u5OHySd
         a7yK3n9pd9NHKMPdOon2x+HREc1mda9bRvD8I6ps7he89XeNbkMx5ke9COVft+RNhKGW
         76qylB3lgBM3s82aZriK62wJ2hCJ1BZG8CJIwa2COFcPA5BdLqZ6Fy+XZJVIZKRq9QoE
         wjA05Fzdwj6q60W7J/fbTXF7Gb3rWPkLBO4pfwBCksHlhECfXaP06nkI1SL21mqNHHsp
         +xF/9hBDEKIwNR1w4Q0GGaL7BawG3AFCtJbygQq5+06I8VUdvCaJnzc7WbABdxv+3dBi
         Aciw==
X-Forwarded-Encrypted: i=1; AJvYcCUl47G4eDyEMcHCFPphpTZ1IQrUngXCXR36lvNGAJqH7/K9YgdgSq6llKbzr24aSvUGTbr1u7m4AQ==@kvack.org
X-Gm-Message-State: AOJu0YwOyxBE4BtIP6Ix28/5M+4SXsmq157V4bbjFtPe3gonSmlE//ts
	bw8djbQJ55NKY3D2U0h5fuW5bkuMTTMK1M7S0wa9eoqMSK7mkfYoihJq6nH3i197+EDh1SlHa32
	OofwgdpWcN7jAOrmI9HKhlqfRWYxt8cnkw9RJSCZkcWM/HoL5o5BtzA==
X-Gm-Gg: ATEYQzxo3qPj9Fo/8p630accr63vqe7/m5TMGRM/QgKLMpIlJvpSQFlrZ/50+l/cSG/
	VLsoR1uMmeuFR6SYFvJP/7bcUd1SYm8pDE4Nqfo90hJ5hmqMa822jHIw5F40WwZUg2Kco3SVdk8
	KEawgrhx0yvltEybWwM8wtmk2u/dNduEexldozKoTrUpvDCwEw1Pgha8hCmpNAhaJ0TaafAJ0NT
	L5jmKPBIuGg86apkUysebBznNHKcQxA8RLUIAl+jlH4HeRs14+PC6izTYIQbrp1zc3/7raeEJio
	mUyNaqmydvp3lRaOaXgqQqYZ/6reMlEclzVMvBkL+hF1YwhBT9psG++k/vkmumR9PaUx9XNmVoS
	YkpGpGBy3Q+yMjNYE2wYpnvKMsGO7HqPrbCU0H7KbHWdwb4qyQU2KFZmx+jsWwZSSNHgunN1cbB
	dKx5Mh
X-Received: by 2002:a05:6820:818d:b0:679:8a47:ab95 with SMTP id 006d021491bc7-679faf9f2ecmr8558592eaf.71.1772530426349;
        Tue, 03 Mar 2026 01:33:46 -0800 (PST)
X-Received: by 2002:a05:6820:818d:b0:679:8a47:ab95 with SMTP id 006d021491bc7-679faf9f2ecmr8558564eaf.71.1772530425942;
        Tue, 03 Mar 2026 01:33:45 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67a1d603f31sm938666eaf.5.2026.03.03.01.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 01:33:45 -0800 (PST)
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
Subject: [PATCH v3 1/5] mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
Date: Tue,  3 Mar 2026 01:33:37 -0800
Message-Id: <20260303093341.2927482-2-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=P7E3RyAu c=1 sm=1 tr=0 ts=69a6aafb cx=c_pps
 a=V4L7fE8DliODT/OoDI2WOg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=ohdZF0R09fBrv2_F_REA:9 a=WZGXeFmKUf7gPmL3hEjn:22
X-Proofpoint-GUID: B8dSIbcIi92IuGX2caYvTYx1Mv2c1ZbF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3MSBTYWx0ZWRfX4FtepM+o33F8
 /nCCz+xjsUQ1noL68lO8DyMwF78iiYbrXJqFVeRQQtlHhYKYV9ipvmKwR0x85fEA+rF5bb8QydW
 G4LI05zxHPl+7gFjIHwc1Xp9C7n4gE29DLEDaj/YpRtERSGqVCpZlfYqFmmcQCKk/qomesWOwFG
 bRAPkret8gYxsZAE0Nt22/0NvlQxRMhZwviYNufMYDsyGqp2HGNn1mDx9RUKDpkfKadmYEZKI8m
 TCUz/U86ThuAG+ON+jV0tiLJAKDJJmanLKPLhMqrCtBahLMB1/HouEXpg1zAdBKzUuZ2ULZrH1y
 SEkKIOiEs88pV308bvUfFWe9Do5qeaffccUbvSjlT9bt33wYMrByVTncl9JVKJuxQn8BeuGkavd
 ZwT+SML2Gzfr6JO7TTsDUtXXbRLxvMYPWEtXG6WJWypiBzDt0+FWxA8gz/gG8Q+HzvJ7WNOztg7
 vjRJkfi/dklKLCXJJpw==
X-Proofpoint-ORIG-GUID: B8dSIbcIi92IuGX2caYvTYx1Mv2c1ZbF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603030071
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DBB5160003
X-Rspamd-Server: rspam08
X-Stat-Signature: w3czaxk8n1pwrotoqwaf9ernt6uch7be
X-HE-Tag: 1772530428-680345
X-HE-Meta: U2FsdGVkX1/lor6pf8iAwTWj+1HeWaHuXoblamlz2j8hpYievn4QDBVz9LsEvu8joiIiAKcv1m5tfjc0mFScK/2r4QvNf5rhyk3tSKFrQPDGKvGRgSA0lz3EQtjAsOdV2H3NRHt42FysGpBzVb/FLE44rRqETYy72ZNRKABykGQ4sE3UG8gIBbjEXBy8MX35dvK2yHXwktSus8VyfDFsMb1oO4iDLDu0vsqaWisLnI7RMeF8VsX3yevk5iF9JSN76FJJczfLjln5jSo2juyknhlQj8OUe3bk8EHw8mUAS2DaXVH2JN/Skwfk+jgDmdZ0hmO6Uikpc5aW4MUihZy9AjikCq5aR4DjzLbTYhPp0xIA22Tfp5wiK96n3WepYugvpj6k2qYPMw4QvoII7IKqmYvtt3QIukk6yFOFOG8FzQVu+a8dL93P/sIkZuVBNeSVP/HkLRs/Jt+lDCoDSdkPon8bBh74CwHL1GH724Jhz2+aAUnEzyqCB5cUjPH1gXi5ElWhyzFKSo3bs1/tOOd8XX1pljO2ce2N72NEG8tX8Z92OgdRX2+lar4/1sFKyRye55YAN+04TP0fjBZ1vuJvMHxf1SFCguwDlBMr6Ru2mYYdKJlZ6clKomrNsCC1brHzThwk1oeaU9wJB2crlUIcYHhu64fnNTtkf+63h1j/+JmjfFgrWo7Tzn8ChQOBmhUBaXtezuXfXHNIltXl8P9p8KHGAkDz3JgilJqKY9PFrLDhCUNs5lMHsv2qNvbAqX5HFrHpr9Hpm2SzDKkTW2hS1RESA+LZRyofLcO51plCkDrT7jg/4heY4/6d0589KRg5xHewiE4C6mixTa/2B7igeEfZSwh/7kUya/l4ZnVRaNxYSq2tUiLlHhaOvJ+CIh3K8/IlHTIzKJsmKbjxWAc35IakYLrlAs4omLQX8emZiEup1T7+KgXUdDY+/aP9gJ16S7ZVtMhl4EPxMp0587G
 wao1mrtH
 4TgTIQ5apnuFEl3zY2A+xwMjQe441G5Ej1RohAcLdRSG+fOWSdEiy8hnEW5VZW/6F0QbT4iRAW/Cxz1UlW+S2j8tC40bBd4NYy5b3bzgAGT7KVOG2L8sOO7LgjX86G1MR7d85SZ6jaM1XOB65JUqzgu3EL0Bos6wjWo21i1bC+9pj8wxy9L1GmutnqhsBtht6gHo5fWPa/lIhrdggxjri7e/+B8ks5rEFBg7JdYTxENb8xJX2sYMU3nt23rkmpQS4HAGIlwmk7W0b5ckdwgnA0u3SMmrVxddznXAThMsQE/PhHiJtBOm1gxcv4j9kfPNXnv288aIPVZ2KVVmJFk8XTDP9T5vEbjiNRym8XLg5X8dOgm5rJeoMWZKme79gtkKUQdtf0nHpe9/Ce98P+lYDjHmVchbfk8jQrAwm8DG9EQYibKuVJ6lQ0F72+CLLkVQa9Ah64Y4k1r8MMU0ze8xoqediZ8nGSdEch+w8LS7lcwUiTvEGCjK82Aaf7PKsZJXiEhHd5wO/QDQcBeNB7ij+4ckvATHnFTZXg5QmY99yDaOl9uR10JtUKSjRboJWpAssbItr/qhyCeE4n5oAZ6toJ1d+ZPMK4jDt/QQJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drivers can pass order of pages to be reported while
registering itself. Today, this is a magic number, 0.

Label this with PAGE_REPORTING_ORDER_UNSPECIFIED and
check for it when the driver is being registered.

This macro will be used in relevant drivers next.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 include/linux/page_reporting.h | 1 +
 mm/page_reporting.c            | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index fe648dfa3..d1886c657 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -7,6 +7,7 @@
 
 /* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
+#define PAGE_REPORTING_ORDER_UNSPECIFIED	0
 
 struct page_reporting_dev_info {
 	/* function that alters pages to make them "reported" */
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index e4c428e61..40a756b60 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -369,8 +369,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	 * pageblock_order.
 	 */
 
-	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
+	if (page_reporting_order == PAGE_REPORTING_ORDER_UNSPECIFIED) {
+		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
+			prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
-- 
2.34.1


