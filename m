Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4081CEFCE47
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 21:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3206B0005; Wed,  4 Mar 2026 16:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B507D6B0088; Wed,  4 Mar 2026 16:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53626B0089; Wed,  4 Mar 2026 16:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 917106B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:20:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AF3F1401E0
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:20:48 +0000 (UTC)
X-FDA: 84509650176.30.8539D6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5C34114000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:20:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pcsL7qsq;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772659246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/66LpixWo1M2GXd18vMpDKJ9Y6n7ok2PNLeTve+H1c=;
	b=4Kg7pmM2HntLN995SIg4iGRfDQ1juPVjFdh/2z1BixWRVks66BRmRddkcbt/730BST7Dw3
	mFIZa9sD3kplV+vLcfun7OAag1RSzikU7IJHGf9afp/QgN9plWuco1Z/iPA3h+kQtGBJxd
	bimJoUcp5k3/HHd83EyRDY2yWk7ht2Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pcsL7qsq;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772659246; a=rsa-sha256;
	cv=none;
	b=i3FHX8q4UCo4ky/6Q7x+mnsjN5mGL6GpiJ+P/8KLiYnJgxN2u0zY34KBDBINjpCW/Hh5+K
	0jsrYSCG5o9vUmLawNlUwGA9i0qk/qg+rnF1FSynmJ3kgNMfu0xFPpIC8b3HWkyhH/dWKb
	sMcOb6OFf70s/fXwxZRDSj110zrkHK8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EFAC60053;
	Wed,  4 Mar 2026 21:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0B9C19425;
	Wed,  4 Mar 2026 21:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772659245;
	bh=PEFmNLyjHS/ALIPUCbybwIkmjM7p2hAZEVo4N4QhGQA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pcsL7qsq5J89iAHojkRt9O1SIf2LMQL+Wj9LlAxXt81lP4reLT5mGE/kKPnQ4voA1
	 C0VHM6uMt5Puosi6SvpXeANdjxUTARM4J4k2W/DvSX+VVl3r8SbD2g3wPhLBbtSEeJ
	 1g5+xQok1fxfzJs8NicusjJ76mzQGe5ADEGYtOrI=
Date: Wed, 4 Mar 2026 13:20:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: igor.b@beldev.am
Cc: Harry Yoo <harry.yoo@oracle.com>, Vitaly Wool <vitaly.wool@konsulko.se>,
 Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 linux-mm@kvack.org
Subject: Re: [PATCH] mempool: fix the race condition in mempool_resize()
Message-Id: <20260304132044.a6fffc26f6bcd119771944ca@linux-foundation.org>
In-Reply-To: <98e1c65fec7c47e1ff77ac33d5604ef6@beldev.am>
References: <20260304131214.102588-1-vitaly.wool@konsulko.se>
	<aag0PRXyEN-ansub@hyeyoo>
	<98e1c65fec7c47e1ff77ac33d5604ef6@beldev.am>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mrspn6mky1wm6jediq4hjwrbiny9517p
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C34114000C
X-HE-Tag: 1772659246-302314
X-HE-Meta: U2FsdGVkX1+nvjqdgFor8KYMkqan1lZ+LITqY5xOuFwyjxcRHyJ2b9Vi96R+QdzFdijWLwzBko81HqBjh/mvcNZjlW7I4EZefA4A+mcczi+Y9FVn4PSYrsu4x2cIw6wMMrjGpwdPkxqCIS2slimczpgGN/9nMc9t2SR1ZWmQPlVRhdJoeL0cuLQJjam6pHasy0uplzZPhetTe8H9sGDotjWMpufGrhV5exjg3uIKGhY7fEahW+RXCbpnPAKvjxCsF2hWCvEDbzJ3jSRXUKtu6sstipU+QQscyylVsZRyBQLy6nqghFhqIl/BWqw0jPQ9QgI5qNitrXghYDZa+hFboinDVmW84y3r8SZnX8YlnfwFjFQOFu6MhABVUwtn4u4ydnxYW1TgJvZn8V1Mq/RMnIShxz5ZqMtFaahYenZDu44WmWYjN32wy3TJMN35B8s7RV9jm0cMg6td/zZT0WbjnXeJu3mKhDct3Cf66DlmkNGdvbtKMVlcFa928G1Y32j8kE3vw6dC/HBBLyJzQZAlzjylrwogBnpz7v/ORZb1d6aHy8Ax1JYA9YU8MHxI8uisrpoR/XSVRp3Q77Yv1iv69UZ9T2mb9YGEpHWduy7bjocfGVUmpNlx0VtPvY3pRvm3ilyIJDMHikrJvp9zamp7hsaC75XjK+J9RruUXR8o94V077vkeG8jv9k27CDNMyiSQgCsFRXr9BX3Zau4DyAaKu1Tl9RtPIz2cX7Ga+6ux11WTEhylM/R41PoG8Ct+16+1waP5gQY6St5xpUeOQj0KEmWxqz1ErsFRiXr34Rc00X3sXIqLlmv01iMUe6DKoAR4d6cKTbsEpJBNditUNN/8GCzG9UcyIegoxwNdHaUnp9FDNQxKX+8RTCopeVtpjzyI0gxhlVRc0B0CaNqKvNjecmPi64mj/4CyW3iVOr4EZ2oGgKA5vIZePe9psievovPn1KC5SC+VIiMs/Okuri
 NuREMgum
 grNSPBUlvgNXSA/v+QCjD74GvqsBa9xFB+rcMPi2VV9ZjalBPFgw3GdYMgEfPzMMRCRyrf9iU5WTGa8tGfe7B2hS/I6jGB7u0lEF0H+xk7e5Go4SUX+p4k8oBAPVZ7M0a+WvDNy/WIKbGmcjNTcF9xJ9sDEakp5zYCUM3SgLn7/PA8kiZ1QwVuwH8Y8IjHzhwWi1aO9uCp6it301wJDrw3SGithE+kpB0e9vNmvtwYscIAppmdgxMPFg96bGbOWB4nBxS9/49VlhJtZRLwbYm1xebrs10qt7/YI8i34KW8nk9NVyfAUdXO5AQDeF3pivup/A8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 04 Mar 2026 19:20:30 +0400 igor.b@beldev.am wrote:

> > I think pool->lock should prevent the bug you described from happening
> > and I don't think using xchg() is necessary when updating fields
> > protected by a spinlock.
> 
> Can you please explain how pool->lock protects pool->elements in e.g. 
> remove_element() function?

afaict all callers of add_element() and remove_element() hold
pool->lock.  mempool_exit() doesn't but presumably there are no
concurrent accessers at this time.

So yes, perhaps a more complete problem description is needed here.


