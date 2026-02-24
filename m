Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CFECF4BB82
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 20:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3F86B0005; Tue, 24 Feb 2026 15:23:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81E86B0089; Tue, 24 Feb 2026 15:23:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956F36B008A; Tue, 24 Feb 2026 15:23:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5456B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:23:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30EB2B7285
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:23:53 +0000 (UTC)
X-FDA: 84480476346.06.4920B4F
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3A275A0015
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:23:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S7gaevuE;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771964631; a=rsa-sha256;
	cv=pass;
	b=5K8L3O40zwauJwjdjjQLEzVNqlwZnJOhIWm89ZJfJbz0/X6yoQEtRjw+KO7HbtvxbRXI0p
	s/xAwqv+XIOXbITRNxNveTUxCW76aDU70Uydzonq5uWs0Hf2VD9k8MAOwOa3+lqLUBqv5F
	psliAiGJHXlk0+nBCxDYHzgo9sslj9k=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S7gaevuE;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771964631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92cF9vLOTY79UFyNdy9bd2VrXglLHPTMAuIFCQkNKr4=;
	b=MycMT7Zg3xWLxzGmsDLuuXd7GY0OXbrsGBoiKHySnojI2cMAylzxBGNNtxOJW3wCyJtt1L
	86NJU70Kzqj/XXlYXdZWgKN855W0OgfFOubAHy6pNNHMZ8q86Ad19UZhUmXubV5OTm+zVf
	R6hpLAob+nEzt8J7xMGzRJgZO2HzCLs=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-897023602b1so68497336d6.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:23:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771964630; cv=none;
        d=google.com; s=arc-20240605;
        b=lV4xjV5NQ9osGHiQFWO9NvhkMbKb4m8BzZoxoSq5Tunt1dUee5+eL9QCt7X6hZ++DV
         rRZ5Mw2uQlB4XD0rJICrtFN5o2aTf9ZgeghaQrXhGtsI8rTSr1EGx5fFz/tbWqusw/CG
         NizNbkNESCCZhFNUgLOv6cEWSs14z9uRumi+6l3urJ4SEBnT54EM7PUK0dVrwthWXsLM
         qaJy2ofl9QQn3Xn1aS3oNNqRk7G7GPOYzwY/ZHJ3qio02wq7R0xjecWW4ZnG5hcxLoz1
         B311wDF+kmAaqVzNAPWsZNM/Q6V1tITRAp6yUijNYlnGcVcP9h8SlDbL+3VOsQ6XeWBN
         qaZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=92cF9vLOTY79UFyNdy9bd2VrXglLHPTMAuIFCQkNKr4=;
        fh=xN8USFiJwHRz7XIdyfYz5NnC2wh2sgmgvjhySZN/jl4=;
        b=Nif/ww4qg6BWQpcWm14Y4jhm4HYcGcLWnAnkxxTfDeuLtPIscTaKr2v4/hfk4VJJZt
         g+0rfOraGSUFtsdEwea3RYWdO4AWWqRbQ4W3cFR/cDflX/R+HWrYxsEDhPp6hoUe+sQJ
         AdkvCJxXt1WDtai+drLDjK9+g/ssy6oyydtSeNpmm/HI8DBxoQ2LDEbtBIMTzv4ohPmi
         PLL6rlABZNFT2Gj+aJfYbhHFp+VA+NSd9037VS0RR8JYRVmqna5w+JsZdaYi6IPyymXQ
         H+NPV7U9771CqN+/zagTWeTlMpupC5tPmTSRvISVR5nQ8AYgvoIkbKmf+00J3jEsIUl1
         bpfw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771964630; x=1772569430; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92cF9vLOTY79UFyNdy9bd2VrXglLHPTMAuIFCQkNKr4=;
        b=S7gaevuE09yA/VIZCazUBsodcvq+XAIm9HrehYvUALVnY3vdn0GNxZCHTq744q/YBi
         KPwIw1f/XvAnVG/EqsdLL/Cb+viGo5biwpu6On0gGWQKpawQZviFNQvnHm+mkRe08Z1j
         gOqdmYdb2I2gsQaqMBuOtPVpOXp4cyjZRgW6TEDZmJh9GI8Vf+G4IdnObrBzalPyZlBp
         CUD9Inei55YJcl34qKVXrX+4JhObK57DoIjMvwD4bqUQW9UgoqdA8VoQ2B2awfk1zQot
         ND7zlMPDKdheLUCuRP7j5vpqToXmHOoVHqMhEYHlPMeebny/c5aG/jre+pB6cjllSYKY
         1RVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771964630; x=1772569430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=92cF9vLOTY79UFyNdy9bd2VrXglLHPTMAuIFCQkNKr4=;
        b=tXS7DLpINgO+swtNr9fTPbEGp8iotwEkd7zxgpCCwTYhGuGInhdg37+VbIGz7fzi0/
         T3NqQ7vmbCp1DptW1K8kBIypYz33bWd4BbKguWgcj3X2CMu0TLMVwtUVq/rKIFPVFSrU
         4IeHpkfiXR3ymGRuKD3AuR+yWtziM3C1F+uGtV/RWQlkqItJX4l0JLixpDZex561Yt5P
         LXEXyWQrckg+Ti+Mf0U8UwzdrbAhPCaGLprTMpkz0Boq3pl0vLXtdjR89Fojo8ke+TQ1
         UllUrDrtqXUz39PcVaJWCE2Wtbc97ZKvT9KTv6HYDuRzOSS0z79VE/8/6+Jr6RcM/P55
         rwZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6xJYt6QbNXUqkEgk2Mc71/DekrwXafBMbPF7GdOX1EzaGbDnWRsiqnL/+eEurCfhV8qIpNMnHzg==@kvack.org
X-Gm-Message-State: AOJu0YwGPInMWNN5ooSmeMXrGXSYgwNgxodzoq9khuZL4xCLrujsK3Hy
	JcNFH76htfZJZVts36gaya3TfZA/10oQXttC6+gPWiZy8VoujJZ7FnyAfJhIFOBRLRXA4aTYQ0P
	OYTQfRwwnB3Jegl2+zkm0ufI4B0JYYcw=
X-Gm-Gg: ATEYQzwWQU1nLBbDcSg9xdlvn9dV2WO6AY08sARijBqfUTh4te0u9VQuyccUpzxImK2
	w+72GMYFzKxNXTkt21fY8qfZKkDFx7gxsb64oCvqZYWyrcXY8eRKlAEXtEeieHy/Fs8iGUKk4OA
	/vyB3t3s2Mk6wL0iLWKp41T2wHRA3nNA7BtmJqg+lSClzapAAorh1ZVP/ss2pWoWE8dPA+uJtsB
	DsAhyusdKd2z6HWnPP6YqbC3q9JOVoAbGGRUomLQ2d00YMMfa6/kN2iVJVchE/lVAS3rcTp1VHa
	sHYm1A==
X-Received: by 2002:a05:6214:29c8:b0:894:610c:3a22 with SMTP id
 6a1803df08f44-89979c76debmr202658606d6.20.1771964629806; Tue, 24 Feb 2026
 12:23:49 -0800 (PST)
MIME-Version: 1.0
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
In-Reply-To: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 25 Feb 2026 04:23:38 +0800
X-Gm-Features: AaiRm51tVPbjfFGLZuhsinIpZ8XgVX0DCpFpdUFWO8H7nEMI1ma3A3W5gK8MC1U
Message-ID: <CAGsJ_4zatnuLkCJyDe_o_yXmhngpc54kV6b7M3tu6JyvF-ZxDw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and Challenges
To: wangzicheng <wangzicheng@honor.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, 
	wangtao <tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, 
	zhouxiaolong <zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>, 
	"weixugc@google.com" <weixugc@google.com>, Randy Dunlap <rdunlap@infradead.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "willy@infradead.org" <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6bicp58os9kdt785rfaomx5rjmsujn6w
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3A275A0015
X-HE-Tag: 1771964631-466691
X-HE-Meta: U2FsdGVkX19s5MkF2KcARNn4BsffQC3/76Y94xG1aRee5ousHEV/Q2g2uppxyCM4C8ynY7XqbjOSQNfORRIiZaaffLKJ6KtVmOgu3z8UU7SddfCrB2b54G0KcDdMMMhZejSepYm2f7eqqypeWRzI9RIP9jrW2n38kI3T2dY/i4ay18tlpjxHGskcQJ84mUtMiexsW51OTS3Z18gfVKzhtNGRjyA4AXP0Snfy+VZOkaCmmwDRogCf8OUoOWcVxkavhBwc5et/cam8Mr1oV4kgx7ANOkRIyfwmTjQGXIFK0PJL6qrfDPS4UlbcB/T5mevO9LcUAggvGTd/6TgrZrxrnf6bs/zexOTh/JnSU3+tocgbaDZ7mdFzoZ5TjjkL1DBF6i5a6a800sEE6nUVSdabwJ6uTmrB/BW/4/ss/Sc0jIgHDlKRutQSTiMC0teue5+VMR8PyuVPk+vQx9v8JgfPXeVPTj6gxw2OekbPJqc/qgwj/M1Ejha15taVaDs2s1Idz30A2FaYETxrJ3ttMz8esWZJbonWhTuH0kvPmNnJawA6Hbz2ObRpDtbWEQkzsYuw4UIu2JNpvLmm2JIKrL5ThgqpQy00yHxC8fJl4NeSPuEME+AJk7Mn5DmCiiQ4CvliKTvcuFWUXtQG8GxWld5e4NQElkRUgschI4Uob0stTONpKlr55Zjrw+nsVGQTjFnzdDDQV+wlQCsV+bCYwvlQyhiZ6ApxtxeCTodrflKn1xlzInE4or/5/azNwsY3k3oHgj0Up5eOvi7WiETb1enHJxM7FTPPjlSQgJduhqnpLAQ/UX9Tj/m+oMVdlan6lFyHSgHTIDwhuM21xeSLFGSDAF9nE3tLJ3St1BdmKNv4vlgYJMFIPGaMcmOwbU6xmBSuICx3ng95tNu9NfebYErrhhIkNkyeIMQ8LDLau3yFAKiwdKq8izuKO7AWb0wP/uk0V0Bpu7vusY/3r8LFNOz
 FysSdwdH
 VYi0159ADR+wff486bzOv/7uLFJHoRje0c+AzbNQk2w1RvAF4QBpYlYLf0cnsz9GgMf1m0F2TiFUKNa9vPQhGeSP5t8wMO6Oazg5u9qEOro1OfCqZ4ATdh8cTPfdU7U0PCaXtJMha9wfgyP/JwLHhLERv5hjoB1NeArQO5SNp5MEaGY+8J2Pq58vLv8CnLak0ylhzRszCPFyZRMjWpUoAiZhpXvPcrTQMd8ogFP7FsuSxnpzkqYNaVaRpiVSx3OOjSDp72p6V9NuJpITLAbxoVa4iAR7h0jQ6JSBTUfMEqC6MJDNvwFDSFKq9WdPKaYg3y88YbXQgIEXD3NekQmq544XGXrDrNDUpz9wFwy8Cl34F7WKBu13EvMCyPYrQ44eRgpUJfj+BoQxHBS0komxBJS+8cwO8KdQrgZwLI6YKvE78uyiJIkkXMdt2vAthDrjajy0asaDVmiTLbW8a4PSbcPlwxuVtI4v7Px1bizo1dJQxOoDzCVjgdUt0zNE2ho4Qs+VZC8/125SK8d+jUaLEvKRBIteLbv6j75CxsWLxI1fG4no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 11:17=E2=80=AFAM wangzicheng <wangzicheng@honor.com=
> wrote:
>
> Hi,
>
> I previously sent a similar email which unfortunately had encoding issues=
.
> I'm resending a cleaned-up version here so it's easier to read and discus=
s.
>
> MGLRU has been available on Android for about four years, but many
> OEM vendors still choose not to enable it in production.
> HONOR is a major Android OEM shipping tens of millions of devices
> per year, and we run MGLRU on all our devices across multiple kernel
> versions (5.15~6.12) and RAM configurations(4G~24G), backed by
> large-scale beta and field data. From this deployment, we have identified
> four concrete issues (Q1-Q4) and current workarounds, and would like to
> work with the community to design upstream solutions.
> Also we would like to discuss MGLRU's future direction on Android.
>
> Below is a short summary of what we see.
>
> Q1: anon/file imbalance and drop in available memory
> Android apps workload show a persistent anon/file generational
> imbalance under MGLRU:
> anon pages tend to stay in the youngest 2 generations;
> file pages are spread across multiple generations and over-reclaimed.
> Tuning swappiness to 200 and ANON_ONLY does not fully fix this.
> On a 16G media workload we see:
> MGLRU: MemAvailable ~ 6060 MB
> legacy: MemAvailable ~ 6982 MB (differs by ~1G)
> Today we mitigate this via explicit memcg aging in Android
> userspace [1], which is a vendor-only workaround.

One fundamental design of MGLRU is that file generations and anon
generations catch up with each other when the generation gap reaches
two or more. As a result, even if swappiness is set very high, its
effect on aggressively reclaiming anonymous pages is much smaller
than with the traditional LRU.

One workaround is to force old file folios to be promoted to relatively
younger generations, but this could also cause problems by clustering
file folios in the newer generations.

I wonder if anon and file generations can progress separately to some
extent.

>
> Q2: Hard to control reclaim amount and stopping conditions (memcg)
> For memcg reclaim it is hard to stop near a target reclaim amount:
> kswapd can continue reclaiming even after watermarks are met
> (e.g. to satisfy higher-order or memcg allocations);

High-order is an interesting topic. Sometimes, vmscan over-reclaims to
satisfy high-order allocations, reclaiming many zero-order pages even
when free pages of the required order are sufficient[1]. You=E2=80=99ve rev=
ealed
another aspect: high-order pages may already exist, but reclamation
doesn=E2=80=99t push them out in time.

> reclaim via try_to_free_mem_cgroup_pages() lacks clear abort
> semantics and can overshoot the intended reclaim amount.
> We currently use OEM hooks [2] to early-exit or bypass reclaim under
> some conditions
>
> Q3: High reclaim cost and long uninterruptible sleep on lower-end
> devices
> On lower-end devices, reclaim cost and latency are harder to control:
> throttle_direct_reclaim can make tasks wait for kswapd instead of
> doing direct reclaim;
> sometimes the target generations in many memcgs have very few
> reclaimable
> pages, so the CPU spends time scanning with little progress.
> We observe tasks staying in uninterruptible sleep in try_to_free_pages()
> We haven't find any proper ways to fix it.

Have you identified the exact line of code where direct reclaim enters
uninterruptible sleep? Is it waiting on a lock or something else?

>
> Q4: Lack of global hot/cold + priority view with per-app memcg
> Android uses a per-app memcg model and foreground/background levels
> for resource control. root reclaim lacks a cross-memcg hot/cold and
> priority view;
> foreground app file pages may be reclaimed and reloaded frequently,
> causing visible stalls;
> We currently use a hook [3] to skip reclaim for foreground apps.

Interesting. This somehow reflects that the LRU lacks the user=E2=80=99s
context, especially on Android systems=E2=80=94for example, which apps are =
in
the foreground, which are in the background, and how long an app has
been in the background.

But this is not specific to MGLRU; it can also be an issue for the
active/inactive LRU?


Additionally, I=E2=80=99d like to add Q5 based on my observations:
Q5:
MGLRU places readahead folios in the newest generation. For example, if
a page fault occurs at address 5, readahead fetches addresses 1=E2=80=9316,=
 and
all 16 folios are put in the youngest generation, even though many may
not be needed. This can seriously impact reclamation performance, as
these cold readahead folios occupy active slots.

See the code below and the checks performed by lru_gen_in_fault().

void folio_add_lru(struct folio *folio)
{
        ...
        /* see the comment in lru_gen_folio_seq() */
        if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
            lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
                folio_set_active(folio);

        folio_batch_add_and_move(folio, lru_add);
}
EXPORT_SYMBOL(folio_add_lru);

I could have submitted a patchset to address this by initially marking
only address 5 as active, and activating the other addresses later when
they are actually mapped or accessed.

>
> Discussion
>
> - Vendor-only workarounds -> generic mechanisms (Q1-Q4)
> Our current fixes (userspace memcg aging [1], OEM reclaim hooks
> [2,3]) are Android/vendor-only=E2=80=94what parts should be turned into
> generic MGLRU/kernel mechanisms vs. kept as Android policy?
> We need guidance from community.
>
> - How much control should MGLRU expose to Android? (Q1-Q3)
> For Q1/Q2, Android has strong fg/bg and priority semantics that
> the kernel does not see. Should MGLRU provide more explicit control
> points (e.g. anon-vs-file / generation steering,
> "target amount + abort condition" memcg reclaim) so Android can
> safely trade complexity and risk for better performance and bounded
> reclaim latency (Q3)?
>
> - MGLRU evolution without memcg LRU: global hot/cold & scanning (Q4)
> If memcg LRU will be removed [4], how should we maintain a cross-memcg
> global hot/cold view and per-app priority on Android?
> Given that much of the power benefit seems to come from page-table
> scanning while generations are complex, is it reasonable to decouple
> page-scanning functionality from MGLRU and make it a seperate kernel
> configuration.
>
> We are happy to share more detailed data and experiments and to help
> with PoCs and large-scale validation if there is interest in
> pursuing these directions.

This is very welcome.

[1] https://lore.kernel.org/linux-mm/20251013101636.69220-1-21cnbao@gmail.c=
om/

Best Regards
Barry

