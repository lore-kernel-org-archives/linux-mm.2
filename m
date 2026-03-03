Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84942EC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAAB6B0145; Tue,  3 Mar 2026 06:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B706B0146; Tue,  3 Mar 2026 06:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301B86B0147; Tue,  3 Mar 2026 06:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 19BAC6B0145
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:30:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D889113815C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:45 +0000 (UTC)
X-FDA: 84504534450.13.6BAD473
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 820B620003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=QIFxFnmb;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=BO4B9uid;
	spf=pass (imf13.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zrUsPz7mski9Qb/OvkgQW1KGt3Ejhzi6jRFHoRkisBI=;
	b=hPiWaJNnOIKcYD7UL5QeKRPcPc4g8erFtQAvmnT4jdIktpTtONZF59uL62+LppozuRB4j6
	A2wH7WacIFqf2wyUaYevn9aUBG9m7yBLH1ojHLEsNY1ZoJt8+Pv/1jr9+BagbXVKtpeOj1
	C7urD4aKITTG5JxQX4dFB/yvXr5Nu4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537443; a=rsa-sha256;
	cv=none;
	b=3SrZYEbPhFeZgfsp4UznQXBL2CqjslWout2txYJ3rZXzE/KBnQWnL+avnC9/EYYUo6RFdJ
	9Hx4CPxLZCokRP8BgeMqPiRYd+n62DnBNWfUX+dEchUDBfkqDq3bqxQxPCx5/9iwcHaZYq
	KXBPWNcyn/2k9Dp1m+mjiCkdG/IPRog=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=QIFxFnmb;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=BO4B9uid;
	spf=pass (imf13.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239moLL2614205
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 11:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=zrUsPz7mski
	9Qb/OvkgQW1KGt3Ejhzi6jRFHoRkisBI=; b=QIFxFnmbXG6Yb7INz7t4sLwL7mN
	ZVGVg3uC6kBrgYgBPgIyevgE640WHF2F2g6Ee/N8dUy1fhW5T7ENVQf2IzX52DXq
	wGwk+eOQ7HYbv7bK1rTo1NLv3Ob6QwRIJLQ3qZN4qJRQEYNyFvGWtC7ofbJUlk7r
	SFhuOAIAR3sJ8WPaQwrSowQGpmt3NVKshjAAE3SSBORhXHAwZpR3usEvQUkxTt1x
	oCy0DYmoL+NSt4qjUvBMdb9JKiemCouKNA5vW06xuO09/mVHokr6zmrIRsapb0Ur
	PRXp09N3P1i6jXoo1PCoW3eZNeXIobnFjPjeZbDqgzSFMNrU62HoZL+3qaA==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnvxf8dk9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:30:42 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-46454b2fd81so57005837b6e.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772537442; x=1773142242; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrUsPz7mski9Qb/OvkgQW1KGt3Ejhzi6jRFHoRkisBI=;
        b=BO4B9uidZnnmYiIZesDtUpM8d/rB9sp4M2bBhNJXdnYak2+X85U7r+vR5OuSEKZIRx
         4DU8d69nukt/S2cQdgRDin7qMzMN+gHJ+UxXbVhGSq+oBglq2HCsL7+Cd6TrCJmtrxXI
         PR1INf8xLoPMt3lYZqWvI/SAUrNHfsyGJ5tIf665kfnNQU1ZAqdqlMAfXC5A7yzG9Uer
         zZk8HYJKgYXgxxFY/Zez1NkxM1FWW+HjY4SB+tyLXE7IT9WkzwwLPBhJnHFVZ3rAwxA5
         0aU7tDJKoAUNBeI0yCM7+pP2NNCAlMoPhhnIQ72arlUskfDqsRoFEpTLyaJP2D1KTkW1
         Eukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772537442; x=1773142242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zrUsPz7mski9Qb/OvkgQW1KGt3Ejhzi6jRFHoRkisBI=;
        b=AfjIPlWGv2PSQKNmuZ4V+Wxnnjd1EXXi3zVAkTRdRJ+n+sqTWm6eLo6r8Pik2P4j8B
         j0Pvh0WuYAsLJCiw1TcXMVGF76Xt2OWAiloSzkxUL2eAB0ZE4nleBgPhzY5nW5ahVFmG
         l0S11sQAOmKIK7vyuclxnxDdmTtG5HxDxnF816p1pS8ulZa0EgqllaRIDeot59qp4opS
         zhkjcdEkw8tomreSNLx5+kO8y/lUDF5CFOVTVTZlrBDiQHlBHPRWphFzKe36BJbBMnH5
         8nGlvbfq9grZYw7mtO9YSjQ272v4v/LV/+Pm/49k3inMJQ+quVyeg2MTfBrONz55ZMpw
         wzww==
X-Forwarded-Encrypted: i=1; AJvYcCVufCsSGapZ31ZY117dPSC3U7I7omcZV4GFHoqtGvwPT3iZjKp0wl+C7OyLyRp97rytmrYpzmbZfg==@kvack.org
X-Gm-Message-State: AOJu0YzGnpzNo/p6wSQeLkTjWcznbIOuygo+Yl4XQV5hJcRgrrt15lQz
	07pJ8kKCUbwCBHjE/pIETq9oQes+n2KM4DtmRXBi4CXpWPkRYKG+oXVnVeABZcF8UwPtacmV5oh
	isGgb2fN8XzfoMhNak5ixmoZhkXecWESeXnrpDePrcKNfqcrSPgxc6Q==
X-Gm-Gg: ATEYQzxN4vWL1YBweDZtn/fsmUFSMTjhxkpyHaVdobc6p0SXde3633m+oW36qBVPYIQ
	IuyyMWcBY/6fJv1L0zcHIhiNG4iH2ri95CzWnRyvxeOxjaoH/a4AIaXAIPUXRhtRCN23K/c11Ju
	LW7hITrLEcnCd4zVwtSrO27QwxyaitNZROdK4T4oStXMk8+h7zQgnspGcDnT3u1v2fmHc5ArXav
	Afl0HAEFbVUR89SaBI9wcRnmEsAio4jVs4+UalBiuYAOqyanrCydRj9ToWnjNpsVe44RbPUxfET
	4RbaFUZLqnm47e8UAOXt8+9GSUNaSdhXvNLiBC4t78fwHfrhxl4eeSFrbMXkii5jkxfy33qEog/
	Z83n+y+deABUjgcDLmcGT1I6K+toQEktkgvNnZXhC0elZFUnxb6EulqmkKjfNGZymXXYqZDJ8kz
	1q0Ukm
X-Received: by 2002:a05:6808:318e:b0:45e:ed45:15f4 with SMTP id 5614622812f47-464beeffd1bmr9623222b6e.35.1772537442050;
        Tue, 03 Mar 2026 03:30:42 -0800 (PST)
X-Received: by 2002:a05:6808:318e:b0:45e:ed45:15f4 with SMTP id 5614622812f47-464beeffd1bmr9623187b6e.35.1772537441604;
        Tue, 03 Mar 2026 03:30:41 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d59785d8d5sm9311790a34.17.2026.03.03.03.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 03:30:41 -0800 (PST)
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
Subject: [PATCH v4 4/5] mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1
Date: Tue,  3 Mar 2026 03:30:31 -0800
Message-Id: <20260303113032.3008371-5-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4OSBTYWx0ZWRfX2Mb4aDrjnJ7W
 xNswlMI2MI/75M6U5aQyUm5UHDKfTWOdjii6NY67ooiNBBcTNOT7BgALxXdr5cgoLMA1SkT3TkV
 /sWdPB0u4cuqcDxQJ7zvlev2k6Og/Rxcgqc7j7hzQXrtvla8mFw2r5ZpzQpimFP3FwgeRcTtiQD
 oOqOr91fYuz+IRnuQdXiBCT2K1TofWsTtvrlUaHV4AvWZplz27ARgamzrPPdoMlhGJch4LAffVU
 vN23JgXjd840z6ILGe8vMQwMfuKdrqJCnFTHPw/7tJY4Dwj3LkWJFx0q1GmVS1TtzK4GMS0woni
 Pp8a5rRPBaJE4+/dT0EVsHYd5+WecUA14kbB3uopkzjLHs7YaW68qEgZhFLrZJq3znWPKH/g5Mu
 aRfyiyPf31iapPPqC/Y+sQzb4QCqDJh+ghlgkoAgt7G/uXmzjWaY+KtHzRyvtRNmMmGazs6t48b
 A76ZPrUvXhEzf0VBsow==
X-Proofpoint-ORIG-GUID: mPS5e4izzC1B2xEd7Wv3s3tlp0P5Ag7a
X-Authority-Analysis: v=2.4 cv=S+HUAYsP c=1 sm=1 tr=0 ts=69a6c662 cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=c6WgzpUFESAvjm-ZtrYA:9 a=TPnrazJqx2CeVZ-ItzZ-:22
X-Proofpoint-GUID: mPS5e4izzC1B2xEd7Wv3s3tlp0P5Ag7a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030089
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 820B620003
X-Stat-Signature: 3f1eemnspdm3u4y1zh8xwsyejntx1fcs
X-Rspam-User: 
X-HE-Tag: 1772537443-932519
X-HE-Meta: U2FsdGVkX18N1pLarheZzY4AiCc+w6MK8usXHY/Nv/Zr85WfH43eMvj1yw9GruV5oM5fBD9+5ptITq5e1aBSxqVXhQhbUoT8nqt5VbfUCe0RVUWEqmhyrgm6hvkQTipg66kgZdkWFUFnvcq0+NnI4AXdViIREMadN1jqqoKwnBPLfRSgNY+bbm5AC/KoPInXdAfFG5TG6qLwhs1HpRFL51GZ51YLergCoW0EgozoMUyzFesm7uQrgN3Vdg4WL/hDvqHp17cyRZCRG+UlQqD7MDilr+5UUlTbfmN8emwLSuk58CDx6ZBOn647n3mASAiBprC82Ik6a8a6g+sjqCPxrynTlDMxx5hXDxm9AyaKnoHDbJfoLgsCVfzfvV8jTMzFliKen3W/r+LcgTCPuCZRwzoN4yfGRg8SjW/jbxvNeArUznK1m/vveGqAoZnQGuVEtSf9ZdfauuMMlbrQx4gKYHqBUMeaFqFH79OighjYse3OkfJYCZ4SCfF/Je7YbIPM+LZ5FmJKsp0kYWXXv3Dm3Be2fu3o5bHaRvWEpGw1TppTWuTsmw5fSb7SbeT+q0Hv9DoPnnUXegGcNWez7HUoQ0l61RC20G4jWYEY0+kjYHfMpLLFIEZY/0HdC765xrILxNF/+CB7HHT8yCWIoOyfchZJf+tuy3/fpEMhepqLn6gBlIQTGdL9kRPc09jC59Bbnms1MNs1Zc5pZgfBsPCHgmlhBJkR3joYTxvsNTk4ytwZi7fENCgDuiPQSrGva1PryNZK1yJKGc5OM1vJ/k5bknYf91CMizoq/R/uxLH4/tikEemPoS4WbW9v21wlI8KcsCUf1rJIl/alWvwwzMojbN8EQxvRxHxkfw4PosLJB48/PIU9zu7JhQqKPcgvVEDz/S/b6G3m4K3qAFqp6kzCITfQn6HW9Mr92DU+aJTHDuVHzn7xYXkmKnwWstrq/Bkqaze9zV94QlGgW6jdZDU
 bJzFGaLm
 WehVPEfy68WPn83UzDqGzbe1xLF5Xn09Wun4MSQzpkc4C55cRAFirnAyu3+W82xbVtKOXJYDsxD0SwpDO8rhFKuG+trHyCisP8yczA//p2fMcSmXhmqJwG8MBUNqEi63RaVK8YRF6qAivnHq464UnxICQPEHt4m1cvVxASd3fQFC1ALeeeYPfS7INNGH/vlTuwAAT7QUlKBdI0r8p6hWDuWum6zrP3qv+xkB3voOxgS6AmHq6bDGzaFKI8hLXwE43MT3hQWrrF68DOiqnsVASBwZkHbSxWHcFFCh8jUnMKCV32xgNFDbHq+Z8pi2ZLhsXJDI21/pNlCvg9aDGbixbjpmj9MpJDYiu/0gaBbV0nMMgC5ByJV+X2S4A72Nww+qm9WilV5lw6zJXTBupGLpumeoO6pa6BaJPV3K1tliY0UFJAZWHvax2j887OknQOVMNXQUeOR2FID7qiw2lfbO/0kDCDX8kTi2/qftfY6+Bp7pYM7By3IaaP5tzctj+ZPjc3zA3DsWhPRwe/q4ZlfKbjgRjfkqkx0bKJW/nRYJ1+Kdw0iCwR+GD2B0J5gbdSt+QCiRK4RoBcofWRUb6D+Rn3Vg/gg==
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

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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


