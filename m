Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0387E606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=IT/8NHst;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=qMZnsprd
Received: by kanga.kvack.org (Postfix)
	id 0F5B36B05B1; Wed, 11 Nov 2026 17:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CDF76B05B2; Wed, 11 Nov 2026 17:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7716B05B3; Wed, 11 Nov 2026 17:39:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C260E6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:39:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47F63C046F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:39:22 +0000 (UTC)
X-FDA: 85424305764.14.9E3E13E
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64153160002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:39:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="IT/8NHst";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=qMZnsprd;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794436759;
	b=pfqvi2/rt0R3dNqt2OGKZWJBJTFCem5pwuhV4UlKRYogmqGwPt8SUyjq6o7mpRqhAfHbrP
	6mzLGnkMz6uHmIYZ+pa7YOt7lxflOxQI72nNaTxak8jzEtM6ioXu3/noWOWFYMU0Ke0Nxu
	56FcaLbTlxTkb88TnE52bwhq/0JOhns=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="IT/8NHst";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=qMZnsprd;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794436759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyB99dES1VWSWEDHCuA5hRT/5p/ujc67VH3aWrgWNkc=;
	b=QrHmLRJBX6eDJTiUsPsbaozzlFlI5a+0c146GIRvovKnnzy900/Mv4z0sHRVT6KJS/27S6
	sHWz+G/cM+sN1CZXHAZ1v+gJyysElFnPjxWfMQ3rH5UnqzTh9b7zomH6YaeF5C3APJvUNf
	CThC/9vGg9dOXE16bjpy3dBfe8Lpk9o=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABMBwrb4018382
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=tyB9
	9dES1VWSWEDHCuA5hRT/5p/ujc67VH3aWrgWNkc=; b=IT/8NHstUgDEGgSQnLX6
	Vaiv1AWGs/qhkiRKlUcq7D3eR5gJ6ItvRqnKsmZtifCmYF83Etsk6xnSg4ghYtJq
	E3Nqa0kPb00QkhUF3JRsTPPds/3MgmGm6kO+aDh9nKa4vJnXR2esYIlCFPgPXPSF
	lDUFil5vp3qkfjAq/6sbqbK9b31ugJ/b+kyU7psmTCLkP66JQr1rsht9NlWn/cmN
	je7rKgCUnqELG3AW5AuZzJoGUPyEc5DA6apdCCOb7QTWpyxE8PDE5hdqLeYunDsC
	dTBiuFo0GmbBv8Ls2WN0w0DzSQA2IFSMjQ7cwioWb1nXGym7TLR/jbioy1JwNf9Q
	0g==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hvwrc1w1w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:39:18 -0500 (EST)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91b937ecbb4so70639026d6.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794436757; x=1795041557; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tyB99dES1VWSWEDHCuA5hRT/5p/ujc67VH3aWrgWNkc=;
        b=qMZnsprdrpLlKmY/IAi8vuu/Ds3nNqstyGmn/7y20m/D6gW1yzKzVGvmolkd9g6qox
         CkaTtem2YOFYway6iF+2dpTxcNdrQSVXReMGWutljc+uATzWVjLfQmJlEMu7QMozUoH5
         RdJeEuMN7iB651XH+OuC/oODQDA8jcNvZ2rb6oJK75TKg3oGafOd6ApkDAmN62jIpQta
         USFnWXyKDF4Kp5Lq64dcBAwl0L6cd/83MaA3nMdK192sesV2fcg2dQX9rK8jGAwVpv4V
         cV/a30tvkD2T7mTNiUVpimpW74QA1phXFMEmiwPPENclkXBpfbccKC+BMhrmJ7HQK5Qm
         Pntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794436757; x=1795041557;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tyB99dES1VWSWEDHCuA5hRT/5p/ujc67VH3aWrgWNkc=;
        b=h/JFZ+0T7zwWpUxlncTjAPIuWgo0FJpuKT/D/Q8EKt3PuYxpQEFpYnh2i3BM/qZ5Um
         zSkRxZskbO/+/p8khqY18VNbje3cw4Vnf1FQcb3RJtufjPdBqj26SGqDTVmFH82rAZJo
         8g4txh5iX6lKursfTQKTSeLRv6tU9rYqaLfGxPTjH9oYehBRrIAgP7D3bloGocZ7vHZ7
         i/6lU9IemL5/72s9yDWJaTPoRBRbF1I5g28ki/LEwL91BL+QylvOyJPVS6ZZ/Wo9oBwG
         +JNoM+yBeLjKlpdUuFciiY21Q8Of7fC99jDknRk5WTLMZx/741ZG7ly4lCJSu+Inla1w
         UeWQ==
X-Forwarded-Encrypted: i=1; AL+hErH2IhuENM7k503cTdAuCUI7kNbVuBbJB82l4+mn9o0fsjwZaUx4YaMtpnv4dABfXN4UxmWxCRIKqw==@kvack.org
X-Gm-Message-State: APuU4Z+0XGvJ51GgGckhr0CB40W4Z9ob8rZfw30u4Zi+mMqe9lFIOgn+
	T0RzzXtHNa+6oN1o/tXq4excaTKkneUST0vSzE56ERvxS7+6woHjFtLkGrs0dBLNCbNDkjI+b5R
	OydLSY6Y0rOw+MY+2KKkKBmTzoh5G9AnzjXkBxPEXw3B3zMI7
X-Gm-Gg: AYBFou1fP0zFdnMvEk64VzkV7OVWmS0nPFFXXlfwzXnh2fY6NBhr4xkWWOd6B+AKd0l
	iJPDos6PdPh3hPSnGYgd3d5xJCLewH/tWfVNRARX0aCdctpsu6iu49Lres2b1K/ZJqQiZ4VKWWO
	C1A5MVAVQ+jf7ZA+Ne4hPC6DewU7J7G9g1RsdH0udG299I9enxw6BCQqOKb4v3B0AddnL8wRTp3
	UvqOo8eMpV83bJt6IxVfIg7gjZbeU05b3gx/6an/5FB2ZDPZlL5IyQnvJE2FHt+ZQp3dwcn445u
	k++oFU5PyaIXpvZ05SgYqGuP4KYyDKXHRyVzgZpzbIyG2hAGYgX+UeyDQ7P2DHPQeO5Yizoohwr
	ysT9hhwHAjiYlt9FPKc6BmnpUJO+refRdvtapvo2bk0XDll8KBDQc9sXxWBrV07/TpVdFxqSGgP
	9bSNURB590siIJBAJ4zHFyaV9rs4M=
X-Received: by 2002:ad4:5943:0:b0:91c:996a:7fc6 with SMTP id 6a1803df08f44-91f03e26d40mr67403476d6.6.1794436756510;
        Wed, 11 Nov 2026 14:39:16 -0800 (PST)
X-Received: by 2002:ad4:5943:0:b0:91c:996a:7fc6 with SMTP id 6a1803df08f44-91f03e26d40mr67403156d6.6.1794436756029;
        Wed, 11 Nov 2026 14:39:16 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-177-239.net.columbia.edu. [128.59.177.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef04d8397sm57802366d6.18.2026.11.11.14.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 14:39:15 -0800 (PST)
Message-ID: <956d86f1-9d8d-4d4a-91a1-00583987c622@columbia.edu>
Date: Wed, 11 Nov 2026 17:39:13 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?=
 <mirq-linux@rere.qmqm.pl>,
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
        Chris Down <chris@chrisdown.name>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
 <avS_43B79K2lUV3Q@thinkstation>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avS_43B79K2lUV3Q@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=DbaCOftW c=1 sm=1 tr=0 ts=6af4ee96 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=BoHXNMl2GZKy+iVh/K8zVQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=VwQbUJbxAAAA:8 a=kkTTwOaqnXeBwKB4IF8A:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-GUID: 2CRLswc5TVDPjEPHJEM_5cvJ06rIcAkP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA5MCBTYWx0ZWRfX1OEsUMK/6pUV
 KlPeBdRUMxEHBiWpyUmKF7Ab30iOtLo9ATHvL6q/tvLrHUbv0IZ9fwQwBOBNxeGToz21LY4m3y1
 QRs7kd1vU11hjoTHwGYT/Of+t6PGeoJTxW30EZxvc7o9j4E3s6hj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA5MCBTYWx0ZWRfX4ZbKxnzd6Esc
 HDQZQnA/EUKAzq0WGMPCSMWOYFpb9HY8GEhV3GIMHRmD2P2x2z/EsdpFvgN2rEJRRxHd1vq9tql
 KgWsytO3bXm7J9keUWDgsS36+6tA+8+ekE+6NVbOVHImll8hduC7IKmBVULhjN6PjYPIqNsOrGt
 evuu/r9BbeH1q7G0IowiapOf6VFTyRmEcc3Vx/GkEImTYuBl6oBL6Xv9ETVtH89ekT5BrSboDj0
 jjecZ5ThJsmIxDwVT+F2THeV+mEuPNuQCvTdJno3Dyqz4oZVB4K5owgIx/DNBrVgDzUpqiqmwgs
 Ij6wARypAqifLmFoF3HgglxgvfwAIkdz+cgB+23pu6RV9WRwt41oWHhTuwYKhGIrUCSLsMyP9BG
 DgHAc/DGt58yvydxFWNvCjjYPXpl3a2Aq1ZD+ciYyoGGJIPR9Sc2UuK6fTcrGaMag+GYCN7o5ru
 6bnnadOuMkzU1tMdzuw==
X-Proofpoint-ORIG-GUID: 2CRLswc5TVDPjEPHJEM_5cvJ06rIcAkP
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=10 lowpriorityscore=10 adultscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110090
X-Stat-Signature: m9npy3cg6388qnuq6igt5zxaw8jh7pph
X-Rspamd-Queue-Id: 64153160002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794436759-885133
X-HE-Meta: U2FsdGVkX18aUqLxwwfix+kvIfq3NTIjnw3J2cf6jNWbH6beZQ41P8QuORPLqsxIxLN0tdFDXDVX0XPHpNZhaFClBnUGaoPHNBIq/GEbBJ1S3jGH/GDQa2bTF/wJCBuktC6CBalMfpcrzt2dKWxcehAdiT+dgJB2Kc0DC25neYhnZ12dNBnHjozBeeMV3aInV1QlxEQTcmIB3J9TojFGQfh1yMOAlltEkpPUZmvAUzdKOQhs35n+Z8bACOtekY72Q9uQxFIWdH7NZ8nmS4AISwagy+RDNfcWUEPNHQ2S4uSY1/oireT1o6LyaeAZ/b99mV0Y2SqvfH+wFaOPHuVaW0lHR2SGuygAVT9aqmG7KPO2WdGFG3a+pyHm36m+EWf8DY6+z3SoIBCxzg2u9dO2Aq1ErUcLGx0Ot3ID04NL4ydDtNKeRE4dOURWe4s0Zr8nF2zdyVYH/wK4KQj3aRTGEh5XG+FTUb0xzxR5evv0HnoVzh2peKbQcKQkRSw1MZpGzd4uwTkpIoHxZOiJLMVbq5ctT6HponLj90tMvKlLICQTP+2GLJCeExK0AGtPPsuWuWqHS/fbJ8YooyRpp1RNbbYrpExHTYig+HoqDRNULcRXrEsbfHgwPrmF1qUwNfwtX2c3JY12UbzhbezgLxKAhngf4XhkjcbNPkn/U8/Tn4gS/Gn48HuMVAdTuNiPRNbTxMym/hFANCDwKz1nU1BuWC1pPbM9DTXmYZOIngVRtAEY8E1LmB3DFE/VL8V7n5V3W3yUvIldPfCN1vqgsak/0+tiT+O82mWDm7ln2Fmf3JqCeugRNw07SqNuSP08USXVSdeTSFpxm0U/v2ZSlBhTgJksS9bSznQqbWONy26TcDoXnj/kxCo9NKIFw6SrHtZVhYiYpFnJLGoqyZTTBAnu63O4Z51IaBhevmI95L10+99gGM9pPTKkfR33Mj4tg1+Ia+9d3p59J8I452Y16xy
 HLtBerO/
 JR4TAk9W+3aRYAKSL5Ub7oKJ46Qb/Qmpst6SGhKozU15HthZMsiZLHki4xf5IATT2fGBgLgISsIzkCJVUnVfucM1xtMQ4Iqt1Axsrk4w/SMaZp6z+Jbh+oOLQLuvLGv4gMO41HiWAbaP/CdcmPzpC/df8jgHcnifrsIt6BnXA574HvgzG+fFFY1maUE/Nyfs/hfCUd4o304JMWK8VxoK1vzU/c4Pw4ccY3+fpQPCb6bLbR2IkukHOUXk3vVseuhuni1A29ZxCA6qpy2AZOZapHKKqrfWHBLv9z2CHJVKFynDvg2ojcmpIB2ZM9EtOzPWX3zDEwpdsAqh5owVumrW2QRsJ/fHUkb0sjdFg/2ReUkIlvcL6NEr8qUAaFA/gewc1VTJyOHuD5BniKBiV5O8hmy0FR/noytOsom59elJhNwfKHB3jbim81fB8P0Sih59UQDdiVKz4vo8bWNSWDQu+keq4TlH/cOiG0IVJgVI9kXOFUDZaSNBV+LVuchUSLVEjFR3xxZa4f6mxiAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 2:20 PM, Kiryl Shutsemau wrote:
> On Wed, Nov 11, 2026 at 12:55:15PM -0500, Tal Zussman wrote:
>> However, this adds spurious minor faults on shmem and hugetlb.
> 
> "Minor faults" reads as UFFDIO_REGISTER_MODE_MINOR in a uffd changelog.
> Maybe "write faults"?
> 

Yep, will change for v2. Thanks!

> The RWP side keeps its behaviour: vm_page_prot does not depend on RWP,
> so resolving with change_protection() gives the same PTEs as the
> per-entry code did.
> 
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> 
> -- 
>    Kiryl Shutsemau / Kirill A. Shutemov
> 


