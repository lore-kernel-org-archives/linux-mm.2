Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BAFD13C39
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 15:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854826B0005; Mon, 26 Jan 2026 10:43:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8021E6B0089; Mon, 26 Jan 2026 10:43:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704116B008A; Mon, 26 Jan 2026 10:43:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 613A16B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:43:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03BD21A0828
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 15:43:36 +0000 (UTC)
X-FDA: 84374534874.09.DF239B2
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id AF2A240010
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 15:43:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XIwhfHYe;
	spf=pass (imf01.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769442215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syuEs8QARhmjr0ad7z3aeMN6tixAFbRn00lc7K2yoNk=;
	b=eL1Wyb539p1dYbcahdFd2EUdGPtKGyZcqIp5Wp7/kyhAaDXi49eOMjcy5myAJ1fQ80InVS
	qCSEnc7//Y9++Lvr6qShrLuTYgV3c63G2AJWjptj2e0N1p53GHNtqC8ZVxOvWw3zU7vuUF
	74AjoA2inAxB7xzKr7l5dToIBguz0Ug=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XIwhfHYe;
	spf=pass (imf01.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769442215; a=rsa-sha256;
	cv=pass;
	b=O+IL2q8t5h0nfMEQoIwn+EWaEgJi5H365iJC/MI94bLgXC8hBb1MQ1BaAynN+lpnwJMPrs
	kt8YCribNJU0C9ZN4DhUZXjpvJkX0w7H3a9gkZxRGb+7DsgyrT8yGGiFf9GO+i4ZZR///P
	bnFWCQdpuz94+gtCnHEiXArH8KBzo1E=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59b6f04cae6so4799521e87.2
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:43:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769442213; cv=none;
        d=google.com; s=arc-20240605;
        b=JsFaIcWUP6B/QjqqdBoRjPkinkvB34EWrAekkKBSC4P9Lfqv0nr1Lf4qh0EPqhK0Mb
         GZfZ89o4yYVh2+Dx1jdfcTPr+g95SeHzzGzZP4myuoF27cYWfXOughIOV3OZ/StFZoFP
         Y9g/k2ChtzTnI+BB90jg2DdLXIpl38QlqC0DIH/YvcAXtO0czF4psdSAaUWGHR8bDI7y
         FlrcIuS30CMtXdpbDQSqEQqESeocLHp1aHKAG6kqYOW1J5cEEn5BANoHyU4pok7bn8mZ
         K/xyCcp1ujo1upF9Nil1/uZj0PJnx6qLQlkoIgp0vW2HwFenNWfnYNuiiNf51lpqBkhC
         NV2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=syuEs8QARhmjr0ad7z3aeMN6tixAFbRn00lc7K2yoNk=;
        fh=F0n2gXGDHCMLqj8NRrIiwgWnFtR2gLDBFLqt6vKd2H8=;
        b=JZKtlZCPfEJLEomDbtp54X/uqC8QTD5+Q1bdPkN75ZJiG6SBGZAAkJcH4WNdOVVb/w
         9clU9MkQ+2b967Ahjt8BUDDc7DnT1IbmJXYy4LmhNfvhnMMiQsqurUQw8OCQLyZj8+1e
         HR/vaFybj6UmZ2eSc1SBnaEKx26Id40nhQ5laJiaZ/z9lh9hxzCQi6+n8Mkxr8Ljgvev
         INRELBDgfB/md5YyS3UnQmo/cskdJ/XQiN1f0hlJBuuzt9S31Ig2uaFayssUiERFM2rq
         o6XjgNXKCyLSXVZGLZJ5/2iiacSituBUcey5uAHGIgDTkOrZbcyHi8ryZKOrPYFdNFoE
         6y8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769442213; x=1770047013; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=syuEs8QARhmjr0ad7z3aeMN6tixAFbRn00lc7K2yoNk=;
        b=XIwhfHYeyzNdY0w9TIrZ3JRYndJSCobFnb8G9CfwxSxR9UInM/r9dM2lIyyb+5pu/p
         X6KcN/MLI4YUknP6wPrIhKEmzY6eJp6NfwtSf/Eh9IGxuDtLkbURca5Ip1UDHtVcifxr
         hgoiYXWdeanyCqmkLPPjJ2aQnT/s6xPGSCCMThiRBBA2HpnRE9B/0UALFtFDjH+g9A5/
         lBArjmmKUy2F56pHDQ4cSu864LJJ5VPC7ZVj2+xPVHVHuGA3y5RJjVbB7AeH4f5B5Nj2
         tkk4mJ6zn0EB8q/1XNFhoz/DPseDM1mca6r3gHjUxdTMZU/5RFToVMCiYuZTMJ8iG+mu
         vGuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769442213; x=1770047013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=syuEs8QARhmjr0ad7z3aeMN6tixAFbRn00lc7K2yoNk=;
        b=vsepI1oBxTrGCIsOGg9OiD84+YRgl7MqDgX7CPJTDIaGz1nRoMZtGzU0PKYSFlFY63
         Vs609i02eplrnzRJVCN75FYVmcCnh+uZ70vtnVqBq4vFeEre7annKHxMxRxwy33vqRMz
         TdWN/PQG+0BEFjq0JKYz3gdQvgJbW1hLCyXMDsegxtVTmTbcxS5VY6L1UxkbRUs2HhlJ
         1dOk6jF/u2w3tUl8f+XQHa7oEtCmOztQ66x2j7UDJLBGUR8zN9/lqDqqBTa/sGH0vkIn
         L1zA9z6z1irFM8hDHybl7zlt+7q8bjjQVumclTHLq7plDhZjIA51kFHZmi6Brxbzrooq
         qprg==
X-Forwarded-Encrypted: i=1; AJvYcCXuEsNPKOVfc0/Ei4ek2awiPQZ+BAo17O6zk+hcIB/sgZGIgEJKvz2S/s/Z5KLkYHdFIRVuGrPI6w==@kvack.org
X-Gm-Message-State: AOJu0YzlGSqwHiZi95fqOvLIe/4p50XN0nB5VL8fDGSrQCt7KbQyrI2x
	1Bjww8bJUjmzTYNogS5zKrSij5Sn3j0PSOrk1ZBKR8gQt7hNst1ltAKTS3IXN0j6FQR8DBRJGWY
	+AhhsxM09Mdd18DzHErc8EqmeuNiJhbqfuLLIOZRmRg==
X-Gm-Gg: AZuq6aIXTywIfdWtXQhfdJgQkHDpEnuKr9CkDCWfq4F3LVi0ec+qLufusx4gnHOQJrI
	LUKU4cWfenUEtpGAZbFDJbqPeWswzBGqKOOHzP4hDL/N9z9hRAz9BQkczaI9QagLpyXhzOoD7lV
	hPzyDnoZihivmdudO2aj/0rq82fuaABxHEBp23x11ddlHD86VSFjMl/ISR/2ebzjrMw/d7kV+3/
	zOG1CKDhS/A3MpVddJHRFWFknz5ccoQXbcjhSi3baiawQpPwfDCbYWiUnNgCWQFdwgR7be9/Zju
	1Dd56uy6NeBkTtqe6UdphHnuo66WrwL/ErEZ94g=
X-Received: by 2002:a05:6512:33c8:b0:59d:e350:3c45 with SMTP id
 2adb3069b0e04-59df3a8878amr1649750e87.52.1769442212690; Mon, 26 Jan 2026
 07:43:32 -0800 (PST)
MIME-Version: 1.0
References: <20260113114630.152942-1-marco.crivellari@suse.com>
 <20260113114630.152942-4-marco.crivellari@suse.com> <20260124222135.XyGv6OqY@linutronix.de>
In-Reply-To: <20260124222135.XyGv6OqY@linutronix.de>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Mon, 26 Jan 2026 16:43:20 +0100
X-Gm-Features: AZwV_QhWwQeAe8qxxRUOhm1FgDlS7o5tMx2lt48Rhb8O1nebFZlywwUCr4WAx-s
Message-ID: <CAAofZF49yM4UN36-kQsux7LM3YrV4PwEoWMZ_Rv1-_RTNZCH+w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: add WQ_PERCPU to alloc_workqueue users
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: AF2A240010
X-Rspamd-Server: rspam07
X-Stat-Signature: o1hqu1n73uq5mesrbaxcq9ogsajft4b9
X-HE-Tag: 1769442214-653400
X-HE-Meta: U2FsdGVkX1+OE99zUTbkKWakIAYw6zPnu2pdL0zlimNtPYGEvd3Ed06x/rXljzVixTUtU7jbR3Zo9mfo8lB5w2y0r67HTx7OWOk1p9lwZspSygcY0dt4j1SbDtcWz/AW1L75BWS6Xvrv7wdLq4rwKCjYrwPx2/fn7PyClyEBF9nEa0TaMqVZ9ECQoxkfRYVJwOkWrycuDSB5KZd/CvW5qcprYfG2IgudcuHwm9mA+0yNCJ7j0A7b21gI0RQHzMbPx7qc4VSU/hIgcXRdFVgV8yMy01lyYrw3dS54tAfhzCiq7dJyogRwXvwhJxnCWvz67dGx46tJHSZWLfaVvgHEM/ZXL8Rs8pzd7+7vD0MudMidpjMC8BFcUs49c45a6aXl3wtwNUit7O9vNeRbPugW7wC3yaO8t8p4+dt38QLd2vbDItVCjO1lPD+Gk4J5hQLPDJKFcXPZDaiQXQnaOXN4muoECnItpcqrVoMREgM46VV0HMv9yuaHLvDsd9FH+e9ej7RZrjZ7q5Pq8PqtJXsakxVRiAYr6rPRqUkVQLG0dEWaC610C4FF4ML1JkwndySfjUIGUzhuCw7O47r/hKALrkkHq+RpL1AUutm1rUcv0DjDnkBhh0WTpoTkqIJHDut9tnT7i89pqUfgv8D/NsGBfyoJ1ii/eiESpXkyplL/3tIy+4EHzOZdSRQpTWtLm46Df9P1UlAZdEDmc7qSIiIqGpzpQs6n7QPA9sa77C6oI7Hd5vMs/fSP5O7MCT8vHqGdmmG5k40srAFOSbIIrZoZ94W8D/2RWkGCNBofpAJA9jB9M19WjqBWKiXiOnMDntaoZHp7fdZF/U8F3Yr0jR7oIjKPkA1kJonXeitF00OX/EEyYvv4a5mrtCDTFBTBuWqETS1s3eVmgIa0NKSzcm4MMVl/j+7s0KoGauIOHMGXpJaojbEr9MQX/PeH4uYtatmufJkgM6yvUdReSO+Gzpz
 NJlhORuG
 EM0vHYlM72MkbGuBLMbkEayhexNS/bHSSc3wkm07SFDAEYo9u5NlSDYNMNNdMVGElGzlb7ZYOIOaEjQ50tgv+1XJ5WvksEkLE+im3+9pO9KVWDB6Rp9iekBM6HoKdtKPzX9d/Bvo1o7qBDxe/HqTaSnD/fLXuhFg7oL1stzVZ+RvpBt/rJOJFG+CBVzvFiMF4Oh9wPWJiUCjKuv2jGcZWbtv/fDI6clSW7U28eXet65eqNVMrUbwIKURSNQFUR0sLb8iFlSpa1xvW7dCK+DuM21pneA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 11:21=E2=80=AFPM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> [..]
> >  void __init kmem_cache_init_late(void)
> >  {
> > -     flushwq =3D alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
> > +#ifndef CONFIG_SLUB_TINY
>
> This ifndef does not belong here.
>
> > +     flushwq =3D alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_P=
ERCPU,
> > +                               0);
> >       WARN_ON(!flushwq);
> >  }
>
> Without the ifndef above I am happy with
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Thanks, it seems like I messed up the thing when I rebased...


--=20

Marco Crivellari

L3 Support Engineer

