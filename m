Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C404D606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6BSORoo
Received: by kanga.kvack.org (Postfix)
	id BA1CD6B00EF; Fri, 20 Nov 2026 04:29:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B529F6B05B0; Fri, 20 Nov 2026 04:29:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D796B05B1; Fri, 20 Nov 2026 04:29:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7849A6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:29:27 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDC77120DF5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:29:26 +0000 (UTC)
X-FDA: 85454974332.27.795313E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 40052160007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:29:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6BSORoo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795166965;
	b=IWGMc29BMJKAlszqJNCxbLBSbUzc8r14dYTpYT3Qmef3lHYbf7pKPGYb/NBTLVBR9O8BEt
	mWQtwIgLagNoqvNC63YR+q/HlSmBet9AHgf68Bhe/qLHNINDX7sdwqb6gfChr752WGwqEJ
	xJ7UoSCA118LCb5+d22R/BEmPSXQGeI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795166965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xt2wVuk2J+BOzbjJqVl0VPYFzZDBC5TyFmMj5npkcc8=;
	b=K29+oM9X10tyuY5NteetHCtjO2SdXRe2801+0rNSavWs15ICbEqhxK6//AtLfJi95cOhc/
	hjNkXOK2LNi55Fp7Hideohr7ETbrKstyiDoJMZJotLgYm8XUI2FcRKGrxOhAf4vpRgCZHp
	uXasThS7fFtiQOppqH8dUzHN71AUWDg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6BSORoo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0E8B61841;
	Fri, 20 Nov 2026 09:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335A11F000C6;
	Fri, 20 Nov 2026 09:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795166964;
	bh=xt2wVuk2J+BOzbjJqVl0VPYFzZDBC5TyFmMj5npkcc8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q6BSORooUGzpTPM5Q4NEFHTC5JyU+GbUWPZXmnhH+gAIlJaGTUG2MHt6MFzHyf0gx
	 LLvJ+iyH9ElIWhnok2ziI4hxEdLYvzYgM9zJwLMNGX68wb7Y56mH2oxDypypEraNQt
	 kr/ittiMa13icSUfq9kluZZiggRs/sR1K0ISRd6z/+wzdZWUsZ6wERKMERpxrJAlrD
	 T69RGNhdEhSl0D6wAR3k2nTt0r9AhL6gRWu571KnZ5mFoXcii8e/yUC/k4B5K8L61e
	 9tiGnVo0lX2mF/x5mHyWVfRuW0FVayzHcOVXIgcG8KFIsjRpw4BLDMPi5gyCw2+dsH
	 QCAfWrQUNOPaA==
Message-ID: <92ecb061-22c5-44c1-a526-53e592911f33@kernel.org>
Date: Fri, 20 Nov 2026 10:29:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>,
 Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
 <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 kernel-team@meta.com
References: <20261104130118.2507513-2-kas@kernel.org>
 <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org>
 <au2lsbDkyWt-To0C@thinkstation>
 <aa2a1e32-9b1d-4545-b2e0-03d213593023@kernel.org>
 <CAHk-=whnH5qLJH3Wd3bOxv--Ei6674Jo4iifGD_MqzyJg2Jm4g@mail.gmail.com>
 <8504e28f-faeb-41e3-842e-0cb74d1a25ad@kernel.org>
 <CAHk-=wihE=ioLKrwzz=WQSJg6HhB-syu4hqZ2QFwgnwYmmLEgg@mail.gmail.com>
 <f39a0ec3-be81-43f0-91e8-145ec139b1bc@kernel.org>
 <avWv-0LafPyo90ln@thinkstation>
 <fa90c536-3b3a-417e-a09f-011a12e73048@kernel.org>
 <avcbg96XgusgAlfS@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avcbg96XgusgAlfS@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40052160007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: sjzsgobrba7x8gz1ce1u6ndxuqddodew
X-Rspam-User:
X-HE-Tag: 1795166965-422957
X-HE-Meta: U2FsdGVkX18H980ZmxlqkOevZ3m4wIMhCjNyijSFYBBUXh90M4hqy2zTbJxL1QzVEkqKOZalnJrS9CpOZ74r/uxcQkDZB/6zjuvGuasjX8LyfBlBqgq156GOOTi9L1D+KLvxyiJH3i7blDa0Nqb6xw+krf76zDbnyGfOsmi8QrCMG3gB/I5TMftRoeszQbihQ5GGFxF1O1e8NH0H06G/yXtkNSUNIO9z4OWW+8NVCqD5SJ0BPy0DgILwBK2kmp0u42vRuwtAv/xvak6lx4bIjOfDgbKdFLl8Y+NqEamSahGEeCsmWRONBfdcDQ28ru+eI6Sp/HKJnX28YAb/6no8YgV3JwxAUyccEYVsP8tdnmWPD3ojdWYin5geXYl+gX0ovo8ZPQ2ibGaLoDZ0k2T8hElMvZ54oMi8r7eXeyEqkmbyF/wu/6EY+7i/30anR/nElVizCYHjV5xUKcqWgdZzcj4Fx+FID/wqa+XrAAwEDLpzgBFlMv3nHI5zKaX4rvGBHASEsILrxo55KDAjIJ2sbUm/raDPhg88O2NEjvpHH93TNuzigHKyvGDW6VybXsOvWCwPWLxqmc7Vop6Ozdb3rKxcGcLPCBiibkdgCFFeihOENhdgk0XiXljh877d8pXFLPQFvUhb5rX7LokyrJw+2cxrMLHzLLKpHOS/xuq1yGu11bq8nwQRpRxZ56xEQZYDKpJqZF29BWCDn+XWtysiKzjU0XPPbCxc2tLm6hkm+wWi0xY3WhYVWmM16mRiMeMH7kQ+CkieZxOyp8s5pg64zcyQyyiCT2VgncLo8sGH2lT0hnQgLClP/zkSYdLsin5ztqAy4upFe9lOdytVdH3Opy8S07Kb42viRv8u2aHbv3ccONkOQqg+BcHobfKL4aKJEl7+0xLynFehSLVi6qhYonts1q9B1asBgowPEDVFRVFNbU47djN62C44uBi7uPFDG8+V8RXclils2LH61fv
 tS8Gr/hp
 2v9LxlEPLUQJSIxtOoEXB1oaQ8Z+H7nNpiERjemieyBYawvhQZTF6oKlKdEEC5Gv9ZGWqJ5wEZDNEKzJqeVedvN2+G4YTzXGMqTpfowSPq3gx88DOHSEele55Q0kNpoW6DtAtaWtkVt9aG4VWD1YOfE8xsYbJogia6kRLmAWSMbWL6d2KZwugjXrbLRBX4Mq+dD4xuOJXdOAcpHbWEE1PPAA05Vtvgt61/ou3BTEUo5vcHtf/U0qi09xxTLJCvEPy6cNyhxZx8jkdj879q8y0/H2WrY+DW+fUPaApD+P+YYShWJBqZ+JtytkEvzVaigfp3VDciHSg5XqTO11mOJCX6gSJbhkbZOvTxwfThp6oUOeigmrAxjGOIly5nIkt6Wj4FyIIb6XwN5gFFkstQ2aotRjZOZBf7B96eTc+PC77LdnKzhJJAlW6defRy0Ipuze3nxeKCS3OXk+pVScTfJalZGdRfeJdAk5LmLKTOApb7CJz/25BJbNzLqHUfX++UmfLkSUOc0OJiDp4D/iRAhV6ZlcTU44wTtb4E3C7qN1e39zciBcYhPpMXzH1lwUUU0v5yuQ/mzBSRBTX4iFIePzKP5aDpZkX9HZXTaIB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 15:17, Kiryl Shutsemau wrote:
> On Thu, Nov 12, 2026 at 01:32:02PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/12/26 13:26, Kiryl Shutsemau wrote:
>>>
>>> Right: once the folio is allocated separately, the lockless read
>>> dereferences it too, so it has to wait for the grace period along with
>>> its pages.  The per-CPU batching and the waits in the allocator later
>>> in the series do not depend on where the check sits.
>>>
>>> Until then the folio is the struct page, and __free_pages_prepare() is
>>> the one place every page cache folio passes, so v3 keeps the check
>>> there. 
>>
>> If we go that way, don't make it effectively folio-centric in the
>> implementation. That's what triggered my response in the first place.
> 
> Is something like this what you mean?

I guess, so and not making this a pure folio flag.

... but I am not able to think clearly anymore, too many fixes :D

-- 
Cheers,

David

