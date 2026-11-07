Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6A7606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=prQuEx/r;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IyACM/Ex
Received: by kanga.kvack.org (Postfix)
	id 4AAFD6B05B0; Fri,  6 Nov 2026 21:39:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45BF86B05B1; Fri,  6 Nov 2026 21:39:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC9D6B05B2; Fri,  6 Nov 2026 21:39:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE4C66B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:39:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D52E402BE
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:39:37 +0000 (UTC)
X-FDA: 85406767194.24.592C9ED
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id D8F7780004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:39:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="prQuEx/r";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="IyACM/Ex";
	dmarc=pass (policy=none) header.from=oss.qualcomm.com;
	spf=pass (imf02.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794019175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yPqS9+jjib1sxM+lashj/lPQvrYKSiMhFD5RdhnO7D0=;
	b=yQ7vnFCEQm9K89gOq6DlKY+RyPt02aYPjsI1aiORYMaXzkHVMT3GD+g2AGaG3XSV3wgSOP
	7zB3JZlz5C8jnApJOxmPI0rgBgkVFuX/FcopAxuyT8yCXkkNdzqnl4pXMCx/YSe4mltzYl
	4RNgIZngdN2++H65RHRa9h31KgIOHX4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794019175;
	b=LEESPXvZepL8d9/JqO6pqvLGqs6VGCyA/3T20xdOtgElD53nNq26ZgaBa45oFf8uKhy2Yj
	el/QY6vYs9CpZMAo8wfJnS/obksgQ/jQswgRR3mwJffAC000eezTIV+XOYG/atMJOCsGwU
	N5uWuCjPWHuCtalkVSD3McgI4WYV/Hg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="prQuEx/r";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="IyACM/Ex";
	dmarc=pass (policy=none) header.from=oss.qualcomm.com;
	spf=pass (imf02.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A72C2Dw2138247
	for <linux-mm@kvack.org>; Sat, 7 Nov 2026 02:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=yPqS9+jjib1sxM+lashj/lPQvrYKSiMhFD5
	RdhnO7D0=; b=prQuEx/rq64IvGjKtB6ZhmV3sHxdSim4xZlwhchPEwZk9dCeAhW
	6wq4vss9cQEzzvbBiUFcavNg/55mtjMFdkL7yTnfk7DdRQU8ib40vIgMvtRSKel1
	du8vGjdJXtkdGXU3VLV8eJdvRU9c0mWi3bGd1xfAFhwnqAoW05/n+jIQcUWQwI59
	AP+oJfOH5JT5l2ag+lVDGj6FnaLUR0HQfX/DQ5Gc3cOkgQsegAcMsR98NR1KqcZL
	5qlz0xq31NJrMmWl9yXnpxGS/dBwApzyjkikODk4y0oHfnd+AfNSVQjDgjUFV2aS
	BgSMpAZj+6OTfvE/SIUj4h4NwH1P2HKsH5g==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hsu06r2he-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:39:33 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36cec75d8caso348971eec.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794019173; x=1794623973; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yPqS9+jjib1sxM+lashj/lPQvrYKSiMhFD5RdhnO7D0=;
        b=IyACM/Ex60ljFdr6HDQlaUPlzD3GVGMzjttDs3AUHJxEbV+KvKEOeNgtqTrUvWCx7L
         Xgh4ailszp8wZgN/jGhVrnInjKWN3ComQuUpB/kbtBahcL+PEzXwfByzlFZ1T6mO6vRu
         F//A96EDQyNOO0PKVyZcA4/2bnOXtT2Ko4QvGoY38vjSViaXWAmgiwqmvCxPLUg1dZUZ
         g70A2jLOpJpSaj7BR1bdGTzhrCYW8Jm/aaVnfhKHVDmSmOb/+bq3cgU9lu5hPUeMnCaP
         JXp0lydt8MGNnNdUutW41gdnaEsd/FS+BjLyCQYm9qTzyiqxuJXWws7CICy9IZHInZ4a
         EXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794019173; x=1794623973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yPqS9+jjib1sxM+lashj/lPQvrYKSiMhFD5RdhnO7D0=;
        b=Myrs0ZlcVj4jQdufDIKzvX9LmwAfhMvxiVXpled30Qkh6UAKrerO4cFsMO9lVPDXac
         qBdhqU88aCRDegY+lG9JaChOgGro8M/US+1knYylMW+t71VTrCwStqQo3ATvu3DJVBhm
         MkI3l2TwRqjTh7EAYKyJw+QrY6K11tmXk552XK+JpsQCAlnhHZB6/NQ7+cmbhndX0KCF
         7OC1aTp+tXUsqCO0PWSZwOm6yeW8w4iA4tY52KuDnERbkAnFGgjy7jPRdTSNk1xhNWnM
         qVdfgJPKq97XLiBemOOeItojIuZVTDCzAU+udTmgXMlyM47uwWGA1IGmSdIf/yn1JlZJ
         stFA==
X-Forwarded-Encrypted: i=1; AL+hErGWiyGD8F0LgbOdARdsFczEe0g8VHt3XKQFJZiLZms2eEcJ/MCv2MjrxhbRdnsZhoT4fGxWOI1b3Q==@kvack.org
X-Gm-Message-State: APuU4Z+36RDlgaYA8Yvzflx2woDRnuTVzT10QC+IVXNeZXF/pnEpvS4w
	ob0Y0/04JANl/XyKvjgjsG1j9siJy4WTUqUqMROrDgWWQgcO6+5teCF2XjlLcU2PPkjt9QPbtWd
	Xmj7Kza099hztfmONt0n6/s4wzSfCBsR2Ok/anV4Gw0NA8Dt0guEO/g==
X-Gm-Gg: AYBFou3z+3bt8KZbUlXK447hvUsb6luZo8/ZUJLtSQFA87bQSDRERlEBiV80z272DFr
	fyth56zXlIuS1C6LejK0Fclyxd7zuzDdxVHLvS06rOllX1GaxAIBOsygUfbxUTdSpBvr7IJR7eX
	tuC1As5NvkJSZ2AHjUBZaZWVVZ1LyVanEwzKTabmobuNdbZWP8hwjeJhrrF3hQ5k5gVVfFHepz5
	P2Mdk5FnAPvZMXNG/JsAg+QwDhquNaIPAu8M+nvvteQW52x6GNoCMC7YH0q7RD6FeWPuNHHDCaE
	ATP+Dm5WVM/jsLkhZOwWBABIKVn+xlC8g1cmhDwjNAlYjOT9FXsqtb8+RvkzRpgeaR9Mr3dTD1F
	3GiGsRYfm6FjONN5BqG+DH1as2AC4SSVzx88ZbsGxcKAAev7XnezgPUGO/2w9FazezUpKgzjNg2
	XTlInnG2iLEsF/M1VEfBaIAPZ7nrMiH+U8m+5lU1a4yMyeK5qzkkoSm20SZ59zRNzm1kUdBvrn3
	g==
X-Received: by 2002:a05:693c:8819:20b0:36c:dbfc:ee6f with SMTP id 5a478bee46e88-370f6ec412cmr1169928eec.14.1794019172299;
        Fri, 06 Nov 2026 18:39:32 -0800 (PST)
X-Received: by 2002:a05:693c:8819:20b0:36c:dbfc:ee6f with SMTP id 5a478bee46e88-370f6ec412cmr1169834eec.14.1794019171274;
        Fri, 06 Nov 2026 18:39:31 -0800 (PST)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faac86a96sm11069040eec.29.2026.11.06.18.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 18:39:30 -0800 (PST)
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
Subject: [PATCH v8 0/8] riscv: Introduce support for hardware break/watchpoints
Date: Sat,  7 Nov 2026 08:09:09 +0530
Message-ID: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX0luXCjg9xC3I
 CekDkAxCBtkccP3+JZRTXSWZgIjsQvAitCNERIMNOJhXTNjX8J0tPaZZE9BAWoOsAvO2sg6i33A
 oU/qEhEbCfpASCVkmAG/gf+fs7WB/U0Gbi2vwOUaQjWWl/ZkApbSNx7GOKxGYWFEHXGe5//GhSh
 pef1+ttTLrjy9CPlkjpHZrXKFd/ooM/RBzt46x+YpXzSMmAikixEtZ98DyogGdrmMDuCoRsvTYl
 OCO+WhGslFZ87gNwS7XzlG0jiM1Jy1eR31Y2mv8YaqZQIpMrnhWw4vUGe32mTb8lyhBF4jEvipk
 a4bWwdwGjlnOgjnQ3GrDqG8d2X9s8IugQqkXrqvOondfQzk9eYyQOjO2FMeXc8Asf/OSYXMJAVc
 gha6RHD9HFm4WxP/fA8/KyNQw5fFLmw41UBXB0kiIhUtttHxvtze+oGgtUsuHtpAmNzev1xounS
 CKpUhuuk+4nBzDCiHdQ==
X-Proofpoint-GUID: oBj1klfvEWK4nJZBF4h8MGimCXlopOsN
X-Authority-Analysis: v=2.4 cv=IJGXmQvG c=1 sm=1 tr=0 ts=6aee8f65 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=NEAV23lmAAAA:8
 a=HwFc7jivAAAA:8 a=_NFv3PjsgsRmLWfyS6wA:9 a=scEy_gLbYbu1JhEsrz4S:22
 a=kr7TZk85JJIQSqC0cl8G:22
X-Proofpoint-ORIG-GUID: oBj1klfvEWK4nJZBF4h8MGimCXlopOsN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX5U/SWC7aVpqX
 6wsCaeULMuqRjfyKMWJRnxmMC6D+/aLO6d/1JoCFHSbTWoKdGRcgmklxguVyzYEoTWs53B5sXBR
 RzOq3ZYbw+GACTDrIoIk+h+w077ISLM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_01,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070010
X-Stat-Signature: kcfjrz447x1fbssh37ikpqt9dh714cyi
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8F7780004
X-HE-Tag: 1794019174-294156
X-HE-Meta: U2FsdGVkX1/FvuAzA7DTDj5XvHekcdRTJLwYbevSdeSAdaNdcdFyZ2n7dpZrpnp0iyLIbj87bFB4day8H6cA6d+lUKHR16Okl0EBAw8elVdA+IR0aOAN96T2ni0cRYgkKD2c1UY/I8785Qmu3UHC5soBWOYal4VUFCnUpAHw6Jlw0pjdHE5rOtlIj67XGzLcu1LEa9K5+qTJwVZxn8Y02quD5tw9IsbQHp0cafOKvhEu2kckrrolfLFzUWrMCoAsvahO3Mu1GPsthh8sbkut91g/FoCDb5Q2CHx5p3ccJke7SfnaYyyvTkYBEWuT0zxPxGlTgEB8/QYMF2dQpdBvB6LN24/Lu6LK0iIBnz6SIwMMAsVw5CKvr8TDqmjUqMCW8n2euyVJoXGziK9eGthEd9xhMEvEHSYVxK3FQMewECLqoVgikwS+vtAkVyKt3GmTqAV9r7q8RiTrhC4VK+Sdp2dvWCgwsT/KQCaS4001p+ji3KgdxsveX/6JhrkWZ+cm0lXsstr0rZEMgezRdYCnSxl34HmpYWgU3/pm5tca3tWHrq++1wV49lm+Qd0O8Fezkl6WV7c2a39QZY597vcf9VNlg6zpva7MD0Ab+CmuOsZUOEwjNgQ5eUeNSGAMAWd0NtLZ1gMmZDwYtoa9Rwi6zbwRPWm2o6fQu2WdfKblKDExdJ25xxAwRv9kAfRMTTYOny0gE/7G/Evy799so0pgJ4iYE35Zsu1MM2CmQlWbVXBf0fwR68XWwF9hcrxsyEqnsy7+IU7ICm6DKoL5fbNjNR8x4FOZNCIxGWoI6jD8e8/aSHVQ99ZJsDhx0qhDTuvLyqjx4EFEKgCDSaMHFSCcASBnu/NsNvv/7tYbT4HoK+VJK5lY9Jc5W7pkQ9Yp9Hr0AGa+ovsPTOzdP5EGILlDocYJaEHVWdMkfG36y+652+Fi/y5vx7OuzxpeOAzA9Bt43nmO9bmpfxqFUBxpUwu
 /RSGZcIy
 HW6nMde2MM++X8TTbq8SdmDOmEZyZ5jjNv9gait2WluivnjlCeo6osp9K6aHy54yEbVfTYTnLu+8k2J6JiWM3UNjZtbuDbRN6Rqk2WBfvwSCXMZPxTaGQ3TDwp3iefgn41D9THyRCYGbaUnD51nnoeuotEi4Ss+ldW6Aod+N7rvxqWD3c43dULM5SsrVAwxrmdKA7IMVr40VN7NR2BfGimUn7tbEwuYjQN0uRrun2zvgRK5tbrUDcQO26aZutNwuRBeySh5rIA/fWErzIPo9cylEiOWceuUDANTFDq6vPIpgnKq5km4KUnxDTkujkQBsqB70TQSYwMj+qO1HcB7kydrAmnkj7hzL11IIkSJd2yLkvdMdDDQaMawiYunLgSV7eJc5skeWPoTn9DRKV4Sx4CJym3IB1CFZoNAoDQuwEj4pvIFV21lV7bpjs0s9/SJns45yEkQiYMsyCqoHheHsGAzwNPtXWrvxy245A5EOi+OsL42n6L/nAvVBopnDbUS/sF1g9C+ZpKH1xZaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This patchset adds support for hardware breakpoints and watchpoints in the
RISC-V architecture. The framework is built on top of the perf/ptrace subsystem
and the SBI debug trigger extension (Sdtrig).

Single stepping uses icount when it is available. The software stepping path is
kept as a fallback for systems where icount is not available.

The icount path depends on a QEMU fix so that, when an icount trigger fires,
the exception PC follows the Sdtrig action rule: "xepc must contain the virtual
address of the next instruction that must be executed to preserve the program
flow." For QEMU testing, please use:
  https://github.com/hschauhan/qemu/tree/hschauhan/sdtrig-icount-fix

Virtualization of debug triggers is pending. The patch set is ready but needs
testing.

Changes from v7:
  - Rebased to v7.4-rc1 and folded maintainer entries into the patches that
    add the maintained files.
  - Reworked the patch structure:
    - one patch for the direct single-slot ptrace requests
    - one patch for the register set interface
    - debug trigger encoding details kept internal from the introductory patch
  - Tightened breakpoint and watchpoint handling:
    - trigger setup, update, uninstall, cleanup, and error paths
    - debug trap races with trigger programming
    - hit state cleanup so stale hardware state is not reused
    - cleanup across program replacement and fork
    - bounds, overflow, and wider-access watchpoint matching
  - Improved ptrace support:
    - both ptrace interfaces now share the same breakpoint/watchpoint storage
    - 32-bit traced tasks are supported on 64-bit kernels
    - partial writes and bad indexes are rejected more carefully
  - Improved single stepping:
    - icount is used when available, so the hardware reports the next PC and
      the kernel does not have to decode the stepped instruction
    - software stepping remains as the fallback and now handles indirect
      branches, kernel-address instruction fetches, and mode-specific temporary
      triggers more carefully
    - unsafe software-step cases are rejected instead of looping on the same
      address, and the original breakpoint is restored if stepping lands
      somewhere unexpected
    - CPU-wide software stepping is rejected when icount is unavailable; there
      is no task to follow, and the fallback needs per-task state
    - unused saved trigger state was removed, and the QEMU icount fix needed for
      testing is documented
  - Improved selftests:
    - icount stepping over a taken branch
    - cleanup of failed child processes
    - failure propagation to the process exit status
    - bounded waits for expected signals
    - breakpoint/watchpoint readback validation
    - native riscv64 build handling and RISC-V-only test flags
  - Built and tested QEMU, OpenSBI, Linux, the breakpoint selftest, perf tests,
    RV32 compat ptrace tests, icount stepping, and software-step fallback

Changes from v6:
  - Rebased to v7.3-rc5
  - Added HIT0/1 bit check/clear in breakpoint handler with EPC/Bp address check
  - Removed dbtr_shmem null check as pointed by Qinfang Deng
  - Fixed MEM_HI/MEM_LO macros to work both on rv64/32
  - Changed unsigned long to __u64 from hwdebug state struct and dropped packing
  - Gated HAVE_MIXED_BREAKPOINT_REGS with PERF_EVENTS
  - Software base single stepping with mcontrol6 trigger type.
  - icount is still under development.
  - Moved and and reworked instruction decoding code to a common file.
  - perf test suite now supported.
	- Breakpoint overflow signal handler
	- Breakpoint overflow sampling
	- Breakpoint accounting (needs sudo)
	- Watchpoint
	  - Read Only Watchpoint
	  - Write Only Watchpoint
	  - Read / Write Watchpoint
	  - Modify Watchpoint
  - __test_function in "Breakpoint overflow signal handler" is name noinline
  - Fixed warnings from checkpatch.pl --strict

Changes from v5:
  - Rebased to v7.2-rc6
  - Simplified Macros in hw_breakpoint.h
  - Took care of the review comments
  - Added ptrace support for hardware break/watchpoints (new patch)
    - PTRACE_GETREGSET/SETREGSET via NT_RISCV_HW_BREAK / NT_RISCV_HW_WATCH
    - PTRACE_GETHBPREGS / SETHBPREGS for direct single-trigger access
    - HAVE_MIXED_BREAKPOINTS_REGS selected (break/watch share trigger pool)
    - flush_ptrace_hw_breakpoint / ptrace_hw_copy_thread wired up
  - Extended selftest to cover ptrace-based hw break/watchpoint paths (new patch)

Changes from v4:
  - Rebased to v7.2-rc4
  - Fixed rv32 build error
  - Added pr_fmt to print KBUILD_MODNAME
  - Changed type of shmem_pa to phys_addr_t
  - Use per_cpu_ptr_to_phys instead of __pa for per-cpu allocated memory
  - Print successful registration/unregistration message when no error
  - Added RISC-V DEBUGGING section in MAINTAINERS and added myself as maintainer
  - Fixed warnings from checkpatch.pl --strict run

Changes from v3:
  - Rebased to v7.1-rc3
  - For watchpoints, check tdata1.hit via SBI_EXT_DBTR_TRIG_READ and keep
    STVAL-based matching as fallback
  - Improved watchpoint matching when STVAL reports the lowest accessed address
    for wider memory accesses
  - Program execute breakpoints with SIZE=0 (match any size) to avoid misses
    with 16-bit/compressed instruction addresses
  - Updated selftest to avoid deadlock by replacing unbounded sem_wait() with
    sem_timedwait() timeout handling
  - Updated selftest breakpoint function so it cannot be inlined or optimized away

Changes from v2:
  - Rebased to v7.0-rc1
  - Fixed warnings from checkpatch.pl --strict run

Changes from v1:
  - The patch adding the SBI extension and function IDs is already merged; this
    series builds on top of that
  - Added breakpoint selftest in tools/testing/selftests/breakpoints/

Specifications:
~~~~~~~~~~~~~~
The SBI debug trigger extension is specified in the SBI specification:
  https://docs.riscv.org/reference/sbi/v3.0/ext-debug-triggers.html

The Sdtrig ISA is part of the RISC-V debug specification:
  https://github.com/riscv/riscv-debug-spec

How to use:
~~~~~~~~~~~
OpenSBI:
  https://github.com/riscv-software-src/opensbi.git

QEMU:
  https://github.com/hschauhan/qemu/tree/hschauhan/sdtrig-icount-fix

Linux Kernel:
  Apply these patches on top of v7.4-rc1

How to test:
~~~~~~~~~~~
>From the Linux kernel directory, first install the UAPI headers (required on a
fresh tree so the compiler can locate <asm/ptrace.h> and the new
NT_RISCV_HW_BREAK/WATCH definitions via KHDR_INCLUDES):

  make headers

Then build the selftest:

  make -C tools/testing/selftests/breakpoints/

This produces breakpoint_test_riscv under the same directory. Load it on the
target and run. Sample output:

  # /apps/breakpoint_test_riscv
  # [perf_event]: Breakpoint test passed!
  # [perf_event]: Watchpoint test passed!
  # [ptrace]: Breakpoint test passed!
  # ptrace(PTRACE_GETREGSET): Number of watchpoints: 2
  # ptrace(PTRACE_GETREGSET): addr: 0x82888 control: 0x8080
  # [ptrace]: Watchpoint test passed!
  # [hbpregs] breakpoint readback: addr=0x10472 type=4 len=4 ctrl=0
  # [hbpregs]: Breakpoint test passed!
  # [hbpregs] watchpoint readback: addr=0x82888 type=2 len=8 ctrl=0
  # [hbpregs]: Watchpoint test passed!
  # Icount taken branch PC test passed!

Perf Test Suite:
~~~~~~~~~~~~~~~
Run these perf tests sequentially. On this perf tree, the watchpoint tests share
one watched variable and the default parallel mode can make the subtests
interfere with each other.

~ # /apps/perf test -S -v 16 17 18 19 20
 16: Breakpoint overflow signal handler           : Ok
 17: Breakpoint overflow sampling                 : Ok
 18: Event re-armed with PERF_EVENT_IOC_REFRESH   :
 18.1: Software event                             : Ok
 18.2: Tracepoint event                           : Skip (permissions)
 19: Breakpoint accounting                        : Ok
 20: Watchpoint                                   :
 20.1: Read Only Watchpoint                       : Ok
 20.2: Write Only Watchpoint                      : Ok
 20.3: Read / Write Watchpoint                    : Ok
 20.4: Modify Watchpoint                          : Ok

=== Test Summary ===
Passed main tests : 3
Passed subtests   : 5
Skipped tests     : 1
Failed tests      : 0

Himanshu Chauhan (8):
  riscv: Introduce support for hardware break/watchpoints
  riscv: Add breakpoint and watchpoint test for riscv
  riscv: add ptrace requests for hardware breakpoints
  riscv: add regset access for hardware breakpoints
  selftests/breakpoints: extend riscv test for ptrace hw
    break/watchpoints
  riscv: Add shared instruction fetch and decode helpers
  riscv: Add software supported single stepping with mc/mc6 triggers
  perf tests: keep bp_signal memory accesses visible

 MAINTAINERS                                   |   12 +
 arch/riscv/Kconfig                            |    2 +
 arch/riscv/include/asm/hw_breakpoint.h        |   78 ++
 arch/riscv/include/asm/insn.h                 |   16 +
 arch/riscv/include/asm/kdebug.h               |    3 +-
 arch/riscv/include/asm/processor.h            |   15 +
 arch/riscv/include/uapi/asm/ptrace.h          |   50 +
 arch/riscv/kernel/Makefile                    |    1 +
 arch/riscv/kernel/hw_breakpoint.c             | 1182 +++++++++++++++++
 arch/riscv/kernel/process.c                   |    2 +
 arch/riscv/kernel/ptrace.c                    |  661 +++++++++
 arch/riscv/kernel/traps.c                     |    6 +
 arch/riscv/kernel/traps_misaligned.c          |   52 +-
 arch/riscv/lib/Makefile                       |    1 +
 arch/riscv/lib/insn.c                         |  279 ++++
 include/uapi/linux/elf.h                      |    4 +
 tools/include/uapi/linux/elf.h                |    2 +
 tools/perf/tests/bp_signal.c                  |   14 +-
 tools/testing/selftests/breakpoints/Makefile  |    8 +
 .../breakpoints/breakpoint_test_riscv.c       |  867 ++++++++++++
 20 files changed, 3197 insertions(+), 58 deletions(-)
 create mode 100644 arch/riscv/include/asm/hw_breakpoint.h
 create mode 100644 arch/riscv/kernel/hw_breakpoint.c
 create mode 100644 arch/riscv/lib/insn.c
 create mode 100644 tools/testing/selftests/breakpoints/breakpoint_test_riscv.c

-- 
2.43.0


