Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A30FE1075276
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 09:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5BD6B0448; Thu, 19 Mar 2026 05:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080CE6B044A; Thu, 19 Mar 2026 05:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB05F6B044B; Thu, 19 Mar 2026 05:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5BFA6B0448
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:00:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7734F8B96A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:13 +0000 (UTC)
X-FDA: 84562215906.13.15730DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 64B2540009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=McPzNdsf;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773910811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLpGL8Vr0yASXj9ZY1iUl1uVwjXzOrVlN9+ZR3fg6Mw=;
	b=gQhGSCuRTHnJVT5ivP7nm65mEIg3FzKLSRZWQF0KnjnIxo5MaObUbPSOUXBKfJYO08A44u
	/n+SVNlP5RcZE/zXcM11H5mws7tG/AIp5rii6wPoHXTcN7kwesei3Rbnhj2J/5p8WMArfK
	E/FTjyLHceOsBlVHPg0XYKfuKmcSSgM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773910811; a=rsa-sha256;
	cv=none;
	b=rm9ycs/iwul+K5jgd6tJBHg8uZQn/EE/9V8yL3CQXvtUPXFEadaWJxYzmJygQuiqTB9luN
	OveEo7j2Rtig+cSxZjVlxHDZ9hYe67S2/IhefIxq5LApt9vIm0vKHdY7q/IQqVLETJAn07
	NUM+SodVQEjRu8VXvWHBT9eZzqY0U1I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=McPzNdsf;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50155442B2;
	Thu, 19 Mar 2026 09:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489E6C2BCAF;
	Thu, 19 Mar 2026 09:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773910810;
	bh=rutOn3YV5gTkK20mFe8/Y152SVFObowRGYBbVWX6jxo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=McPzNdsfk+0MOZqdYj77+2D1+dSQqQ0f5gUnODqByMZsfjluLsehrLlau5ZxvD3K2
	 SmjDZ/EBvi9YuZEKPeXbc7HUX4u9FPoYSH5LSk5PzAKVxmsArKSv6SEOTz86NODZo5
	 KVKmJnyHinzfH1vUYErfyY3XaCFnQFBIB12ulrfwsm/j6p7vsrcNZ2WOIBlBLrq41/
	 seQ/e3i2Y8+Wrx+5UGFH/J9uYW4+3gXccSGberHmrlXVIPgbezuU/KxiGpFu/GBPi/
	 iNOag5IvDofsp/QgyzdDzatWUDk1xTDDF6qbLOR5pLZuRReZDfr9fSzCwWPNS5qqx3
	 XP3jQr7OUR/wA==
Message-ID: <c3defcfd-74f6-4e70-b002-85bdcba44df9@kernel.org>
Date: Thu, 19 Mar 2026 10:00:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Lance Yang <lance.yang@linux.dev>
Cc: syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
 willy@infradead.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
 linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 64B2540009
X-Stat-Signature: jrsfurg4e3ww8h9snmgwz1hjt6tz1aiz
X-Rspam-User: 
X-HE-Tag: 1773910811-85251
X-HE-Meta: U2FsdGVkX1+F7DnkAOW3BIP0DSCBJ1OX1G+PI5AR/HlzVYTnFwsVSe0oP7TNxewP4rwzgHBNO5VQMJvRqQpvC/FsLxj3FqyJzJgRJLBs7cW3uC1BOgYkcqGy0cTVcM2Cd+3SnqVgrxeZqZ/LLoC4RddbNNBKc/ihQujzChxSQOIIVJ2wlI2OA6WWVl6VQuRwypfD2YuPA+ZUJHSsYEf+27M3lqzU6O4bQgn/HUsb64iZ3VZEOA+/QP0UoIO4+eyqejgK5X31cvIQzS+suVJYpq4zvpdLpD13gmRIAjwhSgjYbSbOGMCmv4Svp3V19lhO8TNTB5mCRWn7cbJ+/6ACevwndckONaJY8iH+oi2cdb9dc8OPN9JMz9ZqR50Y5IH+VQkbysc0PP/ArG+N1ak1i1/kgOes96tyGH7MfYdZw4nR+XZbiyGIxodApFP9fifs3+R3GlABrEF9nlqkRnCsQwvEGwg1rjekoDS+4Y3tULtBn/SsnALX+avmPnx2z8fo+wl9YbdK/Ylz/EIIahcZY0lBZp1/AikAbyjSmLPclhcIa4nLPmsssJMVIwP0jL0cpCKsYUX5l/Xd4F/DTUp5cS6E83zr4g9p6wD+n36WhITl+hnqULjAKJyuPHhbZDQlGl00UhkushHgFAHrRLmJqmO0qzyMEt7k/8xBfErXzmyZzP7p80zQNL+fT6wMAoFVD+OzZfsgTEfPuzmAZtFKMKfhP4oSo6ZEt1SilZMgNPKndqY3/Wp9qrzRtpv40MgCcmRmsLfTabIAb4lKjtTMCivZxqC5xJQZqNlCQnxxTIa/GDFHqhRyE8qqzfMsMyYHHn6UD3dkoJnO9UvMVLb2DG0IOqqRp/4UCORJCdmV6xWAUdxA0q19OxuhvuisiD7p34BWhsl3IUPJZLMkNqFW/uxz0WXlo6bSvm7QKRCPVuEPvfCUnHpDMSpyhUJL3crt3KNrD8arGgyZ5NFWHnu
 hC/6Xh9y
 CzWV1wIl83gfrhvBm+WvzsazR45NOrxrUfw7oBE2OU37FkNu65gYAJBRy/mbPEmQmiHlUXJX3eiChXtgMdVXmNOzb6rF2DjTiKAOtQldPmb5K91sDuemmc+c8MBtqosSPLVVmmny1g5yOx2K4mrUThdXx3gthc4P895o06e94e0KtHveiRYGXa3LLUQ8RdaFlpXUsuSYkBVQjcWevEpd0CoqdtQ9dID/2R/FqR1cazMrgvCuUestqd6XeZUoDAZL6xS/MweqMDNAFD9uvxq8r4zzyQo4zIHDlTbncO4/Wboh8XMYyzoHzpH4YH/l0wZJXZO4p70T2l2/Ub3QTkLT+CN8uTVJFchuNqYq/FaPRyG9MExSW3gergoHl/hSCW1mwycaN4FFQFrJcA9PP81uIlAfYKNlmQL9decYjCvEoEJ1PqQq6MV2fLknmTDD5DK4x/zy/emuC+NTMU0puEuxveVckkercAeg/mejFTiPfcz4k6VsNV+qU3wszFQPwTVvV0LnugaA7bQilK8lZUllLAKIix5YBCpnUSC/gKRvmcPLswGi3dyhUsWDPOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 09:53, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 04:05:38PM +0800, Lance Yang wrote:
>> Ccing Willy
>>
>> IIUC, this is a dup of the earlier report[1], which I looked into back
>> in January. The root cause is the same: collapse_file() calls
>> xas_lock_irq() without resetting the xas state first, tripping the
>> XAS_INVALID() assertion:
>>
>> #define xas_lock_irq(xas)	xa_lock_irq(XAS_INVALID(xas)->xa)
>>
>> static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
>> {
>> 	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
>> 	return xas;
>> }
>>
>> Added by commit:
>>
>> commit 43b00759f21b10142094d1ae5ff65cbb368953a3
>> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Date:   Sun Dec 14 10:53:31 2025 -0500
>>
>>     XArray: Add extra debugging check to xas_lock and friends
>>
>>     While tracking down a recent bug, we discovered somewhere that had
>>     forgotten to call xas_reset() before calling xas_lock().  Add a debug
>>     check to be sure that doesn't happen in future and fix all the places in
>>     the test suite which were carelessly doing just this.
>>
>>     Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>>     Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>
>> I posted a HACK fix at the time[2], but David pointed out that Willy
>> had mentioned it likely needs more thought[3].
> 
> Hmm we shouldn't leave this bug in place while working for a fancier fix??
> 
> Can we get _something_ going as an upstream fix? We can improve whatever we do
> later right?
> 
> David, thoughts?

I recall Willy mentioning that the issue is likely a false positive.

IIUC, that commit is not upstream? So it only triggers in linux-next.

Which means:

1) If it's a false positive, upstream is not effected (no XA_NODE_BUG_ON)

2) If it's not a false positive, upstream is effected but does not
trigger the XA_NODE_BUG_ON

-- 
Cheers,

David

