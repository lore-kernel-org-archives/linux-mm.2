Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26477C87FCA
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 05:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949066B00B0; Wed,  6 Aug 2025 01:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920C56B00B1; Wed,  6 Aug 2025 01:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D7B6B00B2; Wed,  6 Aug 2025 01:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77EE16B00B0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 01:51:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22498B8579
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:51:22 +0000 (UTC)
X-FDA: 83745260004.08.304C691
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id 34C5F2000C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:51:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of liqiang01@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liqiang01@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754459480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tq9ggoZf/2lmdTMNecqghzT9uyoBRG0/O8wgDOI2ZxM=;
	b=HRgEreMaLgZje3wF3nGKR/7E5B7oIM+xgEGq7cnmC4EmJi34mCw7RShAMzqjhjru05U7ZJ
	fSdoqnHU6gTvWi80BWjcmHc4d/InbRIMEk1Pp4aZy9oWRh5RVq9OOgSvgYAHDxgx4ivqC+
	XpXZ7xDxqOiXYwX/V2M9RJ9YELHaMfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754459480; a=rsa-sha256;
	cv=none;
	b=sV+VQeFNnwfwf1A+XEExKtRdcpoISNoKtDjteLDHo1IT1WGP1+XPMwqNcoZ+kbl5/YW7J7
	EKy6O7DDfePNwkeCYNcgeQ2D5UO8bYUGD9gYoXG+Unm8w8NpYx7HYn/UKlhuworxoeZeOb
	Jx7F5YTrOtuQyT7ihgyGpsHiiDmS/DQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of liqiang01@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liqiang01@kylinos.cn
X-UUID: 5c90e0a8728911f0b29709d653e92f7d-20250806
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:7fb56755-3785-4b0e-93ce-823174a2ee0a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:302b5a4f98e223cc71f14d88a51b63d3,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 5c90e0a8728911f0b29709d653e92f7d-20250806
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1598190382; Wed, 06 Aug 2025 13:51:13 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 898B0E008FA3;
	Wed,  6 Aug 2025 13:51:13 +0800 (CST)
X-ns-mid: postfix-6892ED51-43911259
Received: from localhost.localdomain (unknown [10.42.12.14])
	by mail.kylinos.cn (NSMail) with ESMTPA id D73A6E008FA2;
	Wed,  6 Aug 2025 13:51:11 +0800 (CST)
From: Li Qiang <liqiang01@kylinos.cn>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for performance
Date: Wed,  6 Aug 2025 13:51:11 +0800
Message-Id: <20250806055111.1519608-1-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <9d60bae4-a61b-4d4a-a0a8-19058df30b0f@lucifer.local>
References: <9d60bae4-a61b-4d4a-a0a8-19058df30b0f@lucifer.local>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cdxwhgx6ynhijeidu4acfab5u733azh7
X-Rspamd-Queue-Id: 34C5F2000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754459478-404043
X-HE-Meta: U2FsdGVkX19hoXo5zydjMIzBYqB8nNS5YSi1ApXZUxE1QK1jmclA9TUc5+8nRQtIFsIxdyOeSMrdrI25S20vKVl0yYFtAAZdng6cYpv58jXj5Oo31y1BsEsBynxBpM9phUUNtM0095LDBe3KwOVvIQzwvfG0T5tfPrvxsJMTmRncrJOBA8zqpmq0sKWI2TkMdDMruqm2K8qtk0ffXxNwOyNA4x7bxj0rqZ4HQJXhjHXOacVP/DiFaWZh+jVcMibp1xp8ITq3QmfO65yFgpHder4+RTu24zDucuhMOKyR4uKHJEqGlv0VATpe8ywbFBqv8x/ZASSRMOIRUKEWqvKXVfkUIWyd9xGGGXLbmHZJ0UAFadhpmj7NyPR1KijP1t0Ai1dnCtMoIk+4guVbR0Lrx85I4BhWGciKWCHvfejv44nwB2Qv9rJp0M261+mVK+ZKp5bPbf4cY8ghhVFfns5JYyizkJI0PmyVg2bSv6qm6sS57yh3qts51fDZZYnGX7eiPzT9jeX6MTgh8SVrb4QE2RVXAR7iQRu20mrryyYiZqzZAG1nho/HO2Uhi5VaMCP2jOind1UbQsjRgs0CoN5XbjyOfCI0lH79DOvWu1asykKjS1n+pnHdKyGejXscZ5JqIF4TzMcpp2JqQ2QyOxcbO47Bfmyo4yvlf7luRQsYn5KDe04rplDg2JH7i9miwF7YwY7+QR8zLMn/2s7Dn83KdG5CMI4MGV8ktehnrs6womkbLNAPWbDP5GV5/XEesIZRnme8QdzYsPk9l88CAU0tBY+WE/lD9i/PJmt6mmc79vQXsBGUxaJNuwmZJ0RqHx6R03d6gcxfSvsdnH5TdumqgJa6q+J48Wojq7u+zBwmMlXrK64yciyjCNkNXfTlfvu1fI6iT0F6v+tbh4D0S4/BwnkfwoBTWNeJ4WQBn8Vofrr1rgACm/wDRapnar4/mpo2PYkBlGsUizz7nM2BqK8
 p/EO2m/0
 yoTaloGAkjtzjUA5t1+PXUfPexXmK/b2gBOKVrIvptMHtmUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tue, 5 Aug 2025 14:35:22, Lorenzo Stoakes wrote:
> I'm not sure, actual workloads would be best but presumably you don't h=
ave
> one where you've noticed a demonstrable difference otherwise you'd have
> mentioned...
>=20
> At any rate I've come around on this series, and think this is probably
> reasonable, but I would like to see what increasing max-inline-insns-si=
ngle
> does first?

Thank you for your suggestions. I'll pay closer attention=20
to email formatting in future communications.

Regarding the performance tests on x86_64 architecture:

Parameter Observation:
When setting max-inline-insns-single=3D400 (matching arm64's=20
default value) without applying my patch, the compiler=20
automatically inlines the critical functions.

Benchmark Results:

Configuration			Baseline		With Patch			max-inline-insns-single=3D400
UnixBench Score			1824			1835 (+0.6%)			1840 (+0.9%)
vmlinux Size (bytes)	35,379,608		35,379,786 (+0.005%)	35,529,641 (+0.4%)

Key Findings:

The patch provides significant performance gain (0.6%) with=20
minimal size impact (0.005% increase). While=20
max-inline-insns-single=3D400 yields slightly better=20
performance (0.9%), it incurs a larger size penalty (0.4% increase).

Conclusion:
The patch achieves a better performance/size trade-off=20
compared to globally adjusting the inline threshold. The targeted=20
approach (selective __always_inline) appears more efficient for=20
this specific optimization.

