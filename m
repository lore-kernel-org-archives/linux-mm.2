Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D8F606A882
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=G0KSRkUW;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=4nc/+OS4
Received: by kanga.kvack.org (Postfix)
	id CCEF36B05CD; Wed, 11 Nov 2026 12:56:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F9D6B05CE; Wed, 11 Nov 2026 12:56:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9E96B05CF; Wed, 11 Nov 2026 12:56:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8580B6B05CD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C5E880369
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:06 +0000 (UTC)
X-FDA: 85423591932.16.66EF1A2
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9A76380005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=G0KSRkUW;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="4nc/+OS4";
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+EjyARKBaNH3SkAfWpNAWHi3Sv3+8OGpYn7wnaHoKA=;
	b=X1C2HnehWLOPRUWDDdhbj3q3N5ll/BqID/KeA2EnKYZNkiuOaqzY3Efn40a55BhbuT/nUl
	QgsaGH9KyeX8ic6oIzGaIFF045G9JUmSdiPEZgT13s6BBzzOdwDXbslFb2o7fl568WiR0R
	biTFLMB5z5UqJ0HuZctkeLVamFll9Ck=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419763;
	b=1XkmaBrpOFkSrDFAlL6h8mO4txCDLn+kPY7DmhfD+cUDDTRP9l8KpOFItqQVN76w/L7yWx
	LL+m1ag/cbLyaou7buj9X1WKBUxKlQDQMFDLucgad61wUPS/ozHG3VD7Is/GGFgL8P6AUz
	7Fg0uN094KENWtxwt3hycp9I0eMP2Po=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=G0KSRkUW;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="4nc/+OS4";
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYHgT1158251
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=R+Ej
	yARKBaNH3SkAfWpNAWHi3Sv3+8OGpYn7wnaHoKA=; b=G0KSRkUWtA/jxZnsPfSd
	sLK2jnQq2mx4i88lTY+hIFSByloYyrhH4l+bsweNL0HufkFwSPkIA5L+jh4VQ8xI
	yCr1t4YpfdhCjxoGVVwXKjHzGqm7Ra0a3vh7N4iLcAAbJTznv+VtSVNo9Bl22i/O
	Oscf1KwEhWPIYnTU2kxBMDHKGtXqVNRLGoNxc2h2hcsT0DMN8RZ+PmGIEmoBHu+6
	95dGU/3r6apsJpqt8EaKfqdzw41a7WlQT23y9A0siWQzvIDAFUyf0HwfB6jXETpy
	7ZqJKdfxS9JHmMqrOKwV4cNGswEKpJVxrwN4SXDMsbZfEcW89M5o+m7G+N2LywPN
	Xg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvhnsc4at-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:02 -0500 (EST)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5358515b4easo60204431cf.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419762; x=1795024562; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R+EjyARKBaNH3SkAfWpNAWHi3Sv3+8OGpYn7wnaHoKA=;
        b=4nc/+OS4GOY0tcTMtqhlqTKZDEEnOfKxqa1PUz4M655cGT+GeFdxWoBx5viTzyiNCD
         cug+85rJtOfvoXyDGREbRSLx9KSTJk8jHI9mL8YL7X51ZlzCXQC7IcftaJMZVCSycdCZ
         ylyKmY8ZZPvf1ckztjQmksp+sxnOZCAagJkmaGAec23mxZ3xIkHWAL11G9xkZi+WK6Vc
         +OtMiiS/urMlcgQfmeCTy5Rx373e+QWSZKxP82S8O5rjWh6R29cE9QdmnXiY7tU+Lhk7
         LcOQJtJYZnwQSdsBAV5os+7dmafK7CoXX+/FuZlFaefWcTW0osUDpv7YqJUOukoHT1A8
         BS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419762; x=1795024562;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R+EjyARKBaNH3SkAfWpNAWHi3Sv3+8OGpYn7wnaHoKA=;
        b=CGpBvo96lf4I9EjQebXM3vI/+deVVl59IDi1V1/XShGqMFVYZM3Yoi1+Tu/0R4nmIC
         z9nTAqTUktFivC419pkgILGz8Fjwch7YnFYl9gAw1FEtkQgcpWyXVpcJpcioF7xR0VOJ
         ue2LR4ShzHtfHRjohKyLlgSdPfdq0H1bSpLvep80g2nNdN88MCLsR5W+0YtyXVyItJaw
         UCMUAAZ/X6Bv9fD+nSEjBH/NL1pmkXLJg0QBRAU77LjomK+tuhmxNAmKTi+gzEvTLofi
         s5ie6l+RjJoKd0tuU9Gw0NJPMxY/+zFvs96W0+dA5jz/AjThkbjVFFelQzo0DBJWSRDy
         Zwtg==
X-Gm-Message-State: APuU4Z/CN6gBVYqe1Zcci+imLWKw7l9bhDZ2pUgh7zt5PuOgHRcq5M9g
	pMsCUBBOdoQyUSs2nMqzT61I/6sYAKDi9ki7Ihftf/MHSHJQBg9V7tmlmoNyQT0b1rngKkcgE6k
	I6gLTwPQqQ5hEh5hnW3gLOVnhP63uwkXTxLP+ggxF4HWYqDer
X-Gm-Gg: AYBFou2ndIv9I5M8Kjnu1y+GvCNwqYYYD4vSpBLIMFDxTjKZrGTEla51//tM7j9ATw6
	Zpx0J5QizYvsdoTdhaI64F0x8JFVPy5YM+jX384GrotJ+0u8HyB7JvT/g09T40O8f+JLa0wnDYK
	+Le+GNnt0ON4PCnmSetADkyphxRsnnhy9JajIC1BQFi+BffULlv8PGSj9M48axc7rBelAhUN5f2
	UJ1RDso4JMnR9UDYQkO06CfYjRtOeHtlDvlXiXDqvc3zPnKL2qSleCCLKNpTyNqw69M++VhOpiv
	0O/WQvt43P0AicQlCKaS/zUFPuOg3Sbtj7EHoVMvSrMVzKJvXlU2/UJMRFGMzfgSXGJjXQKnlK9
	tHrQurlm5R1s7DogBYn1PglLeF8xwmcP7tlh1e2lLR0FgtyA2gToOfOhuvuBI5oVrF+4pWbW2H1
	ZNcIrViiCxr7o/WoYKBw==
X-Received: by 2002:a05:622a:17cb:b0:535:87c3:79e5 with SMTP id d75a77b69052e-556c02feee9mr45374411cf.39.1794419761989;
        Wed, 11 Nov 2026 09:56:01 -0800 (PST)
X-Received: by 2002:a05:622a:17cb:b0:535:87c3:79e5 with SMTP id d75a77b69052e-556c02feee9mr45374101cf.39.1794419761469;
        Wed, 11 Nov 2026 09:56:01 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:56:01 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:14 -0500
Subject: [PATCH 06/12] mm/huge_memory: build the moved huge zero PMD from
 the destination VMA
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-6-00713d368976@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=2003;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=c/tJkA0ywzx7Mq78hcQB+Mewlq+Kcny7U2nx85cQ+eE=;
 b=gh8f8A+1RSt0AMZELb50zZ9wb86q/oSkQ+azdyShjWWpdd+2fo767l+7G2ocPpLH2v3rnH7js
 r1p/FefMvNpAgWeMRPyewtgYy1jmipy9Rtg6Vb0m1Snm2yWGvxN1MsH
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=S9lMU4sP c=1 sm=1 tr=0 ts=6af4ac32 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=dI9OOPIzGUgM9lhLtj0A:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: 6m_jWH4BEtru9Rf06gsqxAk1jgpqfAyq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX9ob8J50kLDxN
 rF4lxqJD8ICGMT3QoZlDH2xSVnRz3D5/yNPHOzGxZPvyY4xfpHrx0C2SUaO7gXKTQjP/LtUwOHk
 RoPEJXmrNjLR7kis473uJBdYl+E5J7fgqLchqbRtFK0aYN75LKVFdV/DT8Sk2D7hJSE1OLEgwEo
 U6wzsboAAj/vxwdvyBoIFt6W9Q9i804jSP1cUDXyEZ/sC/ZwVNkaRT+Qf7z8+2Ae2i+aKySF1AI
 hfIDgSo9j7f7Xt52fCsse1zJ/pX/4vh36FYU6hmg8Ykkxn2EHR5hWBo8fX5WKIIuMJ4aX9FGWun
 L6B1eDrZv7SBQCipR9BA2/vsRl+ELiAcNHQY3NmEkQgBOrpWdlNl8tKBQIxpPitROMBOKOEt77O
 /+083vsxo9abpGw1wY/G/gTLVWIDZ/JuYVTHh89tmVTxtEnWrgnIDOfhBMBHnuV3NzrZ1CS3rkE
 BoJtzApDijLRhtlwfWg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX7oaYcgGoCjxI
 JmDMVNjsA/LN2VulVjWhtIZSq7J8qGyIb7doA1TBA656Jt7DCBPbfwAqieCZhna830apyoqEqvF
 gqMVIwZe9j43Hw2CzamyTK4n5Nqx4u98dBx3O5pMppcnspyIcb0i
X-Proofpoint-ORIG-GUID: 6m_jWH4BEtru9Rf06gsqxAk1jgpqfAyq
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=10 adultscore=0
 bulkscore=10 phishscore=0 malwarescore=0 impostorscore=10 spamscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A76380005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5ewyom8temw79rzob8dwyjgr4onwd4tq
X-Rspam-User: 
X-HE-Tag: 1794419763-982406
X-HE-Meta: U2FsdGVkX18o9L1umI3anpdJYzxo4EbpFTWm6GEc/iIXaaziQQK2RycQwq/wFyaRLuCi30xWS4JbAemvH54C3iF5XvXPhZmBQcbnkxdN4P+JsSJNRz8CcYSWzNx2H/g3LOkMTrSAxfgBTB3xAGlkVMjwfcJ8I2GNplD+oMyGTd8wO3a9BlNT4ihrMpRpJJ0BkaftdqISk71dPgAyMXv61yhUNSpVM49S8rQwePNd3071L3yi6j3H752dVtYRON/+a2sGSq2LfYX1cliic4+WEY0JOk6Lq4jiw4Rl/1vOJmKAbqqBDHdo1cFIZCX3145TnUnRdRW90ePPX+sanravWYsOnNPheIWW+5GvRA3QKyerK1dIsS3JAJzteqf0ObsV2QCSeFMatd7n80MjJolnvJHh0mqh4rKPnH/6B+DeQQ6uf54h0aSzNDWa7Bcg44Ay1/tss+8Qhbm1CJhsEloxVFxwViNdEpWOZL1+StZBnp18lbbkGDTWFu8QZxjBlEtzhIwr/eauZCTqkpdWOHVuKnKLTKB75fht6je4tFiIrqGgon6Wl4mi8zIlikCYnHVrhjsRRnufotZbJkALzkD+/XO4CBqZhQBCB2fy/dW+UibjeXJFVXbTRQfqcj5XodO8R53NQi2w3FiOsgdpvaBzlduikYDFbHWc6HYDXXjUQ2oswQ27qLUz3F65Q/r4EB6WCr9BDuAGuFtbAggxhYodsufmk/Fzv+oNFkxdzEPJm+T7QnssYVrSACliAbVX3mj9USuzWlXMc3M02wdaqM0W/AxC3uxEK3MgaMWw8Xj2QUIgzbgniOu9Lgo8Wmmx/BflZ683kdTuZGqonmCGtrChRzLYkVG75dNK1CLzPQk7RtwsWh4C9AurResoIQM/XFQ9LiFZ6zX5XqI8j0tURaD0ARZEJlPbYtIiZZFgo1Se9Y/svs5L5J2Y04Dz4ATn2zWQJ4KygmJ0SiAOl8keCzk
 XZlf1SxA
 q5D+Dc7rPMvR83qfnfa1eyuE08iDTKGNrh+Hc2OL3m36RpntQiidPvKsGJ9UodgIrdq6BPZszkrtuxeX/FPYXkwhntyUH+L2jV6l0i0Yvt6SGlSRFRVftioAgEHSEcVyprawAaAownW7c3yYbvCOuowa8AGkJKTB7P8IihhTEv2TcMOBGF51nKBdXT0qPbepjx5KUyIa5sYxd1NkBpqpUPA1IivS2fTvjwK/MS52LFqMvIpWIQ7c3lw4MeJymED8wV/xoiRxJc6FFc/jX+Midw7drnFjYrNX+mizbBoO8Qp9o4PmjpQ2bvVbsUDQwVDG+jkPPjhladO9wReLhv5f+71e+SSo+HY64xr5iN1QDNDHzKzy5JJG/vZulq+U7z6i9mm9iuSIVO0TelO2sxsNEnJIdaadrmos73+9IY6gODaekDqvaHeK4M68BvCq25ZVCxTDaGUf3tpiVCnU3hnTy4gz2iLQEPZuPmBjvMxYFTMR/D3TW63fM8s66yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_pages_huge_pmd() builds the destination PMD for the huge zero page
by copying the source PMD and clearing its uffd bit, so the destination
keeps the protection of the source.

A source VMA registered for RWP can map the huge zero page with a
PAGE_NONE PMD, and UFFDIO_MOVE does not check how the source is
registered. The destination then gets a PAGE_NONE PMD without the uffd
bit, although nothing asked for that in the destination VMA.

The next access fixes it up through the NUMA hinting fault path. Until
then, the first access to the destination takes a spurious fault and GUP
has to take the fault path. The impact on userspace is small.

The moved entry must have the protection of the destination VMA. To fix
it, build the entry from the vm_page_prot of the destination VMA, as
move_zeropage_pte() does for the small zero page, and keep marking it
soft-dirty. A destination VMA registered for RWP still gets its PMD
re-armed afterwards.

Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d589be136d2..09176b290f76 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2981,9 +2981,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		/* Follow mremap() behavior and treat the entry dirty after the move */
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
-		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
-		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
+		pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
+		_dst_pmd = folio_mk_pmd(huge_zero_folio, dst_vma->vm_page_prot);
+		_dst_pmd = move_soft_dirty_pmd(pmd_mkspecial(_dst_pmd));
 	}
 
 	/* Re-arm RWP on the moved PMD if dst_vma is RWP-registered. */

-- 
2.39.5


