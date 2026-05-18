Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B52B1CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38C26B0005; Mon, 18 May 2026 19:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2F56B0088; Mon, 18 May 2026 19:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A1A6B008C; Mon, 18 May 2026 19:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFCD66B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:26:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4894D140AB3
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:26:16 +0000 (UTC)
X-FDA: 84782126352.11.1AC81ED
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D2F540006
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:26:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l2Z9wR/n";
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779146774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJpF8zNQx3fuLJ61e34VmvRInkcEmUUj8JXY5zhxM5M=;
	b=AcyVCrIbCtpwkv2QW/iIAhRV6q2xqwUkipuTtNq1UPVVTHMr35DrvsiNul+Yj6DAq2yZ3Y
	pHYXukWvjtSKjD+ienfFCBMf3DxB8aZ2CzXvgI3ZSlgTt0FkpkpNOacZk7DNQmiLFydvjx
	4Pl903yjP/SjVIItYf+nYCN6EajQHLk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l2Z9wR/n";
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779146774; a=rsa-sha256;
	cv=none;
	b=u1pX4RXT9r5KWaNXvkw9WJVWpm3u7NLV+9PQvvgJnzvxXWI/Iq66on16q2NUpeBk6Jz7uX
	lXK0GuFXegXPg63We16eF3N1uHQ+T8RIQuaDQ+KOup2afgsZj5wMRt0b4F9WQmJntN5a56
	EHZLI32LT6Ym17jAPk1s2xymOylAC+0=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6579254f996so1881583d50.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779146773; x=1779751573; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJpF8zNQx3fuLJ61e34VmvRInkcEmUUj8JXY5zhxM5M=;
        b=l2Z9wR/nIQs+s+m8Gzp1rOUP3sfDt4d0M54TcGPNq0s20AMiRqMXE3gRUGF3NalQaM
         pjyuPlQr3I8/FV0/WCOIzLq4U+Z65eRXpwNRtBSUeOg2HulOotiUqJr+Vh8G5FoNPzsw
         ZwmsErE5A9ivAQ6QjN2ZGY/qsZC4X/KTsWwgAW6TOtZzUL2sm2sKye5BocCILPUgSVB+
         P8qk08qq17E2DuqZAR0jOkrwPc+Y7eDP0ZCprLb/JQXcvPOxZEuLD3jfnfep9oqBz+cF
         FF0rfKpgEyeiqHGUsqV/AD6PjGmsS13PikVh/gNAiMLgQ0ewgmmm71lxChJTIwHg1WOG
         b+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779146773; x=1779751573;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eJpF8zNQx3fuLJ61e34VmvRInkcEmUUj8JXY5zhxM5M=;
        b=WvP5u1gr+IuIFGyvD8sXsssrzxQja1VKDa7q6GNC6KY0OllyvWwQPMeiBpuRFfj5va
         qKxDmDQJ1BU/fPZN7MwY7Fw17o8rI/OPlxe4lkw8n7Fmn+2Y0TsDJSjEb0VTbw/4FntH
         ThRcZXTbafjA5le9XhriyqZ/FK22+c668W3AiSff7YWqeLe7JQXfYVrhrZPP2hmD6w08
         4dTrNSTfZdgADPnCbRzuy9nKAiXVVGo+qOApwvvC560IZcd87ca+HdAuxEa2W1jYegey
         X+WPACNadyWRTCNCiYo2/B/jLJiGuOcyzsHq1yxWz66aMHQDCSFOW+pjQbKScre2x+S6
         jS2A==
X-Forwarded-Encrypted: i=1; AFNElJ9kbFVccqoppCzVYJvRfL6GZJzQiGJxO4sFMGiY5tERuHWmDkIhm/yGA3owhVCpOcThKOz62+Yk1w==@kvack.org
X-Gm-Message-State: AOJu0Yx93QFw7eCTBjGJoerw9PuhbYSRLeDu9uS03cyyq6nm3cSE7yPD
	yC9aASqFBYGaALaph9bmVelgBdb5Tgo+fn8WdCBbyTF/7GfJepAzkqeb
X-Gm-Gg: Acq92OFmlg6zK5sIP16LTtW6lbKow9wczctuf/POsCmbbphHp7swIte2KvVml8NsRFi
	jQnqzs+8gNl8sn0tf4aQj53i/lJpPzUe/W33kQJPlTLw9TFnq1R1E80YmfcIEe431/Fg+ZN2p2o
	rxpkxrTMak9nGy6cbdvAoYpY6dYN7fX1i2C6AftFrbe+jgX00RL5aCzbok4TCFrJNBdg017/gjJ
	16WGE8PlUbBKTRQuSkHournMZt91Mokc0T2Nyhp8CgAT6qSrlrK8sMDFd2Xfj3RwSz3pixYxE99
	NjkfiHpOANtR+jzdVmq20zVoEdBt9BwuRyvVv09eExGUx4ZAUGhkxAXaxI63mpsFxOW0/CNoWiw
	XktAsik76G4nZZ1+tgSvUJZwq8wBOoT/RCoIltEYGlPBh6dabMZXc87pBnbXi+StcbaumKiF5yG
	V0VG3y+a9jaSZEVIZPh82qYgS2VNqwSvT5kTI/qrOIpDQ8K6J+amTF5IFDXX48iOQxWMzAIdW3c
	lzqkwVh+/QuUw8pmw==
X-Received: by 2002:a05:690e:14c9:b0:65e:438e:c025 with SMTP id 956f58d0204a3-65e438edademr10259078d50.19.1779146773245;
        Mon, 18 May 2026 16:26:13 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:52::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65e0db0aa51sm7022713d50.12.2026.05.18.16.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 16:26:12 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 18 May 2026 16:26:11 -0700
Message-Id: <DIM6W7GRZK2N.14AH43S1XTFCG@gmail.com>
Cc: "David Vernet" <void@manifault.com>, "Andrea Righi" <arighi@nvidia.com>,
 "Changwoo Min" <changwoo@igalia.com>, "Alexei Starovoitov"
 <ast@kernel.org>, "Andrii Nakryiko" <andrii@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>,
 <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] sched_ext: Sub-allocator over kernel-claimed BPF
 arena pages
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Tejun Heo" <tj@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>
X-Mailer: aerc
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-8-tj@kernel.org>
 <20260518072042.GP3102624@noisy.programming.kicks-ass.net>
 <agtt2dEjS4Qg7a_P@slm.duckdns.org>
In-Reply-To: <agtt2dEjS4Qg7a_P@slm.duckdns.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D2F540006
X-Stat-Signature: nftff49acfa4cgf5j9how3j9do6jwsw5
X-HE-Tag: 1779146774-1659
X-HE-Meta: U2FsdGVkX1/+ogM3xSpFPOBqba92V2DjkYDbw1AIO9I5CKmHI8QJR4IJMeUHPyp0G54wcFP1w65pQJOMeAfBlExOBq4wT/ejbIOW2x+SUHPI5p5znVFr6jQMLy8rzmyBlqOmSNjvBtGzMtpGrHzKSEA0ZmrPAuc6tnRK7/O8NBho9/CMXs52kjmD3yYeTA1Sv6cRRPDkLOV7+2gxZzigfwgO6JmCRItOlOE0amRHj9VfqYw7qCP8MVFD7pL83ffJaIrKpATXPdSpzVuNMPVqRptryj+O8uLMYdgJxGrPM5HieOEbUlmcHmYbEeE9zkqLkMsaV4FANbSUfxYpvfEiTwPek13E6kWif/PHcYSk8UlMB1gFOxW/Ase6KJBbsOOquY1FgZVdYwvrPgUm+H7uoP1YCJqz1Vib+DG9j6DpKOlQgFCrjT+ljNyAlskmUdv47JAWZCLCGrcH8i3xS7O8ubTxOwOkrIG41TSv/UT22/kECeGEW1ECQsg38489m2ym/D7AMhJES2fTqYEs0X27pNWQ7Qg44gLDNEN7IZKa0Tkby1pVAIDrD4mg+k46ozFX9nve1SJk4eGCKudH8a+8yCGHk67pmoV4pNaIuSmsb3V4kbEC6tqQmg8Ao5qYv3arQHsp+ppwO/yf7MO6d+bwHL03wfEFAy3q8/cnj+EJQHZVgr6tY4mbsS3iMDFKxM6mb8qRqCcJ+FM27rsHjz6OAH5w3rFZ8Zs4tkwBFdtv1H+DRQALDPlkFzop5n7Co0bGq5ZWxV5I9QJU0rIhcNB8ZzIyjzyVDP6ybaOI2NTH0OcnsSOEnAEn5B5G9Y/KvOH0eYx8il/iVvHFbMVJAI5eK5AaGllgYHyBjLf1yr71jAJj539Z6qy9SGwQzVRPcIsNsWsu9h3gh1W6QJ4qa3KJNSl5pglpoRUUx250l9sZt+R/GcxJxmCffYzcoNKQqpTlRLKwvKJJC2ZiZNAn9US
 HxqJLKHN
 ruiPY1OKz0WAtZ4KFiyAy4Z5HPoCk0sZqHTNUr4XggpxIH5r9AZ99n28B4j2AHx5MoSKqIOiHCaPw4qTJ7midxFA0kr3OBHi1cY9CfOWZEmnk/MHJtliM+NTYUAc7zBtEZNvOEUzVVpOa+lKQ8JdqkofDDMqnrVtT271q2vhGgMAfcLVu3WDauDq1RoOl6MBnXcIhdLsyXpuU/GEfCBHX5rbXTsEW1sM8tpSdhEkkov4lvXbvof1dxqlFdqFLuB2u4fcEED7chO36n4aPGiY+xD1ERx1igIP8R2B1AXzncZIeQd7NQ7P4uN61yTLZmjCjs3SnYWeAyWTQFq0S5Ba6bVN2JRXsXdN0VhYnDc+p91cg1yA78U30++9f9rLp+xfGbkBqx8uhtweWODAkn/tv3a8tMsuKRGlTUxbi2MHxB9FbN0O7lN1+98kM/bhEn4qMlM57HTctgHpKee4bN01nxh9menJyXiPoWw81ncZ/rO6WGmvhjMuMfaCPISPhmTjux6BFs1i4BwOLgkSnTuNGJoaPfn6A/T6iu4sFVOE8VV1h3zEG24uBxx8gMq8QOwyL2nGw7cEJKyFbjXa4OLIdzFqu7g9W6IiJ+AZ0PQYnjqmFSs/43X6fb3X1vWFnn7HfRKuH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon May 18, 2026 at 12:51 PM PDT, Tejun Heo wrote:
> Hello,
>
> On Mon, May 18, 2026 at 09:20:42AM +0200, Peter Zijlstra wrote:
> ...
>> Should this really be part of scx rather than be part of the bpf-arena
>> thing proper?
>
> It's just a layer on top of arena. If bpf folks are okay with it, I don't
> see why it can't be a common utility thing on the bpf side.

Well, this gen_pool based allocator of arena memory is a temporary hack.
It's ok for rare allocation like in this at scx init time, but not suitable
for active arena management. We don't need to expose it beyond scx.
Having said that the fast and generic allocator for arena is definitely nee=
ded.
This break through with scratch page and bpf_arena_handle_page_fault()
cannot be overstated. It is a huge improvement for kernel <-> bpf interacti=
on.
Not only kfuncs can now read arena without ugly __get_kernel_nofault(),
but we can reuse mm/slub.c to manage arena memory!
The key idea is simply this:
get_freepointer() {
  if (s->flags & SLAB_BPF_ARENA)
    return (void *)(s->arena_kern_vm_start | (u32)(unsigned long)ptr);
}
I'm sloping a prototype.

