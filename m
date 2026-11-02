Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE55606D804
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=KcIyYlhH;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=stVYU9/B
Received: by kanga.kvack.org (Postfix)
	id 576996B05CA; Mon,  2 Nov 2026 17:54:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525746B05CC; Mon,  2 Nov 2026 17:54:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8766B05CD; Mon,  2 Nov 2026 17:54:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB046B05CA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:54:58 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 884D81202C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:57 +0000 (UTC)
X-FDA: 85391685834.14.D5A5CC7
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD1DC140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KcIyYlhH;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="stVYU9/B";
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLnMk/B1cFQ3z0k0LPzM7qddECf0IZkSoR3rfDNv3Qo=;
	b=EJi3Hpbzbau30Wo2KPNYUxI30Lbimfm1mvDqDXiWGvQ29BOPYEXCrnETkfkWz4HbinKorQ
	2GOpLqd2z23mgD8AoWG+yTpN82uVkh2ud8Tqy5JmzlUTWMNMevumli3v7MAy5uDOGhWMsB
	AiodZtnr5EWUeLn+9Jem5u6gT1plJiQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660095;
	b=2pIw4BH9nLsnAe59ZlKke2zikYNqkhkhfu2ZUew2h6h4RXpryUuO12pR1u6X8x5UeDlZv0
	YyxZmh+LmRscEUaEGSJPjqNZKG1V4k8k+u2xHKBk4a9MmyWAjM5v2WEhrZKlgXj7iH3aRi
	g2VsPe6JWrmsd36+U0yF9Iu/f+sJSDQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KcIyYlhH;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="stVYU9/B";
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2MD6vL2287185
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 17:54:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=CLnM
	k/B1cFQ3z0k0LPzM7qddECf0IZkSoR3rfDNv3Qo=; b=KcIyYlhHka/aLzj1YcU/
	Ujww+HQttnvrap2DyOvBYAhHdsOau+joQmC06nexMZwElJ2nJfggfL4Btqp1z0re
	hW/kZlCLIlr4CR3v5D1GLztV3KjCKmynVi03ZsvBec1pDGh92gK0yR6LWJm4iuDM
	RsG7CezQlBr6yQx+eZHRoFxWsSybUVQNQmi/XqTghSFF75MD489mSTYsskDg5aYS
	R+NC+jkKACRpJmCzZ20AgHVkjsp0e8U7D55YSnuc8HfpwegKiwlhLLIsy+HDa6j8
	6U5TxIgd73F4SF8F0TpNi5AQoPRNGI1CuHxeluSm1+U21kfaNihiBYQJNUNE2Wcl
	Ow==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hq34br9q3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:54:53 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f2373e9b4so355171285a.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793660092; x=1794264892; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CLnMk/B1cFQ3z0k0LPzM7qddECf0IZkSoR3rfDNv3Qo=;
        b=stVYU9/BnUjXFJmhCoUxaGfvvtH190kP6/jyIT5NujFwqWrAkpL2VW8Mz1fbrQqqVp
         eCZ7xRa+GHLZ9ttToxD0VLn2aQlYSBEOIi6HmpvN0nfJhjh2Uy9+eUqCWdk7EVe3+jhw
         nVHANSDci2eN/OXJh5dOejU9iVf6AAI0xVMrneuOm8Xf1SUk7HpP0LZvFhtW/HfwOuQl
         xBPioFe8CvmhpKSBrwRoXUcF+rLW5C96ayyAd3RGO9eVeOigvJDaxaHMzAU1vl8bSjGJ
         mzwMcCqDM8uJZw14JA8lZYI8AEyKZ+JGYDYIvom6n1OaaV3zuMCDS7NhobiH4ThQ3Pev
         G+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793660092; x=1794264892;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CLnMk/B1cFQ3z0k0LPzM7qddECf0IZkSoR3rfDNv3Qo=;
        b=KutIX7VhWWZz15r31fNZ//Mvm0s6UspFD4QnN3j/NChonwg4lGy4AAtCGnmoVzxauJ
         js1bSoyE+lhctNTTnnsWhJbVkORbJ8Qh86Qe63vdMtRW1pRdH52egqbecCK5+ph3DRLz
         89M7JOU1aUyNauKUyuBQzjDmm7EYnP+ooId07alSPS7IhSm57jee5Pz2jELjuRP9x7Lj
         7SQb+kF7nNIXs6AKdr8pYxxqHwn1v7nRc7YhNSYRqIBr3WNyTA8dZv+3cUIyHrNDA0nh
         s8QF4UpPFX0WVd2HAaJXD5550j1OUXlZ1ZW+XZEJ0AGsJJgFYs52BVey7w0evANg1SV+
         mOaQ==
X-Forwarded-Encrypted: i=1; AKwUvBw8H0KcF37VQ5FT0DBPNh15rPW3LKJQaPxMoW+sCR+Gy4JbeRM5cuyTXZRwrSHGasLUjxC/Omjf/g==@kvack.org
X-Gm-Message-State: AFq9FYJ2d6ZgjbOs3lHn3GGwtMzAzH31ARXDgt3HPlDoJ4+QG8McvnYD
	LAIMQD32Ch+iEakIomoqWyiqf71p0Y4Is7KMSYhowXi1n17SlIjix9mDcCJL01QFhHg9EDFW+w1
	8ogMpMMgXIVyWd03+HmCfDJrRClHjRvWuLz69u2nb33KWVXbB
X-Gm-Gg: AYBFou2DQbI2BfYeWJHuzXnLUbKEvJVg7zuXnERJTlNpW8dmlR/O+tED7BHqbMwDRW6
	3wEmvTK+/ZaFRGXJrQcrMHbzpAKuapF1zMevC/thUAbuD4A8cE2fMOBe5LcLbWtqBztIOKA6IOM
	/wGvHKUGN+/GVgDtHzBUIZfxCqBRpoiSQutnBAztgkr2jAmzxSQEX0XpwevKcz6cZciHomnW2VS
	ThNNafO17HKUw8qn6LJxDIRp4V3eiI2REI+jLeNyX3JBkWhu8N3fTYC764+RzzjQYbavu05kHBE
	A+MzDnckkuUiTupoMqigdaTxnZP8EJnvrf+KT7cKX/CzCkErHJXiSpUpfiZ+IYstd/A53i7vOrJ
	sNyPY5tRk5025nW3+OqQqOYW7fWE0W7ccFrVhB3cgzDmNgTrT8VrZKdffiS8=
X-Received: by 2002:a05:620a:4402:b0:93f:34c9:9252 with SMTP id af79cd13be357-9442174e1femr1926260285a.55.1793660092573;
        Mon, 02 Nov 2026 14:54:52 -0800 (PST)
X-Received: by 2002:a05:620a:4402:b0:93f:34c9:9252 with SMTP id af79cd13be357-9442174e1femr1926257385a.55.1793660091921;
        Mon, 02 Nov 2026 14:54:51 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm24710529f8f.31.2026.11.02.14.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:54:51 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 02 Nov 2026 17:54:13 -0500
Subject: [PATCH 8/8] mm: remove thp_size() and thp_order()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-page-wrappers-v1-8-e7280bdb31f6@columbia.edu>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793660051; l=1262;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=6t8b0yasyYH7uaOC/pe0116nR8/5Kr1ZC3jHg5DjY98=;
 b=hJRS3l3lsCEY2qgn9hYW0rOfYfRH53Y+MmXfkNNwQXYDnRHQLgVIFrENlde5pR/kqnnVhHGZw
 aqdn0TcBaRyCRMSDUYUqRTd1SjdjkQj3EkIbJxIwZJVaFBlnU0eMKkb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: gcCZcRF7SpqRDf9zGen9wTEriCG_u2zE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX5K7Yi+UUfuXm
 w7swkgrhOBObQ1Medz4ufkUIVoxFTUms/BxEVefSuL28CXDr2rL6cgAVZBYOhUtHeAW7gXYGvTC
 pyQKUzeWh/vquqpnbDgz3AqXZkeLqqmB+IeDDNSpiAECsRvtqm5leJIoS3WwuqtSTOY7B+cAaiy
 v+BYNQ6EjSLpvZ0SO6sO4Q98nu6HcitsQ3PkdL53lAsOFtfY36uy0VVYTrbLsKluMrdy78aukws
 pIWVz2OETSgyZ4C/enof4rfgK1MrNh2NyGhAR8AYqAMpfsfPXkua1pqFW5GT2SOYU/jvpU7jcG+
 VEn6GP1RxUim2ZC0fKzYnwubOAhDrPU/QMOPH/vlYUtJO5tww4brNgDTAI3uk1s09QZyzDwQfTq
 nRuc7sY2lUqXy/lfLryCMvm8+jTbm5pW5IoV6N1iNNIYdQ1zPNnS0l5kGm8TIBf5/csBkBIwpN/
 aIFbtRllv4HNvwPgFfQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX9oxxj7pUXUwg
 eeftOfAvMmFmGdvH4sAfoJf0QwvpehQpqzCTibm5P2Pvg5fCwWCsgCFYfLp3WSj2qo64crGtvLZ
 7H3RW9ZjIVLs5EdgyhKEmx1IQBHl0SNl+QEWYppsljbcS37hWD80
X-Proofpoint-GUID: gcCZcRF7SpqRDf9zGen9wTEriCG_u2zE
X-Authority-Analysis: v=2.4 cv=Sadi5fRu c=1 sm=1 tr=0 ts=6ae914bd cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=5wpFShScvf9Uq2YMFBAA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 adultscore=0 lowpriorityscore=10 bulkscore=10
 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020090
X-Stat-Signature: aoas5sdtcyiyk5dyqmatyr8t8w9d77aw
X-Rspamd-Queue-Id: DD1DC140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793660094-453731
X-HE-Meta: U2FsdGVkX183W85UX4ZYdgXYlcQexD/LE5RNzmw++RnrlOADl2YDKfDxPLuhCgvQch16+Bh0n9CqDy6+7lXmOunTAM0LsiirLeT8wDYTbhKi74da0abHCLcV/SyaRgbloLKhrhGgZYqxzUJkrb7gBe1dsbD2n3KjB8L20YS57i6UIZxiboXTx1Mo/YaLlT5Tn0UZtR9lojLq/HFtv+WofkFVC/JCizF8j1uhgEm36lzCBQmpB8K0BRUAxDKxPUsHogXHQEtxoiaW+O8IlnP025FzKjY8o4XZOyNEVDDwWZTKBWk07BIbqkRnADz+r3Pu3/r01PEfaLOWyWD+BrxnRekOuEvtfksxFo88b5DUljP3Jt4NTc94C4yyTxUIW05v7lvWvtH4tlDoAb2q+hCohxJc8wsWU8PBDXRjDtA6+clnBg34/jKAbIMNIU7sRVB0nooL1DmWRpH9QWqX9pWv39wpirGxYI2MG8I71HX+xP55ffq0ijjWGk5HgL1REmpdNMoCrkJkvK9cLxD7ZF1VrPnFLfdDgM8ikFbLlht5QkusMex7ZXe7GaCoXFGgJfQ3GhYxZsiV42S/WJ/0jS0hfZjmbTD3L58lZ1fEOqhLZ3+U3nCw6FMtl6/StlJsnGA73R9nqV0E+vfy4PROGU1zkF1JKICV4uUtoO7MgPkgtgQpgGAbPGeSSu+jdjmHw/w8u1KAFB7tB4qke48SKI9mh1U/QV3ReIDmLHB9nYVGbfmAUwglVWADfUpdwVFOwHGBN+e616sXapK2Q6JsvywXjMzqeE9Z2lDqSl2kjaAO0q5wrxWIgau/Xn/dyRV/KfVCuVBlbhMZE0QBhuhEDWUp253YyxzCLGXmlWOLxovOk9i4dJ+4eE66SBofpZtZwKPRtiGPnKi1Q73BJqQ8NZ8EJEAm7KTL1qqseC1JlEeOsH3VrOkwcCOm8/I+GEM3WYuPRl2gCKTQ4zePBZZPjgu
 Mc7gdqdx
 hVVntU5lx56Vin8aHOa/Zah9hn71smTLzFWqc6SgV+OTNARFikIe6ZKw14s/DsTDSk1oFYuU26dCVx3durG9Mo/YA/8njSS5mQPfUU8B8aqMMaXaWDF9h7VGy3KDJlunR9hIwqbz4JlmdwBcLPZwHWR5ZQkb/+xeRyEytP3m2cDcO6M/GCr9Khz7Gi/DeJsBK/7RekdjF5M/rIOquQqGLV+u+KC1ECWtvorkDKtWqU4slzoX8/49U6YvlqRmaFCc2WPgFDN+sy6xEubNFtpjBENF0iFu4LzAvXhx3u1ivsBu52lVKKNEW6qdFe1QNd6MTKpTR9UKNNhtJgnJG65Apf37lBWgsJfBc0wKQXNxuAiyw2HmS8/dq5gZdmHpZIW5EOKO6Jn2kGuB4FIq20wWlt8pwEQvzKddpBNKOsFCkH8CX68Pf/obGycL6TIprMJUUdZTtPI5wgzZi123dOLILAN1JmfqKgLwo4Hf7K7xC6mNuQUGD9PFKmb3CrSfrLStrnZcljNnUOzJdgcOZ6V0xI+Z4dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The last callers of thp_size() have been converted to folio_size(), and
thp_order()'s only remaining user was thp_size() itself, so remove
both.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/mm.h | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8b5883878538..143865580169 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2146,27 +2146,6 @@ static inline unsigned int page_shift(struct page *page)
 	return PAGE_SHIFT + compound_order(page);
 }
 
-/**
- * thp_order - Order of a transparent huge page.
- * @page: Head page of a transparent huge page.
- */
-static inline unsigned int thp_order(struct page *page)
-{
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
-	return compound_order(page);
-}
-
-/**
- * thp_size - Size of a transparent huge page.
- * @page: Head page of a transparent huge page.
- *
- * Return: Number of bytes in this page.
- */
-static inline unsigned long thp_size(struct page *page)
-{
-	return PAGE_SIZE << thp_order(page);
-}
-
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when

-- 
2.39.5


