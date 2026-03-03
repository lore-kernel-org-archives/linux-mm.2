Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DF4EC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985566B013B; Tue,  3 Mar 2026 06:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C1E6B013D; Tue,  3 Mar 2026 06:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B3C6B013E; Tue,  3 Mar 2026 06:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8C86B013B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:30:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2435F13862E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:39 +0000 (UTC)
X-FDA: 84504534198.05.CEF8879
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id CD43B40003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Ya2HduJ1;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=hPC5C+vX;
	spf=pass (imf04.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2jhEbYgGPpM9YgBi8KcAq9k2DT/kIdh5p+LNtRMjpwI=;
	b=AK34MLxqh2vS4BSsnK+eELS+WAJ7c8SUXp4m9E1e9+1B22w6UYa+Hj3T/eZXm98hSK2a/d
	Oo765L9o02q0zbdantt31boIqEC3NtKjgZfPS8eoBegHv4DqadOn8PktwnMuuTwS6hCscV
	IUXhqS4YRzgqD6Y8FK1EC0on5ZshSeE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Ya2HduJ1;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=hPC5C+vX;
	spf=pass (imf04.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537437; a=rsa-sha256;
	cv=none;
	b=dUymP+acgh8OPkkPbXLFtXrCCuGH1e/zcYC5l9LzWu5D7+WJMvM9VG7seC4YYCTmBYKtEz
	owd0q6V4TjWjvUdaQa9BR63cpxayeOTFh3rmmfPqLe/brumn388ry6KzYC2iBjkFxkjgXu
	8WfzHteoJjBzJE3sE58M6yn9T21SCEM=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239mgQ52613791
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 11:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=2jhEbYgGPpM9YgBi8KcAq9k2DT/kIdh5p+L
	NtRMjpwI=; b=Ya2HduJ196mEDx2M2W52dArVnBH9Llb1RLVi1QopdD9NKEKc02r
	dePOX4zFt3VO4YNGCZTkUH0ZtfyH8eQa1+YaoQ26BmFgHZmRqz0Il1BKoRwNPoVe
	G9sTv/gB+Bvejl+JXB7K+rqzWPb2ObULyTGyr4wLDAAhIzlJ63e2ikhoFbFs6WxM
	z4iiNVroxrU58YliLMLbttjy+YU+6IKiLLiQ5aVI87Efy1sz1HFKNuEoHrxZAkCE
	eNK7sUAey7UP0rojdxuF/ETuISVLyz56JBs23+s4UkK5wOpgRdl9ebBQPoEDF5fZ
	PCl+nwdoeVGIuhVhrHAKjGlB9nw3wH+yDbA==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnvxf8djr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:30:35 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d4c14f388eso27879609a34.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772537435; x=1773142235; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2jhEbYgGPpM9YgBi8KcAq9k2DT/kIdh5p+LNtRMjpwI=;
        b=hPC5C+vXpWbxEm+NyeMDCD/4iBb6jNZQVPTSW3+kNBAzR66mxoaoFqaRLqkcol4uW7
         Jexrf1daJqRB9Bfbc4kEEHbw4H1W4evhS05mzn1thUkpMLY+iTpMrH9zEbrPJJ0Ymuwv
         yEN9yjSpoPOWq8qL5L2fKIf6OVFnv3CnGXLWupmlz24jQGbe16eaH5AO/e76AKmPK1Er
         Y8ZcNGMUGAdt0uXTXEJ4N/B//rthXa7NiROVhxJ9HmkwvAgIVtg3qmfjkGbXUDyALlTg
         pEaXJFkvq958SpVWx2ICiZ2VA+sniPgwa5E9qFt4KxUSWJDzNqym0+4Jh22NzZY460m4
         y27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772537435; x=1773142235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jhEbYgGPpM9YgBi8KcAq9k2DT/kIdh5p+LNtRMjpwI=;
        b=rf0Anrhv5+2oMQxPR2/mlxyGMZmDLTF4apw4+xa8Urfz72CmjpsemE0SR4p1r9mcYA
         62zv6fd86sqaz/1lB6fu42XnbYExEODhUAlvOzblm6j3bVYR7zJjv0x4awiFMew2leNR
         ONnEu2f/lBdVajgOoUAkb5Y5uwt/9BNmR51O5YBKD/V+aCFHZfRrMO9aAnGD+pOCaY5G
         v3Gp2XisI9/I4K7UJtL0cExJylRudqawQcE3fkGCX1D4fjizStrtytHC2/tvyB4NWqP/
         qRJyTSG30CHt2X9BVLQhqaDzskMzB0LZNHkaVixQfmrtmBloZrDv51KTZORaHEgo+U/3
         by0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXUWn9At8+qY4TCRaQooMMODNqXnTjC7Q1P5s/TIxnDIiF1QBucXB1HlDpWTw5iqtqjcVyXaYkB/Q==@kvack.org
X-Gm-Message-State: AOJu0YwOLMl1B/ZBzFogDufb1TIocUeEvYPNDB8WMt8tTB+l2tMVH1C/
	0mCC/iGm0phAY85BeXxWo45rk3fqgcO9NyViLdTbnBI1nJ9MQQCXDGAfL3eg7At7eYahTNfnCUx
	V2cMsf6278IRnMqHU1VpPbFKE2TWE1Dsi1SSqcDR6ndo1MLVCoPzg3A==
X-Gm-Gg: ATEYQzwiTVs10j/K3K1SbTh0uDVPdr9rJKajb7E+mPcuzyS7cdyb3F7eBx+ybptn6kg
	hOVR+7tksOjg/3B6hFf/Wl3RloEpxARGa9ssOYebqTRHxUK4+SCqCXVByLXtZ2YITPmoya2dWra
	tCZHMldefXVaKs4ux0HtmsyC9IDs2CuS2Y2wli8OGVT2FIFOAi62vzRVsZNAbIvFeeV72yMp8Pl
	/x7H33k0AcZ0V3iHB2qF8MTz/iVum6zB4NmHZbU0a4QKQgftmHe1UVxx13isf9XV510S5dDkZdM
	/5XTY4Yd0jC/ZEq0Hy0buvkiyvzYTaNzCI0ttwY0BQ4DgkG5WU2Cf0Oh0KPdhKhXSTfs1GBm4zq
	yyfcZuMXuDT4bWkuM+MCn3lzya9imKhAgVr1jLctoPf2MXn+pNVOJzYRkeOr+5nTJhMdBlFWJ96
	iJkv7/
X-Received: by 2002:a05:6830:6186:b0:7c7:5770:d2bd with SMTP id 46e09a7af769-7d591b3881emr11120281a34.12.1772537435260;
        Tue, 03 Mar 2026 03:30:35 -0800 (PST)
X-Received: by 2002:a05:6830:6186:b0:7c7:5770:d2bd with SMTP id 46e09a7af769-7d591b3881emr11120249a34.12.1772537434819;
        Tue, 03 Mar 2026 03:30:34 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d59785d8d5sm9311790a34.17.2026.03.03.03.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 03:30:34 -0800 (PST)
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
Subject: [PATCH v4 0/5] Allow order zero pages in page reporting
Date: Tue,  3 Mar 2026 03:30:27 -0800
Message-Id: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4OSBTYWx0ZWRfX4wjRGG0GsW2k
 MdPc6t/OVPUUVXJGL8pslQpp2z06y3AZALM/lnNCDBNdGQw2HNUfIHi4YIut7FE0IpS69pHpDlt
 qI75JPS/pSrTvU9TNtrPxeTz4GbJLZkm1f3IE7m+KGtlJxmJJtb2Q6/zezx/BpFCEdz4v8geYdQ
 wA9CGzvNYwOgrfnD6ejMxdIe7znQUvMZJUKyFXeJTBYPc7tO+AArmw2iwB8HznNiSOcPW7kdf4o
 QlvPZUHI0G1d47a6jg0U8Ce7UnSpVoo+WIOF2UOrAgzecxQs6xKn72LXC6GMvZHOp55zitr767N
 GG3gIMpYN09zyi+8vnIJ8z4Qt4DkRLiKabLwu1VXH9li8J0AoWSX1+HBryEK3IG1RnRMk6xx06k
 VRpX7klzpsF1M8riE5U7MrS120zMoqrAPDVgT4LXXtO/V4x1sXBR/sBf6rvq6Xt1ryyQu0aB6ap
 0Pj4Q5MAbiZupwozjzw==
X-Proofpoint-ORIG-GUID: iDyCgCDf7eSNWYPtQZSbAF84A9reMeGG
X-Authority-Analysis: v=2.4 cv=S+HUAYsP c=1 sm=1 tr=0 ts=69a6c65b cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=HYTG7BDJ-qdBC1FqdxkA:9
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-GUID: iDyCgCDf7eSNWYPtQZSbAF84A9reMeGG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030089
X-Rspam-User: 
X-Rspamd-Queue-Id: CD43B40003
X-Rspamd-Server: rspam08
X-Stat-Signature: hhnkrg6qbaco49u6gff41k3qkod8jazd
X-HE-Tag: 1772537436-918618
X-HE-Meta: U2FsdGVkX18RRFono26icQNS8S3/V0SyFOwymuw/GttM+VUGw0dGCVNhdmyQCQ39TJGo4eE078jvQuxt/R5r3NM4i9zvIJWxFmf+7YySrU5A7j8gNjkg2B8+8qVY5khaY4hom3c2PZvseuMQFHvwOAKY4/RJSiiS9aOUR1knpoLC6MQqtHpbKM7hOHfi3CjGE8R9iii6liUv2KZaJxOZlWavpnwKmXBMmmQBSrzFI1lrdP5sTzPSByIrEWuZg03DUmbOl3MEez5/HRZcBaQowT/ry0vSHvOtEBvCYBLzAbLGHXuMv9Wl8bvDXHKh+j/p/ybVErbNdDoLrSbn9uM9vyAtLPUTK809lCql8BKfcQAT3ZjD2YjlhfUcXf11ULD8CdBi5Jj5KN296pXzsTAgq5kOyzcSYxqmjAym1tIzMduLi/tpfFBg53LhbuN+Drr6s6kK1ibDbFumCx8mwrb7NfM866zDtNcwhDKtyVtUekxWcHAnB/6+UbuB1x3XzRevLzLogfZhR5ui76aEsCK4dOgmCSXBUViHUxQgptQjQcWJvcPa2fYBQND8qvZ0JER/17rSjqk8Xa9sn8nMmyq/o28UAc+1XpM+KYsfNX3w18h3vQ+fq8phRfO3FwWWUIQgGb8SFb1eVebFYkW91L9kdifbDdyx0TFxt1hWvtvoJYjAPirxR/XAhoYVZzpSDmKg2qKoVoE7HLOfgxH6tZ9O7vyGUHeurQK2Q01KQtKFeTPnEZfAHqPj+g5mWRIjEVCqIlkXTzb6yLLU/X3U0reKoaP7he+1FggyE4jd3o3kvTMTGoSHtd7wKp3nsskaWlNUzHjmYQuu+lTdRrARMpJiOxvUC+qNfEn2dkXOd6kgpTqE1cRco+9I+d3KUgi0lBJJr+nlkruAB69cxoBOO72z1yjnbvKGSUju07QCx2E1PdOqdkFMecK/hCFrMh9DZdgrj5xwYmdCl73zvJKtZaD
 svbvQaJU
 PzTVgp2grYi9MRN442b6clMj4kEh/QSO55bOku6d5Jdl1xfD1Yo4OrQPqoUHEm4tpHW1xS+wlZGOnQ/zQvcimwGaPov3/ayYjSq0eMdodIwGTqPmyiuCwkREW4hSbid/uivL6kpjnOirEXXbSgQLAEPAKllEYAmGaAKSH9V3PGI6MHjgVDRJFX/xZLyxY6o08DbrLeemZZd6g1RWi9lyL14osmeJT4mxcCgGhmKb3we3Pt228wsNpqZ95n4p8HG5neWGezUl976HvVcOQXDXqC0NVqtpySN2eTljZ2P+/XFyAXbTYUBQoVKNVW8zAJkN/Ces7Qit05DpXcOSk7EJlAHTSrgMGLNNB19mECSGpolUUzC2BO+Vz/oXHVfaSUtqycpUF51dty9jxj5Cv9ESOAiX5TBVweMWXiKtFV3uogtMhrVQLpzKFZEU4yHkUl7e+Rj0W64XsrRlKXTZXv0XGJ7bbfpJAOOYQEjiTgd0LtY0FtFQM1G5ISn9Zhw==
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

Changes in v4:
- Move PAGE_REPORTING_ORDER_UNSPECIFIED's usage with
	page_reporting_order to patch #5.

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


