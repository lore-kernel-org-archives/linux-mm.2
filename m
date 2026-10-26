Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75B3606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMjXyau/
Received: by kanga.kvack.org (Postfix)
	id B65BB6B05FB; Mon, 26 Oct 2026 19:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16606B05FC; Mon, 26 Oct 2026 19:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CA36B05FD; Mon, 26 Oct 2026 19:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65BCF6B05FB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:30:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C51F01608CD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:30:56 +0000 (UTC)
X-FDA: 85366374912.13.4EA3B4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 17F5C40008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:30:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aMjXyau/";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9qeqP7UIpC4jZdgK/RdXjrodSxtqhxIZFIMBK0dNEo=;
	b=YpcpjFtfahXaikJFMNCBUPXfxPfl0oEemjm2uOm5WrHuJV5vC2eAV+jeHYpo/O60PwHg8q
	Gey8ORGtH6jgJmLYykKKq7T+NTAWFdlAdjFgr3Bw3GgBXyUUETCO0kd6H3nPFwqDbdSe6+
	HjMBf9isB473Bs1zAZOC0KqQb9b/Cuc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aMjXyau/";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057455;
	b=6ODtgfKihT6T12HcExVL66z7uNVBSJr4uRB39jWZz06NdWgv95lt8ReNp/L3EOjtYozkFt
	+CZfz7/Uz68gbB2N38mzZuhPjodW/eHFb2KM/rbQ93Fc8iCIf1OxBMrdz1CQATl5cPMm8B
	k1M6sr6JnB+jBAA9M8j/GgS/ttnTUVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 919B0600DA;
	Mon, 26 Oct 2026 23:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C791F01825;
	Mon, 26 Oct 2026 23:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057454;
	bh=Q9qeqP7UIpC4jZdgK/RdXjrodSxtqhxIZFIMBK0dNEo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aMjXyau/DEsG4YEydgc7sLdZKV3j2+LW2b3eNS7X04Qc4ps76HV4VLUeqoLpSYofQ
	 pNs1KkeKtqL5YsMBwS4HuHwBQgtJTMXc8b0J/LV7PC4ZEmv05CevPNCGlefvGzZzOq
	 SBctlXL5N+6DWUb3QCKOqKJvp/XPk5b9g8EabmrImmA2AFBAHIQRb9BHaxfEWT6YJ5
	 Wy6SLfoIBnL2o30c+yyJiRVa2EZUQQPBFqVRbNK+Moy1vtqGht1vqXxe9x0SsIb3cw
	 P+sIyiqcq0KQMpzIa7NPFpdKkz01A9vPZ3PEqp0zq+95N0LLvoKeE67Dw1xNIoyakq
	 UBliE1LHD86vA==
Message-ID: <2467500f-d72f-4b09-a049-e70fa3fcfb3b@kernel.org>
Date: Tue, 27 Oct 2026 00:30:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/16] mm/shmem: avoid moving the truncation start
 backwards
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Zhang Yi <yi.zhang@huaweicloud.com>, Gregory Price <gourry@gourry.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-7-703206d5fa0c@kernel.org>
 <2E377C76-D62C-4A2A-94E3-ABC40C6FCDD2@nvidia.com>
 <583728ed-dc63-4685-9ac5-5a980db55973@kernel.org>
 <B1241F56-8000-411D-A137-24596E599C85@nvidia.com>
 <0D22B04E-5730-4D3A-ADA6-9F1AF94F06AA@nvidia.com>
 <f0029758-5f2e-4c26-9b25-dbc4b3f33701@kernel.org>
 <FA2807F3-66EC-4EAE-864E-BB1DE436A1A2@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <FA2807F3-66EC-4EAE-864E-BB1DE436A1A2@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17F5C40008
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ksnwisgcnqfa8m1k746dwbq9cbs4i76u
X-HE-Tag: 1793057454-942733
X-HE-Meta: U2FsdGVkX18hoeVhizKDzPQFxjMbhMOtwCykkCvVCosvgkDEz6pp3rvNKdSDM9ocOkTDKjo6VU3x9rAnn2ba7S6uducQs2SR9IKmJ8wnWUhOCBli/36tiBK1qf6/kcl28uSkXtsXhpiiEvbUEyvDXczvoIomqs9XsntzfTgTiI8+F9gcfFUGI4fAiv/zM78xBJ0dl1uqDq9CEWfnmRrfRuImSpzwDK6/ouxTTHGQHk/G607SOdvHlzKwjw1ST4EgFxdIMJ9sastmZASLr+uAKzew6TX2mzIVUGqVDaiBpEqn62emwo49k/ubb56akVE+Gn5W7Is8bsenWZf7B+BNeKHeKR5ojd4MQB7ZhO1gfK4DqHrh6r7nz4V96YUD3imvHFPdlgh13Jz1sy7FoUV1Num+g95xO+i7vy392mOj94A/FQMnPqOuufC1idcR2OB0dHlb1qBQmZk8BFapz1Fb1keKv96AsCcitvnjYUvA35TcSR8EdnDrtLOR/ktbnwWZ7GKdTEiYgbfR5/XUjc6x17OajObDb8mgmTKN91SzeXZ2PBbSPpufX3ilqLkHZO+tcy0Ml6WYvhCha9L7ZwTEPG9NSNVtFOh7uulK5HtNJzpKd2pONKN9QlsgZtTYtbryFbvsczFDYU48a2O1E+FFFFaIp1utVdkFH1UscAW9ZLJeez+FOUvFVLzJ2A/bAvkm0AoE01N6XNInsb8T7tHHlB2PhVP0SVl5f+xdYvLbfx1QEX2wWexF7VH40DUheZo7BsdFsIZVp4oigS9YUCyXlTKsUi59mAO/uDD7uuN/n7FIQeVUUfKRpxWnbuBbZRVHXInY2UMk7Kn2FliNml49ohO/rYiqDMoq3/bTemuasQ2CUmuRhW+n2F1RkUmCQbw+Z4tXcxOhcDCpqFi/iwokrur2i16x2nQe2mtkbyRBlkAaBlx8dkHDPJU53cwiAtWpaHbQzLUI72va9Us/l/6
 Dy9ORu/q
 RwErWOvGxoFPXCfMq96KaYCUN5BageUDy3qeDgWzBSxN8VafFrEccy8XfcRHYKq3ED5Bm9caNNxuk/7QBwVsYajuW+/1Ny0e0GUydZpQqFNzLycJWrucfQQsln1vYBQHLeBgnV4YpfQ53RAe6rwuUUdqKrXmXNkDHf54wuleeP3LgO2LhXin8A9i3hJomo6jt9q8i/j8rozhvhtq70UEpZASiGubhzp122PkasIVF8wQxYZi+bK5xcwGzbaxD9WI8fQ+fXpcAJ9ayxIiUGVChMyprV7b+iXLH+wP5eVqJmk2bgZSFjw/vwBfEzKS9pn1SO2Ed+AbXoFmvcV60YEYCyjgltWYYpx+Ze+l3/ukjYnafhM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 00:28, Zi Yan wrote:
> On 26 Oct 2026, at 19:24, David Hildenbrand (Arm) wrote:
> 
>> On 10/27/26 00:16, Zi Yan wrote:
>>>
>>>
>>> To clarify the dependency, without Zhang Yi’s
>>> truncate_inode_partial_folio() patchset, the ext4 + iomap changes
>>> would cause data loss. We probably want to get Zhang Yi’s patches
>>> in first to avoid that.
>>
>> Ugh, what a mess.
>>
>>>
>>> Patch 7 to 11 do not apply cleanly on top of mm-stable due to Zhang Yi’s
>>> truncate fix, where
>>>
>>> 1. patch 7 can be dropped as I discussed above,
>>> 2. patch 8 needs a folio->mapping guard for the added statement,
>>> 3. patch 9-11 can be applied with fuzzy, but I need to look into
>>> them about functionalities before fully trust what LLM says.
>> Yeah, let me take a look tomorrow.
> 
> I will reply to these patches individually in terms of rebasing on
> top of mm-stable and how they interact with Zhang Yi’s changes.
> It is not too bad at first look.
> 
>>
>> I cannot put into words how much this shmem + pagecache shite annoys me.
>>
>> What a piece of crap people created here. And looking at the massive changes to
>> fix stuff, what a piece of crap people are creating.
>>
>> I better go to sleep now :)
> 
> Good night. :)

Thanks! :)

-- 
Cheers,

David

