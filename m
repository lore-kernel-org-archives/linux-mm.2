Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A9ACDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 23:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67F96B0093; Wed, 24 Jun 2026 19:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18DC6B0095; Wed, 24 Jun 2026 19:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C072E6B0096; Wed, 24 Jun 2026 19:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6DD6B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:11:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2ED048EB7C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:11:10 +0000 (UTC)
X-FDA: 84916353900.24.CFEB337
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4A2D3A0003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:11:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvJF0O4e;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782342668;
	b=ZJNaf1t6+XdkEeTFTqfFrPXpNParA+O2xAlHugohDvyVOpQVApIU7Lm/EZQoVIMMejlCYo
	pBJP0+NXL+Ynwq+RfkDXrb6mv4I+JPsYc6xQU1WWGrJ3tiStWLvrw1f3plxsaOVjfM+PAo
	Kax2J1PKZJEhGB43ZyQl0OuWwAtHpt4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782342668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKAaXJoaieAVE8AH168vYoAqWKzDSB5PAxL21Dc9tvA=;
	b=PGokll4XD1kRoZMQ3iWRRrEpk+C9X5HKRI1PlQldUvOhDe2QBosmZiOqGFldbkr92T+n64
	rRY6NMftKuqr7gyJckYRlgi9al/Wq0tm5v5+/0mEWhgq2wfIun5HlMaTL+xriJ/NWdAf3/
	wR0NIrnKVzyIZ9W5UM4SpB8NyqueNWU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvJF0O4e;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 359CD441C8
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099081F00ADE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782342667;
	bh=tKAaXJoaieAVE8AH168vYoAqWKzDSB5PAxL21Dc9tvA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KvJF0O4e+olV2hKgBbt39dJWVzKcz02OxfSxjWy13p1Xm244jRcKwU28/p0+EDHub
	 oKds/xNua1IQ7qfUygKmw4LCikXVcnfsp26mdlsEituoQofJkuv+GfaHbAR3N6GTvA
	 6WeCNPGefYOd4pB1IPLft5iOtCXxeOaD/F0yY1aRnUJlW7jUieyrcgqTbeq7LtO9sF
	 48RXgHYs0Dy0J/+bONa14qZXwisAZtu/FJqfb1q9rv93270vHyOMuheg5wQF0dg6+C
	 wc5du/43K7d31R5M3wt4RhkLB8bZCUR6ZvvUYz+Zs1LvdJ5DHJX4y3FjiNlxIJjIAh
	 f+BOShdB5G2dw==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8e59f64471eso11994396d6.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:11:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrL3L3bo3zmqakzFglcenuwWbNn8fkcAs1sjkYew0MX5372Bu6Y7ZDzIBuCxEhlvlrXFr53dxCIeg==@kvack.org
X-Gm-Message-State: AOJu0YwRwnTj0UQkZI+/7HDxP9B0IqgVvKOQ5L1FAGEPWZKf94xWZ6sA
	J0YyzNkcMy3JnFlit3JElBHFUk+Iudu/GG8XXGdBBQntR4EOSz24KjNO7+qC9kmN0FHD5krZ1wz
	pmfUFpJRZVg4ajB2FPDcmX0xxUWA/Q8w=
X-Received: by 2002:a05:6214:3016:b0:8ce:b018:8a03 with SMTP id
 6a1803df08f44-8e6da33b9f6mr3148356d6.27.1782342666425; Wed, 24 Jun 2026
 16:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260616031309.3036234-1-haowenchao22@gmail.com>
 <20260616031309.3036234-3-haowenchao22@gmail.com> <CAGsJ_4zjuSnR4K5DS0A6yDaZkvBz-9ODNxr3Yo5_0O53MosiQg@mail.gmail.com>
 <CAOptpSO7rLHOCYXgp6sFjbWMD5tf_iK6B5NNrHWb_CU-tuVmpA@mail.gmail.com>
 <CAGsJ_4zmfXg_ub913S_uYeziU+mj_+Cks5iS22oTRRt2Y3LYyQ@mail.gmail.com> <CAKEwX=Og51dvN9PsH9dhVHTU=CQk5oRHwJTiu9mN9Bn8uLnx0Q@mail.gmail.com>
In-Reply-To: <CAKEwX=Og51dvN9PsH9dhVHTU=CQk5oRHwJTiu9mN9Bn8uLnx0Q@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 07:10:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xj1SvosfZwOuki14gYPJ4VLs9qLmabYzKKtgxQR0fy+g@mail.gmail.com>
X-Gm-Features: AVVi8CfquNwlq855nAy5L06lz2Q9n2PyTo_AYlPE9Mg-bsWXjJdtfwZes3hS3l4
Message-ID: <CAGsJ_4xj1SvosfZwOuki14gYPJ4VLs9qLmabYzKKtgxQR0fy+g@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm/zsmalloc: drop pool->lock from zs_free on
 64-bit systems
To: Nhat Pham <nphamcs@gmail.com>
Cc: Wenchao Hao <haowenchao22@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qbe7k8ymsggo73f69bmi6ubx3nee85i8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A2D3A0003
X-HE-Tag: 1782342668-537831
X-HE-Meta: U2FsdGVkX1++xucYVdg6THacKIBDTUFv8svjTqEjKzbghYKmAdJB3BydsxPvlNgDjrZu0EDtL+0U046Dkn+pxfduAOnQp3pu+bNeggznMxNEgf87UlQfVcKLfs1pTftEzwk9knBVGSLFOz9tgoJf1KLQMQ3qi6VJ+SXbe3V4LXx0AA/kcOfPvvji1YV+aiokgiKHvLncfMt3kCLDJObPMDyJwPMq0OEhDBoC/e4lN71J9n1Y4AH6wowHBAhp4xYwhtTnc1RjhWLVWh+LMI7i+uJEfJck0AtGxZLtpE8Q98NgbQ4yfpZ7ffXLWm0IsYeez4o1UhcNPzVN3mMU2lqz96V/nDXAm6Z86sPES6VBE7JdPKHcRK5U3Wchx4uF43QW2u9jleiPXcK1JhZhwbw4fkDDj3wvnCaWVwGdWn2NXzzpxWvLt962LHxDXbYKleHiosRyVucUVrpYGXFyKC3WxqF7AjkndW3hYlW4C88XXr4ccBh5pM2EwG8qjcJFpaflKkQabga0v7nrPVniPt4TZYqUolIRNDnEN6Cs0LgzOaAh+/kh1iwBmWqjum8MWfXZv/Pi43m15GQqEHGkqhE0o9MvsHWXclRXWMyAX+16JM4KapMJwdeMMf/nfe9+cNidGCQiE6oQVEGqbi94YN6TW5V2QXifAp7QbIqE38WJA2pUAeTA1gAcrR7bCbCftDYJ4WEEIvMVBGqzRq75HkaDkZyrAE6lvBsyHMG9NftyzFy3jXOC7CqS0tOL2El9MmBdjXrXRWycUMeIZJH88Zw0+MT/6vm60/SqqBSXslngZAotUqQX3BwGbEeCTN8puy7PpK1MJR9NkUNa4xKmfCHdGhl6aL1cMjgheeNuxH7llAtjOt7AIyt02mZpuswRSFtSA3QSayo5eHveHppjABa29hCI7ckgluG53j6Es2XWbjNozFwdWhngpC+37RYD7cdZA1WIJr+7ls/4jf3E7WE
 opjm8Xlj
 t6nQAUoBa3kF5eGc370mx2RrklDxggqqL7mdbJS9b+pcMu2cW5PCyKiTiz/bcxELwajCiDIBT7rNQjayywY8JLBdzglykIUhIR8/3twaAMclt+WcMoYuiMfKCfYQSSm8Wt0jFtAt2/lgWHM4fcJaK42p1YnjAVosVfU+AeU+0hdkRG/9pHSdxe48SJS30RYWUYyy9Vi3gSt0hB4WPvj+dLicupy6gJ0fPQ0ubGrm7qKzSs+y6hes+UoT0mcgYzaon/MNpw3jY93o+qQUi8yif8sWbOh3d4x9mIvw27futX2dYu9e+w/9+O0b5Qfmxvq/4vEeJlDejtBD8Hi1u4Sixe/o82aZLhZ4/ablmUrzX71YMIAS6CJGMZcYkfU9UCxW58h5j7Ec4f8mw4KEk9j3wgFscSemwSETG0Vb28KmqAOUje7EFidjzKC7KhTN+jOGnL9mnytAOMm+LByQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 6:39=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
[...]
>
> get_and_lock_obj_class()? :)
>
> or obj_class_get_and_lock()? - there's swap_cluster_get_and_lock() as
> the precedent.

Nice, that sounds much better to me.

>
> Anyway naming is hard.

Best Regards
Barry

