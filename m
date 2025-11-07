Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F32DBCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 10:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1D98E000B; Fri,  7 Nov 2025 05:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592A48E0002; Fri,  7 Nov 2025 05:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8A38E000B; Fri,  7 Nov 2025 05:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 329888E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:27:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F07091603D1
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:27:29 +0000 (UTC)
X-FDA: 84083434218.14.52AA1DC
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 19F861A0004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:27:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0/Ahdojn";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of glider@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762511248; a=rsa-sha256;
	cv=none;
	b=apkG/CLPxAWE0lgXAAzwFiFB5aRJlYU7EU7r6tI2nj7JcCuvTDhx5FXSUOEtyLvkOwTncc
	J/gI8+OlIh6734fWWm4Nowg2tHtxRpCvVLtdTpz4ZscooB4+Ztu/X06R4Y0cy3BYGgFckp
	4IosMUQxekAoA1kGpezfc3d2IXrmyf0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0/Ahdojn";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of glider@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762511248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLhtIptgftMWRvfp8mRlQOiL9wA5G5qSa8Z4beNB3RU=;
	b=bmybFZjt4bLzxdVZjXtgLq7t1kzGLi+DMgW9bTasx86VKkIaPiDQC6ADaeIm5moPD02GWA
	B8Nw9T4xlziQ5/X1F7iT7NFaUTVQz/nQLcBpeerKCdPjdmVIcLICS1spmW+lMu9byyxs30
	IgXyoCGwPrgVOsJtI/4+EMZl2scAcus=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8801f4e308dso5897226d6.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 02:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762511247; x=1763116047; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pLhtIptgftMWRvfp8mRlQOiL9wA5G5qSa8Z4beNB3RU=;
        b=0/AhdojnFyiBMZzCPpntJobJGOeFXUvzbapdadJSEsCKLXZ2KwbvZ2GRHfoOmup8tV
         Ct6gmKr5WE1XT3kdkRE7DQ3FO7VIBU7pR0ua4pQIbkHLSExEALfDOSnrGMRj+HlDOx7D
         /roEKJNM4yocivAUfXKxSZwhBEs/DqNQXGXUhyaf/f5GTvN+3D5M1+msy0tj5C8u4tsb
         hLg0PCFBJyp/AB1lAw6V/SUvnY0QkOC5V+GPTNJSDEkhnIqPuvzn2EMhnvD5vURBW6KE
         2nIfbYh8DED/H0wKMTxXc7Ug8jhJvIKQryvXfJw7qO2v+nMdL16QyH8yf0YvHr3HLXWK
         WhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762511247; x=1763116047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pLhtIptgftMWRvfp8mRlQOiL9wA5G5qSa8Z4beNB3RU=;
        b=wBSSHFmiisQ8CF2qwEBwz/OacSPb61UKHWzy3XYqk5655HGHlzIJOksfo8gESWrX4E
         j9fHMaoBEyvp7TKWATlWNOjL/gqapSXkY/ah47haRmet2+rfO/eeKJFGJUcI9IOLQdG7
         pPi3iKGIMV1JYHxJKdFyEcukb7ZNISI1tHncc7NZrbguVwgjPW9Qi/o/huQzg163VX/9
         67sEz5KLJ+AwhrmiHfbH3U7tvyzHAI6Y7uuB/z8YcHcp2ubCQQQjNRTihUm0oAcKZGVr
         XwLBQDe9fhp4jwGSBO1cxWkcnSGAMQTPJa1PMdec6J75VLFRKfse0hfWaE/uwyCdASCe
         TJkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4hzVRn4hHSS2IKxMK/utKmpZp30EYDx+GJZXdaRuCkoL5RYGmxRu9YWQ6pbL4qWqATq/0yYvXVA==@kvack.org
X-Gm-Message-State: AOJu0YxQPF4F8MpQ1ZJb0IiGM2nt8JLE29EYNk/tu56OwpuIXEricwJf
	E1foszVUggi5Ftb6axg2OqAKaYg1Lo1/d7a+lGzUbGc0Q1TuCBxfp9qWEsUlnRrE983OKRMJGKq
	yLg3hQKFMpi61Eu230sRnwmFqSU0UnerhmVjXf24w
X-Gm-Gg: ASbGncvw3LmlXHyPB1ZtDZWmH2yffKPENxUvjBacvyDxHph+VXu5slC/vBg3PrVGot9
	hqQJPr2T0wrHTzNizGGx2ZZOPZvm5Yif7TqXvjpcb2q5Y5bv8l/nC66V1Bt4FOZcR8rlhMZFNsO
	p1yA3kCkMSpXBAuXIUM1tS5Nr6OT2roNOzz/BUNaq9dqMBY2XGXKOnPGolWz8AU1Gd7EH3zKaSt
	gNyFWQ9LIR1fWqBUTBzPTyaWnUEPlmaSLczRxYNrz/VF3yuSaPS6rKwUfF0I4AwREB5v+QKq6nj
	U/0AbumoW/sQQB8sskzwfHeYYQ==
X-Google-Smtp-Source: AGHT+IHGzRF/1cbs/MsDVPOx8UJ49URwz8VUyR081sUbxE8+sqheDOB1N7EBEDuZ+mpR05WsdF19S4wEHS/n0A2MIu0=
X-Received: by 2002:ad4:5e8c:0:b0:87c:fbf:108a with SMTP id
 6a1803df08f44-88167afbb01mr33443336d6.10.1762511246798; Fri, 07 Nov 2025
 02:27:26 -0800 (PST)
MIME-Version: 1.0
References: <20251106160845.1334274-2-aleksei.nikiforov@linux.ibm.com> <20251106160845.1334274-6-aleksei.nikiforov@linux.ibm.com>
In-Reply-To: <20251106160845.1334274-6-aleksei.nikiforov@linux.ibm.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 7 Nov 2025 11:26:50 +0100
X-Gm-Features: AWmQ_bnF17f6A18RySh-hO3pa-QL803fyOZqBKR4ZjbBOIO0pB_5mi0dYohMDnE
Message-ID: <CAG_fn=WufanV2DAVusDvGviWqc6woNja-H6WAL5LNgAzeo_uKg@mail.gmail.com>
Subject: Re: [PATCH 2/2] s390/fpu: Fix kmsan in fpu_vstl function
To: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Cc: Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
	Juergen Christ <jchrist@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 19F861A0004
X-Stat-Signature: 83bdjkah7yfz1hip7uec76bgso4sonwf
X-Rspam-User: 
X-HE-Tag: 1762511247-977886
X-HE-Meta: U2FsdGVkX190of2lq+K9KWBoUqx5wULHA4NfEKVrHkaqWwhXy6eRk1IQcDC4u0zl4l9YEehSXvNPLdOonC9YGzn3TIs81fUnE+okKshxasLm6Jw8KYwpggaULuK8pw11OJ8ua4Rp4pfiQm1PNP476ciUgjv1Mk2dyy0zOwhBcF5hZZ/Su/s2mCLeoQwEqKThVamgNOgF3oRLN/rF2LfCHd7ENQWwAGyIXtrhRXv0uJ7duodYLUo2c4pzuKBmg+a1bAHjeH+iFQBdfyhE7nRi32ouWfTBkQkt4tGSga3Cai8FvvlEdQPzVRZSkdahE4dKgyurD9VNmCo3gZcjrocEikkKADEfQ6IFFtVZGA+GmlCJhp7gHjphlBtTLeG+PRyoCUam2zPCQN+CLkZBygBMm8I2U/+de7AbXJnqIFu11zncdPV0VdsalRwFK8eXAL/fpJSdPvcTzmnSJPYNzGTEexg9NfwpsZshACMI1lDefptt0Yo6fL3rplBhyUh+HtmcNjAvchAGAFbbHWo4zlbxoZ1u38uRabvf2wreQyt/eGuyCzejBGi3B+J+K+8jxAdhoUhiDeAWKMGnDR1bmkEXXi7HLGR0PPisplExghIyWSugCUGvy5GiZNRkfvVH7MpWhXkDoKOiKKmZ1gtwfRbuFs7qknW7jBH8dC8EyIU4L0N2YNwGAJ1TN1DIX2Xrjt4UgrzbF2TriFnCe5R87Bu63bqLhG2extxJ88uaz7S5pzMR64OV8GbVHtQnLL/IhHGaTkAdXQeULAds5UdaiGDjYOFOPfqTpSHwg62TCG7dxwOu3OLvaBFLCqam/h14GQahI/7ywyzhCKnGfbx4NROUK3eg78AtaAJnywvJz19ONMR+wiZkjPDAzyDgqgA5pf9BqSuPcu4p3BFW2K3BBR/dEO94wI8QxN+Viq2qdCMAanWcFStyS36r/ZJb86DRUDohSurukoNHW90nhh5xhUm
 c0gpggxY
 Dkb+VlsoNlcGcFgtf8xtkR2bLwH9+lJI62kFWUUUUfo/v3N7VGfFOSFrC5LByb3wYwRd725JRxkiF7tz+cNhmxDfw5km0Tw8FXz2HVaTiW1XZzgndPgEcuYoBykmNneDrsmVV4SVP4fUA+qaMbhGmNR10Bh2vyfK5OvW88kdwS+sm2clUwsYlA3ckVg6RwkyoTuW8jFkWiRqSUIl6LJCxniuQbjfJ7Glgt8XQejz0ajFLyc4MuLmeX7WAexbwmbTA0/qbw+sJtBovFbc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 6, 2025 at 5:09=E2=80=AFPM Aleksei Nikiforov
<aleksei.nikiforov@linux.ibm.com> wrote:
>
> clang generates call to __msan_instrument_asm_store with 1 byte as size.
> Manually call kmsan helper to indicate correct amount of bytes written.
>
> If function fpu_vstl is called with argument 'index' > 0,
> it writes at least 2 bytes, but kmsan only marks first byte as written.
>
> This change fixes following kmsan reports:
>
> [   36.563119] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   36.563594] BUG: KMSAN: uninit-value in virtqueue_add+0x35c6/0x7c70
> [   36.563852]  virtqueue_add+0x35c6/0x7c70
> [   36.564016]  virtqueue_add_outbuf+0xa0/0xb0
> [   36.564266]  start_xmit+0x288c/0x4a20
> [   36.564460]  dev_hard_start_xmit+0x302/0x900
> [   36.564649]  sch_direct_xmit+0x340/0xea0
> [   36.564894]  __dev_queue_xmit+0x2e94/0x59b0
> [   36.565058]  neigh_resolve_output+0x936/0xb40
> [   36.565278]  __neigh_update+0x2f66/0x3a60
> [   36.565499]  neigh_update+0x52/0x60
> [   36.565683]  arp_process+0x1588/0x2de0
> [   36.565916]  NF_HOOK+0x1da/0x240
> [   36.566087]  arp_rcv+0x3e4/0x6e0
> [   36.566306]  __netif_receive_skb_list_core+0x1374/0x15a0
> [   36.566527]  netif_receive_skb_list_internal+0x1116/0x17d0
> [   36.566710]  napi_complete_done+0x376/0x740
> [   36.566918]  virtnet_poll+0x1bae/0x2910
> [   36.567130]  __napi_poll+0xf4/0x830
> [   36.567294]  net_rx_action+0x97c/0x1ed0
> [   36.567556]  handle_softirqs+0x306/0xe10
> [   36.567731]  irq_exit_rcu+0x14c/0x2e0
> [   36.567910]  do_io_irq+0xd4/0x120
> [   36.568139]  io_int_handler+0xc2/0xe8
> [   36.568299]  arch_cpu_idle+0xb0/0xc0
> [   36.568540]  arch_cpu_idle+0x76/0xc0
> [   36.568726]  default_idle_call+0x40/0x70
> [   36.568953]  do_idle+0x1d6/0x390
> [   36.569486]  cpu_startup_entry+0x9a/0xb0
> [   36.569745]  rest_init+0x1ea/0x290
> [   36.570029]  start_kernel+0x95e/0xb90
> [   36.570348]  startup_continue+0x2e/0x40
> [   36.570703]
> [   36.570798] Uninit was created at:
> [   36.571002]  kmem_cache_alloc_node_noprof+0x9e8/0x10e0
> [   36.571261]  kmalloc_reserve+0x12a/0x470
> [   36.571553]  __alloc_skb+0x310/0x860
> [   36.571844]  __ip_append_data+0x483e/0x6a30
> [   36.572170]  ip_append_data+0x11c/0x1e0
> [   36.572477]  raw_sendmsg+0x1c8c/0x2180
> [   36.572818]  inet_sendmsg+0xe6/0x190
> [   36.573142]  __sys_sendto+0x55e/0x8e0
> [   36.573392]  __s390x_sys_socketcall+0x19ae/0x2ba0
> [   36.573571]  __do_syscall+0x12e/0x240
> [   36.573823]  system_call+0x6e/0x90
> [   36.573976]
> [   36.574017] Byte 35 of 98 is uninitialized
> [   36.574082] Memory access of size 98 starts at 0000000007aa0012
> [   36.574218]
> [   36.574325] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G    B      =
      N  6.17.0-dirty #16 NONE
> [   36.574541] Tainted: [B]=3DBAD_PAGE, [N]=3DTEST
> [   36.574617] Hardware name: IBM 3931 A01 703 (KVM/Linux)
> [   36.574755] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> [   63.532541] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   63.533639] BUG: KMSAN: uninit-value in virtqueue_add+0x35c6/0x7c70
> [   63.533989]  virtqueue_add+0x35c6/0x7c70
> [   63.534940]  virtqueue_add_outbuf+0xa0/0xb0
> [   63.535861]  start_xmit+0x288c/0x4a20
> [   63.536708]  dev_hard_start_xmit+0x302/0x900
> [   63.537020]  sch_direct_xmit+0x340/0xea0
> [   63.537997]  __dev_queue_xmit+0x2e94/0x59b0
> [   63.538819]  neigh_resolve_output+0x936/0xb40
> [   63.539793]  ip_finish_output2+0x1ee2/0x2200
> [   63.540784]  __ip_finish_output+0x272/0x7a0
> [   63.541765]  ip_finish_output+0x4e/0x5e0
> [   63.542791]  ip_output+0x166/0x410
> [   63.543771]  ip_push_pending_frames+0x1a2/0x470
> [   63.544753]  raw_sendmsg+0x1f06/0x2180
> [   63.545033]  inet_sendmsg+0xe6/0x190
> [   63.546006]  __sys_sendto+0x55e/0x8e0
> [   63.546859]  __s390x_sys_socketcall+0x19ae/0x2ba0
> [   63.547730]  __do_syscall+0x12e/0x240
> [   63.548019]  system_call+0x6e/0x90
> [   63.548989]
> [   63.549779] Uninit was created at:
> [   63.550691]  kmem_cache_alloc_node_noprof+0x9e8/0x10e0
> [   63.550975]  kmalloc_reserve+0x12a/0x470
> [   63.551969]  __alloc_skb+0x310/0x860
> [   63.552949]  __ip_append_data+0x483e/0x6a30
> [   63.553902]  ip_append_data+0x11c/0x1e0
> [   63.554912]  raw_sendmsg+0x1c8c/0x2180
> [   63.556719]  inet_sendmsg+0xe6/0x190
> [   63.557534]  __sys_sendto+0x55e/0x8e0
> [   63.557875]  __s390x_sys_socketcall+0x19ae/0x2ba0
> [   63.558869]  __do_syscall+0x12e/0x240
> [   63.559832]  system_call+0x6e/0x90
> [   63.560780]
> [   63.560972] Byte 35 of 98 is uninitialized
> [   63.561741] Memory access of size 98 starts at 0000000005704312
> [   63.561950]
> [   63.562824] CPU: 3 UID: 0 PID: 192 Comm: ping Tainted: G    B         =
   N  6.17.0-dirty #16 NONE
> [   63.563868] Tainted: [B]=3DBAD_PAGE, [N]=3DTEST
> [   63.564751] Hardware name: IBM 3931 A01 703 (KVM/Linux)
> [   63.564986] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Fixes: dcd3e1de9d17 ("s390/checksum: provide csum_partial_copy_nocheck()"=
)
> Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
> ---
>  arch/s390/include/asm/fpu-insn.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/s390/include/asm/fpu-insn.h b/arch/s390/include/asm/fpu=
-insn.h
> index 135bb89c0a89..151b17e22923 100644
> --- a/arch/s390/include/asm/fpu-insn.h
> +++ b/arch/s390/include/asm/fpu-insn.h
> @@ -393,6 +393,7 @@ static __always_inline void fpu_vstl(u8 v1, u32 index=
, const void *vxr)
>                      : [vxr] "=3DQ" (*(u8 *)vxr)
>                      : [index] "d" (index), [v1] "I" (v1)
>                      : "memory");
> +       instrument_write_after(vxr, size);
>  }
>
>  #else /* CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS */
> @@ -409,6 +410,7 @@ static __always_inline void fpu_vstl(u8 v1, u32 index=
, const void *vxr)
>                 : [vxr] "=3DR" (*(u8 *)vxr)
>                 : [index] "d" (index), [v1] "I" (v1)
>                 : "memory", "1");
> +       instrument_write_after(vxr, size);
>  }

Wouldn't it be easier to just call kmsan_unpoison_memory() here directly?

