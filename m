Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05679C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E096B00A6; Mon, 10 Aug 2026 10:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F306B00AA; Mon, 10 Aug 2026 10:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E5F6B00AB; Mon, 10 Aug 2026 10:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D80806B00A6
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:37:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 735981A014E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:37:40 +0000 (UTC)
X-FDA: 85085613480.09.C079BE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80AE1A0013
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:37:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SArZK5TH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786372658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAZICJ1VL+Q4P+HgVltfFci9gRl+OP2pT5x+XsJhMII=;
	b=tN8ZeIyENAFWzP8i8VpTlzbstJOGNLNPuzYe1POPMkOqXtirWn9vj5IJLL+m8n/nkGo4Hu
	0+Eehn+IUzWqz5vi185mUfzVzZ8u0oKfmm9/ruFAlJf8El96ICRzifWKmUT/QnDMbsM61a
	a8JPRrad/NwbiOmoGNgYaEH/f4fTabI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SArZK5TH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786372658;
	b=2LMy4c+wn3OHsi1YztZiu4O49RHO0HonQkq6gqdmneuh7vzxpskZJS4x07BfAfHCoFaEXv
	2EGD3LSkUwwc4RMEHPGJxXBByS+lmLU1AmzHn7LZhJj3As45Ix4kileRsSqlShhmgTwn2a
	L0DJ4qLVbJLiSvzp0WF9Ugi1SuoRa7Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE50D43D19
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60CB1F00A3A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786372657;
	bh=vAZICJ1VL+Q4P+HgVltfFci9gRl+OP2pT5x+XsJhMII=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SArZK5THaqvLXQCuVVrc4Xw1j9zygKBZI9iYjKiiwBan6sDfP+al+k2f3fu/kYx4L
	 a/Ccl5sHHDhzybny8B1waIRawyLjQrXfsKP5gX4l+3eJTqaPLs12CclPQr7DklcoWZ
	 WPJ+4ZLPPhstBUJfYMaBlNcWT8cP9GWF4gVIYvQhXL3kqcsSxcNWNuyMo09atlZdrg
	 ccX8dM8oBl5XugXNdUSVXwYJ9NcP93BpFoTcxUcp9jImtkyRSNJrtrkqCbRPZEh7uq
	 zCfbNYkxR/JHphaH2+GBlHe+vMVPtXSEM5LcFNkNlYHWboqquri3GpcaohpeKDe4su
	 82BK15pOrkmTw==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a28cbdso3080887a12.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:37:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpb3d4XNO5b3yUZGOgR7iv/AjCJJciWiOnuFOsCY+SWnyln8HD5v4KQKBW5qFGQZnPMARedoeQFig==@kvack.org
X-Gm-Message-State: AOJu0YyGcbVjVWDT9eBsJa0VTYD9xkjeSQzckVfSnyc3fhTVOdSkoTq0
	Lc0Z82w/WJsCQGhSkZ2ITn1FuCjrhWA+5nBO+vPqviP7g79iChcMBVlo/8WMqXcY83jmKOHkPmJ
	S17hgP0wGXVEdMRvkpnyStMqjI3aGJ4Q=
X-Received: by 2002:a05:6402:52d4:b0:6a1:df2c:cfa3 with SMTP id
 4fb4d7f45d1cf-6a1f23c2558mr10654266a12.4.1786372656379; Mon, 10 Aug 2026
 07:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260807103714.33074-1-dongtai.guo@linux.dev> <20260807103714.33074-4-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-4-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 10 Aug 2026 22:37:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
X-Gm-Features: AUfX_mxGX4Nbr4LsOBcUqni8J7T0qO-yPY8u3j28Wab2hCSGdEOhPb7Wq76lg-Q
Message-ID: <CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] liveupdate: luo_session: include linux/mm.h for
 virt/phys translation
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org, ardb@kernel.org, guodongtai@kylinos.cn, kernel@xen0n.name, 
	graf@amazon.com, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org, 
	Kexin Liu <liukexin@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 80AE1A0013
X-Stat-Signature: rzy7ha67451fw4t9u9xy3qmu63xuwza7
X-Rspam-User: 
X-HE-Tag: 1786372658-885520
X-HE-Meta: U2FsdGVkX1+At8Ne5xMxorlYvSGfRXtYi71LWBpM+iui0K3jTJIiPFu/oj9CSHdraEcERoJgmSHO87FyNw0hf/wrYJRYbIW51o28oZaWlaM7F7dT8cYUaSYDDWx+i/CZ7zUbyLFt6dWerupv1XhOLSIYVZc6F9Chj3UlC5Ylzor2ys71XibCOWfx0hSALpq2QKuQ41g26bR4DzB3CWBOQI27STiHJpezbeTcYzwfJnmNb7bLp1B79ddQGali7Xh5HwYD7eGhzNi3nd6kckTZi9RWtK6RcB0jXxfaEpFKJiK+epAvWvpQEEBMAVdvyjBOXDeceuzp7RphC4bqNZzGtJmFbrbYDXXjhygHhCgKppRGZszVSoIcjRKcrCiEzpVoLc5CqpnTNcxxfwr7T3ktHApAkACOdn/EzDa3Q+caE/w1J9BsgTzV9do5aYviYIhAkWRkVdLW+xN7iD+4Bb6oIrugysG2AO1DOZxH4kOOtgJK2mgg+B8pL9lJgLilUmFzHqnsWFVvjp7FXVRwzHI5qeJ3wJjjRm/DCIZGJQV8X2wnukq6HQPLxWuWNmHNY6PbdceAnoo9xqSman/VvMrmdSvzP19hCFmZ9R1qzgBP+LsuHNk51iVtNs3DK3ikKckwzl3lafGuQhlC07SY26kjqoXdrGlUG5MqeamzJh7t03xjkwRV86bKuN6mBgsUr7eRq5ZcoVhclqE4/DpgKe1rkIu/QmUrDov9hyv9gsYWofz6qz+9Eo1NPc7HtcATa/S1eE575/vZcy9iL6GY2Y4px1yd5fZwbwCRTu3vW6x3VvpJmtcQSFsE3vm8DH0VWGLoWC/vZiyS4zuo/Xxo+ZN5er6vfpcbihX20abmuKfjCH91wrudozB5nt4iqz9Vu/gF/zDT7g+iRL8zbuwnaBQVfqVPGCdLgrNx9whOoNomyu0mxL9G1n2IwtMHylmNgvymPr93oapfn+ReuZ9Nt7C
 JhTDZBk/
 fMe3+qz4WYB4H1jvd3/e4xqqSNWstDXi/EPrGXzLSevx1WKAp0R+mO2NVnBk8W/jHgdan+0NrEYVP56GMBk7qcwhMGKeSg90Dk5cO8OwK6c64rSbS1EwGP0FRCiat/dtWDVOETeVquiO+4IJdNwLabvC/OeznvJRNOJggrXGF+vlpFYR/yypbkqpG+9+E2iwz3IKPTpx16z80MPBjf/vDHAt4UIm8ZV/6qOGEZWzmLRZNzRZ1xgila2xNlSJ/FHkzsCdOAJciaVH4oqvG2oPpg1+iWjZaj5e/Z2reOApBcZqjeeyt9RA1E0br7EnLOJHKs2VnegWbdgvFVywfE+dAahPek/3Bj9Sr6oC0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, George,

This should be the 2nd patch.

Huacai

On Fri, Aug 7, 2026 at 6:39=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> luo_session.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
> CONFIG_KFENCE=3Dy, these macros (in arch/loongarch/include/asm/io.h) expa=
nd
> to offset_in_page() and page_address(), both declared in <linux/mm.h>.
>
> Since luo_session.c only includes <linux/io.h>, the translation unit fail=
s
> to build with CONFIG_KFENCE=3Dy:
>
>   asm/io.h: error: implicit declaration of function 'offset_in_page'
>   asm/io.h: error: implicit declaration of function 'page_address'
>
> Add the missing include to fix these build errors.
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/luo_session.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_sess=
ion.c
> index f38b5b18f3f8..31490ac7b63d 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -94,6 +94,7 @@
>  #include <linux/kho/abi/luo.h>
>  #include <linux/list.h>
>  #include <linux/liveupdate.h>
> +#include <linux/mm.h>
>  #include <linux/mutex.h>
>  #include <linux/rwsem.h>
>  #include <linux/slab.h>
> --
> 2.53.0
>
>

