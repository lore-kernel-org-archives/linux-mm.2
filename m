Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1975CFEFB55
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536536B0088; Fri, 27 Feb 2026 09:07:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3F96B0089; Fri, 27 Feb 2026 09:07:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8446B008A; Fri, 27 Feb 2026 09:07:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0646B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:07:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEF415A41B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:04 +0000 (UTC)
X-FDA: 84490413168.18.6560D3A
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7AF3318000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=kq1etGyh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=BAQtYH1h;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf16.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772201222; a=rsa-sha256;
	cv=none;
	b=H/F34tawZAbuMj6EePckjTV8pkzzUcgRzdW84Xorf9AUWr40aJSpzvUTtreQKoJ/XsSlQO
	n8rPzpaHYVeleuGnGqIszrNjOy6mYQcxty3hyJLoJBAW7K/suHx4Cn8L2XzWlpNxo+7Pty
	b7JuHhLOlLc9nhS2LsVcy3eZDxW1DNM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=kq1etGyh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=BAQtYH1h;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf16.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772201222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gQCIY6cePxSMxdE+svAoeyeItLv1W/bH9PdTKktztCg=;
	b=TAY2nF7DJUEHpRHr8ViAp8A5QljX/a96GPrheKyf1Ip10s1tS7iLGsyXXVabPbxIVSeGj6
	pC9rpoeqHDoXbX2OprX6xz8M2zck1ylx4zqS05SP4bzyeqFnKwiPKLvBSHCQ/dEPR/xrIA
	0PW6b1CYBO+XNVxr13ndB288gYyp6hw=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RB5d7u3485986
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=gQCIY6cePxSMxdE+svAoeyeItLv1W/bH9Pd
	TKktztCg=; b=kq1etGyhNt4m2E6u7HdG4M0LhfYmMYMjrKzNb/KwO0Gociue2Wi
	RJrAsblaFp6itjPUqm9dpIIFIKLwzPyMjVjaHsH/31s8gLCWQTgS3EPduYHxYTb2
	SSlsj+WdzQnjyM90Z9TDfzWm6ZSSmS9VlKn6K2U8vp6EqGDy+SrlXKU6MeItboHf
	6e47c6r+Lp3f9Cgvv9WNg0yEI2AIhIDCPWG6pR7VhrctHW1viqhHTtCUJI0ZCeLK
	go4IA6l5X7uYe1IhTPqlKKJqOXED5P+S4m8FZYF9bjBgJwa2yFgJ82/iUSdPt6D8
	J79wJiETN+6/etseKP0irCCgrfGScEFjECg==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cka2xggss-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:01 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d4c27c728eso29107943a34.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772201220; x=1772806020; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gQCIY6cePxSMxdE+svAoeyeItLv1W/bH9PdTKktztCg=;
        b=BAQtYH1hp3F4x/teOJmiXTyH5r1PpC5d4wxcxP9etmXZAO2uq+dkQQLm5cSYfjpqeu
         mvrzfrX1sDMv8pN0E/u/7k/H/UasC1qm5ak1cWSgp+lvmeaqrqnihandpVjL3WCUZEIu
         /7USKJS52JSmrMkP8LVzK+ZjjEKOOXT+WaHC9eeXGDvDS46adt2Y/DHQCPoaTOfaKlq8
         8v/zyTg2xgsiJTtz5ZDCBV19tp1vrylW7rOgQj/U5i77k2egQX5NI1s18a4M4J1ZyCzX
         e3B9dLacgUrJTRqX0wxpfE/Dpy722HAsDkZJgQsp7ZOYro/2MMy/qZ65O6PYqVqIimnH
         tHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772201220; x=1772806020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQCIY6cePxSMxdE+svAoeyeItLv1W/bH9PdTKktztCg=;
        b=i4IX9t7VqHsHD9eDefqgzLwoevporo2LxuW+ED2p6/HonacXPz7dY3dYl9bPPTB4ec
         44SBwVNFgkXQn61BEL6xWKOORS+logzMT1cZynwJ9ZGBEMHcC0bqoWQ1C9MPME+JfZ6b
         Q5oJ7EfLc+wSkf3jUYx/BhvPDd5+ZAjWawVUXu2G8A/gkfu+bYWMPXTFissoeTc9UXWr
         J6LnHHIujBP2z7fAiY6iYJ4yCx0ZUO+hZ/GdO8eePJwbCayYfxIh50WNJDhiKCDW8f7h
         /3kiKXMprj7jIaFP+tpxuI/RerstkKH0hktd3OvYommeMdf2upuAWjqtGjXQ41iLDyZ9
         Zdvw==
X-Forwarded-Encrypted: i=1; AJvYcCUD2zXte8I/HXj+D1i7cRFho917IEZMxT6gK4Gkp8+1Km6ZATNbSZqOTYWhFEctvy042Efv/BwPmQ==@kvack.org
X-Gm-Message-State: AOJu0YzCsxKuR6hp/2MP8/Jr6fFOJQglcRQ8B30qYlnw9uSnr331GHpH
	GH30bHT0NEokmFRk5jpAtRf3Jsodpl1ZN2/u/+LuTWVNmBEpxPPyorttdoo9dttJDXcF1QkH/eH
	4bF5t8XnTqqbUeQyl+d7hzSfIOXDQbr6OW1NxB8yiOpT3M81TAQOuZA==
X-Gm-Gg: ATEYQzz9ndhrUpMRzlqQvvLIwPJPXFeCpxgDyFx1itZoQAKc30rlp6GrLStfd/VjWij
	vESFPuhOoS6itst3SvuCBne700Ay22LdM4AIjnp+EUz74YvMYvIUJ2o8FEv4rzqHtNauk2nFpg4
	Ypsi9UyfGR68ElX4QWksYfMTWqIeLpKcpdyeqnVVXCm/5qFzLLZ9+Bc/f5sW2yguSF8Lei7BIU+
	HK3Oqplb4MDDwntQLpb9zyJHoQDkpKr1kBDEoBQJ0fTfg2GaLSnogTZJkTcQwr3iCZNpvngglAD
	l+fciC8M+m/KnzaH6kDgKgg2v+OewKo7MoS03m19VytYLNO2pTttQJa+hlnZZiMYfVpxeoPGPR7
	oVsu+d8bNJF9CLO7xQ085+u+otSbfAmrcWAjYnMaWwbPOPatFY38yV6wUvJnL3cQuHaQ4RNYDuQ
	+DMIGw
X-Received: by 2002:a05:6830:3146:b0:7cf:d7ab:bc5d with SMTP id 46e09a7af769-7d591ec617emr1870650a34.15.1772201220527;
        Fri, 27 Feb 2026 06:07:00 -0800 (PST)
X-Received: by 2002:a05:6830:3146:b0:7cf:d7ab:bc5d with SMTP id 46e09a7af769-7d591ec617emr1870621a34.15.1772201220051;
        Fri, 27 Feb 2026 06:07:00 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866269a8sm4324502a34.13.2026.02.27.06.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 06:06:57 -0800 (PST)
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
Subject: [PATCH v1 0/4] Allow order zero pages in page reporting
Date: Fri, 27 Feb 2026 06:06:51 -0800
Message-Id: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=BOC+bVQG c=1 sm=1 tr=0 ts=69a1a505 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=9ecvtSpfVrh-a2M179QA:9
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-GUID: wQ7pTSAsmtjR2lrzlAdZdrf_bp84fSkq
X-Proofpoint-ORIG-GUID: wQ7pTSAsmtjR2lrzlAdZdrf_bp84fSkq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDEyNSBTYWx0ZWRfX2+iNrIelDZFU
 lf/XbmtXKVMQv7q6kEO1tJ8sBJwGnZW3ybiS+dya5niBONhnkzIyP3sywoe+5Bz28eQ3uJyrc+A
 rBJZdZNCLvC9j2Sfb68vK6cROBUJMd6mem2QLjLsCOeEA+j7Y1WGUUll6a+sONOLAautIDK7Dl2
 wP0oQ65d4om4CUS2rcce24+n0mAhl+SpwSWaE/O2xVjax4orl3toUmeZPkkH7nMiyj0bFniFQ0g
 AgYSpl808yG6cZqZrmpH8fct/dBxfaO7tl8NZBkab2iuDGrbgYXImjajJSW2JhOAI/jstacVkCn
 mJyvKgYTTDA00WfXojXfWkQKdPMmfsuQSATNxfaMfGQev/EnlrkkNL3/NbACU9Il6VEBL905kuB
 xCSBuz1veXcuC4FcNpKAAY/3Z35EmFTMxW8dPtX4CzVTSjJNRLUU2hMWsVcgCqIZAkJq2+Q0LSS
 fAvIvC7rqU0Y1dt4Uhw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270125
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7AF3318000D
X-Stat-Signature: jf9h9fnpi4rirpcd4ad4f75q4rx4ksex
X-HE-Tag: 1772201222-835262
X-HE-Meta: U2FsdGVkX19+p//jY5Wc2XxDS+mNWOm5ff3FRK0Oq+z9ZA3uvhO31MVTx4ynYONVcMYSw6jXFB5fjGtwnDBOvUOxieYb/Pt7OY7kw8aNi8BovGyJlgfnZWgJeK2i2WXztmE3JC/5JCYafP86rsceEfnhh20ftYP8dvCrh9O8kaPjfIIeuqDPE4e7tNrKCjcMePbBRasGK+1EvvDda/WTwRmi4U1qKqUqJrf6q5NqtxT+laxY/W0ZNXu2TI9Ixg2pXMTyFxumyO4Slsa2IDt6fD8Em8xFT5czlddidZ1XRWWH/iIw5V+CHen/Noq0Lo/V2Oi1e62PDkDcA4V31PYQJWRJg95H7qwrfVhLYX6MME7ricSGY2bLZ4KtMuXGC849TEU+lHhE7szJyoOrumo1Pi0J/2rgB2wIh8z1LD8Y/Txyesneg4GTjmRNpbxE+nEjW8GOSVpBYzVX5TWBKvHTzgZci1p7H0JRcwLKBEFVcB7QWpWXvJ1Wl9R+m13RaRrdY6nu3FdCae3dVw3dGLPXp787SIA73NdLVpu8PX6TZpbyJ2lSnhFdOaIniEgsEaFcZDALaz4D6vFHMHMqja5x//WsIlFEGHKCbYdXHX9VdZtWxO9PPPWReHLKfasq8i0M7y9PaL2bbrXWWve6VP6tTXg3/00k50xvxVpvd8Ck4HCgGGCihwTCmC3MvQEzjDTawbpZe3ISfEQzf6Ab/lC3Ujxsjm5ltCbL8o8UvDJ0hxWaC/Vt7yLmSGXYQuGIvLvN155M0RYqq7dMyK9FfKPeLTAyQZtuVN8jAWMTXmyF5YFMLNRDnm7meuegO9qlTLavC1E39RTFEElDi9BAtva43u0j5cLqIXcTS+wxozylvFnrFHWbf81CLle/qM8SqsB70Lh/a46QjwhUdgBtFrtbjKryOZetZOWUBghn/mf5Ec0JESCA2MSVNGNC2c3BHH4BNtLu8Z8hs10zrdsty3r
 uMN5jYWP
 b9zMX3ST2oAmIkRScdhCz3r+JZZ3wB7dlagIH/eeVV6E3DKgaP8oJ1WYbJavlZjFlXOJn/DAiEoZ9ds6bbt6VSK4zcYJGy1XipbdRVupCsCTFBitoQh4QkjtZePH+Oz9ccE9nYmCirICYQqxt4fHsmtSsR6YNPkFPpQDugPKQbKrtgQ9Q+1LGh9wThpeUA1XLOf8uhbXJf3aABjONT6lUAPd6n1m7LpFbbedsUNwI7R9SrndYvGQIEb1PrOstqOPxAL4EcOHK63/rAOenkhjyL6+p15CmxobcB6Ro7X2JxG4dguML7XSH2Yl+8dXSfvSlfIjIAJUAArfLJsnlR5dm/u1N9YT/uXe9NiJx/bA3ZMS+Cn+j3UdNJvka4rDa67ZSEGberX/zhDJfLfh1zFbpLwpKMQdEVgM1ecPUdqk4wpIZbZuyZeqT860aaAj7P1CgDluxCOH9jJBDSJwLKJZwQkBBs9C227lFVkp7tQxZoKi2LN6gcd16QbgRvA==
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

Yuvraj Sakshith (3):
  mm/page_reporting: Allow zero page_reporting_order
  hv_balloon: Change default page reporting order
  virtio_balloon: Set pr_dev.order to new default

 drivers/hv/hv_balloon.c         |  2 +-
 drivers/virtio/virtio_balloon.c | 14 ++++++++++++++
 mm/page_reporting.c             |  2 +-
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.34.1


