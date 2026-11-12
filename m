Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D4C606A331
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=qTIXmb6I;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=vKn59FFC
Received: by kanga.kvack.org (Postfix)
	id 13EA36B05BD; Thu, 12 Nov 2026 10:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F01E6B05BE; Thu, 12 Nov 2026 10:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21966B05BF; Thu, 12 Nov 2026 10:56:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCB886B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:56:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58880C02F8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:56:16 +0000 (UTC)
X-FDA: 85426918752.22.A3412E0
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 97AD91C000F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:56:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qTIXmb6I;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=vKn59FFC;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794498974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5MCX39uElepfVtTvuZHVglCqNrm+Ac5neZ1hbGO2lg=;
	b=kVznxDHBBWa0siH9OumwulvkZny/iAF0XrqB1Ps8drRaqJ0jgsbYLhEennCOxFVpkF7jRH
	GvRGCP+4xX+MbK8IYCE7xreT6L8zlvSCRZrKToaG4UyKcLm1iL8lGVE79PYTFSkNslAVeB
	2fpLgTVpwiYNGGP9kNG61uF83S+TxWw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794498974;
	b=FIujNbxBQf6ikkbNmtNduvdhHGXC7V2L/4lZYVvMvyDwn1lxxEESYZ9WbVVFiiREiTNsw+
	2OPKVaOt9CDZ1qQYtvqhq8+zjXAVhSamIeZq+YCYJ4aVIMe9Kw0D9gMz4pD/Sq1/0efbX4
	/hUtrmluE3EBToNmdBGamW7isUkLtzU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qTIXmb6I;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=vKn59FFC;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACFY39G1345331
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:56:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=t5MC
	X39uElepfVtTvuZHVglCqNrm+Ac5neZ1hbGO2lg=; b=qTIXmb6Ic6MlwXZjV3kT
	fn+T3+gZsaoRNrwfJOLTfI7WERkwtLdWJNySW3ERtXHj4X9ojddNHnFnRMdDxE5/
	pIarWQXZiZiMSqTxtZPRoYZ1alPM3+1dw+bo/Q8HzY+0dRNd2SddSeI44/SdsB9Z
	u7yQKYt1a6eH3GsCPJzW1fKyYPwr7aSOgJPyFZnU8QroVLJoDqkm4FiKAwBsY/eR
	ofi6ao3yQVfyz2CpmqAalgjsxeSxdy/AgeDcUM1iDvz9MtGc6ArdcHUkBWG7uFPR
	x6S5pEGTpAm2jdbfxy6S9wYYUcscTTcMY6nI9HAebPLvETvNFl1KuTBVipLVx8ZP
	ig==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hw6uyk30d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:56:12 -0500 (EST)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91ec6cd898eso85987696d6.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794498971; x=1795103771; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t5MCX39uElepfVtTvuZHVglCqNrm+Ac5neZ1hbGO2lg=;
        b=vKn59FFCM+VIUtBOvJ9Lu13tiJr5XDbqjgqXdfLutbeqw0DpQ3M0FnJBdOCFohktBG
         E9+uYQhkIWX9WNLHB3OmMQBwD6kuy/cA3VUnQdFM0Bl18Uzl4vinRsXjYtw4q7ovlhLb
         tLewKsCvHTK94hNFGvzphwUrMBBY4GjgsYDxrXubnPNag4cEn84baOkXDIUkZfPd5TIH
         T4dcDJQsYuQxNXTvS+Fwh0yzZU1g4+P323DYmcw60DSf7InlkuQd2szdKW5ivxOlCtD/
         qsEJyQzjDPGcxdkFke9t5OC4/fq/JugA642IYn+kN8BRhEJlTyOxoT4B/tIki0Z9Xx6r
         O0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498971; x=1795103771;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t5MCX39uElepfVtTvuZHVglCqNrm+Ac5neZ1hbGO2lg=;
        b=eFp2G7e6ZHGmnn8RcEbYMJzvnpUYzNaJekPUdfpAmsswTxW56mC0EalPMSbEgVZmQz
         iy/l6BBkM2qH/bheq5+2QEDlLtGn3eEkoBvpO69pILqFdiyYL2UN3vCmy6EbZetpbuGs
         Zhj7/QQy2lRP/wtYBYEmFcoWKXtmXjA1w1SycNvhqg6tU42UnHrs66b5IGlsRuAN5Tly
         sHAYk559pd0ugAp1B7TEgQecrKJsU1rHstb6KPPxHIXM2aFLk3cF628NHyjNejHyM80S
         LZLGY9ow6NuSsRJGkakKEKxhNfM6C698wDgKavr/6y62RJ39ft1R8bNT7ws4LgI+dHPZ
         HEsA==
X-Forwarded-Encrypted: i=1; AL+hErEiJbqhjyRJ3w9zcJIeTumBWkGk8Y5Q2+xqCQCAIck9sb1fjjKcgDgo/bGONaimCejOC4/PHWZk4g==@kvack.org
X-Gm-Message-State: APuU4Z+FMqsXL/GiEfzvfkysUYmEIK2U1htK+TBaekJ+NCxPq3c7S1VW
	Fv8/VEeaXwRERtUbbLdGdlkNJhwxBEri9nCZJfWX6+IHTAG3GBCDocYRMkg+ug0jmIKUAXot0UD
	Vf0TwkGeRph5WRc9/EpD0dkHiFJBpWMvD1twkVULOc5LWsqFx
X-Gm-Gg: AYBFou0wuiApt5UWlz9R/AU92aTjy12gyLaNpVgkCNXBYe5Twh4THg/kvYcQn3B6jAt
	77ERuCGLef1bvLuw4OZ5Y6gripxqQSswOm1JxTSwWin8Vu3ZwLELRdhGKTe4IyKqcWzCWUQ+r9P
	24RT+QcULEDFcp9X7xcJWsJLQfM+4W/wmtGW0lX0xnUnzocFxdQfxaHilCfc0MThHE0P+UN6huq
	ePxwwNqlSeg7NFHJ6NVkYfMvCeM5nI3Yslr79ljDefHdMzCpKT4iIMtETep21n6DNGwS3sQgMDq
	ThNbvYPD3jOc07QpygB/p3qsbhQxOgp7yt9SGP/z2MIDQ5W9WOQ528jh13xYyLbTlSMBVJ3gct2
	s3D0Y4zzG4YsER7/yZiAS9NEi+bSjtceHIH9kzwNV8VOZKTxGj7jegDqPmln+7JILlwCrZbggLG
	xg2i+CUu8yOnMTQgJvpk1X5Q==
X-Received: by 2002:a05:6214:85c2:20b0:91f:136e:e90c with SMTP id 6a1803df08f44-91f136eec29mr39816116d6.53.1794498970958;
        Thu, 12 Nov 2026 07:56:10 -0800 (PST)
X-Received: by 2002:a05:6214:85c2:20b0:91f:136e:e90c with SMTP id 6a1803df08f44-91f136eec29mr39815616d6.53.1794498970297;
        Thu, 12 Nov 2026 07:56:10 -0800 (PST)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031c7dasm74341706d6.1.2026.11.12.07.56.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 07:56:09 -0800 (PST)
Message-ID: <f76cb2b0-0090-4554-9169-5cfff6a6ca53@columbia.edu>
Date: Thu, 12 Nov 2026 10:56:08 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/12] mm/madvise: send UFFD_EVENT_REMOVE when installing
 guard regions
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
 <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
 <avWW5t1BiD7pbzIZ@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avWW5t1BiD7pbzIZ@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA2MyBTYWx0ZWRfXxJIGq1sISf74
 iRE2MFPQ2yBbzqXXBWlSM1RjIM2a53wZzfFU/ZhH9oxu5MG3pFtcnTj2oLZNxJ0+X10y+l57B8k
 xyXhkgS66A/El4IiYuUzd0rKaUdr09uB2mLTkX7epVvWa/AO6DbO
X-Proofpoint-GUID: NdJBrA1-ldtp2Uusct3HwHiFhqNCbwGZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA2MyBTYWx0ZWRfX/FB2RkeXYNlB
 X+HwPWDyJHCDCBLdkPfMxKiyQJHZ2Q3UtyQUXQMXEHAu/CTv9uptjzAGQbQcydEzcl159xPXqn2
 3YN927QID24NQVvvV3m8T4Z2x87jPJeMmACzPk7r7mDnkO+jAGegXHM40RXPZNHFVPFtZO7C/I2
 7jnjgfrA1YdyN6XRXcNuKY55ik6pci9x0p74ysBKVp3Y63S2X9jgOLbv6lb6M2BomvhRKHTSo2M
 t58qEiWnTg4cddXPgHbXxJeHutFCZTZ57ymCf29aYwnXLXAsd+4crQlbp0LLwfshcCyRXVim68X
 wTjZCsQQ5aohtXCY4r8jer6eWHsCFgIBE4KTTFUzlxt4BxL3gG6trK8VXxaW9HYmZXxO5pZaC4o
 ZVC4+GgrVJIj5Fr3UJcyc98rnN7yKAnN2AwF0PJMnLEdJBPWZb6cpNcRsU4+USa/yX0M3zGBHhe
 TS+Z/hJ8ZBWTRouq2+w==
X-Authority-Analysis: v=2.4 cv=NvRE4MdJ c=1 sm=1 tr=0 ts=6af5e19c cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=Byx-y9mGAAAA:8 a=MsTJSH7eipKYaIDY7ewA:9
 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-ORIG-GUID: NdJBrA1-ldtp2Uusct3HwHiFhqNCbwGZ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11964
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=10 bulkscore=10 phishscore=0 lowpriorityscore=10
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120063
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qbgt1p6mx8fjw1ksznmfbwdijek61kdj
X-Rspamd-Queue-Id: 97AD91C000F
X-Rspam-User: 
X-HE-Tag: 1794498973-593893
X-HE-Meta: U2FsdGVkX1+pa40wRkLwTS6kB08Wt1rYfGIG2YiH0hArGVpmkmq3tOs4Y60rTmYjKWU5oHGE9rcRnBQjln4SrjV5SYd45ZZ78gtYv0k16rvABsSxO8zBbNjh7l64Z+bxGZKogJeGiWqeFLcDEgdJDxvA6TXhXIkUniBGsQqBVEH5vvfodq8rVC4BzDeUwMJZwvLRBCnTl4aVkdqq4VxrDBt1mECsyyoE05rKB5no3fSZHSciV3fEAxzqxPRQ81pIqxVRau3mdAWJEko54yMjpSbou1uQ7E32B9jazwYriSFcWQ/poII6B7FUARCjJ1yTezw7arfyhUsTFq20VG9nBKfZmFwoEgIeu+XWoAHvGACWFT1jiJ8hRJwcFlJOT1O0dPcisyte2dTvAMieBE+BiiUJjYV1xUp55ep+yCcwRKhUrihvBK0joYMS4YNENk2wCVA9HGY71FhdVYUnX8kI/cgffQIm7KDtAj9PN/YYEDu4t6wrB7eQXuCi7YfsEmSwdQJ3jsulu46dy/iBRyosjT37EdeI0SiFR8QPpR3a6ZD9c6jR8A6+teeAUAw20rorYQgjnQ01NzrjOdw+H14Hnvd87OrFQtuX6XkdUrAuTN2nkSOl+YCtHfE8l9EEzsXWxqPRE4iAzzM7BlILP3mqpu0KubR7l8RmDEA7xqQ4wCAEpD30ZtX0J6T5zAsoSpzmHDcSp2KT+Im/xut3oRVf+QhsLJnKJCVlaF4tDA3xbehCqWySYjn5upBDkUsupLzjVwM0tzMeLTCP/x6ETJiAlvkkA3xrLfSkFonJF30LN0F3NerQoa5W5Om+hxUfgCH4nQp7Rby/YQTwGtxa0tEQt8jIJwWtQN7opQBo1TOv6jVC72wteipNMCGQGlaNEpqUDWXeCNoIXzIiY6yz+ancn0UNxkGVPhGjv/TBB7urwVeRnbiXr3OFuymiiUe9CjlMg4q19LC65xyT0KmoERA
 WX8FDUPG
 g1wgW1LkashcVetZgw3IDRTHl2lgTL7Owl3pocftZWJecrisN0piNd/WDQa8rkM8wOo/irV7lgaFMnzoWQ4BMpqzqxMsjBMTcWDBYkimx1wmg8maYW1vlXwtVySFKxPU71RlyPUdDqTj39CWmAW1Qg+M+FX8GSN1XrGwEhmBmXv02/3TPtPJwJ/Qg/NHqO67mNfKj1etNInHnnZ+SA8pQMzgl9PM7ItIqNkVLOMe6hiLrmYgZe85QORLnVdRyIAQrdq6QxpPMBE+2rKd6NjA8o1Emsil8IS6LZvdOOkG7XdsSH/MAnWBMwlBj0sPubwks9IRH0DiS1KaYAmzJggFn5XW1520o5cTf1mRePW48eZNwQANssRWIEU0NJSh7kXP0c5YeZalqlEItx1T4/dyI/wW98YUhDkB26z9l5pnjneUkDd2ygM3geuelVDproRItA4b07E80tiB0jTzVtshvajPVQ0p89NTihRtePmtyoDV8/Md/vCvBFNsfauPznNTuB9+LBO8J0sOS+Omc5D02fjILEumJmgRCKBVzvNqUXpkWc2dVAD7PgwHFL4Q8AvDYx0UeNa4H7J/7aPWabZrtjPqpEj+rKzUdV0Vz+FHZoHig7wY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 6:03 AM, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 11, 2026 at 12:55:19PM -0500, Tal Zussman wrote:
>> MADV_GUARD_INSTALL zaps whatever is mapped in the range before
>> installing the guard markers. However, unlike MADV_DONTNEED and
>> MADV_REMOVE, madvise_guard_install() does not call userfaultfd_remove(),
>> so the userfaultfd manager is not told that the pages are gone.
>>
>> On an anonymous VMA, the zap drops uffd-wp and RWP protection along with
>> the pages. Writes and accesses to the range after the guard is removed
>> are then not reported, and the manager cannot know that it has to
>> protect the range again.
>>
>> To fix it, send UFFD_EVENT_REMOVE before zapping. Guard install on a VMA
>> registered with userfaultfd already takes the mmap lock instead of the
>> VMA lock, so we can drop the lock for the event and look the VMA up
>> again afterwards.
>>
>> As with MADV_DONTNEED, the call can now return -ENOMEM if the VMA goes
>> away while the lock is dropped, or -EINVAL if it is replaced by a VMA
>> that does not support guard regions.
>>
>> Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
>> Closes: https://urldefense.com/v3/__https://lore.kernel.org/linux- 
> mm/3f4b0d1b.bbf84.1a1c55cb666.Coremail.18670333770@163.com/__;!!BDUfV1Et5lrpZQ! 
> T5BLvK-D7GgO7Y87n7ULpXAEzR6V57uNMU7saDR9ShW05mDBxMyqFA4DD22Nbycn_r7rhjPtEZp8gBAN$ <https://urldefense.com/v3/__https://lore.kernel.org/linux-mm/3f4b0d1b.bbf84.1a1c55cb666.Coremail.18670333770@163.com/__;!!BDUfV1Et5lrpZQ!T5BLvK-D7GgO7Y87n7ULpXAEzR6V57uNMU7saDR9ShW05mDBxMyqFA4DD22Nbycn_r7rhjPtEZp8gBAN$>
> 
> This report was super-synthetic AI slop
> 

Will drop it

>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> Sorry I hate this.
> 

Don't worry, me too...

> Since this was already silently broken, I think the right solution is to simply
> disallow guard region installation for uffd-armed VMAs.
> 
> I had the AI go look for users, and it seems nobody is relying on this (glibc,
> android, CRIU, etc.), and there's really no sensible world in which somebody's
> combining the two. So I think fine to do that.
> 

What about CRIU restoring an application that uses guard regions?
CRIU registers the task's memory with uffd MISSING mode for lazy restore, and
if the application (e.g., glibc) is using guard regions, this could break.
I believe glibc falls back to mprotect() after guard installation failure,
but I'm not sure about other users. I agree that there's no sensible reason for
a single application to combine these two, but uffd manager mode is where we
get these fun combinations...

Re: "silently broken", WP and RWP are more broken here than MISSING and
MINOR modes (due to the issues in the other two guard patches). MINOR and
MISSING mode already work today, modulo this event notification. If the CRIU
issue above matters, disallowing guard regions on WP/RWP VMAs could be a good
middle ground (and of course this should all be documented somewhere...).
Otherwise disallowing guard regions on uffd entirely sounds reasonable to me.

> It was simply an oversight (reflex action is to disable new features for hugetlb
> + uffd)
> 
> I'll send a patch separate from this, please drop it from the series.
> 

Will do!

>> ---
>>  mm/madvise.c | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index e8b05dc899f1..6413f0e65381 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -1166,6 +1166,29 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>>  	if (!is_valid_guard_vma(vma, /* allow_locked = */false))
>>  		return -EINVAL;
>>
>> +	/*
>> +	 * Installing guards zaps the range, so report it to a userfaultfd
>> +	 * manager like MADV_DONTNEED does. The VMA can change while the mmap
>> +	 * lock is dropped for the event, so look it up again.
>> +	 */
>> +	if (!userfaultfd_remove(vma, range->start, range->end)) {
>> +		mark_mmap_lock_dropped(madv_behavior);
>> +		mmap_read_lock(madv_behavior->mm);
>> +		madv_behavior->vma = vma = vma_lookup(madv_behavior->mm,
>> +						      range->start);
>> +		if (!vma)
>> +			return -ENOMEM;
>> +		if (!is_valid_guard_vma(vma, /* allow_locked = */false))
>> +			return -EINVAL;
>> +		/*
>> +		 * The VMA may have been split while the lock was dropped.
>> +		 * Handle the part in this VMA. The remainder is handled by the
>> +		 * next iteration of madvise_walk_vmas().
>> +		 */
>> +		if (range->end > vma->vm_end)
>> +			range->end = vma->vm_end;
>> +	}
>> +
> 
> (separate rant - that we have to a. know to do it and b. write duplicative
> open-coded crap like this is a perfect example of why uffd is such an utterly
> broken mm feature that should never have been merged...)
> 

But where would be the fun in that... ;)

>>  	/*
>>  	 * Set atomically under read lock. All pertinent readers will need to
>>  	 * acquire an mmap/VMA write lock to read it. All remaining readers may
>>
>> --
>> 2.39.5
>>
> 
> --
> Cheers, Lorenzo
> 


