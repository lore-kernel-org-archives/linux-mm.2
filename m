Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1ACA606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXW/aldR
Received: by kanga.kvack.org (Postfix)
	id C95516B05B2; Thu, 26 Nov 2026 16:28:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6D1C6B05B3; Thu, 26 Nov 2026 16:28:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9C06B05B4; Thu, 26 Nov 2026 16:28:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AFC26B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:28:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2571BA012D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:28:02 +0000 (UTC)
X-FDA: 85478558004.06.DCE0A7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6818A40008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:28:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TXW/aldR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795728480;
	b=YO6m7uoDXh0dv/hMFydGrexmvntikQgZyvDULAVIXFRqLa0Ak7fCWmnWa6t9SsvoCVMlpr
	rgMQ6vQWoA4ybPAh6XmJIY/0Enn22l8k5Cnd1kt9gKiJVSN8lPYfncbl/zO78RU37U0JAI
	LF6uUIWZ9UqvE86ZKRURo6f2mF3jtlY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795728480;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+StfTBT/yTskOPw7Xg05jxRBBLZCudnehaXVkvhMe5s=;
	b=aWrd84N2bssvHk3sn0q3tq+rd6mTYS++Ib+z07iHxCEBQsHjpTtmjR7Wym5ojtW5xRnT+u
	/988TFOJ4VTDFnBjlMug6vWofeMrcpAVernoLGR4x5DmB/gmN/yi7a//1oLL4brML7mxGE
	S53fEc1PaxdSU21v/KXQ7NaNNrysR8w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TXW/aldR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0374B60DDF;
	Thu, 26 Nov 2026 21:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A2E1F00896;
	Thu, 26 Nov 2026 21:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795728479;
	bh=+StfTBT/yTskOPw7Xg05jxRBBLZCudnehaXVkvhMe5s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TXW/aldR7PWMbfwaYy8QyhQLyEBBvh6q5GcpetpP0Hw15S1O8fFwDqiTKf8Iv87h4
	 f1474fnXzZ/+wGlb1daU4s3tPXpMX6H8pTJVag4jSluIquPeowkAuP9ftcB7XZsT0H
	 2mdHl1FEjpADo4At8ynlwA2GFhOV02SEdVRpPReHkpuZrM2GV1OfGmdsBoSyoqSCfM
	 G/ppyMENwNL58EU2cqFx+yxfkelidwkwzzO9xovlC2VG3ejz1O2pbmMNvaJD43Ue7y
	 ojQcmK9s9hVe5GgsE99TWifE4tbaRXQejwQtYQ1kPz2saYREIyEZigiV1eNjj25JGC
	 XTdoIzsvjrmMA==
Message-ID: <sashiko-outbox-236231@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] mm/page_alloc: drop the pcp lock before enabling
 IRQs after a drain
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Zi Yan" <ziy@nvidia.com>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261125212730.1128631-2-joshua.hahnjy@gmail.com>
References: <20261125212730.1128631-1-joshua.hahnjy@gmail.com>
 <20261125212730.1128631-2-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 21:27:58 +0000
X-Rspamd-Queue-Id: 6818A40008
X-Stat-Signature: xzsohjjjkcw7hccsa6i3am6zeg5ctcfj
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795728480-760547
X-HE-Meta: U2FsdGVkX18UHUinBq0vu8TJa/e5ZuXzHiTkcDNLp5LQCItARBoNQVZjc82SlfSXQegwOmHvNZNxSGqmDKm0kKQ5+Ttx4tycccAKnJ1gmlZAfpvbjW2PScLi4J64N9wcin5q/uAOKT5l4PEcN7bRUj+l8whKqKAC73gLd8/YuGYNK5s04qefEgff7rmmH5yLFefW2vbOQrVo+WP7pMMy3zbuoZL0ONH+WoLwAARE6HqjGV0EpwATsaWJFoIrDNlewACheAIdg8ZUvyE2K8Hute/aTaEn61adi8qM6aPt/wJNwLXjohy6DD4W7Gg8s/o6+lhXKVPdLcjp+SpNAUqCpJTpabcrFuG4wFLRixsA0IGxBA/IVVy/jUaLh87jUmOM4USalFLwfcl2YAGk1LpFYX1lkFMAAvvpu6uQ3oW5m9SIQiMvX/EtL+fEIkwwm2Tdi7XY6sgWMzq3iG51MJk8JSi7RPeecbw+NfR3UdcJCknKfbmLyQfTwVgTbcQHSJ0hMOanH7yyYW24xSTVAIqHNLB0sh3zXxtS7E3p1c88RTLo37IrQQQbSd/Gnizs8gcN17V+T8hl+vxVewN0I4DpmXJKQC6Q0zLvxSFO7BD5m0b+z2wjKjTCnUUig8n5/9L/Re+Ure8p1g7zm62wcu+i8ETYbwjF1NK7VmQnRzNoYY/d6m+9K/U+uAF9LO8uJ0aF5M7NfvXjfrQj+MySDjDS8LBkqxAei0Aw0xlor/7BnyBqJdcWXh4rcj4XKk8YDxq+7AFSH+JoukvaaeMZ8vjNIuYGeBGsML8VGi2JVTmh89U52RWL4pziYS0ZO70c+Prvg/qLjfL83YiUe3e8c7UetoQVYxOs11+no7V9kctG2/VTcBTvFjSOHtTtWJcAdxgpUeYLrdUkSO5cC5FGOjtsgCRS9iD121/XbkzIdoxb3WUs0z3J7wUGKvcJXFMPoknVIaP5/JCw5Essaf9WzSR
 J+I1dAlL
 njUYBpWZaZKcOG1nBQhxXplsA73oXHJvpDOVcGoGmEdOwJ3RvL/4YZYIAvfv1cvu4GANBQSCc3g4+IfYxyi4Ym2PMt6yLILV2gOZcRYyXIZEJQSyXkyz3PDwIqe9dhmBgrcGwwWvM9maV3yQ+BREMooLm6nmU4G/7TfDysz30joqJk28VCAe9q700p0hD7Ixi3hUX0TrJNd41id7cbzefwWe3p9lGw6oFxbddBT0NE1YtASUpTo3UGglOFB9C/58VZkaVrvX3+/7Hq6ulEfnhNV3G3ODfet2Ih+/Rijp9r5TcN9f7AeqS6yxaPwp5jTvLkL8r9Qo05r6Eew6d+Spjla0jsYklnTToMko5o1Ju9RN5CUPpeg96SQrCPJEiDP61OAaa8lO/Mx2Ckf422P9gpfsqDro1mF+jn7tqA0tKswwNZbmehSbClsrCcnH5wOh4jOj1kUcL/3bkLkyJQN7lP4xsPfRyTw56pEorJ20cGAQHL//jg/hzFdy8pTaq6aR8q8mA6HWRJoovn3r8BJHxzK42a6I0UJECghrpHaba38zVW2WF07IRrA9iMjjVaYLMEAbXMzN2Y/Tv7zRpWLmISMtpLaT9mWLtHh4eFw1KcchtESJPuyBnjIjV0EVCWd1cIs0zmFs/Ybt2I4xhyv4E7Dd9FGTuzQamrAeo+yJeEvf4hVvabIKopHrRDLGkG6S98z7sswtuOv/ClYgMxBY3ECEANeXlF+Urdp9RAYBJOfqXnoIhSreaCAVJLUHSD1/2q/VphvXRSnN9Vt/KM1RpSoKOnuIEguMoScTnkLF9TbfPhCICnbFN5V9SXfD73WWUwVIZG61YRR54UJ5FXfNyYUhcT2k4ccqXyDtmJwVA6XIqr0c+rFEwv06lRbQ7PFaRKz5QRaqcUvTwe9dnpdtCslWkxdtetA00WihyDqTy1gnnsOnI4lCAHlXEyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/page_alloc: unused-but-set flags variable in
  free_frozen_page_commit()
--

commit d66ecc1b75f6ab35dc480b529fcd4baafd313549
Author: Joshua Hahn <joshua.hahnjy@gmail.com>

mm/page_alloc: drop the pcp lock before enabling IRQs after a drain

This commit disables IRQs before calling free_pcppages_bulk() and
restores them only after dropping the pcp lock, returning with the pcp
unlocked after draining pages.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index aa1ed599c7c6b..bc272f8d8ec75 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -153,6 +165,9 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
> =20
>  #define pcp_spin_unlock(ptr)		\
>  		BUG_ON(1)
> +
> +#define pcp_spin_unlock_irqrestore(ptr, flags)	\
> +		BUG_ON(1)
>  #endif

[ ... ]

> @@ -2904,14 +2919,19 @@ static bool free_frozen_page_commit(struct zone *=
zone,
> =20
>  	to_free =3D nr_pcp_free(pcp, batch, high, free_high);
>  	while (to_free > 0 && pcp->count > 0) {
> +		unsigned long flags =3D 0;
> +
>  		to_free_batched =3D min(to_free, batch);
> +		if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> +			local_irq_save(flags);
>  		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
>  		to_free -=3D to_free_batched;
> +		pcp_spin_unlock_irqrestore(pcp, flags);

[Severity: Low]
Does this trigger a -Wunused-but-set-variable warning on flags when built
with CONFIG_SMP=3Dn, CONFIG_TRACE_IRQFLAGS=3Dn, and W=3D1?  With
CONFIG_TRACE_IRQFLAGS=3Dn, local_irq_save(flags) only writes to flags, and
the !CONFIG_SMP definition of pcp_spin_unlock_irqrestore(ptr, flags) does
not evaluate flags.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125212730.1128=
631-1-joshua.hahnjy@gmail.com?part=3D1

