Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 581BBEC047D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4596B00A1; Tue,  3 Mar 2026 04:33:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2436B00A2; Tue,  3 Mar 2026 04:33:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6866B00A3; Tue,  3 Mar 2026 04:33:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA4C6B00A1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:33:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E92721BDAC
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:51 +0000 (UTC)
X-FDA: 84504239862.17.098D38C
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id A687B8000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=A2qQARhJ;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=NnizPh9u;
	spf=pass (imf30.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7rYseVkxS5+KfcyGe26QQjJgka7f1dcyKVc/ATKtdbs=;
	b=Wzh53dLkk8u3xeqp3+VcShuHbq27GMovnI4qcG3xe4DMesGXjxDho8lCKEeSTMvGc7jqEu
	lp4K/TPBAytujk8I+opvZOJyDyX5gLrGC1w1sCEdUtJszUkKkgfcrc0WEZE0jA5TjqPoz0
	ZAEaCRnPPuofoby7fvI1sfeAwey9Feg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772530429; a=rsa-sha256;
	cv=none;
	b=Ss1Qf2B7APsbR6xlaUFqYGv/aYLMkJFQ9O1row1TaZfOrtDBWFmQWdOipLLU6a4xZgaZo3
	wXCdCZX4+1nMUjjokpvuseHfUo9yvvrVy/cp+muktAetJZpkc89JcqKt/t85idu2kT3wCJ
	G9Gus4eeIWBMmJtMtyJl3EMoJUu+j2E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=A2qQARhJ;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=NnizPh9u;
	spf=pass (imf30.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239L5To2553911
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 09:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=7rYseVkxS5+
	KfcyGe26QQjJgka7f1dcyKVc/ATKtdbs=; b=A2qQARhJi84mnrPGEg8Holq+5M3
	UzdSd1/wYzgXrlZjAnKeXuqHWXGzGIKhgoqB3qYc+PeD+5xwBu1l6QhUC3e3ZfmF
	tmeuo2+drJLiXFCOPcrC3N1KRXSY6WIPzvmnzRBzyPRYpw5DoRWg2YuvwCxh2KVd
	Ybh6FxxDGLv9nHsz40PGyR3tWMYaEG+HCFTCfWzmBYv0tEBbB1uqDeGed7jRKlzU
	MZSHxsEXlDp0kHcU01D6L6tw9x8HTxBiPxa7m3SMSyn5B35Z03C9+gXNy561jGe0
	2E9pEa2aWkHYGziqnFGPKk+mjw8tUWByY+9X8ERby+BXiTJx+meSMJxf5wg==
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnvxf81mm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 09:33:48 +0000 (GMT)
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-67999893008so47455280eaf.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 01:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772530428; x=1773135228; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7rYseVkxS5+KfcyGe26QQjJgka7f1dcyKVc/ATKtdbs=;
        b=NnizPh9uwFoLcDcTSHZF1jFrWB414F589A+TMNWbzPygxa3eN+RquUTCeTFLjP+/Sh
         bbj905odwS/pBAQ+TuFvGfBS/TSEk5LR1f1q690Njn1oCWe7PNs1Vm17qUcohIps6aT4
         FySvrLcDI4SYIk+n24ykSguLXQMN4/bLCfxeKyJGY3TLwh1SqULwTG1PtSGsfFjGHY0d
         o+HfjeC63wrP1ItzE+XhdOlDNAw658TXF00XziJUXYA+n3IaZH+c+1exOPoGiENQAp2p
         puoOX3yTQ0T9jY3ExbcHR0Gt+Hlsm1gB/zVFqXbDOBudDft9+38IonV4IVkCGRjgV4N7
         Af4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772530428; x=1773135228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7rYseVkxS5+KfcyGe26QQjJgka7f1dcyKVc/ATKtdbs=;
        b=xGHS2qvTJtPuxmYqNnbf41McSkqDXhToOFHLX9+LBDUGSWZtdQ547Uu92aH2uvcttE
         jqOjL2K83Qip7SDy+ZVK8IAHV1t6kuqGXow8eY30r7bJnNMSAkkbbz4qpQ5XXJPfl0uA
         RBxYxutgYrUzX0mENTo7egOYpJEGwRryYi3/YaHGUJ+IYZwhjbmDvMqmAvPTZ9NIfxg3
         mnePxtHED6Lf0L3ROCfPWqfRHTRVAoD3YkyVkHUzNhdNGFeo39oXTIUYqDdjalofOVPn
         xout79IYxD4MoNXUSGsluUUzhW4oZDjuZAF+mNaolDe4LjiwAgzM3pfqtQ62JhO6FKzu
         7xxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMfGA0lNh1iUU6iMX3WghwBkSz97G9UOlwTNohiioab0bHUebbALyXyQzXir0fEsW5kmSD3mjDVA==@kvack.org
X-Gm-Message-State: AOJu0YwYDTJbDBnf/6n/US8+f2paYujRYQKiP389YZtgsrQVr3T0gMhz
	5uJZwyqmLa5KBStYPI1+cA5g5oAqlMCzHl/efmHrHTHqLDOGZw/qMyRSH/NJvsvWYEWeh9TAr03
	0ecRn3AVrgY86uoME73VVQ40KF07Nw+wiWgIhlzg7PgWTfpAwez0Irw==
X-Gm-Gg: ATEYQzx487TFHy64yuiSsnWp1LEjHk18ARfvNCAxxrHnbtICGDjgku9XkIT4k/2Tu9p
	j/wTC4iHXtd1Idbpndi+/v7QXft/t6xPgasHBqLwUCb30W3triMwpG33aTIKPwCQAjYTOw07/8A
	b55dneK611lqBaJVSB4R+1/aD9AUvOB4kUvjFrGrt7O8KfLSCibowkLrdkJlaP37+lb8KSs3smK
	jHAF7XzSBYV3L13spfw3til1fp6Ou8Tzn4oBYN8VkC1/NmqHCDILniQEaqqd3ax+mG0Yw4j86PN
	5zQUcEVyUg2W+p2F7mJ0ojHZgtbR734R9aafnRy7xQeErIn6+ebx1+BEe1vHeXcM3b3FTtKcmRT
	Q6hli3K9L2K5Q8z8CYNaCFw6Ur4LCmXyd5fjMLla9s6D2MZu4hg7+OQUQ1pfrZ6PfzJIrdJll++
	kCMwMo
X-Received: by 2002:a05:6820:2913:b0:67a:1d5c:b249 with SMTP id 006d021491bc7-67a1d5cba23mr1025568eaf.74.1772530427958;
        Tue, 03 Mar 2026 01:33:47 -0800 (PST)
X-Received: by 2002:a05:6820:2913:b0:67a:1d5c:b249 with SMTP id 006d021491bc7-67a1d5cba23mr1025558eaf.74.1772530427553;
        Tue, 03 Mar 2026 01:33:47 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67a1d603f31sm938666eaf.5.2026.03.03.01.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 01:33:47 -0800 (PST)
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
Subject: [PATCH v3 2/5] virtio_balloon: set unspecified page reporting order
Date: Tue,  3 Mar 2026 01:33:38 -0800
Message-Id: <20260303093341.2927482-3-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3MSBTYWx0ZWRfX6RaIK23m+VKc
 Idv8N/DkkW6hsRiX538uak3N7384TGjT5P7DLPZY4rBZSw3a3qxE4Ytapw654igCnnUYSy1DdL8
 2mklUEHrjFw7zt9fNFGlC16S/6t/Pf1URi0GA28SZ39COEeY3RUMBfwzQZXcE4U1a2Sy76U3XSu
 bbcT7a2S2vzdQ1prSarzxheOzzVBCuRAFkV5mRvzD4Ztd92RT9ji20mcAD3Rx6ovcYfAJ4ix3IU
 U3JPVGi40KDYpjf9xRNwTZsBqDqpAzEJPmXAm0DJSw32EWOXDOqHWrWwGdc3kJtyZ1e5KalJifA
 L90RV13zPcDTfZJbv/3r3iLGiVsdSx9V29Q5XjQDdgY65o+mzo4tdRczNnCBNmHTtVqGtBHt2bK
 Cqj12kX+eWGxgz8T9302jv3P9mIE0gOTa9i3WDX00/icdX0HjL5I7E0KjAkbdPEMAN0cR0/+E6L
 xtcbEIDjxxjZp0lBI+A==
X-Proofpoint-ORIG-GUID: Tz9UDjufV7-llKy8hXnaxBaSQok0VIts
X-Authority-Analysis: v=2.4 cv=S+HUAYsP c=1 sm=1 tr=0 ts=69a6aafc cx=c_pps
 a=V4L7fE8DliODT/OoDI2WOg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=Jvdq4yWlxvBRgq3Xg-wA:9 a=WZGXeFmKUf7gPmL3hEjn:22
X-Proofpoint-GUID: Tz9UDjufV7-llKy8hXnaxBaSQok0VIts
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030071
X-Stat-Signature: nrbs6ef8kkkexq7dg83937tr4oyc3jg3
X-Rspam-User: 
X-Rspamd-Queue-Id: A687B8000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1772530429-987367
X-HE-Meta: U2FsdGVkX1/CVmurOvT0jmNL3mFisTxq1k1jBJBMXLgIDJLuNksR8fgWNMfMjznlZ22qh/I67mVQpkAshRE4dnpG1c5tZa1W7g1YMLxzE/rTnmmv5aRjsqEK150tt9C0QxztwArYqAZRLhH2+OAjGJZDH32SAGg+HHgb6ylhnyTP0lT7ujuzXpG/2ikQcEl3mwWFQpj/vdPN/BkynFmGFzFQ/1Gbo+G/BRCa2knPjrMb4TZhDQLR5ym06Ii1+LYBksaESadxcq+ekZ1+ZOBZP88MJg3k4kTDaF7IkeVeCwYJDM4Jw/wa/YNQw88If/VEE0gr7liUebs9QmL0eKG9g2jVXzMbhxPuAaavznHWCIAflzkWxZJfTcpDTPl5hsPpwCvmVzlLAqIsaXnfntbIWD5XiTsBpOlmWZPZ6+QlqkLGzFKiuOactkRK0f9rSeHo5zaDr8YmDKeKMVPFG3fgCK0CATONvfGPl2wCP1l/iWliw7vI42vlmrDaccrr7ew8yCTHSJtQCPjEQH9CdGKVc6xPq7uPgmFRV/HbKFNNxdsouP6AiL33Jw0Y415p82QZixSB5ABWHgNTNZwLdhUiajf0/39gaA/T8XuO6qo16aIDoRgUduMKZfqAviMKYa0LHeuyXtwHaA8yi7B1vPMZ5Ekwwuh3IGHmRrsBT4+RRUjXoHjDXZNxPebI2zt8hlqnHMVRE74gP7zFlvusLUseSEJp64FiOKnen3H7ei7bkv1TOFyRfJd33pEO+MY89Laj9epkuZ7KlTXd2yVpqY9EpQuUlUpspRSjM2t1EgUJc5bemxGRyVJ652UhBewjzuOBRJjQbQ8isCOfbKWZKHuaz+J2XOkFFWff0v/wEgDWAr9+t2pzd0ytMMr12NAxnxnuNQvin1+61miVrF0dVjVGGzs6HCtvVMdO1w8VQJx/oJOaY12tia7X4W3uDQiR/hDymCZsX0sEyKk6qPsIMNM
 d4+5/H2A
 BaG1DoBRk8BZTifFPym5ugTcePouOfyyVVoaCTUyKaKgGCUV1SGLRnDfz90ABItfXWr2DX7bwabprpHLx9EW+hBDsxqnRAsFkaRzePLyv+U0KlpLbOwNnsBmWoURDtmUc9v+iXVAR2akA9KSqEdKa5OsaRAAI5w626yn+ez7BWttc1WZo3MHLsnf0GyGtLDGfR7kjt3XVC9yFJq2zSN4d7j4VxqwMYexn7pUVmGNt36wOU+B7ulsMCdb0LD2/TajBLs6cwBrU2Cw6pB3DVgYv12Sp2uOzG9q4GQlz0ihmFUzncHNW6aAWbE5EpdTeU/0cyIZ9c8ZjcyNSqHAMEqUK+7Vkj93kV6Ch6pvcovW//rh6hyvmAEfRBTvsnx8S+ALNGmKgN9zJBSvQPNkizdVOOmeONJI2ybE31/vgBfuhq4fqI249nYjEZXElXoQlr1BVQFP03MX60z6UhaDenlHoaAzcgbgHgYtQgNe75MI1FvK8nrBxJX49rTehgutR2OAe4P2sQKXXnFD4NP8Vm3OdqX8ErAI8C4WfIbTG0ntW23gNt1zC/YI9OtlIzCeD89YZXsnrEypbE/68mVukPq+0GEym4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

virtio_balloon page reporting order is set to MAX_PAGE_ORDER implicitly
as vb->prdev.order is never initialised and is auto-set to zero.

Explicitly mention usage of default page order by making use of
PAGE_REPORTING_ORDER_UNSPECIFIED fallback value.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 drivers/virtio/virtio_balloon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 74fe59f5a..2dfe2bcd8 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1044,6 +1044,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			goto out_unregister_oom;
 		}
 
+		vb->pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
+
 		/*
 		 * The default page reporting order is @pageblock_order, which
 		 * corresponds to 512MB in size on ARM64 when 64KB base page
-- 
2.34.1


