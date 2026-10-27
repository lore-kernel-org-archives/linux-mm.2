Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FF260A3801
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wAG8g9sV
Received: by kanga.kvack.org (Postfix)
	id B4D496B06FC; Tue, 27 Oct 2026 08:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24C06B06FD; Tue, 27 Oct 2026 08:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62A26B06FE; Tue, 27 Oct 2026 08:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 857F76B06FC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:24:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0AA7409DF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:24:32 +0000 (UTC)
X-FDA: 85368324384.05.762DCDB
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf15.hostedemail.com (Postfix) with ESMTP id B88DAA0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:24:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wAG8g9sV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1vFLQhXd+Ee7U6nRfJgbj6Iy51wVYwS2wjVTcJ19eA=;
	b=IwTpprRYjQhmVnu9KOWmMrEx7ZoOwpZr0KCO8GVcXloSbqBrUy2RpeHV4zp+87jI0i5vLO
	XJOvrS+C+sGMQr6PIVepBZLeoy1DoynHZEXqHJZfkJudQgt3fbxmVKO+rJPq2BLQrnTCXR
	32II+ckOlfO/V8CbrIEJqohU5H2ULbg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wAG8g9sV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103871;
	b=1fWfbUep9nMMjdVwucMcVB3t3w2PT7z3R9IzY1/BOLMI8E1tkbvbC1Ihn8/eZd0xWva/CM
	JArdQcBI7P89iIaYKMM+uHz3dnJVMCh4kWiwOcwipE0olBlbKxPQggiUXEKCv29sRbv3LC
	P2I/RxjTJmu06c5A/KNWcqYw9l2o7jY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R1vFLQhXd+Ee7U6nRfJgbj6Iy51wVYwS2wjVTcJ19eA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793103869; v=1; x=1793708669;
 b=wAG8g9sVHDZiHUsVSPdzUYuIlsd1O8fLWzka+s4pSADrAFB7VchGNgJKiFy3QMASncjLRPcI
 kfJDXT0LM0dEE7atPk2KJhpalkG3alSfNi9hk3NMvRaJAbMh9YlOVLfgix/RUP0udeHgLWpyS9I
 mxjSoU2CfSPZ4yUrfiIpwxZM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 264de3ab2a2cfef0;
	Tue, 27 Oct 2026 12:24:29 +0000
X-Mizu-Trace-ID: 264de3ab2a2cfef0
X-Migadu-Flow: FLOW_OUT
Message-ID: <ffe057d0-6cf8-4028-800f-09dd2dabd35f@linux.dev>
Date: Tue, 27 Oct 2026 20:24:15 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/19] selftests/mm: add khugepaged race harness
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Usama Arif <usama.arif@linux.dev>,
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Hugh Dickins <hughd@google.com>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-17-kirill@shutemov.name>
 <85b3725a-6dde-4a57-b303-4ae2b53b60a5@linux.dev>
 <6e3c298f-9b93-43b2-840d-65c5ffa3bc36@arm.com>
 <248431ea-4bbf-4a48-a80e-72287ffbae22@linux.dev>
 <atiU94VjdEsWzdBr@thinkstation>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <atiU94VjdEsWzdBr@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B88DAA0009
X-Stat-Signature: d7raej1kmtm71cqsfsxwrhinusee1gyn
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793103870-963935
X-HE-Meta: U2FsdGVkX1/odrjZeAHshmmOJ6nwRMDx9v3Qd50K6boRNbqI2t42bbl4rJcwijq3u9eON2KneQbpWBAaP5PRhCQFjdxN1B2LT5WlDaK10FYICIRQuo4F7KdpWzB7WyZ72rGslxYmOYWaL0aQF6PY+TSGhoR5eguwISRHYLonYPZWwXsW/JPz/vAw3b8V0DWkrxySTrC2Qly3wonuhwsUcrVom2NCVWzPxn1zzIc7WIZrGDrz2uTCrn9K3ARZEE5sb1uX8Ko86yZFhrTvOzSAGH63h9FHEaIgTCAsUO4tbXz94XXkGRETo23856b119H+n/eGDt9O5BrPvlHNv+iAkgNWwMO8j6uBMcf1WT1W1BjbJg+47/K3bxDmW/BRdOmfgYNelFTYzEdSElmrnRd2qFm7wA/bV+wHA7ZH2qzlYSA2oJc5c9RBNTQ03HxPGBcnACmGwKXG68WvMLNq5+qUiRx5nWInpirJzR4eO5tqRIuXHEXdyMNSj/AliJtxdId5C1yv2gAnexwt6A1o6mL8xt2hoKICRt3Gw+IEp0PSVA/bbb5Fs7parIpdXNXRtQlpnALrhXI0USy0G6dyGgXo5peXDbt6FAj/OJ0fE2P+XjVAFvLC327ArL7uWWzYxsrZVIrsLAzzPxn19ID8KUVgx1jhLeHfY08ZTGzw4YQoxy1fl/vBXQWMzTUwhcqVmuGXbj+Lp+FULJyfZneSI0j3/sQiQ0wYsDwHye7GiNfZVxdFGPj9LdCeGSWJNFjc9z97irbzfutt9cAHpuA0FHNJZM9kV3taonyL5ARciN47XMDOTz+b++gP+5yPDcNJD39z8Lub7Ajx7gLle+yeiwBwDgH5aBW2mCpja9SifRMn155COWttKhAcJCmaf0J+wof7cn3zlsiSpInE/VJ2eRRygWejXSbD04EbQCJ5MtMyo7vMhJTTrkHYmg+G4D8lI4nmKrtDT+54N+1CvMlO08N
 AoIpsYNn
 ZIhNP9UnOzG6XH+QCoFRMp21Fg3GNCiouk13S9RjinVMSuzaJcOEhBMarhNYMChLtRBwY9PAP9wrmqvodAZtsybBkpbC1TuGgfncgcWHKtqEQaq8IujLe/+KIiVU5bhEkwmuL6M1JX2A0IVsoNimuFgLsIxpYLIfli63IN6HTroZobImzZWT0T0ichIbYAGSbUd+czOh7oDatYVSizAmq7Brehu8iawNzBvFSNl/YBTkrGlb76MoyvM7/hT4ikWZlFxr3DY+ViyYFqQiNZbwETgqq8/u4l0Rl7IgQWriDifKwrLApAU/wdMadnVwzssoTpATN0m78xYXGVc11cngpI1UYjVNFHcUPD/5MqL1L3aWiKWWI6nVwO9gYK6VeIs5FVhqD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 6:34 PM, Kiryl Shutsemau wrote:

> Right. Would you like to send the fix?

Sent out now.

https://lore.kernel.org/20261027122013.4286-1-zenghui.yu@linux.dev

Thanks,
Zenghui

