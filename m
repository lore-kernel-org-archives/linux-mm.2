Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C043C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD376B00A3; Wed,  8 Jul 2026 01:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383F26B00A5; Wed,  8 Jul 2026 01:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24BA16B00A6; Wed,  8 Jul 2026 01:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D94B66B00A3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:34:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AD35908A7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:34:54 +0000 (UTC)
X-FDA: 84964495308.26.BDDC115
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id C653280004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:34:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=CtwLPwnm;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=J5ZNveZO;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488891;
	b=kKwGGfLzNSq2nSkLGZrD3Eg8glpEdwWkqA4Y+yqEt9EOePYmZSRTr59/eiF/BTBxCr7MlU
	bSpFSIO/3GhIQe2rfwW2DfwJaG7BuHwQfyANZlQaBQuz/fqvmT9/ncxC61FWR61Ju3zx96
	AIySG010e51j7q5ag15l4dKWVwfl/Dk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=CtwLPwnm;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=J5ZNveZO;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GG0TiEFI6S40u81CAA6ELJbYcW+fJPcBWrtzfeGi1/M=;
	b=fCqkb2bWZxM7w0pL0VVbZOCwZIATecKzpfgLdYw1O2iSjwjQIuONV54CnuKVZZ7OCumfu7
	ksdXB1KCjWvxy1Jrw7B92mu6PneDpM73MmGP19qEnJEqQT5c1rempS4PJ+ZD/LKRPs3MZ7
	LNotRbX58/mNqPe7X3Ms4m3wf/4mzo4=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842A4F1572657
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GG0TiEFI6S40u81CAA6ELJbYcW+fJPcBWrtzfeGi1/M=; b=CtwLPwnmIWiCP60L
	tSRsWp19PTCvpGjTRExUl39BzKsi+1lH/6uR4/3M9lId08XsntBqFVLk732lFfZx
	PJvuBKJLGVOglKa3NnUHesiRg9LcFb6InkB9NcYdGjQr3LXiJzSBccXx2chE4mQC
	+B4+ilNPXhbBgZ0jXx8+aGb0zAGPN1UxAGNoknIjQhKClh6K1myUaQZ36mpiFGJX
	03ih5H27p0rFYkktHS+mLwP3ldhelLo0rwl23FhVNzePBBDxAu5GqLxhcv7nzz75
	5JviMCxj2DbFv9kIvNO2Wcb0ycdSOYQn4PspXJkWPKmGwYGgAhkg/GNcgKW4HxMP
	3rSjmA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f99hgshk5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:34:50 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8482b95574dso412150b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488890; x=1784093690; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GG0TiEFI6S40u81CAA6ELJbYcW+fJPcBWrtzfeGi1/M=;
        b=J5ZNveZOG/cdmz/73mOA68jxLNa5ykq8kcdLw8qFO93qJDrkcUC938N7KJ2KCzx2vc
         GJ209xZ4vWybKb6TEnXVsc4pSV2sqsNw0mavhqr0gXdoL+czPshA6GnufAXaC/6+7EQK
         cvK+Sp3Rqt+a1rjUSx9rc1H8EoVYKlPmguBob7vzg2G+Kb9d3UOdEwW2THEb2/rj0J//
         HhbcTQvJOZ7ZWlp1t0hnW0ijSvqVXmn1koCl8CLiTYFMNWzcSPt3NgEL2njmbhUhB/m6
         9IHQoHHiYpYS9yr4B1yosxitKvXPl383QMnXhcF/5FbxCpXaezTUG+hFNXUofY+DvlVt
         s9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488890; x=1784093690;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GG0TiEFI6S40u81CAA6ELJbYcW+fJPcBWrtzfeGi1/M=;
        b=MB8MeOCm5oUnDtx2KYZQmqf0szX8g+zhCgvCLE9sVcHMhS82Gc0Oioa1GWmp9qDzMl
         LpCRcsho4ENRNFsbbI1OVwm8JRCrk7G+y2pKcGp/350qJQIdYFfjy1MGjpAD5+7u4CRk
         oR2pgNR+aeCkwiVk9psYts6w1kzunokN72hMMnRzaSDjtBGpO1Y9LpL/0gizhgH9GssU
         sFkLN3LFNQKu7n3RGUPGPY4QY0PCHQNoHaUbZ3tbCFwsGzjMPyTN5j86ycT/RTcZLy3S
         isDUxItGyjnuwlzhvOqzK1pVlUp8zufR/vfR2TKG6Unh9sc+zDVymvEq7o7miBNDf55f
         +N5w==
X-Forwarded-Encrypted: i=1; AHgh+RqxvQxGQaOwdpcJ+VMIBuSXpHlAbfUZlg7dXXj1KuIp0+jegITO1D1m9lFSefmC3hitDsEH/K+rOQ==@kvack.org
X-Gm-Message-State: AOJu0Yzqnvucm2vTFejLF8Ku7GYJGdc7gRycojalRAbECKjavjbfn9Hc
	Jy+nw5NDHUGs2YNV+5FcYU10j8xobauLnxB2r552SumH2jcd004WsJxHlaQPttnVQk8rpAV9n6c
	HcIJOIJ7eRmZwkYSAW/AHF/gZYU+FmcWfJcIkqB9afdhCrs4/wF6siQ==
X-Gm-Gg: AfdE7cmxM8ipsX90ITZUrILxScJwilHLOdkqwuxhX8NSgolglS04SXbrdavR5tVPfIO
	aSwE1KYdYXBTcO5w4+Gmhrahqy5OUA8eiwY5R+2xkfJRtKS3R5lsnLHkleOtIzMLYiLGOCq6MgV
	57Xj9ImBUaxJ5hIcqI0fjB8slDTPL87fOYT+yafFrW1feQpHFZkT4zePC8ld7YKaw2tG5MWnaUu
	Hwu+F1RnRlw8CLJydv2HSOzPYja0yFy94A5d2Q2UfHtoCHMPfPk7Zu3p8915KuV1N8jDdS5ahiS
	QiFXndnNXCoL9yeKBWRxLF9i4LuAf4aeNmLp4dr7E/yvBbqky18BDBPUMTbWigMmrPDMqkQJsZE
	QOKEaEpjlpvxchpSlACGujGN83vOjgGKucqOCEw==
X-Received: by 2002:a05:6a00:1d87:b0:848:2f71:b65f with SMTP id d2e1a72fcca58-84843000644mr1092049b3a.74.1783488889722;
        Tue, 07 Jul 2026 22:34:49 -0700 (PDT)
X-Received: by 2002:a05:6a00:1d87:b0:848:2f71:b65f with SMTP id d2e1a72fcca58-84843000644mr1091997b3a.74.1783488889150;
        Tue, 07 Jul 2026 22:34:49 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:34:48 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:49 +0530
Subject: [PATCH v3 10/26] mm/show_mem: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-10-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=914;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=Juh0kWVVV9+31+pGUNWBrImKXqVrnwqwm/8iHkGSNZc=;
 b=QUUwmdgFWBgI75+U/LQsmKds191tgbFJHJT05eRFMeyjFTPxg5V8CAPSijLkfNZ7LQtRjumHe
 J5Xw5f3z1e2CW+YpiYhbyE+qRS4qLD2cAWVE6mgZMA9c4AZEcoFxInw
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: lDTz9E2RszgcvltvgAXXF8_w9SM4gINf
X-Authority-Analysis: v=2.4 cv=CviPtH4D c=1 sm=1 tr=0 ts=6a4de17a cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=Ayq6lH46roXo9nsmW_UA:9
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: lDTz9E2RszgcvltvgAXXF8_w9SM4gINf
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX40rW20ssKmWm
 IS5rdKh1vNLwntw7crIUqoK9p3eCfO8/y1V6PMOYhFCURX5/kAhZ4iMjnIUku+ObAGzb82qCHhg
 6M1e5dcnL06uYKL2zf8icbp1dngdTzI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX12NNMHm0Fmvz
 NWXWM3wSXlLPzjCqYcv2Z7pS8Y1CYysAQwsaN8poUFH/a9V1eV5A9Lfxwfg4x13sy2vie9Cd8+f
 67EzCPpJMUzXWDg6OYeKHBJ0RCBbQRse5geaPUVkhwdFbO/uTf1ZU1Jo+c0jznXc8bPoKcm1gMP
 yEGsGI6xwLbO9QB9xncMiaIcy9wYW5t3r3PsESRCpyL8BEx2pdjCK7d23XTAt8MOk/5XONEC6AV
 PPVSJ85tCoCGoSFMvNONRKsYkscJ1MXOY1UcZDSUkkeY3pHYCbj/wkB8EhCToMBBc5Gu2S4HNx/
 rltmaOH+Xa5xfGk687hF0ct5wTdEGxDRAXSs/ACWnc3KAG22Nnq8EaUQM8nzBU4EuLWT/qBd52Y
 RKmg9jvb81HvvPTSuVpn1RvST23O73iprJBhUkgB6ruyrP3EaYFT5UQJXHneWKmUt4nWt+dmqny
 YHxFJXvd2E6ANwslmNQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C653280004
X-Stat-Signature: 3j9f15hgy7kfs7ndcb9uyemjmq8xmwak
X-HE-Tag: 1783488891-394457
X-HE-Meta: U2FsdGVkX1/07cgjp6P1+0R4bTY4eCKSHAZze8vsFwC0/fGlRsAP0JXmvTs1zB5BZzH4y9V7HiceMltsuuj/HJTwPhWtd5scr7mbgcEm994L6QFMwSIJwE/giRmLLBVzdrv0DzGGDDK6uYS2i3lS2EUqFPFhLgI5aOL+6qo4HTmRDgfnsWAQHVvqcaWpSNfAzzqhGfL4PvqyDmlXWarDdHiNYviJdrfKKOsQD17la6lHip0IL736jtu+vme7iCuUmrMOiaxyCWHgV1QlsmNE1KywiO9WU3Ja0g2NuFQTNKeN2uGI2MNPgHw9FZQ3X1t8C6DwHbmjqEwu2xnQTYRdwCtVq2Xjfj9UxfRHTuE0O4XiTGB8kavRh2oeRvaKrrgrFA8Ph5Os2WhCy4jzZoUxSCPck6Ipg3Vdbuz9WlohbZj/mpP0wYLYwhrBhAcfN3DI0syDPd4Pn5u0tXMkUssJpTishzioYUaIMYjt+KyMlUZabE+LckMbegHj4WyZaZtqu2Ss2nhu4vN3miMGlT/T5QGTDqwYKGy+zxjK3RHTEif0Jmu/Y82+JyofqiVmU+ePmfwXl/E/VV/egfn+hjcBNMogqlUQaTwf9bGKgGKvrGeussgyMhLM0RCdI2qZv4Tt3kFy1MB29QlWPsqQfe0g7jpMk2/hkKsUNEYJXTJcXOCpvWLOCEVbmPgyNxdhWF6rV6D4frHor4G/P3NEBvI3fiTAUGoCq2eYaRqkVj8d3jecFJHvYXgOo/1NJaU+/RZjSFfDrGnnMoT+0+a842kJfxgmiegmY9HRZp5iWAGFqNLGlFe8auHN7N09bS/0420SHpd3JjeLmJ0lpCAs0XgFlKWZ5lnDES0UT1wcG5EMyPjE7ovZ45abIdHCRfQfyjn+IBkH/qb4Kjhbt4VnFgf7Bc/bC2o5xJgKOWZsAJ//Uy5n2MwIxmzDjNukg3bTTKP1Q541Pok6qRma4n+SmEu
 bD6FhXQm
 FrwtSq9D+I8i76AoPG8D0K+5JLBbWDJXrX+rMg5phQA3nRalC7+L+YVxxn2NSrC48EKX6knEmj58DrghX9IkMQUGnSI9fDzFdvAvjmjmNIBudRVvuL1MaZxNhHhoorNwc+Fqd1pTydofHRwANPbDc8TIu9vVr9i04QjYMrtUbQP/A+nUEBgvAqz3gfIdL0VK3Hr/lmIj7eubygGu1J6P7EW2hn0acatPKWpb7lGwxXPPHFb2PbE1SpMkymdCczMBCJ+iC6Qx6eL7EyYFffF1XDphzEjRrz4UdXGik28VHRqDyuhwDtCS1oqHynH51s1P76rb9WAtshmP+Druvl6vyhYw/AW5mrNKq8g92CVwAApZenx4W4HmtgfueVXLKOk0JELx0kIMB3SpSpljcDXlz4kAc6C6xzDntXo6XdVCktNoX9aEE3h/7G4nFcozbCD1/QH9eWgTEuqoYN/SGhFvZKJNTFHfKqW83k1NsgYVlIfcZW1V4TXsj/Ij/hYCi+lEfUsoG41qgFAtt4b7D/99GLvAAfhN+3+ZPaA43l0Mro1lheC8MKe6Q9pI1xApwIuJBqf7U+XgCzbBNHXe4ZvcuFhCXjfH4cZnu2ECIRJu21LyWFb7o+v3X/XrQyNi9m/h2lt4+K/4t/U8535wzJDS1G2dnPp9nERY13xRfyZnS25+Xea8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into inspection table:
 - _totalram_pages

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/show_mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index d1288b4c2b64..67ef32f1ebb9 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -14,6 +14,7 @@
 #include <linux/mmzone.h>
 #include <linux/swap.h>
 #include <linux/vmstat.h>
+#include <linux/meminspect.h>
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -21,6 +22,7 @@
 
 atomic_long_t _totalram_pages __read_mostly;
 EXPORT_SYMBOL(_totalram_pages);
+MEMINSPECT_SIMPLE_ENTRY(_totalram_pages);
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 

-- 
2.53.0


