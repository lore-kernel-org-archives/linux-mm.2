Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEC2FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47A266B009D; Tue, 10 Mar 2026 16:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444736B009F; Tue, 10 Mar 2026 16:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305D76B00A0; Tue, 10 Mar 2026 16:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0E36B009D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:18:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 732828AB41
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:03 +0000 (UTC)
X-FDA: 84531264846.12.C345901
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id E70B0C000E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ltPrFDPp;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=f0tn4dXP;
	spf=pass (imf10.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfUV+gBEdHPcOo4V9gaPme4dCYACtyl7032fIDcKRTA=;
	b=PqLrsnsCSiBA2H/eeWvzEG5CD/yLTUMKMTF2n2NNAk0gJudJUUzCqkxQDelp9wHtzmGUzR
	o47vT3lCvTM0U/5Qz7u2fCJa+kZ1wLKDxV1YpgKneN6Zw4tUkRi80Aj0bNWYh/wxiJcIog
	TR+A1uqyJh3I9a0mZCXqj+F0A66rTX4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ltPrFDPp;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=f0tn4dXP;
	spf=pass (imf10.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173881; a=rsa-sha256;
	cv=none;
	b=HdynWYFJvPpiYFGDm7LscQky24l2kmLiTr08v7CiiGNwLUzbKmVw/ocGtmAEKKzHTmY4dT
	Q/Is0AlynBh2K09G5lwO5xbvNvvDQz6cOi6xMtKzIHZZL/oZegnHuW1WTi0b/7RMVUmlXD
	ZcyLTOPgm7yPApY7tigdXzeNSizkTtw=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AHd1O32179858
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bfUV+gBEdHPcOo4V9gaPme4dCYACtyl7032fIDcKRTA=; b=ltPrFDPpBsvwp4po
	ad90malbUSCAVb1F77szLolF5CGbif8xsLCMrHPQ395uceqWccxjjS731AmtNcZA
	s35yyO+XxfA+/9ksW1XEG1SZEp8/x90VJsvDurZvg0w5K35oxTWTuBitgb0rQlxN
	jm815/+ebhvK6V/FnI7Hl3iAjyrgOcIyWjGA5OndLr7U1uoDwcObVsxWHkBy49pe
	ijrlD7wNCQLDh9J4i+76LgLqSYK1DiABrcBtbo2D2HkuTUnNd6M+qALdxFx5fz4+
	KU/YVzFef4M2F1sc+1Fuas+IPIKF6mtUPu53zirHUT3TSA+QFU8S0VT5isIfdIXz
	dralag==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctqvsrjrx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:59 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8298150caddso4552722b3a.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173879; x=1773778679; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bfUV+gBEdHPcOo4V9gaPme4dCYACtyl7032fIDcKRTA=;
        b=f0tn4dXP31IwNkWeneLnm+Z+YutuHIpfeQNaIRZ/pP4/mau9gRJIjDBoXag59MGq+Y
         VYwtjP5xZPZw0EXcCZLKZ0ek8uIcTYgIoyGbIg1vkXZlMyaRJaxPieIJGwUHVsL0Q/07
         2/Ch2poIooyM2fIuNfRpH7CRmQY4NNhTVjmYPKPvioT/25bqQ0ajx6cmNLm6UtuumJJr
         9b2tFFpaKyCsc09L04qdL6fFov4lI1H5grlqqDjhiyasN2Ykt69w+ihp6DpNdhylWn5O
         PGzSjOl+lS6cDEMRnYMojjR7ZZJTheopPakwAE81KUHLYjBTASZAL/X9P64hQAl6seYj
         rNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173879; x=1773778679;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bfUV+gBEdHPcOo4V9gaPme4dCYACtyl7032fIDcKRTA=;
        b=E3Du09Fx0iHsH4XLyr5uVcT0vEFnpZNj8hO8OqDdAiu/YojXNgUjHPuJpH7Oa9Kdme
         OClU8Gs6USIUhSYF6ntEdXcIbwSBr2/v+Ws4SHJVieIJ4ifYdZ3LDNyPcRo2+DfIMIeT
         3c4NmW3lJEcp4PR7+GX4lbYuF4RHj+ixeJymu/75jfQ0io+HP+/C04KeJj5MTbKK8FWG
         0JCW+dWsI6k8+vV928imRtJ1ESdTyg/RQ5SOJcD2M2DvvjKT4wvyWCiddWPsu7GMVOUn
         uGQqj4ZsbxhViZVHNPCi4LHpHPaQ9o+fOGo4SBEqdv8WG43sl/gzY8qac6aXsCd7PR34
         Smrw==
X-Forwarded-Encrypted: i=1; AJvYcCWMulmfvj1J7R9MQMsLM8jJMyfD3bgVHvoqBP9iRIHv0tfZbnZjHRq4PdzKZ+jD007FVt1vdLMgyg==@kvack.org
X-Gm-Message-State: AOJu0YwaRsf+/8uBA5rDzU0/wlAEp1Rw+QWAWQnuhQrWpUlcJs+926yc
	6/BbYaCUhhRcXeysg25hXP163UwWVnlJw/V+83lpD/FQHTfsUUxGW+ePRtRflPnX11T+aHnkE6t
	ImjhAJeppzGavSmXBr3EyNPmz/M2qgseEwsbC7RySGHZojbTDmbBDQQ==
X-Gm-Gg: ATEYQzxgs0ahg5kxoj/CQV9giYJbP9PJIC2VRiH5Vrz65Qzw/7NY+NChzns+Lw8x7SL
	CwGym1twyRRRAGs0xpriLf3fnU2HwiiiLzBMMBT6eZJRl58evo0jU2TOtduBQPGODc7nLCk/3T7
	1p+ZbjvGO91uvbfezA/ucfjlSDqhbYUh47tzIwJAC1kir9uZeh7hEkSsNj8tiW/HYOxeB1s4Him
	mwMLdOar/qkFnXF27r8uQN6Dvr0ofReqN6EEYIwmUzJlyOQUVtSblLJY57/OQSZjutwoX+JgSKy
	qbfRwNpkGpCjr+/ZG47hVz564nA1K6Ct/2zv9nSGdHyarN3rAzNEgI5JldJoBSrMgUjkgSXeG+k
	oxukJsPqyL6D6L+n8DbnV3zUwCnW4Opiv5N4Ee65pFywpRJAx
X-Received: by 2002:a05:6a00:4503:b0:824:9451:c1f5 with SMTP id d2e1a72fcca58-829f71970a8mr146625b3a.58.1773173878759;
        Tue, 10 Mar 2026 13:17:58 -0700 (PDT)
X-Received: by 2002:a05:6a00:4503:b0:824:9451:c1f5 with SMTP id d2e1a72fcca58-829f71970a8mr146573b3a.58.1773173878123;
        Tue, 10 Mar 2026 13:17:58 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:17:57 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:51 +0530
Subject: [PATCH v2 07/25] kernel/fork: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-7-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=954;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=tIrpoWgx8SQ0AJN4uKOz8Q5k4KFIipptt9Oac2pyJ/g=;
 b=u81ZD0X0X0SI+khpkrPGcBBxMXVinSVgpb28+k/sEaIN8k2yywYYFp73LfCO2jT2lgtl+DXbZ
 rxxNXkcBZHpBttjt41FiCwlNIOvPQKsMtMaqk/XFlaQv/SJP7SYKiPJ
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX3hFWKqzW12jc
 BwVbGuiCyLgiKSfnPlghV3I+2+LrLDhgw1aBf2Lc72nq7yObPx2eBx9LHQI102kRuU8vGAVrHN8
 c7H/QmMSmP/C0wgIdoF7Sc7B+2+ifTXZTzJtE/uNoptNpOc4D7ADNUhtZAVnt6Cfyk7OZ4u8dl8
 kTHHDZo4+h3JkYFjtCIbpKF0FaFJHgw77MynrSV2z8s9fHwNhffCqhFBRbN5DJdrWnSjeESID+2
 ++SqoTuK7NLxMg3IjY0LN+UGKWws3hk5u6dxggL6LxP6NWSOemLWyQvgt1PFqN2uKVb0CLkqpPZ
 0ZmTYLLymc+4mvsuOI+29wqYP1+Yh1BTuYO9TN2ccu4juCbMU3fl4q25f/jQiTFma2WzgO3OsIh
 mbdfnSJg/Bznyqye03spvm/wrtRPN8aZEJQI5WAOwH5A3bcoPY8+KGBKkgL5UzLV+7yi1zr+M4D
 jYZdJbace6AS3t8yAqA==
X-Proofpoint-ORIG-GUID: lqay_Jhit3XzMflsu8IwhJjxrU1yYHcb
X-Authority-Analysis: v=2.4 cv=Lo2fC3dc c=1 sm=1 tr=0 ts=69b07c78 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=A5cnksRAjNInYuj8VG4A:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: lqay_Jhit3XzMflsu8IwhJjxrU1yYHcb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspamd-Queue-Id: E70B0C000E
X-Stat-Signature: 194sookhqpn1ne4eog34coijgs5mt9de
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773173880-35662
X-HE-Meta: U2FsdGVkX199CMLkRHuKuFJBMZeabh+zqsGB15F2X+K7D6dHSeQk4ganITw0UKGRRSVi5EvWDR/XdVgtOiNj0c0IF9uihFsP/lLOJmNbdJXH2ooSFzlB3tbWMzR7PqgBDK5iLDfKcJt/u1SWaDCALCHH57xdMGNerSOjVHFex6zJNjv0t0N+UDa/NzkVeQLqqYzmah150jvZfE/ZV0u/M4yC6/NHMWBN9NpMzxAU4j36nSxHracDm9ChLx/kM8x/bERvuJmN9//UUdXn0s2H2C1z6nJSbLI+1HzygdnYluhJZoWtRidItUMR+fa9ydg4i9RqNjhiuyChRfIuxdNSxvybow93bcTe91TmTgS0G+4RD7R3WEptPp6RLgJ9fGc57Ye7le7k/ynqKk9K+JR42oaJtM8dN5d9By0SOFbgpz2KYs7UxcbzOJAfA6TOAVfEw5Q6gD998umCC+FzvUzCG9n3K95n4hfJ7IXnk8QQqn1zczurdpjHMHepbX2VAOAMmfALeYm1igGSiP6epQhg/rc3BziuFaUnllrhbX/vb9UwlnCqMXjyz/dZjKPybYwJLnO9HwnkSMbeqRwkWGsjutvja16ns4LU02IRcvS+6WifDLIPwnJDmUxJ6vt+D8HJUuVTp/4dKEnqtXrLagQVJu8bRlEBL5bia8yG1jQsqI3+/dcWgxYDj5xB1sNjfnbd4EaYh56x1M39F3npwE9pZZ3FXavoca4lOQwVtAhgYl5EIwVtTzHVF9RMWUSJd/SJuhniSk8F2SX36fJ97FUW+EdALatWli9itPeulsITIyTIpMRLmZZU2BlWcQFpsANiMAIyqxkI6nHLdWlaqivQdK1kDcQG07ty5VQzaez6Xgm/3HDQTeOhqLQ8kWCMMrBAsX9DQZS3h2yyD8nZqklyvVjcR6S5UgwuVinIapPtcIiv2gOtzG3fSAGVtmZgOxnHRzQNFAhvezN1aTTsi11
 +IKQd2eO
 g/L0HWNMaYXwMBo22IYwa2YxnP6KEeggy7Llex98D/251TpV6t5+TchKwiIb37zEODzNOlVtqFIHkyWK4litx4s5IDj9n3pB9TlKRyvFCOl4tT9oa2wQ5D2aty41FhBQyahsI7c+29RTpHsrGqRaAR2aOPTp1yCK+bEqjM8d9q5rpJNLQhk2gj9xrF/+qCu6WS0g5V2Ai83/ESIBq1Hab4xNoh6fOowIbin3wMuzsljUasezbbEuCeSpW/6qj7DcMFRCO2H+wkp8if9gQN0LAemhcmRwE1uph9RXVuvBWI7KXUkyAXPjszjg1Y9nLCLT6vcJ3Glbpx38vz5gkOEJMnk8gj9IoYr9konkEGmlr1IQFRr8BxBZpM5oY8PL6uYHANeftAe8xQCxT/1V/MP+Npb+4S3MPik9gXaOXThvfNGvQBQH+geguXK3RXw5NUCxVqsiS4l4ib7ZoWCnbE2fGvwUYWG6BwrWYrQVq2q+GEvgmBBjwStujT9T7IUe3uvxE3BLottW5pJYc5KldMlTEjpHo+P9APAzBad84fOUKqGhY0ADD0oGSPUrUEX+TbfAjKHNCFrOWax43ZY7gWixwXnmLTECvhoHxusQpbwgF+rsurN2lT3PRVlstRgULoOpS6cY7uGIxkXnQ8zwYvXQVi/af1yQnBGMkCnCw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into inspection table:
 - nr_threads

Information on these annotated variables is stored in a dedicated
meminspect section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/fork.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 17d2c2a9af93..5f20b6250259 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -108,6 +108,8 @@
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
 #include <linux/pgalloc.h>
+#include <linux/meminspect.h>
+
 #include <linux/uaccess.h>
 
 #include <asm/mmu_context.h>
@@ -144,6 +146,7 @@
  */
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
 int nr_threads;			/* The idle threads do not count.. */
+MEMINSPECT_SIMPLE_ENTRY(nr_threads);
 
 static int max_threads;		/* tunable limit on nr_threads */
 

-- 
2.50.1


