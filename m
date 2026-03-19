Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66F4108E1E9
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168E26B0479; Thu, 19 Mar 2026 07:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140756B047A; Thu, 19 Mar 2026 07:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056046B047B; Thu, 19 Mar 2026 07:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E74FE6B0479
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:10:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A493F59163
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:10:44 +0000 (UTC)
X-FDA: 84562544808.14.00D8158
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB3F018000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:10:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6N5YwLS;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773918642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5OiDh9ZOcOagneeFTtIf+kAzBjMZS8Y1rZCLqteg4c=;
	b=zRQDpfZHl+AYBHR7KHiBw+WbU0c8fRLxrlf/6PPU0AM01OpdDPDq09oRNyM+q1o7T9PO+J
	EqcBLogVIVLXadkbDnTygsfj/mDISrp8lr88upfarlcKaswaeo8qaKthtjvsNns4ZH78oB
	7KzGH7BtBEJcvlMom0bXvPi18Qxfsrw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6N5YwLS;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773918642; a=rsa-sha256;
	cv=none;
	b=eb91/rU4m+oWPyk4vUUeXnqV3XTUVWHJ7cckBZTZrftdG6ztdlKQ66i5kg0k/pIgAJSgtd
	ivZjUl1FfLC11UOZkS84CfjycX4XsH0jPgYEoV5k8oY75EcP8/nuVDj15bZU1x4JUMxHk1
	juAMjikV7bwuRI2QEgTG2OIdw7+cEF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BC7E60126;
	Thu, 19 Mar 2026 11:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BFBC19424;
	Thu, 19 Mar 2026 11:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773918641;
	bh=xCSk92CfU8qfUajdKyN5JbDzZ9wgci/sR7WiwlKN7dM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e6N5YwLSaG0NIXkeUTCCwISt02qYAwd45uQT2jWuzW3aERJMg1ooKCjNIjJkhaWqB
	 Aq8bMUQwVEqC4Ug/ZIRh13kRteZIBkSX5iuPK1SNmENqrfu+yQJ+NhOAd3InmoZw4r
	 B+++EBhlFsgKJNy+aUNO94flT3P3WjZffgVmfszZUDMgeHl0aIhUhWMxON9YV95Hfd
	 uNmYSB0iEvKHbuLHUCkXpCUkpB1Un5w8hBa+RQZn/yvXBLQMzkv81tMCFWUG6oqKRJ
	 00H7DQUU2Pp2E1QwO0Hp/i+12caJwgukh9rzMIDwsuV80FbQFuG7AqIOpS8g8Cwp2o
	 dv3NmQXTTo4zw==
Message-ID: <5a4fc5ba-ab0b-4294-9577-9b5ee30b2c56@kernel.org>
Date: Thu, 19 Mar 2026 12:10:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>,
 syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
 willy@infradead.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
 linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
 <c3defcfd-74f6-4e70-b002-85bdcba44df9@kernel.org>
 <b963c391-8576-4351-b121-67ab9a9b2a1e@linux.dev>
 <8ab10631-4672-4196-b32e-7c5a01707424@kernel.org>
 <ecedbb39-2df6-4300-99de-a56c7490c3d9@lucifer.local>
 <37b48d94-9576-4529-8576-d4ed615d4768@kernel.org>
 <b5e33e17-86ac-4587-903b-b277fe5b752e@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b5e33e17-86ac-4587-903b-b277fe5b752e@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB3F018000B
X-Stat-Signature: 61mobhkf9frfar1qjym5gdfqhbojnzyy
X-Rspam-User: 
X-HE-Tag: 1773918642-90250
X-HE-Meta: U2FsdGVkX1/o+XvIMDb424cK/5Mhr3dnv7r8PPZE7Bs/5pYEhM5FSYib9OvdMYwzKVzUDJSGV9cS6YUA8q1rqYEIGb6R5rY5ty29p1yO9BCmFyHlo9EQojA9TI+zrUEPr/Yv/qneyRl9v0KqGHMCMqUgshwDntrE/u47sXDJ+zeEuXcMcqRuJfP0bCdIdmmx9y9tWppjLcST9Hre9HzyEmnHixUMPa0bBdznelhpDZuy2BLnj8Q5E54PSz/1DO7F43MItdO9oVZh0DQJnMDtVENmQtu67MfKML75V6xgMI2VXZfctCfqj9zN4aFA5ws4IK5DSkQ1h05NmiKJTkuLMjRRzMc0QQBbqdcF59cNJBA3D3nguMW4+H7TmOvJTA4NrKY2b4gu2VxhQFDSHjdWQPnymdsag2tET3N7UqlNzrm3XKP1Gq7Mwl32Lbtw1Kj/5/S58kte6Q4EmLrFWX4BfZaxf0q+zTlMantUo1K9FKq2PRwGDU3/5V9q75X4COm2BCVjvFuItUo1h4VSAhPSc8LzuVIOuPjjh21P6kco8qIadTc4mFO9YS5iTEiiQN0rGTpQHCsYl68i4g8vI0WBfxRj1GTBgH3pYa0UGc+CDHl/zMLYUcRQNXY0ESC+Ljh2DnJrtA5GR63XIv+SoqzYt7I3c9FQY/tZEgkLMgvC8xvs4E72XnVUnBf/SKkn1bWR85s3BEiOmjEMWv5H3v0rCVATcuGJlUdCrzhC6mgUtkdYaLdFA21/PgFx0msiBQFH/y28muFQq6zUYUdOe7vaonug7crnz94LIP5HfTknRbmrIYl/xxDnuY3SyajkW39rpn/SNCSMY79ejDbwMX2os8BF5qrS6cUEWSIJWfq6GkAXtdjMNTtAjt7RgP7b8OhjWPxX9y+QNkkHCB8yVZIEfDb/82zETyUJOM4RPox+qP260uw65IjcKWZx88TrCI6WxBQImyMiwcQOCpP65l8
 OBOMnjRm
 STvvuVu8lJx1jcfVF23Gb0/8VesEUDcMOPBkKweyLNSiCoLrbV3dWpIk7FNBvh9y1w60NX44oCSf0eTmW66bKMqH94TAtYzTwyUuQH0L4vRaRiHj8DDdZjO9tEAxBcDqrfbMxTiebBGnapXmymSIHC6SjAqT4DrHc7vgc7h66l78F7D82TXo+gUPa7dqnIBnyFB/2qGU1fllpWdTh6JlXmcumwkLMr8aPj2ctrf4OqRNbUezRg72bTS2FwVCzTFeriZ11Jlbej6Vdf8gD2Q24ZD19Z1YgzQXDgzb1diZBwueSpVs1XAmSY+/99KLbMwvWLQMvTRMjnFBpZV7rOqs7nkY+WDvd2iJ6MOOjbYtoC+wAMBmka6vvULQgAvKDdB3QfLwBUf/2t5yRLCZ6Jnguf8A7/zrrd6+QHsxs14xTYy4XUGjqGiLl3hbBsTJ7AbGTNlBU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> "This isn't the kind of thing where you can just jump in with a one line
>> patch and actually be helpful, sorry."
> 
> 
> Yup, so again really I don't think the kernel should take the xarray debug patch
> until it is discussed and verified as correct on-list.
> 
> See the discussion with Vlastimil.

Agreed.

> 
>>
>> So I am clueless if there is a real problem there or whether it's just a
>> false positive. And whether (if it's a real problem) the simple fix
>> would actually be a good temporary fix ("make other bugs more likely").
>>
>> I can try finding some time to look into that, but pagecache code is not
>> particularly the code I'm familiar with ...
> 
> I don't think we should waste our time on it, willy's series should be yoinked
> until it can prove itself for-sure well behaved.

I hear you. At the same time it has the smell of "test case fails, so
let's remove the test case" vibes.

Well, arguable, it's worse than a test case that fails :(

I'm fine with dropping that asap. At the same time, I hope we won't lose
our reminder that something possibly bad is broken upstream.

-- 
Cheers,

David

