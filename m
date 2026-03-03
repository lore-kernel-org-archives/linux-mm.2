Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF9E1EC1433
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939F16B0146; Tue,  3 Mar 2026 06:30:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8076B0148; Tue,  3 Mar 2026 06:30:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E5766B0149; Tue,  3 Mar 2026 06:30:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0B26B0146
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:30:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18D491A012B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:48 +0000 (UTC)
X-FDA: 84504534576.14.798FD05
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 983F41C000E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=id+ozkJT;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=XSYbKi8h;
	spf=pass (imf20.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gb6qHftYG9h3/gCtPEjrgXaiMu36521aS4BQT1QUR/o=;
	b=cJaCxqXK9K/5iVx0T/ox+8/Ca7vaNBkz3meoSUT1rqBJ9g7ErFjaLVS3WT37b6HdRuBXg0
	Y9lmtQWHKleRMNd7BR2tShXQWdrMg4EBabCzOWh+Qn94SfxQL4ENIs4h6ZUI1xI2DMXm6m
	B+9w6NyWWK6u88r75Bl6j9aPjJ4LOxo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=id+ozkJT;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=XSYbKi8h;
	spf=pass (imf20.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537445; a=rsa-sha256;
	cv=none;
	b=uP9MpYFHrcLm9wpHgGcvIEooVeTPkL6tcdEVnbLGxIzV8y/O5dEFsGjwUmuDZF/BYOSBo3
	IeoUEMnTYHPIrkZJzDQjZ5BwWg2N+manC+Tv5J3/v8u+pjk+Kg05XmQ1Jgeh06IQnucRrP
	G4zwjGfFZHxJc/v6tACgcfhnk/tjYlY=
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239mnKa2733127
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 11:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=gb6qHftYG9h
	3/gCtPEjrgXaiMu36521aS4BQT1QUR/o=; b=id+ozkJTpWHaKiJG2P5abPU1gIt
	EhpdCcOmUibdXNwCJ0AtMxlgc7G5ySfRo293tPyEecOjmB8i2a4wSmcp0zduPcM1
	tr6H1BgQbeagyVmjyo5+RylXDUCWfNGKgqUpS8twb4RDp6WJ5JtD72h5JhZr2KAd
	NgbjmyCWTZqPE1ScEIullfIdfyBI8QbiZfY75aCjz0j2Sjl6Ohduyto0jWFfwJr9
	gLx1jt9TW3ae4voVVZ+izlnW3Qj392AtcJQ0E9yPKuFdYGKzGAryNStJ1RfxhOw6
	TTlpj28Z7IxQ25l3WMIYYBSlB9onRdEcA7dC0w+hcxvr60uIg+oKORdiMKg==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnswe13e0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:30:44 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d4beca8c53so61055352a34.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772537444; x=1773142244; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gb6qHftYG9h3/gCtPEjrgXaiMu36521aS4BQT1QUR/o=;
        b=XSYbKi8h0Ky4KervXxcGBvBdvPV3wqsLqOx5Nut/oF1V8dP0deVAjgPh4TAmaSPkbJ
         XlmfhvMfYHwyLHoRXMfKf1f5e68vrBy31Kh9EWnBhWS5ONDufP9L+amVZlpEsIO/SISh
         s1bKP21fJ+dIFj9EIU5TLsy+zGDsxWMaGiYhwVxPUBj04ALZ93jxcfzc3F3kpqlVb3vI
         5B8AD1qvg89YPpU0egtX/xHXsaWUTSFIZe43uY0ktNmwZc4otmM+4C0GvrCVMa+Qi452
         G5EhbSYabg1hACbGilP98kwcPPy6Xyg8C9ozhH5vZDbYIXaSjJepw2m+2a0ztBHVXa4f
         1wXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772537444; x=1773142244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gb6qHftYG9h3/gCtPEjrgXaiMu36521aS4BQT1QUR/o=;
        b=wZTE7wnSdVg/gY5ZGuZGNspP7fAWEVC+/3HcxB+H4LScLqEdRTvIUV0vAoRQunujok
         NaKVNDIjJ6vgFX37Ia+quToDP38xpBXukUIHt5JN+APc4AhgZ34EYaY2KpO8OuPVbjWi
         gk2Rj2imWhuCFFcHotL6qnbyC3ihTDB7FhbSPY1zMdpJXtZGzNufgIXjZiy2YphmyQKO
         hnY0LW6mT30i76a8TWSUnOSIzfsaWHvDRsk2nVoi2nfkXe0TU/iYRP8VC0HZwwUq5Hd3
         VsHqFVhdr/UHSlm7VRetmmqU5KPDB5QT7agTY3kBtzxoOCK8rg0joQUTG9UiaoGcqUwU
         ZC4w==
X-Forwarded-Encrypted: i=1; AJvYcCUsUUJsprmueMAGehgg4un0ojJUKKsKaVneHYcsJ9t6UjSDNfcNg/bhClt0Agd6siIyIfpZUv65Xw==@kvack.org
X-Gm-Message-State: AOJu0YxhxKNKPZBR7KeAaNQiPsNIqI6yxRtM7mhohvQqf4r90zYKCv7D
	qlXnIW22u4cUIzHn+o27I+Ga9QOPLfX+wpknbVs4WWbrGRLvEPc3ZRnuHOuczcQii4dQyqDpXNi
	p8VXbeD63Yv32pJXU67wjY0nfBrJlHs0kwx2d4fFUtCXIwEO7nUwy3A==
X-Gm-Gg: ATEYQzwuAXszN4CoZe67CsOr7d5G2LoF6xJjpS2LooXeb6QCIY7u36hXDn0fZepOYc/
	Hayf8EbjVUH7SIh15bymqA5oqlrKCKKZz2rhmgXOKqcU+EuwzDyWeS+Ql1QUWybhs59J5RYqz7y
	UDDIG1cTQu6idHMi7paK7mDlERci9r8yo1lba8Bo1MHLjYfQeCVJVoeAgoJ6lRkOa3AjElH+rrJ
	Hi9u9sKanRFUGtqW6npl4lCUZpE2ebxZ7GtyncayOHyDWgWG1xbc+sB1VqsHVV/gf2dc107AIot
	nO80iJMLKkd/inO33Lw+wkuocwTj/f5iijyKCYt4DoQKBVr1Ji3BezsWCI6BIcgh778aYCP1JtN
	bymnonCwVTDqubcn4EG57uSFL6tRO8vYsiFmP4iPmn2DGcC1pcAGDop9vY2LalUfrcbgqQNYEH+
	GQ2GWq
X-Received: by 2002:a05:6830:83a4:b0:7c5:3c7d:7e67 with SMTP id 46e09a7af769-7d591be6fe4mr6865293a34.29.1772537443647;
        Tue, 03 Mar 2026 03:30:43 -0800 (PST)
X-Received: by 2002:a05:6830:83a4:b0:7c5:3c7d:7e67 with SMTP id 46e09a7af769-7d591be6fe4mr6865268a34.29.1772537443240;
        Tue, 03 Mar 2026 03:30:43 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d59785d8d5sm9311790a34.17.2026.03.03.03.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 03:30:42 -0800 (PST)
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
Subject: [PATCH v4 5/5] mm/page_reporting: change page_reporting_order to PAGE_REPORTING_ORDER_UNSPECIFIED
Date: Tue,  3 Mar 2026 03:30:32 -0800
Message-Id: <20260303113032.3008371-6-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: QatmiRl2JQWgHzQ3kNyCr2JGadzs09e3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4OSBTYWx0ZWRfX1Vnt5Ii4Kzru
 uFNYkr1V4RSiO7Vxrl1vas08LXw9HlVbghZD5eDxb5XBpWmJ9ynnw1sv/CuAD2oTt6czBBj/oji
 JNzvgqSIgpfoijcxJ7Fazdh6ENxDvonPPN9bVkC2ngmt9oQ7ulf8ujIkPPylsruZqtsw+ZUMEMn
 Dk6fJDJ80OItOfAr5wesdgS5zExeXX2kMU4Oh9TLUdm0yya/8xQ75t3NRrqz2dtUn2352pvMG7a
 oqCEEndcER1TAgkggIyZDl3GR/Ra+KeRcisn08a3OswlAOV/KGu4Xzhz/uGOMDGy8LZd/HRieU3
 0b69+UqbUw5vHLhzmAgOe2xjo/PFjxW/TewqTP0JJx9mH7NbhqQupSYdpfdE/VPsO72kOZbzS7K
 bc48m+wL6Ccv8kopfUBKjiUdnY4zKL1X+r5ucbHGkKOrmvD4DenFCE6M0EOHQ/oSexfj2qZAbWs
 OWdd8vxwX1PHhvDtK9w==
X-Authority-Analysis: v=2.4 cv=TtHrRTXh c=1 sm=1 tr=0 ts=69a6c664 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=xOnWzZm5OySgNDGUUPUA:9 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-GUID: QatmiRl2JQWgHzQ3kNyCr2JGadzs09e3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030089
X-Stat-Signature: 9ctwfri3zzrsgd7yr7r71916hdaxmy9h
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 983F41C000E
X-HE-Tag: 1772537445-690169
X-HE-Meta: U2FsdGVkX1+QFYmNYEZHWD/OyKaMR06pZxH+/KSjG1O1kwzR8caMAuhfV6BdRNILsuN1EseggC8jyFBn6qa+G7BwvbApkQhWRqQ+GT1v6UchaIq4eav+8IP8+FirIWza1I0MHi+NbH6EKiL8Gw+HsrDdmIoJ591HWPe1SqDY58/fpbRYNWZyXvGr8iWYzbv4ACRuZqPGOzWOhIsVtPXXsNz720UdyXL5VGcQuss8Cw6ZB7rm6k/qbozHBt1IWApGKTyLYslXEnJ4nfT6PskoqBG+JJrPqceWH9xX7ANOAsNLstkh6cgzrIlSK1XRb78oFJiBd5hhFnhHr+ytoWGlguUxGqNHNAoLSiC5FSNkgwJBvk2+wLJCWWnvk3OFbU3/mPpYTZGo6QVG7mrrd4GDe0LyiQTPUifelTA1i0MXFUxM7r8/3RxOoVdwNsYrbsmazVPrRf3Y0L8CRQJ5xybZb+vR+DYc9d8pE5xKCnz2GZzXn+z3nLQ244L+/zH4uzNLsbglTV+zrneavd/FQiyzHAFuFI51nyAxkBJsmq3IieeMuFk0sJ46iEeWY+V4wZJ86xmhL/uCALlFlWPLVCm+Gp/1Ts15/UCwf4tb73zRirmNN2YLaz8gc/Aq3Gemnpdj0D2QNZsyT+IJSCTZzvS/N3JRitk22RmvAcTYVtf+AoiM116IcriiL9yDnYl/CPk1qR/4qn4qh47r9eHB8l+qQNjmiWcphQH/AUPdV+cqocso/3xu9cOktn+cqvWyQ9TcLIInn2UF1SFCX4s9iPtVymvsVmi8IExaBSefwy4Xiir8WUPteGWItKuLVQjvRDMPXjxLQNPpXRkl5ZYGUdhgHhj3RgHA8wB3n9wRs5pe5xxeAUg9CgOq7Y6cBSNJiatLjZTqjRAkhL3cEAnV5nmpYnNgcTwYb9q2H19dqCQC4wkev0C3pjlfIu9mZjRxuU1Eb55TR2UXNS3ioQ32Vue
 VcQ0AG8V
 bW6RT5+YasQY3kR789l9SJ37m/izOoKqTxmfO5K+dhrBYh/2ev9s77ox5/UarwOxpvcj+Dq1nHM1QL4vhQBd4Brq+uFXHXzj4hhZeHvIZ5RtP9yzgeBptUnqSOc9a9r3aq5irsaGMI7MthRjhmAiai/981yPRAdqG+AUuxXrTZ4y3cR07PfCdmRBL1Ay7InTyzCc63MXG+jEZ5kDM4BfldGvjanQwMOXt5eeIlbBb+2lj1NpwHsCAGxPGaXpDbg9H+KpdLTacJwILkR042qrlGvVdK0Wzz2T5SrKg2+t3MoTRr1Xoux3RRId2hame2afMfh0i2QCyb104yslq0jgSrA5/Ql/o/EfmmFRJNEInshNwJwM1kozE4R0OwVYJpF3lSN5NA6at6HNlsvXsZJdsmrMpBPjAzF5b4NCE3kUm/8nwn7QyEGOI7nnU8Od6/dHqZSefO+11QLewo65gEaPwK/P4g3FM9RfPie7drDDOhc06YqA8lh/x5SxOGhvByIEGmDGxrWfhR5QVYXj+HkcNSsIo+CJU4iZxEMUi6vO76Ni8rvau5TakU2G3iKyGPgVzYam3wYso3Ad1Arqzu1Lc6+bv45tI9r6AgxRt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_reporting_order when uninitialised, holds a magic number -1.

Since we now maintain PAGE_REPORTING_ORDER_UNSPECIFIED as -1, which
is also a flag, set page_reporting_order to this flag.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 mm/page_reporting.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index a97ee07cb..21c11b75e 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -12,7 +12,7 @@
 #include "internal.h"
 
 /* Initialize to an unsupported value */
-unsigned int page_reporting_order = -1;
+unsigned int page_reporting_order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 
 static int page_order_update_notify(const char *val, const struct kernel_param *kp)
 {
@@ -369,7 +369,7 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	 * pageblock_order.
 	 */
 
-	if (page_reporting_order == -1) {
+	if (page_reporting_order == PAGE_REPORTING_ORDER_UNSPECIFIED) {
 		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
 			prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
-- 
2.34.1


