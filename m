Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B089606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FvkgVOsL
Received: by kanga.kvack.org (Postfix)
	id 418876B07A6; Tue, 24 Nov 2026 11:06:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A18B6B07A9; Tue, 24 Nov 2026 11:06:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242976B07AA; Tue, 24 Nov 2026 11:06:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5FCE6B07A6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF9A91C4747
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:06:05 +0000 (UTC)
X-FDA: 85470489090.18.3C443CE
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id EC4BAC0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:06:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FvkgVOsL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of puranjay12@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=puranjay12@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795536364;
	b=KD7Xcz5ShQ9UO6EodiwQOdKSBBQy3C0KWcZbW+Eh2CkYJLUe8hdyAGDPneJF22MAVk2D/D
	kbRddqHwvpzneEzQLrXIxZmQZfz+pIUfhbCLjc7quTRF2rRQS8VfVLm8I9aTvjLpNsiwaa
	CxgLhRbGjM+8JXmG+mLlXPGFdBfadmw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795536364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+X1zAbocrlZ5/LLPdVPcXdnhobUDrydqC0c9bKACg4=;
	b=Xil23PQebl1wb4hsVWAILlhZwm5cP/RVOzwTPDQciJ1ipExnCo4+hAbxTfDAd3NUC/bKR7
	RMJzhsOMxuHgbRxycCDg6ehW+0FXEsL0VfGy/+UhxwQi5xfPIdNQJx4tUFEFGHvg/ZN/TS
	b6btY3nuy4Mt0ijxqAycIZdzcOeDNbY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FvkgVOsL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of puranjay12@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=puranjay12@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6bab10844b5so4047270a12.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:06:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795536362; cv=none;
        d=google.com; s=arc-20260327;
        b=QkYK6gBLb4VpTvV7WXgvwHEhJVZkJNj4bMwUx5LlhbZi09JbLz5ZiE6h1ibJeDQ7SA
         wbVXegcioPz2PkGp+vOIyynJA2ufBP8pnI6Q7i3lHxq91ADQpjhgAuxaM0nT2CWs3kPP
         uEhq2vF6K1DZglwFUXoQj3EPP3uw+SCC0OUFIHHQc+WAkcLmwLQp+3e9YLb6Ut9fzcCX
         ecgAky45/HTqCQkeM9MZPs5+jFjURVBBDsSrx3HZyTPdIuXUsaYFyAwAd5pEFaVrYbxv
         E7b3AKdSypkF7fwnWbvVVS6ijq0H3Xss4iuGZS4lNlT5wigmQFxn3sc+c7w11L3/ZaEp
         FAJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i+X1zAbocrlZ5/LLPdVPcXdnhobUDrydqC0c9bKACg4=;
        fh=7yN/82+NAdDPB/AjNY1aih6YuKMN3RxKCzSsRRVdYD0=;
        b=neO25gAi95Ck8kIuY3feJ9w+dTiBQ8w1CikaAOKiA6d7xbVsjEokNLo5kLz5ScvNoO
         ureLIVqqubJC2zNXDDUxBJ4+bWgQK3+YIsyoY5yN00vGl8z4WvLSDjqNv+z/cIJfACVu
         DAru6ER26AZe4af8ygukZmxL8xB+0mpF2YuBAIHW0Waw3vq6I7sjzwAClA+vaXm3v7iU
         xg+3HRf3dfcuGbC7dOjiYF43qkRE32UJSUUbvF6QscSgGWwBDi4LEqrcDMMwMFoRvp+K
         T+y6HzqR6paYsKw/GTpOpFzgaRpKg/gep45a0eTvnesB6mebiBXazGVhl0aYnAiD9Zae
         bdAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795536362; x=1796141162; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i+X1zAbocrlZ5/LLPdVPcXdnhobUDrydqC0c9bKACg4=;
        b=FvkgVOsLRDt9VmOr8idcdrCz4eL3V2CBJoigFygnU+f0GWFZLBMZ+2KMxIDx8KutNS
         YZHcuQ1FL4Ul+3YkrFe6UTuxb3iZ3KJujk9FYz0BvmaRbGt4/k89xoQ3+rm2qWjGZDpw
         1aaS8g470OjKizf1BXg/FKA0tgKY1dQxyyJfXiDrKGZhzyi9A9WdO7f9MTDgokOfRVOt
         MNxMzo/1Dya6vuL1JOaNZWUh98O553icLh+57G8BCudzawbCjMVci07LeF2U/1vZ+fnD
         yZlq8xqhbIYWajf+sDxp746GL70t/GyLy8n01sstMfbHeBAzSvk/81ENgPEhL+Bxnpkz
         q6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795536362; x=1796141162;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i+X1zAbocrlZ5/LLPdVPcXdnhobUDrydqC0c9bKACg4=;
        b=g+JQ08/dBJTGl9Q+k0dybkrUvq6srgm9uFxVaKuOLkKP7TJIWz+0GXBYvjNB52jKPp
         nkjrMlqQk+61/uubmnqIx2gAp3njFD1RVzgPMZDGY/tNeGK5k2nqOhyWol+kMugnECmb
         WSw85ThXjZNBzQofN68iA8APMqf4QUJU4oMRR8pGAkEmaBmw9QatfVj9B5YGKeF4at6n
         3CAgfhB4rHnMV/EoiaCP/9Q6KcUt+9xn7iTmK+fnfb0U9heyEaLEw6mGS/6IDDiJTs/H
         /VAYkJtP5v2/BYl/OeQXtgPlCo1gGL7UCwy2PFsLzcQUFe/lsmQUzamnYWMk7L37HEUN
         iAOw==
X-Forwarded-Encrypted: i=1; AL+hErHkte0HQ8uvwh2A/fkZyXMaCnSQ6cujz+sFE46avw135g5wU14wdLgfqqIPVDckJtEaQYKbL2yrXw==@kvack.org
X-Gm-Message-State: APuU4Z9LXiCbk36He8EWey49E5PwPIHXLFRJTqYaTbORjALr6ZUUQgGS
	v73kdGz2LnwYUJ7WnXZI5kovgPOURF6+xRzYl0nKuFd49Gul5Ej85NEZaQHHJ2mcKc/DzeONjqL
	Wzv4FioXUZASPtHUL+AWv0BzYrgmyzO0=
X-Gm-Gg: AZFdTZe7Cf372i4mTZBSRSSTqeey37KKgjfA+eEjX2+j9/pZcC82jpG+dK4DWofVcTc
	MMfy3gPcmEBw4fuWgChuMdEBRlll7qr1nwJwNd2jTQ1Huxp7df5/TFDLqeOBC/ezVZ+/5Dl4ztR
	+P7WAjt4tkCjRbA2Y9sC93krbfB3Q7BLc3gFiPEdRHAD6MZixbd+YHupgRpSS+8VP4VohPm3Qzy
	T+xvS3ht8XNe6+U1JjdPfNoPHuaOIaxIMOwAb5Nv/L17Vxg0jJS0RaWGo9lzQbaPBQmup4s1fmd
	dVEeDWC1P8Vu35Uqcq9umhKHxPqTfa4MBFNGpCu4M1wFbv2H7DM+oHSB6O1XkAYQCCnr43vaTdq
	qU6DDu6MZ+hWONmtAvHBCCThMzLNDX3McdzI=
X-Received: by 2002:aa7:d1c8:0:b0:6b7:37bf:13bf with SMTP id
 4fb4d7f45d1cf-6ba1fadf982mr9292482a12.4.1795536362117; Tue, 24 Nov 2026
 08:06:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
 <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net> <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
 <CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com> <awWz3nc_b8x3mIXq@gremlin>
In-Reply-To: <awWz3nc_b8x3mIXq@gremlin>
From: Puranjay Mohan <puranjay12@gmail.com>
Date: Tue, 24 Nov 2026 21:35:50 +0530
X-Gm-Features: Aa3M54pSMtL_EaeBSS6GmhvCgL293XFN6RiH4uS7LjK9j2GLa6vMCzrMZ8KZVJQ
Message-ID: <CANk7y0gAxY18Ew+6j5YsqrOsf5Dx+v5M78r7_8JLXh5RHZj4qA@mail.gmail.com>
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a34j4wb5yygzgjhyftsy69o95tux6xus
X-Rspam-User:
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC4BAC0003
X-HE-Tag: 1795536363-334836
X-HE-Meta: U2FsdGVkX180FBQoeTbonRaHJ8clEHhoib15a0zO71Ziwrpmr7pizfLvX5AeQx08Af7AV1UECdUJO2QZmxPude/RIoLtISApNyuEHah7GN2LQg2l8tvNCz6hYI8kLqK+ZhSht0QxnVRsZQz+tyiEJCOfzy9KvS5gFf1w9xv7XtfwerYqHX2y1wN0fN5qswyOWOSNgOyFBU3J3yQafl1VtSpob/u2fSH/95uJ6NW1QKLMrNs3WboFiM3di6fyWOLwlk8KOCebgaYYCIyMnxtagbi9crveyjstheGCiAh3JcV988rmcbWRNuWN9Dl4rcDOUiD2VXK8D/zJP8q1RamjZKDDrMAHNg2oLDoTbq3PKbpF4UtX/E/3OValr3mXClJ7iQLDCzynUNCKejKhh946BJ29rH5YiKN1Hwf8t/0+li7HN+SS3vcQ7yVo5JH/eySjiXRSpAyZ1ly5U1AwIywCK+pHFG6O+cZ8S090yuSsW+uIUm5Xp0fUvaRpCx4ORH0cKHML6PNFqYUsRYKUzcLk1gDuzZitnI+3e2Ad2YsLAiHDlLLtDVX34qjMSGoDyiykodWfGqA4UHef/UAQLtQdSF4zCzDYJsK/XFlbwe/OlxYe7vWYxCQX7hWB6s9CQdRz9XWheJBPVjA80/sv0UkJVZ1V789YMDzTjWHhu3xKIBkvaAbvPsJ+ZQGGkzYhDLHCppMvMVEbirByP3UcWBterwKzNo50nEVdLxU/AvtAvJEkNr9IY0NG/Vdnmpl6/Z4VbOaHJJRfbdv4dKYZRvLeTlk6pTP7mKR4uvnSCYShTUZYwwvaA7i+nwPYmnV3VIsIejn5gFcZgd3M/mM7tccZuJnGln42h1izzerJE9ZU/0mcLCA/hyQud5O3ydhjmhuyxYpVlVnxrjaZmlM0AODbvEoR6Tp/C05DQ4t9983DxiEEgl6HXp8qC4Xnq9vipbxbnTV1F+2o0BaOg9+YWPg
 qIIuBS56
 Wd3RlUjVYg411OD+6kbYyTE7AeYHR9ZBSUEdtiul9uBtqdJQ/P4ZjNzgfq/uDmWbLttQKYGAuAXZA6Qgit7NVemr9jRQba/XBtCSNBIeos+eU6gaL60q7WzBQ2KgAEeWe5F/oirz+W1wDW5b58N86rbgdxDGMGcXMYgvHHb8VnT+j2deImUMwbJa0GEqFUIoQGlEwTnqvDSfpPJO59weHto86vyRc2d1L0sbYKFXtr7UdgB2/vvkuDwD+Zjf7InFS/8DMnru2Tl1zfjzujXgPXFTlmIeoEvQXfNIebaLLKQwpKIEr7+jgV+ezggV7lfkGfM7Xh39yxGqDTZV65vEnxCh36YPkZuMXTEsSDJrAqaL0bGR6xGx6U4V9mWUu9TS/QRgpretvDFDnxYoH5ANHd3fo4JGGHy9HE/6KdclshlTXC49TxfaGLk5rKhiaNAFkg4De8q6tZnLdo2FLfdF8G11CJV+MHBdxctU2mfcoDGKOZnFe9r1SKn+pB2+ZAMTBsmF1gWvv45U9iSk7ilKmjrlPmFLr7sQvUoexT2GBqqy8kOeXcvEM0v8uuRYsYFhxDlODr4pPug51TA4ygPu7pV5wqfXuH9toMn9O/KGA23Qou9ZpfDHzt39IGjbY4/6Dk+4FgOCa8Mc9Hdlnfwa1pYiVGOlhKCtelzL7vB4iTlEBD8rUu2y8ADqfuZO2VwFXY78K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 9:28=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Tue, Nov 24, 2026 at 07:51:42AM -0800, Suren Baghdasaryan wrote:
> > Actually, VMAs are allocated from a SLAB_TYPESAFE_BY_RCU slub. With
> > that RCU unlocking move you don't need other_mm copy and the comment
> > that comes with it. VMA won't be freed until RCU lock is dropped.
>
> Yeah but they can be reassigned? They won't be _freed_ until a grace peri=
od but
> they can go back to the slab and then allocated elsewhere  right?
>

Yes, they can go back to the slab and become a different VMA.

