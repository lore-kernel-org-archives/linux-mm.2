Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24975606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LwS+QNeN
Received: by kanga.kvack.org (Postfix)
	id 4270E6B05C3; Tue, 10 Nov 2026 03:00:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF3E6B05C4; Tue, 10 Nov 2026 03:00:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BB86B05C5; Tue, 10 Nov 2026 03:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 116406B05C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:00:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9632A16087B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:00:20 +0000 (UTC)
X-FDA: 85418461800.09.00719B7
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf17.hostedemail.com (Postfix) with ESMTP id 15F324000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:00:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LwS+QNeN;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794297618;
	b=6GgplxWAzDXtmc0ZRSn5v7TK7Be8/T0dJiolpL+4zmVh8THaSekKOC7mGqtg6rNzAMoFGS
	pCnvNMEAIpAQ4JuVhAuncurO1jyVfbq+I/Q6eGKNR6TZ9NT+pVeony2QABB7B5cjCQLmMp
	NZ1urqybROkGXotkh7ukERENGcwyN8U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794297618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iokOrYjLzZi4SS+ZT28oEpEsRqVw5VPLDVu//2xytMk=;
	b=NfJWOJGaqL4J/JGomyoCecKbv10UvwqL9vOIMI22ve/m/utvWjaNfU5gEwR5tuzKPKlftb
	GQOOFBMhFVFtNZcn0Y/0OcR4NUqOr6X94nR4XSPPeik7P7+qlNH/T5sh9pKiSziZFIE+7Y
	EHEVTJeoLl646buEmuag5MJ0qCKujM8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LwS+QNeN;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794297613; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iokOrYjLzZi4SS+ZT28oEpEsRqVw5VPLDVu//2xytMk=;
	b=LwS+QNeN7vBKSQk1CDFDh5qAwkSAumleLsRF3/5NpY+KQ8Ee/3dPXAjA4RmvbH/NtEXY4VzZJD/m+thsluuvHzRXbxonf+86Mw4uDD6fKmNjxFC2eWwhAIIiXw3uYR2uhqaEhodGwn1GsyGJx039ChPccin6ALVvfM3HsqbCa5I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XEUewHH_1794297610;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEUewHH_1794297610 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 16:00:12 +0800
Message-ID: <98a97122-5927-4d72-a2ce-f5b5cec98ec0@linux.alibaba.com>
Date: Tue, 10 Nov 2026 16:00:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/huge_memory: scale thp_underused() to the folio
 size
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org,
 kas@kernel.org, alex@ghiti.fr, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-2-joannelkoong@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261103212004.1356327-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 15F324000B
X-Rspamd-Server: rspam12
X-Stat-Signature: aqkczxkk3s5j6swcpbqyz9ptqsfnjkrt
X-Rspam-User:
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794297616-789177
X-HE-Meta: U2FsdGVkX18uw7VXl++VQ7/vV9dbOznIgfHgj2fJh4ANSJt4Ge3BpoT//ZtQx9FzIkZ6Dlrp5wtHzLWYZ1vw0PvSDeqe3yNYtkIZmGT4T4gB7TngC/H2UefJdw1BKCGlY3FKKhNgo7Oi6TdJnt46n7NeNT6vVQbUXyXwMfEkd47wBATB6Zh/WduIdgWyp1Zvsz8Q/zku2CugevmQ9F0QajE4mWW8qlYsFjleotrJqa8J0rLJFTtCQblKfTAcN6MEuFLHAquHWq2WD0h0iTj3cnwy+Xvs/lt0llojbeh8VoA6xAegp6+5hSDvMouwBxbsMRuNpJ0sZ4JTC7jiaic5YuXm+UlxEjXoUAjhewuqpYMxAHYFltO2PfsLr/gwo6i7032jpeYc1L3LoBhQzRS8H+vdweDrOQgVAWWV3bewMIpEluejWbqe3uhcZ6Kw4Dgkpp18qnwqcX+aiYk6CR1JHdDMrUfBWFgH1OmTUSuCM9JrZV7JNU8yzgJkMHFdga8E499qiLk+KgwJR02xzl2I465zEbdoFJjDMXFyJz6kmbU9bkEfBhZiD9LkfQXJ9FUa+/qQ8xD8n66RjcAZarwTbhltzTn2TnFct4BKPVM9tHGYWiqaW4M79bEh0R/+/5H2ZWC8rEoSA7IZiHtVQyji9LjRTggBC+ILZn3NUKIaZ3U0Z6Y1vxZwwxNqo12wDMZzDsCRbyu6Xg//Sv2clDznLpLMZg3g6zcZa5M4zqMtZFPwGY+5ZRvjyjFHgfVGRkKO0mxjlr6XYTIF6Cfa1YG3vfxTy+1J4c81rOJDSGxBcL6BR3jdtZuKJDKxF7ZxntCya/f1E/NgjN5WHUxFuG/OZmkWpgki/UNAx8uq42+fv6CHuKytqrwrhUmOwac6k8PfN+WK/a0Zsd/pQHmGMt5Vt6YmUynCdhfpawZXIjEB0JBF9H6gZhXOPCI0H9zeqL/4T0ABsdZqjVDzZxFnNqn
 WlHA82J3
 qXqim+y9MiFZN4xBTNbklW/u9yGJJ379gBlxLcNQSWYO2M205WSneKT8VBtkq+9KbwhL/J/9fkMa6ig5Usa3539d3rlz6+RptfN8EhlPM9k5rbeHH4ndJ0BO44HRdC16txUlRKP4pBpbJFTKwULXNvUZCjJH7bNN4W+fFupcqzny2dclChKRfV+s0YNPJ/BhLU4925rlfTXzXY7NKv7Z2qGWPAQG4/hnyvZk7SFvEVPZ/lVx/q0IjgFrn4CHhLcZUiwVxGEVn9McOOTy2FxSzqaJMhEV1K4gBA46k0damx9Kd98XKwNPiSPtbPeg+zcQHChJROu4xSr98TxHEt63CKZZNJVmEpxhyRUUMIiYyewaYNq/+41y4yU3hnkNyPRF7M2+n2v9Saoe21DlR5vtdd79oXXLouJbBjQKk8ywr5MzSlOrhaLSOSj7NcnAxt5YsxEqW4ksMAMPNskNjigX6k5PUKCD8sLn3aTmF43aLiHAq6nSVDi3sMkZJajmYuoNzARuEnn7Ml66jq8Q70ISlom12lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/4/26 5:20 AM, Joanne Koong wrote:
> thp_underused() decides whether a large folio on the deferred split list
> is underused and should be split so that its zero-filled subpages can be
> reclaimed.
> 
> Today it only ever runs on PMD-sized folios, so it assumes that the
> folio has HPAGE_PMD_NR pages and compares the zero-filled page count
> directly against khugepaged_max_ptes_none. A later patch will queue
> anonymous mTHP folios onto the deferred split list as well, at which
> point that assumption will no longer hold.
> 
> Make thp_underused() folio-size-aware, and scale
> khugepaged_max_ptes_none proportionally to the number of pages in the
> folio (eg every folio tolerates the same fraction of zero-filled pages
> the user configured for a PMD-sized folio).
> 
> khugepaged deliberately doesn't scale intermediate values when
> collapsing to mTHP orders (to avoid the memory footprint creeping up
> through repeated collapses), but if/when collapse later gains support
> for intermediate values, a folio that khugepaged collapses won't then be
> split right back by the shrinker (and vice versa) since both collapse
> and split would use the same threshold for a given folio size.
> 
> There is no functional change for PMD-sized folios, as for those,
> nr_pages is HPAGE_PMD_NR.
> 
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

