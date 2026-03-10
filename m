Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A39FD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD926B0098; Tue, 10 Mar 2026 16:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78006B0099; Tue, 10 Mar 2026 16:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943056B009B; Tue, 10 Mar 2026 16:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 807E06B0098
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:17:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FA2358481
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:33 +0000 (UTC)
X-FDA: 84531263586.05.038B505
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8D9BB100012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=by4B4Kk5;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=AAngCB4a;
	spf=pass (imf14.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/p5bQNtsurS8ELLM8cfGcTYhFbVSlQNGcc/PqunPdEc=;
	b=ueHoSPvCIuiMsgCdlktoGgheM8fd5I9DxGg7MDR0F0QONEo56ofOFByCCOsLgHJAQ72dAL
	qPf91p+bspKhX1NUGojBoX2h6SS5RqzhpPVroSAtkLeqw6cYoINBEO+zEV6/+/hqISCfOE
	ldv8c5H13TH5/pTpsq0adZORI1+zziA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173850; a=rsa-sha256;
	cv=none;
	b=KWok1SUuasTKSOcgJlivUehKNY1RHNKa9Ga2Q7dZ6jIuR/CHpmUpWHOd9ZOB+p7L9cJC6V
	Tm1stnEb9C/3lvVQaw1njAawVD+5Bb2awFrHMyMg7cqO0cF7p9ob9Ke8zQ0kO1iZ/0f1Z9
	dc2tYY7+u/lAxVxdNqFXivhZzR8qKww=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=by4B4Kk5;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=AAngCB4a;
	spf=pass (imf14.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIeJWB3759617
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/p5bQNtsurS8ELLM8cfGcTYhFbVSlQNGcc/PqunPdEc=; b=by4B4Kk5+VrKoSdS
	6QyqTOk4zerpxFHN9awWxqzVBp5b3Mbr9Z2OSzscqVAx95NlEcLuGCeFrp5wkCor
	c4u8y1+2cddOZHOuCwlb4trlfPIlcBqsiLktXdRhu26uZ7LrcFQWmSSE1xgkztHZ
	bRkzfwzAfTXWaFbv9/xATSrCiv2I3Wfn36Loaj3XoBEioFfD/2E6fsm63URDyl2y
	nkIFioEFaNvJKMYKFzFHpmIGQL7IU1jCt2ZIcL9zpLf2QlAYZrKj0XqOF75lafAU
	dJwLzxk2YiqgzWwu7Pg7sSwVEv2cgU23b9noj6vPEkTuFMFs2LXYtiNLQ7ovBjj+
	SjLD4g==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctk8uhvrt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:29 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-829c331b4ebso1208361b3a.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173849; x=1773778649; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/p5bQNtsurS8ELLM8cfGcTYhFbVSlQNGcc/PqunPdEc=;
        b=AAngCB4aU4Q+g5ovefADRDVcmIVoELF0a9T+7khb+Ql+KmaQUQLPXrPesWKLdLNWI3
         nUqgw3tT2U2/fT0aRl3eK/cb7iB0HFThl/w9ksb4tcNZs/cXQcX0o1BblP8Zsyb4296m
         bW6Sr13JPkbRt10CxjgciNhx2PmdDc5mOLHBAzh6Hl7KCU9mzUyH3/jPc5YHB8xqoOlC
         Co+dD53GER+19SesLoEV1mewTZxDlvDxZcLX4coIoH0BbQ34r4ypbB6TIH2c4/vz8XgB
         qB4Ed3YVmGtwIF+MKvyaElqQqnmL2QRN8ymDQcxrMuUNe2uoxi4UF5dOp0lvVPrsDSHZ
         hclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173849; x=1773778649;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/p5bQNtsurS8ELLM8cfGcTYhFbVSlQNGcc/PqunPdEc=;
        b=a9Dmtf/2ihoOqrW9/L/Mi/oaSRzRZzMPwhcQ0sANe3uz3jwoEZ36d3fpOiQ+z5onAQ
         1ujpoSp+eDTqcuF7Fo9lJmygmBOvyE8eRUkue5g92aNYEZBzVVWgl6yUKSy6XX3ZT42L
         BPCq5IfaGE4fY5j/x+aLDZPi+fJgnUD5ndHq6ltPlbz9PVd+pqQvKh/phsyCSeZhYPsK
         jxBMIQ638xHOl4CegyRa48exyNfXIxqZMuXkKvyMmserWM75pbV605dtDOwZRSknS92y
         y2pksG2bsEYvIiEej+LUwYT7K6F6UZXPnZD4F25Uveyc6tpwf1x/BSjx3EJLguZNjyZL
         0TTw==
X-Forwarded-Encrypted: i=1; AJvYcCVFZWw94MGArFqgoz9/wBSadR3gzJt0twRUmVZimlD09IrQ9julnTMBpxaGfem8r49UTEKQ0Q+p0w==@kvack.org
X-Gm-Message-State: AOJu0YxDUjlI8hP6BHdh5E6qR0xGsw6u/yp4fS0NtJ/sWfYTtQK4Rpkk
	1O9HplVF37aQTt3KmDEz8dgIGIiuqvz7sDocFVTF9s3FcjZEnFRa+dqGTMNz9fZMGNA7gu0gL6t
	uI+snU28QJbXNA301U3kYT9Io2M4r4/bwjzRNhkeqfC4AGn2w5GXqLA==
X-Gm-Gg: ATEYQzwpPSs7IQK3YdjrlSx+5febOBU6Ly9vMU1tykpc5vh1QgjgIzKxIkSj7zdS7sL
	52BXTRrm+GC5UDPVVvv+24iDfC9x44g9/kO/Fpp86TMqxPQoZ0sGzkGMTPVFH60lGfWKu/6tdF7
	bkJBo/jqkpDP5RUZmAeZ3ts4nZfPeuylO9ImkTTXrCEkmOClC2D2uxNyWpYBPsJu3JvUkxUSAJM
	zEMuJ1QYpApvAPkEnQVjKpA8+5+9eRGqzKdAxH9bP0BiQrytgLBFeYo2Nb4Dvd7gN1pSYuO/F0F
	CPF5KjZmDsB02JchZY0VoiJ5INYCMPnI9szggIZmvR+u9EvUM9LttxHI/J8EUIC0EUxWhoDl7AF
	xnhnZzICnvdTdHy24VeE5VrRZ6YTQGPGAUx9VgG4H2BplL8nK
X-Received: by 2002:a05:6a00:180f:b0:829:7e6d:cf12 with SMTP id d2e1a72fcca58-829f6ea54e6mr176848b3a.18.1773173848451;
        Tue, 10 Mar 2026 13:17:28 -0700 (PDT)
X-Received: by 2002:a05:6a00:180f:b0:829:7e6d:cf12 with SMTP id d2e1a72fcca58-829f6ea54e6mr176795b3a.18.1773173847792;
        Tue, 10 Mar 2026 13:17:27 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:17:27 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:49 +0530
Subject: [PATCH v2 05/25] genirq/irqdesc: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-5-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=961;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=UXg1t0l9m5ubA1qVNL7kczvqoaB7NuMSr+jbvqU0OqA=;
 b=tpLi1SDrgekMvdM7bSodVPbvBq2jkmRJ9w+7dr9fMPSvTOVcpu589oNcA+Ssz2qd7S8Bd4rG9
 EZ0hqpigrLFAIbWc52tOHGSzhTc9cgRgeA1CcE72coJ1nJxp+QVKA/P
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-ORIG-GUID: 95loceZcOnzy58HTHHraEDWyuMisAn8M
X-Proofpoint-GUID: 95loceZcOnzy58HTHHraEDWyuMisAn8M
X-Authority-Analysis: v=2.4 cv=YcmwJgRf c=1 sm=1 tr=0 ts=69b07c59 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=W0BCv_TwhUmk0ohr3HAA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NiBTYWx0ZWRfX7xTCtJSx9QDd
 dxX0jDkTtgmk1capQp4mSi1LpoXppljRputl/ve/ubEd6yIZVNbEWF4PNKl+eeqz/wYiFAnCVbp
 BwOLwX2sOauVzNQ937YqSwGbnUtb6t7VUFh3qjpR2x8lD4bZzHnxStSfogCk1SxiCAjCQ9347vz
 Quip4FMUJkg2xufYtQ19hd7/OEmD5Bz5WahmfdbvXLYjMkz+Xb/5dCDOGT+Gcc6aWkuZXQZm0KW
 4tSta2QAqDRzOnNW54Kb5aWcOokD8rZ36VhGOD1TQIsHU2nlB+tqmn9dWbKP47hbqf3uGg13ADu
 myVbLoMMyGFyzZKzzuuPdPLxBs2oihtdcgFgB68ELB03uZcBqH6P/+IWTCeDj1oog/8oVi/FrP6
 vSfkSzStzJmlLUhdViU1dr9aX1liZ1gsyqTB9I8AxJaS6XBNQvfdJdymJzbX9fZcrCYRizSv2lN
 z5bt1FvW7tlPF4TVw+A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100176
X-Stat-Signature: wa574g6amr1yd7cy1qkf8hcg5wb6nsf5
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D9BB100012
X-Rspamd-Server: rspam12
X-HE-Tag: 1773173850-290727
X-HE-Meta: U2FsdGVkX1/yW7dOsgnL23UB8uWBiPSLRNw8Y/QC4Ay4DtQWfhUZgm3+xLseOP4SdiAmyNsA/rXY6uXVa5iKY0N2DCNfu4ZYnbXlq12ifEA5RdHGlDS8IxAPb2G5BO142+aeOT1Mqw+VVpK6yrc7S2SglgLDX5A/OcBDweNgI+xKeQj43F3ddMDI93fSjABph5813nmEqtSTHxTI9VKEmcUgOoaEJQNWZGOHf3US4N7s7c7V8vymGEaQkdwy7vtzy7vKMlkNrGyJKo17n/3ki3S517O0igOZ4i3Gauu4GT/BFGVpJptC0N8dR4+JuTXy0xCMYTUKQPIxaqVTK3rb04WRRSuwmbByr0RIGjUi6jCMN27H2fMULTo4Ow/SG+713SEc5WncErkCC6DpfmGNZXUNVZGCsuyIZ0+kcnXMeYCU7qh/iDXtpN5QCXYMp0hzOcb53Qa06pmNIP8B39ALyn5odYJIrpPcTmblxF+/00LzDjadxGCPFTT5YpT0prxMQ8dWE5r2O9+/Ee88CVndvNu15rN7XQ8uydTnbbTOymxFs0sOxg54pG/d8yoHD25He8Ya1Li3iUJpN++Z3/UbNzifW8wmQMCyPgrzoSM+Ck8XLvp6xAUHnnm1Vt6FMa0lFfyiKPlMqAevEkYCQ2cMfXwW8H6+kUEzGMgdHOJaT4DDeMOKhgxbLdlZLg70bav7QSjTWhGx+5Yl31O/akRtmiGtqy0S5Nsk/pj0r+TAWnLwyXndoTASt3n9t9gyEXdywmMDPRoL2IZ5rjCL7Khxkj5ESaToIQ5oEz48mXZa1ztEsjr3C4rA4VqdGJy795iJIR34Krz+J0as3QeACWYWsp1FsfEECd5bCfeomhyjIPyXr+l6n17OXbBN+lk5bbbUkqoX9lkW1Fd71ap2AcmmJSVTWsKB02FvMVxQuzSi+BXsNispBBKe9v/C5M77VvlpowFtiYtlP789QEekCQe
 UEUu7OVP
 k4oAy51hL6f62jdcH88OrHCUmJML6jF1O9ueIAV0KU74ki6LcJ8mJThv0/EGwQSDudlQ+q+ewsmp1HvYsnX1gaiBxlZGiW8A+jWX3SIYLmR/jffJv2bcKhCHb+zsxTqiUyyOxOvQ9/bkzG76cGtD78hbbJCFzLXUUzD7xfZKIBMjh1APuiyrt5s6xajDLNgFXTRhYEgD0NQM9785B0e/AltN0e38y4Rs90acdF5jlp8t3DNZ33PFsjv/DFXcTYLpYj4QMUMpBccZMpisrWbcSAPZv/cV6TFE2OxcQ0Wr4XYzSZLhK9rn3q0/vrvZKTt73dMU4J7GVCP81K1vxfpsSJUJDUTvo7BSmjNof/Fz3txzGkhQ3P8uGanQrdr41Gi7X0lsMixUPwN/q28diXYpUZEBQZScmUZfyWjRXtVXe5/VQnh9+a5oOzrUuvlNTkM1ACfKaehYDwKy8hLBTWiIy7I4T0VMnsaZ8ZxHstiFWi+jkIWEaerz3woXJqCZ5ZHO47CNfoFFq56tqMXjSUfPiXi2CwfsmCCOpjFXDFTmHlG0EL+ylOby2CMe0ZOL4ZTSuytAxIpb6xceXGFAbrUnuVr6AYbeKgDsMC97fIFyKti+CeR3xwe/a0B02RCZWa5a5mddRPvgDeSbzUDYKHx9YLAUHZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into inspection table:
 - nr_irqs

Information on these annotated variables is stored in a dedicated
meminspect section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/irq/irqdesc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 7173b8b634f2..44ef0ebcc3ce 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -16,6 +16,7 @@
 #include <linux/irqdomain.h>
 #include <linux/sysfs.h>
 #include <linux/string_choices.h>
+#include <linux/meminspect.h>
 
 #include "internals.h"
 
@@ -141,6 +142,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 }
 
 static unsigned int nr_irqs = NR_IRQS;
+MEMINSPECT_SIMPLE_ENTRY(nr_irqs);
 
 /**
  * irq_get_nr_irqs() - Number of interrupts supported by the system.

-- 
2.50.1


