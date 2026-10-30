Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99E5606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=dss6POhi
Received: by kanga.kvack.org (Postfix)
	id 075966B05B1; Fri, 30 Oct 2026 06:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DCB6B05B3; Fri, 30 Oct 2026 06:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA48D6B05B4; Fri, 30 Oct 2026 06:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C28736B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:44:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7A16801B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:44:56 +0000 (UTC)
X-FDA: 85378959792.04.D1547C0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4F8FB20003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:44:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dss6POhi;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of pavrampu@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=pavrampu@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793357094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+c1ihJ1Xln4zEcrREqgDAfDTBrnVULNOnFAexlBeung=;
	b=FQYacGW9/Qo3SaRRpWcfmkvPIM4SjSv5XBPTnoGYtgVC/1yNfZIqmS2XGfwgMv1FyTeaNk
	Qp2cEMlGUc/bwil8EBeKuqXIX3nAvl7ZJROILsflXiuj7X7c1D+1yVU8MuiQiwhYtRA9wc
	8YlMMoN8AM49Dxifa17G4pv7OzmO2zk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dss6POhi;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of pavrampu@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=pavrampu@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793357094;
	b=lNSer57+hk6S8OWpItu+YKxI+te9gaE+d41yhgDDa44ggbDe0oOobzPv9VT+hOoQyXkMR/
	Ordtg0Ch/ycUYrww47OuQOjGyf8bCV6puu3IPw3JRWBhvHPaQCLSkgGkDNQKXm+i1PyFi2
	nUMIv+itLqjCXJUUAlcm/3njanzoCiw=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U8ET8p2376743;
	Fri, 30 Oct 2026 10:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+c1ihJ
	1Xln4zEcrREqgDAfDTBrnVULNOnFAexlBeung=; b=dss6POhisLc8cfJCKTifeh
	e+zeaNYuHH/S+VNxv02rsfOpAAnPd4o3EXWVOgIGXK9wUtudQiLRLunlWU3HQbEF
	S+RaUFDI4QzfXTaudAzQsGpG3ulq9R05Lr8IiUi53XbtCC5IhlRkLd02Jj3UHjEf
	4BqxYQLvkunC4NMK6BIf1xCGsuPlWAxHVvfNCoeq3IP9B8Dmu/h2XQgk+MADFPuJ
	SX4qeCc3Gn40ncO7VNprWTsvmwMinfoZaD0Fdjb+T6w4q+QwsicEEUW9BDNaVvkf
	OJwxYVInsMUKK8S2FTdTdK29t27jsAs5n/zYE/1G643+3AszcO47WJxIxHRkWXVw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hmeay29j6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 10:44:23 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69U8Jvbq238919;
	Fri, 30 Oct 2026 10:44:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hm69e47b2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 10:44:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69UAiJoN44892546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Oct 2026 10:44:19 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0651320040;
	Fri, 30 Oct 2026 10:44:19 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4028220043;
	Fri, 30 Oct 2026 10:44:13 +0000 (GMT)
Received: from li-49acbccc-2994-11b2-a85c-d51b89e344f1.ibm.com.com (unknown [9.43.39.23])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 30 Oct 2026 10:44:13 +0000 (GMT)
From: Pavithra <pavrampu@linux.ibm.com>
To: songmuchun@bytedance.com
Cc: akpm@linux-foundation.org, chleroy@kernel.org, corbet@lwn.net,
        david@kernel.org, lance.yang@linux.dev, liam@infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, ljs@kernel.org,
        maddy@linux.ibm.com, mhocko@suse.com, mpe@ellerman.id.au,
        muchun.song@linux.dev, npiggin@gmail.com, osalvador@suse.de,
        qi.zheng@linux.dev, rdunlap@infradead.org, ritesh.list@gmail.com,
        rppt@kernel.org, skhan@linuxfoundation.org, sshegde@linux.ibm.com,
        surenb@google.com, pavrampu@linux.ibm.com, vbabka@kernel.org
Subject: Re: [PATCH 0/4] mm: Enforce read-only shared vmemmap tail mappings
Date: Fri, 30 Oct 2026 16:14:10 +0530
Message-ID: <20261030104410.417740-1-pavrampu@linux.ibm.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019090830.1917657-1-songmuchun@bytedance.com>
References: <20261019090830.1917657-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Cq-D5FMcULtYQJqPtFBU-Ss_evhba_3I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA0MiBTYWx0ZWRfXyG+fs1ghDdeu
 MufdeAtSObpnKs0XjFFcDX2NqGMGt7MHQXUNybXyz53Fpx5amXAtuMm34jTk75sa+4qr1stjkxL
 W4mTEW2Wg+tKYnjBZPaniDSxElpoM6rAiJnRlo+5BEcOeBlWQmiSqtSkWZg/0RqOhdewZE5nCHS
 7F4GF6CU7dxnmGk6bXQZHzXUjhtxmPB8nhEizRkNqNRacXRUjHfBtpcS3vHNNqhbNQdbb2k6SyP
 4iWd5KSjzbKBagjm3VDXKfdYWa6BxZ71PxnqFHfPoO3orZam21OnNKnNL1mznBWbHnLEZR5yiAF
 nDT181Dq8h0ROzEuGXqsq3AAvYUh50njhXSMNxxLZu3pfolJkFLeftBVau3zEFP28NqImjRMB5V
 GyfgLl3sU7eiZvH4nBoBbVhnvQrP9SSBSXEWVfNTwXvjlfqm88/iv3UwT9mdRlxXt22gSpz+Htf
 OPlw6g22K/JelFWbJxQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA0MiBTYWx0ZWRfX5dC/lVTICYYG
 PJrbr8wpoREtd2C2ydh3d2GuaJgASQ9dZh5g7ZaHXI4cuQzosbh6FtReDhmycaMxMNbqAdhNIgz
 Meh5Gf3IkxQBnIaTiPevwSoYHYeShng=
X-Authority-Analysis: v=2.4 cv=QbjzLcbv c=1 sm=1 tr=0 ts=6ae47508 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=Uv9NjG45AAAA:20 a=VnNF1IyMAAAA:8
 a=8zS9G5xvJLahJeJr1kgA:9 a=zgiPjhLxNE0A:10 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-ORIG-GUID: 8kHx2nZ45Fplgz9D0Wt0xILKkBxGZrzM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0 malwarescore=0
 spamscore=0 suspectscore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300042
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F8FB20003
X-Stat-Signature: khmhstrqer3bkgu9oz3kebbes5nc1pam
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793357094-965520
X-HE-Meta: U2FsdGVkX1/xOt3QCFB8VLokaDPLxxXw2ny94Y6hZBkcp0idzZn1k67ZxHnDPJ2g+7XhZhl/MwMEfWPI27BkmJceK2JgGdrhkmZSeDNj3EfTgpUZXOiZK8pDlpIdyEJEd5cKtBIJ42Y1Jq8oFQs/Aumk0TwulV1QI4DSrgX4xGAG14MneJs+J0A1ZcTDCRJ1s1Cxm1dQZXOyHqHe4I68u3Aje7EbsfhC3zbWjpaBVWDz4JPO1Ci7zenggSXfr02KMhbafyl4qCwmpsLAzut56dKozh4VoZouQhtK7EXPv7td7Dic6fOMEP/upWfoisvPnp2vbyhh2z8gZh4O383jPktccUwAhe+dqQ6NzdmLs961JcxSCIQVXHDpGY5Hb6eVSIumF/vpV5pxcA9ABBXWyS0ARaT3yVnUy6w3sL+DP3mQFPa50N7nfPw4Vtuh8OMNsRxGDCUFiP33FV99rVX12KBZCUwQ5rAH5XLcXc7AkApZuC3mQMQtcUkD1R9UTFHY5XAXKVzXmaEmfjP3PyW5hB5e/ee80r+hE4c4bHGXyQAqH3fEUjst4946gcH5d3MoO0D6Y9fiCAgnfvYhWZrDf1e0tLth8eeCpBv3/VfZ6IECvI0wSpxs2qwxaOfCPtC9wFvrAsQwCnLHzFjfNNd2jRifXUo0ih0RY892ZWDUQyW1JwBq2lR99hKXX6g7NXuzyrh6XqOq2Ngi5uWddVMdXelaqT7V4xRQdxZPdj7PNzEGARCuqc630j6234iCcPM/aDeMKBptYQw5cnr2wlKsdfYJgQePRFPxtLyet6M9LRRiS15Rcn8xcUWaqA4f9WqkYUBmhSFWgfwOTdlNMI9mHRKw1scbfEBGngsty14L+AYWLWSB9o7K1938cAQujkmSzr1gvLQzC6JJx4wG0GC4gxwKQlYCS9gWen8u4ootnzkI7Ku+gF8GImCtIf4t3gvCH2fHzjluF+o9gfEh7HI
 oiLljbVm
 TzHh9KCRfL745dn8orxC4nourGgcpXaJwZRCoL1yurIUZ3E6I1YR2u7XhCAaPmVQuryD9cSEr03svtBCx9XUZLEvtkC3hVRC9NP+bG/l3TEKM/CkW9Y6lz0EK5vH62ZYwhz3jCQfz6VoWEoKxQYDRpCuQ2q5We/eTDrOBWgwp093mB7482/oXWloL+hZgYr/LHVxeXUQBHqpkoPRlynIYmsAqFbjIJWB5byYC2N6IUSTvri7vi+hY2ySrGaUGPXwh0NJBSPTWrHXVh5QEptsRlbkoDIA9jUXirk22D+DXgvoBRqmsqsW+8SCYrPJDTB74l2eeUHWL3RzeOpd7fU8TuDiKpcWD0kdzvEdp6/jQ/hI5wk6M6VNALZPoDjtGLLJGUOb645dcSwH+GWmKydI4FZej58yRAdFPM/KUOJkYieIqhYGz2nsqu9BeUMWKk6jg4WxZSDFeOj+qfyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Tested on Power10 (ppc64le)

Test configurations validated:
  Page sizes : 4K, 64K, 2MB hugepage, 1GB hugepage

Test suites run:
  - libhugetlbfs test suite
  - LTP hugetlb tests
  - mm selftests (tools/testing/selftests/mm)
  - ndctl test suite via avocado (--map=mem and --map=dev,
    2MB and 1GB alignment)
    https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py
  - HTX mdt.pmem_all
  - Memory savings validation with 1GB alignment
  - Hash mode basic pmem tests

No issues observed. Thanks for the patches.

Tested-by: Pavithra Prakash <pavrampu@linux.ibm.com>

