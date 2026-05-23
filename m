Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8713CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 14:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FAEC6B0092; Sat, 23 May 2026 10:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084F76B0095; Sat, 23 May 2026 10:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E436B0096; Sat, 23 May 2026 10:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0EBB6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:34:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6499E40B83
	for <linux-mm@kvack.org>; Sat, 23 May 2026 14:34:44 +0000 (UTC)
X-FDA: 84798930888.19.DB0DA05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B773D1C0007
	for <linux-mm@kvack.org>; Sat, 23 May 2026 14:34:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fRuMNnEn;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779546882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0RMW+vUTF/Kw0EclT9JxUQS8BolCI+Rfe/P5jHnTs0=;
	b=uPH1sefVqoaSDTPAmOkWw5TsycO/VpnIVXiFvvXk31dPqJIYf0i/UtwWSqeV70by2Oxb4R
	PCNGW9RFYIxPQnsSXgFF6I6cbE0y8r3P4bXUtQHhn7RLJnWo6z38CLWgYiDE67Pu3yLxNW
	HYLGM24J73Ah8ZreXxN9UzylZKTvPm8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fRuMNnEn;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779546882; a=rsa-sha256;
	cv=none;
	b=7aGpc81Y66zCOdRfA/tT2BlAKtMEwr8Ikh28Nv/bEQ6nu5y7HYyhLTnITZnqQ6XerLPmwt
	JYkYzRA+YdMnz5PlGZCBjzsFqdcPCWkGrYZs6G1AdWxFJiianaShfEepIXFW7P3BtQH6el
	ekHhLddKufZhniqZllwyyjCf57OwPao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA1A960136;
	Sat, 23 May 2026 14:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A8F1F000E9;
	Sat, 23 May 2026 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779546881;
	bh=m0RMW+vUTF/Kw0EclT9JxUQS8BolCI+Rfe/P5jHnTs0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fRuMNnEnaU3pUZeCti0/1FjuF1JXjZLBPgmMnv61LrJySZ6X8EFw4h2BCpGe3W364
	 f+9TH0AgdXEX9X7yLx0+VKbn0qgcbuAO51gJuiY2p1d+A/K6NqWlqTun1KP2N5Qd1u
	 9/yPoL0gp7BNmbXkMwnk20TdBUFwagzYOSTEaD2Ww0In+zde2qnzcSAcBA5S4vFz/1
	 i1k+D0fxc9jwqqB0D96e1yuj5vzgO3x0eJY8B8QPTXwXDcHwhvQHiQfJ3SyX3YnzuA
	 8cpCjfk1Cu/tjjhiI9kllFtuwCkOTVqsyDsk/+ZQ4bT+UY/+1Q+KXZm0s45qWVf0FB
	 XkiIfM2Ewr0dw==
Message-ID: <0592b09b-a084-4d9d-bcbf-1b77e45226cf@kernel.org>
Date: Sat, 23 May 2026 23:34:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: DEPT (the dependency tracker) as AI review prompt?
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com, torvalds@linux-foundation.org,
 damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com,
 peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
 rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
 daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com,
 tj@kernel.org, tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
 amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
 minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
 sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
 penberg@kernel.org, rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
 djwong@kernel.org, dri-devel@lists.freedesktop.org,
 rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
 hamohammed.sa@gmail.com, harry.yoo@oracle.com, chris.p.wilson@intel.com,
 gwan-gyeong.mun@intel.com, max.byungchul.park@gmail.com,
 boqun.feng@gmail.com, longman@redhat.com, yunseong.kim@ericsson.com,
 yeoreum.yun@arm.com, netdev@vger.kernel.org, matthew.brost@intel.com,
 her0gyugyu@gmail.com, corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
 gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org,
 frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
 josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com,
 jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, chuck.lever@oracle.com,
 neil@brown.name, okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com,
 trondmy@kernel.org, anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
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
 neilb@ownmail.net, bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
 dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
 alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 tmgross@umich.edu, rust-for-linux@vger.kernel.org, Chris Mason
 <clm@meta.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Josef Bacik <josef@toxicpanda.com>, Yunseong Kim <yunseong.kim@est.tech>
References: <20251205071855.72743-1-byungchul@sk.com>
 <6b2a816f-eb3b-4e0c-a024-ee2e3743eb04@kernel.org>
 <CA+7O06GxeDLR9RcKDN2i-Rgc4kgzz6BfF4b0XAH4tFx=A723Nw@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CA+7O06GxeDLR9RcKDN2i-Rgc4kgzz6BfF4b0XAH4tFx=A723Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B773D1C0007
X-Stat-Signature: okt8uj73m9zoyds417jax65qjzim3cdm
X-HE-Tag: 1779546882-939739
X-HE-Meta: U2FsdGVkX19/bA0tUcuSJRMutJMX7GI9JJ8+XhVfYuRLsYJzy8NQRtSw/Kyd+1EvuAhjnMQUodGaJKKFCAFR/IoNIy3BgUw875VM7YOqC6IzA14x+hW1+wdcGJLYb3fdZ3UGhluy6f00DQbTYjNEK8xO8/Vot6Ag/YglkUytQfYbu+Xc7ZoawhoWoDCALH75aPND+zE/Nuoxw3GonGP8pjEo6dfRywCISwl9wmUfXUHcrI0RLLantUW6VhhNidupDroBWVp6y7cmP0NsHCCozC1zDuGxD5rHzo8Hsqt2ylneq5gFBN/YrWo42q+7PQ3IfPr0+f+y2CnANDu1pM+N7Tb9tOJImzTgnXEVgb8oS0xV4M89fVeWgC9v+wnqRnfVMU5ubwCuFy3cT3W/C65auQ1fLySDkYX3gZP7dnbG5ztENNRqBe2Njz/bjXEmGGc0pdUbXt3xGc3WNyNdvNgQf+eaD9ikx+kNkvNjMbMyDSzer0ooITBIo+7SSqIr+gYfYdyUHjlJGyD9fr9E0JOe0zR4UlIKdFNvDLI4A9PdS+dU0atpFNqb8xn3KPRluXEjOGnQdyBxWsDYtHpX7augmMXb84wFdz9rXB0ZaDxXEVuovEXr5jnudqUa0bJpfxzsZRUNJ9M7IZ4HZUGbtRFp11sTd9lHCW0CjDSdTlx6chgCAbIpYon8kAIknYACmVSbfOcswwvIXT3J3JgChniNVt8JGPFmVD+LqXihIK27v+g9crEbjA3cttT5JAUOjNjJBrvCbKCVl3LvkKBjsmDICHd19VEgkS3WkEOgUsfPaOA/Kh3trikIi0cJHivzkDgB9h6PM0fjI+KkwwJa3Zm9UC9qCVlK+kKi7ZZPtzwhkkMQ9/auzi7vUgtJ93WHJquoTSLq2+j/2o5QwfEQzisFPLfoWtf2WRVTVCflh5CQtDphUcqyrvX/8dKRF1oksCHbkxPj03Q9q766QStItqK
 el0HvAKh
 +tuQXtlPbp1mmFien30oegJRwzn2qcNymT+ipODgV4W5Ow/lvbx+iE9+JknFCYK1e4xhdat6eHf1phWZRx1ary7QY2o8g+5JqKN5wjj3PrZ+cP537Qb8imcTJuhiOW2PfVInAMm5boXBiqp+6bKECGFv83Ihq5XIeonqPAPKFHyc5QO2XSE6Wi8WMQrqj/IyE4RSKPGS9icHbFz3/AKta8EyOGLp2xB1bw9E4qSFzhPZPC33XZZGCJISF9kZPVOPtX6hTeIiDZO7p71KsA+wlyuY8UvwyC4onoeB//jef8dz43uC5Fdv4GzJNSUGPCBHlBnEgRC1mfa8cER0TA5bJkV8HIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/23/26 11:00 PM, Yunseong Kim wrote:
> I've previously experimented with running DEPT alongside syzkaller fuzzing,
> and many hung tasks missed by lockdep are caught by DEPT, but the resulting
> high volume of reports makes it easy for issues to get lost in the massive
> log output. Sorting through that output manually is a huge bottleneck, so
> leveraging a well-crafted AI prompt to triage the warnings and filter out
> the false positives would be incredibly valuable.

I mean both 1) detection of deadlock issues AND 2) false positive 
elimination with AI.

If the review prompt is only used to eliminate DEPT's false positives, I 
think that would be quite hard to get broad use.

Someone would have to build out-of-tree DEPT, collect the reports, and 
then feed those back into the AI. I don't think building that kind of 
pipeline would actually work well in practice.

-- 
Cheers,
Harry / Hyeonggon


