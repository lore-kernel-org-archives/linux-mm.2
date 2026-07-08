Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C997AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F9A6B00AC; Wed,  8 Jul 2026 01:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B285E6B00AD; Wed,  8 Jul 2026 01:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF146B00AE; Wed,  8 Jul 2026 01:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75BA16B00AC
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:35:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 047B91C3C9E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:35:57 +0000 (UTC)
X-FDA: 84964497996.07.CB6B038
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7524D140002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:35:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=iyVGMjHS;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Tqj1Z83Z;
	spf=pass (imf23.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488955;
	b=c364aysvHARPwCzKa3QY8ai4lT96CSHrjwiS5Gxg0EqJYTdOzzbgJym9b3fT8/8mAcHKTB
	PELHSq3TxqUKmwPa0qNgQLc56tMKUXoyLqZYROzEi1p4j+ttCMlST7ZCM1yb2peh3D92wt
	uhGY+jStuIsWk8E+NxXDPnetKnkAG1M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=iyVGMjHS;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Tqj1Z83Z;
	spf=pass (imf23.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAshyy6/VO0qiyWiPgZ2rAgo5RvZA1Z9f52v0WVoR68=;
	b=4QzTfGo6Ml0HVx/BJ5zhz7eXhcvMyk6SCsfRT0TyuQ3g++1ZvbVVgmoinQNxOYfrTG1p3N
	MnUdyyjj62nFwUZt655zWmzYAXAizrws+rmEOyuvjX0m9j5iFyMWpD0rpa0xJYe7iCT+Kj
	O+nq9do6uKK/rJRRKAhgK9yomtKNYmU=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668429Ig1656437
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:35:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xAshyy6/VO0qiyWiPgZ2rAgo5RvZA1Z9f52v0WVoR68=; b=iyVGMjHSYXLMOvvb
	whTK6oJiXUtt4IV+/SzT1wIWF1tRxXGFzPJB5KDz0Fe8VB+7px3ddcHqPJp94fgx
	Ze5L7Vr5soKn+zKznGYkt98thcz+2A1Gq2WZBO25klO57cRwKc6RPyi5zY8PkyES
	pvG++Irv6hL5nzc3s4OWjhuzUexAuPSgLt8ypxUtXHlbe1ZpsPfnrdkS73qp9xNl
	3T3NFIzF7q2wemmc/4H9IA1i3tN2GPs0fXWn+/ftR+t9FeInphgSkGQnLHsM9sVg
	+xYp4XB3BkS/hYwyLcQxUDw4MIeT1AAxE01wXzb2Gig4tlJhnHv995tiIJoogDk2
	ngKXnw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9cssrtw0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:35:54 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8479cc04d8fso632609b3a.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488954; x=1784093754; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xAshyy6/VO0qiyWiPgZ2rAgo5RvZA1Z9f52v0WVoR68=;
        b=Tqj1Z83ZzArhFcrAolsfOq35YrsZ/mcSNQbB3HOXKDUA4yJm2Hv/L+V5j3d0l+nycJ
         ouQkvNo0aBxEHMWa/sXMHtzGbWK0EIDeTxz8aLSIe5EW8w3TwI4STzOmn8ayLKevkIIB
         A47xi74xKCzE9Bf9MJJxJesAkI/jwq+ChwXkFBzYa53wgPuNaDDHri5hJuMS0re4QaVE
         5klJ91Q85JOjQ3gIN3d0FC9N9JjL9tJAeIVF3+d/SB3oyKs9oTbz+mzWHmeSi8H4L/41
         uGM/RWErzSFmgJ1+AsiqkNGXW6zEXeCiZuqas9pKGC0I/vK1K4J2F7Bbh+UzwBBLqNN8
         lpOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488954; x=1784093754;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xAshyy6/VO0qiyWiPgZ2rAgo5RvZA1Z9f52v0WVoR68=;
        b=gthGEp7pBsaQxA/f4U1EY0FOju3BRRUHI5miN2iSf0hBjr6MLCCOs3kIZl21JRKq13
         0fm6NM1Pt9+oDX2lYXJPQtLisQidOEgC6jOiWhyu/PB70UNZCHXDQI/pG1Fckv9LPaeS
         sd55vt+R9/nNhHfwzUUR7RQj3+8+wbpDnEWCkQ7PKM7cN6GpqUUTNNQ5U1NhG6S2V+5C
         WLL3Mzm78cOSFk6rl4iWWc9QOaoYLMTTjUEpDeWUfkbKTwjqa9O6SqkY324vuLaV1pPR
         IC0VG1ie+hmyeFv8acouW2jh3kKRB8m6NByZ7NJHKFcI1Hy1K04YbDY0KEnL3RhwNHgs
         gtyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr2R+rT9WEaugUJiZJLfYPTgj4IGIRTzUWojRXQRjG/MLhdLlYPktQP3qGrwdywVJq43ukOmP1zgg==@kvack.org
X-Gm-Message-State: AOJu0YwkhCIk+Uiza+HvSXlYVHWmVJgZmFrknAZ4MEK1TM4hBvSlq6DW
	uTSvhuP6Va2hF6lo2kPmd/IEPm/Rf/p3Cy01VnyLWV/US+kYDLcRArUSx1BGZGGToON+UqFx+5s
	uQq/jRA4pTW17C8bZDJjvqIvWzNpI64PQYcnhkAGP0fPuDbrqPs3pyg==
X-Gm-Gg: AfdE7cl8WRUGjNxI67YumrEA5QgbtLp1CTTWJTnakzj6ax4VyUp7s7icuecZr5WOPfg
	qCflEnXpJhfduJrbXJ5EAlE2KScmHNUFLt45P7Un235iFgqr1ObMHSBAX7p/aKWbE55eDjbtVWC
	WH4itS/jZvGYU8q4a9cmWokoeiKqta+N3aTxkrrDdZJPvDZcHckmd4E19LdhPNjy/jMJ0F1CuiQ
	LnMfbDGxqMYuTMDkP6/fifClnZ57F8PySzQtFuAOamkb1BbzTY4CEzfexRffCiPQ9U5fRzIpd0r
	B2fq/054GlW6sj+Idoj/ZxVwFbVQSm0cvQlZDxxqNDwnS+/nGWKQahDBcauahw65omdKFZ4ZomC
	rmF4tt/Ho9zbinCI7OIj5+Dur+qijXEEldvbEAQ==
X-Received: by 2002:a05:6a00:12cf:b0:848:2f84:f431 with SMTP id d2e1a72fcca58-848432cc7a0mr1101704b3a.74.1783488953428;
        Tue, 07 Jul 2026 22:35:53 -0700 (PDT)
X-Received: by 2002:a05:6a00:12cf:b0:848:2f84:f431 with SMTP id d2e1a72fcca58-848432cc7a0mr1101621b3a.74.1783488952811;
        Tue, 07 Jul 2026 22:35:52 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:35:52 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:53 +0530
Subject: [PATCH v3 14/26] mm/init-mm: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-14-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1627;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=C66R4z8t2Qna/gYEl08YE1zQ0IYA/DB7tbhATdDv314=;
 b=a4ZKz7sKq0X3Xk4djKf4AkkMOFWqa+Gt3qunjb5YpftQ8eDqQGmZHBmWWdz2ObrXjPZiVPIj7
 /TQu22VS0TvAfSBd7UB5LIi8aMhGbP2gVYcpIP8hELXfmPA5AwjOiwA
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=EtziaycA c=1 sm=1 tr=0 ts=6a4de1ba cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=HJIP93yTpLwjP442z3MA:9
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX85dHux/2mXfA
 PVRQpqJCChPyW0zQFAbTgNVSLaWzIUHP1uTjNO473vLmtA0gGwordJF6amz1wCJFiMukEYta5Pz
 LglZI+L0YI5dtvPe+fWV4ThqXDCyGI7E3fcWD6KqfBzWSZs3O/3NJ674A+/meAmHa9a11nCKKpw
 sv4/eKQaAd04hz/QawVZlWII93tXl0kVwAvDCgepE4i3sFeMqqGfBvDvS8JOl+mbDhgviOvhGwX
 /jo3q708kEy+TBaRU58PkASBasgpQySlZz6uZs5k/xOUMRYhDpiAhLvfBRK/u/Angk7dEbUpGd8
 +myzFPGVdrQCDUi/aVwZ5i0EbGtGojsPUTyVd5Q1tdm8Dlp9scq/BgBZILaCONQrZwuwfJmNtE4
 NhKYWqatO6Yl/GfsqCF90e0bW2TRz4VNQXgUgJcVXbQXDp0Cz46sF3hmRT1ee0e7OngPg4Kj8BI
 Ledm6SdgPTDNc0b9kVA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX/us2HWNYxCX7
 TQ9nm9uMuufFX9KwkxmbzGgsQUoFIgf+5PK45IrQTEhHLI4vCwAkXqFVMirErStyRzs63NNXl78
 C5IlWo/YENDJercLITyesdKkQ1ciqZw=
X-Proofpoint-GUID: EPP80s-M-86QBQHCwCcYgRW58DPr0BaE
X-Proofpoint-ORIG-GUID: EPP80s-M-86QBQHCwCcYgRW58DPr0BaE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7524D140002
X-Stat-Signature: nchy1uex4kxyncdd61fgb9emd4dweth6
X-HE-Tag: 1783488955-482460
X-HE-Meta: U2FsdGVkX1/DBcH1vbGG5qmj3KDcqsv7UmGaFR4/lJLMswHCVCSQCW3PWjtPBvq+NvVyII+t3n5GxLhWXcDBQ9kFHbsr/AQ1BD/t98wbB5I4xPnk2QyhN/0MHvT+pi/gqlyG+PSPxHp1AFD0AEnh411INw+vsI6KW+dn+hab5knV3sUlSV+CGDyLePZKFy4n7PhmCydTMMFDjY8nOm5xAMvSrQoxLtHNyDS/s+r7Ypq+b7r/fcJg6juO8iBXizFlVoqNFkOoRdDF4f7dQwK6Ib7eODAyTIOzNGIEHQnU/QD1+nbh/qRC21aNfKEKyt8OjAday0Eq2vXBOwyFZtoqnvhTLSLWkS750FLEgDNYF/ap/RWfkM8fNazCGOgmpmOf8cdNQbZYAp0VXRCw2Wwtnig8c+cr9XpPo2sLaa5pyRsvnNv0waNAvoPhZp8ELu6RJavBRGIS0IT/Mum7DTCMQv5xQnHp/Yr2dogpvBBOT81kIruRBQfo+CFIqIsjkGthu8T7RCTOm6PN3SeJ/7vG8FOvxr2hi1H95PPTrqZMFyZarmQ+ydN5+8HW7jPTNUam/Vq3FicJybkZKIrJe4n/PCPzmNH4WcOyVItVihlbfXgZlwq/aFVhQ+bwK/BfTc7iR4s36e2oKBTBqLv5Z/qXO7xPiOFlY3lvcMBakUNUaAYSemZckBKzEN4s+Zuz7iomd2pAZVZkz1lRWl5OGmMGn0Sp281abGC1mPJe1NpKPRBrbvbqYFs/BJ6+KDSp9fSR7ibNWSRWbCje2jnzLJwg2T8BxZbnFSIZmgYjVmjvQI6pmPUzW5IHx5fPs7t3Tchbp9x8R857UetGB8X047smvO+V9zCcw5biXnPCRNi5kp1QPpAYEe6JGA+UDEGfwDqMj/iga6Mi1xMob6CnRErS66ifSRwPm6bbtKWamB2eokHF8AV2RVtE/QZlT0+ev/NEckdB5OfjjC+hn4VsTtA
 WNnSXjzD
 WYC/xN0A3D5T1xWXq/6seFlTWAIfvJBRJQKhW2A/mc4Ao5/SRaPCRlLTbOixC2+yu5ulqKwr8Q8WeDCy44wvzBHB9Cx2MR9lL87eCmugobJGJ0YuBhICGbMHfrEhI6kdZiQUSAhe2spgghdMvrFqq7wJ+qjPStP8S9k8Ks9zi6ThVGsh11bJXVQmRhBDHVIm3mY+gSTTCuzDmBLQNXdD+FwSD1S6mjN49HLe6o3ddQWam56uzLZ/I2O5Zqh9TjJNHKAv0SvKrFV2Yhza1O5qjr2LFLzQjOpCT6fOMQA43ijOB9aKrbinTeRSOar1ngFzGvRHFGJSoEHCjE1d/tqnv0a1w9JT3m3pWiMZRp8IG80KDIHWPjdNaBVwFclPsWZy9eEyfQPNTctI952VnDCeJggVI6gVqovZj9etPxvHcz/7AXfC1QiGNEv5ZrpemAdvZV11gn1f4dHspPvdPXmABdl9BGdOHP7pHT22rKTZ0FnRdyV83pIxGVAQ85RPcZtgPl4dDjSQ1nG7Vp1plCUYmX76hPebZy8iuOkR0KpkZQkMjjchtNUE2hZKQgFgS56cj9nSuKNB55Ssxe4hmfjl6ePiXCVrVG7R3tuXKZifKj7svWSYPjJuh4QF85A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into inspection table:
 - init_mm
 - swapper_pg_dir
 - _sinittext
 - _einittext
 - _end
 - _text
 - _stext
 - _etext

Information on these variables is stored into dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/init-mm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/init-mm.c b/mm/init-mm.c
index 3e792aad7626..cf53058410b1 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -7,6 +7,8 @@
 #include <linux/cpumask.h>
 #include <linux/mman.h>
 #include <linux/pgtable.h>
+#include <linux/meminspect.h>
+#include <asm/sections.h>
 
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
@@ -19,6 +21,13 @@
 
 const struct vm_operations_struct vma_dummy_vm_ops;
 
+MEMINSPECT_AREA_ENTRY(_sinittext, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_einittext, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_end, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_text, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_stext, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_etext, sizeof(void *));
+
 /*
  * For dynamically allocated mm_structs, there is a dynamically sized cpumask
  * at the end of the structure, the size of which depends on the maximum CPU
@@ -50,6 +59,9 @@ struct mm_struct init_mm = {
 	INIT_MM_CONTEXT(init_mm)
 };
 
+MEMINSPECT_SIMPLE_ENTRY(init_mm);
+MEMINSPECT_AREA_ENTRY(swapper_pg_dir, sizeof(void *));
+
 void setup_initial_init_mm(void *start_code, void *end_code,
 			   void *end_data, void *brk)
 {

-- 
2.53.0


