Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 866B7D0D178
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802276B0092; Wed,  7 Jan 2026 17:34:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AFEF6B0093; Wed,  7 Jan 2026 17:34:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBF26B0095; Wed,  7 Jan 2026 17:34:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 583DD6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:34:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 076C3C1FEB
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:34:54 +0000 (UTC)
X-FDA: 84306624108.23.ECBD8BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E5EC8000C
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:34:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kpIdvfQr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767825292; a=rsa-sha256;
	cv=none;
	b=Gkpb8kHfJRu7WOOwL+aCh0psdWKTMh16PT1eky3nHkbt9QFnkTLl6J3OEfYskmWEyRvL4E
	ryegPXwQADZN/6yVUUTCaSe5KEHhTHMaLriiTpvxriX8cra/huH3Pt5ByIZwbiO4OrSYoO
	WdxJ2Scx8H1eUmnTwrtRDLXtKKiUACo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kpIdvfQr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767825292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBe14BkMnVLNe36vJOnZUY6TnKEkENjDdjEohOJLB0s=;
	b=cwas0rV9rGEpRDtLNeK3R00VDDE/9H8aIxsviALlOn7SBqR4LrxtuDDapDBeKNoAUJFOWN
	EUmILpLttdk5N10OPRUnlQGZAxgKAn8Cim3c2nFszNgnhRt/wg7pDEGdBnwRImJHZF7Bh0
	1scXJEExoHpxPhfFTjniz0LQfnSo6Ic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBD7B60007;
	Wed,  7 Jan 2026 22:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF6BC4CEF1;
	Wed,  7 Jan 2026 22:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767825291;
	bh=u2djh5HTea2QgQAtKE8wrDS39r3GdGnQy6gR3KSDYo8=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=kpIdvfQrxqcdWmTnAlntF/vZqTBIV/dYi2cpN6FGularoO0Ce+glktt9n3X43t00Y
	 LbANnAjw7W2dRUg4YvSms29eNjfW8EpVkKrNu3jsJQWHmqkpRzcqsj91Ww9gyP55p2
	 WuIzknUf0JP43QyZ/MIzEjAR2xrb6j77mHBAahXUGWj5WTgcOwaBw1QwzP9XeGdYF2
	 AGMtFXAVr4h//JpvQhgYDNBGYAvYmzocfxWJXxBNhDZjmGCbGrWfXkS5sUDyIxi6y8
	 K2np+ZUVoKbW40KNeKgIKR5ZzTNlwtmcmcYe6MSgYJ0WsgpExgC3uQKp+t7t5e8wCi
	 7yFBeHOqhBoaA==
Date: Wed, 7 Jan 2026 15:34:48 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
cc: aou@eecs.berkeley.edu, alex@ghiti.fr, andybnac@gmail.com, 
    apatel@ventanamicro.com, ast@kernel.org, ben.dooks@codethink.co.uk, 
    bjorn@kernel.org, bpf@vger.kernel.org, charlie@rivosinc.com, cl@gentwo.org, 
    conor.dooley@microchip.com, cyrilbur@tenstorrent.com, daniel@iogearbox.net, 
    debug@rivosinc.com, dennis@kernel.org, eddyz87@gmail.com, 
    haoluo@google.com, john.fastabend@gmail.com, jolsa@kernel.org, 
    kpsingh@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    linux-riscv@lists.infradead.org, linux@rasmusvillemoes.dk, 
    martin.lau@linux.dev, palmer@dabbelt.com, pjw@kernel.org, 
    puranjay@kernel.org, pulehui@huawei.com, ruanjinjie@huawei.com, 
    rkrcmar@ventanamicro.com, samuel.holland@sifive.com, sdf@fomichev.me, 
    song@kernel.org, tglx@linutronix.de, tj@kernel.org, thuth@redhat.com, 
    yonghong.song@linux.dev, yury.norov@gmail.com, zong.li@sifive.com
Subject: Re: [PATCH v3 1/3] riscv: remove irqflags.h inclusion in
 asm/bitops.h
In-Reply-To: <20251216014721.42262-2-cuiyunhui@bytedance.com>
Message-ID: <bb259f36-6a5a-1bb8-75de-9bb62ade44a8@kernel.org>
References: <20251216014721.42262-1-cuiyunhui@bytedance.com> <20251216014721.42262-2-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 7E5EC8000C
X-Rspamd-Server: rspam03
X-Stat-Signature: iwcpozhzof4smwxq68zk4j8qc9awb584
X-Rspam-User: 
X-HE-Tag: 1767825292-851207
X-HE-Meta: U2FsdGVkX1/qWZwYJ5pOiQoHMcJHvkyBZpwwKrz2um+hSXr7JNMjcNABr0Oo+YiYFQmajx78sZvszxlGaUP/KbQUs9gcSpNJk4ZrDK5RQZajnKt2RmqdsXZfHJ5cKN67gm1WTwtPOW9rZg4Wh8dhWC4mP2fg9WjGQ01J6vy+Tmf4caW/2KEW86elDFdsvSz4NkiJb/VzQp+TDUXkwNuNkQE/LXvNVoVCbIOakimi6USSMXSSH2kLxdBzqrPT1HmI+G46+3ZYbLomfFG4SOWCXgltfIIjJCQdG7YOMmSsA907LfsgE6zJDjvjDPLXFtshlPImFfVuz4pkiIF5Qeq9hlIHXhzRWe2Tp+sUHCrANUbt42tydmXk94zDXupGBoFfWoP+2qL6IjY5/qg1uoMUqzvw0ED7cXolDwq1L79ShxOt/D336p3qv54PlTnwH8pBEjgBFQBU69zm95Dhgkt1ArmwVV2wXEdoAPI5UxIl/M5sGhI/DZpsFjhXOCVEgBvPY/Dmt+vrjnMnm/qbeQ9fcfG8Bg1RQGrCZ3Kpd/IaAnzBlbxl5XkidpzJNvwcE2Bqr+va5fT3JfXtxhe9bx2WgBs1/74lzUxX/Y0TJSkJ6ULT/1VlxgTZtcAiuX65hWc0tTgd4CdqZuY3MrhcbcQzts4qwg1U+e25f0tAfxrCnrzOspQD26mL28tcHzLYEE2FEdTctRTQu/xuiL2mVPCbTNR5mGiL5eT/QC0QDYzdi1GDm+1H9NmRtslmE7wXG5eLWu19txonrrLTURwFPwicOAERZryI0rrOaxzqln5nTOIe+eRDGnS0kKXEaHhotbVSxqn20P+FWoZuoeP+W1knnJOlUYXMimUKTZ5YErZc91MbJTDSdsEY6IvoCml4l3v1lRrGGRWfCkai8XMYhSwtN7J8cdQyvsOmbhEuK3tFy1HHXUYt19XC3zILs+dI2eh3bkzm4qN4VhcUQGsWkr7
 EvPGF4Pi
 LlYPqQl/t9Y091wdNh/nWzXvI3OpCpUSVLJT/3M5a6UT3xCXTYs33acXHvY1NqCkqQpdL9J3+6CEs3RL/df+cmaagwUhtSRypGOXmLtsNomHRhmGD5N01kC37jKMA/+TYPVQLASrHVJYzxL47fkD7H5FIedM2arcpbDveFEzvRjPimKdBlMwZBipLu3c1EPU5kd0eNFkS6MKJSZb5Oi5R8nu7f1rbZqGaPbO9RLs5Eam363cJf3NVxXHT9qAmuE9lhTof6M4wSoDMC2Kg0EzPJJ/W156YXpSAuevLVi4qbV99A5yQzJ2D4bB576mINhK+l/lZYjiGPxR3G3+CHhOSV9OYZlcmMUPEcX3r+j3MmZx+r0HAw5bF1kTA+l79OZuqWji6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025, Yunhui Cui wrote:

> The arch/riscv/include/asm/bitops.h does not functionally require
> including /linux/irqflags.h. Additionally, adding
> arch/riscv/include/asm/percpu.h causes a circular inclusion:
> kernel/bounds.c
> ->include/linux/log2.h
> ->include/linux/bitops.h
> ->arch/riscv/include/asm/bitops.h
> ->include/linux/irqflags.h
> ->include/linux/find.h
> ->return val ? __ffs(val) : size;
> ->arch/riscv/include/asm/bitops.h
> 
> The compilation log is as follows:
> CC      kernel/bounds.s
> In file included from ./include/linux/bitmap.h:11,
>                from ./include/linux/cpumask.h:12,
>                from ./arch/riscv/include/asm/processor.h:55,
>                from ./arch/riscv/include/asm/thread_info.h:42,
>                from ./include/linux/thread_info.h:60,
>                from ./include/asm-generic/preempt.h:5,
>                from ./arch/riscv/include/generated/asm/preempt.h:1,
>                from ./include/linux/preempt.h:79,
>                from ./arch/riscv/include/asm/percpu.h:8,
>                from ./include/linux/irqflags.h:19,
>                from ./arch/riscv/include/asm/bitops.h:14,
>                from ./include/linux/bitops.h:68,
>                from ./include/linux/log2.h:12,
>                from kernel/bounds.c:13:
> ./include/linux/find.h: In function 'find_next_bit':
> ./include/linux/find.h:66:30: error: implicit declaration of function '__ffs' [-Wimplicit-function-declaration]
>    66 |                 return val ? __ffs(val) : size;
>       |                              ^~~~~
> 
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>

Thanks, queued this patch for v6.19-rc.


- Paul

