Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE6F2CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43486B046B; Mon,  1 Jun 2026 12:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B426B046D; Mon,  1 Jun 2026 12:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58416B046E; Mon,  1 Jun 2026 12:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C362B6B046B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:27:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70C841A0714
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:27:47 +0000 (UTC)
X-FDA: 84831874974.25.FDF9C78
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 472EE14000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:27:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WMJEz07D;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780331265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfdjQS/pFfEXuH7PG4C46cynqclz9ShkzqgbwkZu3z4=;
	b=p2sb9TOppDf5+CJln/F22GawGz3tFCz31WqgrI6AnLdmu2Y08S1PD2knz/IDWRGMpd8G8Y
	uMScl/fIncWBPkFgLffSYutg3/zLNI8lI2BAe0e4LmjqQiGQKnOHB3l9dpTumx4p+PudCc
	4ojg/grn2Dh2xnf2S7iejT4LSkuRdGA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WMJEz07D;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780331265;
	b=CFJ6cNiSLzFu6Wm5iNvIM5Vc0u+IPMkAWJ7L3z/ekxX2nOos4pPD+afUfM5/lgwFb5zTQd
	GJptJ6E7oRvrL3iQPj1CUVy9GkiyEX3v89EXtfc0S4Ci7ytv0Gql/fGCUebNGTUUwdACAs
	bJiMeIY+6PW3qzezROyMzC0e3xhXa7o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 724B4176A;
	Mon,  1 Jun 2026 09:27:39 -0700 (PDT)
Received: from [10.163.164.232] (unknown [10.163.164.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B684B3F632;
	Mon,  1 Jun 2026 09:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780331264; bh=hJ83ANAMGKlfACSoWSYsWcwjPLWYlAw2gamYdgHqgfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WMJEz07DJwD3lk5ISTRXSnfMF3sfA6pRzeWlr08F8XagPv97GNAxD2MAZl9OMNuRP
	 BoT0SrgsqTTl3dWYe+5pf0unJowIew6wmKXwrQ85HegAba5PAZQGjiSzb6KPgmSicy
	 FpnW7AIuja72LAxgvYaGRprOX1soQsCY6soI0LAY=
Message-ID: <474a4ee5-a29b-4b8d-95c4-daaf7bf5aaf6@arm.com>
Date: Mon, 1 Jun 2026 21:57:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260601083044.57132-1-ljs@kernel.org>
 <cd8b6bb1-5c42-47e4-8773-2c301a029372@arm.com> <ah2rKKATQwGN_PHu@lucifer>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ah2rKKATQwGN_PHu@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 472EE14000B
X-Stat-Signature: nsjtrw6nhaahyfm1bruqik4ogmerob8d
X-Rspam-User: 
X-HE-Tag: 1780331265-606155
X-HE-Meta: U2FsdGVkX1+9gmTPbxpkBkAn+PVJQRVxrvk6XkgamXRuv7czQ1Yu/8iM3Bx/ggEIoBGod6CNfSb9RDIsP6IPfb0D5VG0N8aeLQhRhZA1NswvggjVH7INp1uc6MGyrsK1IEd/Cw3upTdGCqjzo/hhfoBA/BOtI25cyw5ev0Hi6HIJU3Bb2oOzaVNFcE8+fpm9ETj7d01j6eBQJA+sKLB5fAE2vGqJVZj8v2RVdVpRXZ66l6j1XIL7ZZi61O8muWnStTduFH7Q9l1ocKsmA7UEhN1BTdKfMWAjQ4TM4JXT/Qd5Y+2pMkVRpcdF1RsDjybEFv5Zn5r/RNo2PGErrVweQ0BX2trZsgKbWKR63L+mUjPbwFs48gi2UnzVRaypeoAGACvDQPyg67UKjLyBXvQ84bToOYmFLvtp9smWdbka9T83o2eAM0ndxisvVf775r2js2wIeQhbv1ekWGx/7rhDoWPOczsdeM39thySkzhgSU9l60mjR9K/O4eT1X2Whr9GvqCCP0WnlqK0xZCzpidicgOT+Fr4QBfuqRQOtRkUeb7iALuSd82E3Fn4gMG/YryltU/IlbBp8q+wd3p3V44xV8BBq9muD4mak7BwZ9BNlxKqjffkQVQrwKiEIV0t1vLGnM4RQd7d/7jv5mMnU0Lv5Idb9bjo6/G32i9VvPkJzU7KoOnkJI4t/fpS/pngEHZIPerArV88ckyRKSCGtjp46LNEBxgKxIf9icML18D8He10KkKfClwo0ubAnUhkBjjP8s3bCoRqUoPWlV9M1oQwQuJrksjnWCh+2dd4ecayu7IDunvAv7N4jGEIdjuE7h2jcFdV7PsyZu+k83gnL3BJbwcl8pS+snNrhJbC4I7K0zaS8ZHO02nRmlKm4H9n38ufNg4gWWmXrVFOx/nzCC1f/U8NXxmhxGOHlvQc3xA44yoRC4JknJejEF7oUcQ8gUT9G9d0n+cPSsmYpxX/Nv5
 yBmiI6JG
 pTmafY3uE937Crwt5YnQ0pRfQk5re1YJ3Yz9zyZGbIMCT7UWAl2UwdJIecBJclXqBBIseJfXJboA1eZs30mFrA/b5jWVf6v2n98BmcaAnnIAoIJ54/k7FDOk45Ki1AtcQ6F6MQKv8mGL3ABt6BzXAfH+0MqbDUcfACe8nXuDxJgAF3v1AFttLktLherkAisMMnmaxo6GZxfEnNceTs5F1ic2EGEKjKd6BB7FmxY2SL4zJAGuDIJYcveHTJD15OnGlwwIxxiJuUeePw+FwHwZS9O+4Ew05rgr8D8FuOxgfe2NJlGqi+NTUtBhewKruVPD/zkcVV8zCZ0CKIJqVTUg3Yqj4SZrxSaj9TUGcPzaKcFYHSEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/06/26 9:31 pm, Lorenzo Stoakes wrote:
> On Mon, Jun 01, 2026 at 09:20:51PM +0530, Dev Jain wrote:
>> Sashiko continues to find existing problems :) What do you think:
>>
>> https://sashiko.dev/#/patchset/20260601083044.57132-1-ljs%40kernel.org
> 
> Thanks for highlighting Dev and to be clear I'm not yelling at you :P I'm
> yelling about this aspect of sashiko... :)
> 
> So, this patch fixes a serious issue that renders THP device-private
> completely broken in a way that can lead to memory corruption, and this
> review comment has nothing to do with that :)
> 
> So TL;DR - maybe as a follow up?
> 
> IMO there's _no_ obligation to respond to stuff like this, in the same
> way as somebody in a review saying 'hey here's this unrelated broken
> thing'.
> 
> And this kind of thing should _never_ _ever_ block a series or patch.

Yep I agree.

Thanks David for bringing up the link.

> 
> (I kinda wish sashiko didn't do it, I have extremely limited time as it is,
> it'd be better as a passive background scan of existing issues or
> something.)
> 
> Cheers, Lorenzo


