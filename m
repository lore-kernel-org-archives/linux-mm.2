Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A19C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F6C6B0096; Fri,  7 Aug 2026 03:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F846B0098; Fri,  7 Aug 2026 03:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9415D6B0099; Fri,  7 Aug 2026 03:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF276B0096
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:59:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C64B160365
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:59:06 +0000 (UTC)
X-FDA: 85073722692.10.DDC0C03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6ED652000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:59:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLWDOUMG;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786089544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbJ9IVpwycZnmQ+/PVsvEhvqqY3XRHwI92BLOJF6e6c=;
	b=cZPHe0GTn5jOTuiKga5+xjpkRwUkFh8AYfXuBoELxlYgaGk9C61m22GEdKc85z3McsojOw
	H3KH0yEH74GkE2u6lYphoveWy8yc1jN3f7y6RYbhrhJ20u9gxra/Q+EiNqoujlChbBDXL2
	di6V21xs0MF/YQACPCS4m0nvypnFHBM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLWDOUMG;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786089544;
	b=lz671JtX1GRbEbTBBwe0DDyvVsncv0Ug6F1o2tr52cvcEj7GUBjqyHz0s1RKz4SKvXseJN
	F2cLCJLXnAl8sJVFAuGgbTyL6fMbDD0cQdG5gMOMQhX9pk0t/Ef1Uq/B4yPOL6aSgF5UUg
	Tkp9i4PGB6eyqkTHKDXwHiF6fKO9/MA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09ACB42157;
	Fri,  7 Aug 2026 07:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29271F000E9;
	Fri,  7 Aug 2026 07:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786089542;
	bh=NbJ9IVpwycZnmQ+/PVsvEhvqqY3XRHwI92BLOJF6e6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oLWDOUMGHncsHIjQEsJMJR95AovO72eNAZUuqaxIGDeDFzVcKIigaGDzQbfglRwpI
	 X+4BqK5mJUlvQB0Q3LYFZL3x3/BN7P7Lb+bSEQARTSqJTxyl75cM/mHp2RCGrlQY3e
	 SovjrIgCPIWkB/6Sp06qJBLvhzx6Z7uyFC+EkaNWOw+AwmY5vExfyP7gnQ/KoQ27VY
	 w90YNJfp6BMXuT8y1KUIXA98bgkeM1vV1D0yeoE93z6x4kbvz9VKo/3soeEDfWq7Z0
	 8TIMK3Pf69bE40NbCf73s1bH0DFS1h79zi/CmnskhUR+dmjSoTNikbL0Dc14+jg4KI
	 jnUgD+BTDdQDw==
Date: Fri, 7 Aug 2026 08:58:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sparkhuang <huangshaobo3@xiaomi.com>, akpm@linux-foundation.org, 
	bsegall@google.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com, kees@kernel.org, 
	kprateek.nayak@amd.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, ryabinin.a.a@gmail.com, 
	stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org, vincent.guittot@linaro.org, 
	vschneid@redhat.com
Subject: Re: [PATCH] fork: reset pointer tag of vmapped thread stack before
 vfree
Message-ID: <anWQIwKDHj-8SXO0@lucifer>
References: <anSVlVpUXrA8ra_z@lucifer>
 <20260807065351.93659-1-huangshaobo3@xiaomi.com>
 <anWPTt4DE-Q8PKry@lucifer>
 <15a1b3e5-825b-4ffc-9349-de771cbde7fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15a1b3e5-825b-4ffc-9349-de771cbde7fa@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6ED652000A
X-Stat-Signature: prig18z39uyo4hgtycx6jtnk5ibobkqr
X-HE-Tag: 1786089544-624912
X-HE-Meta: U2FsdGVkX1+Etc5K6y2y8sjH4IOAs4ecV9x+PH88gSesU3sx67EaLJXgu2f/GjqxxiY2PMzNUrZAcb6RCh6dXs8xqUpUu2BWMjobchq7eev0Ra7J6AZbHmf1zynZnB+uP8G3EJz8GhURElhj61dBXr1iFW1Sg3cBcakSBqjbjB3jKZDs6iNGJi0uXiPOO3Vdaoh+7TYZrR6hWM2zpOHvzssN+iucsBecdV0r7JjkkO7bbShkbjcrnKkll8bhDzg3JV5AIaeJyzmL/DHJb4c6t2/z+WAEHBzJrupYnJkHhKYa3XQcfiMjH1R3CJPpUJvshzbWaAna7V7XVp7wq3NBVFyDXmib8xCMVNw275gGVxNz7OR4zBvv01f3wqyfcxI1fAHYvfBGw5Q30HqG45UiMUL0y/xce6fOR3FfwtuYOVArvFDo2PnrkryHDCD/jukqyovg1mgIl9yOFz4zmWG6UBZoVzZvwsNZrs7pzWHzE8keaISm5RoWH5eGYNSBYOR8Biry0KbO0ibyDXFnE05Eu1sQ44FeXeZbOatNNj+PcpgEokYZRq5e6i4ASHJLt+UbK1/lF6DtoUtw+2nN9U4qPZpnGsRJufmpbODCVsBvI/Uq029BXmOZyH2Isfk90dht3/ONxAUpH0jNYLiSzLDv2HnzOV8tepR+7Xc+kchNEavfRKqpRmVe8ItAHJbxrTvZ5y4gFBUXqZaWHeh+kUPcQU8K+xK1UZNPCX1XYHbQNPnRmwHFfLDZgKDEJsQ/EZOA7OWx1cS2Yumsmug8QapRni+MYpqf8A1eNrQXKBNW8X2Qoyz76cBQBVXi1w0eCnGism9wkzUV/AyWhw9NL8dlh2cPzYmqBmUJkTrXra+gWRMRGj+90G7wb2FVvHhSLulJ8NcVSHAtqSIdOEx80jWniPxu7ifEzFl6hMd+vvaGQzrAuja+6PmTnLdWm0aKWJtGyfRgaLcKHG1kWd1kI8U
 VH7o4GEn
 snqgo+aeLn73NGPlkNbcWb9T2ZBLgePOpAwm03H6fHm5ClW0I+7ELTIINAaAGXGEEV6bMyzeDoYPzGHU+wD/DwIizxK4UkYvTd7gUYdT1CRypTW3LfVh9o3MmOM6LYYfOstyXoAQmz6tARyppWuLC5M+EMRed66xOxa9V+gpqXhQZYHMWr2/O4SA478/2eo2vytCUH06aXB/S5pUXPhGaB3cHVZXW2ihAJ9WcReh7xZ86k1/NuIv+rVIALgcrvxjOBT8b1TRHv9/FbqXnLjoTMbbFkHHJ93O8R2j9JOLK1r6D+xjCR3hQnd0qbQe8nC1SaS2DfRLkmMgnf+V+Wb7a33qDEQqBdzjm7CEg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 09:57:30AM +0200, David Hildenbrand (Arm) wrote:
> On 8/7/26 09:56, Lorenzo Stoakes (ARM) wrote:
> > I'm sorry that whole reply is more AI slop and I'm not reading it.
> >
> > I have zero interest in chatting to an LLM via a middle man.
>
> I think we should start charging a workslop fee of, say 100$ per patch? :)

I don't get out of bed for less than $1,000 ;)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

