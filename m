Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E83CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 10:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66486B008A; Sat,  3 Oct 2026 06:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D566B008C; Sat,  3 Oct 2026 06:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53AF6B0092; Sat,  3 Oct 2026 06:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5E96B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 06:02:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20C221A0943
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:02:52 +0000 (UTC)
X-FDA: 85280876184.20.E467C4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4D7F0C0005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:02:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cbPkUkr0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791021770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CINEjaQKfqAZPwBrbQreJnxCjhJLGPy7LWkHQXklSnc=;
	b=Fks2Ox1BAbFw0RU7M9YGhKOiufV0XjVBHJ9llU6usaW785oEuETXOPr7RI/8qTPZTG8XKZ
	Xrkx267TrbbxELNnSTGtLhUsSIUNLiKoVcAVIfvqxOzc6uS8k7MsI2Ys87j8cCkv6roTmP
	Of3U0hkKJuAY7NaeKpG1fY7XAsi0iVg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cbPkUkr0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791021770;
	b=slmIJO/6PtDh4sxGyix/nYKM3IELtmecn3MZc4kdd4FHMjcUxbXhOHXGCifLjtywaV93Fg
	184IB+dcEzJvDiUIxLDZhCUSyJB3IU0NcFwKedOltxSIGjSBWRuUpskyduAO/AdEERDETd
	9DR8Bmkpcl0eWWL6525FmiFLCmMlKuY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EAEC60A56
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB441F0089B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791021768;
	bh=CINEjaQKfqAZPwBrbQreJnxCjhJLGPy7LWkHQXklSnc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cbPkUkr0XYdE8+ZIbbi9i8lK+HB0OiP8AJesP7l7WyFTmGTfx4iCKDdGwVmpcmD1N
	 X1Skp9yjZcBCLYCtJLeKa8LYM0g2fGrbOYibnOJknCeVgTkeyINLpLntZp9JaWbdo3
	 B3ba2/41L1iwhr0yb/xu1x6Qwz0Fn6tAXVCo6MMuWZGvLL82QO+Bx9bySCTcF7ohJr
	 gNaVEp2LZTRUUo8nnL5cxND358VxyvVcVrm+TN4amJxV0SF91qZOHOrZ66aYQIwZz+
	 FE38duc0emlzkCXJ64loBzj31lr6plLL50ka/4Dw58spqN7J3ZfQ5qviZ3vtzOTaHO
	 G9zajQX4zVl/A==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93e59d6618fso17112185a.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 03:02:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzU2yyfYwdScC4VJ7+4wzfs8o4ztx1dxQZKOgCI+SEVkBlP8dCEw4wccOb3VcZ2lXUjsmnAoAXNtw==@kvack.org
X-Gm-Message-State: AFuF++kTcyHaqrtZt3h5qI4RPcZ49VWX0FLhLlyeyUdGZXhx0bbW5aV6
	SoIg8Vb39C0Iz652Ctadm//8SZJZnY2enMG/oA1wByou7gTcG1yM2SkZB7wriK8ql+WkLZxoI17
	MHcSP25ZZOzY9sHfv4riy41R4ugIo9OE=
X-Received: by 2002:a05:620a:414a:b0:93c:677c:778d with SMTP id
 af79cd13be357-93e510b2f5amr326716885a.59.1791021768309; Sat, 03 Oct 2026
 03:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <20261003090430.91664-1-jiangwenxiaomi@gmail.com>
In-Reply-To: <20261003090430.91664-1-jiangwenxiaomi@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 3 Oct 2026 18:02:37 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xWAd=VHPdGhS2AHKag2WhFA=_3MSOPuyt3ksKH9ezQ7g@mail.gmail.com>
X-Gm-Features: AclHuK8clB5bMzNPhaWHp9TdGXPrszsdDwE5fUfbLLA9dhcHefwAYdXz5_pN5jU
Message-ID: <CAGsJ_4xWAd=VHPdGhS2AHKag2WhFA=_3MSOPuyt3ksKH9ezQ7g@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: bail out early on invalid page_shift in __vmap_pages_range_noflush()
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, dev.jain@arm.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dtx4pax54utpyjwnne4s535j3dm1mhjc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D7F0C0005
X-HE-Tag: 1791021770-392530
X-HE-Meta: U2FsdGVkX1/ACoRmj6Z2U5R4ZCLI/V68lgkeYz81JcveBluntsw0oRIuCI7JQldCzPg5ml2CR6MgntfzC4wnQWtzJvSIAuTj33J/fQRwPQuH06o0jBSczNNqXAv+tissFZ7vfVsA6/eBXJl9zkWaafqFBYZGBavXWIFkWkk6uGxLHat3/NNB0/459ZFPQIBwRHWGg16XMhjAa3sTtcg2xNHVtYhFQqS6q3gRJfjSm0HZo/EuDEglkLjg0crtZPBIZTaWMTrS8H61Lk7QSB9WcSn8S2Zk4atdGWlFCCq912JDXFhTZ5wSbH+7xdYmaPDUeDTUwQavmWeJp/baDkiMdZziFg+PPVhhSo7To1dL3AU8wl41WQ6xiWr+75gxXipa3TLfRyjCMc2aTyKX3cvQKRFRQneu5eChwzxaLpSQPNYJgG9xzGiAFir+bsd/gPB/eiyZNiPKabHcqQIZq8a/bXpzHhyIk0KW+c1Q3gIsiSokHuXjsXrp6BSC7MLUobE8lEum+L2us3jdQKgvgHf8IxvR70bTyJylIRCzmlswJOt8eJOoV19K7NSYE6/bW7JML2MrPZniLIN5X7dCMeXl/3ntnE40oJupND9nJVbY1neoxHfZPAc4urL6qHjYNq4OFX2HjiAFKWN8JxjMm8eRxCNPRFSqF+afwsqeojkg7DIEZOEBa1yYyP0kF+cZaRIr26SqwEAe2w9+0NZ05Ok5nryk3bImm4OEaH18fI7Pc2oljpYOYtZREVhwmtWetBT4vagndAHDnQKa80F+VwOuVjDUK4AN+PLd1KuyvAog8jnRGc9gDnZIj82LDKfPGxPEYeuQES2s49la32qT+4JrRtUr20zvqYEiEaGQhGdTykGkh13YdWDYoIBGre2IwZVOeSTzTfatlKpyX5qIJmPVJ8Iqj3hCQ4toUDPrI1XRGrzqsBzBJskdO/0PI2JlHxe3DaEro0fmj3Udks5rlb/
 ojaBfjMD
 dLLluD6JhbG3O5jhziFSlVTG0TqXCw3b2lM/q873oGIu1O5WIVnRPDI+7LePIbSXr44HBanVEISplIJuc0gOBys36QYVjmxb223AxYxQA2JeSmjRq9Hr6e4llSxSd8zI6VFSk8xvozhcWmEgvuOtUWLwxofhrdztLgL7nW7O1DruR1fMQ0uoJZhBxpqgdeHW3fYhBrv7yBWMvcANlGV979FFanp2uwQQ8hKpozNP+AJM8uNcxNPCG5jypdoQnk2mFtIPLTpq8YDXi7U51RcduwtJMevnYfCFxId3fGA2WZUd4n70WPXRC3b9IsGz8GtMJIERtp7Fohl9EY+k5ydHwPl4xMOvxwIe1CcTc0SklBJc6Rgi8HrUHoExaU1VQ9dWP/mon3LL/1JNzVnKPXWnB9K/VWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 5:05=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.com>=
 wrote:
>
> __vmap_pages_range_noflush() currently only warns when page_shift is
> smaller than PAGE_SHIFT, then continues with the invalid shift. Return
> -EINVAL instead so the bogus argument is caught immediately.
>
> Suggested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>

I have checked this carefully and confirmed that this is a correct cleanup.

However, when I applied your patch, I noticed that the author and
Signed-off-by do not match.

Author: Wen Jiang <jiangwenxiaomi@gmail.com>
Date:   Sat Oct 3 17:04:30 2026 +0800

    mm/vmalloc: bail out early on invalid page_shift in
__vmap_pages_range_noflush()
    ...
    Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>


So please send a v2 to fix this, and feel free to include:

Reviewed-by: Barry Song <baohua@kernel.org>

Best Regards
Barry

