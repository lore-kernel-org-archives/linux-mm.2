Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF51FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0EC36B008C; Wed,  8 Jul 2026 03:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBEF36B0093; Wed,  8 Jul 2026 03:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD396B0095; Wed,  8 Jul 2026 03:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 815F46B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:08:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E67801206D4
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:08:45 +0000 (UTC)
X-FDA: 84964731810.09.2B97F38
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5A994140003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:08:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=dWA6Inxr;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FGhcF4fR;
	spf=pass (imf23.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783494523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJqYhVncBU+d62V+AHvnJXoOTo03C+xWxG51CnST7TU=;
	b=q0dVq1W/epOmzwnZkhBTxtclmLnt3gNomTXVcLUkFmF57CGHVW1GxcuhqTJL4JiIy0ArAu
	Jm78Y84pRen9qE9bHHRB8cN8QkyEPPpQJmAi08Tr3Y2FQ4EcGdNlf/LPnGkCBVIob4+aqL
	YAFMt4uYOlEEKhtWvn0+PUf6NQYI0zA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=dWA6Inxr;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FGhcF4fR;
	spf=pass (imf23.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783494523;
	b=Wz78gefQHZnGeV9LDtc8w/bFObcEhPjcKpGIghej+gle3Mi4O5h5+wA2eJEBLjOnFmmc3A
	mdqs/5pdqkpJk2IGJfsnjfb2WLc3Xb3XWsqcYvb5uhxo+MJRTes1i4GqrOzwBLBulIsofb
	Qw9j5YtaKgiRG08uYvgBkIq+2nDgqRw=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6685mjIX1761043
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 07:08:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=nJqYhVncBU+
	d62V+AHvnJXoOTo03C+xWxG51CnST7TU=; b=dWA6InxrM1RDSuiXJWA8wNLflNn
	bjANDuPY7kJ2Uiv12Ah48NqX8rczX8ICeD49ThCPjfrxwDYvjDxGKz9TTTt4lcSy
	6CdqHUbjjbBrjrcFaa7ppQC+kldPN6iJVr8ovr6Cpw9lYjW9FNo6UzysXJkoMdQn
	W4wwr6HHJyeLZeFOsIEMQMGKFVmIw/83kT8n75XoFBAnTZyE15fA4huaUutPBeZz
	IxXwuRpA3MMGvJyii3Ju74nPN3LN9N7nfhkIaOFrr3wk31zMpV0WVtG4i+GAduni
	FbUnjHxWmv+nWZzRz0zqBeTgIvQ8ZII1udWS9nED984qtdCzvsPdUDYXx+A==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9gqw89q4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 07:08:41 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c8895156101so584988a12.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 00:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783494521; x=1784099321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nJqYhVncBU+d62V+AHvnJXoOTo03C+xWxG51CnST7TU=;
        b=FGhcF4fR4rf4mCX5QqTmsEOyvSYqXNLsxtn58zEdFPGBwbIvyx4VqWh4Psaw2hf0v8
         +VZKa4zpHEtATVyXgWGvIlzWqEbteeY656C4i9UtbaIBTGlorJJmp5gdIdgWCsZzOCNV
         BF5ZCZKwttsu8PcqFDb2F2wupqYO8Q40mHbba2YkDHR5czLVkFQRrsV+k5bM6nPUNKEY
         gky42yFHGySBO2SWz4lT8aIW7LP7WTTTou++z23zSZqRRoRMocqBt0eA0cnni54dUPlQ
         4EEqGJ6D5VTFxSrzFhcqacWTYTt893Wj71j75bt9MLxh+V2vnxwaLWThNsC1PzTxGHRb
         YOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783494521; x=1784099321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJqYhVncBU+d62V+AHvnJXoOTo03C+xWxG51CnST7TU=;
        b=RIuNOnJedG49qXbWX0fh3d43Qa9cK4cszmCiK54MUuPBAlh9GsTa1eMmTrMl+ndSQf
         5HDIcJKvlAf5ft+GWHh1LoCN/CsXd2q0oKOZ7xoO4arxPc9+1JiXPcZY13A1U+7lIUXQ
         xRjCYdnhUkJRv+ra6x59JQii7HYpNKMyTmjInr0vwGgxg2iyR9IkftFIaOhanU4TIjm8
         AzpwCU2dhzj1YnWCOzjBcA0vIG+w9lXOkW7DFvrFXiGZpi2Fq9PTzdAi6NxFDv97At94
         icSvQjvcMz2c06QOUjtIJKEMFaYkrlWgdFQe88lYzhRsBs4AQJ6I7syH45BtYFfULuGB
         2xeQ==
X-Forwarded-Encrypted: i=1; AHgh+RqvUHyXnyedzcYypUftR35ghSAXvoSR5H+L860IkZBZi7WdN7lPTZitC+aia0yeJ5F6LI+gP+kBOA==@kvack.org
X-Gm-Message-State: AOJu0Yy0U2a2Dc2xdoqK4EHqrhfh/oQunIzTnzaMR6n2XPPpEDeMRzKj
	p7QiKrDSxqkmtTtinTf3ltcqon/nJkA5dQw/C60Xiaydi7tghtO12GSs5MSDqtQxPlY85/Ry+zb
	Oyi0V5WLk9RtXwdk1uA15f+enhwMNYC2oqKx2hUGB5GB5QvBE1/ycwQ==
X-Gm-Gg: AfdE7cmpRo0HW2t7MTH0/zTBEMbUiumNfop3gB6za75yiUTdEs+JPyVp8PZLx+Trc8u
	nDFgoiK1bkglB6UCZlfoPdbxuNa3YPTSJL3bOPlxbdSa76WZGiDUQ5ea+if+LZ9BXNr2UNKL7It
	LGfAo5EDMASZ2B2H9shnAzDQv6zugJHLzVP2sR9nMim1QbZpqye3wNKK57cZCrCvs5LC5CVmJbF
	4VKyJyvH6AZHB7e7IokbJz56ULW0ilsR/+Xgm0MNr66HQrpY5dG9+m7Zfs8JLDr6mWjr42OqRGd
	iorF5/1t0TIIBNXuTNrHKLjgbJikfM5Ty9fjVz6NoNzbw0nvGOGhshhHa9xV+BHaFO8/vKjXHJB
	kqLkhegl5jgRTT3y7HpFdZSWDdtnAYlLpP5o/BA==
X-Received: by 2002:a05:6a21:10e:b0:3c0:9c19:65b1 with SMTP id adf61e73a8af0-3c0bd3acfb6mr1445382637.73.1783494520978;
        Wed, 08 Jul 2026 00:08:40 -0700 (PDT)
X-Received: by 2002:a05:6a21:10e:b0:3c0:9c19:65b1 with SMTP id adf61e73a8af0-3c0bd3acfb6mr1445323637.73.1783494520337;
        Wed, 08 Jul 2026 00:08:40 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5afdb754asm1893624a12.13.2026.07.08.00.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 00:08:39 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: akpm@linux-foundation.org, anna-maria@linutronix.de, arnd@arndb.de,
        andersson@kernel.org, chrisl@kernel.org, cl@gentwo.org,
        conor+dt@kernel.org, david@kernel.org, dennis@kernel.org,
        devicetree@vger.kernel.org, ehristev@kernel.org, frederic@kernel.org,
        mingo@redhat.com, jstultz@google.com, corbet@lwn.net,
        juri.lelli@redhat.com, kasong@tencent.com, kees@kernel.org,
        konradybcio@kernel.org, krzk+dt@kernel.org, linux-arch@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-remoteproc@vger.kernel.org, mathieu.poirier@linaro.org,
        mukesh.ojha@oss.qualcomm.com, peterz@infradead.org, pmladek@suse.com,
        robh@kernel.org, saravanak@kernel.org, tj@kernel.org, tglx@kernel.org,
        vincent.guittot@linaro.org, workflows@vger.kernel.org
Cc: atomlin@atomlin.com, ast@kernel.org, aliceryhl@google.com,
        linux.amoon@gmail.com, ardb@kernel.org, baoquan.he@linux.dev,
        baohua@kernel.org, bsegall@google.com, jackmanb@google.com,
        leitao@debian.org, brauner@kernel.org, coxu@redhat.com,
        dietmar.eggemann@arm.com, dianders@chromium.org, ebiggers@kernel.org,
        feng.tang@linux.alibaba.com, yangfeng@kylinos.cn, gary@garyguo.net,
        guohanjun@huawei.com, jack@suse.cz, wangjinchao600@gmail.com,
        joel.granados@kernel.org, hannes@cmpxchg.org,
        john.ogness@linutronix.de, jpoimboe@kernel.org,
        shikemeng@huaweicloud.com, kas@kernel.org, kprateek.nayak@amd.com,
        liam@infradead.org, ljs@kernel.org, elver@google.com, mgorman@suse.de,
        mhocko@suse.com, ojeda@kernel.org, rppt@kernel.org,
        namcao@linutronix.de, nathan@kernel.org, nphamcs@gmail.com,
        n.schier@fritz.com, pasha.tatashin@soleen.com, petr.pavlu@suse.com,
        pnina.feder@mobileye.com, rdunlap@infradead.org,
        rioo.tsukatsukii@gmail.com, senozhatsky@chromium.org,
        skhan@linuxfoundation.org, sboyd@kernel.org, rostedt@goodmis.org,
        surenb@google.com, thomas.weissschuh@linutronix.de,
        vschneid@redhat.com, vbabka@kernel.org, youngjun.park@lge.com,
        zhengyejian@huaweicloud.com, ziy@nvidia.com,
        Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH v3 26/26] meminspect: Add debug kinfo compatible driver
Date: Wed,  8 Jul 2026 12:38:09 +0530
Message-ID: <20260708070809.2660886-1-mukesh.ojha@oss.qualcomm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA2NyBTYWx0ZWRfX4PcQO6yOfL9d
 dW42TiIck13Zh4561ZgdKg19djt9A4k8mSvCJf1xOIEQpFpCoWI4jnIrDzNX0bdZeeYX/TbZ9bt
 XsdTeNSEFJST05PDPM0Zeapl3au41zFmWPz/VCsXLO5a7e9+qZUCyC5o7WDSdQpFi5BqyG3wAMD
 t1IRJlDVP00Tplpix7Fe4+bDJBBOQQxugAsIsjcvrSXu9FxizMTaUbTBfxm8Pv0ujw7tleeH4J7
 8hbboIHtrQLGEvrRQkoALimbQFvBjKbNypJN7eFHC9hxG/syErVA9NRaT4FVu+igVka0TslBQBb
 jCSk3cwVjH3/ivja3kox1kWtHOKO+EV/k+o8Xgj03kQcVBvX//o8hH27qcFsycBB1xBc3zygMd8
 oWkW7tx/w/DNhG7aCHgfCG7yDlRSDOwQTSwMKOzZdl0fUFOPamvcHWt1fyyhHGDq75PNQm3+xRw
 sTaMbPwZheXvi4pXjww==
X-Proofpoint-GUID: rBTqanX9tbvHeeWfTOuNqkzluviBxJBw
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA2NyBTYWx0ZWRfX45oaCX6JkXnd
 6ZW0G1+1htFKEzkeksLiumen3xf1XJY4nBdXzhQlNU7Rvf4RojLl8W2cXberT8bzoVpVXEyxLn3
 FRi2rEvQaCsb0oiv2IWg8BpvcH9bi8Q=
X-Proofpoint-ORIG-GUID: rBTqanX9tbvHeeWfTOuNqkzluviBxJBw
X-Authority-Analysis: v=2.4 cv=Wf88rUhX c=1 sm=1 tr=0 ts=6a4df779 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=Tty9oNO6AAAA:8 a=1XWaLZrsAAAA:8
 a=rSYwI8UV6N779v-tbp0A:9 a=3WC7DwWrALyhR5TkjVHa:22 a=cvBusfyB2V15izCimMoJ:22
 a=Bts-Es6F1CBXvF7u4C_G:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080067
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5A994140003
X-Stat-Signature: oy55ihrg5ohpfwc9hh8439j39w5e1qps
X-HE-Tag: 1783494523-798041
X-HE-Meta: U2FsdGVkX19B9wtsk+ic+xJifE+60GDmvz4/tpPRxvLYBU4S9/2WpVSnrfPjNADLunH0FKkDwv7gV8QwsxXtlVtdwWnA2HSM4/8reVRhZxD1EtaUS+o1CNU2NFZa6jXTQUf6LfFy8np1/yiNbP8BKV2lhj5pCISJD0LdvLgSVbxHUxfZDk9Idggs3RQh2Sn37yTHSw1gGWP/G/iX9d7U8Jn6dgmYKc1wFKIarefx/k2d6mPhmGX0Ufv4uBP+z0MsxWrVV/D1+mKG6JS7I8wd/vFjO2Rgf4Aq7tfEL/LkLqztgQ5ez5PrTt2INfZO0BbDcuehOYBKtUmTdNN0qKtYA0YHCfsX55jCxr7NY0oPd0fc9sU0Tfh4Nf1ntZwvPlZ+VewA/99twDov4F4e7etfW8DZECR0Fny/JovhnNxn41JCfcHigfBOZNxPE5SddKBiNHpSwH2zvocAI1poUlwNjcNSSNEmlPgM4UVvzGlnULEI28jfzD7acfdXftVxP/Ja3qPGHs6tY3s8BA3IlundjzozIR702Oc2etJOTDELERDuQ0dxkbuiGXfYLB1egL+Vr7siUh5Puz8qePAJmw3kP46bO/BWg9D1XwHlMQJa0Q9wO0f3igjvTDq1mrAsONrWGEzH+CSYpIdf3nzOjRxoFEo2kLeBpWwIuqLXwZ8ESYiBf0RU1FQRQJiVs47VGCTEtcTXVXAJAoe2PabmJse7Bua5n2ubqp3p3362AnI6G0aA7L1Ti4kpPsFNoJepyeX1mxREJ0R30J+41Lsyb2llX5CgCU/JNoA+JPO1D8gE9QzY/fEXx6ZKfeYzC4GfA0wAE7KANxs2NOQWGnU34vAx8nOTD52GMB0Y4vyyHPuEel5HoHHF8aPsG5rLfBOTyCCAPEvgLjcE4rA9B64ti/hn94EQnBmm1aAMES1JEPV1CVu8IcpxMmklwN5iF5ak/hxTiRkHjJ4PmzBrWM8fwqw
 kLbIBLrv
 mX/4TqH8l44InOsKmJgKE5WIMEt32Wkj+75uFa2IMuMPpqN64JbZtyC51Tg3IEBXdqeikL131ITpdxvEkvAAJmkwxS/j+SN3Iz3eWGcwms7YkOvitS+2SS0M5k7Px2oryt3MMvES5FU8iHtkyGCo0LeNB+AKdutPNiB1i+TT41f+asBetffp2tHyDmR+nuL9MiswtcSh0gbiGI9I+UryL/JMSvuPA8oq0Kh4xy0X45fqoXjJVh7136Jb6+ryB8BZu815lNQxwIfFEEwO7JTymTRjkwuQxZ9g+XMauPkxkjLlLkY7Um1a2Nk7IRKJGz4nWLSt51eneRrOLpz7OJWht9qj/W7cCUg0L7pWhmb78YxSnecy25AnKkbmca3dG/Pg09du6RLZtE6qd7+Jb21Df1e47LkA13Fii82thTqEGiv4BDxDK69NsDs13LApFGtEYyKspzP6TUpNWc1Pz8/AhyaZF8mmPqKaQtpX7tbryQ1dbNmX2hRtoOUuhoPoA6YrpeCQSdHfiPQH3yw2guB5ej3WciRZ5JPJPME5C3JuqLUoCQF41+8sbRwTrdsWMApA/goqInx20VVuu9UD8hKToX+fpqJN8IeEMntXAR4t2Ihf50BppPUySl/kwMx79L3/GzSl4/TZNmbO3+YRKIB0Hm02oAJOJnUWzOCKuzQx1WQav3PZzs7KUvATcGTDEnxj/x7XO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

With this driver, the registered regions are copied to a shared memory
zone at register time. The shared memory zone is supplied via OF. This
driver will select only regions that are of interest, and keep only
addresses. The format of the list is Kinfo compatible, with devices like
Google Pixel phone. The firmware is only interested in some symbols'
addresses.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 MAINTAINERS                |   1 +
 drivers/of/platform.c      |   1 +
 kernel/meminspect/Kconfig  |  11 ++
 kernel/meminspect/Makefile |   1 +
 kernel/meminspect/kinfo.c  | 257 +++++++++++++++++++++++++++++++++++++
 5 files changed, 271 insertions(+)
 create mode 100644 kernel/meminspect/kinfo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2d816d783024..d805ff9fedac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16906,6 +16906,7 @@ M:	Eugen Hristev <eugen.hristev@linaro.org>
 M:	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/reserved-memory/google,debug-kinfo.yaml
+F:	kernel/meminspect/kinfo.c
 
 MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 53bca8c6f781..f80bd25fc481 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -494,6 +494,7 @@ static const struct of_device_id reserved_mem_matches[] = {
 	{ .compatible = "qcom,smem" },
 	{ .compatible = "ramoops" },
 	{ .compatible = "nvmem-rmem" },
+	{ .compatible = "google,debug-kinfo" },
 	{ .compatible = "google,open-dice" },
 	{}
 };
diff --git a/kernel/meminspect/Kconfig b/kernel/meminspect/Kconfig
index 18ff511ad4cf..7f6436c3344b 100644
--- a/kernel/meminspect/Kconfig
+++ b/kernel/meminspect/Kconfig
@@ -16,3 +16,14 @@ config MEMINSPECT
 
 	  Note that modules using this feature must be rebuilt if this
 	  option changes.
+
+config MEMINSPECT_KINFO
+	tristate "Shared memory KInfo compatible driver"
+	depends on MEMINSPECT
+	help
+	  Say y here to enable the Shared memory KInfo compatible driver.
+	  With this driver, the registered regions are copied to a shared
+	  memory zone at register time.
+	  The shared memory zone is supplied via OF.
+	  This driver will select only regions that are of interest,
+	  and keep only addresses. The format of the list is Kinfo compatible.
diff --git a/kernel/meminspect/Makefile b/kernel/meminspect/Makefile
index 09fd55e6d9cf..283604d892e5 100644
--- a/kernel/meminspect/Makefile
+++ b/kernel/meminspect/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_MEMINSPECT) += meminspect.o
+obj-$(CONFIG_MEMINSPECT_KINFO) += kinfo.o
diff --git a/kernel/meminspect/kinfo.c b/kernel/meminspect/kinfo.c
new file mode 100644
index 000000000000..7451c13bc316
--- /dev/null
+++ b/kernel/meminspect/kinfo.c
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *
+ * Copyright 2002 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ * Copyright 2021 Google LLC
+ * Copyright 2025 Linaro Ltd. Eugen Hristev <eugen.hristev@linaro.org>
+ */
+#include <linux/container_of.h>
+#include <linux/kallsyms.h>
+#include <linux/meminspect.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/platform_device.h>
+#include <linux/utsname.h>
+
+#define BUILD_INFO_LEN		256
+#define DEBUG_KINFO_MAGIC	0xcceeddff
+
+/*
+ * Header structure must be byte-packed, since the table is provided to
+ * bootloader.
+ */
+struct kernel_info {
+	/* For kallsyms */
+	u8 enabled_all;
+	u8 enabled_base_relative;
+	u8 enabled_absolute_percpu;
+	u8 enabled_cfi_clang;
+	u32 num_syms;
+	u16 name_len;
+	u16 bit_per_long;
+	u16 module_name_len;
+	u16 symbol_len;
+	u64 _relative_pa;
+	u64 _text_pa;
+	u64 _stext_pa;
+	u64 _etext_pa;
+	u64 _sinittext_pa;
+	u64 _einittext_pa;
+	u64 _end_pa;
+	u64 _offsets_pa;
+	u64 _names_pa;
+	u64 _token_table_pa;
+	u64 _token_index_pa;
+	u64 _markers_pa;
+	u64 _seqs_of_names_pa;
+
+	/* For frame pointer */
+	u32 thread_size;
+
+	/* For virt_to_phys */
+	u64 swapper_pg_dir_pa;
+
+	/* For linux banner */
+	u8 last_uts_release[__NEW_UTS_LEN];
+
+	/* For module kallsyms */
+	u32 enabled_modules_tree_lookup;
+	u32 mod_mem_offset;
+	u32 mod_kallsyms_offset;
+} __packed;
+
+struct kernel_all_info {
+	u32 magic_number;
+	u32 combined_checksum;
+	struct kernel_info info;
+} __packed;
+
+struct debug_kinfo {
+	struct device *dev;
+	void *all_info_addr;
+	size_t all_info_size;
+	struct notifier_block nb;
+};
+
+static void update_kernel_all_info(struct kernel_all_info *all_info)
+{
+	struct kernel_info *info;
+	u32 *checksum_info;
+	int index;
+
+	all_info->magic_number = DEBUG_KINFO_MAGIC;
+	all_info->combined_checksum = 0;
+
+	info = &all_info->info;
+	checksum_info = (u32 *)info;
+	for (index = 0; index < sizeof(*info) / sizeof(u32); index++)
+		all_info->combined_checksum ^= checksum_info[index];
+}
+
+static void __maybe_unused register_kinfo_region(void *priv,
+						 const struct inspect_entry *e)
+{
+	struct debug_kinfo *kinfo = priv;
+	struct kernel_all_info *all_info = kinfo->all_info_addr;
+	struct kernel_info *info = &all_info->info;
+	struct uts_namespace *uts;
+	u64 paddr;
+
+	if (e->pa)
+		paddr = e->pa;
+	else
+		paddr = __pa(e->va);
+
+	switch (e->id) {
+	case MEMINSPECT_ID__sinittext:
+		info->_sinittext_pa = paddr;
+		break;
+	case MEMINSPECT_ID__einittext:
+		info->_einittext_pa = paddr;
+		break;
+	case MEMINSPECT_ID__end:
+		info->_end_pa = paddr;
+		break;
+	case MEMINSPECT_ID__text:
+		info->_text_pa = paddr;
+		break;
+	case MEMINSPECT_ID__stext:
+		info->_stext_pa = paddr;
+		break;
+	case MEMINSPECT_ID__etext:
+		info->_etext_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_num_syms:
+		info->num_syms = *(__u32 *)e->va;
+		break;
+	case MEMINSPECT_ID_kallsyms_offsets:
+		info->_offsets_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_names:
+		info->_names_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_token_table:
+		info->_token_table_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_token_index:
+		info->_token_index_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_markers:
+		info->_markers_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_seqs_of_names:
+		info->_seqs_of_names_pa = paddr;
+		break;
+	case MEMINSPECT_ID_swapper_pg_dir:
+		info->swapper_pg_dir_pa = paddr;
+		break;
+	case MEMINSPECT_ID_init_uts_ns:
+		if (!e->va)
+			return;
+		uts = e->va;
+		strscpy(info->last_uts_release, uts->name.release, __NEW_UTS_LEN);
+		break;
+	default:
+		break;
+	};
+
+	update_kernel_all_info(all_info);
+}
+
+static int kinfo_notifier_cb(struct notifier_block *nb,
+			     unsigned long code, void *entry)
+{
+	struct debug_kinfo *kinfo = container_of(nb, struct debug_kinfo, nb);
+
+	if (code == MEMINSPECT_NOTIFIER_ADD)
+		register_kinfo_region(kinfo, entry);
+
+	return NOTIFY_DONE;
+}
+
+static int debug_kinfo_probe(struct platform_device *pdev)
+{
+	struct kernel_all_info *all_info;
+	struct device *dev = &pdev->dev;
+	struct reserved_mem *rmem;
+	struct debug_kinfo *kinfo;
+	struct kernel_info *info;
+
+	rmem = of_reserved_mem_lookup(dev->of_node);
+	if (!rmem)
+		return dev_err_probe(dev, -ENODEV, "no such reserved mem of node name %s\n",
+			      dev->of_node->name);
+
+	/* Need to wait for reserved memory to be mapped */
+	if (!rmem->priv)
+		return -EPROBE_DEFER;
+
+	if (!rmem->base || !rmem->size)
+		dev_err_probe(dev, -EINVAL, "unexpected reserved memory\n");
+
+	if (rmem->size < sizeof(struct kernel_all_info))
+		dev_err_probe(dev, -EINVAL, "reserved memory size too small\n");
+
+	kinfo = devm_kzalloc(dev, sizeof(*kinfo), GFP_KERNEL);
+	if (!kinfo)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, kinfo);
+
+	kinfo->dev = dev;
+	kinfo->all_info_addr = rmem->priv;
+	kinfo->all_info_size = rmem->size;
+
+	all_info = kinfo->all_info_addr;
+
+	memset(all_info, 0, sizeof(struct kernel_all_info));
+	info = &all_info->info;
+	info->enabled_all = IS_ENABLED(CONFIG_KALLSYMS_ALL);
+	info->enabled_absolute_percpu = IS_ENABLED(CONFIG_KALLSYMS_ABSOLUTE_PERCPU);
+	info->enabled_base_relative = IS_ENABLED(CONFIG_KALLSYMS_BASE_RELATIVE);
+	info->enabled_cfi_clang = IS_ENABLED(CONFIG_CFI_CLANG);
+	info->name_len = KSYM_NAME_LEN;
+	info->bit_per_long = BITS_PER_LONG;
+	info->module_name_len = MODULE_NAME_LEN;
+	info->symbol_len = KSYM_SYMBOL_LEN;
+	info->thread_size = THREAD_SIZE;
+	info->enabled_modules_tree_lookup = IS_ENABLED(CONFIG_MODULES_TREE_LOOKUP);
+	info->mod_mem_offset = offsetof(struct module, mem);
+	info->mod_kallsyms_offset = offsetof(struct module, kallsyms);
+
+	kinfo->nb.notifier_call = kinfo_notifier_cb;
+
+	meminspect_notifier_register(&kinfo->nb);
+	meminspect_lock_traverse(kinfo, register_kinfo_region);
+
+	return 0;
+}
+
+static void debug_kinfo_remove(struct platform_device *pdev)
+{
+	struct debug_kinfo *kinfo = platform_get_drvdata(pdev);
+
+	meminspect_notifier_unregister(&kinfo->nb);
+}
+
+static const struct of_device_id debug_kinfo_of_match[] = {
+	{ .compatible	= "google,debug-kinfo" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, debug_kinfo_of_match);
+
+static struct platform_driver debug_kinfo_driver = {
+	.probe = debug_kinfo_probe,
+	.remove = debug_kinfo_remove,
+	.driver = {
+		.name = "debug-kinfo",
+		.of_match_table = debug_kinfo_of_match,
+	},
+};
+module_platform_driver(debug_kinfo_driver);
+
+MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
+MODULE_AUTHOR("Jone Chou <jonechou@google.com>");
+MODULE_DESCRIPTION("meminspect Kinfo Driver");
+MODULE_LICENSE("GPL");
-- 
2.53.0


