Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86BB0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906676B008C; Fri, 10 Jul 2026 03:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD356B0092; Fri, 10 Jul 2026 03:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B1D6B0093; Fri, 10 Jul 2026 03:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6854E6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:53:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1364C1BBF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:53:24 +0000 (UTC)
X-FDA: 84972101928.13.8DBF09D
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 233FDA0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:53:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TKzwd9LT;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783670003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TM7g+f4DY2IQKDVuMIDRQ7RBAsmrawP7WwfGxU5hrlk=;
	b=xnko6VXaopjVeYIlnEFVT32o+Ympr8YPsd3Awdr5lPUy/8CEWz+StQJt4gLSgXq/0G23mR
	Q5qeb18ru2A6C1XLEkLhpdTIfnw3izMvQBer5otYz6tbAO9vrYbLyYcXpB50CdBLVc3j2i
	WmB76J81OQzuboixv+iSuEsttpXpJcc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TKzwd9LT;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783670003;
	b=BzjCa3QzC9iUsrSj5QFSeqeyX5DdA+Y2qCkaqyEnp42BMXCPSPMvLUtNFyMniZu8uK3u+d
	5HxPmk8fZJ6FPm4KAtIe8df+JXM8dhahRGJU+ZGl0ma3hmRE+nqK8PEli73LhJghfYnLnI
	x6otSIk64l9JQrMuqDBeDO5H0EKN0ks=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783669998; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TM7g+f4DY2IQKDVuMIDRQ7RBAsmrawP7WwfGxU5hrlk=;
	b=TKzwd9LTCKd58hCn6wQhhKiWiGONcpdPXCFgmwgKqb/ufL+whK6o0VzUtv1EZnrE2y8Z6E96EO5FGyQZzFxSF4lYH8yUSsvWxcbSFsdwit3wjTDVAxZejKTAKsJvRaniyMg+CjPKt41Nk/AeKh16AcxyTTnB+hVTWCZEJeleRRA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X6my5Zf_1783669996;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6my5Zf_1783669996 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 15:53:17 +0800
Message-ID: <c8d1b841-3514-4805-bec1-7064a82b8ffe@linux.alibaba.com>
Date: Fri, 10 Jul 2026 15:53:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] mm: Documentation: clarify where the mTHP stats live
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260706154500.39178-1-npache@redhat.com>
 <20260706154500.39178-9-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260706154500.39178-9-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4wxwbuu4paggwgg6xtmcxynb6b9g1awe
X-Rspamd-Queue-Id: 233FDA0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783670000-357390
X-HE-Meta: U2FsdGVkX184aEyDTzMAAA5iWF06kbRsaP8uHZN0t+HU06td+z1S24VldcOwNAdVBpXCio+VpQzw1UvAuYxDfxiwVetS8spNpH2vWel/311SHc1QERjjV0ZkbK0hDVAVrrWsYwRnvh/DSh6fALdHGZc7SAcKtqkQETlVkFPRiXuRTxe2ZLDrO2czbaqRzxA2bhVu9Lhb/hgDdy3xnLVFDekaKCtcuFkj/zhgs0dwTrm7t5Vj1HIFSS+SSWBftR0o2vmCe0YnMCI/NJqjc3twlFRYjSRiqn85z7OXb25KsI4NO5szR+7uwOdf88Cowvs8bwC0dRDfpr6za7TpYP1nflvkoEIYI8K7v3YavdpNILJnMtupt0ASgjH/qP4h8+vrEMFYwquKC1/kDpY05y5xtcq8Z00oS4ytjQlK/dIPJ31iI6FYduaq93j9hr9RpIDAanq6YNF+nW3ljxP7NX6wXoCJjt9l6d7OK7Fef5swWBqWGpPmbu4/+pCNJUVsGJq1Bcn3msTN5rkowAQZoRnHAXIdDp9w9z4OQ0LJ25P/gH6p+hFXD6lcw6cQUp/cmqzfOBTaP3aIJzaQMF8zRbLiUssnlMrmv8PwpJ0Gsyz3vH1qgW9zCWMdJiRXJpJGam4YPy9J1cpHj5PGulBlH+Ci8AGAYs3xrxg4LyGvqwmfQEz7hkO8zBF4bei1OpRutKYWPM+oeUL3i7MkiTGR16nxb/qbxJk4UiYxstxP5ACsr5ftdtTTPbCqx1dz0ipVCeCGwyEbnLbyKMHgxADe0uwrDxlmHCo3rd2A1r/UKdwa96AxjH42iZ98z1xS4A/pil4MoUyP3iien+pDPCsJfhvJoplRwpUKjqnwu/3wO3uOKGq8u5xUWzDye1IAEuf+tog6fbBhdXWXd0QeUYFilfDQP9SusAN5X4LsdJvk3M0uxM3fQ4J0zdRXw9lFQAbxiCGvICT7987s2FLd3/H5e82
 d7ckNUkN
 fo37Ws1Zm8yPNrRaYN2uAqJkjxKQD7g12qVCs5IR3afLgR62KR6NuPBErg5WhtLtszVeixvza0b6LZ/kMs2ymbLt3JJ7ssEULUPYs2q0ZMJQBzSHx/jGs98A7hvkfk4IGOkd5WYxRBsW+sijasbJmHJOknWaAPcLMq5P2Dr62KmNjTAQDaGehRFG5Rif0VvgaYEQj1ogVszThagdNq4pANiQ2x+gNwFjhuOHQT8EBtcVZJEHNFePBSqsCpJ9u75cljTW9chQoCLWBlaoBoPe0floX8LeTfBtixnpE9Z9ezailkkATpnteeRz9yNqS5wwH4b+14v0f1C/rmgVSdw8gdSQcj2SwjzpNqIWc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/6/26 11:44 PM, Nico Pache wrote:
> The note about khugepaged counters references /proc/vmstat for the PMD
> case, but never mentions where the mTHPs stats can be found
> (i.e.: /sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)
> Add a small addition to this section for clarity.
> 
> Also fix a missing period while we are at it.
> 
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

