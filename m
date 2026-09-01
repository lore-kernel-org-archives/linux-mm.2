Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BD0C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 19:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D836B0095; Tue,  1 Sep 2026 15:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65016B0096; Tue,  1 Sep 2026 15:38:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BBF6B0098; Tue,  1 Sep 2026 15:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E12E6B0095
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:38:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E38391A0512
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:38:33 +0000 (UTC)
X-FDA: 85166205306.20.306461F
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5BCBB14000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:38:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Wcc9i12D;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=JfghFMpx;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788291511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpxOuIfVVhVb4LmRbY/n+8EtkuMrFuMNtcwsS2l3jWE=;
	b=ZgGCB17PnIVM59VQhX1RB98YKtU0S6k8OtGe6SYqId0dkoa0qxyHXtIjRvhhiWzKImrRs9
	2EF/CeBlQGXG188icENPFD9tgJepZxjq/+J0WFGVeTjCrPS3Ye0/MlIwmda1TK1h8sJjiI
	1LctEgHVJoKXT7GNgRCBt28NF74P3JI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788291511;
	b=Sd2frQuCGNyBxluxskLcW6+Et3kBIPNahjYUVknGFZazJHGkGCTjsvcNeewYt99uI3Xv/t
	avFtPwyHvOl/rHHq5fnh5fGN8WUAEjwCE9wc3+NccvRkneqUWdtz1Pe55Db3K61NckW/3L
	3Nho+z6PoyRgLuaFFQnV9iV3YXcWSKs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Wcc9i12D;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=JfghFMpx;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681IgqXX3153539
	for <linux-mm@kvack.org>; Tue, 1 Sep 2026 15:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=bpxO
	uIfVVhVb4LmRbY/n+8EtkuMrFuMNtcwsS2l3jWE=; b=Wcc9i12DA+c5Q/7rcDts
	WDV/FqfHBRRL98SbWikGktdrhAytXKDWBNwiYO4J7VLW1x1k5j9PrIKYTKi/K10q
	bw6VrNZB3wh9oaw/lMwceDXW6wPud6h6qoD83fKO+BqtY0GddwIdhp+nWEHUHM1y
	pyrOHXcRt4ixhp2MXeOFDCYDGo3ctFa/OFgY8cTsGfPkIrv/kIYTbFM4SKqT07Qh
	Ti664VIfzskwBOJpjdtWrXss0nq7yUM2dwYneVUbZmCcaWAS7FrdGudbTMFfxIde
	PZi6flXM5V1lwAK37KgUvaNUzf4yykz0N+DlgxjfynCD3gYuxjM1qteEvl319t2D
	ow==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gdqbu5yfk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 01 Sep 2026 15:38:25 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90e98e74535so5210666d6.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 12:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788291504; x=1788896304; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bpxOuIfVVhVb4LmRbY/n+8EtkuMrFuMNtcwsS2l3jWE=;
        b=JfghFMpxoIXLDYFeVXT+SldPyZzS2opBksZbdBzZxjWRd8wg7kOpKDXIt+yzipjyry
         lZNggiZyIzd4GLAEoOn5yCuyFlGMPGcK8YPnukQpFQjcB/VosOkPeR3adJFLB6XaOIzY
         vlB+d2NnMiXPxTf4pIF0hsms0gSp+HUNuSPhXCB7v4r8vLoj3xYOkxLLrXGzkYZoo/gJ
         KH5KuXEjHsfmO57AAkg1lQOZ/3UHr5Vnqy0L361WUmyKmM9fCjQ4PLwNnc1KfZApyEUN
         Y5Lh8bd+w0GufModfqrFI1h3LO383DJLexbvdelpw8Xu1oqK7RWsjyF+Jb/mFikVp38e
         XVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788291504; x=1788896304;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bpxOuIfVVhVb4LmRbY/n+8EtkuMrFuMNtcwsS2l3jWE=;
        b=oha7O+jAR1GYjZRh6ROFIPDb2Yms+CkFcrz3xtN0/4ukLh3IzZ766vbioxbjByhMZV
         yzvyrlSVCoZxHK/RW3yrUOU7+6un8Rc4OKQ6XfBvIVwfPqYgWOd2piHqwW0v6SYFVhCy
         GFEkU69hxtEkNirteo5UwfbFzwdFJ3Myps796VSZzOuwKZYJbNlXP4U8xE9DMvLz3DDW
         CHoT10+lEOOCfFT+/W/bT26QjAIJTpUyLBtnHaekFcfQywe4Z+C1qW9Etr/i1avCS98R
         ezPF1x/MskW87yZg6mdo+zq2CP2Wgxgnbzmz04mRYAv/CzqnDFA77M+NZ6vOvnjRx/wa
         niWw==
X-Gm-Message-State: AFuF++mQuexvNsm+aN1UPsxAsAhmtDzPCeMpU+edt8AOefUcYq942YjQ
	DbmJmDISxrrnoz4qDt6DQojVP0cn1TvvCH1dh4Q4pr6MuPgztp5HDjadEmTOJYlUCM2AtOu2Ca1
	hXg6ddzNfru/WhYX4r95yVhOZe9/m+slIg91zUOuv+qD9FoT5
X-Gm-Gg: AYBFou2L7laJYg/rpvmgtYxhLGgfT9zvhutg7kStBPEQib6etnUDii6NROHaJkloufm
	TpPn+mEH7Q+KjXf9IF5noWZHOUlXuUi2/I6NmX04LOw1JkZROb+tGHbZxOImH1JNF42a+MLa42S
	F7b6RZYCkBNkUizS6pNBFWIDeHHwMcCPUUrjP+5/62TrPJ8gdraxz6y+jgXSBk64NiGV36R2Zds
	apR1qxv4qvLUGi8qIosKtaJqDhni0DeFRKoVR3lkL9TZb+9rEvifapUPrrJaMc6dy9m9X18rcaC
	ZVMLmD8+8OeZMI9fiYrAe/Fuy6ZFsyZ/ylCnj0VE0IL0FR8fLNDSvLtXnt05YeYT/CvGlRJ2jRL
	shkOr7fFimqnHKT2629MCmxV4VrZ7W03ZEFNc6rWC9dnDaDWZ015oBw==
X-Received: by 2002:a05:6214:528f:b0:90d:255:df33 with SMTP id 6a1803df08f44-90ebafc4229mr991986d6.30.1788291504124;
        Tue, 01 Sep 2026 12:38:24 -0700 (PDT)
X-Received: by 2002:a05:6214:528f:b0:90d:255:df33 with SMTP id 6a1803df08f44-90ebafc4229mr987986d6.30.1788291500352;
        Tue, 01 Sep 2026 12:38:20 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-192.net.columbia.edu. [128.59.177.192])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eee72f8sm1201866d6.36.2026.09.01.12.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 12:38:20 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 01 Sep 2026 15:38:05 -0400
Subject: [PATCH v2 2/2] mm: remove unused totalram_pages_inc() and
 totalram_pages_dec()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-mm-remove-unused-helpers-v2-2-f6474e169c23@columbia.edu>
References: <20260901-mm-remove-unused-helpers-v2-0-f6474e169c23@columbia.edu>
In-Reply-To: <20260901-mm-remove-unused-helpers-v2-0-f6474e169c23@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788291497; l=1652;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=8+aiwJgC8YS1D9kaD5ME1ed0Qs485oFlFuUrlvOu1Oo=;
 b=gxQdwjFtKUMMZBtFUA2NcrSOyGL/CR7zXevIdOHQloOF0CTnFztdijopSWYpk4zCRuOuo7wDn
 S3AI/kQ2yVkA9P9jWMHhOyM22pB0J4EZeeit8PVRfS4njFpOBnCqIoY
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE3MiBTYWx0ZWRfX8O59z+Ouowmz
 4GDQY7hPfS9fNbUEnd88Foaat+1vpIS/ztLYcUDj9NGtTMf5Pii36v5t7sZ0tjTnQuikhkWibUO
 TTa+KT3wYRp0ubOsaoLgE7bnHQnGLOGtqh3NMF2w7jdU2Shv3Qprf+CF6nPoyBF9lfnFJR5xaxn
 iFSPxdDEUMTVtgAZcnFA0b50ecSJGaNOVuX4p3bMgz+GFa+G+CSSCBLo310m83U1pNJokque7zr
 F8rHqoFhbet3l2MCxfSAX6egmOlgnXMg9ZqXJzYqD0kXjGs0Y2XuoQOvOw8zMYbm95ssC+RUMfu
 0cQdqMgncJ0Q0dO25lvscqdO1Z9i+N/sdrNpR2CdANSGcbK3bfpDapofe6o9sGStObyAFOynaMU
 gjZHG7l7CpW4IlSoj1ys0E+HCNIN3FKLfy7EZoNn2zTNKpwHxip/IcFLK8JICjT0zmpXvCvU5/8
 IcFqf+tlLlbBuBPJRTA==
X-Proofpoint-ORIG-GUID: lkc_Yk58WG7n7xur-oBT9L3SocFBKd38
X-Authority-Analysis: v=2.4 cv=ZOXnX37b c=1 sm=1 tr=0 ts=6a9729b1 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=l2kTeM/jHJEfm+IcnTWp2g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=VwQbUJbxAAAA:8 a=ZKe_TKLu8epUeBHU9lQA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-GUID: lkc_Yk58WG7n7xur-oBT9L3SocFBKd38
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDE3MiBTYWx0ZWRfXxnUamr3+ahNr
 l5TRIDJDITEB/5a1S1FrI7M7pV6tZjm3IBWUeUbFnSHFwYjh3TAmrF+rN0fkVf6tMGQSmjSVgTa
 JhOjMJcksUK9qG14ju/R1BWMmRMe7g+fkkxcBcPCjBr10xVj1ipW
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11893
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 malwarescore=0 bulkscore=10 phishscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 impostorscore=10 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010172
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5BCBB14000E
X-Stat-Signature: uot5tgxnyf898hpahjfk1xsb4aanrdgi
X-HE-Tag: 1788291511-479049
X-HE-Meta: U2FsdGVkX18T4qfocQP4a3Iyvxp68IsnoRI/k2Jcr9ZEXm63zs5mz3nhiPWoUQkrOJn74EzzyEohX4hEvdgBZdOR/4Q/N6z3iLEPQN4kcUq85TEBCrWixBMh3LQAQJLucG6vesZ0ZVBrYG4RUgsN8V63tNVBHajJhYxCSNu+0fIJxTTspQQX/Gas9SX1F4bLga0/oenA4ZSoLh3weilzi/WBSrfWgE2V6qL0VW6rZMnHIu0jaq0YbpsXwkgxJ3Mtb1wtf+J5Cv3o7UCfP+YlC/FvcvdH+AF0C8UYIQFlLezAl1MOpgTxlgCPZtbW73vW3sBC+319KFuTBd3HpsYa2jwrTnsDcuoR2o/xo+kivLQWwC9xiKkfTLOvY7gV0yQidzsTMnDOj4iIs+TAv17EVv740Fmg1w2QXhzOLOca8giEfHMlT7I8cEep5r8AGZUOPIW4uKyzhuxIH6GD7Ka/sqf9PViOT6pKL4VQGl+68BTtOD8P7a+51OwQqw/JXm54KwKGmaV8pYnawo0KfXyTDxy8vdUF2EADf5z6J/Ia24EnN8qB/pg05fjSSacOQeyFemRuFa6cRRtHhIWkS/N9eOFYNPaHB4D/ZuGzVGA3EM9yFzmBqbhLLbCnQUV39+zpznCxEi69a3LPpbSqv74bmIDr5Fx1tN6JkpczVx/9mnsSlmpicxj8uSRMJn9q7nmsz1hR7nKhaTDRTGqkc/aB4GbMAG0CGugKwZPqCWOgfo1HJ/IboZ8+UA0wAFvjHLd4A0aiQ3L+axUMn7Fmkrqw3mJd7vQGQ8MTUbrboCSEaebdJ6AXjoZMDglvg8CenYmY8xv4tJwukzIEXvUamAFi76fvKzROy061oUTD9mM33OhS6yys2IMLtOMZ6rchMT3S7/nNgdnHctDV253V936sR8akF6wSsE4Zzgkb57m9988Smgxa9hCXNj7VLiWsHzuw/4jcvC8PuVxG9mecmEi
 tUgtJCpW
 u0VQwnr9INsFOeM0H8RjZBlEyER5T7svWcZ9Qxszmyi8zZ6k6vsATtlatMq+tkXde+uAXs5OpbG/kryTqdK6lqLAPRXRVA+LK0HgV4aJlNPH8jY4b8Vo7fHjoKTHg69twL12rLRpDK9jfLZug+Q4qEZiPaJj9uxHisQt9Xz/XEPXAhthiAesGIo7ulTFUtjQJxevI5Q6z6ZGkuewW57SMfErltDEJCqjUoGiI4/0CNKwB6iKsUpLhVT8vp7wdeDi9B6vnZxwftJYu+pavU2sFSa5l6lnMxY+9/k3pTXZenVvB+3a39yJ0XMmQK87x3xVduBvemsZ5y6NDuG5uoelISLuToqLNpel0145fHyH7SpskfWq7RH4nYgDKHkBvFMLeabyrGgAislowAfip/T3r71rAwgtKV/rM/W7FVSIagS25pVpOvWIDQaoWsmhnoDu9vyH+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

totalram_pages_inc() and totalram_pages_dec() have had no callers since
commit 7fbc5e26123e ("memblock: extract page freeing from
free_reserved_area() into a helper") and commit 287b89773d81
("powerpc/pseries/cmm: Use adjust_managed_page_count() insted of
totalram_pages_*"), respectively. Remove them.

Drop the totalram_pages_inc() stub from tools mm.h too.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/mm.h       | 10 ----------
 tools/include/linux/mm.h |  4 ----
 2 files changed, 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e3736c42c4db..c105a3758915 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -57,16 +57,6 @@ static inline unsigned long totalram_pages(void)
 	return (unsigned long)atomic_long_read(&_totalram_pages);
 }
 
-static inline void totalram_pages_inc(void)
-{
-	atomic_long_inc(&_totalram_pages);
-}
-
-static inline void totalram_pages_dec(void)
-{
-	atomic_long_dec(&_totalram_pages);
-}
-
 static inline void totalram_pages_add(long count)
 {
 	atomic_long_add(count, &_totalram_pages);
diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index 84b5954f66c3..d586a510e6e1 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -33,10 +33,6 @@ static inline phys_addr_t virt_to_phys(volatile void *address)
 	return (phys_addr_t)address;
 }
 
-static inline void totalram_pages_inc(void)
-{
-}
-
 static inline void totalram_pages_add(long count)
 {
 }

-- 
2.39.5


