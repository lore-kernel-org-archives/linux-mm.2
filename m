Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06805CDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9106B009F; Thu, 25 Jun 2026 05:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A076B00A1; Thu, 25 Jun 2026 05:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C902E6B00A2; Thu, 25 Jun 2026 05:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8DD6B009F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:06:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 230A612060D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:06:10 +0000 (UTC)
X-FDA: 84917853300.02.12C1414
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8167A14000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:06:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGUZR+Pm;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782378368;
	b=ZmDo09fEiNl8fHymHEYvzXS/e5A+92abC5FQgQyyeWf62fKV5ED/vpHPZyqdsXZgM+SEjv
	BVOVnl5xMqw39EOq2UP6qH+NibEcNjG/EW2NQQyjqL5tfoA7rqw9mXgGA81jXB4eUezzrr
	oicv5rc72Lj4+x9W/ymJiaZkBupa7YU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782378368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWgZuaM7iYZt7359X1HxJyqC3nPtLZFOpucffsH2wXI=;
	b=2LFSI0KDpFseNiEvENqmYECTI3dQ/hNXkpZN1RvhitbOR2XIoK4dJfmgOy6YFeOmt0S4PL
	jaaqHCpHHQI5Q7C3wSJFQB74F/XEnXmHUIYOc4dTwkhNgsMEYqUQVc2xS5BrdFnWTw/Yhv
	6O24xdoLEE/9JZ3+iNCWrdWll3C/SUc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGUZR+Pm;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7B664074E;
	Thu, 25 Jun 2026 09:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E7C1F000E9;
	Thu, 25 Jun 2026 09:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782378367;
	bh=uWgZuaM7iYZt7359X1HxJyqC3nPtLZFOpucffsH2wXI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gGUZR+Pmd8hdHISAqIzcRl3hmfPpYxddIlJxAJNelBq2PMgqY2bGB1gn/o1J8/fqV
	 59NTkSRahwRttvehSso/thYLDcRNzZ0lxVwSPidD/wrLyKMO3AoCHasO2KdSotcBeg
	 jmABSXee0C9aVIauoK4MnrnMKMz9PIuUq6JCszf7kJ0/Bc139fnYjtJEPpaogDQ9xP
	 akH1+4QL/VtY6QzrvheG2MDeI9AQogxcjv3pfxXgqfgywzhcCwqduFFXx+s4SuRwMZ
	 eoFP3Q4bTx8lYp46TKZj1t/9c/LrMpAj71JxXAMsCFoE2Nn2HAo2sf3H8YUwGIRbIw
	 /MUqeEuknHjeg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: viro@zeniv.linux.org.uk,  brauner@kernel.org,  jack@suse.cz,
  linux-fsdevel@vger.kernel.org,  pasha.tatashin@soleen.com,
  linux-kernel@vger.kernel.org,  rppt@kernel.org,  pratyush@kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 1/2] eventfd: luo: luo support for preserving eventfd
In-Reply-To: <20260625054946.73445-2-duanchenghao@kylinos.cn> (Chenghao Duan's
	message of "Thu, 25 Jun 2026 13:49:45 +0800")
References: <20260625054946.73445-1-duanchenghao@kylinos.cn>
	<20260625054946.73445-2-duanchenghao@kylinos.cn>
Date: Thu, 25 Jun 2026 11:06:04 +0200
Message-ID: <2vxzfr2bkn0j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: d3hrqum67hkusns99qk8pfk4auariete
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8167A14000A
X-HE-Tag: 1782378368-203129
X-HE-Meta: U2FsdGVkX1+IOl7hnKN6Mhjr/6wXDHW1gMaF12Y7Q9sS349KqQt2Mf1AMBwi/j81Jis4pB1uO/BjKaaPWXOzimyHz2WfsgJpSSws9wU0ZkUcthMoyb/M+Ps42j9rRDi21FQRNj6Y9guAOpB+KG+CjvX8VDF3Nsosfr6NUIo5mod8ptFOJZn+ctUekUdPGe76uc1p6yO3JsiFt6/7LjUtoQnsV/+53/ThPcTpyxgrKojPKSpMge288/kWn6494qox7R855ikgeQcICDZTDeWvutR3J4oFLuQRTss5mWn2+AIaaTelOpugcA5LH++CR4QzMespURC8M3itgQT9iy/v3BFlQg5UqTV8Tp1VO+ki06OL8qVvYa40hKMiOJmY3G7dcwXOLmnVOjwo5789cG2EDhga+tSpwjkbKkEpz2FDG/Mk6/qlK1zrt4n998sAikycHp11BzZsjOJmaCH8ZFupjP5txbDyijA98+QXandk+azmUPxXMK0HjsXHvYCP5kNQdSdgvvdf2PVPDBLwKGtGibZ2HEnWbwsWkygSDdJjveYYA97TU88X1LpehtA5nWtW+VpFsZV1i0CcRCos9c3b4miZyg1J/zrquksKsKZo54Yyui6hGG7mZAtxAFdwQHvfG0XXB/N/V6DsS03o5oa5KyJX5MHhd4ZsEAVrSQufBuZX/uF00eZi/oMRUeyoNUp2lbqkCJMymplckZEfCaSfJ7Q3TJeiyQomAriQfVkNq28SJAUmDS7TwjbJsKd4F7duKIdpbkRAaeQL4PriZOsz073tElm7X4pY2hp/6v0KI2r3LHNpZ8CJr3NqfEKbnxI6Cf46kL5mXGAYqLbE1VVIhcHLzX+BnO1xK7QemwnC6E5rgbzmY7ItztyA9xd3z/M6nNvV8IMaDrrL/K+LF3VAoVhAQj1PBpv6DodjvjljHuFjL75uUWNOhiTXYIHf1tU+gAGlb/9MP27ESImWfbV
 YS1SX+wa
 hBtnoMgliDqxBFVEq6/rIRfhKEBWrkZcHIQz685it66ssu0RHyiC3e1kCEZGQ+XzBInUgoCp8jZtTIZ+V3P7XBK1KFBlpap2dus219YYYLOKmSumtSmgJ22QGyMXhRoYu9r7EecaKh7L0FNQ6X6ZCQGjdzuZ9S49z6NsnHfaw/laS1ey69263Tcwog/Fy+4pOj0txHtTPs7SPOm+jkqxhdsdVpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25 2026, Chenghao Duan wrote:

> This patch adds support for preserving eventfd file descriptors across
> kexec live updates using the Live Update Orchestrator (LUO) framework.
> Userspace applications using eventfd for event notification can now
> maintain their state across kernel updates.
>
> Preserved State:
> The following properties of the eventfd are preserved across kexec:
> - Counter Value: The current 64-bit counter value, including any pending
>   events that have been signaled but not yet consumed by readers.
> - File Flags: The creation flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NONBLOCK)
>   are preserved.
>
> Non-Preserved State:
> - File Descriptor Number: The eventfd will be assigned a new fd number
>   in the target process after restore.
> - Wait Queue State: Any processes blocked on read() operations will be
>   woken up and need to re-establish their blocking state.
> - All other internal state is reset to default.
>
> Changes:
> - fs/eventfd.c: Add eventfd_luo_get_state() to safely read eventfd state
>   (count and flags), and eventfd_create() helper function.
> - fs/eventfd_luo.c: New file implementing LUO file operations:
>   preserve, freeze, unpreserve, retrieve, and finish callbacks.
> - include/linux/eventfd.h: Export new functions.
> - include/linux/kho/abi/eventfd.h: Define the ABI contract with
>   eventfd_luo_ser structure for serialization.

Why do you need to preserve this? Why don't you create a fresh one after
kexec? You just preserve the counter, which looks pretty much useless.
You can just as well open a new eventfd after kexec and set the counter
value if you care about it.

[...]

-- 
Regards,
Pratyush Yadav

