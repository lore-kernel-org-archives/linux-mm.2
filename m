Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C57606A333
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cNh/Or7O;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y6AzXRVY
Received: by kanga.kvack.org (Postfix)
	id E49146B05C8; Fri,  6 Nov 2026 21:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF97E6B05C9; Fri,  6 Nov 2026 21:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78A86B05CA; Fri,  6 Nov 2026 21:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 979AC6B05C8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:40:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21924C01E6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:15 +0000 (UTC)
X-FDA: 85406768790.27.0B07DF7
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96CC3160003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="cNh/Or7O";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Y6AzXRVY;
	spf=pass (imf08.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794019212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSTWstvbv8LujZTfVp3lvTUcRdBqryRUI2SM8+iLfBQ=;
	b=R4Xonh0G9i5XYR7ANpySjAl+RCCi0CxVpiuvMSKlrKTczrCebTKIRYmZ1pa9G+rWmbFe/T
	eMOp4+uXiUz+f3y1gqQtPRJ5qsP85zNWTgCkzJCEpRHOimilgJWBGiDFXKBVzQxmKijl8G
	CBX7aIJ3ZGTkheJpuY13VHIown1yhR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794019212;
	b=d8ygLit1+e3T8A+eY6OrdayXvmD34LRZX/LGnpIs7MFcQGZSfARYgpXK+ntCP5gy7yhlvm
	cF3ly+n8qJ3cV36Mvhr+NBVsUYDI5eZqiK+H8VfPPJmabmVZASrbRTgbB2frvaiVRh6bIe
	U0wkl/D2hwsEiYws42RP/m3h2enDmY4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="cNh/Or7O";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Y6AzXRVY;
	spf=pass (imf08.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A72AjM4984848
	for <linux-mm@kvack.org>; Sat, 7 Nov 2026 02:40:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=mSTWstvbv8L
	ujZTfVp3lvTUcRdBqryRUI2SM8+iLfBQ=; b=cNh/Or7OUbLa43GPBGNhx2XwnE5
	a49u8Xzwi8Jl1kX01lwBgyyRnxYAMjk79FwIkAHUIFNb1bo4bVwyKRjl6sRFEhMJ
	pZgWGsriAjjKDwwvUyXIQokHY3enc6QBVLYnOPF5DyC0FprDLU0jngh16Hhqpd22
	vEEGRefDxcu9dsNW3sfZbIAIykeBg5mkeBlVKXt92fkQhEw+D2mcJ8mkI89NvExA
	dlRfWTK6UeARw1OuC3MDWql9sc8O/7G+hehvWa0KMmN3QqIfoP94pQSfOs4ZjkT0
	pDkjt96RkQCkPo3PB80sVk09UrcPLDULlBeTv0JmBzPPE0a4gsrxlK7WpXQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hsmyrh737-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:40:11 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30bcb065bfdso2110837eec.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794019211; x=1794624011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mSTWstvbv8LujZTfVp3lvTUcRdBqryRUI2SM8+iLfBQ=;
        b=Y6AzXRVYolpHoOXy3hVzSr40P2YNR2LdVlZiqUtIsC39RIU9KkcU2ya4XKLmOubPcZ
         Y0uhjbwaJMswNFQMNBonl2h92GXkuuO1Z1WT8Lt9IDn8v0obNNa+X3GgzdQgPDI5hsci
         w/OeMO0fuw0AKXv17qw6W9X4dl1/5z5/1+mOR6Gxn55BmI8ShzxeWZ9SP+CUTdrVaZYq
         E65xXFcG+BFlkIEHecDDYh7urP5YFb8fI6ertAqylgMCwIkyvXPFZOPBSpfrsjq+/edU
         R3J9VI7BzTVYmZvt6Gic3tIlAmegXEubvzI1j0YOHtFwYxMl13HuBO9L+7QNtWj0VrLO
         mHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794019211; x=1794624011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mSTWstvbv8LujZTfVp3lvTUcRdBqryRUI2SM8+iLfBQ=;
        b=GI4tVhTT3/gMEosThfWifwnaCvZDmvcEj37He7yWNxI+C81PX7id7um/m+K6KX9Dp/
         cvlzXiVM1DTIPXryoYe7x597pJVVAl4yVgDoPml3/xFQeQ/0JdI7Q8rQIuoYaM3sGhue
         vzQCY2MinBLAtGgZwqKQBbxYs4Ly3J7gWY+DxEzjcD+quGwUZfyZdoKID+wFqv8GgeTA
         YMpUYgtK8twOJwz+yRsS77FMMyZf/HHhd4EBZUvgrHiQ6v3gjunb4sEETAXkKqIc9GQt
         Tm/FENxXw8x3Oqs5jopRUTzrSO/lfCy16OGeI+dHUF6mYRsAy52MXBzUfIGPQaJ+GDKS
         ZxLA==
X-Forwarded-Encrypted: i=1; AL+hErFN+5ShmQRnFaoXMnrKj7oHRpKwT4O3yTsX8U5ulkhhnpYUJuv+ytN0u0rhyR16RiLbUqhNPucBEQ==@kvack.org
X-Gm-Message-State: APuU4Z+SmeN6HJXhBdqDT3cPz0ce1olOjTE3sSg4G1gFGYShTpUE1GAa
	BSk7xsDCgLFgEO0PC1B9Y4lmvIA950Ese7iaDleq8YAizkI3+cgb4gORU0jqSogLx/SG4RIB3JF
	Nb1XlsEL923uzrr3+KRRNY1pqJvwzZjzSpD4fCl3vjME6bgIgrf9opA==
X-Gm-Gg: AYBFou2pKAOvvAwXYgsISC8Yq4l0/YobE+AkIsiERlHMAAj9nvOLMT24JX+Hz0btxaj
	lKyOdfjk6QfA98FHm6xyytZOVL1LrfvVd0EtqOSAvzUbrk0xzD2s8TyQetHh/uHJ5DGv17Tne+4
	/KySemXbrnuL99j4mzJj6Ln9fRxR/9bWX90iB7v6+x2a/K5uNG6jEda7Y8bvC1vy32dsXrJ9bEK
	M6GNudlqc+T41HKiPkl53aNVUcUA3vQjqepJUyVFnb72chS+qLpUliiejeNETAoH1QoEZvs2m6A
	r53pUwuOsUtlCy8S590YwHZOrv/v+AGlDSHZ6ALe1Ags3fRWOsP+r/eQxy06g1dpS7KWQNxJhH8
	NfO0H4CXPFsxoeJKAzbgr4RDl3K4c6j6fue3pOr9DMpdv7782/Q7d4FJMeOW09mKolS/WS/1Eg0
	jG6Hhl2vp01atXcDMfGqB1JXXgcAxjubIqp4TqDhI1TUXTNStq0wX2TtzpVg6PGw6YlwirKdSJO
	A==
X-Received: by 2002:a05:7301:700c:b0:36f:83e7:fb7b with SMTP id 5a478bee46e88-36f83e7fbfemr5647479eec.40.1794019210198;
        Fri, 06 Nov 2026 18:40:10 -0800 (PST)
X-Received: by 2002:a05:7301:700c:b0:36f:83e7:fb7b with SMTP id 5a478bee46e88-36f83e7fbfemr5647422eec.40.1794019209442;
        Fri, 06 Nov 2026 18:40:09 -0800 (PST)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faac86a96sm11069040eec.29.2026.11.06.18.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 18:40:08 -0800 (PST)
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
Subject: [PATCH v8 5/8] selftests/breakpoints: extend riscv test for ptrace hw break/watchpoints
Date: Sat,  7 Nov 2026 08:09:14 +0530
Message-ID: <20261107023917.40606-6-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: zuiQGiAlB-7bBu4C3HZrNFmbQ4SWQZKv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX0GNoUoByzHMn
 B3v3c5utUtytdgg3KMDwaiSXU9BZxUlssEhIxINL5kB7Ii/CbVwFsNPg6cZcTqzwVkuovGL5Fgw
 608W+FZmhqQrPXTH+Py6QWboAfRQnz8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX9J5hy9JXLMcI
 BSDMBv7ixWEEDXHeuPtHa3sr+fpFZJUtig2Aqt99B3NB9mvhPSeTzpkLULpdcEm1Gnv6z/SmGSM
 sQgVJmxy5P2FjJBgDBhs5YqhKZv8HV0d8mWW7fFIgH0DUS595pF1eZjx0IiMltcYt8iopjHMRUo
 WDkyHlrNknun7+nUcZMUP+XNsuX3T5iRCq1UBqBFS3aXiQRArMSe3y1nv5sIgtbQH7MoxZc+pss
 pcAwe6bw482Waoj60aMyzQIQxmKgi5yCoFSeXp13k8Y+3JsLN++85V8CxnNJW8FtEYdqh5hGOEJ
 v34tmk29Z2zVqq+2dkgccsqboG8mvcWzZEoFlynvYF1gXx7CQvfPz8qWv2NCvkSBtO+XYNmxyAV
 JnBTGhnjMwilWMPVw9c01sygwt7UkX53mL0ToMArFavXdOU9ZyF7qvJVWxZC8W1oRKrBbf9tFa9
 QIWY9SR+Z34T24pt+Nw==
X-Authority-Analysis: v=2.4 cv=V+XoQuni c=1 sm=1 tr=0 ts=6aee8f8b cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=07_doiqUAAAA:8 a=JWLIJTURB46zOI_XQbAA:9 a=scEy_gLbYbu1JhEsrz4S:22
 a=S1vEknPFSxWy9jUyH7lK:22
X-Proofpoint-GUID: zuiQGiAlB-7bBu4C3HZrNFmbQ4SWQZKv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_01,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070010
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96CC3160003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: use3771oatn3yz7jcm7g1ue53nokg4c6
X-Rspam-User: 
X-HE-Tag: 1794019212-349905
X-HE-Meta: U2FsdGVkX19lnDAIus2WqiVH4TDo2fs2fRVPlU4lLmTVo45t87ani0CUpJeAQTLu4sEwOfsWqXij8auQhyihE/KLvuKXjrqxMqIg09aE/LoeGiqPrWK6W/gc+EwSEBjlBXBtiIKPJPHFTyTNjn8eJWie1mA1Hba8XfyeTu9ODEJ7F0b+PLpMkTHxBhR/I8cEaA/nNOvcAX0/bHNePc8qNZhUCDvWvIoX1qfcY5SaBxssvYlBAb1moOLGz+4V6Wz5gw2lTuKqXc57MDuHhefEBPoyRnU80+dUF52a5eh5THTsQen/gLjmAAk2AU9gipuWY+9POSCEG4/hS8qexQRigngum7Z4pGmfQzEY0HhR0CpFp7mSvBp9eNVZFzQpRzXdYl4LgUTtAtzmJt28iVGMGQERFlUwSu7LHkA4cwgqfBfadUWhjMyVgrtC/uaY2uWblcSot0jeNpNgw0yd+oyYqhMuss49zHK6lfR2oUXEcntNzInrY7WBOmPiPIP1GZwwLPrPzglT5ttwCw8qzAoH2ZAraogYA+9bO84g/eEIov/OBrRByaksShccwRXGhyqjMGDmbvpk+joWSsH30arJqwfNC4W/C8Nahw6L+8sdhSIBX8UBcsnBg62rzA/axyIUiSMpVaoyKytjs2NBckHpBAYk0Qqc1Z/zOtLSl8a9Alk7erNV1pYD8cHY3JBbyOjzdJAIto94NN77dTDfTNfjurIjzJ2QxEZr+opunZSCjrjShob0RQaPO1uE6CsLuNQIs3xkw4uuAdm4VUD5o7ZoV3NJGslFmAI20N0ZUMuMBiRctnvcVO2FiO1VXmQ2WqtoOMJEXprcMAJIqYWCcj7tubjThuB3WudkGoUoRUw+HMPXoRCcUPf0393eisn0HwBB4weGAjAR79+mDO34WY6IVLzbenRiRS9RY37MTodWgi4WFZKDW1CzNnMsU+xvTsVj+qFFYAHoZuur5u1SIm6
 kARpEZYN
 N8QxTNwzAMJdVH60XgKKzYjjS7qyCQQJkDJ1ZzQeJ91JANaR4og16hlEPhECHWIcP+ZTv99kA/JmlU+y//sxHkYUB069pz/mIlI83g7MFXQwhes1ZYG5/XFK+6QKcbDeLuSX8Fm1B6R3tkF2gNZbSJRL8KAbrIx4yQSK/Toh4cmGXP61A11eFJU0IpYuAcwCL1Wgd7L+egAshXY3eFETVcg+OT0iQ9xDXYl4j019JlGODq7oKPaREIgOrwxuuNVMZSOPBZThr2DFuBt7DoPMqGoKHXio098RipAtcr7I4A6naClvGxQD4+IbUbhCn7Uy15cBGubuk9JPNwWzCBZfyfIRol01AWwG1AQKFJ9MK2HkotLrt5c5owZwK2nUdtRAqI2WVK5uj2NvP+HsVFensVc7oaCr7IJRrPvJP52ZEGqU1oI9a0nvvGYzb9DcsnDHKLcRZ6L/oAog83WaItlbTnI/1VedXvtNjazgSak0xugZ1c34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Cover the new ptrace-based hardware breakpoint/watchpoint support
added for riscv: exercise the PTRACE_GETREGSET/SETREGSET regset path
as well as the raw PTRACE_GETHBPREGS/SETHBPREGS interface, alongside
the existing perf_event-based tests.

Also drop a leftover #if 0 block duplicating the HWDEBUG_* control
field macros already defined in uapi/asm/ptrace.h.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 .../breakpoints/breakpoint_test_riscv.c       | 698 +++++++++++++++++-
 1 file changed, 675 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c b/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c
index a8a94a788142..b07f6770c380 100644
--- a/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c
+++ b/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c
@@ -9,6 +9,7 @@
 #include <linux/perf_event.h>    /* Definition of PERF_* constants */
 #include <linux/hw_breakpoint.h> /* Definition of HW_* constants */
 #include <sys/syscall.h>         /* Definition of SYS_* constants */
+#include <asm/ptrace.h>
 #include <unistd.h>
 #include <stdbool.h>
 #include <stdio.h>
@@ -18,17 +19,512 @@
 #include <fcntl.h>
 #include <signal.h>
 #include <sys/mman.h>
+#include <sys/ptrace.h>
+#include <sys/wait.h>
 #include <string.h>
 #include <semaphore.h>
 #include <errno.h>
+#include <stdint.h>
+#include <stddef.h>
+#include <linux/elf.h>
+#include <ucontext.h>
+
+#include "kselftest.h"
 
-static int gfd;
-sem_t ib_mtx, wp_mtx;
-static int bp_triggered, wp_triggered;
 static int test_func_sink;
 static const int wait_timeout_sec = 5;
 
-int setup_bp(bool is_x, void *addr, int sig)
+static unsigned int hwdebug_control(unsigned int type, unsigned long len)
+{
+	return HWDEBUG_MK_TYPE(type) | HWDEBUG_MK_SIZE(len);
+}
+
+static void cleanup_child(pid_t pid)
+{
+	int status;
+
+	if (pid <= 0)
+		return;
+
+	/* Every error path funnels here so a stopped tracee is never leaked. */
+	kill(pid, SIGKILL);
+	while (waitpid(pid, &status, __WALL) < 0 && errno == EINTR)
+		;
+}
+
+static pid_t waitpid_timeout(pid_t pid, int *status)
+{
+	struct timespec delay = {
+		.tv_sec = 0,
+		.tv_nsec = 10 * 1000 * 1000,
+	};
+	int tries = wait_timeout_sec * 100;
+	pid_t wpid;
+
+	/* Avoid alarm(): SIGALRM's default action would skip tracee cleanup. */
+	while (tries--) {
+		wpid = waitpid(pid, status, __WALL | WNOHANG);
+		if (wpid < 0 && errno == EINTR)
+			continue;
+		if (wpid != 0)
+			return wpid;
+		nanosleep(&delay, NULL);
+	}
+
+	errno = ETIMEDOUT;
+	return -1;
+}
+
+static bool wait_for_child_stop(pid_t pid, int expected_sig, const char *name)
+{
+	pid_t wpid;
+	int status;
+
+	wpid = waitpid_timeout(pid, &status);
+	if (wpid != pid) {
+		ksft_print_msg("%s: waitpid() failed: %s\n", name,
+			       strerror(errno));
+		return false;
+	}
+	if (!WIFSTOPPED(status)) {
+		ksft_print_msg("%s: child did not stop\n", name);
+		return false;
+	}
+	if (WSTOPSIG(status) != expected_sig) {
+		ksft_print_msg("%s: child stopped with signal %d, expected %d\n",
+			       name, WSTOPSIG(status), expected_sig);
+		return false;
+	}
+
+	return true;
+}
+
+static bool continue_and_wait_for_trap(pid_t pid, const char *name)
+{
+	siginfo_t siginfo;
+
+	if (ptrace(PTRACE_CONT, pid, NULL, NULL) < 0) {
+		ksft_print_msg("%s: ptrace(PTRACE_CONT) failed: %s\n",
+			       name, strerror(errno));
+		return false;
+	}
+
+	if (!wait_for_child_stop(pid, SIGTRAP, name))
+		return false;
+
+	if (ptrace(PTRACE_GETSIGINFO, pid, NULL, &siginfo) != 0) {
+		ksft_print_msg("%s: ptrace(PTRACE_GETSIGINFO): %s\n",
+			       name, strerror(errno));
+		return false;
+	}
+	if (siginfo.si_code != TRAP_HWBKPT) {
+		ksft_print_msg("%s: unexpected si_code %d\n", name,
+			       siginfo.si_code);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * Keep a real instruction address for HW execute breakpoints: prevent inlining
+ * and force a visible side effect so the function can't be optimized away.
+ */
+static __attribute_noinline__ void test_func(void)
+{
+	test_func_sink++;
+	__asm__ __volatile__("" : : "g" (test_func_sink));
+}
+
+/*
+ * BREAKPOINT TEST USING PTRACE
+ */
+static int do_wp_child(void *addr, size_t size)
+{
+	if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) != 0) {
+		ksft_print_msg("ptrace(PTRACE_TRACEME) failed: %s\n",
+			       strerror(errno));
+		_exit(1);
+	}
+
+	if (raise(SIGSTOP) != 0) {
+		ksft_print_msg("raise(SIGSTOP) failed: %s\n", strerror(errno));
+		_exit(1);
+	}
+
+	sleep(1);
+	switch (size) {
+	case 1:
+		*(uint8_t *)addr = 47;
+		break;
+	case 2:
+		*(uint16_t *)addr = 47;
+		break;
+	case 4:
+		*(uint32_t *)addr = 47;
+		break;
+	case 8:
+		*(uint64_t *)addr = 47;
+		break;
+	default:
+		ksft_print_msg("Unknown watchpoint access size %zu\n", size);
+		break;
+	}
+
+	_exit(0);
+}
+
+static int do_bp_child(void (*bp_func)(void))
+{
+	if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) != 0) {
+		ksft_print_msg("ptrace(PTRACE_TRACEME) failed: %s\n",
+			       strerror(errno));
+		_exit(1);
+	}
+
+	if (raise(SIGSTOP) != 0) {
+		ksft_print_msg("raise(SIGSTOP) failed: %s\n", strerror(errno));
+		_exit(1);
+	}
+
+	bp_func();
+	_exit(0);
+}
+
+unsigned long var;
+
+static bool set_watchpoint(pid_t pid, int size)
+{
+	uint8_t *addr = (uint8_t *)&var;
+	unsigned int control = 0;
+	struct user_hwdebug_state dreg_state;
+	struct iovec iov;
+
+	/* Write watchpoint */
+	switch (size) {
+	case HW_BREAKPOINT_LEN_1:
+	case HW_BREAKPOINT_LEN_2:
+	case HW_BREAKPOINT_LEN_4:
+	case HW_BREAKPOINT_LEN_8:
+		break;
+	default:
+		ksft_print_msg("Unsupported watchpoint size %d\n", size);
+		return false;
+	}
+
+	control = hwdebug_control(HW_BREAKPOINT_W, size);
+	memset(&dreg_state, 0, sizeof(dreg_state));
+	dreg_state.dbg_regs[0].addr = (uintptr_t)(addr);
+	dreg_state.dbg_regs[0].control = control;
+	iov.iov_base = &dreg_state;
+	iov.iov_len = offsetof(struct user_hwdebug_state, dbg_regs) +
+				sizeof(dreg_state.dbg_regs[0]);
+
+	if (ptrace(PTRACE_SETREGSET, pid, NT_RISCV_HW_WATCH, &iov) == 0) {
+		memset(&iov, 0, sizeof(iov));
+		memset(&dreg_state, 0, sizeof(dreg_state));
+
+		iov.iov_base = &dreg_state;
+		iov.iov_len = offsetof(struct user_hwdebug_state, dbg_regs) +
+			      sizeof(dreg_state.dbg_regs[0]);
+
+		if (ptrace(PTRACE_GETREGSET, pid, NT_RISCV_HW_WATCH, &iov) == 0) {
+			ksft_print_msg("ptrace(PTRACE_GETREGSET): Number of watchpoints: %u\n",
+				       dreg_state.info);
+			ksft_print_msg("ptrace(PTRACE_GETREGSET): addr: 0x%lx control: 0x%x\n",
+				       dreg_state.dbg_regs[0].addr,
+				       dreg_state.dbg_regs[0].control);
+			if (!dreg_state.info ||
+			    dreg_state.dbg_regs[0].addr != (uintptr_t)addr ||
+			    HWDEBUG_TYPE(dreg_state.dbg_regs[0].control) != HW_BREAKPOINT_W ||
+			    HWDEBUG_SIZE(dreg_state.dbg_regs[0].control) != size) {
+				ksft_print_msg("Bad wp readback: info=%u addr=0x%lx ctrl=0x%x\n",
+					       dreg_state.info,
+					       dreg_state.dbg_regs[0].addr,
+					       dreg_state.dbg_regs[0].control);
+				return false;
+			}
+		} else {
+			ksft_print_msg("ptrace(PTRACE_GETREGSET): Failed\n");
+			return false;
+		}
+
+		return true;
+	}
+
+	if (errno == EIO)
+		ksft_print_msg("ptrace(PTRACE_SETREGSET, NT_RISCV_HW_WATCH) not supported: %s\n",
+			       strerror(errno));
+	else
+		ksft_print_msg("ptrace(PTRACE_SETREGSET, NT_RISCV_HW_WATCH) failed: %s\n",
+			       strerror(errno));
+	return false;
+}
+
+static bool set_breakpoint(pid_t pid, void (*bp_func)(void))
+{
+	struct user_hwdebug_state dreg_state;
+	struct iovec iov;
+	unsigned int control = 0;
+
+	control = hwdebug_control(HW_BREAKPOINT_X, HW_BREAKPOINT_LEN_4);
+	memset(&dreg_state, 0, sizeof(dreg_state));
+	dreg_state.dbg_regs[0].addr = (uintptr_t)bp_func;
+	dreg_state.dbg_regs[0].control = control;
+	iov.iov_base = &dreg_state;
+	iov.iov_len = offsetof(struct user_hwdebug_state, dbg_regs) +
+		      sizeof(dreg_state.dbg_regs[0]);
+
+	if (ptrace(PTRACE_SETREGSET, pid, NT_RISCV_HW_BREAK, &iov) == 0)
+		return true;
+
+	if (errno == EIO)
+		ksft_print_msg("ptrace(PTRACE_SETREGSET, NT_RISCV_HW_BREAK) not supported: %s\n",
+			       strerror(errno));
+	else
+		ksft_print_msg("ptrace(PTRACE_SETREGSET, NT_RISCV_HW_BREAK) failed: %s\n",
+			       strerror(errno));
+
+	return false;
+}
+
+static bool run_ptrace_wp_test(void)
+{
+	pid_t pid = fork();
+	bool ret = false;
+
+	if (pid < 0) {
+		ksft_print_msg("fork() failed: %s\n", strerror(errno));
+		return false;
+	}
+
+	if (pid == 0)
+		do_wp_child(&var, 8);
+
+	if (!wait_for_child_stop(pid, SIGSTOP, "ptrace watchpoint"))
+		goto out;
+
+	if (!set_watchpoint(pid, 8))
+		goto out;
+
+	if (!continue_and_wait_for_trap(pid, "ptrace watchpoint"))
+		goto out;
+
+	ksft_print_msg("[ptrace]: Watchpoint test passed!\n");
+	ret = true;
+
+out:
+	cleanup_child(pid);
+	return ret;
+}
+
+static bool run_ptrace_bp_test(void)
+{
+	pid_t pid = fork();
+	bool ret = false;
+
+	if (pid < 0) {
+		ksft_print_msg("fork() failed: %s\n", strerror(errno));
+		return false;
+	}
+
+	if (pid == 0)
+		do_bp_child(test_func);
+
+	if (!wait_for_child_stop(pid, SIGSTOP, "ptrace breakpoint"))
+		goto out;
+
+	if (!set_breakpoint(pid, test_func))
+		goto out;
+
+	if (!continue_and_wait_for_trap(pid, "ptrace breakpoint"))
+		goto out;
+
+	ksft_print_msg("[ptrace]: Breakpoint test passed!\n");
+	ret = true;
+
+out:
+	cleanup_child(pid);
+	return ret;
+}
+
+/*
+ * BREAKPOINT TEST USING PTRACE_SETHBPREGS / PTRACE_GETHBPREGS
+ */
+static bool set_hbpregs_watchpoint(pid_t pid)
+{
+	struct __riscv_hwdebug_state state;
+
+	memset(&state, 0, sizeof(state));
+	state.addr = (unsigned long)&var;
+	state.len  = HW_BREAKPOINT_LEN_8;
+	state.type = HW_BREAKPOINT_W;
+	state.ctrl = 0; /* enabled */
+
+	if (ptrace(PTRACE_SETHBPREGS, pid, 0, &state) != 0) {
+		ksft_print_msg("ptrace(PTRACE_SETHBPREGS) failed: %s\n",
+			       strerror(errno));
+		return false;
+	}
+
+	/* Read back and verify */
+	memset(&state, 0, sizeof(state));
+	if (ptrace(PTRACE_GETHBPREGS, pid, 0, &state) != 0) {
+		ksft_print_msg("ptrace(PTRACE_GETHBPREGS) failed: %s\n",
+			       strerror(errno));
+		return false;
+	}
+
+	ksft_print_msg("[hbpregs] watchpoint readback: addr=0x%lx type=%lu len=%lu ctrl=%lu\n",
+		       state.addr, state.type, state.len, state.ctrl);
+	if (state.addr != (unsigned long)&var ||
+	    state.type != HW_BREAKPOINT_W ||
+	    state.len != HW_BREAKPOINT_LEN_8 ||
+	    state.ctrl != 0) {
+		ksft_print_msg("[hbpregs] unexpected watchpoint readback\n");
+		return false;
+	}
+
+	return true;
+}
+
+static bool set_hbpregs_breakpoint(pid_t pid, void (*bp_func)(void))
+{
+	struct __riscv_hwdebug_state state;
+
+	memset(&state, 0, sizeof(state));
+	state.addr = (unsigned long)bp_func;
+	state.len  = HW_BREAKPOINT_LEN_4;
+	state.type = HW_BREAKPOINT_X;
+	state.ctrl = 0; /* enabled */
+
+	if (ptrace(PTRACE_SETHBPREGS, pid, 0, &state) != 0) {
+		ksft_print_msg("ptrace(PTRACE_SETHBPREGS) failed: %s\n",
+			       strerror(errno));
+		return false;
+	}
+
+	/* Read back and verify */
+	memset(&state, 0, sizeof(state));
+	if (ptrace(PTRACE_GETHBPREGS, pid, 0, &state) != 0) {
+		ksft_print_msg("ptrace(PTRACE_GETHBPREGS) failed: %s\n",
+			       strerror(errno));
+		return false;
+	}
+
+	ksft_print_msg("[hbpregs] breakpoint readback: addr=0x%lx type=%lu len=%lu ctrl=%lu\n",
+		       state.addr, state.type, state.len, state.ctrl);
+	if (state.addr != (unsigned long)bp_func ||
+	    state.type != HW_BREAKPOINT_X ||
+	    state.len != HW_BREAKPOINT_LEN_4 ||
+	    state.ctrl != 0) {
+		ksft_print_msg("[hbpregs] unexpected breakpoint readback\n");
+		return false;
+	}
+
+	return true;
+}
+
+static bool run_hbpregs_wp_test(void)
+{
+	pid_t pid = fork();
+	bool ret = false;
+
+	if (pid < 0) {
+		ksft_print_msg("fork() failed: %s\n", strerror(errno));
+		return false;
+	}
+
+	if (pid == 0)
+		do_wp_child(&var, 8);
+
+	if (!wait_for_child_stop(pid, SIGSTOP, "hbpregs watchpoint"))
+		goto out;
+
+	if (!set_hbpregs_watchpoint(pid))
+		goto out;
+
+	if (!continue_and_wait_for_trap(pid, "hbpregs watchpoint"))
+		goto out;
+
+	ksft_print_msg("[hbpregs]: Watchpoint test passed!\n");
+	ret = true;
+
+out:
+	cleanup_child(pid);
+	return ret;
+}
+
+static bool run_hbpregs_bp_test(void)
+{
+	pid_t pid = fork();
+	bool ret = false;
+
+	if (pid < 0) {
+		ksft_print_msg("fork() failed: %s\n", strerror(errno));
+		return false;
+	}
+
+	if (pid == 0)
+		do_bp_child(test_func);
+
+	if (!wait_for_child_stop(pid, SIGSTOP, "hbpregs breakpoint"))
+		goto out;
+
+	if (!set_hbpregs_breakpoint(pid, test_func))
+		goto out;
+
+	if (!continue_and_wait_for_trap(pid, "hbpregs breakpoint"))
+		goto out;
+
+	ksft_print_msg("[hbpregs]: Breakpoint test passed!\n");
+	ret = true;
+
+out:
+	cleanup_child(pid);
+	return ret;
+}
+
+static bool run_hbpregs_tests(void)
+{
+	bool ret = true;
+
+	ret &= run_hbpregs_bp_test();
+	ret &= run_hbpregs_wp_test();
+
+	return ret;
+}
+
+/*
+ * BREAKPOINT TEST USING PTRACE_SETHBPREGS / PTRACE_GETHBPREGS - END
+ */
+static bool run_ptrace_tests(void)
+{
+	bool ret = true;
+
+	ret &= run_ptrace_bp_test();
+	ret &= run_ptrace_wp_test();
+
+	return ret;
+}
+
+/*
+ * BREAKPOINT TEST USING PTRACE - END
+ */
+
+/*
+ * BREAKPOINT TEST USING perf events
+ */
+static int gfd;
+sem_t ib_mtx, wp_mtx, icount_branch_mtx;
+static sig_atomic_t bp_triggered, wp_triggered;
+static sig_atomic_t icount_branch_triggered;
+static int icount_branch_result;
+static unsigned long icount_branch_pc;
+
+static int wait_event(sem_t *sem, const char *name);
+
+int setup_bp_len(bool is_x, void *addr, int sig, unsigned long len)
 {
 	struct perf_event_attr pe;
 	int fd;
@@ -40,7 +536,7 @@ int setup_bp(bool is_x, void *addr, int sig)
 	pe.config = 0;
 	pe.bp_type = is_x ? HW_BREAKPOINT_X : HW_BREAKPOINT_W;
 	pe.bp_addr = (unsigned long)addr;
-	pe.bp_len = sizeof(long);
+	pe.bp_len = len;
 
 	pe.sample_period = 1;
 	pe.sample_type = PERF_SAMPLE_IP;
@@ -52,7 +548,7 @@ int setup_bp(bool is_x, void *addr, int sig)
 
 	fd = syscall(SYS_perf_event_open, &pe, 0, -1, -1, 0);
 	if (fd < 0) {
-		printf("Failed to open event: %llx\n", pe.config);
+		ksft_print_msg("Failed to open event: %llx\n", pe.config);
 		return -1;
 	}
 
@@ -65,17 +561,21 @@ int setup_bp(bool is_x, void *addr, int sig)
 	return fd;
 }
 
+int setup_bp(bool is_x, void *addr, int sig)
+{
+	return setup_bp_len(is_x, addr, sig, sizeof(long));
+}
+
 static void sig_handler_bp(int signum, siginfo_t *oh, void *uc)
 {
 	int ret;
 
 	bp_triggered++;
 
-	printf("Breakpoint triggered!\n");
 	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
 	ret = sem_post(&ib_mtx);
 	if (ret) {
-		printf("Failed to report BP success\n");
+		ksft_print_msg("Failed to report BP success\n");
 		return;
 	}
 }
@@ -84,26 +584,167 @@ static void sig_handler_wp(int signum, siginfo_t *oh, void *uc)
 {
 	int ret;
 
-	printf("Watchpoint triggered!\n");
 	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
 	wp_triggered++;
 
 	ret = sem_post(&wp_mtx);
 
 	if (ret) {
-		printf("Failed to report WP success\n");
+		ksft_print_msg("Failed to report WP success\n");
 		return;
 	}
 }
 
-/*
- * Keep a real instruction address for HW execute breakpoints: prevent inlining
- * and force a visible side effect so the function can't be optimized away.
- */
-static __attribute_noinline__ void test_func(void)
+static void *icount_branch_insn_addr(void)
 {
-	test_func_sink++;
-	__asm__ __volatile__("" : : "g" (test_func_sink));
+	void *addr;
+
+	asm("la %0, icount_branch_insn" : "=r"(addr));
+	return addr;
+}
+
+static void *icount_branch_fallthrough_addr(void)
+{
+	void *addr;
+
+	asm("la %0, icount_branch_fallthrough" : "=r"(addr));
+	return addr;
+}
+
+static void *icount_branch_target_addr(void)
+{
+	void *addr;
+
+	asm("la %0, icount_branch_target" : "=r"(addr));
+	return addr;
+}
+
+static __attribute_noinline__ void run_icount_taken_branch(void)
+{
+	asm volatile(".option push\n"
+		".option norvc\n"
+		".globl icount_branch_insn\n"
+		".globl icount_branch_fallthrough\n"
+		".globl icount_branch_target\n"
+		"li t0, 1\n"
+		"li t1, 1\n"
+		".balign 4\n"
+		"icount_branch_insn:\n"
+		"beq t0, t1, icount_branch_target\n"
+		"icount_branch_fallthrough:\n"
+		"la t2, icount_branch_result\n"
+		"li t3, 2\n"
+		"sw t3, 0(t2)\n"
+		"j icount_branch_done\n"
+		".balign 4\n"
+		"icount_branch_target:\n"
+		"la t2, icount_branch_result\n"
+		"li t3, 1\n"
+		"sw t3, 0(t2)\n"
+		"icount_branch_done:\n"
+		".option pop\n"
+		:
+		:
+		: "t0", "t1", "t2", "t3", "memory");
+}
+
+static void sig_handler_icount_branch(int signum, siginfo_t *oh, void *uc)
+{
+	ucontext_t *ctx = uc;
+	int ret;
+
+	icount_branch_triggered++;
+	icount_branch_pc = ctx->uc_mcontext.__gregs[REG_PC];
+
+	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
+	ret = sem_post(&icount_branch_mtx);
+	if (ret) {
+		ksft_print_msg("Failed to report icount branch success\n");
+		return;
+	}
+}
+
+static int trigger_icount_branch(void)
+{
+	struct sigaction sa;
+	void *insn_addr;
+	void *fallthrough_addr;
+	void *target_addr;
+	uint64_t count;
+	ssize_t nread;
+
+	memset(&sa, 0, sizeof(struct sigaction));
+	sa.sa_sigaction = sig_handler_icount_branch;
+	sa.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGIO, &sa, NULL) < 0) {
+		ksft_print_msg("Failed to setup icount branch signal handler\n");
+		return -1;
+	}
+
+	icount_branch_triggered = 0;
+	icount_branch_result = 0;
+	icount_branch_pc = 0;
+
+	insn_addr = icount_branch_insn_addr();
+	fallthrough_addr = icount_branch_fallthrough_addr();
+	target_addr = icount_branch_target_addr();
+
+	gfd = setup_bp_len(1, insn_addr, SIGIO, HW_BREAKPOINT_LEN_4);
+	if (gfd < 0) {
+		ksft_print_msg("Failed to setup icount branch breakpoint.\n");
+		return -1;
+	}
+
+	ioctl(gfd, PERF_EVENT_IOC_ENABLE, 0);
+	run_icount_taken_branch();
+
+	if (wait_event(&icount_branch_mtx, "Icount branch") < 0) {
+		ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
+		close(gfd);
+		return -1;
+	}
+
+	nread = read(gfd, &count, sizeof(count));
+	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
+	close(gfd);
+
+	if (nread != sizeof(count)) {
+		ksft_print_msg("Failed to read icount branch count: %s\n",
+			       strerror(errno));
+		return -1;
+	}
+
+	ksft_print_msg("icount branch: insn=%p fall=%p target=%p pc=0x%lx count=%llu res=%d\n",
+		       insn_addr, fallthrough_addr, target_addr, icount_branch_pc,
+		       (unsigned long long)count, icount_branch_result);
+
+	if (icount_branch_triggered != 1) {
+		ksft_print_msg("Unexpected icount branch signal count %d\n",
+			       icount_branch_triggered);
+		return -1;
+	}
+
+	if (count != 1) {
+		ksft_print_msg("Unexpected icount branch event count %llu\n",
+			       (unsigned long long)count);
+		return -1;
+	}
+
+	if (icount_branch_result != 1) {
+		ksft_print_msg("Icount branch did not take the branch\n");
+		return -1;
+	}
+
+	if (icount_branch_pc != (unsigned long)target_addr) {
+		ksft_print_msg("Icount branch PC 0x%lx does not match target %p\n",
+			       icount_branch_pc, target_addr);
+		return -1;
+	}
+
+	ksft_print_msg("[perf_event]: Icount taken branch PC test passed!\n");
+
+	return 0;
 }
 
 static int trigger_bp(void)
@@ -115,14 +756,14 @@ static int trigger_bp(void)
 	sa.sa_flags = SA_SIGINFO;
 
 	if (sigaction(SIGIO, &sa, NULL) < 0) {
-		printf("Failed to setup signal handler\n");
+		ksft_print_msg("Failed to setup signal handler\n");
 		return -1;
 	}
 
 	gfd = setup_bp(1, test_func, SIGIO);
 
 	if (gfd < 0) {
-		printf("Failed to setup breakpoint.\n");
+		ksft_print_msg("Failed to setup breakpoint.\n");
 		return -1;
 	}
 
@@ -147,14 +788,14 @@ static int trigger_wp(void)
 	sa.sa_flags = SA_SIGINFO;
 
 	if (sigaction(SIGUSR1, &sa, NULL) < 0) {
-		printf("Failed to setup signal handler\n");
+		ksft_print_msg("Failed to setup signal handler\n");
 		return -1;
 	}
 
 	gfd = setup_bp(0, &test_data, SIGUSR1);
 
 	if (gfd < 0) {
-		printf("Failed to setup watchpoint\n");
+		ksft_print_msg("Failed to setup watchpoint\n");
 		return -1;
 	}
 
@@ -162,6 +803,8 @@ static int trigger_wp(void)
 	test_data = 0xdeadbeef;
 	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
 
+	close(gfd);
+
 	return 0;
 }
 
@@ -200,7 +843,7 @@ int main(int argc, char *argv[])
 		return -1;
 
 	if (bp_triggered)
-		printf("Breakpoint test passed!\n");
+		ksft_print_msg("[perf_event]: Breakpoint test passed!\n");
 
 	sem_init(&wp_mtx, 0, 0);
 	if (trigger_wp() < 0)
@@ -209,7 +852,16 @@ int main(int argc, char *argv[])
 		return -1;
 
 	if (wp_triggered)
-		printf("Watchpoint test passed!\n");
+		ksft_print_msg("[perf_event]: Watchpoint test passed!\n");
+
+	sem_init(&icount_branch_mtx, 0, 0);
+	if (trigger_icount_branch() < 0)
+		return -1;
+
+	if (!run_ptrace_tests())
+		return -1;
+	if (!run_hbpregs_tests())
+		return -1;
 
 	return 0;
 }
-- 
2.43.0


