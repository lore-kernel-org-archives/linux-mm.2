Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CBE8F46C76
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 19:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6DC6B0005; Mon,  6 Apr 2026 15:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67326B0088; Mon,  6 Apr 2026 15:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D0D6B0089; Mon,  6 Apr 2026 15:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8698E6B0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:16:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71BEB1B8372
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:16:06 +0000 (UTC)
X-FDA: 84629086332.01.6490783
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A8B32C0007
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:16:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="i1zGF7/s";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775502964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lMzqJHprahTOpy9CHnlrkWwJ+Vs75Vcnnlup22qKYQ=;
	b=vqWwv/3pbdt+LGH95j8ZcgQveB2gaH9BPQQcB0Yk6jr++Xs4UIJx+NnOpFgwATqNqioDzD
	0D1iNzxWmH8vArSp3cZ45zwKu3uJ+/+luuXuu5CXyGdy16nR7u7T1lFET0T1mIWIL261Us
	eNa75gf45GHpKI5jenCIaqQQb11pry0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775502964; a=rsa-sha256;
	cv=none;
	b=4C4VGszC1tHDnRUB8YwOo8DIMZE14WvHGCxXcgu3yBYV+7SToBMCpfvpWrmSwQ5As79QQK
	u+D3DSsmPj8k0Vas1E6h01LU4aeKoz1vnlLOLPN9K9ncvQ2lWKHLQX5zx+1hOi69TcyM4a
	3xIY2Qeyy5r9JYLylzkgWPA/FM3+e5A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="i1zGF7/s";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C347407B6;
	Mon,  6 Apr 2026 19:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EC6C4CEF7;
	Mon,  6 Apr 2026 19:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775502963;
	bh=QFs5zbLdbLvzwCzJF46KTmdJhGKCTNp3PQe/c6FVWuk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i1zGF7/sXDGh16efrnNHdWmhZTD0x2pFwIZOavKSuFz2N2xtPiz89vS+Sy1zhba7b
	 FEnT9pU71iW1MyZNNXcGc+cGkz+XnfIw0RzpAiskj7GY1Gg75WAsOQ82daAXmiW+Cc
	 aCbidToP7gn37uvs/LYVIM08JTBfpfHPMoaPEVSs=
Date: Mon, 6 Apr 2026 12:16:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, hannes@cmpxchg.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, riel@surriel.com, kuba@kernel.org, edumazet@google.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3] mm/vmpressure: skip socket pressure for costly order
 reclaim
Message-Id: <20260406121601.0f4f3a6886098371e40d6711@linux-foundation.org>
In-Reply-To: <6a41259c-bf69-49d5-9cba-80a5feb8ee8a@linux.dev>
References: <20260406174425.61692-1-jp.kobryn@linux.dev>
	<20260406105417.28fda9587146a011af2fb876@linux-foundation.org>
	<6a41259c-bf69-49d5-9cba-80a5feb8ee8a@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A8B32C0007
X-Stat-Signature: k86e335tqzcawb4xqe7q4m3adhqasm35
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775502964-754166
X-HE-Meta: U2FsdGVkX18PLl6Q9FQbe/WAtGkQKrtFffzFlFnZsw65xhADU0K3mUUfUpkrElj7EzmhYX45dh1xEc9XsRC1u0l0scTDYb30vU/POvlTTtrtgbN/svQ93mmZsgYaq9dA8HZWVE+mEke5QWsXx8ooTZ0yWPMyn+EYnWJyefxAlH8y3QY2JP7Z1kQVts/aqRZurauDmxCoGTeUJZgu2FhDg+H6IPDcaYgdM+sD1rIrGZHFecjUEMx/eLt7Xewvso9lgHV1vWVIlrgVALfT7Rmbl+EHjz9xTnE8YGLy44AHdIbWo6nmZn7/HMC+f6ARVLuBZDSFwlU3iLeIv8nS6JPYQICZDs4ueBYQ0q2cCvJUG62igQZ5Ty+mai6Af+3TREK3YZ4nIrBQ28Wv+y3Kp9H+iA9EfzoH+M26SBLtfwmKhrO7wSh1DvTmIvssC+zfABZ3tEfu9HtH+hvu6tBoBqoXQwALUs0a0QZYY5AzO9fbklrrLc6oGXtVMt73Z96o6iS8P9Ds9G9xnukNnFhYAYKhTeN7TWWVWm98WiPjmKILjThiNWdPpD7LIPNs/WcJcIPnrhAUKmHnwR8DcHhfgfCBMJid/m6mCIpN9fvSg8hkXcCkK98Np5JV3BaaEfjOYRj18ROup4ooUV7RY4M0/8Ain5ROOAXvkrufjF2UDdmTzg8m9u8Li9ZDlK1IVylHJk4K8zd20LFSLhTJpU7SKKm1DORSytso0MsGb6QZHGz/sOeCRO0uw8oiCk4thV2w2cWy10kohhA1sgOI0zOV2ahRtPXdgy9nVodcRSnr1aj5yBJbOZ6aD+2Z1ZVyFrG5xXuR8kWwal0lJExzxeTlMpehzwiXEltjOl2X+8wxGtZXlTc9omyx6Ovy3EgV4Xham6Emy5BnjndUH1+H/VikeT5bGL+iFX150ovy/TsE9eFkgBNOFJ8tFQ6u8jUkyMjTdaBRHx1iN4VOqmaeTwdKSDk
 4dM1HdpY
 i4U4rc4Sx+LXMKyl0E7fdEGPWn3K+U57TRCegF2jv7YvoHWARPRDXmxMeJ/d2LAbJx39zDi+ftQ/sma0sZEWUP3A3jpk28uaOpnXsEHLwK8BQ4YKwphMaCqFVbHf+JvB8PZt2u0wZ+5MEcF82DIMJU46M1WZJRbkI2F8EoG1PGh6xo/ygXZhwLgJ+70wIVIhzG2ydPYEnkXElKrBM4j9OHyjRMSzR27rpgy2bqhP1bhKPyKS1R42xxz7+R2wwJYJX+L7t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Apr 2026 12:07:57 -0700 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:

> Let me know if this data helps, and if you'd like this added to the
> changelog.
> 
> On one affected host with impacted net throughput, the memory state at
> the time showed ~15GB available, zero cgroup pressure, and the following
> buddyinfo state:
> 
> Order FreePages
> 0:    133,970
> 1:    29,230
> 2:    17,351
> 3:    18,984
> 7+:   0
> 
> Using bpf, it was found that 94% of vmpressure calls on this host were
> from order-7 kswapd reclaim.
> 
> TCP minimum recv window is rcv_ssthresh:19712.
> 
> Before patch:
> 723 out of 3,843 (19%) TCP connections stuck at minimum recv window
> 
> After live-patching and ~30min elapsed:
> 0 out of 3,470 TCP connections stuck at minimum recv window

Well I'm impressed ;)

Yes please, it's a useful thing to include.  When people look at a
contribution, question #1 is "why should I spend time on this".  A
clear (and tasty) description of userspace benefit is the ideal way of
answering that.

