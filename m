Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2EA606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aXWWnyqI
Received: by kanga.kvack.org (Postfix)
	id 948A96B05C0; Mon,  9 Nov 2026 12:41:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F97A6B05C1; Mon,  9 Nov 2026 12:41:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9156B05C2; Mon,  9 Nov 2026 12:41:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5072C6B05C0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:41:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B64AA160763
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:41:49 +0000 (UTC)
X-FDA: 85416298338.14.D2B7610
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E59A21C0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:41:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXWWnyqI;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794246108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PaPFt2W8vHp/vM8VPUvFDhmEx264Brvjd3EDncjGEk4=;
	b=JV5MoUR+CH9e2ly4A0FryNPB/iKZdjmTCTsY3LLqs86LSi5bFUx7UbMeZoAuKDOfYq0LcQ
	UHFlz6UhGHQ9MEqQj3e8sPe4NOKFyfDgjirNyKA5iZN7XL2iFx0Ihba6pfprErkEMW4h8u
	Vn6T3vw0aZWTXyODTNYy6/2Yl429XUw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794246108;
	b=yi7rQCfNTBTGMgY7WsLN+hSdHNQOH+7JXT9JQqVFlY3Rh03j+JQhyZTIm29PB9TqQyrq6m
	jHcvAEq1C2xz6imv+OeR/LYbLaIyAjBqIgLYPUmRW2VvI1KZeWUrkQAFJBtHcw/QTbfywp
	j2iC7Xlnrr8nNS8rBhDEBfXqFxxg0rQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXWWnyqI;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC7336020F;
	Mon,  9 Nov 2026 17:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F15F1F0089F;
	Mon,  9 Nov 2026 17:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794246106;
	bh=PaPFt2W8vHp/vM8VPUvFDhmEx264Brvjd3EDncjGEk4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aXWWnyqI5N6BBRTwrri0ZjjNWbUmk/cFqVZohdzK6I/dE7xzWFAdRaNoP24X98w4q
	 rNaUtdhh9lHtyJ4LrTD4BtfsvItctmAg6A5GS1OdVvA+JDNEn0trF3pY26oIcy5Kd9
	 qKnx2UawdPczi+CEpcWuOrtUlUuoawW/F1cn7hIRAYL5SePhB+rlNIsA5qfYXqo4Wg
	 EPwkiTo54EPjs8/aMDMH+JTdN5fxGo74c8FbIV5gwwcPRaEAYph3Xg9X0M7R92ASwf
	 K3RwwDxyhbyai13yWIkr7XY8sFqTV0eKiIIJLZ3r2ClVFjHnJCpPnPXxa/O6ACRNe+
	 1WFvDPVw2Je0g==
Message-ID: <3e126b7a-d7d9-4a8c-9c83-b6fbf5bf1539@kernel.org>
Date: Mon, 9 Nov 2026 18:41:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only empty
 anonymous pages
To: "Xu Xin (vivo)" <xu.xin@linux.dev>, g@dgvxl46587.localhost.localdomain
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Chengming Zhou <chengming.zhou@linux.dev>,
 Lorenzo Stoakes <lstoakes@gmail.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Huan Yang <link@vivo.com>,
 Wang Xiao <xiao.wang@vivo.com>
References: <20261106034841.233085-1-xu.xin@linux.dev>
 <899b1b2b-4f6c-45e2-abd6-a333ac77b23b@kernel.org>
 <avEkWyGoKsVlCCRG@dgvxl46587.localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avEkWyGoKsVlCCRG@dgvxl46587.localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 5m1a8npgtx57bdj5zaog6xwsg7uho3qo
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E59A21C0004
X-Rspam-User: 
X-HE-Tag: 1794246107-342961
X-HE-Meta: U2FsdGVkX1+ARHmzKzbsC0L9wHepUIQy66EZEjnX/st2Sbbq9ZqlpQPVrTYecbYTmutdZ2D+pgOuzhe2eBvu423iAiFmrkla8r7MydP75283BqaQCX2+ulhS+EzfXBT4JpRdYcuA7/ebEZ4iXGrU/hm9MOUM5iS1ItAGtbz3zJc8gRk1jVc2FXHFH2unxN905EkzQ8kL+RItZWGQJSR72GTgGEXw7bSsfPv6ruWXnUxDF+Aw2PgUI8hWDcWBsQEg5Ypd6jV1e/S1ZPUSljy39rGMY05zoQnyuyW3FQwWg8G6mhfCu/18V3jeoRxoUNj/mfE3I5N5SfM7O/6DpujYQhYsXrOl0ruNF7OXzMoTq7oG70xRbRc6Yisg0eoZdm+jS5ueCUvXzgH1+nKKVMrIooZZ/j88wffh9YmVceiN5iOI3hWFtfzRo1W4q8JHVbK9uKII9kOt1OaTKx2bVrEG82/T6vQeQjOzMPh0ESwobnvUUMrWxvQf0s/KnM4XoJUfVj/E7BvcgaA3kH9uoFHyrpMASgZHnjpNrLPERhTQVid/UruE91R3fkEIQmsl7D1ySUNooDAjaWq2P/u5xZGEmdXs3e9YlcbfjCuiQvMApPRpiCmipYGz7slMouMZbQiT3Ltt/U/5i38si5JI7LsrympiAFXWgTkguhAofEGiDQjmG0pGt4cvlpZG+TbQrV3agSYqEy6Y/W36aJ2OOUAGkmnTPyYAP15/RukYBA38MrouYA6bWc53aqVVicSLBnvN/dR7OCOXweNoUEqADDHmDtpmz8GTYpSOmYZ3R5oRwK+16L0B7Cx5jqbknU7XJvfzvTeX7KCi7cMUlIj3+fnKaEkX/2pbqXVNFqUwo7yHu8DhXCg/RaxcrRFLXLDLPGMT19ym7Z0nEVAv5ewV1QyeC8fsFroAA2YbolyFjode9Xci2nDwB/ZQvjHMlVfKnjQRGQTfC/M3a4j+IW5FM4x
 WpMEml5A
 k3EdWqBOEFocGa0UroyCdEicOyuXsIYUxbNuZGG8mfnADAkcBY9QtKemrWhDPRSFLQwkDuYIeFBOhhJXAjruhlSeFf3iP8/v6Qk3qr6QbukGXCs9n14qwG1lK1sKZZ9TSs0G1xivDf81acUAPzTX1eoOg2H3/huLVpopQZlvBFHfP98rbt8l7MTRZjhdolDz5A0y3XI6C9AJ7OEwRpDxPofnBCJWojmNrI6BOhMa0kS2w/PlBxmgBc9MvP12oMoMfekF+u6t7iO5Fj0dr7WL2rvnpuCGB0SVLyNDyGKdBgPwTVuIUIz/2E+ygMdau/qqV7q9UlDsKPSYx5Mg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 02:39, Xu Xin (vivo) wrote:
> On Sat, Nov 07, 2026 at 07:28:50PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/6/26 04:48, xu.xin@linux.dev wrote:
>>> From: "Xu Xin (vivo)" <xu.xin@linux.dev>
>>>
>>> Add a new sysfs attribute, /sys/kernel/mm/ksm/merge_only_zero_pages,
>>> which, when enabled, makes ksmd merge only empty (zeroed) anonymous
>>> pages with the kernel zero page and skip the stable and unstable trees
>>> entirely for pages that carry data.
>>>
>>> The attribute requires use_zero_pages to be 1, and the two are kept
>>> consistent by symmetric constraints: it cannot be enabled while
>>> use_zero_pages is 0 (-EINVAL), and use_zero_pages cannot be turned
>>> off while it is active (-EBUSY). The new attribute can be changed at
>>> any time and is only effective for pages merged after the change.
>>>
>>> Benefits in three aspects
>>> =========================
>>> - Memory saving:
>>>   On memory-constrained systems such as Android and embedded devices,
>>>   zero-filled anonymous pages are the largest source of duplicate
>>>   anonymous memory. They are produced by userspace allocators: the
>>>   zeroing of freshly allocated Java objects and buffers in the ART heap
>>>   (new byte[]/int[], Bitmap buffers), calloc/memset in native code, and
>>>   preallocated media buffers. Merging them with the kernel zero page
>>>   frees a significant amount of physical memory, which matters as DRAM
>>>   costs keep rising. With this enabled, we measured 100MB–300MB saving
>>>   tested with several popular applications on aarch64 (Android).
>>>
>>> - CPU overhead reduction:
>>>   Merging only zero pages also reduces the overhead of ksmd. A page that
>>>   is not merged with the zero page carries data and can never be merged
>>>   with the zero page, so there is no point in searching the stable tree
>>>   or inserting it into the unstable tree for it. Skipping those tree
>>>   operations for data-bearing pages reduces both the CPU time and the
>>>   rhashtable memory footprint of ksmd, which makes zero page merging
>>>   practical on low-resource devices where full KSM scanning would be too
>>>   expensive.
>>>
>>> - Security:
>>>   Finally, this shrinks the KSM side-channel attack surface: only zero
>>>   pages are ever merged, so the sharing status of data-bearing pages is
>>>   no longer observable through KSM timing side channels.
>>
>> Lol. Did you come up with that or an LLM :)
> 
> Ha, fair question :) This came from our own investigation. We were looking
> into whether KSM can actually provide benefits on Android phones, and this
> observation came from real-world application workloads. To be fully honest:
> I did use an LLM to help polish the English wording of the commit description,
> but I carefully rechecked and verified every sentence myself..

The reason why I ask is that this effectively disables most deduplication where
KSM was originally invented for: VMs running the same kernels, libaries,
executables etc.

So yeah, disabling most deduplication shrinks side-channels ... by disabling the
core functionality of KSM, to dedupicate pages with the same content :)

> 
>>
>>>
>>> Note
>>> =====
>>> - Suitable for Android, embedded and low-memory devices, where zero-page
>>>   deduplication is wanted but full KSM scanning is too costly, and reduced
>>>   KSM side-channel exposure is desired. Many handset vendors may prefer
>>>   this knob, which can be used as a default fallback policy.
>>>
>>> - Not suitable for server and virtualization workloads containing many
>>>   non-zero duplicate pages, where vanilla KSM provides better memory
>>>   savings.
>>
>> I proposed something similar when I was still at RH. My concern back then was
>> that we don't want/need all of the stable/unstable trees.
>>
>> IIUC that's all still in place in your implementation, right?
> 
> We still keep the stable/unstable tree data structures, but zero-page merging
> does not participate in the stable/unstable tree search path. One more reason
> for keeping them is that merge_only_zero_page is designed as a dynamic knob
> that can be toggled at runtime, so when it is disabled KSM can fall back to
> the traditional full KSM behavior.


What's the memory overhead from keeping these datastructures in the
merge_only_zero_page-only path?


-- 
Cheers,

David

