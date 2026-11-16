Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E12E606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=h8wEBqzH;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=BY0+dGMs
Received: by kanga.kvack.org (Postfix)
	id 3A7896B05B3; Mon, 16 Nov 2026 18:00:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F5C6B05B4; Mon, 16 Nov 2026 18:00:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F4C6B05B5; Mon, 16 Nov 2026 18:00:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00E136B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:00:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EEDF1201F1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:00:36 +0000 (UTC)
X-FDA: 85442503272.03.FECCFA4
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id A8F7A4000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:00:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=h8wEBqzH;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=BY0+dGMs;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DrgpmsI4pZAgdTESjomnSbj/5rvp+0MEGWpwnCYEqBw=;
	b=xijLBOxqWv+HiRROhBxaYJDaFoS7zNLvUUgWQWKpz1uW4UPa2ZnEiBpvzalEXzAMHhHhFS
	AjulPusvEJtfrFua6wlSmiS7dJSGaezV2FxZIsN3a/88AYXytMNESg4HnNrH2GwHZbKyJ0
	EppsBF1xYnboPY3NjPR9CF4IF8eeeiU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=h8wEBqzH;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=BY0+dGMs;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870033;
	b=H+JGxyRuV27qgxyz/EWmX0zqV67tU9PyrsQsoSBbXbPWIFEca30GfmXea6od3lt/vURDoU
	KNAJgOTtQhH3hkHpmE/kLKarvU/I0yYCgTGIKKpLIZPhWUEjDazGQWZa1HLPj/FSXj/QVD
	eG3GIYglUxzbUWhj9ioJBj1dUT8jB5o=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGLYkn74083946
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:00:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Drgp
	msI4pZAgdTESjomnSbj/5rvp+0MEGWpwnCYEqBw=; b=h8wEBqzH/LUQm2YIPDam
	ND7PzYl7uX5hIzo2H0E8IKDCqczu8OQeKthgNbyHKXTJfqvSE1AtX7AAH2ET3Pu9
	oUi+s/Tw/pGr6XbXNsOFIHyuqVr/eymttT+JD9lfGEIFvEU+t68KaAfZMGuvgZGC
	EPqnwVbxA1e/RV0HrgZFSYEQGufXuJyADNwvF7rXlwqDTv6a9rxCno3HtH35BVqu
	dNoCsC/C52eCB/S5mqu0BE1pEp+1BE45cBw9QnZZM9wJfJxApwozwjL0m2qnxzYi
	h3Bmq/eFSDsyc8J6WMJK8ptkqkrqft3msvZ/6IPtZShkIH+QA63FRoOsRbuLRZ3q
	ng==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j059skns9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:00:32 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f32050e72so1121056785a.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794870031; x=1795474831; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DrgpmsI4pZAgdTESjomnSbj/5rvp+0MEGWpwnCYEqBw=;
        b=BY0+dGMs+NhsymQXwZwRNvCg0h9wz6Zln44HfUF8Z+85c6Mr7+7TlAT8zOUFz6D8tZ
         psgLkL8YkY98A2r7nHI7Z3ixy4ggtzJEqICiLC0hzDceLDvfidXuQqx7HL/pHZKh0ief
         oak1NvVRQ3XRq2oJyTHqCakrXgRCEVnRoGi4tKDJbLdO7ImbOG2Yw/qhfyyhV+CNx67L
         rVy1UIVubgFX5uzNdVXh7EXlti1zs6p8M94hH6UFRNoMpmeqH9K87J4kYGc5C9J0lXnc
         gPutEiXXeH7vQTJlVqqqpQxY9ro26zD6Ff7R3iac+zXIR0OuAA86WPYsikyl21yxTE+5
         /JUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870031; x=1795474831;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DrgpmsI4pZAgdTESjomnSbj/5rvp+0MEGWpwnCYEqBw=;
        b=IniXbY4uegg8E9KOpxBek2m2VDoszxapnMnjOC55pSjo2ULkgX2sjZdL/oMEUAg3Ou
         4XsnCEER76XjzGhtN8b9fczDozEVuU0Ot5auK3TLmOpnxLxiXCCM61mUT73U59j8vfJO
         wb2qPhHukwb3lZdJfwwfOInPZXtcGq5ZtVkG74244tJRS27d4lDWniy8E3OFV7EV1Bno
         FD4DJRGpdjRZOot1WqvmHNQlquedshhKa69K4SIWnh0PEM1QV/V/cNgZmJlHJkxDN2nt
         Vc6gO1mhLOsAeD7X8IbCg7T4gK6m1G2f6ZEtUYX3dm8dqE0s/ptAZARFwAGjztQBmtBe
         aI+g==
X-Gm-Message-State: APuU4Z9T86w+mswkW/yW641eBnRkY3DJlf11Qj+K46M5eSFMajCdQZc9
	2O6OeT5ZOD+hROweiM7CET8xTrLgJlbUnuBqXB4gVbJoWWnX/qMGBjVCrpHI4yigBZZLPnOwiKV
	ioeY5g0mOaztEarsr4ne/E6Ea8TvA/jbjyWAP1oqd/L1zEOOF
X-Gm-Gg: AYBFou3jzfufwtHw/SaebEh11xU3uKsi/xSZjjPn59NnUkYLBAo0AOYP9kaA4l6W9Os
	n4DoojMgL5LMpXCG5LOXiNNXcnuEe5Gy+jgU4c6CUsYXfWBk05qvweSUpv3Ifer9734fUz+ZcXP
	mYDSrB0OGByv/xgBmtakboJNObynflqif5ETXZvuGV9VD+9NGl18NWRaQcXHGDYnwb81+JHUgAv
	Aw8qDJazCv59TQ5uSH3++1q66ckH2EBGUkqJ7Nowofg3lXlnEpY71jAGb6IwMB58lpRlhHakLB+
	5qJSa36xFcLT9vBKo4cXSZHioFM+DFMBZMje4oDI6ahciaRxwdbNs4uMyOmwaE4eU3VCwZ2K2dj
	A3/+eddY/tEGpgTz0NCK33PRwaYefqCQ2lIuuY29CkEhvWO5FQH0GrxdRKr5LI7e24WwuGf9SGG
	Ui0hsvJOmxBVmLEoQVMQ5Euq4m
X-Received: by 2002:a05:620a:2a04:b0:949:733e:dde5 with SMTP id af79cd13be357-949733ee773mr1059321185a.66.1794870030843;
        Mon, 16 Nov 2026 15:00:30 -0800 (PST)
X-Received: by 2002:a05:620a:2a04:b0:949:733e:dde5 with SMTP id af79cd13be357-949733ee773mr1059311385a.66.1794870030135;
        Mon, 16 Nov 2026 15:00:30 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c831b7dsm952569585a.20.2026.11.16.15.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:00:29 -0800 (PST)
Message-ID: <c9d616f3-d442-4db7-8010-82aa052baaf7@columbia.edu>
Date: Mon, 16 Nov 2026 18:00:28 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
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
        linux-fsdevel@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-7-4397a0196479@columbia.edu>
 <20f100af-c831-4e37-8077-50f6366f323a@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20f100af-c831-4e37-8077-50f6366f323a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA5MSBTYWx0ZWRfXzqRhTVnO9wiy
 R7ED42KoOzf61JNOseykRs50Kw3bmjdPpBbG/zviC7AQllvZRzoJ9wkjbxzHI+wTF7ap8CrHcCa
 Pt7wnWjYfX3PZJ9PCwSRt3Q/IkeibtIon42vZyJXzQoPPKv04cdtNS/OwLmSn/y5r3HD8CdcF5Q
 eFCZyHfLv/r/YtLGOX+qlU23OmCChkdWEQXN4brZgTXN9k7yGjEQX/JMcyvKGv8+2SnoAg8pyXo
 eROjpNduB5BT59y0OqFIvRIedlC7vtdu6S+MyOaHLtt/PBN2ymaDu+Skr477YH3j6NWU90Xqte9
 DxFTagzG7ivxP5VzL/50i+gh+Zx7Xt9eX3BBLeYVJ7FgPRQa7h75fJEXZv8j5yDL66rGDofuvpU
 ps/Cv9CWjQcvum7LlNIcNhhMzEx7oxJ9SmakuE8Ta2DLzKQo5Nr/vy59waWdHrqICfZiMa8P5JB
 jpa20L/Do0jk4NZfpaQ==
X-Proofpoint-GUID: q1cr9R1FHQmYG2GdI-5zlnkSgMg0YaQJ
X-Proofpoint-ORIG-GUID: q1cr9R1FHQmYG2GdI-5zlnkSgMg0YaQJ
X-Authority-Analysis: v=2.4 cv=X6THu2Te c=1 sm=1 tr=0 ts=6afb8b10 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=tHa68p0SAAAA:8 a=7zGzU32CvNdQK9yYqCEA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA5MSBTYWx0ZWRfX88BHcGBtVUXf
 sj3Ya7PiqzlLDoMwZ10Yj80+QPxadBUtjTUqCiCci5X8aYeMVsTFxjX1r7PbtEVfBsbIqCHr72U
 8BNwu1ITbcgkv6tIi6VxYfQyYic0nFUGQ2gtT0bND1Z6gmcElnNz
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 phishscore=0
 malwarescore=0 impostorscore=10 bulkscore=10 spamscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160091
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8F7A4000D
X-Stat-Signature: artiungwszhz6x8dajahxh3jexh1e6mo
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794870033-806832
X-HE-Meta: U2FsdGVkX1/jbYYZ7dxV/MWViwUiWiAXc/9PzwqFf5C0nSqzEtK2TKgoDvtIq8LEM6oIw+Se+RqM6x49W6Zj2IpRJYmpAnFx/V9AHGcq7W/03+UbeYPYicf7Zyk6YF+O0otnPwTBvnzFl2Dfmq3mQsCjxWUrc1n+Gh61UNvC+4vU46PiEuqaUB/8zK/lDn3PT9CgDkwdQ9xMwoiddFh1tWhH0o9ZsFkaax+uHoUoGgHVbG/mtix8qFWSUE6K9hDAFwGqTqmaRcY5MdCgh9LRxXA2Tyk7xeESdICVLN80lKoDgm3QRSiEnyNVqWFLejP9sl2gwiKeek7maz4/xwAS17wwO2l9Wz/uINTFQncSgYi8GvnAFFVJKeE2bYxE3On/AA0n1w3F6dkzJoBPysgcVr6YqwIkJXMWX7O14w4pPEqxjNgog2Kk/HBpYkYdOQz7qGwRJeosES4oJu2rbWK4iBgAACBjjr99JZKBsX1VqtlNX2fwQiNveTniNxNLjQmrvlJyo214aaJHfzK+7vWKDO5hUCt80WPqe6KlJvdqLkyQyXg59mxGZqygZ+U90+6VHS31YitFKNDsit2+/UAu90X/280C+r7Ef1TI6DTK3ua9gXn5HCl1/sbIml/TmEu5SNz3UlS9mjsSn/sPdYTMRnjPmRKGiggP+ChaROWYxUL8xPitHQSzSVxM4qrOOrs632RbGc9EbaVY/o6tHUk8z84v/ao7xb+zUn3/GQ9Tz3vdATaLxYXFhqpAQ587xsMd5C8PU14debr0B/CpHXaDXWQZxZfMBGHdhROUWamlKtwv3UXlibc80JqsgrBoXordvL2zK01CQ9CdWASAsdQcDtBeHiaC99KCf/CgU0MHgA0+XOBF3EmQVLJuz7vOxtNEJhSHj8dEXF6Azut656ocixj1LLDlJe7nFZWEHGZ/KJk8Np7Aq2E2faTCYPRYrZ/6j0IjPhvuwcESEJI9f69
 dFCrKMhY
 ZG5g+EJfMulTNQmrxFBQgToxa7V4YmI8Y7Z/RUXqRVnDhsWWTJSLTJQbEE2oFRYgKpSjB5pdNOhMcL2Sc1sljZjr3xvOsPs6HKdVRF+g3ARzgRyXQX0MJVLM9vnS48eaDHv9Lf1GOVEMnPtazdvm0uNCTycY9y7xaBos+/Gy29FJqehsvLHfFCW/wCLsMYyxRhrIsFvIqFRDUeokHyJGatZ11IHC2xwYXx0GNZIRCM2pm41/+c0UopGDePzmZSbMo3YpS0CMjolM2v3rFGqtYd3DpfKDAWxP9+7sEH7HOEgs+4rNYpZdLviXcMCvnjREAvc0Vu8vIxM0hrxa88ZN+GJws1xMEDs2XZYRvrG7S0H4BRg9Sc7LxfNaKH5rLpYOfb339hIf8C8ciiyCsTtNbQw1k71O6FfnFMctcyFyF0ZBDr2Jk1CXT3EA1x/DYX7EX9qQgPUVnQvJo98oa2cWhdIo7+ZY1lS3QQYkiyYcy9CFBn0ELF0UjTnR62AGaGw4zdw6wcyfXKMIk76YoFQ7a7aCkKg7jQ9JXoTUZElXt7M13wvoKIlyo+IIVusPpGaqJcJpT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 3:41 PM, David Hildenbrand (Arm) wrote:
> On 11/16/26 21:02, Tal Zussman wrote:
>> Without UFFD_FEATURE_EVENT_REMAP, the new VMA of an mremap() is not
>> registered with userfaultfd, so the uffd state of its entries is cleared
>> while they are moved. If the move fails halfway, the entries are moved
>> back into the old VMA, which is still registered, without their uffd
>> state. Writes and accesses to them are then no longer reported.
>> 
>> To fix it, leave the entries alone during the move and clear the uffd
>> state of the new VMA in mremap_userfaultfd_prep(), right before dropping
>> the context, like unregistering does. This walks the page tables of the
>> new VMA a second time.
>> 
>> This is done with userfaultfd_clear_ptes(), which also makes the PTEs
>> writable again where that is safe. That removes a spurious write fault
>> per protected page on private anonymous memory, but adds spurious write
>> faults on shmem and hugetlb, as change_protection() makes writable pages
>> that were never protected read-only. UFFDIO_UNREGISTER and
>> UFFDIO_WRITEPROTECT already behave this way. This will be fixed in
>> change_protection() separately.
>> 
>> The entries no longer need per-entry handling during the move, so drop
>> uffd_supports_page_table_move() and clear_uffd_wp_pmd(). Whole page
>> tables of these VMAs can be moved again.
>> 
>> Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
>> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
>> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
> 
> VMAs should be write-locked, so nobody should stumble over it and walk page tables.
> 
> Rmap walkers can stumble over entries, because only the page table locks protect
> us here. With your change, that's now actually consistent while doing the move.
> 
> I assume there is now a short period in time where the PTE bits don't match the
> VMA flags for an RMAP point of view, essentially in-between clearing uffd state
> from the VMA and clearing uffd-wp bits.
> 

Yep, there's a brief window where the VMA is registered but PTEs are clear,
but that's fine. That's the same state as a registered but not-yet-protected
VMA.

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David
> 


