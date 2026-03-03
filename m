Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E259EC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A676B013D; Tue,  3 Mar 2026 06:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1E06B013F; Tue,  3 Mar 2026 06:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F092F6B0140; Tue,  3 Mar 2026 06:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFF206B013D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:30:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3377B3798
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:41 +0000 (UTC)
X-FDA: 84504534282.19.563283F
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B52DC0010
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YIppyilW;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Pe3k1ZVj;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf22.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/GrAB9ZzdxfoJdnHnNk8v/UQou0d1cJUOMk0fx5Asw=;
	b=pTnLoVr08F9+F4Cg7BnpRyT6CXLO87aPxoeC3WZfeJuX5C8na+iBRHMQTcnBMmLuFUgo9w
	VOvgvN0bP/CDTAHAtrtNppU2bm6YNQBNpC7Yk+hpK6xXFl63D2Ti795IPaYXx+fWzDUqFR
	Pk58ITTd8qIjJRLtnAqOx+A6nSXmuro=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YIppyilW;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Pe3k1ZVj;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf22.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537439; a=rsa-sha256;
	cv=none;
	b=a25aEUNxWbJkFp2QgsYSGXGp9MWk8Iv0QMzRoFjWdoOUC/7qx+7L/9UZaijeVmFvG5bSOO
	bbAquObVsVgJcLySVkxCTi1FFYOszl0oK5XCdZ0hoQwWUerSvvOAZK72+Y86iTwu6uBxh1
	qzkIXCqdURFfqoQ7yyBN32jjLEMrd54=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239muCL2773689
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 11:30:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=D/GrAB9Zzdx
	foJdnHnNk8v/UQou0d1cJUOMk0fx5Asw=; b=YIppyilW/cAq+Nt7dLWikSamMOV
	5hdhDDms0iUPUaYdRSrcMoM762jvV/Z07RAsZqVRz8lV0HpSxBnBIUvXi8rydy4t
	lw3gwOzdTUVj9bJAQjk4I50p6szGyJLKK19C251YwnUDGPHlMrHZdV5eXUuqe3kF
	paUs65cQeIJxtjdMESnqhR0yBF57NN/AR3sytri1ClNFbRD091zeFIe8scYxe+j/
	2uTY2cQQdR6HP9C7h0jBM8xuMbpjmbo8/ZXNmp8Eg/3BT4/PExwt/7EbX2LS68jn
	fu/Bx2Tk2T31VWthrr4d8n4ztkU0s+QrDgV2CPFGEaIaufPr0IKqG1gK5hg==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnsjm17cw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:30:37 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d18e95c658so40520779a34.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772537437; x=1773142237; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/GrAB9ZzdxfoJdnHnNk8v/UQou0d1cJUOMk0fx5Asw=;
        b=Pe3k1ZVjuda/HKRr06070ctggjHY16Ugwa0QBUgawypP8Q5AGxY2+DWelIg6UApnr3
         0Y+0eiwLRgeD3HioTy6WPFersuMw0NT8uFLo+uJm55R652Xd/Y4NWfKZZCl8ec5/Vx0Z
         pFk5+R5qqu48cBwa25RAw8YcEhPaChjklP8tUYO/3S7rWn0k7wxuwVTWEklDru0lu+6l
         KnU3KiGOXZJdljuMBbxEnyvkZClwVst9SF/AzJfY1AM2AcPvjFx2UXRHdZILeiCWVGai
         5q34Nzxh0XmsVYq8dEoo8VUOuuySsirIYb0xFxKYm6rXkLMCHnPxQZ8N2DIHQ8hMXvVL
         iGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772537437; x=1773142237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D/GrAB9ZzdxfoJdnHnNk8v/UQou0d1cJUOMk0fx5Asw=;
        b=Fk3YnJcUjTdPzqo/OjCp8SBF5WoUZ57dErmjmLGP1B2UwamzKblmi9h1S2phFEvx4x
         dvsdSElimN/fpEHTtkthNwRB8305Tg73NswJg1Zpy9PqSXntO6ILjVHvMvqaR1XsoWu/
         NJNzuEgZGxw/M8yNWxY2Y4GjXAm+wsLXONW3yVJrmWTh7wNO+lW8cFKN+VCnJg2iXL5J
         TK14rANxNBvV9MC5GaTPVIGZg1SQUByME8jrt6DBSvcTYrEkIloqNWxoyQnricf2S0Ri
         8WJpgoPH154zu6bpWyqYWBVfS/zyhK051A1OIeVv/xQ1Jc8zRZWqYQFyXSqrs08AgMr4
         PAZw==
X-Forwarded-Encrypted: i=1; AJvYcCU33RuAx21zYuBDzL+ExHoYC4EfWs10NaPCdAlV7C79BL9O00htQEtv+FXGFA9AKqVuWILpXyMIDQ==@kvack.org
X-Gm-Message-State: AOJu0YyAB/3fJGgq6FxMgcFy9lQG8ZT6LbTr66WOUf1XWCdoutLekxwY
	ebCS+k+G3dqmrsuTc2JU/ZuaerHEoXzmkXzxpHBikSh+Z9owLOW1q3MV7Rd4uFbY4b8yi8/uOCJ
	OeFX+z6FbnbGDZq+PzhvjQ/TI/24dq/pmHJpp2f+1g3ypOm1XYyN14g==
X-Gm-Gg: ATEYQzzGqqdQQ3nYgLhIJu8NjKkqhy/XG+tHMfDcCFM2GAz6/wvzVhSx/xFEhKsrO/5
	vaX9TMLRrMLX3p0s3of8N81kUxquVrDGs16P1CFL1eOyIxKD2sJ8V1bN7R8X4GS9X9Wsc2JWwfg
	cMA4DVp4oMpLj4C+qymw9XudmhOeGYkHK4vWUU/Yaoi0pbTcIN/hDa7sg32MJQzWtX5qGJ1v1hQ
	/rmT2zBNCxzXLyA1xvFfY42+fZqdrGwjmHLe8RjRzvVcY8snx++xcO7d0YgxSusNX+pKjhUpTRF
	7N1KW9KuFF+e3zlBVMWBfTBOlrcQnrAwe4XpUlGD7aozrd9YpNQogR3Tzhw65ShzV08mLOmqYNF
	aopo8ob9AHN5c+ihDjhw6sPKag6OzR8ZO7D+d5vRFuosotmGeoxJcLkCLsRoz6z7b1emFggSDAj
	F+aBoy
X-Received: by 2002:a05:6830:621a:b0:7d1:90ae:bc16 with SMTP id 46e09a7af769-7d591b6cb55mr10355768a34.8.1772537437010;
        Tue, 03 Mar 2026 03:30:37 -0800 (PST)
X-Received: by 2002:a05:6830:621a:b0:7d1:90ae:bc16 with SMTP id 46e09a7af769-7d591b6cb55mr10355739a34.8.1772537436545;
        Tue, 03 Mar 2026 03:30:36 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d59785d8d5sm9311790a34.17.2026.03.03.03.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 03:30:36 -0800 (PST)
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
Subject: [PATCH v4 1/5] mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
Date: Tue,  3 Mar 2026 03:30:28 -0800
Message-Id: <20260303113032.3008371-2-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: _1ck3va-rGfXf0GhXEjdWOsH-rDAolb7
X-Authority-Analysis: v=2.4 cv=GIUF0+NK c=1 sm=1 tr=0 ts=69a6c65d cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=agIWOxjPXKrzBStnBTYA:9 a=Z1Yy7GAxqfX1iEi80vsk:22
X-Proofpoint-ORIG-GUID: _1ck3va-rGfXf0GhXEjdWOsH-rDAolb7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4OSBTYWx0ZWRfXw3E8rmi+V9kp
 xfSe+I7FO4wRKEe8sZl8n7l5dPftgi/6k+h6PuSgUiKwZNVNWFkihZHVxpzy246NfVpBxcy04m8
 0VxtQee+KmKrOrivAFnWuGA8kMWdL4XmNrcyln6mHHRVYV32zmQWBRJMxDtXrct5TxqPGyjtnm/
 Z2EjkKLDx61iDumb5U4QN9wHZJOnPwkDkX4tBRuTDx0VjlKZYjO4VhZprPmWoanD9x0QK8zOudy
 /DU5cQQf+u5BbQdGdSue/F/ILJsn1aivQexiVVibEzzMvViD77oDw3v09FnEXrDQGT2pZbO1Dgt
 pxYJopATe5W/w7DiW6fIiwleYwOWrjTDNdtsLgBUyiUXyvAasNuhHfNYV83MtqR9Bb6Lj7H+vqm
 ERuNA9cJ3bl/+2huGttmo3eHDbk9EgiQCpUtbp78xtnel8/G0lcfPAtAz+C85dXxC+4rLjOC4I2
 g15n1yFl0YgVUbumeOA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 suspectscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030089
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2B52DC0010
X-Stat-Signature: 6z1mqx7kpndktuskwrdbte4zoiz4maub
X-Rspam-User: 
X-HE-Tag: 1772537438-904112
X-HE-Meta: U2FsdGVkX19RAKjLy2u8IrF6eHDwnejC09XauY+GXXbFkobhOdLsmfrEd7NrwJM0ufjsyORqa50tP6qCCtYBpr8il7JLtt9a1IQKaBm5db9OPh3l2gkeGBYgVpnP6/ePNjvkw1GH98ywqEPaAKy7nGlGpISq9F+0jXp6BhzL28AInML+/Lru2qoqSx7yGGJ66MxkbfotSdzH3X7Mms6nEkfWkx7XDoNitfpFxhkWhd+BrTHycplSeg9NHeDqu4BKsm/4n0dUCrihzIrhWkR/tnLsTQmybfMEE5nGczPSZWrqVl9CxhLTZMqnCTRxiUWcaWGewMXVDuO6zTjiy/yY17txxduLxwzZ0ubWXXW5L7QErnhH7djrX7IAC2pq/QELBreE0x4WULMkWJMpLFFoAjeNt03U3d2kd3co8OX++D8G1B3EVHVXF/XJF4wiCM47yZev17uvWgF4mUmdGhnCUPB9xTrwWZbdtGTuW4KvffvbzT8eiYmPuIBdYDUaOtwxYr3puwZyEVoLcndd6V7GP4T/nBsuQaIgt3iGAzpaMH6WQExVuhSCbJVwPLHZiARvacjKsaLSPrNDJRo9tVRjSIzHemuoVWmJC6ZRWAdLJldFuJcpHZRVkM++Dw9MIIssBnQImqMPDc4hHKtWgtkIF/vYUw3C5V+mOCkyqbr5RiYraPnPImXKIv+Zb0ibUakQ4UIbQQa3qUHkthJGF938s6pKrHlAQGJ9oplpyVr2GTrIo9T4+I9WXNb9nl5bc6QgRsE66WVy3lnGfRFxRG1g3AIMtdhHO7os+uhV47A+hjwpD2NK5VlhWkCQ5/LLjMadQFhX/e67un0sud8jAEGE031oDlOlKe++0T7ulDYwsAagHZnDq1WpdRFAqNRHUo2J/OamWm17tLQmW2y/TrbuOqUAToUMQPWVx2rGgMBpYUJHdc27yfwZ2TFD1x2aIJTZ02BrYwU6tzY3scf9u2+
 65wT7IYN
 rWr5mckl+4WAH3qoFXdayP27vRHS81l5G4PTiv4UFuqzFhmDPvnNQkx8QmWoq351/CVdZ+eV1IUjSMC1lIhO48hzZ/kXjtVa79e2V6UdmGWPnxbEBwTH4wjfCJO9p0GBtadFbewXInNRuZxA2i3pwxgyOV/1ocfetO8+YbQ0TR/6gIgi4sAjsA6mZ8I+8wMg/13o++ApWZZZBA8Hv5gjutpLN9WpeRFEs/s7WqowYjMQ4hIUGD/eZFsb+TcrOFHKisV2eHqjB5t6NLZAlb6qXUCstrd5Y6YjJRbXu3PUbRUxMbISPXflzrN60PTKt3LmKAD689JIBQqmFNuVV9xIWdy0gl72XWJ3lM4fvmVX3u0gstv6uzJzNmlbctfXJ0FQwYoI4zfcikgaWpXenlPkxgEgIe+KqZ7uNZ8urWfQfgzPfR5FB15HupNCDgbxB6vRshcBMcDnHNuCEd99mrxysxh7/2Bf7CP8y+DphMiHVH82a/LHn0r2M0jndEiDPcdE3tm1sJ7xhjHWWibuAO9CjL4iYy1fznuAQYaEvEoxrznRS+ZPNOzvYJzahiQ==
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
 mm/page_reporting.c            | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

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
index e4c428e61..a97ee07cb 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -370,7 +370,8 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	 */
 
 	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
+		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
+			prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
-- 
2.34.1


