Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9106F54ACF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DCE16B008A; Tue, 24 Mar 2026 11:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D956B008C; Tue, 24 Mar 2026 11:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054E46B0092; Tue, 24 Mar 2026 11:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E44E16B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:18:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 844A41396A7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:18:07 +0000 (UTC)
X-FDA: 84581312214.06.29DB291
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1321218000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:18:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pCU6nPgn;
	spf=pass (imf24.hostedemail.com: domain of sshegde@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sshegde@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774365485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3OTHytKuvDipWBXDZMqSX0aVAx6IXCWrgqyxj3ydJo=;
	b=TOaJom3MwRu0h3SYupdnuIeJI30TkjxNQtSScGIqurEng3h56/bCXscFguIKMNjESCJWfI
	lsxzwNExaMltJ3v+gm6rh1QfxIIkEoew0Sb7GXRfUFrC249dVzdzdvOQlogupBrBPfs7T8
	IOWaE7vRSdZbFeGAml83qr3HHY+ChE0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pCU6nPgn;
	spf=pass (imf24.hostedemail.com: domain of sshegde@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sshegde@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774365485; a=rsa-sha256;
	cv=none;
	b=8KVfgfi5m4T69R0yg2i+/8HcAuANtboUfLO6K/oklub2XAOrfp8gl+nnNjjaHWxMxy2xRR
	lMzLx10Qw8rURsXDeI4EHkgu60cmjob1MT9nvlKstMa5bkgMvCTQ9wy2R5G39/yxGL8rgf
	WEr0RPksAbNcFiBXnnLPIbGvu6Vepxk=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62OEYcxo3559585;
	Tue, 24 Mar 2026 15:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=f3OTHy
	tKuvDipWBXDZMqSX0aVAx6IXCWrgqyxj3ydJo=; b=pCU6nPgnPlEai+yNjr4vqO
	izYJD65R8Yqnm4MgZ1jIT/vQufPVK3JtvxDqH1+RbAewNouplF3WlXdDVgsgBgBy
	weTYwAATWc89XVyCT9N8OJe7pr6u+k5yXuOpMq3eoFiblRBsEV4Eqvo7l2Wa+Hoy
	fS7Bwstm68yMsNas/9DFT3RInBms7BLLT4mHe8Q9cA3MxMs+yK7SOAE1amiOdVOp
	NFKjYjuXT8AnnH0mnnk48nIJCla3yF1ab1Buk0YOzAAuDRyKAWc7bqW1nkV0p0xl
	+mWwnKq/o51ydaSKJRw8Ka9Btszj4N5VteYqkNnCy7smzRqrU+urNe+vlcBZEnag
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ktuukrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 15:17:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62OCXkw8026797;
	Tue, 24 Mar 2026 15:17:36 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d275ktcxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 15:17:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62OFHYFE30540408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 15:17:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C23152005A;
	Tue, 24 Mar 2026 15:17:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 41AB82004B;
	Tue, 24 Mar 2026 15:17:27 +0000 (GMT)
Received: from [9.39.25.102] (unknown [9.39.25.102])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Mar 2026 15:17:27 +0000 (GMT)
Message-ID: <c72fa095-654c-42c6-9e5b-1459b1b7e732@linux.ibm.com>
Date: Tue, 24 Mar 2026 20:47:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v8 05/10] sched/isolation: Mark
 housekeeping_overridden key as __ro_after_init
To: Valentin Schneider <vschneid@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Jason Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett
 <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>, Han Shen <shenhan@google.com>,
        Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Tomas Glozar <tglozar@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Daniel Wagner <dwagner@suse.de>,
        Petr Tesarik <ptesarik@suse.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
 <20260324094801.3092968-6-vschneid@redhat.com>
From: Shrikanth Hegde <sshegde@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20260324094801.3092968-6-vschneid@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: lh1l74MIxKV7Fg_fwq_BieQeDYV6h-gv
X-Authority-Analysis: v=2.4 cv=aMr9aL9m c=1 sm=1 tr=0 ts=69c2ab12 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=20KFwNOVAAAA:8
 a=7_2Gcuf7Guj4Ce4GsV0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDExOSBTYWx0ZWRfX1/ZffR5oMZ7x
 a32Hf/e+ABZBoL23PyRlPV/2b7h7Kc39ci3+3xosDrv48bm5ihck6SH2fd7JTy/wf7M4ucdS0PZ
 ekCKE/Inl+Z1wcta4U5JVFl7ZcoKPDeMub0yPBBqyDVMmjOtsjWbStRjqct4/TYeNUDgm26kHri
 ToburL5ciKtQge7yPQidqSJlpRSNbt6z6zHbK/lhgvpnxCzSQRkgq81WuZws61MJy8u7JtBo5Zm
 HmLpep3RfRR8yLIORnyLfw9+DnIj7NB8xkdeHhJ7ZQOyuHCsrSSZv2e+HHsU+cHvC5vlHqH8MP9
 Qn0CThDarfzCNoiv0cY00YTb4wqF3OFn5uOxn1CdviXff6iYKIvCeLOz5J84FwRYyspK4zC45/j
 zExG2xX5Dd8v+fidhbt8YJKOD3kld8LVCmH7OhZrg3MDB3ozFdy1Oj1199ySD/vNyrhKn4QeEVQ
 t39FmEiG6w/+gsu9gZw==
X-Proofpoint-GUID: fs3pHPZOFeMxFT6VksEiHD_LbNcsVRBv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_03,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240119
X-Rspam-User: 
X-Stat-Signature: hwwkty5xjfahdcrj59fz7wroixzryaqy
X-Rspamd-Queue-Id: 1321218000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774365484-370146
X-HE-Meta: U2FsdGVkX19tm3JrNbl2WN6Ljnuhj7nAC4eWtqleD2sVlqtDrU5aaUhpJK6xqVT4oXCQP36eyl/2af4uqXWUCzGiItEOStJSuBlXz2uECmctWM4TnZiE9wvNjgPim04Ho9QciJmFgPGw+necJK+SY4kzyilCkjBzl6pLxflT2bunHBXkQSsl5cE8n8Dsok0d8Hv4Jgs7xHCU1k6/cwX0AwgjD/YU96quZpaYFVe81PtPu46/OnYIsM7ymeJjz9lXF9pp/KRUBveZ75n7SOE3p+ihwd3xIBcfZBFBVuHomHRjZRpbMSGMgHeG4iy39oKyaGF0LeKAWe3HmOLa8AuveldaZQktYDg6OfliQb/ajL+uRuIPP8C17Vy1qK3bfGoHXBj86MjID6nf0KtRq+xiyNP0IVS3GnOphYaNi/MhPkVcRJ802ntey1tIdj8LQU9Hi85Kfurd53GpyvTwONW+6yCrH1Z9ac88Qbkhk1otf7kA4aaPkJKJ6kMWCv12nRSg+jzEqXwSvmuTAM2waZQ8i2qO73WFue7G+vC6oos7tYWd2PwIJ7DB75e0q4qWigGqyMiv8NMnzljN9uTRSSoJATkByxmaBQm31ZWtAjtGn2r6U5W0g13zRY1qeRLjCbBBsxW2QfomgtTWburmKDOtmUN3unAQ9bSngL+TfkwNoc/6i7r2phunCCkE/YO8JTG51uM7q9S3wDuZaV1eF7aoEoa7mRwq3IMbFzUZ8khOPV9B2082hT0/KLKsykxMSi4mEy8e1lJfAswIXZvjOO2c9riiwPhZ8PXobbQqGmVQbmCVF4NLKHC0hsESJywVqHvLdd+qB0a49sgrHlZ+wJG6WaWyLQSWjrrb4YhTPEoiYQtqv7fHSup8J590Jn9yz7+7jQbPWmOj+TL9wGrQPLCYvAO9/JgetRYlZattllaso7TjxApnZnNsL1ZO7+RUqFxnfBoLoO9Qq5IfVA6G059
 lQxdT66e
 P79kfOz+O5R60FnzjwN+DjaP95LRlBqrqfucE4Ile4ehv2j1w1M8SFI1nb7FWFRa3ZOXnSLOWIZLMrKRoQpyG9Y2YHZmwUid0RI67HY5K6jsNPWb9iwh+AFRESna6ZvK6OsI6OxcTDSn2jIN6LyazHLmvZ2lmk4O7zmnH5TSQfQNvAVihIQWc6syZ7Sp/JrE/sUej4cxhwGRsLgEdHqVmVoiqYTQHSqyHzKDSBFcPpnSFSvAOw4wCOPqsfGtBe6xS9PC/8cwd5kl2JUne5hEohN2j/YQLD9yHtF3m8fjKrJRxZBOSo5rwsEm28QxstPIUs5Xu9KvbAjg5+lsnJCozY1HMNQWAL1Q6ldgq+D+VbFHLf/WynVNGTK4lnwKmvyy2dRb3V/XsVBpt66pI8mN3PbwF+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/26 3:17 PM, Valentin Schneider wrote:
> housekeeping_overridden is only ever enabled in the __init function
> housekeeping_init(), and is never disabled. Mark it __ro_after_init.
> 

what about housekeeping_update which could be via isolated_cpus_update
when creating isolated cpusets.

> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>   kernel/sched/isolation.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 3ad0d6df6a0a2..54d1d93cdeea5 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -16,7 +16,7 @@ enum hk_flags {
>   	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
>   };
>   
> -DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
> +DEFINE_STATIC_KEY_FALSE_RO(housekeeping_overridden);
>   EXPORT_SYMBOL_GPL(housekeeping_overridden);
>   
>   struct housekeeping {


