Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1277DCAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 06:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619CD8E000B; Tue, 23 Sep 2025 02:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8F88E0001; Tue, 23 Sep 2025 02:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490DB8E000B; Tue, 23 Sep 2025 02:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352768E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:04:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A139B8A53
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:04:49 +0000 (UTC)
X-FDA: 83919476298.26.C196374
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7922414000C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:04:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=Dk+a+gvO;
	spf=pass (imf09.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758607487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ysy44PRCh+/6wV2z+Ca/XezLJJ6mu2BnXGwORvH9Dd4=;
	b=MlYnvjSEFAd4qFWi98VkHyas/ntlODgXUTeDgVhGhskjqN2mTbgy3lNsfySFQlzwETytMV
	/qO5egmQNviEUWhWJ2thVuZPSPIK40qrhxUomNlTs1T1wC72MqChox5Egqpr0p/7jfD171
	auSFnCfYIlKHTSxX84JSYalPzgwUvEw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=Dk+a+gvO;
	spf=pass (imf09.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758607487; a=rsa-sha256;
	cv=none;
	b=hr9JiyfQl5ZFbwU1Ejl5aXTl7dQpo7A3L4eK4upL+4TbeiKyG46ZNpqBgoCJYgivrkh38D
	MkMWJcdan06rbaM8xT2CY8SP4QrOQ1f2Nzfj9oupxi1b2XSPoK58fe8PQ1QRJrfGrknW1W
	z2mF5WWmp59rtGmIpKxZXjFb8w/fdZs=
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58N52mPd002159;
	Tue, 23 Sep 2025 06:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=Ysy44PRCh+/6wV2z+Ca/XezLJJ
	6mu2BnXGwORvH9Dd4=; b=Dk+a+gvOqKbwRKGH3FWybXgsxrqXr1BZ1JKFr0W974
	/CSXr1RqrpMiOlbigY36ncNFyRVAuz8eFYNzCDN6uh+vhVujq21rkPbXPmRyRUtd
	CjXJyX5Dj+8PNpKae+cGn9xYhD9KWYmV7a2JLVCY7DgRnBBesNvWlz/vVRJnYXWr
	mzLrpCxuhGfHDU6Gc8sqEphT+DujFMSEeVrkuMLfiPVr4/hbEaduEcu0YaO9ltGD
	nY/6xX01dTUYb8VODhtkXXTezQ9rRBW2swIQBO8i3jBv3xCwJ22WDd8K+97H1zll
	r0OI0Fg+9X4DSI79leSDIIl1c03U7LzcDNHGfR7mGXwQ==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 499njsvuu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 06:03:57 +0000 (GMT)
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id EF4A212E97;
	Tue, 23 Sep 2025 06:03:54 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTPS id 1E7D4800464;
	Tue, 23 Sep 2025 06:03:50 +0000 (UTC)
Date: Tue, 23 Sep 2025 01:03:46 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiaqi Yan <jiaqiyan@google.com>,
        David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
        corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org,
        jane.chu@oracle.com, Liam.Howlett@oracle.com, bp@alien8.de,
        hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
        laoar.shao@gmail.com, lorenzo.stoakes@oracle.com,
        mclapinski@google.com, mhocko@suse.com, nao.horiguchi@gmail.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        russ.anderson@hpe.com, shawn.fan@intel.com, surenb@google.com,
        vbabka@suse.cz, linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aNI4QgvyoSrP9-K4@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
 <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com>
 <aMsDJ3EU1zVJ00cX@hpe.com>
 <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com>
 <CACw3F52p45t3iSZPjx_Lq9kBn1ZGTDZsxk+iQ-xFA1zdvdqqrw@mail.gmail.com>
 <aMsR4Tr9ov1pfucC@agluck-desk3>
 <4d2e8686-8810-4901-8483-9b5eb040d489@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d2e8686-8810-4901-8483-9b5eb040d489@arm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDA0MyBTYWx0ZWRfXzcE78KgCk5qI
 +8m7uiJiXKq3Bjdp0HM5+DG3CMW1LZlOucsOc7oyEMwy9uExNSuJEm2t+SnHJWgGFL4+kFni3IY
 m/IKGCleRms7RDbsa0JfH/5/3M2HOXc0VT7mfhDUxdHpS67UZ58s9fkz3Qo0OVjTn0BShG6FEFB
 sraZTw8JtCUO1SOJPj90ij26Abws8eWBhWElzWWmtdQlfOul03NcxKtESHxsXUOHG3bY728UYDx
 /v0lsrN2sS/UldafeoxcuNA7dOhXJm4AmlBRVCqwDSfbJBnRXnDwEdMucZym2sEzDwi5d8PRtS1
 aYkdvN11k7xcHo9XFQco7Z7co2gA0AcV8hl380giL/mxCSIBlmdTXf+1GMbNri9gFzC6xwtAni5
 Y3Pd1c61
X-Proofpoint-GUID: aW_AMqUIMxBuviqCOxNsJj0xPx3M-AnV
X-Proofpoint-ORIG-GUID: aW_AMqUIMxBuviqCOxNsJj0xPx3M-AnV
X-Authority-Analysis: v=2.4 cv=A6FsP7WG c=1 sm=1 tr=0 ts=68d2384d cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=QQnSzdILfhi0SjpbxKgA:9
 a=CjuIK1q_8ugA:10
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_01,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200043
X-Stat-Signature: wfmp5ip3546gpy4u6u7ccd7aodwyowju
X-Rspam-User: 
X-Rspamd-Queue-Id: 7922414000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1758607487-574567
X-HE-Meta: U2FsdGVkX1/VoZVViArByrdEeOoR/+UlKUB4+gQXlKyyaFWrgFufg9jSEoa/jPSVLo3Qbnm9k0Jrw8HbftAs/8QsV3IcgPX0Dvf8zFCzoPLr5OFrnIz5fhC6+N3EaxqO8jRzCkAx0o9NBBVmeBO9Do7vJv1t5RkpNYBSweNNLEjpjIqXsVXrnjnVsM5cpJeqwOcQobWo40jpJsdCXUQcMJBJyDJgDk2vdJl1F7AFtap6XR7erneQiAwv+oFPxrdrYNKLGvCd8WhLcBZKLaXKvNqJFdjvLwITh61y0hwOCQLwDL+xIyuRk+acGY1Ln3rfSTcMoqUiS124719hdRsZehdGQ5k+11mRJnbxs6gagfaAGn+LjPDADaCTY4doLPRhS1Fq510+sFGB/Gv+P9XIsL+s2bJoM93GnGWacuELVdXXiFeNbYFJr8xwCPfYIvUT2uwkRAmvIIs+Ddot35k7JS7YCN1FAIrC3tvC7X1OkOlzIrUDxcH3n3kY2DJ0k0IC4oasdEoXXoQ0fml6/yyheHEtZ4ByvebzEoxeFEdH/9rQRR6cPLD+g8CqAghU3ABT+W8RTS8SP2PZI1fhzchoFFzFyTOJMUl8szG7zXbhlgtZO7JfyepM4xjW6sXSDSjGr2JwiMor0iNWoQq3wETLDvEzTBBtjrq9eIEMGOYydv4qLSv3LPztUFsiPT5gmPTqeRRdR4/PU1BVRrqxFaNZAdcKcSUM1hagbhsOGsZ+HGFqtolIK2/jU0z2L5HZOrhMEKqg+bwVSlWxxeFhtD2L4GziWhhDqAlsqDBwmbHJaW+yZVphs0oRvZ46yuOVWLCI3pA3SJSIQdkDVkxoJ8jkoc0DFQojLTbz8rsnPo/EPQr7XP5teAjEM5Q39oBLeH8h2iIjRaVs00WsSGloTXcXrGf9PnYHZOtbRVG9Hdt1K94ptjTMTkEI2r4yC7zuXcqB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 05:06:31PM +0530, Anshuman Khandual wrote:
> 
> 
> On 18/09/25 1:24 AM, Luck, Tony wrote:
> > On Wed, Sep 17, 2025 at 12:32:47PM -0700, Jiaqi Yan wrote:
> >> +1. Given /proc/sys/vm/enable_soft_offline is extensible, I would
> >> prefer a compact userspace API.
> >>
> >>> would create a new file, and the file has weird semantics such that it
> >>> has no meaning when enable_soft_offline=0.
> > 
> > So the expand the bitmask idea from earlier in this thread?
> > 
> > Bit0	0 = soft offline disabled. 1 = Enabled (but see other bits)
> > Bit1	0 = allow offline of 4K pages, 1 = suppress 4K offline
> > Bit2	0 = allow offline of hugetlb, 1 = suppress hugetlb offline
> > Bit3	0 = allow breakup of transparent huge pages to just offline 4K, 1 = suppress transparent breakup
> > Bit4+	Reserved for suppressing other page types we invent in the future
> > 
> > Values 0 and 1 keep their original meaning.
> > 
> > Value 5 means: offline 4K, keep hugetlb, breakup transparent huge pages.
> 
> This disable bitmask (but when generally enabled via bit[0] = 1) method
> seems much better. But I am not sure about page size being a valid page
> type classification though. Just to start with, defining first two bits
> in this bitmask should be good enough, which will atleast help document
> and validate this new interface properly.
> 
> Bit1	0 = allow offline of hugetlb, 1 = suppress hugetlb offline
> Bit2	0 = allow breakup of transparent huge pages to just offline base pages, 1 = suppress transparent breakup
> Bit3+	Reserved for suppressing other page types we invent in the future

The current patch is already applied to mm-git and supports the following bits:

    0 - Enable soft offline
    1 - Disable soft offline for HugeTLB pages

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-new&id=9ae6eefa4b6bd3c3e7ef417a6507dce4b55101b4

Are any immediate changes needed?

Support for additional page types, such as transparent huge pages, can be added
later as needed.

Thanks,
Kyle Meyer

