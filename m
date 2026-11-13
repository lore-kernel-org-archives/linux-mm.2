Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B780606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=AWcWc5su;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Flk5KCuO
Received: by kanga.kvack.org (Postfix)
	id 3BDC66B05B0; Fri, 13 Nov 2026 16:59:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347E66B05B1; Fri, 13 Nov 2026 16:59:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5026B05B2; Fri, 13 Nov 2026 16:59:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E02516B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:59:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7D80C014C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:59:47 +0000 (UTC)
X-FDA: 85431463614.19.960D8FA
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1AA411C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:59:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=AWcWc5su;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Flk5KCuO;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794607185;
	b=NVKMOvutMrhrteLm4Pu4nxEfc1AdksuzNMBTacVYC7XppAsezvQ6C1Rv+dEb1Te+ZHiOEv
	E5scHjpIEN67fLjS5LqxTPupGNtd5pTxAkr00i4PtxXEDJ04t38BIi/tRbwCbnX6ndm2WO
	a+C8uty+006gERYWP9LxAbFoBTSfKBU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=AWcWc5su;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Flk5KCuO;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794607185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbo0hvja/aQWVjypyvF7vodG/IYlp4ZZrmUDCCImAe0=;
	b=AbjNXC2I/7zA8UVchwAiBX8zsFxfphDdrRZPi71fuwREF63QhY1fJ5jADdhJfi+cXzwok+
	33j4Vhc8RTFSW3Own+XHduo2m9THAn7PSxKodUNSxfZpqqrIxOqKOwnbbNx+CqyWLunToK
	dKrGJVbSo4DBmRXCk/W3T6CFiqav1yQ=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADLrYW83417642
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:59:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=dbo0
	hvja/aQWVjypyvF7vodG/IYlp4ZZrmUDCCImAe0=; b=AWcWc5suKvE+5jF4Ct2F
	KN/NQ8H6uhdtkzfRMt1aeDZ1Kbb6WkjZ0z3ztHveHd1WMEmT78SquUVjxk3qDyCV
	et+DSTVGOC9hXNruQWV2/b8LIFTQdGpRsejNtuMWpXbSzqZ/RVVrMZspm3KFuSra
	HqKrI2ig9KnxVo0yrRhff6K7A0p2cyou+AI6LSrvoEhVBWejxK9PqupbzzCB14h3
	XwbJQp0H0e9PG95H0whPUfF5xEyriwpgYhol3QdBhKSqAJ4KfbH2+qT8tB+Re7cY
	S9+kKdh9GYKxNfbRbabFAhJsm0ps4wl10oCaJ6oAYtVYoBCgOjoVKRaZemTpj4Dr
	0g==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hx8sj99ka-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:59:43 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-55c5cbc838aso4400631cf.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794607183; x=1795211983; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dbo0hvja/aQWVjypyvF7vodG/IYlp4ZZrmUDCCImAe0=;
        b=Flk5KCuO8t6Dnt/G2scr5O5VWMu7fTvsH7lI6gAsRwpbnT+b83w+kLHKuEOO1y3O3W
         o8UTemtmfLpFNrOqSnnJ4k0RC4i5D3wPjsE1eWcWVAOgBsEIj5Y8Fyqlm4CTZlU/Si/j
         xJSMrW/7bOBWigR2TFLaHZtSDOW80F5kyJozZ2IMlk+1L/iuopgsqsHmT7cLES1LNt36
         zhK6A43zA4ASjlxXKGvzbBfyC0z/1rZ+Vv43coHnLtNzYV5MZnlG8V9vY8Q6Kyy1EiCL
         r2NVwbM7XJl1z32dqCaTOI2KUjt3ya0bBYcPhSmFhFzs+317vcYIDWqfOjcZ2o8igGzw
         1nDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607183; x=1795211983;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dbo0hvja/aQWVjypyvF7vodG/IYlp4ZZrmUDCCImAe0=;
        b=DMi7LUU1O/NMYeTImh5Fee58ENtNtpJ30zzZrTO/Sq2II2unE1vfZwmk+XMiy98PPY
         9haluOVDluk62QIyJEIilzvYYMAtt5dA7gcdzrmp8W37a9LRPpYf3U2ENh2Bkkpfnzep
         sOJ/LfQokqk/VpTNtiDr2GdlgYDd6HVNcnZF2tvuv/pimtdxHoEe8WTDFVVTpZym1F+b
         WUozaSBy0voMCgF99JOaHIKkwopyWA+PYAMwv2T5oPB4XTqHJm9TzQpxnia+hvVB2Vbi
         vc9ey+Zk9DC53CrqlS913CrJ6+DMMH5S4o1w//tS/DrnKJ6LgrcqOw/TL0o1f4k43Apx
         DnLA==
X-Forwarded-Encrypted: i=1; AL+hErGIs2II1vSJarVODvxf51Mh/PXBJLr93Uh3zB0VrRmuMvBu2+b2tHVafDAw+QJjrAZaT+hx9dMq+A==@kvack.org
X-Gm-Message-State: APuU4Z8wLkqVGy4V91Z+3883nph1m3WFDKxduG4oyb5fSP+9YOMHKhu4
	hmUcDc6+1ndemJyqNonlAMkk8JzrGXzEvhhpNWFbV3gbgbq92sajSOz77MDM7miE3oKLMaK2pyC
	8vvikCD/Q8qABPEDAgwCLIaXZOvg81J7+0RqJgk2t0TZzps1+
X-Gm-Gg: AYBFou3s0P00Lbckl4/O6wv7qELRahZH/aNwUzGdpTJl/oAwGpZNEHuSMjU32MzWFbP
	D13a+/qoFgqHPA3TDLZX484ONictQ3y7Hbm25ApI/JDwK2nliKbZvxPLhzfvwzkozv91P291w80
	ujZJ1Jwqn87F/NTq0015EfPu62DsHu0DMegVGft/ysQJTs5rYkM+GeYkIt/RvvZfEfEsad84fLl
	t1Nx8QK2Tr+xg+6r1IzHHw0AJGUFFQ2KkZpmA9uugjxfKUuZKZcdmW7rHqNUqseB6Gqxxrpuzap
	+aiuFyxdJaBd3HOBujn4z7B4Xq7jAYg3VybV7L561jZcFYeWFyHZ+3yu+ZUvKMpyImhTFAaD/rp
	r361/oyfEjsYcwfOH55YRsYlIihXD/1wT7sjRr0yOf8O4Qu5EJdjPezVQ8d1IaMWkTxVw5jWCAn
	ecjN09TsZQ0JBfEFrqW3DM9w9ru3I=
X-Received: by 2002:a05:622a:2b4b:b0:535:a5f8:a5c4 with SMTP id d75a77b69052e-55acaa6abb8mr67025641cf.68.1794607182810;
        Fri, 13 Nov 2026 13:59:42 -0800 (PST)
X-Received: by 2002:a05:622a:2b4b:b0:535:a5f8:a5c4 with SMTP id d75a77b69052e-55acaa6abb8mr67025071cf.68.1794607182155;
        Fri, 13 Nov 2026 13:59:42 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-153.net.columbia.edu. [128.59.178.153])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad13fbdd5sm27462521cf.22.2026.11.13.13.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 13:59:41 -0800 (PST)
Message-ID: <f28dc841-f664-4f97-9dd7-bffd2825115e@columbia.edu>
Date: Fri, 13 Nov 2026 16:59:39 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
 <avYG7CtQ52v3I8tF@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avYG7CtQ52v3I8tF@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Y/JtIReN c=1 sm=1 tr=0 ts=6af7884f cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=Y+j3KQtDOE8TDC6EXH/Ajw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=VwQbUJbxAAAA:8 a=yxsk_VAZLwplHE6VWPAA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA4NyBTYWx0ZWRfXxrkWAHjZTT+5
 AfYlEtkpLF2Dy3uZtTmmY17rh75TnEdgQVBHdTU7LBt7U9RTc8S8QoDk45IjqcFljYzW8XhGLZU
 0fngpP5GwvRgS6tL264DdiNggVSbCzm/uppmCFCMNLqD/HFXapteWF2j3zqxlXYVrYfOgcAUw0d
 avsqcu4LlPZxm5ZJjbQSLpHTvrKJF7YP9jinlgdGFsF0iHzN2x0NLnugawRGLHDmD6/joCJ94lr
 Vzh6nmsV9v2Jng7j9knjVETHBo1CULn8GHgiLEydbY6osZQqbf1MblXqr6fz45b43bTaK53aHGv
 PT3lc4iD/qMkGCQBfo96Op+pW6q67Jo9CmKhg2etGTAsGbR7BnS5VJqon+8x1ypRoticbReXF0G
 jd1gTJ1/ic7bch8Dp/eNC5Tu+gmnUyPQZF1C9SQvHOY2U/HZSGD0B5sOze4twCAq0N7yoHR5Aep
 nRnaLxINEpT47+KrrDg==
X-Proofpoint-GUID: 0fFkqTh-AO12mqkxkOp9V3JVYzsMDHiE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA4NyBTYWx0ZWRfX3jLUyhiM+KEs
 cOhAWy2UxZAyOtfLJ3dtBoxTPVOA1EcjSwk0a4DSy0oXR0KDpbKtBvLKUXGY9oYC+aOIVRGXIVK
 4RkMr43zFh0AUkqRdyiyMpuy2caNa7sDaausVAzObZR6vDUkpmGW
X-Proofpoint-ORIG-GUID: 0fFkqTh-AO12mqkxkOp9V3JVYzsMDHiE
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11965
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 impostorscore=10 malwarescore=0 spamscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611130087
X-Stat-Signature: iha8wiwnjwjmbciyws4y68oxe3aoxrmf
X-Rspamd-Queue-Id: 1AA411C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794607184-29352
X-HE-Meta: U2FsdGVkX19bVLks1Dp47c9uwClNnaCJcqwthrMkogQcloeVxhlmdztgGMtWopEziPi0qL5lPdshzSAY6dt3pQ9b6OOCjiAWp33Od6Fx8xPnp4B8stRzOCyIy2YXkMtiLPx4/PqhuAzdmB8+ICz0fapoYv3mk2pQPyUC5htvqnpzMuyxVDVL+KtHey2UR88iHXXwwDl4XiskhjcoHkbIzctHa+bvnisFFr4sxFn1O01yMNMvph5rRFNSSsQ5E997AZzHhk/g26kmgXQrWIzZUhDAfapoeMxbnBCP5vNFkp5OrcI/McpAY8Lbj+ZTisAicQPlUkWuldoTOW7k8aOimptwN8+WzTMhr7caYaEYYR8H+mRNmPrn+hYHrObdGKRmN97++t91xMJK1wPXyIXrWHy4w4jxx8F8c9I8udZbmAs8II8NADDxRDkPDAFmazcsEWhRtqQdqwbgXzTY46pE+RWn5pXq47CeEnOxqGUdaVBDF9xIskm4U8y4bg47n11VXrUU2x07tNdgZHZ0zcVI9eYg31ryoZZn6zqOFoPRiNPJTI61aHsHcc4c55dYCK3FsoZsfZC9puHdmk06ocisgDzKqU/bvSF0xHGoVm8g+DbQMbIJTINLb7cMW03ITLLc7bIrsCd5FW1OVa1kPIfXdJ8ogqu2vqUZ2jcC6ucFXwUriWeqFuacrshrTct+L9eF+NY38cmP06lq4XruV2stFh24pPyjuB9MH2uClAxVDQrR0eekX24IRS+bb7MdLqf7ON+fE99G9UZVr7/zM95QQVzAQAUgMAL+LvOStRX8nXBfO333GfYxP8H1m46bX3t9FdD3hx8OTH/1326CUjH5fvnJlgS9HsAxXHJM8f0HcSwQBlCtRrqIcf2Bz+xt7TbVDLe3lyCgkna0FZICb4MhxMUiYrMh1JIA4RVxdyWdCebHwWMG+eFsHvmqhhRXmLjcuyWMhCHOTuKqrQzJtgr
 emboVXUx
 QZIodpMLYCSOfFXWCwDmrqwFf2b8WsVpHlKPZRVbHEvQQomezTO9yxQIiF2pWY40v93V05IRpfEAQyO6CZEVVKiuJUG4RLfqk4fmMQGcTu3vvbxomg9ZiuqYLiB5M7B/nWDzYZkiTfSpOuriEdbzWKmyW0zo56ZtkXI4ecfa4ZH5UW5q/gApWlAC5DF8f7gvPxnvgLtSRZHLCl0S/17of/jvAxBupxOP0NSB3DF4+EnkDg7hhd9052cfIa+c9b99eRh10zdPEEF7rw4ofAWAxh3BQIAtGZnEylV4NvCt2a4hAauyGYtppVDq0NV9d81/FbtpanOjUlPDWBJQ+o3JLYfRbPh+Nmaz8hzZpUbjnL9f0TsckQfsQvKb4eNBiSDUJUBb6mOZGtkqSyolj+gP3kDAFmsBLRKdnXcHbspfYkVnIQQPr4Bci0qJj+3doSGI5Ub4xd6Hl83zaf+Cwwh1LeksaKWmXRjyr18lcpawhPRUOOoaTK0naFUf03CrpXe0gAKO7TBL5dM/uENo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 1:44 PM, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 11, 2026 at 12:55:12PM -0500, Tal Zussman wrote:
>> remove_migration_pte() makes the restored PTE writable for a writable
>> migration entry, and only looks at the uffd bit of the entry otherwise.
>> A writable migration entry that has the uffd bit set is therefore
>> restored as a writable PTE without the uffd bit, and the page is no
>> longer write-protected.
> 
> The UFFD WP bit is such a terrible, invasive, broken piece
> of... engineering :)
> 
> Notice, again, the hallmark of an utterly broken abstraction - every user
> just has to happen to know to handle each of your weird edge cases every
> single time they happen to interact with anything that touches it.
> 
> I do hope we never merge something as bad as this again.
> 
>>
>> An entry with the uffd bit set must be restored write-protected, whether
>> the entry is writable or not. remove_migration_pmd() gets this right: it
> 
> Sigh :)
> 
>> makes the PMD writable and sets the uffd bit as two independent steps,
>> and pmd_mkuffd() write-protects the result. To fix it, do the same at
>> the PTE level, where pte_mkuffd() write-protects the PTE as well.
>>
>> The only known path that created such entries is PAGEMAP_SCAN. Now that
> 
> Wait what? :)
> 
> How does a read-only scan of entries create softleaf entries?
> 
> I think this should be explained in the commit message :)
> 

Will add a sentence... unfortunately not a read-only scan...

>> PAGEMAP_SCAN downgrades them like change_protection() does, we should no
>> longer see them, so this change alone should not be visible to
>> userspace. If another path ever creates a writable migration entry with
>> the uffd bit set, the page now stays write-protected instead of losing
>> the uffd bit.
>>
>> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> 
> This seems like a super-weird fixes target.
> 

So this piece of code was added in f45ec5ff16a7, but the issue derives
from PAGEMAP_SCAN, which is the commit above. I think 52526ca7fdb9 is
the right target, but can change it.

> BTW I've noticed you've not been cc'ing stable, is that on purpose? No
> autosel in mm so we do need to do that on stuff intended to get backported.
> :)
> 

I added stable for patches 1 and 2, but for this one and the previous patch
the impact is PAGEMAP_SCAN reporting a page as written when it wasn't, which
over-reports but doesn't lose anything, so I left it off. Maybe I'm being
too conservative though.

>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> The change itself seems reasonable, as cursed as the reason for it is, so
> with the fixes target confirmed + commit message updated:
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
>> ---
>>  mm/migrate.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 28a8d7734735..d200f64b5f98 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -399,7 +399,7 @@ static bool remove_migration_pte(struct folio *folio,
>>
>>  		if (softleaf_is_migration_write(entry))
>>  			pte = pte_mkwrite(pte, vma);
>> -		else if (pte_swp_uffd(old_pte))
>> +		if (pte_swp_uffd(old_pte))
>>  			pte = pte_mkuffd(pte);
>>
>>  		/* See do_swap_page(): restore PAGE_NONE for RWP */
>>
>> --
>> 2.39.5
>>
> 
> --
> Cheers, Lorenzo
> 


