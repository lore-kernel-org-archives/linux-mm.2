Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0877CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889A56B008C; Wed,  8 Jul 2026 01:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860C76B0092; Wed,  8 Jul 2026 01:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7509C6B0093; Wed,  8 Jul 2026 01:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD2A6B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:32:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A60CBC3377
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:32:47 +0000 (UTC)
X-FDA: 84964489974.18.81F4B33
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D9C81C0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:32:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="D/GuVMHR";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Mv8gkh5B;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf21.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wt4xXlBaiTArQJb4Dc9JxahMF7p7g/k7Bc47vJjViYw=;
	b=lOcNrbROMd2hMjfsX+pGnV7y0c21tObPq5jVhDQCjbloxyO3TPaTm2IVM1GuKyfFgBxyhd
	sjlGcwOOjERsKbfpo7jKX6jvP2liEgdJwp6U3NOSYR0LQyrlrp3nCcJJDBRPHcFFe6D7y+
	10w5ty+AmTyEq7LAtdx85OqFiuY6hfc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="D/GuVMHR";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Mv8gkh5B;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf21.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488765;
	b=Os+r9UwMt85hpGQjH/rEpvPOeNAunD7VVYYadSNYTQZiamyEqqhCCcsw7oH0gFe6k76dvX
	ZkupvmhmLazWC5wrxCKtwfIAVunH0xXHyuZxI+SNhSIKYC0krrOlRfa6J29pEknYfQ23x+
	lASCpQU/9QIJ3OwH9lCjGu6DLurqUVc=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842S7N1447410
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wt4xXlBaiTArQJb4Dc9JxahMF7p7g/k7Bc47vJjViYw=; b=D/GuVMHRdMYWGI1n
	zcnAq9lpN/WhuPQNUi7IePjTU9zxLKQDqzCLYxNbMHdlOJ09mo14YIGsgDPvyIAY
	RRCA56dsuCJ5WCWsz2WAmwblGV77toDFBbChK7iNJ/vVVtIPQzvIjZWPDe9jYr1K
	uzDrcqXIvdYEpYzC58tGCon0724sJCjjUCULAu8evnTuMnDM1uXqSEQc/ipO7I1T
	VSHsuLI2QPFinLNSeyng57txHpbeSTwQhux3JvOS7YiN6Sx+j1oCdRcvrWeLnm5S
	H4hwgq2dJYhKB5J5YWKpQQ9eZQvOYmz2HXyHzt5wlr+VFGeXHqm0duuedn9rNN07
	KhJk2w==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f97u11t9e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:32:43 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-848474825ffso223897b3a.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488763; x=1784093563; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wt4xXlBaiTArQJb4Dc9JxahMF7p7g/k7Bc47vJjViYw=;
        b=Mv8gkh5BUX5dlk/VySm1SOyKskzDR6YID8dXsWfiEQTvu3y2ZLLuScrJ5hVgdWPz7f
         kzNZi6sCTlYGfgZ+eQjgkOtg67csgsZ+pxkEfcT99JVseOsmzagA7qRiIbm/eZTOwtOY
         uB0MuUO1+91aWY8XcRfJp51pkMQfOM5B21Ez4c9TVVATEA88vY8yaMn8gU7cxd9vSl0q
         HH/sY22z0W2OrSjj04n51j1P772qzp/Un6qU1p0heihUQyKb3Uhd75Ae2EJWsrKA/jNZ
         9irxMBcLhKv+sD/WsiyBKSDilQR2xoJ7BNW7P9bk+YYip0w5tjlaEU3L0cyZsZ/lc1R3
         7BGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488763; x=1784093563;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wt4xXlBaiTArQJb4Dc9JxahMF7p7g/k7Bc47vJjViYw=;
        b=WaJqR2iOfAIdnE3truK9+4XY3j66bWmeUnmOSJ0r0R/Qms/sdhN2RRFEGiIHKU+w6F
         Mbb7t8V20Vc7HQBcrLnqznwOw/aHHCqOz6Q/h/cpHaCVEbkiGc8tylYqlWcmIrvO91yB
         SCrcia/+Fww2enDrF1DxbodwIZVbpGtYsd9PAwbgpVX+YZ8MG5F+oLUBbtxk9HXI54N6
         ZWHSLSwpN8vL5zQnlTpUhuRalkkYhQo06I8Sgf8O9ZTLdNrZyzUVnczr+iM3ZvR5dg1g
         zgFKq0esGSPjAFxpr0g4ixSuYEUf1ZzpU8IoizQSgPmvnspBZmIv+y3oQeV3zCQRbO4P
         L93Q==
X-Forwarded-Encrypted: i=1; AHgh+RrVaTuGcEkWpzJJmbwtf+93jEbYKCuJzc17ph7EjUF94C1iLSvgsWlkPGaH/D2XijYYhcPWYs+/6w==@kvack.org
X-Gm-Message-State: AOJu0Yw2VGiafmId5oeEUB21CFqwxrNcjBNO7A9pj8FjEZXdPR1nCTNQ
	Qae6mER1855ccxobtMQRWSUDW5dRzjHun4q3L2A0727TcZ1t4tO3Xd+SoIXx+FSVh85SuHQF0DB
	aYbWcusSuFt1BoH1T8OU+b+Fw4guCTMlXYBOmwtGMEQ6wFvJSa3UlQw==
X-Gm-Gg: AfdE7cmAZoMutuqKk96YZWOhcxKHC7yzMgWrj65okV/kO6hozFgmUBEqzW8WMA/13w8
	ImuBd4zN4l7AHS8QENRfp3Iqpe2v5v4HI9EtqgvgNkxZZ7WCGFnLHR9b989783HPVYNy/D+ENI3
	SwTYuwGPyPqy36fQZKkkH2f0AhIx+z7u3FwgiD1CxjKvqwwrTpTplYhehnLpOW8ka9OAgQdWmT/
	Sc0wtP2+qj6EvV4YmexvV13ieFiSL7rKQnXuUGRXKOsCOnBM1sjWkLoVokBrzA4OvmfGpbnyd5p
	Yrmp2bNuXo17R9evOtZWyfUpPQjMWqNwVlVYTNmiX3jG7Fv5QsPH+LBT2fQ6w6yg7/yTSgYHvfa
	fU+ImdprmNXWfxsesljYcYaHWIv+dh0RtNUsEWg==
X-Received: by 2002:a05:6a00:3e12:b0:848:2ef5:50d8 with SMTP id d2e1a72fcca58-84842ffcc36mr985398b3a.32.1783488762950;
        Tue, 07 Jul 2026 22:32:42 -0700 (PDT)
X-Received: by 2002:a05:6a00:3e12:b0:848:2ef5:50d8 with SMTP id d2e1a72fcca58-84842ffcc36mr985325b3a.32.1783488762180;
        Tue, 07 Jul 2026 22:32:42 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:32:41 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:41 +0530
Subject: [PATCH v3 02/26] init/version: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-2-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1541;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=biMhvzpDIK+Q+HwprmIy/ZCCVhqzt5rT4bfWf3Rfits=;
 b=k3O5TLngHyIRrBNI52+BrcUxw3xmjpVsNzhWV+7yBVH9wpmKpORd/vbLo8LxRWzzPpOJi8dut
 RJ4Kz16BlfeBP+Oj/O1AoT7PAHbGUl+ejWRIaB969xrnlumEM1RZh3T
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-ORIG-GUID: UsNKTrX_p5Bb6Tb-DrHbRANbU3_B1KwA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX8xE8Fl5xcBT8
 6+a5mrbPaoidHcUQUoX9d91yqWmCnH5Q7vXwq/I9Qk/PLFo4rxnbbw8+6Sln3Zt71LPEEndJyDt
 lf72Qq9BkugdRRWBLSgGP6QzqPN/z6Y=
X-Authority-Analysis: v=2.4 cv=F9JnsKhN c=1 sm=1 tr=0 ts=6a4de0fb cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=ZVr_NMlg2zHurtFOj60A:9
 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: UsNKTrX_p5Bb6Tb-DrHbRANbU3_B1KwA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX+e/IZHCaimyi
 C7gyA/5OxK6A2iCs/6qLSvVnZns0RFIGzu7mZcxJBcdGzMAewMGaxVwz5IgpVgjJVbdR8zYb2sV
 GuaEnaX9XLG80rouz73AKD9IdpOuwipZjSshftXDNA0mLzFMTNwttWCpVl3DyFdYF0JU4YE5lix
 K3Dquh1Bz7Z04ZL5Jgz3XGBA3zEoOzC1Jo1QXtH6c1xnLu0UQDltvEjf57zmb7VuiihZ1nkg4W9
 g5690s3pxz9hN8iFqaJXyn2vTxzedHBGdesZQoajilGDH7SqilFpP5xQ317W9f+GLBDwwTMu+zD
 XqVtsKRmt1Ent9aaygHfKmHQq7qdkSPCm6wr3J7xw6CCfy/DobKFCXldPNsJ0Qxy/EVv/JHSvuQ
 Yy7BJttqtx8NklWdtW+FG5z70UsO/xpHA1hoXjsIEF9Uo/Ls7V0ndm3VXvknPvK4PxSF94qqS7r
 hFXy6MHNQ5R7/putaBQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Stat-Signature: eers59okrzaqo3bx55abgbwozyy1k45y
X-Rspamd-Queue-Id: 0D9C81C0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783488764-460432
X-HE-Meta: U2FsdGVkX1+f2uDA+t/5dcPCqkafCYmmwyKZvfH4SZ+xM3ZoswikqSvQcBhZeikgewXUYNqXmQvZfREZCbJJLO55CWcvH8wqCLBsriczhkaTnYxGHvV5TTaDxr5hqvVlv/nlM7qtFujHJStgqxYeiKkNkG7TMowYHwX9klklEhan1owhYQPl8JHyv/OdFEQc9rr5rGUHCI8GASURDo420TbqqSivPzER/AMimcMo/82xmBhEGYB+23NNEEcW1VIOtqw33kvltZssWnaIprU9B4r2HHeV4MUWtRc8KSDzTnsVHlZhivxI81blB5bArU1QI706jlJlZRlBz6M/HIv6xxBwpUQUbVdiKfASYqr8Cu9ketq1R4odKJSBmXYEidqIEfJU4LEW2Yh0QEQ2uUaU2ngPadxLV23sJEzNVKtPaAZogtmXQ6WRdaYpfZmPS76uTJXRycmrC2OZ5Oh7VB1nrcoBgGre8JKWLJzRRqyAb73Z+zOPnKkjF0sHjAkm89YQUCiygwGM38vGNMa2+GgF/hHbo3A6DX4RaYQQVZjNqBTbdMkGi/JGAqkJqYHVFvOa6JNH/6DGoyXv79CKou45139/FkteywPmLHEJEBRcjcG+KUmaa90gHfwsS9QCHobVsWQ4YRVec5IMOenUoE+C1jcNAlnj2c/L5d6di+vMq2+dJ6FM3GgnJBcLtOKMS7A9ecb2aWv93C3g5UZ7VvBrSVfNtbcPH/RUmFYvqwF/RrXz47hP/jjnSCAHO9Obujp27LShqBNV3fM0AwhtzNJLnpD0I5aJ7VnM2ho8YXRJiVt2wpMajHgjKE4zcj+SkpFaTSDjiwKGuJpo8sULBoa8fwpxOuL7ADvFSiXO14IPlCzpEfVvXgP5KxuKDEyuRU9lNY8v7mG9Zs45rc5lE8PpaRulJCC4seRanceiCb4Gi0qW0XSrriZS56/IBK9yAUbvCtUeDKFTid4FKXWUtuG
 StKLipY9
 zPMeaHNbxHbkRqBc9SlT0yrM/rVizN3vDTIuvctM3h+JfLy8tdQ9Skmp64eor7BEnrxUjhFsXyKhVm4I0uxhU10BuCC9a46HdC7RF4wZ9G9r+4q4IsTrDtesLz8wYdwO/9Q5ms2TT/5aaUhVmy4aaCcY7Hh27viQsFRustUAzl4o22YZWBxUhZW5cvYDLTHcDf7BPaMT+IisVqsTm81ohBnuLJMeRiNRvcG3UgJ6J7D+Fl8e4+XDxAtVdIhzVwcXQC8iv+P7JKNCjxmllu+85IB28vHU+X7zDjqmJyYtUMvRsDbtLQrD/njiZPDpPphCB3z2gkPRHKrB/BPG0WhtAlEIJD7b1aiBD/YvsiaZC0IFHO2iTlthBO+/KDxRZBdW1Z/lHZWoHh5/k3ZIQwyYAuIagtyj57nU8bnyb04d9csHExVsK0f6J0Q7KO3dVt6TBlOQHFAjdfOU3uSZgtMoFBUAIxIrnRoDVaxvtd74fEAHo4jIuKO6Y5h2XR3HSildiUiRYDdILC8nYg1QwSRdYlL1BJQPdQtuljvFL3HDorcgWvJ3egoGywfSaHKNvzFDeLLDd0FrDZqRbUXXQz2nfn/LynkJr6V3TquH87eWhFTKRncmCHIojEzLGCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into inspection table:
 - init_uts_ns
 - linux_banner

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 init/version-timestamp.c | 3 +++
 init/version.c           | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/init/version-timestamp.c b/init/version-timestamp.c
index 375726e05f69..37bdcdd443f9 100644
--- a/init/version-timestamp.c
+++ b/init/version-timestamp.c
@@ -6,6 +6,7 @@
 #include <linux/refcount.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
+#include <linux/meminspect.h>
 
 struct uts_namespace init_uts_ns = {
 	.ns = NS_COMMON_INIT(init_uts_ns),
@@ -24,3 +25,5 @@ struct uts_namespace init_uts_ns = {
 const char linux_banner[] =
 	"Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 	LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
+
+MEMINSPECT_SIMPLE_ENTRY(linux_banner);
diff --git a/init/version.c b/init/version.c
index 94c96f6fbfe6..eeb139236562 100644
--- a/init/version.c
+++ b/init/version.c
@@ -16,6 +16,7 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/proc_ns.h>
+#include <linux/meminspect.h>
 
 static int __init early_hostname(char *arg)
 {
@@ -51,4 +52,6 @@ const char linux_banner[] __weak;
 
 #include "version-timestamp.c"
 
+MEMINSPECT_SIMPLE_ENTRY(init_uts_ns);
+
 EXPORT_SYMBOL_GPL(init_uts_ns);

-- 
2.53.0


