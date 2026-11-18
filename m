Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB86606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=AvcKfCxg;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=b7r2E6fM
Received: by kanga.kvack.org (Postfix)
	id 1584A6B05BA; Wed, 18 Nov 2026 14:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1301E6B05BC; Wed, 18 Nov 2026 14:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01EE46B05BE; Wed, 18 Nov 2026 14:50:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA6D76B05BA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:50:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 425251C426A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:50:37 +0000 (UTC)
X-FDA: 85449282114.05.D4160AA
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4FE97C000C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:50:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=AvcKfCxg;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=b7r2E6fM;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795031435;
	b=k/vWmF+jKTWFBFPBe9UnLfDxgNkkkN66V0j5Z/2zcflEIomzKQ33IIS1lRZZAWxjKr3yLq
	dZxly5EDgFKNNDBIXWt7aBakDfXjMRyPDM9jmEeedmQhSrd0vBYiUAZi8bHKrboaLsE3NF
	UMHm70F0eWR6Od2MYLOEfjJTt9Gm0Lc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=AvcKfCxg;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=b7r2E6fM;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795031435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7xQEq0S5madAXrgChKTKdPfHb7gKwfhdlAPY6R8vGQ=;
	b=I+k7kvfj7mJOyCbCtfBMdBLx9k/FeB8e37l9+HUm5pEGUxz3AgZ0nTazX/Ucr0jARP+ul3
	yDj3okOSh0Un4TOr0s2kBAhp4pIxKQP/Vz3eVFmxybocSpVOmI+Ewg4PczqgVXaWtHi82X
	rHgmK2rA3T3l+DATMP9+42OgcEjExVU=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIJYomS3533462
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:50:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=r7xQ
	Eq0S5madAXrgChKTKdPfHb7gKwfhdlAPY6R8vGQ=; b=AvcKfCxgh2FO1dLQ8zx+
	4vXb/ToMs6lkdoSyUzHR7J5mA8oTJ80Evn6C7DQAcQmCKyyCXCcVPXC1AY2BPV+D
	PrxnrOdal+rGAkWkiyrbM+AqOwlZAQ1nJhZU5MP+bzgPUyn08QXjS82Qla/J+pPH
	iCcg3Jt/KcqKZ5SUTzgJwHBANnntnyE+Pl4ScFWubQmhtGSgKuvD11x55l/MrryD
	qpYkODcKqypwoTWy8gK5UZs7YAS4kt/NOgHbNYfZYGtlH43Z2m+cRpG1dhxCVAtF
	QizC4R1HjcRvzV9dgt1KKEHn2w9dfl+PcmY3Jg7zuQba4dl/aGh85fAhkp4sBQiD
	SA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j1f6gj2vp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:50:32 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5383c05fb2fso34773901cf.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795031431; x=1795636231; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r7xQEq0S5madAXrgChKTKdPfHb7gKwfhdlAPY6R8vGQ=;
        b=b7r2E6fMmOxqlq0tSYvz89Gb8nRE/zgvHBnOcUZTaumhgqzlFIrxU7F6lAFFXfWf7g
         c9DnOA8Hto/LmYnnmLmNfDoOap2qooX5TB3FpTax2cluU8CBk/EMCvo1aAoRxqIe7udp
         qiTeRAvxhyUg1cdNtj97ToKpNycCS3NtKF6tXBND6krferK/+8gN4OoC/8sdrUVqlsve
         Q5oSsKjoPhpKVEqt13joAfArMwDNWIMIVqwBXp/CJsZh3wtZWI7Fkzp/qk62M1biCO9N
         Z0tVSC3JdnQSOm9CLnnXYIo0svsPKmBwUCg23uVki1wl6Nej4hwKdSjWsQwTWyXG8nev
         xvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795031431; x=1795636231;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r7xQEq0S5madAXrgChKTKdPfHb7gKwfhdlAPY6R8vGQ=;
        b=GzMHCa5RvNPpJdpAF+sry/2qXbIYiA1S2d3Ys7g1KZl341XNVgGprP5Gph5Dg39NAj
         Q8H3qmDqoHrKG0LY3Kxz10atHJyYMxL/6RGe9iOTMtTukCSCjarjmJ5xn6Ii/yAu355r
         SF1QuixyqmtWuRw/tks6TPmXmWb+VpRcWu4hMRgrra0fYh54B8hY2gIVCcQ/xWDzPTby
         VwdAKNt/lYa6KTJS4a5t2qUBKR4iCuFeT5Zf0Hx40D+L3tLwSFk1JrPHEQcSt53BV3CP
         WYbhHe804gxsOmRG1k5rmmfHDwn0tgQHPrEo7Vg9Rwdm6EopnQ7F+rXF0Rw+B4FBQDAN
         Y3Yg==
X-Gm-Message-State: APuU4Z9rdq01T63JWDUog36qvb3pfbRhPvnjaZ8XBuN4/h5vNJ6/esW8
	RhmsCaVKi6wM3jOhznSDUs4iMtZM2AzGl7dHzWLXbVvHrbLTYJGFNbcgKdLGL+5FYpLNzbvZl1X
	wF2Xy/004s6jKe93W0vzsh+LiMmimN3qExw/XrLMkeJRnAL05
X-Gm-Gg: AYBFou0H6wpqhES7WyhXUdJc8qnYCYzyQ0nPy1NNBX7MCY/zNJhCMKKbUmFt+n2TnD8
	d2JEFb+vKq3NAelwj6wZy5eHatHJLl/mh+z1hM52im6hb8EvSIRFJQs/S0/cTLikoM9P7L7xI1S
	4Oss4Mx9DHO7+lhBsrZ4KpDiybhj6DaHNxj4yBuKzug9AJBr5zilNtKj8Irsn+9bKuyLu7ByT3E
	H9chG4N3ZP2sHIpDd0nxeZ4v6/RIQAIeXUmPIVQhVuNv45MGbOm2tcokTyyZ42GT+vQVcyo4Qou
	NEoqyZdJppNgoOT7IvS5vSXVDZj/ESmFvUsf7f1YeIJaQLgABzZd4s2+aUO2dpKb3P6KM0VVv7n
	qsU/uolTYIGw1lr4Uvpht3lJ1OfxTVh2TS8hUX2Aaz+ObkTRosVNQZsbf3j3lkZjnqNqi+SJhPm
	D2lnFuCYMCWmSPatBmFNTddA==
X-Received: by 2002:a05:622a:5807:b0:536:252a:dbf8 with SMTP id d75a77b69052e-55d5a537991mr56617241cf.14.1795031431364;
        Wed, 18 Nov 2026 11:50:31 -0800 (PST)
X-Received: by 2002:a05:622a:5807:b0:536:252a:dbf8 with SMTP id d75a77b69052e-55d5a537991mr56616931cf.14.1795031430933;
        Wed, 18 Nov 2026 11:50:30 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-14.net.columbia.edu. [128.59.176.14])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d66c24503sm7189751cf.20.2026.11.18.11.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 11:50:30 -0800 (PST)
Message-ID: <9a6599cc-f47a-4a27-ae8e-91c8a1a523b5@columbia.edu>
Date: Wed, 18 Nov 2026 14:50:28 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Breno Leitao <leitao@debian.org>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <179501525761.13527.5348420494097607881.b4-ty@b4>
 <d05636be-5a37-46e1-b6d2-30950b7778b5@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <d05636be-5a37-46e1-b6d2-30950b7778b5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDA3NiBTYWx0ZWRfX0XTxnwNXoFZa
 6nR3AF7LAhZLKDoQEo3nZsUeWLrE6UPcmefdAqxemixSuJcxX1Cq4KB/wOpq0qhQr6t71M5f7tr
 /rmyXxu304KewbIVDxLLCTn4fMQVrofxayJc7MHvXy+ljssy/qowewpMhykyITCqkH99g6ftglX
 6kCsgAt9Gb70C6eSO0nwSaOSGGZw9eNXTgahovMTRrAY61BhQFQ6LwXGVkBNCDG9EAzLJ5z8TWF
 KbAFCITuES/21/UsjyJwb2CedqH0mOwG28R1e0oooSxSBG5fdTZB+MPVSccjutAx0c2h2aXMy9u
 2fanKr3XOPFkzgVZFGs+t2Tyr0s4fRDRVrPXF5nmynnscbdR3TRwDB3/3oWLxiWQlo4/nN6ceSd
 PLFOJApodashG9xBFOPdYaq103KW022Yu3pTiF/R/6I44xapdvkvfQ0wiK0syoqQQS+P5+qn9HB
 XR/rE1V3a/JZfXMFkaA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDA3NiBTYWx0ZWRfX+HJqW+O2YhWf
 UFm8GFSWAput/A54dgcuHBXkGJ/0NxjIt+LiwAp3m3y41bMA+MIOIjdllhx/kKtjaB0u5l6rz5h
 8LktQv2WLxQURFtcWG3fJmFBdQBwo13X2DZhWuCXxkBzNwFEkZSs
X-Proofpoint-GUID: RbckQ_OH4nvTdml-fzb2-t8EMZtcrr08
X-Proofpoint-ORIG-GUID: RbckQ_OH4nvTdml-fzb2-t8EMZtcrr08
X-Authority-Analysis: v=2.4 cv=NeFzRGD4 c=1 sm=1 tr=0 ts=6afe0188 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=2zM0HjzktFauw5hoOd8SpA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=b7hxIIQ5yigvctP09d0A:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11970
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1015 adultscore=0 bulkscore=10
 spamscore=0 malwarescore=0 lowpriorityscore=10 suspectscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611180076
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4FE97C000C
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j7atzt77wn4rsgxb8b95gxhckfpsnfzw
X-Rspam-User: 
X-HE-Tag: 1795031434-131575
X-HE-Meta: U2FsdGVkX1/2/8/iA/YxOlwAVInQLv+RMQW/M123fWHxfNH8/yZBRigSAtgwfZC9zpVppGMhDjD+YR365fhvj7e7nYnwwpAXMaOhUj9HV+USGFSy+uMXMO8ZDB69oUlT453/T544U8ZQ91Y9Yynr9mPQMuYFs4oqloaVfdNwd+4muDWYTDZr0VEZYSjkdyhGX8OgOwKnsA0gJTLdO2U/zr9U/9zCsXvxS4Ye0CFIQ3e/yygupW+ugQYC83mDBfOXwYyOE+Mq1qTxCZH/hLT6q75nLwK05HFaeraBldkXGHEapWuxekd+cGFa2pWoDt6vNhIwSGPsZQp4H8xsgJc8CAgO+uDq+Vx8jl2ikvJKPtMbb6VrgQoGP2KBWxUQ6nfk3wq34megFH+fDGCz8tT+juf+wFbp5zZjvcvTSvOsLfKON18arF+uaIzSM+bYEPsP5cQ4Va8iQd5DJ+RxbEnV1W2Qn1u/ntnOv4JHZjeV+IJInPJKclxuCFzeNty9nYbeMdciCwifTHfS7yOxuAUldEZCh/MxxUmdk7D1vhGvzYvHwSMYej/516FwkmUQXhWPfE8h9LVCscdHhzh1QZPcwac0JgePdJMor7ekt01G9vaDceTip0I31zzTB8VE55qti0MSywel1x47oyqxaTFC+UW3a6ogA041ym7SZ53Vi3yZ7V1PRS2KApHwaeZCuUhMw5OQMTFtGxnOJzWh4Qq0D0uh1DNJtcpZxFbxFodT4xLkMTElFQ/SZIysGuBakqHNm3Q1b62k1iCJ1XKMa0UDBNLHoMK6AB/0Z4SViHLv8sb75d9w/ieKaystmF3osLCKb2JGFdLv59fbSdd4giZ9m/OBb5y2e3JZrQ5L9RlT6ADLwjkO2wdS/NDtMfMXBbdLcyUyIObsWINk6XiS+5s0CmqI65K3HFnyhsiC6E26k5q/R7R9gKJx8xgnpMVH946tC79GQXFcBfIz7/rkXXS
 BrKOQRQ7
 aqlYeTxMTJc3LuXgzDoP1MEftvpRcPSIpuBzgj9AbIfz083wLeeAwDrCRT3EoyZ1PHPtAtElekrx4GnnWHvLD9vMzGqsMNPmJu1AW+olYLGe7FK6/Zj9mufohRlq/CHSHQXTcKnNuk23x0gWjNM2HlHUafTRjxWhDD6WxHUtoLdbcEy8ktxxPMh3SA9y05zkBg3yexS3CuVRrXv59PU4fz4dw7u9d6vz4Fs3BuuvWMMqPL0Qoszd58oj7rwC7EK5PA0HvYeI+MjBico1XSPlMDnlJgg9ErXpThLaoob0SRBbh3wKAd9CvGhycRultDZLzoxoJbAC8yYuBUqVszCriF3+gHAKFkDABGE+1M6D7esxB8VS0ygXo937MfOp7S0z+Tp5fdbCt0Mcnve8zgBAM/8d35VUucBLRuPE6/OT1VRPCCpDktjU2IixQjvHT1kDjaVT4AUdBFkKPNftnig4j/oPYWMmAP9xg3s6Oy/0M+8p+90RyWDeDrgIpxkOejJnE2Vx6CHMEz3aQTLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 10:37 AM, David Hildenbrand (Arm) wrote:
> On 11/18/26 16:20, David Hildenbrand wrote:
>> On Tue, 17 Nov 2026 23:28:40 -0500, Tal Zussman wrote:
>>> This is a first batch of userfaultfd fixes, with more to come.
>>>
>>> These were found by a mix of regular old LLM review and by having an LLM
>>> write a TLA+ model of uffd interactions with PTE bits and other state
>>> and seeing what issues fell out.
>>>
>>> Most of these fix places where mm code loses uffd-wp or RWP protection
>>> while moving or migrating an entry. Userspace then either misses writes
>>> and accesses, or gets pages reported that nobody touched.
>>> There is also a hang in UFFDIO_MOVE, and UFFDIO_ZEROPAGE modifying a
>>> file through a private mapping.
>>>
>>> [...]
>> 
>> Applied, thanks!
>> 
>> tree: mm/core.git
>> branch: thp-7.5.misc
>> 
>> Applied patches will appear soon in mm-next, followed by linux-next.
>> 
>> Please report any outstanding bugs that were missed during review, so we
>> can either drop the patch series or decide how to fix it up.
>> 
>> It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
>> though the patches have already been applied. If possible, patch trailers
>> will be updated.
>> 
>> Note that commit hashes shown below are subject to change due to rebase,
>> trailer updates or similar. Further, this is not a guarantee that the
>> patches will go upstream. If in doubt, please check the listed branch.
>> 
>> [6/9] mm/huge_memory: build the moved huge zero PMD from the destination VMA
>>       https://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git/commit/?id=ec36bf72
> 
> 
> Aaaaaand undone. :)
> 

Thank you David!!

> -- 
> Cheers,
> 
> David
> 


