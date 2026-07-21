Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65175C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393216B00B2; Tue, 21 Jul 2026 04:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344996B00B3; Tue, 21 Jul 2026 04:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2818A6B00B6; Tue, 21 Jul 2026 04:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F35316B00B2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:46:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7832314037A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:46:07 +0000 (UTC)
X-FDA: 85012151574.12.EEEE837
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B4C3140005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:46:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F9/Tvggz";
	spf=pass (imf23.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784623565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aazLvrJiWJRW58wrSJTjUMB6XPzwgGNcRmu586sTy+E=;
	b=EacrpAzaj5OfyCvaKkSJvZMCdmxrKwkAcpI5gYZES+epM/usdj8jGRx2l3rfMExvACLKwY
	Xndx7fjLdDamPQx9Uxtbx623Vf6+ep0g8X7NLvi+JdGMPnG78RfbuexKDBG6Saa8QWJPAp
	joGom+esmlKlEoSBk+8+sO0HKpKzMnA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784623565;
	b=0jOzATyLzjpea4GpI3Hm7EoV/9qkgJyRXuIRC9cEGo7A6y6t6X7tpydbIRyrGH7zNRv8bV
	fODiUTwK+jIO2vivCFmg3reOSVfX7qV454S7+HEAg5gu7F/K+GnVSJ91XGdxGoIsqsYc+2
	ZuIaLnS9sBbfVUk5Dh/PEl+sWErlqfE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F9/Tvggz";
	spf=pass (imf23.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C293C4502C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49EB1F01560
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784623564;
	bh=aazLvrJiWJRW58wrSJTjUMB6XPzwgGNcRmu586sTy+E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=F9/TvggzHdbMV1ECyxyDqSQZOP5aSLkK5MPHgepKCOrVavyvZocUcpvNb2KZN2NBS
	 DEJnIVadcH8eSS4aqvRumoehJAS/Dsw69JeCuUVQu+PgHYaJnq+o936WI+UT4TZJIo
	 H9/fpaIyA1toK58xni0lqDfXM/HxL2HNHdisdvXsPufRqbDRdeDa2zt0h/W4x3X+PN
	 dl4AYmvKuC+gVQZll9K9MmiPr1MdDTZtp4M+RcBr71Pef/HGfldK1sYg8DK6nwSBGm
	 1u4WaLTLIt+tw1GZkUb/kxBzx4wsqztBCQC+uGxJmPSLhN7TgrQR7UxOG/2Mppihj0
	 IGGL4qfzkSIhw==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b0231a3e86so10658647e87.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:46:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RraUdcfRAL2mtwmNqygX92XPZ0GuZ1cC/+VBzUWQgAp3phTgAY25QB6qPE0blKVBWdFIMTBrApeow==@kvack.org
X-Gm-Message-State: AOJu0YyXIieGgGbv1ZLP/eFugs5BaNVaIE8HbskFxtddSve/WZfgTTDT
	4U+YO+U155zoJrIpu0XuzNMRVFt+f6+TtFVuwN+dKdblVoAmDxM1HUVd1mfiK3uPbbD8kmt5pBF
	Y2TqIka15N6/IccoFTiCs8IkHHyR94w4=
X-Received: by 2002:a05:6512:3f03:b0:5b0:e15:772e with SMTP id
 2adb3069b0e04-5b28f9bd387mr3910772e87.51.1784623563410; Tue, 21 Jul 2026
 01:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260721081858.1169276-1-ruanjinjie@huawei.com> <20260721081858.1169276-9-ruanjinjie@huawei.com>
In-Reply-To: <20260721081858.1169276-9-ruanjinjie@huawei.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 21 Jul 2026 10:45:50 +0200
X-Gmail-Original-Message-ID: <CAD++jLmftgEgQkdK9agx=Oo3ztkjdxMn3REQGbt4u1vha4Ea4A@mail.gmail.com>
X-Gm-Features: AUfX_myHwHg9se1-ZQFcWZG3sL_s90uXKcSONrAIfNoOMmyaOEKF4pzTzKp3_V8
Message-ID: <CAD++jLmftgEgQkdK9agx=Oo3ztkjdxMn3REQGbt4u1vha4Ea4A@mail.gmail.com>
Subject: Re: [PATCH v17 08/15] arm64: ptrace: Extract arm64_syscall_exit_to_user_mode_work()
 helper
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kees@kernel.org, oleg@redhat.com, 
	luto@amacapital.net, wad@chromium.org, thuth@redhat.com, peterz@infradead.org, 
	mark.rutland@arm.com, ada.coupriediaz@arm.com, kevin.brodsky@arm.com, 
	yeoreum.yun@arm.com, anshuman.khandual@arm.com, james.morse@arm.com, 
	tglx@kernel.org, broonie@kernel.org, pengcan@kylinos.cn, ryan.roberts@arm.com, 
	liqiang01@kylinos.cn, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9B4C3140005
X-Stat-Signature: 6sbzkimaw4tx3h4itygade35osra5u5k
X-Rspam-User: 
X-HE-Tag: 1784623565-983501
X-HE-Meta: U2FsdGVkX183v8fuAkSTgcWMrUYgaNl9OPA+QGTtFqDhPcVcYxZN8YCr1Ed+HRSclSLBGzoasXBdIqlWyZE/hSt99o/+IDQBnN0rdSjLzCRQUnAuqKTmi1MJkP4I652AHr1BQ85Yx9m2uySSHLQPN+F47bEFozSloHzNSe3Yzt7URnsxVgtnY4zfn2Wa8bjr3u03xhwNmI+vXm+asB6wWPkuOrHFHEwa/w0h7okB/CY3PDx2o+5wx80gyT0ph3MSGYBGgGAnII9WvhfXwY8/++J5qwIm9QVQNap2i7Ff2z7+hs3yhpzHAKcgd6u0+N/IIM89MrVUfJBGGeE+CTsi7/JhSQVpHNBZ841DWO3QCkC+P3KhjVON2iTncl6+/SmgEj5LFnjnLd5YpeW4nldXO03JwzwfEimvmGQlTakWcadBrt0qjBr3/hTiaR7LVewNq78ovys7reGTXn3meGVBHlz+7WUgwOPdOn7SB30MCcKKb8BbRGtJYSdvypC1+Em+AHzXIAlKzm53rImpPPpj0P8IqB9UXZCRDUTkYekuEL+K4ihQKSg5Ln3tPglrxiw4ItNTK0zsiBZqZmEGlo1cl8Kkkv5JZR4WRMbFKDb+AxcIcJNsgAhzawoHQw9Cm6MTbOD55wXBZLE91wyk7ZDPblLnfcsGpOkB5aUxID4kkp1au6CQ9g1IDViNlC2mBGRi5OI8CeJjCegtyl30BUGLEvedOWLKazFUfuB74Lr2pXfrPrHSEXZLcMVQCiEO3D5oFVQ0rSOK7GBayhFPbXjNZvtWNnRTd3mzQ5fHyD4NmdAAc7qT1jBNC1NXFbZ4kmgErXJ2CGxFM75bGJf7ZaVtxgvkRJmBhKMk3I3km0T0WrGjPgsd3vMvxYkWfLtVU4OmCxJ+kJoRmodLUB9RWsyPdCqr8Qhwq1vdLT+N5P56EBjc8UqWIL17ssOo5NZDz73RGmA0z/0Umm7+6yrMeLX
 JgOxFY/4
 ncjA57AsPSbypDJa2Udch8htozRtStTU8MWdXD9WWwIF/YzPLHiF1axgJEV8sLZr2g+IaiNHh89TM706HfOJf5lmMPGLmAHU/KYkPFp4zrPsV7MfjlCHAquWqjeIZGaj6M/1tHUmgiak+2rw8AhRRka0sv0tYrHqhCm9EhKwTWJoCq5yl1ly9i7lH1A6lyINiOCb6RYggCR4EFX0KY+B6wuBGxLLOPnfIi5JWZE6ELbCUTj2dH/1jBvck0UbewcuDjKvnMg8jP/ICYvQTFR/RlqSDNVdIi0QTIYNHQfZ7S0/2gpo3VihAlg0fjI6e56BDu1msdIALHpw8Olcf4najV3eX/bsTMprvO06w8OJNTsJ2u6I3ihzgNYpfag/P04dzuGntTwUk79qdPcaotcjjK+FG98S9Ef5f33MpfNeuUlJtqzBEp3CHDd+lxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:19=E2=80=AFAM Jinjie Ruan <ruanjinjie@huawei.com=
> wrote:

> Introduce a helper arm64_syscall_exit_to_user_mode_work() that
> encapsulates the re-reading of thread flags and the call to
> syscall_trace_exit().  Use it in el0_svc_common() to replace
> the open-coded instances, removing the duplicated flags read
> and making the control flow simpler.
>
> This aligns the arm64 exit path with the pattern expected by the
> generic entry infrastructure, which uses a similar
> syscall_exit_to_user_mode_work() callback.
>
> No functional changes intended; this is a preparation step for converting
> arm64 to the generic entry infrastructure.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Looks right to me!
Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

