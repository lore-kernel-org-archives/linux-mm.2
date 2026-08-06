Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DE9C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1CFA6B008A; Thu,  6 Aug 2026 14:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF40F6B0098; Thu,  6 Aug 2026 14:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D426B0099; Thu,  6 Aug 2026 14:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B27F86B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:25:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A70D1C01B4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:25:11 +0000 (UTC)
X-FDA: 85071671622.03.CB8E853
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 671B54000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:25:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gt7b3Vqw;
	spf=pass (imf12.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786040709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRxIpMxQf2eH73MswyccHSNChNNfT/J5n/NCnkKxEHE=;
	b=51uCKeaGEgmazCicekC7VMcO6myqbtylm0dcy6oigVGTnaH9qyXZp+QJuonyGPYNN9aztH
	KqGR/JKn5+l03KdSlob52AzcbosX0GqJcHenbzrJBY6BRtL5uS0e9XUhHm/yzMOZiwDI4E
	1Urjo9ZE756bRpGXct6Hm+n26KQaJIU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786040709;
	b=0vNkIpujG8GauiEBMHaesJ47N8BV+rrecqZicqRuOvF4ZDn8CxGQImjOG0Tm7o0cCQJm1c
	QPBSA3lJYsjP82aA+hEvw5gXMloTPCepIw7fs6aXxBV7HV0jB06/i3t9VAmFZTl7ej53KW
	oV6nbbd3/oLtOfqjXyeaN0fR7K9+6Is=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gt7b3Vqw;
	spf=pass (imf12.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso2199053a91.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786040708; x=1786645508; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eRxIpMxQf2eH73MswyccHSNChNNfT/J5n/NCnkKxEHE=;
        b=Gt7b3VqwtT5FxesIfDfdNRg/IAvxXa6wNpzFmJ5Oea8f6MmZxA7/yqxgee+/TjfKiK
         c5zsyZI0u6vURJ9IStfFxV7bfjlpIhoxGQYciXjVNqR5aiLU7A/1eZYjx7gVLh4FZBHs
         X8+eDcBU/YVgdcKSxAo3M3HZyh7qrXvOs1UGVlWgbO4Ip+2g1x7DbrI7oiYIW7otvC/Q
         Rfb5zcDatFkU/SKQ/UJHAlcahy7SGIIKddVFeEN4BSynwUIVoclHiVm8MO9O8HmsCZq0
         YBwv7o0x2kygBqebNECu1HVibTPXISonm26MCVRz1gDb4dhVZVYYwX2u9/XEFdf+R3zA
         /PzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786040708; x=1786645508;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eRxIpMxQf2eH73MswyccHSNChNNfT/J5n/NCnkKxEHE=;
        b=SHvKzDGSI3J5dFXO7Eb9CSKiugqevlO1NLGa7mqW//jUx5QHUhMhRiU9RMRAcg2DUU
         FjI8QnJDJgGndWOicv/BUljP4iO6cSpeqzRutqfh5IlNRsHkqHpMmbGupiuP5korCeEB
         JeYzU/qmlGVDheHymWYqzTzNhFAZe+ZRfgikEN7FO9hkhxHT5r0rw8pCwNCcHEDUFve2
         K4Qw9J8WBt/K/wWRdjnCf6laPLaHA8JpWzzW325+iLAdDPLX+AjW6gIos+o9u5XXocHY
         bfhqT3dm0a7AQK7Ol3fd05QL5JY257D+DsBLRJwCroVYUm/pCuiB9yqHZKVJrPSrdfAR
         bw8A==
X-Forwarded-Encrypted: i=1; AHgh+RrG5gMG/TTYbnZTw1r61JPvH4BbRJHLhqpEAhKwYmqmApqIqqjmKrqR2FHhpT/+Py7dtdE5eXzx+w==@kvack.org
X-Gm-Message-State: AOJu0YxV7NUqFoLrw4PaJ3THTRGsY9ZP9UBJe/6BN/VsXlcxVZ64YkGr
	p17Dkw8KAkzTRbj04Q2Ys08neVykGecDkpzFeV+Ov6SxPz3XXsAVnSCV
X-Gm-Gg: AR+sD12kD4zUVBwU+EXYZ5NPcGQyTeS9TY1eQMRQvBjGuH9154iuAWLKf2C6z6RtyWY
	jwoxdz7aV11EZvRRTDmSFpmJaLGOfJTE+Puq5quEKOY7OJHTjqU1atM0lif4WI4fnd1hNtN6w/D
	i6jyQKgzuVmxtTn+NX6o1kwKMdlKQ/jfwfdSOrMLL7o3FOff2u1XNENUwKN0HDHkTv1ytIbOYto
	KUCf919B+ydhhWRWiHF6+rs5xUI9caAArndzlvTaoFbWgdQuFTRmxdjQFpuwHHfNJAXFhZwULAs
	SDjTgrizQtV5vZpIlPidUxwehmSzglSZ1Hb9BdewrKh6r5c5H4Oyy/fA6Oq/wAoB/advTKj7ZZ8
	Eh3ADS1lAaxpUKPZGn1fo3iOWTQWsuG8STz1c0Qw1afS5lzGbn/fjUprRtSSENIV+A9lumBooAW
	YMlbHplsnhsdy79O/IuC1bVi/hc/CwOMSWc5JBka+/Y2aD0STU+ZfTGzF86iIq5pdKURRTmGYDe
	gIiRqBT
X-Received: by 2002:a17:90b:3889:b0:381:973e:fa08 with SMTP id 98e67ed59e1d1-3903c5cfba2mr14353244a91.18.1786040708017;
        Thu, 06 Aug 2026 11:25:08 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:6e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867bc261sm29668669eec.28.2026.08.06.11.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:25:07 -0700 (PDT)
Date: Thu, 6 Aug 2026 11:25:04 -0700
From: Ziyang Men <ziyang.meme@gmail.com>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
	linux-input@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-mm@kvack.org, kernel-team@meta.com, bpf@vger.kernel.org,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] selftests/cgroup: add memcg_stat_cross_cpu
 correctness test for flush
Message-ID: <anTRgIZe5wgAsdCU@devvm16600.scu0.facebook.com>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-3-ziyang.meme@gmail.com>
 <f83b6c93-b32e-434a-94b7-68628a2e8527@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f83b6c93-b32e-434a-94b7-68628a2e8527@linux.dev>
X-Rspamd-Queue-Id: 671B54000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xpnwgpi41txz9p3scixfxjt1giqemhx5
X-HE-Tag: 1786040709-54353
X-HE-Meta: U2FsdGVkX1+lL22GNmhmV9ZiHJqyuo2nwH/GxcordATHwt/68GzLWioMY5OE7lftWpo4yCjsj1sQZXAqbyYOz39NVMR5RMBgjAZMamLeRt3HrPgG0nJR3Q8Lhc0LMnywj0KoYpF+XnQ3N5ubeyB6nMpxbiXWf3HT0hqX9VBcs7TVSF6JkOjGjJsEFblk4QdjipDLh4i+Tk+JkSfgbMy49Vk6ImZcrVz4SYo2zi7m9SMULrIbGTcZs5gnYNqeLLhfZtbD5X+d9H702YVOR1jZjkfkFyHpEFaiuyabkmKgs218/o4ZStnIZ7QRudkrYctuJG3Yk8BorFNOeXWuEH/nict/JmcqqWFlFo8GtlG7XXxMokWJ8vmMFn6BVElerEiv8bLeFdsCJT6+R1Tw8DbAG2n/w73xjzcygxjicYH/HEAmHlnFrBZhsHa/4YjZmGLbzuB6nSIUlIfnOpIkJ/SD03vKg+wHtliaMUk2UKUPh90N4whXtonQV+emGF0JGeA5aSwmTA9WVk/E7RCbUfqLf7VuU1RGL3If+q0Zrb9N9qlbUR1EVzPPhgVGVEIRYsgtMXM4KhYdqC9QNF06b3s6KIjYxoWWwG0mlnNy80DxXUddHQgRb3GZ73l3QJV0w9UgVHa+jKuRlS6H9bUY0mzDUVJIJ06BpFuiVpyJeEnmCZxJdS9/udSPll6utBjCvzMb/9GKNUD7zJH+zsPbY9jLDjez2pG30UpXC8Hdv7kfKVt5LyB2EbdJfh1yHixJ8fjpbXpfoqcYkfencAb+vxeAp9E8q2KTq0svj4P43h00BXh5Bs5yRfUHG0mv5C5VVbqudk/iiNA184pgDAdEg1z/3eKyqi86/oisP/TcIGhxnOJViueqJNLYIW2l0WtlL9WRrDquDLiuAvgKnUjipaxH7VWvmYKQ7GQpmAKQXaJt40aZric1Jx31bEVUvOB4BvOoIIzKi/29I2rzyfRIsHr
 Kn0YQv3e
 8D6tQUNkMtaB+ZNmFX332aZ7gxP2EiBYexXxARyVY8u0yz65qGUmQqhi5A002OEQaoSgugALaZh7F/kdCwEwXKeLmiDizl4AFZq7w++hGTi8Mwnc3+ZcB7GS4MW0+Aa3KXjvutolmfdzB+eG1tv2jVFA5gfIqSV0Hdhg310Zbupz2CHWKa79yxyjynAVPTRuFBisaUPxgBsZnZcLBiKeTWDWXjYVkoQ1NjRzflLveDiKKUwW9DtdLmMT8s490PrdGXgvvWo3tAo37k2m8l+WYWfQolHXzf8YVE73A6ucB72h/0+dqaGWyGKM+3n/KWsdCzftUrV/hpniGOfCK9m0k7VKrpf3A38ApUxj2U4vQaQcTsCfXfKV7uEPY40OmdPMZV+ONSran2qAyRGZedrE0DsVG6DR1s8O+gZ3vMwBtmrRxpaOeAHiWYMlyLA1k0GlWf6pBfSgLpB6mXhPe5v+Ouaae3VMncpR5O9/2F38QYbg99o/Zc1iZUy9MagRpnoXCvhgjfy3nQNYtOv5nhZ3LhAE3yiEgJFFD3xUpN+ujTUPjb6d1Do0vLA1ffQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 11:42:58AM -0700, JP Kobryn wrote:
>On 7/21/26 10:48 AM, Ziyang Men wrote:
>>Add a test_progs selftest that verifies the memory-cgroup BPF kfuncs
>>return values that agree with what userspace reads from cgroupfs, across
>>a whole cgroup subtree that has been charged on many CPUs.
>>
>>It complements the existing cgroup_iter_memcg test.  cgroup_iter_memcg
>>calls the memcg kfuncs on a single cgroup (BPF_CGROUP_ITER_SELF_ONLY) and
>>only asserts each value is greater than zero, so it never checks that a
>>value is actually correct.  This test compares the kfunc values against
>>what userspace reads from memory.stat, and checks every node in the
>>cgroup tree.
>>
>Can you extend the existing test instead of adding a new one?

Hi JP,

Good suggestion. Actually extending the exisiting one was the plan in the v1.
However, existing selftests with similar purpose is the cgroup_iter_memcg, which
is in the bpf/. After discussed with the bpf reviewer in v1, we think this
selftest may suit better in the cgroup/ rather than the bpf/, since 1) it tests
the cgroup functionalities (bpf is a tool), and 2) together with the selftest,
this patch serials also ships a common Makefile lib.bpf.mk for easily compiling
selftests for other subsystems using bpf. Currently there is no other selftests
in cgroup/ relies on BPF and we think it is good to put this selftest here as
the first consumer.

We appreciate any possible suggestions. Thanks very much!

Best,
Ziyang

