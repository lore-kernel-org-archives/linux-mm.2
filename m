Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2B5FEFB55
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7AA6B0089; Fri, 27 Feb 2026 09:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968756B008A; Fri, 27 Feb 2026 09:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815D46B008C; Fri, 27 Feb 2026 09:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B71C6B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:07:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AEB813B7D1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:07 +0000 (UTC)
X-FDA: 84490413294.18.6EE9BFD
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7C34E80014
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=HZCZ67n2;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FLWIILIf;
	spf=pass (imf02.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772201224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hiLJ34i16BM9bLJjsXt2y8E6JkcgWXHQvTr9UwVPbUs=;
	b=Bj8ma6CRS5HNzKqegqui6dS5wfltdt6gZR2TMM1bpo2+LrSVuwzryz036OBkVJBdvsyOfb
	s4b7CScmr6+DAa23e7mNQvSXieHNeJ2B+8M1w7LlEah+2bAaMT0eUxPKyjRpIELDWtkNB0
	Ohbx4ws5JCHpwzuXMiQqwVezNZHKBfs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=HZCZ67n2;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FLWIILIf;
	spf=pass (imf02.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772201224; a=rsa-sha256;
	cv=none;
	b=sz/zknssgFNaJK5xhyulf0jkkkHfLJCFXNvSXTYJ9hScNw73MnzVSvCtKQw1iczqwkgfBS
	IyfixiUbdSKVWropHWC2kg9YpLyHydT4wy/h3CDKBbeubuOiL87AB7Sb+bJ10zyA5yFc0R
	C4+B53bgNzpn0b/RyvHg/Pap8FtFQZA=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61R9VAtB236992
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=hiLJ34i16BM
	9bLJjsXt2y8E6JkcgWXHQvTr9UwVPbUs=; b=HZCZ67n2dWR6CiBijqDWsFZ6epp
	ohL6zAH3hzMzniM+XkdlZ8UlI5X+9odr5MoggeyoFawVDDR1YIMdLJVIvC7CeUGe
	Krsr9CeYzl0Xt5aaLBy/Unonpg2wxVGOr+o9LGUusE29TYnj3fDvmsnk3ovZqTrw
	wVFjggRmMNz4OpL3mauQ4k0YrhZq0xRlfs37XyvaQc7ntGklcqQYAtLvtG9wtmt2
	jjP0J5vPo1f9imAms0kuRTe6uoOsYYWYljO1WfMrt8Ce7HQeKvhybQLGIVu0q6bp
	Jf04CfFCa6lp8EdY/KQZ4mYsgbO0xAisST7ADe52ukKRHpstzBwox6bIivw==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cjx1xttef-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:03 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d4d4db1523so11051494a34.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772201222; x=1772806022; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hiLJ34i16BM9bLJjsXt2y8E6JkcgWXHQvTr9UwVPbUs=;
        b=FLWIILIfDWvM9792GU4+fc61cpYJKYYXRSibq5dlZIKWewgxVkNubfbg4wf1CXnX15
         U7M8JD63Y6ljs4KsW8CrATC3TXmWaxT8H8bep5C6jToB0O/zv6tALPrKKs0uTeqeUr5N
         9mV3v8rieJE9n8eoSVJPN0aGUkqJUKLIxmOu2ZepgXuKyzxZrHJydwSODfeI1V9ILRMq
         Er8FGKIV+PvqUksLONFkx3THFEQbMTu6ndpCreQb1C3C4Ed7Yd2ionsv1JZHI66L3aLJ
         Dmx891iGZvfKbefz75+b0k/1wMFM0WlLyx/K5RO8RclaY+DeScRsZM2PtQQAPM3kWQ/L
         BhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772201222; x=1772806022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hiLJ34i16BM9bLJjsXt2y8E6JkcgWXHQvTr9UwVPbUs=;
        b=MCL97q6FP8U+31DsKwZJNb9GG/tRs4tRh42Wg5QurpgtGD9DbaEeNcqydqTQnov2Io
         36i+cbW2GPcdBTTTzzUj6fNnssyX9C6GlSgSdi74x7ZX76BqcgljD9iEoMr6/zx3TtGo
         gX2uN93gXqXC8yXfvCWsUWrTlVlHpYQZJ7jZMkZahp+lmjLLgH4HGSxfk5TcRL9ypILb
         NNltBlnLKlvNb+DGEahb4EJBV3RmYMDSVmwSIn3tRXyJBnvEl5DukHgdvGvIaf4i51IZ
         7E/1udtPWGjMTa7GxW9SQTo9lfq8dLHdiQ2KIRud2Exoo/00JTHBkWahUnd7tSrWHNOG
         d5Xw==
X-Forwarded-Encrypted: i=1; AJvYcCWIZgjFzn92iOFjqe/VG/4V2Zjiq590VUcIoeO1G0ObW+ObQ4R5Hd5aFAR7TUOPXAjIngH0dtLffA==@kvack.org
X-Gm-Message-State: AOJu0YwoRv9WEfWE21KRZv9bGnR5vPXBY7fq7EKT3rocisXhoDjULP/G
	h8IIeXlyZSRYfRQY8qlFQa9Bv7g53WCZ+nHf46jIzB2tbV+q9og6ifiEyfa8C5JYlr54vaxyLe+
	DUr7LRT6rq9h2ws7bbm5htBUStL+r6Yrn3JBMXfpFcX6oMu40dLr/OA==
X-Gm-Gg: ATEYQzz/jlOIFbit2XWgptWuHlL1JhWj/Ea+CVi4lTR6vQX+x1yX58MmoRr9YwreD4+
	hPg6tBFQQ1UdLn0qybSUXL7JGl/dhnWV/HeZNDIAYgXWpf2+TRitwCXbYLpq++rOKJvuEfTFFco
	DfYxHJXpW0LB4I8se2bu3iFlN7y7E2GvWmBdkh61b8fHX5bsUevT/UpWxcwgHL8Xe0u+TcRQVEQ
	d3yBKUc+N2otR3425Aw1zZfzrOmCR0zFZDsjtMshnAX4gQN/2BAC/CZzn6ltO4Mip6z6TWd5S+g
	VXcYNuDYYdVzqMKbhVd3yMueN/f7iuW30UidqqN9jQ5djvX6++eK8xg+HFbkWqGxbG9jMLoaHbW
	4gUs3kLf1INVLAKDBxVUjseKFIqUqHHIUaZE1udeMptWCHWQlJ8kDVSUB9HgoydeqbeyQkaKZ1/
	M036Wr
X-Received: by 2002:a05:6830:718b:b0:7d1:94d0:e8f1 with SMTP id 46e09a7af769-7d591b2ce8fmr1792346a34.15.1772201222454;
        Fri, 27 Feb 2026 06:07:02 -0800 (PST)
X-Received: by 2002:a05:6830:718b:b0:7d1:94d0:e8f1 with SMTP id 46e09a7af769-7d591b2ce8fmr1792295a34.15.1772201221840;
        Fri, 27 Feb 2026 06:07:01 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866269a8sm4324502a34.13.2026.02.27.06.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 06:07:01 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org
Cc: mst@redhat.com, david@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longli@microsoft.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
        eperezma@redhat.com, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/4] page_reporting: add PAGE_REPORTING_DEFAULT_ORDER
Date: Fri, 27 Feb 2026 06:06:52 -0800
Message-Id: <20260227140655.360696-2-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: hD2noLic1TJf3QQhFB8N9qDwsqDgl-3B
X-Authority-Analysis: v=2.4 cv=Vtouwu2n c=1 sm=1 tr=0 ts=69a1a507 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=agIWOxjPXKrzBStnBTYA:9 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDEyNSBTYWx0ZWRfX78RA3hAtymIl
 eEa+vW8M2IvQukfjt5Kke/dBQxfKJtYdEfHQmQiBlCJ1rUoBOXSYMrTAmyZk1clhvfHKP4Opc9Z
 YeJTLQFWloCWpXbyXaXP9VQyauqBqJU9r1jfNtOoSm8oSB/zYHtajKYjv9BzWxFkVOWGW4nZwwn
 ZAxSMlhgen5njynpvM3phQhxIJ5Tpj2kFUk16yiExfAi+s1nBvzyVTciyOmd9g+lnzTGWpVO0v2
 xTWaXTvuV1aUCKqZfcxkquJMdRemPjlAu9fzLNjnxfpn6dUcjmSYmNrT22AEPxAhGm0JRfQgyXl
 hRUnA1H4BSsIB3Dr9aCLbKojO+PZWW3TswLj4nlnxcYmRpDFvGqMRDZFXOFx6IZEp82lGs2A4Pa
 aNn6TjQqsaTiXV1llkEECPfVvELCSNVc+xk7PuqcAC266z+wenYGYxldLhHvVg7VgTpl7Z5Wk1d
 HoTme/vaqsVnSxzd65Q==
X-Proofpoint-GUID: hD2noLic1TJf3QQhFB8N9qDwsqDgl-3B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270125
X-Stat-Signature: hgas8g9pyu9x3rfokoczbdkptx9wf3ms
X-Rspamd-Queue-Id: 7C34E80014
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772201224-695707
X-HE-Meta: U2FsdGVkX1/oq+aDj5EtC7aUHrb+aYc3eePjwRIz/OkVRLCmVSR5daa+ILOolqkXOXl9kgPqh567fLL6ryz7sqUDyuh+5HhrVbSLXSuV039GWYeRQVPZrCUQ2buKBSC0qy5f1kvON/w4v/rmJM1Q/IhvEwEm+d7fI9Wm35wHeS0Ro3b6s4af9mNGaU2PzYdw66jpDk5SHVFeC29NofS8xkRI1lcNRE/YqbRlehjEbWFl/OJlRgZLu1UoWHaYAbb14ofmp4TgxI4L+dUJARUdwVGdSUyRQ2MOPdrZXD9chpErzZfYzhV7ONRCBUJpwKCAOSgGSUPNGdxGuvvUgfgWbQ7QZND00U+p4EZ6DhwcYCZBg4BJGmz+8mUIX2n9PcP6EcBN3pBWXLS9qw6SDQkZ2cSjKCcVlZQRNtgt71HhAvHqPNxicg3WPrA/6v9w6KVDPIcHu7Mc0c+BfYs2JO85AJzA0t2XLOojvbADdu7XeUZ9mFMRVlFd3tK8IoTBQD2wpBO5uUcONi5oKqiBUY7w0TNY806sG+FiYvb9G94Qmc2rC8MilC9keVYwO5DHtBOzEDkJnPHW7XpUrzfHtLZkbLGEyL+3+qxZTy3o/svB91TUb9U1PbXTaiO8mnNrsltU9dPNX55pRJTKfo3d9UrMhdv/E7OTO9Ly7j7NboSFdqJqMA9VhHFYtuN9U8aS7vr4CVHsHymnEtByJAyEIRnpip+twpkYGKMCwMOdCeXNyQ78+AsKXbLC48pZT5hm1Pb82fDkh/Uv2hj978Zsdl5Vf6aoGsoZT4BVUEc91EQ1lSwF+DU7TqNQZR88ZtzcohIcoUWh258aYW0se2/QDp9xRbAW0jvyx4iX+98dHlDXLeuFszMOO4sRvqTO4TgYmXAm2Lhuyk7DoZMWHrogYmUIHslXo7S4Lirr8zgx2De44pBjoZiRPlKIOZ9d8gk3pWxG6RoZmuJTwejS9Wu0C2K
 6J93KLRP
 yiRG4NuPs9GnpWVIS7JF7zC1inrw06y/axtEIdLwtZ0v/F/HO6dPpI8UuzisciHBo//t8/ab3Gnw5zEdTzd4O6GTT3t9VuIMvUW2nB2aNit22U/EOQ1iTgTY99dXpQaG/uMwdnGcJPNKicoK941dmxKVyI8PbPTSPumvxCpmQM3zs37YOn8p9gnqahmKu8op80P9VyCk2qfr61wNsQ7/prpG9uqE4y/Sx75m7cpjbKXQQHDi3vEBv7yVw4bDI9Cu1rSHBUYNDu3MASW8HxVTtA8+9jrVzgfb2yNGRAWTfU5WcD9kvi4XbDX+7NBEt3GmZ7sSl0oZ1Vn7a17gmQfWXo+QF6t++qB+JKO+3krakXQd9dQOs6+VASeD6/m9ejA9/b5D50wzZUahiij4cQvvE/P5i8/GC8v+eORxPEdbrQru9ryFMzXBrakBpqvAl/5HxdQZtWqlbKz+vSy9hJUKKW1GXvlqFeAtHuI59Cvan0uCUgIaEh748d0R7KCXf5KWvMZC6PWkfq2KilBuOolabziZVy6wLseuvwT9gel3ZzHF+A0uOh1FXPMkZ8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drivers can pass order of pages to be reported while
registering itself. Today, this is a magic number, 0.

Label this with PAGE_REPORTING_DEFAULT_ORDER and
check for it when the driver is being registered.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 include/linux/page_reporting.h | 1 +
 mm/page_reporting.c            | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index fe648dfa3..a7e3e30f2 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -7,6 +7,7 @@
 
 /* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
+#define PAGE_REPORTING_DEFAULT_ORDER	0
 
 struct page_reporting_dev_info {
 	/* function that alters pages to make them "reported" */
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index e4c428e61..9ad4fc3f8 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -370,7 +370,8 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	 */
 
 	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
+		if (prdev->order != PAGE_REPORTING_DEFAULT_ORDER &&
+			prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
-- 
2.34.1


