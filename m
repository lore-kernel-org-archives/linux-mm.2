Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE711D339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE8E6B01AA; Fri,  5 Dec 2025 13:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77EE76B01AB; Fri,  5 Dec 2025 13:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695026B01AE; Fri,  5 Dec 2025 13:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 51F026B01AA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:20:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07700B7B6E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:20:04 +0000 (UTC)
X-FDA: 84186231528.04.8ABADDB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 417C3140014
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:20:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IkWGNHpi;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958802; a=rsa-sha256;
	cv=none;
	b=7/sQi8u6uYgPTTjmsdL9fY+sBag8MckOAMupIh7zFOgU7kd7eFdZoaK/ifrPQmN0/EvPLA
	ny/eIBCScJ3UfxaROihA4qcXp3hWAiSRLUoqq3/cxA2PUlOw6e8wz2DK0daFUTXnL2JVNU
	ybcjtNDosOHmxuSqAwqXDFJu6a6tJnI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IkWGNHpi;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TB5O1IivxgT40PMCiat1nUPFv7ewjxHUnFbq0ckScDM=;
	b=CbEx51r1pX/WI3XKRXlAr70UcWSVGaQwNtDj7RWQpdSb9uOvZD9sudbp1slccew1vBLojm
	1LE50QeFU18fNe2+5U83NWMhr36WcWcDwzL+ePAQE9KPqSLjdVVAcagnU0dCFDFMRAhe9x
	TKFVOkYDW+w0fiw7ZCd3Kg1pkn0321U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72FBA60010;
	Fri,  5 Dec 2025 18:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E392C4CEF1;
	Fri,  5 Dec 2025 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764958801;
	bh=uWu59OOnukX41sFdZObKv7Syg27XPL0QGtwNOMvGJSE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IkWGNHpiezZQcCDCyS+Jz9xPdN6j423fwolXLjv6Qzs/t5OXs4LjIdSkioy/9nAlE
	 3g8bFq8XAuinz65X0BHEHz7pVBa/y0ERbNIx2ACo9u6Hy8Priz1AeMs73MvNc2ygol
	 HqjASwbYLerygzx50pzCxEeP4KgUbI1x+Zvhpajk=
Date: Fri, 5 Dec 2025 10:19:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, masahiroy@kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert
 "mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb"
Message-Id: <20251205101959.b9e89f4416e90d54646c2f63@linux-foundation.org>
In-Reply-To: <057ff845-6ab3-46a2-82df-067c25bef56e@kernel.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
	<20251204135746.6d291cc861b4507b1fe95aaa@linux-foundation.org>
	<aTKDRF2sMdM_5aRB@kernel.org>
	<dc22e2e2-a62b-4b9f-9fb0-f3a42a57b00f@kernel.org>
	<057ff845-6ab3-46a2-82df-067c25bef56e@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 417C3140014
X-Stat-Signature: 7bz5gjjcbb69hngp3t7nxt11xw31j31z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764958802-51954
X-HE-Meta: U2FsdGVkX1+xdDs7m6lSecxyeDPaqICwVzhZqs+dMr5vxnRUosU/LLBD/1VSk1Jon+Hd4nAvzaFmhwiJIpMpKSpkffeZbwtsxslQqT65V6hWTsQ/nMwV9KIah48f+h1AYK+rhnqM2RIcoz/ndmPFpkoSVIVeYRejHNtJIoN6o/VckBO/aQcqj8H6LvnS6Rn/sm70cqCyUSWfQiI9DxL9CG6WyN/+2FzO421AreY8HwEPF/jFzWka39+6IUhyJGjFBuUJ8zgwZQGzjE9eHEAewJJSvKH48915Fv5QeW9x5HteQZ+plWXLQGwF0ic8le3cX70D2GyeqVH/Xom1z6TIJNZj/XxtCoOtPPWnhdxPE2NaDTNiVHMwMfRatcImBH2NPFSoMJrdjb4EWCE6Z5X9+TjT2hk1X6EILdjJ8xEr4az4gDjraf4a9tKLgWRyOBD6zvvY+/0heXbpy3R+F3vYeONX+cVDaPEFlXRxVTVMiQhIVlhJzOOo3RFB4t1jdKDgP6pygAXei2uilzcByLnLaJnef9c+ysgIRq9ryeUhpK4JV7keByj2u8pCymrNTaizf2J30akpg90I1mAjpkui61EY6GOnLP1RUNSdgU2Rxc1YNgDSRH1aXiZ3LgmGDn5omHlKr6fZkpqHg8lcOl7ow2vyib+iaanU5GyIXlCusuW9AOWOelLQMMOqh86Xf/bNqJQg8+UFSPbBmSpZCKQCfvDxBAjCcdUDEcMrI6kNESyfPjs1hv781hmvl3V0FR3y6NnBa/HwFo7HOky/a8dmFTP5h/xcaI+tpHiYcqZr72VkPUwgqFsMz/ozbB6P8hlNiHP8IgDNWdo/asRANe75/K/QO5HJQs7T7e0M1AGMmffDMp6yUo6nYg1an+U5fjFNflF/c1KYPgyf3TC8BwB+EOrH6gGAPHOQ3sN9TcXwfWzm0jPRm3vaTOWFHT5YZTw1E7T2OXyR3iukJL7GRVy
 3WBaV5SL
 HOz9PyMKxN8xBsrSmfq9n7yD2WOJa9BKwy5N6AcX07tIqF9zeI9kQhQPQuPToE+Wom9yEOPc+7GtPRLk7vdvUsUHSzmYVWJ5rocqJ87u1RhkBy2GTE8hVh6IbBedjSL/Cm9nbV7jdpE1aK0IkW2lgUZuI+2GIsyvAqHI5bmnUX4SlMWk9H2Fn6ChVUi2dcsUG5aEN1+IPwEhKv6BTy4jBStvZihQxs91+ACHhU4JRpP0JtPGXqB3nNPmVb3hPcUa49hXTHPpcqvw+mH2xhD9g/P3TdTS3S+VNiuuJOQZSa0prCx1T/4Z6CHWQO4IkSQ+J08dr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Dec 2025 08:41:07 +0100 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org> wrote:

> > Thinking about reverting arbitrary commits after Shuah clearly tested 
> > something wrong is completely unreasonable.
> > 
> 
> That irrelevant revert has already been applied on mm-hotfixes-unstable, 
> see https://lore.kernel.org/all/20251204215938.750D3C4CEFB@smtp.kernel.org/
> 
> Andrew, could you please drop it ?

I already disabled it - it never made it into linux-next.

