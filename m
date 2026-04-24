Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C81FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D73E6B0005; Fri, 24 Apr 2026 14:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF226B008A; Fri, 24 Apr 2026 14:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5386B008C; Fri, 24 Apr 2026 14:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6F86B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:28:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE6711C0260
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:28:26 +0000 (UTC)
X-FDA: 84694284612.06.2F90F90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C921F40008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:28:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1BTff07;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvqGh0pU5Nt+ZFgnakqOu8fyNuwnoAnCPpaxjmJD+R4=;
	b=0+jDLwD/1ip4TqxYRfNy1/8Q0G9qgD7EfexiuUto2DmOQqqKhPAoIDaISyMHJgFvFmS6st
	DevG37wQnjjWo6syvWNvns/HNT5jAPybVikcgXC/LdMBWw/rtLH4Sk3So5BPozzCCgpIcP
	f1Laq1GQe1d8UbF8ZH7kg44gBBAn6lU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1BTff07;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055305; a=rsa-sha256;
	cv=none;
	b=vTDhvalQeG9Lru4IEF0njqw6u0omgF8kH7EY0PhnIIP0tDEeMp9wPKSvF5RC7G9sUkcf7x
	O1xd1D3+k/MeEW3U4s1wH9oYcgSGcjDQgd9NxJ92Qvkqwq6I1EexnUhBShQl+FMQTuxwiM
	P8PxvKiugeYN4Ixz5HJjo8vl3TIL0Ik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFFA44363F;
	Fri, 24 Apr 2026 18:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30E6C2BCB0;
	Fri, 24 Apr 2026 18:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777055303;
	bh=nsCK8lA2BzQi4jFTXuDqLHYn5FbisryKK3hHm2rfaCQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n1BTff07OGkd3Ad8zf+5Bg+/axUDSkNbg4CLYAhI1ceEUwVlSFzuGBu8va3AnWbfm
	 R9MDSh1MWXNVKGAfKQZhvO7Xh601sjrX7CiCWftSrNhbp76H9xrctIXgNkXfdqc+5J
	 p9vNHjPyrVzsjO/5J6nMqkebRtSgewFkQKOUJJTzCVOhEfTkBEU/hSNYD4gsQbxsb5
	 OGZjVoSabsi/F7bgQcZ1cFU1UoghdExt9DoSMe7U1D+VwL4tC2GqdEzpeQLHFmPH4u
	 yzPQh1OYyts/vthGnzJmF2OYhJ8dkwv8ep3mF9KXPaIz2SI/wc7zRj7t1iMUbQXcoj
	 hyT5th/hP8pYA==
Message-ID: <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org>
Date: Fri, 24 Apr 2026 20:28:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
 Sasha Levin <sashal@kernel.org>
Cc: akpm@linux-foundation.org, corbet@lwn.net, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, skhan@linuxfoundation.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sasha Levin <sashal@nvidia.com>, Sanif Veeras <sveeras@nvidia.com>,
 "Claude:claude-opus-4-7" <noreply@anthropic.com>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
 <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org> <aeuC6TJ4XowazVZj@laps>
 <aeuFnuiYDBjttEKt@plex>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aeuFnuiYDBjttEKt@plex>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C921F40008
X-Stat-Signature: m6xokno1sbiwafx7xyfopnwyafznmb4d
X-HE-Tag: 1777055304-660671
X-HE-Meta: U2FsdGVkX19C6BZUj2mgPtzDfC9a4X5BLp7LKMyFimSgmm0oMMo5/+VYTJS8bMOdtgqd+zWMvdLcUXx9SVePq/AF1RqrNPa0ARINeQqoRg8N7NyXsSBdUnhAHsTSbbUUKZaD4gVaIxL3I6F28LNV7Bu/Ik8yTA6Uy/ZPIkAWkyMClyZK8d4AtpN2Cj8Owba3YpvNeHN79hD3ZxC09UsG/JrMd8mF/uYjKoChBcS5DYISltYl8dbE13vOafSk/LhGV83dqHuNaxeVqCe6Qya5p0TFPtks7ZgP4S1uXqSz+OJkxfyyx8SGcUatfvEbmzPrnzjF9mjwNRz/aAv2oCwMY7zRcJbg01iEb1Y2HnFy0Bb/5J/UR1AvYA5N2E58qizu3cy4UCoLuY90l66ehOXQO4w8elei3qAKMDWAvtb6F3Q1DQt9XZdwNxh5qVfACLkrbLk1NiKaVDSfumaspWCs5XhizEiZeFl9RUSGrFFAvOoTgSk4gaUh6HDMqczTB53G8tLaTIAqYVtkB1r4iSNZBn6TscP7h6jsghgPXoT6rFecISSFspWSOHiJEtKsI7VED/0j6/6SI/5XODN+pBUSU8O97A7b3awqiA/bUyt/iVeBnY2o1LK1RYG6N1zEp8wcfLWdG2/iLIL9sa0nJ32oM0xeo7NP2ardsBbmlFXCPS2ozZzPVDIYaiZQNjANedza4z9nxClE6HcVfOKdT9KdcoWwt1ZnwwhDjcUxQupONJ882q4INdl9Z9ZHOTM31YxtM9fDkQRHhDe8T0n6UMuN3ExI+XZfBmWnxO0ejuTbV9eYotUven7GlZNQ+By+mEzrj0kdS6VIXEbman5hxrNjKJVU/7gacaemmZBGThrFJPpX3s0FonNOFoDtA28dvhkiEULGIuQx+h1xHrrS7mzzgbonHMXRcENuQDi5b5mQnjKydjCCorlO6AIP97otqYfmSfrmxXLmyEgYoN7bWGk
 M4x+UI30
 pCWIAPiXjt3iqFy0GuYaP+CWLJeD4TFrldKTMbNstOPiZxXYZgLY6gar8JG99q2bGeNzSB1mAxJnX2i230qiWJCzkcZo4/f6S3a+ZyeO4MGFWGvT2AY3ZCXQEoNa2Dw4aWIphKbFChlQ3f8pXfPtMkVEsJhKzqXVhOFGh6TiWtBRp/AER6yU4kWtjnEveFoCDZNTag5hLURAMfoYGAJo4TTdUTXy2h6xjsPoC8SrU27T6qWiiewCiOFGuqaPa45ciQXNw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 17:06, Pasha Tatashin wrote:
> On 04-24 10:49, Sasha Levin wrote:
>> On Fri, Apr 24, 2026 at 04:25:41PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> One bitmap that covers all sparse memory available at boot.
>>>
>>> Conclusion: Just horrible.
>>
>> Depends on who's looking at the code :)
>>
>> I picked it for auditability: covering the whole range with two
>> memblock_alloc'd arrays means the only thing on the lookup path is the bitmap
>> words themselves, which is what the dual-bitmap invariant already checks.
> 
> The issue is that we are going back in time to a flat memory,
> without NUMA or hotplug support. We need an abstraction that avoids
> allocating this memory in enormous contiguous chunks, as thit approach
> will not work on modern hardware.
> 
>>
>> We could go with per-section bitmaps which will fix the waste but pull
>> mem_section[] into the trust boundary, so we'd have to start validating it too.
> 
> Page-ext provides all of these capabilities, but as you described in the
> cover letter, it does not meet your requirements. Therefore, I believe
> a new abstraction layer is needed.

If we decided that we want this (and I am not convinced), we definitely want
something that supports sparsity and, in particular, something that support
memory hotplug.

-- 
Cheers,

David

