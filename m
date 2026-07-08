Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C050BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCCA6B0099; Wed,  8 Jul 2026 01:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3ED6B009B; Wed,  8 Jul 2026 01:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2F06B009D; Wed,  8 Jul 2026 01:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3A46B0099
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1F4B1206A3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:33:50 +0000 (UTC)
X-FDA: 84964492620.13.8947147
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 471BF1A0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:33:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Kis4SS8T;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="F6Tb/C+f";
	spf=pass (imf19.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITO+JE3opr8LgPgXIr5SaVvHjNfRbkajEoRTp9nYlQ8=;
	b=mPgy+DO+laMZ/rumSEY4fjhOubRuBlx2F0k2m2aTWxXW34mPCgRh39lqRujU1G9h7dH8OQ
	Hss/i8x7AKQ2Nb+NApELcmZyjXfH3XU5cmt1kWXh9SNbn7QAvG9hgPTQzT2EXBtviAWXs6
	Yn3qT59AKV+KXAF3dMO3mSoNoqMBc30=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Kis4SS8T;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="F6Tb/C+f";
	spf=pass (imf19.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488828;
	b=IQOKrQGpg0AeT3qmmPo/QEEn+u3N5IALPZBE+fPBu17FwtpowsbeKLLBa/sZ6geNd7ULgk
	Z/8J3Sn7Upc6LiB8gmum7wEl1wBTZ9nW4GohNoKYR71Ev+b9imFoAMZLt3DFrFSlwVI3aY
	2VwDFMP551k0+1s26dEHjCkM5GgubqI=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842XP41447584
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ITO+JE3opr8LgPgXIr5SaVvHjNfRbkajEoRTp9nYlQ8=; b=Kis4SS8TmV5iP1Yz
	l7VP5KpLpSZzCD0HrWRlM9bPZ/SXhy/pzeuagg8DfSkugOIRNgwO+qGFPEI8UTz6
	xxQpKMEk3q4vPwwhSx2yHQIvCKGadfWDzWEVWxxZr1U1tAjm1JTlZhcuxJq/wHZU
	v5KN+a2tdu1/uxc1SoYHlL4x7Zm1t6TpzqRjbQrtGNZjDwpsvXYsl4iAMzvO/kTd
	fHtdDkbAxSVGRHy3kRK5EmfbHzCsONFcZa09PxBGA18MaN9K7IL+V55kZODy+bra
	MfzYkjW7Hiq0Qt7h8a2OhI8IXcXLg5BAILmPstdQeEwpidHjLbiSIdgV5v2jd4m6
	vvOMqg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f97u11tfa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:33:47 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84240683a82so329875b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488826; x=1784093626; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ITO+JE3opr8LgPgXIr5SaVvHjNfRbkajEoRTp9nYlQ8=;
        b=F6Tb/C+f1mJS7yCs2qFCzCk+YrIpeo1j3kuk+3CwftzAZ2MoSkly72kJEhK+z449r7
         DZmTYPwD763+tz8alw4NqwAWfoD1gtG9Dq22Gt/6vyjQrw2tG6Aw2ruQyzjXcGF4VdaY
         xhbhYioSd/Cm//59tuSjudRbmF2H9iSy8FQ+KjLKWBLzRPYPXFG0hHw8irv6o9YHmUfA
         QApj++n9OyvjGQtb6tT+/FdpyLougi7vAhIROWWFNtinrU0686i5XqW/dbcoGajIxnCi
         Ddgv9pR9YicAGk02PZsly6xf4Ja3/wNGAqllFKNdFQuw1eJ2r/f3ovfQCJpigWVwkKlz
         ik5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488826; x=1784093626;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ITO+JE3opr8LgPgXIr5SaVvHjNfRbkajEoRTp9nYlQ8=;
        b=lTyyO829v2FeZtlkGLJiRHSj8HwAyDlFJkPhgwhIXk9V+47L/9ogwIERVww7ZiX4zS
         PGaCKqogkQ8imtZJBKxb08eOZrs5Fwi76MYgrutTs5vAcpWbv+55JHaq+w0ZrK3sv/Ic
         NasP0czw56xlqh2yYZQmX9xY0AOEkeh26tCC0iJarn1kOPvXjbWFTg1Tq/iR5yRvCZ6o
         6wifus4LYJuZOIZ8AC6b7C31RzftGsC3pyJeD2Qjnzqvs0qlcpESsECgLA5oyQ4CWxCe
         Yhia774ZXYz2e7JkVmzpaGyxs9NaUyVpu2sVD/Fp8vlQuQq0DyydXmGVDM7q7hRAfGB1
         M5PA==
X-Forwarded-Encrypted: i=1; AHgh+RqYWQwU19Ymqn6bHJneNH9UMd+rxda9Gs8GbmvQ11511XpyJWTXXuM02oQG3aHOcYsNmBl5G+ifNw==@kvack.org
X-Gm-Message-State: AOJu0YzECpZKL4FGknYVLio0nqxhX/0rxSW/CMwHd4Pyq1WudwHe2Tfo
	rGS1z719RkW21p3gVi5+Ie083osDA/bD3OBSJJN9C1U+gJ2yMoW/aEsdPDOqXAfNeaGc7LpS2gK
	eCLKJ86O9jzddfLbs7LTkFLK5r6BUu8RJok1ocQyIMaN4pZQG1Jn+XA==
X-Gm-Gg: AfdE7cmefurBSn85wNtGtj7X9514U41r2jf1RlvE6n/glzul0uNZXGg36WuEKQPL6XK
	h6wmerPngBPoA17jptWNnP02O3WmjxsANVkO0pFFrZk4B4z55jslYpccJ1YcsAUwFtV+D8N4c1N
	cimCoYEqRQ6MJNh7OheRNRONhIyUXaG/VD3lUP3qoGY5wUcYDtLUpOkhdgFe036uto9H78QAgxy
	5v5eIMlkcZHGN1KACudoUgWQCG+7IExreMIUB9eakUusqAYqI4Wlzl1/HhaAnhmze4/7lmMwVLN
	dlDF7Ew7tCleXv6mRYcwPoqH5iWmf8VW0SF54bVH5N40A6at9IbMI6L5uwNmV6YddnifDeKaCGn
	kBP/78f9+hKZsj8HqwheM9kaXNXKeGmQv/Nq+5g==
X-Received: by 2002:a05:6a00:8d8a:b0:847:8791:f54f with SMTP id d2e1a72fcca58-84842fe321cmr1182161b3a.29.1783488826164;
        Tue, 07 Jul 2026 22:33:46 -0700 (PDT)
X-Received: by 2002:a05:6a00:8d8a:b0:847:8791:f54f with SMTP id d2e1a72fcca58-84842fe321cmr1182097b3a.29.1783488825439;
        Tue, 07 Jul 2026 22:33:45 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:33:45 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:45 +0530
Subject: [PATCH v3 06/26] timers: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-6-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=952;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=dRXeUIpIlzWe1LNHxoHjAVpHzKcKSqqlKNhUPjx2KTw=;
 b=FTqRhuK4jJoW5z8xkIzP9taBuoDPVq9v+EOp0exYW2spJdYWD+lEd+oHVaecDxylcFpv676MQ
 j09Wz7/ilg8AWemdOCnZLhJohxL16BOY0AIU6SL7rCeCEXHzowGgz/i
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-ORIG-GUID: 6riYBKlhiFoUXOil0UrkqostHfxyOeTl
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX1S6FL9uX91KT
 +7ryoB95WvGs0y43POJHHr0tem4xGSgUWcrmjVPHwdD7dRSJyjSnjeCQAMTf6NK8SL/aGM8OjJt
 V1o1utF/YoJvR5/4NfiZjvfwTmxMQ3I=
X-Authority-Analysis: v=2.4 cv=F9JnsKhN c=1 sm=1 tr=0 ts=6a4de13b cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=WZmkKkIAQcJSthQVk9EA:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 6riYBKlhiFoUXOil0UrkqostHfxyOeTl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX6yuaOAMSP1Y+
 Ii6UYJpouvBqxhwmJkRXE0Ad9qrS0VE8deJsP3bdA5GrGhVq98tufkXepu4kfFqZ5hdz4tTYb9U
 DtR0mKr/z6e208KYtuNHMJJKSqfzsWFY0dExm6iTpxcTShmx+PsZC/I6zZAR+stJpDWF3waqhcl
 Zf2QEkb17AZ3QXqhSkNTEthFVyqDDjZxXhH8zpc+YqdZW8pekshZfqLKDyqlWu1khSK0IBdKgjL
 l/IY1ghaEk6fSRrpTw2EZsbr3MF03o7BkI/0PeYlPgoJaGvLK5Q0xQxw0xzg6lzA8fM101vIsvj
 f6zrih4DbRv9qrFgd08xdas/FsksBZNrpPdxBNYwyslC5IRerHIw+6F42Ln90kd5237WD+q1Ou8
 s1XaR4EYttdRI9IQu3Z+QOD3ArHEyOWJxTtKM0GSAFDY3vlexQj7SdoiDOJK5yf1VoOrLnG97ra
 LhjZZQrsf1hb2Fy+U6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 471BF1A0002
X-Stat-Signature: 4ogppcjz1ktdxkcexd3fjd8o53hcupgi
X-HE-Tag: 1783488828-664899
X-HE-Meta: U2FsdGVkX1/qfumFg+Z/cpEsvRYxpMe7erkQdSE9AHjG+3rBs2FWrW36AUXm6kqLMT183xkgKPNfQ+RM8cSteNZwoxyF0B0YiVeTA3Dv+vAblfgx4Y666yumYqTnCaIkUEaD1T/JUhabLD+IdibBAEd/0Bj/CE3eEoWo0GG9vKg4Te+HmSLkkk7pPWr29p/eTt0s8M99RrIKs6ZJHC656xzYgTMmVGDlv8hQzYgotcb87wm/U2rU9Us8kU1DsCo8jKf8gtuPM4jbw4ZZvlFOqWnVqL8O4OKBw11waIcec3ujX3t+QjgD7nqKXvKbxk0yDqR6i9pZkaS/iJCPGor8gkM3CP5nUP3dqUZQVfEgq3RF6kA7CSce7M6IG1ocGykwa7kmVAcNVcpVEOjhI6YXJs59klc2qU/gm6NbXkQTYuAchy6mjflJ92LHs26zCKRCNcNwkJS5cEvPYgC9bYIhGV5BuVoXYnqyNmmU4jicxqUtbJ2BAxs8j4Ug9eLY44vUfL0e7Ra57gHCnPzmVijnCqhth64JM8W7PcpBfC/pIr7GxqKGxQcW8prVL2c7CeXglHNZncUuEOQnSgyBGj5n4eV6cLum8U3Y80kChtSwjyVs2tTQd/DdY2kbx/iJK6Zj6gKLnpBzmj5U5aL53OLq/LThRTRoRra8Xbhb8Ud/H/zNBzN6jVuErAPoQRr3H9o0OuxZCZhl8YNFa6r9EEV3J3qFvPzkk4X0gvfYhDt5dcIo/jnfEInLbEYab8FQfN+3YtSdS+42pN7Y74YYCkYAM2wm+vxNbMPshHYrUliccixxvXiubaVa5ZW+8hICGDaSS3kqY7xj2Nwn2mjld/7pCYTmv+rdR27P/WlQ/tK7YSZw0CDt4aRugYsa6xe66NPcw0ZGXsOj5PaPAI04LMavmD6uPMD0jniKnRhKs+rKywJr/OxEk4dla1gJAa+Fpnn+UZWAgmwtYB3K/jUnD/Z
 c2KLwPj4
 pllOf5FaRNLJ6NtBaZdOU9EU7AkV2mLx7NHEgGOPhJhI+szTvSO4X9+AuKYgxfOVSZSMxHR+JAj4m7tigDh4mHWXJx8OFehh70s7XLRow4utwVLhhE7U8kqNquS/zz+SUyFIPIjcURSJaI67IU1ZKM9FyFuUFx466RXgYdpDiVGLF+Zp35tmhaZALqyQ+V+LBpR85eSeY6pNZ7i1lRFEZ9QnxIc7r4h66oibGKxlxoYyxWH9s4PywaoaGRK1o2QneO1A7zUBpUeCs8PwbIpQsLROIwwgkRO0Ryg7OlLvhRbSf6vQIsGlyHW2GOGuwrPaw849ry69wN4DJhr5cDUzw1s88b3t5kXXaiPoUtf8xrNbfDNRh9sNOSD1Kcmq0ViQMSKhny8rbv/mCfBsbJV6laMMDf9M6iaZY7n8swutvJdRMLgD1z5P+IbKH2sT1qrXAXAP9xuZz9PTOCSuFuyuwm0RgBexMT7iUQsAcubvJAX4ILF+1/+z1MmckWdACzmnT0jLa3vSoRrS0cR2RpDoB1HmKiwsmio8abVJFhv7WZKyjTdU7S9VA5FngQMCddFXoLJB2brpPz96PAIYnlMONufo157i48PqW8vZykrK2revYsXrrqForfHQ0UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into inspection table:
 - jiffies_64

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/time/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 655a8c6cd84d..6cbb054c7c4b 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/meminspect.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -60,6 +61,7 @@
 __visible u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
+MEMINSPECT_SIMPLE_ENTRY(jiffies_64);
 
 /*
  * The timer wheel has LVL_DEPTH array levels. Each level provides an array of

-- 
2.53.0


