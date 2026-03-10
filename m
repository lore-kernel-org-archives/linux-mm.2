Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24B5FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DCAF6B0096; Tue, 10 Mar 2026 16:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493AD6B009E; Tue, 10 Mar 2026 16:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342426B00AF; Tue, 10 Mar 2026 16:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25AA86B0096
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:20:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0463D1B7686
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:49 +0000 (UTC)
X-FDA: 84531271860.06.29FA06B
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FBA51C0002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=TA9HNEAS;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ApEwdWoR;
	spf=pass (imf21.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jopR4iBKMZiW0WEP0sLMhWOcTp6GXZxGsMBTPgmxLMk=;
	b=nqPIcjFZeIctqOETXD2ElnysG5BG6eCA5TFjch+Eak5ptsRLgPTJadrE9kY7xBoWJM2w+E
	xsxq7fs9Za/aghhmRt6Woj4eBtpjp+puNZNb4MSccDlWBOS2sv0vIb6qaWmI8TB4dk5iIk
	tioIO0SQU6gd2TCaz7p8eS8yyGEC6DQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=TA9HNEAS;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ApEwdWoR;
	spf=pass (imf21.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174047; a=rsa-sha256;
	cv=none;
	b=I3SlLY1ek70lrH7f3i/qQuKDtCs4eyYaXr2MRlGrVsW8teV/bi/WTAIJXytLu7+YKbdkse
	bI1QiB2lq8aB6Ppu8KaE6y9YpBlCYrHkzyr58K6Aqgs3tAFWOMaoQEKY56bJ416DFg/0eF
	hPLY2ljEFGZZBXn0ISDIbpb4DSnxNaE=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AEF0fA1863207
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jopR4iBKMZiW0WEP0sLMhWOcTp6GXZxGsMBTPgmxLMk=; b=TA9HNEAS5Og9Z2Fk
	ReNSVQ1eeRV43iBdF8RJ0o+ZkbZMFzv62RmBioWH2uZQ5SxhGftXd7erjg/h5JUz
	AEIwuvWttlHhFCoDGWWBB4PUnq5fLu8MhbDVUVsO/XLUiPu9a7d9V+HaPKy1nTAX
	BEhwiXcEQwgOVRKwfPNCYi+fogRJxPvYFeibZfpIxiTGfsZUuKho1/ZTQ8Bdq4T5
	OKuwj6BnpDpdAn0jJ6pEcoED8ux8lYBJw+LzCj/cAn6NyA64nF17PjpxxswLXfsH
	AWF80tVORsa7QPW4nJFoM7DzoLE7rCX9L0RIR30iZJg1tfIREX+RwJFHHJoa9Cgo
	hP2gyQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctmw81g10-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:46 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-829c331b4c6so984590b3a.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174046; x=1773778846; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jopR4iBKMZiW0WEP0sLMhWOcTp6GXZxGsMBTPgmxLMk=;
        b=ApEwdWoRY8YZ4clSMb1wjeIECCFL0jruAm8DjE2i6BDURPf5iCCx9vQH8P7VnHuuWl
         UEjIR0IEJxHaPy4io2gOJai6+l1vU8w+pveNZseau7+3vGUVKyr7VVkTipCwRaSZdxni
         meUVZ50EMGfJ83VaCjlUFjW8rUPfsZxwWgq5ledrPxMU86OH9on0z/v9IwdzaBot0uJj
         qEFIj2LBaOoD1AFGKbjwOA0D6YhRv4Hq/S6BORktCappiBxyTs5p9Dqz6xHRfo3ES9xW
         /lWL+MlS4k5sKW/ysPujGI5hUlnNhCtfYQvl3sVIANhP4ynV5UunbIZ62rl+yJoa6XWW
         ccYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174046; x=1773778846;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jopR4iBKMZiW0WEP0sLMhWOcTp6GXZxGsMBTPgmxLMk=;
        b=FZoEt7VV0xmXK9ujgDu0g4l9aH9kkcOayAzkmjGDRyLEar1emOmZ7iotDPv4EQQQUa
         10o6AxLdgTUevWuSk/Dd6WSpktWQRP/u8parIbWDhUydqyWNFt4e0ughS2xlkMj+pNeJ
         c7I8ckC2e2XJ/r0pQ1SZjxIaJxD27WP1/m3EKeOmd+IUMxfjFoZGRk0RzcL+89b7rPxv
         zxaNRt7qHKiGgpiesCVn88UsD4UISviM8Up5TWL+6lum9o8CeTBQ51mxu8bq6SOAwCdn
         T4Q1kkvs2R90HE4/uSy+UNS7+nXwquN2UC1zpcaiX7kYKR7RikFm6QVCpBQBWNr7/rb5
         SFIA==
X-Forwarded-Encrypted: i=1; AJvYcCVPBE5Qu+7r4zQ8jvOa6BIEYO+QXLs3IyaYHnrx9nReB99OuupIy9kRjJnFP7ALua5UQJLnjs+luw==@kvack.org
X-Gm-Message-State: AOJu0YwtwXSedA/iYLRYbDhYlcd3K+paYq2qTkjWuInQGAvX/iZmukQG
	06cI0dlJ68CFDtOIx/JQ+gn8To5DfkXy6nYup9i7zLCKX2Bl9TGBAY/IzsqzXAKStfuMMkM93Zp
	A3FusxfVGlwBvkNQPPgu/rM7qUj7Pcvc/oR7J7v26uBrQ5H+iorPz6w==
X-Gm-Gg: ATEYQzzA1orSxEGiDsCIb3yG4ArHAQ7xL/opmBOhmwc7Sz6jrxkp3d3HicMp4urFufA
	5V2xcBU2tWkci4LFlRYj6E9fahlULPzHy65eFZO0qgXX9lJuf2lF3Jc08AiQcBR+kyaK9YkabR+
	m5IQoLynXpsPqKrYH7aoetivWS48qQ1XR1ZkwA//yRU/Kwn5/6gt0BQTdSZYr0gYxrYB8u6AG7E
	FK1jp+4WN+uQeVxQpZigQ/Z54MJeLpeCUzcxE3hNhcQq3v26Q0YNaiLozlxgrFrP6YitDi+st99
	Q0e/XlXX16qnDsn+pFERRGKDWPkJgGcReQ4pB/2Bh/z7KEJWPeuLDN6dcXJg8/R9PKMeN6gSeEQ
	Fw7gFxk8Ckoq5uIuTdpVyj0cPe9IeHfwKq23yXsjdeXsC90hX
X-Received: by 2002:a05:6a00:a245:b0:829:7a62:5f with SMTP id d2e1a72fcca58-829f70729eamr159356b3a.9.1773174045410;
        Tue, 10 Mar 2026 13:20:45 -0700 (PDT)
X-Received: by 2002:a05:6a00:a245:b0:829:7a62:5f with SMTP id d2e1a72fcca58-829f70729eamr159313b3a.9.1773174044746;
        Tue, 10 Mar 2026 13:20:44 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:20:44 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:02 +0530
Subject: [PATCH v2 18/25] mm/numa: Register node data information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-18-f91cedc6f99e@oss.qualcomm.com>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
In-Reply-To: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <eugen.hristev@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1043;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=6Bj6mC+a6VBQpII15E95Sp6w7GOQTay+uqnC/6WwCwU=;
 b=sVE7UB8h95VErsPUO4HLhhiTiKsqQAwG/9Ded5XkdsuZg+zS19SjzGCGHXAkoG9YisCapzqnx
 q5gzTZGzf7tAtbmkLgYEPHDDptUq+d/dYvl4noJdNZrSjHyxzW3MTLb
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-ORIG-GUID: htrumAL9GkdT44BHKz8-DmV0hGt-sKXE
X-Proofpoint-GUID: htrumAL9GkdT44BHKz8-DmV0hGt-sKXE
X-Authority-Analysis: v=2.4 cv=PJECOPqC c=1 sm=1 tr=0 ts=69b07d1e cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=nLJQaZXserL0MincpKQA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX/reuHaQPs9FO
 imdK74RoacJN1bdRBcHPqbRAwD2zQWwmqcab2aoUcVZZ4AMk+zDMiiMllxVi++WbRsLBM+/xvEQ
 VKPDecadzgGPHtTrLYl1QUnWT09+fFto74bAgqMiCgVz7NvF2G9v4XsG7NDNJ9wfmiweOpnu7AS
 g3fb8no08kmHvVxOALOJ2s1NXYEr2NtXhCePQ0UZezMsxecnL6EdTzj6fZ8p03QGDYbVmkBzAB7
 Xvw6U8PzZ634xnRZQKm3VmpIRVXGsmQAw9ZpniwVg6arbeGUuzbfjTdCDM7wF9dLS8yVmKqLbUd
 0VrOnkNUb1eWdBre76Gc36Jb8a2ubtMhTHrIxyzhlYKr7LWLAWyTM99SXiWtccYFyAaxRWBTRYv
 4Gn0WLLd29/skVfpxuP3vxfMYpeRQGNQyKklQpZLMKJVUhY6Mnc+wvrTbG4rGxYSetaOt1UGVeA
 Q3HvGd5B0AGwbRl18Fg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Stat-Signature: z9hsptfxdbitogq55t1d9cq7kenf4an8
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FBA51C0002
X-HE-Tag: 1773174047-307136
X-HE-Meta: U2FsdGVkX18rUk0kWsECKLw+0Mfl92a3dkw+8roY7hf1eyJd0S5/H6I4X7EbHUWRpJrVXAnQRn1rs5PpeYUtpL7DCh0e80kF3uuOKyVCp7J3c/dvRzMAOAg8T8Kq5lcxVAZfNLnFTj5hjJ3ZakRrSPShUdG1xrLx3BS5krBiVuSzk+GXzhWPYzDBedGDee2lRw8r/TlFh+fLqpQpVgAlo4UexMXLKkaPbGVdRpBowaDZ+wbUJMSJ0/2k7TcRkMcB4QvSp6e9DPt032iZm/6Gc8C65ti/33TU2IYBEPs2xenClpU7HwdmaIi2ssRWwcIe+c2zru+YBTRfFElovByT7yV6UDKWxAhZE3NVsvouscCIhCPZ74+BOnm/ETr+nXLL4dcAFbfZERrcRheTVXaxYYfYi6NJN2YOsac99h9pUEXfXHmcRHeUM8Gy9xeTqIqN1B5apFZH6mDToAiANS6HK9waK+Ibmr7d44ucGajp7bVfasgNTX3cAMDeZz/DioWZSDQ72Dg+H2qcu4AR5Rp3Ju6Fd1h8KSoMF10DP5amNk7im4E5TMw55MQoMmsc1fku/lz4gFROarw4xFzVQGUHwRPg5WmLn+0NazSlxfbL7T3EQJPK8mFQp/PDX3nk4qG54f43oB2ufs4s3BhumI6kBhttxR6GOYCOkW8eGK5IyRWKFmUcGqZnNe/k0AYkK8qIZOfCotlFeHryb7bfc0ql9SQDkd7D0dwzN8l0UMiYNDRJKIGureYgL4BqJC/iUxyxHV7WW3ZPFhjUKXkqATSZ33CJah4KLVcPIwcYzB7CgRrWEZlwi7rAJQUtH5NnK6+/pWuFApmBlzYiJkkizMysI24YMEmTpbqfK9XRVJURRNDndQmTZzDKVwb7M3QXFi9lu9PqmEPbYCVy7i16jKRK9J4oGeEZmTCxM7Zmicuum6fP6Nyy3u7tHVyZ1n3y+NU1REnREp2wnK307u7kLkn
 ihSXbTb3
 BQWoWngw28iL+FGuOIjFqCF+pMLJ8TPUML4jhiZLO7fqhcZFL0ZLcM3Pi/MbwDoFjvotqITcjcdaf6W26krmzaDLIH2pOrvqxH8cpBb8z4tVb3qFijODlrMdF4fpEAJOfERJ+dUcJIesiZPz9FR+1H6ByxYU+140SGhff5T3Q9PqDF8nDVBNuByVehodTZfdslg2a3Om/SPxhDHxE+P/iCK2+Je7EY9y/PiIkoFyqr1Cxz1Vl+k9u5ZhngVOYaMRonBx0mOIlkm0F5k3fw5/MpkB51wuhSv9s5Ru76Hh3gmluMKNlEvyFT73Vu4xOKVacZhC6PAanRc+5vLWDVxWDfY78hH7m8ajnOlicu6Ty2Pu21mJSapuheI6NsWdUj6CxuWFtYpQJD2xMzSW8+XpqVvifBuQtxV7LVjj6DkaZC5oSiGj3Bt2+BjosbvhXxQfTVQw0MVateOVzVmIUBpwMTBWszcWi1jfHM+hqV1slsz4AnGrXhc5Q5ulZyZj3XqJMsDVpY1YMmXqNzYSJdRQl87jNlDYK5DKGJpNyZgOyFN6qmTSWddTMvjOVplFvGTF5hsQUqbvrrl99KHMdEOUtsfcCvnhrWfdWF4rr+V5J9J08N/cjDig+W3hP9s6cJic85S/olNzSA9MpZN+pBoh7u3s4iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register dynamic information into meminspect for debugging:
 - dynamic node data for each node

Use meminspect_register_pa() to collect node data into meminspect.

Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/numa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/numa.c b/mm/numa.c
index 7d5e06fe5bd4..fcf31bf2c552 100644
--- a/mm/numa.c
+++ b/mm/numa.c
@@ -4,6 +4,7 @@
 #include <linux/printk.h>
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
+#include <linux/meminspect.h>
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
@@ -20,6 +21,7 @@ void __init alloc_node_data(int nid)
 	if (!nd_pa)
 		panic("Cannot allocate %zu bytes for node %d data\n",
 		      nd_size, nid);
+	meminspect_register_pa(nd_pa, nd_size);
 
 	/* report and initialize */
 	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,

-- 
2.50.1


