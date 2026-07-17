Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2362C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01006B00B2; Fri, 17 Jul 2026 12:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B30A6B00B3; Fri, 17 Jul 2026 12:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0BE6B00B7; Fri, 17 Jul 2026 12:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDF56B00B2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:56:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D64A6160195
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:56:13 +0000 (UTC)
X-FDA: 84998871426.12.DDEA60D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 10DD940007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:56:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MUi2FbPm;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784307372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaHlt41/hvOJvLvitj/2kxV3NYCQuixNvOi36N10KU4=;
	b=6CzjBWWXO5DpFpI9aNsI3iJ54MKH3JDnZDiHw+mAqTqyjYVEDCC3iySZ8K0rMdDf/FoMnf
	vEKcY9S6M+pKCsgK4yQsPi7wkQtTFBR2Zwwa1DrYBP2vzipRolJBMaQQPJodXTQPC4X0Pc
	2gWqinei5/PYydIpBfcVetW62g6klhM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MUi2FbPm;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784307372;
	b=7KEypsDdqpCiETcx43b+M3uhDlMscRp3beynI+CvNEaLnCG9pS1N2psFqRzRU6j4Cu5h2u
	Kkr0SwyERiTVMfg/kj3YIT+X8UM8Qn5Wu29VZuu3Ve4WcBib368inxhzxUFsaP1LcCu2j3
	V7GYm3YF316ySAnDMoLnl1t+VpwtP5o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BC5860A72
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6C21F000E9
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307371;
	bh=YaHlt41/hvOJvLvitj/2kxV3NYCQuixNvOi36N10KU4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MUi2FbPm3fwo7a8P3d5fdAYLmDCQg3kxkoNN5vhp7ggx/WyX66s8yJlZ1SBJIvh7i
	 a2OL+Rhs7B+NX5vt40G3lXMuMlqgIdtHFnEbwxIPTNEmpF/g0rXnLVARMGVkYeINDw
	 yPI2b4sWELW3OKh/WnsYhjrBsEMqT8aWBc9dQnE5GqK5otRTG60vTIm/KsD3sjhAUh
	 i5uXe2WDauDfCFarcaHpNcfbmT4Z83XNC0iB1vTjLbUKmAL7gjYKX9Ecu7FzHEamLC
	 GJYVIBoP1HI/Z7EJ8u0g79yTbG1sAx/Twt8wwbQ4p87vjktQs2l8r8jMsu3zuf2NSL
	 jlXTp4boWMofQ==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92ed3993c1eso299860085a.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 09:56:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpxZO3I0SwtPGNqbus/hHC/4Ks9OBw6hgk2boXg3VIZb08rlXiOMUKa0ttDr2k+7/1PuSCPDFFRnQ==@kvack.org
X-Gm-Message-State: AOJu0YwgymH8zVHO/xixq6oTNa5SJXplDiuck0hp8ej+OXgFL0BxPXCa
	+z0wYWx1v9qxJLQdT2sH4Z4c9uzK56GoM74Kw1mWhLNBjloVref3xT3Q+qZsb47g9WVLfTDQ2JK
	FV5wyZKWFwkBwechct9lC4OgejuXj2cM=
X-Received: by 2002:a05:620a:1988:b0:92e:5259:1154 with SMTP id
 af79cd13be357-930b3ecc422mr401488385a.39.1784307370342; Fri, 17 Jul 2026
 09:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-3-jiahao.kernel@gmail.com> <CAO9r8zNiT63LUHx8X5i_aboX1UWuGkcFf+p9ch-pekURUuDdXg@mail.gmail.com>
 <2bc8e4f6-46a0-5b74-6eaa-59e7aef9227e@gmail.com> <CAO9r8zOFg_mnNGbFFd_h8FAwRCbQ9vXk47EF5f1CLg1cDVGB5Q@mail.gmail.com>
 <b910e870-9583-a2f5-b681-e69edb9af290@gmail.com> <CAO9r8zMLGMpsQ+HbLA5SFSMEc_ctuZoScJMkybnXMp+_0MW-yQ@mail.gmail.com>
 <CAKEwX=Patm4+gxtxwDYBFXFh+jfaOUSvtKtVZFvp=oQwNmdu1Q@mail.gmail.com>
In-Reply-To: <CAKEwX=Patm4+gxtxwDYBFXFh+jfaOUSvtKtVZFvp=oQwNmdu1Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 17 Jul 2026 09:55:57 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP8L_4dOSVQT8v6v83uAN1ZG_7vTMxfp5jDME8U2sxEhw@mail.gmail.com>
X-Gm-Features: AUfX_myUxG7G3wSjX3kFU7KHxWXdkDog2oSpDszGYJpxnIxoJbNXRcZjOxi9Vho
Message-ID: <CAO9r8zP8L_4dOSVQT8v6v83uAN1ZG_7vTMxfp5jDME8U2sxEhw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10DD940007
X-Stat-Signature: xmzfxyb9p1ghs3n8mew1hpaemtt4nger
X-HE-Tag: 1784307371-612078
X-HE-Meta: U2FsdGVkX1+CKGHO31FxRO5ilz9bwBnBsWXXGvDQxVwjoxyekrFGyZ0e85ojs0QcnZDWOtaFdVseVNqiUjIRXokat7yZRqW0E+ynPESAB6M3AErE1jcVY3W4CV8E90nSa6dey6ePkLLK8+lJ64djrVz9t4Tkxtm5OefjMc2hY6rVBGM00lYBrwiybeFc5ySTyswtc63odF6DUkpQ7C49bvT1pr40dgv8VhWIYwisHKguD8LwqilJtCtj8sb13Q8EPYsTTVB/3mtUexcwj7/K4F67TCbv0pPdMUYUblQpNrHPuOcetNmmH7zMlLNN1VFyynrUxemFcsZV+juqQFF0kVFQnsbfmkOLNyZK8wo7irRl4R/bLDk0MjL4Rup+mXslUH5e4bT6DSYUrZ4gLWuTUMk1XJZSO6148svrA30rrXDGEORC5CgpAJs7kn+zbci7SPf5gra9l8qu/APlkUubZzDWws5L2S3p+X2Z2qxXOHbvs9G23MMejbBJg3oQWadd2QgEfHM6v/lAZmAEs30lQbnYsGMGNDOyYDrGmZGhufJWEqgzoEz53aSXOqiXb4l8XhJ/t//zqvRerJMwpl1KJu+Y1d/EMUyOCk3K4FXo9V2+q4uHmVLSFLxhmFinId+Ypfcjuurh/hCry++1THfogFGgJQw60dzGGZRo8GPT9kTOvnH81zxGsyXKhc3zbr+JF9CdC7LK0fw8DaX10ndkOICkqshB8vRv9P5vLbLe9ADPlHqOF2P7pwNn+3Q0Hgp/iihHxurrvB2yRgtozbbdnJqOJ/rvYlThi/NdLLrTkPjtTkwCdJJZB+kLk5ov4Xg3C4fbHATVKxZLJkOQa8LGPqw006ApWEe/WIvfDEtx73koYOBx7UxTUjhCFwzWhDkHkgL5LL1P9vYQTZ3BzFpplmhNddJ1cj6InRAFjGP6r3lTeLR7rCXreq0T9H+N4m+qp1DmTafNpUncmSf4mfA
 jpXC1pvH
 d3PTRly11HuETdsgdDbM+lDT7fQ+/8i0DF6ThwAMcg8YwOP51b7MaTf3f7kaEXT1mN8F2ZmMCHwYgq2aQKrROl7vh0ubRvFEHNHaQaxBiCd+62HHWayjXyZ05u0wpuekLQBWCrGyMZwR2FW2sL3GKlWCJvOVZugk+21/yYARjG76T+htTh1LvUpA4fwzZaF+fNUyGZ3UJZ9YRp16vxhg3Fhj8OouzzMWm29b9bU49g5LczFKmAxTJoFqOtGfy8/FEZdT7capmILMJck8u7ybg7CM8WglAUvu8fOrw0nl07K+wzuDvi38DMGcUcYdQfDfeFeZMlfGIUcxteMQZL//eAyfQweX2noTB0UpErvf89l+J8Tf2KkZa6K8aeUnmDVQjli0wLd5ZnCwnDtiPsvZtIzEyJ8YnPGLMOWJqLZr5c0RWly1jGGe7uM3Eut912tABiYLWiVNd2zUFtxXGyZtnNwzQ6APb3Xc3yOsM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 9:50=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Jul 16, 2026 at 1:35=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> >
> > It is a bit alarming that the store rejection rate is still 43% with
> > batching, but we can worry about this later :)
>
> Yeah I think it's unavoidable at the time the global shrinker is
> awaken, unfortunately :( We need to kick off shrinking way ahead of
> time if we want to avoid this, especially since the rate of zswap out
> is going to be faster than the rate of writeback (CPU vs IO).
>
> Sort of why we implement the proactive reclaimers :)

Arguably, reclaim should wait for zswap writeback and retry, similar
to how allocators wakeup kswapd and retry, instead of just skipping
zswap. I was actually thinking about doing this at least for the memcg
limit case, eliminate the sync shrink_memcg(1) call in zswap_store()
and instead wakeup an async flusher and sleep.

A problem for another day I guess :)

