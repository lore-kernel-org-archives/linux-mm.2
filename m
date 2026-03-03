Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 744FFEC047F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD6C6B00A3; Tue,  3 Mar 2026 04:33:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A0D6B00A4; Tue,  3 Mar 2026 04:33:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87136B00A5; Tue,  3 Mar 2026 04:33:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7E8E6B00A3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:33:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EB931B73AD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:56 +0000 (UTC)
X-FDA: 84504240072.22.1F697FC
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA76E40007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="b0/7P4l0";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=THFYwAkT;
	spf=pass (imf11.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfGWmgs2oNUvnsLBvbEHmpATWwPVNjbdSo0LsFWVo1U=;
	b=kKrdqhUSTVE3R05SS4XVN6nzbwcQizICsrY2YzoqoAhmcsTPCjGdXxynLyTpX8xWh6YBqB
	iq2jGNRUTX/7usPUNofnyVu6RLVUn6P964tvJISNWShZCtr6aROhwZDqIiZCAFc5+KXzBN
	6bkXjIcnr7curDsBb1f/bvzTQto+GVg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="b0/7P4l0";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=THFYwAkT;
	spf=pass (imf11.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772530434; a=rsa-sha256;
	cv=none;
	b=EM4lWFKxOIWiw0PFEmP+54mSreDKjoG3UsXYhnALyRRc+Z4bXQKGlBXOcyLSOApsCgfWYJ
	HfdmMu3IsQ+SdVOFMQn1I0MaAUnaN9AM9djiCDf+TM7ExgzHkT3JS/esW6WsX3zf+Oy0Dt
	WG6WLNn8A/bJweqi7TCrRqohtfmpf0s=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623539CD3362548
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 09:33:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=LfGWmgs2oNU
	vnsLBvbEHmpATWwPVNjbdSo0LsFWVo1U=; b=b0/7P4l0FVPZuXBYQuwzeCwqNUZ
	Ep31sNDYK9bgVIfC3Du4RO5X9MSRV+kJCx9SnMnFAzJkYIMyX0Wc9IB6bnHZ6kX8
	5NUG4RhdTcHs+XKFBG4Mg2w7Aofip4E7t30mb7lMFPWIk02WiyARFKPqDwOqfX+w
	6GtipcZg6sF4mE+LPnrcRBT4vjlj75XhjRv07Pmv0nYWqrhvGcIuclYO+5jwAZdT
	TV3llc/AGVS1NgpLvPmwWM4AZx+a6wyCRScDhghd/8EtoT3wa9lP5P93j7IIsKZU
	PPdccLoJhOyhJi7ZdiCwVPGgWPGYHEWDGWk6aG2UwYoKC/s8UYSXJWcPiGw==
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cns5frwdw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 09:33:52 +0000 (GMT)
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-672c40f3873so103222818eaf.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 01:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772530432; x=1773135232; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LfGWmgs2oNUvnsLBvbEHmpATWwPVNjbdSo0LsFWVo1U=;
        b=THFYwAkTFlKcfGW392VVu1pROR+cWqd44BvuRThP4EzW5ZU2hS1X8MawUxQNd0xTE7
         00MGNMlahjY3n/F72M8IYs0Opjd/leCWd/NrAQn3xYwrFgvbrlMW6gSRlAm8ZJc67MQV
         vrZU1tGohx9fJzsAqzlDno8RxHHLeOpi/b+r90A1atKAGI4fM8/nyqOYUiOc4TvSuUsN
         /lH1YwJ2wLzvYIY6G4BNuZ6sjcmzIXDI2Q69aI9/riGDKFnzqTuXdHi745YGcg8Xua23
         /WSFLHQgKzZSzrfM09ShEe4XgLEMcv8R8LfetjMIFEBnUMzdaaaCHhKHnDvQFMl5oGCP
         vLOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772530432; x=1773135232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LfGWmgs2oNUvnsLBvbEHmpATWwPVNjbdSo0LsFWVo1U=;
        b=JXwuGZHWRsegGZxOVg+/T1OCIa+L/Hrw7cuwWNVNVXsWIKr6wXN6X5TKBnqN9QZHKW
         1JZRYvPZP6w0ULi58YSB3wdKO/ibBFPqRrcJtnQAYEGntUs/o+CXfKnfRgq84xOOKcvM
         8ynAwM8H5dO/1qHe0VODk9wEG4ahN+l8Xob0BbFhTkBFeRXAlwdOu+wdhWyuYi9d6455
         NbIDkJXVEs8CbT0hTGC8PUPZXrpoVs0x3SvIWrI6rCbexR86I2b6Z9zsiGueLIwdjplA
         eWdxNslk3zy/K9TzqIWy7PvtjSPQ7oFyeE843lEK1lDTqGnXrXNflweU/qRZ9in5vqNl
         oKjA==
X-Forwarded-Encrypted: i=1; AJvYcCXMb/2gTSBYg2yxABCRf6JU4fBH00Oo+dDhSrI5UhnyW9EDlmICc2LgIVKUcRuME+mygZVBnPzqCQ==@kvack.org
X-Gm-Message-State: AOJu0YyAT/hZPIc9wlIshuz7iXmM2hVHXvUZzLmzlN4qE9DoiZ2b41xV
	+huKsVxRdTRbTiJobx+gwBYsGimOs1IK0L25iB45x6WvOsNurO0R3Gju9nt/5nm8NUtsELXyRyh
	r7Bo8fl2k7geHdAk264w0TovrzwMtOM1b+rZgGEfPnxCzaEB1Cj2XCQ==
X-Gm-Gg: ATEYQzwW+Iee74SWnwrPhJpCE6852Pn24XxZBYdNkbWbtBuaI1zLkc+Cjya+g20IiUB
	3fV8z3NekDetEWdAIaZd04CTn83r8pz4nhSw1eK6wjE8kybPCPgpVp8oxEez7CCE9y5MaPx6cSK
	7yMJuIjMEOSCUEzvd9Qi7Y6HQOwZuySHnemmTkQBKzKzcgNi4FAv72SaaT07ciK/SrIgjN/OeU+
	nJozUmWLJ3sA+iWYe10PhBxbjvIWLJfKHJtvlrgyvBrYHJTFLRlrbYnYHW5HJsdNKSAK6/yBRuh
	c/m2EfCAID0G+xVOPPwekN4Mzm9rN9LIoo81ZjetxdHMhA2v7fOogt6t3PTslg1kCTalyFlR5O2
	jlZm1ivak1rgSNs6JmYeCh/fqI8+IqULZYar3ff7Xavm9kay0HTS0GpzGogXKNCXnTheUubzoKr
	dHLzTK
X-Received: by 2002:a05:6820:4b91:b0:672:f683:7c54 with SMTP id 006d021491bc7-679faf9a246mr9755943eaf.69.1772530431835;
        Tue, 03 Mar 2026 01:33:51 -0800 (PST)
X-Received: by 2002:a05:6820:4b91:b0:672:f683:7c54 with SMTP id 006d021491bc7-679faf9a246mr9755930eaf.69.1772530431435;
        Tue, 03 Mar 2026 01:33:51 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67a1d603f31sm938666eaf.5.2026.03.03.01.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 01:33:50 -0800 (PST)
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
Subject: [PATCH v3 4/5] mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1
Date: Tue,  3 Mar 2026 01:33:40 -0800
Message-Id: <20260303093341.2927482-5-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Pv2ergM3 c=1 sm=1 tr=0 ts=69a6ab00 cx=c_pps
 a=V4L7fE8DliODT/OoDI2WOg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=6q7Fjfde3VlTRWJJNBIA:9 a=WZGXeFmKUf7gPmL3hEjn:22
X-Proofpoint-ORIG-GUID: sBQ9aqRvWvPo06rzkdmP1S2Q9_U0tAf5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3MSBTYWx0ZWRfX8cCHKmbcPZQZ
 pquQ37Qn8ZzS+cCdRKZ5EUPUCJwaL0PW74YOKfQpWe6gFw4Fh/FV0pLG+hy7OEkw0KHvMrqHhRe
 laWv68UCSg+tLLeVaknJuXGaXon4VY9n7gnu+50zKJtA5e8m7yODk8jK1FA1Iw1s1Iq60QnCl3A
 p4pp60FGhQNpEtLPLSW894Ji8TUJCBTp760SpfwSmlRQ6sIODvxhD5Kb57kRjuh5XI1E9Zu88iS
 V8QUUaRgJV0avP/iBeURKY3wAlRP/c80lbxAoONw2TqnLvd+UubuRR1/BQgYsQ/UrdoXlO1RYRP
 xXbS7idkEKQtWqW6YlouktWitnIxkLd2Nd+fLjQa0Y4mDBefiYvFsSmlG9d+Xk5ERB2F5MGOEfQ
 nNp0LHmn2l8nPW08I7YSkl7j4501IXNA1z86RcjYHI1PStZLVGjTef+aDlwDS5am7pcclHd2nPB
 FmhJxc35A0SqfjlOiXQ==
X-Proofpoint-GUID: sBQ9aqRvWvPo06rzkdmP1S2Q9_U0tAf5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030071
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EA76E40007
X-Stat-Signature: dsjpgjw5f6wsrywjtc5omxfopycy45kk
X-Rspam-User: 
X-HE-Tag: 1772530433-100699
X-HE-Meta: U2FsdGVkX1/XjtmveX0pv7bwbJ2IHHWoFcY1COWCi8pqvgrFRldQ18dz3fPQCQ5qMUPGUHM3Js4xXmdCRM92OA1bnPDYeI3OFFX/9QfPPewxMJE8Bjr+xYQSRwlUuT7eo7APeMUrD8e4BIkBmCbW0iam1+ndQnqMgb28eZ+vtY/i+ZNcJpymd6eRTtHBMKwFgxgYhmABNS6p9mZYJycPHE+0MaCe+p8ZLZ4qmcQZHdok4MtZAatwpyXcq8G6kUHevy12ZvKocfOFVTLIsI8iIbfk9JOQ1dfvVLHp5IABr3AyM5XMM71fgKmqDX4Ix/KLD/N9bZZqZNDQ8tY4yg0jldvdYcv6ZjK5IHU8FlJeRgjXtmahVfZ71b71B3RJzkFoaXMQwRIDN7NHbY9TFtZHxSxkRrUqejDM1ZhX2KsDynToBAwoXCRuwN+5RPHG/+makZvUX96rcPU1XpNT4E0uYOFY+0nqMxE70s0J/gGaDpI9HzhUm9h96tDl1wD47dnJIWx0VV0iZ2uh8mUVwWzveUB3sl5/s2sNNmEmkj35njuNJ34ojf1v59yt2vOMpgxiT3OIk1oVP5HVzhn0SavDsBF15NFOtOtBJW7RHx7Qmk0MsYTK3mWR+XPn42qELB3NuugpcUbbZahVuIKKXVdByPoa6BNHNasWFFzCGsikPFBFqqdNcGQoFinBTJ+ALXkHmARZZSpKT4iwo18Fqpj60So894Wf9NeNwpYJOhWZrUgYXek4vaO0ZDmX2MEWdK5207I9qTbFo5cxJGDAgww7t2LlSwv6uJp4y+ZlJRJKcYNPAPZNQtHZLGY5wMTiv8WDBT5+D+gPzsT4SFoZaNozKsfbjAPONmiOMqCiekhuwhyj1yFOhVhfWPBcY2dVI2pP0rxH24e0njSMjoKDvml0lh5aEe39mGxB+6mz4dBUm+EIRG3qBS+u3lErHVEHUJW/Th3f4O5It2MkseZAO6r
 FihoFW/V
 CmoZ/CRSzaxvTfCztNOzVnNXc3jqCV7pUhFTJi8gDztMI680h072fJn1jNZ4+9147QybJK/gay1JZT0QTk9JMET7J9IVUhMKafIsu4o32okE2T1wZDOFbYErJEnikmEsEJNje19K+1YnIhs1XYLZO2a8h6ZW+R9iXx4Urg5aXeH7ZCZCBNOGf8DXzfRxaL8D3QPJg4yLBSFqDJIO9D9e6hpOXEayFcfNsfYe9uQOtZqCnSr3OEwnjH8/Mflp6m/UtHStlB7NrBHOYAHWenQa2878zH6fSKwFgm6oFOPRK5pCrUwkxGBWdjHE+OX28D+2Fvi/cHoOF0cJgfKwU4KIIVcVg2MM9ZqkmBUY7dDidrkBPncHZS6vvHvL8NW4orejg5xmHLLI8nghKJbH7z88o4xKqXa/mulBbAHRNZSvg1PcKf8yU2plI/oJOWZLCPNMyccKTsDIdFrPyVutrPNpkXDxKvdkfNUqrUJNLkaA96FzsdC8aEwRa85IdUcJSzP2jp4OSRxWTD5JPo/tE8MxpLNB16IDxdJK0ykDhqO+9ZKJiIh7YZBX3Se1xQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PAGE_REPORTING_ORDER_UNSPECIFIED is now set to zero. This means,
pages of order zero cannot be reported to a client/driver -- as zero
is used to signal a fallback to MAX_PAGE_ORDER.

Change PAGE_REPORTING_ORDER_UNSPECIFIED to (-1),
so that zero can be used as a valid order with which pages can
be reported.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 include/linux/page_reporting.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index d1886c657..9d4ca5c21 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -7,7 +7,7 @@
 
 /* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
-#define PAGE_REPORTING_ORDER_UNSPECIFIED	0
+#define PAGE_REPORTING_ORDER_UNSPECIFIED	-1
 
 struct page_reporting_dev_info {
 	/* function that alters pages to make them "reported" */
-- 
2.34.1


