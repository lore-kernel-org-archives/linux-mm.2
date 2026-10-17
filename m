Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 883A7CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 15:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5891B6B0088; Sat, 17 Oct 2026 11:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A756B008A; Sat, 17 Oct 2026 11:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450F06B008C; Sat, 17 Oct 2026 11:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DEE36B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:54:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE547A7A65
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:54:12 +0000 (UTC)
X-FDA: 85332564744.29.A31A20D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 56F2A100003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:54:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPlOkLY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792252451;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zR54dX5mGu1eslkqUMjenGYBFjPvHaWyaxWS+T8+F8A=;
	b=1b9W3JJizRYbZ/dBVr4gHWlNxGR3gZXLt4ApOzHhciImljGn5lOq7NCXgx4G2m+qLfn7FW
	/NHpuLXTCk9A3j0edHiYbcAKu9AxMg/sYBS472mb2klUBdPufTI20np/JOSlWXkGrt1Wvc
	dICgq3fvcTD0cwrGL15NN+nArJdnlAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792252451;
	b=wSbqVHkIi2G6H7a9rF7CPl2q5WMIqlb7bx1CfkBgxp/ctur4Oq/iTJXxszNYuyTFGYHB+s
	4q2mYaSuiRIhe9lMrya6vmB30YJ0ePvUHdmeJGGvjJGaOMdNZ7A1Oo+NhXKUI/acJw8i1N
	ZIVeu1+iKQr6qpJTPMPFm0LBVHL0lzU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPlOkLY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EDCF602BA;
	Sat, 17 Oct 2026 15:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EB01F000C4;
	Sat, 17 Oct 2026 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792252450;
	bh=zR54dX5mGu1eslkqUMjenGYBFjPvHaWyaxWS+T8+F8A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hPlOkLY3drAbSzxoixpsfbX+/90+C91WbIUKsdvpmRCXqChJck060CdGxWd53JAeW
	 avl16jlf/Wk/+SsZ7OhCN8avfGuLTo9TQUOaYto2vnncJ2tnZALkRDJpQ4kPj+gTtd
	 J5s5k4c+xEKgrPu2YuJArn3qynMR6As8UarLIlJTRmEWOZZEDL8M+RGMHFROs36HfZ
	 yIYQ+ZCMh0FA6+WB2y5oraOHffhPZRzxlV5p8zyTaDTDJQh88z4LzNQLXW0V3Xs+nK
	 3zyePagoIJwbjnW5t05EvYGDGjIpjxOtJwAFnI98HrFTq2Vup69VE7CP+XSEFyULOw
	 QXgoSKDbP0UzQ==
Message-ID: <sashiko-outbox-175617@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/slab: Call call_rcu() directly from
 __kfree_rcu_sheaf() in any context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Puranjay Mohan" <puranjay@kernel.org>, linux-mm@kvack.org
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261016155340.3304319-1-puranjay@kernel.org>
References: <20261016155340.3304319-1-puranjay@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:54:09 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 56F2A100003
X-Stat-Signature: zriza7rirdf95ggggh8rnzz9r7jz37ap
X-Rspam-User: 
X-HE-Tag: 1792252451-137797
X-HE-Meta: U2FsdGVkX1+U2hqvTwuNHBPUU+YyEk0Y663czfYHXsMUVkx78j47C2PjrtHj9P/6ATYxI0FplsSRd/ZrurE2f+Y7Yfj6gC6XNvUFCuu48jHt2FZw+q6U0aEmcjUQ711us12DrWGp4ikZDU0ei/8NJgLOLAMJ1i5oQOaoNvBC+tIhUHUyhXhmlRvsjK2pGqt31uvnwIaYnhU4go39ZBvvdoBhufvKgHhphqfI5SIoX96bnJKWSXgo+vU7hiJlKyr3X+7dTgOtiwatet33La/pGdqOP4wDx7vx4DV7NWcDh5M/RKuTLSvLNVNaXvfqSu4sswrR82cLXdQc9ugsJVAsWdzF85EmZzb5H0I0LOKgvbRyT0YJUOGYis1WHpRPLT2oA16sy+m4Ev2VGJ6Lmf0EtCPN7NeGKrmvS12CiamcOk1vuuIPB7A4tcY5IPoyTeAQ4rTulZ2xD6dZdD3zRCN2uekzMiufobTo4ZuqmUE1GVvKvdusEEPtxdQcFOx6/VfvTlMuYeJftCnBmp9VO7rUPdLZA1l0/jDBwVvoEUZRH1HPKLuCaTBFBpRM3wlhAcdOVIpKyH3g/BciOd6Bd8pOOMnKshW0gEUfYsXu5JzdyLip5hA0oROYKxWEDTCLnVKMARyrf76F0fs2v23D4/vm1PRuq+/wx5LEj08rypwl/ZtHEEVypC4bSLxoE4JMhsC1Xeww5JxV1SWD8rp1M431jDJlIR5aFZcri1PM3h3SHzWMgs2eFdDmSbAYp2Knad9c/HlhexWn51hGqZE2YSIwVqOyK683q3dgZq7DUUnAGL1HxVV/sFdrjvsD+Bnxh4cgUMhkN/AdHqXH9ZN/erHZM93+MnmqjU8vtQWu3BDB+Az5Xn4bixu0RYojIKbSgK5RUBf28/fLN1RLAb3QicrbaoTvDHGqy+0G6N2MNnoE3otm8jjSJvd9oNhRPYvGOKfCGfx0pbzzgiQSSGGVM4G
 bSmcucFV
 qGnw2mJmxd31ZYWgwFAvmylHizZ6ZFkKowhWZFbPQgbcsqKHrWUWyUEU4ShFLJ6iIpMlfRpqGFMoDXv1kMYSf6qgW2wBVDIYFCd1NPK71xByzIJvO8SpK7hEa2Suvb9wniquQQQVbILaayvwX9XBK6a6Fx3xEajPy4YU2GivReu3bMLDygjNezz7KFt6WINCJg/vYaoSGGEVs/D1vHjW2PRSITnk37LTkbiVdNvRLg3guY4Pzg4ezEjUE8nWnKloBNskq+oUQFb2+wNmtpmAzqsurYygKPw/JnT0UB8zL2nZOoL/MmMcigGmNyNUbOPBSYv2X3P2/4PqDiWh8pmMcuRAlGrgw1YgY48waWt8mcCeXbdQX6rHsrFvNpBWzhMaw9mSt/spSKPYeH9g2/m3q9ZdhxjsV+/uHChOCvNGrlivW9jY+8IkN8TzhlcIbeYBcb2l/e2zq/sYLbFkvJDZrEc0+2VYMGx8rSgs86dWZl+UxdLZYxlHCRe+eX7sTKyxsPeUL7SANDSCMQAjox0zH+7hr3bKAYwMA2UuItryp4DPCBfvfYNrQ7leFt9puPv2ESWC4m9yXcZkcItXoD6Rs9cDZX3ID40kY2wzVetly6s++b6Y+h67XxdMUTfMEpdA5AXKU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: call_rcu() list corruption due to reentrancy from NMI
- [Low] mm: unused llnode field in struct slab_sheaf
--

commit 81da114bf5411864e59d873df170399156acac6d
Author: Puranjay Mohan <puranjay@kernel.org>

mm/slab: Call call_rcu() directly from __kfree_rcu_sheaf() in any context

This patch removes the deferred irq_work fallback for rcu_sheaves and
instead calls call_rcu() directly from __kfree_rcu_sheaf() in all contexts.
The commit message states that call_rcu() now natively handles reentrancy
from NMIs.

> diff --git a/mm/slub.c b/mm/slub.c
> index 8fbc6bf8ebc51..6c44f4495db5a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4145,7 +4145,6 @@ static void flush_all(struct kmem_cache *s)
>  struct deferred_percpu_work {
>  	struct llist_head objects;
>  	struct llist_head objects_by_rcu;
> -	struct llist_head rcu_sheaves;
>  	struct irq_work work;
>  };

[Severity: Low]
This isn't a bug, but since this patch removes the rcu_sheaves list and all
its associated logic, should the llnode field in struct slab_sheaf also be
removed?

It appears the llnode field in struct slab_sheaf was only used to defer
this call_rcu() invocation.

[ ... ]

> @@ -6308,22 +6306,8 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void =
*obj, unsigned int free_flags)
>  	 * we flush before local_unlock to make sure a racing
>  	 * flush_all_rcu_sheaves() doesn't miss this sheaf
>  	 */
> -	if (rcu_sheaf) {
> -		/*
> -		 * With !allow_spin, we might have interrupted call_rcu()'s
> -		 * IRQ-disabled critical section. If IRQs are not disabled,
> -		 * we know that's not the case.
> -		 */
> -		if (unlikely(!allow_spin && irqs_disabled())) {
> -			struct deferred_percpu_work *dpw;
> -
> -			dpw =3D this_cpu_ptr(&deferred_percpu_work);
> -			if (llist_add(&rcu_sheaf->llnode, &dpw->rcu_sheaves))
> -				irq_work_queue(&dpw->work);
> -		} else {
> -			call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
> -		}
> -	}
> +	if (rcu_sheaf)
> +		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);

[Severity: High]
The commit message states: "When it is called with IRQs disabled (from NMI,
or re-entered from instrumentation), it stages the callback on a per-CPU
list and re-issues it from irq_work."

Looking at the implementation of call_rcu() and __call_rcu_common() in
kernel/rcu/tree.c, it disables IRQs and synchronously manipulates the
callback list. It does not appear to contain an NMI/irq_work fallback.

If __kfree_rcu_sheaf() is called from an NMI or tracing context (such as
from bpf or perf) while the CPU is already executing call_rcu() or
rcu_do_batch(), could this direct call to call_rcu() re-enter the list
manipulation and corrupt the RCU callback lists?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155340.3304=
319-1-puranjay@kernel.org?part=3D1

