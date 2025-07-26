Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAD0C83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 23:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B68E6B0088; Sat, 26 Jul 2025 19:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1674C6B0089; Sat, 26 Jul 2025 19:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081C76B008A; Sat, 26 Jul 2025 19:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBDBF6B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 19:19:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69592160B41
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 23:19:23 +0000 (UTC)
X-FDA: 83707984206.02.B7F4617
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A6FDD40005
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 23:19:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oP6TEdb7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753571961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDGIW+TH9vAlNoQvdFdR+qpWRbp6aLgiXKsAT00qYJA=;
	b=jvD+yPbHwOJOgw1V8r8ZXYtphS/HuLeZjD7DzBgDu195WYfdAGvNgB5WbJo3BgbYre7Oco
	mWGaIluitzoQ/utDnaFKoG8GbmC6IkvgFJlYZ+3+aRSnvvVEPhCao8Q734y/EEERLhpoWD
	qGC5G5jU+bYfvNLae+AQLdO7qAHnDkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753571961; a=rsa-sha256;
	cv=none;
	b=DihZVs9+M4kaBRkglzEQEHuecNZb2inC55Pc3RW4NlNOZSIPiZf+p8jlJJGY1F8mgx0ViW
	3v2hEifZ2bVutupBA2qjoBxNNV6QAdwDqhu9d8sue464WJHS6MSJrLYSQ2PR37zeaB4LQ7
	BgKvsrn6MwlGUMvyx9VgfianoqRCN1I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oP6TEdb7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 579874435D;
	Sat, 26 Jul 2025 23:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D9CC4CEED;
	Sat, 26 Jul 2025 23:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753571960;
	bh=EDGIW+TH9vAlNoQvdFdR+qpWRbp6aLgiXKsAT00qYJA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=oP6TEdb7YE2T2S8Ap9nwc/X3asue9bKewcgHIuUVA3FoCpyOmXmfThSlzYPyAK/rP
	 4QmN0JpN+rFzUZGkj7ZfF+6czDfH3GIzjeosnlj8ZOiateuLnVjtxdSz4wROmB22Fe
	 vfrhicja1vsznPCIbFme0J4tO5KEpXgaiaY+tIDY9AwqLc2dTu1wu19uR7qZEUmZ/g
	 OEgxNsGwqMrDhnvjqnWWGtfTN0rV/BICgDQCteeZ6t/gqmEDxcGxYzVjvKStGgtfOW
	 na16XywlEeyZIaWoOiS06QOBLiNnnO6YFDoUHguGw1tVAVRvr6V1alfU6Krbou9WWZ
	 q88hFGa4q31RQ==
Date: Sat, 26 Jul 2025 16:19:18 -0700
From: Kees Cook <kees@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bhupesh <bhupesh@igalia.com>, akpm@linux-foundation.org,
 kernel-dev@igalia.com, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
 laoar.shao@gmail.com, pmladek@suse.com, rostedt@goodmis.org,
 mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
 alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
 mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
 david@redhat.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
 brauner@kernel.org, jack@suse.cz, mingo@redhat.com, juri.lelli@redhat.com,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 linux-trace-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6_2/3=5D_treewide=3A_Switch_memcpy=28=29_use?=
 =?US-ASCII?Q?rs_of_=27task-=3Ecomm=27_to_a_more_safer_implementation?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com>
References: <20250724123612.206110-1-bhupesh@igalia.com> <20250724123612.206110-3-bhupesh@igalia.com> <202507241640.572BF86C70@keescook> <CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com>
Message-ID: <B9C50D0B-DCD9-41A2-895D-4899728AF605@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nb89uafamo3gu65mnhfgsoe891sihbju
X-Rspamd-Queue-Id: A6FDD40005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753571961-756562
X-HE-Meta: U2FsdGVkX19+hNzARyVPPa8Vz2wYap/nCTc/VPvO2NjaA+Suln7VRRqO5D1hWCXdtFfG/x8dGFOubWMrqG3xIxoygdNg2XvwYoblDvj3MiUFwW6yHWT6pApWiVN0/kf3dMBydm+Jf6Uy6MTX3uTFXvqFhsAGdUZ+bCQZWl02JK+VF3z9c3KBVervR4b+6KQJPPgLSxVJWjRU/q7W19uUfa041iWnecwyJZodQKBNxc9Xfy9FX8Q4t1Qz+xNnEp91vrEma/TQCAhumg9GzrFyeZVIB6ErJES8qasIJ2/25SfaaBoKOsCS+aagnlLLMJ8yiTnEqwkif7AE9c6EkJHHXp1gtb5ZglFXtdUTzDQ602VnDR4fDGroL5cW1LIazEwQ8tKrojxlweX5jjddpU5rZG003jz/yRSPzqjMapzFTPu6HGzoMi1x8pMsLCEHBzSkskapgFcv17S+XIOYZJf5qOvKRvDieVq1cPzbryUyvl51W95CyqLBibFK2VpE//+OBPixdakLotNXx8V0dbkprvI5h6Hdz2PGLxWXYvddio2FW2IzFqvGJd8fYXAa1yppw48ro0UcRFLsO231zGc2zEjWeBMPfjLroAbloGKqXPZJY+/bQkxbLNNiKBHVzElNw5hrLmJYdUPmRPBaprKOFrw+hzxfayjD0909KI3jmpWQ9gR3SUzVOxAeN6LlHretCaUz5JLUwg3N3wlSuK2OCn6AeGs4NjNmC3yZhlc3bHimkk2tgvwjAJfYXzyIQb9Sn+OPuLDWiuuJ0SnpTogoHmnXDOBaCZloW6lQ+gOXHk9KOiTaWeUdpRhvpN6DkMRp3S+s6cj9j3gJgWNdqq3/5s8alTveW2eLHorPn1aYP8ABCBmiCHK5HWBaVf+6rH9nlXJaYapBTf1JiruYvC6x2dLyUoc4lhc6dqL9gnid7H24FE9Lbz6FYS6nm4mea3/U7jYbrW7/o0ULqjkdOhp
 HvdbGqPt
 XvWsc3esxZmB0u7biHk4DAHRN6ndkW9H4UYhlvBKpH2Qa6R0UETVMfW+kn9c9K+Z7pIXRmLeY41ZTxJPHE0pZudANKG9/CdUMSzJCVR+CfeA8hb6y2CDYMl54aDYxLE4xtXLbfyEcYOxyb497itupCOOlsc2qEqo3JKBAljA0rEcOfsgdj4AIfzoTc+CnXwGAzxhw9dxFHUa+zEG1revllJdBvFO7iqx5O7Ks3SgnWmHUQcQMvDJ/Br88GmJ57JGUFzerZwFhwbQLPMHYL1qXiKqVBMK9boEq6GQEFHnUOUQyia2xmImmiMg5cEbzKIB6eQGVLgkeqwu3lc02l9davlsf34IJ27fBKLUAszXf1fISrDV+4YlcFNUllLo0nLRIXlJmDp+uvAkk4jdB/k+dGoLfF7rO4IE83++jv3Urb421hVeEq3tOtEddAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On July 26, 2025 10:50:55 AM PDT, Linus Torvalds <torvalds@linux-foundatio=
n=2Eorg> wrote:
>, but
>
>On Thu, 24 Jul 2025 at 16:49, Kees Cook <kees@kernel=2Eorg> wrote:
>>
>> Why not switch all of these to get_task_comm()? It will correctly handl=
e
>> the size check and NUL termination=2E
>
>I'd rather aim to get rid of get_task_comm() entirely=2E

That works for me! I just get twitchy around seeing memcpy used for string=
s=2E :) if we're gonna NUL after the memcpy, just use strscpy_pad()=2E

>And guess what? We *have* that function=2E It's called "strscpy()"=2E It
>already does the right thing, including passing in the size of a fixed
>array and just dealing with it the RightWay(tm)=2E Add '_pad()' if that
>is the behavior you want, and now you *document* the fact that the
>result is padded=2E

Exactly=2E Let's see how much we can just replace with strscpy_pad()=2E It=
 we have other use cases, we can handle those separately=2E

-Kees

--=20
Kees Cook

