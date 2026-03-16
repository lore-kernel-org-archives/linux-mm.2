Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1339F53D85
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030D06B0337; Mon, 16 Mar 2026 14:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F290D6B0338; Mon, 16 Mar 2026 14:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3B76B0339; Mon, 16 Mar 2026 14:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C80586B0337
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:17:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D8A01A033B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:17:16 +0000 (UTC)
X-FDA: 84552733272.18.91320A3
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1017180005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:17:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ordbabXD;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=A8hdzkol;
	spf=pass (imf24.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773685033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQaNupo6FUMhewtRLNzdvftP/Bl6dIddVvBA/8yfO+M=;
	b=HOcfHec86FM1wkNFTqsK84Z/iXiWAy/8s8dCC5fnlNEsK51IBr+AEQO+pIXnrm2iNk/b09
	094PU7AzScQDXP++NpW65FPYxHURNT3QqAvRUWwPHGZTWJ9o5NTCvuRmHW6FVxqxcs+Mo0
	3VDHxaTiR5XKpFB9ml40Bitv2ODxyhY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ordbabXD;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=A8hdzkol;
	spf=pass (imf24.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773685033; a=rsa-sha256;
	cv=none;
	b=RJ+K2uYC49MHsiDWSQ0pkv+MXkALbUHyOVebbG44py/S+OJNx7aeKawf2KxcCaSjoCqqVh
	u4unoFxKXA9u+uWct4sXHPGgxMa0JL6FHN4YfrmjptlFPykBr2tsp4bOtmkmiWJlLivAaE
	uJu1asACCWXHVaZwgURwrpRcRZz51Tk=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GG6RW34022277
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HQaNupo6FUMhewtRLNzdvftP/Bl6dIddVvBA/8yfO+M=; b=ordbabXDw6dGs6//
	OmChgPWgoRdUvSqfuuSHd5bKYR17PBXafAVpkSkX9xkvSZGC3PgnI7Jhw4GFqj2D
	lZFaAAl0zT/2HQ0nhJDrIii5hMD4S5IDZJIuDGYgNV6h+t//tg63oYcnWuOhbH35
	d3C7EpgoxLfl+rx9HZ4Fegnej/uMiViArk3htwsildxLw0g/hOQqX7b8+1VLIC1I
	SETQu1ZoT+hKlke5XPCNDGyoVbjpsF7/MpuQn+wRGa5JJrLMPNR5eRv/Q9Q10O3X
	cdrueGaGH93M1mkiT5eSYVf8C+omQ8YlxDHDi6DNvDAsBLJ95my7pKWh0VR3pbTE
	o33zqA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxn3fgf21-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:17:12 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c7385e8fa73so2734944a12.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773685028; x=1774289828; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HQaNupo6FUMhewtRLNzdvftP/Bl6dIddVvBA/8yfO+M=;
        b=A8hdzkolovaeU6a0BcJJdyP4T9WxrCreouoK6CC5mVdxkv2j63KN1ivqNZFuYkEAVn
         ZXdOonfgN/jkmWUOnr3w0lE6DoDL88Rz6eAdGTzUgLdWulH+qnnjvhisLObR+qkd39Aj
         LbvAHQtQm3GqKh6JYrdwjh/AASzOcE6YwwAyagB0w9WW7JBQ2YWuGI3S8R63SPl1W50u
         iVV0Fr0fuq6xpEqk+zUAeWJ4ZAxycq+IyhGmt1StjYqBPafeGCDnhOP2xfrDz7pRv69q
         PNH0tKDntzs42zqi+hu8w8XcB78qfo6gZnPnTXuTvkU4yaLhICEYQhHLOLOxu/iaVUGd
         Cq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773685028; x=1774289828;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HQaNupo6FUMhewtRLNzdvftP/Bl6dIddVvBA/8yfO+M=;
        b=D7AmGKt1ZACFXi5uYOFOjI+b/PvowMlEVfTi4lOEdqSxvToVmArKb1Pa4PEEdCOLl/
         6kIEWTzVJvlLoZqYrn667Ua8SRdaZVBLDJhD7Pf80cynQk5a2OP50fidvIJ32uVr6wEF
         NA5sDmmGfZg3SyjjT+pz2wrh7IbV+JbPwjdBWWSVYkcKrow6dHFi6nezM4WoWdawiFpY
         9RJM/+sMRPOeKrwqo1RQQLKYtkZxrlP0en1jrFvCR7N7K2Vk/6IaTWT/uoQsQWkesGQZ
         Js9DT04++1XqHIQwOxlppIh6UHQCzI1ErPuMTPE/5OIciKnCyQj25vppywQWehp0ZsNy
         NJzg==
X-Forwarded-Encrypted: i=1; AJvYcCVXFK0bZPH2U3QqKCmLpYsqTpM0TMkIHmDFjmxW4linE0f3UCIx9Jlo8x/ZJSAcyDLMluTPbngFLQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4kGDVJKxhFwYR2HJuHvwxrZnR360aHBSBKLcXYTO6TMyGgW3J
	9j++DSKaIbWgWZVTG0awyj4TCMf0gVnhgBxKTcWR8Tal/leNg3HTBVVeXOukkY+L6LEzuWvl31u
	TMPYM41kvlh/3D/8CXiTgQlGsSK1IyikFyWdXyoi/gTdf0jSr6ycD9g==
X-Gm-Gg: ATEYQzxybJLM+7PDxdoLt4hYaLI0/wTPiSJEUkMHL7Bj42z3jWXJVizMnStCk/wcq8F
	a3m1DE1axj/RTD6DtEiUPomkLHQcqaG7IDKJjusLdeumOzGFDVkM3KiiONCnfNmJVtpWSbrvPWp
	XYMTmATP+MbZRCTRh66hEkAa429UQRyW0AlZAGYfgNdqP/uudL5LMU8eiIMO6BBTav3D5Mp/lkK
	eB2st5ereM3p2imoAOkXD9kmi7pCvKlGaCWH2AXDoiNaAhbJlilqWyD62mAG2WrmQERJJW1oueF
	GxjwarcpL9UpldmMRFf8quiiy/lxZloeruEV/2tzr9ge8Gh0Odukn3wmHGEfKOA75XkF0kIyYex
	MOYpp9EjkzK+bRieq2Q0yUiQc98nN5OlYiwy7TAbw1e7Cpk2g
X-Received: by 2002:a05:6a21:3981:b0:398:c2d8:14c with SMTP id adf61e73a8af0-398ec9e64f9mr12436755637.7.1773685027221;
        Mon, 16 Mar 2026 11:17:07 -0700 (PDT)
X-Received: by 2002:a05:6a21:3981:b0:398:c2d8:14c with SMTP id adf61e73a8af0-398ec9e64f9mr12436685637.7.1773685026281;
        Mon, 16 Mar 2026 11:17:06 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73eb9966cesm9457724a12.10.2026.03.16.11.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 11:17:05 -0700 (PDT)
Date: Mon, 16 Mar 2026 23:46:47 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
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
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>, workflows@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 00/25] Introduce meminspect
Message-ID: <20260316181647.m7x4ncmwdjho6yvr@hu-mojha-hyd.qualcomm.com>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <abdnp90cC5PI9wyz@baldur>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abdnp90cC5PI9wyz@baldur>
X-Authority-Analysis: v=2.4 cv=C5bkCAP+ c=1 sm=1 tr=0 ts=69b84928 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=vnREMb7VAAAA:8 a=Oh2cFVv5AAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8
 a=COk6AnOGAAAA:8 a=bLXd17yOAAAA:8 a=1XWaLZrsAAAA:8 a=EDBQhX0Mc2V3NrmwUxMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
 a=7KeoIwV6GZqOttXkcoxL:22 a=cvBusfyB2V15izCimMoJ:22 a=TjNXssC_j7lpFel5tvFf:22
 a=XOuVWTVwyKTMzSnUH6Op:22
X-Proofpoint-GUID: c5RF4knZ9_SlIrEQuO7YbeaWGSpmK2k8
X-Proofpoint-ORIG-GUID: c5RF4knZ9_SlIrEQuO7YbeaWGSpmK2k8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDE0NCBTYWx0ZWRfX8nKhPZq1V/ie
 QF489lo3WwIdHSBc9Nii7ZD5Cc+UgtyOspAYYWDNb5JZWSH860D3irLlR0r2O2umAJLWofBA4MF
 uMq6lSMu/50Jhx+mzo68plzYqm5KDp6lXDnBGSOXKqOyuvkFbM7VwzO8qy1J5gtTVDvSePEzcYH
 pLbj/txFWXWrkO05OVeLcLsES5qNlrV77FmUCKeisvO3Gk5xP7S9NFjNhVooQOEN3j/KAQvWPhZ
 Kj6WvU1Dhc8mv2rk2iQ4ln0vyewV2W3prCMb/Pq29U0erxIAqNU8HaDrNwlD3J7Ca/HN29AQgvY
 2LqJ+cvUoO+rV3JhEY+gGzBf6NTCpJc3UQhTewmXd2F22s053d2A0ujkhoi6qYV9jrvOhtbGUax
 OAfVpQJmC/4BA7ADvmiN3dXKkcryfzGP1Pzb6dV3tvrAwNUA/DPh5awQxEfOwzwHGZDhigBXy0c
 VQU/AO44M4+45KqRDcw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603160144
X-Rspam-User: 
X-Rspamd-Queue-Id: B1017180005
X-Rspamd-Server: rspam08
X-Stat-Signature: shipfxbha8gbiapbgkk4h4khmiu97qoc
X-HE-Tag: 1773685033-515203
X-HE-Meta: U2FsdGVkX19klY6wXYBIakIH7CW2VSd7hLivIP903AoeBi6TImMl/VNleoj2N4KKoukshVzY7BZYRZNf2LF9gvooAnzRNEXbaBgJxakUGV+E2gMxiFKFrtb5WIQYHnXsjtddsY7NCfsgM8N7eof5uGs7niVvqTRgTBN+I1YXcQq9BBeHrsGOoywkXY4bjTt+wJrHG7ZBvQCmeWw42XsYgTy9cTjEkRjiKqRLnPnY9l1lpnQDyARZ0yE6yZ1cvFwF771Oe0crVfl8QgAEAaqRw/iGppjdcOL5g0TEo3D9KM2tVChmlTVI/BmG6gsCvntBjPq1f0kp8CjLzlZTnhI0WbCftjyUD0TRBT8OfeOczl5n3PtfS7x9kNKmnLKTBTtLJafRElZSSFJtXaHPuk4d3RotjCNHyneTHspU0WTUuO7+YXuIyJxEb7EuWjz3FaZegTTswHgLfBqY3TkKoGPBVKsYJ7rV/5i9l5wEGoTgq3iYhoVoTXkULXt8QbeSlCJVtfqV53khu4UZ0vswAI+WfLzhb9GeYJU1+K9rxgb1WFv/dR7wDiNivXaDWJFuKijiiWcOXSL4Y2pRfEpIFzhow0Xz96givXd6tnOfH3NomsehkZuK9+6JzDTF6UXJXprxMA34qax5YLaT2AhAheWVI/jM5AYqoXuNar9rDPP1T6tqjswWAvNAXSoxxiUPBT1g4ppe4ihzxiLqBxro3RCuRxn+LjTWOgZH/WfiaOohL72OQuAGOxr904v9HPeko9eHccX9YYurYaUgxKI3RIIuFg8MvQrTPjPfxs6FW3DU8VM95rq9X/AJNA9/BxddSm3cTGb0MCDhDC0Z7Akfas5AhGtd2U0bxmMAopiUnDv4KiQro5n4/PGleyvgj+zyAOY3Y1b7sHCCs86mrLA3hTfoimGvQQaXimFf2EemkEtF9Wx2mqnvyw6YAWGUS5bngLNI0nSf0UWeeLD2tfYwh6B
 AC7c79tC
 xFHfkMcS+BvttLZedpBxfYqD2bfvbOOj/bB7eIRKr4x6cMrXH4mEw3pF0V8HkNTzpFiPaMnUiOCUnA09PrhBMciKrr6JIGerluTqJNVdtr76oLLL0TZR2HcO+VJmPCk3HUVnutuD6mSYB4mRyBW7Ey/mYHQLsdIv90Jy0ml+EGOseWT4XuYlAHlDKNV+VneUG3M8pdEKvvvHiL9oblyp3mzWpQCg+z7eB+kjoqzXTvkZU2VjHeRzvDbkCOQAKCEFjY3bAWh5ptnyWg6bJW6vFRKahhzsSnRzU7WsPPEBuTepdHyh3u8lIABZPfpDxiqL96Cj0r27Sq6R/T6VCwqjJU4FYXckdM+3volkhbFq/44oxycqLd7oWhN7JjN3sYPoK9pMk+X6IWiru05s/ThTyzi1bihEv6dCvLpw9S2erQiLm48+U58Vrn/98K2ihdbtHX7P6DWBHDTMv6YL8YXqylecPh1FAeKTuk06WhYWM18XAKSudkQSQPq5gQH9h3a7hvXnEX4HIggJXOMvgxIyCFZBvMcjEq4Hkt967Wu7HhxKR03HWjrWSKXc3Be3KdFHxCylcLEtDACG0wooxbaAbHFNzDAmZX8HHsn0AJ0Q1pjjdzD7gfWJ5hfE83C0ctr8Wecm57SJq2PWIbODe5f2Goic0Zq6RbIdFT27nuHYxHa+OX73nXjJ4SzpPciJ4bsseUJlIsPUL/67wjeYKBhWKQhbB3sasNESe6J8F6qafb5rPiGi7aVe4M6i2DBEchR1vqVAfJJvowBBXGIU3L6Zypd4Qyufeb/UO8a56vQT0HmRQW8hOn916+bfxzFQqZ5T8+6guw6B7SV0ILdsp5dHOVa2E6xWRfIkSe2k/Z5J/UOIHwYvUZL03lDRDdxzrRM3hgBIBXYDraOlTepzQ0DKGhHfpguBDm34KFNRdERF/OYZwKxll676zUJXcs1PvbWEXr8IL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 09:24:39PM -0500, Bjorn Andersson wrote:
> On Wed, Mar 11, 2026 at 01:45:44AM +0530, Mukesh Ojha wrote:
> > First of all, I want to thank Eugene for his excellent work on this
> > series. What began as the Qualcomm Minidump driver from me has now
> > evolved into meminspect. He also presented meminspect a few months ago
> > at Linux Plumbers 2025.
> > 
> > Video of the recording is available here for anyone interested:
> > https://www.youtube.com/watch?v=aDZv4-kOLSc
> > 
> > Introduction:
> > 
> > meminspect is a mechanism which allows the kernel to mark specific
> > memory areas for memory dumping or specific inspection, statistics,
> > usage.  Once regions are marked, meminspect keeps an internal list with
> > the regions in a dedicated table.  Further, these regions can be
> > accessed using specific API by any interested driver.  Regions being
> > marked beforehand, when the system is up and running, there is no need
> > nor dependency on a panic handler, or a working kernel that can dump the
> > debug information.  meminspect can be primarily used for debugging. The
> > approach is feasible to work when pstore, kdump, or another mechanism do
> > not.  Pstore relies on persistent storage, a dedicated RAM area or
> > flash, which has the disadvantage of having the memory reserved all the
> > time, or another specific non volatile memory. Some devices cannot keep
> > the RAM contents on reboot so ramoops does not work. Some devices do not
> > allow kexec to run another kernel to debug the crashed one.  For such
> > devices, that have another mechanism to help debugging, like firmware,
> > kmemdump is a viable solution.
> > 
> > meminspect can create a core image, similar with /proc/vmcore, with only
> > the registered regions included. This can be loaded into crash tool/gdb
> > and analyzed. This happens if CRASH_DUMP=y.  To have this working,
> > specific information from the kernel is registered, and this is done at
> > meminspect init time, no need for the meminspect users to do anything.
> > 
> > This version of the meminspect patch series includes two drivers that
> > make use of it: one is the Qualcomm Minidump, and the other one is the
> > Debug Kinfo backend for Android devices, reworked from this source here:
> > https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/android/debug_kinfo.c
> > written originally by Jone Chou <jonechou@google.com>
> > 
> > *** History, motivation and available online resources ***
> > 
> > The patch series is based on both minidump and kmemdump previous implementations.
> > 
> > After the three RFC kmemdump versions, considering the ML discussions, it was decided to
> > move this into kernel/ directory and rework it into naming it meminspect, as Thomas Gleixner
> > suggested.
> > 
> > Initial version of kmemdump and discussion is available here:
> > https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
> > 
> > Kmemdump has been presented and discussed at Linaro Connect 2025,
> > including motivation, scope, usability and feasability.
> > Video of the recording is available here for anyone interested:
> > https://www.youtube.com/watch?v=r4gII7MX9zQ&list=PLKZSArYQptsODycGiE0XZdVovzAwYNwtK&index=14
> > 
> > Linaro blog on kmemdump can be found here:
> > https://www.linaro.org/blog/introduction-to-kmemdump/
> > 
> > Linaro blog on kmemdump step by stem using minidump backend is available here:
> > https://www.linaro.org/blog/kmemdump-step-by-step-on-qualcomm-automotive-platform/
> > 
> > The implementation is based on the initial Pstore/directly mapped zones
> > published as an RFC here:
> > https://lore.kernel.org/all/20250217101706.2104498-1-eugen.hristev@linaro.org/
> > 
> > The back-end implementation for qcom_minidump is based on the minidump
> > patch series and driver written by Mukesh Ojha, thanks:
> > https://lore.kernel.org/lkml/20240131110837.14218-1-quic_mojha@quicinc.com/
> > 
> > The RFC v2 version with .section creation and macro annotation kmemdump
> > is available here:
> > https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
> > 
> > The RFC v3 version with making everything static, which was pretty much rejected due to
> > all reasons discussed on the public ML:
> > https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
> > 
> > *** How to use meminspect with minidump backend on Qualcomm platform guide ***
> > 
> > Prerequisites:
> > Crash tool compiled with target=ARM64 and minor changes required for
> > usual crash mode (minimal mode works without the patch) **A patch can be
> > applied from here https://p.calebs.dev/1687bc ** This patch will be
> > eventually sent in a reworked way to crash tool.
> > 
> 
> That patch was written 8 months ago, what's the timeline for landing
> this?
> 
> It's not feasible to have every users rebuild crash from source and
> maintain this copy in order to use the tool.

Right, Let me see what I can do to make it acceptable..

> 
> > Target kernel must be built with : CONFIG_DEBUG_INFO_REDUCED=n ; this
> > will have vmlinux include all the debugging information needed for crash
> > tool.
> > 
> > Also, the kernel requires these as well: CONFIG_MEMINSPECT,
> > CONFIG_CRASH_DUMP and the driver CONFIG_QCOM_MINIDUMP
> > 
> > Kernel arguments: Kernel firmware must be set to mode 'mini' by kernel
> > module parameter like this : qcom_scm.download_mode=mini
> > 
> > After the kernel boots, and minidump module is loaded, everything is
> > ready for a possible crash.
> > 
> > Once the crash happens, the firmware will kick in and you will see on
> > the console the message saying Sahara init, etc, that the firmware is
> > waiting in download mode. (this is subject to firmware supporting this
> > mode, I am using sa8775p-ride board)
> > 
> > Example of log on the console:
> > "
> > [...]
> > B -   1096414 - usb: init start
> > B -   1100287 - usb: qusb_dci_platform , 0x19
> > B -   1105686 - usb: usb3phy: PRIM success: lane_A , 0x60
> > B -   1107455 - usb: usb2phy: PRIM success , 0x4
> > B -   1112670 - usb: dci, chgr_type_det_err
> > B -   1117154 - usb: ID:0x260, value: 0x4
> > B -   1121942 - usb: ID:0x108, value: 0x1d90
> > B -   1124992 - usb: timer_start , 0x4c4b40
> > B -   1129140 - usb: vbus_det_pm_unavail
> > B -   1133136 - usb: ID:0x252, value: 0x4
> > B -   1148874 - usb: SUPER , 0x900e
> > B -   1275510 - usb: SUPER , 0x900e
> > B -   1388970 - usb: ID:0x20d, value: 0x0
> > B -   1411113 - usb: ENUM success
> > B -   1411113 - Sahara Init
> > B -   1414285 - Sahara Open
> > "
> 
> This doesn't add any specific value, it's just "Device entered ramdump
> mode".

Sure, will remove it.

> 
> > 
> > Once the board is in download mode, you can use the qdl tool (I
> > personally use edl , have not tried qdl yet)
> 
> Is this your or Eugen's comment? Why haven't you tested qdl yet?

It was Eugene's comment, but I get it, I can try QDL and check, if it
works.

> 
> >, to get all the regions as
> > separate files.  The tool from the host computer will list the regions
> > in the order they were downloaded.
> > 
> > Once you have all the files simply use `cat` to put them all together,
> > in the order of the indexes.  For my kernel config and setup, here is my
> > cat command : (you can use a script or something, I haven't done that so
> > far):
> 
> So these need to be sorted in numerical order, by that number at the end
> of the file name?
> 
> Do you manually punch these in? How do we make this user friendly?

Yes, manually.. but I think we can do better. We could make
this more user‑friendly by using the section header and string table in
the md_KELF binary both of which existed in the earlier implementation.
Then, we can write an upstream‑friendly script that reads this KELF
metadata file, checks whether a binary with the registered name is
present, and stitches everything together to form a complete ELF that
the crash tool can consume.  Let me know if you have any suggestion..

> 
> Regards,
> Bjorn
> 
> > 
> > `cat md_KELF1.BIN md_Kvmcorein2.BIN md_Kconfig3.BIN \
> > md_Ktotalram4.BIN md_Kcpu_poss5.BIN md_Kcpu_pres6.BIN \
> > md_Kcpu_onli7.BIN md_Kcpu_acti8.BIN md_Kmem_sect9.BIN \
> > md_Kjiffies10.BIN md_Klinux_ba11.BIN md_Knr_threa12.BIN \
> > md_Knr_irqs13.BIN md_Ktainted_14.BIN md_Ktaint_fl15.BIN \
> > md_Knode_sta16.BIN md_K__per_cp17.BIN md_Knr_swapf18.BIN \
> > md_Kinit_uts19.BIN md_Kprintk_r20.BIN md_Kprintk_r21.BIN \
> > md_Kprb22.BIN md_Kprb_desc23.BIN md_Kprb_info24.BIN \
> > md_Kprb_data25.BIN  md_Khigh_mem26.BIN md_Kinit_mm27.BIN \
> > md_Kunknown29.BIN md_Kunknown30.BIN md_Kunknown31.BIN \
> > md_Kunknown32.BIN md_Kunknown33.BIN md_Kunknown34.BIN \
> > md_Kunknown35.BIN md_Kunknown37.BIN \
> > md_Kunknown38.BIN md_Kunknown39.BIN md_Kunknown40.BIN \
> > md_Kunknown41.BIN md_Kunknown42.BIN md_Kunknown43.BIN \
> > md_Kunknown44.BIN md_Kunknown45.BIN  md_Kunknown46.BIN \
> > md_Kunknown47.BIN md_Kunknown48.BIN md_Kunknown49.BIN \
> > md_Kunknown50.BIN md_Kunknown51.BIN md_Kunknown52.BIN \
> > md_Kunknown53.BIN md_Kunknown54.BIN   > ./minidump_image`
> > 
> > Once you have the resulted file, use `crash` tool to load it, like this:
> > `./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image`
> > 
> > There is also a --minimal mode for ./crash that would work without any patch applied
> > to crash tool, but you can't inspect symbols, etc.
> > 
> > Once you load crash you will see something like this :
> >       KERNEL: minidump/20260310-235110/vmlinux  [TAINTED]
> >     DUMPFILE: ./minidump/20260310-235110/minidump_image
> >         CPUS: 8 [OFFLINE: 7]
> >         DATE: Thu Jan  1 05:30:00 +0530 1970
> >       UPTIME: 00:00:27
> >        TASKS: 0
> >     NODENAME: qemuarm64
> >      RELEASE: 7.0.0-rc3-next-20260309-00028-g528b3c656121
> >      VERSION: #5 SMP PREEMPT Tue Mar 10 18:18:41 UTC 2026
> >      MACHINE: aarch64  (unknown Mhz)
> >       MEMORY: 0
> >        PANIC: "Kernel panic - not syncing: sysrq triggered crash"
> > 
> > crash> log
> > [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x514f0014]
> > [    0.000000] Linux version 7.0.0-rc3-next-20260309-00028-g528b3c656121 (@21e3bca4168f) (aarch64-linux-gnu-gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, GNU ld (GNU Binutils for Ubuntu) 2.42) #5 SMP PREEMPT Tue Mar 10 18:18:41 UTC 2026
> > 
> > *** Debug Kinfo backend driver ***
> > I need help with the testing of this driver, Anyone who actually wants
> > to test this, feel free to reply to the patch. we have also written a
> > simple DT binding for the driver.
> > 
> > Thanks in advance for the review, and apologies if I missed addressing any comment.
> > 
> > -Mukesh 
> > 
> > Changes in v2: https://lore.kernel.org/lkml/20251119154427.1033475-1-eugen.hristev@linaro.org/
> >  - Fixed doc warnings
> >  - Fixed kernel-test robot warnings.
> >  - Took Mike suggestion to remove mark inspect flag for dynamic memory.
> >  - Added R-b for printk patch.
> >  - Modified some commit messages for clarity.
> >  - corrected binding change for debug-kinfo as per Rob suggestion.
> > 
> > Changelog for meminspect v1:
> > - rename to meminspect
> > - start on top of v2 actually, with the section and all.
> > - remove the backend thing, change the API to access the table
> > - move everything to kernel/
> > - add dependency to CRASH_DUMP instead of a separate knob
> > - move the minidump driver to soc/qcom
> > - integrate the meminspect better into memblock by using a new memblock flag
> > - minor fixes : use dev_err_probe everywhere, rearrange variable declarations,
> > remove some useless code, etc.
> > 
> > Changelog for RFC v3:
> > - V2 available here : https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
> > - Removed the .section as requested by David Hildenbrand.
> > - Moved all kmemdump registration(when possible) to vmcoreinfo.
> > - Because of this, some of the variables that I was registering had to be non-static
> > so I had to modify this as per David Hildenbrand suggestion.
> > - Fixed minor things in the Kinfo driver: one field was broken, fixed some
> > compiler warnings, fixed the copyright and remove some useless includes.
> > - Moved the whole kmemdump from drivers/debug into mm/ and Kconfigs into mm/Kconfig.debug
> > and it's now available in kernel hacking, as per Randy Dunlap review
> > - Reworked some of the Documentation as per review from Jon Corbet
> > 
> > Changelog for RFC v2:
> > - V1 available here: https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
> > - Reworked the whole minidump implementation based on suggestions from Thomas Gleixner.
> > This means new API, macros, new way to store the regions inside kmemdump
> > (ditched the IDR, moved to static allocation, have a static default backend, etc)
> > - Reworked qcom_minidump driver based on review from Bjorn Andersson
> > - Reworked printk log buffer registration based on review from Petr Mladek
> > 
> > I appologize if I missed any review comments.
> > Patches are sent on top on next-20260309 tag
> > 
> > ---
> > Eugen Hristev (21):
> >       kernel: Introduce meminspect
> >       init/version: Annotate static information into meminspect
> >       mm/percpu: Annotate static information into meminspect
> >       cpu: Annotate static information into meminspect
> >       genirq/irqdesc: Annotate static information into meminspect
> >       timers: Annotate static information into meminspect
> >       kernel/fork: Annotate static information into meminspect
> >       mm/page_alloc: Annotate static information into meminspect
> >       mm/show_mem: Annotate static information into meminspect
> >       mm/swapfile: Annotate static information into meminspect
> >       kernel/vmcore_info: Register dynamic information into meminspect
> >       kernel/configs: Register dynamic information into meminspect
> >       mm/init-mm: Annotate static information into meminspect
> >       panic: Annotate static information into meminspect
> >       kallsyms: Annotate static information into meminspect
> >       mm/mm_init: Annotate static information into meminspect
> >       sched/core: Annotate runqueues into meminspect
> >       remoteproc: qcom: Move minidump data structures into its own header
> >       soc: qcom: Add minidump backend driver
> >       soc: qcom: smem: Add minidump platform device
> >       meminspect: Add debug kinfo compatible driver
> > 
> > Mukesh Ojha (4):
> >       mm/numa: Register node data information into meminspect
> >       mm/sparse: Register information into meminspect
> >       printk: Register information into meminspect
> >       dt-bindings: reserved-memory: Add Google Kinfo Pixel reserved memory
> > 
> >  Documentation/dev-tools/index.rst                  |   1 +
> >  Documentation/dev-tools/meminspect.rst             | 144 +++++++
> >  .../bindings/reserved-memory/google,kinfo.yaml     |  46 ++
> >  MAINTAINERS                                        |  14 +
> >  drivers/of/platform.c                              |   1 +
> >  drivers/remoteproc/qcom_common.c                   |  56 +--
> >  drivers/soc/qcom/Kconfig                           |  13 +
> >  drivers/soc/qcom/Makefile                          |   1 +
> >  drivers/soc/qcom/minidump.c                        | 272 ++++++++++++
> >  drivers/soc/qcom/smem.c                            |  10 +
> >  include/asm-generic/vmlinux.lds.h                  |  13 +
> >  include/linux/meminspect.h                         | 263 ++++++++++++
> >  include/linux/soc/qcom/minidump.h                  |  72 ++++
> >  init/Kconfig                                       |   1 +
> >  init/version-timestamp.c                           |   3 +
> >  init/version.c                                     |   3 +
> >  kernel/Makefile                                    |   1 +
> >  kernel/configs.c                                   |   6 +
> >  kernel/cpu.c                                       |   5 +
> >  kernel/fork.c                                      |   3 +
> >  kernel/irq/irqdesc.c                               |   2 +
> >  kernel/kallsyms.c                                  |   9 +
> >  kernel/meminspect/Kconfig                          |  30 ++
> >  kernel/meminspect/Makefile                         |   4 +
> >  kernel/meminspect/kinfo.c                          | 284 +++++++++++++
> >  kernel/meminspect/meminspect.c                     | 471 +++++++++++++++++++++
> >  kernel/panic.c                                     |   4 +
> >  kernel/printk/printk.c                             |  11 +
> >  kernel/sched/core.c                                |   2 +
> >  kernel/time/timer.c                                |   2 +
> >  kernel/vmcore_info.c                               |   4 +
> >  mm/init-mm.c                                       |  11 +
> >  mm/mm_init.c                                       |   2 +
> >  mm/numa.c                                          |   2 +
> >  mm/page_alloc.c                                    |   2 +
> >  mm/percpu.c                                        |   2 +
> >  mm/show_mem.c                                      |   2 +
> >  mm/sparse.c                                        |   6 +
> >  mm/swapfile.c                                      |   2 +
> >  39 files changed, 1725 insertions(+), 55 deletions(-)
> > ---
> > base-commit: 343f51842f4ed7143872f3aa116a214a5619a4b9
> > change-id: 20260311-minidump-v2-eed8da647ce5
> > 
> > Best regards,
> > -- 
> > -Mukesh Ojha
> > 

-- 
-Mukesh Ojha

