Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86256CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 12:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DEAA6B0088; Thu, 21 May 2026 08:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78F756B008A; Thu, 21 May 2026 08:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656DF6B008C; Thu, 21 May 2026 08:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 527286B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:20:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E47321611FE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:20:25 +0000 (UTC)
X-FDA: 84791334810.04.DEC72E4
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 727211C0015
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:20:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ImEv4Ai5;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Cmb0cC5G;
	spf=pass (imf20.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779366023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TwK02OO4K1epQED36FGkSoJT4inoRnIOR99uClBefzI=;
	b=iQnV8O5d25uOecSwrfNu1jWUz/0o4Wmx8cH7mohvW1NrEy5ikPrJCrQm+Zy753x7gk4Tx4
	oK3NJxEXBhmXcOhbNHeRBc/cjv0PO3u/E+mL5vwqKxEaLUMe/aSe4y25xjwwCU81ib0gLE
	Zyg+O8ehsBTxkJm6qnAgMyUj2/ZATMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779366023; a=rsa-sha256;
	cv=none;
	b=xPbtoIc2dDXIdRyT/5u4iRwPJEodT8wzMFhCISrH/+b1DsemBUd4w71GflDcau9+o1uYg8
	bnUOtuBtmsAYINAQuMjKr0nM56/+G/UPFOePS8KEm8UU6B+tIJySFIgKLDcVDIj58/8Yy9
	Qjz897JsC/sqoi5QpCIUp71iuAD9gjA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ImEv4Ai5;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Cmb0cC5G;
	spf=pass (imf20.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L99x4L2632726
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TwK02OO4K1epQED36FGkSoJT4inoRnIOR99uClBefzI=; b=ImEv4Ai599CkKWct
	28BA/t+9vRGd5MBP7ry2a53XDrFhmSAHGsRtyliCdQ5YKRfW1Bh1Gxns0N4G6ssK
	HQET9yhe8qDT6Jy2C/JFNNPd/qE2aWrX3PEyGEQTTy8vHmvk76zfeWM7feJ3k5ga
	RGKcE1FLRVm9bx55awCHNyRoLTicBQBYgsRo/1etey2TNkPVJX243Z6+PVqx5brP
	qKocHiZtcdEL3XAQOUeWmmkrh8DCY2g2e844j7AFlirWv67+T15Vb3eu1Sc1fg/0
	zZ9MMzUelSnBhh/QDqO992G3e4SyivLJq4ojL6/eu2cafltwEvyb+EILUw2EmW1J
	zYPTCw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e9ee8cxmm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:20:21 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c827adbf00cso2728768a12.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 05:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779366021; x=1779970821; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TwK02OO4K1epQED36FGkSoJT4inoRnIOR99uClBefzI=;
        b=Cmb0cC5GKGcufuyHBFXzJOx848fjpX/9L22ADFi71KlC89CKhOA092PLySUzdWQU82
         x8gdytY4SH0RXFpQ4p7Z+n2FNlBKRM5Q4nQ5YIvLILYdMcn8DH2rrGVYE69J106GWOXL
         sKZlzXdDkfSldXOa7173E+wNk1icM4iYvhBagbX1eGsG9rIUI5ObvMRcM7ocNfhxH1f/
         U0gtluB9XbVAPZoehKbBGTMFBSLzhep5iLjUGWhD6nkX8qxRCnYvJEPOnmq5iOOHgzGs
         hlNsFTVOA3bz/LU01+H7C8upXzjd/URJdaTtbVYkYu1KwgSpttXidBm0qdMyyyqh/P9A
         kYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779366021; x=1779970821;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TwK02OO4K1epQED36FGkSoJT4inoRnIOR99uClBefzI=;
        b=tZJ2GQJ45ku5qq1lpyqZ0B8T1PCdjC9ZQSn7zJ3AP1VisLa7W7FT9DH7jjOU5FZNr8
         T/2QGz7peXBpNI9SC/FO9SR2Nc6roXltIUUmUuzsd/U/VDfCax6xGkjNy4A+0urCKnYN
         ZwisrE9th31d7kHkAQplCIEzQfmHNVq+xyZQnM0b2Tfc34bZFrEZar2jNGywS1nEHgn3
         C8FQ6A8CHW0Z/Wc9YkqhoJAlnQ7uzprrP5RCBF/TnwwJpe+jBh1KxwGIXTiQpvc2TsG2
         JueNLoJkhu0ufRKEKpM2ZTDlbHxFoy7KeIbrMJWSx39dncuhMBbTeoRSrA+SKz5/qDDE
         CZBA==
X-Forwarded-Encrypted: i=1; AFNElJ+CWY1+1gXnMDvaiD1icsDbbJ56Qhn0L7yYUEpw9UqCUmHXkGYq1o3BfiJg8Noq7pDfb3I45K9z/g==@kvack.org
X-Gm-Message-State: AOJu0YyL1hGP8bobP+hctDQOoKVQ6lCdONnAPc0WJY8fdcD6oXM+VRpW
	Ec3Uzp3IQFIazusZ4CbwC2U54OQPgnRLP+1ZpKmLv59lFpC2O44dRI0oJTbnHmP1RHYA2XI7Xst
	DpzhLd10Gnu/U1PnxihYUTqNi3jhXVBUZkM/2EadCdtpLa0QbFVyWwA==
X-Gm-Gg: Acq92OE81f2E8rwABaDg2kKM5c1wY34HCftS9t+4oV4jypDpa6LmJW6n/0MNxMAxMon
	GkmCIlo/RcfsXbQ1Y9hUhhzHqqaJRne1rkAjv8OiuHA13vrXXQtdQgerAEhCngrW5kjNxnbgsB0
	Ql0xO0yWtc5J/Qus7HzlXwEgNwBmMZIGaKO1dNbkaYmc3VOEPApUB13Kilv9kFIDi4GPhLLaj/4
	UeCD0KL1ARpbXjshHYsNeqr9g36rq0LnAlye5A2/mO1jj4dm1XJi7bH/ActPbcimwqe//aLM4ue
	9Gv92eHbwI2GNaT9cwV/D8Ds0ZSnHVSfgrIhU0blDAVmRBh7QRyEeXFlCukoAbw4nOPNQXfQnHZ
	u2aJdTrVyRwfDfrjtQlRkEa6hTWOOJr25IKBKmUNDuoQp16CXailH4IQNVvM=
X-Received: by 2002:a05:6a20:9183:b0:398:6bb5:54c4 with SMTP id adf61e73a8af0-3b30854e9c4mr3264433637.5.1779366020837;
        Thu, 21 May 2026 05:20:20 -0700 (PDT)
X-Received: by 2002:a05:6a20:9183:b0:398:6bb5:54c4 with SMTP id adf61e73a8af0-3b30854e9c4mr3264348637.5.1779366020198;
        Thu, 21 May 2026 05:20:20 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c851980bcdcsm240706a12.14.2026.05.21.05.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 05:20:19 -0700 (PDT)
Date: Thu, 21 May 2026 17:50:02 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
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
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>, workflows@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 00/25] Introduce meminspect
Message-ID: <20260521122002.etqupwnjv67didat@hu-mojha-hyd.qualcomm.com>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <abdnp90cC5PI9wyz@baldur>
 <20260316181647.m7x4ncmwdjho6yvr@hu-mojha-hyd.qualcomm.com>
 <abtlUQqMOxj5PwGB@baldur>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abtlUQqMOxj5PwGB@baldur>
X-Proofpoint-ORIG-GUID: wrRb3T8LcqWFmX9JUhnO1RIyefKtaEhJ
X-Authority-Analysis: v=2.4 cv=e5k2j6p/ c=1 sm=1 tr=0 ts=6a0ef885 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=NEAV23lmAAAA:8 a=mDV3o1hIAAAA:8 a=0QWIX89dG7aUu2ROjmkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDEyMyBTYWx0ZWRfX+ODinOpYuJx6
 kNAnq190GgA9kUmsOLrb6A1bAYPbvOcariSPSupkCJP0PNgXA06SgxD/jLic1trIFRaoSS0E+xy
 J75n6bAYXkm9ADGDDYTDEPI74UCITxSfqhL0A12UBs8vxS6F8eAxMBQ459SDLcda4kKeIvO/F7Z
 hFpjkdxQoSuZOEFo4X686Pod93sStqzPuATa+vfyeesyPmlIHpD+mig8XPikva/TmGMMv4JG9q9
 /+HvgHOiLX8bFnnEcBQa0FzBRtQeqOvRlC5BxyS9BcJeNAiF2veh2VVx04/OBAM5KyYKSivEEUG
 cjT4D3uW3shgVBtst4YRnaye4FQZ6p9L4Qsds9t+RgrILNUwjLu6vg422rSzuAhXYPyP+wkuxVD
 EHUBDAOPRyfAiQYddkIFVztkNp8N/I5vgCSgK7v33+QGK508tcMkIDQSU7kWEA1U+fJHtIXj2/6
 A6Osc/6s9QzurIIz2QQ==
X-Proofpoint-GUID: wrRb3T8LcqWFmX9JUhnO1RIyefKtaEhJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210123
X-Rspam-User: 
X-Rspamd-Queue-Id: 727211C0015
X-Stat-Signature: 8k5pcg7s3umo1kc86sxsizdx11bisu8x
X-Rspamd-Server: rspam06
X-HE-Tag: 1779366023-630813
X-HE-Meta: U2FsdGVkX19dUP7YZj8Qc3hOf42GMk0sSpPKtHsaR6ygSgakzJ0YRsnQCyz9xuZPPXn6TevjMr/8ALetMyz2C9mnzKTzdZP5MtbfPjFRdRlE6NaOEy2pkEZQ0dUqG4lT6gNuEhnZ9CeVggl2siTWdTjpRZAXiBb4zoS5OnaoccyXRuKp0TN7dVX3VGrZLAKPszjKvaUyQ8oR8Uc8teDpxwtzIimHGX5/zy/4Saz2Iozuaat8UoXO3/ruUGKaPlUo7Xh/RnoaMwRHUZuGMuH8JNeLTBoBiOLMcLQHSL2QrcAlADfz+DmBab7t3IXtKN7hI0s9HUzRNjaKBVaa+zAHGjbVk10EeTBr03nZytUQ5SqqIj6g8Cjh7wD/dZ5wvI+8eRTfjjDroaOH3OprWe5tgNlWOg02H7+ANWho0c5qwiK1SJLuYR+VETgiCFv3yG49MaRddxEhYAgsm6aQXJ1p5Xc/mLyzJeRk+1hyzCKozSnvxSQUU/5DJrUeyiIkT5zHijB722ko8qTflQk8I69mzIrAvFUmhRAu725CbR2Cw7ZAMvPCN9XwriQxgy2d2qlHhZOAmhmspPy0BPo/9mqWjGn0Bp8aKqFX3FxOD4XCM1PK0D5g9ydasgcwDAa3dHPnBTCOhg1BF+X4DNL1WDLyWb8PgSEzExPXpjaPSIjvy+/r4izfU0Ug0M7A2eKtzeBzSmWJgq3c5nS0Ft5KbN6n1VphGOxxSsQIEMYtKR7t/Dzvn+87d/IXifkY2qzkHLzEoZrqnne0Db0tHj3JCEMy35DFj0S9SharU6+kjS2Ox5gMSQTy/gcKk7vS+vFOk46Z8Cyimup621/tcNoSv0fX/a9M4plBiUImnMOzZ61SRNZfn8p5+P9oKe1USXDEEzUf1X4/nXMjDKw56hPYhvDaMkNC+phKYzCmkAfWbogU0lRQOON3jyL5V4fH0hJPS2PlkU0Awn/BJDVr+cp26kk
 EdXsXF54
 hiKwW8j5AHpUBTPCmfUAXubvW69fA63zX9diGNZfoiTtuK2VBfnXeyQ/gOXKftpVKGOrpk0pHTvVjVFeJsgHQiqFbGdBS15ef/qdklnJ+TvnE+bEogAWTANgddC+8ZUFJ6SsGGXNKHvw0fPQmhrZvwsREjEMOw3pAh2bmkF2AKrDINZDuvj3ZXgAG+KywonyF/EWv7fT1PtWPHpUbBYyIwgCX8Fq+lQqzJ2Lsh5SdT2u5clA1czrKk6gYAyp4kXICYFHeVhn//nqXNq1svkwT/taUCJr5kvShA0XMKBahEZCSq/dV+fGa9DqtiSuY+NCqFS9BfcKBxSFPr6oa8aAh88IURAjiZD24i0Vat69wVTcDBPGdpcaa2ACQtiFFMBZVcHA9O2kkdD9gZnjAThytkMbRr08HnsA5U1g2Nld+juAE4hFRNKOsMU8hGttHxHVzmQP3QiFy7cFmzw93K/5O011jh9ydZNj+Pa9n+Fe5D9vEUct1VSUSYLryRsIumIqv7Ax2CZTd1lxf0n/Bj31aWDyAKMSKSvsLNor3UF4Aq5LslQj4O4ACiLqMpCxtqLLfJin/7Ih1e1MTI1/aPivNTHwyZ2tVcPlYa4lQdl3kEoJsVqoH2IFYc+LvWCeFWt3wAGkB4SZ0YM3vrzTu9Nb5MGhIC1V7cnyWuPmAg5w0LfKDnfYVWscyT/xUnLm5Kfb62D/7oHNDSW0mL9h+k/y6+r2liA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 09:55:29PM -0500, Bjorn Andersson wrote:
> On Mon, Mar 16, 2026 at 11:46:47PM +0530, Mukesh Ojha wrote:
> > On Sun, Mar 15, 2026 at 09:24:39PM -0500, Bjorn Andersson wrote:
> > > On Wed, Mar 11, 2026 at 01:45:44AM +0530, Mukesh Ojha wrote:
> [..]
> > > >, to get all the regions as
> > > > separate files.  The tool from the host computer will list the regions
> > > > in the order they were downloaded.
> > > > 
> > > > Once you have all the files simply use `cat` to put them all together,
> > > > in the order of the indexes.  For my kernel config and setup, here is my
> > > > cat command : (you can use a script or something, I haven't done that so
> > > > far):
> > > 
> > > So these need to be sorted in numerical order, by that number at the end
> > > of the file name?
> > > 
> > > Do you manually punch these in? How do we make this user friendly?
> > 
> > Yes, manually.. but I think we can do better. We could make
> > this more user‑friendly by using the section header and string table in
> > the md_KELF binary both of which existed in the earlier implementation.
> > Then, we can write an upstream‑friendly script that reads this KELF
> > metadata file, checks whether a binary with the registered name is
> > present, and stitches everything together to form a complete ELF that
> > the crash tool can consume.  Let me know if you have any suggestion..
> > 
> 
> Can we somehow identify that these regions belong to the minidump and
> teach QDL to build the ELF for us?

Raised PR for the QDL https://github.com/linux-msm/qdl/pull/243 which
does not use numerating order and we can completely drop.

With that PR, QDL will be generating minidump.elf .

And I checked the latest crash tool with no extra patching and just the
--minimal option (as we do not have everything in the minidump) and just
dmesg.


$ ./crash  --minimal minidump/vmlinux ./minidump/minidump.elf

crash 9.0.2++
Copyright (C) 2002-2026  Red Hat, Inc.
Copyright (C) 2004, 2005, 2006, 2010  IBM Corporation
Copyright (C) 1999-2006  Hewlett-Packard Co
Copyright (C) 2005, 2006, 2011, 2012  Fujitsu Limited
Copyright (C) 2006, 2007  VA Linux Systems Japan K.K.
Copyright (C) 2005, 2011, 2020-2024  NEC Corporation
Copyright (C) 1999, 2002, 2007  Silicon Graphics, Inc.
Copyright (C) 1999, 2000, 2001, 2002  Mission Critical Linux, Inc.
Copyright (C) 2015, 2021  VMware, Inc.
This program is free software, covered by the GNU General Public License,
and you are welcome to change it and/or distribute copies of it under
certain conditions.  Enter "help copying" to see the conditions.
This program has absolutely no warranty.  Enter "help warranty" for details.

GNU gdb (GDB) 16.2
Copyright (C) 2024 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "--host=x86_64-pc-linux-gnu --target=aarch64-elf-linux".
Type "show configuration" for configuration details.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...

NOTE: minimal mode commands: log, dis, rd, sym, eval, set, extend and exit

crash> log
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x512f0030]
[    0.000000] Linux version 7.1.0-rc2-next-20260504-00228-g2595b97d6061 (@f134cd6ce783) (aarch64-linux-gnu-gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, GNU ld (GNU Binutils for Ubuntu) 2.42) #11 SMP PREEMPT Fri May 15 09:34:41 UTC 2026
[    0.000000] KASLR disabled on command line
[    0.000000] random: crng init done
[    0.000000] Machine model: Qualcomm Technologies, Inc. XXXX
[    0.000000] earlycon: qcom_geni0 at MMIO 0x0000000000a9c000 (options '')
[    0.000000] printk: legacy bootconsole [qcom_geni0] enabled
[    0.000000] efi: UEFI not found.
...
..


[   48.488296] sysrq: Trigger a crash
[   48.492004] Kernel panic - not syncing: sysrq triggered crash
[   48.497944] CPU: 3 UID: 0 PID: 363 Comm: sh Tainted: G        W           7.1.0-rc2-next-20260504-00228-g2595b97d6061 #11 PREEMPT
[   48.510055] Tainted: [W]=WARN
[   48.513140] Hardware name: Qualcomm Technologies, Inc. XXXX
[   48.519699] Call trace:
[   48.522276]  show_stack+0x18/0x24 (C)
[   48.526089]  dump_stack_lvl+0x34/0x8c
[   48.529903]  dump_stack+0x18/0x24
[   48.533366]  vpanic+0x47c/0x4dc
[   48.536646]  do_panic_on_target_cpu+0x0/0x1c
[   48.541078]  sysrq_reset_seq_param_set+0x0/0x94
[   48.545788]  __handle_sysrq+0xd4/0x1b8
[   48.549679]  write_sysrq_trigger+0xc0/0xd0
[   48.553930]  proc_reg_write+0x9c/0xf0
[   48.557737]  vfs_write+0xd4/0x358
[   48.561187]  ksys_write+0x6c/0x104
[   48.564724]  __arm64_sys_write+0x1c/0x28
[   48.568809]  invoke_syscall+0x54/0x10c
[   48.572704]  el0_svc_common.constprop.0+0xc0/0xe0
[   48.577578]  do_el0_svc+0x1c/0x28
[   48.581025]  el0_svc+0x38/0x138
[   48.584317]  el0t_64_sync_handler+0xa0/0xe4
[   48.588660]  el0t_64_sync+0x198/0x19c
[   48.592474] SMP: stopping secondary CPUs
[   48.796761] Kernel Offset: disabled
[   48.806510] Memory Limit: none
crash>

-- 
-Mukesh Ojha

