Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04FC5D35176
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C37B6B0005; Wed,  1 Apr 2026 07:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B0D6B0088; Wed,  1 Apr 2026 07:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0D96B0089; Wed,  1 Apr 2026 07:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6466B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:38:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC9981B8AF4
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:38:39 +0000 (UTC)
X-FDA: 84609789558.15.F56E09B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03125180007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:38:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eBskjXCM;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775043518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQQnOmBo1ESZfb0SGk34zwrqfhlhv+DmtQh77NATnyM=;
	b=CVyIp2nYVFrCFWKS+ZGjoSpsBvTAUmwQkVf4cDQpgasUo+bU1rpeDxMw0jz7ULoDvdEC9z
	ZnF2g8rphUk7DByM93SluMPIOUJEM/tV+PdxfSEv1/AChY8o+5xU4Z5b3imvRAVb6KyHKX
	k8q4GbFy5WlNZ+zzIzgs3qaavLrGAc4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eBskjXCM;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775043518; a=rsa-sha256;
	cv=none;
	b=xv8Gd79Qk0hR0nUKIWpdaXbUwEuZqBHp8QVPG6fSaLsP3lo1YuYcSCH7+5qm/ofufiLSvF
	/UwWKdXLJYtuJQPluBaLXkm/6EvDuXkrMejl94OPH99Qkk1sK46dMSR60PTeN4yri9ts2r
	o0msjhgAbLHlMP7al/RoXfdIUM0krqU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CB0B408F8;
	Wed,  1 Apr 2026 11:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA01C4CEF7;
	Wed,  1 Apr 2026 11:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775043516;
	bh=12Rf9M+2EKOvcfXCBti89IrItim3hAHjNLiB9TnixCQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eBskjXCMmhOraxNGx+vZqaYVnU5l86LDX6mfpAY1dKa57LU8E8GKl1rCNXfnKyMg4
	 2912PlpapGG309BgU76kWmHig8RQDTa/B5VZQjXEwoonF3p3O0/auiYuokgn6m0o8P
	 achUE6LNxyC3jVsCYP+4dMTq5MNtI52SIbyLmwS8hDbYqWeYpDO4QBH2X908dbtZC/
	 lfYkMN20zAo7Na+hKKWmAiB4AJWUVnQYV2Wayjt87WYgg692yVu8zhW31ETnGHKMD5
	 bT6kAoI9ecmVeELOCw/uWpbMvKim+tvo3SCub6PfpKI7Y67I5FC/eg0l2RM0F2AuDs
	 BZ2pplF3Nri6Q==
Message-ID: <cc8a2d06-c774-48d4-af8a-905126dbd588@kernel.org>
Date: Wed, 1 Apr 2026 13:38:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
To: Lance Yang <lance.yang@linux.dev>
Cc: kartikey406@gmail.com, usama.arif@linux.dev, Liam.Howlett@oracle.com,
 ziy@nvidia.com, syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com
References: <38a347dc-8a1c-4d04-926d-7a6318e93ca2@kernel.org>
 <20260401113434.29369-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401113434.29369-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 03125180007
X-Stat-Signature: dwd9c1scwz8woxmmxuyrbbfmripgremu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775043517-798810
X-HE-Meta: U2FsdGVkX1+vNAhRxNHzk95z3YuWMnZpPDWDYEGVywPa7FS7CwucnTXVnbSon/94ZA0bd/1GXfS0pNQBgV6Pz/fnwiTxewPfgvaJWMPjDO7sXDu2PBkfxsMalxsbxtCXa3EUPXFB6EoURImgPNzXZQxQ9hRSSRA2OKiSY79gmKkUWHhv+4B6C1IY09bmHF9OHmQg4SzimrmVLPHtPaVa7VqBv1Mx4PmCz/s3MTLbjsvjmNvHLdlIdVDxH0eOdzZrxVCbfdjGuTGZ9AUfrW7diFQXMO0ZaE+o1pa9jzDgXM0iMpxBtOxRYUtqPIaJsttBT/Cex+jEeo1d78gyIWPxeLifLOT+YEwlnTduLCK1hbNklQzfkv4XoofazyTLXfoo+pJHIYUP+5OAzcXbsM20U+f5ILmH6+PsKKAMplTYgxN8jdgVycHyRTXV8E925V87UgzHAqOYUwnJAX8Xh9glNhMAFVDQcN400T1sPWhN461BIxhHFxmyuHVOvCWMDk2X3I5TzuklOxj3cOfyEyXKV0JXMkCkvWKLP5GLXCu8JJhKG776AaUdSE4n5uz3gE7i0MSQxvrXx0oAqbuRXlKDxlbaUkWGHa3+ucvG+jx40JaEMIYG2Cj6YHbHZHOE9CXwFFScxj6AyiYzILrz9omkWRJ9ZawyPea1w/2Likf9nQGNjYPITwsINdO57wKKIrVBSRKKq3Rd63GbzgzJwYmI1VLlLu7p7lAalJP6QAHlVZcooCHUU+6//kXjbNIZ03fFsdQWJj8S8pC+IuLFfKS7jkk6+rL8FT76Xq2jw4Tei/uhKIO2X8NcVD+Jv33RcegF1AW8VVL5x6Pop4F2T4wWjJoZmZMk8Bp8YhtzpCMwXvTJl240VpFNktQM5woF3SMhyp+1ueXDi6lx5ETwiNxxoLKtHaM8PXr9E22KPn8Jr7xwVxH1VDk23N2vyIjWo32YRcMF3Q1x4nA+LXeV2u0
 wYnmu/Eu
 qgaeMiYheM4daiJ59lo794GM5oNBYhKozi9PJJNlD+R+sE5L+KsXE+xloLEOo+O5b5btrhgSWRgRl81g28NlROLCXqVM9wnTS6ESqM06ERP3r2MOCw1OoB6llgcBgBOcb0+wE/Jr/AfC1Q2N7KfKH69b6JwJcgwx81ZXNW3AHtGt+leRNl5dh/aIDzCgZ2aUOd+InZ16E6zwBy4j3TZ/RFWMBsS6JExph7i6w4EIG0yg4cLbIl8y4VNwmv8oQcCtFWqy+rReyjjYUaYCYBV3y6g6akn6uRjO/6/ImlgrFU7aRONRfY3Xvz4DJWgSqIsHjw7mX3qyVZ3zL8ak8A+wu1Av0+cAhs5jSfsPDZXa27ebFG/tcQLmDEJrCDlUy2MiBifYHqR3XpEiUz8LyGf9hjuD4ZqkEpPzUl1G3t4Js50pmhG+G2J7mHB+F5UiCHpwP6ql0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 13:34, Lance Yang wrote:
> 
> On Wed, Apr 01, 2026 at 01:22:58PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/1/26 13:20, Lance Yang wrote:
>>>
>>>
>>> Ouch, you're right, I was wrong - the trylock drop is a pre-existing
>>> issue, not caused by the reorder ;)
>>>
>>>
>>> Nice, LGTM!
>>>
>>> Given that the "trylock -> drop" behavior seems to exist already today,
>>> do you think it's worth fixing that together with the reorder?
>>
>> I'd do it in a single shot if possible.
> 
> ACK.
> 
>> Can you craft something? (cc stable etc)
> 
> certainly, will do! But commit[1] ("mm: migrate: requeue destination
> folio on deferred split queue") is only in mm-stable now, not yet
> upstream/stable ...

It's tricky. The original commit will be backported to stable kernels,
so we want also the fix to be backported to the same stable kernels.

The commit id in mm-stable is "stable" now.

-- 
Cheers,

David

