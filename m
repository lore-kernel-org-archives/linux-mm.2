Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A126FE6BF2A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 16:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F04E6B008C; Fri, 30 Jan 2026 11:48:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A47B6B0092; Fri, 30 Jan 2026 11:48:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6AD6B0093; Fri, 30 Jan 2026 11:48:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF86C6B008C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:48:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EBAC8C1A6
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:48:34 +0000 (UTC)
X-FDA: 84389213748.23.128E718
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8712AA0006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:48:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Q7agNK3l;
	spf=pass (imf15.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769791712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MzBnHIH7LnjecF3bPO9bEFfJeYSW4F3Z6RvyBhoZ3M0=;
	b=CqNWDky84bnqw8fIYb5YMjjgLBxK4Aw0/rboBvG6bpYU5A6z8fIBMOZ9VulLShSQO+NNY5
	8iwPOssWZDqZwaiHqhtPtlX7cnKU+mQAbTUqTebjEoLOkUM2vjbxbU3T5jlse78LPfogb4
	HT69f241nfhsQlstJVGYyuYDR9SatFg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Q7agNK3l;
	spf=pass (imf15.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769791712; a=rsa-sha256;
	cv=pass;
	b=YEBRV4ZG5jdUlQgTZtG6EA/I2koKrCCVrc38CcKxVZ97K45fyQS6Us0zLfUHzgTtC61s40
	ANx/wIRJd0Rr7YToJj4QqBwIJyYsw+jdqkLNNgQmc0kf5d653QsY+nYQDt5WZwjj/Vip+K
	oQUdcfI7FfSGg6iUnH0kf631GaAvVOQ=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a7786d7895so16978085ad.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:48:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769791711; cv=none;
        d=google.com; s=arc-20240605;
        b=MSAfuZWi3gw2sLOTbQqUECdmUgUWpEKQEQxEFMAygcBGU7/Y0UxO9aK0xUL6dU51rT
         BE1v6hUIQQhGUf1+4wuQVDEUOc5JTa0iTRBcaDWxY4RFBwOqMZ7986G7sVkIqHGxB7TU
         7j6x4wnDyWRjOB94R6et3nt/vTfbPXAXwXK5yLiLVA8vf69zxtJLIvEActAOgmCDcRBb
         jv8f86xWJ0DfUZUT2juLNmRvj/VQwmBJ3/BIiMwglPPzTNlyq41Akfv1ilbjr95loaIV
         TI/eTVvVU9Or4FuBK01GpDvR3tchQvH73ZGUEyYP5TZlHp6WeGbA2SIv0jEpuvroLnrS
         F/Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MzBnHIH7LnjecF3bPO9bEFfJeYSW4F3Z6RvyBhoZ3M0=;
        fh=rbrqJucQSNaAmzoBwaQVrBK15ighsvAwm1vYofbBHaw=;
        b=EkwEVpTUPF6yRVCNFjAmqzP+ERZg7BWi1d92KWwuPvHJ/WizGtZmkue3hNIbEiyn9K
         0xV7IaIsiXuEgtpgb9xMVZWxiswDuUKy9zdO55FQzQ1h6ftGw+Mxf8uQBHr7IPeuZ7Z7
         Jvo8dm8JsL/G+evXPRWai/w2rzS4Fivh7DdmcjYIEbstOAkCw8hz8SKiD6AxyqJq2IHc
         UHMYZbiroaB/wBPwlPdk8zk0omsfVnHBdTZXss4zF8EVZdAChXh7XVH5e+bdLwcZfpmI
         yOLntSLlaJx8+K+DJB1NHBBU1+RkaVLFeTD3QF5KHr2E6FGqaHZV9WSiJOO5ZfbysU8g
         Y3pg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1769791711; x=1770396511; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzBnHIH7LnjecF3bPO9bEFfJeYSW4F3Z6RvyBhoZ3M0=;
        b=Q7agNK3l0Qh8A86abdtfejRNustmfCZqQo7eV2ZksvmQ9nTuXMfB1gfWqh8hGaL6Ku
         wkE61km1/uM+Sq109WDn3HkjoUZSRetnlU6S76VjABeWpxjKxFta7LINSEmIMQzEsylt
         HSFKQdYtv6yzDWvbh6UHQ6Q8fqOTk2Z3GlKUr/2VK2q1TivavsmL1TV3HL8hcG0CshQC
         evaD67oiFZLdudn5Hon93FANfbfzlTKW3EUeeK9LEgM+KXAXIe/Y1pBNoaEx7FaLvES3
         kiZIH7sokSFnG2Se//NnmAyyJAQx5gIxhiEY7WpXm+4XbBmTU5At+wAfLi4wXH/i3Bul
         IlRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769791711; x=1770396511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MzBnHIH7LnjecF3bPO9bEFfJeYSW4F3Z6RvyBhoZ3M0=;
        b=wbI9YbtYOyMF3K8RUa5nomwQie0i5xEmHyD2gKoGkFm7LIScgTx+YHS9+CrntOd2AL
         1CAQRxKh0J3tk5s2msHEEQHkSXfLutf58pJDQEsy5ECLkw3TmJlCLSkYKzv3VIzGABFs
         OrOqGr/u8LYcV62tBJQCd73jkhkofXELupJ3n2KFyVXt4obDQPwsxcxuoxe6vj65Es4W
         jfqJX1hohsDRqcqkn3QdnT79py0BpZJIJ2iLVikU/4srRA2C5K/YezMgFxJ0gcABOeeg
         XlnlA1mc/hn3nSKPsdaAGjs7N4P3Z9SpGP+Jd6sSKkrvBqWJoz/fgGLTTJBnAp6lifVF
         EdRw==
X-Forwarded-Encrypted: i=1; AJvYcCWXdfKVVfMXKktlnVTmGw2OHs4Z4bbZofcPB6YiaNrEiMi1JI0CUK3tnwTUPY1YfsGfTW7Gmw/avQ==@kvack.org
X-Gm-Message-State: AOJu0YySj+j1sRy3VsaeyBAZnEcAODc0GHdOBTQutLlgAoVqZMzg9atU
	CsiOFrdTka8j34//TlVbUpmuKmrD3tXSBgo9e3qp9LkNdvq16wP5/9tvWBHszUKqBX/sRozBh38
	Ms6PzZCNVWuwbyGwohDFfDXYI80qCRhGxo6FcH3UK
X-Gm-Gg: AZuq6aKlgTCRkW6SHOVlhL5za3pje6uype9SBr45AfGMg0AkiWqNOtctariwUhatUMK
	xlt6Cwnh2dWb21WOmwdcM8m1OmHChIXN4mXWrx3s/dumIsHTMSXmmkPaU6dXtAT9/YVzMBHM5VK
	pnsShamAzh0C9vUQoyPxcgIEc0SQbkIiFv6gDK6pvXWRUdPw+uyDudSlZoQusvCTyHiMQP6it3D
	Y8v0xAS1kkacKaGl1Aov97gUy6jcV0asNrhL9MhK3u9eD94dZZLMx+Ad5onRhvErHMzh7M=
X-Received: by 2002:a17:903:2b04:b0:2a7:9e5a:a516 with SMTP id
 d9443c01a7336-2a8d990b710mr38647195ad.28.1769791711048; Fri, 30 Jan 2026
 08:48:31 -0800 (PST)
MIME-Version: 1.0
References: <20260129225132.420484-2-paul@paul-moore.com> <202601291730.45120C1A@keescook>
In-Reply-To: <202601291730.45120C1A@keescook>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 30 Jan 2026 11:48:19 -0500
X-Gm-Features: AZwV_Qh4Ohkl16EgJ4oaj21z6gSU8EcMXzEt-HgB_8gRApB5wUnJP5Smmit89ag
Message-ID: <CAHC9VhS77c1-5HTRUVXV=e2Z7Q3wHeo_e8S3RswqGWLTB0_ZhQ@mail.gmail.com>
Subject: Re: [PATCH] lsm: preserve /proc/sys/vm/mmap_min_addr when !CONFIG_SECURITY
To: Kees Cook <kees@kernel.org>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: isjkizyfc9bzc3ufjc8xkspsnyp5ero3
X-Rspam-User: 
X-Rspamd-Queue-Id: 8712AA0006
X-HE-Tag: 1769791712-497107
X-HE-Meta: U2FsdGVkX19YKtNmZM7F8NJ8EtNK2Tsk8YBlU5BosGxyNqXqE8dm60GTos6Ri+ua5JP7vR/tpbqi63KUbPVQiPWouCLehY314A/b7GHSCDomEQW3TumQP8C0N7xrPG25EiaufE8+a/YM7RCOZLyKzi+NOmGkk8GIpxJ/yexJDfaTbHPEejBzeKoAF/izzYk8p3NCanzANeH2Dz3qRwH/bMH5fVWGsRqPxk0Bnfc04bk82O7+aBa3nsHb2EEMbV39RELCKLnL4PtLR3VqgKOnw9629IWdjo8PCt1iPxo0Hi5FZDO0KTkiJdZwYEyCwJPlqrS7q8AMfRCvXUPROr1xL5S8mk/psAWiJgbLyQwUnyP6LuEFapVcHK5+PwaQkj/UJHOa9Sgg6I7xpqzrikgT3dLSTEHuUlWO6Ya+cckUGseXG1/X52yTgKK+5i72mzPPwl/iRz3A12gN3KGHZ3dACMXwEpKSGKvU4CYGj1Oq88w6HRCEmQYQRA6tpaoGZaHrC7rEEfBgZioICQ4bbYhn78yW6kYonK+mE8I7IV5ftLHPD7XUMhOyrS4qrWZDpgk0Y30jPv3+HMb8XeuxU6l7gg+kt1sTFa0B3ve7msEeDc5MiE2ige5g6xF6NQykDTmNbSSnLkHbAQacwcZRzL/nekTnI5GAQ/v0uPT/ccxWWv0W4zEDldj57NbD0NXTANaWI/6L9B+VckXIIUhb9eCNZEzuDYzv+c6lnR8/wRgyH+Z9IZ82Yae62jtkc+6eb/vk2pRN940tGTmffNT7Ek3L21dXaHTYaJ1rbEf6H6ihXUefig/YQHkG2/RBuS0nD/WE6IqFKCOW6qvpGHRlEUoVwfiAU+jYRiXkQnGCAUXe2108gFlFK8gpUPSC4WGJT7epjeOdtEgz8TY2Omcjtu6mzJKKubKGV3FpUjCxt3K1QP8gTzf/lLlo2K1/dsVncOHXlw+mqfmps+kdrVnEyTJ
 N8Fa1MB3
 GEHfMB7AwkAbQ/FFzUc/UMNsvZKbA7vHl2qMUJroT5uEdvrNMU/s8+M/plQf6ljsm0A5HUX4MlcObptC0Z3XNMQdY2w+GxaNF+pe+jPhK+SH51KPQEAfpdriVYf+928qMlm/E6MIp6PWMtPSFvG/95dMo3peViUPfZ6H3WXSnzzwRoEo0seABrT+94PZhcPz6Lz0C2ImWbRNLaRyPA/AyJF3RAIQaoen6CRfeFGYyLj+aJIiVjkNDFW/t/IUMacFJAi/CQEkzWaRARxuuC0tFNfRCIj99NpubVjksNYgqkY9+/Xlx7ngu3ujMURVF3yWORuKYMu73gZwWxPlrUkvFSGVvryvfM0Siw/52fgimz2sGrtEKx/w0femExCGoB1CiIcimU2170vGate4zavBuGh9COmTkGb/rfQ04UDCbqfk1ff9B0YNr93/qUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000046, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 8:31=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
> On Thu, Jan 29, 2026 at 05:51:33PM -0500, Paul Moore wrote:
> > While reworking the LSM initialization code the
> > /proc/sys/vm/mmap_min_addr handler was inadvertently caught up in the
> > change and the procfs entry wasn't setup when CONFIG_SECURITY was not
> > selected at kernel build time.  This patch restores the previous behavi=
or
> > and ensures that the procfs entry is setup regardless of the
> > CONFIG_SECURITY state.
> >
> > Future work will improve upon this, likely by moving the procfs handler
> > into the mm subsystem, but this patch should resolve the immediate
> > regression.
> >
> > Fixes: 4ab5efcc2829 ("lsm: consolidate all of the LSM framework initcal=
ls")
> > Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> Good catch and fix!
>
> Reviewed-by: Kees Cook <kees@kernel.org>

Merged into lsm/stable-6.19, with plans to send this to Linus early
next week after a day or two in linux-next.  Thanks everyone!

--=20
paul-moore.com

