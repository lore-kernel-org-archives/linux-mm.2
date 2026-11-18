Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E404606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=nkgzzLi3;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ooIQQDG9
Received: by kanga.kvack.org (Postfix)
	id 634F36B05BB; Wed, 18 Nov 2026 10:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C0D6B05CD; Wed, 18 Nov 2026 10:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC866B05CE; Wed, 18 Nov 2026 10:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23CFC6B05BB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:27:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71401407AA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:27:02 +0000 (UTC)
X-FDA: 85448617884.15.8AE2297
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id C5ACC140003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:26:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nkgzzLi3;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ooIQQDG9;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y03Y2WW5oPTNmKuWLrWXmR4s/hn2HFIbPEH/c3XFLbg=;
	b=yHmOQMUFshIYAP/iTX7dr0eVHHn+i1SENnhoZkjd21lPbf4+Sb2KATHLZQX57B15KO/Px7
	31SDCF07LakRtQ+LlVg3yhL91E4fcHhml6BX36hd3NGC9A3nunL/pLmXUMOXZwq4sfGOAj
	2ujuQv5mE8ezp0hz6SAf7Ecy93O+OUQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nkgzzLi3;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ooIQQDG9;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015620;
	b=eiNUTaMMjbWmp1gQBN+U6oeIZ7c0/JIC+CCUStNDoJm+1juZ0rkBMPpg26VijMMav3TJsA
	mg3oe1J1bYw6IqLsi9msm6B3DLw0To8wX66UP5JnCxFgxroeb3e+zkuT3NzoZt9eXwUSVh
	JMyF3CIcuwJyRY9lMMxoAbjYBsIUrQI=
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIEgIaK1027178
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:26:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=y03Y
	2WW5oPTNmKuWLrWXmR4s/hn2HFIbPEH/c3XFLbg=; b=nkgzzLi3h9HeG8fKyYEG
	uDh31vyXH1oYKrz4We4FN7MFzIgxKgw5bbl/1yYWvjel0KI9TY0DcA4tf8wyHfUO
	E9S3VBpfvNnGIkq1nWd7rxaJV0Lqs7OrEOCpyx0/oBVIQHwhYGWzDerPT+uUwcIw
	UNDOHrTbQpKsrdIawLbTecxwoOgThMzBSetvGLfhD1Fr+I+bJ8XjXzV/tn3a/mwj
	WnmC1oaXxkPmI1tAL5NMf/NM2XxF0DEM+oYOVbl6k3afNC9MEBBmKm7ao0MfRmEk
	9PYcQAKRmMuhT+Cw6VRw5kLAg34WlAdslNZkvKUYJ/1MhKqj8LIxnHzWfAB0TDWa
	AQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu5ceqc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:26:58 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-945b0154705so165674685a.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795015617; x=1795620417; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y03Y2WW5oPTNmKuWLrWXmR4s/hn2HFIbPEH/c3XFLbg=;
        b=ooIQQDG9H+u+VESIHNH3rIj1ROLV7S8/wgrUiQG5yYDMOwYgIIWzd+1L6ICPpgBhLb
         /d9qRPAuhpqW54s4PFn3Q3CT0iyELXnCl5zWFKIf7zJ55k2gIo8q5xmfvNvgNsinbgts
         xeHyHQq3V073IoHAwSZKK623KOqLOx54V8y04lC6KcsotRqSkz7VJ0+mrJVOk/4yLD65
         L8D/cxTcepR2QMj9JLbNnEY1ujwQSBwBhjDfdgVmNpbYQ1nMMjgHHLf48PA6zY0k80KT
         MHbNdswSI4j0OLJWiVyBYBhPKppGEkWR5LySjOrTj10QCYiNbHk0w2tME5fjGTe2CWXv
         Jl9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795015617; x=1795620417;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y03Y2WW5oPTNmKuWLrWXmR4s/hn2HFIbPEH/c3XFLbg=;
        b=Vv+TotpEp2HeICBG0Fz+cON5c10KeWi9oxrvztBHU3Jffosowu713WAJFUxqlW1rTA
         MVXPNHA/FhKhULBzdLtMEKaUZT+F7FLkRqYuWI5/s6x3HHtLT1DAwdp3DT+jPSep42db
         HqLn9kYk2/nI/4/B/vSYiX5t70uLUTb2OX99QGMZ+T/8I9dHBaQQuVjbRchAP9WmoNWW
         0EjpAMJViOj4DiV/c5I/VTpiCz/sGqDyfeg6p8Jae06ZsxN09pShhBo1WxAY1sI/1uzK
         jrrGhdi1zi8qd+aQ7G+ww7yrF2psP4iklJd6TODVUW+GP9JSesrdUg1abityR14x4s3i
         XLYQ==
X-Gm-Message-State: APuU4Z+KPczSV90sN5Q6VScDyawCcdo01QIrQWEWF/tM89AopWkk/sUb
	0wnk5H7EC9qemjMAfSvrR+BtX24ftz7NJEW9xH7+c9ghLsKjcmHP0LnuCGm97xw5eXXYI7+9F3L
	yHxiE57a513e4EBMp/3WMJTS+/tqxyjwRC07KcsBFYN/UZ3Wd
X-Gm-Gg: AYBFou0FyjHh8pl/ZHtU7KQ9rBgXcq8qNFH0qfte0hUSc8nqu/3oxEAmYVl4SU4TF+5
	Or/AFcSzK8e4yluun7DiLjL3tmWL7vUbM7dRqvJOiwN02FYiGoET4eOpwzWCVQmhitbpjUupyRc
	5+0BSKSTWV3Cx4psA1MJR3XAVUYQKcH917U4GAGclklPbSHUooi6ItlzRA5KCuOL2zi3jiYIRuQ
	J+N0wD7t1wHx8yDXq258RDEFsn3fpJ3xOhYKG72ESUHK0jqq/qiud14F+hNT93q1AHgs73O99ab
	iveSKlYcEppZFI2jfDQEYZSu9jTW3hRYWQV5oOo3VPSzwCY4zRGXJVFC6xMU3QwZOD/csVKRPSj
	i8SEmdK+rd9P1PamMbAe5G41bMrDaEqBfHwC7dAXZBSBOYeT9zV68OsovbcBvSuH6HH6+xYrW4m
	U24EkUfFKPUN6z9eHzb8nk1A==
X-Received: by 2002:a05:620a:8395:b0:947:b201:faf9 with SMTP id af79cd13be357-949995f04bamr536124685a.59.1795015617449;
        Wed, 18 Nov 2026 07:26:57 -0800 (PST)
X-Received: by 2002:a05:620a:8395:b0:947:b201:faf9 with SMTP id af79cd13be357-949995f04bamr536117585a.59.1795015616695;
        Wed, 18 Nov 2026 07:26:56 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-14.net.columbia.edu. [128.59.176.14])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b72055bsm204599485a.12.2026.11.18.07.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 07:26:56 -0800 (PST)
Message-ID: <7d31ba34-8b5f-4eb2-9864-145ea80c3412@columbia.edu>
Date: Wed, 18 Nov 2026 10:26:54 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
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
 <4f23b0bc-b89a-46c1-b8cd-853e7815b7ac@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <4f23b0bc-b89a-46c1-b8cd-853e7815b7ac@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: NJYAi16awPvtzfJQaNnZYDH-g5X53Dve
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDA2MSBTYWx0ZWRfX55ThQg2OPwpA
 RYEFErK+VAgA1hooIZasNDfyUi3ubRo4QjHiS5J/hk+MV8Ku8n0e6CMhMMoltz6Ddzd7gxUWSlV
 5uhmZ/2oExgWBSPz664mkvu6ndWtgQIIBEtMY2p8w4Je5viF/JDH
X-Proofpoint-ORIG-GUID: NJYAi16awPvtzfJQaNnZYDH-g5X53Dve
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDA2MSBTYWx0ZWRfX0dJ6IoKbQ8n8
 slsSjns+bf2DTHgpZ+oUy3PS6UQ34Z0KRxANT51mkubFz3MthpyY6aZz+uaIMtQ3DGZmvcpTLB7
 90nivOZGoyQn9S19ksOCed4c33pBU8ayJL+mujxZ5VzhKfgRNNOQmrpUeVzsO7iqmIgSljt67Yy
 VgR6uSoHUzO9yexFGfGmQcPuPlYxl0HqNdreJeYdpYIS4sKORsJq9wMpz5U0TdUK7tVGT31oYJc
 kfoMQIwZ+AelZzRomn9WZnT7GqWZszghxX3PBBLOHoODfVZqeT9ImDZZSQ1m10iuGPpEf6pboa9
 8NVEm1WVw8jeVsMiCT+Ws0OOGkrvhbTil060tQHiRUpsgDkmI6g+9FVlGnWFbXxoxUQgwOAN36K
 a949LRC2x20jdgwaMU7Jod3keCh/Yz60D0fAeZ9x04yzjfHijmPoLLWNCQ3XpDUgnvtGnfA6GMN
 UHOUiRw7LjzaB6pVjxg==
X-Authority-Analysis: v=2.4 cv=HtPjiETS c=1 sm=1 tr=0 ts=6afdc3c2 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=2zM0HjzktFauw5hoOd8SpA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=Z7cX3StJxvrjZLnT-lEA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11970
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 impostorscore=10
 suspectscore=0 malwarescore=0 bulkscore=10 lowpriorityscore=10 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180061
X-Stat-Signature: ehb8tgfxnrgjanu6eqekk6enockdtmfh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5ACC140003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795015619-450175
X-HE-Meta: U2FsdGVkX1/v+BjFtqvrw+P5Uphf7wLNOfJsROgwNf0/tFifSKhuHLnimsDBs7Z69Pdwy9L97vf6hSlGq7Ua+YlA+8e8v3QuzYZxryHO7ShS/+ubrnyja6g9m89mtt7QXhD/RnU2n9szVRdGQh8A/xYroSISw6i+xWStAv3xpDbuFKKbiHGoaDoLfuC8Mo93rxCzLOmmzoMGVLCBrWWW6vrKeIgADq3boRsPWVtC0sFphyRlWy8TBcSe75uoF8ep6vRSpKsmmT4ryeoldPJob99bdZXkjgllmuBX5E2sK1wPWZrBJ/C8I6bY7T5X/ovP963qtOFcIeLdC+1+Icft4mgNFne2aVzhlcH0yhXyoALBWHFk5It7KHsAh0gz8lULdfn03cnEt1f08M/TIlnwNG7xL8lfXCww+j1lfw7yZ2sjD63g9FBHtmYP8O4L555Sk2gadv0lDa1tFGVAdpIseMEojLbb0bV+k8Hw5raAqkXeAloYaRY9jpvyZXodDab1S8DsFran1IH3ibytJlq339mKKEagD+LJUlIu4jzxOyjhz0ZdmTW6xuY2JTfi36Bf9J51eBlDnhnauzAekKPsl7HicXZ4YIirv5aboAATxy4V0rwgJ1/mIK3Gu9j+cEWSxiZkwqZBXRiEcRWIavbZLtc7q8+Cp/Pj8CRjxBiJ8hsPLFoDbUkMbCjXgLIvSxGV/YdGQ6sbbPU1dzO2prpJVbRSRNPOWeXtSknXZPq0Q2AfWhKYM2E8pYuakQR7xlPsdCEdwwKXIYDRlEUNIuyPxkZ9UfTp6IF7XcI/j42Y3LkwnRo76qxnwE078oX87OKdKI69li9pvRL+nPHv9P3/jsaoG6UqMx8CzhnSJ8J8qguTh/mu0ZbnZnZLdydOrplsKKI22Nq9NzTC76B436l6V1PUhNbxHLedczNnSZNw4sRqlf/lq9doRYqd4jgrExtsbYTbVd9Wx4wR+joKq+d
 ERyDg5+2
 5Rjg5qP4IJc9J0RQIOw0xgfn6X4Jaoe1NTAVkBm5bKWh75Inku613kOBBjoTda3pWYnyhAExq94ZogUuvJVhgZPAtHvtmoGBC7dCQoX0QeiCKg6SNu/ISvfyYlotHhN+s9ZwuK2EiVIdxOPlQopgCB8h8smmbE4D9En5mJ+tUEJUnOsXOdazcQm6sT2bYp+BJnXJs7Dmmi8K1hImOe2EMyVHthgBNnSYWq+dIJ0SKd6YXyFxZjlfSwJJO+7UVvMCGb4LgkyX5GBIZTd+74uyfVIbqDPVuVThH9743QTvIucT2WsDALzWkvOrx6VJvbSBkGKzWU9cMWbymjr+WfYkXJU3jR0pxUMxZ8X9KKKMzW0BSK+Qai6UBXY8SqDul+7p/kAHyXqjDOBMGYikZq21fIWjuGhFioYGEsgb16YzMgTJxouTIxIEe7HEo9tlZS18Gg+4qxNnFHa09g+wi3Hl2vrUVIK55VbZFb8MVYlEeUuC09wI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 4:41 AM, David Hildenbrand (Arm) wrote:
> On 11/18/26 05:28, Tal Zussman wrote:
...

>> Patch 6 has little user impact on its own. It is included because,
>> together with patch 7, it allows removing clear_uffd_wp_pmd().
>> 

...> 
> So, I would be picking up ...
> 
>> Tal Zussman (9):
>>       userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on private file mappings
>>       userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD
>>       fs/proc/task_mmu: downgrade writable migration entries in PAGEMAP_SCAN write-protect
>>       mm/migrate: warn on a writable migration entry with the uffd bit set
> 
> This
> 
>>       fs/proc/task_mmu: write-protect device-private THPs in PAGEMAP_SCAN
>>       mm/huge_memory: build the moved huge zero PMD from the destination VMA
> 
> This
> 

So my one concern is that (as per above), the mremap patch removes 
clear_uffd_wp_pmd() after the huge_memory patch removes the other user.
Splitting them may break compilation. I would've left clear_uffd_wp_pmd()
alone but then it throws a nice ugly unused code warning :\

>>       mm/mremap: resolve uffd state when the context is dropped, not during the move
>>       mm/migrate_device: do not migrate a uffd-protected zero page
> 
> This
> 
>>       mm/userfaultfd: check the hugetlb alignment of every VMA in the pre-scan
> 
> 
> After waiting a bit longer for more review. Andrew can take the rest.
> 
> 
> -- 
> Cheers,
> 
> David
> 


