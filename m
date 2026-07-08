Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B4DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A182D6B00AE; Wed,  8 Jul 2026 01:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFCE6B00AF; Wed,  8 Jul 2026 01:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8076B00B0; Wed,  8 Jul 2026 01:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5888B6B00AE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:36:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE8074067B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:36:29 +0000 (UTC)
X-FDA: 84964499298.01.634165B
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 52311C0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:36:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Iv99Fe6j;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=IMvpQn73;
	spf=pass (imf22.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoV8YBxGFxD7tibQwZ9WC2gTvFHftXwkSTWa9oagng0=;
	b=ZJMKI2kaRokhn2MN8kewntQpx4vVbBelRPqkmyIjz8m3rrTARSNjG47+/ObevNk19E9KRl
	md9qWAZog5rofZyIF4Fis3oIfQ3c9/FOZvoiLwcj5sTZBaDKHViCHbRbzyfwD1w+z3HUwN
	u976JUK5zRMLGPw/yMGp19r/FN8vUIk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488987;
	b=sCAEZqH25sqhrHQOe6HkW89jMALT4OW6sljaMEEbHUbscjy5sknqsfksZ0vuv3lOv5eNIA
	U1Kcb2yyStI1SAIRkprpbKhPn8YnrLivPYz/D65V7zxYPrbfb2oFophhikdQnmBZc9y3bO
	lgXjJOrz6mScZvTgUL6Qv0CWzO+YA+Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Iv99Fe6j;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=IMvpQn73;
	spf=pass (imf22.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842h4L1625072
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IoV8YBxGFxD7tibQwZ9WC2gTvFHftXwkSTWa9oagng0=; b=Iv99Fe6jAbsZCCqS
	NiM/Qq1pQ3aRuun62AHDkFpQxEYFtdthDAqXaUY+HQUJ1wFw/bPDans7nAPcDs9M
	zYV9AMQhoif2Gkb4YRB+yMEyKyLZA4TgjnGcZzO34H69ejcJqodnn2faDF1JpYXp
	dpjHuH2gzqRGZC1HgzQ0bJ5ZdgcWksb+VhkNv6BDiaCOdBP4HAdY4zJQD6GIEugc
	2xwzrptfJ2UTJcvWMfTxb0j/6zbeZImKWeK8+zIm88CQSNIePJGMAwKFFtmL2+E0
	5yS36eJoF4Q4RsIvsAJ7LbVBeImkcTef+XGdPa3CMbZgTFwHEQUo9Zb29FthjhhF
	OrAt5A==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f95fd2ttd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:36:26 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8478e9c4bd2so416007b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488985; x=1784093785; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IoV8YBxGFxD7tibQwZ9WC2gTvFHftXwkSTWa9oagng0=;
        b=IMvpQn73+bNiPEefAb9tyI0Os+WUgeIq4mMbHP6Xr98C8/3sC/b/tKKAoVNdYF58WN
         3qJSsTEZty7ySeIZBj8A1a+L/gjiBv/hi/PRV28xBR4UQIGFQJAKJ+RelWGlCRZqlg/f
         vMVKrHKISYXsuc45Fo1aib91I7PbqjKOf3eqsgxR6OPSQ97TSxAVwq+QIIxApVhkdUuZ
         0NzQyOM8Rkjuh3euUvLp9g+ntyKLxhNPNY2ujv+JT7xBfrGPA2oERBdTRtw96qO/u1oB
         SpAhAKLmWC3Ejd3cqL0lIEEY+wQSogX5d3kaAp2IWkEKGv2FKFeq3/rV2+8oxMff2aHy
         Sb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488985; x=1784093785;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IoV8YBxGFxD7tibQwZ9WC2gTvFHftXwkSTWa9oagng0=;
        b=B7d7T+hqsqnP/Ibz8Zfz9ZrOluMRvl2YHda09RrWvidZ2hIw0W87GBE0jDTdiFpFVC
         WyBg4DDzMLTGTE+Lp5bYdRlsMT9l4MRlijIqdP4QBZb2ouO8mT1JhxxXjgnIEnTBlQkT
         AMxN+9g5DxxuJQB2VNBbod/iTNEIsJP1yQLeESk0eOkulubIhV6QrJjzSyq4nVCZalTe
         Tr1P2wr1TCHTA4vJoqEqtMHuvgjSistDIh+KqjJaJVC/g8fVjNYE4gOtE+v/ploETv7X
         yqvcFXEzR5kK5F80AU7EMqKSxZBrWJfWUGVzwF8F/xsqxX6TATZYt71UqdDrfrBMk+Kq
         Jfbg==
X-Forwarded-Encrypted: i=1; AHgh+Rr61pk6bM9mB6X5aAgUxRg9gLIpOy4OtRxwac3Im9PF/GVh3p3QgqE6n/F3JzyuoJS2ZeJD0PkIjw==@kvack.org
X-Gm-Message-State: AOJu0YzZ1sss+YMDO/OVg4h3sAJ5gCXKM1qMAgL7STT+6u1hjeleVAYR
	d/NkjMj4Z3NDUOEZcRS4CO+tLdDoqmpE4GQLX2KAvoL38xhkveOGTCCnAGrURX5rEuJWjhiBWV0
	0XspYv9T+4PxxFyk9t0OLZJhZQE7U9C9Cd301IA4/bFlLzw2NKf1+AA==
X-Gm-Gg: AfdE7cnZ8Gq9k5MBJxiFAf1GLG34mkOMGk3wZXJfsBscd9tV7Aya5Gyhyc9X17R85zE
	5slowMYznfhTPwcNn8YP4at21+6s8XvUtFXIEPszWB24VWm4IqQQSybFbxhb1FJ6XyiSnMCuEnc
	su9AqULZRwL9sAI5vKlvY+enqM0yV4Zbn4bJwtWuTcog8LxU6+FLlgXNh52Ym1yvw6F/3SRZdDR
	8kuL3yI5XFmm9U6RdAu30q8onmJFv21D+R6Ek/k91Z0ch/cfO1svpqk34lbcetMkHRt/Q3ZpWFg
	0xY2R0wowK0QAwf3R7GN3qyJALmBfPrHmp6XbuFShPEL6XmnJN6jYmExfEuRcxSQV/RLO/tow8t
	cQuErGdFZop7ph7WjnirB5PIl77OV61pYqiR/Ag==
X-Received: by 2002:a05:6a00:a205:b0:846:bc7f:16a7 with SMTP id d2e1a72fcca58-84843233d05mr1113983b3a.28.1783488985101;
        Tue, 07 Jul 2026 22:36:25 -0700 (PDT)
X-Received: by 2002:a05:6a00:a205:b0:846:bc7f:16a7 with SMTP id d2e1a72fcca58-84843233d05mr1113887b3a.28.1783488984399;
        Tue, 07 Jul 2026 22:36:24 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:36:24 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:55 +0530
Subject: [PATCH v3 16/26] kallsyms: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-16-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1392;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=Gi0PIfTIjU9TnT41l5DIWFSBN6wjIpAR6J0C3M16mR4=;
 b=4j3BsRQDoQCY2sSeQc174A2W0e6sMIQ9ts68CSYZZ6ZC0iuChwxNv0mlJ/UxecW0pFQsfhCfc
 knHk43S2I6HDzfKU2yn6g+e2LK0aM67W84x5u9xvsDoxGMo1wtX+K7g
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX9gm8yj5Ah1kS
 5VDU+rxD01leDZ0Gq0msOWIgurqrwMIjbbawWorWRRFO73OklwyWOYLOo5dJIBcdXA0THUIyXgO
 xqaOOl/WWBqF0zYSStCnNS/mq3gUR21QuKGH4+nILXJ96Gl07Jw4c02X3B/tJZQp3TDxfQe5DCh
 U0AZHLhzcRXvmjw8ahT0wNraJ40/VoR4RwucmnhLWIxP8TATg/XOhFjnD2XVsjraUtsofBf+rQj
 2celXA/oo4bLSeD7VsHvsnircsPYMV+GTS1hYb6H/Z0s5f+OFwq+RhZeN4YFW1PovgIw54AIU4I
 K5X5S0kdbLCGWnBvfEqv202WZW9LjtBPwMGwjR2XbL/l7o+nOhwzAbMN8Zco1CW7eOC1p/sskoU
 Zy2a+Vzww1jzKoN87ttT0u9a6mSLCUtBi++MejT3mxiFSwydYhKOWjH0NZivYTxaeD0zv5Od85C
 Yyyj6TG4O32Ow4H48mQ==
X-Authority-Analysis: v=2.4 cv=VZLH+lp9 c=1 sm=1 tr=0 ts=6a4de1da cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=w68G1zR93E_Nt3437osA:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: TWFDeavxY7A1Dn2uuh7Yn-uWY9tcrabu
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX6zQAnEYxCa7A
 xx5pLG3kx5kDKLW44BhD+3K9FAv2xGDkYVIFi3qOLeFqG27aJ6Ssbr5AM6xwSYN7Xo9CO7IiO9l
 duz4ytPs6E4JlgZAnkU5IL9T13Gz+Ec=
X-Proofpoint-GUID: TWFDeavxY7A1Dn2uuh7Yn-uWY9tcrabu
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52311C0002
X-Stat-Signature: wu4cun9snga438e1ikhpuoek7hinux44
X-HE-Tag: 1783488987-554087
X-HE-Meta: U2FsdGVkX18+nLF+vz6f+vcDuRq9w7I1NS5vcW3wjSEyCVRTnYXUsd7SO+chwJMW7mk+gh6Bqub54unLzshQzf9gz+cvbu9HTsXKGemS1qymYHjjy4+pNKJYMOI6BuHQPDooQGfmFCHlaa8AvOGZTHv7PemgfhOKrsD7kQ6Pdrclv4rtvjZ8P703cb97lUL1qHcBenNfpKmDtrkWmtXcBpNGBM1AWo0no+NfxNxKmd5MD3Zo1UA2HQnB3lnWDRLoS9VrA9PcoKpNpZV0Ch1KlR6t7DJipHmJUtL80V4vUQ+kxvEt9BkRQZCOVT7K4P/Vx4Onhf4ZeT0GyY7GaBnbJmdMTlqLtNj7PCxE8iamd+slcuYgbA/6GdBMBVS94Ob1A2o7+8YWy7sJMpT242jDtn8eTROUR4HnMyAIUHGrmC2xmdr+zM6VVJ4/4HITh20RCIcTDsBNCKmMNXpKJj8MLtg6X3AWENxx7NAqPnoAfY5vrYQOOfumpPstY2A4yh2B+RWm9TMAMochc/K+YMRZt4EvisjOKBKpIDF8BCn7afkIKAR64rlDNhX5MJ2+H/7hNuO8gqi4sBB/Asdc73xo3tWI3tWL9z81UE72BD3sYT+f5E2IOy66s2e2AFUG0DVVgZ2GzlIDOmarPfywSAsT8eDott5fIcTauHzaO6kjdkGmidN8s7vC7AKtwUwspOBwZfE3YGxDZjpiUat3eTYI5bOwfpDJLy505RrLZCXxOZQXspnEnBxbjQGgLI6WAULrzX+fq7mkU9G2VZnRBnPmn/eM0iarpgHSksMLliezX7JAm3mKzk/jOGSXVj37gDSgGnc2TpYhg1PLrTU+JC5TYzwkDzVoA5WJD6r+CubsHA0moDuuXt/bZ4aaODmEhNGSSR4tqvX/yTn+Y4yv//iWtwgNvbZTTvZ8k125DkgLBhRgrZMiv60aS5Koteg690/sPP/q82a+NHm/1HAHd1T
 vYP++bcz
 EI5lNC8yj6M1O+qQyKnN9xM5Op3+OgoKGxFamjOtUXRDwWS0dIqrHUVIP+bpKWGPZn4hkrhsd9DgBraYZR8REGM6F1oUojHhPydlPN8pNLSbNJjfFj1SQUWxJPsFtpLQrEHMdKB2A7PVzVzta2cNxPhzcdVVE9yjHUT62t2iwUHNL0cDx876nDm8s2VlZ9ZyE+SBCAl2geGs12ajHjI9DQlbT5oT8y2F6hVuW54FwTcGjuT/y/xEPnTj/EgjlrA8+ClBcfXKjkLTm/8KrM0w2NbqicmzXqvYkdOYwYTkQ4/V+krO8uRPMvK0Ny/TN+ToGFRxVqfoYno76uEu206rnGDt2ndq5sLBYBosCbBr9T2NcKxpmE/UeSvwG7vrIRjXzpKau2VApaEIWp4kJ6MxsZMO6elwlcjx2/QjGI8Ms4zuxaIgfMIRbTqLnEfEQFuQlMYxKrhLZPV+serKzo3ohFRemf5EaON0mL0XsJZCywsD0Ku8B5uLbthOLYxib+CsxFvUc0NqHWZsIJPoKxe9gTy7M5mCMFet28T1TVbe3nb6cyUejxXStc/U4OuHxQ/HpqrWxLPYhW2+geRtD0cCPvDkvPptrixIVautGY0wZvM5iXeqMQCATlxFpig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into meminspect:
 - kallsyms_num_syms
 - kallsyms_offsets
 - kallsyms_names
 - kallsyms_token_table
 - kallsyms_token_index
 - kallsyms_markers
 - kallsyms_seqs_of_names

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/kallsyms.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index aec2f06858af..e71c085ec837 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -31,9 +31,18 @@
 #include <linux/kernel.h>
 #include <linux/bsearch.h>
 #include <linux/btf_ids.h>
+#include <linux/meminspect.h>
 
 #include "kallsyms_internal.h"
 
+MEMINSPECT_SIMPLE_ENTRY(kallsyms_num_syms);
+MEMINSPECT_AREA_ENTRY(kallsyms_offsets, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_names, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_token_table, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_token_index, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_markers, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_seqs_of_names, sizeof(void *));
+
 /*
  * Expand a compressed symbol data into the resulting uncompressed string,
  * if uncompressed string is too long (>= maxlen), it will be truncated,

-- 
2.53.0


