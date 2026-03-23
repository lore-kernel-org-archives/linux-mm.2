Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 748B7F483F2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA966B0005; Mon, 23 Mar 2026 16:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2336B0088; Mon, 23 Mar 2026 16:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC89C6B008A; Mon, 23 Mar 2026 16:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFAC46B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:14:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EFC81B935E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:14:05 +0000 (UTC)
X-FDA: 84578429250.08.3D39EB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 797614000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:14:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FZ/588ny";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774296843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Siaf/OGZ/crySVQUDMbor3K01igBRKTGDp5SPc1Xh5Y=;
	b=I3PUyBEB6ozK52nbQkoigxszlg28Gz9pq4CEqsfK6HzoELRB2tgpZNJq1UHo2jF0ezKxFP
	YWxWCxfMcamiNCKJRFwTm2vx4tfdYKk39dwf6eTJju2hZQFbYcnj8B/0A+fs/KnEaQeCYP
	kNSZHyRWC+r9xkHrAI3sH8MYO7lEI04=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774296843; a=rsa-sha256;
	cv=none;
	b=1kyZKbqzNcLGnKsb/hCiE51v5iQk3JwUqzCyCipF/+EGYPjwik3MClJCeeaj6QOhy+PUJg
	dEftZDmKYR/RftxvmyVZQ3zGk9Ym0LE+5GPDzaurC0CTrJdxCEOR/Z1G4rBYQombaUuh5w
	oF2EY+oGpuKe3GHfzSS24PWjfk9Xh5Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FZ/588ny";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3432600AC;
	Mon, 23 Mar 2026 20:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3399C2BC87;
	Mon, 23 Mar 2026 20:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774296842;
	bh=JUBvAK46mTqd1zKJmPRXyBeGQ+jrNGl+ox/wJedLocE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FZ/588nyVXdf+iwohY14/wPw69oa0j5gSw7/sS0Yv62b/kOLMQqf/7FoXOz3Dw0tO
	 vVQdYC9Xp9Ts/I6BtozJJS/J1QQl16lRqSxwEUh8Cm6cxn8RTCquir5YHYD7Pmpf9N
	 zT5RcSXaNg6a7Vyne/WozYrnm+AjypA6EYRxsTK/tpKZB4I4oSWsFqjSltMNO7PvtB
	 +ePJYKJKdAlsc5qB0HcCuRI4eKCoIwfn4yxMg7v5/low81f+TAsc9MobIfk/HRH5Ii
	 d+CzJ6oTqXQIwcjnPacAVcV8FrNrhYz6B0LOgtnvPkOvDAnzY9xG8QPjy3S+9ee4MI
	 QpeyCuGjOsTiA==
Message-ID: <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
Date: Mon, 23 Mar 2026 21:13:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
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
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 797614000C
X-Stat-Signature: fc9nbsx4z11znfc1moti543bwwuad3et
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774296843-877039
X-HE-Meta: U2FsdGVkX187q39aua35/hSrfjkfiuKl/Jmf6nEo/LlSsu15k31ipBZyrdC1YipdpzkAHYmGYLvO6q4q/qi5/FByeJxW2mIc66gFD+vikBGQz2AuUHdrPFvDLQjWROdSsKi1wlkzUudRdb2JUWUdxbxvs/5hP5x8WaH1mlwu4Y4/MJqjUU7wxRzGQMK99g8K93SCwq3qWgOWbEZPM0w6lqJisZj7NBZZvoO0fzcEG9fcbIYZn7E5vLSklj8nB4Pf/gqGTag81neccq0rIrrA+nvQnm9q05VrQE8P3O+actKQjjYMt2RGuR+d5zhpO5Jq7FQFzXRCSw2KCf5FMF3C9nlkqEqW6TtckhPdW3HSrsz0eClyqgTX6K2ckhTjbC2GZ71UQrmz9EQZHAyA/NduV5WTKV2VN+qaJYsHb2MznV1wOMJK4Du91yFUYsFM2pl+qL23+2kqISJ8V2Wzt6qAOXBDmHOpMHXoATczVkLXESm7jSM2FEXdB7DtqowUXsXJBeDtSEIUmKSxkZv1PWThXypafC017gGZDCqcyb+zSH5RXOhbV61I6HM3ryHra6l0WKe5LAYwweZKdgPO+lS+N4vYezHHLDSX0t3LwOUlkFTht7lHjLNr+qx9MBvfnaqhhlY/rJiJKKmdlsrSOWwhZnKouaIMsQCoIpAsy40X7UxjcsjvoF+MFcmmMV84rR0TWiFc3pV43BrCgNKklwnoZ5vNlL8APW8lgSzWII5L/C80CwUTtE+qTlA4PKkVhCbYdysNF271k8pscjsbIrluPiphXiX/uCEhH9GwOm2Byi7RQztiqZoWlVwXnd8ggYuGxCUVt4lVYhwWCAWvmtwY8Dq2m0C2wlNa9UlgUEPbP4bA7uofzwYhoXRZFnR6s8gdH7ppQsZ3XAehWuWojfsvgsHTJnVI5Z+ofLW09KYPm12n81uRRGEWj6pcvIMlJFIeemByizgJOHUvCU11bDa
 PWVhyVO4
 uWzs9Vgc1Ed7/beO8M1xLIEfSHr7cbDyVJPIZRzgPjuwJaGoZn6sZsiOX5S0tYfRW8zjkQDupeNjNzJ5k5ZHW9hRpa5FQcy05c5mJusc2cbMKCl187J8TURNMCycJPVXay6tqjpkj4rHXn+uKcyLfLZN64BWR9Y8CFGhrmKjEc4h15HfPJqBUgwi7LenOUD36671xu0Hn3nJ3xk4OaaLuA515bClTMpyjQMF6ZPotmsW9DK+jApbApGI00zWXL/X/BkL17/C/jFPHOIaMkMNTKV1rchONWjXWeAibLJtHvDCzvHd2RbNlt3w7sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 20:59, Zi Yan wrote:
> On 23 Mar 2026, at 15:53, David Hildenbrand (Arm) wrote:
> 
>> On 3/23/26 20:47, Zi Yan wrote:
>>>
>>>
>>> My understanding is that collapse_file() is only used for
>>> READ_ONLY_THP_FOR_FS. If FSes with large folio support also use it,
>>> I can replace IS_ENABLE with mapping_large_folio_support().
>>
>> Otherwise we'd be losing support for THP collapse in files? We'd have to
>> cross fingers that readahead gives us some.
>>
>> So we have to be a bit careful here. We want khugepaged to collapse THPs
>> in filesystems that support large folios even without READ_ONLY_THP_FOR_FS.
> 
> Based on[1], collapse_file() only works on read-only fd. So it is not
> as general as all files. If we do what you suggested, the function
> will be collapse read-only folios from FSes with large folio support.

Right, I think that's the first step to keep the existing use case
working. Long term, I suspect we might want to extend that to writable
files etc.

> 
> BTW, has anyone used/relied on collapse_file() on any FS with large folio
> support?

I assume so, because for executables you would have to be lucky to get a
PMD THP? So I don't see the non-khugepaged large folio support on par
with khugepaged support.

-- 
Cheers,

David

