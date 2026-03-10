Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87BBAFD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E594F6B009F; Tue, 10 Mar 2026 16:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24436B00A1; Tue, 10 Mar 2026 16:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4E16B00A2; Tue, 10 Mar 2026 16:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDA106B009F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:18:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83F82C17ED
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:18 +0000 (UTC)
X-FDA: 84531265476.19.AA24448
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0AB411A0012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ThgTmnWO;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=NxHtxud0;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf19.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUnRC5Z9iDEsUkeDXjt9L4ivaeLdDr4kj19gbc3Hy6I=;
	b=rmTm80qtGo3+efsoSH0yIX8jK2/QMVGFa1EVEOm48qv0y5jZs8QjQXbBoCvCv4OIgqyBCL
	2xqQhfG3Hht0K3Hpci0280axPB5TxVsw4X1sY5WDGTSQ9kBaYvZNbXqT+30YkeZ8+j0jyT
	8oeGUBqsfL3gcxNaKQ82TT308Wicdfg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ThgTmnWO;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=NxHtxud0;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf19.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173896; a=rsa-sha256;
	cv=none;
	b=EbE0DkzgAlCPb8HdXBDrQcccHIq6tj/dXS04W+Fq9gHfIOnt4W7iOOoBkNSFjGRVYwYZE6
	4nU1aMcr+xoZbQ+UwV5ePAuC0MOyGt3tvkjEaFLvWlKCua2OTgq8JBqmedraJkso7HnS2U
	Lu397MljCFFSLjRNEdyVXvK+Wda5foo=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AGGxdp508369
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GUnRC5Z9iDEsUkeDXjt9L4ivaeLdDr4kj19gbc3Hy6I=; b=ThgTmnWOfvbZeQo1
	JmhSGY/XWUnWavEygPXUvRtSQuzM7eO68HBklkhFXiEJF/pLtdJLv9M+QvmNdpDB
	53Uf1epX1mwcmxWxQ1hUuD9kbeKWXsJMxUE5Owva3qpevqhT2s4DprTxmfaEsHRV
	AS8AUtpw1FcKodPRvcM23BVifHTzbJE2vlQdv2BO45BEGoN5lT9go52vFwF0Al1i
	jzr9rv/rVfs1Qli/kRemy5JL6zrh1CczgpDCntp48GdKc27UkzLmNceX7dJ1QTfu
	SmrbICVkKh5nF70f1D18IYFvLjwJBpM30gywzH6qahOL4lGsZ5J6XKCACmAucW8W
	cvRrgw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctppagwmg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:15 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-829942cf9deso4514088b3a.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173894; x=1773778694; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GUnRC5Z9iDEsUkeDXjt9L4ivaeLdDr4kj19gbc3Hy6I=;
        b=NxHtxud0FZrTEsCmtX6dTgGnskYjWYQwyIUdvUz9RSSkxDVOAlQ+fnPaNssmVTpUfL
         p9se2dvUWkqPfrLugmkCWG3dKmXTIIk/stpuXUCqX3aJR/XVts1mMyPuZFppY6BBrYm+
         JBq/z/6SimdE7ocbksRguTqYgRAamNFjmFRn+bv/ePfNSHTqCm/DsIOwaB8SFrXy1mWv
         jzOflUoGuTsE86T4LSJl5jwXv3Ntss4AG6mSeI3zbNjWDP7FBEgc+RE7SJhTEK2ieG1J
         Ylismb2wAY67Uzm66d2hbpbxO0bJBPYpqowW8M0R1oM/YjahzaGOaKeDqVQNCA70EWJR
         fEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173894; x=1773778694;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GUnRC5Z9iDEsUkeDXjt9L4ivaeLdDr4kj19gbc3Hy6I=;
        b=QNsDwtdyU8rF6zO1pI4gm6k9+Ov8wCNyTac4g5Gxt/BjnSGELOHGucCHLJwKWTiyYL
         K5mPxue7TYqfbzPjVFL96BAoOoYIVwCLPTNyO8iHmEo7LR8A3IWvn94OsqgS1NGYZv1/
         J9TExKRkTlpRi15oOmfPka/rMrrvC+5MsXDbAjhMOhPsoLLjAcTAtebDYjnxAyjoh6r0
         BK35OcTRNbpoHtU6finOfSAA6il7BPytiAxsN3OG69Ip0uwgMLpFK7KxCAZfk926mtzX
         aglkHnacOCpk8qKc2pMA9sg2c15j1/DGIEsO0UioM2sLD5JJ3Z8/BnjtjVY6dmLTpRSy
         62lA==
X-Forwarded-Encrypted: i=1; AJvYcCWoHMawFUM9lnS1UOdDo6a5ZL9tzm9zJTW+sp8iF8RFkE/clZ5DFOuFz8yv/49Q3kYiQxu3cEqnpQ==@kvack.org
X-Gm-Message-State: AOJu0YxYL7B80SSEFZsutFJFGKS/dJqbbb37Lj/kLPuoAvyhbmnj1dSr
	EXO4zDH1jFgbcGHGbmNg0SO3AggvPukg7iYyA+DNFGMxwwYc40kaKRNlg3auoWHZf42S0UtrbJS
	3NzsmoGSZ2xFYp5eiLb4DEDidUAk2I6/zkxS2oxyLuW7wnpZHRDxCOg==
X-Gm-Gg: ATEYQzy//WNNHLvHuGsdcceZhJgJ5oJtkNc5QVLXY642vAyBpc2KQTe3lIUkHIFRN4n
	W+PncB1Fh9eC2JtZuK0Wd538vAJPqXWH0Ls2YLUHWvnhIiDOAdnFLjRTT5tU5dOpIWJNtpkmtY0
	dA9OV9TcNL2YCGKsPZX62XuRD92sNDEJ6lhN6Wr9wsILizP9llBvowkbmcEqn6vhangKpitJXJJ
	gnGNpPVTpp4BlXQ5Kv2wdsLaQY3m4WsS4WRqX47yk30uWbUiYkGEVLkUfSnoFKmlzLI5LzSWvFe
	rvm/zeS0DlbNFgu3UwrcV5HsZri7p3aRgeQhb7dgPLICtC22INi1fXJCdKJ/sgG8DG8YVzTGhq1
	6vlfw7//uuoUfBetmC5m3/PjKPKhQAJzwSbuFaFjanVKxjqwE
X-Received: by 2002:a05:6a00:420c:b0:80a:fc3c:f839 with SMTP id d2e1a72fcca58-829f7078837mr151579b3a.49.1773173893841;
        Tue, 10 Mar 2026 13:18:13 -0700 (PDT)
X-Received: by 2002:a05:6a00:420c:b0:80a:fc3c:f839 with SMTP id d2e1a72fcca58-829f7078837mr151503b3a.49.1773173893211;
        Tue, 10 Mar 2026 13:18:13 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:18:12 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:52 +0530
Subject: [PATCH v2 08/25] mm/page_alloc: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-8-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=951;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=WjWOTE5wCASvyqTEqQTC8D45Mnb3Je5ENWQae6LBsc8=;
 b=sCMEZiGoy1i3RaFgw2bPkErqvS8tQsW6y9j1/DY+TYT3BAmsnGCCvrBuUVNv5kpwQ0AKxsqsc
 0GXsjJqIPzVAxAfgDVGIQ0i5cxpLM7I3P0NkJ56C69IwXRBjC/8natt
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: PxDzWH02nkeBU6d3R-pBQ4aKB1dAs3u9
X-Authority-Analysis: v=2.4 cv=D7BK6/Rj c=1 sm=1 tr=0 ts=69b07c87 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=TiJDLkziv7N9Y1Svq3wA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX5TJXERrWW8t1
 fjCYgHUHbPbbYv4EZyJQ2hwA0ApDh8Tiaqj67viyzqic0iQHs+hYpEolZtw8ETQzVi0MDqZWjkw
 MD8yBxr6pknd3n84kVVVuauaiYmed2iZwzMWwOR7vUvbXkLhzpp7+E+Sj59iEuQV5GZmRAAPGVG
 2KzKuQTwwnRBmjmnsMrA1XZSWKrM8q79/oeh5WIv2UM5KqsSwOCAd+Ch9Wkp4Nqd/affkIYA4kq
 PLdTcGlU4g4AI9hlW5BXJy8/z36yf4VJP+qYWElyw8GGz1PPXwAyMMB9j/jemZ5DAtr396aP+Ts
 QpNT7cV7QHy8rOivWB1Dvqkpb8WG0pOHe2zENkiNOT4uLk9pv41yI5dBP+CEhYCwO6RlQd0c5re
 OoW6lQvMeFrgSIFdK3EGh15WbDBJIu7ef1LHSb97+dUXDYIUfHADOsIUKFqKxeJRV2kMmF38gpl
 YfYavj6SO0zkNTHkglg==
X-Proofpoint-ORIG-GUID: PxDzWH02nkeBU6d3R-pBQ4aKB1dAs3u9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100177
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0AB411A0012
X-Stat-Signature: zht1p46jy9g5t6qgbq8ryx546in6jsga
X-Rspam-User: 
X-HE-Tag: 1773173895-366364
X-HE-Meta: U2FsdGVkX19hCpgcRZpDUTCB2FIeBxSiH4izMh9R8gGk2/nbxP9CSHGnzUB4o3u6L7STYtDT4PFMlGGxTL34dXKH00BhcTIfRhkKZj7elVH0eGZThSwSWdTX7ERoV59ciZbPEUHqAhsJtcSD4YG58gS9CDuNauAOSp+ve27uqnYWJFwn5WJkkrFF0zmsNkoURhjpWKbFgThVmZmbqQ66ZTxTI/AIOn8rdzOZj8hA1VewKr56OkC+ph5a7aAyNieC0mtHLN3LYReXXKdj5DPks2pFcCbdUFvbc/hkvFdSSnqkcjRNmV+tFDOjmmbK9hvL1UlO24fR+MwpkNNihLB+ruHP6bMlEQ18aQAvedqWwmXADHfAUV5tV3IbaS1m9e6NpUVoNBaUndKa5I2BcDox9Q8c0XEdJQUNqdn294eZfnrTlVU5+jDOa8cluZVN3FG6oNRZzYhzRWyj6TkcpWQVk4YcFX0g/xEkS6oP9hHYUz8/LaBTcLWsGyrJnjR21O/OjfSxxjmIwt1I1YXOQokSUDZED44WZ8R1QqNBbT+IAYx8UGueJoJIEX+OGwTWe/xtBx6F0F2myPmb2ErZo1JTaxpJlVuTgelLtzqzhnfK60Fsfi7WGDZ42UqTj5SMhvz9NyMR/FNX0u/6NTtaI7yJcsb7yOrILc5I/Fl94I8vneYckl+Qh/Rgc9Nj3junU7x7+u16LwFJ4FRG1zgPeY+9ddxBFCW+M+i19kKKDa7hxGrZkGxgrWsKqO/Mt8K2x/MuHawlsrCuGu/BtQxaPxO3nlS4AdadWTiw+eYtXG8HxCHGWReliBOBaKS+1Zpl6h6TewODIOn4kEPpRZj23hcxquJp8hBFp/lv8N9WOHyioMYZ9tcIDWvrqH5afoBw5qWXopaq6mVXk/QGXpY8qV66dTPv4IKIf/lsFX3HTQqr8pqS7UVnQ5pq6Sem+LBraCLaQijyzdubnPbOGCbntJb
 5+bQZUUU
 20GUwWzXdyAde5t5Zw3slyzzeKikto9vClkdTS61UY49VsaZiYEn7fj3W6r003fFtovzSB5QUaPCrPu6zdm6btHdkQojeI1JQ9o8mxDA2n2Gw389uk/tXUyAMj6lJ9i24KCdSX1reCtwlvsj+ARZb2o4WVFKTMWmiKpYlFaiANbD0z37c/fKkpuHvutZAf8feBdmvnhrxG12x0Aq03eVwvjLMiF7bR8T3vR1WdmytzHP8yiVpd7OB4Hq0n1JObj2ZijFpxGfUDVdaPUGjVdeGZdoIcTJjbKc4p/Iygly0LJYAexWKS+P1orAjTr/B1+BxgeXLOLnej6AmPi/X2rSbk9EzkM7R0k66wI7T3O+At6C3l1r+SwpIxlws9WLNaAlDUL3gEO7w7sXD0fBKmpCXhbK6kwVS1tQukw9bTDAXZW/C77OUjsgkgVtGJNTk564yspdsEKsNA2TlHgvfH0jyodq3SqD5l0f/t+t3fFfHWHiq1WaUF7sbKC/+nrHa2duSsMWuJ7JlG+vjnu558Mp8rqP5BMVSwr2ieN6VO7KxFqWGQwN4pGc0d/lWSswkXQkkmVdv17f70c2REPV+of+2DEU0s3tuE03DBJBX7hX5ro7jAWzqyqA2PZGyH1nNQyDVkW0cSSYXTWbHBcFmPB8aYabvI/ZZRty38bewsD8H8KFtY31F5VVhH9+K0UhZ0xCBLb09/2zHA8xewW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into inspection table:
 - node_states

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 75ee81445640..c28a84d11d49 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -54,6 +54,7 @@
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/meminspect.h>
 #include <linux/mmzone_lock.h>
 #include <asm/div64.h>
 #include "internal.h"
@@ -199,6 +200,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 #endif	/* NUMA */
 };
 EXPORT_SYMBOL(node_states);
+MEMINSPECT_SIMPLE_ENTRY(node_states);
 
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 

-- 
2.50.1


