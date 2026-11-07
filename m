Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46B5606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nop8ZZz5;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VkJbFzsR
Received: by kanga.kvack.org (Postfix)
	id D5F5B6B05CE; Fri,  6 Nov 2026 21:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10826B05CF; Fri,  6 Nov 2026 21:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27566B05D0; Fri,  6 Nov 2026 21:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 872B56B05CE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:40:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1160116027A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:37 +0000 (UTC)
X-FDA: 85406769714.23.20EFA19
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id B18F11C0005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=nop8ZZz5;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VkJbFzsR;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com;
	spf=pass (imf18.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794019234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GIOH+/c8ZlwAH4hdy3vTg9Fnv+nr6QlL6HrUi9JjUI=;
	b=I/5MIn9guPdf6JZQ6BEbrnB299IRy4fxBoVDEBryWQBpfNUygkSPhDk2NR8ze8ZvRjngqD
	Jbaqzq3m9mz6agoo6EGUFezy41ElYLTbaqudi4jUXNouWmNIbuEFsuo728IW8H3QBI3EwF
	2f6F7kcMUZmVuzsusE98BrdaXWlPoCg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=nop8ZZz5;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VkJbFzsR;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com;
	spf=pass (imf18.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794019234;
	b=sqyFlhS0mZQGFPeE9+ZPaM2BPcSB/5+dme8+RvYv5CpufcpBOFXcFAVs2tTWeTbUZ6db5x
	3TIBZNdocV6fl6l1eZ/V6srJBgWRJhvcgGLlWCOdWRWr5Mr2uMvTk+1IEM6JhtYCSjoFYa
	z0GCQRDKCEx6Mkz4A0/wJHeqg7lGksM=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A72B3W41521200
	for <linux-mm@kvack.org>; Sat, 7 Nov 2026 02:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=3GIOH+/c8Zl
	wAH4hdy3vTg9Fnv+nr6QlL6HrUi9JjUI=; b=nop8ZZz50KWkS8urDJT3hxpTV4k
	BAEPCnNgvlCV5nW/ALTCX9VJTey5w3I10a/mjLDouG3WOysCbGYEzn7gNFkNg8M/
	nzpOsFkzTU0Z/dY4mPagcZ7QvQcIjZqzc44YLqeoKSxhr7/j/HR9z2FI+0DuoyDV
	i1bCmfL8UTAFZpvehzU413xo0+FAgXLAC7BKlCtlyydehZhLOkP/Qs49TEO2o2Rm
	Tt6kwxWKzdvHE5kMzJ0E0bXvcpYIna7EiRYtn8YmVfbrX5esD/ex4wFvDxncrpOF
	kmJbd5Xw6pX9NV4pmdQJWV8D0BfLJPqH+N0rZNvJ+7Dyq9HYKMns1MG1JZg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hssbnr9hj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:40:33 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36fa5673fccso2876057eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794019233; x=1794624033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3GIOH+/c8ZlwAH4hdy3vTg9Fnv+nr6QlL6HrUi9JjUI=;
        b=VkJbFzsRkkJQs2RzbLnDLuu2NoDDMtC1Ys6PYSiAA+a1arNJKQzXISoOj/UrQJ6CFs
         bwjEPL1TX48jk5qqnyzzm3Y+AEuZdTQGCqinuiY5E2AYcTR80NzFmU4vNx7SX5BGc6Ql
         EMmsER64zN1Uaco7ojSy7gYl0a2PPwDjkZS7rVuOA5DoRcqJjLylu8KVnVIdtTvJ6o/o
         ASihZvEfpJ7ai3tg1M5QAEA/pLIaPJ2PEyu4j1d9ojMU1MZnsxoaSrIj9BVEGWD6PuiJ
         SdUZgiBqqn/9QDwXkmQ7rzEdCbwIWTNzD4RiEsZPy0McjXk4IjbGzM9i6H0hcdFNEJYV
         dNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794019233; x=1794624033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3GIOH+/c8ZlwAH4hdy3vTg9Fnv+nr6QlL6HrUi9JjUI=;
        b=YHUDv+Mp4LXosG35SghB4UnAxjfV8KKcnRFZqs0AfgXN3WCYpoGlAm8kFQfVHe+EaQ
         CBSgBsPBbe5YK8AxiXS8Cvy970kr6POeWlKXb4m26KNMN/+dQd5G3Ja1SE84ypgw1GTw
         WJmty//ktUhNCPcqaVag81CA3alrXMq2rHLLuRgNXNW3SpFP1JhmXl9EBUIfyFFajf9w
         +FuJWILbr3nGh537TbIewxtTU32Q+828bovV4PM/fVutA1ZXppp8DLRDEu0o1ANqOP9C
         buFIJUhVDxauvalGskG/YGbTvHfAsnlpgyDQXHdB6Zk66dZZNX9HbIa/iQlCFMikXhxY
         5QZg==
X-Forwarded-Encrypted: i=1; AL+hErEEUW7VteMaqnyJnm/hd06Be187xjhOonKi7ZF5Ud7nQtyqvAn4tckb+9lOeplKEykoF6v7UqQX+Q==@kvack.org
X-Gm-Message-State: APuU4Z8/wIHIvBJ4t5W9t2oRM8kU18LWWZlFDtLajJHk1iIwBGhw8kab
	RWLmzP+ErQPdQT81JXZd/gUTQJn0HVCY51lwbdtOseAR/dDdtKC4o+66+5JaE/Jn/lDdjjtY4uU
	dnudagt2J6/tov2NstpPar7QQ3t1lKyfcaqzyEvL+cpmOSOkpVtUJiw==
X-Gm-Gg: AYBFou2DgyMRJeAUy48PhdEhApWlL+/iIhisidKasnvkeo/OR0iJhymQvMRRsGcfr/f
	XQazYxfzHLC3h2+5TBUqs7fOu+QHBYIYCPZ3PSpZ5KN2wobh7eM+jgH++GEumuHOTi1s8J0cLhF
	E/EuOvgimqgUda/Brn0iLjpq7qpqONOBws79LasIDI8D9SPSQ/7IkKJp9ROXuMaKo8n5QPPbxIP
	NMGxPUaWHNW5CbCTjoBj+LcsP9K0B1lfV1xbj/D6nVAbcNev3ECQbMHaxCZKafxHwGfBkkc+zRk
	gw5a8cZ7gAA/JAD9C095ftOQi+0mYLcwNBLmui5ATLXAns0hGiJIvn6ICYHqueJDVZhhN0jfM0c
	c8hx3McH20m03UU8M7eY3LoMMQRgrxzbelaXTDWHq1esvWfZ0kYiC/lpPqucGcjZ1t+z3EpCy5S
	TKZXQkfMUZMlxbHtC9PKFD3PmPZW27uCMiIpnJRoy1ix/UytTz35pSvZqGaLCBPHxYV700L9hKR
	Q==
X-Received: by 2002:a05:7301:d805:b0:362:fa87:2aa6 with SMTP id 5a478bee46e88-36f6fc79169mr4866640eec.0.1794019232687;
        Fri, 06 Nov 2026 18:40:32 -0800 (PST)
X-Received: by 2002:a05:7301:d805:b0:362:fa87:2aa6 with SMTP id 5a478bee46e88-36f6fc79169mr4866588eec.0.1794019232016;
        Fri, 06 Nov 2026 18:40:32 -0800 (PST)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faac86a96sm11069040eec.29.2026.11.06.18.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 18:40:31 -0800 (PST)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org
Cc: Alexandre Ghiti <alex@ghiti.fr>, Jesse Taube <jtaubepe@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v8 8/8] perf tests: keep bp_signal memory accesses visible
Date: Sat,  7 Nov 2026 08:09:17 +0530
Message-ID: <20261107023917.40606-9-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Yru_zqj1xJqCLJ1ew4P9T7amey0QPtt_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX6N4i5EbsPQnH
 LFTTtW5P7b8GW4DGNO9miK672Bq6tFXPs459DxMS6rVeAqqRMz/WemNfmAvljBXicUf9/8W/GTu
 veKeC4wXTduubbVYv8qArCLSSp9SYljKeFEu78fG2BsbMZ7xwkuaW/LWn3eXYsGfboU7UEfsXgm
 nDYr6FjhfJPWi3Rc+4P62oWSko+ei+wEWh4HkyDXJd1li0jTc5sBwooYKZ29vSkrHiRYj7mbPzM
 BKNLsTJTPVJAv4CGyTXU1XWC/pDvbaiio+hoOKQonMGYJvuJND0F6btw6epZiQpga+3mLakEWcd
 SWbRnHp8P26CJISp11diOLfjqabyv8tSoZ5PT6AjDKayBsrugjELu6NvCKpfMSvAjThV8h3me4w
 Zn4slEw1ZicRikKpZJ3JIsbAJrUtt3Vxpn6GmA8d+JWGhphOPnUy8XyC1Qti+/62IWckO5vJ1/b
 kFYqjG79b3YWcI+Morg==
X-Proofpoint-ORIG-GUID: Yru_zqj1xJqCLJ1ew4P9T7amey0QPtt_
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX3SaV8aUYeZds
 uAVBl7K+bpSCPB1a+NORX++MGYN7CRb4kPdpTvH+q/QJ/e6BjJXkhhmXvI2ly9ae7UEk17Iez9+
 hS1SuGzSqHvA3KPcku/qLGeEWpI2bI4=
X-Authority-Analysis: v=2.4 cv=JtBkP84C c=1 sm=1 tr=0 ts=6aee8fa1 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=tsqkxpHE8OKeFbBeJjEA:9 a=O8hF6Hzn-FEA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_01,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070010
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B18F11C0005
X-Stat-Signature: oxfj3yd4nsnrccjdcuxgk5kpxqn77r7t
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794019234-905114
X-HE-Meta: U2FsdGVkX18WRz7xnOvmglMOxzQ3uow0ONLh+mntP21ZOu+0lSAJ/oCNnUNylE/HiuTFDrxh8w2SAcnfs7O7K39DqRGilA4gLJgOSZ2XYLc+LngY9F6AHHPzAwcemmVvxNj4VU48iFamUObu4CKIME3qsxFRvHWa+E2laSyMgfgngeLl/zpo/NkjgkYMemVJOLFXD6jOaz4XQqAxGtYEdKRZqZ/Xw70o10wkrdTx70CG1yQe7BgYzRavtnR3LpIupC1DcM/LQCD6MKmnaRZomtvl2KupOQIFCBoz6HF09LDZeKSZBubk97a0Zo/zbf113IS3cOIi5JpKjpjoASPZcdY+/V0QEo/zxUD8CAjG+EHNQo4vdJxngvcjOuEffiXGydxAShavmrjHP7GvPuWvjPW6M64HrPuCOgoTv/+6Wp7XokzIRI02xpHpt++0TX1lPNSgAgaD3t93evL493w3n5KFwcQDSoBIbuFja2KsnTDeqEAq2uA1EfIl5aFOwoh2sREte6QjwvfPNGyrqGf4czpA6zmzhqAlEn+F0saiU8rfbZ85D8aqRRuEOaHyofPHJNRzaNnuvvY4mV2GQOmiTqTT4DrcuRYhsDVTXRPd+YPa3MwQeOB7C43KckBwCKTX34Y6lql3NWVTnsKv1sMdPmz2CY61BbUnn5X0xZ48NXNaRa9pUfHS9ihobUFWqnC+pKjVgy/YnlGlROZQcsaayGCkXiyEI5icuF9LIvBDIdFe5ymTDCl48wf1qxWeNbCOEFQ1JnQvCM52zhXFtzHWxRedMzmzwRfOLShOMJhfwQwrxrJLaUvLQkoleN0CFqw506RgNl+dgpGRbRpxgyK0XZOOmIUbnCHD1Bp1b3HMpe8PyeC3S2Pm/Fa6aeyWbk5oznjAk0VwMBHHBO9QK80lgRUBo8IzQ0xnun4qxNDti50I+dmeFrWflP9R7/k5LJTH6TqCTyLTiYGvdCcDv9M
 Z3QwZiE7
 ZRIZ0Qbkq8Khel9A0Qwd/JeElesahX/Oext/NniVthSzyl13JvtimrkP96bGxH1z3U2Q83TvW1yJudHWi3YVFwm3ptJGCGCjclf6JyPZBFjBEgcWi5NbT9IB34RCdvmgTPTwF+AMeeln0Qo6g0t4ZyNLS++4AnSViakggknxv/jNI/Lg8zrNzyWzNZIQvHNQMm2J98lz3mUPZBqSGeRueNLKW8yTXg6WeZ5BpL3hC//F3nXRBxUDZNNVVzFiAufmcAHwnkfv+7kIfhiv8y67HIM82P0q9ttNh+p5O+ee5+sbNeKKQken4lzCMr1qzd9LJOPOz1IM3hGk9eRq8D6HEPYSFi5jBvjenYecX61ak5+CZwnDTEHnuQ/CqtIsq4rKn0G6xTMqFjwGw9jt6PVnowmcL2eeFRJaayNMel4xgb+PMl73EqHKCcDXZP3zMHHcWXOm2Piu5adDoLFtQRpcPdP2XvxzRQXS8c+XYiy0NN/WEZyYwfx37+ZPNHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In the breakpoint signal handler test, a breakpoint is set on
__test_function. Keep that helper as a real call target so the breakpoint
has a stable address.

The test also relies on the watched variable being accessed as distinct
memory operations. Use READ_ONCE() and WRITE_ONCE() for those accesses
instead of making the object volatile, so the source marks the exact
operations that must be preserved.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 tools/perf/tests/bp_signal.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index f580ba7486b1..2e4f7747d32f 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -36,15 +36,14 @@ static int fd3;
 static int overflows;
 static int overflows_2;
 
-static volatile long the_var;
-
+static long the_var;
 
 /*
  * Use ASM to ensure watchpoint and breakpoint can be triggered
  * at one instruction.
  */
 #if defined (__x86_64__)
-extern void __test_function(volatile long *ptr);
+extern void __test_function(long *ptr);
 asm (
 	".pushsection .text;"
 	".globl __test_function\n"
@@ -54,16 +53,19 @@ asm (
 	"ret\n"
 	".popsection\n");
 #else
-static void __test_function(volatile long *ptr)
+static noinline void __test_function(long *ptr)
 {
-	*ptr = 0x1234;
+	WRITE_ONCE(*ptr, 0x1234);
 }
 #endif
 
 static noinline int test_function(void)
 {
+	long value;
+
 	__test_function(&the_var);
-	the_var++;
+	value = READ_ONCE(the_var);
+	WRITE_ONCE(the_var, value + 1);
 	return time(NULL);
 }
 
-- 
2.43.0


