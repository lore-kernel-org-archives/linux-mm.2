Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E93B6F531DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9686B0092; Tue, 14 Apr 2026 07:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0C06B0093; Tue, 14 Apr 2026 07:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B78B6B0098; Tue, 14 Apr 2026 07:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2AD6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:09:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7AC15918D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:09:32 +0000 (UTC)
X-FDA: 84656890584.13.2F7F3A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id F365C180007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:09:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZLMAdoI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776164971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDqEbpjkVyOGpJ9FMacQhTv0F52HnH5epaTip3QvP9U=;
	b=Ddzznozw1SHnMwEeF33r+jvi5iTpMzG3gdZgwffM+dUph0ng+GvkKOPLjfa8hDe8UvKKEM
	WA31NOsTneMOfd0o984D/cmFSRD9yXf7SDMOEYwkHMW0ZaATPWJ7hbJlplESOKGGYIliKM
	xmewbNfFgshvxfXScubwKp7j2HiS96g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776164971; a=rsa-sha256;
	cv=none;
	b=yFMsVnvcPqCbjNC2j5MTm20pUBCcidK02VKijql7qQM0J88yla7AZqxhfggUA75MAqHPLU
	jKwAfUNqikAoq8E6cw82ngPA2A9qLdr0mETJ/Cb357vF52XdQTcerfCzcQ39gluhpjSARZ
	9UHYQYiyO+2RHtGYNVYuCK4rsA7vFhI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZLMAdoI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0188B42A3C;
	Tue, 14 Apr 2026 11:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47A7C19425;
	Tue, 14 Apr 2026 11:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776164969;
	bh=Igrdgqjd1mSlqPVTKCYHYfCc2YqtKV+qD/MgEpVL3fs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hZLMAdoIcuwxCt4ZaPjDyUxjQGYQ6QzclOsD+DMOX9kSSwpSYyK9cABZl+5inW9+3
	 hEv1hvV052o4UTpCwnYEIRgLg4uUm7P02gACkmu/zrBAt+T4tozNkraNTjJz0GOg+Y
	 kMwt28gdnlWVu+KthcNd2V6NN3O9fCCTzd2km/5w2GDKYiRnhow8uuCi17RS0e1KHU
	 Iu3USVaYspHKQ1g6QRgcwicIsHNWtAflwe3m7Th80vs1SdvSYaLohm09z/AQmgl41/
	 oXtEEy0N6QXAZPL6xEd1CFw6BrtGTHUQyodT3hU813wXm2/JHnEe8KhAL2TCHIf7Su
	 /y9IpduDCZpyg==
Message-ID: <c696705c-4c0a-4e3c-996c-358d2f0b7074@kernel.org>
Date: Tue, 14 Apr 2026 13:09:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
To: Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
 <ad1WTCR5Kld-tiL8@casper.infradead.org>
 <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>
 <ad1uK11f_J8sFN0e@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ad1uK11f_J8sFN0e@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F365C180007
X-Stat-Signature: 57nt3a49dr4nnz9w4gpf87xcw3x6krnw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776164970-619141
X-HE-Meta: U2FsdGVkX1+z71PYj2gL08sOtVX4O4Vxu19e7rqH3OxjORwpTHNXmqkaYwtjuOetlCX81mY9knHasMyHNWPBtivIWQGNWnhJP1bo44yJh222rDsw+wVFJqG15UuxqJ8xQw0qHryGxWuk+wn4D94r9pI36fGPhp4oCy4Sim0ybV2sS7HwYYldOnsM0I2N0a4jt+WEpwIcsYyAq3wU33vgMxKTpqguCn6HxOgA7jKCJXlOv+iVsDImqKRwt+0rpjU12PUZSsyktlve7kE0NEnzX6Of/qswubChPE96+6Dkadz0HsrUxopgqk9g93DEBtsAXGDjuZFrX6K8A5+Wzyrk48evPqM1nfK4waPR46AfwJ+W7JVg3zBYGk0wasRR/h8o9/znJ/L0a+1r+o0vDW7TxA2qs8PT1OGamryGOaa1+pSnZfDknzxJj3ZSvvvrq1l80UyfvJiXdUXq3Lkue/I+D7zPW4wMVjFS9t+Jd/1jknD500zvYTz1jyxGn8hRavkrU8tVYyZYApkYuKd5NkQW6hnYMdsLvVNKJCttCQI9t+wno5XiRBUgQv55g/EvywdZAbzOERTLEGbjzo4Bi0lInOdudt5lkjywAKSjwfIQed356MLeU2UFbwUHCbgupG0pjx37ocZUniqp2Bclw0sQTbjq3w2ZmcfDjXF2NR+rW7GERwcwUpgGX1RmfgMyW29U9K0ni/hF7Zi/vvdl/gvg1BRD6WxAmRv6Gw41K8Qc6EJzKWViJh+XYL6MbHea7u9f7SyiicACDV0VguI0I5fhnYaMQeh6VyFRWREc8AolxNXaA6mSjajzDUIOiNs2i24k5379G+VZRabIw9Mlnrvpx4k3m3btD02xY1iK8TIAS5RMk3c8RkAfLhdEmpBIzkXSNDTMk+cgiGBzkdwuh/4batBotCDK9q/jdWKuB1AKbRmXjl6AG/nTkgOTS7e3YJkhdKcgEDGcsNlR2440Iqh
 mACRoqzC
 79DaApUbiNYB3jYzuaGEfACuD+PVQT2RHv4RAo0iwVCFIVliIcrcJg14ogLEdHcXOCF0w+PDzwSa4/PlIwl15TfvaACFtUyu/CsL8LJrcF1WiT+JJHRT5I1iLGkj92kbaIat4jZS3h6Y3A+HR6fTaAOVK1jblyNyFkvexS1RwrG+wOs2Md431jEMEpXVW/Mj0sp1+3IeAVLsCdwTsNukWZjU44a22Oae2D+HDop9nws3Sch5aOoKCxUaVHXAD0Y/QxAAsZVVLH8IM/0+H62WRd6zuvcKnB94NtkmePdLwqz/uQiUxxu2ItPLoIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 00:28, Matthew Wilcox wrote:
> On Mon, Apr 13, 2026 at 04:51:28PM -0400, Zi Yan wrote:
>> On 13 Apr 2026, at 16:47, Matthew Wilcox wrote:
>>
>>>
>>> Is this true?  Does MADV_COLLAPSE refuse to work on writable files?
>>> Should we delete some code here as well as fix the comment?  ;-)
>>
>> file_thp_enabled() used by __thp_vma_allowable_orders() refuses
>> writable files with inode_is_open_for_write(). That should prevent
>> MADV_COLLAPSE from working on writable files.
> 
> That sounds like more code that was added for RO_THP and should be
> deleted?  See commit e6be37b2e7bd

Sounds like something to implement on top of this patch set?

But with the added dirty checks in patch #2, maybe it's trivial to do it
in this patchset already.

-- 
Cheers,

David

