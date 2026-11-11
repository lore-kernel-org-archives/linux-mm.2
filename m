Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5D2606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=V/ZwGOro;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=kvgXB8u3
Received: by kanga.kvack.org (Postfix)
	id 0253D6B05D6; Wed, 11 Nov 2026 12:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA24C6B05D7; Wed, 11 Nov 2026 12:56:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCDCF6B05D8; Wed, 11 Nov 2026 12:56:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7036B05D6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8CE314038D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:13 +0000 (UTC)
X-FDA: 85423592226.27.5D0BFBE
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 36606C0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="V/ZwGOro";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=kvgXB8u3;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQXiGUDfX4nhGSBE/hoqgNBZ3AZrbYE3C3VVsm2sLEk=;
	b=wg8lQLkTdPQfW7pRR6wnv61VNI2WHy3MhF0b1ZmDol2UsXrkz+GFlOk4Mfvw7lNbrTOX55
	RavU6SiXI5sScWu+eL4JZAZWryuCOoYfkYSL6OCp7Fpr5R3w4w5EQrJE5uv4Wi+YmOgO8/
	tciTYrwySY5cecemOQBmyRjxfYuTP84=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="V/ZwGOro";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=kvgXB8u3;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419771;
	b=e1O6SeliXJRcbZi/JhOOiYxfNMwqhNESxXTsYYIEk2c3BEy4WgD/rUyeUuYxNHKpqDLf2x
	+RZpQYcPrS4eIPisv8U/JarAB6Il2R7RpHmLxAnDH0OAWB8wangBMSy8mg7HMLfmfd1AHd
	qmm2X6LFvs38HWAQc736rMw6lyqWGpo=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYOd4566667
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=zQXi
	GUDfX4nhGSBE/hoqgNBZ3AZrbYE3C3VVsm2sLEk=; b=V/ZwGOroO1zo48pZ66bT
	L/ZvfSo66O62PCEkxH/hfRJgDsDlkZGZfJRgbYbCmi1+dtxRgQrXBp2H4NRmmwdp
	bupXC1WKqxHvCYocksf2dKhoqDOAGhPpDArKxAyoTLC6JyeewK89IEMXB5zRH4pf
	0Pb50jIoIV/sL7YHOXogwszUeqq0LBS9FavtCT6taGOh7vIcEvKR+lqrh4KqVkU/
	LMURGMKc6WKV0JmJNYE0thUhmAc9f9qR1S3+A8hN4defBp9qzKNuVrahAnqRl9js
	3bff7yJo2jxt9NF8vBhFxqqr6TmnnMPUnmC3slxmbWTBzgR4H2DeOemaHvgead3I
	Yg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvew5mpwj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:10 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5337b591609so54215631cf.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419769; x=1795024569; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zQXiGUDfX4nhGSBE/hoqgNBZ3AZrbYE3C3VVsm2sLEk=;
        b=kvgXB8u3Y0unvpNxxfKLLAUo+7lQ5ZMXMnYD/nCMP3RD7Ngh8xyOkVAxutnKokA80V
         5FIf3QUfnS2wMX0pAg4lK7DURm064GkP0k+8TIme265HUUXPyyB/JzuW1NZwhtSpZaX1
         VYaoKsY4CqwACrecGWbtvVQnf7ldpyoMA7eKB0xGUe4CU2fjG4VU5IUkGG91oMTJUHWH
         hRZV7xrzWio7xk6b0TlJTfKDXNfH9PXp2ZWZiBQTmBl8nXEBM2XSHv60QSua8SC1aLd6
         OkMuiIVf9O8nrubhropC0iTNcFYp+Be/Slw+93lQRnorXBnMeJ8fpNoljOPh64+16H3C
         6Yjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419769; x=1795024569;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zQXiGUDfX4nhGSBE/hoqgNBZ3AZrbYE3C3VVsm2sLEk=;
        b=hd5C1qXoOh1ffvtqv5ii7n8B5QPzXbMOfHIa2IEHD/3vqI+vEaWG1Ze0++DDkN7Z6h
         bgB1EwWXqsU0LRTIeQTFxrH2TCweO77qh1N5ltOvqb5vG/GzVfdGNp2ghna7/8d07lYw
         4uX5GslV5aCjNQgIkzeihzybRewK1GQxFrnW7d8+8wY27bfilSNCElknjo+OZmFQeM3m
         bUZxXyHum+zD2/eJR0MPlXU059qHK0wM+MXCZeIY82wETVD/WlZOc0RQv5224XMIIg4m
         R0LQsgim60C/wXZ4PkyW4hc0MJQGTQj+FBVUo2CKJD7Y1L4DltRSKnhakBTQM6X26vlM
         i9eA==
X-Gm-Message-State: APuU4Z/NSNqicGi4Lv5ozddfZxxYOMXObEUd3Z9JqB907k1xK0bl3HZo
	wAQvVNE8L9u4lDJFKnLH9ZrHDJDfqAsuyZiUvTDb6mV4PpT+HqiTNR0IzlYkzSndHw9SM+Y5/rh
	e63hzY9lJYtT1eujQUa1QcWnmEuvHlO+X+dN8ZJFCYzkkSMKg
X-Gm-Gg: AYBFou2g1HudC6JH7yvjVZoD9E6R/eQDXOB+f1iswjlvf0zuyyH66dXsHUZO+b40IUF
	6IUxMIuczLb/DVvQ1ImuaBB+wsM6tDIjzkOwFygzH2MIPCGOp+AOs127I6mKXLWEVOMmJOUwpP8
	Qs1fdR6MnmxH8i+o5MKF8GEjYOokIP53JW2xppLUh8AjPBJ/BszXkwAoDQ4QN5BHMOkRSDgodu4
	G5SRteeedaU0kcDluXPzfh3JHBQciCBkaG7CNjl7alRWRVcaLnCVXNa0+4uwfiLYaZ1rNhxx59d
	5BBulap/gj1w99KhF4PWNkBShX0rt6Nff6DqEO6tytOZZkcOj1sJo3A1KWtBvbizDEHaI4KJplK
	nkTYPO9VNJSzw06v4iervH4hhnKGHwdYUxTL7dnbsxNv8vzSTwsygnRIusNMFn0a0+2rvt/zI7d
	qO27QgFEfYdcibb6jBGA==
X-Received: by 2002:a05:622a:514c:b0:533:3af3:43b9 with SMTP id d75a77b69052e-556c0cb83a1mr49123751cf.44.1794419769613;
        Wed, 11 Nov 2026 09:56:09 -0800 (PST)
X-Received: by 2002:a05:622a:514c:b0:533:3af3:43b9 with SMTP id d75a77b69052e-556c0cb83a1mr49123161cf.44.1794419768938;
        Wed, 11 Nov 2026 09:56:08 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:56:08 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:19 -0500
Subject: [PATCH 11/12] mm/madvise: send UFFD_EVENT_REMOVE when installing
 guard regions
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
In-Reply-To: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=2548;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=kEdcltU5qeZ7eK7b5dl+oNbbR7olPAATUNygSBtDqx0=;
 b=GjNOWnuSdk/55WU96LIrcc2S9e1J9GWjLD+AXNsWkcA9q1s0rpxpdn5CaqoIq5RA1eqiRV6v4
 +w/Sz2zM37YDGSHG9tKMkiXliEld8eZF962ZxuFjv4RugUrUbbLap7+
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX+4b934zzLVnl
 FXXxNeNcvfFodY3ny+Z0wPQuDv4BorYirwOJkocKTyGz8q8z1/7LsP8E42hzbSRHZQ1kf60q+ul
 Td+DEj7h9oxxqSMq6gsvDbcYnxek6vepu6Y8NFb/uz3D7kIN43ShvBsQw+DgujX6A3pfa5x4Bf1
 OTDog+6/169HajGEr2NaXdMpLcA9FMl5fniPSf69G6zKpA92Fz4CuWO8wDfpEfDaIaotleAGXqt
 Vw0Ev5Tub9dOW/9Un3ORY8fscBHL0kftWLPGnHM4ed46CLhsvDOqM2pjHm8Gy/4VL2kMVGs0Wkc
 5gEE/S4w7FvUV/Qk7toaK8V5HDVPfuzJu3RttWDRbc5pCAuIoAas9tHbrs9d9XMBrtd237ASELc
 6jrpXlbZNM4yY2P9ZAHndyWovOBO3mDYhWevYXjDKnhbRXvhe1hhmzeFPa67G3aNtlQSMVcsO38
 sOfqGSVS0SKHtwViSnQ==
X-Proofpoint-ORIG-GUID: RzFpLu23LgAz4uQJyjAuHsVfjvd24_l5
X-Authority-Analysis: v=2.4 cv=etVKXYpX c=1 sm=1 tr=0 ts=6af4ac3a cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=Byx-y9mGAAAA:8 a=H9KHOoA6oAAipju2C2wA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX90YYLbnV84Uu
 2FGqKrM3WB9nAyqZFrJy9+c0LrhYFb14z4LBeqYDO3VYWhURvmX6OgCQIeKrepbL6+bnURRzaSJ
 d0CBT2Rxa/Cuqba6ZSM9n0kxdchVypEbTk5nYdEdhtpF3NargQ12
X-Proofpoint-GUID: RzFpLu23LgAz4uQJyjAuHsVfjvd24_l5
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=10 suspectscore=0 clxscore=1015 lowpriorityscore=10
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 36606C0008
X-Stat-Signature: 69xge6bg4441twczt3jqwjo58q8t4duc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419771-711841
X-HE-Meta: U2FsdGVkX1/aLSrB7eTf4LCutb1jrwxcggQp+PB6Fja3AlLDrFg/0thTkxb9595V3fQnQtcI7LrE5tpgODwlu119Jzq5sa0P5/+kBFdlB2OpVwEwURPtzJoECF+Dx3bVEnuF0GPjShD9h4vBkr5Rwx5LzX57X4vr9Uj4eHts9CCaqCdIy1KOOg52RQTMeBA6LTSTXp/vrjkPrw5ylNhT4u3g0wWdHLamSlSnuLNBV7pDqOeMKa57UNEuP+ILxnYEwuUZvJpKawjpqRAsBzxHjUVZa626xBvUnL5+SUpsfffzBmsKY9k2S/ijURUx79Ha4ofq53y8QSIGvJNF0wsTg+GmdVgpTt9odP1+scFX2vavDZ7/JAusmWp4AvcQtuaiPjTqkloXVNa76x8bvlXUNpTA0ThGaZ5iEK7k5xGixw+5EOaXYUcIeh4BKG940BN8O8sHskdPeBmUpBHMrClumj+tbKWVs5q21+cMcTXlrRc/2pH+VShvkb545RqZ4JtcpAzyT6WelMabcCfiaHWtnwnyL6s5Ob1DTQFAss0NBFQIZZCpVAKnk/MUd0s/5T/N1VqwJQKfs27q38Nyaf7zABK7/K4i9ejQQSgGcdkNGpOwskkOVxKNzMj1UDdHPrFjBG3+bHPL0IeEuiQKAfis0sjnLBWc5sJ+RCq7tXpL+XHIY0vDL/Ofl/O43GHs2pqPQyjILY6B/5SH6dsW1+AAbOMTIiKQv/OxP9+Du1ugGrW/kj43tS48DtA9xWohhtxTzmaXayoJBfrD8F9H3vWL3KUuT77RqdZHeo8Mc0sJP0Pj7uV0MhMv31rOPn2oJoNIJIUAjY9KHwZ8qmdv+M6YHYesF0K2Fjiq1Uf4oa01cL7czEAPjoo4eIMgPsmaLIzxMkq9bPIMDBkcQp46fBxSxz+qL/VKl0VmnYtgfGkjdmFfhcRh9r0JiC771mR5iDbfAYy5Ur5xDQKjMKkFylu
 Uw16cOq4
 yoPN+lL8fojqrLGA8EU8WeDa9Tuvpe6i1Qt80QSch2wadcIxDolcMiCGTd/pStLk0nrHBbpLk9wW0LyzWpl+pwPwDxkLJLt0gXwT7LS5+DFMFX+XE92OIXOTylU80fZ2uO7Nj+WNBI5eYMYKkhmXQS3zlMgZeCQKj2nOcNT5rN0S/Xay2TWu/6hmgGbw84ftHIGC2K6m06a04E5KqD8nv9kSGI9qjjXmgWHjcok6AVhRSm79syIlFmsT2YlNUQaEJCJWLF+kciXEYzRlNJufn821Pvx6W3Iq7vkZLtGYIfr8ExjrTlMpk1DYd8lmvhxGQ6o8EbBtEJCzLWcwANeSDh0wligY22Ar0VC03QN0XcDcwA4y48Gicr8V9iqoJNO58cIe6AM8esShIRxWRuQOMiRC4ZBIyZR7/6pB1qAZY2ORGsR8Ca150wxuOA1rW1GwmEfPcFOprTXWxdpvbn3RLcKI7Em+ZoEOOBmccys5rRvm7Xn3xUcAhjUycjV5TOzVGhnjM5LKx8vjllqM9AiSl8kbSpVPZjIh394ezK3335g5Nz94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_GUARD_INSTALL zaps whatever is mapped in the range before
installing the guard markers. However, unlike MADV_DONTNEED and
MADV_REMOVE, madvise_guard_install() does not call userfaultfd_remove(),
so the userfaultfd manager is not told that the pages are gone.

On an anonymous VMA, the zap drops uffd-wp and RWP protection along with
the pages. Writes and accesses to the range after the guard is removed
are then not reported, and the manager cannot know that it has to
protect the range again.

To fix it, send UFFD_EVENT_REMOVE before zapping. Guard install on a VMA
registered with userfaultfd already takes the mmap lock instead of the
VMA lock, so we can drop the lock for the event and look the VMA up
again afterwards.

As with MADV_DONTNEED, the call can now return -ENOMEM if the VMA goes
away while the lock is dropped, or -EINVAL if it is replaced by a VMA
that does not support guard regions.

Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
Closes: https://lore.kernel.org/linux-mm/3f4b0d1b.bbf84.1a1c55cb666.Coremail.18670333770@163.com/
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/madvise.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index e8b05dc899f1..6413f0e65381 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1166,6 +1166,29 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 	if (!is_valid_guard_vma(vma, /* allow_locked = */false))
 		return -EINVAL;
 
+	/*
+	 * Installing guards zaps the range, so report it to a userfaultfd
+	 * manager like MADV_DONTNEED does. The VMA can change while the mmap
+	 * lock is dropped for the event, so look it up again.
+	 */
+	if (!userfaultfd_remove(vma, range->start, range->end)) {
+		mark_mmap_lock_dropped(madv_behavior);
+		mmap_read_lock(madv_behavior->mm);
+		madv_behavior->vma = vma = vma_lookup(madv_behavior->mm,
+						      range->start);
+		if (!vma)
+			return -ENOMEM;
+		if (!is_valid_guard_vma(vma, /* allow_locked = */false))
+			return -EINVAL;
+		/*
+		 * The VMA may have been split while the lock was dropped.
+		 * Handle the part in this VMA. The remainder is handled by the
+		 * next iteration of madvise_walk_vmas().
+		 */
+		if (range->end > vma->vm_end)
+			range->end = vma->vm_end;
+	}
+
 	/*
 	 * Set atomically under read lock. All pertinent readers will need to
 	 * acquire an mmap/VMA write lock to read it. All remaining readers may

-- 
2.39.5


