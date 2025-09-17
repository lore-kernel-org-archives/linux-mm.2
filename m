Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 151BBCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D328E0080; Wed, 17 Sep 2025 17:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705028E006B; Wed, 17 Sep 2025 17:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61AFA8E0080; Wed, 17 Sep 2025 17:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 518128E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:39:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24C8111A58A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:39:47 +0000 (UTC)
X-FDA: 83900059614.20.BFBCEF9
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1EFA4120004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:39:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=TS+ImPEM;
	spf=pass (imf29.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758145185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7aywbVgoWACndDeOW0D7B3YoIkDJpnENYBe2GyDpVE=;
	b=AbfLQ6LL5L79wFJ2+NGI6S3fGgbUDiRlKjWPriDwDH2ndZyEYVbIJUFxwWOXHjZThOA4i3
	v8OjaknzQPpBXnrxW7Iatc6N8oQPQVNiDktcXVSuhaLt1utMPM5eGwzkAIM2dFupgi+p4g
	ereopwCffk4dYIjeZ1Cd0trEFYSA1Ck=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=TS+ImPEM;
	spf=pass (imf29.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758145185; a=rsa-sha256;
	cv=none;
	b=5RDkfpLdscm5ZVVFs1QBD5C4dcqyE/Sov9VQY4d6JW/60j2RT8aq/wQcQXIPWKAlvEI4Oz
	5w5OlNDRKwfYjiT51HvTqNpKhTqPEh81MSolsKXQCsgX0GC9Ewlc/48Ow9hz8JbFtEGNo0
	JCU9F52amlBJSYAVMYel0ziY7LTaOD8=
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HLbTx2031830;
	Wed, 17 Sep 2025 21:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=e7aywbVgoWACndDeOW0D7B3YoI
	kDJpnENYBe2GyDpVE=; b=TS+ImPEM9BnHP3pjsIAzoxU99Ze3vLHdShH8ASvMm8
	FwykYSUvQfUo4b69MoVprjuxbc5xtMnnAggTGlywAy1mRBGpw1hiiy7Pdr+GrtDh
	mVYloPY8I5cBTrKCxWuGN+hgiJNRayFGiJhC6DOIrhD9QzHvcAz8UjP2qOgKlZpN
	SQIXDNidMKF9KrtOobcTEPKv8CJ666Eftw+csaSfkhgIOAa4ufr1Oh0YrHveLsvH
	8RGhGG/OZlOd/qUqz7jZA4r0pLWR3Z1j6G/VprUKBmshuhN32+XIhIu6dVqt/kHB
	EFsgAN9OvseDuBWr5X/BdwI48sHnuTfa9mXjPp7wosEw==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 497y4f2xjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 21:39:12 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 0A89D130D6;
	Wed, 17 Sep 2025 21:39:11 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 1A621804CDB;
	Wed, 17 Sep 2025 21:39:08 +0000 (UTC)
Date: Wed, 17 Sep 2025 16:39:01 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>, David Hildenbrand <david@redhat.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        akpm@linux-foundation.org, corbet@lwn.net, linmiaohe@huawei.com,
        shuah@kernel.org, jane.chu@oracle.com, Liam.Howlett@oracle.com,
        bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
        joel.granados@kernel.org, laoar.shao@gmail.com,
        lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
        rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
        surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aMsqdesM1ImJp1yt@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
 <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com>
 <aMsDJ3EU1zVJ00cX@hpe.com>
 <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com>
 <CACw3F52p45t3iSZPjx_Lq9kBn1ZGTDZsxk+iQ-xFA1zdvdqqrw@mail.gmail.com>
 <aMsR4Tr9ov1pfucC@agluck-desk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMsR4Tr9ov1pfucC@agluck-desk3>
X-Authority-Analysis: v=2.4 cv=FoUF/3rq c=1 sm=1 tr=0 ts=68cb2a80 cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=-yUDYzNKurD68FfYE3YA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: -t5EYyscZvkXoKgU1Fr4v8bU1oBCB3c2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE3MDE0NCBTYWx0ZWRfX3tXC0LyiZmGA
 EQSbxobfpqBJ2/TPQVKW8un6ill+kJamYAOG2TNuIPQIDu6vQ4oz/swV8qQUbtXFdefRyu3kzD0
 0/RqovEVpnKbXv7WT+CSeihWkbOyM3Q26jnL2O0SNy9YpUBnXaDgXQP3fN1ANJRH6/e143PFK+T
 GnGm++4JBCUndCS1f4ekeoy7NuWS7nDFC+12d3b1Poz5lIJYQcxeEnzQtQGg9MTISmoyl3T+5ak
 2uf60DEbMDNIuFuFx7GIuUHLszdqS7NMXf0Xd/ndH6KyLRmnmoqXKGPbmep0T4d23Pt9VhCo7Xp
 4/orMAto6QC504pcbM8XW0vX4ybFk+kvdP1UNm7YC3ZKDuFlT8pguL5yvNbe34N6rR5o8EArpd9
 0RfUBX9b
X-Proofpoint-ORIG-GUID: -t5EYyscZvkXoKgU1Fr4v8bU1oBCB3c2
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509170144
X-Stat-Signature: noey5qq9exf3myfw8pa86ugp1tzdityo
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EFA4120004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758145181-145626
X-HE-Meta: U2FsdGVkX19upfZ7JX5r/1S+/Cj6z0YSHMoE7IiYn8nx3U9W+7bbvHPaWfaP40c/llfFjI4oJDXrTZhioo3PJooult9MRd7YVbWV3xDBCI7mtuSk8w5lWGlLXGBagHx5Kom8uXmtdHvBH7G8nw93KhbZeGvXkP7fPIJvxo47O5FFWwWaVvEhVVu4KOwZ/znKvgS/M/QMx2WN4CvnYGq3hgzswLhdOHPKtCP79m58tmPD7Y/7gOiDd0ptyleaq/1A5zizM1vLt5qlmLt3zJmHKQ5yhGWU/fuOikUHZAzf5k1QBL7iY/oOPhOCGU5BS80H9sbPFXrdDhaPYXfPwrZHzcKibm3Udebqru1AevHMSo3vJyyN4ztS5G8zyvsvpjwjoOLp4ocSs9H4/I2lbBT6IsEJ2ZD4G3y2/cXRrBgPylqwPstnk4Qybcv7fEveWmnOyO+1zID/UWlM8MCrCQ9aDtCooQUPWNh6rshPABTWx6fAXc3eoPxoxs4lPpbVAR76Fksrde1SfyFfdXDdmf/O06BA1imT7dgTmRIDIPy2amudhglzkEouL5GTWcS0f0rg3xI0h7RhGzPQEFTvXa2OaxiysM736S8U+7u+ry813TEFOSkDDtX9ow0nNQ2Vylg2d51opnqL9In3ID/VEFtSDWYgYRb2/u3UoaCs6Rg/ysYK6DRNn3Y3bg/wuUmjAqWs2X5PTq1WILRt5+94illmT/fEKmHQV9g0CuqbD9bmsGU4mTi5EjXkQTS/UZJkSY0reBjIQdS8N8nZWdiLFTR3HC+/+GhC4UwzXju8o7O3O90pNltEq+hQGxxNJ1K58JfbEOG+bbHEPPgV123s/fuTc5E9nIvAtpwUp/sfO5E7aTOKe42A7RazfiLXYEOMwk7245eBptHUIvvrkBIdalyjfNVZl7SX6MLMUVuzJKlmV8kFn+auPZb/zhtOEhqLAhMCkyOXMQ4AgZ8iKTCSUzo
 Ur06mTUr
 jaxUQsgkjbyJ0AvE2sGgOh5KellF0f74ePjopW/F85FBs/08sU5I4xeZ0CmWupq6xYrC8CoKKs2RmqEEW1CK2CbAqc3iIkGneNqWMC5KbUanGV+x7Db8Q1QP+KYD/CbPF1Q9URcAG4StAH3AZL+ZuzA5wTA2RjGTwHJeuGqRg/3tIe9P4qMhjFsZawslgnlzOO0rfLhZW4HBuIp56U96HVSK1wPT30qqPMnjwDBH6U0hHbZqH5FfDdhNwIahJaiG5FfXL6qcTCiWmiwG10/X1ie6orgtqstSd98bCC5dkHeE7JQ1ZhbgYdKKhCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:54:09PM -0700, Luck, Tony wrote:
> On Wed, Sep 17, 2025 at 12:32:47PM -0700, Jiaqi Yan wrote:
> > +1. Given /proc/sys/vm/enable_soft_offline is extensible, I would
> > prefer a compact userspace API.
> > 
> > > would create a new file, and the file has weird semantics such that it
> > > has no meaning when enable_soft_offline=0.
> 
> So the expand the bitmask idea from earlier in this thread?
> 
> Bit0	0 = soft offline disabled. 1 = Enabled (but see other bits)
> Bit1	0 = allow offline of 4K pages, 1 = suppress 4K offline
> Bit2	0 = allow offline of hugetlb, 1 = suppress hugetlb offline
> Bit3	0 = allow breakup of transparent huge pages to just offline 4K, 1 = suppress transparent breakup
> Bit4+	Reserved for suppressing other page types we invent in the future
> 
> Values 0 and 1 keep their original meaning.
> 
> Value 5 means: offline 4K, keep hugetlb, breakup transparent huge pages.

Do you happen to have any use cases or reasoning for why someone might want
to disable soft offline for 4K pages or transparent huge pages? I'd like to
understand the motivation for adding the extra bits.

Thanks,
Kyle Meyer

