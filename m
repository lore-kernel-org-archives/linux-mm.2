Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08EABD6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A066B0343; Thu, 22 Jan 2026 14:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662316B0344; Thu, 22 Jan 2026 14:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58E106B0345; Thu, 22 Jan 2026 14:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 460796B0343
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:35:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED2D41B0D4C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:35:55 +0000 (UTC)
X-FDA: 84360605070.19.488F4EE
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id E15BC2000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:35:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cIGpUWe0;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyEozQAGUN8eF/HmAuTFVwwVCihu7gPto1FFI8JxTmg=;
	b=tWQ5xcAZ+K1e/PKQOrvysdbMwECZK8AqBxEFosKD1WB/Yng0rxL4TyY41Eufrr3iz4+nZE
	sQREi0X2UV52gpYiwir/ak8S+AGtGIP4doMqZw1ooeTKmFHifV6fyTybOCt2N/QgVV73zp
	a2fJw9iKKipQBk+EdkAhnr+B0QZAvJ4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cIGpUWe0;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769110554; a=rsa-sha256;
	cv=pass;
	b=1rsO6BZmf72utjVgA2xviJLiXcemp3pGzCNNUF3rLs2uRlTPANZzKA1OemwlZzmXCGksbh
	FNdwodb29U8A0bDBifSe8s8fOn2ZBx8rm3ccpbOayWKVXMYDyuYf83JRQaRn3XK/6vaNat
	QPAFgaV2RswuGF8QL+5SQudMr01nKSo=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so2366023a12.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:35:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769110552; cv=none;
        d=google.com; s=arc-20240605;
        b=VWpEr4jRQ2f9alA/9GhOpyViJYaR+XHmZ3BDRjCtHdbAGnhHXTX5KYLCrGJt2rCdcM
         4OVVoR/WsmlU0rW/E75Shl3Rt43kbMgJFlWgZE4RtyZqcgz3NCAT+ukt2Fa/O7rOIzia
         ymsF5JFm7baNCT5VHbswI0nKpPIEDQlUE9kKeRsIiWmUL5o1vRVTQAZFEaavjDArQT7y
         6RufjeiYspyzkvL6x7EOBkyWdeY4ypG/O0m6lLvjfEeBsYE0zF1DBfSUB+pYpTxJaL88
         ykMtpofZZCG8ApRh1wDgPAGZ9ryEJet42rbvxc22wJFj9zG2P+8jjshxSuEu5dud43Vl
         rKZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gyEozQAGUN8eF/HmAuTFVwwVCihu7gPto1FFI8JxTmg=;
        fh=POq8VgvPPwK5lYty/6EXdAUFvi5z17A7i+5Xgaz5tnA=;
        b=WmSDM3TeINhs9NtcH0V/Fd8rXoxl7lC6yUeqCv2XwbmU7xKwB9TztlMjx8JMmPyceW
         DrmuY84gKaWtWS11h/r0fD+KPfd83yQ/z3CZQW6GN5dflh8kIQFw4CBE8RZ6ZBrBvepO
         AZs63bUYiWYPv7BZN2lPQMMsd3xbHQiPBC89pedvS883wTvJzK1g+agvNKPc6z00+hrR
         dEd9LMDUospCGKBv2QTIIqYbg0ajYY6m146lNv08RNuka6047QSFDc5PKisueEfVVN8P
         oAPwq64efj0VZ3Jc+0IAfoHlnAmAN347BfRwJDhDcfsInehuMHLamkOsnwVqm4WswS0p
         ygPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769110552; x=1769715352; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gyEozQAGUN8eF/HmAuTFVwwVCihu7gPto1FFI8JxTmg=;
        b=cIGpUWe0Cqz1XP5I4I5UuwPsFkSV63JI8TS4v1w7+s6VErqz/SI5D444jEEsCLl9hW
         dukTC84Il72uPaQBH9WtChOJaWMijGyORM3Xo8EV4ppAK7fqRdYAnaZPmhDJu+Ykd0X3
         kW8k29BuD1gYmgZs50Hw6m/oih3FIckKN+THvMoxykPlGFKl1QLi5n8Jbwi14fW96HjF
         VCUHfbYsM0TNXgeewaXaePJugP7e/WpIY9k3HVVjVVoLZpB6Dsqv9XyTTpdFn4GMWAU2
         gFnC6qfxi7S0G1Su4MbRXn8SaX4Ndo5W1IfuDbCJy2kYrG4n5vnumY+GZBJO5klclyHf
         ak+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769110552; x=1769715352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gyEozQAGUN8eF/HmAuTFVwwVCihu7gPto1FFI8JxTmg=;
        b=InssWtwTkgBPAw1v5K5d5zZ6onyrD9qE58kRBmTx/22mgvEdTSOMa6H93G1UlHbKyY
         WVDrUfisaUSYojHBcQadPHjPtM7J8nT17hsf++vkhc9/gxB+Zvuy7zO0pqskJvvwjmlB
         qcpmnhnj/CAbs7A125hZkvk8ibfNMquDWbugNo0udQUiLOj1a7fd/T0XWZzDO47IYOo5
         Vid7De0iILANWGFxFcY8DaHVB5+uwmzS+CX3KCTiutS15YbK70mx3JEpXfNKPiTm4Tn8
         HFg8KUrY/FctPXC0uq8XlOtTGTT5T6F8Jn6SG4PQHHDjyTxhJ74SQla6D6OIYeBR7E0s
         ai/g==
X-Forwarded-Encrypted: i=1; AJvYcCWQR0R4IIA6B1wVtiFROrsXphY++0Q4mJURSTbOA6fjHDUK9B6SN7DE7KIew7yeYiUb22L3ijR2Gg==@kvack.org
X-Gm-Message-State: AOJu0Yz+bOdbl1Zq1tFzZY9qEAQ9m6yyFxJ2VmmOv9/+kM1/DaKjdNPd
	fyPrwZ0fb8wr18wHHZLTIoxMxhMvhLyj/KPbILimy0Of5CL4W47vFig9Sg4sZBBZTDbAF+L7j31
	4ccA2/WvGgkCRR/h0SWnH2HCfWmXh4wmphqFdLkZU/Q==
X-Gm-Gg: AZuq6aIiG2h39FSJH+qq54xt6oqVW39R6j4kNbZIKoBY/VFPVvHghP+3H7xQVBB7KVg
	0rRgJu5QAhUZVMxjuJDjo8I466AxKhGaWjAEGfnfINlq/fOulL773bfEDY26foVZLljLxeSi+Rt
	yqmXQM3sOvkzz9WSphTkRtYkmSbIv1MKncVNTblUDY9bCq3EUUASHwQcYl9r53aN3yb3sksKavp
	AcSpbjDqoB2muPnkFtZlFXorsTzX3JhmGDC7x182vr/m7AKwOLG5FjoU2T3ekJNGuVvN04Eldgu
	lAK62SgOLPI0NRn9SegLP9M8FA==
X-Received: by 2002:a05:6402:3491:b0:64d:1762:9be3 with SMTP id
 4fb4d7f45d1cf-65848762657mr439621a12.8.1769110552424; Thu, 22 Jan 2026
 11:35:52 -0800 (PST)
MIME-Version: 1.0
References: <20260116165416.1262531-1-pratyush@kernel.org>
In-Reply-To: <20260116165416.1262531-1-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 14:35:15 -0500
X-Gm-Features: AZwV_QhXxubGRdqSX0oxMXkz26trejH0_IxVvQl1zrw9g2D_bxj_PjBh-rntby4
Message-ID: <CA+CK2bAG0byyZ0CF+jHq2m8bAMq2ACxtGrtQV2XvP8i=UH04Sg@mail.gmail.com>
Subject: Re: [PATCH] kho: print which scratch buffer failed to be reserved
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, Jason Miu <jasonmiu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E15BC2000D
X-Stat-Signature: ipknmj4yceqzacjgnypinw35mcg9jni9
X-Rspam-User: 
X-HE-Tag: 1769110553-755421
X-HE-Meta: U2FsdGVkX1+YMHYQZx9YQrv8SRMb3NAhw+hkR/uHTrAN8sOD+z/brtBMs7L1O+04Hz54ZkTWyHvrQvnwCPDesoT7iwfvx3lnL7X34wZQoQVsmkp1iujXWYB9iJGfMxaO91oxns3ESLupgsLvHOQGOrdbPwlJUqAVaiNuc6+Kz+MRpgfYj4xXNP9dFiTGh+MGRYJ8lfPQDY++AJIoMoPc478wlaNba7L7vtxHHDUkBYH3yyE4oMP/7ZvIESIlqbxPBevfVJswAzGxlbS7Eb+wPm7HT94Q5X06sb4O1m5dtTNlpFoj2nnjbfZ4UajCxd74OsMF/6TehST3if9V5yHfO1XMfd8xaD+U4BlkUVZZh5z6gjnp9zxAOmNPtoP9nkqtvyR6k6yVU6NXNN0iOrCYaYWYOjjBum+6+DMhCe/VxBYextRbdNv73nLxTxLbOToxTW3XkwtMnFnyTFlV421kI+sg/K5gdhRrF3UBhFasPOJV5azTF8bTSOaliy+Y1cgtmO1CpFIqNmRbp3A8LGD9X5eNGvDmPcHyldcw9uUZBRWlHtipMHhI7IJPcufYbAQKaN1RyqZB3PU2zz9JQa0eLgzVRTEo7hh/AKIfRJj4fjiOvrnSZqN3s6b4FjMOIC91jiTvMQr0C2KN2DDBjZepVTA/YyJxga+JZ5DNpTQYRHUKgKFQvcGgbfI1OaRjgD0fvm0Nn7BQZo7YqAzqmDVmfNKXvNE6k5IVfG0d805RTpCb5I7EYJqV8F2TU9pa1Dvt3r0MOvTiZuk7GhQN/nshJ+ll2nCG9oQjoF5MPZdI4CTw0VS+XBGymmg7Zr8hyUKEy4WVRaeg5Gm/FONge5yrQORfuTL+7GgScT3ILnreVRldX2a93dKULGHC8aik4CO8mK7b6NGAz78f/Kdqszd1Nro6GruYI5xxcG0nI4QYkndOxmeNrCTbb/2KtHGqeSDdiVurbcUUPg3Zz3l+oPt
 XBozmAiz
 8O9lAJC6v/ro7vTSASyVbFH2CPli/t7PYcpRnqwae9Oxt8J/Fz9fHl9gR4XMwBBqz0oOID8y6q7CLhWa/K0x9H0L/+JW/ucWUWU8aqvN3erdIoikhrSgcCiYT21LfFzIliJ5bqEsSTQO4CxPx5WdFW20gWUrqEPmLbNhD9ry6cLQd+W/Wr8vttSnCMalyhdQr4F3Hr1bpzF+PLg52jHaSJpvuOJf97g7ab7H2EAU0FadLKuFuiHz9UcGhcFikHavC3QFsBwD7mY2BOwjKuZcu+8LJNiT/JKUlJzhrPZdmMAk/gI6/6Un3JyyhH4pAco3Kckzd7KyBZ5EIgZ0mF6WqDIwsAvt4kAFvuztwfw4jbWD2DtHhw1Jq75tWLgHPNj1yb5Y56Uk8FdR6TO7qA/a5bzD/lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 11:54=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> When scratch area fails to reserve, KHO prints a message indicating
> that. But it doesn't say which scratch failed to allocate. This can be
> useful information for debugging. Even more so when the failure is hard
> to reproduce.
>
> Along with the current message, also print which exact scratch area
> failed to be reserved.
>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

