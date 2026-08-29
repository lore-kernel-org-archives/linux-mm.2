Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F07C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 19:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC346B009B; Sat, 29 Aug 2026 15:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686016B009D; Sat, 29 Aug 2026 15:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5739F6B009E; Sat, 29 Aug 2026 15:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0996B009B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C07D1201A5
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:36 +0000 (UTC)
X-FDA: 85155245952.30.92690DF
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5CF314000E
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QV1HRb7g;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=XPC+UpcP;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788030573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E8sXUWWvgumxHaw6NteTp8vxgRbcmWk9fgTLWHiUUV8=;
	b=hRe7NDKIpY1JySe/lwPBMwfht+5ntYoxfD3jpZpyWm8pKDzBg2ubU6p863PrYyFJ8bK7Ab
	sUPQ8XzgC2oZPwRXwRrlPd1u1y1pYyf7Av6ejjptqYDqMPDK6SGdFWCpPt+Apipf2GQMhq
	7j5EAEYyEUbaOEspX8JcR0qymg9zsr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788030573;
	b=FyYv4ulcLq5Yeg2/MiuVJ75xpcs1lYPYjvLTHwaQQ0X77l3XLKN6FUiElvEmLFhVMCWASB
	E+viV75Lsic6C29jsvXfDw352Hcn5yhrNejQXqMp8lNRY/WT/mHAgLf5dmqBnDbyUh+lmy
	u/DMQGtPewrXKr2LEoXrZl27M0iXj/Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QV1HRb7g;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=XPC+UpcP;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TIYxtD1210752
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=E8sX
	UWWvgumxHaw6NteTp8vxgRbcmWk9fgTLWHiUUV8=; b=QV1HRb7gXk2P5EQTzx+V
	KNUFpZzKdMSgg6YR+o5qx5CaNnDiLV+godq5bY1Hf573Khmja8v7y/xNOQud5wLT
	X7Uh9vDnkWPqFvEZfNc2EF1g0PX59+ip4mSyI6mMJvNrwgCiuHXmGk0xWP/jpgPX
	LqA1zhCOncfDO/bbysqb8KXxgh3ur4SLA7joTgB/ZLTfXitsmT8E8y+OOGXpNauL
	IREnK3Cf3nWCg/vWzYcRDvqAfxDGCfVEf6MRFz2LXKOESWGxC2YSnc4FOYrxZXGU
	ELvaghMzfsjOEu6ZMf9gQnFaKtK0H3XtBWy6XNlBQXMR2cD1JkHzLiL+G2SLkx+8
	ug==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbufx2rng-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:32 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-938153538caso380338885a.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788030571; x=1788635371; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E8sXUWWvgumxHaw6NteTp8vxgRbcmWk9fgTLWHiUUV8=;
        b=XPC+UpcPlnaPtaNWPmXx5zwr5hOyb/t7ez5r5dqdjoyFJ6/zBbiIRdHk4RPAGVl58w
         6oSju6Ei67ILTHOO65U+xdYFKMjFtVac7f+RyuvhN/BKLPwP7KIsKSY2AVyvAly5Sg4d
         GqOQ4/T70QSonB5tkq60s+2QoD+bbfZrdkQfv9/V12ytyAnFDiU3WHRWYEyg5Ycv65El
         zFo1wZY9UUAK3PNh9JlrjM/ULgU4JJRH1D6Lj4Uk1dFLf/qC/zD1Yc7Bn2iqOmLqGS1x
         pEx0TG94ipR+TaDI7fA2lXVAdAWx0vrYFHTzaIgcagEPO0bRmFeHZKpZPK2Sr/1bUOCG
         Fumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788030571; x=1788635371;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E8sXUWWvgumxHaw6NteTp8vxgRbcmWk9fgTLWHiUUV8=;
        b=mc1ex4MbSe4u11Mm2JHADikGaSdiDyslp62ggzpNpHORfc5mC1pmmTq2Wt4WYn8iwt
         O+sOYJQyy9ghMSg3lWGqPWKyvHH0DpnISzXmTc4GLQ5hStJhJQl0jl5Q01S/7hvisHpX
         1n4QqWqueV7I9OtSUdlXeS218rW4zRAyBw6W83c1yith2VmVHajP2P2pBVSEDo9waDVR
         WyY/L2D9oNmRNjk00APpS2eyW2Aieydgf7L4NENWHiSiNJQMMc+RW8h5E35x07kZTt/A
         TBwGLWdl+k7BwNZkb2h8CNOTF7sV3kKlEIZxzK5X59+ylDu5INK3igkiohOjV6g1IY+y
         jaTw==
X-Gm-Message-State: AFuF++nqkkk7enpXAdYAaDNqo4egRvXwfNwH3mWgoLQ+grsf76KtdLvV
	wW3mRHYb12AUQaF1wrezI9aBw8YaSlCvuq2IwdXgyf96p5WL7uQl4V2R6/jJsiSxZD4qv42dtk8
	eyRxHzwLZRYQfXVhpFYw9TsDL086+M+JeTGEEx28ikLZKzQBb
X-Gm-Gg: AR+sD12M1SUo1EnchwASWM8178+AvkRBXtANNPYeN0cq4c1TFhf+iMKHPsJVEfJFo2g
	PHYArZxHwveaO2cRr3WDjmx1A6xXYU6j9DZ3rR5jd87gin4G5mSHevyo6LHlV/L0dx4GgeghJ8y
	Q3A+WxXIiqB4WnHLXQy6nfXokTB13fV1C7z92KTeYp23Obc75iPDHfMK/6Ov2r2N9fFBAxrv5R8
	Y+g3ikmeTk+QWR5SWzlW3Tg+spaBDfh1tNWjRE4xFHcMyFMAoXtzgYtPHwHxtPoXo/RRtdZT6lC
	fXV/hRVXqVIJsStWj0BZ2gRMii8iveUkI6B88d9xIpsdhDgyhYcoHxVqBkMd7WuZ6MDb63KPVqP
	HVQbAmYifFNRAoRT5pml38f290/YZWzA5T2Hy5qzMrA==
X-Received: by 2002:ac8:7f11:0:b0:51e:47a4:4851 with SMTP id d75a77b69052e-52fb9374e5bmr185528881cf.8.1788030571449;
        Sat, 29 Aug 2026 12:09:31 -0700 (PDT)
X-Received: by 2002:ac8:7f11:0:b0:51e:47a4:4851 with SMTP id d75a77b69052e-52fb9374e5bmr185528281cf.8.1788030571080;
        Sat, 29 Aug 2026 12:09:31 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b963c3c0asm239150095e9.10.2026.08.29.12.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 12:09:30 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 29 Aug 2026 15:09:03 -0400
Subject: [PATCH v2 4/6] mm/page_io: rename bio_associate_blkg_from_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260829-b4-page_io-folios-v2-4-649728091117@columbia.edu>
References: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
In-Reply-To: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788030553; l=1747;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Y3cEnXs1YeV/0iBoVNSFQ7BAMa/E6hl2fJ5PkOunTBU=;
 b=L1JMeqhEXa1QnFULub28wOv3IoMKc0N4ikuTVAvdru7NNNjwsvKIFrD145lrYhmih84D/rE9Q
 AmolEdBg1uFAlDb+cnyt03B1zl0tirPNUPIqaSWPTeEHIHCEsEq+81o
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX89ACIVMaARNn
 bEF1oOZyww86c5b2zllMmfwxfxgiZ10N+JCxyHaHZ5muKJiu6S7gvAWPASCFIaNh7/sPXb8KuRG
 owu7FaaPb2waFcgxEGs4tEqhsBPsixVnShShkhELy8PyH0ek1b+u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX9eQ8cFC6hWzr
 F+RcvdLrWcS0SEgQ1LkD4dJgTj4puUMql9v4jBjTAACNM8lI4ia4o/7FvSiXl0euoQxrBADQliI
 B5oDI6yRxV76Ef9pPNQ4tI5wabtfgfcE8OnfYbi6U8CYT6gvgyPlGhtHXokao/keQy+sub+bRz9
 RtLFlztGjDqyA7RHCEziPWH+Y6Hf4OA8ieJV54aqR1ZzXHKdPDecEsZWc3IzOUs5xDDbcfs7cp0
 yHCL10kFyKOLOcPaRy6f1iYoSnYdB+7H6StW2O6r6aOVdCW+v6TKmCttNU/bFSIoKQdPMmEbZN6
 koVnyd4uxBBtEacnXiigDGtIWWuMPH2ioMjqmXpQloQ8gAQYp5e7wplAxGoUcmbgOttndLYY1JS
 N5NwT4k7diM7jTcbWf+W4lLKqEKJfFUgMKTpy5NwdHMrITky0oVTUwXWeh59qzPLR2yJAFFpatr
 Bizl5AUz1GngOHTpZDw==
X-Proofpoint-ORIG-GUID: 2ceHCJ2xoS0vYUR4WGyFqCOYwH-tqTAo
X-Authority-Analysis: v=2.4 cv=BoitB4X5 c=1 sm=1 tr=0 ts=6a932e6c cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=ufHFDILaAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=d-08HifAjaWcUkSzOnUA:9
 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22 a=ZmIg1sZ3JBWsdXgziEIF:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: 2ceHCJ2xoS0vYUR4WGyFqCOYwH-tqTAo
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=10 lowpriorityscore=10 priorityscore=1501
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608290165
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A5CF314000E
X-Stat-Signature: 4coixyh95wixmsefy7di6exoy9tsmqxy
X-HE-Tag: 1788030573-208009
X-HE-Meta: U2FsdGVkX1/BCZdjy5d6F28EkMOANCw1GvVb4zZPdqD7IZjjwgEaBZ4A4cZNvBMkvj8jP+UcFCIHaD49STig7XYi2GcWRUl842uiB11ojozoTBtFwUNAQesaEJt4+mQXRHNLgYeJJ9dpNWQBPA3Xg2QyKOtpJEbpv83QYX9ObVVjVnqUWH+5GUByA4ZXXMnCgRSemtQjSgyUYw2TXQUWTEq9jg2vP5E4b5vG5B2Om92siVSlwAyPGBs020XOwGGUPHkl5kxO9RoV7LaLpl2PJw33ttNwnfkeyBGv5sy9QWA/4HRWgjsRIG1fxN1AVYdljYXAcMYwvCiCvERPM6xEgNOSJ3zBaB+ZyHXnBkXG35OdEQEUnLkpKsXouxO5RkuXz02NX7Ee/lRkDNFdiZEgkj/sHzZ0YxL+ayRBtg9tCQ5zmmxhP13T1YFAy10xZXjLRd96FQTflDh+7PxmqVyw1xm0z2EGj876ryRYScrpkpLGR3B/jgUaBNwL5d8tKDtngge3X5/3LOY0rTXtQjkwMwEfAZGstfkSBUGVDVRbKEdS6YyVdIU8DXo61C/BnslxUc/5ed9tNefbnpq0RPomHQCDrzERu60T2zGJKfY8JjFMr7TsVzAnYB8ciqNZL+EMy7KXNv08FtR569eIvs7ygddE4p1rgYST25cmoH0MYt3KrOPgRCESdO/oa/SqCNG4i9uwGmWo4dvOMs8fMWMcrXtUv7fu2US7rpYXYs6Jjvt6hwpXeQT2VjEDJO6UMYlg0jGfkJh8wImO441dip2hn/h7MlPyfZhvXx3/qPKz2sPRm/xZfQnR6V3x2jN3EJbWXBBdKHrC2rfSPUPYNQtuvdYGgbunyMQzxHvDinAej7/0hlMuaEzV9h0vi0uLXVFBqLwuMfrZIDvc8p02R4b2vXg77d6tEo/+j8hSGJ5xezsfO6QU1JALsL8nhWmYscFsieA6BQEbkF+5g3SRk6L
 JKbiWDzj
 sVkcR2sbUmcoyOwxfaN69cKJC+ehwHraIZ8WJsfNZGMQ+sOfzk0Sis/d8VgEdsJBX72MSr1xD+qkKpYxDhBp7A84vVtaoXN4A4FDoNFmA13HFr4tM9aN0eeujVRvtNBZXenAYHcX3ZE5JrF7Us26gmOUMc3fLl5YHfpjE6E8dEarR3yF+J/K3iM5RJnXwGaj4Jp7HAIENQxF2PMBt8ZsVDY6flQtG5xku2R/spzrZ777FxTcmoAS8guPm1A1wBTk9vLXfYeLu6GXVDgDtg/eCMcYfuYYmAz/ki361rQxYrrawyssuBScF5Asx1EVdbIJFrnyVYH5NxcbVlV+cVQo9Pp1kSecUe8a3ypSX9eCV6fcjvCQcCXoHW2rrSzBx1qdCz+HmgJzqVL90ZEEm15nILyilSGy3Py3nDVH147Aud3ucpBUV4mZO941mALb7VRLPJpBUBtbbuojT3ZgijDRKR+rlAQUDwzAfTbIH0I5sBLit26SGpTxdYFJ4By17Pi6axSuzdewEnT3utqKgj5r7f5X8oYb35mH95spvlkCSvCbshOB84cahD1ROHw2Ptm0hnPSl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function takes a folio. Rename it to
bio_associate_blkg_from_folio() accordingly. While at it, convert the
macro in the !CONFIG_MEMCG || !CONFIG_BLK_CGROUP case to a function.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index dd95cdb0cd7a..295cc6ac6244 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -277,7 +277,7 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -298,7 +298,9 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
 {
 	return true;
 }
-#define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
+static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+{
+}
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
 static mempool_t *sio_pool;
@@ -596,7 +598,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
 	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
-	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
+	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		submit_bio_wait(bio);

-- 
2.39.5


