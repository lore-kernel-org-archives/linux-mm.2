Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E3FC61DB4
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B96A6B009E; Tue, 25 Aug 2026 06:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543B06B009F; Tue, 25 Aug 2026 06:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3E76B00A0; Tue, 25 Aug 2026 06:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 154FA6B009E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:13:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA7E5A0371
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:13:14 +0000 (UTC)
X-FDA: 85139379108.29.EA95EAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D4B48C0004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:13:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LzKXx9vJ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787652793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oc7gcRDbmLeElYFa1mxkM+TkNUeFFxrhZCG8ME+Ws9c=;
	b=UqNtwUhI3wLfMeKYWWK1TXy3Bka4XyLVL5cwkjK2ovpfAi5XTQQFxbhxKVrhmI3vFmHc0/
	X07/IKLQe1j6Lz773rKjo4vvhklcSmahEXlAhRdjRQjnMnfwrlvIxJZpwtkPVRRTrsXHPE
	BW0+Zxn7EZCR/Bwm+znEAJk2Bi1/gRU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787652793;
	b=OPrLKKJBxu55IVKVdui6784NXnuHXQP+zirDzX+KVLnIBwWV/XPn4hBBt07JAQy1zin3eB
	nr6iLLK4NdxYbuuRyY93hpSG+hhPh0midzPpbysTvhfUuC5oJ2LTecRxrvfw3wrLbUe3OR
	5QSiDiMRTBHMmCfe4cJ3gZWuBP/ghzM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LzKXx9vJ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2BE7403CB;
	Tue, 25 Aug 2026 10:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EBB1F000E9;
	Tue, 25 Aug 2026 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787652791;
	bh=oc7gcRDbmLeElYFa1mxkM+TkNUeFFxrhZCG8ME+Ws9c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LzKXx9vJwSlJcTzT3/alZIDwFBAL7Df+Z6kyUIdfsVhTXycAf+5iP0nEHvJkQn4RU
	 MKg2oB0u0ClV9drOSG50ZyHACzO6Dux+tDMpo3v3mz95X+h1qdM9d492cx7gozjS3b
	 PvGrS0E/EzYSeOC1rNKU/Pn2g2h6374GnLDw30zHAOHzb9eTYfXjAULmxbYSOxuu+a
	 XAwBDvuETjsAUukkXkrcuNufnGwheLM/rQn9tbQQf9wHgIGnE4CzElxJaxV4mUm1W5
	 wMYYEJadGq+zjC+XnbIubBOgId7dbcnY92eWIgBqExkFZGbsXM2sbHWO1EykTi4/Jq
	 MwZgZnU5A5YMw==
Message-ID: <6bc50779-1daa-4d1f-9374-ef784cd6fc0d@kernel.org>
Date: Tue, 25 Aug 2026 12:12:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 00/40] DEPT(DEPendency Tracker)
To: Matthew Wilcox <willy@infradead.org>, NeilBrown <neil@brown.name>
Cc: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org,
 max.byungchul.park@gmail.com, kernel_team@skhynix.com,
 torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com,
 peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
 rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
 daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com,
 tj@kernel.org, tytso@mit.edu, david@fromorbit.com, amir73il@gmail.com,
 gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
 akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
 hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
 jglisse@redhat.com, dennis@kernel.org, cl@linux.com, penberg@kernel.org,
 rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
 linux-block@vger.kernel.org, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
 hch@infradead.org, djwong@kernel.org, dri-devel@lists.freedesktop.org,
 rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
 hamohammed.sa@gmail.com, harry.yoo@oracle.com, chris.p.wilson@intel.com,
 gwan-gyeong.mun@intel.com, boqun.feng@gmail.com, longman@redhat.com,
 yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
 netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com,
 corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
 gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org,
 frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
 josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com,
 jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, chuck.lever@oracle.com,
 okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
 anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
 clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
 kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, broonie@kernel.org,
 kevin.brodsky@arm.com, dwmw@amazon.co.uk, shakeel.butt@linux.dev,
 ast@kernel.org, ziy@nvidia.com, yuzhao@google.com,
 baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
 joel.granados@kernel.org, richard.weiyang@gmail.com,
 geert+renesas@glider.be, tim.c.chen@linux.intel.com, linux@treblig.org,
 alexander.shishkin@linux.intel.com, lillian@star-ark.net,
 chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com,
 link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org,
 brauner@kernel.org, thomas.weissschuh@linutronix.de, oleg@redhat.com,
 mjguzik@gmail.com, andrii@kernel.org, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-modules@vger.kernel.org, rcu@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 2407018371@qq.com, dakr@kernel.org, miguel.ojeda.sandonis@gmail.com,
 bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
 dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
 alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 tmgross@umich.edu, rust-for-linux@vger.kernel.org
References: <20260706061928.66713-1-byungchul@sk.com>
 <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
 <20260821042143.GA40890@system.software.com>
 <825134a8-ceae-430c-b2fc-d1d0c7240f39@kernel.org>
 <178730572084.2852630.7732425311008244683@noble.neil.brown.name>
 <3d58eb3c-7a9d-4183-907b-46172664631c@kernel.org>
 <178761465493.3510150.12380729360578969391@noble.neil.brown.name>
 <ao0AieB7zg5FKD39@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ao0AieB7zg5FKD39@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: dh8d867fyhquwiinfbnj6k17duneqfrt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D4B48C0004
X-HE-Tag: 1787652792-232147
X-HE-Meta: U2FsdGVkX18jPebI7r3wXlWks7E1yIj0i5MKv/vbTcwEiBFPigHZeyH0TOMAlRdowo/Rej4zx9AfOnQPvK4JQ1pKorTlbEWN+slxe3FgHKB721k5G9jES+nZrHI3ZJRjqiDtJhpBenr1xPJ3O236OAS5J4U37qq5W4hk/ToZl1zcoJNTOW21ShY/RCbCvOJYf6opmuQ9d6uQTwcB4O+Z2a/dQ6ENCpDo6tl6E8QFXrrDm+DYoXzDHNfWwJvKxGMIqe2TBE1co5mQjWWZH6cY4T3Ahe1hoS7uXzLtolLxt8S27Zi/ZK2YULs8uyw1UJtUn7YO5BX9hf7gUR6+HxkBofT7F+c39ugGBGS9uubLn1KEI+szQJlsv8Yo8OcEpUZkmNvIll3pH7iHrTcgUXr2s5X5W+Xlg9Jx2lsB9VLyX3NVRDvbMpDPw9hpghydf0MB7UqKF4wgf8O6NZXNRtE5SIG8uI/28OcVFzpxgtA62o+mlzUxJNHfCP9iusmTBegjODi8885070uZN+6eFipbymU6CVdhNCJ6oWdY3V5ExGGHe7HP6bff+5MXq9RYJvXLfzMC6W2l6To53n8m+lWRJ6NQkgecIvd8cMfW1yi7+buyYci0zgq6/od+hwDq1NCHNVHU2nfdptT7aS7l2kEjxQMBR9z1wgQf1N+meX+vH6JN2SAWBB3MgyVBnWl0qTkjqvJq7FUVabi3/joVMkubnWKzLrGQoqjMCvdhgh1y423DRuttP+IuPE7P/aYrXE46Vk+8o/kJizPzPYKv+miWgl2zGnq+fIxzxb/ljubz/BCbZzQq2+2QJT/ruLk02KAKctp0kKK17V6IQlEHgBhmrDosC+YDMuO7hpDPybA7peaZuuq4x/q8Ep9lZf9A2ggzVAG0QobHwV1dTV0akE3EG3EBgwDNdv4b2iHTga9onjS/0e01f5vZpLonvduwikNlnFlN0pSOxVkscQWLhIW
 haDC/z5R
 dAtmb7mvTWARnTv6flVIeKJ7nuw5ndT+w/EgrWj/sStKkTWJvizMVjXaG+8h/HrqTe0TJL4rMPMJCWO39RmGBeli3Xtuxp9Mm5sl3c9rzwHXTRk2F73jSHa/gGCWWFAaNNUFYfYTyzMMKX43+kNkig1yW5VJNLOBimn3zctPEsOhDFrNxCAHI21YM3ePjbNtOwm73wyMWSzqitcxfghAWoYfQU9J6aYBUvuGvCSOaCfLyLOCAl6nkb0DngImYhkHx3CvS6XjgP+CAy+RyduBKYj6zRxdXS/0jo3hkpfD6uu0XZLNK4SpzNGOoV5zVPGEFGYbiaU5nUzhHK22qa2xUtELDPcdrIXwqGF5wBXweQl9qT9mVC69VxoKAPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> It's interesting, that for writeback we never unlock the folio on the I/O path,
>>> but instead have the dedicated page flag to tell us when writeback is complete.
>>
>> PG_locked and PG_writeback are two different lock-bits with two
>> different meanings.
>> When a folio is PG_locked the content is invalid and shouldn't be accessed.
>> When a folio is in PG_writeback its data is not safe even though
>> PG_dirty has been cleared (if I remember correctly).
>>
>> So these are two separate, though related, lock bits that would both
>> need to be tracked.  lockdep would detect how they are related.
> 
> Some history ... before we had PG_writeback, we held PG_locked
> throughout the writeback process.  People argued convincingly that it
> was fine to map a page into a process's address space (which requires
> PG_locked) while it was being written back.  And so PG_locked was
> split.  Now we take PG_locked at the beginning of the writeback process
> and downgrade to PG_writeback at some point.

Right, conceptually I would have thought we could do something similar on the
readahead path. PG_uptodate is likely not what we want I suspect.

Not that such a change would be easy, or that we should do it; just one thing
that came to mind.

-- 
Cheers,

David

