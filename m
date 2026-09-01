Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9823C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 19:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6734C6B0088; Tue,  1 Sep 2026 15:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A3B6B008A; Tue,  1 Sep 2026 15:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562A06B008C; Tue,  1 Sep 2026 15:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29C926B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:38:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA3A41404DE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:38:24 +0000 (UTC)
X-FDA: 85166204928.09.068F7C1
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 02FFF18000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:38:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=s+mViLE1;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=HW0Oz8Xi;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788291502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=abeEyCGVZG04iLojvXDSZUvpimuQC1N2Upc36tnQnyc=;
	b=aHvL0fDmDvDh1kmZQdaSncmBmUF6nubMW7jxEJX04hMqKBotF3qsv8PL7G61uV+AK26Qds
	zXBRbsKbMsMpEJqtcTO+0ujIZMrY2sx05f38/A2nzcBjvP8XNIaFLzuUDKMLnWU0YdbBdT
	M6fo65LpZK950CM0zbjqn5jmGU/CycE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=s+mViLE1;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=HW0Oz8Xi;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788291502;
	b=fFEWyoZ3xVrSvqTawgU3Q668DcEntQ7nOOtckNED8kOGsjNtWPKd9zycn+sdHfpUC/ALs7
	kHvyLJL+w5xjg7NEJKssDqK4bTqME2rbrBKdP0N7CIJ/edIF0GgHLJcD05gf+fggl7uxeH
	mTgj4kMV+t4ehjvOf0pb3KpRu2miHGg=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681Igfv33153204
	for <linux-mm@kvack.org>; Tue, 1 Sep 2026 15:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=abeEyCGVZG04iLojvXDSZUvpim
	uQC1N2Upc36tnQnyc=; b=s+mViLE1cujMA8/hsGitHgYeC/jVd3AWLgTZi8knVd
	P6qphQ2ZoAUAH7cLvNJdgky5AU+H15hLR0C4UU+a9jtWZrok62YEaGxRb+TSvKvD
	jIdFJfwrB0Iwlhu4bJEV3rDrWTX1/+c8wJ/p7YXepCcRo7KwBvYpdtpDzKNlipRJ
	0vglwqTWAmqcCPNeWR5FeugeVUttPqckxJAquEtRfeP8zsAiFE/l+QGKw7ZcLX3f
	Edp1bKdEtyqpKwTfU8S7VwleWbqWOwI7gxehikadj0lQF9YMHsOEUG/EioID5nLw
	mTUDKFx09T0Cj5b7jfiooZNiaLxmj6s9fwcmhsbrJLNQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gdqbu5yeu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 01 Sep 2026 15:38:20 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90e87478402so7653966d6.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 12:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788291499; x=1788896299; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=abeEyCGVZG04iLojvXDSZUvpimuQC1N2Upc36tnQnyc=;
        b=HW0Oz8XiTO8ruFUJZ5o69jOp124g2MERoYOMSnob9VBJ2n/A54pWq1rjhJ6TIpNXmo
         MXMq+4Nr9LljM1ByQ5Z06IipeJ6PRr2AqLXsP4kL3lM/kajboduIr6IVVxdLWkpScmsY
         mTR9jxAKIu5b/4+fRChtjfy2csEZxsEcaBuaibil/VLfImVT65juHN8NlKyakvl7tbUX
         wfAlPgmNdaLVRSzBvGd3FA9YXRvcM4Kj5PHQ4N8bT3chv8NhcBHkR8s39nsTwxUuNVHd
         xih469Ht7wIhVjXLe6oxI4aqCvJcah0t0M+Ya2HyC2XWvTmyzoWbhTUbJ5K9wK2oRYvd
         nCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788291499; x=1788896299;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=abeEyCGVZG04iLojvXDSZUvpimuQC1N2Upc36tnQnyc=;
        b=HGe66Nh0bffuJJg3uiKLoA/d1RcMdjSUd16EJZbHoXs0328gSbqc8G0Qaac32AD8uF
         bx30WI+JPZ2P5xLC9BdrSjg8jZxV3/Bzh2avoK38vOk0UvuLKpHEbx1QlwDZ1SEmI0iQ
         yLSLjFFQTjV2+H0dcLcX07mNLxoixgd8yk66I1sgO7L+yXWUNPROTLOiqwqC03PQJK08
         Wajhyk3DuzJcUXiu7ubijeaNIDmFq3ZZFbcO3zewis5gDzww+bK0PA86oGXp7GTqFwyq
         E4sXYV/OsYdQHds1tdRr9a1w+vfHCqUJqKDAW8vjdYrDX3T+QKBrKTYl/ovnwtTTDiQZ
         fNqw==
X-Gm-Message-State: AFuF++lwQDPxsG91h+Lpv8TvVDgfCErJEyyeqd4VQR4GQ/Yj5Fj51m1N
	lTw8ZwOxTE3Ys8OYsPT+4rNr1kxu5iyl2HB9TFUoB6NX36BuqgK7VVkuJ/f0vdtIIvF7EIWgrHH
	BnmAX6UINUSpeUGv3ZcnyGRrsgPq5RKoLYytnC3buLbDHBP6L
X-Gm-Gg: AYBFou1DrjFB593q5wdgKfB74w9rV6STXOQ4ClvVXfwapcscN8tcUTtjcC9l9PKE0QW
	dF74EI5vfVLC7+eQHq95vY5aYfzWP6VW5EtvvHee9PasV8QviXbjl5PV7ta8Q/hIlflHXmASXLn
	UINg2yb7I5GCjCp3/8KxTJDMs27nRpqvOQMFsvPhrVci00wSHftISaNW7es/JdsPWglB0YRuB/L
	VtyPm6MZ5PGqfCtBncLyemePl3iGOnsrGJg2fQeemPKYUdo7p4gp8Z3Ix/8YDD7UfWLXkkVbLS/
	eJvSbOAO5aJchE0AhwNPKpdpEDsbpDtnp0FAr/yjNhrgf+pVi4D0FT20ho0lSiaukRDiTUOf36t
	PNePHRPJB0CFVWPpwXKIiqTgw7dGaeNQgBGVYBAsc2fZUEp+uOTOPMQ==
X-Received: by 2002:a05:6214:4197:b0:90c:d4d1:aaf with SMTP id 6a1803df08f44-90eca38c54amr253376d6.20.1788291499326;
        Tue, 01 Sep 2026 12:38:19 -0700 (PDT)
X-Received: by 2002:a05:6214:4197:b0:90c:d4d1:aaf with SMTP id 6a1803df08f44-90eca38c54amr252726d6.20.1788291498789;
        Tue, 01 Sep 2026 12:38:18 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-192.net.columbia.edu. [128.59.177.192])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eee72f8sm1201866d6.36.2026.09.01.12.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 12:38:18 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 0/2] mm: remove three unused helpers from mm.h
Date: Tue, 01 Sep 2026 15:38:03 -0400
Message-Id: <20260901-mm-remove-unused-helpers-v2-0-f6474e169c23@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJspl2oC/42NQQ6CMBBFr0K6dsxQsIIr72FYQDtIDW1JSxsN4
 e4CXsDlS95/f2GBvKbAbtnCPCUdtLMb8FPG5NDaJ4FWGzOOXGCNORgDnoxLBNHGQAoGGifyAYo
 CLwLLuhKlZNt88tTr95F+ND8OsXuRnPfebgw6zM5/ju+U794fNykHhB5rrrAS/VXJu3RjNJ1uz
 6Qia9Z1/QKJ6SS01QAAAA==
X-Change-ID: 20260901-mm-remove-unused-helpers-33056049864c
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788291497; l=821;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=W4O6XEpMwynUwwXj0xfp3EfT0BoZb0GOfBjR+1fixXU=;
 b=cc1Kbk3+fvxtQyPl7Ad+uVIO1DINWfdCFEs308JrvB39pcwBWnHEaGiY4trGL7kL0GXRt6W3P
 HEYT6ztXGrkAEI1h3slb8NH5VekdmtkYHBlJK7fkvtCb/VdokMI6bcv
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE3MiBTYWx0ZWRfX1rLuWI1qcN+h
 tf+pAE+HNarwoFqF+P5MvnKY/qVF3IIj4Q70SHylPqKO9lPHBuK621QC50LvTCU7zf6aOOlt/Hu
 2e5tUByDwgwmGa/9DbrP6avHjZxzZv//6MP9ZeuNjeKE1je2H8Gv6+D7SE10qPHlSW65ledIAf5
 lLzTPBt/28eWFI/SLxbYI7bEoCvDcq+/DJnuGB4DojLYMg7HLix9WUF580MNkDYYzhAaF9U8nuk
 ywk70LcLs857ubg36Fo5gX4ptSh54M5LVvZobFP2HUN0Xc+TA3yBXvBYPvAxjVKRXUHlICLeLGC
 rZdiZ18OhSr7i0MUjBCJmarxEDgjJovf2EDrYvrAw27jM/0ACNSpRX4nXPiAvtg+KyCFsPrSUbX
 s/Yh1vJz3KpzkCwrNq6U2OrRhotlRbKZ0jiISRlcEFbZmVb+MpNyc3YJODVQ2F1PvRQ/b05e5Y2
 G54YP/OQW8CYoXp4Yvw==
X-Proofpoint-ORIG-GUID: wC0OOUN_bnMP0IzS4t5vvRisi0ALzjDw
X-Authority-Analysis: v=2.4 cv=ZOXnX37b c=1 sm=1 tr=0 ts=6a9729ac cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=l2kTeM/jHJEfm+IcnTWp2g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=bC-a23v3AAAA:8 a=rF-OBKQuQRgILe8AnB4A:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: wC0OOUN_bnMP0IzS4t5vvRisi0ALzjDw
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDE3MiBTYWx0ZWRfX62uHwDiqmWdV
 rxGQP9Vuo6ykhhGRRN8hzgkT8QqIUU/WfDq0RchgtuN1RKp6lGloeh5CKMaP9AklPR1IeKSM1FB
 ZntZFEHmLwqLlbUZ8E0Sn8IN2A3SQzM/VXa9VkyJl+bRZDPlS/Of
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11893
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 malwarescore=0 bulkscore=10 phishscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 impostorscore=10 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010172
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1u5ntysjx8nz89oqkoas8s1m5fdqekop
X-Rspamd-Queue-Id: 02FFF18000A
X-HE-Tag: 1788291501-395401
X-HE-Meta: U2FsdGVkX18EDVkEIGashogSQ+dt0hcxE9WxyRxa6cJuQFZcrO3WWnEEuhTF7ENZu3Bfo1FeuCT0UKnW7ngCtqQKDmmAOndvLuSvYp0bxdHiHnj8Hb1UW8hPg5fXeHYh55g2vpaESEbCFE9nz/gjYnvLQaSrVNKCe7hYee552LxbUHO046o28oYOTa3pc+4FyhN/ld9ZrDo5F6z6RincuY6hnRf6I+BUZW4n4Ji1BFb7iEyKyw/r7WOylw9aXP8Ig+X3hZpmEw3VUwo4Z/Ra4aNX+bAriNBWtdkoZsq4nSB9V96IjuE6bDeJOAiRwN3pn2eXplvjZVfZEmllG+Uc085wIwVgZIuwxTLwuD+8BOR42xsL9uGM5o4bbfHEMQcEzZ9BoyHPJVfSZBQMeaREpFSO+yCk+tl8NtaQaDa1ismIbwl7Fk8DPukq1/KEg733WLwX3h9+wJcpjqw769VmsrrV+XOS+5yzpoUqa8+MypxffBM/IRxtRvNFrz3X9+6miBzskVB3IJbpCmzBslGd4z6n/SA5vbvPqWMt07BTcgc77dIImfJyzTnUDlwR1xXx+S7ORjkVZDzLxEFn2NFmWu9+5RkL5PAFV5DTB1VN9Z2Qbol+hCuj3adZG0PMBv+Q6EjCNdaug8cxQ8p8jZIB+AkuiUIvCpBz22u+PLnP3ZhNbOvm4DA5/HCUDEy0Marley4wN/RO76Z6ZJ2Mhj4T/3fIZJOEJb//cwfi1lmAx+JyjrrrCRO0q8uiI53yPttEkF0PishblDXbpzLHViiGEpWmUA9MfUzThsoPgaVI8j+1s3BI2kWTRu+SJv5cG2RCXHNJSLe9aMYniurphmI73KNEQ6KOq7u8Gcs1StqpoP7w0BToyLLdcgRTw0BDzBAwmu8DHDyf4Qa/OLPiV3DsHSrMuB9jpuBNXNOswXU/Q4Q9v8CKrVwPySWf1TwySoXRTXlmb4GzYxIKvWxGq1U
 f7nAM4Is
 /fagMnxWenFOR7w1jFDSJ1rRlSTN8gBvwPK3S7L3xiAnMEN4hfQvjr6l/tdnsP5ZqlkytJBgAEaMvm5P9iw3PVa04GL+HuBLszShhrzTgPb/MP8Px9Eve9GUbbxaVQgI5M2npVkIlKTtX38nrGSpqByirDsvBt1F5h0kO2Xj6TIm5EQK9RNY7iaxEisble1blumerv3gyJZpT37SIpcwXebLnVfBNV8iTKnayBJvchQRcLoaDNfmgF0X+B/hExScV5wDcuq75VEtu2XO5AwkcmBpI90vWnDeznCEhnM503f7C2K6wkRmpuG4WLLzuCfjR9rr7CUHOjT57Nd/zXKuRig1MuAaclI3+fJ/c9KedzQCV4e89Yv1WgKeUnDjwAP8FS0xq+d7ESZvCuiPVvrSbVaXAtsRjoq3rjFooyK6ta+RUUrmA4dMhOULz39cCoTYLBRIKSexXp6aVFBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I happened to notice these were unused. Two of them are relatively
recently unused, and one has been unused for a few years. Remove them.

---
Changes in v2:
- Apply tags (thanks Lorenzo & Mike!)
- Drop totalram_pages_inc() tools/include/linux/mm.h too, per Lorenzo.
- Link to v1: https://patch.msgid.link/20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu

---
Tal Zussman (2):
      mm: remove unused mark_page_reserved()
      mm: remove unused totalram_pages_inc() and totalram_pages_dec()

 include/linux/mm.h       | 16 ----------------
 tools/include/linux/mm.h |  4 ----
 2 files changed, 20 deletions(-)
---
base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
change-id: 20260901-mm-remove-unused-helpers-33056049864c

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


