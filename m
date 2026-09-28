Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53BB5C98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4796C6B008C; Mon, 28 Sep 2026 01:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42AC96B0092; Mon, 28 Sep 2026 01:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340736B0093; Mon, 28 Sep 2026 01:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1C16B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:58:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA950120B74
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:58:54 +0000 (UTC)
X-FDA: 85262117388.13.169F58C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DDCFC160004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:58:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E6H60ywS;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790575132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srfQqHtFz8qMgjHgFSb/Ele5F879D92XNe4pdLC/vrE=;
	b=uT+XFTr0oh3lEcqU5Az7h5P1KFE1844bbJNht0BDrLUtCgeBTvlHjHoAx8ckTPdFHV1cXY
	ipvm/oq8WBH9Z4Cuv2xdQ3/xlbYRvuViUuKUPaUR7vBw0EfKmAs9VsT8rr7Oxgteez8z9Z
	kQc6OWAj01SDrZOXflg79NIqh51MHqo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E6H60ywS;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790575132;
	b=tJV3ZhDWNNe0QGGrP4Kx4IzuqoylDCstLdajblSY8WChrckXOpkCheEuYurlBe0obrbP1y
	tWMP3d4V9lq2aRSSl7viXO12I0859oCDtWVEdjZQ4P/yrxprvFmDVlQaPbzpo2U9fp8sCD
	glbcXYM51TuE+7zl1B3zCNOWgFSmKI4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 625AC60204
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAE51F0089A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790575132;
	bh=srfQqHtFz8qMgjHgFSb/Ele5F879D92XNe4pdLC/vrE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=E6H60ywSuN/2sAFIcIxAUdPMZAiZE06BrzymPjID8yGUFso2aOFQ5k0t0MUU9hRp9
	 itAW8DxYkJapAKCmagEuE0pxpOvIJ03MBuJEH3IuKZ11OKfqAN0fNi8w4e8gpCc8XF
	 GJtj00SX/Fzz3MEwmXFtzLMrdSDkxVp1iUbCX8j6TE5ZLkcKpzcr2jV+lpNjgNLfsX
	 7fR1LZonKIIrQqfCNK0MTsKQU5L/ulq5hGwcTSIR42NJ8tpMJ4eh6Z/UEkKC5xsWC7
	 IPjKU3CK8iF6WXs/emFI60D1rjzYENy90uqDPwmo8Yo6a5TuO9kJ4tPhTHhx56Sx/a
	 A1Axd42G3oYtA==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2c996fd607so92754266b.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:58:52 -0700 (PDT)
X-Gm-Message-State: AFq9FYJsrXznfKCph4yaDrJCL3b1p6ODVy9Fj/ZXZovXYOv3FbCd3zJ3
	IhHXlBcHLcUYYq7Jwt1vuHF+rVS3VK+wNuzg15bXpqWLc7ZWnawdICH4U1ZhTgMW6fys+s5pime
	DHE+8CWOlMwfliICJ1e49WluYyS54nrHSKcVJot3img==
X-Received: by 2002:a17:907:960d:b0:c25:f7db:4bf0 with SMTP id
 a640c23a62f3a-c2ac238a8d0mr1079000666b.22.1790575130941; Sun, 27 Sep 2026
 22:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-11-hebaoquan@kylinos.cn>
 <CACePvbUn4xBNkKBjyniG0TLb5bA8wGNBiJ77JTF8FDGN9EgCWQ@mail.gmail.com>
In-Reply-To: <CACePvbUn4xBNkKBjyniG0TLb5bA8wGNBiJ77JTF8FDGN9EgCWQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 19:58:39 -1000
X-Gmail-Original-Message-ID: <CACePvbU9PfTuVqzsJisa3S9DX7AssaUCRT2qk=tj83ACGUobXA@mail.gmail.com>
X-Gm-Features: AclHuK8Nttla48_gCpAztfqY5DyhHBX_oGqq8i1YtMK7SH7KobM-TpczZoxSPGE
Message-ID: <CACePvbU9PfTuVqzsJisa3S9DX7AssaUCRT2qk=tj83ACGUobXA@mail.gmail.com>
Subject: Re: [PATCH v3 10/14] mm, swap: refactor swapoff and add xswap_destroy
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDCFC160004
X-Stat-Signature: mtdh4p56eqhtox494ch4ne61xf1o4t9h
X-Rspam-User: 
X-HE-Tag: 1790575132-129101
X-HE-Meta: U2FsdGVkX1/TPX9ipx5OMDymudC+K3jbRmA28JcjZ3np9i6fu3t4Pxap5aEgWJS8DQ4fjFpW33hAaRGCloMGwqAh4dTmfNz4VZsYnzkY8hYVGW8wvjjlv7wWexdumIoZM7YGrTb65ENQkfLe7lZoCWo+bmyrmok1QUu58+FQi5xIwynLfC7bRkfKVSGSoZ1RBthwApOnOfYm1oGORj+U2qtodBlEP64pFy8jmevEcK7QD82sASpFG/q3JfDMzrmdVVo0wpRFZvgddy5WYJ06qHcLBAq4ym4owwvc5P8vHhDyv+wJ6Yj+e3FGWjVSsPHkTH9c/9HVyHcYY9Y8X2vz9zeDk/yCWBZU8cC3EmS3HUt3OUNGbk2GANy18qf80h77NPOWnhRaip04T/E4EcIC9JdTzn774OVNBgbvsjvUxP3WW4Xy76a0t4iE0x8/X/dOo74d1vlXP36OEJJ/j6qMFFC+cuSVjx7jUFMWOKmB9OAUKAWw7ayxpPtCN2ApR+sgIDE6cFJ8efpa9DJEdDTD6JMm+zVjkoNrj+N1920Weby5KZdFvWeCe5aAqEyvf3k18cRasHfqfH7ue/DqpR2n9CqxKX8off0ZXpezFGcY+RZnr2pIrlwnx3kCcEHfUbOtyyAB9h8X7YuC5fE68t8rzFMCoAN77B2Qz8UwoJCyAFQcvmSut0Msbazic0ZV1rjyo0jSNgQn19M23COjDxRbQH4nGdurKz0UuleNzWV+3nDZ0TTPS2kZ1asVlwykpfGlkcP7H93Roub+upFN3+IbCx7nFVsmlP3M1OOEq5bWS/gJWOd8C+qN8aFD45Czk9rYzu4yCbvndl9U1PCEDXBxmYNBPjR/57RzNbZEt3Sqn7tzFqcRvHS186F4ilFEGPaVCLnyzuW21aKTFyxoQzswtQOpol9byoataQZQJKBf2sxF41IWV4gVxLDuyrqAdmlBDMOehfSE2wXwiyiWBz5
 PstQN09Q
 5yrkExUptPUI0XE8Punn+NfXFxbBzwngq0D/+hEAw8DH9Dfii/D2yUAK/vJdKe5vSFpaDEwmWet6lewopeBJAHvRgfyI4DzSKWX2hzSvYq5PN37CrX6NOcjDOPIJ18yVfjkTZFHaGRJLC8pCBs/VXr5FDRCvMN+PE/iSKhp8TC9GQZSB4MsFDiWEXgexZhQjqQqpvlJstw+O0v9RhEGCfBK/5R0XIjcM6lOkY5ep4Le6ojlQGdi0AExA6WXT3iJG1zTHk7BlgLf0jgZ/l12chwErH1jENKsMwVdhXnT3xRHV7wKA7U0/yqNfUE4Hvy5Bo3kSSeKkmCJLnaR94mk6VSzH4hNDjRK8F7U/gwo9l9Cbs3ghABJM7mDhYRQN/eXZjulKjVr6vEPtqWK6CtGJOWzEVaPITFZhnxkzg61letNzBtnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 7:40=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> Here you relocate the swapoff function and causing a lot of diff
> context due to the code movement.
>
> I move your swapoff code back, right after
> flush_percpu_swap_cluster(). Then the diff is much cleaner around
> swapoff.
>
> For example, here is what the new diff showed:

I am sorry I messed up. Please ignore my last email comment for this
part. It is still benificial to have the swapoff function move after
flush_percpu_swap_cluster() from the diff point of view. II messed up
my patch by relocating the `pweroff` function in the wrong patch.


> SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  {
>         struct swap_info_struct *p =3D NULL;
> @@ -3391,6 +3393,11 @@ SYSCALL_DEFINE1(swapoff, const char __us
>         spin_unlock(&p->lock);
>         spin_unlock(&swap_lock);
>
> +#ifdef CONFIG_XSWAP
> +       if (p->flags & SWP_XSWAP)
> +               cancel_work_sync(&p->xswap_shrink_work);
> +#endif
> +
>         wait_for_allocation(p);
>
>         set_current_oom_origin();
>
> It means we will need some swap_ops->swapoff() for handling the async
> workqueue canceling.

Never mind the above comment.

Chris

