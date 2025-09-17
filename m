Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC651CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4411D28000D; Wed, 17 Sep 2025 14:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41918280002; Wed, 17 Sep 2025 14:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356AA28000D; Wed, 17 Sep 2025 14:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 24F74280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:41:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3AFB59FE1
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:41:03 +0000 (UTC)
X-FDA: 83899609206.15.B72645B
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18426C000E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:41:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ramjtu2R;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758134462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4m40o9ZPKTMCwPCfIJV5wUzBbdpAJYBIhwgx5ZOVek=;
	b=aGoiPuX15rOCibyK8HocfhG37s5YeNRSdhgxMtcveIrrRuKGQSCqr06kr3XR+e+e/Itzg6
	HTPQ0hYeNLqD3NzeX2rJhTcj5GcgODqVsUYr141QCTeeIIarCYz8CXVNNvYShFwebJExGU
	n+8s/u4FN31MZwIglYFbP7WJh9wKb+c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ramjtu2R;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758134462; a=rsa-sha256;
	cv=none;
	b=X7fQ4KsxailZzu+kEu/5NU683exOyu9aZvRpGY2qk4tpiOy8D2IVtjX9wXNSnxbd30syfu
	Wlde0cw/Tk1lMy7SfsjOLPvUmqo0vbZlF+yxc5j6xMwKBlGYn7l+6kjMWUi06g0ql7lAzZ
	o6jd04RFUFl1Ge97rLmy3V7UTNOdI28=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45dfb8e986aso1022925e9.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758134461; x=1758739261; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w4m40o9ZPKTMCwPCfIJV5wUzBbdpAJYBIhwgx5ZOVek=;
        b=Ramjtu2RvZstsTIrQ3acP6TAcKjmXRrRqRL3h16tzHrsLnECGdAvjEAkVN9BUblqfT
         2dry1kRthWKeM9T+SbdBpRSg2Wh5O36SGuBrdgtY5kZNFjRpPCUt1viId1KUGLxerZa3
         wkbnfdiFCQXeo5xePQlHIvwR8osKpVWuh7x8OIN20D70YdHyoTB+C6NQzH1T9Ipcygs6
         XEXWq2p59GjUezm+sGTAyQf6LxjWMvUFiCLLkHW9gycDwDFWVOT9mrVDnL7+v/p0EEsg
         o9GNl8fGEPU0a0dPluRZ11FeI8/dw2UKiRXp93zoATxYp8BSwJzVEZHZ5JoMK0OwlXPG
         llKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758134461; x=1758739261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w4m40o9ZPKTMCwPCfIJV5wUzBbdpAJYBIhwgx5ZOVek=;
        b=YbBn0AKAbTpehDzJOq9zUV/NrGnH2cC1DbzZNajU9MBpk7J2YBROpmwa9nvPMPA91Y
         deh9aTVr2wAyLsqprqQ/8JYeWPt4GKpD52MEImegZmbwr9tT+UjPIWwzT2XO2wOt76YO
         SRygi9CThifs0oxXPA05WmUFxYHXZdNMsNZo5jJ7Qx7QtWrKNn20izyjHGWNgcMa+Uv4
         U9LBjDv9/3QvdZukCMyGowa25RUPpjg6X8K38Bgz7/YhNOf+FX1299v6qI4pJrxLeM3n
         S61qUbwrG5dYsASnEqe1e8XPOFv3XEBSzkg0KoRbyDJrqjEuUChe8ochwhyaYMo4AbEe
         ETZw==
X-Forwarded-Encrypted: i=1; AJvYcCXvGN4/x072NhOLmm2Dnlie5KfETwM4iwKTrenqd13Egu4yqF5j6grkW8gMfodEIf4STubjutEryQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1dMmc29HoJ9Xc73DwQlkIFMUisGZX+GffRIfGasy8AwvqRPts
	po35UFXZGJQA6sHIdlJXMQ23LLWDjyg26MdqHsysI9iU/rKzkP3VzoRUYjJ+vPaf6xh0CStu6Ni
	g8e1C4kc83tS9pQhAsudtleYzasGKwIE=
X-Gm-Gg: ASbGncu8qINTscmiMDbvQHw9QcILTHY7XBMYO/y76sW7xTIkNRBVP/cRrWAfRbErBYu
	ax1s8O5y4pCaPXA/aGAf05WNy6R3S6PoYstIUaYX/w3Mheb/soG6WFDDOX0BV3+z6QzjaYM+bfS
	IjrJO261fR2xbAooJQZV/7P7XZ5hkFu1aARKfmFjVFvng+tAheD3iqeRaEgmc3Loy7i5j4RUXBT
	qwQJvGjN4mujD9QNAkOqg7G7KiFzvDhYdj5
X-Google-Smtp-Source: AGHT+IEr/Zm4Pxly+Efbv6sNYcUut7LfEU4UTikXIVrxYEdaISjLHguHk43hV30oxPl4SaJojIG0lHAi9h0Ph0jNBHQ=
X-Received: by 2002:a05:600c:450f:b0:45d:d8d6:7fcc with SMTP id
 5b1f17b1804b1-46206a2b929mr28099785e9.27.1758134460571; Wed, 17 Sep 2025
 11:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
 <47aca3ca-a65b-4c0b-aaff-3a7bb6e484fe@suse.cz> <aMlZ8Au2MBikJgta@hyeyoo>
 <e7d1c20c-7164-4319-ac7e-9df0072a12ad@suse.cz> <CAADnVQLNm+0ZwX2MN_JK3ookGxpOGxEdwaaroQk+rGB401E8Jg@mail.gmail.com>
 <0beac436-1905-4542-aebe-92074aaea54f@suse.cz> <CAADnVQJbj3OqS9x6MOmnmHa=69ACVEKa=QX-KVAncyocjCn1AQ@mail.gmail.com>
 <c370486e-cb8f-4201-b70e-2bdddab9e642@suse.cz> <CAADnVQL6xGz8=NTDs=3wPfaEqxUjfQE98h5Q2ex-iyRs4yemiw@mail.gmail.com>
 <aMpdAVKZBLltOElH@hyeyoo> <aMpeADsz1Znaz8AU@hyeyoo> <CAADnVQ+sKKV+-Ee61Bxma+=MN4unGLRypAnfqHuLOtHM6T=HEA@mail.gmail.com>
 <ade5442f-6257-498f-bffd-5fc4b1d5858f@suse.cz>
In-Reply-To: <ade5442f-6257-498f-bffd-5fc4b1d5858f@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 17 Sep 2025 11:40:49 -0700
X-Gm-Features: AS18NWCKkOmsGuqHqNCm235rRDn6_iVaWC-ke90mDrNQHKL2y4zWb_MZh87_Ljw
Message-ID: <CAADnVQKfj23PocEfe1XMa6uMz0N-Z4O9YG+JqzY5E3_bLNA1Tg@mail.gmail.com>
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ubxbqjba796556o4c8exsmpoxrwxmakr
X-Rspam-User: 
X-Rspamd-Queue-Id: 18426C000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1758134461-698841
X-HE-Meta: U2FsdGVkX1/pLhlHnGHupB/P7Y/Z+LWg6vEuXJ3z3qYxxgZeidsB6PB+jrTVl9/KWuti/8pJPajGelZGwUa3BcHINMGdewGCwTo0bghxqpgVwfzjZ7eHTSsxPnhyQSQRDNNfkSd+gZnqaS0B75N1X3iTXmbChx1HtiQibDJ7wYXvYBZg4ikmCkuWW0mW70IM2IEkHyEESiz75NTS/2AtXOIi+WPSXZS0BNvieAUhGuTrEutXbkKS/KEPtS5oIOTHkOqwz87JQmmc4hd26NX23wkCazr/D8Zk8dEuY4dlGsMYuXCU1zYHc7yxVHgdDROB5sNNG5wR/qMYS4/s6RQe0xH8yzp0VmHB8CAMJNB8X3V9jiISlUhZOq8K5HDf3VN5tvbQOlx/68UdjhAifvhtpMp1cO+ba+u5eRxVOPqznXG8QU4IJ8ZanDB0Jby7wGj04OirStH5UcVZa7nLdVdwxbyq43zpiTamgb+1qeM7or0cJTpgKn9MQjy4qztuM0XkT63dKAr21LWLe3WH2RpjdJDEupib53dkWrBlZbsbHzQVEVsTM2yjvEPjQfETN58QvzYOKCvg75Oi4t+ODgAnUuSonYkDkh0BxnBnlI/HwIa7mpi8RtmjFofs7dXscVzCg2Nmw6MwNcHQsvNcmP2TTiHgETW4loTV5Hawrxj1vDLYrw6Zl+QbIr97dtiMjG/NrA8r3KdxQWweBFAdRlE3/oZ3wLC/bscv1n499LA4vSs94Lvh7bnuhNS+S8gJnOuic0y3v8PlwBDDI6/SJh1mwmWWdnY6PProRd94GZ1qAJXeyd9/k8Gts1WtAWPkxZt4PS176pYCja+yaL+UqK5+NZYBNyr2N5X7ApZtFsj4PLUNSJbsWIzWuqFgWXfiLYk0kqfQGWbqbcWjE69/IcVH9OuXCnMWIvEBNkxGcQRoDyL+hV/FbdX+3cpA8+lNBbHoGtPkvixTD0xXmPceq/a
 CuZZ8IiE
 17QaT+/eYymb61ibas28jLyFGH5aAh2ekeuI43ICSrEEHUKqO0pnlKg6zbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 11:34=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
>
> Ah right, I did add one based on your commit log and this conversation:
>
> +/*
> + * We disallow kprobes in ___slab_alloc() to prevent reentrance
> + *
> + * kmalloc() -> ___slab_alloc() -> local_lock_cpu_slab() protected part =
of
> + * ___slab_alloc() manipulating c->freelist -> kprobe -> bpf ->
> + * kmalloc_nolock() or kfree_nolock() -> __update_cpu_freelist_fast()
> + * manipulating c->freelist without lock.
> + *
> + * This does not prevent kprobe in functions called from ___slab_alloc()=
 such as
> + * local_lock_irqsave() itself, and that is fine, we only need to protec=
t the
> + * c->freelist manipulation in ___slab_alloc() itself.
> + */
> +NOKPROBE_SYMBOL(___slab_alloc);

Perfect. Short and to the point. Thanks!

