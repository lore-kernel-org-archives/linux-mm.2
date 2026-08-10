Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1097C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057D86B0099; Mon, 10 Aug 2026 08:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007FC6B009B; Mon, 10 Aug 2026 08:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E397C6B009D; Mon, 10 Aug 2026 08:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C068D6B0099
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:58:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53574160161
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:58:59 +0000 (UTC)
X-FDA: 85085364798.15.23AA58E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF32340004
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:58:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Gzz3kVOr;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786366737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSiblIiYTIEmqanmh2YkYImArEcTnczokd31LNN7kYY=;
	b=feWr8YtxBZQjOaGq+E4cGZAntOcvBXvYxKVTUbQ2Cw3ShPStEiubccyz/eJV+uvM0Q7Arj
	lw8/fbXPz+kjmhwPySdCpI+6vYnH6uT1nX/EQAi0RgosVHLa8ChohHujYwG8YOJOyfLaPu
	1GDSCN0ln3eEktpVPtZG/At3bgQR+eA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Gzz3kVOr;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786366737;
	b=p0WRvbUoWUFgxcPp9Jp/tTwxAMR+DDbo7zAcS5wT+rzvSROJC4VP8OpQbmldCMgus9sobI
	iCPsbcoyZlFJEJn6AXQyfPJ9D2Up/GpY6XF5kw/fXn7qUkApDmjamDG3FNY9dRmtJ16EkX
	Tb+Pod8SkYXgB59Tpzdqm+qS9EXXr70=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67A9VesW156779;
	Mon, 10 Aug 2026 12:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=dSiblIiYTIEmqanmh2YkYImArEcTnc
	zokd31LNN7kYY=; b=Gzz3kVOrvWCVRzZkdQEYdPzIdPMzqy4qsVDzew2xBktM85
	GE8iepSqJ+ovQBywfgeyr04ta//fK7T7YrA/4X7WnIy+3TQxLZr4GGszy9akGjfW
	eQSFSKcbNUKv5W9QRgx4L4V3tVG4B9QIcgh3zv7az/m3Xq2zdXKwxvoW9To9wcbZ
	AP8JS86gyANYkvPQkdA+C3KLmn0XumA4XyMh3cFBsIv4UthRJa12UagfR/ALa2xr
	4sglh+x/gFAGaZ3IUmXbDOXOf+PQiNhdqowh81WSym4VBwiUNNsGupcfCwpQBxy4
	AKKjSVISEInI+ZhhaRPfC7PYfHFcl+IG3dbFN94w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb23h04p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Aug 2026 12:58:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67ACuhGB009990;
	Mon, 10 Aug 2026 12:58:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxhfxvkg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Aug 2026 12:58:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67ACwjlG41419190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Aug 2026 12:58:45 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E034D20043;
	Mon, 10 Aug 2026 12:58:44 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 980EC20040;
	Mon, 10 Aug 2026 12:58:44 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 10 Aug 2026 12:58:44 +0000 (GMT)
Date: Mon, 10 Aug 2026 14:58:43 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org,
        dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev,
        liam@infradead.org, mhocko@suse.com, rppt@kernel.org,
        ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
        usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
        usama.anjum@arm.com, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kas@kernel.org
Subject: Re: [PATCH v2 00/17] selftests/mm: improve khugepaged coverage
Message-ID: <f9e0fe38-47de-4577-b638-1142d4ffbe6c-agordeev@linux.ibm.com>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a79cb08 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=Hq8G7kb28POlo2kKp_sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEwNyBTYWx0ZWRfX3SMiRUWGUIYF
 RNyU+VCVbf1wMhedsG6ts0uBTyN1XnDiaAMXFz2VWe44OSsqpXaI+Bmri74bCkxf9i6g4KZxvxN
 /Co9yK844fmCV0bN7XfPlcnAal5YKqAIyo0BuVqHBElKQl2F1lq0tvPHVACmi5MQD1z6v4gswvr
 KJyzmHMQigwl1HNGYwLRBjY2qmkLZ4wYIVc0/HNhjFo5CePLHDNqmIw7jQN89Ejx7TJlVQFCYiW
 mO9p2mrLmRXcHHELV2wNYdvOxQew/qiX/26CDPMaWdhG4PtSMYf2QM6FmjWs7vogcT+dF7qMp+8
 qC9nTXyoAjpU9z4RRqVoCFf5FHAfjMFozcBsa2nBVr2jryzcazoqmW4otD78hY6vnJdS7MtKl/b
 AFyD+iDMFbP8mBUTZnrSrtjyDNPrX0rAr6Wao2a3DbZOGWgsifZLv/nFtazcuPYgUi6MHdDsG4H
 XX45j6Tb9iaFm2M+L/A==
X-Proofpoint-ORIG-GUID: ANPpCN1PvFh-XlYVrdF7tqcS3P4jSn4Q
X-Proofpoint-GUID: MSLDefExe5nYuA80fEPFcTJzJ6JhaPnE
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEwNyBTYWx0ZWRfXxRcTmIoc+1PV
 t/cLDMYLbX9lYLzgKBJM7tHD3tS4NKxxH1mJtsg8jTvBc3VjZYTwBrNQAsrt2ZWqOiFfLZlllQ0
 QMotxG/f3ULO8iSWDN6D2TkD6oGk+Ro=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_02,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1011
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100107
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF32340004
X-Stat-Signature: onbiak7t36i7p5qx5yxm9erxdma8c4gx
X-Rspam-User: 
X-HE-Tag: 1786366736-105053
X-HE-Meta: U2FsdGVkX18SO8rsHfFlr8kv3H3wnL8fqRXH7+T383GfAJR2alrVmiJq/gZ+8huceWvYwr9SDMcHYoApvpsO55HIkehAj3Pkflab/9w+4VydQsEO4HeLnabxwwVvroiy9EDzfOIXu1pF92UUJDWE8B1DsexhsRTdg4FJ6BRseCYfWvqbjC7kRiWUe+GKcem9WhdpWAHwvrUneiAo8lbTzqzDEfHu+sDhRgvGUCYtVgSwv40jhaqw6hHNMpXQmrIauGOGcXzq1Hx8tFrGce2MzfahGcTFnO6YS/BBH02K2yldxALLf3WrX+rY9ljWn/hmlIaMQ1Uu0kRpiSD4ZBaka0KY8pFaUBsyfwpCR3sqg9bKQsF/aRgM0VM/7yxESP5criOpZER+xHlKVCOJQz2EG4iZRDwU/epllk8VW5lg+Er9sHHfm+VKkT95YUu+/Wl2IKeHFPzG4O3yzUXgFzzPnmSUPtrFjhRLH4RqCOdnrZKkm2hkDWNgpxobbXc1lhVSpA78CNe8XuT0rGil83XnKKkAVxBPU1PuIm8DRpCLWc0OtX8S4/hpFPh8IWlp6PvGAJUzPRVw6zWxP1qtOtOgQ2KB0qYOqQ1k6+qsyjNexoflmjHvVKnSC0EFqh1ufc2YVc9TnzUt4Mv6guiLKksCdnxrEvnjhavmS71LJVmwq9fjalm2zqIDrZNzyubdp9uHQjOaiqnpP3Ny6sxn3lJACHgtAMFsAwl49vYYbZ27hhm4TDx/ofspfcOko3kVoUMMBBzrdqSmK07Bx3Rugnj2roWcO5LeTILSrv1dPrMrDYY6WvM9gzjFhU3esHZYE8VlJSBeC5TUNzoTu+orL6sKKfu3vFYHY0DeTRcuWA4oJuuMhf/NuOfsLvP5gIQFmkUDCZNvJRqE0JHfUIBG5/EBxoDGvzw/N0bMhGh/PlIaj3mdqKlCZZl7CGP18UOVTzySFDPglnBWQuEkH7Df+8o
 OWH3Jq6k
 9E0vIPT2SJp23p3+BuLLb9Kk5FpBNWxWhsUtm+euOqA8P+bjwNI24nhyOZb5zZhZOfA5zwqjWYfmRgW5TPpH42u7QRGYj1R9MrTw4zgYWEsTcEc7qAoPt8H+mt7OEfbTGHzMTJlutKY6z4WJhCJvhqr83aMTCBmwJw4ky+IsheVBDgarxT/DLJoksz2Y99Bw0Z2mczslQ+NFdajMmntXEmfGAbM67rb17yiBYrD80eVnCOL9RV9UvqvnhC51552IGOaRoWUQoY7JU/CdStlJ3/s6oNf4RBYsBLHWT3LZZZqM+gVib0FCDMo9UPU+O0KnLOYREQkbnGr9WVzuVDxm47iSZug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 12:36:30PM +0100, Kiryl Shutsemau wrote:

Hi Kiryl,

...
>  - Dropped the swap-skip patch, an equivalent has landed
>    (Alexander Gordeev).

And dropped [1] following David feedback [2]. Would you pursue the proper fix?

1. https://lore.kernel.org/mm-commits/20260808063054.B75691F000E9@smtp.kernel.org/
2. https://lore.kernel.org/linux-mm/9d0d98ea-05bd-43c0-bb36-68aea62cbde8@kernel.org/

Thanks!

