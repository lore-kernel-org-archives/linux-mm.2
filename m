Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BEDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 19:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFCB96B0088; Wed,  8 Jul 2026 15:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD2E6B008A; Wed,  8 Jul 2026 15:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74D96B008C; Wed,  8 Jul 2026 15:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8624A6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:06:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 118D71C68D0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:06:00 +0000 (UTC)
X-FDA: 84966539280.26.DF1D7B1
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F469140012
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:05:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="C/Z3O8TS";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=DPDAiqNq;
	spf=pass (imf26.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783537557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CeHf8ZnOmdDt8+90mSP4wYI2u2NYKjn3Be4iJ272f5Q=;
	b=n2BjBFqObWZpyId6z0d8fxvhZJ0wRg9tMzAr2rQvJ9JQjv+o4oQMxNWUcAye7Urh5ekDXo
	yvC0iXB1bzfsCe84pGl9GowaO831FKH/Kjbn7PhRIU0/joeplShta8QNX/KC2tuKIcifkk
	qE8iSnKUN72wgeZaS8LbSNggBD1Y3NQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="C/Z3O8TS";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=DPDAiqNq;
	spf=pass (imf26.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783537557;
	b=hBE6bGX/XTPrc3/8T4VrYVHkNJLANk0NWbWFXfsYGBmVrcDbeL7Svq0DyGNDrFUEN+Hbwo
	qkGNH8rG7JlJCTwoS8U6oqeosTASf/agLlAcSgokMn8K3VcqzTYt64wIhf6T868xg2Mxwe
	6aIxdDjBwi07OqLvxfmhRIP+LAUMYrM=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668GLCO73256486
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 19:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=CeHf8ZnOmdDt8+90mSP4wYI2
	u2NYKjn3Be4iJ272f5Q=; b=C/Z3O8TSU/K6ST7I/5NLvaXUbyaBPKdv0+DgP40l
	nQUMyIiRO9eb0HkYDoQACetPWHg33l4B4SndJBK78czyFY2O72YHuNe0IwlvvEDO
	e3Y5cvI4c3FPt59an/wepDFFpz+Z03T8w+4iB0iNKikofEJk+NSkHJqWjAuBGuDu
	AtCF25xZE9fajt5L8vuDM1kN1dXUr3yeqChMyf4fl6dNiYLugaM5q29YztM8AH9s
	XpjSoOZW0vNUVP2e+nShpv9KxBXbZv+Ku+p0c6/+UfEDrWTF5ZEDyfUzfYbgBzid
	ORzfs/9zn+9EvdTrpupSEOicov9omFUig51PTAzYEyTiVA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9sqw8qw4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 19:05:56 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so1507349a91.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 12:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783537555; x=1784142355; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CeHf8ZnOmdDt8+90mSP4wYI2u2NYKjn3Be4iJ272f5Q=;
        b=DPDAiqNq2xGNskAIQDB+UfoEL9+4jf6KIVw7NVCR5yBwU7s98RbKdzggM4Mht25n/z
         d0n0Do5tS3yxpB4TJPzqAeFEptZ0HeYb4IG4rfeZ53lmI/IFo9UkBi4frKoDydMaG6Dl
         xzR1PsvDVEG+5hNAo+e3o8RrhvJXKqtvVLDBHY6dyYBtIlba1v1VwpoNjC9AVO0Rnzq6
         cmm1ulTCOZiJsxAil+9Z5f0ZpYmTjUNBNeEFz2MgcliXBP253pu9b0ShXEuBXAjQ7VUJ
         DDAAdNuRcvuw1pPFppNM9o7vrIe3PAO0c0l7OjgZR9r3ozB5IRvjVD2HyokJZ3rfRg9z
         H7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783537555; x=1784142355;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CeHf8ZnOmdDt8+90mSP4wYI2u2NYKjn3Be4iJ272f5Q=;
        b=VowRWhfgJpCAbhfY6MSzotZ+C1kOHvcIp4mprgJi1ZDhOiBWl1fCx/X9OUOvZ1OhT+
         Izb+SD8FA8r5GOx4wMz9ABQtKahhkOchxD1AiXjEH3/0qtVhjqpGFxJFuJ7V8AmaGA3x
         Lxp2f0Uv5LSHXRJAH24ocOjTTPxTFJKHDzPXcKbqCMrH6SeX0+GwvrDYv0c3iynDKp6U
         R3r7q/1i9IKgglduPimLW3IWtkyrT3B4YNPuKhaMNWcUjMBedrvjEa5dUdf3DoEfqJng
         5ANV+Sb5RNMDI+DI9gxpp3XO/oJ2xDcPM77kDCH2qI/Kbesqa7W6OqSQOtuJk+ISejE9
         dTnQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp4ok4he5H2PalbAi9AiMLZCixq8ao0hhUmbadlnL3zmVnNtLQOyRf2l2MFFNggBxw7mC5nsQO16A==@kvack.org
X-Gm-Message-State: AOJu0YzCzfnpn3Er0UMbgZE59kZkS6fr29rU4AO9milN3UoP2XjLPVf0
	S97N3oMddkNVp0mkL+zivR9iLfDj87FBpOznItkCQ/YgXHMbtUpQBTapSv/L3SBdoj+fh4PMHpW
	3Xwl57nMMG99ztkl7xPUoI87s8QHtyfjwSyDhpwWkmOUkkXhS2ZypYw==
X-Gm-Gg: AfdE7cmTxxiSPsUlPU0B43y+siDd+9BEo4oaZo0jgJQiXZKkVQjvxcplBcj6T/eSj+y
	3985Ko2JRkJfxTsIKfrQfFeh1HGJMz5XiNgdWgcM4GOQaCSgg/Y/Et4pZJvcR9+f8o5WMBg2hjN
	pZrvPT4aLpGoIMQu+WvhzAUm6DEhJfBPLovGnACc0d16ugEzJnXVSZAsxTUsSWv3fqrMFzMaFdH
	7Q488Ia+XEd85kO0cnfUcqelFDBaVSTsXD0S7UQWotxVRoen6Okt8mcKFBuOnZ4P0L1NQRax7/T
	W91PIRIsEU+rbkv6GXw4Gc0P/n6MOPuw/Lf3xyM72IRKZLD+Gbr8Pt+y8ChAnyyKJN9WQk7GgSA
	wLd7CgXjX77sZLlx2HzQHcj24RRXf/UNMAGZktw==
X-Received: by 2002:a17:90b:4d8d:b0:37f:db06:229c with SMTP id 98e67ed59e1d1-38942f7105cmr3621954a91.22.1783537555367;
        Wed, 08 Jul 2026 12:05:55 -0700 (PDT)
X-Received: by 2002:a17:90b:4d8d:b0:37f:db06:229c with SMTP id 98e67ed59e1d1-38942f7105cmr3621916a91.22.1783537554731;
        Wed, 08 Jul 2026 12:05:54 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174ae6cd9sm24772373eec.31.2026.07.08.12.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 12:05:54 -0700 (PDT)
Date: Thu, 9 Jul 2026 00:35:35 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <ehristev@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>,
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
        David Hildenbrand <david@kernel.org>,
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
        Saravana Kannan <saravanak@kernel.org>, workflows@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 11/26] mm/swapfile: Annotate static information into
 meminspect
Message-ID: <20260708190535.fhqaddicljho44eq@hu-mojha-hyd.qualcomm.com>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-11-7aa5a0a74d5c@oss.qualcomm.com>
 <ak4AgXqMnkn8rVGE@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak4AgXqMnkn8rVGE@lucifer>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDE4NyBTYWx0ZWRfX6kC+xFAOCn/W
 ZWk/BPesgqzIDecUFa/E71c6ZZIq2nKQ0dWDGDZWcfhQ7dF+pm7q8lgwNnaxWOWnhRkUEkm5wuz
 bYgSijx6l9SeJCohbDDRJENrEfYbU/tx00RAj6zTR6uE5QvhX4joV6jVhY5GItri35AI7EL0cmr
 ERdLxBXFqbS6WO9nMyd+8l32E0sBiYTzBa3n1cFIt4FuwtCO2FJNnu9+s6Rw4DXJq8GjHGFhBr4
 DRL0gEZDU3ybbm30FrHcIDEP8TYe0qdxLAkpTL1GIHagBTH6hQnhisJaqrmGlLqCFUaxuB+N7hp
 DqhhG0V6LCMSk51oQvyIryz2DnGtPS5fee4UU8WgS1CkiSvtzcG9UaAsYRQWDxEtvyHc4H77ezK
 hlBolx0HOWzhoEuf8wyy3jSdbV28kkGVRtCModd7wRepY6ndHJKcIi1wyKV/oFZxarG4mizHkRg
 ZxSayaYjDkEuAkh2dkQ==
X-Proofpoint-GUID: QxlSS0tY5n6D6wEBrkaWyWCkntOG-aqW
X-Authority-Analysis: v=2.4 cv=fMIJG5ae c=1 sm=1 tr=0 ts=6a4e9f94 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=cq8IU3OeMPPiwu34qS0A:9
 a=CjuIK1q_8ugA:10 a=rl5im9kqc5Lf4LNbBjHf:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: QxlSS0tY5n6D6wEBrkaWyWCkntOG-aqW
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDE4NyBTYWx0ZWRfX1e0bSdFJPz5E
 s2DEyoJ2PpyoiLjK1ThRxC4aoIb6yLfoAnXHfBHeMJaCUIXMu688uWED2/zp1aHmKmTnFtAASJb
 ae4e2YvQq4/zrhYW963UAHP1OEPi5pA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-08_03,2026-07-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607080187
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F469140012
X-Stat-Signature: 9dx7yk5xttntz6q3teb6zup7mtmhofxj
X-HE-Tag: 1783537557-199037
X-HE-Meta: U2FsdGVkX1+rds0fXzVe50g3zpzHPMBrYJZchsn54zFEsbza5yn4yN3cw6mfMN/lh9wJh4o48uXBjSkuDYvC4mbRmKzinBvxELgH52awWbQRKD/B2hxjaQaOx+1WTEZLYUeW19VqWN5y0maga/bAPQZPFrbIr64TPGbGZnI4gMHTZikljIUwl5p/FGyt2dMUbWzYhZ3mlip7siNf+vm0q6ok6pAQimfXDDVEECzKBTpWH94DaMa+yT3Bdby3IWwNWXJUGmuSpcHVUpeZmdTdRsVuOSA9ILjZMrWUrIFEj7O9sPxQ7yuOcMPAilBO0x49h4N4d0nVMFM/n0cywsd/THybw5rjku3m1oK8EqG6RCumCX87Apj303R58gTLCVrD3VidchfjF4Rst99YOEHe0vTjy3e/lBHNxMFsKs43VlVYDDfIy58d2G1l5sNuTTE2ylRHAlhrd2GKG+WJl/K7lalzYYc/ony2++kqRtO+Q+7sBGhNFG6JiLzz9IEzNHb463wlLjR8XbQXHbzWkFjRez1Qi9oUdTXYO511XMD+QIHtXx9GXZOlPzrKF0kRRwPG4Jqo5iEW1ngTQ8JyZgI3yx2xWSCf3rkkxwXN9PB5g3oNLmYUVOkWKtJJR8yIuhjKSzPJn+8Ju9+kDxDKiECxcg9FXoQBoFt8Q3J5FCMyQASM5pNy88W2nS0tu4bwaUHgcfGabFGR/gg6oqqH9v2Jz8acZRE24leM95tzjprSUIfvv6+2hlFBnxMmainpcADI1U7v+2dXG12qUgaSM8mC7fbwWaTSks0XqVfMG1oln+gmgJ9o37ABcXtI3Og0cdlaUbKWJRyAxBXsXIlPb106lJRdAa21ARk46VrffLXOtBvRStyfrk/7faSWxfRm3ymU/vDLg7rEbBWJnL+hgV+uGhixKjdp3Q8BjRXbSzeiOkYcoSBTNU9zIjdlJM/2UzUU7fM5E2dyBBWaU20BkSA
 RfsHsF+E
 U6B8jGr1U0eufgG3LyQFUAyx11bMbvjUfnKi/UgFjM3DtuG4aNHtwrAh43kVs0X10UleDcCW5S/4b1p1W/TnXkliQ7TQhlnwo1dR1wv0E2/j9sJibTS1p3uOMsQsl9d+pzG0g5+obpI3CGssPiWQN13FERpu5h/JYlycHeGXfEy6oiVF8y4/rDOJUaVJ9ghJY5ZoTooiYqFy5fRwN7VaOPOR10Q0T3pJ6EnNE5RiaufubsA0qV9KEtLbyFD9CSsk14mXTpGR54QzjCh7yoYn35IFHoGKRNKFB6RrnEdsmMczJ3HOvD7B/cI2EYFfqvQ3qLieHqMA5L5iRSuJIL46GvWmjnBYkC/dg6xywhG6TTp4KjfP1C6dr6s5OUJ6wSlXOgC+notTS7J0sh+1VdZ5n2xfQuVg/DA6F8xcLZVjZRFNl5MCM+P0X0ssG0xg6sXSJBD4OIC0lTn2A/Vjlaap9/U/IQKi0Xv+eYFxPAgUZS2g8maS18VctH/f/GNZmO0l11HuJCMnuqH4qaBK9wk6udcKEA7YNwafPc0Az3Iy8ugBWU9PVJ9OWG0+vT/Os+BZuZrbVkJSX+vsGyZ8cL+W9IAiAZ/BTZ+HO/HP7aIlfjCjFi8hR825ypgu5edVMwhxlFGUrD5sqLf35mSPgp7hdLbUPL1QNV0bdmU3X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 08:47:51AM +0100, Lorenzo Stoakes wrote:
> On Wed, Jul 08, 2026 at 11:01:50AM +0530, Mukesh Ojha wrote:
> > From: Eugen Hristev <ehristev@kernel.org>
> >
> > Annotate vital static information into inspection table:
> >  - nr_swapfiles
> >
> > Information on these variables is stored in a dedicated meminspect
> > section.
> >
> > Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> > Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> > ---
> >  mm/swapfile.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index a602e5820513..d480727e4987 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -42,6 +42,7 @@
> >  #include <linux/suspend.h>
> >  #include <linux/zswap.h>
> >  #include <linux/plist.h>
> > +#include <linux/meminspect.h>
> >
> >  #include <asm/tlbflush.h>
> >  #include <linux/leafops.h>
> > @@ -65,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
> >   */
> >  static DEFINE_SPINLOCK(swap_lock);
> >  static unsigned int nr_swapfiles;
> > +MEMINSPECT_SIMPLE_ENTRY(nr_swapfiles);
> 
> Now the EXPORT_SYMBOL_GPL() is an EXPORT_SYMBOL() in effect no?

The whole reason we had to tag most of the MM symbols is that
the crash tool looks for this information while launching itself.

e.g.,

./crash --no_modules --no_panic --no_kmem_cache --zero_excluded ./vmlinux  ./minidump.elf


> 
> >  atomic_long_t nr_swap_pages;
> >  /*
> >   * Some modules use swappable objects and may try to swap them out under
> >
> > --
> > 2.53.0
> >

-- 
-Mukesh Ojha

