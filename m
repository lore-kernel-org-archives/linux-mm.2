Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57442C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0372F6B009B; Mon,  7 Sep 2026 09:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2AE56B009D; Mon,  7 Sep 2026 09:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E193E6B00A5; Mon,  7 Sep 2026 09:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B42A26B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:46:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35CE7A018B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:46:43 +0000 (UTC)
X-FDA: 85187091486.09.E1D7084
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5623D14000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:46:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGRPqI68;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788788801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzDzxAuqB9ojF+hh+Hj8j9w5WVxfT4T0AT5rizOV1hI=;
	b=MwUfwaB9D81Omj25XI6eHbuUb/eodGLZQDnKUWYvp3TJw3ekD+rByzZsRHqb5BmAEThsXZ
	YZpbdnmi6KCZEPQnDeEDawpv1FYJ3cy63VwIYagadAiAUSWisVDIudvTSiYb0MzHe8m1jU
	g0uDqg9VoahAH/PlR06VAdy8pRDJBUc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGRPqI68;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788788801;
	b=X2c4Xs0sINq3tUGK0wSaBQzSpvffR+7kO6fNleozJ9R4r4DEEhip07+pJuOpsq/q7qH2O+
	7EfGrCsbkC9JGwwGgqePv+Z2VRr2/8NZCUxTn3KXCL4UNKW0nlyT1gu2FIsil6Z6pniN4j
	HNH1w5Exoz86lqVnaL4gQEytCx9qQPg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6B92407A8;
	Mon,  7 Sep 2026 13:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923ED1F00A3A;
	Mon,  7 Sep 2026 13:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788788799;
	bh=wzDzxAuqB9ojF+hh+Hj8j9w5WVxfT4T0AT5rizOV1hI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UGRPqI68GBAlh9C4rRQOOuXVdq/mzmQAz/kOW0z5WgWrOMrsS3ws5BWD637XsEwVb
	 IwxYeDnfu8B/WLcDl+8qaC0Xh02fxQg4WFWtBXFjmSlz0Lhr8bUbsIECP40NS/YdRD
	 EOv9yD6mYbsWGGM1lRftr46ALQcMecwn5EvLpwPq9IWY9TPXCRyv+cLZoPTjKs8uKG
	 c9bUyKAmT0JlaBuwEYlgnvTFGMiCE+wQtzyYAsHbl99TI1l93lajRjG8o2nYl0y2ac
	 EPcwHiuAU9nk+9TnO8GclwjCWfO5l5ax7BH7Krk4KDQSvOrcnKqKQfjc8PEceGdqBt
	 yceWjUTYotkWA==
Message-ID: <5a04238e-7dc7-4c88-b0be-c4b510488f48@kernel.org>
Date: Mon, 7 Sep 2026 15:46:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux MM Alignment Session on hwpoison
To: David Rientjes <rientjes@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: William Roche <william.roche@oracle.com>, Jiaqi Yan
 <jiaqiyan@google.com>, linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com,
 osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, duenwen@google.com, jthoughton@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 shuah@kernel.org, surenb@google.com, mhocko@suse.com,
 boudewijn@delta-utec.com
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com>
 <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
 <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
 <8f787434-5326-4a8f-92d0-467e817a23b4@kernel.org>
 <8f023b9f-53d0-0eb8-6f75-65957761cf40@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8f023b9f-53d0-0eb8-6f75-65957761cf40@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5623D14000E
X-Stat-Signature: dk6wreeuw8ggnmc8jz87jq7z56box847
X-Rspam-User: 
X-HE-Tag: 1788788801-671259
X-HE-Meta: U2FsdGVkX19mjIYci4qOASqHKLK841t2BEazl83h9YanSywrR4W9D0IbTNm5dPG/gmTxa+WGOPT7nn1N9zODbN9ppyMH2GJWjzMJXphyShV89gBy8Bygkk+igbNpX7HhMIgqa6452LHGn6gVExxNxs/xNkC4EMs5mqNAaj7DPxU1HBUEUtU2cb5sq1n0hwEH7k59hzKat0qKWv8gJE03HsltAeFKEsyeXE+62g3/JLrjyLtRbdvx5RPxj3ZsLs/FV85JziQc90MLuKIIyCCg09ah79kc/15OF2qJH5jrKuT2LcRE8ocDkOxsO/rHPxuFAcPLfP7kkGUgFpJofTWBx3/Fz0l07snFxeb0YiYlQslyJoZW5MSjN5WywqdmqTdx9s+LdmyLIA+ADKLJswMIRmQQRbDF+jp9avWCamrwc6U8xrP74BoFJZ2NYaZAWPWGHQVnvuTkNQPChE3jjgfeWaGmUs6lvCeqHb/KQnyNnp88Mdh+TLEK1PfVjIWan27a/3yCMvXZ5b1dU5CwAqWTCbVpRk198v99MPGlcgcOvlWYMtf5Q4i0tru0X+LV5wXISgwXNnusQbDr5b8OQTEtolOjVkdQVoDu/qHAjGlBnOMgPxVu15yCOD5WFvuG3FgWnlqh4bBCspIclr92YGFw5dgNCC1AESwTHTtv2T5uRSHt7hgpXj27WU9EQ2SOqzXY9NkpgVCUgzVqOyUZC6VWxTt2fBj2UHgk+aqsliJFbSrG6vHCALZ0r1yzEIuyfz31LZYDOwcM9YstepwQ/x5uIJ05wx7CQPyF7ozThlEPQafHXP5f2zOePmbP+D1O7s9Re5b1dyiS+SY31mZ+nyIqtiG5Y8UEzlcrerdTH8MLMSXK5slDyzHQ7/dmbLSRC9zLWdU9fWt0Xgj4Cxj9Ynolz4AFlshSYlAjdbZXQ7nR01cAFLtBcCkOjmyL5N24lm9KAicyaSY181/BeQPca+T
 tNZTayLD
 rdZGz3LuGOiTQ0WTOZw+gS7o5K9C3aWJEXy4MFeMAV080FVCD7Vht3/I9LcBkaD/qs9STHNSXR83TnephWdfiQJJHiWY9ubrBdom283Jrh10lvN+8HowGhv/VHltqoCdqTuJwp9IeO+RnLsSV9PYmh+2FBwUyZ73BdHnst76HBoij0u2iaKfot4+2yWn22g4LqeSEVCRGUy5Jd7GGujlwjgtkEYVOLXFlA62/nDGuvgVbrX0cRT9yEYpjo1Y2j8Y1pl6VsHanYJ1dJsrDGP+hab/5tOtiEMLFE50miaSQCNJsufa91o0fwNkXjBo4/Jeq43LKuJHO1jBhz7JtMTHNc1TYFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/26 01:36, David Rientjes wrote:
> Following up on this thread and the suggestion from Matthew (thank you!), 
> I think it would be useful to have a hwpoison requirements and roadmap 
> discussion on how its support is currently integrated into the core MM, 
> get an understanding of what the areas to improve are, and get a sense of 
> future work in this area that people are planning.
> 
> This particular patch series is addressing an area of interest to Google, 
> but it's also quite clear from the thread that there are multiple areas to 
> improve for hwpoison in the core MM and it wouldn't hurt to get more 
> insight into what dependencies users have on it.
> 
> I'd propose this for discussion in one of our upcoming Linux MM Alignment 
> Sessions: Wednesday, September 16 9-10am PDT (UTC-7).
> 
> No specific agenda other than to gather core MM developers with hwpoison 
> developers and discuss:
>  - where validation should live, esp with regard to the page allocator, or
>    strict invariants in the page allocator
>    + implications for the fastpath
>  - handling for folios of arbitary orders
>  - handling partial folio poisoning and split failures
>  - race conditions between memory_failure() and concurrent
>    alloc/free/compaction
>  - soft offline for pages in the pcp lists

There is also the hugetlb hwpoison oddity.

-- 
Cheers,

David

