Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C19CCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF60B6B008C; Wed, 10 Jun 2026 12:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC316B0092; Wed, 10 Jun 2026 12:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1EB6B0096; Wed, 10 Jun 2026 12:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE586B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:48:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 392461C126F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:48:30 +0000 (UTC)
X-FDA: 84864586380.27.5C2ACAE
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3E4ACA000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:48:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=syTb5TNl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781110108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slp+cwJYLu0ks8o+WooXqV/SkIb2cchA9oT6qbMqw7M=;
	b=YKpqiFHa858zlfcihpB7liMwwePUIQTtaXXsDjGPULTO2uWDvAdilR2ejyTj3AZ+lJnDlK
	PTG0ZillNTyl2D3Cm4oo8WbQ+TJkIFgSnCoPOj6B1aFHB5gIMRlRNfqqrNPHGCsONJGQTf
	yxEmsWFNnNp3jE3JoJowOEMx+0js5cY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=syTb5TNl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781110108;
	b=lBI+61Ag4PYBkN0rLsIe5fz6rFLm5A8a5UplqqAYJZQ1qtcvPqSDsyWZRVBYtDterBzaWW
	MH6ns33AIFoHEFQqpu4lNIHWu0gH4ffsFMYrbd5JziP7hlATVjKIjtKIXowX1HrGc685zw
	XKmf29M39l1XM0bu/miRcGudoXGNxHc=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45e9f4a3510so3555163f8f.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:48:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781110107; cv=none;
        d=google.com; s=arc-20240605;
        b=jPWlX0PMcp+inRxuqHOAX6D/PsAaQMys/vgkWckxZZu9AAggohNia00EsC2OKh7Rs0
         VmXrfEZ+65ifYwExEzUGwWFLI7y3YTMaKR2cN58+ghoDBrr7M+4evarzeudsJFn+M5Yu
         4Lb7pBamfxyZKzeYPCPeY2dvuYgPFVu0MEbv5UnHN4Zv7plYIPM+T60q5o4DBdNo2Kyf
         T3/2EayVecTpyEY8TJL0wIpu8HhRTK0hk4rkopht2TEu5XZVKGXXenPyKbrrdiqxWZy3
         7PwN+cp/1B4AGDnZ50Z2LMVYEWHXeNZabJgsYaPrJwCq0H17mA/WVBJotXoohK+QxG0q
         787g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=slp+cwJYLu0ks8o+WooXqV/SkIb2cchA9oT6qbMqw7M=;
        fh=ttuOrSWfzZHjgM3vruJNtKxktSsw8qqW02SQhXCq8OU=;
        b=boeH0FpwbPsrINPpqFRuV9w+E4dAq8WifZsC3K3/zWUM8ckcPslV/G3bo2nCfuRf6q
         m3XULJw/eCgJFN1kwXXvpESSZaxD8V9HMT1aABPycn9PQAvj7+2KJexogyHtbMwvqBjl
         BiNhbSuAslSPNu4/JiXpTsJNd3v+23LkqxstqrOBYLAAM7oXaGXDwhKiHV6Aus6RxluH
         MwHnxxolo6cJZBI5iu3Dcirn5t6o3XEdtRk5EIM8e2skAg1zHdPRFtOWTfwD6gOJeYia
         mz/+nU4op4jlCPmB8h9um9a6Y0PItl7ujbsOITZj4RoSOqwExi/a2SrwQqNtEudRNSL+
         PMCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781110107; x=1781714907; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slp+cwJYLu0ks8o+WooXqV/SkIb2cchA9oT6qbMqw7M=;
        b=syTb5TNlTeu1o6rQppIT8jmGFc3vIZCepJxAP3qDy6KvgDfBfCTeS1AWSmIHajwHX+
         q+HFXoTmyTFuoVf2os+xygirShB8IHlG4i/Qzq7loSVSzNNooVx9fmr7Kwthoqv375yO
         pJaHh1WtyZvTIVI7Sh/gDOAPI34iH8inizwGhhrBJjYZ9pidEtrGcTY/QtG1LQR524pp
         HjT/UFTJKH1ECrlmtMHmtbCn5J8oo3X8M75yQyL5s7jY71LSvu6WkX1qokcWenyJtGMg
         OtoyhbICnv6ZP29NRbtQ9O8Yy0Ghtg0enH+LOdkK7WlI5DPFlRWK54VQ59EelrhxQU1W
         pE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781110107; x=1781714907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=slp+cwJYLu0ks8o+WooXqV/SkIb2cchA9oT6qbMqw7M=;
        b=pej4LyhNbZGIpSO/G5fM9kI6SUNuiBehQmb5TXWirnrMlX8BXGZh1oI3nb727ZaYY6
         nkSRPSWYmfC3MP6ydRASGblWk1V3PlsnX+N9IHgporQCzzZXk1aJCM6YRgHP+t5zf78k
         Mohnvy5qq/JWGNpoMM7B+jybpFF2wVAnSuTXmCx9OJoNkP+Dkb4LnalzkT6etT+Vy98f
         /mqqEdZz4+hSnCVch0/KFbiqEaWXQWCwqVfuuC4unmzqt95PsyS1FsKaycCHVzuilr+R
         SFAvzMJ8dYFd0gG+B3Kim3uQe/0xrSkPL6UunwAbx51uPSRgyzvpyGam5VxtMN6II+ey
         +ggA==
X-Gm-Message-State: AOJu0YwoHdQMDVCeoWRygbmGC5cCaWzTXrfK2RJXZUhMjtxp4stFiJc4
	AG+gShy8HlS6Zg+kV+egQPo+rFkhADINGhIG4THqLO9JoWIoikO76Ms+jrzJP9bBtepYgyXru5s
	Bm+EevvDPXUhJwIW6hRDO2WIZimqSiSU=
X-Gm-Gg: Acq92OEv6hBUiAEit1A60qc+4vnXfrLsi20LCGxXiSueK3ZG1mJnfiKw/HZJWOYf+1K
	yUQAh1LE2v6ottYKf1hKqCjrV/y28nc6CHo8HrrakEM0qsy2z9LzHPdLSmXMD/9TFRNjKTy+tr5
	Qz3SwLzwPWxFHU84T5YXWJtuIylcSU7NQybRfhQk2P8QnqzT9vFS/+98ApD9zkPOEn+A2lv0JG+
	ohHGh5DkqOZnc4v4HSlhBgLIUi/+Xwtc57O9p7dXOo7eEXB+u9G9w9mkiiKx6sz3Qka7gsiHgMY
	TngXXt143hDwzqwUFLYFfQkfEjEC/5Ac36Zla9l7eDUpI/wFaoiU6hSmSxb1tU25pFC7FmBbC+3
	m
X-Received: by 2002:a5d:4688:0:b0:45e:da9b:97d6 with SMTP id
 ffacd0b85a97d-4603061e47amr29719379f8f.27.1781110106832; Wed, 10 Jun 2026
 09:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
 <CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com> <CAKEwX=MFt=Z5x5meSgf6H6B2a4J9Uf9RgHtBLEqJgyCiJbtyyw@mail.gmail.com>
In-Reply-To: <CAKEwX=MFt=Z5x5meSgf6H6B2a4J9Uf9RgHtBLEqJgyCiJbtyyw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 10 Jun 2026 09:48:14 -0700
X-Gm-Features: AVVi8Cf1nrGJOTHfRnrJwHtb-S74-lk4k6lwqsXYLSJv1Kwn9FC4_WULLk5bTpk
Message-ID: <CAKEwX=NzAa4pvHSrjTYGqaA3Hvo1yodngKfpzro7NKPhL-+F_Q@mail.gmail.com>
Subject: Re: [zswap?] BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3E4ACA000B
X-Stat-Signature: 8p14wddw46ancaqync1i9mw1fw3oihnr
X-HE-Tag: 1781110108-685935
X-HE-Meta: U2FsdGVkX1/dSsLGzIp0VejbpjZSAGUtX6GN8G7fGYKRu7jl105E1uOheeyIr+3YwnxJFBhtJ1bu2ow5xxgGAkvLFUo17pKhiuQuQEgsgFUf1h6JwBLH3k02iX8rzYx62Gw9kOtmVnklxPQzhoGbwl+MGYkfLRxrQLYlKSTAawela6X+wNmpTJM1x9kY06QzED9JR2YuK/Vz6EL/9P7/SY6cJa47J3OgafPIIcP5EDhvT1ml0U7WqKkCvtBQ7sV/eQdkPzPFk6czk+bEu3MmY7+buQhn2n70Yh8y2q14+ZDy+mnNNLlSmWZR5tErM6koippH/i2pz0S7GsYszXqfyjA+jOOAE6ZTzq9rEgfTCUBXOY0s76S42Vjzj32r+5MWSm6v/38p5WS9h6cpq6npzM5p544CoZiRA29Az3bwk5LFgqvS6xQpVhNhu6h87oyYSDkhCc0RnZebXO2cab9xJRp+u+3Oi78rsA7mnmI34BKnAT2OUx3JJTO0SyUTIVgzAGrkgFD0psT7UVwNaE12U9tdaS8rFOUCrsvUBDNla4gtUzHZsFXoTMYdHZlX/RTQhvQGOGRZTubUpSOwdls/YACOoGgC3sMUCgMW86XmRPmzc58Wpap/LSGJBOo0sOXvizeS+Ej0rQYwdLJYDW7dQfnUrHu9EOoM5B8iqt1hSzBluFrlXcJ+8NPt/q3N4qrP8e92T+MzIuJyXW77cN7dK7F5YacnB7daqV9zad5w6XHK3czMF+ObxTGnpNIpcXA8MsjayQaqzVlj0jS4uJwFodu87M553UQy2kW9YoTZjITREQxJZlFLQvKqQxDizstpG1KKCK+cf2Ipzj5dz/klgp7fP3ual95zCC9JMq0wp4nkkfythtcB187/efkp8bVqtTbUxhuKjOzKANpdZh2eCZOpX9DRlH7IggM1EafVXF6CkfdmAdRRre8AmM7g7TGS7ULMeITLCbi2kH2mNp+
 2zNvp7nr
 MZAtFHwrjl7F/po+f6/8BYiGJGvJUU4dAMajAIFIhlm5MT/g5h6RQiF3weSGXnO33F/riuInvU/B5qD41HA8cFFp2OnDkNjpPhtEQ0narnlfWITU+uJ7GfBWGWnBb/EdP0eIIO7pB76jWwPcDsUIMd8qJpKvnQcvD92Mt8SJgQUtCtdHbbMxiELW6DQqK+6FLBMIuE4Sadf6JOuqRSAmBbGT9lnRQHV2JssNFDWu8LcxpvCV3IOpxDKLZpelsgl+c9FEJZdMo3pSANfY6iB4Zqw28oVEKl6RTo5MPIWSAdkdz/Pqi+dXIY3Qz+gjcCAVhgungwQGEuCLERQtNXq3r41rJ/YOPgFC+/g3vq294+AdJUB5SiW19JYg5UGZPCcCs65HgVWyEwZbt2xQMOucjpHUnYzER44Rl/D7PdLeDH53Qf3pkYA4bvS847iKiCqrKtidZMq5ANNHRvAUtWiP1aSxI1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 9:47=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
>
> Also, looking at the code a bit closer - if (!shrinker->flags &
> SHRINKER_MEMCG_AWARE), we shouldn't be getting into this loop at all
> and inducing all the memcg-related overhead at all...
>
> The code really should be structure as:
>
> if (shrinker->flags & SHRINKER_MEMCG_AWARE) {

As usual, i flip the conditionals :( But you get the idea...

