Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09956C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FA76B0088; Fri,  7 Aug 2026 03:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0496B0096; Fri,  7 Aug 2026 03:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF956B0098; Fri,  7 Aug 2026 03:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA01E6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:57:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A1ED1C0502
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:57:43 +0000 (UTC)
X-FDA: 85073719206.08.B469072
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id A55DC20002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:57:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJ6TWz41;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786089461;
	b=kzdXfBaqZ7DvvX2oRB5AEYp87kQ27PDSRqwv+s97/m20gQJOPg6sCT4FUHuOuW6VerVsJh
	QdVxhASTmDywdrOYUBJBukBz1uY0RHXk3gsWgKOdgiXxykGzimYgoK3y3k/BsC2ExDWCqX
	iCZeUzDxTEkPWLg7w4b5htJI7WQjwfU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJ6TWz41;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786089461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6G2Tr8SMdJfgzQZc1aTtam63RipacEJ6N+zzWCNRX5M=;
	b=GsvvWwSQBOVJHCJxl7STKj0O860TMwyQfZV4QT0oyf8dPg7OoQ/8avCEYLZtFzNnKsyeKI
	MnjmPeMK5FPvor5AHLjHd443QSb7/yh3injyaHXDEIQ0vTpVk7RbgSPRBwNSS8CdoHk/gj
	GMJs7yc/bvEaoOXw0JO0uSWvlDOJ5BE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD0DC60DB7;
	Fri,  7 Aug 2026 07:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F631F000E9;
	Fri,  7 Aug 2026 07:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786089460;
	bh=6G2Tr8SMdJfgzQZc1aTtam63RipacEJ6N+zzWCNRX5M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AJ6TWz4154ZXcycFkjsMSq0PWvEXiXCutQPTRAcbWVbhAiVCSDFQtXFgISPYQjhn3
	 tVjkZCe2v2gO9DJeY3B8gy4cCCCrTO2pOLin4DUZicZ5VKLVKjmTjSUSmTUQzewi10
	 Uew5GJQv3pq9wFX4go1LgWSrDovGLRgdaCEutVnWQB4Lj3GC1Tcd9D1TZEuMC1goQq
	 x2OidjZ2HepYGnL4l0uPlPFdyWYFusWSovmBL/gMgRkZx6eSsudQGDGInE6F1Vt/eZ
	 OAPlQM6MNeRbBXTDQxyLejR3PSMLZsxYxmyNOhfbRCnoaCyYekIzzBGdH5jXDISv8w
	 1W85IgPSZQzmQ==
Message-ID: <15a1b3e5-825b-4ffc-9349-de771cbde7fa@kernel.org>
Date: Fri, 7 Aug 2026 09:57:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fork: reset pointer tag of vmapped thread stack before
 vfree
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 sparkhuang <huangshaobo3@xiaomi.com>
Cc: akpm@linux-foundation.org, bsegall@google.com, dietmar.eggemann@arm.com,
 juri.lelli@redhat.com, kees@kernel.org, kprateek.nayak@amd.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, peterz@infradead.org,
 rostedt@goodmis.org, rppt@kernel.org, ryabinin.a.a@gmail.com,
 stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org,
 vincent.guittot@linaro.org, vschneid@redhat.com
References: <anSVlVpUXrA8ra_z@lucifer>
 <20260807065351.93659-1-huangshaobo3@xiaomi.com> <anWPTt4DE-Q8PKry@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anWPTt4DE-Q8PKry@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A55DC20002
X-Stat-Signature: e3bdbzmrz9ahmzrrbzspn8xexos57xco
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786089461-363896
X-HE-Meta: U2FsdGVkX19n9O3+eRcM2okqf1rzcNYbH9iUcchvuOze6c7Tk6oiKH5RYOFCoonyL8peLEdEhBfk3LrPIUvIM8e1qE5vMoH41BslQPuCvqAz/lV9FjjDzk251FjOL+2/Lq6iXS2Zel/kYiPTAQiCnPeWmGsVx7TShT5a/HfMJgYSS2ETwkWrGO1nDyFdZcnX5C4UJXmunu87Nhi6JwfNXOhph43GZ/9Cil5sPe21S5UKIiBYPy0UI88aWniopehDw7LeLXzAsQj0HvfOZUJNOEFnQRAcxJIi08T5FHyGrEJKXcjq5TLcDiB7wIUZiVE6MXPCzzWLVdxvM88gj9CgY6GedAJj+F2Ez241XdhR9F+jwLByjr39Kghz7UdmiTikwZQj6kXBXBwsij+lNjYD7KvP2KsT1wHzgnKlILfdBp8Ft4QQeNvu2Q8EJYPVGsGnXMs2JMTgck92KYkoo08R6D9u9U3r0XdoBUygyuqM5kM0EV51ILWh1kAhGmFDBuTQazR5cmZet45N+vKA5mTSQO0twIivfTfa/fXdHmPakSEg9guESDaa8p9kbkHFWg1/AgnDu1/GqA5BpXWW/JjtHtA2znTZSBjb/+Rk47qIUOnGymcVtvZlZm+sajC+CQ1sjpxSSDLVjJSUT3F4jUqZVJXd2k8Iur7j6cQbiANuGjwmwgJOjwkK5Sa57/9PzYt5BdlOP3/nNe8d+RC1ycR3uqNrmrY7ww9VgXbhjhlelMxHAOfVnEtJ+B6OJxdVwHOdCxUz//cGbS/0pCfivDLWE7RRbT7uTSpokxcXwn4bU+uiGZI4jRyMEiLUZLjLsI4WlOchQl1VfZEvvPS+PKcRd0xs81W7RuGSRmNb0U3UOqEO59Q2OJEDbg3qy6tLuSUDTv6PxOBmvElqpwyFJ+exJbg+XmoP5ELrFDatrzdUCi/ZlJxdFtuMIyTBb0N8Ty/OqENa47+MePrIITnSkRm
 WsivSfon
 bWLq+mNyP4rNRSP6WToPdpD6lk0QQzY/B9XDtz3bZ30BI2JUJlKIbG3osRulrRKf93eWiERcH5yVBBTHJBOPzbLteORGuxltT2r6soFuyb5H7F0UI3m25/ePn94oLxrVYF6hy/x7I+7796etXNSBTAc5bTYmpWuWTw9/Na6Cmn4deMMQPyueQAtfz2wKpbSk1Cozb9j1Aj3cmazJNUtzRjxDZc6yZtHZ3JcACl68HkxMdpLxsMj4YYeBOOGIcRg9EmlfVkaWeqcce4vpKhrDaLGPqFw42wGYhsF7Y3NFf7dX6cF4bLA8aLeknfbwbgwQV/HlOUMt5H8mahBVMTsxUig1YT1650Z2Dm4vBdeW9th2m4mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 09:56, Lorenzo Stoakes (ARM) wrote:
> I'm sorry that whole reply is more AI slop and I'm not reading it.
> 
> I have zero interest in chatting to an LLM via a middle man.

I think we should start charging a workslop fee of, say 100$ per patch? :)

-- 
Cheers,

David

