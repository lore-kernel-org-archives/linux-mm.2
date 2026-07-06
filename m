Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20775C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D844E6B00B8; Mon,  6 Jul 2026 13:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B546B00BA; Mon,  6 Jul 2026 13:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71986B00BC; Mon,  6 Jul 2026 13:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3D736B00B8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:58:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 282CF166E9F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:58:13 +0000 (UTC)
X-FDA: 84959110866.24.71B5993
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EF8080003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:58:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TRiOTbRj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvqCZpW6ehW5/EAJOze59do9erFs6tHYQwa81Plq9ms=;
	b=ivHajWgDHsgGz1ipbVaw/5ln06qSFVGwd+QsVRCpz3cYiei8PB7/MUI5Y9ZCO1PtBa4uxk
	MJi5Ili9TjSxVl3grG5ib0nSl7fItAtUJCs8DDYbNtGDsDC6KVoEqp2Ye3dTSsj8rZJpDa
	Cx41mb2/5rKOf0ozPk1/zmoRd/Om5zg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TRiOTbRj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360691;
	b=xbO21H75vWtU8XDBed7Jyy8jQMke6jHSY0T8pcb/RQL9dNyq99o9y9D+TiXGbC0r/UMv6U
	SuZStLAmj59kQcr3IVwdC4kS5MMJjpsyAnVz8ZINQ6Kga9ME2wK+7tL6I4WWGRGl24jt7W
	r9BcsPssh3XCZ9mpzmiS1N8mTH2Swxk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43B744174A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E781F00A3A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783360690;
	bh=zvqCZpW6ehW5/EAJOze59do9erFs6tHYQwa81Plq9ms=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TRiOTbRjpDFDduGaHwmPG6rKQcyx1kTwRnhyWDlKHv/FSu62ZJs+QD9f74i4ZaGmJ
	 CYz0MDPeszLHVPiBeqkGcFKDSimazLJAA1DqBJ5Z6RR5X/nF2JFlofX0KQbEqWCEG0
	 tgZFDA1W6LQleyM3YD6Gpe80gJhr+HiVSCU8ZlEMALmcTzccIH07acANXHiow4udaR
	 xwJkMeMPTBT0r460KggN6mvrw79q3eFrXWD+G18nrernKHHGwVsciU8OMnYt45iLgd
	 EowwnOq9O+Ue+OpX0QlfauzCb/k3j8oRd+YB3IBUUNnaXkWFAXZgiaCtQMyvynrZA/
	 ZL8KtzXyJMxsg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aeb11c7347so2493750e87.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:58:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqOIryuRvCcPsvEyD6oxI+tCDcE7UWn9EJrIJG/8sWCe6B553N+KKx5aixunlg4cR/825bGYsfCew==@kvack.org
X-Gm-Message-State: AOJu0YwhN+urryWY3zkeCLaAfeUoxj9GVSt98TcQfzCrCpfOc3GcyPSI
	crFsysv8fx3LwfGqbMT5dcoLMJXV8jG+UZe0w1nlsKvppdFYf+lT7cpUZLlCIJ2dxeVCccsEwXw
	jEDbimOX++Q1yolA/I25A4cAXOH3Gqns=
X-Received: by 2002:a05:6512:1548:b0:5ae:bd1f:c835 with SMTP id
 2adb3069b0e04-5b007b77aa1mr261552e87.16.1783360688610; Mon, 06 Jul 2026
 10:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260703041329.2797584-1-ekffu200098@gmail.com> <20260703041329.2797584-3-ekffu200098@gmail.com>
In-Reply-To: <20260703041329.2797584-3-ekffu200098@gmail.com>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Mon, 6 Jul 2026 19:57:55 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0iq+SjMvFVwsfwh0Zyp+h5MUJ7eeejQAOir8ssSu7yO3Q@mail.gmail.com>
X-Gm-Features: AVVi8Cer-fCztyBRN_23Y60i679-KEiFZuAbrTyLd-3-YzEE4LLFETmiJwjEoQQ
Message-ID: <CAJZ5v0iq+SjMvFVwsfwh0Zyp+h5MUJ7eeejQAOir8ssSu7yO3Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] ACPI: NUMA: remove redundant numa_nodes_parsed node_set()
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, 
	"Rafael J. Wysocki" <rafael@kernel.org>, linux-mm@kvack.org, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Danilo Krummrich <dakr@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Huacai Chen <chenhuacai@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3EF8080003
X-Stat-Signature: u49wnydnqfhuktoofqqxym86ruieagnd
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783360691-866838
X-HE-Meta: U2FsdGVkX18Zc8YBTwt8r/MDRq8TUqXNGKNCBrcEVbk8gD90CRP2B2aZUV6Vzx/7CVV/BKentna+YheG8zYC7k+UnBenSfCeF1Pw/UNU5Q2JEPPMqurpXht4lMvhRwQxi1kDcpwX9LZUDirMLhxw+TXi6nws7hdBr6qqrqeVXqWhAVH/nhJFwMshu7iyBhGlc0K0gsuGe2MzrQNzRyz3QhLaUI2SAEnv1hgUP+c4OHg6G4smqGDgKw5E5p6Uz6eqpeCJNEmLz4p3rlwOvLif7rOYMzvUM4QKoZSvIcfIiVQGLw/MxkchS18Ud6dUb0TYaxj+QhpZw7gDZIIRpYa1YElZ4gXvhlaKdPewXepDr+/VhoXYFP5Gk2IOcH6cSW/ZH16/OynSkZE5ifOrFuCjlYDnlEQKYXN1rXBT1S6JVjul3i98NY+FZD/Ns+bWP+reNKcpL9cbANjGII41o+jHpbFL5rELGbag/9L5yZXZrW1kUsNffiRXTybIpkwJZZs/oqwKKFGnLcT3UnbJWYt18nYunFVX2MivmHnP+zWbtsQ3pUazIVu9SecZgh0GELSLDG3Gm8zpyPf9sG4OnYVjPx27h1EeFG8IP0p7obno/H24zh78W7hlZ9obrNaA6pjqFW2gr/fwhJyANF3ViY/GVSGwPtZgIvTauNEosJ6W7RpS4oWjyLl/c8zLrBicseVBuqDpuLQbHqpIC6N3SkhtGs4dD1imG5zco5gMmJ6s1O9Mt/93It+ONPWGOzoOvNSrv/naAt0QsLdoT8stBbIaIUWVGE1OOtCBqjcfm6PmNkupZ2sIgdLKQCcQUgaXJ210uXkWMD9DUlDsRZmVGVnxt1rFv0teLi2XsNzU/zANQNkx3Bo2MiOw3mkfpxjUNZnKG5Nw+cpbYCLb6YXkahC9macrotxHj7tSIg/3Hp2cACKzKUYqMq3MmHYX0LxmHl0LhIXEqNpWmn9YqVerNoY
 poZ5/a+W
 4MTlG6Qcxkq0RveLzJoIk4HrvK/VIpgTpLmV8q96obGq66Elru6KYmLEdKomxoJLz1Vvd2BCbMM5MVdUUIWRY2r1XVX1PxG1x6ozEjF39jMtFT0sbAoE4tcGUjzJF2O2tzn/Fivo6opx/3tzIANaXvd1KGF4ZU1QP9ti/EVHffKYtGJlTJ4KgxTAE0kUPl5Mv4bnreoGpdw4j7VK3NT/i88oC1Cv1WJ2+AHmUGeAS3Dqu/QhYG48qvS2o7YOHCa518uqV2OPAan7nnjc0khl7WAJfaKGV/umpXkJSVUrEx14mP66i7hcJ3+Xb+gcyUeqPRQ2Oj5mpFlRxOaKkGMCw0/mRbpW5AA7BdqNI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 3, 2026 at 6:14=E2=80=AFAM Sang-Heon Jeon <ekffu200098@gmail.co=
m> wrote:
>
> numa_add_memblk() now sets the node in numa_nodes_parsed itself, so the
> caller's own node_set() is redundant.  Remove it.
>
> No functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  drivers/acpi/numa/srat.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
> index 62d4a8df0b8c..5c407dc6401e 100644
> --- a/drivers/acpi/numa/srat.c
> +++ b/drivers/acpi/numa/srat.c
> @@ -399,8 +399,6 @@ acpi_parse_memory_affinity(union acpi_subtable_header=
s *header,
>                 goto out_err_bad_srat;
>         }
>
> -       node_set(node, numa_nodes_parsed);
> -
>         pr_info("SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]%s%s\n",
>                 node, pxm,
>                 (unsigned long long) start, (unsigned long long) end - 1,
> --

Applied as 7.3 material, thanks!

