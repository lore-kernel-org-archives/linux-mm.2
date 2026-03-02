Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D110AE9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F69F6B0089; Mon,  2 Mar 2026 06:18:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4C06B008A; Mon,  2 Mar 2026 06:18:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BFE6B008C; Mon,  2 Mar 2026 06:18:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA7D26B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:18:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3A4C1D24B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:04 +0000 (UTC)
X-FDA: 84500873688.07.623B548
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 473BC80008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=MHRcXxNn;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=PuOyPwdn;
	spf=pass (imf30.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772450282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/iFgusvo1aPKir8ugITOqUipqQuZUj6mnHU5x4L5Mi4=;
	b=B0K/W2KjJc3NjdCBVjZASWO+BBG7FXhMiMHKR/MjIL5KVbM7Aq7IHlNnCt5KmMOqUSgM6j
	9f/Pac1kTy2EZ2RttwxP++0PCYu1yHqCgf1BMUqnGw7zvRbItdHk2F/RiX6aOPVmm1+oFk
	7dEQ+kZ9R/85oVWzZojR14Fb9KvfgfA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=MHRcXxNn;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=PuOyPwdn;
	spf=pass (imf30.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772450282; a=rsa-sha256;
	cv=none;
	b=WD/jfoJWMEs6iByFvqq+fU+8xHvcvJaXa+4LyP5q6Ek/aIi8E4C+P4WvS1MuUS4xLnttcR
	GAlgt0MH99G5jVcxtIuOmAYyoJ0anYUHmc/2SVA1zt2SSHLnGhLB/vxdJpQl6nQLf/Q4A2
	2+Ul5i3krNUxix/MEdDg0pm5DylDQF0=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62285Xeo662205
	for <linux-mm@kvack.org>; Mon, 2 Mar 2026 11:18:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=/iFgusvo1aPKir8ugITOqUipqQuZUj6mnHU
	5x4L5Mi4=; b=MHRcXxNnbz5GIKwWQYVoaNUziQJIm1paESYHmUwIp8XM8ZrTtZQ
	kcWU5RPnyN+J/lK8HEO4xggNDAX87YEtX+uyGAs+gzkW4c0y660oCog5baGTwhwL
	/+nBuWpu2Sxgv1D99xyf0mQgaJiwF3slKBh2Qu9t/GvSWSUmHrout4pmtuUKjsjt
	/CKjluajet6WGWMAaPMLcnWZrcuEpKzXCek0kna0xqpSKnm5wH16juvw7rMIehIR
	0KJ8oYt3tpIdqqB5yF3QVZNFVTrl2fS3fLFogoOoZz7dDz5baYaTEL8LIN2WvABr
	s0TfoEpl7QRHAEkWKwHTe+IMzQkw/PX/z4Q==
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn6r2rrm6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:18:00 +0000 (GMT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4648a1c3520so20928819b6e.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772450280; x=1773055080; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/iFgusvo1aPKir8ugITOqUipqQuZUj6mnHU5x4L5Mi4=;
        b=PuOyPwdnBKVZDMKutO5lRcA1AFYTzg8w13sm0PuVmbLe2MzaPMtbkrSzNLsmrgRkqp
         s4gyb7qfcCCmWxtOF4fIlXpviFToNS2mVMWu3jiKdDdeu2TFY9fZLFWkbxE84BhalElO
         v+5vggtJHQBuDjpz4SDMD8UxHNh73XnHOEYlR5i8efTEsoE7Tf+SjwCuC385HNpFpKmD
         WcFjq9NmqtJo6eta1mVicfCM5xSfH49P65XtaPRYhq3DFLbJANzciHCa7Nxvk8tZNP+r
         IhJWiIyF2qOHfEIJXadtGsLjMjWF7BWhBb7dwGrV4pwkMq163FgQ/dzUHMCII2REDezP
         +f8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450280; x=1773055080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iFgusvo1aPKir8ugITOqUipqQuZUj6mnHU5x4L5Mi4=;
        b=vWmYtVec/KfC+BYTHv6MarR7Cc5pL+CQEienBUv+DRp778J//4EAKabZsLddfAMb3K
         3DQaPCZ98RuM3JkTus9J0xbLNWHJs2KjXJgd+SikydOeHKiFU7XS1q7JFwaiqHM0yQ0l
         YHdaqNTZCYghQQl+DAx+8gVKPQttfsZ+5iDFx5JZ1jfmpwHfd0tsiac4pUKRJMGqBqB2
         uRIaX3wArolfAZU24uwbgWOCIIPnCxs2B2j8zw/ik63n8Mu3x+BF1Aoi/Y/VhVMm38Go
         xDArmVQ1wfRbN8scSnz7FQZ0rr2+JMJf8XIKzZSxrTdtIxX7yoPm7AQVk7tO8UDyUnit
         ouww==
X-Gm-Message-State: AOJu0YwSsqXjh98mQ20r0aaFGxll0SpI85qDyeHG9izBNpC+uVhtZMJe
	Lvi0v4xmLljXPfERiDvELnZ4rPOWWuh1ZFlICXeDC0PTcKHUDM9mSKZ5WkhY7bNxAFthu4Q4JAp
	WwGxtE8Jbw2i9R/9cunpE+0r4Ax83Tb9SH7xqvGmo7HMnSF83REkbkg==
X-Gm-Gg: ATEYQzw0S6x6vG5qywpzsUbnBEDjW/qgBMvnm0E1iK9NHriTxnQn5o38LmRpNV3+AxX
	puBiBLOBqe4727ytCTt+/LX+e30tT9xMmFSiy+JEP8TUnJNU5EgimFqEMhib+DddQetipF2XzJr
	bGQF75rt0hEzC4ezNFDfzEPrJIoiyBonn6C1aNPzy8benwZCW2tJDewV80dB0IruOTj3YcVZpZY
	UCMz0cqJitxyquECfruB4px+nCVNM0leFllS6kajbFM3uvR1ZsRC15QCe58tYyJMnu/NlElkjkZ
	1AUme9o8vpFKbNItfMpN+VZ2u+qf8et3Uy5Sv5qNIL4sCdDyYJdSPD3Sih9XyNLjjucm8q9UcYj
	W7bpyv+O3w5oG8hh00UrG0BWheV9ghKz+466HC9UUtYKrdxUSQAPMsugp/N9LitYLccfRr1qUbP
	RZa8sl
X-Received: by 2002:a05:6808:6c2:b0:462:d097:2467 with SMTP id 5614622812f47-464be972a89mr4750532b6e.7.1772450279939;
        Mon, 02 Mar 2026 03:17:59 -0800 (PST)
X-Received: by 2002:a05:6808:6c2:b0:462:d097:2467 with SMTP id 5614622812f47-464be972a89mr4750514b6e.7.1772450279537;
        Mon, 02 Mar 2026 03:17:59 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59b66fsm7354528b6e.10.2026.03.02.03.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:17:59 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org, mst@redhat.com, david@kernel.org,
        jasowang@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
Subject: [PATCH v2 0/4] Allow order zero pages in page reporting
Date: Mon,  2 Mar 2026 03:17:53 -0800
Message-Id: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: lU_4SQXnx0T66Tdx0YZrJmDAea_GLeJB
X-Proofpoint-ORIG-GUID: lU_4SQXnx0T66Tdx0YZrJmDAea_GLeJB
X-Authority-Analysis: v=2.4 cv=Hpp72kTS c=1 sm=1 tr=0 ts=69a571e8 cx=c_pps
 a=WJcna6AvsNCxL/DJwPP1KA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=9ecvtSpfVrh-a2M179QA:9
 a=_Y9Zt4tPzoBS9L09Snn2:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5MyBTYWx0ZWRfX2WMPwxPDhUle
 BH2K2M/JbEyIGfptGuYBgV8cdzb977ve7UIHaFuf+BSE7fENGyfs4zYi7PyEvnkGTt2T4wxTpRp
 iwfutneCBFzwMaGL6BOqUCqJdXMhjHi+JTTzxZ7OSvXymncUiVFJNsiOVbUxdpdrFyOaxQYi0H/
 rsUKatMZRNNuxplAuP1wvTQ2jwh0v/eUJ781Ea28gRZavvYW76vOD0UKF29B16RYWCGxpuXqL28
 88iDh5x7WnYWEZVTb5Uan87zttbFLQGnowBh6UurMY2TEiwqhyb9M3npWFG6BdwiEYsQRqaYfAU
 LjMwlag0BXUdw27DT5dIN4ULEIYo/c521Nn28gQg+t9qgwHjHPaxa4iCqUqHJcn8Lo9inUNgMgI
 C/p5NuG5PF4OB+vypTYFMr2YX5lcTdoI6fxA2RNpj4RIGpzizmYuxy4IhrWJC/46YIlIhrm5SuE
 tYRl8OKC2kWukvRxRGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603020093
X-Rspam-User: 
X-Rspamd-Queue-Id: 473BC80008
X-Rspamd-Server: rspam08
X-Stat-Signature: x8pq5yk3wnwuoxnxjdfwp9amruspzofb
X-HE-Tag: 1772450282-714657
X-HE-Meta: U2FsdGVkX19lXZo5v436UITQbctsM+mV8tEKm87uK8qooEq9uchbNdrsgnqBbQ4fywmJahOThTnyf+y+6tvulv3uji5Q19nSuoNxguKPRZpklXAU1sWnRdRJ8rVWJ27n7UkpfKhSflV8vJUk2ATF1KxjeDSgIiKP59ARE92/V1AHyhgsv0eB7N3dc+kjFXVI/56QPMtjpBatji+4/I3X9UOuEhmo07Pmrr7rcfBeOtnwBMQuVbfv8LowA06eEocGbrOMXC+oExyyBfXspMz1ThFVpAnXhfJXq3dnoO6gMEiR+9a7YN7cmSmdJFFBEUcTcumMzJ/dpsPWo8WUR3/+31SdbdxoHQVj0xOvflmaIUotl+xoix+L22sze+d3rBZAKny8ciTRtkP+lBHABbQKMZNtAAShEC04CGqy8l6RKgVLqE0C8pu/86zfl7pE/Kt+2Ag5ptUVsI7yktJzS+NGvt0NihHxzBaUrYTjSuooQR5QtDPORkqfO7zhOznsA29avS1xNEmRY8s2XQUw9BO86qs+oAkkmFLD5x1mxaGqM4ANzf4y/d3VdIBIQTyjmfZ0SpCYbZq4EqhS52+2o/VA/qOF6Y0xbE7p+ow30I5NvaIU7Y4dB09ytHj0yGMI0Ebb3Y0IS5cgZKZ7uHjITxXKR5WnHwQ2MTJwm1TWXPaqktfkF/pW0E6YOttILdbfblM2y3T0K7UvLM9KXa8UKMlXTamsxMoyfB3Zc/CRPCKpYHIS3DCjqQUx/yf0ajDYrtO03/2jys2H1ac1gEirlWPzNbXrtR/7eLDDHHggTS7ob/hWU9k0/17PMpDb9G/KZzXUbd8Evr/NIfVpaF6fReKa8k4WpeQNd5x6KD4Qyd2K/uaZcv7/+0EFOUEv5ir0+biXWroV95uiDJRO/J0TPADecMg33YgSbzNIpClgzebeHDfFE85hJ3WFWCI4vZKdncMH1kSeFf9FQTSOwZjjgvT
 uiDGzYSY
 nU31I+FNlYzevKJYkYoIKt/D0yz+uv0aUvVSendDHD2vCfUYFNRT7vYnWv97ZJOFtIV+hN+aiPVB0vsp1QpdPNkZAn5t8UDMtjFu9da62E2pvYBkK6xlHi6qb038UnmJK39x6EX2WLXJRZH5HVDTL0CjC4GTb09MW/CdAUPWks3fNcqarNNiQcEi1wKMt2C7WspR7ZuH3cKFh9cYv2iWs0KV6qcof90GM2yKHCUYslClTCVJz/X4rj9w0B6u2z/i9/Om9oHZsSgmmy1Z7mzpUw50Hk71w2Lk/R3dxDmvicnmdvxyj46YNM81IRGCI/sGIPy5KXUYwwwwipFpIteJRvVA6ZGslC73venYwlT3tPhHezlUcBsRmv271At1avzne50bnxgAN0BbCtSxzBYqjbbz9W3hBwU70iWloUmGoKwXznj2211iJ8pCSA+a96fcQuuNQm92d0OA+JdSFNWjVa3K8nNZU+WcYYJoJdizpvG3FNS9FCwbtSpuj3w==
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

Yuvraj Sakshith (4):
  mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
  virtio_balloon: set unspecified page reporting order
  hv_balloon: set unspecified page reporting order
  mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1

 drivers/hv/hv_balloon.c         | 2 +-
 drivers/virtio/virtio_balloon.c | 2 ++
 include/linux/page_reporting.h  | 1 +
 mm/page_reporting.c             | 7 ++++---
 4 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.34.1


