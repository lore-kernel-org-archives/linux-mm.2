Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F1DCA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1C38E0048; Wed, 20 Aug 2025 05:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB99E8E0002; Wed, 20 Aug 2025 05:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6788E0048; Wed, 20 Aug 2025 05:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFC6C8E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:25:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F43B14040A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:25:43 +0000 (UTC)
X-FDA: 83796603366.01.C2B5724
Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	by imf26.hostedemail.com (Postfix) with ESMTP id 76B57140009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:25:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dwT/bynN";
	spf=pass (imf26.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.68 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755681941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXaugHPMoplpDsoBjFEcdde60xwXGr2k9rLptADyPcg=;
	b=yN4SYnM1W3cmyIMacFilgYXWMcMzPERrs1f5GIbHyVjgdAj3u6sjjVGxpKhQkqraTzCMGp
	8draxQge0D1JR9NPW0TBczFmoWSz/YVbZstgJGOTWTFLE3El7TBe6ki3cLyVzO2q2+UWSL
	T2XpEKL715MvMGM+i+5Uk7WdNnYIfNs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dwT/bynN";
	spf=pass (imf26.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.68 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755681941; a=rsa-sha256;
	cv=none;
	b=sL+ybp9CKnt2xGQlwO4lRwwp9xVOKRe823+ZJpk1q9Kc7Z19d815EjoZrRwGLqj8eRW/bQ
	qGN9C+aTdLWhwfbr3e8Xn4739N5AdaiS25OO6O3FSQm6KAUrFvNDPZ+SwfB5G25cmuYuf+
	/6J3omh2rIMWdAGTyusswudV7O7N5BE=
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-61a2a5b06cdso6371461a12.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755681940; x=1756286740; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TXaugHPMoplpDsoBjFEcdde60xwXGr2k9rLptADyPcg=;
        b=dwT/bynNr91juTveGG6k76tPMtRQiF6pgmNdi/p30pX+P+fWhoE1HLMB3p5VCnAbn4
         yfaB/8dKNXkOc430bwwgrpTQfdQbQQPrBF+T7tdQ8W2wxsNoYySH3ztpip+M5r7LxCon
         aoBHrZzcMtehlxSX0zd0JtXglGZRtW/gf11MfoPQrO9BYkM+SwIH4irX17XrgTAMQT8K
         5aGa5ty311bsvJte/lbs1LdW3V2zfaWpQxjnWhf4ZIUNRE70MLdWiikjIT7+ubRZR5VX
         gcLqBZ3+mqLfBL+6ZGbYUgDTah8gdoz0Gxc/GRh7ZIbUEB27iikd/QUl2YSwlC6GgKDK
         J4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755681940; x=1756286740;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TXaugHPMoplpDsoBjFEcdde60xwXGr2k9rLptADyPcg=;
        b=pSqc8mM+/W9o/1jcboC3o2IiYzeUGmYQdAhwY/REhrGLnoq9ve/dYNAYRTivvZH2dl
         LdSqjtVDTt+L8jx6nKi5hnemRUZnx4IYdiZf7yJIQ3pMexu+rkm1pyudlm93IGjw6wJp
         UnLjkSYbNxHFx7vzTL8Vj1Ot4NJUiGuZ5WCv9GINGeA46HM5GyflldG9YHGBAfM7AvhC
         vsm4wzfcHPYYBbnOCc1P/qnvJKa8wvMPLf36jxt8loc08l7MGBLFDdQ0YnyjLoJJIEVM
         +QitWJl3ht4cGZQ5ATHAUVGh4Wjj5tMOyG4t+aBMSXerJbPW8jdFHZwRVVXfeOGe9XH1
         ffrA==
X-Gm-Message-State: AOJu0Yym9DfwTETOcpe6OX+rKMRqoeSm2t3jZbAW5Y/uZLDEv6sl+x81
	8kJEq3vOxMLnpnCPQ2Meg3p8cg76s5wNlI5toYaScLQE2myuk0lIKtQAVAcb29y0pP4Va1w3wPR
	C8QP2iCLmI44Brkj190DjZGyMZPUddg2Sqvrl
X-Gm-Gg: ASbGnct0f9ACSM+FpWfLeZC7XlGL2rSpRvqz3XgxzLodTc9sRQx/K3SFn3e8fJBqxN5
	8Dcvzzx3fFEodioQ8f8ropBXiL7kNW2B1NwreNzTVZ5yF/stUm933AyImTRxRF3t3dd3l6ErYm9
	0e9PvsYAPhswUwGW0t0UvKJbexzpnv4DKdgWbdEVQFC5tQl3IeW/ok1frMcNFPde+GzhVmT91I3
	pxl4VHB/wic0EkwO2O5
X-Google-Smtp-Source: AGHT+IH5r/oUOPIaZVKzeJ3UawFBydND2m/Zr4Z8FjLc2Sf4IdgmOgYNeZoUcGG6NZupv1UlJJ+OmXXFf9P7zfIG2lQ=
X-Received: by 2002:a05:6402:42d3:b0:61a:8966:ced6 with SMTP id
 4fb4d7f45d1cf-61a9782505bmr1832376a12.35.1755681939804; Wed, 20 Aug 2025
 02:25:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-6-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-6-roman.gushchin@linux.dev>
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Wed, 20 Aug 2025 11:25:02 +0200
X-Gm-Features: Ac12FXxpl9gi1KUaEwzxMMmXIWzdn3euZF0dat5BG2FZFZDhN6aQnB8C060Jz44
Message-ID: <CAP01T772oh8t05Pth2eWFzfSGVWDuW6kujRVSYQEreqZy==nOQ@mail.gmail.com>
Subject: Re: [PATCH v1 05/14] mm: introduce bpf_get_root_mem_cgroup() bpf kfunc
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yih7tbnjsweyfqxidwcgc4j6y5nzp5hn
X-Rspam-User: 
X-Rspamd-Queue-Id: 76B57140009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755681941-691939
X-HE-Meta: U2FsdGVkX197GhSnxK5AToNfH2Z9I3kwzvGBl3p0R76zExzaY+4vl8zkPVle6TfNrGF2BIJrhkm5a/4MB3qp0OC1FLIA+kK6uhlL+KiEdY7wtMeHYMkwGQtCW2dpf2LnvgCWDuDToDQ+yJItu9M3YETi1FMHVw1FQwxRzlmSThqOaW0aqPfeZxw+uDvtwm3Wgt8dAkfzIfe+L/63bid/5GDC6nls8ZBe21WOsiSFedEE67tkoFHKc/6ptP6cGBEdC0qhKkBb7B7lpW30pxSHHsadSsGnX4XzFOgYpeC6NYHM6CuSL1HMByxGGHJjY0izKre2rp2ol5Uzv8GDLtM/9RxqfvFeoLr3XAwT+IknM7j9hztGchGLt1tQHD98v/UStWiGejWovIf83no6lZJ+UHw2tliAXqrA7ymu4ciCfvwGZwDMK6tV0iqAUYZi8qRUIGQF+255CN0kfs3ECPkKHPJtAYzRR3UjaVK3J7Z0sJE79HZhCd5MqIq5Ud8ej1C1u6oWFKExhyQT6GJExDMMc35P5NvQNtQkIxmuyZ+CrN3n5veXPnYcABnb5S1mzxWxAvuswmiPleDgrsECQh9M80+vuziVweWJD8ipmSMYsqn3jkOOpUUalW5byCC5L+bEES+GtfHHfYsTChGYe/ZkdAVsyJIyNTewBFxJlq0ivrDXgG+o0Yxos1YSHJ58gjuPHFpExfX/tUBGjgF84qTQ4owJ8C/OtotXkZMwVT3AqQNH5DtezxzQWR3lxI+p3DecZ7Eg6+0XyYWItuEngnF5lPu/Z57EK7u1Uc6HVjVRwjtXiT092MQlGsCfJKpckKWdvTSES90M3ViH6l9XOKX6vOYXmQb6UwF1Us4lfZKn6LjOY9t+hHOar848x03wvUatGA2z3CGU6hVQH0VgiW694u8+fxKmQys3ejxdM7zaWmBGLvtkQ/K5pMPCtKWlzsl0kFmbybIYkx2c4thUGSk
 dqYWUYnT
 rkcqi1XJIVuVeBjyZfjfsyCgnh0U20Qlk8L5XUY/8yeM5Dtl8lS8Vobvvx7oMQEPmxIpy8D0Kfy7DzziXPjQ6iWXwVyRErzSHzObGkSjcWCglHnk05S2M4EVLkn31d89rMHUoH7Kjw5mvrpj7S9rVpEDhRp+ggW2qOQb+Bnlk2Q3IdSD59kkqDXIzmyxP627npPE6bIzu0EOm0A97oL4JyJfXcn13M/HarROSqyh/f5Q7a3BUP3HIHFHRpcheczLBJCdpZOloN+Y7q7EEbwDjI5jm+CMrZl0HCYQ9MA2SLOjDHkPmhJB+FsFgTuOYBzzLIaa7eHslOX7iQNSs6N+T/bXLOi4uo7QwpaSuL96gl+NR9fWPvVJk3o01N5PSiADJe446oCra4TjeNg4HQFLI6z25q9tnwUUa6rinV6pUl6mI5wo3B43zb8wutbafhvoOu4UQ3j/jUW1shkzAHOAnmr6S1B/E3SefBgzWZ8tPvq4fR9M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 at 19:02, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> Introduce a bpf kfunc to get a trusted pointer to the root memory
> cgroup. It's very handy to traverse the full memcg tree, e.g.
> for handling a system-wide OOM.
>
> It's possible to obtain this pointer by traversing the memcg tree
> up from any known memcg, but it's sub-optimal and makes bpf programs
> more complex and less efficient.
>
> bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
> however in reality it's not necessarily to bump the corresponding
> reference counter - root memory cgroup is immortal, reference counting
> is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
> memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
> obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  mm/bpf_memcontrol.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 66f2a359af7e..a8faa561bcba 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -10,6 +10,20 @@
>
>  __bpf_kfunc_start_defs();
>
> +/**
> + * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
> + *
> + * The function has KF_ACQUIRE semantics, even though the root memory
> + * cgroup is never destroyed after being created and doesn't require
> + * reference counting. And it's perfectly safe to pass it to
> + * bpf_put_mem_cgroup()
> + */
> +__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
> +{
> +       /* css_get() is not needed */
> +       return root_mem_cgroup;
> +}
> +
>  /**
>   * bpf_get_mem_cgroup - Get a reference to a memory cgroup
>   * @css: pointer to the css structure
> @@ -122,6 +136,7 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  __bpf_kfunc_end_defs();
>
>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> +BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)

Same suggestion here (re: trusted args).

>  BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
>
> --
> 2.50.1
>

