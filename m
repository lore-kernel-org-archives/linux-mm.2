Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B70EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3956B00B9; Wed,  8 Jul 2026 01:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38C7E6B00BB; Wed,  8 Jul 2026 01:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 279D16B00BC; Wed,  8 Jul 2026 01:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7EB16B00B9
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:38:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77768168F99
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:38:05 +0000 (UTC)
X-FDA: 84964503330.06.BA6B5F9
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id E84A0180002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:38:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=FfzuHjvm;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VWBe1bYm;
	spf=pass (imf16.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783489083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tQhSIWI14qqnmz6kQc2gEQdl1vvWUYPv8dRt1VJvvg=;
	b=T1uV+nzSM28VRxmQJ7JYtqqwln/EkAPPZqeyUKkp6jtPbfqsoMIZ+jjhLEHcUlw15d2xoO
	ZsZfEczA/1uLp6aBpqNTSxuBxQGr9jSxRo0A5w5yZj2OwaW50KLErHU8r/ilxDZKXTa8ho
	PdxJGEonPtuUASKr6DWfSbpOE7rT2FE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783489083;
	b=eLLN416etDc1Dvzj/xulLRuxjg618nKb/Jb52AUx2OlkTLef93/eiAgjWoeQqsWc69BSWL
	jYv+1Gf6ejG6DChGJGbSLnqPrlrKb5yvOD2SDx0r7f8//n6DJt/IWtQ/ibxapUCZk5z09a
	cCOjztFgwl/QhxNQ/zWzhU35Xbma7yc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=FfzuHjvm;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VWBe1bYm;
	spf=pass (imf16.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842RQg1509183
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6tQhSIWI14qqnmz6kQc2gEQdl1vvWUYPv8dRt1VJvvg=; b=FfzuHjvm75cQHZf3
	TCN9eJ1x4s7H0avZYnpHrX0U4q749iAj2TENyuuyKJE1sjE+UdIN/2rsFExFjoTh
	CI3ywe2xNZ/eZkaOxt6yCpn9a7u/O3vrsWA9AUZtB2UIsE9xo/GOseBFd+VcNwfg
	+hxjGwJzz9cjDnygtg/MHpTXucuO2kdVmd6930H0oqVrh2IAwMr8UcZGNPaEJDvx
	lIkDWX+ZZdokzTR/dRXDLdWw4OQRVdS0tSp+KwLk3eN4KyrGcsI8HHOhUOxX7/xd
	0izWDl06giRUT9qFU1ujKNQfQZqHSxO78F71U9MNLaA/ooldiHZMh7mdgRhovq2c
	5kHv2g==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9be591sh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:38:01 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-848452dd146so767503b3a.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783489081; x=1784093881; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6tQhSIWI14qqnmz6kQc2gEQdl1vvWUYPv8dRt1VJvvg=;
        b=VWBe1bYmW02m7tMBEJrpt+Ez3oB3HwV8evaxkOAVzcIlEUsYzitdabnX/dufBWuem1
         /6RsmNvrvVGdMYqRN3AwjfWzsV8Qyyf/GlTqD6Xu6aYnEht3f4knQtu0J66durCfF2fL
         VPZC1bB9qw8XRLjEbxX8R28aJgA9BXl0aq7zD431Z9jcTplLYIvbpwNiWhBJ+Fy1WsRi
         xYwV+9s/AUnk71Wof0M9yz+APrTjE8M3BxzKMwBarFwjzg6rSGOMMcHyawJ1CsC53OPn
         xGSh8zT4w5QTB2lbsRdDQMR+gmz9H1mShkT2mnArd+rYX+ffygrzo/Ep8k2LSje3O7VZ
         z8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783489081; x=1784093881;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6tQhSIWI14qqnmz6kQc2gEQdl1vvWUYPv8dRt1VJvvg=;
        b=cTVpd/+EEyOji9rnerWSSUrhPGcR56DM9D1eIG1UYcAEPzgg7ThRvRXBu16KtGnlVR
         CdLZxVYKIrTBgVzv2JoI2mctclp5/Ax3DXMUrFKyh/+qLYvVFCHqT4I5dmG1kW8u0EcI
         zsllM7ik499UhajaSBcEv6fj9ZqbjbCbGzBXLgQ+E2kaggDy4LsDR9KWAECg2Ag5Juna
         j9R/BsBXPp81lKBnrSXFWcQn882osZ1MdxFRiTzEWym760OI4Q0vGFP/IBixXQ0lkkWh
         jHo9PmsPxDBDhwcm+iX6K7GAKPGvnCsCJgn6+rdetIUHQcerzC65UXc9KajZysizaORs
         HjCg==
X-Forwarded-Encrypted: i=1; AHgh+Rr3Ux4Qjft55GwRJ7wxDz60sbtM5ic68EKXswtxz4RUUiehDiDdXqzi+u/0bS2unizzB4aJbRjCSA==@kvack.org
X-Gm-Message-State: AOJu0YzvD/25vMVjhlEwPTKgbKXyVReutIgfYV6u/k9TalLtwL2zUrdI
	GP02ovkPHiPVSgR2z1l0YRWySqvxH1quNY3bJN+Kp2XqWfCGsIaYjz6vZCC12BYhxC9U7BdPaQI
	w+z77jIjsX/7SSTkLhLkH4rJo+DzCtie1oj33Hsr5NvLMAYUHMgzZvg==
X-Gm-Gg: AfdE7cmYqiuNyykSm0lDLPh+mq6fixKbE9osQ34ISMc89dFYNlzYO5xiXV3misXWwi6
	Xq+vZ5Rmvz9gtcKU9xB4KKvggfhMgL4jzLQs3KzUYo+i6oqvHFrcY8YWDz5ph/JriC6XF6M7GSV
	joqk7KzRhaWEpTrwMlMoKq0AYUpfi1XifnGv2wzovvMxp/zqBn7q0B1Jsvj8x31+Q3i5qUOQ6zE
	oWzY6LFOhW9+spYuhbfmZP/v1O8gJVSZRmOYBVUT0lgAaFoPLUzs/P1Mpc5aAhhWtJc3Wh5/nY1
	6+jW2Z9jQk143EOVnfDKBrjl2FCY4CfAr5hSwka6E7RR/NCJGXPssn0ZfmbKwcHE79gF9/rsTjX
	333lsR0WcAQY0kpE8sQKieIqTmKqoBptRfPsMuA==
X-Received: by 2002:a05:6a00:1826:b0:845:cd11:37e8 with SMTP id d2e1a72fcca58-84843273dccmr1108569b3a.24.1783489080594;
        Tue, 07 Jul 2026 22:38:00 -0700 (PDT)
X-Received: by 2002:a05:6a00:1826:b0:845:cd11:37e8 with SMTP id d2e1a72fcca58-84843273dccmr1108519b3a.24.1783489079953;
        Tue, 07 Jul 2026 22:37:59 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:37:59 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:02:01 +0530
Subject: [PATCH v3 22/26] remoteproc: qcom: Move minidump data structures
 into its own header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-22-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=5306;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=/Jtff8M2EKscXA/Je0INbgmO1YS6m/R2F3Zo0Iz1ek4=;
 b=xINWUZfMh5pzjvIvBrT7eJj7xNvbLw2tKLmtZMw6qxkQ1gC5A0Ib7M6fYtAHV7x10PU5CxuEP
 JzEOyAstB91B4AE5pg32ds/zx+eCqBM/u716kEL+09/CtbaoWEyfJmx
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=GJc41ONK c=1 sm=1 tr=0 ts=6a4de239 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=b4h7NkmuwT24Zy2QmmkA:9
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfX2W5UUDiEwaeK
 u0g8pZNFTfCdbGqcC/q0uNKoumzfhskoTQ0vSNlhmMOCFJ1GNsfhF+Gh3HLl0rvtoh2Gk+4txPY
 x17ElIihQ7FV38d8gfIIq71yHgDGM0g=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfXzIFPffKyco9a
 ceuEiMtc+Fog4wwIR1l3BuVZE1656DtiXPDM0pXNW+hrFDlq3OwfkuCi28a5t+Fccs/FY0ZNPWS
 GfN7GzdoKifxYIrxN68tL78WS0nrfNe+e1+U7MSjAbwUWioMccMB/n3mWw9wOFtLKwL5fZVr3hO
 JYtbarascbcUgZdfHDeKvW7nAYuwqlsMdlPJJgltHOpCemGjxn9CoWuKtJH3ogBy+JTH0pg/G9Q
 johat4SQr5bsQiYtMKYxrBVVGttkm5QjMsDZRrYaZZgO96LkErsOSRq4ZAf/8dudolKKkgPb0lI
 pli8hBOhLjaKd7r3sBmeCa/HIhqMsUy+VJ6ohfXvPTME2wh7ojVWughYiQJcn8yDAs9ytvRhi60
 tW2SpduN7ShGao2f9SfazqM68olucXHtnOjkjhy4K2xZsjgZGBjYHiFDvVTxPbBOFgJH3lDYVd4
 EW5HbKgzVItWX1bCo9w==
X-Proofpoint-ORIG-GUID: R4bP1xz_lgmDPNH2Gd9D3I0IyLvJlqXs
X-Proofpoint-GUID: R4bP1xz_lgmDPNH2Gd9D3I0IyLvJlqXs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080051
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E84A0180002
X-Stat-Signature: 91atoyhohpdco5bp7nrgd1bdtt5w4f5n
X-HE-Tag: 1783489082-257415
X-HE-Meta: U2FsdGVkX1+cL5vfKpzrF7tzwo/hrxtTFc8VHLV7ZxAruMCoGOzn8X3XMj9I4ClBG1sujK7MDK24EtiLSTrQrsBfrxUlFA9cdfjXyftZ5hPJoDa1hSYlutioH20C+k3CfmVPu0G7SF3DLF46iTyK+/S0ts9ZY1a/qTmK3lpkNa0wgX1+TOHE3mLjX590NWHqrjx5tr+9XkzCJqPb+uQuYNk96fpFkm5vF73Iad6n9O2VIr9PoKj7PlhVmu0Nw+2tZa5SpHj0BEg1BDtoNjD2w1jAYF0JEpBnMvZllyO7roQkB4kveYNfYqJDBz/mDY3M87BBSRmCK9a864U39AMoFE+vqEujIRHnYSSYhCrdpI3hJ2EPa6zlChycV8gPghkGsdR+UOWoGfx76gFNNBiBuTMRVAeuXxw+QAX+CCtOuSL8UtNti0PmSqXAQHe6oxjd7vdHurywZLiJuRrCKClYMDE3+zGGjnk+3twpM/9dnD0DjHAyldpEvPXLPIpEdLknDA8NCD3P3PodWiJhdiiAFZl1LRVcTpf3HUB7XuDBKPQHQV+Id4P4M+6+cdeOIr09+5kF93+gBl8031e75k3e5W55r/PtXvQvWCErfLk5QUKo+jDNB8pGg4kS4Q2GASxpDpQAVhgOi6mH63tpBvcCyf7Cij9TqDoYPJRo1lo9AaTmrzvkLcBk84JSZuVTBJbyzevHMWt/3K1Jkh9031vYabJwVW0WTj3utPXaPsdmHGKdNbHM7DvLUKPJS51hAE6lk/n3zpkf09ltmCfr2r92hycHV7JORoQVkfDYQjzLvYdDzdmKy/ooenICi9By6+nDOLyUYyHtMKcJX/TaldMxmGbErUIFVcH8WkQ0DZSyzt7p3AmWnMcrhy7Q4ISYzyZq5+juL0sJUxbi+Jc1XyDXFlkzFX2Ud7/84Gf2xLH6BLZLjeyDhEJ8aj2ciWYNWDfvrGHWPKjqm7Q369DtsVE
 eK81E8u9
 F0uCJ2d+9kgjOQD+vTIgS4w1H9PAeM3DSBZvYG9yzCzAvLNJMpYnM5s7cSSIEgBC/rtyxH+p0nahPgF6l392qEK/9YX+EyV/+9YAET88irhUuxQGxGzQOWWK/PHcYZe9mF51RtjhD6AZ8Vque3a36NdfF59OZNV/obggjZs9fw384r6ISJwcmdSJPFoe1OBjW5bzvxOX+hobIfa8vRhp0rZe8ul6X2yoFpdShgx14l76QEsHJvkW63GDeRwjcN/1YrLIeTvXU8jaq4TzGRmJB/KkyVWxeoX2hWMG9BvVZY7oP0j5GlFuXhTeBH5TBFE0CF9M1ycRcUDTLPlTD/pekZNBjc51qOdMFwHcfxlIq/pcJ1fdxkipC+MzCCT+rw62RaS7LHRZESm+7usq06SjTfH4yBJl+cG9XAg874sc2O+C+jwvkmyH2T5k2TMqj9VGSNo+6PKhDbIo6IX+VupxhQnsRA0wjFT82gn7o2ZsjxIEwXEedPAyJ81WwtA/q8hpmW8yp2I+11H3fX45tPo/0AGwOYt/hxXbVDr7v+JXVUxApNUEVH8SHyVb+SUncb4GLxGQHPqesG6WbEo+QxRP8Ys/3UBZTOZ4Igw1ckjbdSnbB/WlRQyi1l92wUkZ+o/Q4d7Gvf0qI10NxG5qp6ji5INFgBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Move the minidump data structures into its own header such that it can
be reused by other drivers. No functional change.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 drivers/remoteproc/qcom_common.c  | 55 +-------------------------------
 include/linux/soc/qcom/minidump.h | 67 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 54 deletions(-)

diff --git a/drivers/remoteproc/qcom_common.c b/drivers/remoteproc/qcom_common.c
index e1a955476c9b..a5ab9f024e64 100644
--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -18,6 +18,7 @@
 #include <linux/rpmsg/qcom_smd.h>
 #include <linux/slab.h>
 #include <linux/soc/qcom/mdt_loader.h>
+#include <linux/soc/qcom/minidump.h>
 #include <linux/soc/qcom/smem.h>
 
 #include "remoteproc_internal.h"
@@ -28,60 +29,6 @@
 #define to_ssr_subdev(d) container_of(d, struct qcom_rproc_ssr, subdev)
 #define to_pdm_subdev(d) container_of(d, struct qcom_rproc_pdm, subdev)
 
-#define MAX_REGION_NAME_LENGTH  16
-#define SBL_MINIDUMP_SMEM_ID	602
-#define MINIDUMP_REGION_VALID		('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
-#define MINIDUMP_SS_ENCR_DONE		('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
-#define MINIDUMP_SS_ENABLED		('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
-
-/**
- * struct minidump_region - Minidump region
- * @name		: Name of the region to be dumped
- * @seq_num:		: Use to differentiate regions with same name.
- * @valid		: This entry to be dumped (if set to 1)
- * @address		: Physical address of region to be dumped
- * @size		: Size of the region
- */
-struct minidump_region {
-	char	name[MAX_REGION_NAME_LENGTH];
-	__le32	seq_num;
-	__le32	valid;
-	__le64	address;
-	__le64	size;
-};
-
-/**
- * struct minidump_subsystem - Subsystem's SMEM Table of content
- * @status : Subsystem toc init status
- * @enabled : if set to 1, this region would be copied during coredump
- * @encryption_status: Encryption status for this subsystem
- * @encryption_required : Decides to encrypt the subsystem regions or not
- * @region_count : Number of regions added in this subsystem toc
- * @regions_baseptr : regions base pointer of the subsystem
- */
-struct minidump_subsystem {
-	__le32	status;
-	__le32	enabled;
-	__le32	encryption_status;
-	__le32	encryption_required;
-	__le32	region_count;
-	__le64	regions_baseptr;
-};
-
-/**
- * struct minidump_global_toc - Global Table of Content
- * @status : Global Minidump init status
- * @md_revision : Minidump revision
- * @enabled : Minidump enable status
- * @subsystems : Array of subsystems toc
- */
-struct minidump_global_toc {
-	__le32				status;
-	__le32				md_revision;
-	__le32				enabled;
-	struct minidump_subsystem	subsystems[];
-};
-
 struct qcom_ssr_subsystem {
 	const char *name;
 	struct srcu_notifier_head notifier_list;
diff --git a/include/linux/soc/qcom/minidump.h b/include/linux/soc/qcom/minidump.h
new file mode 100644
index 000000000000..7449a04e6e15
--- /dev/null
+++ b/include/linux/soc/qcom/minidump.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Qualcomm Minidump definitions
+ *
+ * Copyright (C) 2016 Linaro Ltd
+ * Copyright (C) 2015 Sony Mobile Communications Inc
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef __QCOM_MINIDUMP_H__
+#define __QCOM_MINIDUMP_H__
+
+#define MAX_REGION_NAME_LENGTH  16
+#define SBL_MINIDUMP_SMEM_ID	602
+#define MINIDUMP_REGION_VALID		('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
+#define MINIDUMP_SS_ENCR_DONE		('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
+#define MINIDUMP_SS_ENABLED		('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
+
+/**
+ * struct minidump_region - Minidump region
+ * @name		: Name of the region to be dumped
+ * @seq_num:		: Use to differentiate regions with same name.
+ * @valid		: This entry to be dumped (if set to 1)
+ * @address		: Physical address of region to be dumped
+ * @size		: Size of the region
+ */
+struct minidump_region {
+	char	name[MAX_REGION_NAME_LENGTH];
+	__le32	seq_num;
+	__le32	valid;
+	__le64	address;
+	__le64	size;
+};
+
+/**
+ * struct minidump_subsystem - Subsystem's SMEM Table of content
+ * @status : Subsystem toc init status
+ * @enabled : if set to 1, this region would be copied during coredump
+ * @encryption_status: Encryption status for this subsystem
+ * @encryption_required : Decides to encrypt the subsystem regions or not
+ * @region_count : Number of regions added in this subsystem toc
+ * @regions_baseptr : regions base pointer of the subsystem
+ */
+struct minidump_subsystem {
+	__le32	status;
+	__le32	enabled;
+	__le32	encryption_status;
+	__le32	encryption_required;
+	__le32	region_count;
+	__le64	regions_baseptr;
+};
+
+/**
+ * struct minidump_global_toc - Global Table of Content
+ * @status : Global Minidump init status
+ * @md_revision : Minidump revision
+ * @enabled : Minidump enable status
+ * @subsystems : Array of subsystems toc
+ */
+struct minidump_global_toc {
+	__le32				status;
+	__le32				md_revision;
+	__le32				enabled;
+	struct minidump_subsystem	subsystems[];
+};
+
+#endif

-- 
2.53.0


