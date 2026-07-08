Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E0A7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4208B6B00A1; Wed,  8 Jul 2026 01:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1116B00A3; Wed,  8 Jul 2026 01:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299D16B00A4; Wed,  8 Jul 2026 01:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE69F6B00A1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:34:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A7E51691AF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:34:38 +0000 (UTC)
X-FDA: 84964494636.16.E858637
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id EBD31C0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:34:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=EqtfYnE9;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=N5PrsAU3;
	spf=pass (imf22.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488876;
	b=XpfU95m7lUvVXmU15nJPwMHgcTh9x/utJcHXwcsRs5dsNOryucprvQhLR293786LytV4Wr
	r+NABK7hWWyx3cqbRZh1gBxUPHEexdNNMpaHsdP+zieCl0fzyB95SFaU3xlrsdqIel5O1s
	akvxeu6L+ja0BTiD7PhLrMGzSSRgKlE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=EqtfYnE9;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=N5PrsAU3;
	spf=pass (imf22.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCieFDn9o1/mTKBwZokgs/AnxZFC6Cu9M4cCeHRgDUo=;
	b=8bc4Pfamo+/82VRswVlHIKMvImjyGLCm7T7+VUIN6s0/XBl1PDWNzOQjsdo+7Ffu0A4Fj+
	o3TMryJRT0gVv+2KS3tclzM/1qOAHiO4SQycG7R7vAEFKWK9d20X4YMV3Q9t01GmyCdyRt
	kyqEHYPMm8RaNcoaTvBmk9pmgsZOlmg=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842Qmw1638132
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xCieFDn9o1/mTKBwZokgs/AnxZFC6Cu9M4cCeHRgDUo=; b=EqtfYnE9jR6VGU4L
	YvdI2c1EaI3rL4BCZXWS7Zo3iHKZIqpJQoNZfsSUxo6NEe8oRbLa5EMTeaRu4voU
	IY1pIizZJPRrLq/hLiu165f0oCyIxIZz4PmDh1RLDU+G31ae54kVZkpL8H9dzi7N
	qUxd9tE6S2sdcUCXsus076nYopGmu0k//mgdILW/Cbpyv0LiKG7ZXO054xRQwWgE
	QO+w2lP8mecmRm+/MjbG17xHONiDgyJ+CAdJSi0hv8CtmtfEuTh370P5IgAuM46F
	h8tCLgRzunwaNw28X3j1P2+8NJGdqyibeRrhaGsHbkAMaogF5HGPvQrCQ9/IHRh8
	USIY6w==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9c6a8xqf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:34:35 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-848452dd146so761024b3a.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488874; x=1784093674; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xCieFDn9o1/mTKBwZokgs/AnxZFC6Cu9M4cCeHRgDUo=;
        b=N5PrsAU3E60mKpmCKhsGfZFAe5BIt4jeapQynkzv70azEhe9O39mraZOHKnsi4mLNF
         elsRbGPtZD9qUr8+AT+6ByM495MI1fiwtE3lsfB/OZR0R4hmYLTTaSD8juUSZD2o5sHZ
         R/WMH8j36qgygtXLYa2+dNnfYAoTHGisS7TNKC+QYOmw0Z3iaW1K+d97qTAVWayLs39Q
         21FBgjsG4rcSlrnHjUxoCK0XGvOxXhyIkzpWTYRQKRjdTUMvOb0bMLir1+7i5PFNqwAN
         IFV25GlH61SMP/UMDb5vFrmKKiTs2dcwp8IYO9xX3A6eTPTknPRwqBrcrAo/KHiNi/yx
         ae2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488874; x=1784093674;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xCieFDn9o1/mTKBwZokgs/AnxZFC6Cu9M4cCeHRgDUo=;
        b=lDTQvAC9chv6VL0eFhyyE4q8QVgzKav0MlikPfax26xCj5NraOX7bVEZMS5E2LTU+J
         1xh3tbOxsUXDIP0jOkbvoJ08bh6PsrZMAN4LdNNPcXYaTqAAlyoGBpi4b+Qy/8INT8z7
         6j/IClSQuhKMxluZSwO2kYld0faYuxnzr91u3cNFAOJzslYX5uIsfg6CDv94jZgdBu0O
         wcoNAVA7vwGBzmHuK7naPmpB0uhYl4gWaLnI3yMRlKBBZA9/C91a91A3mNkdiIDi6JxO
         EDOhMsiwg8LEOske1Ff6snOgULav4OlOOEUyyuL8o+f7YQKs/YSM14H5v8JdZH5tXd7W
         LVww==
X-Forwarded-Encrypted: i=1; AHgh+RrkkyrjIzwMv+GjZasCXjppBRsH5buJVnYNk625oCkmrqrnQt16ydPxm/QlUvIN+X4vghViOAtEtA==@kvack.org
X-Gm-Message-State: AOJu0YzZSTLkDAXFoTR8m0sB+EAAaZkGQAJ5MfbgRuF1Z1FvHxwIOJ5s
	f8IeTU1esnF9j/NUfT0TTuESZxaxTWnKABCzhDUYD4j06LZYjF90b+BO6tReVitFaGV1OLycM2w
	f7l0QW8i8kBgh4HHYcYi9iYpTVeYLhp5MRLC21MI3ZExILG6Q87ccAw==
X-Gm-Gg: AfdE7cmIwuesi1aKq1Hc241Mr2nWLLt7OKpBVDbtARmxGxgPOehsHZvZpV8ivMxfzC7
	rrJHpvzOtRrKUmfsv3cml4UrDZt2xsvuglymm8aGxgQ+NXgah0MTT9l2M2XChnNt9ZS3DyrY7bb
	UTeFfrioFxyn3t+88q+kgQw6llVy0+e0ITAUX8w1cC1y7Y80deSuSw/vyALnCcM13KzfHx71Q5P
	+LV9Jo+Kx9WNOhBCDu2bV/fwoxgcZuo8+blS8UsY2B5mpqOAAGnDzyA0Q7fZPyzWTI0BteUFIVz
	P7DRGRAGS2fW4+CFF613EK3jFDtH+GX39NSkmLMvk+xTGqR3ckR3GRtvdFXq33dz4QCyzfGLkow
	IeYbnc7ejH0u9gZCCqQxJUI8dljqmRDXV4fDgcQ==
X-Received: by 2002:a05:6a00:c8c:b0:847:902a:57b5 with SMTP id d2e1a72fcca58-84843675521mr1352951b3a.35.1783488873940;
        Tue, 07 Jul 2026 22:34:33 -0700 (PDT)
X-Received: by 2002:a05:6a00:c8c:b0:847:902a:57b5 with SMTP id d2e1a72fcca58-84843675521mr1352904b3a.35.1783488873305;
        Tue, 07 Jul 2026 22:34:33 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:34:33 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:48 +0530
Subject: [PATCH v3 09/26] mm/page_alloc: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-9-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=944;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=L6c+15QWfJQlsN7pofG7oj9ERof+W0cwt812FgtujDc=;
 b=l1lEkLsA4P0Av7A6H60+TWCYPTjtTVceVA79u4NAHGXJ0OzlnegIIncayRRiyD3tgW/XBu0j3
 S5WBgcBHx3qDeX1/wpk1pjLIXGINMHFVPzaNC/c9Fa6/35YeFUeYUZv
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX08EX3UXaqcrB
 jkBfg7X08XPAOYtKb0LKOhEvL5eSokFgXVzbwBGij55t0npCFXT4FAJCmaPFVsRJdDq83dNGwXJ
 6uhqI8CyhKkhxtt9hE35XPy4kKO+JAHd7qiYVbt2RDWuL2+taHn6EQj5XI79nTHZfsT0+hT7K6Z
 yjJk9WWes4tUp4MfexFDqH02EO9PEw5QTEDsGockfk4SBpHUKK1P1UvRW4nTAv/6ZVqpzGMl579
 fFjQ1EAkbtBmX+4nyWRjtQhbyQ7LGj9dzj/R/K5MrwHYRaYmKs2pN9c85g+HDVLJaBDUDQcgZsR
 UYbZvQxVh5F9SBOc2jr1uMElbnkECFJkkgQhrEvQNmI0Z+iaZNQSiYyItLzelcY91p9BitWTCMb
 DWNA6VOSawXhbszvzz2uW4pEkMEDKWBrlyu9rLjG4YQBCoIV/fGYC5vXV28UyOwk6PDdDtZn1zQ
 YmWCmQLTzViQ4mADZGA==
X-Proofpoint-ORIG-GUID: fL5DclR0r9UNe4hh5G41QoVCpVAgD-ci
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX7Tsi/x+zVGlX
 jMqwewNt2i1QCBqxgQ++JKOfoczDxaX896djtY89t4GZ3pCK5Dje70W+WaHLAPq3ey3OR/cqvTd
 3cMjKAImbzbgiZIigXNib6jZxsneZtA=
X-Authority-Analysis: v=2.4 cv=UehhjqSN c=1 sm=1 tr=0 ts=6a4de16b cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=TiJDLkziv7N9Y1Svq3wA:9
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: fL5DclR0r9UNe4hh5G41QoVCpVAgD-ci
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBD31C0004
X-Stat-Signature: 8eesbwfz1t69rutmxxszw9ryohh8di8j
X-HE-Tag: 1783488875-886690
X-HE-Meta: U2FsdGVkX18/GdfZcxxahbR1tsZRZ8q6qcsT1/LXx+vLL7nIrjXuHu9uAvNW78DqVp4XJEYyev9l3okrLjPQwe5BT+gSXt6yZkTqmjmHG4Wj2klDyns+IjPFM7KinqP8/+WR1WIKN/qX0xq+Hg0OHWZkkNh7d9L6qNaW5QHT8SKPjhqpN+VndFy2Je5ZLfTwPmEt24dM+st4SC6hBWeYJ0a3WirdXwpvlUmUl6D+H5HIYBHxkkVof2EVjmK0ZjAhUEqa5bPhqUiZ2E8J/tipFnAfpJXBk6URe7MQWdF/Fjl5i/qDXKh3AASWzXtOBUN8OCW53NOpUlmWME6mx3Cbb37DOiEPdFcQgxck5iUIHHa0wg4yCQMhZfNN1ECK3mq/HrV/A9e47GpLJsfigNBmiZ/7CEbYJ/W9chZBzRo7JF71dvUNGDITG18bycIYkeHoCijEV87odWV3R3xRXHrZAzJ3Ps59ueK9QreFh1vd4PvLK1T2f5pM4tgmESAjNafxl4Y1AuU8usqUCgPb5WXqb/0tRFSagYsoYlVHHiYCw+W/8qlflKvuy2bhpHeJrrIPk77nEOdeDICVdT8KzmBU833YYjvrMFU0ih3fveetaOZko2HA/XnFBgQXwLvwL5Nh96lKzElXzHUKUDB+r6a4kpfKEzNm8jdJJCuF5oElP3g+cuPvggMEOSwspgksKdn+aTv7edCcD+BSHBWSmGY1EG118T6O7BTh/SyG3qFgme/Bmxg29wIH5f2kSd2mCdsNZdhBNxPEbmS7GZCRb7bzFEPQ8shyjuQNtnWpJrVwqq6ioCWE74FIhcIWIXYQTnfC2rEpKG6MLW/KZfwsD+hBwjqx5MFhLrQdWxk/1cxoezCsRNHHo+iZ9gWWPIMautCysUey7KvQpXlpPr0IxtYP0CWxK8iLWPbEuHZeWAcnMUpX9/SN+qwYQewLeLjwf87jAyQvhtyQWhbn+f+xe2g
 zaPo0FpI
 PizL8x5SK4A+O0mqmEpghKJC5HIYxJRLJlfKnqTHAuJ3F3FbP1BFD/ITHLzWUwbNtSmHiSUC+jFR8PeMgQ0vUTwEBsAFHZy1YW2lz7D0LTo7CTpasz6GQlOe36/QRQUGZllQ306urLFSji0cDPO9gX2yK4Lsvi8N06GB2qxImrXR0dkF3yQDhTwtzfltxr//TiNG71AFPbAH0lFc3hN0lZAhbzr3hDJgljIisQc21YkXfgviU1+7zvC+LzN1XrJud9CT1xVcQvwc1GJYpdx3UkEFGnLT+eZ/2SJe9cJ059nJTIk2Yj9FgPW3nL03KRBN6PWvmpTedvLtSK4cFv/XRWANf2vsQRSxsO4HEJ+uCFA/HL+XWsavU06La1budvbNvvC7jqBquegO1FTmydMyHqnwSzNCLEgW6PLzyVyS1bX1rJBQwoEI5yz+p67VTcNCWWiMfUMJpdAidHqmk+Sp6hViCP0dNcoCN29BHErFr2bZVDYBO5u+5E13UvpCNc7zM2kql+H26QzBRUpCMk9XfptFHjxoLTUHx/+w4aRSm6SZYNywwx+aKvbmT2kIaWelGUnrddB8PbKPYfa5oldr/24z6io5N6C/qGQal2/A7aIKhlH/kGF2TzhIifEjr87ornINkYuYdrumCqzTVW0UCflnDup8NorCeyiaMbNbsSocQnL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into inspection table:
 - node_states

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a63733dac659..70c5e0794efa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -54,6 +54,7 @@
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/meminspect.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "page_alloc.h"
@@ -204,6 +205,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 #endif	/* NUMA */
 };
 EXPORT_SYMBOL(node_states);
+MEMINSPECT_SIMPLE_ENTRY(node_states);
 
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 

-- 
2.53.0


