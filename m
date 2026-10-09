Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B25CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 12:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0152D6B008C; Fri,  9 Oct 2026 08:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F075F6B0098; Fri,  9 Oct 2026 08:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6166B0099; Fri,  9 Oct 2026 08:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB2C86B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:09:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14F498036C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:09:42 +0000 (UTC)
X-FDA: 85302968604.20.89678EF
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id 475C32000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:09:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fSIoVp/+";
	spf=pass (imf31.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791547780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJN6L3Z0BRVrqG/DbxfAbbB7P5rB4RPpZa9d14nZmOw=;
	b=uOvkY6QhJFDyAQYL+rcR4K59soD9TArgU6rBcjHKaQjgRnq1NJRKK7SQ5tL28hRed6S0K3
	EQb090Mr+HetdftXEXbxrDLf7EjDVAvh9qt+UFQmxFJd51TdUUuGmBFQwSJphwcPRg25l2
	q9co8FwWzMk36WStsYIOQ38VjO+Ts2s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791547780;
	b=ZrXQx3vgfMaM8VdTDNCwAd3zek5T8JewnIW+dtKj+RMBr1TxiSRnZK9k5zDyhOG0SdwOMa
	7m6pmAkzKXLNf9EKxxhzS7hXtOtwhPJH/C7LBlVj9i4YW7SYu/A6Ijq4GTM54qhFRNtDsV
	4tYEQbVdxsr51ih7v3skyVmElJUTSV8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fSIoVp/+";
	spf=pass (imf31.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so3731816a91.2
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 05:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791547779; x=1792152579; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bJN6L3Z0BRVrqG/DbxfAbbB7P5rB4RPpZa9d14nZmOw=;
        b=fSIoVp/+IcBuqzqNdSNAt06JqhbaqBcMbvN/XzmOYB1kylEOZx8O3T1P0uaIj4OaSq
         nTrF5Ta3PEoj3LoBT7NwtUA8TUlEcKLh0Y/z7yi/5RwB2gpS++n5N7z8qpj2IamCxKss
         L+8A7yLcPruHujh7+9a4HSlizB8blgtIx5SbGaxtzn1V42qqIng8FhtEIE7w9Lx9ymLo
         u+CJVboXf1NXcazSrcryaUBnCdChM0xf8t0grOEs+ioVXGhihleahJpH4K2Xq0c+5ITT
         1vzbg49i/YdmzgCJCXEN0IGfMgkKLUzrjXCHVG9PeHxXkzMESFHElrC9yNRNw9NUtD/y
         nI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791547779; x=1792152579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bJN6L3Z0BRVrqG/DbxfAbbB7P5rB4RPpZa9d14nZmOw=;
        b=0827Pc0sLNbvwmP1MFt2epvdv5IuEiOZFZx7wpAHQ7e9W1NbV5+SwnZPt5Xqcprr6l
         D+1dyZcgY5bjWxqWD3izoyLU5IZAxkS7ppfEqyWIuOuAXIFlcjIAVsJGlkVbksfD52ik
         sceCQW/TuuAUk3+daMIM1/jX5u0zOD3VD04d89PeLuysd8bu5x3fkSsx0+k8spplup3q
         UgzgSrIYADbU0u5BlqURVaHiAv85rTS8fEh9ADe9jWkwHz8Nn3cpfD/NcDsqF4eA+TqQ
         crvOTgF4Zi0xD04jpmvEx5+S7A8NfXqjNGubRnQkBazV49vNgx8TsjROQbK5PJ6xGiQo
         t3Aw==
X-Forwarded-Encrypted: i=1; AKwUvBz8W4YgYraXlFp8VVG6t/ajSKNgQoObQsByo/0ZXQdcGW1y6XxMtVMf4m67S+38iTS+Jtm8wOWwRw==@kvack.org
X-Gm-Message-State: AFq9FYLJQA57rhhwsM94jjGzNjIj0g4ALQmwSxeREvXDziKyLweD767w
	6eN9dfcN/bm/YI6C3LOFR0kd3zLro3VMtZmwPAvqsjueDVhuiCkhy7sAk+dKTv/Z
X-Gm-Gg: AYBFou0xjC7Sk6snxNGxgvCkKeew/mFmBmmkcFUYb7ORRxUQbYTH1Oho9DAPpykSkz9
	WkmHijKuGijVYo3Kq8laT1YCEdHpjqUYe+K/cOlsWWRzIXNPzalM0j4i43Mu+uzZPXxvfy8sYMK
	OrVxt4PpAhjY/SCi31eSy7K8LE9G42OITFOKGUO8qpNIDiT3cAFEKWvRdS1wXUxNuCkYGzaXgZF
	FqTcawsOLWYe/9dDZs9Cemg0kVwZz5P3bqDWHilWuBo19Tkzn58VbSUjIKo2ggAuphyYdQ1+sSn
	GikMyV8TyjtwGlh4SeM6/CfTYmhaNhJofKzH6DA8lnzaHo1aSnUrOw549e8TllIrG/QFmWzZASB
	rUrlw7HuSGABOIHTiFvSIDl8JDZUjOIEjnutVKqZqlTbGeDheCZPmiwRlMBgMKr+z+LMG5IflVV
	Fvo/I9Iz24cabFRpF9cEsZvMPVpiF7DrkjOGkdQ1FwPEUaDDhbEAg9TCKjSwcpsyM6Con14U2Ou
	iI1it7ydkiHBwytVqgscfOIbg==
X-Received: by 2002:a17:90b:2e83:b0:3ab:2d17:51ce with SMTP id 98e67ed59e1d1-3ab3a9116fcmr1554693a91.12.1791547778895;
        Fri, 09 Oct 2026 05:09:38 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8ea:96d7:5eb1:79f7:809d:9087])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38f4863esm3727762a91.11.2026.10.09.05.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 05:09:38 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Fri,  9 Oct 2026 20:08:33 +0800
Message-ID: <20261009120950.38879-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009080138.41269-1-sj@kernel.org>
References: <20261009080138.41269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 475C32000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kuqusxr76b861h1xqfkskqxrr4w7gwym
X-HE-Tag: 1791547780-983069
X-HE-Meta: U2FsdGVkX18N2PIojlmhvXZZrafocyODxenk8SX7fydWPGamYKhXvqZZXXc/JI+HB7QV1K2lCaG6/bjXxE3gzs0hEpAUcTQEh77278TwIyWXp+labwjzdfZnGjwSO+vXEBAYTtdyNF6mtUsKyhSnOOVb3nVDV8yt+Wq2GI5Vz4gVOwbUImpXsb/qhJtT/OgAha9pKVxBFaiA1kyvz/wFa+o0EgOjTnJLC79hFxCDIAVIwQ+eufcG2hx7eCQz/IdV+bKkfPRk0UNU+KrbFB2jLe0WTJ0pSyzO8iL6g9tYXgCdD8/dI52dgWwtLP43sdML0hJ4DjsJ2GBDRK5JWwLVOPPnLgEeRFO9XIE2w/jITb+JstnjnRRHI2QClTOMH14rH+Rw4n4ktCNEV8/BqrVzA/vacr7un5/TZBgB6yLTsScER8pxjLDWGjdWLwjGSia5uJCn3yccBxOEkSDqYn+bH9xtaZ8MzKQS9/AVLdVUMsE/Roxyf5qshUWQc9W7IDL11n29oN3BZXrZgUYRfzzIzy8YxXrnkDFmqzUYiYcyI9OobLxmLaF8SXv6/C31HkIq63vgKUrJeUxVWn7ntRU179xlIIkIl2lK0UKrFUdR7NK9gyPAmhWSqMuxCUDyIbGrQHu7yp0zNLi0tc6ddOPJ7f1SbZo8ieDNZLP8QrCC8+CXThCsM/B5KytWtvXYk9j7/PDoO/XYpFJKUPkhRiGa8Uid49Ogl67oLMi8ryuKzHTqc01PskXzwIcEd63PBnU6Xps09EMCPhhfjBhFu+TLEbBxeQ0z8mQPl6HVxaUsaTfKgobtB982+ObNTxXOilrUQf0LxFbGlx3KWszHZaD3iCwUlUM/Nysc616Bx0qfuqVciZkYkS9XgN9SzT4P5t2x8qte/qkEFH23ijlevw8QYZ6PMCk3LHhpH9/VOlrqmhlw3YkVVH65k6/YZ48qGjsOYv7BEeyKxrw9S2JpRXR
 c0iJ+OU4
 3pzScE/5ZV1Uty6StsZD/B8oaSMOs4pPHxh4MtVG3an3dgGaWvuZcoAo6fQjvhD1XsurfurlrCyGVpju7C9+fpkm8zdZw+b3szxz/TWR29b7zrurwHEQA0H6Z7tFqNx/Vw3dhbAR8jezQydUfHdYO5diAZprS8i28tGdomQEUfBP7/Jonhyd3zk0CIlobJwtPC9PQjivhKOKpVRSLedkL4KUzip618FupwotInm+2KJ6U3newAv1bCnbU0sSVxhnqW6unIGiVpM1PFrW7CMpY6oaqmSOz+JujcdjbYlcFJU33/fqmBlHO+p3ede6jngtN1S1U5iRWt+i2lLIX84h1Soe/BBrUnlN9gZHBgZWRQGMkt8RnUaqIvF6rNUw3m94nbxCS3hY/6mV9B0EBD/vFKVQci37tU1R8zSTBWLnKu+z4DVLd7V0eaEX5cyP1NtGOhPPE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 09 Oct 2026 01:01:38 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri,  9 Oct 2026 00:14:54 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Thu, 08 Oct 2026 08:00:43 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Thu,  8 Oct 2026 21:44:19 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > On Thu, 08 Oct 2026 05:32:31 -0700 SJ Park <sj@kernel.org> wrote:
> > > > 
> > > > > Hi Liew,
> > > > > 
> > > > > On Thu,  8 Oct 2026 20:09:05 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > > 
> > > > > > Hi SJ,
> > > > > > 
> > > > > > Just a reminder, I think you might have missed the question I asked.
> > > > > 
> > > > > Could you please clarify what is the question that is not yet answered?
> > > > 
> > > > It seems I forgot to ask the question, my apologies.
> > > 
> > > No worry!
> > > 
> > > > 
> > > > I would like to ask: after reviewing the reproduction, do you still
> > > > think this is a real issue?  If so, I will start working on a fix.
> > > 
> > > I'm not good at reading the diff in your previous reply.  It makes me difficult
> > > to understand what the issue is.  So I tried the commands on my system.
> > > 
> > > '''
> > > $ sudo ./damo start
> > > $ sudo ./damo args damon > damo_args_damon.json
> > > $ sudo ./damo report damon --json > damo_report_damon.json
> > > $ sudo ./damo stop
> > > $ sudo ./damo start --kdamonds damo_args_damon.json
> > > $ sudo ./damo report damon --json > damo_report_damon_aftr.json
> > > $ diff -u damo_report_damon.json damo_report_damon_aftr.json
> > > --- damo_report_damon.json      2026-10-08 07:56:04.979178016 -0700
> > > +++ damo_report_damon_aftr.json 2026-10-08 07:56:27.717941609 -0700
> > > @@ -1,7 +1,7 @@
> > >  [
> > >      {
> > >          "state": "on",
> > > -        "pid": "46402",
> > > +        "pid": "46449",
> > >          "refresh_ms": 0,
> > >          "contexts": [
> > >              {
> > > '''
> > > 
> > > And still it is unclear what is the problem.  Could I ask your elaboration?
> > 
> > Thank you for testing this!
> > 
> > The reason it did not reproduce is that no DAMOS Schemes were configured
> > during this test.
> > 
> > This is a bash script for reproduce:
> > 
> > '''
> > #!/bin/bash
> > 
> > mkdir -p /tmp/config
> > mkdir -p /tmp/output
> > 
> > ./damo args damon \
> > --kdamond --damon_ctx --ops paddr \
> >     --monitoring_intervals 5000 100000 1000000 \
> >     --damon_target --regions 0-4096 \
> >     --damos_scheme --damos_action lru_deprio \
> >         --damos_sz_region 4096 max \
> >         --damos_access_rate 0 max \
> >         --damos_age 120000000 max \
> >         --damos_quota_interval 1000 \
> >         --damos_quota_time 0 \
> >         --damos_quota_space 16777216 \
> >         --damos_quota_weights 0 1000 1000 \
> > > /tmp/config/lru.json
> > 
> > ./damo stop
> > ./damo start --kdamonds /tmp/config/lru.json
> > ./damo args damon > /tmp/output/damo_args_damon.json
> > ./damo report damon --json > /tmp/output/damo_report_damon.json
> > ./damo stop
> > ./damo start --kdamonds /tmp/output/damo_args_damon.json
> > ./damo report damon --json > /tmp/output/damo_report_damon_aftr.json
> > diff -u /tmp/output/damo_report_damon.json /tmp/output/damo_report_damon_aftr.json
> > ./damo stop
> > 
> > rm -r /tmp/config
> > rm -r /tmp/output
> > '''
> 
> Thank you for sharing this script.
> 
> However, issue reports in genral are better to clarify the expected and
> unexpected behaviors of the repro together.  Please add such clarifications
> from the next time.

Thank you for your guidance.

> 
> And maybe because of the lack of such clarification, I still don't get what is
> the problem.  Clarify, please?

Yes.  My expected behavior is to completely save and restore the DAMON
SYSFS configuration, including DAMOS Schemes.  But it cannot done by
'damo args damon'.

In the script I provided, it first apply lru.json and then uses
'damo args damon' to export the current configuration file.  I expected
that reapplying this exported configuration (via 'damo start --kdamonds')
would fully restore the previous DAMON SYSFS setup.

However, the current/unexpected behavior is that it drops the DAMOS
Schemes configuration entirely.  In other words, I cannot fully save
and restore the DAMON SYSFS configuration using 'damo args damon'.

[...]

Best regards,
Rui Yan

