Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDF8FD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1676B0089; Tue, 10 Mar 2026 16:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485DA6B008A; Tue, 10 Mar 2026 16:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325D46B008C; Tue, 10 Mar 2026 16:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9436B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:16:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC3578B436
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:34 +0000 (UTC)
X-FDA: 84531261108.09.1463062
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3D8A080004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=F0PiB3g5;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="Y/6K+djk";
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEYB6VKT1KWHwAwuDUOWGOxEw4U6bCRjq97SLIyOJjc=;
	b=Rr8AsCQxguJoeOMzP0S2ywMZN5IiZpWQ/U6uQY2dhyNuSOphJx+uMSsf/s0OcGHJxCYRsZ
	wAKOLK7DAO1hMVzWj7A3TI0WJibL3UrbSSG39oIA6kZ4oxp2iJ7Pwhqzd3xBthqypKQYBS
	BHX3ZtPoOtNO4BTrxS/hwP0i77GK2Tk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=F0PiB3g5;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="Y/6K+djk";
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173792; a=rsa-sha256;
	cv=none;
	b=HM2c7x8rivs349UrjiC+4KXD5aS2GVR7Q5dZqTzTtiRJj3s9V+2W/UJWffaSoHEaXeHFkz
	SBn3N99PGZqYDUqaf2FfuIGrE0Lolmvcacvw4CJ6eFjf/EE034Vo0cVe2V1xxFMtyzssWk
	KLM9WiMYePGGNQWR+YI03eGseMSg03o=
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AHCqPP1573018
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sEYB6VKT1KWHwAwuDUOWGOxEw4U6bCRjq97SLIyOJjc=; b=F0PiB3g505PlHsEv
	/FfXQuqjlz1b7OzSSGDVCaC4OWcwfW60ElZZ+qY1JzLR7/0aXvlOR5B46nQbni3z
	WfXFPHtWk1fQG2IAbTAWQtwZ8rO6JpS+ZOW3bHzWwFw5CHdpOxwMs1cjmkSlhqBr
	+ShMCN/wOnTuUGCnSCsGdgY52zeAEk2yZ9C1MZPpO9YeD26QJEVCt+/Nm0x/rMp6
	NzGfo262gRVIlNd0nKgafcleCFKUA5BneqOeXQXT0RmGf0LOZR95SgF7rCLCeHYR
	HiRnjR+7TkXzja1v5jm0wxGgu+zrOQdbw7K+ZX4SmrWOZakMDfgUDzohJ89BrkJ9
	UJDBzQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctqgk8ngr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:30 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-829ae358238so1660323b3a.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173788; x=1773778588; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEYB6VKT1KWHwAwuDUOWGOxEw4U6bCRjq97SLIyOJjc=;
        b=Y/6K+djkpQuaf3Zsy8IzTjj1qGcyhgSKUwk6j7jn4jyf131dOLpgBgqnbf+yLvsKF2
         nQKF29lNMWkvcAcygDkDFvbLTdqH2XdOhwp5TKxIN2nNA7Rx4m/VJ3IqoHhfguhmmGOS
         /47i92NxXFBP/BWjVKkZdP/NgSbGmcG5x0j1JhoY5JeWDd/xZayROZpl7WrZZoOfpR55
         hgsgjXmRlDQpp70fNwoqT+FDmdNkmA/Mnr3BABxZKu/02S7bEmulCBO0Qvv4Er0IKHHq
         VCWpDmEVoc/RHSnPmPaR/IbNA0riJ6eXiRXaWieQ9/u3JpNC0SQdp8Qn39LzxVKh1yuK
         0/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173788; x=1773778588;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sEYB6VKT1KWHwAwuDUOWGOxEw4U6bCRjq97SLIyOJjc=;
        b=PxDIgBesUMHB5Q7eMGx94V/7t1D0feqXMs14n0keezWy6fIYEe6wbYyiEm2Zb/D5Bw
         DfdP7dOdek4C5/t90+oC0q3q8S2JfMYLlRCmKg4mDSGvXAXoxkF0G8EfBEa62LZuFHtM
         VyqYmrK5W2I2ONeqXbD+QsKYVGX0Xlfmj2kl3XXT1Z1hXv3dnpaOXHUweObITM6/c5G4
         gt9+RHSo72m/HWQamGelSZtVMnI4p4vkuUSqNyxRSP7QTm06JnjjZUCUJTRm6RaV5CPZ
         40OGMkDKsAmboQMQlw26O9/A2t6wngdxRtvlN3wxXobcsXmNpEgQmNQ0dw1K6S/g2rDZ
         B9nQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqd5pamOiql9lh+VOaUBNqvXTuQ6jad8GjJ4gfkJm2lJbMfa3MZk1JRQ3ArqShykVXs8SrHSWm5g==@kvack.org
X-Gm-Message-State: AOJu0YyOYi+2pa+RXtL1R8N0XU5SKZqcjAxoSF3esZ1sDHh2knX32ewi
	GY2/Vs71VQaIP+4zVSor2aPynRwEV/zx1Vy4Q+ZQOuFeNHLif83z03vl90IYTQm1N3d9WZyCklM
	TZNxyGBJSiKg1xDgHUJxicO9Ae9auU7jvvFMmoEOBRVYZl5Vtpjb4FQ==
X-Gm-Gg: ATEYQzz2GTUIhOhwks9xtE98K06nEHaofpbbRrDysRzz4XGEKVYkwsD0y5XpZoQN7+q
	cpGb+UnQRBtOgsmUcvdwkNtEvF7NQrc9sU5uSs9EN0+EpGdNOdDULHjgYh5LTRzr2STtCShUpN4
	tBlfqKEpK91uJj+qRxRY7HEfk8U40Q5a9BMprm3qQf+eZq3ljYxwLsC9QPNPaueLtG9k9gmTx2p
	aYKYnweNrzNo3v5L9xnxrL2E+UXf0laSlpdvwUssg7+88fTKTtqX9OG60O90k5LjGAsg5FHz5RB
	NEYiqXwdD0hNK/fdQX6vS2jKwgCLj8N7NyFsfwOq/2mOmUC0gs5ZAsYiwLOu3GKj2GjBw56H+PP
	9+TASKQUeEjaa0+bYjLgfDrOdivVwhnWO3WSx8S4H9/v02NT0
X-Received: by 2002:a05:6a00:4c8f:b0:829:7089:cf89 with SMTP id d2e1a72fcca58-829f6e6b7e8mr162434b3a.4.1773173787687;
        Tue, 10 Mar 2026 13:16:27 -0700 (PDT)
X-Received: by 2002:a05:6a00:4c8f:b0:829:7089:cf89 with SMTP id d2e1a72fcca58-829f6e6b7e8mr162400b3a.4.1773173786847;
        Tue, 10 Mar 2026 13:16:26 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:16:26 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:45 +0530
Subject: [PATCH v2 01/25] kernel: Introduce meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-1-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=32123;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=kcCVU0FW5js6m4ByUjHJGpd7DgYFseMUP3qupxG3ysY=;
 b=3DLqst1EbPyajPBOlb1UuPP5oYpN9EFCWX6jEiru5k4rbd+6EmXywzI5pB3pJvhX72pjJ2YC+
 6QyF+STETc9AgLDfMWYaejhXEA4vV9V/p52kS6pTmPLcj5FU/LmQdNg
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: l7Xt5qtlz3C7x_idDj3053lYr6uh9V62
X-Proofpoint-ORIG-GUID: l7Xt5qtlz3C7x_idDj3053lYr6uh9V62
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NiBTYWx0ZWRfX/hxtwBsKBMmM
 BNiuHqtMhqbMkRbHe3clmnqBIA3XDKXlSyt8o/M9CYKrvaFGpcqfobYQ1QsYdApio9yoq0+9jVQ
 Bdl16gYiMRgrosKAw8v/nRtKFSHb42G0bnWS0FvXZL73+1U//2cCxRNKTDaRsx87Q22ClRUaS6V
 ZnGJ7l5IKYnrTdfj+iv3V2znjhLdZ/RJR1XikXPHfykMWhr9x8CtfFIDZL2Jra1l5SQ1k7rk1LN
 Sa8OlRKJGgcquwToEqQ4vLlygEj5dw0Vc5OCz/sdG0Yx7Y9YPpIJIxSZ+bZG+Lyv0flUGxQcdir
 cRMXhLlvxYGxhTwEWD8ExDqdrjj2jZ4RK68I1pQd64AV8n17V1tfOOQXCycCU/ahgB0IMryHYnv
 IAKmLhR76uD2ZgjgSXtpuSJgc+/TgVgGBtFMXFXbsikc5e8nfj/pc73Hhq3zBU0LWmEXD9A4w2/
 K/4VSw3DOXxM+cROxIw==
X-Authority-Analysis: v=2.4 cv=M4JA6iws c=1 sm=1 tr=0 ts=69b07c1f cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=37rDS-QxAAAA:8
 a=-C0oUgKtVeSR-ImVawgA:9 a=vK0BWnVuOUyhPZmb:21 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22 a=cvBusfyB2V15izCimMoJ:22 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 adultscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100176
X-Stat-Signature: rfyhwfr9o9twi1ihhdu1gip66kxn99o7
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D8A080004
X-HE-Tag: 1773173792-126733
X-HE-Meta: U2FsdGVkX1+5kcWIZ4sPWu1ilRGtJ5UrbCvPMckDcsP8rfzcUyvVgHmNQ/QOFJHp7zxCAy15bIbtnEdvpeGqUrqNyCLno1khTuLTkcwHhTlLKQd9qPtT55zfqUwYeA6v8DucZjcZ4IYknNZAcAoHM7SRGxZ/2mUPfzWPjAgQgaUEmH3A5Yh9Z1fJQY3IKfthteeZd8r9+uSAr58YwI91O/MjeJbqQ1BrkVcgoD2ufJDYE5FpehlbV0tJYGd2ZBfhiQl6XGSVTcMcirvlcafBGpSzG+il7WPjPcA3uKRyk0xqqWcAgrtjAIY2U87bgXvOPmkCu9DMFBpedTqx7Zb7rxXDzM+8RUbFdbMVwF8z8EyWMSCurzzglePmufA8pWE+1eecE0fPS2gtdxrLg3Z5KNrfsjIuLcqIcscFwDeO3mfqYYJiJnmvsaLaqaWBmeyvHfxAmk8mbb2tdUxGeucRfcA5DVfdi1by3LpwxEEkGMkSkr0D/+3nUBpNDxZBl0lRYfPFidcA56KNCowF7WecQ+XWa8tGqs6JLdUPi+rkyROHACSKNpT6XQyk7mQMOti6R6rP3G8fag90SQAd7BT6d8oYE/cBxCSqs2ZMI2nGOZbHpBQfbCWnrJpTtBlgFV0anrBts3ZQ92n3mZhgcU3JXyd6ZmFgxpjK5xS2GS2XRfrkLc5EV21b+gRID6YSmy0xJzSHSo/2DDNMuFH2bSXNkx8X9d78x8VAj1n0tAlirnDLpO5XhYskmTwwFeKV9rLKYk1f5mzVdHPFn7JOGOMwjoaoPnr1poFVMg1hyFQGaCzppUdwqWkifHepK34kPibiqNrptyn9ZSuAD1E83lXcfc1kpAoSeeEwuVOqVLBpg2pjYKq6Yidejfp+NL5K8r52BgoGQMkjrvUvgs1X4VYveVJ/kjn1/ozdU9jxvsoOtzCqw2OUo2DWxI6PN7/hgs4IF/Ew0V5FbTl3iLEY5gZ
 lxmA1mwu
 EWGk43tM3QeTTCxr/W1sIimJDdE0N4qOFXZtpPqKhq6LDadlX09ogh+/OJ0jdt3iVcbFYKmP/EdmcF+FtI4uFOqXul5KfL/0h/z9z8XUdcXavuYcIEESm77Vz7d1nDYps34bUbEKYEBuAARUNxnN/BLWP9/ZvoQIxb2PMkJAVLoRL9hIMUJrYmXBEUxZL5rx6WTnR1c5r+YN/x/jEJv8cy9rb1eBaZ/THEnRouTcZesa10lTfCnfaDTgFf107DcJxOyZlx0fbwa3DsYKQqqJDO++BRhbosTMgR2OYPJOJHSzyZbu5tdBCKeSWhROpL9lwMaiTW/W/SW7BFI9BwGDxS62sAP0oJWbITH/cWMQCD9gZubD8k7mfu/5paehV65FYRbHFJPP7uNN04+6Fhgwyj12//MGsQVE+RL+aFtlqccgpTVcTYw8IvaoHQSgHLXMT0mEc3b0x6Z4GdxGG5S4Qv8gixSufPehwOJUs23cRJwvWs12HLVo+P34oaWfBCSrb5sWaTh0128rLWWXH/XYRsfx24EwPGQ+9I5Wsh5SG3JRGK1w43z6MgTpvMhfNlYXnGHj8/S+r2y9lWbUTDlRUvkqtOqzvo33W7GhQI14PyzQK4SH/MRfp38m5iwF0PvpBss4vrnp9iXv1Z5igpKdygS25R3CX74hNbfqCZQwBG4brSGJmFsEll0USR5vzWup1H3w9EFzwl43SdmDLeMm3OPTs7gUSd+wKr0g6jJ+3TnuySvFs4eZQjXR4vrtYARN5igBoV8gGEWpbJhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Inspection mechanism allows registration of a specific memory area(or
object) for later inspection purpose. Ranges are being added into an
inspection table, which can be requested and analyzed by specific
drivers. Drivers would interface any hardware mechanism that will allow
inspection of the data, including but not limited to: dumping for
debugging, creating a coredump, analysis, or statistical information.
Drivers can register a notifier to know when new objects are registered,
or to traverse existing inspection table. Inspection table is created
ahead of time such that it can be later used regardless of the state of
the kernel (running, frozen, crashed, or any particular state).

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 Documentation/dev-tools/index.rst      |   1 +
 Documentation/dev-tools/meminspect.rst | 144 ++++++++++
 MAINTAINERS                            |   7 +
 include/asm-generic/vmlinux.lds.h      |  13 +
 include/linux/meminspect.h             | 263 ++++++++++++++++++
 init/Kconfig                           |   1 +
 kernel/Makefile                        |   1 +
 kernel/meminspect/Kconfig              |  19 ++
 kernel/meminspect/Makefile             |   3 +
 kernel/meminspect/meminspect.c         | 471 +++++++++++++++++++++++++++++++++
 10 files changed, 923 insertions(+)

diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 59cbb77b33ff..ea2989ca1566 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -40,3 +40,4 @@ Documentation/process/debugging/index.rst
    autofdo
    propeller
    container
+   meminspect
diff --git a/Documentation/dev-tools/meminspect.rst b/Documentation/dev-tools/meminspect.rst
new file mode 100644
index 000000000000..d0c7222bdcd7
--- /dev/null
+++ b/Documentation/dev-tools/meminspect.rst
@@ -0,0 +1,144 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========
+meminspect
+==========
+
+This document provides information about the meminspect feature.
+
+Overview
+========
+
+meminspect is a mechanism that allows the kernel to register a chunk of
+memory into a table, to be used at a later time for a specific
+inspection purpose like debugging, memory dumping or statistics.
+
+meminspect allows drivers to traverse the inspection table on demand,
+or to register a notifier to be called whenever a new entry is being added
+or removed.
+
+The reasoning for meminspect is also to minimize the required information
+in case of a kernel problem. For example a traditional debug method involves
+dumping the whole kernel memory and then inspecting it. Meminspect allows the
+users to select which memory is of interest, in order to help this specific
+use case in production, where memory and connectivity are limited.
+
+Although the kernel has multiple internal mechanisms, meminspect fits
+a particular model which is not covered by the others.
+
+meminspect Internals
+====================
+
+API
+---
+
+Static memory can be registered at compile time, by instructing the compiler
+to create a separate section with annotation info.
+For each such annotated memory (variables usually), a dedicated struct
+is being created with the required information.
+To achieve this goal, some basic APIs are available:
+
+* MEMINSPECT_ENTRY(idx, sym, sz)
+  is the basic macro that takes an ID, the symbol, and a size.
+
+To make it easier, some wrappers are also defined
+
+* MEMINSPECT_SIMPLE_ENTRY(sym)
+  will use the dedicated MEMINSPECT_ID_##sym with a size equal to sizeof(sym)
+
+* MEMINSPECT_NAMED_ENTRY(name, sym)
+  will be a simple entry that has an id that cannot be derived from the sym,
+  so a name has to be provided
+
+* MEMINSPECT_AREA_ENTRY(sym, sz)
+  this will register sym, but with the size given as sz, useful for e.g.
+  arrays which do not have a fixed size at compile time.
+
+For dynamically allocated memory, or for other cases, the following APIs
+are being defined::
+
+  meminspect_register_id_pa(enum meminspect_uid id, phys_addr_t zone,
+                            size_t size, unsigned int type);
+
+which takes the ID and the physical address.
+
+Similarly there are variations:
+
+ * meminspect_register_pa() omits the ID
+ * meminspect_register_id_va() requires the ID but takes a virtual address
+ * meminspect_register_va() omits the ID and requires a virtual address
+
+If the ID is not given, the next avialable dynamic ID is allocated.
+
+To unregister a dynamic entry, some APIs are being defined:
+ * meminspect_unregister_pa(phys_addr_t zone, size_t size);
+ * meminspect_unregister_id(enum meminspect_uid id);
+ * meminspect_unregister_va(va, size);
+
+All of the above have a lock variant that ensures the lock on the table
+is taken.
+
+
+meminspect drivers
+------------------
+
+Drivers are free to traverse the table by using a dedicated function::
+
+ meminspect_traverse(void *priv, MEMINSPECT_ITERATOR_CB cb)
+
+The callback will be called for each entry in the table.
+
+Drivers can also register a notifier with meminspect_notifier_register()
+and unregister with meminspect_notifier_unregister() to be called when a new
+entry is being added or removed.
+
+Data structures
+---------------
+
+The regions are being stored in a simple fixed size array. It avoids
+memory allocation overhead. This is not performance critical nor does
+allocating a few hundred entries create a memory consumption problem.
+
+The static variables registered into meminspect are being annotated into
+a dedicated .inspect_table memory section. This is then walked by meminspect
+at a later time and each variable is then copied to the whole inspect table.
+
+meminspect Initialization
+-------------------------
+
+At any time, meminspect will be ready to accept region registration
+from any part of the kernel. The table does not require any initialization.
+In case CONFIG_CRASH_DUMP is enabled, meminspect will create an ELF header
+corresponding to a core dump image, in which each region is added as a
+program header. In this scenario, the first region is this ELF header, and
+the second region is the vmcoreinfo ELF note.
+By using this mechanism, all the meminspect table, if dumped, can be
+concatenated to obtain a core image that is loadable with the `crash` tool.
+
+meminspect example
+==================
+
+A simple scenario for meminspect is the following:
+The kernel registers the linux_banner variable into meminspect with
+a simple annotation like::
+
+  MEMINSPECT_SIMPLE_ENTRY(linux_banner);
+
+The meminspect late initcall will parse the compilation time created table
+and copy the entry information into the inspection table.
+At a later point, any interested driver can call the traverse function to
+find out all entries in the table.
+A specific driver will then note into a specific table the address of the
+banner and the size of it.
+The specific table is then written to a shared memory area that can be
+read by upper level firmware.
+When the kernel freezes (hypothetically), the kernel will no longer feed
+the watchdog. The watchdog will trigger a higher exception level interrupt
+which will be handled by the upper level firmware. This firmware will then
+read the shared memory table and find an entry with the start and size of
+the banner. It will then copy it for debugging purpose. The upper level
+firmware will then be able to provide useful debugging information,
+like in this example, the banner.
+
+As seen here, meminspect facilitates the interaction between the kernel
+and a specific firmware.
diff --git a/MAINTAINERS b/MAINTAINERS
index 1121276c59a1..ebf478dbd15c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16585,6 +16585,13 @@ F:	arch/*/include/asm/sync_core.h
 F:	include/uapi/linux/membarrier.h
 F:	kernel/sched/membarrier.c
 
+MEMINSPECT
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+S:	Maintained
+F:	Documentation/dev-tools/meminspect.rst
+F:	include/linux/meminspect.h
+F:	kernel/meminspect/*
+
 MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1e1580febe4b..a41536b310a5 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -506,6 +506,8 @@
 	FW_LOADER_BUILT_IN_DATA						\
 	TRACEDATA							\
 									\
+	MEMINSPECT_TABLE						\
+									\
 	PRINTK_INDEX							\
 									\
 	/* Kernel symbol table: Normal symbols */			\
@@ -911,6 +913,17 @@
 #define TRACEDATA
 #endif
 
+#ifdef CONFIG_MEMINSPECT
+#define MEMINSPECT_TABLE						\
+	. = ALIGN(8);							\
+	.inspect_table : AT(ADDR(.inspect_table) - LOAD_OFFSET) {	\
+		BOUNDED_SECTION_POST_LABEL(.inspect_table,		\
+					   __inspect_table, , _end) \
+	}
+#else
+#define MEMINSPECT_TABLE
+#endif
+
 #ifdef CONFIG_PRINTK_INDEX
 #define PRINTK_INDEX							\
 	.printk_index : AT(ADDR(.printk_index) - LOAD_OFFSET) {		\
diff --git a/include/linux/meminspect.h b/include/linux/meminspect.h
new file mode 100644
index 000000000000..f09cfcef62c2
--- /dev/null
+++ b/include/linux/meminspect.h
@@ -0,0 +1,263 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MEMINSPECT_H
+#define _MEMINSPECT_H
+
+#include <linux/io.h>
+#include <linux/notifier.h>
+
+enum meminspect_uid {
+	MEMINSPECT_ID_STATIC = 0,
+	MEMINSPECT_ID_ELF,
+	MEMINSPECT_ID_VMCOREINFO,
+	MEMINSPECT_ID_CONFIG,
+	MEMINSPECT_ID__totalram_pages,
+	MEMINSPECT_ID___cpu_possible_mask,
+	MEMINSPECT_ID___cpu_present_mask,
+	MEMINSPECT_ID___cpu_online_mask,
+	MEMINSPECT_ID___cpu_active_mask,
+	MEMINSPECT_ID_mem_section,
+	MEMINSPECT_ID_jiffies_64,
+	MEMINSPECT_ID_linux_banner,
+	MEMINSPECT_ID_nr_threads,
+	MEMINSPECT_ID_nr_irqs,
+	MEMINSPECT_ID_tainted_mask,
+	MEMINSPECT_ID_taint_flags,
+	MEMINSPECT_ID_node_states,
+	MEMINSPECT_ID___per_cpu_offset,
+	MEMINSPECT_ID_nr_swapfiles,
+	MEMINSPECT_ID_init_uts_ns,
+	MEMINSPECT_ID_printk_rb_static,
+	MEMINSPECT_ID_printk_rb_dynamic,
+	MEMINSPECT_ID_prb,
+	MEMINSPECT_ID_prb_descs,
+	MEMINSPECT_ID_prb_infos,
+	MEMINSPECT_ID_prb_data,
+	MEMINSPECT_ID_high_memory,
+	MEMINSPECT_ID_init_mm,
+	MEMINSPECT_ID_init_mm_pgd,
+	MEMINSPECT_ID__sinittext,
+	MEMINSPECT_ID__einittext,
+	MEMINSPECT_ID__end,
+	MEMINSPECT_ID__text,
+	MEMINSPECT_ID__stext,
+	MEMINSPECT_ID__etext,
+	MEMINSPECT_ID_kallsyms_num_syms,
+	MEMINSPECT_ID_kallsyms_relative_base,
+	MEMINSPECT_ID_kallsyms_offsets,
+	MEMINSPECT_ID_kallsyms_names,
+	MEMINSPECT_ID_kallsyms_token_table,
+	MEMINSPECT_ID_kallsyms_token_index,
+	MEMINSPECT_ID_kallsyms_markers,
+	MEMINSPECT_ID_kallsyms_seqs_of_names,
+	MEMINSPECT_ID_swapper_pg_dir,
+	MEMINSPECT_ID_DYNAMIC,
+	MEMINSPECT_ID_MAX = 201,
+};
+
+#define MEMINSPECT_TYPE_REGULAR		0
+
+#define MEMINSPECT_NOTIFIER_ADD		0
+#define MEMINSPECT_NOTIFIER_REMOVE	1
+
+/**
+ * struct inspect_entry - memory inspect entry information
+ * @id: unique id for this entry
+ * @va: virtual address for the memory (pointer)
+ * @pa: physical address for the memory
+ * @size: size of the memory area of this entry
+ * @type: type of the entry (class)
+ */
+struct inspect_entry {
+	enum meminspect_uid	id;
+	void			*va;
+	phys_addr_t		pa;
+	size_t			size;
+	unsigned int		type;
+};
+
+typedef void (*MEMINSPECT_ITERATOR_CB)(void *priv, const struct inspect_entry *ie);
+
+#ifdef CONFIG_MEMINSPECT
+/* .inspect_table section table markers*/
+extern const struct inspect_entry __inspect_table[];
+extern const struct inspect_entry __inspect_table_end[];
+
+/*
+ * Annotate a static variable into inspection table.
+ * Can be called multiple times for the same ID, in which case
+ * multiple table entries will be created
+ */
+#define MEMINSPECT_ENTRY(idx, sym, sz)						\
+	static const struct inspect_entry __UNIQUE_ID(__inspect_entry_##idx)	\
+	__used __section(".inspect_table") = {					\
+		.id = idx,							\
+		.va = (void *)&(sym),						\
+		.size = (sz),							\
+	}
+/*
+ * A simple entry is just a variable, the size of the entry is the variable size
+ * The variable can also be a pointer, the pointer itself is being added in this
+ * case.
+ */
+#define MEMINSPECT_SIMPLE_ENTRY(sym)	\
+	MEMINSPECT_ENTRY(MEMINSPECT_ID_##sym, sym, sizeof(sym))
+/*
+ * In the case when `sym` is not a variable, but a member of a struct e.g.,
+ * and we cannot derive a name from it, a name must be provided.
+ */
+#define MEMINSPECT_NAMED_ENTRY(name, sym)	\
+	MEMINSPECT_ENTRY(MEMINSPECT_ID_##name, sym, sizeof(sym))
+/*
+ * Create a more complex entry, by registering an arbitrary memory starting
+ * at sym. The size is provided as a parameter.
+ * This is used e.g. when the symbol is a start of an unknown sized array.
+ */
+#define MEMINSPECT_AREA_ENTRY(sym, sz) \
+	MEMINSPECT_ENTRY(MEMINSPECT_ID_##sym, sym, sz)
+
+/* Iterate through .inspect_table section entries */
+#define for_each_meminspect_entry(__entry)		\
+	for (__entry = __inspect_table;			\
+	     __entry < __inspect_table_end;		\
+	     __entry++)
+
+#else
+#define MEMINSPECT_ENTRY(...)
+#define MEMINSPECT_SIMPLE_ENTRY(...)
+#define MEMINSPECT_NAMED_ENTRY(...)
+#define MEMINSPECT_AREA_ENTRY(...)
+#endif
+
+#ifdef CONFIG_MEMINSPECT
+
+/*
+ * Dynamic helpers to register entries.
+ * These do not lock the table, so use with caution.
+ */
+void meminspect_register_id_pa(enum meminspect_uid id, phys_addr_t zone,
+			       size_t size, unsigned int type);
+void meminspect_table_lock(void);
+void meminspect_table_unlock(void);
+
+#define meminspect_register_pa(...) \
+	meminspect_register_id_pa(MEMINSPECT_ID_DYNAMIC, __VA_ARGS__, MEMINSPECT_TYPE_REGULAR)
+
+#define meminspect_register_id_va(id, va, size) \
+	meminspect_register_id_pa(id, virt_to_phys(va), size, MEMINSPECT_TYPE_REGULAR)
+
+#define meminspect_register_va(...) \
+	meminspect_register_id_va(MEMINSPECT_ID_DYNAMIC, __VA_ARGS__)
+
+void meminspect_unregister_pa(phys_addr_t zone, size_t size);
+void meminspect_unregister_id(enum meminspect_uid id);
+
+#define meminspect_unregister_va(va, size) \
+	meminspect_unregister_pa(virt_to_phys(va), size)
+
+void meminspect_traverse(void *priv, MEMINSPECT_ITERATOR_CB cb);
+
+/*
+ * Producers, or registrators, are advised to use the locked API below
+ */
+#define meminspect_lock_register_pa(...)		\
+	{						\
+		meminspect_table_lock();		\
+		meminspect_register_pa(__VA_ARGS__);	\
+		meminspect_table_unlock();		\
+	}
+
+#define meminspect_lock_register_id_va(...)		\
+	{						\
+		meminspect_table_lock();		\
+		meminspect_register_id_va(__VA_ARGS__);	\
+		meminspect_table_unlock();		\
+	}
+
+#define meminspect_lock_register_va(...)		\
+	{						\
+		meminspect_table_lock();		\
+		meminspect_register_va(__VA_ARGS__);	\
+		meminspect_table_unlock();		\
+	}
+
+#define meminspect_lock_unregister_pa(...)		\
+	{						\
+		meminspect_table_lock();		\
+		meminspect_unregister_pa(__VA_ARGS__);	\
+		meminspect_table_unlock();		\
+	}
+
+#define meminspect_lock_unregister_va(...)		\
+	{						\
+		meminspect_table_lock();		\
+		meminspect_unregister_va(__VA_ARGS__);	\
+		meminspect_table_unlock();		\
+	}
+
+#define meminspect_lock_unregister_id(...)		\
+	{						\
+		meminspect_table_lock();		\
+		meminspect_unregister_id(__VA_ARGS__);	\
+		meminspect_table_unlock();		\
+	}
+
+#define meminspect_lock_traverse(...)			\
+	{						\
+		meminspect_table_lock();		\
+		meminspect_traverse(__VA_ARGS__);	\
+		meminspect_table_unlock();		\
+	}
+
+int meminspect_notifier_register(struct notifier_block *n);
+int meminspect_notifier_unregister(struct notifier_block *n);
+
+#else
+static inline void meminspect_register_id_pa(enum meminspect_uid id,
+					     phys_addr_t zone,
+					     size_t size, unsigned int type)
+{
+}
+
+static inline void meminspect_table_lock(void)
+{
+}
+
+static inline void meminspect_table_unlock(void)
+{
+}
+
+static inline void meminspect_unregister(phys_addr_t zone, size_t size)
+{
+}
+
+static inline void meminspect_unregister_id(enum meminspect_uid id)
+{
+}
+
+static inline void meminspect_traverse(MEMINSPECT_ITERATOR_CB cb)
+{
+}
+
+static inline int meminspect_notifier_register(struct notifier_block *n)
+{
+	return 0;
+}
+
+static inline int meminspect_notifier_unregister(struct notifier_block *n)
+{
+	return 0;
+}
+
+#define meminspect_register_pa(...)
+#define meminspect_register_id_va(...)
+#define meminspect_register_va(...)
+#define meminspect_lock_register_pa(...)
+#define meminspect_lock_register_va(...)
+#define meminspect_lock_register_id_va(...)
+#define meminspect_lock_traverse(...)
+#define meminspect_lock_unregister_va(...)
+#define meminspect_lock_unregister_pa(...)
+#define meminspect_lock_unregister_id(...)
+#endif
+
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index ebdd3b9d3394..23848994f97e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2231,6 +2231,7 @@ config TRACEPOINTS
 source "kernel/Kconfig.kexec"
 
 source "kernel/liveupdate/Kconfig"
+source "kernel/meminspect/Kconfig"
 
 endmenu		# General setup
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 6785982013dc..af532e0b4806 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -52,6 +52,7 @@ obj-y += locking/
 obj-y += power/
 obj-y += printk/
 obj-y += irq/
+obj-y += meminspect/
 obj-y += rcu/
 obj-y += livepatch/
 obj-y += liveupdate/
diff --git a/kernel/meminspect/Kconfig b/kernel/meminspect/Kconfig
new file mode 100644
index 000000000000..fa2b5a84b251
--- /dev/null
+++ b/kernel/meminspect/Kconfig
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config MEMINSPECT
+	bool "Allow the kernel to register memory regions for inspection purpose"
+	help
+	  Inspection mechanism allows registration of a specific memory
+	  area(or object) for later inspection purpose.
+	  Ranges are being added into an inspection table, which can be
+	  requested and analyzed by specific drivers.
+	  Drivers would interface any hardware mechanism that will allow
+	  inspection of the data, including but not limited to: dumping
+	  for debugging, creating a coredump, analysis, or statistical
+	  information.
+	  Inspection table is created ahead of time such that it can be later
+	  used regardless of the state of the kernel (running, frozen, crashed,
+	  or any particular state).
+
+	  Note that modules using this feature must be rebuilt if option
+	  changes.
diff --git a/kernel/meminspect/Makefile b/kernel/meminspect/Makefile
new file mode 100644
index 000000000000..09fd55e6d9cf
--- /dev/null
+++ b/kernel/meminspect/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_MEMINSPECT) += meminspect.o
diff --git a/kernel/meminspect/meminspect.c b/kernel/meminspect/meminspect.c
new file mode 100644
index 000000000000..be91a839f688
--- /dev/null
+++ b/kernel/meminspect/meminspect.c
@@ -0,0 +1,471 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/crash_core.h>
+#include <linux/dma-map-ops.h>
+#include <linux/vmcore_info.h>
+#include <linux/notifier.h>
+#include <linux/meminspect.h>
+
+static DEFINE_MUTEX(meminspect_lock);
+static struct inspect_entry inspect_entries[MEMINSPECT_ID_MAX];
+
+static ATOMIC_NOTIFIER_HEAD(meminspect_notifier_list);
+
+#ifdef CONFIG_CRASH_DUMP
+
+#define CORE_STR "CORE"
+
+static struct elfhdr *ehdr;
+static size_t elf_offset;
+static bool elf_hdr_ready;
+
+static void append_kcore_note(char *notes, size_t *i, const char *name,
+			      unsigned int type, const void *desc,
+			      size_t descsz)
+{
+	struct elf_note *note = (struct elf_note *)&notes[*i];
+
+	note->n_namesz = strlen(name) + 1;
+	note->n_descsz = descsz;
+	note->n_type = type;
+	*i += sizeof(*note);
+	memcpy(&notes[*i], name, note->n_namesz);
+	*i = ALIGN(*i + note->n_namesz, 4);
+	memcpy(&notes[*i], desc, descsz);
+	*i = ALIGN(*i + descsz, 4);
+}
+
+static void append_kcore_note_nodesc(char *notes, size_t *i, const char *name,
+				     unsigned int type, size_t descsz)
+{
+	struct elf_note *note = (struct elf_note *)&notes[*i];
+
+	note->n_namesz = strlen(name) + 1;
+	note->n_descsz = descsz;
+	note->n_type = type;
+	*i += sizeof(*note);
+	memcpy(&notes[*i], name, note->n_namesz);
+	*i = ALIGN(*i + note->n_namesz, 4);
+}
+
+static struct elf_phdr *elf_phdr_entry_addr(struct elfhdr *ehdr, int idx)
+{
+	struct elf_phdr *ephdr = (struct elf_phdr *)((size_t)ehdr + ehdr->e_phoff);
+
+	return &ephdr[idx];
+}
+
+static int clear_elfheader(const struct inspect_entry *e)
+{
+	struct elf_phdr *phdr;
+	struct elf_phdr *tmp_phdr;
+	unsigned int phidx;
+	unsigned int i;
+
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		phdr = elf_phdr_entry_addr(ehdr, i);
+		if (phdr->p_paddr == e->pa &&
+		    phdr->p_memsz == ALIGN(e->size, 4))
+			break;
+	}
+
+	if (i == ehdr->e_phnum) {
+		pr_debug("Cannot find program header entry in elf\n");
+		return -EINVAL;
+	}
+
+	phidx = i;
+
+	/* Clear program header */
+	tmp_phdr = elf_phdr_entry_addr(ehdr, phidx);
+	for (i = phidx; i < ehdr->e_phnum - 1; i++) {
+		tmp_phdr = elf_phdr_entry_addr(ehdr, i + 1);
+		phdr = elf_phdr_entry_addr(ehdr, i);
+		memcpy(phdr, tmp_phdr, sizeof(*phdr));
+		phdr->p_offset = phdr->p_offset - ALIGN(e->size, 4);
+	}
+	memset(tmp_phdr, 0, sizeof(*tmp_phdr));
+	ehdr->e_phnum--;
+
+	elf_offset -= ALIGN(e->size, 4);
+
+	return 0;
+}
+
+static void update_elfheader(const struct inspect_entry *e)
+{
+	struct elf_phdr *phdr;
+
+	phdr = elf_phdr_entry_addr(ehdr, ehdr->e_phnum++);
+
+	phdr->p_type = PT_LOAD;
+	phdr->p_offset = elf_offset;
+	phdr->p_vaddr = (elf_addr_t)e->va;
+	if (e->pa)
+		phdr->p_paddr = (elf_addr_t)e->pa;
+	else
+		phdr->p_paddr = (elf_addr_t)virt_to_phys(e->va);
+
+	phdr->p_filesz = ALIGN(e->size, 4);
+	phdr->p_memsz = ALIGN(e->size, 4);
+	phdr->p_flags = PF_R | PF_W;
+	elf_offset += ALIGN(e->size, 4);
+}
+
+/*
+ * This function prepares the elf header for the coredump image.
+ * Initially there is a single program header for the elf NOTE.
+ * The note contains the usual core dump information, and the vmcoreinfo.
+ */
+static int init_elfheader(void)
+{
+	struct elf_phdr *phdr;
+	void *notes;
+	unsigned int elfh_size, buf_sz;
+	unsigned int phdr_off;
+	size_t note_len, i = 0;
+	struct page *p;
+
+	struct elf_prstatus prstatus = {};
+	struct elf_prpsinfo prpsinfo = {
+		.pr_sname = 'R',
+		.pr_fname = "vmlinux",
+	};
+
+	/*
+	 * Header buffer contains:
+	 * ELF header, Note entry with PR status, PR ps info, and vmcoreinfo.
+	 * Also, MEMINSPECT_ID_MAX program headers.
+	 */
+	elfh_size = sizeof(*ehdr);
+	elfh_size += sizeof(struct elf_prstatus);
+	elfh_size += sizeof(struct elf_prpsinfo);
+	elfh_size += sizeof(VMCOREINFO_NOTE_NAME);
+	elfh_size += ALIGN(vmcoreinfo_size, 4);
+	elfh_size += (sizeof(*phdr)) * (MEMINSPECT_ID_MAX);
+
+	elfh_size = ALIGN(elfh_size, 4);
+
+	/* Length of the note is made of :
+	 * 3 elf notes structs (prstatus, prpsinfo, vmcoreinfo)
+	 * 3 notes names (2 core strings, 1 vmcoreinfo name)
+	 * sizeof each note
+	 */
+	note_len = (3 * sizeof(struct elf_note) +
+		    2 * ALIGN(sizeof(CORE_STR), 4) +
+		    VMCOREINFO_NOTE_NAME_BYTES +
+		    ALIGN(sizeof(struct elf_prstatus), 4) +
+		    ALIGN(sizeof(struct elf_prpsinfo), 4) +
+		    ALIGN(vmcoreinfo_size, 4));
+
+	buf_sz = elfh_size + note_len - ALIGN(vmcoreinfo_size, 4);
+
+	/* Never freed */
+	p = dma_alloc_from_contiguous(NULL, buf_sz >> PAGE_SHIFT,
+				      get_order(buf_sz), true);
+	if (!p)
+		return -ENOMEM;
+
+	ehdr = dma_common_contiguous_remap(p, buf_sz,
+					   pgprot_decrypted(pgprot_dmacoherent(PAGE_KERNEL)),
+					   __builtin_return_address(0));
+	if (!ehdr) {
+		dma_release_from_contiguous(NULL, p, buf_sz >> PAGE_SHIFT);
+		return -ENOMEM;
+	}
+
+	memset(ehdr, 0, elfh_size);
+
+	/* Assign Program headers offset, it's right after the elf header. */
+	phdr = (struct elf_phdr *)(ehdr + 1);
+	phdr_off = sizeof(*ehdr);
+
+	memcpy(ehdr->e_ident, ELFMAG, SELFMAG);
+	ehdr->e_ident[EI_CLASS] = ELF_CLASS;
+	ehdr->e_ident[EI_DATA] = ELF_DATA;
+	ehdr->e_ident[EI_VERSION] = EV_CURRENT;
+	ehdr->e_ident[EI_OSABI] = ELF_OSABI;
+	ehdr->e_type = ET_CORE;
+	ehdr->e_machine = ELF_ARCH;
+	ehdr->e_version = EV_CURRENT;
+	ehdr->e_ehsize = sizeof(*ehdr);
+	ehdr->e_phentsize = sizeof(*phdr);
+
+	elf_offset = elfh_size;
+
+	notes = (void *)(((char *)ehdr) + elf_offset);
+
+	/* we have a single program header now */
+	ehdr->e_phnum = 1;
+
+	phdr->p_type = PT_NOTE;
+	phdr->p_offset = elf_offset;
+	phdr->p_filesz = note_len;
+
+	/* advance elf offset */
+	elf_offset += note_len;
+
+	strscpy(prpsinfo.pr_psargs, saved_command_line,
+		sizeof(prpsinfo.pr_psargs));
+
+	append_kcore_note(notes, &i, CORE_STR, NT_PRSTATUS, &prstatus,
+			  sizeof(prstatus));
+	append_kcore_note(notes, &i, CORE_STR, NT_PRPSINFO, &prpsinfo,
+			  sizeof(prpsinfo));
+	append_kcore_note_nodesc(notes, &i, VMCOREINFO_NOTE_NAME, 0,
+				 ALIGN(vmcoreinfo_size, 4));
+
+	ehdr->e_phoff = phdr_off;
+
+	/* This is the first coredump region, the ELF header */
+	meminspect_register_id_pa(MEMINSPECT_ID_ELF, page_to_phys(p),
+				  buf_sz, MEMINSPECT_TYPE_REGULAR);
+
+	/*
+	 * The second region is the vmcoreinfo, which goes right after.
+	 * It's being registered through vmcoreinfo.
+	 */
+
+	return 0;
+}
+#endif
+
+/**
+ * meminspect_unregister_id() - Unregister region from inspection table.
+ * @id: region's id in the table
+ *
+ * Return: None
+ */
+void meminspect_unregister_id(enum meminspect_uid id)
+{
+	struct inspect_entry *e;
+
+	WARN_ON(!mutex_is_locked(&meminspect_lock));
+
+	e = &inspect_entries[id];
+	if (!e->id)
+		return;
+
+	atomic_notifier_call_chain(&meminspect_notifier_list,
+				   MEMINSPECT_NOTIFIER_REMOVE, e);
+#ifdef CONFIG_CRASH_DUMP
+	if (elf_hdr_ready)
+		clear_elfheader(e);
+#endif
+	memset(e, 0, sizeof(*e));
+}
+EXPORT_SYMBOL_GPL(meminspect_unregister_id);
+
+/**
+ * meminspect_unregister_pa() - Unregister region from inspection table.
+ * @pa: Physical address of the memory region to remove
+ * @size: Size of the memory region to remove
+ *
+ * Return: None
+ */
+void meminspect_unregister_pa(phys_addr_t pa, size_t size)
+{
+	struct inspect_entry *e;
+	enum meminspect_uid i;
+
+	WARN_ON(!mutex_is_locked(&meminspect_lock));
+
+	for (i = MEMINSPECT_ID_STATIC; i < MEMINSPECT_ID_MAX; i++) {
+		e = &inspect_entries[i];
+		if (e->pa != pa)
+			continue;
+		if (e->size != size)
+			continue;
+		meminspect_unregister_id(e->id);
+		return;
+	}
+}
+EXPORT_SYMBOL_GPL(meminspect_unregister_pa);
+
+/**
+ * meminspect_register_id_pa() - Register region into inspection table
+ *		 with given ID and physical address.
+ * @req_id: Requested unique meminspect_uid that identifies the region
+ *	This can be MEMINSPECT_ID_DYNAMIC, in which case the function will
+ *	find an unused ID and register with it.
+ * @pa: physical address of the memory region
+ * @size: region size
+ * @type: region type
+ *
+ * Return: None
+ */
+void meminspect_register_id_pa(enum meminspect_uid req_id, phys_addr_t pa,
+			       size_t size, unsigned int type)
+{
+	struct inspect_entry *e;
+	enum meminspect_uid uid = req_id;
+
+	WARN_ON(!mutex_is_locked(&meminspect_lock));
+
+	if (uid < MEMINSPECT_ID_STATIC || uid >= MEMINSPECT_ID_MAX)
+		return;
+
+	if (uid == MEMINSPECT_ID_DYNAMIC)
+		while (uid < MEMINSPECT_ID_MAX) {
+			if (!inspect_entries[uid].id)
+				break;
+			uid++;
+		}
+
+	if (uid == MEMINSPECT_ID_MAX)
+		return;
+
+	e = &inspect_entries[uid];
+
+	if (e->id)
+		meminspect_unregister_id(e->id);
+
+	e->pa = pa;
+	e->va = phys_to_virt(pa);
+	e->size = size;
+	e->id = uid;
+	e->type = type;
+#ifdef CONFIG_CRASH_DUMP
+	if (elf_hdr_ready)
+		update_elfheader(e);
+#endif
+	atomic_notifier_call_chain(&meminspect_notifier_list,
+				   MEMINSPECT_NOTIFIER_ADD, e);
+}
+EXPORT_SYMBOL_GPL(meminspect_register_id_pa);
+
+/**
+ * meminspect_table_lock() - Lock the mutex on the inspection table
+ *
+ * Return: None
+ */
+void meminspect_table_lock(void)
+{
+	mutex_lock(&meminspect_lock);
+}
+EXPORT_SYMBOL_GPL(meminspect_table_lock);
+
+/**
+ * meminspect_table_unlock() - Unlock the mutex on the inspection table
+ *
+ * Return: None
+ */
+void meminspect_table_unlock(void)
+{
+	mutex_unlock(&meminspect_lock);
+}
+EXPORT_SYMBOL_GPL(meminspect_table_unlock);
+
+/**
+ * meminspect_traverse() - Traverse the meminspect table and call the
+ *		callback function for each valid entry.
+ * @priv: private data to be called to the callback
+ * @cb: meminspect iterator callback that should be called for each entry
+ *
+ * Return: None
+ */
+void meminspect_traverse(void *priv, MEMINSPECT_ITERATOR_CB cb)
+{
+	const struct inspect_entry *e;
+	int i;
+
+	WARN_ON(!mutex_is_locked(&meminspect_lock));
+
+	for (i = MEMINSPECT_ID_STATIC; i < MEMINSPECT_ID_MAX; i++) {
+		e = &inspect_entries[i];
+		if (e->id)
+			cb(priv, e);
+	}
+}
+EXPORT_SYMBOL_GPL(meminspect_traverse);
+
+/**
+ * meminspect_notifier_register() - Register a notifier to meminspect table
+ * @n: notifier block to register. This will be called whenever an entry
+ *		is being added or removed.
+ *
+ * Return: errno
+ */
+int meminspect_notifier_register(struct notifier_block *n)
+{
+	return atomic_notifier_chain_register(&meminspect_notifier_list, n);
+}
+EXPORT_SYMBOL_GPL(meminspect_notifier_register);
+
+/**
+ * meminspect_notifier_unregister() - Unregister a previously registered
+ *		notifier from meminspect table.
+ * @n: notifier block to unregister.
+ *
+ * Return: errno
+ */
+int meminspect_notifier_unregister(struct notifier_block *n)
+{
+	return atomic_notifier_chain_unregister(&meminspect_notifier_list, n);
+}
+EXPORT_SYMBOL_GPL(meminspect_notifier_unregister);
+
+#ifdef CONFIG_CRASH_DUMP
+static int __init meminspect_prepare_crashdump(void)
+{
+	const struct inspect_entry *e;
+	int ret;
+	enum meminspect_uid i;
+
+	ret = init_elfheader();
+
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Some regions may have been registered very early.
+	 * Update the elf header for all existing regions,
+	 * except for MEMINSPECT_ID_ELF and MEMINSPECT_ID_VMCOREINFO,
+	 * those are included in the ELF header upon its creation.
+	 */
+	for (i = MEMINSPECT_ID_VMCOREINFO + 1; i < MEMINSPECT_ID_MAX; i++) {
+		e = &inspect_entries[i];
+		if (e->id)
+			update_elfheader(e);
+	}
+
+	elf_hdr_ready = true;
+
+	return 0;
+}
+#endif
+
+static int __init meminspect_prepare_table(void)
+{
+	const struct inspect_entry *e;
+	enum meminspect_uid i;
+
+	meminspect_table_lock();
+	/*
+	 * First, copy all entries from the compiler built table
+	 * In case some entries are registered multiple times,
+	 * the last chronological entry will be stored.
+	 * Previusly registered entries will be dropped.
+	 */
+	for_each_meminspect_entry(e) {
+		inspect_entries[e->id] = *e;
+	}
+#ifdef CONFIG_CRASH_DUMP
+	meminspect_prepare_crashdump();
+#endif
+	/* if we have early notifiers registered, call them now */
+	for (i = MEMINSPECT_ID_STATIC; i < MEMINSPECT_ID_MAX; i++)
+		if (inspect_entries[i].id)
+			atomic_notifier_call_chain(&meminspect_notifier_list,
+						   MEMINSPECT_NOTIFIER_ADD,
+						   &inspect_entries[i]);
+	meminspect_table_unlock();
+
+	pr_debug("Memory inspection table initialized");
+
+	return 0;
+}
+late_initcall(meminspect_prepare_table);

-- 
2.50.1


