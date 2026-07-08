Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26288C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2320C6B00B5; Wed,  8 Jul 2026 01:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2030F6B00B7; Wed,  8 Jul 2026 01:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F46D6B00B8; Wed,  8 Jul 2026 01:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF4446B00B5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:37:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EBDD1691B1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:37:33 +0000 (UTC)
X-FDA: 84964501986.16.03EEA5B
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id E0CA540002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:37:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="AdtinD8/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=SgfxVm4U;
	spf=pass (imf04.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783489050;
	b=qssTJVTwBHX78LY1OiPPs4faLMXjpl+/vvK5ro7leCljacJ7z5IxjmE0i1BY0N35DeVbKn
	KENAlcEqb13+XuWqbA8RMqNRPXfaMjjQ4aeOlwQb5iLUN/+WekbQbLpuDGGE+BKkKEUohZ
	zKGLFY9UnCPIaUNj9fsQYacpXTQ212M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="AdtinD8/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=SgfxVm4U;
	spf=pass (imf04.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783489050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJX87HCSkcJTd7kTCA0/nQnGj2UQmcItMQaaFDWfyJQ=;
	b=zl0L+gDnZudmSzh9dML7FmHdxFv/3ore/3l9fISYlCiSzQ8pw0/oPoQGLFNGrDX4w79nKw
	qYS/wyuBt57I3tb/1bswSvzm3ArLTXdvX5XIWWPpHuZJuvpuhJSixx0qTutK6qw3B4gRf+
	dUi/sLqNcnOJ44PMOcMQzxna9fXSKZs=
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842h5e1625072
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gJX87HCSkcJTd7kTCA0/nQnGj2UQmcItMQaaFDWfyJQ=; b=AdtinD8/0bXvXerl
	YGn9KFl1bhMFe7gFO40JI6emTQXt75jSzn3nNrvl0JmjJ3Zxkf4b1fHFs8XJQ/KP
	SuoEKr0GElrjwf9A5KnphGI9waiQ9ZXSYZtfPAcuieqU3uf4vDgo94J+yJNGog7V
	1ltSTfSimVja2g1NCoktksfzXephR8poFoa12l2OImMD+AL63cypVkPikhF/wWrP
	tLKVRLhiaL2iPiXMOIor9/P81WaxfLfGOZiHYrLSZcOVjJpC7V2qjroL5umYsIer
	xxE9u1/PPa+CRwLa16hm2Wk7yv56mjJAToKaPXm/FDYCW+3OOC2SY0/NBI8vkja3
	TIMlwQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f95fd2tyu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:37:30 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-845df469a26so910127b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783489049; x=1784093849; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gJX87HCSkcJTd7kTCA0/nQnGj2UQmcItMQaaFDWfyJQ=;
        b=SgfxVm4USq1hoqURAgKtNAXiNiQdwEq+tK5JW8MbxiWJBLYH8WORqEwRFhhOa7cetm
         SbatpO62l3AVqMAYgAF+2O34b6dMKxs07jmndqCejDyjJtJG41r/ZI5SXFpkKXrQVwFG
         Rdb5gvN/obbHTo4EBbzQcHtH1/ob1usqhklNSGrwgB6eJ96DKxkYqeJW0sPlpL9Dy4yT
         v5aYqCVMixwxhsIwQ4quzkXq7rCXVpwph275CNFtBYZZ7MqFw8RPkzhyjXly3F0Qowlh
         VyAUHsAUlqwcSfPjMCmLSMK8XHDez9ZS7w7XO3rdmRNzKVGueUBALARbVzkeRZ11cwZ2
         J9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783489049; x=1784093849;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gJX87HCSkcJTd7kTCA0/nQnGj2UQmcItMQaaFDWfyJQ=;
        b=M+7zNVEZpdf3cpytrhzXi/zG6pYwIkoxMkNs37/irS7bQ/bsFqbWJqojQnUskS+vwK
         3bIAO1g4ZSqshdXpZoP7wrZRERVa6Cwut8QxQo+dbyl9moTnO7gXNnIrvAgHnm7UcTUf
         dXOBtVYpGQ3TsWRoQCtAeTAN72Dkj9xuhhpQTJ0ZavFhQzHRsWQppg3RWwU2JOZmb6u7
         04GB64H98jtQbUM3HrUSkNBOOKGrC4kORqLipHjaIAy4grVj3ad1QOF8RKlK/u+PtyNr
         KoVWGoImvkAQm22LaWf2MT9UUUhQZoM+G0YSqtwFL5pqXJn+9er7meI3UfEDHV3nUY1X
         QxZw==
X-Forwarded-Encrypted: i=1; AHgh+Roqdu8tlCX6JYwiM5bCDs3QX0+dLrrZsxuXUuF6yLQ0OYqCSLXmX24YbM+cWW/K4UAT4t7d+hG+Dw==@kvack.org
X-Gm-Message-State: AOJu0YwvOHR50E/2J6joCDwznzXnW2QEqEauLKOW3Ej+3kt67xqweIMb
	7feRfllPNZLTmgbCr3K6Z539rVogN5u6+lqsXtBZ5eK4DYsKBHMa23Kp64owst4g+KEqsyrq8ax
	+d8g4wY+CuurbYeL6K/QE5tUVBZCgH8475pUYJf3y09fCjdGHhSvUVw==
X-Gm-Gg: AfdE7clD3iXhljWBu+LSWn605DB2Mq94n/TgRFnnUOiDR3au6zZefCDURTjWF2gajFp
	6iObuh4CLpHmN2ogjJY3b708d3bebJZKPK3p1ip4B7R5XGP7GtWR62nwQt2yx0uzIPPmAbN22wc
	tmmTIYOqj8BqVCuHC8uJWFwfBh8+RMZu7ut3fNUq/H3sptORfSY1+vgTL7ZlkoihBpW7KKHyof8
	0ug7jDLcKT70FJgv0QcTrh6clyFZZQFwE76NellGauBItsHJY9Cz8ZR2FFpN3Wsb23m/SRB6YJQ
	Q2k35miiA7rSdeYi6aD67/KeQBZ+Yb0g0N6MgQZbWTAIFhffXLjCzjyWU7dPVjR91Q70ahrRsKD
	dQtH3+W5o0YR/GaTLXsVI9XR+qIAjxAw+F58swg==
X-Received: by 2002:a05:6a00:2193:b0:848:2f77:e2e1 with SMTP id d2e1a72fcca58-848439317abmr1120463b3a.74.1783489048640;
        Tue, 07 Jul 2026 22:37:28 -0700 (PDT)
X-Received: by 2002:a05:6a00:2193:b0:848:2f77:e2e1 with SMTP id d2e1a72fcca58-848439317abmr1120395b3a.74.1783489047954;
        Tue, 07 Jul 2026 22:37:27 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:37:27 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:59 +0530
Subject: [PATCH v3 20/26] mm/sparse: Register information into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-20-7aa5a0a74d5c@oss.qualcomm.com>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
In-Reply-To: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <ehristev@kernel.org>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
        Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        Eugen Hristev <ehristev@kernel.org>
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1429;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=a//aHjAOCZdOEDNOGwW7cj8bqxjleSnaH73aGg5zKnY=;
 b=29tpun/9WI36+AbZk5KGoVhyWBxd6E9AyE00Qj9B9ayJultsqHtisEukCmg+Pc6yavSnSZJB8
 fznsdxO6dZmDcdPiYEDbgHtL5VgKNvVrVXBP/v99PFh6GVWx+oNIDcS
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfXwrUaaeUfngVz
 Qfupfo/5y8h36tBJkOz5dHIRxqSOURpTwd4wl6SvraNS3+XoVk2/nzw3wNby8UeTAr8QE0OUYeO
 fvPAeoIy6EMjuHzfc6MSqKkdHrm82I7QQogfYtaZGb205H9EOSk4Z7hbtVd02jbDrxDcphRanaH
 pNKTLRb5AhOhvEQUxS78b4JDwkrzuT2O42pcUyNgrIJt2sjvJP1/YC5G+oBgrVWmOHcIW1TZE3q
 4vzu+7lV9cLdQ3BWFgOW8h0XynkgcC9CXZJGUGkJhS4+cO/Hc/oATb0oYdyAsyfnqKjg5o6U52J
 9YdGuY2WXsV70nazN9ZhzKvgyJMVrX7qrTsxLZM6cGTBBOoIQ7rjcV75TrXS3dRN3H4p2F7ZQjE
 cH88G2DUySmj5gLd2lOoo7ipvFeY7gDgzTsWI3IajBFUo234q3bYV+JZjyHuFIf2Z+o9GLEOAeQ
 IZrZLF3rUV7Na+5Oj/g==
X-Authority-Analysis: v=2.4 cv=VZLH+lp9 c=1 sm=1 tr=0 ts=6a4de21a cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=hPKMzws2jpgYMEASFUsA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: BEnXJX5CDR9jXTUyOcjs2r4Yo9n8PoiO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX+C+BJ+lDOPYM
 H6t/37MOYhQHdl460L9CUohKRYGCs7+UYRzfi4O14zzP1iFGR1LN4uJ0iX5taPi6Z+36SEqc+y+
 4RVcPhp5DRoESBi+tub/g3MNL3OVN0g=
X-Proofpoint-GUID: BEnXJX5CDR9jXTUyOcjs2r4Yo9n8PoiO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 adultscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0CA540002
X-Stat-Signature: e99b5ceg83ywjw87cxgg7oudtabgmxih
X-HE-Tag: 1783489050-171129
X-HE-Meta: U2FsdGVkX1+kxGUYK1Y/rpyD7GJ/sIH4tCgp/AsEsPCbwv3bJvK2WRbk2sNxPmqU9wPY8AyCX8U7yBpG8+pX4ah303ONSUQglq4a8gZC50B9DE3eQrC5dBI+GqDWoOJpXE9/6mHnRaAh1v20exGEcBwKa2ngPdRpBi/uSH+e1HnNITCnrNmTjlioGywKPoKM2YmeRHDusYO5p8qBYQNpjaIIt1Ab4XGksHqYioH5NBSBrC4uQXAgJlXJNzm3EX9XL9k9qOgEHVnjrVBN9ncUzHtFPL2Mg9jdn/smhVsIby/BUddow1tVbtjyKadP4T1DXWccdqKeH5jF+ItwTnhrpvcMeoNxHcCm4tebI8mIcQ1bb9+GUnqPZFmx6tvUwr4DnvPuMEJxiHwmAwNawEmaGNuGIfzcfHKak30xYGs/FQpl6GxnjrcsDhuFvMIIKkBtvqlhAuXVpusr3WUUeeFVaV9dmJdII/rFSLS+cOterlEaiwhpOX/RNaLBI2f7AyaDy2AXrbDHyQ8PElMYLZm9MVRMNTHP6M6FiFKXbCv+QJnfHUWX0FYRRWPcQKSZS1t62nLZ/DUH8QTWP1LhCSI5QFPOv2Xpa7UmddPb3G2ga2j8f9GSTwTfwLWEaEK7HIIc9MtPYHTfGI2t4PrEuERsc8CdVQefrJZm1WgfGLCIymOFSJgkMYiKNTqyy47nhWe3mu+C6p68dK9bEUCXmrpV39DgFzu3z5GQS+eoiDrPn9xBNYes+tkGEWroOuJ8TJFlLvVVmJZDCGsqPQLEqqqNZALUgaf+5ese64My9sTUDjgqVPGhEnMIQpEQsinJ1RS4mJUCJKusIBQwjtgiqjE9q3IKEdBitz3Hc1ExzbkSdBgIbOKGwVlT+V6g/yp9x6cPASUzo1Qhn+isT6OxJOU68DKWD1R5ziWb2GJ8vXfrGaewAJlV/58+Zol2PrHQZOT+1JD0NB1aeLj42wRs79a
 cmVJzTNR
 PP/Uq76SyXwScUBo/ywoAt4vUJkIEF0NRo4vXIfIxGSUAHEsCxZygazSgVKzMZeTd2OscF2JfT84yOm1eGzjhoNxK5YcB4+OzuAeKkjoB1mhhHLpsYVRMzbh104QlkQ5zx1zBp1JHAVyRkBuow+ciPnY0OoILu120VI1q/TTuFlaVT0fc574pRK8C2iGPfVqx3oPTFcSGyd7zsVeX6eRzlMLy+1poxodskHLG5F1zc3nsXClB2tWQ7scGo8vbYMNzLA+kRrZeTevvV8tdtn7akF1z46LxDZrqFZ7A9aTWC0xzyVCIGNDFw/2/Fy+YjI0O7WdZREM4wm2sp44PDOQZ8okMzM2vCWohY0lqrL5MwKyRChsgXHhAm2ID9tzoVXHGl4344I3W8+Luvjsf1dZflcRT33kNW3Zn1SflTqEV9ZGLW00IWLPXahV5FQoxxlZYft3SZSBNADlaId0QUMbWlj0dfCt7azauTH2qK31pukaXeRGx0mJ9G43E5lu0+HPHO9aeOcHdOFebY2lZJXjf+gdTQWQFdfr35itwdnnk60DjBSOutmwBTd/8H5qYX7ZrjJo9vP2hvrBz1bkQynFdTfBWDRL45UzvLqNQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static, dynamic information into meminspect for
debugging:
 - mem_section (static)
 - section (dynamic)

meminspect uses a different API to annotate variables for inspection,
and information about these variables is stored in the inspection table.

Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/sparse.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index 058ef9300367..9e890fb6c43e 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -15,6 +15,7 @@
 #include <linux/swapops.h>
 #include <linux/bootmem_info.h>
 #include <linux/vmstat.h>
+#include <linux/meminspect.h>
 #include "internal.h"
 #include <asm/dma.h>
 
@@ -30,6 +31,7 @@ struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT]
 	____cacheline_internodealigned_in_smp;
 #endif
 EXPORT_SYMBOL(mem_section);
+MEMINSPECT_SIMPLE_ENTRY(mem_section);
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
 /*
@@ -206,6 +208,7 @@ static void __init memblocks_present(void)
 	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
 	align = 1 << (INTERNODE_CACHE_SHIFT);
 	mem_section = memblock_alloc_or_panic(size, align);
+	meminspect_lock_register_va(mem_section, size);
 #endif
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)

-- 
2.53.0


