Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E0BFB44C4
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2844C6B0005; Fri, 24 Apr 2026 03:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25BE46B0092; Fri, 24 Apr 2026 03:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C146B0093; Fri, 24 Apr 2026 03:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01A8A6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:57:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D2F91A0910
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:57:24 +0000 (UTC)
X-FDA: 84692694408.03.3F44DFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 774DE8000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:57:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BbDHZahC;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777017442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3L3peLMzfiNM9QmfnQA5sv1yMU4xoeYtNvV9y8u3ftA=;
	b=upE3Fv5FCSNdlkcr/kqVzoFEtoiRXuPJ5CiRnqLL3RLoF4Yr5bbiHbkV4+uuzA4ddQ8/DL
	bVP/a0xQDs/a9DMIK7tpQqUwuOOfWfdt8LC2ouWkNNNt4AYdgNqLa7DPcfz+PzNm26Q90K
	e1YJBgNP0l9xDwjWOLrM3Lh/90TnBF0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BbDHZahC;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777017442; a=rsa-sha256;
	cv=none;
	b=b7Y9/+upxyBx/kO8CKQBzur1zzdAt3r0J6cdJpDo/RXeqUOYWwhu4Sh4YlAAmdEd15lM6y
	zV279oniuilJACtgbqIQWToNEO0Et2jvV8iseCdOBIcn+02EZzSuFP+S/3qY1huyUn/LKc
	jzH3pmIlGGiWnTsq++0wtewqAj1he9o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF284600AE;
	Fri, 24 Apr 2026 07:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47849C2BCB5;
	Fri, 24 Apr 2026 07:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777017441;
	bh=czQhppD5qcT7kp2D58dBtgwKrojert5MR4HN8A7JoCs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BbDHZahCmaSXeVwPFi6iJr80JFzdWgWyUZOSASDK2YA3RlxF0DSnSc8nVRdxqI/l6
	 NKtUK2tddUOh3pa2niiMoDP0sHKiaet8QZGOqm0jqM20YXIZ/4fRhSEnTE+9Um0/KW
	 9VxobQWkypXjTnduj2YF1yPXAc/cthuUaVisPKKOTGMj74iTmte5DCKFAO3EN1U8Nu
	 4xJJ8+hKZCIDMiM7JhRGVrp+souJTsZtbmtDBV90zyIDl77kLP1gFTmgl2G8oi/Rmr
	 Lmj/U4gHxFHj+NVPYNEwSoIOdqQ0ZpkgQ4iG7yzLfIBHuc92u9xhHcydN8ezyxXPe4
	 YMdrN23oz0ITA==
Message-ID: <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
Date: Fri, 24 Apr 2026 09:57:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
To: Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org,
 brauner@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 surenb@google.com, timmurray@google.com, Minchan Kim <minchan@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org> <aesg-sj6_VmXyqxb@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aesg-sj6_VmXyqxb@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 774DE8000C
X-Stat-Signature: pikpbm4prthkm9hnai1pmuon51b4uo3p
X-Rspam-User: 
X-HE-Tag: 1777017442-285632
X-HE-Meta: U2FsdGVkX19LLBJ7J9WFtxWAgvRazZ/ibO+h0K6QGEZ4ZuNYq4UTNtu5FUFJzmwU7r8thfBVrXuXmFw+a9ckwxytZRCujfAtFchQSxNnHUkWMSm9qT3skDb+K5mkGlaDgpuEzKL92b+JOS8/uiFZQUUiwuArX9j46sPyEYrpHmugusB5flx8p/i7vXLjzu882n+2SD2NIjEBSbGzOjmIwoVnkTOkiSVs49jwYGVfqCWg52wqBNBF+Vhdk0FZPxW/SUL1T5c4KoqTGYBrBgyO/dx1zkD20SFeQFO2luwnwuDoxgfUrsXnNY4V1cp8hWA4ZUOXVf2Q9ISOSoSgdx3Yic7xXnugiMZ4qBNeqz93O8q2QoHmZxay6YtQt18n0h9oEm5VLjnWAFuBrXinrJ9uOo1E2tWPL1UFV3NhqR39uuOiguvdA53Fdh3hKnq0fZMqmODU+8BqALHVqfthc3JcdSy373iclCKussX6ATsqKmU5fFIpCt2du9MuwVAbc4Lq4XDdA0pKuT75NArv8JPIHagAW1kvKNcOscYJM51u+vCy+GB3hkp/yJ4UMnh3BJBqejhFJOu0u174Jg8qUZGN+olytMlx+79ZrhXEjdWUbd83zw5UGIAeqge/FeEnLonmgEsh11YgVDGfAUE47X1BQuVo0SR7xJmYpXZqHjl1JGgVG/ucjcVE0oLNQB2q06Rk1nh+ZIDoV/EUXex2jpxNpiFZXjShplvseCI5/fzViFhL+IX/Dv4/7SUbZc2MZI/EzhytvKdjFt1zPYr/qxaRIe84uaO7BE/PtvHoXJb7JMDZvvMnLEyN8HzoqdY+rvDtvSMYcQBxiEYn9X/EHdVhQr9CowsyJaTifovjOSnQ4V4ifFluCEL7thgbYsEMq7CI9stuN0kjS+7hzaTKunqQQ10AFxO+14Dqy7KpMdBu589W9e67B6dwZkKnWZEFKC/rm4JX3hIlODGP/AWBN3T
 3yjbel45
 XdXsurUOOMKjTNhuEOwZ+DMtlVws6/OSniansCmC1CJz2DjXZ9G8okDx8t7CC9IK6gzBrN9HGsj48ieF5sX73Wk/zGFPADzoIu3rLoJerunpP7ZqsqP+cn/me02YLHleHOQGkoqeHzugGbMTGa7oU/+33b8DravgZPOGGXEq6HISj22dytKXyFNST7xUItOjq4ERqqIF8JSm5IHuCJspu9c71/mj5RDU/4kcmdTB3Dmqrs5G3NJ5kBsoBbMBunjAwSQ0t8GTdh8zcAVpQ1AMoSXGONHN5tj5Ie+AySMSPKL9m7hqw8/B7MDi7IPZav2a9IuvigKozwRml8aw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 09:51, Michal Hocko wrote:
> On Tue 21-04-26 16:02:38, Minchan Kim wrote:
>> For the process_mrelease reclaim, skip LRU handling for exclusive
>> file-backed folios since they will be freed soon so pointless
>> to move around in the LRU.
>>
>> This avoids costly LRU movement which accounts for a significant portion
>> of the time during unmap_page_range.
>>
>> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
>>      exit_mm
>>      __mmput
>>      exit_mmap
>>      unmap_vmas
>>    - unmap_page_range
>>       - 55.75% folio_mark_accessed
>>          + 48.79% __folio_batch_add_and_move
>>            4.23% workingset_activation
>>       + 12.94% folio_remove_rmap_ptes
>>       + 9.86% page_table_check_clear
>>       + 3.34% tlb_flush_mmu
>>         1.06% __page_table_check_pte_clear
>>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> As pointed out in the previous version of the patch. I really dislike
> this to be mrelease or OOM specific. Behavior. You do not explain why
> this needs to be this way, except for the performance reasons. My main
> question is still unanswered (and NAK before this is sorted out). Why
> this cannot be applied in general for _any_ exiting task. As you argue
> the memory will just likely go away so why to bother?

I think there was a lengthy discussion involving Johannes from a previous series.

That should be linked here indeed.

-- 
Cheers,

David

