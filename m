Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817B1606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 00:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=lsovCs6I;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=1VKCtvGC
Received: by kanga.kvack.org (Postfix)
	id 554806B0608; Tue, 27 Oct 2026 20:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A3F6B0609; Tue, 27 Oct 2026 20:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3578B6B060A; Tue, 27 Oct 2026 20:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 070416B0608
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:14:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BBCF120B5D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:14:17 +0000 (UTC)
X-FDA: 85370112954.25.EB428E8
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7A69640008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:14:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lsovCs6I;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=1VKCtvGC;
	spf=pass (imf12.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793146454;
	b=aahohog59FFyyCELxXr1Xc8RSA1ffspG820NkjPXD2F6iRETqM3zIj75tukodevnfwBPJF
	0UGsUgn85SX7ve2EakvB9p5U9VmJwjGTJaWwNIY434EeQxTeVHNUGMUoWzAGwm3mqkai5t
	KJR2/lb3Blyu4LUDK8zWdgYXJ2uYXj4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lsovCs6I;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=1VKCtvGC;
	spf=pass (imf12.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793146454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7p1ucq/Ny8UBz6ghlqYuLhKrCHyG8ylaL7otql1jOZ8=;
	b=PiI/w/MFNu54Ief5uKL8WF9q9sYcO4nWmCBM/hQrc0nCEeIXunfMpItM6t9kYcLwKXVo+A
	3gSMJ+L3tboTGdh1X4FEBUYw50P0aEdPw9AO3yx7wFR4ZQQZJRD6+iXMr/tI3Ody9WXP70
	FZcNtR9/8Y/EAIaMAL5igadV5hkHqDU=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RIurOW479644
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:14:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7p1u
	cq/Ny8UBz6ghlqYuLhKrCHyG8ylaL7otql1jOZ8=; b=lsovCs6IxaWMyufeHyab
	UGnNVfqeJNBrnilLDH1hmBBzIDO1Xw2PYSUP6AO5lBNUxpxEQbs+32FmrWqXgs2U
	tOPH30t80MNHG2qpSiuiuflnpzM+Fl8MrVaIQ/TzOQwsV3+8EA9G3C0UHn/qCG3Q
	PQj237pzIWWLwXlIO/8itmTx5LzX4mvdorMSSEhTUlDiVt+iAvZg3DPutnck/E72
	SD4t4EgnBW4hfXCWuhw5rDgUQrr386PNS4Nzie4yCvvMNEyT2eeHSzgksDyKzRBz
	69BiiAg+4Y9BSAZh6oP9aUSXMEnXOkAGEduwN+78Gc0cdd8YkiEvb2dw4F4cmelV
	dQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hjxk9mh0h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:14:12 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91b8c60c550so13969046d6.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793146451; x=1793751251; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7p1ucq/Ny8UBz6ghlqYuLhKrCHyG8ylaL7otql1jOZ8=;
        b=1VKCtvGC0Tc4ohVfYMwgKeJIwYHmCyOiSBtTa0sfziQJlrAi7ekgreXdTSfY52hpMS
         IX4yVL44MComLyqL/B4bKIMitoFH/j9MMYyoUsvOcM1rKWn8Ofbiel6BqQoAvMZvsW5V
         //IJ9cWOWaUXd9Vk/8nzs24HH+IBHcvus1ZY2wZL7eLQCB5ojYh9OvQHZFu4jShQztd5
         dNZnnRAyaVMAYpP3F2+a5Ra9mSMpAN+5VwS1ebC85FJOaeQag9U7JizVijleUj8P2YJI
         1U6QRAzXTxpLuOwORDPqa8pDwie2yJ7OwEihk4oBI1RscBOP+GzFy5IsjAdxZvjyEDQw
         6Gmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793146451; x=1793751251;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7p1ucq/Ny8UBz6ghlqYuLhKrCHyG8ylaL7otql1jOZ8=;
        b=X38eg69WF0rMB+/h/M8yNH0P8CVDTbRPPyRIF2G4a5VI9UJ1GlZVLeUMoXbCMaxvHL
         BKOW8xEvpMKNmyvIyBGYksp9sh8nDz/q5cMxDcyq0HuoYVKSBIgdPIIHqgPL5NBuY6JC
         2Ods6z6m3SUW2iqFRJALhAyWmvtdrAR7iFTiBpNC2Br/b8jOPdaZiYmer1p3ClAt1ROu
         8I9sgKSOVaY2BOi+xmP/GYQlpcgP6p9G+fvP9JvqnFSRfw3xT2UqzllFEBnwAXLCB9ED
         C7i+HxP5SoPCwA0iuQACce76u39ioFheaD03DSHzfoHb0tTAb2Pmj7MYhqwq8iSXW5HM
         nU8Q==
X-Gm-Message-State: AFq9FYI+X4Sziun1AanU2oFddU4WNtxHX8A23vdoAMuh4ZvcAEyM7IY8
	IYIflQwyJOgVOLhLLPOGkdLL6E6fZnACL5wX3NgpHO43Ngk2vkLTwArE+cqoQl/yHqjf2ZHJzdx
	BzuT+voehKysZSvr9n8CYQKzp4VrpBShkwVfI3kyBc8FLBlTJ
X-Gm-Gg: AYBFou3F+T+VMoVSrQjYxEvdSJO0JCpYISHWN3a459/8Sm/RDYSh5bYYbPYoa0A7P13
	23+i1WD/9YiYCZfxRmH8tAzCzODUzWJFvOyGwY1mvYFdgf4q3TrzAZvUcu4lCYEfmTmtt4Ii5bN
	e8n+AlvQUPxGTaTEftb8Sb7JZyoWf0AYHrEwCu9LZ/E1CjxttixSPeQXaLZVKyzbcGeafPVXfpS
	dw8fcvJ2/ylFg/AzYE/Bf9LQUuQG7eX0abeSIGbs1P+lRrzKGhqWZF3FcnBTX99PNnhERRQbIFh
	MXBlx4rfBpXrkgGFfW7G8bCEyxiea/KCybvfgFmImje9ZUnnabMTlcr+tjogpVJKpJL8/YqgF02
	HlRibBvSUDJnM/Xbg1T9CD4SBrio0wC08vnE0odbludToXjPusrlK/83ouPYspfX7Ney06hNUcy
	s5KrwpFKHCpFBMiVYDaRfF6epUYk+pjmyMh84xlhg6+KVUoknLDbcW6o1t+R6x4aZSHqgGvJLTY
	G+NqmYUDfmprd1468ehuCJjI551ej4vT05Dw1DR+WGRUfT3YHhVR+cKixLsLzYv
X-Received: by 2002:a05:6214:21e7:b0:91c:76aa:2c67 with SMTP id 6a1803df08f44-91c7d1aaecbmr12070766d6.39.1793146451421;
        Tue, 27 Oct 2026 17:14:11 -0700 (PDT)
X-Received: by 2002:a05:6214:21e7:b0:91c:76aa:2c67 with SMTP id 6a1803df08f44-91c7d1aaecbmr12069876d6.39.1793146450883;
        Tue, 27 Oct 2026 17:14:10 -0700 (PDT)
Received: from [10.206.51.58] ([129.236.225.183])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c6d8103b1sm40645156d6.44.2026.10.27.17.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 17:14:09 -0700 (PDT)
Message-ID: <3c754c36-86de-44a6-ab3f-5c86e4bf83a6@columbia.edu>
Date: Tue, 27 Oct 2026 20:14:07 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/46] mm/huge_memory: fix list corruption when
 deferred_split_scan() races with deferred_split_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
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
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDAwMCBTYWx0ZWRfX1PqFcKRMQUMM
 0+3SPsKWBF7MUk2xzi954v8kUQyjRsl9sjdhLLzRn7IsPwdZzCONh+C/Euq0TCbsUejhhZ+4YUI
 gJMuwjEV/2EZkwAGHAOFC7hKxfqswWmu0p1elhq4YHRCLJnGgVaT
X-Proofpoint-GUID: JmcCE5QcAeXL2yFY3ddaSs8WP6oxU1RL
X-Authority-Analysis: v=2.4 cv=SowFe/O0 c=1 sm=1 tr=0 ts=6ae13e54 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=TdXXog4ttPu8yHJGq4T0ug==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=maIFttP_AAAA:8 a=_zromwrzjHPDTWxWFBQA:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-ORIG-GUID: JmcCE5QcAeXL2yFY3ddaSs8WP6oxU1RL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDAwMCBTYWx0ZWRfXz6g4Qphhkjbe
 UgyYwcyAaTE4pG3stkSBno1iRMJCRiZQQX54c57kmKi9aBzHu+Y/delHdf5WbXcahGOu+mjm+l8
 BXcjVgej4ShFaG64x1Zo5Wds3PvNvKl7qyuX2tB18E2DJHk8qa6Nq7InltCJmGgZFpTs7caMHjM
 sDO3QdFOQK1QUANGgj0F3lRZNlDZjMzXvCSRfLeXISeXnIkxJ4k9a3yVNpZPyNrIQ75y5p7bUw4
 ctucgkqrP1jKpujfP1vnyQ32XiWwjvHczRpFs+OLHDZVw7KZ3Im8HZQCfPzg5xHlEhwO03dc2Nf
 Ye+SGoZfPwsy5FNLMB25VxOuGQyNad9jEfo+POWxcE4EyCx49SDn6cY6qh5TeHMylwlrUnjfaMb
 nUa4wkoEcWxXhcfWKUGye71UxxRKuJXuR57cdxmbj1/yrRQGq5tIb9gsPGUZlJ9nu50TbMrdwwE
 KPD+L3xEsOi/uds/5Gw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11948
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 bulkscore=10 lowpriorityscore=10
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610280000
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A69640008
X-Stat-Signature: our7ju69grs4fz977sk6pbfimtqgqerg
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793146454-164618
X-HE-Meta: U2FsdGVkX19nGq+8Pqo9XGU0Qgzqfs/byDQ3xE3xGHE84KINlQFgh3LtkWPoU3gX9f0ORx7OWKIN8my9p0F+03LY9Cu7TMTZG79y37tL+ngkY9aJ95mXd8tvyiIaoR76YyyIUvpI4HFx2no+/aXGWanGTO28F6Ht2YPHtPLImlZwMDI9tgbFD7w4k6HnIOjbmLU+5AKavWJ7JU86ZtZkF1D0FWlWUJjGf6buQFktYar/P+yyBc2tMJ1Q35oSj/M3iSR3lIar/RuLOR0MhY0oBbAbtk9adppH6hmfcrFHYxceEatyjeWLJszJR6sQXNPG5WwerMC28JsAyhEVqzt5OB0lOCYajdymTW8OTGmzgXnokUSEv/i1SRAY1vc0XTGCK8uraUnCoRGedubcsJ6me++BYC1wZyObEMH+b9bnQ7UW2uNzlxqN4gaXaOVyKJYitVZuo66Q3gGd4jXms7iWltQDSRaMe9Fc3RuYSo1xKySfkHi2zHLdF/Vtoxqrtrwy1MbY9Ke2twARuuUbLfTfpqPpjxXEuhb+QQ73aFh3FGAs/3/a+vjWauBYY34mDgk/CWRC4ta+SIsFJmWEZXOFUA0OHlW+SJWV1LHpPm1TXGAXhzmhLbR375OaCs6RBeahUqfXK4zHPyW4QdLq9RJ89kDdzaxqjY2k6swW8VGjG3jiT6GAP3rw226KS20Ca5DfgJmaPNxwsGMkr+aoWmMIJQFmZNKnI9HQS29Z5ZOM9e10FjmhhDmrNPBOfkgmKR+EaShbGvPs2tSm9VNNb8IPkOxRAfUwVILocXyBOFrHka+bwWA9rzoCW6yK1IpHN2ubYzgigb15o8mtZA7xDek/cnhXr/besry/6GicQDXW4cOrW7KSBnQHHNYbZeHOEV5zoSgUluEBO/zHtOpH7THBIX73rtAEWnw9/rwmItqsy3EqrNBclEw18eKa9zcMQ2rFatzTZBX0PBe/EoVE+a+
 +LB8uJOI
 EyvdBDlgGJDYp+6WObRH+wekYImLUcWgxiZKjz8Zx5ZqIcOpoxVK0YIB8huUPDnpuunxDCZjJT7LqirQjjZxbkO++w6KmFc9aPuyjR1sOzbB1i5iSbdc5S9pSRuJ1ds+EHBIMKbRpFim945eJ/KmUkBcEQwzmjx7Wq3Xptqo2fwpR4KTaptBIP/M1a9rDOk4dyx/MUzY6engXhh3aTpD6kP3OlprTwrISCUi0At+Q/bUHzGNc09PRh5H/tQMJ2/WMRCcd24rIjtOcRMf7SyBgjqCMNpkIyZ1eO9ihpHmmRUYjRHgkCbJF9qRMeZpTEPzdKrQbjjtXzY5oxZYejdW0a5kxvvdRqxJNFg3m1ARiyY+s4vcfnjUzIboVgD74zHfjHJdtIm7Gm6hFZMUXWwtm0AQGomkgR9T9QTNc0DVk+kFJRMb3WRQEGUs4EFdRNXfaQtg/gX7cDIt+7xu5EhLE95QTkqZGjaogNUJ087kna0r45bEw12k/Kd/ZFb8ZDGLgCETxl5SOfkRaf6i5aJg+AmuE8ZhP5Ief36E/tQklRYD9ZlWdFclYVJohkEsnc1RxC0alHJmYsU9kPzQKI6WIdKqvweo25VqRz0Q666umPa/X5E4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 7:17 PM, David Hildenbrand (Arm) wrote:
> Since the deferred split queue became a list_lru, the isolate callback
> moves the folios it took a reference on to an on-stack list, linked
> through folio->_deferred_list, and deferred_split_scan() takes them off
> that list with list_del_init() without holding the list_lru lock.
> 
> deferred_split_folio() does not know about the on-stack list. It only
> holds the list_lru lock when it looks at the same list_head, and it can
> run for such a folio: a THP is queued when it is mapped, as a candidate
> for the underused check, and is queued "again" when a part of it gets
> unmapped:
> 
>    CPU0 deferred_split_scan()          CPU1 deferred_split_folio()
>    list_del_init(&folio->_deferred_list)
>      next->prev = prev
>      prev->next = next
>      entry->next = entry
>                                        list_lru_lock_irqsave()
>                                        folio_set_partially_mapped()
>                                        __list_lru_add()
>                                          list_empty(item)  -> true
>                                          list_add_tail(item, &l->list)
>                                            item->next = &l->list
>                                            item->prev = tail
>      entry->prev = entry
> 
> The folio now sits on the list_lru with ->prev pointing to itself. The
> next removal leaves the neighbours pointing to it, and they still do so
> after the folio has been freed. With CONFIG_DEBUG_LIST:
> 
>    list_del corruption. prev->next should be ffd4000000270090, but was
>    ffd4000000278090. (prev=ffd4000000270090)
> 
> Fix it by grabbing the lock around list_del_init() so
> deferred_split_folio() cannot race with it.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mani Tofigh <mt4022@columbia.edu>
Tested-by: Mani Tofigh <mt4022@columbia.edu>

