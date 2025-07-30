Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21F5C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 19:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECF26B009B; Wed, 30 Jul 2025 15:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4DB6B009C; Wed, 30 Jul 2025 15:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801A66B009D; Wed, 30 Jul 2025 15:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EAA06B009B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:45:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16B24114210
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:45:01 +0000 (UTC)
X-FDA: 83721959202.07.22EE006
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3C7FB180003
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:44:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TTee3jR4;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="6/Gz0aKb";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753904699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=cgIR3LlEqm5Yn4FbgFmfo81Tc4TUNuPGbcZVD8SuLzs=;
	b=NuTrx/GoOPTAdjBVrSkkfFczvuNv1ONuYXvzL7jlwbpaUfd46Sum2ztioNa58F1QJoqy7N
	e2Jk9J7syRxCAU+dqHrkYncrS0ySG+49SAi6amvzuHqm/zHiKQsS4Npe3g6tATmk3pEvfl
	K60czp/ISBagyBu8HjBpUhzyWylBKtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753904699; a=rsa-sha256;
	cv=none;
	b=wLR/BCONi3IC9wtvJUrM5Lvhw2JM1N59nSV85q57le6VGo6lSb1ZEUKqxK+UXurM7Ws4/+
	e793wJ9L0nWuhhaTzbJdVF1xWIFNx7fybGw0XrdrzqgtY4CHFOx6uzG8UYJyUbaEOMK1DI
	2dZzW/qWnfCLh1Zr+czBa2eyIFtfheM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TTee3jR4;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="6/Gz0aKb";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753904696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
	bh=cgIR3LlEqm5Yn4FbgFmfo81Tc4TUNuPGbcZVD8SuLzs=;
	b=TTee3jR4JgLVEmuOlv5TLzXRmHqeQhruQHEhwnOfbjfW/3/AF71PJM5ag9KGfK3f1PfXah
	44cuO6UyKwwmXB4RDgwrrGbOdQgxQEmRaBhvDJB+Yw2b1/XOfK5BCJXFg9eDiTLcYjtKu5
	xk2VTq3M+zcpqavajvn79gMJzE9VIMgZTfJT0rfe+w+4u0Ntd5/vpex4LDamvmJY7eVXin
	X2iZLaRJZWqwMMLMCbXLlt+9zQEeC7sJBs9BWxvssHklMB2QrLAv5j94UhEAGCCU4gYBOM
	ao4CGkjFc/G6NzEW6lQUA4DOFhKAe1KN2KCWCHYKBBvmm5H0tnOG8EKKqcYeHg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753904696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
	bh=cgIR3LlEqm5Yn4FbgFmfo81Tc4TUNuPGbcZVD8SuLzs=;
	b=6/Gz0aKbOJRDitx+CqwintG72qHhWn2ENuaJEAHGtoXwk2w+2JlJXrSLoqBK75YWS2j+bV
	01onNiQW+J6VLuAg==
To: =?utf-8?Q?Andr=C3=A9?= Draszik <andre.draszik@linaro.org>, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>, linux-kernel@vger.kernel.org
Cc: =?utf-8?Q?Andr=C3=A9?= Almeida <andrealmeid@igalia.com>, Darren Hart
 <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, Ingo Molnar
 <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Valentin
 Schneider <vschneid@redhat.com>, Waiman Long <longman@redhat.com>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/6] futex: Use RCU-based per-CPU reference counting
 instead of rcuref_t
In-Reply-To: <0c8cc83bb73abf080faf584f319008b67d0931db.camel@linaro.org>
Date: Wed, 30 Jul 2025 21:44:55 +0200
Message-ID: <87ldo5ihu0.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jh1xsfixe3mwnqi9rhgior3auqqjdee9
X-Rspamd-Queue-Id: 3C7FB180003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753904698-672782
X-HE-Meta: U2FsdGVkX18DF3K/gBrfUwwdavjkKV9iMXS8wDW/UfQcqVrTqlAxgREdxvI6iC/UUIdgs/avpYI1Xz+Q+n0D21oFe6gpWMOMeh0CCjVaf6wTv3JWqVdzTbUiFeeattpO01ept6Wl0JRSPnxeQQg/vel9pLeQq2ei5dPymKr63Uz2qYjMK/wp53RMsZFFQZ4gt3GyTB3Ps3+0+q4pdDZcomNPqO7QB+wz24qLT9qr5SoCwfTrYcqtHYaMA6RkPixfhB0xxHatY1k/vMlVf2bURgFgvofYjoyPuIqeao0mJTEyY0Q/yaF+FAiZJhuJatEvXvURCDji22ZpkDTvH56xBNK5svAdInp41MfCL1rT4O06Ta6BXdqqd6FSiInMgZStlmS1ufLm6PO1ceR90g5NavoHriTrOfwuVPVCfeUxOnbYdBRMwgNXSPImPp6Xm4jOSO95XIh+S3z5UJBWziIT59p/wBbYoZ3yLG0cA4QyDppxJnu5hwoNjB0zksPftEcuL2bQkfNxUJN88HddHV9oRYc0PDos1CKxhHAtddunpNBhjqhSRr8LVjb3knxdbhSrqZ9l1uW5xfvaCdPtWh4ywckUckwkstyfuNfHfsSC78+Fiav5C12o8TQgASczu5dlUgw/rgl/NEeKbNHNwCggrbN14BF5fF0WA8AT9rXJMyNPH2HHD5pY8LwZ9tNnzaEFrE7BHQToam7ahJnD2ZT18OzyYyTm731bQCUNcenFjdoWgRhWahwchr5uWI8yBrk7JROR54D5uokG4kpukyKkZ2HaryODMMNnW367PC5CxcJHbfFuK/dAXdmfi2PZZrFZxtF7VfHrP+MnEjdfehubtMH9/xYFlNRHIQYvbYzf/xrn7FewQf6aYg8KcMEuJG/mzcM/2bqZwkbcKdmhuMbT3erSM12QkWBOu+SJfAgUikn5g9cwX0RE4OSr7m8xnMPVm7ltTiuS+0WTLQI2lLk
 OMcl/cAx
 42gyVkIdHNjsUvhs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30 2025 at 13:20, Andr=C3=A9 Draszik wrote:
> kmemleak complains about a new memleak with this commit:
>
> [  680.179004][  T101] kmemleak: 1 new suspected memory leaks (see /sys/k=
ernel/debug/kmemleak)
>
> $ cat /sys/kernel/debug/kmemleak
> unreferenced object (percpu) 0xc22ec0eface8 (size 4):
>   comm "swapper/0", pid 1, jiffies 4294893115
>   hex dump (first 4 bytes on cpu 7):
>     01 00 00 00                                      ....
>   backtrace (crc b8bc6765):
>     kmemleak_alloc_percpu+0x48/0xb8
>     pcpu_alloc_noprof+0x6ac/0xb68
>     futex_mm_init+0x60/0xe0
>     mm_init+0x1e8/0x3c0
>     mm_alloc+0x5c/0x78
>     init_args+0x74/0x4b0
>     debug_vm_pgtable+0x60/0x2d8
>
> Reverting this commit (and patches 3 and 4 in this series due to context),
> makes kmemleak happy again.

Unsurprisingly ...

debug_vm_pgtable() allocates it via mm_alloc() -> mm->init() and then
after the selftest it invokes mmdrop(), which does not free it, as it is
only freed in __mmput().

The patch below should fix it.

Thanks,

        tglx
---
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -686,6 +686,7 @@ void __mmdrop(struct mm_struct *mm)
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
 	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	futex_hash_free(mm);
=20
 	free_mm(mm);
 }
@@ -1133,7 +1134,6 @@ static inline void __mmput(struct mm_str
 	if (mm->binfmt)
 		module_put(mm->binfmt->module);
 	lru_gen_del_mm(mm);
-	futex_hash_free(mm);
 	mmdrop(mm);
 }
=20

