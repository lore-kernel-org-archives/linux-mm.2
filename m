Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91793FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E866B0088; Tue, 10 Mar 2026 16:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15656B008C; Tue, 10 Mar 2026 16:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0E66B0092; Tue, 10 Mar 2026 16:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD2296B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:17:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55F0CB6B50
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:17 +0000 (UTC)
X-FDA: 84531262914.17.C8A9B59
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id C476B80004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="d8M4xU//";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FbGrFWiU;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMbcxvfGnpO2kUkVDeQzzJXRTIyuF4NzJgKQxZFl54w=;
	b=r0qG6pIWJ33JivQ4CJe6w4m5rbv1Ht84a69UTqBNxPuhTNL/vcHEIWWEUBQ6HDnxcna94F
	naG6NwmAZnVMAiUKIQEfCUt4OWA6eikvVNLnAV4ksLwf2yFRJJiNosE6mHebhBiOAieB0/
	f7Ik8Xk3YNxCF5Ks5UnTLI3oeEbMSyg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="d8M4xU//";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FbGrFWiU;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173834; a=rsa-sha256;
	cv=none;
	b=Sv/6a2oziP/8ZRY5uz2xjcRXDDvxdqCn9d62DG5G6A61eUMbtVnZI7qzUbDxeDOGm14mGU
	BqEQu9awGQRkMs4cJ3Wn1r1xKyZAk8IEYZWngJTGo3kR7pHMMV2ceQDDheFC3+JvocAPXW
	HDjZk+n01+ED+a2tBQYo4oc8GR2j8ys=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AInb3v3417119
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JMbcxvfGnpO2kUkVDeQzzJXRTIyuF4NzJgKQxZFl54w=; b=d8M4xU//pa3iRcZL
	9k2gcobpvQi/oLgFMti2zHaQKpYMq7WC5KHszs5r/5XIooXIqOsUpJ15qyViXx1c
	PU3UeFWqpJLWXPclVANvs+AS3eFmEahvLPYpBj0/SREzgXgbUm3Mbcp6zP+/NVh6
	V4y9Yf9xhbOzBsjeNr6u0YfPCG3L5epl0SWPeGoGNBQ1XzKSx3inWfS9kKkrNFGo
	oCllBnobYFaqkD58GCFm6fGVgSQM6qLbiCMxb7QKOshg+GjEK+KVIZo+FOiWkdMt
	rs3SKjNQTu/GW/6hV4fMJRq8kcmfqC+iK5XkF2oudCzMZrbWZxvmbhTm8pQBFfBw
	BnZHQg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctja2a3k7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:13 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-829a9d3073bso1642996b3a.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173833; x=1773778633; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JMbcxvfGnpO2kUkVDeQzzJXRTIyuF4NzJgKQxZFl54w=;
        b=FbGrFWiUFxaJPZVVq71lUeZm3azL7O/ChubXl6FROggQ0LchRKzIz4j0ZQtU99yhSR
         +kJKBqflFyEpnsAaXQgSRnfGz62HwE9hOPyVHSZPsPLGdQhJ2C7El3BJc59IL2wUgpD4
         ukL/Qsk4t3k2Rm9xPQdbkpUsuN7xej1PMJP0zDfIVpiuF+AqOzKIJQ9+8PIZzb4pM7Qy
         eTHCsQyO+H3wNreA74fFyrxnSN63H8KrFVPnpScCUijEIFtg+2StnxmPjJ8ULTGhZph2
         kDjRAO98EMTmXLB1xxQ4zm5Uf3zEL3XlYwzH/d9QBOErqVDLFXmxbNvAg5BmzXbub439
         uUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173833; x=1773778633;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JMbcxvfGnpO2kUkVDeQzzJXRTIyuF4NzJgKQxZFl54w=;
        b=DHpSzhc2ogg8qRgSr1Wnj0SDRJBf8qNsDuyAHmkCz3ZIwqEN2nD74OSJuX2Rz1s9yn
         Vz3An9IssRnC/fupLS0mGH2fu9/FJy0LDahyUwCNXHsK8QC0sWSA/QVlbj1EqFvKD0wX
         eoDkP0ZP8IdFd7aj87Qo8ACiOnvUFCo+Gw43TowLblgwJ3sxJx6QVNOQ7DqjxsH/A0DY
         0nwkydkUvDLmk3xyMr4TSNhnSVICwodmlqgBP8zxFqEzyIpblihrQorXnbXSnGY/3rhh
         05m9do3IsKaKxVVJE5w1RCIR3kBounx2eV8Tm5tHc7tXss7kp0wzJ4FmKwJLlwTh5xGF
         VtBg==
X-Forwarded-Encrypted: i=1; AJvYcCXIp2MBopVAhkkVmnHzklKM1k026ghlF/d+6JZLWQBo4IIWoX8pAZzqO3yk4EG88JXJszuC2N+UUA==@kvack.org
X-Gm-Message-State: AOJu0YzEv5nQ2vrnue0Sz4AuIUO7AXE4FKcsgTmti59dqz/XT/ZOhm8H
	5U0ZFlIoAKc9OOg9xteH7+R/DhIzlPY8dNjwkt6ovIC5x+ypYJHzFMAYOKG9tGxNmvt8ATzcZZK
	iH/vafDt6ngruLUDJSe1frDzGGTLsOp19tYK7tdxTaufvbpPnNDsVoQ==
X-Gm-Gg: ATEYQzyJq0axHJjfKNAzxzMYSnS+6PNCWj1l3D1+CHcpk6HPte5WQ7DL3igDuepY/FL
	KELYrbyI/aeQ74V4ogk3Zp+dAcmVY/GMKwG+2/mW3t2naPzDtiPz8LHQuW2Mu0fwtm0oQDsbPr9
	P03yHJUalg4Ux0KrtKamvM04afoCglSAhWLMEfWyYgGXUPNlDHQ8EabZNqdXfazSA/qVJXMuhtn
	9VvBr+PeSjwJyxT2trWSvdBVAHVRiVBPPweTPl7xwfcGspGHfY7I6xX2x/bUyPtAvsNSSN95MG9
	2CdKsR3zVlKk6xDjvoRNDV3NMQHxrj3XwjZ3O65gNjQYVaWZ2InMMSKdDGEFzpdJVdhfxcPlFY2
	+XSDtLJKfEa67uvY22Y1cTsJMn3ssuGFwcozvGFoZd4G67eJb
X-Received: by 2002:a05:6a00:1582:b0:81f:b97:14a with SMTP id d2e1a72fcca58-829f70d574cmr110712b3a.61.1773173832802;
        Tue, 10 Mar 2026 13:17:12 -0700 (PDT)
X-Received: by 2002:a05:6a00:1582:b0:81f:b97:14a with SMTP id d2e1a72fcca58-829f70d574cmr110660b3a.61.1773173832144;
        Tue, 10 Mar 2026 13:17:12 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:17:11 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:48 +0530
Subject: [PATCH v2 04/25] cpu: Annotate static information into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-4-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1623;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=JIIb0fgbimtcknN5I2sV/aALlXS8ugEHIxtl7tKUkUg=;
 b=yXlU0vbeIL+rP/TVk5DDTuofv1NrCJH8YoUDw3a/Y/cDnFlVa7jur1W2IPvmwrwhu/aujvbGx
 uIv7w8SUm9zBOJWsYqXfqlc9L31mJK/006ep+rZj2cSkRngOtM577Hg
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=c9WmgB9l c=1 sm=1 tr=0 ts=69b07c49 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=3A8An4GuCW952TOlvi4A:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: xqHU60tNNeTkk47Q_UQZv9DurJUK-1U8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NiBTYWx0ZWRfX+2lDYg8VH5/x
 bQFdvV3BGzY1pZT4JzpRyyF6ssFYQqVWmoBHTdVOicklFxWL5G4ow2CFz2t3Sf5w8DG3RDNfYGz
 r7doRirLVEz6Zq54r2x505/a9qoWiKartUlnrxb3/0e9ktagNuTldopiMOnmwo4mXY01V8wkfig
 w7Rvqto1RWLrWxpYTlQhmXS1KpXV+QMwMM8HNmvDOYmU7YNbDzF71YXTgZL1OzAl4k41qpL70Np
 7y1HGbl8Dxr3qGaQYCeLSXDoeBa5brYDXmPdyBzCdp8kkoVHX1m3YXYNPTDExALg++Gi9YOYwt6
 iZcN/0tc+mm7zgJha3/+J58GFIwVVnJxw0xDdXHMR590kxFiacrucxN6jy+w4V2utueQexNEFyt
 mzZx65YrmCmC7Sp9VOMc68rm6Yaev8MRSqTw2+XJcDeX2VXH9s1oxBRbBKoeH5V9ff9UBy8/3B1
 5QmQUG1jtFWNZKnPbbQ==
X-Proofpoint-GUID: xqHU60tNNeTkk47Q_UQZv9DurJUK-1U8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100176
X-Rspamd-Queue-Id: C476B80004
X-Stat-Signature: njwz9i3quf57rdqrhj9hsrtg47fs3im5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773173834-799626
X-HE-Meta: U2FsdGVkX189CQ+FYF3ZpVbTmZG8ruWtIGrowbopLCZ4e8dX4X3/TtBzHklFeoTXa//CvcQw8h+8PuAHddBm99DQPL90POf8fFl7TIKYIlQ4y2/9OfAypSf4X2TxgguvVHdTdFXfCydTKkR2jxlbLLPObHKKxB3NxCUl+2U4eRqEDE0XxmPeh8MWBlWXORMBrBjWBCfsyCg6gJTmT9SPkATp5vepd/AY0FmcMUUoJ6WFAv68wO0vw/QbXoLhC9oN1qygd97rAjxSta6NAkdadHJxymU4jPJJchl9CpwQu9w4pBCsf/0s79GC2WB4ya23OTiM+yo+zYDEF419+KErGGbpJhMT6zpIMoTpMdBtc/wDibCcfWq7DoTYqLkGx2Jg2FVYc8+DNhnIx3opw87TD+bqdxg7dhyLp8vv/sTYoxGw57CqDkOfVr5BvoJY3Hz0wjIqaawZ8t4lWroIt3qkP/hmg4HYy9TO29zKRlDxhHpALjqlSiHekqrRypsTPoPFVIlWrBxyXdPorR2zh706JqkD5EnuH0ffjIhvuhi1jMXeG5FRcpvzIs0UwqrPkTzcXVrQaufMOIerkz4iCGjvIn5pxDqtjQUL0DIjVjjJEuAAgYtKU6B5h9TpAkdTbvPjEGSBRPdHnED643CIjhVgrpTXNKZXnpufdt+Xe8kjusQeis/CFcRdJE1HeWsNRtleOh4g9/UWrE7EOuQZeMJ8n886Yg5dP4mJjoMoaLun3O0kIxoHIOTI5/XTRa0yDs2Gpd8gLguS533ALGi2W248pqZhi57ZVHA904Jw3+S/H/SoNIyv5o1AGPOBwPpGwTDlxuQ54yh4yv2UrB+wpd5a7BDHE/ZutKofaZcn2F1aMRaI0O8pIRHK40kGyAqFhMAddGQF7A18LtlnHaEZaopowQ0qH8wTQr/aOPolY43TOSSRR+Y5bkgElq1IOlm/A515VuYCYqHQ1g812xJntrZ
 6SC4xeoC
 SScIOCyd1Qrq6g6lDQ1+WfA+kNKXASGDsBvhznLzyQFMe2wWu+MhrYw6nxqG5CrsQM2rZBzuQxjTLxsfW+s56AsBn9d2JWeZwsfqBSBcolPgFsyCIQR87Q1fJ2shdKpt6Uv8rQ/4pScQOv0jWvcX+ihOICnphw0HMjjf1NoN9DdKF45zRPLoJqD+x/Ykf0/1W8BSU1izUylzW+7wL1iCaHNgWpDSTFqWAeJcPgLheWcvULtoiRPG14Sso2DzFOG0Hv38EiEtFy89/WLbgC8zZ5QDpqaZUtAw6qzrutJPUn4UyzAtk63FA/yodBR+zAkztVft+lf4Bsjum7GMtHXFkOJ7Bg1vQUbtmyhXbi4hoYBUG4VDOwSr39k+ZkA35pZRxt6ZsapbjY2foFtZK49ytwrt6m6I7GBkdyJG5RTYIG7u/i+WyZ4Hgd6T6Pij5Yex1V5TjpR5KB5M6jyXvg92a/9rD5fYI1SSsJd4aGvgLxPR3Iffs63BxPGvc0tKx7nWnWpnZusp2OMuDHlSiY7SsRgN1eeqQn2L8tsiL74yDMhJRzgCPOhOBiqV1ScvjpFaI7XkoF383OW0A46iRIwoUbzGt8VrFJ4D4DvDeFNLrFDqcoPYUk6WdG/2d4vlblR50kq2LLF8FnGQOPzlmh0EDd5gU3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into memory inspection table:
 - __cpu_present_mask
 - __cpu_online_mask
 - __cpu_possible_mask
 - __cpu_active_mask

Information on these annotated variables is stored in a dedicated
meminspect section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/cpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index bc4f7a9ba64e..25b0fffbda83 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -37,6 +37,7 @@
 #include <linux/random.h>
 #include <linux/cc_platform.h>
 #include <linux/parser.h>
+#include <linux/meminspect.h>
 
 #include <trace/events/power.h>
 #define CREATE_TRACE_POINTS
@@ -3087,19 +3088,23 @@ struct cpumask __cpu_possible_mask __ro_after_init;
 unsigned int __num_possible_cpus __ro_after_init;
 #endif
 EXPORT_SYMBOL(__cpu_possible_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_possible_mask);
 EXPORT_SYMBOL(__num_possible_cpus);
 
 struct cpumask __cpu_online_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_online_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_online_mask);
 
 struct cpumask __cpu_enabled_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_enabled_mask);
 
 struct cpumask __cpu_present_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_present_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_present_mask);
 
 struct cpumask __cpu_active_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_active_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_active_mask);
 
 struct cpumask __cpu_dying_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_dying_mask);

-- 
2.50.1


