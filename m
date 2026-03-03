Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C30CEC047D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2756B009E; Tue,  3 Mar 2026 04:33:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44FCC6B00A0; Tue,  3 Mar 2026 04:33:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352C86B00A1; Tue,  3 Mar 2026 04:33:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2217D6B009E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:33:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF2831BFD2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:48 +0000 (UTC)
X-FDA: 84504239736.09.E9986D6
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 897D61C0004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=XpjBQ3Uu;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=f4FZug3+;
	spf=pass (imf18.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DJLx4++p5N7l++8jI9J/g474bxq1j9GXBe1mPomm33Q=;
	b=SH6BLvCQcpo7lffWPjW48KuDwVAsNDhW6wwXWe9Tl2VwilR9/8RA6RmSZZ7ma1rKEhQmLs
	uTJFhkaqs6Q+uWYwyLF7peveR8XxWRecmkTvTD22hcm3ggQf/MMxPn2A7YI0dG4k9ANmK2
	GlS58ulq8kCrOAeIJINFX2NUmKsMrBM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=XpjBQ3Uu;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=f4FZug3+;
	spf=pass (imf18.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772530426; a=rsa-sha256;
	cv=none;
	b=kLyC3e/bWPw7Z8fPWV1PEHLVjuYHxMZjXAQ3iK87Uk+ev92a/xe98Z81JrNW8BL1v8bGsg
	LaQvtjL0Rt9/xLzp0HoSJWbEAMCoAh+D10RCcrt+LPb6rW1E1wZMS7myaA/+3HRmHNO1/A
	Aah4BvioCUuGCKy6KqFdR2q3VBpEruQ=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6235bNpE2996045
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 09:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=DJLx4++p5N7l++8jI9J/g474bxq1j9GXBe1
	mPomm33Q=; b=XpjBQ3Uu12WblyJhgX+AvwyVf7GKvlvTqaofR1Iuo+GTx3nD7pu
	zJFWRN5SbSyG9B0l6aDuGUuG1sIjGgJPz+MZ3CohbG7S1phKSLkM6qImDwGWRFWL
	Q80U9L2dBCyeK1J1xHTKkN9fVfd9sdby+E6j0e9TUHLA1WiBncK6oJNXbUe4mEhp
	DjQ1V1d5LcsrOZu1/JP/If03TazDsvUIomCu7cZwva0F1LgIM4j6lC8wbHzsxOIE
	QQ0MwC13PJsoxjpCuZrKuEVn6logXsxcdwjPEI0A+XgMKblxAKfcWo8+yrDwcWiX
	72P7m+bs8bpIOSkOWdORSfP6Z6YOJam6DWA==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnh6uad2c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 09:33:45 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d195fe3eb4so95239783a34.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 01:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772530424; x=1773135224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DJLx4++p5N7l++8jI9J/g474bxq1j9GXBe1mPomm33Q=;
        b=f4FZug3+N5cD9wkMVqsVv7RuFmB1oTA4zwOtojoFD7U/f0mvZePAt1cRu6MK0txnn8
         yaROVTuGd56RvEnxOjtQzDYMq6wb09ySZ8RtOTcetCOBsHzMcDgzEFuyTjLURPQK3vi7
         OWHMfVTYtbxpYXj7sRDuoYPXR5CfzQQgkp9zuxUxM37yqO4vevsLpkLq/VRbfycxrGJB
         XsPW0YRp1hOC6jacdDVxkARNMMyDMoDgssMOnPQ7FnkMI1jiuWqm02kC2JPj8mdxwnI2
         YHU7PTugqCFAmv1F/TyTqMhsHdmMCxdrtKuRbwv7igy0YMVb9VQpUjv/bnEan5jOXI1C
         zVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772530424; x=1773135224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJLx4++p5N7l++8jI9J/g474bxq1j9GXBe1mPomm33Q=;
        b=dOYg8DjCusPU35AQLMBmkakgPfAG1YwRZMlMQISCYb/dMtVDDPvWWOCGIhvgbHy7Ch
         VqlGwKIoRFMvKAppBekFv7c3fjhgE6DwN5mZdn81XBc0I2WYGXyFqcmed9rW0Lh8ZbcC
         AFbmLOQbpVBk5o5F1X6F2CArVrsnB8KnpEZBhyDPwhxAx99fPEHlb55+bl+nCGCMW0wH
         zpCOe+0gpTjAVlZqlM0NOAhj5kbDFW0guDSB5xIpFQkOFYV+rhhXylPVL73iavuoiuu6
         tQmJ3Ut+q6Vrbv4WaNXZ8ESsryb4g2FcAz2I+qqDjD3DTrg4nKPSfEnFXuofMOHplKBl
         J5KQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9bCfLHg0m/TOoDdcgBFUw9Ckl08UYpA75+gRhe48t9BduP6itSjLU/8viLAmeBk2DV7AFAKjU4w==@kvack.org
X-Gm-Message-State: AOJu0YwceMrSITSkjwgAFjnztaaUlCtTL6DUBfKnWQUD29WK8N6UHPcq
	Zi9ovZmyJv64kkd73x75VanZgV6Rrv3QTbSaHFtGb3h2T2sY8fvcgoATIvFjfRZFFXypbrzRBaO
	4XBEs/H63nLsyiowsXWUj2maErp+Wco1lpYFx2ta+2dbewH1maWGf1w==
X-Gm-Gg: ATEYQzxiM8mpQMxgF3nvHuidFhNcJvTa7fvk8bRAaYhzkamxk8UgrTB147w6tuvd0zT
	09wLhXoJi8iNv0aoEyOx+SqjSOCwmSXewifedsM+zqZ2+G7SKAvrxFFFLOGeqc17KoQJHAjHFVa
	A5ukspYPSLT8VpmSIK+6Kja2cf+0x4FCOHzKRqtpU7e0r6BNC0edwGkJBGGkuAQjswXzgGHbuqT
	ynAHDiuqjjFOuKuT3lYjwV5y/jiwz4t0RSVd/Fg1Kl5VwlcF1MwP3EI/wIny2rdEjr+YYMrjs9G
	bxtPjpZ8Fz5yT5YxepQme0Rhb9/FV7A5PZKu9I9TFMgaGXm74TbG6PAt3Hy86n9tfflPFk/BeY0
	slQp1qrLClSgU25axq6ijKksy58k1f5XjKsUryVwzBs+EtoVYE3ihmuMUWwZu3efUo3GErNqPx6
	X5Ojst
X-Received: by 2002:a05:6820:4de5:b0:673:3cef:fc1f with SMTP id 006d021491bc7-679faef8a08mr8486878eaf.38.1772530424299;
        Tue, 03 Mar 2026 01:33:44 -0800 (PST)
X-Received: by 2002:a05:6820:4de5:b0:673:3cef:fc1f with SMTP id 006d021491bc7-679faef8a08mr8486861eaf.38.1772530423888;
        Tue, 03 Mar 2026 01:33:43 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67a1d603f31sm938666eaf.5.2026.03.03.01.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 01:33:43 -0800 (PST)
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
Subject: [PATCH v3 0/5] Allow order zero pages in page reporting
Date: Tue,  3 Mar 2026 01:33:36 -0800
Message-Id: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3MSBTYWx0ZWRfX67jYeIfQHqH4
 ocA7Z03BnzbEl6UKBuAuuqMzSRu+5iZ0Gps9wb9M764ssEfMGXi8VvvQUM7eMZ6rKB+V9RW4+PQ
 JRxYb8cpU3/2AaE7UPCiSDHhTJ90dMChwVlwYJndOmY2lwTi4Q8Qt+k7onKy/trK42vUsQPCvjo
 Qyf76YjzZ0trDgY+XSR8H8tGgPF7sSv4CEOX81CYF0x+w3T2ftfLxGr3NkrcbBTC/PzDdCldZci
 S1pYfDNIO8hS+XE6/1oTC3vyEHQ5d689VHyqKKvlZtUvPRKXA+GJB0hpDgr6chfbsyc5BVINNtt
 gBAxfbDfbAvFlY9VNtNGMWm/A0yff3WuGa92lXSkN4WBYMUh31yL87USoAaZDmQHl8U/vBo1TC8
 AOFCqwjBVBFecha5v0+qtarSn6GVjzNSzNpBj3SUVd+ebgqhHIfNEe/7b2rofY8UdVcDuhEOvDH
 0ZN4oQT5352i9I69phA==
X-Authority-Analysis: v=2.4 cv=MuhfKmae c=1 sm=1 tr=0 ts=69a6aaf9 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=HYTG7BDJ-qdBC1FqdxkA:9
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-ORIG-GUID: NENRQZolKdQy8zV-g6FS5rkj1xfJqvGN
X-Proofpoint-GUID: NENRQZolKdQy8zV-g6FS5rkj1xfJqvGN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030071
X-Rspam-User: 
X-Rspamd-Queue-Id: 897D61C0004
X-Rspamd-Server: rspam08
X-Stat-Signature: zsdg14wktprgt6c4paspp9ftme4b5y1s
X-HE-Tag: 1772530426-369575
X-HE-Meta: U2FsdGVkX18IQeXxk0CuqkdOMU+spvqNM2m7yD8aNJrRIAt8RJtNIplo8gEOn4x/SsvyotUn1zuscIoDLAQULjJ5tj7QOYLwHezjwnEDotW80798k6+gi+mpz91PSgGRQYBk6YwTWSTD6kW4YeUvOaFFEAAMG+d3FeDqAjpW4YVmSeMeN0BD4w0G/ct7A0yea81u6RlT9KU9qIkPmZPCIwEnpFiVO1HDY2E+lniqQVHxMF2aebO7pSh1Oo2jFyPJFzZULYjcGhxsPkP1vK1edNCv7GevkgP75Dma9Ton8mq77Dh0yhhNJAZqtt0irZa5ncg38PCXmcZ/ke0MSn/4gvxRjgxqnIsy/fX5nX8gEI/SqKmNipWwWVTBJwbOagE9ukcvU18wZFqdB2ESH8hMwY3jOf/OEYPcIrCS4fGWm3SHTSAQSbTiK6fUVeu3CcEUDKEJgZh6xAsjyHKOyfKLYz1pQniiF8bl7ZGbNAgbcaMwwwkGXkdQawLkq+T1dKKJo21WXBFK0g4URLmYag3CRL6ry7gDVfF0jlDcRregQVXJ9k5XFWa2RczVLvif8/FPRAbyofaqqrVzpC5tugaYQiNBacNvHeyNJXkJ9dlqfg+NVfd/tS9Cjkq9EToILFel+6iKpLpgI2LeNIbu1wf0imA4HQEQuEWSJ1x/dshQzsHjdBiIGpIvVfpCsxqgqxexQLRFevyOUEupH707+DVqebQIKh6KqCQIDixR8DHIktiVf7RZ3VH/NXXv2/AkVCPOh3AUuG4+zSerPfL9j67E18ipONKViR0bB34dYINP0f2tqAnCeRe/cu9FmDq6mfUc5FPMHcQG4ptF6tHLLrjqtrX+kkbPeJMfYmzYu5GimbHNZTfnUM+jKBRknT1GURUtCEDpuOLZsjVZAG0xn3PQGrdgKClPMnPLrVLe1z+izI1vFO354RCBvh7KK5AVrgXRM758Ikd65i7kiAEfbyb
 5M/bNtjf
 Gh/C/1ISbW/uwD/0JiF1jZF5Pd0PzsLDeTrJvCPIbWZtyILhpgjFhdY1FAtrmiUXvYUjsUxjDw/h9avq8LW8fKUkJwwP9Nlm+QUvN+UqwRwY62tZrMjz5ZXKqEMGY/GbONytVRUMv2guIuUuEZEw+sTtQYxjEPSDRug2sDO7c0ZkP5g4qAD1oXl92GrAfPHULg/nt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Today, page reporting sets page_reporting_order in two ways:

(1) page_reporting.page_reporting_order cmdline parameter
(2) Driver can pass order while registering itself.

In both cases, order zero is ignored by free page reporting
because it is used to set page_reporting_order to a default
value, like MAX_PAGE_ORDER.

In some cases we might want page_reporting_order to be zero.

For instance, when virtio-balloon runs inside a guest with
tiny memory (say, 16MB), it might not be able to find a order 1 page
(or in the worst case order MAX_PAGE_ORDER page) after some uptime.
Page reporting should be able to return order zero pages back for
optimal memory relinquishment.

This patch changes the default fallback value from '0' to '-1' in
all possible clients of free page reporting (hv_balloon and
virtio-balloon) together with allowing '0' as a valid order in
page_reporting_register().

Changes in v1:
- Introduce PAGE_REPORTING_DEFAULT_ORDER macro (initially set to 0).
- Make use of new macro in drivers (hv_balloon and virtio-balloon)
        working with page reporting.
- Change PAGE_REPORTING_DEFAULT_ORDER to -1 as zero is a valid
        page order that can be requested.

Changes in v2:
- Better naming. Replace PAGE_REPORTING_DEFAULT_ORDER with
        PAGE_REPORTING_ORDER_UNSPECIFIED. This takes care of
        the situation where page reporting order is not specified
        in the commandline.
- Minor commit message changes.

Changes in v3:
- Setting page_reporting_order's initial value to
	PAGE_REPORTING_ORDER_UNSPECIFIED moved to
	PATCH #5.

Yuvraj Sakshith (5):
  mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
  virtio_balloon: set unspecified page reporting order
  hv_balloon: set unspecified page reporting order
  mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1
  mm/page_reporting: change page_reporting_order to
    PAGE_REPORTING_ORDER_UNSPECIFIED

 drivers/hv/hv_balloon.c         | 2 +-
 drivers/virtio/virtio_balloon.c | 2 ++
 include/linux/page_reporting.h  | 1 +
 mm/page_reporting.c             | 7 ++++---
 4 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.34.1


