Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07D7606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 05:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jZBEJp8S
Received: by kanga.kvack.org (Postfix)
	id 714AB6B05B3; Fri,  6 Nov 2026 00:50:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED726B05B4; Fri,  6 Nov 2026 00:50:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F496B05B5; Fri,  6 Nov 2026 00:50:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC0F6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:50:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FF5AC0274
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:50:55 +0000 (UTC)
X-FDA: 85403620470.11.D71FF1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8ED4CA000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:50:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZBEJp8S;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793944253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkwduMqYAfdl/KfY8u0XGrj5UOL1s9uwI783UTJT08A=;
	b=NWRUlI4C0F8ht+IHJL0/Y34CiH/PHlYT7Y2vBIRzlB08ZPiXKiFW6mpiNIvEkEUWFqcN6w
	cbwX89q0pkm8DGtrLTGUyjtCJluCvKPM31fKVNoRzsmeVWojqCnAFGCoMal3NIP104v4fc
	3eI1xpLfyWrYAJnl2D5IEHe0cW8/Evo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793944253;
	b=T3WfB9m3Sh7pbSd0A2CQNvJgan20JxCjs3MUF0VoNwpRctbcNhUs/P9U36flQYQuyM4ggv
	ZINE5rmhixVMxGxOVcrEiJDUDkMCFee4oMt4Bf6cExhe/xntJqkV2+AvkMFsuypXbjndpy
	wr3d8coP6GbJileVMgRWtDvLDu+TyPw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZBEJp8S;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33D6960215;
	Fri,  6 Nov 2026 05:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EF01F0089F;
	Fri,  6 Nov 2026 05:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793944251;
	bh=vkwduMqYAfdl/KfY8u0XGrj5UOL1s9uwI783UTJT08A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jZBEJp8Se8g0VR3BMOOsKQtTVxEIf2NFDuWpyMLHOJ4vGIK8goi4b9D6rZvYe5hLj
	 XltKVv3P8zfDRQk2qnEPO0rBcnYOovctdU1/zwewB/qF8iRd/Guyoj4WKOT3jTfVJc
	 y8BJvUMAShufXs5FgNC780uJlG7h5wx4DVL3ZzN3Hsa4LQdrYChEjukuKNLNban7/1
	 PNrYAuE378GXIMExAUJvSrBuSpVk5wcdLAVnDIodD8UskiyvHUzuaUwV9M41twCJX1
	 CJJYPHcB0SCGD+qbxz+nqVuAqbaCqUhHPKIfwlUSNxE8kjuXWE3JIPU51WWQ05uwCG
	 tHx2XTBqcRPUg==
Date: Fri, 6 Nov 2026 06:50:45 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 3/4] mm: hugetlb: fix GFP mask propagation to CMA
Message-ID: <au1qtSMDpimURGuq@localhost.localdomain>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
 <auxTwrKCeg7a3hfY@localhost.localdomain>
 <1535887c-6be2-4415-b54e-2008e6e7a35c@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535887c-6be2-4415-b54e-2008e6e7a35c@linux.dev>
X-Rspamd-Server: rspam06
X-Stat-Signature: kf7c9xgeywns4r8371qh4xc75qijmxrx
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8ED4CA000B
X-Rspam-User: 
X-HE-Tag: 1793944253-736742
X-HE-Meta: U2FsdGVkX18dwG8mNVQ5vd6VnV9tGEALnj/6u/IBxgXoWKA2vjYJjYFdJ5BFpwJJJZhR2DMWr/NfNPXCYbbinZgaYS8d0IFPNVq22BA3LAQh9RsFpzaIw/7ono1naqSR2CgNOz0grVB9T0PryDgKLxmdSBtMIttdc8DcFPX7ieRPtlJ7enJKGliHb/AwLImKKPVpgDf0xxqXkVBSlHFjgptnOxQq6y7oKV/8kaKPptRsXw9HYHeX/2Ud7UDiWtoSKV97E30XLHjl1ykQkW/YjtDt6KndsWg80ajrClRi4Gjn1/MC8y/Xy6C5HwA74YvkZACw79uWrTfQLcovmILi9FXZrNHyCl6Aj0uC7oe1jHk1xaZaaxf5MTYsEQCN7G/2b2xhXbRL5LF0vhh+74Mgy6BEqxGq3KrssLIzhWp/xzLjBwy3x7w0rLisROHkcZkunNAGrdOzJBP8gF8YtE4WIAz7GaCH/cSYFojHe9TJVRpi4qEs+HQZ0C4UyJVH3KTaYwK00KuOFAqfV9xbTcZPM1mc1elbKI2PeyBdMWKpZMMR2DeYFsfF4Y5L7vt+KaodHpX0R7pE61Pi8fGCGUaIPOFr7iBll8BGQFCwWZRfz0UE1vXNpkRO+AKEiTz+w2cOTVceZebjFTAUeClvppw2CR+y6WaFr+19g7q1UDDAWz+uIGJDn0pZB7uWSQ8Cku6vRIwKLTPorMIMMa7T510fS0sqjGIw1GUtiaiz9dvs2yWOr26z+lWx0/ijlf6rFfMmrvyXPoTM8P5O+8SIpyoQYo1I30/Tgw8eE+7ECeYpQPHB4Ya8stIDZi+FbYXoOoCjFIqxF6QKCH6uUTvHL84BRlmyh7QmbDjBTfUb94S+DjwIuSXmK3wxFF1v6n0JCo8jEfe/UXwyq5LWasgLkqgJAg2enSqiRa4MJPQNhG+Qs2UQEBP6XTpZHMq7tfaCNi0X/0o4+bhHFFJrnlsfykr
 9kaSG8d6
 PIffdIo5NebLl26PESp5o8gHQjs7K9jugrrlrtCNWyppDvKCDxQyp7IFvYjyiiTcIz1OZMX8h4DqMmmycZ1hbejg8vj3J1FxzeP67U1PjEcQPGV0p2uoG0bjBE7sPcXe7Y7a/3m+NMjctc837A0rVUND8J85zrrLhTI4OD2peV3vwVZhtuEHk4D4dyJ9s1BsDrYRUaumb5M+z3imN8wxQ1tEW8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:43:53AM +0800, Qi Zheng wrote:
> I'd still prefer to keep __GFP_COMP so that
> cma_alloc_frozen_compound() itself guarantees compound allocation,
> without requiring callers to supply the flag.

Well, but aren't all callers hugetlb? And we already do supply __GFP_COMP there
for evident reasons.
And should that not be the case, and you want to catch someone who went rogue,
I would just place a WARN_ON_ONCE to catch it here, so we know who is not following
the rules.

Makes sense?
 

-- 
Oscar Salvador
SUSE Labs

