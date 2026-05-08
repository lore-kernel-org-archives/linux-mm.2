Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A8ECD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23836B0274; Fri,  8 May 2026 16:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4136B0275; Fri,  8 May 2026 16:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C096B0276; Fri,  8 May 2026 16:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7CC96B0274
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:09:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5EB2087456
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:09:37 +0000 (UTC)
X-FDA: 84745342794.19.8F66D3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9F1E8180007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:09:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m4tZNpao;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778270975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gwpxap+WR2Bxv5srL+R/mh+gO8CoutdhNTSTODA7hxA=;
	b=NdOIdXFov0+zzUm7KOGdj+K2QaIJoWPen1j3oSqdM4UH1F5PHHI/UVGOf7PrYRa+ElfKY7
	4+3XNfjQcAdfKxGvEpdW8+LsWf7XBQJ4Bl+k7ExdR9Dm67N9FJIqheNf9ISPjcl4j/1j4J
	XGl7+ITfMiG/2Hl3bTuqOSWWFWA3AmE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778270975; a=rsa-sha256;
	cv=none;
	b=5zQ5kN76ecxETFtN/AP1DJDlfDE8TY0VeSIswnR3ZSQ0ipAg1QsCFtVgWjDe8iZYZ+CVKq
	bxTMEctzFKQuqe4EzMXQYiwObw37ZQZOBnpueczGCV+L0meroSzuBfM33tJPdoMLCT1gJy
	p2WR+inrcNzdyo/NLVTY/GS2bdTKamg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m4tZNpao;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 118536024D;
	Fri,  8 May 2026 20:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8FCC2BCB0;
	Fri,  8 May 2026 20:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778270974;
	bh=t5h/pbwLwJoMHajI/15IwmnbpJqPM0yySlvu9EFrr1A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m4tZNpaoWxVYS7/LIvxw+3IqL/2lAfawJ/rtqwePsUP0JKCQYPGJ22Y1uZrgmLxif
	 oeOwuxUIGI1ArhngJrhwS0oJ4IP0zZxelswhP7BWGQdm/judK0rGGnGaQMQMxeUJun
	 Xk9zMcI7f1za1jyxBDZub+Onk+ZHcW9bdn71LcDLAerJSLENxxb4fZgBiI25X6xLT/
	 PsSfCQ6La7NtzuAewmc5mWbeunaktUwH4qyJEml/OagSokzAhutYcds/varYgMUC/K
	 wIGRFD08sVLqcWQcEaKIa2HIvjhsfLv2Iz+sY66VqNtqowY/Ln81gcU1UWHdYW3Gxu
	 L7sayZY/ZTw1g==
Message-ID: <6b2a81e0-21c8-4454-a07b-dd025d032a67@kernel.org>
Date: Fri, 8 May 2026 22:09:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/14] mm/khugepaged: enable clean pagecache folio
 collapse for writable files
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-9-ziy@nvidia.com>
 <CFECCB44-EEEA-4D3F-A505-3BA2C564C107@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CFECCB44-EEEA-4D3F-A505-3BA2C564C107@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F1E8180007
X-Stat-Signature: oxr65exbwij1ekchppxaedgs3wnu5ors
X-Rspam-User: 
X-HE-Tag: 1778270975-824403
X-HE-Meta: U2FsdGVkX1+Uxzr4tLtHHj1xuNihs71dqkOTKNq9FzSYFNjmDSMR6IBq71KmGlYVgwaXIyjhYczVaWnHZAqt2IR4UheYHS75/5hXWih6CUiOfJdKSbwyLr1SQiOM79ZIhTjGafMC6g86FrbHPmvJvo4PLMHxYf5a9LuqcA+tjW5VwQOa9stQUT2wMppcVQ+sriBdf+gA6oLtVow1unMZt3/x8ASfN88dh4N0n+LMacZnDXctA4kQeBgT0B0DmQCGFE8ryf7Nos7UPEGnV15m/R6cgbVNUoVBWgD1Ts5fmbXbD+BSaWhrt+ospxOSggMnSvFo/KQ2ATlL/dOPzv3KSo/DFGw1+W6BeYgnR3HPyGW64CS39Gte7Ef4c5SGcE8OZzV3sCRx9313xIsF6dU6ZnI8mOeO5nOvbl6v27Wg4Jdk0J00zu9GPL0C1uPqEDSiPDFTgUojnLPf8TGB03CeEYkjcETY4jJaI77ZUy6czkggY8KB1PRzU6/oRN1l1V56O2qMeImUb5wD5TIuo4cT+zEi7F1BpcyBRem3StBvjLz4SJxiFBwHw5fvYMpABzjlfIsIG7wWOEPyMLhOb4ZY6ZovgDO1Tgcnnx3LOq3vXsUsXEOGgekflFIf6rE9rUxjV4/U/cUvg5H2AYjrpLQBMSsIQfKmJtLybaqTMYIA2MJH3iwCljb9/RrR4YxEsgygxYAH7aUHpKjADFfu7NLW60eDlmWicX38dMaQZxAFvjnXFGf8p+A2bP8/+QVGLRFCuKGsRvBaIKoXeqKsBEozD2URhoQb/JxefgJdvBRN+vUepVVYP5wlxItG+SDbApMDYmvs800g/iIFNLeEjemxF0tpwTPMrT47/U9SV3ZyRUPNZgm3ja87HwkWil1bZk/si8cHSGFBHuD1PrnVI0bxd6VsViLi7QeU/u1g+8rNRkUVReCV3npM5vmZGvvwFFSMWzfDpm2xonRSTCRRjDr
 5VLnGAwC
 Kst5xQwd+XMWoXOnFB/80Q1hyDBaBb0NLOXeOiGt+ldKa6iZMHgrIrSSf/dKixa7Lcrwa2Qi14RZXcH8CGqfv8yQc58beK6bMeVpx5RA7Xml7b4pP/9/yA4ZeXA9KpmuXntXEgxpddHLH0UbdJYQnbu4GBBtXgs49dRJ1iYcQo9edReFOlyYQjODmkAO4JFIxgzDLovtA0jZ5Z64vDTqvVX9Xn1LhFn0oTEKImYCwj8H1q/pD2koAckD3Ivv6AyKEc7jV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 17:18, Zi Yan wrote:
> On 29 Apr 2026, at 11:35, Zi Yan wrote:
> 
>> collapse_file() is capable of collapsing pagecache folios from writable
>> files to PMD folios. Now enable clean pagecache folio collapse in addition
>> to read-only pagecache folio collapse by removing the
>> inode_is_open_for_write() from file_thp_enabled() and only performing
>> filemap_flush() if the file is read-only.
>>
>> This means userspace needs to explicitly flush the content of pagecache
>> folios before khugepaged can collapse the folios, or use
>> madvise(MADV_COLLAPSE), which does the flush in the retry. The reason is
>> that blindly enabling dirty pagecache folio from writable files collapse
>> makes khugepaged flush these folios all the time. It is undesirable to
>> cause system level pagecache flushes.
>>
>> To properly support dirty pagecache folio collapse, filemap_flush() needs
>> to be avoided. Potentially, merging associated buffer instead of dropping
>> it with filemap_release_folio() might be needed.
>>
>> NOTE: this breaks khugepaged selftests for writable file pagecache
>> collapse, which is set to fail all the time. The next commit fix it.
> 
> Sashiko:
> 
> Is it acceptable to intentionally break the selftests in this commit? Each
> commit should be self-contained and not knowingly introduce test regressions,
> as this breaks bisectability.
> 
> Answer:
> 
> I am fine with squashing patch 14 into this one, but it is unlikely anyone
> gets a kernel at exact this commit.

For bisecting maybe problematic. I wouldn't squash it, though, instead prepare
the selftests in a different way beforehand, such that they won't get broken?

-- 
Cheers,

David

