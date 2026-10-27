Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6D0606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=HWMW+LuC;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=oZliqJ70
Received: by kanga.kvack.org (Postfix)
	id 1761F6B075E; Tue, 27 Oct 2026 14:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1274A6B0761; Tue, 27 Oct 2026 14:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A8E6B0763; Tue, 27 Oct 2026 14:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1C8A6B075E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:04:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B965140AA6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:04:08 +0000 (UTC)
X-FDA: 85369180176.28.3F29729
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 67E29A000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:04:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HWMW+LuC;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=oZliqJ70;
	spf=pass (imf15.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793124245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbwQln0osS5Ody02EmE3zfTJ+96bXVyWs9ItOG40Y20=;
	b=W2piTMeuYDKZl+f+ju7X19H17kpvi5RCZLtr2ws02UGkQIaI1r/DZ/S2vJlQVsDkrbWQwU
	ns5B1IvZhXPNa6hflnINEggtnZDkv/yxfaxbmQvmH35dm/uz2+EXvPJ6naV05I+pR0GG4F
	Ew21iZBftVNhAR1cwEChT6ExTVJO+0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793124245;
	b=IkiSOZRhUbRsEKxWMpDbFBKCWMRGqraQjv2zsj2NpU7+wt0RST4EHLoFH36sIqIvliwUCR
	7p1q9iRYj2c8JO9rHHt2OglzIFgZ8pMTTo1INCQh37jfeVBsLa+1/zwTqY48AaPtdp2Te6
	7DvNdyd9PQCcr7dtJ/6NxjzX/fvqOaA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HWMW+LuC;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=oZliqJ70;
	spf=pass (imf15.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RHh8XH1050150
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:04:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=CbwQ
	ln0osS5Ody02EmE3zfTJ+96bXVyWs9ItOG40Y20=; b=HWMW+LuCz6utW8S/VyIJ
	rHuo4CHhRhfcBnkgT2it5oCdt4YIlLKc6jaoFTG6NBRm9OQx8/Gj8cgBC4Do0iWk
	mAEHeGX4ZEQrgjmx5BHUqwprw2uw/fxZQF3p+JzRElcb76yXcKt4GQvOnFFzOajv
	msygurYhvvDfEXZY1Y1OFRcS/MQ3DzxL1Zn7WjVKu/boL2iCknUIbvotLMEHVOFn
	8z9EcTAubn7A/+OQElkqnT0CU8euYHGKsuMyJovfBE9MpfZ4akkMjYw62aGpHRD7
	9NYu/mzCxLPH6caGTchbWrsAFJNSQvq09+77FlRkr73QTb2lnAcZCq5a3XUaooGA
	UQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hjq5cmu8g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:04:03 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f2005ce21so5672685a.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793124242; x=1793729042; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CbwQln0osS5Ody02EmE3zfTJ+96bXVyWs9ItOG40Y20=;
        b=oZliqJ70fsFHX+KMB3I4gDbUW9n7jR2/AH8UHPRrDUaXJHjQsyWZpOgg/Y28fcN9hX
         RI/eDWcN522XTUZJNS3KBCkomsKi9jKlkQFPOBkIKsYudl86yZEN+ljpna1WTWMH0QoJ
         kvif88FkYAnHPZA1rboCjNRh8JDy0T3kIg0Ta7CTzYP6Uj7h3JVGCzZcYse+e5srYMsd
         UTRHJRWXCaJhEsPr7Nf51ou+R7snOUcO9ufOjgrr8Wu3uSiL9GckwvLEUNR71iudzQIM
         AdsV3/WgFqhlfNxF691Lzw/eCvZ9V6Y+vtJEjIuHZgfQQs75XS8J8MEWFFSD/2sokLl4
         +n4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793124242; x=1793729042;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CbwQln0osS5Ody02EmE3zfTJ+96bXVyWs9ItOG40Y20=;
        b=iVth0G+fnooLROLbyfehX5O+1WqY+JNrxkVH2gyMsRCHhMq246SVqgkO61v+SEFqK0
         /jL4Noh4WyeJ6h3DblgPaFiuePdRcOFbywmoCZt5EOctRuufS2G0P8LlZtPit8ImbD+Z
         FKp3Shzvgxwds9v+pmNcpH/4HhzToslCqaaQ0t5R+oH2A0EK1+DL/VJBQhGa8P4+tx/1
         mLNqPvc1oI0pe2fxvAulV/c6SknDjBdYY3uSuql9C2yxnscvM/QXEcbYO1O/Y41MJTzr
         5/pg/gsjQiMf9z5a7nZOdUM8nfkGMlPlIPk03B9j+6/gcX/A9FMBH8AwwQJnEhjezKUe
         OlIQ==
X-Forwarded-Encrypted: i=1; AKwUvBw9iRJQImJPTcS2C4uPImOcdJX4zb2EjCc1PZMaBV+AhFcsvjZwP4OQ8LzWqsX/GGKJuyMp5NbNRA==@kvack.org
X-Gm-Message-State: AFq9FYIz76SZ57XKU6T9hPY/gPognCPD3HWnSHdEUMhQf0l4yTTMOIS4
	hpDjNHI/64JcK/VjPPxjH8cd3bSjrP00qKIm3WlLQYKNh9+i7fHY3cbC9O1fnZCkuvaDRfkgcYR
	SshthEVUWEZ5jFHNG2tUl7fUlsFU4d6BnZrcrAtdkd3RMhxGK
X-Gm-Gg: AYBFou1g3z82DYp2keFux28A6eCZiyW4Fiekzm3BE7Tkc28BPsWVSQYUI5kk0hmHZvY
	TD9a/4WyLn/zRSUK/Iozm3Y4a6rLWeGanEZesvFvvOB3mMwglik1fpKxjHjIb2M6YM8lBLJMQUO
	1kiU5yTGB23cGJAfnfKkPsVs4ApNV9ES8Fcd0LNrS4WqGm/dqDC9i9+pyh4WvhVbq6DVhMdLNsS
	vj70A1CbWb4xrHxoRJkR0d21QmpCJ79ippY6SeBnZ63dzaMoH+qG1Ym4M5kU4w2dV3jV4ofveDb
	0MDTE3PyWSA1bOwZvniUjyuIANiorpNVyDBx0wXMJP7oQs5kisq+N1edWlSa2wWgFNXRUPdJ8Ew
	OuTTaNYrRgEIIHjbcqizqqILXdnrEHt6rTW63qAht3T4A/BZJs09lE9fdCsO499neJG4dt7iMFr
	xZYTDaxMvcxQSmiB+w7QLU4tn3kvQUX7I/DNeyM+x/Rw4tZEzSDGD2wDbo4FxoMNEUh/Yyrg3dq
	+GurgrGyieNj+8=
X-Received: by 2002:a05:620a:2a06:b0:93e:c12c:9dd2 with SMTP id af79cd13be357-940ef9ed966mr1547495685a.82.1793124242358;
        Tue, 27 Oct 2026 11:04:02 -0700 (PDT)
X-Received: by 2002:a05:620a:2a06:b0:93e:c12c:9dd2 with SMTP id af79cd13be357-940ef9ed966mr1547486985a.82.1793124241704;
        Tue, 27 Oct 2026 11:04:01 -0700 (PDT)
Received: from [10.206.51.58] ([129.236.225.183])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a94a5csm1037624685a.41.2026.10.27.11.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 11:04:00 -0700 (PDT)
Message-ID: <208738b1-35df-458c-9955-e2e5318fd2c7@columbia.edu>
Date: Tue, 27 Oct 2026 14:03:58 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/46] mm/huge_memory: fix list corruption when
 deferred_split_scan() races with deferred_split_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Hugh Dickins <hughd@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Pratyush Yadav <pratyush@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
        Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry@kernel.org>, Alistair Popple <apopple@nvidia.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>,
        Matthew Brost <matthew.brost@intel.com>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
        Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
        Gregory Price <gourry@gourry.net>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-cxl@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
 <auCw2-_yjh1_RjiO@cmpxchg.org>
 <5d431bf7-8813-4e2c-a40d-b45d4ff39a5b@kernel.org>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <5d431bf7-8813-4e2c-a40d-b45d4ff39a5b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=K763jCWI c=1 sm=1 tr=0 ts=6ae0e793 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=TdXXog4ttPu8yHJGq4T0ug==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=pJWPUViXIfCbsMganCcA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=zY0JdQc1-4EAyPf5TuXT:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA3MSBTYWx0ZWRfXwhAgJ2vWyoj5
 WgcFHkzUoiggcj9azv0YR0FA4V4O86AMoKyfdpRvhQBkKZ5CcW1jTgRaReXjFH9j0MB4uHWADYP
 Ck1hAgQoN+vF7aj8dPclY/BtrePat9Z56IowfOAf1HgukbSB/8MpCc0ePzcLc4GgsKDWgU8bmgZ
 Av/Rk7TIy2+i2cH6EayGmYrrqSzG4ERhqZ09jivYAqqH3k6TCYMXZrgRX0nklvLnY28hvCOM9FZ
 ElAapJLxf/sXPTS0NoU72rRZQk5M8ocRGaw7MJTdrKoK915KZl1Ccum6yW6H1Tc+SJIneddxc5r
 RmcKlS9iggE1phSH+csyopDowZwtAF3j3pZvsGcrxKMK/iFCrbT+MIxqu+NT5k9FWiPKjdNpqg4
 ET3M3+a9CSBOP3KJMO6ffJO5t23Omz/8Ebvv02qfW5jff9TSYxSjzEwPVVSsOqsArPqzXj/AQJF
 j/hkhf69QlvSxgIAc3g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA3MSBTYWx0ZWRfXy0XAGDmlpWR4
 yScWXjEkgCHhuX1rJwrMtjoQsweh0XMGK8iVSWtwA+PtYp46euv4I+6TMrmB/ACQVBm3S4PScWj
 xGx650Q80n3WoilwiPxdvkZzHiY9PDUFlZnYpj3hmm0HLOOwezq8
X-Proofpoint-ORIG-GUID: MRv9psNobms2Fnze_3LPkGkFDEWB0B7M
X-Proofpoint-GUID: MRv9psNobms2Fnze_3LPkGkFDEWB0B7M
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11948
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=10 adultscore=0 bulkscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270071
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67E29A000C
X-Stat-Signature: mnzp8zotwwzq4mf88t38yc4xmhhpkzzc
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793124245-485727
X-HE-Meta: U2FsdGVkX1+H5l4hhz5tjtdVtEI8i+CbkMFQ/KklNIJ+HEH9uQUXl1QQOz/ekVBH2PZW12JnQ4dLHdyGQAUHgnrneU3wFwp3qtOxOTIvCxXXYzUKWrxSG+WLHnr9MRHFZpuRaDsEhxhqT92U1QPpphgadlYQJLS1V0O4ecQ4kHQuoAKuUNDnfeTenCfkPbitpej3TzHfTPRUU/BFzCgVtIJK95BNUE5mhJ8V3zXeTrHsBhwF7WMY1NeTSW4dOrcpq//9yys0uFu0x0sAEY+/NLvWBi+XQ2jog8N9TY+t1e+Me3g1S5uQ095lnf4/94M4Jt2BeYZG/2m+t9Ne8LYIqBfB6rOLqoytXRBwgjCJHQkxvjtYe03GkSUCovJLxbsREHrTj16ilafekPuk45qFJSK4jF4gJlfL2i1Ga34x25Zq+CEWeGaghYpsmGr+OuU2GXfiwdW1Fcud3m0c6fIJcP25p5WiyJrvSIaqw1PWyPFa/H5G7lCH+eTFJ9GIW+rQUmGl5xvt8s7fIyAgp++SIuQZQovlXDvRpDR83/IKQD5hP3/EVIUCOcszAsFeZGc2X772x7a5XIah6lS38YVw1Ut8pVJSXrfuCUfFJtF2fkWzHiIkhwHlr4g8ATS7b26DIvoG8BfScZQePILrnkIrVXu9i0KRwe0TiHYkJhmjLOguGdIb57oMuHbuHoyr8/uClSaIE3B+Js+n+4o6ZpHmSwOfLN3cIT3G98lRPOO0sO1CMXc/BPyw8ooTP/XSrnO27LMeYLWOKOFNi7C0Cz6Rn7BuOnNvdysbG6AHvfA39Dc1HcWsN34uphIRUhStxOLyalc6/9ck2K440vaHYc6WT1Kp/INdZUfFwNfX7EXJrFCf4xcXO2twbaB9dT6U8fV7OpxzQYB2VM+qAVk0uFK/+04AqaizMniq0DU6Sn8Qt1QQyCn8e5FuEQtKpkEBoXF8pBi/kxFEsWQPnQbUzcg
 7dB+LoxS
 q8mSC+C6Va2/7hZripWIPTItXT1pwtLH+SmQggDcgXwVyNwYZ/V7spnWFb5iavUSKNyKtOu5HGPXO6Lq8VWZXsQqNLWPGRVotjwyVEtIQedjsRqNB4SI7TlDUIP4/HP5jiCI9l/uAxHpAGZdZY/7jisUvFj4pac00kEVe4zNVLU0TSeuRM3y9fj0++pJkvNIDOuWJLlWSeGuwS6Xy2TMNo+Vzy1SbHEIMQ5B/TXnIFZgVxwI85c5/RmQSKs1AAs5g1UqZAAuOK0eqPtmA+Nla9euwzLOgu+pMEiQ8m0PT8JebBAFM/x/GSdWBW7/Ej4tZWdPLYu3oglyDnEpTJjnYL3blBw4TAyiSRIdXxZ0EIc4pXVvdpXWgKbBSd5cIKktR5YwxK+aVKYv2oIxatn/cFItyhUBXq1RIg0gWaUCpZGOchyjMeC84dTQTSeLxTVFrMYQzk9wqK6IzYMssKTfptWgd0LAxrDlybIAqlUJ1wBMe36Dh1jdTYrEKkCnH1AHQkg+qRwLYxwSzAbrs/wxoqv/k8beZN90kQhcOsIG1uC1InFRvbaYvrgYJuVRvsNpZCjWV6sshPKN3KkeeNPcCVGN69A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 11:15 AM, David Hildenbrand (Arm) wrote:
> While I have your attention: This variant works, a different proposal used
> 
> list_del_init_careful()
> 
> instead. However, that is documented to require list_empty_careful().
> 
> Do you think it's worth looking into?
> 
> 
> https://lore.kernel.org/all/20261026-thpsplit-careful-v1-1-d357d70fd6f4@columbia.edu/

In this case the careful variant is fine without
list_empty_careful() since it writes ->prev first
and then ->next with smp_store_release(), and
__list_lru_add() only writes to the entry after it
sees -> next == entry so it can't race with the ->prev
write anymore.

But your version also covers the PG_partially_mapped
race your comment mentions, which mine doesn't, so
it's the more complete fix anyway.

Thanks,
Mani


