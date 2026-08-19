Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF29C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 13:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B45E6B0093; Wed, 19 Aug 2026 09:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CD16B009B; Wed, 19 Aug 2026 09:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1FB6B009E; Wed, 19 Aug 2026 09:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54DAF6B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:04:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D60571C18BC
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:04:53 +0000 (UTC)
X-FDA: 85118038866.13.B736959
Received: from mta0.migadu.com (out-146.mta0.migadu.com [91.218.175.146])
	by imf05.hostedemail.com (Postfix) with ESMTP id 451F510000E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:04:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LB5H1Ada;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787144692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1sLvu06Hx6JLNPfSPYtXJzuf1YhJzenwN+HiY4rnYw=;
	b=2ufVqFSeAAuWbse8tJlsek29VzELezRqdO93jSyAYWDQ9VitoVS4JgEtuFG1Wz/c5ffrKt
	w2WG6GgZyKn6lVTehNY+G9ar3gWwEiFkA8uHRSw/UIlOKbd6te4FwXuq0iqKaf0DOZRKdq
	vASXsXtRmuUG2UuHwZO1NJSdjRYnPtU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LB5H1Ada;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787144692;
	b=sxa4FCwKrMuvJJu8rSRdXrxW2NU9w7EaGper3zJc73U4iisOavvDKx4+eatAS3fj+/yxJB
	KF3IOuGX4eW5U+qeJ/lDel9OrPDKbRB/41e26q7dHRkbB2dza7h6SB+h/rIAdAtIgz9b9S
	Ot26HxBuYohb2Yqer3NJlSzpcJq4jF8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fZALeriPdLaxSaHA9bIAzL1g5VyWTFEs3PqqE7YojUA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787144688; v=1; x=1787749488;
 b=LB5H1AdaQr3O0wMwSORDFgJi5+5iUK3lb4a/VahJqWseTDpLB8dWhnyXLhkmGothMoQEoB5p
 k09xdhGdvVpPYJDim4m2fydTPa8povGtCsDMfh+twwndL+19AJQygQ4NNdihrQx8/QPi4Zt7SVb
 1xslPCVOHF6kEZqZjyNaPBCU=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::4:a428)
	by smtp.migadu.com with ESMTPS id cac369ceb3f75518;
	Wed, 19 Aug 2026 13:04:48 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <282ef982-3e48-4283-9155-73a33fc1c4e8@linux.dev>
Date: Wed, 19 Aug 2026 14:04:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/12] mm: PMD-level swap entries for anonymous THPs
To: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 451F510000E
X-Stat-Signature: edk65167e8nb9rbwzbjqzosygeruwih6
X-Rspam-User: 
X-HE-Tag: 1787144689-47091
X-HE-Meta: U2FsdGVkX18KLRPKrHu5uPYN99o4zDeus/sOLCHx5F9JtzTU5Wc0tl0rbM++xmrwfUdydtj9uueqn+9q4Gq+728aE5OjIZAFbDl+Qkj9bJpH+m0z0fplzazD5ouB5GSf7ow5+KvsPtz97FgYWj126V1zOz+XTY8kNYE7M/23ecQ/f1RM0xc8zCLqZcy6gHMjSDzYcYVjpqJCeFFvayvsLMK6tG0W9lehkL/EIavvYZMKI6f8mFCP1XCQInh67ZHBhDHRyHtCWYaQloRd1ATo67ZjNq5Kq4CjZpxn7lKpBXULeC69Qt4q4GsDJhyXvnWWDYj5wgFvg/FaYWy2FN5QDwhxFd6GPiHcUlysAUy3ENw2Ai/5pxYGhHnQ9p4W9nG/CzesUcvr1wUxMAb8lwxbfcHdJtTxumAl8uy4716wVbKIuv+ABpaVw/fPviMXBG9Zq5Z+wjCi3GcatOIIlG7cYpPLiCArYpgEjMQ+XR6oEuuHkUlAvD0C7E5gYCOd/H3sfbYsswEDYZOZMPXpQqCR6rwNDUiwkzY9LVxeYYLqXXulWNJPqo7+OzDbEVjOzqXfpyhJvKSiXQej57h2coqINGSrf+fEFMPWawzmVViHTjjlun/skIKInvoIRsgHfAlLyNCvGxPWpScZBO0AAA/rxxZLZLfsEoSE/jGSAtFoxXjz7iuwH4oYbvLFkY1CWkST3QnbYcfbYOd/LSlKrkre7QkOzI+9WYcU1EwYzXIMfghN1Hx/U2qIunKqa+jSNtFOR5uMsYwWg1oDTVNVBoVrPAAZZYHFQAkpWMikjSfGyVPuZAaxJ9D5p0ZiqE4+IXyPoXD6JeVxE6UA/TBONaOQpvC+ri6syCCCDOgIqYRlqF+C5a7crqf6ImWTPuwSjQJhvA0IEziJAXsx6l8YSojahZh+bg6aR3Y2/QveqTOmLDhVhHJ3m7IDTM5NiXsqlgU/27NzGa0okz7Sv34AVCA
 oTJInwKj
 9RBcrzhUy21Pt5itb9To0kZtIU6y5ybTJvAQTr8BJKNF6+xmcmNrMGQWs3hFZpOLbaRrzpNkQ8njVRe991WmTA2L08DsRBWrpFkU04nXaLq6Dr/uhDF2D6PjjsfpGtseP3kCzV3ruRhTckDMUtzjjPCLqcdbxAoAnf9PW0oo3/TEfPuFpiz2V4nk0w5BgHnwPCJLrzXL14W6tGjeWQh1CXdSI7s70IoVPuHcfzOtkkp54mQAsMi5cSv4Z47irySIco6+MSKXIFudEkFdMf98J7yZ1dW9mu3WE7YLGG2Sv9MX0kwFyq/Oejopj6GJvwhQGeFf8YIKdS9VTRvC7CrgpWlUezJmicEYKQZUqi/z5gNPFok4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/08/2026 14:09, Usama Arif wrote:
> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
> split into HPAGE_PMD_NR PTE-level swap entries via TTU_SPLIT_HUGE_PMD
> before unmap.  This series introduces a PMD-level swap entry so the
> huge mapping can survive the swap round-trip and do_huge_pmd_swap_page()
> can restore the PMD mapping directly on swap-in, without waiting for
> khugepaged to collapse the range later.
> 

Addressing sashiko feedback from [1] here as its a common reply for most of it.

The PMD swap entry is installed in patch 11, until that time, the path in patches
1-10 is not taken, so the feedback from sashiko is mostly wrong as the feedback
in patches 1-10 is that PMD swap entry is not handled in another path, but it
is in a later patch from where the feedback is being given.

If patches 1-10 were squashed into a single patch, I imagine sashiko will be
happy :)

[1] https://sashiko.dev/#/patchset/20260818131202.494754-1-usama.arif%40linux.dev

