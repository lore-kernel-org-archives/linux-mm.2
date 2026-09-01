Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 683D5C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 12:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53B866B0165; Tue,  1 Sep 2026 08:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6FE6B0166; Tue,  1 Sep 2026 08:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366E66B0167; Tue,  1 Sep 2026 08:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13CB96B0165
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:59:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87DF81202A3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:59:32 +0000 (UTC)
X-FDA: 85165199784.16.E99DABD
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id D469E8000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:59:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nMH+HSqp;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=rUnVe6a+;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788267570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I6x0aIMNF/APTHzjlwyItONqvhP3bzfUtmEMlPeRvu8=;
	b=rNXBHeSjN61VHG5cL3+iFDbJhT9PZHkgUXTnECJ2HMKkifLR3RJEO6bWAE62rO79CgwiAu
	twataqaAWmAceofmGZWVqbyePLDZ2ATUzKTavuWTXOWkenY1u58MElUy0/k0dpA0IlbLBy
	vkXLndlSa6NsCFIGb6SBSn1iyr1XrDU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nMH+HSqp;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=rUnVe6a+;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788267570;
	b=hdXwFlrfQjVjY6XFalelpnwSRgYt/AJNfziHsOEL47TRIctLQ+xwnDd9gSoX8v3gTpUZez
	BZBYV4XMw+uisU3Gb7bw8yQsH0cNJE7gi99lkpLyikU5jOMyOIRQgUZEoqIeNQTtSN7mzz
	VTRrEsKChBq3iq1R3e0m3xXdB9Zss5c=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681CXvU0958904
	for <linux-mm@kvack.org>; Tue, 1 Sep 2026 08:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=I6x0aIMNF/APTHzjlwyItONqvh
	P3bzfUtmEMlPeRvu8=; b=nMH+HSqpCeYAtqsXegpahaw1UyYQ5PPrVfwfv6K+CU
	EPBG2oxk2GjHpC1pFe5oXbRxkFElbmNZhTKAlv565KApyjOP4qjUY+9PWQLtAzxu
	hYsmV4cfw3NZ36qHC+BwZEkouDexjEfMgNxM8BJjdmP6bU59rbRVcVQ2ZmHfZIF6
	VRviuq/8IrdHJZuB+yYKYFXSp5XYulfXfw1N/GBJFtl22ahedbMkAdeu4M4oJRbj
	oMoKQOcEodOB5+JmkNgeNyqIdC73CaGKHRceqiJC2lWyo7KHgbNG9KVtpaoBt3vV
	4m65hP/AHH2MUt1MePHgnIH3YXqQ+i9qfDMV2qLx9TqA==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gdk1vbd70-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:59:28 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90e94dcec5eso14279656d6.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 05:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788267567; x=1788872367; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=I6x0aIMNF/APTHzjlwyItONqvhP3bzfUtmEMlPeRvu8=;
        b=rUnVe6a+zKyx/2IplGDl2avRdObW2WI5zhYVR3F7jMZQxRi1eBtF9G67Yi1ZZdsxCd
         ae8ORPgBk1iG+lAABsaI4HhHZGxUZRnPcMQDSLzHwHbh99rfVEc3Ve6E1tmP7btURDxv
         25RtoP/4B59+ZuqDhZGe1EwQcuYnE94iTAcU4g46unb3kTG4lWuJqR7Qr3RLOFgn3M1i
         RZ5Y+cfnRIJX/93qfTX5JZQsdnDLv6NlP9LEF0PdSXx+HxcyoXipGVDGVH6WFSIkGGg+
         zlvaJLk9Y2Lj0LrfuvlLgvWX1ZG81+/+sol7QbJ34ZHrk7IwDay9oPhQoOS0zIGXRb7/
         n6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788267567; x=1788872367;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=I6x0aIMNF/APTHzjlwyItONqvhP3bzfUtmEMlPeRvu8=;
        b=UHPw2IiOXW7FccyNSIGnxzTo570ywJtUv/sz4tzLnHPVsUQf0BSr/NSOz5KfFm9IDL
         FRsegYBBzKNod7PwmfI+3OpgTMQ8bE/uhEvRE5wBvmgI6z5irX8KEBiZzDLnxTLVRDBR
         KNN4TnccwEZ4wxmt0tDz7UaeCpd6x+wGe9ct3W/IvYEY/dG+M9hX8/Pgl4oSKTH1F2AO
         QcpMzygE5gG92LLG6Ve2uJtwqbO+KgNbn53BI0IBmliEKEMiGZUDV8asI1JKIReKhuj4
         pRTxTZLPlgkS2LS8NF413Ws47B0sdBwuQuaJbQO4dwpk46OCO6+u5JFy31glpE4DW2md
         lcfA==
X-Gm-Message-State: AFuF++nCEAplQedIDTkttaAqrZWGTBtMvPmlAxto7UHsByVJy49GhhiH
	mxTsK0pAc/FGFuXfvu49WVDxawCAos8CYy2Idv+klsTmiEo1DJZAaTCG7De9CZFDaIqoHSetaFZ
	ga+/E5jwNyvB7tNXOjxd7qO/acoH50zNyrvFCIEeAOoFOGaxI
X-Gm-Gg: AR+sD10UnnXFxWosOsue0+yfvscWWZB64yCP2QAhPYE7cQmydJKSmJVUcsqsHf4picn
	2RQbG0UtPvNbRYnym37FDZPiH2PqRDQWeve7X7eH7Pd/GQd+yJuEkrVBMokx7snmZ38fcSdu2mt
	jzXtTVEslPcyJf33WKD51x44GAqG2c9N48+9XI6jW242ZAvb1QlRsaMpo/5xhfdT5d6rM/uKh8l
	/heaphLjYJRye3E2kyj8lCTclFW7AZqu8Mq2CAm4kksEfSzv4DfPLW/0BSEjGMq0EwZjual/4KC
	yy5u1xRwY3dHEQZ9Isp+ylkbikey6fRJX59KRBhMOIOuVhfggrXDEovx8feLN8o7rfoel0KBJhs
	sLCFUUeB3N8cPmCOxmLngnHtq5Wr9trtm+O4wPydc9wi46Y7n3ws=
X-Received: by 2002:a05:622a:1f93:b0:51c:ca9:7cdf with SMTP id d75a77b69052e-5302521fdc3mr73571371cf.2.1788267567262;
        Tue, 01 Sep 2026 05:59:27 -0700 (PDT)
X-Received: by 2002:a05:622a:1f93:b0:51c:ca9:7cdf with SMTP id d75a77b69052e-5302521fdc3mr73570571cf.2.1788267566713;
        Tue, 01 Sep 2026 05:59:26 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52fbe830222sm96194331cf.20.2026.09.01.05.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 05:59:26 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/2] mm: remove three unused helpers from mm.h
Date: Tue, 01 Sep 2026 08:59:18 -0400
Message-Id: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACbMlmoC/yXMywrCMBBG4Vcps3YgvRisryIuNP21IyYtM6YIp
 e9u1OW3OGclgwqMjtVKikVMplRQ7yoK4yXdwTIUU+Ma73pXc4ysiNMCzikbBh7xnKHGbev23nX
 9wXeBSj4rbvL+rU/nvy1fHwiv74+27QP+ni7OfAAAAA==
X-Change-ID: 20260901-mm-remove-unused-helpers-33056049864c
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788267565; l=538;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Pqs+cj4xtjDFOIqE9jaFWHBHduMHrWgBCyN13kFuM8c=;
 b=v7OUuFlykjFon2/xI0TirQn4FrxC2L8ziRFt3kNCOKCLO+H51gFCuWnVas7TMNJm3W5x4b7VR
 6a4tCgXPVjXA2C/2OtBT7aNyBjd542zmpQsV2O2Bwy5KkSnkbbaIiNk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDExNSBTYWx0ZWRfXxlOjlMD8ScJ6
 YJI0/Brk2PGgX+IDJ9T53AnUUHy7ckn6f7CauILINZ3U4e6q/HhB3UpQNLpAwp7G7RvEnRL/nBC
 2A85ynJKZ2nefbugwmBrucp9om+7GgeuJbM9ce+9KrdDGszaQRa5uF2KA6D5srxVWAZ1KFezpj5
 DlH2dUNQP080oyBtDOIIMS8x67Ckc9VcvearMgRx9axNF/3jhFvSS5Q+uho6Onu4Vh9HP2YPRPv
 XOaroFy/46sWB8dzmNmDqM3QLG4GWaTYY94BfewX9bU31Fx0NOdHSZQi7Ibq1pbHb5FF1QFadYi
 Auf1Voeam/KEBET/wRfdhAKVyiVyH9axm42TEwHfFidfSp6q8Bb3W53QZvwTJtdvrdifVmkDqMB
 sDJ5Gah1Tb/Gueo1x0BMOdjJW5bzrWH1TL+CHoEv0SJBAx0KRRaBWnKpcPVhMHpHO3TE4W/CUrO
 uKhZfHoYYxZfGFX7e+Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDExNSBTYWx0ZWRfX9UeHzHAhBAKR
 3E72NgR9KimX/bvXePSBqVR18cExkfebW4OfUULcekUJQmJLHCUXnnXyOAyBZo3EqY5TGdsJqEk
 T0ePi9viFxaSU1XN5drzdpnMBmvDCxcXlhj/mHFrmHJuHXATNAT/
X-Authority-Analysis: v=2.4 cv=N98Z0W9B c=1 sm=1 tr=0 ts=6a96cc30 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=rF-OBKQuQRgILe8AnB4A:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-GUID: 2oprQGZR5he87WkP9HHYZsRu21uxBUj0
X-Proofpoint-ORIG-GUID: 2oprQGZR5he87WkP9HHYZsRu21uxBUj0
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11892
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 impostorscore=10 malwarescore=0
 bulkscore=10 suspectscore=0 lowpriorityscore=10 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010115
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: efpgh7acgchehkukgbaxg5xc7i3zfi5p
X-Rspamd-Queue-Id: D469E8000A
X-HE-Tag: 1788267569-54327
X-HE-Meta: U2FsdGVkX19NT7IxPz/dSFOgMiSWlCumg0msAvpXBmAAPALaXm8WuZCVJ4/+RJc+p0gaIunkserN/Fi07xCak63ww6GZJ5Lk2HX+gHAAuAbGEr5gzUH+GyeIf5qbwKV0R1bZmrDCRZLm/6STmje+6OYi0zbTSq4eG/ajTP8arjLtqdQbnKlcq7nCQRRb3nigLyD4G1i7E/dIE9liy4/tfXzSXx+np44v/Gnf1HL5aKAGDlIO+2qP6iZayM5ihy4Gjz8zWubuNkzXn03gFq/O6fdqKLXd5HCaObMV/PpUbCJdJN/BawSWFXe4BGh5W9QCGn7/bdIkl5a8pJze4YmIgCwBCsbCgtav7ZYtsM+YWqHHDiev+gz0IZhaSppYR+Imni44TTMw5U+JUiQcgNLICb10dy/VpHDto2qgI6Tg8kv5tZE3pFN+nn4yyaaDjhG4pbOvoMlTy9yyDfGL9KURNyuTPfbJF/i5GeJfLFS24tCC9JRNnkOrLJxAABJJ9zvae2PJlSqAZQXAEixIguMFmY2MNXqWNtw3P5V5Ee+igrMYp242whnqXJhqNyYmj1rpyrXs/HdUQSM7YJNwddYn3XQElDPPmPbnV8xLtecFkqMigi6TTVzXnRFUaGaluIB5UoMf56dA+LzkNpds2tXa6xj5k0NuINGtZe+maiMPrs78br47Uy1YkCNIbakLndpbIHmxMP7ROII1BQehXiH8i8txAQnpKz+FH6u6B3KyGp6cxTds0+6GD3f8Go8om4FKtaLUUqs+x5/WSgKqf4iSR9mLNfmsb7blHuWf+knJToS28fVx8E+7MTatuilAmNFgXrCu1i5hCdlbBok89FhxJhoIJWh+5RAc0UfeApzQ+y5A80J193kp0CGpUjSu4vDQI+3OjP05kpuGW8pGopXjSeaHfelXs7LJ530gIqHXkNfGRgJSv9v6AJ87RsM6QjVzPsU++DyjgRlDAwlCk2k
 33K4XJAU
 zIkR6U8pnjCcORVz69UhMR5YbV1b5xotVlSV3AGzBu8445zsZPX5bqQrm454e4S+lJhkIDO1IPV57rwxRIfA5KVHmLUNLb7zBNITXtQLsSBeBIy7c5ovXnYiaelGVlFxOQfTRqm2QiJyabpU025rwWjX/1A2EfuOu3JF92GtV0zm/JmnZTWap+dUd9rijNetlIjlwpVCEcoviamRVAxw+ICFsyB/4vqPjRC/TdaYCYMSUOlvxdZGmQYmtK0egUly9MbsZmOaPWdSg0qA1BNsY7qMdaU1OeJeFhOB4uov6NfIWXPDlppShE0z8AugBYQdW9eMcR/PjqbybYzTE1jFba2yyYzG/9I8j5HG34pJ5jp5cQYixU8qA0LVsmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I happened to notice these were unused. Two of them are relatively
recently unused, and one has been unused for a few years. Remove them.

---
Tal Zussman (2):
      mm: remove unused mark_page_reserved()
      mm: remove unused totalram_pages_inc() and totalram_pages_dec()

 include/linux/mm.h | 16 ----------------
 1 file changed, 16 deletions(-)
---
base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
change-id: 20260901-mm-remove-unused-helpers-33056049864c

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


