Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AEC606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ifa/XnA7
Received: by kanga.kvack.org (Postfix)
	id 2A2516B05B9; Tue, 27 Oct 2026 02:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C946B05BB; Tue, 27 Oct 2026 02:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3476B05BC; Tue, 27 Oct 2026 02:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1C8B6B05B9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:15:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32CF880902
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:15:19 +0000 (UTC)
X-FDA: 85367393958.21.7C86D52
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id 296D1140002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:15:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ifa/XnA7";
	spf=pass (imf09.hostedemail.com: domain of 3c0HgagYKCNQAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3c0HgagYKCNQAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793081717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtJC09tttupsRkJF7blYakQNCqU2D7U8rlrA4MmM+5g=;
	b=JchgTGxQTbht1neEUL1avQydiWzW3BSi0XuSDcn6+CHI86t0pLBIQnsF+JetSlYyD0kQF4
	j+IE7wTjXPISoCOySK/rB7NfXDAakt4NqnDcmMdzLeBTNEAtwS+pNk0gmN/pc64Z6+3tmT
	UXhVB+TivsPPHqT7gIG82f07Hh+SVvE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793081717;
	b=RTnOpWzCfVM99tsQsrdkje2Ft58ueNLAbOiUsB4TESPASwlw7sYjYTtDWdNiLKXHI3aM7/
	GbrhEB43vTemtKbYO7pfJVuG/CKRpJeinORGve+cdoXpaAKzMMF9nSU0us+Jqgw1Nq8A2E
	xHojOpZgVx+vuRO34CBue6VyWJ9wyM4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ifa/XnA7";
	spf=pass (imf09.hostedemail.com: domain of 3c0HgagYKCNQAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3c0HgagYKCNQAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a5971cf7ceso2187395b3a.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793081716; x=1793686516; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GtJC09tttupsRkJF7blYakQNCqU2D7U8rlrA4MmM+5g=;
        b=ifa/XnA71tw/ZzPEcaxHJZnVXEyTgGH56ux+WTIphr3LSpheNCcSaaIQzqC6D+pykQ
         Et97NHwSYV975pzIGUQ3Ft7uiPGrm5hDjuhIXfhITuyLf7cquUSZa0dF96BSGqmeKPE5
         Q8yAf8G/nfIKDev2ZEkpXS9JyGTzvfBmcDtBpNNLAVz7KEabbpcTMvoYC4ACJ6uBtJsG
         eyYTAa8bnog+I0TxkVWP0osoZHCnEhX5f7Bw4jcELJ+CdkFbcQ12JjIS9NynU24US+Gz
         aCAEc+YSn1CfSn+BeRLvnFraLoulOaewltPhRuGRdkvf9MBXzukf51uqE/dkjiwgkPhP
         GwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793081716; x=1793686516;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GtJC09tttupsRkJF7blYakQNCqU2D7U8rlrA4MmM+5g=;
        b=C+qIDGHO1uTPBAVE0Qs+u5Tb1kVe6LeK4o7ECEep6VgkgFV/t0uq7IrzZtV4R57GGx
         PjTqZRz0MigpYBj+2E9QTJf4tadGMiVZlr80fmXKlnG++//ghAwL0mI7Xte7E+LyOkrm
         cwQP8tR+wglcZTOrhp8ITog/KrhQ/+7UZ/nYRNcQt8WqCxj8vRy1roMLoVm5ePHfbHHC
         Gp52G8+0jt7YU50PXJ3CyEALN0chA3VjUMOYM3ZPsUv30GdbCjCKn0nEtrtIjFTsWgpJ
         PkKMn59dYfRPr3xu25enuB/h7WkrdC36cut9LA0/JUY2jLshZFX6slFyaDjaaaLRVYsh
         MrEg==
X-Forwarded-Encrypted: i=1; AKwUvBy9XiQtKJysPoDa6w5B5spJKi4Z8+5WRL4s7/nywpSFnFi6LqO2mwcj8JCa7TESbfIWxkqLrrsvyA==@kvack.org
X-Gm-Message-State: AFq9FYJ5S4twO2hyDd+7n9xHLMGSQAUGwZpV2zHatDKKsgUOr+BaWYs4
	w8Lj9tjtDk1t4NSiI/o5021MOMO/xJqwbM7iGwcAoYma6QeQGAyzzyaA/qpbOkIA01NfxL34tNj
	uKfggIQ==
X-Received: from pfbcm25.prod.google.com ([2002:a05:6a00:3399:b0:8a0:afff:6594])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:b7aa:b0:3e4:bc33:6ff3
 with SMTP id adf61e73a8af0-3e7cd4ecfc6mr7468029637.68.1793081715690; Mon, 26
 Oct 2026 23:15:15 -0700 (PDT)
Date: Tue, 27 Oct 2026 06:15:15 +0000
In-Reply-To: <20261009214639.2878857-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261009214639.2878857-1-kuniyu@google.com>
Message-ID: <auBA1_CNKLuO8Xus@google.com>
Subject: Re: [PATCH 0/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 296D1140002
X-Stat-Signature: zgwu33sg5qkyqcgsazr6p755fr73cn7i
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793081717-980318
X-HE-Meta: U2FsdGVkX1+ZzGGQfrj2GJCjIg7NJzhoWySMEwq3I10ys2wNyfcNb037duxy4lQj/ubPuf2BZCF3OWLotxDjLfn3vzHI4nnxk0yhTRZr63/2yS/F3hA/1Mkc6M1rM1SAraFd5ZByRybn9nLZtt0wd9Kqr9HgEuiDGbfgi3bkkZ/CLqmn0acapliXtZ5mzSNRux0sayCNBcBUUNALbgzOVG5p2tFqpZzx/Y7Aj/zef4EAw0V0TNXVNHGBj9hGO46VT3//kdaJfwny1GNLaJD+moTv5SKuWgXIqkxJvViGenjv2+5UQmD6HnR9cnCc0Q4UCDix3CgViemY019oKv+geWDeR/tdhmgiUrDnKK7Kiy8GaHPbVnTRNvt9AQ/W3KDKRCtIxuc9BO98z55Itd1aeSIb5guHiT+nVAfZQs2ISqT24LyGN79XvAoICVQt6GexwGOscSedE+Tjlpnv22eFL0ex0hEzAcGxJ7g6ljZ13x5NJpNWJ2Alw7QDczL2OUDAZnSJ9hCOmHxl3yKHNS8BoWoMJmrKdrhlh86F1bHmISI8AEOv1CIbgWKFcHFKgpjnY6HpfMnH75I8F63YhWdCUzhA/sVf+EqdMOaBISFf3NbsYZ9OI0NhFdogU8obSAbvQabyRJ8FjN+dNoIYIXEx059ctYks2QaNrdBUdahP8kE27l5D3qmfyC0o7HaGRx+CGzBSUMU0LWOh+CUqDEeqQqZW9UuGN+VUUtoRTZKJpdX/haPhbb2Q/GUBovAATg2yXeSESTS1u1qZxLF9qkmSxe18JYUYmbLUG4qLpzjtO7HaSb2zvxHmoqh3wtfNg4I5DkbpdFlaLh7Hhm2rYKYAk1CVd+YH+E5tA6R6qLSxUUGForQc7+uQV1e6zVj5yy58Qa1B1pjhna/94zEd534CzvVTCHxaOJ0A8sf7IicMwp6QH8KEiCMuzh7MjvUVkN+Qf/iMUxljqwhrnXax8cZ
 VDLN83Vf
 DeD654PQqCL01MjkXLJHPhPvgySTFEuZtZnkwWiYw87GnsdBVg7r7YY9a1qcgPfPRxv37HcxmzJ0wwUlDZNsjl5rjjrAGAlZ11T2rqiaewSMIylogZiNcamzK4QzhcE4+s4uj2cruWCC5tEKL84o46GXWWPLY90h17xtnGyXfgpuPtLc9C+ZdO5JR4mmdjXGZAN/N747+cntmGfxdRh/CJvZygc1/XKONi2Ibth83RDzQ/G0aCoWojM+9UkUt6+rOJuMpm4WQcQslqS78UqTRNZjUMbDeoRKGm9IqZByiwO1Ep3CTfokFWolY0lzwZXLXyUn355UGFGSx+fnvx90wm1dRShWUvsTp6JE5HU9nJV0waDVOnqbxBiyfKyxtWb1GncWdy1scUoloVlCmf5oCZAozFmDipKmPtzeviXneI7IFmYHxVmDBxERMk9sTv7Yt6xdtBBv02TqsvwXHgdCYgdOBorKmVzwUM3J4a7m/zwJ3iUfo93vnRzCJgiZr84Xfndgl2zaaADUg6K9yR0hj9BNnORLE39GV+ZmICIdZJklpJi9i4dZePEVGXCpeZ0RR+Ar4kRS5xXWFaxcKmEKAN6ZbVBBeL+1OS6NCE0ceRrTdGSi0wYsVqXoUpQTbg9RygiIKB6sIQ72hN5YEFp0ZT7Ve1JdU65LgMGrqPx7okx863XkbmaC467iHn3mO2ywj+cbNEpxCIzJHmoaI0wxyd2FKRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 09 Oct 2026 21:46:24 +0000, Kuniyuki Iwashima wrote:
> Recently, syzbot has reported several weird use-after-free splats.
> 
> What they have in common is that "Freed by" points to rcu_free_sheaf(),
> whereas the object shown in "Call Trace:" and "Allocated by" is never
> supposed to be freed via kfree_rcu().
> 
> This means the object was a victim of a double-free somewhere else and
> was silently poisoned by rcu_free_sheaf() after being reallocated.
> 
> This happens because kfree_rcu_sheaf() queues an object into the RCU
> sheaf without invoking any KASAN hooks.
> 
> This series enables KASAN to detect double-free involving
> kfree_rcu_sheaf() immediately and adds KUnit tests for it.

Hi KASAN maintainers,

It would be appreciated if you review the series, or if
respin/repost would be preferred, please let me know.

Thank you !

