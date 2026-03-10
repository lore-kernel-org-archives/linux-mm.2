Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97EFFFD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8B06B0093; Tue, 10 Mar 2026 16:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5AD6B0095; Tue, 10 Mar 2026 16:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71766B00AD; Tue, 10 Mar 2026 16:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B81906B0093
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:20:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79A5A8B38D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:04 +0000 (UTC)
X-FDA: 84531269928.02.4773B9A
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id E4C9F18000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=dQMX6mcx;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=j+5dVYiP;
	spf=pass (imf16.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwRw+3zoZjJFAT1RlGDVUTiEW0Vv9n3Q33NYxUXFN4A=;
	b=qkvbze2LcDaXmmsYZilgAcMpXHuddc/VbmWPwH20CAdU0SNz7sZXwticRkcIxdGs2Q3mHA
	re5SJ6GkfoOOqxVUa3qiNEg8Vgzx6kJQ3I3Rbcye93on4uV9n0yPnnwknTdP3mWSV4+KOQ
	fjf6bT6ID3HBDaPrZfFWjhr3iGdn/BI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=dQMX6mcx;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=j+5dVYiP;
	spf=pass (imf16.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174002; a=rsa-sha256;
	cv=none;
	b=44pGiiEQQU93SyV/qNwVj7hoGM+0tXiqSYDYRz+Ux0o/ej9NppkFDnpR559ZJhaaHtofTA
	Ds2RBBmk62bdyrjjAAOpzN3xtQK4tLezwYgZ4kz/pVihWiIhSsmWwwYDnj0RTE4k1TpEtD
	mMIjCF5AdNQAOD5q9sXSLkQwZUoL9bc=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIutae3892938
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jwRw+3zoZjJFAT1RlGDVUTiEW0Vv9n3Q33NYxUXFN4A=; b=dQMX6mcxDTnvoa/5
	6ezJq8gaLhHuHHIlrq4Ort9DzKAPwveetu8AW4Oy25sQNHjoLOOgJpeqq6DLgk56
	Z4fZxQ9R+c6QPz8dhw/hjxDXSf1AAXXNx1Z6bff7ceMH0yS97r0jczO14/Fzn9rt
	uNW+QNmFwR33rUn8q8eXw4xLN/bvLzf6liC1pr4tRc7I5LCLc+R506+GhMe2+4ue
	yAIR03vvs7hR3z6Gc/EcmiU+A05oFTw3scor3R188D65kAH0gfflfg3pF15gJe1a
	y0hy9Z32/48hL+XnI6wBKuvrXPnlOkCfVmACKuygve42g5VpRNnBLb+Gox0D5Wtv
	vNRxDA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctkmystav-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:00 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c7385a1476aso3862274a12.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174000; x=1773778800; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jwRw+3zoZjJFAT1RlGDVUTiEW0Vv9n3Q33NYxUXFN4A=;
        b=j+5dVYiPTdjD1aVblcWZ73Jmbq2jGY+KLRc00N8YU5EE5sbeT7pA7U1CgtRDJKS3pg
         ZtkOTh/h9x+7MSUA3/G0EGQSXNbv14wFKtP4IUwQcuasWPGK2w62eoSsNMR8qdVtc4wx
         RlIeG4Wj8Grk1uj/yNpEruToa048dBv5gFfVe5MWH3rOWxSAUfVUV4/pM2ahLlQqI54E
         Qqpw7QnBL4OLl1fS7/MmV1kQrICbYuV/TqOiHpW7Gnk0UNNR4kkWoaGSaGw+bxEFwRSN
         r8mjX9/N5gC3WlezrHw0TFDZfppoEOa9UyeeBtFiIAZnH+FWxdeM+3RJFMFasIYoEhzu
         ne4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174000; x=1773778800;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jwRw+3zoZjJFAT1RlGDVUTiEW0Vv9n3Q33NYxUXFN4A=;
        b=sMylHbazXFYg8lwMfUTtHVo5AZ9nksG1dsitvfjBLEFTy2cTFX9miw6vbEFScDQZLG
         6yNsUFCKIXQUkqV2pYtDokwkXQFZ1QorKGhwj4udFou+MFDi9e5MkjNO+8+GL8PTwdH0
         l6vykpRASUMWfUVjqkanSUOnzfgodxMYzY6Nf5+fRbm4DTxbp/bqBh2pZtAgnF4os+tU
         jW9CGuD4iw244+ePZwJORhESm57fS/+VHmD8r7nzw56JAV5+7vPbns6/4eG9UofMGsXe
         /hEJ2sLiQYAo9/ZAUfYBLPrjF8npTEkfjDuJFr+/k272oxLu8JDkhTBSfvGQmvJ2V7ul
         Bcpw==
X-Forwarded-Encrypted: i=1; AJvYcCUu2dtdFmU8XRoI3qdfv3dT7kW44wdec8Jr16aeiBroSHbIrxncH+gUNWWB/OsKuxEpB+WNWAmWhg==@kvack.org
X-Gm-Message-State: AOJu0Yzcz4uKRQTg7jhZ2caqLfo8TMqyHroPiPUtlOtuVfEqYH+RBvOb
	FEsspiKN/UHi0FnXqnCJiaLUWJYpfylx2UyHpX6pnEGZW4l236vxjZtd8AAk2//cY3XKpylFXGr
	CzybeRTUruRKRuBHHCucKkdGoQw8S/BIPOu5KVP7krUvBC4gRClJgAg==
X-Gm-Gg: ATEYQzxNdux6Zp7GxIpdi2TklxmB4p9uKzhToXZzSCjhpxF2FrCfXaRjVeCiU/Hn609
	Zp0mkVNkJTq+v6tUT+LrqaqKy7bCfjG05xD4/FtNGtZG80PcBHB9JIJ45dpZVGeGgUFDpo0IkCc
	LmwW/1zrTItNvZbGdlPKJnfhKnXMSdj3NVNS+IeBYc+40Cc2Nwtu/+6x+Pux24Eh0FP7fJQn/as
	OSRNfdIYf3gSkikE7BinvifxLkd1yjQSNkggvJK7dcLextv7RE9l1aMAafwUSp+z68acXFLNnjq
	NDN2lGiCmvvVPoZ6sdg0jADEo0EuNLcpKD6myGNauzzLxts789zXH0XzfgUXSN4z2+iixPlvub7
	uH5FCcpw52Eih/S2Y8wNs2armizz196hNAszBa316NbvZFNXx
X-Received: by 2002:a05:6a00:1815:b0:821:853f:b9c3 with SMTP id d2e1a72fcca58-829f711ef2cmr141759b3a.58.1773173999756;
        Tue, 10 Mar 2026 13:19:59 -0700 (PDT)
X-Received: by 2002:a05:6a00:1815:b0:821:853f:b9c3 with SMTP id d2e1a72fcca58-829f711ef2cmr141718b3a.58.1773173999148;
        Tue, 10 Mar 2026 13:19:59 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:19:58 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:59 +0530
Subject: [PATCH v2 15/25] kallsyms: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-15-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1395;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=5cCBSBzKqX170EaIe747597hAIrIZlq0oNbXZtqGG78=;
 b=UEgcZFN6n/iIdr4I3xkl5ipDSF8TBMHCjSGi5uHecNqRszG5U0xLBoF7+wvpLEO5xpUvUFbNM
 ogRuwWUh8vDAQ/Ser3c0V3Ex5ozlIGE1K0yhFAi/PuDBiBB+xRCiu04
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=RYudyltv c=1 sm=1 tr=0 ts=69b07cf0 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=w68G1zR93E_Nt3437osA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: U5uQMQ9b7n6Mn2_sB93Fv1hJnL_8rKcS
X-Proofpoint-ORIG-GUID: U5uQMQ9b7n6Mn2_sB93Fv1hJnL_8rKcS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX9ene269Jrksq
 kBbsNQAwnKJETVOuw20KIJ+xUQFnNrV0MmJUidAgHrEC2Eau0jLTmHWpnKrbucD5J2ogsvQtBnp
 S8gSob2bQ8OmxEsClgyP5fJeQvZh5A7PJ4JF9pjgpHrL6dIJAy+5fPOggjNUmxns2/mHLUPwqIp
 groZYiMyGNfHISfNX1VOQ+pp7qbY58IJQTz4cFYpaDr+nlLN14W8vhneg/CIdFXDeueyw4wQsRK
 m58oiiofmsbAlwLaUFMtwXBrQw4lx2nfdkKTwbO4SQW8kkQneZHTwRUkNxN3GQmQ7yyQT/IUvp3
 wu80agtR8uixzJwgok8XAPbGSYK8b7IPjeG+UUKQb/9xsHmaaeyP6j49sb2jOFIBoVCU6O2T9Jq
 015+awpE5ZvYorK7gN/WKMCSLOTuvAmOp8BOoJOU279vQv7UZfNs9O6of1OD37e4f0fP5LQsQC7
 j9H1wD83SooDGpLbznw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspamd-Queue-Id: E4C9F18000D
X-Stat-Signature: gstkqwkmjpee5gojkemrjq6suiqoc7in
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773174001-646360
X-HE-Meta: U2FsdGVkX1+eTy3pc65UqJsvzpY3RcssoLuvpGE3H8bnrljSAR+e5qeHMz56tn+gosvpE2BPw30lB9lbJ0bjrynqEf2F9DKR7pXNYSvkhWCis+giJJKTIC+L/LsARu4M3mZ7BE7mdnjOOU8J4fPLpOaz5cCLEGpvn01qXIl1IYKi86FrcY6HmVS3RV1QWkw6xHm5uGZGjSIZadUk/6lmp77V21mV+kr0HJzCvKPilV7rFkzOdWJPIUMBRXdRfQ01icYe/pQaCXz+MzPHKZ2ekzCVyrdsl911k2G2ZBfFQV8IvAXZvame0+lpuao2WdvUBH6LTss9Fl8aU7uNjGe3zwZsE7r6W45zl7+6gt7oqL3xjnIlHrGry7L7DhbPcR5jyYDrTr3eA8sb76PidbyAjIfATnbtP9UZJYjD1ADVGiTZd5zPjBuVcbxqOpgc5XExVNqLAM3vdg/ik/Iwbxc2igv9uHFnca3aEOjjv9RI/GV8jx2XspZo8uRgBV2UGTxk4SVqFnZGWf36yGGPARz6KaGnUWEaGiC8Ay5gKxrnPGD+C5ydzHXxB2ufzrp3VfuDxW06UIQCdJ+n+7Oe9mY4WH91g4MK4rJIKlVcpOEprgY7gDm6M9M5NngXohRB/v+uuYuAM97SPPFyVOVJetSWmFzL/XEXaqH8sz8AYtrWLiM8zn/RDaircat+NHkVotpK0rr1rPZHuXNqcCj4HrMV72g5R82djrrsUog76rVG86OoRhf0ucy7Pe8phD1WTgYlA9EJwVA0BpPFnvc3Vnmc9a1gK9iGQ3C1akdkuHV9s2y66cLE+bnm0cUbaBie/0WQ4dPFhNUr8mxVEV+ccjYukW37Z/+20KikDHE0FYVI/AIaE14Yf0zQCySeWQSToStyUNXTiZ3MPK0AnFP+Vhlea5OYq9H0xutKigp/K1mBEd6sGUSFfuO6iS35CCLr/DOopsqquKWzijkKtGxkGJu
 VdU1QD7k
 72V+hs6ilyVvWWxBh1cevFu7dhtoces7BSQiXl7BOKclONUXP4DtQobgl8G4cbrVDZv4BYz7t2RjTxi+uYTQuyW4+8yBvt8212VLMoQxDkO7//bGvCUGUyTR/satwFbJRPwoel2bBEsqM7bpBBLEiIWHcMZDXSLNbJ9tOmmZaqjjBS2ITOUnsc80FrkgaND//vTShfJ2aCTgexjYRe0bjLemVVSFQ7EUl1oDIBnmoR24pb+J3WV4gmnnSeX/vu0IQTdVVqwVf6YdX/dC0K/pHqao6lfWn80Nfrb3oSKaQdGeS0nqMWZ+DOILU5uuhPLDWYD1A2SYG/lX7m1PKp6xXsRUK9xTogkTY5lPl2RqvtYs+iz/pObyOPZyS60Jr67FZTycenLgng6kaQ4HU9NfKhD066cnejkxag4FQoolKsTwb92Ygevkv91k7lQB2trmKS2sSMczrP7b3xXFPZt53RPvPK1fi/VRP/wTS0hfTzhO6D8cPvGOruYjG29VrVNUaUoflMxH3M/OgScUwmRM6q9M4B2Hszw2KxqZn5FegPOIbzDO8GQEGz6bmErT9+HjjG8/vB9LsfHOY9HiL+W1OZZa7lu/D4JNUpEDw8eSvtxt5JqqnixMdn81/4tqDmO4uOrhMaj8PZcgte+aj9h0X5cr0DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into meminspect:
 - kallsysms_num_syms
 - kallsysms_offsets
 - kallsysms_names
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
2.50.1


